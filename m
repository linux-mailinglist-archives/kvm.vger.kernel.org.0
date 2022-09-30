Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D555F01DE
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 02:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiI3Amq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 20:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiI3Amo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 20:42:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5D52028A0
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 17:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664498564; x=1696034564;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FbPamp3DuDN8VaeGpowUIlPIvBY9RjYb9w4a2lGRpuE=;
  b=hMjHkv1duZxvinWwRg9XFIxGeJ2PxbTBq5CSfYJcpLb4RMji8PmeJRZT
   DipkcJ6PaST1pHpVKSoCXcwxKv3choNhW5dFuWoKm77ZkfmPKYiBBUQ1M
   xl2eNpr66TY8SYsduDMMbuvd5p1wXOgIYpf2ILNjVZey+5IBO1ELCyPK3
   kT9UAD8VSo85zH7NeTuHhzR/RbMtGZI/b81kD/rp5b8IS2meJuFU5wUTI
   Uwk+Xzazu/rd9VE9cBrJIdzSNckVOV3q3ZY0tUMDcPloIdnvly3bW/FXX
   sgUZPjxaFSw52VuaTAz9QvNIRhAJAOlpsF9VaWYd6E7GEx1FXEa0JcepB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281776632"
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="281776632"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 17:42:43 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="691051266"
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="691051266"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.168.175]) ([10.249.168.175])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 17:42:41 -0700
Message-ID: <13f628d5-3ac7-3ddb-d151-d9b22085fde0@intel.com>
Date:   Fri, 30 Sep 2022 08:42:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH v8 0/4] Enable notify VM exit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220929070341.4846-1-chenyi.qiang@intel.com>
 <d20d8f67-2ad9-7b87-71f6-011aab7b6ba5@redhat.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <d20d8f67-2ad9-7b87-71f6-011aab7b6ba5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/2022 1:28 AM, Paolo Bonzini wrote:
> On 9/29/22 09:03, Chenyi Qiang wrote:
>> Notify VM exit is introduced to mitigate the potential DOS attach from
>> malicious VM. This series is the userspace part to enable this feature
>> through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The detailed
>> info can be seen in Patch 4.
>>
>> The corresponding KVM support can be found in linux 6.0-rc:
>> (2f4073e08f4c KVM: VMX: Enable Notify VM exit)
> 
> Thanks, I will queue this in my next pull request.
> 
> Paolo
> 

Thanks Paolo!

Please take the resend version at 
https://lore.kernel.org/qemu-devel/20220929072014.20705-1-chenyi.qiang@intel.com/

There's a minor compile issue in this one.

Chenyi

>> ---
>> Change logs:
>> v7 -> v8
>> - Add triple_fault_pending field transmission on migration (Paolo)
>> - Change the notify-vmexit and notify-window to the accelerator 
>> property. Add it as
>>    a x86-specific property. (Paolo)
>> - Add a preparation patch to expose struct KVMState in order to add 
>> target-specific property.
>> - Define three option for notify-vmexit. Make it on by default. (Paolo)
>> - Raise a KVM internal error instead of triple fault if invalid 
>> context of guest VMCS detected.
>> - v7: 
>> https://lore.kernel.org/qemu-devel/20220923073333.23381-1-chenyi.qiang@intel.com/
>>
>> v6 -> v7
>> - Add a warning message when exiting to userspace (Peter Xu)
>> - v6: 
>> https://lore.kernel.org/all/20220915092839.5518-1-chenyi.qiang@intel.com/
>>
>> v5 -> v6
>> - Add some info related to the valid range of notify_window in patch 
>> 2. (Peter Xu)
>> - Add the doc in qemu-options.hx. (Peter Xu)
>> - v5: 
>> https://lore.kernel.org/qemu-devel/20220817020845.21855-1-chenyi.qiang@intel.com/
>>
>> ---
>>
>> Chenyi Qiang (3):
>>    i386: kvm: extend kvm_{get, put}_vcpu_events to support pending triple
>>      fault
>>    kvm: expose struct KVMState
>>    i386: add notify VM exit support
>>
>> Paolo Bonzini (1):
>>    kvm: allow target-specific accelerator properties
>>
>>   accel/kvm/kvm-all.c      |  78 ++-----------------------
>>   include/sysemu/kvm.h     |   2 +
>>   include/sysemu/kvm_int.h |  75 ++++++++++++++++++++++++
>>   qapi/run-state.json      |  17 ++++++
>>   qemu-options.hx          |  11 ++++
>>   target/arm/kvm.c         |   4 ++
>>   target/i386/cpu.c        |   1 +
>>   target/i386/cpu.h        |   1 +
>>   target/i386/kvm/kvm.c    | 121 +++++++++++++++++++++++++++++++++++++++
>>   target/i386/machine.c    |  20 +++++++
>>   target/mips/kvm.c        |   4 ++
>>   target/ppc/kvm.c         |   4 ++
>>   target/riscv/kvm.c       |   4 ++
>>   target/s390x/kvm/kvm.c   |   4 ++
>>   14 files changed, 272 insertions(+), 74 deletions(-)
>>
> 
