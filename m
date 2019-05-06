Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB75114A9A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 15:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfEFNLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 09:11:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726255AbfEFNLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 09:11:19 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46D76QE141719
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 09:11:17 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sam04c9tr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 09:11:17 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 14:11:15 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 14:11:13 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46DBB9A58982428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 13:11:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56D0AA4040;
        Mon,  6 May 2019 13:11:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F369DA4055;
        Mon,  6 May 2019 13:11:10 +0000 (GMT)
Received: from morel-ThinkPad-W530.numericable.fr (unknown [9.145.46.119])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 13:11:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     cohuck@redhat.com
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        alifm@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v1 0/2] New state handling for VFIO CCW
Date:   Mon,  6 May 2019 15:11:08 +0200
X-Mailer: git-send-email 2.7.4
X-TM-AS-GCONF: 00
x-cbid: 19050613-0012-0000-0000-00000318D2C8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050613-0013-0000-0000-000021514BE7
Message-Id: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=569 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I did not integrate all my patches for state handling like I had
before but just two patches which seems interresting to me:

- The first one allows the device ti be used only when a guest
  is currently using it.
  Otherwise the device is in NOT_OPER state
 
- The second rework the sch_event callback: AFAIU we can not
  consider that the event moves the device in IDLE state.
  I think we better let it as it is currently.

Regards,
Pierre

Pierre Morel (2):
  vfio-ccw: Set subchannel state STANDBY on open
  vfio-ccw: rework sch_event

 drivers/s390/cio/vfio_ccw_drv.c     | 21 ++-------------------
 drivers/s390/cio/vfio_ccw_fsm.c     |  7 +------
 drivers/s390/cio/vfio_ccw_ops.c     | 36 ++++++++++++++++++------------------
 drivers/s390/cio/vfio_ccw_private.h |  1 -
 4 files changed, 21 insertions(+), 44 deletions(-)

-- 
2.7.4

