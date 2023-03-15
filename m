Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24A86BB62D
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 15:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjCOOfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 10:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjCOOfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 10:35:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38444303E7
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 07:35:39 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FCi7q2008553;
        Wed, 15 Mar 2023 14:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OgMa/FL/Fg2JPxk6c485XtvR8cr9+IcfLTc85Echlyg=;
 b=UPWQghAXC0UjSPprolcfOO6Vai1gBo6yryb8dwNOxmAJpHpQPCmdnQv8sO8PbLowJK6o
 jWM9s1iBokKaAJShbQksU/q9fzB25KvtoI5Sxdgu/w3fNJF/EnFtsY80ur9Ww6pBSukg
 QPRzCpIGJMu9SavQNvXk8zl0PW0tc2yp/hAla8uEj5xA32CfIy1zGJdUpIN14TzFirsH
 h2VINrWzDAbVNc+80jD9u34NzrWYfwtAmPmcaaW9yHXH6+RUowxjqGtgaDFOKhmS0Vm0
 yC/ZNZNdIv3zQzQAP7dchzI0Ybup9QRmf6itdvV5KMvYYPOfgxE/3OdLA7dga2DL5EBg Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbe9f3ckq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:27 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FDTGDh017675;
        Wed, 15 Mar 2023 14:35:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbe9f3cjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FE0H00021588;
        Wed, 15 Mar 2023 14:35:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pb29srwr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 14:35:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FEZKGL11076214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:35:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC82B2004B;
        Wed, 15 Mar 2023 14:35:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 516592004E;
        Wed, 15 Mar 2023 14:35:19 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.95.209])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 14:35:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v18 10/17] machine: adding s390 topology to info hotpluggable-cpus
Date:   Wed, 15 Mar 2023 15:34:55 +0100
Message-Id: <20230315143502.135750-11-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230315143502.135750-1-pmorel@linux.ibm.com>
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A9P4xk27m47mDvNBM1lMnDQD92eun-1q
X-Proofpoint-ORIG-GUID: SY0RKG1ib1hgX9wP8faeUozaIvG0FYzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_07,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S390 topology adds books and drawers topology containers.
Let's add these to the HMP information for hotpluggable cpus.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/core/machine-hmp-cmds.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
index c3e55ef9e9..971212242d 100644
--- a/hw/core/machine-hmp-cmds.c
+++ b/hw/core/machine-hmp-cmds.c
@@ -71,6 +71,12 @@ void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict)
         if (c->has_node_id) {
             monitor_printf(mon, "    node-id: \"%" PRIu64 "\"\n", c->node_id);
         }
+        if (c->has_drawer_id) {
+            monitor_printf(mon, "    drawer_id: \"%" PRIu64 "\"\n", c->drawer_id);
+        }
+        if (c->has_book_id) {
+            monitor_printf(mon, "      book_id: \"%" PRIu64 "\"\n", c->book_id);
+        }
         if (c->has_socket_id) {
             monitor_printf(mon, "    socket-id: \"%" PRIu64 "\"\n", c->socket_id);
         }
-- 
2.31.1

