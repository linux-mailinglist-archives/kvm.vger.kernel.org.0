Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30022375D63
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhEFX2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhEFX2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:28:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00771C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 16:27:31 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y32so5819286pga.11
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 16:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hNnmB2N+G/xliEHvFgXD/jk8b5W6LQ1nCJcVUsPji2I=;
        b=cXuAAA48mu88DAuWJxtAPWw5wM0J3HL3GxZE9djShlADFL8vJ3ysETvXY6SV/jQdeQ
         NHXdnwBUs5Zij7g0Y4e80hmMJi4XbWulwDIXgHeb5lyNB8B8Yzyo4X4KkZOz60OTnIfg
         SQVUoOaco97WIizqiL/OwN2ey5smZPwKzpsENT/Wi7GA/4wzFT0SDo1rYJIBDlsjjySK
         ky8BdcIpcc4BjXuYD1OS9Fckz0v81qKM6y4k1JrlD9dCCs6l4UhY8JrkQ0xHEqUDECTI
         InG95rF0j8N87Xez49u3CR2+ZF1F28laFfCbm273k7ymbrKIkNY7SaY/CHGIITjm1UC5
         tZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hNnmB2N+G/xliEHvFgXD/jk8b5W6LQ1nCJcVUsPji2I=;
        b=mM2kI7yC2nNDkKpZbxV+OBeWoJT4ZpaH7V2PU87ZCINfdBMQ8HQfP3k1+5JOwFbNYH
         lgVpnFSbT/lJHEu1a37PWpw8hE2EhJ/zlRx57VtGAxEm8vccKkdSlgVh5th3OMXnoAgU
         1vroSX4sjD65ETb4jFb97e4DdPJHgrh7UN3TgAHKG0I69fO51CfiEHg/6sBbAc1iYZwj
         Hi8eg1ExFRMV2q9MGtmOv7IcLrrZ2qFhFySZkHtjwcyv1dYhL1xOXHIE2Ki2S5P/UyOb
         HfL6ic+acomR1yLNDAVG/UzW2jqxTCB/h07R2ktB9QLS+DmMSLpxErdoIO0Qp7VTnwJD
         LkDg==
X-Gm-Message-State: AOAM533nEivegfk3TeXut590NQldMyzxuUw9vABKdXWzEAB0AOFIzB5M
        EAmRwBgroGTy8k5m5Wa+/cuRUHAHLCjoYQ==
X-Google-Smtp-Source: ABdhPJxKb2tilIJ4jh/l5dj063LYVgL9b+SY5h1DiC2kpP4lVhAVzlu3K9Pp+zl3VS3rhBMXvGQyiQ==
X-Received: by 2002:a63:6986:: with SMTP id e128mr6751721pgc.16.1620343651335;
        Thu, 06 May 2021 16:27:31 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c6sm10411626pjs.11.2021.05.06.16.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 16:27:30 -0700 (PDT)
Date:   Thu, 6 May 2021 23:27:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     KarimAllah Ahmed <karahmed@amazon.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 08/14] KVM/nVMX: Use kvm_vcpu_map when mapping the
 posted interrupt descriptor table
Message-ID: <YJR7X7nN7sFwvesj@google.com>
References: <1548966284-28642-1-git-send-email-karahmed@amazon.de>
 <1548966284-28642-9-git-send-email-karahmed@amazon.de>
 <CALMp9eR-Kt5wcveYmmmOe7HfWBB4r5nF+SjMfybPRR-b9TXiTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR-Kt5wcveYmmmOe7HfWBB4r5nF+SjMfybPRR-b9TXiTg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, Jim Mattson wrote:
