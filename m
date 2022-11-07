Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60DC61FB88
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiKGRgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiKGRg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:36:27 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4716E21E33
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:36:26 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 64so11073022pgc.5
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 09:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gq58p71OCZRt35pItCxZvZwXEFwO9+Zb8yr9Gn+0PNk=;
        b=K3wDrQzU0lkOt2BVdHY4QcXBLK80/FMNghlhn7+jBoEcXZUO98pFwFjJa8aPm3EgSr
         lY6t0gsDrWSXhX8WuS7EqJGzo/JgElfm7lWxXUc+42CEP+gwwkjSW+c9TNoOrma3BnTp
         k3y3WywnethziJX6pT5AGFdDnbJ8Dbt4nVsLgyO2Pn+XRzvoxyB+Xyyey0sJVcn6wqOK
         4gwhj66DRxdLIbdUqtyDizXjbMeaEB7KpoY7zmUUUajlFA3ycE5k0CGmAc1Ox/vSnsIZ
         fFy5ErzgerC3LAuhK5zdUD0yHLmWJS1LTZvLUgU+IKd1NiduBDzgb9v9/YTTM7G9PoeK
         7u9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gq58p71OCZRt35pItCxZvZwXEFwO9+Zb8yr9Gn+0PNk=;
        b=DdOZyQZ23TjbIglPQ5MTvS030+HRpjZFncIXsgG53b9fIQgUauumky0aaI1kvHqPP/
         cCkBEbJbU56Cz8Icd3ueb0Ph0HuqKvy4OuLtkpE71vb6IvURA/MlOsa8YkV+0FGvJ+07
         y8OOVwzdOeXQ4uSAY1lq7dHKYm7cCPo4lNWsB2iBbdR5Cx4+p8Z0aWMIWlqr9jM7Cjph
         JWh88wz/KWwucgGegeJcFaXlICSv1iRIPbm0lXJE5oqX6FeCncfNn4TcUSiACLqADagM
         sW1ancKDEiCvHeyVsbh+nIyRjoVQHRLRFCEmd2XuW/zQR81igstqmAUVTMT9TYEeWRnN
         +1wQ==
X-Gm-Message-State: ACrzQf073goIUNGdL0B7emFa7Ku/BgR/AeNxb3/NCMMBDmch0azTA1CE
        GFhDtjwtqcRULzRXa6i8K/RWhg==
X-Google-Smtp-Source: AMsMyM7cYRsugV897xl/VuHBggB96zDE4/VylwMMBycPArzVqgAR1ZrJVL/MTRBgPPXsi33DuzJIfg==
X-Received: by 2002:a05:6a00:4508:b0:56d:8afe:b7c1 with SMTP id cw8-20020a056a00450800b0056d8afeb7c1mr40069381pfb.29.1667842585648;
        Mon, 07 Nov 2022 09:36:25 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090a2a4a00b00200a85fa777sm6513109pjg.1.2022.11.07.09.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 09:36:25 -0800 (PST)
Date:   Mon, 7 Nov 2022 17:36:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
Message-ID: <Y2lCFUbAFnbzyKzO@google.com>
References: <20221107082727.1355797-1-yu.c.zhang@linux.intel.com>
 <c8f036f4-6ab1-efbe-dd60-b934c21cb21d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f036f4-6ab1-efbe-dd60-b934c21cb21d@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022, Paolo Bonzini wrote:
> On 11/7/22 09:27, Yu Zhang wrote:
> > VMFUNC is not supported for L1 guests, and executing VMFUNC in
> > L1 shall generate a #UD directly. Just disable it in secondary
> > proc-based execution control for L1, instead of intercepting it
> > and inject the #UD again.
> > 
> > Signed-off-by: Yu Zhang<yu.c.zhang@linux.intel.com>
> 
> Is this for TDX or similar?  The reason for a patch should be mentioned in
> the commit message.

It's just a cleanup, but (a) it should be split over two patches as disabling
VMFUNC for L1 is technically a functional change, where as the changes to
nested_vmx_setup_ctls_msrs() are pure cleanups, and (b) the !guest_mode path in
handle_vmfunc() should either be removed or turned into a KVM_BUG_ON().

E.g.

---
 arch/x86/kvm/vmx/nested.c | 11 ++---------
 arch/x86/kvm/vmx/vmx.c    |  7 ++++++-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c62352dda6a..fa4130361187 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5792,15 +5792,8 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12;
 	u32 function = kvm_rax_read(vcpu);
 
-	/*
-	 * VMFUNC is only supported for nested guests, but we always enable the
-	 * secondary control for simplicity; for non-nested mode, fake that we
-	 * didn't by injecting #UD.
-	 */
-	if (!is_guest_mode(vcpu)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
-	}
+	if (KVM_BUG_ON(!is_guest_mode(vcpu), vcpu->kvm))
+		return -EIO;
 
 	vmcs12 = get_vmcs12(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..5a66c3c16c2d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4487,6 +4487,12 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 
+	/*
+	 * KVM doesn't support VMFUNC for L1, but the control is set in KVM's
+	 * base configuration as KVM emulates VMFUNC[EPTP_SWITCHING] for L2.
+	 */
+	exec_control &= ~SECONDARY_EXEC_ENABLE_VMFUNC;
+
 	/* SECONDARY_EXEC_DESC is enabled/disabled on writes to CR4.UMIP,
 	 * in vmx_set_cr4.  */
 	exec_control &= ~SECONDARY_EXEC_DESC;
@@ -6004,7 +6010,6 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_RDSEED]                  = kvm_handle_invalid_op,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
-	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,

base-commit: 07341b10fcbd5a7ef18225e0e9a8a40d91e3a2cc
-- 


and then the pure cleanup that is made possible because KVM now does:

	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;

---
 arch/x86/kvm/vmx/nested.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fa4130361187..981bf5b3a319 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6801,6 +6801,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
+		SECONDARY_EXEC_ENABLE_VMFUNC |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
 		SECONDARY_EXEC_TSC_SCALING;
@@ -6832,18 +6833,13 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 				SECONDARY_EXEC_ENABLE_PML;
 			msrs->ept_caps |= VMX_EPT_AD_BIT;
 		}
-	}
 
-	if (cpu_has_vmx_vmfunc()) {
-		msrs->secondary_ctls_high |=
-			SECONDARY_EXEC_ENABLE_VMFUNC;
 		/*
-		 * Advertise EPTP switching unconditionally
-		 * since we emulate it
+		 * Advertise EPTP switching irrespective of hardware support,
+		 * KVM emulates it in software so long as VMFUNC is supported.
 		 */
-		if (enable_ept)
-			msrs->vmfunc_controls =
-				VMX_VMFUNC_EPTP_SWITCHING;
+		if (cpu_has_vmx_vmfunc())
+			msrs->vmfunc_controls = VMX_VMFUNC_EPTP_SWITCHING;
 	}
 
 	/*

base-commit: 777dde94dd5e4328b419dcc5cb7118b39588eab1
-- 

