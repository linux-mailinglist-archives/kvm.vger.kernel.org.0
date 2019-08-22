Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B239A40E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfHVXsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:48:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:39466 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbfHVXsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:48:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 16:48:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="179009470"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 22 Aug 2019 16:48:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Attempt to parse ACPI tables only when needed
Date:   Thu, 22 Aug 2019 16:48:37 -0700
Message-Id: <20190822234837.3500-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Parsing the ACPI tables to find the PM timer port hits a #PF on 32-bit
unit tests.  Regardless of what is causing the #PF, move the parsing to
the pmtimer test to unblock the other VM-Exit tests.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmexit.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/x86/vmexit.c b/x86/vmexit.c
index fa72be7..66d3458 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -196,6 +196,13 @@ static void ipi_halt(void)
 int pm_tmr_blk;
 static void inl_pmtimer(void)
 {
+    if (!pm_tmr_blk) {
+	struct fadt_descriptor_rev1 *fadt;
+
+	fadt = find_acpi_table_addr(FACP_SIGNATURE);
+	pm_tmr_blk = fadt->pm_tmr_blk;
+	printf("PM timer port is %x\n", pm_tmr_blk);
+    }
     inl(pm_tmr_blk);
 }
 
@@ -541,7 +548,6 @@ static bool test_wanted(struct test *test, char *wanted[], int nwanted)
 
 int main(int ac, char **av)
 {
-	struct fadt_descriptor_rev1 *fadt;
 	int i;
 	unsigned long membar = 0;
 	struct pci_dev pcidev;
@@ -555,10 +561,6 @@ int main(int ac, char **av)
 	irq_enable();
 	on_cpus(enable_nx, NULL);
 
-	fadt = find_acpi_table_addr(FACP_SIGNATURE);
-	pm_tmr_blk = fadt->pm_tmr_blk;
-	printf("PM timer port is %x\n", pm_tmr_blk);
-
 	ret = pci_find_dev(PCI_VENDOR_ID_REDHAT, PCI_DEVICE_ID_REDHAT_TEST);
 	if (ret != PCIDEVADDR_INVALID) {
 		pci_dev_init(&pcidev, ret);
-- 
2.22.0

