Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEB24F79FE
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiDGIoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243200AbiDGIoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:44:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035625DE76;
        Thu,  7 Apr 2022 01:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649320931; x=1680856931;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=yy+cT/a1EMFV/vsEI4YTD6dp4j+4Ch2HlkBQzyfLhT4=;
  b=Gj28QSS3gxZx1AU7aoJ6GOLhq5kuehve13weHUKlmXxihvG4XpeE6Q2/
   +hXB+Pzw5AJSbW84JCVJypOam65HHlUyjWoJqRfBVxfWy5ua4QwPKdl4i
   nG29IayLzE06pS3eSbZQV0c2WZueUyFBxKTwuVpjQRxzWMuN5ToD1yGpp
   w9bJ9xkgUSmTb+UhIzwd6//jZW3fTFToOXM5gVp/bgyb3jFXNDIH9pKFn
   bn2wo30CzGu7GsmhE1kyenz6oTj2BYqMVBer8WK1/nSqKY8Keea5kbtro
   BbUadHWOv4TghYMcnq3/zeKbwg0hckKuS+y4Dp1nufeNWrAxUhJOqztyN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261443694"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="261443694"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 01:42:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722872202"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 01:42:09 -0700
Message-ID: <55f6f971-94ef-00d8-6f99-c040b103d56f@intel.com>
Date:   Thu, 7 Apr 2022 16:42:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 3/3] KVM: nVMX: Clear IDT vectoring on nested VM-Exit for
 double/triple fault
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20220407002315.78092-1-seanjc@google.com>
 <20220407002315.78092-4-seanjc@google.com>
 <a23077a5-777f-85fb-05fa-b91e21aca0e7@intel.com>
In-Reply-To: <a23077a5-777f-85fb-05fa-b91e21aca0e7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/2022 4:02 PM, Xiaoyao Li wrote:
> On 4/7/2022 8:23 AM, Sean Christopherson wrote:
>> Clear the IDT vectoring field in vmcs12 on next VM-Exit due to a double
>> or triple fault.  Per the SDM, a VM-Exit isn't considered to occur during
>> event delivery if the exit is due to an intercepted double fault or a
>> triple fault.  Opportunistically move the default clearing (no event
>> "pending") into the helper so that it's more obvious that KVM does indeed
>> handle this case.
>>
>> Note, the double fault case is worded rather wierdly in the SDM:
>>
>>    The original event results in a double-fault exception that causes the
>>    VM exit directly.
>>
>> Temporarily ignoring injected events, double faults can _only_ occur if
>> an exception occurs while attempting to deliver a different exception,
>> i.e. there's _always_ an original event.  And for injected double fault,
>> while there's no original event, injected events are never subject to
>> interception.
>>
>> Presumably the SDM is calling out that a the vectoring info will be valid
>> if a different exit occurs after a double fault, e.g. if a #PF occurs and
>> is intercepted while vectoring #DF, then the vectoring info will show the
>> double fault. 
> 
> Wouldn't it be a tripe fault exit in this case?

It won't since #PF is intercepted by exception bitmap in your case.

>> In other words, the clause can simply be read as:
>>
>>    The VM exit is caused by a double-fault exception.
> 

