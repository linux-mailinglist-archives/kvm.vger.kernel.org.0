Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DEE6185A1
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiKCRDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiKCRCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:02:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2A410B64
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:02:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3GXBTT022043;
        Thu, 3 Nov 2022 17:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wjp98LsO3lRaMAifITqpzmQQn+B+wmj/NpDNMqpnC6g=;
 b=bUE6gQJW6t+Yhs3xj9mowgLoBJfc123kVwgTGVCcD8vFUJDbwrg3ykUxwKPH1vRDJqUs
 eafpnLvaNAqPlxS0Ni+MAgQLou1z7BTPDuo6z0I13wdNAx/8cXqvQY4F5UW2KDS7MzRI
 sn4xZoG8JrFz+/sqYjWwtJ/ErjwsV15cAdFat7He6TO+wB9VHNeJwZRm6tacF2OuPdEr
 FEGXdEfpdrS+sazxjZ4j4JxXs4otnq+2J3UuDSqHq5uXi2zZ1iIMhkFK9y1PxrHsQBZ/
 MZWwZgE0RLMfHa6oOUGtasbfyUv65rSayrvFk7D9xnjTtadNBU8vDxWDZUwNyiwEHih9 pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kme7ygngs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:58 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3Frpta005591;
        Thu, 3 Nov 2022 17:01:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kme7ygnfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3Gvb0t015750;
        Thu, 3 Nov 2022 17:01:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kme3487u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3H1qXW2490964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 17:01:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A8BB5204E;
        Thu,  3 Nov 2022 17:01:52 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C872552052;
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
Subject: [PATCH v11 02/11] s390x/cpu topology: add max_threads machine class attribute
Date:   Thu,  3 Nov 2022 18:01:41 +0100
Message-Id: <20221103170150.20789-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103170150.20789-1-pmorel@linux.ibm.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g24beMP1dI5VvnRwhRUOLoZ_1XLUUzzQ
X-Proofpoint-ORIG-GUID: 4kFfVNDEcJn1xCk0l-ASmrdGSPQ4zRQV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The S390 CPU topology accepts the smp.threads argument while
in reality it does not effectively allow multthreading.

Let's keep this behavior for machines older than 7.3 and
refuse to use threads in newer machines until multithreading
is really proposed to the guest by the machine.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/s390-virtio-ccw.h |  1 +
 hw/s390x/s390-virtio-ccw.c         | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 8a0090a071..4f8a39abda 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -40,6 +40,7 @@ struct S390CcwMachineClass {
     bool cpu_model_allowed;
     bool css_migration_enabled;
     bool hpage_1m_allowed;
+    int max_threads;
 };
 
 /* runtime-instrumentation allowed by the machine */
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 567498e780..9ab91df5b1 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -85,8 +85,15 @@ out:
 static void s390_init_cpus(MachineState *machine)
 {
     MachineClass *mc = MACHINE_GET_CLASS(machine);
+    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
     int i;
 
+    if (machine->smp.threads > s390mc->max_threads) {
+        error_report("S390 does not support more than %d threads.",
+                     s390mc->max_threads);
+        exit(1);
+    }
+
     /* initialize possible_cpus */
     mc->possible_cpu_arch_ids(machine);
 
@@ -731,6 +738,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     s390mc->cpu_model_allowed = true;
     s390mc->css_migration_enabled = true;
     s390mc->hpage_1m_allowed = true;
+    s390mc->max_threads = 1;
     mc->init = ccw_init;
     mc->reset = s390_machine_reset;
     mc->block_default_type = IF_VIRTIO;
@@ -859,8 +867,11 @@ static void ccw_machine_7_1_instance_options(MachineState *machine)
 
 static void ccw_machine_7_1_class_options(MachineClass *mc)
 {
+    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
+
     ccw_machine_7_2_class_options(mc);
     compat_props_add(mc->compat_props, hw_compat_7_1, hw_compat_7_1_len);
+    s390mc->max_threads = S390_MAX_CPUS;
 }
 DEFINE_CCW_MACHINE(7_1, "7.1", false);
 
-- 
2.31.1

