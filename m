Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C763A51A5BC
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353309AbiEDQnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 12:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243438AbiEDQnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 12:43:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12F02E9E3
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 09:39:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d17so1926060plg.0
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 09:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m1io7k35g0XkxBE66aLJmCdfAolmvIrbMMfT0zopegk=;
        b=NLb2jf/Au5xzZ7oXie6CwJZPh2AlRsupNDu2fSb1lWW/BldJTRHdf+XcKva/rpFWTT
         91pmoaVlPGdWS9TezpYbWPv/Xkq3T903F1K1828RMOkEVK6DwrQJqSChuGoQgpSK5DH2
         nBZUo/muE6yWD3J6Gj2FCBSNbV5YboygeEbAjtEJKu5elGxXLW62ml+JUIcWM0yUoIom
         0vauUwCpaYPYucnNCJZLfKZkZ4NVx6V+qT4RovPsdM6YuIq4Mjpd+G6+BvP/dSOa4tZV
         fNwijU/J8STzHJGfUwB5RqR30kEqVh/G/wtaEf+I2kSsgXJ8XfxN0ZrIK+tWandqhbEC
         Ihaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m1io7k35g0XkxBE66aLJmCdfAolmvIrbMMfT0zopegk=;
        b=YikqxPJM0zGm6ds2Iyt8Cu2gYQUtYyEF39KSZ1wBnWe/7B0RH5iQxFO0fcJIA0eh7h
         gJbglvMeyXhm0u2+/tJoufcKAwZJ3hL2oUc3d4kcP/1yqGB9NR8zgssNVe5zP2B30l1U
         2ZbGCx3z2ofqjrP1G7ZJzCKyfDsYk6cmmo9gluCpX0cvkJcHQIJuqYwO3lMeWEtpsX6o
         dluSCDvXNhaXqqQe9P2MAcLkK0XQX2ESppArFToPVDSCzyFi6ERTLOZCAnb6Q+a3rZPV
         rvCGqjDke7SNo3gdV+sPr2yuHF+8hhLmoyEtRFuuF60/CL6H60Xn5W2im8absz5gdwga
         XOFg==
X-Gm-Message-State: AOAM533TeYTs2gWeylDy416Vmgu16AtA8VaNDWxTc1FatokIR5He0gbD
        lDhLXxJAQVGL2kBtQCzbYKSg6Q==
X-Google-Smtp-Source: ABdhPJwrGW7n1baZfamUHku5h2p2HjtP2KsLnmxX+a/cSxQ3eqCQQFzgZdqdKZBpyvIEx9EZY+vziw==
X-Received: by 2002:a17:90b:1b47:b0:1dc:3c0a:dde3 with SMTP id nv7-20020a17090b1b4700b001dc3c0adde3mr389278pjb.52.1651682368881;
        Wed, 04 May 2022 09:39:28 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090ae28500b001d960eaed66sm3499510pjz.42.2022.05.04.09.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:39:27 -0700 (PDT)
Date:   Wed, 4 May 2022 09:39:24 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic: Check that new ITEs could be
 saved in guest memory
Message-ID: <YnKsPFnQCcEpX0qC@google.com>
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-2-ricarkol@google.com>
 <da752e67-1fff-e27f-bcaf-e29aaa536532@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da752e67-1fff-e27f-bcaf-e29aaa536532@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 07:14:24PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 4/27/22 20:48, Ricardo Koller wrote:
> > Try to improve the predictability of ITS save/restores by failing
> > commands that would lead to failed saves. More specifically, fail any
> > command that adds an entry into an ITS table that is not in guest
> > memory, which would otherwise lead to a failed ITS save ioctl. There
> > are already checks for collection and device entries, but not for
> > ITEs.  Add the corresponding check for the ITT when adding ITEs.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 51 ++++++++++++++++++++++++----------
> >  1 file changed, 37 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 2e13402be3bd..e14790750958 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -894,6 +894,18 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
> >  	return update_affinity(ite->irq, vcpu);
> >  }
> >  
> > +static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
> > +{
> > +	gfn_t gfn = gpa >> PAGE_SHIFT;
> > +	int idx;
> > +	bool ret;
> > +
> > +	idx = srcu_read_lock(&its->dev->kvm->srcu);
> > +	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> > +	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Check whether an ID can be stored into the corresponding guest table.
> >   * For a direct table this is pretty easy, but gets a bit nasty for
> > @@ -908,9 +920,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> >  	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
> >  	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
> >  	int esz = GITS_BASER_ENTRY_SIZE(baser);
> > -	int index, idx;
> > -	gfn_t gfn;
> > -	bool ret;
> > +	int index;
> >  
> >  	switch (type) {
> >  	case GITS_BASER_TYPE_DEVICE:
> > @@ -933,12 +943,11 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> >  			return false;
> >  
> >  		addr = base + id * esz;
> > -		gfn = addr >> PAGE_SHIFT;
> >  
> >  		if (eaddr)
> >  			*eaddr = addr;
> >  
> > -		goto out;
> > +		return __is_visible_gfn_locked(its, addr);
> >  	}
> >  
> >  	/* calculate and check the index into the 1st level */
> > @@ -964,16 +973,30 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> >  	/* Find the address of the actual entry */
> >  	index = id % (SZ_64K / esz);
> >  	indirect_ptr += index * esz;
> > -	gfn = indirect_ptr >> PAGE_SHIFT;
> >  
> >  	if (eaddr)
> >  		*eaddr = indirect_ptr;
> >  
> > -out:
> > -	idx = srcu_read_lock(&its->dev->kvm->srcu);
> > -	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> > -	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > -	return ret;
> > +	return __is_visible_gfn_locked(its, indirect_ptr);
> > +}
> > +
> > +/*
> > + * Check whether an event ID can be stored in the corresponding Interrupt
> > + * Translation Table, which starts at device->itt_addr.
> > + */
> > +static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *device,
> > +		u32 event_id)
> > +{
> > +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> > +	int ite_esz = abi->ite_esz;
> > +	gpa_t gpa;
> > +
> > +	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
> > +	if (event_id >= BIT_ULL(device->num_eventid_bits))
> > +		return false;
> > +
> > +	gpa = device->itt_addr + event_id * ite_esz;
> > +	return __is_visible_gfn_locked(its, gpa);
> >  }
> >  
> >  static int vgic_its_alloc_collection(struct vgic_its *its,
> > @@ -1061,9 +1084,6 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	if (!device)
> >  		return E_ITS_MAPTI_UNMAPPED_DEVICE;
> >  
> > -	if (event_id >= BIT_ULL(device->num_eventid_bits))
> > -		return E_ITS_MAPTI_ID_OOR;
> I would put
>     if (!vgic_its_check_event_id(its, device, event_id))
>         return E_ITS_MAPTI_ID_OOR;
> here instead of after since if the evend_id not correct, no use to look
> the ite for instance.

Thanks Eric. Will fix in v2.

> > -
> >  	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
> >  		lpi_nr = its_cmd_get_physical_id(its_cmd);
> >  	else
> > @@ -1076,6 +1096,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	if (find_ite(its, device_id, event_id))
> >  		return 0;
> >  
> > +	if (!vgic_its_check_event_id(its, device, event_id))
> > +		return E_ITS_MAPTI_ID_OOR;
> > +
> >  	collection = find_collection(its, coll_id);
> >  	if (!collection) {
> >  		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
> Besides look good to me
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Eric
> 
