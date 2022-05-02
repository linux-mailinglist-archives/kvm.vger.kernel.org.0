Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44507517169
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 16:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347497AbiEBOVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 10:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiEBOU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 10:20:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5111A17049;
        Mon,  2 May 2022 07:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651501051; x=1683037051;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CJgkaS9O4REA+/QIrvQMB9jS3Pr7zFdaQtj+hUxh90g=;
  b=a+VF1qzaTWMD8IoK9br7kV59IneIkZ2tURUCjnU66UsecbxNrYUeS897
   5lF/+0RV0eH6mn6ElPIWOY673DokMxJzGHgg4ltJ9W38vMPHqtS68A5VM
   LgXNKeAxpGeFiyWZaWdDMDBzAHnU83t9baEBfndaoBSQ1FvDPLU9E0GK7
   7viwFSc9ImOk4rq51chwAnL64Fdlw6Ra/QeRHvFsKPHaMMS9swKEg+4Cf
   Ppuo9rC86thrB78NT3Aq1kdLo/EcXnz237EI802pPtkfVk4hveokHNk5V
   UUUkPuk9VUV6Tysgi3sEEHF8Qcl5nF3oAurGC8zhrk1hHV9abhcn4gYZB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="327763628"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="327763628"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 07:17:30 -0700
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="663538658"
Received: from gsteinke-mobl.amr.corp.intel.com (HELO [10.209.165.8]) ([10.209.165.8])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 07:17:29 -0700
Message-ID: <8d5715b5-d561-f482-af11-03a9a46e651a@intel.com>
Date:   Mon, 2 May 2022 07:17:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
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
References: <cover.1649219184.git.kai.huang@intel.com>
 <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
 <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
 <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
 <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
 <af603d66512ec5dca0c240cf81c83de7dfe730e7.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <af603d66512ec5dca0c240cf81c83de7dfe730e7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/1/22 22:59, Kai Huang wrote:
> On Fri, 2022-04-29 at 07:20 -0700, Dave Hansen wrote:
> How about adding below in the changelog:
> 
> "
> However using alloc_contig_pages() to allocate large physically contiguous
> memory at runtime may fail.  The larger the allocation, the more likely it is to
> fail.  Due to the fragmentation, the kernel may need to move pages out of the
> to-be-allocated contiguous memory range but it may fail to move even the last
> stubborn page.  A good way (although not foolproof) is to launch a TD VM early
> in boot to get PAMTs allocated before memory gets fragmented or consumed.
> "

Better, although it's getting a bit off topic for this changelog.

Just be short and sweet:

1. the allocation can fail
2. Launch a VM early to (badly) mitigate this
3. the only way to fix it is to add a boot option


>>>>> +	/*
>>>>> +	 * One TDMR must cover at least one (or partial) RAM entry,
>>>>> +	 * otherwise it is kernel bug.  WARN_ON() in this case.
>>>>> +	 */
>>>>> +	if (WARN_ON_ONCE((start >= end) || start >= TDMR_END(tdmr)))
>>>>> +		return 0;
>>
>> This really means "no RAM found for this TDMR", right?  Can we say that,
>> please.
> 
> OK will add it.  How about:
> 
> 	/*
> 	 * No RAM found for this TDMR.  WARN() in this case, as it
> 	 * cannot happen otherwise it is a kernel bug.
> 	 */

The only useful information in that comment is the first sentence.  The
jibberish about WARN() is patently obvious from the next two lines of code.

*WHY* can't this happen?  How might it have actually happened?
