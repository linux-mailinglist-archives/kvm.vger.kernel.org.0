Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A383574B1
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhDGS7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:59:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348702AbhDGS7t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 14:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6WxyRAp6RNCUYZydrWBy02gx1gkkcvZFYdhfqWAaBn8=;
        b=SI/Fnl+RytUQ0JIqia+b26t9NRbfzw6eUpI1in5qYq1KkJy6xPWp0YWYOXaWPNaJ/hh1ZQ
        pCLe3j1TNvEwvB3x3JuZoHVqlyJoxlFaA/QujIyOjIUXcmFJ1y//uyJPHwDEcnhJJhEIEw
        JMgu8FVhx1bFSYBOJfthoEFjc/Eamdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-Gp8Vf8ItO8mnHmxdROBKug-1; Wed, 07 Apr 2021 14:59:37 -0400
X-MC-Unique: Gp8Vf8ItO8mnHmxdROBKug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EB3191271;
        Wed,  7 Apr 2021 18:59:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AD3360CEA;
        Wed,  7 Apr 2021 18:59:34 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 3/8] pci-testdev: ioremap regions
Date:   Wed,  7 Apr 2021 20:59:13 +0200
Message-Id: <20210407185918.371983-4-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't assume the physical addresses used with PCI have already been
identity mapped.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/pci-host-generic.c | 5 ++---
 lib/pci-host-generic.h | 4 ++--
 lib/pci-testdev.c      | 4 ++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
index 818150dc0a66..de93b8feac39 100644
--- a/lib/pci-host-generic.c
+++ b/lib/pci-host-generic.c
@@ -122,7 +122,7 @@ static struct pci_host_bridge *pci_dt_probe(void)
 		      sizeof(host->addr_space[0]) * nr_addr_spaces);
 	assert(host != NULL);
 
-	host->start		= base.addr;
+	host->start		= ioremap(base.addr, base.size);
 	host->size		= base.size;
 	host->bus		= bus;
 	host->bus_max		= bus_max;
@@ -279,8 +279,7 @@ phys_addr_t pci_host_bridge_get_paddr(u64 pci_addr)
 
 static void __iomem *pci_get_dev_conf(struct pci_host_bridge *host, int devfn)
 {
-	return (void __iomem *)(unsigned long)
-		host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
+	return (void __iomem *)host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
 }
 
 u8 pci_config_readb(pcidevaddr_t dev, u8 off)
diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
index fd30e7c74ed8..0ffe6380ec8f 100644
--- a/lib/pci-host-generic.h
+++ b/lib/pci-host-generic.h
@@ -18,8 +18,8 @@ struct pci_addr_space {
 };
 
 struct pci_host_bridge {
-	phys_addr_t		start;
-	phys_addr_t		size;
+	void __iomem		*start;
+	size_t			size;
 	int			bus;
 	int			bus_max;
 	int			nr_addr_spaces;
diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
index 039bb44781c1..4f2e5663b2d6 100644
--- a/lib/pci-testdev.c
+++ b/lib/pci-testdev.c
@@ -185,7 +185,11 @@ int pci_testdev(void)
 	mem = ioremap(addr, PAGE_SIZE);
 
 	addr = pci_bar_get_addr(&pci_dev, 1);
+#if defined(__i386__) || defined(__x86_64__)
 	io = (void *)(unsigned long)addr;
+#else
+	io = ioremap(addr, PAGE_SIZE);
+#endif
 
 	nr_tests += pci_testdev_all(mem, &pci_testdev_mem_ops);
 	nr_tests += pci_testdev_all(io, &pci_testdev_io_ops);
-- 
2.26.3

