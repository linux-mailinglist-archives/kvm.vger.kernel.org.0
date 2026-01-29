Return-Path: <kvm+bounces-69645-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMPxEr3ue2keJgIAu9opvQ
	(envelope-from <kvm+bounces-69645-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:35:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DE722B5B6C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0B543013A75
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF983446D2;
	Thu, 29 Jan 2026 23:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IUmCpxqL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FDE215F42
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 23:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729716; cv=none; b=fvnZ8pl15W/+WKqiEFXtqgktKpYS8U+I95sD9LdjQ8oI9xGU70SM+D9KcPUaPwqrCMgwnqIDNAaksFBEg13r/VfdV7HW8CjDMrZ7WVC302gpzR/UjwFoRTtnjzxWKbmj4M1HYVxP9nk6Au8Rvnha3z7j7pYHYd+ZNfMMqnjjQ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729716; c=relaxed/simple;
	bh=62qGoba01/4xKWg0SglqZtm4/p5doWh/TYXL8RIiyWM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kaNjxyb/DU92kIPMaA1oROeAYQ1jwzipB4Hog7SJjlMrrBaBnt6BxIU0u0X0dNw/Ti3uC2LfduD2g6Gga9YKc6HYroemFx8UdzMKwiu6ZSxT58ZEx82bPrJkl5ZNVAM42gdLD1cr37KR2v7L0ziBKu5CuHEJWWcV3PuS3aGpbTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IUmCpxqL; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-93f6a0da26dso4709940241.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769729714; x=1770334514; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HJBNjw3RNtSCw9MLJW2nzX+EmjmcAxr1O5/9KOr8e5k=;
        b=IUmCpxqLbD/ju0tDBjHzYWeOLzhOYSbDywkzxQvBkZ5UfImuK/FdT9oMWZKOQ4aP9k
         tHt7/tReWZrugwndtDXxk4XinQpviBop9TPDJ9gmMVecnkA/4GyPsNoH/sjuukElYqXr
         v1FKFdlalcGuLsswrrb3POzqSYy6bWgT7AGleERXnHGiauxs+jrYPpSu4+9g3ois4j6q
         M4ZMZxFQhV1bcmGdUBfzuOkgEgUTtWTctOE6hppmYgcpte9fnDllumWjHaODI5uj4n3i
         W+RVjiDzDqdiSRkvj5ZTk3R6O7GEoXVg66r10uaHP2EfzN11qoF76Dc+j26y4yFghWtd
         B/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769729714; x=1770334514;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJBNjw3RNtSCw9MLJW2nzX+EmjmcAxr1O5/9KOr8e5k=;
        b=jcw4kBSU4Y0iEENaJek8Uxu1dyKbOXEqYv4zs8VmwhjOI3BpjhbCCQOdrrqWCW4xYt
         hpzyfLy0BswEeBEhavCo81H2xlgQXAQ59jcmN58ujQTF6wf+I5D4xoOcbnheTwP5Ze7H
         bPsEOTAINirFW6wQBeI8vyMznxo/O970uO4NHaN8fy3XPdboiEI/emthcbCDOsdV+/dm
         2pG/OqSkJQRPe8iddhcAuolFCrQKgwKuz2brPh4JgooSv8PMCmkKV3RFZvcyePmTcLR9
         CpdK6Xwan3ezhlVJQ4n7PtegnNXJK7oD8ZEv8Qy3GBrvE3clmP35N19uyBA+ZJ41fl3i
         dOUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVza62LXYAJreGzMlcCRHzQe7ZeLmgrNLfVCERAN6FH/hO/l2f5hbKMC7q1BjEP5w1uUl0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCGjYY9RGADAdHzIBkZWEKrY730WLlJ6H56Otzrft2N/0BQNQl
	PjLFWA9WpkNnLbVS2OKcyNjoc6dNmZaNycdDmWnKnw6sYAFDs0F8KIJJFufTJ8UFKN19bFhw6RE
	ieDXtCbBeC1IptQ==
X-Received: from ploc15.prod.google.com ([2002:a17:902:848f:b0:2a0:86eb:ac5f])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cf01:b0:2a0:d629:903c with SMTP id d9443c01a7336-2a8d992f074mr7921925ad.30.1769729340083;
 Thu, 29 Jan 2026 15:29:00 -0800 (PST)
Date: Thu, 29 Jan 2026 15:28:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129232835.3710773-1-jmattson@google.com>
Subject: [PATCH v2 0/5] KVM: x86/pmu: Add support for AMD Host-Only/Guest-Only bits
From: Jim Mattson <jmattson@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: mizhang@google.com, yosryahmed@google.com, sandipan.das@amd.com, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69645-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DE722B5B6C
X-Rspamd-Action: no action

This series adds support for AMD's Host-Only and Guest-Only performance
counter eventsel bits in KVM's mediated PMU passthrough implementation.

These bits allow an nSVM-enabled guest to configure performance counters
that count only during L1 execution (Host-Only) or only during L2 execution
(Guest-Only).

KVM updates the hardware event selector ENABLE bit at the following state
transitions to ensure counters only count in the appropriate mode:

  - EFER.SVME changes: Enable/disable Guest-Only counters
  - Nested VMRUN: Disable Host-Only, enable Guest-Only counters
  - Nested VMEXIT: Enable Host-Only, disable Guest-Only counters

v1: https://lore.kernel.org/kvm/20260121225438.3908422-1-jmattson@google.com/

v1 -> v2:
  - Fixed various style issues, including indentation, comment
    placement, and comparison to 0 [Sean]
  - Replaced "hg_only" with "host_guest" [Sean]
  - Reversed the polarity of the dormant/active logic [Sean]
  - Removed the pmc_hostonly and pmc_guestonly bitmaps [Sean]
  - Added a refresh helper that iterates over PMCs during transitions [Sean]
  - Introduced svm_enter_guest_mode() and svm_leave_guest_mode() [Sean]
  - Moved transition logic from VMRUN/VMEXIT emulation to the above [Sean]
  - Moved architectural definitions in the selftest to pmu.h [Sean]
  - Added a test for neither Host-Only nor Guest-Only [Sean]
  - Refactored the selftest to program all 4 bit combinations
    simultaneously, reducing code replication [Sean]


Jim Mattson (5):
  KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
  KVM: x86/pmu: Disable Host-Only/Guest-Only events as appropriate for
    vCPU state
  KVM: x86/pmu: Refresh Host-Only/Guest-Only eventsel at nested
    transitions
  KVM: x86/pmu: Allow Host-Only/Guest-Only bits with nSVM and mediated
    PMU
  KVM: selftests: x86: Add svm_pmu_host_guest_test for
    Host-Only/Guest-Only bits

 arch/x86/include/asm/perf_event.h             |   2 +
 arch/x86/kvm/svm/nested.c                     |   6 +-
 arch/x86/kvm/svm/pmu.c                        |  42 +++-
 arch/x86/kvm/svm/svm.c                        |   2 +
 arch/x86/kvm/svm/svm.h                        |  17 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/include/x86/pmu.h |   6 +
 .../kvm/x86/svm_pmu_host_guest_test.c         | 199 ++++++++++++++++++
 8 files changed, 270 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_pmu_host_guest_test.c


base-commit: 1a424e9e0616db91010f08e5985bcc6edc504205
-- 
2.53.0.rc1.225.gd81095ad13-goog


