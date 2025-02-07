Return-Path: <kvm+bounces-37601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB42FA2C75C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D2CE168D6B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 15:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3B81EEA23;
	Fri,  7 Feb 2025 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B35xr2iG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E0D238D26
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738942663; cv=none; b=J1OD+DXFmsJ2609r+15wQeYhlc4V2KhQD2MuPk6BvJHAPdt981sCSgbGjV00C33rCzdH44eumwR3agrLQOGUb5NHeOA50HvN1af84G8p2sbrmRynT0ne4iJrm9zepgzPrdi/ssUx4A4Dvlaetdr7GkoVVrC3CdrPkPkIPy1bnEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738942663; c=relaxed/simple;
	bh=8qEGyB6V2L2T+Ub78mdaZLcdSoUfuOlyT7jtkvOsp8I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UMMq6YiFMVbJRNPVk/MC157TmTYP1zJBHlU/yTXekw0tcQJBKiCXC3EjzONkKxMvUth96ApHkX5s17YOjLLOctPzBhFkQ4aMKTUQ6pUr9OtWNa1OQR9nnPHp74Qoi0uNeAme5/1mwRWgIUUi7E9BAJTQsvM0VnHot0fd+mp2/vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B35xr2iG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so4720038a91.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 07:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738942662; x=1739547462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwYTJjiEd1pBTulC56b0xIusdB3gOsGMSwp66kj31EA=;
        b=B35xr2iGgdHuxFz6oQfkyFNaYlVvvU2+EYI//dq9ee54zScQdVKl0/eMcke3oMdxtB
         KOTvTvG48bAaIubSJ9w/PGKkpeMeBPY3bj2svZx2UGT5CdYjFDwHSgMdVCZdKd3tCMSC
         u9aDURkVK6fMyG8EddSBlIML62vUdnwXQ+Ci0ZPDyGrJhcl7+bMOOJl+IaUfrDKtou+c
         aUEhVDN313h+MsMlO0nXl4Nd2Rzt9LNmx7EZiDCO22hkqaZMH8K1tOPT7X4/tV5enjru
         l+HpqoMD7Cdk8fe8M4mwwBPflg6o0pWs9ZxfSfkMvVRLkSMEQ+AAa3+QLi8J8VRnwkx0
         COJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738942662; x=1739547462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwYTJjiEd1pBTulC56b0xIusdB3gOsGMSwp66kj31EA=;
        b=UG36NcB4U7AU6KJkuSb3hcEKFbWpp/9kiTZTxnJVaKF7FGyNF7eIHqftTbD3wtLr/f
         HAvm8uuegiIJlaeTjoowy5stUVhk2j1OG3aLq3L/Hhq/IrjjXNyqyMPhhUSR8/Fh0TRR
         Pweh4E0TAVfJThjyZrdAzKLXta9djNAgQLRbYZNbgjZlW5QiklBcy2EkLNrjGvj5RP+w
         Y2R2nC0Mw8AdIz8MscvahBMPt1q6uwcrgLqpwqH9nAeqyUVYERyJC9mTGHPy8wiZGMYE
         0X92DXJwE8LlV6/1j5usUbNJl+A4nnpcuFkeJxJqwm9xkAfQg3tv1b6doTdIRlcSYJuY
         v/kw==
X-Forwarded-Encrypted: i=1; AJvYcCX3MhgrluO+J48V1/7yorpLBAxS6kBZAgURqCCt3xtG+2FQeqD3KTi4NnwYk4zEO/DwRLg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTw+8pwyP4MWbvjD7QrT7uDqaU7+hPOagxNZdnpWkhAxhrLMXB
	wAUopA+uDz0o+ONhkrLTZL0OIeb2GGVr0gQ2ob2BJsjDEetYEUCq2n0DTW52sTs3XX7z1D0mEcZ
	E3A==
X-Google-Smtp-Source: AGHT+IERa+Rywv/H/txubJQW0t0aFsR0oFzWrZg8x4V2aIf7jDbMtfwdY1UmKxioAzFzmBb+WHSzh3ryuv4=
X-Received: from pjm4.prod.google.com ([2002:a17:90b:2fc4:b0:2ea:5613:4d5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b44:b0:2ee:cdea:ad91
 with SMTP id 98e67ed59e1d1-2fa24175d63mr5586623a91.15.1738942661522; Fri, 07
 Feb 2025 07:37:41 -0800 (PST)
Date: Fri, 7 Feb 2025 07:37:40 -0800
In-Reply-To: <20250207143724.30792-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207143724.30792-1-dwmw2@infradead.org>
Message-ID: <Z6YoxFOaMdNiD_uv@google.com>
Subject: Re: [PATCH 1/2] i386/xen: Move KVM_XEN_HVM_CONFIG ioctl to kvm_xen_init_vcpu()
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: qemu-devel@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>, 
	Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Kevin Wolf <kwolf@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, xen-devel@lists.xenproject.org, qemu-block@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 07, 2025, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> At the time kvm_xen_init() is called, hyperv_enabled() doesn't yet work, so
> the correct MSR index to use for the hypercall page isn't known.
> 
> Rather than setting it to the default and then shifting it later for the
> Hyper-V case with a confusing second call to kvm_init_xen(), just do it
> once in kvm_xen_init_vcpu().

Is it possible the funky double-init is deliberate, to ensure that Xen is
configured in KVM during VM setup?  I looked through KVM and didn't see any
obvious dependencies, but that doesn't mean a whole lot.

