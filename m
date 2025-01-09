Return-Path: <kvm+bounces-34951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1494EA080E1
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D96B3A2009
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417221FECCE;
	Thu,  9 Jan 2025 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K7WuMsnN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE171F4293
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452290; cv=none; b=ac2auXDapEh/iE5d1ZZbecNVgs+egKi92isRmabBeXeu4HgMIb2NXATImzR2X25IDztkYFDOvbNNrpTKMu/rc/L93kZB08BvcvN/GsAIm++sD5r4EpK78KYdhE1gYLzrUZZgzkRWea4MU0jjWMy4gs8LC7Y7ZHpi/3tDviR9mFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452290; c=relaxed/simple;
	bh=MvkEk3gSSDbS3zZPJLdX95x01W/tyUYM4PAuF5w5OC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S1KNYbLUpMUT3JpV+n//NVjHFl25XTbPRI47xDRJW++kAqqi6Nx+TxvIyfFlEYpzggGZq5mVTUVh48QkbDRahcrjnuSDyRNdUYcFMsM9+lPtz5BW4fIGTDyGkULlc249ptVcp5ntJvRyrVBNeUGxM+kUvITf1rz/3Z8OCfnFiPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K7WuMsnN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee5616e986so3277035a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452288; x=1737057088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=57Etux7AEN5TmMsdcxvDpSx5a9gpJFGTs6viFVCrUcc=;
        b=K7WuMsnNJDompEqbNA1fa5RXPm2utyRb6SIEfLr/+bNREHk9zA7VqnM2TvUhUp+2Xi
         7jtSrhOVWl/ef6boCENrXSL8e28+CQcwgCvSkXi7/RTeA+uaDdgzNfEPFs/EMP2PKpK9
         RCsFd9Zov14BXFtQNoyyGrt+W5tf7nZeUMN7Gb84b7pa6JkBEYb0kZfkEsJTq0SWy12E
         OZvjeLxOrWrcCDv8dvr6jogr8yZ4dF/DfxsJruQAYIcwUFQoIz11n29FFdbmT9w8HtlP
         jCyGJ/wHMhPGncGEotRusscwxK/zqxvhuXj/PzpsQakeu5neFuVHrFJ0QXFHPt4TaiTM
         XPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452288; x=1737057088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57Etux7AEN5TmMsdcxvDpSx5a9gpJFGTs6viFVCrUcc=;
        b=nr+vz+AVsZsnnb6z0bqDuDhU4TxlMwAlAKDbVLCei2DDyS7i7ytFSzA4FQZ32z3jNT
         ypbIf3skf7PRnxh3XKtMqR3BfMCp/o1r4fojlnz4zIIYeCiDbq4VjCljwpgXf41ayg4g
         wZeSWaRywnTW//q0z+Iut7J0LfxnGszDSZA79ZF1BI4EbBLCGq//CUB/mNrPEhyPfLuM
         CjAC7oJsKKH8KFxU1m52LtmRayxWoSB5Shh0HZtL18UfPPmrbZrx4hzJhl5vHa3jc6Wj
         jujtIJKWrZYLkYueG1Dmu2n3wCEvr4PuWru6b0ob9YreJUElH206IDXs0Y3L8Gys+EWY
         wg9g==
X-Forwarded-Encrypted: i=1; AJvYcCWz+ELqpPboJ8FdtqfrXa7UkOR21yxInJWOgGLykfUMabtiT3s/9pbFVTLKMC32CB7/Bnc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7OfluqLSIf8lv4Zs1wFgZfZIU+P2slXG4+qfBoJjhfD42kDMx
	7l/lpgk41tXfrCyyu6QSc5gRMJjufm8OpLDsaZCDF5PotM8HMozcF/RBz9e67fBd6Ki7c5R+NiR
	KOA==
X-Google-Smtp-Source: AGHT+IFHDTy4w76td90IJzNaC3o+z6gkD1eeZgoEcbJclu/ja9AI/IqxAF+xDqx17F3s6er+xWr0fh4cKz0=
X-Received: from pjc11.prod.google.com ([2002:a17:90b:2f4b:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c88f:b0:2f4:434d:c7ed
 with SMTP id 98e67ed59e1d1-2f548f34ee2mr12933623a91.16.1736452288677; Thu, 09
 Jan 2025 11:51:28 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:25 -0800
In-Reply-To: <20241219221034.903927-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241219221034.903927-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645201741.890420.7594833670950629627.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: x86: read the PML log in the same order it
 was written
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-kselftest@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 19 Dec 2024 17:10:32 -0500, Maxim Levitsky wrote:
> Reverse the order in which
> the PML log is read to align more closely to the hardware. It should
> not affect regular users of the dirty logging but it fixes a unit test
> specific assumption in the dirty_log_test dirty-ring mode.
> 
> Best regards,
>        Maxim Levitsky
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/2] KVM: VMX: refactor PML terminology
      https://github.com/kvm-x86/linux/commit/ae81ce936ff9
[2/2] KVM: VMX: read the PML log in the same order as it was written
      https://github.com/kvm-x86/linux/commit/37c3ddfe5238

--
https://github.com/kvm-x86/linux/tree/next

