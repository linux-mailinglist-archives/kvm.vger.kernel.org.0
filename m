Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277B6347E0E
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbhCXQpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:10 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:48321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236580AbhCXQou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYnif2mb+NCyB7NfFyT+1D9Y4tDK1AuxQ7/Yqwt3ixVTt+3lQgtNL1YWoVNzMQFjBbj1RqfpvoYvriZSRz5vrmUUqV9s9irDNq0qSDrm5uSkfzTH2DN88CX/nSMtWwAv18y4DTiaFYGzYP2C4LVROoH9KNpFKSAdpczOsIMb7zil8hrmbhMxySB3XcnSFnjqNjcHF+YtECk84huDCsmlnH3ULEY4pSOrn09JOebcp/OHK3kwF06awcpXMVyGGNkEe13YSvlI8nv0kiJcr98pok00iYYj79drm4Ogi4Yuhi0RdjTImj04GQGe+giryd1AB+5V7hwVpYQsbwWF4cz95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGRspJr8QjsByc2IlG+O6P638AIgKqnJz9n01zB7Wuc=;
 b=RDRMsD7v9Il+PU2nZ4TRvypvfGPfVqCb6DuW1zwASGot+e4njqmKBay1wD5Svh24sAsEysQ7LCRg1Hn15lc9bD6vivixkHKlPxORdELJr02KxMS5LVgsnHmTIE9faezCb5ypHfzVIhYH4/0CIYXX+b8tSrwiBlff1NLaSg7iwUimGSiywSo/Ywxgp+l2+Gn1FdWNbZ7lAeX7t30gU7iYTjhivQVC75JE8Yw6zgwROcqZmvlDmxM78s9eSkLsHkeSWnWyyoFmdC7IlvS2bc4n05ysI3RjT6yE0WN2tZyvgi8z9Qaa0w9jmvFOikKWE5yGU7TICpZIMwtQLMWwWYbYqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGRspJr8QjsByc2IlG+O6P638AIgKqnJz9n01zB7Wuc=;
 b=fgjNRfeNhyD9/t0bj44FnoUjIfUisYeLnWc40rTWuvzfGwiEhBfWBUFY+unIjQPE8SS/GWcVXTIYPouYN2SC8emV70U5xT6z7dLHlCm6jShrFBWkipfpNMwtHEF+8ABr+P1quTGsG6PUs7fi4DvdTmfnBPpt99S8AsGj17g4RsA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:44:47 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:47 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 12/13] x86/sev-es: make GHCB get and put helper accessible outside
