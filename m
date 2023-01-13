Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B1166A63A
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjAMWuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAMWu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:50:29 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F216C7EC84
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 14:50:27 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k18so832353pll.5
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 14:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQZCEBEaghsOR+zhl/QRIXPVX+uCKPvU91VQuy/V94s=;
        b=X76rLWdZrm8cdm781bGE/NuVpMIrvPOi9lGhvncTfFs81VVxsQB/QGGTWKxHh1GL1W
         d/AoRzt/BgZEnefw0frAVABgAhcfb0NjbvQQ6PThCX1YXedTBAqOobICTThGoiP6om5q
         O3KMRfb6M32Bg7CVQSQvIy3h9U9bkySatLBmzLp/OFGTsGTVJq+w1gHMbDBjfBgq7rHh
         ADYr+PPp2TF3nGbuwOKFE5/4euBQA3ZQaQSM4gqqLZGzGNJeHa+tfxiLoUS2z+t4YmPi
         kKxrLU/4iehY+TcpZNW1WLdBUrSh7cY4mTcXmXq7RCEGkbTb53lk/EI3QzzxovpqZqg9
         0htA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQZCEBEaghsOR+zhl/QRIXPVX+uCKPvU91VQuy/V94s=;
        b=GO58l1cXD+Zzit4i3OiJAe1+aZNKMwgXUkbGm/je3utx2fY2/gB99ZOm0KKhdu6AlS
         4qNhkPLDl3/pZLS0RbwTnQuLGLJ5NH7Fr0Ds+Fd9X/gqh3EldnuJyYnMGSuiwfgauy1I
         FvwbV8sZaK9hurzfnzkJuNy2j2f3daRsIezm+uW7MZ0GTKuu+wgcMm9xioPD47d6xW68
         SrgWG2WRkNQ+H7UJhq0QySc2vBSpwLP1SJcJDXDH7fsk7Q63gnB4IP6GXltUu0geolEP
         DXgfr/dIyCxh76FWRej3tkP6QLI58qqYiCGhpGHxzCPO8C1X1JsttZv0Et9R+/5p/0n6
         2G5A==
X-Gm-Message-State: AFqh2kqwnXHhGv7RJAILNnFtkVkFpGS6ojqyeNPvweb7DckALt/l8MRY
        5w/QorybBrV9g1aOl+11HhyvlkV2BoHPhSsK
X-Google-Smtp-Source: AMrXdXuS4zXTytfOZ5xIh4bs+rkmeZmK+QXoBwGpkC3p2EnL8ac6bXz6nz3yQ+yKSuiIei2pYWQMCA==
X-Received: by 2002:a17:902:b10e:b0:191:4367:7fde with SMTP id q14-20020a170902b10e00b0019143677fdemr1360463plr.0.1673650227268;
        Fri, 13 Jan 2023 14:50:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0019460ac7c6asm3819704plg.283.2023.01.13.14.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 14:50:26 -0800 (PST)
Date:   Fri, 13 Jan 2023 22:50:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com, aarcange@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com,
        Quentin Perret <qperret@google.com>, tabba@google.com,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v10 6/9] KVM: Unmap existing mappings when change the
 memory attributes
