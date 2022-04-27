Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C57510D60
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 02:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356459AbiD0AsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 20:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiD0AsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 20:48:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B6D265A;
        Tue, 26 Apr 2022 17:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651020301; x=1682556301;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gIWayyo9QRWW2AhJIfOYwd5MOnosNVReAhB+VKUMMwY=;
  b=BkxMRoCP0UlyIrNyejFkVILVl+5ICMy83NoLEoyuRE7cM1B5RKh4bW0d
   WPFtMOkXZAKRJLcVFP7LeeHEIHmMsqD0Lmv4PHh2QwaqPbabUNL45jLPl
   +PMF6t95Kdy4phREXa+SQROnelr/M6/Mh8V17Vc5T6IsjvQhMQleLLR6c
   4vcUZOjJcexmzr99+7s+fbcrawjjicIlJEXVFee15aQwl7h/E1kQYAx8R
   KQ3HMr7gzvgFi62nLGZ2/q57wgw2OdRnKvLZrBhvydLGS+pXxpKWGOtsI
   YsoCC/GCHndTip0kDO25KjCjca+k2nA4y/2Fxdgtkug5S0UMtmucRpThn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="247699392"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="247699392"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:45:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="564838724"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:44:57 -0700
Message-ID: <47836361f893a5d762444c2aa66749f8c788ec8b.camel@intel.com>
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 27 Apr 2022 12:44:55 +1200
In-Reply-To: <YmiMyk6T5zNhYeRB@google.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
         <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
         <ce325155bada13c829b6213a3ec65294902c72c8.camel@intel.com>
         <15b34b16-b0e9-b1de-4de8-d243834caf9a@intel.com>
         <79ad9dd9373d1d4064e28d3a25bfe0f9e8e55558.camel@intel.com>
         <YmiMyk6T5zNhYeRB@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 00:22 +0000, Sean Christopherson wrote:
> On Wed, Apr 27, 2022, Kai Huang wrote:
> > On Tue, 2022-04-26 at 16:28 -0700, Dave Hansen wrote:
> > > On 4/26/22 16:12, Kai Huang wrote:
> > > > Hi Dave,
> > > > 
> > > > Thanks for review!
> > > > 
> > > > On Tue, 2022-04-26 at 13:21 -0700, Dave Hansen wrote:
> > > > > > +config INTEL_TDX_HOST
> > > > > > +	bool "Intel Trust Domain Extensions (TDX) host support"
> > > > > > +	default n
> > > > > > +	depends on CPU_SUP_INTEL
> > > > > > +	depends on X86_64
> > > > > > +	help
> > > > > > +	  Intel Trust Domain Extensions (TDX) protects guest VMs from
> > > > > > malicious
> > > > > > +	  host and certain physical attacks.  This option enables necessary
> > > > > > TDX
> > > > > > +	  support in host kernel to run protected VMs.
> > > > > > +
> > > > > > +	  If unsure, say N.
> > > > > 
> > > > > Nothing about KVM?
> > > > 
> > > > I'll add KVM into the context. How about below?
> > > > 
> > > > "Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> > > > host and certain physical attacks.  This option enables necessary TDX
> > > > support in host kernel to allow KVM to run protected VMs called Trust
> > > > Domains (TD)."
> > > 
> > > What about a dependency?  Isn't this dead code without CONFIG_KVM=y/m?
> > 
> > Conceptually, KVM is one user of the TDX module, so it doesn't seem correct to
> > make CONFIG_INTEL_TDX_HOST depend on CONFIG_KVM.  But so far KVM is the only
> > user of TDX, so in practice the code is dead w/o KVM.
> > 
> > What's your opinion?
> 
> Take a dependency on CONFIG_KVM_INTEL, there's already precedence for this specific
> case of a feature that can't possibly have an in-kernel user.  See
> arch/x86/kernel/cpu/feat_ctl.c, which in the (very) unlikely event IA32_FEATURE_CONTROL
> is left unlocked by BIOS, will deliberately disable VMX if CONFIG_KVM_INTEL=n.

Thanks.  Fine to me.

-- 
Thanks,
-Kai


