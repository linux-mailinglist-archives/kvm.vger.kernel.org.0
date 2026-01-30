Return-Path: <kvm+bounces-69672-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mehHJTNGfGn+LgIAu9opvQ
	(envelope-from <kvm+bounces-69672-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DBBB76E4
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6660A3035271
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98D935C195;
	Fri, 30 Jan 2026 05:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+Y8YDeb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00216DDA9
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752068; cv=none; b=IeCI7rXzwRjOM2+rTB5tD+mXqx4utc+C2BmGsHZA0WPy0gble9KfL3zr0C8fYf6JnEQxkNn12V4MSeS2/xP+2E2PB9ZEgxsKWOH9qGRrSOF0Wj3PLB56nbqyJhdrtBHK7F7YUKTJiIdnGcIXQaCFM5E3brTgf/7iO0WHZaF4NAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752068; c=relaxed/simple;
	bh=oMHpk2cMAhF6NnxyHJXHsjG99cfVzjJN6uppq3b3wug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHm8QXhVvPMfk9C/Pg29LVFHwoF00NP3nZqvGYFnYRtRGN7bmtBH9RSMIv0rXohzxh7MztnbCz3GlsKu+bOOOaLPLskGohdEuP/0zxH/fi7x7QkfSdDuxSHNqAyh6hisMnR0uj5G9FA/KgrZuHvobmWxPzZGWQZ0X5Au/DwtZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+Y8YDeb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769752066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrXq5XPq57Dmv4jNJrrZOk6iLltjBvZVxbwDGavrQFg=;
	b=L+Y8YDebdoEJQWmsgUWVbzINaZ96sDYGXrV2PUcT4VUdUw3ODBCV5k/AdiYJUUdlkz334w
	48IlbH0qMe1ytjqCQYdaaOIks6bR973toTI/lOvo57FMgmxQQKSer7DHUv9TPtJ4jRE+Gy
	HiyF0NQBHn2e/upwQDUCY7Qib0+pebY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-FyAiZ6omMpGdEnokQBM1GA-1; Fri,
 30 Jan 2026 00:47:41 -0500
X-MC-Unique: FyAiZ6omMpGdEnokQBM1GA-1
X-Mimecast-MFC-AGG-ID: FyAiZ6omMpGdEnokQBM1GA_1769752060
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DF16195605A;
	Fri, 30 Jan 2026 05:47:40 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.45.226.150])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5AE6919560A2;
	Fri, 30 Jan 2026 05:47:34 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v6 3/9] hw/acpi: Add standalone function to build MADT
Date: Fri, 30 Jan 2026 06:47:08 +0100
Message-ID: <20260130054714.715928-4-osteffen@redhat.com>
In-Reply-To: <20260130054714.715928-1-osteffen@redhat.com>
References: <20260130054714.715928-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,intel.com,habkost.net,vger.kernel.org,linaro.org,amd.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69672-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 18DBBB76E4
X-Rspamd-Action: no action

Add a function called `acpi_build_madt_standalone()` that builds a MADT
without the rest of the ACPI table structure.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 hw/i386/acpi-build.c | 9 +++++++++
 hw/i386/acpi-build.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 9446a9f862..19c62362e3 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2249,3 +2249,12 @@ void acpi_setup(void)
      */
     acpi_build_tables_cleanup(&tables, false);
 }
+
+GArray *acpi_build_madt_standalone(MachineState *machine)
+{
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


