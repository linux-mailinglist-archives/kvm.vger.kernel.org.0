Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634712D35DC
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgLHWGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:06:45 -0500
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:34912
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730486AbgLHWGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:06:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvmzFZp2vVvO7DTSbWAgMde4DOy5jSACGsXF9ZQDgGvAfdjkQ+eJUln4OQxZmYFsBzt5siWKJ3doAzxWQkAeQhwMtbftn31UEsVqzPfOLqMjAF07dTcIzqOUfG/P82MRubd0L++OM3eCgbyzLQEtlkoIxQyk2AMfHCBiP/Ufwe6cYytbgh6lUU5yq/xEWONr8U80qbFnvn9V6cVxxh3l5nDrq2yhTQtnFXE/pDDd/8TvKJI94fW3Pr4asZ3U4etYkw+wMcxz6wDDckEAUzzFHfHtqTAufWtfV/0limQr/kigqeW5qKU/32u2ACHwl9IJtUvW7NV9ZVQcFaCDwsMfzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M75rSIoIjHyp8gjWTs/3Jm6+mwNRo44GL4tGH8ct4lA=;
 b=DEQpy4LrRZIEJyYwLCPkUBz4iwoHNp4jzcuuDq+4CL4DxNInveRmfPbH9WbyzO2JdDXjDpdchV4+1p76AmGx6ugd0smGR67QkG6mIbWsfLdBYqRsHXnt1VmkbuwHxhbsU3EYQoHvAeFQHlz7RRoyDjm+awG36CUVWUN4B19OKOoePSmQNDLiqnOrUkoOCXbanYUcktVojnEoT610vUJKPpcwYZv7Pb0YgO6RXPw4cHE+OMzbCkzCw4F7EuyRGk2t9LVfA5Faa+UZHaC83A0DsMZfr4NV3yLBJs5M4Dzf8lG6USatSzKh2HP9ymRZg+xElLGh1Lv3Yb6YMlQACZyWig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M75rSIoIjHyp8gjWTs/3Jm6+mwNRo44GL4tGH8ct4lA=;
 b=gdfR6GmfRd6U5VJq7ciyQhjGZXm0p6Z9BP2hgOw8lkA9hu9UlksMIKDo+MLHZksJQr/4WqcHhuONpEXuoE8gTqfUfLoa+486lL/pJL4aOMVbVH0Upxp2KsKcHUF2wBIq3Q1wmZ5BgT+utBzs/nbnpCTNhyMfK+o9DtNd4UezhE8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:05:50 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:05:50 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 06/18] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Tue,  8 Dec 2020 22:05:38 +0000
