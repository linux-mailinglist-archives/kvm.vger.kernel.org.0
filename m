Return-Path: <kvm+bounces-64247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A78AEC7B898
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 239CE35355E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0313064B7;
	Fri, 21 Nov 2025 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mMeWsbl2"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C0D305E14
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 19:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763753557; cv=none; b=qIXJNLIKuESz91nJkCwOI4lFZ70/uu0w5uJJkeGfqe2YYFF8eSMBh2P3mgM5j8GJrswH7qfrqBDHP42/EydSosh48oxuZJalxzLWlsambmYZ0oT5TMsEOuVcjl+SFu3N7PJv+M0Kyu2FpZa42kY2oswyC+rropu2jJrFC9aUV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763753557; c=relaxed/simple;
	bh=P9jNJ6a3XA/UqRlZ8eGhGlpQjAzbM1XS+0upAlCrVd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HLMixy/SL5HfMEXGi2knX4pIh+fq9bZUxGOOfBPkcuCVqAPys0XYERWQaFOwTINnTzpLrZPasInvFsXo8q0KPP37rJVhnv/Skj0bk2zzqT1UhiRsl6nDwBweEEkeHR+LFZEsEKyH0CI4njqNWq5ZRsfwCRj1H8IGOuUKERzjUYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mMeWsbl2; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763753543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xr+O/n1EInaOTF07XuoTaSXKQkI1H4ZJzwKjfgbigFw=;
	b=mMeWsbl25KHS9MRNl2Hs/cZktY9qIupTtzvOwEqiKUU6ecpH8pn+3qnPCiC3vVg6QGh0zP
	LZsQwLtpUlvHsxxq4CmX72ULT/RZX1fxSM+5IoDp5dD/4Z5zvSIjSzbT5GXvYicqF45T52
	qjwyxUVML33bccaPrvmxQVl7vfFYsss=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ken Hofsass <hofsass@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/3] KVM: x86: Accelerate reading CR3 for guest debug
Date: Fri, 21 Nov 2025 19:32:01 +0000
Message-ID: <20251121193204.952988-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Some guest debuggers use the value of CR3 to attribute a debug event to
a guest process. Providing CR3 in the debug info makes this
significantly faster than doing KVM_GET_SREGS every time, so add support
for that. Also extend the debug_regs selftest to cover this.

Yosry Ahmed (3):
  KVM: x86: Add CR3 to guest debug info
  KVM: selftests: Use TEST_ASSERT_EQ() in debug_regs
  KVM: selftests: Verify CR3 in debug_regs

 arch/x86/include/uapi/asm/kvm.h              |  1 +
 arch/x86/kvm/svm/svm.c                       |  2 +
 arch/x86/kvm/vmx/vmx.c                       |  2 +
 arch/x86/kvm/x86.c                           |  3 +
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/x86/debug_regs.c | 82 ++++++++++----------
 6 files changed, 48 insertions(+), 43 deletions(-)


base-commit: d209f1ea367750edfcba7db8d199a856e4186511
-- 
2.52.0.rc2.455.g230fcf2819-goog


