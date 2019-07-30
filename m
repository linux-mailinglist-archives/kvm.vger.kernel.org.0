Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C37A5D3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 12:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732505AbfG3KRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 06:17:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45962 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3KRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 06:17:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so65102091wre.12
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 03:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0BfXKRiEVxvU8bBbaJFcml0F4XwqkulSy5LoM8k5vnU=;
        b=iHGVZWBInxNRqZy5kybY7r3vO8Q5QXjcrUTMekEYhG1OvvFLugYHabszgwIQw+c0sB
         QDs4aIy9yY88GTRx6H8OHKCZk90cx6F86fKqKCYZ+W551htBih6bmdnPHCWS23fdTR17
         xYxMNmk9GrhnRzXJHbtylSPiOeQwNyI7ivHdd5pyWGxFn1CSNNaL4ZT73RzFPp1kXdy7
         KvvrPWYRZcvsq0a3SFBMXoMrBAohr5XuCcDbMnAzc1b/aYlaq/yrM4qXMhDjHnWIULC2
         sHzQQzKZ1wQZfECfBs0EiLXrJ2WrWC2Q4+Uzl8hbnTtFcZHAgU8WhBgLZs6Zul2b+AK3
         cvdg==
X-Gm-Message-State: APjAAAXugIf8OuzU9rW4I/DYPazO97pdbL4bRJRBD15HvuYYYQ3b7o9J
        Gdboga53NindbvjgUrPP3M4u8w==
X-Google-Smtp-Source: APXvYqy6/dowCLGeT9RriCZ015qAZZF2PPTjzlMgI9dPdoZanSSBKVmGsIjx7EURe6YAtK3Npnanuw==
X-Received: by 2002:a5d:4041:: with SMTP id w1mr115756381wrp.199.1564481819511;
        Tue, 30 Jul 2019 03:16:59 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s15sm46966792wrw.21.2019.07.30.03.16.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 03:16:58 -0700 (PDT)
Subject: Re: [RFC PATCH 04/16] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
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
 <20190729115544.17895-5-anup.patel@wdc.com>
 <ade614ae-fcfe-35f2-0519-1df71d035bcd@redhat.com>
Message-ID: <2de10efc-56f8-ff47-ed69-7e471a099c80@redhat.com>
Date:   Tue, 30 Jul 2019 12:16:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ade614ae-fcfe-35f2-0519-1df71d035bcd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 10:48, Paolo Bonzini wrote:
> On 29/07/19 13:56, Anup Patel wrote:
>> +	cntx->hstatus |= HSTATUS_SP2V;
>> +	cntx->hstatus |= HSTATUS_SP2P;
> IIUC, cntx->hstatus's SP2P bit contains the guest's sstatus.SPP bit?

Nevermind, that was also a bit confused.  The guest's sstatus.SPP is in
vsstatus.  The pseudocode for V-mode switch is

SRET:
  V = hstatus.SPV (1)
  MODE = sstatus.SPP
  hstatus.SPV = hstatus.SP2V
  sstatus.SPP = hstatus.SP2P
  hstatus.SP2V = 0
  hstatus.SP2P = 0
  ...

trap:
  hstatus.SP2V = hstatus.SPV
  hstatus.SP2P = sstatus.SPP
  hstatus.SPV = V (1)
  sstatus.SPP = MODE
  V = 0
  MODE = 1

so:

1) indeed we need SP2V=SPV=1 when entering guest mode

2) sstatus.SPP contains the guest mode

3) SP2P doesn't really matter for KVM since it never goes to VS-mode
from an interrupt handler, so if my reasoning is correct I'd leave it
clear, but I guess it's up to you whether to set it or not.

Paolo

> I suggest adding a comment here, and again providing a ONE_REG interface
> to sstatus so that the ABI is final before RISC-V KVM is merged.
> 
> What happens if the guest executes SRET?  Is that EXC_SYSCALL in hedeleg?
> 
> (BTW the name of SP2V and SP2P is horrible, I think HPV/HPP or HSPV/HSPP
> would have been clearer, but that's not your fault).

