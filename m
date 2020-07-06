Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C11215C17
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgGFQnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 12:43:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729386AbgGFQna (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 12:43:30 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066GY9BB150928
        for <kvm@vger.kernel.org>; Mon, 6 Jul 2020 12:43:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322n2rjr86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 12:43:30 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066GYO0B152299
        for <kvm@vger.kernel.org>; Mon, 6 Jul 2020 12:43:30 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322n2rjr72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 12:43:29 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066GQEDM009876;
        Mon, 6 Jul 2020 16:43:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 322hd8191y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 16:43:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066GhP8W45154366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 16:43:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECA5611C05B;
        Mon,  6 Jul 2020 16:43:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DA3A11C054;
        Mon,  6 Jul 2020 16:43:24 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jul 2020 16:43:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/4] More lib/alloc cleanup and a minor improvement
Date:   Mon,  6 Jul 2020 18:43:20 +0200
Message-Id: <20200706164324.81123-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_15:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501
 cotscore=-2147483648 impostorscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=975 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some more cleanup of lib/alloc in light of upcoming changes

The first real feature: allow aligned virtual allocations with
alignment greater than one page.

Also export a function for allocating aligned non-backed virtual pages.

v1->v2
* rename helper function to alloc_vpages_aligned, call it directly
* alloc_vpages_aligned now expects a page order as alignment

Claudio Imbrenda (4):
  lib/vmalloc: fix pages count local variable to be size_t
  lib/alloc_page: change some parameter types
  lib/alloc_page: move get_order and is_power_of_2 to a bitops.h
  lib/vmalloc: allow vm_memalign with alignment > PAGE_SIZE

 lib/alloc_page.h |  7 +++----
 lib/bitops.h     | 10 ++++++++++
 lib/libcflat.h   |  5 -----
 lib/vmalloc.h    |  3 +++
 lib/alloc.c      |  1 +
 lib/alloc_page.c | 13 ++++---------
 lib/vmalloc.c    | 37 ++++++++++++++++++++++++++++---------
 7 files changed, 49 insertions(+), 27 deletions(-)

-- 
2.26.2

