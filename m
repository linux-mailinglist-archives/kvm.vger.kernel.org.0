Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783F64C4847
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbiBYPFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbiBYPFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:05:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031101B4013;
        Fri, 25 Feb 2022 07:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645801503; x=1677337503;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mWqSkEzHA9hqSD7dCkiJ5u6r0L9ODek7DkDlPbYQDHg=;
  b=bSo85AkzD2mLTpqGYeyG3M9fh3U9SQOsLq2vywCOyBo3btuAOtCAVeic
   edgCE5ixO5wXsI0DmO9QmPXXwiEg5jDlawyqdggyCcPooaomR7cOewL1N
   D6b0DXKVboNABat62pYRScgikeR5wZvgpolWy8wbvHzTK8n5DIuxN0Jz/
   8Vqx/okDuGSMtbHJ7mg6OVaQzgo6982mPITo3W3d9O7N5/+e/rjtB/wos
   WqyYu9oVj5Xaz4xR2sQpRp0rWMRSpe0LsuDOtz80I6G1FSMvWM92cz6Z8
   sN80LSu7IuIyH/Gq8f2AqlmIiYryJEoWv+5FZPrXuuH625rOh0e5owXSe
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="277144993"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="277144993"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 07:04:50 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="628862166"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.203]) ([10.255.30.203])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 07:04:48 -0800
Message-ID: <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com>
Date:   Fri, 25 Feb 2022 23:04:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2022 10:54 PM, Jim Mattson wrote:
> On Tue, Feb 22, 2022 at 10:19 PM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>> From: Tao Xu <tao3.xu@intel.com>
>>
>> There are cases that malicious virtual machines can cause CPU stuck (due
>> to event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
>> IRQ) can be delivered. It leads the CPU to be unavailable to host or
>> other VMs.
>>
>> VMM can enable notify VM exit that a VM exit generated if no event
>> window occurs in VM non-root mode for a specified amount of time (notify
>> window).
>>
>> Feature enabling:
>> - The new vmcs field SECONDARY_EXEC_NOTIFY_VM_EXITING is introduced to
>>    enable this feature. VMM can set NOTIFY_WINDOW vmcs field to adjust
>>    the expected notify window.
>> - Expose a module param to configure notify window by admin, which is in
>>    unit of crystal clock.
>>    - if notify_window < 0, feature disabled;
>>    - if notify_window >= 0, feature enabled;
>> - There's a possibility, however small, that a notify VM exit happens
>>    with VM_CONTEXT_INVALID set in exit qualification. In this case, the
>>    vcpu can no longer run. To avoid killing a well-behaved guest, set
>>    notify window as -1 to disable this feature by default.
>> - It's safe to even set notify window to zero since an internal
>>    hardware threshold is added to vmcs.notifiy_window.
> 
> What causes a VM_CONTEXT_INVALID VM-exit? How small is this possibility?

For now, no case will set VM_CONTEXT_INVALID bit.

In the future, it must be some fatal case that vmcs is corrupted.

>> Nested handling
>> - Nested notify VM exits are not supported yet. Keep the same notify
>>    window control in vmcs02 as vmcs01, so that L1 can't escape the
>>    restriction of notify VM exits through launching L2 VM.
>> - When L2 VM is context invalid, synthesize a nested
>>    EXIT_REASON_TRIPLE_FAULT to L1 so that L1 won't be killed due to L2's
>>    VM_CONTEXT_INVALID happens.
> 
> I don't like the idea of making things up without notifying userspace
> that this is fictional. How is my customer running nested VMs supposed
> to know that L2 didn't actually shutdown, but L0 killed it because the
> notify window was exceeded? If this information isn't reported to
> userspace, I have no way of getting the information to the customer.

Then, maybe a dedicated software define VM exit for it instead of 
reusing triple fault?

