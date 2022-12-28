Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03A657165
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 01:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiL1AVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 19:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL1AVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 19:21:22 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D1FCE34
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 16:21:18 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pAKC2-00EuQW-Mk; Wed, 28 Dec 2022 01:21:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=u+SXGGAMjZrou0lH27ETbaoXiSkwMP3eNynZwxgvLTc=; b=hdB+vaa9pV7tGriN1iB8uAiGLp
        FhwOSP6JWYY5TC2HORlctAWS729p2nLzO5o2NMqdFAO3CPU0LQi+mCkxb9IQRSIYG1QKoCk+cAIZG
        m3tR4z8kvkJQiV7R0IpolRNJ0r0DgbxFI0Z64xgBInlOr3PKnAq8ZhAH3YSTBdn/OpieFTAnifiA9
        iVQ9CYoVL9MliZkdzJLXdTiugLM1u4djIb8lfGNSiEStqfk0VpVmgSus58F9m4R2HZRjp3bqpvTjt
        dyptRrDkT+p2GmNUf3rOzg7v/nGl3RT6mdNX4wkaNTl/bkO9VW1u6LgZ9FT/0Wd30GSbCBCGavKdp
        1go9t1Fw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pAKC1-0004CS-MZ; Wed, 28 Dec 2022 01:21:13 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pAKBz-0000IQ-LO; Wed, 28 Dec 2022 01:21:11 +0100
Message-ID: <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
Date:   Wed, 28 Dec 2022 01:21:10 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: pl-PL
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
 <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/27/22 12:11, Paolo Bonzini wrote:
> On 12/24/22 12:14, Michal Luczaj wrote:
>>> This lock/unlock pair can cause a deadlock because it's inside the SRCU
>>> read side critical section.  Fortunately it's simpler to just use
>>> mutex_lock for the whole function instead of using two small critical
>>> sections, and then SRCU is not needed.
>> Ah, I didn't think using a single mutex_lock would be ok. And maybe that's
>> a silly question, but how can this lock/unlock pair cause a deadlock? My
>> assumption was it's a*sleepable*  RCU after all.
>>
> 
> This is a pretty simple AB-BA deadlock, just involving SRCU and a mutex 
> instead of two mutexes:
> 
> Thread 1			Thread 2
> 				mutex_lock()
> srcu_read_lock()
> mutex_lock()  // stops here
> 				synchronize_srcu()  // stops here
> 				mutex_unlock()
> mutex_unlock()
> srcu_read_unlock()
> 
> Thread 2's synchronize_srcu() is waiting for srcu_read_unlock(), which 
> however won't happen until thread 1 can take the mutex.  But the mutex 
> is taken by thread 2, hence the deadlock.

Ahh, I see. Thank you for explaining.

Does it mean kvm_xen_hcall_evtchn_send() deadlocks in the same fashion?

				kvm_xen_eventfd_reset()
				  mutex_lock()
srcu_read_lock()
kvm_xen_hcall_evtchn_send()
  kvm_xen_set_evtchn()
    mutex_lock()
    				  synchronize_srcu()

Michal
