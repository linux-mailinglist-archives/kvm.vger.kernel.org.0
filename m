Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B388F6E73A7
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 09:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjDSHIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 03:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjDSHIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 03:08:18 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA4BC7;
        Wed, 19 Apr 2023 00:08:16 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2a7a54303afso3191051fa.1;
        Wed, 19 Apr 2023 00:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681888095; x=1684480095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFdV/aZNB5s27u9laUjFRCNUzAEvMQJQhcf4tydPiWI=;
        b=XJnh5CXFx1jKI0FEpWnbjVkPGkkjBbhMfsnpE/eXSTPUL8ZrCZ4T1yh6OY9oUx67Fh
         sgDhX5SZwxSKb0O2tckhDEtQ0h7wpV/66yYPUu6G3syHNj1ZUqptDFJ+U4WiQPxe1VSn
         eP2H8jmE+bjsCc+AtDqcoCyMxLnzpvZSHSUT3tUpFUrvht/7fLS1fOsIGIpPXtezblBe
         zmcdjvghji+mplFxcmq8+DOqYpi1YtHE2nFgYrjaQJNDmpKpOwnZU9PiIPaivI4S4vwF
         pG1e5RADcg/aELOlUEjQyfxNQ8GGgtPXUNIOx/dXKwCGqJcYc1wNxPaO0uW0a2eZR4Sl
         kXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681888095; x=1684480095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFdV/aZNB5s27u9laUjFRCNUzAEvMQJQhcf4tydPiWI=;
        b=WFLmKufmP58yeiTK54oUHbRAZj0sddi1NUhfAtciGTnqhAi7jZ47y8WEc5+5Tfy3DZ
         H3elHhF8Wxl1IAYWsmeEVcX+BU/ZACQE/RwDImcYCyU2kUvkilzMVTE4IrpX72Ou0egE
         cIaXMZ8WDp8ouR18hdugI50GIjzGiuq773yO8el3oRDS2R6IdVZijaImi0Gwu0GPnUIs
         GtoFADLcfzjkG/IFi6WsnAtkEScR2jPWHS1UZhI2GRI7DU1KPQQ1xUwvkeN2X49fO/On
         xksEheu7yrrOmnSrRzL2379oZsPDiQgUxZQrQVdQgSlWR4EuApngOUY0c0rYogWnZPlk
         CdhQ==
X-Gm-Message-State: AAQBX9fx8aDu+aqNZqrqFZpvDVxdQiS66QLbajifkhBM6y1MstYJciaI
        JfkGmTJDI53a+xKcyP23p5I=
X-Google-Smtp-Source: AKy350aAMti/yPJ0I+V+gY4/IGWnHjXQBLY9YwVa62ihlEO/e9THIsbUhHdrLAmmhA7DlH+bG0f0Pg==
X-Received: by 2002:ac2:443a:0:b0:4db:1e4a:749c with SMTP id w26-20020ac2443a000000b004db1e4a749cmr3778431lfl.0.1681888094805;
        Wed, 19 Apr 2023 00:08:14 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id p16-20020a05651211f000b004d8546456c6sm2595758lfs.195.2023.04.19.00.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 00:08:14 -0700 (PDT)
Date:   Wed, 19 Apr 2023 10:08:01 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH 5/5] KVM: TDX: Add core logic for TDX intra-host
 migration
Message-ID: <20230419100801.00007d20.zhi.wang.linux@gmail.com>
In-Reply-To: <20230407201921.2703758-6-sagis@google.com>
References: <20230407201921.2703758-1-sagis@google.com>
        <20230407201921.2703758-6-sagis@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Apr 2023 20:19:21 +0000
Sagi Shahar <sagis@google.com> wrote:

> Adds the core logic for transferring state between source and
> destination TDs during intra-host migration.
> 
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 191 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 190 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 0999a6d827c99..05b164a91437b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2834,9 +2834,198 @@ static __always_inline bool tdx_guest(struct kvm *kvm)
>  	return tdx_kvm->finalized;
>  }
>  
> +#define for_each_memslot_pair(memslots_1, memslots_2, memslot_iter_1, \
> +			      memslot_iter_2)                         \
> +	for (memslot_iter_1 = rb_first(&memslots_1->gfn_tree),        \
> +	    memslot_iter_2 = rb_first(&memslots_2->gfn_tree);         \
> +	     memslot_iter_1 && memslot_iter_2;                        \
> +	     memslot_iter_1 = rb_next(memslot_iter_1),                \
> +	    memslot_iter_2 = rb_next(memslot_iter_2))
> +

