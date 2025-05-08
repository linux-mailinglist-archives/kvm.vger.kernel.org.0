Return-Path: <kvm+bounces-45994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2170FAB0658
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 01:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B08CA00B6C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 23:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EB3233721;
	Thu,  8 May 2025 23:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2oJsu3Lx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D20D22F3A8
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 23:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745477; cv=none; b=d8oH6SqufUGWRgsGpeOCmuKSxV1fTIrhVU9uBlAuaPpm5esPnnT05ckihBL0ujV9XvXTASzUdCaifVOUGd7kQ/hnycNDwW8PEEGJjMxzLIH4AT2jd0NkXh8h9enjdp2TdA4FeQoYjtTKtHmT9ef8hpgrM6KOJ959qr6a3bc1aMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745477; c=relaxed/simple;
	bh=o9MeEdic2aw5fuiXgCnE5gY7Rjy86uabdHeLWt3OWtg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MRqVeFd3lxokQYTmKknOKOA5WuzTwVJsPX5Qedp36KGZoDrTKkbdcb5BPN2fgE7L5frXyS0fthninO3EGomnajeqNAw6b2/dcCEPRhTqJQtcios1waPp6rB3siXYV4e9u0FA8y3rSPUYBIb2CbcEtknP9DsMZw1fdRH8O2y6e9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2oJsu3Lx; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af534e796baso877412a12.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 16:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746745475; x=1747350275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UFnJZ/RAlcNSP8DZMSaNIf40AZH7y1/ctvuFTqQKpZw=;
        b=2oJsu3Lx5JPxYgcQU4M51wvLCGjfw5SXjg9UWs2cTdZ4Qk8YYLR5D8b4asIdfza+bV
         Qbh6Dx87grn7oTV7bvdf5WZ6iz6o5DX5ztUg2exo0S6mudlrVheyI5u/au4uV6MJKJcJ
         6LGAdRbURQ4bPIMlaJF09hWeREIDBzN7UGg5CxSFtFux4FXXvlpDrePrkpRZpevLtnn1
         wOne0WFc5+YBXCXdAKdtd69Mna3qivHltJc2uBPc8rYQiKrawklJJ3nsvIb3PppoN/s6
         XMF9wIBiFKf7oNQaXu0nQjAMZoYDttzbPRCNaqgksIGfzGIzvbEuC8UbLBcCKmzbaMe7
         TPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746745475; x=1747350275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFnJZ/RAlcNSP8DZMSaNIf40AZH7y1/ctvuFTqQKpZw=;
        b=FMpQasn34PAFn8O2+3obqoQ943LXvSaXcdBb79FAAzw43KlxPpCvbzOAzLGLmW3nTl
         qZ/biaz40+oBjY2PYcC+8wxhtZl4EMcw4Gi1FBwzt8FFi6r51VFG7K6Gkfg+udq/8M0d
         gWhg4TQZSrLNniJw1Ar5WuoK+ZBmvqwHQtj0nc+FlFPETBUmMi8BDnlr1+CAJAHecHnV
         0B74/zc8q4KMcTSBE6oiTHPVVX1JpTWelpVzn75EXaYQytcVcuQ0AAVQFxtbyUo5K1HO
         vqlwjHmBB850EQ+elKPgbfN3XA72Aa72r1O/J0ACkXh06drFngkJAwYT1JMQUlYa0CfW
         SLHA==
X-Gm-Message-State: AOJu0Yz7xgx8hrCm+o5v8NdA/E2LnLW1kZS1Nrcd7s2dtYMgSkyXsKyf
	ZDp0miBGFphiAA258PAWqs8GO0lOxZsvjpivqq0wyMKn+8Xce91cjbZWjOyYbo+5aBpt+XrntBB
	ZYA==
X-Google-Smtp-Source: AGHT+IG4NdTzrTcn/tJ+C+qU+BUxLlmZ3u4ruAx10ti1k6L8LxPT6OHgmEaQdgvRL/L6EYHOM/vcI+YYgpw=
X-Received: from pgax25.prod.google.com ([2002:a05:6a02:2e59:b0:b22:c4d:2874])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a4:b0:1f5:8da5:ffe9
 with SMTP id adf61e73a8af0-215abb03afcmr1445565637.12.1746745475574; Thu, 08
 May 2025 16:04:35 -0700 (PDT)
Date: Thu,  8 May 2025 16:04:13 -0700
In-Reply-To: <20250505180300.973137-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250505180300.973137-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <174674531183.1512799.1644836485465401885.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Larabel <Michael@michaellarabel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"

On Mon, 05 May 2025 11:03:00 -0700, Sean Christopherson wrote:
> Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
> only if KVM has at least one active VM.  Leaving the bit set at all times
> unfortunately degrades performance by a wee bit more than expected.
> 
> Use a dedicated spinlock and counter instead of hooking virtualization
> enablement, as changing the behavior of kvm.enable_virt_at_load based on
> SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
> result in performance issues for flows that are sensitive to VM creation
> latency.
> 
> [...]

Applied to kvm-x86 fixes.  Assuming -next doesn't explode overnight, I'll get
a pull request sent to Paolo tomorrow.

[1/1] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count transitions
      https://github.com/kvm-x86/linux/commit/e3417ab75ab2

--
https://github.com/kvm-x86/linux/tree/next

