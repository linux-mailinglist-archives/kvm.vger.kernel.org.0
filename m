Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB26634BFE
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiKWBEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiKWBEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:04:30 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A793D59176;
        Tue, 22 Nov 2022 17:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669165469; x=1700701469;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xIkQj2jeU/8NPzjK+TPyInzQOmljcCdXkpyBV4P2W8Y=;
  b=Ywz/kTK8EEqg32c1KFzfSnPriSnVP79vVZjU3iC6iRs0hfGVZ9kkBkQd
   7OloZ84gMkGXsEoWHS7DVcZsgXXxLIn2wp4NJVg9sh/l/k0kuuCj8ilkv
   BEiAm4707Edf3izatOnKbwY3hVOVomS4HZphwytraiURmDt+sOqhihYLt
   85rFlUnxfkWqV+xUmILVyTR3iwnL3vYWH2Pd9RzBAHvk75cFYEExxTybB
   bC1WgFQaYPkXK3gNMK2r56+kKOE6tJxKFo5xX1Mw7ll8WneN5USVy4aBB
   bXv+9goz7z3qKD2A9f2kkfaK4lsXkX1SOzL598v5+/Mz6T4KjjPkzDo5C
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315773032"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="315773032"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:04:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="643923109"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="643923109"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:04:26 -0800
Message-ID: <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
Date:   Tue, 22 Nov 2022 17:04:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
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
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/22 16:58, Huang, Kai wrote:
> On Tue, 2022-11-22 at 11:24 -0800, Dave Hansen wrote:
>>> I was expecting TDX to not get initialized until the first TDX using KVM
>>> instance is created. Am I wrong?
>> I went looking for it in this series to prove you wrong.  I failed.  😄
>>
>> tdx_enable() is buried in here somewhere:
>>
>>> https://lore.kernel.org/lkml/CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com/T/
>> I don't have the patience to dig it out today, so I guess we'll have Kai
>> tell us.
> It will be done when KVM module is loaded, but not when the first TDX guest is
> created.

Why is it done that way?

Can it be changed to delay TDX initialization until the first TDX guest
needs to run?
