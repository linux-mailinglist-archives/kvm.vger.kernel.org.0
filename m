Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5552618593
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiKCRCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiKCRCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:02:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E741571F
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:02:11 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3FmLVb013035;
        Thu, 3 Nov 2022 17:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ndqOKCz4WiC5LdiQDoC2Y8yrOzyVWlAO6mnYZTbQzcY=;
 b=pivksETxSu2GzI1I5Qo2DUi3Q8SuT0QjxJmG95HhttD0kxMY0CcyrxxpV/MReeizu/qY
 w8NxBCqI6NLwjrFJDnykcEiCEt5FvP4aKEIH1hZW+AFACEkHVmZRpqELdaMMKdDbEBua
 OkFDu6eO+P2ex3opWBjFFwGtJe/kgCRc3Pss++c8K9mWlUjzGJKJMa97AMzyk/0QI3Hs
 WROsehg2RVRkkkX1RL27lomJNkJLiPqvu/gknlcTbhFU4PSbiP5s0Ub0rSOx1dKLSGnn
 ZARdwll72tl/anlrpNGrzyFvz1G0waeW1dCCZQ8Ovee2FFWjrCkf3yM2idAOQWOzkn4S TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kme169he8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:58 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3FmsIi017247;
        Thu, 3 Nov 2022 17:01:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kme169hd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3GGOLP027107;
        Thu, 3 Nov 2022 17:01:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3kgut8xtnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3GuJN040632830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 16:56:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7C7B52051;
        Thu,  3 Nov 2022 17:01:51 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3FB225204F;
        Thu,  3 Nov 2022 17:01:51 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE properties as class properties
Date:   Thu,  3 Nov 2022 18:01:40 +0100
Message-Id: <20221103170150.20789-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103170150.20789-1-pmorel@linux.ibm.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: krW8gHxvb9dpTIgDn4qXaJXQ1fZTJUeL
X-Proofpoint-ORIG-GUID: 8CEz_CeX8YcbZo9wQjuhI81EvVk9yX9H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=946 bulkscore=0
 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/s390-virtio-ccw.c | 127 +++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 55 deletions(-)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 1cc20d8717..567498e780 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -43,6 +43,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
+#include "qapi/visitor.h"
 
 static Error *pv_mig_blocker;
 
@@ -589,38 +590,6 @@ static ram_addr_t s390_fixup_ram_size(ram_addr_t sz)
     return newsz;
 }
 
-static void ccw_machine_class_init(ObjectClass *oc, void *data)
-{
-    MachineClass *mc = MACHINE_CLASS(oc);
-    NMIClass *nc = NMI_CLASS(oc);
-    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
-    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
-
-    s390mc->ri_allowed = true;
-    s390mc->cpu_model_allowed = true;
-    s390mc->css_migration_enabled = true;
-    s390mc->hpage_1m_allowed = true;
-    mc->init = ccw_init;
-    mc->reset = s390_machine_reset;
-    mc->block_default_type = IF_VIRTIO;
-    mc->no_cdrom = 1;
-    mc->no_floppy = 1;
-    mc->no_parallel = 1;
-    mc->no_sdcard = 1;
-    mc->max_cpus = S390_MAX_CPUS;
-    mc->has_hotpluggable_cpus = true;
-    assert(!mc->get_hotplug_handler);
-    mc->get_hotplug_handler = s390_get_hotplug_handler;
-    mc->cpu_index_to_instance_props = s390_cpu_index_to_props;
-    mc->possible_cpu_arch_ids = s390_possible_cpu_arch_ids;
-    /* it is overridden with 'host' cpu *in kvm_arch_init* */
-    mc->default_cpu_type = S390_CPU_TYPE_NAME("qemu");
-    hc->plug = s390_machine_device_plug;
-    hc->unplug_request = s390_machine_device_unplug_request;
-    nc->nmi_monitor_handler = s390_nmi;
-    mc->default_ram_id = "s390.ram";
-}
-
 static inline bool machine_get_aes_key_wrap(Object *obj, Error **errp)
 {
     S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
@@ -710,19 +679,29 @@ bool hpage_1m_allowed(void)
     return get_machine_class()->hpage_1m_allowed;
 }
 
-static char *machine_get_loadparm(Object *obj, Error **errp)
+static void machine_get_loadparm(Object *obj, Visitor *v,
+                                 const char *name, void *opaque,
+                                 Error **errp)
 {
     S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+    char *str = g_strndup((char *) ms->loadparm, sizeof(ms->loadparm));
 
-    /* make a NUL-terminated string */
-    return g_strndup((char *) ms->loadparm, sizeof(ms->loadparm));
+    visit_type_str(v, name, &str, errp);
+    g_free(str);
 }
 
