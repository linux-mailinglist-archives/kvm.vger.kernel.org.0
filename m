Return-Path: <kvm+bounces-69670-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDgXORxGfGnfLgIAu9opvQ
	(envelope-from <kvm+bounces-69670-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4497AB76CE
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63086302E423
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1706935C195;
	Fri, 30 Jan 2026 05:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6e0hMBH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6E32FF661
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752056; cv=none; b=SZhhqh8KhzGkKAlaGetjG7ketnTDTBzynp8fX/RgSWHKidht0eTpPOoDqXgCGi/A+ti7z3Ug0i23eD5IIey58ykaREKiMEWgC4+Z3F7j1Hr5MhlUMSRjTjT1hHwYz9taYRGMau3UtApYGXtKJ735g0RLrZuWekTV4d+UgnAnZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752056; c=relaxed/simple;
	bh=VU8Qza3S1AKHhzsNMdTyIAhFLSNWJJOZbBEXfAE9Ukw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcr7oAK0Rdw1332qduXYOwgQUtCV4+QiV330HyhTyG0U5xNBuvUwVHxW06SF+TwbY5q/4x+SwvxnOvTqd9UtATfBXfRPXCclg97KLnYZBzLqz81p2hhI0E5j8w5NTA/Az21AIezUAT7d+9odvA/9f64tKErcwo/bFbg2lS/323w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g6e0hMBH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769752054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pKeoqLnw94ekV3SKkVoM9wLZ2GlZHZ0eY7j3K1tcDgA=;
	b=g6e0hMBHS9l4Aipgc2Z4MLMyKLOX/AHplBD3kxj8WZ8TsAE3+fyP7glows3c9eJ4dqc3Zj
	dxQ3nw7hnH+QnLW8aRts3Gl7ARCC+uO/ujEbN5pcf9als4rURfUs44tg9PpDbPUtNnBr35
	RmS9gERVrmxYnLTOwWrTlNd6DGR0sLY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-Xg4ZZ5_KOomfVzHsx3HC0A-1; Fri,
 30 Jan 2026 00:47:30 -0500
X-MC-Unique: Xg4ZZ5_KOomfVzHsx3HC0A-1
X-Mimecast-MFC-AGG-ID: Xg4ZZ5_KOomfVzHsx3HC0A_1769752049
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA21F1956054;
	Fri, 30 Jan 2026 05:47:28 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.45.226.150])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E72619560A2;
	Fri, 30 Jan 2026 05:47:22 +0000 (UTC)
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
Subject: [PATCH v6 1/9] hw/acpi: Make acpi_checksum() public
Date: Fri, 30 Jan 2026 06:47:06 +0100
Message-ID: <20260130054714.715928-2-osteffen@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-69670-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 4497AB76CE
X-Rspamd-Action: no action

Make the ACPI table checksum calculation function (in core.c) public so
it can be reused in other parts of the ACPI code.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 hw/acpi/core.c         | 5 ++++-
 include/hw/acpi/acpi.h | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/hw/acpi/core.c b/hw/acpi/core.c
index d9979b0da9..6b65e587f2 100644
--- a/hw/acpi/core.c
+++ b/hw/acpi/core.c
@@ -83,7 +83,10 @@ bool acpi_builtin(void)
     return true;
 }
 
-static int acpi_checksum(const uint8_t *data, int len)
+/* Calculate the ACPI checksum value so that if used in the corresponding
+ * header field, the ACPI checksum verification will be successful.
+ */
+int acpi_checksum(const uint8_t *data, int len)
 {
     int sum, i;
     sum = 0;
diff --git a/include/hw/acpi/acpi.h b/include/hw/acpi/acpi.h
index 4b8ee094c4..b036116dfb 100644
--- a/include/hw/acpi/acpi.h
+++ b/include/hw/acpi/acpi.h
@@ -203,4 +203,7 @@ struct AcpiSlicOem {
 };
 int acpi_get_slic_oem(AcpiSlicOem *oem);
 
+/* core.c */
+int acpi_checksum(const uint8_t *data, int len);
+
 #endif /* QEMU_HW_ACPI_H */
-- 
2.52.0


