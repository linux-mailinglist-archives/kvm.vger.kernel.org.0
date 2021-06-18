Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3273AC8C7
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 12:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhFRK3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 06:29:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhFRK3l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 06:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624012052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Z2CJ9V34y2pAE384/ANEr0yGKWrtOTaGvsqCpVRS+U=;
        b=CVBuJ4scA8FL49OKv6xID43XZuJf1ezm4VEWdMRqBng1vmmHuR+XaRzKMNWH1zL75Pvj7F
        bxuvkA/M7bNqCdXo2DpVcyp4ICkhdSdNpc2ljOZCZck8eUmaNwkYHCLCEzElXfPcqHgIFM
        zJW7KwPxmKYzi7p75aKz354QHE8YEAQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-LTmpQvJ3N-uGaccn7DNnng-1; Fri, 18 Jun 2021 06:27:30 -0400
X-MC-Unique: LTmpQvJ3N-uGaccn7DNnng-1
Received: by mail-ed1-f70.google.com with SMTP id f12-20020a056402150cb029038fdcfb6ea2so1475648edw.14
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 03:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Z2CJ9V34y2pAE384/ANEr0yGKWrtOTaGvsqCpVRS+U=;
        b=bA92SBwXtaoOeJkYr0ys5FdI54A/2p5+FTgOFId3YhO+RKzAmSPCu4C6DjsVexGggS
         BA+3CgW+aW6mydfyhOqaGEy9CyN1jVfFREIv9MHGkh8d4K5nJCTgESRMly703zn+dNx+
         NgRMHFypRmsyiWtQWY6Tiwl5J2AcamxRZMG+srKDRjtL/JqpI1DfD8hxJsWSth5vAd5J
         Wc89ZTVWDfTgFfeK97ZEQcuwGHezrRnuKdcRU0vqj1HhCh6gVVkcF3FeYle1oJjPz2in
         +eKDyPotrLTxp3siwP8kpr7ukV4rcaM70CWYaEi2Ps31YoHYzeJFqRBUZd33SsEkBv+G
         bttQ==
X-Gm-Message-State: AOAM530etCf3VzljylWs4fiL8uM/3G2kgN2shqcHc7srjkEbDK0Ftzfh
        imFkkvkEWm86CYEb2V028RESWvjCl49NdP11LwUOFtSg/+bCp46I7dw58Vy2LIcar7nlQJVzaGo
        YGnhDjeyoqHOv
X-Received: by 2002:a17:906:3057:: with SMTP id d23mr10217661ejd.131.1624012049503;
        Fri, 18 Jun 2021 03:27:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXkfkJJzO9ow7Rx03C2rZ0ep5F363V1TXI14icaVSd94bulhKHWZRzimP1DHsWrjdYztsWog==
X-Received: by 2002:a17:906:3057:: with SMTP id d23mr10217649ejd.131.1624012049358;
        Fri, 18 Jun 2021 03:27:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm848630ejk.97.2021.06.18.03.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 03:27:28 -0700 (PDT)
Subject: Re: [PATCH 3/4] KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210615164535.2146172-1-seanjc@google.com>
 <20210615164535.2146172-4-seanjc@google.com>
 <CALMp9eSkVaDfCJwW1eds=7H7yn2pKJPKoFVpc1GQcEqGD5S0Dg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6ea2385a-9abe-82b8-6c57-8dc3aac824b2@redhat.com>
Date:   Fri, 18 Jun 2021 12:27:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eSkVaDfCJwW1eds=7H7yn2pKJPKoFVpc1GQcEqGD5S0Dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/21 00:39, Jim Mattson wrote:
>>
>>          rdmsrl_safe(MSR_EFER, &host_efer);
>> +       if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
>> +                        !(host_efer & EFER_NX)))
>> +               return -EIO;
> Input/output error? Is that really the most appropriate error here?
> Why not, say, -ENOTSUP?
> 
> I'm sure there's some arcane convention here that I'm not privy to.:-)
> 
> Reviewed-by: Jim Mattson<jmattson@google.com>
> 

EIO often means "how the heck did we get here?" or "look in dmesg to get 
more info", both of which I think are appropriate after a WARN.

Paolo

