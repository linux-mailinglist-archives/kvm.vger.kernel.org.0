Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF16988D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfGOPsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:48:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730257AbfGOPsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 11:48:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FFm5n9032390;
        Mon, 15 Jul 2019 15:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=FJzjxBNbpW/GyIxHetEdz2C7HL8JPEwyW6l1rgsXKlA=;
 b=Jd8lVoEgRtJFCAtSd9Ez4OsISbNShgzb2OLm24E0EUzvf1INMmgGx1PpNxDEGRnHrXrE
 3pID/fF6Pi/G4OAKCQNsgJk+vbVg+8Ts6GJI1ZhDPP+/FGxiVn3pd446HWW0UFx2v3vr
 dBcEoxYw+feLRgmnCBjMImY2iAZwWkcgbCBeUdshlSzJ5mggYsCqBW/jyBOzxhLjX8/w
 Jco9FEfNW5n+fLxh208EMjKaBRV8mj8J79PR3c4+zRXNRKZrk/sdl1hQc3xQFsk0Ji+W
 WrJ9A9WSSQ2qLYy81V5uJewloklXviV+aiKHt3rJjPsQAAkXiQRyCGzvf4XxFoeUsvKn lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tq7xqq909-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 15:48:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FFllEg156442;
        Mon, 15 Jul 2019 15:48:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tq6mmbqst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 15:48:02 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6FFm0uf010783;
        Mon, 15 Jul 2019 15:48:00 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 08:48:00 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     max@m00nbsd.net, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: nVMX: Ignore segment base for VMX memory operand when segment not FS or GS
Date:   Mon, 15 Jul 2019 18:47:44 +0300
Message-Id: <20190715154744.36134-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=519
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=565 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150185
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As reported by Maxime at
https://bugzilla.kernel.org/show_bug.cgi?id=204175:

In vmx/nested.c::get_vmx_mem_address(), when the guest runs in long mode,
the base address of the memory operand is computed with a simple:
    *ret = s.base + off;

This is incorrect, the base applies only to FS and GS, not to the others.
Because of that, if the guest uses a VMX instruction based on DS and has
a DS.base that is non-zero, KVM wrongfully adds the base to the
resulting address.

Reported-by: Maxime Villard <max@m00nbsd.net>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 18efb338ed8a..e01e1b6b8167 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4068,6 +4068,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
 		 * address when using FS/GS with a non-zero base.
 		 */
+		if ((seg_reg != VCPU_SREG_FS) && (seg_reg != VCPU_SREG_GS))
+			s.base = 0;
 		*ret = s.base + off;
 
 		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
-- 
2.20.1

