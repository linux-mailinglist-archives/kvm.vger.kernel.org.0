Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2ED578057
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 12:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiGRK5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 06:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiGRK5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 06:57:19 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3A91C920
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 03:57:18 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id i188-20020a1c3bc5000000b003a2fa488efdso105582wma.4
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 03:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l+h2HYoyNpOTO71DMUTeHgfk/XO5dsFlakdohwm5DuU=;
        b=h1D8GxvDEHEp7hVSx8zz/boM9eIlbBFd3sUSsLcdyQ9XnBYcgPl95iHw4cQm6tt8Vf
         MPs79MZF3K4E9gZ2AGN0f+UFjTB4hU8z+Q7ziriYEakNbclvFu3z4eEy0jqDw04HshGP
         w/vdnBuuunuSFqMcPqkxy72xlOX2wztN3O3IceMuK6xtj2SB/TYr/QC+jY7q5xwe8Tg7
         Nhw4VAiUs5FQ/NDJsMnZkENeDju2dbcTHm5gfR7TshrGArFdjEPrBu0PW+02jJtB+NFw
         o6R6XkYuX5o1/KZyLqJr2yHurhS7R2mx2IhDiNEuFGh01u32GySQJ9TEYwxQJBuB2K6N
         UQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l+h2HYoyNpOTO71DMUTeHgfk/XO5dsFlakdohwm5DuU=;
        b=BMBC+vNwBLPt/CvCgXOWeQ0ACYVWtjXddULs43KtiCFRuGbWe4aKYh30GiEbPf8R3z
         nS5pCOWx//DFa1vJM64w6+mT0YeI9nxJ11xsNAcDy2yC5BWkQPlxNGUVUMo7lNDV6ZuF
         FRGcPisER7Zs4X0CR5i2tBFqfmfbf/yakJuFaJY4AcqyF399vu+l2Hh0l5El1+L2g8S9
         adIuntFV4yayGPLU+Un1oDkNpbGdMvB2oXJ99ao8ftMXsUdilvVa7QTwdqRk1CAnLxqL
         +QGKCc4EUxHEvXvlZdi675YWSHwiXf9BAu0plq51ULFBraPtTdHvxiu+mUdTng1Q+ENT
         rZsw==
X-Gm-Message-State: AJIora+RrJYNAiYEnTypHvDVlUsRRg9OOcF1HkMVC9LpiOr8IFNwhXCE
        iLplcKGoPifhKD1yirHeXVD1OQ==
X-Google-Smtp-Source: AGRyM1s/cGj8fdxsA/y4TWPk5jYYyUcQDg5YvtMbBXY2i8ZjsjS6G9zcb8wwxCBGfHjPIxLBqEo4zg==
X-Received: by 2002:a05:600c:1908:b0:3a3:f85:702a with SMTP id j8-20020a05600c190800b003a30f85702amr13559591wmq.157.1658141837060;
        Mon, 18 Jul 2022 03:57:17 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id j9-20020a05600c190900b0039db31f6372sm21111747wmq.2.2022.07.18.03.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 03:57:16 -0700 (PDT)
Date:   Mon, 18 Jul 2022 11:57:13 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 03/24] KVM: arm64: Add flags to struct hyp_page
Message-ID: <YtU8iX6tmTOpxvlJ@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-4-will@kernel.org>
 <YtU74D9fcLCpHHwc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtU74D9fcLCpHHwc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 11:54:24AM +0100, Vincent Donnefort wrote:
> On Thu, Jun 30, 2022 at 02:57:26PM +0100, Will Deacon wrote:
> > From: Quentin Perret <qperret@google.com>
> > 
> > Add a 'flags' field to struct hyp_page, and reduce the size of the order
> > field to u8 to avoid growing the struct size.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h |  3 ++-
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
> >  3 files changed, 12 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > index 0a048dc06a7d..9330b13075f8 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > @@ -7,7 +7,7 @@
> >  #include <nvhe/memory.h>
> >  #include <nvhe/spinlock.h>
> >  
> > -#define HYP_NO_ORDER	USHRT_MAX
> > +#define HYP_NO_ORDER	0xff
> 
> BUG_ON in hyp_page_ref_inc() might now need to test for 0xff/HYP_NO_ORDER
> instead of USHRT_MAX.

My bad, read to quickly, refcount/order... 

> 
> [...]
