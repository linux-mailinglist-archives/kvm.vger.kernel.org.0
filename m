Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A847764B8EB
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbiLMPtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiLMPtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:49:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5592653
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 07:47:00 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDtQBs013168;
        Tue, 13 Dec 2022 15:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=vQVGK7fgSpyCIpDQsXBeT7Ujj76DQQle9S60B0H3D4g=;
 b=0Xqv0v8W4GRK198ACA0OHvN904YCTUasCn0KH2Bu0lSWlo9ZD9qZ5nYgNCVFbIMz600H
 dITJfT/ZVdYQd/xUVtYyrpdI/zOxzTwCJAmqVg2JVN9z6htXd9rkPSiS8fj3/q9Ufz9N
 SBSIgDn/yp3NdicueSKCrN73bWKuN0W3uTaKSds+08GEqUedBSg4M3jWqIaDFyoHFzKB
 iqvGEi2PDfHXjNpJDd/BcbHDHQCCtw5uT5HT5CNUA7QB1I1Ifvnw9oRiCw+lI4t/xzUa
 5igFtrjzt7J12uOqBkvUu3Bb5XHiWd/oKTVIZLBcI8GdHo7u5yHi5t1sno23MFePO39Q wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mchqswp31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:46:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCUr8040125;
        Tue, 13 Dec 2022 15:46:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjcg41g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:46:58 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFgwtG031631;
        Tue, 13 Dec 2022 15:46:57 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3mcgjcg40c-1;
        Tue, 13 Dec 2022 15:46:57 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 0/2] fixes for virtual address update
Date:   Tue, 13 Dec 2022 07:46:54 -0800
Message-Id: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=917 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130139
X-Proofpoint-ORIG-GUID: fd6qsZD25SLMHNGql-M7T8sXXfCSRMmh
X-Proofpoint-GUID: fd6qsZD25SLMHNGql-M7T8sXXfCSRMmh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix bugs in the interfaces that allow the underlying memory object of an
iova range to be mapped in a new address space.  They allow userland to
indefinitely block vfio mediated device kernel threads, and do not
propagate the locked_vm count to a new mm.

Steve Sistare (2):
  vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
  vfio/type1: prevent locked_vm underflow

 drivers/vfio/vfio_iommu_type1.c | 36 +++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  6 +++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

-- 
1.8.3.1

