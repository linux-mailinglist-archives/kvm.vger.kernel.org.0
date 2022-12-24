Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C386559E6
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 12:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiLXLP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 06:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLXLP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 06:15:27 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89BEEE24
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 03:15:25 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p92Us-006Xda-Bt; Sat, 24 Dec 2022 12:15:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=1VBp4nTFbVEhmp+YB6kb3QXe5jkWbW6KjWeeyT++l7U=; b=KHQ6+TQSGMaXPUI/j4CXKV1rwc
        iGxfFvllWdj1+KX/BiICp20TdL6B/8NsJPqz8ApMEZjQosRwZ77V4KwQ3tYZ8vsrWryqOZSDfWqUS
        +da0hGNxn/njJdMaM/l7N/ZdIE4oEu3izSQAS5rEuqmxU6na/yhTTStdQKMpAcybdpuf85QsyAnJP
        EzD3KicgbOW+SfXI2+BCVNAuLDfStw27+mIJ/2q+YqJu/vBhrrQYLbGtgelE8AP70wP7Mvor3oaeG
        iU0rdGT36Y9XRxU5te3EP48HZRCFM6b+b86s36MzmD5D9fiMw+jOsUHzL6cADH4R8YKBwCUJRFMz7
        0sUg1a5Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p92Up-0008Ij-I5; Sat, 24 Dec 2022 12:15:19 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p92UW-000589-VC; Sat, 24 Dec 2022 12:15:01 +0100
Message-ID: <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
Date:   Sat, 24 Dec 2022 12:14:59 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: pl-PL, en-GB
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
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

On 12/24/22 09:52, Paolo Bonzini wrote:
> On 12/22/22 21:30, Michal Luczaj wrote:
>> +	idx = srcu_read_lock(&kvm->srcu);
>> +
>>   	mutex_lock(&kvm->lock);
>>   	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
>>   	mutex_unlock(&kvm->lock);
>>   
> 
> This lock/unlock pair can cause a deadlock because it's inside the SRCU 
> read side critical section.  Fortunately it's simpler to just use 
> mutex_lock for the whole function instead of using two small critical 
> sections, and then SRCU is not needed.

Ah, I didn't think using a single mutex_lock would be ok. And maybe that's
a silly question, but how can this lock/unlock pair cause a deadlock? My
assumption was it's a *sleepable* RCU after all.

> However, the same issue exists in kvm_xen_hcall_evtchn_send where 
> idr_find is not protected by kvm->lock.  In that case, it is important 
> to use rcu_read_lock/unlock() around it, because idr_remove() will *not* 
> use synchronize_srcu() to wait for readers to complete.

Isn't kvm_xen_hcall_evtchn_send() already protected by srcu_read_lock()?

vcpu_enter_guest
  kvm_vcpu_srcu_read_lock		<--
  kvm_x86_handle_exit
    vmx_handle_exit
      __vmx_handle_exit (via kvm_vmx_exit_handlers)
        kvm_emulate_hypercall
          kvm_xen_hypercall
            kvm_xen_hcall_evtchn_send

Thanks,
Michal
