Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7037A6C3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfG3LUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:20:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33571 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbfG3LUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:20:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so45082264wme.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dU6DC0DBnzponZWFwxW0e6zjqYJ2z/TxlXP6MPH2kzU=;
        b=alASPX1Oivc60IRRnT4S9ugA4Py8OMhfyffBncjtngv+nN4nwiyzHT1thIbPSFhVgc
         6cgum3wwyYeKztwBJdXyfDT6x3rJVm9jO6wucruyiFiTBjd2igY5zYHjmr9WRrRAO6vT
         9MQYXV2RxRnx1mU5ZZP6RN+8WBlZ/rKYKa0o2nTBp9GQQyaVKxRmxkR8lmknPqlRH352
         JWOuYcbpcbR9c9QRxDr6Kl6Xip4dOKivHgmTm+J/C3Jwp2WEEJn3NQOeIYo4biw7w4nN
         +gt0ARRIqG/XKBb3nlZzhc5LIuQJdCaPKS3qD7wiYITmefVSUrfGnHAnft6044kJ5CYS
         OLgA==
X-Gm-Message-State: APjAAAWYvV1ZZYebKt+xPYg/1ArWVJIF12fCrHO8ueY0jQ4peo7Xetgh
        P9IL30xF09+B6RZNDZ8KMEzmig==
X-Google-Smtp-Source: APXvYqxGPEGFqFhh+SybAHgvqyZjBla5wxFfR6C1Wpq433TyWcQ3KrXJLcUDIP/E7F7OQac0mNBfoA==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr107521wmg.135.1564485615636;
        Tue, 30 Jul 2019 04:20:15 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 18sm54002868wmg.43.2019.07.30.04.20.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:20:15 -0700 (PDT)
Subject: Re: [RFC PATCH 08/16] RISC-V: KVM: Handle MMIO exits for VCPU
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
 <20190729115544.17895-9-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05d41219-6c0c-8851-dab6-24f9c76aed57@redhat.com>
Date:   Tue, 30 Jul 2019 13:20:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-9-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
> +static ulong get_insn(struct kvm_vcpu *vcpu)
> +{
> +	ulong __sepc = vcpu->arch.guest_context.sepc;
> +	ulong __hstatus, __sstatus, __vsstatus;
> +#ifdef CONFIG_RISCV_ISA_C
> +	ulong rvc_mask = 3, tmp;
> +#endif
> +	ulong flags, val;
> +
> +	local_irq_save(flags);
> +
> +	__vsstatus = csr_read(CSR_VSSTATUS);
> +	__sstatus = csr_read(CSR_SSTATUS);
> +	__hstatus = csr_read(CSR_HSTATUS);
> +
> +	csr_write(CSR_VSSTATUS, __vsstatus | SR_MXR);
> +	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus | SR_MXR);
> +	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
> +
> +#ifndef CONFIG_RISCV_ISA_C
> +	asm ("\n"
> +#ifdef CONFIG_64BIT
> +		STR(LWU) " %[insn], (%[addr])\n"
> +#else
> +		STR(LW) " %[insn], (%[addr])\n"
> +#endif
> +		: [insn] "=&r" (val) : [addr] "r" (__sepc));
> +#else
> +	asm ("and %[tmp], %[addr], 2\n"
> +		"bnez %[tmp], 1f\n"
> +#ifdef CONFIG_64BIT
> +		STR(LWU) " %[insn], (%[addr])\n"
> +#else
> +		STR(LW) " %[insn], (%[addr])\n"
> +#endif
> +		"and %[tmp], %[insn], %[rvc_mask]\n"
> +		"beq %[tmp], %[rvc_mask], 2f\n"
> +		"sll %[insn], %[insn], %[xlen_minus_16]\n"
> +		"srl %[insn], %[insn], %[xlen_minus_16]\n"
> +		"j 2f\n"
> +		"1:\n"
> +		"lhu %[insn], (%[addr])\n"
> +		"and %[tmp], %[insn], %[rvc_mask]\n"
> +		"bne %[tmp], %[rvc_mask], 2f\n"
> +		"lhu %[tmp], 2(%[addr])\n"
> +		"sll %[tmp], %[tmp], 16\n"
> +		"add %[insn], %[insn], %[tmp]\n"
> +		"2:"
> +	: [vsstatus] "+&r" (__vsstatus), [insn] "=&r" (val),
> +	  [tmp] "=&r" (tmp)
> +	: [addr] "r" (__sepc), [rvc_mask] "r" (rvc_mask),
> +	  [xlen_minus_16] "i" (__riscv_xlen - 16));
> +#endif
> +
> +	csr_write(CSR_HSTATUS, __hstatus);
> +	csr_write(CSR_SSTATUS, __sstatus);
> +	csr_write(CSR_VSSTATUS, __vsstatus);
> +
> +	local_irq_restore(flags);
> +
> +	return val;
> +}
> +

This also needs fixups for exceptions, because the guest can race
against the host and modify its page tables concurrently with the
vmexit.  (How effective this is, of course, depends on how the TLB is
implemented in hardware, but you need to do the safe thing anyway).

Paolo
