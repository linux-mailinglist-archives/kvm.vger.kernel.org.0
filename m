Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B3A2C92B5
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388969AbgK3Xea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:34:30 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:9217
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388949AbgK3Xe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:34:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sqkv9m2sJMHnzh7uIcGGZZ2uMXcf5c213kT+XC6artpDIMaejCTdut/QT4gNMWTWF2CzQZBcIwo9rrh6LA/mT27WXg/sXNx5GFcDgXr8Mg5v9y/npGGo7cknRrx8WyFL2+Eub06mIybrNCYTvmI2ZtRL7S8yK55GgZvzw5ogr9bi6AiVQNyDgM9b4+WRltg4t4Cz3QDziwGT3B32w0FmmPnscfDQBrQgDyk7OrnVNJWcHcArj5W9M/7Y+nBZx5hN9J8O4QZt5BUnKsvbhz87L5nEUl/UxeBj7x5yssmVU8M34ErmOlybALcBY1GUYV27sNR4AS0LIdae/xwhg0DHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ez+E+ZdxtGGPPZQ8bYXP+fWYSNIYW25ERPpDKhCks6g=;
 b=ZvK8tOp4x7TYyjY2rjbF9eaiOBkehEqR9HXoIJg4g55sOeeUuHpJj+V7uRwJyS8mHHub+CWBETl+EbwL68Z7nW0TQkzN+KEw2f2lvBRq3woArPuD5V2x/hkePhrFmFViz96r0ofgjVWlOIcc91yvQKo5YC4Zv2Gm73Ax8cDsonXIs8cllNBF9+1YSXp5fRAxJ8mg5zgLokKd4eHJOdjdEvBO/2Co62qZLpikr/02hCgPw6rE6CB8yxLt2nbaDAxCvCP+4mUN9gVwv3WP6LnaF4AWfmZxxAexruRazKaqCNOMoDRm7RE0ze9i/OxgzxkZTB40rhBC+aeyO7GsTNnTEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ez+E+ZdxtGGPPZQ8bYXP+fWYSNIYW25ERPpDKhCks6g=;
 b=KyNl4OiSbwt3KK8HO06NlfO6rUY7ruDldhFN3TAVoSnat3D5EBQHb1nkwgOVbH1PVZQOmbm21/7xcd3RXmImefGsziRNC1fN9+ofv24TNL9EERUrNopenXsykuxprAHFwyFvMxHR5wZ0QGgHQMPE9Nr2cTzFF/65UARhDzeY2W0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:33:40 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:33:40 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 7/9] KVM: x86: Mark _bss_decrypted section variables as decrypted in page encryption bitmap.
Date:   Mon, 30 Nov 2020 23:33:30 +0000
Message-Id: <dc9ce1acf9817b0a13cb8ac3de21be20abcc60d0.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0029.namprd21.prod.outlook.com
 (2603:10b6:805:106::39) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR2101CA0029.namprd21.prod.outlook.com (2603:10b6:805:106::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.2 via Frontend Transport; Mon, 30 Nov 2020 23:33:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c8369755-3b85-489c-15ba-08d895885e14
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45097B9F35BB59AEF16159588EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXFRIpOrnNmMCYew1nbBIDLzlnQ9vYc8VhJDylg6YChUYi7oyD+PXDMZB80nN3bXKyj2y+xAMA6fteAbsby62guzqyI2zGcDa/Y2vLw+0+cEQzKl5ZoT7YsjQR3WJxw35sD1Lt4nCDDVTbZc5pPSj59OsbVs1qcYlV7U9Ue9zK00kYq21Ou1OtXdYWkORfYHUzo4k1Jc6QIneC0VClko25mOedu/U6At7RQXtR50lddJGZSJKEzEHIa13GhgiL55DndhrRKr757eSsN5f9z7oPZKNThF6AeE3JdD2U5tqOCbOYOyhM23mBeTZM3m79AsBwEmuE+RsqWbCl4QNdvmPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HUgwuatq4QayFFwfl8es/izFXy6UFWBkcCbW+N8oOCAb/yVdef68h62aUs+Oofeph5yTjZftBxk3bfIvC8He+/ADWOfVSshImBCC/dNnyxO5Be9V/iZPQJVMqldiMjvP8aA3fp4Uar//OdQE3kjxT+/F2TThLqAck3OtQVBt7kYCRXVBf/jJa+SOrY+f3sO4wARnW3HUkYYi7tuYcszpndjdZPeGIkNqnzJVgos5eFFtU4L49HeEaGFjPvmWth7pXsPy1Cmx7wmcNNo64EwTjo7U48K2Nv0iPG8TDpifkuqeHl/sJRdxjRIeuxHpsndGOVHw38C8DVmYXZrFnDGLG+/NRu6YgI8tUKmCxkTKn0Dg7Dw40oUoy18o74OKTo8COaurtclfTDsDct16/rOx9ZPRz2U9IuLxHUmMUAsDgEQh1v2XMuBzW6bK0pQ9PwtZIgSTeR7D8zFSN0Zh62zc1jVsWpTQvhZR52zpbXRcBb1vqLUnCm0r40XZObVollfHtblaaVAU6TEq71pdzTHUbbkzYWmRWDRd2pPb7/uPPDjTofTu/ciSvAY2wyvpXva7aw9uZ0+56c7ZBjZrUymwuWt7in6Cpa5NT3DX8rMKhSsQyZBNyAS6xnjWKWuRM5F3wcU10i2OHedvtXQgy7rqpZjghY4qKf2NJjJaq0ZDJhpEeZj9pUOf1a+GDfDhXPB8t5vzBBJad2D8UkWSfOM8789HTC8glEYFgdBWTVZ1Ohhe0TLXuGQ+qVQbhrkHM0yV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8369755-3b85-489c-15ba-08d895885e14
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:33:40.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B40LiPQHyWKasFgWgB8u7it2OK5m/I8pSmscKXUKhFCQR1SHXD+E+ctDXYrnLZ5g7EByopz4JEK3o1XUlwFDeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Ensure that _bss_decrypted section variables such as hv_clock_boot and
wall_clock are marked as decrypted in the page encryption bitmap if
sev liv migration is supported.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |  4 ++++
 arch/x86/kernel/kvmclock.c         | 12 ++++++++++++
 arch/x86/mm/mem_encrypt.c          |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 2f62bbdd9d12..a4fd6a4229eb 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -43,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
@@ -82,6 +84,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..94a4fbf80e44 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -333,6 +333,18 @@ void __init kvmclock_init(void)
 	pr_info("kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
+	if (sev_active()) {
+		unsigned long nr_pages;
+		/*
+		 * sizeof(hv_clock_boot) is already PAGE_SIZE aligned
+		 */
+		early_set_mem_enc_dec_hypercall((unsigned long)hv_clock_boot,
+						1, 0);
+		nr_pages = DIV_ROUND_UP(sizeof(wall_clock), PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)&wall_clock,
+						nr_pages, 0);
+	}
+
 	this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
 	kvm_register_clock("primary cpu clock");
 	pvclock_set_pvti_cpu0_va(hv_clock_boot);
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9d1ac65050d0..1bcfbcd2bfd7 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -376,6 +376,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc)
+{
+	set_memory_enc_dec_hypercall(vaddr, npages, enc);
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
-- 
2.17.1

