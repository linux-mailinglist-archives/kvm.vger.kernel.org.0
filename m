Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CEA2552B2
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 03:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgH1Bt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 21:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH1Bt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 21:49:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345EDC061264;
        Thu, 27 Aug 2020 18:49:25 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l8so14003ios.2;
        Thu, 27 Aug 2020 18:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AuxkTqVq7yF2cLR6HeqahnZopzaHgO8OPP4mjEB1p/k=;
        b=PN9yYyL4U/3wo7e66qiK4b+DxYiIE2tNSdJ1QM6y6NdGvVhy7cMLmg3Rz72+yJ48W+
         iXITBxJq7GTKuxRnhJAEICDM8RtusSpCWOqlSf82SEW0QUGwqX4jxZz+xKWpZ1aQNGS3
         daDj3FQEk4wT1/V82TdGadwCJl9OzsvMcq+wpcOwZJc9rzhJ96IQYjXBJWYsJ5pqM7vg
         Tio7S4cZuz0jySy/qtstaV/t8GW5vbknrSvcMPh+813krFMDZiPqQhqbKxMc0zcFM0VJ
         ShD2xJLTVebdKMwJOHZiPFqBAdkPq5b585X3uA5wYjxcqQElpi4RcGKHh4oPEqO+kFvo
         65Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AuxkTqVq7yF2cLR6HeqahnZopzaHgO8OPP4mjEB1p/k=;
        b=lSUgKQaQ6pM/uKZhUrWFGFscIzpePFzqwht5BwQjF5hVucymwB/Zl9h7NTdHiR8Qew
         CHQB0OXovPh/Fig7jk/eR16s2AsOBVLoA0WGFA6Re7j9PtRMqIqUi1WL/FbhjfrQTBsK
         fSveIsHHK9+pCCJZ3YnGkGBYL1uWLhvkLXR331IqWOxrKKs5U58VQvKzkc+IikrRbr1J
         jOtD9GKqvE5MvZoYxh7AAqOTZVVIbioD2nVXI3Jylx5aTWQ9rS6UQyLKSabQE4y9GDmZ
         xJeq3KYwQ2gMRl7gazkffBD3FjJP9ZfAeQTjEDIAhR8wuzHkGEXMZ9zAtvvBEHgJ4j8+
         LMqQ==
X-Gm-Message-State: AOAM533ZEJxeRxomZXjY0gFVtt+LLYHxNdbyXa/VWFeBVGKWNS2lwiLo
        y9tY6bbb2iecn6aZ59ywoB0GcM9QLma1Nvz0L2jZ6b5XS/V7nQ==
X-Google-Smtp-Source: ABdhPJwx/DIu4zJ07VCu6FiVgahDko/FpmdmTd7xlfYVxx8Un8UKZNh/GZWHLRZjPDLEg7i+ACD8EDmZ1JsVkGd3H+o=
X-Received: by 2002:a05:6638:24cf:: with SMTP id y15mr22673544jat.137.1598579364071;
 Thu, 27 Aug 2020 18:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200824101825.4106-1-jiangshanlai@gmail.com>
In-Reply-To: <20200824101825.4106-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 28 Aug 2020 09:49:13 +0800
Message-ID: <CAJhGHyC1Ykq5V_2nFPLRz9JmtAiQu6aw4fCKo1LO7Qwzjvfg2g@mail.gmail.com>
Subject: Re: [PATCH] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
To:     LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping @Sean Christopherson

On Mon, Aug 24, 2020 at 5:18 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
> changed it without giving any reason in the changelog.
>
> In theory, the syncing is needed, and need to be fixed by reverting
> this part of change.
>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e03841f053d..9a93de921f2b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>                 }
>
>                 if (sp->unsync_children)
> -                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +                       kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>
>                 __clear_sp_write_flooding_count(sp);
>
> --
> 2.19.1.6.gb485710b
>
