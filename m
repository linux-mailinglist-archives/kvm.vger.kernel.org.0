Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573DA37AFC5
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 21:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhEKT5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 15:57:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhEKT5u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 15:57:50 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BJXsUb171564;
        Tue, 11 May 2021 15:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=HjLYgEurXkONDxmN71vnc4qpFZfY+USpOrOsSejGVFk=;
 b=cHSk9tjcMXy8eGuSBY9L4Ewr0Km1BXYbTBu8icA+m6/m39VMgxo0Ts14X4oigXelR8xW
 u2oObhNS27XVWhYa3lR55CxddDXC6JGiWQKMVQP5Kk5iU8fd9fTOXImnloeCCHvQdKV8
 eIjHqxO9QBVVDs4wCE5yYSOzySmWpSWBaJEFnPqZlMndstnRbUwn2mRLHfqrmXjrv7S7
 RKoT5pZ6F4abOhfPo5OLx163bAYP6hGiC6IilcAidOcIiraimlHOghE9ufY74oBV6fcA
 Y5gXeHLmu9FH0WozLobvF3A1I5TBXcswjb1DWNrk6GScnqiTTKSZsl4YVJyqYQeDawYu VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fw0r6by7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 15:56:43 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BJXvLT171857;
        Tue, 11 May 2021 15:56:43 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fw0r6bxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 15:56:43 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BJmhsR021962;
        Tue, 11 May 2021 19:56:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 38dj989u8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 19:56:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BJubpk33358290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 19:56:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3CF5A4060;
        Tue, 11 May 2021 19:56:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0981A4054;
        Tue, 11 May 2021 19:56:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 11 May 2021 19:56:37 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 5B3DFE0356; Tue, 11 May 2021 21:56:32 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v6 0/3] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Date:   Tue, 11 May 2021 21:56:28 +0200
Message-Id: <20210511195631.3995081-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 28mf0-0GtL4HWlG2eekMsUiDquXYBYU_
X-Proofpoint-GUID: uy3HdWRg9NQrlIE8qDE2thaZJegLT_23
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 mlxlogscore=894 impostorscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110130
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conny, Matt, Halil,

Here's one (last?) update to my proposal for handling the collision
between interrupts for START SUBCHANNEL and HALT/CLEAR SUBCHANNEL.

Only change here is to include Conny's suggestions on patch 3.

Thanks,
Eric

Changelog:
v5->v6:
 - Add a block comment and rename variable in patch 3 [CH]
 - Drop RFC tag [EF]

v4->v5:
 - Applied Conny's r-b to patches 1 and 3
 - Dropped patch 2 and 4
 - Use a "finished" flag in the interrupt completion path

Previous versions:
v5: https://lore.kernel.org/kvm/20210510205646.1845844-1-farman@linux.ibm.com/
v4: https://lore.kernel.org/kvm/20210413182410.1396170-1-farman@linux.ibm.com/
v3: https://lore.kernel.org/kvm/20200616195053.99253-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/kvm/20200513142934.28788-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/

Eric Farman (3):
  vfio-ccw: Check initialized flag in cp_init()
  vfio-ccw: Reset FSM state to IDLE inside FSM
  vfio-ccw: Serialize FSM IDLE state with I/O completion

 drivers/s390/cio/vfio_ccw_cp.c  |  4 ++++
 drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++--
 drivers/s390/cio/vfio_ccw_fsm.c |  1 +
 drivers/s390/cio/vfio_ccw_ops.c |  2 --
 4 files changed, 15 insertions(+), 4 deletions(-)

-- 
2.25.1

