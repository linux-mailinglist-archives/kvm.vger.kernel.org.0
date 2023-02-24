Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7026A1D42
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjBXOJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjBXOJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:09:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AFDE053;
        Fri, 24 Feb 2023 06:09:16 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OE4Qat008367;
        Fri, 24 Feb 2023 14:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/f/asA138BcbXMTBViejwhQ69qV8Tiu58RJDY30UFbE=;
 b=n+VxF1b6CXlcls8HLRb6U8ABqNJsrCZku5tamRcq4XqlNNh+udbJdi6wTUT4vyMpYTlW
 TInu3s26ymIUxebC75vdhbwY4l0tj8LcUv5j0UpZpfoUx5sPnInSRLarSvBOH3NesZ74
 NO41LsP3LrOSs9Aiv/+quZKufWgfDjDA1ijRKeR/ALH4//Mkz1aPJw8wyN7L+z2wH2V4
 BiJzbWgsc88iZawrwJFjIrJxbVmI5zSvks5rJ4RpdMi11/jT7X8X9WlT6YsdTNaxKbwU
 OduzKthF9dhmzXnYKcxPlMRL3kHf06p9hsMUJb5Go1Y0mhW5ZHXX7SaCiBXkeXakFo/u Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxvkd3f3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 14:09:16 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ODo1Fj006656;
        Fri, 24 Feb 2023 14:09:15 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxvkd3f21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 14:09:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31O55Pm5014654;
        Fri, 24 Feb 2023 14:09:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6631j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 14:09:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31OE99uZ56361404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 14:09:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43E5420043;
        Fri, 24 Feb 2023 14:09:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E913620040;
        Fri, 24 Feb 2023 14:09:08 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Feb 2023 14:09:08 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mimu@linux.ibm.com,
        agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/1] KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
Date:   Fri, 24 Feb 2023 15:09:07 +0100
Message-Id: <20230224140908.75208-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: llmLacYUkuCF7hCfdgiL8JSInoVqjITi
X-Proofpoint-ORIG-GUID: Xw_b-8RvKQ0SRrL7g6OkCwVlqDClnp9J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_08,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=818 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
---
* improve commit message (thanks Janosch)



Nico Boehr (1):
  KVM: s390: interrupt: fix virtual-physical confusion for next alert
    GISA

 arch/s390/kvm/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.39.1

