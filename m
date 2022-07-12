Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD657299F
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 01:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiGLXEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 19:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiGLXEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 19:04:14 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA862A41B
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:04:14 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10bf634bc50so12163444fac.3
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0kilpuaWkkH1jWKZwcnpv75y3bBAyVMGJWLT8pq7Zew=;
        b=ZBE5KGyRMkxibp5iaQK1l2yLFQs3jMAWpu5gwk0mkKX4ubei8nAy3KENVxr6zAoHjv
         GxxAukLzTPcow4xb39vYwDGdcaSRPa60fmvrQz7t5M+INg1M5ckPSC915vA9q2vN94AD
         /SGqziGRgsU+lRLMnfhy3E5QN+LwNKSm54tmpu0mNnq5YnUHuf05goqCVAxNqaaAiN6B
         kCkPthpHgFI7wBZw9z3V/ubta+xmhbhQHRM/O5EcP+46woLYQpwn+fg2Dj/B6KQdkz8q
         cxYdjJT7Re3j22yGvnr+ktEYQOKJ6wkxisMXfv/a2tIwVaodgTZvM0zkiXaKA3U/CSDX
         wuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0kilpuaWkkH1jWKZwcnpv75y3bBAyVMGJWLT8pq7Zew=;
        b=Bx+DxOzyN39Ti7c43QsHzP2wc4FCg4MjrFYUe0tqG1T6objvyePmI502VDXU3kHKLI
         x6AJHLArRvIIRh789BC7s8sfDNww1Aav5dxDn2cbPSDLAJmwCQ7+NLIAuLPt4uD1sBR2
         aYJCjAFFrjMI79dSXYspP8nglXroqFLSQ22CxMcq4gpu24J4s+JB5tUJp71a0QuNxhuN
         2CXBjxCiF0IOmNA2L5ZFsxkcUxwy8SyDqeOJJoY80wDrUdUbME7wtZodjE/NEtvh4xOh
         hrz+6OBc1LU3Ahri2aD810W4NyvinVbF82bhNBXw5iqDWJFDcQOlmSg2ChZDF6Hz5VdS
         NFgg==
X-Gm-Message-State: AJIora9GK6H8rmevNURKnFb70Mb8TyEOZmYchxG7Te+nOiaEK2hIrAnb
        rZT8gaCKFkPlQqbfSty9W8weF4b4DgOJq+IlrFlWAA==
X-Google-Smtp-Source: AGRyM1uYZ+G3f4X735Xr0IJWdBmvb830WjZ9bkBphZtyS8Anj7WjdMlYQpZtxJ6khjfO5cktyObZb/GpgNs5V7B3uuU=
X-Received: by 2002:a05:6870:d349:b0:f5:e9ea:5200 with SMTP id
 h9-20020a056870d34900b000f5e9ea5200mr3194460oag.235.1657667052905; Tue, 12
 Jul 2022 16:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-3-yosryahmed@google.com> <YsdLVBtl16mx3+Ot@google.com>
In-Reply-To: <YsdLVBtl16mx3+Ot@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 12 Jul 2022 16:03:37 -0700
Message-ID: <CAJD7tkZ-r7O1AD8kAUgoY0Y2RNQkBpbtmtKpq68xN4PO=fzPnw@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jul 7, 2022 at 2:08 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > Add a helper to account pages used by KVM for page tables in memory
> > secondary pagetable stats. This function will be used by subsequent
> > patches in different archs.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  include/linux/kvm_host.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3b40f8d68fbb1..032821d77e920 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
> >  }
> >  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
> >
> > +/*
> > + * If more than one page is being (un)accounted, @virt must be the address of
> > + * the first page of a block of pages what were allocated together (i.e
> > + * accounted together).
>
> Sorry for the belated thoughts...
>
> If you spin a v7, can you add a note to call out that mod_lruvec_page_state() is
> itself thread-safe?  Caught my eye because the TDP MMU usage happens while holding
> mmu_lock for read.
>

Sure! I will send a v7 anyway to address the comments on patch 1. Thanks!

> > + */
> > +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> > +{
> > +     mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> > +}
> > +
> >  /*
> >   * This defines how many reserved entries we want to keep before we
> >   * kick the vcpu to the userspace to avoid dirty ring full.  This
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
> >
