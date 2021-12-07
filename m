Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00946C02E
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbhLGQFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238770AbhLGQFd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:33 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FmJZp004610;
        Tue, 7 Dec 2021 16:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Bbn7eq9aN6lyo+pJKLyzdDZEzdov6fujey+OqEpeewk=;
 b=VNWoBKrETah4mIlexRikvGt9RoaOcf7qJMLyI2Bb6cjz6hVvGxMohQdaEYJ/CUE9B/OO
 PLDF/6u30bxKNC54X9Wx4PIc1c7kzDPJByulzRtQ0Z0HgmVaXnQTl/6vv6WMMD7RnoMx
 +IK9w0e7j3+R3N8Byzn3c4CK34bZ722aWVXh1IszUWPJAcXIU4NxZyL4W4bwE5OLaWoM
 FBZ7rx2KT2utdTCjxVrHQjcCUxnzK+xMuxyBvHfkdD+LA/Yha/qSchymhNa1nH/7rzuG
 Vgm9qetxmbde6hFl8VGlWCdf+BDmorJEbvRReIw4l4U0sDPW6JWSaLeflQ5PJpY7ye4s bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajy095p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:03 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7FpsqH017316;
        Tue, 7 Dec 2021 16:02:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajy094j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Frn5u031715;
        Tue, 7 Dec 2021 16:02:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3cqyy9eys9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G1vU626477052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:01:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1DC74C046;
        Tue,  7 Dec 2021 16:01:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B56554C04A;
        Tue,  7 Dec 2021 16:01:55 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:01:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 00/10] s390x: sie: Add PV snippet support
Date:   Tue,  7 Dec 2021 15:59:55 +0000
Message-Id: <20211207160005.1586-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jzjk-udpBieXSe4EVWp8MlV4KlS3iAby
X-Proofpoint-GUID: m01x0RWMim2kv-B9zrKB3UpaYlRFx7VD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding PV virtualization support was only a matter of time so here it
is.

The biggest problem that needed solving was having the SE header as a
separate file. The genprotimg tool generates the header and adds a
short bit of code to the image which will put the guest into PV mode
via the diagnose 308 PV subcodes. We don't have and want an emulation
for the diagnose so we don't support this way of starting a PV guest.

Therefore we needed a new tool that generates the PV image separate
from the SE header so we can link both as binary blobs. Marc created
this tool by writing a library which lets users create a SE header and
has bindings to multiple languages. Unfortunately we didn't yet have
time to upstream this but we plan to publish it once we find some.

The first PV snippet test checks the "easy" diagnose calls 0x44, 0x9c,
0x288 and 0x500. We check register contents and responses to PGM
injects.

v2:
	- Moved snippet management code into library uv.h and snippet.h files
	- Added a fixpatch for mvpg-sie.c making it use the snippet helpers

Janosch Frank (10):
  lib: s390x: sie: Add sca allocation and freeing
  s390x: sie: Add PV fields to SIE control block
  s390x: sie: Add UV information into VM struct
  s390x: uv: Add more UV call functions
  s390x: lib: Extend UV library with PV guest management
  lib: s390: sie: Add PV guest register handling
  s390x: snippets: Add PV support
  lib: s390x: Introduce snippet helpers
  s390x: mvpg-sie: Use snippet helpers
  s390x: sie: Add PV diag test

 .gitignore                                 |   2 +
 configure                                  |   8 +
 lib/s390x/asm/uv.h                         |  99 +++++++++++
 lib/s390x/sie.c                            |  20 +++
 lib/s390x/sie.h                            |  54 +++++-
 lib/s390x/snippet.h                        | 110 ++++++++++++
 lib/s390x/uv.c                             | 128 ++++++++++++++
 lib/s390x/uv.h                             |  28 +++
 s390x/Makefile                             |  73 ++++++--
 s390x/mvpg-sie.c                           |  24 +--
 s390x/pv-diags.c                           | 187 +++++++++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S   |  25 +++
 s390x/snippets/asm/snippet-pv-diag-500.S   |  39 +++++
 s390x/snippets/asm/snippet-pv-diag-yield.S |   7 +
 14 files changed, 770 insertions(+), 34 deletions(-)
 create mode 100644 s390x/pv-diags.c
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-288.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-500.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-yield.S

-- 
2.32.0

