Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D5415B683
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgBMBRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:17:11 -0500
Received: from mail-eopbgr690049.outbound.protection.outlook.com ([40.107.69.49]:47846
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729185AbgBMBRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:17:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxKasMmEYdX7XTpZb0P3NufS1sODA31uYLuyibp2lfRpPyMw6ELwVTCtubi2eBjTHTF4auMcXEVixIP551PSdYZWQPcoGlHrPNrO6EdibEiYxAOYm+VHyiN+KFa8zui9j+vgezNmU6bSmIMYigT1Y3zHTEEPBoeA9Og2HbSfdb1mlUxDcsZFPkzzEtz8+75dU2NVRLbEKK3gkgjl/ByCSt2vo7rzUEhsw5YOegcTf6E0ICh0qHcnnOAv1t0bGIPkInl+qp/hwdcXM/dI9Fz8bSWUaFIDRW0ghPVSIzhUkr5yiXH+I1oepBsRkwQR/8N4xY/K4SaRi5pcDJkDTbP5vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLGxKasy2SOaySnf14fAj6lUB58iq+T7ZQDgXfxzQtU=;
 b=a2Tr9wqwu4Y5k0HfjCE5cD36UqpYyP0MiXGOSdYfoxO+xe05fmqvmFza7JmBuFGQyQrOodNzPTSev1DLUk7Qj50QcTiNPM7mbqbqZttfe8fxfOiKqeraXRZxSYDywE+UYKwv9An82yV4FYWmUudKFDZ/I1sdqUTbWIJVBiPLox6NjEodY93TaMG814d4479d8x83GOmO2et5HTey0Me2esUjqJLMPBGpEyy6SxcOvbW3WjTrr68x1IQAooUHTEVaS3HzBeXBPtwDEYCu7kfXLECjhzl+PevQpR45nUT3vZ4PTX5M9myjmzgL86nmN5D9ZbtoP1Csk5wdrR5bTBmujQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLGxKasy2SOaySnf14fAj6lUB58iq+T7ZQDgXfxzQtU=;
 b=n1GeDOCzPE5ZbpznVdJwFTYEn7+s6rWC/dkXxxioNLLbKrE/mvDFI1XF9ACrxkkte9AZ4QQvGdQTUnvHUzrirWL8JCm1A6q96ZMu3Tf4CPZn8P0QSy2LDsMdcRzU9ibVPmH8cbVcqDoZTitdkWiDXw3+U0hrV42PgUU0ntbxM+4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:17:08 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:17:08 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Thu, 13 Feb 2020 01:16:59 +0000
Message-Id: <de1dc9cd9b01f9384a703e1d85b6631c669558eb.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:5:74::22) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR07CA0045.namprd07.prod.outlook.com (2603:10b6:5:74::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 01:17:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4521a4dc-75f3-4619-d507-08d7b02271d8
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23660037B32E2E5E106227F88E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(66574012)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwK2ebjaCpt1kV7hIOK+l3dSti4MHGYHHpcDoaJV2rl3smpvx/cTZm1dv6ySt62D1+wHMfJqDBlm2I0323lYmynffhe72i68gwN7NxxrDkCqReudFTKMTkf2pKfVxI4dSiHKaFdWwFpo1AjLsxV3LvOM4Hij1fpCt/Gc1IRhU6oXLUi1WtL5cPncNZBSP1B1cb8xfLCfNSqVZ5EFT+jNtAUBsVN5IZAjaOOMYGUZk+fYaOuFNi6rMFxyZWjqMbvgfr/MkTmPls6Aji9b7PqYFQ9DPCdcbhDsHa9otOB886HCt34rSHRqXJxN4jVowm5VGGVZ1PuohDDI1UNmGbTx7yJfDoCrTZqElK3kpQs6VTUytbxuTK1Ui5XVEST6aregyOmFmtRPW0qCEw1iVnl2n+ClCcMg+eAtUFzw1UWxS42gBAdRbmMuwWKfh7EHVxDm
X-MS-Exchange-AntiSpam-MessageData: JKESBtvcfmty/894+v+jMlPTTuzILMF8ep+vHtYqgDSvIcHW5CD4of+Bu6pPQPsgiXJjmPEu8GkHnE7zpkXkgfKB0l7JGNpdCobymffGFyoodu9DZCXZ03PpLtbTKThs81f8CTAmbzWW9kpVftcisw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4521a4dc-75f3-4619-d507-08d7b02271d8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:17:08.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3A2xj6J1Sl3wXUfI6EBcw1JkC+wOmZDXnMBVV5PzAmi9odKkjiPoNvneJPJCeznyLK8hEZJd4diRz99PInQtnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
 arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 52fca9e258dc..4dbcb22bcd55 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -350,6 +350,14 @@ Returns: 0 on success, -negative on error
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
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 907c59ca74ad..d86b02bece3a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7561,6 +7561,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7617,6 +7637,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

