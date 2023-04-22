Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B616EBB2D
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 22:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjDVUiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 16:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDVUiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 16:38:02 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6292128
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:38:01 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a950b982d4so142015ad.0
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682195880; x=1684787880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BMpyicsnV64UZ0JHKcTDU3PMlR+2xg6SffWwdhUOnrE=;
        b=SMwl4QKO43Bho+gaOVe9PpkGvlnggq8Qn2IDZYIACTHJcSgrdvaqHz7PROmcBul3YC
         ZD7mz+izb7ZHNSNyq/Je4fT2Hbb720aRd4f/bIZDDEhVOEc8Vu0OfVLW7z+BP7L8jw6s
         E7ZOnee5IP+e21M2HxOF9svVJ6OiQSPc9X3rXzUKIyAL3GgaAlPTfl0rcWK9XWmKlMFw
         NiSQPvEkbLxkyuZedN04hPlCAa2gb6seCCzLybuuGv2KhlNGGVD+sNCh9tZcF90F1omh
         LC4K0DyZs/zKpRGHHoSPx4R2WehxrwblvvgmFR2fwrJKF6YFBXmS/CJ8uHh0X7dGkbeh
         J4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682195880; x=1684787880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMpyicsnV64UZ0JHKcTDU3PMlR+2xg6SffWwdhUOnrE=;
        b=iXDWUvAttiR9Uf283N+9hSqA6gKFKiAX7XbWLPzOrMnMUZHe2IwUuGxbCO0GdA88NC
         QNQSBcEDm6RlbTwTTclLQj3rqrpw8nrBX8No4sxABFJ2jc+WoKXcr5ltdoU5fbUFRvMD
         lVezgsMgR5H0V8XruF1zzwHMUF3sgZmQRkNYhZ1VROIfMQRiDcz9JVBDRvBdqcq3teBd
         PFdkZ936z5/5waZPXh5+njh+cyzXNIL5glPOZPei48j2OJBl6qQJtHMLp6NDjOcko9H8
         78+T3Inpx1Ho/1CdwI8H9O5qJI5OTAbIspdgJJMhYtH9zwHiiUC57ilLE+ORVpVVajNB
         i7ZA==
X-Gm-Message-State: AAQBX9fSmIWAcaVWvkohH1oB/eqE/sUqU+z/DSzsMvDMx3TnwwEFCJ6G
        x99iz7nwBIgQOYtGBCw92muRBh5BrMZB5jnqCEgzRQ==
X-Google-Smtp-Source: AKy350Zv82JB8pbXyRQM1aFbU+pPitTSNnATS+bUJAGbOHxLAstpvf7Lt002l4v9ScuqXyc8IYgNew==
X-Received: by 2002:a17:903:6c8:b0:1a9:1ff6:1139 with SMTP id kj8-20020a17090306c800b001a91ff61139mr159785plb.19.1682195880544;
        Sat, 22 Apr 2023 13:38:00 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t207-20020a635fd8000000b00517f165d0a6sm4315657pgb.4.2023.04.22.13.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 13:38:00 -0700 (PDT)
Date:   Sat, 22 Apr 2023 13:37:57 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, pbonzini@redhat.com, maz@kernel.org,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <ZERFpWDUt3WkI5kp@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-5-ricarkol@google.com>
 <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
 <ZEQ+9kyXcQS+1i81@google.com>
 <ZEREQrqmZeLtgbPw@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEREQrqmZeLtgbPw@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 22, 2023 at 08:32:02PM +0000, Oliver Upton wrote:
> On Sat, Apr 22, 2023 at 01:09:26PM -0700, Ricardo Koller wrote:
> > On Mon, Apr 17, 2023 at 02:18:26PM +0800, Gavin Shan wrote:
> > > > +	/* .addr (the IPA) is irrelevant for an unlinked table */
> > > > +	struct kvm_pgtable_walk_data data = {
> > > > +		.walker	= &walker,
> > > > +		.addr	= 0,
> > > > +		.end	= kvm_granule_size(level),
> > > > +	};
> > > 
> > > The comment about '.addr' seems incorrect. The IPA address is still
> > > used to locate the page table entry, so I think it would be something
> > > like below:
> > > 
> > > 	/* The IPA address (.addr) is relative to zero */
> > > 
> > 
> > Extended it to say this:
> > 
> >          * The IPA address (.addr) is relative to zero. The goal is to
> >	   * map "kvm_granule_size(level) - 0" worth of pages.
> 
> I actually prefer the original wording, as Gavin's suggestion makes this
> comment read as though the IPA of the walk bears some degree of
> validity, which it does not.
> 
> The intent of the code is to create some *ambiguous* input address
> range, so maybe:
> 
> 	/*
> 	 * The input address (.addr) is irrelevant for walking an
> 	 * unlinked table. Construct an ambiguous IA range to map
> 	 * kvm_granule_size(level) worth of memory.
> 	 */
> 

OK, this is the winner. Will go with this one in v8. Gavin, let me know
if you are not OK with this.

Thank you both,
Ricardo

> -- 
> Thanks,
> Oliver
