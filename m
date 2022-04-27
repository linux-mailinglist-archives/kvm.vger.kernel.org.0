Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2605124E6
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiD0WCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 18:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbiD0WCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 18:02:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80640114E;
        Wed, 27 Apr 2022 14:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651096741; x=1682632741;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ReKgWjo5Fy4ccefVXI5WqZ17NyQEm0KPvtdTQFFhd4Q=;
  b=XIEFDv4nLLeFa23t1t7QlsI5v58+4bHEJgRxkXlij5a/xy4oGoWAklR4
   UPnGJD5ExNUteH/67Nwdj3/Y6Gzl01FvuRyQkyvUrWuC1b1Ub89v4hGNq
   n3Z068La5opclGRXXO5YsGS2xt/FDFLG2w204arE2Pi9ZbzW3z2eEZjFv
   Rj9KnIjuT2pB4njb31XdQFTbevvT4nCtioMnMFC9mTFhbwLZuoaNiX33x
   ZggpYENMKJELjr87cnT25T7Tgzmbokoq73ZfczDqbQ+l55aDWqZ6vIaoj
   4tNAK8oOX1A0Yy4iMcM19zYleIQ2UgevL6dConqZYlvQysu1bNHCJrVKo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="263666520"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="263666520"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 14:59:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="513905331"
Received: from lcdaughe-mobl1.amr.corp.intel.com (HELO [10.212.72.252]) ([10.212.72.252])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 14:59:00 -0700
Message-ID: <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
Date:   Wed, 27 Apr 2022 14:59:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
Content-Language: en-US
In-Reply-To: <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 18:15, Kai Huang wrote:
> On Tue, 2022-04-26 at 13:13 -0700, Dave Hansen wrote:
>> On 4/5/22 21:49, Kai Huang wrote:
>>> SEAM VMX root operation is designed to host a CPU-attested, software
>>> module called the 'TDX module' which implements functions to manage
>>> crypto protected VMs called Trust Domains (TD).  SEAM VMX root is also
>>
>> "crypto protected"?  What the heck is that?
> 
> How about "crypto-protected"?  I googled and it seems it is used by someone
> else.

Cryptography itself doesn't provide (much) protection in the TDX
architecture.  TDX guests are isolated from the VMM in ways that
traditional guests are not, but that has almost nothing to do with
cryptography.

Is it cryptography that keeps the host from reading guest private data
in the clear?  Is it cryptography that keeps the host from reading guest
ciphertext?  Does cryptography enforce the extra rules of Secure-EPT?

>>> 3. Memory hotplug
>>>
>>> The first generation of TDX architecturally doesn't support memory
>>> hotplug.  And the first generation of TDX-capable platforms don't support
>>> physical memory hotplug.  Since it physically cannot happen, this series
>>> doesn't add any check in ACPI memory hotplug code path to disable it.
>>>
>>> A special case of memory hotplug is adding NVDIMM as system RAM using
>>> kmem driver.  However the first generation of TDX-capable platforms
>>> cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
>>> happen either.
>>
>> What prevents this code from today's code being run on tomorrow's
>> platforms and breaking these assumptions?
> 
> I forgot to add below (which is in the documentation patch):
> 
> "This can be enhanced when future generation of TDX starts to support ACPI
> memory hotplug, or NVDIMM and TDX can be enabled simultaneously on the
> same platform."
> 
> Is this acceptable?

No, Kai.

You're basically saying: *this* code doesn't work with feature A, B and
C.  Then, you're pivoting to say that it doesn't matter because one
version of Intel's hardware doesn't support A, B, or C.

I don't care about this *ONE* version of the hardware.  I care about
*ALL* the hardware that this code will ever support.  *ALL* the hardware
on which this code will run.

In 5 years, if someone takes this code and runs it on Intel hardware
with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?

You can't just ignore the problems because they're not present on one
version of the hardware.

