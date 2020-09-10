Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96502643C4
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgIJKVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgIJKVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:21:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252F3C061573;
        Thu, 10 Sep 2020 03:21:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m17so6493945ioo.1;
        Thu, 10 Sep 2020 03:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIDx3q32OpBxKEzp9SHVTFYjF0eHn3L4CiEBr1eEYX8=;
        b=oYKUQC5oEjTGVYlyuczxuT6b7kACfyNUTuZFp1lSBBL3ll9Or6GRfh7NRSIqx90O91
         Hx5ekTT6/oMjOiWlB2w+d77l5x2U6QWDuv7WYUG60skCp34fFti8QvHlMR/HD1KJ8TIk
         WgHNbMPIL/wi/hn7tenhJAkUuX5RVNVEeUTWhxOHHDVuxOIFw8LZdcB60aZ9Gh480Tcm
         Tu3+TEBdMInqLZVK6+Xb6xRKVG1BaQMVGYoEMpul6pMU5BX9fyWXyGC6Ell3MJ7PViWX
         nF2LKkJvD3NRCzQBd6e0sS6rCcIyuL8Sw1A+2oP0mZn9BVXq0ZYpjr0miAijY156Y4g+
         4hsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIDx3q32OpBxKEzp9SHVTFYjF0eHn3L4CiEBr1eEYX8=;
        b=BipR/uvWEidtyL2rCSUsDGMnA2VJW13mx5PfKYXQqnPkLuNEWjnUMrNB+u7ex28c+f
         4Ft/X8XcUxm60Ci1iW6MMi15sOedSKmWRqwowkeRNhbhMVOdwhrcR279wBBWgqz0cueU
         7YuWKZond81wPjPomwfkMPHA9GQAiDMshDF2pK2/lrVion4HzWuKxHdvawnhqfoHQrr0
         d/BcXXNPFpuwBTw6FC2gmZC4X6k18iAnSM+wIF2xdaUledJLaVW+1L8TDoJkfDIHOO6Y
         D1EbxJveNlCgSNS64MzZixi9HeljtMpFxI3+tOOvQ63mUxd1NNrjENVNU3V2G0Zynq1l
         XOiQ==
X-Gm-Message-State: AOAM532+cIygu7zIXoQHOCdy+qbMUf2ime62GIUmkOYs20nz+5F7haWO
        qdXnTYz3vHsNgkL6Rz4F44+ozb7CPgyeVX1kHGlwfUlEb1BzuA==
X-Google-Smtp-Source: ABdhPJyKrLNjNzW8T4M7sVP8p/JDi1lpUGIbQO8F+0rLuAnOAy6XRJ9V5vmfjSSBb9vmL7XayBvdWjtRLiQBt04fDPY=
X-Received: by 2002:a05:6602:2245:: with SMTP id o5mr7064224ioo.105.1599733275286;
 Thu, 10 Sep 2020 03:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200903012224.GL11695@sjchrist-ice> <20200903162304.19694-1-jiangshanlai@gmail.com>
In-Reply-To: <20200903162304.19694-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 10 Sep 2020 18:21:04 +0800
Message-ID: <CAJhGHyDQMsdtEe8gxDW4A_YOgu4SeCmmm18pBcPA-S4sRhSiMw@mail.gmail.com>
Subject: Re: [PATCH V3] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
To:     LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

Hi, Paolo

Could you pick the patch please?

I think it'd be better to be merged before v5.9 is released
since it fixes a flaw.

Thanks
Lai

On Thu, Sep 3, 2020 at 11:22 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> When kvm_mmu_get_page() gets a page with unsynced children, the spt
> pagetable is unsynchronized with the guest pagetable. But the
> guest might not issue a "flush" operation on it when the pagetable
> entry is changed from zero or other cases. The hypervisor has the
> responsibility to synchronize the pagetables.
>
> The linux kernel behaves correctly as above for many years, but a recent
> commit 8c8560b83390 ("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for
> MMU specific flushes") inadvertently included a line of code to change it
> without giving any reason in the changelog. It is clear that the commit's
> intention was to change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT,
> so we don't unneedlesly flush other contexts but one of the hunks changed
> nearby KVM_REQ_MMU_SYNC instead.
>
> This patch changes it back.
>
> Fixes: 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
> Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from v1:
>         update patch description
>
> Changed form v2:
>         update patch description
>
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
