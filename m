Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23FC3542BE
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhDEOYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:24:44 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:48993
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235959AbhDEOYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:24:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmCitbkNAGKsuYD21LbBUmBCaXLoA5DUjFE2Yz5p00eia9j9KQeInz9q3VvU89eE4E8j0srcVCu2sU3QGfCL8juRI5lMNGtXVZpiDxdas6cAypVIr5R4Fhzeu/O8OAHB9jXjZX3g3eyfkSamv66Gg8DISKNu2GyeKDDgEIxh7TGX+KME8of55ZnOulyqilH7KPT9PoOQGmKYyFFDWd5zS97Bnyv42CMbH0zmJASPke6Dj/qQZsOUTD+0yQv5jriVuAf/Qz2DDEC9HX1uODP3y7LmXbXUi1HXH0q/pf1EiqaFkYCUnNFAy+0/O6DxW+8ZK/f92JKEsNAaK/kxaR4Y5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hoe8sGamNdrTHVOTWOtnEUu268YbmQzoeLNrHgJhv9Q=;
 b=L62Mob4Q45SKqaU6Ixm7iSagKcPrTOPEJPCBxjL2KYM8jY9UCxlvILn+GY4Nqu3EZx9H/7CA1u4malW4TRIrle30P3Kg6OcpU8+yDS72xrCXwao4yoiLyhMb5TY0DsVVVTfUlEnW28PVcF2459OiU7NdYMGJHjhp6rF9rP0ngGDYhiMPIhHS0LVu88pVI6XQt5BVoufphpWXi7b/sa8I7BxmeQXcEDUno9i6eS+SvhhztkFpZu7tSnxNuuTo15U0NC4nNIO9hMg/uKqxBzz99lF9ABwzy1O7xEzv8ptXTd5uCLg+A4eWQ7nBQ7wJulyxaCpqvofXa/X7mCQXgpTaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hoe8sGamNdrTHVOTWOtnEUu268YbmQzoeLNrHgJhv9Q=;
 b=ZIkQ9/BTXrysUbAbShZZ4rZBuG7z0DEK/7lbmSnh6aZHEwyXzQMqCNIfe7DDla479YWCe/ISHIXfhv7gVO/VQ8XB3CBNY6lS5B/HCFlm1YobBpJqZi6+Bdea0UozOfOD//jKBACN31B5XS9ZrHdIeZspgdzz+4taFb8NlhV5wtw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:24:33 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:24:33 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 04/13] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
