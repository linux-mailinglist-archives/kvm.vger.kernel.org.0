Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBC230E8AC
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhBDAjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:39:42 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233506AbhBDAjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:39:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7LzAwSCIP7j69pUcaJRvyAggy2hS+lYCTxDiDi0opOjzfaigOW1V/Dbj2PUw2LOL2CGURZYXpQlZZ2QUkaWObHSwdacLE8R1K3nQMnMi33o54Vq+YsJEWUcjH+E5mYC6iWd+Mr1dddvPnbzmJw2LZSSWO6ov1bwEh9l2b2TTrcPNpv5rE5cOy52jaz+HEUyiZg7b4LWg34ObOr2a7JalzMuoubTbqfCk/0Qn3k789vVOppRBPMk5FQTnX6pmavf1mJfvWFnLtNVKinv0fLAfJwkUmm3nVxH1pl9JafrwX5qNOMUEYaW6AkqgIB4R5LwHNiXTwtOB9XDjdefg7ap9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzjtUji2VzxxH+gdEoG8gGdPxEp68Hq0QNfhWXxI9hk=;
 b=BR5gORN137WeBot5lwFkFLHMa0Yg7VfnbGWu85TvvcCsp0ncDUlM/OQn92sv7KmzExhwqXjJ6nBjTbXa8TyzgasD80AuCHjZll7WLv4+3lVHWIoZi6ZmUiRsiCL7t+DfY/t02gNHpTEVuWLezaptJg06evQM94w+ZT6jpmJbG+leHlSoIMK2MmFZIZ9RpIWpXy1KFOxIiyErgdVxNeB2UaHwsOIY9k4sgZ17GRaeHUsZtr9jdrEorKM7WhlM5AgnWHvvQ6DyDOf2bKGYXuOFe5eKbiw+EfBjekx1pF8AzBkz9w5CKe+2NHcFxPZibqN1ze71ro79XlR1+Yt7TAaQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzjtUji2VzxxH+gdEoG8gGdPxEp68Hq0QNfhWXxI9hk=;
 b=1ys05Bawv/HtmymlYWkBrNHXo11pzz65hz1k+jbc525WNl8qeMlRyzGuWmc3+E2UqCqCRxvmF1ChQWUtDRUoy0KeZt4Wvt0BP8j9PVe9e3qZJhuZEhgKXnLyjJ3tBB3XVaLmgBY/Ob7VvAszmwjpSKaF37GFb9NcZaL1w+QBvH8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:38:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:38:09 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 06/16] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Thu,  4 Feb 2021 00:37:59 +0000
