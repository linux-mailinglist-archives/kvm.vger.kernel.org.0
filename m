Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F961B891
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfEMOkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730620AbfEMOkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd2Tx194906;
        Mon, 13 May 2019 14:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=K8i6wzsowphEeVDFXNpunuRUppmUJV415MqqD0nUaBI=;
 b=W22kvYLfLPm+lj8NF2wS7sDx9KGLeptevfeDTUzv+GZagg1XtUp9vZNWcihPEkWLSaPG
 Lx/9JGXoffT/Eb0lGLC1sDrq7K90utKJBv6oHFBVipO5+pMWF/TFSJYeuAR0q5E3kmrb
 Z8y5MymYgg/n3HDgLeCgwZcunQle8i2tJ4Yh1yNjfZX7YXAq/W6CISOEnlueSKA6ARpD
 7dxEJ5PcvUpwerEg1uRhKhIlwA7KzrsVOb2FbKrBGoKH6oKfCK78Z0vuFk+sXe8ZpF4h
 vFYm9C8pwOMgg5LaQcKAYKtRiG+FEuIFLEcRxD9EaawYkjfOPClZpb0QoK/QdH7HCyaA Yg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7ayc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:45 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQP022780;
        Mon, 13 May 2019 14:39:42 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 22/27] kvm/isolation: initialize the KVM page table with vmx cpu data
Date:   Mon, 13 May 2019 16:38:30 +0200
Message-Id: <1557758315-12667-23-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Map vmx cpu to the KVM address space when a vmx cpu is created, and
unmap when it is freed.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5b52e8c..cbbaf58 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6564,10 +6564,69 @@ static void vmx_vm_free(struct kvm *kvm)
 	vfree(to_kvm_vmx(kvm));
 }
 
+static void vmx_unmap_vcpu(struct vcpu_vmx *vmx)
+{
+	pr_debug("unmapping vmx %p", vmx);
+
+	kvm_clear_range_mapping(vmx);
+	if (enable_pml)
+		kvm_clear_range_mapping(vmx->pml_pg);
+	kvm_clear_range_mapping(vmx->guest_msrs);
+	kvm_clear_range_mapping(vmx->vmcs01.vmcs);
+	kvm_clear_range_mapping(vmx->vmcs01.msr_bitmap);
+	kvm_clear_range_mapping(vmx->vcpu.arch.pio_data);
+	kvm_clear_range_mapping(vmx->vcpu.arch.apic);
+}
+
+static int vmx_map_vcpu(struct vcpu_vmx *vmx)
+{
+	int rv;
+
+	pr_debug("mapping vmx %p", vmx);
+
+	rv = kvm_copy_ptes(vmx, sizeof(struct vcpu_vmx));
+	if (rv)
+		goto out_unmap_vcpu;
+
+	if (enable_pml) {
+		rv = kvm_copy_ptes(vmx->pml_pg, PAGE_SIZE);
+		if (rv)
+			goto out_unmap_vcpu;
+	}
+
+	rv = kvm_copy_ptes(vmx->guest_msrs, PAGE_SIZE);
+	if (rv)
+		goto out_unmap_vcpu;
+
+	rv = kvm_copy_ptes(vmx->vmcs01.vmcs, PAGE_SIZE << vmcs_config.order);
+	if (rv)
+		goto out_unmap_vcpu;
+
+	rv = kvm_copy_ptes(vmx->vmcs01.msr_bitmap, PAGE_SIZE);
+	if (rv)
+		goto out_unmap_vcpu;
+
+	rv = kvm_copy_ptes(vmx->vcpu.arch.pio_data, PAGE_SIZE);
+	if (rv)
+		goto out_unmap_vcpu;
+
+	rv = kvm_copy_ptes(vmx->vcpu.arch.apic, sizeof(struct kvm_lapic));
+	if (rv)
+		goto out_unmap_vcpu;
+
+	return 0;
+
+out_unmap_vcpu:
+	vmx_unmap_vcpu(vmx);
+	return rv;
+}
+
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (kvm_isolation())
+		vmx_unmap_vcpu(vmx);
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
 	free_vpid(vmx->vpid);
@@ -6679,6 +6738,12 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 
 	vmx->ept_pointer = INVALID_PAGE;
 
+	if (kvm_isolation()) {
+		err = vmx_map_vcpu(vmx);
+		if (err)
+			goto free_vmcs;
+	}
+
 	return &vmx->vcpu;
 
 free_vmcs:
-- 
1.7.1

