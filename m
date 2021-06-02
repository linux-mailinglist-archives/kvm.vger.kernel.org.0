Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB676398C4D
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhFBORL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:11 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:30304
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232025AbhFBOPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Art7wraoDaqeAqMgiqBcDNlWm14HnU+hoE7DGcAmGlBA4Ff1ZFSH4NtlvgZSlOm2StJHtN9oNyzH4mIZ3rhdnkMdXYaeepTkl7QkswW69Whe7cpDYEkEoLdm6PMpDXWLABTspZA5bPmqLhXzV48xqnVttOlmeYzw2TRIqD0niI8PAJwHXNeAYd2rLHm/V1Y7ojiVGmVMk7BjEzk/7kKTXjtjNRgB2EAmiFlMg3drs4BBiZfb7HB6xGhMzp/kU57FzKOZbHBP+VAyZCUb/NODMZ6ye5lkGZFZDGSLjTAkM2K17U7Clzy3cL1VSOfaSnYSqkFlaylxmwNtfl94ST/85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5fkC3xFRR9pL5wKKPvCx+W+UqhkeLVogvMDzAl06Y4=;
 b=NTpPqR7xcS5REFAIAASFCcftPuKGGTDOEzookQjtxAMEl19KCsGRNCiStceKc1woK494979+8oOlStut4z+hEZi4y6298vMZj1R3Qrpt1MxbJ4thjVy6gQ6RkWaie+nXaxSODgFEfJXUAenTSdFAjM6W+VyaZ/W32gl28vI09xBdjn60rD7387r9N0jcCJPcTkhq/MtbeXr+Xv1V5WwYgrPLQ9fABSaGBwnoaq3YP+M7IKnCTv1Jb/aZqHouSUT0g6/tTJXo2yriIPtZvjVPhZu/dErsu9ZiK+W9WXrXp1HiQAVRg2IkFDw0WSgDq6JiIaL1gyincfZYiUq2nhsP7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5fkC3xFRR9pL5wKKPvCx+W+UqhkeLVogvMDzAl06Y4=;
 b=izPf25QUEskrCDiP4GRL6CTU5PgSbJwW1QP4H93m2NxHRHftn8FIfXHF/aGr8w0q498EAOgRqWvZUB0ym9YxjBFO4CSxn2yvePcFadNB/nVFX7GjixBVdeXNL5/dTo4SZQ/NM4F6CL1IHfKFgmthcXoyl+DQZ8gbNqxC3kXtK6E=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:12:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:01 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 25/37] KVM: X86: Introduce kvm_mmu_map_tdp_page() for use by SEV
