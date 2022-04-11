Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214F44FC593
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 22:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiDKUPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 16:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245728AbiDKUPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 16:15:02 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE8A2C679
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 13:12:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id be5so8851822plb.13
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 13:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wLQzPAe6pyjRg5XiF99tjyaUc0WTeJb+T6qbrWIkFcE=;
        b=teoNyc2n+lT+vKWWF2jxuNeY7aDRxPR5rtXU+q3Xz9/jFG/UyVkzNoyfhjL0v6T/6s
         NKILWL8dLo4S/a3Cyh5GoUmQJFvHFaT22JqolFQ/R9aXE0WCkjMKjKFnJPAQtXr2FKCr
         SaAkB9lDGUm85hO6A0CilBbr+m/RRHArTZ0RYPsMeyztw07h/yhoY/2zjYzP4XTuNbov
         Hb41Va996j+uUx/75VOCNdkwL3s22dDpx3u4+A1J13GB0alNEdAzSVMVZEVVGOo+36P9
         vvnT8ulduwaI2VneasObplDiF0D0hr6bu+x7NHpJPBGc/vp8rPDsRIzL44UCah9Zxd6Z
         4Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wLQzPAe6pyjRg5XiF99tjyaUc0WTeJb+T6qbrWIkFcE=;
        b=Wjiv+T3GrurNqyabBjauXelRZv/JinIjmL1GlPqnsKaW4rl021OkuZPMkegXJFsKoR
         CykrUaeym2vUY+0B7k2ZaxyEb3XCYrJnhsrJnLLLTQ9xhmEzQmniDAw2AKJCIp8Y1S/x
         ZyQUZzUxwyEu2EEdw0d7GGG5nQC1LjLrbKgO/0IoK1IgARoA5lr6YZVjW10GbTkiFil5
         byzmHRmHis0tzugtCN2iM2prNdbgVXiYXqQ2TBMusM6t22hQfu0ndnO65COnGkan1DFS
         gliTJXkIZkzufGA3iPKTASUjg3RFkccZMDju6/ZlTxfX6JrWK78bqL0sFAl27DVxJQeq
         18Rg==
X-Gm-Message-State: AOAM533CI41mm/8qA4tyHyYtMQ8e1ZyDLWijbJwtzj8nFFglobSSsgLa
        J6Pg17lCVTQerPm6dS/sNVAGBQ==
X-Google-Smtp-Source: ABdhPJyMwroHdQl0yrQRu74auN6bH8pc+j1ezfBTcqbjfSeirt4m78ErqrMT+UGt7bh8fX/aSvc+sQ==
X-Received: by 2002:a17:902:ef46:b0:153:81f7:7fc2 with SMTP id e6-20020a170902ef4600b0015381f77fc2mr34277650plx.26.1649707966168;
        Mon, 11 Apr 2022 13:12:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t69-20020a637848000000b0039831d6dc23sm495967pgc.94.2022.04.11.13.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 13:12:45 -0700 (PDT)
Date:   Mon, 11 Apr 2022 20:12:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlSLuZphElMyF2sG@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
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

On Mon, Apr 11, 2022, David Matlack wrote:
> On Mon, Apr 11, 2022 at 10:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > Circling back to eager page splitting, this series could be reworked to take the
> > first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
> > order to provide the necessary path for reworking nested MMU page faults.  Then it
> > can remove unsync and shrinker support for nested MMUs.  With those gone,
> > dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
> > than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
> > some of the complexity/churn.
> 
> These sound like useful improvements but I am not really seeing the
> value of sequencing them before this series:
> 
>  - IMO the "churn" in patches 1-14 are a net improvement to the
> existing code. They improve readability by decomposing the shadow page
> creation path into smaller functions with better names, reduce the
> amount of redundant calculations, and reduce the dependence on struct
> kvm_vcpu where it is not needed. Even if eager page splitting is
> completely dropped I think they would be useful to merge.

