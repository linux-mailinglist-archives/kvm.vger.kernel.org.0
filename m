Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F033798AB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhEJU6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:58:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232847AbhEJU6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 16:58:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AKiMOs076650;
        Mon, 10 May 2021 16:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=3ejgp9ieQVOHbjTpuh55gWqJ5Sk7YcDs3R1J9dJEvXI=;
 b=FnxBdsPurdMu/XUtxCwUyhNiFLHUvIHcKBmgC2ob/EsLXnQfyIV/yMATck29s2SOufy1
 bGc1KSkPmyhp3+zhU24MBoCkoXNJAPzaHcAU7YfIVCQdzU1A7e8KGsRjs79Q2qqI/fYc
 bLB6su/EG7yZyB3H1FFySkAejWXo54q/K0j5ZImpDuArd+vFpXFpHO4CU8S8Gudha/G9
 zw2RKa9VqDqJW3tzBvQHZkZOcwxxkez7GZonDZp0yhBk5KP8qjJgiUIdf8mRhLirzG95
 2Gdu2h0pwkk6T4z5hTKK7gpvuvM9vdOeh8jOT4zQ/8UPJbPc2bXv4xMGtjC/sEMHwXeg OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fc4mg95u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:56:54 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AKjfAE087857;
        Mon, 10 May 2021 16:56:54 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fc4mg948-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:56:54 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AKtI0f003065;
        Mon, 10 May 2021 20:56:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 38dj98gpec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 20:56:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AKumAC23855390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 20:56:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99ABEA405C;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85FF5A4054;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2B7B6E028D; Mon, 10 May 2021 22:56:48 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v5 0/3] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Date:   Mon, 10 May 2021 22:56:43 +0200
Message-Id: <20210510205646.1845844-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9npWSwHlq46qtu_gfjb56wneFsKSX4PR
X-Proofpoint-ORIG-GUID: sHfTEOP3pOjOvzHyi5DyQ5z4UfYKzsE4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_12:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105100140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conny, Matt, Halil,

Here's the update to my proposed series for handling the collision
between interrupts for START SUBCHANNEL and HALT/CLEAR SUBCHANNEL.
I'm feeling more confident in the state of them now based on the
discussion on v4, so will keep the cover letter brief. :)

I carried patches 1 and 3 from the last version forward, as patch
1 and 2 here. (Thanks, Conny, for the r-b's on them.)

I dropped patches 2 and 4 from the last version, as part of this
newest attempt.  The conversation on patch 4 [1] has formed into
the new patch 3.

As we'd discussed offline last week, I still have the todo for
a more proper audit of the serialization across these codepaths.
But this seems a better, simpler, fix for the code in its current
form, which addresses my problematic test case and does not
impact my usual regression tests. Any further rework for the
serialization [2] will be more invasive, and take a bit longer.

Thanks,
Eric

Changelog:
v4->v5:
 - Applied Conny's r-b to patches 1 and 3
 - Dropped patch 2 and 4
 - Use a "finished" flag in the interrupt completion path

Previous versions:
v4: https://lore.kernel.org/kvm/20210413182410.1396170-1-farman@linux.ibm.com/
v3: https://lore.kernel.org/kvm/20200616195053.99253-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/kvm/20200513142934.28788-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/

References:
[1] https://lore.kernel.org/kvm/2c1c1e73d488673ec39d7c085a343cbd6b50fb41.camel@linux.ibm.com/
[2] https://lore.kernel.org/kvm/20210416164137.23f4631b.cohuck@redhat.com/

Eric Farman (3):
  vfio-ccw: Check initialized flag in cp_init()
  vfio-ccw: Reset FSM state to IDLE inside FSM
  vfio-ccw: Serialize FSM IDLE state with I/O completion

 drivers/s390/cio/vfio_ccw_cp.c  | 4 ++++
 drivers/s390/cio/vfio_ccw_drv.c | 8 +++++---
 drivers/s390/cio/vfio_ccw_fsm.c | 1 +
 drivers/s390/cio/vfio_ccw_ops.c | 2 --
 4 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.25.1

