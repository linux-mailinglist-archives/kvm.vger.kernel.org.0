Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ECC3F3107
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhHTQG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:06:26 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:45024
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229772AbhHTQEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:04:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4e4I4WQlD056UUR+LDDow/+cjcoO9crrtoA7KQxA/RT/uu1vpDQqPcs+fw6DmBvtXHuEEZe/Bjg4a+mOl7V3AD0ZPsTopaBA2U5eCbnkMFTKs3dUWWFzoAM1Pjo3sk5jb0N2SKPbFBiUWuyBT9OEiECMt7IN4b1rFUmy/M6MGlZOJAUumTbWckak7kcp/S4HL2pqzcOof/75E/dGp/ZBXA0Z09fUCaOW4GByCP7VuAFx1PYTzSN7z1/TPyfqB4sE2/e4jCWF6jCZ2GaKl3VCXrJSgdJhgto2bhUWizpl+i33yZthQWGUTZ6a3OwRu8Ocsn9QTz2IHdzU+fpSJUE8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgGy54dnJkrivIr9eJV5SEJ/kD8j1HP7vpZl/8sU0RA=;
 b=ZA6fmE8B0z+pSqvVB/UC2GdVhG0NO9dLgDblIHycuMZddqSb98amAeJBf3pKgONUWVFlu/pNtnYHTN2YX2jIPE0gNejn3R7SdDdNcBvdWb3oSl0JuqcL4onndbXRMOkORu/47JNIjqGiUpAy8IDtZNuGDTtJylNwmboyMCJM6boK97vme0hYBgYOQM29Gw8s8DAXqBCif244tx89As12/ZWcuGzVMDey3n57CQlgDjhqq6y6+rI4tx68yhTczdbhhqsH7qraLPfqXWgBZn67OYgMTzaz6+P3+hWd0vEF3wRLYH0BaYvPRE6Vu2hxGlUYVrETgXotfle5dKP7tp0Kbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgGy54dnJkrivIr9eJV5SEJ/kD8j1HP7vpZl/8sU0RA=;
 b=EVRX/8qCGaI14kUNdhV4IKIUAM+WBHbRSbEfdULq42NicloGRfmB70CJVzaj0A99XIVyh5d+OnZf1v9XBHwaYRgEFXvjpeO1gID3PZt3SzKOE7Wgnb3vTyZ+YDTaIBb/IbowFc9NPpXV6noztkWfgQKEP7Ft/91UPU3YH+zNvkA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: [PATCH Part2 v5 43/45] KVM: SVM: Use a VMSA physical address variable for populating VMCB
