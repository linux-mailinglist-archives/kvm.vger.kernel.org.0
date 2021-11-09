Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9285444A4D2
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbhKICmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbhKICmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:01 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A09C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:16 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id r11-20020a170902be0b00b0013f4f30d71cso7656624pls.21
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=loxMeAeqhpiKSvyXoOE21nDz6NxFuQUOOaGjcUtPr9Y=;
        b=MPBHIzvwhMn3f4yNpS714cQcUrKXhSzFKQhJJsxLnKNQ270GW+osyzjO9GvjzIpyiD
         1k0VBUDy5gEAe3BwH7vYKZniPHXtHs+f/a0jCvHUhVjKAiP177Xu5skV1xi3ytJ/uN8X
         u6bYt4Rlu2bZdGlg96xUNOoV2Y8TRV9XyavcoV4jmXmxVX36aXl4qYBWpn2myOO1AyuN
         kRxAJ3Gmdw9vMQhilsQlfH4ZYhBkMILM0tzSqgcQQpDkvXom+HrTVCRKYGIuZBLDMyhV
         V6ylEC7dCxpE3ShHS0oQyddi7Xnswq2xD1iSxLiCNJY7G5zBYQ13b9tztn6kzb6vQ5i4
         pdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=loxMeAeqhpiKSvyXoOE21nDz6NxFuQUOOaGjcUtPr9Y=;
        b=nuxXedcw4OkX5CJANCBLqrycrC4nwJYXBLuGcj9gj7A1R/ymj9XD7Q1oXotBVBPRo1
         MCYsHKs2miCWmBoSoV9nN6kw2Ezxmense7yllw5Zj067y57ll8K6qgv/D8ezXRutns4l
         oVkNefsE1HKnIm6C9XksgD/Mg62e5eECZjmFPBa/Tmbo4KsUwNUIn+3MUZRILcyZdvU3
         f/3XmC2DdFXwIJ+4Iqwllzwqq/Hx6OpS92R+akNXnGEkyBs+bXNg2AvnbNw+7eYu4yBD
         nXdI65uJub50rMU2ZJDRss6re1sgxcCCAkT9jW+mpS5W+LQ05rQ0npuQ+qHoI2Tx47/F
         q5ug==
X-Gm-Message-State: AOAM533/0Gq2A6OkxXwbuZe1dGlpLa45wTynuZHIfBcGag16vXBu8OI5
        +mxR32FUZsZGX0uaSGbjmQSR4Xa0gnsbRNI0N/Skr+PABk9JCD3bAOHDX0C56IAn0sxcrSe+hbi
        1vTbeKBaVqXhUPlFuNydjVvZlJs1b9JIS5jCvy2cf6vnWqKAItJ6JblHFe7Kz01Y=
X-Google-Smtp-Source: ABdhPJx4by6npC6Bw0eZYMhu8Sm094t2D7pgKDmPKyanQSa9LkHub+gt4LWj8jhp7QyGQhSy5iSsdpoTBcdQ8w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:9197:0:b0:44d:a2e9:72cf with SMTP id
 x23-20020aa79197000000b0044da2e972cfmr4519442pfa.38.1636425555973; Mon, 08
 Nov 2021 18:39:15 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:51 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 02/17] KVM: selftests: aarch64: add function for accessing
 GICv3 dist and redist registers
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a generic library function for reading and writing GICv3 distributor
and redistributor registers. Then adapt some functions to use it; more
will come and use it in the next commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 124 ++++++++++++++----
 1 file changed, 101 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 2dbf3339b62e..00e944fd8148 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -19,7 +19,8 @@ struct gicv3_data {
 	unsigned int nr_spis;
 };
 
-#define sgi_base_from_redist(redist_base) (redist_base + SZ_64K)
+#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
+#define DIST_BIT				(1U << 31)
 
 enum gicv3_intid_range {
 	SGI_RANGE,
@@ -50,6 +51,14 @@ static void gicv3_gicr_wait_for_rwp(void *redist_base)
 	}
 }
 
