Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9203542C2
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbhDEOZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:25:44 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:22862
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEOZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:25:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UExTH/3s/niz6XMjSjTMX4DryhPynwNnHFBFhEoHYBg6C1ekfwg6o8KH0EUDOSX+gVDaUDtJtSKOeoHIxRi06astl3GRyppKj1Zx++L4f2z84BOId7+ls4Z+VpXA2nyvFPGN79tzsuSs1FBqKgC5lrtVwyYUZNPCGrTd8w2QN/2pAI6nQoTwGmVSgsi8L0Vq9+1vbX78fyMYsQB4ncnWfEt1cdbqGhxNcvHQxcZRpbNDtSrKsEElLOCmSiVzKkPovq9Ol5m5euzIAejEWfnHaMj1CKpv/hDk2FaaptvGNTqHdkDKq5ZNX2kjTftU7Vq7xmnuvAn++GmQDbAumU0oZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecWJetWk79BG8nSoPDpZq7XRRwLaEAjNQ7SI2nOsNIA=;
 b=bhEecpHXtyKeRxPY5Mh4zNfywFKMFDwrn+er2OaDHlZGbjDWH+D8UcYNRyW7GUB80x/ajp2m9PeyIAFv3SCiAU6EVqZQDx3jmmUHZb700tJEmY4fb08EwCsklc379b1X5dss3/UV2O3NvUjz3TwcTNt0TqbJTOwPhJH2tXAFovSguLxi1h3H0xpEYmHuTuhwfICIR68Q9F2yeDFFzsw5P7txfc3I5Z8mmvI1J8/956bSD8tprHUFQyiwEM3QM6Fn40tZlmnddCt3VUObhFLsdii9fTxJifMUzodCBduup69jCvSRrKX1Q4oCobIKJxRcFzDwvln8oM9hafduvrLsjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecWJetWk79BG8nSoPDpZq7XRRwLaEAjNQ7SI2nOsNIA=;
 b=vNL3nhk4ZWsedP2xAQYUwV3BC8CT3QQg+xjrNl/iloqqsPhvX/LpUR+qzmNeVv2uL4ZjNlF34p6dbj54EG1IVsMmDLA/ed6j5bjzWzqY4CZFoIGxJUaFytdc/+aIe+ySOCTShWXximbBJGFlI93vXQTo0cbZ2CCir7K2Q5Ub+38=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:25:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:25:35 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 06/13] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Mon,  5 Apr 2021 14:25:24 +0000
