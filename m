Return-Path: <kvm+bounces-67824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD4AD14C14
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 246AD30FDEEA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6275F38736C;
	Mon, 12 Jan 2026 18:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SZo7pmPd"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6023806D9
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242082; cv=none; b=TmcT5TeEt/5Zlgsc/LhsUNcrqJMGJlyw88r+gCrfd9FQbxB/Bp7d3s6mm0HKbK+/A69imwb5OpFSpDGR4sbjDEI8rsc1YmsOUDfX+bOUvtw053Ui6rTk8ro5TF/kZK54tE6NCtqRuoJGP/VFPe17O5fXvmyu80Z2ghf5Wh4b2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242082; c=relaxed/simple;
	bh=b752Bz0LgkdGH5+II6JiAm6+ufd4tNe9qeFo7d2eRXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Th76XAiOoP+33d2qY0SVAIica/86pJnk+vQJH8YiFoey9cSDNUfBZ/TC+ieh0YRQKLZtKgvfzXbpx2hiXs480ter4/qiwDmx01H3HC0o4gwcTSTu/FReHZuv46KQkk/63zKDsDdZpJ4GOdV7je8laC4LwWlnc3t8kUcpGs8BIDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SZo7pmPd; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768242059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OkLAw2Vw0ZUP+CvCQijJOLl9X6oTTN0rb3YRLu73UUY=;
	b=SZo7pmPdZsX0UVnuaxI/gmSMHjEPjSMfoRpZeU8odL88wQt+8BIMt1Hs86G1TqchxKC+Vy
	K/5kN5BFiTNKG6WJHDeky845FTbaWyNjK1WhKczp55aV1lIsQ96+v+XbUyXBjh8vkkZWSk
	Ngrh6lTbP17b0uZ1K0dQx5CpMixtV2E=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/3] nSVM: Minor cleanups for intercepts code
Date: Mon, 12 Jan 2026 18:20:19 +0000
Message-ID: <20260112182022.771276-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A few minor cleanups for nested intercepts code, namely making
recalc_intercepts() more readable and renaming it, and using
vmcb12_is_intercept() instead of open-coding it.

Yosry Ahmed (3):
  KVM: nSVM: Use intuitive local variables in recalc_intercepts()
  KVM: nSVM: Rename recalc_intercepts() to clarify vmcb02 as the target
  KVM: nSVM: Use vmcb12_is_intercept() in
    nested_sync_control_from_vmcb02()

 arch/x86/kvm/svm/nested.c | 37 ++++++++++++++++++-------------------
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  4 ++--
 arch/x86/kvm/svm/svm.h    | 10 +++++-----
 4 files changed, 26 insertions(+), 27 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog


