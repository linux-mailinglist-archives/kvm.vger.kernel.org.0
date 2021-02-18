Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A059831E9C8
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhBRM2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 07:28:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhBRJ7b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 04:59:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613642280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOYUaALkK3IIo+lp//wp5j/HradrMHBgGPIHa0GEm6A=;
        b=XmJz5PRdGAFLgVCglfsHMlHRPSBu/FtHZ0kTOcoR0W6kbNdDyU5Hy3DoodIFM1CFLV6dbm
        RMfLZUILtEOX6xNLXL4MoCC2JdeYWsDBa2el0E32AfU0yUMbuyiJyI8Kpsl7uRjSYFHR4f
        6UTsL2+GG8MVTZLmqqtyUbjBUb7BXXk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-ba79Y-GROhSt79Csqtt8bQ-1; Thu, 18 Feb 2021 04:45:48 -0500
X-MC-Unique: ba79Y-GROhSt79Csqtt8bQ-1
Received: by mail-wr1-f69.google.com with SMTP id e29so572089wra.12
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 01:45:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOYUaALkK3IIo+lp//wp5j/HradrMHBgGPIHa0GEm6A=;
        b=HD3dt4G7sz7zS8G358XLgmS71A8Yu68OYGwyYFCpB3qREg2T/thjiAl37soKBKafXE
         +k6pRNe3F/yjTG/lkWP4OpLVdeEGDbx6O4SnIqqiOu5RljKQ7Rv2AikMXDsd6HPoTy7v
         n+aVxzayGD4r2WB/5WNpIlSxWV8EnEHJ8LHLhLI4A95uB/RnrBJx/WR7HMzSmdhE/VPj
         8Lz0Aw7BUO6ys6P3w5tqrmOvUYcAav0ExgPrsRJOmB6XTpBQpoBWaccgvENSPOrr2u+1
         4DNmcSiRnI6m0DkeqhM4GAbx7OrOchRsXcRqjZnIJh+ECiE+7sXkSJ/cPSn0rfgPAJU8
         hBjw==
X-Gm-Message-State: AOAM530No2XiUAS1aTgSOFOupxEBJOXbIijGKfCYI5ZNMrrLBtKClGnN
        bD+uusFe8Ba98lbnKQu5CJhGqBkaOT5lsNWC8ylYtOh5dXLiP5i7MZtSTh0gSLPOwWwMGgMMIMs
        kvhGrDoej4B+4
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr3499966wrz.343.1613641547436;
        Thu, 18 Feb 2021 01:45:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwak94cWMx7rdkTVuZHKmnNzTDybceXV4ybLRoo/svCRcFVxO+Q6nyQuWw8qHLmH3SkpRo6mA==
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr3499943wrz.343.1613641547281;
        Thu, 18 Feb 2021 01:45:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 36sm8508195wrj.97.2021.02.18.01.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 01:45:45 -0800 (PST)
Subject: Re: [PATCH 4/7] KVM: nVMX: move inject_page_fault tweak to
 .complete_mmu_init
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-5-mlevitsk@redhat.com> <YC1ShhSZ+6ST63nZ@google.com>
 <1b9cb222508b9b16b27075745d902e4a40cf9a25.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eaa92c4a-79c1-8a12-9742-1c9007b63e23@redhat.com>
Date:   Thu, 18 Feb 2021 10:45:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1b9cb222508b9b16b27075745d902e4a40cf9a25.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/21 19:43, Maxim Levitsky wrote:
> 1. npt/ept disabled in the host. In this case we have a single shadowing
> and a nested hypervisor has to do its own shadowing on top of it.
> In this case the MMU itself has to generate page faults (they are a result
> of hardware page faults, but are completely different), and in case
> of nesting these page faults have to be sometimes injected as VM exits.
> 
> [...] Also if the emulator injects the page fault, then indeed I think the
> bug will happen.

But in both cases you (ought to) get an injected exception which then 
becomes a page fault vmexit at next check_nested_events.  That's the 
part that we are all collectively missing.

Paolo

