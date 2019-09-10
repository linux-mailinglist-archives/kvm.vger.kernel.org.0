Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0EAEBD4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 15:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbfIJNoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 09:44:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729662AbfIJNoH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Sep 2019 09:44:07 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8ADgRDQ125390
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:44:06 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uxaafpjr4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:44:06 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <groug@kaod.org>;
        Tue, 10 Sep 2019 14:44:02 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Sep 2019 14:43:59 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8ADhxw135651692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 13:43:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7EC442049;
        Tue, 10 Sep 2019 13:43:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE6624203F;
        Tue, 10 Sep 2019 13:43:58 +0000 (GMT)
Received: from bahia.tls.ibm.com (unknown [9.101.4.41])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Sep 2019 13:43:58 +0000 (GMT)
Subject: [PATCH 1/2] KVM: PPC: Book3S HV: XIVE: initialize private pointer
 when VPs are allocated
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 10 Sep 2019 15:43:58 +0200
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19091013-0020-0000-0000-0000036A843A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091013-0021-0000-0000-000021C00BA0
Message-Id: <156812303847.1865227.3495698285729698782.stgit@bahia.tls.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909100135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

Do not assign the device private pointer before making sure the XIVE
VPs are allocated in OPAL and test pointer validity when releasing
the device.

Fixes: 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 arch/powerpc/kvm/book3s_xive.c        |   13 +++++++++++--
 arch/powerpc/kvm/book3s_xive_native.c |   13 +++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 591bfb4bfd0f..cd2006bfcd3e 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1897,12 +1897,21 @@ void kvmppc_xive_free_sources(struct kvmppc_xive_src_block *sb)
 static void kvmppc_xive_release(struct kvm_device *dev)
 {
 	struct kvmppc_xive *xive = dev->private;
-	struct kvm *kvm = xive->kvm;
+	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
 
 	pr_devel("Releasing xive device\n");
 
+	/*
+	 * In case of failure (OPAL) at device creation, the device
+	 * can be partially initialized.
+	 */
+	if (!xive)
+		return;
+
+	kvm = xive->kvm;
+
 	/*
 	 * Since this is the device release function, we know that
 	 * userspace does not have any open fd referring to the
@@ -2001,7 +2010,6 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	if (!xive)
 		return -ENOMEM;
 
-	dev->private = xive;
 	xive->dev = dev;
 	xive->kvm = kvm;
 	mutex_init(&xive->lock);
@@ -2031,6 +2039,7 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	if (ret)
 		return ret;
 
+	dev->private = xive;
 	return 0;
 }
 
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 248c1ea9e788..e9cbb42de424 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -987,12 +987,21 @@ static int kvmppc_xive_native_has_attr(struct kvm_device *dev,
 static void kvmppc_xive_native_release(struct kvm_device *dev)
 {
 	struct kvmppc_xive *xive = dev->private;
-	struct kvm *kvm = xive->kvm;
+	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
 
 	pr_devel("Releasing xive native device\n");
 
+	/*
+	 * In case of failure (OPAL) at device creation, the device
+	 * can be partially initialized.
+	 */
+	if (!xive)
+		return;
+
+	kvm = xive->kvm;
+
 	/*
 	 * Clear the KVM device file address_space which is used to
 	 * unmap the ESB pages when a device is passed-through.
@@ -1076,7 +1085,6 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 	if (!xive)
 		return -ENOMEM;
 
-	dev->private = xive;
 	xive->dev = dev;
 	xive->kvm = kvm;
 	kvm->arch.xive = xive;
@@ -1100,6 +1108,7 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 	if (ret)
 		return ret;
 
+	dev->private = xive;
 	return 0;
 }
 

