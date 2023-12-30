Return-Path: <kvm+bounces-5400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D524B8207FE
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 060261C215F4
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EF414F8B;
	Sat, 30 Dec 2023 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="shQmBCCe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBCA14AB6;
	Sat, 30 Dec 2023 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBFNe7T0xjHiRhOneVlvxIW6gBX9V+1xEZ/J1AA5XtEvphyQaq/b8ZMtTBGHfmh+UKKHALJSFW/0kl8wHDvuJM3Sp/d9bVqPM80NPfxtYaLpRK/KrxR9QZR82lAlkMjjzLPVxVQYMpiLRNQstc5jWVKnK/wZFpTVCnJ5EzjXf4nNPz+hPpZlvMgCrd+mVa3QHcjvlQLH9SA6p/moH1vS5Eh83zsey36ybhvryUp+pK0kr0CvC/sv6VpFEmzBzC5+5raoBsvBvfAbhPY1ods+IDAJfShDMSUToQrN6B5XEz0t6Bmwbt3xCdbmOG2WmtzW1jV8+2tFPTxOeQa+XMWgFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6G//Ysjjc0XVDXuudSAUkrpExZ17kMbMXQYYD05EbYo=;
 b=gWFFxqtgC4UWLehG2dBMD7mO4RgP9sf93u3aFJNz/g/c6zS1dBxdfgds4gRQaGpBtvbi890y0GOjvtteEGOvvpb5C9lO18yOEDhYrqX18SGc1qlb7Nwae9qE+F6WBUOBDGkKJxSw80HHBReHMfuOEkrR6sBwi+e3V+a2c9DACdfqWmMAgsfxqrE/OZTfQhoc/9fo7JPE1tZbqGCdrUVAk9aIKVWvJ27aR1Wvo6AiHR2ionz+zwUUUV/NohJcsZguG3rlguVwPmp7GXwJ95HoYf2i9mbBm0GAfkOl7IvorWk2a8CtD3VscB0c6QbwhyA3Vx4VQhBmDPApDtj9AmZGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6G//Ysjjc0XVDXuudSAUkrpExZ17kMbMXQYYD05EbYo=;
 b=shQmBCCef1TiFrawKvFLEiYkmK2jKb5324/+TENkvMmfn1cqXH0DS6OcbZoWciE9qELiEZgGfWfiYb5BvBu2EaZTJCakSdP0uF+MFr9cSEuOEWosOSZw/Nhw/kkhgsAORFGxh7+Pf2AxWKlWmSqz99Bf+pwY33WN005NFPhMtnU=
Received: from CY5PR13CA0078.namprd13.prod.outlook.com (2603:10b6:930:a::40)
 by DS0PR12MB9057.namprd12.prod.outlook.com (2603:10b6:8:c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:34:47 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:930:a:cafe::2) by CY5PR13CA0078.outlook.office365.com
 (2603:10b6:930:a::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.8 via Frontend
 Transport; Sat, 30 Dec 2023 17:34:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:34:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:34:45 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 03/35] KVM: Use AS_INACCESSIBLE when creating guest_memfd inode
Date: Sat, 30 Dec 2023 11:23:19 -0600
Message-ID: <20231230172351.574091-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|DS0PR12MB9057:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ec4380e-2a68-4fae-2126-08dc095d9deb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jrEIvM6CWP+c4eLOi4q5MDeu5IIVftoeblGsQNw4FAALRiXDejt1RkPVfE7F378NkpEJRpCCZgEBFusuGpw6kn1rXYIIFE0FxstVROPuY6x9HVqUR5xkg19gRS+cQY6TJWVJxrRzEG9APGvymwcv5GgH7dqBsuSrsA9w2i5r2E+cTRVq5LcXsKNOIYGbf1/3PrdD/rGeM7yD/TiwnTKntu79dputM7j/cqW5iGcrLWvjz8kgvY4vmimiJLdF+JjYnlJy/BFMMbHEXWpQtIT1bf5V0NKg9gn3s38OaIr6y3Eh16mR7y4zXSClkv7YAgdWSQWQ/p3J/8ACZV+Y1ftjNt1v5QU8AZqgZDE/D3ijhy2hPhxndLvJEl+krM5V6ZBwbJoq1ALn6KxU0kPHKqLfg9BaThuXoEVp3Ucci+gPEguK5yyIkift16R9gBIjwTGYfJTotANHC/1l+UBjXWa0FM7qUSGsld9tTuu8tElQP9ES9QuIw7U58r9o8jjwRwuuO6kk32NX7SCSvJHy2q15+yLW00p7VC7cM5Yrid8HUTEYwzhnDSBJCaprZ8olkpa6kUSH2zQw5g5ehwWqi6YbXdEpxPMx07Nwv9uG88asRMev633YOZA/Ty7dS05gmPFw8SIXawHlthu38MEnldlcOCm/AuoKcgcEG1Z5M256mc9+GZGRYVqp5SYnQSb0SZvlGR8gCsjXrJFHJM+Cl7dJbOd0R3SIONNfUmn9uODtcLR+Ba/MfYFrCjc5xJdfh51iUm6WxDBkwyVkc8wEjeTvlg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(41300700001)(2906002)(7406005)(7416002)(5660300002)(44832011)(8676002)(4326008)(316002)(54906003)(6916009)(70206006)(70586007)(8936002)(36756003)(86362001)(82740400003)(81166007)(356005)(966005)(478600001)(6666004)(47076005)(36860700001)(83380400001)(1076003)(26005)(16526019)(426003)(336012)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:34:46.4871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec4380e-2a68-4fae-2126-08dc095d9deb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9057

truncate_inode_pages_range() may attempt to zero pages before truncating
them, and this will occur before arch-specific invalidations can be
triggered via .invalidate_folio/.free_folio hooks via kvm_gmem_aops. For
AMD SEV-SNP this would result in an RMP #PF being generated by the
hardware, which is currently treated as fatal (and even if specifically
allowed for, would not result in anything other than garbage being
written to guest pages due to encryption). On Intel TDX this would also
result in undesirable behavior.

Set the AS_INACCESSIBLE flag to prevent the MM from attempting
unexpected accesses of this sort during operations like truncation.

This may also in some cases yield a decent performance improvement for
guest_memfd userspace implementations that hole-punch ranges immediately
after private->shared conversions via KVM_SET_MEMORY_ATTRIBUTES, since
the current implementation of truncate_inode_pages_range() always ends
up zero'ing an entire 4K range if it is backing by a 2M folio.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 784690a664ac..4aaa82227978 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -390,6 +390,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mapping->flags |= AS_INACCESSIBLE;
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-- 
2.25.1


