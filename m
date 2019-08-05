Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58C81888
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfHEL4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 07:56:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53898 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfHEL4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 07:56:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so74467018wmj.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 04:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vhTBJZEcsjvTkvOpSV7JcEtFKAA9Exg0pMP9uE8HBUs=;
        b=j2cxRWIzJWwkZSXOsd7iqkdySk76thOrHaNvBOCn2itmKfoj5zmnKFKd5PZ83DQUpd
         VWN6CriBZdpZ6mayWW41Dg0KK6Np+Wv8SZf0ZyjwXE42dDXcHFU2P964QIOrXYcB9RrJ
         th68YmT5hWQKspO1CFMPKRhlZ68MHu1nfflC4c316MaJM41iyU3eG+5jEOH6IOSi6FDc
         JOQPdmSu01w6czCcx8rCHJLaXZ4Ig5ko6Qtd28QVjqmvlANS2GK+V/gisiBAt9NChtg0
         e42XgEfznhyur69CRHk2XN/GF62OC+Xd06npgkw7ZqGvaqWVi0uGxeeRuDsHgwc+JF7P
         /5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vhTBJZEcsjvTkvOpSV7JcEtFKAA9Exg0pMP9uE8HBUs=;
        b=jTxSrJIY+K+ZLf3o0gZRox6u+E9X7dMZkb4HfP1MAGBxOkjvgJhfGpFipqyD8wkXUy
         Taiux0dJSJmAoXRSM+iWSjkuGoQHBy0bqavrWGjEzN/zH9GzhQjWm0UR4LgN9/KMLmAG
         +FlnDTJkLIOY/f1OthTepdvV8t5rVPt0F9HmC9EW2+rMSBR8cjZRhPrbs30Y60duId75
         TlRmTxFrAs+pXQrjk0TazClFpIvjXgkMLan0lQbEZ7Mb3PcYq0VICqFi49dKNgB/+OrD
         Uv4szUQDgrPmYiXy1RwYy1xDzommuynAQ0vMwwaw6+TJrtjP/bxKs3rn/VSLDeOMhzy9
         WftQ==
X-Gm-Message-State: APjAAAXg3VlwGdB/THBfrT43CJ8IEPHxjL31TSqZ/vNKpZL/C245b42s
        xdg3GY+LR/aFedx+j80vdsvSN3BaJTWuKTP48S8=
X-Google-Smtp-Source: APXvYqyF2repcCJOaZYS4p2lUuk5LTjS5XFEImFO3Oxk67YaRU8tEsimiGNdEpidJLWjEePzjO3jrxahGnlJVrib7EY=
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr17243611wma.171.1565006193144;
 Mon, 05 Aug 2019 04:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-8-anup.patel@wdc.com>
 <edbed85f-f7ad-a240-1bef-75729b527a69@de.ibm.com>
In-Reply-To: <edbed85f-f7ad-a240-1bef-75729b527a69@de.ibm.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 17:26:21 +0530
Message-ID: <CAAhSdy2PDSpTy1JEEC2LCB4ESvZHBbkVEZ2wqz-D2b7SKD5VSg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/19] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG
 ioctls
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 5, 2019 at 5:08 PM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 02.08.19 09:47, Anup Patel wrote:
> > For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
> > VCPU config and registers from user-space.
> >
> > We have three types of VCPU registers:
> > 1. CONFIG - these are VCPU config and capabilities
> > 2. CORE   - these are VCPU general purpose registers
> > 3. CSR    - these are VCPU control and status registers
> >
> > The CONFIG registers available to user-space are ISA and TIMEBASE. Out
> > of these, TIMEBASE is a read-only register which inform user-space about
> > VCPU timer base frequency. The ISA register is a read and write register
> > where user-space can only write the desired VCPU ISA capabilities before
> > running the VCPU.
> >
> > The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
> > T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
> > PC and MODE. The PC register represents program counter whereas the MODE
> > register represent VCPU privilege mode (i.e. S/U-mode).
> >
> > The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
> > SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.
> >
> > In future, more VCPU register types will be added (such as FP) for the
> > KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.
>
> While have ONE_REG will certainly work, have you considered the sync_reg scheme
> (registers as part of kvm_run structure)
> This will speed up the exit to QEMU as you do not have to do multiple ioctls
> (each imposing a systemcall overhead) for one exit.
>
> Ideally you should not exit too often into qemu, but for those cases sync_regs
> is faster than ONE_REG.
>

We will certainly explore sync_regs interface. Reducing exits to user-space
will definitely help.

This is the first series for KVM RISC-V so here we want to establish a stable
and extensible UAPI header using which we will add support to QEMU KVM.

For time being, we are using KVMTOOL for debug and development.

Thanks,
Anup
