Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F61349331F
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 03:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351069AbiASCuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 21:50:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:51210 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244048AbiASCue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 21:50:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642560634; x=1674096634;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u2HGL8KISl8494gdzNKZWFnRqO2cILWQ4uYRe/M7siM=;
  b=Cvrsu9Vr31EpLudHgCUK2gmjdeTcoW9fW8j3Lpkx5FhbIN/JH5EFxNaF
   jdgTtP2dWkhrr7TMfa8wzr562h3RMy6XFwJSaN0ZukChXw4N9Pqnve579
   ijBv4r8c6DB59/ejqo/9agdSjVyhEXSl6HoOOB9JZ44zy+c2aBcEvkrIT
   zrOr0r5YKBLaQsQvtv4kS1g6EucZtdTc+exjUksQbCKLVo/wbPffWFpUW
   xQ6E0hk13ce15ufK4lZNxhoGVP0Kz2589yn+n/+xzg6PYd67mIg8QfPCU
   mfwxFHScuwcWqnu1oHtLCbCRB6tZkOLNwzAW8ucjYDjf4yp1hXSJdmjsA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="269355573"
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="269355573"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 18:50:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="532063112"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.96]) ([10.238.0.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 18:50:26 -0800
Message-ID: <be6cb4b3-541c-8a8b-8d49-c53f84ac8a9c@intel.com>
Date:   Wed, 19 Jan 2022 10:48:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v5 5/8] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-6-guang.zeng@intel.com> <YeCZpo+qCkvx5l5m@google.com>
 <ec578526-989d-0913-e40e-9e463fb85a8f@intel.com>
 <YeG0Fdn/2++phMWs@google.com>
 <8ab5f976-1f3e-e2a5-87f6-e6cf376ead2f@intel.com>
 <YecEHF9Dqf3E3t02@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YecEHF9Dqf3E3t02@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/2022 2:17 AM, Sean Christopherson wrote:
> On Sat, Jan 15, 2022, Zeng Guang wrote:
>>> What about tweaking my prep patch from before to the below?  That would yield:
>>>
>>> 	if (apic_x2apic_mode(apic)) {
>>> 		if (WARN_ON_ONCE(offset != APIC_ICR))
>>> 			return 1;
>>>
>>> 		kvm_lapic_msr_read(apic, offset, &val);
>> I think it's problematic to use kvm_lapic_msr_read() in this case. It
>> premises the high 32bit value already valid at APIC_ICR2, while in handling
>> "nodecode" x2APIC writes we need get continuous 64bit data from offset 300H
>> first and prepare emulation of APIC_ICR2 write.
> Ah, I read this part of the spec:
>
>    All 64 bits of the ICR are written by using WRMSR to access the MSR with index 830H.
>    If ECX = 830H, WRMSR writes the 64-bit value in EDX:EAX to the ICR, causing the APIC
>    to send an IPI. If any of bits 13, 17:16, or 31:20 are set in EAX, WRMSR detects a
>    reserved-bit violation and causes a general-protection exception (#GP).
>
> but not the part down below that explicit says
>
>    VICR refers the 64-bit field at offset 300H on the virtual-APIC page. When the
>    “virtualize x2APIC mode” VM-execution control is 1 (indicating virtualization of
>    x2APIC mode), this field is used to virtualize the entire ICR.
>
> But that's indicative of an existing KVM problem.  KVM's emulation of x2APIC is
> broken.  The SDM, in section 10.12.9 ICR Operation in x2APIC Mode, clearly states
> that the ICR is extended to 64-bits.  ICR2 does not exist in x2APIC mode, full stop.
> KVM botched things by effectively aliasing ICR[63:32] to ICR2.
>
> We can and should fix that issue before merging IPIv suport, that way we don't
> further propagate KVM's incorrect behavior.  KVM will need to manipulate the APIC
> state in KVM_{G,S}ET_LAPIC so as not to "break" migration, "break" in quotes because
> I highly doubt any kernel reads ICR[63:32] for anything but debug purposes.  But
> we'd need to do that anyways for IPIv, otherwise migration from an IPIv host to
> a non-IPIv host would suffer the same migration bug.
>
> I'll post a series this week, in theory we should be able to reduce the patch for
> IPIv support to just having to only touching kvm_apic_write_nodecode().
OK, I'll adapt patch after your fix is ready. Suppose 
kvm_lapic_msr_{write,read} needn't emulate ICR2 write/read anymore.
