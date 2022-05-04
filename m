Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3582C51AA09
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355866AbiEDRUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 13:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355707AbiEDRR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 13:17:26 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE3E15838
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 10:01:37 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k1so1956786pll.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 10:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djBQAYzvnQPbFywsSGq+qFa7/2dyAx9kLA8TA/q8bGo=;
        b=EQnT+GQA+QopGtj4oWguMQr9Pf+0kt81+7p6or40nKj8qqLlnW/2CzJ3KRMNOC8cK4
         BM+qNmTjnKOm4b6OH3BHOdD29tTWaXf+h1wwwhkk4irzdLAb7MPqlQyH3oKNCyIZZIkZ
         hR3Bt2rL7emEA7K+RafpNp2Auv2bMcaj7Sz0mhrVukvWu2FTc2O5e94QXC7DpTEsAE+S
         WCdfOcTqCYp1fzRj9sbueDW12WgrwJudP4eO6Mgym5pclcdcld+UFVd81mbhdueAhPjX
         21TOTzw0mw/btHPkg1VZxJmkjhIy7SZoaJd4CWqeNoEUZtmyfO/bA+1/hlhv5dEUFi6E
         6ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=djBQAYzvnQPbFywsSGq+qFa7/2dyAx9kLA8TA/q8bGo=;
        b=2reJQvQe8hrH3rdQeQ3efqnEStgBfPWvMku2BH476HHMNhUUq6SZCuRvfKdwxb5ShA
         Ohz40p4AA+cxyJCJmps0DoinLsBHWG1Y5iL48M1AAfwyrtQE2stL1Kqng9X6sbjfJLpd
         gXUD/W8mIpD/iNQ2ZXU6jSka4Qa2b5WZoV3XIAWEXJBKTS+p/jf4dSMFtO3UvM++Cs/U
         ck575/w8Y67paHV+J6Z3G2S364pwLTCPj5Ku4PMi1BXB7Mke9sSKBRbs5Npwv6tO5AjC
         Tn9fuOIkr8dcehAz41/cvz0uwTSoZ6sA+jNOLkqp4Z4JgjtlWdP1PRifg2S0zMmSvuyR
         /rog==
X-Gm-Message-State: AOAM533BZtKuSC3pHY/1i4brJLTc124c4n8gTJE1Gtprw2tu9fImTvEZ
        POpHU+IYyP8WbobjifOG98/uKiG1PBOntQ==
X-Google-Smtp-Source: ABdhPJyHGZtJJE7ghhsABggO5pUuiqRUIGw57QKov6Pnk6fPav91MXGYb4OeJ1ZzBHb+JxPxPFrHzw==
X-Received: by 2002:a17:902:f682:b0:15e:951b:8091 with SMTP id l2-20020a170902f68200b0015e951b8091mr19189721plg.106.1651683697042;
        Wed, 04 May 2022 10:01:37 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0050dc76281fcsm8401395pff.214.2022.05.04.10.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 10:01:36 -0700 (PDT)
Date:   Wed, 4 May 2022 10:01:32 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring
 ITS tables
Message-ID: <YnKxbNuf4U1Zgjx5@google.com>
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-3-ricarkol@google.com>
 <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
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

On Tue, May 03, 2022 at 07:14:19PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 4/27/22 20:48, Ricardo Koller wrote:
> > Try to improve the predictability of ITS save/restores (and debuggability
> > of failed ITS saves) by failing early on restore when trying to read
> > corrupted tables.
> >
> > Restoring the ITS tables does some checks for corrupted tables, but not as
> > many as in a save: an overflowing device ID will be detected on save but
> > not on restore.  The consequence is that restoring a corrupted table won't
> > be detected until the next save; including the ITS not working as expected
> > after the restore.  As an example, if the guest sets tables overlapping
> > each other, which would most likely result in some corrupted table, this is
> > what we would see from the host point of view:
> >
> > 	guest sets base addresses that overlap each other
> > 	save ioctl
> > 	restore ioctl
> > 	save ioctl (fails)
> >
> > Ideally, we would like the first save to fail, but overlapping tables could
> > actually be intended by the guest. So, let's at least fail on the restore
> > with some checks: like checking that device and event IDs don't overflow
> > their tables.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index e14790750958..fb2d26a73880 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
> >  	if (!collection)
> >  		return -EINVAL;
> >  
> > +	if (find_ite(its, dev->device_id, event_id))
> > +		return -EINVAL;
> Unsure about that. Nothing in the arm-vgic-its.rst doc says that the
> KVM_DEV_ARM_ITS_RESTORE_TABLES ioctl cannot be called several times
> (although obviously useless)

In that case, maybe we could ignore the new repeated entry? or
overwrite the old one?  find_ite() only returns the first (device_id,
event_id) match. So, it's like the new one is ignored already.  The
arm arm says this about MAPI commands in this situation:

    If there is an existing mapping for the EventID-DeviceID
    combination, behavior is UNPREDICTABLE.

And, just in case, the main reason for adding this check was to avoid
failing the next ITS save. The idea is to try to fail as soon as
possible, not in possibly many days during the next migration attempt.

> > +
> > +	if (!vgic_its_check_event_id(its, dev, event_id))
> > +		return -EINVAL;
> > +
> >  	ite = vgic_its_alloc_ite(dev, collection, event_id);
> >  	if (IS_ERR(ite))
> >  		return PTR_ERR(ite);
> > @@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
> >  				void *ptr, void *opaque)
> >  {
> >  	struct its_device *dev;
> > +	u64 baser = its->baser_device_table;
> >  	gpa_t itt_addr;
> >  	u8 num_eventid_bits;
> >  	u64 entry = *(u64 *)ptr;
> > @@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
> >  	/* dte entry is valid */
> >  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
> >  
> > +	if (find_its_device(its, id))
> > +		return -EINVAL;
> same here.
> > +
> > +	if (!vgic_its_check_id(its, baser, id, NULL))
> > +		return -EINVAL;
> > +
> >  	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
> >  	if (IS_ERR(dev))
> >  		return PTR_ERR(dev);
> Thanks
> 
> Eric
>

Thanks,
Ricardo
