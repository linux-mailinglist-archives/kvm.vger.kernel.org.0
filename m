Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E112A7A486
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbfG3JgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:36:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44217 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730880AbfG3Jf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:35:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so64964207wrf.11
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LfBe8BIZguRGaVcqxBIUd21ri7wgmIbA7EXh3G0N3Hw=;
        b=ZZxhrWcBAqOa9NczKjDuFzHoKu9y2vyavzG5htQpcMjwFofdW/ab6M2O4trwhsUl8C
         Wsk9A4ujwqPje3E+3caw9bhq7BFe7yod58cXDeTV79VoKH/qk32/QDs2O03J6XB2irHb
         mdiwzu5ZTvG8OZ2rUVK7mAW8MRkPJNZewTMQONzzSPO5o1pkN14LywGdi5nxUtizEyg5
         E3MYOPNWXTJQzqL+7KEQ+6VOrc0NKJ6GWLCTD84yiv0nOs3AtErzAobKodrTIvEOYi8E
         HXpFGjFwVm5xbc/27hbZlXXWzYwP4cKSkj60rooaC6Y9FKKobFgEQtLHHYzlsQn4WPsK
         HYGQ==
X-Gm-Message-State: APjAAAVuj5nXyYHj8fmATXkjJpjnagEierGuy4HcBdPCov7HKGAbtyA+
        /BNS7fXwlJf647LMB15cYDYLQA==
X-Google-Smtp-Source: APXvYqwq3Hft9cpeFWfJQOdIrZK1BvEf6TQWeB6zhzE98jxFZtCFfEZfO6QPRJKZp8CB+tTOovDs0w==
X-Received: by 2002:a5d:4f01:: with SMTP id c1mr45610035wru.43.1564479356485;
        Tue, 30 Jul 2019 02:35:56 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v204sm67712311wma.20.2019.07.30.02.35.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:35:55 -0700 (PDT)
Subject: Re: [RFC PATCH 06/16] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
From:   Paolo Bonzini <pbonzini@redhat.com>
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
 <20190729115544.17895-7-anup.patel@wdc.com>
 <3caa5b31-f5ed-98cd-2bdf-88d8cb837919@redhat.com>
Message-ID: <536673cd-3b84-4e56-6042-de73a536653f@redhat.com>
Date:   Tue, 30 Jul 2019 11:35:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3caa5b31-f5ed-98cd-2bdf-88d8cb837919@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 10:43, Paolo Bonzini wrote:
> On 29/07/19 13:56, Anup Patel wrote:
>> The PC register represents program counter whereas the MODE
>> register represent VCPU privilege mode (i.e. S/U-mode).
>>
> Is there any reason to include this pseudo-register instead of allowing
> SSTATUS access directly in this patch (and perhaps also SEPC)?

Nevermind, I was confused - the current MODE is indeed not accessible as
a "real" CSR in RISC-V.

Still, I would prefer all the VS CSRs to be accessible via the get/set
reg ioctls.

Paolo
