Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE29360F77
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhDOPyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:54:09 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:15745
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231726AbhDOPyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDgXXkpGdpduBZ/B0cbxxiaQ6XMsfROOoDuZCKu6QS1fiLLKxUjR9j0OsH9lgC1hCwgdo4Tk1NQ9U6gE9rX97HFIPitUwg82+dg17A3ONM1FUl4FJbiMkpph9S5a0Aq4/Ohj5u3WJWaRc8/6yKHGuJM3Jk82t5loA+6JDxp/fBKaSOx6PDJ1j03umJJqDHuYUFR4o2iRs8H12mCGpzegSX8n8nYL8+FnmjtKfq8rKgiUXjIn7C7+I+0yyNLeQtF383COaSb5UDlKrqv63VtVJWz4u0o1cE7PuPCBje7tiC4gbRkNo0Pj0AdpCd9cHAaapKCdniQ8g8HQDWHNIQT+pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9+vMxeGG/Np/pHxZBLItVNVJH2aLDUxgz42hCBtD2c=;
 b=oMSdzV4gDKpRhfmL9eXmwWWXAENhokaaDP5pZ/7coCq70MQYoDCWHAoexlZxDseHSLO5IFvUxtUPj1ebrNnr1U9XIwlVzE8T3MimUH0uwnZBNo0F8RS4S3MqxI4eHKIX0THuziW5qxxJX8FpMkd/R/QHD0W1FeU/n2XAZMuhHLMIo5Q8GVzhoJg5V6Ny3MiRq9phzg7dIclkbTMn1GhpHrjSHEVHmQvu6b03zRBZus4+ZuKn36MFB2ms0B5UTNtOVQpLKkNTKSwCTdzTQ/ppiLNVkIGG4ZBXFVOBI+2C5jI0D1uAx+KTooFdm9UqDhiYdOq3bqlXAsI6e44uXny+TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9+vMxeGG/Np/pHxZBLItVNVJH2aLDUxgz42hCBtD2c=;
 b=wLJv50LUh4B4c8/U5pHHudjCzGZ8tITqZFxf4alLIA4w4e47lLsIV35qOy9/J+4Efna3ukGZZ/yitRm/ps3Qkv/l1E5AydFp7KuXOricwD82/cGiPXYDmpCbQd2jPNSakHYetcAzHFu221/Zoi+oxQgFlmkex+p+9Sjxj9X/ZdI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:53:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:53:43 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 01/12] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Thu, 15 Apr 2021 15:53:14 +0000
