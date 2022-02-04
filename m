Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6A84A99B8
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 14:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiBDNJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 08:09:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245574AbiBDNJH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 08:09:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214BpVrm026612
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=W7sjWEgfnr9ZhuChNkS6O2kWjcMN8iho3Eo5eLpl5nk=;
 b=E5K/sPx2+iPkSdNMOtGmFg8omU5Ut8zJF52mnjEhk8WVFj0h3RbuQ2ASn/CVg4JzQj8j
 nY89ojgD7QiukWRCEwtmzo2+2aamPSySyKZ9KO2IP5TK7v8HkSmaj4lJJUD640wsNG30
 Z15uPtbIky5zLWJA9hBCEGkYzvJibnp48yfLNDrYZ6SXLHbbF6csa2UjhtWLcodY4tbn
 P6DY+lLF2cEk+9ZdpPNegv3P8y+8Y2DL0t8Lg1TgsasFlwVX65hUcyk1W4pg+NOV2CPA
 q3yosqkpbcnaAxYBe9jd5RPqaYbYFMJHe+6dv/OL8f2+H8cJ43v19efrXYtC8vzWllBD Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx1d7j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:09:07 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214Cs2kC017509
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx1d7hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214D7VDH019530;
        Fri, 4 Feb 2022 13:09:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10d0th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214D90L346661918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 13:09:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51B9A4C046;
        Fri,  4 Feb 2022 13:09:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF83A4C062;
        Fri,  4 Feb 2022 13:08:59 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 13:08:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 6/6] s390x: uv-host: use CPU indexes instead of addresses
Date:   Fri,  4 Feb 2022 14:08:55 +0100
Message-Id: <20220204130855.39520-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204130855.39520-1-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lgQm3TLaCJDxG6WOvUPPHBZCnP6fML-r
X-Proofpoint-GUID: uILMjb-RTNFUTeaKCsVutYFmf1tEtbtA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adapt the test to the new semantics of the smp_* functions, and use CPU
indexes instead of addresses.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 92a41069..a3d45d63 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -267,12 +267,12 @@ static void test_config_create(void)
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
 	if (smp_query_num_cpus() == 1) {
-		sigp_retry(1, SIGP_SET_PREFIX,
+		smp_sigp_retry(1, SIGP_SET_PREFIX,
 			   uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NULL);
 		rc = uv_call(0, (uint64_t)&uvcb_cgc);
 		report(uvcb_cgc.header.rc == 0x10e && rc == 1 &&
 		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
-		sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
+		smp_sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
 	}
 
 	tmp = uvcb_cgc.guest_sca;
-- 
2.34.1

