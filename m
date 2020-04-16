Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E711AD1EE
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 23:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgDPVeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 17:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725843AbgDPVeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 17:34:06 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EFCC061A0C
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 14:34:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f3so83049ioj.1
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 14:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+TPezPECUKOwAGB1jeVzVXF9iCR+5ADFws6BKwwbizc=;
        b=L8ZHdAigb7rztBqPmzv1Wr3oBMfKTeVUJzOlwoAqCki5iP/+Ph2qQ9QmvsqjiI78wr
         b8mcyDA7M5AEGBxKnri7090GioBy7YcYX+/fA7E8SbfvXVQMBoOGei6QFiNFV6pbmGhx
         URtmXYhIyBHa9vnqaQF+WHenD3KJBKa+ltxSijIDFsvwdkylsah1fiJgbM52NL0AiUsn
         91ccjFMOSucVrljfbPpVeflKDDCJ7EeMKO7ZPYpfa+ZkG0iHLbI0Eevud4VnJcGtvv7b
         +eI0hi9/OPbZjUsChCJSiQTCK0g0OPdCoPNbNExx4hSnpad/bK2lAdbQ62l5z/g4qAvb
         P9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+TPezPECUKOwAGB1jeVzVXF9iCR+5ADFws6BKwwbizc=;
        b=Gm8H6l3GpsqUhAQG+qjghNtZnvRCrinGLABJ94w7hypIwR83UcUvA1xzFnOwavxOBl
         /b1GqIpJFaaAxfIG+aztZwReZq3FGrL6CRkLgfldMtO27/dr7dJpnKYlviH7sNCx4bNK
         TnAChumT5XZM3yvvjW2AyiSoI8uvnN24vY0JJEVkG19QJanIYRntGUMhHUV3JKYysGdv
         OOx+BcenQaAEObcXyjgCz4hUmNS3s+/ewN/rQtw+5jSNJpl9Yil2AUJ28sGfQkZpDZkY
         bxfHoWTpmcYXrNUfukhIkkidt/uUClIyyntIFlVG38sYfNKX0uR4IGxG+XOKxXUVQhjO
         W/DQ==
X-Gm-Message-State: AGi0PuYPFVTd7ziNIzN6OfiQIY2fdPkm3pBz2Z/+eCgip/OAc1En2VUX
        Mmta5Usbq1xgqGgN7C1eQWJtrvCKIfDIouZ0hG+rQqEyfpY=
X-Google-Smtp-Source: APiQypLrnL64Nsr0s40zEsJnABAfQ/0uJW+UGGpZoZyX9B3baRbF2EyT+Oszief9+BiZgV4RwH5jr0uQTlTp/BL11Ow=
X-Received: by 2002:a5e:a610:: with SMTP id q16mr590633ioi.75.1587072845762;
 Thu, 16 Apr 2020 14:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200415214414.10194-1-sean.j.christopherson@intel.com> <20200415214414.10194-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200415214414.10194-2-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 16 Apr 2020 14:33:54 -0700
Message-ID: <CALMp9eTaLwj7kXgvACFQ_42+F7pnOvaAd02_2o4tG2fX5+JQaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Set @writable to false for non-visible
 accesses by L2
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 2:44 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Explicitly set @writable to false in try_async_pf() if the GFN->PFN
> translation is short-circuited due to the requested GFN not being
> visible to L2.
>
> Leaving @writable ('map_writable' in the callers) uninitialized is ok
> in that it's never actually consumed, but one has to track it all the
> way through set_spte() being short-circuited by set_mmio_spte() to
> understand that the uninitialized variable is benign, and relying on
> @writable being ignored is an unnecessary risk.  Explicitly setting
> @writable also aligns try_async_pf() with __gfn_to_pfn_memslot().
>
> Jim Mattson <jmattson@google.com>
Go ahead and preface the above with Reviewed-by:
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c6ea6032c222..6d6cb9416179 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4090,6 +4090,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>          */
>         if (is_guest_mode(vcpu) && !kvm_is_visible_gfn(vcpu->kvm, gfn)) {
>                 *pfn = KVM_PFN_NOSLOT;
> +               *writable = false;
>                 return false;
>         }
>
> --
> 2.26.0
>
