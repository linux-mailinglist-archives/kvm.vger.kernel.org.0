Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA65588E18
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiHCN7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238391AbiHCN7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:59:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC10EDF1D
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:59:17 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273DEkDC014144
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 13:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=t3df+8UzzZVAtk3TNGU8oKzEn1iU4Q32bEA2zO9Euwg=;
 b=c7sio3wMG7inBToAW3F3EG1fRK5XyLxTj6mlkIonlolYRQC8vOOpqUUb1WB64UlmY6k/
 lhukLlMzcyXzA8JRWWQ2RUDjHHaeemaEBV9wDZSU27LjuYA0eFVIzd3+rxaPv0BR6ViB
 9jjMr1/7XXEbQ4jaB1iywAIC2lonVM7BW9ngg/yDc3yYPfFfZD3aIyRZ9+9z6hgngy8t
 S5UCvz73HCrQMVfbCxCTao/WAq4UUWwGjhSzLmUMACIVp1UrcbQO2nn+EnFQcx4Nqk18
 47beY8OtnIP5RjJWLKE4D1NJOP8lt0unkY0VhtV6akP1qFjD2JpG3CI1LQVrO/AkSNNC mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqsr0sd2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 13:59:17 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 273DhqSX031536
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 13:59:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqsr0sd1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 13:59:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273DptE6001328;
        Wed, 3 Aug 2022 13:59:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98n0j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 13:59:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273Dwp7S25821680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 13:58:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F20442041;
        Wed,  3 Aug 2022 13:58:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41AC54203F;
        Wed,  3 Aug 2022 13:58:51 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 13:58:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/1] s390x: verify EQBS/SQBS is unavailable
Date:   Wed,  3 Aug 2022 15:58:50 +0200
Message-Id: <20220803135851.384805-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zhW506mVZVYUwPqc_t7zAGhPvd9X9mTr
X-Proofpoint-ORIG-GUID: CL8wYIOUUnd8ku5MoDq-H1xw2GAGtoIw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0 mlxlogscore=697
 suspectscore=0 clxscore=1015 spamscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:
---
- Claudio pointed out the clobber of r1 is unneeded, so remove it.

QEMU doesn't provide EQBS/SQBS instructions, so we should check they
result in an exception.

Nico Boehr (1):
  s390x: verify EQBS/SQBS is unavailable

 s390x/intercept.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

-- 
2.36.1

