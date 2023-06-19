Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79036735851
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 15:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjFSNR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 09:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjFSNRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 09:17:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C50F172B
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 06:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687180614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkl7/OAql/f43M/MBr1GZ7gscQkSnXy1/Z0UiG5toM4=;
        b=PgIkKxPUuVi4VWZF/EnAC+oCVY2WL0M/NjC0EHkle3QDwpZXecsc6LBZebmIlFBZ/9FzyS
        DENfdOnNB7NBBkkbQSDMzI9MvgNuz7dPc+5yj8Tt/Q2XFV/DnsW/ezgZUmQTgJ0eKX383Y
        vdgeTD3FyGJvgz5/ydPsT8ykJCsAIwE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-YZIXGAZmMlOKh9ir0J8irw-1; Mon, 19 Jun 2023 09:16:52 -0400
X-MC-Unique: YZIXGAZmMlOKh9ir0J8irw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-311145e2bacso1187788f8f.1
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 06:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687180611; x=1689772611;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qkl7/OAql/f43M/MBr1GZ7gscQkSnXy1/Z0UiG5toM4=;
        b=kNDD4pftbTo1hn7GyNxICn0MXP+HEA9Ki31Cp0vbBmiuguzRvoxvzNOx3V6FQLJxbb
         zXUVjgGEQCB7Nq5qgVH0YPDcfTDfcoJWpGOMHUlz/0lDDLJtRT7N/Y32sm4q6KEUalgw
         DMU3p44EBn11DAW+9HbiBYC1FqYO+A9quzCG3XkqyNkcg4SB9RwOtXp/bTw3SzEP/TNH
         euMMKLC4Ak4v2BwxAb5Q5Nl6wFRsiDcF4Rme4XC5a6kP239dVvjUlmv6NnllNUozs2cB
         3VAT+50tX7Tv+dg+mMaQxmND5z78Y0hhu0NDDuE7zrmOxH+uDUSZVxp/c3CnoSjRNtNv
         7WWw==
X-Gm-Message-State: AC+VfDyV0j4WEIQ19CpTpAKcZAeaSiOkA6Z470TaZQLJK4ZQkin29Vmb
        aPs8lTgU8ZtmitZ4Cq2Oowrghe0KEcEpYpt5tGgJ5MQjxmkat1PT49lGWbDlv4VrrJuV0sq8QeX
        fAFDrunMbVluc
X-Received: by 2002:adf:e849:0:b0:311:27bf:f9ec with SMTP id d9-20020adfe849000000b0031127bff9ecmr4932056wrn.21.1687180611058;
        Mon, 19 Jun 2023 06:16:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6eUMkRiOhkqj3R+Kc+faaknCTta5upUMsqs0nsEyjVXkgYUL1lVH+0E4qxHZvBrhI8RFMvMQ==
X-Received: by 2002:adf:e849:0:b0:311:27bf:f9ec with SMTP id d9-20020adfe849000000b0031127bff9ecmr4932030wrn.21.1687180610610;
        Mon, 19 Jun 2023 06:16:50 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72f:7100:cede:6433:a77b:41e9? (p200300cbc72f7100cede6433a77b41e9.dip0.t-ipconnect.de. [2003:cb:c72f:7100:cede:6433:a77b:41e9])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d4291000000b003047ea78b42sm31571827wrq.43.2023.06.19.06.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 06:16:49 -0700 (PDT)
