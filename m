Return-Path: <kvm+bounces-69227-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOhtOImOeGmqqwEAu9opvQ
	(envelope-from <kvm+bounces-69227-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:08:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8628F9271C
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:08:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C8693071814
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2115F2E62AC;
	Tue, 27 Jan 2026 10:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7nG+f7K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7C1A76BB
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508155; cv=none; b=RfbmUusSRmDg45bgZmkIN3YjO8TqiT7PSu/814Fk89AqXtPa6LZzf5OH5BEMKie+BntA6F/yzbLJJg10SrzBwTnwZdDU6OTYSus59OpSV9p67sI5tCCrMq+KDPjrCsrSS8qi2lEtUw3rlDj2lOssHN5Pom4dNXK6+50dVHOQgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508155; c=relaxed/simple;
	bh=jvVTlOrCwUQ798UqiYB31Ha/4wwtGH5t7x4X++RYugw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8inGIEio7A4jDiZ3ulc+AnIWzdIHDCBL4+prZ0H/Ye83x+v4Ssn42gRrXeGFTuZQZT9gA0UqzEc6Xb9qlHvqwzz8aTuCWHyA2BCXFIqBL9VwGbphxPtLU2XBdVnENGPawrDkAj0+c0rDrzWAwiD8guvR158jVPljyo61f9yd88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7nG+f7K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769508153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WBzv/EEHOLl1lvpY0Tolfh3wVeN8GBPJIxvAOWVtvEE=;
	b=Q7nG+f7K2iKnM05ZLEpCRYTnRAYJaOttj5fSrK2BZMILRgsQeR6rDgzDrMtcwMCs39tLmI
	TjaEfNtoRwFrCu0i9pu4Fu8kW0A1NBrGpceD7PAx8ca2G6TnA5uslFldVaRjb5ORHcooCW
	SXGwaRDHrekv6KpivXq3hWNhq6L9gpc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-H7VBd2-2OFeN1rY2OTZRew-1; Tue,
 27 Jan 2026 05:02:29 -0500
X-MC-Unique: H7VBd2-2OFeN1rY2OTZRew-1
X-Mimecast-MFC-AGG-ID: H7VBd2-2OFeN1rY2OTZRew_1769508147
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F2F818002C9;
	Tue, 27 Jan 2026 10:02:27 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.44.34.174])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9534D1956095;
	Tue, 27 Jan 2026 10:02:22 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v5 1/6] hw/acpi: Make BIOS linker optional
Date: Tue, 27 Jan 2026 11:02:10 +0100
Message-ID: <20260127100215.1073575-2-osteffen@redhat.com>
In-Reply-To: <20260127100215.1073575-1-osteffen@redhat.com>
References: <20260127100215.1073575-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,intel.com,gmail.com,amd.com,vger.kernel.org,linaro.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69227-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[osteffen@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8628F9271C
X-Rspamd-Action: no action

Make the BIOS linker optional in acpi_table_end() and calculate the ACPI
table checksum directly if no linker is provided.

This makes it possible to call for example
acpi_build_madt() from outside the ACPI table builder context.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 hw/acpi/aml-build.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index dad4cfcc7d..6a3650076f 100644
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


