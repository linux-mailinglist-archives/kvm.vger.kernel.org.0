Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72A3695DD9
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 10:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjBNJBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 04:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjBNJBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 04:01:12 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221EE22DFA
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 01:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676365267; x=1707901267;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9bbQQTyA5iea3mBo1igrVeDMVxlYdweThs5/7tbwbO0=;
  b=iIDEpEZwl8tGS3wbK/lqFRP7XM1M/VDw+M5ioZOWJzXpwVPgXrnPEPIU
   BQzB8ic6pMErQq1trrM9z22Jl/Yi8YGuUn2eRbwmu8IyjC9Ue3yLuv+GE
   SvIUCDcGHITr1TBTqrYZYef9omsUhZURiz9+QCxsnDwyKh2ndMVy7Jk81
   WRIUPiq8Z4EsPY3d/qUKUxASUHRJR9a6NP+ZIsOWO26yvrunRYJxUxzbU
   IHRox+C3Ht2N68w7Cpw98fwsnC36AS2XzLmqvxGG7LP9SaL3izE28Vh//
   pOwO9rNHAZnM36z9b7s5RAapC1CoFA3Jgp7HnSzEYlOoIi3B5KO1vSfgv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="417332701"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="417332701"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 01:01:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="699477737"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="699477737"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.213.213]) ([10.254.213.213])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 01:01:00 -0800
Message-ID: <1e8df25a-4c25-6738-dd92-a58c28282eb0@linux.intel.com>
Date:   Tue, 14 Feb 2023 17:00:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-2-robert.hu@linux.intel.com>
 <814481b6-c316-22bd-2193-6aa700db47b5@linux.intel.com>
 <90d0f1ffec67e015e3f0f1ce9d8d719634469a82.camel@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <90d0f1ffec67e015e3f0f1ce9d8d719634469a82.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/14/2023 2:11 PM, Robert Hoo wrote:
> On Tue, 2023-02-14 at 09:27 +0800, Binbin Wu wrote:
>> The interception of CR4 is decided by CR4 guest/host mask and CR4
>> read
>> shadow.
>>
> My interpretation is that "intercept CR4.x bit" is the opposite of
> "guest own CR4.x bit".
> Both of them are implemented via CR4 guest/host mask and CR4 shadow,
> whose combination decides corresponding CR4.x bit access causes VM exit
> or not.
> When we changes some bits in CR4_RESERVED_BITS and
> __cr4_reserved_bits(), we changes vcpu->arch.cr4_guest_owned_bits which
> eventually forms the effective vmcs_writel(CR4_GUEST_HOST_MASK).
>
According to the code of set_cr4_guest_host_mask,
vcpu->arch.cr4_guest_owned_bits is a subset of KVM_POSSIBLE_CR4_GUEST_BITS,
and X86_CR4_LAM_SUP is not included in KVM_POSSIBLE_CR4_GUEST_BITS.
No matter change CR4_RESERVED_BITS or not, X86_CR4_LAM_SUP will always be set in CR4_GUEST_HOST_MASK.


