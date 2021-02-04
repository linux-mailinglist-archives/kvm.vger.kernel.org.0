Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9ED30E8A5
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhBDAiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:38:23 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233449AbhBDAiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:38:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ET0NJZoz4O+e6repibqh5OXo8wNILR1K2wKflbTp0YSHz5adTUB+obffZmZ+q/Hcwz3tUhy/r7wKk7kntWQtcJsj1yZj7j6Is57RwTH3IAlpDuMTpyROn9ugxy6b+IhEukJ8Qjg7mmNNIgourElox4vHzjXTKfcPDhjFPxcD0PdcnqYBfGWNawniXuokW23vjFdS3ILn4sHv6Bm/d9eVYgoM3nF28QtfaXWF2SV5+iSyDAtUtac99OhkGyqzH/+l1gPcyYjDL1mbNNXkwEq/1KNh0zADMeTeLrqMyIaWA+6qNES7I3OXMEjPjWue7vImvfghUUjPhZZxLeMZi1Czlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3IzyGcZBeyczru1sGmwVZ0ZnqAlZ+sLlWaV8Us533k=;
 b=hHjOz+vL12DxTPLkxQqC7yMZ9Cb1LD+qIEbg4yLH0omv9LwHI+TCRCeyfMHM2wiwKvv4KDSuwTsmg7wvECsy2X0OCCRIPU3OLBv9JgDF4X1zVIZAHVbDZUOs7J6ZQBkK/C+Rc3Wls56CVWr14aUy/xEiG22pFCeY+0COHIFA44gnjKXtaN/rFcBp45dZZ24fwnl+hPhzfEjqR3YvBew4HvuJhwuydk8RKeoLBG4k/Lpljr7nzQcxeecnYatwy7FUcqxAxydtSx6w0Ycfsrls/WX2KU2tb161XBNJ1+D2eKcKQDZtZbwtX5VLPgHQ2WjLIS1FNK+Vz3vD8Nr+X1rVEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3IzyGcZBeyczru1sGmwVZ0ZnqAlZ+sLlWaV8Us533k=;
 b=DQmxfLkDzmIbjz5CIVHvOg811gL8mRO3MkomFFs3Lpj3sQCqFbPvaLsM/KnyZWPVtERXGIF9g/S4BdCD5vnR6skPbExlHwbl4iGRsn7cm27VABQ72dHdX+473z6IckoxLmZJqmPEl0iWDIhjOE5mkYJqNCCqycctU85IWOIr4ag=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:37:20 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:37:20 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 03/16] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Thu,  4 Feb 2021 00:37:11 +0000
