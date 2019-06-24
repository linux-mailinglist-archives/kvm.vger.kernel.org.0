Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D1451EEC
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 01:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfFXXHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 19:07:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfFXXHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 19:07:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OMxd9U036398;
        Mon, 24 Jun 2019 23:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=yUBEZia5gsuqxQ69vNng00iBJBoO065TVcwKIsFBCF0=;
 b=4AMs/1XWaPckBZwOgJMgOaZLtE4WpFsA1IdegEGmRkTmLPVc1A15OUIGzAXsG4Yb91un
 DsH9ZfYASvGkFQE2EiAyZpOuGO5XWuKdo78FtW6aBAgMB5MdnaK0sN6Gq5dM7q7yw7Cj
 1HwzJ5nPjfR7mW1ZziRBnpqNbnJ9AKbyN/98mV6NbzNHB73u8EdsI9xEv4/uVU6zImXo
 1mNG7AEAdKHE/d1X78v6ifGBLWdohL4bICiyv0g+F6niWlOEDoHs0lmHmzuR6s6nNIx1
 /4T2CfFO9OgL/1ExHspeu1K/+t/NfrFezB719qL/OUaJnLnatLQJucvsRLIJNoESnBCs Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyq8vyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 23:05:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5ON4mh6024774;
        Mon, 24 Jun 2019 23:05:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6tuhge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 23:05:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5ON5MpY000353;
        Mon, 24 Jun 2019 23:05:22 GMT
Received: from Lirans-MBP.Home (/109.64.216.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 16:05:21 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Karl Heubaum <karl.heubaum@oracle.com>
Subject: [PATCH] target/i386: kvm: Fix when nested state is needed for migration
Date:   Tue, 25 Jun 2019 02:05:14 +0300
Message-Id: <20190624230514.53326-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=991
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vCPU is in VMX operation and enters SMM mode,
it temporarily exits VMX operation but KVM maintained nested-state
still stores the VMXON region physical address, i.e. even when the
vCPU is in SMM mode then (nested_state->hdr.vmx.vmxon_pa != -1ull).

Therefore, there is no need to explicitly check for
KVM_STATE_NESTED_SMM_VMXON to determine if it is necessary
to save nested-state as part of migration stream.

In addition, destination must enable eVMCS if it is enabled on
source as specified by the KVM_STATE_NESTED_EVMCS flag, even if
the VMXON region is not set. Thus, change the code to require saving
nested-state as part of migration stream in case it is set.

Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 851b249d1a39..e7d72faf9e24 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -999,7 +999,7 @@ static bool vmx_nested_state_needed(void *opaque)
 
     return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
             ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
-             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
+             (nested_state->flags & KVM_STATE_NESTED_EVMCS)));
 }
 
 static const VMStateDescription vmstate_vmx_nested_state = {
-- 
2.20.1

