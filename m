Return-Path: <kvm+bounces-38246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95529A36ACE
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A029B7A45AF
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A03015198B;
	Sat, 15 Feb 2025 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GKHq01UW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782433595D
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582440; cv=none; b=F4qYh+9KE+Fcfkt7noojo1CMTrhHSmRaY5KUceL5i7r2d9hIBkcO0cKU50SEj6O21T1JU7NyK5vvN33ESLqTvcNoLIPWr2pBwWDq4Ncd08nWPdRdskSGPQr30viF9lRhOxmU2nbJSo74/LMZXtEDGJISq5y4+1SgkzZ9vxtUO/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582440; c=relaxed/simple;
	bh=u7tdHrMMjQ/ReadPZX2qvlIc67bz/HaecAzrp1/GNkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qL/0Fel2d4qAeF5NcxG19EbioJgWHkRuvsFt7KPfkz/Sf9NlTDyZRJAfRXjndE02T6wB7QZl6Bo8EKWeswv6UUfirrIcRDQ7t7wXoBAVJpPpWRTXUntupZRMaWCg5os5aQr7f4aE904wBQbNU1xEHebtIT6sv981y6ztUbGsWEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GKHq01UW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05afdso5244765a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582439; x=1740187239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M7Ontz1FhRjdiHfzWQOk2nVik234l6ODi0A/QAS3Egw=;
        b=GKHq01UWIvZf5jE1jcDdS23nS0nVB2fnQy+z4oWm0YxHVteHmodrkkB0WziBLKTblz
         NtwsAfq+x95C9r20uh5n5adZDA6kxQx2A+Y5tK7T7JEGufr8nABPh+Un7fq1w7fx1kAL
         T3/wQ8WqxpfdvDquF+/yreZqCMGCgQYb92ag4PPZmEe8FR4j3CguGn63fYYuYg+DC4ZX
         d3PCFIazq6JnxM+1H6KLcjM0YVup77hlgaPobZqA77nV2/m/dQZ1T7+VoHVEPzMfceSU
         DY1xg2g5EeH5TKT+tZL7dnn5WpnXmV52s5cTIoKzDQBmQkjBzhrSDMr9sJdRTPVsZZDP
         WM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582439; x=1740187239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M7Ontz1FhRjdiHfzWQOk2nVik234l6ODi0A/QAS3Egw=;
        b=W+YLH8NtQ3C02C8Lc4DwEo7xb6h5jNKf10RunnkQNIHs+yXv5Txef0IjE9tly6sh6I
         LgOJ5CDpYjRNvWOJj0CtTCEFlUx5qfT3k0z3WauSQZgD4wEykz1jeiQ4baKgAx1Sdvuc
         +Z4zt2ikcKySavbqT30bhG1+PxNVMljJpmK8j3j9i9610FIQiIP7snjPN1gnD66zPwIQ
         wrpZjAb1ShU6F4c8QTgLbXIbAtHXT1NLVgDXqCMrwp2paAG6l1QOmWPFpcCrkBaUWujT
         uGtSdc6+z+6WR6My191ynjjm8SbgQq9jAQ/Uw8y4Nn8nBoduhv4wr+Cvd0/zJJIr2nRW
         beEQ==
X-Gm-Message-State: AOJu0Yy0Y6qqAAzcAyxsG97qissNS+DTon7pjcGOUtsPcDA/qnq0AXEg
	2QJLG9pQL76RkEzDLiGhsYkk0S9NVB/d2B4XdQcc9zgPHhzWqUnx7ZZY1fzZ59s/IJy/a5lWeL9
	gGw==
X-Google-Smtp-Source: AGHT+IE43piwt/I02uTSLnFnr/Czalt8HJ9UwKUzXlsYKXzVCXSlEmDJBy0VITaKINTJlmmgyRcro3pdJVg=
X-Received: from pfbay3.prod.google.com ([2002:a05:6a00:3003:b0:730:8d2f:6eb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1804:b0:727:3cd0:1167
 with SMTP id d2e1a72fcca58-732619005camr2270302b3a.21.1739582438739; Fri, 14
 Feb 2025 17:20:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:20:32 -0800
In-Reply-To: <20250215012032.1206409-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215012032.1206409-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215012032.1206409-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86: Increase per-CPU stack/data area to 12KiB
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Increase the size of the per-CPU stack/data area from one page to three,
i.e. from 4KiB to 12KiB.  KVM-Unit-Tests currently places the per-CPU data
at the bottom of the stack page, i.e. the stack "page" is actually a page
minus the size of the per-CPU area.  And of course there's no guard page
or buffer in between the two, and so overflowing the stack clobbers per-CPU
data and sends tests into the weeds in weird ways.

Punt on less awful infrastructure, and settle for fixing the most egregious
problem of tests having less than 4KiB of stack to work with.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic-defs.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
index fde1db38..5a1dff3a 100644
--- a/lib/x86/apic-defs.h
+++ b/lib/x86/apic-defs.h
@@ -3,10 +3,11 @@
 
 /*
  * Abuse this header file to hold the number of max-cpus and the size of the
- * per-CPU stack/data area, making them available both in C and ASM.
+ * per-CPU stack/data area, making them available both in C and ASM.  One page
+ * for per-CPU, and two pages for the stack (plus some buffer in-between).
  */
 #define MAX_TEST_CPUS (255)
-#define PER_CPU_SIZE  (4096)
+#define PER_CPU_SIZE  (3 * 4096)
 
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
-- 
2.48.1.601.g30ceb7b040-goog


