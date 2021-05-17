Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA753383253
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbhEQOrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240202AbhEQOlS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdagpMYPQdi+Q5aE/1/KjEIzB5PJOaprD7q5l0OSWE0=;
        b=MzVMrbXoNe/f/F7PeGfXyPl16+pFlyFBLNQjzzSDkyL4gO5E+DbG0STuuniSIcXSZ5ULND
        Ivg83ziK+IHihDmTP19HO4lJuZuws/mhFoDVLChFoD8Ri9Ez7jSVUB0RTigvi0A/G+Yrmu
        7ZzJP/QbGGOMyzBAe2A9GVbTCjptZGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-ffTJ_7OtMummbv5eOVBomg-1; Mon, 17 May 2021 10:39:42 -0400
X-MC-Unique: ffTJ_7OtMummbv5eOVBomg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 960111020C37;
        Mon, 17 May 2021 14:39:11 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 588B95D6D7;
        Mon, 17 May 2021 14:39:10 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 05/10] arm64: micro-bench: ioremap userspace_emulated_addr
Date:   Mon, 17 May 2021 16:38:55 +0200
Message-Id: <20210517143900.747013-6-drjones@redhat.com>
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
References: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should explicitly ioremap the userspace emulated address used
in the benchmark.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/micro-bench.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 95c418c10eb4..8e1d4abdf8a8 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -273,7 +273,9 @@ static void hvc_exec(void)
 	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
 }
 
-static void mmio_read_user_exec(void)
+static void *userspace_emulated_addr;
+
+static bool mmio_read_user_prep(void)
 {
 	/*
 	 * FIXME: Read device-id in virtio mmio here in order to
@@ -281,8 +283,12 @@ static void mmio_read_user_exec(void)
 	 * updated in the future if any relevant changes in QEMU
 	 * test-dev are made.
 	 */
-	void *userspace_emulated_addr = (void*)0x0a000008;
+	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
+	return true;
+}
 
+static void mmio_read_user_exec(void)
+{
 	readl(userspace_emulated_addr);
 }
 
@@ -309,14 +315,14 @@ struct exit_test {
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,		hvc_exec,		NULL,		65536,		true},
-	{"mmio_read_user",	NULL,		mmio_read_user_exec,	NULL,		65536,		true},
-	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	NULL,		65536,		true},
-	{"eoi",			NULL,		eoi_exec,		NULL,		65536,		true},
-	{"ipi",			ipi_prep,	ipi_exec,		NULL,		65536,		true},
-	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NULL,		65536,		true},
-	{"lpi",			lpi_prep,	lpi_exec,		NULL,		65536,		true},
-	{"timer_10ms",		timer_prep,	timer_exec,		timer_post,	256,		true},
+	{"hvc",			NULL,			hvc_exec,		NULL,		65536,		true},
+	{"mmio_read_user",	mmio_read_user_prep,	mmio_read_user_exec,	NULL,		65536,		true},
+	{"mmio_read_vgic",	NULL,			mmio_read_vgic_exec,	NULL,		65536,		true},
+	{"eoi",			NULL,			eoi_exec,		NULL,		65536,		true},
+	{"ipi",			ipi_prep,		ipi_exec,		NULL,		65536,		true},
+	{"ipi_hw",		ipi_hw_prep,		ipi_exec,		NULL,		65536,		true},
+	{"lpi",			lpi_prep,		lpi_exec,		NULL,		65536,		true},
+	{"timer_10ms",		timer_prep,		timer_exec,		timer_post,	256,		true},
 };
 
 struct ns_time {
-- 
2.30.2

