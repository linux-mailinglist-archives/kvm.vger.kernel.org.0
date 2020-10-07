Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2EA286306
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgJGQDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbgJGQDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:03:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCE2C061755;
        Wed,  7 Oct 2020 09:03:01 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602086579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/O9zXhP69EMhj/QeCm7nrD9DQq4LE8NEMX5F2vVATgA=;
        b=RI/eM+2S5vH/NncDytwt7k54fB7OvpP02d8g6KxKLwsB8XC3qMn05fzYGhjNibTLNMTJpr
        w/l7vnoIHEp++pNghC71NU1X6d1Z+uU7zFRzWjVig3KaWnl/XWH3TDXYF/8FILRizMwXVM
        asKtdY0JB7Wx5QN7ZQZZ8YL+WC4FLxO5JTzqF1wYks9U66MgUJFoE4vsEhkAJq/J+wKoXE
        xiVbPLzdi1GgKH8TI0DGruH4P5yyrJ3BofYgIEiVlHSpsI10w2Vi12p4tFHmm7d6hGMxlv
        p8hTVXPd2fxe98WmDN3uwt0rMiGFqH5KUe+WKCKZBpcOuqeFozoUMHYIfHI8sA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602086579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/O9zXhP69EMhj/QeCm7nrD9DQq4LE8NEMX5F2vVATgA=;
        b=aqWokfyvspmV4iCEpYaILBtp6cY+vo8aEECP6c1adQSHnVnLCtdUwT+etJqIziH+dADdSA
        AAKK0fqcfKGuzjAA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
In-Reply-To: <1b1fda3079627748e1f5084ddae8a686258c78d9.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org> <874kn65h0r.fsf@nanos.tec.linutronix.de> <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org> <87imbm3zdq.fsf@nanos.tec.linutronix.de> <1b1fda3079627748e1f5084ddae8a686258c78d9.camel@infradead.org>
Date:   Wed, 07 Oct 2020 18:02:59 +0200
Message-ID: <877ds23txo.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 15:23, David Woodhouse wrote:
> On Wed, 2020-10-07 at 16:05 +0200, Thomas Gleixner wrote:
>> On Wed, Oct 07 2020 at 14:08, David Woodhouse wrote:
>> > On 7 October 2020 13:59:00 BST, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > > On Wed, Oct 07 2020 at 08:48, David Woodhouse wrote:
>> > > > To fix *that* case, we really do need the whole series giving us per-
>> > > > domain restricted affinity, and to use it for those MSIs/IOAPICs that
>> > > > the IRQ remapping doesn't cover.
>> > > 
>> > > Which do not exist today.
>> > 
>> > Sure. But at patch 10/13 into this particular patch series, it *does*
>> > exist.
>> 
>> As I told you before: Your ordering is wrong. We do not introduce bugs
>> first and then fix them later ....
>
> I didn't introduce that bug; it's been there for years. Fixing it
> properly requires per-irqdomain affinity limits.
>
> There's a cute little TODO at least in the Intel irq-remapping driver,
> noting that we should probably check if there are any IOAPICs that
> aren't in the scope of any DRHD at all. But that's all.

So someone forgot to remove the cute little TODO when this was added:

       if (parse_ioapics_under_ir()) {
                pr_info("Not enabling interrupt remapping\n");
                goto error;
        }

Thanks,

        tglx
