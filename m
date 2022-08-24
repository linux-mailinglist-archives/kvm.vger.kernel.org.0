Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3719459F1BD
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiHXDEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiHXDDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8664C82849
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:15 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id bf3-20020a17090b0b0300b001fb29d80046so3061996pjb.0
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=mXQVHkQ6v/z3R2rrqlFzIt1GZQ5VuOrGi28wo/whobw=;
        b=Jo5r1bq7VX2AkDUII02B/joWx0VsKz5iVAHZjE66cK9vCR22WG2u3fb4qt8crbgCoy
         uFQPG0WhWr3WN8haW53izHAtwYdT5d0fbXZ0m7/BgHyBjkoZ1gOtq5Ow01qxEFdl78Vs
         gH4aFHe3hqg4NdSiK4VcoqDuu3PCkBCtAkHXavwiiGI9BBmoH+5hRaKS/4cQSSUTlVuk
         nT+G9azU61/+t1dlDbUx9p3LvAZ9M/tDLk9i1ODQ1oB2oGzDj4iZV+dAA6V7H4YdP8sO
         JjKgNtTiRX88x/3vcuvEJOk2Pgt132KglY6ZUGFfb2gBOWiFFqw9X14LLSanT47BS8eu
         TIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=mXQVHkQ6v/z3R2rrqlFzIt1GZQ5VuOrGi28wo/whobw=;
        b=EhAzPaj9VfRCVmjQ6Ey921V9cMe2onGlTR4tdxzgaAcExB3SdlaYqs2x4Vt/ZD2qbW
         BJzRT8Gbq4ojDuj5FHIucsO+4z0XKbNF7TlWMQzOWb0Tk5y01/opWT5o3LnVHgWliOT3
         vtreycDonPGM6maAjHgZQ6ULvHjUx+jH6E0oSRDgO6h+vlpwz1TUpkuf29s6sYwyw1k6
         RBiaoX93heiCTpMYyVnhgq4SiEqsMnYXn9BhywuJ7f5YDybo8zMqOymAQTUX/O4a6lHY
         9RfyEPKUxhOFYjM3RwjhXbcD+g3dnilg1BWmtPsXiUUmReb2/RYbVnNtq7Y4wqIz+uwj
         MvJw==
X-Gm-Message-State: ACgBeo3IHXxxjNUkA52OUU8Wvfl4OcayVLln6sKFRU7f1+2CxZG7cLzx
        O/ijVh0H8moAlBrnet/Yj6Z8BFsRinc=
X-Google-Smtp-Source: AA6agR6tS/A+xuaQsFEk2JjLrGnKlQjGrjwNqOLBcVrJyBRD4xWuBL8v2j9niZ5fRWsbcWcwJE6GuRy3FWM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:a14:b0:1fa:bc6e:e5e8 with SMTP id
 gg20-20020a17090b0a1400b001fabc6ee5e8mr151239pjb.1.1661310134907; Tue, 23 Aug
 2022 20:02:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:22 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 20/36] KVM: nVMX: Don't propagate vmcs12's
 PERF_GLOBAL_CTRL settings to vmcs02
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

Don't propagate vmcs12's VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL to vmcs02.
KVM doesn't disallow L1 from using VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
even when KVM itself doesn't use the control, e.g. due to the various
CPU errata that where the MSR can be corrupted on VM-Exit.

Preserve KVM's (vmcs01) setting to hopefully avoid having to toggle the
bit in vmcs02 at a later point.  E.g. if KVM is loading PERF_GLOBAL_CTRL
when running L1, then odds are good KVM will also load the MSR when
running L2.

Fixes: 8bf00a529967 ("KVM: VMX: add support for switching of PERF_GLOBAL_CTRL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 57e96f4ab765..eed7551dd63c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2368,9 +2368,14 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	 * are emulated by vmx_set_efer() in prepare_vmcs02(), but speculate
 	 * on the related bits (if supported by the CPU) in the hope that
 	 * we can avoid VMWrites during vmx_set_efer().
+	 *
+	 * Similarly, take vmcs01's PERF_GLOBAL_CTRL in the hope that if KVM is
+	 * loading PERF_GLOBAL_CTRL via the VMCS for L1, then KVM will want to
+	 * do the same for L2.
 	 */
 	exec_control = __vm_entry_controls_get(vmcs01);
-	exec_control |= vmcs12->vm_entry_controls;
+	exec_control |= (vmcs12->vm_entry_controls &
+			 ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 	exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
 	if (cpu_has_load_ia32_efer()) {
 		if (guest_efer & EFER_LMA)
-- 
2.37.1.595.g718a3a8f04-goog

