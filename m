Return-Path: <kvm+bounces-22325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 168C393D47E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C05B51F248A2
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079771E536;
	Fri, 26 Jul 2024 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jN1wgmon"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75151E51F
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001552; cv=none; b=aPPf9dftDIUJGe0uRLbnmGgP5x5NJLix6Zn9CXpXbTuf3OTg/t+ZqtkWym8odW4hSOkxawwlqNaRSzvr7stPlwlDiqIGjfSMPzS14QfpBAadNQkh3VUNkYjXfJwszh6EXL0NGhfr4K/bngREWuYw/PBnjVOMrebyELcwp1ni3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001552; c=relaxed/simple;
	bh=stN7LSPeJfpeO6AjTu74XONPO2TxufjVsVOgft4YlMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtQ5GHQRAkAihxgJJ/M++c9bMsjexdB9NUjRp/8TGzzr0Oe4OueWt88N4o0/g4JJQSjqpYSa2RG0qImY7FmcFoEW//VJ4Njwr/m3ujqhvkkx0FElAshwaZ7ibqEQamEiuZ80JwIe4nCsyyZFsV3Kxeg5d1UOtikhPg7X2fnNsKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jN1wgmon; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=22aK5G9Gu9BLJGucdCy0aPoPQpR5xm/lyRWYWqyAjJA=;
	b=jN1wgmon9cPb5i+f9/vzA8nlXJYIumD3eaHXFqH7s2/QPoZLD4Xmy4Kepv9W13BC1cbuLn
	mTkayTjgV9+YfgGMh8BBVdH1UBrDNaHPzkxYhwSlt18+Rfv3pYXlwObElfRe6ksfbZ3b79
	QJf/B7Z7U8890JqBrjvI/15gEC0bTOs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-1NnmSBVsP8KgRivKXZD1fA-1; Fri,
 26 Jul 2024 09:45:46 -0400
X-MC-Unique: 1NnmSBVsP8KgRivKXZD1fA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97E1718EB20E;
	Fri, 26 Jul 2024 13:45:38 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7C961955D42;
	Fri, 26 Jul 2024 13:45:33 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-arm@nongnu.org,
	Radoslaw Biernacki <rad@semihalf.com>,
	Cleber Rosa <crosa@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 11/13] tests/avocado/machine_aarch64_sbsaref.py: allow for rw usage of image
Date: Fri, 26 Jul 2024 09:44:36 -0400
Message-ID: <20240726134438.14720-12-crosa@redhat.com>
In-Reply-To: <20240726134438.14720-1-crosa@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

When the OpenBSD based tests are run in parallel, the previously
single instance of the image would become corrupt.  Let's give each
test its own copy.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/machine_aarch64_sbsaref.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machine_aarch64_sbsaref.py
index 1275f24532..8816308b86 100644
--- a/tests/avocado/machine_aarch64_sbsaref.py
+++ b/tests/avocado/machine_aarch64_sbsaref.py
@@ -7,6 +7,7 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 import os
+import shutil
 
 from avocado import skipUnless
 from avocado.utils import archive
@@ -187,7 +188,9 @@ def boot_openbsd73(self, cpu):
         )
 
         img_hash = "7fc2c75401d6f01fbfa25f4953f72ad7d7c18650056d30755c44b9c129b707e5"
-        img_path = self.fetch_asset(img_url, algorithm="sha256", asset_hash=img_hash)
+        cached_img_path = self.fetch_asset(img_url, algorithm="sha256", asset_hash=img_hash)
+        img_path = os.path.join(self.workdir, os.path.basename(cached_img_path))
+        shutil.copy(cached_img_path, img_path)
 
         self.vm.set_console()
         self.vm.add_args(
-- 
2.45.2


