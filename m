Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D9DBB833
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbfIWPnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:43:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732544AbfIWPnq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Sep 2019 11:43:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8NFg7Ai076599
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 11:43:45 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v6ydumg5u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 11:43:45 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <groug@kaod.org>;
        Mon, 23 Sep 2019 16:43:43 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Sep 2019 16:43:39 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8NFhBfA33685764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 15:43:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A020AE057;
        Mon, 23 Sep 2019 15:43:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B11FDAE045;
        Mon, 23 Sep 2019 15:43:37 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.22.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Sep 2019 15:43:37 +0000 (GMT)
Subject: [PATCH 1/6] KVM: PPC: Book3S HV: XIVE: initialize private pointer
 when VPs are allocated
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 23 Sep 2019 17:43:37 +0200
In-Reply-To: <156925341155.974393.11681611197111945710.stgit@bahia.lan>
References: <156925341155.974393.11681611197111945710.stgit@bahia.lan>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19092315-4275-0000-0000-0000036A1A52
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092315-4276-0000-0000-0000387C8F5E
Message-Id: <156925341736.974393.18379970954169086891.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230148
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
 

