Return-Path: <kvm+bounces-25745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8BC96A0DA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF4B4B25072
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EA913F43A;
	Tue,  3 Sep 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qfQPriaM"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE2C13D518
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374394; cv=none; b=U7v4WAYbjDltqREVs2PMwzZeuWaDiwKzQpSNkeNux7aRFoguvu3FW+GbL+ghJ6QMrnQuQIScOt193YoWofgg8I5MV2xtQAj+6CrBobpUjplM5lqtvsDeD/xEv8YoNWjko+shGBAAYJcGMNxEWm3uzhDcXdvhH0naKBa570s5w2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374394; c=relaxed/simple;
	bh=Q0jpZSdEq9UcPqSQtw8ICs4EGrluGAh7nPySsNoe7Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s5shR9+Z9JSi347iKCuKViikMnCpETq5Qhp1iZEhx6T6vVyqMXFLzuQ0xvFOQa69tDCYcN0E1gYBY6rp6XC3HvsuSUM+EDXy+jiormq6dtHiLhBRLrUNC9cEBeQ0rrqRFXW5P6eLdUmkHrlKe8B/Ta+XLYC0CF15gHvJ1CUOrVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qfQPriaM; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725374389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UoipvRa1rIlz02HbMk6/9TovCElSsYtUx+SlrCp58mM=;
	b=qfQPriaMG7F97zrrYRPeqmNAzZ2Fya7Tx/pPdqSt1GFpgUddaebwTjEIgXnEVgMXx9UAtj
	rtPDaZ3L84KS7pDp3kSEy4UmxXJrOBaUpqQG+3GKMvtaQHOHJev9H/ASPyhRExHSXUPKri
	ElCIqPlGyfKU0+3NNWojOHfKeSuUQwM=
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
Subject: [kvm-unit-tests PATCH 0/2] configure: Support CONFIG_* extension
Date: Tue,  3 Sep 2024 16:39:47 +0200
Message-ID: <20240903143946.834864-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

riscv already wants to change NR_CPUS sometimes, so a CONFIG_NR_CPUS,
which can be changed at compile time, would be helpful. We could just
provide support for that with the configure command line, but other
configurations will eventually come along (there are already two more
in another riscv branch). Add support for extending config.h with a
manually provided config.h-type file and also add support for using it
for CONFIG_NR_CPUS for riscv.

Andrew Jones (2):
  configure: Introduce add-config
  riscv: Make NR_CPUS configurable

 configure             | 17 ++++++++++++++++-
 lib/riscv/asm/setup.h |  3 ++-
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.46.0


