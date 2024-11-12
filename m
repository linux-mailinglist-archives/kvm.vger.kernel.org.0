Return-Path: <kvm+bounces-31607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C05469C52E9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 11:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 791631F237CD
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E52212EEF;
	Tue, 12 Nov 2024 10:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDniX+8B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CA22123C8;
	Tue, 12 Nov 2024 10:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406510; cv=none; b=kzxN2d7rj2FjhIJNxNk9qwSd837FY62MMlTuGH810nbeLK8td4UetnYV04JezW/3j5NGNEQQuflvfTSkXL9kXyvn5rSwchf1zL97J6hfg/rTdl09e1FBwB00SgylGYvTk3ZOkFzH/A1XvAySeBiTczo9UCqPQntQMRKNWYsyk8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406510; c=relaxed/simple;
	bh=5wZqVnCrgTXXPVtQVMLwa2P0FPVU3SNsWCdlLMoH7BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgalUPtn1/oZmJ8dc9MranhI1CnTThGeSThUI/3kw/XU3SC+2YXCRJ08PNuokFsBSua7zbMJNv0AFhWHxPh5ZpNQK9oPVmFTv0Z8ZwUxX2QJhH0MkjSk0CJVtb8elbZmXIkhzJcEsOsMdi9D1hliHXhMvvvfbGVwqOg7QgRRbbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDniX+8B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A52C4CED8;
	Tue, 12 Nov 2024 10:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731406509;
	bh=5wZqVnCrgTXXPVtQVMLwa2P0FPVU3SNsWCdlLMoH7BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDniX+8BtOyWgaoumVwcqyGXjkyjK4KU5QMiM9vRvCZ/zBExGqUzebHmaybh5r0+R
	 sYsfbWCVhjP9vRg1JHsueBS9LoGXHCu0AX3H31mhk/n512ws/SIGXU8q4NF53fdgOP
	 r/ORFCzqoN0Xq7fKVsRcD6mQJjh0xclUV/7xSfDLiBcaszimCc0ATbSUXiIa5CqRRU
	 iyRY7imGq84osQxfmEcF4GpCDQg1+e9LgUGf3AtqaMVF1/72dgiWVsaSwNTxoYLGDe
	 m402wg2wRzBJqkx4UZGZ/SfZeg3+X9ttEp1g+JgjFrXLigBo0Y9YEN/JiRdRnsd5Pz
	 NIjkPy93bEMMw==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1tAnvP-00000000Jd3-0oqc;
	Tue, 12 Nov 2024 11:15:07 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 09/15] acpi/ghes: better name GHES memory error function
Date: Tue, 12 Nov 2024 11:14:53 +0100
Message-ID: <b1d2b24dbfb375c5bda03561b31b7130a4b9939b.1731406254.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1731406254.git.mchehab+huawei@kernel.org>
References: <cover.1731406254.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

The current function used to generate GHES data is specific for
memory errors. Give a better name for it, as we now have a generic
function as well.

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 hw/acpi/ghes-stub.c    | 2 +-
 hw/acpi/ghes.c         | 2 +-
 include/hw/acpi/ghes.h | 5 +++--
 target/arm/kvm.c       | 3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index 2b64cbd2819a..7cec1812dad9 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,7 +11,7 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
 {
     return -1;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 0eb874a11ff7..1dbcbefbc2ee 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -421,7 +421,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     return;
 }
 
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 8859346af51a..a35097d5207c 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -74,15 +74,16 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
+int acpi_ghes_memory_errors(uint16_t source_id,
+                            uint64_t error_physical_addr);
 void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t error_physical_addr);
 
 /**
  * acpi_ghes_present: Report whether ACPI GHES table is present
  *
  * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_record_errors() to record a memory error.
+ * safe to call acpi_ghes_memory_errors() to record a memory error.
  */
 bool acpi_ghes_present(void);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7b6812c0de2e..8e281d920052 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2387,7 +2387,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA,
+                                             paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
                     error_report("failed to record the error");
-- 
2.47.0


