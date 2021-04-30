Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA536FABB
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhD3Mnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:43:41 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:14433
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232664AbhD3MmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIuPoXFueIiljBQQFxYBsLMHnVQUO7nRLvDtLaj/Sw8mIyw/A3SUjC/IYr9jp1HU1Nne0/Ios04mLY6OTNTCM5mc0EksizS+UVMae91TGNrGK0WK4GQ5wGHEZ1zzml5uoZvwvUy9sv8Zu+NlBcBIBJatf5LRJsaUMhS7e6JTb/s4eqeJ6vkxMB/jBnfl2YuH/fX09PxzHacOyvFHtlBWFDazXxF8k+YDjkvCj+FEpffpjce7iGQMUJaUs0pTScuHTh2NCXpHiHxeXfo9RRDSReUj5QaCuzC1LQt/t35E6Gn5tf4oCHmY/q1c/+PvaKXZzRpVVmQvbCrBRQQrQx+rdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmdfe37WCZOmdDcwYzQwdb9iA1CX1Dn77JtUII7ehqk=;
 b=KsmXZJPN+hINz9Ry2Ll8sKAYnfQb8FyIPyvPEet39eq9yZp5hh6Q+6hpn7W1X3BWlzijUWBsPhOw/yLk8DUnI513zCoMC3Z1y64e4cux5kitNWhdqUlM2oj/zMm6c2bWkbBYaaJ7D34bzuzHAQ/6oxB4v7V1efFP4g8jaiuNjBTdpzJ4qtDUvg4QoBxx3X3fiMJvbLiWMibbDu0cNjM6TF7uvqLTo2YQVl6cXyFbSLVbEPYUo+M+PKmNs/p4uRLPlfFtyLEQgX0izuwJdSyRhY0Q4Z+gmq33HIgc0zEWHUMYPqRY1jUdAoH3T3/qjBEqvCw0OXRMYXHrouvDXtJ64Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmdfe37WCZOmdDcwYzQwdb9iA1CX1Dn77JtUII7ehqk=;
 b=1UFudHL5WcvaAHhALFr0Y8H7oCFo0YYMHyok5kb3qoTaP7vv9I0z8qZhqLgQ0gyTSMXdEDlwTDGJ85kcOlsOeoRj0i40KvL+jFECEo6pKnbP+IUGmpYnoIPx7NmrbyzYlMeK+3NTJIp6uE6or4SvOByjzWiNW1X8tfgNE8WMMwU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:49 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:49 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 34/37] KVM: X86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Fri, 30 Apr 2021 07:38:19 -0500