Date:   Wed,  2 Jun 2021 09:10:45 -0500
Message-Id: <20210602141057.27107-26-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d5f1e87-fa01-400d-0055-08d925d06391
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592EA9255DC355B01A4C3CAE53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJRSFYg09H95Dzg/B9PnbGw7fD0db1V98XtuCo79Sw5a4uhfzROMRqYI46d5WJzrP6v05RyKYK8yfm+GoHiRb/DgbGQHytsNSA2La26R7J0v+4YFt4ZrRzFC0FAjj19KTHb+CmW0/k1EdnaME9jprlqoutiXEw14vGRpfor0ohHGUEYvqqCHFRzSF2cE+KH/pEGZsD/+h4dYUbcxg+WWWY1tLgKeguKfYpHK7cmWMjtsFzOhIAg8vMDz8mc8rhgxM0dY7g9nFlvrWmn/5jQVi9gHp++abeahbqCwfIuySG5UI9ZJq6mPDkbel3ss48Mzulk26tHstMJokf5RyQQQuBHyJbYHchQcjT9JXviOfoUy+UV/400KmjcS8Ta6tSG0VLMbTZrQob/WZafmbOB0njjlASc3cVvB4bR7v41EzlVud+N6NU/ms02thn3lxId9vVFc7JH1BX+KQZTmhmpI3fpL7BiytxYeYe5WiTwIDQSYDWvAWSVIFOm5WnDI4n1CKkUxXDLHP0/aAgs2o6ucTNapaJU7hYTtcB6PlOKtW1Beih/owJXGnV05HYNhvAiN/8k1LQogx89AI22RLuiWzpyu0NNWTP2puSN1h7xtc09HR6a8z3PQskyreCgqPRGH6uVT1aG8fEL6x1FzPbtaLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?adJ5PMZfXgw5n1+KQdL7qyk+dCbssm1N3BreEqOi3DFCHQFeN9HGyji15Ajv?=
 =?us-ascii?Q?Eo4DAgMAJ4SJBjdj3+fsA3dMRgesRAQcXVDx8bixtuqjCLrNOeR/ji1bT46F?=
 =?us-ascii?Q?vp1F5AgKSL2ydzD4hlw9MfAeErMAABKrPrCAWEVUm2mSbCnwR+v+Ax7CHVME?=
 =?us-ascii?Q?TwBngsQthuzG8xDVRu9D9WidPW8aQ+3bDaa6YLYSv6qkt1xnRbUsNBxNktN2?=
 =?us-ascii?Q?uPfY+Paxdvl1pHWxIpCBdoRIq6cSbdgaVMNgjGN7I2XVhdpPeKY7z/zJvYXZ?=
 =?us-ascii?Q?7PYsZwuyH00FgYW6f6nDl0IVLpD9pIGjxIVDChywK1Tle3W+R8eQRBcR07tr?=
 =?us-ascii?Q?PMFcuIO8l9Pvs+mjOd0JswqKrZJVjd2caYwxCOY6S3RvvH624isfJnOxIWRA?=
 =?us-ascii?Q?9uwNStdJPtomAXdK1The1rFyePbxAXaJqCRgQ0gNWLil0XLtRcnM4rzktZOX?=
 =?us-ascii?Q?gO6eSdrL+uaEqZYgSEnV6kANL9PFV1u87COQoqwd5V4C0qAXco2MsP2Zo+jy?=
 =?us-ascii?Q?bgGKCdzKnoipBvUGEYFeSuQcjN4gvK1KFIDJNSwcyfQi9xXUX7qUaq0Y2Eob?=
 =?us-ascii?Q?fVx6TsUveWpTf2kiP847xfQShePYLJfUWkLgpmOUW0Cc/ZnP7xalQCmeHcT3?=
 =?us-ascii?Q?A0U7y2n9XYQ9bTWGgl09mjuYmyBxSGZuhVM3RZ/7ty1WMkvFaYmJRufvuJQZ?=
 =?us-ascii?Q?xbtOYZczk/i5H7sZuG94BGB1BluujCQEIevEBdUHu+mkt9Tt9egKcv28070m?=
 =?us-ascii?Q?G32IykVZ/GXmVQjnF9/AkFDqCqNJCifyBTrZ/b3Z5tiTBUFzfv7pkYytmEk/?=
 =?us-ascii?Q?sYcrAhFPfewNvFhvjARTibh9Xi4XJfgESY7n+nFB3o+ZibBIJDVmUbMng2oh?=
 =?us-ascii?Q?+SlApqLWDkgJQWhMmOdu3HIkVxBf53F7ePcyE33x+7h/TDfraFsKn+oLIOTs?=
 =?us-ascii?Q?UytaL+7QliHJO3B9lOwrUWqkmkOfA7DA+f1T+70V9nQO5QAzH3hyytb2OObA?=
 =?us-ascii?Q?PtarNbIpxDtOjBGyn8HbcG9BvccnzXW0cL5XFLGucDcMFjTVeTELOW0eLU6d?=
 =?us-ascii?Q?T/2n0r/Odm+oRMMD45r8cCaZ0rL5hWBiKCUJxtq9iJQJ6IOB6EHPVFyRA8+z?=
 =?us-ascii?Q?mLfTZEs8rPALONzOvmcJASNc1M/8dzmmBbGI50lpshODc4e2HwA+RHcFTl9W?=
 =?us-ascii?Q?ujfLkXPgMQO+932v9a+DqgElLAlk8LBGSuCTq3uzkepHuY/kC6WHgdKt4Lc8?=
 =?us-ascii?Q?ztj+pzJKh1vAXq6fUfwU75phA/VBGDnTI1oZlulafomYga/H5I4KslsvQh6W?=
 =?us-ascii?Q?VElHq5rPmJ5oOt1w/xJUbDke?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5f1e87-fa01-400d-0055-08d925d06391
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:00.7286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /u1gjgtONsnUEdEe96xsGtiZ5n0q63g8/1r9vc6iY3vrZWnp1JUhmZnOHRqdMNoWfu4zDgOCB/wKtm3lwht8WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper to directly fault-in a TDP page without going through
the full page fault path.  This allows SEV-SNP to build the netsted page
table while handling the page state change VMGEXIT. A guest may issue a
page state change VMGEXIT before accessing the page. Create a fault so
that VMGEXIT handler can get the TDP page level and keep the TDP and RMP
page level in sync.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 88d0ed5225a4..005ce139c97d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -114,6 +114,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level);
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7991ffae7b31..df8923fb664f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3842,6 +3842,26 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 max_level, true);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level)
+{
+	int r;
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
+		r = direct_page_fault(vcpu, gpa, error_code, false, max_level, true);
+	} while (r == RET_PF_RETRY);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
-- 
2.17.1

