Return-Path: <kvm+bounces-57869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7C9B7F33A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53BCE2A5062
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD9E332A34;
	Wed, 17 Sep 2025 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="KheEbi1D"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F45832BC14
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114239; cv=none; b=sTiJ947DnhGmQxaM+NmchpsLWm8Pk/AfP+MHx1yU6igL2xkC8i/g0YpI3E1qNteJpbLStNgzx1UrGG1/1rc9gGkKDE9DgR8moHicG53RMfvfLcpWhdF5v1fZoEQ9vLP8g1q9tNvBcQb1FWw5R/XgsYd7AoMfT8i+uwX60R6ClYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114239; c=relaxed/simple;
	bh=XbK4hB8xnqGYdd0Jr5nBzp/Z7wR+DK2AGPitBHnrX6s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ed5MbSQySDSS6ABJZN2Xtrg41fQpqhUKtNJSR2q9Gm/rMQ1re1/NGoh0lequ2qL5DU5/aThzucZgNAuOVvSuTjRkY5dzxkVWbw6FuY3lQo4VOVPitErQERuGwx49Ivbrioeoc7xmfBblyNXtj9l9y9iMjHUaYwSr6edELlRDz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=KheEbi1D reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6r008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:41 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=TGbrQM/McNBrLXG5VfeAkh7HnxBCj04Y3QHaSSNnZfI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113802; v=1;
        b=KheEbi1DHbpSY1QMbJ+q1rYvx7VsHKkiS8/9RjIZiRXMxAyctZqTc0JFtwBvh8PW
         2lKENHULJa8wpzYIeWYz2UROsL+SnDsw7kwGSPlXu9/XzqJKBb1rCwX0ICOzKLFN
         +bu/6ujnuSSLfrn4qTLWAnGGdVIArkbeyzz/ERp0RLdum5ZGDcwG1f7AerWpDS1Z
         eT/ItWkzHgUstvQj7m354JJwf41b5mNhUpi/++mCjMFvFlFs4SP8knmmtBCbZ+A9
         +toIb6vhywCtSILmojmMqKTjF38LQiZl7pw+tcUMM/YYSs4bJsu/2qyrxZEa1CkQ
         LAYO+Em9E6LfJazNVBAXJA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:25 +0900
Subject: [PATCH 13/35] hw/mem: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-13-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

The name arguments were used to distinguish AddresSpaces in debugging
output, but they will represent property names after QOM-ification and
debugging output will show QOM paths. So change them to make them more
concise and also avoid conflicts with other properties.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 hw/mem/cxl_type3.c     | 44 ++++++++++++--------------------------------
 hw/mem/memory-device.c |  4 ++--
 2 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/hw/mem/cxl_type3.c b/hw/mem/cxl_type3.c
