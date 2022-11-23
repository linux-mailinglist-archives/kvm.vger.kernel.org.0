Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699ED636895
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239424AbiKWSTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiKWSSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:18:48 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF1711A0F;
        Wed, 23 Nov 2022 10:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669227527; x=1700763527;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E89CZqbaoYjUKLoTevrvJoCvfEz61O1bB0tNgiHnTvA=;
  b=ih6tOimMX0Pm8MMJOQndqTCFsJ96W3582sK4vUi3UCEWpOtxdgi775lD
   7NFKcxByfHrOiwkngDSO6mTPdHUpJnB5JR+jleZDKzQJkUPLJDX/U0SCo
   epTX3uXQNVPHPvm45Ur3rSXH0ypR9SIGiKP5yvN9vkfFNZNXUZfsMt+X1
   7mqJOv91VajbGTxg32SMNwJ1+SutDKBJAI+osyeJBmCBWrq4huOBChPaW
   rai9sfoaSuxMem2HqBbU8YTChqQDR9xImENGZEJaqLs7waopMvdvx4OF7
   gbsm0hL48PGTJyqn3/bbqleWVg90ilbzqmGwhlJtaGQn2p697nv4sw49h
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294519300"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294519300"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:18:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="672965938"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="672965938"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:18:45 -0800
Message-ID: <2d99f823-09bb-ff51-0e71-f254cc6ad28b@intel.com>
Date:   Wed, 23 Nov 2022 10:18:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
 <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
 <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
 <Y35IW/PnbxinKHOL@google.com>
 <168ca2b3-ffac-31c4-0b83-2d0ee75f34a5@intel.com>
 <Y35aXX5b2Ed4vc6y@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y35aXX5b2Ed4vc6y@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 09:37, Sean Christopherson wrote:
> On Wed, Nov 23, 2022, Dave Hansen wrote:
>> There's no way we can guarantee _that_.  For one, the PAMT* allocations
>> can always fail.  I guess we could ask sysadmins to fire up a guest to
>> "prime" things, but that seems a little silly.  Maybe that would work as
>> the initial implementation that we merge, but I suspect our users will
>> demand more determinism, maybe a boot or module parameter.
> Oh, you mean all of TDX initialization?  I thought "initialization" here mean just
> doing tdx_enable().

Yes, but the first call to tdx_enable() does TDH_SYS_INIT and all the
subsequent work to get the module going.

> Yeah, that's not going to be a viable option.  Aside from lacking determinisim,
> it would be all too easy to end up on a system with fragmented memory that can't
> allocate the PAMTs post-boot.

For now, the post-boot runtime PAMT allocations are the one any only way
that TDX can be initialized.  I pushed for it to be done this way.
Here's why:

Doing tdx_enable() is relatively slow and it eats up a non-zero amount
of physically contiguous RAM for metadata (~1/256th or ~0.4% of RAM).
Systems that support TDX but will never run TDX guests should not pay
that cost.

That means that we either make folks opt-in at boot-time or we try to
make a best effort at runtime to do the metadata allocations.

From my perspective, the best-effort stuff is absolutely needed.  Users
are going to forget the command-line opt in and there's no harm in
_trying_ the big allocations even if they fail.

Second, in reality, the "real" systems that can run TDX guests are
probably not going to sit around fragmenting memory for a month before
they run their first guest.  They're going to run one shortly after they
boot when memory isn't fragmented and the best-effort allocation will
work really well.

Third, if anyone *REALLY* cared to make it reliable *and* wanted to sit
around fragmenting memory for a month, they could just start a TDX guest
and kill it to get TDX initialized.  This isn't ideal.  But, to me, it
beats defining some new, separate ABI (or boot/module option) to do it.

So, let's have those discussions.  Long-term, what *is* the most
reliable way to get the TDX module loaded with 100% determinism?  What
new ABI or interfaces are needed?  Also, is that 100% determinism
required the moment this series is merged?  Or, can we work up to it?

I think it can wait until this particular series is farther along.
