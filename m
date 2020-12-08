Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A6E2D35CE
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbgLHWFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:05:03 -0500
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:37153
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730739AbgLHWFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:05:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eShcA53hVoYDJyFyd2d6Kl+U65ko/f0DRh/nz6Y8fxAFCw34+LFGsUghIl6CK5UmQcddBsJ35kmC218exJEJhi+oI6EzAEmvBis2g94SBeUZMIbnoRzO2Bebba6/BtysFzoqkUk988eJ35be552kIRIPTh1NGEOCrOQ7TphCJB8PgD028CkPF3ecsAiFeO5ex+axBtgyipB/bfbRnsHUuuth11/g171Jdu6mUSniF3qIYOKklsfUt2gqTusZ0HyGrw1WQKvUlCd7ywAV4s50AalFLukgk4iXk6ly09u67UAa4QOiaMdSmQkbQ9oJE5fmEMzANe/HJB4Pl/BDkTqg+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLuRQUgfGdBflyqEaDs9Jkt2i6psVdRmX5pDNuT531I=;
 b=cxPW7hNIzQWp61yyPgS+QOAFcmvXeBMzV0lx0jnZqC9B9aECXGYu4zEYBjx2AYIboNtrdP8K5O+KSuvPKH7ck8YQwtEyB8yaS7kDauz1RgCNKxIHWPBXbbL7WEUlXPpjUezzs9sBE8fGHopic+HTVDUb9tmOjrUOR/U14/Zm3NZACkSGgqqMATEUlqns/hSNYECM12ahhXbXXVRMefn6Ix6Y74iyBY/f+uNwuPRnFtbtMCWHUM6a7U+JCHXiYzfYYcezULgSDWMfx4R4YYoYW00Bgb+2JCKrO2g8g1iW0+kP73YPte+ODO3m45EYNPp9lK7kd833d0EBHRkAll12/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLuRQUgfGdBflyqEaDs9Jkt2i6psVdRmX5pDNuT531I=;
 b=R+qyDO4DMxVe9qImuv5hOfpyBUf0afNtsZgX/2fHdeir6GUTLyF2fdLKKxGapMmQcj0Q2V/Ni67jGNqEbStxcg1qRe3bDSjRtsqhqGFY3JTLzYZvb/RMwyfJ8zC3iGVesvyEaJioIZIAkoace+zHlg+AL+OStgQZYytYzvus4SY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 22:04:06 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:04:06 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Tue,  8 Dec 2020 22:03:56 +0000
