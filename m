Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25FC2AC867
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgKIW1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:38 -0500
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:28320
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729336AbgKIW1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iz31hr6MLvf6RERzm2HcXdm4wT9ftVWL6DJMD/9tAz8hOOXmvutql52OucuuuwTCRmXGU9hKs7o6AUxCi9flLfllY1fYW+x2JDK8oQZ1LC83WGzaLiNZgJ0NDNgDu0t1kncsA2vlSh9Pf6bgpIjzK1S48pzDKv1aGxvFbDFCY3FVJnK3GbJVU5/FqKf2zLBJhFSRXuyP+sc5QUdzUz1qer5QC8lCyPRRWzZIPfw6L9TxQSZjoGYU4wGTKgT48ViyACUauqakoZDnBUtuf1my4wGvD7sl6KW9zfgPLk6PR2bHjpQAqIZ13vRPDB5JxYKbK3Z8KtuST63EuXg/xTqjng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCPd1cemga2nT9Mliq6eEgmXXXeJRbwSStRGkT1lprA=;
 b=AHI16du0i8HJ+xLASPvIooags3wVoyTpzGPA+7ooDeXZg1V41XTOiDgBtOnJVVdZm6trgnDyIwt9c9Mt8RJZDtItLWrw/masgB4jS9Oee40csVnl+Yg2pEpRXNgnTHDcrm5zHLHz3bjVdSyeznARuaEeUCGfVmEAzxWN65UA2Lrs5Yi3e4q9BHM2mQ2pJ8qn9p+KpwTCqdxDC9yqT6MupKAajW/ViBRf0XqZGnvwrvNFphEEhefqfZbg/1smVI/DmctAdUEYp/uNzY/0F4k7xIvsD/uwSKgApPgSTWBl7uIuLXeAEmxLydPTCokV7NRpymVXURPYvNfWqe+c6l7FIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCPd1cemga2nT9Mliq6eEgmXXXeJRbwSStRGkT1lprA=;
 b=XeoYasc8oTXsXxrBbB/DsPQTcF5OrzEi+i5WqWpftGCQjVlhrs8vkRFWOcNmXYdicU++ejSXB1kpnw+kCCoItgHTHVVd5izB69nDP9m6y0abayx1IfTJ/2lD0Ogz7WPMgIF9LvPCnjYV+J88TLdhGfCH8OUhelLRtY3Tlhozd38=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:34 +0000
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
Subject: [PATCH v3 10/34] KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
Date:   Mon,  9 Nov 2020 16:25:36 -0600
Message-Id: <f0a40feaa9442c9d39c4719776e8d3c8f876e6d8.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:3:16::11) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR07CA0025.namprd07.prod.outlook.com (2603:10b6:3:16::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33452629-1fe2-4b4f-d6c1-08d884fea7aa
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB405845B0D929ECA71ACA30D9ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p0SD/zjUXzAo3GXbywdS78hsAHTOMos6TzJdfL3qUafkROslG6Djin23QV8tAM0WaIdJZytMtDakOdG+I0jvmo96+iSX58M8IU+HdXCi7rMYx9cIP9d1VZr+1Z7EkjQ0wNfjabHFjoxEiT9By0DpMcE8qa9OJwIw38NVmagZxxA2LbgM4zbgp//KtikJpvNrIp8Se0O6k550rLREgxDLkBpKmBR3f5XmUR6HCzroGPPe6tiERVtRItjY/Iwwry0IyP+nCmJrFMJfbwNyYmCeYt1h9hmNTkHXB3fztJUzaxfDKA5zhmbDX+DR37+a5vmu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(4744005)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0MF/GGeIYxTc3lamnPJ72veuFgHk4traMsByADC7DdGpUnwM9OIFRAp4G+ak8JRikjcfPewRPtF8bA4TK0TlecqGYpSGWV+YnmWN+urktypKR00UVeWDSpK9RTR4ESXT6cxG19rErPyaYNCd7LuAVpHDxBUkuKTTU81tmNp7pHqb7pEIl9sVFp7RXRpQipZ2PGabiFj3hIcqZk+8b968KK0FLW7ShQbfAZA1vRNBCYWbfyzfKlBWfhOjnpLYDxwrAHhHfiRvnRYeSMGoYjU6cN83k9DIH8P7ngwqGI6ptTpOL7yFo6yxD84g6Petc2K4kity3reXRGkNAgffVSrQQTz70boiabKG4gufivdolcHFGdMEiV8eFJKHyerXI7Mw9dqSMHARrHPrZB4phwHrBq0ar0iotg/QKyGzOoJanGzP+BMf65GcLpZ8D2wWTqBoVZRTrkWahFi9pyYmZzJ/luoJ0qZi2XBTU3FLOf/pRtcd0YBJlAkBcdBoYsTXbcbn7VdYJETfpnX2KREsZauqHwj7B16+13SuID3xsT1okI9OtZ83rrZPxyauZIrpQn/INYw/ZnqSmDM1SSigrdJXH38DBwzPACLvHCYZ50tkhi/CycpMn8wGkRBL5Uk91ZZhxFVoj5/H/22SoPjEfQ4Z/A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33452629-1fe2-4b4f-d6c1-08d884fea7aa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:34.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dj2XXpPMFeOHpgeZiu1ePPyqxxX7Lh+3mNc5h362vwbB2FpSpUurL3GTFfUzZlQVD4cQfFWUxDkdvYrkoyckCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a SHUTDOWN VMEXIT is encountered, normally the VMCB is re-initialized
so that the guest can be re-launched. But when a guest is running as an
SEV-ES guest, the VMSA cannot be re-initialized because it has been
encrypted. For now, just return -EINVAL to prevent a possible attempt at
a guest reset.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0e5f83912b56..f353039e54b6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2026,6 +2026,13 @@ static int shutdown_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
+	/*
+	 * The VM save area has already been encrypted so it
+	 * cannot be reinitialized - just terminate.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return -EINVAL;
+
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
-- 
2.28.0

