Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD5D35D156
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbhDLTox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:44:53 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:8691
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237613AbhDLTou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:44:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PF8iiHutLApTnyIz6rqvl9F6O8GZONIiCIj0iz6moBndBu5Cil5oaPi0oi/ZTRDrFjmEX4bMyWYLS3iseGgXFXA1ERS6iZEd8P0BbNUb+PP19jb32jev8dyhNGqgpp9xCoof66sHvRfYcUfm9vvGGFe6PHoBKkD4nQTQcYF9ktjVsDQ9/4xzI33KEyoLMDu1ZVTx8+nI+eucit4IqT0afvZeRyTzd1tUu1OrzFUbE6qzLIWBDuAiPvM/Bm7noIgd6H6HJhc7jYqFg/hRSg2HWnzoDwNtcapjw3O1l1a0/cmC8rHsKu1kHb9cCY6ajVBtCgkO41OgeYwewfYzSZbjOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hoe8sGamNdrTHVOTWOtnEUu268YbmQzoeLNrHgJhv9Q=;
 b=Sluvd8XOUSd37ZgyseNQhkKBTVn+F3hHtdMvCUXBIUnLfwXLQdXyd6f6KsGCHE7byJQOyopjAU89Wuz2OlOF0WzJOiXNh5Z/FLevujVcuym0BQeD+1p9hW0d8m/lwv9QBSDJGy4FxNbbLP+bHxVc3ORjX5TnRRjM8dRusCvSf3pGglQFFF1ExN/bYnxFLqvYX3FzrT2JrpXwitJdpA2raYBaT2qc/NdDUTNbsBdqs1W2HFQfF64KbBPL+xjXvVgVwNkE3kjEQoYDqdEs3BwXMisvHjJCuS50Gxh4eFQ3zjeYpyo4jb3j/2p00nHGRj4KigyYDTyr3Q6lksjUvYEYAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hoe8sGamNdrTHVOTWOtnEUu268YbmQzoeLNrHgJhv9Q=;
 b=vA83hBVq0ikaYNTDyMf2k141J5u/PT1E57bb5M2DmSFDnWQgkD7g/cBde5sa3gIU7MukHnAOkiAfzooGtKFq5sRASqjSn1KAk3MckAgrsT7/3JNGeB5YBrRLko90U1RRftVDj5OBcwKRE7hESUDUYKhVmNsstkUaqbd7AzrmsEk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:44:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:44:21 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 04/13] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Mon, 12 Apr 2021 19:44:12 +0000