Message-ID: <895f7f8d-6fd2-2098-9208-6240d2655978@redhat.com>
Date:   Mon, 19 Jun 2023 15:16:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
In-Reply-To: <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.23 16:27, Kai Huang wrote:
> To enable TDX the kernel needs to initialize TDX from two perspectives:
> 1) Do a set of SEAMCALLs to initialize the TDX module to make it ready
> to create and run TDX guests; 2) Do the per-cpu initialization SEAMCALL
> on one logical cpu before the kernel wants to make any other SEAMCALLs
> on that cpu (including those involved during module initialization and
> running TDX guests).
> 
> The TDX module can be initialized only once in its lifetime.  Instead
> of always initializing it at boot time, this implementation chooses an
> "on demand" approach to initialize TDX until there is a real need (e.g
> when requested by KVM).  This approach has below pros:
> 
> 1) It avoids consuming the memory that must be allocated by kernel and
> given to the TDX module as metadata (~1/256th of the TDX-usable memory),
> and also saves the CPU cycles of initializing the TDX module (and the
> metadata) when TDX is not used at all.
> 
> 2) The TDX module design allows it to be updated while the system is
> running.  The update procedure shares quite a few steps with this "on
> demand" initialization mechanism.  The hope is that much of "on demand"
> mechanism can be shared with a future "update" mechanism.  A boot-time
> TDX module implementation would not be able to share much code with the
> update mechanism.
> 
> 3) Making SEAMCALL requires VMX to be enabled.  Currently, only the KVM
> code mucks with VMX enabling.  If the TDX module were to be initialized
> separately from KVM (like at boot), the boot code would need to be
> taught how to muck with VMX enabling and KVM would need to be taught how
> to cope with that.  Making KVM itself responsible for TDX initialization
> lets the rest of the kernel stay blissfully unaware of VMX.
> 
> Similar to module initialization, also make the per-cpu initialization
> "on demand" as it also depends on VMX being enabled.
> 
> Add two functions, tdx_enable() and tdx_cpu_enable(), to enable the TDX
> module and enable TDX on local cpu respectively.  For now tdx_enable()
> is a placeholder.  The TODO list will be pared down as functionality is
> added.
> 
> In tdx_enable() use a state machine protected by mutex to make sure the
> initialization will only be done once, as tdx_enable() can be called
> multiple times (i.e. KVM module can be reloaded) and may be called
> concurrently by other kernel components in the future.
> 
> The per-cpu initialization on each cpu can only be done once during the
> module's life time.  Use a per-cpu variable to track its status to make
> sure it is only done once in tdx_cpu_enable().
> 
> Also, a SEAMCALL to do TDX module global initialization must be done
> once on any logical cpu before any per-cpu initialization SEAMCALL.  Do
> it inside tdx_cpu_enable() too (if hasn't been done).
> 
> tdx_enable() can potentially invoke SEAMCALLs on any online cpus.  The
> per-cpu initialization must be done before those SEAMCALLs are invoked
> on some cpu.  To keep things simple, in tdx_cpu_enable(), always do the
> per-cpu initialization regardless of whether the TDX module has been
> initialized or not.  And in tdx_enable(), don't call tdx_cpu_enable()
> but assume the caller has disabled CPU hotplug, done VMXON and
> tdx_cpu_enable() on all online cpus before calling tdx_enable().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> 
> v10 -> v11:
>   - Return -NODEV instead of -EINVAL when CONFIG_INTEL_TDX_HOST is off.
>   - Return the actual error code for tdx_enable() instead of -EINVAL.
>   - Added Isaku's Reviewed-by.
> 
> v9 -> v10:
>   - Merged the patch to handle per-cpu initialization to this patch to
>     tell the story better.
>   - Changed how to handle the per-cpu initialization to only provide a
>     tdx_cpu_enable() function to let the user of TDX to do it when the
>     user wants to run TDX code on a certain cpu.
>   - Changed tdx_enable() to not call cpus_read_lock() explicitly, but
>     call lockdep_assert_cpus_held() to assume the caller has done that.
>   - Improved comments around tdx_enable() and tdx_cpu_enable().
>   - Improved changelog to tell the story better accordingly.
> 
> v8 -> v9:
>   - Removed detailed TODO list in the changelog (Dave).
>   - Added back steps to do module global initialization and per-cpu
>     initialization in the TODO list comment.
>   - Moved the 'enum tdx_module_status_t' from tdx.c to local tdx.h
> 
> v7 -> v8:
>   - Refined changelog (Dave).
>   - Removed "all BIOS-enabled cpus" related code (Peter/Thomas/Dave).
>   - Add a "TODO list" comment in init_tdx_module() to list all steps of
>     initializing the TDX Module to tell the story (Dave).
>   - Made tdx_enable() unverisally return -EINVAL, and removed nonsense
>     comments (Dave).
>   - Simplified __tdx_enable() to only handle success or failure.
>   - TDX_MODULE_SHUTDOWN -> TDX_MODULE_ERROR
>   - Removed TDX_MODULE_NONE (not loaded) as it is not necessary.
>   - Improved comments (Dave).
>   - Pointed out 'tdx_module_status' is software thing (Dave).
> 
> v6 -> v7:
>   - No change.
> 
> v5 -> v6:
>   - Added code to set status to TDX_MODULE_NONE if TDX module is not
>     loaded (Chao)
>   - Added Chao's Reviewed-by.
>   - Improved comments around cpus_read_lock().
> 
> - v3->v5 (no feedback on v4):
>   - Removed the check that SEAMRR and TDX KeyID have been detected on
>     all present cpus.
>   - Removed tdx_detect().
>   - Added num_online_cpus() to MADT-enabled CPUs check within the CPU
>     hotplug lock and return early with error message.
>   - Improved dmesg printing for TDX module detection and initialization.
> 
> 
> ---
>   arch/x86/include/asm/tdx.h  |   4 +
>   arch/x86/virt/vmx/tdx/tdx.c | 179 ++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h |  13 +++
>   3 files changed, 196 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index b489b5b9de5d..03f74851608f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -102,8 +102,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
>   bool platform_tdx_enabled(void);
> +int tdx_cpu_enable(void);
> +int tdx_enable(void);
>   #else	/* !CONFIG_INTEL_TDX_HOST */
>   static inline bool platform_tdx_enabled(void) { return false; }
> +static inline int tdx_cpu_enable(void) { return -ENODEV; }
> +static inline int tdx_enable(void)  { return -ENODEV; }
>   #endif	/* CONFIG_INTEL_TDX_HOST */
>   
>   #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e62e978eba1b..bcf2b2d15a2e 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,10 @@
>   #include <linux/errno.h>
>   #include <linux/printk.h>
>   #include <linux/smp.h>
> +#include <linux/cpu.h>
> +#include <linux/spinlock.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/mutex.h>
>   #include <asm/msr-index.h>
>   #include <asm/msr.h>
>   #include <asm/archrandom.h>
> @@ -23,6 +27,18 @@ static u32 tdx_global_keyid __ro_after_init;
>   static u32 tdx_guest_keyid_start __ro_after_init;
>   static u32 tdx_nr_guest_keyids __ro_after_init;
>   
> +static unsigned int tdx_global_init_status;
> +static DEFINE_RAW_SPINLOCK(tdx_global_init_lock);
> +#define TDX_GLOBAL_INIT_DONE	_BITUL(0)
> +#define TDX_GLOBAL_INIT_FAILED	_BITUL(1)
> +
> +static DEFINE_PER_CPU(unsigned int, tdx_lp_init_status);
> +#define TDX_LP_INIT_DONE	_BITUL(0)
> +#define TDX_LP_INIT_FAILED	_BITUL(1)

I'm curious, why do we have to track three states: uninitialized 
(!done), initialized (done + ! failed), permanent error (done + failed).

[besides: why can't you use an enum and share that between global and pcpu?]

Why can't you have a pcpu "bool tdx_lp_initialized" and "bool 
tdx_global_initialized"?

I mean, if there was an error during previous initialization, it's not 
initialized: you'd try initializing again -- and possibly fail again -- 
on the next attempt. I doubt that a "try to cache failed status to keep 
failing fast" is really required.

Is there any other reason (e.g., second init attempt would set your 
computer on fire) why it can't be simpler?


[...]

-- 
Cheers,

David / dhildenb

