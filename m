Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359687B5A3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 00:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfG3WVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 18:21:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbfG3WVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 18:21:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UMJ8Ie117994;
        Tue, 30 Jul 2019 22:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=TZxsq5+VmYFgfEpn0yWZglL3zAT3cN51mKdL+Iqh064=;
 b=JFDJMvDyCeQjUePOKPoY0O+IOtVYGZDvqw5BUNUehbyT4kNMhnu/qXhPHuIXu6XIE84h
 4F7eFltwgP5liCHiPQjiXFiKKzas86c9E1B5iB3BTDOTUEInotwzPwo+02UxcOFovzBc
 zZ/KCNem9VzhWtOK0cjkSmHv+3YUZQOSTu9RoTF1/emBgfVQpVfclcyGhwd5KhZl2GHz
 XHGDw+A3qkL+fTvN4tjKRK3UpZTzAeVUhDBeOITBbfE7kdumWluDXzPnsfNdQHHMAt4F
 Bwvksu5i7HU0vjOopU8ybmw6lODFRQMkiuTje0ouErLnrL/rtjFLadDtDmmRfipc8Nyg LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u0e1tsfdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 22:20:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UMILXk066686;
        Tue, 30 Jul 2019 22:20:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u0xv8h9ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 22:20:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6UMKfZA001436;
        Tue, 30 Jul 2019 22:20:41 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 15:20:41 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2] kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed calls
Date:   Tue, 30 Jul 2019 17:52:54 -0400
Message-Id: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=389
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=432 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300223
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch-set implements a generic wrapper for the cpuid/cpuid_index calls in
the kvm-unit-test source code. This is similar to what we have in the kernel
source code except that here we retrieve the data on the fly.
This implementation makes it convenient to define various CPUID feature bits
in one place and re-use them in places which need to check if a given CPUID
feature bit is supported by the current CPU.


[PATCH 1/2] kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed
[PATCH 2/2] kvm-unit-test: x86: Replace cpuid/cpuid_indexed calls with

 lib/x86/processor.h       | 147 +++++++++++++++++++++++++++++++++++-----------
 x86/access.c              |  13 ++--
 x86/apic.c                |   8 +--
 x86/emulator.c            |   4 +-
 x86/memory.c              |  16 ++---
 x86/pcid.c                |  10 +---
 x86/pku.c                 |   3 +-
 x86/smap.c                |   4 +-
 x86/svm.c                 |   6 +-
 x86/tsc.c                 |  16 +----
 x86/tsc_adjust.c          |   2 +-
 x86/tscdeadline_latency.c |   2 +-
 x86/umip.c                |   6 +-
 x86/vmexit.c              |   6 +-
 x86/vmx.c                 |   2 +-
 x86/vmx_tests.c           |  11 ++--
 x86/xsave.c               |  15 ++---
 17 files changed, 153 insertions(+), 118 deletions(-)

Krish Sadhukhan (2):
      x86: Implement a generic wrapper for cpuid/cpuid_indexed functions
      x86: Replace cpuid/cpuid_indexed calls with this_cpu_has()

