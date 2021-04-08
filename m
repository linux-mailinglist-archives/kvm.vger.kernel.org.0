Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F20B358173
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhDHLP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhDHLP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 07:15:26 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFDFC061760;
        Thu,  8 Apr 2021 04:15:14 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id m13so1724303oiw.13;
        Thu, 08 Apr 2021 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FylWEYGitKEaCSH784s5zRlwMAjF/aD1+YiS/V9+4Qg=;
        b=Ke7k/7GHop2pIvA/9h+q3GUmYQ/ttLnITplBVVA/KnG8JkqQFR78+3r9DPsWvhy/f8
         fponDB0OmMGCdQqu9/U0Hy4X2wmQoaJvmUwHaPO9v49Z0KSq8MyqrK8njlI1q426mJgU
         vXhxnh+IaCz+TZAAy4EY3bsM9tij1TAwQ8pkIe1XAnJ7JAcl/9+b/nIgAThGIi28FFPm
         vUV1LvsJOIN9KDcWzvoOjANx4NV5niv1YAcYZwAukjbpzrXeutZQMF6Fxl54IbUQLnbE
         ayJ3/ApFuUeOm+VWCsayGdNtjtqd8ZjFsmC+cb2nWOH9yJ2JJ5amqexkBbQCr3Yjtc+5
         MpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FylWEYGitKEaCSH784s5zRlwMAjF/aD1+YiS/V9+4Qg=;
        b=jvUcfOkgQyYvopo7bZF/RpVAavNf6HmBvTf5gPuPC7/Nzxxlu/eHzPRvohMs9m+zWl
         RrHupNAEGY5lT402f0PhClU+RhH13NNN0VOT24cPuQ0gJZ70RHvbfevZ183736pjHLmA
         ko6OTKNmufKBrYv74qkz3N0oWv7/Ty/eeS85Ed3YnnwE7lkfQq1d/V431My+pu28p879
         oR0HVej2c+O6bbEIeD/+eE8chEq7rVNUke5B9gAY6FAdRvi3cd/4P+vho7YHmc1KH4x6
         LzPZJClL99+I3BFY/TrEwR5EaCF0naC/82RpgrUgmzn7knDaaWDN325yHCFozYlxjz3g
         62Gw==
X-Gm-Message-State: AOAM5307XxQgA6Lh2bPIdHDkDGVU8E8fZxgFruafkQpsXt2RCt456HTY
        kByarhd4KM+RrFeKxD7TcqcYZYkcikCpy1biYc4=
X-Google-Smtp-Source: ABdhPJxxkyPtqE/3yyw7xtmIFCDI8ldlLV6q7jg22Fw1FidzGDAC90LPf0iOR1CnD1X1P8HN1SaO0JoigCqDkUir3Uc=
X-Received: by 2002:aca:1a01:: with SMTP id a1mr5677316oia.33.1617880513703;
 Thu, 08 Apr 2021 04:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com> <20210305011101.3597423-8-seanjc@google.com>
In-Reply-To: <20210305011101.3597423-8-seanjc@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 8 Apr 2021 19:15:01 +0800
Message-ID: <CANRm+CzUAzR+D3BtkYpe71sHf_nmtm_Qmh4neqc=US2ETauqyQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] KVM: x86/mmu: Check PDPTRs before allocating PAE roots
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Mar 2021 at 09:12, Sean Christopherson <seanjc@google.com> wrote:
>
> Check the validity of the PDPTRs before allocating any of the PAE roots,
> otherwise a bad PDPTR will cause KVM to leak any previously allocated
> roots.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7ebfbc77b050..9fc2b46f8541 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3269,7 +3269,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
> -       u64 pdptr, pm_mask;
> +       u64 pdptrs[4], pm_mask;
>         gfn_t root_gfn, root_pgd;
>         hpa_t root;
>         int i;
> @@ -3280,6 +3280,17 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>         if (mmu_check_root(vcpu, root_gfn))
>                 return 1;
>
> +       if (mmu->root_level == PT32E_ROOT_LEVEL) {
> +               for (i = 0; i < 4; ++i) {
> +                       pdptrs[i] = mmu->get_pdptr(vcpu, i);
> +                       if (!(pdptrs[i] & PT_PRESENT_MASK))
> +                               continue;
> +
> +                       if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> +                               return 1;
> +               }
> +       }
> +

I saw this splatting:

 BUG: sleeping function called from invalid context at
arch/x86/kvm/kvm_cache_regs.h:115
 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3090, name:
qemu-system-x86
 3 locks held by qemu-system-x86/3090:
  #0: ffff8d499f8d00d0 (&vcpu->mutex){+.+.}-{3:3}, at:
kvm_vcpu_ioctl+0x8e/0x680 [kvm]
  #1: ffffb1b540f873e8 (&kvm->srcu){....}-{0:0}, at:
vcpu_enter_guest+0xb30/0x1b10 [kvm]
  #2: ffffb1b540f7d018 (&(kvm)->mmu_lock){+.+.}-{2:2}, at:
kvm_mmu_load+0xb5/0x540 [kvm]
 Preemption disabled at:
 [<ffffffffc0787365>] kvm_mmu_load+0xb5/0x540 [kvm]
 CPU: 2 PID: 3090 Comm: qemu-system-x86 Tainted: G        W  OE
5.12.0-rc3+ #3
 Call Trace:
  dump_stack+0x87/0xb7
  ___might_sleep+0x202/0x250
  __might_sleep+0x4a/0x80
  kvm_pdptr_read+0x20/0x60 [kvm]
  kvm_mmu_load+0x3bd/0x540 [kvm]
  vcpu_enter_guest+0x1297/0x1b10 [kvm]
  kvm_arch_vcpu_ioctl_run+0x372/0x690 [kvm]
  kvm_vcpu_ioctl+0x3ca/0x680 [kvm]
  __x64_sys_ioctl+0x27a/0x800
  do_syscall_64+0x38/0x50
  entry_SYSCALL_64_after_hwframe+0x44/0xae

There is a might_sleep() in kvm_pdptr_read(), however, the original
commit didn't explain more. I can send a formal one if the below fix
is acceptable.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efb41f3..f33026f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3289,17 +3289,24 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
     if (mmu_check_root(vcpu, root_gfn))
         return 1;

+    write_unlock(&vcpu->kvm->mmu_lock);
     if (mmu->root_level == PT32E_ROOT_LEVEL) {
         for (i = 0; i < 4; ++i) {
             pdptrs[i] = mmu->get_pdptr(vcpu, i);
             if (!(pdptrs[i] & PT_PRESENT_MASK))
                 continue;

-            if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
+            if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT)) {
+                write_lock(&vcpu->kvm->mmu_lock);
                 return 1;
+            }
         }
     }

+    write_lock(&vcpu->kvm->mmu_lock);
+    if (make_mmu_pages_available(vcpu))
+        return -ENOSPC;
+
     /*
      * Do we shadow a long mode page table? If so we need to
      * write-protect the guests page table root.
