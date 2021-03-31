Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504FE34F717
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhCaDC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 23:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhCaDC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 23:02:26 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F0BC061574;
        Tue, 30 Mar 2021 20:02:25 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w70so18712612oie.0;
        Tue, 30 Mar 2021 20:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJZNjW6b9Y+KVB3MOg16iUNyNSm6MhWVVSvFrHV9UWQ=;
        b=FOmnFOR1c/h9UlaYgC7AWT1hE4TEodNUbA5b9UxJ8iyJZ9rIc9okyseUDrKEXd8KXm
         +Q9NoLlljEpxYt3qj88mEvIsgAac4BE1bxcp9tWPDIxj7Vn2s+S0MKJbfXNgsLSxxa9F
         26i/kh6PXpGY2P74ronATJnJmwWA6SEQEEodKUKvvWPKZfWK0SEYnB6BVm7FFb1kU5+I
         H01X4orqFRKLvFviz/N5LAaceJ9+8qSZMf9VGQ2syhYFoDYNnFIhQiyjyc9hZ3FqDnNI
         oOxe8j9M9UFVHDdQaN/5LJRm2+YebUPMp+9P6PJ6MJiw/olxXNsVbuvM1BwPf3KI5BUm
         6Psg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJZNjW6b9Y+KVB3MOg16iUNyNSm6MhWVVSvFrHV9UWQ=;
        b=jzp26DvUVg9GDlvOUZP6gHBr5uh3Wl1GkJefLmK+MU+zO1sZiH4mICsYqeWwbgDDZe
         CTeaOEMSe188Jjr8HHq4ggmx9X/Plk040p9FXb4AMIRtubd28O5coE3pCs90qDMfJTkf
         k2aTNgkYshvuMBC2Y1Akr2n1ULNfCQdcCK/rK4ETTX6w3ucqZl/Uc6h1Wj/QNf4Sq5l5
         OpHT7+tSUqvjcxdr3fFpG1l0NtR4xNDAgKSqgovOV0l0PwimmfGQijF29415WF8Qv/IN
         0l0u8GECORVxVN2A3XmGyfvRwhz/29ELWFvXv0fwUHafhMxxMLuGxU6t7m6obTHqipnx
         jcdA==
X-Gm-Message-State: AOAM530QnaVoQSpmjFlGyA5jGxmQJYLS+j2p/PuwjmjRYLTqPwG4zcQL
        zku06P4lbdMpw5HxukHMvBbu9TcsDs5NSjss307hLh65
X-Google-Smtp-Source: ABdhPJxwP2S/PgnhvDY1OVZDMgm111Cl9KRSXSyCRChRbXqTEKz8OU+Yjm2t4CWKRuyMJb2DPeT78q0RxUd2YkI16c4=
X-Received: by 2002:aca:4748:: with SMTP id u69mr737357oia.5.1617159744637;
 Tue, 30 Mar 2021 20:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210331023025.2485960-1-seanjc@google.com> <20210331023025.2485960-2-seanjc@google.com>
In-Reply-To: <20210331023025.2485960-2-seanjc@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 31 Mar 2021 11:02:12 +0800
Message-ID: <CANRm+CwowrYPSnFNc11j5aT2JNw_k+NOh1apoxc3raVD4RVaAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: Account memory allocations for 'struct kvm_vcpu'
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 at 10:32, Sean Christopherson <seanjc@google.com> wrote:
>
> Use GFP_KERNEL_ACCOUNT for the vCPU allocations, the vCPUs are very much
> tied to a single task/VM.  For x86, the allocations were accounted up
> until the allocation code was moved to common KVM.  For all other
> architectures, vCPU allocations were never previously accounted, but only
> because most architectures lack accounting in general (for KVM).
>
> Fixes: e529ef66e6b5 ("KVM: Move vcpu alloc and init invocation to common code")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 383df23514b9..3884e9f30251 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3182,7 +3182,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>         if (r)
>                 goto vcpu_decrement;
>
> -       vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> +       vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);

kvm_vcpu_cache is created with SLAB_ACCOUNT flag in kvm_init(), this
flag will guarantee further slab alloc will be charged to memcg.
Please refer to memcg_slab_pre_alloc_hook(). So the patch is
unnecessary.

    Wanpeng
