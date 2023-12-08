Return-Path: <kvm+bounces-3952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 060A380ACA6
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A687D281A59
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670D64B137;
	Fri,  8 Dec 2023 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="APVHA/0V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B33510DA
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=adJH7rWy3zq1h4h/lqGpwZ7Vbw0iyk9j/MLUkacF4c0=;
	b=APVHA/0V13MNVxIXPl34qYOnt5ATcO350oqcXieu8nUbOMgbLrApGUBS3d8y+9pkVlB/1Y
	Xt50VKxSninIZqpkfOiQpRX/ViqjGNU48ACNw1QhrwToJeH2HguZlCrGKkMdAWX7rdrSGb
	SAHlfSky1iatdi20kwCnPFB4XJDlq8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-heyNTEq2N5q3V0XwSXHsjw-1; Fri, 08 Dec 2023 14:09:24 -0500
X-MC-Unique: heyNTEq2N5q3V0XwSXHsjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DB81101A52A;
	Fri,  8 Dec 2023 19:09:21 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7D25112131D;
	Fri,  8 Dec 2023 19:09:17 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 00/10] for-8.3 tests/avocado: prep for Avocado 103.0 LTS
Date: Fri,  8 Dec 2023 14:09:01 -0500
Message-ID: <20231208190911.102879-1-crosa@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

This is a collection of improvements to a number of Avocado based
tests, but also fixes that will allow them to behave properly under
Avocado's upcoming new Long Term Stability release (LTS) version
103.0.

A pipeline with (pretty much) these changes can be seen at:
  - https://gitlab.com/cleber.gnu/qemu/-/pipelines/1096168899

While a pipeline with the Avocado version bump (using a preview of the
103.0 release) can be seen at:
  - https://gitlab.com/cleber.gnu/qemu/-/pipelines/1099488480

Once Avocado officially releases 103.0 LTS, which is expected to take
no longer than 2 weeks (after a huge development window), the actual
version bump will be posted, along with more profound changes to the
tests to leverage the new features.

Cleber Rosa (10):
  tests/avocado: mips: fallback to HTTP given certificate expiration
  tests/avocado: mips: add hint for fetchasset plugin
  tests/avocado/intel_iommu.py: increase timeout
  tests/avocado: machine aarch64: standardize location and RO/RW access
  tests/avocado: use more distinct names for assets
  tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
  testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset
  tests/avocado/boot_xen.py: merge base classes
  tests/avocado/boot_xen.py: unify tags
  tests/avocado/boot_xen.py: use class attribute

 tests/avocado/boot_linux_console.py      | 27 +++++++++++++++----
 tests/avocado/boot_xen.py                | 34 +++++-------------------
 tests/avocado/intel_iommu.py             |  2 ++
 tests/avocado/kvm_xen_guest.py           | 30 ++++++++++++++-------
 tests/avocado/machine_aarch64_sbsaref.py |  9 +++++--
 tests/avocado/machine_aarch64_virt.py    | 14 +++++-----
 tests/avocado/netdev-ethtool.py          |  3 ++-
 7 files changed, 67 insertions(+), 52 deletions(-)

-- 
2.43.0


