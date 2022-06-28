Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3055EAA0
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiF1RFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 13:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiF1RFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 13:05:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445762AE3B;
        Tue, 28 Jun 2022 10:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656435945; x=1687971945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=He+/gvN4uag1zs/e9FSisKAycqG0udPhwiCpLr5nAw0=;
  b=hmUwtDB6+W1/IOfvnm7h7aCPZbyz5YM1puHOUg3aX0SS5VTao0cSn2cr
   tRZZXavtUVRW/U6zswtqQxPLEJi7h4fFxKi4hloGjpUtbqBYSI0T0dCiO
   owEty6yeSdVjkXY1cECc0g+riecp1hWhySArcc+z6XtdHeVgQwZJsWEs7
   GzdO1LTxTI2iqVDYhOH0FcWqfWI3AIvtij95OAcQGoG5LA3ZFyMT33BU/
   0YBWtIMtvm7anxb0zglETO13r6yUs++L7VnCuNeZv9VdRv0oNrvy6yHnw
   a4w2a6GukZEWvxFV+9LD0it4U3oeJNowH8K99KzHeARXJQFbCvvlEaUdU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="307282189"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="307282189"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 10:05:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="587937625"
Received: from staibmic-mobl1.amr.corp.intel.com (HELO [10.209.67.166]) ([10.209.67.166])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 10:05:02 -0700
Message-ID: <cff391af-9523-46d6-97c8-ac9917097d96@intel.com>
Date:   Tue, 28 Jun 2022 10:03:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
 <28110f9c-b84c-591a-d365-ae4412408e48@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <28110f9c-b84c-591a-d365-ae4412408e48@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 17:48, Xiaoyao Li wrote:
>>
>> I meant this:
>>
>> +       switch (level) {
>> +       case PG_LEVEL_4K:
>> +               page_size = 0;
>> +               break;
>>
>> Because TDX_PG_4K==page_size==0, and for this:
>>
>> +       case PG_LEVEL_2M:
>> +               page_size = 1;
> 
> here we can just do
> 
>     page_size = level - 1;
> 
> or
>     
>     tdx_page_level = level - 1;
> 
> yes, TDX's page level definition is one level smaller of Linux's
> definition.

Uhh.  No.

The 'page_size' is in the kernel/TDX-module ABI.  It can't change.
PG_LEVEL_* is just some random internal Linux enum.  It *CAN* change.

There's a *MASSIVE* difference between the two.  What you suggest will
probably actually work.  But, it will work accidentally and may break in
horribly confusing ways in the future.

It's the difference between hacking something together and actually
writing code that will keep working for a long time.  Please, take a
minute and reflect on this.  Please.
