Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F405E3DB8F2
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbhG3M66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238852AbhG3M65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 08:58:57 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695D2C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 05:58:51 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m12so6430351wru.12
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 05:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8hwjM/QSzVbDdpvE5AeYjXhEWiO5+EcdPNYuJTkjFg=;
        b=TsfEJZvy1y2u50cLgrLLYofgWvuIMkgvXW0S+vvSU9GzX3mFKvG6124i06yOC8eb27
         20oETj/Pf8KSzJbb8oyT+eGuILBv/+i1pZ1yYPBDlVQCRZHWC4CrsXkwUFlGcwmS3eMC
         j1k6mWNpgiiH44Wu1eF0cfG2ZCnBWvtdaIBVuugBYUy6Xt3I9AlfYgi3SCEbxomhC9vU
         2RGxTWO+cEpbNB2ViIzHIEnFw8U9NRenXL5JGiiD8tz/wL4ygy6t/NEK5VwNqnS7obW7
         ob0CwQ821wKM68qZa6pKGtKOBElIFnHxra9+PupVE5JcWVCd4j53gRNXxHm0UbJDwPnP
         ejOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8hwjM/QSzVbDdpvE5AeYjXhEWiO5+EcdPNYuJTkjFg=;
        b=q9olZEqm7mDjPjikTipqI/GKBqZqSDz2lHBw7njoOjUttIubNwqJgI8QsN7WBDppMK
         s3FIPH/lWq/KuY3Ien9gJD+WUPVBdaCV7MTqGUsNuktB7UiRtxKIMr4EoSBxQgh3YAyF
         jPaDHuXiHpPZwGZhqo9bHumNij0rrVAXYxvRXacpEqIg3SYm3ywfvHoCMgNWyPnIYQMN
         eqZ3sGf0Qz1N2oPJXhYtDGP2yrP8dDT+kBG/KRsXdu7Lor7g3DywznAHUdIqIVRi5h6e
         s/2OnTDRIdAAE+zD8nm8N0kHIM6HZ3EJ7yaVWf5sNsH9xqDy2NrSFFjbFJDV7vj8CdPp
         EOig==
X-Gm-Message-State: AOAM5314YXsVf0ohUwW03GUqdNa6DJMv/LFv7dHqa/w1ditfxRp4Q8NA
        m6qrnt4Fd/vzlV58WdoS7iJCkg==
X-Google-Smtp-Source: ABdhPJw3CJ1cqpI0Y4vGMsPLtJPixEOIGryBdXpTDYmJE+DPDNyY/xAIzO3MXjhCsbR8ZQ/NrllLug==
X-Received: by 2002:adf:d087:: with SMTP id y7mr2868579wrh.323.1627649929764;
        Fri, 30 Jul 2021 05:58:49 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:26d7:991f:a808:7661])
        by smtp.gmail.com with ESMTPSA id h12sm1678791wrm.62.2021.07.30.05.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 05:58:49 -0700 (PDT)
Date:   Fri, 30 Jul 2021 13:58:46 +0100
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YQP3hnkXs1R7PRqt@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <20210727181107.GC19173@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727181107.GC19173@willie-the-truck>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday 27 Jul 2021 at 19:11:08 (+0100), Will Deacon wrote:
> On Thu, Jul 15, 2021 at 05:31:47PM +0100, Marc Zyngier wrote:
> > Introduce the infrastructure required to identify an IPA region
> > that is expected to be used as an MMIO window.
> > 
> > This include mapping, unmapping and checking the regions. Nothing
> > calls into it yet, so no expected functional change.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   2 +
> >  arch/arm64/include/asm/kvm_mmu.h  |   5 ++
> >  arch/arm64/kvm/mmu.c              | 115 ++++++++++++++++++++++++++++++
> >  3 files changed, 122 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 4add6c27251f..914c1b7bb3ad 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -125,6 +125,8 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
> >  	/* Memory Tagging Extension enabled for the guest */
> >  #define KVM_ARCH_FLAG_MTE_ENABLED			1
> > +	/* Gues has bought into the MMIO guard extension */
> > +#define KVM_ARCH_FLAG_MMIO_GUARD			2
> >  	unsigned long flags;
> >  
> >  	/*
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index b52c5c4b9a3d..f6b8fc1671b3 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
> >  phys_addr_t kvm_get_idmap_vector(void);
> >  int kvm_mmu_init(u32 *hyp_va_bits);
> >  
> > +/* MMIO guard */
> > +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> > +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> > +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> > +
> >  static inline void *__kvm_vector_slot2addr(void *base,
> >  					   enum arm64_hyp_spectre_vector slot)
> >  {
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 3155c9e778f0..638827c8842b 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1120,6 +1120,121 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> >  		kvm_set_pfn_accessed(pte_pfn(pte));
> >  }
> >  
> > +#define MMIO_NOTE	('M' << 24 | 'M' << 16 | 'I' << 8 | '0')
> 
> Although this made me smile, maybe we should carve up the bit space a bit
> more carefully ;) Also, you know somebody clever will "fix" that typo to
> 'O'!
> 
> Quentin, as the other user of this stuff at the moment, how do you see the
> annotation space being allocated? Feels like we should have some 'type'
> bits which decide how to parse the rest of the entry.

Yes, that's probably worth doing. I've been thinking about using fancy
data structures with bitfields and such, but none of that really seems
to bit a simpler approach. So how about we make the annotate() function
accept two arguments instead of one: an 'enum kvm_pte_inval_type type'
and 'u64 payload', and then we provide a static inline helper in
pgtable.h to unpack an invalid PTE into type/payload members? I'd guess
7 bits for the type should be more than enough and the payload can use
the rest.

Thoughts?

Thanks,
Quentin
