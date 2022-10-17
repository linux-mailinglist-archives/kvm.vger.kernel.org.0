Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14D600B0E
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiJQJkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiJQJkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17C724BC3
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:39:58 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H96o6U004063
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=SDtoT/ItDCq6dF8eWb5I4nkirRwKCP2i7pgoxEQoJHw=;
 b=PZ+yCYOWK24hTfNUK6txLcYWZ8bNRblxTFA4d8AKJCrsJ/1cWON/f32F20nAnm2UId1D
 MfF7D1oT6o+WgHmDwcSvjCps+gf2lzbchMmwKBVtHjdPQAxjXePpGDf0KyuMtnrqZq9k
 VMRgCcYljg/2sBeepWSfexnWjaAcdMEl4GjERAtBrBM63i81/qGqYPjxGe8BnK4jT83B
 jFmbPKoutueVFV6yd+4dyXTmiE3uzNfhDZ3W7WG/1T8FkroalJXmFd9Cqk+f9ph6WfJU
 YIXB2vFQWCsZDa3ncUgnNwXHhqu+33DInjCHre9AOidfoWXx+GzAvOTnpmsVKJXemss7 Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86ws328d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:39:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H9Znot006518
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:39:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86ws3279-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9aL8R024450;
        Mon, 17 Oct 2022 09:39:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3k7mg8t2xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9dqvS6554288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:39:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E42AA405B;
        Mon, 17 Oct 2022 09:39:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C51B8A4054;
        Mon, 17 Oct 2022 09:39:51 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:51 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/8] s390x: uv-host: Access check extensions and improvements
Date:   Mon, 17 Oct 2022 09:39:17 +0000
Message-Id: <20221017093925.2038-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Orrx-x-34GGE9iMKILu3-O2xIJV5wmGm
X-Proofpoint-ORIG-GUID: oSfyBe96Gua_3T45Cw8rEVhv7eHOM2il
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Over the last few weeks I had a few ideas on how to extend the uv-host
test to get more coverage. Most checks are access checks for secure
pages or the UVCB and its satellites.

v3:
	* Added len assert for access_check_3d
	* using the latest version of patch #1

v2:
	* Moved 3d access check in function
	* Small fixes
	* Added two more fix patches

Janosch Frank (8):
  s390x: uv-host: Add access checks for donated memory
  s390x: uv-host: Add uninitialized UV tests
  s390x: uv-host: Test uv immediate parameter
  s390x: uv-host: Add access exception test
  s390x: uv-host: Add a set secure config parameters test function
  s390x: uv-host: Remove duplicated +
  s390x: uv-host: Fence against being run as a PV guest
  s390x: uv-host: Fix init storage origin and length check

 s390x/uv-host.c | 264 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 254 insertions(+), 10 deletions(-)

-- 
2.34.1

