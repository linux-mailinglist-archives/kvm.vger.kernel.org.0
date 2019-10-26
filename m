Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06F5E5842
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 05:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfJZDZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 23:25:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJZDZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 23:25:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9Q3OkNH051181;
        Sat, 26 Oct 2019 03:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=qbmDCgBtV8Hu9bOnHVIN+c104YmBRi1ZzJtk9wI6Wqs=;
 b=p4ze/GwYzEfMoaKjVa/36Wf2yzmPsZVRyBLgpPMvgYxHUVjbMNVHKOSIcp+rnro4PabJ
 VlnRQT1h+j38IQCwlQlhJuaO0lJhhjYjFBBerHRBDGVYm5LZhb0MJ8eCod1lCQ6p4CB3
 o9aEv9s7GjV7mBWshwu9ByFYkd7I06SXANC33zWDKq2/4lvRSQySGKp/7nEELxK6aos9
 WDWT1S/lI1DxQIcKM0r7qdW85srarp0Cj5beEHOjBv8UUWZB+R7dyM/ZnGwupHT25E2u
 RgJmYPwjuAbM0JFJQohCvExHw2oi/JzuREz2DOsDSVLlBrw6F00c/TaP0mI/0vlH36LL FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vvdjtr51k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 03:24:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9Q3O9wZ018306;
        Sat, 26 Oct 2019 03:24:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vvdymgd56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 03:24:47 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9Q3Oj9U016087;
        Sat, 26 Oct 2019 03:24:46 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 20:24:45 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH 2/5] KVM: add a check to ensure grow start value is nonzero
Date:   Sat, 26 Oct 2019 11:23:56 +0800
Message-Id: <1572060239-17401-3-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=712
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910260033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=798 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910260034
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu->halt_poll_ns could be zeroed in certain cases (e.g. by
halt_poll_ns_shrink). If halt_poll_ns_grow_start is zero,
vcpu->halt_poll_ns will never be larger than zero.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 virt/kvm/kvm_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2ca2979..1b6fe3b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2266,6 +2266,13 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 		goto out;
 
 	val *= grow;
+
+	/*
+	 * vcpu->halt_poll_ns needs a nonzero start point to grow if it's zero.
+	 */
+	if (!grow_start)
+		grow_start = 1;
+
 	if (val < grow_start)
 		val = grow_start;
 
-- 
1.8.3.1

