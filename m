Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9781673728
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjASLlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjASLlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:41:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDF14B898
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:41:11 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JANRGZ029976
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=atxlL22lTpQD0qkiYh+cNXVkDDhIGvAQ7WEieHWn0j4=;
 b=Vo4bRxaD3yYMiOizF6uOev25pTV7apyIWON9NPYbBGHllxh0ZcGdFjVEZknIT8wiTvET
 f32v9P1njuHVkWBzfLHsg90afI22exzU0Vju1Ha/eiUZKgnL4UI7qjeh2ZfqMyggnDfb
 T7mOqtRm22vskHO1eqzVzWVIsPc0tQ9wxkjQfsoN5qoAtnC/5RKCFfPukcyQdUeOuQJW
 rrGX7qElU5L077QcQK8R+i5bTcbK/SbELkvBxktZABBqQaht2q7YdxQrDUXM85mVvcEm
 jKL8WIEb6OR/tpimAUuddUW5Fve8OhVLMTNNHUHmAzOuvJyr+HTX4/Y3dHb57V5Xzqq+ rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jc026dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:10 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBKADC001202
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jc026d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J5X3x9023782;
        Thu, 19 Jan 2023 11:41:08 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16pm1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBf5ZR26018472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:41:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D3BB20049;
        Thu, 19 Jan 2023 11:41:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D17F20043;
        Thu, 19 Jan 2023 11:41:04 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 11:41:04 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 8/8] s390x/Makefile: add an extra `%.aux.o` target
Date:   Thu, 19 Jan 2023 12:40:45 +0100
Message-Id: <20230119114045.34553-9-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119114045.34553-1-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9pj9ezN0zQt28Nw7Woqj_TXO_xjSbcbp
X-Proofpoint-GUID: k-m9TFrYfKkVTskkacI2ShExlHtS2AHx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's unusual to create multiple files in one target rule, therefore
let's create an extra target for `%.aux.o`. As a side effect, this
change fixes the dependency tracking of the prerequisites of `.aux.o`
(lib/auxinfo.c wasn't listed before).

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 9a8e2af1b2be..6fa62416c0e9 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -162,13 +162,14 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
+%.aux.o: $(SRCDIR)/lib/auxinfo.c
+	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
+
 .SECONDEXPANSION:
-%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
+%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
 	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) $(@:.elf=.aux.o) || \
+		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
 		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
-	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
 # Secure Execution Customer Communication Key file
-- 
2.34.1

