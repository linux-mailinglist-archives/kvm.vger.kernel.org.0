Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD83F75ED5A
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjGXIXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjGXIXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:23:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E82A131
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690186978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uZSMkLJ8MfGB3NZlVuXc/0ylP0lrumtVWsn82boBlRE=;
        b=bF0Pc30BiG9Ll6FiGzjGuxW7pA7tdKJ8YY7E2UGtadjJjOl2m6VcK8DcIbRpcXxLU9sS3P
        CZIJ8U8BblTcbZVd/4jsgeDc2mE6IuYy4m6B85pwl5NJ54x4/tYQhDCx1p1m+c9yFstZH5
        JhH7gCqXG1/b8MfuevwsH+5x/t2ta+Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-fOQv45CVP9mFB4dLgkI-IA-1; Mon, 24 Jul 2023 04:22:56 -0400
X-MC-Unique: fOQv45CVP9mFB4dLgkI-IA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fb416d7731so19417715e9.2
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690186975; x=1690791775;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uZSMkLJ8MfGB3NZlVuXc/0ylP0lrumtVWsn82boBlRE=;
        b=j+mOtDYIXrFaOAw/e7YEkm5On/0QNJfc30L7cH5nrRw4rt6DLKBp9e+Np/o+UxGRIP
         AUomg88FZ4nzhfVqdG2UYzG0S2l9x1VOnrCFrwCJwaCwuAO1UYdQtVheztWP+h2Cphjp
         GQYWkNKN/QhYBk6ij7fvz0Ad26rzy/lPDIYjeuM9V1/M6+3E3nZv85Ic1Z3tGLBHYIoP
         jGudxBRcpT5uTvOu8XPCRllIgffDd4+U4+7z0iA5xRsi/XwByjWRtMb+yAAOeYYOFn2L
         6nbCV/CFVFWgYYBpuypZDoVHoOXpoDgR6XJ9YRi0szzcosV/TipsY+uyQk12/Lh0uYco
         FAWA==
X-Gm-Message-State: ABy/qLazBwCpLru2/T+xcYLO0mbGFhPN27XvJK2ReCpxpWDX1v+RjxiI
        8HgGTZaJYWBDMVZBlVlkTLStek8409xDYmOV/zDtTgLSlSpkwZl1tyk/wr5CtsnZRxI+2QY/h8T
        Ud+GFgTUOSst5
X-Received: by 2002:a7b:c7d8:0:b0:3fb:a102:6d7a with SMTP id z24-20020a7bc7d8000000b003fba1026d7amr5294663wmk.28.1690186975114;
        Mon, 24 Jul 2023 01:22:55 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGZj29rHiyHV23TBcjt4KImow2A6hGZHPtgZhwdsT1l1etBcqDHZaeqr258tj3B2CQsPP72SA==
X-Received: by 2002:a7b:c7d8:0:b0:3fb:a102:6d7a with SMTP id z24-20020a7bc7d8000000b003fba1026d7amr5294645wmk.28.1690186974735;
        Mon, 24 Jul 2023 01:22:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f45:d000:62f2:4df0:704a:e859? (p200300d82f45d00062f24df0704ae859.dip0.t-ipconnect.de. [2003:d8:2f45:d000:62f2:4df0:704a:e859])
        by smtp.gmail.com with ESMTPSA id v22-20020a7bcb56000000b003fbb9339b29sm12169484wmj.42.2023.07.24.01.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 01:22:54 -0700 (PDT)
Message-ID: <af7be3a9-816c-95dc-22a7-cf62fe245e24@redhat.com>
Date:   Mon, 24 Jul 2023 10:22:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
 <20230721120046.2262291-2-iii@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 1/6] KVM: s390: interrupt: Fix single-stepping into
 interrupt handlers
In-Reply-To: <20230721120046.2262291-2-iii@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.07.23 13:57, Ilya Leoshkevich wrote:
> After single-stepping an instruction that generates an interrupt, GDB
> ends up on the second instruction of the respective interrupt handler.
> 
> The reason is that vcpu_pre_run() manually delivers the interrupt, and
> then __vcpu_run() runs the first handler instruction using the
> CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the second handler
> instruction.
> 
> Fix by delaying the KVM_SINGLESTEP exit until after the manual
> interrupt delivery.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>   arch/s390/kvm/interrupt.c | 10 ++++++++++
>   arch/s390/kvm/kvm-s390.c  |  4 ++--
>   2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 9bd0a873f3b1..2cebe4227b8e 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1392,6 +1392,7 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
>   	int rc = 0;
> +	bool delivered = false;
>   	unsigned long irq_type;
>   	unsigned long irqs;
>   
> @@ -1465,6 +1466,15 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
>   			WARN_ONCE(1, "Unknown pending irq type %ld", irq_type);
>   			clear_bit(irq_type, &li->pending_irqs);
>   		}
> +		delivered |= !rc;
> +	}
> +


Can we add a comment like

/*
  * We delivered at least one interrupt and modified the PC. Force a
  * singlestep event now.
  */

> +	if (delivered && guestdbg_sstep_enabled(vcpu)) {
> +		struct kvm_debug_exit_arch *debug_exit = &vcpu->run->debug.arch;
> +
> +		debug_exit->addr = vcpu->arch.sie_block->gpsw.addr;
> +		debug_exit->type = KVM_SINGLESTEP;
> +		vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
>   	}

I do wonder if we, instead, want to do this whenever we modify the PSW.

That way we could catch any PC changes and only have to add checks for 
guestdbg_exit_pending().


But this is simpler and should work as well.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

