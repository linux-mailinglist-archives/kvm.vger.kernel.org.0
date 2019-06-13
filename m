Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A713B437E0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733063AbfFMPBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732543AbfFMOfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:35:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6765030860BF;
        Thu, 13 Jun 2019 14:35:44 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 277E71001B0F;
        Thu, 13 Jun 2019 14:35:37 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 05/20] hw/i386/pc: Add documentation to the e820_*() functions
Date:   Thu, 13 Jun 2019 16:34:31 +0200
Message-Id: <20190613143446.23937-6-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 13 Jun 2019 14:35:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/i386/pc.h | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 7c07185dd5..fc66b61ff8 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -293,9 +293,42 @@ typedef enum {
     E820_UNUSABLE   = 5
 } E820Type;
 
-ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
+/**
+ * e820_add_entry: Add an #e820_entry to the @e820_table.
+ *
+ * Returns the number of entries of the e820_table on success,
+ *         or a negative errno otherwise.
+ *
+ * @address: The base address of the structure which the BIOS is to fill in.
+ * @length: The length in bytes of the structure passed to the BIOS.
+ * @type: The #E820Type of the address range.
+ */
+ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type);
+
+/**
+ * e820_get_num_entries: The number of entries of the @e820_table.
+ *
+ * Returns the number of entries of the e820_table.
+ */
 size_t e820_get_num_entries(void);
-bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
+
+/**
+ * e820_get_entry: Get the address/length of an #e820_entry.
+ *
+ * If the #e820_entry stored at @index is of #E820Type @type, fills @address
+ * and @length with the #e820_entry values and return @true.
+ * Return @false otherwise.
+ *
+ * @index: The index of the #e820_entry to get values.
+ * @type: The @E820Type of the address range expected.
+ * @address: Pointer to the base address of the #e820_entry structure to
+ *           be filled.
+ * @length: Pointer to the length (in bytes) of the #e820_entry structure
+ *          to be filled.
+ * @return: true if the entry was found, false otherwise.
+ */
+bool e820_get_entry(unsigned int index, E820Type type,
+                    uint64_t *address, uint64_t *length);
 
 extern GlobalProperty pc_compat_4_0_1[];
 extern const size_t pc_compat_4_0_1_len;
-- 
2.20.1

