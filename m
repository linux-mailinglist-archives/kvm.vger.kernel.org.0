Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8109C1BF32C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgD3Imw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:42:52 -0400
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:1515
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbgD3Imv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:42:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBr5YAaD7g1RjajA9lqjCd1tNQPGfD9uyXE9ah//mPNt2bAHyQvp5ZV1//oO7bLqyYLrGMzI6Cxz5ZnHFwadwh8rFGN+vuiMoiFJaFlUZMXvLVz7uMly/+Zi/SD6cgK2fdC+2lV+8E9opa/u/OjIAxCImkCF9hTWS7HQuFCO26ymUH5O6c6mbW48cb8XSiRmR5KQVlt0bsK6HjQc7bE3LA91/hpLEVwEKjcckTjIZlnQauptVdhvZReH3D5VegedhdQ6H1CT28IK9g9rsfXRtwd5e6uUSzXrbFsDSJQEG7f6JTBKivLaUnu1YL1ogY+Sde3LtOW9u0mLCVHVyocqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N433244vsAX8No2Y65AniCLT2vuoX/pv1hHiEXKxOaE=;
 b=MUharnlm/2lQ0wRK32gQHLyOaBNuiQ2NAR9nCyfianHdpcwQb7K0TvpdJA3t7Mm8g4lUxv05Ii0SyYsSWFUGrO1+Iv1w3ZxWTa/vyLLMQPLD0GTN6CQa9EGvKuWoEaElWKYIPLGAtPFGh32IUW5t1aqn5LKsgSvcJK+9dqIkTlmCYD7PDwdxUCoYY2piCG9S2QX4U1uQJ86AjWv+3dhKN2FVcNxwrrsmpeRZl35eVSm5+mc+QWCaKYi/NClCVGxU00VtIc1hP8Z8382i/KSI5vbsgXdvuw5rhsRiDLrhk5gHfnXbEDfcUjldgI6bnQEuBNixmRwHu88n3VzSKus0zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N433244vsAX8No2Y65AniCLT2vuoX/pv1hHiEXKxOaE=;
 b=bzXcHiDqio1/GwykzrqReDWfLfISEdKUSXocqBbYlp1IpIXJQYbdRR6nQ07V9ZOuut8fGZ5wfoqdQ7lqi+7WuQjo+WfirBdS8K2af05xzi99fWSU2687ugJ8cEIvaJcXpoWfIYLd2LOwRYqWLnufTkxRhrLUHFArNwQ0KYYqLAw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:42:47 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:42:47 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 06/18] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Thu, 30 Apr 2020 08:42:37 +0000
Message-Id: <01ba3a317e54756593e54b7029e7df846c33d3e4.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:5:74::47) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR07CA0070.namprd07.prod.outlook.com (2603:10b6:5:74::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:42:46 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d12fdb8-b1d6-43e0-26f7-08d7ece27515
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:|DM5PR12MB1194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB119463ECFBB70D0D39FC77328EAA0@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(4326008)(6486002)(6916009)(66574012)(66476007)(66946007)(52116002)(186003)(36756003)(7696005)(6666004)(316002)(5660300002)(26005)(86362001)(2906002)(8676002)(478600001)(66556008)(8936002)(956004)(2616005)(7416002)(16526019)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tA3kvit04lZAHCS1NTFTjMFDP0D9iqJ3OFcR6Tq1CuNwGIAMxVwAmF86Bdn50RtAgbWil0O+G6aKh3DYZWBAF55wWBNPrR/NNIdfabuBsJT5b1xaT/umCdPMRL1cP5dWmIzPi5WwNfKNokivQEphLgD1kAbzPoXCfno4t3ogEPka2pFUphRFtRyH/2KPwP1/N/4+GCn6eid3lFLAQJZdHXX+/JiZJEU/VWuchTev4RMhxMRipySvRvhorxpIP5OEksa5F6koFGPCr1WXBVo4YofqVmre/1RNui+hnDKfUN9n7ghgp6TC2mmCAUXxs7ptCe4V/z8ZHwZ4iCqK+R2j4OFYctPxmLcZlyIx0lDN/x23yooKI5cJoxWZP/nz8sHQr0p6734dew3WLnpztSgSNZBCMe+2UY3b7NKW04qM5FAio0FUAqcQe+yGhTp1FmZFHntTs35gVsodw+ED8HkVeq3TsOJU/3+w6olRoEyd97TiNuMoQtc2sRnLSV6kU3/f
X-MS-Exchange-AntiSpam-MessageData: OHAUYs7EsmCHGXUDOs97qMVIpdF0hxutYAnHG9hnwbbxMd2tMMhUJxaSE69CLpfIHJ+OV98rzwH9th4uQx1hjQeLUCO+swW5vMxHzuLa7XqNQegj02N4nx3vv02dGPC6kriZnMP/7f9AnrWh+P0jgbyYGROhHFwDo3MfXtxLWMsGSghMQpKDnDdpVPD7h8bOZZxKDut9Yvsxx20bVc5PIx/f09XGM/cqLv9dmlcuCG+Ow7qZuTTDngoYyA1r2Sw691HKSOi3aaowyCM90Praces6ddICdtb9Br0hG7WLu/ZfrxnkKsUhe2ozaGypZWdmAp+y8tN1kRjZQse3i/fv7HuvbK2bcr7y1Ykw0q+u8wIoeK0mpIHiY2zgpwgsb+JvqA88lO77tskLi/usGNtXnp/kq2DlpPMlBAiSRTps5yEdz3TFfYSlpfOONSIe4d3rL8LLqwhPn0u7ds7Y7f1cg8CnAn3r312do9okrMvmiFooVD0OEQ4lFw7sWnH5N2XkVA464fTHs/OQIkaGkN9d2NM7Yf9qwmrnTaqqWu41zsx2YQpUXvfsRIHAE6ksuDQ2GJEEu7L6wDlyPp/DzXI0Ap3lZo6r38jk3zDcTeNvW0iXTZcxXporxJDDWxpfHRsabUl/X04F2ueHEB4HJDJ5qYw119AhsgWoZe1D4nz0KxxY5qRrsXFD+FFboBE/zobhcxBnfl5rB9lBHuEua6ZDBJw4TDKZ8lQ4Y0xIVd3ue6CxQMgvZYDfL4hdSi9exNABXCB/XzpFm5W9rIA9FhpYIzYWnid7p908/vOstgOQEaw=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d12fdb8-b1d6-43e0-26f7-08d7ece27515
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:42:46.9468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwZkRvtYf7txNTRxcoRpH3KU2ps1TVlU+ckxe3Aam2907SrjPT992BGwlSzAoHG689iNAG5SBmCXNR4Rp5EA7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

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
index 554aa33a99cc..93cd95d9a6c0 100644
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
index d5dfd0da53b9..1f9181e37ef0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1327,6 +1327,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1386,6 +1406,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

