Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE25D76A3DB
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 00:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjGaWCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 18:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjGaWCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 18:02:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B583E49
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 15:02:17 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bba2318546so42906975ad.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 15:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690840937; x=1691445737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZXwDT7lSpqyD7OTKZuyX3OzGyE3jIs1AadqKpDkW4k=;
        b=tOj5Wt8YaFbV9ywN8nWXCNvxhO7wQxvdH1VuIunjBBAFvrIRXATc1vv1fhcuEb/L70
         6vI9iaVn3df/+UxPaojvO5Rgor46IcxGgiooU1s5haTR0pdIPEwSRwcvZPAXGyFiH3bw
         yaFnfDJ4DE+SoVu9fyI8CWeoD2XZ2V0l7OrojyOM4pj17/rkfyxy9wlEneag46uAQUZ6
         FYmKPIhBnvgFvsP3VgHD5an3SyGSlka7JM5wUfGW++JWly0Ywc3x1k5DWdL3frlpoAfc
         VHK8LiITN+JKqZJy9ty314CUeJBBEZGXdkDUPtSeoOOnQYNH5vnTVmuxi6DPv/+A/NJk
         VRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690840937; x=1691445737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZXwDT7lSpqyD7OTKZuyX3OzGyE3jIs1AadqKpDkW4k=;
        b=DBrxE8ZXieaJmEdV1XU2i5SR4Y04s8+ToJXYymr6232j5cQe5DT8XuAOkNvkzsqFyX
         upHr5Kak6e2yZAHtCXllgxhIvwixRO02DllAEaUz90NDVeae4OiOptOULHKW1PeL7QHY
         OG80MnQnCI2xhkL/BDuox5WzJ12+pT7lbBShTEJ2GYKsCbs1cwzaiIMQ2H5bS3VxB0Cq
         rDvyZYOjOo5HACoqbH06hSkQHXqoIi/kQrQ/GPGEcw+DSK0t7isAhySWFL89lPQv5oe6
         ZyM1RdcZYUEvWPukAyHXfmI/4m6i6yHoHlkl9SNagyTXUPD8XRNnL3KQTzRx10CmhHom
         UK3g==
X-Gm-Message-State: ABy/qLbpSeTxb785yGfTpt4mZ0IfngXXTrQ7TrkY8LvV8ZwnG0WAALhw
        xC4LUwMpoLHDeBtHSLdpxv2LLg==
X-Google-Smtp-Source: APBJJlG/7TIXArFl9nzqfXiuLGmMf5q7GAr+Ricr4oDD2rfNy25Ng3+2Iw3hd1zL6TZ5ztIEFXv3mQ==
X-Received: by 2002:a17:902:cec7:b0:1bc:6c8:cded with SMTP id d7-20020a170902cec700b001bc06c8cdedmr8032979plg.67.1690840936879;
        Mon, 31 Jul 2023 15:02:16 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id f16-20020a170902ce9000b001b016313b1dsm9052782plg.86.2023.07.31.15.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 15:02:16 -0700 (PDT)
Date:   Mon, 31 Jul 2023 22:02:12 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: Documentation: Add the missing description
 for mmu_valid_gen into kvm_mmu_page
Message-ID: <ZMgvZA+4FhtWB4Dl@google.com>
References: <20230626182016.4127366-1-mizhang@google.com>
 <20230626182016.4127366-6-mizhang@google.com>
 <ZJsKsQNWVq4zNmGk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJsKsQNWVq4zNmGk@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Mingwei Zhang wrote:
> > Add the description for mmu_valid_gen into kvm_mmu_page description.
> > mmu_valid_gen is used in shadow MMU for fast zapping. Update the doc to
> > reflect that.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 97d695207e11..cc4bd190c93d 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -208,6 +208,10 @@ Shadow pages contain the following information:
> >      The page is not backed by a guest page table, but its first entry
> >      points to one.  This is set if NPT uses 5-level page tables (host
> >      CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
> > +  mmu_valid_gen:
> > +    Used by comparing against kvm->arch.mmu_valid_gen to check whether the
> 
> This needs to explain what the generation is, and where it comes from.
> 
>   The MMU generation of this page, used to effect a "fast" zap of all MMU pages
>   across all roots.  To zap all pages in all roots without blocking vCPUs, e.g.
>   when deleting a memslot, KVM updates the per-VM valid MMU generation to mark
>   all existing pages and roots invalid/obsolete.  Obsolete pages can't be used,
>   e.g. vCPUs must load a new, valid root before re-entering the guest.
> 
>   The MMU generation is only ever '0' or '1', as slots_lock must be held until
>   all obsolete pages are zapped and freed, i.e. there is exactly one valid
>   generation and (at most) one invalid generation.
> 
>   Note, the TDP MMU doesn't use mmu_gen as non-root TDP MMU pages are reachable
>   only from their owning root, whereas all pages for shadow MMUs are reachable
>   via the hash map.  The TDP MMU uses role.invalid to track obsolete roots.

Sean, thanks for the detailed explanation. I will pick the most of the
content and get into the next version.
> 
> And then big bonus points if you add
> 
>   Page Role
>   =========
> 
> to explain the purpose of the role, and how/when it's used in the shadow MMU versus
> the TDP MMU.  The shadow MMU's use of a hash map is a fundemental aspect that really
> should be documented here.
> 
> > +    shadow page is obsolete thus a convenient variable for fast zapping.
> > +    Note that TDP MMU does not use mmu_valid_gen.
> >    gfn:
> >      Either the guest page table containing the translations shadowed by this
> >      page, or the base page frame for linear translations.  See role.direct.
> > -- 
> > 2.41.0.162.gfafddb0af9-goog
> > 
