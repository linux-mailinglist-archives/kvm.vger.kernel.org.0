Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7F2351D01
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbhDASXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239284AbhDASP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:15:56 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E48C03115B
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 09:50:12 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id j16so2550160ilq.13
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uVJlz7EBFUJTVJxoNelXauAVdIkkrJxCY7MPgIbB9eA=;
        b=HnT6yrUdSlZ/rXVnoydEGJNeSCzPLozNWzBZYqwlIduHxEll05y2hoskd8WkvoSpgV
         JWOQQ5mn5UH16lEKPBBRlgluAlq0oaeaWHZfqEthrSYrM5E0ExJtpU8ljphBhEEcFVix
         jmWg4SmU5pFjrhrpRpK8yUBBb6DRUA5+MZOyDICqKxjLvWM3mKkuhRH5AFJuVSZwWTc1
         MCAQfmIiJ2XVPpt01aihVg7DHpTYuVdeS9ZV5Fhe9HWFngMAK6owumWPw5nUVMNfuM6j
         /zerO0OjlV7Pk3EmkWkNAYDkMDvPnSV5YN+TqGxjec8vdjv1u5BbSjJOBk2lvCs1uT8+
         LrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uVJlz7EBFUJTVJxoNelXauAVdIkkrJxCY7MPgIbB9eA=;
        b=PmUTdnGdUtn156iZltaXSdYyaN9D1xtCQZ36Kjf7R8rCf1z4+O/8cuEOQgMzHfN4qS
         JMTqkZkbtO+rWBKdzD/tOzOSBr4/tIhpE5Vo5GfSjVCpTJLY5Zv5OiOku1TWXkWdcOej
         h9qj/G3neXgoCAyRI/oJ55gnAmK5H7aPb8XeAM6LOXpfyzvwfk2PBSK7MJKl5RPR7i5q
         uzoI9Wdua/A1CM+bzlsHXnkNONJgcC4LEsoCKTTyW/uG1ElM8ef6PfXw2W8XCuhyrChW
         /YSI+y609FXr+llV3acbAl4nqO3ZII6feyDTEHQk/3uv7R05O/Pe7MbFXYMLFvRmoum1
         eiug==
X-Gm-Message-State: AOAM532k7F7BlnCRM7lmyo34/2+FF6U1jEXtRrPkDUAkprVFXu3BGxBH
        zcivRVWfNBGrJcPKUW47g08LTO8m/eQD2RuZZr1LEA==
X-Google-Smtp-Source: ABdhPJybXOA1eXtNH5cMvnR9/6T4oBIJW9f/CwtYVh3dyIM318COLUmgmqQA1YIg9p5GAbxYkWqaNL/9TNHn0oSRNQw=
X-Received: by 2002:a92:340e:: with SMTP id b14mr927052ila.285.1617295811243;
 Thu, 01 Apr 2021 09:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210331210841.3996155-9-bgardon@google.com> <202104012131.qcIIr4tP-lkp@intel.com>
In-Reply-To: <202104012131.qcIIr4tP-lkp@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 1 Apr 2021 09:50:00 -0700
Message-ID: <CANgfPd9OYoAk5k8nDZmsMEVU_PKTg4zcJJtnBtDPy1CNwXeEGg@mail.gmail.com>
Subject: Re: [PATCH 08/13] KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
To:     kernel test robot <lkp@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 1, 2021 at 6:17 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Ben,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on next-20210331]
> [cannot apply to kvm/queue tip/master linux/master linus/master v5.12-rc5 v5.12-rc4 v5.12-rc3 v5.12-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Ben-Gardon/More-parallel-operations-for-the-TDP-MMU/20210401-051137
> base:    7a43c78d0573e0bbbb0456b033e2b9a895b89464
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/2b2c6d3bdc35269df5f9293a02da5b71c74095f3
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Ben-Gardon/More-parallel-operations-for-the-TDP-MMU/20210401-051137
>         git checkout 2b2c6d3bdc35269df5f9293a02da5b71c74095f3
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/rculist.h:11,
>                     from include/linux/pid.h:5,
>                     from include/linux/sched.h:14,
>                     from include/linux/hardirq.h:9,
>                     from include/linux/kvm_host.h:7,
>                     from arch/x86/kvm/mmu.h:5,
>                     from arch/x86/kvm/mmu/tdp_mmu.c:3:
>    arch/x86/kvm/mmu/tdp_mmu.c: In function 'kvm_tdp_mmu_get_vcpu_root_hpa':
> >> arch/x86/kvm/mmu/tdp_mmu.c:139:5: error: implicit declaration of function 'lockdep_is_held_write'; did you mean 'lockdep_is_held_type'? [-Werror=implicit-function-declaration]
>      139 |     lockdep_is_held_write(&kvm->mmu_lock))

Huh, I wonder why this isn't exported in some configuration. I'll fix
this in v2 as well.

