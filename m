Return-Path: <kvm+bounces-35893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FD3A15A1A
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1A74169436
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C30E1DEFD0;
	Fri, 17 Jan 2025 23:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="va0eWlAA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED781DF27E
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 23:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157336; cv=none; b=c7dP1kPQpqqWpWRKAxy6V0iDb/MXvaibzBdDXc8N/paH05PYV5Qb+8yEkqQnxyLFFRgUq1/SJgdl0h9e53rKFbFRPJ3dlgRkmuMo8c9wip0S3f/4DUALWPYlPx3vMs3zt6ANpQ24iBmkzVmjKxM88Ft/Hpm2jPrF8TgWDpQNntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157336; c=relaxed/simple;
	bh=DAhep5Ase+lzMS0yxjMlf3nQhuSF+WH7RFRAClM9nmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cyhK9ZkihHmdAyRMjGyI/KvV5RGtH8LoK0lB53sKQ40u+qicCGH1ptkqjA4nb2E8umTnmwJbAC5eGFvTPB2XyLGJh5EUTEat9d3rV4aznwnqlBiuC2WxcTcfdw+B4sPZqCl+i7L+Cj4+MNMZSBUqV5BS0cQR7Yyb7ouItrU4OYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=va0eWlAA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21655569152so51840865ad.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737157334; x=1737762134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Pxxocry5JF8tR6kff16FhjmhaVcMoVJgF5laflTBa1A=;
        b=va0eWlAAB30fE2SsWaElGtzOWLGoKezL4arLdK9/Hs2ba6mRz94L7iBkC05jwpnTy/
         xyZ21DAPfwM9FgeTf30wQZXivGqQLDHmQpkHBzR7wtgT2vbeEHeth21HF/qd2qidbnKH
         OlN65K64C0HSJ5Uvg5CWnQmZ8QYq+6DSQ2QcpUU8KkK29Tzm1zuh3djsh2VzWtYGNBK5
         K81arHTdwcVJaP3MK6Djxx2nDRlrkXwg+Yc785F9n7CGaWPd7B2Q89h7/sH5ZwVFFm7w
         kjNFflLxR9sYEYj+UMnJPVNUZi1zDCNPhnRMQKHhHannzGM1Ntm/nJk11jEhZYt7FilL
         VPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737157334; x=1737762134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pxxocry5JF8tR6kff16FhjmhaVcMoVJgF5laflTBa1A=;
        b=oW1ClcqawHy+5F/xCGshsOA8UvskYdNlDosezY3BnUEhKV2z8v62bgh37QKlRfgSOx
         B6wlV4h5VX2G8TRk0pZUmkZg2hxFuO+YbWpCYKhc3bhhLQa5vcsNlyVlM3NydJqXI27S
         aagoHBArUF4yefMLQxc4HXyY3WFYp0LtFMjaOZWorrJ8Dm81zKlLcBbHYauCtAmkPjBR
         uPvqDUhNMNeA79e49mhDmrqJ/xqFH+2rPocYbRxsIQMsFLrLpqtMVR8tnmTmNh7ZX7Be
         qUrhTkj0cKN+kph8pkbEAEy+IbaO7Zyhk40GYB2nqeWI0Wcp2NsTprxneGw0GL5bSQdA
         dzKg==
X-Gm-Message-State: AOJu0Yx4RnKC+LOyiHhZodFjN6z3hBsJN3OmrEKlrw2Ie5/yEQ1aUohJ
	xHca2Rwlm6UMIodwYd5Caq2SErhALMftDQUQJcJgzExEnNWAOw30uxAkStGCmc/0Axc/uNq7y6e
	+xA==
X-Google-Smtp-Source: AGHT+IEaLt2kHxRo8izrrxWWtdVHMGzvIZ9FdNE/IPsW8hD4WzO+hrVwOHBFnStH3DvZx+QCOFX/xnP1GWQ=
X-Received: from pfbcg12.prod.google.com ([2002:a05:6a00:290c:b0:72d:b526:23ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:928b:b0:72d:8d98:c257
 with SMTP id d2e1a72fcca58-72daf930ff5mr6435991b3a.2.1737157334291; Fri, 17
 Jan 2025 15:42:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 15:42:03 -0800
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117234204.2600624-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Print out the actual Top-Down Slots count
 on failure
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Print out the expected vs. actual count of the Top-Down Slots event on
failure in the Intel PMU counters test.  GUEST_ASSERT() only expands
constants/macros, i.e. only prints the value of the expected count, which
makes it difficult to debug and triage failures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/pmu_counters_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index ea1485a08c78..8aaaf25b6111 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -174,7 +174,9 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
 		GUEST_ASSERT_NE(count, 0);
 		break;
 	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
-		GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+		__GUEST_ASSERT(count >= NUM_INSNS_RETIRED,
+			       "Expected top-down slots >= %u, got count = %lu",
+			       NUM_INSNS_RETIRED, count);
 		break;
 	default:
 		break;
-- 
2.48.0.rc2.279.g1de40edade-goog


