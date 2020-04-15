Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A451AB16B
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506445AbgDOTQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 15:16:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411817AbgDOTLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 15:11:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FJ7qIe062355;
        Wed, 15 Apr 2020 19:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=nTSkysgzrhho7jcZJ+h2Xj3yr2tTKuMWwXbQ7X0Y1ZE=;
 b=hys7JUKEaURphFF8HhfxjPy4i9VB4cR+TaF+Yr9zyy/U+c5DHtxBxzkGcdhblfPOVkbh
 xNZSelugRR0PHxGDzKiuzEqyFssoWs/EQ9kHkoReKJV6DR7cRD041dPCI/ZqPh0S6fvQ
 luPk+cjekTDdK5IHtGcveta5sEPtQrLvnRGfJQ26/oZ8Ytji8EgwEEm45Wkt8DB9ZOab
 S5HGO6VzFisQvhN7HakUE7rHSYhtwe2lpK6KB9l58akRIlupIQ8T1dDvMkmRGZq/nRcv
 mEZC2JFhyLBZKg2+7bPrQfOOBZYc9/jMP49iuOZZcq4LaoJpisWKVrTNhv7H66n3EvWN Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30e0bfattj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 19:11:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FJ7wcZ195208;
        Wed, 15 Apr 2020 19:11:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30dynw8cen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 19:11:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03FJB2RA026526;
        Wed, 15 Apr 2020 19:11:02 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Apr 2020 12:11:02 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest" VM-execution control in vmcs02 if vmcs12 doesn't set it
Date:   Wed, 15 Apr 2020 14:30:46 -0400
Message-Id: <20200415183047.11493-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 suspectscore=1 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, prepare_vmcs02_early() does not check if the "unrestricted guest"
VM-execution control in vmcs12 is turned off and leaves the corresponding
bit on in vmcs02. Due to this setting, vmentry checks which are supposed to
render the nested guest state as invalid when this VM-execution control is
not set, are passing in hardware.

This patch turns off the "unrestricted guest" VM-execution control in vmcs02
if vmcs12 has turned it off.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbc9ea2de28f..4fa5f8b51c82 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2224,6 +2224,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
 
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST))
+			exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
+
 		secondary_exec_controls_set(vmx, exec_control);
 	}
 
-- 
2.20.1

