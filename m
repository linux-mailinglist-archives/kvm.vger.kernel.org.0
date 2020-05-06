Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78F1C7186
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgEFNSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:18:24 -0400
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:6525
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728357AbgEFNSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:18:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIdghRBr9ZuajBWHpu8nvyBuf++5g6pIwrKlVGf74DOsYvtIAVBsFiKcfBE8ZrJ+0b8Osqo6UgpjlFfkVv111OufWgkq0y40kZd7PQe90zQn7JomZj7F/N6YciZtDBPWdQhe8/Xbaknh0Vk/QV+RZUEAudQA+izCu55kOCCqid6wI37rF9205GaagMf5miZ3f96Lz+vkSIQxwj9MmcuMLIkEsaPVpY2w6hP9RSw+kPyR+sbLIzfgA8lh5GkgrvdsvVC1yZ9vTjPtkIIXJDT59ucXrPe+mP4SnsWqxXLhJob3WXgiS9f703rChmcrAXcvKAXMpwdw0+Sy4Fbbn6Mgcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3v7wsourL4SXYCDRkuXB0Pt4sYYRiDKwervsLaPKlF0=;
 b=YYjxcE0PhDw8hi2bj0K9fJP3QSluO30idBKw5cSYkXbNwYYaLCP2XokPrEMyODpGAd+0MJ7jZ8OqpsBhLjHJtQygJ+Z9n857g//PKXtlHIrwtHgOazF9xS78aId7KKI6vc7TvvY0tr+ZqOMd48o1+wpZSahVeLjt56U3rq28HJrDhYH6D8jRPC1yGcMrqNIyfrzUtxGwMRvd+5BwuqZmMNYdW7zOJU+KyTph/FoFOZLOlq4h8Ze1U7jTPLZvW9AamhxQZ17bBltJwCPv7Kjjp9nQrRccZ7l/ENfVHDZyXHxk+wNJU5iaeHzQ/98El+E/MgzCqFvGS9YEuoAkps3fTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3v7wsourL4SXYCDRkuXB0Pt4sYYRiDKwervsLaPKlF0=;
 b=r5/BXOgjOmw6tk+UuqZujtrw/q3DGq3PxFKahiVy8SNZc6HKLEACVYRfOpCx8qXbi1iQ5kpRgRfkp9RBhO4JKuv2UQ2IEttUDOWthWueJACkcsNPQt+KqDQIxBYmNZeKJOVEQ8Q9CTghPU7KjvcCjmyx2z1tCm23TGHYOH0z1F8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Wed, 6 May 2020 13:18:14 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 13:18:14 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        mlevitsk@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/4] KVM: Introduce kvm_make_all_cpus_request_except()
