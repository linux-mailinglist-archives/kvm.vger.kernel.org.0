Return-Path: <kvm+bounces-37268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4368DA27B0D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82F493A32B5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F1C217658;
	Tue,  4 Feb 2025 19:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TwS1otwe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE7216D4E6
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 19:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738696833; cv=none; b=bFFP3hVtnCfuRRu32N0SMeIIUFqfmzR0TCPHlfIYo3gyjIooaURJk7v3Hi+WWjEqLwM0s4en795tScHHHaBsTlaO+yaOQHg0S9m9Gvw4kQruyccJijQf00RgBtoPp46tkncRpT0dc/6ZZNBveUDcry21ci2Wu+Hc1WZJV4ZFtso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738696833; c=relaxed/simple;
	bh=mNmyy2FC7XgMiq0PvTt12e4c9v/T4bfd1z/cjoQD4gc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=av9jxehYVfMrUiPCEeQihXd4HanhGSxRs+yOdDVC9JfymZ7VYBN6VmfCAas90I2Zq3ZfiinmX4mxe61UsxhRvKU54Z4hStU8DZ2+q2ZJZXHIdNFuRm5CVmfN3ic+5E0qhhXsdmcHZb3BnWiiystXnN3z9R4jL7Ff5RiX/L+IKYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TwS1otwe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f09d89718so13043475ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 11:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738696831; x=1739301631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUD5D6UHqdEbzKicnw4Hmt6GFZr7yDkVb352/NUxKMI=;
        b=TwS1otwer8rpHAmg/RjX+h0lnvxRRDGP7Be+CJ02Lf8wu0a0uk/JdQxjeSho9oAtX+
         +nb2WCGJgAXnWZewcaEwPsB5EeQWHu9vTwceVrdrz6jJ0KeoPVvTiLaizttfz6G/n7vY
         0ZGPXQA+Om770oP36iO8lP67xEp92GouKZagEZIXJck6HojglUKPt+QfMRuoAryns5xb
         iXWUykGrbFfpy5FvqJ5o0vPd+tU11I08zehhE93o2iun9mWRtIDxDiajZLdYK23im6lY
         TZGWHHzVPyarXT4Y09ZmSG+650XH0MT988K8rdwZM9a1c/jra0oyESQu3W0Efco8ohgT
         lhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738696831; x=1739301631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUD5D6UHqdEbzKicnw4Hmt6GFZr7yDkVb352/NUxKMI=;
        b=CuMUSvcvGg2r8T8gnffn3bWMfPITuK4VDJKiJ7MRMDKnlo/bc5Xptz/P01NtebUVn4
         PoenOnXaACXFq5ORkvxRl6MyUR5o/yBwioyFg7BKOqQvthfGQhBkjHF2193l04dnWrZt
         8b108quY34O6LWaK+ILyU4T6VmoXLomplN+tpNN0rZOM/U0EHUXyZdg/1bLumlecGww2
         v1xt61SK7Yjb6NuzvrRmxwGeNlE2BL6E6J9CnK572UuxClEgc4+Y9P2W3uJccKDFzza+
         U56T2j9/J4rK/bV7FHqNtSPqPEPKKGglTgRj6Orwvdw+nUyGG8SiTzRxbbYyR/fNyM3V
         A4HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrOqPapPzfo6AbhryPFyJf4A/dNNskmDj2O6GzA3PABc+7QTqNWPemLwapTXg91ZwECrs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5hNL49KKO+IxvxL1Dcwcr0AbbdHkggR0Vqw8L7u5bbLU0jgiS
	PiMudmBU7uEJvH2Sox+lZbnQP02D0lgU2CVLDc40n6skVrfWbUv41gTk1MdoU0X75yMdhsjnqxu
	NBw==
X-Google-Smtp-Source: AGHT+IFkYcHYXjwN2gMXjbGebXZATW1D8knfX7+cOFw1VdyyvSLQlNY59tpvaTAXzOjAPDIhMoM8ZWEghug=
X-Received: from pfkq14.prod.google.com ([2002:a05:6a00:84e:b0:72d:50c8:38cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cd93:b0:1e1:afa9:d38a
 with SMTP id adf61e73a8af0-1ed7a48c85cmr40943657637.1.1738696831536; Tue, 04
 Feb 2025 11:20:31 -0800 (PST)
Date: Tue, 4 Feb 2025 11:20:30 -0800
In-Reply-To: <20250204161336.251962-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204161336.251962-1-pbonzini@redhat.com>
Message-ID: <Z6JofqPQNkcfHFy1@google.com>
Subject: Re: [PATCH] kvm: x86: SRSO_USER_KERNEL_NO is not synthesized
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 04, 2025, Paolo Bonzini wrote:
> SYNTHESIZED_F() generally is used together with setup_force_cpu_cap(),
> i.e. when it makes sense to present the feature even if cpuid does not
> have it *and* the VM is not able to see the difference.  For example,
> it can be used when mitigations on the host automatically protect
> the guest as well.
> 
> The "SYNTHESIZED_F(SRSO_USER_KERNEL_NO)" line came in as a conflict
> resolution between the CPUID overhaul from the KVM tree and support
> for the feature in the x86 tree.  Using it right now does not hurt,
> or make a difference for that matter, because there is no
> setup_force_cpu_cap(X86_FEATURE_SRSO_USER_KERNEL_NO).  However, it
> is a little less future proof in case such a setup_force_cpu_cap()
> appears later, for a case where the kernel somehow is not vulnerable
> but the guest would have to apply the mitigation.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

