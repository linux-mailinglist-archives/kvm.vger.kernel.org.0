Return-Path: <kvm+bounces-69655-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cK5xJJ8SfGm4KQIAu9opvQ
	(envelope-from <kvm+bounces-69655-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:08:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB7FB6536
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 690863011F25
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF6D2F0C49;
	Fri, 30 Jan 2026 02:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FthNu7zV"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D8D21FF49
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 02:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769738901; cv=none; b=tkhXFheehQxQ0fDP/mLRuZ2wrb5FTffSSI29ZGo8iyt8HctUZB2KgnQ1w47RZVRS29+VZUruLZmqNmrFlQNIsUndI7xIY3aKyxCOtGkdUPrlAB4pCndxwgMkSoCzEAmgiPksotuTJVkX7jcYagVRvAPCeivHFFiWMWoC44yRv2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769738901; c=relaxed/simple;
	bh=OgacTcHqVNPt77tiFMVqPpAcMafRFYIcKmffeSRE9Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mbh8oNDhW6QyLhWPyR+0MWZMtH01WZr1tYEFbSyZYxp0jl2P2jAd7TDyjxXQUEHBJSPetSBxz2vhng36MBGii3e3EpcMqUADDn96HBXwm8FkZzGyOadHGz+6TthGzJTH+xnRPRmQ5pEHz67ViYFRiBfNDM2ngpJ2EuBGlIm+G64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FthNu7zV; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769738896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rij+lw7784FhR4mnutSqr3sydrwUO+t7hZTEO5VM4VY=;
	b=FthNu7zV8sJwUCobwWZ5QGtsfxYu43ibM9Bwv0GLI9kJNC2f9Z1qU/zNJELS02/89jKze1
	sBo+0iH62cIpTiVMWpsmFZlN0lqqfVZhF66faqFpt840hGfQr8/tE4lcHqeRa5IoF62Jz0
	htBA/xY/ITD8d7bUwcnZ5lOuHqT1HCg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/3] KVM: nSVM: Stop tracking EFER.SVME in guest mode
Date: Fri, 30 Jan 2026 02:07:32 +0000
Message-ID: <20260130020735.2517101-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69655-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DBB7FB6536
X-Rspamd-Action: no action

Fix a bug (although not architecturally a bug) where KVM leaves guest
mode and tears nested state if L2 clears EFER.SVME and L1 does not
intercept it.

Yosry Ahmed (3):
  KVM: SVM: Refactor EFER.SVME switching logic out of svm_set_efer()
  KVM: nSVM: Do not track EFER.SVME toggling in guest mode
  KVM: selftests: Add a test for L2 toggling EFER.SVME

 arch/x86/kvm/svm/svm.c                        | 79 ++++++++++++-------
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../kvm/x86/svm_nested_toggle_efer_svme.c     | 76 ++++++++++++++++++
 3 files changed, 126 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_toggle_efer_svme.c


base-commit: 1a424e9e0616db91010f08e5985bcc6edc504205
-- 
2.53.0.rc1.225.gd81095ad13-goog


