Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7ED490978
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 14:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiAQNYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 08:24:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:21856 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbiAQNYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 08:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642425854; x=1673961854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HGSlJkPFahzJlQW9BvUEZBi+xdMhmzehQDA5gynXVrA=;
  b=bSsOlR+TMguFVzbdC2XgvH0rvpakq1OMozThKmLdHOD798tycEUkcwK/
   qfi4a7YqfaGuuYWnXeBA11Wg0YqtuFSSSVavk7SXZBn7eV05MREzlrnir
   NFRfh0AJLRUb+l7LacGWfiv5th12bFTZ/LABDDR+tpn4wAIxYxYx6SJw0
   Rcgu6hnywHs0j249k6Sbta/AwyqENoBYw63hHetTsEl41b8tWS0ETgkfp
   oqDinTYUb8WlMmXwoHQ9Ut2zSTTGT8TC0h7Df3sY6rps9LH8mABPssXdW
   z6Y1wvIDW0ihHiRL7DQ/baZv6koQ+TN9Bc/jfNRcZ4rW0tCDnRgMsjo77
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="307962600"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="307962600"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 05:24:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="531336726"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 05:24:10 -0800
Date:   Mon, 17 Jan 2022 21:35:04 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: x86: Remove WARN_ON in
 kvm_arch_check_processor_compat
Message-ID: <20220117133503.GA27833@gao-cwp>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-6-chao.gao@intel.com>
 <Ydy6aIyI3jFQvF0O@google.com>
 <BN9PR11MB5276DEA925C72AF585E7472C8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yd3fFxg3IjWPUIqH@google.com>
 <20220112110000.GA10249@gao-cwp>
 <Yd8RUJ6YpQrpe4Zf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yd8RUJ6YpQrpe4Zf@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 05:35:12PM +0000, Sean Christopherson wrote:
>On Wed, Jan 12, 2022, Chao Gao wrote:
>> On Tue, Jan 11, 2022 at 07:48:39PM +0000, Sean Christopherson wrote:
>> >On Tue, Jan 11, 2022, Tian, Kevin wrote:
>> >> > From: Sean Christopherson <seanjc@google.com>
>> >> > Sent: Tuesday, January 11, 2022 7:00 AM
>> >> > 
>> >> > On Mon, Dec 27, 2021, Chao Gao wrote:
>> >> > > kvm_arch_check_processor_compat() needn't be called with interrupt
>> >> > > disabled, as it only reads some CRs/MSRs which won't be clobbered
>> >> > > by interrupt handlers or softirq.
>> >> > >
>> >> > > What really needed is disabling preemption. No additional check is
>> >> > > added because if CONFIG_DEBUG_PREEMPT is enabled, smp_processor_id()
>> >> > > (right above the WARN_ON()) can help to detect any violation.
>> >> > 
>> >> > Hrm, IIRC, the assertion that IRQs are disabled was more about detecting
>> >> > improper usage with respect to KVM doing hardware enabling than it was
>> >> > about ensuring the current task isn't migrated.  E.g. as exhibited by patch
>> >> > 06, extra protections (disabling of hotplug in that case) are needed if
>> >> > this helper is called outside of the core KVM hardware enabling flow since
>> >> > hardware_enable_all() does its thing via SMP function call.
>> >> 
>> >> Looks the WARN_ON() was added by you. 😊
>> >
>> >Yeah, past me owes current me a beer.
>> >
>> >> commit f1cdecf5807b1a91829a2dc4f254bfe6bafd4776
>> >> Author: Sean Christopherson <sean.j.christopherson@intel.com>
>> >> Date:   Tue Dec 10 14:44:14 2019 -0800
>> >> 
>> >>     KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
>> >> 
>> >>     Check the current CPU's reserved cr4 bits against the mask calculated
>> >>     for the boot CPU to ensure consistent behavior across all CPUs.
>> >> 
>> >>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> >>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> >> 
>> >> But it's unclear to me how this WARN_ON() is related to what the commit
>> >> msg tries to explain.
>> >
>> >Ya, the changelog and lack of a comment is awful.
>> >
>> >> When I read this code it's more like a sanity check on the assumption that it
>> >> is currently called in SMP function call which runs the said function with
>> >> interrupt disabled.
>> >
>> >Yes, and as above, that assertion was more about the helper not really being safe
>> >for general usage as opposed to wanting to detect use from preemptible context.
>> >If we end up keeping the WARN_ON, I'll happily write a comment explaining the
>> >point of the assertion.
>> 
>> OK. I will do following changes to keep the WARN_ON():
>> 1. drop this patch
>> 2. disable interrupt before the call site in patch 6.
>
>No, we shouldn't sully other code just to keep this WARN.  Again, the point of
>the WARN is/was to highlight that any use outside of the hardware enabling path
>is suspect.  That's why I asked if there was a way this code could identify that
>the CPU in question is being hotplugged, i.e. to convey that the helper is safe
>to use only during hardware enabling _or_ hotplug.  If that's not feasible,
>replacing the WARN with a scary comment is better than disabling IRQs.

OK. How about:

	/*
	 * Compatibility checks are done when loading KVM or in KVM's CPU
	 * hotplug callback. It ensures all online CPUs are compatible before
	 * running any vCPUs. For other cases, compatibility checks are
	 * unnecessary or even problematic. Try to detect improper usages here.
	 */
	WARN_ON(!irqs_disabled() && !cpu_active(smp_processor_id()));

a CPU is active when it reaches the CPUHP_AP_ACTIVE state (the last state before
CPUHP_ONLINE). So, if a cpu isn't active, it probably is being hotplugged. One
false positive is the CPU is dying, which I guess is fine.

And to help justify this change, I will merge it into patch 6.
