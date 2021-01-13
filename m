Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96D82F47DC
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbhAMJme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727396AbhAMJmZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:25 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XaHq135299;
        Wed, 13 Jan 2021 04:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zlHOQngHFVsjECDW2gjWgEiinuJbJTG62H3oRSZDlZ0=;
 b=YI+0L0/V8jG2Mh9jT3FUQx9rMMk8XewkSpc0vOmByy1cOMFlfsK7TrQ0bab5+VsF62XR
 RLaKSorTafwFQccp/VKpH2DnmK6XpguqG9dUr3LFCMVa4iMcr3hY9+fgHgxLE6n77g0h
 Vp11p6zqUpymZvMzM4SWFOVJf0xfc9epdm3k6DznjCkiZ8EQVU1J1DcYbzBOPLvmLb79
 KoPCZYbGy7Ndq62955VLOSHGAh4PwfhI4/qPQ3ORm97OrMVDH8Cc9kru5oVR5tC4IJzx
 xeq5pz0dtDOVidmhvSWiRhtTZbuDq/bTuqnYMF7BThB+M3ux/TwPXpzw/BWtbF75zaPk RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361uq2vjas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Y0UN137579;
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361uq2vj9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9S18i030792;
        Wed, 13 Jan 2021 09:41:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 361wgq814x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fd3q28639546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0F4BA4055;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B936FA4059;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 14/14] KVM: s390: Allow the VSIE to be used with huge pages
Date:   Wed, 13 Jan 2021 09:41:13 +0000
Message-Id: <20210113094113.133668-15-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have VSIE support for VMs with huge memory backing, let's
make both features usable at the same time.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst |  9 ++++-----
 arch/s390/kvm/kvm-s390.c       | 14 ++------------
 arch/s390/mm/gmap.c            |  1 -
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c136e254b496..c7fa31bbaa78 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5876,15 +5876,14 @@ Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
 :Architectures: s390
 :Parameters: none
-:Returns: 0 on success, -EINVAL if hpage module parameter was not set
-	  or cmma is enabled, or the VM has the KVM_VM_S390_UCONTROL
-	  flag set
+:Returns: 0 on success, -EINVAL if cmma is enabled, or the VM has the
+	  KVM_VM_S390_UCONTROL flag set
 
 With this capability the KVM support for memory backing with 1m pages
 through hugetlbfs can be enabled for a VM. After the capability is
 enabled, cmma can't be enabled anymore and pfmfi and the storage key
-interpretation are disabled. If cmma has already been enabled or the
-hpage module parameter is not set to 1, -EINVAL is returned.
+interpretation are disabled. If cmma has already been enabled, -EINVAL
+is returned.
 
 While it is generally possible to create a huge page backed VM without
 this capability, the VM will not be able to run.
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dbafd057ca6a..ad4fc84bb090 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -175,11 +175,6 @@ static int nested;
 module_param(nested, int, S_IRUGO);
 MODULE_PARM_DESC(nested, "Nested virtualization support");
 
-/* allow 1m huge page guest backing, if !nested */
-static int hpage;
-module_param(hpage, int, 0444);
-MODULE_PARM_DESC(hpage, "1m huge page backing support");
-
 /* maximum percentage of steal time for polling.  >100 is treated like 100 */
 static u8 halt_poll_max_steal = 10;
 module_param(halt_poll_max_steal, byte, 0644);
@@ -551,7 +546,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
 		r = 0;
-		if (hpage && !kvm_is_ucontrol(kvm))
+		if (!kvm_is_ucontrol(kvm))
 			r = 1;
 		break;
 	case KVM_CAP_S390_MEM_OP:
@@ -761,7 +756,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			r = -EBUSY;
-		else if (!hpage || kvm->arch.use_cmma || kvm_is_ucontrol(kvm))
+		else if (kvm->arch.use_cmma || kvm_is_ucontrol(kvm))
 			r = -EINVAL;
 		else {
 			r = 0;
@@ -5042,11 +5037,6 @@ static int __init kvm_s390_init(void)
 		return -ENODEV;
 	}
 
-	if (nested && hpage) {
-		pr_info("A KVM host that supports nesting cannot back its KVM guests with huge pages\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < 16; i++)
 		kvm_s390_fac_base[i] |=
 			S390_lowcore.stfle_fac_list[i] & nonhyp_mask(i);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index c4778ded8450..994688946553 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1844,7 +1844,6 @@ struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce,
 	unsigned long limit;
 	int rc;
 
-	BUG_ON(parent->mm->context.allow_gmap_hpage_1m);
 	BUG_ON(gmap_is_shadow(parent));
 	spin_lock(&parent->shadow_lock);
 	sg = gmap_find_shadow(parent, asce, edat_level);
-- 
2.27.0

