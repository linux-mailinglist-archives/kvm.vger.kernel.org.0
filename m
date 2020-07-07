Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740CB217B0B
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 00:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgGGWgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 18:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgGGWgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 18:36:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917E4C061755
        for <kvm@vger.kernel.org>; Tue,  7 Jul 2020 15:36:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m81so9918839ybf.6
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 15:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iKsgbuR1fTpH0ZFi8jGnta3z0+1/5i8qIQmX7R8d9a0=;
        b=ddIDDwSAU2FmdCY55ER7+sD8F6BhDGcqVPI60KX3UznCZ29r7IW1XseZe5ol29nDQW
         302TolJ+AgKBxnY7U5N88aBj3W/Z/F0D1xrkGG9mYobua4fcII+rryuhm/7YYBNVW9Xh
         6uNzqLk5um6Jdl6faPbiUMMg/BWJimJqJzSaAMbdaMXnCfigVQmd7EobfD4AWl3M8dWQ
         5K8uSNqHmo8wrIuUfvHuctdH6lBXY0meA2iZvyjSdavFj0l5mc2uXky2ZSM26YKpVygk
         PuduzEcwBJFD/wUs08tLFyRXcO66mhuocTS9FMFgZIXCFZ3bikm3Wa88qeYVkm1XDm70
         /l/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iKsgbuR1fTpH0ZFi8jGnta3z0+1/5i8qIQmX7R8d9a0=;
        b=piZmYvfMZZuRgcESG6d3v92WHIpE0ppZdIVj13WUYoM5sqyt0FYPtqHxEJ6qTyEfks
         r+6uswdS9ZpsDT4nlKqbGAWdm873X/gu/pp2rdMUK/W4swGBVc4UQBqfB9eZj6CGmlY6
         tok0tnava336vlQORelpOgghnWssOY63zLHy/EXSIRPeOGZiQm+eWRR4PjeXCLU6jwAC
         pr8riLX+egZq76SL6Ei6hnnKZgayxh0Rm0YePzcd9NbWP6OtEXhKYj7l5KfaBpzjI2kn
         sndYkdxjH42/tSQa2S0hV+WD+Qh0QdaCXbCDJufmRhRSNxTX9OBhmC8Z+flNnhMYOATQ
         mJJQ==
X-Gm-Message-State: AOAM531RCL3X9lL/z1wECBaXm8uAopU+ppx3f6Rfyl7/5jkZXLhGx5NW
        Hn7PB9x+l3VcHrNBRccLd/nV4kmix6yDBZwSAQDDt78brMSQ7ZrvU0pYK8MgY+jPUZsL0JLsxG0
        /bx09qf86kgmdUQXABAjHmXfORENVTiPf6P7kFRN7DsGY7Uy+49FnezxnRX9JF8A=
X-Google-Smtp-Source: ABdhPJyqGzXsogKiFMYP9vr5Cl6ht62P4lfONGd7FnWULuyATlBNwCEZCNwfy141caWCnZqnFQ2f0lYNHDY2OA==
X-Received: by 2002:a25:7582:: with SMTP id q124mr66565332ybc.208.1594161400577;
 Tue, 07 Jul 2020 15:36:40 -0700 (PDT)
Date:   Tue,  7 Jul 2020 15:36:30 -0700
Message-Id: <20200707223630.336700-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH] kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, when PAE paging would be in use following a
MOV-to-CR0 that modifies any of CR0.CD, CR0.NW, or CR0.PG, then the
PDPTEs are loaded from the address in CR3. Previously, kvm only loaded
the PDPTEs when PAE paging would be in use following a MOV-to-CR0 that
modified CR0.PG.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/x86.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..5a91c975487d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -775,6 +775,7 @@ EXPORT_SYMBOL_GPL(pdptrs_changed);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
 	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
 
 	cr0 |= X86_CR0_ET;
@@ -792,9 +793,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
 		return 1;
 
-	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
+	if (cr0 & X86_CR0_PG) {
 #ifdef CONFIG_X86_64
-		if ((vcpu->arch.efer & EFER_LME)) {
+		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
 			int cs_db, cs_l;
 
 			if (!is_pae(vcpu))
@@ -804,8 +805,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 				return 1;
 		} else
 #endif
-		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
-						 kvm_read_cr3(vcpu)))
+		if (is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
+		    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
 			return 1;
 	}
 
-- 
2.27.0.383.g050319c2ae-goog

