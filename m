Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB5D9CD36
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbfHZKRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:17:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41536 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbfHZKRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:17:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QAEdQQ140930;
        Mon, 26 Aug 2019 10:17:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=5TqsifU5bVW0lTygAbeTjhINiSyDVg+Ft396Wv4qiY4=;
 b=Mv2J7SCFNVUk7pQ1bGZzzejbGMErFD7vUdRB47uthleYnXiTcK0dVoNxBimwbOWQl7X8
 xnYbEtb5Bs7ibBDU3GLjiqW0i5NT3k/iXSaUoVWbqQzXBskxcbVbi7vXQ0GgzN6RiXjl
 KLWBsh0nQpOh7nULq9Q+H7k9vHz/EsqRZs9e6NU16VfVN/yam6l00v/wqACGco3vy+dR
 hsSR8p01auv2FMal64MI9VbixNSj5q5vlzpP9+L70SZumU0DJTTfGdKVC1AHw9eUJivm
 GVGQTefLQywpbsE2YdH8AI0nSi1fkAd/zwyHDrAchmJNBf+kjwrOVvNevTAh7wsbxrsa 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ujw7182er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:17:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QADnBf079920;
        Mon, 26 Aug 2019 10:17:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ujw6hmb0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:17:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QAH6kj028121;
        Mon, 26 Aug 2019 10:17:06 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 03:17:06 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: x86: Return to userspace with internal error on unexpected exit reason
Date:   Mon, 26 Aug 2019 13:16:43 +0300
Message-Id: <20190826101643.133750-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Receiving an unexpected exit reason from hardware should be considered
as a severe bug in KVM. Therefore, instead of just injecting #UD to
guest and ignore it, exit to userspace on internal error so that
it could handle it properly (probably by terminating guest).

In addition, prefer to use vcpu_unimpl() instead of WARN_ONCE()
as handling unexpected exit reason should be a rare unexpected
event (that was expected to never happen) and we prefer to print
a message on it every time it occurs to guest.

Furthermore, dump VMCS/VMCB to dmesg to assist diagnosing such cases.

Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/svm.c       | 11 ++++++++---
 arch/x86/kvm/vmx/vmx.c   |  9 +++++++--
 include/uapi/linux/kvm.h |  2 ++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d685491fce4d..6462c386015d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5026,9 +5026,14 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || !svm_exit_handlers[exit_code]) {
-		WARN_ONCE(1, "svm: unexpected exit reason 0x%x\n", exit_code);
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
+		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
+		dump_vmcb(vcpu);
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror =
+			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+		vcpu->run->internal.ndata = 1;
+		vcpu->run->internal.data[0] = exit_code;
+		return 0;
 	}
 
 	return svm_exit_handlers[exit_code](svm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42ed3faa6af8..b5b5b2e5dac5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5887,8 +5887,13 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	else {
 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 				exit_reason);
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
+		dump_vmcs();
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror =
+			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+		vcpu->run->internal.ndata = 1;
+		vcpu->run->internal.data[0] = exit_reason;
+		return 0;
 	}
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..42070aa5f4e6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -243,6 +243,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
-- 
2.20.1

