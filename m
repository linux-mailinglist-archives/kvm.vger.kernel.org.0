Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB90285364
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 22:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgJFUqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 16:46:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38796 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbgJFUpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 16:45:55 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602017153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=x8PBGKW1YFjQr3oglR9eLdmhsqjcfHmqCT2LlUTGLOM=;
        b=e4W7SWtA094G/E5QqbF3+PJqU6PUCpdgUq/IsecAJg6rJGv7NpL2fNMGDOv6YrrFBPWI43
        /At/3FcNjP6DMeygAGU9gzxyFADLwVgcD7taKVyMC3Bic8MaBKJj8CYoeGdeglElyZ7gyS
        3IuBDsSU7PhQrFtLOIV/V1UIR+FZLypZF8if9oTQvKwmruhx6XFSrZTZ7ht4hJeuxPGC7j
        KQqM1UOXcLmkJGWADmKPl/3A7fH25cVGyMIdTbejWT3pKIVGzvfHbijDm5L+j2F5fFr6Rx
        i8LOIZdqPcHAd5v8jdsRdPjsZjuKhdRWGgSWVpqn5NAwQ/4+7DyAgqzJb5QMHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602017153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=x8PBGKW1YFjQr3oglR9eLdmhsqjcfHmqCT2LlUTGLOM=;
        b=K8TBdKokFbXMu9SjeVNl/PwtI14Ub8N5UFQnHrWRhVM7CD57x46IsI4/6AuINN+3aCkni2
        DyIYHMP7C49pfYCA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 02/13] x86/msi: Only use high bits of MSI address for DMAR unit
In-Reply-To: <20201005152856.974112-2-dwmw2@infradead.org>
Date:   Tue, 06 Oct 2020 22:45:53 +0200
Message-ID: <87v9fn5bi6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
> -static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
> +static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg, int dmar)

bool dmar?

> +/*
> + * The Intel IOMMU (ab)uses the high bits of the MSI address to contain the
> + * high bits of the destination APIC ID. This can't be done in the general
> + * case for MSIs as it would be targeting real memory above 4GiB not the
> + * APIC.
> + */
> +static void dmar_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
> +{
> +	__irq_msi_compose_msg(irqd_cfg(data), msg, 1);
> +
> +
> +

Lots of stray newlines...

