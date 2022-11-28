Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D1463B502
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiK1W4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiK1W4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:56:30 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB12A42F;
        Mon, 28 Nov 2022 14:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669676189; x=1701212189;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lMph/tM1XZPPmKJoB9xyc4L8wuSBzaj6cHmnYu1ENrg=;
  b=jjyU6IfanORkYFMfEWh91jU0cd8609t0K+X9kVDB0Ib8cRTkhvrx723C
   T5DWSLz9MRzbMFLNQdi9FGnR5ZYMeqqmlGaCQUXaDkooWtSzRjwvWYl1I
   GUXfBSWvrdJ1xkHV/ouc6rgb+FskmMy5UnYJhs2UyLeRdandnEdEjZHrZ
   kI5v+tk0R4IKTkOrlqOcpqIxUSVbo9jofaKvTh54i1MyKgzJRm8h9vMNO
   1RxBqdDDM/rYj0bpv6SA3CQ8lvrtrr7b0AbPFqGJmcgA91J5m6ihiF+XJ
   icQtidZdP5+gCnvLK7+rX3wnfnnPASBvtcBtgbNL25ULZ+KyvtUAoiQCe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="401253078"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="401253078"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:56:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888612395"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="888612395"
Received: from nroy-mobl1.amr.corp.intel.com (HELO [10.212.209.4]) ([10.212.209.4])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:56:22 -0800
Message-ID: <44e28b2e-833d-4ad3-542d-b2fae41dbf97@intel.com>
Date:   Mon, 28 Nov 2022 14:56:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
 <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
 <cceee7b0476437fb18f90a272e2852bdbb2636cc.camel@intel.com>
 <1e45748f-0de1-39aa-7e0f-7596ff813302@intel.com>
 <a68919357982a85252e13626b8d577642fee5beb.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a68919357982a85252e13626b8d577642fee5beb.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/22 14:48, Huang, Kai wrote:
>> Maybe even a little ASCII diagram about the different tmb configurations
>> that this can find:
>>
>>> TDMR1 | TDMR2 |
>>    |---tmb---|
>>           |tmb|
>>           |------tmb-------|          <- case 3)
>>    |------tmb-------|                 <- case 4
> Thanks for the diagram!
> 
> But IIUC it seems the above case 3) and 4) are actually not possible, since when
> one TDMR is created, it's end is always rounded up to the end of TMB it tries to
> cover (the rounded-up end may cover the entire or only partial of other TMBs,
> though).

OK, but at the same time, we shouldn't *STRICTLY* specialize every
single little chunk of this code to be aware of every other tiny little
implementation detail.

Let's say tomorrow's code has lots of TDMRs left, but fills up one
TDMR's reserved areas and has to "split" it.  Want to bet on whether the
person that adds that patch will be able to find this code and fix it up?

Or, say that the TDMR creation algorithm changes and they're not done in
order of ascending physical address.

This code actually gets easier and more obvious if you ignore the other
details.
