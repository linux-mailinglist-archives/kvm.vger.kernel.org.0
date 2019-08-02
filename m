Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DA77F027
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 11:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfHBJOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 05:14:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38606 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfHBJOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 05:14:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so76393554wrr.5
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 02:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qip0/4niVe3t0eqLUXzaEsnThAuuUjr0Sl7TEveH/lY=;
        b=QY8HUJPMKBAaFGAvfEwoVT9DlbP0sioHyftTT3O+Nn5SkWWmPpFHQIJuKP6mBx2gB6
         F/d8CnpVKX1Py0qjI3hOkBAxWJvl0noyhygp0Rgo5ZZqJU4XVqqUS3hc9rypnr3n3ggz
         IhaXWSeabacfJsGGIHnp//wANg8Mmc1OlfeolksshDJEA2WB1IB3z6CmOTgtjL1yHL73
         LoXlKF7B/EudnfL2DeTbhW+xAGgb3Yknuhe+B5CpZxL8TX3NkSF8XVgLEuMm2LFPaRgQ
         Hc3xBs0wTd19eyONyDbgqvvoxuuBwvetw4kWvcg+zKQUt2NtPSsh6lb40Dz9xwUR6Oqu
         qY/A==
X-Gm-Message-State: APjAAAW04On3NAEdvlrUvWeDH4EHor8tWBRmpAyjuTLmF3wRTZlaDfWZ
        lPjRYU98mo+8Ga+M06aq44hafA==
X-Google-Smtp-Source: APXvYqzBUUchxm6j0ktdj9jreOdHWCW7hMz3Yz24xUQA2HVmbvwbX1hgS8nU0BDDul8xNizaVm6PxQ==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr1884801wrn.31.1564737282526;
        Fri, 02 Aug 2019 02:14:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id y6sm62931619wrp.12.2019.08.02.02.14.40
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:14:42 -0700 (PDT)
Subject: Re: [RFC PATCH v2 12/19] RISC-V: KVM: Implement stage2 page table
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
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-13-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <949b75ef-5ec6-cdfd-5d5d-5695f35bd20c@redhat.com>
Date:   Fri, 2 Aug 2019 11:14:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-13-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:48, Anup Patel wrote:
> +	hgatp |= (k->vmid.vmid << HGATP_VMID_SHIFT) & HGATP_VMID_MASK;

This should use READ_ONCE.

Paolo

> +	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;

