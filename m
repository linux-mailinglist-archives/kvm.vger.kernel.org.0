Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A793516D8A
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 11:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384320AbiEBJnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 05:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384294AbiEBJnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 05:43:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDAC11144;
        Mon,  2 May 2022 02:39:35 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2426dsev028894;
        Mon, 2 May 2022 09:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5AZnIlzSnk5Y4BEmr2Rc5MMBTRAHojFjH2V0jpZfTes=;
 b=BtFrUjiC1WIxNmwydgSc+LiilYxjMhiMWuzuouo4VOhCH0cVxTpmlbOY6DMtlH4kXzyY
 Nb9ARuHTYb9IgH/19L123lGB0WSb7B95oyeFw8KpJK+oIt7W8PoAsy86LaXf3PROsDg4
 WM0hjG2K3v8mKi2dJATIJ6rzhVOQtUeM/Zud4RNF/PqvRlVrdHYKJx2pzGJ2euy9a+61
 ef6GFaHN5YLd5+rOOI5KzNFsQsT9/P7WmVui4+3g3XVmFEZSd10sZf9oseQA6PMwnZNS
 R6PXRacFqzl80Es5IUYoCcntSvvZp98TDiCnCuhgxNmvRwhq33J54D0twBwobcV2x/IV nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ft7tmd2a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:34 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24296RKJ024551;
        Mon, 2 May 2022 09:39:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ft7tmd29k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429cN26025308;
        Mon, 2 May 2022 09:39:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3frvcj2g9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429dUtx24773032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 09:39:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFE9CAE045;
        Mon,  2 May 2022 09:39:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0108DAE04D;
        Mon,  2 May 2022 09:39:28 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 09:39:27 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 2/6] s390x: lib: Add QUI getter
Date:   Mon,  2 May 2022 09:39:21 +0000
Message-Id: <20220502093925.4118-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502093925.4118-1-seiden@linux.ibm.com>
References: <20220502093925.4118-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UrYnElWYMpo6gIvECGicZABhrNKYIG5e
X-Proofpoint-ORIG-GUID: _f7kJ3UZW7oXpfIbFqP-96msvb4YlgTx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 clxscore=1015 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
already has cached the qui result. Let's add a function to avoid
unnecessary QUI UVCs.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/uv.c | 8 ++++++++
 lib/s390x/uv.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 6fe11dff..3b4cafa9 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
 	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
 }
 
+const struct uv_cb_qui *uv_get_query_data(void)
+{
+	/* Query needs to be called first */
+	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
+
+	return &uvcb_qui;
+}
+
 int uv_setup(void)
 {
 	if (!test_facility(158))
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 8175d9c6..44264861 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -8,6 +8,7 @@
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_query_test_call(unsigned int nr);
+const struct uv_cb_qui *uv_get_query_data(void);
 void uv_init(void);
 int uv_setup(void);
 void uv_create_guest(struct vm *vm);
-- 
2.30.2

