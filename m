Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312A57CAA19
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjJPNol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbjJPNoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:44:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B918EB;
        Mon, 16 Oct 2023 06:44:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6i9oj1qw/BuLddivuz3FKVkSxluZFvWv6HsNeCGcji9JnRG8+BmyyDGjS2goDXpf8305Znp6Xx8NFr2HdjAQMyVXfBy6M7CyPeW5zt0nstbffmw0QHbajO/8CoafGzEDfZCq48mRHE65cyaoDDgtBU+YN1ivsALnHq1kFKOy38jJjGopa9uGtulNr9uuOY9DwwgQfcwliyKfPoK6P5uxCSKaXNHR98nI7K7Pphwru6GiAWDFSc8ZzQ1CXR97vTz53E96hQUwrGf9LEzy4gDytTJywsecHRgOGqs9Ou+oAZOxFm/nUmNAkYcwMo92E7a5oSrIXz3qaB3aFg8au7YSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/XXYKvsa7V/ySbrTiRvd6QMpQ3il+5mLsa616zGqX8=;
 b=oEYCiTb/q+gJNTxQsiFeZtk9hNOGjNXhYLoH0zl9CPS2JTD9Rpv3XdQpGwsvs+GBVGdrI2Zxyk8jtp0F97HbVtx6Dz1VIsdA0Qq2MrjHQHU69hzsYuQ3GfaASar4WvZLhW0rV02ju8wcdH6lJHHcuHsIU6P0ToGj53nQ2OD2dxfupe5uQOeg/60vS7wMcr+zJr9Kl4nW3BpFTYG/D32D9xelbRlT0gApq2NMrJ1TEz32yRKBdA5AfdNeuiBl/27T3KG1oHLwczDtFmGHZV3FnV/OxSGAvN4T6cNdKh+rdOyTZB40PsUOLIc29gCedaJgV7HGGhEl9dmCwSHpNaRriQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/XXYKvsa7V/ySbrTiRvd6QMpQ3il+5mLsa616zGqX8=;
 b=kq7uP5PgyHCkiCsYh4bylR7x1ApL+q1X5zAoo5YjvAR/+wZzd9iXhxVqrA68ur8I63+u5busCqMlFOB1adT9k6pro4TNeZ1wRPa24Hnkc/wNkVM0TFyWbONWPc6oc+kKnPhdjR6/Sb3epPaNknX/E5M21tIpmQiPcA3E9S60o88=
Received: from SN6PR05CA0007.namprd05.prod.outlook.com (2603:10b6:805:de::20)
 by DS0PR12MB8502.namprd12.prod.outlook.com (2603:10b6:8:15b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 13:44:36 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::a2) by SN6PR05CA0007.outlook.office365.com
 (2603:10b6:805:de::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Mon, 16 Oct 2023 13:44:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:44:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:44:33 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 42/50] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date:   Mon, 16 Oct 2023 08:28:11 -0500
Message-ID: <20231016132819.1002933-43-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|DS0PR12MB8502:EE_
X-MS-Office365-Filtering-Correlation-Id: b24c572f-aedb-4a22-1748-08dbce4e08f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQ0NY/9WTT71MmlBSjOZraYdQNW80eJHxejxVnqMtrxLROsVcFVZCbZibyPc88apBaMbnvIO8lyBcLs2F80GPlkSeq+88PXII+ukshErhy5dMNHzImiDsxiLvpSInDtZe1lEb1D7GGGhD6pn7OcyXr+ASVLL7O36FWrsclnmyHD10TUBc7Fw6ipFodkthUjEZd/pP+boeeN65cMpRM6/7ZEhxKZfHVhbbAuJx4H/PW5R246rd4N0VG0jxtXBHHcf5QLVP0n97Q+5IAQgcyrdzVXjppOU8zbp5lOw3lmp/+eRFcd1d249ksUFueH0QZmCdKvMgubeNQTDe225xSAHcv3y1pCnRB7f6bJW+0ZsSV7+Dfdqntwo2fD1OmkDP4AbebET1rMzsr+5mYLMvVwti0GtlToc7ixvrBjSA7M6YCb3Pm01XulsMSweJPeOQDCMFwhj2lLTk5uHEtFlNXJcdy+my6u4DkkYiLwbzOXBIZwhIsZ+vGBT/Tw2f66hLtBLRBdwfA381jPv8VGmk2BB8/Dw5Q2g2T5hWoHHJAjv+0G/Z3WZZTSzd0E2L/LkqLhgglm2Ohs5ii0LYqprZbksWQF6YsOd8/JASi7E5dAqJ5CMYJp3qeXcLyShkLcpza2t9kUKxFD03q+BITogJ0Qk3IqVokECQb/VTubIumv5chJdwlWan9BJ5+Y95Em212yHy4N35gJ9fODAv6bs8UtiLa1qxfLgf7nYuUk0d7T9R5qBzsUkOfjIg4IT1tbuoBrds3u0+Yn1qDhK9wjl54xmhQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(186009)(1800799009)(64100799003)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(1076003)(81166007)(26005)(356005)(2616005)(82740400003)(16526019)(47076005)(316002)(70586007)(70206006)(54906003)(6916009)(478600001)(336012)(426003)(83380400001)(6666004)(36860700001)(8676002)(4326008)(8936002)(5660300002)(41300700001)(2906002)(7416002)(7406005)(40460700003)(44832011)(40480700001)(36756003)(86362001)(15650500001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:44:35.4545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b24c572f-aedb-4a22-1748-08dbce4e08f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8502
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

With SNP/guest_memfd, private/encrypted memory should not be mappable,
and MMU notifications for HVA-mapped memory will only be relevant to
unencrypted guest memory. Therefore, the rationale behind issuing a
wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
for SNP guests and can be ignored.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: Add some clarifications in commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c6d5a320d72..f027def3a79e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2852,7 +2852,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
 {
-	if (!sev_guest(kvm))
+	/*
+	 * With SNP+gmem, private/encrypted memory should be
+	 * unreachable via the hva-based mmu notifiers. Additionally,
+	 * for shared->private translations, H/W coherency will ensure
+	 * first guest access to the page would clear out any existing
+	 * dirty copies of that cacheline.
+	 */
+	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
 	wbinvd_on_all_cpus();
-- 
2.25.1

