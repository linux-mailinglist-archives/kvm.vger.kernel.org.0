Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FCBDF434
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfJUR1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 13:27:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJUR1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 13:27:15 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 827DB369AC
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 17:27:15 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id v7so5765130wrf.4
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 10:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o4xeYtdnmb8NdCuVzBbUa7fVvwoUzqqrPHBPV9zqYVk=;
        b=Nv8989Pta92h996X012FfW1CSvRGHB1C9Bfi2tMz1osstddQ2E0jF0VaAQN3i6ULyP
         L6KGhMN6FelJu+9iL3davfefhAs+/DAfvuXz/ItbDYk4DnRchJaEhgzkqy3oqvkdMDpB
         CP9C13LJtcmfgkjyRrZsmqyes0HbRbZiTGwr9BDdqu7P5tbIvkxAe6qb55iiu6YIh8Aj
         Q7qQy69APb/miARyBjGgw8wid5I6tzmFfwHN8MEY7Nc64sMo1eUuh2Trf9tFVrqiuVJw
         5Wubx9lOapEGP/sXTA19iW/Yudp8CCtx+q5wRZ7d5AmR5eZN2Y50p6X82yWHGljjP/YF
         t0RA==
X-Gm-Message-State: APjAAAXRHyfq81gwitAEL9fF4kaq6waGJx/t/Cb1SOx7Y0tovlkQfoWJ
        fuX1cnHikbJxoMm8lX5KVCA21oR9A37xQa/nyd07aJeIyiJa2bi8+YmTp2yfrHn+yq6GG+H8YyS
        c3uhangKAWTj8
X-Received: by 2002:a1c:a556:: with SMTP id o83mr21599600wme.0.1571678834215;
        Mon, 21 Oct 2019 10:27:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzipaLfA3kUVnqB/RRSN8weGdEW5X/KaWu7Reo2wlZT9NrXTpU395PLRqKuErbW+MMVjo6+Dw==
X-Received: by 2002:a1c:a556:: with SMTP id o83mr21599580wme.0.1571678833914;
        Mon, 21 Oct 2019 10:27:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id t8sm15118590wrx.76.2019.10.21.10.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 10:27:13 -0700 (PDT)
Subject: Re: [PATCH v9 20/22] RISC-V: KVM: Fix race-condition in
 kvm_riscv_vcpu_sync_interrupts()
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
References: <20191016160649.24622-1-anup.patel@wdc.com>
 <20191016160649.24622-21-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1d2e9514-235e-183e-b4fc-d3becc9ce471@redhat.com>
Date:   Mon, 21 Oct 2019 19:27:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016160649.24622-21-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 18:12, Anup Patel wrote:
> +	/* Read current VSIP and VSIE CSRs */
> +	vsip = csr_read(CSR_VSIP);
> +	csr->vsie = csr_read(CSR_VSIE);
> +
> +	/* Sync-up VSIP.SSIP bit changes does by Guest */
> +	if ((csr->vsip ^ vsip) & (1UL << IRQ_S_SOFT)) {
> +		if (!test_and_set_bit(IRQ_S_SOFT, &v->irqs_pending_mask)) {
> +			if (vsip & (1UL << IRQ_S_SOFT))
> +				set_bit(IRQ_S_SOFT, &v->irqs_pending);
> +			else
> +				clear_bit(IRQ_S_SOFT, &v->irqs_pending);
> +		}

Looks good, but I wonder if this could just be "csr->vsip =
csr_read(CSR_VSIP)", which will be fixed up by flush_interrupts on the
next entry.

Paolo
