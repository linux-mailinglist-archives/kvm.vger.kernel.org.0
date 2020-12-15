Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3449F2DB1CF
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 17:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbgLOQrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 11:47:41 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:53647
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731194AbgLOQrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 11:47:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXZeMnAirvyi3UOE0elwZwkZNDCckuT0TOJbfT9Lk24ohyFqUDAmVpZZFqkHurL7ArMWqL9tZWkOnzsN3KMFwfTbjM18k5sv/2Ogn+ozjlH8w24f6poxrrXVg4LfY7aaTTB9gCqovGGY5ICMkWhmjJo7J9RqvIeZOjlRUovt+JlitW88IkxJST4INp0YvTGpmVgW2WwRubRQdm3oFthdVfBLeDKPIK0T/fAz4MPHQs0C552Ts9nOeNHT1IVHD8qgdG8dTgHvT39OenAdq9JSA3idshT1w1Fl18EpO47Y+9kGiBzmtzhneTim6csOfRYXMY56mLQhhDUIxpFDxwVLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XcV+vKFxPQf1qIn63S9bl0AODPlk76naIEZeCnz+lo=;
 b=GcuxV8j9co1b9d0oIBbcztyPY38/peYrOpGTwGYYjrJi/A8vd37wTBQB9EIy+EvC/QtCXxTh6XIS8hw+I74Mw5hmttr3CdWStRGf2MePez0TFG9L09OR2a4mmAHHW9T8zRXAN3RB1+SYW0MpNTbnxYsrBeLKcfQy7e+Ksa9M+Xnm234Jt+6be0gJW4wHB/fdEaYyD5xdLkSX7zcFUELn4RWMBxx5RknfqkHtbsCHg50tJZ9/1sQBhJuzuQJv3ZjRJa3ABu43RQA3JRvFCgmozLzgRBpqNcH3Kb7uwwArQhRq4EoP5L3PTZeKkweR/zdX5S+05eNgtZeIsG95wLjmhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XcV+vKFxPQf1qIn63S9bl0AODPlk76naIEZeCnz+lo=;
 b=2K8g1av5TqlOymljFmBwej9NLG4Gzzqz8tWPcu/UnF0Q0NMq8BOaQ0zKWr4+5oInp94tnLm3ebswD2tyNlbt4QkZc3uQb3xQTzUP2RPiRdXVg//FSHdnJ4KLbFHxDa5ZLEEYQkka0ZoaPQlY2yh/wwuSDJUzYCGvA6qSCMQOFWQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.13; Tue, 15 Dec 2020 16:46:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 16:46:46 +0000
