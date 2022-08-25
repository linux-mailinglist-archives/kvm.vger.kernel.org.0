Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D21B5A1800
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiHYRcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHYRck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:32:40 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E056B24A5
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:32:38 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oRGiZ-001cCv-2s; Thu, 25 Aug 2022 19:32:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=a4kLirzIny9Wq0234p3txa4W7yAPW/hAXuCD4k9TNio=; b=ERwHIs4l9e0usMiqehITCQOUBZ
        /1lzsN5zPMvbQwfXUrM8mWA/RFshm09Uj3drEGaw9w5X+TxeFJ2D+6n+lmnTRcw6FHayKbyNz6rSN
        Viv8qL85kiAxPhCQz5VWdYiqWli+pm4bOlxxieYPM9zT88xHeJZNfocWN/m+r6YyhAE6j7gPr3f86
        Brj7YzsvZWAE1u7dV7dG/ijrYNtjx3eSLWoleDNpb23zB7odORpUfx3ndav/9to6X0fF+9Fq1sbRK
        m671i6LatydLg6+sFh4qunnL/FDMIlouCkqvIDtqB3X79UICi5lvTNHnyf4xLrbonlUOn2bcBEZyf
        R3ZG8aNw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oRGiY-00028S-B3; Thu, 25 Aug 2022 19:32:34 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oRGiR-0001b0-BF; Thu, 25 Aug 2022 19:32:27 +0200
Message-ID: <635a6f6b-a3b0-401f-dfd4-3a8c27f65774@rbox.co>
Date:   Thu, 25 Aug 2022 19:32:26 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Content-Language: pl-PL
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co> <YwOj6tzvIoG34/sF@google.com>
 <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co> <YwZu1K5Rgb1sevsy@google.com>
 <69d74e6a-dd6b-28bb-8011-e204d4ab0253@rbox.co> <YwereSW3UPhDNsnh@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <YwereSW3UPhDNsnh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/22 19:03, Sean Christopherson wrote:
> On Wed, Aug 24, 2022, Michal Luczaj wrote:
>> 								\
>> 	n = 0;							\
>> 	asm volatile(/* jump to 32-bit code segment */		\
>> 		     "ljmp *1f\n\t"				\
>> 		     "1:\n\t"					\
>> 		     "	.long 2f\n\t"				\
>> 		     "	.word " xstr(KERNEL_CS32) "\n\t"	\
>> 		     /* exercise POP SS blocking */		\
>> 		     ".code32\n\t"				\
>> 		     "2: lea 3f, %0\n\t"			\
>> 		     "mov %0, %%dr0\n\t"			\
>> 		     "push %%ss\n\t"				\
>> 		     fep1 "pop %%ss\n\t"			\
>> 		     fep2 "3: xor %0, %0\n\t"			\
>> 		     /* back to long mode */			\
>> 		     "ljmp %[cs64], $4f\n\t"			\
>> 		     ".code64\n\t"				\
> 
> Ooh, I see what you meant by temporarily switching to 32-bit mode.  I was thinking
> we could just make the POP SS testcase 32-bit only, but I didn't realize this test
> is 64-bit only.  Argh, and so is emulate.c.  And now I get why you added a brand
> new test.
>
> Let's just add a new test.  The above can work, but it relies on the code and
> stack being mapped with a 32-bit address, e.g. will break if KUT is ever changed
> to not map everything low in the virtual address space.

Yeah, it is fragile in that sense. But does it mean code such as
vmx_tests.c:into_guest_main() or svm_tests.c:svm_of_test_guest() should be moved
to 32-bit binaries?

Michal
