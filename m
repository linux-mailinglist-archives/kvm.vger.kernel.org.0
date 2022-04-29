Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7A5152F7
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379800AbiD2RwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379817AbiD2Rv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:51:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBC1D4C6F;
        Fri, 29 Apr 2022 10:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651254520; x=1682790520;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5nf6dQ2n0VV5pIH0jfSN6QopQJy5UODqlRTGczslSjk=;
  b=bwzv6/E3Bb+l62kp1snAABw1w9xTYoLBL4TQnL5FnIA5udFG7HwbsZSb
   9SDiHGaH31NJfBqKdJHVovi7tQSj2hgTvmyUowWaoEwCC4x0aW6FFtVaF
   nf3Fl2exD+hcvyIVXhSWguWPhJpmMirQy+a4a4mXcvrz9998f6C9MBfMQ
   +9hxdht1uDA9/BaVjzJLUdlgx6ptOJJT5Sb0QegcU0YXzZB5qP/Se9wpZ
   4LwnlLRoiUK1hj/LrfudLSxKw2C5KZLYfM5peOknjes1H2XW/PXqdxhZz
   W5UdMoqJBh0L1j9HKGUhT+lNovcK4/v4WIRP1zQxcvTXZerd/yExySxyM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="266545761"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="266545761"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 10:46:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582296660"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 10:46:39 -0700
Message-ID: <c875fc4a-c3c0-dab1-c7cb-525b0bff5ae3@intel.com>
Date:   Fri, 29 Apr 2022 10:46:56 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Ymv2h1GYCMQ9ZQvJ@google.com>
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

On 4/29/22 07:30, Sean Christopherson wrote:
> On Fri, Apr 29, 2022, Dave Hansen wrote:
...
>> A *good* way (although not foolproof) is to launch a TDX VM early
>> in boot before memory gets fragmented or consumed.  You might even
>> want to recommend this in the documentation.
> 
> What about providing a kernel param to tell the kernel to do the
> allocation during boot?

I think that's where we'll end up eventually.  But, I also want to defer
that discussion until after we have something merged.

Right now, allocating the PAMTs precisely requires running the TDX
module.  Running the TDX module requires VMXON.  VMXON is only done by
KVM.  KVM isn't necessarily there during boot.  So, it's hard to do
precisely today without a bunch of mucking with VMX.

But, it would be really easy to do something less precise like:

	tdx_reserve_ratio=255

...

u8 *pamt_reserve[MAX_NR_NODES]

	for_each_online_node(n) {
		pamt_pages = (node_spanned_pages(n)/tdx_reserve_ratio) /
			     PAGE_SIZE;
		pamt_reserve[n] = alloc_bootmem([pamt_pages);
	}

Then have the TDX code use pamt_reserve[] instead of allocating more
memory when it is needed later.

That will work just fine as long as you know up front how much metadata
TDX needs.  If the metadata requirements change in an updated TDX
module, the command-line will need to be updated to regain the
guarantee.  But, it can still fall back to the best-effort code that is
 in the series today.

In other words, I think we want what is in the series today no matter
what, and we'll want it forever.  That's why it's the *one* way of doing
things now.  I entirely agree that there will be TDX users that want a
stronger guarantee.

You can arm-wrestle the distro folks who hate adding command-line tweaks
when the time comes. ;)
