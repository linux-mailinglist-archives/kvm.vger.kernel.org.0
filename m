Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353C11C0932
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 23:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgD3V1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 17:27:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726616AbgD3V1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 17:27:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UL24PW135712;
        Thu, 30 Apr 2020 17:27:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r5cma6u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 17:27:33 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03UL2FeX136877;
        Thu, 30 Apr 2020 17:27:33 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r5cma6tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 17:27:33 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03ULN8bT012382;
        Thu, 30 Apr 2020 21:27:33 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 30mcu7cr8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 21:27:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03ULRUQA12452328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 21:27:30 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52FE27805F;
        Thu, 30 Apr 2020 21:27:31 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E7578063;
        Thu, 30 Apr 2020 21:27:30 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.180.191])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 21:27:30 +0000 (GMT)
From:   Jared Rossi <jrossi@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] vfio-ccw: Enable transparent CCW IPL from DASD
Date:   Thu, 30 Apr 2020 17:29:58 -0400
Message-Id: <20200430212959.13070-1-jrossi@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_12:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the explicit prefetch check when using vfio-ccw devices.
This check is not needed in practice as all Linux channel programs
are intended to use prefetch.

Version 2 improves logging by issuing a warning if a non-prefetch
ORB is encountered. A kernel warning is printed when an ORB without
the p-bit set is initialized.  The warning is limited to once per
five seconds because, if encountered, non-prefetch ORBs tend to
appear in bursts of hundreds per second.

The commit message is expanded to highlight the potential for
future risk if non-prefetch dependent channel programs become
prevalent.  Furthermore, a note of prefetch only support is
added to the limitations section of the vfio-ccw.rst.

Jared Rossi (1):
  vfio-ccw: Enable transparent CCW IPL from DASD

 Documentation/s390/vfio-ccw.rst |  4 ++++
 drivers/s390/cio/vfio_ccw_cp.c  | 16 +++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.17.0

