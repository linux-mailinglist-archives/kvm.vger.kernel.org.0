Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30A41C62C7
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgEEVP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:15:26 -0400
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:25025
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728076AbgEEVPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:15:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGPoFympT+uksyyj2qGAgPMLtXInZiWUjd3kfINyUxQYULkzlqasel9wf4IAWwhoyEHcvcSyQJyGEIlR3akJOY03y7XJ4/2S4M3w2he8BeODLU74W31ev3ItdtQuLK4Cz0lVEGgs0ajKvVtFhow17167HTmnvzdkr2WrrkFz7BDh28dIAhNMqBuDCr/xbBNxmdadNEi+ks55cSCberio0nSNXVmmw4cYrtrQ4kxH4+01uNVVEyQIQkJ+iRjvSp7/s4mpc5HQYAqaCCydv5XaKNDjK4sESfvgj1GmVGSglLsfEzDTMs30fLClrtOh0NzT6Y+L3wZgxpcfwXXLPGjHcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lBY6/QnX5N877zCGUMQUdYeLw0dYdUpoeLZC46wsdU=;
 b=noVKW7W7aFGYT/EK2FxwYVgOiKF9k2LM193fGhg6U6+6vB1VgqkhsIui3RcB9ZLiEkWpK4KVj/y1fS0Pss/liNAqLQI19cwFirvXwl8wrTaXWtfmyFvdItQLKajisdC85+N0AfT9HOpMZa9bgnKgZn4gGqUwLHjO2w/jwvlkpWprxPboWM567v0mAf4CbeeSo4XQFV32CPj8Hi0kUB0mvbqtRZJkc6g2AYgm6Njf52fUjVt/2XbaXscl/lJgqMFAgXAkWjkYjzL88EWfBOXhNp7GmVoN6suNhl3nF2TBizFVzZ4vzxRWECWA8o/ChVF9nV1vkbh1TwYvg3ugp5lUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lBY6/QnX5N877zCGUMQUdYeLw0dYdUpoeLZC46wsdU=;
 b=FieeBJViOPn8NNELmoE8Z7WqP0fsF9c77wksmzAZKOheY1+iX8JUIGcb0OmVIop/VyP04tmCg8EGGq+qtwMwFt9tMF69+tDsY6GL3kTGbsU2Y0jkvwUEflWNZLyrqxdUPpZhr2ic9zlr78eeTqy2AsEc31N+78il1f3SaqtkpMU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:15:22 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:15:21 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 03/18] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Tue,  5 May 2020 21:15:11 +0000
Message-Id: <3ad971e9977700140d9092259d5326caab986f1f.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0055.namprd02.prod.outlook.com
 (2603:10b6:803:20::17) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0055.namprd02.prod.outlook.com (2603:10b6:803:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 21:15:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fa68eb36-42bd-4972-d958-08d7f1396b8c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25181C344A113C30B49FE4BF8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRwjTPJi3DdB2p60wmXcYQMmVUbVgzWw4w/Pdxe25zLBXH8sievXAL+x/jAEDM5CFdPxaQcdTDHMb6JnFiWEhSoJD7Gmyq5pDp6FU0mfv0lixF/Apnv54aw7+pbVDxAJErKkZyxYj/06LtbtxBDdDP5w8lG/h2cgDz7mbJTB3bsr8neMZ6xriUIUTtYe+do0KYhiXCFYNFWN7dtVBIOSf6Jg60YQN98aSy9yDtmzYamQJfqHnOfU5BXIzCANhGRhozN9xy6WpX72B4yjLrFswH5vC7XHwqqMnf+To7O2mKz1ZFsCGY6LScDluHKqz47+KGqEJUChoFjGKT/sLhFMw/L+DwLHOZSjDl9X5XhSzEd/v6MILTEL0hvw05aPqUF/nRwRguj3+vmMdfEGLESJxURe401AHZJ0psicWz4ym2rnL60KhqiStA0nVxjDREDOsx3aPmN8c2xdvfXDg86a2dt3XMMDs02dgtalXYwlOqRxvpNBpyPSdjHZinN75SWu/q7mr/uBEuMvMwKUiEOW+Kq4ArMsFH8IgNHGOy4MLfwTzPn2uRLTJDB8EnGkZM75
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4M0e0IcDAbHu7OLgI5IZLBaSE4SNEFwAeOFWobFw2vPdaOh490Fm6jXQfTOjn+uPTlJzkmoSAaPvt+VCEbGc/b1hmUPtyUAgYr9n7FqcZT8eRsc0moGzExl1MD28GT7ysvh4Ur4pCOJVuJP8HASdn4bnx4KC84S5PdyosvFGxKkFIW8qebZYqnQNLLpnzfANLguurfJLey//XYQMXS9klXhkvrNCX2wENVaUiK4Y4AV6X6VVDVqsXE9EZHB1bNN0jUiTACpFvH7MBg1++3Zd0EAnxjs7RMTxeFIpmpWdMP5xouxtzfIjBc6Ppjac8sDnbQsOAnZcDANGXfdfhj2JcuoPoJBmdVCWYh3VTbhKr7O7Q/RB1tjb81ZQsC3HVsBkmfzJDj0pHaz/t6z/ok0Yy+sGaq/BzeDq47046kWVl1oeNOM8Q1H9GG9YdATCRNYlfjXtqXqDvJJ+rgkdY9exD3Y/c1Z+T4iK2LjkOW4hoZEgT56hNl6Sorbl/fHBFJ9yH4XGSgc97Yc7BErwR6ddb6YTiAyBMxPCqcYd30Yv7zEq5BM3IWp98gYGsypaEAKFMMO0A5kHHPtBnB9nKWwNFPDbLpqavUMS8H6Uq+TzMVj4Q02gywL9uBwpaAjdA6Hu+OcPjdPBlGuEC6kJh9S2UkhXROQrK/3SbGf/uQPzS3cBHOlmS2iEAXFOJQ9jBbcgrnfuyrx5j9QvDRJtQ8qpTC/WCpf2Vyr2TdYX6/Ke8DL9OdAIskQ13N+YtBxSQXtFljgafbervKoJCp9VOgPKkr3q3yv7mz/1YzOcuNhtqCs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa68eb36-42bd-4972-d958-08d7f1396b8c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:15:21.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kpiwRjgQumL0cFrworTVeUYa8Z1JmxDXmKYUhGqP93myx23JrlU8TSZ/eQPQl+RfTu2hs6S0wPGemqJ8idEzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index d0dfa5b54e4f..93884ec8918e 100644
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
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7031b660f64d..4d3031c9fdcf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1153,6 +1153,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1203,6 +1223,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

