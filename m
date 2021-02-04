Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08230C8FC
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhBBSGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:06:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234405AbhBBSBR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 13:01:17 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 112HUxl6004795;
        Tue, 2 Feb 2021 13:00:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=xvHIsgzKyZQkrHD83FTOBU/tApKe6WvjIoLg2C2AXP8=;
 b=cwdpNrRxJ/zUjhQ+fJsDXxK0tJ9NwIoJHYynpeprhsPqe0IzjMbg6CJcZ6N0T8HBtIxI
 ACZN2p7hI7doMK/BDjFrp/oKCjFdcobad4qmda2wF/BtdYIkVw1luWoowqTNIY/5oY7n
 FBr08x6PPKeE8ROuJR0FR9Ja6/BcpXmvwFlvYQQIBh0XUTChrtRMbtYvGbe3zHsHOJ5/
 El10H/DMecbzk8MAy19IMVlFRuvbWMzHp/4BMHXvJMm5Us3UqhoghihVDOE6+3/EPpMs
 qgBIYOiAoSUvoWMvMj6P44pueiIvqFVEkfCMcBFWIXchtk7a6ZZRLZMN0P1/OEtLCyp1 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36fb3n14aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 13:00:34 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112HV3Id005344;
        Tue, 2 Feb 2021 13:00:34 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36fb3n149j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 13:00:34 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 112HrQ39030725;
        Tue, 2 Feb 2021 18:00:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 36cxqh9mqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 18:00:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 112I0K4v29819208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 18:00:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61275AE057;
        Tue,  2 Feb 2021 18:00:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 054A7AE063;
        Tue,  2 Feb 2021 18:00:29 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.15.83])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 18:00:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/2] s390/kvm: fix MVPG when in VSIE
Date:   Tue,  2 Feb 2021 19:00:26 +0100
Message-Id: <20210202180028.876888-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_08:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=825
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current handling of the MVPG instruction when executed in a nested
guest is wrong, and can lead to the nested guest hanging.

This patchset fixes the behaviour to be more architecturally correct,
and fixes the hangs observed.

v1->v2
* complete rewrite

Claudio Imbrenda (2):
  s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
  s390/kvm: VSIE: correctly handle MVPG when in VSIE

 arch/s390/kvm/gaccess.c |  26 ++++++++--
 arch/s390/kvm/gaccess.h |   5 +-
 arch/s390/kvm/vsie.c    | 102 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 119 insertions(+), 14 deletions(-)

-- 
2.26.2

