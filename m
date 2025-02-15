Return-Path: <kvm+bounces-38222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 404A1A36A7C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7CF716FF93
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128871FECB2;
	Sat, 15 Feb 2025 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bdO3DUDv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDF1FE47C
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580979; cv=none; b=Kylpujuo41NtxT/vTiWdo+zaP3jHmVKKdDJceen9U46DoizDJRGdpL0GkeOvGQSPVWrTKl8lRCwr3knYJ2mtcRsu3+/qo9eYkU+scF5KCZ3GKCgWs+KhgPMFM9Ag0rq2RBa2MdIUxPI3b965eSOmsVc5voHJMpsxxa8x+4b8VZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580979; c=relaxed/simple;
	bh=uRG8ujHEnrVHsIn8c8zSJEBtls3YLe4Wr0vqkh6cY1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLQXSuDKfAhNzfxRWQwxwrg43fKGTwnMLuoERh0PG8t6Ri5TYUKZO08jddq7sSwT7pxCEynR0xbFfQyofjYMY/zx2pubYBaiu/jm3+WzxzEDCqdfB8Z0nwJf5q5hRYeQMOqsn1lW5djp8IohtXUi1QnUYv7mRmu95jqUnvWT01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bdO3DUDv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1c3b3dc7so4401484a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580975; x=1740185775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=68IyYIycq1Pdtbw/J+YPvwgWpOzv8wHscA0Xwfn/5+E=;
        b=bdO3DUDv1e0tmRaaImpGLsW2AFYAq1fsbnnVFRUsPjwIFmvFgiIHrQ3ZAEtT7HaDp1
         g8D6Gzb35omYET5C6vm2Vp0dd1vgG2qoZAnLB0jhp867TC9fwknPyf8u168za71jhJqA
         ybr+QKEdXEL5mKKOFBsRed2gME2tlUy86U7Z4WnpIhRjaag3TmVWtVeANIl0L29/TXD/
         olIQxAY4NxlP8WnJyBtNtYxUE5gsu7d831oYV3GKW+nsm3MKUpmNEUImHaSYuKsMJ0Vz
         XzG0km2HkajycFnDgrPmsizt03IsPvqNOLnEVezQdncURgUjaMziYtQwCFQ+Kip0qXB6
         dB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580975; x=1740185775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68IyYIycq1Pdtbw/J+YPvwgWpOzv8wHscA0Xwfn/5+E=;
        b=UDZkURtb4p/IyXD9tc0Kf78DT4ZqD8hyMQHJKO7KdQrdUPu97tVxLyuwFRdJ424SW4
         UnEZehw/YkrUbIpqEDMLQcQy3eFINEYkI7aqdhIhyvHa3uTaS71FINzn4YCLAarQ2fdF
         u846RctZg9auvcAe8osa2r8Jf1+wRrmE2a7vAxHePhBNaisdAt50RwJqyKfit1B4yOXS
         oL2UjPm6YwRaOTFDjK52SPRNsXPQg9B5PyRmdGgTaBzXNkIgYz9mKKohVCNAlyt2nLjt
         VeiU89hCz4ODMb46PSKnsHEimc19RhO1NpSgni7cj7a0BnDbKEnj9JsjbeRzr0DpdaJp
         xNzg==
X-Gm-Message-State: AOJu0Yxe+X3nhoWBciMWxp0uYDVBs+TICs9OvURpRduUCFkAnxlFfOEl
	dptgJx0Vmc7j+f5BGsDWLRy5fkJmdGda9MceIMwyX0riT8b5JGsEofWH6LDLMFsmzP50QE35kqv
	TQw==
X-Google-Smtp-Source: AGHT+IG4oS8jezFfPOMO2sK+lY9DhJZjY2Sv8URxjuuxFTE3h23wn9S/0xpeGoE8/8bdl+7B4BhHhcuLgNc=
X-Received: from pght20.prod.google.com ([2002:a63:eb14:0:b0:ad8:3be5:88d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3986:b0:1ee:7e81:9e61
 with SMTP id adf61e73a8af0-1ee8cad2bc3mr2237807637.11.1739580975020; Fri, 14
 Feb 2025 16:56:15 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:28 -0800
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958014840.1188392.7565055042963100594.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Fix PMC checks in PMU counters test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 17 Jan 2025 15:41:58 -0800, Sean Christopherson wrote:
> Fix a flaw in the Intel PMU counters test where it asserts that an event is
> counting correctly without actually knowing what the event counts given the
> underlying hardware.
> 
> The bug manifests as failures with the Top-Down Slots architectural event
> when running CPUs that doesn't actually support that arch event (pre-ICX).
> The arch event encoding still counts _something_, just not Top-Down Slots
> (I haven't bothered to look up what it was counting).  The passed by sheer
> dumb luck until an unrelated change caused the count of the unknown event
> to drop.
> 
> [...]

In case Paolo ends up grabbing the version I applied...
https://lore.kernel.org/all/Z6_dZTbQbgr2iY6Q@google.com

Applied to kvm-x86 selftests_6.14.

[1/5] KVM: selftests: Make Intel arch events globally available in PMU counters test
      https://github.com/kvm-x86/linux/commit/933178ddf73a
[2/5] KVM: selftests: Only validate counts for hardware-supported arch events
      https://github.com/kvm-x86/linux/commit/8752e2b4a2b7
[3/5] KVM: selftests: Remove dead code in Intel PMU counters test
      https://github.com/kvm-x86/linux/commit/e327630e2a0c
[4/5] KVM: selftests: Drop the "feature event" param from guest test helpers
      https://github.com/kvm-x86/linux/commit/0e6714735c01
[5/5] KVM: selftests: Print out the actual Top-Down Slots count on failure
      https://github.com/kvm-x86/linux/commit/54108e733444

--
https://github.com/kvm-x86/linux/tree/next

