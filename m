Return-Path: <kvm+bounces-25774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 036B996A463
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B57D9286DAE
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFB718BBB5;
	Tue,  3 Sep 2024 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fnHXhWjW"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A84D18BB9F
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725381066; cv=none; b=OaZw/HKMSXC7nfrE8FipJ1YHia/Blg9/9zGz0RW36kQFli4+iaeiMv8UMan8ygQEfy0DNDWmTOTMLuF2PG1l+QskPB6V5ZA9/XSTfAZuhoDgodSSSPw4RMuXbglt3lfGQx6PZJKZVwHWkBJmmb7bvKsnqNmWtO7RNlEcQl0uxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725381066; c=relaxed/simple;
	bh=1e2PJ9C4cSjp3/AMqt3JlJ1Cx1fmp2V4q5C273sWOSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGyYZ8XVTt2aIPn6eBazO++mqTMIrYZP8eYz+NzhQ8mO3iYZiUVmMLjRwPtwkItg6bwhPTNOYbDolQdPk43HTXSlnTfBeaEhP4uBFOVORQDSikBBXFPvqbYmir7OBbHMNXizl2uLTkV33P21ye209eaVJSw7689fW+d5pqbWZvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fnHXhWjW; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725381063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BZJkoNgFN6URY+7lN/rD+PAMiteNcprRb2IpocXJAk=;
	b=fnHXhWjWeEn3rcGrQ/Z+7smSSzd/z9fh1Rnug/H9guDSc4s33GknopNiQVzNKy5PuQFyIs
	lUoEGLn1k6hs+3yDmWrR2nEIJHY1TctbeZQLU/9yK8DdjZ8Q7W4H6vDdr228KqSUmG7Lmz
	ed4VefAucFdC2jsCKGcgx0TDyicuR/4=
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
Subject: [kvm-unit-tests PATCH 3/3] riscv: gitlab-ci: Add clang build tests
Date: Tue,  3 Sep 2024 18:30:50 +0200
Message-ID: <20240903163046.869262-8-andrew.jones@linux.dev>
In-Reply-To: <20240903163046.869262-5-andrew.jones@linux.dev>
References: <20240903163046.869262-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Test building 32 and 64-bit with clang. Throw a test of in- and out-
of-tree building in too by swapping which is done to which (32-bit
vs. 64-bit) with respect to the gcc build tests.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 67a9a15733f1..033ed65aec26 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -176,6 +176,34 @@ build-riscv64-efi:
       | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
+build-riscv64-clang:
+ extends: .outoftree_template
+ script:
+ - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu clang
+ - mkdir build
+ - cd build
+ - ../configure --arch=riscv64 --cc=clang --cflags='--target=riscv64' --cross-prefix=riscv64-linux-gnu-
+ - make -j2
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\nMARCHID=0\nMIMPID=0\n" >test-env
+ - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+      selftest
+      sbi
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-riscv32-clang:
+ extends: .intree_template
+ script:
+ - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu clang
+ - ./configure --arch=riscv32 --cc=clang --cflags='--target=riscv32' --cross-prefix=riscv64-linux-gnu-
+ - make -j2
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\nMARCHID=0\nMIMPID=0\n" >test-env
+ - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+      selftest
+      sbi
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
 build-s390x:
  extends: .outoftree_template
  script:
-- 
2.46.0


