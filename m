Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB434F6E93
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiDFXhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiDFXhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:37:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC9F1E5202
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:35:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kw18so3962426pjb.5
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I9PXYYNYzm+S86XiDohEIIjS7uODRi+inUQ+moEyXoI=;
        b=AHE5qokLSDutFR7PI8eQWDwxmxlJzrKafDW0/fFJ5EL9eN5tG8Ib+nvmPWjLccswFO
         LeBMTI+eySDNC30XqN9ueFi938W7I4yq1ZS7LJMpYY2vAy6DD2krEQIuakJkRHmOJJD2
         2qW51WjOrAwtImJkE7bXt2zuDlMIeuMjonTWrp3LI/f6WeyMKYbGgBfORrKDMu4Y+ncd
         mtIpb5SSZ1XD4hMusUwFvUsQKFZarjSi4MYhbgkAr9DFzNmGqd8C3uqsV2cJUaXlgJ2q
         zwFw0KCxkoz9Gs0Mw+T9ysOWDwHhd4H9pUeN/qtavuciYsE4ZXb/RYcYThkdLG2hffah
         uAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I9PXYYNYzm+S86XiDohEIIjS7uODRi+inUQ+moEyXoI=;
        b=TyQsgD1oVRKGA4bjAnb1w2Ti2yfHEhvG4scZAABKGP1rNcO1IfvXYgvlhOTifPDhUB
         mx2/2yznXYyPGBM+M1DS7IQuudY/1Q7Xt2vw+0lKtP10ORD8Uhh1DnpfXaAx/YfssJLb
         u0xCefuCQYpLgJmyTXK5CorQzVRj2SzDdqDfW2DddoeFGJvd6PNyeYHYjJlq38qjxFnB
         i/XaCgYGR2eZkxvLf+jG4uryu5BBTcUUrnMPa3MfdCxBgzEuYSJxDG6DNFCC6k3A9XrW
         6D6kWsUtMcTYeLZND2zvXKYOTA1nFJw3+VJtwpfITEHvOdDI7eKIitL6Z4ypUUMeLYY9
         LzBg==
X-Gm-Message-State: AOAM530osWI6L4Dy2Ioq5f78JAd0g9riZTeCvJR/smW22HDuh/VErsmM
        oR6tzYNqsM7hFA4Ci/TjQMNcig==
X-Google-Smtp-Source: ABdhPJy16UR83rlEq9AhsRifZ1oBb2UHMARMltuDdLjmXLfxa1VkMpUIcuOE413C9cxMtZqmFWNWpw==
X-Received: by 2002:a17:902:d48f:b0:156:bddf:ef8 with SMTP id c15-20020a170902d48f00b00156bddf0ef8mr11085044plg.83.1649288149820;
        Wed, 06 Apr 2022 16:35:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m15-20020a638c0f000000b003827bfe1f5csm17030090pgd.7.2022.04.06.16.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:35:49 -0700 (PDT)
Date:   Wed, 6 Apr 2022 23:35:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 045/104] KVM: x86/tdp_mmu: make REMOVED_SPTE
 include shadow_initial value
Message-ID: <Yk4j0cCR5fnQKw1F@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
 <3f93de19-0685-3045-22db-7e05492bb5a4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f93de19-0685-3045-22db-7e05492bb5a4@redhat.com>
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

On Tue, Apr 05, 2022, Paolo Bonzini wrote:
> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> > @@ -207,9 +209,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> >   /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> >   static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> > +/*
> > + * See above comment around REMOVED_SPTE.  SHADOW_REMOVED_SPTE is the actual
> > + * intermediate value set to the removed SPET.  When TDX is enabled, it sets
> > + * the "suppress #VE" bit, otherwise it's REMOVED_SPTE.
> > + */
> > +extern u64 __read_mostly shadow_init_value;
> > +#define SHADOW_REMOVED_SPTE	(shadow_init_value | REMOVED_SPTE)
> 
> Please rename the existing REMOVED_SPTE to REMOVED_SPTE_MASK, and call this
> simply REMOVED_SPTE.  This also makes the patch smaller.

Can we name it either __REMOVE_SPTE or REMOVED_SPTE_VAL?  It's most definitely
not a mask, it's a full value, e.g. spte |= REMOVED_SPTE_MASK is completely wrong.

Other than that, 100% agree with avoiding churn.
