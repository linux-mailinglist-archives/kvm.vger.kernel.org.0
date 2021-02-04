Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC2A30E89E
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhBDAhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:37:33 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233343AbhBDAhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:37:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG6DZUIPfP2TRdYCy8oAe8BEMV9XSizNPN7LRd+7kEryA+p7I6SzyRwDpL+3b5ABAh4JuMzgh55hV5NwrDsyn/BFJ4GCkU0qabiOOtttc5CFuoldwuHzTyLnokUZmIVLv58v17F4L9kU7LttCk3tkg4EnR2g7zXD8rfl3FjjSHp8pA+4ESzASGXSlh+87Z1lKRxfw0d8856ja5A5zufOQclyVK6aYMLrbWLxtFhSniEMkrdVAhiXHajeFeXSkYM+vHr08IdaNFqSXL1bbKkdAMKQvsG2rCgbthZ6i2t+9A6HaRb2bhksKgdmztWbTBUA6qLn07nF7fmkj7knzdTtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV4tmI0JPaYZJop2XHUnckbXZPG53Y5sV70d3NFdtGA=;
 b=gqrzIgA+UQdatomxFzH7sSn6+Rccfc12zIS2rkuLOneEtKOYuNv6ZU1q7XAjahZ9Kz0Hba5Ya2ES6741YiZEcIe0jyNDeUlpmcTj8DrZy8/hWC1StnQUYfULIbRKxYO2wIX68MddSRKFwVugMiJ+A2YsYA4IF4EYi3xi8+TyEbF5xgP0VhxPgRCza5YCr79QqDlgUB5m0xE49RJjDxrFb8woMFwYHt4LAlmpIst+L2J3FXvYR0q+VLibTEG/yonSpvDi+bkSFiesfb6lvFUUO3n6DF0LOQnZI3G4PaIfONZ3PeOfAz5KXlTJDKx+RlpMlZNMcSdZxBWo8wHGNfKZjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV4tmI0JPaYZJop2XHUnckbXZPG53Y5sV70d3NFdtGA=;
 b=jDlu6dDaITZVML39wfUtffxErxEoNAT9UejaVmCxVZPRzARKtmZLWGGY4WWEL14Nq321VBGv5cza0xM5Qri1NLPhTCsDtu0RYZ/VueJ4087EoHi3eQdjL0LNmGTQ2OGCnNe2AODA9UwGVVWsOaHCqkwDLZLF3TS/v9tgtR4JDWM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:36:37 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:36:37 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 01/16] KVM: SVM: Add KVM_SEV SEND_START command
