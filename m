Return-Path: <kvm+bounces-61057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C55C07E95
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEFA7403295
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C62329BDB8;
	Fri, 24 Oct 2025 19:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vRrn5L9o"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B13202C5C;
	Fri, 24 Oct 2025 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761334194; cv=none; b=B6X1H8B2RASu4XDtfwnoRVa8lOmdwF1jIHGjoB0916+YPbXYzBMjy24eoAiuYW+pru6qCxaiSe3Uav+I80ScPZVFjlymc9hw9yiCLFr4t1677DR4Cyz6poCt6mKBRsuI8VjmaxMj675G6vC/KJQxxC2TEVpVXwr9/HSP4pGcqP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761334194; c=relaxed/simple;
	bh=j6nTx4YLsIGcLo4WocHsYeZfIBd0d4OpgI+FBObMtXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SHiPewqdqHSBCeykk4OKJGZEJXXGVPZ1HZlahRAyiUa+sVjrEAhunYO0aF7/i+w87rRQLs78EN8x7+eJVvXizODfhD4EoIqimDtrMN1UaNhnpQeCBrqGtHLaz1SjVOt6gJkrjAyWAaduV86ecYiE1Mr9pwNtawZTRUyNaKDPKBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vRrn5L9o; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761334189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CTOwpEZ2Tq/4XfOfqHmLyogG4/0bhJSgwH+nVLePT0I=;
	b=vRrn5L9oJEUe4dpxv+doTd+XXqm0AgOakBMw2E/SAOufRZPIvIO/7GcBdF+nQIC13wsAoL
	GfIh1yJJJaoGECIOyZMlZ0Ulf/wVKUO48wcHIt22pxjO/b4Gq3Hr9vT9/pq4gSODw7HXJL
	pD22ldf8ubkymTLx/LEQqCm4JVyR/dY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/3] KVM: nSVM: Fixes for SVM_EXIT_CR0_SEL_WRITE injection
Date: Fri, 24 Oct 2025 19:29:15 +0000
Message-ID: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A couple of fixes for injecting SVM_EXIT_CR0_SEL_WRITE to L1 when
emulating MOV-to-CR0 or LMSW. LMSW is handled by the emulator even in
some cases where decode assists are enabled, so it's a more important
fix. An example would be if L0 intercepts SVM_EXIT_WRITE_CR0 while L1
intercepts SVM_EXIT_CR0_SEL_WRITE.

Patch is an unrelated cleanup that can be dropped/merged separately.

Yosry Ahmed (3):
  KVM: nSVM: Remove redundant cases in nested_svm_intercept()
  KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW
    emulation
  KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE

 arch/x86/kvm/svm/nested.c | 10 ----------
 arch/x86/kvm/svm/svm.c    | 34 ++++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 22 deletions(-)

-- 
2.51.1.821.gb6fe4d2222-goog


