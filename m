Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B43FCA5A
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhHaOvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 10:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbhHaOvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 10:51:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5817C061760
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 07:50:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2614758pjq.4
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 07:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ohiiHqesNPeC/mV3ttMhan9fJsp+PESpTprhKRQBUys=;
        b=qxeDHCHkDXDv36deSisEv8D00T7si8oSUAAGdKI+OujJdeG3kU2Krk0jLUlMop5tlA
         UF1sbjLOAalJQB7zHjak8XuQewtqPJAJh3UiXkAMu/+xnqBqJiswiJ96U1wPzbSHm8xt
         4l9kAuL4OUEKEm6/ADbKppZOAUF91RYuTswtWLUHR5MikFGSnRw1yVM0Zur5X56DnGLP
         LfrOLD18Zf2pz16uJ3AMbfrfxVJqryPYu2q5BoM4kYM9A9ah8sLRcQNiCHc0pEpwLVfC
         bdlkVP0srN/TALyDbaSiuLLOrDOETb2z+YFmjTvj33X2riU5lQL8/ovfZ5BRkSuSmCU2
         9vLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ohiiHqesNPeC/mV3ttMhan9fJsp+PESpTprhKRQBUys=;
        b=LUok8rNcqyrCwjASF0AeQNVPF51pGxJ2nXiJOhzh0p41hVgpcAIbvfpY2uSA1Z48/h
         wZ/4RAorhZcqbXRuaQpgN8A50V9xaLmo7mPjPqul2sMfxJfvnlzwfoXdAs53zvvk9eeD
         QQ27WBbn7HkQkJl63j1n7u6v9rs3AjfgDLgvQuKEQHAEn9owsSdkk2sRNErrNrCXkOSW
         QZaJwPS2emA0HYTaKGrK0/0FmgNpEcR5xnfjPfVhReqCxXd9YIkC6bg/zHcQGt23k8SM
         xpDeXbSIs9WpRpwhxpAp/dH/kthcXEiA4sidKpMxWKAbjpXHQbMazEqQUJhokvWgKe3U
         2nPw==
X-Gm-Message-State: AOAM5326wQBYHX+9Yj0mOK7Uu8awjlKPmW36M3wWK04h1s9TyM78TEkn
        FntjHOAokSHowT4VDsIGnNMtUA==
X-Google-Smtp-Source: ABdhPJx2U01+1IX8ZEA2HMzsm5rbu7780DiR3Dut8yt/oVACgZD4uw7vNgwPlFJ5fjNmWn2VZfvpBA==
X-Received: by 2002:a17:90a:4481:: with SMTP id t1mr6006880pjg.232.1630421411692;
        Tue, 31 Aug 2021 07:50:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t15sm20610705pgk.13.2021.08.31.07.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 07:50:11 -0700 (PDT)
Date:   Tue, 31 Aug 2021 14:50:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     tcs.kernel@gmail.com
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org,
        Haimin Zhang <tcs_kernel@tencent.com>
Subject: Re: [PATCH] KVM: x86: Add a return code and check kvm_page_track_init
Message-ID: <YS5Bn6I6wVEL8wKS@google.com>
References: <1630376040-20567-1-git-send-email-tcs_kernel@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630376040-20567-1-git-send-email-tcs_kernel@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the shortlog, describe what is being fixed instead of the literal code change,
otherwise the shortlog doesn't help explain _why_ a change is being made.

On Tue, Aug 31, 2021, tcs.kernel@gmail.com wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> We found a null pointer deref by our modified syzkaller.
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  CPU: 1 PID: 13993 Comm: syz-executor.0 Kdump: loaded Tainted: 
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
>  BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
>  RIP: 0010:rcu_segcblist_enqueue+0xf5/0x1d0 
>  RSP: 0018:ffffc90001e1fc10 EFLAGS: 00010046
>  RAX: dffffc0000000000 RBX: ffff888135c00080 RCX: ffffffff815ba8a1
>  RDX: 0000000000000000 RSI: ffffc90001e1fd00 RDI: ffff888135c00080
>  RBP: ffff888135c000a0 R08: 0000000000000004 R09: fffff520003c3f75
>  R10: 0000000000000003 R11: fffff520003c3f75 R12: 0000000000000000
>  R13: ffff888135c00080 R14: ffff888135c00040 R15: 0000000000000000
>  FS:  00007fecc99f1700(0000) GS:ffff888135c00000(0000) knlGS:0000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000001b2f225000 CR3: 0000000093d08000 CR4: 0000000000750ee0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  PKRU: 55555554
>  Call Trace:
>  srcu_gp_start_if_needed+0x158/0xc60 build/../kernel/rcu/srcutree.c:823
>  __synchronize_srcu+0x1dc/0x250 build/../kernel/rcu/srcutree.c:929
>  kvm_mmu_uninit_vm+0x18/0x30 build/../arch/x86/kvm/mmu/mmu.c:5585
>  kvm_arch_destroy_vm+0x43f/0x5c0 build/../arch/x86/kvm/x86.c:11277
>  kvm_create_vm build/../arch/x86/kvm/../../../virt/kvm/kvm_main.c:1060 
>  kvm_dev_ioctl_create_vm build/../arch/x86/kvm/../../../virt/kvm/kvm_main
>  kvm_dev_ioctl+0xdfb/0x1860 build/../arch/x86/kvm/../../../virt/kvm/kvm_main
>  vfs_ioctl build/../fs/ioctl.c:51 [inline]
>  __do_sys_ioctl build/../fs/ioctl.c:1069 [inline]
>  __se_sys_ioctl build/../fs/ioctl.c:1055 [inline]
>  __x64_sys_ioctl+0x183/0x210 build/../fs/ioctl.c:1055
>  do_syscall_x64 build/../arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x34/0xb0 build/../arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

