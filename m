Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF23767C797
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 10:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbjAZJkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 04:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjAZJjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 04:39:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CC45CFEA;
        Thu, 26 Jan 2023 01:39:50 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q8dEg3003633;
        Thu, 26 Jan 2023 09:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vlzp8Hgx+CZwAI9kF9gEpZfUFmXyzQCicYbF3bl6Xbk=;
 b=qlsgw4CeCu0JK2g5qfCgrwFL8nawBy7QZUU1ubAqT56yT4EMspr2GOLAuA4xxlrOc9g2
 fireK6FV4i772rbMPAghFAL3yWXQttL14l4X22OgpjNeetJVXrZcuBovFTENfgZQpLUu
 lzqYRO/7kzcpdoKgNobfzcDJ6F5i/qAImt5IXvW7dZ21uZq6xxkxP9raP1wZn5gMZysy
 Ux55inqn5GQ0HB8MWBecWIhXCATp6NxWedk43sI4i6d0mtgMOCAjwEn2wQzHvysQX2bT
 olYefWSO7GhawjnQD0VDwzWM16DAPtiOY9DfphiZAAoIn+BM0zL/ooaxjnWkyppFltJF fw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbktwv3jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 09:39:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30PGAXkK010401;
        Thu, 26 Jan 2023 09:39:48 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n87p6p6ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 09:39:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30Q9diIr40239496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 09:39:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2492A2004B;
        Thu, 26 Jan 2023 09:39:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8AB220043;
        Thu, 26 Jan 2023 09:39:43 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Jan 2023 09:39:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/1] KVM: s390: disable migration mode when dirty tracking is disabled
Date:   Thu, 26 Jan 2023 10:39:42 +0100
Message-Id: <20230126093943.608468-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C8dkkLj-esFQ03xpTNyMwsZZibr9HoRT
X-Proofpoint-ORIG-GUID: C8dkkLj-esFQ03xpTNyMwsZZibr9HoRT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_03,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=651 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
---
* pr_warn -> WARN_ONCE
* comment style

Migration mode is a VM attribute which enables tracking of changes in
storage attributes (PGSTE). It assumes dirty tracking is enabled on all
memslots to keep a dirty bitmap of pages with changed storage attributes.

When enabling migration mode, we currently check that dirty tracking is
enabled for all memslots. However, userspace can disable dirty tracking
without disabling migration mode.

Since migration mode is pointless with dirty tracking disabled, disable
migration mode whenever userspace disables dirty tracking on any slot.

Also update the documentation to clarify that dirty tracking must be
enabled when enabling migration mode, which is already enforced by the
code in kvm_s390_vm_start_migration().

To disable migration mode, slots_lock should be held, which is taken
in kvm_set_memory_region() and thus held in
kvm_arch_prepare_memory_region().

Restructure the prepare code a bit so all the sanity checking is done
before disabling migration mode. This ensures migration mode isn't
disabled when some sanity check fails.


Nico Boehr (1):
  KVM: s390: disable migration mode when dirty tracking is disabled

 Documentation/virt/kvm/devices/vm.rst |  4 +++
 arch/s390/kvm/kvm-s390.c              | 38 ++++++++++++++++++---------
 2 files changed, 29 insertions(+), 13 deletions(-)

-- 
2.39.1

