Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12326C6E59
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjCWREA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjCWRD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:03:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8D89004
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679590982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cglotdbZ9kvOmjiiA3xfBy0x7OKBSKTg0p62tpcUq34=;
        b=Q25uFBrQ09ucTL2QBePvWNRJ/rBmGsde7BeLG253T116aUVHZLNtYrdB3do9S2KTLk4YIY
        AHjzvl8tKJLRVCS0lJW67mBnHVG11Ax4SisbUO2MaD4U5hxzaV8BxSXPZty6jsdw+Q2wC8
        vanX98uGgKro+UO04aTpc9+wEZnfEaM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-Mlj9LUpeNYa2F7SRdT2vgg-1; Thu, 23 Mar 2023 13:03:01 -0400
X-MC-Unique: Mlj9LUpeNYa2F7SRdT2vgg-1
Received: by mail-wm1-f71.google.com with SMTP id o37-20020a05600c512500b003edd119ec9eso7177682wms.0
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679590979;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cglotdbZ9kvOmjiiA3xfBy0x7OKBSKTg0p62tpcUq34=;
        b=dnVi4MnSmc/9+bw64JK9XMv54RRvIiTqCF7eOHvcNMHtMdYfpdC3y3gq5pNeVI74VB
         HIyzT7b99CsqYSeUcg7fjOj3+ngGjnF1g2WkD2GQJQD1qZ1xgECv1xmZEK51u4i01GSZ
         VHUSKiCldKviiyhoqs+kReoq5oK0BkIRkc9NJ7POCTL17UHOWIsfOEdk12YTdnj0W8np
         UJtz1ccb7kgqHNng22wiaiE/qBuBLA1U2m1+ZQkWB+0fIaFDkpwn1gqfAOK/geK9ip7J
         VuKjXxyD7LH2uw4iX397KqoWM0suz1ugcDQT45F2vMRTKVLHN9ouBq3K1LTTv7pSQ0uO
         6lDQ==
X-Gm-Message-State: AO0yUKXMGOBV7BIk/eHDrAuiWprRG8Bm9uo5LwNxXZOY6pmOp6Nsutv0
        g/HQj6FnQr75zg0hbFX/VBgCPEqk9UNOJCs8KwqZ5TguV4sMq4LleAATtCEr4LwkgXMIg9ar4sM
        MWUwutaaHMzD7
X-Received: by 2002:a1c:7406:0:b0:3ed:320a:3721 with SMTP id p6-20020a1c7406000000b003ed320a3721mr281073wmc.22.1679590978971;
        Thu, 23 Mar 2023 10:02:58 -0700 (PDT)
X-Google-Smtp-Source: AK7set/2X0vV6gTyBSJOJJGL1Fdh0QWcbOfAS0eHPNeVmmhuLkrzvxlO/MiBZ4ftHK9wZ9NuLSr74Q==
X-Received: by 2002:a1c:7406:0:b0:3ed:320a:3721 with SMTP id p6-20020a1c7406000000b003ed320a3721mr281045wmc.22.1679590978561;
        Thu, 23 Mar 2023 10:02:58 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:e500:5cdf:c280:4b31:4016? (p200300cbc704e5005cdfc2804b314016.dip0.t-ipconnect.de. [2003:cb:c704:e500:5cdf:c280:4b31:4016])
        by smtp.gmail.com with ESMTPSA id fk6-20020a05600c0cc600b003ee7169d57dsm2353857wmb.40.2023.03.23.10.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 10:02:57 -0700 (PDT)
Message-ID: <3dd0e43d-36f7-3325-7680-33779e9b0a55@redhat.com>
Date:   Thu, 23 Mar 2023 18:02:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v10 02/16] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <35a2421ca97d9e8dd938dcd744674602f4faa617.1678111292.git.kai.huang@intel.com>
 <90f6a15c-0dec-4a19-7a21-b18b73932a21@redhat.com>
 <e8cc32a3f374e494bc6b93dad31367d8b093f9c8.camel@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <e8cc32a3f374e494bc6b93dad31367d8b093f9c8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.03.23 23:37, Huang, Kai wrote:
> On Thu, 2023-03-16 at 13:48 +0100, David Hildenbrand wrote:
>> On 06.03.23 15:13, Kai Huang wrote:
>>> Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>>> host and certain physical attacks.  A CPU-attested software module
>>> called 'the TDX module' runs inside a new isolated memory range as a
>>> trusted hypervisor to manage and run protected VMs.
>>>
>>> Pre-TDX Intel hardware has support for a memory encryption architecture
>>> called MKTME.  The memory encryption hardware underpinning MKTME is also
>>> used for Intel TDX.  TDX ends up "stealing" some of the physical address
>>> space from the MKTME architecture for crypto-protection to VMs.  The
>>> BIOS is responsible for partitioning the "KeyID" space between legacy
>>> MKTME and TDX.  The KeyIDs reserved for TDX are called 'TDX private
>>> KeyIDs' or 'TDX KeyIDs' for short.
>>>
>>> TDX doesn't trust the BIOS.  During machine boot, TDX verifies the TDX
>>> private KeyIDs are consistently and correctly programmed by the BIOS
>>> across all CPU packages before it enables TDX on any CPU core.  A valid
>>> TDX private KeyID range on BSP indicates TDX has been enabled by the
>>> BIOS, otherwise the BIOS is buggy.
>>

Sorry for the late reply!

