Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CA419745E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgC3GVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:21:01 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:18754
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728733AbgC3GVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:21:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iePs4F+/Bi4D3poutB2zASyreQKYwj5M1JMcE6CnmMT7XG1dTpm5TXDQcVL5qan1mBv8m1vLu3mkzpEcw6jE/eXTrzS0Ytoc6K91Xo0ofV+XqD1yPGUAh6CvmWWDQk1YG/myzTzKBrBU1c8myXtYV6TnNyrZfd7zFSzKVsTTQC/aqLXEuLqLOUpCx2WocW+8h+QQ6+2DdPYrj8ZIiBHuQFVob56lHtmRykbxBarTYV5QcLcHA4/h1ObH19AAFrfs4ThSc+F9bHHUxo8sXIPdxO5qs8LFRwNluTGNxfCt2AWKZu7ZHT2vyI5oXOZgBr9EuYSl55pA9aU79yDyw/b+uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjtJwepDN2kGis4bfFaCD9krHPW7ehs/wxeUhcqsEqc=;
 b=OF+3T+VtHYIAlXDNAco9JoeLzJhPn0nT1Bni6tW4petFTuQ6s/iu5nStNQvun7NxW5So3J1anpVo6q5n+L/H7v8La63qcpec38qlfdV46lz9xh3VPMWI6Qn6Od2/1/UknG+b3XEt1H+Tv+ox7VTaEgF3GgbJTQPCLdieUtxxj2NUyBwK9WLZIrrLQm3mTirEsUw6jGD/fqho1D7kupLNe30yIkCCek0rQGdGxdZwTipyJQC4PXOk31XNi8G2b9hOJCwtCMmCnNWwetQhrG4zJiOBT6fqZ624oyg2oZLoq7C4idBiu+womeEyZdJMzIQij0zoQObKI1kpyAw00RC/0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjtJwepDN2kGis4bfFaCD9krHPW7ehs/wxeUhcqsEqc=;
 b=x0LRs2ANo6432ZaxrXPCQ8GBq/0ueWvExrwW5QB+TNj8/Ai3RGwyy1Bher36Hk2npyCPnHk3WqXR3/uPWBpcfV/nsz/o2inF/ZgF6WIOq0xaegfmv1iw5UuRGHiMalFr96wuFZ4yzTH0rUWlUZdSdn63qqaQCY/TvylQ4UUm/e4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:20:58 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:20:58 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 03/14] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Mon, 30 Mar 2020 06:20:49 +0000
Message-Id: <798316bc964cef34d2760a87de0fb6dc4e5d9af3.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0069.namprd16.prod.outlook.com
 (2603:10b6:805:ca::46) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0069.namprd16.prod.outlook.com (2603:10b6:805:ca::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:20:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e1f9c27-610c-4e6b-bc76-08d7d47282f2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692179807310CAB9B1EE0288ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(16526019)(186003)(26005)(5660300002)(6666004)(8936002)(6486002)(4326008)(2906002)(36756003)(7416002)(316002)(66946007)(66476007)(86362001)(66556008)(66574012)(8676002)(7696005)(81156014)(6916009)(2616005)(956004)(81166006)(52116002)(478600001)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhWA1uzMd9C/F5KDXy1DM8fj+o7Dj5zlcRxtmrxzf+OhRjQh2AdSkJwEyHC6kJpCaDA+KeD60NEXRGOI6lXPctfHa2pAWsJ7SCXlXEAtpL9bsi0X985Ap3dHpupGtM30fNkajRdGYOyWraSYQCp0Uq9ug+uow+yX4kuHoFUAtjEKaJncv8eiN87UQcGsfKLhS74qFkHx2D/V56kSEQosNREKkvRuAaXmZgW1Ow98NTZ1OWvze/EG4py+Bh5X/bXV6dniha6WM3hlFA0QN7Spe99u5eUtYIvfI6FFqeAexvIwssgZ7pfn7+gKb5Fj9nVe6DXkSsoXRo51T2IBZYKP8DFkJJ/KhneSPW7FpKX/X2kLjBmmtEuT9YElvJE5lwsEMC/XVRxpPEGlaw863Lorr5K4yXyEOHc9adJQ1jFZ0IWzZwYubp3sCJe2M2pwICMz7GJTtSj/u51tkhgCSKNF6o3bpIdqrMbJOEalA9iHzcLXw6HO1CMWSO9DonRa2rlT
X-MS-Exchange-AntiSpam-MessageData: LSlTsPADdwJb3wWBn26g6lWUSsr4N3F1SDE2/hkWisPrBC+Wk/xutR5SbNOoZAFR0DFvFWmjfchIWaxez99cBNe37NnQAoFWf9y0f0I0rf+83XOtmpRdtxSV3MZ/p6Lhwc+gZPUQ/uJDPPWidBr4+Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1f9c27-610c-4e6b-bc76-08d7d47282f2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:20:58.5940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfdAZ+tFyQO+EpzarOIIQeN3ZifB0fT7/ynOxaco6FSITftzzAzEFByWgVsA+wYkhzwoVimq3pE5InbgxCMDKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The command is used to finailize the encryption context created with
KVM_SEV_SEND_START command.

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
 arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index f46817ef7019..a45dcb5f8687 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -314,6 +314,14 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+12. KVM_SEV_SEND_FINISH
+------------------------
+
+After completion of the migration flow, the KVM_SEV_SEND_FINISH command can be
+issued by the hypervisor to delete the encryption context.
+
+Returns: 0 on success, -negative on error
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8561c47cc4f9..71a4cb3b817d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7399,6 +7399,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_finish *data;
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
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, data, &argp->error);
+
+	kfree(data);
+	return ret;
+}
+
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7449,6 +7469,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_UPDATE_DATA:
 		r = sev_send_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_FINISH:
+		r = sev_send_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.17.1

