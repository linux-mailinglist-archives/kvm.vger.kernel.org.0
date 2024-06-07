Return-Path: <kvm+bounces-19053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0764E8FFC7E
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF49C1F21D8A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 06:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12CF153565;
	Fri,  7 Jun 2024 06:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R/X4i8Uq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B583F1847
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 06:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717743151; cv=none; b=TOFkrPHKoyJWsryREePc228WylmUmM37Fo3NpFiYCOjSROV/tynOpq9TkCPnH8rdykyL0o0W8NaOtWc4d4cfEBxB9GgC3oRo9bsFDMGr439rSx+XALqynQ9X/Caam5RJL8a9VmQ3wNEqNBp56wpearvtyRU1oCe17DkbgogarZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717743151; c=relaxed/simple;
	bh=say0nCCt7hqDtN1L3soE819364JYKFcAh35R7okjzpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SYktPnSDo0kPK66XSitW/+pBcNBcqTGBQI1xjTEX0cWkqTIfUqmji0jQuplJLGtpCozmBW9SNdDHzfoHZ7ZitC+XrjI9tXmXHjpFwYLYeu5E6l1jpXn75VHdLgngQES2s/jlWXaTW5rXaTSnsU4CFcsRskfTwYW+jDCaCzjAetY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R/X4i8Uq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717743148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fDuvNyUUQJJeHkRGOgjdd0RDBjCz7mkEiq2Gc1+aryU=;
	b=R/X4i8UqTZkMJqZOHhM57KGdGjVkUtx45q45Om1F0ElXE8Z4luqybwAUCIHArXcxSD/kYW
	xb6pzJZvRn01sFpCERsjpAQGXhjasjX+JbjpO4XWBD3e/NIiqCbcw1HsyMaE7b5440h5RK
	59JpPvm1LcyXlTS02/+oxfHJN3I2xwA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-jw00deEvOJ6EsvN3Xv45lQ-1; Fri,
 07 Jun 2024 02:51:55 -0400
X-MC-Unique: jw00deEvOJ6EsvN3Xv45lQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2687219772D1;
	Fri,  7 Jun 2024 06:51:54 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.105])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 400C71955F14;
	Fri,  7 Jun 2024 06:51:49 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] Bump Fedora version to 40
Date: Fri,  7 Jun 2024 08:51:47 +0200
Message-ID: <20240607065147.63226-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Version 37 is out of date, let's use a supported one instead.

The "xsave" test now tries to execute more tests with TCG, but one
of them is failing with the QEMU from Fedora 40, so we have to
disable the xsave test for now.
The problem will be fixed in QEMU 9.1 with this patch here:
https://lore.kernel.org/qemu-devel/20240603100405.619418-1-pbonzini@redhat.com/

And there is also an additional problem with the "realmode" test. As
diagnosed by Paolo: "It turns out that with some versions of clang,
realmode.flat has become big enough that it overlaps the stack used
by the multiboot option ROM loader. The result is that a couple
instructions are overwritten." Thus disable the realmode test in the
Clang build until the problem is fixed.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 2af47328..b689a0c9 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -1,4 +1,4 @@
-image: fedora:37
+image: fedora:40
 
 before_script:
  - dnf update -y
@@ -216,7 +216,6 @@ build-x86_64:
       vmexit_ple_round_robin
       vmexit_tscdeadline
       vmexit_tscdeadline_immed
-      xsave
       | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -268,7 +267,6 @@ build-clang:
       pks
       pku
       rdpru
-      realmode
       rmap_chain
       setjmp
       sieve
@@ -289,7 +287,6 @@ build-clang:
       vmexit_ple_round_robin
       vmexit_tscdeadline
       vmexit_tscdeadline_immed
-      xsave
       | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
-- 
2.45.1


