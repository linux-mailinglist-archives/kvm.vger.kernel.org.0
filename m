Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F98B429637
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 19:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhJKSA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 14:00:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234132AbhJKSA6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 14:00:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633975138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRSX21YYQNR0zf93QnpnZwtrx/fhYTinOsr/f3yNls4=;
        b=brDWlW6FfDiZoFh01jvOOIruwdRMsGWTTvm5uK2CH8wl3SgRgBeO2wvdEcXHv7gJ/0h/r2
        LHYWgNlvsVtBQQ2m3swah8yZOFY1+imw/1lDAjq/zBgxi2D4TztBFWU3b9S8A5TzVqqUNd
        Z1s2JM4w8iG8cCRFB15uY1aNtvvr+oE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-vvFJUE8SMyOFtk0zdf9r6Q-1; Mon, 11 Oct 2021 13:58:57 -0400
X-MC-Unique: vvFJUE8SMyOFtk0zdf9r6Q-1
Received: by mail-wr1-f71.google.com with SMTP id a15-20020a056000188f00b00161068d8461so3519240wri.11
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 10:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rRSX21YYQNR0zf93QnpnZwtrx/fhYTinOsr/f3yNls4=;
        b=4OATJpQjDgZmJIqKJiuLruqyEI47OfTmAoSs0VQPxOWSRMljcxxn94WKDWA0lX/bO3
         FSyiBlQkdrJEXiC/++UhN+QqeN7UfeT+RMMXL6qeRr3C4qou3f6JhqM2I41x1c0nNfke
         iFuA9GbO0r1DR9EPjM8QrP/39ftg6ncsHaaUQLijaq3fFXYIocm3EDullw3kG8mObAJA
         5f/Ko/0gi6DwQ0vDDChMD240odUoihbAeu5H3i1hFG9o/rq/MUVwZ3H93M9csUXonOJg
         mwXKZgIG9QmPVD7RWC7U7xCxLfh/8qmVcfnu988wv7r9M/FDXLaigSAGHQp+NLat5zFg
         vs3w==
X-Gm-Message-State: AOAM533Gy5aXmuXEeOIMSpkJM0JdyBupbH34FIZSPGDhkCoEQ/VIB9Di
        et/dD8DAxeNdMZKfUOA0xJyz/2lDL1makZVI4AO0OEglhy9h8bhQ7kAH+b9ciJWvFK+r9T9Rjfd
        ia1oVim6xxUqW
X-Received: by 2002:adf:bb82:: with SMTP id q2mr26164306wrg.170.1633975135826;
        Mon, 11 Oct 2021 10:58:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcA7ddOsvWoAKGQTBlvMoWuzcoqCXit45Ko+l5Rf3AyiQqbRVOzSKizf5HqT2Q/4GU9GN44A==
X-Received: by 2002:adf:bb82:: with SMTP id q2mr26164281wrg.170.1633975135550;
        Mon, 11 Oct 2021 10:58:55 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64ba.dip0.t-ipconnect.de. [91.12.100.186])
        by smtp.gmail.com with ESMTPSA id d3sm8760239wrb.36.2021.10.11.10.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 10:58:55 -0700 (PDT)
Subject: Re: [RFC PATCH v1 2/6] KVM: s390: Reject SIGP when destination CPU is
 busy
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-3-farman@linux.ibm.com>
 <4c6c0b14-e148-9000-c581-db14d2ea555e@redhat.com>
 <8d8012a8-6ea5-6e0e-19c4-d9c64e785222@de.ibm.com>
 <bddd3a05-b364-7b52-f329-11a07146394e@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <e9935fe6-8c8a-b63d-4076-de85fb0e7146@redhat.com>
