Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D5F7D231A
	for <lists+kvm@lfdr.de>; Sun, 22 Oct 2023 14:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjJVMf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 08:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjJVMf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 08:35:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0D2F7;
        Sun, 22 Oct 2023 05:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697978153; x=1729514153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yi9S8qFYA7qeOGAPjOjM2PKgIEyoT8Vi+9i0QilN0HM=;
  b=nByA4xc2WiON1vldnvomTo3QScenkes/kbIuZ68U13O6RHzFiQJyCltw
   UGP/PeBD3KA7/8cXSi/2vZyHO0PvJt9XYu0k4CTEx3qvgzcx89kx7UvOv
   7X5cVU2AzsTFdWfuOvksI5dwFHLF3UJgXzBbOKacpyBUzfFWkh2YrEmK9
   AaCyrRiW3R76xjySo2ufl4mtqMW3hV0GPCdGSJvtjNh/W0VPQ4sbZSjjk
   Sr7DRYrwfBfTbOW/yE7hzLb0HVrpJeoYFWQ/OazyGTGXyDrLkNr1xJ+K6
   XvDLhsCyTldErITI7OStdgYP9EjSjwy8aKDbA/dIJ87QEZDJwiSQN0isf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10870"; a="450925576"
X-IronPort-AV: E=Sophos;i="6.03,242,1694761200"; 
   d="scan'208";a="450925576"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2023 05:35:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10870"; a="734396966"
X-IronPort-AV: E=Sophos;i="6.03,242,1694761200"; 
   d="scan'208";a="734396966"
Received: from zfeng6-mobl1.ccr.corp.intel.com (HELO [10.93.25.116]) ([10.93.25.116])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2023 05:35:51 -0700
Message-ID: <8c6e8f32-f831-29f1-b749-d0873dad20eb@linux.intel.com>
Date:   Sun, 22 Oct 2023 20:35:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 00/16] LAM and LASS KVM Enabling
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
 <ZTMatKliYT5_I0bg@google.com> <ZTMcg__FPmRVqec9@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZTMcg__FPmRVqec9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/21/2023 8:34 AM, Sean Christopherson wrote:
> On Fri, Oct 20, 2023, Sean Christopherson wrote:
>> On Wed, Sep 13, 2023, Binbin Wu wrote:
>>> Binbin Wu (10):
>>>    KVM: x86: Consolidate flags for __linearize()
>>>    KVM: x86: Use a new flag for branch targets
>>>    KVM: x86: Add an emulation flag for implicit system access
>>>    KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
>>>    KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>>>    KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>>>    KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
>>>    KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in
>>>      emulator
>>>    KVM: x86: Untag address for vmexit handlers when LAM applicable
>>>    KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>>>
>>> Robert Hoo (3):
>>>    KVM: x86: Virtualize LAM for supervisor pointer
>>>    KVM: x86: Virtualize LAM for user pointer
>>>    KVM: x86: Advertise and enable LAM (user and supervisor)
>>>
>>> Zeng Guang (3):
>>>    KVM: emulator: Add emulation of LASS violation checks on linear
>>>      address
>>>    KVM: VMX: Virtualize LASS
>>>    KVM: x86: Advertise LASS CPUID to user space
>> This all looks good!  I have a few minor nits, but nothing I can't tweak when
>> applying.  Assuming nothing explodes in testing, I'll get this applied for 6.8
>> next week.

Thanks very much!

> Gah, by "this" I meant the LAM parts.  LASS is going to have to wait until the
> kernel support lands.

