Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00E53542B2
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbhDEOVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:21:43 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:15969
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237153AbhDEOVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUyr67wqGRCMr+gRODwwKsUNtbx7BzDSelI+Z9VMoKRRFAzRLfEEwU45XDKkOGuyw9LJWoDvV/iI0DSyFnqCgo4h2M88dng2e1+8BgijzudhXTqS3NYr1O33sM4PuLNnUYtynoCVV4isNhOK4YToRVG9F2oY2FhwVDctkTqSup1Cw/f6BGVw1eRLuTZY/yuj9lo9OcTcw0yPBLY0wlmRcdA9g+/izBU26Vp6lCHLTuKjtp1o5MELoIj+fiNHhQCiQpnb4SDteYlm/vZiwWu8RohsqcrR4xgxAiphQZ+N0IQA1qYgjPr4HLfQkNaKCflFy2fyI1PWU5j+KW19966NCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9+vMxeGG/Np/pHxZBLItVNVJH2aLDUxgz42hCBtD2c=;
 b=dwNnLNRUv5mOEGzwRlzT9gDjN/z4C9yWBsrrvrrgHoZa7J+BbpGr+DGX6ObWx7IJmmobz0kjfuQrd/yTcuJDcFDKJ1RduBVeaHV6rVIAqqjcr3+oeZ5sKWiv5+Ej+w70SFyjXurC9WwJ0GQWqfLe9L7qlTB/oAbkDQvE/la3KlW0S3lrF5hLyWGocSHMoloBdSg0bA+lFG0MX7y3BqnsqtkPxULSa9kUlX3Whmx/ywhuYchcd+nTvLK+c8viMvA1Nzp4YJPYc6VoqNu2s5lSwO5pCLBNEFIpiVFCc+nX+rgdRw6fzQGKZV0ESWR9UFkbNNa95pH3dWxdfJaFeXamqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9+vMxeGG/Np/pHxZBLItVNVJH2aLDUxgz42hCBtD2c=;
 b=25FevdG+zUOahB3nPyieqa0f0Wh7/6/jO4F3jGuRdiz1mpBXtp/46AsB7gSqyVP9AVfVQqGL9rtXPtpchP0lyxbml7u0RUFHoFufR7kFpnZ7Jo1JhdafixHU4/1mUEB3wtsySjodNUlMZIpmeDWv/kk7LHvLode07Y2ImceicKo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 14:21:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:21:34 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 01/13] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Mon,  5 Apr 2021 14:21:24 +0000
