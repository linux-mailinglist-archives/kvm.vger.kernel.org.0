Return-Path: <kvm+bounces-31863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FD39C9011
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5C0FB42CE1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6E6199E8D;
	Thu, 14 Nov 2024 16:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QGJgIDhb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4500E19047E
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601143; cv=none; b=UdJyiY13aPiUHVJQ4puMIoa58EYN1RlvP/hhuo9V8MXaKlrQ5WAXiCjwAJDtiZTkvYOJFpP+eGTlVMO2A4KHeZuWGA0L2BYB5Eu2Ae5UHJ4awRFXyQLnAGnL+7UtjVtkItUE/Cj4pF1FGQmVU8TWTtrQgfv1bhkDhgQhSpAqZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601143; c=relaxed/simple;
	bh=+5wAhC0R7frfuir1SgBtFwo6bPSVn4yPznFFFiLyIwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwXDQvFsKhJKZbrkz0rpkkeHFF/EWnPT9f9QORgtoYkoB1yoBkK+GJ3OSy1EXu6E9ICuk+bYEX95q9LNhJDOrGJaH0fT7Dq0VOY9UBUOpvxbyBifHmr3hFF6GlHVfpgyNSfWgnPv1bj1f5AFa4b8/7UzBrLT3TMID4JjWmPyrd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QGJgIDhb; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43161e7bb25so7032725e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601140; x=1732205940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/DCjdoH/ZMLdfMdshfw9p7vCmVOtJEZSwKkAynWgoM=;
        b=QGJgIDhbAkAAY/B6opqYckVlEyHcaYHjA1IWoeuwxDzBmgfIy4AZwaBs88eMOUOCjb
         TIa2tQ1mmSC9k0v7j1TKlaj6x86b/c5BFThQ652X1esxVA2Oc5IBh/gWRAinK+eA3a/r
         NF6qCTDpc/BSJxekqWQxrlUGtUqPULXzmt5reU0x41aJsO5DSgSPcv3fqqZmtt8H9U60
         0lyF5sl0hfPUYiqchrbuLNmUSmYWLsoiKr2ysrtUU/hxNIxGQn0ik/tbSgISn57OnqCR
         RNiMAifwqZrL1oypd0Co9P6z0XBBhpEvlGUaGGojT+zY19hbeqP88gixi4J0dPr0lJIS
         9KuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601140; x=1732205940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/DCjdoH/ZMLdfMdshfw9p7vCmVOtJEZSwKkAynWgoM=;
        b=n/jK2PFGZ1J/AkJ4dWKu6IQFSlHddUlbdJO92nQF6baCBLDOt4SIaFXR8OsqKMy51f
         hYEYLK2eMqSkjc3Z3VXPPH0vsYVv3LxH19iJ3Kw8W1Kv8yEvzFfGq0D5EJA36z+e+Qlg
         FPqZQdqYeYu5zvUm0XUp9wf7bR85bHgriLa+eObXfCd49ZnHYzK4zN2k/eDaBbzS+Qi2
         R4e6KU1QiIBb6WCqsaDpbVcKv52g/ZX0CRPzJvxBF9xtEvegKp0JxO4nYQyCWoTjhhcP
         LIjTdseplVJ4dvouh6SOXOcP8iyZk7GEHXt5oixiLayjjhy9bjQy94f3qIPpE6UYh7nc
         J1Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXZQySmep6hjNriuTrP8vQunWfA1scIURUVqVxFsd+tBeAhptwATaaSrWnBp6CZpOr7WjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzmqGm3UOZ+Q7b7WfCzNXmOSS8yDRxCDFJIdYGWAQu80sImS9u
	+UlW6wbk4LHgsi3xccL/9hJBaHLCPXEzI2r835U5zcj1yjhu6GeOX5SSqXgxEkS1/Y9blJvnrdy
	lrOI=
