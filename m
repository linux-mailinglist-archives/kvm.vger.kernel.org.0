Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7E3F30CE
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhHTQEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:36 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:58929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233093AbhHTQCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjAxHnGTbRuqdIp8z8+3xvWUNgJxMroeaw5EUmoguIkGguPKsVZiwU1bg5M9IRthh18cHpk5ue/aT62w7uFPSE/wDorHnZ8zMNoRDhh7IhdJB3JlFZWIOhJLFB0PuxZ+1Nmlxis/O8Rl+vI+o3tpinl3aQvjGzc6Cwzy/tbHsh29MW/bBqVYSXBn3/esxA3roBRB/uh3F7DLzEwM8W5/DTyoN+EAClLSuyEoKrqKeFnYbZwgyHrv/uJiAh7G5T1MPCFRODW13cNujcVt+qjwugKZEABOs/Eqt++ZRG+iiikxhpLz7078uBoDkkNAe2b+SV33U8mM/TnIZz8nPgI42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP94SxoFqNd03EOGlUpc51w62BGvCOVTDriTneq6T60=;
 b=SYVb7Hgc+n6x4q898sbLmdFrXr0cxkS0ikDB5ZIMBJd7yYaC1GqY2uE1HeV3Tjb7CDzbXk8PuDLizQwgmfW3QH14/D6ea1YYQsh4D9XROm5dt8pTN4iQmDT8mp160c8bRnN40TSUkjIUra6t94E2BLMVz9rO9ccF3iseepvqOSaaN2F0ssLcttJAmJujSPVhUwZ8qW/uWfWzpPAaBIuyJPR0jNdPWB9sRBdkbPDjZadUkCcG+B7lWNOHWeC3gvSvF+5PydeYlQ0MeOmdKqXlXrds5xwS6d7aZRFp1zBTqc/+LBOBSpk0zYtYwGXV/qCKY/HnCskosbBFbmhDSHrCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP94SxoFqNd03EOGlUpc51w62BGvCOVTDriTneq6T60=;
 b=18DYd1PhqoqETwZqHWw874E5wVC+4XIOFOiUMDv151QhlDCq18AmHkxSTLnZF9HkHYDP7Z0d8Si+ndaMLV+8PZYB2Pjd22ah0a/sWhB1BlHu11jSmBRSe7HY3Rg4ahr+FQUi38LGMcHBCN0hTHoHKk/FxlYG/Sxu5QVr7X6LaOM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:32 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:32 +0000
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
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 30/45] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP
Date:   Fri, 20 Aug 2021 10:59:03 -0500
Message-Id: <20210820155918.7518-31-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8dbf6f4-3a72-4302-b926-08d963f3a38f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45746170C9FCDB23435DB567E5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwknKwWUD+Qm7ORkJMQAPR7pB41RMj6/GZZdcc68dB7Dx8QiVGrRMFQi/Wmb7dz6/Eqlp05INYW1UIAjj24ywzhHO0wqiLjCT9cmT+xUETghVQEjYWpONqRJadcyif2iG+MA/GTA47Z7Dh/tnX4+NJJjK74YT8igmyVeWBb9WTgYFJYtgSidrFXibLl2OG7iTByMlLBu+MeQuOL3jIAdUl8R9OEanGm/roU69AU+6N1mW/a4YvL0OY5nEK0DXNi/bO8K6DJJgYsk3beMdimbNA+fRhrS33CyZMvsGsrHYjVHkpFhLm06G4bYoi7xo43nUunlxjJbl/NX6n1Uq58ZJjMUllG1OXEs54aW5W4FwUOOFqQjNz72BFY53DeZwTjPAS/Wlg0qp10zgrpzCsEeyFUr5B5XZIs7rBZk1Y5inkJoKMR1mo+SoXl1o+capy1KNZWibB3XsJkPBTHtpohR31bh4QWYUbdG/TzQ1up0VAAI2+pZmBW1hHzk8R+NUBU42R/IyNTURgv526r/PEkdkh/4Tvw4j7yJ0AoFUapOdpepwubWWfIrQ+cchFZ0YfRPbT9DLfa/At9l82sf+LhEnwP2bwD1w2z98vR5+WS9BSaAli7FpSSErJUJ/OcVWe4UFFOkXhJQh/Qdtg7cLG6bVZZEPAJM79fmELApWYpbjQYUhQ1Vte09iKay13qhBST8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gS+QGQgUkGRkpD19SDZu97B+ec7ahnWTmr07kZBdmXfMRMz0d8S5Mp35JmUO?=
 =?us-ascii?Q?LglgcHRY3Adj8pjErDkKvSYzRF7yaL0E6lWEAPb6/RC1e/ju5aZumlGvQiHf?=
 =?us-ascii?Q?NkIfaPxh0iRNJkAl6ydpXdqg7DIdBdV6mzkaIkcAXXmPbwP60fM+C60ejKON?=
 =?us-ascii?Q?8VuqynrchXWME9HZ5zbsCscj6vk3SXIoWpi1J1R+Nxq3EIB+uyU7qmVUJ33t?=
 =?us-ascii?Q?j9mexDg4wAMEq9dL3J2ohRfNRSoCPs1o0NNFgAH7OqHpC7xTw0yPq5UR/jpq?=
 =?us-ascii?Q?5rfaJQKcDtWT0E+D/QBACbVJWXYOu0fbI/5yMGxexcws9Ynnp3TU+jio6JMQ?=
 =?us-ascii?Q?Is5QSHA1tV0TFXPY6QEy/XdOv95Awz2K3w4ZyTpOQlK/tvfgcLFzvTmwZwbB?=
 =?us-ascii?Q?YDID6IW5rueBGw+FBRkPuNx6VBOn+1hj3GC1oGSlDly+1pGxtlj66RbEc7nT?=
 =?us-ascii?Q?duMy6kKHrcoKYIFmmcUdMILP7V1nSWzk5bvgWg4xRmWDuOrzr/B2APxvl1HO?=
 =?us-ascii?Q?FlAAU+kuo9uCdVB2CiS2cDcXjBhPWJe8umvVSLMnxGw0Stx+O/vMT0LhAibh?=
 =?us-ascii?Q?EZh6tcettXLgio7jlOmAvKhNMuUZUjSOvX9N9ebeCh+5/FhDk16473CApgsl?=
 =?us-ascii?Q?0yzdD7Cy27Yom8wWNSv+VNFXpYgcVXMnbrNFO/V21x5OwYJkefsfky/+0/tn?=
 =?us-ascii?Q?gqxDPjLyTM/mc2KgC6p+oVsCLU2pt7NYRm72DZ45d79LnBRWozUTqUme7qj8?=
 =?us-ascii?Q?W7fRDkKM8DBlNDfzl6K+Bj0GV6MmKwHvLh2YrhBCfu8Pn8ES3Z+b4UkBONw0?=
 =?us-ascii?Q?t7WEW/o/K1xJPAbdtnJahnyUd4eyM2SHzGwoJIXG0UHmTMnGF6Zwlkmav1sS?=
 =?us-ascii?Q?hkj6ZEy5645oOzwLXqLTRhE2Ot/64840td4qhCELv7RWH+6lt4nhRQ1JeLna?=
 =?us-ascii?Q?X05TqmqYnuS+RQ8+7jX1nT17DMqxFfPBDTIMNtIxoIwagQNVpslwKJ5H8g9x?=
 =?us-ascii?Q?Fsbm9V2wVruxEeZW+bEDWDFbZTzLiHt/zKZAyzW4KzZNfqLu0kAZ7UMpAa+0?=
 =?us-ascii?Q?LkRb2U61oRXYxnM9AkZi6YfNxoi/gu57o7uN8uNDQhFFLyG0Eyfz5LQbhcqs?=
 =?us-ascii?Q?xuZyowkoJrMyHKIOlNCtp/8mrycAU9MQezti8SP2wroprOrfglMIJvo5jUXr?=
 =?us-ascii?Q?cLaaIJb0vkAxm/Dg7lLMaAwIkYXCis67xOm8/Qp+eVgC1jIqMNVdSUjBP46M?=
 =?us-ascii?Q?LOqUwoDnmlby0xDH3w1x+wmt1WDDqOFM1Cdw9r3W4qDEg8n4dUhwmoQ91Yr6?=
 =?us-ascii?Q?ai5bZPq2z38/aRzfbXId96ok?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dbf6f4-3a72-4302-b926-08d963f3a38f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:32.3812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLGAgpLfZZQ+NkEpiLzARwIpRrD9NjD1WZFmN0pWd/HL/VDuKER6bW1ptPelwIGIAJXMCkquMzmKKC3GdVo+Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Introduce a helper to directly (pun intended) fault-in a TDP page
