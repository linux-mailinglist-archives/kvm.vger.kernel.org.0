Return-Path: <kvm+bounces-29509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDA59ACAEE
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDD201F21388
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518951ACDE7;
	Wed, 23 Oct 2024 13:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="up3IwyMd"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A8B14D2AC
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689450; cv=none; b=rYbzl0kDM08R794trdRGwBYxwW8eAT7zl73nVi+YaAMUrX6gWmv5Bd4cSGXvIYlIwqewnSlwkSrPjNOOt0Xqg4KrU17mOWBgsMFYSmKwlroXJWJ1G+MTAu1R98iHGDf0ofOfwbyaGESAW7VRGwj/EcK7tzxdWxUN0nByQhBpWCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689450; c=relaxed/simple;
	bh=XY8XC+f+015iR5jNrhbsO8iF9wfNnGxN3MVqA41OaYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a42DdGh8qej8yYUU/bG1ZSScM5DrAOArK3CyrAqI3W1wYPgsj3H4F88vBYquhmjwZbtHJMiClz1qudERqavGIlgt7PjDnEe2Q6Rul8OOCoibrsDS9yDxJoX8FHD8RdvIQTt+Rqe0jgrya9B4N36cRbDTV157ito1gJR5WLygRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=up3IwyMd; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lZPwBMs7hy9HbGJzqbAYFNAsDsrWybNy8Qs2g3Lc1go=;
	b=up3IwyMdVOM7vxNGaMvujuYZ6Qqi5FhbgGVwBXFQNP/XC0/yBuFBMFpdbjJqR6aECHdygI
	zTfLOR4jYArwbhWjaQIuWoQ6XU81YIf0lTA6XVTxx1okETevzM2I/r7vHAjtWAxsfdBzuf
	TUH4Rzo9cJTlfo3GExOw9EUcUDw5twQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] lib/on-cpus: A couple of fixes
Date: Wed, 23 Oct 2024 15:17:19 +0200
Message-ID: <20241023131718.117452-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

While creating riscv SBI HSM tests a couple strange on-cpus behaviors
were observed. Fix 'em.

Andrew Jones (2):
  lib/on-cpus: Correct and simplify synchronization
  lib/on-cpus: Fix on_cpumask

 lib/cpumask.h | 14 ++++++++++++++
 lib/on-cpus.c | 53 ++++++++++++++++++---------------------------------
 2 files changed, 33 insertions(+), 34 deletions(-)

-- 
2.47.0


