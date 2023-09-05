Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0365B793239
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 01:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbjIEXDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 19:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjIEXDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 19:03:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C4A191
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 16:03:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5704715480eso3380886a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 16:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693955018; x=1694559818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BOdaluftC7lLn3PP61IZ2OEQPOQs7eYrh55WlE2TqCs=;
        b=QA8f/NSreWvGi2JBk1vEi9hXjq/qElZxMMsXDylvp7s26kv7jjqfXqUoihcsaSzMFW
         Vg9GDItDGiJ9EoYnDbAVhYzavFyDhxAcZ8Ho/3l++ibELBpndCyMM8vNeu78ZFifBEB7
         wXuzbXLUl0RvNyYhMmKkXqJ+9Bq3V8JHAvVsHAUD+wyR/VvkJpCquFEzyHfcsIbHVNX8
         zmyWHJk/mHYHanx0FEifgK/EfSf+mpJLDTqLh/v3geALgsR8xLoFfEY7pPXbrdfvzUKW
         3Y0aslHhynNKfX9r8ZG/gHMkNXmMn/JL6Jxgynxs452AVFGJQ6EWEE6u8sKOS03rpgS9
         jZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693955018; x=1694559818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BOdaluftC7lLn3PP61IZ2OEQPOQs7eYrh55WlE2TqCs=;
        b=eXTD06y+BaHS74t/L/fYhue733LBFdwayqTFouI5jopanoKCreoxDzvuoM8pS/JgG3
         mpUCoqjPxF46Y4z/AQTC39tdnkTxaZQXneU6Rt/RfmAtzJwpQA9YYBKUucUFl2LkVMFq
         MQmWtwnmY6Jc02wty5gLQ2Nk+fcblIcXZMASGneD0LDQ4SDdiqmwpmeRidQCtOG9A8KG
         Ul3KJD/Rvy4FDXEZUlPzu+tLFw3PxzbQG0g9dRpRgvxR56dqJOU/eezpqcCNzHGvbL2K
         RhY9X1f3n7mYFptpDMsuaiTC/aeNFlLACoNUSYJBPLFLtAliwtOHIrejYKxJp9UiEUK5
         K4Wg==
X-Gm-Message-State: AOJu0Yzbi6Wby9O6z+6sEWkRp0T7KF2cCte/x+4XgdwdJ76/vpLQl837
        e+cF3zZctNGhTP2K6jrH9AZBQoyiFeQ=
X-Google-Smtp-Source: AGHT+IGS3w/cW42aBG+d9dQKa7Mx/WiROHoGCiqtqcn4HHMTu61bbwe8o9B0EcDatgLC6RpkBqhxLkI/Qo0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f344:b0:1bb:a13a:c21e with SMTP id
 q4-20020a170902f34400b001bba13ac21emr4042103ple.10.1693955018229; Tue, 05 Sep
 2023 16:03:38 -0700 (PDT)
Date:   Tue, 5 Sep 2023 16:03:36 -0700
In-Reply-To: <20230904013555.725413-3-tao1.su@linux.intel.com>
Mime-Version: 1.0
References: <20230904013555.725413-1-tao1.su@linux.intel.com> <20230904013555.725413-3-tao1.su@linux.intel.com>
Message-ID: <ZPezyAyVbdZSqhzk@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after APIC-write VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Tao Su <tao1.su@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Suravee

On Mon, Sep 04, 2023, Tao Su wrote:
> When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> 
> Since bit12 of ICR is no longer BUSY bit but UNUSED bit in x2APIC mode,
> and SDM has no detail about how hardware will handle the UNUSED bit12
> set, we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
> the UNUSED bit12 was also cleared by hardware without #GP. Therefore,
> the clearing of bit12 should be still kept being consistent with the
> hardware behavior.

I'm confused.  If hardware clears the bit, then why is it set in the vAPIC page
after a trap-like APIC-write VM-Exit?  In other words, how is this not a ucode
or hardware bug?

Suravee, can you confirm what happens on AMD with x2AVIC?  Does hardware *always*
clear the busy bit if it's set by the guest?  If so, then we could "optimize"
avic_incomplete_ipi_interception() to skip the busy check, e.g.

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..4bf0bb250147 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -513,7 +513,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
                 * in which case KVM needs to emulate the ICR write as well in
                 * order to clear the BUSY flag.
                 */
-               if (icrl & APIC_ICR_BUSY)
+               if (!apic_x2apic_mode(apic) && (icrl & APIC_ICR_BUSY))
                        kvm_apic_write_nodecode(vcpu, APIC_ICR);
                else
                        kvm_apic_send_ipi(apic, icrl, icrh);

> Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a983a16163b1..09a376aeb4a0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1482,8 +1482,17 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  {
>  	struct kvm_lapic_irq irq;
>  
> -	/* KVM has no delay and should always clear the BUSY/PENDING flag. */
> -	WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> +	/*
> +	 * In non-x2apic mode, KVM has no delay and should always clear the
> +	 * BUSY/PENDING flag. In x2apic mode, KVM should clear the unused bit12
> +	 * of ICR since hardware will also clear this bit. Although
> +	 * APIC_ICR_BUSY and X2APIC_ICR_UNUSED_12 are same, they mean different
> +	 * things in different modes.
> +	 */
> +	if (!apic_x2apic_mode(apic))
> +		WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> +	else
> +		WARN_ON_ONCE(icr_low & X2APIC_ICR_UNUSED_12);

NAK to the new name, KVM is absolutely not going to zero an arbitrary "unused"
bit.  If Intel wants to reclaim bit 12 for something useful in the future, then
Intel can ship CPUs that don't touch the "reserved" bit, and deal with all the
fun of finding and updating all software that unnecessarily sets the busy bit in
x2apic mode.

If we really want to pretend that Intel has more than a snowball's chance in hell
of doing something useful with bit 12, then the right thing to do in KVM is to
ignore the bit entirely and let the guest keep the pieces, e.g.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 113ca9661ab2..36ec195a3339 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1473,8 +1473,13 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
        struct kvm_lapic_irq irq;
 
-       /* KVM has no delay and should always clear the BUSY/PENDING flag. */
-       WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
+       /*
+        * KVM has no delay and should always clear the BUSY/PENDING flag.
+        * The flag doesn't exist in x2APIC mode; both the SDM and APM state
+        * that the flag "Must Be Zero", but neither Intel nor AMD enforces
+        * that (or any other reserved bits in ICR).
+        */
+       WARN_ON_ONCE(!apic_x2apic_mode(apic) && (icr_low & APIC_ICR_BUSY));
 
        irq.vector = icr_low & APIC_VECTOR_MASK;
        irq.delivery_mode = icr_low & APIC_MODE_MASK;
@@ -3113,8 +3118,6 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 
 int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 {
-       data &= ~APIC_ICR_BUSY;
-
        kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
        kvm_lapic_set_reg64(apic, APIC_ICR, data);
        trace_kvm_apic_write(APIC_ICR, data);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..4bf0bb250147 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -513,7 +513,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
                 * in which case KVM needs to emulate the ICR write as well in
                 * order to clear the BUSY flag.
                 */
-               if (icrl & APIC_ICR_BUSY)
+               if (!apic_x2apic_mode(apic) && (icrl & APIC_ICR_BUSY))
                        kvm_apic_write_nodecode(vcpu, APIC_ICR);
                else
                        kvm_apic_send_ipi(apic, icrl, icrh);

