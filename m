Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97B59F20C
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiHXDbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbiHXDbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:31:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CAF83042
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:31:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l190-20020a6388c7000000b00429eadd0a58so6981820pgd.19
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=2uNZhNlygYfzqtsufi8grh7zfz/isIffnv0kaF6zjFw=;
        b=nvhkP1quL0nCRBfrxMLWjqyp/MZEExScs2NzyX9rCFcZOgEhFpmYcC/g99s0b6XqRA
         nGuR76qd67RN6PqoWyhI1pxj5tb9lZMmm5XY8shjy7EM67pdRQEt1cu4d2JvnB7ckkro
         RL4q45KEi5tCNh0kO0bgc1KefEVe0rbVa9EfeKP55GmIRcE2S9Wp848Ul2fPWaV63EoE
         iJ0BIcbvr9uC6cKcEOAE4C0KEkSZHCw5csPKhkhqWQgc1kG0m9BTHCHdMZ/wUKCNq1RT
         wHQZmcnD+6KJV+/NuKz2rJs3kPxkUXRT1Xi3O2uMN1NTxGv3NS3/zKOTDJX57aGdnczS
         apRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=2uNZhNlygYfzqtsufi8grh7zfz/isIffnv0kaF6zjFw=;
        b=IfjXfWDQhdgQuNTiBMWBaLenW7utLde/DJbPgpIQVf2rw6R9OHDfCtNAIMo7uMwapC
         qKo1203p2sC3BMeXIqT12PVPEWxQ5Yj+nNTI45APpdgN36th3WX+s3i7TpfYZyHmSMLI
         h849WEJcys+TvCr6GwdNAZ6TFEUyAVCA3b8G+Zfwv3ZejIPVlFscBkROO7/Y+BSHMdto
         YFEziJebrPWTNmDKm5SZtnEPWdCIc1YBOHX2dpwZ6r04pD2+lAQARtcyZWQk5jkB3Hoo
         9Cl/tFa/5arp79orXISy/W+uk217iq9ukJq6nu/imb/SUgKYzF5OFzQE1vqoeL4II/+8
         RsUw==
X-Gm-Message-State: ACgBeo3LX8IxezlHVYb+eTjGoGDLr5AVxOD032F49HyaabfCq9ZtfEso
        9Q6t/4Q9C6nqJzfu8Iv1D33ThCTYtvY=
X-Google-Smtp-Source: AA6agR4TQFp6F/x/VzAI7SFXRkCI9AJwEpueV0cQacS/3VkifY18ZPF87EIFebk2tUIH/i2uTHCN+oCv0D0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e94c:b0:171:3df0:c886 with SMTP id
 b12-20020a170902e94c00b001713df0c886mr27423263pll.39.1661311863609; Tue, 23
 Aug 2022 20:31:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:30:56 +0000
In-Reply-To: <20220824033057.3576315-1-seanjc@google.com>
Message-Id: <20220824033057.3576315-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220824033057.3576315-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 2/3] KVM: x86: Always enable legacy FP/SSE in allowed user XFEATURES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dr. David Alan Gilbert <dgilbert@redhat.com>

Allow FP and SSE state to be saved and restored via KVM_{G,SET}_XSAVE on
XSAVE-capable hosts even if their bits are not exposed to the guest via
XCR0.

Failing to allow FP+SSE first showed up as a QEMU live migration failure,
where migrating a VM from a pre-XSAVE host, e.g. Nehalem, to an XSAVE
host failed due to KVM rejecting KVM_SET_XSAVE.  However, the bug also
causes problems even when migrating between XSAVE-capable hosts as
KVM_GET_SAVE won't set any bits in user_xfeatures if XSAVE isn't exposed
to the guest, i.e. KVM will fail to actually migrate FP+SSE.

Because KVM_{G,S}ET_XSAVE are designed to allowing migrating between
hosts with and without XSAVE, KVM_GET_XSAVE on a non-XSAVE (by way of
fpu_copy_guest_fpstate_to_uabi()) always sets the FP+SSE bits in the
header so that KVM_SET_XSAVE will work even if the new host supports
XSAVE.

Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
bz: https://bugzilla.redhat.com/show_bug.cgi?id=2079311
Cc: stable@vger.kernel.org
Cc: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
[sean: add comment, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2e0f27ad736a..4c1c2c06e96b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -329,7 +329,13 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
+	/*
+	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
+	 * XSAVE/XCRO are not exposed to the guest, and even if XSAVE isn't
+	 * supported by the host.
+	 */
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0 |
+						       XFEATURE_MASK_FPSSE;
 
 	kvm_update_pv_runtime(vcpu);
 
-- 
2.37.1.595.g718a3a8f04-goog

