Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6767852CEA2
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbiESItp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 04:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbiESItk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 04:49:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3016A9CF42;
        Thu, 19 May 2022 01:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652950174; x=1684486174;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lWZmcSgWhxQnzMFbbGiVHJHijQBfJKZ/Aeb1nkaJqSo=;
  b=BOkakh8KL24p6csb7g08ng5Gfzsk0qdKJ/Uv5Nq8+perlg4DDek6JZqa
   F9F9jqCGX3/czlUdge+66XuP5J/t3bCrEcItVqItC7xnMmDrpAjZRxL82
   qdqszYmOD8sXtkHV1/y3mXXFJquSkmqKy8yvHR7lIgl9ZrJW1pJBfj4KS
   8CRKK3n5LZ6Ec4fY7bNDN3UQHHLNQBlZa+tfGI1Vq8fQTpNTd2o9KzPpP
   ZDp/QpZO7qCXF8tO3XnELEdo8gE/yBBljvmGgszaOSUmY/bxs0n2hW9PX
   zK5tHVtbjJxBO43Kip+7jpYm13iCFaNQmX7r/khK6QA4lMYDYEfNW/Bmc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="254150315"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="254150315"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 01:49:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="598443191"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.31.218]) ([10.255.31.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 01:49:30 -0700
Message-ID: <908bc121-ceb8-e296-3397-643733016ecc@intel.com>
Date:   Thu, 19 May 2022 16:49:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v15 07/14] KVM: VMX: Emulate reads and writes to CET MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        John Allen <john.allen@amd.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-8-weijiang.yang@intel.com>
 <YoUW4Oh0eRL9um5m@dell9853host> <YoUb4/iP+X+xgsfQ@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YoUb4/iP+X+xgsfQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/19/2022 12:16 AM, Sean Christopherson wrote:
> On Wed, May 18, 2022, John Allen wrote:
>> On Wed, Feb 03, 2021 at 07:34:14PM +0800, Yang Weijiang wrote:
>>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>>> +		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
>>> +			return 1;
>>> +		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
>> Sorry to revive this old thread. I'm working on the corresponding SVM
>> bits for shadow stack and I noticed the above check. Why isn't this
>> GENMASK(1, 0)? The *SSP MSRs should be a 4-byte aligned canonical
>> address meaning that just bits 1 and 0 should always be zero. I was
>> looking through the previous versions of the set and found that this
>> changed between versions 11 and 12, but I don't see any discussion
>> related to this on the list.
> Huh.  I'm not entirely sure what to make of the SDM's wording:
>
>    The linear address written must be aligned to 8 bytes and bits 2:0 must be 0
>    (hardware requires bits 1:0 to be 0).
>
> Looking at the rest of the CET stuff, I believe requiring 8-byte alignment is
> correct, and that the "hardware requires" blurb is trying to call out that the
> SSP stored in hardware will always be 4-byte aligned but not necessarily 8-byte
> aligned in order to play nice with 32-bit/compatibility mode.  But "base" addresses
> that come from software, e.g. via MSRs and whatnot, must always be 8-byte aligned.
Thanks Sean, I cannot agree more ;-)
