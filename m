Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71172B6CC
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjFLEqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbjFLEom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:44:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC351BC6;
        Sun, 11 Jun 2023 21:44:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOmWeOCa6NkYH7ePV3RsOvkDgBdH4Chk5VCtWI8IYBX/NzqQ+uUg4n747GRM0oCbxzs5+m/xLHZhfv5Atb14ieTbqW2iuBbbPOJr1otAAmScD1Jaz9leomaopWIXZ0NuYVnOMnYUNDGO3g8bzodyh+gS0rw5HuvG8dlP8lkLVT/VKzli5MTnlckbJ/TmqpHKnKGNJ8rvkNx3GcnnEk2LGUgZA9JSsVAYbLf0k0PgEFHnC5gzMDUNAnXIlrzy49YS1Vs+ToXlgcUKHDHSOi3CyjdW53bXx/sEUzDbkK26KTn4q/JdTE57t1O2xzVcHsqEnML6Jj2qVqp5qriTamwwvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sDrVPW9K6hr5iqjy87+FTvyv+9ltC0aCsqlHuApz6k=;
 b=eBbZMCxgr7rn9nKM7H+ydg7gfayNpM8tczu6Ao6pJ9J7wYBK3WB6ngIhpHZrULiOGIpFJDwCwAx/p3H7/5J25H91aQd4+MbB3DQsgVlBJZafwTQDcSnBGPWxBCyxnZ0fD1dS8OT2yvBHKnt4IHDOoh/uNl7FfnZA+zCXPmpHTfv3Ve4JZchQftPun3GpIgn3EaBAVmHgpamnGCBBM76DmAcoqo47AUTrzaHiTIseRqkVXGiAwOP59XnH7Fnr8RhmggAnx2VgGChpas5s4Xbqdse+zaAJ4eHgGaf3EPQ3TnivdRjTkdXVKaeJQZKp0+7TgvI8QI1L/PtVNCTvNfO1NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sDrVPW9K6hr5iqjy87+FTvyv+9ltC0aCsqlHuApz6k=;
 b=ZFg1dBhIO/GPB96ZYa0CbeIMDY4CVnzwabNCjvbpGdwRsIe5XkfcW4UCW2bzHvNKCam70NLibNEODKA87b1Bl1eHlt9fknedxu5ttOgVgHc8rA4zk3fX67zLSMmBJ6XmGXWEJ6ZRK2Mcn0r7pRnxElMvJLFs5blIVRJrjLih05Q=
Received: from DM6PR02CA0113.namprd02.prod.outlook.com (2603:10b6:5:1b4::15)
 by DM6PR12MB4500.namprd12.prod.outlook.com (2603:10b6:5:28f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 04:44:19 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::f4) by DM6PR02CA0113.outlook.office365.com
 (2603:10b6:5:1b4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:44:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:44:18 -0500
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 36/51] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Sun, 11 Jun 2023 23:25:44 -0500
Message-ID: <20230612042559.375660-37-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT046:EE_|DM6PR12MB4500:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d9c5aea-57bc-4b7d-8f60-08db6affaf32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnoRJBIiWIS8VmyL7Q71Yz9l76DEfTekyzl/7U8sJW4ZomDagrcBw4q+7e0B4+ge21/zXE7IgkBmUOpPuIS3Vyq0SBsOTiBWoGiygSDwp8DwZsATzmnJvL93/5eqGfnboNR2AjvgBLErx3m1aNe17uZWOkqL/HJgNUv2clhZIXxj8328s10Mh7hAOvVHBrinjeV3Z1IgMOEJtu80oKpYPnOtRC/DubE1B5cjAzmUe9RYIQTMo0Jdz6Oj3hMxW7/qx+1xMOm9GxK1c6Eh9c1VstOB5jNghJ2e4Ib3Dve4gvIY2q0+Z1Z6IoIdHAzZp7h7CPk3xzArVfoFVe9SGIy6wesCLwVlbSxPHZhguzgHR0bukTnTr7nIzBvZDj5J2JnJ+12KoPdNRfh5tArl5uFXF+DV0TczLiVahUrrwq+eL2uCzwB63f5TenNUnKjE9duvgH6tGRsSSIc+BvVK6aWoBSWJXIMQEnRAqe1x0tcYHyJv8PX0zVl2Gkv8ccm1++a9pyyaYFXWJCV57em8ZrgcVFOlde2O0tM3tfaaQ09/C0B6V0slzxhjL6rMI3oW1eHpUp30MpxSehxglBFhqpBwdUk8APBHKPnvuzZa1w732I4FjgVOawmPzAuiJCULHNGobzFbmoQmE3lOa6EC/b+TciBikkpjjU0zevWu5r2IKmJCplqky14Bd4ppQ3ZvZF/3ivmwHNxsJd01RSoZOIWEp92Oo4CLHDJiFgSFiWAZBEZ9TZyjKyoqkMQRCz5q1e3alXMV0HG5GddoUXS0pGCUBw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(7416002)(7406005)(5660300002)(70586007)(70206006)(4326008)(6916009)(44832011)(2906002)(316002)(41300700001)(6666004)(54906003)(8676002)(8936002)(426003)(16526019)(336012)(2616005)(186003)(26005)(1076003)(83380400001)(47076005)(36860700001)(86362001)(82740400003)(356005)(81166007)(478600001)(40460700003)(36756003)(40480700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:44:19.0807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9c5aea-57bc-4b7d-8f60-08db6affaf32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

When using gmem, private/shared memory is allocated through separate
pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
KVM ioctl to tell KVM MMU whether or not a particular GFN should be
backed by private memory or not.

Forward these page state change requests to userspace so that it can
issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
entries when it is ready to map a private page into a guest.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 44fdcf407759..2afc59b86b91 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3233,6 +3233,15 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	set_ghcb_msr(svm, vcpu->run->vmgexit.ghcb_msr);
+
+	return 1; /* resume */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3333,6 +3342,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.ghcb_msr = control->ghcb_gpa;
+		vcpu->arch.complete_userspace_io = snp_complete_psc_msr_protocol;
+
+		ret = -1;
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
-- 
2.25.1

