Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD45D2D35D4
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgLHWFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:05:39 -0500
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:11169
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730829AbgLHWFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:05:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VO43tqK5QbWB9FToARROAOiVTyQW0oBB2L288J8VJQRUplqt0YbmYwK4B8QDNTjN4dH7kE5S6wTm+eSIEZdLdFbJ4pb2s+bmd1Cd2F+aYyHFWFIdeyQfBtAmlZQ4ugE5sdWATgF/8Fneq30X8gWBQxCURitxjuom2UY551ukMPheu9+sjBkeAOlbH13Fwyh5CWyXurgP89n1cTefz7Ulu9q9caCBDTnnQzna3EwvqZ4eF+cFmzyJvV1oLFnJrNza/JveVBvizv3xhJYi3FRVV3yXin6xMvLhOGd4y49H88dR2jv/AqAxdHoy+2MJ6LzaDdqERaAqbWU5A/H/S4VPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmg4NnjGtFHeBFDkCxpthshagXkYd/DC/lMiLNF3pjY=;
 b=PAxVWfFvlW1Uy4Ofdn38izcoqYgj8BuF5hlIUi3kXDv/ZU4K23GwdTHUdFSWRWYc18nAMBjubCotZUBJDO8JKc/GQfo8b/q1TrPS565rwPAFFNTxnBNQcsk4ldOONW9+8TM7VXTAfyNuuKRO8uKpF3fAYvpCnuyQgjrl+MhUsAUoqNl0LFWH651HMTKxgjj5Ys2/t84Y8bckXzqPfPuTeqLE80STcetdZkIwDLSLN1XqhttfwJhGI7i+0YUJ65sBZ6TODpl30scIocw/JUBCtRC+sB9YiqYO+B0TIJhKZy0LqDnCbo7mNHuLZemLug+bxFhhLBseWPauOazAutM4qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmg4NnjGtFHeBFDkCxpthshagXkYd/DC/lMiLNF3pjY=;
 b=B3OJNI+NBPzpt6alFCSj8E5Pa7m+w7JQOmVEjcHEXqOq7KRRgIzey4m0AfcOwREPQBFx9XjYSF86AJIGtuqvvY/VnGSeGNYJRko5upk3MuPVa5EHmCYw7417fuHx1WXgfPOfkFDXPgG+AwTsFvtgEJUMqj8nswn8pykY76gxlUI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:04:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:04:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 03/18] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Tue,  8 Dec 2020 22:04:28 +0000
