Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD774E3FC3
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiCVNpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiCVNpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:45:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D612612A
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:44:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MBg8nk019324
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Pbg0vtaE5eVRbSC0wq0BcjaEHQbbF2t4KLpAAkcRbZ0=;
 b=qHKbM9ULKXzpfoTYPjk8I6WDqIVSqxy48NIJV7fvajtUAq/obviiId9IczKe8w2I4v/R
 H+V68Hr/Mk9fptpCLJVvpZ82wCJ0cQxvFSzc7BSrpj9lwd9i8e7PaHVTRxE737eJxrMO
 KD+eDR6jvwVkYacrGL74QR5C6p6Myd72wyVgg7lMpEJ+JMnSQAT53WCc6qKO/t6dIFsj
 wqn5uNCFS7vO0FP7/FAJTnIhc61+xRUsSMt/KlOO2XEwjAYoA1pPF3IbWkE+Q2JKVeDQ
 rosqsRZFlH7kTXfGlRQBaQb7mGY1EZPuaE9gTcX08W5ywx+keVHvfCxmXuYV6kfZQUdM 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautq0bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:44:13 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MDiDGS032155
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:44:13 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautq0av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:44:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MDZQOA023534;
        Tue, 22 Mar 2022 13:44:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t95ehn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:44:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MDWRXd47710574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 13:32:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AFF4A4051;
        Tue, 22 Mar 2022 13:44:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A553A404D;
        Tue, 22 Mar 2022 13:44:08 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 13:44:08 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     mhartmay@linux.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/1] runtime: indicate failure on crash/timeout/abort in TAP
Date:   Tue, 22 Mar 2022 14:44:06 +0100
Message-Id: <20220322134407.614587-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2qlCjfrfBYRgjLkMjw5LjqfPdim3GVK8
X-Proofpoint-ORIG-GUID: uVuubzz009d9cgWTSX_wPjAX1OzCoro4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=877 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the noise, I sent my v2 a little too early and forgot to include 
some more feedback.

Changelog v3->v2:
---
* I forgot to include Marc's suggestion to make the else if ... an elif,
  now included.
* Thomas actually suggested to quote $tap_output, which I missed, now quoted.

Changelog v2->v1:
---
* Change [[ to [
* Remove double negation

Nico Boehr (1):
  runtime: indicate failure on crash/timeout/abort in TAP

 scripts/runtime.bash | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

-- 
2.31.1

