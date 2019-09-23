Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246BFBB2AA
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 13:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfIWLMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 07:12:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbfIWLMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 07:12:23 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B6C5C053B26
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 11:12:22 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id h6so4695682wrh.6
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 04:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxD2Y3WBGHkLvQqCAXXWzhnVRm7+WSVZkhBdGyUy/Zg=;
        b=T2gUNQVusNoBuX7erj9qaYqAkw0PLMm9hvhKyfwjpq/23ASox38TUocgZP+pKwMhfq
         8hO4FoSP8KYD28OxUfa6JAkDHe8glAz9T/F3Lhok6Pe7UVPovRODHPeTZU10+o0iGhwX
         IPURw+hgsbIoJFsdBhFiNaMwOcs7Fu9JrqAr33+Lyp3JNT8u1ABihBJfdXt9IUxqdxKN
         zSIACzTTAZLSXcJqIqgtc9N1+sRoTj/ZOzL/PMDGI4vjQ7wYaYIwGGz6DTEftVnsFcRR
         fBQbD+DU2o3Yj/uwTBgOwoCsR8azO1CBj2XEqzOYphly3pcv5GTXd62e3f4sGJXLq3nm
         BV5w==
X-Gm-Message-State: APjAAAVCOT9zhH+2FZK0V+vTfBTHV2vF6cOeCA3617D48pTtziVEXl9R
        4VRnBrDSkyjjkfEHKZH/6EbVLKooVhJ7m29CI/cZcuJszd9lMO+Vmii5p2rfvpUEpjrfnL3ngWQ
        Avp2kl5MvmJzP
X-Received: by 2002:adf:cc87:: with SMTP id p7mr20853216wrj.43.1569237141151;
        Mon, 23 Sep 2019 04:12:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMW44zhOI1DG3DXgqsJqxbWPiZJb1HLWTJc4XK+mxiK6jX2sDL9nFCMUqBJJ1EN+ViAcwPtQ==
X-Received: by 2002:adf:cc87:: with SMTP id p7mr20853197wrj.43.1569237140829;
        Mon, 23 Sep 2019 04:12:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id s12sm14065554wrn.90.2019.09.23.04.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 04:12:20 -0700 (PDT)
Subject: Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190904161245.111924-1-anup.patel@wdc.com>
 <20190904161245.111924-12-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c44ac8a-3fdc-b9dd-1815-06e86cb73047@redhat.com>
Date:   Mon, 23 Sep 2019 13:12:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904161245.111924-12-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/19 18:15, Anup Patel wrote:
> +	unsigned long guest_sstatus =
> +			vcpu->arch.guest_context.sstatus | SR_MXR;
> +	unsigned long guest_hstatus =
> +			vcpu->arch.guest_context.hstatus | HSTATUS_SPRV;
> +	unsigned long guest_vsstatus, old_stvec, tmp;
> +
> +	guest_sstatus = csr_swap(CSR_SSTATUS, guest_sstatus);
> +	old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
> +
> +	if (read_insn) {
> +		guest_vsstatus = csr_read_set(CSR_VSSTATUS, SR_MXR);

Is this needed?  IIUC SSTATUS.MXR encompasses a wider set of permissions:

  The HS-level MXR bit makes any executable page readable.  {\tt
  vsstatus}.MXR makes readable those pages marked executable at the VS
  translation level, but only if readable at the guest-physical
  translation level.

So it should be enough to set SSTATUS.MXR=1 I think.  But you also
shouldn't set SSTATUS.MXR=1 in the !read_insn case.

Also, you can drop the irq save/restore (which is already a save/restore
of SSTATUS) since you already write 0 to SSTATUS.SIE in your csr_swap.
Perhaps add a BUG_ON(guest_sstatus & SR_SIE) before the csr_swap?

> +		asm volatile ("\n"
> +			"csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
> +			"li %[tilen], 4\n"
> +			"li %[tscause], 0\n"
> +			"lhu %[val], (%[addr])\n"
> +			"andi %[tmp], %[val], 3\n"
> +			"addi %[tmp], %[tmp], -3\n"
> +			"bne %[tmp], zero, 2f\n"
> +			"lhu %[tmp], 2(%[addr])\n"
> +			"sll %[tmp], %[tmp], 16\n"
> +			"add %[val], %[val], %[tmp]\n"
> +			"2: csrw " STR(CSR_HSTATUS) ", %[hstatus]"
> +		: [hstatus] "+&r"(guest_hstatus), [val] "=&r" (val),
> +		  [tmp] "=&r" (tmp), [tilen] "+&r" (tilen),
> +		  [tscause] "+&r" (tscause)
> +		: [addr] "r" (addr));
> +		csr_write(CSR_VSSTATUS, guest_vsstatus);

> 
> +#ifndef CONFIG_RISCV_ISA_C
> +			"li %[tilen], 4\n"
> +#else
> +			"li %[tilen], 2\n"
> +#endif

Can you use an assembler directive to force using a non-compressed
format for ld and lw?  This would get rid of tilen, which is costing 6
bytes (if I did the RVC math right) in order to save two. :)

Paolo

> +			"li %[tscause], 0\n"
> +#ifdef CONFIG_64BIT
> +			"ld %[val], (%[addr])\n"
> +#else
> +			"lw %[val], (%[addr])\n"
> +#endif
