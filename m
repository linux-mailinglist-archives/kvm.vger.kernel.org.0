Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF36634340
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 19:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiKVSGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 13:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiKVSGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 13:06:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCE66A760;
        Tue, 22 Nov 2022 10:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669140362; x=1700676362;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NqGjlbIkPNWOGloMRZM2TX/+oGAXDSpMzfHC29CcdNU=;
  b=beI5XsWMMwhKKi/XAsNPci6+cy+jVij/bPJplxkR3qEgJc8iG/JYDS4q
   0DVbT1bMqtmYA7KbvylPkuDgmSjEsTFw5wUC8zZ865OFfsYugkTa7rIGR
   iXRMJPi096qN4MeTAfg0XaBOteM6MicNYNnj2wPvRRPezgoFQfoFwZrGP
   BdWLQnYFXOMIluDm4Fzk/BDgRiOMoUhdWNzXCldJfYbFaxk1uvkCj2IuX
   ioEmhzNzP1moyk8Rhc3p54OedI12bh0usvGckpTBob26EzdoX7DK6R9gx
   9hCzruWPwdVW8CFgf6xrr77ufQRzdLbRiVi5cP7mLKh67oSny0UlP362N
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293587390"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="293587390"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 10:06:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="970557030"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="970557030"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 10:05:59 -0800
Message-ID: <ea588f69-3b9e-b0ec-e5e1-a174d6031681@intel.com>
Date:   Tue, 22 Nov 2022 10:05:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> 2) It is more flexible to support TDX module runtime updating in the
> future (after updating the TDX module, it needs to be initialized
> again).

I hate this generic blabber about "more flexible".  There's a *REASON*
it's more flexible, so let's talk about the reasons, please.

It's really something like this, right?

	The TDX module design allows it to be updated while the system
	is running.  The update procedure shares quite a few steps with
	this "on demand" loading mechanism.  The hope is that much of
	this "on demand" mechanism can be shared with a future "update"
	mechanism.  A boot-time TDX module implementation would not be
	able to share much code with the update mechanism.


> 3) It avoids having to do a "temporary" solution to handle VMXON in the
> core (non-KVM) kernel for now.  This is because SEAMCALL requires CPU
> being in VMX operation (VMXON is done), but currently only KVM handles
> VMXON.  Adding VMXON support to the core kernel isn't trivial.  More
> importantly, from long-term a reference-based approach is likely needed
> in the core kernel as more kernel components are likely needed to
> support TDX as well.  Allow KVM to initialize the TDX module avoids
> having to handle VMXON during kernel boot for now.

There are a lot of words in there.

3) Loading the TDX module requires VMX to be enabled.  Currently, only
   the kernel KVM code mucks with VMX enabling.  If the TDX module were
   to be initialized separately from KVM (like at boot), the boot code
   would need to be taught how to muck with VMX enabling and KVM would
   need to be taught how to cope with that.  Making KVM itself
   responsible for TDX initialization lets the rest of the kernel stay
   blissfully unaware of VMX.

> Add a placeholder tdx_enable() to detect and initialize the TDX module
> on demand, with a state machine protected by mutex to support concurrent
> calls from multiple callers.

As opposed to concurrent calls from one caller? ;)

> The TDX module will be initialized in multi-steps defined by the TDX
> module:
> 
>   1) Global initialization;
>   2) Logical-CPU scope initialization;
>   3) Enumerate the TDX module capabilities and platform configuration;
>   4) Configure the TDX module about TDX usable memory ranges and global
>      KeyID information;
>   5) Package-scope configuration for the global KeyID;
>   6) Initialize usable memory ranges based on 4).

This would actually be a nice place to call out the SEAMCALL names and
mention that each of these steps involves a set of SEAMCALLs.

> The TDX module can also be shut down at any time during its lifetime.
> In case of any error during the initialization process, shut down the
> module.  It's pointless to leave the module in any intermediate state
> during the initialization.
> 
> Both logical CPU scope initialization and shutting down the TDX module
> require calling SEAMCALL on all boot-time present CPUs.  For simplicity
> just temporarily disable CPU hotplug during the module initialization.

You might want to more precisely define "boot-time present CPUs".  The
boot of *what*?

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 8d943bdc8335..28c187b8726f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -10,15 +10,34 @@
>  #include <linux/types.h>
>  #include <linux/init.h>
>  #include <linux/printk.h>
> +#include <linux/mutex.h>
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/apic.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> +/* TDX module status during initialization */
> +enum tdx_module_status_t {
> +	/* TDX module hasn't been detected and initialized */
> +	TDX_MODULE_UNKNOWN,
> +	/* TDX module is not loaded */
> +	TDX_MODULE_NONE,
> +	/* TDX module is initialized */
> +	TDX_MODULE_INITIALIZED,
> +	/* TDX module is shut down due to initialization error */
> +	TDX_MODULE_SHUTDOWN,
> +};

Are these part of the ABI or just a purely OS-side construct?

