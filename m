Return-Path: <kvm+bounces-22314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD8A93D471
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD5C61C20324
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBAB17C214;
	Fri, 26 Jul 2024 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AHElJTuA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462A117B4F3
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001497; cv=none; b=Z9mHzTFU1Cz+LRhh8oKttlEtGQ/koXr29syA2euGQ6hsW2BSEWuMBijO54bZV3K6Y/0ZiSmtzDQ+xZdpPEgJyJokCJKHy9G/2Iaxp1kR4Fjn8t3+s6Ec3JOPPp+0o3vTvkK5di2L/4uTh4PtA4OIfTgEbltRNfrkHeZI7xPN98I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001497; c=relaxed/simple;
	bh=z24RNPvvFHYm1rQxIwxqe7lKBvyJJ7+E5/m7dxhVvx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qUnG5cY/pECMwFrVV8/HgFQDVck5QqsDSnOxJcYi6K7PH9oXznJO2Za6pv9MTpX41668I5H5vm+0+AWN69FeJJAzgegDgkQRu59QBxdNcMxe3RVjx/VTasA+bx9tk9dk1voOZ9/dvXzqdfsx8/DmrvssPDvSPdarMnVXP0+aXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AHElJTuA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xjpHnfhfIk1q7ufJ0zYLvewcXRU+o6xX79PPBGuUDmE=;
	b=AHElJTuAr2zwzAsAzedgEhdv1ToJIdDELhElNl6rpSqzOkPwSrE1EQ77lrcEcGvSqdS8B+
	V4FzMnHUminX+dGSDGE+UslH2hjrINLWdRIJrSF+fxYxABWvj3lgPhcgMN+moX9szG1STL
	h61W+jvJXmOoxBcJPrpNlW1YXXnYkS0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-tYbBeg7aOjSrkvpqgfEtzw-1; Fri,
 26 Jul 2024 09:44:51 -0400
X-MC-Unique: tYbBeg7aOjSrkvpqgfEtzw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 874FB1955BF7;
	Fri, 26 Jul 2024 13:44:48 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FC711955D42;
	Fri, 26 Jul 2024 13:44:43 +0000 (UTC)
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
Subject: [PATCH 00/13] Bump Avocado to 103.0 LTS and update tests for compatibility and new features
Date: Fri, 26 Jul 2024 09:44:25 -0400
Message-ID: <20240726134438.14720-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This is a *long* overdue update of the Avocado version used in QEMU.
It comes a time where the role of the runner and the libraries are
being discussed and questioned.

These exact commits have been staging on my side for over 30 days now,
and I was exceeding what I should in terms of testing before posting.
I apologize for the miscalculation.

Nevertheless, as pointed out, on the ML, these changes are needed NOW.

Some examples of runs in the CI can be seen below:

* Serial with 103.0 LTS (https://gitlab.com/cleber.gnu/qemu/-/jobs/7074346143#L220):
   RESULTS    : PASS 46 | ERROR 0 | FAIL 0 | SKIP 2 | WARN 0 | INTERRUPT 0 | CANCEL 0
   JOB TIME   : 432.63 s

* Parallel with 103.0 LTS (https://gitlab.com/cleber.gnu/qemu/-/jobs/7085879478#L222)
   RESULTS    : PASS 46 | ERROR 0 | FAIL 0 | SKIP 2 | WARN 0 | INTERRUPT 0 | CANCEL 0
   JOB TIME   : 148.99 s

Cleber Rosa (13):
  tests/avocado: mips: fallback to HTTP given certificate expiration
  tests/avocado: mips: add hint for fetchasset plugin
  tests/avocado/intel_iommu.py: increase timeout
  tests/avocado: add cdrom permission related tests
  tests/avocado: machine aarch64: standardize location and RO access
  tests/avocado: use more distinct names for assets
  tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
  testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset
  tests/avocado/boot_xen.py: fetch kernel during test setUp()
  tests/avocado/tuxrun_baselines.py: use Avocado's zstd support
  tests/avocado/machine_aarch64_sbsaref.py: allow for rw usage of image
  Bump avocado to 103.0
  Avocado tests: allow for parallel execution of tests

 docs/devel/testing.rst                   | 12 +++++++
 pythondeps.toml                          |  2 +-
 tests/Makefile.include                   |  6 +++-
 tests/avocado/boot_linux_console.py      | 24 ++++++++------
 tests/avocado/boot_xen.py                | 13 ++++----
 tests/avocado/cdrom.py                   | 41 ++++++++++++++++++++++++
 tests/avocado/intel_iommu.py             |  2 ++
 tests/avocado/kvm_xen_guest.py           | 30 +++++++++++------
 tests/avocado/machine_aarch64_sbsaref.py | 11 +++++--
 tests/avocado/machine_aarch64_virt.py    | 14 ++++----
 tests/avocado/netdev-ethtool.py          |  3 +-
 tests/avocado/tuxrun_baselines.py        | 16 ++++-----
 12 files changed, 125 insertions(+), 49 deletions(-)
 create mode 100644 tests/avocado/cdrom.py

-- 
2.45.2


