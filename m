Return-Path: <kvm+bounces-68063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D82D20A4B
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7ED853065DC6
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0133232A3EC;
	Wed, 14 Jan 2026 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UhfjdKww"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2B1322A1D
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413029; cv=none; b=WjCSHV4NgLaxPDkjbaOSpclieMasWINVolK5im2tcTuRulNuVflGe67/HwNpSjbK5ci1sMabvBiF5dEt879hkjX8F8YFLMP5Ulf2+0NhbTfYurLUyMVDLTNfGK+zSzXegvuHpPq7g1fKOTYfFgzo45LswQ24nSQC5lY4oQwDJOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413029; c=relaxed/simple;
	bh=gn0nIGEnPU+hm4hwTTmC5p6+ecZKM43A0laTVmDWYZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLPyOWBmAuG4Pwosdb7P8iVioXxHq8IxcxIleZKVAeLnNgfDE3qWsdRu1KAtS6ImT945I5TT4JJbHwcbaFDPC6CQakmlQqahLToRI8t/n8BeDBmAIol4cwFM/aLV/wfer6Wx+JEjwPWdn1QlDpS7MudYoNPiWUn58afUCak6voo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UhfjdKww; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768413026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vGtwJX7VVQYuFr2VBiDG+YxC+0YSGXZVi3YOZ3uxtvY=;
	b=UhfjdKwwnHvAY6/IMM3fqEeno4ZkV43EzOnO67ahq+qMXSgtX6jy7fJunV8K1UcUNB3LDK
	zLDzUtVgZTjcbo474YI9DM6rJlTzuNLw/95Moz54eVdnFsdaV9UTPYx1yGJlopiNIN1W92
	jY2S4U6Z9QIjBOFrmTNqw4+aVeMVGVo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-0YMH1tWsNWS6jU4iXZJNig-1; Wed,
 14 Jan 2026 12:50:23 -0500
X-MC-Unique: 0YMH1tWsNWS6jU4iXZJNig-1
X-Mimecast-MFC-AGG-ID: 0YMH1tWsNWS6jU4iXZJNig_1768413022
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0476618005AF;
	Wed, 14 Jan 2026 17:50:22 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.224.90])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 60FF718007D2;
	Wed, 14 Jan 2026 17:50:15 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v4 1/5] hw/acpi: Make BIOS linker optional
Date: Wed, 14 Jan 2026 18:50:03 +0100
Message-ID: <20260114175007.90845-2-osteffen@redhat.com>
In-Reply-To: <20260114175007.90845-1-osteffen@redhat.com>
References: <20260114175007.90845-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Make the BIOS linker optional in acpi_table_end() and calculate the ACPI
table checksum directly if no linker is provided.

This makes it possible to call for example
acpi_build_madt() from outside the ACPI table builder context.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 hw/acpi/aml-build.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 2d5826a8f1..0b0baa67f7 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -1730,6 +1730,25 @@ void acpi_table_begin(AcpiTable *desc, GArray *array)
     build_append_int_noprefix(array, 1, 4); /* Creator Revision */
 }
 
+static uint8_t calculate_acpi_checksum(const gchar *data, size_t len)
+{
+    size_t i;
+    uint8_t sum = 0;
+
+    for (i = 0; i < len; ++i) {
+        sum += (uint8_t)data[i];
+    }
+
+    return sum;
+}
+
+static void update_acpi_checksum(gchar *data, size_t start_offset,
+                                 size_t table_len, size_t checksum_offset)
+{
+    uint8_t sum = calculate_acpi_checksum(&data[start_offset], table_len);
+    data[checksum_offset] = 0xff - sum + 1;
+}
+
 void acpi_table_end(BIOSLinker *linker, AcpiTable *desc)
 {
     /*
@@ -1748,8 +1767,14 @@ void acpi_table_end(BIOSLinker *linker, AcpiTable *desc)
      */
     memcpy(len_ptr, &table_len_le, sizeof table_len_le);
 
-    bios_linker_loader_add_checksum(linker, ACPI_BUILD_TABLE_FILE,
-        desc->table_offset, table_len, desc->table_offset + checksum_offset);
+    if (linker != NULL) {
+        bios_linker_loader_add_checksum(linker, ACPI_BUILD_TABLE_FILE,
+                                        desc->table_offset, table_len,
+                                        desc->table_offset + checksum_offset);
+    } else {
+        update_acpi_checksum(desc->array->data, desc->table_offset,
+                             table_len, desc->table_offset + checksum_offset);
+    }
 }
 
 void *acpi_data_push(GArray *table_data, unsigned size)
-- 
2.52.0


