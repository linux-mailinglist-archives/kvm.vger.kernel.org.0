Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F0B386557
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbhEQUJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237776AbhEQUJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:26 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK4Esv180664;
        Mon, 17 May 2021 16:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/JL7l+Vc6WTNXZlPugYxcdcXRNeZ1GKl6iZGoQQX7mw=;
 b=TamER3VR8BH9WSbm0Piqfzx28G0cbuXULWyDpnydeY6+YxAE8uxAKu3OahDWn10e55GO
 yQuFQAuGpT+4QMhHvslpqYAzX2kvwA/+O6sRTK4UnykKkYl4DR0c5UyK2vwAU6aELvjm
 WLRwUspRr86qKyGsfWa7JZDxMdyoVlpzopKlMMfF9WMbC3m+XnELKUHPOz0+pDEoyu4c
 AjxZcVoS4KnJF30hXOIw2XvF1+TcXjoF5BTA+gs8VfjgwK+jM7iqdRNk39D7gqp+Wz4D
 DELGrW/+zPNFefEewKeS35bQJag1fat0mJmXJgVf7n70hUWmFQzMitCv0YTG5GICq2wI Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxwr8gac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:09 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK56R5186054;
        Mon, 17 May 2021 16:08:09 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxwr8g9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:09 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK3QVB005385;
        Mon, 17 May 2021 20:08:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 38j5x80kep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK83mC31326502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:08:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D72F35204F;
        Mon, 17 May 2021 20:08:03 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 74C6B52050;
        Mon, 17 May 2021 20:08:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 10/11] KVM: s390: pv: module parameter to fence lazy destroy
Date:   Mon, 17 May 2021 22:07:57 +0200
Message-Id: <20210517200758.22593-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 74CCcO8o888fYquU4M3k0PSUOaapfaeU
X-Proofpoint-ORIG-GUID: QIPsQduD9xKsBdaz91GPrkMBcZdFnaFI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "lazy_destroy", to allow the lazy destroy
mechanism to be switched off. This might be useful for debugging
purposes.

The parameter is enabled by default.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 4333d3e54ef0..00c14406205f 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -26,6 +26,10 @@ struct deferred_priv {
 	unsigned long real;
 };
 
+static int lazy_destroy = 1;
+module_param(lazy_destroy, int, 0444);
+MODULE_PARM_DESC(lazy_destroy, "Deferred destroy for protected guests");
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc = 0;
@@ -348,6 +352,9 @@ int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct deferred_priv *priv;
 
+	if (!lazy_destroy)
+		kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
 	if (!priv)
 		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
@@ -396,6 +403,12 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
+	if (!lazy_destroy) {
+		mmap_write_lock(kvm->mm);
+		kvm->mm->context.pv_sync_destroy = 1;
+		mmap_write_unlock(kvm->mm);
+	}
+
 	atomic_inc(&kvm->mm->context.is_protected);
 	if (cc) {
 		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
-- 
2.31.1

