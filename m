Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB7A381067
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhENTYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 15:24:00 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:43105
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229610AbhENTYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 15:24:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7IySrd8MSi73peX7Dz76sGHYK4mCsVbFe34Ln67PaF6lRFnjqjI4yOhYffT/ooZ7MXBewIPCCABLv/p3nAbuvdS1PUoIRlf+H7stK9/sxjSiHUYNRNHFPni/O51/YD6UQpUOjE7eF566fa47CS00FzsAQZoX8u/iNlKjvmAFUDimxuACULQl5bxgWwwOt2wRkvksp7EPYadVtKR2Jth5bxpQAU/OPq7sxhRz02jVAKwQQPgrIDEaFbE7WEBYQNINJWc+GO8Ptg+hhjgF7CYMpRs3Br+Wcin9iGPOnLRQqyd1POoLtUym/Py+MJF5WBIsTENjgM3NOU0EiD0ny3m0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VepO996Q8zEYKgkFLldzaVYVigxqVmFwVN6bfx3fTb8=;
 b=getjErUrs4AureTy/ZwbvL6pvamx503KE2mr1Ihce0GRN2a1sy68dAhXMGTY6qUYKdjrbnk8Y/usJSSyogTSYnHePucSo5rBvHJZ39+jUmlYR6ASf9ErsDWTDBeyvN9yJPyG2cH9WK6VqoepWlAAAZdxxt6XY/Zx6ykuf3tnf14i/oPbfuszr7FqCuXF1SFJ2tV1zAbdf5EQWWQvy8bEsUrrgnIChCPdADgem6tlATr3HWQYMg0eGtLr0BEjLdSwD/YwgopKG1CEPDQygthvvtu4Uly8vHKA20XQxMm+UubeNaUJP7uscwOMIb70CsJM/Ikd2fsnvdabPfjxWCoA3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VepO996Q8zEYKgkFLldzaVYVigxqVmFwVN6bfx3fTb8=;
 b=RB771S9AuPe1jrD0E4R9cJMIHVsI1osn+DcAEV1+LpQfc9qacfiGoo+wj0UscIquAWUKQfR0UXomqssl+gFBIUK40AE99eIVaawBXMg6RaJnNMDjL3pa50bbjxzB3K6wFlywD6xtUbgOajPsUXS36qTEbfNcNg7RLppJB+H1kDM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (10.168.234.7) by
 DM6PR12MB4337.namprd12.prod.outlook.com (20.180.254.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Fri, 14 May 2021 19:22:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.025; Fri, 14 May
 2021 19:22:46 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB validation failure
Date:   Fri, 14 May 2021 14:22:38 -0500
Message-Id: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0101.namprd12.prod.outlook.com
 (2603:10b6:802:21::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0101.namprd12.prod.outlook.com (2603:10b6:802:21::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 14 May 2021 19:22:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f477576-9e5d-4adb-4647-08d9170da768
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4337AAF005C7964657440F85EC509@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZxxIlxL6rBZhLr8WYxbyxqc9W1nrhh4GZFA5PC6VaLT7rGJBg0WmVZN1lOvnFwPZEkVHChaQGVcPBxk/Kw09KOsJRsSslaUPgHzn0pVUkm2UrVYKDjnlN3FDtp+xcNTkgq+DAnX3Eo+YQDGPXylex1/7MQHICwQd9sO0STPnpA/DiShKl5zIzk+SosQTfXs3TN6FCTWl8BUuPn+h4akeoa4G1tyo/WJa34+kTD9n/iveGCRXe1HXDSo47Ua1ua7IfYKqHSM20TrkZQK6nWXj9wD2UMDGYNaNu9STMLtINdFh7nkmTOUzo9b7Yi71gDh5tH3EoywpF/Ncly6MXANKBNaGf80E6R1IiVXqbCCqkbKpeJbnfx0LEDpkSk5Kt7Rl11X1lfxIlGT54RHRytilFOfb491F3YLW2VMm7RFI7ktQrQvyXb/Nr8DKjPiodJzHB3dtY6pMeF698cft0ulfFHAlFl3z2rc7lVNVdsk0+BjABl3JYNOC8V3aZfv+i1HtQNSN2gsSc6VIT4y5UQqscvPkbCgK0nmoxfJfTjJdvObyVGgb9/zITZavhz4nfexPa29QKD7I5t+4hgmPOmyFCJkmZMLviVs1y/yjyCkkXVrmgUJmIA9oR3MlPEigTyrd3nf/sPpQsoJyJIWQce7HA7BVqt4A6b3Xm0rshR0yFI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(83380400001)(4326008)(6666004)(26005)(54906003)(38350700002)(66946007)(66476007)(7696005)(8676002)(7416002)(316002)(52116002)(66556008)(478600001)(86362001)(5660300002)(8936002)(2906002)(186003)(16526019)(2616005)(36756003)(38100700002)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1uyv9d6pUDNEzsVSwuinIZ6jozMq78paiwjNtDIc6c2nThsgwQzvATD73I2q?=
 =?us-ascii?Q?xNOTYKva8Z/LSUhHavjBaPV0BqX0scZLaDYQS6XgNO5RLCSGkiOobWNNcOT0?=
 =?us-ascii?Q?MVn/DjUn0Pe1VnYx4qozRwockGKcCgCsVYDVdFUbh9DxQHmG1Tp313v0Py6/?=
 =?us-ascii?Q?YbJeGMaOBKv9Lc4fp8gZKdoYJAh5AMdugHa17ECdE78zvOnA9qkm0YVJovDi?=
 =?us-ascii?Q?rO9kVIoCrUNCe6HDlZgYycRUHY7QW4Phrn7jp99D6D0meWuAnpaOjNT62HGz?=
 =?us-ascii?Q?eXNNXEZgWKb46wGPfBOkrpac4tx80pUS0nXnqgy8e7eRyZHNwyleV0ePyj6D?=
 =?us-ascii?Q?vwwsVlS6Do2NJKGHHbTV6LlvUUHKsB4JewtmKifKVHMX9IEYJ0tdEMGh5bEp?=
 =?us-ascii?Q?MfR9aiL3Q0DPBMh0EYqewpVmq7WHbNjYfRS26HtB9mgJSZvnfv30ussor95i?=
 =?us-ascii?Q?aHyV7KK6IXRjvqa4b84ktTPEwDM5Y1jpwLPN0JK/9xLPrYz82STvaR+T4usQ?=
 =?us-ascii?Q?V2dj+j1FUQJxVPo3u4gNqBjYtIkOS2ioR6eGyIRvcgfPVIz1B6tiHLN6OGp8?=
 =?us-ascii?Q?KFguwVWDi8G+mlvbseQ1yg8w0Pa9qXxPVXEgvf2K8yXlAHALljLHPgT+NPsR?=
 =?us-ascii?Q?Bql2Zy9IJ2i+mVMEqE0Kc6EpTYEYqN+PlA/MTKNHhDqHaHXWdmD3oLDrG7x4?=
 =?us-ascii?Q?SQnsAyWgJRZYIcFwsFjgnb+n8IsaV5wN2J8nN5CFkwsBZoHkqRx6P/oOwuVy?=
 =?us-ascii?Q?nf9kSwNlK7u1AguV48NksOqNW7bdYiwaIaUYSqIzDdfik7Xkua0VOF4hEMuE?=
 =?us-ascii?Q?mKkvJrugiO6ODQktuaQQ4UKrI8DqECSQaoHkFkuC0M4ApaKAgkLRZu5oYJ5s?=
 =?us-ascii?Q?IrNHxicM4/CnPp71hO1+patGdHDoBELooIY6TYFFoFfvH28yT/EOm5GVuUag?=
 =?us-ascii?Q?oWeDaSVfBJlgtxN5n5FeK68R1Yi7/7B7MfAoXZJiGz1cpspUTiEUyd19KTDC?=
 =?us-ascii?Q?BoplUgHCrCgl//9rbbv/2VPZ6qtToVNrtKFz7ifJxUKE/sMkye7v5tMepRzP?=
 =?us-ascii?Q?s7IzvC2LXPClDBE+fG/fngOqfVO9uOmj5w/fM66UzzRzxn3ztW5jLFtz6Fjv?=
 =?us-ascii?Q?LpV9E+GtT058szlgsCUZNxb2eJRtZhKoKZTrrb+gTYMKrvy+0H3S3Z6I2qsk?=
 =?us-ascii?Q?HaOA5ZXYDrZZ9QWOsP0j1M2U3E/zSuHj9Ve9ShefrSKk5gcBownVylGyMjpx?=
 =?us-ascii?Q?tMQ+ovL3fhhwybVU+bJPnfp/VrYnLnxu0eOoOzO9sOBB7fAucseGX+7fFU63?=
 =?us-ascii?Q?8WmhlnBJqRhNtTPLbbSidCUe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f477576-9e5d-4adb-4647-08d9170da768
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 19:22:46.1817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wl2KnUPAZwn9Pq+fYeM0TyiQLW/yjyf6is7J0v532Mm3S+3Q6fVkyQxBqp+xCVpm5EXOpZVDf9R0e8FxfHI64Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
exit code and parameters fail. Since the VMGEXIT instruction can be issued
from userspace, even though userspace (likely) can't update the GHCB,
don't allow userspace to be able to kill the guest.

Return a #GP request through the GHCB when validation fails, rather than
terminating the guest.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5bc887e9a986..bc77f26f0880 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2075,7 +2075,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu;
 	struct ghcb *ghcb;
@@ -2174,7 +2174,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
-	return 0;
+	return true;
 
 vmgexit_err:
 	vcpu = &svm->vcpu;
@@ -2188,13 +2188,16 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	/* Clear the valid entries fields */
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 
-	return -EINVAL;
+	ghcb_set_sw_exit_info_1(ghcb, 1);
+	ghcb_set_sw_exit_info_2(ghcb,
+				X86_TRAP_GP |
+				SVM_EVTINJ_TYPE_EXEPT |
+				SVM_EVTINJ_VALID);
+
+	return false;
 }
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
@@ -2459,9 +2462,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
-	ret = sev_es_validate_vmgexit(svm);
-	if (ret)
-		return ret;
+	if (!sev_es_validate_vmgexit(svm))
+		return 1;
 
 	sev_es_sync_from_ghcb(svm);
 	ghcb_set_sw_exit_info_1(ghcb, 0);
-- 
2.31.0

