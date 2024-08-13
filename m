Return-Path: <kvm+bounces-24041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73837950A97
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:43:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 932021C20BBB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA211A38C1;
	Tue, 13 Aug 2024 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z977CYLx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA0A1A2557
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723567398; cv=none; b=oh+RtstY+TKJkfZKJmjX7nRf8+XQ7rryMnLSRTlDFGUczhAvnto/qVsEuhOS25luA+5B1yhNYSPgboqYmW0GhppIil+pOiC1BLgxklFsKC3AN1OtgqxzSE/bA+r3tDNU1lAL8675qxJiz96TElc8PhDfBXVhT9QYOvhvAbGHRkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723567398; c=relaxed/simple;
	bh=+8Jotfh4jL/fBqNPpnZwk5SliEZbhTClP2DNYMZh29I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLmVEi2xZDcrQIvAPfiUADoAWZqzLiGYnGZzDpbMnX85KeY8So9RSVx+XMT5gZge/TN6PNCh+DU7xcsfa2KPFQkVED7oqabwnuOul5EypExjsNiGnutvQ8evAKXTN5/xGggVS5wIsnjX5ppOYB6NBDwnZrqzfZxzI4pOpaUnYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z977CYLx; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-39915b8e08dso81603965ab.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 09:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723567396; x=1724172196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4hjHwnogfh1FVF5nIyMDpPAAJmvxrrYhDd4vDZwnNI=;
        b=Z977CYLx3+tVm4qWQIMId5ZAgCg9WUrR2gblffMFztvFuXtry4TXn1i3xf6pJz4kR8
         GzSQlRZf01ITYCG4CFt7zyaPX+7xi7wrb1tsIX/ZM/rJiJvdb1LKijIgaepEqnsglJmg
         JDKqSHSbar3LNZc8a4mZihlnl7ogXxSjV6qlev9srQ7ar0vZcevB+YquiXXDoe2IHkzq
         pRVrGxE18fvDU7Rf6n24DluakBJ8EtOL+GtmOP4XbYwQYn/u6sPE0iuVuqrqafmeD3s/
         9qrinGoMHAZhVKUKsn/fApfKdMmj04+S6f9vBSPDDvFH7O0sIa1jqfX22PCBxy97vqqS
         u7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723567396; x=1724172196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4hjHwnogfh1FVF5nIyMDpPAAJmvxrrYhDd4vDZwnNI=;
        b=wdjZb1aqxHbGGhhpVHKhlXndUYZsfgc4EgJBEqubsb/+D1rPL2s824JfbK2KA45fN2
         TRrmyeop9qsVlYrARdCRtIjxlT4LrxJoyRrOAYnbVpIHKcnaR+/TNxl8+TXCGluU4tY0
         kK7KJnHw4hW99YrbgxL8GNB6SixalT3FOQFX46dh40U3uq6lHczviUee3ChSoukw9acG
         en9W9wR295acl0EQGi/KC7SmeH+sGc7mSGo1IqMdtaAJZdaRsNe4u51+PSK/InB/iXWV
         arVvbQRKDfGoAvUBj3J28Pvaf/eW+eKW01U65Q5vFlJYIQ5T39atG4wjdslQ/xUoFz2z
         9RmA==
X-Gm-Message-State: AOJu0Yz0a6Qm2R+hBIxLNi7/1zvzGmmcXA1yCdPI4W4BidlE0JJva6CX
	Fef9Li824kvZHHKCBYbO2vnShbpybQucbw6uj04Yd9N+R1W4x02ATAmxRQN7JEFKb7BMiWO61s0
	aJ2rFAP7CH7LzgFUp6V9LOAiuGYmip5Lez80BcmGtkWGGaEdutZOJOGInAbqQiZR8Sjlv1fVefk
	3DNoIfMia7wIJ649oouHHSnVU5BOZbKRdtL6tXYvJK1mausF5rydhlWv8=
X-Google-Smtp-Source: AGHT+IH9sFuwwZm2IzNPjr75f0WTGkljO5daIy5Ohio798p0uPQPFiZA8ni/huUlI+/Kd2HlFr4VhkfAuQWlzAKSFw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:12e1:b0:39a:e800:eec9 with
 SMTP id e9e14a558f8ab-39d124ce491mr169325ab.4.1723567395730; Tue, 13 Aug 2024
 09:43:15 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:42:40 +0000
In-Reply-To: <20240813164244.751597-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240813164244.751597-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240813164244.751597-3-coltonlewis@google.com>
Subject: [PATCH 2/6] KVM: x86: selftests: Define AMD PMU CPUID leaves
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This defined the CPUID calls to determine what extensions and
properties are available. AMD reference manual names listed below.

* PerfCtrExtCore (six core counters instead of four)
* PerfCtrExtNB (four counters for northbridge events)
* PerfCtrExtL2I (four counters for L2 cache events)
* PerfMonV2 (support for registers to control multiple
  counters with a single register write)
* LbrAndPmcFreeze (support for freezing last branch recorded stack on
  performance counter overflow)
* NumPerfCtrCore (number of core counters)
* NumPerfCtrNB (number of northbridge counters)

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a0c1440017bb..9d87b5f8974f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -183,6 +183,9 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
 #define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
 #define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
+#define	X86_FEATURE_PERF_CTR_EXT_CORE	KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 23)
+#define	X86_FEATURE_PERF_CTR_EXT_NB	KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 24)
+#define	X86_FEATURE_PERF_CTR_EXT_L2I	KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 28)
 #define	X86_FEATURE_INVTSC		KVM_X86_CPU_FEATURE(0x80000007, 0, EDX, 8)
 #define	X86_FEATURE_RDPRU		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
 #define	X86_FEATURE_AMD_IBPB		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
@@ -195,6 +198,8 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
 #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
 #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
+#define	X86_FEATURE_PERF_MON_V2		KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
+#define	X86_FEATURE_PERF_LBR_PMC_FREEZE	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 2)
 
 /*
  * KVM defined paravirt features.
@@ -281,6 +286,8 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_GUEST_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
 #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
+#define X86_PROPERTY_NUM_PERF_CTR_CORE		KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 0, 3)
+#define X86_PROPERTY_NUM_PERF_CTR_NB		KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 10, 15)
 
 #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
 
-- 
2.46.0.76.ge559c4bf1a-goog


