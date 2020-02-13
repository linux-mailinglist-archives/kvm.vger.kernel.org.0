Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0715B67C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgBMBQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:16:26 -0500
Received: from mail-eopbgr690041.outbound.protection.outlook.com ([40.107.69.41]:40833
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729276AbgBMBQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:16:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Glyrr63PTZuEOXHNWTdT255rD+S4toV/1FUA88Xw0Da2QwXOpjsyPp8YuhAsMLY9oTzmJ5SyGjFqC3RNGrmDtRNf5iEueEIWs6BJYpxYxwKqYeRmbuv0GacCpqiVvFOta81h3duKiff1lc3mSRCk8OQaICS0Y54M4KbtgBQ5ik3ghEsKuds8Mn6qKQzGbQNsVjctvOPuZQZMkdUJX6qny2EDm3diHhILycUsFKNfHCL3gwbpfa6ezN6CeFYKYgh3aQRnVx+cLvSUnDnnz4Njfc0FWKw0I2Wkj1Ga82qxE32GV6EefQpifeiSralWzF/T21h1/kllnWN8fjo7lon2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swqFPurofpMDZYrmVIIjPRTcqalWc2cHXs8EPG4/xeU=;
 b=h6F45IdOTG+MSVEVGMe/Axf9ifenMMNZZxNolHhk1a6NQZIDmfYFSsG7KRSrhrUcwExQgZuF5Mv47ZdB82xyZqXKxhzf8TQc3Z7oy1ioz/sPt3qo2T29zxt1EH4QmeyzHpEwsxLuQ4tFvLbNfoJ8zW/rrdcFJnsnfVxoKq12FhCgwZjJz6fD0nWljXC3z9xADajX/dGQa0KgNDeMQb0Mw8ShoOKMwWSKH7ZBy61fjMErrSOTQ7wbdmHZq6XLhI3Uys1SgQncrpRfG5iHfxHtk/8Zis6fBkhXeVqgOVK8fzToplruQ27HW3WfS8J9gItYIysrcrUobP+8SpP3lmbk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swqFPurofpMDZYrmVIIjPRTcqalWc2cHXs8EPG4/xeU=;
 b=cy26+rZWeQxzKhbqIRFB4CKanB3Qc/cwJ9rsiDdoSPQqWwvx02+Mf257FHtTj2ILLCvHSHicRrSwS2ppZzNKvIpzxoSL3ysLPktgJkRNS827pOljQ50tFLKYJj2WDluuLOEZGYrXsvaQ1u2V+YkpHiVi5kwwH6AVx6MyNEYiV+c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:16:21 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:16:21 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Thu, 13 Feb 2020 01:16:11 +0000
Message-Id: <d6f21be0c775fd51a63565c8944b03b3bf099e0f.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:5:100::45) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR03CA0068.namprd03.prod.outlook.com (2603:10b6:5:100::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 01:16:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bc916cd-a590-4558-c71c-08d7b022562c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366E6A2BE883AF8955C43648E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(66574012)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbonPrQhB3AI6NAjssE/BKyePT6RiPtooWD0xNHV6F7WO/TekM92CgsGRUM8htG7IvdmpE3Ya/Jt+34uUSZPpPc5/zYGXdvraEoltub/AOEKrqO+4JkgUJ2NSaXH6/dgDlFmk9uANTAgHdie2OtRNTI2u/dCCo+h+h1REvml/m9O3vbyEq/ebHvsbxTsfx+l+Uk1icq/xLxZHR25h35YtXc2FOyDm9fYzwSenUkFXjGmwr1rN2hL7+aF+GAGhGkl+3mpjVVNHHug7P4G+8YILWgAQI0DsjrG6/nmtDuUJvswIjtrGGma692fgIl46fY77UFmfuE3hLlkwidCPWxDfBll8LM7q7aKg6JoxcwSjzsZl0/mNqEyInpU/EGx/3MQs6w4Ve8kza5T/R9tnNyyNXyvpk3dxPfvBlx9xLy3CdCVDSHmmo94fGm6WCrhcTU7
X-MS-Exchange-AntiSpam-MessageData: h3UegRnFAMfbOC0XTkiG24Nvu+76EqxcshPhEQmY8lwcrzoAcmHRRO1iUkIjSAkjqHT4Xu0Vx8uMvE2KKdq99hQIU0iSIjusYJo0aoZJnfGq/qt+Vp/kJY4Uwg54M5cdEKniJ/O3v0KkKjSFR4gJ0w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc916cd-a590-4558-c71c-08d7b022562c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:16:21.8675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7OjgE5PqGeZz2F2UxO0Pg9ty5xfy3Hdw6XRmWOl9LqOW2QbFb5Rw1Lev0RuqFjavUjyQxfP5MGjyvfCqumB+zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
 arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 0f1c3860360f..f22f09ad72bd 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -289,6 +289,14 @@ Returns: 0 on success, -negative on error
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
index ae97f774e979..c55c1865f9e0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7387,6 +7387,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -7434,6 +7454,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

