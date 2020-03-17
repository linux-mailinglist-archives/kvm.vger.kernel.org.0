Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0F188F39
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 21:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgCQUoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 16:44:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39276 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgCQUod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 16:44:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKiFu4046053;
        Tue, 17 Mar 2020 20:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=OdpgIhTvhAdO6ABMJZtItawg7Zcv3wS0co5iLt+/01w=;
 b=fSFwxW66DGK4ri9vd1VEfWy+7g58xiiLJ+eryuxqM9FpPyB+HUtgUYfuoGQgJN18IGp3
 Kh5RD6ATw9zKIg8yqsCon1kubZko1nkP0ey3c1+m5Q0dbjOeiNMmTUcGMkwJYs2mMKYF
 voViQdShBMhsPhFI4qAzzpXjDFVG8FrUzqkp4mvTIio8t8ymY7A7vWqXIOANipkVf4XD
 rAVtm+CQoI3CLgUxYx84aDzZUu8pcySFr0+hfUzvEr2ZqgdW1kj0GYOIfd9U5Ei9aL3q
 SbX21abxM3QvgWnHJFbD+Ebp91Ra0He3mTf3U0V2wy9potp1g1cR60Mbh3Ij1CkwkiTx 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrppr79n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKcVjR149082;
        Tue, 17 Mar 2020 20:44:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ys8yyx3b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02HKiTdD023933;
        Tue, 17 Mar 2020 20:44:29 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 17 Mar 2020 13:43:16 -0700
MIME-Version: 1.0
Message-ID: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
Date:   Tue, 17 Mar 2020 13:05:34 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/3] kvm-unit-test: nSVM: Add alternative (v2) test framework
 and add test for SVME.EFER vmcb field
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=417 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=13 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=472 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset builds on top of my previous patch titled:

	"[PATCH] kvm-unit-test: nSVM: Restructure nSVM test code"

The idea here is to create an alternative (v2) test framework that nVMX has
so that tests that don't need the functions that the current framework
requires, can be added.
Patch# 1: Adds the alternative (v2) framework.
Patch# 2: Adds helper functions for reading and writing vmcb fields by the
	  tests.
Patch# 3: Adds a test for SVME.EFER field.

[PATCH 1/3] kvm-unit-test: nSVM: Add alternative (v2) test format for nested guests
[PATCH 2/3] kvm-unit-test: nSVM: Add helper functions to write and read vmcb fields
[PATCH 3/3] kvm-unit-test: nSVM: Test SVME.EFER on VMRUN of nested guests

 x86/svm.c       | 91 ++++++++++++++++++++++++++++++++++++++++++++-------------
 x86/svm.h       |  8 +++++
 x86/svm_tests.c | 25 ++++++++++++++++
 3 files changed, 104 insertions(+), 20 deletions(-)

Krish Sadhukhan (3):
      nSVM: Add alternative (v2) test format for nested guests
      nSVM: Add helper functions to write and read vmcb fields
      nSVM: Test SVME.EFER on VMRUN of nested guests

