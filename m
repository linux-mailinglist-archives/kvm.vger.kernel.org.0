Return-Path: <kvm+bounces-71935-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLp/Hcj5n2n3fAQAu9opvQ
	(envelope-from <kvm+bounces-71935-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:44:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 202C81A1FAF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD687302BDDE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89FF38F948;
	Thu, 26 Feb 2026 07:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="aqGeQxfs"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA49F346AD5;
	Thu, 26 Feb 2026 07:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772091830; cv=none; b=Tv0uiYzgvT2B9rOMl4RQK67TpBvf3ht7/2algrqaYgrz2ewk6qUnooxcQLWqNxt8HfM1axo+Ekx1MTxCcAWki3nKpWtScG/+BJBy2UMxksX49cMh+YrzeVRcnFL/njtW9oLxiRII8Ssn2u5y9bT6DXBtATdYNed2oD7YLBglUic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772091830; c=relaxed/simple;
	bh=8sZgpxpXNF/Wg74hlM+C1pJT5h/2MVixhIk41gLcqZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sm4xy2LSZAGwekrF9Ay4GxV3H3gkyXygZP74OVf8NU9QvLPQWMYgqKOwjikvNJswo1KQUotc7Lg917FKJyv4nwkKOWsqnzdp+BaaNR1W7Lb5167k7frD5/Yy0Pb0f7pglGYlHBd37gnfXk1R6U6FfVBn8MGtdKCFKfVMqCae5Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=aqGeQxfs; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1772091829; x=1803627829;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=blmN2EVZYJX9S4DrIUUWQL7NQsdDK+HUJ0tjuMzQ7pc=;
  b=aqGeQxfsWN27BeDY23VyInD/eCvI4oUSXu3CyL3xuEv8VEqDzYqIM67c
   niaUgVe2T3NTamjnDV4rdTFrLbahR8bOe9rlpl2JgPzsx5/Mg+j3RqlQh
   nmT3fLpJruGWOJYxHm+m7qr9yWF0eJqrpGEOzktuTwAmc6TdtxZio3evt
   TlXNJrGzvSsgi8mD5AOhQyGnt7DmfJ4bgW6ztzgraW1FQSZL+5SdLNe0I
   nJctYhPJoOfTv/ubl0d8OHOyA5Ho1vZLHOvHNIky38Y0novlF5X5vB3Ew
   UF3JcQk4toIk6khV1ftraag+XwunAJI3+h/AJZGnQLgMVj1HuyD2o7VY2
   Q==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 16:33:39 +0900
X-IronPort-AV: E=Sophos;i="6.21,311,1763391600"; 
   d="scan'208";a="616141174"
Received: from unknown (HELO asagi..) ([43.11.56.84])
  by jpmta-ob1.noc.sony.co.jp with ESMTP; 26 Feb 2026 16:33:38 +0900
From: Yohei Kojima <yohei.kojima@sony.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Yohei Kojima <yohei.kojima@sony.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>
Subject: [PATCH 0/2] KVM: selftests: Add test case for readonly memslots on x86
Date: Thu, 26 Feb 2026 16:35:07 +0900
Message-ID: <cover.1772090306.git.yohei.kojima@sony.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71935-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yohei.kojima@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[sony.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sony.com:mid,sony.com:dkim]
X-Rspamd-Queue-Id: 202C81A1FAF
X-Rspamd-Action: no action

Currently, there are no x86 test cases to verify that read and execute
on RO-memslot succeeds, and write is blocked as MMIO fault. This
behavior might break if changes are made to the MMIO path, because
x86's RO-memslot relies on the fault propagation mechanism for MMIO.

The first patch adds a function vm_userspace_mem_region_add_map(), which
is essentially the memslot setup code extracted from spawn_vm(). The
second patch adds an x86 test case for read/write/exec on RO-memslot.

This series is developed based on kvm/master, although this series adds
a test case for x86. This is because the first patch changes the
spawn_vm() function, which is used in the tests for other architectures.

base-commit: 0de4a0eec25b9171f2a2abb1a820e125e6797770

Yohei Kojima (2):
  KVM: selftests: Extract memslot setup code from spawn_vm()
  KVM: selftests: Add test case for readonly memslots on x86

 .../selftests/kvm/set_memory_region_test.c    | 147 +++++++++++++++---
 1 file changed, 129 insertions(+), 18 deletions(-)

-- 
2.43.0


