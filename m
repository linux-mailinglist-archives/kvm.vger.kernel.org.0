Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88A12B6B2F
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgKQRJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:03 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:51553
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbgKQRJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSqG2pdHMFyJXNSNILBVi2IsdYhcLdQG61rmAALHf9ivzCegWE8fsM01U3CWODL2iORquET3Gvmb1qiKkwP8GnOV84HKW6toziKgdI3XHn5aPprguU5Zjs3dE0CdiQZhtt3KyaQBI0qwijkNuoXJ9HSbP/9zSnLIdf5kLRN5ywMEc1Fzl2+/EDa7y+74iWbc0QecldqH8vByPXL4qSw0F7coZks4Hsx1Nm2MGA4aGjrRqxzf0AQjK/MR48IOO8y9OH7wu0u0EBNT2wb7+paj/DaaucNh0M/YtyDmcBKbzcoxN55x8wp24cn6dO+yLn2MomFyrNIE7FjPP7tnr4En7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RhuXIfqSRyztA4U1jk+19FuqBF3k/BPQjzIwfqFKtA=;
 b=OhwctgCwJaRfF56KgQKuAeX5nDLgtM76remo7WxzujgQIe6zC4BS4YtNAfwElbbeQh9TfdtfHXNdvixvC4aKGJVEDX+N/D7hyqCn/ZL3DF3zerjhG1bVzU3CdmrM6NakCZd69UrXLDx9W8LwS3M4PAfSzNHnw4mlm9IqfuCAqAEULAczsDkYn9g4N6cexlhkB8fGZeljPacAjMmEjnfncJWgeUYSTvl1WsHPvsp9bZ+fSiRmSy0OSkyAOSnGeC1XZKcQtFdZXcnB29/AhL8ghwxa/ikKz56+3CHo6tc2hv6LCHoiInOno7TZ64bEfxZAgYIKTD1RPH6qtFViow4l4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RhuXIfqSRyztA4U1jk+19FuqBF3k/BPQjzIwfqFKtA=;
 b=V6yJqVVhm4U4F75v7QtSsUmvKfGuvpSbx6Ul5mnk+koZlnMmWmhVc5V63G3Z6UIItMFa6g3zzM/CDVgHS8Cl7fUHCFTBpF8r21LwT7/JuhOHX1h76mIrL9VkGu563G+5tocmEvo+vOT8wvY5IgKyw61jAJ+3J3Vcc6ORByK/d9Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:59 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:59 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4 09/34] KVM: SVM: Do not allow instruction emulation under SEV-ES
Date:   Tue, 17 Nov 2020 11:07:12 -0600
Message-Id: <26a132acdbbeaad4dde2a85f6bafad70a307335e.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR11CA0036.namprd11.prod.outlook.com
 (2603:10b6:5:190::49) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR11CA0036.namprd11.prod.outlook.com (2603:10b6:5:190::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:08:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 03bfdfb7-f0a9-45e9-2ccb-08d88b1b7928
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB177222C524552B877A5005F5ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUplKpHkc4GDL7mhgJ06oLvmQG0mzEB6WxCC9kXlA5xpdHNedllt9tRb+kMbqvYfOXuRw96cJyO8WFNn+1VRYFBvVP2Jh4WUGmnAcd236BezjVBHffRaEPIfJXju/knNoBE1Tm0EOKtUhlO+gDl6rsv7UMqJ0Tn+6UyyGWXISLxQGxa1szESb3+uU5CMK8jVYaUWJBYybU3u0du9Jzn65E1XtrM041TOh86DbmgFGPNnsPN2RUix2ZkRkw40zuDHyxSg+crfpFT2UY1b9PU3FAS7smUR7UfcyraDwSBExQW/da9Dn+l5VZNX8r/y2xq/LIZxGbYJ8/TO9/ItgqRsOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(4744005)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bIKLOTscPz8OZeqWP3jxShM51xcuxAd3QMdaMuY0WYKXyvS/qAVGs+caGT7XUEccpCWJxoU5o43bRuM3UyUEqPXpeSRh+MynKpkAs3hZWdwq1NLMhogDAJ0zRrHBNkCdZSA1tI37vM6+8hULmQMiiCCr+v4S7gnE82aK0mD1Q6zj5/v6BN4zEcmT1nz03NPrASgr1mXpmEY6DuCi4chnpDHygZZYApE3hwmgbhoJnUcl6S/9X0uu8AdkSztY6I4mxVZFvhdy1pCRXb+94GrUO25HOi3CEF9yvIOWh39gunpvfE1MXYVFEGjgko9VrTuq870dRIp7F6jCqCM75GkkEOJprHqkB3JRRSsYR7cAlOJLSK3EYRhpmvmqqBnobkuqg8+zMymRaK+GEfAcxEP4AgxTSlZidSG1d97FS2Q+bfKMsjPgdTS3D9ULLdqYFas9ME/ek+5MuVZw/o27yzq1CLA+JWkknmrwj5/jfzmRcqAc1HWMRa+6RlhVn2jspvuB/FeMnoxL7yrv4WskbHQaw39nBXBPP0inPzEgS1FzmeH0Hjj0cGbOYTnZnRlvatdJnCEWN4myn5QObGBy9vafbPip9o4yCHm1ESYde7lCQs6LX4BA8FzGMq3kMmVgKiGCJMX7DszJd2D63bsYTcz8Cw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bfdfb7-f0a9-45e9-2ccb-08d88b1b7928
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:58.8328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8UAuSIJOlhvzYaeaKN1zQR+a84CpQ4zEiqnkpRVaqnBNaDU8g7ZXTBpYK9XpTZsTl+79TLPdcjX7uUVcSDUDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest is running as an SEV-ES guest, it is not possible to emulate
instructions. Add support to prevent instruction emulation.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7f805cd5bbe7..0e5f83912b56 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4195,6 +4195,12 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/*
+	 * When the guest is an SEV-ES guest, emulation is not possible.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return false;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
-- 
2.28.0

