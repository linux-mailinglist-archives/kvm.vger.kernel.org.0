Return-Path: <kvm+bounces-19050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B3D8FFC4F
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91A71283D49
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 06:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D2314F13B;
	Fri,  7 Jun 2024 06:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AqsernDW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2316E14F137
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 06:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717742183; cv=none; b=jGtd/ZuHJCkiIpL8pOI0miBNkKF54hF8a8O6q+VI7xhSr8OpjxG8S8WvxyLm++UIth8c5wyZ1YrxjCZ6XlKUkdpcqTaDaSWTczxNJsP4VGnjmAcip9GpyCmhjUvsZmgslGIw7hXy3RIaczwXaklq9rYHge/N0FFP9/nUzCnqDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717742183; c=relaxed/simple;
	bh=eu+tQpp/Pz+GkhY+cNg93sfuGpigqXGxkUUPZfjzSBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xk82z0ambHCP9HHWttACVBKzwTsydmYwGvfMugFYDGucRlentfw1D09tCEzVvxpSH7Ed1tWj/7n12fefTqGyDHy2ikMCQPENgUwSFJJjNVhjswa/QhwNp8c4e8D8Et0ttG9385DGMB7raH/D5cCrV4ZFk6omypecA8cITSyY4z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AqsernDW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717742181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QjUbr+xp1uX39yYlndG/O09JuDiQ+IMnyD2ESguybHc=;
	b=AqsernDWIgFKVCi9qCoIg7UlQc4OaHYDFUu8LA8AvKW955vXYizIGFgrwXchS/dU2AD9Zr
	2ba5R2CGFt/ZaLXM+Pi1Jvr9mTGdrxzufmxkPdx37ONay7NBcihJL3SrOOpNB6Qf3ioN0n
	78aUPTNuhNVS4YHTRn5cWZK/udJBkpA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-IZYwhgWaP--1NM_irPHjXQ-1; Fri, 07 Jun 2024 02:36:19 -0400
X-MC-Unique: IZYwhgWaP--1NM_irPHjXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A27B101A520;
	Fri,  7 Jun 2024 06:36:19 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.105])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A2BE71C0A92B;
	Fri,  7 Jun 2024 06:36:17 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Nico Boehr <nrb@linux.ibm.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci: Test that "make check-kerneldoc" does not report any errors
Date: Fri,  7 Jun 2024 08:36:16 +0200
Message-ID: <20240607063616.60408-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

To make sure that we don't regress with the formatting of the
comments, we should check this in the CI, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 23bb69e2..2af47328 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -310,6 +310,8 @@ build-centos7:
      setjmp sieve tsc rmap_chain umip
      | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
+ - make -s check-kerneldoc 2>&1 | tee docwarnings.txt
+ - test -z `cat docwarnings.txt`
 
 # Cirrus-CI provides containers with macOS and Linux with KVM enabled,
 # so we can test some scenarios there that are not possible with the
-- 
2.45.1


