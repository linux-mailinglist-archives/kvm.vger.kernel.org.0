Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885167A739
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfG3LqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:46:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41304 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfG3LqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:46:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so62208670wrm.8
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSo219uBBQuUIUjoxpKujZtQ/5w8YP4pzpQJT3D8aBA=;
        b=gbw6CwkeXhENGj0Eco2ek5ibwxV16dRDV7am21QurDDO6eOhOkVzbupEo0vU5bjnX8
         wooptB/qSlORBPn6AJO9d6w6OTdp8aKbkrTjrp8IMloxRKPXN2yYh47vKeAN/CFaSZYc
         Wv4D9akzJgzNvlbW6kCYgSG5YfrJLKMHeK5qJ5Os6kkfd8HRUesS8DW3VJif/ZhFLgVa
         ISCTcC/JSf8tTK7eXzEfjoBsWfG2JmxjnSA0s37YubJ9mISX5km8dbVKEIjFQRlWhxxD
         c/GVRcN0F/txPzvFKgC/LRk0YOagBkFUvHIj1KabmrGucdZCwu0ckNAkGrLyj6NzYnMs
         9YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSo219uBBQuUIUjoxpKujZtQ/5w8YP4pzpQJT3D8aBA=;
        b=HoolGWzjJUJjAKewo/InFV9zbBwd5Vyci+E+EHMbXsPpdb2gsPCSLaOPgzg2NQhCKw
         ZS6na8tDWVsf6wxE0CC7j/ggwSeXVBhw0kB35fx3cy02JuF2XniJbTAEEFsE1W1EBO9P
         K42s7Laehf+keTmWKy/Wby/2CRM/D9863aW+hz8JSR1SRr7UoB6KFJry29li4OjBOqdg
         gZCsk/OdUXnCldZoMSeo3i0ht7f7xTGSn1K8VRGidXRRbSGBYkP/7ARXtx9uFSWDNlCR
         qnJI/Yatr/bcroiPo5PaBC9/XRCm4aEB90rV9zUV4Hhv2CF/58XJWdzjbuO1g70dIt/J
         vVgA==
X-Gm-Message-State: APjAAAU5LUBDl6gKmqs/VDBBUC+6W4EVuFz+khseIhd0FcP+3zwrw/10
        VnD4H5r495xJ2REAriyKOCDKCQZPQFwk0V26jng=
X-Google-Smtp-Source: APXvYqxcNGyAMDSQUqXUF4ibEZV0Hg0QLhoWESRbxN2cYy12N9UTrjz1RoeAXOIYGCVQ4YlqG0W4pvPRidpxQg32B0Y=
X-Received: by 2002:a5d:6284:: with SMTP id k4mr94957352wru.179.1564487165402;
 Tue, 30 Jul 2019 04:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-5-anup.patel@wdc.com>
 <ade614ae-fcfe-35f2-0519-1df71d035bcd@redhat.com> <2de10efc-56f8-ff47-ed69-7e471a099c80@redhat.com>
In-Reply-To: <2de10efc-56f8-ff47-ed69-7e471a099c80@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 17:15:53 +0530
Message-ID: <CAAhSdy0OH9h-R=2NxhhPs6jmFPNgZVSwFtCjtJrf++htu82ifA@mail.gmail.com>
Subject: Re: [RFC PATCH 04/16] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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

On Tue, Jul 30, 2019 at 3:46 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/07/19 10:48, Paolo Bonzini wrote:
> > On 29/07/19 13:56, Anup Patel wrote:
> >> +    cntx->hstatus |= HSTATUS_SP2V;
> >> +    cntx->hstatus |= HSTATUS_SP2P;
> > IIUC, cntx->hstatus's SP2P bit contains the guest's sstatus.SPP bit?
>
> Nevermind, that was also a bit confused.  The guest's sstatus.SPP is in
> vsstatus.  The pseudocode for V-mode switch is
>
> SRET:
>   V = hstatus.SPV (1)
>   MODE = sstatus.SPP
>   hstatus.SPV = hstatus.SP2V
>   sstatus.SPP = hstatus.SP2P
>   hstatus.SP2V = 0
>   hstatus.SP2P = 0
>   ...
>
> trap:
>   hstatus.SP2V = hstatus.SPV
>   hstatus.SP2P = sstatus.SPP
>   hstatus.SPV = V (1)
>   sstatus.SPP = MODE
>   V = 0
>   MODE = 1
>

Yes, this kind of pseudo-code are not explicitly specified in the
RISC-V spec. The RISC-V formal model is supposed to cover
this kind of detailed HW state transition.

> so:
>
> 1) indeed we need SP2V=SPV=1 when entering guest mode
>
> 2) sstatus.SPP contains the guest mode
>
> 3) SP2P doesn't really matter for KVM since it never goes to VS-mode
> from an interrupt handler, so if my reasoning is correct I'd leave it
> clear, but I guess it's up to you whether to set it or not.

Yes, SP2P does not matter but we set it to 1 here so that from Guest
perspective it seems we were in S-mode previously.

Regards,
Anup
