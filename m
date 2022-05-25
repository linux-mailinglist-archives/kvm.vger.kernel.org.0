Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC2533649
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 06:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbiEYE5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 00:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiEYE5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 00:57:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED9D6C540;
        Tue, 24 May 2022 21:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653454660; x=1684990660;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EWA0K2J771t3RS3ay05cCgofn/C2Ovhrpn5ZmOcjugg=;
  b=krT6Tg1lPm8cfRXWta19GPhxZbjWXes288zNFe6BK4Q0UP158ppRZDmE
   SyF99NYE8O9JXfSqfwgdF9x5ciH0AW+2QPhnf+xS6R+L71cKkqdw/LZQt
   PS8Rz/ZtusKOQ8oq6QSvfHx1H/RYjswrnmqFRWLb02EQNMklvU05fMBh9
   8mXu4e+XX+6R3w8P+VmZcVzTKnon71c1V0OxSecfJ1k+m7ie98+8g4clV
   WRupL2yGjX3ZVX5YFvx8hGr9PEmVGxoSzc7fEskTqxhPGwnPnZoDEd5QW
   OBpPKwqS4L5Esc36eWjprJF3XD3Rb+lqf0rPLccOEY1+maZH5KcuYk6rG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="272535052"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="272535052"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 21:57:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="578186300"
Received: from canagani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.35.228])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 21:57:37 -0700
Message-ID: <a47b12f762272540d7b8b691d863b60ddb0d246d.camel@intel.com>
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
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
Date:   Wed, 25 May 2022 16:57:35 +1200
In-Reply-To: <a6694c81b4e96a22557fd0af70a81bd2c2e4e3e7.camel@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
         <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
         <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
         <98f81eed-e532-75bc-d2d8-4e020517b634@intel.com>
         <be31134cf44a24d6d38fbf39e9e18ef223e216c6.camel@intel.com>
         <4aea41ea-211f-fbde-34e9-4c4467ebc848@intel.com>
         <a6694c81b4e96a22557fd0af70a81bd2c2e4e3e7.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-25 at 16:47 +1200, Kai Huang wrote:
> On Fri, 2022-04-29 at 10:47 -0700, Dave Hansen wrote:
> > On 4/28/22 16:14, Kai Huang wrote:
> > > On Thu, 2022-04-28 at 07:06 -0700, Dave Hansen wrote:
> > > > On 4/27/22 17:15, Kai Huang wrote:
> > > > > > Couldn't we get rid of that comment if you did something like:
> > > > > > 
> > > > > > 	ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);
> > > > > 
> > > > > Yes will do.
> > > > > 
> > > > > > and preferably make the variables function-local.
> > > > > 
> > > > > 'tdx_sysinfo' will be used by KVM too.
> > > > 
> > > > In other words, it's not a part of this series so I can't review whether
> > > > this statement is correct or whether there's a better way to hand this
> > > > information over to KVM.
> > > > 
> > > > This (minor) nugget influencing the design also isn't even commented or
> > > > addressed in the changelog.
> > > 
> > > TDSYSINFO_STRUCT is 1024B and CMR array is 512B, so I don't think it should be
> > > in the stack.  I can change to use dynamic allocation at the beginning and free
> > > it at the end of the function.  KVM support patches can change it to static
> > > variable in the file.
> > 
> > 2k of stack is big, but it isn't a deal breaker for something that's not
> > nested anywhere and that's only called once in a pretty controlled
> > setting and not in interrupt context.  I wouldn't cry about it.
> 
> Hi Dave,
> 
> I got below complaining when I use local variable for TDSYSINFO_STRUCT and CMR
> array:
> 
> arch/x86/virt/vmx/tdx/tdx.c:383:1: warning: the frame size of 3072 bytes is
> larger than 1024 bytes [-Wframe-larger-than=]
>   383 | }
> 
> So I don't think we can use local variable for them.  I'll still use static
> variables to avoid dynamic allocation.  In the commit message, I'll explain they
> are too big to put into the stack, and KVM will need to use TDSYSINFO_STRUCT
> reported by TDX module anyway.
> 
> Let me know if you don't agree?

Btw, CMR array alone can be put into the stack.  It will never be used by KVM,
so I'll put CMR array as local variable, but keep tdx_sysinfo as static
variable.

-- 
Thanks,
-Kai


