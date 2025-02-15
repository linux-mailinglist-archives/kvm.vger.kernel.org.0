Return-Path: <kvm+bounces-38244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E64E9A36ACC
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66046170720
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C7013A244;
	Sat, 15 Feb 2025 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nNC+jorV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7301E42AA3
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582437; cv=none; b=V+Cc8TqMPAJhDuJq85PUNkQkwFuwAC8Xm29ghQY701cLZ91ucMyWuIs8/obrUcMKKxKV53tw0sHhuD6Xuu2Q8YXG73eYlfQqGkseFdilMPD4CMJvoDP3tRnE60CkbfXMJL/bGhjQM6uNyB8qXcfO3QtQspyeb8GWsZC+v56v3W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582437; c=relaxed/simple;
	bh=nBDkEijhjTx0/Pu6lukitnblAt1hyGlNtVkBkR73eYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S020cuYJB8yBnwVrJPjlRYtfmFfrDGmQMttpRCPyLMACAPv1jBuTqch1n5yIcmdDve7H9Z6bwtIaW7wwT/YYuUg47fPuN9fA0+pNHTWVnZ8wsevkf9EBmPs78wCG+BXGx7VZmSw7L/31M/qUZ7mdCDfIFMnTRWmv4WZTSkWsbgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nNC+jorV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa440e16ddso5627969a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582436; x=1740187236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+xfEszoj9UQOtWpt0zdSxIp6e0ZDqOvipnJKtKXbbyA=;
        b=nNC+jorV8W75R3ZIEGGeyVaRdzNOpDWSdQMJTDDmRc2gOW3Kwe9qPOrfWBKYCRVYvG
         RdXh1AeeWnQvFooC/c2AE0iUqJQn2Ao7yk6mv0VA/EAoa5LnZ1TmL2nq89P4mGgaG2w5
         wcmo3mdj2MGfAlDViqK40Hvr8KZoL5rR6B33qRcFQXJnWR3JXsxnMLqgph0DHVAliWGw
         C77jqIY5kA0l8doa7jiKpQX1dPS4b4vdEo46eLafLC/43E79BDVggnVQEGA7/yRXZqxU
         v1yL3pZLTOzYQT9ut8vXioepjoc7aLyQvSxC5yRiKLU3iQ7FeErk9CRtx0PqUNUBdwY5
         RkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582436; x=1740187236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xfEszoj9UQOtWpt0zdSxIp6e0ZDqOvipnJKtKXbbyA=;
        b=W+yRmNy+ATU5ifpVH1tOxphVDNTVUOKCEHI9BaBXq4L1fv3PEwSkr19cg8K9d3jb+k
         5umaowTALZ0opijweElLGJQDePYyCCxYfUFfaTOYLxk+hgizYat3Z31iQKjbHd0Oh5fL
         qKygiXqj1iXuvbNadPTapbnuwQ3cxkscTyWFWp6mFLpTe+vfWPN8Sm3V89prPeiHa5pZ
         3aW9n1ZyEzRtQdCGGbspJoSTF3iIfmp+kTyNREoPA/bzPddn97m4zKhuBWasIgcrOg15
         xr/ohnzwbKXPbr37Zm8NMmag+KGUEMIJDatehhuReoavwpALt7blM20JUDpDTGygSAJY
         9vUA==
X-Gm-Message-State: AOJu0YyJIsDqlq+l2VA8IeTVMsQVODLTuoMrJFuGCDHj/iCv8CRwgCpY
	LA9VRIrckmbWL9NBtHa7k9V4dRsnTRpMeVQWH2nDW37yHlcsoSF22jcEgJTZRdewPJOKyPnpKac
	sag==
X-Google-Smtp-Source: AGHT+IGUiqRtrLVQdb+LLEWajt0HeiOol5P+hWUKTvFS25PD5dpD31JczvyHysIChMpInZIS7GnJDC1DR10=
X-Received: from pjboh15.prod.google.com ([2002:a17:90b:3a4f:b0:2ef:95f4:4619])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c1:b0:2f1:2fa5:1924
 with SMTP id 98e67ed59e1d1-2fc41046e53mr1619435a91.26.1739582435734; Fri, 14
 Feb 2025 17:20:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:20:30 -0800
In-Reply-To: <20250215012032.1206409-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215012032.1206409-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215012032.1206409-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: Make per-CPU stacks page-aligned
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Align the per-CPU stacks, and by extension, the per-CPU data area to page
boundaries so that when things go sideways, it's at least somewhat obvious
that a test overran its stack.  E.g. as is, stacks often start at the
*bottom* of a page, and so it looks like they're always broken because
they immediately split a page.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart.S   | 3 +--
 x86/cstart64.S | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index ceee58f9..df3458fe 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -8,9 +8,8 @@ ipi_vector = 0x20
 max_cpus = MAX_TEST_CPUS
 
 .bss
-
+.align 4096
 	. = . + 4096 * max_cpus
-	.align 16
 stacktop:
 
 .data
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 4dff1102..bafb2017 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -6,9 +6,8 @@ ipi_vector = 0x20
 max_cpus = MAX_TEST_CPUS
 
 .bss
-
+.align 4096
 	. = . + 4096 * max_cpus
-	.align 16
 stacktop:
 
 .data
-- 
2.48.1.601.g30ceb7b040-goog


