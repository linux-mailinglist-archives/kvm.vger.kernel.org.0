Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C4E60D4B0
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 21:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiJYTb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 15:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiJYTb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 15:31:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64290BBF39
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:31:26 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PI4kY0004143;
        Tue, 25 Oct 2022 19:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=TdeDcU2llXEcFQTUo3uw8GBcTlhlAqcRXY160d5yQw8=;
 b=KwiosVyJQYOpUcpcl7TFBmtUpQteOKjunY5/BoPdnnK6CnO8Cdvql+sDz/FbdKWuU6JR
 OI7M+BDNnqLu0cSY5/GKwhVSveSZuEQwaJY+d/O1SE/l3DiyWFQrZqRi4W1OdYA6Gj98
 wSG+2UlCm4bVdnJWvXRvSl8PF1HgCJXhBtzKpSWir/3gb91X/fqtWWS/a38KWlmr4XTu
 0VVUJITN1Wp/6/rpXWS1NklnlmoWzFijphqpyV0rMliCHqwpyA1Yy05ZTDaJDnLTBim1
 APEzVojnKShvBV6H/6C/cbhg+GLNBMs+r4/toNDoVgxju14YexLuLnuYy923fIZGDhcp 2Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939d5yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 19:31:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJ5VkP012753;
        Tue, 25 Oct 2022 19:31:22 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-215-98.vpn.oracle.com [10.175.215.98])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y4y1dp-1;
        Tue, 25 Oct 2022 19:31:21 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v1 0/2] vfio/iova_bitmap: bug fixes
Date:   Tue, 25 Oct 2022 20:31:12 +0100
Message-Id: <20221025193114.58695-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_12,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=880 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250110
X-Proofpoint-GUID: KbCrhnLtwBPyGHT9RsJRyj4WEi4ygGRG
X-Proofpoint-ORIG-GUID: KbCrhnLtwBPyGHT9RsJRyj4WEi4ygGRG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

This small series addresses one small improvement and one bug fix:

1) Avoid obscurity into how I use slab helpers yet I was
never include it directly. And it wasn't detected thanks to a unrelated
commit in v5.18 that lead linux/mm.h to indirectly include slab.h.

2) A bug reported by Avihai reported during migration testing where
we weren't handling correctly PAGE_SIZE unaligned bitmaps, which lead
to miss dirty marked correctly on some IOVAs.

Comments appreciated

Thanks,
	Joao

Joao Martins (2):
  vfio/iova_bitmap: Explicitly include linux/slab.h
  vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps

 drivers/vfio/iova_bitmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
2.17.2

