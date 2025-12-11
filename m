Return-Path: <kvm+bounces-65739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEA9CB516E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4BA930463A0
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEEF295516;
	Thu, 11 Dec 2025 08:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BxRLrZmW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABFC27F171
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765440943; cv=none; b=p2evqpgvPMApXbZ6MZ9gcSmCaV1bd6kOIFHQd/Sgpdn2jzXwhQTga3wGqG6LlvBfpMFyEk224DQFtiHT02k8UN+XUsnPic+Pr5xdG6x3tZlOSbpRzwY3lSUOYvmli1yfNWfAj7wn6gxeJT+FDwDeQdRrTcTlQVDKz05yqSzbgLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765440943; c=relaxed/simple;
	bh=ZYMW24kNKTUdiGXyRbfAi6V3VGnGpdYxvzCbj5jO7L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMbaz5EHkcP+lLIH1LdHTRFH0zBHme5w+BYSHnR60nnv6HIKqKO1p0oSazwCqlVAeHmmC+gw7Oy4UA40IItUBzmy7hLFqQnbFesQ6/A10FGclIgRgBgqrfL66FYgqW30U+dos29qyteAwN0pwWjuBV0KU0xI5W3sJnhPNjBt9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BxRLrZmW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765440941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RbvZl+vxzfLE3Kc7Wvw7PIUMKqNVOyqJtrnlb2bMgEM=;
	b=BxRLrZmWDHr9sELWe7pESK0XSWDc0+dOf8iAwtDWqA0YxlXh6wDVmg0Qlzjy+D9cKrJZaM
	9WhUMnlV3ondGvOdVHwYColOwsGL4Qnujd4ILPtq3IekWt/bc28IdJChfGmgkuVaEZiqpy
	y4Citz1LW4bMUa3+UCaTeBmNoyr2q2w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-HSliwGdDPdKxVCZPPH6PeQ-1; Thu,
 11 Dec 2025 03:15:37 -0500
X-MC-Unique: HSliwGdDPdKxVCZPPH6PeQ-1
X-Mimecast-MFC-AGG-ID: HSliwGdDPdKxVCZPPH6PeQ_1765440936
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04FD9195F156;
	Thu, 11 Dec 2025 08:15:36 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.89])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0663C30001A2;
	Thu, 11 Dec 2025 08:15:30 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Joerg Roedel <joerg.roedel@amd.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH 2/3] hw/acpi: Add standalone function to build MADT
Date: Thu, 11 Dec 2025 09:15:16 +0100
Message-ID: <20251211081517.1546957-3-osteffen@redhat.com>
In-Reply-To: <20251211081517.1546957-1-osteffen@redhat.com>
References: <20251211081517.1546957-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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


