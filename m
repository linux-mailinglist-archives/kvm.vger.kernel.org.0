Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC82818A7
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbgJBRFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:37 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:24518
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388278AbgJBRFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+sRyr3moywfTATzmixHMLJ269kKsgJEvr6MoQ4XIGPwISmXwOYnRC0xqlBqx2O670SEkP4Kgl1JIZ3aA747pOyEkNw7bJklImjAM264czsu9RdUhCsVtBeFEuePaRNJPv1EbfBHsnR88oSuoXdg3IUMjQRV8m73ApdZh+VHDCBX5ANnBaPA5Qn9vSLutAM94+7S4d95mQlmMElYtJSNttybTxox46jfYBqkxQI/UxuTH8iVZA2b22Pz1lS1kmoZhwLcGEiZZGCSkI/U57z+kgdFW27HcC2GRI8IiYHRVWeBM6QvTjZzL0vZ4kkD97piqcjJzJ9c2nvBsByagk8tZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agWbVonp+EOc6wys951O7AUjD6KMq0+cAJJVbw1TMzo=;
 b=GhUP56ngnK1g8/qBYlh0tQeoR45FjBLTJwAZhDUnrtlSY3ikyaiVzKl+cqHvNq7z7QoZDC/bb7Vk6bN5fA4rh3YHMO13Wj7IUZxhHLZzaMZCL3Q6R2LBBd6tF5djWeq+SIVlEK9llXlQ4KMmGzmyCNc29kVztZb8zjbGj0rEdYgevCNjfsfITI5KZF0bmSm+Z8H0lSGkDnDKfyE9wcpg5czUqCOUJxKH3GUOHyNEcazI9/SPv8rJC3U6UtRGgQBoT9FxzW+hKiUJ8JbZlmZjUVZWzq7dVljHqibrTeMVtU8AAAHTonvf+syBtbaX/4DUEVwnSSwvxrTlKTUta7VPsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agWbVonp+EOc6wys951O7AUjD6KMq0+cAJJVbw1TMzo=;
 b=2NlmF3CKXeEx/rR9OO7U78ZkjhXVT6sFNv/e2qbJt0xA0cPVqmB++OmFbj1Fx4TjHlC8f/p2sTyCUJ/ip8qQDqNGayH3qUZ/nOS4uMFTb0gkeVPJZhdDX9ww7chN71zIh0zhTKeVZSucVnBHGy3hnvIzOz3I+8kmF400SKnfGc4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:19 +0000
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
Subject: [RFC PATCH v2 15/33] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
Date:   Fri,  2 Oct 2020 12:02:39 -0500
Message-Id: <6d0962dda01d4347bd5044a3503c60522704e558.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:806:20::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR03CA0024.namprd03.prod.outlook.com (2603:10b6:806:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Fri, 2 Oct 2020 17:05:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bf23b824-bc08-482e-68eb-08d866f5577e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218889A6CDF11C1C3D386B1EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkTQIvPHGZj+EJYqzGszMI8OhAQpaotml+hErIe6o5OHwzkNWHQ7n8tT1sLBkTw7ZPaRn0/OCnQcT8VcKcpGrJuyXiNe2+jQj8cVKO4nt2lfUpBjNnT+maU4B6JS4NSIRtotlNnLXVk3YIZJ21AVLml57+In/W0ejfV5UHR47cBgiqjKGdx5kmXu4/CtRmRzBISRlMhhz8nhOZzCba9Da1fHod8SZ1S+x1op7g4Rs+8pGNdqp7TGgjctkVa0br6bgzGLflaBTbEDvKvNhri4bKQsUfnRuxKmXWZ96NxOUc/FDI/RJX+xVVnr5wd+JMD6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RBVqeMNnKvLet3WUhXpsXsF/Y24GsIKaUuflWk3F6W+MyROriLa/QSfEnqV4CM2pYC22Lwv5gVuEWYbklpvpBWPUUEQo4qo/PFsZlkdz7VPLpF/N3pBc1p+q/FPMWeDbvccm5lcHPYM6uv5lvBI4IFn0dMtki2xe9YtHKbpvM3UR44Cq0Pmp8mU1oJ9WakIG4aEJYRgp9Q09dvck+NwA6bdChF93GFGZNA7bzKS8v2+WsJn36o5VNWLqY1nkN0GD/qwj/91wsGZmWdffy1VdUwpprcqAtPftwlM6ffhFiawn9FRdL9yKekasNOqLgGWnvCWhtzw1T2VOfjPMZx8UlVj9HGxKifGjMvN60SHVtYziJMh4gs8JQvg9V80SsSjUF7ERC5dxfGcB2bGL4yx7Llgx8WjY495lOI/Eh1UKKaMOMto+mgmT+Tf2VT9eZDnB9aogKQUiqkfh9DfO8AdTr6gv9uNmNeZJ5x4wq3i13yGskdfojm8geD2AdLjKQlyemUsbH/GEg7UfBVPJSQAEoLt2RuiwMMsuShSkRvnbVoUoe1TxYl7vme1pWLtCBZcp8d8UcpkIGkrzMmXtFUM/uT3EIqNtPj82XlL3rfPVk38q7/6wrqdNDFOLgWV6Q7UwrnBD5OPrM9xdW2Ch+6uoUg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf23b824-bc08-482e-68eb-08d866f5577e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:19.5957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nm/2sMPaCOUqwkwTjNDu5IlhZDvpw/felQDM8GoXf/EognkBfG8NXjiaErcekD7xR2ZttqZBkIVgVjNFmr2Epw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines a GHCB MSR protocol using the lower
12-bits of the GHCB MSR (in the hypervisor this corresponds to the
GHCB GPA field in the VMCB).

Function 0x100 is a request for termination of the guest. The guest has
encountered some situation for which it has requested to be terminated.
The GHCB MSR value contains the reason for the request.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f890f2e1650e..cecdd6d83d9a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1482,6 +1482,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_TERM_REQ: {
+		u64 reason_set, reason_code;
+
+		reason_set = get_ghcb_msr_bits(svm,
+					       GHCB_MSR_TERM_REASON_SET_MASK,
+					       GHCB_MSR_TERM_REASON_SET_POS);
+		reason_code = get_ghcb_msr_bits(svm,
+						GHCB_MSR_TERM_REASON_MASK,
+						GHCB_MSR_TERM_REASON_POS);
+		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
+			reason_set, reason_code);
+		fallthrough;
+	}
 	default:
 		ret = -EINVAL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 817fb3bd66c3..8a53de9b6d03 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -534,6 +534,12 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_MSR_CPUID_REG_POS		30
 #define GHCB_MSR_CPUID_REG_MASK		0x3
 
+#define GHCB_MSR_TERM_REQ		0x100
+#define GHCB_MSR_TERM_REASON_SET_POS	12
+#define GHCB_MSR_TERM_REASON_SET_MASK	0xf
+#define GHCB_MSR_TERM_REASON_POS	16
+#define GHCB_MSR_TERM_REASON_MASK	0xff
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0

