Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432C1616B4F
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiKBR4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKBR4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:56:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461A12EF10
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667411711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tePRKZ0uLjBLYtJwfg0xYFUmQTdg6aXwOf9GayM0nFY=;
        b=P+qkNoAHXkUEQ7NWg1R983QWCWziOUCvw0zyjPAgDPN67OhvQg1W+7Noad6Lzh6GGrIriD
        DOdwF20VtKqmfmhJiJnvsRQBYLHsgTremgCA3dP+eKS+SM5kuK7GatTiN7PJuNKOQEZY99
        CRNGEzIpLVcxhKILpfDvI0DV4MVoAqw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-yhHIpxHGNDuv12lYZ5hyGA-1; Wed, 02 Nov 2022 13:55:09 -0400
X-MC-Unique: yhHIpxHGNDuv12lYZ5hyGA-1
Received: by mail-ej1-f71.google.com with SMTP id ga26-20020a1709070c1a00b007ad4a55d6e1so10203686ejc.6
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tePRKZ0uLjBLYtJwfg0xYFUmQTdg6aXwOf9GayM0nFY=;
        b=CmrY5/sLFB4L1g2kpgFVUSg7M13h1jXw7f/j/Xj746aBc0EGbVZfaHa6NXz1umBn3B
         8zm8mWKbatQNtSpG3jGsk/LCOn9qudV8g7KkrOjCunAtU6ugGC8yOqVKOuIvS5TzyqEr
         fyCqUsadfEHkYvtq+cClYOW/ugAG8FnwQNrngk4uum7/1HaENPi2lD2zNbhJzusdpp5h
         MGd/iwZG4YqIRHtHbWmVOubgnJ+xRsuyK/ZN4vHJe68Q58QNvQHxAkDpE5zXMldzVNrL
         y+rQl5Pgp2PdSYUZ1bgvBl3S+rWKBpx0dSLGuMzU799qqRBFeH9887x1pN/wFF5l8RP5
         3UqA==
X-Gm-Message-State: ACrzQf3dYV3kdVK9S3LUHgtsB5GlogcTVl36wILepgx4oO3DRPq6vCb3
        Rxqr8m+JQjbrcvPffJZ6a/Dhf92Wm26XxVut9I4N6V3tyjZNK9SqwkW3kG90PY2wPqE9mLHPWvd
        v9dexAgEe/KRk
X-Received: by 2002:a17:906:dc93:b0:7ad:ca82:4cb9 with SMTP id cs19-20020a170906dc9300b007adca824cb9mr18291450ejc.521.1667411708077;
        Wed, 02 Nov 2022 10:55:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4CGDDQLFxluIk93PXHliWQxFzNbc8VATbMSOEZi9GEjCnyS6RcTxp7eGuio3D7ZCvsmWJmNw==
X-Received: by 2002:a17:906:dc93:b0:7ad:ca82:4cb9 with SMTP id cs19-20020a170906dc9300b007adca824cb9mr18291428ejc.521.1667411707801;
        Wed, 02 Nov 2022 10:55:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id v27-20020aa7cd5b000000b00458898fe90asm6117421edw.5.2022.11.02.10.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:55:07 -0700 (PDT)
Message-ID: <67c59554-1d90-0c7c-a436-e2dd0782f4cb@redhat.com>
Date:   Wed, 2 Nov 2022 18:55:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
References: <20221028130035.1550068-1-aaronlewis@google.com>
 <Y1wCqAzJwvz4s8OR@google.com>
 <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
 <Y1xOvenzUxFIS0iz@google.com>
 <CALMp9eT9S4_k9cFR26idssjV+Yz4VH23hXA10PVTGJwNALKeWw@mail.gmail.com>
 <Y1xbINshcICWxxfa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y1xbINshcICWxxfa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/29/22 00:43, Sean Christopherson wrote:
>>> Checking 'dat' doesn't restrict counter 0, it skips printing if the guest (or host)
>>> is writing '0', e.g. it would also skip the case you encountered where the host is
>>> blindly "restoring" unused MSRs.
>> The VMM is only blind because KVM_GET_MSR_INDEX_LIST poked it in the
>> eye. It would be nice to have an API that the VMM could query for the
>> list of supported MSRs.
> That should be a fairly easy bug fix, kvm_init_msr_list() can and should omit PMU
> MSRs if enable_pmu==false.

Aaron, are you going to send a patch for this?

Thanks,

Paolo