Message-Id: <c868af4b0f4ab4e5797c31a0fbb117ddb6c2f6dd.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:610:4d::36) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:610:4d::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 22:04:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b53cf4d7-3deb-4377-13fa-08d89bc5423d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415A3D4A0550A0091B6879B8ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zCZn/JCcqpQXnBUVQERWOt3B2ZgtKyAeadO5jgMzlBFJpQOhP7X4L7722+jMjo5gulgBssrDENlP4X+9wui4A3NYeOqYm+q/AY9H6A47j6YzswS/LfoNGgF5hinz9lP/eKlsT7VDELVTyrqE70JpNUb7TYFNG3Jn0sLFDzcj6QnIqsmFuoZkrnp+EtWvz1BpNQ0qHpNFz27DKJbuBhP+dsS27IKdXrpg+RYG7bSezqC2uAZuPTl856c8FhxMUl9m6opaVp6kEp6/QkRQD6zO4kYoxKQhxr4TFVzbLwiEu5mLm3M1cAN9ITTwU761bA+HnlalxoEeKerORm7Chvnz1pJpXXj1kO3VemyUXEKAKQ23cRLhpNJ8iCFe94PxR3iD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66574015)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1VVMnVYYk5vWmU3bEx2M21LblRnMkIzN01sV0hzRHA3MklONXBaU0tSZ1A1?=
 =?utf-8?B?UEhZMGJKUE5HUHc2Q2l1SlhUektYVUpjNUhnb3BsWmpsY3k0TzQ4UGFDeEx2?=
 =?utf-8?B?TWVkZms0bHBuSUl2clpROU5wTk1YbUtsejR0eGxnY0hLNldPV2ZQSHpDTy93?=
 =?utf-8?B?NWx3MTIyNXZPUFlUTElWU3pXRmcwb3lxaGNCRmZZck1oMEtSa3lDNDBFc3kx?=
 =?utf-8?B?TytDcTArRis0U2tUU3B6U3NsdmFEVHdmRktndG1LRzJnQ1NXRFo5bEpiLzZI?=
 =?utf-8?B?RUFGd3BrMWtZV2hsejNYTHppakVOb3o1NjhzSFJISmQreWx5ZW9kUjcrOXZR?=
 =?utf-8?B?YmRGQjhVMWg5eUZJQ2pZb0g5eEFQdUs1TmtUQ1YreFZWMlV4TU0ybXdtYUNI?=
 =?utf-8?B?bWFybEtkUFloRUVUSXhrQStOb2xXSWxXcFhDamorYnF3dnlMMmlab1BKMXU3?=
 =?utf-8?B?K0s2L0dJUzEwT0J5UDY1T251TWU4dS9PUG5rWGF3dzBFZ1dtRTVYR1JMWi9D?=
 =?utf-8?B?cHdpeUFPUTJiVUdONDJOYjJ6YlZQRFE0Q2ZmNlBBVHk5WXR1R0RXT1pZZE5u?=
 =?utf-8?B?OWNzK1NVMnR6RCtBQkthWjlWbThQRTF4b1ZtOUtUS1V4dzdTL0dMMTlWSVNy?=
 =?utf-8?B?NG84Wm1IK3JrOVJ2b2d5bWhKTjgyRTdhZVpaUjVDbC9GZW5lVEtORkNrY0xT?=
 =?utf-8?B?SmM4WWhybTJRc2h3T2dQc1NNTTRRWHZNd0dsMVB0ZHNPZk5MUGUwcncyMjBE?=
 =?utf-8?B?WHRHK3dHQzBnbkdTQk1lc1pvcFJRcy9SYzR5V0tjL3ZBTm1KNjQrT0hjYXRm?=
 =?utf-8?B?M3c2N1JaRFVuT0NwcnRONFEwZW1TcG1iVXRqTGdSei9yMWt1ZVdsNG9QVkdV?=
 =?utf-8?B?S1VvS1ZhNThjYWVZRUFleC9pdlU3TDJlaUVvT0taa0JOMVJiMWVjN1Q5Ty92?=
 =?utf-8?B?bEp0RHZCTEhFZWNlYzQ1ZXV6aXFHaUNjM3RTb0kwUkxpKzAremNhcGJqempF?=
 =?utf-8?B?T0tDL0czSUNyU09WQUt1TlA1YklkZkQ2ejRjVk1rMGl4WEdUZHJqODlJNFcv?=
 =?utf-8?B?aVNuN3lQeEZOTnNLNk00WDFIQmdsZ3R6TnQ1R1NkK2FiYVUwVGxQNFFpVEZr?=
 =?utf-8?B?NkJkSnJ0L1ZZNUxiMWY5ZS9RZGMyVWowekk1Uy9JWTBURkZUNldsL29SS3V6?=
 =?utf-8?B?ME5PNXp3Zkl0WDFLa2t3OFBwMTZrTnpQdy9xcllBZE1jakUxd0xiYy9BNStz?=
 =?utf-8?B?SDRPckFxbUxwY0d0czVWbUU5UW1qZUdvdnRUbER1OWJBd21GT0JoNHhhYzMv?=
 =?utf-8?Q?OmqKS58oUX6uE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:04:39.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: b53cf4d7-3deb-4377-13fa-08d89bc5423d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4yLFK1h0spIryUbpD4Jhf/gg2+LzRIgVKEag215TTd8ZDh5j9BpcF0YoxDdRLV2qBFp/BlfX9bdBAiHw5Wg8mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
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
Reviewed-by: Steve Rutherford <srutherford@google.com>
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
index adfe2e53abf3..877780222378 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1167,6 +1167,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1217,6 +1237,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

