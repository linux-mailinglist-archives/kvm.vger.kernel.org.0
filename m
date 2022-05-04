Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A79651AC5F
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 20:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376625AbiEDSKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 14:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354674AbiEDSJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 14:09:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7BD5A083
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 10:25:49 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fv2so1821525pjb.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 10:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vYIF1GyGwPG3U4GpF9XjOLqlSm28mEvmIEMPrLRuvXE=;
        b=fijwwJUwuZbBL9G644JE4yeC1xMPq3T14JnyzAD90uVlIrSl3TY5v/FyHEBWg5ZvyV
         NSYBkTJ6HKs6AuDOTqSqC5I60PPyC4flyYyan3eK6DPr5JQFpd8j5yNKqRYkMuKqbHvi
         W0XVMTbg728zYr7nHtFbcR84MEpIKyVPewL/26leliQknYqnH8otbzrJbVxfhBpWjJ07
         bYrKDsLI4fcjj8jKme2ragFJ3w7fw9BicHPwLT8sXf78FSdQxxqsWb5oLjMoh//hZodQ
         crrWIpUzjgDLQfg78wCjmSrThLTM6NsjHiwGoHb1ZztU2za3PH+82PXlImjK0Lr/nE54
         MW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vYIF1GyGwPG3U4GpF9XjOLqlSm28mEvmIEMPrLRuvXE=;
        b=dm+hq+sMMFW25ELGHEuyiKECKfiXHrRfjMg1rO93K5nAfUFj+v9ouGYbuMvEhxWSYv
         bSxQMyV3W/p+aDvCXx0R0i32537XuKEl9EOf6DTt3eEu0sUL3MN+n1j07Sq9d+uc3qk9
         9qeCdKobLgCAmAfciBkgm2Ei6Hypb6i1YpG0oeENJUP1Ws3oZnsc2xxK5ZRE+VU6iecO
         9+oiETqzSiLHZL44UYduaiIqur1ADtb+hhQfnHLYzQPJO7ugG/P0mA5Yj65rj7kf/V9Z
         l+9R8uPx+eAUssxV0ZjZY/aCBn96K00hEnqhpo15A1TpYWCm2zoXN4ZVoMXWXBwZRtmo
         qhxw==
X-Gm-Message-State: AOAM5332eY/lJ+dY16Flxb8Szi4uWPydw07NaJdn369MI9kkzDwW4aQ5
        8RYtwGnnmipHDbK/StLKPiqUVBTXiyTmhg==
X-Google-Smtp-Source: ABdhPJz+7raDkIR64Kg4kFnopGRd0za2CrdMaZ6KvTwmUxKeqmwDOi2YYfDuv03xFM1WgMvHgrqrhA==
X-Received: by 2002:a17:90a:730b:b0:1d9:7fc0:47c5 with SMTP id m11-20020a17090a730b00b001d97fc047c5mr628859pjk.60.1651685148311;
        Wed, 04 May 2022 10:25:48 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79042000000b0050dc762814csm8506416pfo.38.2022.05.04.10.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 10:25:47 -0700 (PDT)
Date:   Wed, 4 May 2022 10:25:44 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic: Do not ignore
 vgic_its_restore_cte failures
Message-ID: <YnK3GKIr0WeVxkve@google.com>
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-4-ricarkol@google.com>
 <8cfeae8e-93f3-be10-8743-8d51b89b7a5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cfeae8e-93f3-be10-8743-8d51b89b7a5a@redhat.com>
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

On Tue, May 03, 2022 at 07:40:46PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 4/27/22 20:48, Ricardo Koller wrote:
> > Restoring a corrupted collection entry is being ignored and treated as
> maybe precise what is a corrupted ITE (out of range id or not matching
> guest RAM)
> > success. More specifically, vgic_its_restore_cte failure is treated as
> > success by vgic_its_restore_collection_table.  vgic_its_restore_cte uses
> > a positive number to return ITS error codes, and +1 to return success.
> Not fully correct as vgic_its_restore_cte() also returns a bunch of
> generic negative error codes. vgic_its_alloc_collection() only returns
> one positive ITS error code.

