Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DFB53F00B
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiFFUkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbiFFUkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:40:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892E41105F6
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 13:36:59 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KXYa5001956;
        Mon, 6 Jun 2022 20:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QT59XG4yFEdaUJP8CL+P9u/550+JpgHD6CVebJvzSEc=;
 b=Y9/uR17lM2s+pefCuKPBH9pwafjgsY9zr744eoqT9ArHY8UModa++iosOoMbcwExI3bH
 VIlSzJ8Q3Bt8990L+z97VfsCJkOAMzrjeBUBIXdFf8uQNg2NDtAz529ZkvbPDg8KXEBL
 lrmmMR0t0tVEKdgcSG72qH08/whYOntuYC+W4/Pkzl4qO3zungLi255yx+M/VCnacuag
 ScIxK7E+BZ4NgeouZ7Lb3QEYk8Q/w8teGjfArMie9uYvALd/5Zzog6MllYTaeZzY+EkE
 1qvuJW7j2+5nX1Bs78+pCcqnjHvf12gwiyK76OeOupaiVzJVCBjHyjmxygTUL+2q8t0w bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqj1h9d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:55 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KXcGe002483;
        Mon, 6 Jun 2022 20:36:55 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqj1h9d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:55 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KLO5b007310;
        Mon, 6 Jun 2022 20:36:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 3gfy1abrqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:54 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256Karqa8847618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:36:53 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5051328059;
        Mon,  6 Jun 2022 20:36:53 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 797C828058;
        Mon,  6 Jun 2022 20:36:50 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:36:50 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine property
Date:   Mon,  6 Jun 2022 16:36:14 -0400
Message-Id: <20220606203614.110928-9-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203614.110928-1-mjrosato@linux.ibm.com>
References: <20220606203614.110928-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RqrgQHz1AakKiU08n6mHz-c9-atM2Bk2
X-Proofpoint-GUID: sMrpFmRQ60iCiPPu6ur9SZCM-FRZRXJJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The zpcii-disable machine property can be used to force-disable the use
of zPCI interpretation facilities for a VM.  By default, this setting
will be off for machine 7.1 and newer.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-kvm.c            |  4 +++-
 hw/s390x/s390-virtio-ccw.c         | 24 ++++++++++++++++++++++++
 include/hw/s390x/s390-virtio-ccw.h |  1 +
 qemu-options.hx                    |  8 +++++++-
 util/qemu-config.c                 |  4 ++++
 5 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
index 9134fe185f..5eb7fd12e2 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -22,7 +22,9 @@
 
 bool s390_pci_kvm_interp_allowed(void)
 {
-    return kvm_s390_get_zpci_op() && !s390_is_pv();
+    return (kvm_s390_get_zpci_op() && !s390_is_pv() &&
+            !object_property_get_bool(OBJECT(qdev_get_machine()),
+                                      "zpcii-disable", NULL));
 }
 
 int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist)
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index cc3097bfee..70229b102b 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -645,6 +645,21 @@ static inline void machine_set_dea_key_wrap(Object *obj, bool value,
     ms->dea_key_wrap = value;
 }
 
+static inline bool machine_get_zpcii_disable(Object *obj, Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    return ms->zpcii_disable;
+}
+
+static inline void machine_set_zpcii_disable(Object *obj, bool value,
+                                             Error **errp)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    ms->zpcii_disable = value;
+}
+
 static S390CcwMachineClass *current_mc;
 
 /*
@@ -740,6 +755,13 @@ static inline void s390_machine_initfn(Object *obj)
             "Up to 8 chars in set of [A-Za-z0-9. ] (lower case chars converted"
             " to upper case) to pass to machine loader, boot manager,"
             " and guest kernel");
+
+    object_property_add_bool(obj, "zpcii-disable",
+                             machine_get_zpcii_disable,
+                             machine_set_zpcii_disable);
+    object_property_set_description(obj, "zpcii-disable",
+            "disable zPCI interpretation facilties");
+    object_property_set_bool(obj, "zpcii-disable", false, NULL);
 }
 
 static const TypeInfo ccw_machine_info = {
@@ -804,9 +826,11 @@ DEFINE_CCW_MACHINE(7_1, "7.1", true);
 static void ccw_machine_7_0_instance_options(MachineState *machine)
 {
     static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V7_0 };
+    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
 
     ccw_machine_7_1_instance_options(machine);
     s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
+    ms->zpcii_disable = true;
 }
 
 static void ccw_machine_7_0_class_options(MachineClass *mc)
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 3331990e02..8a0090a071 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -27,6 +27,7 @@ struct S390CcwMachineState {
     bool aes_key_wrap;
     bool dea_key_wrap;
     bool pv;
+    bool zpcii_disable;
     uint8_t loadparm[8];
 };
 
diff --git a/qemu-options.hx b/qemu-options.hx
index 60cf188da4..fafe335b4a 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -36,7 +36,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                nvdimm=on|off controls NVDIMM support (default=off)\n"
     "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
     "                hmat=on|off controls ACPI HMAT support (default=off)\n"
-    "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n",
+    "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
+    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
     QEMU_ARCH_ALL)
 SRST
 ``-machine [type=]name[,prop=value[,...]]``
@@ -124,6 +125,11 @@ SRST
             -object memory-backend-ram,id=pc.ram,size=512M,x-use-canonical-path-for-ramblock-id=off
             -machine memory-backend=pc.ram
             -m 512M
+
+    ``zpcii-disable=on|off``
+        Disables zPCI interpretation facilties on s390-ccw hosts.
+        This feature can be used to disable hardware virtual assists
+        related to zPCI devices. The default is off.
 ERST
 
 DEF("M", HAS_ARG, QEMU_OPTION_M,
diff --git a/util/qemu-config.c b/util/qemu-config.c
index 433488aa56..5325f6bf80 100644
--- a/util/qemu-config.c
+++ b/util/qemu-config.c
@@ -236,6 +236,10 @@ static QemuOptsList machine_opts = {
             .help = "Up to 8 chars in set of [A-Za-z0-9. ](lower case chars"
                     " converted to upper case) to pass to machine"
                     " loader, boot manager, and guest kernel",
+        },{
+            .name = "zpcii-disable",
+            .type = QEMU_OPT_BOOL,
+            .help = "disable zPCI interpretation facilities",
         },
         { /* End of list */ }
     }
-- 
2.27.0

