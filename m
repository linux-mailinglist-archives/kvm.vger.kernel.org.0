Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B0749007A
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 04:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiAQDHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 22:07:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:46396 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234099AbiAQDHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 22:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642388823; x=1673924823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R8Sn8SZmhuMPafCTfdZnGovaHJidPy4VsCKLE6frY5I=;
  b=bdS4wD6AHE+mJ2tHmHW171YjF8JhXjxLB36Hsbsc27Kq4S5wvNKufoAr
   yT+4jZV3XJGfKRljngwCMX5I2k13+OqzwGFDhT4HlFHsWQtPIiTD/LZ7/
   p82Gd6n9yAVqe9yJHHzEn9y/9fCTCixYlzio/9m3tGMa8wxE+2uPqTsW9
   EGrgNYTBQNVVubuasV+C/UgdrMxNZWG0znms8zKGtXftAA7wk+BCps7OQ
   ZfHpesFyWY6fMVdeO98TACgPLT/4pNP6rTaIbInRB6gQzsWOeg3dWbN78
   pjtsxJy9vfp7S+TFz8wN9XgetYEw+ucqNBVpkK1WaCR0/DYByMXQMiBB2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="224521886"
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="224521886"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 19:07:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="476489507"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 19:06:58 -0800
Date:   Mon, 17 Jan 2022 11:17:52 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
Message-ID: <20220117031750.GA5339@gao-cwp>
References: <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
 <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
 <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
 <20220110074523.GA18434@gao-cwp>
 <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
 <YeClaZWM1cM+WLjH@google.com>
 <20220114025825.GA3010@gao-cwp>
 <4b9fb845bf698f7efa6b46d525b37e329dd693ea.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9fb845bf698f7efa6b46d525b37e329dd693ea.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 10:17:34AM +0200, Maxim Levitsky wrote:
>On Fri, 2022-01-14 at 10:58 +0800, Chao Gao wrote:
>> On Thu, Jan 13, 2022 at 10:19:21PM +0000, Sean Christopherson wrote:
>> > On Tue, Jan 11, 2022, Maxim Levitsky wrote:
>> > > Both Intel and AMD's PRM also state that changing APIC ID is implementation
>> > > dependent.
>> > >  
>> > > I vote to forbid changing apic id, at least in the case any APIC acceleration
>> > > is used, be that APICv or AVIC.
>> > 
>> > That has my vote as well.  For IPIv in particular there's not much concern with
>> > backwards compability, i.e. we can tie the behavior to enable_ipiv.
>Great!
>> 
>> Hi Sean and Levitsky,
>> 
>> Let's align on the implementation.
>> 
>> To disable changes for xAPIC ID when IPIv/AVIC is enabled:
>> 
>> 1. introduce a variable (forbid_apicid_change) for this behavior in kvm.ko
>> and export it so that kvm-intel, kvm-amd can set it when IPIv/AVIC is
>> enabled. To reduce complexity, this variable is a module level setting.
>> 
>> 2. when guest attempts to change xAPIC ID but it is forbidden, KVM prints
>> a warning on host and injects a #GP to guest.
>> 
>> 3. remove AVIC code that deals with changes to xAPIC ID.
>> 
>
>I have a patch for both, I attached them.

Looks good to me. We will drop this patch and rely on the first attached patch
to forbid guest from changing xAPIC ID.

>I haven't tested either of these patches that much other than a smoke test,
>but I did test all of the guests I  have and none broke in regard to boot.
>
>I will send those patches as part of larger patch series that implements
>nesting for AVIC. I hope to do this next week.

Thanks.
