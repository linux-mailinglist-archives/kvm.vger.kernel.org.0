Return-Path: <kvm+bounces-14659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7388A51CA
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E9A51C228F2
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A5783CA3;
	Mon, 15 Apr 2024 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wiJLBwJz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cJi8icg5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wiJLBwJz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cJi8icg5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7264E7691F
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713188198; cv=none; b=RBVsavJga3qXeyJibLsMr+XAJP2Z1VHQw54Ycxgt4KJ702eVPzwn5g3WUFL1dBtAl7S7250vYfu8UrzON70V9uOV/y1pUbY4sk4x2UXuAGbiR470v7xs0GhEXJ2+pOWEC9RFj6U3JvJxpuFpwMHfbtFjkXVA0+bVU8DmLwwUJPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713188198; c=relaxed/simple;
	bh=NX8yHODCOi86UhZ0dtxXRNCn0w6ixCBrGT+e5+vXb8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IdrJnnQ0vKFoXA5cCT0DEs6ryj5ib8lmJXTzDRO/yZQiKpc5NOahxzfObT1JUFhwqyMNcObMiwwA51v0Qe7OOj8veHIeypdxB6WEE76yg2+wi4QzwWhKA4g3yVpko+3pLqS4L6kiyqZtCarUwakioX4RwSItQi4Z5ErkmZYrHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wiJLBwJz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cJi8icg5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wiJLBwJz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cJi8icg5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 30A5E37189;
	Mon, 15 Apr 2024 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1713188190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zQqbIB5kjeKVPKDHQZhZmwx8PhIheitUD54ORClWXGY=;
	b=wiJLBwJz8Q1zCCnc6mkCTS/fbPX0ON711dPqBd1/MWmHnHKn5k5W1Ty/0+3CXBe1MmHz4Z
	GC22rogQD14awW27tkl38hkGpO1wAdka2+VK5+4uFW9mAxp4TSUjhLRQSqZtpdzdRuDIgH
	DH+/EFUAIxkktaSY1z+6Lr3g1R/GN60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1713188190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zQqbIB5kjeKVPKDHQZhZmwx8PhIheitUD54ORClWXGY=;
	b=cJi8icg5W8/+PXRs+AfcCoB/dlgWP6RdVKonQnvDjSnAdMPbwfR9yTYLxi/JndbLmQcdeM
	KD5ZVf8kFZlQhYAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1713188190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zQqbIB5kjeKVPKDHQZhZmwx8PhIheitUD54ORClWXGY=;
	b=wiJLBwJz8Q1zCCnc6mkCTS/fbPX0ON711dPqBd1/MWmHnHKn5k5W1Ty/0+3CXBe1MmHz4Z
	GC22rogQD14awW27tkl38hkGpO1wAdka2+VK5+4uFW9mAxp4TSUjhLRQSqZtpdzdRuDIgH
	DH+/EFUAIxkktaSY1z+6Lr3g1R/GN60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1713188190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zQqbIB5kjeKVPKDHQZhZmwx8PhIheitUD54ORClWXGY=;
	b=cJi8icg5W8/+PXRs+AfcCoB/dlgWP6RdVKonQnvDjSnAdMPbwfR9yTYLxi/JndbLmQcdeM
	KD5ZVf8kFZlQhYAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 190671368B;
	Mon, 15 Apr 2024 13:36:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cT6lBV4tHWZkFgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Apr 2024 13:36:30 +0000
Message-ID: <a97d6ed3-f4f8-4d3e-9306-da93bf7c6b26@suse.cz>
Date: Mon, 15 Apr 2024 15:36:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH gmem 6/6] KVM: guest_memfd: Add interface for populating
 gmem pages with user data
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
 <20240329212444.395559-7-michael.roth@amd.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240329212444.395559-7-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.986];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email]

