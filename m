Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D30536FA9F
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhD3Mlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:41:42 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:61889
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232709AbhD3Mkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+nBav39Wr/MAY5+w30pPd2biYzbLvOxkjMFndVvdJ48ZDhSGm4FJnqZRci4RQ8YIJjNJyM6nmyj19qvtOkL1ZO0/MV3jynRRpd09ViPLzhYyz4bwxt90NpglD7XM4/qLQWrBHJ6Yl6nf9XfygVCZSVE43ihSAsuTcg7SLfupBcLlrfxIRedtSDU/yaciZxKiwHCtO9H5xpB9T+ZGNSk24qPrui4J9yFgXeDw6r7SueT4yEVRyElLlpau6ezu6U0htycow/lv6/qowFpUrh7uMVNyCIEbczSvkiX20IVLKF8g6c5GkERn3qrQRIvMMIM69pdsbV1Kho0a7tHNkrgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHxPvT2mceaCDwGApkBfMPFYPhBf1kKunh9+nlibH5U=;
 b=HUYl4cOHGx9wQCQOTNRXGxFyt8tZLU2IjzNFJw5y8yE9Hk17xtsKo+UXhpoSemTOa+qtdf4+oq4j0zA1Sz6espWsxxd3N/JL0uqAep2d1y8kJI0B35D3jIvhukiL0mrXMPQIh1a7Akq/3GhENC7rAq3FGkjyqqtjTx9askh9OlH7wy1Tz2o61hGN6p4jHB5fr8mGIZ+jmWUdvgb4M/8RgU9a8l+70VpGlFHX8pMtHXFikQtrTQJ89mXFG9xpZ6MXQhCvyRGIwdSP3fPiFuby3AgZcqt+UzpA4ecUY6K9U1U/7mW8RTe8u+CJfs5JRhCp+wQYis3oiobviS4lJlt1ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHxPvT2mceaCDwGApkBfMPFYPhBf1kKunh9+nlibH5U=;
 b=IK+NtHzG2+/NXAeucwnMfLHyoKeF4Hanipi5W353dWOgy/ZvnyfrABMJRjW6K3UxUpHHjQp2M4lzjtZ/Wx7tWFdVQ0plrY1pNPKvMH7pG87WENbeF5lP8tjc7E/7SVfPNOTpZn9FjtK9FUd6h9qjTXcQu5YViFk4hX9sxgU4Kd4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:13 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:13 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 27/37] KVM: X86: Introduce kvm_mmu_map_tdp_page() for use by SEV
