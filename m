Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F184AF517
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 16:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiBIPWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 10:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiBIPWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 10:22:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A059C0613C9;
        Wed,  9 Feb 2022 07:22:45 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219EMANK010887;
        Wed, 9 Feb 2022 15:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=PDPgdRq5kmBOP+iD3Nr/K8GbRWCQaVotmuHtKHIMnrQ=;
 b=W9mdVvOQJbN6I3OE4GFKIVC2gK7D+EcZJYodLEOyh1gh6ZG8Q+iLdZLJK5fmAVNEOVLV
 789Nx9y+VbUhzi2mhGW9/xrKbdEtKQJEs/0PxjmRq5LJFOBimU5IXsd6hnsgeuNYzutv
 TmkoY/FbpWtW0z0P1fGnOWAYDzvWbAY6KAL+TwyaVhHNe0eZ9QRm5Qm7IHhsx129Qdm0
 fEh5+YkMXwvEi8Xz7/RR/W5IBttNSwA/ZrLpWICbEbQyQ7xfMUBybuFxHVEzbvBeIMVb
 W1u7QYnj7vSF7682XGgWUpfMmjwP4BfOwJDutMAsqVVOEWW2hmCOzNblxmZyu4qOzX3B fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e418347cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 15:22:44 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219FMinc003471;
        Wed, 9 Feb 2022 15:22:44 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e418347b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 15:22:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219FJIZC002903;
        Wed, 9 Feb 2022 15:22:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gv9phfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 15:22:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219FMceC42139992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 15:22:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39F7A11C058;
        Wed,  9 Feb 2022 15:22:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D82D411C050;
        Wed,  9 Feb 2022 15:22:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 15:22:37 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v3 0/1] KVM: s390: pv: make use of ultravisor AIV support
Date:   Wed,  9 Feb 2022 16:22:16 +0100
Message-Id: <20220209152217.1793281-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VC6tczq0g_i8IE5PuqVrtiVZNHE01DWQ
X-Proofpoint-GUID: p5AAFkbSYKFKfD1xQ7XD3MSdDaBl6atE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=402 priorityscore=1501
 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables the ultravisor adapter interruption vitualization
support.

Changes in v3:
- cache and test GISA descriptor only once in kvm_s390_gisa_enable()
- modified some comments
- removed some whitespace issues

Changes in v2:
- moved GISA disable into "put CPUs in PV mode" routine
- moved GISA enable into "pull CPUs out of PV mode" routine 

[1] https://lore.kernel.org/lkml/ae7c65d8-f632-a7f4-926a-50b9660673a1@linux.ibm.com/T/#mcb67699bf458ba7482f6b7529afe589d1dbb5930
[2] https://lore.kernel.org/kvm/20220208165310.3905815-1-mimu@linux.ibm.com/T/#e0ecf74ad7fdccc5ed22007e783106d4ef7b849df 

Michael Mueller (1):
  KVM: s390: pv: make use of ultravisor AIV support

 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kvm/interrupt.c  | 56 ++++++++++++++++++++++++++++++++++----
 arch/s390/kvm/kvm-s390.c   | 11 ++++++--
 arch/s390/kvm/kvm-s390.h   | 11 ++++++++
 4 files changed, 70 insertions(+), 9 deletions(-)

-- 
2.32.0

