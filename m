Return-Path: <kvm+bounces-37909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D3DA31471
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAB0B188AB9F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DB026217B;
	Tue, 11 Feb 2025 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wVfmklPW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374A253B43
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739299994; cv=none; b=NXQro7lI1d6My9CSZLZEiEpH4U0fkTtoD+OpSzQLGwAKgRnkaLcTvGai4KIJnYRbYKPjBb9kUn5eUs0YWhRv7Pgzd4u05/ekn6h3o4RuquQY/GahyokYogJZncBoLkgNSVIUWlXpRPTYJOsvs+JblowC9Y3YdrN5zoFfpmwzNOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739299994; c=relaxed/simple;
	bh=yYcU2JZAoQo0PdjybSDTkRZ6mPUenfDV1ftO6rPg5Uc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dwtoATi+eU64Yzwj36sy1KFJ5dz22DX7n4Pu+K/OtbccHAGh3Y6E8lBNJ1eOzPYBUA7+bc7TRFjQf0qfsLEuu5uv2OE2o5EP6MIsIPOoZJqjlOfh0OnTRlIkH483gxSMmGu54EN5JB2osN6ZjKZofxZ/n2RbAvNN9TGLGMSbmMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wVfmklPW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21f40f40788so135793285ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 10:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739299993; x=1739904793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSdXzw5i+XGLoyBoJnanrigNUDo0sEg9JmDuJ0DaxPQ=;
        b=wVfmklPWmdKqL1wwIhnKrVwNMDsl8ft9pm3I3k5WtiVdqR1raSyrxwFcTtogrLTCWl
         IZXbLBjggkMZ/2owg48P+BHLt5hAS6vcWE6q4s+3mMwOtBue6PzJUGbFCojkbcId9pl/
         MrIqm49u17Jh27PIZuO66G3rLKFZH0Hr0wOPBj5jwZ8WSLBkAycysuegAZwX65rFtXVj
         CPnkpIRc4Nl+k1NvOmIkUaKSEXXSGcOkGyyIxpAou1ahisovocJKRiM252/E+xDUo3oo
         unrQxnMO4zqR0gTNwmnBxa/kaqjKMGmcpUi+QpyZOu6ZWZmLYWyjYzV8FMMefpEhZICI
         lZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739299993; x=1739904793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSdXzw5i+XGLoyBoJnanrigNUDo0sEg9JmDuJ0DaxPQ=;
        b=VCujv3nA9TGvE1lBrjMVAuD0Ia5SpMAvuV/zw4yre38k46pPKXFyyZTeK9DWHKMDfQ
         GR0YUC5nUBZHz/jBuBd+LEDNQkiYznRC45D8Nz1yS9d42YNPNXGp6wax4gNmDZgN0IdA
         vsTgOAy+mA9pybbw+X1tWztp4Llp3qItEwoQhGGrj4gkPQQtSgtEFAvNfVORalHStZ48
         AogMAtbgiapBDXjBEhDkpqC0tnEpH4o9lF8HHpEzNIx0v9XlwkVZLsgDH8l/4Cih7Qtt
         HHj3+a254LXmhQnqEzF1mcpkLrDzIqOzhIbf51MCePG5ed9jkf/zfdlfmSqCBDiWUBeC
         hbYg==
X-Forwarded-Encrypted: i=1; AJvYcCV/uBnPL+R6uwApG/5l0L4OASNEky7GDJj1xwISsb4E+yobb31DpZ9Q9WZAoyMYGJhtLRc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywps+HShHqGRet93oDb+qLZCJ0WgHinGeewyQ7X+Bu/TdBDi07u
	Yh2LAwmxBKT16M3AMxu/BPCdZHU3q1QEgJbpJzfz6kU1At6jVfCmuuleLwKzWTZxRWeS3DkV6u1
	+Xw==
X-Google-Smtp-Source: AGHT+IFX8Gb8h6J+XoaDUIOL0BfhgtQAHFbQcWrM3kh7lUuCjN0+4w5jTeoVicZi2AD+wRaXv1IpPGRPdQY=
X-Received: from pgc1.prod.google.com ([2002:a05:6a02:2f81:b0:ad8:6337:811d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7314:b0:1ed:7540:45d5
 with SMTP id adf61e73a8af0-1ee5c74ccf3mr617940637.17.1739299992823; Tue, 11
 Feb 2025 10:53:12 -0800 (PST)
Date: Tue, 11 Feb 2025 10:53:11 -0800
In-Reply-To: <20241127172654.1024-2-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127172654.1024-1-kalyazin@amazon.com> <20241127172654.1024-2-kalyazin@amazon.com>
Message-ID: <Z6ucl7U79RuBsYJt@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: async_pf: remove support for KVM_ASYNC_PF_SEND_ALWAYS
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	vkuznets@redhat.com, xiaoyao.li@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, roypat@amazon.co.uk, 
	xmarcalx@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Nikita Kalyazin wrote:
> 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9 ("x86/kvm: Restrict
> ASYNC_PF to user space") stopped setting KVM_ASYNC_PF_SEND_ALWAYS in
> Linux guests.  While the flag can still be used by legacy guests, the
> mechanism is best effort so KVM is not obliged to use it.

What's the actual motivation to remove it from KVM?  I agreed KVM isn't required
to honor KVM_ASYNC_PF_SEND_ALWAYS from a guest/host ABI perspective, but that
doesn't mean that dropping a feature has no impact.  E.g. it's entirely possible
removing this support could negatively affect a workload running on an old kernel.

Looking back at the discussion[*] where Vitaly made this suggestion, I don't see
anything that justifies dropping this code.  It costs KVM practically nothing to
maintain this code.

[*] https://lore.kernel.org/all/20241118130403.23184-1-kalyazin@amazon.com

