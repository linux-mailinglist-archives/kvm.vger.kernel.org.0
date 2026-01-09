Return-Path: <kvm+bounces-67564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1746D0AA7D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BEE73025F9A
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB012BD587;
	Fri,  9 Jan 2026 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgw1cZKj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219934A01
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969276; cv=none; b=svwwjJs0RnVBbtjo/hi6WwFxHI+YnmhNLpOZXwnz6WkCKaJ171UQPdOjFAp3B7KHfKMAlzrZT/0/XuwIRtLjqansVIv6cy5C0WwYl1NVM7BK1BRWpdMPBDiybzIVQvKKvwuIPBiL/VuEyV+8S/bN6BcGM9dTtN/D8WPfWugfOnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969276; c=relaxed/simple;
	bh=CuCGEONXnrmX8FQTfL/ZiQcdCpXG9R9vrULYNj7AGbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOBp3tiOBXlrW06h6vaaSzhCqEbRwM4pHX9Me7JbMAd+xjheP6OiJPbW+Mryl2zugWU1Yzf43GkKwJcJDzvKR+nl1DfRTn5lDX6yXQHZF2h3/nNko2pGZDynGOlm26gkEUCCfN1pKeGDGjFvlCEl82Xf/4fMF2IJ+fn2u7K0e2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgw1cZKj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767969274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaPmqw/Ehr8W6RQwc5yl82CYunPOYiPN0xNLMshtHSc=;
	b=bgw1cZKj7jZGqeaYSUfkl/dIaAa0ClfyY5oLgoDfstJsU0bImU86ouBonwXJ54qio65HSF
	KF2EmfzBcXDCGIW9oARM2TXuLhcd1JBz942EKmdQqnyXGvP1f2lmSbxDhAt6zYgYc2wWeE
	QpfFQDTYflSiRqziMPg6waZ1YmmjNBk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-4i_4hS42MCOsmAjYEx9_fQ-1; Fri,
 09 Jan 2026 09:34:29 -0500
X-MC-Unique: 4i_4hS42MCOsmAjYEx9_fQ-1
X-Mimecast-MFC-AGG-ID: 4i_4hS42MCOsmAjYEx9_fQ_1767969268
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAED918005B7;
	Fri,  9 Jan 2026 14:34:27 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.84])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D4FE18001D5;
	Fri,  9 Jan 2026 14:34:22 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v3 1/6] hw/acpi: Make BIOS linker optional
Date: Fri,  9 Jan 2026 15:34:08 +0100
Message-ID: <20260109143413.293593-2-osteffen@redhat.com>
In-Reply-To: <20260109143413.293593-1-osteffen@redhat.com>
References: <20260109143413.293593-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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


