Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C5E698C05
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 06:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBPFbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 00:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBPFbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 00:31:48 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791791BEC
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 21:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676525506; x=1708061506;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YpGGjxXBgRUXDWZRTTAVOSNDs0rn3lq38WRq/zKWQkY=;
  b=H/qcJZjK1WBbUdBBshW1OClheLYVLFfkPjkHxBY7PO/0TAjwrzSh3bGB
   +q0HjntbZmItPXMV8moSsr4jjZkEvt80XLjR0X903jHj15FI+rVtzVFoU
   7sXaOXIfUlODGkIx5BY1IUsxnW3SaWaAF064UmwFOtPTDUDNfhG8zcmDA
   X25pX1ujS3y5WZQ6kVJgdz+OYOnO7BAxr6z1+hAhYj5oIzQkz0rqWfTN8
   Q+SvbTk3cGktbaXj2c62ois8EQc4ntiEaKto/2bcxGRVwIT5PBDRcfsRm
   36GL7S69jkLNmy/gSvVjqhNEXJYPvzauP2f1/0t5aRx15Ocie2b42nnpX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333794743"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="333794743"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 21:31:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="702440244"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="702440244"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.250]) ([10.238.1.250])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 21:31:41 -0800
Message-ID: <264acaa2-ba77-685b-04c3-35e4c7db52f0@linux.intel.com>
Date:   Thu, 16 Feb 2023 13:31:39 +0800
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
 <1e8df25a-4c25-6738-dd92-a58c28282eb0@linux.intel.com>
 <d1d819b00a6dda7a58b25f7b0692ad53473497d8.camel@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d1d819b00a6dda7a58b25f7b0692ad53473497d8.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/14/2023 8:24 PM, Robert Hoo wrote:
> On Tue, 2023-02-14 at 17:00 +0800, Binbin Wu wrote:
>> According to the code of set_cr4_guest_host_mask,
>> vcpu->arch.cr4_guest_owned_bits is a subset of
>> KVM_POSSIBLE_CR4_GUEST_BITS,
>> and X86_CR4_LAM_SUP is not included in KVM_POSSIBLE_CR4_GUEST_BITS.
>> No matter change CR4_RESERVED_BITS or not, X86_CR4_LAM_SUP will
>> always be set in CR4_GUEST_HOST_MASK.
>>
>>
> set_cr4_guest_host_mask():
> 	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
> 			~vcpu->arch.cr4_guest_rsvd_bits;

My point is  when X86_CR4_LAM_SUP is not set in KVM_POSSIBLE_CR4_GUEST_BITS,
CR4.LAM_SUP is definitely owned by host, regardless of the value of 
cr4_guest_rsvd_bits.


>
> kvm_vcpu_after_set_cpuid():
> 	vcpu->arch.cr4_guest_rsvd_bits =
> 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
>