X-Google-Smtp-Source: AGHT+IFaQ4hpn9NQyC7cNnSLRB13MgnD04TaYJf6YLnF9bvsb+UpgbykQ8H4jk6OiPjoZJw0SQKo9A==
X-Received: by 2002:a05:600c:5247:b0:42c:b63e:fe91 with SMTP id 5b1f17b1804b1-432cd474820mr91410355e9.24.1731601139559;
        Thu, 14 Nov 2024 08:18:59 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac1f94asm25135835e9.39.2024.11.14.08.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:59 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 07/15] iommu/riscv: Move definitions to iommu.h
Date: Thu, 14 Nov 2024 17:18:52 +0100
Message-ID: <20241114161845.502027-24-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to add the interrupt remapping support in a separate file,
share definitions through the header, as well as making some
functions public.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu-bits.h |  4 ++
 drivers/iommu/riscv/iommu.c      | 71 ++++----------------------------
 drivers/iommu/riscv/iommu.h      | 54 ++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 62 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index d72b982cf9bf..d3d98dbed709 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -36,6 +36,10 @@
 #define RISCV_IOMMU_ATP_PPN_FIELD	GENMASK_ULL(43, 0)
 #define RISCV_IOMMU_ATP_MODE_FIELD	GENMASK_ULL(63, 60)
 
+/* RISC-V IOMMU PPN <> PHYS address conversions, PHYS <=> PPN[53:10] */
+#define riscv_iommu_phys_to_ppn(pa)	(((pa) >> 2) & (((1ULL << 44) - 1) << 10))
+#define riscv_iommu_ppn_to_phys(pn)	(((pn) << 2) & (((1ULL << 44) - 1) << 12))
+
 /* 5.3 IOMMU Capabilities (64bits) */
 #define RISCV_IOMMU_REG_CAPABILITIES		0x0000
 #define RISCV_IOMMU_CAPABILITIES_VERSION	GENMASK_ULL(7, 0)
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index ef38a1bb3eca..6e8ea3d22ff5 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -24,23 +24,10 @@
 #include "iommu-bits.h"
 #include "iommu.h"
 
-/* Timeouts in [us] */
-#define RISCV_IOMMU_QCSR_TIMEOUT	150000
-#define RISCV_IOMMU_QUEUE_TIMEOUT	150000
-#define RISCV_IOMMU_DDTP_TIMEOUT	10000000
-#define RISCV_IOMMU_IOTINVAL_TIMEOUT	90000000
-
 /* Number of entries per CMD/FLT queue, should be <= INT_MAX */
 #define RISCV_IOMMU_DEF_CQ_COUNT	8192
 #define RISCV_IOMMU_DEF_FQ_COUNT	4096
 
-/* RISC-V IOMMU PPN <> PHYS address conversions, PHYS <=> PPN[53:10] */
-#define phys_to_ppn(pa)  (((pa) >> 2) & (((1ULL << 44) - 1) << 10))
-#define ppn_to_phys(pn)	 (((pn) << 2) & (((1ULL << 44) - 1) << 12))
-
-#define dev_to_iommu(dev) \
-	iommu_get_iommu_dev(dev, struct riscv_iommu_device, iommu)
-
 /* IOMMU PSCID allocation namespace. */
 static DEFINE_IDA(riscv_iommu_pscids);
 #define RISCV_IOMMU_MAX_PSCID		(BIT(20) - 1)
@@ -177,7 +164,7 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
 	if (!queue->base)
 		return -ENOMEM;
 
-	qb = phys_to_ppn(queue->phys) |
+	qb = riscv_iommu_phys_to_ppn(queue->phys) |
 	     FIELD_PREP(RISCV_IOMMU_QUEUE_LOG2SZ_FIELD, logsz);
 
 	/* Update base register and read back to verify hw accepted our write */
@@ -480,15 +467,15 @@ static irqreturn_t riscv_iommu_cmdq_process(int irq, void *data)
 }
 
 /* Send command to the IOMMU command queue */
