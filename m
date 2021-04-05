Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83693542D0
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhDEOa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:30:26 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:18177
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEOa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:30:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNQOtkm1cyMiUK+tTQjI1dUj0Zpkwba8zicAKIFh47yFPSU0bQJSsiRnaA5Jv9o5xIgC97i1PNjXxrXHdynssmQkH2WVqB4x0IuYrqBAJDgiJvSizIGM3mrYQWmfl2VqA0IpbKsxiJ3CwcTWvL+2QgpKnYQXhb/OfrEpz+4joL4PHmNYFXyBzTk3ofBzGei2AYRXM4absvE1zyGxtsSlrj7HXM+EjM5bjQC1EJe+KQzp3xkASmiTREFUWCGoZB9NFi0naf9igu1+bWNAicrGwqKi6sR5eQCtYyK9ez9ERR2P7ajLYGp7xxK3OyN0rB1se/o1If+RSpVvbxu+WkH5rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srKv4wJn6605FhurZXMhV1Mx3xPzBtYCQYZ8fqgXoMs=;
 b=I8tWoNE2Rz/CA/PPhT+90rJ26JrMqrQgEvPXbBDt8XQf1RJeCKqyjA1k7D3N5QDd6TR4L34Iir9/JBjiRNlhnLdoB/kYKnNu9C6OVykqhELGkqaMGeSEWjpPNpWo+GRWF9Z2C5lC9lQ5YKZC3l4i2d1SUkEM+sbAPlOJxAz5LYOu+Tp+itWct0Z23RHeME7FoE/ljbr+xsaEUg5NGvSErdlfycVmUMCg9t35ht6ScK6x1mP9KVjthtzBhMAYf1hV1oMj0lgBc6RBRWFwDbAFuxxXMdxxO7HihdIV9HgPX+46uu7xRW7gEJPJ0YHgm6dKsfRBtNHLsON2wOM6uvAVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srKv4wJn6605FhurZXMhV1Mx3xPzBtYCQYZ8fqgXoMs=;
 b=DXlQAv8AkBayNZ9Q7onHFZLjf2jjvEYoKy7+3zqxquAiKzpGirn9Wb+NDdecyLg9mH4KfGvLN/8tD9nkdwR1qQUhhZm9J4aKqyJPdtuBC6hzQTswPU13azsSg47bIb+NqI4mwlVdbxt5X8Vkt+c5mTRv3EXdeX0Kd9Q+co9UH7E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 14:30:19 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:30:19 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 10/13] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Mon,  5 Apr 2021 14:30:09 +0000