>  static u32 tdx_keyid_start __ro_after_init;
>  static u32 tdx_keyid_num __ro_after_init;
>  
> +static enum tdx_module_status_t tdx_module_status;
> +/* Prevent concurrent attempts on TDX detection and initialization */
> +static DEFINE_MUTEX(tdx_module_lock);
> +
>  /*
>   * Detect TDX private KeyIDs to see whether TDX has been enabled by the
>   * BIOS.  Both initializing the TDX module and running TDX guest require
> @@ -104,3 +123,134 @@ bool platform_tdx_enabled(void)
>  {
>  	return !!tdx_keyid_num;
>  }
> +
> +/*
> + * Detect and initialize the TDX module.
> + *
> + * Return -ENODEV when the TDX module is not loaded, 0 when it
> + * is successfully initialized, or other error when it fails to
> + * initialize.
> + */
> +static int init_tdx_module(void)
> +{
> +	/* The TDX module hasn't been detected */
> +	return -ENODEV;
> +}
> +
> +static void shutdown_tdx_module(void)
> +{
> +	/* TODO: Shut down the TDX module */
> +}
> +
> +static int __tdx_enable(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * Initializing the TDX module requires doing SEAMCALL on all
> +	 * boot-time present CPUs.  For simplicity temporarily disable
> +	 * CPU hotplug to prevent any CPU from going offline during
> +	 * the initialization.
> +	 */
> +	cpus_read_lock();
> +
> +	/*
> +	 * Check whether all boot-time present CPUs are online and
> +	 * return early with a message so the user can be aware.
> +	 *
> +	 * Note a non-buggy BIOS should never support physical (ACPI)
> +	 * CPU hotplug when TDX is enabled, and all boot-time present
> +	 * CPU should be enabled in MADT, so there should be no
> +	 * disabled_cpus and num_processors won't change at runtime
> +	 * either.
> +	 */

Again, there are a lot of words in that comment, but I'm not sure why
it's here.  Despite all the whinging about ACPI, doesn't it boil down to:

	The TDX module itself establishes its own concept of how many
	logical CPUs there are in the system when it is loaded.  The
	module will reject initialization attempts unless the kernel
	runs TDX initialization code on every last CPU.

	Ensure that the kernel is able to run code on all known logical
	CPUs.

and these checks are just to see if the kernel has shot itself in the
foot and is *KNOWS* that it is currently unable to run code on some
logical CPU?

> +	if (disabled_cpus || num_online_cpus() != num_processors) {
> +		pr_err("Unable to initialize the TDX module when there's offline CPU(s).\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = init_tdx_module();
> +	if (ret == -ENODEV) {

Why check for -ENODEV exclusively?  Is there some other error nonzero
code that indicates success?

> +		pr_info("TDX module is not loaded.\n");
> +		tdx_module_status = TDX_MODULE_NONE;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Shut down the TDX module in case of any error during the
> +	 * initialization process.  It's meaningless to leave the TDX
> +	 * module in any middle state of the initialization process.
> +	 *
> +	 * Shutting down the module also requires doing SEAMCALL on all
> +	 * MADT-enabled CPUs.  Do it while CPU hotplug is disabled.
> +	 *
> +	 * Return all errors during the initialization as -EFAULT as the
> +	 * module is always shut down.
> +	 */
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module. Shut it down.\n");

"Shut it down" seems wrong here.  That could be interpreted as "I have
already shut it down".  "Shutting down" seems better.

> +		shutdown_tdx_module();
> +		tdx_module_status = TDX_MODULE_SHUTDOWN;
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	pr_info("TDX module initialized.\n");
> +	tdx_module_status = TDX_MODULE_INITIALIZED;
> +out:
> +	cpus_read_unlock();
> +
> +	return ret;
> +}
> +
> +/**
> + * tdx_enable - Enable TDX by initializing the TDX module
> + *
> + * Caller to make sure all CPUs are online and in VMX operation before
> + * calling this function.  CPU hotplug is temporarily disabled internally
> + * to prevent any cpu from going offline.

"cpu" or "CPU"?

> + * This function can be called in parallel by multiple callers.
> + *
> + * Return:
> + *
> + * * 0:		The TDX module has been successfully initialized.
> + * * -ENODEV:	The TDX module is not loaded, or TDX is not supported.
> + * * -EINVAL:	The TDX module cannot be initialized due to certain
> + *		conditions are not met (i.e. when not all MADT-enabled
> + *		CPUs are not online).
> + * * -EFAULT:	Other internal fatal errors, or the TDX module is in
> + *		shutdown mode due to it failed to initialize in previous
> + *		attempts.
> + */

I honestly don't think all these error codes mean anything.  They're
plumbed nowhere and the use of -EFAULT is just plain wrong.

Nobody can *DO* anything with these anyway.

Just give one error code and make sure that you have pr_info()'s around
to make it clear what went wrong.  Then just do -EINVAL universally.
Remove all the nonsense comments.

> +int tdx_enable(void)
> +{
> +	int ret;
> +
> +	if (!platform_tdx_enabled())
> +		return -ENODEV;
> +
> +	mutex_lock(&tdx_module_lock);
> +
> +	switch (tdx_module_status) {
> +	case TDX_MODULE_UNKNOWN:
> +		ret = __tdx_enable();
> +		break;
> +	case TDX_MODULE_NONE:
> +		ret = -ENODEV;
> +		break;

TDX_MODULE_NONE should probably be called TDX_MODULE_NOT_LOADED.  A
comment would also be nice:

	/* The BIOS did not load the module.  No way to fix that. */

> +	case TDX_MODULE_INITIALIZED:

		/* Already initialized, great, tell the caller: */

> +		ret = 0;
> +		break;
> +	default:
> +		WARN_ON_ONCE(tdx_module_status != TDX_MODULE_SHUTDOWN);
> +		ret = -EFAULT;
> +		break;
> +	}

I don't get what that default: is for or what it has to do with
TDX_MODULE_SHUTDOWN.


> +	mutex_unlock(&tdx_module_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdx_enable);