-static void riscv_iommu_cmd_send(struct riscv_iommu_device *iommu,
-				 struct riscv_iommu_command *cmd)
+void riscv_iommu_cmd_send(struct riscv_iommu_device *iommu,
+			  struct riscv_iommu_command *cmd)
 {
 	riscv_iommu_queue_send(&iommu->cmdq, cmd, sizeof(*cmd));
 }
 
 /* Send IOFENCE.C command and wait for all scheduled commands to complete. */
-static void riscv_iommu_cmd_sync(struct riscv_iommu_device *iommu,
-				 unsigned int timeout_us)
+void riscv_iommu_cmd_sync(struct riscv_iommu_device *iommu,
+			  unsigned int timeout_us)
 {
 	struct riscv_iommu_command cmd;
 	unsigned int prod;
@@ -614,7 +601,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
 		do {
 			ddt = READ_ONCE(*(unsigned long *)ddtp);
 			if (ddt & RISCV_IOMMU_DDTE_V) {
-				ddtp = __va(ppn_to_phys(ddt));
+				ddtp = __va(riscv_iommu_ppn_to_phys(ddt));
 				break;
 			}
 
@@ -622,7 +609,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
 			if (!ptr)
 				return NULL;
 
-			new = phys_to_ppn(__pa(ptr)) | RISCV_IOMMU_DDTE_V;
+			new = riscv_iommu_phys_to_ppn(__pa(ptr)) | RISCV_IOMMU_DDTE_V;
 			old = cmpxchg_relaxed((unsigned long *)ddtp, ddt, new);
 
 			if (old == ddt) {
@@ -687,7 +674,7 @@ static int riscv_iommu_iodir_alloc(struct riscv_iommu_device *iommu)
 		if (ddtp & RISCV_IOMMU_DDTP_BUSY)
 			return -EBUSY;
 
-		iommu->ddt_phys = ppn_to_phys(ddtp);
+		iommu->ddt_phys = riscv_iommu_ppn_to_phys(ddtp);
 		if (iommu->ddt_phys)
 			iommu->ddt_root = devm_ioremap(iommu->dev,
 						       iommu->ddt_phys, PAGE_SIZE);
@@ -734,7 +721,7 @@ static int riscv_iommu_iodir_set_mode(struct riscv_iommu_device *iommu,
 	do {
 		rq_ddtp = FIELD_PREP(RISCV_IOMMU_DDTP_IOMMU_MODE, rq_mode);
 		if (rq_mode > RISCV_IOMMU_DDTP_IOMMU_MODE_BARE)
-			rq_ddtp |= phys_to_ppn(iommu->ddt_phys);
+			rq_ddtp |= riscv_iommu_phys_to_ppn(iommu->ddt_phys);
 
 		riscv_iommu_writeq(iommu, RISCV_IOMMU_REG_DDTP, rq_ddtp);
 		ddtp = riscv_iommu_read_ddtp(iommu);
@@ -799,49 +786,9 @@ static int riscv_iommu_iodir_set_mode(struct riscv_iommu_device *iommu,
 	return 0;
 }
 
-/* This struct contains protection domain specific IOMMU driver data. */
-struct riscv_iommu_domain {
-	struct iommu_domain domain;
-	struct list_head bonds;
-	spinlock_t lock;		/* protect bonds list updates. */
-	int pscid;
-	int gscid;
-	bool amo_enabled;
-	int numa_node;
-	unsigned int pgd_mode;
-	unsigned long *pgd_root;
-};
-
 #define iommu_domain_to_riscv(iommu_domain) \
 	container_of(iommu_domain, struct riscv_iommu_domain, domain)
 
-/* Private IOMMU data for managed devices, dev_iommu_priv_* */
-struct riscv_iommu_info {
-	struct riscv_iommu_domain *domain;
-};
-
-/*
- * Linkage between an iommu_domain and attached devices.
- *
- * Protection domain requiring IOATC and DevATC translation cache invalidations,
- * should be linked to attached devices using a riscv_iommu_bond structure.
- * Devices should be linked to the domain before first use and unlinked after
- * the translations from the referenced protection domain can no longer be used.
- * Blocking and identity domains are not tracked here, as the IOMMU hardware
- * does not cache negative and/or identity (BARE mode) translations, and DevATC
- * is disabled for those protection domains.
- *
- * The device pointer and IOMMU data remain stable in the bond struct after
- * _probe_device() where it's attached to the managed IOMMU, up to the
- * completion of the _release_device() call. The release of the bond structure
- * is synchronized with the device release.
- */
-struct riscv_iommu_bond {
-	struct list_head list;
-	struct rcu_head rcu;
-	struct device *dev;
-};
-
 static int riscv_iommu_bond_link(struct riscv_iommu_domain *domain,
 				 struct device *dev)
 {
diff --git a/drivers/iommu/riscv/iommu.h b/drivers/iommu/riscv/iommu.h
index b1c4664542b4..dd538b19fbb7 100644
--- a/drivers/iommu/riscv/iommu.h
+++ b/drivers/iommu/riscv/iommu.h
@@ -17,8 +17,35 @@
 
 #include "iommu-bits.h"
 
+/* Timeouts in [us] */
+#define RISCV_IOMMU_QCSR_TIMEOUT	150000
+#define RISCV_IOMMU_QUEUE_TIMEOUT	150000
+#define RISCV_IOMMU_DDTP_TIMEOUT	10000000
+#define RISCV_IOMMU_IOTINVAL_TIMEOUT	90000000
+
+/* This struct contains protection domain specific IOMMU driver data. */
+struct riscv_iommu_domain {
+	struct iommu_domain domain;
+	struct list_head bonds;
+	spinlock_t lock;			/* protect bonds list updates. */
+	int pscid;
+	int gscid;
+	int amo_enabled;
+	int numa_node;
+	unsigned int pgd_mode;
+	unsigned long *pgd_root;
+};
+
+/* Private IOMMU data for managed devices, dev_iommu_priv_* */
+struct riscv_iommu_info {
+	struct riscv_iommu_domain *domain;
+};
+
 struct riscv_iommu_device;
 
+#define dev_to_iommu(dev) \
+	iommu_get_iommu_dev(dev, struct riscv_iommu_device, iommu)
+
 struct riscv_iommu_queue {
 	atomic_t prod;				/* unbounded producer allocation index */
 	atomic_t head;				/* unbounded shadow ring buffer consumer index */
@@ -62,9 +89,36 @@ struct riscv_iommu_device {
 	u64 *ddt_root;
 };
 
+/*
+ * Linkage between an iommu_domain and attached devices.
+ *
+ * Protection domain requiring IOATC and DevATC translation cache invalidations,
+ * should be linked to attached devices using a riscv_iommu_bond structure.
+ * Devices should be linked to the domain before first use and unlinked after
+ * the translations from the referenced protection domain can no longer be used.
+ * Blocking and identity domains are not tracked here, as the IOMMU hardware
+ * does not cache negative and/or identity (BARE mode) translations, and DevATC
+ * is disabled for those protection domains.
+ *
+ * The device pointer and IOMMU data remain stable in the bond struct after
+ * _probe_device() where it's attached to the managed IOMMU, up to the
+ * completion of the _release_device() call. The release of the bond structure
+ * is synchronized with the device release.
+ */
+struct riscv_iommu_bond {
+	struct list_head list;
+	struct rcu_head rcu;
+	struct device *dev;
+};
+
 int riscv_iommu_init(struct riscv_iommu_device *iommu);
 void riscv_iommu_remove(struct riscv_iommu_device *iommu);
 
+void riscv_iommu_cmd_send(struct riscv_iommu_device *iommu,
+			  struct riscv_iommu_command *cmd);
+void riscv_iommu_cmd_sync(struct riscv_iommu_device *iommu,
+			  unsigned int timeout_us);
+
 #define riscv_iommu_readl(iommu, addr) \
 	readl_relaxed((iommu)->reg + (addr))
 
-- 
2.47.0


