Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC45265042
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 22:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgIJUIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 16:08:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730859AbgIJPAn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 11:00:43 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AEi4YI192630;
        Thu, 10 Sep 2020 11:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=5VXKsHTc2YlCV3PXBFCbmF1hTMHTSBXPxb9CKodxcuc=;
 b=lJm0/tYKVnLWLps2+W6cAz1a9vrIWBEiP+kwk1q2U+Ibr3tK9hHfmZoMaZ7sHL4AOzFG
 U8MF73hxTxtHjYbp0vBLEb92NkHzmKnOhS/u21GYrVf3OdLrsa7h7TQHZKyALnhekAjo
 nKXwusdMDgbyylGqJ1WSDugrkjpm2fcrQ+t0h8aSm/92l+ZV3JK/cliqzGPxJ4jZlzMZ
 da2I0XmeJAYCxvHw+l7r2ceDyk78W3+gRRTLx1nHTrEG94Euogl/XhE/by94e7BT5SNn
 48fbqOVVb7A3D2xgiKi3CzcaUtJ8k2udWAmivgmg0FDa3PkDt/Z/Kpfc5gNYS1a2gcgF zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fnyv0wgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:00:07 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AEq17J025485;
        Thu, 10 Sep 2020 11:00:07 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fnyv0wew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:00:06 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AEqMb2000343;
        Thu, 10 Sep 2020 15:00:06 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 33c2a9jbjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 15:00:05 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AF00At32702764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 15:00:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 984DF7806E;
        Thu, 10 Sep 2020 15:00:02 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0909778064;
        Thu, 10 Sep 2020 15:00:00 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 15:00:00 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v5 0/3] vfio/pci: Restore MMIO access for s390 detached VFs
Date:   Thu, 10 Sep 2020 10:59:54 -0400
Message-Id: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_03:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 mlxlogscore=864 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes from v4:
- Switch from dev_flags to a bitfield
- Scrubbed improper use of MSE acronym
- Restored the fixes tag to patch 3 (but the other 2 patches are
  now pre-reqs -- cc stable 5.8?) 

Since commit abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO
access on disabled memory") VFIO now rejects guest MMIO access when the
PCI_COMMAND_MEMORY bit is OFF.  This is however not the case for VFs
(fixed in commit ebfa440ce38b ("vfio/pci: Fix SR-IOV VF handling with
MMIO blocking")).  Furthermore, on s390 where we always run with at
least a bare-metal hypervisor (LPAR) PCI_COMMAND_MEMORY, unlike Device/
Vendor IDs and BARs, is not emulated when VFs are passed-through to the
OS independently.

Based upon Bjorn's most recent comment [1], I investigated the notion of
setting is_virtfn=1 for VFs passed-through to Linux and not linked to a
parent PF (referred to as a 'detached VF' in my prior post).  However,
we rapidly run into issues on how to treat an is_virtfn device with no
linked PF. Further complicating the issue is when you consider the guest
kernel has a passed-through VF but has CONFIG_PCI_IOV=n as in many 
locations is_virtfn checking is ifdef'd out altogether and the device is
assumed to be an independent PCI function.

The decision made by VFIO whether to require or emulate a PCI feature 
(in this case PCI_COMMAND_MEMORY) is based upon the knowledge it has 
about the device, including implicit expectations of what/is not
emulated below VFIO. (ex: is it safe to read vendor/id from config
space?) -- Our firmware layer attempts similar behavior by emulating
things such as vendor/id/BAR access - without these an unlinked VF would
not be usable. But what is or is not emulated by the layer below may be
different based upon which entity is providing the emulation (vfio,
LPAR, some other hypervisor)

So, the proposal here aims to fix the immediate issue of s390
pass-through VFs becoming suddenly unusable by vfio by using a new 
bit to identify a VF feature that we know is hardwired to 0 for any
VF (PCI_COMMAND_MEMORY) and de-coupling the need for emulating
PCI_COMMAND_MEMORY from the is_virtfn flag. The exact scope of is_virtfn
and physfn for bare-metal vs guest scenarios and identifying what
features are / are not emulated by the lower-level hypervisors is a much
bigger discussion independent of this limited proposal.

[1]: https://marc.info/?l=linux-pci&m=159856041930022&w=2



Matthew Rosato (3):
  PCI/IOV: Mark VFs as not implementing PCI_COMMAND_MEMORY
  s390/pci: Mark all VFs as not implementing PCI_COMMAND_MEMORY
  vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn

 arch/s390/pci/pci_bus.c            |  5 +++--
 drivers/pci/iov.c                  |  1 +
 drivers/vfio/pci/vfio_pci_config.c | 24 ++++++++++++++----------
 include/linux/pci.h                |  1 +
 4 files changed, 19 insertions(+), 12 deletions(-)

-- 
1.8.3.1

