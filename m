Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1102525049
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355431AbiELOjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355071AbiELOi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:38:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92197EAD0C;
        Thu, 12 May 2022 07:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652366337; x=1683902337;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=bOl39S9FUmv+PaeqjC4lbDx3yxwJ/hYZ3cBKJY/+ajA=;
  b=RvP0CBa4ZRZHDHc2avOxh0+3JNStlH32AOk2QvM88ccYI57GNx0gSgpe
   jSLHaIPy97Tn1IkE7fHu8vELjCTL7/t+CuEFn/sgI69CDgaRWyNRx+Vmm
   bOHGVg2DyE4NfdQQLEC7fo918TcgR3EmMsrHsRPvskYoe+W3ymZqy8gFt
   Nf4KgglF+bx6I3Bm35JTs2Fb3T/biP6Ks6kRydRQtfCJNDzBoCXJjChFp
   nEGs3avJDuT8K+3BvOx7e42LEPBlczTF5ZJfp5rTdYV65J+sgSd7PBV73
   hOq5BH5BPn5/qYaBYsREmN5oNynjZxxRl0h/BefbHO73nOhmNPUH00bHN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269957370"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="269957370"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 07:38:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="594692886"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.28.40]) ([10.255.28.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 07:38:53 -0700
Message-ID: <7a8eb4a3-c58a-fd32-4419-4e799870c757@intel.com>
Date:   Thu, 12 May 2022 22:38:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
 <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
 <9e2b5e9f-25a2-b724-c6d7-282dc987aa99@intel.com>
 <8a15c4b4-cabe-7bc3-bd98-bd669d586616@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8a15c4b4-cabe-7bc3-bd98-bd669d586616@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/12/2022 9:18 PM, Paolo Bonzini wrote:
> On 5/11/22 09:43, Yang, Weijiang wrote:
>>> Instead of using flip_arch_lbr_ctl, SMM should save the value of the MSR
>>> in kvm_x86_ops->enter_smm, and restore it in kvm_x86_ops->leave_smm
>>> (feel free to do it only if guest_cpuid_has(vcpu, X86_FEATURE_LM), i.e.
>>> the 32-bit case can be ignored).
>> In the case of migration in SMM, I assume kvm_x86_ops->enter_smm()
>> called in source side
>>
>> and kvm_x86_ops->leave_smm() is called at destination, then should the
>> saved LBREn be transferred
>>
>> to destination too? The destination can rely on the bit to defer setting
>> LBREn bit in
> Hi, it's transferred automatically if the MSR is saved in the SMM save
> state area.  Both enter_smm and leave_smm can access the save state area.
>
> The enter_smm callback is called after saving "normal" state, and it has
> to save the state + clear the bit; likewise, the leave_smm callback is
> called before saving "normal" state and will restore the old value of
> the MSR.

Got it thanks!

But there's no such slot for MSR_ARCH_LBR_CTL in SMRAM, do you still suggest

using this mechanism to implement the LBREn clear/restore logic?

> Thanks,
>
> Paolo
>
>> VMCS until kvm_x86_ops->leave_smm() is called. is it good? thanks!