Date:   Thu,  4 Feb 2021 00:36:28 +0000
Message-Id: <48c18d02e68856fcc667dc95c965132f42080fb3.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:806:d2::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0071.namprd11.prod.outlook.com (2603:10b6:806:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 00:36:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9a6b339-b1db-4224-8eba-08d8c8a4ee8e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384E38FBB1AF02A78A18BA78EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtNHZNn8ydwiSDhducu4+bgmRccLQ2Wm1u4M4swGFz8mnuGyK5qnIIwIBsO459ZvkrhKydsn1AV0xRw4S1lGG9NySLFzVHPCJb9zfsdOeOHGdu1bouVRbmAVhGS+qvJW7B6r/zKzZ/NSAdANeRhtD3d2Hmx33E0RWa/hMQHsGROfhrvnnq3c2TWaU/B4yOxatsZcNH+SDYeRSkxsJ5EWjM+GdTXqXucLiDvRalakBrW9sW56uOkD4M3sJGa9OrqlaEGfmkrUpPi5iW+KBVtF08LyHMbItXDecvy/2ogxAuyhjs5tYpr0A5AAP7hLZYKeCnSQ0SVOUpWPWMrZkVXhDLcTlJUND0mC7YwgRX0LQ2PSdksXuYXHUderWW/fP7pWM9yb1Dzt9+IkkL2Gc2r873yl9WaEHK2BtIbYFoHpX/jZP6wHz64xynu9VBmU/70CiPOkHHOabzBlU7f9bS+wZPRMXYqZ5f7Hi+K0m0jffr2Fmn8J66etX/gnJSXVdO2xFzZa8caVxS/G435RWOVjnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MUxaelB5MnBINk4xWDcwMjM1S1FUL3RpMEJnbnJtdVlMOGw5L0twK2M3eXZY?=
 =?utf-8?B?L0ZmL3JOd1pFRTB3ak5rRWVGTjVhVCs4KzhMa3NLMlhRaEpCNFVabXJNR3JR?=
 =?utf-8?B?R0lqdmxhdDVMdkJXeEJDeFRKZjA1OWVtOEUvdXVpbSs4cXlnek1UZnZXeWpE?=
 =?utf-8?B?NmZTZy9sWEtmb1M0dktDZ04vSnJNbk52Y292dytCRmpHZHZhOHpNUlhKRGlG?=
 =?utf-8?B?T2JoUjFET01SVU1kcXFSQm9vR3RoaDdPTFBuUmVJTFkraDRzcko3OUJLbGlK?=
 =?utf-8?B?eHdyNFNic3lZV0s5Y0JIU1NRa0twbjkybEkxR3pXVFBsOHl1bDFWa2lZNU02?=
 =?utf-8?B?WnRsR295YnhQalVPUGErMWxUTTV6RGtOcjJ6OWl3bkJmc2VIOURHOWFPeXFG?=
 =?utf-8?B?RXVVVytjWW1zTmVlbTlyTy9oMXJ2ckdDNkdrd3VNY05pcHBZYXlHaHhmaXh2?=
 =?utf-8?B?TWRlNzZXYmw5ZGJIZVZORkZXRW9udkxSUS83eDJPSUNNY2FRcU5RZEdpS0Np?=
 =?utf-8?B?VXdLd2kveGl1RHZQSlZFb2x5WVJZeTd5VmZZZnJ3WGV6UW5lSFRySnpETDJm?=
 =?utf-8?B?THFlOXE3NWdKelBrMy9NRUl4ZlZ6Y3JqQnhEK2Q2aWNIVkgvRUVuUndLbzEx?=
 =?utf-8?B?VUhDSVRtaGtoYzc3OTAzSk5Wa003NWdpZEx5V2hubHdZTG5ZWGxFV1JWZmxD?=
 =?utf-8?B?NUl5M2twZG50U21BZWVZdXZuMXZlbzgzc2ZweENnWlM3bERONmxmVmVoK3Zs?=
 =?utf-8?B?YWVGQXRLS1h3TTljRkdDNG9ZTlBnNjdNTDNjSVJ5SlRNUnlTODVxL2k4Qlk4?=
 =?utf-8?B?NGhGUHdLa1B6M1pLa1lTaWNTTEJBK2sySFlZTU9aYWNXRHpGY1lEaEYzSStJ?=
 =?utf-8?B?LzFhOGd4Unoxc21KL3U4Vkh5dkplYjVDVkJpV0w2NHRDMFg3VnNQT2s4RVJW?=
 =?utf-8?B?ZzNJd2pJN0FTV3pQU2p2cVNOeE1QWHNtK1N1VEIxQWx6blVoYlh3NTk2UWZF?=
 =?utf-8?B?QWpCTTArY091N3FIQWd4bkZCbGlSZS9qb3N1a3Q2S0E2UXZYMnppc2laY21Q?=
 =?utf-8?B?dGdyUXRQRzU3UHowYit5N2F2MlJVMlVhNng5RWx3UDRVR0FtUGVGVW50NXY0?=
 =?utf-8?B?bmtZYTRsR0hSWjFXaE1qSE5CQ00rUSsrU2w5WGtTN2MrbytqRVN3ckNqSGpo?=
 =?utf-8?B?eHpkZzdCelRVSTF4VHF5WlRHMTBGbzVtc1EvbHZRcEVsZlRnZm1mWTRyRlp3?=
 =?utf-8?B?T0NWaHlvbjBBMGkwUXVyOFlzc1g5MlJoZnorMGJIRVFsREx5ZnMvNkJNb01h?=
 =?utf-8?B?WC9FTjRZb3lzcXBrd1JDMTI3eTIwV0VOMkZiNFQ1VjlZSjlIWWRMOEZzYUho?=
 =?utf-8?B?YWxFc3N2cEtob3VpWHlyR25kY1ZDRjkraExMcjBTQjBVL2ViVDFPekR4c2tX?=
 =?utf-8?B?YVdvU1BwdWNoZWZSaGVaMHdGMnVuZVRuNVVvMmtIWGlod3FCeUdaakpBd3BL?=
 =?utf-8?B?MFYxVzc4ZHk5a1pqOENSSEVKd2V0SHVlWXFJa1UvVVNYamhGeURIcXFKS1BZ?=
 =?utf-8?B?aTdwSC9oTytHZmJOZXE5eDhVMDF5UEMwYVFrcjRCUEdXMHhvSVZLZ0gxMFIw?=
 =?utf-8?B?TGhaSTZLTHRqakI2NlQ5M2c3WFNaRmFoTnJMUXlmcEJscjJ4c2xsYXhpVm5T?=
 =?utf-8?B?MEsySmhCQy9UelVZcGZsck9oRjdVZ0cxNWdaSFFLK0VUdUVoNjVZeEgwVTll?=
 =?utf-8?Q?iHQKlBx1YEYGikUbRECXe1wAlcjwaqbBAz5QrQt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a6b339-b1db-4224-8eba-08d8c8a4ee8e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:36:37.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdDpSJrbYif1TIZMWpFU9qIsepUEdN9FeqezCZ6jZY8AOed1eTz/6r0oBuGc41h4s83mvsKPYYR8CdFYgkISww==
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
index ac652bc476ae..3026c7fd2ffc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1039,6 +1039,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1089,6 +1211,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 374c67875cdb..8f538fd873f6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1645,6 +1645,18 @@ struct kvm_sev_dbg {
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

