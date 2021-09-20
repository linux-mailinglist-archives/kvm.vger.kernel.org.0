Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11019412ADE
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhIUCB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbhIUBnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:43:02 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149B4C05936B
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 14:06:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23-20020a17090a591700b001976d2db364so925637pji.2
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XcdvaCng9FOAEUwEM752oQTsKp7wO8UtsrtvTvd7Atk=;
        b=LhcKmSl3aTohEmXgs+IQB2/khzXdhw5WBw6BcvXK38HLHoblakIFGnzW8dngvn9nak
         6mYmlKAwnSJv16pX7LS+P7vuE3Zvl9FPz+4sULh0X2zeKjQTGcBpivIDfE92IChwzPEF
         K1lYp11kCQsNtTVAiaMUocKnfDZVXgiUSTjjxiiZru8t7a3zPbyDjMOydtwTuLTto1tC
         cLP7nrnWHIgDVrGAtSBTe+1xnzkOG1h7MLwUsZPcTllo02oX3w+JQYAW3eh/FApxy0Rg
         mfswXHW1SeAVoUadPALWA22S8zR9tDqW4pFuuYV4vgjcJawYKiCeoP3dtzlFbBpEDM0a
         LdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XcdvaCng9FOAEUwEM752oQTsKp7wO8UtsrtvTvd7Atk=;
        b=XbM6hu9hM0m+7pP4sD7XPdTKnVFzZc6FG67UoW24gp0blxkigRWvM+U2dofN4r/cJC
         KcSNMKEo1qZ8l0bG/y8lZNRiLmZJRhKwUr7Ifqvg7ChWOMIp2cz6E14YGOQeuZvJ7glm
         1zoZs+9s2rr7tbsN0HY2QUb+SA2Fcox9jsOUqKxBxwXfEbEfF0VgC8akMprIQz8k9FHc
         vGkqpLbn7mmLTHAhbsSTqmkL5qd8GZtU05qGaaX22gsAKm7tdKwpBj4VVBHQ6qT5D5Cr
         V7yxxKkZvw4WdPINTSCzl746RhrMUafRZlml8cir07WDC88cVQCN0aP71a+4OjdxQFYu
         rlAg==
X-Gm-Message-State: AOAM530hXnMmZ0/2jXZS7lZwDD1B7lMahPU0z3XlwWXh7PjZDtMNvMoE
        q+LNGZIikXVfrFz2+WfHb6OwgJ7E87LGCg==
X-Google-Smtp-Source: ABdhPJyYH1s2i3HfOPJIZRH+RtyJJg78EOVtkM9t65i+UYvvNqVRCpzCrAaiE1+8/6orpJR1Jr5NBQ==
X-Received: by 2002:a17:90b:1644:: with SMTP id il4mr1119135pjb.43.1632171979407;
        Mon, 20 Sep 2021 14:06:19 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id w5sm16032561pgp.79.2021.09.20.14.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:06:18 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:06:15 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        shuah@kernel.org, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
Subject: Re: [PATCH v2 1/2] KVM: arm64: vgic: check redist region is not
 above the VM IPA size
Message-ID: <YUj3x61sT+TlxBd3@google.com>
References: <20210910004919.1610709-1-ricarkol@google.com>
 <20210910004919.1610709-2-ricarkol@google.com>
 <87sfxzv37z.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfxzv37z.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 01:30:40PM +0100, Marc Zyngier wrote:
> Hi Ricardo,
> 
> On Fri, 10 Sep 2021 01:49:18 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Verify that the redistributor regions do not extend beyond the
> > VM-specified IPA size (phys_size). This can happen when using
> > KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
> > with:
> > 
> >   base + size > phys_size AND base < phys_size
> > 
> > Add the missing check into vgic_v3_alloc_redist_region() which is called
> > when setting the regions, and into vgic_v3_check_base() which is called
> > when attempting the first vcpu-run. The vcpu-run check does not apply to
> > KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
> > before the first vcpu-run. Finally, this patch also enables some extra
> > tests in vgic_v3_alloc_redist_region() by calculating "size" early for
> > the legacy redist api.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
> >  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
> >  2 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index a09cdc0b953c..055671bede85 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	struct vgic_dist *d = &kvm->arch.vgic;
> >  	struct vgic_redist_region *rdreg;
> >  	struct list_head *rd_regions = &d->rd_regions;
> > -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
> > +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> > +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE :
> > +			nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
> >  	int ret;
> >  
> >  	/* cross the end of memory ? */
> > @@ -834,6 +836,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	if (vgic_v3_rdist_overlap(kvm, base, size))
> >  		return -EINVAL;
> >  
> > +	if (base + size > kvm_phys_size(kvm))
> > +		return -E2BIG;
> > +
> >  	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
> >  	if (!rdreg)
> >  		return -ENOMEM;
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..5afd9f6f68f6 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> 
> How about vgic-v2? From what I can see, the placement of the
> distributor and CPU interface should be subjected to the same checks
> (see vgic_v2_check_base()).
> 

Yes, gic-v2 has the same problem. Alexandru first mentioned it here:

  https://lore.kernel.org/kvmarm/5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com/

I'm now working on the next version of the patch which applies to gic-v2
as well.

Thanks,
Ricardo

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