Date:   Wed,  6 May 2020 08:17:53 -0500
Message-Id: <1588771076-73790-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:3:103::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR12CA0071.namprd12.prod.outlook.com (2603:10b6:3:103::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 13:18:14 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d439415a-5ec6-4af4-2410-08d7f1bfeee6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1258:|DM5PR12MB1258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB125857A1D2F9684D88046FA4F3A40@DM5PR12MB1258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCWBIHNxhEqMxq3Q+rrcZ7caL70sDhj+LcQ1IfO8HakqconFW9ENzvEd7gMZJbossg78QiGrxDB179C0Ag7cDksqTWturACV9dpLvX71useMBAK6mB+W+UDPe0XcLA6EUnHctS9IxoVxteEzqvFsL5VvP8OWYnAKnrTU5pTqViZmXDaWgqde3DgWKh/kuGUj8NoEWKZAZtO5BwzVNLLgvoqv3lnde3WKvgnOJP1WzArSuRdCpw/MzEScvh5dMgqoAMPRZVxtkvkzSZmV3FgrmGd4wsOynBOOAp0SbiR3uFQJdf3pjFUtmLdmNwMkPuahkJ8ZhnsZ3oXUuRuj938tNOLpLtOLV7R7IkpBysJS4rUu75K8vdaE2MYcf66jLxt6vYJ2PXoZus3tBQrvSlukYGuYCm+eF06UD26NMK2m2XmGAz53DNDJjCn1d+KQpdDbOJlogHs8JmatITNq/25vDFMrLbX/OH0zKyam05yPbgtZsGYCdXsqP0r2PrnHDHy2Znt8KiqZ+vD8lSXOVlhqeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(33430700001)(5660300002)(66556008)(66476007)(66946007)(7696005)(52116002)(8676002)(478600001)(8936002)(44832011)(6666004)(2906002)(2616005)(956004)(6486002)(86362001)(316002)(33440700001)(26005)(16526019)(186003)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Dj84rSuQcEpK3guW7MCxl90u3L4dJv2KsaRt0K8N2ZqH0b/r0SYzs9ZOur49RMFdSLEeC00DcpIBn+PcI5Vg4YrP/IV6bj2xNPy3gK9kFxHMjS1Xq1z8fFT8ziIGdY2fVBysE4NCJtj649TU2iPOm1+QRRViyMrHgSHFSv/zcekthUhPH+9u4d7Yi3WeXhrSgUboraG2Ta6sQPIA40ZPtRnDez4Dau+cIfKKCBLkl2SYJkLJzzw1q/3XFPrrVXQ8c7ff0X4s77KtuytEEM4b2b3NVKRsxC+tB45I0Km+iyqtnfYJ57WCZwZ0Meh+saGqRSN6NXYfwgekhRgLFLYUKfRwQJ1fmQIEuxQ0X+ifd7/sxInLlC1kd1SHj0NkXb7h79sTkNKiqY1/wgWc2kdXm/4rOnVAlW9LV3bALhVLcrijGAWeKunuqanx+39m0UHBoDqrTFHQwPIQ0ZM3DmsNZJGdqTEFw0DiF7jn6RYb94S9+U19leIDMEQq/sUMtfLNFKknI26+LwRL56NdKzobMF1XA3geVwWiqDBzOFF2O4OHEgpcfC1qhGC0sNE3g32KDMBVsF9/to2nt64QIvycFROMYRWcD5s8ap6Wfs+Qz85oOlFizOLunW6CAyB2PeWZ3O0c/HTWxMXR0e4bgb+gnSd9RqKOhqFeHEEs51q0rqNFeOu1x9mj2Oh9D0ZSSIILLdzOVvLpPfXr0RvdheTTMYDCCK+y4W7ORn6Q2/VPbLnbPfgz56wv501heq04W1B5HK/9y6B7SeLWbYh4IyWkaRYCKDpm0QyaNgy6wuRFjlc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d439415a-5ec6-4af4-2410-08d7f1bfeee6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 13:18:14.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8yOQl8garQ6ELp4eeQLbrXqH0KRat9lf/OVmacn7EtkcWyaoU+5RAhZh6zhslHkTcvcZzH3zuVfWTeMGmDpdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows making request to all other vcpus except the one
specified in the parameter.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/hyperv.c    |  2 +-
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h |  3 +++
 virt/kvm/kvm_main.c      | 14 +++++++++++---
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bcefa9d..54d4b98 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1427,7 +1427,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
 	 */
 	kvm_make_vcpus_request_mask(kvm,
 				    KVM_REQ_TLB_FLUSH | KVM_REQUEST_NO_WAKEUP,
-				    vcpu_mask, &hv_vcpu->tlb_flush);
+				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
 
 ret_success:
 	/* We always do full TLB flush, set rep_done = rep_cnt. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7900ea8..df473f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8055,7 +8055,7 @@ void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
-				    vcpu_bitmap, cpus);
+				    NULL, vcpu_bitmap, cpus);
 
 	free_cpumask_var(cpus);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 01276e3..131cc15 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -813,8 +813,11 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
+				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
+bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
+				      struct kvm_vcpu *except);
 bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
 				unsigned long *vcpu_bitmap);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7b..df73605 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -259,6 +259,7 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 }
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
+				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
 	int i, cpu, me;
@@ -268,7 +269,8 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 	me = get_cpu();
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
+		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
+		    (vcpu == except))
 			continue;
 
 		kvm_make_request(req, vcpu);
@@ -288,19 +290,25 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 	return called;
 }
 
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
+bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
+				      struct kvm_vcpu *except)
 {
 	cpumask_var_t cpus;
 	bool called;
 
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
-	called = kvm_make_vcpus_request_mask(kvm, req, NULL, cpus);
+	called = kvm_make_vcpus_request_mask(kvm, req, except, NULL, cpus);
 
 	free_cpumask_var(cpus);
 	return called;
 }
 
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
+{
+	return kvm_make_all_cpus_request_except(kvm, req, NULL);
+}
+
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-- 
1.8.3.1

