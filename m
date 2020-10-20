Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCA4290F9E
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 07:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436583AbgJQFvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 01:51:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46098 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411804AbgJQFvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 01:51:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GNwvaT058171;
        Sat, 17 Oct 2020 00:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=N0OpfcI/hWNtodCzC8b+M1zikHj0wih+MvM4jFBWAa4=;
 b=P9F2xMBERtpGigdffm7jzjhHZ9iompFj26HVhrAaOa1keEFe1Q1EHo61Qw1krCay853e
 0bdCvOt/ek1KyYB/6C2LsXqeDgzvkQLclNophfMwP+vmAE34GYwPEC3HYFnVRO/+1ytI
 2ICsSMAl5INhFppYKrCTua+K+tZuVVwHXfwkQAhWwfPobqKRKGA9E1OHlMvAFgeIjWZN
 Y6k2UMqQxiag2Yw8hoaQQ/gZdptzIezWUuyd7LcnSVNXlu9fe5FrPrsirc3DzSzFKkXX
 HPyYGsmthxtYA0cJblwKvsdXEa3gEvrX8m6JSfimP6lg2IKEhn8XDqlRgzqIj37PFAZk WQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 346g8gsadu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 17 Oct 2020 00:02:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GNxx6O158786;
        Sat, 17 Oct 2020 00:02:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 343pht17xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Oct 2020 00:02:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09H02r9Z018824;
        Sat, 17 Oct 2020 00:02:53 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 17:02:53 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/2] KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Sat, 17 Oct 2020 00:02:32 +0000
Message-Id: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=680 malwarescore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=692 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to sections "Canonicalization and Consistency Checks" and "Event
Injection" in APM vol 2,

    VMRUN exits with VMEXIT_INVALID error code if either:
      - Reserved values of TYPE have been specified, or
      - TYPE = 3 (exception) has been specified with a vector that does not
	correspond to an exception (this includes vector 2, which is an NMI,
	not an exception).

Patch# 1 adds these checks to KVM.
Patch# 2 adds tests for these checks.


[PATCH 1/2] KVM: nSVM: Check reserved values for 'Type' and invalid
[PATCH 2/2] nSVM: Test reserved values for 'Type' and invalid vectors in

 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/nested.c  | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

Krish Sadhukhan (1):
      KVM: nSVM: Check reserved values for 'Type' and invalid vectors in EVENTINJ

 x86/svm_tests.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ

