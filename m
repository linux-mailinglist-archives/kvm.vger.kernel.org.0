Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAD631A944
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhBMBG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBMBGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:06:51 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDF3C06178B
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:35 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u1so1571849ybu.14
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=73lpx2Ds4nvqlzfYC2U6+DFk/lea8weqXjZsX+2GDyw=;
        b=ZDEE5RwcuHsoiD9G5EqwUruq+RUMompkf0icwCSbTaWazBwSSHjqycoQCAQUig6JLX
         lHd3cdDCINo6JFi1t5kIOHGkAxPe6n8heWpOf0Ar6QcF8qMXBOL71MwmuetIXFBVFnxn
         SbiskeSOPJEnaOptYYoSvcU3z3gpCYudseikfY3B4PJKvwcHkoGMrSQGe+K1H1n7qfIB
         j49CpM/z76XiG1+XIeCmImVT0EiOlpattwYI8+xiYMLDbl7WGItmSNxSTQNUqdXn6OQK
         GTdd7T1xDhN/qy36dCXlrM92c6D1WIFlGM76b9o0y4UdT5g0bTdQXly9HvLrccpw14n+
         EbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=73lpx2Ds4nvqlzfYC2U6+DFk/lea8weqXjZsX+2GDyw=;
        b=WBrps1i6OxghbeTY3Wn+0nAD7fNdY4F2sDtUtgMOQ3EyI98FtNzRrnybXPUQlctEKu
         P0P5U9wWEuVCdLyKp/kLyfZZHaUd7Bpt8alfxEZ6vU4jnjkvQoWcc1F9EUQDRV2GPGmE
         x6YW2AYuAyUEByufD2e2VrZP3dLDQC5PUou8SrFjpQwg7Ir7Yij5faoSL6hVtCMwWrmR
         ji1dWCxf/Netvk1bHuFDt13c0JinORYBVcgaB4CIgrdSZ1t/Y95hFdIxSzo0QEHbglhV
         jK2k8ozN/R0DkLwHNjbIaS09+zqpqwlWNX7ORsGsurogJHbmGKXUFrZE8xK5Sv51KkIE
         Rjdw==
X-Gm-Message-State: AOAM533Jtng0rkosxohLzJNT56yBvx6xa2FagFz+BLv296Uq1TcfKrMb
        Tq4oucP9pOztCaTgGp2y8ZslZxJPnqc=
X-Google-Smtp-Source: ABdhPJx+0Cq+HxRVYT+4ftVIegCIMDnq/iMusdAIcSm4QHRvfpfrkJW7Brk6Ieo52y+3nWHY97ZniguMvIw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:da8d:: with SMTP id n135mr7603360ybf.13.1613178334460;
 Fri, 12 Feb 2021 17:05:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 17:05:12 -0800
In-Reply-To: <20210213010518.1682691-1-seanjc@google.com>
Message-Id: <20210213010518.1682691-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210213010518.1682691-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 3/9] KVM: SVM: Truncate GPR value for DR and CR accesses in
 !64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop bits 63:32 on loads/stores to/from DRs and CRs when the vCPU is not
in 64-bit mode.  The APM states bits 63:32 are dropped for both DRs and
CRs:

  In 64-bit mode, the operand size is fixed at 64 bits without the need
  for a REX prefix. In non-64-bit mode, the operand size is fixed at 32
  bits and the upper 32 bits of the destination are forced to 0.

Fixes: 7ff76d58a9dc ("KVM: SVM: enhance MOV CR intercept handler")
Fixes: cae3797a4639 ("KVM: SVM: enhance mov DR intercept handler")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 42d4710074a6..d077584d45ec 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2526,7 +2526,7 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2572,7 +2572,7 @@ static int cr_interception(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(&svm->vcpu, err);
@@ -2637,11 +2637,11 @@ static int dr_interception(struct vcpu_svm *svm)
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		err = kvm_set_dr(&svm->vcpu, dr, val);
 	} else {
 		kvm_get_dr(&svm->vcpu, dr, &val);
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 
 	return kvm_complete_insn_gp(&svm->vcpu, err);
-- 
2.30.0.478.g8a0d178c01-goog

