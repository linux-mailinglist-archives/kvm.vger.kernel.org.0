Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5B7273BB
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 02:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjFHAaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 20:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjFHA36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 20:29:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA802128;
        Wed,  7 Jun 2023 17:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686184197; x=1717720197;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TDhH3H4jg2X/8d8NcY3cf7ZRv9oNiNqThvaMDhA7KtI=;
  b=T/IPP0C51J8+9miklCFM5xoA+7PBkeTPx/gZ6CXT3PsqVDIbEQNZnDGU
   CPUn/djcfArAQwMN180UsMne1825xjLcvX6xzXs9da+eyaBpM9IhjHW77
   ROxd2n8RhenjUWrITst3HDbfRaFX5FStExMCZc6m6gJIJ9Fqsl7zMq71w
   bblauOzvYdhKsUvlWGOAD0wct3DZSR0uwvrWJQTeFIGI26OBVUmURKNGA
   S8yfhSXgH98dtEw/FSjvNTEytslbWNX7UdGoDP4FRzrxeCVGUEo2cS4+9
   R3ASTgnB94Sqs44KcruAFpbwtQAap3281V0Vc1nQg4sXOFGkkKB+6vNvk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="346762802"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="346762802"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="779664634"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="779664634"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:29:56 -0700
Message-ID: <c957ce2e-fb91-47bd-5ca2-2c7ba7f612c6@intel.com>
Date:   Wed, 7 Jun 2023 17:29:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
 <1e58e3df-ae9a-607c-cfc3-4f3d033ed531@intel.com>
 <c05384781a900ec5f36809d3036f7af64ef3c997.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c05384781a900ec5f36809d3036f7af64ef3c997.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/23 16:36, Huang, Kai wrote:
> On Wed, 2023-06-07 at 08:08 -0700, Hansen, Dave wrote:
>> On 6/4/23 07:27, Kai Huang wrote:
>>> Certain SEAMCALL leaf functions may return error due to running out of
>>> entropy, in which case the SEAMCALL should be retried as suggested by
>>> the TDX spec.
>>>
>>> Handle this case in SEAMCALL common function.  Mimic the existing
>>> rdrand_long() to retry RDRAND_RETRY_LOOPS times.
>>
>> ... because who are we kidding?  When the TDX module says it doesn't
>> have enough entropy it means rdrand.
> 
> The TDX spec says "e.g., RDRAND or RDSEED".

Let's just say something a bit more useful and ambiguous:

	Some SEAMCALLs use the RDRAND hardware and can fail for the
	same reasons as RDRAND.  Use the kernel RDRAND retry logic for
	them.

We don't need to say "RDRAND and RDSEED", just saying "RDRAND hardware"
is fine.  Everybody knows what you mean.
