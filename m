Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43707360F7E
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhDOPy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:54:58 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:58256
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233369AbhDOPy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:54:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3dtEnpxtFDyR8H65pFSH6g+3faofYuljlOT/VREeKuTZHy0kPM+H2KvuiUvp/QXVNnIIVQY4hh+RSGU8k2yUMMTvLtmrrSJV5mw7s5GKyRNMAnSDi4F6mQFCIwBmdBV8hvpixvsKQvF1wunhXIYUa2mLgsL8RIm2ecxOpZGyMj1XpZ/wh/k+lFbeUlv6Lbv9zweSfUgG2h92JM2oWN3lKFot7BHtfO1lKIj5wOVV429ItV2KKUni63N2r2VJSI4hKhWcMik3qDeo/LHektTMN7EVA/K2Ks0ekDD3iJhDiWGHZK7WyypLm6hJIMwt3iLhjFLiHaH8kgurf75RO+9mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoXsYPtt9BXmkmjz+xmowRRzJrV5xMeUKi1J8IY9VRA=;
 b=dgWbClRt0z8MVQuzLDc5ROb3KxRz43ukVqbG+GoMmTMXM+pJbNuaCft/FrIR0NqULaCf2JLQD0J3Ho2NpATg+98yYeibvX67FwVdfWDsMg9wgFfAplENoRwmT/sNoD3ycW9f9lwJWKJ6g6lqv10/y2wTBbXS7LVcK/9eEH5+9h/r0ZFNaoI1asRvJE1Gcaz01SP/eLwIEEjyJO/e8RbdDX5FrmNne/hVDeLwGTF14gulUeH7TzMXlqbiH0Swkdqky33RBX/Au/rXrfLXd61qNm68sCSKltZD1RqxRUC63jcfSkEuYAMgmCFkjHiSF2bpmZHly5A/42r1reiNO0EslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoXsYPtt9BXmkmjz+xmowRRzJrV5xMeUKi1J8IY9VRA=;
 b=Z9f/fSIu0iSFB+tR52r1p0hHZNvIOHKNfdSqe8wYTyKXln8Y/vjqT5DYcmyhofQKafKy/uX6MYxcuPbJ3OGdvoEBKPTYj5MZFAJciPKuI7OItRGGtRbe4QuosWNZf+BjT8avTqaBn3iQQPwhAw4U1gaKyFwhH/1/hhND/294EXM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:54:32 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:54:32 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 03/12] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Thu, 15 Apr 2021 15:54:15 +0000