Message-Id: <97f0da36644b54701cb8a85b5d9394585da3a66f.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:610::20)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:610::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Tue, 8 Dec 2020 22:05:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f273f058-e10c-4e9f-c216-08d89bc56c64
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44156D2EE300B493D2E971528ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvfvOQXNvfEoQrW+tK7kW+NQy0mPgZEks7Z8YZmf+lnIBbjSZS+IAFc44whdb1q1MolZzyz6ZZcnJ5efrLGN0Z3rrL/rlp/o2FcM2nqkWtwUhXm6JSa/W4EpTyhnI5p67W+YPb9ojt9LGdmv6yYwQKoefjEp8hIGNdQP6QwbrY1LwEQnVuHOq8ICizzw5byX7cjPaFtiLZ4s5zErkrS+uNjNqilUT/dke73+A1dO634gN0CqCiUsV7oHANu8ioy60dfi54iqwVsVZRHIbxg17KRsBJDsCw1UFtGeIq+FYju1pP63xRrv95e1CZBE7N0oCY29/dGkylaZK4dEB2ZAJz4q0P3L8jSgVDQX1D3butkNR8jSirZ4sX8hyeVT0pds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66574015)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K2VpN252alZrbUVQakFwWlRCYXczcEF0QkpVTjRDVjFsbU1WM0pYVUg2MjdE?=
 =?utf-8?B?RUVUeWgzZUFQVjl4RVQ5YzdDMlowQ25oVTlPS3k1cm1jazlPTlorYTdPUUVF?=
 =?utf-8?B?WkJ6NWk1WFE4K2xFNDdDTVp6VEFnOU1IUmsySzBWVWpSRENqalU1QWJDTVlt?=
 =?utf-8?B?SzJPZ0p3eHk5WkYvVDlXcXcxL0dYc3JBSW1tY0d1M0lpNHBvTG5PcUNKVHg1?=
 =?utf-8?B?SnUzV2tQUC96d2F5VFNIWkNjalZ2Y0pRNE5udUVJVWFVTlAxWWZvVGNxU09p?=
 =?utf-8?B?MHdNUEVoT0I1WHlMSlZEWGRQQWFzZUtkTVNwaHBUWDZldGtveERQL3lmREJI?=
 =?utf-8?B?ZzloWThkTitYRWhzVG95N0NtSEtPZXBqVTMzdXJvazlYMXNvaVJBVUdaMUpx?=
 =?utf-8?B?ZmNVWGpaOWh2ZlcydGxrcXpYQVZHRjFwVHJqN1pLV3BieWtybXpySklLMCt3?=
 =?utf-8?B?SlVsYWtLSzhQSTQ5QitUOG8zVkM0NmphSngvbWNVWnp4THVhWnZTVldDNUhu?=
 =?utf-8?B?dm1lYUZVWnVKZGpoVHorK3l2RGVmQmo4ZndWUDNacVFXRTRWc1NYU1pyYjNL?=
 =?utf-8?B?bmEzbzJKVHpPMG5UM0ZVUTdSdnhEcjBURHFTUGh0a0NlL0VNVG9PUkJzTGJE?=
 =?utf-8?B?bFBHVlhGdkw0Mnh2aEM3QW5wSWNPVFVNVWJBcDZnenUyWmpBQWs3cG45U0Rl?=
 =?utf-8?B?QzErL095T1VCS3VNVFA3cndObWVtZGI1VFVTODdiTDJocmVEK2ZOZjlkejlZ?=
 =?utf-8?B?d2tOakNhZk53eXNYZVhNMUN1bUJlbDFQV285UXhWd3lnV1RnMzRXZk9NaGtV?=
 =?utf-8?B?ZXQ5c3NqT0x6cFZlL04yOG1Tdk9sRG9wS2o1dTN3M1RaYUNjQ1UyV25mUEkx?=
 =?utf-8?B?cGprUFF0YndzcmRna1JIWUdYUmNkTjNBTjNNQWJBUm5oR0h6R0M3aStJRjcx?=
 =?utf-8?B?QkMyVTU1bm1mMndlUVAxeWFkdHgxNDcrODVDdURDQWo5SkpMc1Z4RTNNSnNP?=
 =?utf-8?B?QWtRc2xVcW1OQ0MvNVdzSlpOVVN3Yk9ZK1c0OXBhb1I5WUcyMWQzU0drZlp6?=
 =?utf-8?B?bFgrTXhxZE53MUlBSXB4aHNpUzQrTU5Mcy9rSE02WjNNQ3NsendWbG92K2hE?=
 =?utf-8?B?QndrNndWQ3FEc0Q5VW1jTGJ2SmVsanU5N1ZNSHo2ekVKVEJMK3FodGl2U05v?=
 =?utf-8?B?VGVJam95MUtmcVdzZDArMW5aOXdtNnRJN25ReVpkbjdkRE9odEgvNjUxaUwr?=
 =?utf-8?B?c3hmWDRmc2FSQ2VYak1aeHNpZlQyOUNIWXRGWXB4dis0U2p2RDhJZ2Iwank0?=
 =?utf-8?Q?8EHb0hrYXm/QFvZbClBfUyfv0MsgKO2iVk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:05:50.1560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f273f058-e10c-4e9f-c216-08d89bc56c64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKjgp2+6LTMGroCIAZ1hLx3JMCEIU97RlbH6c7mW4V/QM4gq1Kx0W5vPiUVwxfAJBylYl7neQuFTzg71RRfBpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
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
index 34240c022042..edd98a8de2f8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1341,6 +1341,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1400,6 +1420,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

