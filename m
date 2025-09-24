Return-Path: <kvm+bounces-58698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FD8B9B8E9
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD35B1BC1FD3
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C339731771B;
	Wed, 24 Sep 2025 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fx6/HPyy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E2F313D45
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739487; cv=none; b=Zz/3RdZVmEMvo1iHNZS7XkoOiqqOfEKvgf2cgAbQhLzXyUuu01aId+azm5+wxgY+uAbVabvNB32TfheNkR2m2C8/70+dKhfJnXdQt91RmpYPjZ0lTdlrWLM52ykSn5kUQsx+uHn8AVVHnzkKAiEfFXINT2PitJmuE7UegXpi2Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739487; c=relaxed/simple;
	bh=XrKYdpCzTJitBfTH7h3tMpzc9gUATsq6f2r027mR+Fw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=itxWZrpD7sESHB7srDeYIG1ZxCqApPUBm7MlnlRaVmuK3reJVbZZxYSdqUW78WwtR7wzMntKBuRaqd7rNcNWPD7F93IFDJ//dtmnby/KR0UjNLMf2nmYTmJcgiKImXrgfJqnXFboeHFlkfRel/tALHZOZrSdP+G6tN3oQ99zInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fx6/HPyy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27eca7298d9so2247145ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758739486; x=1759344286; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L4wsQZfmoQA8Yf+bei6HdCOLaw6MvQvAF54nH254qZc=;
        b=Fx6/HPyyUpLi6odSFMy4Pt7HL+rCrPAsw9jD/NCC4YbA8ISl4/8HBww6Fjbzw2NKvK
         aCOZKZwvRcCNIc3Q8OWEebEDx7/da1ukqghYk6E/F77HJhb/n4SWwi8fug2MSmkkuuA6
         v7Duervm2Zk8mV9erm0yPCsTtK6vO3OeV7HNoWUlPfQHlPuquihNczNnuNT23tY9ljkP
         e70cdlJi6KXpBQJPa7lFcERGFong9ldIZmtWKYz1RIKbPZHffTDSp++qS6aGOLxPqi04
         nMbnlvfWpnY4eVvuILdEIO5+LGFpIxpX+APq7jcJVAW4wSrgQPu2fhGCsf7DK7yGHcIX
         96FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739486; x=1759344286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L4wsQZfmoQA8Yf+bei6HdCOLaw6MvQvAF54nH254qZc=;
        b=ZVtCCZ2syOF386dMBEOs03oQGp6pN7ZsDONZJ+aZZFG7N+Pia0ahG1GXV2pEwoSx+L
         H4LFcZ34DMLts2MCOPtGjTY3xbcv7QHVDXOZjFsj6RkVlvITgV7XAbbo2Bw2z1m/g+80
         YkZnexD8v8VKQUoxdN0WF5ql8QXq4GthqEuau5IlnmqgTVdnjrHxKV4etczpAeJqz7GG
         X4lZ6f29jOPO8SEyBW4vO1kcrHExgjA1fF/SVFL8hOkiY/ZZ4wtPfM9wocQQeLbs3KxZ
         MHsOlyjre0BlET/9XLSBQoPzvezqef67acI0LeK1+9eZ3t48JOvrxbgj2bOidASFRE8y
         jNGw==
X-Gm-Message-State: AOJu0YyxOYHJzikZvEU6zegH4PI8+CTUFsOquUJO5FE+eivOn74jvWSe
	CKPF5KQl+4087vYmQLcf7cb638ElpvU9YOOJKbSP7OW0KHY2krclIpdJP7cSgF63wH7rgo7wD7a
	Pd9W79g==
X-Google-Smtp-Source: AGHT+IGKhkRu8Tnpm5tsgJtAbgTyL1XLOvAwUGapjYL4K8zGN7RqMAnR/PaO0GD5m9zp6FYgrHnhaRE7GZ0=
X-Received: from plbkw4.prod.google.com ([2002:a17:902:f904:b0:269:ad1c:3698])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1209:b0:267:44e6:11d3
 with SMTP id d9443c01a7336-27ed49d2bf5mr7779945ad.21.1758739485753; Wed, 24
 Sep 2025 11:44:45 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:41 -0700
In-Reply-To: <20250919211649.1575654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919211649.1575654-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873636645.2146220.17008570618264199146.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SEV: Reject non-positive effective lengths during LAUNCH_UPDATE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 19 Sep 2025 14:16:49 -0700, Sean Christopherson wrote:
> Check for an invalid length during LAUNCH_UPDATE at the start of
> snp_launch_update() instead of subtly relying on kvm_gmem_populate() to
> detect the bad state.  Code that directly handles userspace input
> absolutely should sanitize those inputs; failure to do so is asking for
> bugs where KVM consumes an invalid "npages".
> 
> Keep the check in gmem, but wrap it in a WARN to flag any bad usage by
> the caller.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SEV: Reject non-positive effective lengths during LAUNCH_UPDATE
      https://github.com/kvm-x86/linux/commit/5b66e335ead6

--
https://github.com/kvm-x86/linux/tree/next