Message-Id: <2f1686d0164e0f1b3d6a41d620408393e0a48376.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:806:20::6) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR03CA0001.namprd03.prod.outlook.com (2603:10b6:806:20::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Mon, 5 Apr 2021 14:21:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f6f66aa-b896-4e6b-17bb-08d8f83e1db4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557626F0CE86A3A8377F1568E779@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+Z6VjhV00tRpj4tD4KxMFBFu3zAZkXZ6VFL8pb+UbQX0NHFVn/BIkCkyZJ82XjFAZtDazjh5qLy6PrkvrEtPx+2n7DTf56VP+9bVTS58g4HCugkvslL6k9vahFca2QCxwaBdLzdrIONjYHmZxQU0XZvmy/DWWOiorTeL9iAWXnl1A2uk71TIZYstwQWJ5X5VutsHD3wNAQEg6IZvcBZbs48JrgHg+NJ99dF3OxwuRqmJ/ytV/B7O6LNyoEPeuNuQkNdK1H4NFINfKFHjUA6EIyAmGvv9RK33Q0ApGFhuU9XQmVTF/oij9IBlfvHqVmelIdwz2jHWwatgjEJwdush16R3U2yv84WU+UOHwXPjXrizZ3JjRypv0hfmcZTZVxmjuj5/O00TSx+4pyIHBlJi/YPeilDE90/FF8H7USk4Jk4slcedY1Xh8ERik/38qylFS8/o716fOIHG80uwj1f3k8XMlaJw42c6BeHw6nwSwrk9+jOqbPIz1PweWTyGxi0GXk7eBwpwYCz+n+F4X8dwR8PaPhlwFC0FdWT9ARI/583Bxgkoen2SRfYtKyey1dDd/okt8SQZMaZR5mWnV9qsfKeniRFb5ofXbrOkeo+q5a6gQimPjIvV6B6aRxvLgIghdxEk05NDU94dU0Yu6RQWbxRG+goBqmKZglI7+jbkQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(956004)(6916009)(4326008)(52116002)(7696005)(8676002)(316002)(8936002)(36756003)(66556008)(26005)(5660300002)(66946007)(38100700001)(6666004)(83380400001)(2616005)(66476007)(478600001)(2906002)(16526019)(86362001)(186003)(6486002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NzNvdE1Sc2tYc0QxN1BHM2pvMEZZU1lCNGxhSTJQNENwNUhMcXRPUDZHUHAv?=
 =?utf-8?B?RndNenZtWVpDaHlPelk0Ly93N2V2V3QxOE1MSUx4QnFvd1kxUTRxZ3RMVDQz?=
 =?utf-8?B?emxyOTZ0QU03SXo5S1E2bHQ4bVgxQkxiNzFocGtTQ3RndGdOdlBSbEdybDZW?=
 =?utf-8?B?U0VPQlVaWlhEQis2UWNMZGlIWXliZkQzT3lQYU9IUlp2Z1I1a3FoRm9ONTVT?=
 =?utf-8?B?MlNlVVpKZzEzSE9MK0VaalVwQk9YVjl0L3NHMTV2T2tHbWtEd1d6RW1iY2Ew?=
 =?utf-8?B?bXp2NWtBUkFyb2lvS3dhQ1czNDlXQXlzN0pMcTlYRVlYVGwyYS9EWW5YdCtx?=
 =?utf-8?B?a2ZTaUlKbFhQRllYSnJIdjRlaHdEcEtzRm5wcGJYYjk5bXdKcXdkSGNVZDZq?=
 =?utf-8?B?R05ZRkUwblN6ZHljdUM4TmNtNE13aldQcytXVWt2UUlyWE4zQ0pJRW43MGdm?=
 =?utf-8?B?cEF4VjZVSi9TMWxyNWZnUGhmaStsVjBja0phQjA2Wkl6Rjc0c1h1b1o3ODNG?=
 =?utf-8?B?bDN6UDBQUmluVnhITTB5eTVJakZGUzBxWTlLSUhrS2pLcXRkS05CN1MybEdn?=
 =?utf-8?B?b3lNQysyWjJlY2JiMVJLZ1hDTm04RVMyTi9sMmN3dExOclk3Y1hLSlNacmVv?=
 =?utf-8?B?YWhNTGNrd0M3NlV5V1lZTWVLTnY2Z1cxWjBhYXY4ODJiTmVyeU8wei8vUVNL?=
 =?utf-8?B?ck0xWW5wclhDeDhHdUNXRW94MWpZUktzWVVSc1ZrOG9sVXhrL3hRMGQzb0NI?=
 =?utf-8?B?eVBTenlSaVhLdU1lb0Exa2NLTXJMTytyRE1RL2RzN25DVVRpZ2V1TlNnSUxQ?=
 =?utf-8?B?SlVhNTN2bE9udmc3QVR1M2h1Q2dMNC8zR2JSRURwT3dtM21mMzlnUFV1OTBo?=
 =?utf-8?B?Q3E0bFoza3VXemxwZTBrTWFVY2I5S1J6eFdzTDFrM0F4RDBOaG9QR3J6R2dJ?=
 =?utf-8?B?YndlZy9MMGtST013OFUyeXlScForRUdnamI0dEt4WEJBdXUyejFyS3Nqa2ha?=
 =?utf-8?B?YXVFMTZjNTl4VVhLbmhOTVpxd3ZleVZFQmJOU28vOUptYS9DOHh2TENJYjEy?=
 =?utf-8?B?U2NXVEF6aW5IVGdORHBzYzdBS1pFSnpjbk1GcWMxZ1NXejNjOHAzWkRGVzBK?=
 =?utf-8?B?d0VKU2ppOWgzdi9pcE1DVjZyUVhnS2NPN0cyTWQ5UWl6dldNNlRocjNOUTFS?=
 =?utf-8?B?YmRjb2tlOG5IdncwQ29Wc1hIOC85dTE3cm9rcnI3VXFYdmxXbS8vVXZpMjNC?=
 =?utf-8?B?clhjK0hwdmk1OHZPVHNHUkNFdWg5SHlkK1dPZ2FkNXhRa1RDSUFINEphczhK?=
 =?utf-8?B?SjRubkFidTRIV2JDMnFtTWRPYUJWUyszbGtSSVhIa0NYWWF2TjVPZHNqYkVL?=
 =?utf-8?B?YmthV3pSSkIwcmxQc1k3ZmZzWlNLajl5a1djSHY4S0wxbEpZNnJLSHNzV2hy?=
 =?utf-8?B?R3J1L1hWYlo2NHpBdGZzM1hvbVh2SGJjYjBmeDZPQmNERGxXblAySllhYWlj?=
 =?utf-8?B?SnRxeEJtTG4yM3lland5YXN1bWw4SnE1eVRxVDE0VEJ6ZDY3UTBCWjVudTU1?=
 =?utf-8?B?MlBKZkIrRWVXQWduem9xZ0oyMytuRkdiL09TTldlT0VRejZJQ3h6ajY1ZTJ4?=
 =?utf-8?B?YkZDNUowYURYYWFGSk05R2laMXR2ZmRiYmxKaU4rV0ZXcTRacXhTN0crU0Zq?=
 =?utf-8?B?a2wvK1VENkxhV09TWHZ0b2JWRFQyamY5T3hnenR2eTZQQTdRcENDMUZ3NkRG?=
 =?utf-8?Q?tvc2ChTEzcCzGGnJT+O+eKALUXQmJWxr/6VY32K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6f66aa-b896-4e6b-17bb-08d8f83e1db4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:21:34.5306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/wNpaYDaTfii61WSH7CUhKSLea4HAWNquaMuxetL6RcVLf843SIXn4V26JMW3alE6utrEeTGbnNIRboQwx0Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
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

