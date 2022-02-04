Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E1B4A99B2
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 14:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiBDNJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 08:09:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230425AbiBDNJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 08:09:03 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214CYH7x018087
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0d7VlbNlG/MMFQTarHCyHQ5D+YilTgK4e6mPj/9h/bI=;
 b=kdxKtXBdhC+OG2M8BcTkH9Q/OBaPUzgq1nE037kQZXuw2+/DAFKqh7EBphGtBjM8uATW
 xkHJ5H+z9p/vOiAjwrhAMIZ+HGrL3zWVjHVk8sXtZnLq2KpZc8C3jaFOclsI5/rrM0La
 McflsRWKQRwMKNCWiRXMI/Lix5yn8vwJlYiv4dvV4pFHt78w5ujYTU2KxeGj1+2/jMMT
 rjM9IbeiuJ0ht1VaPEQmukqzDt3ieu6/Npz+vPstR4WyG+Ht6MHKwmQLZr/H8Pt+9OVh
 HraODbYI8vLmVyG4n8TsjftLYInQ8OyZUEvyJutnhSiCOKL4EqfLcsIZtei5Ct/Q/g4z OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0qxfwcw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:09:02 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214D4J8I006437
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0qxfwcvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214D6mAY002424;
        Fri, 4 Feb 2022 13:09:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3e0r0n4s30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214D8um444106040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 13:08:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4E3F4C063;
        Fri,  4 Feb 2022 13:08:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F0624C040;
        Fri,  4 Feb 2022 13:08:56 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 13:08:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/6] s390x: smp: use CPU indexes instead of addresses
Date:   Fri,  4 Feb 2022 14:08:49 +0100
Message-Id: <20220204130855.39520-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wA6YoPP6FpE9UGCFN5IBdbBmiccHpgsD
X-Proofpoint-ORIG-GUID: tocWAvuAjw2X3Xgwp5BQ0D5x51wpgca7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390x there are no guarantees about the CPU addresses, except that
they shall be unique. This means that in some environments, it is
theoretically possible that there is no match between the CPU address
and its position (index) in the list of available CPUs returned by the
system. Moreover, there are no guarantees about the ordering of the
list, or even that it is consistent each time it is returned.

This series fixes a small bug in the SMP initialization code, adds a
guarantee that the boot CPU will always have index 0, changes the
existing smp_* functions to take indexes instead of addresses, and
introduces some functions to allow tests to use CPU indexes instead of
using hardcoded CPU addresses. This will allow the tests to run
successfully in more environments (e.g. z/VM, LPAR).

Some existing tests are adapted to take advantage of the new
functionalities.

v1->v2
* refactored the smp_* functions to accept indexes instead of addresses
* also fixed uv-host test

Claudio Imbrenda (6):
  lib: s390x: smp: guarantee that boot CPU has index 0
  lib: s390x: smp: refactor smp functions to accept indexes
  s390x: smp: use CPU indexes instead of addresses
  s390x: firq: use CPU indexes instead of addresses
  s390x: skrf: use CPU indexes instead of addresses
  s390x: uv-host: use CPU indexes instead of addresses

 lib/s390x/smp.h |  20 +++---
 lib/s390x/smp.c | 173 +++++++++++++++++++++++++++++-------------------
 s390x/firq.c    |  26 ++------
 s390x/skrf.c    |   2 +-
 s390x/smp.c     |  22 +++---
 s390x/uv-host.c |   4 +-
 6 files changed, 137 insertions(+), 110 deletions(-)

-- 
2.34.1

