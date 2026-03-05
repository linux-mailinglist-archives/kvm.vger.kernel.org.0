Return-Path: <kvm+bounces-72865-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APMmJ6S6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72865-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:17:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 409B221604F
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B202C3054C2F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC1A3E5ED0;
	Thu,  5 Mar 2026 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q4ioHUhl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F283E5ECE
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730755; cv=none; b=MBb05tTl7CFmDK1IPbTSq4kwiCmLxvTEOEKYqTBgB9QvQcisEw+1KIc3x8XIS6C8ei+v8aWGFJxA9nbrt/g2j98jzDkncERqPxHKc52TKosRO7KN975btphIJpSu0nRNlRy+FmLniy/4wszPpElH3c0GQDJIMX/rQ6ufKFwVSF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730755; c=relaxed/simple;
	bh=dns5h0qR2KZ4FdzLbrUrUvVJWrBlR2/7jhXyY3CqByM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iT+qq4KG2sKg08k3+sNB/vo9/6DgwNxArpA3dseBTupchYySRseyESbjVi5QYTwasIrdB/bpjHQVElOXNAszZNG99fcZkR7prLxGOtpC2MtomgmnldWvF1iRDg1sjrB8jYVFJAbf2nrEKzIUIjFoSrWy3gHCUn3fwv9C0MbVtPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q4ioHUhl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358f058973fso7928569a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730754; x=1773335554; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V8qFCWJ5evls0w2NVX0f3a/m73/uGRK6Z8I0hTOz8KU=;
        b=q4ioHUhlWhY1kW65PuKNBZ6MFuCifKJS4tMrkcDicOre6qh/PkOHbgETjC+xKTaSfq
         CVFF/gTd9eukWGd0t/NbcO4VW7dcidd8jd8rTuaas97BkgAuevs1C8SOsedbs1hCQnb4
         0ts/vqfYG7fsfeW8/JQmAZnEz1PLI03nQLK6ja8vcckiH7F0mCcSuq9zf++yiywfKDAk
         SPuuXtlNfWR8zXOkb9kYyEVekWZTiHT7lEFI+j/dazLJJhvAHtKaeLnOWPWZajCK9w1U
         0JNfBXbw2AhCFZ1UvlBH8m5RD4KxbVtkACA5e02a4pjJsX+Q19Z0er3Z/w+ovXe3fb0m
         P3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730754; x=1773335554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8qFCWJ5evls0w2NVX0f3a/m73/uGRK6Z8I0hTOz8KU=;
        b=YbQKDA6FwxZMTkuugO3MuKzsBNblysEiyhrPtZvHS7DiWJPWJjz1+bLTPYRWuWYjXI
         OM21k7N8dXAp4/QThSmBzajsYfI5JAh582hDYEJTaT61gvSomnHeT/37/CrENG7BSG+h
         LXXb6mPPrXCtimUj/MpsgJlOjQpgUNOsyZB1jEfvzn5Y7Hnmoh/ITEYyIx/Owr33HrYU
         ZIgvRG9XJJ/XAptQcquOCYTcKQYXardbn0HMQS0cIc0CHlJMtUQ0TcP6AJkrqWIH2pxs
         2AHrnUV08KlTTRAowyPKjXgIfyrh2KKpyaq5i9/J5PoroRD+U5Kp3Bm3p+coUge5+UIs
         TTgA==
X-Forwarded-Encrypted: i=1; AJvYcCUgawTXxrud1Mvzs7voYmHoYNTFYbyj9kicV6n/3SOrONaEDwKQaEBQiLXLnshQe13wT2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDWppnTabItP09yonWbV9LF3tfMejs366SmTtGbJfyFBrANthB
	j22ejG4nNmq/6IeDWiCiWIhZ208ihT8tjs4z54fQOUMEInFwBZGu+kSRtWhhifsAWMyvP/5QeIc
	EHmZn3Q==
X-Received: from pjsv10.prod.google.com ([2002:a17:90a:634a:b0:359:803b:2e2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4f:b0:359:9b45:7754
 with SMTP id 98e67ed59e1d1-359bb40455cmr225426a91.32.1772730753957; Thu, 05
 Mar 2026 09:12:33 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:19 -0800
In-Reply-To: <20260203201010.1871056-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203201010.1871056-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273034728.1571417.14215404445053164555.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 409B221604F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72865-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 03 Feb 2026 20:10:10 +0000, Yosry Ahmed wrote:
> KVM currently uses the value of CR2 from vmcb02 to update vmcb12 on
> nested #VMEXIT. This value is incorrect in some cases, causing L1 to run
> L2 with a corrupted CR2. This could lead to segfaults or data corruption
> if L2 is in the middle of handling a #PF and reads a corrupted CR2. Use
> the correct value in vcpu->arch.cr2 instead.
> 
> The value in vcpu->arch.cr2 is sync'd to vmcb02 shortly before a VMRUN
> of L2, and sync'd back to vcpu->arch.cr2 shortly after. The value are
> only out-of-sync in two cases: after save+restore, and after a #PF is
> injected into L2. In either case, if a #VMEXIT to L1 is synthesized
> before L2 runs, using the value in vmcb02 would be incorrect.
> 
> [...]

Applied to kvm-x86 nested, thanks!

[1/1] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on nested #VMEXIT
      https://github.com/kvm-x86/linux/commit/5c247d08bc81

--
https://github.com/kvm-x86/linux/tree/next