Message-Id: <813ea518ab74252cd66565fe87975dcbdf15b3f3.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0032.namprd07.prod.outlook.com
 (2603:10b6:803:2d::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0701CA0032.namprd07.prod.outlook.com (2603:10b6:803:2d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Tue, 8 Dec 2020 22:04:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2913bee2-3362-4061-3f18-08d89bc52ecb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB436597735CE2308EE596EDC48ECD0@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2wbGfz9diPPGiNnQzER8Pwf/Y+o1owrQb9uvU2xjEZwdIUPeXsTHlA7hqGEnjK8BCttonq3qosA1Ef88RIK6lghCyV4ZzgDPpn5ZD5LVgwe6WG6+CjRc6Evqa8pJA4A85dNV0kA0pZyFUBkfpy5pl3E+EoW7oyB1Fa3m0B96AlbjASlf/L+Rb44gPqn2Dk5SBKWxb0pXOmsc2guI4plx/yzzF+c1lMFXJ4PdWOY+/yXb5QccAxuz7PIH7/KhhVv8xMrRYi8V21Q4OLOdMvWu8WVmHcWrYz+KYxmftqA2LvgA1x1xDnZNcehPSvLH9u0x/ehuzIfmVxnWkPEjHehOBD5UDYJ+5OwPGanVl9hNlsKz5DeckWdl27cLTacWevD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(7696005)(508600001)(6666004)(66476007)(66574015)(66556008)(4326008)(66946007)(52116002)(5660300002)(186003)(2906002)(6916009)(34490700003)(86362001)(2616005)(16526019)(26005)(956004)(7416002)(8936002)(36756003)(6486002)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aVpKdFRRU0pzajZ2bWk4THk2NXBobWpWd29ld2cvdWZ5WSsrSVB0SVgyMFRD?=
 =?utf-8?B?RCt6WnVSRS9ZbXo1QnphWm9BeTh6WEhkVExKQzR0N3ZOaU9jR2pJMmJidFhY?=
 =?utf-8?B?TmNkMDNxSzB2SlVxcEFiamxEVXYyT3lzbnFLemZWZ05kSFpwQktTeGdDQUxQ?=
 =?utf-8?B?dEdLakVYWjJPNW1DeFBndi9tejd3R0xrZFlIeFkyVmV0a0hGNlVwdmhCWHZ1?=
 =?utf-8?B?TlhCT2F2TFprL3B0a2l5cmZMQWRkQ0wwakxYVDBZcmxYVmRzZ0NFM3hXVEM0?=
 =?utf-8?B?aVFJblpaV0syTTdRRURWUDBBSG9uTDE0bmJQOWNtUUNyOWVpVkpHT2lWYlNs?=
 =?utf-8?B?M2VPMzUzMGdkY2lFMTlaWFpoc1VxM1lvWGR1RUNMMDBnR3E3SWJYakllaWtK?=
 =?utf-8?B?T28vTk5ROHNaUlhyUUdpbmN2QW05cUNwYXRodTJ3VUp3OWt6cE9TUjBURGQv?=
 =?utf-8?B?WDJmd1Z1QXorTXpFdGhEbFVlUVdDemxWOVU4eE1oUExRa3JOWERYRmhsTFZX?=
 =?utf-8?B?eEY2b2pyZ1hvV2cyMU5FMWc5WGgzTTFsN1pWcVZMS3V3RWV2ZkRVdXhieUlH?=
 =?utf-8?B?bzMwRUVrdUJqcDBTckptenUwNmsxcVNjLzB1SGVjWDlRakdVQXdUN01uSFNF?=
 =?utf-8?B?a0M4TWxlYit3L2FwSWU4V2k1Ynl1QWlWdzQ1VGphWWRHbC9yMGpISFYybmxJ?=
 =?utf-8?B?SWJzcG9jcGRkSnZ3aGJncEdXSGh0alFDZmR0eUdGOEM5b0EzM0loT3pzQzRB?=
 =?utf-8?B?YllFTzlDTEdudDFGRWhqWUR6TzNrb1dVWkNVc3NqeUhEZ3c3STZSMDlYcnZl?=
 =?utf-8?B?Tm1GUGVDU3JPNEY3VnV5M1dIZ1lOdW5FL20rcm9MVTRKem1PNVdHNzZ2YWcv?=
 =?utf-8?B?bkpWZDk3ZmNoU1hCeVZBQ1FycE4wNmlvcmRnbXY0TTE3Y2NrNkhmT2xxazk0?=
 =?utf-8?B?Z05OSUlabit2blFMRmdOV0U0ckVGWGppT0Z5cm93S2NRaHFjS3B3ZUxMcWlL?=
 =?utf-8?B?QzkveEJiMFVVb0cvTFF0Z1ZXWm4ycm1KdjlEeWZaOTEzU1NxSHZmZXZsYi91?=
 =?utf-8?B?SWZnTFYzNE5DWUdZLzJtcS9XMzliK01WM2NpUFp0VE9QNTNBZ1VrQmNJOStV?=
 =?utf-8?B?YVJXV3EyNzh1YkgveFVac1RFR0ZrVWhmRDlKZHEvTHFraGROOU9UQzNDUDZY?=
 =?utf-8?B?NUdIQ0RpcGs5OUNicW5YWU9ZTjlDb05vdWx6MjJTZXhUV1ViSy9ydlBZVzVM?=
 =?utf-8?B?bGM0VDh1QjJuNndmbzJoVHFrY2wzVEEzNitaTGFVcjdXd3hxemo2dVdMMkNl?=
 =?utf-8?Q?mimgwvMF9WAgOJAwamzwSGGnaFMaXQtajz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:04:06.8060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2913bee2-3362-4061-3f18-08d89bc52ecb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qd9W1NL/hw4a+lvKRLP9u2f9ABFs0cBedMHRaVZzATDS+dVhzPYWhtcMi127WeABS38UBlqeSa7FX+iEVN0lZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used to create an outgoing SEV guest encryption context.

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
index 09a8f2a34e39..9f9896b72d36 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
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
index c0b14106258a..f28a800e087a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -927,6 +927,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -971,6 +1093,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_LAUNCH_SECRET:
 		r = sev_launch_secret(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_START:
+		r = sev_send_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 49d155cd2dfe..454f35904d47 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -325,11 +325,11 @@ struct sev_data_send_start {
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
index 886802b8ffba..f91aca926e89 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1643,6 +1643,18 @@ struct kvm_sev_dbg {
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

