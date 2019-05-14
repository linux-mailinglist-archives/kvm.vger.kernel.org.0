Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CBB1CBAD
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfENPRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:17:54 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3883 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfENPRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557847072; x=1589383072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ApUn5NrD10awU4eW559R8go9dXcgyOtHemBHTUkzGiI=;
  b=hhbFKKybPtDMuLu03QsPug21ByqZsKgAuMZOjw6ekJDiC77EJZOlG8Nq
   FsNQFGJta4ACy5LmunEXdXRDJLT84k//ufetYESzLoaVP/7ZazvYmR85C
   lYtdR/rCuSAGMr0wgfrvN8JQ4dHM0IWBjjeEWVjFjs5IfwAFhdeu8e4J5
   A=;
X-IronPort-AV: E=Sophos;i="5.60,469,1549929600"; 
   d="scan'208";a="766033521"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 May 2019 15:17:51 +0000
Received: from uf8b156e456a5587c9af4.ant.amazon.com (iad7-ws-svc-lb50-vlan2.amazon.com [10.0.93.210])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4EFHhWL108365
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 14 May 2019 15:17:45 GMT
Received: from uf8b156e456a5587c9af4.ant.amazon.com (localhost [127.0.0.1])
        by uf8b156e456a5587c9af4.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x4EFHgN3028019;
        Tue, 14 May 2019 17:17:42 +0200
Received: (from sironi@localhost)
        by uf8b156e456a5587c9af4.ant.amazon.com (8.15.2/8.15.2/Submit) id x4EFHfS2028018;
        Tue, 14 May 2019 17:17:41 +0200
From:   Filippo Sironi <sironi@amazon.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, boris.ostrovsky@oracle.com,
        cohuck@redhat.com, konrad.wilk@oracle.com,
        xen-devel@lists.xenproject.org, vasu.srinivasan@oracle.com
Cc:     Filippo Sironi <sironi@amazon.de>
Subject: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to report the VM UUID
Date:   Tue, 14 May 2019 17:16:42 +0200
Message-Id: <1557847002-23519-3-git-send-email-sironi@amazon.de>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557847002-23519-1-git-send-email-sironi@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On x86, we report the UUID in DMI System Information (i.e., DMI Type 1)
as VM UUID.

Signed-off-by: Filippo Sironi <sironi@amazon.de>
---
 arch/x86/kernel/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5c93a65ee1e5..441cab08a09d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/kvm_para.h>
 #include <linux/cpu.h>
+#include <linux/dmi.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/hardirq.h>
@@ -694,6 +695,12 @@ bool kvm_para_available(void)
 }
 EXPORT_SYMBOL_GPL(kvm_para_available);
 
+const char *kvm_para_get_uuid(void)
+{
+	return dmi_get_system_info(DMI_PRODUCT_UUID);
+}
+EXPORT_SYMBOL_GPL(kvm_para_get_uuid);
+
 unsigned int kvm_arch_para_features(void)
 {
 	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
-- 
2.7.4

