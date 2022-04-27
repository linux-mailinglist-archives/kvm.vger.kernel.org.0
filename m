Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE9510D06
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 02:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356290AbiD0AJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 20:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiD0AJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 20:09:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424462F382;
        Tue, 26 Apr 2022 17:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651017998; x=1682553998;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WF0BUOeCUWjXtygZ0fA+ocYyTRB01MF/mxmqK/OFDYg=;
  b=H1jbq50hw9Me9mg3kFpgKW5OEP7gVVm4g6eN4TPRg3eBmVqkYFLAr9UJ
   oWUIuwqacAdmNdWTK1uI121j5mmgBlufe3L+/oiOWVyxyjs3vwTrD4zZi
   5epcYRYawq5SeeMN35CumMuh+OMOkC2FZUJc6y5GqeAGLjcCaofBTuRxE
   47Vvjiie76QAafrBA3rjD4A612VRY0igR3h885xGNNVy3t7hWKlyqTLUD
   QSUxZrSrcuYEVoAlyhpnko2wEFDtxFig93FipC+CZtMenlVsDxbAALyKK
   aMMPTtX7iv95KAXT4gOzrd2AL89OfRH7ziiIH31wCV+q1Z9rEfXsipCj0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="245685354"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="245685354"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:06:37 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="558612050"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:06:34 -0700
Message-ID: <345753e50e4c113b1dfb71bba1ed841eee55aed3.camel@intel.com>
Subject: Re: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of
 error
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
Date:   Wed, 27 Apr 2022 12:06:32 +1200
In-Reply-To: <b3c81b7f-3016-8f4e-3ac5-bff1fc52a879@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
         <b3c81b7f-3016-8f4e-3ac5-bff1fc52a879@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 13:59 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > TDX supports shutting down the TDX module at any time during its
> > lifetime.  After TDX module is shut down, no further SEAMCALL can be
> > made on any logical cpu.
> 
> Is this strictly true?
> 
> I thought SEAMCALLs were used for the P-SEAMLDR too.

Sorry will change to no TDX module SEAMCALL can be made on any logical cpu.

[...]

> >  
> > +/* Data structure to make SEAMCALL on multiple CPUs concurrently */
> > +struct seamcall_ctx {
> > +	u64 fn;
> > +	u64 rcx;
> > +	u64 rdx;
> > +	u64 r8;
> > +	u64 r9;
> > +	atomic_t err;
> > +	u64 seamcall_ret;
> > +	struct tdx_module_output out;
> > +};
> > +
> > +static void seamcall_smp_call_function(void *data)
> > +{
> > +	struct seamcall_ctx *sc = data;
> > +	int ret;
> > +
> > +	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9,
> > +			&sc->seamcall_ret, &sc->out);
> > +	if (ret)
> > +		atomic_set(&sc->err, ret);
> > +}
> > +
> > +/*
> > + * Call the SEAMCALL on all online cpus concurrently.
> > + * Return error if SEAMCALL fails on any cpu.
> > + */
> > +static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
> > +{
> > +	on_each_cpu(seamcall_smp_call_function, sc, true);
> > +	return atomic_read(&sc->err);
> > +}
> 
> Why bother returning something that's not read?

It's not needed.  I'll make it void.

Caller can check seamcall_ctx::err directly if they want to know whether any
error happened.



-- 
Thanks,
-Kai


