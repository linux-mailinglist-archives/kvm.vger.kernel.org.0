Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE9D2DE3E1
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 15:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgLROS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 09:18:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbgLROS6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 09:18:58 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEDEnT040950;
        Fri, 18 Dec 2020 09:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Hb2vIskaEuEzm8cbxDywKvyMNWrHp7cUGkREIFvkH3I=;
 b=RQmf/u2MgmVv/pU1R2MqfPcromLVjaxvE4kE9Z7+pbbfR4nJAW3PEZJOAe4fjpUx7BmN
 5v8BzOr6pUrSUUBS3HFPqimHIbwqeBQY0DeiHNUaSlrqb65WQ3eYfycuqK3xYLLq5Ziq
 +ga0kuAN4ohOKMad0WZ/QboS7FEs/Kw62eLbWx2oYmMMKQoRTQegIyJLm/Bx8GkZVeu3
 /TQlFwppwW0DxkPeYOeQ+ZD1V06RN8UwXviEC8dNwzKQoumfnbBExeu0QSa5xFustnR2
 FcoXKzA9Pn0tiYgW1PAeh+WzTpHmTmB2BvPwl6VwwhEJBDBPCyufB1kheLFsX5MjOWYD 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35gx0cg55q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BIEDTSv041680;
        Fri, 18 Dec 2020 09:18:17 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35gx0cg54x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:17 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEGeoM015047;
        Fri, 18 Dec 2020 14:18:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 35cng8bbw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 14:18:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BIEICh842467650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 14:18:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34A24A4060;
        Fri, 18 Dec 2020 14:18:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF5D7A405B;
        Fri, 18 Dec 2020 14:18:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 14:18:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/4] s390/kvm: fix MVPG when in VSIE
Date:   Fri, 18 Dec 2020 15:18:07 +0100
Message-Id: <20201218141811.310267-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_09:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=790 spamscore=0 impostorscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current handling of the MVPG instruction when executed in a nested
guest is wrong, and can lead to the nested guest hanging.

This patchset fixes the behaviour to be more architecturally correct,
and fixes the hangs observed.

Claudio Imbrenda (4):
  s390/kvm: VSIE: stop leaking host addresses
  s390/kvm: extend guest_translate for MVPG interpretation
  s390/kvm: add kvm_s390_vsie_mvpg_check needed for VSIE MVPG
  s390/kvm: VSIE: correctly handle MVPG when in VSIE

 arch/s390/kvm/gaccess.c | 88 ++++++++++++++++++++++++++++++++++++++---
 arch/s390/kvm/gaccess.h |  3 ++
 arch/s390/kvm/vsie.c    | 78 +++++++++++++++++++++++++++++++++---
 3 files changed, 159 insertions(+), 10 deletions(-)

-- 
2.26.2

