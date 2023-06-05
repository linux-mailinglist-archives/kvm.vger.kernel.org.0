Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7C7721BDC
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 04:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjFECNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 22:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjFECNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 22:13:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BA8B1;
        Sun,  4 Jun 2023 19:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685931212; x=1717467212;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l25PqmRhj6mGQ0+gMnNtHUBK6nJpcKBVAjCUOlZNLEg=;
  b=Jxbr21UdALVX9+E31731NtFEsdLpxn4vFnds1Gh69ZJQ/7LOU1EWNq7k
   Cu+ih8JLmYmuZTpczUHPouAqrr+77qi4mu2UWWbhK9Qijx4Y9EVPX6xQo
   +58jWPaUmDyJzC2heFq2ZfPcaCT2QbsFchOpidw5EAucaEQBCBR3VfSkX
   tVG+YJppwmM8gA24nBW5XwruqiXBt03RHNv9q1LcH97ci1yT2baSAaTUa
   p2mwzMap3+KUC3BOqPA2RtHmAWEjPp3qpI5UYXP3+nHGcILHIXqRp0z1T
   Qcch01T2/qjoxF3Y+/3ledjgmZN6XcMICIkhtszHGbwgCcxXb7+DfaZyE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="384557932"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="384557932"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 19:13:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="773545268"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="773545268"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.215.231]) ([10.254.215.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 19:13:25 -0700
Message-ID: <55e7b947-ca2f-c6a3-bb38-af4cd0ebc183@intel.com>
Date:   Mon, 5 Jun 2023 10:13:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.2
Subject: Re: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/2023 10:27 PM, Kai Huang wrote:
> == Problem ==
> 
> A partial write to a TDX private memory cacheline will silently "poison"
> the line.  Subsequent reads will consume the poison and generate a
> machine check.  According to the TDX hardware spec, neither of these
> things should have happened.

The expectation is that write to TDX private memory with HKID 0 doesn't 
poison the cache line. However, a partial write with HKID 0 does poison 
the cache line. This is the erratum, right?

> To add insult to injury, the Linux machine code will present these as a
> literal "Hardware error" when they were, in fact, a software-triggered
> issue.

