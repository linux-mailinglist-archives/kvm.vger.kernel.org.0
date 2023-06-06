Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1417723865
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 09:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbjFFHIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 03:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbjFFHIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 03:08:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19607B2
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 00:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686035301; x=1717571301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g803pMNA2wmAwc/9nZuEs5fpVitT7acZiO6TMXeDKZk=;
  b=RZKm74g0+UG1006nWOCVZNfAaNgJ5l+wyvCrQ5WNg00Xfpa9Me4CQTL/
   BYPowMVyODkRF/6vcF+aMlJnHv235QWE9ht7d9dpohX/1jQjT2BWJFM+S
   Yzh5ZFQNVB9ZYY6B5T/lAVPxSS4UQ9NMPfZJT3bLsgjIcopsgJKmKynOT
   0DM8Y1xVKbL1dd3j5QWq4ZrbjiGb9D6OYdIDLhYE4VDmBuoeqdAdt0p4Q
   So2Y/uYKW90BUqfCspmikgFqD32D6Fs74XyT5ymN+nUhN/5mhUyUEWk6g
   JxP9EGvCAL8LAddHpUuJyMPs0HxT2gsd6n58+S1fkJkWuOCn2OC2TBpoY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336945213"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336945213"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 00:08:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="955637446"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="955637446"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.170.159]) ([10.249.170.159])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 00:08:19 -0700
Message-ID: <bf0996fa-9c12-fb72-e471-e914f6a32ad0@linux.intel.com>
Date:   Tue, 6 Jun 2023 15:08:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 4/4] x86: Add test case for INVVPID with LAM
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
 <20230530024356.24870-5-binbin.wu@linux.intel.com>
 <ZH3hqvoaQkQ8qK/n@chao-email>
 <fa4a405f-0ee6-c6de-7947-e56c4ee22734@linux.intel.com>
 <ZH7aGywSih+TcFyu@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZH7aGywSih+TcFyu@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/6/2023 3:02 PM, Chao Gao wrote:
> On Tue, Jun 06, 2023 at 01:47:07PM +0800, Binbin Wu wrote:
>>>> +	try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
>>> shouldn't we use a kernel address here? e.g., vaddr. otherwise, we
>>> cannot tell if there is an error in KVM's emulation because in this
>>> test, LAM is enabled only for kernel address while INVVPID_ADDR is a
>>> userspace address.
>> INVVPID_ADDR is the invalidation type, not the address.
>> The address used  here is NONCANONICAL, which is 0xaaaaaaaaaaaaaaaaull and
>> is considered as kernel address.
> Yes. Sorry about this misunderstanding.
>
> Do you need the address to be canonical after masking metadata?

You are right, I will use set_la_non_canonical(), which is added in 2/4 
to pass a proper address for test.
Thanks.


