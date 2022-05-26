Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A39F534BDB
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345013AbiEZIiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 04:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiEZIix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 04:38:53 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12FF8D697;
        Thu, 26 May 2022 01:38:51 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2fee010f509so7901007b3.11;
        Thu, 26 May 2022 01:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbUeYaGV2iiTmVNKTztnPLDzOTHifNaSgRvdrF1CxyU=;
        b=P2WjARQ55FNQcr4R+gXEvuEn585KUkmWQRoOdXmP88i2dYu4kLI11R8f+Gr2nGcLFT
         gc21wTZ5aHe0bYVXFD63LP1T7VsRxzZV0qDnRJ2Wj1ikRpdbebeMlUycBR6//c22lbla
         M+7jhM5nUJi31rTZ6YAj1Cj4auqjGui3E3yJ+fwCpfhUaVWYW8zAFueJcjPEL/LNTM92
         7q7ZVLHqfvyXMILM/oqc4rqQ3xOA9ntjlIy8XBkSeUKNcU1LB/5uTut+CVH+8QUSpBpQ
         HoUTPgqdurtxnd0lcWd8OYgLjEUhkDRcdRmojM1giTPlildacj9nflpIpFyFEKPq5vyZ
         8/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbUeYaGV2iiTmVNKTztnPLDzOTHifNaSgRvdrF1CxyU=;
        b=Jg5uqPSYJKXtxazw3DH13kccMvd+gG5nhoI8omAzBhtdN3esvbCfGK9xGrQXQgOFdK
         CGZm+svtt1MhPUIa7rjkm2e/BejuzII/TQDzK9K3//6ZaNUwN/ZR+ndOZQKmQ/QcKaWX
         +v4iy8CCM5UJMwM3gvzpavlEm9CWP/lKmFErUvzHBpXWnm1rOQ0MqmdEZL6ILflW9F+K
         7KFSIzF97aCDjilk0fMS+iyBSyebnv7gkCjNMeeSeVZfB/IKzmvC1PaLesGn6N3j+igU
         0rPMyqwO0A6g4lFZ9hRPsvM4JkMP54TSGX5dEiCyABBEa+nLHmsWAIbcYyjpmx+Vg/wD
         AAzQ==
X-Gm-Message-State: AOAM532/nrKDvDKHsjlWV7o8mEA7i3cCTRelFz7kCTbiNpfELDPImYEm
        W+bWXi+vyuuJ6rfvT4Op9Yk418Z+6EMrc0jI1M8=
X-Google-Smtp-Source: ABdhPJzeUexWBR2EUkg6MWAag5FyAZsCS2FmgDFxl3d28/yHC0PXTjDtzEAQDiTbf2T94NoymPbmgVJH9skeqeDH0uA=
X-Received: by 2002:a81:250c:0:b0:2ff:ee04:282e with SMTP id
 l12-20020a81250c000000b002ffee04282emr19640772ywl.161.1653554331053; Thu, 26
 May 2022 01:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220415103414.86555-1-jiangshanlai@gmail.com>
 <YoK3zEVj+DuIBEs7@google.com> <CALzav=c_WfJ0hvHUFHkLH-+zrDXZSCzKsGHP6kPYd77adwHkUQ@mail.gmail.com>
In-Reply-To: <CALzav=c_WfJ0hvHUFHkLH-+zrDXZSCzKsGHP6kPYd77adwHkUQ@mail.gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 16:38:40 +0800
Message-ID: <CAJhGHyBtVwZ9G+Mv8FMwC4Uku_gK4-Ng7+x+FqykZLftANm0Yg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/svm/nested: Cache PDPTEs for nested NPT in PAE
 paging mode
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 5:45 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, May 16, 2022 at 2:06 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Apr 15, 2022, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > >
> > > When NPT enabled L1 is PAE paging, vcpu->arch.mmu->get_pdptrs() which
> > > is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from memroy
> > > unconditionally for each call.
> > >
> > > The guest PAE root page is not write-protected.
> > >
> > > The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get different
> > > values every time or it is different from the return value of
> > > mmu->get_pdptrs() in mmu_alloc_shadow_roots().
> > >
> > > And it will cause FNAME(fetch) installs the spte in a wrong sp
> > > or links a sp to a wrong parent since FNAME(gpte_changed) can't
> > > check these kind of changes.
> > >
> > > Cache the PDPTEs and the problem is resolved.  The guest is responsible
> > > to info the host if its PAE root page is updated which will cause
> > > nested vmexit and the host updates the cache when next nested run.
> >
> > Hmm, no, the guest is responsible for invalidating translations that can be
> > cached in the TLB, but the guest is not responsible for a full reload of PDPTEs.
> > Per the APM, the PDPTEs can be cached like regular PTEs:
> >
> >   Under SVM, however, when the processor is in guest mode with PAE enabled, the
> >   guest PDPT entries are not cached or validated at this point, but instead are
> >   loaded and checked on demand in the normal course of address translation, just
> >   like page directory and page table entries. Any reserved bit violations ared
> >   etected at the point of use, and result in a page-fault (#PF) exception rather
> >   than a general-protection (#GP) exception.
>
> This paragraph from the APM describes the behavior of CR3 loads while
> in SVM guest-mode. But this patch is changing how KVM emulates SVM
> host-mode (i.e. L1), right? It seems like AMD makes no guarantee
> whether or not CR3 loads pre-load PDPTEs while in SVM host-mode.
> (Although the APM does say that "modern processors" do not pre-load
> PDPTEs.)

Oh, I also missed the fact that L1 is the host when emulating it.

The code is for host-mode (L1)'s nested_cr3 which is using the
traditional PAE PDPTEs loading and checking.

So using caches is the only correct way, right?

If so, I can update this patch only (not adding it to the patchset of
one-off local shadow page) and add some checks to see if the loaded
caches changed.

Maybe I just ignore it since I'm not familiar with SVM enough.
I hope it served as a bug report.

Thanks
Lai
