Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031A5508034
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 06:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359317AbiDTEk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 00:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359299AbiDTEkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 00:40:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A51A819;
        Tue, 19 Apr 2022 21:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650429455; x=1681965455;
  h=message-id:subject:from:to:cc:in-reply-to:references:
   mime-version:date:content-transfer-encoding;
  bh=JGHVxQmvQ1Ff7igrrS3X4Y8AJbzw2ajXfF/fr+Fs8BQ=;
  b=HR2JkQydhsrxC4zfT59y61XxJvl3POV5HOXzVAefanyNhQylOmkinQ8P
   +FTOcbfsoMA2rZSRcuKPpJad2dVmI2SFx8Z5f3bG9x8PGOy1agWeR6inL
   X9OXtUeDrxQlFSHaCpX6Yq/ePlw/iF2nrhsdu1B8Rug+8ersHeoJ4mf9m
   Me2QRpZ/UScXdWlp+kG+94wG8+v3d+zUZouWLDvHeZ2SRtBJBjEVn8352
   Iry2Z8HS8s9AGQjd3AIBnXDYB8tMy9ED1rLCBA9srX0vWNtyuIn8X6z4W
   i993+Vgr41zQZyaOC8l35YCJ1Ktv9GekJRczcAiIRz5WvHNDbv4EPrPxS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263700125"
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="263700125"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 21:37:35 -0700
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="667717035"
Received: from rnmatson-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.31.26])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 21:37:32 -0700
Message-ID: <fd954918981d5c823a8c2b8d1b346d4eb13f334f.camel@intel.com>
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
In-Reply-To: <bc078c41-89fd-0a24-7d8e-efcd5a697686@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <bc078c41-89fd-0a24-7d8e-efcd5a697686@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Wed, 20 Apr 2022 16:37:11 +1200
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-19 at 07:53 -0700, Sathyanarayanan Kuppuswamy wrote:
> 
> On 4/5/22 9:49 PM, Kai Huang wrote:
> > The TDX module is essentially a CPU-attested software module running
> > in the new Secure Arbitration Mode (SEAM) to protect VMs from malicious
> > host and certain physical attacks.  The TDX module implements the
> 
> /s/host/hosts

I don't quite get.  Could you explain why there are multiple hosts?

> 
> > functions to build, tear down and start execution of the protected VMs
> > called Trusted Domains (TD).  Before the TDX module can be used to
> 
> /s/Trusted/Trust

Thanks.