Date:   Fri, 30 Apr 2021 07:38:12 -0500
Message-Id: <20210430123822.13825-28-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f27436c-6eef-40c9-0b75-08d90bd4f5da
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268843F40E9A7B3A05FFFFD5E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7XQQsTOViNPlYvkwXgUizkIBVHfznYxYRFSNibsc0ueWVYMC7tENIdTpPc3ZEW6Xsx4L+NtnQPMlQZtxMwPyo+YhxFCR9wqDAfL7F+ONcGEskb7yDgzs6vJ5yCRL+252KymJR/pYdGklQo/dTwf+bftji618Vgco5lSaQj1+IR9xIzN7cpcy2nwkPxAJuxGKoJX1uV+S44iGduH4lN8avpcS2TZGe+ZPeDdsOmjYDV89UNCEOxqfLziJdppCghciy0b3Gc4sJtzG6UaO32kVN77cwf4vGeeTKQlbbnUyNhE39LCVTP480S5HzAcFnGD2oVOFVWmBFn4TXhOMglLnemIi09ALNgYF+2jgRZ1n+q/isue20G5iDh1JiLLhppWo92ZeTkwbpLnUIryhGn7d20N5jCtgkBXMDNSpp+tnHrDrgNA7n30ydoLDf7YFBus6mkTCLhEz3RmfKN5J+yg1BkVDn29Q8YfGJIr/gx2CXLpdGD2UrWARgsKyVtA9HVSlK9Fq4VjrTHcjv5KYjrI6P0Vl8Uj++2SD6gIwAx6+E48LzS7+QTvg57P7V1ZVj6Ex/vDSKDzjFEWGpUePg+ia8b3MEft04ZcrAZ0ar7p0AZprkCmDEQQzCowpACZ52k4A++KbOBL6xQ1OmIa7A4lIpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iBM2oknEn7Z8sppps+bSjRgsmj0+nXrHB28zd54nuZ+aC8woHEmQR1/d5xnf?=
 =?us-ascii?Q?duXQNZ74G8YvZLQlXG1o5YrEB9OdFBdpfjHxexxYNcuw8JJDx1NV4POmALVf?=
 =?us-ascii?Q?a/FbiF9oQqY6wvNyssvL0Il41eP1H/BdddUsvuWoydlqa1t2YS6XtMZdyloy?=
 =?us-ascii?Q?NqiKq1v3okZsvupmM32g82JvcGMEirH8oHV/qW/cTQxwTOilFbvRHBVbqUf5?=
 =?us-ascii?Q?RuV53Cow1rs5AI30unvPFk1HoS8WyjmzYu18otMlfBHkVWag20VTq1o36nUp?=
 =?us-ascii?Q?9uqhEkWCJEVhm7Ch4PZ2kdS08xztbabfNgTmDQfz0YanzGTlXTMTbOtif0l6?=
 =?us-ascii?Q?C0X2GmgZRXEORaKJTdDIPsCy2URa1GFttu0FJV0STEh3YUvU06CftmHUlr61?=
 =?us-ascii?Q?sxFCLi3El/UQB5pGAnZIYMwzhEVwKhuiN/9QxIlJJ2NsEDLSUKF4ZOS8To7P?=
 =?us-ascii?Q?6eV8fodv/cyGxkfrAnQi5FtaqwcNHOA/OLZ8o/txunRCUz7S4I48b10km2eO?=
 =?us-ascii?Q?w2lMh9ZPA4EBaLFKe2GIs79YKtpPxV1U7BgZbRzUQqq4cns/1Z23oomDwf3Y?=
 =?us-ascii?Q?cMiaOI6mDF4ZYJCZFsbCDxsMhFzWaRGmTchYZMTWCVzY1FuGsU1RcTJLA0/K?=
 =?us-ascii?Q?eztChFpnv8pSD8EdCKY3iE/lSR5BQ6e0yhuxAyn5d/VPJ/I/Z+Dy9a5c9Zzu?=
 =?us-ascii?Q?/dE5JqYgIpoXs284xhXUehUV49PIIY4R72dw6SshF5xcH01RHJG2954+xV8Y?=
 =?us-ascii?Q?sjvMzq/H3XoLIPNiOAskG2Wr/g5rwanycUyBGcKRIXUdPXsAKOeY8TGeN3gl?=
 =?us-ascii?Q?/1O6fq3xo4fGwoN6gPggghj9yyhHLOqa5vagdGICPyED+yQbX/4vZq1FC4k7?=
 =?us-ascii?Q?vvXdFuW7bBwGjGvAWw3IIJjc21excTHkEE7zb/FFga6QrvB9iC0ldPkdjUHL?=
 =?us-ascii?Q?6TKo2xtMfzsQ72DHhC3sqmrpoHoDD7wP81i0YabBJXrto1PGBe1KP4dt/WAe?=
 =?us-ascii?Q?m9Y55GcCj+zGGydoF9htUNWQf/7Y7EbXTVMCgKq3Zg0L8Byng6p0gqMe4d1g?=
 =?us-ascii?Q?+cFtlUSBbtE8MB7C3jfJj61NCOjeWxAxfnmyJm+kWCO7YyMOECgiPQVM77Br?=
 =?us-ascii?Q?wIboBjE/6D9oSTwyPgMpw34VYn0fBbtWuIz4tpga0I4zu+fo8k+T2xYy/4Lb?=
 =?us-ascii?Q?E6LOrvstN0CEqIh4yCV3XM4wt1/MNDBalSVM0i20vIcs9dFkfjN61H7j1wlF?=
 =?us-ascii?Q?F6fbmtZC5xkHt0Wdb0vL7TAfBaH5PFMZDv7I/XAOYd4UnK3qQ2x372IQUaYQ?=
 =?us-ascii?Q?GFQH4FGACBvBP6ayc+JoJu4r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f27436c-6eef-40c9-0b75-08d90bd4f5da
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:13.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMf1nX1+ozugPj8BViO81zFTImd7lVkSMhtbhnfJwsxsmA8DBTYj5ZOxOd4DrI5X1jxtek/r8VkpjA657lm2zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
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
index fe2c5a704a16..d150201cf10c 100644
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

