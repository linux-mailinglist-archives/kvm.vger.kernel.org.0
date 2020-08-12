Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC18242F12
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 21:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHLTV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 15:21:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726512AbgHLTVZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 15:21:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CJ58vd101214;
        Wed, 12 Aug 2020 15:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=CHSXnYQWMFZcz1RKn84neMS6ZuPvr0AKPxkNnK1oAJQ=;
 b=i+ucGRBuqc+BfrIjdJfyFAHKleXUsZNwCEnU48LD8d14rLSek0oAWWNywpTdxsGPXmLt
 pgkEfqCORS3luNbeLOH22kkOgMblGUIH6yw7IowR0PvmF3rQdzgZn52EdBIWozIKcj/0
 zFGirlYmGP+AQOY/bHTD6a7ySw6OuXDG4xJrLFhIMb7xHVd08yKID6bZEPoOEB+XnJx6
 M4RKQySwLKyCuK8oXJF6yxeYfboUp2NLYjeBwlNPwqWk6PKsqi8RDUfDIt5ti8ngGxVh
 k6J+zQs9Bm08oEN5nFWzXQNy+L8FOcCUOsJ/8h3zJuKFv+DjxiHLcu5fsnyxt6Bp+kOU Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7v0fmpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 15:21:18 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CJB5VS115073;
        Wed, 12 Aug 2020 15:21:18 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7v0fmp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 15:21:18 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CJ58qJ020922;
        Wed, 12 Aug 2020 19:21:17 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 32skp9d14x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 19:21:17 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CJLB4137880176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:21:11 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 577066A04D;
        Wed, 12 Aug 2020 19:21:15 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 607906A051;
        Wed, 12 Aug 2020 19:21:14 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 19:21:14 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2] PCI: Identifying detached virtual functions
Date:   Wed, 12 Aug 2020 15:21:10 -0400
Message-Id: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_15:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=866
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes for v2:
- Added code to vfio_basic_config_read() and vfio_config_init() to
  extend emulation to userspace
- Added detached_vf check to vfio_bar_restore()
- @Niklas/@Pierre, I removed your review tags since I made changes,
  please have another look


As discussed previously in a qemu-devel thread:

https://www.mail-archive.com/qemu-devel@nongnu.org/msg725141.html

s390x has the notion of unlinked VFs being available at the LPAR-level
(Virtual Functions where the kernel does not have access to the associated
Physical Function).  These devices are currently not marked as is_virtfn.
There seems to be some precedent (ex: in powerpc, eeh_debugfs_break_device())
where pdev->is_virtfn && pdev->physfn == 0 is used to detect these sort of
detached VFs.  We toyed with the idea of doing this but it causes additional
fallout as various other areas of kernel code have an expectation that
is_virtfn=1 implies there is a linked PF available to the kernel. 

In the s390x case, the firmware layer underneath handles the VF emulation
as it still has access to the PF that the LPAR (and thus the kernel) cannot
see.  But one thing this firmware layer does not do is emulate the
PCI_COMMAND_MEMORY bit, which was OK until vfio-pci started enforcing it
via abafbc55.  The vfio-pci check is waived for VFs as of ebfa440c, but
vfio-pci can't actually tell that these particular devices are VFs.

The proposed patch attempts to identify these detached VFs and subsequently
provide this information to vfio-pci so that it knows to also accept the
lack of PCI_COMMAND_MEMORY for these sorts of devices.  For now the bit is
only set for s390x but other architectures could opt in to it as well if
needed.



Matthew Rosato (1):
  PCI: Introduce flag for detached virtual functions

 arch/s390/pci/pci.c                |  8 ++++++++
 drivers/vfio/pci/vfio_pci_config.c | 11 +++++++----
 include/linux/pci.h                |  1 +
 3 files changed, 16 insertions(+), 4 deletions(-)

-- 
1.8.3.1