Date:   Fri, 20 Aug 2021 10:59:16 -0500
Message-Id: <20210820155918.7518-44-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bde20be-330a-48cb-7b6b-08d963f3ad3c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB450904703DC8F3CCA9729FDBE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGx/slJKI788K8bBwDS3vhaYyv+Y9cv0cE13gSgkNjfh6lUbuvlOmFWV0Ja235VnQ2tbqYFykDY8hlWa+MEQmih3bocDKPiHBe+LLcIP9lGm17YTPW64NRe/Aj/SiM1Uy6Yc+CYl1XkSqHau3Oai1wTKt2AHneJtUd0b2pZ3GOkvx2yJNsuHHiR7Dhb+Gyhdrg3oWgjFBgYa6GkX8FrrEXCWUPTgXiPdlY8ZoADzlzZsuHGuUKMMx49g2kHCGlGBF4i8xdecf08oXHyCXA3q3tdaIvUTMWHB7bHfB7e7OGfiGZJtJJEdtf0nMm4+H//OL2xct1XFFU8sn8Db+0Pe09CxD0PNiW75pO07j3YySLGhZ414qsb7xRSF9cdetZDL+0HPU99RYdOAtmTfYqL46Kh0aGQns7xLwLIS/LGNIRrgL2D9bdYiXJ65HkNHWr12EHg6qDP/2BmVHDK0hhbAniFu60v5vAhYUQCm4f08E0w3Z1bPP1cgd+5XHrKHoO9gwXrLJhrraBYH1gVj8qdyewvKGMlM65RlbPiSatFnR9z9GG0KyXF3x+F+veocIa4qKofOnLOAfD7Jq6txzSgqxVR95TmTdNqPzXarcXBlWyUAfhwnSXbGjDpIN/H02JUIYbcT2neuJlQLckCShsCLeUilHmZ0YVOU7KoxL/kiT+PkruwlLG7WCTcJrEmyXUp9wXSmxauOgMFqvzs9Jgt3EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4JtmKJWKk6l0BlUGxidwA87nFdQ++XUtG8DhXe/J4vSVP0OkR7T3LuhtibVU?=
 =?us-ascii?Q?jUCqW9/TGzTP/d8ckJQtrWMLPdVShQxCXCBqi9EQ+qGUcQBSXkCXTbC+rpt8?=
 =?us-ascii?Q?OOby9q7+n7VNQZDpu64w+nJNz8XvzY1nWWKXldVrHoK+fUGsuzEF+oZSmkd1?=
 =?us-ascii?Q?OXR7xOsjRpqLZJ+QfqFHG5RqHhn8cjhuE51C71S7jcCfzVs2b/DZXzXgaB5V?=
 =?us-ascii?Q?8+j4TdshecaA94duvjWDM3943uLAHBnIGY+X4xNBZ308yboQr5wCOVHD27ya?=
 =?us-ascii?Q?QFJtiKZq+JuixI+R4nIAAM6HXZQQzRF/C5ve1mHoHfwkXmqX18m80ajqzaIk?=
 =?us-ascii?Q?igi+8XUhM70NjF72YEXeRaIqbcpLvvNXSGupDrU0b7Jv4Cw8/pBb/AndeO4q?=
 =?us-ascii?Q?22fd0fWxi0wK9pwydDEVfspmSCeHzqqtOcNe7Kec8ZisRxyKeilVMiaWGFSE?=
 =?us-ascii?Q?gxG1tiPljYbEDtitaFCDcpKYvIU6+3eX/v+LcC0Sk1Fzn2ov1H7enLNoh9SG?=
 =?us-ascii?Q?DOO3peAsjCFoks5i81WyHzZ/m6m5Tx/P2C1+BHIMxrIanLeR7160IVXUIQtF?=
 =?us-ascii?Q?3wwK2U2gkqi9V6mNE8hzo2RU9n03PfAcf0sbHSA1QqndOsgKPGeBnsU8Es4n?=
 =?us-ascii?Q?gkmP6/jYSgtkd4C68Es7ut60F6Pvb7s6WoAq4QdMu7oQGqJIVdobtJXGtP2O?=
 =?us-ascii?Q?7dB7kuHpdrAY1ZjPvTzx/6gZ0zgY/dJyYelwSsDhmBb5Eud/z+Hkowf8peHR?=
 =?us-ascii?Q?PW0UWQELeNJddT40lL5zAhQ9tlLW2hxgn/8ERRP2T8TkSyNhG69PwWW5Ou2D?=
 =?us-ascii?Q?9T60ksTfBjbgZoyMxrE+TbOsFmcqQQeITL6p6IeibamF1Nfj2psCaG/Kslwo?=
 =?us-ascii?Q?hk0AlppuXQr4LdDnwhCcWEzHlkJrn5lL0kXYTV55T80NBJjLR+MBefrQwbKa?=
 =?us-ascii?Q?/dvx/bb57uj9ILVfVImIbtVPpJ5/2aoQO1Gx1El8W0TBEa00G7lRjII1OI/q?=
 =?us-ascii?Q?ThGM5KFy+u4DdbYrO16z0i5QVJv7uwyOquD2OvCkqaDeXobsBlBKtlZeYjUz?=
 =?us-ascii?Q?6kiWoPKgbGGEYSXyluOJaupDoRfAiHJWktP+gPpiVbeKhpQTpZ5LMLkrsfiP?=
 =?us-ascii?Q?FGYZT+pnnljHFfT4STa4qOt/qeDPR5zubUKwOQUkAM41ARizPQwDc+lFiHlh?=
 =?us-ascii?Q?9qLZfgqshgzaa+tTAuJP8fgRjB78D98SjSU7T/u9pgpkyYkAxnSkCov5iZ4o?=
 =?us-ascii?Q?AWmj8HSbon5KHqPFzBbLoGqhO8nUFDgUtDPIcWVzBHJpJMvSVCBUeBWRvxPh?=
 =?us-ascii?Q?3X9WnR8lGNYh4Uk0Mb2kxteB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bde20be-330a-48cb-7b6b-08d963f3ad3c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:48.5969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxkdFAa+z3sW9ePyL7RVdF00vj7kXWpz66ufjoJb2UviR56CXNznBXbO6Q5TeafIivNANRNf71K5sMiT7LwxUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 81ccad412e55..05f795c30816 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3619,10 +3619,9 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
-	 * VMCB page. Do not include the encryption mask on the VMSA physical
-	 * address since hardware will access it using the guest key.
+	 * VMCB page.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
+	svm->vmcb->control.vmsa_pa = svm->vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3ba62f21b113..be820eb999fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1409,9 +1409,16 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->vmsa_pa = __pa(svm->vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 71fe46a778f3..9bf6404142dd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_svm {
 
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
+	hpa_t vmsa_pa;
 	bool ghcb_in_use;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
-- 
2.17.1

