Return-Path: <kvm+bounces-22327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EF793D482
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EBD7282D98
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E6C1E536;
	Fri, 26 Jul 2024 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JRd4hw9p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13091E51E
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001585; cv=none; b=IbfeqWHC8AJeaTSAEfK7NhwP5vYVGbDLXZ7C8e+E3r+420sMFs8UrxvJuB30nRPkpmwMzIDRC2VIJKsFXaebX4KyqHXKnXFZvjUmSRqkVeK/vGygapYTQmlo0txB6RtKsJp3FiNGWF2lJP/EzSL+JIfSSoN6l/cf9easJ8P8ZEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001585; c=relaxed/simple;
	bh=nd9uOdF5ixjSilVwzdWEGLL+i33lm9IfHRsSqxvXQwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xqa5XmqzbKZRY3kZ5qM75SpsGXlj5yPyUJ88ZpxPd9ZpxksJ15nQpfYNpN6NEHbQNR8pFy8opcdvyDCgn59M4KCDxC1GPm3fqJ/Llzv99x9+R2CprdTF80zo6bY2X8dw/x2Z5azmrcLZ1Ulo7S/AKaVnqEU3nqIfj0/2d9HBkhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JRd4hw9p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Im4JjI8yzxxn9wQq5bZQLL26rZjo/9QxJ6+zUl4DQ7s=;
	b=JRd4hw9pQKflbRFcRgvbfdvcHmBW4u9jb229hQ3T/sgQKIRjSVDvMgVOW/gGK1k2FoSjkU
	8TEQ30M1JJwKrtfu+QpuPtKwIZgmbfQ+MTkYsngWYW/Vqi352jUZcDB/PRKB3hbJ4sqtyi
	exIIE0TKD2gG04ZOK3t6Al/WZ363Nig=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-dGOgJqcsNGmzR9AyTJmYdQ-1; Fri,
 26 Jul 2024 09:46:17 -0400
X-MC-Unique: dGOgJqcsNGmzR9AyTJmYdQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B640C19E5770;
	Fri, 26 Jul 2024 13:46:07 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A4F71955D42;
	Fri, 26 Jul 2024 13:45:42 +0000 (UTC)
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
Subject: [PATCH 13/13] Avocado tests: allow for parallel execution of tests
Date: Fri, 26 Jul 2024 09:44:38 -0400
Message-ID: <20240726134438.14720-14-crosa@redhat.com>
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

The updated Avocado version allows for the execution of tests in
parallel.

While on a CI environment it may not be a good idea to increase the
parallelization level in a single runner, developers may leverage that
on specific CI runners or on their development environments.

This also multiplies the timeout for each test accordingly.  The
reason is that more concurrency can lead to less resources, and less
resources can lead to some specific tests taking longer to complete
and then time out.  The timeout factor being used here is very
conservative (being equal to the amount of parallel tasks).  The worst
this possibly oversized timeout value can do is making users wait a
bit longer for the job to finish if a test hangs.

Overall, users can expect a much quicker turnaround on most systems
with a value such as 8 on a 12 core machine.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 docs/devel/testing.rst | 12 ++++++++++++
 tests/Makefile.include |  6 +++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/docs/devel/testing.rst b/docs/devel/testing.rst
index 23d3f44f52..5600123743 100644
--- a/docs/devel/testing.rst
+++ b/docs/devel/testing.rst
@@ -983,6 +983,18 @@ of Avocado or ``make check-avocado``, and can also be queried using:
 
   pyvenv/bin/avocado list tests/avocado
 
+To run tests in parallel, the ``AVOCADO_PARALLEL`` environment
+variable can be defined with a value different than ``1`` (its default
+value).  Example:
+
+ .. code::
+
+  make check-avocado AVOCADO_PARALLEL=4
+
+Please exercise care when using parallel execution with the QEMU
+Avocado tests as a higher system load can cause time sensitive tests
+to timeout and be interrupted.
+
 Manual Installation
 ~~~~~~~~~~~~~~~~~~~
 
diff --git a/tests/Makefile.include b/tests/Makefile.include
index 6618bfed70..545b5155f9 100644
--- a/tests/Makefile.include
+++ b/tests/Makefile.include
@@ -94,6 +94,9 @@ TESTS_RESULTS_DIR=$(BUILD_DIR)/tests/results
 ifndef AVOCADO_TESTS
 	AVOCADO_TESTS=tests/avocado
 endif
+ifndef AVOCADO_PARALLEL
+	AVOCADO_PARALLEL=1
+endif
 # Controls the output generated by Avocado when running tests.
 # Any number of command separated loggers are accepted.  For more
 # information please refer to "avocado --help".
@@ -141,7 +144,8 @@ check-avocado: check-venv $(TESTS_RESULTS_DIR) get-vm-images
             --show=$(AVOCADO_SHOW) run --job-results-dir=$(TESTS_RESULTS_DIR) \
             $(if $(AVOCADO_TAGS),, --filter-by-tags-include-empty \
 			--filter-by-tags-include-empty-key) \
-            $(AVOCADO_CMDLINE_TAGS) \
+            $(AVOCADO_CMDLINE_TAGS) --max-parallel-tasks=$(AVOCADO_PARALLEL) \
+			-p timeout_factor=$(AVOCADO_PARALLEL) \
             $(if $(GITLAB_CI),,--failfast) $(AVOCADO_TESTS), \
             "AVOCADO", "tests/avocado")
 
-- 
2.45.2


