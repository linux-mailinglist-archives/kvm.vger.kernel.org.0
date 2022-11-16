Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3162B146
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 03:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKPC1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 21:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKPC1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 21:27:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAFF27B31;
        Tue, 15 Nov 2022 18:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668565657; x=1700101657;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JkCXtmekIJ3sgsQAhAIWJfyZ4ZqLSy43OZmKF1Syvak=;
  b=kn3++aoDA5g8FiDk7B+GXe86CinwDy1+ZF832rEVoDTjtdu2zbosumQi
   mUA6HY9RjFQfv4aSnFR8u+0NlgiEhtSlDM4tJZPHWJT6TgbdPfRCXmv4g
   CYoufzaUoZBv0DRmjxgVq/YJRpKHtRzcY1XHYV1GeAyf4HEmGYfafWvlZ
   dp5kUdX45KQZBe7iy4tT5Jy4DaOunaldBqDT5TeiPzhUHs0/+AymWbXc4
   9TAPXkL1sTOfqfRTi0Ie43/AVhD/U+RD/pCRTZEpVrB7MG9QADG6HV9a3
   FloDiedWmaAIYdm5hVeDftAVX2qpEyt6cP9Xz0CecLtMNTtEsH3Cce9QP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="314240422"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="314240422"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 18:27:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="616987547"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="616987547"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.3.45]) ([10.238.3.45])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 18:27:21 -0800
Message-ID: <286ff53b-e81c-0409-f344-81e2d2d7d8e2@linux.intel.com>
Date:   Wed, 16 Nov 2022 10:27:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 1/7] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
 <20221110015252.202566-2-jiaxi.chen@linux.intel.com>
 <f8607d23-afaa-2670-dd03-2ae8ec1e79a0@intel.com>
 <Y3OwaRBzVFqJ4KEs@google.com> <Y3O7UYWfOLfJkwM/@zn.tnic>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y3O7UYWfOLfJkwM/@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/16/2022 12:16 AM, Borislav Petkov wrote:
> On Tue, Nov 15, 2022 at 03:29:45PM +0000, Sean Christopherson wrote:
>> Heh, are any of the bits you believe Intel will add publicly documented?  :-)
>>
>> LAM could be scattered, but if more bits are expected that's probably a waste of
>> time and effort.
> 
> I'm being told the bigger part of that word is going to be used for
> either kernel or KVM bits so we might as well use it the "normal" way
> instead of doing KVM-only or scattered bits after all.
> 
> Thx.
> 
Intel published ISE spec
[https://cdrdv2.intel.com/v1/dl/getContent/671368] has documented 11
instructions for this leaf CPUID.7.1.EAX by now. Given that more bits
are going to be defined, I will enable these bits in the patch series as
v1 did and will not move them to kvm-only leaves.

By the way, Boris, what about CPUID.7.1.EDX, whether bigger part of it
is expected to be used? In intel ISE, 3 bits are defined for this word.
For now, I think put them in kvm-only subleaves as this patch series did
is a better choice. What's your opinion?

-- 
Regards,
Jiaxi