Message-Id: <ad40ddc16426745a3650991fc36ebf5ba285f57d.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:805:ca::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0040.namprd16.prod.outlook.com (2603:10b6:805:ca::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 00:37:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d9587c9-4d7f-4ce7-fb0a-08d8c8a50848
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384933B5EDAEF45DDBA48BD8EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ER5T1/J+Q3OYD2qEvp+Dgeri5rjONmRbbUx/oXHKY/wM2TsBx67AhAaTtJdoO83gtfwoyoR60cGKPqU+uuq5gI03AcbVJ1LKHeE+p9gpShozv4fW29WB9F8x1JxJrLzxv4ehMPtm0lIfSUM/k2ttXQcLhpd0Wz6boYTQ/LaZNj+DsSucfj8529gaapKlQLhxdGTk911j+my64001EKfmbhAJuP7rOiA9Ov6Xv7Bi76ZomoeeFYIuh9lwFoK3M+WVxWTHXhaBwRtoWGtYDhy9vc/Be2DyppyNiPIehBrGbc/aLvozbr15DMUSH65bXOFnfUbsY3HMmDOq/7aiuBoqno58ij4pdvkjPGe/3xPXFxgLae+KG+ULFPHkqhYfR+tl/ka1k4K2S36fFtiE8ZEF/ibuM6k0+fTyZx7usBgw35R8o5wkmYcJNFD2RBu5ZEyH2yfipGjJc6lx9QIEwD28MLY1iWNg756XquBgqvT6JcKP6NAfGkQh1ePcuk48KwkFSmXqLQz6im0ST9TAACRJng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U1lzZ1RiN29sVEVtb1RaR2FDOFNlelZPM2xsc1ZJZkgvYWtUMEtSMzRkV3VT?=
 =?utf-8?B?MFhDc0hqeks1Y0ZKMStpbTBLK0FrOC81aC9KV29lY3gyeGJKaURCMVFGSE5z?=
 =?utf-8?B?QXJZOG1XdkgyMC9taCtkQ3dwcGRxb05URWRCZ2gzcnI3UXZrZExPKzYycVJz?=
 =?utf-8?B?bUdFOFgxTm4wNFppUWhhU0hXb1F5NGdnVkJ3eFBYVWNmb1FZaldjNUtKL3p0?=
 =?utf-8?B?SHp1TmgzUXdGKzhrcURrZ2hDdkFVUHZWc2o4ck9VaVorVTV5YzBDRkw1eVRI?=
 =?utf-8?B?TVZUbmEySFNRc3lqUjJoSzRTSFpyQnpZZmVRb1V4OGFZa3BYK2d6M1YycEhW?=
 =?utf-8?B?c25xUWxEa0FXbWFzZHNsbVZiUUNhbjNXNDJOaGt2VXg4R2NCYmFDa0kvU1Rh?=
 =?utf-8?B?ZHI1dXNoUW9DSHNzV2h0RU9FSzdpNTR6azJpR2JlRys5U0lYOFJINWh5RkQv?=
 =?utf-8?B?NHpWSDJSNFViTEcrSURacFZFVDlrRGNZcFNOSG44MU81U1hERlNzcW1XeWNi?=
 =?utf-8?B?NWNXR2thODlVcTQxSFM4ZFl4U2M2WDU4SEx3Ny92WVZOQUZyOXk0cTRvSnNi?=
 =?utf-8?B?RDVKeWpWQUlKUzlrWUVUQ3hjZkV4QXFjZFk5Q2JERjlHVUdGam5ZK1ByNDdM?=
 =?utf-8?B?UHFwU0M1SElZUTFMMnhGYmpNeHFBcnVnODZVV1h5QVVHU2tsR0g4SFk4V2ho?=
 =?utf-8?B?YXpnV2ZVNzFCVmxVQUtmVFVsY1NqZmdraG52TnRJSDJ3SFArUmVPSURoR2kw?=
 =?utf-8?B?VkJ5dGMvMkNFclhTOFVDOCtoODNPZEtZN01DeHZmejV3djZPaG4vcE51Nzk1?=
 =?utf-8?B?eEJxUW5nbzRnSUhIejFidDNhLytpdnpqYUFhOERUZUZCOVFjWi9NamE2d1pp?=
 =?utf-8?B?dy9MQmdEY1B4Y2p0bGMxa3Y2QXR0WWR6N3hicU5nOE1SRnMxc0xYK0JsaG1x?=
 =?utf-8?B?RGxxRm1tSytpVmhvRVIzKzlhdEp5VmUxU2wyRE1yT0VQVllXejY5YXlZNmF6?=
 =?utf-8?B?WGxyNDY5RzhJREVVWnYvcTZ6N2NTUUZ1c1RVbW1ZYmFXRjFBZ3Y2L1RIWWkz?=
 =?utf-8?B?Z2tpRU13SGo1TDY5YkFWb3hwVjgxNkZJVTN6Ukd0emlYczdiTTlXdHVWQkcw?=
 =?utf-8?B?Y1JMa3FySEpGdXJQcmd6dzUwRkt0T0JaMkZXblF1blE0OG83dzh0ZS93bUw1?=
 =?utf-8?B?ajlHRko2VmR3ZWwxVnA3Tnczc0E0Vmt0NXBwcGkrcUdUb1JxZEM3Uit3L1Z6?=
 =?utf-8?B?MU11YlNaNVVFK1NFRTZpMnNHbEtwQUhLY0tkSEY3bDdKdE53d2MyWTN1UHgw?=
 =?utf-8?B?YlpwWVFINEt0aVFmRFphTVNoeTZFUHdib1pldjJYbFNTUUFnck16blVWN2dW?=
 =?utf-8?B?bHJvQnR0Vk5qY1kwOURZMzBta1dVek5BSEgyWk4wbkpzL05sV3dJTXhHOHd0?=
 =?utf-8?B?N21lRlZ6WGJMWTZUQjdmV0ZLS2ZmeUNFS2ZzYmlVTlhVcTF6NXdUajhiUGpi?=
 =?utf-8?B?Yzc1TjJzNEhzV2l0ZG9Oanh1ZGFBWTFjVllzZmc2UUtQS1pFSGxOOGRrMkVx?=
 =?utf-8?B?WDBGYkpDRXdKQzVBaEZpeXJKWmdJSlc4UkdlWlRPOE9NUmYyaWMxT1dYSHcy?=
 =?utf-8?B?ZTQzR09admtHVHNQYkVzMmJESWhYUlRaNWxDODN4YjBzWmhqb2JMbkFqUFdt?=
 =?utf-8?B?SElTczYxQVVTTndTWDNzYVQ4SW5rNk14ZEJQU3hhdTcvcFI2Y2R4bk1FcVY2?=
 =?utf-8?Q?/JJOmviaBs4bLPl1Eydk0a88D6JMA9nMhzrtZBW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9587c9-4d7f-4ce7-fb0a-08d8c8a50848
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:37:20.8534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+Wh2q7Pyf3bxbS/6mTpNhdu3QEvgayb4wp6RLxaAEuEFppWcSKolm3C+6lljUamv+H++8dIxg6GMTiyIyeaXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 8bed1d801558..0da0c199efa8 100644
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
index 98e46ae1cba3..0d117b1e6491 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1279,6 +1279,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1335,6 +1355,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

