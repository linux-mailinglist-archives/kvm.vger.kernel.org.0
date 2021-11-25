Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B399845E10A
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356730AbhKYTgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhKYTep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:34:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75613C06173E;
        Thu, 25 Nov 2021 11:31:33 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637868692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gpUN5LfxUwziCHZGBBCmGs+KW8h5+IJ1c0CfPbKoypk=;
        b=D1V3v60SFpMXgH4XlHLPQB5pnAALo79hGM7wcQmx2UtiMLCjjaj31/mcQ3XtgfvnrwPHVV
        PujbkOu8/NhLqPbuENTbIucltFZgA27hB9nQzIessAxlITJGOyhfsgPzyWoPxg/aNMtZjb
        dbZTqhcJV0jUrtN58OFqIdFr384tCCMgx+FGiZpMZ84ff9hAKcHnZklBSyxLKpOj+2fI1X
        6TgEmPwIYueEI1X34wJzIR6Eyzl4ji7aOv8O7yfdSwzvW6kR2+fvIaCPGn1mwFkzHpLDO0
        NYUO+QYvOFFicU4guFJg0ADrb/sfXIpzBmvBlWpR0dh9i9Hqup9xRKr4ZhRoDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637868692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gpUN5LfxUwziCHZGBBCmGs+KW8h5+IJ1c0CfPbKoypk=;
        b=Sgho37z2/ampj7dMUCz9rJuM5k+anbpXD+Cq0HwRImTcm4FkDmm+SXs/A9m1nsBuofIkgH
        bVqOdauSQRByl2CA==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 16/59] KVM: x86: Add per-VM flag to disable
 direct IRQ injection
In-Reply-To: <dbf8648ee18606a5a450bce32100771a3de5fd83.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <dbf8648ee18606a5a450bce32100771a3de5fd83.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:31:31 +0100
Message-ID: <87o868jalo.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add a flag to disable IRQ injection, which is not supported by TDX.
...
> @@ -4506,7 +4506,8 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
>  				    struct kvm_interrupt *irq)
>  {
> -	if (irq->irq >= KVM_NR_INTERRUPTS)
> +	if (irq->irq >= KVM_NR_INTERRUPTS ||
> +	    vcpu->kvm->arch.irq_injection_disallowed)
>  		return -EINVAL;

That's required here because you forgot to copy & pasta the protect
guest condition muck into that ioctl, right?

