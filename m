Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B974EE809
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiDAGJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiDAGJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:09:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF0125F642
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:07:40 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b13so1761092pfv.0
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JC975jqGdiLRLhWjnwwn/6ecRehq409qPW+iVF2xd1A=;
        b=Cn4SuP2ca6r1NvKtXXPRoUEL+NpQqYzl2WXGXhPBqZmFTd4aDLo6oshsvmx/E8ItQZ
         KgFUZYCZ1GdN3k3FCagDQ+SiUpQNqtT1YuHL60bRBy/3DFiRGWTAF20RsEfRo/rE0Qcn
         8vHciwB9PPjPUBwjm/Tl/HhPo0ekFTQvwbv/OtS6sqhrwI30CUsKWeJUzuiY2FRpOHUq
         +npbZ0WY82jZE4HNfuRlpIsHts171WnpaHi1bQjxjXxUilAARNgYt0bbOakMibco81/J
         kw78FT74e3FTseHvBfswUdxNp7Zj65/cawrkc7BF7vp8Oppfwm98gdvPb7qmWh6Hah5j
         o4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JC975jqGdiLRLhWjnwwn/6ecRehq409qPW+iVF2xd1A=;
        b=uavdIzJvv3fblKwhxDoh8yTSMUL9VTGJhtXInsI4+dEOAc21kgR9YUBNQ/T5n1kEll
         fq+foM/H+oYt6jjs4b/9APJdTMQpiGjvGj3sNzk2cqwckZcNhY/HdpJyAnNtri7n8sHh
         VH9CzfSk5py33dyE4FsUyfA0E+07KgKq5KMYc9MvFV2a5jSYLOxC3+zcj77/HBlkrJkZ
         b67G2EkiHwUyZsbhe2byfJq/Ijs7OC1UDqoai+9F4rUSlTVbr6rPm+5/5LLmVZo//DOs
         qC2xDmIbxaO1iDcvuXTTDpKbpTr6+HeVuBGR4hkyCq001+5WnggXh211OdqC5ZNJuNlE
         gqGg==
X-Gm-Message-State: AOAM531OyP0kdDKac7qwVnUYOjp5pizuISkqegpMg/SJUiY7SRYMJx2c
        LHLT9gCqTborY4e9a/Dd7pYQyI9kLPOVOrI9KvDXNw==
X-Google-Smtp-Source: ABdhPJxtC47RWhR5tlIkYa+YMgaqWV7aGtq2N7PoQ5wJ7w4vThHNlFMC920zTOZSLcC8suY21Q9WU24t6iJG/5le+po=
X-Received: by 2002:a05:6a00:179f:b0:4fa:ecc3:a6ea with SMTP id
 s31-20020a056a00179f00b004faecc3a6eamr9306828pfg.82.1648793259671; Thu, 31
 Mar 2022 23:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220331213844.2894006-1-oupton@google.com>