Message-ID: <Y8HgLq/CqTaEi/ME@google.com>
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <20221202061347.1070246-7-chao.p.peng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202061347.1070246-7-chao.p.peng@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022, Chao Peng wrote:
> @@ -785,11 +786,12 @@ struct kvm {
>  
>  #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>  	struct mmu_notifier mmu_notifier;
> +#endif
>  	unsigned long mmu_invalidate_seq;
>  	long mmu_invalidate_in_progress;
>  	gfn_t mmu_invalidate_range_start;
>  	gfn_t mmu_invalidate_range_end;
> -#endif

Blech.  The existing code is a bit ugly, and trying to extend for this use case
makes things even worse.

Rather than use the base MMU_NOTIFIER Kconfig and an arbitrary define, I think we
should first add a proper Kconfig, e.g. KVM_GENERIC_MMU_NOTIFIER, to replace the
combination.  E.g

	config KVM_GENERIC_MMU_NOTIFIER
	       select MMU_NOTIFIER
	       bool

and then all architectures that currently #define KVM_ARCH_WANT_MMU_NOTIFIER can
simply select the Kconfig, which is everything except s390.  "GENERIC" again because
s390 does select MMU_NOTIFER and actually registers its own notifier for s390's
version of protected VMs (at least, I think that's what its "pv" stands for).

And then later down the line in this series, when the attributes and private mem
needs to tie into the notifiers, we can do:


	config KVM_GENERIC_MEMORY_ATTRIBUTES
	       select KVM_GENERIC_MMU_NOTIFIER
	       bool

I.e. that way this patch doesn't need to partially expose KVM's notifier stuff
and can instead just keep the soon-to-be-existing KVM_GENERIC_MMU_NOTIFIER.

Taking a depending on KVM_GENERIC_MMU_NOTIFIER for KVM_GENERIC_MEMORY_ATTRIBUTES
makes sense, because AFAICT, changing any type of attribute, e.g. RWX bits, is
going to necessitate unmapping the affected gfn range.

>  	struct list_head devices;
>  	u64 manual_dirty_log_protect;
>  	struct dentry *debugfs_dentry;
> @@ -1480,6 +1482,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> +bool kvm_arch_has_private_mem(struct kvm *kvm);

The reference to private memory belongs in a later patch.  More below.

> +static void kvm_unmap_mem_range(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	struct kvm_gfn_range gfn_range;
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	struct kvm_memslot_iter iter;
> +	int i;
> +	int r = 0;

The return from kvm_unmap_gfn_range() is a bool, this should be:

	bool flush = false;

> +
> +	gfn_range.pte = __pte(0);
> +	gfn_range.may_block = true;
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		slots = __kvm_memslots(kvm, i);
> +
> +		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
> +			slot = iter.slot;
> +			gfn_range.start = max(start, slot->base_gfn);
> +			gfn_range.end = min(end, slot->base_gfn + slot->npages);
> +			if (gfn_range.start >= gfn_range.end)
> +				continue;
> +			gfn_range.slot = slot;
> +
> +			r |= kvm_unmap_gfn_range(kvm, &gfn_range);
> +		}
> +	}
> +
> +	if (r)
> +		kvm_flush_remote_tlbs(kvm);
> +}
> +
>  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  					   struct kvm_memory_attributes *attrs)
>  {
>  	gfn_t start, end;
>  	unsigned long i;
>  	void *entry;
> +	int idx;
>  	u64 supported_attrs = kvm_supported_mem_attributes(kvm);
>  
> -	/* flags is currently not used. */
> +	/* 'flags' is currently not used. */

Kind of a spurious change.

>  	if (attrs->flags)
>  		return -EINVAL;
>  	if (attrs->attributes & ~supported_attrs)
> @@ -2372,6 +2409,13 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  
>  	entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
>  
> +	if (kvm_arch_has_private_mem(kvm)) {

I think we should assume that any future attributes will necessitate unmapping
and invalidation, i.e. drop the private mem check.  That allows introducing
kvm_arch_has_private_mem() in a later patch that is more directly related to
private memory.

> +		KVM_MMU_LOCK(kvm);
> +		kvm_mmu_invalidate_begin(kvm);
> +		kvm_mmu_invalidate_range_add(kvm, start, end);
> +		KVM_MMU_UNLOCK(kvm);
> +	}
> +
>  	mutex_lock(&kvm->lock);
>  	for (i = start; i < end; i++)
>  		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> @@ -2379,6 +2423,16 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  			break;
>  	mutex_unlock(&kvm->lock);
>  
> +	if (kvm_arch_has_private_mem(kvm)) {
> +		idx = srcu_read_lock(&kvm->srcu);

Mostly for reference, this goes away if slots_lock is used instead of kvm->lock.

> +		KVM_MMU_LOCK(kvm);
> +		if (i > start)
> +			kvm_unmap_mem_range(kvm, start, i);
> +		kvm_mmu_invalidate_end(kvm);
> +		KVM_MMU_UNLOCK(kvm);
> +		srcu_read_unlock(&kvm->srcu, idx);
> +	}
> +
>  	attrs->address = i << PAGE_SHIFT;
>  	attrs->size = (end - i) << PAGE_SHIFT;
>  
> -- 
> 2.25.1
> 