Message-Id: <5082bd6a8539d24bc55a1dd63a1b341245bb168f.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0223.namprd04.prod.outlook.com
 (2603:10b6:806:127::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0223.namprd04.prod.outlook.com (2603:10b6:806:127::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 15:54:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0448f58-7341-4970-a3af-08d90026c2cc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384C4BC56707D9C881D8F808E4D9@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/oTqNgi3h5Xbomc4m90faWkBPrvyHM8zATlvHMT5rQDf9W30v5qSW8zcBn62Ns3KLA8yLaELW5uHqT0WWV9vFId9ZPcJOKrluEAy6DiTH7GXfp5ebz7s/ZcRP3GaNhx3kfuCqZWQnT8DLbdvm7SSGDY3uqSNK7h1IADfSN9a+R7SJKhGxj8eCHk9+l5PXZYgL/OpesSkkHYz/f1PsmaGiM2t1+pTTfiOX7sFPoB+XghMepayWBTaOeB63xuTDYn/eRqEOtHhq7OxRJELSg1sZxpVgVjPc5UZ9toum7LMDMMJJG00h5r7j8hR1zrpZgzxxyMMgZStcUoHFQK2zsnkIShkzk4OqRmJTFGV/Z7oKqJLWVQqbkAYNYcCUuSn00rsPp/6ApTbmZkEA32VL48/cmMD8EQdBc9Vjdi817RJPL/pg74dRkXhoaQqlnuaRgIx4dOGKjfgvvVk5Z662hMAcLHVvCyVFKBREW8qnNGbmfhzwxhfZvzP7jLXVRhH566+F1LhNXoy7bwfsvEyoClofiejMicJVXxPjt1IBMN8KXtEUwwI3B2wZEN2wCedc+ShWeUbSNVzEa3iCM/vvTf0eZttWqGTbggJpvc1mERcTD+s/4TmBr6g9xACEs26u/lZIbPPlyjzTe0Xg/ZDk9AUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(2906002)(4326008)(83380400001)(6666004)(316002)(38350700002)(2616005)(38100700002)(36756003)(8676002)(956004)(8936002)(26005)(16526019)(7696005)(66946007)(186003)(66476007)(66556008)(478600001)(5660300002)(7416002)(52116002)(6486002)(86362001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aWptbGJYQjNJRHcvaStWOVBIVWR5K09mN2RUQVFLSXRZQnBKSTB2Wi8vd0s1?=
 =?utf-8?B?VjFOZ1VsM0t1SHpxU3YyeC9wM1R1V0p4dU9FK3Q5YW5PcktGNEpjNjJqdjVl?=
 =?utf-8?B?M05yL3hVUmdxR05mdTNLQVRhdVdJQ0ExTm1wVDNySU1WY05XVWkyZ05Pazlp?=
 =?utf-8?B?ZFA3UENMVWFtVklnY1J1ME5sdkE2NjBaYjRJdzE1aXNPcWloQjdNZDJ3dHJv?=
 =?utf-8?B?cUdXbjlHNzhMaStzYmJwVmUwNVRIQ3lYZFNqZGZYaEoweUJBdWwyeUZWNThG?=
 =?utf-8?B?L2xGYnp2S1lhQ01vcXpzeVhrdm4vRloxMUJmZ3EvTzM1dVQ2cmJoSU91VDlw?=
 =?utf-8?B?STg2ZXBTd1g5eXRhY1hjNkg2TnVtUi9vVVpvVnNzM1lmUDRmOEpJbHllUVF0?=
 =?utf-8?B?Nmw2SmdLaGZxS2l6bWZNSmhFSmdjMzNyUFlFY3pVNzdUbWJzV3U0Y0FYWWlE?=
 =?utf-8?B?b2pnN0s1cVAyb1lLTytRSzU1Z1Y1eUxUdUtsTVplWmRNMlNDQkhWRWFFejQ1?=
 =?utf-8?B?enlhRy9Dc2R1RjdzamlKYWxYQUVEYlNtNkFucVFNVHlTUDBTMVJkc21BeWM0?=
 =?utf-8?B?RGNDRXdhQlVRUEdldzhlZnpFWkc3WGtCK0l2RXQ5UHlOQjRZb0dBSTJ6dkhx?=
 =?utf-8?B?WlBXNlZOK29HdU5HcXNDcUdqSlNkbmQzd0RueURMeTZZcTJlaTQ4Wm1ST1BY?=
 =?utf-8?B?RGZua013RGkrenJKbkFUbHRjOUt1alg2cDlvZnBMRkp6UjJ0VFYzejFpV1F0?=
 =?utf-8?B?bFZ2OVhUelFVSmxWZ3lCTlcyNndNU1p6ekt3Q0xveFNRNUF5dG1oVGZ2UXFP?=
 =?utf-8?B?VXdzU2tkL1N3RlFSYVpJV0ROczMxQmVWSVkwNkNPOXZRam1PTm0rRjN0SHVa?=
 =?utf-8?B?UGFFTFgxWjFpUlZoOHNIMm1jeE4xUFB2MXJzdHBsdWU0T2xGbytWaEhUOHJ0?=
 =?utf-8?B?NFVzUDhyZ2x2TmdrYXp0THRTT0lDV2paYXB4WDhBUUpVejR0NVg0Y21WS3VN?=
 =?utf-8?B?N2k4TkljM3ljbXQ3WG4zUWZoYlFDN0RtU1FLQk1ucG9wS3JsLzJPVUZWOTJN?=
 =?utf-8?B?RnZtY0xHUVB1QkZ0RTZoYjZkaVRjZThSV2xXQWtoTGZYTENRenc0alVQQUlV?=
 =?utf-8?B?OGNGWmxyU3hoQnNKM2lQanU2Q0gyZ3FWNUxTa29LWkZPdC9HTGJSN0dwVUpI?=
 =?utf-8?B?cm5HMFoxUTgyeUFJd1JTUEhYK3FsSjhXT25yTFk5SnpYNkpqRG9ENVNwYzZK?=
 =?utf-8?B?WlN0UGZsZ0s0MjVkdUpsanFkYVJLdEtTRGNMNlpCUkRvaWlhNzJ2Vzc0UDJG?=
 =?utf-8?B?MFVLUUM5UUMveHlPQ0Z3bVBzaWVrQmtsMTl0OThoaElYMllrVW9PVU9JODls?=
 =?utf-8?B?MlZzQVByZWdEdzlWOGx1TTk4Z1dXWXFrLzRmSmVtZHBFWFdZYnAwNHNvd1Nn?=
 =?utf-8?B?NUh6a3dPdGQrc1lQN2xjdEY3RXA0aG5qY1psc3B4aFB4aTFmbkdSNnFlcE9R?=
 =?utf-8?B?QmxwTEtFL08xZHdtYWppRWNLYktuNzBZTEZ1dWMwWU84K2x3c1NoaVAvbnlG?=
 =?utf-8?B?NGRFdWllRm5zSjFWWkQ1REc4NFN2WGNKdmZyMDJ6MWdMaUd6bkw5YjVLQ1FZ?=
 =?utf-8?B?YWw2VEtFVjFZb21xZytVMVpMaDBLMTdkUlJBd25rTkI0TTA5Qm1GT1lBNWxw?=
 =?utf-8?B?ZjVubjNLaGVLbG0wY0ZjZlgvbXNPbDJLOFh5Rit4UFpYSU1mVFRscDJuSmJO?=
 =?utf-8?Q?dj6n7DABN93KZD7Mx85uf8oFdDkosVMHFkuDwMH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0448f58-7341-4970-a3af-08d90026c2cc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:54:32.8213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fN5VjtUkQyeVrOy57GfleTWx1G4mtiqmA5/l/lFY+/I8MscXz7UEsJIiG7ZuhoW9XbMqecGMK0aARHhsfpRv4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used to finailize the encryption context created with
KVM_SEV_SEND_START command.

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
index 3c5456e0268a..26c4e6c83f62 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -335,6 +335,14 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+12. KVM_SEV_SEND_FINISH
+------------------------
+
+After completion of the migration flow, the KVM_SEV_SEND_FINISH command can be
+issued by the hypervisor to delete the encryption context.
+
+Returns: 0 on success, -negative on error
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 30527285a39a..92325d9527ce 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1350,6 +1350,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_finish *data;
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
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, data, &argp->error);
+
+	kfree(data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1409,6 +1429,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_UPDATE_DATA:
 		r = sev_send_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_FINISH:
+		r = sev_send_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.17.1

