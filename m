Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87C04C4897
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241944AbiBYPTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiBYPT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:19:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A2882D01;
        Fri, 25 Feb 2022 07:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645802337; x=1677338337;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=84fOjGeLn2tSLSYuKr7MpfZDNr7NR6Oa5z6KoGnpcbo=;
  b=ArGdlHT1GipZMDK6110kc166RG0/6Gruzqixw0opkg9RAj2QJkrkKt0A
   nSMiJggkphhjvabbbPvbs6yMoQDcEWs4y6fnHChVjesZ5zMPb/T45M6Wp
   L3znTCJT124elISSj97/YfC5vlDoyI2pXhDnEEIqyMrlAcUMFTW20OwZ1
   P9FGA3rZ0V+quo4adkzEs9gSitFCtkcT2by1uiOfjCSZl0mJeJXZSqcR2
   2HaZfzv/ZLWVWhK1kapibqbr0YyjsQlpR1SReU69L84hFoqhMq+sassJn
   rReB/3NrWgQhsCPs2mjPYWT4hd+kvfRDzqfCGezCONIeIFPWIeS9IwNCI
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252708656"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252708656"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 07:18:57 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="533603388"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 07:18:51 -0800
Date:   Fri, 25 Feb 2022 23:29:48 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v6 5/9] KVM: x86: Add support for vICR APIC-write
 VM-Exits in x2APIC mode
Message-ID: <20220225152946.GA26414@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-6-guang.zeng@intel.com>
 <91235d07cad41a75282df7fc222514dc1e991118.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91235d07cad41a75282df7fc222514dc1e991118.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 04:44:05PM +0200, Maxim Levitsky wrote:
>On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
>> Upcoming Intel CPUs will support virtual x2APIC MSR writes to the vICR,
>> i.e. will trap and generate an APIC-write VM-Exit instead of intercepting
>> the WRMSR.  Add support for handling "nodecode" x2APIC writes, which
>> were previously impossible.
>> 
>> Note, x2APIC MSR writes are 64 bits wide.
>> 
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>  arch/x86/kvm/lapic.c | 25 ++++++++++++++++++++++---
>>  1 file changed, 22 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 629c116b0d3e..e4bcdab1fac0 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
>>  #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
>>  /* step-by-step approximation to mitigate fluctuation */
>>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
>> +static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
>>  
>>  static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
>>  {
>> @@ -2227,10 +2228,28 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
>>  /* emulate APIC access in a trap manner */
>>  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>  {
>> -	u32 val = kvm_lapic_get_reg(vcpu->arch.apic, offset);
>> +	struct kvm_lapic *apic = vcpu->arch.apic;
>> +	u64 val;
>> +
>> +	if (apic_x2apic_mode(apic)) {
>> +		/*
>> +		 * When guest APIC is in x2APIC mode and IPI virtualization
>> +		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
>> +		 * on Intel hardware. Other offsets are not possible.
>> +		 */
>> +		if (WARN_ON_ONCE(offset != APIC_ICR))
>> +			return;
>>  
>> -	/* TODO: optimize to just emulate side effect w/o one more write */
>> -	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
>> +		kvm_lapic_msr_read(apic, offset, &val);
>> +		if (val & APIC_ICR_BUSY)
>> +			kvm_x2apic_icr_write(apic, val);
>> +		else
>> +			kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>I don't fully understand the above code.
>
>First of where kvm_x2apic_icr_write is defined?

Sean introduces it in his "prep work for VMX IPI virtualization" series, which
is merged into kvm/queue branch.

https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=queue&id=7a641ca0c219e4bbe102f2634dbc7e06072fcd3c

>
>Second, I thought that busy bit is not used in x2apic mode?
>At least in intel's SDM, section 10.12.9 'ICR Operation in x2APIC Mode'
>this bit is not defined.

You are right. We will remove the pointless check against APIC_ICR_BUSY and
just invoke kvm_apic_send_ipi().

In that section, SDM also says:
With the removal of the Delivery Status bit, system software no longer has a
reason to read the ICR. It remains readable only to aid in debugging; however,
***software should not assume the value returned by reading the ICR is the last
written value***.
