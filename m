Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5862C91B7
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 23:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388052AbgK3W4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 17:56:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34802 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730857AbgK3W4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 17:56:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMcsel171270;
        Mon, 30 Nov 2020 22:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=oyWjxkrHuqfLKrcgjwyTjeeBCvz6gVxbR5c8SxNaFvM=;
 b=Jl8Ac1LTRh8wOh2Y39a1uv0vhPiNHBCwnjAMt4R5GcFo25Lc4+0ffzZOOSAYOM3eNLRc
 S64svPO188trfoo9HR6oSpu2dF6lT5f7m1L4zP51s3IjMRjS3qBEZJymh3AaSU7MvQDj
 IueISE6bgAIFQ3Yd8/ndrUIY+9LiuyfBDnVSHA9DIFpLWSCUzzYbXvcabVmEhJPxDiYH
 GvG9gB+yL2Mcnr0M/WvOjFpBfb2soyj4zWCkvMjy//7rkF9HSUIhWhIM+aRZsCEkqk5+
 n0XThKqa1363TlakW7o0J3DqZ034IZNAxKCVPXqmCtF0GAwYbGqlpUjKXTMFR4y1QJ/M fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2aqvy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 22:55:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMfItj185798;
        Mon, 30 Nov 2020 22:53:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fvwe9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 22:53:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUMrEOB026955;
        Mon, 30 Nov 2020 22:53:14 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 14:53:14 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/2 v3] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon, 30 Nov 2020 22:53:04 +0000
Message-Id: <20201130225306.15075-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=845 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=857 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	1. Rebased to kvm.git's nested-svm branch.
	2. Simplied bracing in patch# 1.


According to sections "Canonicalization and Consistency Checks" and "Event
Injection" in APM vol 2,

    VMRUN exits with VMEXIT_INVALID error code if either:
      - Reserved values of TYPE have been specified, or
      - TYPE = 3 (exception) has been specified with a vector that does not
	correspond to an exception (this includes vector 2, which is an NMI,
	not an exception).

Patch# 1 adds these checks to KVM.
Patch# 2 adds tests for these checks.


[PATCH 1/2 v3] KVM: nSVM: Check reserved values for 'Type' and invalid
[PATCH 2/2 v3] nSVM: Test reserved values for 'Type' and invalid vectors in

 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/nested.c  | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

Krish Sadhukhan (1):
      KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ

 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ

