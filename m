Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E616DCBAD
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjDJTig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 15:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJTif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 15:38:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABDF1986;
        Mon, 10 Apr 2023 12:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681155514; x=1712691514;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Svb4QE5O3AtUUvnQaSnfurOg76l86/it8y02Sa3f2MU=;
  b=Tn8fkVty8P758UBVppkKRpozjteN0RJryqUjHl6q6rozy1weBhxImM2V
   hKxL4KXDu8kva5jP7le6PGf98lERvtjAkj1cZ0TXjYAvyiixI41+GRxee
   +JnyBrbUN4vLxrRrtr63vo186WRxSQXBU4rSMuXvf7w1cc5Kl2MnzsV74
   ZWHAQhKvf9D8rWGX+JhbDquYCHXPz8pkmp4bCjh3IOlIxLarpadXzTKmb
   HYZIj4gGSMzj599ibUfQTTo5IX5pGrydM5eDtGkNdrwSKFoL+Ak8HHxEW
   /GVDDXSrsReGDhLZV2jsNycULeQQSnGQFR1h5GBYN0po4bzVGj/1IKtPT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="371282080"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="371282080"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 12:38:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="688365506"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="688365506"
Received: from arsetion-mobl.amr.corp.intel.com (HELO [10.209.122.228]) ([10.209.122.228])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 12:38:33 -0700
Message-ID: <7d2be935-848d-4b6c-80f5-053db5141a33@intel.com>
Date:   Mon, 10 Apr 2023 12:38:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v8 00/33] x86: enable FRED for x86-64
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
 <SA1PR11MB6734C0AE97E8B5ACF70CA32AA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
 <20230410193254.GAZDRkZjBURP9BydHB@fat_crate.local>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230410193254.GAZDRkZjBURP9BydHB@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/10/23 12:32, Borislav Petkov wrote:
> On Mon, Apr 10, 2023 at 07:14:21PM +0000, Li, Xin3 wrote:
>>> Basically, if anyone else has been procrastinating on reviewing this set, now is
>>> probably the time to dig in.  (I'll include myself in that category, btw)
>> I really appreciate it!
> That doesn't mean that you should patch-bomb people once a week even
> without any review happening.
> 
> Is FRED in any hardware incarnation to rush it?

Which reminds me...  It is always appreciated when hardware vendors can
put a stake in the ground about where and how a feature will show up.
It's great that you said that it is SIMICS-only for now.  That's a start.

But, if you could, for instance say things like (and I'm totally pulling
these out of my rear end):

	FRED will be available only on server CPUs
or
	FRED will be available across all Intel CPUs
or
	FRED will start showing up in CPUs that are released
	in roughly 2033

it would be nice to know that.

Here's what I said for protection keys, for example:

> https://lore.kernel.org/linux-mm/20160212210152.9CAD15B0@viggo.jf.intel.com/


