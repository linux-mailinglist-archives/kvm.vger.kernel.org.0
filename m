Return-Path: <kvm+bounces-23412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1B019496D6
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20B7A1C20F2E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C76174E26;
	Tue,  6 Aug 2024 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkkaLHSM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047956F2EB
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965516; cv=none; b=Ki0BKSvle8wSxbe0nz26dtLNv4PBBYiOJGQeZlILVNCLbtVYJpRF2h13CJBEMyHqHXYzqI65xA9pfMmR+qGst9zWf/VW/yWpGmwAEi+rIANcJHmWOfpOf7S3A57457P/CRDrEbfx1JQT2d7jop8yZh3GPB/4FB/pSYBz6LtXlqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965516; c=relaxed/simple;
	bh=rHaJtwI8xIAlkDLeEWEuVRlWirwDDbTrAC7UNo3ccEw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lPSuoXc8upmZY/LYNjwF8cEVr29wBqETl+AAc52+GtuszqKQ7ptw5wGabvqVwJex+LTtBF1gsVEhjOxuinSvixvllefmB6cxR6P3VEls7RjH6Y/G10NjdHzEfr9lX0OHFGqo+LMyp0sZxK5ezMneaUcpDmuXSLN8lp5i5E2qMYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkkaLHSM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nXinTE9rFIYefn8SSsxp/18DtX97VEd5BEq82ma5RtM=;
	b=XkkaLHSMtraHqeb0pZbCx9dvoeb5hK6d+DIBK4kIFpcVEKscm/Uy6Fmt+IidOvzm82NHoF
	pCbbtpep49A90Pz7aVWiTxM+Dc6HMxw8+0pEHSQB89jkJF8+WG6VsYWldHGU8Dn7Z0EpWH
	Pxlhxpn8d9fKl0oN57r57P3rBFYHlJM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-KsaEGWMPNgyDiFOpDM_1WQ-1; Tue,
 06 Aug 2024 13:31:50 -0400
X-MC-Unique: KsaEGWMPNgyDiFOpDM_1WQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 467151955BFA;
	Tue,  6 Aug 2024 17:31:38 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB8421955F65;
	Tue,  6 Aug 2024 17:31:23 +0000 (UTC)
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
Subject: [PATCH v2 0/9] Bump Avocado to 103.0 LTS and update tests for compatibility and new features
Date: Tue,  6 Aug 2024 13:31:10 -0400
Message-ID: <20240806173119.582857-1-crosa@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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

Changes from v1 (references are from v1):

This version first applies the Avocado version bump (now PATCH 1),
adding to that patch the serial execution behavior.  Avocado 103.0 LTS
can run all existing tests in QEMU without any changes, so it's safe
to pick PATCH 1 *only* from this series if needed.  A GitLab CI job that
does only that can be seen here:

 https://gitlab.com/cleber.gnu/qemu/-/pipelines/1402633650

Details on changes:

 * Moved "Bump avocado to 103.0" to first patch

 * Patches already applied:
    - [PATCH 1/13] tests/avocado: mips: fallback to HTTP given certificate expiration
    - [PATCH 2/13] tests/avocado: mips: add hint for fetchasset plugin
    - [PATCH 8/13] testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset

  * Dropped patches:
    - [PATCH 3/13] tests/avocado/intel_iommu.py: increase timeout
    - [PATCH 6/13] tests/avocado: use more distinct names for assets
      - Replaced with "tests/avocado: simplify parameters on fetch_asset with name only"
    - [PATCH 7/13] tests/avocado/kvm_xen_guest.py: cope with asset RW requirements

  * [PATCH 5/13] tests/avocado: machine aarch64: standardize location and RO access:
    - Fixed rebase mistake

  * [PATCH 11/13] tests/avocado/machine_aarch64_sbsaref.py: allow for rw usage of image
    - Use "snapshot=on" instead of new copy of file

  * New patches:
    - tests/avocado: apply proper skipUnless decorator
    - tests/avocado: simplify parameters on fetch_asset with name only

Cleber Rosa (9):
  Bump avocado to 103.0
  tests/avocado: apply proper skipUnless decorator
  tests/avocado: add cdrom permission related tests
  tests/avocado: machine aarch64: standardize location and RO access
  tests/avocado: simplify parameters on fetch_asset with name only
  tests/avocado/boot_xen.py: fetch kernel during test setUp()
  tests/avocado/tuxrun_baselines.py: use Avocado's zstd support
  tests/avocado/machine_aarch64_sbsaref.py: allow for rw usage of image
  Avocado tests: allow for parallel execution of tests

 docs/devel/testing.rst                   | 12 +++++++
 pythondeps.toml                          |  2 +-
 tests/Makefile.include                   |  6 +++-
 tests/avocado/boot_linux_console.py      |  1 -
 tests/avocado/boot_xen.py                | 13 ++++----
 tests/avocado/cdrom.py                   | 41 ++++++++++++++++++++++++
 tests/avocado/intel_iommu.py             |  1 -
 tests/avocado/kvm_xen_guest.py           |  2 +-
 tests/avocado/linux_initrd.py            |  1 -
 tests/avocado/machine_aarch64_sbsaref.py |  4 +--
 tests/avocado/machine_aarch64_virt.py    | 14 ++++----
 tests/avocado/machine_aspeed.py          |  2 --
 tests/avocado/machine_mips_malta.py      |  2 --
 tests/avocado/machine_rx_gdbsim.py       |  2 --
 tests/avocado/netdev-ethtool.py          |  2 +-
 tests/avocado/reverse_debugging.py       |  4 ---
 tests/avocado/smmu.py                    |  1 -
 tests/avocado/tuxrun_baselines.py        | 16 ++++-----
 18 files changed, 82 insertions(+), 44 deletions(-)
 create mode 100644 tests/avocado/cdrom.py

-- 
2.45.2


