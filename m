Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D583C38E887
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhEXOT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232685AbhEXOTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621865906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPw/5LHMKGLRM41ByxBD2gODEQe12CphnDx2DP+UUxM=;
        b=Qpx32zg010Yl3WLBCImXEjPu2FEhK9m0Dyj2TrudgMZ9e6CDclJrav6WFWnd0KQ2WJjBYe
        mRYCn9rsdtdyFcYWl2u8b7lbxk6TMbwtuXE59VMIgNYn81JKAUPruD6wO8Fh3DOMhK5Rv8
        AsuI50UM6i1Xn4Zjvi6+wDk+MUXT9Ys=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-pXvsvimJNTGgHFZEJ8EueQ-1; Mon, 24 May 2021 10:18:24 -0400
X-MC-Unique: pXvsvimJNTGgHFZEJ8EueQ-1
Received: by mail-ed1-f72.google.com with SMTP id n6-20020a0564020606b029038cdc241890so15630164edv.20
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BPw/5LHMKGLRM41ByxBD2gODEQe12CphnDx2DP+UUxM=;
        b=OS3oSXuTprMFgXXJ0Ur8MsxXab4JeimrMmauvDetXCFdl2JkGoF6WwznUMfBvjQjLq
         SNwB+V4HKNSkzcTRHpfbBMGucvLW2SX0y3RXCgya5S5PmXHu511oXsZwlmmTJXLSQN+e
         LiLhBvy9T/Xpgtxx+PPqjZyxEjvsaUjX+lG8M2UTqs5cNK9FUf2cApiu/kTohQ1ggHLr
         7r8sWuLDf3Bj/N8f3b0R4g0IgGzK/oMyETH7SPfS/eiepxVX2eX6SHtWUV67OEcDwswt
         vPjJzYxm/IcJ5IYAmi9cn6dlpRCMflt142ETdByWaxigy1kvWCJLR3PAmNxcwFkLnTex
         5rZw==
X-Gm-Message-State: AOAM532Up0E9BU2JVRyIMva2TpfG+7wyteUc+wQXqpJYKYHcz12jlAaH
        uUzyCl6i8x58zdJNnP+w0bh+H30/iuZGN4EpkWhPdE8hTIl7pzqHOHNuobaSSxxssO88wOQv+mV
        gny82vt2UU7k8
X-Received: by 2002:a17:906:7e55:: with SMTP id z21mr23962497ejr.225.1621865903286;
        Mon, 24 May 2021 07:18:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx45Uzx7QU999pULxjst2unJ84pDpHQLupsTGnJHZT9GFcGBcvJ2kHermICIR/DbnvBToGvRg==
X-Received: by 2002:a17:906:7e55:: with SMTP id z21mr23962474ejr.225.1621865903105;
        Mon, 24 May 2021 07:18:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f11sm7691938ejd.101.2021.05.24.07.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 07:18:22 -0700 (PDT)
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Introduce nested_evmcs_is_used()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-2-vkuznets@redhat.com>
 <115fcae7-0c88-4865-6494-bdf6fb672382@redhat.com>
 <87r1hw8br1.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <37a6d13d-58ae-65e1-75f9-681a40d819a1@redhat.com>
Date:   Mon, 24 May 2021 16:18:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87r1hw8br1.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 16:09, Vitaly Kuznetsov wrote:
> You mean we'll be using:
> 
> "hv_evmcs_ptr == 0" meaning "no evmcs" (like now)
> "hv_evmcs_ptr == -1" meaing "evmcs not yet mapped" (and
> nested_evmcs_is_used() will check for both '0' and '-1')
> "hv_evmcs_ptr == anything else" - eVMCS mapped.

I was thinking of:

hv_evmcs_ptr == -1 meaning no evmcs

hv_evmcs == NULL meaning "evmcs not yet mapped" (I think)

hv_evmcs != NULL meaning "evmcs mapped".

As usual with my suggestions, I'm not sure if this makes sense :) but if 
it does, the code should be nicer.

Paolo

