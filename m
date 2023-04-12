Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DF36DED29
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 10:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjDLICo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 04:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLICn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 04:02:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CFA59F4;
        Wed, 12 Apr 2023 01:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681286562; x=1712822562;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=elGtqN9uf2ct4fffBNjNDmoB102spyDxuH+prGf6E1M=;
  b=Jq9wM6jq6KYanSXIWp2/DcoW/N01mLrCcdAXljrUTp2d2qVbATchg3u/
   db9V5Z1ax0TiLaiywW0qfu2RiKEvHyJHYtP+lErxIse05q5WM9vP5RtdI
   BqZTE2BHzn8SYEwnHMFpUAIdZ7VqDJAVmKg9jiEE7P5oeG4STo/Ynehq/
   0xbXl0yBcXV8kjc4/cSEn2874v+L7emtQJ74XIkYcGSW+RumKS2l6bvf7
   9DC3WJHvX6YDg9zHI+Py8tIFXJzncGVdMcOsHBosXBQqI//ISmCIw244v
   uyX0ZytUclh3GFMqOt92ENe7f4koPByQJ4aERzqO/OZUURGTPGsrv3Nyu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346509412"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="346509412"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 01:02:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="1018660314"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="1018660314"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.206]) ([10.255.29.206])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 01:02:38 -0700
Message-ID: <f8beddb6-5139-07e7-c880-6767b1e9ba40@intel.com>
Date:   Wed, 12 Apr 2023 16:02:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH 1/2] KVM: VMX: Use kvm_read_cr4() to get cr4 value
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230410125017.1305238-1-xiaoyao.li@intel.com>
 <20230410125017.1305238-2-xiaoyao.li@intel.com> <ZDRDKsPGP9JI2MHA@google.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZDRDKsPGP9JI2MHA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/2023 1:11 AM, Sean Christopherson wrote:
> On Mon, Apr 10, 2023, Xiaoyao Li wrote:
>> Directly use vcpu->arch.cr4 is not recommended since it gets stale value
>> if the cr4 is not available.
>>
>> Use kvm_read_cr4() instead to ensure correct value.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d7bf14abdba1..befa2486836b 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3431,7 +3431,7 @@ static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   
>>   void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   {
>> -	unsigned long old_cr4 = vcpu->arch.cr4;
>> +	unsigned long old_cr4 = kvm_read_cr4(vcpu);
> 
> Ha!  I've been tempted to change this multiple times, but always thought I was
> just being a bit obsessive :-)
> 
> Patches look good, but I'm going to hold them for 6.5 just in case this somehow
> causes a problem, e.g. if there's a bizzaro nested path that "works" because KVM
> _doesn't_ decache info from the current VMCS.

so you will put it in kvm-next after 6.4 merge windows?
