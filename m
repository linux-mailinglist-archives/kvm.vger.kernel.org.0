Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D2839FEA3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 20:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhFHSIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 14:08:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234232AbhFHSI3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 14:08:29 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158I5V2w100956;
        Tue, 8 Jun 2021 14:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V8hAue0KgRTuoyeEvt/A/KfXGxAaTetCPGGsxljImrA=;
 b=FXmZQhGcjwoiRorZwWzq0MyCzOdfKwQAMqHGBVfu7T+fuRkg8MGCSxZMToLF8qXsBdPh
 6Z67ipeO9HWjs5n5E/RsRf21MIsP7RFD3MGIS8Il2zEEPeQw62N1hTSslgIrNKMMxFih
 zUGhxTTgKET+0BjMODPiRAZDEU02F6MHeQ1gJTjZYk9dDEzcPU3WG7/VFRNYcoQAkY4A
 h4HBvVoVWI5YR/G0215EIS+F1iy1OLxBa55xHsmfkuh2Q0y/4C8u1HgGSze1BathFT06
 5180TRRTEy9PDUuEcaM0rQs0N3sWoBAY6yDNniPtpctk8aCmnFajHA7Q3UG+UlplYPJ4 mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39298jgs5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:06:28 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158I5rD3102798;
        Tue, 8 Jun 2021 14:06:27 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39298jgs2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:06:27 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158HvoBC029483;
        Tue, 8 Jun 2021 18:06:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3900w8rxej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 18:06:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158I6KfI30999026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 18:06:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B57CF5204F;
        Tue,  8 Jun 2021 18:06:20 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2336F52057;
        Tue,  8 Jun 2021 18:06:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v2 2/2] KVM: s390: fix for hugepage vmalloc
Date:   Tue,  8 Jun 2021 20:06:18 +0200
Message-Id: <20210608180618.477766-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608180618.477766-1-imbrenda@linux.ibm.com>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ss8pFI78_GVA3TEEphJP3PWftSielIPb
X-Proofpoint-ORIG-GUID: xRSZQZyiwuQryLDOJM4l9727LbvgVe2i
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_14:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=769 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Create Secure Configuration Ultravisor Call does not support using
large pages for the virtual memory area. This is a hardware limitation.

This patch replaces the vzalloc call with a longer but equivalent
__vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
guarantee that this allocation will not be performed with large pages.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 121e6f3258fe393e22c3 ("mm/vmalloc: hugepage vmalloc mappings")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 arch/s390/kvm/pv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 813b6e93dc83..6087fe7ae77c 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -140,7 +140,10 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
-	kvm->arch.pv.stor_var = vzalloc(vlen);
+	kvm->arch.pv.stor_var = __vmalloc_node_range(vlen, PAGE_SIZE, VMALLOC_START, VMALLOC_END,
+						     GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
+						     VM_NO_HUGE_VMAP, NUMA_NO_NODE,
+						     __builtin_return_address(0));
 	if (!kvm->arch.pv.stor_var)
 		goto out_err;
 	return 0;
-- 
2.31.1