Message-Id: <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0138.namprd05.prod.outlook.com
 (2603:10b6:803:2c::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0138.namprd05.prod.outlook.com (2603:10b6:803:2c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Mon, 12 Apr 2021 19:44:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12e728c0-aead-4236-4f7c-08d8fdeb5e72
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685EA485549B72B808B145D8E709@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zl7cixbs+qkiZbpIVS7/upY5vu2JOM/wzb6SVxY+UIBn6Fl2oCve35EFldUqZ8DBNfvfck6W+8WyfXx0RR89ITcyNeXTFiWNHmi+9nze0PdoVh+vhtHowP/bq5agp5OJZPJaeIhpw3O3cVuTsAcTKr0I1RxXces9xs5eynMtOhUQoGT7kZXPGZiNKCjXwaB3AWeYA4JtrYnimVsFFdbrWvS7KtGP7v05kNTHM5yPuS2c6fwMtTjdXbvXgOZKMlIx6sQU5UB4p8vKOhpfDjmqtASLrTG4KZnlWcNDINBvsUprAhrq8Bb4NVPoUIXw96lsidyccSOgQTvT22O21qC3CFF0VmOLidcIt/ldmwU00zyz1R7lcf1LGL0HZa3VRIVKejpn3OvhNGY0mCIVd+0qz5Dbltg9Gc3EgVmGOOu7aarItL1ax+vHUiPq1bJYCHML1YukWiGng+uCtbbhyYeBkW4IWtvyGFv2SBaKEwEkUoTxL/z6mSJvbgS9Bpw+dRiQ2oCHiFVOvoqb0zQ6333lIQxPNbwR1IEnBi9LyMWI6nBTcHgI8uWaNzpfPiHW+7pBGMEbNjTlOjEppOiC4hQ3vN7MOcPaqmeTX1Hax6sTLPauaoAYhx7hz3BxJnrPxfCqJ/NIMTg4IIzlUop3T8rb/OZozCYOasdRWwGZ59xxcJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(316002)(6666004)(38350700002)(36756003)(8936002)(38100700002)(478600001)(52116002)(6486002)(16526019)(4326008)(186003)(7696005)(66946007)(66556008)(2906002)(66476007)(956004)(2616005)(5660300002)(83380400001)(86362001)(26005)(6916009)(7416002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K3hjRGljTkNWbDZJVlAvb0FtakFDazhiakpwMGgvbnFRbG5vNk1tbWFKSHVw?=
 =?utf-8?B?TUVhcmtzNnJnWUpZL2p4bHhuRnh1Rkk0RWd3SGhFMGpnVUxlV1dtZGdTVHQ3?=
 =?utf-8?B?Z0huWGVrdURIWG5DZFk0bGhOUDNISmxFMnZRRnZJcGdlczk2eHpUV0h6ZElu?=
 =?utf-8?B?VTZQN2xlTjV1TmFIREFoZkRkRW5tVlQ1VVFzS0JEM3dOR0g2b1VaQnAyckJx?=
 =?utf-8?B?bEZaOHpNMW9QamZiVm9tQ2NNcGVVZ214ME9BU2V0S2k3SU5PL3R4UTJ6Y2hu?=
 =?utf-8?B?dS9vUFkvRElQMTlrQnJzTTJEZ2ppZzR5amhncUY0aERBV24rN1dMZzY1V3Bz?=
 =?utf-8?B?VXpwREhNMnEyOXYyMEE4M0xzWFl2bVNscEhUNE1nMjBKRDJ6S1FhTGw0RUpB?=
 =?utf-8?B?T1VJRHZYR3lCWm9XaDRQVWRWd2Z0cVIrOHpBUjFhK0V0UFVYUUI2OVZDcDhR?=
 =?utf-8?B?Qlk1RlZKdWNqK1MwaVZYeVo4ZkJsKytnQXBaTGRRUTQ1YnVVZUV5c1BUK3dC?=
 =?utf-8?B?MU43L2NkV2M0Y0x0QTAxN2s3ZEFiUHJ4a1VFSFFsdDNMaHk1STc5aW5RY0dt?=
 =?utf-8?B?NHJleUpnblRNL1pVTDd1MWVpWVVqVDhyN2l3VGFHZC84V01nS2Z0RStaWHlF?=
 =?utf-8?B?QjRHcUZpeHE4VUoza3Q2dGwvWFRsQk9IQUdNOHlvSjBJOGdwODYzcjBnZ2F0?=
 =?utf-8?B?OVlCVHp3OUpaaWk1bVQwV1ducDNsMVFETkRRbFdHWmFHcW1lRDB4Qll5VW04?=
 =?utf-8?B?cm55YTN4YmVJZ1lRMmlMZnpZMFVzeHM5cU45L1lrR2luZDFGNUg2UTJOZ0lX?=
 =?utf-8?B?ekFwZnFpdGFkZi9zSDdsUGh1dU0yWWZUMzFqK3loOTNxb0F1eC9pMHI0NFR4?=
 =?utf-8?B?ZWRUT3BOcS9MNjg2VVowbHhwb2F0OU0yeTh4Tm9WRHpxbERMVVZuTFdUaW0r?=
 =?utf-8?B?UTRHR1ZqbzllQk5odWwvWFVHZk52Zno4cm9aQW9XSnBrUGFaN0huL3NXZW4v?=
 =?utf-8?B?cExVaXozQWw0NEJzaVBvczJJVmFyNm1IaWxMQ0tWL1NQZVprMzRMVG05cWRL?=
 =?utf-8?B?UTc1dVdGZGZVRTN1RjBTV0I4WmF6OUp6Y2RVUHNVVkYxNVUxRStxb0hIRnBk?=
 =?utf-8?B?dWN5cnhHUjJqZXRUQy96MVdNZHdBSVFwNjN0Q21OK1oxM080cHB0V1poaVNF?=
 =?utf-8?B?bUhBREVZeWd2L1pPNlMzTWJWeS9GeTM4WlgramZkWTVDV0thMnVCNlR0UWRi?=
 =?utf-8?B?bUJCa1NWV3hKTEFwbVF0TitPaVVQVHkvWnFtRERHQlo5VWhMSnVaM2NZSi9D?=
 =?utf-8?B?NHdIenlPaCtNeTZmWUkzVXNoSUFwd1lKV1dtQTdhaktyYnQ1ZUJiVkkwMG9m?=
 =?utf-8?B?Uk5BVk8vZ1JiSnAyaG55Skt4aVBsNHZRUjd0RjgrUHRObEs3Y3pYaDZJMmdS?=
 =?utf-8?B?ZVdKOXIvWnBsMGxUZnNEY3FhTkFjOFNCdmZINXNVMGo1MkZ3bXZWVXlJMUdz?=
 =?utf-8?B?STNuMCtFSHVJdXRSNnR6QVc5SGwvNnVVUk9PZG03eGlzU3B4ak10S1RMSTlV?=
 =?utf-8?B?UXJMQS9zWjVlRTFlN0FySnlOSjZGdE9nRzU0U3BNOUdydzVYNnpIRSs0amRm?=
 =?utf-8?B?Q3FtL1RHa1ZCbHl6RThHNndicHZvWm8yT0Nncnd2MFd2d2RrVUUwSURIUFZm?=
 =?utf-8?B?aUFYd2ZoY2o2T2dLTW9EOXNVMklweXZESk1zR1BBYWF1Ync1TlBSYmtqNFlw?=
 =?utf-8?Q?YT+0NusK3DLUOCfF4DJDztSkRBrZzWFJCWTXiOe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e728c0-aead-4236-4f7c-08d8fdeb5e72
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:44:21.7976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6KLzer+DZbplsMh8uK4ovsBTIGyAp4rx3wGtFHjofG3MrJfb6S5rEPdwm97gAvI/4BdFNDa+1SmYRcZJixvZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used to create the encryption context for an incoming
SEV guest. The encryption context can be later used by the hypervisor
to import the incoming data into the SEV guest memory space.

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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
 arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 26c4e6c83f62..c86c1ded8dd8 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -343,6 +343,35 @@ issued by the hypervisor to delete the encryption context.
 
 Returns: 0 on success, -negative on error
 
+13. KVM_SEV_RECEIVE_START
+------------------------
+
+The KVM_SEV_RECEIVE_START command is used for creating the memory encryption
+context for an incoming SEV guest. To create the encryption context, the user must
+provide a guest policy, the platform public Diffie-Hellman (PDH) key and session
+information.
+
+Parameters: struct  kvm_sev_receive_start (in/out)
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_receive_start {
+                __u32 handle;           /* if zero then firmware creates a new handle */
+                __u32 policy;           /* guest's policy */
+
+                __u64 pdh_uaddr;        /* userspace address pointing to the PDH key */
+                __u32 pdh_len;
+
+                __u64 session_uaddr;    /* userspace address which points to the guest session information */
+                __u32 session_len;
+        };
+
+On success, the 'handle' field contains a new handle and on error, a negative value.
+
+For more details, see SEV spec Section 6.12.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 92325d9527ce..e530c2b34b5e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1370,6 +1370,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_receive_start *start;
+	struct kvm_sev_receive_start params;
+	int *error = &argp->error;
+	void *session_data;
+	void *pdh_data;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	/* Get parameter from the userspace */
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_receive_start)))
+		return -EFAULT;
+
+	/* some sanity checks */
+	if (!params.pdh_uaddr || !params.pdh_len ||
+	    !params.session_uaddr || !params.session_len)
+		return -EINVAL;
+
+	pdh_data = psp_copy_user_blob(params.pdh_uaddr, params.pdh_len);
+	if (IS_ERR(pdh_data))
+		return PTR_ERR(pdh_data);
+
+	session_data = psp_copy_user_blob(params.session_uaddr,
+			params.session_len);
+	if (IS_ERR(session_data)) {
+		ret = PTR_ERR(session_data);
+		goto e_free_pdh;
+	}
+
+	ret = -ENOMEM;
+	start = kzalloc(sizeof(*start), GFP_KERNEL);
+	if (!start)
+		goto e_free_session;
+
+	start->handle = params.handle;
+	start->policy = params.policy;
+	start->pdh_cert_address = __psp_pa(pdh_data);
+	start->pdh_cert_len = params.pdh_len;
+	start->session_address = __psp_pa(session_data);
+	start->session_len = params.session_len;
+
+	/* create memory encryption context */
+	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
+				error);
+	if (ret)
+		goto e_free;
+
+	/* Bind ASID to this guest */
+	ret = sev_bind_asid(kvm, start->handle, error);
+	if (ret)
+		goto e_free;
+
+	params.handle = start->handle;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data,
+			 &params, sizeof(struct kvm_sev_receive_start))) {
+		ret = -EFAULT;
+		sev_unbind_asid(kvm, start->handle);
+		goto e_free;
+	}
+
+	sev->handle = start->handle;
+	sev->fd = argp->sev_fd;
+
+e_free:
+	kfree(start);
+e_free_session:
+	kfree(session_data);
+e_free_pdh:
+	kfree(pdh_data);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1432,6 +1510,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_FINISH:
 		r = sev_send_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_START:
+		r = sev_receive_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d45af34c31be..29c25e641a0c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1750,6 +1750,15 @@ struct kvm_sev_send_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

