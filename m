Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2922AC875
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgKIW2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:25 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:33312
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732202AbgKIW2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiHuG/0Hvy6wrIychBqzi4VOyRFnJvvDCmGZzaPcpeP7NFHzeN8BHj8yTWI15F1+qdBKAARYP+OJc7Fbpmscli5gSgHsTxQw8TGOjc12b1Ge8fCzjvCno2G8ebA+nB0vLZESTjGn1FDCBpNQ6KtsZSx/e8M1ig4w0isHUY8vwIoGRy51q03leXLe05jiwC91/UJBiU2jGB5CDYbG5GWJNN6ci+keTE0ppaEtASl0MGR8kuRtlOFkPN+eNsETvCtCkphz1+USmxK9O5BdpND5vIxQAA9qf9Dz0NsFGFH0BGBoGnaBxrhq0qohYsMbjFj5tydZlw1yJr6mUc9O/8q06g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAuA0ixXBN57dG8/icE1i2U+ntvPfiuvKWAoTLo3Ttc=;
 b=I298qycMuQvyJzzPV8GqOTVjfpSh8s05gDh0Y9jBxEgBtb2K9STs2USYlZm9CMtBviQJpQndkn07xfJ51kX8exqOKiFUHGu9qG725kf49HhWDjHnQmxECuQiM4Al/FTREtfb5WKOhWtaFEwxbBtuMmQvnD6WNK0/BCP5obYfSzye/xFjZr4ixT0HBbz9CFTJY+1xJxZdPk0hRztJftuZyGHcRYsXGIzbOxQhaPgvlkA5XdgMUai0gmhixbkkxSCjQg4Bl+TdvNGEc/xEGIGN9uKH+mq5mD8z6xNZ0KxR6O2yzyyKuPpZL7f3SWCyWkaj7R0dfQfY903pp+5P1Nt7HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAuA0ixXBN57dG8/icE1i2U+ntvPfiuvKWAoTLo3Ttc=;
 b=157tl81QL3UFlhBVKyrR7VOJ5ABSoPXZfFqp61/9mJY1UbEbLHBZB87JciKit20IZob2VIzwuPY7HfAekOAK8bkpeZsKsnursi8BJZmiZFtdQbUpViuuMTiWQk+tj9epHDOxjJh2qplFRSCJ79/XaxzXa8wuMagPI5o3To+iR9A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:21 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:21 +0000
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
Subject: [PATCH v3 16/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
Date:   Mon,  9 Nov 2020 16:25:42 -0600
Message-Id: <3ef183f7fe44f91e9b0dab1c908f8580184ca303.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR10CA0019.namprd10.prod.outlook.com (2603:10b6:4:2::29)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR10CA0019.namprd10.prod.outlook.com (2603:10b6:4:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:28:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b6e4fda1-5ce7-4d19-421b-08d884fec3bd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058F0B5CC6456D0C0423139ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bspn8ZYNtAeo719Y4QEar58pCwUeSKjPefFTSBwOYbaPrGzcTJ8gUJY8aivlU63ycM3rCvqFhSJklTQF1CL50SKsxh7309FQPOiqZnkvobeRdh2rKLWS+K6e/tSDt1k2tyWCf+8/FSQHYG00HRDYGwg/BpBmah4MV4DYoI5ts8tYj079bd8nXkBeE3EQ+zxoTOU8jlNcflldHGJfSkymWXRP7I3tp7DXut5bPYEKPwvaPRWD9p3y3VF6xtYXCHg0Fco43LIz1iOwht/suBNGccc6PiiTE42uXiF1W3R5nl+bbZulgAfmDeivsAm9iHay
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ShlCBiEVdFV5x0j6hRxwnBvTdYV7ybcqwprvfTwlSmwjxmzjSKkIu5lxYK6ySF9VH/O29JwVTcDmC/rNA3BGzxiQ89UciZRgyFepBI0oWXgYxIQm9goNOrPkSReL0BEYwBbp1buFhlfgB2fA17goASZbj6q+5O5SRPSzZhn0Ok55rz3OEylMdjGMArI9Bhcby1X5/nUChNnwytl2iGTamRisAEes/NgjfgQXuY3Hmza4OKAaDwMTODBaP4ZYSrqPOxNX38HYZ/tGzEBWgzmBHpt/ot+wKfgCxzuIytWyMc7tAQR8LMZCaNzkUt/DgVvbG5mtvVxw4raW6UmEYfz6/o2eHpnjU2SLPw2xZPFQdrdb8Wfe4szvz4l6XWtjLsdSv/wNnSCYFQYECprY7VOj6lxH/0jqnC7IOgQzzkPtj2QHJmIGlrcua0ywF+OZlL6yx1J2idIg3mEB51q1uCiRTvyLSznX7ljVV5lOM2qhbjbNP5wNnhWirg5ZxAJEF3Tu7hr/Rttsp289X2WY4yGsmRDSqmhX8YdATI5jeXqY5YOrfaygZivFQyRazt2jQOCrvv7RsJC6klqj7il53lR7Ulch+/NlkjEOs3XJ3KEblcRH+K8ugeH1WYRuIbr41KDv6JacCjXrThCn3gKT8wi6hA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e4fda1-5ce7-4d19-421b-08d884fec3bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:21.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZjylaKxcvPox2ftIzSSDJzYmerLoBo71I9VmMMErUuVRkPdstBmT+B7QBRFZ5FFEIjWBz8flVq4w6yFMnO2sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 24df6f784a2e..de8501264c1c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1571,6 +1571,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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