Date:   Wed, 24 Mar 2021 11:44:23 -0500
Message-Id: <20210324164424.28124-13-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79b74ff0-9e16-47de-e2ea-08d8eee4225b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB444612E216B61598FB05DDC2E5639@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haIJP+KHpLLQUghzP9gfLI6P0n3PrMaVbMksJfLcFeG67PjrbbXhEpOiAVG8xKD7BnuBXg9uc4i5iZaVoSS7tVSMZYpRY6e3IxC3H+vi8IA2scEkwviinIrBpv2XTAZBYBYTEtJ9hl6fSq8dodDOq7NFgngpRmGVshQHyLfIIGIrPQoqLjz20YuWtXAONu0BYjCl5M3YFyusnD/4RGb3CDxwKz03f6m0Al2R7EAbec1pgleZ+5zgPMRW/OHImKvVw0QW4lBi30TVeDLEwHVAHs7clHO3ZI1LbJgifijJUHpiri1D+SiOHEHeBLn8sT/8ng/Pr0qje+diuoHc9qH5k4eV6GEPbzywGXLBe4b2sFdw1Kxd0Mf1zwbcKMAZ3RuPdI9gP6u13rFARYpcahbot+NRnx+mCALYzFCGnpjPhhAL7CVakmygbbjx7QZiTGyi/SrBQUeBng1xZLYzLqdoSSwMRr1TEma0Whpkl6U+tQoVCMtE0t5dyq7r0pM0qJrFeLDqynfrabhGehqilyfMbJn/MeNatPUNGMcpHQ+kn+EQX4iaPpl0uyJaprGQw0powk41qw3yMJ94eAI/8ZpiZvOeTxiezk+3Y4wFE38U8PtonZzbO83l3le6aJIILwh5pXma7bksL20cDzTUqIkKSi/ZMR7eXPMKVEWgKN5uvVw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(8676002)(1076003)(4326008)(6666004)(38100700001)(8936002)(956004)(2616005)(5660300002)(186003)(66946007)(86362001)(44832011)(36756003)(7696005)(6486002)(7416002)(478600001)(66476007)(66556008)(52116002)(316002)(83380400001)(16526019)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ozt0Pahxbe/Jy0knm8i92oTB8mqjEz0IQwgExkyODMqne5MWKEkJB2HFOr0e?=
 =?us-ascii?Q?uymqnAO0ZQ5h0/xiZl1qcTCwTbaaHl8pmEMJF4ViwyL7Xgea4ECe1VeRcWBd?=
 =?us-ascii?Q?bIC4J2vH5xSONVr28NWgvI4I1zhrSDM6XgdWgnPvpSgDR7Lk8oqddGQdotOw?=
 =?us-ascii?Q?V1VJcStLnk+AoQnhZwgPhe7G25pgN9ngqSA9PpcRlLPPmqG8QHiYedazmaSy?=
 =?us-ascii?Q?dJBQGsCq7pU2v1tW7q7r84mBK2xKoisc68r9vLbsp+sUtnaevr0kwDvqCm57?=
 =?us-ascii?Q?YlNABGrEpeAU5KmD36+hhwxGwfz3OAttFfytMq0H/43Bdtwif083YkAIyIBX?=
 =?us-ascii?Q?MMnuiZ6jT1UMb8d5G3je+D/f+ZZPyDN8sCWRXREtI2VEDLrDTwg1xOd5O4lz?=
 =?us-ascii?Q?7CuuMFxq1UMxdH2qNjADBWRvPppWj9FhnegMSO0STtZ0voSooUDNaK4p4RWX?=
 =?us-ascii?Q?QvJHcH6pKh+aL/MzeAsBiwv0q+bzvIj5GfS6hmuiGT6kb52ZRU5MFfIsVQ/h?=
 =?us-ascii?Q?VAg2v3XOWC8a8xtZ1Vd2ezvZhKgEpodAOnK/n1ZFPgrPSS73I+Xjp+1U4LYC?=
 =?us-ascii?Q?RVmZonyIBnene5gCMqs59f5zMWK6gF0Pei5O8AM+hAfcF1gtCzIwpEKaqcFZ?=
 =?us-ascii?Q?nd3g7dgEfD7WFAfPXUi5UTFMDAfzTloPau2kYhLxjOmscRYixcWtvfBigFhP?=
 =?us-ascii?Q?U8x9YJV46RupBz94OuqOo4ps8IdHbcmMktiGWEjszYyQsmepSVCUMk//H4kp?=
 =?us-ascii?Q?eBcE173633BoQPybgMMAW7EF76YcSEy/9F9k8BH2w4Uw/gqXIZ0UJI5t+vRp?=
 =?us-ascii?Q?CpkWdhKzySLULD2BAOfPowiDzX22SlEt2fhLdR7E2WavhCJLCSHlQ3RVWeN9?=
 =?us-ascii?Q?ItuInVXXkaFeS4E3K0gnzVbcjHRoEi3SvsZIubjF0zIKyWpzi72E+1JGxU/Q?=
 =?us-ascii?Q?TwlCwZv+RdKIXmuuY81cMR/mkgPf8kDEioR4u7og0ca7aSfGE4BViu34ODwf?=
 =?us-ascii?Q?c/DHMze7LHDtHUR+3w4fycrq5To+aUtM4vOe6rU3L5OZNg7L46OKkEu/D9EQ?=
 =?us-ascii?Q?95PVyigS9BBpg2gef8dEcUv/8Q2Q0J2pLnv1wa8GBTZSmHLLE7jmeYaD4VjH?=
 =?us-ascii?Q?ma/9qk8ry6lXmafebbSnMW8GEZvKvdb1ynv8Ou3NbzHBRKHNhGxYogTadq1s?=
 =?us-ascii?Q?Z8f+WAX49RbjgKlGYCDvgGY/v/rQkwXfcTVipYGyGZoSQAppaObNuq0czBGU?=
 =?us-ascii?Q?8+P4w3zG6lVKa58AV/yKrx6PGh4k0+N5EK6eN4wqc1oJhbd18lru5NR5l9qN?=
 =?us-ascii?Q?+Rs3i4mmVZiCGsXz0v3HYeFO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b74ff0-9e16-47de-e2ea-08d8eee4225b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:47.0715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ay3vy5RAU5NvJkKGBACOrjE7tMRa61CMhnC84OzbGhySW3JpgnC8TbR4mD+4QbD80f/qMuKprSJUZqLQSp5mwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP support extended the GHCB specification with few SNP-specific
VMGEXITs. Those VMGEXITs will be implemented in sev-snp.c. Make the GHCB
get/put helper available outside the sev-es.c so that SNP VMGEXIT can
avoid duplicating the GHCB get/put logic..

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-es.h | 9 +++++++++
 arch/x86/kernel/sev-es.c      | 8 ++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index cf1d957c7091..33838a8f8495 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -81,6 +81,10 @@ extern void vc_no_ghcb(void);
 extern void vc_boot_ghcb(void);
 extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
+struct ghcb_state {
+	struct ghcb *ghcb;
+};
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
@@ -103,12 +107,17 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern struct ghcb *sev_es_get_ghcb(struct ghcb_state *state);
+extern void sev_es_put_ghcb(struct ghcb_state *state);
+
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
+static inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state) { return NULL; }
+static inline void sev_es_put_ghcb(struct ghcb_state *state) { }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 004bf1102dc1..d4957b3fc43f 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -98,10 +98,6 @@ struct sev_es_runtime_data {
 	bool ghcb_registered;
 };
 
-struct ghcb_state {
-	struct ghcb *ghcb;
-};
-
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 
@@ -178,7 +174,7 @@ void noinstr __sev_es_ist_exit(void)
 	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *(unsigned long *)ist);
 }
 
-static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
+struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 {
 	struct sev_es_runtime_data *data;
 	struct ghcb *ghcb;
@@ -213,7 +209,7 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	return ghcb;
 }
 
-static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+void sev_es_put_ghcb(struct ghcb_state *state)
 {
 	struct sev_es_runtime_data *data;
 	struct ghcb *ghcb;
-- 
2.17.1

