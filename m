Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE95B64F7
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 03:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIMBOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 21:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIMBOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 21:14:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0419F51421
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 18:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663031640; x=1694567640;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jwYI7Y+ErustrW+xyMACGSP6kr582mwHq0bLbgyd9ec=;
  b=OCNxy3rrICGYWROYFdlgk5OXB9hiN3DBCAPjiP3LGHGUP166i0VneFLQ
   GbmjqhRx/0zQ7lAgtgC0eRPb5V6dsYQWD2cQhRGyQD/Fc4Ep8EZb7b0YG
   yOBinnFhoVpO7oTByfXjPnslj88srzY+qNdtNzuF3tFMNVcK9FybbdsAt
   hLBfUpIq8znh5A5t062iHqtpVirgJOmCbzp2DqXMCFcgFLIT1h5rV3mjD
   +PP2pi3cvjVnI7QOLkcsOoORw9U4lQk2GySKV9AHyXbs1C96x5o+4k7u7
   XK7nQ6pX9LW3CHhfC0MdW5fEiVrtzStXn/wZoXLPxKKph7aW4VOO2vBZq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="296743154"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="296743154"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 18:14:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="944852505"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.135]) ([10.238.0.135])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 18:13:58 -0700
Message-ID: <db7834a7-5006-4345-3c66-2277c68d29e3@intel.com>
Date:   Tue, 13 Sep 2022 09:13:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH v5 3/3] i386: Add notify VM exit support
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
 <20220817020845.21855-4-chenyi.qiang@intel.com>
 <YxtpBMZmrDK3cghT@xz-m1.local>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YxtpBMZmrDK3cghT@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/10/2022 12:25 AM, Peter Xu wrote:
> On Wed, Aug 17, 2022 at 10:08:45AM +0800, Chenyi Qiang wrote:
>> There are cases that malicious virtual machine can cause CPU stuck (due
>> to event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
>> IRQ) can be delivered. It leads the CPU to be unavailable to host or
>> other VMs. Notify VM exit is introduced to mitigate such kind of
>> attacks, which will generate a VM exit if no event window occurs in VM
>> non-root mode for a specified amount of time (notify window).
>>
>> A new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT is exposed to user space
>> so that the user can query the capability and set the expected notify
>> window when creating VMs. The format of the argument when enabling this
>> capability is as follows:
>>    Bit 63:32 - notify window specified in qemu command
>>    Bit 31:0  - some flags (e.g. KVM_X86_NOTIFY_VMEXIT_ENABLED is set to
>>                enable the feature.)
>>
>> Because there are some concerns, e.g. a notify VM exit may happen with
>> VM_CONTEXT_INVALID set in exit qualification (no cases are anticipated
>> that would set this bit), which means VM context is corrupted. To avoid
>> the false positive and a well-behaved guest gets killed, make this
>> feature disabled by default. Users can enable the feature by a new
>> machine property:
>>      qemu -machine notify_vmexit=on,notify_window=0 ...
> 
> The patch looks sane to me; I only read the KVM interface, though.  Worth
> add a section to qemu-options.hx?  It'll also be worthwhile to mention the
> valid range of notify_window and meaning of zero (IIUC that's also a valid
> input, just use the hardware default window size).
> 

Thanks Peter for your review.

I'll add some doc in qemu-option.hx and also the commit message about 
the valid range in next version.

> Thanks,
> 
>>
>> A new KVM exit reason KVM_EXIT_NOTIFY is defined for notify VM exit. If
>> it happens with VM_INVALID_CONTEXT, hypervisor exits to user space to
>> inform the fatal case. Then user space can inject a SHUTDOWN event to
>> the target vcpu. This is implemented by injecting a sythesized triple
>> fault event.
> 
