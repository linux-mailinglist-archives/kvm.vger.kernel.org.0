Return-Path: <kvm+bounces-10887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F37871881
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4BA1C2107C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAE94E1D9;
	Tue,  5 Mar 2024 08:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="exzf0ZN0"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111C95102F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 08:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709628420; cv=none; b=nJ3p0Pf4P5swRsOTJUm3rlqo4oJI+B+B+rqN7elhRNMp3jp0uERG08xU4PlEuuK2SLenUm6gV1zo18bvJdHDJMXnwS/TrjlfbEpPirVrW4xt8iDofT9g3AUClrRzFyeagGn7pltzT7OGqhwoNcN7hJfw43nOI3oADf1qppwUckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709628420; c=relaxed/simple;
	bh=ypBAMq1xD122eQYCVVu/e4bhCUfHMyxBwy6PiUei7ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rG6/Km9paO4PA8dzeGnorMynyYf/eSOaQSWR/GXjF92iSGy+d9iyTvbZnRH+qBR1Ih3z5p7DCYkKklKHbBkpEJFoV9v2f1qVAzOc331YkZfG+Re0N5gyMzHfyhK4QaJZvP5G6GMAr06Tz28MJQE+l919c1+/7msOI59vTXktnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=exzf0ZN0; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 5 Mar 2024 08:46:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709628415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XFrbfdZsWF6FXVs3YMWczDqjRAtMwJZL7VFOKOOlg+8=;
	b=exzf0ZN0e5j8rMXz84wObFPRDcs6l2hsX6ODjXb4yQ9XbrZ5cOhDSPVnhoEilxaX/AXwaG
	JuKcJjNVUN2eFnRsS3Vdg+kvZKp8irQlGJQSsKMKZ971NA5s7tOzMQ1dEcqFM7GC1gBe9M
	rYwzzXADn1SJ13vRZk4LoTRzQpZZNfE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, darren@os.amperecomputing.com,
	d.scott.phillips@amperecomputing.com,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Message-ID: <Zebb9CyihqC4JqnK@linux.dev>
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
X-Migadu-Flow: FLOW_OUT

-cc old kvmarm list
+cc new kvmarm list, reviewers

Please run scripts/get_maintainer.pl next time around so we get the
right people looking at a patch.

On Mon, Mar 04, 2024 at 09:46:06PM -0800, Ganapatrao Kulkarni wrote:
> @@ -216,6 +223,13 @@ struct kvm_s2_mmu {
>  	 * >0: Somebody is actively using this.
>  	 */
>  	atomic_t refcnt;
> +
> +	/*
> +	 * For a Canonical IPA to Shadow IPA mapping.
> +	 */
> +	struct rb_root nested_mapipa_root;

There isn't any benefit to tracking the canonical IPA -> shadow IPA(s)
mapping on a per-S2 basis, as there already exists a one-to-many problem
(more below). Maintaining a per-VM data structure (since this is keyed
by canonical IPA) makes a bit more sense.

> +	rwlock_t mmu_lock;
> +

Err, is there any reason the existing mmu_lock is insufficient here?
Surely taking a new reference on a canonical IPA for a shadow S2 must be
done behind the MMU lock for it to be safe against MMU notifiers...

Also, Reusing the exact same name for it is sure to produce some lock
imbalance funnies.

>  };
>  
>  static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index da7ebd2f6e24..c31a59a1fdc6 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -65,6 +65,9 @@ extern void kvm_init_nested(struct kvm *kvm);
>  extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>  extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>  extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
> +extern void add_shadow_ipa_map_node(
> +		struct kvm_s2_mmu *mmu,
> +		phys_addr_t ipa, phys_addr_t shadow_ipa, long size);

style nitpick: no newline between the open bracket and first parameter.
Wrap as needed at 80 (or a bit more) columns.

> +/*
> + * Create a node and add to lookup table, when a page is mapped to
> + * Canonical IPA and also mapped to Shadow IPA.
> + */
> +void add_shadow_ipa_map_node(struct kvm_s2_mmu *mmu,
> +			phys_addr_t ipa,
> +			phys_addr_t shadow_ipa, long size)
> +{
> +	struct rb_root *ipa_root = &(mmu->nested_mapipa_root);
> +	struct rb_node **node = &(ipa_root->rb_node), *parent = NULL;
> +	struct mapipa_node *new;
> +
> +	new = kzalloc(sizeof(struct mapipa_node), GFP_KERNEL);
> +	if (!new)
> +		return;

Should be GFP_KERNEL_ACCOUNT, you want to charge this to the user.

> +
> +	new->shadow_ipa = shadow_ipa;
> +	new->ipa = ipa;
> +	new->size = size;

What about aliasing? You could have multiple shadow IPAs that point to
the same canonical IPA, even within a single MMU.

> +	write_lock(&mmu->mmu_lock);
> +
> +	while (*node) {
> +		struct mapipa_node *tmp;
> +
> +		tmp = container_of(*node, struct mapipa_node, node);
> +		parent = *node;
> +		if (new->ipa < tmp->ipa) {
> +			node = &(*node)->rb_left;
> +		} else if (new->ipa > tmp->ipa) {
> +			node = &(*node)->rb_right;
> +		} else {
> +			write_unlock(&mmu->mmu_lock);
> +			kfree(new);
> +			return;
> +		}
> +	}
> +
> +	rb_link_node(&new->node, parent, node);
> +	rb_insert_color(&new->node, ipa_root);
> +	write_unlock(&mmu->mmu_lock);

Meh, one of the annoying things with rbtree is you have to build your
own search functions...

It would appear that the rbtree intends to express intervals (i.e. GPA +
size), but the search implementation treats GPA as an index. So I don't
think this works as intended.

Have you considered other abstract data types (e.g. xarray, maple tree)
and how they might apply here?

> +bool get_shadow_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa, phys_addr_t *shadow_ipa, long *size)
> +{
> +	struct rb_node *node;
> +	struct mapipa_node *tmp = NULL;
> +
> +	read_lock(&mmu->mmu_lock);
> +	node = mmu->nested_mapipa_root.rb_node;
> +
> +	while (node) {
> +		tmp = container_of(node, struct mapipa_node, node);
> +
> +		if (tmp->ipa == ipa)
> +			break;
> +		else if (ipa > tmp->ipa)
> +			node = node->rb_right;
> +		else
> +			node = node->rb_left;
> +	}
> +
> +	read_unlock(&mmu->mmu_lock);
> +
> +	if (tmp && tmp->ipa == ipa) {
> +		*shadow_ipa = tmp->shadow_ipa;
> +		*size = tmp->size;
> +		write_lock(&mmu->mmu_lock);
> +		rb_erase(&tmp->node, &mmu->nested_mapipa_root);
> +		write_unlock(&mmu->mmu_lock);
> +		kfree(tmp);
> +		return true;
> +	}

Implicitly evicting the entry isn't going to work if we want to use it
for updates to a stage-2 that do not evict the mapping, like write
protection or access flag updates.

-- 
Thanks,
Oliver

