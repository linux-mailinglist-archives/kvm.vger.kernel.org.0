Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437447EFB3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 10:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbfHBI7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 04:59:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55941 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbfHBI7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 04:59:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so67167747wmj.5
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 01:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JgbbmoU8mRwQDt1oX8O7FGI/YFBQIrkxghclZVXxh9E=;
        b=R3WYTppF95LCFww3hEpN9GkiIQgfVuyFb5S48cM6PwbDgaylLb+aA760T+pbKNIA7g
         hGePBLfh+Tjiln+IDz5O4zpWNegDq5yT+V6M3PGyAwdurw9dVJUNpjI5ZrDGAoJIPEKQ
         Hhrw5IHQNGGg2QeAfkZYI3A8uMBoaa3sAQTeTyFSVeRimlpLYaIrgFqQtMiiutnBKQlk
         c+imQPsyo1g3Nsx04PsCepn+7mqiUWXhUqVgAfD9YcBAAemyHoSCrylq0ha2lM7MSR7K
         FQLWGb409d925+IphqlTSSkiMRzN5xN7z0HBRjcWdMVA3da5UPZRq1rxGyHYlwKsiumf
         oY5g==
X-Gm-Message-State: APjAAAUYLBiK4UkdceYjNFIldKSijYFwFS1S7Z5Ak3mUgC09xWlzyBAl
        y0gO7OJ+DZZVeGmGKxe4wnRZ2A==
X-Google-Smtp-Source: APXvYqxJwRjyVgdn+EYXPUb8lVj+sHz60T4z7O9Y/MtbR/5gy1f516YgcK5v2luTrVMoSW/i85kDyA==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr3410562wma.68.1564736377101;
        Fri, 02 Aug 2019 01:59:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id f1sm50649557wml.28.2019.08.02.01.59.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 01:59:36 -0700 (PDT)
Subject: Re: [RFC PATCH v2 08/19] RISC-V: KVM: Implement VCPU world-switch
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-9-anup.patel@wdc.com>
 <72d8efbf-ec62-ab1e-68bf-e0c5f0bc256e@redhat.com>
 <CAAhSdy2_ZsnT7gSKb624r9wzuJSx+1TnKxgW6srtqvXV1Ri9Aw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f9dee99d-f536-e351-f637-b5098d53be22@redhat.com>
Date:   Fri, 2 Aug 2019 10:59:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy2_ZsnT7gSKb624r9wzuJSx+1TnKxgW6srtqvXV1Ri9Aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 10:43, Anup Patel wrote:
>> A possible optimization: if these cannot change while Linux runs (I am
>> thinking especially of STVEC and HSTATUS, but perhaps SSCRATCH can be
>> saved on kvm_arch_vcpu_load too) you can avoid the csrr and store.
> Actual exception vector of Host Linux is different so we switch STVEC
> every time.
> 
> HSTATUS.SPV is set whenever we come back from Guest world so
> while we are in in-kernel run loop with interrupts enabled we can get
> external interrupt and HSTATUS.SPV bit can affect SRET of interrupt
> handler. To handle this we switch HSTATUS every time.
> 
> The world switch code uses SSCRATCH to save vcpu->arch pointer
> which is later used on return path. Now, I did not want to restrict Host
> Linux from using SSCRATCH for some other purpose hence we
> switch SSCRATCH every time.

Right, I'm not saying not to save these registers.  I'm saying not to
read the host value on every world switch, instead load it in
hardware_enable (if it's the same for all physical CPUs) or
kvm_arch_vcpu_load (if it's different for every physical CPU).

IIUC Linux does not use SSCRATCH while in the kernel (it must be zero
while handling an exception, but handle_exception takes care of that).
I think it's okay if you make this assumption, but if you don't want to
make it, you can still save it in kvm_arch_vcpu_load rather than here
since you "own" the thread while in KVM_RUN.

Paolo
