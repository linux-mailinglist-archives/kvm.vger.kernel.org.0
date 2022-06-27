Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0183E55C7F1
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiF0Um1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239191AbiF0Um0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:42:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07481EECD;
        Mon, 27 Jun 2022 13:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656362544; x=1687898544;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=teCkAY150hpKgnL1JJaIVCKfP+fzFobYu8LKDCwZNbM=;
  b=Th/QgnYUuHhNuyABbhvM5cmuYLVeUZHJYE31njpDaOq0D6j836+2nrWt
   727CZotrw99WyOQ4P/hrZOar3ql2ArYoe8vax+2UIyP4107CmMY4RXlU5
   8FnDJZeHxb3Lk4aXw7FiX/EymmhBjOnaMQP5AxoWoJ5NmLgwRfMTnnWYl
   fAVmeo/AqEgcxjUK2iLIt7pZxsw7i4uFPXipD05Zfx12tiWKdCTHg9Q3T
   xcM00NIsYCLyLjNsg+NZqkPJieM9MF1+U6QwtDs/CaWSZ8wAFqUg+cDnb
   gjbRmKwBjNOEFCu1cmb3EbQUgkThgvN/MYc3rqGEGk8LGZoQRg7VWKOzu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="261970165"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="261970165"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 13:42:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="732471886"
Received: from jsagoe-mobl1.amr.corp.intel.com (HELO [10.209.12.66]) ([10.209.12.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 13:42:22 -0700
Message-ID: <b43bf089-1202-a1fe-cbb3-d4e0926cab67@intel.com>
Date:   Mon, 27 Jun 2022 13:41:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
 <e72703b0-767a-ec88-7cb6-f95a3564d823@intel.com>
 <b376aef05bc032fdf8cc23762ce77a14830440cd.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b376aef05bc032fdf8cc23762ce77a14830440cd.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 03:31, Kai Huang wrote:
>>> +/* Page sizes supported by TDX */
>>> +enum tdx_page_sz {
>>> +	TDX_PG_4K,
>>> +	TDX_PG_2M,
>>> +	TDX_PG_1G,
>>> +	TDX_PG_MAX,
>>> +};
>> Are these the same constants as the magic numbers in Kirill's
>> try_accept_one()?
> try_accept_once() uses 'enum pg_level' PG_LEVEL_{4K,2M,1G} directly.  They can
> be used directly too, but 'enum pg_level' has more than we need here:

I meant this:

+       switch (level) {
+       case PG_LEVEL_4K:
+               page_size = 0;
+               break;

Because TDX_PG_4K==page_size==0, and for this:

+       case PG_LEVEL_2M:
+               page_size = 1;

where TDX_PG_2M==page_size==1

See?

Are Kirill's magic 0/1/2 numbers the same as

	TDX_PG_4K,
	TDX_PG_2M,
	TDX_PG_1G,

?
