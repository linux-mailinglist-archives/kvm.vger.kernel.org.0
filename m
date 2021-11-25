Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A90145D3C3
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 04:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhKYDz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 22:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhKYDxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 22:53:55 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C822C06173E;
        Wed, 24 Nov 2021 19:50:45 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id a11so4287113ilj.6;
        Wed, 24 Nov 2021 19:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aOsXAIA+CjlrrWv1+HiSUuoeX4fJaK/BXi8fJXg25Ng=;
        b=eUUaQ+yqghtwoOPYIXgPke1HdQlOUnN5LaDhXBoh9DY1a6kfDSnowXzKr6mgBDidpz
         t+n4kaKQAZQT6b83DylmoUBkrMyOUN+8mzUmyYE8zLUrSpp/9WGRAb7SbBjAdj9IGR+o
         dRHs4dPb1+wIjgb6Lepl2eSraztz3SvKARhFeD3sKfl3eFEy3EgxOQAA8XLg8dDkOr/O
         Zkds79HEEJUQWYHjjCt0pmdjY/JadyjZcJWmS1WIr4mSoiOx/s1o4TkRaYQ9CmvCokim
         DWTvev04k6Q4prf+aXUsdZxkS0qTpEHzk4PwJe4QNmYTGg2CMSq/+PXDLS+wj8VaYoI3
         2Eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOsXAIA+CjlrrWv1+HiSUuoeX4fJaK/BXi8fJXg25Ng=;
        b=8DqakretKXoVRtvLcTKLtr1pTIca47rO/nkehAFU1QV2JcLm6HYHI9Onv8Vxk1TxB+
         DGVKfDe7HRvnSezkQ6iVHU62KLBVN8hDh6OIPtAhb6+P+pvA/20qPBvLNWrPw78fqw22
         hHmJ/4TOIk3dM5lYi/f6z31SpfM6ADuOaLsg98s6bc5p9HM/fGeyV8qMpwW87Cx01HfD
         qM08QIRvrUCOtibQzIH+jgfZ535ZvVE6jR54yHwDxaJMm5BbEowZIYtULqu8oKAp9Gg/
         AaCvIpg3ZMjJ3JAWcb9b9UZXrEZgD5RXWWDNdA9TssvVjyr6wlbQM95ePx9yi3DzxPBy
         Hhig==
X-Gm-Message-State: AOAM533H1zsHKTLEeBEkG/Fk3S+XzVXc94r3TsMigt8lz8ESR9MxPiM6
        hsMacMWvzjaWop5o1IgZk2aioCG2hMrBDCofez8=
X-Google-Smtp-Source: ABdhPJyeq5RpKNPyCMqW3EdnsKbhLmlv3yR5AIDLq4YkyFo4QC4NdWDc+VED08HYOEKnD4nKq5veosNcU/5Fnik/2Ig=
X-Received: by 2002:a05:6e02:1c8f:: with SMTP id w15mr16679701ill.147.1637812244580;
 Wed, 24 Nov 2021 19:50:44 -0800 (PST)
MIME-Version: 1.0
References: <20211125014944.536398-1-seanjc@google.com> <20211125014944.536398-3-seanjc@google.com>
In-Reply-To: <20211125014944.536398-3-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 25 Nov 2021 11:50:33 +0800
Message-ID: <CAJhGHyBC1C71wchvqE_YztCvtkNgnmTN9FbBAOSz0K6SA3+WAA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: nVMX: Emulate guest TLB flush on nested VM-Enter
 with new vpid12
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021 at 9:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Fully emulate a guest TLB flush on nested VM-Enter which changes vpid12,
> i.e. L2's VPID, instead of simply doing INVVPID to flush real hardware's
> TLB entries for vpid02.  From L1's perspective, changing L2's VPID is
> effectively a TLB flush unless "hardware" has previously cached entries
> for the new vpid12.  Because KVM tracks only a single vpid12, KVM doesn't
> know if the new vpid12 has been used in the past and so must treat it as
> a brand new, never been used VPID, i.e. must assume that the new vpid12
> represents a TLB flush from L1's perspective.
>
> For example, if L1 and L2 share a CR3, the first VM-Enter to L2 (with a
> VPID) is effectively a TLB flush as hardware/KVM has never seen vpid12
> and thus can't have cached entries in the TLB for vpid12.
>
> Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
> Fixes: 5c614b3583e7 ("KVM: nVMX: nested VPID emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2ef1d5562a54..dafe5881ae51 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1162,29 +1162,26 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>         WARN_ON(!enable_vpid);
>
>         /*
> -        * If VPID is enabled and used by vmc12, but L2 does not have a unique
> -        * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
> -        * a VPID for L2, flush the current context as the effective ASID is
> -        * common to both L1 and L2.
> -        *
> -        * Defer the flush so that it runs after vmcs02.EPTP has been set by
> -        * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
> -        * redundant flushes further down the nested pipeline.
> -        *
> -        * If a TLB flush isn't required due to any of the above, and vpid12 is
> -        * changing then the new "virtual" VPID (vpid12) will reuse the same
> -        * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
> -        * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
> -        * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
> -        * guest-physical mappings, so there is no need to sync the nEPT MMU.
> +        * VPID is enabled and in use by vmcs12.  If vpid12 is changing, then
> +        * emulate a guest TLB flush as KVM does not track vpid12 history nor
> +        * is the VPID incorporated into the MMU context.  I.e. KVM must assume
> +        * that the new vpid12 has never been used and thus represents a new
> +        * guest ASID that cannot have entries in the TLB.
>          */
> -       if (!nested_has_guest_tlb_tag(vcpu)) {
> -               kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> -       } else if (is_vmenter &&
> -                  vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> +       if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
>                 vmx->nested.last_vpid = vmcs12->virtual_processor_id;

How about when vmx->nested.last_vpid == vmcs12->virtual_processor_id == 0?

I think KVM_REQ_TLB_FLUSH_GUEST is needed in this case too.

> -               vpid_sync_context(nested_get_vpid02(vcpu));
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +               return;
>         }
> +
> +       /*
> +        * If VPID is enabled, used by vmc12, and vpid12 is not changing but
> +        * does not have a unique TLB tag (ASID), i.e. EPT is disabled and
> +        * KVM was unable to allocate a VPID for L2, flush the current context
> +        * as the effective ASID is common to both L1 and L2.
> +        */
> +       if (!nested_has_guest_tlb_tag(vcpu))
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
>
>  static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
