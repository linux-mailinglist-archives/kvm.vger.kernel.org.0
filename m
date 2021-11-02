Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2064436AA
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 20:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhKBTtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 15:49:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230043AbhKBTtk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 15:49:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2I1kTS016571;
        Tue, 2 Nov 2021 19:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ncG5Uzws+fVb0FYOwZbrkc7+Arq4gVOrK5eUqO9Zmd0=;
 b=bLxgTOp1+6esOkN1CDoed5cZJBu54qJv0ZoT+ji9K1w+4VJTxzIj8P5CI485YDfWrJVt
 3adsBFZtUWIi5kq8/nIWuKyT+onUH11PgNxEYyoQGWni5tukWEZ1CmKhUyh93O5CVKCx
 Vh6eegoKnuWUl/uVYBqDbE+kpJkLXBY8+gYO+fnmC2KesOay3/QBpYKW2P3VKkgT4JhQ
 6OL8BjNRlk5cXRQpREPu5c/lBvSLnyJBh5LqfxpTQsrfWK8TQulP7xlXEOIprWcBqkzr
 3xEy9JyvTLuAHsyBJWSm5Fz+76CEIAm+PuYtM0OM2u4t0jqvbZVwJylAkwCP2Yp4SZJP eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c381ynncy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:03 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A2JELBo013749;
        Tue, 2 Nov 2021 19:47:02 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c381ynncj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:02 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A2JRVoM005664;
        Tue, 2 Nov 2021 19:47:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3c0wajnjfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A2JkvXj5243622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 19:46:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32F6B4C04A;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FF1D4C044;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C5AD1E039C; Tue,  2 Nov 2021 20:46:56 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 0/2] s390x: Improvements to SIGP handling [KVM]
Date:   Tue,  2 Nov 2021 20:46:50 +0100
Message-Id: <20211102194652.2685098-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pcvMg0jeV77L8jPZsccvPd3AbPxIJbwF
X-Proofpoint-ORIG-GUID: c2-DreV6Ahv6yDnXzLj--u5oFNCsmx5D
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is a new variation of the SIGP handling discussed a few
weeks ago [1]. Notable changes:

 - Patches 1 and 6 from v1 were picked for 5.16 (Thank you!) [2]
 - Patches 2 through 5 were removed, and replaced with this
   iteration that relies on a KVM capability and IOCTL

I opted to use David's suggestion [3] for the kernel to
automatically set a vcpu "busy" and userspace to reset it
when complete. I made it dependent on the existing USER_SIGP
stuff, which maybe isn't great for potential non-SIGP scenarios
in the future, but this at least shows how it could work.

According to the Principles of Operation, only a subset of
SIGP orders would generate a "busy" condition, and a different
subset would even notice it. But I did the entirety of the SIGP
orders, even the invalid ones that would otherwise return some
status bits and CC1 instead of the CC2 (BUSY) condition.
Perhaps that's too much, perhaps not.

As I'm writing this, I'm realizing that I probably need to look
at the cpu reset paths clearer, to ensure the "busy" indicator
is actually reset to zero.

Since this is an RFC, I've left the CAP/IOCTL definitions as
a standalone patch, so I see it easier when working with the
QEMU code. Ultimately this would be squashed together, and
might have some refit after the merge window anyway.

I'll send the QEMU series shortly, which takes advantage of this.

Thoughts?

[1] https://lore.kernel.org/r/20211008203112.1979843-1-farman@linux.ibm.com/
[2] https://lore.kernel.org/r/20211031121104.14764-1-borntraeger@de.ibm.com/
[3] https://lore.kernel.org/r/3e3b38d1-b338-0211-04ab-91f913c1f557@redhat.com/

Eric Farman (2):
  Capability/IOCTL/Documentation
  KVM: s390: Extend the USER_SIGP capability

 Documentation/virt/kvm/api.rst   | 27 +++++++++++++++++++++
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 18 ++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 10 ++++++++
 arch/s390/kvm/sigp.c             | 40 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  4 ++++
 6 files changed, 101 insertions(+)

-- 
2.25.1

