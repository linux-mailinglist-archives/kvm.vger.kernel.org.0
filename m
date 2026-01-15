Return-Path: <kvm+bounces-68226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BA458D276A0
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1A6930DF83A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6463D5DAC;
	Thu, 15 Jan 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxsh6lM7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1100C3C1967
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500410; cv=none; b=U2qH16SxiD+liCe3cZGMa2WjMZmtVivB1Yw5U/IkMZtQ3tc2S9CSpSZWqpyFB6JEMtR9BLBRjljFQPIJxe48A0UP/egJJ4nbRipuhngSU8aBXm1pyhRk58BvaOGmpeXQc8GEa5o8VemTygBx8yJab3JQH7aXlzWEbllVLg9xwu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500410; c=relaxed/simple;
	bh=qZidp7Ban15XHn+Pn/c6id+totAcCUabuR7gWlYuoTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EjFYD01BC7hlqOFSoHzW40lWaFtlXKJhnfOsmp1UWVoGNaf4/d+QakDP769ekZebX6HE6sysqIt7PXbMZfgWqgzsPOPOHLyUQ2RGoPke1mbBxHJtFa6P0kq5F19uSxaNeVyERPg4tzWQXOB06h0LKmuxtp906uvZR1ZrgWontys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxsh6lM7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34a9bb41009so1342268a91.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500408; x=1769105208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vasUWdq2k89/YtglEaVM5MpeBoJd4Rm9t5utEnattHg=;
        b=fxsh6lM7awZXZulOxLBmb7iy5cKEG5B0bHGyvOBl+RzDAWPCU74ewPfy5WuBXayFea
         ABi/KeLR5v0z8GS7v8ucNTX5j7em5VR8CC1a5skxomXS16g5aGIXIsWD2wdUenI0cDsY
         JeJ3ReYUD5JtqV5z5VTJXSDUFQ6gEqhDVoS2KxGNR/7yNc59TL/k3Bm/pqz/g1JWAujF
         b/Vr7AomQ50tazWNPenEqChBqzN3nwQ+ZzYrLhrQK0F9ZWGqQY1nnqqz8/Zy8wMoyiI/
         eSVdNcXcVCL83wYF3zZRr4QiCCDAFbXVtq8/I25cP7utkGFaNYHNG0xMXntN4NCWto2P
         9tKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500408; x=1769105208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vasUWdq2k89/YtglEaVM5MpeBoJd4Rm9t5utEnattHg=;
        b=kTqtBxfluaQiFtSsNqeovLGUxO2QHUIK+l4PNN4PujVgKD7gohdBx+wuC8/juGLav+
         EGeK8Zhs+H9zunYd+2kpetXpN4sllwLKUpi4fpRwYNqwx79cS4yP7HIZYmISvuwua7gj
         bg8Aw5KCFKWDVECOgd4TyCwjkXG9QzK7Ca1OlXnxnqk6knbeTGYjfzRijimzYdflyRvf
         SYWieCp/pFygc2VQLDMDLK/W1t9fGwfUtFDiJG/oUChaKjHgUhExfKza3dDo6I8MXjzL
         WGXqVu1HhcpmeEYpGQw9HZ1Mc3wVEuQ6nqcMFmKQ/KoruBf1xncOFVtys0ug62Ji0h3R
         9bpA==
X-Gm-Message-State: AOJu0YzCVjEGHD/Ps9gzSRinAIb60JdUJzh00ic4wyjQSG5pfVq3ZqHp
	9DKpsKtXII27casmHowdW5KeojCGz724RrXMvOJIWQfdINtG+jllfJwYFThWlXlLIlkb83cub8K
	Z80GAtg==
X-Received: from pjbss16.prod.google.com ([2002:a17:90b:2ed0:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c4:b0:340:e2dc:95ae
 with SMTP id adf61e73a8af0-38e00d5ca1cmr20475637.42.1768500408455; Thu, 15
 Jan 2026 10:06:48 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:32 -0800
In-Reply-To: <20260109033101.1005769-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109033101.1005769-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849900585.720229.17386625201191599754.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Drop SEV-ES DebugSwap module param
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 08 Jan 2026 19:30:59 -0800, Sean Christopherson wrote:
> Remove sev_es_debug_swap_enabled as it's no longer needed/useful, and
> mark sev_supported_vmsa_features as read-only after init.
> 
> Sean Christopherson (2):
>   KVM: SVM: Drop the module param to control SEV-ES DebugSwap
>   KVM: SVM: Tag sev_supported_vmsa_features as read-only after init
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] KVM: SVM: Drop the module param to control SEV-ES DebugSwap
      https://github.com/kvm-x86/linux/commit/9587dd7a7ebd
[2/2] KVM: SVM: Tag sev_supported_vmsa_features as read-only after init
      https://github.com/kvm-x86/linux/commit/d23051f59a5b

--
https://github.com/kvm-x86/linux/tree/next

