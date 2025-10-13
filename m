Return-Path: <kvm+bounces-59904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DA9BD48B6
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 17:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A9C19540F07
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837F930DD18;
	Mon, 13 Oct 2025 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GrWvzsWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7413064B7
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368449; cv=none; b=JvDsd0eCOEX8yPTvKFzBD8OLSpDtjBA8EktLSlVzDjrAcn3VTYFZywbqNOAowX5yJBbU+Q8wuvid3byLe8Rv35TGBjVZVvfTAllFnWxv1peKNFJRg7nNJIHQQ++5+MARPbqSDcu/1VF0HqtBRh9vzFhymAPX9k3/MZb4gIrts84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368449; c=relaxed/simple;
	bh=Z9RgNSg0rvUZJKtFBNjOQe0Or+bfCzh88xAj94wUZ7k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Pld8Qz3tMDRxohbY7z37CYdBecl8nOouEWpx/5yRTBcueVz6bhxfkWs9LZF1NPGT8J/NKdf2D9+Vs697zUOm2epydITkpEbhYRRHpuu7L+kDd7z/QpcVPojgUbL6YhFz4hJ/sOwp3D/Ltg5X3e/dhMPLOFB+nBlXd4Vl6lv0XQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GrWvzsWH; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3fba0d9eb87so2789342f8f.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 08:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760368446; x=1760973246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NNmxwuDco5ze1SKSZ1OFoPdEieZ9GLx/Dr5DvgKSKBA=;
        b=GrWvzsWHKH7+3kuHWKBXXjZemZIPPPVzFsuI8814GN1eGocFL7axNSZ+ovjQkgrTKt
         CDAJaDv1CB5vcWlgRWYFG0KKGPigPDgXojmiXVu1fejKM88V2it/3o0YORPWDXx0NkF/
         a5vOsiay1X6ivTn4VRBkP5CJQg/qvLvxex0mfVSPHOn8CbEnBeTXKssViDjCkLe/Nn54
         aumqnCCIZ+cWxPfLhmsVOJRvRdVMWzykZ9WKZGLOREtn8zKjWT2B32uV65CIDs1ILFH7
         yzcM0vadje+e/G078uOgMl+OH8nsZlbGoGj/PH0CNfcgNu3eHeW3ierQg2VYuufWx1KF
         9KSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760368446; x=1760973246;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NNmxwuDco5ze1SKSZ1OFoPdEieZ9GLx/Dr5DvgKSKBA=;
        b=C6MXIUMSZGUcG3S0E6pvP3tKFkTQkYUjbikjEhmOQSwgpFOq3Ny2gp4CtG7nKf+Ev6
         3/IZ62EmHxZNq0AMfHKuceUsOcnD0G0h4kqLz/LXnxwyUqvfozeBUDq+JBHzzVD1H1Jv
         3bYASSqyFNfSwGkZ2+FybR93+xhgYv1+HsfBLXGIylX1q4F7Ipa/TkHskyesYXzSwQKs
         g7pg/pO/Mf68mCeUm8HM+mIbkaBhJahmcUmfwyLcIkeTl1Vjl5Pt2bWeLpFhq7lif4VX
         w2FeY3ZvK0BL3xl9NVdzWdiZynBIG7o3D5UEjG6holvAr+6RFBtAJDeJxr15QCwlKmIS
         rdXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTTB+n/BAfb33aVP2InNfZ5wNnKE3YpYF2kw4xX5Nrrbdu0nGMjjTzdry7aQiS63X3FQc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpw5jOuABr6FfoQ5GQNj7CwAXnFVXNIo5WN6UcZ71C7VmCq2en
	Sv3BpyGfiDXeh1EHL8AxT52DqMrRnINpy8goG5UCfWAVK8kWO7HSbgJzjd8p+LzRRPguFT7pxEx
	QDNpa+UNSKiHXFA==
X-Google-Smtp-Source: AGHT+IE3C8Nd20ZHePRqKGg22TTzUNGyTunUFc7gyL2zVKMFC2qRk5Zo3CNDYWy1lTTMLQtOrMQV+bypVbSMug==
X-Received: from wrue9.prod.google.com ([2002:a5d:4e89:0:b0:40f:b976:8cba])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:178c:b0:3e7:5f26:f1e8 with SMTP id ffacd0b85a97d-42666ab3390mr15014702f8f.5.1760368445701;
 Mon, 13 Oct 2025 08:14:05 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:13:53 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIADEX7WgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDA0Nj3RzDkjTdktTiEl3DpNRUUxOD5NS0JBMloPqCotS0zAqwWdGxtbU ASHY8XFsAAAA=
X-Change-Id: 20251013-l1tf-test-1bee540cefb4
X-Mailer: b4 0.14.2
Message-ID: <20251013-l1tf-test-v1-0-583fb664836d@google.com>
Subject: [PATCH 0/2] KVM: x86: selftests: add L1TF exploit test
From: Brendan Jackman <jackmanb@google.com>
To: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Alexandra Sandulescu <aesa@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

This has been tested on a Google Skylake platform. 

One potential issue with this test is that it fails (that is, the
exploit succeeds) when using the conditional L1D flush, because the
gadget is injected into the hypercall path which doesn't appear to
include a flush. If this is unacceptable, we should discuss how to amend
the test so that it can be used to evaluate the conditional flush logic
as well. This would basically mean simulating some more complicated
gadget where the "attacker" has found another way to steer the host
kernel towards the target data, instead of just a simple hypercall.

The reason this limitation is tolerable to me is my ulterior motive,
i.e. because I am specifically interested in an end-to-end test for
Address Space Isolation [0], which is abstracted from these details of the
exploit.

Based on kvm/next.

[0] https://lore.kernel.org/all/20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com/T/#t

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Alexandra Sandulescu (1):
      KVM: x86: selftests: add an L1TF exploit test

Brendan Jackman (1):
      selftests: fix installing nested TEST_GEN_MODS_DIR

 tools/testing/selftests/kvm/Makefile.kvm           |   7 +
 tools/testing/selftests/kvm/x86/l1tf_test.c        | 633 +++++++++++++++++++++
 tools/testing/selftests/kvm/x86/l1tf_test.sh       |  10 +
 .../selftests/kvm/x86/test_modules/Makefile        |  10 +
 .../kvm/x86/test_modules/l1tf_test_helper.c        |  92 +++
 tools/testing/selftests/lib.mk                     |   2 +-
 6 files changed, 753 insertions(+), 1 deletion(-)
---
base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
change-id: 20251013-l1tf-test-1bee540cefb4

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