On 3/29/24 10:24 PM, Michael Roth wrote:
> During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
> prepare newly-allocated gmem pages prior to mapping them into the guest.
> In the case of SEV-SNP, this mainly involves setting the pages to
> private in the RMP table.
> 
> However, for the GPA ranges comprising the initial guest payload, which
> are encrypted/measured prior to starting the guest, the gmem pages need
> to be accessed prior to setting them to private in the RMP table so they
> can be initialized with the userspace-provided data. Additionally, an
> SNP firmware call is needed afterward to encrypt them in-place and
> measure the contents into the guest's launch digest.
> 
> While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
> this handling can be done in an open-coded/vendor-specific manner, this
> may expose more gmem-internal state/dependencies to external callers
> than necessary. Try to avoid this by implementing an interface that
> tries to handle as much of the common functionality inside gmem as
> possible, while also making it generic enough to potentially be
> usable/extensible for use-cases beyond just SEV-SNP.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  include/linux/kvm_host.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/guest_memfd.c   | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5b8308b5e4af..8a75787090f3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2473,4 +2473,44 @@ bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
>  void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  #endif
>  
> +/**
> + * kvm_gmem_populate_args - kvm_gmem_populate() argument structure
> + *
> + * @gfn: starting GFN to be populated
> + * @src: userspace-provided buffer containing data to copy into GFN range
> + * @npages: number of pages to copy from userspace-buffer
> + * @do_memcpy: whether to do a direct memcpy of the data prior to issuing
> + *             the post-populate callback
> + * @post_populate: callback to issue for each gmem page that backs the GPA
> + *                 range (which will be filled with corresponding contents from
> + *                 @src if @do_memcpy was set)
> + * @opaque: opaque data to pass to @post_populate callback
> + */
> +struct kvm_gmem_populate_args {
> +	gfn_t gfn;
> +	void __user *src;
> +	int npages;
> +	bool do_memcpy;
> +	int (*post_populate)(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			     gfn_t gfn, kvm_pfn_t pfn, void __user *src, int order,
> +			     void *opaque);
> +	void *opaque;
> +};
> +
> +/**
> + * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
> + *
> + * @kvm: KVM instance
> + * @slot: slot containing the GPA range being prepared
> + * @args: argument structure
> + *
> + * This is primarily intended for cases where a gmem-backed GPA range needs
> + * to be initialized with userspace-provided data prior to being mapped into
> + * the guest as a private page. This should be called with the slots->lock
> + * held so that caller-enforced invariants regarding the expected memory
> + * attributes of the GPA range do not race with KVM_SET_MEMORY_ATTRIBUTES.
> + */
> +int kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> +		      struct kvm_gmem_populate_args *args);
> +
>  #endif
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3668a5f1d82b..3e3c4b7fff3b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -643,3 +643,43 @@ int kvm_gmem_undo_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return r;
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_undo_get_pfn);
> +
> +int kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> +		      struct kvm_gmem_populate_args *args)
> +{
> +	int ret, max_order, i;
> +
> +	for (i = 0; i < args->npages; i += (1 << max_order)) {
> +		void __user *src = args->src + i * PAGE_SIZE;
> +		gfn_t gfn = args->gfn + i;
> +		kvm_pfn_t pfn;
> +
> +		ret = __kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &max_order, false);
> +		if (ret)
> +			break;
> +
> +		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
> +		    (args->npages - i) < (1 << max_order))
> +			max_order = 0;
> +
> +		if (args->do_memcpy && args->src) {
> +			ret = copy_from_user(pfn_to_kaddr(pfn), src, (1 << max_order) * PAGE_SIZE);
> +			if (ret)
> +				goto e_release;> +		}
> +
> +		if (args->post_populate) {
> +			ret = args->post_populate(kvm, slot, gfn, pfn, src, max_order,
> +						  args->opaque);
> +			if (ret)
> +				goto e_release;

This if (ret) goto seems unnecessary, was there more code before the label
in a previous version?

With that we could also change this block to "if (!ret &&
args->post_populate)" and remove the first goto and the label.

> +		}
> +e_release:
> +		put_page(pfn_to_page(pfn));
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_populate);


