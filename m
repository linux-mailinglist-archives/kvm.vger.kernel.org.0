Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8B73BC7F0
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 10:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhGFIjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 04:39:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230356AbhGFIjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 04:39:11 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1668Y84t085651;
        Tue, 6 Jul 2021 04:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=FdUKfU9+eMpFfmJat8zgzYnrqAMHepw9g26Q2lp3SJM=;
 b=TG6HxPJU8ubGPWrka0uAOZ+Nj6ZsDzQv88smVPJPM4pCfXFY1IIRIJIenRIob2YJNgr/
 COMqlkftPAbpmDjCzCy2s6qIuKCk9cDiSD1GiacEcaPxFlryr+2wm6yfRBjQVdz1PIX/
 yAwtjtolrfQ58u2+ZtxZnE7Gau78J1x1zZNSDxWrmmvAesAp5gbnb1CFD9nAtAk5t+bz
 VLcertaznduAdTdGtop3lHhEe/pPSiYkvP76QP8mh8Lnlzq1VAMHRu4EI21d56UvCwgL
 mjwJnuip+slWpophgqXoGICk2Sb7KnkO0vmXHjbXWK1Do/w6ZSAKQlG9k/RqACPqs6lE nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpug5dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:36:33 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1668YDWb087208;
        Tue, 6 Jul 2021 04:36:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpug5d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:36:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1668WXME010012;
        Tue, 6 Jul 2021 08:36:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8s4xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:36:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1668aSNS34079198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 08:36:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E93F552071;
        Tue,  6 Jul 2021 08:36:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id D723C5206C;
        Tue,  6 Jul 2021 08:36:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9843CE07FC; Tue,  6 Jul 2021 10:36:27 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 1/2] KVM: selftests: introduce P44V64 for z196 and EC12
Date:   Tue,  6 Jul 2021 10:36:25 +0200
Message-Id: <20210706083626.10941-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706083626.10941-1-borntraeger@de.ibm.com>
References: <20210706083626.10941-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bdKZKETrMMqOwvCaMgvVm9ko686Ap11j
X-Proofpoint-GUID: k20L8zslU6zEkoMmjP5Rl7mku_0bFLrb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Older machines like z196 and zEC12 do only support 44 bits of physical
addresses. Make this the default and check via IBC if we are on a later
machine. We then add P47V64 as an additional model.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/kvm/20210701153853.33063-1-borntraeger@de.ibm.com/
Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")
---
 tools/testing/selftests/kvm/include/kvm_util.h |  3 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c  | 16 ++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 35739567189e..74d73532fce9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -44,6 +44,7 @@ enum vm_guest_mode {
 	VM_MODE_P40V48_64K,
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
 	VM_MODE_P47V64_4K,
+	VM_MODE_P44V64_4K,
 	NUM_VM_MODES,
 };
 
@@ -61,7 +62,7 @@ enum vm_guest_mode {
 
 #elif defined(__s390x__)
 
-#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
+#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 16)
 
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 25bff307c71f..c330f414ef96 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -22,6 +22,22 @@ void guest_modes_append_default(void)
 		}
 	}
 #endif
+#ifdef __s390x__
+	{
+		int kvm_fd, vm_fd;
+		struct kvm_s390_vm_cpu_processor info;
+
+		kvm_fd = open_kvm_dev_path_or_exit();
+		vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
+		kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
+				  KVM_S390_VM_CPU_PROCESSOR, &info, false);
+		close(vm_fd);
+		close(kvm_fd);
+		/* Starting with z13 we have 47bits of physical address */
+		if (info.ibc >= 0x30)
+			guest_mode_append(VM_MODE_P47V64_4K, true, true);
+	}
+#endif
 }
 
 void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a2b732cf96ea..8606000c439e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -176,6 +176,7 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
 		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
+		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
@@ -194,6 +195,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	{ 40, 48, 0x10000, 16 },
 	{  0,  0,  0x1000, 12 },
 	{ 47, 64,  0x1000, 12 },
+	{ 44, 64,  0x1000, 12 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
@@ -282,6 +284,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	case VM_MODE_P47V64_4K:
 		vm->pgtable_levels = 5;
 		break;
+	case VM_MODE_P44V64_4K:
+		vm->pgtable_levels = 5;
+		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
 	}
-- 
2.31.1

