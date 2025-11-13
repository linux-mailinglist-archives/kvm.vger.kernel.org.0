Return-Path: <kvm+bounces-63049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE77C5A0C5
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BA8033511A6
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150E0322A28;
	Thu, 13 Nov 2025 21:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJgXktwd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1BF320A38
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067774; cv=none; b=HbVs4xhOFmRS7RoBHdRo5qv/s6rcoeqJ+gN7W+XPosw3Om1tqwTOY+CstpbXz9wyHTBU8Mf5pwvoUG6u6+Sh+Y1pMWA+K1hgIRb+DQ8zQrc6a+P1fDW831egpH0dXU8PP3evrdN1DwWOW0hPVmcqoVr9pYAvx1yxKsWbSSBnD2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067774; c=relaxed/simple;
	bh=JJMmcUtZJp8Q17nld1BqpwgAO2U2Da66BAIpwFh59GE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IoD55KSZ555Fa38sLcH0ZCd+M4VYlDdByoV6nr77wyIkR0BQ1sObVMTOKu1W6V5B9n4JrOeZ2G7WQ33P/tqCVYwUTVxWcapA9oXjc/kac+8gJASCmG9Bq7nPrff54F/pNxk6iU57ZUwVfWVQCbO9H2XQXzZfT90PP9I4KgPltc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJgXktwd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343e262230eso1623979a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 13:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763067771; x=1763672571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7uBxDd7R+0ljt93BFkiA/Yx0vDhWSjlZQEH3Y9tQqs=;
        b=pJgXktwdp6HrNeZBlKRTlyTwF56c66JASo7/qDcXW2VBYHpf2JWjaVVjWUjzHVAbBu
         wxniwqrEM9I0MQTX8FTTl/MfhoQH20/f8PQCftGdqYPqxc5jAdLGlCE65LR8SdZi7bqr
         5eVHDE3uvjW7e2WUF9kuUYMQ1rc6RgEqMsYP23CqRNcBDsIFoLT0a41mZkufXwitf+Lb
         isKNoVy1o9xOjnlQP0gg72IzgbB3pCoZUBPGNOwms+bR54D8mm871PNb+Z9vMpXB672J
         ckzOv5ez9Po93rPWzo3Ejgm3jcfVzyv4EzsOMZa6/RjoZF/tsMBOlf719CFMjkPpeiV2
         TWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067771; x=1763672571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a7uBxDd7R+0ljt93BFkiA/Yx0vDhWSjlZQEH3Y9tQqs=;
        b=SskswyNZwookginAB5hTVVxDc9zcIPmwMBsrVpjrmmlTUud8WfWn1ZvGh4Q9pgzal9
         8LTd2eKoXCE8ZQONltlzvcKLJWlPMUH0Gb55Z81FzVoukcVqgsfCthwWpTubECfPs0JM
         9vCHCgurUj4kVDVDJ6/9jjpdmnlEFX+NzznRvn6I5tboWaF8skPo1TDwEKNSQkzVQb0z
         +9JjxpGT4syAtOAuvCI9mGR1isNrTFtEE16dQoEyppQLmV78yi74vfocft4frkhNYL65
         Wuem13lPE6qmGgJsIfmBEpfXqstd8rPztuudwawoR1/PzFV1estoOCGnMJGv1mAiPa2K
         LZ+A==
X-Forwarded-Encrypted: i=1; AJvYcCXbpfC0C7fGBh5LF+6ogM3Gil1KGsY0unRXJVnBi1q4JxAjyjS4tZ5fJsNUY1/aCuIVnuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXWLu/nfovQsy2GwyFp8HEzyJSoLnRreXZ05jtOHcAEUSn86z0
	fX+AeRGK3BWsLCMSzi0f0U6t8UaNvXTgPIzn2H6XBTXj3lF1dPFxGpkm69yUYObvQPKm0mAjSOI
	46tgKcQ==
X-Google-Smtp-Source: AGHT+IF8Q/p7fFdV9MiImezpF9mKOY/uB6kSCpqMVPn6O8zg7LXO9eBP9jm0kD68oKRw55JkZXnSS7LXjkM=
X-Received: from plkn5.prod.google.com ([2002:a17:902:6a85:b0:295:1ab8:c43c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b10:b0:296:3f23:b93b
 with SMTP id d9443c01a7336-2986a6b7b8emr4493805ad.2.1763067771151; Thu, 13
 Nov 2025 13:02:51 -0800 (PST)
Date: Thu, 13 Nov 2025 13:02:49 -0800
In-Reply-To: <aRGOu3eJoRnsaV+n@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251108013601.902918-1-seanjc@google.com> <aRGOu3eJoRnsaV+n@intel.com>
Message-ID: <aRZHeTNW9o5SlQSK@google.com>
Subject: Re: [PATCH] KVM: x86: Allocate/free user_return_msrs at kvm.ko
 (un)loading time
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Chao Gao wrote:
> >-static int kvm_init_user_return_msrs(void)
> >+static void kvm_destroy_user_return_msrs(void)
> > {
> >-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
> >-	if (!user_return_msrs) {
> >-		pr_err("failed to allocate percpu user_return_msrs\n");
> >-		return -ENOMEM;
> >-	}
> >+	int cpu;
> >+
> >+	for_each_possible_cpu(cpu)
> >+		WARN_ON_ONCE(per_cpu(user_return_msrs, cpu).registered);
> 
> Could this warning be triggered if the forced shutdown path didn't
> unregister the user return callback (i.e., with the patch [*] applied),
> and then vendor modules got unloaded immediately after the forced shutdown
> (before the CPU exits to the userspace)?

Probably?  But that's more of a feature than a bug, e.g. gives the (privileged!)
user the heads up of how exactly they broke their system when they forced a
reboot.  I'd prefer not to condition it on e.g. !kvm_rebooting unless it's truly
necessary, because it's "just" a WARN, i.e. shouldn't crash the system.

> [*]: https://lore.kernel.org/kvm/20251030191528.3380553-4-seanjc@google.com/

