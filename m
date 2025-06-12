Return-Path: <kvm+bounces-49292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A187AD75CF
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB1D47B299B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999C72BDC28;
	Thu, 12 Jun 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqkhG5J4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A378E299A8A;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=EUbv141SJGsSoLhQbHxAUuaxI2jN701e1v2zgozuO+qBvhhxUdMr5NJrsyrwpiYieK7U8rs/b1wWo72EnDPe7bpKyUQxX61A0kSnbC/uhRDgn7+a1/vGlpiGi2j5/pUcBj5zlGUSWu83wD3sj4pVpM/HxdCzbI5c6IvMe/o9B3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=5800+9pcKbpwq9CBW/e+YLPVT84qYs9jAiAX5nQsi/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/zBdMtxf6xQcuzSW+F3Tl0Vva+F5C2XBj2dnr8gM+SEZ+D4jtZUAZ9LaNnCuG6byXkrCnIdaZ9oytBX2jc1eicYXwGDXm0+0wEhAqLn1Y/BRiFb2lapwGAgYcG83ZigQttzvzdedE3qeSt611zLTQXT5ZF8IAhh2l1QVRIcFOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqkhG5J4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38507C116D0;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741469;
	bh=5800+9pcKbpwq9CBW/e+YLPVT84qYs9jAiAX5nQsi/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqkhG5J41imjPv1R5ZtN4zLsGMd+SJAwp0efcggHaslrKnhroV7BfEfNm3q56lo4j
	 cizltsctWOzDiCKJ1h8ilyTVdeLebnqHebKBOb50a7MO80nVJKPiGf35HBDxxxuJ63
	 nGSoGoFwAqXYfzAilMQalDmYibTW/GJ9cVeLeEr46s3nfBonaNI/3YHlMTZG1c1+lD
	 H0U1SAuLWp+Uc06m7u1/t1R1rk6V2LXEZf5AW/ELS7zh1CnZSWwWLpNSw2gjWe7rrG
	 DtXra/v2IuqDFB8pwhac8I2lrTtKagU8IWe5P+5LMXwi5iRXsyAh187Ezbo4hImRbt
	 wryGJdo+gN31Q==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgZ-00000005Ew2-1rj9;
	Thu, 12 Jun 2025 17:17:47 +0200
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
Subject: [PATCH v10 (RESEND) 14/20] tests/acpi: virt: allow acpi table changes at DSDT and HEST tables
Date: Thu, 12 Jun 2025 17:17:38 +0200
Message-ID: <c3d68c081655d471f6d9ab4fb24191b33137ff5e.1749741085.git.mchehab+huawei@kernel.org>
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

We'll be adding a new GED device for HEST GPIO notification and
increasing the number of entries at the HEST table.

Blocklist testing HEST and DSDT tables until such changes
are completed.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 tests/qtest/bios-tables-test-allowed-diff.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index dfb8523c8bf4..0a1a26543ba2 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1 +1,7 @@
 /* List of comma-separated changed AML files to ignore */
+"tests/data/acpi/aarch64/virt/HEST",
+"tests/data/acpi/aarch64/virt/DSDT",
+"tests/data/acpi/aarch64/virt/DSDT.acpihmatvirt",
+"tests/data/acpi/aarch64/virt/DSDT.memhp",
+"tests/data/acpi/aarch64/virt/DSDT.pxb",
+"tests/data/acpi/aarch64/virt/DSDT.topology",
-- 
2.49.0


