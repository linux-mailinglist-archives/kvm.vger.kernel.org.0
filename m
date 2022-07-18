Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E6A57885D
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiGRR2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiGRR2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:28:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14392CCBC
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:28:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q5so9644040plr.11
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=miE0kqF6TFWNBIdBqT6VO1lpZCmACyisnAMzziZNjoU=;
        b=NbIy7yTi7YM4Stffc79sessrp1CqyBGn3R/J21HXe0ejAsE5Mrh5QqWTJgP7wR03LK
         bb7L46eQ6BiRSMbtFL8hMydP+qMc7KQCv0ftuB4Pql370F7ZT1h9eVCol8O0M78fTybA
         trO3VyZD4AvTgLllsSgul+CpMn0n6h2k5Y2cSgI4n6N9zM/B4JOhehr7yM7lVKWWPW32
         XKV4QMGHLtGUxJiVMeYOkAp0gVhw7NX3AMsquci9bZ/g34mAEiSoMGHA1ZGk/Vb2WKV3
         oUWNGIJvCugJpsdUdfkq91teAEYeTHoj3CA503/XoMR3fNUIOkvk2+p/QfRlgGxOSF/A
         5usw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=miE0kqF6TFWNBIdBqT6VO1lpZCmACyisnAMzziZNjoU=;
        b=aqeCtmEQp6Jwd+WyU7ipHVB1MKcMn8rlrXv7QB6mLcqSR7jCdONXnJPMmQhTUXo4uo
         Ee8FegutJJN8at6aqRx0Y81wFPNDb91AZRuO32YlgIxmm81EPzBXKl+A7DAudLMEbP2O
         cLjxqzVQvNNSSSUXjd7xdG0wE2gUSU5pEGf1nltlBwExM07EJLI+WTl+ah+yC2D4yRFZ
         t6o4ps9BVBuviqGXzwi+Iatic0ZbrDM8wEIdOzdTnz+OnIxAAztH18H8dWpVvQSBcPwM
         oz9GLcEBUm5Z4od7Vx+4P+4Wp+5/pMN++9KwFdegrVV6PeFS8vE6BHS4Xrs9lVbYqGxJ
         tPBg==
X-Gm-Message-State: AJIora96mtGoBzyTqlPhnQraJCABElEHVWh7yk3e9yu+h9ni4Abp6ms8
        3IQWS3JKb6MURvrcPeE2vJx0s2ieqCTJZQ==
X-Google-Smtp-Source: AGRyM1tm0SI4zofXoCefa+XbSd+8xZO1TpJMQvohWCBDcmGclrUCOuPnvrC8Ad5uWhIAubhkywZjaA==
X-Received: by 2002:a17:903:228b:b0:16b:ee10:b91 with SMTP id b11-20020a170903228b00b0016bee100b91mr29296087plh.27.1658165299137;
        Mon, 18 Jul 2022 10:28:19 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090301cc00b0016bd67bc868sm9852993plh.210.2022.07.18.10.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:28:18 -0700 (PDT)
Date:   Mon, 18 Jul 2022 17:28:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, jon.grimm@amd.com,
        Zeng Guang <guang.zeng@intel.com>
Subject: Re: [PATCH] KVM: x86: Do not block APIC write for non ICR registers
Message-ID: <YtWYL6mvN72kaDOi@google.com>
References: <20220718083913.222140-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718083913.222140-1-suravee.suthikulpanit@amd.com>
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

On Mon, Jul 18, 2022, Suravee Suthikulpanit wrote:
> The commit 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write
> VM-Exits in x2APIC mode") introduces logic to prevent APIC write
> for offset other than ICR. This breaks x2AVIC support, which requires
> KVM to trap and emulate x2APIC MSR writes.
> 
> Therefore, removes the warning and modify to logic to allow MSR write.
> 
> Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")

This tag is wrong, I believe it should be:

  Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")

And that absolutely matters because this should not be backported to older
kernels that don't support x2avic.

> Cc: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/lapic.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9d4f73c4dc02..f688090d98b0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -69,6 +69,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
>  static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
> +static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
>  
>  static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
>  {
> @@ -2284,17 +2285,23 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  	u64 val;
>  
>  	if (apic_x2apic_mode(apic)) {
> +		kvm_lapic_msr_read(apic, offset, &val);
> +
>  		/*
>  		 * When guest APIC is in x2APIC mode and IPI virtualization
>  		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
>  		 * on Intel hardware. Other offsets are not possible.
> +		 *
> +		 * For AMD AVIC, write to some APIC registers can cause

x2AVIC if we're going to keep a comment.  But at this point, the WARN has done its
job and the comment is obsolete.  My preference is to just document that ICR is
special in x2APIC mode and not bother with vendor/feature specific behavior.

> +		 * trap-like VM-exit (see arch/x86/kvm/svm/avic.c:

Specifying the file name and full path is completely unnecessary.

> +		 * avic_unaccel_trap_write()).

If something like this comes up again in the future, please just explicitly document
the architecturally (or micro-architectural behavior).  Redirecting to KVM code is
annoying for the reader and comments that reference function names all too often
become stale.  There _are_ times when explicitly referencing a function is appropriate,
but IMO this isn't one of them.

But if we just drop the Intel vs. AMD stuff, this all goes away.

>  		 */
> -		if (WARN_ON_ONCE(offset != APIC_ICR))
> +		if (offset == APIC_ICR) {
> +			kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> +			trace_kvm_apic_write(APIC_ICR, val);
>  			return;
> -
> -		kvm_lapic_msr_read(apic, offset, &val);
> -		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> -		trace_kvm_apic_write(APIC_ICR, val);
> +		}
> +		kvm_lapic_msr_write(apic, offset, val);

Because this lacks the TODO below, what about tweaking this so that there's a
single call to kvm_lapic_msr_write()?  gcc-11 even generates more efficient code
for this.  Alternatively, the ICR path can be an early return inside a single
x2APIC check, but gcc generate identical code and I like making x2APIC+ICR stand
out as being truly special.

Compile tested only.

---
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 18 Jul 2022 10:16:02 -0700
Subject: [PATCH] KVM: x86: Handle trap-like x2APIC accesses for any APIC
 register

Handle trap-like VM-Exits for all APIC registers when the guest is in
x2APIC mode and drop the now-stale WARN that KVM encounters trap-like
exits only for ICR.  On Intel, only writes to ICR can be trap-like when
APICv and x2APIC are enabled, but AMD's x2AVIC can trap more registers,
e.g. LDR and DFR.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Zeng Guang <guang.zeng@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9d4f73c4dc02..95bb1ef37a12 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2283,21 +2283,20 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;

-	if (apic_x2apic_mode(apic)) {
-		/*
-		 * When guest APIC is in x2APIC mode and IPI virtualization
-		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
-		 * on Intel hardware. Other offsets are not possible.
-		 */
-		if (WARN_ON_ONCE(offset != APIC_ICR))
-			return;
-
+	if (apic_x2apic_mode(apic))
 		kvm_lapic_msr_read(apic, offset, &val);
+	else
+		val = kvm_lapic_get_reg(apic, offset);
+
+	/*
+	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
+	 * xAPIC, ICR writes need to go down the common (slightly slower) path
+	 * to get the upper half from ICR2.
+	 */
+	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
 		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
 		trace_kvm_apic_write(APIC_ICR, val);
 	} else {
-		val = kvm_lapic_get_reg(apic, offset);
-
 		/* TODO: optimize to just emulate side effect w/o one more write */
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}

base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
--