If it is a pair, using suffix *_a, *_b would be better.

>  static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
>  {
> -	return -EINVAL;
> +	struct rb_node *src_memslot_iter, *dst_memslot_iter;
> +	struct vcpu_tdx *dst_tdx_vcpu, *src_tdx_vcpu;
> +	struct kvm_memslots *src_slots, *dst_slots;
> +	struct kvm_vcpu *dst_vcpu, *src_vcpu;
> +	struct kvm_tdx *src_tdx, *dst_tdx;
> +	unsigned long i, j;
> +	int ret;
> +
> +	src_tdx = to_kvm_tdx(src);
> +	dst_tdx = to_kvm_tdx(dst);
> +
> +	src_slots = __kvm_memslots(src, 0);
> +	dst_slots = __kvm_memslots(dst, 0);
> +
> +	ret = -EINVAL;
> +
> +	if (!src_tdx->finalized) {
> +		pr_warn("Cannot migrate from a non finalized VM\n");
> +		goto abort;
> +	}
> +

Let's use the existing inline function is_td_finalized().

> +	// Traverse both memslots in gfn order and compare them
> +	for_each_memslot_pair(src_slots, dst_slots, src_memslot_iter, dst_memslot_iter) {
> +		struct kvm_memory_slot *src_slot, *dst_slot;
> +
> +		src_slot =
> +			container_of(src_memslot_iter, struct kvm_memory_slot,
> +				     gfn_node[src_slots->node_idx]);
> +		dst_slot =
> +			container_of(src_memslot_iter, struct kvm_memory_slot,
> +				     gfn_node[dst_slots->node_idx]);
> +
                                       ^dst_memslot_iter? So does the other one below.
> +		if (src_slot->base_gfn != dst_slot->base_gfn ||
> +		    src_slot->npages != dst_slot->npages) {
> +			pr_warn("Cannot migrate between VMs with different memory slots configurations\n");
> +			goto abort;
> +		}
> +
> +		if (src_slot->flags != dst_slot->flags) {
> +			pr_warn("Cannot migrate between VMs with different memory slots configurations\n");
> +			goto abort;
> +		}
> +
> +		if (src_slot->flags & KVM_MEM_PRIVATE) {
> +			if (src_slot->restrictedmem.file->f_inode->i_ino !=
> +			    dst_slot->restrictedmem.file->f_inode->i_ino) {
> +				pr_warn("Private memslots points to different restricted files\n");
> +				goto abort;
> +			}
> +
> +			if (src_slot->restrictedmem.index != dst_slot->restrictedmem.index) {
> +				pr_warn("Private memslots points to the restricted file at different offsets\n");
> +				goto abort;
> +			}
> +		}
> +	}
> +
> +	if (src_memslot_iter || dst_memslot_iter) {
> +		pr_warn("Cannot migrate between VMs with different memory slots configurations\n");
> +		goto abort;
> +	}
> +
> +	dst_tdx->hkid = src_tdx->hkid;
> +	dst_tdx->tdr_pa = src_tdx->tdr_pa;
> +
> +	dst_tdx->tdcs_pa = kcalloc(tdx_info.nr_tdcs_pages, sizeof(*dst_tdx->tdcs_pa),
> +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!dst_tdx->tdcs_pa) {
> +		ret = -ENOMEM;
> +		goto late_abort;
> +	}
> +	memcpy(dst_tdx->tdcs_pa, src_tdx->tdcs_pa,
> +	       tdx_info.nr_tdcs_pages * sizeof(*dst_tdx->tdcs_pa));
> +
> +	dst_tdx->tsc_offset = src_tdx->tsc_offset;
> +	dst_tdx->attributes = src_tdx->attributes;
> +	dst_tdx->xfam = src_tdx->xfam;
> +	dst_tdx->kvm.arch.gfn_shared_mask = src_tdx->kvm.arch.gfn_shared_mask;
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src)
> +		tdx_flush_vp_on_cpu(src_vcpu);
> +
> +	/* Copy per-vCPU state */
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		src_tdx_vcpu = to_tdx(src_vcpu);
> +		dst_vcpu = kvm_get_vcpu(dst, i);
> +		dst_tdx_vcpu = to_tdx(dst_vcpu);
> +
> +		vcpu_load(dst_vcpu);
> +
> +		memcpy(dst_vcpu->arch.regs, src_vcpu->arch.regs,
> +		       NR_VCPU_REGS * sizeof(src_vcpu->arch.regs[0]));
> +		dst_vcpu->arch.regs_avail = src_vcpu->arch.regs_avail;
> +		dst_vcpu->arch.regs_dirty = src_vcpu->arch.regs_dirty;
> +
> +		dst_vcpu->arch.tsc_offset = dst_tdx->tsc_offset;
> +
> +		dst_tdx_vcpu->interrupt_disabled_hlt = src_tdx_vcpu->interrupt_disabled_hlt;
> +		dst_tdx_vcpu->buggy_hlt_workaround = src_tdx_vcpu->buggy_hlt_workaround;
> +
> +		dst_tdx_vcpu->tdvpr_pa = src_tdx_vcpu->tdvpr_pa;
> +		dst_tdx_vcpu->tdvpx_pa = kcalloc(tdx_info.nr_tdvpx_pages,
> +						 sizeof(*dst_tdx_vcpu->tdvpx_pa),
> +						 GFP_KERNEL_ACCOUNT);
> +		if (!dst_tdx_vcpu->tdvpx_pa) {
> +			ret = -ENOMEM;
> +			vcpu_put(dst_vcpu);
> +			goto late_abort;
> +		}
> +		memcpy(dst_tdx_vcpu->tdvpx_pa, src_tdx_vcpu->tdvpx_pa,
> +		       tdx_info.nr_tdvpx_pages * sizeof(*dst_tdx_vcpu->tdvpx_pa));
> +
> +		td_vmcs_write64(dst_tdx_vcpu, POSTED_INTR_DESC_ADDR, __pa(&dst_tdx_vcpu->pi_desc));
> +
> +		/* Copy private EPT tables */
> +		if (kvm_mmu_move_private_pages_from(dst_vcpu, src_vcpu)) {
> +			ret = -EINVAL;
> +			vcpu_put(dst_vcpu);
> +			goto late_abort;
> +		}
> +
> +		for (j = 0; j < tdx_info.nr_tdvpx_pages; j++)
> +			src_tdx_vcpu->tdvpx_pa[j] = 0;
> +
> +		src_tdx_vcpu->tdvpr_pa = 0;
> +
> +		vcpu_put(dst_vcpu);
> +	}
> +
> +	for_each_memslot_pair(src_slots, dst_slots, src_memslot_iter,
> +			      dst_memslot_iter) {
> +		struct kvm_memory_slot *src_slot, *dst_slot;
> +
> +		src_slot = container_of(src_memslot_iter,
> +					struct kvm_memory_slot,
> +					gfn_node[src_slots->node_idx]);
> +		dst_slot = container_of(src_memslot_iter,
> +					struct kvm_memory_slot,
> +					gfn_node[dst_slots->node_idx]);
> +
> +		for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
> +			unsigned long ugfn;
> +			int level = i + 1;
> +
> +			/*
> +			 * If the gfn and userspace address are not aligned wrt each other, then
> +			 * large page support should already be disabled at this level.
> +			 */
> +			ugfn = dst_slot->userspace_addr >> PAGE_SHIFT;
> +			if ((dst_slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1))
> +				continue;
> +
> +			dst_slot->arch.lpage_info[i - 1] =
> +				src_slot->arch.lpage_info[i - 1];
> +			src_slot->arch.lpage_info[i - 1] = NULL;
> +		}
> +	}
> +
> +	dst->mem_attr_array.xa_head = src->mem_attr_array.xa_head;
> +	src->mem_attr_array.xa_head = NULL;
> +
> +	dst_tdx->finalized = true;
> +
> +	/* Clear source VM to avoid freeing the hkid and pages on VM put */
> +	src_tdx->hkid = -1;
> +	src_tdx->tdr_pa = 0;
> +	for (i = 0; i < tdx_info.nr_tdcs_pages; i++)
> +		src_tdx->tdcs_pa[i] = 0;
> +
> +	return 0;
> +
> +late_abort:
> +	/* If we aborted after the state transfer already started, the src VM
> +	 * is no longer valid.
> +	 */
> +	kvm_vm_dead(src);
> +
> +abort:
> +	dst_tdx->hkid = -1;
> +	dst_tdx->tdr_pa = 0;
> +
> +	return ret;
>  }
>
This function is quite long. It would be better to split some parts into
separate functions.
>  int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)

