Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766781CB988
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEHVKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 17:10:12 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:6195
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbgEHVKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 17:10:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVUSBfBMcMX4UAkaxGG5+kfDLH2N72f1okjYAydHU7XhM0mjOkDG+TgsG8vqbCeL065Gf9CK30O8XH2qQTKDMJwIlbjZ0PXrJB/J4pGDPt6+CW9Tg6tT2A2nHZ8MIvOaru5RSg9gd6Er7QPua/Dgin9sDWKTTnlM1dovT2XOTdRgfnHeWohOSTBJq8aqcViC0qMUbSByfLAxqFFGecARIXaelgDK9J9hOoDVMvF2e7V00N2ih83LW4DpGbRgNIe1c56oi33p7L+NlK2VdHtxseafs/2gSDOp6NxDjP+afb5yLQRVl5XGqYSCXRvzijJLgpHpOmCrdkBV27icxD8wew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7cQjBBEUu3wYAe3qFF+Q4q+ikFV3K8/pZksdsSFtik=;
 b=d+iwfMZEKp0UtzxfbkZL5iikg267opEdWi0rRiyYrQgwGF+tteIBm+S7lvA5k7e4XmSeHvNo33k7oQR7Jr5qXCKy3FG8hjT6jp0N+7MXaevGr28nE9EvaKbwzyPgJdkU2ueWal/HTvR327s5DyKSxMeQOvlLWK2r+oHFHG56xBEv4/pD8nfL8KKzaW9FiTyu16qSG0BwxISvMwSsgI1KIa0UKIMLuRRUR1c8e0bksvcWkGUISKvwND/ITDLqJwzf0DSd/RX/Ex/KzS5+tuAylb3dMwForvxoVOXeQGSyoaJsIu81iHIdX3onvh7u4gqU7tJ1AKNNtc2wDl0BG7APZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7cQjBBEUu3wYAe3qFF+Q4q+ikFV3K8/pZksdsSFtik=;
 b=4GzEIB/7GN4SSXjlfd4SFeDRF41GQ3l7ZmvVz0XakgJahi+ZOEiL47rI8y9lHbU+bQbOm7bq833Z1cJ0er2PLMZsIUkVvdx+CXO+e3fbb/tse0Pc0ivHf0/HfJVLLycZHeyN4xjXOuhvSuZr13UoRyU3IRr9CwohOgI1wke5GFI=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.33; Fri, 8 May
 2020 21:10:06 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 21:10:06 +0000
Subject: [PATCH v2 3/3] KVM: SVM: Add support for MPK feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 08 May 2020 16:10:03 -0500
Message-ID: <158897220354.22378.8514752740721214658.stgit@naples-babu.amd.com>
In-Reply-To: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0066.namprd12.prod.outlook.com
 (2603:10b6:802:20::37) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN1PR12CA0066.namprd12.prod.outlook.com (2603:10b6:802:20::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 21:10:04 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5da47f9b-0196-4820-ff14-08d7f3942e76
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:|SN1PR12MB2591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2591550799E8FDD5ABFA899495A20@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2fpKlxMPB0WtA9WcGaSKnvhp9iAbhSNX/RlQKo7ZO0H73fN3YUvw46/NvXYX62ziuYY8J21wHeIvrEkGMVJqB3RpAikL/Rw8aE4U3HRI/97AmkCoseiL3phMCibZNG0RV2b5GW/VV1nu/FwFJQWg0A0iAyAQ1Mpz0ScDsEx4s6leG6XVpO9+yC4mEKnzHpTCqfxtaE2pRLtlxZZNn0M5QWBYI9imIrb8TGlGSPH2xx1ACTTu9VA3OTXeM3aBXr5zgoZMZZVR8cmogMBoVbkTCWO+MzI3dsNgVric0dzsu3OVlqKWgrsj4Q5BlMDC+kAddWuyQQztRr43qhFoeJxP2CMW2nDNHF6s0isRHphYJYuEh7SrWedvYa3JfQlOnQ6CwiNhITzfEH++rILLY81VzdxULKyWnbhO5I3wPrOElTwn66UWqhbptBynuyPTr4Z7/gtnSpX87ewYBjeb7G6YoqSqTV7ZFHvubfaXkIjMOzRH2YDzKxyvdH3Ai9QMJ7Mfx0hm9n2G47G/Jud5lRIDWMd0oxBFRa2aiipYLmu51njBMaDv2uuYjMzUMUMBV0bfJwXL6ItccpGNX03eK1AcN3s4kndXjX12LrrpKxC4XA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(33430700001)(7406005)(16526019)(4326008)(7696005)(7416002)(186003)(26005)(66556008)(8936002)(52116002)(316002)(66946007)(66476007)(33440700001)(2906002)(44832011)(956004)(478600001)(55016002)(966005)(5660300002)(8676002)(103116003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vDIc+C8A82sK+GCKYtnrjZxq/WY6WKPUeUS522oecI9QItXHy1qlksaLGLXGOzOJgNP1sTrWqB545b42xz04Fr8FOGDr3hFf3/y8Wt6DWjYerN1j7FeRq7IEDthe3YE0SqgroHH5q1cOU2KiwPicAPTUcBCUDOxWhkC833vZ6l0+CPjXT30+ksJUNxB34HDAYVElLiFb7qadUMkRl7AR4C6Ozp8cdg4RD1oJguZZ79EumJf3J9lunKfjw4HOVHHnWuMV/VB6wlU+kTF6LgdstP+sGGcXL8+66YHmM3SiH2VEaGAIPYFOXfjMYVdpb37wOf/YE9ztrL9AIGEkA2DDZzUqGC9GuXchEh5Ij3nKgF+OqPohuJ3UbUhspz1LclYp67ZC7uFjG6TFacP+NsTVDmEg2WBZ5Y6c3Bqcv2XZGy3+BQywEvWb09Z4LL5OKN0BQJGeWwAmvUABTn6KjKyVUQcijjJbSHIqgzSiv99mTe8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da47f9b-0196-4820-ff14-08d7f3942e76
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 21:10:05.9332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Avf/LB+qAqwgRCC6OQN+2sfUUsb0H7tXWZop8lJwdf6Y7paRQUsp7kQlZQYVHoEJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Memory Protection Key (MPK) feature provides a way for applications
to impose page-based data access protections (read/write, read-only or
no access), without requiring modification of page tables and subsequent
TLB invalidations when the application changes protection domains.

This feature is already available in Intel platforms. Now enable the
feature on AMD platforms.

AMD documentation for MPK feature is available at "AMD64 Architecture
Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
Section 5.6.6 Memory Protection Keys (MPK) Bit". Documentation can be
obtained at the link below.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f379bacbb26..37fb41ad9149 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -818,6 +818,10 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* PKU is not yet implemented for shadow paging. */
+	if (npt_enabled && boot_cpu_has(X86_FEATURE_OSPKE))
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
 }
 
 static __init int svm_hardware_setup(void)

