Return-Path: <kvm+bounces-55153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D90DB2E051
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0209A05075
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CFC335BCA;
	Wed, 20 Aug 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N3TasCgT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E9322544
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701893; cv=none; b=Fvo397rWeLg+Zi1AOMItbNkkA4GKjyVmhkni4qkZZmM3r5JXZcY93UE6oVR+7QQvtnO8+gLWIGIN4fWmYrIBh+SjglkORqLsFeOrslQN6Eea+T/CXeXC7p1Ish8K9h1J+dCHJLuAt9gT7je+UHLar4GcAFxnENPT9VaQX/AKi08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701893; c=relaxed/simple;
	bh=CspbNBhuYsQ7du6/xNp1Y5AUWYuRxxmyICpjtfMmmAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ulpWKSTIF5YgwfzSt7apM9sH1D+EXmyQ3fkHicRg+BqamVoLM2XQyTaxObbusXiG7saxxpCszS9QUndYLsRVTZCPebdh6OZY3pEF8o8WIBopcvtcBVv5nVrXZO2he50wlabISU1XimBJpu/kTDtEPrNUf+Vu0s7vHBfKwi+tAVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N3TasCgT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e09c5fso8397a91.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 07:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755701891; x=1756306691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oiMay2IdSLHxdRMiaPmIEcwuoM6FhIvI0i1OVkS60Rg=;
        b=N3TasCgTNbvuetFtQeemUwHi6Utkf++dvXGKCVbhi49ZlEiPdrGz9upLgPjtGYJsZo
         yrmJqePwoG4aA6GmUzBs2/MlQbBLGnUhhOELQwsrMQNAHtN6hsNqN25RKjYC+rcr7j03
         Kb3OWzsex1jw73sQlwh3r40KwchxY48aWdJR1eUctk7XnH+0N+k/Wl7CttYBLPi1x7Dx
         BH4ar1Q57N/kJUv7j0EJh9DxEezpe9z2N3oJfeh2aBt8csOcJLv/08d+MkqNNi+BFhQz
         sndZyNygZSXk40SodWKsUHA850QzyNMj0b8JFqjs7ELryXU0bJLnGZ6R+0lKCooIbRiX
         iYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701891; x=1756306691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oiMay2IdSLHxdRMiaPmIEcwuoM6FhIvI0i1OVkS60Rg=;
        b=RHhXeYd7WCyBJo56+NQYg5g+P4NrEevWPqoh0e7/l8xPROpzwJsC/cgf+gj+iSvGi1
         A9ie1LpM9C5dDZrf0F69ITYHJpRK6kh7gIjUUPsIHQ65MuxJTRQICzHFHgh3UPKugZPq
         NRHwk8+pOJVk0mSbrnOflQofWtlr69Ue5ULU2D4/QhDRWUPGBRjWSR1w2Hy8qaeSYM6A
         lRntKRNBndBN7a533dM8Zcma62lcpzUZh9SLhZqAgPgOAqxndiOAImfAm0V2XfhQfSdW
         4BoYMM/gmL4zHz3FkkD+1hy6AST9+Xa+Wml281jQT7womPffnkhdsQLtqWjKcxuGrbty
         lucQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9xdiZH6MhEjLekYBSahPFInddgo20E+NoNNzc3rvr6WJJ2bYXI7ywUQ+Zr3e+s6Y+ngc=@vger.kernel.org
X-Gm-Message-State: AOJu0YznO88CqT+4kOWJfBqGWsBs+ZsWU7RYmxcnS9J6YlnP4kjoxVz7
	cbO7vc4w1wmNI6uFP0hjNC20Xgf2BYQMbSEw8+URn57xAbD9yBm6sfR8xEaAn93U+/OEIFY1hsF
	e/EZJRg==
X-Google-Smtp-Source: AGHT+IFF9tOLd+O+PeK/bjekdXgGVAp7JWSfLy4Z7Tuw7Z3CghxjcwedFydLMuTopL5E8f51XtOU2SaFr6M=
X-Received: from pjbqo7.prod.google.com ([2002:a17:90b:3dc7:b0:31f:232:1fae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d85:b0:321:8258:f297
 with SMTP id 98e67ed59e1d1-324e1420be4mr4203585a91.18.1755701890615; Wed, 20
 Aug 2025 07:58:10 -0700 (PDT)
Date: Wed, 20 Aug 2025 07:58:09 -0700
In-Reply-To: <bd3268e4c7a300db33a2cce373741f0e875474a6.1755700627.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755700627.git.ashish.kalra@amd.com> <bd3268e4c7a300db33a2cce373741f0e875474a6.1755700627.git.ashish.kalra@amd.com>
Message-ID: <aKXigZHIe91Fficj@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: corbet@lwn.net, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, herbert@gondor.apana.org, akpm@linux-foundation.org, 
	rostedt@goodmis.org, paulmck@kernel.org, michael.roth@amd.com, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 20, 2025, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
> Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
> into separate ASID ranges for SEV-ES and SEV-SNP guests.
> 
> Add new module parameter to the KVM module to enable ciphertext hiding
> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is '-1' then the complete SEV-ES/SEV-SNP
> ASID space is allocated to SEV-SNP guests.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---

*sigh*

Give people a chance to follow-up to the existing conversation before spamming
a new version.  Sending new versions as quickly as possible doesn't help your
code land faster, it just makes people grumpy.

I'm ignoring this and responding to v7.

