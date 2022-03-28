Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05CC4E8B86
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 03:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiC1BVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 21:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiC1BVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 21:21:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93354F454;
        Sun, 27 Mar 2022 18:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648430403; x=1679966403;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KchMvDvbiC67yGPjkt52HrrIXysjTlzcF5vTID7lVI8=;
  b=hTFEFxkv31WRxNYwEnHLaQtHMRB9QduLxTEwG8N5Gflk+Lq7jjEZyxjd
   Tu+sHiisnRwjeuKwMp5D5Sow8LX3vzxaDL91ip89DCPwLe2i8O0+gkyih
   oJEJIsVS5QySd5i4qYz0ycT7bLl7qPKxeOMc7fBekYgUgFtcWeoAAW4OW
   q04IyEalwxM+vg0XWu3DKMr6fhdfr0w8Y6NxdCzwBsCBIFZJu9Vr5c9wi
   20tbpnfVCdTNVrLfMgmm6xNDdbmwt/HzkcsSKar+PBSd8/LNerURVZfLj
   hqx+eK3hdbfffc/sfjUAt3Tu1Szf6LRoXACXwveUFyOI0NcL5EyxmWiaS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259075149"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="259075149"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:20:02 -0700
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="603596427"
Received: from stung2-mobl.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:20:00 -0700
Message-ID: <8ff183991f34b9a0166c24c8392ae4a8c676470a.camel@intel.com>
Subject: Re: [PATCH v2 17/21] x86/virt/tdx: Configure global KeyID on all
 packages
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@gmail.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
Date:   Mon, 28 Mar 2022 14:19:58 +1300
In-Reply-To: <20220324181832.GC1212881@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <c36456b0fd4bd50720bc8e8aa35fbb124185ae98.1647167475.git.kai.huang@intel.com>
         <20220324181832.GC1212881@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 11:18 -0700, isaku.yamahata@gmail.com wrote:
> On Sun, Mar 13, 2022 at 11:49:57PM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> > index e03dc3e420db..39b1b7d0417d 100644
> > --- a/arch/x86/virt/vmx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx.c
> > @@ -23,6 +23,7 @@
> >  #include <asm/virtext.h>
> >  #include <asm/e820/api.h>
> >  #include <asm/pgtable.h>
> > +#include <asm/smp.h>
> >  #include <asm/tdx.h>
> >  #include "tdx.h"
> >  
> > @@ -398,6 +399,47 @@ static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
> >  	return atomic_read(&sc->err);
> >  }
> >  
> > +/*
> > + * Call the SEAMCALL on one (any) cpu for each physical package in
> > + * serialized way.  Note for serialized calls 'seamcall_ctx::err'
> > + * doesn't have to be atomic, but for simplicity just reuse it
> > + * instead of adding a new one.
> > + *
> > + * Return -ENXIO if IPI SEAMCALL wasn't run on any cpu, or -EFAULT
> > + * when SEAMCALL fails, or -EPERM when the cpu where SEAMCALL runs
> > + * on is not in VMX operation.  In case of -EFAULT, the error code
> > + * of SEAMCALL is in 'struct seamcall_ctx::seamcall_ret'.
> > + */
> > +static int seamcall_on_each_package_serialized(struct seamcall_ctx *sc)
> > +{
> > +	cpumask_var_t packages;
> > +	int cpu, ret;
> > +
> > +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
> > +		return -ENOMEM;
> 
> Memory leak. This should be freed before returning.
> 
> 
> > +	for_each_online_cpu(cpu) {
> > +		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
> > +					packages))
> > +			continue;
> > +
> > +		ret = smp_call_function_single(cpu, seamcall_smp_call_function,
> > +				sc, true);
> > +		if (ret)
> > +			return ret;
> > +
> > +		/*
> > +		 * Doesn't have to use atomic_read(), but it doesn't
> > +		 * hurt either.
> > +		 */
> > +		ret = atomic_read(&sc->err);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static inline bool p_seamldr_ready(void)
> >  {
> >  	return !!p_seamldr_info.p_seamldr_ready;
> > @@ -1316,6 +1358,18 @@ static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
> >  	return ret;
> >  }
> >  
> > +static int config_global_keyid(u64 global_keyid)
> 
> global_keyid argument isn't used.  Is global variable tdx_global_keyid used?
> 
> 
> > +{
> > +	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
> > +
> > +	/*
> > +	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is
> > +	 * a recoverable error).  Assume this is exceedingly rare and
> > +	 * just return error if encountered instead of retrying.
> > +	 */
> > +	return seamcall_on_each_package_serialized(&sc);
> > +}
> > +

Both will be fixed.  Thanks!

-- 
Thanks,
-Kai
