Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F6A5EFE5B
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiI2UFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiI2UFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:05:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CB31260E
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:31 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TJIkTL032567
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=9DUyzCE+9LcliOjaEta+SPjhznTXiuml9lI23qr5Cbc=;
 b=iW/EZPJTit9FOYEhY3RKNVkSyH69kYGgpyRoDIbMs/kmpPPXhBI1SfSTPDsXpv5s2y5Q
 tAUC8B8Z22+pgZTaZecwIe0tWNp0Wx1VhMJwJtQfG99KdUaTGnpxQKytrOCgIGfCLmdH
 S3WOxHToTz5HFZpGPrBaoMMs44GWLZMb0qmj95QaFxbTMm6cJuqlWVJljUSKqSlRoVKC
 /Mx/LoiGFJuLdTXc1vC1NMYWN/am9C9GfdIryjGCs1jTzScQ3LAl5nqEfDdT7xG8zJgf
 arh5fh8wPN6yghGPUjl2d/uVBbUS64stc13+XqI2d0gmbvGgpZroeNZ/dyceZOmus81C DQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jw15sxws6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:30 -0700
Received: from twshared10425.14.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 13:05:28 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 96477930500F; Thu, 29 Sep 2022 13:05:24 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <qemu-block@nongnu.org>, Kevin Wolf <kwolf@redhat.com>,
        <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 2/2] block: use the request length for iov alignment
Date:   Thu, 29 Sep 2022 13:05:23 -0700
Message-ID: <20220929200523.3218710-3-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929200523.3218710-1-kbusch@meta.com>
References: <20220929200523.3218710-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: xPKhKS53L_aYHZnSBsiuIs7WyaqUY_L3
X-Proofpoint-ORIG-GUID: xPKhKS53L_aYHZnSBsiuIs7WyaqUY_L3
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

An iov length needs to be aligned to the logical block size, which may
be larger than the memory alignment.

Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/file-posix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/file-posix.c b/block/file-posix.c
index e3f3de2780..af994aba2b 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -2068,13 +2068,14 @@ static bool bdrv_qiov_is_aligned(BlockDriverState=
 *bs, QEMUIOVector *qiov)
 {
     int i;
     size_t alignment =3D bdrv_min_mem_align(bs);
+    size_t len =3D bs->bl.request_alignment;
     IO_CODE();
=20
     for (i =3D 0; i < qiov->niov; i++) {
         if ((uintptr_t) qiov->iov[i].iov_base % alignment) {
             return false;
         }
-        if (qiov->iov[i].iov_len % alignment) {
+        if (qiov->iov[i].iov_len % len) {
             return false;
         }
     }
--=20
2.30.2

