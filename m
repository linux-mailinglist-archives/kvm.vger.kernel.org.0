Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EC11B8A3
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbfEMOlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:41:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47098 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730664AbfEMOlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:41:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd3dB181544;
        Mon, 13 May 2019 14:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=bOd6NTuOO3w4Tse88wsGsS3lTxF7t3wBy812EA6WdBU=;
 b=Y9nXfUJNbdNXiy0WXZfnXcvJMfJnbW6Wd/jhOsfaH+Nku6LO73tegfk4kUXz6qGARmee
 jxG1wNCbZiHDX8SNNrTewc3cLIlDZsttlVSwGklecgW/HROVU+I3mtazS3Yvqh11anbo
 Zv4jHKjLPjfduxRLu4X8LAzZ3P36HyfHmP1W/DyLiXegpYJeMKnqKZFwITYW5qzlSHm5
 RtesqMSGG/6fDOLSNgWvXF9bfkYj0YrLp3UqSNuvKowRK44FvGuaRvjBi3RpZ0NPhj/l
 QmdYQ9IaU3TVKzTuW8I6wo8hxvktW9E/r6qI9QWOuBYsblTK3/WgBv+O9a9uDwsYhX/x cg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2sdnttfeja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:39 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQL022780;
        Mon, 13 May 2019 14:39:31 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 18/27] kvm/isolation: function to copy page table entries for percpu buffer
Date:   Mon, 13 May 2019 16:38:26 +0200
Message-Id: <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pcpu_base_addr is already mapped to the KVM address space, but this
represents the first percpu chunk. To access a per-cpu buffer not
allocated in the first chunk, add a function which maps all cpu
buffers corresponding to that per-cpu buffer.

Also add function to clear page table entries for a percpu buffer.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/isolation.h |    2 ++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 539e287..2052abf 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -990,6 +990,40 @@ void kvm_clear_range_mapping(void *ptr)
 EXPORT_SYMBOL(kvm_clear_range_mapping);
 
 
+void kvm_clear_percpu_mapping(void *percpu_ptr)
+{
+	void *ptr;
+	int cpu;
+
+	pr_debug("PERCPU CLEAR percpu=%px\n", percpu_ptr);
+	for_each_possible_cpu(cpu) {
+		ptr = per_cpu_ptr(percpu_ptr, cpu);
+		kvm_clear_range_mapping(ptr);
+	}
+}
+EXPORT_SYMBOL(kvm_clear_percpu_mapping);
+
+int kvm_copy_percpu_mapping(void *percpu_ptr, size_t size)
+{
+	void *ptr;
+	int cpu, err;
+
+	pr_debug("PERCPU COPY percpu=%px size=%lx\n", percpu_ptr, size);
+	for_each_possible_cpu(cpu) {
+		ptr = per_cpu_ptr(percpu_ptr, cpu);
+		pr_debug("PERCPU COPY cpu%d addr=%px\n", cpu, ptr);
+		err = kvm_copy_ptes(ptr, size);
+		if (err) {
+			kvm_clear_range_mapping(percpu_ptr);
+			return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(kvm_copy_percpu_mapping);
+
+
 static int kvm_isolation_init_mm(void)
 {
 	pgd_t *kvm_pgd;
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index 7d3c985..3ef2060 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -18,5 +18,7 @@ static inline bool kvm_isolation(void)
 extern void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu);
 extern int kvm_copy_ptes(void *ptr, unsigned long size);
 extern void kvm_clear_range_mapping(void *ptr);
+extern int kvm_copy_percpu_mapping(void *percpu_ptr, size_t size);
+extern void kvm_clear_percpu_mapping(void *percpu_ptr);
 
 #endif
-- 
1.7.1