Message-Id: <262a84c2a8f673a08df1ef296b1d6d2ee9e1c771.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0104.namprd04.prod.outlook.com
 (2603:10b6:805:f2::45) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR04CA0104.namprd04.prod.outlook.com (2603:10b6:805:f2::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 00:38:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e13c5e8a-a92e-4b21-5855-08d8c8a524e7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43844AD7A38A673F5A6D3CA08EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2gFjuhUt1/oAPN/DyeyRLufQrk19HNbQgBBuT0x4X9W790vFgmkz8RZk4ZwkJxv/fFt0QQoD2uRizyR/W5/Rep3st1qaRJEdHgvpDZ25azvQltIaIxq/mEGQL5Ow8VSxT26aBgr0d7Bnnyk4rQgklNLZL6hVq3egOXr0MLc4+AweTIGLZAPW+cBfiC384H9gBPoy2xS7kru5EBHQBFl05RWv+uEWsLUVtAOac6Heub/B1djbDLgPkCO/ewkyetV/bRNTOI3+tn2zE7F1FOrz2pQ1Ftdhfi+nsM6Mm2H5vdsinGiF9yOe0K0XwKla5BLmPabDQpdCCgrj/OY2CeYXM8bIrjbPU/TLcZfSPE8zhwsyNv4M8LMJl+7DQDgJyJe3RPbavE4IqwF5+Y8WbM3TuCdodir5FiwytndCntLdd9JtRszejffg39rkNS6GhNIY41IlgzYbsNbpU26rwrt3bb2qtN/hvtvXETYLZ3d2eK2w8hktMnQYmfO79p+afmnXT8GPGBChEhknpYek64JEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?anlmZktNNDVvVksvQ3BjSlYwMExmSHVQRnhFSFp5TE5nejVqb0JhQU5USEpN?=
 =?utf-8?B?UGY0d3BObFVqcXJzSlFxWUU2dXV5VDc1b2RDU0NBUmxveTV6TndVM0VIejhV?=
 =?utf-8?B?SFNzdDVoZG9ZNkl0VlNIazdwL3VZUzAxZExiK0dFVm1udzh1WXBpbHF2Q0tW?=
 =?utf-8?B?SnJ0YUlmektkQlB3ZEpLM1pYZXBBbWlNLzgxMnRETUpOK29nWmxpR2ZRV2R6?=
 =?utf-8?B?M3FUL3B5MStqcTBnZ2lla3ZDTTNyTUlVTkt2TTRZQzZNN1dlVFJDaXJWWkdo?=
 =?utf-8?B?VWtHd0gxMDhrZHhON0F4VkdPR0NtaTdldzlZVy9xbExVeEg4UDlZbnRjSDRS?=
 =?utf-8?B?ZlJEdkNac2dHNUpwa2lzK2tpWGpNcnhGY3l2YlkwYzJrQ0NKRWppYWNqRnFT?=
 =?utf-8?B?MU4xNmtkcm9JYmZRZGFadU1iK3NsY3k1aDdKSjN5VUJ5NFNvalI3N0RZWW5X?=
 =?utf-8?B?S1VreWd6N20wUm96RFlVdVpyOUE2NXFyTEhmQnhjbHFNOSttcUN5UUgzdGRO?=
 =?utf-8?B?TUJSSjg3UlJyN2l5S2wxTmJuS01IWHpTeUlQamt3Q0RhT3lGWm9rWU1HUGZC?=
 =?utf-8?B?a3gxNDNoTFFLTUNVZVFqSkRySG15TExuU3J6bzlub3FrcU9zQzB5K3YxWGdw?=
 =?utf-8?B?Mk8xd0VQQUZrT3FCSmxueUswdHdmWFd2a2lBSlpTMFluSzhETllMM3lVRTRJ?=
 =?utf-8?B?MjdWOCtmbXo5em82THc1aE9tMGtVSit2K1hWR2RjZ3k4aDdYREh3VlFIYU0z?=
 =?utf-8?B?QXp1dHRRRUNuMk9qMHNKdXhqZEdCOHluYnpaL3J1di9Tb2dQdFdLYi82Uktk?=
 =?utf-8?B?U3dtZ24xVWpTeTFDZDhPZC9ST2wvNFcwNFd2NUk3dW96TTVZdVpwb2hTZ04x?=
 =?utf-8?B?KzlrQmsycmpLb1pIak9rdnpuVFFnTUpSMjMwUTR1dk1DdUVTNXhvd09iZXVz?=
 =?utf-8?B?Qlh4dFA5U0w3RmhDUHNxVDNVOHQrcDVhSDJnWjFMYUJtV3BOaGw1UU0yS201?=
 =?utf-8?B?ditXRCtOTzdzb0c2RmdxT1F4cnpaa1dZaTA1elpJMzJ0c1lkYmtFUzVVTkNX?=
 =?utf-8?B?OFhjOWF0MVhuWFFrTDJLZGg3cHFMbUZ6dFB6QWlvYWNCUXFmVmRudGxMQTlk?=
 =?utf-8?B?ODBhWWxkdHFRWFhFUkxkamZQTWZlaEJKZ0xRdG9LV3ZJSEtZblpvcjh1eERi?=
 =?utf-8?B?UlQvZ0p0TW9hbHR3YWJmZndrS2ZZSlcyRWkrTzZJWlBsSXVXT0dOZXVEOGtJ?=
 =?utf-8?B?dDFlbVZOdWtLWXZoUFdsVE5qbU0yTXhVOWVkRDRzeC9iMllNYjVoWHlrd0w4?=
 =?utf-8?B?anlsWUp6T0xlSXBTM2t4OVhKMzAvWUhOdzVMeUtES25EQmtvZTdhOUdJMmwr?=
 =?utf-8?B?WExCSWJnUG5wck9PMUhSS0JUa0ZpYjhpOEVGRXJodjRYTFljV000ME9INTAz?=
 =?utf-8?B?dndXL3Rla05RRG5IYVM1eDRrNnFXcEd4UDBWY2FzTnJtK09oOWwvOXBHL3h4?=
 =?utf-8?B?NTJSVmVBSEs1ckFteW9jV2lrWmhkWkJUT3lPRGRHdWpLS2VEZ0dvbjlvcm9p?=
 =?utf-8?B?TmIxa2lCUDBDUEZPYTFYeVhXZTk5SXhaRlRGV01VU0ZYOTJGQjlmdmxXbVhh?=
 =?utf-8?B?SzBQNGNDamFjYUFsMVZKaERnRDlzRStqMVJYeGcwUXg1OGR6K0FTMEN1TUNF?=
 =?utf-8?B?eUI1dytCcDlzeklsbjJXRzVycVhRQ2JsZDZibHBBYk1nNlA1V1lEMXgycnVj?=
 =?utf-8?Q?OJZx48Mp1hVmxFjISNlzjwCf0scZdugL3xywHJ1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13c5e8a-a92e-4b21-5855-08d8c8a524e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:38:08.8934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdCM8u7A793D29Kp211bidKBOENtDXDASAZKEDVoOK7ehoBlw4rK9vGlX2mNUt7N9QWst+/iBIAeiA9VczwKtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
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
index da40be3d8bc2..1f7bbda1f971 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -375,6 +375,14 @@ Returns: 0 on success, -negative on error
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
index 73d5dbb72a65..25eaf35ba51d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1453,6 +1453,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1518,6 +1538,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

