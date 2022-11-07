Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935A661F29F
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiKGMMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiKGMM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:12:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DC4BB6;
        Mon,  7 Nov 2022 04:12:28 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7B2mag007359;
        Mon, 7 Nov 2022 12:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3ZD26RNGvUE/E4dBQgXHFo1uhyoEYdfLQqEdnsO8mfI=;
 b=T3PNdZ4hplqZNI+GfBtNkOkM4Hn/fqPGh+3njhzzp2X8YwVmPrxuwZl9PuKZnaQEQ8aN
 K0Rzm//kP744+slxCEns2GlqZb3uv2ZH17sQweM6P/tCqtjP/3GLbh321aRqWZaZ6SbM
 The6s9i2dnkXc1MPJCfZ4/fR3/h/SR6UCEtU8WI1xdg0gh0puoGmq8BR+AfFIQbUsJU2
 G9NBD4njVTz54bdvysVccMolQWuDD8qSjY4loIkqjID1AZ6f/dKVZ0P/Qfn52XiCi6gq
 up6Ydbv8e8wd4FL0ERcH6M1dEG9raQJiBavT1480liPtN9R8bkPf7LvwshdfuawiEcd/ DQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1mshcqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:12:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7C53gt016431;
        Mon, 7 Nov 2022 12:12:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3kngqdahx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:12:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7CCMCs45809950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 12:12:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47E26A4060;
        Mon,  7 Nov 2022 12:12:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05D22A405B;
        Mon,  7 Nov 2022 12:12:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 12:12:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/1] s390/mm: fix virtual-physical address confusion for swiotlb
Date:   Mon,  7 Nov 2022 13:12:20 +0100
Message-Id: <20221107121221.156274-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GCQli1J1cNarR6Q4sQoyWwtvVKNOBNJc
X-Proofpoint-ORIG-GUID: GCQli1J1cNarR6Q4sQoyWwtvVKNOBNJc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=787 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070099
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
* rename addr to vaddr (thanks Christian)

Nico Boehr (1):
  s390/mm: fix virtual-physical address confusion for swiotlb

 arch/s390/include/asm/mem_encrypt.h |  4 ++--
 arch/s390/mm/init.c                 | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.37.3

