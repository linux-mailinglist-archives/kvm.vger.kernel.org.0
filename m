Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573552FA90A
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405520AbhARS1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:27:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393683AbhARS1o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:27:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610994373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5tNgVARNvQCB0SJouIAYqEN8m6OYsaWxW5vbk1y2k0=;
        b=EH2vK0Fbaf7bWnYR919g8PTvBpqEzrZbaCIkE5RQuwp/H7nrnKVNj8SnPw9IWrZeIFO50o
        J+qrMZl5WJqjb2csBF7qiz9GEkum274+mXgliTgwVaA6iCq5Kp3Y7BcTG/BMyG3y2/5EbP
        kcTRG+vxumZSSb5i/rukRddzLlKvrqw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-hkE01USVNumhKuk3y34QWA-1; Mon, 18 Jan 2021 13:26:12 -0500
X-MC-Unique: hkE01USVNumhKuk3y34QWA-1
Received: by mail-wr1-f72.google.com with SMTP id r8so8692101wro.22
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:26:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z5tNgVARNvQCB0SJouIAYqEN8m6OYsaWxW5vbk1y2k0=;
        b=lMYJKlq3IbLVYNtiQXtzvSpF0hOpszbyuBN4jFKDB9btTd7VRnE4watd5uZEvdXOI2
         bleAuCqyc1Xz/jfFBivJnz9QWIVlkj5+YwMx9yAQnwkox7ciPVyztGjDVtwFokvvGWBZ
         zvYHzkYf0ZTAU/ICuKydG7H88h/3l4P5x+2TXsiGO2OtIvwo267f5AAE+H6fKFT2huHK
         QYVhoE6wiOgB+6g72SlXCwwsDlspgNE86cxxPSsOABF1XLVLhQ/Q+scLfP81CwubmcM7
         S6QmYByYwvt3VXreCSuHvwS/B7qqG3SHNRuebwmdQg258CqnX8ct6H2R6v+pp39G6vJw
         QCzA==
X-Gm-Message-State: AOAM533fm11Cd61WNzk/wXWeMRI/i6iUThDRmBjFbu9J9SKBsATjQjTm
        gbi0h5Uit6ZwDbSyXs1RPtiwpmL4Mj7ZwaEhgIazrPVwawVM8rt1PGzQBYTDtAc4SYnsNkOV/9N
        jrjs2qbQnHc6x
X-Received: by 2002:adf:fccb:: with SMTP id f11mr746717wrs.3.1610994371127;
        Mon, 18 Jan 2021 10:26:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw+GkRlOpn8qdAgG+r1ePLj7djM6dNvjijlBFLTRGUtIq1pAUqz9pcNXC44g/iM+5qMvdIrDA==
X-Received: by 2002:adf:fccb:: with SMTP id f11mr746695wrs.3.1610994370933;
        Mon, 18 Jan 2021 10:26:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c6sm34500990wrh.7.2021.01.18.10.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:26:10 -0800 (PST)
Subject: Re: [PATCH 0/3] x86/KVM/VMX: Introduce and use try_cmpxchg64()
To:     Uros Bizjak <ubizjak@gmail.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20201215182805.53913-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05bc4cc2-1c1b-ebb8-39e3-9eaef7f0df4f@redhat.com>
Date:   Mon, 18 Jan 2021 19:26:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201215182805.53913-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/12/20 19:28, Uros Bizjak wrote:
> This patch series introduces try_cmpxchg64() atomic locking function.
> 
> try_cmpxchg64() provides the same interface for 64 bit and 32 bit targets,
> emits CMPXCHGQ for 64 bit targets and CMPXCHG8B for 32 bit targets,
> and provides appropriate fallbacks when CMPXCHG8B is unavailable.
> 
> try_cmpxchg64() reuses flags from CMPXCHGQ/CMPXCHG8B instructions and
> avoids unneeded CMP for 64 bit targets or XOR/XOR/OR sequence for
> 32 bit targets.
> 
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> 
> Uros Bizjak (3):
>    asm-generic/atomic: Add try_cmpxchg64() instrumentation
>    locking/atomic/x86: Introduce arch_try_cmpxchg64()
>    KVM/VMX: Use try_cmpxchg64() in posted_intr.c
> 
>   arch/x86/include/asm/cmpxchg_32.h         | 62 +++++++++++++++++++----
>   arch/x86/include/asm/cmpxchg_64.h         |  6 +++
>   arch/x86/kvm/vmx/posted_intr.c            |  9 ++--
>   include/asm-generic/atomic-instrumented.h | 46 ++++++++++++++++-
>   scripts/atomic/gen-atomic-instrumented.sh |  2 +-
>   5 files changed, 108 insertions(+), 17 deletions(-)
> 

Queued, thanks.

Paolo

