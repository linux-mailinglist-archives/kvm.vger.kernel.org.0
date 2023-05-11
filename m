Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC95F6FE973
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 03:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbjEKB1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 21:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbjEKB1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 21:27:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD65BA9;
        Wed, 10 May 2023 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683768469; x=1715304469;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z62C8M1tWfn4U6wg5u2pI6YKTBsSY36H16SFQnfBkLg=;
  b=XiG0OoyKNFndIK3GwnWtoczWb6ybzI16q4GoivfdTuJZZxVl1vB7hTZ5
   /Xik1UcnMRmDWzU9EYbwhAhANmALdJFuGpnFy3PNmMI1TwNYjbhey59B/
   +cCA/McDRw5rzjlltcjjFeBKxI6oxQQWZeVErOHRFdWWnRHOAjtHfQzg0
   s/48h09D+SjkWOjggJ4U/5Cvoe0fHS+QwUjlF4BzTuh85oe6jT1w5m4AW
   EpwU0I3HgSopAP5CX8uUPcM/aEhzUhxdaMO+VFrVqLTEOfFovYdP6wGnE
   t1TycSxXFbwV+wVFVgH3gFfOVy7AD28vEmDrA4XMKZwnYOevahfk70JK4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="436691263"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="436691263"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:27:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="649944172"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="649944172"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.43]) ([10.254.215.43])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:27:47 -0700
Message-ID: <0b5ba30f-2b95-3f2d-b2bb-c3101abb3716@linux.intel.com>
Date:   Thu, 11 May 2023 09:27:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        robert.hu@linux.intel.com
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-4-binbin.wu@linux.intel.com>
 <ZFtcwACy/1rn2Py1@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZFtcwACy/1rn2Py1@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/10/2023 4:58 PM, Chao Gao wrote:
>> @@ -7743,6 +7744,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> 		vmx->msr_ia32_feature_control_valid_bits &=
>> 			~FEAT_CTL_SGX_LC_ENABLED;
>>
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
>> +		vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | X86_CR3_LAM_U57;
> This function can be called multiple times. We need to clear LAM bits if LAM
> isn't exposed to the guest, i.e.,
>
> 	else
> 		vcpu->arch.cr3_ctrl_bits &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
Nice catch, will fix it, thanks.


>
> With this fixed,
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>

