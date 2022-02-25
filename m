Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92DF4C4862
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbiBYPNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiBYPNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:13:52 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4266FB8B71;
        Fri, 25 Feb 2022 07:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645801998; x=1677337998;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=vZg6tbM7+9XOW7hnxWAfKkhfxkNsoS8BNELj0PMEy1Q=;
  b=hhX7Zx0aFTzVzGSuqDOKj/qHqBRlmFN8MNZ9pZ/uI8sqZJIXw92khLqS
   X5R7wx1K8YBKGySUFHMDR5pXf4mMH8EyWzeNxCcYN5H6t9qu2zkfU2JsQ
   kO5Uf/lkbX75Gr6qqlJRwSN4vJb+u5eUEtX/jJUjqMcw+p82LP7SpG3R4
   wy9DLLTK9xErJrZXhWJdlBTuSVe330VKy9ytEap6gI/SmJSnK2Y0Njqjr
   eTHB2UulMzpip1UlDm9eGTPy+rFGEFz8U/k+vfIxfrTmOUUntpB1/M890
   roL3Wxd/CR1MCQ8l87yU5ik9HTPJD3cZ8EzqCVbb4NR55xXBYEbz8ddl+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252241388"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252241388"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 07:12:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="533601428"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.203]) ([10.255.30.203])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 07:12:15 -0800
Message-ID: <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
Date:   Fri, 25 Feb 2022 23:12:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
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
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com>
In-Reply-To: <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2022 11:04 PM, Xiaoyao Li wrote:
> On 2/25/2022 10:54 PM, Jim Mattson wrote:
>> On Tue, Feb 22, 2022 at 10:19 PM Chenyi Qiang <chenyi.qiang@intel.com> 
>> wrote:
>>> Nested handling
>>> - Nested notify VM exits are not supported yet. Keep the same notify
>>>    window control in vmcs02 as vmcs01, so that L1 can't escape the
>>>    restriction of notify VM exits through launching L2 VM.
>>> - When L2 VM is context invalid, synthesize a nested
>>>    EXIT_REASON_TRIPLE_FAULT to L1 so that L1 won't be killed due to L2's
>>>    VM_CONTEXT_INVALID happens.
>>
>> I don't like the idea of making things up without notifying userspace
>> that this is fictional. How is my customer running nested VMs supposed
>> to know that L2 didn't actually shutdown, but L0 killed it because the
>> notify window was exceeded? If this information isn't reported to
>> userspace, I have no way of getting the information to the customer.
> 
> Then, maybe a dedicated software define VM exit for it instead of 
> reusing triple fault?
> 

Second thought, we can even just return Notify VM exit to L1 to tell L2 
causes Notify VM exit, even thought Notify VM exit is not exposed to L1.