In-Reply-To: <20220331213844.2894006-1-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 31 Mar 2022 23:07:23 -0700
Message-ID: <CAAeT=FzmvwmXoxn41xqYJByNgGMwCRViCUP9yZ0cun13nJ43PQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't split hugepages outside of MMU write lock
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Mar 31, 2022 at 2:38 PM Oliver Upton <oupton@google.com> wrote:
>
> It is possible to take a stage-2 permission fault on a page larger than
> PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
> eagerly maps at the largest possible block size. When dirty logging is
> enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
> mappings and instead clears the write bit on the pte.
>
> Since dirty logging is always performed at PAGE_SIZE granularity, KVM
> lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
> fault handler. This operation must be done under the write lock. Since
> commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
> relaxation during dirty logging"), the stage-2 fault handler
> conditionally takes the read lock on permission faults with dirty
> logging enabled. To that end, it is possible to split a 2M block mapping
> while only holding the read lock.
>
> The problem is demonstrated by running kvm_page_table_test with 2M
> anonymous HugeTLB, which splats like so:
>
>   WARNING: CPU: 5 PID: 15276 at arch/arm64/kvm/hyp/pgtable.c:153 stage2_map_walk_leaf+0x124/0x158
>
>   [...]
>
>   Call trace:
>   stage2_map_walk_leaf+0x124/0x158
>   stage2_map_walker+0x5c/0xf0
>   __kvm_pgtable_walk+0x100/0x1d4
>   __kvm_pgtable_walk+0x140/0x1d4
>   __kvm_pgtable_walk+0x140/0x1d4
>   kvm_pgtable_walk+0xa0/0xf8
>   kvm_pgtable_stage2_map+0x15c/0x198
>   user_mem_abort+0x56c/0x838
>   kvm_handle_guest_abort+0x1fc/0x2a4
>   handle_exit+0xa4/0x120
>   kvm_arch_vcpu_ioctl_run+0x200/0x448
>   kvm_vcpu_ioctl+0x588/0x664
>   __arm64_sys_ioctl+0x9c/0xd4
>   invoke_syscall+0x4c/0x144
>   el0_svc_common+0xc4/0x190
>   do_el0_svc+0x30/0x8c
>   el0_svc+0x28/0xcc
>   el0t_64_sync_handler+0x84/0xe4
>   el0t_64_sync+0x1a4/0x1a8
>
> Fix the issue by only acquiring the read lock if the guest faulted on a
> PAGE_SIZE granule w/ dirty logging enabled. Since it is possible for the
> faulting IPA to get collapsed into a larger block mapping until the read
> lock is acquired, retry the faulting instruction any time that the fault
> cannot be fixed by relaxing permissions. In so doing, the fault handler
> will acquire the write lock for the subsequent fault on a larger
> PAGE_SIZE mapping and split the block safely behind the write lock.
>
> Fixes: f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission relaxation during dirty logging")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>
> Applies cleanly to kvmarm/fixes at the following commit:
>
>   8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")
>
> Tested the patch by running KVM selftests. Additionally, I did 10
> iterations of the kvm_page_table_test with 2M anon HugeTLB memory.
>
> It is expected that this patch will cause fault serialization in the
> pathological case where all vCPUs are faulting on the same granule of
> memory, as every vCPU will attempt to acquire the write lock. The only
> safe way to cure this contention is to dissolve pages eagerly outside of
> the stage-2 fault handler (like x86).
>
>  arch/arm64/kvm/mmu.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0d19259454d8..9384325bf3df 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1079,7 +1079,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active = memslot_is_logging(memslot);
> -       bool logging_perm_fault = false;
> +       bool use_read_lock = false;
>         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>         unsigned long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> @@ -1114,7 +1114,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (logging_active) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
> -               logging_perm_fault = (fault_status == FSC_PERM && write_fault);
> +               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> +                                fault_granule == PAGE_SIZE);
>         } else {
>                 vma_shift = get_vma_page_shift(vma, hva);
>         }
> @@ -1218,7 +1219,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * logging dirty logging, only acquire read lock for permission
>          * relaxation.
>          */
> -       if (logging_perm_fault)
> +       if (use_read_lock)
>                 read_lock(&kvm->mmu_lock);
>         else
>                 write_lock(&kvm->mmu_lock);
> @@ -1267,10 +1268,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          */
>         if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
>                 ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);

When use_read_lock is set to true, it appears the above condition will
become always true (since fault_granule is PAGE_SIZE and force_pte
is true in this case).  So, I don't think the following "else" changes
really make any difference.  (Or am I overlooking something?)
Looking at the code, I doubt that even the original (before the regression)
code detects the case that is described in the comment below in the
first place.

Thanks,
Reiji

> -       } else {
> +       } else if (!use_read_lock) {
>                 ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>                                              __pfn_to_phys(pfn), prot,
>                                              memcache);
> +
> +       /*
> +        * The read lock is taken if the FSC indicates that the guest faulted on
> +        * a PAGE_SIZE granule. It is possible that the stage-2 fault raced with
> +        * a map operation that collapsed the faulted address into a larger
> +        * block mapping.
> +        *
> +        * Since KVM splits mappings down to PAGE_SIZE when dirty logging is
> +        * enabled, it is necessary to hold the write lock for faults where
> +        * fault_granule > PAGE_SIZE. Retry the faulting instruction and acquire
> +        * the write lock on the next exit.
> +        */
> +       } else {
> +               ret = -EAGAIN;
>         }
>
>         /* Mark the page dirty only if the fault is handled successfully */
> @@ -1280,7 +1295,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       if (logging_perm_fault)
> +       if (use_read_lock)
>                 read_unlock(&kvm->mmu_lock);
>         else
>                 write_unlock(&kvm->mmu_lock);
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