Thanks, will clarify this. I was just focusing on that positive ITS
error code being treated as success by the caller.

> > The caller then uses "ret > 0" to check for success. An additional issue
> > is that invalid entries return 0 and although that doesn't fail the
> > restore, it leads to skipping all the next entries.
> Isn't what we want. If I remember correctly an invalid entry corresponds
> to the end of the collection table, hence the break.
> see vgic_its_save_collection_table() and "add a last dummy element with
> valid bit unset".

Ah, definitely. This was incorrect then.

> >
> > Fix this by having vgic_its_restore_cte return negative numbers on
> > error, and 0 on success (which includes skipping an invalid entry).
> > While doing that, also fix alloc_collection return codes to not mix ITS
> > error codes (positive numbers) and generic error codes (negative
> > numbers).
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 35 ++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index fb2d26a73880..86c26aaa8275 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -999,15 +999,16 @@ static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *dev
> >  	return __is_visible_gfn_locked(its, gpa);
> >  }
> >  
> > +/*
> > + * Adds a new collection into the ITS collection table.
> nit: s/Adds/Add here and below
> > + * Returns 0 on success, and a negative error value for generic errors.
> > + */
> >  static int vgic_its_alloc_collection(struct vgic_its *its,
> >  				     struct its_collection **colp,
> >  				     u32 coll_id)
> >  {
> >  	struct its_collection *collection;
> >  
> > -	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
> > -		return E_ITS_MAPC_COLLECTION_OOR;
> > -
> >  	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
> >  	if (!collection)
> >  		return -ENOMEM;
> > @@ -1101,7 +1102,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  
> >  	collection = find_collection(its, coll_id);
> >  	if (!collection) {
> > -		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
> > +		int ret;
> > +
> > +		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
> > +			return E_ITS_MAPC_COLLECTION_OOR;
> > +
> > +		ret = vgic_its_alloc_collection(its, &collection, coll_id);
> >  		if (ret)
> >  			return ret;
> >  		new_coll = collection;
> > @@ -1256,6 +1262,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
> >  		if (!collection) {
> >  			int ret;
> >  
> > +			if (!vgic_its_check_id(its, its->baser_coll_table,
> > +						coll_id, NULL))
> > +				return E_ITS_MAPC_COLLECTION_OOR;
> > +
> >  			ret = vgic_its_alloc_collection(its, &collection,
> >  							coll_id);
> >  			if (ret)
> > @@ -2497,6 +2507,10 @@ static int vgic_its_save_cte(struct vgic_its *its,
> >  	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
> >  }
> >  
> > +/*
> > + * Restores a collection entry into the ITS collection table.
> > + * Returns 0 on success, and a negative error value for generic errors.
> > + */
> >  static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> >  {
> >  	struct its_collection *collection;
> > @@ -2511,7 +2525,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> >  		return ret;
> >  	val = le64_to_cpu(val);
> >  	if (!(val & KVM_ITS_CTE_VALID_MASK))
> > -		return 0;
> > +		return 0; /* invalid entry, skip it */
> >  
> >  	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
> >  	coll_id = val & KVM_ITS_CTE_ICID_MASK;
> > @@ -2523,11 +2537,15 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> >  	collection = find_collection(its, coll_id);
> >  	if (collection)
> >  		return -EEXIST;
> > +
> > +	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
> > +		return -EINVAL;
> > +
> >  	ret = vgic_its_alloc_collection(its, &collection, coll_id);
> >  	if (ret)
> >  		return ret;
> >  	collection->target_addr = target_addr;
> > -	return 1;
> > +	return 0;
> >  }
> >  
> >  /**
> > @@ -2593,15 +2611,12 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
> >  
> >  	while (read < max_size) {
> >  		ret = vgic_its_restore_cte(its, gpa, cte_esz);
> > -		if (ret <= 0)
> > +		if (ret < 0)
> >  			break;
> >  		gpa += cte_esz;
> >  		read += cte_esz;
> >  	}
> >  
> > -	if (ret > 0)
> > -		return 0;
> > -
> >  	return ret;
> >  }
> >  
> Thanks
> 
> Eric
> 

Thanks,
Ricardo