Date:   Mon,  5 Apr 2021 14:24:23 +0000
Message-Id: <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0031.namprd05.prod.outlook.com
 (2603:10b6:803:40::44) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0031.namprd05.prod.outlook.com (2603:10b6:803:40::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Mon, 5 Apr 2021 14:24:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f58ff675-4bda-4623-3c4d-08d8f83e8835
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2767BCF40790993DE7A0EC638E779@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHZ3n+M2rXLiya++hAZrh1p5Dxb/h2SVbu1HFESX90fzg+5qAlc7usPL+cZlClodiAauo7j3kwcQyIiszWzEW93Xc2Us0AYAwZTYr7+N5Fq7OhSUlLfuy12dLLm1n2EVZpDkRoEBA7WIfA2o8CAP9RlgXfjTbMStG1aRUsgx0UWhWa1TG55SluEvYIOrlbxecV2BAARCuvRlJ3YFoH3U7XV8/hpISJB2qpiG3gXkunIDhxVSmnJFiXUt2l4UMRIkAMZEsLPwEc2vW4iILLmTtrtRqMasTg68kpnIIkJUPWT6FKnOoLmSt/+uY4r40PekgCa6WMMkeJD4Gw6BfthNomkJDc5p9vTQEzHyHmGoG5xSpJXtj2vX0DpeysW41VZcOlSu1XsgEG+fY7v+11yMjdm+I3BipaN6Zhe4iE8K8S47QbCgSAP28zfh4JHM4V9Y0r+MQHgDyWOzZcfYTvvv0sU6SuIhVCxRCzy6YR/CtnAVz5zDcjDZrFLEoFYvdDNJLBL4fVVFQjmHdIGZQT4aocNJMtg4LP4DBgJv+cInXd+hk5vBfNNDMm6TIQnr5IrUOEAuYEX03wWZbrfNcA138kpxmOViP4Sxc/1qp3wQqAD2hND21BTQFItaGvxUdlmdX93vTdcDz61lZFKt3cOLOEW4BczV7B19XjkhOOmEwvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(8936002)(66476007)(478600001)(36756003)(83380400001)(7696005)(66946007)(52116002)(5660300002)(186003)(2616005)(16526019)(26005)(86362001)(2906002)(38100700001)(6666004)(6916009)(7416002)(316002)(4326008)(956004)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ajVUWVREaVhXT09KbXJiN2dMTWZoMHc2OGpMc2dQdVgwMzNmNzlFd2xnWDd4?=
 =?utf-8?B?L2ZxN3R1TUN2Ukc0UEtOK000VzlxTU04ZTVEVVkvUUhBSXJIbExwdFhIOFNW?=
 =?utf-8?B?MUNDQncxRlB0Q2MvTEw1Rm1QaTcvL25DMWwxWjBZOWx5NzRJMFc0QnZXVVVz?=
 =?utf-8?B?akpjRitSRXNkdEFnTVF6a09wZWtIc2puY3NPWDJXN3RhYU9Wb0ZTVWo1KzQr?=
 =?utf-8?B?K2RIb1MxZ3c4dFl6LzFzMkdOaERFQ2ZOZXQ4R0VKTnI5UkVRY2pLUnIrWEJq?=
 =?utf-8?B?VVdvZ0pRZEJiNFdrSXk4VU5MVWkrSm11LzJGbkQ1MnQ2MGVZV1MyZDJGTWZB?=
 =?utf-8?B?Q2s0eENqZnZ4RXRBNjd6TWVOcldxdDcvRzdlMkhTN1NlZDB5MStDRVNHZGs1?=
 =?utf-8?B?QjBtZERBdUZJbnNNcUh3RkhlUmM2TnNIam5oRFQ0OUV6TTFkMzhMY09SdkdQ?=
 =?utf-8?B?QmxFMjkyN2VjTnMzRkxnNHI3SEp4Q1pnNDY1NXJmNTVPbjBVeDRJY0h1YVh4?=
 =?utf-8?B?WGtrN0lUd2JialFiVTlqZUlGK0JXK056Y2s4ZzVlZ1pLNlVzQXJoL2RwblYv?=
 =?utf-8?B?UlNDS2dhV2M2aEsxa0F4RTFwYWgwdzdHazBhSzdqa3l1RlFWbjJjYjRaQ2ow?=
 =?utf-8?B?dTg4ZTAyOTJyeHZrVnNJSUg1M2EwUy8zblZ0Z01UWGVIWHByeVAzZ0FiVkE4?=
 =?utf-8?B?WUo3blJmQnNHVTZuWVZHeEpQdVZlRDM1YXY3enFUUTd2ai8wZ0dNYnZQaWZI?=
 =?utf-8?B?SExpNHoxMnJPeE0zRlRZWis5Slh4bmNkT09kVXBqa2oyL0RmTGs1SFpvT05q?=
 =?utf-8?B?K0svNTZ1WnAzTHdubE1nbDNPT21qeGc2QkhaTVNVSUR2M1oraTNwbkNBY3Uz?=
 =?utf-8?B?VTlLZW9xZCtwNjAwbnBRek5NcXpDZE9GWnRJUkQrdzBZa01KRXVKNzRKaURi?=
 =?utf-8?B?aTdBSVY3V2tQQmwyNmFnRVo3dmhQRVJtMXdVdEJiT3JyZDBZMmdydzBtdVBM?=
 =?utf-8?B?VFpBWjdNVnR5MXdCN1BtdlFrYVhxNWNvRzlXVWRJOFN0Tm1PdlZpTmx1VmFm?=
 =?utf-8?B?dTNOR2ZwSWo4Z0RVakJhdUVldllEcUFDdU9qU0F6VUVjWjJ2VjVYUktTR3Fl?=
 =?utf-8?B?WVUwbXNvZGh6THVuYlVSZThRQlRwR3V6UWk1WUorWmdKMmRWaDNNaWNGL1dU?=
 =?utf-8?B?Zk84YXRCc0tpeDRDMGhFUkptNWRnTmRzTEROMFRWcklIVHhYMjJpUlY1SVpw?=
 =?utf-8?B?Ny9HN2F3VDdPejAzcG1POER3SkVmWW8zL1g1WmRKVEVFQmpmTWJOWVpBeno4?=
 =?utf-8?B?SWZGUSt5UHhTQ0E2QWZIYUdjK0svL3NxOFhuWlZ3NFFJeSs1dHhtOEhQT2J5?=
 =?utf-8?B?Q0p0ejF3RnBsaXRpMmVYMWRsZHRlQXlKLzdOVm92ZG1vMjROWE8rbkdTK3N0?=
 =?utf-8?B?YXRiQmdLUitNMU1BNWpBRDVNVmJHdkJmSVhNdnBpT2pwemI2bDNKbFdlSEFQ?=
 =?utf-8?B?L1ZPNzRLaDlIL041WHVjNENzTXNZY2tuRHhTTTQxL2RJSzkweS9TUEs5ZmhO?=
 =?utf-8?B?WXpkWjBtZXpobjV0ZWFuRDRSbmhKaGtjN1FCWThEb1EvdXl3QzlDR0MzTUUz?=
 =?utf-8?B?Vm51TUdzU0UrdGphY2lKdzMxMEl4cTQrL3pOeVUzUW5URFRRREpFZEc2bVdI?=
 =?utf-8?B?ajlKYy9OREZMMTY2U2l4dGtiSjBycFRXdExtWnplbG1KekFISVF0WVNieTZ3?=
 =?utf-8?Q?P7detMA9FGt9jPPApADhd3ADVW9zpNmk9NZv93i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58ff675-4bda-4623-3c4d-08d8f83e8835
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:24:33.1595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRJsEb4W+qaI9wy41f/yONJaFhDw71/pKUcLieY8lZ14t0x/zEy/26msU0w/M4u9pUXjKSA2zEd6vfX5Ln9Lvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
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