Message-Id: <2f1686d0164e0f1b3d6a41d620408393e0a48376.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0161.namprd04.prod.outlook.com
 (2603:10b6:806:125::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0161.namprd04.prod.outlook.com (2603:10b6:806:125::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend Transport; Thu, 15 Apr 2021 15:53:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c671cd1-4deb-4c5b-20f7-08d90026a541
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384783AA409FAAEE2ED938F8E4D9@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSTTGRjOmF9r4zGJj7IjvfNi0uhN/dBdA80EO3+UNxTtDCf7NbfhajhGogbYlrlnrgfjndrdsuucCI/menihmID9u3xULIcpHQdDZwunnL8KFc+rlMsRQVedT9LXzbpWasRomP4Ac2of7PtxklvpSeDXjRfzUuALzwIrb9ISFs4QK7xusmL545Dq4kP2hojG5sTo4uyRRtc260i3Fz43WJNkbrFwKzcC/cI5KGCTIE6nxyuxr08cwOv7+g267z4PfmiUiaMM2JNB5tvvFvkxneyc9FoYUq0Saautd0ceMewQ3dCJgLb4tJCwFE0NfneAUrEKPBLQMAhAIftXWujxrqL5gzf/I1Z3PdGmt5J2QbxuMxnya3GOQhfrKZoMsYTI0cWSOrs0wSeNs2LhdWHOqAkRBKCnKtMk/0Eta0lwqY8LZnKNDr3FQsvNYGEqIFgVWHHiJoaP3cb9KT8UTAdLNKzOIlHKISd6YUGOS8fLEPysvHQfo1ouK6XRQGs7zRnYC/dS09V40xfyuifn2lIFynGEyuKIKHxPn5QDZdW1/KwCjLZzSsWQaRqtxEWjs/hJorR7H103YwCI3ySJLOZEAp2XIU1QNxFTm9qQgREIe+W/s7g1l0ED85c6EJb3vgxgGUMFQqDdN8T+JUmkgmBXMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(2906002)(4326008)(83380400001)(6666004)(316002)(38350700002)(2616005)(38100700002)(36756003)(8676002)(956004)(8936002)(26005)(16526019)(7696005)(66946007)(186003)(66476007)(66556008)(478600001)(5660300002)(7416002)(52116002)(6486002)(86362001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LytOTXNLV05yNmUwZ2h3dU1vWDJSM2VZOHc1UStwSFBWYnB0dlFrVHBPclRi?=
 =?utf-8?B?OEdNLzVFU0NITmZRdVduNGVPTkowN09DWXNLOTZzeHpHRUdkOHp5amFZS00r?=
 =?utf-8?B?empsQTBLTXlYdDZ6SzZEbHpSblFyWFdKZk1FYjdTbytXOGVENzBOMldWNm9k?=
 =?utf-8?B?V0FNcEFScUVZcUlxd0NzdU9tRzIzblA0VWdCclJKNkRmQXZHZUJmcGluM0Ur?=
 =?utf-8?B?enZSbHNtcWRCdDJnaFgzWVo4RXZacmw1MWxxYTVxOWlxYkNubWZPTG8wQytF?=
 =?utf-8?B?aGMyenV1d21JU0tOR3MrQVRWRkZJeld5MmgzaHNDdHdSNE1FN0REcUNNKzJm?=
 =?utf-8?B?REhoR3h1OXVXQ0IvZlBoMTBQNFE4c2xsTWdxM25ERHVrNFBORW5XZVRGR2lC?=
 =?utf-8?B?ZjBub2xrWWIxekw4NGRzbGYxLzBGMFVEOTZwRDVtY0tHYWczK0FzTm1qcXlZ?=
 =?utf-8?B?OFo3NVJaSzNQSDkveTJlZ3JjUVZoazdpdGZhdDFBNytBaVM1aFFZOXhob3dQ?=
 =?utf-8?B?U2JLaTRVazJNSUNVWG4vZVo0bG51NVBaVnJIaWRQRlhDYlloMitLcUtFbDNT?=
 =?utf-8?B?VGQydXR1REtQUXV5RzF2N2NYcm9hcDNnL3oyUU9sYlNwN2wvWTZZT2xkS2R5?=
 =?utf-8?B?aVFuNHpLMmhHa1hTcGhSNnJ5bW5hM2xxQ01LWmwvTDgvdzUxU2UyMC9QUk5C?=
 =?utf-8?B?RFg5ekZmaGxuSTFwUzJ4bVFNV0g4NlpLU25JK1dzSjJKbzkxWkpCQkNFVUh6?=
 =?utf-8?B?dTd1Qk5Ha0grYWVSSTl5K0FNNnRGZ1I2ZWxleWpES3NnYWU3U3Q0aTI3Z1lj?=
 =?utf-8?B?T0lETitwS3JWcm5iTUdtSUQyNnY2bWs2Z2taNFFoNGszY0JQZ09JSit4MWo0?=
 =?utf-8?B?NXRxRWtVZUJzeDV2MHJHd2VqUU1hTEdRSXEra25IUWk5b3I4UHJKOVF2TGdM?=
 =?utf-8?B?Yjd1WHlwY3QwQjZQOWtDZ2U2dlBSMDI1WVBudllTd1NSZHdkdDF3dmQ3bnNI?=
 =?utf-8?B?bXM0WHM1TUd1SW1zckxyaGkyVjVuTDM0cENaVVloalJXeHByaVlRTmx0eGJE?=
 =?utf-8?B?bXRscWNaaE5XZzJpL29sdUlueWFTbCtBYmZpSEcvREtyMitYK0Z5Tm1YL0xu?=
 =?utf-8?B?QnpnaVVBT1pvOE8rRjZySktXRmkyUXRvZXpJcytweUVqZzBscW9JZEZLL01D?=
 =?utf-8?B?VVNIcjJPODd6bEs5MWVCdG9mOUhFNGEzRlY4NzE0ZjdTZnNxU294WVFxN3RH?=
 =?utf-8?B?TVRBWW8zVHlRUWpHdVdabDFEbS9xc1BGUzhRSXBmSzhDeXZEWitnSnJVWHpp?=
 =?utf-8?B?azZINFhvdjN1eVo5TFhmSWYxM2xnRkxqQzhvQ3lRWWlxb3h4Umt6alNLdnJh?=
 =?utf-8?B?dXFEbzBIRUI5VEZ0N0FsUjIxUk9lUm84K1JhUE14UzVPYnBkTnllbGJ1OEJM?=
 =?utf-8?B?NFkrenpvZzRRazQ2eXNzd1dTenE5dG92OFUzQlZrUFNmblQvZ3ROT3NMallt?=
 =?utf-8?B?czVDRVBPTUJvRVdZb0pFcTNicGJrVnVxMkhKSTcxdFBRelIveHl5RVgvbzBr?=
 =?utf-8?B?OVB2UnBGcWZlODBraFFwL2J0OWxJamVPK1NIeFVmemRFUXBUMkQrcmxJNTIx?=
 =?utf-8?B?ODQyaGgza2hnaGVRYnRFSHRua1ZITDNsMmtTUFZDN3daWVF6Q1Nkcmk4UXJz?=
 =?utf-8?B?ekFrbzRNdm9sTjJMMjA2aDdxMWlHa0RjMEY0V1ZtVEMxMEc1Nmx3eFkyMi8w?=
 =?utf-8?Q?PI0hxNKDDz/G3maT7f0iWHwLJ5qR/++Nn5kQ2aP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c671cd1-4deb-4c5b-20f7-08d90026a541
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:53:43.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XTjZAocLQtlGcEehXJXIM+mbV9YsBwQjCYo7NAiUeJVTPpMcdpivXvYVHOeqMJA9WiVR0KhwfS5hAB/RyLdLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used to create an outgoing SEV guest encryption context.

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
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
 arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  12 ++
 4 files changed, 168 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 469a6308765b..ac799dd7a618 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -284,6 +284,33 @@ Returns: 0 on success, -negative on error
                 __u32 len;
         };
 
+10. KVM_SEV_SEND_START
+----------------------
+
+The KVM_SEV_SEND_START command can be used by the hypervisor to create an
+outgoing guest encryption context.
+
+Parameters (in): struct kvm_sev_send_start
+
+Returns: 0 on success, -negative on error
+
+::
+        struct kvm_sev_send_start {
+                __u32 policy;                 /* guest policy */
+
+                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
+                __u32 pdh_cert_len;
+
+                __u64 plat_certs_uaddr;        /* platform certificate chain */
+                __u32 plat_certs_len;
+
+                __u64 amd_certs_uaddr;        /* AMD certificate */
+                __u32 amd_certs_len;
+
+                __u64 session_uaddr;          /* Guest session information */
+                __u32 session_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 874ea309279f..2b65900c05d6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1110,6 +1110,128 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+/* Userspace wants to query session length. */
+static int
+__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
+				      struct kvm_sev_send_start *params)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_start *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
+
+	params->session_len = data->session_len;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
+				sizeof(struct kvm_sev_send_start)))
+		ret = -EFAULT;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_start *data;
+	struct kvm_sev_send_start params;
+	void *amd_certs, *session_data;
+	void *pdh_cert, *plat_certs;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+				sizeof(struct kvm_sev_send_start)))
+		return -EFAULT;
+
+	/* if session_len is zero, userspace wants to query the session length */
+	if (!params.session_len)
+		return __sev_send_start_query_session_length(kvm, argp,
+				&params);
+
+	/* some sanity checks */
+	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
+	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EINVAL;
+
+	/* allocate the memory to hold the session data blob */
+	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
+	if (!session_data)
+		return -ENOMEM;
+
+	/* copy the certificate blobs from userspace */
+	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
+				params.pdh_cert_len);
+	if (IS_ERR(pdh_cert)) {
+		ret = PTR_ERR(pdh_cert);
+		goto e_free_session;
+	}
+
+	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
+				params.plat_certs_len);
+	if (IS_ERR(plat_certs)) {
+		ret = PTR_ERR(plat_certs);
+		goto e_free_pdh;
+	}
+
+	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
+				params.amd_certs_len);
+	if (IS_ERR(amd_certs)) {
+		ret = PTR_ERR(amd_certs);
+		goto e_free_plat_cert;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto e_free_amd_cert;
+	}
+
+	/* populate the FW SEND_START field with system physical address */
+	data->pdh_cert_address = __psp_pa(pdh_cert);
+	data->pdh_cert_len = params.pdh_cert_len;
+	data->plat_certs_address = __psp_pa(plat_certs);
+	data->plat_certs_len = params.plat_certs_len;
+	data->amd_certs_address = __psp_pa(amd_certs);
+	data->amd_certs_len = params.amd_certs_len;
+	data->session_address = __psp_pa(session_data);
+	data->session_len = params.session_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
+
+	if (!ret && copy_to_user((void __user *)(uintptr_t)params.session_uaddr,
+			session_data, params.session_len)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	params.policy = data->policy;
+	params.session_len = data->session_len;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+				sizeof(struct kvm_sev_send_start)))
+		ret = -EFAULT;
+
+e_free:
+	kfree(data);
+e_free_amd_cert:
+	kfree(amd_certs);
+e_free_plat_cert:
+	kfree(plat_certs);
+e_free_pdh:
+	kfree(pdh_cert);
+e_free_session:
+	kfree(session_data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1163,6 +1285,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_GET_ATTESTATION_REPORT:
 		r = sev_get_attestation_report(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_START:
+		r = sev_send_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index b801ead1e2bb..73da511b9423 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -326,11 +326,11 @@ struct sev_data_send_start {
 	u64 pdh_cert_address;			/* In */
 	u32 pdh_cert_len;			/* In */
 	u32 reserved1;
-	u64 plat_cert_address;			/* In */
-	u32 plat_cert_len;			/* In */
+	u64 plat_certs_address;			/* In */
+	u32 plat_certs_len;			/* In */
 	u32 reserved2;
-	u64 amd_cert_address;			/* In */
-	u32 amd_cert_len;			/* In */
+	u64 amd_certs_address;			/* In */
+	u32 amd_certs_len;			/* In */
 	u32 reserved3;
 	u64 session_address;			/* In */
 	u32 session_len;			/* In/Out */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620..ac53ad2e7271 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1729,6 +1729,18 @@ struct kvm_sev_attestation_report {
 	__u32 len;
 };
 
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

