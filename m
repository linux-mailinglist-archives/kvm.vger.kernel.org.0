Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75F1742503
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 13:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjF2Lcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 07:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjF2Lcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 07:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FDC10F0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 04:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688038310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GoRf97kbYDZBwP3J/hRLkmLH66DPLZ1hXk0cIFzlfrw=;
        b=UHqhwF6xjt988sSEBupUu9ISBiXf7lhcEpC5VewolOS7sQ5EwrDDq53s0F2/b98ILu4Jyv
        c0y1aaIa/N5nP542j2L9rbpreLXYfznkGJMUhAIEy7z+pAdw3dY0L7b+btjIfTKcLliIn4
        MkRyF9HBJ4u2oXIj1CYQuju7UOKyirY=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-2oI2hrYoNwCoIeFaTeR0vw-1; Thu, 29 Jun 2023 07:31:47 -0400
X-MC-Unique: 2oI2hrYoNwCoIeFaTeR0vw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f76712f950so581482e87.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 04:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688038306; x=1690630306;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GoRf97kbYDZBwP3J/hRLkmLH66DPLZ1hXk0cIFzlfrw=;
        b=Dx+U/2srWUtI0iKRNKFKu2oa5JmnRvVd/EL8FJfDT6TyK1DAvbbK8kNfhr6hAsJ7/K
         Ymhn3CpTFLrKtN0o1iIEWdB7MUzNtOH6xfOx62B+DLaYuG/E5ZJLRBDuEpieOyGuBCS7
         6QTHqwtcxxj+fd0Du+OLNDcRxJSJRFCt4h9FBAofjGW40voV/g20EDyx7wdAZlsbgPVf
         HF/vzGte2ppHTTOe1v3/ZHwRCg0gpxLWEXBZbTcqopTeRkTiRWbyjiIG77GMYEr1djqZ
         5+S4kFKhrNElGL6T7FdCZiKvcqF9w3Aat6mWrAYpeZgUZ1lBDpetFV2s/wV27orrbjgP
         KNWQ==
X-Gm-Message-State: ABy/qLYfrrw9ra0M5u6596jPLNUkLdaBsHLXn5Au9kOO0eGMXGBj3mfG
        CJhzVLzkVd/vuk2HH5XB66VQuc4tCwAtYWqwL5Zrkm/pn5I/PE9hNOdA6+X7PmXAkN1Ko017E8K
        LD9gKVuJotHzG
X-Received: by 2002:ac2:4c48:0:b0:4fb:9595:15e9 with SMTP id o8-20020ac24c48000000b004fb959515e9mr3245790lfk.22.1688038305948;
        Thu, 29 Jun 2023 04:31:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ759QKQQgqTCxa6IKWpXNlinwcvLHmiY40QmBJrFlDbDPxQTAATynaKDRxhNlc/1jVC7j3A+Q==
X-Received: by 2002:ac2:4c48:0:b0:4fb:9595:15e9 with SMTP id o8-20020ac24c48000000b004fb959515e9mr3245756lfk.22.1688038305499;
        Thu, 29 Jun 2023 04:31:45 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id hn8-20020a05600ca38800b003fa722e8b48sm19303141wmb.32.2023.06.29.04.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 04:31:45 -0700 (PDT)
Message-ID: <bd9ce008-528b-2009-b157-6d69f1cf5530@redhat.com>
Date:   Thu, 29 Jun 2023 13:31:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.06.23 16:12, Kai Huang wrote:
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
> Export both tdx_cpu_enable() and tdx_enable() for KVM use.
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
> ---
> 
> v11 -> v12:
>   - Simplified TDX module global init and lp init status tracking (David).
>   - Added comment around try_init_module_global() for using
>     raw_spin_lock() (Dave).
>   - Added one sentence to changelog to explain why to expose tdx_enable()
>     and tdx_cpu_enable() (Dave).
>   - Simplifed comments around tdx_enable() and tdx_cpu_enable() to use
>     lockdep_assert_*() instead. (Dave)
>   - Removed redundent "TDX" in error message (Dave).
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
>   arch/x86/virt/vmx/tdx/tdx.c | 162 ++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h |  13 +++
>   3 files changed, 179 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 4dfe2e794411..d8226a50c58c 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -97,8 +97,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
> index 141d12376c4d..29ca18f66d61 100644
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
> @@ -23,6 +27,13 @@ static u32 tdx_global_keyid __ro_after_init;
>   static u32 tdx_guest_keyid_start __ro_after_init;
>   static u32 tdx_nr_guest_keyids __ro_after_init;
>   
> +static bool tdx_global_initialized;
> +static DEFINE_RAW_SPINLOCK(tdx_global_init_lock);
> +static DEFINE_PER_CPU(bool, tdx_lp_initialized);
> +
> +static enum tdx_module_status_t tdx_module_status;

Why can't you switch to a simple bool here as well?

It's either initialized or uninitialized. If uninitialized and you get 
an error, leave it uninitialized. The next caller will try again and 
fail again.

-- 
Cheers,

David / dhildenb

