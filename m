Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A4A3B2C2E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 12:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhFXKQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 06:16:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232063AbhFXKQR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 06:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624529638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgeFYkU0pR1Q1xO1W6kYeH0XfpPQ577wwQcLewdoy9I=;
        b=b0fBbGzUviuQWfG53+goimeZRXTChoucFs+qI1i9RJR4XZyTa1ZGw8UqJzSyIcMkGTMFVg
        6VoaTSU+n5SwskP/dAJiEJGwagjVmCVvXn217lhglUDClZ7cXy2m4yIbxh9luqdTYwC7cW
        dr+e+S3qgEhuu9aB4i6O79C31zvuLZ0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-bM4SZh9VPyidYyYEAfs_zQ-1; Thu, 24 Jun 2021 06:13:56 -0400
X-MC-Unique: bM4SZh9VPyidYyYEAfs_zQ-1
Received: by mail-wr1-f69.google.com with SMTP id k3-20020a5d62830000b029011a69a4d069so2005511wru.21
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 03:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qgeFYkU0pR1Q1xO1W6kYeH0XfpPQ577wwQcLewdoy9I=;
        b=XviTpssk2vcuP8Vx2e9mGMDVw74ba7crnl1pfDK3FWlgiDI2P3+gEbObY5UsibAIXu
         KHDl2+YcJGmFHXFpLm0xAfGD0HcjRNqOQHmfYPk5sVotUHZFoeIAg/+KDGRx1Dnc4R3x
         w50MfxjnoOzPg+nLhnHvvUBawdQD0143ps0PMT+R1TnEM/rqNEslPhBS23QWT9PT7a6T
         r3OVw5y3tmPDde8/O/kKw7XcuKQcUcji63lk2cldu9GWvSQYOEurPMORjX9WUKva0d86
         H04a1WGf24F14D/hp2tXxLLuHIPIvM4+qVY4GI8cx1PqFrmrvqpoMnJaueNGlRi2JqjS
         7ajQ==
X-Gm-Message-State: AOAM530+fEcbv5/C1PLcoNhvOZ8J3nNexRTReVhOlkwMB+CldB8YKMXg
        qbs8CBAaHDKDBp9UVfTCt5OHbrYj1+LK41Wl+1zHGPdRJ5aekawl2q6r94leAx/0dFWHDjlQsnK
        uTKi8hlF0APcd
X-Received: by 2002:adf:e80c:: with SMTP id o12mr3526079wrm.425.1624529635766;
        Thu, 24 Jun 2021 03:13:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwystGI+L9gOrbELlIiJWJblqcplIdniKN++kkqVaKxE8NfJktozv1x7SoGv2eSTMa2UzUKpw==
X-Received: by 2002:adf:e80c:: with SMTP id o12mr3526053wrm.425.1624529635607;
        Thu, 24 Jun 2021 03:13:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q19sm8207562wmc.44.2021.06.24.03.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 03:13:55 -0700 (PDT)
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To:     Nicholas Piggin <npiggin@gmail.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
 <1624524331.zsin3qejl9.astroid@bobo.none>
 <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
 <1624528342.s2ezcyp90x.astroid@bobo.none>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbbd7334-5311-a7b4-5dec-8bc606f1d6c9@redhat.com>
Date:   Thu, 24 Jun 2021 12:13:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624528342.s2ezcyp90x.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 11:57, Nicholas Piggin wrote:
>> Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so
>> it's a good idea to move the short name to the common case and the ugly
>> kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not
>> sure there should be any kvm_pfn_page_unwrap in the end.
>
> If all callers were updated that is one thing, but from the changelog
> it sounds like that would not happen and there would be some gfn_to_pfn
> users left over.

In this patches there are, so yeah the plan is to always change the 
callers to the new way.

> But yes in the end you would either need to make gfn_to_pfn never return
> a page found via follow_pte, or change all callers to the new way. If
> the plan is for the latter then I guess that's fine.

