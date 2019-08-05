Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A4F8188B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbfHEL4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 07:56:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45329 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfHEL4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 07:56:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so5208629wre.12
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 04:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TY4SwjXmEN9gc5bLylSn4Hg0/dB7NKueAsPGd6xGBoQ=;
        b=TNX8eRkn/+urFB0t6dQmh0V/R5junwwfhqge8PnHmYmhidwlVaGQFc8BMNqueSgYsb
         R0hXZ5VuBKyhlhemeAB39xkb80QBa1bLH+h9QKjqQ2YmATbbzitp32Q+giZVHWxxEEf2
         gNzoMHhpxkK1W9glnRqe7NavUl8FmtkmZPQY3dK+W+W+9d+DvVuHc/haf7HDZcu8aYcH
         qJH+X7EbcyC2Dd6xpBBB4h9fEksnK30Y/V3vbQvu1fTJ8knxguA5+XtDHy+Rpncc9xrC
         /rOhtpS4Jfpfu5ZZVS+D6rM9Fn/q6naJfJBSPsXM2opCHewW8OThvWUamJycQ0ttb07z
         69yA==
X-Gm-Message-State: APjAAAXq+cZKNN5oQWXdk/btd4T0wZwrOpblx7wcjRcCTFiUyNFudExe
        gjX78eXXAHcnGMizJZ1+8EFOwg==
X-Google-Smtp-Source: APXvYqyiW6VU1XQOFEG2eUsh/f6zKNWC3klkjjD7J05dOiekrtpHuIxq6IVPBKdC0E3ZEqXFzkJjhg==
X-Received: by 2002:a5d:4cc5:: with SMTP id c5mr107334032wrt.278.1565006195708;
        Mon, 05 Aug 2019 04:56:35 -0700 (PDT)
Received: from [192.168.178.40] ([151.21.165.91])
        by smtp.gmail.com with ESMTPSA id v15sm77198646wrt.25.2019.08.05.04.56.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 04:56:35 -0700 (PDT)
Subject: Re: [RFC PATCH v2 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Anup Patel <Anup.Patel@wdc.com>,
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
 <20190802074620.115029-8-anup.patel@wdc.com>
 <edbed85f-f7ad-a240-1bef-75729b527a69@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8563b869-1ab4-d0f1-afad-9cd864b6019a@redhat.com>
Date:   Mon, 5 Aug 2019 13:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <edbed85f-f7ad-a240-1bef-75729b527a69@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/19 13:37, Christian Borntraeger wrote:
> While have ONE_REG will certainly work, have you considered the sync_reg scheme
> (registers as part of kvm_run structure)
> This will speed up the exit to QEMU as you do not have to do multiple ioctls
> (each imposing a systemcall overhead) for one exit. 
> 
> Ideally you should not exit too often into qemu, but for those cases sync_regs
> is faster than ONE_REG.

At least in theory, RISC-V should never have exits to QEMU that need
accessing the registers.  (The same is true for x86; Google implemented
sync_regs because they moved the instruction emulator to userspace in
their fork).

Paolo

