Return-Path: <kvm+bounces-72878-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNQDBd+8qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72878-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:26:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 904002162D0
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B96613028B2B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894AD3E3DB7;
	Thu,  5 Mar 2026 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G7hWePbU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A47F3DEAC8
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731378; cv=none; b=j0A2JpddNaa+sCSrNhnyh6+MWOzKkB1nFxrkDErfY9YIFiwTnRMzLuwUwNqPNPq+Wr+P3UvGCHR//Pkunf+ttMn5gDXMGZCOzdaMNynZ9Wlg/nCs1G6Gs1mxkX6sHP4A7po5/gajTRZzJ3GPpMZ0mq9JDgGt3HG09V4XeN9g5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731378; c=relaxed/simple;
	bh=44nrwl9MtsM8nG2wYpqGAWFgiMCuaPB9R7DRYfG94no=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7xsqwbGzV3/6PRhftl6rWHii/a/6QnS6MtJytp09xgh6SFGJ0lh0emmr1p9F8p706Wq42wpeL0pvllWHFGF0oXU2cH0U7xss6A3LFpmW6O6QMSmOGn36heSKCkDmi6o7jb+/GKIpTiFFy8cImT237aAStqeqDvhgKYjYdIeB9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G7hWePbU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae4af66f40so55984725ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731376; x=1773336176; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p1wGeuRJ/eZ0ds4iRA1USsFNUrpQJYzw8H7jxKUj2JY=;
        b=G7hWePbUS9tIdqWWJqfgbeDZ8pmF9H8RTx1uf1aY+HMbX7/htd8bjbLUrKDMyK4uDd
         To+eUFOfNHaKYRW6uQ5PiYbRueoydo7+SGHvRllk0eduLDOUd0/FCYDyK4kJSmQVPHEw
         0QHGvZ/CabZPgXcIenZk70ZNI00h4OSlaDwNTQUvu2AgCxkID6w3lZofTh4B0467UEla
         OhM7HiwhukAZTLY/D36SyQPtMOVTVWbrCyb4M0oRj/mjcp6r1qsZ6mnTi5STupCJq251
         mG4o+jECz3tyqGGo/g8dlmdDrpvbil6+YISaoYYT3+RgR090lyjYISSsJtCiWclCAeyt
         feaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731376; x=1773336176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1wGeuRJ/eZ0ds4iRA1USsFNUrpQJYzw8H7jxKUj2JY=;
        b=TuHz/u5vcOCfEh6m+3cJj7z+3/tWMneYoF4I6TXDCHjNay2SOUohoYTtRzztbIv/lz
         wCHpQBAEuO90NCTL/jFx6NIwDo9RXIPfImCxdj6HOvhz4tBblyKqJjlsUDVjHBI6G+iL
         iiAljUHH4cf38QhFBAsPtqVkUzgQHNOTNNWM/CBdrwbMzxAIJaFLyqr7Xa9+ateT3e5q
         OEiwxaFVszfg56fzeoXTEBeUeCEt9nqRm2EiHX2xneFRh0j0LBgHek/YwIdqfo4FEbYd
         qKZDk3Sm4ZfZFfQeSwZExk2dKJWL3RJSyuC/q2yGxoZHt22EQ5ZLYeToR5m54tPk2tr5
         WlaA==
X-Forwarded-Encrypted: i=1; AJvYcCW393bqlxz4d7sdkB6FTB9ygsHExJ43gEuxnEV3OeDpD4CAqn3h95X1AikxEbTQEHMOocU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnW178g0bS0Zx99n0jBS1KbijUQcObya5dVPPi704ItybgWNsU
	rKYn64BL+PK3xLXRMoq+siHxp4iRpxuOLp0ZssVAiB9dkApzSHKfavCtwFlnLTkqVPHtOlHts5b
	S76/jng==
X-Received: from pgbda4.prod.google.com ([2002:a05:6a02:2384:b0:c73:7810:6005])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:166e:b0:2ae:7efa:b2ee
 with SMTP id d9443c01a7336-2ae7efab422mr8334235ad.45.1772731376023; Thu, 05
 Mar 2026 09:22:56 -0800 (PST)
Date: Thu, 5 Mar 2026 09:22:54 -0800
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
Message-ID: <aam77t8fe5RKSr2Q@google.com>
Subject: Re: [PATCH v2 00/10] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Bibo Mao <maobibo@loongson.cn>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Colin Ian King <colin.i.king@gmail.com>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 904002162D0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72878-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[redhat.com,google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[41];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Fri, Feb 20, 2026, David Matlack wrote:
> This series renames types across all KVM selftests to more align with
> types used in the kernel:
> 
>   vm_vaddr_t -> gva_t
>   vm_paddr_t -> gpa_t
> 
>   uint64_t -> u64
>   uint32_t -> u32
>   uint16_t -> u16
>   uint8_t  -> u8
> 
>   int64_t -> s64
>   int32_t -> s32
>   int16_t -> s16
>   int8_t  -> s8
> 
> The goal of this series is to make the KVM selftests code more concise
> (the new type names are shorter) and more similar to the kernel, since
> selftests are developed by kernel developers.
> 
> v2:
>  - Reapply the series on top of kvm/queue
> 
> v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@google.com

Sorry, I was too slow and missed the window to get this into kvm/next without
causing a disaster of merge conflicts.

I don't think you need to send a v3 though.  I'll prep a v3, a branch, and send
Paolo a pull request during the next merge window.

