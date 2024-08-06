Return-Path: <kvm+bounces-23413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B00C9496D7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35FA21F241D9
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8D34F8A0;
	Tue,  6 Aug 2024 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2WiUEbN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5E93C08A
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965528; cv=none; b=OAUjygeo+orucd9+SAzekFySxhc5V7OGIgfVggx10mfqjhZeIjtQ0XW7yB3I7QFfUCUVF6LOecfuPrM06D2AQWD86ApJh5azBLOAExRxJ00eD5bsYAfz7PpiJ8NT3+1FHc+TvR/FatFztWaZTvYAHL/zb7RkeROmbDMUQSkV3Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965528; c=relaxed/simple;
	bh=3ltEtQnhEUMjlxlHwauDlJLQDZFdwaQXGsQUmfZoUxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzgRuJCIvSfaW6LUK/Jcoe5iqgw5GawcFoxyuLG3NLtR14Iqkq5xgKpcEqzugJxOh151eatlBGAkdwQCQTMBPSFvY7nAWlxX5UdlmruLgAghPT2qj7vrSyF6vVS0TWESa2cMbNx0xIDi56EHQIYeQMBj2a5l+wTnxKy1u3KuZ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B2WiUEbN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3d6XMb3rg8qagy9L556QHcs1su9m4o4U8evvKQPrw1o=;
	b=B2WiUEbNqyPBJFkCG+rZBdhSY2QXVSXlKgaghgHXlZx69ylkrAP9VOLimUXRVa4ftIvKRG
	ToK3UMb+PiSB4U9ZmRf0HqEXW5TD+dZI02k2s/bihZc+UafgPejI+sK5KS+w93No46dNIL
	vBRBL737RrqEa0CSJicr1pHSwJNjev4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-HCMI_sXsMvKtkbo1ab6cCw-1; Tue,
 06 Aug 2024 13:31:58 -0400
X-MC-Unique: HCMI_sXsMvKtkbo1ab6cCw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71A2E195422B;
	Tue,  6 Aug 2024 17:31:49 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A23AC19560AE;
	Tue,  6 Aug 2024 17:31:38 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Troy Lee <leetroy@gmail.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Beraldo Leal <bleal@redhat.com>,
	kvm@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Paul Durrant <paul@xen.org>,
	Eric Auger <eric.auger@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	qemu-arm@nongnu.org,
	Cleber Rosa <crosa@redhat.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	Steven Lee <steven_lee@aspeedtech.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Leif Lindholm <quic_llindhol@quicinc.com>
Subject: [PATCH v2 1/9] Bump avocado to 103.0
Date: Tue,  6 Aug 2024 13:31:11 -0400
Message-ID: <20240806173119.582857-2-crosa@redhat.com>
In-Reply-To: <20240806173119.582857-1-crosa@redhat.com>
References: <20240806173119.582857-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This bumps Avocado to latest the LTS release.

An LTS release is one that can receive bugfixes and guarantees
stability for a much longer period and has incremental minor releases
made.

Even though the 103.0 LTS release is pretty a rewrite of Avocado when
compared to 88.1, the behavior of all existing tests under
tests/avocado has been extensively tested no regression in behavior
was found.

To keep behavior of jobs as close as possible with previous version,
this version bump keeps the execution serial (maximum of one task at a
time being run).

Reference: https://avocado-framework.readthedocs.io/en/103.0/releases/lts/103_0.html
Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 pythondeps.toml        | 2 +-
 tests/Makefile.include | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/pythondeps.toml b/pythondeps.toml
index f6e590fdd8..175cf99241 100644
--- a/pythondeps.toml
+++ b/pythondeps.toml
@@ -30,5 +30,5 @@ sphinx_rtd_theme = { accepted = ">=0.5", installed = "1.1.1" }
 # Note that qemu.git/python/ is always implicitly installed.
 # Prefer an LTS version when updating the accepted versions of
 # avocado-framework, for example right now the limit is 92.x.
-avocado-framework = { accepted = "(>=88.1, <93.0)", installed = "88.1", canary = "avocado" }
+avocado-framework = { accepted = "(>=103.0, <104.0)", installed = "103.0", canary = "avocado" }
 pycdlib = { accepted = ">=1.11.0" }
diff --git a/tests/Makefile.include b/tests/Makefile.include
index 6618bfed70..537804d101 100644
--- a/tests/Makefile.include
+++ b/tests/Makefile.include
@@ -141,7 +141,7 @@ check-avocado: check-venv $(TESTS_RESULTS_DIR) get-vm-images
             --show=$(AVOCADO_SHOW) run --job-results-dir=$(TESTS_RESULTS_DIR) \
             $(if $(AVOCADO_TAGS),, --filter-by-tags-include-empty \
 			--filter-by-tags-include-empty-key) \
-            $(AVOCADO_CMDLINE_TAGS) \
+            $(AVOCADO_CMDLINE_TAGS) --max-parallel-tasks=1 \
             $(if $(GITLAB_CI),,--failfast) $(AVOCADO_TESTS), \
             "AVOCADO", "tests/avocado")
 
-- 
2.45.2


