Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4888A6EC21B
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 21:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDWTrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 15:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWTrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 15:47:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0FAE51
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 12:47:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a7ff4a454eso600495ad.0
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 12:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682279272; x=1684871272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IH0UhTga2Ggf3gBi/LWbIB66Yn9BwYN3FLa4+Rl5znE=;
        b=46oMTjfOUEOW0USYxhExI9nVbbYygkR+I6flk2OKspSTPOE3WBCGf+M9mM/Vswq2qK
         4qsfPyxK7+5xcMEfEcZ8TrHNp1d4v5bpXNKZQBdcbR0IqtIlDxlCYcSuIHzu1Ue498CQ
         6Xqsb+EH4pTlD2yxIWAPp77cIDTurO9sXcLlmWnQOjNHccnFzoWKrCsDCyBzCOtpmpSp
         F2NJ1osEoWFxkiAx8Q66kQ5uzXZHmgimhPyzl9cA2/s3yy0BssVcrbpQBbMEogBbdivS
         3xKWWj0qMwqZaBeS3mGRGL1tcafNbmuhYn8jMdatau7dFZ9uu0vq2i37dUEDkESaEwXR
         hQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682279272; x=1684871272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IH0UhTga2Ggf3gBi/LWbIB66Yn9BwYN3FLa4+Rl5znE=;
        b=jANn09latxBdYcKe6ygD24yQ3wNRhJj654IjjBK8vDaawiTP0JOnFR1wod5rgv+TUg
         MJWKa7uYuK5i5xRq25vTPLO4fgbec+aIjKPlnHAq2X34sey4mwvHA8dXoTNELdESsIiB
         IGdp6ck/oQkgtJCgcs0gGqMC4Nr0VmGOVA+TL93m+l/nTXxcqgoqHnLtiMjvXwIrVaUQ
         AYiRP1R1X+DPu/ib89LA47es6WB2BGicCLjJGQWBT6/mjEqz/RGtOd59WV0zKLfhh3pO
         PbHzB/OnoguPEU9d0Oj61xVlp9U/jbD0ncNulK9t/O6aNEF9wnO/GQPXSnGPrkPK0aXw
         dthQ==
X-Gm-Message-State: AAQBX9cMqggs0a8qYmXCgBFehLHF1lRqMqcRJF63B6vqRderYVrZhniM
        ITcFx8woSV5OLBURcrjHHJ+7pw==
X-Google-Smtp-Source: AKy350YCxJSlp2GFMyn7d8p+/8XtIli5TcQQGF247uJqgvBOckKitJhsjprD1GxzxwFMJp4aFF8gsQ==
X-Received: by 2002:a17:902:7c0f:b0:1a6:c161:37d7 with SMTP id x15-20020a1709027c0f00b001a6c16137d7mr298917pll.5.1682279272112;
        Sun, 23 Apr 2023 12:47:52 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id h125-20020a628383000000b0063b87717661sm6057262pfe.85.2023.04.23.12.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:47:51 -0700 (PDT)
Date:   Sun, 23 Apr 2023 12:47:48 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 05/12] KVM: arm64: Refactor
 kvm_arch_commit_memory_region()
Message-ID: <ZEWLZDK39w737qiI@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-7-ricarkol@google.com>
 <2819bd9d-9a8c-938c-9297-86c1b8614550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2819bd9d-9a8c-938c-9297-86c1b8614550@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 02:41:39PM +0800, Gavin Shan wrote:
> On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > Refactor kvm_arch_commit_memory_region() as a preparation for a future
> > commit to look cleaner and more understandable. Also, it looks more
> > like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> 
> With the following nits addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index efdaab3f154de..37d7d2aa472ab 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >   				   const struct kvm_memory_slot *new,
> >   				   enum kvm_mr_change change)
> >   {
> > +	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> > +
> >   	/*
> >   	 * At this point memslot has been committed and there is an
> >   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
> >   	 * memory slot is write protected.
> >   	 */
> > -	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > +	if (log_dirty_pages) {
> > +
> > +		if (change == KVM_MR_DELETE)
> > +			return;
> > +
> >   		/*
> >   		 * If we're with initial-all-set, we don't need to write
> >   		 * protect any pages because they're all reported as dirty.
> >   		 * Huge pages and normal pages will be write protect gradually.
> >   		 */
> 
> The comments need to be adjusted after this series is applied. The huge pages
> won't be write protected gradually. Instead, the huge pages will be split and
> write protected in one shoot.
>

I see, this comment is a bit confusing. Will update it to this:

                /*
                 * Pages are write-protected on either of these two
                 * cases:
                 *
                 * 1. with initial-all-set: gradually with CLEAR ioctls,
                 */
                if (kvm_dirty_log_manual_protect_and_init_set(kvm))
                        return;
                /*
                 * or
                 * 2. without initial-all-set: all in one shot when
                 *    enabling dirty logging.
                 */
                kvm_mmu_wp_memory_region(kvm, new->id);

Will update the comment to include splitting when introducing eager-splitting
on the CLEAR ioctl (case 1.): "KVM: arm64: Split huge pages during
KVM_CLEAR_DIRTY_LOG".

> > -		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > -			kvm_mmu_wp_memory_region(kvm, new->id);
> > -		}
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +			return;
> > +
> > +		kvm_mmu_wp_memory_region(kvm, new->id);
> >   	}
> >   }
> > 
> 
> Thanks,
> Gavin
> 
