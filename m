Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475205153C3
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380043AbiD2SgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiD2SgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:36:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA18D4C90;
        Fri, 29 Apr 2022 11:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651257164; x=1682793164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zftMOiKfzA2N0SvkmILBHm7NmobiVBrkq7/3clP0XAg=;
  b=iFkFV6bQaGu5XPbuMLNm3Fi30Bao33Vi82qTPmXCeCI3QV45o0j/3gJP
   iSV4U8rFE+vQNHeJ0VcNRJ68Lu6j1mj/ODJN8EYdt3y1PELd3E1QXEFGj
   J0oRMsddQrj2i+zVArwEnBML3qpXbpihIXHkkzIZ59gpCoL0JlWxb/su3
   NcmSeap1IvNPnLHi9WN3q+Hhe2ue9c2GYttTj0/qcNLkdGlmBm98nRzvT
   RBPFPjX8QvGwRW15/ej1wBwnmWekexR28FsOxDaJYNi/oRNESbmDLPF2m
   bh54kzlO6i0c0WtrMm6VWTkI6vicC85r7vKQhT3HMWl+venwA6znq6tKs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="265582909"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="265582909"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 11:32:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582322111"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 11:32:43 -0700
Message-ID: <7359e83b-9056-11a1-30ca-d13e9b953c95@intel.com>
Date:   Fri, 29 Apr 2022 11:32:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
 <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
 <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
 <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
 <Ymv2h1GYCMQ9ZQvJ@google.com>
 <c875fc4a-c3c0-dab1-c7cb-525b0bff5ae3@intel.com>
 <YmwsOo4TCq1/5hgd@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YmwsOo4TCq1/5hgd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 11:19, Sean Christopherson wrote:
> On Fri, Apr 29, 2022, Dave Hansen wrote:
>> On 4/29/22 07:30, Sean Christopherson wrote:
>>> On Fri, Apr 29, 2022, Dave Hansen wrote:
>> ...
>>>> A *good* way (although not foolproof) is to launch a TDX VM early
>>>> in boot before memory gets fragmented or consumed.  You might even
>>>> want to recommend this in the documentation.
>>>
>>> What about providing a kernel param to tell the kernel to do the
>>> allocation during boot?
>>
>> I think that's where we'll end up eventually.  But, I also want to defer
>> that discussion until after we have something merged.
>>
>> Right now, allocating the PAMTs precisely requires running the TDX
>> module.  Running the TDX module requires VMXON.  VMXON is only done by
>> KVM.  KVM isn't necessarily there during boot.  So, it's hard to do
>> precisely today without a bunch of mucking with VMX.
> 
> Meh, it's hard only if we ignore the fact that the PAMT entry size isn't going
> to change for a given TDX module, and is extremely unlikely to change in general.
> 
> Odds are good the kernel can hardcode a sane default and Just Work.  Or provide
> the assumed size of a PAMT entry via module param.  If the size ends up being
> wrong, log an error, free the reserved memory, and move on with TDX setup with
> the correct size.

Sure.  The boot param could be:

	tdx_reserve_whatever=auto

and then it can be overridden if necessary.  I just don't want to have
kernel binaries that are only good as paperweights if Intel decides it
needs another byte of metadata.

>> You can arm-wrestle the distro folks who hate adding command-line tweaks
>> when the time comes. ;)
> 
> Sure, you just find me the person that's going to run TDX guests with an
> off-the-shelf distro kernel :-D

Well, everyone gets their kernel from upstream eventually and everyone
watches upstream.

But, in all seriousness, do you really expect TDX to remain solely in
the non-distro-kernel crowd forever?  I expect that the fancy cloud
providers (with custom kernels) who care the most to deploy TDX fist.
But, things will trickle down to the distro crowd over time.
