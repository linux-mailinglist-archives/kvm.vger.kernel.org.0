Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2A569CD3
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 22:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfGOUbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 16:31:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731764AbfGOUbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 16:31:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FKSqw6069100;
        Mon, 15 Jul 2019 20:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=OJRivD+7Yp0+qtCjnq9xtV6q7N2gf5q8KAoqRMx0UXM=;
 b=NPPlCX5XDpvMHpei1c2z32vX8RkFv+gUe+WDzqtIlGOiW1LEqCNLq6ShIc5HUDrsaZAr
 Th7vgk/f6wWHNxV6PgHrV2YjgQ+HF1wu/y82NvSDRB6df4XiDIlEbmjYNMSam2jYPjfe
 PeEd5gifkdlfTz9i846T57fEM5G4cqcHVNfZCtkiH9rSFvqGvA3z1jSBh4KAorL1M/Ck
 D5Gn/YPmGbFQKk/DSj2/J+/mk2hyolXljuihlCBVUHQ969d3gfQjAXeHeptlD/BUPm/4
 JdlLgpYLWs1LyiKqfp98X3QdlyHzz5LER4JQa0Jf1i6YQa6BUhd1lxjhfYJP8LwSYFZL Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tq6qtgtr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 20:31:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FKRmfX194874;
        Mon, 15 Jul 2019 20:31:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tq742qmha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 20:31:02 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6FKV0Gs020943;
        Mon, 15 Jul 2019 20:31:00 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 13:31:00 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     brijesh.singh@amd.com
Subject: KVM: SVM: Fix workaround for AMD Errata 1096
Date:   Mon, 15 Jul 2019 23:30:41 +0300
Message-Id: <20190715203043.100483-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=550
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=602 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150234
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This simple patch series aims to fix a bug in how KVM handles AMD Errata
1096.

1st patch is the fix. The bug was that vCPU state is checked incorrectly
for being able to possible raise a SMAP violation which is required to
encounter AMD Errata 1096.

2nd patch is a simple rename to make code more readable.

Disclaimer: I don't have the proper physical AMD machine to verify the
fix. I would appreciate if someone who have access to such AMD machine
will test it and reply.

Thanks,
-Liran

