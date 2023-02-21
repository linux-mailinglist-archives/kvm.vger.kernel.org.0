Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4586A69E8CE
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 21:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjBUUEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 15:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjBUUEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 15:04:52 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EF21CAC4
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 12:04:25 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id p8so5823042wrt.12
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 12:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EIb2flwMflqFym3iTYzvFjM/prFop9ypIVwQwGI/2Aw=;
        b=m9k35q0U65PVXWlf0RAcVdHkw968UFoeZUUNEsFwhXdKsZV1N51O59YraeHSpefpwX
         OoOkEgzVEq2YiBQNLnp9lp1vRQdtT5TLuq3gCgL6hBsiPMk2NQS+yUeSzMXmfX+q9R07
         jEAw4IH+m4PYq2MRbgaV8qigfz8XkdrPM1ISUEB7DFs0YHEC7v5liiuSNfAZVPHYxVKS
         EQ3xJ5Mfj9z/INdXng/xuEkWYqSeTbj9JWcsWs5hffUxyY32TOKsHX+AqNDKs/0bg/uy
         aKss3vqE7njgtfy5R0WKVWWdjvAnlzEhXwUNL3XGiteWity77ETTTqiEnFOd07t9s2S0
         ib3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EIb2flwMflqFym3iTYzvFjM/prFop9ypIVwQwGI/2Aw=;
        b=4oHqY50q+QjInDZKvpIsanvduoHCL6o1NMwXEWzfvVLejT6adTMwdPDFjUmDilmOtY
         wzEckD7YHX56w2bXHurEIaeMol7+Xcudh8BXPfkHtLkZkzKwPguwTKLEYSZMlV7N3dNm
         f//gawIjiVMBk8W7Ztxs29ltkTcyJtiEpZKikidDEwOPTXj9x2pf/1IwKZxfT1CeoUXj
         twUCaUPLrNM17IS4YliP6h57ca8N/zHeD8V935r69H9osikR9bQBVVWBpGCiY8btIZU5
         +FvOBFJHVpzsvhVplHG9L6jPcTTtVH2h9hy+K9MI7kwWFivKYoKr309CrGSAiiwLm7lN
         5DSg==
X-Gm-Message-State: AO0yUKX9fOnotZn7gSop+bTbi3K3nMj7LTi5nnE4MxIGv8VP2TRKgjg6
        LefPGmuW4aqjxRiNfX6iH15wgA==
X-Google-Smtp-Source: AK7set/YVRsOSZcF1OgUYNXH/U5F94pPl7UST7vpCkjPcwkP41OV1DDZZDVFktbMuczhP52/fsVb2w==
X-Received: by 2002:a5d:5087:0:b0:2c5:60a9:9cd2 with SMTP id a7-20020a5d5087000000b002c560a99cd2mr4266245wrt.28.1677009863796;
        Tue, 21 Feb 2023 12:04:23 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:1a14:8be6:b3a9:a95e? ([2a02:6b6a:b566:0:1a14:8be6:b3a9:a95e])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d5228000000b002c70851bfcasm818024wra.28.2023.02.21.12.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:04:23 -0800 (PST)
Message-ID: <538080af-b876-6462-c591-be66dceb4b8d@bytedance.com>
Date:   Tue, 21 Feb 2023 20:04:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <f71275dc809cfb32df513023786c3faa@natalenko.name>
 <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
 <9153284c37a79d303aa79dbf07c10329@natalenko.name>
 <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/02/2023 19:10, David Woodhouse wrote:
> On Tue, 2023-02-21 at 13:14 +0100, Oleksandr Natalenko wrote:
>>
>> With this in place:
>>
>> ```
>>          early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(0);
>>          initial_gs = per_cpu_offset(0);
>>          smpboot_control = 0;
>> ```
>>
>> the resume does not work.
> 
> Yeah, I think it's always running on CPU0 after the other CPUs are
> taken down anyway.
> 
> We definitely *do* need to clear smpboot_control because we absolutely
> want it using the temp_stack we explicitly put into initial_stack, not
> finding its own idle thread.
> 
> The problem was that it was never being restored to STARTUP_SECONDARY
> in the parallel modes, because that's a one-time setup in
> native_smp_prepare_cpus(). So we can just restore it in
> arch_thaw_secondary_cpus_begin() too, by working this into patch 6 of
> the series.
> 
> (Usama, I think my tree is fairly out of date now so I'll let you do
> that? Thanks!).
>Sounds good! Will send out the next revision with below diff, checkpatch 
fixes and rebased to 6.2 (testing it now). The below fix looks good! 
Oleksandr, would you mind testing out suspend/resume with the below diff 
on your AMD machine just to make sure it fixes the issue before I send 
out the next revision with it. Thanks!

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 50621793671d..3db77a257ae2 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1571,6 +1571,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>   
>   void arch_thaw_secondary_cpus_begin(void)
>   {
> +	/*
> +	 * On suspend, smpboot_control will have been zeroed to allow the
> +	 * boot CPU to use explicitly passed values including a temporary
> +	 * stack. Since native_smp_prepare_cpus() won't be called again,
> +	 * restore the appropriate value for the parallel startup modes.
> +	 */
> +	if (do_parallel_bringup) {
> +		smpboot_control = STARTUP_SECONDARY |
> +			(x2apic_mode ? STARTUP_APICID_CPUID_0B : STARTUP_APICID_CPUID_01);
> +	}
> +
>   	set_cache_aps_delayed_init(true);
>   }
>   
> 
