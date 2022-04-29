Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E40F5152FC
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiD2RxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345635AbiD2RxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:53:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF74D3993;
        Fri, 29 Apr 2022 10:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651254586; x=1682790586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6PO7TJrMwheafNd4JcSQG/q9LVcYu2jJZi/WoopzbnQ=;
  b=Im816ewbzH10ZU11K4ur7lk5QA+ptUQHg17nidAMQyB83xYvWsxSUzb9
   Q5c99g1ykPzyIkCePzUpiNRv9/ymjwLC7aFjGTBHjFe91oaDFyMvzKpDb
   kJkn3z1QsPgGN+2y0J8bP/4defRfgPi4zEhti0Xde3BucPUjHVzPhs8rL
   rGC/8CQ7Fqil1ULmYrfuWUEx5ya840wgis4S5+8ddk36zRqDujEtf9Oum
   kweSxv39zZoF3clC/oY3d+ItWfrnzLe8u8Kn+6JndTHbdAXNLWQI/t+9t
   FxQE0PRgj+is6JtZIWQei4fF5Jml18zOij8dy5/y7DyH7i2/PbTUrkTme
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291898825"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="291898825"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 10:47:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582297691"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 10:47:35 -0700
Message-ID: <4aea41ea-211f-fbde-34e9-4c4467ebc848@intel.com>
Date:   Fri, 29 Apr 2022 10:47:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
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
 <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
 <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
 <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
 <98f81eed-e532-75bc-d2d8-4e020517b634@intel.com>
 <be31134cf44a24d6d38fbf39e9e18ef223e216c6.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <be31134cf44a24d6d38fbf39e9e18ef223e216c6.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/22 16:14, Kai Huang wrote:
> On Thu, 2022-04-28 at 07:06 -0700, Dave Hansen wrote:
>> On 4/27/22 17:15, Kai Huang wrote:
>>>> Couldn't we get rid of that comment if you did something like:
>>>>
>>>> 	ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);
>>>
>>> Yes will do.
>>>
>>>> and preferably make the variables function-local.
>>>
>>> 'tdx_sysinfo' will be used by KVM too.
>>
>> In other words, it's not a part of this series so I can't review whether
>> this statement is correct or whether there's a better way to hand this
>> information over to KVM.
>>
>> This (minor) nugget influencing the design also isn't even commented or
>> addressed in the changelog.
> 
> TDSYSINFO_STRUCT is 1024B and CMR array is 512B, so I don't think it should be
> in the stack.  I can change to use dynamic allocation at the beginning and free
> it at the end of the function.  KVM support patches can change it to static
> variable in the file.

2k of stack is big, but it isn't a deal breaker for something that's not
nested anywhere and that's only called once in a pretty controlled
setting and not in interrupt context.  I wouldn't cry about it.
