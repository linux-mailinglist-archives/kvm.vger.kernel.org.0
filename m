Return-Path: <kvm+bounces-71882-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8G2sNoVXn2kCagQAu9opvQ
	(envelope-from <kvm+bounces-71882-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:11:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4367A19D145
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D54F53029E65
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE4830DD22;
	Wed, 25 Feb 2026 20:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A+5JWYKQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747D12E7165
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772050294; cv=none; b=UpyAaLXUM7cTLzMyVtkZCmay2LOW25vaIJXQPMlEMS2INnj0Gn+EahVIauCbgvghydbZwsfYzIo72OUdgi9pTsZ/RgDfEftychFddR7aScpdtNWFu6/e00BCUrwTCocv9PeIfJ/XbjGclkyoDDPyb3LiHAJJofHOq4s+XIz+XZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772050294; c=relaxed/simple;
	bh=xb240UHeJZUpSheryUetfPnHX+Or5u1jl7cIe9qLxno=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F5+CObAQGnIJCP5g4vuCM8B6WRmPrmKaU9rHQw32fnd0Ccv3g4tLrDoxAb4/SQ74YhOT/Dx7BvFTygVCE0EngA/M4TqF7HLfkyAwLWAPhSr9P0519xTpqJ/ci0OlA8cRpN6ShmBRdX0in1vlkcijn1hSetUqOg+MbQqIw15wNgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A+5JWYKQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad5fec176so185415ad.2
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772050293; x=1772655093; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l12W4BbMOvS46dH8NvG0bfSFtU9wMtIxMN8ZzhevNqI=;
        b=A+5JWYKQxnVD5EXVFIur1MWNAwKcG9bCb8KIfudNJB8x0qwjHebgxy/crsMHdJS24L
         DRcQrW5JWjwpIrdX3ETKgM7lz1RAl1c88RBgO0nXmcuqQvL0k+IgQLKfjxAO/s8PGzkr
         8l0dP8jzHoDSTvbWPf+rn08l4cDvJ7msSoYWUwT3i5jOoowTFyFzam2Yfj3rlrdBH2ws
         YGnPh9CVxlIRbawpGDzLKdqUi23IJXk9psAhftBDBxwUfm7LZeN7/4mUP2WuDNwW094x
         lPjVHmBp/j/bVXqjtiKRH9l6YS5B6XVkHKxfltIjKCsTJDhAxYj971NXDZaTwW1vAa5u
         z9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772050293; x=1772655093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l12W4BbMOvS46dH8NvG0bfSFtU9wMtIxMN8ZzhevNqI=;
        b=JE7AzaJ01lZPsV488zS8+yP4ukRf7QlFF1g5UsshbAo2bL0IESSTVEkPZhlCAVPf39
         SnzKCCeQxdzdlhowdjzSVJd+mExxZxaq49uWxuEEOVN89SqJjfYFbEWHEm7ztbK35xh0
         5gqQkHhQ7hyeN1Dtcy9FdWzZG6fIyt+++NflbO0+H7srIQIH/Rrt1BLn9NTKU9KCTiJD
         CDj4ySgw3lXIUW5cqtt0RyamqJndG3z/+ZutZRVPrK/nIhNVQxb2eibCggGhf4Ho+g3X
         CbRuIoeV30R180eC+FqA6A5E1K1HOII11xrPR29UkMbbGQtpnN2QJh4RA7tGrMgKxuki
         YbpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVN49tC/rg9C0FpN/eUECjYIQjUZyTRAkwK7h6Q7GqJpsZ0sryxClwNZzZ2bogRV36FXeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyawkPxpzDYzgqgTPxh+mC+JU5KPoqL3/ntVPvg5LyAHl29XU3b
	W6ITGQCCO+veyA5C2KHcF3FhND2ZRcPXzv+rnNjituxkWQZaN7qySlQ78+96zvnQpzM4DBbD1Rc
	MNIGarQ==
X-Received: from pghq22.prod.google.com ([2002:a63:e216:0:b0:c6e:700a:2902])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a3:b0:371:53a7:a4aa
 with SMTP id adf61e73a8af0-39545ebb5a6mr14949603637.29.1772050292456; Wed, 25
 Feb 2026 12:11:32 -0800 (PST)
Date: Wed, 25 Feb 2026 12:11:30 -0800
In-Reply-To: <20260202074557.16544-4-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260202074557.16544-1-lance.yang@linux.dev> <20260202074557.16544-4-lance.yang@linux.dev>
Message-ID: <aZ9Xcgxa0_ouGr31@google.com>
Subject: Re: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI
 optimization support
From: Sean Christopherson <seanjc@google.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71882-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,infradead.org,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4367A19D145
X-Rspamd-Action: no action

On Mon, Feb 02, 2026, Lance Yang wrote:
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 37dc8465e0f5..6a5e47ee4eb6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
>  #ifdef CONFIG_SMP
>  	if (pv_tlb_flush_supported()) {
>  		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
> +		/*
> +		 * KVM's flush implementation calls native_flush_tlb_multi(),
> +		 * which sends real IPIs when INVLPGB is not available.

Not on all (virtual) CPUs.  The entire point of KVM's PV TLB flush is to elide
the IPIs.  If a vCPU was scheduled out by the host, the guest sets a flag and
relies on the host to flush the TLB on behalf of the guest prior to the next
VM-Enter.

	for_each_cpu(cpu, flushmask) {
		/*
		 * The local vCPU is never preempted, so we do not explicitly
		 * skip check for local vCPU - it will never be cleared from
		 * flushmask.
		 */
		src = &per_cpu(steal_time, cpu);
		state = READ_ONCE(src->preempted);
		if ((state & KVM_VCPU_PREEMPTED)) {
			if (try_cmpxchg(&src->preempted, &state,
					state | KVM_VCPU_FLUSH_TLB))
				__cpumask_clear_cpu(cpu, flushmask);  <=== removes CPU from the IPI set
		}
	}

	native_flush_tlb_multi(flushmask, info);

> +		if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
> +			pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
>  		pr_info("KVM setup pv remote TLB flush\n");
>  	}

