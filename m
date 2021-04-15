Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3494B360F90
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhDOP4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:56:22 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:43488
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233682AbhDOP4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:56:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqbg+AQUv2gxFtXoGr6mUHetlpKipqBOeppq4l5aD0Gl9xSft7ffarx8wzyNE/vdAAiE5ue7ECetccFlt0t0+FE7J/gELtycwYHLPD4OsxopJPhJeHu/MGT1u/kIYTb9NRUzCkd6OpMyAExcl71JhLc/uT4oOXHhX1R0uCqu0FmH+ib2TYUHcr5GBcL1k/tWyyxNFS5M3gPR8Til/3TKKZ03bzvIZS0lMk4gbYyqsr0hfL/xCR9qXAKB++NEwkkumDSKG8EAZNgAJiGPOiIPQMfTCCS/6saRiqS/JhB6JyvLuvWTDg3qiv/Zp5zzR+1HeWxEq5IsXQAPnFJ9awKZdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecWJetWk79BG8nSoPDpZq7XRRwLaEAjNQ7SI2nOsNIA=;
 b=HcKpjcORKmP6PZ83FLEoIOEId7xUpdpDwkR22YyO4SLqCObhlwKMpc36CZ9ePcWZJP8ndGeCnbcB2S0WcObde1Gvfg5dK3fQho7Usxf56pe9VqIuoDRGzIqOALZl1Eu017LjugqfpWQ1tBX8E8SA0V2xN5cerEcrAiBJrIdJe1NwzBUJsTA+FnWRrU/RWzD1rEW9jdlUtuWwpU54GBx6NCC22JWWbvQXZ3L6pkNxqhvNbrQWcaD5rxXb9qAyDMyUexJ2FF8E/h2ODUrPisjO39PhMDR2RKqtV22DG7IgIrN03dnsKiWyHg9XMudOPzqJaEmwI4Ft8YNTYX87+XTOIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecWJetWk79BG8nSoPDpZq7XRRwLaEAjNQ7SI2nOsNIA=;
 b=M+PaGQG1dDVxPXCzCjPtWhamWXPvogHZTOhQ4D1bnsrRCN5x4wkCt65phWEul6O/1FpdRYo4ECIo+ChK6N3V+gPMlM2ElA5yWOpPp1HGbYjlBpqe7jhhdG/rcrO2B1iMIIK/jw1owwqjow+d1u0u/4IjiTHozVmKKtqtFZ/lEt8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2510.namprd12.prod.outlook.com (2603:10b6:802:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.19; Thu, 15 Apr
 2021 15:55:54 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:55:53 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 06/12] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Thu, 15 Apr 2021 15:55:40 +0000
