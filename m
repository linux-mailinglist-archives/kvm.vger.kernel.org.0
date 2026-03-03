Return-Path: <kvm+bounces-72582-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yK5cCSM4p2lwfwAAu9opvQ
	(envelope-from <kvm+bounces-72582-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:36:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C4CDD1F61E7
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 79AF13055478
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A0E3976A2;
	Tue,  3 Mar 2026 19:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gC6G77/o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471BB397686;
	Tue,  3 Mar 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566445; cv=none; b=JEWWAEqKKAc9bcXjuGX2VCnXusOja8EdMHu3JmyitxVRkvRULAQLlMH60hwHbeQlGM4kjTw8TQuskttCo4qTJ26qRj0cl6W5HyIHi+fHIL1hamtdDoUpIUAwid0kDENkR+444zNqawZNxRDIi43yiDM+YGGqivqXGLEGtby5RCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566445; c=relaxed/simple;
	bh=XNSxifEFf2irY46BpjtXhqwA8XGnDUzWVeM5fRdCTb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFBEXibqZJK50F/D5zP9XKOLdJlBhCd4NTPTBwAHrBt4rcam4RBag7XzmSijCddB1ors4e7aZMiuphcUkg+2E6WYKdSxZrNr9ZReaAUEJkRuDKGrraaxd+OyPXmoQprDmiaW19kORPc/SXotDUXJmsXynu9i82OSFrmNe/wOrcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gC6G77/o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD30C116C6;
	Tue,  3 Mar 2026 19:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772566445;
	bh=XNSxifEFf2irY46BpjtXhqwA8XGnDUzWVeM5fRdCTb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gC6G77/oeW8p4NXlyLn6UCy3gtHjA8Nj0dRRH2/liP8nHLq7QF9QUxaq98huKTstn
	 BGT3L1538Sdjm2VWaDskM6pl8gVfB2NoPmla+XHodrHSJimM4Rmi/itXdXwQbdNb3o
	 UWogD5C53UWVbwn0fiPe8uD6URMB95qolyuejUFr8NQB5y56SOSOy4Z/NKoFED+q2N
	 BPHaySs3Pn0x0/LYgaLCjAQU8Qsl7RpwFbZ21LKOIN/8CR7tdx/A7RfbKEe++yFMpy
	 LZZtlzYJGiUosgcklcUVVUv9gBD0S7XuasZxrAQG/f/nvKGB93MEEeNA5/Bc5SQ3PI
	 u552hl557d62w==
Message-ID: <0b06d473-4116-472f-8908-4f36d204b2e2@kernel.org>
Date: Tue, 3 Mar 2026 20:34:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: PPC: e500: Fix build error due to using
 kmalloc_obj() with wrong type
To: Sean Christopherson <seanjc@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>
References: <20260303190339.974325-1-seanjc@google.com>
 <20260303190339.974325-2-seanjc@google.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260303190339.974325-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4CDD1F61E7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72582-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chleroy@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action



Le 03/03/2026 à 20:03, Sean Christopherson a écrit :
> Fix a build error in kvmppc_e500_tlb_init() that was introduced by the
> conversion to use kzalloc_objs(), as KVM confusingly uses the size of the
> structure that is one and only field in tlbe_priv:
> 
>    arch/powerpc/kvm/e500_mmu.c:923:33: error: assignment to 'struct tlbe_priv *'
>      from incompatible pointer type 'struct tlbe_ref *' [-Wincompatible-pointer-types]
>    923 |         vcpu_e500->gtlb_priv[0] = kzalloc_objs(struct tlbe_ref,
>        |                                 ^
> 
> KVM has been flawed since commit 0164c0f0c404 ("KVM: PPC: e500: clear up
> confusion between host and guest entries"), but the issue went unnoticed
> until kmalloc_obj() came along and enforced types, as "struct tlbe_priv"
> was just a wrapper of "struct tlbe_ref" (why on earth the two ever existed
> separately...).
> 
> Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
> Cc: Kees Cook <kees@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/kvm/e500_mmu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/e500_mmu.c b/arch/powerpc/kvm/e500_mmu.c
> index 48580c85f23b..75ed1496ead5 100644
> --- a/arch/powerpc/kvm/e500_mmu.c
> +++ b/arch/powerpc/kvm/e500_mmu.c
> @@ -920,12 +920,12 @@ int kvmppc_e500_tlb_init(struct kvmppc_vcpu_e500 *vcpu_e500)
>   	vcpu_e500->gtlb_offset[0] = 0;
>   	vcpu_e500->gtlb_offset[1] = KVM_E500_TLB0_SIZE;
>   
> -	vcpu_e500->gtlb_priv[0] = kzalloc_objs(struct tlbe_ref,
> +	vcpu_e500->gtlb_priv[0] = kzalloc_objs(struct tlbe_priv,
>   					       vcpu_e500->gtlb_params[0].entries);
>   	if (!vcpu_e500->gtlb_priv[0])
>   		goto free_vcpu;
>   
> -	vcpu_e500->gtlb_priv[1] = kzalloc_objs(struct tlbe_ref,
> +	vcpu_e500->gtlb_priv[1] = kzalloc_objs(struct tlbe_priv,
>   					       vcpu_e500->gtlb_params[1].entries);
>   	if (!vcpu_e500->gtlb_priv[1])
>   		goto free_vcpu;


