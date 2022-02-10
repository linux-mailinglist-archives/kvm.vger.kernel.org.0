Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233FD4B1473
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245265AbiBJRnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:43:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbiBJRnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:43:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E8EB192
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644514990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/BBZqEoVfgrKabodXFBIfVfpq8FM92AHBedmxW/K9E=;
        b=Ie9G2HPtAKVSAEIcfInoE5ALNo6uWflVIFlj+duFdB76nem09Ewr9yn5JvWhylDytu7INp
        9dD+rjZPMVZkeiucrjC/nZF+tjuyCMdT64udZYcKoQZWzYHih36iHUTTKOrB952DegyqsJ
        a2KuieNsqw+RhbDmH2ASzi5NySiAG9o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-_j0yYoETN2m2Fj-rbjdS3g-1; Thu, 10 Feb 2022 12:43:04 -0500
X-MC-Unique: _j0yYoETN2m2Fj-rbjdS3g-1
Received: by mail-ej1-f69.google.com with SMTP id aj9-20020a1709069a4900b006cd205be806so3069737ejc.18
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:43:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l/BBZqEoVfgrKabodXFBIfVfpq8FM92AHBedmxW/K9E=;
        b=seCAJWqhH5LBO2ZIf6b4o/HCZ0tSu8F3XPtl6YOdiwLAr+hAVGEbpyKTdCOTWLfFFD
         6ZKXR2g4xKB3qmjdGovSo7YTvqWqF++6SEcXbhgfzb1LGLMA9v6kjCudzdJLQlOoUQJH
         QeKWpbw9b3tK4Ql1JSKn85Dus0l6TrpUC2nLXKyQigp0eF73fTxuG6gGEgKAAxbhb0G2
         +6C1MeVutNSBOZwlMDw+W6mkfXHUbGLVTwiPjA3CSe9KazXmCQlkeYDMmuDvcsQEYnKZ
         e9tJBWbQPnNpNWQ9Tb+lqxESOcG0F91RaKqiT++n7fEREXQE3TmB2VjlChunvBFU9Itn
         rlkw==
X-Gm-Message-State: AOAM532ssSaMwu4xd5heEyE5toZ32K2F/6jYG4mQEvChTFsc9xQk+Age
        7H00Xwap19GYJH6SJaoMUcPRn+VG5vVsITJ6dcXX560+IHhKTna+b21bykme3zFh13ZBIBYjKIX
        2fIJf4tMT+/jf
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr6977860ejc.667.1644514982869;
        Thu, 10 Feb 2022 09:43:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKjfhznrr9laZMtcRaScaaUKLhriNA5xwcpXInITqCA6iv3CF/yPelg05zk1+mdpH7+t1itQ==
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr6977851ejc.667.1644514982705;
        Thu, 10 Feb 2022 09:43:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z22sm8979452edq.9.2022.02.10.09.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 09:43:01 -0800 (PST)
Message-ID: <88d3f309-9424-9035-b2ef-88c5d7fb088f@redhat.com>
Date:   Thu, 10 Feb 2022 18:43:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 07/23] KVM: MMU: remove kvm_mmu_calc_root_page_role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-8-pbonzini@redhat.com> <YgRgrCxLM0Ctfwrj@google.com>
 <1e8c38eb-d66a-60e7-9432-eb70e7ec1dd4@redhat.com>
 <YgVLkgwBRy+JXZiH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgVLkgwBRy+JXZiH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 18:29, Sean Christopherson wrote:
> On Thu, Feb 10, 2022, Paolo Bonzini wrote:
>> On 2/10/22 01:47, Sean Christopherson wrote:
>>> The nested mess is likely easily solved, I don't see any obvious issue with swapping
>>> the order.  But I still don't love the subtlety.  I do like shaving cycles, just
>>> not the subtlety...
>>
>> Not so easily, but it's doable and it's essentially what I did in the other
>> series (the one that reworks the root cache).
> 
> Sounds like I should reveiw that series first?

Yeah, this one is still a nice step in the direction of guest pt walk 
from shadow pt build(*), but with no immediate use for TDP MMU root reuse.

The original idea was to use the MMU role to decide whether to do 
kvm_mmu_unload(), but that would have still been a bandaid---inefficient 
and a bad idea overall.  Patches 6+7 of this series (once fixed, because 
they were buggy as hell) turned out to be enough to tame the PGD cache 
and remove kvm_mmu_unload() altogether from kvm_mmu_reset_context().

Paolo

(*) Your idea of detecting stale roots is quite easily implemented on 
top of these, for example, because a root is stale if and only if the 
root_role changes.

