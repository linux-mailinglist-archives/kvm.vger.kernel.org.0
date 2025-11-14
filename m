Return-Path: <kvm+bounces-63142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 919E6C5ABBD
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3349D4E7A2B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354E921FF38;
	Fri, 14 Nov 2025 00:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hnm0YLPx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D823D7EB
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079210; cv=none; b=JB9S7MQgh8pDgFeoImsx2Ndlsa8yHpPZ8ZO5thk+xX1shdLhs8XiD0l+T40bIs3qIdREt3D9U64k2yVRgfQ0v1sUOorx4IuW1TbVe+0JvmLYqdyyF+9tg0FEu9WpxDV9UKHvDKPoIwjXTULEee0p/469AJ3Fw5EVlM9IwYUvCL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079210; c=relaxed/simple;
	bh=w2cyW8JmGF1XH7JOWXXLURIADbPe5c65I/r9tDJawSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uBzN8CntlqUc+Csejhlz5wIevvnWXG/ZMlOhvU+MhhwkymizAm9l3j0/lnUt2ZSvY7jKy5EobfrEzzMV9e+xNVw6oh59hGcj3cQHw/Zv7/I0ECxx4GInYbuIeTxZMWlkvidtHPuvVHXlSn7oovwtjIS/XI5v+JakKdLrsUjIOzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hnm0YLPx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341aec498fdso2271713a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079208; x=1763684008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lR8KEBSO4p55+03Sp8GiO+6wbI4s8YHmKZkGGM7IKm0=;
        b=Hnm0YLPx+OdJYQOHKrKDbbR8uDYKj2KjRZH3/unUkP1UR1qZFHInh5w13Vopkr8ZV2
         CY7EMhwmK2fj+IaXFiuUjirjteqMN66rD3OLpE7df5b+ETjiAybOjbOPfZO7xekGxEON
         tN1GCVLtQKe9yDg7caaxIBPQRqssefFHB2rEJBlaA+pMUO06sbH5EiZN/AM/sDIt8Zx/
         kjXG1Xcu+uzrkXKDlc7xfrwFz3HBAv6tpHryp3JJqvsX0TqyVLanTDddphTc3OU3BoHj
         +E8hFV7SzPmuhdY7ARdOQs7e7C1/iqySQfhzcg3zgaTAFEpVF3I3P3Us2xNms6JF5jsc
         HutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079208; x=1763684008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lR8KEBSO4p55+03Sp8GiO+6wbI4s8YHmKZkGGM7IKm0=;
        b=miLbRRaylSPpCUXglWy/Nz2mwU79ezanWf5MhgVRqpSkm43YO3bUzkIcObCfV44K8P
         474Q8lTsNlfOlI6bkDB5yJf12SdB3JVxaSeAU7PDiIcsWsiuSLakurGynwpWrA2E71WR
         RkutE4Yqr8y/4WeuNMU7+RV0/2Uso018+1xYt3jeBGYXfXJ593ejlJIdw6Cla3Eqsy6u
         OeE5a3OE83azQ8NvQjKbi1HsrnVHpfG9cbIhAkf4xNgH1jrqIN+ZDhowxPr2Vyd0KDul
         eL9e5yxIEJ3hcKHSbrMRkt/EeoPkadpSMMbSDVicubmR5UcieZZJESzm+UTxAAJWzlAx
         qb/g==
X-Gm-Message-State: AOJu0YxlGpy9en8tfA6elXqx+iPI0+Yre6vwHdun6vYYYu1/USs9LCZM
	lso5URJBsrWFi95laDqkFJiiJroQ3utv43csHv/h01X1JotcEiefQjursgflk0PBUIVXQAwI5VX
	RQ6AJVQ==
X-Google-Smtp-Source: AGHT+IFZh546z3WiSZiylZRqt0bv5Sw6mkJFP2xnD9e0QzjKuDVhv1+o3ZmegdZVDp/Os7xhpR5helYIYPM=
X-Received: from pjbbv17.prod.google.com ([2002:a17:90a:f191:b0:340:6701:ec71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c50:b0:340:f05a:3ec3
 with SMTP id 98e67ed59e1d1-343fa76ba3amr1258123a91.33.1763079208249; Thu, 13
 Nov 2025 16:13:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:57 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-17-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 16/17] x86/cet: Drop the "intel_" prefix
 from the CET testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Now that the CET test supports both Intel and AMD, drop the "intel" prefix.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ec07d26b..a647d1bc 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -509,7 +509,7 @@ file = tsx-ctrl.flat
 qemu_params = -cpu max
 groups = tsx-ctrl
 
-[intel_cet]
+[cet]
 file = cet.flat
 arch = x86_64
 smp = 2
-- 
2.52.0.rc1.455.g30608eb744-goog


