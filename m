Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B9F197460
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgC3GWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:22:07 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:20854
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728955AbgC3GWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:22:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inqAwu50z7Lkp5XzXT7NOZZbSKExPdE4MVWP751FbLFrhNIlA0k73CguA1le+j2P/KoWOcmndgiwAoRAgp5DsUR2cGy9YZs8qLBzd0D9xEmxHg53PFMlj6N+lC+KYTp+5BqvV6pcyqOwqCMyE0BRXEHTCmEE08lubM2btl40QOH05pRt0eDKfODmUTgBJQvvCKuR8Foa3qFSSuraJ51AQfNqXwRTfclh6/zKOC3neGXQGtQUXHUEMT7j8vyrbQUSWMjdPrYYAa3zKS47fT9GNHMriEHsu+f5QUD9aK95Bj7U0TMZaQ6Zp53nur7sH5ZOKQeCjtNs6jWAqvK4xZM2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+0q6Nyh9f1u3yEndkck8hsJTicRQCuicnRxNyF547g=;
 b=ckUyjKZJkpdFDGrjzkzv8PZfJx21BX3M1sPNkQ2cOO7ZtVA+cSIPtemPyOXfUXoa0ly3c38b9q78AOnB5MyGqDF7Z2knjCg0HE7eIsGZjKGDSf469dJpyMYUsPjwq2Yus1g78llk7a9Fw4J3HNANB0bv+mdH4Ac20yoQbl+4kggGHyCXsObmroUQPsa9lslAg4GKmWj2N7fJ80eENMVub1cSqqJoTpxByXxGi/KRh2EdaA2i13QAeLsMKXlp/kq8afYHulGymY4r3cnPOI1eGsZWTF0Xr76vTot9HzjtHuUB3lZTW/rI6apgB7rTKqDB159tlYu4RNiRsZRu5fQSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+0q6Nyh9f1u3yEndkck8hsJTicRQCuicnRxNyF547g=;
 b=zgW9QPGh1TBNLOnkIuszTG9FPJCPtofObPeQFNhq7RSCN3Z9nyXq6C6huh5JqgpMdIFu3L/0CGsOUTSpJUb1xEsR7w8Plf/kn6q4j9jlxNB8Zwu5zKkmmPDYSkjKg0+CvChDJbnAdYHU2KhZa57cHLMpE0laYznc1x1oYuo20kk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:21:45 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:21:45 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 06/14] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Mon, 30 Mar 2020 06:21:36 +0000
Message-Id: <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR19CA0036.namprd19.prod.outlook.com
 (2603:10b6:3:9a::22) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR19CA0036.namprd19.prod.outlook.com (2603:10b6:3:9a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:21:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c2c79b0-e23c-4c1d-cbd7-08d7d4729f0c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692D6653CC001F7E5B28FD28ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(66574012)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtrF3Gd1bslAqfomZJueuZawM4x84uN1HHWPiHqq0mdtUXG3aLrvmP/YrHkfNpCPdHsh3BZEkzAt26V9MTujKm+GGmFALizrieJhJKqEYcbX1iGeVvZ9HRIXuFL7jJCPZiV6j8ME9elgEdEqp4mCaM+5BzN7zQUI6LENh0ySExVl16oBZc49ss7ILHaKGc7s69gEzCyMND9BPxApoJUx+iGf24bXe81bk1sw3n2wJqjQRX0f4eMV0ztju3qLRHt/4fiQg5RTgE1SgwJSY4XKnuhXeCtdGgjOeBfCohsYaD3E069vbXDk7w7weS8vJpqe4GJSatjmABq4fvR9DVE1/4S4u35hL5FLlEfucES27FQ5UdZSQHiWc3rDl/HNV/EQf3VbphYWy4vI8DOaBpd1asXINQkdvqsoysKvDnLRlKQ8uLADxhVlDtYj+47j6KVFcSYnV1/dtXbjSNUez3QZ+j9a54/Vl9kMGHxOvn7cQzs/rJD4vrvROgQ5/It18dr+
X-MS-Exchange-AntiSpam-MessageData: l3yIuSFmbRj+ArExEuqR4bV15lEhuyL+FwYNq1wx4MiSyCtgvM0Uzx8HZ9Z2bp0E6dnPuAcK1lvQ7bzQwNqXM3Nb0arKHyMNCz0LMtKgsC2f42IKSeqF7c8+VUHxofJLj1YBIeDRkZabpNIzr19T6A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c2c79b0-e23c-4c1d-cbd7-08d7d4729f0c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:21:45.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95aQZGKxoH2XArSgoKyA85vOOtpDwUYREWYAXzttInQhvvBErcHaa3Tcx1IzxUuRTpFeWLDIyXAv9rgQv0abig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
 arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
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
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5fc5355536d7..7c2721e18b06 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7573,6 +7573,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -7632,6 +7652,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

