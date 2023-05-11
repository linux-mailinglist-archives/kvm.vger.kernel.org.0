Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D5B6FEF1E
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 11:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbjEKJre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 05:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjEKJrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 05:47:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444E81FFE;
        Thu, 11 May 2023 02:47:31 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34B9ct2E000929;
        Thu, 11 May 2023 09:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mxCPd8Eafw0hllUQnkeAng0xEkLXstTLptXkOa7zvUM=;
 b=izcCRcsk08t4DIQbQMIJOLOJFPUSJKZm90PIySeV+jpoGGVVeg84yOSG8CrXB+4wmLhe
 8D6qlawJ80cZeMRXiRfPe63vLfObaXGgpdHOTaoMY70h4BZjtVsomJorPVJXdE17vcHZ
 YVIjH+ON8RFUR9/roGvQ1LxxjrERGLtii/yaL4nUL3R8GCs2JgsgbRiTup2Hy9CHej3b
 ZawbEhOnWqFdKKAstv5dy04M3RbkmgfH13GTin+z69GrUtWEoFre7jXWTdAYFJy3jzki
 8UH8ljNlgEXXB8dNLmxbSyK27QBsHwAlQ0gZOr6x26JdWqmhDa/Jyi1FN/wut21kD3S5 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgva0u6au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 May 2023 09:47:30 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34B9lUbt004656;
        Thu, 11 May 2023 09:47:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgva0u69r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 May 2023 09:47:30 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34B3unue030591;
        Thu, 11 May 2023 09:47:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qf7mhh9kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 May 2023 09:47:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34B9lLDf32833858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 May 2023 09:47:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DCF32006E;
        Thu, 11 May 2023 09:47:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4375A20094;
        Thu, 11 May 2023 09:47:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.23.165])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 11 May 2023 09:47:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
Subject: [PATCH 0/1] KVM: s390: vsie: fix the length of APCB bitmap
Date:   Thu, 11 May 2023 11:47:18 +0200
Message-Id: <20230511094719.9691-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1AY8IvvE4SKnUSQwZj250Ehpl9VvB_sU
X-Proofpoint-ORIG-GUID: LGuZ6AgO3B4VDCnenAgtVcdjB7iniHZF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-11_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=436 mlxscore=0 clxscore=1011 impostorscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305110081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

bit_and() uses the count of bits as the woking length.
Fix the previous implementation and effectively use
the right bitmap size.

VSIE With AP has been after the patching succesfuly tested in
VSIE with Harald's AP test zcryptping.

Fixes: 19fd83a64718 ("KVM: s390: vsie: allow CRYCB FORMAT-1")
Fixes: 56019f9aca22 ("KVM: s390: vsie: Allow CRYCB FORMAT-2")


Pierre Morel (1):
  KVM: s390: vsie: fix the length of APCB bitmap

 arch/s390/kvm/vsie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.31.1

