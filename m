Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B104624BA
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhK2W0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbhK2WZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:25:14 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E321C0C085F
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 09:25:30 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z6so12740797plk.6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 09:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bxpm877ucu29+swtwCcWrV9CPuVdsV2sIZfuT/jfRmc=;
        b=OQsEdj0rbR41/5YmIUdSrIJYCBGgCTUy9MQ5b9N87MM6uHjwmzAsHY1InGAtcJzzT0
         kXYHaRVbVnijPR96HzFaJq33Sw0nxu7KBR5alKkujlnpJgTb7ASLVjrwO1SSGsYoOkaQ
         K7cyD5kT9W1uMzNVmFhkVgYWGz7yTXUI7MuAi/f6xjABudDnAM1CxSfahAqvYF0vFr+z
         P1vOrLjB/9DR5TYDkZ2qVm7gvSexhNg5yeXAFAs7Vo4H0IrRkItMjbCy7SznqoFOYmJJ
         HNBdnQMeynqmiQ4BF5DB9MM0TzHLeCRZF1Krj6haC25keEJILJKSu+fr0lje3TcmjayD
         +Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bxpm877ucu29+swtwCcWrV9CPuVdsV2sIZfuT/jfRmc=;
        b=xEYY8ZpStkgqQyXyy5Xox35AKLGAfmfF405lYGUjVPAuFE1WSrSd7gM3uznvGMz1e/
         SwHwKwcHqNLNway5LIKpy7RVPHgTTXo7/vwXxQMn4IyEZWNs4EegvgzpcFmA45++hDae
         rqcy+Infpq5aiA8rQHfu3O455m941ROe0uINcMWvmj2oYfM96ETsmkRnCItoYIR7PIhZ
         EaA4R81iXzwdbEbHrs7xl0AJxtxGcqAS5Y+vGhqOirvJSHXggUwbksIVHFGB9mdmcAof
         jrnvRnI//aFHxRQ25a+cqQy+/6EDyI5nizNHGwC3hQe5J8/+vSuuFutm4IxvP2KTrILT
         wi6Q==
X-Gm-Message-State: AOAM5323N1UXN9nUzvwHj692zqkKxsM5t6LoYQC7ZHQZt1/4ACbvgvlS
        mRYKPFMHuzRhI2EQ4twuyq1dOg==
X-Google-Smtp-Source: ABdhPJykBaUp6Ra73BKveHHRMZh4OnjUi7muGD2LnVC8BwpUUYIBB4aGQnyy+EYpnJ0P8dJ+mpdu6Q==
X-Received: by 2002:a17:902:7289:b0:142:805f:e2c with SMTP id d9-20020a170902728900b00142805f0e2cmr61761710pll.42.1638206729695;
        Mon, 29 Nov 2021 09:25:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m15sm18877279pjc.35.2021.11.29.09.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 09:25:29 -0800 (PST)
Date:   Mon, 29 Nov 2021 17:25:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <YaUNBfJh35WXMV0M@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021, Maxim Levitsky wrote:
> (This thing is that when you tell the IOMMU that a vCPU is not running,
> Another thing I discovered that this patch series totally breaks my VMs,
> without cpu_pm=on The whole series (I didn't yet bisect it) makes even my
> fedora32 VM be very laggy, almost unusable, and it only has one
> passed-through device, a nic).

Grrrr, the complete lack of comments in the KVM code and the separate paths for
VMX vs SVM when handling HLT with APICv make this all way for difficult to
understand than it should be.

The hangs are likely due to:

  KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with APICv)

If a posted interrupt arrives after KVM has done its final search through the vIRR,
but before avic_update_iommu_vcpu_affinity() is called, the posted interrupt will
be set in the vIRR without triggering a host IRQ to wake the vCPU via the GA log.

I.e. KVM is missing an equivalent to VMX's posted interrupt check for an outstanding
notification after switching to the wakeup vector.

For now, the least awful approach is sadly to keep the vcpu_(un)blocking() hooks.
Unlike VMX's PI support, there's no fast check for an interrupt being posted (KVM
would have to rewalk the vIRR), no easy to signal the current CPU to do wakeup (I
don't think KVM even has access to the IRQ used by the owning IOMMU), and there's
no simplification of load/put code.

If the scheduler were changed to support waking in the sched_out path, then I'd be
more inclined to handle this in avic_vcpu_put() by rewalking the vIRR one final
time, but for now it's not worth it.

> If I apply though only the patch series up to this patch, my fedora VM seems
> to work fine, but my windows VM still locks up hard when I run 'LatencyTop'
> in it, which doesn't happen without this patch.

Buy "run 'LatencyTop' in it", do you mean running something in the Windows guest?
The only search results I can find for LatencyTop are Linux specific.

> So far the symptoms I see is that on VCPU 0, ISR has quite high interrupt
> (0xe1 last time I seen it), TPR and PPR are 0xe0 (although I have seen TPR to
> have different values), and IRR has plenty of interrupts with lower priority.
> The VM seems to be stuck in this case. As if its EOI got lost or something is
> preventing the IRQ handler from issuing EOI.
>  
> LatencyTop does install some form of a kernel driver which likely does meddle
> with interrupts (maybe it sends lots of self IPIs?).
>  
> 100% reproducible as soon as I start monitoring with LatencyTop.
>  
> Without this patch it works (or if disabling halt polling),

Huh.  I assume everything works if you disable halt polling _without_ this patch
applied?

If so, that implies that successful halt polling without mucking with vCPU IOMMU
affinity is somehow problematic.  I can't think of any relevant side effects other
than timing.
