Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E618D46FE35
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhLJJ5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:57:52 -0500
Received: from mga18.intel.com ([134.134.136.126]:18482 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239633AbhLJJ5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639130056; x=1670666056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i5mi2ux2NWMV234M1FllWOI2g2yLlRa0QdVRhusT3Og=;
  b=jXjSg1o11jQstUvNfIEOFiN4k7aZin+xk+NMw6sHx3leMoAZmHspfCVK
   NsaOYWrxZjV/++yqLvMH0DtzYMc+T12IOtjK7lqA7AVUOsnMlONqW/cxE
   8W5WWgR+V3FMhqOqruWtdxUGBL2FoKpRwc79Xvgk1s5oXRMfQzar1xiEf
   xGvKc9XS9fTQEGPtpQQQtqMW0dCKRBEpRCpznhV0Dc7lgBhwM8lNEa2oL
   SuhO2Pm30BYLbi/6eh0bUpJJadsYbQ376z8wxaqUn8pWL34uQpN7K59TG
   7KbxGo7ewEZYQ9Ur8BtTb5NEdxQe71bjhi610Ml5TrlwicfHQYygOfABe
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="225185189"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="225185189"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 01:54:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="503868624"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.171.165]) ([10.249.171.165])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 01:54:13 -0800
Message-ID: <6031a4ed-1544-c563-9f05-cfcf2ae351b6@intel.com>
Date:   Fri, 10 Dec 2021 17:54:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v2 34/44] target/i386/tdx: set reboot action to
 shutdown when tdx
Content-Language: en-US
To:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <d1afced8a92c01367d0aed7c6f82659c9bf79956.1625704981.git.isaku.yamahata@intel.com>
 <0ccf5a5c-2322-eae3-bd4b-9e72e2f4bbd1@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <0ccf5a5c-2322-eae3-bd4b-9e72e2f4bbd1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/2021 1:54 AM, Connor Kuehl wrote:
> On 7/7/21 7:55 PM, isaku.yamahata@gmail.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> In TDX CPU state is also protected, thus vcpu state can't be reset by 
>> VMM.
>> It assumes -action reboot=shutdown instead of silently ignoring vcpu 
>> reset.
>>
>> TDX module spec version 344425-002US doesn't support vcpu reset by 
>> VMM.  VM
>> needs to be destroyed and created again to emulate REBOOT_ACTION_RESET.
>> For simplicity, put its responsibility to management system like libvirt
>> because it's difficult for the current qemu implementation to destroy and
>> re-create KVM VM resources with keeping other resources.
>>
>> If management system wants reboot behavior for its users, it needs to
>>   - set reboot_action to REBOOT_ACTION_SHUTDOWN,
>>   - set shutdown_action to SHUTDOWN_ACTION_PAUSE optionally and,
>>   - subscribe VM state change and on reboot, (destroy qemu if
>>     SHUTDOWN_ACTION_PAUSE and) start new qemu.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 1316d95209..0621317b0a 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -25,6 +25,7 @@
>>   #include "qapi/qapi-types-misc-target.h"
>>   #include "standard-headers/asm-x86/kvm_para.h"
>>   #include "sysemu/sysemu.h"
>> +#include "sysemu/runstate-action.h"
>>   #include "sysemu/kvm.h"
>>   #include "sysemu/kvm_int.h"
>>   #include "sysemu/tdx.h"
>> @@ -363,6 +364,19 @@ static void tdx_guest_init(Object *obj)
>>       qemu_mutex_init(&tdx->lock);
>> +    /*
>> +     * TDX module spec version 344425-002US doesn't support reset of 
>> vcpu by
>> +     * VMM.  VM needs to be destroyed and created again to emulate
>> +     * REBOOT_ACTION_RESET.  For simplicity, put its responsibility to
>> +     * management system like libvirt.
>> +     *
>> +     * Management system should
>> +     *  - set reboot_action to REBOOT_ACTION_SHUTDOWN
>> +     *  - set shutdown_action to SHUTDOWN_ACTION_PAUSE
>> +     *  - subscribe VM state and on reboot, destroy qemu and start 
>> new qemu
>> +     */
>> +    reboot_action = REBOOT_ACTION_SHUTDOWN;
>> +
>>       tdx->debug = false;
>>       object_property_add_bool(obj, "debug", tdx_guest_get_debug,
>>                                tdx_guest_set_debug);
>>
> 
> I think the same effect could be accomplished with modifying
> kvm_arch_cpu_check_are_resettable.
> 

Yes. Thanks for pointing it out. We will take this approach.