Message-Id: <d08914dc259644de94e29b51c3b68a13286fc5a3.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0051.namprd13.prod.outlook.com
 (2603:10b6:806:22::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0051.namprd13.prod.outlook.com (2603:10b6:806:22::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.8 via Frontend Transport; Thu, 15 Apr 2021 15:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b18f70-3826-4222-e926-08d90026f2a0
X-MS-TrafficTypeDiagnostic: SN1PR12MB2510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25101FC247D481BF376C08D58E4D9@SN1PR12MB2510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKGtURmgn6Z0j/WfgtwFW8rNaytzDVZdVEcRnj+c0Erg2LPM4mNY1d3QufdAp89fM1rofFuEjm051FfUATdzVfL5X9RnFOuWSneaqCJLh6QGawzIgKUzaZ0TLns/E2lvSjDn5RIASV/g7numen0kufqYmJafl7/xdlRuff1Fo2B/qf8MEGqQVGP8zgXOZ4hv2KHeduIhbkp/o8oi+t2ETPbkvVN3IaLLcFNa1oiDHD1OC9zmbY6XiTAowgzzNgSoCYr4Vm7Md/HyHQFC4GUJvQMJaEQaL9TCVrI30t31PXiPpM4ResjVVNrIGmK9kRV0Z0wPfHd3QPfcxBRi1Xuyfc3TABnqKlj2f7Qt6Ze/Y8wRAGVgs2lCp4QMYzbUFlJUSlxmVxMvORdtE3M88ReMDU/IRZ7zOFoTn4Yhi6EoLjGbyLNLfsFoT4K8CWBVgw03F4PDFzNjK1tZxXoGFsKftTAbafxUcmPJIjfeNwj+o9FKB2rCWXTOXqEgsfi0NczfOU2jjKmUv8kXkaZIWljiugb2ht04N8+wmvSjkhrFRqQpApKEZQVQuWifyJqaVtzzaa3lxB+Z0C3/KOGfUI0W5fzeYtTgkLip+r3P7q2DGMEy2V5LHP8iqgbumno0IIg2u6UiDxeZrKXh11G8z8q+Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(5660300002)(956004)(2906002)(4326008)(6486002)(2616005)(36756003)(16526019)(26005)(86362001)(83380400001)(186003)(8676002)(52116002)(7696005)(7416002)(66556008)(316002)(66946007)(66476007)(478600001)(38100700002)(38350700002)(6916009)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTdPT0FFblZab1RmZ3lsWFA5N1dxZzNCN1dEQlZ1cTMwQ3ZVb29rTFVPY2FD?=
 =?utf-8?B?ZE85UjBJVnhGSlE1d1RQQ0NzUzBmZjQxREpZRlYrVmdwWHhlSmwxdy9KWTlE?=
 =?utf-8?B?amsrV3lCSXpia2QvMTZTTmVpeUpIajM5eHRSMEd3QmxwMXJhUnpYZnZIYTBt?=
 =?utf-8?B?akhtQXNBYnhUYzZNRW5ENVpRZ1VpR3VqbGNFcWM2QWtSM1VjZEVScXRtYW5W?=
 =?utf-8?B?UmVpYm5VQlJPVEl1a3JQOTVyMlNhMmhJblV0ZXQvQXg1ZEx5U011d1ZjbEtB?=
 =?utf-8?B?S0dCczdYWmNQMDBDVjRPODRYMXRSb1pMaTg2TzdicS9mbXVLRFVqZUhiMXF0?=
 =?utf-8?B?R1MvbWdiQVhiZ2V3dWthMGNxRm1kRDlOejRDeFVPeHNTbTV2QzFTR09JeGFT?=
 =?utf-8?B?N012UENUVUVpT1llRlB3Mm9ZVXJrSnkrMlh4ejljZjZHRHdXM2VTQzdyRlVR?=
 =?utf-8?B?Tk1VVCtxaFEyeXhZd2JMVTJ4TWtGMkgxMDJkb01uSkM3MWxVc21FNzI0bHpu?=
 =?utf-8?B?U0hzendIRHhSVDJSbndVODltckp1MUlIb3Fxelh6RmRKTENjM2k1cVlzbW5L?=
 =?utf-8?B?QzVHK1liU1V2eFhERlIzNXBPdE9wRmdNTVgrM09MR1A5cUZwcVlXYy9Gd1k3?=
 =?utf-8?B?OFlqK243TDN6a2tOMnF5bGQ3TFczbHlhcnNMYmRSVmgyVUFWQ21hWjkyZXdJ?=
 =?utf-8?B?czV4enlHbStEelRZUlNQYXF1MDhXcVUvZDhOTVdiQVhEQjQ2b0ErOFMxU0V3?=
 =?utf-8?B?Qmh6WWRoRUp3L2FVNkpodStTODQ3MUY3SmVoSytmQWFtMVdxRE5ZekVGLzFn?=
 =?utf-8?B?U1ZkRFAybE9qcXRBRk0wQ1VlSzlrY3R2R282cVltanJpbmowektSanBMTUhp?=
 =?utf-8?B?ZVBoUnp2TE8wY1hDdzYyUkJrdEQzRTNVM2dMeTYxVnFUMXFIaGU1QUFBUXZt?=
 =?utf-8?B?bHZMVTFIaXg2N2Fyem5RVUg1cTV6NmZlaURObGVxRTdERURDVGttdldkNWJ2?=
 =?utf-8?B?MFcwSGkreXFwRFp4RlBVVXl4TC8wMkYwWTlXZU9YUTdsR2VqSWR3Y2dwbi8y?=
 =?utf-8?B?NjZrYmloa0FLWTNmblhEREtEc2V5TVVkbERkZ1ZIZXRlNVNMK1RrNWtjYkdI?=
 =?utf-8?B?djVLYlpIS2hldWRHQkMzMUtka0I2dWJQUDhmVEFiV3pSb2xBNlVRS00rOFIv?=
 =?utf-8?B?ZjlRRlNxOGhWZ2s0UDRmVEJ1RG9mQzBlOVlRV2s4bVlyakVTRktjR3U0QWVa?=
 =?utf-8?B?TWJlNmVPOFEzUDlzalpFb2JNSVgvVWM0M2cxUERRR0NtTGk2QW5vaDZTckVs?=
 =?utf-8?B?dW1KejVoOHFqdUZ6bkQ0OUNjZ0NQcnZCOTlPdXBXZ2hRUjZSc3FjcWFjQWxK?=
 =?utf-8?B?dFJiUW1EczJHeVgrUDNjcVhIV1hwZkhRY08wNE5hUGsydzdSUmg2cWZaWGZK?=
 =?utf-8?B?T0U1YWtGOXI0cnFvSmljbmdhZnhFeUpmVzg2RmlMZjB5eVV0TVRZM3dMUjBC?=
 =?utf-8?B?VFJqOEp3T0xHQVFQOG1uSFAzS1ZLYk5yaTE1dmwrNCtEbVBQWVFmaDZYblI1?=
 =?utf-8?B?THJWYVMwcmp5OGQ3YUdZQStGQUJCN0x2U2hRUDFOTUNqNGJzRVpmdTNBdXg2?=
 =?utf-8?B?WTJxVThkbmI3K1VqWnRlcm9ldFpCQTlKN3VUaVdBQzQzSmtVVXcrZjlGQWUx?=
 =?utf-8?B?VEV1cGJmaFNsdGg1Wm55TS9CR2VEVUxWSFJ1R2VVY0RvVVJYS0R4K0FwMUN3?=
 =?utf-8?Q?MZDJwRg6qkM3FomIvlSc5mexM9FcAIW++ri009/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b18f70-3826-4222-e926-08d90026f2a0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:55:53.0743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iC6r7rq7rj7tgSD5nYQONMK30fBMP43BZYAjblo9b+cpAnjdd7BfnWQ5RSfraEjzbO1Zh5A8s5M/qlj4qoRVhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2510
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

