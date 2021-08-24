Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5583F5CD2
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhHXLIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:08:07 -0400
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:2624
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236483AbhHXLIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMQkUYT+6L2mGAuEGescFkk6hsXsGuXQcyn+acU1hIB396ok0ftn6Uk6lEyh99K00F4qwEQSpZ5G8AMoIVSlS47wKcUysMJhSbjI+BC/N6m7al9o53puuhaL+9HOJWS//XCm6e+vEks9yvD73/5azJWkx9QCTKG3BvTvqIbiZfSFSrFIRHlr1F3Dk6fvv1aLx3yJ3vZH2wkpM4/tQV0+WNJBcJcLPElgofYrBzwSAkxbyYlV/atPk5j5gt2K+DBJ4PAu2ol+G3TRDntSBoxs9sLZvJYWXtnwtHVSX+0gvkLJqbFzVvyZraB6nB9khTzbhBFmw5zRNsSSyaqcmDP1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjIJRxj24NM2NvlJ/4DT9cHOeuohjVrsiLWhnHXBXrg=;
 b=CS86lzcKBexZlGqAx4gODL9Tyg4P+qncwPIAPtLyUFN1eU+l0FADG9XPjceFkcTiD386emm5fJ58FdGh4knXJ0Fe59839gQh9kkEc45N1zpELZSRGAmvc59pbyjNdXNiAXzJfW2NaeuHaDr6rLO0d/TzBV6/Dm6xcdYgjU3mgvUEDbVslOu95ejMbxpLWAh5IV/8j/wd+n1JQFy5VdJJfkPekFxUTB/Bpm8TTak8H3h1b+n2Q2349xmcMRnZUvYe3URayCRhTmHigq5ZYFu9b7hlNpMO8eW9LwbRFLYZ0MoVmEBgtT0NZE4lX+PInZh/PycA2hF+oAmrKMGsBAIWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjIJRxj24NM2NvlJ/4DT9cHOeuohjVrsiLWhnHXBXrg=;
 b=GtZXfIA1P82GDL6XOwcMP3w4tORrG84+sjuvqQCIyf7FQfKPrWUDSP0Jo9o4KwyHLP3raq/Kzqw+ACDiQxOIUhvqJS+4fvG5fMMvW1J49SKEQmUVPtACZ5nzcKjBW+1bvPdx/F17HXPMQnjRlNYjcbqsIkKM0sbf7X3ik0y03qc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2637.namprd12.prod.outlook.com (2603:10b6:805:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 11:07:19 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 11:07:18 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: [PATCH v6 4/5] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Tue, 24 Aug 2021 11:07:07 +0000
Message-Id: <b4453e4c87103ebef12217d2505ea99a1c3e0f0f.1629726117.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629726117.git.ashish.kalra@amd.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0094.namprd12.prod.outlook.com
 (2603:10b6:802:21::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0094.namprd12.prod.outlook.com (2603:10b6:802:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 11:07:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a5ab36-6110-4990-d219-08d966ef56b7
X-MS-TrafficTypeDiagnostic: SN6PR12MB2637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26372B6346D7D328CCC695708EC59@SN6PR12MB2637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:205;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+d1SyDXWtQUoEAGRH42XLBIO3gNbYBflrPaYMFIwkz1BC/o6Acd88879rsRjn9qNcosAr9G+NIBz0JZHvsfdZjtzaaLV4BLCAzL6mV+a+c07WH/T+oVFhU6T9efJrHZeuuHPrq9hDmq14MdSZAvmurLx+VViclmQEHppiEvQ7KkOFaxF8hNLgnboma8P0HUaOj1MuTwtgqA+IPhcDz6Iq05/kfmw8KJPeO7LPa8jmdhrz1p6JEapHHw+o4i7yuBLtmsLzL0vRLXUSwhFqkkwQ2dXb45tOeqmMR43GdWKCp7Nah5wjeFfH4llJWqfxJIw8+1FjucA3XZi89Pjsq9Vj9dfQgQlCEK4XDWR6zAqZoCWzFAg87mx0aJU5/v35qLky+3Um7wFQFpiRpcoDLrco0rJ2BG+z7TZfKLhiUROESe+fX7Nc2dcONg49O9+6vkHfB3SXsoBHr5ZcteXc8OYYtWbH1nak8yH5z0+GdhpIQMV/EZnDgD7Vy0FytW79wr/Dz5Zxl45soxm618l/6w6ghZ9izklRVZJdb58WD9+nYLcvJVrcgr/eNhr/L0VcFWSv3Evpoavu5RD2opJyNxN/KYsEfFpci1yEXmbT4Q3ijeGMzGnrl/wSiJI6etMddcPA5ZZejMLoKIAC3Q7VOtm5TIH9OHFfkj3Iu0RiIeqjVo9akbf9xvX9tiDSHs/DBETy8DQOS9Lp6ga8BTMVgjKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(26005)(38100700002)(38350700002)(7416002)(478600001)(186003)(86362001)(8936002)(5660300002)(6916009)(6666004)(83380400001)(7696005)(316002)(6486002)(2906002)(52116002)(66946007)(4326008)(36756003)(8676002)(66476007)(66556008)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zCPCLcmiuOjfoMnyVzJv5sgP4Pw/Nd0EET8RPf9DddibxVgAaHWPJDkrL9G9?=
 =?us-ascii?Q?04aI8HrS4+waV5APNAB/yy7AK1jdjT6l3+a4UPOstz0B4SRaY4Qs7FNDWG4B?=
 =?us-ascii?Q?ofso0elD8cgmGMKZtxqUyl7LUP9CCyZZRDgOTYXq46HEdX1WVP4RHi0DisGs?=
 =?us-ascii?Q?vmIvSnVF6bYASaZB63irsf7biYLKFOzp/hMD1sOyct8dHIg2N2oiV0QeHWiw?=
 =?us-ascii?Q?Rs3/bT8AaSwHj2PMTzrnGuDp927rX+0rsqGouC68yAbqBcYJy3FTLkQt46xi?=
 =?us-ascii?Q?bATiO3RkToSi98VHesL8eBwMQy3H8bSmWJ7Pwi/osZ/X4gTTzUGDLpIRYrJh?=
 =?us-ascii?Q?oqpfiByPtLzFuZq1G7MFmsBTSEA9iUmpMh9nABccgv0odGLc5IT4ychUsoxr?=
 =?us-ascii?Q?RWoNg5oBHwZwdbNxrWv5xfXgoQGjw7XJIJPD5OXEzCSOBJcjdrBhwPeWRahX?=
 =?us-ascii?Q?8EU9FXYXwO4HZRri07xLgK6sX0JN9VIg/c78sZ5ouR/xReDOyUGqGNss+548?=
 =?us-ascii?Q?SXcxH77Tysq6OoAD5EB8jXZp6VwTH+ze6hkcSZ/4v055QlG2Lv49Rn7O4PkB?=
 =?us-ascii?Q?PN/fxwtkgg5osjl3N4V18E/l5orwyetlF6vyKF5DF3RAgjQNkrMCdFe6TjB+?=
 =?us-ascii?Q?tVo9Pn7DLuR3DfhCc6o7WlFE6RwgA1eo3olSCSy1O/1nnSooxV43FeKmlQBt?=
 =?us-ascii?Q?OdGy2riqxBxEzg1IaLiOhuJAZPdcFKM7CQ0HwnUsBOyCUCmErWTcCTbzmkfg?=
 =?us-ascii?Q?XFiCCeW1qFQ2D9oakMkTcZt5jW6j/ZTyXpTyRbrh13jVDwulm0jiAuaexXVN?=
 =?us-ascii?Q?0vzhfdt0XQz0CRQEmPnkExAmDbG1ZPIIsp3XSxMz5yRuHbt4dfimnkGMZMwq?=
 =?us-ascii?Q?44A8eUmIztAgQKD88HwE/clVKKIb5pdU27zjI2eeRa4YNIrrmvxXtZjlIkfT?=
 =?us-ascii?Q?dOUAVrNmJS+bHJ44mhej8szb7qKMJfZM5+XNP8ykdjyN5ezTnzA9Y9a90Kos?=
 =?us-ascii?Q?RgKXGnb0rYXmpTSbXn+h9FIFfZT03MfXLXYkFA7GjYiDExrjSO8LGI9UmZhh?=
 =?us-ascii?Q?/VZVQCdVqyxX+i1bPGdJilV7v8sB1VROe5uJ+Ws995mub1YMidIXvIRCM6td?=
 =?us-ascii?Q?h6eJ1b+7A1wbZMo7QS/qDIa5ZviSaxUKui8hR/Q+GN9yyiqEj4H0OLW0usOs?=
 =?us-ascii?Q?3EUv0Q3TkpfukhefXkKhA1KW6Bt7kHw0TzZwdVVl5nrkH4r8twO6nx/3gCVz?=
 =?us-ascii?Q?WxOGpNv9d11hKKx6rpRGhPb8uzN5bWw5Lb2BNv3baj286sVLhtqR0oF+SCoJ?=
 =?us-ascii?Q?uKy3/AtQlJiNH4UCMAZXcJWb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a5ab36-6110-4990-d219-08d966ef56b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:07:18.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z56xPlcpWEtwUkLhuSER4umoxzyMbswHICsqb2HodgAcDq2Cl2mgKu87Xgp+9G2LpX/v1rwyQvv/UgCdLVauuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2637
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The guest support for detecting and enabling SEV Live migration
feature uses the following logic :

 - kvm_init_plaform() checks if its booted under the EFI

   - If not EFI,

     i) if kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), issue a wrmsrl()
         to enable the SEV live migration support

   - If EFI,

     i) If kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), read
        the UEFI variable which indicates OVMF support for live migration

     ii) the variable indicates live migration is supported, issue a wrmsrl() to
          enable the SEV live migration support

