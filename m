Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2934B6B1513
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 23:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjCHW1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 17:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjCHW1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 17:27:43 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D94C4E8E;
        Wed,  8 Mar 2023 14:27:42 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id y10so213018pfi.8;
        Wed, 08 Mar 2023 14:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678314462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2xuYo+kEimI1JiWgrDooT7VycvX93kcpUx+pvKWDXsg=;
        b=HW44QUqUrTulduLimbW/0ulFslu4t1IyWgiO8czxGolwDQNkIIWrGgQtiL+BWQV+4u
         Q35ROKKbVX/y8HJbLCI7vydrU6kGrnQMI48oGjeFlXLp53/NL35vYj5UF250tGwsSfuT
         YPIJ9+qtw6i0IGAXKlooWfW1ntkkzQfWV014VlO2yCOse2CTDp8zm43XhwjwKNjTKuyO
         S06NzJm4WqrVHAoNGEvbR9QuFoqD1FyWk3DgE78xcnB2wa/4xNiu8E1i6Oy50/EXW4Uz
         HuE9Iyeo80EEd6x/SS1yoN5S40lG/tU4487NpUIOSwNlAbnuLjdKAUBwJc/PCEd9Dpir
         zK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678314462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2xuYo+kEimI1JiWgrDooT7VycvX93kcpUx+pvKWDXsg=;
        b=cJhSr2gE3l7HXIEM2xLY6lENi1UygtHby+eRSyu3xsp1ekNTwhsB/JxLvZUKjcPk2S
         D2w8qcXIbS0Xo2kCfHUyLA4CmJl5451ZgdYPTsPkBPjMaXNKY4kxNisV23WewNBP9yyZ
         vybMiMv2kfDi3pRDOrG8TrivKelCgYIEP8tr5JeeHuhvTUtAw97OhOB0Cx4u3WG5LeZD
         H8UUEOAxGpvOYslBxwaqf4VJPSxdGji+Z0NwCwWihC/VEhPSxnyC514JbW5cAs/sePC/
         hhvTlnExlh41YQYTOE9LMDVcm/aMwa2nVpoVC4a9nVYLC6okhoWvWYioz6w4LMV630AV
         ICMg==
X-Gm-Message-State: AO0yUKXL8xhUupq/0CsRZGjyVfhgdB6ZOP80VBBn9MHP4GQy9DjWhW9M
        Z+QUnDxNjSdmDCOtyh3HUAs=
X-Google-Smtp-Source: AK7set8Mc+3El3Q5EC7SwuesaEtyAyOhkePWm7aBpLdQ9ANVI9cPkvALV47exu6fIRaRcJa0N7y9tA==
X-Received: by 2002:a62:848d:0:b0:593:89ab:2ec4 with SMTP id k135-20020a62848d000000b0059389ab2ec4mr21105276pfd.10.1678314461447;
        Wed, 08 Mar 2023 14:27:41 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id c24-20020aa78818000000b005d3901948d8sm9800589pfo.44.2023.03.08.14.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 14:27:40 -0800 (PST)
