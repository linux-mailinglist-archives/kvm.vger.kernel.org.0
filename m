Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE686829F8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 05:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbfHFDTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 23:19:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33245 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729999AbfHFDTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 23:19:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so7934171wme.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 20:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dr2+cEWOTjWIrHgq1rAPpBc6r9tZtYF1YbUnLR69BFg=;
        b=xQaMHCEu94MSWV0KnK1zA0WkUuR9+C2JoA7OyFGL1bMhbTfgWoKYiPiBLsiLmW+h+x
         MQ3B6t0N0TyWSy9h9rZc8F+4VTFAIH8Iedrf8KilAY2c5AOdX2tC2CndcOeVjxSy2GHO
         GI93PGu9zITG/U5rrHWGkkA5Ju5ktIJiHKkSvIGs+vOJ9Kez1Xb0dI8QvVhhWkfzaKsV
         tMP55LDR3YYdlt9K21sGMwHzYF9O1rH+IegheKtwbw9tlS2hUgPhoge/HJIJWt3xMgRz
         uA7D4HcLjXGGPwdp50RKYHh/RJ0kRwQ0JvqWO80/m5fi1DQlNlA09FUD+/020u8Gvf4D
         8o6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dr2+cEWOTjWIrHgq1rAPpBc6r9tZtYF1YbUnLR69BFg=;
        b=coKZ4goQCjF9Z8w/29xbkU1no+JpCHRMGeHQg/60M7xrAZ0ZZtNlhv/cHH53lC0wOG
         BdV50D2wWdCI+lWLK+H4IrwGr7mkHElDimxcBDjjmWcKPhtllFVJHW52qmh9DQWLO9qo
         bzhKDcLYG/4jzOWg4DnhXd8NOIEvd4WK2wYgKhuGGtfYb7Qp/8OQlhAfCxRvareoVDWV
         9wFKIhJfavyLKJo3YENGpn1yIzDXw8UfQq7Nt7LzM23dhcXsf90SEW2Y1OPpHAqqu1sM
         OrVAhl/pMhiwUXxOni43wmP3/Ako9zRnGYfBM/z6kxXYr902j5H/qinMaWzaBZImzqA0
         eo6g==
X-Gm-Message-State: APjAAAWQtIN9f14oDdhjYtcDvGQhUbtIorG52W3GPkek1L3YY2p/q3Wr
        GQriIUQVm/+SDaxdmONKTHArrHBMLsmeWIDwhVNwkIU7
X-Google-Smtp-Source: APXvYqwH6qC9nSAJAWBGGxZ0uXvKgHP/raIkzQCYLK0pRSGDcTtZMMyScdsr3bxWn1y3xiVpXqFzA7f5nHQEnBJZ3yw=
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr1313747wma.171.1565061575887;
 Mon, 05 Aug 2019 20:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190805134201.2814-1-anup.patel@wdc.com> <20190805134201.2814-12-anup.patel@wdc.com>
 <21bdde39-8d33-6aae-e729-476ce11406a3@redhat.com>
In-Reply-To: <21bdde39-8d33-6aae-e729-476ce11406a3@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 6 Aug 2019 08:49:24 +0530
Message-ID: <CAAhSdy03G-8S0y7kg96PzC-4npdEFv+WCCuBvoCbEt9244kDOg@mail.gmail.com>
Subject: Re: [PATCH v3 11/19] RISC-V: KVM: Implement VMID allocator
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

On Mon, Aug 5, 2019 at 9:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/08/19 15:43, Anup Patel wrote:
> > +     spin_lock(&vmid_lock);
> > +
> > +     /*
> > +      * We need to re-check the vmid_version here to ensure that if
> > +      * another vcpu already allocated a valid vmid for this vm.
> > +      */
> > +     if (!kvm_riscv_stage2_vmid_ver_changed(vmid)) {
> > +             spin_unlock(&vmid_lock);
> > +             return;
> > +     }
> > +
> > +     /* First user of a new VMID version? */
> > +     if (unlikely(vmid_next == 0)) {
> > +             WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
> > +             vmid_next = 1;
> > +
> > +             /*
> > +              * On SMP, we know no other CPUs can use this CPU's or
> > +              * each other's VMID after forced exit returns since the
> > +              * vmid_lock blocks them from re-entry to the guest.
> > +              */
> > +             spin_unlock(&vmid_lock);
> > +             kvm_flush_remote_tlbs(vcpu->kvm);
> > +             spin_lock(&vmid_lock);
>
> This comment is not true anymore, so this "if" should become a "while".

Sure, I will update in v4.

Regards,
Anup
