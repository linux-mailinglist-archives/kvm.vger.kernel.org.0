Return-Path: <kvm+bounces-70641-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PprGSA7imlkIgAAu9opvQ
	(envelope-from <kvm+bounces-70641-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 20:53:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A9D11441D
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 20:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A20E13020FF5
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 19:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7FE4266A2;
	Mon,  9 Feb 2026 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pRuUEjPq"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB8B3064A0
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770666780; cv=none; b=EmXj123YKF7W+z5HIq+ig78WPpTNW6qcqOX8MAfO+Bvj0JP2bTfv87rxef4jD7pMXcP03pJcbkF+xm6NKvLGNVmjXi1K7tBq2RoQ/AG26LlHv5+l8xmi8TL36/ETb8y8p/Vu8vrfVY/KbMZXlx5qsjtNHz9jo+9GCgNrObBBhRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770666780; c=relaxed/simple;
	bh=yQ0R5fxwrSYy6VNEOLO3WcTueLmh3QneitZBZOBSFO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZpDzKgzUjIY6v5grlS8QOwTi7ra6XBRiYUtNiaJxfzuYF4c0o87RLBMaeLV/y0WeFhKdCNVZSzI0PYe4WLuVv5YQ4AHysLHkxZzx/T4EASxcmiKJ+ZH8SVz5qbZdtlaSPYOcMb3NRgl2u3WKHLOVbUcL+J0oLnCHcZ1gWV6cGio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pRuUEjPq; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770666777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AjQeKuZtmqXTFuRHD9gtw3oJWd2azY9KRMLyRkeBjK4=;
	b=pRuUEjPqYjwmBDHSanKaHlOaihlr7PyxgjeTLpzL8h4sDdqsMOj3jkdyaO2IePhIsgLYaE
	9nfb2s/N87wj1ym+GMY9IMHn5vonmdu5CcQd8RstYyGNHUYdrn/RQcnU/oofayNaU5dfJt
	hF8hFABI9j3VP37sL3AIDPsXw/6RA6M=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 0/2] KVM: nSVM: Handle L2 clearing EFER.SVME properly
Date: Mon,  9 Feb 2026 19:51:40 +0000
Message-ID: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70641-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B1A9D11441D
X-Rspamd-Action: no action

Add more graceful handling of L2 clearing EFER.SVME without L1
interception, which is architecturally undefined. Shutdown L1 instead of
running it with corrupted L2 state, and add a test to verify the new
behavior.

I did not CC stable on patch 1 because it's not technically a KVM bug,
but it would be nice to have it backported. Leaving the decision to
Sean.

Yosry Ahmed (2):
  KVM: SVM: Triple fault L1 on unintercepted EFER.SVME clear by L2
  KVM: selftests: Add a test for L2 clearing EFER.SVME without intercept

 arch/x86/kvm/svm/svm.c                        | 11 ++++
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../kvm/x86/svm_nested_clear_efer_svme.c      | 55 +++++++++++++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c


base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.53.0.rc2.204.g2597b5adb4-goog


