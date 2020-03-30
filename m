Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C881197206
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgC3BfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:35:14 -0400
Received: from mail-eopbgr750057.outbound.protection.outlook.com ([40.107.75.57]:6492
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbgC3BfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:35:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A38CYZqpTL2yhYiZj9PXuEEPoUsTeCgsCuFj820zRTLkMZIe/A/y6P3aRalq0Umk/u5YeBY0uos1sqPx/IWMSsPwmZbC8dq70Es3uw2HGyHP58ebl9eCrKt7+ss2HLbhuppXoFX7F67adQCTSw2LbyJLqMTmoOUdJ9JQ0Dwc3IFUU4/vlIU6J55kfBojAhSspgDVHSdFDA1AMhKNXzK0gteoXu51IVLJG2n5qDFqfMXBjdbg4JaiAIbLASBCW1X8IQkRCtbgwyrExZL+XxOqEQR25ZISuKXuaQrZpGn5P6wWLsw5qtDU0ZFQu4GLZ0RNtjE0AiPXdrNT3gAlJyHboQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjtJwepDN2kGis4bfFaCD9krHPW7ehs/wxeUhcqsEqc=;
 b=COJN+KuMcmWu9W7tX/MDqzE9MU86iM/47Q5vgUI0Uds2GpyVxXmIuD6tWnOpLNbJJfTZV21VW89rSK0Qpitk8mhe8hUS6GQ3coXmEDV2IwTgiVxL9ufoE7TdAICQ+khdGKli+xB5CYoEObUj2ssc8z0l7vRdHvmxXTxC8RrlNsLZZIdMmmgOrTwf+3dnQaSMEz139fqAMjz6M+kDFuSNSIM8Mf7olc5ObdBUIoCoVwnYLLhDRKnsOuhmsjS/QXJRunuAnH9xhYwji0SDGnXfMCnpc7242Sp+MPZrTXXvNVqowgi+6+IBtBrnbeSvynIaprtP0CvNDgEH4eH/q51cCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjtJwepDN2kGis4bfFaCD9krHPW7ehs/wxeUhcqsEqc=;
 b=yAE19gfSUqNRNJWjwLnXuRo5Gv+OvUiceE8AEc0j6CZVf14Yi5RlWB4JpXZeZX7IJgQaMf7wzPMHQTG2TvlzkGdmtTdf7U8Ow5v5GO7GtMhBQSJwvpD6TwgVywe43h+l3q7iF37d6g+5nHcBxlfyKp9BDsIFirpppv47Qp71M4Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:34:38 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:34:38 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 03/14] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Mon, 30 Mar 2020 01:34:29 +0000
Message-Id: <798316bc964cef34d2760a87de0fb6dc4e5d9af3.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:5:177::43) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR02CA0066.namprd02.prod.outlook.com (2603:10b6:5:177::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 01:34:37 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cc15f87-e7fb-42db-f71c-08d7d44a82e0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387643A6EDA183CD87515968ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66574012)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8PIE8DnFmOX9H07WuIReiTARTbvmFQNiiWERzSv66f7Oow9x97PUuK9//rzHhFNo/efUkc3tZtOUVFxgkgwWnhsLp9qFyUxtnoaPR00GUX5U/NaK/lq1dkPzNzlgD4ajPPWEEIDbwPAvJ/C8pm5IbCQPisAOYKp8xC67KZAru04UMaRqwe+k+udvMuj8dNWA/yEF7BAKmxHgK0RnBS03ElNizAXtdBxD8mE0FjTbkP813DW+NH+4KrGwnoWCoqawwSSQAc2qzyr0wDg2oiIKBFNECXQuDAYSK0wyl1f1HvOt/FryYVY5TcJ6a+4Fc2H0Dth43DuHvslijweETehv73QXrDG53IRyE0abQgQwOraj+iQjcMU6BiXXZL7uZOqrV6DHnzzXoLzgJuBWXzrjvkkjvMLntiQ81VSJeLpS7FxLdnnHPyokor2yEUtL86aLKo12ooc19XMJeaqK3CieJ0qbL9dDXcz1LEaEiet0L0DUDyYGXReQ2Dcf20vTMjr
X-MS-Exchange-AntiSpam-MessageData: itskoVnL7hZCAsmhTrO0jeap5q0Je6/Oo3KWkA/QsCPjPKuEzn2/Kmku0doMSi3L7zcSUzfFSZ7YQ4rRNKZOoOVvkjZr8QkbkB720fA24KLgOAo0J0Qc2hVADap/jc2gldvSmMmMePvCF+9rV238gQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc15f87-e7fb-42db-f71c-08d7d44a82e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:34:38.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXeISo38cW7MVc4nM9MVAmO6M7p5FSizOLDSGyML7LtFAAOXv6Yfecdt9aYa8i6trmmLUjLxxgUyS4RlbKqiPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
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

