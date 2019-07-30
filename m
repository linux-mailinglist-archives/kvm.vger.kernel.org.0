Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FFF7A385
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfG3JAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:00:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44698 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbfG3JAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:00:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so64833009wrf.11
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OXM02iYz2IRdbVYTSZ1WZe77JTnwpAeIa8FaghuZo4c=;
        b=L3+C1d0T9qFt7gLOnQ4GIoB5cgBGDgl7rMqNUBn78VprwhQV6L7fjPX4AUJ9qYeiao
         waOl56LRK/f+IlYAuWNGFX6w/2eoPDXue5c1ODNTuJu6D5i/M8vQ4lVvr9nBYoEWu7UF
         bX2hjcx41sGMqblN+0Yww2JLvYflpJpt+gqlFpA/V2MCF5UAX9tqeF9ccaKPIP43NBIj
         cOUJ00vJ6DE3QhCAPkcOaf9DdaxPWiAywgKGL9h/xi1JFMThB2Jl26/Z76tTU4tCoWbN
         QUR7pjYn4LUYqgD7IgdVe4FZ3qEjULBM5lR9zyuDeK3YSrJlmHoJ4AxP93BZHbngcy7p
         g6SA==
X-Gm-Message-State: APjAAAVsqBbb5G/JkVhUGfXpLngEjfL2xXAiOS0KAYdIy+PmG5Aqnevz
        zqZ0MElRObWJ4Captq0i9VC92g==
X-Google-Smtp-Source: APXvYqxVuoAVEo5L0whFkRYU53jDf4dvvaMxhfAYJm0ZVclfasplU5lwtvKcELxa3jmCorypxW7/kw==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr126870879wrn.31.1564477209192;
        Tue, 30 Jul 2019 02:00:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id y6sm56247471wrp.12.2019.07.30.02.00.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:00:08 -0700 (PDT)
Subject: Re: [RFC PATCH 11/16] RISC-V: KVM: Implement stage2 page table
 programming
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-12-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6ebde80e-e8a9-6b7b-52ea-656b9a9e5e5b@redhat.com>
Date:   Tue, 30 Jul 2019 11:00:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-12-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
> This patch implements all required functions for programming
> the stage2 page table for each Guest/VM.
> 
> At high-level, the flow of stage2 related functions is similar
> from KVM ARM/ARM64 implementation but the stage2 page table
> format is quite different for KVM RISC-V.

FWIW I very much prefer KVM x86's recursive implementation of the MMU to
the hardcoding of pgd/pmd/pte.  I am not asking you to rewrite it, but
I'll mention it because I noticed that you do not support 48-bit guest
physical addresses.

Paolo