Newline here to make it easier to differentiate between the splat and the
explanation.  Though I would say hoist the explanation of the "why" to the top, e.g.

  KVM: x86: Handle SRCU initialization failure during page track init

  Check the return of init_srcu_struct(), which can fail due to OOM, when
  initializing the page track mechanism.  Lack of checking leads to a NULL
  pointer deref found by a modified syzkaller.

  <splat goes here>

> This is because when init_srcu_struct() calls alloc_percpu(struct
> srcu_data) failed, kvm_page_track_init() didn't check init_srcu_struct
> return code. 
> 
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> ---
>  arch/x86/include/asm/kvm_page_track.h | 2 +-
>  arch/x86/kvm/mmu/page_track.c         | 8 ++++++--
>  arch/x86/kvm/x86.c                    | 7 +++++--
>  3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 87bd6025d91d..6a5f3acf2b33 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
>  			    struct kvm_page_track_notifier_node *node);
>  };
>  
> -void kvm_page_track_init(struct kvm *kvm);
> +int kvm_page_track_init(struct kvm *kvm);
>  void kvm_page_track_cleanup(struct kvm *kvm);
>  
>  void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 91a9f7e0fd91..44a67a50f6d2 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -163,13 +163,17 @@ void kvm_page_track_cleanup(struct kvm *kvm)
>  	cleanup_srcu_struct(&head->track_srcu);
>  }
>  
> -void kvm_page_track_init(struct kvm *kvm)
> +int kvm_page_track_init(struct kvm *kvm)
>  {
> +	int r = -ENOMEM;

Unnecessary initialization.

>  	struct kvm_page_track_notifier_head *head;
>  
>  	head = &kvm->arch.track_notifier_head;
> -	init_srcu_struct(&head->track_srcu);
> +	r = init_srcu_struct(&head->track_srcu);
> +	if (r)
> +		return r;
>  	INIT_HLIST_HEAD(&head->track_notifier_list);
> +	return r;

Just do "return 0", which is guaranteed by the above.  Or even better, I would
vote for returning init_srcu_struct() directly, the ordering doesn't matter and
obviously failure is a very rare occurence.

	@@ -175,8 +175,8 @@ void kvm_page_track_init(struct kvm *kvm)
        struct kvm_page_track_notifier_head *head;
 
        head = &kvm->arch.track_notifier_head;
-       init_srcu_struct(&head->track_srcu);
        INIT_HLIST_HEAD(&head->track_notifier_list);
+       return init_srcu_struct(&head->track_srcu);
 }
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..5da76f989207 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11086,8 +11086,9 @@ void kvm_arch_free_vm(struct kvm *kvm)
>  
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
> +	int r = -EINVAL;

Unnecessary initialization.

>  	if (type)
> -		return -EINVAL;
> +		return r;

Unrelated and unnecessary change.

>  
>  	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> @@ -11121,7 +11122,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	kvm_apicv_init(kvm);
>  	kvm_hv_init_vm(kvm);
> -	kvm_page_track_init(kvm);
> +	r = kvm_page_track_init(kvm);
> +	if (r)
> +		return r;

Hmm, so I don't see anything above this that needs to be unwound, but I'm still
worried this will be hard to audit/maintain.

As an alternative "fix", about dropping kvm->arch.track_notifier_head.track_srcu
and using kvm->srcu?  kvm_page_track_write() pretty much _has_ to hold that since
the caller is writing guest memory, and conversely kvm_page_track_flush_slot()
_can't_ hold it because the caller is modifying memslots and thus would deadlock
if it held kvm->srcu for read.  In other words, kvm_page_track_write() can rely
(assert?) on vcpu->srcu_idx, and kvm_page_track_flush_slot() can take and release
kvm->srcu.

Practially speaking, (Un)Registering is going to happen only at VM creation so
waiting all kvm->srcu readers instead of just page track readers should not be a
problem.

>  	kvm_mmu_init_vm(kvm);
>  
>  	return static_call(kvm_x86_vm_init)(kvm);
> -- 
> 2.27.0
> 
