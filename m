Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A92D74F191
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjGKORG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjGKORB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:17:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4DC19B2
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:45 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDuqjn001838;
        Tue, 11 Jul 2023 14:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+kQ5tf3JyevbaVtzVA3tjfbhSfGGa2i0KmGT/k4O8VM=;
 b=C0gcNr974FBzbQ4i+2mXzQkVgLj9UYGYByrPZwh2kUrcgX0e2JrWmOnwhKM1Aq2RWro7
 GsRORe0CRrDjyreoEXKmr36ChVfa0tScadAD16Y7gsBsR7mdGIdzwiNIE6Oq3E/hrTkG
 2Nkp6qdF2DdYnL410Mem+zRox+La4+Gi2jIF0jjS2QvTN5w0ONo8AxTvm6ppvgt+fsAs
 OLsFLroaZ9XERQc4uuK9gtuxIDagRsgTzmSGFcNhfo/6OwhMaMKwefdbl17W8ONgmWUC
 CLpQM9dFehiVrTVqxMpSUDJCtWBYvOG1qogdbD07W+EiD+OvxMEyvLHMetWYgHOkcXaP tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0rc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:42 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE6Gtf025842;
        Tue, 11 Jul 2023 14:16:41 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8de0qxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDmUtj005988;
        Tue, 11 Jul 2023 14:16:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e1u41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGLl128312052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DBC720043;
        Tue, 11 Jul 2023 14:16:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 979EC20040;
        Tue, 11 Jul 2023 14:16:20 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 18/22] s390x: uv-host: Add the test to unittests.conf
Date:   Tue, 11 Jul 2023 16:15:51 +0200
Message-ID: <20230711141607.40742-19-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: twXRld3e1cYZlw3MDbgYFXP7ZWKEVdlq
X-Proofpoint-GUID: EyXMU5ZJ9np-aYufT5CpdwlK0tyt_HK1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Better to skip than to not run it at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-9-frankja@linux.ibm.com
[ nrb: fixup whitespace ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/unittests.cfg | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 49b3cee..b081345 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -234,3 +234,9 @@ extra_params = -m 2200
 file = pv-diags.elf
 groups = pv-host
 extra_params = -m 2200
+
+[uv-host]
+file = uv-host.elf
+smp = 2
+groups = pv-host
+extra_params = -m 2200
-- 
2.41.0

