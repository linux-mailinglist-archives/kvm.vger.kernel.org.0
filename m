Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD46EA63F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjDUIvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjDUIu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:50:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383DEA249;
        Fri, 21 Apr 2023 01:50:51 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L8oQqV008307;
        Fri, 21 Apr 2023 08:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1rY0AJuzCvr4bKWKdQn+znXW9Cg6kd/HWcj8XtK6vq4=;
 b=DBmwuzEDLIJOd6RXsEkhNbl1rxabvxBfeuffhMAUHFVBq1RGCmz9RhmmTunms2tBRM8C
 jnq1nVDM/zlE+2vY5fea774+mTw4svHcWwNpuoPg7PNYYqWJ2aBwi57m+nYZmHJr9PmI
 V5YSGK6pmBGHmxNaS2NvKUZ/pDV0bKYo3TMpS+HRbiDrl9cpeyUpt3tX4T99CQfNamrX
 2Q5hjPsppkdIkU4rR9OIdv59T6rI5oVlETQzPeEMQ5RK7VfcoVmRrqtd2vwMWss6kRZ1
 GNmIin5B14YAGOnAT3HbbCWN5JAZGw8W/RR6iSAGSp1QMXXvBDKWdraOSVGyJkJU0eF3 kg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3q7sr7xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:50:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L07AmU024025;
        Fri, 21 Apr 2023 08:50:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3pyk6fk8dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:50:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L8ogxq34669006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 08:50:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AA5220040;
        Fri, 21 Apr 2023 08:50:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F36320043;
        Fri, 21 Apr 2023 08:50:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.17.52])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 08:50:41 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com,
        kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 0/1] KVM: s390: pv: fix asynchronous teardown for small VMs
Date:   Fri, 21 Apr 2023 10:50:35 +0200
Message-Id: <20230421085036.52511-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ByDAMJG2pozyBFDTK46GuUm0tjwWIEk
X-Proofpoint-ORIG-GUID: -ByDAMJG2pozyBFDTK46GuUm0tjwWIEk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=911 clxscore=1015 bulkscore=0 spamscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On machines without the Destroy Secure Configuration Fast UVC, the
topmost level of page tables is set aside and freed asynchronously
as last step of the asynchronous teardown.

Each gmap has a host_to_guest radix tree mapping host (userspace)
addresses (with 1M granularity) to gmap segment table entries (pmds).

If a guest is smaller than 2GB, the topmost level of page tables is the
segment table (i.e. there are only 2 levels). Replacing it means that
the pointers in the host_to_guest mapping would become stale and cause
all kinds of nasty issues.

This patch fixes the issue by disallowing asynchronous teardown for
guests with only 2 levels of page tables. Userspace should (and already
does) try using the normal destroy if the asynchronous one fails.

Update s390_replace_asce so it refuses to replace segment type ASCEs.

v1->v2:
After talking with Marc, I decided to throw away most of the patch and
instead simply refuse to prepare for asynchronous teardown if the VM has a
segment type ASCE.


Claudio Imbrenda (1):
  KVM: s390: pv: fix asynchronous teardown for small VMs

 arch/s390/kvm/pv.c  | 5 +++++
 arch/s390/mm/gmap.c | 7 +++++++
 2 files changed, 12 insertions(+)

-- 
2.40.0

