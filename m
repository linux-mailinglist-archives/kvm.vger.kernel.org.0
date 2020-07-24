Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6122D281
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 01:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGXXzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 19:55:23 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:27873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726769AbgGXXzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 19:55:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5qOIKLe8T1TU64u1rfDZW0RA40pDnDv3SXGKCVQ7SgqgtmBYLKsnJ5Ye0CQe/mKZsIH9bDJUNcKQ4ptHAsZsymtHfCmphwfS9HwO7ZuwOiFFPc5t8XhRK5vjz3J1WEnYpvBDs8DWgqsy/d9Pz2Mw99l5PocsqOnViq2H/qaZ31anLUiFLn12nB3YZQiBWg6Gln5HhW6O5BlG5krdRRFePvKCBWyjaUgI6pwCXL8ClMEiuYRu9np79nv+GUpXLWUBnaNhhiIIpbbvxhdPmDnOCZ+74zFaNN0X6Eyg/ZjnfaJAElMFo+CDZ2usFW6We3VFhcQSabPVlWCDCzKxXkjpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMkoW3oWYAD0DMKhc3n1LMSCl3LLGJUpGzo6Ht5E1bw=;
 b=Ha09LRBS+ZUibXXoHOs8Fps9YC1cIhMEVVQG/Qp2P75FfI9JJEdhTUIaoivI8x/PxodvQkEWU6gmWy/3tRDzV5Zel83S0XUDlv2Q0IDvSuEg0pK8Om2ME0G4OSMZO4KYOUtLG/1E1ST9OvPtd1cnxq45P5qBvRVSZ+nx98tOsZVilni7r+TnJmPn3F8ZYvedBvgM4pO+r27HQMgbbiEGlHhks5GHrzz0wxwo7spWCDNr23SxYC2qAr9GsZphmAOsZfz2S5vF0OmtKTs49Uqbm93/Me/pAoA2e+MtUXn9iZHB651SmZTB5l96uu3VWK225Ym5kML6bvFvZafhmnY5Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMkoW3oWYAD0DMKhc3n1LMSCl3LLGJUpGzo6Ht5E1bw=;
 b=NUzwi+1G80DurWFTgGiPORR70teLBTu5ssA//DbPE9I0m90+/FPcYnisens8Br3zqgqd3jYip2tp6+d9fpKkSsf2lw0bPMaAuACKiupMZNWwJg0rJERbiETa6g+GaffNimmebeBMmXTVKYVQt/O4HbyJKy/t8tbC9xVBh56Uxac=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2652.namprd12.prod.outlook.com (2603:10b6:5:41::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Fri, 24 Jul 2020 23:55:10 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48%8]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 23:55:10 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        evantass@amd.com
Subject: [Patch 3/4] KVM:SVM: Pin sev_launch_update_data() pages via sev_get_page()
Date:   Fri, 24 Jul 2020 18:54:47 -0500
Message-Id: <20200724235448.106142-4-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724235448.106142-1-Eric.VanTassell@amd.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:3:9a::19) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0033.namprd19.prod.outlook.com (2603:10b6:3:9a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Fri, 24 Jul 2020 23:55:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e17e373d-6eae-4d57-b9f0-08d8302cffbd
X-MS-TrafficTypeDiagnostic: DM6PR12MB2652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2652D9AD80213B1719025FCDE7770@DM6PR12MB2652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29G+MkvVIDrDbq4jA99mNPaxNHp32ax5jaHAJVktwGC4DpNFm2AaFB6F/Yzm5RVHdBNGZzxuGu8SH+7jGsqC/oFH0ASCg+n5GTYCS+pEpVrHrn21Pg7fDDFx8y9A5YxzQc7g4IGPwluD4SXURlKtmnSReRDXF1Io5uMiPxiigjflzmiyiuM7V+W/rEGKp4wKTrknqjjpdC275Rx+56zFvhyhMelrVN9IBsTWsIbBO00BW7is1Bv7kJmiS4ON6r/x7mFzq0FCQ1Nb/tN0q5YEijPOz31Ey3wWPo1KfHKXEg08iILGwjaKEoCFAEE6Q0C+vk0O/ntKem5fUi/Wv9YdOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(6486002)(6916009)(36756003)(8936002)(8676002)(26005)(86362001)(7416002)(7696005)(16526019)(2906002)(316002)(186003)(478600001)(52116002)(83380400001)(66476007)(66556008)(66946007)(6666004)(2616005)(956004)(1076003)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Kk+UbxIEGKCOxgnDbGYmjX2ooKj3rgrfrmP6lQMq4FlOqj/PBjQrCUXdM0/bvEPfymu8b4fokCTFEx8xSNEMSMvE5EoEaRF7FYSCFXyNXpgWcS+jkUt9leJqq1jM/tsbSH0OPLbWtda5jNY9XaYAEgrYU4m452dl8Af4h+zfGGCb6gSDNKghs06lPcYGmrZp898VUSwvQpcA8Zoq9oRqKjED6bMk1u61bT/d+YDodKSr+PKHFyPHLRJpKy6d1+5m6qBMYiWJgdYI0GtKRGnDenbPKxC3jhbT76jzSCpnsv4rDmrjZCvAFVALS4fVhmtZDX9X9zkq3IQSWxquePWcslLuhATfKbuUsT0rKDyVTwHye+XIyzJGwg5aiV2YWRIlxrym5zel1Q26pJOOKDr35LmK/ppN6tjdEfkIjAXPS3WWiTkQJ1jiXG6Cm0AgqfyiVEAeH9UU0rmQ6F9dQxyvQ1X6hQZW4AGdkwvvNa7SDl8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17e373d-6eae-4d57-b9f0-08d8302cffbd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 23:55:10.2172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uV1Y2Xe4lJM1h2qntASeypYOjJH5CLScvQkn3Wo1VIrGNMTb+iAxScqfbrKIvpu0l92kuNQ4CtLG8X8yXveCDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add 2 small infrastructure functions here which to enable pinning the SEV
guest pages used for sev_launch_update_data() using sev_get_page().

Pin the memory for the data being passed to launch_update_data() because it
gets encrypted before the guest is first run and must not be moved which
would corrupt it.

Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 040ae4aa7c5a..e0eed9a20a51 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -453,6 +453,37 @@ static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
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
@@ -483,6 +514,23 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 	}
 
+	/*
+	 * Increment the page ref count so that the pages do not get migrated or
+	 * moved after we are done from the LAUNCH_UPDATE_DATA.
+	 */
+	for (i = 0; i < npages; i++) {
+		gfn_t gfn;
+
+		if (!hva_to_gfn(kvm, (vaddr + (i * PAGE_SIZE)) & PAGE_MASK, &gfn)) {
+			ret = -EFAULT;
+			goto e_unpin;
+		}
+
+		ret = sev_get_page(kvm, gfn, page_to_pfn(inpages[i]));
+		if (ret)
+			goto e_unpin;
+	}
+
 	/*
 	 * The LAUNCH_UPDATE command will perform in-place encryption of the
 	 * memory content (i.e it will write the same memory region with C=1).
-- 
2.17.1

