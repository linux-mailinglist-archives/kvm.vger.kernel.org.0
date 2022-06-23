Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53195570FE
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 04:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376471AbiFWCTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 22:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377785AbiFWCTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 22:19:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031673A18E
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 19:19:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31838c41186so36749847b3.23
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 19:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qmRSFVhsEhDBpfnqm4N8Fhb131UT2F+11PJ2keCwIs4=;
        b=qrU4bfPKoBkwTTiKfPve9s0Kfjp8vuFN1z7yGqlBJDfwPofkgZxH2msgkZnA46WpIg
         xG8zlJh5lI5v7J36zFE22Nf4NWZoPrVMg2ZGyQAjnuv5G1AZbdvGSHrUyzMRK9Md+7ud
         1l+fT1dftAhQYN7yJbaLAe0h/bU/teWnLgJkcRE+HPWctxwxdny1yeGSXwyiJLs2wifH
         kRrK6R/eCfVs5VOt4N6yOFX7UOnpfqC0hY/mE58OymHm0B7puwmwgCi+WonKm5WK/X0+
         BSndrmaGkVBWfm99WMNnpXqmrQMZdXDd+7IJAb0CsRMbaBZlDHus7yiwLKlGb0ZGx+r/
         LX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qmRSFVhsEhDBpfnqm4N8Fhb131UT2F+11PJ2keCwIs4=;
        b=wxkGfULn8AfE24bfxR1cUJlx2KrmYmeLKACQ3p4FRKSp6lZXvvtvG9FfrcJ7yF9Rxa
         Qj29MyiOpvrRZ5a+jKhUVXMw0+aer+gTSwywBq/oFRRDjtz7Y0T3GthkJxIvvz+YdoOb
         rIMRryhzD2RrfLhAwpyxH/bPLIHizzQ8Uu/3BMv4Z5HhBgJSXBgSJNKNQX6tzneU/GND
         P11xTuS6ij2rpKnhyfNd5kdGLE2NL9Jx1otFLl438yez3roD3w1NlIp8EQwEcczPEHJU
         p+2L4iM9ySQdNcayIE3cY2YfCQpgXfmh+PzIaS1ui1Vr39AEagCOgogFwg9FmrBBW2F/
         jmtw==
X-Gm-Message-State: AJIora9FAmak5wxYy9lLJww7S540d3XPVp194mGshgPPbzZwwaPD24k/
        RQXrydEH39oRhpe14g6ody2QuTE=
X-Google-Smtp-Source: AGRyM1vvw84U2jyg/dWdtxTfS7KweL0nv+g/AhyHvwsGSckCZTqHtjS95hVvHN66mkERZ2IvAJ3TsBk=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a25:8887:0:b0:669:97f5:d0b8 with SMTP id
 d7-20020a258887000000b0066997f5d0b8mr5089027ybl.432.1655950780321; Wed, 22
 Jun 2022 19:19:40 -0700 (PDT)
Date:   Wed, 22 Jun 2022 19:19:25 -0700
In-Reply-To: <20220623021926.3443240-1-pcc@google.com>
Message-Id: <20220623021926.3443240-3-pcc@google.com>
Mime-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 2/3] KVM: arm64: disown unused reserved-memory regions
From:   Peter Collingbourne <pcc@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The meaning of no-map on a reserved-memory node is as follows:

      Indicates the operating system must not create a virtual mapping
      of the region as part of its standard mapping of system memory,
      nor permit speculative access to it under any circumstances other
      than under the control of the device driver using the region.

If there is no compatible property, there is no device driver, so the
host kernel has no business accessing the reserved-memory region. Since
these regions may represent a route through which the host kernel
can gain additional privileges, disown any such memory regions before
deprivileging ourselves.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/arm.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index db7cbca6ace4..38f0900b7ddb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -4,6 +4,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/acpi.h>
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
 #include <linux/entry-kvm.h>
@@ -12,6 +13,7 @@
 #include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/mman.h>
@@ -1907,6 +1909,48 @@ static bool init_psci_relay(void)
 	return true;
 }
 
+static void disown_reserved_memory(struct device_node *node)
+{
+	int addr_cells = of_n_addr_cells(node);
+	int size_cells = of_n_size_cells(node);
+	const __be32 *reg, *end;
+	int len;
+
+	reg = of_get_property(node, "reg", &len);
+	if (len % (4 * (addr_cells + size_cells)))
+		return;
+
+	end = reg + (len / 4);
+	while (reg != end) {
+		u64 addr, size;
+
+		addr = of_read_number(reg, addr_cells);
+		reg += addr_cells;
+		size = of_read_number(reg, size_cells);
+		reg += size_cells;
+
+		kvm_call_hyp_nvhe(__pkvm_disown_pages, addr, size);
+	}
+}
+
+static void kvm_reserved_memory_init(void)
+{
+	struct device_node *parent, *node;
+
+	if (!acpi_disabled || !is_protected_kvm_enabled())
+		return;
+
+	parent = of_find_node_by_path("/reserved-memory");
+	if (!parent)
+		return;
+
+	for_each_child_of_node(parent, node) {
+		if (!of_get_property(node, "compatible", NULL) &&
+		    of_get_property(node, "no-map", NULL))
+			disown_reserved_memory(node);
+	}
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1947,6 +1991,8 @@ static int init_subsystems(void)
 
 	kvm_register_perf_callbacks(NULL);
 
+	kvm_reserved_memory_init();
+
 out:
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
-- 
2.37.0.rc0.104.g0611611a94-goog

