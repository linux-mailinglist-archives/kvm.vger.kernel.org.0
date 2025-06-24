Return-Path: <kvm+bounces-50553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F6BAE6FFF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D33F3A7F58
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A022ED145;
	Tue, 24 Jun 2025 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nePFoL33"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283F22EACE9
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794176; cv=none; b=ObOUVyyNQkazJbGSPcXuCTBbtE/eFj0QMgNKlAYNlNXCtN4OJLtpWks7jncvcjFrhkOy+p9s+1BFDJZwQ904e9r+P8G22mLBVKgwFSQpOxt4oG6yzvhLWUyGqAUFFWOPEoi+1kxVTzqTaky4/hLPFz7XfLwPZqE6fsEigVCz+08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794176; c=relaxed/simple;
	bh=dO+dW40LtZuSsCWa+WBV8jzzSSO9iLzEYTMbtOq+Yv0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JgowJybyAuf2HQT9oPv+IzqX7o0UGJw8Kz/2WffaOYgyFd2/R6PknVsUgACxDTgVUbwjcU8Bs01IFtNTUJJh5PUdPRZAysjxm/o5jDeHAwL8owTOWmbTDe2QrGyfAiRSvx6Op9kgP5aLAAt2Fxy0zBqqmmMNCAlvDcnctibnAVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nePFoL33; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748f30d56d1so286086b3a.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794174; x=1751398974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X4quOVy1erD77eB7GtW5qeTK+/ZPrDIfGhJB042CiIs=;
        b=nePFoL33G6uVLy4L4SnqvCPgpeqyNgcL1ot/cSdZM6Xg6QdwkT4QxEtonVL6LK1Ziq
         sVr2SbQsAHU1gfdefI2vKnUqDbx5+GEWGIFgp7+3gBd0OkKu1PIKQ3khkOQmgD569j0Y
         RLrYwnPh/MwLev+6lX7tvavfiyYJ1Cg4oYgufh1ovHgNpw2UBkfjW4yzn59T2I1bCe9O
         BqZOT3KhruQT7dYsEpAcMIqjOQO8udEFp8e8fvjI0KXsINa+ovuI/VGnjRLmorh5wvMN
         0VI61dmToczMUdXZYrlvzP+9pw4STOLd43Sd2xIYz0R8MKXCJg6FFOZ3kuGrFqgXLYt+
         OowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794174; x=1751398974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4quOVy1erD77eB7GtW5qeTK+/ZPrDIfGhJB042CiIs=;
        b=i4343UPkzSchTvUPovQwoIfLRVjUtkmWS2LyaNxveTplbPkASKJG8+zROwpTl7HTyG
         Sb7C8CsxIEQBXJ82fYy9c8ZtZBgOZZgKOYbPJmTtdMA52N6bU7JzGnMVQR61/JwGwF2w
         iS01zyFCN5URworlb7Bc4/wU8LXC1X3F2cgNO8pnCTRrX7mUKaxthKBEyoEJKkS3aVra
         Qxw28YL5GmbFvQy288MKUyzQBIz0Pig/PeDglhOuSYXZjEKB6Ln1MxtOEdGcErD+OVqH
         ZzP9HZf8O74yur5wCWIVOm55F/flzJ1/HTAfdwcs9FXgvw/ScP8Vfagch+s54Qc7/s1i
         tW8g==
X-Forwarded-Encrypted: i=1; AJvYcCWgMTlJn0DM5+VNB1zlfemVJ7WVGnLoouybVNNPvn+JK/wGCL3aSKzUsHzuQbv4Sa8yrWc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7NMRG2smEUvwwBzPhrjBuG7EoWvVHVKy4ld/rFgy6QXiwzxld
	hvjHWgo4I9AI7mVzzlx6jcWGI0XnsuoCP7EUHVAq3cFbQDd+F43cBlDZhRv9NqdEDruwjG+vwn2
	9dIuCtQ==
X-Google-Smtp-Source: AGHT+IFPp/7TrD3168GEkS3WDBIVg8N4ZeR3LrjWM06mZPH5V7T+xiSLPv8PGV346ZTlZS0IgYMMeeAwzao=
X-Received: from pfbde21.prod.google.com ([2002:a05:6a00:4695:b0:73c:26eb:39b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1443:b0:220:41f6:7a6c
 with SMTP id adf61e73a8af0-2207f302f0cmr351194637.40.1750794174645; Tue, 24
 Jun 2025 12:42:54 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:45 -0700
In-Reply-To: <cover.1748553480.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1748553480.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079224437.515260.14294578957654984603.b4-ty@google.com>
Subject: Re: [PATCH 0/2] Remove some hardcoded SEV-SNP guest policy checks
 during guest launch
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 29 May 2025 16:17:58 -0500, Tom Lendacky wrote:
> This series removes some guest policy checks that can be better controlled
> by the SEV firmware.
> 
> - Remove the check for the SMT policy bit. Currently, a check is made to
>   ensure the SMT policy bit is set to 1. However, there is no reason for
>   KVM to do this. The SMT policy bit, when 0, is used to ensure that SMT
>   has been disabled *in the BIOS.* As this does not require any special
>   support within KVM, the check can be safely removed to allow the SEV
>   firmware to determine whether the system meets the policy.
> 
> [...]

Applied to kvm-x86 svm.  FWIW, I'm not entirely sure I love the idea of doing
nothing, e.g. it'd be nice to enumerate support to userspace.  But adding a
bunch of code to regurgitate information that's likely available to userspace
(or more likely, the platform admin/orchestrator) doesn't seem worthwile either.

I'll make sure to flag this for Paolo's eyeballs.

[1/2] KVM: SVM: Allow SNP guest policy disallow running with SMT enabled
      https://github.com/kvm-x86/linux/commit/9f4701e05fae
[2/2] KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET
      https://github.com/kvm-x86/linux/commit/24be2b7956a5

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

