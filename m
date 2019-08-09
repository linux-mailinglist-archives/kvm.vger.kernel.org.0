Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920A98837F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 21:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfHITyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 15:54:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHITyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 15:54:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JsBHX187057;
        Fri, 9 Aug 2019 19:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HfeSZiFqCbr7iMLJxVOSL+0nmxDcneaZbH2KpBdlyuw=;
 b=IF/nIcU08oiYLE2fkHop5NT7ip9J20gyMgAd/3Nc9AVyVIA2nUSkG/F3Y5Ea4hlBCG0+
 y89I/KQaLYJAdUrLVmTpoV3oGhxvlS4vRbf17pG7RxYHyRElDrcjxi52lhp5X+RLYhry
 l+NtczxcmnF00r4IF+bmG8GDui6rGFQXZcOkHYdUV3mbyEqNzld+Uz/dgyWZjWCTEoSL
 4cxJrhwbDP9GwuwjHvQeWBu+Tfoq+KxNIJtqEP/obhyWQW5y5T06reRWHShyPb4Xgm2V
 YUrpXNPG9kI5FcbNveoAem5UWZLpc/hYVV09EwomV3DegKAHyja16c6n+oCD7ZWY6vXo xA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=HfeSZiFqCbr7iMLJxVOSL+0nmxDcneaZbH2KpBdlyuw=;
 b=i2Eq7VHCnn79PYQcr+Odv0NuTzRhkrZoQrchusRfJWgAS7vq/b03eiyueLmjA64CRqkU
 Ns/4Hn8OmynZOscP4zVm6zw7bFlZJLBcoYRlGJA2QN67QQFCx3IE1Z+BO1O+25rRSIGU
 eN0E6HN2CmnX0JghjDZSM8dlD9gsAU3K+H2phNVcGwwTVG4iBQ01jz20V0C7OkR7J/JK
 CfdrVmNYFjEv63ImZOTBD7M5aYyyft2eQwJeDe8/o2OsvEZEtu+cfA12XiVaKHKIDoxZ
 TVAp7A92uCI81T41rfqWXsI0Fgu10oLFd3hQNeYEwIJ2oSFQ3c6x9YWVAWzU0oEp2ofR WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hps9qpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:54:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79Jr71t162469;
        Fri, 9 Aug 2019 19:54:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u8pj9gj20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:54:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79Jsb1A032323;
        Fri, 9 Aug 2019 19:54:37 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Fri, 09 Aug 2019 12:54:21 -0700
MIME-Version: 1.0
Message-ID: <20190809192620.29318-2-krish.sadhukhan@oracle.com>
Date:   Fri, 9 Aug 2019 12:26:19 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2] KVM: nVMX: Check Host Address Space Size on vmentry of
 nested guests
References: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=848
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=889 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks Related to Address-Space Size" in Intel SDM
vol 3C, the following checks are performed on vmentry of nested guests:

    If the logical processor is outside IA-32e mode (if IA32_EFER.LMA = 0)
    at the time of VM entry, the following must hold:
	- The "IA-32e mode guest" VM-entry control is 0.
	- The "host address-space size" VM-exit control is 0.

    If the logical processor is in IA-32e mode (if IA32_EFER.LMA = 1) at the
    time of VM entry, the "host address-space size" VM-exit control must be 1.

    If the "host address-space size" VM-exit control is 0, the following must
    hold:
	- The "IA-32e mode guest" VM-entry control is 0.
	- Bit 17 of the CR4 field (corresponding to CR4.PCIDE) is 0.
	- Bits 63:32 in the RIP field are 0.

    If the "host address-space size" VM-exit control is 1, the following must
    hold:
	- Bit 5 of the CR4 field (corresponding to CR4.PAE) is 1.
	- The RIP field contains a canonical address.

    On processors that do not support Intel 64 architecture, checks are
    performed to ensure that the "IA-32e mode guest" VM-entry control and the
    "host address-space size" VM-exit control are both 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bb509c254939..4de61b069d8c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2649,6 +2649,34 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    is_noncanonical_address(vmcs12->host_idtr_base, vcpu) ||
 	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
 		return -EINVAL;
+
+	if (!(vmcs12->host_ia32_efer & EFER_LMA) &&
+	    ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
+	    (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE))) {
+		return -EINVAL;
+	}
+
+	if ((vmcs12->host_ia32_efer & EFER_LMA) &&
+	    !(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) {
+		return -EINVAL;
+	}
+
+	if (!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
+	    ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
+	    (vmcs12->host_cr4 & X86_CR4_PCIDE) ||
+	    (((vmcs12->host_rip) >> 32) & 0xffffffff))) {
+		return -EINVAL;
+	}
+
+	if ((vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
+	    ((!(vmcs12->host_cr4 & X86_CR4_PAE)) ||
+	    (is_noncanonical_address(vmcs12->host_rip, vcpu)))) {
+		return -EINVAL;
+	}
+#else
+	if (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE ||
+	    vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
+		return -EINVAL;
 #endif
 
 	/*
-- 
2.20.1

