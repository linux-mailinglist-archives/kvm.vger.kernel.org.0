Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5570242B9F
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHLOuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 10:50:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgHLOud (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 10:50:33 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CEX1Dq118605;
        Wed, 12 Aug 2020 10:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Nb7/F+qLmTp2iA3LuSjA0x4eScmWWq5g3dtL7AsyF7M=;
 b=X124SN0FxsscGSskbNNSiMl1q2E4Q1SsIrDC5TK5nbbI5RLWsasKsAD8/WB2ljA1A7xy
 flfVT/zGv9h3xarNmTyG9iqFn/IbbGMsWnBeyaoOCNO5FmJ7T8nG6kHVhxjBa703pcTR
 DO28xHwPU73HDKdt/d8Bp0SdIHQGLqsOSc47tarO7SLTRzCsbxSMoyjAdv23FHrQctWf
 LVuNJy3KPrFoP6i/Kd/U5e/NOVcddqk4AF/grZ2L0Fn1954jD1GsABT+5BrR3bi0IQvx
 d+3LeuFEK24WVWJz7IY34RK6JJnuJtSvKDGMtZmWOt81bA9ZTE6NK91F2+7IsCTKDEoF +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn91aq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 10:50:26 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CEX3YO118827;
        Wed, 12 Aug 2020 10:50:26 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn91ap4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 10:50:26 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CEnuO8008418;
        Wed, 12 Aug 2020 14:50:25 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 32skp9ab1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 14:50:25 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CEoOe649152336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 14:50:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A049A28059;
        Wed, 12 Aug 2020 14:50:24 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D6B52805C;
        Wed, 12 Aug 2020 14:50:21 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 14:50:21 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH] PCI: Identifying detached virtual functions
Date:   Wed, 12 Aug 2020 10:50:16 -0400
Message-Id: <1597243817-3468-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_06:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=789
 clxscore=1011 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 arch/s390/pci/pci.c                | 8 ++++++++
 drivers/vfio/pci/vfio_pci_config.c | 3 ++-
 include/linux/pci.h                | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
1.8.3.1