Message-Id: <d08914dc259644de94e29b51c3b68a13286fc5a3.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:806:122::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0102.namprd04.prod.outlook.com (2603:10b6:806:122::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Mon, 5 Apr 2021 14:25:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42f4af13-7ad8-4951-3667-08d8f83ead2f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2767875C1F55E620B24656428E779@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoBpvwgLo7zrEE3onrDzfEH5lgjdq9vu1yyp1PHqahatwYcHJHGlP+ET+eSeiRDdq5v1nQyXVult22QghzBeiH+Rlk+iYLCQBR4oHbgdiBk/fOI8hOeVD+2a2JtvRF2xoqPq3et0f65ujz4gKKo89BcPaVEWKlYkcf+8k+tFPGBZVHjpf815NWYxORSzraCk5UdOeYZ+nH7jrta/eNo6VPwR+WlVwwaN2pIAQAMG6U/j3f6BqiHeeURAE0x92JwbLHq/osEfJ3lG1MeDrVIK3kIy+mww1f/tvfcWeV+xN/u7AkatMZmF9wCINaAQKN4UIZnAQvOgHJv/H1yqEXZyKy7CHOyGbD14qCowtAHsL9BaIEyXA2OO+X5PmDi0kevoG7ZMcKVaqrcNijNi7kYP6EFIigxP7+yykIajXokcguGqchUD8SygkjD506SvtJWsiIk5BYlwkAPVYIC/Q5L/fB/7XZWxYULpGdK2gD0NXon7Cb/vvCSIml61QP60+n7SLpOFYjKMhtNp+5ynJRe72youfwwXpnhuwTD1Z36GuAk1XyEGuBRUcoXO1cpnfLjG4tneUptkwfwghG9PyARxu3W0meTUOk3UCycq1Op8G76wfuOB0F+t2cN6kckDKn5vaWcb6WercVfIHPeDX6x+PA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(8936002)(66476007)(478600001)(36756003)(83380400001)(7696005)(66946007)(52116002)(5660300002)(186003)(2616005)(16526019)(26005)(86362001)(2906002)(38100700001)(6666004)(6916009)(7416002)(316002)(4326008)(956004)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ckFHQkMyOGEycmZUNFhtZURua0hIRU50dFZ3QTVGVytwTnBWY05QOGRraFVq?=
 =?utf-8?B?cVIzM2hzclRoVkNGMGJxODBURjNVKzEwT1RwZ3UzVEkzbmRMV1g4cTdxSXNn?=
 =?utf-8?B?TFFoZTVaRUI2aHVud3dROStSYlVDd1RrNEJyYW5VRTBCUVJQU3Q2V1MrOG9p?=
 =?utf-8?B?K1gwR0NCbC9tVlFNWUVEZzVqcjdEbG56QzBpWDN1Q3FsTi9SQ2lCa05RV0ls?=
 =?utf-8?B?VXYyUkVuOFZNNWRHZFdZMTZNSUN4NVZpRnZGU0YyaDdyWCsvQmZjbzlwMFl5?=
 =?utf-8?B?L1dRUmNDSndXcXBCSndzQWE1WmFrd21rbVFBNW9ldHlxcXdoRmVrVzNXUUpE?=
 =?utf-8?B?VkNvcnk4eS9PZEZsN3I3NUdSU0xSSVZLbTg4Ry9nMndxODRhYURjU1RVbHRj?=
 =?utf-8?B?c2phcGo4R1NzRFhDN01YQWZVbjdEV2FqcHkzUTdNZTF6KzRrMU5VM2sxS2FN?=
 =?utf-8?B?NlhJUFlrZDg2SWNLRnptVlFjamdwNTlCTGh1cS9xV01iQjhUL0VQa0o4dzdI?=
 =?utf-8?B?ejdYUzBxQmgvUE5kM2NoSjFUQkNLSk1aUE9VendlakRBVExLd1hOSklmNG1I?=
 =?utf-8?B?THVWUmw3VWpqK1VMZWtpWnFZdHdQY0xkeDhMRmh1aDVWVk1HaUI2MS85dmt2?=
 =?utf-8?B?WWNIYmZ2bWR3b0VGb0l6UUNVVUI2b0RGcmRGY21aeDFmTlZMcXU1NkxlYXpZ?=
 =?utf-8?B?QkxhL3YyL0lCN0ZIc3VqQ1VQSzFwOTdKbmhDb3l1VHo1a2RRV2Jhd1RFL3dw?=
 =?utf-8?B?MUpTUDhoSUlLNkY1cWxRWmxhRWpoUE5ySlg2UUc0eUxLaWtPTEZZV3pMb0lR?=
 =?utf-8?B?UWwzaUpNeFdmWmpzbWRhWHlKT2xPSis1NU9HekpKdjFtR0dRREFlOENsTEpU?=
 =?utf-8?B?M1VSNnNyWjVKSGUvV0lxOVU3S2VBeHAraVB3NVRwM1FTcERjYU9iVk1ENGpz?=
 =?utf-8?B?aW1rc1NHcUVHOCtJbDJLc0lqVU5IL1g2Vjk5K0VXZlpZQWFNampSM3Q2NDdy?=
 =?utf-8?B?MmJ5b0doVXRYcVc3eHRPK0hNMFlHMFlEVHdsTWpaTkREQ3Z1aE5wWnA5ekZz?=
 =?utf-8?B?ZVJUdkFEUXdTQ24xMDdCZ2E1L0JDNGFxWUpETWQ5TnZIQlBHRG10YjJpd2Ra?=
 =?utf-8?B?ODFVbEk3YW02RWtMYzEwTWtGYWJpWDNQSERBTVF2elZtajJ6dm1jeVd1V0dt?=
 =?utf-8?B?bHJQeThFU2xvZUFFaVBWdFMzRURtYWY5aXJiMnBXOGlHUkJZODlzY0NKQTRk?=
 =?utf-8?B?MWdyNml2MFFBdlNwbXp1T09SbVkrUWozWEprUndVZHhEeElweFA0KzY5VVRo?=
 =?utf-8?B?QWRYTmtlVzBuYU0vNnFNKzRLcWJaSXhUTnF6VU44bHZzUEpSTm1nakdWUkp5?=
 =?utf-8?B?QzNXbWY4a0Fma1NFY0hvM2FaNmU2R2JNSFgwdHluT0IrZUNQdWFaaXhZQ1pO?=
 =?utf-8?B?TGNpRU5OV1Yva1k2eHV1QWJrdGtkWGl2ZTF0QXhmdnpmbmdrZjgzRmwwWVdh?=
 =?utf-8?B?ZlJuVjFqQ2FtZE8wbW90U082ZUlZV1kxM2RIQUhPanBjR2pERHNneFI4M0M2?=
 =?utf-8?B?dkNBVG9GenE5ZktSQ284SnBsZE0yTXAzdGlGSUhJSFJQZHVCckpVRE1QZnRm?=
 =?utf-8?B?RUUxelVxY2x1SXBGWGNHVS9rdHBlY0lzT3NXZ2FsWm1EZ1ZtSFBVRmcwcHFp?=
 =?utf-8?B?VmdiRmk1U0dPd053RTBXdEZsWnF5WnluRE9JUkwvK20yWTN1dEJDOUswVTdV?=
 =?utf-8?Q?7ak35x8baNfrJKOeNTyUcaPW3inZ77Ruqikchgp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f4af13-7ad8-4951-3667-08d8f83ead2f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:25:35.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohkNyEFDpa2cb9TukEnUKGAD/9N2311YO3htH8d9lnJlx/IqCybK/d9x1khXPwldmG/mMePN5R2VoNzETm6Zzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command finalize the guest receiving process and make the SEV guest
ready for the execution.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index c6ed5b26d841..0466c0febff9 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -396,6 +396,14 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+15. KVM_SEV_RECEIVE_FINISH
+------------------------
+
+After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
+issued by the hypervisor to make the guest ready for execution.
+
+Returns: 0 on success, -negative on error
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2c95657cc9bf..c9795a22e502 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1524,6 +1524,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_receive_finish *data;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, data, &argp->error);
+
+	kfree(data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1592,6 +1612,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_UPDATE_DATA:
 		r = sev_receive_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_FINISH:
+		r = sev_receive_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.17.1

