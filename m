Return-Path: <kvm+bounces-25771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D6496A45C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 763E82878D6
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A74A18BC13;
	Tue,  3 Sep 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wCxhUgXy"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B011885A0
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725381057; cv=none; b=IuaIrUBSvi9v4Ssv3nwm8lvtULTrx3Psb7A7dixZoWwRgBKLXS7V5bhnE2HWrWiUtxCMxmxM6MHx9Dhw9WGoi1jHJ47oXq3VCWwOIyhKN3mXTvHBwYjJpmAqEZFIxYzzzEDa0greUCC4NuM/Q6CBXi0zMKierCiUyeLh7JY9SgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725381057; c=relaxed/simple;
	bh=DVNaHrhGdeeNDyxAyeSdLv3wZlzpfgoOzo7WchAjbq8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xem9XZPPqv77phe6EIhq3jXlwhnBrqPmnMrWIhp5mZm96Jk3GIxBmgBjEJlppWzJNXCNBz5OskyYLwOVvkxtyUkiqpleFknotV/GYeK9idcS124hZunU1Sj1PSjInz1Y5KCYX3zhQ8p/JmxZcZLUo8iOAkiw83ztYFESvC+mB1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wCxhUgXy; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725381053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ItTT1ofl67Qx6qoM/paB6gC9h88l9uMn+lTF4xll28I=;
	b=wCxhUgXywgh+iCSp5MYg6y1jvSHm2x6diiCwreF2/QMspOI24IUZvviIXnFNZ11wawMDci
	3Nz4MnXUCSaklvWm8V8TqnIff8oAwwCmd2J9Q1zJGal5hQB0Dr6SHRgUOONajgn4bpxXSB
	+z8T3JToDc0X+uzmbf5/QTNUkjfaPYU=
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
Subject: [kvm-unit-tests PATCH 0/3] Support cross compiling with clang
Date: Tue,  3 Sep 2024 18:30:47 +0200
Message-ID: <20240903163046.869262-5-andrew.jones@linux.dev>
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

Andrew Jones (3):
  riscv: Drop mstrict-align
  configure: Support cross compiling with clang
  riscv: gitlab-ci: Add clang build tests

 .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
 configure      | 11 ++++++++---
 riscv/Makefile |  2 +-
 3 files changed, 37 insertions(+), 4 deletions(-)

-- 
2.46.0


