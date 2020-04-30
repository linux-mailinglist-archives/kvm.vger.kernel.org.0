Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187D21BF31E
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgD3IlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:41:25 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:52736
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726842AbgD3IlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:41:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdtL6/Z3+z8SLhgE3x/zNfXnpvUjpovup4mdy2KyIzra85xUTw/ix7OX9hYxxfthbioUfrEx7sKQSEJBesx2VhP5AI/2AeWt9m0gJkyEAZC0TDMdpL2pdQ0oBiQMhia06FMiKofTyrWjIJ4dm+KQqJXeySs5KdfbqcJTMjeg3+lgFvcnrHoqXNFgwaOhsoFhplyLlfFAbbhRjvAdNhXwPnL28TiqghE4oh6Q3nHftCRwJoj6iZUR61ILOSbiJRYtT3ydNai3wqiMnamQ+zOsdXTd6c9yLLWjYnOVKLpmWHmj9vFQQ4+HPr8048st6O+szsF4g2ohnISVnx9ImSLvFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t1u0Odkf4Ry/swhE1/sGgWCpzmGYMaFxWHHKqwhBe8=;
 b=bpiRD7WK7CLLkEmferddpOxj8z+YnpJ4azVPf8Qr1mJwS/zNMEuaV/vGpUhQ+mo8A1LY8BZDy2KowoIFXPzF0rS7P6pvzWxlLECzaeJSDD0Gp7itGy8fIqm6eUrSzxtW7uVcz3FQhqzTvBcMFSS5m+ApQXYPWWfSaOKoyMPGWDkURiHhONmuaMjdgzXsDPeqxgr+EAME/FpjRgrB4QEIgr/1bnZspfNxZ2nY3DrXWHHO0TXGIC3Otdly0MU+YYmWVFxuL2dqDz0b0I50TpBhMGjbe6YfdxtDqjCqalNS2aQ5NWoSxEUlWQpjfSDg7J0Q5/0lT6AYyyYSgKcW5f1uTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t1u0Odkf4Ry/swhE1/sGgWCpzmGYMaFxWHHKqwhBe8=;
 b=yLk39r6xoCNCwGB96QgtZM4gDiGkFNRWjCYMh/yYW/hCZEzjlEbno3Vg2SYq+17fd9NplErf+Icjg5C+YwWjZjyG44L3Y4e6mq9BuJo8AYjMJARbPgfsn4Kf03oJSqsaxRgZNx1PMLLopW2IA5GxO/NCLqJexcPXS4J+t5u+UN8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:41:17 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:41:17 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 03/18] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Thu, 30 Apr 2020 08:41:08 +0000
Message-Id: <c0cd07661be8c0ce6f395a386401289a0f362765.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR19CA0034.namprd19.prod.outlook.com
 (2603:10b6:3:9a::20) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR19CA0034.namprd19.prod.outlook.com (2603:10b6:3:9a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:41:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed154eca-ac80-4ba2-67bf-08d7ece23ff4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:|DM5PR12MB1194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB119455CB1A30BB9E8D6BE5B38EAA0@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(4326008)(6486002)(6916009)(66574012)(66476007)(66946007)(52116002)(186003)(36756003)(7696005)(6666004)(316002)(5660300002)(26005)(86362001)(2906002)(8676002)(478600001)(66556008)(8936002)(956004)(2616005)(7416002)(16526019)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qb8o12gaF4sLWBNilRvD/4t0H6ZCEQg9rXZL/C6mfp0PuNMbJforTcPsiuWpnqoUSGkEbjxQrLtSOia9etD9jGkjql9UbRPVEFjaGe7S7l9k5Qm48U2zk0XbemXLODViwpKIsX/0js0VkyZH3GFsYxAeyjBM6v0KvFB0GrEgoL8JrCFxZNoSAx3etO3wU5FJZEys0YQTTMjz2utuxf8ddySaJFhojH9xiISQOaQKp4D8WpxtdzHMPnnMEo3hTXj+wNmTKClGDcEzcu2Yvd5rjedjsvt64s+SHyktbICD6gTe2xKZr0AK4SGmChlXI5jXYx2oaWhlIovWwjdVzU9IPidvBgThS0Cq4jC9rEgLVM0yR4mvp+7BOvJl7IOm0lMS9t436JROu3gH6TV4HATvZhAtEKKl4uBRSy7Ty9P51vsL1To45oFMwJo+hIbV9yzb6tGA/U77tYJplPUSCEfpSiPHaHQrUmK8K9HFWFtSs6favOXnQILAUCJOIpln63lk
X-MS-Exchange-AntiSpam-MessageData: 0ejhoAqzrONz+O7HRbNBgFCPhbX35cSpnVPZeVYaFMmezdzqb2IOEHaCkPZXTK1aA3OjdVJv2GA3cK1s8eCuZYeZejnn4FXrcppiblb1Psswep2ljMJk2winNF2gntJT4927ekCtb7VinnNx+aLoyhLo837OnttmM+3wmwHPoRaC9sZSVcYjvQmheZcl8OY8kJBLMxh6eGfkIa2yOn24SuEs34AyJQcT88w/+P0vbrk1I6zngYoThijSSH04Jg4C8JYq18WnyVEFGX8rw4rLJs7ztUHBCIMMr0vgzbl3jCk1e5koGea6V5rTxBI4+pUTmTDzp5oCMIM8If/oMXNZ2DoCkmCB4houht8/v9wRdUSKjgjHf9bZ3I/iptucKn6gjYlmQVeDoufWE5D3z9tSUtpvDkymJRnfU0PsQAZgbwaxU8IPqh8e7EbGPj6RSblFfHpi2aRG0TY+RM0F61cAg9Es1sYhRAK0gZYuM2qpEC7vR93COSXdenEFOVDSLHoo81ZWlv3gKKurx+TmtrnWuTBy6vkTzK3IBAA6O++YyK09SKmf6lC2r31OTfRAbVw7mXnR6WXd+oFNTC45pUgd58p+aSxz4q8aURPuYnNFL7/sZ8GXHnnb4w4Mx2Z/9HhQbIpKRAMMytwCor7h7v8wELNQYIZodzVnkXsB61sAWzMnvRzsxF2p9R9ZMIEjfICgQNWvFXI6ZAP0uk2LaXpWWU2BGHY43RoubueMUI0Tk9g6zOpaI8wrrCvv81oED6CHd2+Mg56zb3CwCPluH5WrAyMg1CTUufTwYPsSESOc0/4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed154eca-ac80-4ba2-67bf-08d7ece23ff4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:41:17.8229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFRWFQNujn2TIA+OK45hEjNMrS2v6iz+PsrFSD4e6XKOIrzz4ZFNGv3rNKBXVCMXfauXQe58dZ/zHtaw76qXHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
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
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0c92c16505ab..81d661706d31 100644
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

