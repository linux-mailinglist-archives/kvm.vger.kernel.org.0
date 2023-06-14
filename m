Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB1772FFD7
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 15:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbjFNNUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 09:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbjFNNUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 09:20:33 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B211118;
        Wed, 14 Jun 2023 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686748832; x=1718284832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TTY+FiTaX7AgDqQBUwj/BsShWUwI+/hjWm+TAF5VYBA=;
  b=YN27Qk+3Rt9C38O7udVLhG76gTVD3bg8KbsPpPAtLVM27KoJd1LzIiop
   GA9ugURrJt4c8Hr1FVrhQga9K51irEEdyyIdB7rWt+zw/3AI5EbdV+jNs
   x793/lN3lpRuoImm7HX7zOYhoub4AH9s+Lm1M4RXotHRaeNdTGj/qFO+o
   s=;
X-IronPort-AV: E=Sophos;i="6.00,242,1681171200"; 
   d="scan'208";a="220608635"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 13:20:30 +0000
Received: from EX19MTAUEC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id A6337A3E0A;
        Wed, 14 Jun 2023 13:20:29 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 13:20:29 +0000
Received: from [10.95.176.26] (10.95.176.26) by EX19D028UEC003.ant.amazon.com
 (10.252.137.159) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 14 Jun
 2023 13:20:27 +0000
Message-ID: <abf509a2-ebfd-7b5f-4f7a-fdd4ef60c1de@amazon.com>
Date:   Wed, 14 Jun 2023 09:20:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
References: <20230602005859.784190-1-seanjc@google.com>
 <168667299355.1927151.1998349801097712999.b4-ty@google.com>
From:   Luiz Capitulino <luizcap@amazon.com>
In-Reply-To: <168667299355.1927151.1998349801097712999.b4-ty@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.95.176.26]
X-ClientProxiedBy: EX19D035UWB001.ant.amazon.com (10.13.138.33) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-06-13 19:21, Sean Christopherson wrote:

> 
> 
> 
> On Thu, 01 Jun 2023 17:58:59 -0700, Sean Christopherson wrote:
>> Add a "never" option to the nx_huge_pages module param to allow userspace
>> to do a one-way hard disabling of the mitigation, and don't create the
>> per-VM recovery threads when the mitigation is hard disabled.  Letting
>> userspace pinky swear that userspace doesn't want to enable NX mitigation
>> (without reloading KVM) allows certain use cases to avoid the latency
>> problems associated with spawning a kthread for each VM.
>>
>> [...]
> 
> Applied to kvm-x86 mmu.  I kept the default as "auto" for now, as that can go on
> top and I don't want to introduce that change this late in the cycle.  If no one
> beats me to the punch (hint, hint ;-) ), I'll post a patch to make "never" the
> default for unaffected hosts so that we can discuss/consider that change for 6.6.

Thanks Sean, I agree with the plan. I could give a try on the patch if you'd like.

- Luiz

> 
> Thanks for the reviews!
> 
> [1/1] KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages
>        https://github.com/kvm-x86/linux/commit/0b210faf3373
> 
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes
