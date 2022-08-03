Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00785588E95
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiHCOXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 10:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbiHCOWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 10:22:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30BF2A244;
        Wed,  3 Aug 2022 07:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659536571; x=1691072571;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ARwyAl2EszMC/rUU5o5wSvHaFBqvGsQKMB4jjBXC5Dw=;
  b=NVwjBQNvq8ZpNqCxZyyESGSiGG5FRgnZDqFldz6PGKRC/4vW3PlxoUx1
   xSEmR/dmjRBQTUNrr0QpXY2AIO9+H6DepC20FRU4KtWATHCmmleqjd3TG
   OPUTyt0FwRUiuB950TDpcbfeb3VN8JZr0FME6g1NLoOb8YHdGVDMcdS02
   XZkedO+TAjIqc6+mHrNjnlHPxxBeW2m21XJztYLRntne83ShOcQ4fDF0e
   RxJMBpE/jr4kfi0O8hpTM2yvUAHpHvcxFwEmrMQ3Q8l69yZIC/33YXn0v
   7aUzZgFb9VA9wm9uOjfAxG76LX4cEQUSmXMrCxb/TkhES2CqMGHN0+/J1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="290900314"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="290900314"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 07:22:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="631166445"
Received: from buichris-mobl.amr.corp.intel.com (HELO [10.209.124.150]) ([10.209.124.150])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 07:22:50 -0700
Message-ID: <675ac8a7-be1c-9e9e-9530-bd1488c99dc9@intel.com>
Date:   Wed, 3 Aug 2022 07:22:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
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
 <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
 <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
 <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
 <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
 <da423f82faec260150b158381a24300f3cd00ffa.camel@intel.com>
 <d3236016c46da2cbdf314839255e8806ae23f228.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d3236016c46da2cbdf314839255e8806ae23f228.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/22 18:30, Kai Huang wrote:
> On Fri, 2022-07-08 at 11:34 +1200, Kai Huang wrote:
>>> Why not just entirely remove the lower 1MB from the memblock structure
>>> on TDX systems?  Do something equivalent to adding this on the kernel
>>> command line:
>>>
>>>  	memmap=1M$0x0
>> I will explore this option.  Thanks!
> Hi Dave,
> 
> After investigating and testing, we cannot simply remove first 1MB from e820
> table which is similar to what 'memmap=1M$0x0' does, as the kernel needs low
> memory as trampoline to bring up all APs.

OK, so don't remove it, but reserve it so that the trampoline code can
use it.
