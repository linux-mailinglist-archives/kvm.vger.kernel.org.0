Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEF6528071
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242145AbiEPJJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241972AbiEPJJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:09:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2202322B2A;
        Mon, 16 May 2022 02:09:30 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7jQ3J019099;
        Mon, 16 May 2022 09:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pqkf+Q/C9wiBDQqRED0Z5Mk9vEXvmeMST3FtmkdvN6k=;
 b=gglne+qo2BM3ORJ0+aoXIbIC4U0eAQVyP1siSajkwhfg0/vKI7Jc0DImO+Dw+z8ZHP44
 4PKaFWax/L5fTR22pBxtfMMOKwvv5Cx9jE71wqDrm89vNNR0Aj8f9huA0Ci64V2wAHMa
 e7FIcDpc9CMf2ydJKNXzTZ2ekkqMl8WonXmFIIjnFRGL9Lax7VvsmP5yFaufy35Bczu1
 z+oAol/8/qLGAp21SHyjih0mIiTBDtl+Wdv/wPLkrTj0CWFTGJW6E7HtKgCRtd8hxKFx
 T6MQFbmv506BllrE4y0atAFn+SpINe6ImKAkyXDE7K+EG147hvBOrJmhUTMciI3gZf/Q AA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgm1jgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G99Rha009799;
        Mon, 16 May 2022 09:09:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429abst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G8tbOP43909414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 08:55:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 609C14203F;
        Mon, 16 May 2022 09:09:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7C6242045;
        Mon, 16 May 2022 09:09:23 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:09:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v5 00/10] kvm: s390: Add PV dump support
Date:   Mon, 16 May 2022 09:08:07 +0000
Message-Id: <20220516090817.1110090-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OHB8P822Ue_HJr-m4Um05vY3P_pkuKBh
X-Proofpoint-ORIG-GUID: OHB8P822Ue_HJr-m4Um05vY3P_pkuKBh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_05,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 spamscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=867 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160049
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

v3:
	* Added Rev-by
	* Renamed the query function's len variables to len_min

v2:
	* Added vcpu SIE blocking to avoid validities
	* Moved the KVM CAP to patch #7
	* Renamed len to len_max and introduced len_written for extendability
	* Added Rev-bys


Janosch Frank (10):
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

 Documentation/virt/kvm/api.rst               | 153 +++++++++-
 Documentation/virt/kvm/s390/index.rst        |   1 +
 Documentation/virt/kvm/s390/s390-pv-dump.rst |  64 ++++
 arch/s390/boot/uv.c                          |   4 +
 arch/s390/include/asm/kvm_host.h             |   1 +
 arch/s390/include/asm/uv.h                   |  45 ++-
 arch/s390/kernel/uv.c                        |  53 ++++
 arch/s390/kvm/kvm-s390.c                     | 306 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                     |   3 +
 arch/s390/kvm/pv.c                           | 129 ++++++++
 include/uapi/linux/kvm.h                     |  55 ++++
 11 files changed, 811 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst

-- 
2.34.1

