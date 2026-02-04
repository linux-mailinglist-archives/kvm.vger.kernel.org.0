Return-Path: <kvm+bounces-70266-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mC6cEC6Yg2lnpwMAu9opvQ
	(envelope-from <kvm+bounces-70266-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:04:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CEBEBD76
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C32193015A72
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 19:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6343427A16;
	Wed,  4 Feb 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/sjk6wX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RjTHlpsZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E22367B5
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 19:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231845; cv=none; b=Cw5NAkO/Cp2iJRlN0PR3PwhZqeTzEKllGuQHaOlJySAGudydFO+KNGT3PAjz21sgfaWV4vBb3WkbfGn2vd9fyFuk2YtlZvqcD3vGfO80D5ntpSVc2ZZfudZIM5xwITLq3c9dC4DAYird8Ce+E7lQO7WBXWvXf6oVKhkHsZi5qdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231845; c=relaxed/simple;
	bh=vE8DQL76s4TcuUwBIMs9rh8N/GnzJfzppjcOoChPOB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAGn6tw+mxaMYtt/waMyOHbNbNKQEOyUf2SpkKrH0z9ldgAe917XX/NZeKrdjOG/vYSHtU3lmTxjnWnTeNMUpeCWZvPW+n1IfYWflAh0CtfzNmVH+mcLZ16nSLsC8SxqQG+oeAQMU/Mv5MurC7NfA6sa2DqJDYdaA3PpfXpoWTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/sjk6wX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RjTHlpsZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770231843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6HhJDWdiH+sSKLH6a+nIbjrvZv2j3XojMKDoG+stmr4=;
	b=g/sjk6wXZ078RasBJN3CWEt3bTkESMIGgUB7lg0rRAjPn8tsLZDXXLoRtOPzqTVeKHU5Fk
	Q1We7cp2bPAOEeGcNWrOOP6YsOAFcr2eGMxxATRT5NJuRqVpN3FZs6kXBJUjjogkgt/YP2
	2JUh5wm63ghqWtR/ZrPRWx0QYOYIjy8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-lRmza_7vMtGu9lRQC7qIaw-1; Wed, 04 Feb 2026 14:04:02 -0500
X-MC-Unique: lRmza_7vMtGu9lRQC7qIaw-1
X-Mimecast-MFC-AGG-ID: lRmza_7vMtGu9lRQC7qIaw_1770231841
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48057c39931so1466745e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 11:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770231841; x=1770836641; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6HhJDWdiH+sSKLH6a+nIbjrvZv2j3XojMKDoG+stmr4=;
        b=RjTHlpsZPqg6RopxZSud/SJ4/xPE1/aLt4TRk4YWZnpse14cq60x/gZeqQz98EiARi
         u04ylG4D268IhrkD0Gkof+5lXb78dxs18JhAHBinoU2Ntnd9MsBmFNSyQvKwWfl8TD2X
         iyaTrJsVVgEOgXMc9YFfVpvCPRuQObtPMQlm6zVLftbTIbOYKKdQLhzQLw8O2XSPXErR
         gECZdgUvM08weUOe5j1dYuwXZ1MCttYIWX5E0dK2+rOknwrIt0hB7UTH2e25xCaGjxvP
         diGYxBrT6y18g5PIXTbUiVUEZTlXKUw1HDveoJEXFKYZaXCHjuIFlxX70M09+EtH+F7a
         05Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770231841; x=1770836641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6HhJDWdiH+sSKLH6a+nIbjrvZv2j3XojMKDoG+stmr4=;
        b=B2rqsJrfrkGg3l0lgHKo0Nh9tC73t4BzO11uWFTW9ImDsIyYf9DJYi8ykOxbK8UVDa
         A5cYiQUroQ8S+saub1Th58lOlV2ukcHq5W49/W/ETZZwLRKY0fQxIZiUySue+FVRXlM0
         6WuJA8QpTajrapDOVHuhMYfX/BLZLS6+PwNKxi1mzzIknb+vv/ksslXEhh9w4RSX1f7y
         0M5AKuKJIOLRmNEuO+/6Dk0zqZ8s7oYPoewZsrmcRW7KF/GLJUmOebXM9Cqn3jux/Amq
         I/VXvfyh4VLvZ2/tQH14sAZn6pF86bJ0VOZM50SOQTs+q93/TqMjwAN7F0yaSqy9XEWq
         +kQg==
X-Forwarded-Encrypted: i=1; AJvYcCUW+gHDSXZ0P0eGUCeA1y3WKnFAIhL/jmhyc20181R7iiif/H51Tg6ixnJ6XekvWY6+M0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBrpqVBecswaMYk/WgJgA69qcijsXEii+wDEtXpC2DkPcqMBf+
	eBqYn0Xdml482X+ebHPJiAhR6rC88QWM0e9w4XtnEpzYxdJpD9t9+2MJ6RNuhEjxoARlTYUXihT
	3A7E7hRx5XQ0qIphbb0TzsrgdxbUJZ3mWgY/uN75vJ22LSWG5m3roJC9+gL0W9w==
X-Gm-Gg: AZuq6aKXxx/OxfPhiFt1dtNOkhBzpMHjnawRle/L/py9ACT8/Si7AzTM0AXUCNu61dn
	hSrgfHjAT73oXKnMlDAvVUHQ0LzNC9xX9BzdjR6qg0r86sZXlzV+OpEItcy+imNp33RwzL4WnwC
	RUVo6DMDiSk7W+EQS1RKF4k+6LqtH7BK30fe7Bevvk4G9hXnTyLzjXqbOWE77fbqkPECVjdgyyI
	QUSmR7XceHSjVWZS/1L2fHlDA6FSvz+PNCyWIk5lLOj353wIJIUvAhM2hKn0q+mcWhq6IM4+j+j
	c5S8wMFEjlm1s5bQlG1PzFVf6PGROJD4LW2TFj9MFedzVVio6PAs2WERF8DY9LV6jQKylTATA2s
	kHTYmXlhgIVySL5zDzF/2VEwbSwKfz9BbOw==
X-Received: by 2002:a05:600c:4e4f:b0:477:5cc6:7e44 with SMTP id 5b1f17b1804b1-4830e9335cfmr55705195e9.11.1770231841046;
        Wed, 04 Feb 2026 11:04:01 -0800 (PST)
X-Received: by 2002:a05:600c:4e4f:b0:477:5cc6:7e44 with SMTP id 5b1f17b1804b1-4830e9335cfmr55704845e9.11.1770231840650;
        Wed, 04 Feb 2026 11:04:00 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d345c2sm5071665e9.6.2026.02.04.11.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 11:03:59 -0800 (PST)
Date: Wed, 4 Feb 2026 14:03:57 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Gavin Shan <gshan@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 30/51] acpi/ghes: Use error_fatal in acpi_ghes_memory_errors()
Message-ID: <2f6dc473b905c5c82370f74debc56d5f673d2db7.1770231744.git.mst@redhat.com>
References: <cover.1770231744.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1770231744.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[linaro.org,redhat.com,huawei.com,kernel.org,gmail.com,nongnu.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70266-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,huawei];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,huawei.com:email]
X-Rspamd-Queue-Id: A9CEBEBD76
X-Rspamd-Action: no action