I definitely like some of patches 1-14, probably most after a few read throughs.
But there are key parts that I do not like that are motivated almost entirely by
the desire to support page splitting.  Specifically, I don't like splitting the
logic of finding a page, and I don't like having a separate alloc vs. initializer
(though I'm guessing this will be needed somewhere to split huge pages for nested
MMUs).

E.g. I'd prefer the "get" flow look like the below (completely untested, for
discussion purposes only).  There's still churn, but the core loop is almost
entirely unchanged.

And it's not just this series, I don't want future improvements nested TDP to have
to deal with the legacy baggage.

Waaaay off topic, why do we still bother with stat.max_mmu_page_hash_collision?
I assume it was originally added to tune the hashing logic?  At this point is it
anything but wasted cycles?

static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
						     gfn_t gfn,
						     unsigned int gfn_hash,
						     union kvm_mmu_page_role role)
{
	struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];
	struct kvm_mmu_page *sp;
	LIST_HEAD(invalid_list);

	int collisions = 0;

	for_each_valid_sp(kvm, sp, sp_list) {
		if (sp->gfn != gfn) {
			collisions++;
			continue;
		}

		if (sp->role.word != role.word) {
			/*
			 * If the guest is creating an upper-level page, zap
			 * unsync pages for the same gfn.  While it's possible
			 * the guest is using recursive page tables, in all
			 * likelihood the guest has stopped using the unsync
			 * page and is installing a completely unrelated page.
			 * Unsync pages must not be left as is, because the new
			 * upper-level page will be write-protected.
			 */
			if (role.level > PG_LEVEL_4K && sp->unsync)
				kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);

			continue;
		}

		/* unsync and write-flooding only apply to indirect SPs. */
		if (sp->role.direct)
			goto out;

		if (sp->unsync) {
			/*
			 * The page is good, but is stale.  kvm_sync_page does
			 * get the latest guest state, but (unlike mmu_unsync_children)
			 * it doesn't write-protect the page or mark it synchronized!
			 * This way the validity of the mapping is ensured, but the
			 * overhead of write protection is not incurred until the
			 * guest invalidates the TLB mapping.  This allows multiple
			 * SPs for a single gfn to be unsync.
			 *
			 * If the sync fails, the page is zapped.  If so, break
			 * in order to rebuild it.
			 */
			if (!kvm_sync_page(vcpu, sp, &invalid_list))
				break;

			WARN_ON(!list_empty(&invalid_list));
			kvm_flush_remote_tlbs(vcpu->kvm);
		}

		__clear_sp_write_flooding_count(sp);
		goto out;
	}

	sp = NULL;

out:
	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
		kvm->stat.max_mmu_page_hash_collisions = collisions;

	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
	return sp;
}

static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
						      gfn_t gfn,
						      unsigned int gfn_hash,
						      union kvm_mmu_page_role role)
{
	struct kvm_mmu_page *sp = __kvm_mmu_alloc_shadow_page(vcpu, role.direct);
	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
	struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];

	++kvm->stat.mmu_cache_miss;

	sp->gfn = gfn;
	sp->role = role;
	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;

	/*
	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
	 * depends on valid pages being added to the head of the list.  See
	 * comments in kvm_zap_obsolete_pages().
	 */
	list_add(&sp->link, &kvm->arch.active_mmu_pages);
	kvm_mod_used_mmu_pages(kvm, 1);

	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
	hlist_add_head(&sp->hash_link, sp_list);

	if (!role.direct)
		account_shadowed(kvm, slot, sp);
}


static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
						    gfn_t gfn,
						    union kvm_mmu_page_role role)
{
	unsigned int gfn_hash = kvm_page_table_hashfn(gfn);
	struct kvm_mmu_page *sp;
	bool created = false;

	sp = kvm_mmu_find_shadow_page(vcpu, gfn, gfn_hash, role);
	if (!sp) {
		created = true;
		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, gfn_hash, role);
	}

	trace_kvm_mmu_get_page(sp, created);
	return sp;
}
