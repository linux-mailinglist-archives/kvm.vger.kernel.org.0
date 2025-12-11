Return-Path: <kvm+bounces-65753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A86DCB586E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E4433025305
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE2C303CA2;
	Thu, 11 Dec 2025 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQLDkLVr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1A62F5324
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765449128; cv=none; b=Q5/X5smJGNAeFsDDV+QXDhpK3WNxlpGpaiztXZdn6ry25At9VJMTP3iJGEc7q1acsR9KPKkLxdR1/8huJCNwXk/zBhFahnh4l82Jg13VhM6JQFHjaCuCZcEAUabv5k25b4Eg4ji9SqFJYN2JXm04RZaaLLLHu2Tp/0Xpz1oQUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765449128; c=relaxed/simple;
	bh=ZYMW24kNKTUdiGXyRbfAi6V3VGnGpdYxvzCbj5jO7L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feH9FTF6dazYWViuPvN+2pTK7OhYsFQoZZrx4DnYB3DuauToLT07qXT4M7/3i7TkIiRd9iAoW07ue71frdNIghE6LxN9Y34CxhmxJFuivxBefkTysY0rgmbGCiNiLUEEMzGJ02uvV50iB8B+mOCPDL+3Ud2SskbsqtZnB+69G1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQLDkLVr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765449125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RbvZl+vxzfLE3Kc7Wvw7PIUMKqNVOyqJtrnlb2bMgEM=;
	b=RQLDkLVrMMT+xeThohhMMDOia1mA3oHsFfhhdvOK2rkQa//3Dg1Kr7YrqKys9D8ReMoiUd
	r8dtanRvmbiF1Vgeek7X0W5kp4QElGgJKb8ChqKJowQYL8GHvSkD4KhMKAwY621cpEKrZv
	8Q7k/z2+DetIgj8TNOEsoGljehc91MU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-B-BrPfBkNr2nhG_Wj9i9dw-1; Thu,
 11 Dec 2025 05:31:56 -0500
X-MC-Unique: B-BrPfBkNr2nhG_Wj9i9dw-1
X-Mimecast-MFC-AGG-ID: B-BrPfBkNr2nhG_Wj9i9dw_1765449114
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A036118002EC;
	Thu, 11 Dec 2025 10:31:54 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.89])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C19AB1800451;
	Thu, 11 Dec 2025 10:31:49 +0000 (UTC)
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
Subject: [PATCH v2 2/3] hw/acpi: Add standalone function to build MADT
Date: Thu, 11 Dec 2025 11:31:35 +0100
Message-ID: <20251211103136.1578463-3-osteffen@redhat.com>
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

Add a fuction called `acpi_build_madt_standalone()` that builds a MADT
without the rest of the ACPI table structure.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 hw/i386/acpi-build.c | 8 ++++++++
 hw/i386/acpi-build.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 9446a9f862..e472876567 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2249,3 +2249,11 @@ void acpi_setup(void)
      */
     acpi_build_tables_cleanup(&tables, false);
 }
+
+GArray *acpi_build_madt_standalone(MachineState *machine) {
+  X86MachineState *x86ms = X86_MACHINE(machine);
+  GArray *table = g_array_new(false, true, 1);
+  acpi_build_madt(table, NULL, x86ms, x86ms->oem_id,
+                  x86ms->oem_table_id);
+  return table;
+}
diff --git a/hw/i386/acpi-build.h b/hw/i386/acpi-build.h
index 8ba3c33e48..00e19bbe5e 100644
--- a/hw/i386/acpi-build.h
+++ b/hw/i386/acpi-build.h
@@ -8,4 +8,6 @@ extern const struct AcpiGenericAddress x86_nvdimm_acpi_dsmio;
 void acpi_setup(void);
 Object *acpi_get_i386_pci_host(void);
 
+GArray *acpi_build_madt_standalone(MachineState *machine);
+
 #endif
-- 
2.52.0


