Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B2252805F
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbiEPJH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiEPJHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:07:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879C0BE2B;
        Mon, 16 May 2022 02:07:09 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8Nvum023578;
        Mon, 16 May 2022 09:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9x0tKkApznKq3i+TefliTcA5FzoErZXEZ2Yh91oxm60=;
 b=By6NemYa1CRS/OkHqe/QGJZcmhq4far7g8ATxAL0oO1+/GQmTPJbXQqQbTAGa7R765Tr
 nInv/P/S4QyDi5iLHP04pjGLVV14is9O3lMJFQ7GdQmHHnx4vYABSZkrmml917WMzkk7
 mTJ0PtZIv241TytEZekQ+GEuqwsR43DoT2m8mA5BiZkGsc6zEfxv2pDh00gpj87tmHQs
 IDxKi+iuBRNn7vZ4zZlXcR5IaJMpBSJT9IG6cQziGZ5IpCIfu4hTZ5ubYVXdxUP/rZkl
 eCXlePJIU3LtK+3R7eLnHRuMQYsSFmRXK21Ka6ArIxk2QLnCzHhXTcDzMAJj9BWk3NOz XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3k2n8t7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:07:09 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G8sDDc018634;
        Mon, 16 May 2022 09:07:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3k2n8t77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:07:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G94NJW004662;
        Mon, 16 May 2022 09:07:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429abk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:07:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G973Qk28115352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:07:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB04FA405F;
        Mon, 16 May 2022 09:07:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6BBAA405B;
        Mon, 16 May 2022 09:07:02 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:07:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/1] s390x: add migration test for storage keys
Date:   Mon, 16 May 2022 11:07:01 +0200
Message-Id: <20220516090702.1939253-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1UTeNgpy0qOUYbqsY8fq7o0FxxPMGlt9
X-Proofpoint-ORIG-GUID: PzuydkC2WVN_O-got5j8-04eNwvSiGFt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=667 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
----
* As per discussion with Janis and Claudio, remove the actual access check from
  the test. This also allows us to remove the check_pgm_int_code_xfail() patch.
* Typos/Style suggestions (thanks Janis)

Upon migration, we expect storage keys being set by the guest to be preserved,
so add a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
they can be read back and the respective access restrictions are in place when
the access key in the PSW doesn't match.

Nico Boehr (1):
  s390x: add migration test for storage keys

 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 83 insertions(+)
 create mode 100644 s390x/migration-skey.c

-- 
2.31.1

