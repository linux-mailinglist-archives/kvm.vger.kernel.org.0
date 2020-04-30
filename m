Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC12F1BF341
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgD3IoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:44:09 -0400
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:65505
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726847AbgD3IoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:44:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILfY/s63BMnViIhRyEJbcxEXdoHU9gd6W/MTZgOAfkN4jEpJYvLXRv2c0mGudRd8UIGR/MT06oIp6Qkb+GnvZcwqaLoP+NkPiOQyN9xiwzdA1KR1M2MZpBDtnfKqAkavwf2vKDRLzTSgx0a+liG1vQrNjjqRB8yxxs7Bqcu+qGQiSCeZIrR9Gcr6+6B+vWp1+poaKzaxvONBwiTTUoTdVCbHx3xk38TlHHTJtUNiwQAVJmnqYdH9/ZUVHVoHsDrOrOawFTPKNVMKoc9kmrdBhZvfyKIqfNqGt/O171Akv1YVfUCJD0ADvOVHZO8XCkVqDWZwoNsFf1/hFSItqK3D0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQDCVeMKIfaGig1049n1T2F6f1dFD41S9/diaiTH3r8=;
 b=boCWpeT39Napz9CNJBSrEKtZiZE2+wHv3pEHMZjgR19ntQE5UJLKrLaBJMeQPSYHIK7PP8xaZeutjvyV1bO7/TkVa8op+IzoYaq50RBlGp8mRiyXcCOwKh5eYTvnm/MB1rTVeltnwRxYC9di44t/PYdOwBtpNWBpc3D4NrKYiyustMxuBAzdnZUMSVnkTBMzRbhle5+3yfI3s52mlf6cVo7FyKcROH51g0M4/I4hrpMj/MnWr2mXMUVDM9vjv4sL1M/PB3GuV0opGRwZhyXElMZ3I6N+Du/HCZ4uI0eFPCSWmnjHXaXPMWtU9GhFN9yEPb3l2BGFlfRpvQQNDNhkcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQDCVeMKIfaGig1049n1T2F6f1dFD41S9/diaiTH3r8=;
 b=FabLR7HsvVfh693rFRe7fWC6Ok9z+cUAPUq0ZFr/NsieijOcfwCPfStIQvOyvYLzQZ7Z8pBo01AfOqg4/nonwtb9CaOzMpCe7F9cNzPsWtHhN03IZxz0onphW2F8A2OLQ3yBN38uEZclKtEIxZCoptl0r1HveBFj7xFycfIYiLI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 08:44:05 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:44:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 10/18] x86/paravirt: Add hypervisor specific hypercall for SEV live migration.