From: Gavin Shan <gshan@redhat.com>

Use error_fatal in acpi_ghes_memory_errors() so that the caller needn't
explicitly call exit(). The return value of acpi_ghes_memory_errors()
and ghes_record_cper_errors() is changed to 'bool' indicating an error
has been raised, to be compatible with what's documented in error.h.

Suggested-by: Igor Mammedov <imammedo@redhat.com>
Suggested-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251201141803.2386129-6-gshan@redhat.com>
---
 hw/acpi/ghes-stub.c    |  4 ++--
 hw/acpi/ghes.c         | 26 ++++++++++----------------
 include/hw/acpi/ghes.h |  6 +++---
 target/arm/kvm.c       |  9 +++------
 4 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index b54f1b093c..5f9313cce9 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,8 +11,8 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
-                            uint64_t physical_address)
+bool acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                             uint64_t physical_address, Error **errp)
 {
     g_assert_not_reached();
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index d51d4bd466..c42f1721c4 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -516,14 +516,14 @@ static bool get_ghes_source_offsets(uint16_t source_id,
 NotifierList acpi_generic_error_notifiers =
     NOTIFIER_LIST_INITIALIZER(acpi_generic_error_notifiers);
 
-void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
+bool ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
                              uint16_t source_id, Error **errp)
 {
     uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
 
     if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
         error_setg(errp, "GHES CPER record is too big: %zd", len);
-        return;
+        return false;
     }
 
     if (!ags->use_hest_addr) {
@@ -532,7 +532,7 @@ void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
     } else if (!get_ghes_source_offsets(source_id,
                     le64_to_cpu(ags->hest_addr_le),
                     &cper_addr, &read_ack_register_addr, errp)) {
-            return;
+            return false;
     }
 
     cpu_physical_memory_read(read_ack_register_addr,
@@ -543,7 +543,7 @@ void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
         error_setg(errp,
                    "OSPM does not acknowledge previous error,"
                    " so can not record CPER for current error anymore");
-        return;
+        return false;
     }
 
     read_ack_register = cpu_to_le64(0);
@@ -558,16 +558,17 @@ void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
     cpu_physical_memory_write(cper_addr, cper, len);
 
     notifier_list_notify(&acpi_generic_error_notifiers, &source_id);
+
+    return true;
 }
 
-int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
-                            uint64_t physical_address)
+bool acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                             uint64_t physical_address, Error **errp)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
           UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
                   0xED, 0x7C, 0x83, 0xB1);
-    Error *err = NULL;
     int data_length;
     g_autoptr(GArray) block = g_array_new(false, true /* clear */, 1);
 
@@ -584,15 +585,8 @@ int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
     /* Build the memory section CPER for above new generic error data entry */
     acpi_ghes_build_append_mem_cper(block, physical_address);
 
-    /* Report the error */
-    ghes_record_cper_errors(ags, block->data, block->len, source_id, &err);
-
-    if (err) {
-        error_report_err(err);
-        return -1;
-    }
-
-    return 0;
+    return ghes_record_cper_errors(ags, block->data, block->len,
+                                   source_id, errp);
 }
 
 AcpiGhesState *acpi_ghes_get_state(void)
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index df2ecbf6e4..5b29aae4dd 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -98,9 +98,9 @@ void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
-int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
-                            uint64_t error_physical_addr);
-void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
+bool acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t error_physical_addr, Error **errp);
+bool ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
 
 /**
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b83f1d5e4f..3e35570f15 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2473,12 +2473,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC,
-                                             paddr)) {
-                    kvm_inject_arm_sea(c);
-                } else {
-                    exit(1);
-                }
+                acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC,
+                                        paddr, &error_fatal);
+                kvm_inject_arm_sea(c);
             }
             return;
         }
-- 
MST


