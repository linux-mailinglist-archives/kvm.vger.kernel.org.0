Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953E73B74F5
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhF2PPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 11:15:01 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:21856
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234613AbhF2PO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Jun 2021 11:14:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUE0Clgrzhi8yvUriqzHvanMpVx3wiifbrxZ1Ixfk7IMuydmsdYxPdPhdHZ+azSVEdEedwvjsCH2Ylov5v7CPGzU8AibGRmRW6KwLrvYQXIHulE2HaFllc43Ph48or+tsfrew6SoofqCBlwTZ/uSiyweSYa5DQN46tuUSwkwkV+8VDQGTtKalHI4vCi7usbUnQ8UG8AkDe6S8zmwh0vW45/3LWBZR1pYEwcazsYvqy0wYwLhTWHsfxDaCEOnqbcKujwlBMdDIOCnCpm8ubbRuRumfpGRoWAnOLS4waeII/pILmaGNvsBhi74jC/jtSDYTxa+X3FBEuRXWLRNxKuB1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxv5u9AjEffeO1GiR0PBJhW7kpWnSHjYiN4f3WYMI3o=;
 b=G2WuHCQDX9Blqdi8bhD+Bvpfhp1SXGjE0ImF298AHA2Mq9NXgTfrTc7pC6tfl7nHaQosb10HNMpB5HX6Mo1r3krF4hxn8uBKzXnkP19NQnBGt4lsfec9YnSRFlYQduFm1mgFaRGbkSnyVWX8tiEyML4A9b8WIY6UtqOUbLOgAK/kJMb6X52mPeSrNp8n7v4zgl844FCZvvLNE/Bh+qmtn/9yZz/8NPgb2xJlVPsqmYsummPjeRX83AvBd4Z1Xu9E7bHRFM6lPJdmF1MOfhbPphA5fdbJ/iwnS4BZ6e1pcXNWZkyVgN8b4w4UgZzaR5YyI2ZXxKaH65YGZHBL8gBGNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxv5u9AjEffeO1GiR0PBJhW7kpWnSHjYiN4f3WYMI3o=;
 b=Y3mCi58wY4Ba1t+u7XKzoQLr7sZKpdaFgUfLZte7K55Qd+SLheoIFeXkEdo4GKRCEwGlkoS7hmkOb8Yvwsc2hxSwOXQ2psf7RvlWa2LeM+UQn3WI71xj6tZzij2OSG2MPB70cfusv4pkaV8mIgZOUoGyXnMKSUq3TKDEBcpRIbg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4671.namprd12.prod.outlook.com (2603:10b6:805:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Tue, 29 Jun
 2021 15:12:28 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 15:12:28 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com,
        srutherford@google.com
Subject: [PATCH v5 5/6] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Tue, 29 Jun 2021 15:12:17 +0000
Message-Id: <f987ecfce59e90f1b207a84715544799392bdd85.1624978790.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1624978790.git.ashish.kalra@amd.com>
References: <cover.1624978790.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Tue, 29 Jun 2021 15:12:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 698210f5-b35b-4947-0a75-08d93b104efc
X-MS-TrafficTypeDiagnostic: SN6PR12MB4671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4671442FBCD72E0B1AE1EA058E029@SN6PR12MB4671.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYeXjDFhfYlWEzBMTVCwj4Bs77tfzAwdSUXoGZioL3i8uQKG3iR4cw9J93QpfvrwdqZ/NtvZGBqWTgc1L2v8qc/UKlCR1BFHt2enAT52cTS2OKF5uwaBoajTwaCpJfk/fKXPf9LN9sd7vfYuSHm74SjhZMX/dBzfZjb/zaXZUBstxLHNuU64mPPgDshh5UJLcDl0Nxuai+P5eLl7djKVyyJRF33c9SZFHLVhqtxfKAVTxKVRR39Uxx8bU/46SDGcX3fpPSz2tUCKKURPLG35b45b0DGp+jDrRHB/ZoFEYXffy3L2Wu33YFUG7yeYNu8KmI6M/sNA/4oXyyjQ0zwKappuA/jMDb7cvHVDKZJWFi61KYI5+5c83GYmOJnAFHY3BVkI2tYjlDp/wREca44l/LfWJ6mtubagUFy0nYPpJpxWLDCEXWsZJU2dEh7mwlkehw/u9oK7sLQkyWXwx/tMVeqt21aIySvngMaYP9v3/VwqUCtP58eS6eIWCtSi/U4xqFyPlb97imICiICTpHuh3xaZ/D2FhppHy/GkhRlH0pIz1pqRKtsLy4CyAm82+n8VWWzIRwTzY/k2i6dv3CprhfO+20k6FJgOxQpGhaFkqjN0C2YCiQZ2nDXUk9kdMXNQR/f+vWKpt+kr7URu/xKxg/h+IW2ue30xKESR8HVQDiLQ0jH765pBNIxGgDxc4GydTNp4fWPWR90uxlqa+jrnPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(8936002)(316002)(4326008)(6916009)(5660300002)(7416002)(186003)(38350700002)(83380400001)(16526019)(7696005)(8676002)(26005)(6486002)(36756003)(38100700002)(6666004)(52116002)(956004)(66946007)(478600001)(86362001)(66476007)(2906002)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PMi8m2pirZ6fRGyNMytZ6bJsCzIX/SsHxLfoxcRvNtf9xVrjI7RE/1/vuPeE?=
 =?us-ascii?Q?VqmJqHGjq5wWQwqfho9wvOFQEbXuLELapYAB+JRqPbkxKbYyMsYO3ffazFs5?=
 =?us-ascii?Q?8FNgGhFxktXy9kc+Yhm+wYBkcxDruZ1+JBW1ZWnZpPIh92VgbSKV3jbJZtiG?=
 =?us-ascii?Q?RiZeYa3yW/9nxqgijT0u81bE8kC2LcIsdZShpkTvOldShtBU80ASPTtHPlk2?=
 =?us-ascii?Q?PxT91TSfVuSnuaFmE4V7Qq5RLo3e9Xizvz+71XH75bARbJyi6CHQ5e2nWgQX?=
 =?us-ascii?Q?lSmjKF3zRfjGw7qxBMWVE1FtCf8XSVEq9vJqFjBZ30CVDj/Nnl0bk2XMSzp1?=
 =?us-ascii?Q?KrfxGVOEV4sqPRbdaCj1CuzG50adB5qVrSv6PkptQt8zxsE6cepjRe+cmaXF?=
 =?us-ascii?Q?CwGtaFrHCXOE76GlEkKEJ0QO82fBzw5ILcJbXD9E3+KWGZgD5s3BYLbz1nlJ?=
 =?us-ascii?Q?RnpHqGuH/OY8lPZp1fi0brI7f+gItp8sRpVRNi+8hGSta5OEFY6xEMlLIT5c?=
 =?us-ascii?Q?YeoedM1xz1liV74Mr2fHVy7EYih40oPlWwA1WWbLkH1jxGBWo7GHLh9BOYnN?=
 =?us-ascii?Q?jGLfSWyNIukSir0uGAWq8FFgU/QSJHFAjI/RNmdNlv2rXL9ffEjgWb2bVAnj?=
 =?us-ascii?Q?Qvf7Iq4Sl8lo2D5KtBIm9ccYa+pg4IRVHQ61miH9sEjWSlHenWNaYUdXdeYV?=
 =?us-ascii?Q?203DI4rDpDum7+41L/pFE9c21pBP+tZauCaL4neba+4Z2o6ZnqRSVUNg18Ot?=
 =?us-ascii?Q?wXGb8FqqXZDaOyzpxk19M0Vifh0iF2lTa1x0qPXbU3ZSQ6MAp0b6AcciHGqI?=
 =?us-ascii?Q?qTSrHW6VPOMVqo8CJo8HvJhZAAGNBOjOqwCEP18zArjfPKIPeyDOjxLUlHQv?=
 =?us-ascii?Q?XWxQxg/B9dD93Y+uA0B42HzHTgesZjWI84IpxNCAD/bGp+1wgjvGLhUBzzZ0?=
 =?us-ascii?Q?hY3yfcvc2g/v1O907Y7lbLOc+4+mHE6oOmulUyefgBHwPrzhokRLVb2fXq6N?=
 =?us-ascii?Q?gdVD6Tez06h2DDrVqT3nAyao2/3NufSzUgVOhPTwQphfGe8zYDz8+khBXs0W?=
 =?us-ascii?Q?zJScWksqHBHWh2u+UskY8f9YTnYJFBaXgN2JjdrQLIkBaBfKERoq8JxJfybt?=
 =?us-ascii?Q?Le2O3otDYvRF64oUoUA/XF97RgAnmpWAo5uGUsEQsZCuHfqWT9ulb/6A6Jcq?=
 =?us-ascii?Q?pqQFCQGnz5KsHhtDGlQ7ndrrXR0o3Kdn+GHEwjsJf0yRtNgIDGM9p9XB+exh?=
 =?us-ascii?Q?PHXBAJdTej2+UC3zzDixFqYfLYXGAXBhsQMZnP2xmzLQIJKCfK+8aRkiMBQd?=
 =?us-ascii?Q?pbDg8TDqJBXXH/MOyZsw9PC3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698210f5-b35b-4947-0a75-08d93b104efc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 15:12:28.2010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knkgjINXdubzcg8HCVP4LC01s0Zpd7uPzzy98t7vfnxe7S9XgRvNzBFUiIO9tCh8J4SKctxpB4+ioxXpDZyekQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4671
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
shared pages list.

v5 of this patch splits the guest kernel support for SEV live migration
and kexec support for live migration into separate patches.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
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
index a26643dc6bd6..a014c9bb5066 100644
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
+	kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, pfn << PAGE_SHIFT, npages,
+		       KVM_MAP_GPA_RANGE_ENC_STAT(enc) | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
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

