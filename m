Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17D05EFE5C
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiI2UFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiI2UFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:05:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C761B5A41
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:34 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TJIfUn006138
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=C+nkGoYtEXf9lLeKFSRNNzYPHusMQmtBZGd0L3SuEhM=;
 b=LiZ7ONxv7uB9uicfDJq2dGxG5viEUa1LfzXbp/IDOetn7dJtiYb3prEebgYCja0uyIFl
 Vg9iABBw0pMZrE+9s/fLGgLbsGfVbrYWEAijTH73Rvmhm3nsbpB6OI8xgEh8TVFBFYjq
 HoTc5T8CUf/AX00DNJLWa9MA1f+BdD/OKYlV41FGGyp0otnNDl9KWbDh5qIJWWaLX6tT
 4qYIQABYc2U4hmdpXeAejCcZhwOfkwRLY5lVjeGjswqN9xnun+Jp73P/uGUx1nqhjuRl
 SbU90xS2CEw/rD5m9TmuAeI2LEtIj4RGMxRM8OW2OOt7pGiU0pT/4xl0EttJfacbjdXy eg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jwdp12krt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:33 -0700
Received: from twshared25017.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 13:05:32 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 3A86F9305008; Thu, 29 Sep 2022 13:05:24 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <qemu-block@nongnu.org>, Kevin Wolf <kwolf@redhat.com>,
        <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 0/2] qemu direct io alignment fix
Date:   Thu, 29 Sep 2022 13:05:21 -0700
Message-ID: <20220929200523.3218710-1-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: w4xeWIh7uo6o47JaeEzUuvSVc3PUcKij
X-Proofpoint-GUID: w4xeWIh7uo6o47JaeEzUuvSVc3PUcKij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_11,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Changes from v2:

  Split the patch so that the function move is separate from the
  functional change. This makes it immediately obvious what criteria is
  changing. (Kevin Wolf)

  Added received Tested-by tag in the changelog.=20

Keith Busch (2):
  block: move bdrv_qiov_is_aligned to file-posix
  block: use the request length for iov alignment

 block/file-posix.c       | 22 ++++++++++++++++++++++
 block/io.c               | 21 ---------------------
 include/block/block-io.h |  1 -
 3 files changed, 22 insertions(+), 22 deletions(-)

--=20
2.30.2

