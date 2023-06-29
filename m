Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCD67420E3
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 09:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjF2HWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 03:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjF2HWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 03:22:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A943E58;
        Thu, 29 Jun 2023 00:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688023327; x=1719559327;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RWlglnd1GZvN4YNbZiuqTYhsWI29Q3eo3GdCOLcHoVc=;
  b=lAPDESwLF8NH7UQ8N3PzWMH2zE0b3j72KjxJH3kn6v/nt/wazeEhj1oi
   hCyR5jhwF8nOTLrbrybLWBxjiXkKX8o6SorpX8w32F2g5GIU2/PtuVINN
   pMN4Q6jEmLVR3MHt8qS9lNmkHSsGBIacpZGLCBF4aDr9cry5EKCKtoAQy
   44mzc6G6/6jd/GeI1dsyMN3fN/gz4F1VAUbNQ+bEcsj3o63B16xH9V1Ix
   S5auyCANj4XVvnQsH+LDLTGrA6tSgxfE1+hLyptEKjczzaUm8xiddRvWM
   uzlUdAFFE66PvFMeB0dsWa2uQ+cUrhhCLAQ0kbU0MBam/b1QDWeKQpNGh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392765441"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="392765441"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 00:22:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="891315772"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="891315772"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 00:22:04 -0700
Message-ID: <5a9e57e3-0361-77f8-834f-edb8600483e1@linux.intel.com>
Date:   Thu, 29 Jun 2023 15:22:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, kai.huang@intel.com, David.Laight@aculab.com,
        robert.hu@linux.intel.com
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com>
 <ZJt7vud/2FJtcGjV@google.com>
 <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
 <ZJ0rcVpSjbZInnIq@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZJ0rcVpSjbZInnIq@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/29/2023 2:57 PM, Chao Gao wrote:
> On Thu, Jun 29, 2023 at 02:12:27PM +0800, Binbin Wu wrote:
>>>> +	/*
>>>> +	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
>>>> +	 * If not set, vCPU doesn't supports LAM.
>>>> +	 */
>>>> +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
>>> This is unnecessary, KVM should never allow the LAM bits in CR3 to be set if LAM
>>> isn't supported.
> A corner case is:
>
> If EPT is enabled, CR3 writes are not trapped. then guests can set the
> LAM bits in CR3 if hardware supports LAM regardless whether or not guest
> enumerates LAM.
I recalled the main reason why I added the check.
It's used to avoid the following checking on CR3 & CR4, which may cause 
an additional VMREAD.

Also, about the virtualization hole, if guest can enable LAM bits in CR3 
in non-root mode without cause any problem,
that means the hardware supports LAM, should KVM continue to untag the 
address following CR3 setting?
Because skip untag the address probably will cause guest failure, and of 
cause, this is the guest itself to blame.
But untag the address seems do no harm?



