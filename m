Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEE04E8325
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiCZSMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 14:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiCZSMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 14:12:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADF124BEA
        for <kvm@vger.kernel.org>; Sat, 26 Mar 2022 11:10:32 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v4so10354118pjh.2
        for <kvm@vger.kernel.org>; Sat, 26 Mar 2022 11:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M8SQurdpCbgb0/JB23ZIIwrYLAu2IISfqnuSRx7Zb6s=;
        b=O/TCQoKTrLVMYJxM/DR0//iwrwaGxb1BueJn3dY5RgYwVIcwMvsV+vGH8Kk8XBiP18
         oSBgL4QR+Kx+IWdDl2iwLCfT3iwnwvzdLHlUre42hcm1+HXqkozrrNSI3QDXhq9GXapD
         Gi2N+luyjpBQkd0hkbX9gtDXXQbeIs96PKuDGZnQvGls7fEKO9AYWF6NQSsO2HhT346w
         aqNfFYVR6u8CCcOlZ2eXdmU0nf40QYSjrbNs4+pkYtW4RS02A2vIaMX6avVI7V+Fdx8x
         H9P6+F62NmdBrsEsqnBtWRmxfsptTAaqwl2sTTzdRXWXdeoFVK2hglHMDnZr4NDYn/8q
         Uo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M8SQurdpCbgb0/JB23ZIIwrYLAu2IISfqnuSRx7Zb6s=;
        b=W9TZbvNvfu6LE8zn+q79NtcJLGKRn1cjq7uI8t53IOAZR4LoRNXEIcdLR2qAYcaT6F
         Nk+y6iiUQsP5UBYhJv83Xtkg+ay94Dc/oDXMxbkV9iTyh7NiyIjBUct7ciJn/IB8PQj/
         uhNXtwS98uTsnoWu7GXeBxpwNGca34s+7MAfRCmgMDehfbggMvhQ9qXP74tNmKDWSPxt
         qoCSBHK3LdaBPqGeZ0fcREyD19cMJsXW3DTHlfoWV+0bYh2CN/68i19mMLKSv02jGLTt
         ln3LL0OCLhFnrJuHNG26UCmQlm7wkFfXMDGooJZLYW5FwVKktD1a4GwrL9VoZySS9XZL
         eiHg==
X-Gm-Message-State: AOAM532ZIZGCNu+0JVtKxzwOnxIDBIJXFZHkNNvoIEDnIxr5p8jAf5Mb
        XpmtdU2HWEjCzIFMlcVqK3HK1A==
X-Google-Smtp-Source: ABdhPJwSSXJcW0ENl6GXWLbMm/5/4thRTafqiSRAmViITE2nUme3n3SpZA3ptsibf6jGJJT/T8n1LA==
X-Received: by 2002:a17:902:e9d4:b0:153:bd06:859c with SMTP id 20-20020a170902e9d400b00153bd06859cmr18025478plk.8.1648318231601;
        Sat, 26 Mar 2022 11:10:31 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id q18-20020aa78432000000b004fb0a5aa2c7sm6992066pfn.183.2022.03.26.11.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 11:10:31 -0700 (PDT)
Date:   Sat, 26 Mar 2022 18:10:27 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()
Message-ID: <Yj9XE/oeQXBp2Ryg@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
 <CAL715WJc3QdFe4gkbefW5zHPaYZfErG9vQmOLsbXz=kbaB-6uw@mail.gmail.com>
 <Yj3b/IhXU9eutjoS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj3b/IhXU9eutjoS@google.com>
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

On Fri, Mar 25, 2022, Sean Christopherson wrote:
> On Sun, Mar 13, 2022, Mingwei Zhang wrote:
> > On Thu, Mar 3, 2022 at 11:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > @@ -898,13 +879,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > >   * SPTEs have been cleared and a TLB flush is needed before releasing the
> > >   * MMU lock.
> > >   */
> > > -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> > > -                                gfn_t end, bool can_yield, bool flush)
> > > +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> > > +                          bool can_yield, bool flush)
> > >  {
> > >         struct kvm_mmu_page *root;
> > >
> > >         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> > > -               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
> > > +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
> > 
> > hmm, I think we might have to be very careful here. If we only zap
> > leafs, then there could be side effects. For instance, the code in
> > disallowed_hugepage_adjust() may not work as intended. If you check
> > the following condition in arch/x86/kvm/mmu/mmu.c:2918
> > 
> > if (cur_level > PG_LEVEL_4K &&
> >     cur_level == fault->goal_level &&
> >     is_shadow_present_pte(spte) &&
> >     !is_large_pte(spte)) {
> > 
> > If we previously use 4K mappings in this range due to various reasons
> > (dirty logging etc), then afterwards, we zap the range. Then the guest
> > touches a 4K and now we should map the range with whatever the maximum
> > level we can for the guest.
> > 
> > However, if we just zap only the leafs, then when the code comes to
> > the above location, is_shadow_present_pte(spte) will return true,
> > since the spte is a non-leaf (say a regular PMD entry). The whole if
> > statement will be true, then we never allow remapping guest memory
> > with huge pages.
> 
> But that's at worst a performance issue, and arguably working as intended.  The
> zap in this case is never due to the _guest_ unmapping the pfn, so odds are good
> the guest will want to map back in the same pfns with the same permissions.
> Zapping shadow pages so that the guest can maybe create a hugepage may end up
> being a lot of extra work for no benefit.  Or it may be a net positive.  Either
> way, it's not a functional issue.

This should be a performance bug instead of a functional one. But it
does affect both dirty logging (before Ben's early page promotion) and
our demand paging. So I proposed the fix in here:

https://lore.kernel.org/lkml/20220323184915.1335049-2-mizhang@google.com/T/#me78d50ffac33f4f418432f7b171c50630414ef28

If we see memory corruptions, I bet it could only be that we miss some
TLB flushes, since this patch series is basically trying to avoid
immediate TLB flushing by simply changing ASID (assigning new root).

To debug, maybe force the TLB flushes after zap_gfn_range and see if the
problem still exist?