Date:   Wed, 8 Mar 2023 14:27:38 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230308222738.GA3419702@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 03:13:50AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

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
> "on demand" as it also depends on VMX to be enabled.
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
> but assume the caller has disabled CPU hotplug and done VMXON and
> tdx_cpu_enable() on all online cpus before calling tdx_enable().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v9 -> v10:
>  - Merged the patch to handle per-cpu initialization to this patch to
>    tell the story better.
>  - Changed how to handle the per-cpu initialization to only provide a
>    tdx_cpu_enable() function to let the user of TDX to do it when the
>    user wants to run TDX code on a certain cpu.
>  - Changed tdx_enable() to not call cpus_read_lock() explicitly, but
>    call lockdep_assert_cpus_held() to assume the caller has done that.
>  - Improved comments around tdx_enable() and tdx_cpu_enable().
>  - Improved changelog to tell the story better accordingly.
> 
> v8 -> v9:
>  - Removed detailed TODO list in the changelog (Dave).
>  - Added back steps to do module global initialization and per-cpu
>    initialization in the TODO list comment.
>  - Moved the 'enum tdx_module_status_t' from tdx.c to local tdx.h
> 
> v7 -> v8:
>  - Refined changelog (Dave).
>  - Removed "all BIOS-enabled cpus" related code (Peter/Thomas/Dave).
>  - Add a "TODO list" comment in init_tdx_module() to list all steps of
>    initializing the TDX Module to tell the story (Dave).
>  - Made tdx_enable() unverisally return -EINVAL, and removed nonsense
>    comments (Dave).
>  - Simplified __tdx_enable() to only handle success or failure.
>  - TDX_MODULE_SHUTDOWN -> TDX_MODULE_ERROR
>  - Removed TDX_MODULE_NONE (not loaded) as it is not necessary.
>  - Improved comments (Dave).
>  - Pointed out 'tdx_module_status' is software thing (Dave).
> 
> v6 -> v7:
>  - No change.
> 
> v5 -> v6:
>  - Added code to set status to TDX_MODULE_NONE if TDX module is not
>    loaded (Chao)
>  - Added Chao's Reviewed-by.
>  - Improved comments around cpus_read_lock().
> 
> - v3->v5 (no feedback on v4):
>  - Removed the check that SEAMRR and TDX KeyID have been detected on
>    all present cpus.
>  - Removed tdx_detect().
>  - Added num_online_cpus() to MADT-enabled CPUs check within the CPU
>    hotplug lock and return early with error message.
>  - Improved dmesg printing for TDX module detection and initialization.
> 
> ---
>  arch/x86/include/asm/tdx.h  |   4 +
>  arch/x86/virt/vmx/tdx/tdx.c | 182 ++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h |  25 +++++
>  3 files changed, 211 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index b489b5b9de5d..112a5b9bd5cd 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -102,8 +102,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
>  bool platform_tdx_enabled(void);
> +int tdx_cpu_enable(void);
> +int tdx_enable(void);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
> +static inline int tdx_cpu_enable(void) { return -EINVAL; }
> +static inline int tdx_enable(void)  { return -EINVAL; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index b65b838f3b5d..29127cb70f51 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,10 @@
>  #include <linux/errno.h>
>  #include <linux/printk.h>
>  #include <linux/smp.h>
> +#include <linux/cpu.h>
> +#include <linux/spinlock.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/mutex.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/tdx.h>
> @@ -22,6 +26,18 @@ static u32 tdx_global_keyid __ro_after_init;
>  static u32 tdx_guest_keyid_start __ro_after_init;
>  static u32 tdx_nr_guest_keyids __ro_after_init;
>  
> +static unsigned int tdx_global_init_status;
> +static DEFINE_SPINLOCK(tdx_global_init_lock);
> +#define TDX_GLOBAL_INIT_DONE	_BITUL(0)
> +#define TDX_GLOBAL_INIT_FAILED	_BITUL(1)
> +
> +static DEFINE_PER_CPU(unsigned int, tdx_lp_init_status);
> +#define TDX_LP_INIT_DONE	_BITUL(0)
> +#define TDX_LP_INIT_FAILED	_BITUL(1)
> +
> +static enum tdx_module_status_t tdx_module_status;
> +static DEFINE_MUTEX(tdx_module_lock);
> +
>  /*
>   * Use tdx_global_keyid to indicate that TDX is uninitialized.
>   * This is used in TDX initialization error paths to take it from
> @@ -159,3 +175,169 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	put_cpu();
>  	return ret;
>  }
> +
> +static int try_init_module_global(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * The TDX module global initialization only needs to be done
> +	 * once on any cpu.
> +	 */
> +	spin_lock(&tdx_global_init_lock);
> +
> +	if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
> +		ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
> +			-EINVAL : 0;
> +		goto out;
> +	}
> +
> +	/* All '0's are just unused parameters. */
> +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> +
> +	tdx_global_init_status = TDX_GLOBAL_INIT_DONE;
> +	if (ret)
> +		tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;

If entropy is lacking (rdrand failure), TDH_SYS_INIT can return TDX_SYS_BUSY.
In such case, we should allow the caller to retry or make this function retry
instead of marking error stickily.

Except that,
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
