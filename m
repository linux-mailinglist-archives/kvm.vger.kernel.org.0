Return-Path: <kvm+bounces-23417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C89F9496DC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 180A21F2442D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6B65B1FB;
	Tue,  6 Aug 2024 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XATz4wQL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCE38DE1
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965566; cv=none; b=XtuPzSN7zUyH4P2GfA3gmvx4Lkuw+ZxmCoGS5gLE4cn1TcsW6quwrSX3mDug3a1P++zF58Uc0TPFoH4bVFTc+3tT/nNk8wNnI26VbUPUJQOMFBok4W3rqjzKft9SdE0l+Pq8Szp1IcZhWxJYRgkrmZWTzGq+8TmUIbFuj2l9mEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965566; c=relaxed/simple;
	bh=FsuQNbQBP2SBdeZ94q7ludvQR7YYJ9Xh0f8eZsY4x7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYSGcVhSKv+xCdrzNPbMamQo6DYxLHI7k8YdqnBrJCy0me/N6t561oqxsfghg2Xt5RIQRvBbHIYUOqdLtMNz3edb/YKDUnGqimwQ/teyslsBP2wBsVLA/Qnya4A8468gSLj1HTNj9mYn7VuqqObEgZf90hSLHhCH0TLBMMim52g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XATz4wQL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=01Mezu2vBS7e/Bbaib7lIYgCl8rkcleLFRElcDYTArc=;
	b=XATz4wQLgQ8ICgGPDf+/zGd7zuIWWesdIdw1S81ovTCm0ecweuBEYxlOp6AYlBBxsOzCOa
	d9VGUj+bHqSHTa2OHDPyVebRtffJu+nNMtt/IuKdlw2z21MZqE+lFVsTcAl1rxI8B+T5IO
	ChRXb2yY73tNOmMcDz3iX2Ykt/YkWn8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-294-zxumTil8PJCidnFK9zrJIg-1; Tue,
 06 Aug 2024 13:32:40 -0400
X-MC-Unique: zxumTil8PJCidnFK9zrJIg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F6CD1955D45;
	Tue,  6 Aug 2024 17:32:36 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C21A419560AE;
	Tue,  6 Aug 2024 17:32:26 +0000 (UTC)
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
Subject: [PATCH v2 5/9] tests/avocado: simplify parameters on fetch_asset with name only
Date: Tue,  6 Aug 2024 13:31:15 -0400
Message-ID: <20240806173119.582857-6-crosa@redhat.com>
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

When an asset has a single location, it's possible to use that
URI as the name of the asset.

Reference: https://avocado-framework.readthedocs.io/en/103.0/api/utils/avocado.utils.html#avocado.utils.asset.Asset
Reference: https://avocado-framework.readthedocs.io/en/103.0/api/test/avocado.html#avocado.Test.fetch_asset

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/kvm_xen_guest.py  | 2 +-
 tests/avocado/netdev-ethtool.py | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index f8cb458d5d..b6ee1ff752 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -40,7 +40,7 @@ def get_asset(self, name, sha1):
         url = base_url + name
         # use explicit name rather than failing to neatly parse the
         # URL into a unique one
-        return self.fetch_asset(name=name, locations=(url), asset_hash=sha1)
+        return self.fetch_asset(name=url, asset_hash=sha1)
 
     def common_vm_setup(self):
         # We also catch lack of KVM_XEN support if we fail to launch
diff --git a/tests/avocado/netdev-ethtool.py b/tests/avocado/netdev-ethtool.py
index 5f33288f81..7345ded28c 100644
--- a/tests/avocado/netdev-ethtool.py
+++ b/tests/avocado/netdev-ethtool.py
@@ -27,7 +27,7 @@ def get_asset(self, name, sha1):
         url = base_url + name
         # use explicit name rather than failing to neatly parse the
         # URL into a unique one
-        return self.fetch_asset(name=name, locations=(url), asset_hash=sha1)
+        return self.fetch_asset(name=url, asset_hash=sha1)
 
     def common_test_code(self, netdev, extra_args=None):
 
-- 
2.45.2


