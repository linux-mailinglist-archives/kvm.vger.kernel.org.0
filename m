Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EF7489830
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 13:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245155AbiAJMBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 07:01:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:44342 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239787AbiAJMBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 07:01:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641816101; x=1673352101;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qQBsIifTIuMVPMFSn0tGFMJxP2ex7OJBeEEbaxFhClc=;
  b=DkWkfHQtzHzKAXPoy/XJiip1/0iD1DmmvkQoArQw7FEXYfDmex7qhLy7
   Q5x+7eK8Cvtgpyohonn7KGc9xLby8qVax4IXDX/6vQqSDGMFqR2hPDIas
   vSJvpJVX94YCwIdM9qnXnczQ0AUSsk48Xax1jWv5pV8OfR8zVhJZlcPJt
   dVYe6/+Fb8o0b/yxsaUda7eE8qxyzUa06M2+VrmAr9HYsZt/SavdzYwRh
   3HGdNxY/NClkiPA45RptacYy68YSIs2TUKjmE+ahHegHrh4Hw0Omm8wRo
   o8TXMvyBhy3zHvOC0WEA3t5JcZ1T5DHDxWNThLD+MDWCm6liXi73M6J9c
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="303950371"
X-IronPort-AV: E=Sophos;i="5.88,277,1635231600"; 
   d="scan'208";a="303950371"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 04:01:41 -0800
X-IronPort-AV: E=Sophos;i="5.88,277,1635231600"; 
   d="scan'208";a="528244187"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.157]) ([10.249.174.157])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 04:01:36 -0800
Message-ID: <2515c902-ebaf-5917-a006-9d9d283a912f@intel.com>
Date:   Mon, 10 Jan 2022 20:01:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v2 06/44] hw/i386: Introduce kvm-type for TDX guest
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com, cohuck@redhat.com, ehabkost@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, seanjc@google.com,
        alistair@alistair23.me, qemu-devel@nongnu.org, mtosatti@redhat.com,
        erdemaktas@google.com, pbonzini@redhat.com
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
 <20210826102212.gykq2z4fb2iszb2k@sirius.home.kraxel.org>
 <03aaab8b-0a50-6b56-2891-ccd58235ad83@intel.com>
 <YdwV8jUm+RuirhxK@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YdwV8jUm+RuirhxK@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/2022 7:18 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 24, 2021 at 03:31:13PM +0800, Xiaoyao Li wrote:
>> On 8/26/2021 6:22 PM, Gerd Hoffmann wrote:
>>> On Wed, Jul 07, 2021 at 05:54:36PM -0700, isaku.yamahata@gmail.com wrote:
>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>
>>>> Introduce a machine property, kvm-type, to allow the user to create a
>>>> Trusted Domain eXtensions (TDX) VM, a.k.a. a Trusted Domain (TD), e.g.:
>>>>
>>>>    # $QEMU \
>>>> 	-machine ...,kvm-type=tdx \
>>>> 	...
>>
>> Sorry for the very late reply.
>>
>>> Can we align sev and tdx better than that?
>>>
>>> SEV is enabled this way:
>>>
>>> qemu -machine ...,confidential-guest-support=sev0 \
>>>        -object sev-guest,id=sev0,...
>>>
>>> (see docs/amd-memory-encryption.txt for details).
>>>
>>> tdx could likewise use a tdx-guest object (and both sev-guest and
>>> tdx-guest should probably have a common parent object type) to enable
>>> and configure tdx support.
>>
>> yes, sev only introduced a new object and passed it to
>> confidential-guest-support. This is because SEV doesn't require the new type
>> of VM.
>> However, TDX does require a new type of VM.
>>
>> If we read KVM code, there is a parameter of CREATE_VM to pass the vm_type,
>> though x86 doesn't use this field so far. On QEMU side, it also has the
>> codes to pass/configure vm-type in command line. Of cousre, x86 arch doesn't
>> implement it. With upcoming TDX, it will implement and use vm type for TDX.
>> That's the reason we wrote this patch to implement kvm-type for x86, similar
>> to other arches.
>>
>> yes, of course we can infer the vm_type from "-object tdx-guest". But I
>> prefer to just use vm_type. Let's see others opinion.
> 
> It isn't just SEV that is using the confidential-guest-support approach.
> This was done for PPC64 and S390x too.  This gives QEMU a standard
> internal interface to declare that a confidential guest is being used /
> configured. IMHO, TDX needs to use this too, unless there's a compelling
> technical reason why it is a bad approach & needs to diverge from every
> other confidential guest impl in QEMU.
> 

Forgot to tell the update that we went the direction to identify the TDX 
vm_type based on confidential-guest_support like below:


if (ms->cgs && object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
         kvm_type = KVM_X86_TDX_VM;
} else {
         kvm_type = KVM_X86_DEFAULT_VM;
}


I think it's what you want, right?

BTW, the whole next version of TDX QEMU series should be released with 
next version of TDX KVM series. But I cannot tell the exact date yet.

