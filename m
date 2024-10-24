Return-Path: <kvm+bounces-29631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB119AE534
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:42:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5C34B22CC6
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E48C1D63FD;
	Thu, 24 Oct 2024 12:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FXzi85hm"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B99B1D5ADD
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773673; cv=none; b=ksaoULZzz4Yq0b9lLISWQYMvn07gVwhXi0ZQQpCo+tqgkCY7yjXERb1NKfCV1NsQLP2HTe1O+6pSMMcsxPmDjD3w9wni7y7SHot/yMtYHYMchvbFrlcoj3/5OGxS7CwZUSUfi/XkLYJRZ/xseA6A6e6fjP34Yl352l0BNgUA880=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773673; c=relaxed/simple;
	bh=rx/JVRl/uPYVxwoThydcTFOODyMkbYLoHr1ia2cpz/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tx+zic+u9g9OWEofGoB++YVNG2br3S8qwaAtC2cPyz1fpKysMgLdSDZ2EMQld2edIdjvC326okph7p7g1isPCEtzA3cvoIiDaOkcebQahmurATe4AEGvW+bqbSBHxtjp9a2j5wGfF9+HKVg5gQxz4f313bIy/k+CaArOE5PL07Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FXzi85hm; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729773669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KolLfOhyrnQ5fSHFNL2AMGTITVwnzdvUxuSFTMTkcuI=;
	b=FXzi85hmEU4gzN76x2OmG35WgAPuCTCVWnyaCH3yGrxq8tM0R21GopInueokLuCvC8+zAg
	gFcUtnRzg+gLZpTYeh6WnHOGJYNOB92wuQ1c+SrEtzEG99ASQ6RvK9vhPZey0EX2WpYL0Z
	l+9m10R6ol/iM9A8ScVI5UXLbr7xVTw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/3] riscv: sbi: Add SUSP tests
Date: Thu, 24 Oct 2024 14:41:02 +0200
Message-ID: <20241024124101.73405-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add tests for the SBI SUSP extension.

Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Andrew Jones (3):
  riscv: Implement setjmp/longjmp
  riscv: sbi: Clean up env checking
  riscv: sbi: Add SUSP tests

 lib/riscv/asm/asm.h |   3 +
 lib/riscv/asm/sbi.h |   1 +
 lib/riscv/setjmp.S  |  50 +++++++
 lib/setjmp.h        |   4 +
 riscv/Makefile      |   1 +
 riscv/sbi-asm.S     |  55 ++++++++
 riscv/sbi-tests.h   |  19 +++
 riscv/sbi.c         | 308 ++++++++++++++++++++++++++++++++++++++++----
 8 files changed, 417 insertions(+), 24 deletions(-)
 create mode 100644 lib/riscv/setjmp.S

-- 
2.47.0


