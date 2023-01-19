Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D0D673721
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjASLld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjASLlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:41:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DD055A0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:41:07 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JAomc5019346
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GU/8OYxZMo5ply/MpvrFYSci8rJ0mhEkQuiWlLs0EH4=;
 b=R7w6VUnjsY+7ZU/eJvU/XaWTpH298M6nFOVmV0P5ckCiteQs3/YpnyxCR2NycD2KQpjy
 d4GOnSYLT8B+e/FDWVkJWJZZs9yFt5K9IDG+PApXqqcQ10UR/GVIg34UXGARbl9LIHEf
 7Y4ebuMj4BrnVucEp7OYsIjfNAcG/npkNeJ9hJMECFvLJhmjR+zgm6qN6RKlFUoAdRX6
 D2BcmEgVOBl3UtEy5fVA/+zmXkBgLdEMNNgxAnSBfyARu75wdwPs8Z+3f3oIkPPvuZVg
 pZhXlgwSDGx/C78eGrI9eoeznUCvY2ZGsWvpXXYKd44NJXv8UuTfdEh59o88yp9iG4y6 yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n74f8962y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBTQdu009922
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n74f8962f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J5Okqp023774;
        Thu, 19 Jan 2023 11:41:04 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16pm1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBf1m150200936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:41:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DA3C20040;
        Thu, 19 Jan 2023 11:41:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0CBE2004B;
        Thu, 19 Jan 2023 11:41:00 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 11:41:00 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 1/8] .gitignore: ignore `s390x/comm.key` file
Date:   Thu, 19 Jan 2023 12:40:38 +0100
Message-Id: <20230119114045.34553-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119114045.34553-1-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mhRFusi-UviRyBinmB89H6im9HEWfqht
X-Proofpoint-ORIG-GUID: 3Vq6Sl3f-lBDPb-Jj2v-sHJjdxOwr8er
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore the Secure Execution Customer Communication Key file.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 33529b65a7e3..601822d67325 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,5 +28,6 @@ cscope.*
 /s390x/*.bin
 /s390x/snippets/*/*.gbin
 /efi-tests/*
+/s390x/comm.key
 /s390x/snippets/*/*.hdr
 /s390x/snippets/*/*.*obj
-- 
2.34.1

