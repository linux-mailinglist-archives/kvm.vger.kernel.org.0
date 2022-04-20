Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C1E508AD1
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 16:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379718AbiDTOdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 10:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379704AbiDTOdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 10:33:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE341B785;
        Wed, 20 Apr 2022 07:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650465014; x=1682001014;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=caz7Acjfh+ayxvJFE2jIxLIKISpQ58mVtpsDjKc5KNo=;
  b=lSXvb+nfA6viSDKh5AiQHSTFd40hlLTkTPChXxWI0tzTCui/UYo1AMhn
   hiVHmI9m4zOiksaIw4KZuEyuxKEP8pTrjhMH9Luv/czLy5PbCh3a+eWzW
   AKM8MuKcUQf8UADxJK21IHcHelkB4L6xhwitw2A0KTKbpWHj8//paUFzD
   x352HZL0mLlfwOs2ZGVXF7wAk89AX2DqlF/Yy5A4YzxY2YbRiF5I2Ealt
   r9b9LOlshcuQLhTWosBaC2CnsuRJIxNyNqxHv81ZhI7Vzx/hcoubwnj0v
   ldkdq6O/6rhlNjRrvg73J0SMKHN6wld3u2yS2lTEzo5PNe+BLkXww2krh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="350487761"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="350487761"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 07:30:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="614430624"
Received: from myworkcomp1.amr.corp.intel.com (HELO [10.255.231.103]) ([10.255.231.103])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 07:30:12 -0700
Message-ID: <136845e1-fe43-fbb6-3a95-741c46c42156@linux.intel.com>
Date:   Wed, 20 Apr 2022 07:30:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
 <bc078c41-89fd-0a24-7d8e-efcd5a697686@linux.intel.com>
 <fd954918981d5c823a8c2b8d1b346d4eb13f334f.camel@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <fd954918981d5c823a8c2b8d1b346d4eb13f334f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/19/22 9:37 PM, Kai Huang wrote:
> On Tue, 2022-04-19 at 07:53 -0700, Sathyanarayanan Kuppuswamy wrote:
>>
>> On 4/5/22 9:49 PM, Kai Huang wrote:
>>> The TDX module is essentially a CPU-attested software module running
>>> in the new Secure Arbitration Mode (SEAM) to protect VMs from malicious
>>> host and certain physical attacks.  The TDX module implements the
>>
>> /s/host/hosts
> 
> I don't quite get.  Could you explain why there are multiple hosts?

Sorry, I misread it. It is correct, so ignore it.

> 
>>

>>> +
>>> +/**
>>> + * tdx_detect - Detect whether the TDX module has been loaded
>>> + *
>>> + * Detect whether the TDX module has been loaded and ready for
>>> + * initialization.  Only call this function when all cpus are
>>> + * already in VMX operation.
>>> + *
>>> + * This function can be called in parallel by multiple callers.
>>> + *
>>> + * Return:
>>> + *
>>> + * * -0:	The TDX module has been loaded and ready for
>>> + *		initialization.
>>> + * * -ENODEV:	The TDX module is not loaded.
>>> + * * -EPERM:	CPU is not in VMX operation.
>>> + * * -EFAULT:	Other internal fatal errors.
>>> + */
>>> +int tdx_detect(void)
>>
>> Will this function be used separately or always along with
>> tdx_init()?
> 
> The caller should first use tdx_detect() and then use tdx_init().  If caller
> only uses tdx_detect(), then TDX module won't be initialized (unless other
> caller does this).  If caller calls tdx_init() before tdx_detect(),  it will get
> error.
> 

I just checked your patch set to understand where you are using
tdx_detect()/tdx_init(). But I did not find any callers. Did I miss it? 
or it is not used in your patch set?

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
