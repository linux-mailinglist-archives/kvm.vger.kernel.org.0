Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479CF3FF6A2
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347658AbhIBVzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347834AbhIBVze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:34 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D18FC061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 14:54:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t1so3452434pgv.3
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Npc+X0loZsh5ebO7T770baDNp17eU05nzX/pG10qCo=;
        b=h3A42v79cQgO+azy+5YH+vjJ8g6uYAnsYVAxuIsSzOXrqrbVeLOBZxRle290QJLD3R
         lFdCZO9yumPVa81vhm2f1Odf3ZQSJCwMvZ7O65qtGL+8Roh3lm7NbAgEc1ZaznwEN843
         hRmrUpy33nXjqZsBo7CZGhlD57rdtXUIXCMs4zAgHLlRg62ydHXJlag5+IwMhxP1cAlq
         6n1VuY1scLhK8REOCYmm90Jm9MuVgsXydIgTnEAs4gloOD2UlDB8X4y8RaSWHdj0/HXR
         Sp5//6CXtNw+T9LdIgNx3doqnOd21g6eydkUmWu7gTjxhli2/CESnKvpCMOYx3iGnz3s
         ozeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Npc+X0loZsh5ebO7T770baDNp17eU05nzX/pG10qCo=;
        b=EG1Ga9iAJiGZv2tdEgTJeWgFV/WoO+O2qwisOojdw+qxA68hu0oDBO7QICUPFlJqSk
         skzKybUIXoOYAPji5cc1RmBzAKxiuIDz4Ngjc6MIahiUF16ST4BtivbcnxrtY92/J2rS
         a5cfEHlhnuUKsGOvWD4HhKpPytCMEMcd/86sIZYnkdNNXk1t/eL6Z6JU1CrnFg9IQTAS
         auEUb+BrRA+LXlcexyoR+JOp12645P/VW6gSQ9H186ei+f2A3/tywHxIE/tQUNOKCSYB
         8fM4so0COfy9PUGDQBdhIz03miatI/vk1phzKZMwqpCuCf8YbJzibcJVzbhnhbwGpV54
         9dwg==
X-Gm-Message-State: AOAM532aCFEf4aFMQBsFpbrIpsZYdbbV8CE21P8HvXDuO+mDYFjgV952
        1LG7VvfQI1SQrP5+LmIKHQROXg==
X-Google-Smtp-Source: ABdhPJzzT23GfE9mw1/czxBhzeVAB4LNx3fUZJgEKB/NnPGHWknIZWKht18G7sQqYokVixxhXvQIlw==
X-Received: by 2002:a65:6251:: with SMTP id q17mr463343pgv.416.1630619674901;
        Thu, 02 Sep 2021 14:54:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i14sm3083842pfd.112.2021.09.02.14.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:54:34 -0700 (PDT)
Date:   Thu, 2 Sep 2021 21:54:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] KVM: X86: Zap the invalid list after remote tlb
 flushing
Message-ID: <YTFIFlU9wtVHf4xd@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824075524.3354-4-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In mmu_sync_children(), it can zap the invalid list after remote tlb flushing.
> Emptifying the invalid list ASAP might help reduce a remote tlb flushing
> in some cases.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 987953a901d2..a165eb8713bc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2050,7 +2050,7 @@ static bool mmu_sync_children(struct kvm_vcpu *vcpu,
>  			protected |= rmap_write_protect(vcpu, sp->gfn);
>  
>  		if (protected) {
> -			kvm_flush_remote_tlbs(vcpu->kvm);
> +			kvm_mmu_flush_or_zap(vcpu, &invalid_list, true, flush);

This can just be 

			kvm_mmu_remote_flush_or_zap(vcpu, &invalid_list, true);

since a remote flush always does a local flush too.

Related to the tlbs_dirty revert, to avoid overzealous flushing, kvm_sync_page()
can pass back a "remote_flush" flag instead of doing the flush itself.  Something
like the below, or maybe multiplex an 'int' return.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ac260e01e9d8..f61de53de55a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2041,7 +2041,7 @@ static bool mmu_sync_children(struct kvm_vcpu *vcpu,
        struct mmu_page_path parents;
        struct kvm_mmu_pages pages;
        LIST_HEAD(invalid_list);
-       bool flush = false;
+       bool flush = false, remote_flush = false;

        while (mmu_unsync_walk(parent, &pages)) {
                bool protected = false;
@@ -2050,17 +2050,17 @@ static bool mmu_sync_children(struct kvm_vcpu *vcpu,
                        protected |= rmap_write_protect(vcpu, sp->gfn);

                if (protected) {
-                       kvm_mmu_flush_or_zap(vcpu, &invalid_list, true, flush);
-                       flush = false;
+                       kvm_mmu_remote_flush_or_zap(vcpu, &invalid_list, true);
+                       remote_flush = flush = false;
                }

                for_each_sp(pages, sp, parents, i) {
                        kvm_unlink_unsync_page(vcpu->kvm, sp);
-                       flush |= kvm_sync_page(vcpu, sp, &invalid_list);
+                       flush |= kvm_sync_page(vcpu, sp, &invalid_list, &remote_flush);
                        mmu_pages_clear_parents(&parents);
                }
                if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
-                       kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+                       kvm_mmu_flush_or_zap(vcpu, &invalid_list, remote_flush, flush);
                        cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
                        /*
                         * If @parent is not root, the caller doesn't have
@@ -2074,7 +2074,7 @@ static bool mmu_sync_children(struct kvm_vcpu *vcpu,
                }
        }

-       kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+       kvm_mmu_flush_or_zap(vcpu, &invalid_list, remote_flush, flush);
        return true;
 }

>  			flush = false;
>  		}
>  
> -- 
> 2.19.1.6.gb485710b
> 
