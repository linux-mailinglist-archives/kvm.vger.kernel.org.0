Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9C92F47CA
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbhAMJmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727031AbhAMJmW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:22 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XJJG104537;
        Wed, 13 Jan 2021 04:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UTfW3PlUMvoIPLcnrnxvCiTxzoOlfX2GKTSBqN47GP0=;
 b=fwnzJ1/L8V896/M+qNe5t2iUy86rMlTAWV6Geea4DLlsWZk5935J1JzNu3v7cjGLtJPY
 +Y7ncsgBogJrFhoQag+qL74NpxcNMfuVB3roS91jkEDphf5r9+VTj0bFCpOsf1LiF03j
 WjE+RbYQmu5IIwUDWw2c/n5dIKvCxN3Bo0dFrNHj1vmop5h5IOZAJyexztYV6NM0crxk
 cAbmLvxuIIlkgK4vhLxE9THnwj+Y/zLxSgAbqTP9vHiU2srXJatIkIJS7fm5OeRL7c8w
 JAMA6KpHUc1OdDsemYt7ypZrPjkExa1RvadNY9XRFWXQwPaqj8OQuMNCXkTFZe2G/Gdt Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361wbnt2ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9cimc126906;
        Wed, 13 Jan 2021 04:41:40 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361wbnt2a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:40 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SL3a022707;
        Wed, 13 Jan 2021 09:41:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35y448ag56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fZOV31654144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FEA8A4040;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DEA1A404D;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 00/14] KVM: s390: Add huge page VSIE support
Date:   Wed, 13 Jan 2021 09:40:59 +0000
Message-Id: <20210113094113.133668-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we finally want to get rid of the nested and hpage s390 KVM module
parameters let's try again to integrate huge page VSIE support.

The following patches have been rebased on 5.11-rc3 and enable us to
start huge page and normal page VSIE guest 3s in a huge page guest 2.

Branch:
https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git/log/?h=hlp_vsie


Problems that need to be solved:
	* The VSIE guests crash on migration...
	* I have lost most of my knowledge about this topic and I'm
          currently paging back in
	* Lots of testing


Janosch Frank (14):
  s390/mm: Code cleanups
  s390/mm: Improve locking for huge page backings
  s390/mm: Take locking out of gmap_protect_pte
  s390/mm: split huge pages in GMAP when protecting
  s390/mm: Split huge pages when migrating
  s390/mm: Provide vmaddr to pmd notification
  s390/mm: factor out idte global flush into gmap_idte_global
  s390/mm: Make gmap_read_table EDAT1 compatible
  s390/mm: Make gmap_protect_rmap EDAT1 compatible
  s390/mm: Add simple ptep shadow function
  s390/mm: Add gmap shadowing for large pmds
  s390/mm: Add gmap lock classes
  s390/mm: Pull pmd invalid check in gmap_pmd_op_walk
  KVM: s390: Allow the VSIE to be used with huge pages

 Documentation/virt/kvm/api.rst  |   9 +-
 arch/s390/include/asm/gmap.h    |  31 +-
 arch/s390/include/asm/pgtable.h |   5 +
 arch/s390/kvm/gaccess.c         |  52 +-
 arch/s390/kvm/kvm-s390.c        |  14 +-
 arch/s390/mm/gmap.c             | 917 ++++++++++++++++++++++++--------
 arch/s390/mm/pgtable.c          |  61 ++-
 7 files changed, 819 insertions(+), 270 deletions(-)

-- 
2.27.0

