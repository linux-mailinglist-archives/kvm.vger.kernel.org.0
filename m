Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958BA6721A5
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjARPpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjARPpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:45:08 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126E302B3
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:45:06 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id r21so5188749plg.13
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yeOwkb15YsHX9dNg55dB8ZzXAkLncJGPCZFeKh6Ajlc=;
        b=DPaYAEJEmxUT/xXoX8u/F9T/zjjZ6WNOKaQAk/VkEdo87tK7TKKye+wW/RjJ33r1Vm
         PeYqmB4HWkJ4f7a9MoXlfrMJFtOMo66MZaAxGElDceJMiC43lz1L+xIS7HQ9Tw/EiN4f
         5Zn1JCun3JyYb7ZyzE6CjNH3vEsEdiwuMHHsnBVgt9XPmywxzLERh+BK4MWRuYOaaVys
         gRZRsvwDgqU5dXiiU0haT9xPjoUCjnkE7goIJ9xNDI4hUIcoq/dg604Mkt28Gxx7Hg/n
         F6O3efUwmoSAO5yeaIp6WSZqPimpjd3QG+cpIcseRrOubG2GqOZx0HvQGJj6q4r6g1hZ
         f4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeOwkb15YsHX9dNg55dB8ZzXAkLncJGPCZFeKh6Ajlc=;
        b=vrvgp4Qy/zI16oV/O7+JYKeTheHnMBEx3nPV4XTncWRzgonv0pCzbRcyD27Db85UFC
         5eLFZTHuOom5VomED7TCCOzKLrZvgvzWv29vxk9OKq1pZeulDhViP90fgkl6DAYbQlgn
         iXydT1dKa81ppmt3OaEnu3eK8/4HhjLpEHSYSVqcNbmy+N/sgvM9NP+1pfSTNWrJFArD
         yw4/w5dIbTkTyx0eSgV3y1FoiiPITkxtUBjOi1XlrnRwmmPQKZLYMOr8YvoKQCGbKXPw
         B4BNIK0MJdp4RUzcijhE7IwMndL1LEnYrPmFX70Go0dELzIBf3gvDUt7nz9vLfu6GoU4
         2TYQ==
X-Gm-Message-State: AFqh2kry9B8zYCWWu2VK4sNpauUfTNPwC74JArRlVQNWne2r0K06j74y
        /ojBPqLWvH+o81tO1Cl8zvVQrQ==
X-Google-Smtp-Source: AMrXdXukW2fa36O5aBB+p7uY+amXtsGxTNaBG/asiE3oYILziz9Z7GhXRGxJHq/4+lCEv56YVGm+kQ==
X-Received: by 2002:a17:90b:3941:b0:225:e761:6d2b with SMTP id oe1-20020a17090b394100b00225e7616d2bmr3111420pjb.1.1674056705768;
        Wed, 18 Jan 2023 07:45:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c2-20020a17090a558200b00229661c5650sm1468007pji.37.2023.01.18.07.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:45:04 -0800 (PST)
Date:   Wed, 18 Jan 2023 15:45:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
Message-ID: <Y8gT/DNwUvaDjfeW@google.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118141348.828-1-alexandru.matei@uipath.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023, Alexandru Matei wrote:
> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> that the msr bitmap was changed.
> 
> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
> function checks for current_vmcs if it is null but the check is
> insufficient because current_vmcs is not initialized. Because of this, the
> code might incorrectly write to the structure pointed by current_vmcs value
> left by another task. Preemption is not disabled so the current task can
> also be preempted and moved to another CPU while current_vmcs is accessed
> multiple times from evmcs_touch_msr_bitmap() which leads to crash.
> 
> To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
> before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
> after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
> initialized.

IMO, moving the calls is a band-aid and doesn't address the underlying bug.  I
don't see any reason why the Hyper-V code should use a per-cpu pointer in this
case.  It makes sense when replacing VMX sequences that operate on the VMCS, e.g.
VMREAD, VMWRITE, etc., but for operations that aren't direct replacements for VMX
instructions I think we should have a rule that Hyper-V isn't allowed to touch the
per-cpu pointer.

E.g. in this case it's trivial to pass down the target (completely untested).

Vitaly?


---
 arch/x86/kvm/vmx/hyperv.h | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index ab08a9b9ab7d..ad16b52766bb 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -250,13 +250,15 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
+static inline void evmcs_touch_msr_bitmap(struct vcpu_vmx *vmx)
 {
-	if (unlikely(!current_evmcs))
+	struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+	if (WARN_ON_ONCE(!evmcs))
 		return;
 
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
+	if (evmcs->hv_enlightenments_control.msr_bitmap)
+		evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
 }
 
@@ -280,7 +282,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
+static inline void evmcs_touch_msr_bitmap(struct vcpu_vmx *vmx) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..6ed6f52aad0c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3937,7 +3937,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * bitmap has changed.
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+		evmcs_touch_msr_bitmap(vmx);
 
 	vmx->nested.force_msr_bitmap_recalc = true;
 }

base-commit: 6e9a476ea49d43a27b42004cfd7283f128494d1d
-- 