+static void gicv3_wait_for_rwp(uint32_t cpu_or_dist)
+{
+	if (cpu_or_dist & DIST_BIT)
+		gicv3_gicd_wait_for_rwp();
+	else
+		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu_or_dist]);
+}
+
 static enum gicv3_intid_range get_intid_range(unsigned int intid)
 {
 	switch (intid) {
@@ -81,39 +90,108 @@ static void gicv3_write_eoir(uint32_t irq)
 	isb();
 }
 
-static void
-gicv3_config_irq(unsigned int intid, unsigned int offset)
+uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, uint64_t offset)
+{
+	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
+		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	return readl(base + offset);
+}
+
+void gicv3_reg_writel(uint32_t cpu_or_dist, uint64_t offset, uint32_t reg_val)
+{
+	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
+		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	writel(reg_val, base + offset);
+}
+
+uint32_t gicv3_getl_fields(uint32_t cpu_or_dist, uint64_t offset, uint32_t mask)
+{
+	return gicv3_reg_readl(cpu_or_dist, offset) & mask;
+}
+
+void gicv3_setl_fields(uint32_t cpu_or_dist, uint64_t offset,
+		uint32_t mask, uint32_t reg_val)
+{
+	uint32_t tmp = gicv3_reg_readl(cpu_or_dist, offset) & ~mask;
+
+	tmp |= (reg_val & mask);
+	gicv3_reg_writel(cpu_or_dist, offset, tmp);
+}
+
+/*
+ * We use a single offset for the distributor and redistributor maps as they
+ * have the same value in both. The only exceptions are registers that only
+ * exist in one and not the other, like GICR_WAKER that doesn't exist in the
+ * distributor map. Such registers are conveniently marked as reserved in the
+ * map that doesn't implement it; like GICR_WAKER's offset of 0x0014 being
+ * marked as "Reserved" in the Distributor map.
+ */
+static void gicv3_access_reg(uint32_t intid, uint64_t offset,
+		uint32_t reg_bits, uint32_t bits_per_field,
+		bool write, uint32_t *val)
 {
 	uint32_t cpu = guest_get_vcpuid();
-	uint32_t mask = 1 << (intid % 32);
 	enum gicv3_intid_range intid_range = get_intid_range(intid);
-	void *reg;
-
-	/* We care about 'cpu' only for SGIs or PPIs */
-	if (intid_range == SGI_RANGE || intid_range == PPI_RANGE) {
-		GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
-
-		reg = sgi_base_from_redist(gicv3_data.redist_base[cpu]) +
-			offset;
-		writel(mask, reg);
-		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu]);
-	} else if (intid_range == SPI_RANGE) {
-		reg = gicv3_data.dist_base + offset + (intid / 32) * 4;
-		writel(mask, reg);
-		gicv3_gicd_wait_for_rwp();
-	} else {
-		GUEST_ASSERT(0);
-	}
+	uint32_t fields_per_reg, index, mask, shift;
+	uint32_t cpu_or_dist;
+
+	GUEST_ASSERT(bits_per_field <= reg_bits);
+	GUEST_ASSERT(*val < (1U << bits_per_field));
+	/* Some registers like IROUTER are 64 bit long. Those are currently not
+	 * supported by readl nor writel, so just asserting here until then.
+	 */
+	GUEST_ASSERT(reg_bits == 32);
+
+	fields_per_reg = reg_bits / bits_per_field;
+	index = intid % fields_per_reg;
+	shift = index * bits_per_field;
+	mask = ((1U << bits_per_field) - 1) << shift;
+
+	/* Set offset to the actual register holding intid's config. */
+	offset += (intid / fields_per_reg) * (reg_bits / 8);
+
+	cpu_or_dist = (intid_range == SPI_RANGE) ? DIST_BIT : cpu;
+
+	if (write)
+		gicv3_setl_fields(cpu_or_dist, offset, mask, *val << shift);
+	*val = gicv3_getl_fields(cpu_or_dist, offset, mask) >> shift;
+}
+
+static void gicv3_write_reg(uint32_t intid, uint64_t offset,
+		uint32_t reg_bits, uint32_t bits_per_field, uint32_t val)
+{
+	gicv3_access_reg(intid, offset, reg_bits,
+			bits_per_field, true, &val);
+}
+
+static uint32_t gicv3_read_reg(uint32_t intid, uint64_t offset,
+		uint32_t reg_bits, uint32_t bits_per_field)
+{
+	uint32_t val;
+
+	gicv3_access_reg(intid, offset, reg_bits,
+			bits_per_field, false, &val);
+	return val;
 }
 
 static void gicv3_irq_enable(unsigned int intid)
 {
-	gicv3_config_irq(intid, GICD_ISENABLER);
+	bool is_spi = get_intid_range(intid) == SPI_RANGE;
+	unsigned int val = 1;
+	uint32_t cpu = guest_get_vcpuid();
+
+	gicv3_write_reg(intid, GICD_ISENABLER, 32, 1, val);
+	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
 static void gicv3_irq_disable(unsigned int intid)
 {
-	gicv3_config_irq(intid, GICD_ICENABLER);
+	bool is_spi = get_intid_range(intid) == SPI_RANGE;
+	uint32_t val = 1;
+	uint32_t cpu = guest_get_vcpuid();
+
+	gicv3_write_reg(intid, GICD_ICENABLER, 32, 1, val);
+	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
 static void gicv3_enable_redist(void *redist_base)
-- 
2.34.0.rc0.344.g81b53c2807-goog

