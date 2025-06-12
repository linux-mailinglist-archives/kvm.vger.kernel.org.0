Return-Path: <kvm+bounces-49278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0E7AD758D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B2C6167F87
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A91299AB5;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwRtQafi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85A329898E;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=WeNG/O25xOU6ACzHwNTuMeDVX22jS0L2aLE6lfm0flrut0i9gSGIv0wr3Hfb2p6z4VqxGFGodWBUCOjJSUgaucTodXPQf2CFTNIqvn+l6Rthe12QjN+eG8wCUFzjrjbBkIvZULC7HaUBq/eugo9xeTYORo2Jl3Ylxnv1ngkbZ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=IADrYFANwdNZ1rY1HT52KolBlScr6ckE6a5syaX5oVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liIMYXyF9WOBueRO+/TYERVfqd5uV5Hx22Yzs5FSSmNo1Og3wVEurxeUABlZXVDRo98liwH/tNNw9QHj7TOJvICdPpsZtL85QZpCeD/BxA4exWXOR6qoqjwnA8Fq4kBxz2OfGSDADNlIVnL111J0x/wkBJdw1UI65NRsGvFOJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwRtQafi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AFCC4CEEB;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741468;
	bh=IADrYFANwdNZ1rY1HT52KolBlScr6ckE6a5syaX5oVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwRtQafizvhHBnRTdXWuDuyqnQ2vrkcSLc894V2TYhXqOxNIHRNilE1HCfiiP0JbP
	 kUbFcmO3sN2DLEZdPJSj4C4qWGOdLNj7BkHkYwIEIkLZa5FZ7ZE8+nDyUtuAiD0aiD
	 wnp2z1Bw3GPQhWF16A35Tz0N0SyLCE38z7ijUFkAaEiaCxYah9gQXgEIwl36PXlQV8
	 92P9JeEWzQpvuYfvYBSULQx9L65zWGobJC5VPr+nUG84fNIahQPilL0uhCVq8B4XGR
	 3r5rGL+7VCodzj4vFEfL2P2nUEqNq5RiUDa+OSg+v/bf+8MrQoEyW1SHMnR7lh9S5+
	 diqiHdZJGq2mg==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgY-00000005EvK-3Kwo;
	Thu, 12 Jun 2025 17:17:46 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Ani Sinha" <anisinha@redhat.com>,
	"Dongjiu Geng" <gengdongjiu1@gmail.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	"Peter Maydell" <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Shannon Zhao" <shannon.zhaosl@gmail.com>,
	"Yanan Wang" <wangyanan55@huawei.com>,
	"Zhao Liu" <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 (RESEND) 03/20] tests/acpi: virt: update HEST file with its current data
Date: Thu, 12 Jun 2025 17:17:27 +0200
Message-ID: <e3527be1610b2ef6b20ca2efa025de91a1f1e0a6.1749741085.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Now that HEST table is checked for aarch64, add the current
firmware file.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 tests/data/acpi/aarch64/virt/HEST           | Bin 0 -> 132 bytes
 tests/qtest/bios-tables-test-allowed-diff.h |   1 -
 2 files changed, 1 deletion(-)

diff --git a/tests/data/acpi/aarch64/virt/HEST b/tests/data/acpi/aarch64/virt/HEST
index e69de29bb2d1d6434b8b29ae775ad8c2e48c5391..4c5d8c5b5da5b3241f93cd0839e94272bf6b1486 100644
GIT binary patch
literal 132
zcmeZp4Gw8xU|?W;<mB({5v<@85#X$#prF9Wz`y`vgJ=-uVqjqS|DS;o#%Ew*U|?_n
dk++-~7#J8hWI!Yi09DHYRr~Kh1c1x}0RY>66afGL

literal 0
HcmV?d00001

diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index 39901c58d647..dfb8523c8bf4 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1,2 +1 @@
 /* List of comma-separated changed AML files to ignore */
-"tests/data/acpi/aarch64/virt/HEST",
-- 
2.49.0


