Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5C24A2A8
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgHSPSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:18:31 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:48186
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726951AbgHSPRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 11:17:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7Ze09sw1lzpKbMSgr4SaZTzAu6B4ExsoyxO7ZPUHPtDX1DEF5ICxdw0whakPfOBo8QlezpUTUh72nwYn+3R+4Z/CYJUDphzypZFsUG+vEzgveVyftk5E+B0wLxXb1bREwB9PFAwdMZa2LRxLUVIrRzF8pqzDQkaLn22s91B3G6qvVGBjWleE43nLaui7bZQJM+HIATTDCscaShfWRjVia39i9gCzNprmxx01XJZWQuzAyZEOuDRyX3ql0kkTPyb+pkb1/oMWv6FJij/kQNaKSU0rgCUqX1CSBytICsoskisbDFzTw3/D3VoH2981TJooOXhTeoTTtDbrgCMKj7mYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz0EjzPbtP7r/WHnhnHVKye2vpfYurUcEZzPObigktI=;
 b=L8oNNrJy4eRtOKMSfTshyNa3+9erPUkSFLmd/WB5/O/FAdj1UjdU7AZKU2GVzRL0sHoR1alLN2qCKj7nUokDx5qbtMK2LUkgq64DQAWVcZRwom4AFahjslfqVMM04WdKzOwlGBFP/7lsnqDFHQX8KaXboarJWydm/HSRQXIusQSKUVT1AWdY266IPu+q0AyW+fHThQrTLWTJL2YnIhor6Dny9NQSw0MxmljFfgRBjaevkSK3W0LIIrTHx/iyAMaubPC2MhOidiV7bbARkh5DxqK0RgwOVUWXHLQwP9QQ8xNqqvrdbUMEkfDxtYH3oX81bQGmbTMNslwUX97lUpHB6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz0EjzPbtP7r/WHnhnHVKye2vpfYurUcEZzPObigktI=;
 b=KEamFOrdRSQDTyn7cJngiydWfaBl3wnYBnELNOlpeHf/rFp4+UrzdVrSV0LCZREaCRxzYndjRTvV3BRAF+TD/Vae6bkc+gf4ta0p+FHDjShyQkGC6ZCGOPB6OCS0/tgH3RR7o9Etob/an6cGNtijmheFyjiP6S9ZaKzo8JNS2fo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3227.namprd12.prod.outlook.com (2603:10b6:5:18d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Wed, 19 Aug 2020 15:17:00 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 15:17:00 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, hpa@zytor.com,
        mingo@redhat.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, rientjes@google.com, junaids@google.com,
        evantass@amd.com
Subject: [Patch v2 3/4] KVM:SVM: Pin sev_launch_update_data() pages via sev_get_page()
Date:   Wed, 19 Aug 2020 10:17:41 -0500
Message-Id: <20200819151742.7892-4-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819151742.7892-1-Eric.VanTassell@amd.com>
References: <20200819151742.7892-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:3:9a::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0045.namprd19.prod.outlook.com (2603:10b6:3:9a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 15:16:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee1bde45-b8a9-4e6f-5535-08d84452eb59
X-MS-TrafficTypeDiagnostic: DM6PR12MB3227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB32272BFDF16C720FBDF39700E75D0@DM6PR12MB3227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7IVoySYaUmQUu3Yeh7HvMYR8rDw5N9rCB25aqKZ6PqMOStgTKcQ3NK8fRvKcvgfzvp+4b+8mz2cI7OsZBP0/DdVC1ccO0QuQlhV4ZfpabBFO81F4htuih9ap8yGTqB7QwfAMGZ1gVIhjkZhydXdGXRA2QthgQwFdM8BwWwWHyNEW/ghC71Sc+z3MGwSY3LmntcfNEeXxFCMIheBAJ8pV8PhB2cykhwLULfDVg9A4JoKajaDmkKFVIDsH4wQ0pzcI5amZyDiAAebItLxsrLGIL/QEzEbYpzZVBU7gmM4cJFahLIAz5JSH+/ddIb8j3kd5WpfVH85LxEpZ2izY5Agfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(66556008)(66476007)(8676002)(66946007)(26005)(86362001)(1076003)(5660300002)(478600001)(6486002)(36756003)(316002)(83380400001)(6666004)(7416002)(2906002)(8936002)(6916009)(4326008)(2616005)(7696005)(16526019)(52116002)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: w3N3JBp/MLyhSkF+aHd8MTDb8A0C2z7Yt2pjJIO6kKu7Y3nJG/B4kkEsWjc3YpXag52CHF0N9B7qpAafeaNlw5VGpmd36pBSty7dcTySDyOUHVKriT/WitRDFeo4j5o/E/KAKpxLamYWpHkB4VW/AhLgLruEkldKKIvq6cHeNtpQ6SUc9r1BsDLLCXXE78BhiSmxS34ac0tTutN4uBht/Q39SP9R/wbICp2t+e/VyITfDoOtFBgGtGIfXZEG1ZKC3kxrI0xx0eFf7FsP3mPsPDJFU3d19fT8rqrzhm0/aOnxYmk9IS2na3oT2GXL3gpjJxz2ayX5gVm3Sym9xgX2VUxc0ayfWkSOfXO+C0oRJe3ZFYD3rMFob6Aa8Nw2J9s4HzBZuXjeeaf3P/JofEstiD/NlCZFnQ5Au0bP8MMb/u2kX93KVLuGI6H3aBNApmIcrExSTz8j2AXgCqQGPCmSSvSgNQwObE95E2BJJ9t8C2KlZmn210eYuy5xEMxnWNLHyXxG74RtaF7CtmZY0HwWfuRjV1oUkIYzIlIKRzjHsy8AVS8X6zfdX8bxPy/SGDMSYAhDVaFBTdqlmKOFO98A3KR46uzptbDUV0CUw0I5vH7EaQYztBRl7+PpvKthr7IKo2btYXIvSHgaOVyZS3wQdg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee1bde45-b8a9-4e6f-5535-08d84452eb59
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:17:00.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ZQenWGgSMu6y87EliofdQlPCledpGkF+Ubfj8qHvdngbGuaogYd0ZLbylvXgY//IM6+eLupMnOZ/OnprKhyUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3227
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add 2 small infrastructure functions here which to enable pinning the SEV
guest pages used for sev_launch_update_data() using sev_get_page().

Pin the memory for the data being passed to launch_update_data() because it
gets encrypted before the guest is first run and must not be moved which
would corrupt it.

Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/kvm/svm/sev.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8d56d1afb33e..4a0157254fef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -454,6 +454,37 @@ static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
 	return 0;
 }
 
+static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
+					      unsigned long hva)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, slots) {
+		if (hva >= memslot->userspace_addr &&
+		    hva < memslot->userspace_addr +
+			      (memslot->npages << PAGE_SHIFT))
+			return memslot;
+	}
+
+	return NULL;
+}
+
+static bool hva_to_gfn(struct kvm *kvm, unsigned long hva, gfn_t *gfn)
+{
+	struct kvm_memory_slot *memslot;
+	gpa_t gpa_offset;
+
+	memslot = hva_to_memslot(kvm, hva);
+	if (!memslot)
+		return false;
+
+	gpa_offset = hva - memslot->userspace_addr;
+	*gfn = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset) >> PAGE_SHIFT;
+
+	return true;
+}
+
 static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
@@ -462,6 +493,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	struct sev_data_launch_update_data *data;
 	struct page **inpages;
 	int ret;
+	int srcu_idx;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
@@ -484,6 +516,31 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 	}
 
+	/*
+	 * Increment the page ref count so that the pages do not get migrated or
+	 * moved after we are done from the LAUNCH_UPDATE_DATA.
+	 */
+
+	/* ensure hva_to_gfn translations remain valid */
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	for (i = 0; i < npages; i++) {
+		gfn_t gfn;
+
+		if (!hva_to_gfn(kvm, (vaddr + (i * PAGE_SIZE)) & PAGE_MASK, &gfn)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = sev_get_page(kvm, gfn, page_to_pfn(inpages[i]));
+		if (ret)
+			break;
+	}
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	if (ret)
+		goto e_unpin;
+
 	/*
 	 * The LAUNCH_UPDATE command will perform in-place encryption of the
 	 * memory content (i.e it will write the same memory region with C=1).
-- 
2.17.1

