Return-Path: <kvm+bounces-61154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1301CC0D0E9
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 12:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9817519A1434
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85652FBDE0;
	Mon, 27 Oct 2025 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v2oCpbx6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="om4M0Q92";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v2oCpbx6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="om4M0Q92"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5137D2FB09E
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 11:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761563168; cv=none; b=OH+ACEBAmwkW8cx/UpOLf8Hg4hqtoDrobTwZ5i5Zgpo84UWQq2dWT507bQqWXM0UxWkWx7x6Ssbdko6y4sGnIxDsGPSwxVD4uMCbBEjgH+G1CSaG8ZIF73f8cJhLULdErudbjP2aa+E8bFXzungrsGZ3Mot5kB1S2zA+wgl+RVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761563168; c=relaxed/simple;
	bh=HmMy1j55bicBe2rImreC/B7Xz0ZjVkwKVIYH0S0Q7ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BP1/qwbwOPtCFgtzk85GfMuziwxAqTFFVLVosvfammly40LnWciysqzXv3oeMRS312uHx9J/tFYUhhQ1/iq0pK4palX5kbu1U1g9akp6EAxGQ+XmrW9mEshYWT+T4+HXPY0Kog3YQMvkKaeo3ax2Zvxtj1srEQrcmsx8+Sii9Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v2oCpbx6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=om4M0Q92; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v2oCpbx6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=om4M0Q92; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48D59219F2;
	Mon, 27 Oct 2025 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761563162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9DJLMlvHCLwsZUrC2mOIMooIT90ctMEYLWPEuoznNh8=;
	b=v2oCpbx6JIAephImZiiNSMJV8HKboO7M60wIkqKzD0s5VQwgfUeYtcu1K/KnnErup9vwKl
	kY2Q30yW/eIpLWsJ8EKdmF9Ps67BrnBYrU8iMfzLREJYcjrLyPKrNhlkWDdvWPzEVyk6BO
	5FLAfI4Qn7yF91LNhx7kYMb9sRB1ZLc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761563162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9DJLMlvHCLwsZUrC2mOIMooIT90ctMEYLWPEuoznNh8=;
	b=om4M0Q92zRxEJdUyiXusjwa7kEbrmY7e4AKYwwFESyiDAhEMLoqnFrRgobXi7RNEFpUZme
	/rQmOvbw7HdCG1Ag==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v2oCpbx6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=om4M0Q92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761563162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9DJLMlvHCLwsZUrC2mOIMooIT90ctMEYLWPEuoznNh8=;
	b=v2oCpbx6JIAephImZiiNSMJV8HKboO7M60wIkqKzD0s5VQwgfUeYtcu1K/KnnErup9vwKl
	kY2Q30yW/eIpLWsJ8EKdmF9Ps67BrnBYrU8iMfzLREJYcjrLyPKrNhlkWDdvWPzEVyk6BO
	5FLAfI4Qn7yF91LNhx7kYMb9sRB1ZLc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761563162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9DJLMlvHCLwsZUrC2mOIMooIT90ctMEYLWPEuoznNh8=;
	b=om4M0Q92zRxEJdUyiXusjwa7kEbrmY7e4AKYwwFESyiDAhEMLoqnFrRgobXi7RNEFpUZme
	/rQmOvbw7HdCG1Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BE2F136CF;
	Mon, 27 Oct 2025 11:06:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QmBgChpS/2gAQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 11:06:02 +0000
Message-ID: <343bc9ae-17d7-4466-8788-adc68acccca4@suse.cz>
Date: Mon, 27 Oct 2025 12:06:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/12] KVM: guest_memfd: Add slab-allocated inode
 cache
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-5-seanjc@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251016172853.52451-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 48D59219F2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/16/25 19:28, Sean Christopherson wrote:
> From: Shivank Garg <shivankg@amd.com>
> 
> Add a dedicated gmem_inode structure and a slab-allocated inode cache for
> guest memory backing, similar to how shmem handles inodes.
> 
> This adds the necessary allocation/destruction functions and prepares
> for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
> structure will also allow for additional cleanups, e.g. to track flags in
> gmem_inode instead of i_private.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Tested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Some nits below, not critical unless there's resubmit for other reasons:

> @@ -860,13 +917,31 @@ static int kvm_gmem_init_mount(void)
>  
>  int kvm_gmem_init(struct module *module)
>  {
> +	struct kmem_cache_args args = {
> +		.align = 0,

This seems unnecessary as it's implicit.

> +		.ctor = kvm_gmem_init_inode_once,
> +	};
> +	int ret;
> +
>  	kvm_gmem_fops.owner = module;
> +	kvm_gmem_inode_cachep = kmem_cache_create("kvm_gmem_inode_cache",
> +						  sizeof(struct gmem_inode),
> +						  &args, SLAB_ACCOUNT);
> +	if (!kvm_gmem_inode_cachep)
> +		return -ENOMEM;
>  
> -	return kvm_gmem_init_mount();
> +	ret = kvm_gmem_init_mount();
> +	if (ret) {
> +		kmem_cache_destroy(kvm_gmem_inode_cachep);
> +		return ret;
> +	}
> +	return 0;
>  }
>  
>  void kvm_gmem_exit(void)
>  {
>  	kern_unmount(kvm_gmem_mnt);
>  	kvm_gmem_mnt = NULL;
> +	rcu_barrier();

Is it because VFS can do call_rcu() with something that ends up with
kvm_gmem_free_inode()? Because nothing in this patch does that directly,
maybe worth a comment?

> +	kmem_cache_destroy(kvm_gmem_inode_cachep);
>  }