>          |     ^~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:318:52: note: in definition of macro 'RCU_LOCKDEP_WARN'
>      318 |   if (debug_lockdep_rcu_enabled() && !__warned && (c)) { \
>          |                                                    ^
>    include/linux/rculist.h:391:7: note: in expansion of macro '__list_check_rcu'
>      391 |  for (__list_check_rcu(dummy, ## cond, 0),   \
>          |       ^~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/tdp_mmu.c:138:2: note: in expansion of macro 'list_for_each_entry_rcu'
>      138 |  list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link, \
>          |  ^~~~~~~~~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/tdp_mmu.c:184:2: note: in expansion of macro 'for_each_tdp_mmu_root'
>      184 |  for_each_tdp_mmu_root(kvm, root) {
>          |  ^~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
>
>
> vim +139 arch/x86/kvm/mmu/tdp_mmu.c
>
>      2
>    > 3  #include "mmu.h"
>      4  #include "mmu_internal.h"
>      5  #include "mmutrace.h"
>      6  #include "tdp_iter.h"
>      7  #include "tdp_mmu.h"
>      8  #include "spte.h"
>      9
>     10  #include <asm/cmpxchg.h>
>     11  #include <trace/events/kvm.h>
>     12
>     13  static bool __read_mostly tdp_mmu_enabled = false;
>     14  module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
>     15
>     16  /* Initializes the TDP MMU for the VM, if enabled. */
>     17  void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>     18  {
>     19          if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
>     20                  return;
>     21
>     22          /* This should not be changed for the lifetime of the VM. */
>     23          kvm->arch.tdp_mmu_enabled = true;
>     24
>     25          INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>     26          spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
>     27          INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
>     28  }
>     29
>     30  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>     31  {
>     32          if (!kvm->arch.tdp_mmu_enabled)
>     33                  return;
>     34
>     35          WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>     36
>     37          /*
>     38           * Ensure that all the outstanding RCU callbacks to free shadow pages
>     39           * can run before the VM is torn down.
>     40           */
>     41          rcu_barrier();
>     42  }
>     43
>     44  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>     45                            gfn_t start, gfn_t end, bool can_yield);
>     46
>     47  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>     48  {
>     49          free_page((unsigned long)sp->spt);
>     50          kmem_cache_free(mmu_page_header_cache, sp);
>     51  }
>     52
>     53  /*
>     54   * This is called through call_rcu in order to free TDP page table memory
>     55   * safely with respect to other kernel threads that may be operating on
>     56   * the memory.
>     57   * By only accessing TDP MMU page table memory in an RCU read critical
>     58   * section, and freeing it after a grace period, lockless access to that
>     59   * memory won't use it after it is freed.
>     60   */
>     61  static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>     62  {
>     63          struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
>     64                                                 rcu_head);
>     65
>     66          tdp_mmu_free_sp(sp);
>     67  }
>     68
>     69  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
>     70  {
>     71          gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
>     72
>     73          lockdep_assert_held_write(&kvm->mmu_lock);
>     74
>     75          if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>     76                  return;
>     77
>     78          WARN_ON(!root->tdp_mmu_page);
>     79
>     80          spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>     81          list_del_rcu(&root->link);
>     82          spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>     83
>     84          zap_gfn_range(kvm, root, 0, max_gfn, false);
>     85
>     86          call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>     87  }
>     88
>     89  /*
>     90   * Finds the next valid root after root (or the first valid root if root
>     91   * is NULL), takes a reference on it, and returns that next root. If root
>     92   * is not NULL, this thread should have already taken a reference on it, and
>     93   * that reference will be dropped. If no valid root is found, this
>     94   * function will return NULL.
>     95   */
>     96  static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>     97                                                struct kvm_mmu_page *prev_root)
>     98  {
>     99          struct kvm_mmu_page *next_root;
>    100
>    101          lockdep_assert_held_write(&kvm->mmu_lock);
>    102
>    103          rcu_read_lock();
>    104
>    105          if (prev_root)
>    106                  next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
>    107                                                    &prev_root->link,
>    108                                                    typeof(*prev_root), link);
>    109          else
>    110                  next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
>    111                                                     typeof(*next_root), link);
>    112
>    113          while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
>    114                  next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
>    115                                  &next_root->link, typeof(*next_root), link);
>    116
>    117          rcu_read_unlock();
>    118
>    119          if (prev_root)
>    120                  kvm_tdp_mmu_put_root(kvm, prev_root);
>    121
>    122          return next_root;
>    123  }
>    124
>    125  /*
>    126   * Note: this iterator gets and puts references to the roots it iterates over.
>    127   * This makes it safe to release the MMU lock and yield within the loop, but
>    128   * if exiting the loop early, the caller must drop the reference to the most
>    129   * recent root. (Unless keeping a live reference is desirable.)
>    130   */
>    131  #define for_each_tdp_mmu_root_yield_safe(_kvm, _root)   \
>    132          for (_root = tdp_mmu_next_root(_kvm, NULL);     \
>    133               _root;                                     \
>    134               _root = tdp_mmu_next_root(_kvm, _root))
>    135
>    136  /* Only safe under the MMU lock in write mode, without yielding. */
>    137  #define for_each_tdp_mmu_root(_kvm, _root)                              \
>    138          list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link, \
>  > 139                                  lockdep_is_held_write(&kvm->mmu_lock))
>    140
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
