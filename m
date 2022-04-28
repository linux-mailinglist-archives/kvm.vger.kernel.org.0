Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF17D51281B
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 02:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiD1Aku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 20:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiD1Aks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 20:40:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD1460C4;
        Wed, 27 Apr 2022 17:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651106255; x=1682642255;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=josa8NNV04XHmxHSnmGCI+XBJ9Kp+vUK0WwQQ402JTA=;
  b=ZA/UNOIJr8HcKuSSMXkNRVi+HE7xyaZWOfujf/yNtL/xkQKXdjzv1/Fl
   PcB/AmLh2SNkSxMUSZuYrCDJLYi5Q9hFhO3HlZUehS67F0yZW5uthFA6h
   th3NPuKFIYAR35sJQ8oEWnyHSmRVsEULRejCmR6X3pOeBtndBZkIZ5l2G
   GRZ0ingwTZhVlJTc3F1TI6aBAezEzhKlRg/8Td2WO7c8F9w+ZBTjJRIdT
   FsmgxJU/Vg6nXlqli5n9q7gG12LsXyZdwlE6LqWjuuaUiCZ9tkQjAt381
   mVNuwYAcr/xFbm4H33YSyy73moVIz5dkXEcttOXyYhJXTvkNyfrtIJ8Gv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="253498245"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="253498245"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:37:34 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="629275458"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:37:31 -0700
Message-ID: <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 28 Apr 2022 12:37:29 +1200
In-Reply-To: <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
         <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> On 4/26/22 18:15, Kai Huang wrote:
> > On Tue, 2022-04-26 at 13:13 -0700, Dave Hansen wrote:
> > > On 4/5/22 21:49, Kai Huang wrote:
> > > > SEAM VMX root operation is designed to host a CPU-attested, software
> > > > module called the 'TDX module' which implements functions to manage
> > > > crypto protected VMs called Trust Domains (TD).  SEAM VMX root is also
> > > 
> > > "crypto protected"?  What the heck is that?
> > 
> > How about "crypto-protected"?  I googled and it seems it is used by someone
> > else.
> 
> Cryptography itself doesn't provide (much) protection in the TDX
> architecture.  TDX guests are isolated from the VMM in ways that
> traditional guests are not, but that has almost nothing to do with
> cryptography.
> 
> Is it cryptography that keeps the host from reading guest private data
> in the clear?  Is it cryptography that keeps the host from reading guest
> ciphertext?  Does cryptography enforce the extra rules of Secure-EPT?

OK will change to "protected VMs" in this entire series.

> 
> > > > 3. Memory hotplug
> > > > 
> > > > The first generation of TDX architecturally doesn't support memory
> > > > hotplug.  And the first generation of TDX-capable platforms don't support
> > > > physical memory hotplug.  Since it physically cannot happen, this series
> > > > doesn't add any check in ACPI memory hotplug code path to disable it.
> > > > 
> > > > A special case of memory hotplug is adding NVDIMM as system RAM using
> > > > kmem driver.  However the first generation of TDX-capable platforms
> > > > cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
> > > > happen either.
> > > 
> > > What prevents this code from today's code being run on tomorrow's
> > > platforms and breaking these assumptions?
> > 
> > I forgot to add below (which is in the documentation patch):
> > 
> > "This can be enhanced when future generation of TDX starts to support ACPI
> > memory hotplug, or NVDIMM and TDX can be enabled simultaneously on the
> > same platform."
> > 
> > Is this acceptable?
> 
> No, Kai.
> 
> You're basically saying: *this* code doesn't work with feature A, B and
> C.  Then, you're pivoting to say that it doesn't matter because one
> version of Intel's hardware doesn't support A, B, or C.
> 
> I don't care about this *ONE* version of the hardware.  I care about
> *ALL* the hardware that this code will ever support.  *ALL* the hardware
> on which this code will run.
> 
> In 5 years, if someone takes this code and runs it on Intel hardware
> with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?

I thought we could document this in the documentation saying that this code can
only work on TDX machines that don't have above capabilities (SPR for now).  We
can change the code and the documentation  when we add the support of those
features in the future, and update the documentation.

If 5 years later someone takes this code, he/she should take a look at the
documentation and figure out that he/she should choose a newer kernel if the
machine support those features.

I'll think about design solutions if above doesn't look good for you.

