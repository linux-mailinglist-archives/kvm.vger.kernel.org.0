Return-Path: <kvm+bounces-47391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B49AC1288
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F4587B7D15
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2D328C86B;
	Thu, 22 May 2025 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cBJXvqDE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34495254873
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747935757; cv=none; b=eTmj/dM2eH4+qHYIkjHyfR4+W/iS6LsPeuV6DRqZw3F1AwXw+txw/WvzTL4qT5mHLU0BdMFCO7oql6t4OvlCEi5eymUHt2uOgBC27J6ldqyClrgPpw4+BZYzm51Ri+4J5pKtgBnQIUaOI4s8uuiauqrVRMbYpE9UrKAzXVAEkIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747935757; c=relaxed/simple;
	bh=T193aeRyJ1OGv0+6AYB8t+pbinpVG0oKPxn8mbqLW6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ef+JmsvE3wG0JanjRuZLNsFbAROv+Z6vVHiYO9Glaip5xWJqYhBUZAWKRs5FJ5uKyNBwnJlHofMijSWlQIxg+79xFPr3amcbT1Qu6sQok2qGULpRKkMWEJQ8DOo6sQ95A5v2rjWHhaViGHMgyBOlxtUQknf2H2Gt4Szw8XM909U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cBJXvqDE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ed6bd1b4cso6955243a91.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747935755; x=1748540555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTZzTjxME0+T407CR9T2jnDVgTWuq2jRrI32jdizTLI=;
        b=cBJXvqDEqJIxW7JlmSh8HwYJaAeJCwpZZdrzzV6AqwElBgTsOg7RECpAVDDINCwiax
         l4T0i3VcXZA7bv9FxQaI0xAjrd9cEr2DwN7UOPz++d5Ah+v8GtXAT04UGqmkC5SGo0lW
         Uj7LN8/i8f6zIwFpFjH6ZRJn8g5XSnUC6HKR47ojTYjQkiR0WCfo7B5e89Ngh5Zqrduy
         fDBSEvdMIi0IOOD+jm3sTHG9mhzZ4W4hCPtAFlc+V9SVaZUnfydQk1b1NQJpUeVKryGd
         2jbKgGynOqctBoKqMPbYbjp8SPQAtIttIiT1jJo1JPuleIXXhjIh6qlX4wWQXN+vf/y9
         Jc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747935755; x=1748540555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTZzTjxME0+T407CR9T2jnDVgTWuq2jRrI32jdizTLI=;
        b=islNLebXfN8mFDQz6G5nYCuTFKPT+a17hJ/9wyHeuojeDBQ9RCxKMtR1TV0Yw5lFnK
         l8HxDkUvwXHzaZTxuwizgQkixW+VZ91dSfTq5rDIfyhFBxUSfc8GxuCaK4dqWHZFN7j9
         gvFuMVdqsuyBbgmEpBTikmKscPqvbXQxmKmTUC1k4S3DQBb2LOBNXX4QSb/+SK0GI2sK
         34slqDy3FicRZym+IfhJXnZyyrsfHEhpZ9+mW5eBOamKpAWudQm4deaBwq3eDagqCTD3
         QPzumZWGLiTwDYXTzqes5XRaWseMM65hKPCiL/+Mpn1BFtEcClRdkHZLSFR4eEZs4nF1
         zRYA==
X-Gm-Message-State: AOJu0Yyz2uT6DAGtm4g+l9oeST6PszaAlHjbuWP90vu14wFeqFi76Tv1
	y4h/iVY0ulHRp5zRcjy55SUcmCHde1V+B2WhA7ZcBuINchsi0u3sAgUTmaLaRI6lvxeQwsldbVX
	I3Bl25w==
X-Google-Smtp-Source: AGHT+IEitcbqn8Ct6EIf9jvCMYvrO0otsPo/CrQ4mPp/jVLneyxQpCIIYoWk6Q6DEqLI2Pu1VXOQ/PvNORU=
X-Received: from pjbph7.prod.google.com ([2002:a17:90b:3bc7:b0:30a:9cb5:7622])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54ce:b0:306:b593:4557
 with SMTP id 98e67ed59e1d1-30e830ca012mr41799466a91.4.1747935744786; Thu, 22
 May 2025 10:42:24 -0700 (PDT)
Date: Thu, 22 May 2025 10:42:23 -0700
In-Reply-To: <20250522005555.55705-3-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <20250522005555.55705-3-mlevitsk@redhat.com>
Message-ID: <aC9h_9CyZ4DMAAi_@google.com>
Subject: Re: [PATCH v5 2/5] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a
 new KVM_RUN flag
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Maxim Levitsky wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Instruct vendor code to load the guest's DR6 into hardware via a new
> KVM_RUN flag, and remove kvm_x86_ops.set_dr6(), whose sole purpose was to
> load vcpu->arch.dr6 into hardware when DR6 can be read/written directly
> by the guest.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 -
>  arch/x86/include/asm/kvm_host.h    |  2 +-
>  arch/x86/kvm/svm/svm.c             | 10 ++++++----
>  arch/x86/kvm/vmx/main.c            |  9 ---------
>  arch/x86/kvm/vmx/vmx.c             |  9 +++------
>  arch/x86/kvm/x86.c                 |  2 +-
>  6 files changed, 11 insertions(+), 22 deletions(-)

As alluded to in the previous patch, TDX should WARN, because guest DR6 is owned
by the TDX module (the KVM_DEBUGREG_AUTO_SWITCH guard prevents KVM_RUN_LOAD_GUEST_DR6
from being set).