Date:   Mon, 11 Oct 2021 19:58:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bddd3a05-b364-7b52-f329-11a07146394e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.10.21 09:52, Thomas Huth wrote:
> On 11/10/2021 09.43, Christian Borntraeger wrote:
>> Am 11.10.21 um 09:27 schrieb Thomas Huth:
>>> On 08/10/2021 22.31, Eric Farman wrote:
>>>> With KVM_CAP_USER_SIGP enabled, most orders are handled by userspace.
>>>> However, some orders (such as STOP or STOP AND STORE STATUS) end up
>>>> injecting work back into the kernel. Userspace itself should (and QEMU
>>>> does) look for this conflict, and reject additional (non-reset) orders
>>>> until this work completes.
>>>>
>>>> But there's no need to delay that. If the kernel knows about the STOP
>>>> IRQ that is in process, the newly-requested SIGP order can be rejected
>>>> with a BUSY condition right up front.
>>>>
>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>    arch/s390/kvm/sigp.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 43 insertions(+)
>>>>
>>>> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
>>>> index cf4de80bd541..6ca01bbc72cf 100644
>>>> --- a/arch/s390/kvm/sigp.c
>>>> +++ b/arch/s390/kvm/sigp.c
>>>> @@ -394,6 +394,45 @@ static int handle_sigp_order_in_user_space(struct
>>>> kvm_vcpu *vcpu, u8 order_code,
>>>>        return 1;
>>>>    }
>>>> +static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8
>>>> order_code,
>>>> +                    u16 cpu_addr)
>>>> +{
>>>> +    struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
>>>> +    int rc = 0;
>>>> +
>>>> +    /*
>>>> +     * SIGP orders directed at invalid vcpus are not blocking,
>>>> +     * and should not return busy here. The code that handles
>>>> +     * the actual SIGP order will generate the "not operational"
>>>> +     * response for such a vcpu.
>>>> +     */
>>>> +    if (!dst_vcpu)
>>>> +        return 0;
>>>> +
>>>> +    /*
>>>> +     * SIGP orders that process a flavor of reset would not be
>>>> +     * blocked through another SIGP on the destination CPU.
>>>> +     */
>>>> +    if (order_code == SIGP_CPU_RESET ||
>>>> +        order_code == SIGP_INITIAL_CPU_RESET)
>>>> +        return 0;
>>>> +
>>>> +    /*
>>>> +     * Any other SIGP order could race with an existing SIGP order
>>>> +     * on the destination CPU, and thus encounter a busy condition
>>>> +     * on the CPU processing the SIGP order. Reject the order at
>>>> +     * this point, rather than racing with the STOP IRQ injection.
>>>> +     */
>>>> +    spin_lock(&dst_vcpu->arch.local_int.lock);
>>>> +    if (kvm_s390_is_stop_irq_pending(dst_vcpu)) {
>>>> +        kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
>>>> +        rc = 1;
>>>> +    }
>>>> +    spin_unlock(&dst_vcpu->arch.local_int.lock);
>>>> +
>>>> +    return rc;
>>>> +}
>>>> +
>>>>    int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>>>>    {
>>>>        int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
>>>> @@ -408,6 +447,10 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>>>>            return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>>>        order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
>>>> +
>>>> +    if (handle_sigp_order_is_blocked(vcpu, order_code, cpu_addr))
>>>> +        return 0;
>>>> +
>>>>        if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
>>>>            return -EOPNOTSUPP;
>>>
>>> We've been bitten quite a bit of times in the past already by doing too
>>> much control logic in the kernel instead of doing it in QEMU, where we
>>> should have a more complete view of the state ... so I'm feeling quite a
>>> bit uneasy of adding this in front of the "return -EOPNOTSUPP" here ...
>>> Did you see any performance issues that would justify this change?
>>
>> It does at least handle this case for simple userspaces without
>> KVM_CAP_S390_USER_SIGP .
> 
> For that case, I'd prefer to swap the order here by doing the "if
> handle_sigp_order_in_user_space return -EOPNOTSUPP" first, and doing the "if
> handle_sigp_order_is_blocked return 0" afterwards.
> 
> ... unless we feel really, really sure that it always ok to do it like in
> this patch ... but as I said, we've been bitten by such things a couple of
> times already, so I'd suggest to better play safe...

As raised in the QEMU series, I wonder if it's cleaner for user space to 
set the target CPU as busy/!busy for SIGP while processing an order. 
We'll need a new VCPU IOCTL, but it conceptually sounds cleaner to me ...
-- 
Thanks,

David / dhildenb

