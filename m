Return-Path: <kvm+bounces-44371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96832A9D5A9
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D02BA4C5F53
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10252957AF;
	Fri, 25 Apr 2025 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+DQ0tSt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25F2951DF
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745620652; cv=none; b=g7BF8SfUflKc/MLMA+Cy4ulKD/43ILdX/BB+knblQFHM2tS0nYP2Pis2LoW+zOx7jkG3ExO0yOlNdAyCg4y9DIs6O+uofW7WZx2xdC6lKiImRgw0UlmP1ekOf3+1V+dLDpAzchR2bfbqZZqdO2EnTM4W5/KwiUFZLu4WPQi2ETc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745620652; c=relaxed/simple;
	bh=3KArTu/2RUkabCmBtv0e7fMu9ZeDP06C6FtALBblSxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kUJ5qxifoTUuWqktrcUuE2ZeaatPz/ctcTlhsNgIUPIvpQz0YxDkTCAlIdPVauHcWWjSh6z8eYX2v0suCCYqizbtgnVXipb7q9WYT0RDoQAH2w1w+dfQdPfHPyIQMToBvuRxFulzv4WpcKVNYdHj0m41bQSIuKxqbcKmAow816o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t+DQ0tSt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so2183969a91.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745620650; x=1746225450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4wtD+GeTJ9u0QHb0+YR6eCa58uhDG2aJS2glA/Qc9l0=;
        b=t+DQ0tStN9s7v/HazE8xr5ZnphR2BzFtr+Dk4ApcPzKxpnLTwi94rAtfg4jkgap3oN
         f2imSHiCqfvIf/rVX1gDlkMIs/5cFsrh7ayV7jbwXzE5yxpPyk8CxnbeNWp4g6UACvIH
         PAnJMc5mQubHaW3MUbZu63I5RZ5VZAdmBc5rhTWXjrD1FimC4HSG5wX5dRSyT1BqYX5l
         bakYB3oECrnb67N3+wbb2GqdahyvISq+4jCINFzPc+LVekX1XeRhvai5F63l3SW32IiG
         mqLa5hY2h4iPb/A/ydGnBCQtCSZzmdkh/fsBNydX0RQmyFB37nJrWJo01wMQ0AS1Xxgu
         HQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745620650; x=1746225450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4wtD+GeTJ9u0QHb0+YR6eCa58uhDG2aJS2glA/Qc9l0=;
        b=VscO0XcO6joi/t602K6E9hhEuKmfAq370NuvzUu79zMqX/BaujmqqzYNEVbu/C7SWs
         ySt8fT9HdIWqIIILPFNMdTNxYXki9QbYiCTp5XdKFoXpjc5UBVJDG9KWYe0kZRHW/cIe
         cUtuiwOLKaqlofMvMWDBeE5ZchK4JIM8lz7VyHTqrXfFvQfoTsAhAsr+F2wwcD0sfqTc
         UeP8YMMRWfRH1FO6FxDYkOM0wj3RNDMUOhzESh321u8NKm/+BmOfDNqxdZscqVcj0pyf
         YFgfQqyVL2Y7wzeWn0azkIyB18odSTT613/H79MBG8M19UvFGCr7rxb/VVejHUFL0P4d
         +rLQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/KKefX8uTADPElHa+VUhrOw2Dgzr/EQqPhlrmC9Vz66bFtWchE/Ydz/AO6Tr4gmawCzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyncuM/kIdNC5PpYTXTqIVTyTJ+ojdpSgaJo5CLy4WJqZcfjk4r
	IdRMJvoE3HtoT6iHzCqEN6d9f/4omsrqi8/Au01OgcNnbuJTgJqGL46GiUe7HjDZEFSku+Xp5aQ
	p5g==
X-Google-Smtp-Source: AGHT+IGgiNwVkXSP9zfX8Bwz9AFDrYnzhJff3zo34deIREPzgpgi0hqQsE0ginF6C31hQ2DJIXsWXGg0zEc=
X-Received: from pjbkl16.prod.google.com ([2002:a17:90b:4990:b0:2fc:201d:6026])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2810:b0:2ff:502e:62d4
 with SMTP id 98e67ed59e1d1-309f7e8ec70mr5160431a91.32.1745620649938; Fri, 25
 Apr 2025 15:37:29 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:37:17 -0700
In-Reply-To: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559612575.886958.13255435526046364721.b4-ty@google.com>
Subject: Re: [PATCH 0/3] Unify IBRS virtualization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, x86@kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	David Kaplan <David.Kaplan@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Feb 2025 16:33:49 +0000, Yosry Ahmed wrote:
> To properly virtualize IBRS on Intel, an IBPB is executed on emulated
> VM-exits to provide separate predictor modes for L1 and L2.
> 
> Similar handling is theoretically needed for AMD, unless IbrsSameMode is
> enumerated by the CPU (which should be the case for most/all CPUs
> anyway). For correctness and clarity, this series generalizes the
> handling to apply for both Intel and AMD as needed.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/3] x86/cpufeatures: Define X86_FEATURE_AMD_IBRS_SAME_MODE
      commit: 9a7cb00a8ff7380a09fa75287a3f2642c472d562
[2/3] KVM: x86: Propagate AMD's IbrsSameMode to the guest
      commit: 65ca2872015c232d6743b497e3c08ff96596b917
[3/3] KVM: x86: Generalize IBRS virtualization on emulated VM-exit
      commit: 656d9624bd21d35499eaa5ee97fda6def62901c8

--
https://github.com/kvm-x86/linux/tree/next

