Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49AE620B8D
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiKHIxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 03:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiKHIxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 03:53:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6CE2E6A5
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 00:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667897568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RKuZuuCI3q1K/HAD0IraHvmgBZQfdPy2jKFzjPsKHLQ=;
        b=PbAV/nsQYNlOgKCOTa+7l3+MxDr52SGnVzXAO28ZISmpl/lQEByPligXroMNLFOK9vZOT9
        QEu+TllH23kUJr3ro8fVaNus5XLJA1R+Y270FB+wlK+0fjcJx4Xc/9ind805QAHO7oG9j7
        S/3ZlYA0fTYQm6yhiYQ+dfG4/UWqAJk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-673-2GfDEbMsNaWjQqXJ7yaE6w-1; Tue, 08 Nov 2022 03:52:47 -0500
X-MC-Unique: 2GfDEbMsNaWjQqXJ7yaE6w-1
Received: by mail-wr1-f72.google.com with SMTP id c18-20020adfa312000000b002364fabf2ceso3713279wrb.2
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 00:52:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKuZuuCI3q1K/HAD0IraHvmgBZQfdPy2jKFzjPsKHLQ=;
        b=oX32xqyLFIE3AUNs1u33xgQ7YbUbgj4yeNN0QhK2ajPhhtjcWUDiu9tAc7sftuYT2l
         jJAsJpnnHBEaQB7o3sq3EbB3lahr+3NN2PHHex7wwLBLavulkeM8ZkfijkGWUzdK5leD
         +uLtXBAEl/8lEURNRaqej97gr4pL8mZ6MyYMs+mNoGtlluw68cJxXza95Mb+rIxjtoY9
         nwS96xiZoaxdrIwGx6wN/JW0/5DhY2Z+7X9yHCGWPlnUNT9SZCm/Af9Y/48UdCmsOhkO
         jMmNxuvxsQKJHhPXRDorgQO08jRgUGG9ibQZFOkVJohAYQ0K3k1ET05jcALGT8zwxr7U
         kR4A==
X-Gm-Message-State: ACrzQf1kne4YMpShw2JiWLfpJEoUQ3yZT/1rek52OT8UUFk6rxWmHFFe
        aLk36nmrLeP2zbMpV9WAYgY803/udZ/97BfrPunqWe/xuxa2cmiPHLDnYcnkHQGRInZD292lrk5
        FbcR3NlPWx5+b
X-Received: by 2002:adf:d1ec:0:b0:236:880f:2adf with SMTP id g12-20020adfd1ec000000b00236880f2adfmr34973835wrd.617.1667897565471;
        Tue, 08 Nov 2022 00:52:45 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7Td3mYckln2lF/t1NuVY8SNErV7PoyhpXFlmaTgJp4otL4qyQGKPyguMnBStkFyC35OBmmZw==
X-Received: by 2002:adf:d1ec:0:b0:236:880f:2adf with SMTP id g12-20020adfd1ec000000b00236880f2adfmr34973813wrd.617.1667897565248;
        Tue, 08 Nov 2022 00:52:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id bq21-20020a5d5a15000000b00231ed902a4esm9931077wrb.5.2022.11.08.00.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 00:52:44 -0800 (PST)
Message-ID: <b9debf81-1489-6379-4377-e987f604bf96@redhat.com>
Date:   Tue, 8 Nov 2022 09:52:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/8] KVM: SVM: extract VMCB accessors to a new file
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-2-pbonzini@redhat.com> <Y2k7o8i/qhBm9bpC@google.com>
 <3ca5e8b6-c786-2f15-8f81-fd6353c43692@redhat.com>
 <Y2lLFEt3tQBoZTDe@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2lLFEt3tQBoZTDe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 19:14, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Paolo Bonzini wrote:
>> On 11/7/22 18:08, Sean Christopherson wrote:
>>> What about making KVM self-sufficient?
>>
>> You mean having a different asm-offsets.h file just for arch/x86/kvm/?
> 
> Yeah.

Doh, it would have been enough to add #ifdef COMPILE_OFFSETS to 
svm/svm.h, but it was also pretty easy to generate a separate 
asm-offsets file so why not.

Paolo

