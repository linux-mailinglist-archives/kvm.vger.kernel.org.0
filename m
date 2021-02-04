Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A0C30E834
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhBDADB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhBDACw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:52 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA77EC061354
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:47 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p22so1500047ybc.18
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KVbXCJbK0fJijUMIx8v2OVwCZqQe15lsxZFi3EGecaw=;
        b=opyX1IcsdheLOecVRr/E17VB+hX2+bRSNpQU2AKEc75rEOAphJBR1E1zZy11OX5E8D
         MOTT02kX8RMf1rsG08QGYhs16gYkz9lFqyJk8+BOPm8+Fnsym4JEIPdCulxfA3/o6hOO
         Oy2BwhKqbLF9w41MIN6AzwhHKh5OEqYySOdgTcqIwdS7nUhb2tZxvHkSmShe3Gj8RluJ
         ZDJPPvN+CHnmO/xr0U1BwVrx5baf5SYStCy5+yecsF8hrnw7+COuLPAi8sNn4eAEp03b
         O1fv9qtQrbty3PKFo5Ou+01ZLLblZAEs/V/LxPfsw/fR3nl8V66vPOO4NSXle1B1I4La
         Ha2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KVbXCJbK0fJijUMIx8v2OVwCZqQe15lsxZFi3EGecaw=;
        b=RkSrds1r48idD/u+WePT5iMGK+HnqgyTfOtrVUVVuAGPI+j0CaDe9fQCEe9YBmuy0j
         rdGLUDERLd6h13Olm6owNWJ3XNgnrjc1L3zT7G10WuJUMteLhwcUdINdNdKrrGYMb+n7
         VODYI26syK06AsvV5KCo3lBJ0w4IcOZNwtYVot9BE05AynnPgli87mv/KayjDtxPWESi
         vWJlv3EPCYOQ3Beqlya3pH/jaG+Usxhrpvos07L6SuKDeABZnsS4ED/vlZ8Wt09CBx/d
         RQ7Au3SF3g3DdLLyuquX/T8pauMtk2WOs7rmUqdiPnpwlMLne171Zv5Rp79ug40Zx5iC
         2FTw==
X-Gm-Message-State: AOAM533mc+tJSL0LT+yKFdIlZc+5XVJHxfVUNjXolwgJI01Yatbsyd9h
        KC8sskG78SQIoeJL/hy6cc9+jhkpRHY=
X-Google-Smtp-Source: ABdhPJxipC1uw+bK0spQZBfo0QAzIqcG0dWoBMYMahZvik96ZGpn2SfwdWjogVk+rzl+XSv5RRPwRYioj3Q=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a25:a527:: with SMTP id h36mr8036454ybi.400.1612396907131;
 Wed, 03 Feb 2021 16:01:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:14 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 09/12] KVM: x86/mmu: Add helper to generate mask of reserved
 HPA bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to generate the mask of reserved PA bits in the host.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d462db3bc742..86af58294272 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4123,6 +4123,11 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
 				    vcpu->arch.reserved_gpa_bits, execonly);
 }
 
+static inline u64 reserved_hpa_bits(void)
+{
+	return rsvd_bits(shadow_phys_bits, 63);
+}
+
 /*
  * the page table on host is the shadow page table for the page
  * table in guest or amd nested guest, its mmu features completely
@@ -4142,7 +4147,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 	 */
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-				rsvd_bits(shadow_phys_bits, 63),
+				reserved_hpa_bits(),
 				context->shadow_root_level, uses_nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
 				is_pse(vcpu), true);
@@ -4179,14 +4184,13 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-					rsvd_bits(shadow_phys_bits, 63),
+					reserved_hpa_bits(),
 					context->shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					true, true);
 	else
 		__reset_rsvds_bits_mask_ept(shadow_zero_check,
-					    rsvd_bits(shadow_phys_bits, 63),
-					    false);
+					    reserved_hpa_bits(), false);
 
 	if (!shadow_me_mask)
 		return;
@@ -4206,7 +4210,7 @@ reset_ept_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 				struct kvm_mmu *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->shadow_zero_check,
-				    rsvd_bits(shadow_phys_bits, 63), execonly);
+				    reserved_hpa_bits(), execonly);
 }
 
 #define BYTE_MASK(access) \
-- 
2.30.0.365.g02bc693789-goog