Message-Id: <20210430123822.13825-35-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 257f7f71-95f9-4601-e60d-08d90bd4f91d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2688CDBAF0D29BF9AF6B2223E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HNBjkmKedxDeo4GiLOW77GHWaSsQRMuY99B1pCs038Yav7Cz5tzXyj1QPjaOfP/fKr0Ln9zWdvqv0qNIw2BwHLlIXH4OUxcDoRVJ4Uos3gvwYgas9XwMFbPEkKZ24yjuV/3qCr06lIp7ecnBDZYUdyIAoVGLKHwCzAaBvt7UyJD9S5esXhBdMK3vB3IW+8VojXPGJnz9YpTUhE7gnIiDsznwxRtulrcU1w/Du47bN4aFyMNhb8QoyGdhdCWNIHRCNRG3i3uLeqyvly5p+esqC7eXKoi1aTvoU/EEaXaFSCEJtnJET+Q62CT+ZMcb3AoQmbkjQ8gg3ATOIVVxh093rTTl/gAyGkqAPtXmWINMYQ14gSaaHilfmANEBcOtjzCycUO5j0OA4nQxBnBc2bszEV+/5dLrG99Fxc7GGavMnDblO45/x9XmPyHZ9W0iti3rtxLmPTO9kssDWlYYLShSGAhdK9TnzA2asBdEy4pjs3Si9eEIBpHAC9WY2ueu51pe7kit7ivOUbEEHPI3MtDEPqNW/DqibmjA7Uu9AjwsXTE3iuAFgWojYgkc9YCBH0qbibSudNmqARYZ6jR+LFYFSvIA1GUY5LDONsQTAjOqmdFGHqNkVQi/WwahaNbH9+8v7oDODvSs3zmZAqt9CDLCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+qAQfwSYln8nXnQvdPwyeQJEjBUuMaONqY2mtB3bzjlnL0bZr/oyP9yYLgqN?=
 =?us-ascii?Q?4kDQhaLHdYlh8cZr043rMUkpZU6SeLcpAkDbCGlvQBxUWN92VtjcYFUpd3SG?=
 =?us-ascii?Q?Ucn5Yz8Fo4OhsqxbKN7IlVfL3nUBgkhGii+GCS7paxM/FkKRtyggkjeHEK1T?=
 =?us-ascii?Q?92vrYOt0ySuAjUnquKSts9W0O7BCL8YtAUda7iqc/sCx+RQlaQBn67F79jSZ?=
 =?us-ascii?Q?/5GY9KCztLg4sH/bSXi5Fl3QxYCQi3LTqb6rBfksD1v/XNe1/vf5AcJjC6YC?=
 =?us-ascii?Q?g03VppQdjSCymhX2Y2Q2wYapXI7TeQ5uIg/k03fOWa1CXfTubpKKMshe4yHP?=
 =?us-ascii?Q?ZPoi/aYsvlvvPXYV3pXxA+NeDod7ji2+j3yoYsSNE8+g7unTu+Lgxpe68NS6?=
 =?us-ascii?Q?N52dshgCBQPjCHiTxRoQftdqMbPwwAji1AhkZ0dRzhsJ4lR8EJGy6J0Vx0dZ?=
 =?us-ascii?Q?QVjgWjX5y8qkqpKLk353f9Z+XuQQ3le6KALXyleUcntidZw2u4OfCXRIAnN3?=
 =?us-ascii?Q?zO/rjFerM0opupA+f2SElvARHphgDxxEXbG2VIU7aq4aohB1uAp6+RZOuZWk?=
 =?us-ascii?Q?+oQyA7EIP39r4ZG8bOjoDfco7TEu/slnIYT3oxld8Yvr9aKBLqw9oxaHiiO7?=
 =?us-ascii?Q?VVRkRrzvTSdykARi2OMqan7hGuGFed9Jrt5wywCwOaCTF/zaYposi0K4S1t7?=
 =?us-ascii?Q?tIW8nqCVULnObxlZ/SerIX+NlC26h8uS6pFrp5OP4nCRPbVw9hliiF48fwJA?=
 =?us-ascii?Q?BH0EA1km1TI7q4wpnPDn5GaEsWqbh8IkyEVC4lMqm+Al0NGDCQlY6CKozu4C?=
 =?us-ascii?Q?m7Ty9upVyv5V35hnKYY+ZoJiC2HfuVgP+D/ZsZrrn0B04pdlTVyJdzBb7OiH?=
 =?us-ascii?Q?sKzp7MiFKUF7O+EMBVpmTAUub3ZAhser3uuzm/3V57VDPnJI7NCM7Uwa0UyW?=
 =?us-ascii?Q?T68kUj3AW+6XT5lXbbYQ53dgowYtbsqWWiwlyNdSoObVYVNskxPJFXXUssxP?=
 =?us-ascii?Q?aWunu6a4JMihQ/neFbBlTBeNkDBsC9vEfeaiaEGwA2DS+lvvpzo3qmTuQKbA?=
 =?us-ascii?Q?GCDMn7QPb7S7kpu9DVqLqlNYbT7REReosMxaRqOQLv1vIKn45thOZ2KVTqN8?=
 =?us-ascii?Q?HY60RXNY0SuMQzbAwISYwW88CRXMS2TDvYP4sO03/Rn9TdZCYbapiRmA7nsj?=
 =?us-ascii?Q?zuk2b3UmIlxnu29UaqnvwwcnEsTsDHLq4gyu4EU/wuKb0LXKQDfW31LO6SMt?=
 =?us-ascii?Q?3bbDp/El/ZpTI13BpRwPSCIpQZrARYohoVs7Da91yYuJQUBgPNHsa3XDb/d9?=
 =?us-ascii?Q?PH8hnJIA/0Vfascl+/47MP3w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 257f7f71-95f9-4601-e60d-08d90bd4f91d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:19.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTWmLG+LqckUMj+QQyX1iwMibOoifXY8RsdTnM+sDYnaqD4gI2IGprUYtSjYdL6nAPtYtT4Zh6SCLERX8YxYHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While resolving the RMP page fault, we may run into cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, we will zap the gfn range
after splitting the pages in the RMP entry. The zap should force the
TDP to gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad01fe9f4c43..7d4db88b94f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1481,6 +1481,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 147e76ab1536..eec62011bb2e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -228,8 +228,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 956bbc747167..d484f9e8a6b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5657,6 +5657,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
-- 
2.17.1

