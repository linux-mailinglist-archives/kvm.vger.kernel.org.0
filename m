Return-Path: <kvm+bounces-58073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5748BB87734
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B35E466C2F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9A778F5D;
	Fri, 19 Sep 2025 00:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eL8KQv8P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C02AE89
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758240674; cv=none; b=lJ+wvgdSvjDt8UG2MMvH24aVQRM5PkvMvlpyKyQTZC6q8vFCd0ze4NAvqZUIY87LfKG0kZ6g7wMTPWK4SZZbhqNrmu2BRQiArNWj2HDtaSwTWauOXPWkxoxd0xhrx8svZ66txjy4QJDRqOSQ8Fxzv85pMsR9xzHIfIGTgAMPEeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758240674; c=relaxed/simple;
	bh=5kZbjwa/6BVoxn5wegMROAiVV9lXMCurcroc08yFVco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jnfi0fc7ixq90DWxRr5sjOQ3nsnLQZhmKMvNfx32Fl98sNVW1UADhe+pU++xKz1R85LCmtbY11E2zWygPsIwHV6gfknfc351knwQU4EgX4XTsLjbSMnRqqCOjLCM1EuMn4KZ0QSRPO+ZHXoZIFoqdItmQBFz5OXT3oUwICPG0oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eL8KQv8P; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so1552365a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758240672; x=1758845472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDq+VavY2pE4pyHZXsVu7LM0OhcCfDkB6zYweV3fNcw=;
        b=eL8KQv8Pstu8SY7UNwZbUO08qZHz+zeR7DquqpSOJDAHBtzGIC6g+cleyHShEfubb6
         pucUJRKpSR3mBhJFG7YBfaXDLSy4Qi5NQUZ5Ku6GjJjKW1A78e23OBBwtFOH+avA+S1p
         6aydHGj/mTV5nIEXt49JmK+zjQ5vEDsTJCvQVuBFJWhqrmtFk6u7r5O2yFOTYXI3+SJv
         lOPjOstzBuZ3wDNDn6y5bAPpuluaRhikHKAF8gjDWl+l4he0fNOnJBboFGzn7Qw2W8Oo
         LFdELRU493AOlsY9+oVqsartGnLOOiKQ+4y40Dqt2ZC3kDsYs0lUYQXnLr80qFRjWg3J
         xIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758240672; x=1758845472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WDq+VavY2pE4pyHZXsVu7LM0OhcCfDkB6zYweV3fNcw=;
        b=JHge6Kxd5gkoDQyBqTDzoHTldEUdszpRhJ1FttkTr8XPvsrtl/h42iB4R1xGgDZk9G
         wGM+JhGCIXFuswQJWnqbSBO6m2N9ZrCvAd+Sslu2xnw1PSG2h/G2evj6aw3KOwg2xfWe
         l4tVjIaxcCL6D3vY/H0RugvO8q+HJmIOzCQ6Jm8i5N7i0PBBI27hxg2WOdhKUs4iA/qV
         FuJPBKVB+GgfF46cBotseVnogh9u/Y6+4zyPIOoCKv9GOT9mSd9GATeaNWplGXGQJvJM
         JGZ/4fGmy0sFhNCE/kRWaGsLJtthqQoZvbq0nerUzpbQxxP6KK2clYTrun5cAJrpMOpW
         6R4w==
X-Forwarded-Encrypted: i=1; AJvYcCV0iVGE5qcxV7Ci4YdFPQepfzwWxFCCByVrP7T205zwLv2WaIpu2oCBh1vsB1Dv20kChaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtO4JPq+5T9im7gDVCx0XJd6Yrn/SGNGG3iMj3uJUVe2udLLIv
	an0EZ/EvGozUB00FVh7WlH92Spdbr/34t+qMTfm65PvBflic+Ho3JbtzhshHc60MbsVdd4qIUyO
	JcHSaHQ==
X-Google-Smtp-Source: AGHT+IH/rnw53WJfJ7eWmpB7rOT94jvdcHNYPMI0N+5Kli3XKXZCk6CSFlJKKvZxXUFlpHPnz2Wr4v6yW/M=
X-Received: from pjbpl18.prod.google.com ([2002:a17:90b:2692:b0:330:6bbd:f57f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8b:b0:32e:3552:8c79
 with SMTP id 98e67ed59e1d1-33098369dcdmr1600058a91.29.1758240672393; Thu, 18
 Sep 2025 17:11:12 -0700 (PDT)
Date: Thu, 18 Sep 2025 17:10:48 -0700
In-Reply-To: <cover.1755721927.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755721927.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <175824019789.1343495.7167726134042080248.b4-ty@google.com>
Subject: Re: [PATCH v9 0/2] Add SEV-SNP CipherTextHiding feature support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, corbet@lwn.net, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, herbert@gondor.apana.org, 
	Ashish Kalra <Ashish.Kalra@amd.com>
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org, 
	michael.roth@amd.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 20 Aug 2025 20:49:45 +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext
> of SNP guest private memory. Instead of reading ciphertext, the host
> will see constant default values (0xff).
> 
> The SEV ASID space is split into SEV and SEV-ES/SNP ASID ranges.
> Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
> into separate ASID ranges for SEV-ES and SEV-SNP guests.
> 
> [...]

Applied to kvm-x86 ciphertext, with doc and comment fixups.  Thanks!

[1/2] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
      https://github.com/kvm-x86/linux/commit/d7fc7d9833f6
[2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
      https://github.com/kvm-x86/linux/commit/6c7c620585c6

--
https://github.com/kvm-x86/linux/tree/next

