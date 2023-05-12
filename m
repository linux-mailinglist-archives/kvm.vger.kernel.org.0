Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6B6FFE73
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 03:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbjELBfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 21:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbjELBfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 21:35:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914C330DD;
        Thu, 11 May 2023 18:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683855332; x=1715391332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zvIqFCHm6xH47/drlZNFCS7fRujt9qMuMUEtrPtwEfs=;
  b=BUsLHKl5plLKFZc6EfZYM7QJMkM0JCnB33eAA4aWmmIyi6Af4MI1JrpW
   tZpDzNxke2KJ75lJ5WNRZ+qdHcEIq9GRr+j+h2G4J0IRvD54P8X82tknx
   ChzbudMCD3KAzL0KV9Iiyooctdw4grwSKHeYI8JftWEk5YCRoJJYytEjG
   revJeSuhimOCgVxiBdiOeXRR1MY/F8hD3sSc+NIZrUoazKQ5YaOdFyhts
   z5XohjMbnxSSkkJJNVo1qX2Xnr0mL0VoaIXFlAu1mF3nQ/sefFAkaJX7Z
   mUBKOWeMK0ByKK/Gxt9aVMAFWX0wByH7GLW/8J/tZJP/RaaM+yT68/JUz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416301440"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="416301440"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 18:35:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="677477968"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="677477968"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.30.205]) ([10.255.30.205])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 18:35:29 -0700
Message-ID: <bbb3e5ac-1b51-abdf-c7ce-372af548f26b@linux.intel.com>
Date:   Fri, 12 May 2023 09:35:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
To:     David Laight <David.Laight@ACULAB.COM>,
        Chao Gao <chao.gao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-2-binbin.wu@linux.intel.com>
 <ZFtK/NS8rzCx9Mus@chao-email>
 <68a5df32-82de-1f07-5ea2-52ecf1c17e63@linux.intel.com>
 <ccf245b17d7140099ad89628635a04ef@AcuMS.aculab.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ccf245b17d7140099ad89628635a04ef@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/2023 5:58 PM, David Laight wrote:
> From: Binbin Wu
>> Sent: 11 May 2023 02:26
> ...
>>>> 	unsigned max_size;
>>>> -	return __linearize(ctxt, addr, &max_size, size, write, false,
>>>> +	u32 flags = 0;
>>>> +
>>>> +	if (write)
>>>> +		flags |= X86EMUL_F_WRITE;
>>> this can be more dense:
>>>
>>> 	u32 flags = write ? X86EMUL_F_WRITE : 0;
>> Thanks, will update it.
> You can also dispense with the extra local variable and
> put the ?: into the parameter list.
>
> Even more so with the other calls sites.
Thanks, I will check whether they are better to be put in the parameter 
list directly instead of using a local variable.

>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

