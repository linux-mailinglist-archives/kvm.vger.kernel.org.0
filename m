Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4BD7A446
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbfG3Jec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:34:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37263 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbfG3Jec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:34:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so39896652wrr.4
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CokP5DJZX8fcTdu2V8k9QUz5XnfVM2mfkMJryb9GY0Y=;
        b=rQ8qNNEw6xuRk+7wGk/1NbqKurw7x/WcArkYjYNMAIgACSys0np9LBcjJBWkDMjbET
         1QjvKEGGtUmR9J6dwDUEAzWOwlSys+kJs9aIeBF98gBNGBnITlEUN1fVn1HEo3t1psuw
         tpezWne14buhxYo32E7AKhWJ2jNEr5q0XQHnnEVX8GyW9LtZ0A7NnpG9AF9rHGMdFMcM
         UpyvsPWJ4eiqLpDzhmeDVLsuWS+NdL7SZ0O3gj1NivFECSD0TnGQNAkjztjvjT1kb5jm
         XYwh8rG//myKdOXBtT8Dzsmx4UO9BGRc84m0qUyxyXjeqDaJH2bxRmYzlpn4luFDmJ3W
         CPeQ==
X-Gm-Message-State: APjAAAWtxp/zcCwz2ZMR+9R0sv0gUPxM9JrLtqpD0xLPLbQZdU/eZ0Cg
        /+r0EngJVnxyoQXgsrpCsRUwGw==
X-Google-Smtp-Source: APXvYqzBErq4zKQr1w1EtdBj7vtFUGW/B8UZMe8PqrMcUaUa6/Cp+PqL1mP0K4OpT6sybWId8GYeHg==
X-Received: by 2002:adf:e444:: with SMTP id t4mr25964034wrm.262.1564479270468;
        Tue, 30 Jul 2019 02:34:30 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j16sm6519552wrp.62.2019.07.30.02.34.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:34:29 -0700 (PDT)
Subject: Re: [RFC PATCH 07/16] RISC-V: KVM: Implement VCPU world-switch
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
 <20190729115544.17895-8-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cbb1b995-be2f-96a5-9890-63e1941e7f3c@redhat.com>
Date:   Tue, 30 Jul 2019 11:34:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-8-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> -	/* TODO: */
> +	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +
> +	csr_write(CSR_HIDELEG, csr->hideleg);
> +	csr_write(CSR_HEDELEG, csr->hedeleg);

Writing HIDELEG and HEDELEG here seems either wrong or inefficient to me.

I don't remember the spec well enough, but there are two cases:

1) either they only matter while the guest runs and then you can set
them in kvm_arch_hardware_enable.  KVM common code takes care of doing
this on all CPUs for you.

2) or they also matter while the host runs and then you need to set them
in vcpu_switch.S.

Paolo