> 
> > create and run TD guests, it must be loaded into the SEAM Range Register
> > (SEAMRR) and properly initialized.  The TDX module is expected to be
> > loaded by BIOS before booting to the kernel, and the kernel is expected
> > to detect and initialize it, using the SEAMCALLs defined by TDX
> > architecture.
> > 
> > The TDX module can be initialized only once in its lifetime.  Instead
> > of always initializing it at boot time, this implementation chooses an
> > on-demand approach to initialize TDX until there is a real need (e.g
> > when requested by KVM).  This avoids consuming the memory that must be
> > allocated by kernel and given to the TDX module as metadata (~1/256th of
> 
> allocated by the kernel

Ok.

> 
> > the TDX-usable memory), and also saves the time of initializing the TDX
> > module (and the metadata) when TDX is not used at all.  Initializing the
> > TDX module at runtime on-demand also is more flexible to support TDX
> > module runtime updating in the future (after updating the TDX module, it
> > needs to be initialized again).
> > 
> > Introduce two placeholders tdx_detect() and tdx_init() to detect and
> > initialize the TDX module on demand, with a state machine introduced to
> > orchestrate the entire process (in case of multiple callers).
> > 
> > To start with, tdx_detect() checks SEAMRR and TDX private KeyIDs.  The
> > TDX module is reported as not loaded if either SEAMRR is not enabled, or
> > there are no enough TDX private KeyIDs to create any TD guest.  The TDX
> > module itself requires one global TDX private KeyID to crypto protect
> > its metadata.
> > 
> > And tdx_init() is currently empty.  The TDX module will be initialized
> > in multi-steps defined by the TDX architecture:
> > 
> >    1) Global initialization;
> >    2) Logical-CPU scope initialization;
> >    3) Enumerate the TDX module capabilities and platform configuration;
> >    4) Configure the TDX module about usable memory ranges and global
> >       KeyID information;
> >    5) Package-scope configuration for the global KeyID;
> >    6) Initialize usable memory ranges based on 4).
> > 
> > The TDX module can also be shut down at any time during its lifetime.
> > In case of any error during the initialization process, shut down the
> > module.  It's pointless to leave the module in any intermediate state
> > during the initialization.
> > 
> > SEAMCALL requires SEAMRR being enabled and CPU being already in VMX
> > operation (VMXON has been done), otherwise it generates #UD.  So far
> > only KVM handles VMXON/VMXOFF.  Choose to not handle VMXON/VMXOFF in
> > tdx_detect() and tdx_init() but depend on the caller to guarantee that,
> > since so far KVM is the only user of TDX.  In the long term, more kernel
> > components are likely to use VMXON/VMXOFF to support TDX (i.e. TDX
> > module runtime update), so a reference-based approach to do VMXON/VMXOFF
> > is likely needed.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >   arch/x86/include/asm/tdx.h  |   4 +
> >   arch/x86/virt/vmx/tdx/tdx.c | 222 ++++++++++++++++++++++++++++++++++++
> >   2 files changed, 226 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index 1f29813b1646..c8af2ba6bb8a 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -92,8 +92,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
> >   
> >   #ifdef CONFIG_INTEL_TDX_HOST
> >   void tdx_detect_cpu(struct cpuinfo_x86 *c);
> > +int tdx_detect(void);
> > +int tdx_init(void);
> >   #else
> >   static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
> > +static inline int tdx_detect(void) { return -ENODEV; }
> > +static inline int tdx_init(void) { return -ENODEV; }
> >   #endif /* CONFIG_INTEL_TDX_HOST */
> >   
> >   #endif /* !__ASSEMBLY__ */
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index ba2210001ea8..53093d4ad458 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -9,6 +9,8 @@
> >   
> >   #include <linux/types.h>
> >   #include <linux/cpumask.h>
> > +#include <linux/mutex.h>
> > +#include <linux/cpu.h>
> >   #include <asm/msr-index.h>
> >   #include <asm/msr.h>
> >   #include <asm/cpufeature.h>
> > @@ -45,12 +47,33 @@
> >   		((u32)(((_keyid_part) & 0xffffffffull) + 1))
> >   #define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
> >   
> > +/*
> > + * TDX module status during initialization
> > + */
> > +enum tdx_module_status_t {
> > +	/* TDX module status is unknown */
> > +	TDX_MODULE_UNKNOWN,
> > +	/* TDX module is not loaded */
> > +	TDX_MODULE_NONE,
> > +	/* TDX module is loaded, but not initialized */
> > +	TDX_MODULE_LOADED,
> > +	/* TDX module is fully initialized */
> > +	TDX_MODULE_INITIALIZED,
> > +	/* TDX module is shutdown due to error during initialization */
> > +	TDX_MODULE_SHUTDOWN,
> > +};
> > +
> 
> May be adding these states when you really need will make
> more sense. Currently this patch only uses SHUTDOWN and
> NONE states. Other state usage is not very clear.

They are all used in tdx_detect() and tdx_init(), no?

> 
> >   /* BIOS must configure SEAMRR registers for all cores consistently */
> >   static u64 seamrr_base, seamrr_mask;
> >   
> >   static u32 tdx_keyid_start;
> >   static u32 tdx_keyid_num;
> >   
> > +static enum tdx_module_status_t tdx_module_status;
> > +
> > +/* Prevent concurrent attempts on TDX detection and initialization */
> > +static DEFINE_MUTEX(tdx_module_lock);
> 
> Any possible concurrent usage models?

