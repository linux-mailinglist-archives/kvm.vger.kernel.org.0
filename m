Return-Path: <kvm+bounces-63120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D6444C5AB2D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 27DB434DBA1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD81632C957;
	Thu, 13 Nov 2025 23:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WNxeoMTN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FA32BF47
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763078392; cv=none; b=C2yZTj0XqllrrOj9Yt77evSowr2NRrqMlx9zSQ7s4wEwPOPAErK3Q+8WaluLkjpkfu28JbecM9DlBbhmWIOl7l8fSLzAwC6aVbuZW3geQfKd135ONC9OFHnrfU9lhMYmRGgei0Yo1QQE0DHxqHC639n3qoXSIwcy3LsfT//95uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763078392; c=relaxed/simple;
	bh=uwk01tFoAlQjJMdErDu3VpaXgM7jQKYRvxop+EenDdE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jB2WW/DMKei/guMiV7VN24CAvRHNPvF2xw0mbFeLGi47fi3MthC4kOCKLmkgDZPJuKhMYy6WNWXtMddtHkKdXaqvmgjmrR/AjKtQt148iuXKY4yY8NPuYofbV++FdoSOJrKBfEpk69wlzXUIXJoUZTv5f6cfHs9j4ngtiIAH61U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WNxeoMTN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343806688cbso2009451a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763078391; x=1763683191; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+sDmguCo23oPUhWvOyCh9bBYAUD1p6jfzj62yI96oRU=;
        b=WNxeoMTNKKSWkgiyiZydbjmRfF/WAVOc2QfzvceIVcymMolOpB24lcWxjbhBQwyfqu
         GW37rkkUWK5xRCOGVgIYGPUV/aMAy+1KB9rZAnbDs5PAsYnqS26adXQ4+SaMIoaGWkhE
         lA8nC1zBgg8RibGB6JdKIAhRgTEWAcHXWj+ggXssnIr9iDkab++owfslyCweT3rwZGZ7
         AlzWzs+3EWAOd8/xCQrrYv8cFph6ir29e6DjSelu/4uPfOo8+efc49js9LshkA5eW78O
         ZxTqXHxARbRMkhI4uwE/OxZhlWFtmm4tmJVtmMMXLF2o+IhC8S9vVvP4a+YPZcc2MNuz
         yJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763078391; x=1763683191;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+sDmguCo23oPUhWvOyCh9bBYAUD1p6jfzj62yI96oRU=;
        b=M4e4f0/f1u/ow8kBqf0xZtSa20droKKn4CDLT6Uo/7Ffny91azVCm29BwwlvePdnr0
         g7gBIt8cQ2YBnKzonvpZ4YN7L+TdJZTDdPbHGEZ/Do3tgsOMhu1DkCjRwYb2tREHlYXY
         xK8d/Iy35JlMpkYFfcwNRR2K5c6xA7X/Mkt6Q4pNI7BMRD40mtaRyIjncfpHYMK5EmNG
         Sn1gTAq2Cy5TG+1k/sAk/tioVWjQBDGwJYwRJmbIkJg0HSCFzvpnLkSZL/HUr2q8E0ek
         L48LyHRCwLvFELI3zozUQsNGl4lnQJZi5PRgoUjyldkh1ei8tQvt8PaLqGC+cbydwSbY
         3vAg==
X-Gm-Message-State: AOJu0Yx6LXh9QjhbAgjAklohdGKfTeUfDWLPPm26wFylqRjS2JdTTiHI
	gveAlgwJWbMvmG03qPKX/836i29O51EMAZu8VjZuA0Udon3pdfIAGou8oC5n2yj4+dUO4d0wTFi
	8hEehxQ==
X-Google-Smtp-Source: AGHT+IEsujrcEJbRsGDflS52BZ2roNggkaDSC9uRTzR+HCsG9Ns9UHMY/btOpZL8r+G9VI0bRultC36sIBU=
X-Received: from pjbgt1.prod.google.com ([2002:a17:90a:f2c1:b0:340:92f6:5531])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e43:b0:336:b563:993a
 with SMTP id 98e67ed59e1d1-343fa63785bmr1004263a91.23.1763078390759; Thu, 13
 Nov 2025 15:59:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:59:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113235946.1710922-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/vmexit: Add WBINVD and INVD VM-Exit
 latency testcases
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add WBINVD and INVD testcase to the VM-Exit performance/latency test so
that it's easy to measure latency of VM-Exits that are handled in KVM's
fastpath on both Intel and AMD (INVD), and so that a direct comparison can
be made to an exit with no meaningful emulation (WBINVD).

Don't create entries in x86/unittests.cfg, as running the INVD test on
bare metal (or a hypervisor that emulates INVD) would likely corrupt
memory (and similarly, WBINVD can have a massively negative impact on the
system).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmexit.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/x86/vmexit.c b/x86/vmexit.c
index 48a38f60..46cc4c92 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -36,6 +36,16 @@ static void vmcall(void)
 	asm volatile ("vmcall" : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
 }
 
+static void wbinvd(void)
+{
+	asm volatile ("wbinvd");
+}
+
+static void invd(void)
+{
+	asm volatile ("invd");
+}
+
 #define MSR_EFER 0xc0000080
 #define EFER_NX_MASK            (1ull << 11)
 
@@ -482,6 +492,8 @@ static void toggle_cr4_pge(void)
 static struct test tests[] = {
 	{ cpuid_test, "cpuid", .parallel = 1,  },
 	{ vmcall, "vmcall", .parallel = 1, },
+	{ wbinvd, "wbinvd", .parallel = 1, },
+	{ invd, "invd", .parallel = 1, },
 #ifdef __x86_64__
 	{ mov_from_cr8, "mov_from_cr8", .parallel = 1, },
 	{ mov_to_cr8, "mov_to_cr8" , .parallel = 1, },

base-commit: af582a4ebaf7828c200dc7150aa0dbccb60b08a7
-- 
2.52.0.rc1.455.g30608eb744-goog


