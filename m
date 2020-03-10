Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E60A180C61
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 00:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgCJX3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 19:29:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCJX3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 19:29:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ANScAr188171;
        Tue, 10 Mar 2020 23:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=oA5hD/B94mzTT7EGD/Z+5fNdvb48AJjrLpTzm01JLHc=;
 b=UVhcl4/fYzH93Suhv8evdoeg+cnyVMPue5iko8//9yXmlkjYpjD8bMBLI4fXyx+rr9T0
 a0FBAfDWTATrxOAhuMZVBKwIqdZvVomhcpKo8DcIRO4zZXSlDZ+JkqwDrozH7PUE5fiH
 k3bRKjaAV0fsYpNRqwjDL71/usIVaLqF6kYCA6x0B+4stgEAJxlatjuZbEt4jbFX1gbR
 GvN4bE5LMDPuTHJONQQhK2pDeozpfZgZ7jebxLbDkNOW0eNEURXa20ZRY0VT8pnZzgnw
 8jsnEWncUs7w9wGJUlK73RudDOFbBz3Pk1m1bx8UNO1nAJXMMJKms7Daf6TJfjP9RUUI gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31ughcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 23:29:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ANT0NH071921;
        Tue, 10 Mar 2020 23:29:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8nwk188-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 23:29:26 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02ANTP78004785;
        Tue, 10 Mar 2020 23:29:25 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 16:29:25 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address fields of Guest Segment registers
Date:   Tue, 10 Mar 2020 18:51:48 -0400
Message-Id: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=13 mlxlogscore=846
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=13
 phishscore=0 mlxlogscore=916 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even thought today's x86 hardware uses paging and not segmentation for memory
management, it is still good to have some tests that can verify the sanity of
the segment register fields on vmentry of nested guests.

The test on SS Selector field is failing because the hardware (I am using
Intel Xeon Platinum 8167M 2.00GHz) doesn't raise any error even if the
prescribed bit pattern is not set and as a result vmentry succeeds.


[PATCH] kvm-unit-test: nVMX: Test Selector and Base Address fields of Guest Segment

 lib/x86/processor.h |   1 +
 x86/vmx_tests.c     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test Selector and Base Address fields of Guest Segment Registers on

