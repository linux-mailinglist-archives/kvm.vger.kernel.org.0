Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F17A609CCA
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJXIdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 04:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiJXIdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 04:33:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920DC4A129
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 01:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666600405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AztsCWn4r1NILXtf08X14NzvAXIznK04t2hI2Bcl7sY=;
        b=MujjAxqbhyUTNAqTn9lUTSnxz3RWwhqk//+KhPV8bBUBHhSZlfmmHcTdqqN5UHd0+H6ps3
        jCal7jnkX9qmTL4MRxtL882RAYzXplZipgd1d5aff9o8aKER43HKQyuRosXzp7u2RGTVCT
        0VPfvOAVOYa7uu5OqXvgcq0Ddg+eeE8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-198-DF4MHRKJNbKCFV6RZMBDDQ-1; Mon, 24 Oct 2022 04:33:24 -0400
X-MC-Unique: DF4MHRKJNbKCFV6RZMBDDQ-1
Received: by mail-qv1-f72.google.com with SMTP id 71-20020a0c804d000000b004b2fb260447so4890591qva.10
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 01:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AztsCWn4r1NILXtf08X14NzvAXIznK04t2hI2Bcl7sY=;
        b=745V3kJujy8X5VAcpC9vNER2DohU9paNSfOw8MF+/4YgnD3R5cgOMCJxIFHGX4VA6V
         ZO5oL4qZswE5O6+yxavrZUjeUFojH40ZHXiJkNkdT9+eIQSgXjlkmCfsbmn/edckfz41
         fDaQNr4OV5bQTha37hcpysvmh4Buu7XUq9kUUnzVVlhqS80+M7AHsKQGd4HeLI3IB9VF
         0wpV7RYxyGseYcBcMv09AZLanKmkq2zEKRT//CAa3CF+UZf2WuaER/k42QwkOkjzP09l
         A5d/FeCd+eYINc2gdoMAP+sknCGQ17WtA/B0GOcxFbDEAHqjCtW3agEBMs9GOtTiHX7F
         uwoA==
X-Gm-Message-State: ACrzQf3nFZYPDaBg1xKUYZ65HX0Nqr7mgnPVuclfYX8Xe2HOMzkdQ2KE
        L0vY247u8w+i6nWviXtqj5mb4R+t4JKdqGI0/cQC8KphN7wHrYDsUuP4erE4JWhKBfGSEg1EtB6
        eneX6fRgesQjM
X-Received: by 2002:ac8:7d92:0:b0:39c:f4b6:f014 with SMTP id c18-20020ac87d92000000b0039cf4b6f014mr25667997qtd.513.1666600403846;
        Mon, 24 Oct 2022 01:33:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7YuSEiIz/2zlfJySdDr/Uv6YW5Od8GIBMEhw8v9FPEi+DDYWIDJDJn05RSRu9IVzjv9FqB5A==
X-Received: by 2002:ac8:7d92:0:b0:39c:f4b6:f014 with SMTP id c18-20020ac87d92000000b0039cf4b6f014mr25667975qtd.513.1666600403599;
        Mon, 24 Oct 2022 01:33:23 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bl29-20020a05620a1a9d00b006f0fc145ae5sm5743365qkb.15.2022.10.24.01.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 01:33:22 -0700 (PDT)
Message-ID: <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
Date:   Mon, 24 Oct 2022 10:33:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/4] KVM: API to block and resume all running vcpus in a
 vm
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24/10/2022 um 09:56 schrieb Christian Borntraeger:
> Am 22.10.22 um 17:48 schrieb Emanuele Giuseppe Esposito:
>> This new API allows the userspace to stop all running
>> vcpus using KVM_KICK_ALL_RUNNING_VCPUS ioctl, and resume them with
>> KVM_RESUME_ALL_KICKED_VCPUS.
>> A "running" vcpu is a vcpu that is executing the KVM_RUN ioctl.
>>
>> This serie is especially helpful to userspace hypervisors like
>> QEMU when they need to perform operations on memslots without the
>> risk of having a vcpu reading them in the meanwhile.
>> With "memslots operations" we mean grow, shrink, merge and split
>> memslots, which are not "atomic" because there is a time window
>> between the DELETE memslot operation and the CREATE one.
>> Currently, each memslot operation is performed with one or more
>> ioctls.
>> For example, merging two memslots into one would imply:
>> DELETE(m1)
>> DELETE(m2)
>> CREATE(m1+m2)
>>
>> And a vcpu could attempt to read m2 right after it is deleted, but
>> before the new one is created.
>>
>> Therefore the simplest solution is to pause all vcpus in the kvm
>> side, so that:
>> - userspace just needs to call the new API before making memslots
>> changes, keeping modifications to the minimum
>> - dirty page updates are also performed when vcpus are blocked, so
>> there is no time window between the dirty page ioctl and memslots
>> modifications, since vcpus are all stopped.
>> - no need to modify the existing memslots API
> Isnt QEMU able to achieve the same goal today by forcing all vCPUs
> into userspace with a signal? Can you provide some rationale why this
> is better in the cover letter or patch description?
> 
David Hildenbrand tried to propose something similar here:
https://github.com/davidhildenbrand/qemu/commit/86b1bf546a8d00908e33f7362b0b61e2be8dbb7a

While it is not optimized, I think it's more complex that the current
serie, since qemu should also make sure all running ioctls finish and
prevent the new ones from getting executed.

Also we can't use pause_all_vcpus()/resume_all_vcpus() because they drop
the BQL.

Would that be ok as rationale?

Thank you,
Emanuele

