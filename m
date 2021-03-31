Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714E34E4DB
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 11:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhC3JzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 05:55:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231622AbhC3Jyg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 05:54:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U9Z4JR115979;
        Tue, 30 Mar 2021 05:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=g8HSqJyZCcDb656OfNBVeUzttT8XC6QEH/Q3z5IjM58=;
 b=KdB+86KHMwyii5qQDRjWPXboD6GJih1lPUX5rmq7Ta7cOnOHmeFVm06fJnBtvTuR1nLy
 rRClgKJujozw5aeW6WX1BSIUQz90W6IPHG2CLha2MuKi6mlH2ME5kKbBt11BSJZy4i0S
 rvrMMn7ZS3q2mD/C71naGJ9B+fE2zNANFx9QLIe9x1eSjJG67sOJ/SL2dZudhThR9E/m
 BZBCLI2sSL8EWrRRm9wQ9IwEzvwEeib7VUHzgsNZKwPRwWb9RCyTxXIpQCXdzDJ0D0Pk
 n66OJYSzFcBN7RL+hQ4gsTviEu/fFJXhaI6XCVys5HOT19+BQBsafIJuwvQPDL7iKXZ1 bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsbkrvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 05:54:09 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12U9q2aX050971;
        Tue, 30 Mar 2021 05:54:09 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsbkrux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 05:54:08 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12U9s6i1024746;
        Tue, 30 Mar 2021 09:54:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 37huyh9cht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 09:54:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12U9s4AK27001228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 09:54:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32DBA52054;
        Tue, 30 Mar 2021 09:54:04 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.47.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 60E8E5204E;
        Tue, 30 Mar 2021 09:54:01 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: [PATCH v3 0/3] ppc: Enable 2nd DAWR support on Power10
Date:   Tue, 30 Mar 2021 15:23:47 +0530
Message-Id: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Ghyj5v7ENFLiFiBxDRHyuITamK7EuvL
X-Proofpoint-GUID: EQ1DvwLAWtzTioj6fj9Cbluu8DoakoM6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables 2nd DAWR support on p10 qemu guest. 2nd
DAWR is new watchpoint added in Power10 processor. Kernel/kvm
patches are already in[1]. Watchpoint on powerpc TCG guest is
not supported and thus 2nd DAWR is not enabled for TCG mode.

Patches apply fine on qemu/master branch (9e2e9fe3df9f).

v2: https://lore.kernel.org/r/20210329041906.213991-1-ravi.bangoria@linux.ibm.com
v2->v3:
  - Don't introduce pa_features_310[], instead, reuse pa_features_300[]
    for 3.1 guests, as there is no difference between initial values of
    them atm.
  - Call gen_spr_book3s_310_dbg() from init_proc_POWER10() instead of
    init_proc_POWER8(). Also, Don't call gen_spr_book3s_207_dbg() from
    gen_spr_book3s_310_dbg() as init_proc_POWER10() already calls it.

v1: https://lore.kernel.org/r/20200723104220.314671-1-ravi.bangoria@linux.ibm.com
[Apologies for long gap]
v1->v2:
  - Introduce machine capability cap-dawr1 to enable/disable
    the feature. By default, 2nd DAWR is OFF for guests even
    when host kvm supports it. User has to manually enable it
    with -machine cap-dawr1=on if he wishes to use it.
  - Split the header file changes into separate patch. (Sync
    headers from v5.12-rc3)

[1] https://git.kernel.org/torvalds/c/bd1de1a0e6eff

Ravi Bangoria (3):
  Linux headers: update from 5.12-rc3
  ppc: Rename current DAWR macros and variables
  ppc: Enable 2nd DAWR support on p10

 hw/ppc/spapr.c                                | 11 ++-
 hw/ppc/spapr_caps.c                           | 32 +++++++
 include/hw/ppc/spapr.h                        |  8 +-
 include/standard-headers/drm/drm_fourcc.h     | 23 ++++-
 include/standard-headers/linux/input.h        |  2 +-
 .../standard-headers/rdma/vmw_pvrdma-abi.h    |  7 ++
 linux-headers/asm-generic/unistd.h            |  4 +-
 linux-headers/asm-mips/unistd_n32.h           |  1 +
 linux-headers/asm-mips/unistd_n64.h           |  1 +
 linux-headers/asm-mips/unistd_o32.h           |  1 +
 linux-headers/asm-powerpc/kvm.h               |  2 +
 linux-headers/asm-powerpc/unistd_32.h         |  1 +
 linux-headers/asm-powerpc/unistd_64.h         |  1 +
 linux-headers/asm-s390/unistd_32.h            |  1 +
 linux-headers/asm-s390/unistd_64.h            |  1 +
 linux-headers/asm-x86/kvm.h                   |  1 +
 linux-headers/asm-x86/unistd_32.h             |  1 +
 linux-headers/asm-x86/unistd_64.h             |  1 +
 linux-headers/asm-x86/unistd_x32.h            |  1 +
 linux-headers/linux/kvm.h                     | 89 +++++++++++++++++++
 linux-headers/linux/vfio.h                    | 27 ++++++
 target/ppc/cpu.h                              |  6 +-
 target/ppc/kvm.c                              | 12 +++
 target/ppc/kvm_ppc.h                          |  7 ++
 target/ppc/translate_init.c.inc               | 19 +++-
 25 files changed, 249 insertions(+), 11 deletions(-)

-- 
2.17.1

