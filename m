Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A390452C7F4
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 01:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiERXwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 19:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiERXwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 19:52:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6DF7938F;
        Wed, 18 May 2022 16:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652917919; x=1684453919;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mJ+odFwUEFZ8/mBRx5MLyfUxqVB0HbjzNjmsEFcZYgI=;
  b=fCwjRVja+MoYYbfhe+A3QrE3zFk/9DR6+uyMSDDPXXTV9ZwK6GntLxJ/
   2VR3zEVGNlILUvtIt44hxnoZK82uPnfBcOy38rAOQqPtv/Ydf17JTRoAV
   kzDVHFmPGCVsDq5qRIeIh9ToftQ0QIxkwwK9Ee+spy1sP78lEgwRkA0K9
   s29UZirKM5b3i0OJSFb6UOdg7ekJjdr1olDO/C+FqdV+JYVlcwWeHazGK
   TnNr/guEycfB/l02On0tFdAv62qqinbW6Dv3jUeWLkFg1Hn2q1hWFfy9b
   OqvcBh4j9y5w6C9Ahy+xMlJ+uR9qdJQuzqN2pacxXCburZ5wKptf8bQUy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="272072636"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="272072636"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 16:51:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="569820102"
Received: from ppamkunt-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.33.252])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 16:51:55 -0700
Message-ID: <6b9d89e1bd4d9991b0cdb778224474696e8e6b67.camel@intel.com>
Subject: Re: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of
 error
From:   Kai Huang <kai.huang@intel.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Date:   Thu, 19 May 2022 11:51:52 +1200
In-Reply-To: <CAAhR5DFFGTHAG9U74v9YXZkjfgfQ9vD4B76ky-MtM5fkjTgRFQ@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
         <b3c81b7f-3016-8f4e-3ac5-bff1fc52a879@intel.com>
         <345753e50e4c113b1dfb71bba1ed841eee55aed3.camel@intel.com>
         <CAAhR5DFFGTHAG9U74v9YXZkjfgfQ9vD4B76ky-MtM5fkjTgRFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 09:19 -0700, Sagi Shahar wrote:
> On Tue, Apr 26, 2022 at 5:06 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > On Tue, 2022-04-26 at 13:59 -0700, Dave Hansen wrote:
> > > On 4/5/22 21:49, Kai Huang wrote:
> > > > TDX supports shutting down the TDX module at any time during its
> > > > lifetime.  After TDX module is shut down, no further SEAMCALL can be
> > > > made on any logical cpu.
> > > 
> > > Is this strictly true?
> > > 
> > > I thought SEAMCALLs were used for the P-SEAMLDR too.
> > 
> > Sorry will change to no TDX module SEAMCALL can be made on any logical cpu.
> > 
> > [...]
> > 
> > > > 
> > > > +/* Data structure to make SEAMCALL on multiple CPUs concurrently */
> > > > +struct seamcall_ctx {
> > > > +   u64 fn;
> > > > +   u64 rcx;
> > > > +   u64 rdx;
> > > > +   u64 r8;
> > > > +   u64 r9;
> > > > +   atomic_t err;
> > > > +   u64 seamcall_ret;
> > > > +   struct tdx_module_output out;
> > > > +};
> > > > +
> > > > +static void seamcall_smp_call_function(void *data)
> > > > +{
> > > > +   struct seamcall_ctx *sc = data;
> > > > +   int ret;
> > > > +
> > > > +   ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9,
> > > > +                   &sc->seamcall_ret, &sc->out);
> 
> Are the seamcall_ret and out fields in seamcall_ctx going to be used?
> Right now it looks like no one is going to read them.
> If they are going to be used then this is going to cause a race since
> the different CPUs are going to write concurrently to the same address
> inside seamcall().
> We should either use local memory and write using atomic_set like the
> case for the err field or hard code NULL at the call site if they are
> not going to be used.
> > > > 

Thanks for catching this.  Both 'seamcall_ret' and 'out' are actually not used
in this series, but this needs to be improved for sure.  

I think I can just remove them from the 'seamcall_ctx' for now, since they are
not used at all.

-- 
Thanks,
-Kai


