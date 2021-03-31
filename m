Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BD73446AA
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 15:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCVOGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 10:06:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhCVOGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 10:06:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ME3J3i036725;
        Mon, 22 Mar 2021 10:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pnANhrdarCwpxEDW4R3cclyoLFe42MpHeORvJNjndw4=;
 b=b2brCyiOCVgd9E4AVSWlcHV793fsQ5cbC3cZfXLRUihclpW2p44ylChmVxm6aiizUnhR
 QPFXynML482QmRw+eZ3nMbD6vHmYkfH03xmeOGsThDWn3pZKT8C/lvHwcMkcYejg6gO1
 1mgAgWM01Ot3z9VUTI0zx17m6vTrwCXEwPFOTkuP0mNCu2bBbBZfKP+2HRjACIFccRt1
 NZ8S85BpYjfzF1Fs/vl85Y9td4Bm76SYsZf4TYnpyZ+60eSrQfoJYs39SplS/Jn7+bK3
 qqv1PHjweXLuWDao72VVBOz6ZPdrrDuKHfUXamlMz+lNkGsEaXVWv5zqBMv/IWNCn/1h Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37e03f0jbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 10:06:12 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ME3cwT038627;
        Mon, 22 Mar 2021 10:06:12 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37e03f0j81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 10:06:11 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ME2V0b004761;
        Mon, 22 Mar 2021 14:06:03 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 37d9by987f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 14:06:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ME60q641419176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:06:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 489CB4C04A;
        Mon, 22 Mar 2021 14:06:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7F6D4C050;
        Mon, 22 Mar 2021 14:05:59 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Mar 2021 14:05:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/2] s390/kvm: VSIE: fix prefixing and MSO for MVPG
Date:   Mon, 22 Mar 2021 15:05:57 +0100
Message-Id: <20210322140559.500716-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_07:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest real address needs to pass through prefixing in order to yield
the absolute address.

The absolute address needs to be offset by the MSO in order to get the
host virtual address.

v1->v2
* use the MSO from the shadow SIE page instead of the original one
* reuse src and dest variabled to improve readability

Claudio Imbrenda (2):
  s390/kvm: split kvm_s390_real_to_abs
  s390/kvm: VSIE: fix MVPG handling for prefixing and MSO

 arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
 arch/s390/kvm/vsie.c    |  6 +++++-
 2 files changed, 22 insertions(+), 7 deletions(-)

-- 
2.26.2

