Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE3F1046A4
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 23:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKTWcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 17:32:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTWcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 17:32:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKMIxbi194931;
        Wed, 20 Nov 2019 22:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=jPiCHswE/8lrEBCyDTuCovZmy8rsk6cyZIiTyARLZAY=;
 b=ZXWpFhrbyDHS55dfYXxqlfGI9rZwlJYoyYBwWXL7f6tCAnsE/pjjJCarw2BrZVsMCRMF
 0Lvd2/YD3OuveucUkR1prrCKMmIXQSxk34AP4TVsu0v5GHMaR3bqWqJJlwgXE1tB1LOi
 AqtGtECfvyeb1VGL+3/eKwTE+b/QmmG017g4LWOydQwm9idRRquyh9Lta3sbvgNau7PN
 MSXLwXbbGgReGCKsM9ds23OmW1/ykfFQnwnxcNwap/RTEAL7fcyy3RnOobNVsD1fuNah
 stBjbfU8QkdHemVKTQt9PqfpRadIuSRBCtL2BYiTM++VnxCs74mJejn5HTCerXfO6/V3 qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8hu0k20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 22:32:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKMJ8Ug006090;
        Wed, 20 Nov 2019 22:32:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wcemja4ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 22:32:00 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKMVwhr009525;
        Wed, 20 Nov 2019 22:31:59 GMT
Received: from Lirans-MBP.Home (/79.176.218.68)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 14:31:58 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: nVMX: Do not mark vmcs02->apic_access_page as dirty when unpinning
Date:   Thu, 21 Nov 2019 00:31:47 +0200
Message-Id: <20191120223147.63358-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=501
 adultscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=561 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200189
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmcs->apic_access_page is simply a token that the hypervisor puts into
the PFN of a 4KB EPTE (or PTE if using shadow-paging) that triggers
APIC-access VMExit or APIC virtualization logic whenever a CPU running
in VMX non-root mode read/write from/to this PFN.

As every write either triggers an APIC-access VMExit or write is
performed on vmcs->virtual_apic_page, the PFN pointed to by
vmcs->apic_access_page should never actually be touched by CPU.

Therefore, there is no need to mark vmcs02->apic_access_page as dirty
after unpin it on L2->L1 emulated VMExit or when L1 exit VMX operation.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 20692e442d13..2506f431d51e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -257,7 +257,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.cached_shadow_vmcs12 = NULL;
 	/* Unpin physical memory we referred to in the vmcs02 */
 	if (vmx->nested.apic_access_page) {
-		kvm_release_page_dirty(vmx->nested.apic_access_page);
+		kvm_release_page_clean(vmx->nested.apic_access_page);
 		vmx->nested.apic_access_page = NULL;
 	}
 	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
@@ -2933,7 +2933,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		 * to it so we can release it later.
 		 */
 		if (vmx->nested.apic_access_page) { /* shouldn't happen */
-			kvm_release_page_dirty(vmx->nested.apic_access_page);
+			kvm_release_page_clean(vmx->nested.apic_access_page);
 			vmx->nested.apic_access_page = NULL;
 		}
 		page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
@@ -4126,7 +4126,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 
 	/* Unpin physical memory we referred to in vmcs02 */
 	if (vmx->nested.apic_access_page) {
-		kvm_release_page_dirty(vmx->nested.apic_access_page);
+		kvm_release_page_clean(vmx->nested.apic_access_page);
 		vmx->nested.apic_access_page = NULL;
 	}
 	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-- 
2.20.1

