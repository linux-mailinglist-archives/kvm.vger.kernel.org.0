Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A3E5F007
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 02:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfGDAXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 20:23:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfGDAXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 20:23:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x640JhcU088628;
        Thu, 4 Jul 2019 00:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=zDxk33RTSWCTZulMStUY/kTPWhNh1r540LXwahRbUQ8=;
 b=AhgZzH5LFOpArX5tnIR4/t/c7/kgl6u3jbpmzhbtvfHDVa83wdh2qDyFel9+H3YQvLaq
 TWm9LUaU5+ZzMAm2XwDaHOqFlbrVUAftfnJHs2DrnzsPoHqHV62iZr7I1u2it1kr8SJy
 p4Ed3Vkn872Q3Pb5x0VkaCis4dXeMC82HHim4w5+PbkpV1dKXwomYhuAhZCdGQmuXtz/
 Fa0nzMFhbpZlthDc+/WjI6lEDw/YjJllEgSB+cnAxQdOhBFtTTdc6+PZCwHX7MiApO+r
 Kr5yKBGF8kSl9mYg/foYtShz3as8Ymvu5SQ+t0T47EqQVYbLwLCiOqkEqcrNaaUj2GWq 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tbv2tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 00:22:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x640MPh1005060;
        Thu, 4 Jul 2019 00:22:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tebkv5a6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 00:22:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x640Ma26022369;
        Thu, 4 Jul 2019 00:22:36 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 17:22:36 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2 v2]nVMX: Check Host Segment Registers and Descriptor Tables on vmentry of nested guests
Date:   Wed,  3 Jul 2019 19:54:34 -0400
Message-Id: <20190703235437.13429-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=1 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=1 mlxscore=1 mlxlogscore=203
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=248 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907040002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


v1 -> v2:
        In patch# 2, make_non_canonical() has been made 'inline' to fix a
        compilation error.



Patch# 1 implements the following checks, from Intel SDM vol 3C, on
vmentry of nested guests:

   - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
     RPL (bits 1:0) and the TI flag (bit 2) must be 0.
   - The selector fields for CS and TR cannot be 0000H.
   - The selector field for SS cannot be 0000H if the "host address-space
     size" VM-exit control is 0.
   - On processors that support Intel 64 architecture, the base-address
     fields for FS, GS and TR must contain canonical addresses.

Patch# 2 adds kvm-unit-tests for the above checks.


[PATCH 1/2] KVM nVMX: Check Host Segment Registers and Descriptor Tables on
[PATCH 2/2] kvm-unit-test nVMX: Test Host Segment Registers and Descriptor Tables on

 arch/x86/kvm/vmx/nested.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

Krish Sadhukhan (1):
      nVMX: Check Host Segment Registers and Descriptor Tables on vmentry of nested guests

 lib/x86/processor.h |   5 ++
 x86/vmx_tests.c     | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test Host Segment Registers and Descriptor Tables on vmentry of nested guests

