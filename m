Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD93652966C
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 03:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiEQBCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 21:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiEQBCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 21:02:23 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED1F3EAB3;
        Mon, 16 May 2022 18:02:22 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a3so10922088ybg.5;
        Mon, 16 May 2022 18:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uqWi4OnHu9ri4Nfr1SRDUI9tIGr2rwk7haOnQsBD3Ys=;
        b=T92+XNl0GBjaHOZaaCfUzuxLeNI0GDBCfW61td3Vb4FeCnL/deQ1MMtkdearq4YlGX
         9Nd0pBSrkLfd1ABfSyJiZvbo7fsIfPTUUUZToYOvWgYkcGWhOqvYsI+y2AAo9ht40+0j
         XLiIOtmucBvTUa47yg1F6IYvyBqWlr6EVJsktPOpW8ugS+TejTtjC1YxS0pIq0YiX6bz
         ELbIbSsL4vBAaSs6ulh31xB3jZpJgid/5L9ZK8FJmBt6A4H+KXdPXMlb6xKwa/mV3jAh
         aklSiLr46NP0TqPB+F+iczNUX8HM8x1YW3oLpfAGzPX5AWE0BSZF71rwPqXYZDf79SDH
         lytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uqWi4OnHu9ri4Nfr1SRDUI9tIGr2rwk7haOnQsBD3Ys=;
        b=ZJUadBir1R+urqBBX3DfPIfRjK+dSms2AYGSiaycjB1NCZW4ZEJLLTULsmRO2Z19XX
         lKAwCNifRpjyVpFwKqPiOSh+dKBqxnu/LjIclveCJ+K4e6zt42UwRBbJcDM0ZXC8dufb
         Am69nVOo5RGNtWr3YiopccxR8sjGBJQ7SFxPlduxBbidPFOnhnvbdLTFiGdm9wQqeHaf
         0OE62/dX1nV0E6CqHtH+He2LtzfXOb2K5Za12pd24k0eeQf4iArwykwBW7IpXnpNRnAk
         8gtODgzUbe4j67j79HGFb+je7CuHK81kfKgM3vfGtonVCf2/exoeuU9/NsfMaY/Vh4ag
         gkRw==
X-Gm-Message-State: AOAM530V3KkmRwcfYYD0SDYTdnNaEsMc5KtaisiGZpgDGpZj4fAgxKnC
        XFKT2MGoFx5zHErbDiOeGP3asjB3lJAU4KS+hbTu9ZyY+5E=
X-Google-Smtp-Source: ABdhPJwxnH9d3ESAOWYk+zXNYrQeMU2xxTnLHC6hsf4faWRrotO6pkgfo6ewrvrH7mmXg7ahw++WqR31QTpU8QKvOHc=
X-Received: by 2002:a25:2c55:0:b0:64d:f682:db36 with SMTP id
 s82-20020a252c55000000b0064df682db36mr754823ybs.352.1652749341908; Mon, 16
 May 2022 18:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220415103414.86555-1-jiangshanlai@gmail.com> <YoK3zEVj+DuIBEs7@google.com>
In-Reply-To: <YoK3zEVj+DuIBEs7@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 17 May 2022 09:02:09 +0800
Message-ID: <CAJhGHyBYaASEkB7FqGQ3FThgNDkOzvHmC5KFw9y0SEu3we8s3A@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/svm/nested: Cache PDPTEs for nested NPT in PAE
 paging mode
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        Avi Kivity <avi@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>
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

On Tue, May 17, 2022 at 4:45 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > When NPT enabled L1 is PAE paging, vcpu->arch.mmu->get_pdptrs() which
> > is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from memroy
> > unconditionally for each call.
> >
> > The guest PAE root page is not write-protected.
> >
> > The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get different
> > values every time or it is different from the return value of
> > mmu->get_pdptrs() in mmu_alloc_shadow_roots().
> >
> > And it will cause FNAME(fetch) installs the spte in a wrong sp
> > or links a sp to a wrong parent since FNAME(gpte_changed) can't
> > check these kind of changes.
> >
> > Cache the PDPTEs and the problem is resolved.  The guest is responsible
> > to info the host if its PAE root page is updated which will cause
> > nested vmexit and the host updates the cache when next nested run.
>
> Hmm, no, the guest is responsible for invalidating translations that can be
> cached in the TLB, but the guest is not responsible for a full reload of PDPTEs.
> Per the APM, the PDPTEs can be cached like regular PTEs:
>
>   Under SVM, however, when the processor is in guest mode with PAE enabled, the
>   guest PDPT entries are not cached or validated at this point, but instead are
>   loaded and checked on demand in the normal course of address translation, just
>   like page directory and page table entries. Any reserved bit violations ared
>   etected at the point of use, and result in a page-fault (#PF) exception rather
>   than a general-protection (#GP) exception.
>
> So if L1 modifies a PDPTE from !PRESENT (or RESERVED) to PRESENT (and valid), then
> any active L2 vCPUs should recognize the new PDPTE without a nested VM-Exit because
> the old entry can't have been cached in the TLB.

In this case, it is still !PRESENT in the shadow page, and it will cause
a vmexit when L2 tries to use the translation.  I can't see anything wrong
in TLB or vTLB(shadow pages).

But I think some code is needed to reload the cached PDPTEs
when guest_mmu->get_pdptrs() returns !PRESENT and reload mmu if
the cache is changed. (and add code to avoid infinite loop)

The patch fails to reload mmu if the cache is changed which
leaves the problem described in the changelog partial resolved
only.

Maybe we need to add mmu parameter back in load_pdptrs() for it.

>
> In practice, snapshotting at nested VMRUN would likely work, but architecturally
> it's wrong and could cause problems if L1+L2 are engange in paravirt shenanigans,
> e.g. async #PF comes to mind.
>
> I believe the correct way to fix this is to write-protect nNPT PDPTEs like all other
> shadow pages, which shouldn't be too awful to do as part of your series to route
> PDPTEs through kvm_mmu_get_page().

In the one-off special shadow page (will be renamed to one-off local
shadow page)
patchsets, PAE PDPTEs is not write-protected.  Wirte-protecting it causing nasty
code.