without having to go through the full page fault path.  This allows
TDX to get the resulting pfn and also allows the RET_PF_* enums to
stay in mmu.c where they belong.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 83e6c6965f1e..af063188d073 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -127,6 +127,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Currently, we have two sorts of write-protection, a) the first one
  * write-protects guest page to sync the guest modification, b) another one is
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5cbcbedcaaa6..a21e64ec048b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3948,6 +3948,31 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 max_level, true, &pfn);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level)
+{
+	kvm_pfn_t pfn;
+	int r;
+
+	if (mmu_topup_memory_caches(vcpu, false))
+		return KVM_PFN_ERR_FAULT;
+
+	/*
+	 * Loop on the page fault path to handle the case where an mmu_notifier
+	 * invalidation triggers RET_PF_RETRY.  In the normal page fault path,
+	 * KVM needs to resume the guest in case the invalidation changed any
+	 * of the page fault properties, i.e. the gpa or error code.  For this
+	 * path, the gpa and error code are fixed by the caller, and the caller
+	 * expects failure if and only if the page fault can't be fixed.
+	 */
+	do {
+		r = direct_page_fault(vcpu, gpa, error_code, false, max_level,
+				      true, &pfn);
+	} while (r == RET_PF_RETRY && !is_error_noslot_pfn(pfn));
+	return pfn;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.17.1

