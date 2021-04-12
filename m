Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA11835D14D
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhDLTn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:43:56 -0400
Received: from mail-bn8nam08on2045.outbound.protection.outlook.com ([40.107.100.45]:21536
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237564AbhDLTnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:43:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlVDpDbK/34YOmg18pLqQF5aJUnrRxPGHx632YIDq3Vuql1QRU4tWg4D35pNYBhexRjeVNFwqcRgFjAyj8WQiy+dnUhNUVCxevrVgFEgPQToawa2S1rsnr/YC0HAah/9OrK3JMitPBbsDv4zUA20joWxITvXv/RwFyZ7F7X9CELowyo1hp2RAM1O6PIMef5N919GbzmIB3HNfTjKzjbqK2oWLSIfyaUzUc+5HhDIMTRZ1nTceymCmcZkeZupvDbfpyPNPZ5w2HD4pCnX24zWaAIYyTt2ALDp8QwyMhAg8n0xUTAW4XdmXbCzfpin6OZSqmulF8KlUegThyYdo33Xmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9+vMxeGG/Np/pHxZBLItVNVJH2aLDUxgz42hCBtD2c=;
 b=Ieyv+cmt8EmMt9/jprDxqWhTVNUbl+a61kd9HpamF2jEvvXTfzQWXHv/22guIlAYT9C0vmjAB4p46pjY/Xsk/XRGGRdkOevUT6PlWpEICT+tThtmTOyQ356aELlows71Z53ywtiqOWcptSIINleaY6+Tz1K5h1y2yI0lj7XyIyX9CLvpBpxIc1FhnfRbkfEypcTO6J2/SW1o2SKzviLg/vO2stLLIxOwuZq7dMWM+hJP8f296UXm50bZ5surWwNkGc75B78kykW1moAdAXIgr5C/+4zOc71caeAtN6LeqBnijOa2Jsjfsv4AeqDqgVkaa0nRHEdDFM/6INFCV9myqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9+vMxeGG/Np/pHxZBLItVNVJH2aLDUxgz42hCBtD2c=;
 b=vdOz2wgPBdZhkuOsaquMG/TTR8KZlX0DrtIxM467S0YbH/ZjDNcYzKYuf59PqIel4xd0zU5FPx5FjZvxY6JUwll9eej7Y+0tr6vEEgfM4jG/okNnGZ9tqhHJQy8KYj3qoQeEVG01JOQH5ZA05FovbKpyuiCv8gvkqcVm+Iwf2Ic=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2720.namprd12.prod.outlook.com (2603:10b6:805:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Mon, 12 Apr
 2021 19:43:33 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:43:32 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 01/13] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Mon, 12 Apr 2021 19:43:22 +0000
Message-Id: <2f1686d0164e0f1b3d6a41d620408393e0a48376.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:806:f2::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0028.namprd04.prod.outlook.com (2603:10b6:806:f2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 19:43:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 426dbf7d-c072-4ca9-a0a5-08d8fdeb412e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB272026AEB140CDD0A2B07E688E709@SN6PR12MB2720.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ad3pns8phDZVFFm9oLAISKPYYzghdM58clpveeaU9IESQ5M4q5y+TPjbuOuMLZbiRnecUk43hUBgjn2fKEXNBhhtP7yb/vfz8z6NmGenWKPf/eWgCYnafDMSYvdokeiRug8zSXpc3+e9Ct+yUadsOkoPoBk4/NNflhQvE4mNAkiK5Cwr8ggyWYXJeCtbeZ7RyWmc4js7dTGLbIn5ISsCNH6uZstZzwD+iCSQkmEEeDXOxVKw6Zgz/qsXqLqfwCHIzlhJbqBsr/WzdmjCGZ49dNwEXDcnmsDfH2VIpb9+kO0T5OXOj5zRAOqI3DzgoMquFxOcttwBjk8vq9Y4sF8s131dK+WUoJSogaxvXiB08Siu+QMIDwdiNqEt0yJFPerL5qQ3mswFvn72nYfrvVEqYyDXafi3NFF+Rp4ABnN5NvHw8bWGA6mfL+nhwsOg0LfWlw2iDEWFENdPKW7you+rR3huGBrtVGmsNPVekxh9zEruiKhPa+YOUmlIhyMaKr7hfiNT5YMw39LorJ1+cGbPSM/iCjcYhNB/fISdB2PFJ0erT9UbF2SRLGYBygf8/EjuhYZa84B44Cfbp8z4nBFa1PNfL3ayMlLjsWWlxMXPvLi/+gL7DlQE3D4uFYN0yAPu6QHCsfJCmdWC7wbCM4h2Wc0g5VEj8FXsfnVSZ/Xw+es=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(86362001)(36756003)(83380400001)(38350700002)(38100700002)(4326008)(2906002)(6916009)(956004)(478600001)(316002)(5660300002)(66946007)(52116002)(7696005)(8936002)(8676002)(6486002)(66556008)(66476007)(16526019)(2616005)(26005)(6666004)(186003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVoyUGFsd2RmcFNKbFZKcjhvbmRaVENkUnNkVVhGaDZoSzliMVpLL256d2dt?=
 =?utf-8?B?T1NRak45YklCc21haGRCdFlFbWE1TUpnaG16ajBCWllDSlJqTFdsT2tmREl3?=
 =?utf-8?B?dTJxa1dJZWtpbktjQU1uWlNDdFF6OUlUUC9lcURNU015ZUZnSGxESmMwMjds?=
 =?utf-8?B?Y1JOYlkvbU1Bc0Qwc2NXaml0MjZXRllyRjdrcy9uZTFBanRYdVV3S3ZCeVJ4?=
 =?utf-8?B?VWErUW91MnpnbXlKdlpqNE1CZkhUUkdMN0ZBU2RlNzJINUduWS9DOTczVVJw?=
 =?utf-8?B?MjROVzVJKzNpcHhsdjk1NEMwRGFyc0hLLytvcEFZb2EvMjBpa3gxcitEaU5S?=
 =?utf-8?B?M1lQRk0yK1VxaS8xaWVJeE9IMGFkU1F2azh6YXVYVHBzdGg2Z3AyTHovOHgx?=
 =?utf-8?B?VEcrVjMwQ3RFWlhzZVJQMWNFOW1CQXdrTnpMVGVJNU04RG9FVnozakpGUW5v?=
 =?utf-8?B?STZoSDBFQUVWRDJ4aFNBK2JUTmV2S1oyYkR6dXBhOG9XTlcyVG41Y3V3YkFw?=
 =?utf-8?B?bUpUaGpwOGRuS2tIU1RVdlpWZ0xuZk1rMTgxSlBCSFlDZ1pwTFJsdllveEgy?=
 =?utf-8?B?a1Q2ZE9zQXpLdTYvOHdsNUM5b1BBdDJCYXJSRFFsc2YyVzZYRlRwM1VFeFBP?=
 =?utf-8?B?WUNwNGk3MU94YUlWNkZpRjNNZkxwSWRaWHNtRXh4WGN2WTRUbFFEaklNejF1?=
 =?utf-8?B?QTU3V3NITmFRY0tkVlovaG80NUVNZjV0MzRCTmIxNTRxVERBa241VG0rS0R3?=
 =?utf-8?B?ZHdkaGdjRGI5RTc4b0Z4bDQ5L0xiOW5mb3JZVVhXNFo2NmtOVjMxMDlKT09t?=
 =?utf-8?B?MkdEa1B3TDUzMFhJazRYbENveUNndFJJR0t6eU9CcG8rUVowdWxQYmE5SE9G?=
 =?utf-8?B?cE5pNjc2ZkNYL1I2U3FRL3BqT1ZqTjl3c00rRHg2cEN0aUh0b00wZjZ6akNR?=
 =?utf-8?B?ejQxVjFEOTNPWVZtbTdnb0VOYklBQTIzMUtxQnAxSCtsV2NTQzVYRzdIQjdT?=
 =?utf-8?B?aWNTand3V3lJTURMbldGNW9Cb3g4WVF2RUJUa1ZTSUtiTTM5Sm5KVjA1bzNC?=
 =?utf-8?B?TXdCd2ZHdGRFNkVaeVdOQVBFVzVXNng4MHBtYjg3ZVNqeUhMRHR6R1RwalY5?=
 =?utf-8?B?dHRZcjdPNzR5aWt5UGs1MGZ3WUZVb0V2SWxsd2VsdjBzTkljQUxUeVZ1K3lx?=
 =?utf-8?B?OXhFdWNLbjJFa1ZMNFJTbXQxV1RPZXk3Rm5RWlR3QnN0MTFHTmFyOHk3djhZ?=
 =?utf-8?B?L29LSnVCOVUzOXpjTmZSaXVMYTVINFZqZkJxK1kxMzhRSEtGTkl0eHI2NnJv?=
 =?utf-8?B?d1RZOHVVK2FNKzVDdnNjMlpaaGdOTWpHYVBNQTVYU0dlcXRSNHZGdHdSd212?=
 =?utf-8?B?Vlh6Qksvd2syWk5qczBmTm8wYXd5cjBtRzY4NWxiYkR0NWlUQTF2aEhJbjNt?=
 =?utf-8?B?Vml4bGNXZFlObnFKdlIwT0ZvSEFUT003VTREN0hHMXNDWWZyK2ExWFNuMEJR?=
 =?utf-8?B?Y0d6MEp4NXdjT3JhZURhdklqa2l3OGp6T2pnNWpQc2UwOXczSTNieWZhbExM?=
 =?utf-8?B?UURUK05DYThlYjk2N2lxNmpIcXg3V3FQdmt0cDF2eVNtQ09aczgyTmNwMkp2?=
 =?utf-8?B?WFlCZytPVE5UM1J4blFiOEYrUkNhaW5iTlZJQTNUYXpBUzRLNm9DYjVjVzkz?=
 =?utf-8?B?N1RjQUFna1ROMi9nUW45WGt3ZDdLOUlCaXZuL2xmN2QyQ0pZeWJLOFNYWkF2?=
 =?utf-8?Q?XKWY7GTCBBF2s1bgVMBWSGpB9cOaRCrkUn0fe2J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426dbf7d-c072-4ca9-a0a5-08d8fdeb412e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:43:32.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5NfTr4dWsPpDOFhv2XLn+BdvUfopEGBp2vL0qibOyrORb4Mc6yWiloxpIpE09Lch7i2Rrl12874MUF+j2H6e1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2720
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

