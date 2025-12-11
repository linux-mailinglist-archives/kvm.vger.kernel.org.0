Return-Path: <kvm+bounces-65752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB2CCB5868
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7CB40301FF7F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7A42FD7B4;
	Thu, 11 Dec 2025 10:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjTuXFGx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B408617DFE7
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765449117; cv=none; b=llHWduNaiFt9kcaxlARwc1VG2C8ZWRGJ4FJJmSGDUmkr/CHmYIr9+/kfQQASDGaD0+VwL8nqPJ812dl1pRW0BQ7dTk3OdsAZcyXuwLSZN8Rn5WMigm/tbZUrj79L/OqUJEVaAf54PF57s+6SMLkwk2LTlyZUbCQiRN7j+xr3Wz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765449117; c=relaxed/simple;
	bh=CuCGEONXnrmX8FQTfL/ZiQcdCpXG9R9vrULYNj7AGbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDPyWJR7HmsXHIhXQECls2WzRTCh8bDXu5CVELsYlbWDk2ANQcjn+5G8K/gNTmgcGAf2lcdc9tf4E/kEPZfCpk5FmmWZq9m14Kxx2S5IGDJZ2j4vYhdc36c3yXCPsly52QOX5+2CWlwm/hka+f0NL55GE8lG70kasmUTwS3Vofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjTuXFGx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765449114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaPmqw/Ehr8W6RQwc5yl82CYunPOYiPN0xNLMshtHSc=;
	b=XjTuXFGx0hMimUAtOwhXP0OG7EguybAa70yAYRM6oNnZbJx2GxckoVG/4IhVqZMyo+iLZj
	4kGFmwb9U6oiJGcwXALKlwnU5Gm8ZYC//fzmL610nP2a5wap7toLlySbd8sHCJrjBr0USS
	Qk6G/q3Q2Xc1aUEgnRTB4ADikdUpt2M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-sU6khzAZNxO8q3_tvqFg3w-1; Thu,
 11 Dec 2025 05:31:50 -0500
X-MC-Unique: sU6khzAZNxO8q3_tvqFg3w-1
X-Mimecast-MFC-AGG-ID: sU6khzAZNxO8q3_tvqFg3w_1765449109
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37B931956088;
	Thu, 11 Dec 2025 10:31:49 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.89])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD83A1800451;
	Thu, 11 Dec 2025 10:31:43 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v2 1/3] hw/acpi: Make BIOS linker optional
Date: Thu, 11 Dec 2025 11:31:34 +0100
Message-ID: <20251211103136.1578463-2-osteffen@redhat.com>
In-Reply-To: <20251211103136.1578463-1-osteffen@redhat.com>
References: <20251211103136.1578463-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Make the BIOS linker optional in acpi_table_end().
This makes it possible to call for example
acpi_build_madt() from outside the ACPI table builder context.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 hw/acpi/aml-build.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 2d5826a8f1..ed86867ae3 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -1748,8 +1748,11 @@ void acpi_table_end(BIOSLinker *linker, AcpiTable *desc)
      */
     memcpy(len_ptr, &table_len_le, sizeof table_len_le);
 
-    bios_linker_loader_add_checksum(linker, ACPI_BUILD_TABLE_FILE,
-        desc->table_offset, table_len, desc->table_offset + checksum_offset);
+    if (linker != NULL) {
+        bios_linker_loader_add_checksum(linker, ACPI_BUILD_TABLE_FILE,
+                                        desc->table_offset, table_len,
+                                        desc->table_offset + checksum_offset);
+    }
 }
 
 void *acpi_data_push(GArray *table_data, unsigned size)
-- 
2.52.0


