Return-Path: <kvm+bounces-47395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D69CAC1302
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E73D418972C2
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 18:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA7619E98B;
	Thu, 22 May 2025 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x9XMkhaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AA333F3
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747937193; cv=none; b=buOKvUTnQdNNkE+ivD96FO9tJQuK8vF+97M8rHoG/uCqY/tJEXHF0wH1i3DhJnB4DJAKA3j+bVVeYkEULHizXEC1FXxwBmjDipRacpFtdeRZzcs+M5eoAEtnQhw/HnFYVHWLf2BP95h6l2x0eyRT1tKZeqrnj0+xGEbSER4TQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747937193; c=relaxed/simple;
	bh=SEyxKtglVMvhRRYrc8pRddx1p/+gcB0X1Nzyva2dm2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ikGjMi32aFz6aAzb4oBzmN7lFGHVLgstCioGsfTm4kAuS7MOaX0JH54jKG7PQQusQ95Jt08coiMXqREAJgm6mY5VtWrVghEITy2pXZW9uoVjbmVp1fP4y6lV/mkn8i/5125NfCYgaYeUgtY67fMrUxOgzt1xIYC0bBIJCU01aMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x9XMkhaV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e74ee960aso6592456a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747937191; x=1748541991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=egdJflRBmmuE1AnATRR+AKgbnICiGADQnaXxcKCGu7A=;
        b=x9XMkhaVvUkQ4qTE8ZInwVUOuCCKlqK2z+VAwEKEytZThZpMZQ9EOpmHvcvGu9OXyQ
         46ynvyf4rJ8Q4tbECZlI4zPZWTvCuTTRE2LccDS6YccpHaZQQgGAUbMDLmeOyoZfZbSR
         j9yDeXeQnoOBjsF89f/OatXjP8bLEtA2KcRkSFgzPpsuZBDEvTWDzIzTWurNRD74oTgi
         jTZnkHCgHD+LjXua5fAyY4IObqmkzUtNpU+4bNfcpIbjVP8LwffloquvVJhmL3zPwrw/
         g/qGbUf6yyamHe8zsS0N6j85fxo8Ujx7CcDcoFDiVKdyW15drZrvYwFA2L4G9YRb6Zdt
         EAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747937191; x=1748541991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egdJflRBmmuE1AnATRR+AKgbnICiGADQnaXxcKCGu7A=;
        b=Zdzgha1SimB567ex8YqtGf4J5/jORHeKy/CmVAL4CibcAQL3LGHOqx+FSCOxlJJQ3Y
         yVTnOsn/MaVSGuXQhDCpLylf30kYEtLuAbo+20yrm2tANN/3JzXOBR4NZmBEJAD3Q+1F
         GJ3FPYbCC1tyfMRITdV8S3T7AfXpYvzN/hGUYiPYcoS/plZdV1eOWwZE4TnYLQT4Yrwi
         k8CLlwTdyc2ZJsv3gL5SmUsW9W9rR6gPFSbDY3DFG8W1Eym+AJjFhxPs62QYkAO3pGHc
         qFh4aOnX6OAzo3FTcnWqwQDI+KzB6Ux84/B7/TL1TD48SpHfLq38kU72vc3AkumZOvTN
         GgcQ==
X-Gm-Message-State: AOJu0YwcGjBUTztjVTokXyMc2VxnUU3ELQdJ2najJbCUKoD28ER5Y3yI
	cyq3HlOiUJJtzxlUehDt3j6pNhYvfqOYnBxV8yGXRO2F4333OGKA/tmUlNTJKsLMVPgRzPNhlFI
	m7OBS/A==
X-Google-Smtp-Source: AGHT+IFf2nW0YeWspiaZpD52+klhe1Y1/os4fO9+/xoNTczxZ8E3/lhN7bUPZD1ezQfPFJGEqi+KoWVKvig=
X-Received: from pjbdy5.prod.google.com ([2002:a17:90b:6c5:b0:2ff:6e58:89f7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c883:b0:305:5f25:fd30
 with SMTP id 98e67ed59e1d1-30e830c515amr38836348a91.4.1747937191700; Thu, 22
 May 2025 11:06:31 -0700 (PDT)
Date: Thu, 22 May 2025 11:06:30 -0700
In-Reply-To: <20250522005555.55705-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com>
Message-ID: <aC9npqQAAdowxfsn@google.com>
Subject: Re: [PATCH v5 0/5] KVM: x86: allow DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM passthrough
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Maxim Levitsky wrote:
> V5: addressed the review feedback. Thanks.

I'll send v6 later today.  I want to include the TDX fix[*] in this series, and
hopefully we can save some back-and-forth on the series (I want to get this into
6.16-rc1).  My plan is to shove this into a dedicated topic branch by end of week,
and then send a separate pull request for the branch sometime next week.

[*] https://lore.kernel.org/all/aC0IwYfNvuo_vUDU@google.com

