Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1951B70688D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 14:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjEQMr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 08:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjEQMrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 08:47:25 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A61512C;
        Wed, 17 May 2023 05:47:24 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.186.50.133])
        by linux.microsoft.com (Postfix) with ESMTPSA id D164820F069A;
        Wed, 17 May 2023 05:47:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D164820F069A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1684327643;
        bh=LhIkPpJhPvIClwJ39pJZmrIh6zoXx6jE68xfB8W+VWs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mumhyWRm4PGisYlV+6k79BLPaamhkccyeiIlh7D48PRTzPjbzjxh2vVIF5IMgB/kg
         ffvKm60yYk2+lOntvrropzUTEW8F4BOwI+8ppjyBg+mNGMVj/ubDGGKoWDypVfUwG4
         iLdY81ZYifmsEzXVwEDBYtRVqeqDXr8NLjfUncbw=
Message-ID: <e8fcc1b8-6c0f-9556-a110-bd994d3fe3c6@linux.microsoft.com>
Date:   Wed, 17 May 2023 07:47:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 3/9] virt: Implement Heki common code
To:     Wei Liu <wei.liu@kernel.org>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?Q?=c8=98tefan_=c8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-4-mic@digikod.net>
 <ZFkxhWhjyIzrPkt8@liuwe-devbox-debian-v2>
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <ZFkxhWhjyIzrPkt8@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-21.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the delay. See inline...

On 5/8/23 12:29, Wei Liu wrote:
> On Fri, May 05, 2023 at 05:20:40PM +0200, Mickaël Salaün wrote:
>> From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>>
>> Hypervisor Enforced Kernel Integrity (Heki) is a feature that will use
>> the hypervisor to enhance guest virtual machine security.
>>
>> Configuration
>> =============
>>
>> Define the config variables for the feature. This feature depends on
>> support from the architecture as well as the hypervisor.
>>
>> Enabling HEKI
>> =============
>>
>> Define a kernel command line parameter "heki" to turn the feature on or
>> off. By default, Heki is on.
> 
> For such a newfangled feature can we have it off by default? Especially
> when there are unsolved issues around dynamically loaded code.
> 

Yes. We can certainly do that.

>>
> [...]
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 3604074a878b..5cf5a7a97811 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -297,6 +297,7 @@ config X86
>>  	select FUNCTION_ALIGNMENT_4B
>>  	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>  	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> +	select ARCH_SUPPORTS_HEKI		if X86_64
> 
> Why is there a restriction on X86_64?
> 

We want to get the PoC working and reviewed on X64 first. We have tested this only on X64 so far.

>>  
>>  config INSTRUCTION_DECODER
>>  	def_bool y
>> diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
>> index a6e8373a5170..42ef1e33b8a5 100644
>> --- a/arch/x86/include/asm/sections.h
>> +++ b/arch/x86/include/asm/sections.h
> [...]
>>  
>> +#ifdef CONFIG_HEKI
>> +
>> +/*
>> + * Gather all of the statically defined sections so heki_late_init() can
>> + * protect these sections in the host page table.
>> + *
>> + * The sections are defined under "SECTIONS" in vmlinux.lds.S
>> + * Keep this array in sync with SECTIONS.
>> + */
> 
> This seems a bit fragile, because it requires constant attention from
> people who care about this functionality. Can this table be
> automatically generated?
> 

We realize that. But I don't know of a way this can be automatically generated. Also, the permissions for
each section is specific to the use of that section. The developer who introduces a new section is the
one who will know what the permissions should be.

If any one has any ideas of how we can generate this table automatically or even just add a build time check
of some sort, please let us know.

Thanks.

Madhavan

> Thanks,
> Wei.
> 
>> +struct heki_va_range __initdata heki_va_ranges[] = {
>> +	{
>> +		.va_start = _stext,
>> +		.va_end = _etext,
>> +		.attributes = HEKI_ATTR_MEM_NOWRITE | HEKI_ATTR_MEM_EXEC,
>> +	},
>> +	{
>> +		.va_start = __start_rodata,
>> +		.va_end = __end_rodata,
>> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
>> +	},
>> +#ifdef CONFIG_UNWINDER_ORC
>> +	{
>> +		.va_start = __start_orc_unwind_ip,
>> +		.va_end = __stop_orc_unwind_ip,
>> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
>> +	},
>> +	{
>> +		.va_start = __start_orc_unwind,
>> +		.va_end = __stop_orc_unwind,
>> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
>> +	},
>> +	{
>> +		.va_start = orc_lookup,
>> +		.va_end = orc_lookup_end,
>> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
>> +	},
>> +#endif /* CONFIG_UNWINDER_ORC */
>> +};
>> +
