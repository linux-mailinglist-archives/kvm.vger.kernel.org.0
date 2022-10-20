Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9876063DB
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJTPJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJTPJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:09:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76403F30E;
        Thu, 20 Oct 2022 08:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666278586; x=1697814586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2IurqlhG+WiW0enAAYE9odToUJj7X6n8Po90Vwdhvnw=;
  b=gsK/4lvDr/6mxP/n7nIBlFcUtv4W4PyvOM4cIaMag2mWN64KnsrsDvqR
   8eAEcYaSz+IjNNvxsVXf0uyY9CBbiafG3mXzO0+8EZdWpvHfbl5BccMDm
   VSf/pZVu2war0F5yeh8wnb0PJbJy3vNk3awdx/bCEpZ0HR9zPCbpqRCnF
   XQ57pfoU9+HAO/zb1ndkA6CgQBgDn20GgwJFy8O535BR2iJE+4mD5WMBx
   28FsKjYcA4PvUbJIEH+J4zEC254bMr9Ytd/yXSXhnPeZeibzZy9buVWyL
   mLcUwpV1F3fEpTafYBOZAevB+1NASYzLQPCSUX/MOg3/nWpXq/aPZ9Nn+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="290043213"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="290043213"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 08:07:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="804938938"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="804938938"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.141]) ([10.255.30.141])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 08:07:16 -0700
Message-ID: <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
Date:   Thu, 20 Oct 2022 23:07:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.3
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
 <Y1FatU6Yf9n5pWB+@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Y1FatU6Yf9n5pWB+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/2022 10:27 PM, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Xiaoyao Li wrote:
>> vcpu->arch.mcg_cap represents the value of MSR_IA32_MCG_CAP. It's
>> set via ioctl(KVM_X86_SETUP_MCE) from userspace when exposing and
>> configuring MCE to guest.
>>
>> It's wrong to leave the default value as KVM_MAX_MCE_BANKS.
> 
> Why?  I agree it's an odd default, but the whole MCE API is odd.  Functionally,
> I don't see anything that's broken by allowing the guest to access the MCx_CTL MSRs
> by default.

Yes. Allowing the access doesn't cause any issue for a VM.

However, for the perspective of virtualization. It virtualizes a magic 
hardware that even CPUID.MCA/MCE is not advertised and MCE is not set up 
by userspace, guest is told there are 32 banks and all the banks can be 
accessed.

The patch doesn't fix any issue but try to make the code more reasonable.
