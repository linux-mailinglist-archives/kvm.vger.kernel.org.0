Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C542B6B40
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgKQRJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:58 -0500
Received: from mail-dm6nam12on2085.outbound.protection.outlook.com ([40.107.243.85]:11456
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728926AbgKQRJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyrFf2Dae8oRafuZ/sVp6gPmQ8GZ7r+4VjvBvwhW6iV4VZIru0o2hiU8Z/a5/gfe6j3A5ORdG/htMQN1I4p7ISq+IeuBbXMDRSfo6K0JDeZWmWjx53Gwz7kmwYnK3FPw4jGPbiqiLZ/h6TmFuh+yHedejtIE/Hb+5b8wDlerZ+lycH4nzHaIbgT+jctE8dCiQ17AC36pqifT3tT4/y64MMlWFSNFy4BnTC+ZyaNq2P1ghfgCsA/OGDcD2M8AKykijSs/LecuXw/cLxFZYgeY3Y0fp4o1i6ixdu+CLO+mhnTHxLOd9oqfncwvGgvrn0smXig9g0kqfWbqdMp2qMlMIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qHsvoL1T6pLRCEwBEKf264XZQXlfcgpFLEa8TmBkAI=;
 b=WjOCNVJIULlN9kP1nKA538OPgrBJGlErXL/frErptCWe3r5fc7QeZX5+hU0UWhRpCrbZN4TahCXnQkGI87M28qPGqmBmwi4EW7DdXzXub9DD/MQNs8uMwpz8NUpF5sWcgCjWhkvyEnlFAKVBshBWwFb3nwcufVybYGrCqfWcNjGn8xUJTVG3zBtWZsyH24C9LHFSVvgued6lqG688syFYzAkAL14JZcFIbWlxbg6aeK7E+fE5LuF02UxXE4OzObQn47ZVxGVjlKSo+EX828RTXKXYnvGcjlki7FYo+HWt+s04q/JF4dZxU2NUDpoWgSj5vjj2VOnCFGNZRVzQxYRIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qHsvoL1T6pLRCEwBEKf264XZQXlfcgpFLEa8TmBkAI=;
 b=LBoZvlv8b0mK0uE4kpG4AaRiARebpdNNMCFE0YmYUAYqJqFoUw8a7jGmONpO5hj866u19zrjemGa2vU7itCbhzaYQQC5oHs/OOpQVQlskreTAoZ+5ox+OsKrea6lsVw4M6BN+xrTKdgpiDPVX7lwEeHpsjgHZfH5JEFq2xXDi/k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:53 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:53 +0000
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
Subject: [PATCH v4 16/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
Date:   Tue, 17 Nov 2020 11:07:19 -0600
Message-Id: <73021b2cae2341c6cdefdf268f39611e476af0a3.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:3:d4::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR05CA0002.namprd05.prod.outlook.com (2603:10b6:3:d4::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:09:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e749b299-42ce-4efc-e50e-08d88b1b9960
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772F2A22D285D2DAF33A47FECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJTy8KvvHAD+6CxC5wvgSvEGrQS2MsAIh2FqvEL0KlDrpzPVOTbkeiPeiUfX7wRei8azuAEbsoV35tgOiLq1WW72tjpzRKqJWXWFx4uDYr0NitltU4wM3unuz23zDR4RLuM/xOoqIyPnc+TB7KHfesMzTFXjTUSyVtEul4Gd6Kqw3BWZZovY9uAIWEeiMIE0RGpgQuabhri7tJ1WvJVgXXDqHHb7ENV0036gyKtooAbxGjD9qNTWR+wo6Tx3ldC+0Vz8utsUdYcbIwnLMdBHePjpuJUXNH8XdIk5hGfZd3kRhqM1Q/KAAyZJI1ndQA7u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RHbCQpjR3JhHAXWAr71ObVgiSYO9C9Hc9W34ddM6zpL43UX2xeWpqcSl5NZ/e2DgL5KGXcSsHvZfnieXf17MRse+a1pXKPApF28WArAvOwVlbjhCIpaZGGZtIyE1ey6cOY5bLIzghTLZWtBen6ITTRdpB/U2qW0nWbAF2yfVA63LHxSX2CpodCishX/MJFhstSRuWwGm2hL63X672x2Zm0WHJNZ7y3V7Uji2dTZFK+TGHigQdC3Bc7mndPnsN3vB6fqUfTn4tZWcUcbWeY7KgYfJFtq0sOtHf83aqC6Up4Lq7MSoxePRXgcBQvDVucL7JOVFQ69r9JFltZ6ZPiIIIHSpcY5sEtt9WQBRxuXJjZoFujMV6P9dNFhoEoBlDOuGN78WDABPbKx9XDWUdwthQHUNzwW0KfW5Nt9MSwEbvkvOixP7467pefCrltLNM2EYyAqxB8z1OgsbJm4skDElobhZ/VAdjwfjTICwBH+ulMlPH5+4HTZ2F2vPATUMgJTocd3jNlgOAi8WL1bSoL/0a3RpyibjbpE7tF1Fu9WtbX17M3C9ZxBVd3Tw1Madhqk0ytt6MyXfhrw5gzf+fKIYoCAbJp0R7kDd8FtBIhwJ+afMnk6d8LI/u3z/fiBv8nRASSiz13+Iq70bPOdrurZuVw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e749b299-42ce-4efc-e50e-08d88b1b9960
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:52.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWLteyVfP5PfXCtAYJLIKvv5TtC0S55nXbfJlA8sjNL5oxA/zS6Pl8ojZ7H0t2xEvo/wwnTvhO6seJV4tuJ59g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index 53bf3ff1d9cc..c2cc38e7400b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1574,6 +1574,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
index 0df18bdef4ef..7e3f8e3e0722 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -542,6 +542,12 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
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

