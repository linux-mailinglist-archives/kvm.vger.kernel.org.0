Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2095267D364
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjAZRkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjAZRkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:40:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E776D5EB;
        Thu, 26 Jan 2023 09:40:35 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QFfP0h022998;
        Thu, 26 Jan 2023 17:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4BGYm+/EmkMFk7O7ogG/O2YwU0ggtlo/0JPD7ipLbAA=;
 b=URrHZkmKDg+R3vsC0RSqVFWhfByQfqGoP6svRgleu4TjTnnjHs9lV418AQ7muYLtoV5U
 nQrjNbEJWJlw5Wp41nHQ5dIgjYCvJ+IEaB+FhYzTz+Nit59Z7kR9IkDRUoMiaC00/jIS
 iRxZg/8347VTGuUMtSN3LQjAvWno5ZO8zOuyNZqUN4lM249QqesF1PsOGW/LzIpeSerU
 +a1NwpvY7Kq0lbK2o7kD0x/rvBFuHH5PHcQ7A3Vf5/D881TLT3accM1IHWfip+PORBVs
 EqL4CJcHlrdX30wybiiTmB+tj0z3xyhPT29T8gKTrEdh70obZFw/LkFwGWnv8f4r2M2m kw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbtp46365-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 17:40:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q3rEaL027380;
        Thu, 26 Jan 2023 17:40:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n87p64ryt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 17:40:32 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30QHeSrl21561728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 17:40:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1028A20043;
        Thu, 26 Jan 2023 17:40:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC57720040;
        Thu, 26 Jan 2023 17:40:27 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Jan 2023 17:40:27 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 0/1] KVM: s390: disable migration mode when dirty tracking is disabled
Date:   Thu, 26 Jan 2023 18:40:26 +0100
Message-Id: <20230126174027.133667-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZAfSx2DQGrfD-WUK8zBraNCkIYZwkUl2
X-Proofpoint-GUID: ZAfSx2DQGrfD-WUK8zBraNCkIYZwkUl2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_07,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=565 clxscore=1015 bulkscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260169
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
---
* update docs for GET_CMMA_BITS
* restructure error handling in prepare_memslot

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

 Documentation/virt/kvm/api.rst        | 16 +++++++----
 Documentation/virt/kvm/devices/vm.rst |  4 +++
 arch/s390/kvm/kvm-s390.c              | 40 ++++++++++++++++++---------
 3 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.39.1

