Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03DF56C237
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiGHVVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 17:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiGHVVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 17:21:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E173121F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 14:21:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2dc7bdd666fso336367b3.7
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 14:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=d06KtJGM9Urh+hEma1oe+1DCWv79kZEo+4GAAOkgM9k=;
        b=oQDT6Wq7kEbhP3BM0f12sQqelVDyuIBAdNcbuWk1GGVjjUSN1gd5aAKSBazbYqFS4K
         +arOzs7jC2zDxprNY10dM8KLjkEYfomASm4epKLHtGTSor91ZAwLYfV5t0WmZjdt/Z4O
         vACDN7b5l6kICT11HPPKfdfBk2O8d9ITJsAyLdFuTFiEQLLoDPCM58N3u6CiOZzQvKSH
         s3gAaUaVxHr/Co94+2LthvqvFUXhIY9DH6eoOuoA2qViPNkh72I32WcBfGyOYgoqiBMM
         80/uUyzDRSTU4pwtkVhUeJAn3GLyj0tD++8Zd2IcqMvG6kcz0FDO8avyiv4s16nl/HHr
         wu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d06KtJGM9Urh+hEma1oe+1DCWv79kZEo+4GAAOkgM9k=;
        b=YTSFxV0Vsh0zPkRLlINFD/Z9flcrr4LuISXKu0Lf5EnaO01Mh8o3G1SUbaIN92tnQU
         5NqIBUmQ/NxjZkmPAcgzXbgiKwDGpSOWDYj1I3PupCR3O5gYVnzTAFLuf3+0U3THqZTH
         j1q8Bw7If/XbzZeIlpujt8/uZNSqI48+aJ7icqYJwWC3g3OINZnBVs9m+9ghk6ufqfbu
         C7G6VNDHokbO1VHTbJYya6X/icUvGp+WXVXuOH5Dj9g2Vp0EXUWach34YLWUpu0U0gLh
         MUTsRkB6AZipHx4S6yDyowrOkxzzb5ZTR3u0HKVJjjx9itNRjpQDGwFbBqO3tAl4TENw
         H2mQ==
X-Gm-Message-State: AJIora8MyERgTiKhVld1YKMD5HG2VCEVHty5rACc0oRwAaZZrhxfS+Rw
        lT/PYR1u39pT0GlHwrBDWf05hCU=
X-Google-Smtp-Source: AGRyM1vfmvu7rG+koN3KOKJWw2zBTYS3L0eEAox4rXFwqECYm1TTG82R1SDiGf/lpsF8NErbOex4Qe4=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ff27:d65:6bb8:b084])
 (user=pcc job=sendgmr) by 2002:a25:6b0b:0:b0:66e:445a:17bb with SMTP id
 g11-20020a256b0b000000b0066e445a17bbmr5638981ybc.147.1657315278964; Fri, 08
 Jul 2022 14:21:18 -0700 (PDT)
Date:   Fri,  8 Jul 2022 14:21:05 -0700
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
Message-Id: <20220708212106.325260-3-pcc@google.com>
Mime-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 2/3] KVM: arm64: disown unused reserved-memory regions
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
index c1fc4ef82f93..91ca128e7daa 100644
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
@@ -1913,6 +1915,48 @@ static bool init_psci_relay(void)
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
@@ -1953,6 +1997,8 @@ static int init_subsystems(void)
 
 	kvm_register_perf_callbacks(NULL);
 
+	kvm_reserved_memory_init();
+
 out:
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
-- 
2.37.0.144.g8ac04bfd2-goog

