Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F351E52A824
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbiEQQg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350993AbiEQQgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:36:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE9C2C645;
        Tue, 17 May 2022 09:36:52 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGRTlM026260;
        Tue, 17 May 2022 16:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mgPmEsBUGhU9QkJvdeEOOYZ0GsH9wvBhmBczMZ9Kpbc=;
 b=MKMyKZx+rWAfNDxbE6cU6JP94eX4v8ravTVCPoqdHgmM9cNp+ef7ekyIqM01GxNImr6K
 osBOBnIOSNDTosUtsJGbxhO7OjTmiEZG4sAY79DbMG6oBldOP7IPcW3rFBLWwwwZdC9k
 sX4DEjaef7GFRcJS808PrSo5B1F8cfTyadR5bENUzO9qdPPV2xb1Cv8oRxVnxYXdgEGY
 Kk3h2P3aXE9uCFPn+VUxtpRyKL/3MRuaVxVf3qz9npU1wjXzXhNXcdQuh/av5zis2+ie
 akCIiiQaSmOZUKsjR81GqRZs1Nu1EsOL5rs8TSH/r8cnSFv3CRD0Ae+nkwRiD4TQ31aA hw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f8807kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGYWl2003977;
        Tue, 17 May 2022 16:36:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429ch89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGakMf49348990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:36:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB4AC11C052;
        Tue, 17 May 2022 16:36:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E54A11C04C;
        Tue, 17 May 2022 16:36:46 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 00/11] kvm: s390: Add PV dump support
Date:   Tue, 17 May 2022 16:36:18 +0000
Message-Id: <20220517163629.3443-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oFUgFHp6ma-4AR4nzVPQXbCzTO-ApPzr
X-Proofpoint-ORIG-GUID: oFUgFHp6ma-4AR4nzVPQXbCzTO-ApPzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=869 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes dumping inside of a VM fails, is unavailable or doesn't
yield the required data. For these occasions we dump the VM from the
outside, writing memory and cpu data to a file.

Up to now PV guests only supported dumping from the inside of the
guest through dumpers like KDUMP. A PV guest can be dumped from the
hypervisor but the data will be stale and / or encrypted.

To get the actual state of the PV VM we need the help of the
Ultravisor who safeguards the VM state. New UV calls have been added
to initialize the dump, dump storage state data, dump cpu data and
complete the dump process.

I chose not to document the dump data provided by the Ultravisor since
KVM doesn't interprete it in any way. We're currently searching for a
location and enough cycles to make it available to all.

v6:
	* Added patch that explains KVM's rc/rrc writes
	* Added rev-bys
	* Improved documentation
	* Reworked capability indication
	* Moved the dump completion into a new function

v5:
	* v4 went out without a version
	* Fixed spelling mistake in query
	* Improved the storage state dump code
	* Switched to the scheduling uv call for all dump commands
	* Fixed the documentation formatting
	* Moved the capability into its own patch it shouldn't be part of patch #6

v4:
	* Rebased and fixed up conflicts due to the Documentation
          changes and new KVM capabilities
	* Fixed the dump facility check, now we check for all 4 calls


Janosch Frank (11):
  s390x: Add SE hdr query information
  s390: uv: Add dump fields to query
  KVM: s390: pv: Add query interface
  KVM: s390: pv: Add dump support definitions
  KVM: s390: pv: Add query dump information
  kvm: s390: Add configuration dump functionality
  kvm: s390: Add CPU dump functionality
  kvm: s390: Add KVM_CAP_S390_PROTECTED_DUMP
  Documentation: virt: Protected virtual machine dumps
  Documentation/virt/kvm/api.rst: Add protvirt dump/info api
    descriptions
  Documentation/virt/kvm/api.rst: Explain rc/rrc delivery

 Documentation/virt/kvm/api.rst               | 163 ++++++++++-
 Documentation/virt/kvm/s390/index.rst        |   1 +
 Documentation/virt/kvm/s390/s390-pv-dump.rst |  64 +++++
 arch/s390/boot/uv.c                          |   4 +
 arch/s390/include/asm/kvm_host.h             |   1 +
 arch/s390/include/asm/uv.h                   |  45 +++-
 arch/s390/kernel/uv.c                        |  53 ++++
 arch/s390/kvm/kvm-s390.c                     | 269 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                     |   5 +
 arch/s390/kvm/pv.c                           | 199 ++++++++++++++
 include/uapi/linux/kvm.h                     |  55 ++++
 11 files changed, 856 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst

-- 
2.34.1

