Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B711575EE8E
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjGXI6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjGXI6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2060BE3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690189021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hiUzn4GoHzYmJRywXbeyp47r5LbOlgKk94EnRsD7j9E=;
        b=MQVkAnAehqeknoiS8G/H5QWVlJRLLl9K3qeQYKrv+vMqB5W28MvGqaHOCOHUS4eiGF45gV
        4NMiA/NKo+DwrQifB14Gr6XvGFjU6StWSt2RvRHVgW/jozzIGoJMguwLPr6c08C6KBBodQ
        Si4lbA/pTI6cbBgti0q9Y8ss7MiSvzY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-wHpT_FjxNByepZU5ke6otw-1; Mon, 24 Jul 2023 04:56:59 -0400
X-MC-Unique: wHpT_FjxNByepZU5ke6otw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fbcae05906so25567095e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690189018; x=1690793818;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hiUzn4GoHzYmJRywXbeyp47r5LbOlgKk94EnRsD7j9E=;
        b=bJwRqW9gwPSyILUTsZgjsYgqSycOVgaH6DiutitUtiODq68D6MxyuM0QX5jQtRhZDR
         4kk05fY3yvTP6FPZARggTtDtfpxJtXxIFeaFB5lzSyRRzodDYOnDrvtKOJsTF0ZwV/tl
         ebKxuQESzj7U4jjlGhMu8kldsv3v4J73itiayBQa7/jOZVxIOrC8OALSIOV6tiipDrS1
         vWgJnlbEUntY6eXWLJ2ko5bLyWAPI4rlb4H/y68BRRQYNMraPu2n8mNTLEbmmgFn74Br
         FMdUltv9sK9AjW3OJd7af40mZ1ja7kDNBBsDUfMfMh6a10rd6kPZYSTHpSWjjwJe2+Xw
         reKg==
X-Gm-Message-State: ABy/qLaltO9ehDIm957jj4C9Up1pw0qeG90Buv1obppipdF930fGqKtj
        QZCZkzys8oQsmaQFNFzVsQ2QcKgcZ09QXjkwUNvTR8E5sdhxhoipn8+5UIBX7ybA4KjsxXSXquS
        aVLSBCfkTp8sQ
X-Received: by 2002:a1c:ed0f:0:b0:3f8:fc96:6bfd with SMTP id l15-20020a1ced0f000000b003f8fc966bfdmr6849524wmh.17.1690189018754;
        Mon, 24 Jul 2023 01:56:58 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHpERLNNdkBQgqeLMFfxb+yLknb1i7c/nG0TK8neSKVVTW7S2Zgzvd3sYLdo7tRcyc7R9bJOQ==
X-Received: by 2002:a1c:ed0f:0:b0:3f8:fc96:6bfd with SMTP id l15-20020a1ced0f000000b003f8fc966bfdmr6849505wmh.17.1690189018429;
        Mon, 24 Jul 2023 01:56:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f45:d000:62f2:4df0:704a:e859? (p200300d82f45d00062f24df0704ae859.dip0.t-ipconnect.de. [2003:d8:2f45:d000:62f2:4df0:704a:e859])
        by smtp.gmail.com with ESMTPSA id p25-20020a1c7419000000b003fbb0c01d4bsm9753501wmc.16.2023.07.24.01.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 01:56:57 -0700 (PDT)
Message-ID: <dba4395d-400a-7bea-5eba-a44cab80ce0e@redhat.com>
Date:   Mon, 24 Jul 2023 10:56:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 1/6] KVM: s390: interrupt: Fix single-stepping into
 interrupt handlers
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
 <af7be3a9-816c-95dc-22a7-cf62fe245e24@redhat.com>
 <5394773f1d872f086625439cc515c50d2374a161.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <5394773f1d872f086625439cc515c50d2374a161.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.07.23 10:42, Ilya Leoshkevich wrote:
> On Mon, 2023-07-24 at 10:22 +0200, David Hildenbrand wrote:
>> On 21.07.23 13:57, Ilya Leoshkevich wrote:
>>> After single-stepping an instruction that generates an interrupt,
>>> GDB
>>> ends up on the second instruction of the respective interrupt
>>> handler.
>>>
>>> The reason is that vcpu_pre_run() manually delivers the interrupt,
>>> and
>>> then __vcpu_run() runs the first handler instruction using the
>>> CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the second
>>> handler
>>> instruction.
>>>
>>> Fix by delaying the KVM_SINGLESTEP exit until after the manual
>>> interrupt delivery.
>>>
>>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/interrupt.c | 10 ++++++++++
>>>    arch/s390/kvm/kvm-s390.c  |  4 ++--
>>>    2 files changed, 12 insertions(+), 2 deletions(-)
> 
> [...]
>>
> 
>> Can we add a comment like
>>
>> /*
>>    * We delivered at least one interrupt and modified the PC. Force a
>>    * singlestep event now.
>>    */
> 
> Ok, will do.
> 
>>> +       if (delivered && guestdbg_sstep_enabled(vcpu)) {
>>> +               struct kvm_debug_exit_arch *debug_exit = &vcpu-
>>>> run->debug.arch;
>>> +
>>> +               debug_exit->addr = vcpu->arch.sie_block->gpsw.addr;
>>> +               debug_exit->type = KVM_SINGLESTEP;
>>> +               vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
>>>          }
>>
>> I do wonder if we, instead, want to do this whenever we modify the
>> PSW.
>>
>> That way we could catch any PC changes and only have to add checks
>> for
>> guestdbg_exit_pending().
> 
> Wouldn't this break a corner case where the first instruction of the
> interrupt handler causes the same interrupt?

Could be, there are many possible corner cases (PGM interrupt at the 
first instruction of PGM interrupt handler -- our PSW address might not 
even change)

-- 
Cheers,

David / dhildenb

