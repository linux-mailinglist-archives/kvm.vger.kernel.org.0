Return-Path: <kvm+bounces-70001-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mF20I3nlgWl0LwMAu9opvQ
	(envelope-from <kvm+bounces-70001-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:09:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FAFD8D13
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C981031456AF
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0F033AD93;
	Tue,  3 Feb 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqHaQb05"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13033D6D9
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120242; cv=none; b=AoOEqy4LK1TYI5qAAVlrNdoZawaJck3msDU/2iSmn+dqGKfJ00VBFQy8TMLaomkV9kHTBRu8xhoVJ1xXALm5syJp7mitweQqxiRfYEhbdbrv0TH31XiM7JOJH5l4dC0LJIewcVA1B+vadYScv92XZtDCihOkAoqwRvZLAZU3hzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120242; c=relaxed/simple;
	bh=yQgtQuOVQ1k8SJcHl0Kplva8G+cv3/SRORi1j1PK2nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0GxOzK80En5pwyUNfiUCs/hDVtzEXcPjnywkfsdXAXRBbAkE+6QTVZ12CoEihShvAQuKtTUMbcg40htfosLGZfpOJaNnR4rb0n1HBFDmYC+BfMptrMyEEBrkIELPKniRQaoRob1HO6MAQGc1Hln6GMM5/7F+kEUwTJAGcYAqi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqHaQb05; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1agyvkjrIJh1mqxFUhB4jvdperkHnQ8oP0vEdyLunIg=;
	b=OqHaQb051ZTfIEGPskkSuJCRDBCgdDBAvnk4cVaPLqGeq8lRHEnNz2ynSrLdfoCtof4vsE
	PGd3E1voHcCqwseWlX2dwMQFnLcB+poTRMPg1Qo57xXRgLLR7ib/LOjRrBlvSSOQpvye0o
	NF9//w4T8JhRQhWqjSmHevkICNVWR9Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-viQ6p2EEN5W2cgpBKk7Ncg-1; Tue,
 03 Feb 2026 07:03:59 -0500
X-MC-Unique: viQ6p2EEN5W2cgpBKk7Ncg-1
X-Mimecast-MFC-AGG-ID: viQ6p2EEN5W2cgpBKk7Ncg_1770120237
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A54DB18005BA;
	Tue,  3 Feb 2026 12:03:57 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E82E19560B2;
	Tue,  3 Feb 2026 12:03:57 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 241C01807DDE; Tue, 03 Feb 2026 13:03:44 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PULL 09/17] hw/acpi: Make acpi_checksum() public
Date: Tue,  3 Feb 2026 13:03:34 +0100
Message-ID: <20260203120343.656961-10-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
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
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70001-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kraxel@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 35FAFD8D13
X-Rspamd-Action: no action

From: Oliver Steffen <osteffen@redhat.com>

Make the ACPI table checksum calculation function (in core.c) public so
it can be reused in other parts of the ACPI code.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
Message-ID: <20260130054714.715928-2-osteffen@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/hw/acpi/acpi.h | 3 +++
 hw/acpi/core.c         | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/hw/acpi/acpi.h b/include/hw/acpi/acpi.h
index 4b8ee094c419..b036116dfb87 100644
--- a/include/hw/acpi/acpi.h
+++ b/include/hw/acpi/acpi.h
@@ -203,4 +203,7 @@ struct AcpiSlicOem {
 };
 int acpi_get_slic_oem(AcpiSlicOem *oem);
 
+/* core.c */
+int acpi_checksum(const uint8_t *data, int len);
+
 #endif /* QEMU_HW_ACPI_H */
diff --git a/hw/acpi/core.c b/hw/acpi/core.c
index d9979b0da949..6b65e587f2a5 100644
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
-- 
2.52.0


