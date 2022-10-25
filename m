Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECE160C64C
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiJYIUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiJYIUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:20:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9371DFC12;
        Tue, 25 Oct 2022 01:20:46 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P7A4Cu011253;
        Tue, 25 Oct 2022 08:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=IMdZMf22HQSN/jJGTk4DqiJbCehY2nJM3bQ1ddC6siw=;
 b=K4wGkde28pqE8MJBT5W7quII4Fmt7WwHZKtE40ND32dIwjPrroSiO1ptd0Ml0Q1NfQ83
 /XtOO2Weyd1IN+RkVkB89CDuha+giG/SUHeO/4yKQXYjk0asQfXKp0ZOiRN7WW6fHR23
 R9kigYftlG/EYJnQNTNXCaHXkiE4jckBYeasFP2Pp8EPbQMLhYq2Nyax6CFvSK2PvLfa
 GdyKnMOJFoJtMSqhDdiEkO8Z4lIGxmjM1ykapi0l0Iyy5U5MBI5FfbcgCboPNL6eY/xr
 PvnHA2+1W2BISxDAjpqGUEfCN09ceYG/JYscOzGfMXu60e9QvrhJTFFEcI5Nl10OasAW HQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keaxbtkkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:20:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P84rqe002596;
        Tue, 25 Oct 2022 08:20:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kc7sj513c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 08:20:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P8LELH20775242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 08:21:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54058AE051;
        Tue, 25 Oct 2022 08:20:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E8D0AE056;
        Tue, 25 Oct 2022 08:20:40 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 08:20:39 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [v2 0/1] KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
Date:   Tue, 25 Oct 2022 10:20:38 +0200
Message-Id: <20221025082039.117372-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UUtDR6Cr4lwdK0W9xeFu1PLeHqDbU_6O
X-Proofpoint-ORIG-GUID: UUtDR6Cr4lwdK0W9xeFu1PLeHqDbU_6O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=606 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250046
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
* remove useless cast (thanks Christian)

Nico Boehr (1):
  KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page

 arch/s390/kvm/vsie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.37.3

