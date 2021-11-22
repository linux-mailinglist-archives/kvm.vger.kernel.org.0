Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF04595D1
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbhKVT6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbhKVT6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:58:01 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1458C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:54:53 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id x10so24939847ioj.9
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 11:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XDKCUGC/+vexMITH4f2b1LEyYBH9AMi+FMLWKWUf9j0=;
        b=s3+MkMGGFSHx5r5GBpLNs9ptRUkBhX8hADRlhs0mDUxbNUblwEmft+517bbWzhjyE7
         jQhZhjrJwDd4yex3aW2UbguchlrjbrsOiGSudp4U6N7z5FHjG6CcQtrHzb0APGmLevh2
         GGp/KOPP8PaoZODocdCEW8sOtGOeUr7falALusy8/1FETIPxY5MQHKcI4Lt37vWQsBl6
         7yPIKfoXmUDdns4rB9KThDH0Xb8yq62tILbdjIg8MVaocK/aRcInETw62UDfqFCiFWn0
         OLYqjRo3+4YA/n5mV7WHB8i8xfVUe5vXFI3koMZTcih2mVe/kQN9uoOGu4BM1Ehbwcmx
         1+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XDKCUGC/+vexMITH4f2b1LEyYBH9AMi+FMLWKWUf9j0=;
        b=5XXtOQc5pOBx+E9986C3HOVIKxvDQaixpdKbWQ0Enz0YYDYfQFl9ipfvPwzLqyDRxv
         ZIHcswU6n3UunW/bqW1k0+sfggwb26bTwKumHeR++HR0U5jYqJH0CSiONzcQ05JLhUbR
         YuLzcxF3jj+vcfHg8aNGTLHjT9gEDxoE2e7BkWJx4z8pAPEwZR0bc7At0ITESpL2JXhq
         NAz4D8RCpmjJ6I2Nvmr8fYJVtQ/1BpU81NjBu4LBbOuXhyf5uChtAguaQ3J1Wi69KeIb
         KxNXpLL2PaD5779DK+JwpsbCZ7oiEnuvKwPdQ7kLph2DyQcG4X35HfxlmLX+20lYrt5D
         tKrg==
X-Gm-Message-State: AOAM531Jf1jvmd2GKv/rUjDVVN3uuzgFuKOLmV+XtlMKRRWm8gezcMvL
        AiiZlIufT6imiNkJzkMkfAUxld9MCMe1qFjf9Cqyiw==
X-Google-Smtp-Source: ABdhPJxoDU6q90tEOC2lSMUoy83AYW9/c2v01IXfVxeJpYy6HRCnR2ZflPQJwMH1En9CY3DJkavUEFUV3f3DUOWjwII=
X-Received: by 2002:a05:6638:4087:: with SMTP id m7mr53116087jam.112.1637610892748;
 Mon, 22 Nov 2021 11:54:52 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-5-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-5-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 11:54:41 -0800
Message-ID: <CANgfPd_zjbaxBAeV31JtQ5Nyticrh2ZquK+oOqkonpto7fR1dQ@mail.gmail.com>
Subject: Re: [PATCH 04/28] KVM: x86/mmu: Retry page fault if root is
 invalidated by memslot update
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Bail from the page fault handler if the root shadow page was obsoleted by
> a memslot update.  Do the check _after_ acuiring mmu_lock, as the TDP MMU

*acquiring

> doesn't rely on the memslot/MMU generation, and instead relies on the
> root being explicit marked invalid by kvm_mmu_zap_all_fast(), which takes
> mmu_lock for write.
>
> For the TDP MMU, inserting a SPTE into an obsolete root can leak a SP if
> kvm_tdp_mmu_zap_invalidated_roots() has already zapped the SP, i.e. has
> moved past the gfn associated with the SP.
>
> For other MMUs, the resulting behavior is far more convoluted, though
> unlikely to be truly problematic.  Installing SPs/SPTEs into the obsolete
> root isn't directly problematic, as the obsolete root will be unloaded
> and dropped before the vCPU re-enters the guest.  But because the legacy
> MMU tracks shadow pages by their role, any SP created by the fault can
> can be reused in the new post-reload root.  Again, that _shouldn't_ be
> problematic as any leaf child SPTEs will be created for the current/valid
> memslot generation, and kvm_mmu_get_page() will not reuse child SPs from
> the old generation as they will be flagged as obsolete.  But, given that
> continuing with the fault is pointess (the root will be unloaded), apply
> the check to all MMUs.
>
> Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

A couple spelling nits, but otherwise:

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c         | 23 +++++++++++++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
>  2 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d2ad12a4d66e..31ce913efe37 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1936,7 +1936,11 @@ static void mmu_audit_disable(void) { }
>
>  static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -       return sp->role.invalid ||
> +       if (sp->role.invalid)
> +               return true;
> +
> +       /* TDP MMU pages due not use the MMU generation. */

*do

> +       return !sp->tdp_mmu_page &&
>                unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
>  }
>
> @@ -3976,6 +3980,20 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>         return true;
>  }
>
> +/*
> + * Returns true if the page fault is stale and needs to be retried, i.e. if the
> + * root was invalidated by a memslot update or a relevant mmu_notifier fired.
> + */
> +static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> +                               struct kvm_page_fault *fault, int mmu_seq)
> +{
> +       if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
> +               return true;
> +
> +       return fault->slot &&
> +              mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
> +}
> +
>  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>         bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
> @@ -4013,8 +4031,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         else
>                 write_lock(&vcpu->kvm->mmu_lock);
>
> -       if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
> +       if (is_page_fault_stale(vcpu, fault, mmu_seq))
>                 goto out_unlock;
> +
>         r = make_mmu_pages_available(vcpu);
>         if (r)
>                 goto out_unlock;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f87d36898c44..708a5d297fe1 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -911,7 +911,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>
>         r = RET_PF_RETRY;
>         write_lock(&vcpu->kvm->mmu_lock);
> -       if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
> +
> +       if (is_page_fault_stale(vcpu, fault, mmu_seq))
>                 goto out_unlock;
>
>         kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
