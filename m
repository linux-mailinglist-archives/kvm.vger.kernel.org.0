Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B597A37E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 10:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbfG3I7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 04:59:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43719 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfG3I7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 04:59:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so64822316wru.10
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 01:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gAOqp4tzpeM+kc2yKMu7T8t6rZFmcQeUo4HHT+xzYZI=;
        b=LsVCpFQc93aru/8NxhIzF7XPPn2f2NoDwCIE8t27Vd7hn2a7+i2KmfjyzDu0tAAjyE
         y9uUvac9HWkLJnsf5skr5s7hqF3X72dJehc26Lf0tgEsaTbA4w9u6sXRFwF8EvL36+Cv
         Mi5F46Jf7odqVy4mnOKyGLnyJXobqfS9QrsITOyzyrdzjtXDEUWvtZ8BKrFHq9tA2BLE
         pzpucceykKZPki9anPdhT8/A43qW1Qx5foSL/8uCbeoWO3y6VwDZvVaN6QSo0b1B61oL
         j4/yPnbgVf2wDGGi2lEw2r+wYe+i2YeyodQDYEUQDOe9m5lu2cw4BcLVdFr9/QIPXPu/
         mfMA==
X-Gm-Message-State: APjAAAXp5MJ/hzP5BfWvaeDAYwAMMBWAQ0MxyYQoYqGnBuHuYqyY3b1w
        5qqfA7fLq8EGjuIZbpPamD1wyA==
X-Google-Smtp-Source: APXvYqzhAPFkeeQBIg3SYU7j4ftAIiAkZA1CoW1Nhux1UtFgjCYh15jhOXBY/HRWgOoVtocpRAQlHA==
X-Received: by 2002:a5d:6182:: with SMTP id j2mr78631874wru.275.1564477149972;
        Tue, 30 Jul 2019 01:59:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id f10sm51137371wrs.22.2019.07.30.01.59.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 01:59:09 -0700 (PDT)
Subject: Re: [RFC PATCH 10/16] RISC-V: KVM: Implement VMID allocator
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
 <20190729115544.17895-11-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a99b586-a7bb-be3e-c47b-7809e6be610b@redhat.com>
Date:   Tue, 30 Jul 2019 10:59:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-11-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
> +	/* First user of a new VMID version? */
> +	if (unlikely(vmid_next == 0)) {
> +		atomic_long_inc(&vmid_version);
> +		vmid_next = 1;
> +

vmid_version is only written under vmid_lock, so it doesn't need to be
atomic.  You only need WRITE_ONCE/READ_ONCE.

> +
> +	/* Request stage2 page table update for all VCPUs */
> +	kvm_for_each_vcpu(i, v, vcpu->kvm)
> +		kvm_make_request(KVM_REQ_UPDATE_PGTBL, v);

Perhaps rename kvm_riscv_stage2_update_pgtbl and KVM_REQ_UPDATE_PGTBL to
kvm_riscv_update_hgatp and KVM_REQ_UPDATE_HGATP?

Paolo
