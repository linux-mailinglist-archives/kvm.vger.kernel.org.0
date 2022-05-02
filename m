Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA78516A36
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 07:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383302AbiEBFHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 01:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346303AbiEBFHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 01:07:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B5E18B2F;
        Sun,  1 May 2022 22:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651467847; x=1683003847;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V1kJORjn9br3AwkVpZzF5nhWVGElfcC89uM3ZN5Q7cY=;
  b=gVJwl2PMfLj6VpOQNkWMvxOuwhnAbKplGGK7G3Jx+6gZ4rezkXjKajpA
   c8RWIIhQeXMK2jjKjrvEnTdT7yRsIvV0cWSjmSNvtc/LPAnI/EfUubqxm
   cAyhG6BHvQBQB93ydUfndyLy4+X+09MAiv2wfvVS1vIq0dNbeZDgm2Aik
   aNc8vmIyLluBVXhokmeBTynPPmZCzZybP7v81IY8Nati2m6bn56Iy/Aky
   64jmCvA/Jfwhud+rjagttrRqwGwN1H5iRuBw8oxYBVfmPUMlQ81dUIAq2
   Hm5O2c0unCMlzpAyd7sFP4NRpdsYvxCAuWlwC8+Uv7FO8mFjn5l67cowd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="247674779"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="247674779"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2022 22:04:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="886061235"
Received: from bwu50-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.2.219])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2022 22:04:04 -0700
Message-ID: <33e3c91973dd22cada87d9c78e3e4b9eb4da9778.camel@intel.com>
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
Date:   Mon, 02 May 2022 17:04:02 +1200
In-Reply-To: <4aea41ea-211f-fbde-34e9-4c4467ebc848@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
         <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
         <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
         <98f81eed-e532-75bc-d2d8-4e020517b634@intel.com>
         <be31134cf44a24d6d38fbf39e9e18ef223e216c6.camel@intel.com>
         <4aea41ea-211f-fbde-34e9-4c4467ebc848@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
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

On Fri, 2022-04-29 at 10:47 -0700, Dave Hansen wrote:
> On 4/28/22 16:14, Kai Huang wrote:
> > On Thu, 2022-04-28 at 07:06 -0700, Dave Hansen wrote:
> > > On 4/27/22 17:15, Kai Huang wrote:
> > > > > Couldn't we get rid of that comment if you did something like:
> > > > > 
> > > > > 	ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);
> > > > 
> > > > Yes will do.
> > > > 
> > > > > and preferably make the variables function-local.
> > > > 
> > > > 'tdx_sysinfo' will be used by KVM too.
> > > 
> > > In other words, it's not a part of this series so I can't review whether
> > > this statement is correct or whether there's a better way to hand this
> > > information over to KVM.
> > > 
> > > This (minor) nugget influencing the design also isn't even commented or
> > > addressed in the changelog.
> > 
> > TDSYSINFO_STRUCT is 1024B and CMR array is 512B, so I don't think it should be
> > in the stack.  I can change to use dynamic allocation at the beginning and free
> > it at the end of the function.  KVM support patches can change it to static
> > variable in the file.
> 
> 2k of stack is big, but it isn't a deal breaker for something that's not
> nested anywhere and that's only called once in a pretty controlled
> setting and not in interrupt context.  I wouldn't cry about it.

OK.  I'll change to use function local variables for both of them.

-- 
Thanks,
-Kai


