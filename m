Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE4024A3EC
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 18:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHSQXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 12:23:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSQXe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 12:23:34 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JG3O8D054851;
        Wed, 19 Aug 2020 12:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=uu1KxyVc4kHFi1gkZn4wAfBW3iiu2CMXNeV7oFLjvfs=;
 b=bZSlKJ1kFW8HKwqlHAJBbQgIcEjCElwmEjtpwguNFyrHo3ZLLF0CQcf0EUnDLjFUGBP3
 dVk97udHXG/OqxGbouKupRxWpmn2rdlo/F8kr246fBH8MmwEoIt/ZipI3DOq3AGI3DHR
 kOw+npFgyCw7j9BOUSiotmCelbiQgS9xCQjP/twKDjdE4p7IYT8lgev7wFYn9ZxyxaEr
 VGRL6cyvW0ors62iqW2pz0zPrYbEco/Y7XRUF0RlbgXRfT4Kgd6cZ37WoK5J9orhCDkG
 B+kGvhmpmWHn+80D1AtWt00w8dKb4vh7JyidXzS8osHpusX036CvMIIosFNKvhecobfF MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3313kxrvqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 12:23:27 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07JG3l9T057245;
        Wed, 19 Aug 2020 12:23:26 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3313kxrvp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 12:23:26 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JGMOd3003321;
        Wed, 19 Aug 2020 16:23:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 330tbvrt3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 16:23:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JGNKYJ29688272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 16:23:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A57D5204F;
        Wed, 19 Aug 2020 16:23:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D6EED52051;
        Wed, 19 Aug 2020 16:23:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v9 0/2] s390: virtio: let arch validate VIRTIO features
Date:   Wed, 19 Aug 2020 18:23:16 +0200
Message-Id: <1597854198-2871-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=956 malwarescore=0 suspectscore=1 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

The goal of the series is to give a chance to the architecture
to validate VIRTIO device features.

in this respin:

The tests are back to virtio_finalize_features.

No more argument for the architecture callback which only reports
if the architecture needs guest memory access restrictions for
VIRTIO.


I renamed the callback to arch_has_restricted_virtio_memory_access,
and the config option to ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS.

Regards,
Pierre

Pierre Morel (2):
  virtio: let arch advertise guest's memory access restrictions
  s390: virtio: PV needs VIRTIO I/O device protection

 arch/s390/Kconfig             |  1 +
 arch/s390/mm/init.c           | 11 +++++++++++
 drivers/virtio/Kconfig        |  6 ++++++
 drivers/virtio/virtio.c       | 15 +++++++++++++++
 include/linux/virtio_config.h |  9 +++++++++
 5 files changed, 42 insertions(+)

-- 
2.25.1

Changelog

to v9:

- move virtio tests back to virtio_finalize_features
  (Connie)

- remove virtio device argument

to v8:

- refactoring by using an optional callback
  (Connie)

to v7:

- typo in warning message
  (Connie)
to v6:

- rewording warning messages
  (Connie, Halil)

to v5:

- return directly from S390 arch_validate_virtio_features()
  when the guest is not protected.
  (Connie)

- Somme rewording
  (Connie, Michael)

- moved back code from arch/s390/ ...kernel/uv.c to ...mm/init.c
  (Christian)

to v4:

- separate virtio and arch code
  (Pierre)

- moved code from arch/s390/mm/init.c to arch/s390/kernel/uv.c
  (as interpreted from Heiko's comment)

- moved validation inside the arch code
  (Connie)

- moved the call to arch validation before VIRTIO_F_1 test
  (Michael)

to v3:

- add warning
  (Connie, Christian)

- add comment
  (Connie)

- change hook name
  (Halil, Connie)

to v2:

- put the test in virtio_finalize_features()
  (Connie)

- put the test inside VIRTIO core
  (Jason)

- pass a virtio device as parameter
  (Halil)


