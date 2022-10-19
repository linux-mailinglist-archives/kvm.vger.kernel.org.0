Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBF1604A34
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 16:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiJSO72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 10:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiJSO6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 10:58:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1269A7E014
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:53:27 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JEbKIj022156
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uCTGVaGvK+AWdjXskhjB5qkCd+ecJSG5ySKQ4c0lAdg=;
 b=WLQnBmtBtCWbDJ9ipyrutCZqrwb25QOcdMaJuNck/c3MCYXAnTghxhqEMPe8g2ipCckw
 YECUQP+iL3piVoMKzPVcAJlIHqEmi7kI9TKHxGyBA8ztmKQbGE+YMxNURj9KvIX/Wish
 x0yw3NdX+bMbhmBaGW+o3Pvq5ZZ3WY0DcFDIf3paEjOq+4RUpUctd4LsvmZW499H2sKE
 ie+v0jELUhkKFg77Jgnax6HSbQvuE47vUszLndT2/x6NozPHTK3GvkPUIJvKtceMOlrt
 7Nniv+4/9WGm2WTTF1tQwEtM1pUKsg+PcLG8juDPpcUjc5J0+4T6DxXnW2VUfo/S0ECL 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kajskhk84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JEbML3022479
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kajskhk6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 14:53:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JEpifh013181;
        Wed, 19 Oct 2022 14:53:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg9796r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 14:53:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JErKPM65274250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 14:53:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 743BA11C050;
        Wed, 19 Oct 2022 14:53:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34ED811C04C;
        Wed, 19 Oct 2022 14:53:20 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 14:53:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/1] s390x: do not enable PV dump support by default
Date:   Wed, 19 Oct 2022 16:53:19 +0200
Message-Id: <20221019145320.1228710-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ozl8FdOJfEOawtBbuD2QhuoT4UcSPRHe
X-Proofpoint-ORIG-GUID: zOd760wGwUvnHzjl6SfBu7rnwZ5VbLY2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_08,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=771 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
* add indent to CONFIG_DUMP if in Makefile (thanks Janosch)
* add comment (thanks Janosch)

Currently, dump support is always enabled by setting the respective
plaintext control flag (PCF). Unfortunately, older machines without
support for PV dump will not start the guest when this PCF is set.

Nico Boehr (1):
  s390x: do not enable PV dump support by default

 configure      | 11 +++++++++++
 s390x/Makefile | 26 +++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

-- 
2.36.1

