Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3B243CB1
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 17:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHMPk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 11:40:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726131AbgHMPk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 11:40:58 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DFVrD8134486;
        Thu, 13 Aug 2020 11:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Dvgq+CZDKhUP01c00QbT4Vc/o4cdqzwBrzo+M+z0pfs=;
 b=MXl677QCSmPqHzfhKEUjnIKgCnDjglOFx/8nrLck4kGTCBE9NRFKwLhsbganywtycp8w
 v6/06HWYqE8pipQbHqwcQJpnUnYEHpMUjgBw+axmjwhoWhuPg/euufttbSqIqvnS0GZh
 FPvqGWiB5LSoZ40uW4AZRfg9TeHvv6PR/dG+C7aZiZnHSefE9hm7vbFOrKp28ebfIn08
 7+DpU5R0Iter99hTVmriBn1li9Kwk6usXqe5HMZEoqop8CJUVW3IaD9WqEA84uHQ4dky
 aYXPzA/7/5+Ngv5TqkS8mQtbhmZuYi/2wklPez3goZncYbu8/f2rsucrVel/ATqbVpXx Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w706366d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 11:40:51 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DFVxmQ135117;
        Thu, 13 Aug 2020 11:40:50 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w706365v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 11:40:50 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DFLCHB002809;
        Thu, 13 Aug 2020 15:40:50 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 32skp9nx30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 15:40:50 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DFenh651773752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 15:40:49 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BA04AE063;
        Thu, 13 Aug 2020 15:40:49 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6DA1AE066;
        Thu, 13 Aug 2020 15:40:46 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 15:40:46 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3] PCI: Identifying detached virtual functions
Date:   Thu, 13 Aug 2020 11:40:42 -0400
Message-Id: <1597333243-29483-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_14:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes for v3:
- Moved detached_vf setting to pcibios_bus_add_device
- Extended the change in vfio_config_init to be generic (include 
  vendor / device ID / INTx emulation)
- Added a dev_is_vf macro in the same style as dev_is_pf to
  encapsualate the checking of is_virtfn || detached_vf

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

 arch/s390/pci/pci_bus.c            | 13 +++++++++++++
 drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
 include/linux/pci.h                |  4 ++++
 3 files changed, 21 insertions(+), 4 deletions(-)

-- 
1.8.3.1

