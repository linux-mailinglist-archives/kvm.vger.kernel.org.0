Return-Path: <kvm+bounces-49281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C7AAD75C6
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0B9E7B0B6B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2627229B781;
	Thu, 12 Jun 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMm5ZGn/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2399D298CAE;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=A0DL6AA1lMMqbFV2uFviW+WowUwmsFkRSa0rRHXkw7cLDsjCszKlCe2eO35YmuErExamotOynDvC+sYtbQ6PtYKWesc84RPU0NIZ5za5IgFK04YIzUex8bsHV5aLQC39U3W5piwR5I9JqRtd8z4CBD4fKXtzYBU5j6TweILBcrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=qT0ATk/szMufp7pLg3EjSMU6UchGJC4t7yLc86gnlkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3/oSXvL0s1KxcX+x5DitVdGoYDiY5kAe+iq6EQhgRHIEPyW6CH/t7B0X2F9/5ZOl9KxpspUHO0irYhUYfOHEEeN0xTMVd7v9qCSLANdxHZ0jrELJAkhXbYUW6RyurvByrn72kKrfBembDdDnZ+5MEUW9G3goK5n9dbE1ElZN8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMm5ZGn/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DB8C4AF0B;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741468;
	bh=qT0ATk/szMufp7pLg3EjSMU6UchGJC4t7yLc86gnlkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMm5ZGn/AmZQBiV1AtepxMTZ+psNJkv/PIYHRK2NhVn+nruCRVyJUkG4X1iTGUz6s
	 ZVBCuaCY1NPB9kX/z98uWcBl/q2pEUEQRTizAlwMpKdFS+FFrpj9fjDRIKxJc2A3ZL
	 6qQgGNd8dhbdMJuLbPmhjxMBeo7G+ws191ROkOUy25ZP3T1KmHU32dACYs10PLRv26
	 e1GTzOQQBVnCx25rb6nW7yxKpkpF/la8mZAMA27G6j/gjR12qMs7FcSFfUDtdYCWhW
	 +WmuYvzkPtcHb7MOWwBppA92i6DbyZcD4Nwp4YWz9/TfF+qkVwTMP8VT+UqnMWJfDM
	 NpM7QPgavwzPA==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgY-00000005EvO-3ZDo;
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
Subject: [PATCH v10 (RESEND) 04/20] Revert "hw/acpi/ghes: Make ghes_record_cper_errors() static"
Date: Thu, 12 Jun 2025 17:17:28 +0200
Message-ID: <e473bbd6ddf17e8b7d6868657a4c815af435bd25.1749741085.git.mchehab+huawei@kernel.org>
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

The ghes_record_cper_errors() function was introduced to be used
by other types of errors, as part of the error injection
patch series. That's why it is not static.

Make it non-static again to allow its usage outside ghes.c

This reverts commit 611f3bdb20f7828b0813aa90d47d1275ef18329b.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 hw/acpi/ghes.c         | 6 ++++--
 include/hw/acpi/ghes.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index b85bb48195a0..b709c177cdea 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -390,8 +390,8 @@ static void get_hw_error_offsets(uint64_t ghes_addr,
     *read_ack_register_addr = ghes_addr + sizeof(uint64_t);
 }
 
-static void ghes_record_cper_errors(const void *cper, size_t len,
-                                    uint16_t source_id, Error **errp)
+void ghes_record_cper_errors(const void *cper, size_t len,
+                             uint16_t source_id, Error **errp)
 {
     uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
     AcpiGedState *acpi_ged_state;
@@ -440,6 +440,8 @@ static void ghes_record_cper_errors(const void *cper, size_t len,
 
     /* Write the generic error data entry into guest memory */
     cpu_physical_memory_write(cper_addr, cper, len);
+
+    return;
 }
 
 int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 578a582203ce..39619a2457cb 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -75,6 +75,8 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
 int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
+void ghes_record_cper_errors(const void *cper, size_t len,
+                             uint16_t source_id, Error **errp);
 
 /**
  * acpi_ghes_present: Report whether ACPI GHES table is present
-- 
2.49.0


