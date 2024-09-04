Return-Path: <kvm+bounces-25843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A424C96B93C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 615582882B2
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D24F1D04A3;
	Wed,  4 Sep 2024 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EFbICRFV"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF583612D
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725447028; cv=none; b=lsoijOCn4wvUlKerwqO934x2E9U3Ni44kZ8HIp3e7tplRlg8xEXQwQiMUwNj2SnWNzyIV4PnuYPqwGZ1HltyVVKdx9mux3otJx5oCxVc+R0Ad+zZgGSm38AxZ1dXGhgsofIAxr8BKAHIMYfMaz1A3oMs9obk8pjWueQJhQbRa+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725447028; c=relaxed/simple;
	bh=sEuKPtqYHBL0OQ8kh6UQG6Xi7tkjFRJXzncitRYwtjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XD95ps9OoK5WPs1WVeamq29fIpBLMdAd1bJkLhmCC7kmH4p8ZAIHvn5ZK+ySPuJwlwrthuTTPVdXGFIvLECZ6d99aoRcxv8IC0d/n9mbhBulvT19ShyyYw/tp48UDGckraHUYS+YCfXf2qChi+E6Xor8xdN/4SoXFv4r6sAhybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EFbICRFV; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725447024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mriS1H0sJTSVPaDrzCARMiATA5eWDief//MW7qUXAF0=;
	b=EFbICRFVSqlYITPSXqcNWPA0WOazR4AJIycYCljwu7mNHiJFebjXOtL5fzFKuZYVoKO9Cd
	pOcp3gcZ48wUuLBSpa1aOPsCbNaq75WpYmjB7vvlrqTDN/cGmY7FPpiWjkpJ26p+8tfK7G
	tE8sDUQ3EV8W3bQqkYlCr4uyaDo6fps=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	lvivier@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 0/4] Support cross compiling with clang
Date: Wed,  4 Sep 2024 12:50:21 +0200
Message-ID: <20240904105020.1179006-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Modify configure to allow --cc=clang and a cross-prefix to be specified
together (as well as --cflags). This allows compiling with clang, but
using cross binutils for everything else, including the linker. So far
tested on riscv 32- and 64-bit and aarch64 (with some hacks to the code
to get it to compile - which is why there's no gitlab-ci patch for aarch64
in this series). I suspect it should work for other architectures too.

v2:
 - fix building with clang and --config-efi by suppressing a warning
 - added riscv clang efi build to CI
 - picked up Thomas's tags

Andrew Jones (4):
  riscv: Drop mstrict-align
  Makefile: Prepare for clang EFI builds
  configure: Support cross compiling with clang
  riscv: gitlab-ci: Add clang build tests

 .gitlab-ci.yml | 43 +++++++++++++++++++++++++++++++++++++++++++
 Makefile       |  2 ++
 configure      | 11 ++++++++---
 riscv/Makefile |  2 +-
 4 files changed, 54 insertions(+), 4 deletions(-)

-- 
2.46.0