> 
> You can't just ignore the problems because they're not present on one
> version of the hardware.
> 
> > > > Another case is admin can use 'memmap' kernel command line to create
> > > > legacy PMEMs and use them as TD guest memory, or theoretically, can use
> > > > kmem driver to add them as system RAM.  To avoid having to change memory
> > > > hotplug code to prevent this from happening, this series always include
> > > > legacy PMEMs when constructing TDMRs so they are also TDX memory.
> > > > 
> > > > 4. CPU hotplug
> > > > 
> > > > The first generation of TDX architecturally doesn't support ACPI CPU
> > > > hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
> > > > first generation of TDX-capable platforms don't support ACPI CPU hotplug
> > > > either.  Since this physically cannot happen, this series doesn't add any
> > > > check in ACPI CPU hotplug code path to disable it.
> > > > 
> > > > Also, only TDX module initialization requires all BIOS-enabled cpus are
> > > > online.  After the initialization, any logical cpu can be brought down
> > > > and brought up to online again later.  Therefore this series doesn't
> > > > change logical CPU hotplug either.
> > > > 
> > > > 5. TDX interaction with kexec()
> > > > 
> > > > If TDX is ever enabled and/or used to run any TD guests, the cachelines
> > > > of TDX private memory, including PAMTs, used by TDX module need to be
> > > > flushed before transiting to the new kernel otherwise they may silently
> > > > corrupt the new kernel.  Similar to SME, this series flushes cache in
> > > > stop_this_cpu().
> > > 
> > > What does this have to do with kexec()?  What's a PAMT?
> > 
> > The point is the dirty cachelines of TDX private memory must be flushed
> > otherwise they may slightly corrupt the new kexec()-ed kernel.
> > 
> > Will use "TDX metadata" instead of "PAMT".  The former has already been
> > mentioned above.
> 
> Longer description for the patch itself:
> 
> TDX memory encryption is built on top of MKTME which uses physical
> address aliases to designate encryption keys.  This architecture is not
> cache coherent.  Software is responsible for flushing the CPU caches
> when memory changes keys.  When kexec()'ing, memory can be repurposed
> from TDX use to non-TDX use, changing the effective encryption key.
> 
> Cover-letter-level description:
> 
> Just like SME, TDX hosts require special cache flushing before kexec().

Thanks.

> 
> > > > uninitialized state so it can be initialized again.
> > > > 
> > > > This implies:
> > > > 
> > > >   - If the old kernel fails to initialize TDX, the new kernel cannot
> > > >     use TDX too unless the new kernel fixes the bug which leads to
> > > >     initialization failure in the old kernel and can resume from where
> > > >     the old kernel stops. This requires certain coordination between
> > > >     the two kernels.
> > > 
> > > OK, but what does this *MEAN*?
> > 
> > This means we need to extend the information which the old kernel passes to the
> > new kernel.  But I don't think it's feasible.  I'll refine this kexec() section
> > to make it more concise next version.
> > 
> > > 
> > > >   - If the old kernel has initialized TDX successfully, the new kernel
> > > >     may be able to use TDX if the two kernels have the exactly same
> > > >     configurations on the TDX module. It further requires the new kernel
> > > >     to reserve the TDX metadata pages (allocated by the old kernel) in
> > > >     its page allocator. It also requires coordination between the two
> > > >     kernels.  Furthermore, if kexec() is done when there are active TD
> > > >     guests running, the new kernel cannot use TDX because it's extremely
> > > >     hard for the old kernel to pass all TDX private pages to the new
> > > >     kernel.
> > > > 
> > > > Given that, this series doesn't support TDX after kexec() (except the
> > > > old kernel doesn't attempt to initialize TDX at all).
> > > > 
> > > > And this series doesn't shut down TDX module but leaves it open during
> > > > kexec().  It is because shutting down TDX module requires CPU being in
> > > > VMX operation but there's no guarantee of this during kexec().  Leaving
> > > > the TDX module open is not the best case, but it is OK since the new
> > > > kernel won't be able to use TDX anyway (therefore TDX module won't run
> > > > at all).
> > > 
> > > tl;dr: kexec() doesn't work with this code.
> > > 
> > > Right?
> > > 
> > > That doesn't seem good.
> > 
> > It can work in my understanding.  We just need to flush cache before booting to
> > the new kernel.
> 
> What about all the concerns about TDX module configuration changing?
> 

Leaving the TDX module in fully initialized state or shutdown state (in case of
error during it's initialization) to the new kernel is fine.  If the new kernel
doesn't use TDX at all, then the TDX module won't access memory using it's
global TDX KeyID.  If the new kernel wants to use TDX, it will fail on the very
first SEAMCALL when it tries to initialize the TDX module, and won't use
SEAMCALL to call the TDX module again.  If the new kernel doesn't follow this,
then it is a bug in the new kernel, or the new kernel is malicious, in which
case it can potentially corrupt the data.  But I don't think we need to consider
this as if the new kernel is malicious, then it can corrupt data anyway.

Does this make sense?

Is there any other concerns that I missed? 

-- 
Thanks,
-Kai