The EFI live migration check is done using a late_initcall() callback.

Also, ensure that _bss_decrypted section is marked as decrypted in the
hypervisor's guest page encryption status tracking.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
---
 arch/x86/include/asm/mem_encrypt.h |  4 ++
 arch/x86/kernel/kvm.c              | 82 ++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c          |  5 ++
 3 files changed, 91 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 9c80c68d75b5..8dd373cc8b66 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -43,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
@@ -83,6 +85,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a26643dc6bd6..7d36b98b567d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -27,6 +27,7 @@
 #include <linux/nmi.h>
 #include <linux/swait.h>
 #include <linux/syscore_ops.h>
+#include <linux/efi.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -40,6 +41,7 @@
 #include <asm/ptrace.h>
 #include <asm/reboot.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -433,6 +435,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
 	kvm_disable_steal_time();
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
+		wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
 	kvm_pv_disable_apf();
 	if (!shutdown)
 		apf_task_wake_all();
@@ -547,6 +551,55 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 	__send_ipi_mask(local_mask, vector);
 }
 
+static int __init setup_efi_kvm_sev_migration(void)
+{
+	efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
+	efi_guid_t efi_variable_guid = AMD_SEV_MEM_ENCRYPT_GUID;
+	efi_status_t status;
+	unsigned long size;
+	bool enabled;
+
+	if (!sev_active() ||
+	    !kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
+		return 0;
+
+	if (!efi_enabled(EFI_BOOT))
+		return 0;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_info("%s : EFI runtime services are not enabled\n", __func__);
+		return 0;
+	}
+
+	size = sizeof(enabled);
+
+	/* Get variable contents into buffer */
+	status = efi.get_variable(efi_sev_live_migration_enabled,
+				  &efi_variable_guid, NULL, &size, &enabled);
+
+	if (status == EFI_NOT_FOUND) {
+		pr_info("%s : EFI live migration variable not found\n", __func__);
+		return 0;
+	}
+
+	if (status != EFI_SUCCESS) {
+		pr_info("%s : EFI variable retrieval failed\n", __func__);
+		return 0;
+	}
+
+	if (enabled == 0) {
+		pr_info("%s: live migration disabled in EFI\n", __func__);
+		return 0;
+	}
+
+	pr_info("%s : live migration enabled in EFI\n", __func__);
+	wrmsrl(MSR_KVM_MIGRATION_CONTROL, KVM_MIGRATION_READY);
+
+	return 1;
+}
+
+late_initcall(setup_efi_kvm_sev_migration);
+
 /*
  * Set the IPI entry points
  */
@@ -805,8 +858,37 @@ static bool __init kvm_msi_ext_dest_id(void)
 	return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
 }
 
+static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
+{
+	kvm_sev_hypercall3(KVM_HC_MAP_GPA_RANGE, pfn << PAGE_SHIFT, npages,
+			   KVM_MAP_GPA_RANGE_ENC_STAT(enc) | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
+}
+
 static void __init kvm_init_platform(void)
 {
+	if (sev_active() &&
+	    kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
+		unsigned long nr_pages;
+
+		pv_ops.mmu.notify_page_enc_status_changed =
+			kvm_sev_hc_page_enc_status;
+
+		/*
+		 * Ensure that _bss_decrypted section is marked as decrypted in the
+		 * shared pages list.
+		 */
+		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
+					PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
+						nr_pages, 0);
+
+		/*
+		 * If not booted using EFI, enable Live migration support.
+		 */
+		if (!efi_enabled(EFI_BOOT))
+			wrmsrl(MSR_KVM_MIGRATION_CONTROL,
+			       KVM_MIGRATION_READY);
+	}
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 455ac487cb9d..2673a89d17d9 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -409,6 +409,11 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
+{
+	notify_range_enc_status_changed(vaddr, npages, enc);
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
-- 
2.17.1

