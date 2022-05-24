Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8665532BD7
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbiEXOAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238040AbiEXOAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 10:00:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4D8CB0D;
        Tue, 24 May 2022 07:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400816; x=1684936816;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=MkJZXh2oHiKwZRigERlBUJgFTlbtP/47oAjMtv+wZNs=;
  b=QXSmeLJPi+H2wtVZf8+OFTg8oXlK7fZoqTipo2VdAN8zQioiKGs5PAJb
   Gdm6GBbLACPCLZ2f7gd12C9LmLzKHlGFC9BiLQfLV0McDC+BTp2vPOGpu
   QOBp6XAM+nW2k28bkpkduk+XYfgb7Da5NZsnjYcFcFvVqtzK0ljkBto5P
   t+QeOk9i4OwGDy3+PWu1P3w1xmJ3Sx7Vy0Y8j/zCK92E7HH5f/3Ek660o
   O3wjpwMTrRg+wmS36hacZOG+vX4nFtgLmCaGK1uNOejyEL70EClXYksUA
   T/S8zxHGhdf6Hdn0z6pN1uVIZK1k5CF9ZatTMY+5DP0qO/dLZ3J0yACEI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="255599057"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="255599057"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 07:00:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="572668797"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.171.56]) ([10.249.171.56])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 07:00:13 -0700
Message-ID: <df99922f-0a6b-98d9-d862-958447f45048@intel.com>
Date:   Tue, 24 May 2022 22:00:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v6 0/3] Introduce Notify VM exit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
 <7c4ebffe-7b61-9ca8-26b6-1fbaaac5243e@redhat.com>
Content-Language: en-US
In-Reply-To: <7c4ebffe-7b61-9ca8-26b6-1fbaaac5243e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/2022 3:30 AM, Paolo Bonzini wrote:
> On 4/21/22 09:29, Chenyi Qiang wrote:
>> Virtual machines can exploit Intel ISA characterstics to cause
>> functional denial of service to the VMM. This series introduces a new
>> feature named Notify VM exit, which can help mitigate such kind of
>> attacks.
>>
>> Patch 1: An extension of KVM_SET_VCPU_EVENTS ioctl to inject a
>> synthesized shutdown event from user space. This is also a fix for other
>> synthesized triple fault, e.g. the RSM patch or nested_vmx_abort(),
>> which could get lost when exit to userspace to do migrate.
>>
>> Patch 2: A selftest about get/set triple fault event.
>>
>> Patch 3: The main patch to enable Notify VM exit.
> 
> Chenyi, can you send v7 for inclusion?
> 
> Paolo
> 

Hi Paolo

v7 is sent out at
https://lore.kernel.org/lkml/20220524135624.22988-1-chenyi.qiang@intel.com/

>> ---
>> Change logs:
>> v5 -> v6
>> - Do some changes in document.
>> - Add a selftest about get/set triple fault event. (Sean)
>> - extend the argument to include both the notify window and some flags
>>    when enabling KVM_CAP_X86_BUS_LOCK_EXIT CAP. (Sean)
>> - Change to use KVM_VCPUEVENT_VALID_TRIPE_FAULT in flags field and add
>>    pending_triple_fault field in struct kvm_vcpu_events, which allows
>>    userspace to make/clear triple fault request. (Sean)
>> - Add a flag in kvm_x86_ops to avoid the kvm_has_notify_vmexit global
>>    varialbe and its export.(Sean)
>> - v5: 
>> https://lore.kernel.org/lkml/20220318074955.22428-1-chenyi.qiang@intel.com/ 
>>
>>
>> v4 -> v5
>> - rename KVM_VCPUEVENTS_SHUTDOWN to KVM_VCPUEVENTS_TRIPLE_FAULT. Make it
>>    bidirection and add it to get_vcpu_events. (Sean)
>> - v4: 
>> https://lore.kernel.org/all/20220310084001.10235-1-chenyi.qiang@intel.com/ 
>>
>>
>> v3 -> v4
>> - Change this feature to per-VM scope. (Jim)
>> - Once VM_CONTEXT_INVALID set in exit_qualification, exit to user space
>>    notify this fatal case, especially the notify VM exit happens in L2.
>>    (Jim)
>> - extend KVM_SET_VCPU_EVENTS to allow user space to inject a shutdown
>>    event. (Jim)
>> - A minor code changes.
>> - Add document for the new KVM capability.
>> - v3: 
>> https://lore.kernel.org/lkml/20220223062412.22334-1-chenyi.qiang@intel.com/ 
>>
>>
>> v2 -> v3
>> - add a vcpu state notify_window_exits to record the number of
>>    occurence as well as a pr_warn output. (Sean)
>> - Add the handling in nested VM to prevent L1 bypassing the restriction
>>    through launching a L2. (Sean)
>> - Only kill L2 when L2 VM is context invalid, synthesize a
>>    EXIT_REASON_TRIPLE_FAULT to L1 (Sean)
>> - To ease the current implementation, make module parameter
>>    notify_window read-only. (Sean)
>> - Disable notify window exit by default.
>> - v2: 
>> https://lore.kernel.org/lkml/20210525051204.1480610-1-tao3.xu@intel.com/
>>
>> v1 -> v2
>> - Default set notify window to 0, less than 0 to disable.
>> - Add more description in commit message.
>> ---
>>
>> Chenyi Qiang (2):
>>    KVM: X86: Save&restore the triple fault request
>>    KVM: selftests: Add a test to get/set triple fault event
>>
>> Tao Xu (1):
>>    KVM: VMX: Enable Notify VM exit
>>
>>   Documentation/virt/kvm/api.rst                | 55 +++++++++++
>>   arch/x86/include/asm/kvm_host.h               |  9 ++
>>   arch/x86/include/asm/vmx.h                    |  7 ++
>>   arch/x86/include/asm/vmxfeatures.h            |  1 +
>>   arch/x86/include/uapi/asm/kvm.h               |  4 +-
>>   arch/x86/include/uapi/asm/vmx.h               |  4 +-
>>   arch/x86/kvm/vmx/capabilities.h               |  6 ++
>>   arch/x86/kvm/vmx/nested.c                     |  8 ++
>>   arch/x86/kvm/vmx/vmx.c                        | 48 +++++++++-
>>   arch/x86/kvm/x86.c                            | 33 ++++++-
>>   arch/x86/kvm/x86.h                            |  5 +
>>   include/uapi/linux/kvm.h                      | 10 ++
>>   tools/testing/selftests/kvm/.gitignore        |  1 +
>>   tools/testing/selftests/kvm/Makefile          |  1 +
>>   .../kvm/x86_64/triple_fault_event_test.c      | 96 +++++++++++++++++++
>>   15 files changed, 280 insertions(+), 8 deletions(-)
>>   create mode 100644 
>> tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
>>
> 
