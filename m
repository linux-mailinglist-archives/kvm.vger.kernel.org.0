Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D38D421318
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbhJDPxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 11:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbhJDPxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 11:53:03 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB5CC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 08:51:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q23so14870330pfs.9
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xUHxcFcyLxlbEOzo0/4y2u7gqH4zbLfEbPVenn/dP48=;
        b=Vfp46Kuwavj/NMt2Qg9t7k4RyZbxRURDyGDpz7aAdeKzY2h5om7qWhdP8UtSMxnga2
         e9cuSjRGMR+mHKRJh/IUaMCHudDOu5Td3bYJ8xVrW+0G0ab/3taDA9xrfbngobjQ30rH
         uLgiWs41UV7bDpFnnUWLQdCD9eUV5Sl33zSUfLaqrH1uunSfyooJJed2taMSmC+B9nZ+
         IFKRFpB+EllKnb0UeyzeyaCW+p+1Wu5i3jNrrDLzhWxoFNtHAtcMY5LJjJsUd0yx34G2
         gIfefmc1thscr9AQamZYcakBaGPjX/+UzXcuDGoPhG2i26t220Cv/4R1ASXQivBuDo4f
         aAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xUHxcFcyLxlbEOzo0/4y2u7gqH4zbLfEbPVenn/dP48=;
        b=bbJX2cg7cPR0iSrQgrSqCVIFjH22lFbk/pPiIulI+CpfvKI8eBjJwb5b5YxclZQ917
         qBFL7P+PWemCeNTqiFJ2zxiw6ctjT5anmPvnELVsmbHe1F8rGYGvvM0PPHYrLzvFSHVV
         TtwiGtn60E7tbZirTQytiE5s4dFYvxKsv1EiIEq6YSoovnDo0Fkqc/SL6ukiqrr/cK0E
         C6eBCaOcbcTrM98Xduiny8L0Lr5pZAxr5DlIxBTcYJ/1NUi3NG/Jg1NsbGJakbgUV92w
         mPhajnPo/Y4lTARoWGnXiyCAzbtdLeMkx9qtXAW2nz06O00PXntNfX1YK80eN2MCTc5p
         I4dw==
X-Gm-Message-State: AOAM530n8OdR+HY0U4ahxpC9d8NnD7wDRtn5D5Rkqce1bh2x3GfQBHZj
        DHwkk9ujs/Dppss7rBUQCeeH9g==
X-Google-Smtp-Source: ABdhPJyC+5fhEKyG5XQpAML44RdjCbH4hWjl23Jf1ce6Vi2z9vI9fP3aC3o/6cQ93sYpsLIaRYkC4A==
X-Received: by 2002:a62:4ec6:0:b0:44c:7488:e593 with SMTP id c189-20020a624ec6000000b0044c7488e593mr879676pfb.59.1633362673514;
        Mon, 04 Oct 2021 08:51:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id v13sm2828697pjr.3.2021.10.04.08.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 08:51:12 -0700 (PDT)
Date:   Mon, 4 Oct 2021 08:51:09 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        shuah@kernel.org, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
Message-ID: <YVsi7d4v7WLRRR6c@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
 <87ilygsx8q.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilygsx8q.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 02:14:29PM +0100, Marc Zyngier wrote:
> On Tue, 28 Sep 2021 19:47:56 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Verify that the redistributor regions do not extend beyond the
> > VM-specified IPA range (phys_size). This can happen when using
> > KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
> > with:
> > 
> >   base + size > phys_size AND base < phys_size
> > 
> > Add the missing check into vgic_v3_alloc_redist_region() which is called
> > when setting the regions, and into vgic_v3_check_base() which is called
> > when attempting the first vcpu-run. The vcpu-run check does not apply to
> > KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
> > before the first vcpu-run. Note that using the REDIST_REGIONS API
> > results in a different check, which already exists, at first vcpu run:
> > that the number of redist regions is enough for all vcpus.
> > 
> > Finally, this patch also enables some extra tests in
> > vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
> > redist api: like checking that the REDIST region can fit all the already
> > created vcpus.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
> >  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index a09cdc0b953c..9be02bf7865e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	struct vgic_dist *d = &kvm->arch.vgic;
> >  	struct vgic_redist_region *rdreg;
> >  	struct list_head *rd_regions = &d->rd_regions;
> > -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
> > +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> > +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
> > +			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
> >  	int ret;
> >  
> >  	/* cross the end of memory ? */
> > @@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  
> >  	rdreg->base = VGIC_ADDR_UNDEF;
> >  
> > -	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> > +	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
> >  	if (ret)
> >  		goto free;
> >  
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 21a6207fb2ee..27ee674631b3 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> 
> Why can't we replace these two checks with a single call to your new
> fancy helper?

ACK using the new helper (on rdreg base and size).

Thanks,
Ricardo

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