-static void machine_set_loadparm(Object *obj, const char *val, Error **errp)
+static void machine_set_loadparm(Object *obj, Visitor *v,
+                                 const char *name, void *opaque,
+                                 Error **errp)
 {
     S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+    char *val;
     int i;
 
+    if (!visit_type_str(v, name, &val, errp)) {
+        return;
+    }
+
     for (i = 0; i < sizeof(ms->loadparm) && val[i]; i++) {
         uint8_t c = qemu_toupper(val[i]); /* mimic HMC */
 
@@ -740,34 +719,72 @@ static void machine_set_loadparm(Object *obj, const char *val, Error **errp)
         ms->loadparm[i] = ' '; /* pad right with spaces */
     }
 }
-static inline void s390_machine_initfn(Object *obj)
+
+static void ccw_machine_class_init(ObjectClass *oc, void *data)
 {
-    object_property_add_bool(obj, "aes-key-wrap",
-                             machine_get_aes_key_wrap,
-                             machine_set_aes_key_wrap);
-    object_property_set_description(obj, "aes-key-wrap",
+    MachineClass *mc = MACHINE_CLASS(oc);
+    NMIClass *nc = NMI_CLASS(oc);
+    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
+    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
+
+    s390mc->ri_allowed = true;
+    s390mc->cpu_model_allowed = true;
+    s390mc->css_migration_enabled = true;
+    s390mc->hpage_1m_allowed = true;
+    mc->init = ccw_init;
+    mc->reset = s390_machine_reset;
+    mc->block_default_type = IF_VIRTIO;
+    mc->no_cdrom = 1;
+    mc->no_floppy = 1;
+    mc->no_parallel = 1;
+    mc->no_sdcard = 1;
+    mc->max_cpus = S390_MAX_CPUS;
+    mc->has_hotpluggable_cpus = true;
+    assert(!mc->get_hotplug_handler);
+    mc->get_hotplug_handler = s390_get_hotplug_handler;
+    mc->cpu_index_to_instance_props = s390_cpu_index_to_props;
+    mc->possible_cpu_arch_ids = s390_possible_cpu_arch_ids;
+    /* it is overridden with 'host' cpu *in kvm_arch_init* */
+    mc->default_cpu_type = S390_CPU_TYPE_NAME("qemu");
+    hc->plug = s390_machine_device_plug;
+    hc->unplug_request = s390_machine_device_unplug_request;
+    nc->nmi_monitor_handler = s390_nmi;
+    mc->default_ram_id = "s390.ram";
+
+    object_class_property_add_bool(oc, "aes-key-wrap",
+                                   machine_get_aes_key_wrap,
+                                   machine_set_aes_key_wrap);
+    object_class_property_set_description(oc, "aes-key-wrap",
             "enable/disable AES key wrapping using the CPACF wrapping key");
-    object_property_set_bool(obj, "aes-key-wrap", true, NULL);
 
-    object_property_add_bool(obj, "dea-key-wrap",
-                             machine_get_dea_key_wrap,
-                             machine_set_dea_key_wrap);
-    object_property_set_description(obj, "dea-key-wrap",
+    object_class_property_add_bool(oc, "dea-key-wrap",
+                                   machine_get_dea_key_wrap,
+                                   machine_set_dea_key_wrap);
+    object_class_property_set_description(oc, "dea-key-wrap",
             "enable/disable DEA key wrapping using the CPACF wrapping key");
-    object_property_set_bool(obj, "dea-key-wrap", true, NULL);
-    object_property_add_str(obj, "loadparm",
-            machine_get_loadparm, machine_set_loadparm);
-    object_property_set_description(obj, "loadparm",
+
+    object_class_property_add(oc, "loadparm", "loadparm",
+                              machine_get_loadparm, machine_set_loadparm,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "loadparm",
             "Up to 8 chars in set of [A-Za-z0-9. ] (lower case chars converted"
             " to upper case) to pass to machine loader, boot manager,"
             " and guest kernel");
 
-    object_property_add_bool(obj, "zpcii-disable",
-                             machine_get_zpcii_disable,
-                             machine_set_zpcii_disable);
-    object_property_set_description(obj, "zpcii-disable",
+    object_class_property_add_bool(oc, "zpcii-disable",
+                                   machine_get_zpcii_disable,
+                                   machine_set_zpcii_disable);
+    object_class_property_set_description(oc, "zpcii-disable",
             "disable zPCI interpretation facilties");
-    object_property_set_bool(obj, "zpcii-disable", false, NULL);
+}
+
+static inline void s390_machine_initfn(Object *obj)
+{
+    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
+
+    ms->aes_key_wrap = true;
+    ms->dea_key_wrap = true;
+    ms->zpcii_disable = false;
 }
 
 static const TypeInfo ccw_machine_info = {
-- 
2.31.1

