Return-Path: <kvm+bounces-73162-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yK5gMoxCq2nJbgEAu9opvQ
	(envelope-from <kvm+bounces-73162-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E559227BA6
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5903D3066405
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00CD8481FAF;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqElTuRG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3439A36B057;
	Fri,  6 Mar 2026 21:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772831351; cv=none; b=tazio8zV9p9GyEr2yBF5/AUjCKK0dFY40bZoBGvEVG13bmE9qBvKcfKiIkPMwa/prubq8vrgUi0hvWL2q6ZozlBT7yvMd0KvToNJ++xICCbvi3t4G5Ljfg2kFgBhrNGyFW1vUvIHIpbkUYXjGBf1Xr5SDASpmk7ny8ZZ6tqZgdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772831351; c=relaxed/simple;
	bh=oMTna8fTN/AUI8Gwi/r8nTVI+mrYH9D4ZvGDXAhtybQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l4hf6N97peiIbDcIa4e8mewhlwrgbIIBjrc6z9uuzkrShMkzTnbjm27vvcBLAWZYvkEI2LrkfBfleF7tHQcp1I/bTVT72sKxxDXJ68Suy3H73UV3+mV5dOzVI3S6sjw/GSKgmHVhKetfJI6SsHoxmarSQ7rOqJz7THhggmTVbnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqElTuRG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE54C4CEF7;
	Fri,  6 Mar 2026 21:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772831350;
	bh=oMTna8fTN/AUI8Gwi/r8nTVI+mrYH9D4ZvGDXAhtybQ=;
	h=From:To:Cc:Subject:Date:From;
	b=mqElTuRGEn3N6/9B3gIwAc0rROVs0X4lUDZUTX2HG9kUe2xNprCz0JjsMZvHaL9Jr
	 5d9F5yUKjaHSb9tFtknRDt9zkBJieQ15oYlHQQN9rLzkFYZ0RFwvr4ywE+7PJWlS0s
	 VpezIEoEHYQocDHCjUNS1u9cVTlZfwiBAsU0RxbkySe1u80eeGxPOQivvL9Wi8ushO
	 SIRtT1prx0xr6cLPgX22D6JgWZZ7hBt1wIYgfZXotfwP+NSNUWlkOVoZ8Ti09JuwkE
	 H+ICjAUFNOM1waoPS9+1mL40FT40uqEk6sYzXuX9IFYRFy/Qpw1MbyAT8mEWdbuEA1
	 GPh16TQV7a6bw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 0/6] KVM: nSVM: Fix vmcb12 mapping failure handling
Date: Fri,  6 Mar 2026 21:08:54 +0000
Message-ID: <20260306210900.1933788-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E559227BA6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73162-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.986];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Jim pointed out that VMRUN/VMLOAD/VMSAVE injecting a #GP when the vmcb12
GPA is valid but not mappable is not architectural [1]. The series
handles them as emulation failures and (mostly) exits to userspace
instead.

With vls=1, a VMSAVE/VMLOAD with an unmappable GPA will cause a #NPF and
be emulated. The emulator currently hardcodes the GPA check to 48 valid
bits and injects a #GP otherwise. Fix this to only inject a #GP if the
GPA actually exceeds maxphyaddr, and otherwise fail the emulation as
well.

Rework svm_nested_invalid_vmcb12_gpa to fix the fact that it's currently
testing #GP on VMLOAD instead of VMRUN, and extend it to test all of
VMRUN, VMLOAD, and VMSAVE in both cases of GPA > maxphyaddr and GPA <
maxphyaddr but unmappable. Finally rename it to make its name a bit more
generic and representative.

This is not strictly a v2, but it supersedes the series at [2].

[1]https://lore.kernel.org/kvm/CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com/
[2]https://lore.kernel.org/kvm/20260305203005.1021335-1-yosry@kernel.org/

Yosry Ahmed (6):
  KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
  KVM: nSVM: Simplify error handling of
    nested_svm_copy_vmcb12_to_cache()
  KVM: SVM: Treat mapping failures equally in VMLOAD/VMSAVE emulation
  KVM: nSVM: Fail emulation of VMRUN/VMLOAD/VMSAVE if mapping vmcb12
    fails
  KVM: selftests: Rework svm_nested_invalid_vmcb12_gpa
  KVM: selftests: Drop 'invalid' from svm_nested_invalid_vmcb12_gpa's
    name

 arch/x86/kvm/emulate.c                        |   3 +-
 arch/x86/kvm/svm/nested.c                     |  20 +-
 arch/x86/kvm/svm/svm.c                        |   8 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   6 +
 .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   |  98 ----------
 .../selftests/kvm/x86/svm_nested_vmcb12_gpa.c | 179 ++++++++++++++++++
 8 files changed, 200 insertions(+), 117 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c


base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 
2.53.0.473.g4a7958ca14-goog


