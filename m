Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B965072F0EF
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 02:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbjFNAZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 20:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjFNAY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 20:24:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE81127;
        Tue, 13 Jun 2023 17:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686702297; x=1718238297;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ONou0KL3JP8ZODggj3R2LSlTjc2gCgJgF5UTJ/MO0wc=;
  b=URKS6vgalDr3VA2vPuJ7ZN3DVb1zUOxGbOO1FikO1X2/sAM24fRM9L7w
   QE5NgY5f6k1QAqPZVbqhsHzGRHGaevrpsrsQowoGOUIXz4kz/sI4JHhC3
   2V2XzGH7LMXhJSShHTC1S1JB2sxoKObZBONVK6yzlXmMVZhSBJGGIdoYw
   q9f2stzX2xai7Ife4O7hxC2F4NXVIU2/9mVX6oBMCs5xH4w8zfDri7nqF
   2IrDAZLNRkFue9le2S67tEHyWEvcWfw5eZkKdUHQ/p1Ai27hyqe+KUHgk
   Z7c22BhgpfuVy/Vzy0bdKUwcO5QPtZ9C0l2jgAe0p8br/NskzO8lDTW5+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="348139703"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="348139703"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 17:24:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="781895307"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="781895307"
Received: from clin147-mobl.amr.corp.intel.com (HELO [10.212.134.227]) ([10.212.134.227])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 17:24:55 -0700
Message-ID: <6e3ae1bd-c6e4-b7cb-ab4c-50849ffbc237@intel.com>
Date:   Tue, 13 Jun 2023 17:24:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
 <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
 <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
 <6fb1ec2f-8713-8191-fd31-751b1a663b0b@intel.com>
 <1542a26c0501cb9f7fc330d8aa27e565c81b969c.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1542a26c0501cb9f7fc330d8aa27e565c81b969c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/23 16:18, Huang, Kai wrote:
> On Tue, 2023-06-13 at 07:25 -0700, Hansen, Dave wrote:
>> On 6/12/23 17:51, Huang, Kai wrote:
>>> If we introduce a helper to mark a page as TDX private page,
>> Let me get this right: you have working, functional code for a
>> highly-unlikely scenario (kernel bugs or even more rare hardware
>> errors).  But, you want to optimize this super-rare case?  It's not fast
>> enough?
>>
>> Is there any other motivation here that I'm missing?
>>
> No it's not about speed.  The motivation is to have a common code to yield less
> line of code, though I don't have clear number of how many LoC can be reduced.

OK, so ... ballpark.  How many lines of code are we going to _save_ for
this super-rare case?  10?  100?  1000?

The upside is saving X lines of code ... somewhere.  The downside is
adding Y lines of code ... somewhere else and maybe breaking things in
the process.

You've evidently done _some_ kind of calculus in your head to make this
tradeoff worthwhile.  I'd love to hear what your calculus is, even if
it's just a gut feel.

Could you share your logic here, please?
