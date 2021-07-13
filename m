Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C323C74D3
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhGMQhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhGMQhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82DAC0613B6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q10-20020a056902150ab02905592911c932so27952341ybu.15
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Uj2yMP906hWJGI2naVvWw65tlAlIQnpXZj8DT6KTFYY=;
        b=BxKkSE4nzeAN82oc/h3WNbMOSRY3kLdlaT0lHNjn7J4r+J+n8aJkIo3ROQbdwAp/yH
         0ZINHZQZNXvGy2cM95myujd5l78dY2Tp1gB8s9W351mOgogMtBCeIUtqk1kBT5iXq0qD
         R9NRqcVKVpWgTxsU2jc9PhQejQngk8QL5FmFxA8zChtI0o/mFvRWRjqIhaUJq3/zmDvw
         K2jjCA7L3U+jh1vFCyx9Da+qHBAOKUAil5rAkUGPsAmCMaJnJP2BQe+sanJ0HRjV+nLj
         PMzoupGosc0XCIFqqcYrkAD0LHta7Xj18h701jf9TC+e+1whDLbXelZVJOLif7Zqym5i
         +H6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Uj2yMP906hWJGI2naVvWw65tlAlIQnpXZj8DT6KTFYY=;
        b=cuKphMpZKSUCSTPCUc45tyrLDn2khnhfqWu4jL+utX3+bxa5iyd/92GagoMbczPd5U
         tCcRHjkRRUC2t37JU3v6LrdMX/SBBbD/05R20xF35HxJ5BsqpBK59taQZAvDkkWOHgXL
         JMtyfwXgOk6az/3gqJcCD579NPm0q68fWpYTaxbO03he9ez+yWlbmeUl/4J+/9tq4mt2
         evuc0YM04yvzQugYTTrUpQCdnny2muotJmyUayJwyS91Chgsy3ozyY+xc8IjN227wUGC
         WBAoYcJ4pU/70Iwc5C41jXzTyDCuu+F0//gF81Lw2neq0vOESJffKAsH5RvsV20/xrbM
         jNIg==
X-Gm-Message-State: AOAM533YGYtkd5ymlHClrb3lWSThlfOtXpmbAe2ywkL89R55eCjYd/aa
        mdU4sPVfEo4/nbiGNn6i1Tg5dsfX8iM=
X-Google-Smtp-Source: ABdhPJyBu4WEipwbM+p875QlkcqwEMGe7LqGyGF0Q+kW0j9wqkKUWt9cLevGQ/uZA/fwiAZ3QM+IQGUEZ0Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a5b:303:: with SMTP id j3mr6439721ybp.433.1626194063094;
 Tue, 13 Jul 2021 09:34:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:04 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-27-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 26/46] KVM: x86/mmu: Skip the permission_fault() check on
 MMIO if CR0.PG=0
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the MMU permission_fault() check if paging is disabled when
verifying the cached MMIO GVA is usable.  The check is unnecessary and
can theoretically get a false positive since the MMU doesn't zero out
"permissions" or "pkru_mask" when guest paging is disabled.

The obvious alternative is to zero out all the bitmasks when configuring
nonpaging MMUs, but that's unnecessary work and doesn't align with the
MMU's general approach of doing as little as possible for flows that are
supposed to be unreachable.

This is nearly a nop as the false positive is nothing more than an
insignificant performance blip, and more or less limited to string MMIO
when L1 is running with paging disabled.  KVM doesn't cache MMIO if L2 is
active with nested TDP since the "GVA" is really an L2 GPA.  If L2 is
active without nested TDP, then paging can't be disabled as neither VMX
nor SVM allows entering the guest without paging of some form.

Jumping back to L1 with paging disabled, in that case direct_map is true
and so KVM will use CR2 as a GPA; the only time it doesn't is if the
fault from the emulator doesn't match or emulator_can_use_gpa(), and that
fails only on string MMIO and other instructions with multiple memory
operands.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd9026437fdd..6a11ec5d38ac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6557,9 +6557,9 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	 * there is no pkey in EPT page table for L1 guest or EPT
 	 * shadow page table for L2 guest.
 	 */
-	if (vcpu_match_mmio_gva(vcpu, gva)
-	    && !permission_fault(vcpu, vcpu->arch.walk_mmu,
-				 vcpu->arch.mmio_access, 0, access)) {
+	if (vcpu_match_mmio_gva(vcpu, gva) && (!is_paging(vcpu) ||
+	    !permission_fault(vcpu, vcpu->arch.walk_mmu,
+			      vcpu->arch.mmio_access, 0, access))) {
 		*gpa = vcpu->arch.mmio_gfn << PAGE_SHIFT |
 					(gva & (PAGE_SIZE - 1));
 		trace_vcpu_match_mmio(gva, *gpa, write, false);
-- 
2.32.0.93.g670b81a890-goog

