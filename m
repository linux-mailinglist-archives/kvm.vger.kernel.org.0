Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50843103D56
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbfKTOee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 09:34:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbfKTOed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 09:34:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKEEHLN140925;
        Wed, 20 Nov 2019 14:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=pwDdzj40sbmAyVkV0opfYQybjogY7MjzaKx70oXmVzQ=;
 b=lnSutISoYblEW1/J8HOT5/JhIXILrT04HHJcAzFGnws2c2Hy+x/JfnF/mTDhdHvnp8jh
 wxfTDw/Pq/E5O3HyCxfZeqjPJsohsSC/+imKkfbog1AW3eCLMrV1IRg5VtsIEEJyduZ5
 Gv32zGwUytPHLJa+ui0sNuRjqIlk85AAjyoCcrlzdru2iC2iyKkR1IZJxHyI45HGuvl4
 c4yt5dio124Qdi/FRXkICemm8KAxA648zBxKXem16pzuoMGw29jsbNAzwzHEhq7YfZl7
 s7oR5yYJPzfB8gKY7k51fOLlGiPW04IzKRWhbgpe72PibK67ZIEunqFK/aJyjdr9Tqob wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wa9rqnu7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 14:34:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKEDxk8103780;
        Wed, 20 Nov 2019 14:34:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wcemg3nph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 14:34:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKEYQVr030859;
        Wed, 20 Nov 2019 14:34:26 GMT
Received: from Lirans-MBP.Home (/79.176.218.68)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 06:34:25 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: nVMX: Remove unnecessary TLB flushes on L1<->L2 switches when L1 use apic-access-page
Date:   Wed, 20 Nov 2019 16:33:07 +0200
Message-Id: <20191120143307.59906-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Intel SDM section 28.3.3.3/28.3.3.4 Guidelines for Use
of the INVVPID/INVEPT Instruction, there is a need to execute
INVVPID/INVEPT X in case CPU executes VMEntry with VPID/EPTP X and
either: "Virtualize APIC accesses" VM-execution control was changed
from 0 to 1, OR the value of apic_access_page was changed.

Examining prepare_vmcs02(), one could note that L0 won't flush
physical TLB only in case: L0 use VPID, L1 use VPID and L0
can guarantee TLB entries populated while running L1 are tagged
differently than TLB entries populated while running L2.
The last condition can only occur if either L0 use EPT or
L0 use different VPID for L1 and L2
(i.e. vmx->vpid != vmx->nested.vpid02).

If L0 use EPT, L0 use different EPTP when running L2 than L1
(Because guest_mode is part of mmu-role) and therefore SDM section
28.3.3.4 doesn't apply. Otherwise, L0 use different VPID when
running L2 than L1 and therefore SDM section 28.3.3.3 doesn't
apply.

Similarly, examining nested_vmx_vmexit()->load_vmcs12_host_state(),
one could note that L0 won't flush TLB only in cases that doesn't
apply to SDM sections 28.3.3.3 and 28.3.3.4.

Considering the above, there is therefore no need to specifically
flush TLB in case L1 don't use EPT and use "Virtualize APIC accesses".
Thus, remove this flush from prepare_vmcs02() and nested_vmx_vmexit().

Side-note: This patch can be viewed as removing parts of commit
fb6c81984313 ("kvm: vmx: Flush TLB when the APIC-access address changes”)
that is not relevant anymore since commit
1313cc2bd8f6 ("kvm: mmu: Add guest_mode to kvm_mmu_page_role”).
i.e. The first commit assumes that if L0 use EPT and L1 doesn’t use EPT,
then L0 will use same EPTP for both L0 and L1. Which indeed required
L0 to execute INVEPT before entering L2 guest. This assumption is
not true anymore since when guest_mode was added to mmu-role.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fdcead2d4dd6..20692e442d13 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2384,9 +2384,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if (nested_cpu_has_ept(vmcs12))
 		nested_ept_init_mmu_context(vcpu);
-	else if (nested_cpu_has2(vmcs12,
-				 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
-		vmx_flush_tlb(vcpu, true);
 
 	/*
 	 * This sets GUEST_CR0 to vmcs12->guest_cr0, possibly modifying those
@@ -4125,10 +4122,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
 		vmx->nested.change_vmcs01_virtual_apic_mode = false;
 		vmx_set_virtual_apic_mode(vcpu);
-	} else if (!nested_cpu_has_ept(vmcs12) &&
-		   nested_cpu_has2(vmcs12,
-				   SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
-		vmx_flush_tlb(vcpu, true);
 	}
 
 	/* Unpin physical memory we referred to in vmcs02 */
-- 
2.20.1

