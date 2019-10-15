Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BBCD6CA7
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJOAw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:52:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbfJOAw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:52:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0nw9i188611;
        Tue, 15 Oct 2019 00:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=hotD8gkd9LN3gSxavXQRklzT0OQBMnwsghE5Qo2RJzM=;
 b=kHsDmBLSA7AJqwW51GMDXJH2RYkuYyngUq7RJUc3D521NHCc8TY1C7KxYSIgcW8id+g6
 yARxRU3F9Ynrxhe8gHqfbzjzAS4DCv6fvQQaERTSrlMhQ5G56Vnj2Gt0emXEd6UbmlKO
 8wIe6l324qd6zSwdIlRGCcbETUqGzTI5hjMexPZ1aAeBxdv5Ik2KenLxOrz76J7wXx7Y
 XlVEgZIWJjOfumKJedujNoF9USxH529QDP/6Kx4DpCR0r1mogrTRSSaeqaJK4yW95ups
 rSw6+OgDL+fLRImEsl4dP4/yHlCTl6HqNZeguOpZxoHrPUTZEuqJXDeakK2lJovwqwF1 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vk6sqcab7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0mAFl077474;
        Tue, 15 Oct 2019 00:52:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vks07swna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9F0qZEk005230;
        Tue, 15 Oct 2019 00:52:36 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:52:35 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 0/4]: kvm-unit-test: nVMX: Test deferring of error from VM-entry MSR-load area
Date:   Mon, 14 Oct 2019 20:16:29 -0400
Message-Id: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=749
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=826 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Replaces hard-coded value with instruction length read from VMCS
	  field.
Patch# 2: Adds an extra check to __enter_guest() so that it can distinguish
	  between VM-entry failure due to invalid guest state and that due to
	  invalid VM-entry MSR-load area.
Patch# 3: Verifies that when VM-entry fails due to invalid VM-entry MSR-load
	  area in vmcs12, the error is deferred and caught by hardware when
	  it is done processing higher priority checks such as guest state etc.
	  This patch also verifies that when VM-entry fails due to invalid
	  VM-entry MSR-load area in vmcs12, MSRs that were loaded from  that
	  MSR-load area are rolled back to their original values.
Patch# 4: Replaces hard-coded value with corresponding #define.


[PATCH 1/4] kvm-unit-test: VMX: Replace hard-coded exit instruction length
[PATCH 2/4] kvm-unit-test: nVMX: __enter_guest() needs to also check for
[PATCH 3/4] kvm-unit-test: nVMX: Test deferring of error from VM-entry MSR-load area
[PATCH 4/4] kvm-unit-test: nVMX: Use #defines for exit reason in

 x86/vmx.c       |   3 +-
 x86/vmx_tests.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 136 insertions(+), 6 deletions(-)

Krish Sadhukhan (4):
      VMX: Replace hard-coded exit instruction length
      VMX: __enter_guest() needs to also check for VMX_FAIL_STATE
      nVMX: Test deferring of error from VM-entry MSR-load area
      nVMX: Use #defines for exit reason in advance_guest_state_test()

