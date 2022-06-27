Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1244F55D431
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242779AbiF0W6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241880AbiF0W6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:58:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8726A10C;
        Mon, 27 Jun 2022 15:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656370687; x=1687906687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zVmwtCQNF6fzOVCPckEQuUt0SlS/3Ly8rekwR8DjUy4=;
  b=gjQee9DuVZRDzrXgSfciibX16tkM1lEU8bJYoRxU1OvwYeUgu7a2oUuK
   zmv8Pa+6mokamj/Zofq698nLSSVTqEqinvs4gHIGKK6D1g3oZRnG1p7/q
   G+zQSqsChyc2SuhkVLlRuiXwzWuo4l6hTjfbM4ZX8vidRpmwEXn6MEpDG
   ZOocKNpqPggZ5iddJKb5/MwI85FEqy4SJx7uBCHfU5IUuFTt+SL4ZWxel
   8OnuPSa13MgLBz2DdlGOw9JViwTGx+Ukic6vXvssEXOpyOVxMMMhXS/1O
   qZFlMNgNXdKjbNXod3eLpkY3izdN/yMb+dlZcfLv40CEiB91USJqqa3Pu
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282672819"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282672819"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:58:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="732509814"
Received: from jsagoe-mobl1.amr.corp.intel.com (HELO [10.209.12.66]) ([10.209.12.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:58:06 -0700
Message-ID: <3253e9fa-14f8-085e-5f13-bb70fea89abf@intel.com>
Date:   Mon, 27 Jun 2022 15:57:07 -0700
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
 <b43bf089-1202-a1fe-cbb3-d4e0926cab67@intel.com>
 <a610ae9bd554f31364193abc928fad86ed5ebf7c.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a610ae9bd554f31364193abc928fad86ed5ebf7c.camel@intel.com>
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

On 6/27/22 15:50, Kai Huang wrote:
>> Are Kirill's magic 0/1/2 numbers the same as
>>
>> 	TDX_PG_4K,
>> 	TDX_PG_2M,
>> 	TDX_PG_1G,
>>
>> ?
> Yes they are the same.  Kirill uses 0/1/2 as input of TDX_ACCEPT_PAGE TDCALL. 
> Here I only need them to distinguish different page sizes.
> 
> Do you mean we should put TDX_PG_4K/2M/1G definition to asm/tdx.h, and
> try_accept_one() should use them instead of magic 0/1/2?

I honestly don't care how you do it as long as the magic numbers go away
(within reason).
