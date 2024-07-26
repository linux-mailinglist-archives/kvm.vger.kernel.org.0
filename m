Return-Path: <kvm+bounces-22322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7895C93D479
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33E062822DA
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F9917BB2C;
	Fri, 26 Jul 2024 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KzYEvm5f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D4217BB0E
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001533; cv=none; b=npjDvfLFX0eK3IUb1MUksttx3znbPiEulW6Ht1W9I3C6ISlyMsfPLJHVrOnwlxqxJViuqYcbkACKEg8Os9lBoTtxB8oJVjdkS1J8RnFjwgKX5Lp0Ap+ikYcpINipe/p0JlYSedBLANas4JZpnQfuNGDi4fOdo1/7CtZxLI7nLr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001533; c=relaxed/simple;
	bh=vwrL5/odkotTJdCXRBSTvzUIWyYXQa+eCHoWvg1/U+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+wUmawdROa2dMyTMrN1IqVZyuEWilFCN+q9zffkjf2RGaRxgspO29V9J0TxGnuKk2iHRuJ9NZF3QvQFBeBski8UqPDKeSxhPR5oUW42pviLXGhxbiIomdia1qdqXNbTFT7mxBNFz7Ht045QKYmpth+mRf2K0S7e8RYotAO6Iig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KzYEvm5f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CfbZVGkAr1tSkWl9/QjabXB/PTPT9K6rU+mi0TPjxrc=;
	b=KzYEvm5fIf+OUp4CaI62M/yKPjbgSnN1W5h0DdS9PyhP5nTZJjYQbsYgkS0WsovkSdXt7I
	UxZcb0BXoiBSFzy0/ZItvfXT+gnrEUfz1mn8uE4MlR3tC9hRK5gPcetZhR/xExSVIFm43/
	M9EXmPXZI5JBai/23vj0zEmI3+rkzt0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-33CqhGQePNa5PVJ-dZS0Yg-1; Fri,
 26 Jul 2024 09:45:26 -0400
X-MC-Unique: 33CqhGQePNa5PVJ-dZS0Yg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C48F11944B2C;
	Fri, 26 Jul 2024 13:45:24 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 264501955D42;
	Fri, 26 Jul 2024 13:45:20 +0000 (UTC)
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
Subject: [PATCH 08/13] testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset
Date: Fri, 26 Jul 2024 09:44:33 -0400
Message-ID: <20240726134438.14720-9-crosa@redhat.com>
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

The asset used in the mentioned test gets truncated before it's used
in the test.  This means that the file gets modified, and thus the
asset's expected hash doesn't match anymore.  This causes cache misses
and re-downloads every time the test is re-run.

Let's make a copy of the asset so that the one in the cache is
preserved and the cache sees a hit on re-runs.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_linux_console.py | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/avocado/boot_linux_console.py b/tests/avocado/boot_linux_console.py
index b8b0a4df10..2929aa042d 100644
--- a/tests/avocado/boot_linux_console.py
+++ b/tests/avocado/boot_linux_console.py
@@ -401,14 +401,16 @@ def test_arm_emcraft_sf2(self):
                    'fe371d32e50ca682391e1e70ab98c2942aeffb01/spi.bin')
         spi_hash = '65523a1835949b6f4553be96dec1b6a38fb05501'
         spi_path = self.fetch_asset(spi_url, asset_hash=spi_hash)
+        spi_path_rw = os.path.join(self.workdir, os.path.basename(spi_path))
+        shutil.copy(spi_path, spi_path_rw)
 
-        file_truncate(spi_path, 16 << 20) # Spansion S25FL128SDPBHICO is 16 MiB
+        file_truncate(spi_path_rw, 16 << 20) # Spansion S25FL128SDPBHICO is 16 MiB
 
         self.vm.set_console()
         kernel_command_line = self.KERNEL_COMMON_COMMAND_LINE
         self.vm.add_args('-kernel', uboot_path,
                          '-append', kernel_command_line,
-                         '-drive', 'file=' + spi_path + ',if=mtd,format=raw',
+                         '-drive', 'file=' + spi_path_rw + ',if=mtd,format=raw',
                          '-no-reboot')
         self.vm.launch()
         self.wait_for_console_pattern('Enter \'help\' for a list')
-- 
2.45.2