>>> Another case is admin can use 'memmap' kernel command line to create
>>> legacy PMEMs and use them as TD guest memory, or theoretically, can use
>>> kmem driver to add them as system RAM.  To avoid having to change memory
>>> hotplug code to prevent this from happening, this series always include
>>> legacy PMEMs when constructing TDMRs so they are also TDX memory.
>>>
>>> 4. CPU hotplug
>>>
>>> The first generation of TDX architecturally doesn't support ACPI CPU
>>> hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
>>> first generation of TDX-capable platforms don't support ACPI CPU hotplug
>>> either.  Since this physically cannot happen, this series doesn't add any
>>> check in ACPI CPU hotplug code path to disable it.
>>>
>>> Also, only TDX module initialization requires all BIOS-enabled cpus are
>>> online.  After the initialization, any logical cpu can be brought down
>>> and brought up to online again later.  Therefore this series doesn't
>>> change logical CPU hotplug either.
>>>
>>> 5. TDX interaction with kexec()
>>>
>>> If TDX is ever enabled and/or used to run any TD guests, the cachelines
>>> of TDX private memory, including PAMTs, used by TDX module need to be
>>> flushed before transiting to the new kernel otherwise they may silently
>>> corrupt the new kernel.  Similar to SME, this series flushes cache in
>>> stop_this_cpu().
>>
>> What does this have to do with kexec()?  What's a PAMT?
> 
> The point is the dirty cachelines of TDX private memory must be flushed
> otherwise they may slightly corrupt the new kexec()-ed kernel.
> 
> Will use "TDX metadata" instead of "PAMT".  The former has already been
> mentioned above.

Longer description for the patch itself:

TDX memory encryption is built on top of MKTME which uses physical
address aliases to designate encryption keys.  This architecture is not
cache coherent.  Software is responsible for flushing the CPU caches
when memory changes keys.  When kexec()'ing, memory can be repurposed
from TDX use to non-TDX use, changing the effective encryption key.

Cover-letter-level description:

Just like SME, TDX hosts require special cache flushing before kexec().

>>> uninitialized state so it can be initialized again.
>>>
>>> This implies:
>>>
>>>   - If the old kernel fails to initialize TDX, the new kernel cannot
>>>     use TDX too unless the new kernel fixes the bug which leads to
>>>     initialization failure in the old kernel and can resume from where
>>>     the old kernel stops. This requires certain coordination between
>>>     the two kernels.
>>
>> OK, but what does this *MEAN*?
> 
> This means we need to extend the information which the old kernel passes to the
> new kernel.  But I don't think it's feasible.  I'll refine this kexec() section
> to make it more concise next version.
> 
>>
>>>   - If the old kernel has initialized TDX successfully, the new kernel
>>>     may be able to use TDX if the two kernels have the exactly same
>>>     configurations on the TDX module. It further requires the new kernel
>>>     to reserve the TDX metadata pages (allocated by the old kernel) in
>>>     its page allocator. It also requires coordination between the two
>>>     kernels.  Furthermore, if kexec() is done when there are active TD
>>>     guests running, the new kernel cannot use TDX because it's extremely
>>>     hard for the old kernel to pass all TDX private pages to the new
>>>     kernel.
>>>
>>> Given that, this series doesn't support TDX after kexec() (except the
>>> old kernel doesn't attempt to initialize TDX at all).
>>>
>>> And this series doesn't shut down TDX module but leaves it open during
>>> kexec().  It is because shutting down TDX module requires CPU being in
>>> VMX operation but there's no guarantee of this during kexec().  Leaving
>>> the TDX module open is not the best case, but it is OK since the new
>>> kernel won't be able to use TDX anyway (therefore TDX module won't run
>>> at all).
>>
>> tl;dr: kexec() doesn't work with this code.
>>
>> Right?
>>
>> That doesn't seem good.
> 
> It can work in my understanding.  We just need to flush cache before booting to
> the new kernel.

What about all the concerns about TDX module configuration changing?

