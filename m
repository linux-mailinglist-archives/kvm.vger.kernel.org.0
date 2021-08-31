Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB1A3FCB0F
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 17:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhHaPy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 11:54:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232421AbhHaPy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 11:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630425241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cqcv7q3sxv359Hw+wbovVKAY99uifNtZJRnqtsftjkQ=;
        b=YKwMdUI8cbibJ51MM2h4YWBhild5JjCm2Z6eI23QO1tuHWwqKtOHW8UwbbC74Wztv7NYG0
        nSGpIndy8+vs3uL1OQMbUK/LdMvKfOST2rCPcxiyNu29lRJFFI9U/ZQnXhJJg+QgcKoml2
        QElmnsf7yv3pIlB6bnIU9ffGpvXcDts=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-4LmRuSeONXGsmMPc7yjOCg-1; Tue, 31 Aug 2021 11:54:00 -0400
X-MC-Unique: 4LmRuSeONXGsmMPc7yjOCg-1
Received: by mail-wm1-f72.google.com with SMTP id r4-20020a1c4404000000b002e728beb9fbso1433937wma.9
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 08:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Cqcv7q3sxv359Hw+wbovVKAY99uifNtZJRnqtsftjkQ=;
        b=UJMU+3GpQywGNJv2XFgrP5buxtWaTQmFy/ed2nIfrtCtXkRFmPzDsih5Yj/l6bZvD1
         2+rwuCoufW56by7o3bon4qmsV51TC432D2gUBdHlUfC5HthspbVY6d5+RbvF5T6l8y3v
         KuYc/CqWe7bX5Vomudr/b9n9fSxp/jaKNxHpsfo9I9DoZhoiZ/xLWMGprbPI/FvDt+lI
         2A4CPV25jNk40sZaZNNPrAUR8RUxqZ6i4TAZa/SVJjRzAcwjBpMBT1mBrSbX655Frkwk
         5ZSHWmA5tBe/vk6x456c8h+iNXbuTbfCMOJz4llzr9/DiVf522xqFI3HySz3+NRLhdW/
         truA==
X-Gm-Message-State: AOAM5304BU6pjQz4lmshaW1Y8Ghg49Yx046CACbgMgthc9yDNwwF629j
        N20Fibem9YlGTekllAx7l5dkZ4NAs1/zKxh0sB4UgV0BuBQ96fiFdDdeHPsq/A+0+WchdUnKN4g
        EvXx8vZqmxYoD
X-Received: by 2002:a5d:6daa:: with SMTP id u10mr32428380wrs.31.1630425239228;
        Tue, 31 Aug 2021 08:53:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0EjHISPHLs3TIYt+0W/6JrjIDK3mdnV2vWllkRSIu0u63CB5Ml6SIBkpL6FesrH+HKFbrVg==
X-Received: by 2002:a5d:6daa:: with SMTP id u10mr32428349wrs.31.1630425238976;
        Tue, 31 Aug 2021 08:53:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z19sm3139223wma.0.2021.08.31.08.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 08:53:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     tcs.kernel@gmail.com
Cc:     Haimin Zhang <tcs_kernel@tencent.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko@kernel.org
Subject: Re: [PATCH] KVM: x86: Add a return code and check kvm_page_track_init
In-Reply-To: <1630376040-20567-1-git-send-email-tcs_kernel@tencent.com>
References: <1630376040-20567-1-git-send-email-tcs_kernel@tencent.com>
Date:   Tue, 31 Aug 2021 17:53:57 +0200
Message-ID: <87wno1obje.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tcs.kernel@gmail.com writes:

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

Nitpick: pointless initializer, the value is always overwritten by
init_srcu_struct()'s return value.

>  	struct kvm_page_track_notifier_head *head;
>  
>  	head = &kvm->arch.track_notifier_head;
> -	init_srcu_struct(&head->track_srcu);
> +	r = init_srcu_struct(&head->track_srcu);
> +	if (r)
> +		return r;
>  	INIT_HLIST_HEAD(&head->track_notifier_list);
> +	return r;
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

Blank line missing here.

>  	if (type)
> -		return -EINVAL;
> +		return r;

I'd keep this code as-is and dropped then-pointless initializer to
-EINVAL, it's OK to return directly:

	int ret;

	if (type)
		return -EINVAL;

        ...

        ret = kvm_page_track_init(kvm);
	if (ret)
		return ret;

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
>  	kvm_mmu_init_vm(kvm);
>  
>  	return static_call(kvm_x86_vm_init)(kvm);

-- 
Vitaly

