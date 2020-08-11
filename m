Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64753242272
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgHKWYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 18:24:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHKWYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 18:24:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BMMoDW029220;
        Tue, 11 Aug 2020 22:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=fKxy2sHdbbWH2Dqfql+se4yrFnaO+nsOrGJX7P2cGGs=;
 b=fDjW9xwg8e5GyCa/lX0CgOCjXnkA3q7Jj/4/vi5yovURbb8yr281s8eaVzj3SQWtW/Zo
 FX5aDi6bXTnXTx3b1yId8E1fTY+WQvFJwXoG3mTRpKylwTsscigsxR113MnbBWpHa1AE
 hHpNcFPydSLQkaH8pBK/zTgra3L9HyWe66aaXQu3HIJjruiGkgBnxnYamZSMTTU833to
 HvoBZtNdcSqOeJ+TttqnOf5S8xNWAVPvZhbJ25S5f7TnOnAfR1cM6k0whCs4KGJo9njj
 et4C3wuyPSbVDPKKVNKZtZe/vezGD2AxhcMTqrfSrxOw9B9hzQPt6BBAm1iD8+q4mOXe ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mqf2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Aug 2020 22:24:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BMNJMt094468;
        Tue, 11 Aug 2020 22:24:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32t5y54rq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 22:24:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07BMO3Pl007272;
        Tue, 11 Aug 2020 22:24:03 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Aug 2020 22:24:02 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2] kvm-unit-tests: nSVM: Test combinations of EFER.LME, CR0.PG, CR4.PAE, CR0.PE and CS register on VMRUN of nested guests
Date:   Tue, 11 Aug 2020 22:23:52 +0000
Message-Id: <20200811222353.41414-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=15 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=876 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=15 mlxlogscore=863 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	1. Explicitly set CR0.PE in the first test case and CR4.PAE in
	   the second.
	2. Set CR0.PE in the third test case as it was missing in v1.
	3. Changed the patch title from " KVM: nSVM: Test combinations of..."
	   to " kvm-unit-tests: nSVM: Test combinations of...".


[PATCH v2] kvm-unit-tests: nSVM: Test combination of EFER.LME, CR0.PG

 x86/svm_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

