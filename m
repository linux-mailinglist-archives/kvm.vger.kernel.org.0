Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB0618FABF
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCWRCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:02:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42086 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbgCWRCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 13:02:34 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGQSu-0002u3-JE; Mon, 23 Mar 2020 18:02:16 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 13EBA1040AA; Mon, 23 Mar 2020 18:02:16 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of split lock detection
In-Reply-To: <20200315050517.127446-2-xiaoyao.li@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-2-xiaoyao.li@intel.com>
Date:   Mon, 23 Mar 2020 18:02:16 +0100
Message-ID: <87zhc7ovhj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Current initialization flow of split lock detection has following issues:
> 1. It assumes the initial value of MSR_TEST_CTRL.SPLIT_LOCK_DETECT to be
>    zero. However, it's possible that BIOS/firmware has set it.

Ok.

> 2. X86_FEATURE_SPLIT_LOCK_DETECT flag is unconditionally set even if
>    there is a virtualization flaw that FMS indicates the existence while
>    it's actually not supported.
>
> 3. Because of #2, KVM cannot rely on X86_FEATURE_SPLIT_LOCK_DETECT flag
>    to check verify if feature does exist, so cannot expose it to
>    guest.

Sorry this does not make anny sense. KVM is the hypervisor, so it better
can rely on the detect flag. Unless you talk about nested virt and a
broken L1 hypervisor.

> To solve these issues, introducing a new sld_state, "sld_not_exist",
> as

The usual naming convention is sld_not_supported.

> the default value. It will be switched to other value if CORE_CAPABILITIES
> or FMS enumerate split lock detection.
>
> Only when sld_state != sld_not_exist, it goes to initialization flow.
>
> In initialization flow, it explicitly accesses MSR_TEST_CTRL and
> SPLIT_LOCK_DETECT bit to ensure there is no virtualization flaw, i.e.,
> feature split lock detection does supported. In detail,
>  1. sld_off,   verify SPLIT_LOCK_DETECT bit can be cleared, and clear it;

That's not what the patch does. It writes with the bit cleared and the
only thing it checks is whether the wrmsrl fails or not. Verification is
something completely different.

>  2. sld_warn,  verify SPLIT_LOCK_DETECT bit can be cleared and set,
>                and set it;
>  3. sld_fatal, verify SPLIT_LOCK_DETECT bit can be set, and set it;
>
> Only when no MSR aceessing failure, can X86_FEATURE_SPLIT_LOCK_DETECT be
> set. So kvm can use X86_FEATURE_SPLIT_LOCK_DETECT to check the existence
> of feature.

Again, this has nothing to do with KVM. 

>   * Processors which have self-snooping capability can handle conflicting
> @@ -585,7 +585,7 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
>  	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
>  }
>  
> -static void split_lock_init(void);
> +static void split_lock_init(struct cpuinfo_x86 *c);
>  
>  static void init_intel(struct cpuinfo_x86 *c)
>  {
> @@ -702,7 +702,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
>  		tsx_disable();
>  
> -	split_lock_init();
> +	if (sld_state != sld_not_exist)
> +		split_lock_init(c);

That conditional want's to be in split_lock_init() where it used to be.

> +/*
> + * Use the "safe" versions of rdmsr/wrmsr here because although code
> + * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
> + * exist, there may be glitches in virtualization that leave a guest
> + * with an incorrect view of real h/w capabilities.
> + * If not msr_broken, then it needn't use "safe" version at runtime.
> + */
> +static void split_lock_init(struct cpuinfo_x86 *c)
>  {
> -	if (sld_state == sld_off)
> -		return;
> +	u64 test_ctrl_val;
>  
> -	if (__sld_msr_set(true))
> -		return;
> +	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
> +		goto msr_broken;
> +
> +	switch (sld_state) {
> +	case sld_off:
> +		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
> +			goto msr_broken;
> +		break;
> +	case sld_warn:
> +		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
> +			goto msr_broken;
> +		fallthrough;
> +	case sld_fatal:
> +		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
> +			goto msr_broken;
> +		break;

This does not make any sense either. Why doing it any different for warn
and fatal?

> +	default:
> +		break;

If there is ever a state added, then default will just fall through and
possibly nobody notices because the compiler does not complain.

> +	}
> +
> +	set_cpu_cap(c, X86_FEATURE_SPLIT_LOCK_DETECT);
> +	return;
>  
> +msr_broken:
>  	/*
>  	 * If this is anything other than the boot-cpu, you've done
>  	 * funny things and you get to keep whatever pieces.
>  	 */
> -	pr_warn("MSR fail -- disabled\n");
> +	pr_warn_once("MSR fail -- disabled\n");
>  	sld_state = sld_off;

So you run this on every CPU. What's the point? If the hypervisor is so
broken that the MSR works on CPU0 but not on CPU1 then this is probably
the least of your worries.

Thanks,

        tglx