> On Thu, Jan 31, 2019 at 12:28 PM KarimAllah Ahmed <karahmed@amazon.de> wrote:
> >
> > Use kvm_vcpu_map when mapping the posted interrupt descriptor table since
> > using kvm_vcpu_gpa_to_page() and kmap() will only work for guest memory
> > that has a "struct page".
> >
> > One additional semantic change is that the virtual host mapping lifecycle
> > has changed a bit. It now has the same lifetime of the pinning of the
> > interrupt descriptor table page on the host side.
> >
> > Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> > v4 -> v5:
> > - unmap with dirty flag
> >
> > v1 -> v2:
> > - Do not change the lifecycle of the mapping (pbonzini)
> > ---
> >  arch/x86/kvm/vmx/nested.c | 43 ++++++++++++-------------------------------
> >  arch/x86/kvm/vmx/vmx.h    |  2 +-
> >  2 files changed, 13 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 31b352c..53b1063 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -230,12 +230,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
> >                 vmx->nested.apic_access_page = NULL;
> >         }
> >         kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
> > -       if (vmx->nested.pi_desc_page) {
> > -               kunmap(vmx->nested.pi_desc_page);
> > -               kvm_release_page_dirty(vmx->nested.pi_desc_page);
> > -               vmx->nested.pi_desc_page = NULL;
> > -               vmx->nested.pi_desc = NULL;
> > -       }
> > +       kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
> > +       vmx->nested.pi_desc = NULL;
> >
> >         kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
> >
> > @@ -2868,26 +2864,15 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >         }
> >
> >         if (nested_cpu_has_posted_intr(vmcs12)) {
> > -               if (vmx->nested.pi_desc_page) { /* shouldn't happen */
> > -                       kunmap(vmx->nested.pi_desc_page);
> > -                       kvm_release_page_dirty(vmx->nested.pi_desc_page);
> > -                       vmx->nested.pi_desc_page = NULL;
> > -                       vmx->nested.pi_desc = NULL;
> > -                       vmcs_write64(POSTED_INTR_DESC_ADDR, -1ull);
> > +               map = &vmx->nested.pi_desc_map;
> > +
> > +               if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->posted_intr_desc_addr), map)) {
> > +                       vmx->nested.pi_desc =
> > +                               (struct pi_desc *)(((void *)map->hva) +
> > +                               offset_in_page(vmcs12->posted_intr_desc_addr));
> > +                       vmcs_write64(POSTED_INTR_DESC_ADDR,
> > +                                    pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
> >                 }
> 
> Previously, if there was no backing page for the
> vmcs12->posted_intr_desc_addr, we wrote an illegal value (-1ull) into
> the vmcs02 POSTED_INTR_DESC_ADDR field to force VM-entry failure.

The "vmcs_write64(POSTED_INTR_DESC_ADDR, -1ull)" above is for the "impossible"
case where the PI descriptor was already mapped.  The error handling for failure
to map is below.  The (forced) VM-Exit unmap paths don't stuff vmcs02 either.
In other words, I think the bug was pre-existing.

> Now, AFAICT, we leave that field unmodified. For a newly constructed vmcs02,
> doesn't that mean we're going to treat physical address 0 as the address of
> the vmcs02 posted interrupt descriptor?

PA=0 is the happy path.  Thanks to L1TF, that memory is always unused.  If
mapping for a previous VM-Enter succeeded, vmcs02.POSTED_INTR_DESC_ADDR will
hold whatever PA was used for the last VM-Enter.
 
> > -               page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->posted_intr_desc_addr);
> > -               if (is_error_page(page))
> > -                       return;

Error path for failure to map.

> > -               vmx->nested.pi_desc_page = page;
> > -               vmx->nested.pi_desc = kmap(vmx->nested.pi_desc_page);
> > -               vmx->nested.pi_desc =
> > -                       (struct pi_desc *)((void *)vmx->nested.pi_desc +
> > -                       (unsigned long)(vmcs12->posted_intr_desc_addr &
> > -                       (PAGE_SIZE - 1)));
> > -               vmcs_write64(POSTED_INTR_DESC_ADDR,
> > -                       page_to_phys(vmx->nested.pi_desc_page) +
> > -                       (unsigned long)(vmcs12->posted_intr_desc_addr &
> > -                       (PAGE_SIZE - 1)));
> >         }
> >         if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
> >                 vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
> > @@ -3911,12 +3896,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
> >                 vmx->nested.apic_access_page = NULL;
> >         }
> >         kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
> > -       if (vmx->nested.pi_desc_page) {
> > -               kunmap(vmx->nested.pi_desc_page);
> > -               kvm_release_page_dirty(vmx->nested.pi_desc_page);
> > -               vmx->nested.pi_desc_page = NULL;
> > -               vmx->nested.pi_desc = NULL;
> > -       }
> > +       kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
> > +       vmx->nested.pi_desc = NULL;
> >
> >         /*
> >          * We are now running in L2, mmu_notifier will force to reload the
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index f618f52..bd04725 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -143,7 +143,7 @@ struct nested_vmx {
> >          */
> >         struct page *apic_access_page;
> >         struct kvm_host_map virtual_apic_map;
> > -       struct page *pi_desc_page;
> > +       struct kvm_host_map pi_desc_map;
> >
> >         struct kvm_host_map msr_bitmap_map;
> >
> > --
> > 2.7.4
> >