Date:   Thu, 30 Apr 2020 08:43:56 +0000
Message-Id: <d0e5e3227e24272ec5f277e6732c5e0a1276d4e1.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:44:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4dcf4919-9c68-4254-f468-08d7ece2a40b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:|DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB188399537CC612D6D8B120F68EAA0@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(478600001)(86362001)(956004)(8936002)(26005)(2906002)(2616005)(6916009)(8676002)(36756003)(6486002)(7416002)(4326008)(16526019)(186003)(7696005)(66476007)(5660300002)(66946007)(6666004)(52116002)(66556008)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDuMQol5YnWFabbXPn/Ze6x3mbGBowDR2dr45qNx9tq7cC0T/BrJzPXMCbrs42oagUSO7LZm1pLzZjyZSeNe+4f5ECnPEvlYt+LSX0pk2lTO3RFHI+jnzeGuDSu22dt6DYbNUlNOHZ5ireZjkZXqc+WidcLkoZdjBKm+I9HVO3L9X04CWTWlk7ibH9TBUBUQ+KWP5vcqkiGobnva2WkHtVMXTIEgzc+J8K2WFKiV6jayJFLQ+OZdMhe83ONPSTRJGxaTbOvq54z4YdXAeCZn4737EwXRsVXeK6V323ZnHD3pzHrziWYVz/yT+xV9kx9/w5HCDVQEiaQ9uzoskbaNXCUUZDYFCaXOBj2EmilrgWZs6Ql1+W9tCB0Uxq8eeroJ1RSwGjRaAoUKrZA/+FLiOog17LFjrqPydtLlIa0MQH37I4YxDhGFTdbrPLzg1mC/CEu0We8PcvRNI+0g75UKPLRcL2Aou73TW3krJintHR0++/rcFPYYYm2EfaTMFiJI
X-MS-Exchange-AntiSpam-MessageData: /sJSpTx8cMslcrefE3SePTJRPW1nA0TkL2vEQ0lmFaYXmL85YRZkOB1OnFLPBfUVabo6Bbs3i+E+nhQFAuHC/G/PeqGZjuJCietNGFHUVGzmJ1/hTWLDZMFao8adtnUp95lMzcD9VpdP75bnMSIxmg1ZijejUE+wGldF7wOFQd7xo76aQsTgvrbyqvYy2p3f0sHPiCFZG/heW9ct4P2XZUcYpc8WkYtqoW4XEDcQPXa22khSqNEJzTSoQirQqepX8WdmFwtQXWo+bzsyaouq963oLOTdzlXV0qka1IZIVpEyVLuANsexrzPpY7d0em8R3B3DrId5Tmuo3RxJHUeLMAIZ5qsDRnnk23/YVH+CiyVpiBzHFZYsUwu+4S+uOr6pYZQ2044I8y3+wysQtbF1tYL06sBi74mH3uu2Foh8WydgZCLRFLiRfLBVgKUdqS3nEgsLlUsAmcL/2wR6X9j+M6xjhWlS/ckkhSzO1ioCxIk22ICBtl+t1VjxmrFIwr7rQUuXuIEVvMKXh+QOHQ/VIirRnadxzs3vbnLZujx575Ub7RIIKlxht9bSVjA8khMnpvBpk9iJyBDIOty8sav3u8V/aqB6XoOi3OC1Fssdsp0MydkVAuCSr5PhZ7Fp1u87Mz/ORFINhXcKl0w4wbUeshAm6cUr2WjMd7jrKASBp2tGp+PbIkkdJxNwNLPdZFFJ/7d8iLupg5mKrXuB1FB+WBCd0NG2+nNMQqwDskPzqoqbtdMt5HMoWE+xJ4Rg2HiaFjrxB+IWB9EaYnO85BA63hUC1aENYf9FGaCQIdL+YiI=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dcf4919-9c68-4254-f468-08d7ece2a40b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:44:05.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwnVni2KMgZ259hZjUZk+roj4iKLJPxLxJD6XGzYPIAgsG66iJa1/1A4DshrAcjyXj4nMeXF1Sql20xrkIeZ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add a new paravirt callback as part of x86_hyper_runtime
(x86 hypervisor specific runtime callbacks) to do hypervisor
specific page encryption status notifications from the SEV
guest.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/x86_init.h | 10 +++++++++-
 arch/x86/kernel/kvm.c           | 12 ++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 96d9cd208610..888dca30a17a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -238,10 +238,18 @@ struct x86_legacy_features {
 /**
  * struct x86_hyper_runtime - x86 hypervisor specific runtime callbacks
  *
- * @pin_vcpu:		pin current vcpu to specified physical cpu (run rarely)
+ * @pin_vcpu:			pin current vcpu to specified physical
+ * 				cpu (run rarely)
+ * @sev_migration_hcall:	this hypercall is used by the SEV guest
+ * 				to notify a change in the page encryption
+ * 				status to the hypervisor.
  */
 struct x86_hyper_runtime {
 	void (*pin_vcpu)(int cpu);
+#if defined(CONFIG_AMD_MEM_ENCRYPT)
+	long (*sev_migration_hcall)(unsigned long physaddr,
+				    unsigned long npages, bool enc);
+#endif
 };
 
 /**
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..928ddb8a8cfc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -729,6 +729,15 @@ static void __init kvm_init_platform(void)
 	x86_platform.apic_post_init = kvm_apic_init;
 }
 
+#if defined(CONFIG_AMD_MEM_ENCRYPT)
+long kvm_sev_migration_hcall(unsigned long physaddr, unsigned long npages,
+			     bool enc)
+{
+	return kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS, physaddr, npages,
+				  enc);
+}
+#endif
+
 const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.name			= "KVM",
 	.detect			= kvm_detect,
@@ -736,6 +745,9 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.init.guest_late_init	= kvm_guest_init,
 	.init.x2apic_available	= kvm_para_available,
 	.init.init_platform	= kvm_init_platform,
+#if defined(CONFIG_AMD_MEM_ENCRYPT)
+	.runtime.sev_migration_hcall = kvm_sev_migration_hcall,
+#endif
 };
 
 static __init int activate_jump_labels(void)
-- 
2.17.1

