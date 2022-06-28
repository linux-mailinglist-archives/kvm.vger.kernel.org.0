Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C019A55C936
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbiF1AtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 20:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiF1AtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 20:49:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D588B11;
        Mon, 27 Jun 2022 17:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656377349; x=1687913349;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gm2N2ZUm+7WdloRrAvNjqF430gKN+MlOv6l36JlXkjc=;
  b=lWrkUjEyY60Np13XzzZVMd59yZ63fF238KmrPaq6wbz2E5KOSM2FENSX
   9eeMdhZcJKLg6L1Plre0LrcVR7nAZP/kNf0/HvQcF3RTA7fhS5xDD1vJY
   X48FD9OEP+H/Y7X84jcqdfmu8WbLjpaPKM6QRHxxe9a02T2a+CNENWEpG
   Y0Sg+iwDCg+jd/yfLqYToYcr2c41QGr9P4URs0wrE/qmuNQJOwh2GxdxU
   Lf+CWvpize21ox6u5Hg7YhDLZnNJQG1436Vv0h/segkwkDB5vJa+AV5a7
   rpSGj4rjnpTmONZVwIEG0GfuwBJTZEQL7PnLOgpiT/nMi4aMAYEx1xvMM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="270345527"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="270345527"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 17:49:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="646669100"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.143]) ([10.249.174.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 17:49:05 -0700
Message-ID: <28110f9c-b84c-591a-d365-ae4412408e48@intel.com>
Date:   Tue, 28 Jun 2022 08:48:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <b43bf089-1202-a1fe-cbb3-d4e0926cab67@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/2022 4:41 AM, Dave Hansen wrote:
> On 6/27/22 03:31, Kai Huang wrote:
>>>> +/* Page sizes supported by TDX */
>>>> +enum tdx_page_sz {
>>>> +	TDX_PG_4K,
>>>> +	TDX_PG_2M,
>>>> +	TDX_PG_1G,
>>>> +	TDX_PG_MAX,
>>>> +};
>>> Are these the same constants as the magic numbers in Kirill's
>>> try_accept_one()?
>> try_accept_once() uses 'enum pg_level' PG_LEVEL_{4K,2M,1G} directly.  They can
>> be used directly too, but 'enum pg_level' has more than we need here:
> 
> I meant this:
> 
> +       switch (level) {
> +       case PG_LEVEL_4K:
> +               page_size = 0;
> +               break;
> 
> Because TDX_PG_4K==page_size==0, and for this:
> 
> +       case PG_LEVEL_2M:
> +               page_size = 1;

here we can just do

	page_size = level - 1;

or
	
	tdx_page_level = level - 1;

yes, TDX's page level definition is one level smaller of Linux's definition.

> where TDX_PG_2M==page_size==1
> 
> See?
> 
> Are Kirill's magic 0/1/2 numbers the same as
> 
> 	TDX_PG_4K,
> 	TDX_PG_2M,
> 	TDX_PG_1G,
> 
> ?