tdx_detect() and tdx_init() are called on demand by callers, so it's possible
multiple callers can call into them concurrently.

> 
> > +
> >   static bool __seamrr_enabled(void)
> >   {
> >   	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> > @@ -172,3 +195,202 @@ void tdx_detect_cpu(struct cpuinfo_x86 *c)
> >   	detect_seam(c);
> >   	detect_tdx_keyids(c);
> >   }
> > +
> > +static bool seamrr_enabled(void)
> > +{
> > +	/*
> > +	 * To detect any BIOS misconfiguration among cores, all logical
> > +	 * cpus must have been brought up at least once.  This is true
> > +	 * unless 'maxcpus' kernel command line is used to limit the
> > +	 * number of cpus to be brought up during boot time.  However
> > +	 * 'maxcpus' is basically an invalid operation mode due to the
> > +	 * MCE broadcast problem, and it should not be used on a TDX
> > +	 * capable machine.  Just do paranoid check here and do not
> 
> a paranoid check

Ok.

> 
> > +	 * report SEAMRR as enabled in this case.
> > +	 */
> > +	if (!cpumask_equal(&cpus_booted_once_mask,
> > +					cpu_present_mask))
> > +		return false;
> > +
> > +	return __seamrr_enabled();
> > +}
> > +
> > +static bool tdx_keyid_sufficient(void)
> > +{
> > +	if (!cpumask_equal(&cpus_booted_once_mask,
> > +					cpu_present_mask))
> > +		return false;
> > +
> > +	/*
> > +	 * TDX requires at least two KeyIDs: one global KeyID to
> > +	 * protect the metadata of the TDX module and one or more
> > +	 * KeyIDs to run TD guests.
> > +	 */
> > +	return tdx_keyid_num >= 2;
> > +}
> > +
> > +static int __tdx_detect(void)
> > +{
> > +	/* The TDX module is not loaded if SEAMRR is disabled */
> > +	if (!seamrr_enabled()) {
> > +		pr_info("SEAMRR not enabled.\n");
> > +		goto no_tdx_module;
> > +	}
> > +
> > +	/*
> > +	 * Also do not report the TDX module as loaded if there's
> > +	 * no enough TDX private KeyIDs to run any TD guests.
> > +	 */
> 
> You are not returning TDX_MODULE_LOADED under any current
> scenarios. So think above comment is not accurate.

This comment is to explain the logic behind of below TDX KeyID check.  I don't
see how is it related to your comments?

This patch is pretty much a placeholder to express the idea of how are
tdx_detect() and tdx_init() going to be implemented.  In below after the
tdx_keyid_sufficient() check, I also have a comment to explain the module hasn't
been detected yet which means there will be code to detect the module here, and
at that time, logically this function will return TDX_MODULE_LOADED.  I don't
see this is hard to understand?

> 
> > +	if (!tdx_keyid_sufficient()) {
> > +		pr_info("Number of TDX private KeyIDs too small: %u.\n",
> > +				tdx_keyid_num);
> > +		goto no_tdx_module;
> > +	}
> > +
> > +	/* Return -ENODEV until the TDX module is detected */
> > +no_tdx_module:
> > +	tdx_module_status = TDX_MODULE_NONE;
> > +	return -ENODEV;
> > +}
> > +
> > +static int init_tdx_module(void)
> > +{
> > +	/*
> > +	 * Return -EFAULT until all steps of TDX module
> > +	 * initialization are done.
> > +	 */
> > +	return -EFAULT;
> > +}
> > +
> > +static void shutdown_tdx_module(void)
> > +{
> > +	/* TODO: Shut down the TDX module */
> > +	tdx_module_status = TDX_MODULE_SHUTDOWN;
> > +}
> > +
> > +static int __tdx_init(void)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * Logical-cpu scope initialization requires calling one SEAMCALL
> > +	 * on all logical cpus enabled by BIOS.  Shutting down the TDX
> > +	 * module also has such requirement.  Further more, configuring
> 
> such a requirement

Thanks.

