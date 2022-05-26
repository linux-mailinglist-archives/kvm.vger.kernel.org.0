Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1032C534C9B
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbiEZJih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiEZJif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:38:35 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE994E0D7;
        Thu, 26 May 2022 02:38:34 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2ef5380669cso9347257b3.9;
        Thu, 26 May 2022 02:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BX33/B9ySkh4VG2kRHCbprJ1PvLXqA1Nj9XnfhnCo0Y=;
        b=g70oqEiRN6zazpJCEoDxbl6xPwSaxfFeEbrsmsZZwojLtmMF4q7EJeWhGNrZlSUwAg
         HvKxQAjQqm7m1kL+eyf2T6i53TbjmJSqhK14o4TY1PxxFjWRclamkvBjii6SdgtKjCoB
         dPDzVQf0aUibXtMYs+D7LfPCbmajoRdEVs0qpzCWaAFCWy4p1qwN80shKaUzJpIZHjEI
         32dG0jhvNJWNT4WpT5x0k7eF70L0K4BRTwKofSLONFeCfApfXoCSE3D8t/qPtm3IpUuI
         8a4YD6Zz7dEpjgIjOEhao7TOOcjrtWPV3ElbilE94JFlTX7u++Bs93fhPL5gh+dW9cug
         +t8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BX33/B9ySkh4VG2kRHCbprJ1PvLXqA1Nj9XnfhnCo0Y=;
        b=xUaHgYt8EQydvORZn/4RaSaLuXg6XUGVlKrLSNzJ9eIPu6RiI452CSSn/GOhT1V4R7
         9Lmb8jtJPWBT14qoO1zQLU5gc/gFZWaHdoAyTdTtLfqd21IC7Maj/ApfWl6Fa7L8mNoe
         Q0DtPAD2kCSx2Vcy3ah1NGv+zZWfj76rlI2LQpJx25L82Afq4tHbFG3x/fC6cDX7tkLH
         pyt4nEBobDN58UM/lAm5VWbq/H1vayuBN9KZTuFOfTQlI/fdX5yArOYfzcjLXST/ULW6
         kZs6wuW8pJo4o+u9oljHwR6+/Khsj4dnZlqPvs3Xm++dDmHnkgXkpymyq/eSZTCLVCmk
         XihQ==
X-Gm-Message-State: AOAM532a47yoe+MuLNnBpEUYRg3dVGoSXYMUAIOCJr2VFWedkABi8xee
        xZii5x5BpTF6V36/viecg28vAYexDxDqgTOuF790+4WLlIA=
X-Google-Smtp-Source: ABdhPJw2Um5WFqCx/VmRQ2mrQtw91tpTEAxx6T5kbDIPvev77XaDvIQ3GL6CzNqgc0tlRYLK2Vfle0dzQIEbLXkQgLM=
X-Received: by 2002:a81:250c:0:b0:2ff:ee04:282e with SMTP id
 l12-20020a81250c000000b002ffee04282emr19828358ywl.161.1653557914171; Thu, 26
 May 2022 02:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-3-jiangshanlai@gmail.com> <Yn7tCpt9s8qf3Rn/@google.com>
In-Reply-To: <Yn7tCpt9s8qf3Rn/@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 17:38:23 +0800
Message-ID: <CAJhGHyDE0=WcpLqq1zUS5FV_U8HEFVh-MdvR1=Kx7-vpxcWKrA@mail.gmail.com>
Subject: Re: [PATCH V2 2/7] KVM: X86/MMU: Add special shadow pages
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
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

Hwllo

Thank you for the review.

On Sat, May 14, 2022 at 7:43 AM David Matlack <dmatlack@google.com> wrote:

> > +/*
> > + * Special pages are pages to hold PAE PDPTEs for 32bit guest or higher level
> > + * pages linked to special page when shadowing NPT.
> > + *
> > + * Special pages are specially allocated.  If sp->spt needs to be 32bit, it
>
> I'm not sure what you mean by "If sp->spt needs to be 32bit". Do you mean
> "If sp shadows a 32-bit PAE page table"?
>

"If sp->spt needs to be put in a 32bit CR3 (even on x86_64)"

> > + * will use the preallocated mmu->pae_root.
> > + *
> > + * Special pages are only visible to local VCPU except through rmap from their
> > + * children, so they are not in the kvm->arch.active_mmu_pages nor in the hash.
> > + *
> > + * And they are either accounted nor write-protected since they don't has gfn
> > + * associated.
>
> Instead of "has gfn associated", how about "shadow a guest page table"?
>

Did in v3.

> > + *
> > + * Special pages can be obsoleted but might be possibly reused later.  When
> > + * the obsoleting process is done, all the obsoleted shadow pages are unlinked
> > + * from the special pages by the help of the parent rmap of the children and
> > + * the special pages become theoretically valid again.  If there is no other
> > + * event to cause a VCPU to free the root and the VCPU is being preempted by
> > + * the host during two obsoleting processes, the VCPU can reuse its special
> > + * pages when it is back.
>
> Sorry I am having a lot of trouble parsing this paragraph.
>

This paragraph is rewritten in v3.

> > + */
>
> This comment (and more broadly, this series) mixes "special page",
> "special root", "special root page", and "special shadow page". Can you
> be more consistent with the terminology?
>

In v3, there are only "local shadow page" and "local root shadow page".
And "local root shadow page" can be shorted as "local root page".

> > +static struct kvm_mmu_page *kvm_mmu_alloc_special_page(struct kvm_vcpu *vcpu,
> > +             union kvm_mmu_page_role role)
> > +{
> > +     struct kvm_mmu_page *sp;
> > +
> > +     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > +     sp->gfn = 0;
> > +     sp->role = role;
> > +     if (role.level == PT32E_ROOT_LEVEL &&
> > +         vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL)
> > +             sp->spt = vcpu->arch.mmu->pae_root;
>
> Why use pae_root here instead of allocating from the cache?

Because of 32bit cr3.

The comment is updated in V3.

> > +static void mmu_free_special_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
> > +{
> > +     u64 spte = mmu->root.hpa;
> > +     struct kvm_mmu_page *sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> > +     int i;
> > +
> > +     /* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
> > +     while (sp->role.level > PT32E_ROOT_LEVEL)
> > +     {
> > +             spte = sp->spt[0];
> > +             mmu_page_zap_pte(kvm, sp, sp->spt + 0, NULL);
>
> Instead of using mmu_page_zap_pte(..., NULL) what about creating a new
> helper that just does drop_parent_pte(), since that's all you really
> want?
>

There are several places using mmu_page_zap_pte(..., NULL) in the mmu.c.

mmu_page_zap_pte() is more general and reviewers don't need to understand
extra code and extra comments.  For example, some comments are needed
to explain that sp->spt[i] is not a large page when disconnecting PAE root
from the 4 PAE page directories if using a helper that just does
drop_parent_pte().


> > +             free_page((unsigned long)sp->spt);
> > +             kmem_cache_free(mmu_page_header_cache, sp);
> > +             if (!is_shadow_present_pte(spte))
> > +                     return;
> > +             sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> > +     }
> > +
> > +     if (WARN_ON_ONCE(sp->role.level != PT32E_ROOT_LEVEL))
> > +             return;
> > +
> > +     /* Free PAE roots */
>
> nit: This loop does not do any freeing, it just disconnets the PAE root
> table from the 4 PAE page directories. So how about:
>
> /* Disconnect PAE root from the 4 PAE page directories */
>

Did in v3.

Thanks
Lai
