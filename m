Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E85B379D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiIIMTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiIIMSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:18:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D256445058
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:15:33 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289BNDBG005482
        for <kvm@vger.kernel.org>; Fri, 9 Sep 2022 12:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OkBY4wuuSBiJNl3lo1Tmi2bH9rP00b0aSPjssYf2vJs=;
 b=ll9+yH+4Py+qz6TZQfxZEIqbJLehtWB1Ro+O5yNgiMgVQg7NuyD9UItmSBGJICoCYBnv
 5u7J1aw/9EEa8HAgc8HnTaMoty/uO/btTyYgoi6+niDKCACO9Bb4dk3OMSAhvYZmAu/1
 IAkGKJKE/yBS0CXR1zwCfE3giIg8+adL7F//8XoduUc2sQ5oVB91nAl+8jlTjmyF8zZ6
 3nc6QisAZXIHJyg/hdpzT1fXk4xeWOH9MSA+aGNEUc7kMO9hQrPNJnUec8fI5msaQJQF
 Cu4xOPwWf1VRTHLBkcs+EDqil9rUqku9KVlfPHIUBifkDxK21mgLoe6iiRNEE1aY04/7 jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg4jqsf5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 12:15:00 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 289BP4P5015639
        for <kvm@vger.kernel.org>; Fri, 9 Sep 2022 12:14:59 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg4jqsf4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 12:14:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 289C6Fdn013699;
        Fri, 9 Sep 2022 12:14:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3jbxj8yxrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 12:14:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 289CEsJp41353544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Sep 2022 12:14:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D12242042;
        Fri,  9 Sep 2022 12:14:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 216AE42041;
        Fri,  9 Sep 2022 12:14:54 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Sep 2022 12:14:54 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: dump support for PV tests
Date:   Fri,  9 Sep 2022 14:14:51 +0200
Message-Id: <20220909121453.202548-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZDnvpnIUg-SQBUGFvHm9-_fkfNqr_YTu
X-Proofpoint-GUID: -jvJUNyE9EO7Nd-UkxXFpvaDqeBAdOVw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_06,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=571
 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209090042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:
---
- add some comments and newlines (thanks Janosch)

v1->v2:
---
- add newline after genprotimg_args (thanks Janosch)
- add a comment explaining what the CCK is (thanks Janosch)

With the upcoming possibility to dump PV guests under s390x, we should
be able to dump kvm-unit-tests for debugging, too.

Add the necessary flags to genprotimg to allow dumping.

Nico Boehr (2):
  s390x: factor out common args for genprotimg
  s390x: create persistent comm-key

 s390x/Makefile | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

-- 
2.36.1