> 
> > +	 * the key of the global KeyID requires calling one SEAMCALL for
> > +	 * each package.  For simplicity, disable CPU hotplug in the whole
> > +	 * initialization process.
> > +	 *
> > +	 * It's perhaps better to check whether all BIOS-enabled cpus are
> > +	 * online before starting initializing, and return early if not.
> > +	 * But none of 'possible', 'present' and 'online' CPU masks
> > +	 * represents BIOS-enabled cpus.  For example, 'possible' mask is
> > +	 * impacted by 'nr_cpus' or 'possible_cpus' kernel command line.
> > +	 * Just let the SEAMCALL to fail if not all BIOS-enabled cpus are
> > +	 * online.
> > +	 */
> > +	cpus_read_lock();
> > +
> > +	ret = init_tdx_module();
> > +
> > +	/*
> > +	 * Shut down the TDX module in case of any error during the
> > +	 * initialization process.  It's meaningless to leave the TDX
> > +	 * module in any middle state of the initialization process.
> > +	 */
> > +	if (ret)
> > +		shutdown_tdx_module();
> > +
> > +	cpus_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * tdx_detect - Detect whether the TDX module has been loaded
> > + *
> > + * Detect whether the TDX module has been loaded and ready for
> > + * initialization.  Only call this function when all cpus are
> > + * already in VMX operation.
> > + *
> > + * This function can be called in parallel by multiple callers.
> > + *
> > + * Return:
> > + *
> > + * * -0:	The TDX module has been loaded and ready for
> > + *		initialization.
> > + * * -ENODEV:	The TDX module is not loaded.
> > + * * -EPERM:	CPU is not in VMX operation.
> > + * * -EFAULT:	Other internal fatal errors.
> > + */
> > +int tdx_detect(void)
> 
> Will this function be used separately or always along with
> tdx_init()?

The caller should first use tdx_detect() and then use tdx_init().  If caller
only uses tdx_detect(), then TDX module won't be initialized (unless other
caller does this).  If caller calls tdx_init() before tdx_detect(),  it will get
error.

> 
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&tdx_module_lock);
> > +
> > +	switch (tdx_module_status) {
> > +	case TDX_MODULE_UNKNOWN:
> > +		ret = __tdx_detect();
> > +		break;
> > +	case TDX_MODULE_NONE:
> > +		ret = -ENODEV;
> > +		break;
> > +	case TDX_MODULE_LOADED:
> > +	case TDX_MODULE_INITIALIZED:
> > +		ret = 0;
> > +		break;
> > +	case TDX_MODULE_SHUTDOWN:
> > +		ret = -EFAULT;
> > +		break;
> > +	default:
> > +		WARN_ON(1);
> > +		ret = -EFAULT;
> > +	}
> > +
> > +	mutex_unlock(&tdx_module_lock);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(tdx_detect);
> > +
> > +/**
> > + * tdx_init - Initialize the TDX module
> 
> If it for tdx module initialization, why not call it
> tdx_module_init()? If not, update the description
> appropriately.

Besides do the actual module initialization, it also has a state machine.

But point taken, and I'll try to refine the description.  Thanks.

> 
> > + *
> > + * Initialize the TDX module to make it ready to run TD guests.  This
> > + * function should be called after tdx_detect() returns successful.
> > + * Only call this function when all cpus are online and are in VMX
> > + * operation.  CPU hotplug is temporarily disabled internally.
> > + *
> > + * This function can be called in parallel by multiple callers.
> > + *
> > + * Return:
> > + *
> > + * * -0:	The TDX module has been successfully initialized.
> > + * * -ENODEV:	The TDX module is not loaded.
> > + * * -EPERM:	The CPU which does SEAMCALL is not in VMX operation.
> > + * * -EFAULT:	Other internal fatal errors.
> > + */
> 
> You return differnt error values just for debug prints or there are
> other uses for it?

Caller can distinguish them and act differently.  Even w/o any purpose, I think
it's better to return different error codes to reflect different error reasons.



-- 
Thanks,
-Kai


