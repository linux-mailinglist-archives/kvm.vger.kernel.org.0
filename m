Return-Path: <kvm+bounces-68817-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLnyCGtZcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68817-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:55:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7C85F216
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 16111740A7C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D6344CF46;
	Wed, 21 Jan 2026 22:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pLOO+ndm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92293D7D69
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036110; cv=none; b=c3OJZQsFUEN5rVto230wrzu4DAi20/9AYd2KNTC7tNRDiLsnKPWPrIp3WHTsSEsMMTZFYfoiNDFR2j7i3sqVBGPjZQixJkZ66EzpuoiB6w+b6iWZpnxictcAWZF/Qt4vG07HrpW8uJjYrYntihNwMjXVSCq//50M55FuYubVZ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036110; c=relaxed/simple;
	bh=4dK1i0Y+ClhECekgpZBpaR5BRwtTPOuDhSyrvTfYzBQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nuHRS6v0gXNpMzh9tFPzNsLl9cfAwRCjcif20Hd+02rkU0xD2iA5THji30777GaKnIXAl7AA0rlhGy8nmj1PpIPRrSs3CbE6nsxNMMBjHtO9m9wkROPjpNJ53+eXp3WuLK9k1PiHkys69CGI/nqCQZRwJI2d2RX+SL+eUllSmxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pLOO+ndm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a75ed2f89dso2548495ad.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769036103; x=1769640903; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IwnAqV7nleR6mcHb2XFaN1DmqlrQfEeG7PA5eyhEQis=;
        b=pLOO+ndmpMe77IKhNkoxXLSYytpNK+ONqGNntmOPk9DsZ1E6ATI9VSrdeN8zTlQz9S
         vx+doZm3ah8lIIADFCUOHXXuUaK9PwJZksD9hakbsMGgRrKG2nkRSM7GliCVYMEqasm+
         jF0/WiUdzY0hFRjGym+DNlzgVPypyhvnsFr76ovu0QIAJNVohkxuiE4WGNnxDO+N8zKB
         rFHfRdk4xtq3GwsEUwIpO2jGMylhG3fGShyvdFtFiZc6Pc2rDkrS8nwTBvEdwrCO8WbT
         4n0w0geiKlAG4ZrqfK6vaoRYBgSfr+76Pg2VK58sTy1Rpw66n+Qr60R6475bqDwbfu+6
         p7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769036103; x=1769640903;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IwnAqV7nleR6mcHb2XFaN1DmqlrQfEeG7PA5eyhEQis=;
        b=MuHzC4QzJK4WgB12zmqmvoPWRAQKArf/xEGOPfZtWoc0Ux1kcrj3j0MR7309xQnZuf
         BJJRZChOz3eqAeZqOiljD4s6J6XJJC2l8CkLdz/60BMoI7kjbyW20Za2oIuILdLzaKPD
         HgRMNd/2KxAVyG6NsTTuG6ZRjNH92zPI0eZ/feCAeX/6Nz5FL08JypOSmkxga96ueOH4
         q8WY6taHxqFaz/g/eEoZS9EA4VdMRtoRG6uNsLQT/rZOflcB8LkDF0A7B8I6LMAeVWA/
         ksJ39JmzG5fwQFpxOyf0nc62/rjdAnJZkIuyNTYAOhFiLDkfCarcA47NdbTc5opWpAog
         bAdA==
X-Forwarded-Encrypted: i=1; AJvYcCVwKKUr8RhqTTuiq14ZX51aklrFwi4qMFzDvCtPySOt8K6ibG56qlOqypZCroU8sNes7N4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSKd4hAKpwQC5J1ymlH4scQSogsSqK6oAkBs303HVbAFwxx2FU
	ehkjsb2tKmfTSXfRuODXHGpQd72swYqYgqCbpH/RhyFliLXR412bmh3OrcN2jKZmHJEpgEBxhym
	vbQ4YgbdwcQhZXQ==
X-Received: from plbkf12.prod.google.com ([2002:a17:903:5cc:b0:2a1:36d4:7f2f])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef4f:b0:2a7:8bf3:4656 with SMTP id d9443c01a7336-2a78bf351camr42414165ad.8.1769036103212;
 Wed, 21 Jan 2026 14:55:03 -0800 (PST)
Date: Wed, 21 Jan 2026 14:53:58 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121225438.3908422-1-jmattson@google.com>
Subject: [PATCH 0/6] KVM: x86/pmu: Add support for AMD HG_ONLY bits
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68817-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 8C7C85F216
X-Rspamd-Action: no action

This series adds support for AMD's Host-Only (bit 41) and Guest-Only (bit
40) performance counter eventsel bits in KVM's mediated PMU passthrough
implementation.

These bits allow an nSVM-enabled guest to configure performance counters
that count only during L1 execution (Host-Only) or only during L2 execution
(Guest-Only).

KVM tracks which PMCs have Host-Only xor Guest-Only bits set, and updates
the hardware event selector ENABLE bit at the following state transitions:

  - EFER.SVME changes: Enable/disable Guest-Only counters
  - VMRUN: Disable Host-Only, enable Guest-Only counters
  - VMEXIT: Enable Host-Only, disable Guest-Only counters

Jim Mattson (6):
  KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
  KVM: x86/pmu: Disable HG_ONLY events as appropriate for current vCPU
    state
  KVM: x86/pmu: Track enabled AMD PMCs with Host-Only xor Guest-Only
    bits set
  KVM: x86/pmu: [De]activate HG_ONLY PMCs at SVME changes and nested
    transitions
  KVM: x86/pmu: Allow HG_ONLY bits with nSVM and mediated PMU
  KVM: selftests: x86: Add svm_pmu_hg_test for HG_ONLY bits

 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 +
 arch/x86/include/asm/kvm_host.h               |   4 +
 arch/x86/include/asm/perf_event.h             |   2 +
 arch/x86/kvm/pmu.c                            |   9 +
 arch/x86/kvm/pmu.h                            |   4 +
 arch/x86/kvm/svm/nested.c                     |  10 +
 arch/x86/kvm/svm/pmu.c                        |  84 ++++-
 arch/x86/kvm/svm/svm.c                        |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_pmu_hg_test.c       | 297 ++++++++++++++++++
 10 files changed, 412 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_pmu_hg_test.c

-- 
2.52.0.457.g6b5491de43-goog


