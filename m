Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A178060CF4
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 23:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfGEVHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 17:07:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfGEVHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 17:07:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L3rJF119866;
        Fri, 5 Jul 2019 21:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=mRUp3UE+E2D0bvC2nURNQ62ackyCJAb7LpNyWjews3I=;
 b=RFj8+UhJbo1BBp1h12iKJIXOQNTeexWnR0f+i5LWCPlInVaiVNGfRoXDTRIUlpOQ2tuJ
 TbdlKAqdFum1h1SubbkStuyQtA+eKI+YrBeCVANNy86MX2V8oztylKlPbD+idZr/9+9X
 ZXmXrT5fp9C4iZ2IO+4mDMziFcKQdSUo9ynAIgPGp/nTIx/vrNgkiX55OTP9/vBnVxYE
 0GQalW4pnYN4URSz35AZ/NeoKRh3zZzRfTQNX2FUdbqlYL0/98us078Evzq9if31yHIf
 8HXIsJ8s9vjo6FleER/dVTRCfHpF9SLzIwGGwYz0TDwrFVZB300XIfQbZexIEqYuFwbB 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2te61emgg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:07:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L2Tb0107276;
        Fri, 5 Jul 2019 21:07:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2thxrvm495-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:07:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x65L72ls025541;
        Fri, 5 Jul 2019 21:07:02 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 14:07:02 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 3/4] target/i386: kvm: Save nested-state only in case vCPU have set VMXON region
Date:   Sat,  6 Jul 2019 00:06:35 +0300
Message-Id: <20190705210636.3095-4-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705210636.3095-1-liran.alon@oracle.com>
References: <20190705210636.3095-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=661
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050266
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=705 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050266
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having (nested_state->hdr.vmx.vmxon_pa != -1ull) signals that vCPU have set
at some point in time a VMXON region. Note that even though when vCPU enters
SMM mode it temporarily exit VMX operation, KVM still reports (vmxon_pa != -1ull).
Therefore, this field can be used as a reliable indicator on when we require to
send VMX nested-state as part of migration stream.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/machine.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 851b249d1a39..20bda9f80154 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -997,9 +997,8 @@ static bool vmx_nested_state_needed(void *opaque)
 {
     struct kvm_nested_state *nested_state = opaque;
 
-    return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
-            ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
-             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
+    return (nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
+           (nested_state->hdr.vmx.vmxon_pa != -1ull);
 }
 
 static const VMStateDescription vmstate_vmx_nested_state = {
-- 
2.20.1

