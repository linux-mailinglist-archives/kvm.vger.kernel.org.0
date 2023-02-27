Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8026A3DBC
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 10:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjB0JEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 04:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjB0JD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 04:03:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3A12411E
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:53:58 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31R81Zw9016876;
        Mon, 27 Feb 2023 08:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OgMa/FL/Fg2JPxk6c485XtvR8cr9+IcfLTc85Echlyg=;
 b=CVpxm/Cx4Vzm7u3KvKrcr15xy6fdxoB8Mhfi/ryaKomddpdpqp5HDgBZyIIEkzGLKTRU
 UZG9rNWl4IG2NI/kZPXpDMYQJLoOGmNGmFkkkX+BC+u91I0FsRGcUJlKQ1W/B3w5QK7x
 nQb17xHT9L+0OYuKUXX2zXG2bdgZoH7rANMB4D/b0+FwBiVuls0Hy8UVPv7ZmLU3brft
 GbY9jiqZNYf2aUP23wm+OyFzmxNxheepSclbyFsMi71fLn0IIvjOiA1WbEQEEZ49GFz8
 vukFB+VcRTCo72tM2Y8TOLPG0tJYbVbPGCJ15SHjbDm6SYAp+sE1TSwZ9W9mNV/nwNx/ NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0rn0s9tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 08:53:02 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31R81WWZ016592;
        Mon, 27 Feb 2023 08:53:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0rn0s9t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 08:53:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31QLQFR2011653;
        Mon, 27 Feb 2023 08:52:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nybbdh98e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 08:52:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31R8quUq30999142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 08:52:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 221CB2004B;
        Mon, 27 Feb 2023 08:52:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0337120043;
        Mon, 27 Feb 2023 08:52:55 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.37.166])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Feb 2023 08:52:54 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v17 12/12] machine: adding s390 topology to info hotpluggable-cpus
Date:   Mon, 27 Feb 2023 09:52:47 +0100
Message-Id: <20230227085247.11502-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230227085247.11502-1-pmorel@linux.ibm.com>
References: <c80290f87e2c8377dc33584ec33ce77e1f58f091.camel@linux.ibm.com>
 <20230227085247.11502-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VTWqxwNMw18GTy6LhWNfdzocQulR0Gya
X-Proofpoint-ORIG-GUID: qjux8GQF5FWTI06tg5I54TNsmxxjBkAJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-26_22,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

