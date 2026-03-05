Return-Path: <kvm+bounces-72777-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AzVOibjqGnzyAAAu9opvQ
	(envelope-from <kvm+bounces-72777-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:57:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 934A920A0FA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AA0973014629
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E6C248896;
	Thu,  5 Mar 2026 01:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oJ3V+Q3f"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5516218EB1
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772675874; cv=none; b=gb8lY0hsHnoPkJIfv09vjCMhW1fENCekdCDtoPeLlUrTPPIVlQbVbQR0d2fDGEeM79DmXwddQJRkQyQ2V7dtuKE5nThXQcGYtTvOHMF3NKiLIgb9+tgiQnEhO7ZNBKVU8t7u7JTVvXhycqf6GJnGicLAnrkEAumgEhRAF0qUmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772675874; c=relaxed/simple;
	bh=rqNLfrl6uIKp7fTnPr0b50B06vxw6llmzHFDnZDBymU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqh0HRq5BcE6MudvyLs8yKIfInbrzhL4dPrDvpjLl34VWGqsSLWIWnzQw33uHNctR3qKj3wUisp+WzQmr4h+Zdw1xvIpl2oS3NlFMi0baimZJ16rhGOT8VEH+bUD5aPRHYZhHCLp9bwM8EpDguO/7Dq63kSKVDEklIfj3i52jaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oJ3V+Q3f; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772675863; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=29Bd77wZ7ySfXMFtzHtrifcW2gocYnKQEBKeYTFG2zI=;
	b=oJ3V+Q3fZlCf0Hr7UKk6f3TJ5ciOup4pmNG72wfKwouZbQ5cw3HAKu4dt/OH1mIk54b4pjb8hM5tmrPyQZa7u4dTOGhvTpQFClHDZjwddd98mMkTPuuUuHF0PIwAq4d6NeYimvLAjxjoXxlU0f5wtFDLFNir7oNt6PM2uBkAc54=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X-Gjl9h_1772675862 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Mar 2026 09:57:42 +0800
Date: Thu, 5 Mar 2026 09:57:40 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	yangyicong@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v1 1/2] KVM: arm64: Fix page leak in user_mem_abort() on
 atomic fault
Message-ID: <yjqinaji6r6na4weqy2ne52xfcgr4bp4acm2btrv6ri7bpy53r@mk4fnagzgwig>
References: <20260304162222.836152-1-tabba@google.com>
 <20260304162222.836152-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304162222.836152-2-tabba@google.com>
X-Rspamd-Queue-Id: 934A920A0FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72777-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yaoyuan@linux.alibaba.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,linux.alibaba.com:dkim,alibaba.com:email]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 04:22:21PM +0800, Fuad Tabba wrote:
> When a guest performs an atomic/exclusive operation on memory lacking
> the required attributes, user_mem_abort() injects a data abort and
> returns early. However, it fails to release the reference to the
> host page acquired via __kvm_faultin_pfn().
>
> A malicious guest could repeatedly trigger this fault, leaking host
> page references and eventually causing host memory exhaustion (OOM).
>
> Fix this by consolidating the early error returns to a new out_put_page
> label that correctly calls kvm_release_page_unused().
>
> Fixes: 2937aeec9dc5 ("KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ec2eee857208..e1d6a4f591a9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1837,10 +1837,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (exec_fault && s2_force_noncacheable)
>  		ret = -ENOEXEC;
>
> -	if (ret) {
> -		kvm_release_page_unused(page);
> -		return ret;
> -	}
> +	if (ret)
> +		goto out_put_page;
>
>  	/*
>  	 * Guest performs atomic/exclusive operations on memory with unsupported
> @@ -1850,7 +1848,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 */

Hi Fuda

>  	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
>  		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
> -		return 1;
> +		ret = 1;
> +		goto out_put_page;

I thought the way about do this w/o introduce new label,
but it doesn't work due to the lock asseration inside
kvm_release_faultin_page() w/ if just small changes...

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	}
>
>  	if (nested)
> @@ -1936,6 +1935,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		mark_page_dirty_in_slot(kvm, memslot, gfn);
>
>  	return ret != -EAGAIN ? ret : 0;
> +
> +out_put_page:
> +	kvm_release_page_unused(page);
> +	return ret;
>  }
>
>  /* Resolve the access fault by making the page young again. */
> --
> 2.53.0.473.g4a7958ca14-goog
>

