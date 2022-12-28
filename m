Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11D6576DA
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 14:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiL1NPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 08:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiL1NPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 08:15:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232AC1180E
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 05:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672233275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTl6S3HVtcLdlyIurr1Cwi3G31GmlPTfiN05afO+pYU=;
        b=MhLsK4p0FD0sugMwfQMmZyucL2PWxFq7Bt7s1mkqxyfaQulP8qf3RYIwaKj3RB53FUNe2B
        EsdYuWFDOYRDXpbfMbZse4b0UE9KRrQ8lRdHmWe6Q+6c37+9Za+BQZUm4nJ4U/IyuLmioE
        yXf8Rt/L3fpPFNsu2r/rJ217iKMz5lA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-j9Co8iADMzqsY2t596RKlw-1; Wed, 28 Dec 2022 08:14:33 -0500
X-MC-Unique: j9Co8iADMzqsY2t596RKlw-1
Received: by mail-ej1-f71.google.com with SMTP id sd1-20020a1709076e0100b00810be49e7afso11016965ejc.22
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 05:14:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTl6S3HVtcLdlyIurr1Cwi3G31GmlPTfiN05afO+pYU=;
        b=4Sfmm3UWyE1srqO/jr5kKXQIyYPhNay1263ltaz6jfMkHiPyYKPB1IcoJwodgtvkUp
         a9dYty5+QEZq1G2P6PM4d1lO9azUC/YCGwwJvP2bCsUz5wV61SqZoYWP9XYN3qOIxI/m
         8Hk58EliYhdGBieu6W/ltnbkwrQKjxiD2hEhY+MH/ZgUWJxnqkW2Bx0Av1feOX1lQk4v
         WGPH+e3OJ6qv4twrjjOwqKBXRMbk96fynA4Yu98hwbKZMzcfaHWfe6nHpFhpKI1FWAHf
         rlV+mgwg1Suxl+XiDqHf012i1sTwv9+dML8AsglR+Y0ysPqAdJyredTfvwcTWSKErsZk
         VD/Q==
X-Gm-Message-State: AFqh2koI0n2mvjE7TEVbm42qH3b6N3895BGNxlhhawJBVJle3kwxwoHe
        xHuz5lU+UMXsJIpMMMjN57lfJf3EQJNM+H3axQ09/Wsp9CR4vBYadiWJOjoQ8Rr1I8QnpkfVVPC
        kr+YypRK3ADFk
X-Received: by 2002:a17:907:8c81:b0:7c1:962e:cf28 with SMTP id td1-20020a1709078c8100b007c1962ecf28mr22316151ejc.23.1672233272771;
        Wed, 28 Dec 2022 05:14:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtpkmWkNlGXiJ/mfaubS/M+ZhvXwjb/4/bDs0G7EatIHMzYLSaHzNu5igLDXST+QYcBJpFbXw==
X-Received: by 2002:a17:907:8c81:b0:7c1:962e:cf28 with SMTP id td1-20020a1709078c8100b007c1962ecf28mr22316131ejc.23.1672233272535;
        Wed, 28 Dec 2022 05:14:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id u2-20020a1709061da200b0083f91a32131sm7371909ejh.0.2022.12.28.05.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 05:14:32 -0800 (PST)
Message-ID: <67c1fb6d-6bdb-c59e-a9c3-6eba2155288e@redhat.com>
Date:   Wed, 28 Dec 2022 14:14:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     paul@xen.org, seanjc@google.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
 <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
 <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
 <4ed92082-ef81-3126-7f55-b0aae6e4a215@redhat.com>
 <9b09359f88e4da1037139eb30ff4ae404beee866.camel@infradead.org>
 <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
 <50978768-2699-4D70-8AA9-1BBC82961BA9@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <50978768-2699-4D70-8AA9-1BBC82961BA9@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/28/22 13:35, David Woodhouse wrote:
>>> what is the general case lock ordering rule here? Can other code
>>> call synchronize_srcu() while holding kvm->lock? Or is that verboten?
>>
>> Nope, it's a general rule---and one that would extend to any other
>> lock taken inside srcu_read_lock(&kvm->srcu).
>> 
>> I have sent a patch to fix reset, and one to clarify the lock
>> ordering rules.
>
> Can we teach lockdep too?

I think it's complicated.  On one hand, synchronize_srcu() is very much 
a back to back write_lock/write_unlock.  In other words it would be easy 
for lockdep to treat this:

                                   mutex_lock(A)
     srcu_read_lock(B)
     mutex_lock(A)
                                   synchronize_srcu(B)
     srcu_read_unlock(B)

like this:

                                   exclusive_lock(A)
     shared_lock_recursive(B)
     exclusive_lock(A)
                                   exclusive_lock(B)
                                   exclusive_unlock(B)
     shared_unlock_recursive(B)


On the other hand, srcu_read_lock() does not block so this is safe:

                                   mutex_lock(A)
     srcu_read_lock(B)
     mutex_lock(A)
                                   srcu_read_lock(B)

unlike the corresponding case where B is a rwlock/rwsem.

Paolo

