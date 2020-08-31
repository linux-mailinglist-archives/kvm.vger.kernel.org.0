Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE1A2578ED
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgHaMFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:05:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgHaMFl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 08:05:41 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VC2aan026056;
        Mon, 31 Aug 2020 08:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=4If8ZgKPJFBluX6ZF0t25L6SeQXRx/kll/QQACySqwE=;
 b=JZ/hnNYjVtZX7wTDTClcNmzD6DoIihYGzodZcIZZwcGsRzV95/GOGtDMeyXUYRbtgBf/
 ivh5wjkNWkt6rfvBrN3pMGVBXVW0ykIF8mDRbTlLDEsEWz4ZUdTMZOFucufJ8dl7OTx7
 8n1ENTZMaOBFNTtsbEFqmzxcXYfcBseLaM99TDtSSYHRPqkuOxHlDjAJZN2Y1KYwiYfm
 s9BsABKeP+4H7GnfHDbx71pUCrizbKmNbXLtOhf7iH6KvBuymU+OFH2frFMa+asyJW+x
 UXLlRXz868pzefi5O5Lh0LIpRyhsGVq37DgAj68P6lOCog9YXuNOaooiE/bL6HgBDXYu Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3390txg47b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 08:05:39 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07VC5NM4033284;
        Mon, 31 Aug 2020 08:05:39 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3390txg46k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 08:05:39 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VBvYgG017549;
        Mon, 31 Aug 2020 12:05:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 337en8246k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 12:05:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VC43T358589658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 12:04:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D36E8A4054;
        Mon, 31 Aug 2020 12:05:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EBDDA405C;
        Mon, 31 Aug 2020 12:05:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.160.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 12:05:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [PATCH v1 0/3] s390x: css: adapting the I/O tests for PV
Date:   Mon, 31 Aug 2020 14:05:30 +0200
Message-Id: <1598875533-19947-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_04:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=3
 bulkscore=0 phishscore=0 mlxlogscore=873 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To adapt the test for PV we need to share the I/O memory with the host.

To do so we:
- implement the share/unshare ultravisor code.
- implement dedicated allocation routine which make sure that
  - the I/O memory is on dedicated pages
  - the I/O memory is shared if the guest is run under PV
- replace the start_single_ccw() by ccw_alloc() and start the
  start_ccw1_chain() directly from the test function.
  This allows to correctly free the I/O memory after the interruption.

Best regards,
Pierre

Pierre Morel (3):
  s390x: pv: implement routine to share/unshare memory
  s390: define UV compatible I/O allocation
  s390x: css: pv: css test adaptation for PV

 lib/s390x/asm/uv.h    | 33 +++++++++++++++++++++++++++
 lib/s390x/css.h       |  3 +--
 lib/s390x/css_lib.c   | 28 +++++++----------------
 lib/s390x/malloc_io.c | 53 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 14 ++++++++++++
 s390x/Makefile        |  1 +
 s390x/css.c           | 35 +++++++++++++++++++---------
 7 files changed, 134 insertions(+), 33 deletions(-)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

-- 
2.25.1

