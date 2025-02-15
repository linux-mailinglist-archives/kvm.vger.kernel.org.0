Return-Path: <kvm+bounces-38215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD64CA36A4B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60CF41886811
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF741CD21C;
	Sat, 15 Feb 2025 00:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nU2KMg25"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B155EACE
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580826; cv=none; b=K1VeM1ALc6HLXAsvLTKGmmiKxC90KQB+58U5C7ZsLSA1iGd5aQkyUW7c+LXFe3Gl/kb9ZQfPBeCmkqO5NANQiEvC/iRv3Forn7G1zeZySIYp5+axBJFg3+VEW63IZC/P2oWrhEu2OlhivaHyBQj+OY8MIWtaOBI6UwigHuqia3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580826; c=relaxed/simple;
	bh=r4upbXWz/jHR+BK3elm6yyIyLVx20H1k45CXl0DWRU0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=V7m9uF6kGjKPery2zUkgIStsCzP8wfqjMHOS1mhFc2TLbXpGsTWxLTREEo1gziih7+nppgK2DwkD8ahetxuauXEBSiL6senSHYIWSlYyyAHjec67VV6wc2Xu0byqTvBNvwoLnR+CeYDGZI7+mHAT7nAzGpI9XboU2EXD5WVSBsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nU2KMg25; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05afdso5219434a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580825; x=1740185625; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BFcmzJ0i+heVKybi2WQ/QCTEEQ4/aTm12Bn74IUsP94=;
        b=nU2KMg250c2JI2c9jvFBNgXa6858eoDU6e0JDiNa5GWrUtHrJv/hSSDD2umEs5NXAU
         8VdxdKMLQY9QnYUD5OL9ulizkw3VsaUUD8za1Ot8W9/wyoyePH4ZqpLyTuePaqIGOkDd
         UmUzjVsNs48EweoB7KL+IlzwYbERUf1pTIhtIKxaxj5AoBMUM0LNYuGMETt1KBseru4a
         /q7Ek/2cdYJHw0IfroC2ITfGvETmGgvcq2ZYIgTrv4S9WpNbdY43Kn6kv3z1TgEjWcBg
         XZi3xA6Oit2dalDf869BVUi3wXmIbkh9hxZzu6FW0krV8Nn3n6coqZzUHRykpdo5T6Yl
         WCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580825; x=1740185625;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFcmzJ0i+heVKybi2WQ/QCTEEQ4/aTm12Bn74IUsP94=;
        b=JN/UIqS7qx3xql/EembpvHYSXMgEXPVFB7s8sgjVvr39AowzAaEiqWLg0V+D+b5mfd
         /RRvzeNo5tfk/TRQzd9ZHBH36EQr4JPVohC0V4d7oQMsZ8MiMusCPLUXi26p1/ZmGEHb
         1H5Hq7cMzYxgSdyj5NLW+LYu7RC4YsV4C6qwpWJ2pq10AOBKpjit1x4D4bJ2PiOgCawH
         4o8YV4YPSdKJ42w60pODMRFld/hmeJqG18vznxtphPZDtSBbn/djkWH1trehbi3uNktn
         D5rUP/4lR8TutXrcPvSA0U5W6lmFdnbYC716tkLp4/p5XJtPYryA9O4VHV3T2iln5Alq
         +KFA==
X-Forwarded-Encrypted: i=1; AJvYcCXDJ3YWKvP4mmjvImjZEKsD1O3Tq7koud9Nv6c90jiV9R/rEjDoNbOENoiigdPslQy5yI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUGpbemw/cGcZ64tVZbnhnKLfeXHfkzrHbZW/R27PxjKiZfLtH
	8C92VepNfCyxxs/8abvQ4TXqh0PpLZ2zM3OaXSQ48VTqlJ8tTZQQmS+SRQlFqL9KX7hhPqFwDLu
	A2Q==
X-Google-Smtp-Source: AGHT+IGN1wRdgJaTgxmY9eExFQAkm/T4/RvoSDxP5bwSGPAnxCuDU/nufXXbQXJN5CFpgj5o1N4k1ihL4Is=
X-Received: from pjbsi15.prod.google.com ([2002:a17:90b:528f:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b0d:b0:2fa:2217:531b
 with SMTP id 98e67ed59e1d1-2fc40f234c9mr1600051a91.21.1739580824734; Fri, 14
 Feb 2025 16:53:44 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:14 -0800
In-Reply-To: <20250113200150.487409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113200150.487409-1-jmattson@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958021460.1188824.2106156728368699135.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Clean up MP_STATE transitions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 13 Jan 2025 12:01:42 -0800, Jim Mattson wrote:
> Introduce a generic setter, kvm_set_mp_state(), and use that to ensure that
> pv_unhalted is cleared on all transitions to KVM_MP_STATE_RUNNABLE.
> 
> Jim Mattson (2):
>   KVM: x86: Introduce kvm_set_mp_state()
>   KVM: x86: Clear pv_unhalted on all transitions to
>     KVM_MP_STATE_RUNNABLE
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Introduce kvm_set_mp_state()
      https://github.com/kvm-x86/linux/commit/c9e5f3fa9039
[2/2] KVM: x86: Clear pv_unhalted on all transitions to KVM_MP_STATE_RUNNABLE
      https://github.com/kvm-x86/linux/commit/e9cb61055fee

--
https://github.com/kvm-x86/linux/tree/next

