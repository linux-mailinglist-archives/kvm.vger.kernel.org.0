Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56587EF4D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 10:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404188AbfHBIaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 04:30:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37183 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfHBIaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 04:30:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so51185192wrr.4
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 01:30:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MjSLRhTHy/z+LM8sRLnyEruabbpzZhCsOii1dxVU9Y=;
        b=ABjjmBa63ORx5S85nQTU3ArYFnduFCEPXOIcUyf85QtNLRegddmzQe+zhTlWqIEKBw
         +ssZAR7i1HHBcEa6y8e2/7DZf30iNzpUtzbsYJ4iEvU3cZGIuR36N8E0HDXqawwrUvQT
         ao785ZMHt4k+7N92p9JsH+eOeZiMKlN5rXciTIueCtcqP8DX5gZvYxeuIof5D5VpB+YO
         zCGLh4ztQzWeVVlcyy0I0gku7ZnxzRfXFgVPxlY4TxM6ypp49ErrrswShEL0zQDnARGH
         DniLzsWnkHA8Z0cY0o5prbZNcjEdLUy+dPlMqHCZ4KTTcfOPFPUFXbO41SjgtMUUmWdR
         4jJA==
X-Gm-Message-State: APjAAAVYWM0W0468+ATF3J2V8qVP/VBKMz+eXQR0ucDRWWS9PjQ8cBPO
        0upcWZYR+7LVZ1vLTUgAVM/Usg==
X-Google-Smtp-Source: APXvYqxQ8H0EwfjmiYP1/SUacCSArAMVaY+7Hsw2aimu6rkqpcHBrjydXWxpNn5htwW5YM1MsKxGqQ==
X-Received: by 2002:adf:dcc6:: with SMTP id x6mr117116586wrm.322.1564734611723;
        Fri, 02 Aug 2019 01:30:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id b8sm99851723wmh.46.2019.08.02.01.30.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 01:30:11 -0700 (PDT)
Subject: Re: [RFC PATCH v2 08/19] RISC-V: KVM: Implement VCPU world-switch
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
 <20190802074620.115029-9-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <72d8efbf-ec62-ab1e-68bf-e0c5f0bc256e@redhat.com>
Date:   Fri, 2 Aug 2019 10:30:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-9-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:47, Anup Patel wrote:
> +	/* Save Host SSTATUS, HSTATUS, SCRATCH and STVEC */
> +	csrr	t0, CSR_SSTATUS
> +	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
> +	csrr	t1, CSR_HSTATUS
> +	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
> +	csrr	t2, CSR_SSCRATCH
> +	REG_S	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
> +	csrr	t3, CSR_STVEC
> +	REG_S	t3, (KVM_ARCH_HOST_STVEC)(a0)
> +

A possible optimization: if these cannot change while Linux runs (I am
thinking especially of STVEC and HSTATUS, but perhaps SSCRATCH can be
saved on kvm_arch_vcpu_load too) you can avoid the csrr and store.

Paolo