index 1a726b834b02..968594ae65e2 100644
--- a/hw/mem/cxl_type3.c
+++ b/hw/mem/cxl_type3.c
@@ -727,8 +727,6 @@ static void cxl_destroy_dc_regions(CXLType3Dev *ct3d)
 
 static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
 {
-    DeviceState *ds = DEVICE(ct3d);
-
     if (!ct3d->hostmem && !ct3d->hostvmem && !ct3d->hostpmem
         && !ct3d->dc.num_regions) {
         error_setg(errp, "at least one memdev property must be set");
@@ -750,7 +748,6 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
 
     if (ct3d->hostvmem) {
         MemoryRegion *vmr;
-        char *v_name;
 
         vmr = host_memory_backend_get_memory(ct3d->hostvmem);
         if (!vmr) {
@@ -765,20 +762,14 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
         memory_region_set_nonvolatile(vmr, false);
         memory_region_set_enabled(vmr, true);
         host_memory_backend_set_mapped(ct3d->hostvmem, true);
-        if (ds->id) {
-            v_name = g_strdup_printf("cxl-type3-dpa-vmem-space:%s", ds->id);
-        } else {
-            v_name = g_strdup("cxl-type3-dpa-vmem-space");
-        }
-        address_space_init(&ct3d->hostvmem_as, NULL, vmr, v_name);
+        address_space_init(&ct3d->hostvmem_as, OBJECT(ct3d), vmr,
+                           "volatile-as");
         ct3d->cxl_dstate.vmem_size = memory_region_size(vmr);
         ct3d->cxl_dstate.static_mem_size += memory_region_size(vmr);
-        g_free(v_name);
     }
 
     if (ct3d->hostpmem) {
         MemoryRegion *pmr;
-        char *p_name;
 
         pmr = host_memory_backend_get_memory(ct3d->hostpmem);
         if (!pmr) {
@@ -793,21 +784,15 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
         memory_region_set_nonvolatile(pmr, true);
         memory_region_set_enabled(pmr, true);
         host_memory_backend_set_mapped(ct3d->hostpmem, true);
-        if (ds->id) {
-            p_name = g_strdup_printf("cxl-type3-dpa-pmem-space:%s", ds->id);
-        } else {
-            p_name = g_strdup("cxl-type3-dpa-pmem-space");
-        }
-        address_space_init(&ct3d->hostpmem_as, NULL, pmr, p_name);
+        address_space_init(&ct3d->hostpmem_as, OBJECT(ct3d), pmr,
+                           "persistent-as");
         ct3d->cxl_dstate.pmem_size = memory_region_size(pmr);
         ct3d->cxl_dstate.static_mem_size += memory_region_size(pmr);
-        g_free(p_name);
     }
 
     ct3d->dc.total_capacity = 0;
     if (ct3d->dc.num_regions > 0) {
         MemoryRegion *dc_mr;
-        char *dc_name;
 
         if (!ct3d->dc.host_dc) {
             error_setg(errp, "dynamic capacity must have a backing device");
@@ -832,13 +817,8 @@ static bool cxl_setup_memory(CXLType3Dev *ct3d, Error **errp)
         memory_region_set_nonvolatile(dc_mr, false);
         memory_region_set_enabled(dc_mr, true);
         host_memory_backend_set_mapped(ct3d->dc.host_dc, true);
-        if (ds->id) {
-            dc_name = g_strdup_printf("cxl-dcd-dpa-dc-space:%s", ds->id);
-        } else {
-            dc_name = g_strdup("cxl-dcd-dpa-dc-space");
-        }
-        address_space_init(&ct3d->dc.host_dc_as, NULL, dc_mr, dc_name);
-        g_free(dc_name);
+        address_space_init(&ct3d->dc.host_dc_as, OBJECT(ct3d), dc_mr,
+                           "volatile-dc-as");
 
         if (!cxl_create_dc_regions(ct3d, errp)) {
             error_append_hint(errp, "setup DC regions failed");
@@ -974,13 +954,13 @@ err_free_special_ops:
     g_free(regs->special_ops);
     if (ct3d->dc.host_dc) {
         cxl_destroy_dc_regions(ct3d);
-        address_space_destroy(&ct3d->dc.host_dc_as);
+        object_unparent(OBJECT(&ct3d->dc.host_dc_as));
     }
     if (ct3d->hostpmem) {
-        address_space_destroy(&ct3d->hostpmem_as);
+        object_unparent(OBJECT(&ct3d->hostpmem_as));
     }
     if (ct3d->hostvmem) {
-        address_space_destroy(&ct3d->hostvmem_as);
+        object_unparent(OBJECT(&ct3d->hostvmem_as));
     }
 }
 
@@ -997,13 +977,13 @@ static void ct3_exit(PCIDevice *pci_dev)
     cxl_destroy_cci(&ct3d->cci);
     if (ct3d->dc.host_dc) {
         cxl_destroy_dc_regions(ct3d);
-        address_space_destroy(&ct3d->dc.host_dc_as);
+        object_unparent(OBJECT(&ct3d->dc.host_dc_as));
     }
     if (ct3d->hostpmem) {
-        address_space_destroy(&ct3d->hostpmem_as);
+        object_unparent(OBJECT(&ct3d->hostpmem_as));
     }
     if (ct3d->hostvmem) {
-        address_space_destroy(&ct3d->hostvmem_as);
+        object_unparent(OBJECT(&ct3d->hostvmem_as));
     }
 }
 
diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index a4a8efdd869b..165866f10b25 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -535,8 +535,8 @@ void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size)
 
     memory_region_init(&ms->device_memory->mr, OBJECT(ms), "device-memory",
                        size);
-    address_space_init(&ms->device_memory->as, NULL, &ms->device_memory->mr,
-                       "device-memory");
+    address_space_init(&ms->device_memory->as, OBJECT(ms),
+                       &ms->device_memory->mr, "device-memory-as");
     memory_region_add_subregion(get_system_memory(), ms->device_memory->base,
                                 &ms->device_memory->mr);
 

-- 
2.51.0