Subject: Re: [PATCH v5 00/34] SEV-ES hypervisor support
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <e348086e-1ca1-9020-7c0f-421768a96944@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2fac329e-8e4a-7966-c2c0-05ac0bce8e08@amd.com>
Date:   Tue, 15 Dec 2020 10:46:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e348086e-1ca1-9020-7c0f-421768a96944@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:610:54::37) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:610:54::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:46:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 54f2a068-5ca1-4c85-0aef-08d8a1190297
X-MS-TrafficTypeDiagnostic: DM6PR12MB4220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4220B7E895A6E77E7F71844AECC60@DM6PR12MB4220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhgqLPD3zUbd1BpRpCIZMRZ0SXeqbmjDgnk1LqhQDyVckbCIEhZ49Ydx5+JBLg6CbVpRA6Jmmk6VgAIviUPdP1i2MQZ1CCAdEM5bBefwpGSGCvY+g4j/2W1OdqEchC/Kmrmpz7yL0t66Lv3uYILen/tlfNFnqIXFO6i4H1s9wVA8qF/oeswikFBz5AYHkMgrakjg+VkgmVKwtdrRyC23G3C/0BREWQzNSmbo1JVnckifugL401ZJXPSOYFLJfnE3Z38lQLKO+j4FRN8uwRf48J/etUTP6BdT86G588LHW6nBgYEZpUKF0faLdXHX0VdB8JQesfBKlo98Qvs7R1oVpqKlsijgFdq2LPvlsbWY4cG4K7mTk8tcW9JbQ/CLmx7KKB4HW9NAyWJETpJEfwqG0Y0saxICrg2SIa29puA5Kb73Inr7YxpJ62//eYzh1yIw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(66556008)(8936002)(66476007)(66946007)(52116002)(2906002)(7416002)(34490700003)(83380400001)(54906003)(53546011)(186003)(36756003)(16576012)(26005)(31696002)(508600001)(2616005)(8676002)(956004)(5660300002)(31686004)(86362001)(16526019)(6486002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?enJYU2dpbHV2bVZrYVpDUGtQc05WVXh0STlpdlBrZG9iNmwzNEpLeHVHSUgz?=
 =?utf-8?B?eXpaNytVVGh1RHNUc3k4NFZ3VytMV2RFL0xsazRDS0UyUzZpQm5vMXNzcUZU?=
 =?utf-8?B?aFlaQzN4WkNhSGNzZ0prcnBjby9sYiszSmYxL1VzRlJ2aG1CN2I3QzhKYUFK?=
 =?utf-8?B?UElrK1JUMHpCMnMxVU44SGw0VWpuYUNuNWlyczN3dElkcWoyT3BvSHB0dTdT?=
 =?utf-8?B?QTgxemxxNFAxTWw3VlBvVnpMUFgvcU8zMlVqeFIwYzdCYWpDYTJoSUNPeFpl?=
 =?utf-8?B?dCs3amxsdXdwclJZZktaOGRpNnFESXREUkwvTkcwQ3FOKzgzYUUyQlNxbFh6?=
 =?utf-8?B?WjBXYlo0Um4xUGJFMHhLL2J4VEtXS0FmMVk0eFAzQ1pzVEJOelNpemVTMFpy?=
 =?utf-8?B?WjhickJrSXhBTGtuSkZqbjNvMzJhZXduRXZDSW1za093VEw4eDV1K1BscW1C?=
 =?utf-8?B?czNDT2FNU1FrM1d2S2doUkFPeXRsL1VmZ0x1emNTcmlnaTM2OUUxTXF5TWda?=
 =?utf-8?B?WDJkaXZaNkNRRkJVTkhhbFRJaXVKT1pKN2dNbDliU200OUN4cTVndUZxRVNv?=
 =?utf-8?B?WVdxU1pPVk9UVU1rRzB1cWRDYURxcEFCNEU0OTQyK0hnVmp4OC9NNnpTdXRq?=
 =?utf-8?B?NDhDWlpDM0NCekRkdkVPZkxwcUpDWFNoNzJnOEc1UEM1RW9MTUE0dDE1WVhx?=
 =?utf-8?B?VlR4ZHVjWnZsMHljYmpVUWVIU0tTcTFxbTYwVzIvR1NRaTVXV1A4R0I4Rk9U?=
 =?utf-8?B?M3grMTlEOWt1aFVkdFhyeTlSVW1CVVpTbTRhblVwYitvZGxzRWZvbU91aHM1?=
 =?utf-8?B?bGtZMERwczBZcFE0QkJBTTh4czNRNHA2TW0vbWM4M0RxTmROWERUVGlSaEd4?=
 =?utf-8?B?ZytQMklQUjVjT1VpbWc0ekg0a2J5aGQweE8waENOTFNNTXNBenA3c3YrQWFX?=
 =?utf-8?B?OHdxL0VBMTJWVXVuZCtuaGZ6Z0RlNW80T1dwYk5VTnVUWm1WZ0k2cmtQcVlm?=
 =?utf-8?B?Tysra1lmd0twQ2FUWmNLdi92Z2hTTlQxMHQxSFlSN0ExMnJJck81cDBpWEx4?=
 =?utf-8?B?dHRMdVJia3NQVWR6SkRNRU9LdUtnNS91dWp0T0tMcTRQVzAxVzEzTlJpTTRl?=
 =?utf-8?B?RGw4ZVMrNm1vWWkxU1R6Q28vT3A4OUxTRjM2Vmw0T1ZHTEYzcE92ZmVZZ3lH?=
 =?utf-8?B?bUJuWFlabWFZeWpVWE4vaFNhT3RIYm12TzE5K05uOTZrdkY0Y01MM0h1eXBD?=
 =?utf-8?B?UzF1Sno5Q3JEWkd6SGZLZkZJSS9kOVNlajdrdkh0Y2s1WS9tR2liMldjVjNF?=
 =?utf-8?Q?AjsRt6si5ZYKMGcqJWAiUsxLOJASp/PHsU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:46:46.1213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f2a068-5ca1-4c85-0aef-08d8a1190297
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7bqmR+GNdvqkL5xRDUrs9w1pOTWSkg9GhD6W6XzLwuCHH50xMVqvOBX9JJ8MPHcCf0PtUGGqvd+SGMXg9sJqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:13 PM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This patch series provides support for running SEV-ES guests under KVM.
>>
> 
> I'm queuing everything except patch 27, there's time to include it later
> in 5.11.
> 
> Regarding MSRs, take a look at the series I'm sending shortly (or perhaps
> in a couple hours).  For now I'll keep it in kvm/queue, but the plan is to
> get acks quickly and/or just include it in 5.11.  Please try the kvm/queue
> branch to see if I screwed up anything.

I pulled and built kvm/queue and was able to launch a single vCPU SEV-ES
guest through OVMF and part way into the kernel before I hit an error. The
kernel tries to get the AP jump table address (which was part of patch
27). If I apply the following patch (just the jump table support from
patch 27), I can successfully boot a single vCPU SEV-ES guest:

KVM: SVM: Add AP_JUMP_TABLE support in prep for AP booting

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification requires the hypervisor to save the address of an
AP Jump Table so that, for example, vCPUs that have been parked by UEFI
can be started by the OS. Provide support for the AP Jump Table set/get
exit code.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |   28 ++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |    1 +
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6eb097714d43..8b5ef0fe4490 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,6 +18,8 @@
 #include <linux/trace_events.h>
 #include <asm/fpu/internal.h>
 
+#include <asm/trapnr.h>
+
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
@@ -1559,6 +1561,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
+	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
@@ -1883,6 +1886,31 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_NMI_COMPLETE:
 		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
 		break;
+	case SVM_VMGEXIT_AP_JUMP_TABLE: {
+		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+
+		switch (control->exit_info_1) {
+		case 0:
+			/* Set AP jump table address */
+			sev->ap_jump_table = control->exit_info_2;
+			break;
+		case 1:
+			/* Get AP jump table address */
+			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
+			break;
+		default:
+			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
+			       control->exit_info_1);
+			ghcb_set_sw_exit_info_1(ghcb, 1);
+			ghcb_set_sw_exit_info_2(ghcb,
+						X86_TRAP_UD |
+						SVM_EVTINJ_TYPE_EXEPT |
+						SVM_EVTINJ_VALID);
+		}
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(&svm->vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a5067f776ce0..5431e6335e2e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -78,6 +78,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 };
 
 struct kvm_svm {
