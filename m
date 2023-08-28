Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53A78B9DF
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 23:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjH1VBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbjH1VAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 17:00:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A712D;
        Mon, 28 Aug 2023 14:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693256438; x=1724792438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D7H8iRQg3oYPla8ASkYh40XrCVvCBejBs3ZgYFWYd5Q=;
  b=FQAngCInUwHLQ4kYIM+Fzl58jJckMDyiuo2l6jypZ2/gy/12QuPHAJZW
   Z6u/0R3Cq8Mk5czAJH6qjWoJL5sYB0tlyXGj8ILnbPHeo9nU75P4PjaCO
   cVS2eOPIJxL+Uqpr9TY/6Oj2BSnnfWXGPxKTgdmEya8nBvRAkEzOBNBIU
   8NOUQHeYrpHVfuMfUVutAwzki1tthVSO6tkvnQj5/Y+Ac3ly/eR+FeeZx
   X+d+jUXI5RWT1jNiDxaTjI/U7c3koI2aURrfV43rAJtwEMFckSk2M3na/
   07O0C2yqd2PfP1gxB7Gq0rI+7wjzRhjISIQTeWvieP2wooWPA9Vz19XMv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="372615823"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="372615823"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2023 14:00:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="715266445"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="715266445"
Received: from drpresto-mobl.amr.corp.intel.com (HELO [10.212.171.191]) ([10.212.171.191])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2023 14:00:36 -0700
Message-ID: <2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com>
Date:   Mon, 28 Aug 2023 14:00:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
 <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
 <c871cc44-b6a0-06e3-493b-33ddf4fa6e05@intel.com>
 <8396a9f6-fbc4-1e62-b6a9-3df568fd15a2@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8396a9f6-fbc4-1e62-b6a9-3df568fd15a2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/23 08:15, Paolo Bonzini wrote:
> On 8/10/23 16:29, Dave Hansen wrote:
>> What actual OSes need this support?
> 
> I think Xen could use it when running nested.  But KVM cannot expose
> support for CET in CPUID, and at the same time fake support for
> MSR_IA32_PL{0,1,2}_SSP (e.g. inject a #GP if it's ever written to a
> nonzero value).
> 
> I suppose we could invent our own paravirtualized CPUID bit for
> "supervisor IBT works but supervisor SHSTK doesn't".  Linux could check
> that but I don't think it's a good idea.
> 
> So... do, or do not.  There is no try. :)

Ahh, that makes sense.  This is needed for implementing the
*architecture*, not because some OS actually wants to _do_ it.

...
>> In a perfect world, we'd just allocate space for CET_S in the KVM
>> fpstates.  The core kernel fpstates would have
>> XSTATE_BV[13]==XCOMP_BV[13]==0.  An XRSTOR of the core kernel fpstates
>> would just set CET_S to its init state.
> 
> Yep.  I don't think it's a lot of work to implement.  The basic idea as
> you point out below is something like
> 
> #define XFEATURE_MASK_USER_DYNAMIC XFEATURE_MASK_XTILE_DATA
> #define XFEATURE_MASK_USER_OPTIONAL \
>     (XFEATURE_MASK_DYNAMIC | XFEATURE_MASK_CET_KERNEL)
> 
> where XFEATURE_MASK_USER_DYNAMIC is used for xfd-related tasks
> (including the ARCH_GET_XCOMP_SUPP arch_prctl) but everything else uses
> XFEATURE_MASK_USER_OPTIONAL.
> 
> KVM would enable the feature by hand when allocating the guest fpstate.
> Disabled features would be cleared from EDX:EAX when calling
> XSAVE/XSAVEC/XSAVES.

OK, so let's _try_ this perfect-world solution.  KVM fpstates get
fpstate->xfeatures[13] set, but no normal task fpstates have that bit
set.  Most of the infrastructure should be there to handle this without
much fuss because it _should_ be looking at generic things like
fpstate->size and fpstate->features.

But who knows what trouble this will turn up.  It could get nasty and
not worth it, but we should at least try it.