>> So we don't trust the BIOS, but trust the BIOS that it won't hot-remove
>> physical memory or hotplug physical CPUS (if I understood the cover
>> letter correctly)? :)
> 
> The "trust" in this context means security, but not functionality.  BIOS needs
> to do the right thing in order to make things work correctly in terms of
> functionality.
> 
> For physical memory hotplug or CPU hotplug, we don't have patch to _explicitly_
> distinguish them (from logical memory hotplug and logical cpu online/offline),
> but actually they are kinda also handled:  For memory hotplug, and hot-added
> memory is rejected to go online (because they cannot be in TDX's convertible
> memory ranges).  For CPU hotplug, we have a function to do per-cpu
> initialization (tdx_cpu_enable() in patch 5), and it will return error for hot-
> added physical cpu.

Make sense, thanks!

> 
>>
>>>
>>> The TDX module is expected to be loaded by the BIOS when it enables TDX,
>>> but the kernel needs to properly initialize it before it can be used to
>>> create and run any TDX guests.  The TDX module will be initialized by
>>> the KVM subsystem when KVM wants to use TDX.
>>>
>>> Add a new early_initcall(tdx_init) to detect the TDX by detecting TDX
>>> private KeyIDs.  Also add a function to report whether TDX is enabled by
>>> the BIOS.  Similar to AMD SME, kexec() will use it to determine whether
>>> cache flush is needed.
>>>
>>> The TDX module itself requires one TDX KeyID as the 'TDX global KeyID'
>>> to protect its metadata.  Each TDX guest also needs a TDX KeyID for its
>>> own protection.  Just use the first TDX KeyID as the global KeyID and
>>> leave the rest for TDX guests.  If no TDX KeyID is left for TDX guests,
>>> disable TDX as initializing the TDX module alone is useless.
>>
>> Does that really happen in practice that we care about that at all?
>> Seems weird and rather like a broken firmware or sth like that ...
> 
> No it doesn't happen in practice, because the BIOS is sane enough.
> 
> But since the public spec doesn't explicitly say it is guaranteed this doesn't
> happen when TDX is enabled, I just added this sanity check.

Okay!

> 
>>
>>>
>>> To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
>>> TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
>>> to opt-in TDX host kernel support (to distinguish with TDX guest kernel
>>> support).  So far only KVM uses TDX.  Make the new config option depend
>>> on KVM_INTEL.
>>>
>>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>>> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>
>>
>> [...]
>>
>>> ---
>>>    arch/x86/Kconfig                 |  12 ++++
>>>    arch/x86/Makefile                |   2 +
>>>    arch/x86/include/asm/msr-index.h |   3 +
>>>    arch/x86/include/asm/tdx.h       |   7 +++
>>>    arch/x86/virt/Makefile           |   2 +
>>>    arch/x86/virt/vmx/Makefile       |   2 +
>>>    arch/x86/virt/vmx/tdx/Makefile   |   2 +
>>>    arch/x86/virt/vmx/tdx/tdx.c      | 105 +++++++++++++++++++++++++++++++
>>>    8 files changed, 135 insertions(+)
>>>    create mode 100644 arch/x86/virt/Makefile
>>>    create mode 100644 arch/x86/virt/vmx/Makefile
>>>    create mode 100644 arch/x86/virt/vmx/tdx/Makefile
>>>    create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index 3604074a878b..fc010973a6ff 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -1952,6 +1952,18 @@ config X86_SGX
>>>    
>>>    	  If unsure, say N.
>>>    
>>> +config INTEL_TDX_HOST
>>> +	bool "Intel Trust Domain Extensions (TDX) host support"
>>> +	depends on CPU_SUP_INTEL
>>> +	depends on X86_64
>>> +	depends on KVM_INTEL
>>> +	help
>>> +	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>>> +	  host and certain physical attacks.  This option enables necessary TDX
>>> +	  support in host kernel to run protected VMs.
>>
>> s/in host/in the host/ ?
> 
> Sure.
> 
>>
>> Also, is "protected VMs" the right term to use here? "Encrypted VMs",
>> "Confidential VMs" ... ?
> 
> "Encrypted VM" perhaps is not a good choice, because there are more things than
> encryption.  I am also OK with "Confidential VMs", but "protected VMs" is also
> used in the KVM series (not upstreamed yet), and also used by s390 by looking at
> the git log.
> 
> So both "protected VM" and "confidential VM" work for me.
> 
> Not sure anyone else wants to comment?

I'm fine as long as it's used consistently. "Protected VM" would have 
been the one out of the 3 alternatives that I have heard least frequently.

> 
>>
> [...]
> 
>>> +static u32 tdx_global_keyid __ro_after_init;
>>> +static u32 tdx_guest_keyid_start __ro_after_init;
>>> +static u32 tdx_nr_guest_keyids __ro_after_init;
>>> +
>>> +/*
>>> + * Use tdx_global_keyid to indicate that TDX is uninitialized.
>>> + * This is used in TDX initialization error paths to take it from
>>> + * initialized -> uninitialized.
>>> + */
>>> +static void __init clear_tdx(void)
>>> +{
>>> +	tdx_global_keyid = 0;
>>> +}
>>
>> Why not set "tdx_global_keyid" last, such that you don't have to clear
>> when anything goes wrong before that? Seems more straight forward.
> 
> My thinking was by reserving the global keyid and taking it out first, I can
> check the remaining keyids for TDX guests easily:
> 
> 
> +	if (!nr_tdx_keyids) {
> +		pr_info("initialization failed: too few private KeyIDs
> available.\n");
> +		goto no_tdx;
> +	}
> 
> Otherwise need to do:
> 
> 	if (nr_tdx_keyids < 2) {
> 		...
> 	}
> 
> Also, in the later patch to handle memory hotplug we will add an additional step
> to register_memory_notifier() which can also fail, so I just introduced
> clear_tdx() here.
> 
> But nothing is big deal, and yes we can set the global keyid at last and remove
> clear_tdx().

Good, that simplifies things, thanks!

-- 
Thanks,

David / dhildenb

