Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0692162288E
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 11:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiKIKgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 05:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiKIKgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 05:36:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6871A051
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 02:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667990146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OXh9xRxeOqiCgGAyIslxozC+WKA3WlHvk2TQ5NzdIts=;
        b=b8b6TfX/Esa8rV7V2Ibv4YktQ4h2/YPI2Pw6nNNXFj/Rhq1Lxvzhu/k+1DH8qASF0G3a1O
        BpmBr8ZEn4ELypRD2PJApMpPQKxBBFEFj8zhdbKCqG24vgaXjp4/3JPE9iVsHVaQMvGHRr
        k1Lm5mTSYWra7EQwKBwCPXOt7qjIGU0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-6l41sdHrNDCcrRC4ER9n0A-1; Wed, 09 Nov 2022 05:35:45 -0500
X-MC-Unique: 6l41sdHrNDCcrRC4ER9n0A-1
Received: by mail-wr1-f69.google.com with SMTP id d10-20020adfa34a000000b00236616a168bso4882635wrb.18
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 02:35:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OXh9xRxeOqiCgGAyIslxozC+WKA3WlHvk2TQ5NzdIts=;
        b=AMDzaDEfroewa0sqq4KxPJdOIDLzIrEZ/aR2noNNKlfe+A3ToQ4HoU90jiBdEREx2d
         /2QpCSm5zg7z9MB/CyDI9/yUAmEGz5qaJkpgk3FnjvfhlYzhCktB+/Jfr1KXSuxJ2ojA
         n9YH0xLGbrL4ma2O45/cqanJ5dma/6B1O0MA/prxPoRYeDOv00PSbpm4M6Vy6XjMrjDg
         HVa9su9En/EnSNGpzc4LYPpUDwxGJQHaUsL6u0wzaNzuZYzF4SSUG0Gls6c8Vu+7RrB1
         bhaan0unHpVVvENM4T/cUL9qIDVF7I8E8LLO+imVNCGuOCCwwiy+Q3GdzhLLxMFSXJ9b
         oXbA==
X-Gm-Message-State: ACrzQf1nzNQnZVp3Czri29ngM0CAyQ9CUXyPe3RRLgDqeo6Cl99VFfQz
        N1AlcCh9w+DdIDuBf8ie3xLycuD9FmCQl6eppwWQB85YfdfMnWOfA15iVahvOliSBtvqF9y5cE8
        NTHKxUg5j/3Zk
X-Received: by 2002:a05:600c:54d1:b0:3cf:a39f:eafe with SMTP id iw17-20020a05600c54d100b003cfa39feafemr14003399wmb.159.1667990143966;
        Wed, 09 Nov 2022 02:35:43 -0800 (PST)
X-Google-Smtp-Source: AMsMyM67vMbZOxyO9HdRP++/quRqreMLNQgI0Z3kPqtanXbNCYKYQhOFA99t07LzkKg+TdBKcSIorg==
X-Received: by 2002:a05:600c:54d1:b0:3cf:a39f:eafe with SMTP id iw17-20020a05600c54d100b003cfa39feafemr14003389wmb.159.1667990143748;
        Wed, 09 Nov 2022 02:35:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id x15-20020adfdd8f000000b002365921c9aesm13026740wrl.77.2022.11.09.02.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 02:35:43 -0800 (PST)
Message-ID: <1fc523b0-da9c-64a0-7459-e8cf9fe3b819@redhat.com>
Date:   Wed, 9 Nov 2022 11:35:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 2/8] KVM: SVM: replace regs argument of __svm_vcpu_run
 with vcpu_svm
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221108151532.1377783-1-pbonzini@redhat.com>
 <20221108151532.1377783-3-pbonzini@redhat.com> <Y2rCIWtAsmEF1UuM@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2rCIWtAsmEF1UuM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/22 21:54, Sean Christopherson wrote:
> On Tue, Nov 08, 2022, Paolo Bonzini wrote:
>> Since registers are reachable through vcpu_svm, and we will
>> need to access more fields of that struct, pass it instead
>> of the regs[] array.
>>
>> No functional change intended.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
> 
> I don't think a Fixes: tag for a pure nop patch is fair to the original commit.

That's for the sake of correct tracking in stable@, still it's not the 
right commit to point at:

- f14eec0a3203 did not move the RSB stuffing before the GSBASE restore, 
the code before was:

	vmexit_fill_RSB();
  #ifdef CONFIG_X86_64
  	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
  #else

- anyway it wasn't really buggy at the time: it's only in -next that 
FILL_RETURN_BUFFER uses percpu data, because alternatives take care of 
the X86_FEATURE_* checks

The real reason to do all this is to access the percpu host spec_ctrl, 
which in turn is needed for retbleed.  I'll point the Fixes tag to 
a149180fbcf3 ("x86: Add magic AMD return-thunk") instead, again just for 
the sake of tracking releases that need the change to full fix retbleed.

Paolo

