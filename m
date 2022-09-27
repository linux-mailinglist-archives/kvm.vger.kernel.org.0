Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155E45EC6F7
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiI0Oye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 10:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiI0OyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACC243313
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664290332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R6mTkPvLcBDkRPEP9w1VCxjxG2Pg7cZFN1wUuSD75U8=;
        b=OAlCx8cCtQY23ufSVXsBgYdlqMJ8y/PPhpoqP0x5ptEC7DHgA+MUXyCbL2Uj5AjhHvAG8e
        bQr2aR6Z7i99tNYAOhsquo/UCgPGT9nZozozDBeodZpNwPbzNWQIZaCsztHDbpjQeSwQDi
        7tc4RmuvlnL8zQUlT8L6PcCeVzWXV7E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-IDnU4iNNP66yAuBLaG8e9A-1; Tue, 27 Sep 2022 10:52:10 -0400
X-MC-Unique: IDnU4iNNP66yAuBLaG8e9A-1
Received: by mail-wm1-f70.google.com with SMTP id d5-20020a05600c34c500b003b4fb42ccdeso8707634wmq.8
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=R6mTkPvLcBDkRPEP9w1VCxjxG2Pg7cZFN1wUuSD75U8=;
        b=1Y9k8n1bVhdrflbJyzeUkRhKMzngAw3yCbW/vBpQ/20Xa1vdvJoLXfywlSF22mQdqp
         GDVaUwLIkY0t1Lwk2ycqJo5elNNMjZIyunD52aFQa4ofhOcwZqxxTbEt5pldJG6gDyr2
         W0SpqJti7ZSC1gIz7f3x5SxKYbj3w4WcgYFCjIy11ZbRODUHDyVLPYpeUNtsKKYWoj/9
         hK4vHJK0+IGdIg7Ca93kqaXKSnD40pZ0lP3rVoxkeCglwGqd29vPTFK9576dNjjKTGlT
         Vtzm21vmRj8gA3sxobIRzazmMhRbPIO740KmzMT6YPeKClmpcG7NerIONTKlkyWlnE8M
         jkHg==
X-Gm-Message-State: ACrzQf3RQEUWkOaUob5BONqdNjdZVWjsyitRDn5TrCVbcne0xeObut52
        bYV90AexxFkRACGUK7Uh6fuD8v2R1nnqnu35+cNCK13HaNspzd+ymfKZu9UpxzFItjUJKGJzapE
        y33ideq8IQlQc
X-Received: by 2002:a05:600c:4ec7:b0:3a8:4622:ad27 with SMTP id g7-20020a05600c4ec700b003a84622ad27mr3187477wmq.88.1664290329611;
        Tue, 27 Sep 2022 07:52:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM62+UnH0+JOnbyYplqTQoYjHUK04qQp8/V7xC4iNX3GpDY8U0fUFfcgyuQzRA289qMAo/xhgA==
X-Received: by 2002:a05:600c:4ec7:b0:3a8:4622:ad27 with SMTP id g7-20020a05600c4ec700b003a84622ad27mr3187460wmq.88.1664290329340;
        Tue, 27 Sep 2022 07:52:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:ff00:9ec2:6ff6:11a1:3e80? (p200300cbc705ff009ec26ff611a13e80.dip0.t-ipconnect.de. [2003:cb:c705:ff00:9ec2:6ff6:11a1:3e80])
        by smtp.gmail.com with ESMTPSA id w10-20020a05600c474a00b003b4ac05a8a4sm18031124wmo.27.2022.09.27.07.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 07:52:08 -0700 (PDT)
Message-ID: <c4662f56-578b-00bd-cdc2-19d3c45eabf0@redhat.com>
Date:   Tue, 27 Sep 2022 16:52:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-10-eesposit@redhat.com>
 <cde8be9d-64c0-80e5-7663-4302d075dcbc@redhat.com>
 <07014070-5186-ca95-7028-82f77612dedd@redhat.com>
 <a8c40c94-771c-ca3d-ee1d-44cbed2398e8@redhat.com>
 <81c235cc-1198-9765-d1e7-a158ea63eac4@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <81c235cc-1198-9765-d1e7-a158ea63eac4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Does the invalidation already free up memslot metadata (especially the
>> rmaps) or will we end up temporarily allocating twice the memslot metadata?
>>
> 
> Invalidation creates a new temporary identical memslot, I am not sure
> about the rmaps. It is anyways the same code as it was done before and
> if I understand correctly, a new slot is required to keep the old
> intact, in case something goes wrong and we need to revert.

Okay, thanks!

-- 
Thanks,

David / dhildenb

