Return-Path: <kvm+bounces-70528-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPZcKD2UhmnuOwQAu9opvQ
	(envelope-from <kvm+bounces-70528-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:24:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E26010479C
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AA973024134
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 01:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3614827E06C;
	Sat,  7 Feb 2026 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SLGclmpL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5792264CF
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 01:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427434; cv=none; b=tu2yDGMPEYbs8OFCSd1afB0gK3gqHoZdVrruslzenCLcYOcxos4UmH0VkGNqADC55ZUOgA60xle1tQxHW1oflRGAMh/hy0t+OnJoSjc+M3KILRMh34mAVe3ZQ8fGjqJlPeYqHrLWZP7QS47NhjiFbFG6BWxBZwbiI4du6wXPC7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427434; c=relaxed/simple;
	bh=dbXNLQnXNLyXQ9CT/B6ZGUFhbJ3b6yLRqpkwxAjNO5g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CJ3+clnqpYlM486KnTTKwsN9rVVSEVL35bmqJcz3+xdY/XKtejkkyag/GBD9WP91U7k2wWNchceUigg6qpvG3eUuGcRTjICYqvKcM/55byEBNPhyCXzM2lTikMPD8WT6+viSOXrwV2VnCx/HnqcYLQOGowJsgJMy1Cytb/UFNts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SLGclmpL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c617e59845dso1569465a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 17:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770427434; x=1771032234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zx9cflBOvMN2Fre5G6WHM7bbDYv06YwaCyO7rWPF26U=;
        b=SLGclmpLSC5f+b2lHOUddrZVZntDo3NmvP7g8ZpcA99lvnk2/5gz252p8Cui8qb0RV
         GfEYuAgo0K8EwxLGbYja5FywWyGgA04Ghim2Nb66RhtkxQqmIib57ppl5GWglEzd3BSd
         GIQc7Lg5fnzfaJRd3uVjCiICz8UJjbXfnRGocVWrqfb/DYV+lYF0bcsqW9pg2zeeGUn1
         +iqNnpMbeO5kRWPr9fBb3yJF0grnkksUgBaU4DsLPWlkmGaU4znahdlMhxYB/nu8QYkv
         DHiwGnaOr/6YApP1yBoI5+5F9++SBnGbC71YwgSPM4qeBe4eNZUJup863BWlb9vNp0z1
         StQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770427434; x=1771032234;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zx9cflBOvMN2Fre5G6WHM7bbDYv06YwaCyO7rWPF26U=;
        b=vhZrt8+wqYf4ThhbxbkL2qxe9cbUs6jOBQJbEmLx/llMuI+e/RGocwl5Fm7zfXsfy/
         YwfR44UoY8qWVWEfCoLt+QjeUm3OYDCIKM1F1Llk3lelg0XHeyoEF1Oq7Mbv8nxOvWST
         o56zu2Bc+1aHfonaFJZWbg2wlFEFtAZ8U7UzEM7Mxy5/A8cZU2xvh1nz4XqCM8KAxBbZ
         3bEzhFb+ORYuD3L2s6p8OU6Qcj1fP0vq1Wtx5ytWqzhPgYxF6T4XOhFDaVpmSXrGO8PX
         lJ4uDLS7Jw6vrdnto1qv8qTCGD5OCV48qM87oGJBwayTz2WnjobfCslnVnL4Rl5e8+P/
         eqlA==
X-Forwarded-Encrypted: i=1; AJvYcCXHfF3ZuOKCRN08zwFLW0TdMiIYBuQHM9o1Ymi8EtjN4nTOrxeIpzRaMv4ABCwX7VYf7pw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8i7RWEyiuDGQSj/ja1ZvvVbnFz0GS1TIsSBFHzx0Qa6K7BWgf
	NJINjbZlcQTx+0YYy+AMDjzR9MCIi/3K4lX+Reazw2S+u9TNExrR/Ut52g5/zhqWV8/sYkVW6xA
	H819M5liaIPiN0Q==
X-Received: from pgbdo14.prod.google.com ([2002:a05:6a02:e8e:b0:c62:b045:9c6])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:681:b0:38e:c1c3:b1ed with SMTP id adf61e73a8af0-393ad33ab08mr4698774637.44.1770427433658;
 Fri, 06 Feb 2026 17:23:53 -0800 (PST)
Date: Fri,  6 Feb 2026 17:23:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207012339.2646196-1-jmattson@google.com>
Subject: [PATCH v3 0/5] KVM: x86/pmu: Add support for AMD Host-Only/Guest-Only bits
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-70528-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 4E26010479C
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

v2: https://lore.kernel.org/kvm/20260129232835.3710773-1-jmattson@google.com/

v2 -> v3:
     * Dropped the svm_enter_guest_mode() and svm_leave_guest_mode()
       wrappers introduced in v2 [Yosry]
     * Introduced a generic nested_transition callback in kvm_x86_ops to
       avoid confusing SVM-specific wrappers and unnecessary code replication
     * Fixed a latent bug with L2 stack alignment, which was triggered by
       a movdqa instruction in l2_guest_code() that referenced the L2 stack.
       Note that l2_guest_code() expects the stack to be 16-byte misaligned
       at function entry. It was not.

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

 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/include/asm/perf_event.h             |   2 +
 arch/x86/kvm/kvm_cache_regs.h                 |   2 +
 arch/x86/kvm/svm/pmu.c                        |  42 +++-
 arch/x86/kvm/svm/svm.c                        |   3 +
 arch/x86/kvm/svm/svm.h                        |   5 +
 arch/x86/kvm/x86.c                            |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/include/x86/pmu.h |   6 +
 .../selftests/kvm/include/x86/processor.h     |   2 +
 .../kvm/x86/svm_pmu_host_guest_test.c         | 199 ++++++++++++++++++
 12 files changed, 264 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_pmu_host_guest_test.c

-- 
2.53.0.rc2.204.g2597b5adb4-goog


