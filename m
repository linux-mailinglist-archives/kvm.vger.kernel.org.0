Return-Path: <kvm+bounces-68228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A0DD276B0
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A47F8319D0AE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4193D6055;
	Thu, 15 Jan 2026 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vZRbbKIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4609F3D6046
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500426; cv=none; b=nwHWr5lEpUIqA8nNhHWS4mV8wHh18yRZlqamzfjsrWGJbMTd1aUD0gvPqSYdf6MQvC4n+rd0uww7SGrJa1xhUprxoSI/1zB9tptecafPKorjGFnhqHzi0n9PXegPzFzMn7b8fnm2NgZ4sQoejVup5mGLiHGqEM1NjAkuhvP6WZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500426; c=relaxed/simple;
	bh=i5+1/Qsa02xgC7Sf+rEcgx1r6GniEdhsqrbook1edTU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YW9fuIo8+bTtKB1hdSd7QE97IcNmM61fdXJzU9L+xtku7RDj7vd70XSQ8lTQZY5TT+jgOjYhXxkgpuEvqD7PX/GFYGegIv2vT2ETO8HloS94e3YIMEvhn0NeCWQU1nwH+WgepHNOclll+J5EevLJc39Rje1M92MCh6bH0xfpxiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vZRbbKIJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ec823527eso1802812a91.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500424; x=1769105224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N/82cpt0Uas4F64KP8DFk8U21kh16fYHAGtRjudiizI=;
        b=vZRbbKIJTJKWPoSi1DmBjhQQG4a5D5tT+jB7UD6nEM8449rZJ0eh1XxPpDVtFtbKSL
         JXsvdhFbx/121gkLXp/AUlC+mRj7J4XwcYy9ZN5Ov+k4Cjl20UZsWAHtLfi+aSbyTPS3
         Dgbq/lXFl9tOKJNcugw9ukHqgW7ndmOsrO9eJnXPv4uuHintc9Az2Gd0cDSK/0KPrdu+
         8LmML6IFFpGWR89Ok0FWpABNmwA72BNBDh7cna8yrTfQwHGQ5HpL7UJB9QexAjhkOv9j
         /H0mMJlT94+CFKRQeR0JgEV2ZwD1ownxfTJ0GidyijJzvrczQ5ajn1BrnkY21p6xeNVi
         2zjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500424; x=1769105224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/82cpt0Uas4F64KP8DFk8U21kh16fYHAGtRjudiizI=;
        b=ST5yW9+BUlj0l9T8ZLQIm7hKSOVjBHT5WPamqWP/up2IIMSAB9sH029eC6hmInBpBu
         oVeclhPz5ICfDAob2OZXPMwXY4n1rdMSiyWIAF2KDRR/VzGMbzPa+VfWAzR5Sde751Fj
         izkwgMT8XpNLkM9L1gsiYfmBIcAlpCGf+7RaEg75MBtQK7DpsCCkBrKYIxPxxBLN0Ri2
         nJ9PdyHCQEzH1F8qwcGU9YJEjRVRpJKsKmvzhsLiulCpxbZDFDAU48enrBwdJhXy6ZTn
         9WTIQni9VAAGIu/DV/Cm3BwzmmX8CwJyPg1ngQLj0so5LKHLIvS3Ai0D3YwUG0VB4rH5
         WfxA==
X-Gm-Message-State: AOJu0YwvyZE1ym0qwFmR4mbKvsZ3Nkc6Dx3/2fVW0IDDY2yoU7r0VZAo
	07z4CC+UIvZC6sGqrdPWbC0yWcHjaltydxVmcDrhiL/fDeyGSOR6ANRiVNC/HJT4ryRaXawF7Yp
	kSXoOhw==
X-Received: from pjbfs21.prod.google.com ([2002:a17:90a:f295:b0:34a:a1c5:9df9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1fcc:b0:34a:b8e0:dd59
 with SMTP id 98e67ed59e1d1-35272f1253cmr243948a91.15.1768500424577; Thu, 15
 Jan 2026 10:07:04 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:36 -0800
In-Reply-To: <20260109035037.1015073-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109035037.1015073-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849887444.718912.15225828841384052421.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Fix an off-by-one typo in the comment for
 enabling AVIC by default
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 08 Jan 2026 19:50:37 -0800, Sean Christopherson wrote:
> Fix a goof in the comment that documents KVM's logic for enabling AVIC by
> default to reference Zen5+ as family 0x1A (Zen5), not family 0x19 (Zen4).
> The code is correct (checks for _greater_ than 0x19), only the comment is
> flawed.
> 
> Opportunistically tweak the check too, even though it's already correct,
> so that both the comment and the code reference 0x1A, and so that the
> checks are "ascending", i.e. check Zen4 and then Zen5+.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Fix an off-by-one typo in the comment for enabling AVIC by default
      https://github.com/kvm-x86/linux/commit/69555130dccb

--
https://github.com/kvm-x86/linux/tree/next