Message-Id: <69dd6d5c4f467e6c8a0f4f1065f7f2a3d25f37f8.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0232.namprd04.prod.outlook.com
 (2603:10b6:806:127::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0232.namprd04.prod.outlook.com (2603:10b6:806:127::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 14:30:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3789e13-5de4-42df-d671-08d8f83f565a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509F477C6D3848452DB168A8E779@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eWyjm5DDLmptM6fkLBJlzYwOdlzGAHvcuobym3lwmg/zc58y3Mnv4BOyJiIWQB9KGtN5ouZ85Fs/g35771ysfXaGSIyP8+fwJ3hNpVPRuRF5c823LJXThLrzFaNzsD26jq5C8q/a8KNMuk0xshKSwBSXVmH+a2/EfyaLhkLxbcZEsRnDs7R5oPohpufhStBG3IvfTBFq6D71ukGEALoMUMD1xmh5H/d8nQrhR8x0Y4pBnSFPrIT8lwOF5AUcHUva+2VDvNncwoQmGE1iixo+C7EWsKAwrLY8CZFLX429M6+WW8gaAFrf5L4XpF3pYg0vi4lDDbYVAq9+krlkKPqdpVL5w3BiLI7NeyxUukKhZymOZFJOOnXcvlmdLtI79C/0WAgvDvMEOklvDQ5HGXJqHfMLZYEFrPxkYceNv+qnJssADPkxuiAnGIy5HiKlCs7N1kbv5bnbnOw8IpyFbKvHDbyRUzTHOXbRJVzhf7L/zwIsy9knRJb4uNJlt7XLSQq2g1sRCW1MYS7B6xlWVqdP9+iKs/jYK1HNaeyQfs0BfpB+ST4ojcDPJorGOxqthn0FJMZurOvP5dbZxNCCUs09boPciQn9r/Fiax71KTFpdPPfANMYZz4R0OhnL/GkzAWIft9i+BlB99sHTmqteBCqdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(7416002)(2906002)(6916009)(8936002)(83380400001)(8676002)(186003)(26005)(38100700001)(16526019)(36756003)(4326008)(2616005)(6486002)(956004)(7696005)(66476007)(52116002)(316002)(6666004)(478600001)(66946007)(66556008)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UqsvhxaldCc3qWqN0qjQW2qGFXYZ/yDaxUgAiQoaKbT5EcPX1SgbSjJyK4k2?=
 =?us-ascii?Q?Awx9jR6zHjXwHL3938NuEvKSKMkP2is/3UDL8hRHyR2vmd2xf4YOVxojQTU4?=
 =?us-ascii?Q?iuwljD5N1RvRCsRoyQeX+OrrllA71muLwl9xkWRone64/yY9AABQ5VhPSnhm?=
 =?us-ascii?Q?AU3wn8LBPQTMZ9BUOKNN9SqNwLWSCLyLd9I73ElS06nZkiG2402D3TuYlt4y?=
 =?us-ascii?Q?xgMJhfNDCPzO05+PJCqAhNTjhpSxJvH2VzXhyNcMLF6x9jd0Y5eEDI4U3K2Z?=
 =?us-ascii?Q?C47ftsO1TNvGJwZvgLPBRDEjsAE144uToUukxnCluWgJlDWzsS6nA7+yBoWF?=
 =?us-ascii?Q?5FNpW/YS6fRQ6ZmjFadoE0gJxVW1+r4dL7RBorPCCpaPzaCMccxGd6PT5J3t?=
 =?us-ascii?Q?xaqaULo2/vB95pgzPv9yWvfpp9bzORz016BYVDqd7KURZI/mPHVmz+Eyc00r?=
 =?us-ascii?Q?Mas5+8fO7AgeelQgJqYOm2n3u4Srx+30YaALpELZJ5CWr3XutyIzuZ2oOcxb?=
 =?us-ascii?Q?udTTY/pUm70Y1ti9caOSxPkQV0We1aGE9tH9zj17sQofQb5Z+Yrnx2BfhRnH?=
 =?us-ascii?Q?eFE8KH5YukL7sB8++LdWjUMeKPgRbGSpxG7ZU3B5aB9O8fmM6ziwQgm2+PPq?=
 =?us-ascii?Q?UOas8EhL88Rzyh1igjoE9Rg7U88eKThLqsndj7WtaRc7GHffO6zQ4xUdD4yb?=
 =?us-ascii?Q?PrLGtA3bTO8gTWyyPRxMTkq1/wj+cTdUhKgGwBN3VJ31uSBP3SBRcA7VeTLP?=
 =?us-ascii?Q?m2aRr/HINbIrOis/7zYB0qPUs1u8baNXaGEAacT6rR62zZ34t1um37f24F60?=
 =?us-ascii?Q?UDqfQohC897ZJoqHaGMIefif2xIdOkz19cCogQYS4l94vrybY43D/0yZslBW?=
 =?us-ascii?Q?fBszzyCjNnpe+r3ztZrXIEUoaG2jk2/M/R5GqihJqbEXTNvyAh+mAbut1pFS?=
 =?us-ascii?Q?NFN83DH04mhrvzqoYY5EskVRNqDTQu/phMo7xEx8pfCRksyCipgysBtDNTic?=
 =?us-ascii?Q?Op95gx6ZnuyhPtTEqgfq7G9hjNQRXjemwtRlzNw0kQC3NqIcwYDZehQvisS7?=
 =?us-ascii?Q?Ue0A50AGJxLrbaPaEYPp594v70aUIudqqfXXERsPp5WawJVGhzPUPOxW4Ppa?=
 =?us-ascii?Q?uqyafzOKAtXuBU6d/spt0rKGz+S1ayINSDVFe+646oz3aZP275hI6p1ZSflB?=
 =?us-ascii?Q?ZYSDz/kkt6aeCtor6O0Ikjht9xmLsaAsfa6rH7daDBYZvKrxHdmCQrysIy2w?=
 =?us-ascii?Q?bjaEM4zkHeIyUAEnq5IocrIcTj7iTbgEwYJaFmW1dRptDP+GhsDm8FMT6FzB?=
 =?us-ascii?Q?fDLw9EHkDTPQYGPGj/OH48YS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3789e13-5de4-42df-d671-08d8f83f565a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:30:18.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJ67ouWGT6MC37KtiyZgEprbMWzBsV14pRw6X9gxbSha53gF4VMEy5eU8cVCuyh2wMbkJ6nc7GxeW43wvvdSNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. Also add a new custom
MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
feature.

MSR is handled by userspace using MSR filters.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/cpuid.rst     |  5 +++++
 Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/svm/svm.c               | 22 ++++++++++++++++++++++
 5 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..0bdb6cdb12d3 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                before using extended destination
                                                ID bits in MSI address bits 11-5.
 
+KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
+                                               using the page encryption state
+                                               hypercall to notify the page state
+                                               change
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..020245d16087 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,15 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_SEV_LIVE_MIGRATION:
+        0x4b564d08
+
+	Control SEV Live Migration features.
+
+data:
+        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
+        in other words, this is guest->host communication that it's properly
+        handling the shared pages list.
+
+        All other bits are reserved.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..f6bfa138874f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_SEV_LIVE_MIGRATION	16
 
 #define KVM_HINTS_REALTIME      0
 
@@ -54,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_SEV_LIVE_MIGRATION	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..4e2e69a692aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -812,7 +812,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3cbf000beff1..1ac79e2f2a6c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2800,6 +2800,17 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_F10H_DECFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+	case MSR_KVM_SEV_LIVE_MIGRATION:
+		if (!sev_guest(vcpu->kvm))
+			return 1;
+
+		if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
+			return 1;
+
+		/*
+		 * Let userspace handle the MSR using MSR filters.
+		 */
+		return KVM_MSR_RET_FILTERED;
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -2996,6 +3007,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	case MSR_KVM_SEV_LIVE_MIGRATION:
+		if (!sev_guest(vcpu->kvm))
+			return 1;
+
+		if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
+			return 1;
+
+		/*
+		 * Let userspace handle the MSR using MSR filters.
+		 */
+		return KVM_MSR_RET_FILTERED;
 	case MSR_IA32_APICBASE:
 		if (kvm_vcpu_apicv_active(vcpu))
 			avic_update_vapic_bar(to_svm(vcpu), data);
-- 
2.17.1

