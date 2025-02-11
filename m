Return-Path: <kvm+bounces-37928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D103A318B1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 23:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 808047A22D8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8636D268FF2;
	Tue, 11 Feb 2025 22:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RQSoAZQo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594EA268FD5
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 22:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739313439; cv=none; b=mZteG8nk2yo4x7VIFhJaHQyeNFp86E9L90yLf+4XhDQ5mVBugDtnbjI6DEc56SCMJJ8pAKNMK7gMTT24rh1LCQoEvc85/KtzxQQuCsjlbSTol8Wawy3d2fR9VagqcwvLN7ar0vZ3A1MFfvYAeIIbBSLWR7YYls0CafmKIIrBLEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739313439; c=relaxed/simple;
	bh=vv6m/Ov6/GaERKsDAwou1J4SlXEitnOEW3Eh9DkD+DA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkZfIRl7q392AK+xkG2zLXU21/LwDigF7P1F2XEhhTVt9nA/O/2hkYRnIQg1CVvc/0Gz4US4dNVOKviikbtP5KQFz3CUVhSCeu3DYproykJOtBmP9msAhqreYAFTGV2AAwSJ/Qfg8RHMC+xnK/OVxyPi/QUz+hWdMo/oTgefOm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RQSoAZQo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa32e4044bso9067191a91.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 14:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739313437; x=1739918237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FTsjguzzO+im0HeCEFuyAVnIULtfpweNQE0Dpq4eZ4I=;
        b=RQSoAZQoAR43dBp3O1UZK2dIKd2exR86pBAyQhTGUZe9sw/O9pPQZXvGzugIjsnMc1
         VydKf0yAhH9ODyYKdtDSbEtDIRyH1z6p1e+TkxlVpzNqcUYDh7EnLMotkQgytPi9FnE/
         d+N4yhuWsi3Ri7wQu4ctQ+60MOKTRtocdxCcoj+hxITa7or5UYmsALZrvi4Ujw83GbnB
         JL01hQZdgzehzYGm3jijnn5s5CH2q8p9/zT+WMXZlxvyETyLNg6vpOmwASZ9q3+a9pRk
         ROeLARvMwokhxR32uVIFI5DKqQOYWsLqeZHiQKWAeLkhRHgWy9KKSW9M1cO+nT/khpyd
         1mag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739313437; x=1739918237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FTsjguzzO+im0HeCEFuyAVnIULtfpweNQE0Dpq4eZ4I=;
        b=GcX/DEarI4cQDDJOz6RGmmPoJJENldUISZSTNVsWRi84bcj9P33GCrzo6rvoC7AVXQ
         6jlNMp9r0NcvwqPIhYk1lTxedcex5dsqpItEmOXowVum+7v2mQhA2NyDeNM2WoBJWJjU
         jr94cFef9sRVZUGsStZlceAuXX8TjYOKbD3UAecnrwZNux+YMqQV1avUplGot+RO7GYe
         HSNhiPD+/ftE1SLf9FAPbqYImrCFYwe0+WgzfV+Ru0V+UiRnuvYOXHgNFydgbpUBuU1d
         tV4DIzqySBNnp6nLyZy5peZBtacRygFkGhcHNteo9nEx68djevgxr1Ek9PXqOJRHUYfY
         tisg==
X-Forwarded-Encrypted: i=1; AJvYcCVmr65S/BQyMTxW3lKP6nC9B9hoq4Z0Ad2AWgXbHo6Q2ttJ63GoX4oVhvBUO9DTzklD2Pw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj04OfK3iDP1UxCQA1L8dfUEOgOwhf2mpnxBYDL/XQv+ZdK0th
	2BlIZtV9l7m5DhwIbX6XRCHstZGsOJ3ZpTt+48ZDIBZrrsSuWdeClTq2LGpCl2x4Xj4ZZls3/x/
	kCA==
X-Google-Smtp-Source: AGHT+IG99qq1/gKCDil95STrIBBwGrDtZsitLO+I2Lf+wNkjXr+HR+VzFAe4oSYl54HZNiCeTU4O2XMTd4U=
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:2f9:cf33:f4ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c84:b0:2ee:8358:385
 with SMTP id 98e67ed59e1d1-2fbf5bb910dmr1335645a91.4.1739313437595; Tue, 11
 Feb 2025 14:37:17 -0800 (PST)
Date: Tue, 11 Feb 2025 14:37:16 -0800
In-Reply-To: <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250210092230.151034-1-nikunj@amd.com> <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com>
Message-ID: <Z6vRHK72H66v7TRq@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com, bp@alien8.de, ketanch@iitk.ac.in, 
	isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 10, 2025, Tom Lendacky wrote:
> On 2/10/25 03:22, Nikunj A Dadhania wrote:
> > Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
> > writes are not expected. Log the error and return #GP to the guest.
> 
> Re-word this to make it a bit clearer about why this is needed. It is
> expected that the guest won't write to MSR_IA32_TSC or, if it does, it
> will ignore any writes to it and not exit to the HV. So this is catching
> the case where that behavior is not occurring.

Unless it's architectural impossible for KVM to modify MSR_IA32_TSC, I don't see
any reason for KVM to care.  If the guest wants to modify TSC, that's the guest's
prerogative.

If KVM _can't_ honor the write, then that's something else entirely, and the
changelog should pretty much write itself.

