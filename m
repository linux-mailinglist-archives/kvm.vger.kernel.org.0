Return-Path: <kvm+bounces-53315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E72CCB0FBD0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 22:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 725747BB3D6
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C00C23B613;
	Wed, 23 Jul 2025 20:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tRvqJ29w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5162723AB94
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 20:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753303106; cv=none; b=QyK7Dlzspxv0ER93/sw3ADEjVy635rLFqCUBenykH4Rqr9W2e+T6Go376Mp2LARTaC1DgNk+GunUD/efX6lCpyd4CxZAi39O3oCT/VBt49NToSqQbtBJgxPjca7PdE3UgJmRBhRpBsX3CwUPvC0zZGHRXbdaKBOMvoHNo/IGimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753303106; c=relaxed/simple;
	bh=9ksNRByA1R6WRpgBAqiFWOz1XaJlUuXPr+5odDMxUFw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pHIpdXQJ5HEWMRySNBK5X0PYXDNn2QpmM+vFl31OT6wI4/kzRKYMz3RdYjgWIDTFmRSO6RGeW30y0EbbSJ0+n/nUd5D5yoEEdywd+Tsleoily/7x6CqN1+9F23qJ5Zbk6bM/p5Jg93LbltQ8E4xSCVlXLlodg9N6P1AUexeztQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tRvqJ29w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so196491a91.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753303104; x=1753907904; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lngQW6Itt1q4DN9erl71oSaE8dVS9EZdINPQsN2S/U4=;
        b=tRvqJ29w0q4VvYfAxEoitAKpD7jlZys4VNC1KzEhXNP9b162/WAdaFrIbMMloTkwFq
         4pZUv6zsoZ2Rw5n8s5i16gge5w3fshkajdl9GrzR2gNLZxjztskyRC+N6WAeC8VyeRFg
         wBhAsz1WTk0zr3xqYac2iXeu29qtEmP9QicNa4CjjMpb8iIjOFHxE9h/DyyfvbnRqhhK
         ffqW79TWlOBb8bJhyxrkW6jptF/QcKZW46i/CO51JMDxxLXSeqfXGxKlIZr8WKZzBntD
         wKkHMzhJfCCcUCsrBLYd4rjLNydl2VrMYVoysA46qnaNIZZQSRN9fIih8NV9FKIRrAgr
         CxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753303104; x=1753907904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lngQW6Itt1q4DN9erl71oSaE8dVS9EZdINPQsN2S/U4=;
        b=r+bEmKjwMVxH+n2m+jgeq7F4K7pPhhXbswPFQoV9sSwhioyurjNhuCrpeRL/5LPAuq
         TrjnN2URU6kiB2AcAMGoQw9cfOrsIgR5YDvjY0tT3E1n5VuAH7gD0IVBGIVvnip+n7FK
         sCKWOZeXzQ+GSiXtPArXJfy8jTez61o+kNHfdlDVSeIbu/JSWOI8esR1Ko2Dt2EL+yOD
         WDDSkQxAnHaAdtFUvb5SkG2owDSRSnqQjwML5emqJDGpyXl7oSfiwnGwHwjq7bG163bc
         1DL17qNj38nf9Z3xL22nRXrT4GblZmCy6FK22gezTWmI8lbx03zEMMXsylpTOLE9PP4U
         uhrA==
X-Forwarded-Encrypted: i=1; AJvYcCU0QDysYOCOggTP/LJwWym8+vMgclOzjHtSiKb9FfZZcUi1Cj/LzIVh/RskPUBtWOPBJAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2O8c3nR+EHj8Nsd/Qf8wxB5no6wC9RRl18DtmTTWHiHvl98y6
	kJiv8SQafjhdoz4NPQl8+mXvdUcqitPdpGI+pARQl+oTsIMyNYmxNXNxy2P0L2dkQgHjF01MA2R
	nysKqYA==
X-Google-Smtp-Source: AGHT+IEquxd/YBrG+cywa0a1Dg+V5VomOJUYvM7hrpfchOE4B9Vl3O0Q+2Xy8S7PqUmaL7IPxMeVUuFecvs=
X-Received: from pjbsw11.prod.google.com ([2002:a17:90b:2c8b:b0:31c:2fe4:33bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c7:b0:312:e6f1:c05d
 with SMTP id 98e67ed59e1d1-31e5073f550mr6110372a91.2.1753303104581; Wed, 23
 Jul 2025 13:38:24 -0700 (PDT)
Date: Wed, 23 Jul 2025 13:38:22 -0700
In-Reply-To: <20250707224720.4016504-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com> <20250707224720.4016504-5-jthoughton@google.com>
Message-ID: <aIFIPm5zENeKlgkw@google.com>
Subject: Re: [PATCH v5 4/7] KVM: x86/mmu: Only grab RCU lock for nx hugepage
 recovery for TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, James Houghton wrote:
> Now that we have separate paths for the TDP MMU, it is trivial to only
> grab rcu_read_lock() for the TDP MMU case.

Yeah, but it's also a largely pointless change.  For the overwhelming majority of
deployments, rcu_read_{un}lock() does literally nothing.  And when it does do
something, the cost is a single atomic.

I'm leaning quite strongly toward skipping this patch, as I find the code to be
much more readable if KVM grabs RCU unconditionally.

> We do not need to grab it for the shadow MMU, as pages are not RCU-freed in
> that case.

