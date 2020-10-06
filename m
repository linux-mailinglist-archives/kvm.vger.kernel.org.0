Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB21528539C
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgJFVG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:06:26 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38896 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbgJFVG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:06:26 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602018384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJsRLR/GkQ9y55O/CRKVyWEVz7Xo2QXtu4Qp1z7vboQ=;
        b=BumlTzJoaEazB1qg0hEMqrqLjk17pzwuyeAZCv8B4WQH/n5eEctgvA3WOsEaB+xaeEj+90
        lQh/ds6d9BQaeYTOcnM0nd0ikZC+V/UWeMf6jAVNbdNT3av9BL7qrNoCMvqbdziHzy2m0z
        PN0XKqhnVwosi+iqtZ68xm76qYs0EvC29/02kJB5g/CQUvFBEl36w3PCVACLkAm9573ZUL
        19qaTmLc/HKZ/RXQvhNYqUBF2jDQzytl3MhfR3nOPuqsge//c8VdtQUrnQT1N/9HG56kcC
        AXTqAmFjMJWgHN7ExlPSLGXBa2TdzK079Htko7R+C/ilxyUS0EXVvV1k+o4xDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602018384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJsRLR/GkQ9y55O/CRKVyWEVz7Xo2QXtu4Qp1z7vboQ=;
        b=q0LCsvJPrT9MflDeA3d4nXkFpjov+sYU6mnQ6FkKbfUFdxZE9G83qKg9++8n7MHXDg04nh
        3YNP1h4k2nv0+eDg==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] genirq: Add default_affinity argument to __irq_alloc_descs()
In-Reply-To: <20201005152856.974112-6-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-6-dwmw2@infradead.org>
Date:   Tue, 06 Oct 2020 23:06:23 +0200
Message-ID: <87o8lf5ak0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> It already takes an array of affinities for each individual irq being
> allocated but that's awkward to allocate and populate in the case
> where they're all the same and inherited from the irqdomain, so pass
> the default in separately as a simple cpumask.

So we need another cpumask argument exposed to the world just because
it's so hard to extend struct irq_affinity_desc so it supports that use
case as well. It's not written in stone that this struct can only
support arrays.

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  include/linux/irq.h    | 10 ++++++----
>  kernel/irq/devres.c    |  8 ++++++--
>  kernel/irq/irqdesc.c   | 10 ++++++++--
>  kernel/irq/irqdomain.c |  6 +++---

git grep __irq_alloc_descs() might help you to find _all_ instances ...

Thanks,

        tglx
