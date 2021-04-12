Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7999C35D152
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbhDLToa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:44:30 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:43809
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245417AbhDLToZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FroxcO3CLuikkZfZbrgxT5Q/tdQYboGkshpI24ngiwKwdCDc4Dh175S6oBens8vAJlxSc5ZHMNweMel1JP5Hxejwhy/8pjDuai2vobUdcrSGan60xVPwQqty5cTD8cQlq7H4mN/Cf/jTxF8ophva3J1aio3nOvNlAhF81iegl2gWIOes+LnRyDt55PF3il+xqkZ7S01bvcJ6vY65IOotl3+K/StMGeqqhMmT0SxwOSe87EkUqZnrLFfdp6ac6FeLFcxvX+UUDSZ11X2iaehqc8LMxw6/8LhTre/k6ebLPnMIOrppqjUxOw8b7GkyIA39PW/sgI7/p20PRINYBZSmWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYVNY8BsTybE58fvtY+jcGFOHWn1tynkMK/KKN9NcjU=;
 b=ZM+SNrTLNrwcqyXkM4clTWdNelqcRpCbpmOrA3uUrLL+jtJQmIsggxBz0cDavCKYRNcWSYG9M6dwjUGTJf+5t5XSwXpbE6adPXudWeJmjG8bp+fM6DUqVMbTJGMu8cxKV0dIeu0mN8mGyXuyypjbOLBXwUFwt77x+DVqc/ltG377M800m8pFeIehQECYiPEFzXEMzrAXvk8JBn5uc1Re4q2Le8V/xyIAqTimYM3d96maKTDyDggb6hj14aeBi0YspPcYto+fGemjqtE1bT8vaLG4Pza00Fu25H23Pe9OaxHgs6z7hMyHQKwqDC83P+fbCtTdPyeYOWmLh+DxWH4ScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYVNY8BsTybE58fvtY+jcGFOHWn1tynkMK/KKN9NcjU=;
 b=LmPcPB/Uelk1ylcU4hBaDFFBHHxcXa+SwDMeM4td8jr7IHjYq15imcQIyhPnwMhjl/lVmlpvGkl41676rS33BoJ0AmbivXBQok8YVwfuGsKgkT8KX6cbNhnG9wZgJdbSJTJRbx0r/vVm/5r3VPQ/or9CcJCwASDf29EXt56nG2U=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:44:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:44:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 03/13] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Date:   Mon, 12 Apr 2021 19:43:55 +0000
Message-Id: <5082bd6a8539d24bc55a1dd63a1b341245bb168f.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:806:23::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0080.namprd13.prod.outlook.com (2603:10b6:806:23::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Mon, 12 Apr 2021 19:44:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c59e801-781f-455b-81c4-08d8fdeb546f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2717B6441E5ED327B6683FE58E709@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02EH1EnKDvi7jzfHysP+86yyZMn2dWBBjVH4rfxi0NbSiKvNGtR8pqoV6RRMEkvLLv4GqtInJdc1PP6eFMSK66RlXo5s5dQvhLuWOZ92v1AShmm51XBtj4ecdHdbH9tWRvKow4jHqvvN+eNhtI8zKuHC4CzZZDGsU3LVCCQ6LTcUmNpUB2qOoHERkRJ5bkU6DEvx9AgkNMCWUdxyJ3SzrnA5deNn56gbqVa4ApKfTSGkP311O2TduXu5eKq88gY2Au1MBUaGhYwuHdxY2o0sxxj5ofYQVscScH0HmhKeIpUTwahA3lhzaEhGpmHBSRMvv37VknOAmInSLno5Mm2E86+Ami18BmRUAxBmMMZTXbyy4OnMfLTAZlP6o+JFPoqXsyQPy/UO/AlAdafsbtw4KDYbY6MK44MnWk6G1zdswXyYTyqjfsh65mjJ8CbRksRICDULZCIe2KhFK6de5zeaeThOQSbNuBD2ZnGoNLDZne0chIFjyPHarJ43DDARrKZWjk/sjjvV7WM7iEuYUmkcf5eUkDqR3HFnbDMNckA8X/AENP4xxl33LGQ277MLNhCmHMtHG6KhtrUE3TB8e9TTtZbsaGXuvyu6yxXPj2EQzLXM6mWSdqxCZdpoa5xOy2JamXpYpTXGOla098U3Z7e+QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(36756003)(8676002)(6916009)(4326008)(316002)(86362001)(2906002)(52116002)(66556008)(2616005)(8936002)(6666004)(83380400001)(38350700002)(956004)(186003)(478600001)(26005)(38100700002)(5660300002)(66476007)(7416002)(66946007)(6486002)(16526019)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVJYU29ycGVLSy9OK0RsZkppdU5WQ0R2bkVYRTE3TldiZEZvS0IrQWRqMnF4?=
 =?utf-8?B?UVNFeFBzbHFya0NuQWdJUzZZUGZyRGpSZU1Ram9GaFM3V1VZQWR5TkgzZjRR?=
 =?utf-8?B?NC9JZzB6MkNlaHBVZ0RnaXJYT3YzK2pWU3hpdTFjTjFPQWlYc2hTR2V3Z3E3?=
 =?utf-8?B?Q0lobGlscmtXc2Q4eGNKTVFxN0w1Z2Yra1RkVVFwYWxiWUtmZFBYeXZSRnJn?=
 =?utf-8?B?Zy8wd0FRdnVvcG5mdUtmbHRSY2VZZ1krRUdEeU9lelB4RDJIaEZlTC92WU9n?=
 =?utf-8?B?SHN2MEx5anNXUkNtWWVDWW1DSHc5bUV2VXo4aGNNaGFibVVza09Ub05zdnN6?=
 =?utf-8?B?OTllVUE2MU9MOEtEVFJmWldzWkkyN2JIQlNMRGVhbXZGaGFna2FQbzFhUWMr?=
 =?utf-8?B?dU96ZjRpV0Z0VHMwWEY2U3lKeDFrZVhsVGVGTTVDNGc4RzlGRnVaWnNrQVYy?=
 =?utf-8?B?Y2JXMHliSTZFdGZUdmpsL2lRbUZYVjZVZ0U1c1o4T3hLaEtWL21SaDl6dUNO?=
 =?utf-8?B?SStsOGRsM2lLMjFWaUhqdG9MajVsaFV1blBickpYOXVYa05rWDQydlhqZjRn?=
 =?utf-8?B?TEVkMFhKR3pyRVRTSEJiNGU3ZFd1cVMvUVpSSlFMTnN0RFhzWjlNQllxQ3Fw?=
 =?utf-8?B?SVZSdEhuS3pYMUJjZ0hwOFFoMEt3UHNZd2hQem0yNjUwZ2R5R1VCOUlvbU1r?=
 =?utf-8?B?Z2lQVTVPMmQ0V1ZxclF0Smg2cG1JZmlRUnBoYnMzRnYrT0NQV0JmNmlubEVu?=
 =?utf-8?B?djdHT250alVGTGUwRW9wZTNDNVVLTndVNlZnaWRoQ051eUhLdWdzbEpDZ0pU?=
 =?utf-8?B?c0lVdWYwMTlpT1VVS3crUFUvTndDK1ZVZTd6L2dKUXlESjFkVXpyODE5MWNQ?=
 =?utf-8?B?bHB2eTV0a3VtNU1sWGliSXRTUE5WS1lYOGphVmQrY0J0UkFUUFdKT3JYZHls?=
 =?utf-8?B?ckNjSmFlSmt5KzNVR0ZjanZadFkwaG5HVHdWQ2ZGVjhrUUpuTFFJRlNaYVZm?=
 =?utf-8?B?RklhK2xsUnluTTFPaEJobVpma05VQlNhdUErYXdqUnJsNllJOGJNTzFOMWhn?=
 =?utf-8?B?YTMzYzJWRW9RUVBLMmQxMm84SzNsWkdBcDlJbCtaMEJnYjdlaGFEVTAwKzNI?=
 =?utf-8?B?RlhVYmYxbFdSc0ZhN0svVzd5MDJrWDF0QzFCeVVQOUx6bHVhZTRONEZZWmx3?=
 =?utf-8?B?ZWlKcWt2bGJ6bXRGVStpSUVIdmRBR2JCZTRVeEVaUW5Wbkh6UDkrVFN6YlV2?=
 =?utf-8?B?V2dMRDVQRzY4WS9qekZ6RndKZXNJb3duNXcyd3piaFZkUUJqNFVnbFNndGt4?=
 =?utf-8?B?UzVwWHFUY013MVhwTDRPYXJzd3RRTUE3VnM4QmJBNkFSM1N0ZGF6MWgrKy80?=
 =?utf-8?B?SldwcU8yeExjZTF5SjZEaFFYdDlzY1Z2eUpCSWVJT0lpQkJleW9HOXZGSjc2?=
 =?utf-8?B?R0xOQmUwbXFOejdEbjVUb3ZLb3NlSXJsRmtiZkJyVjMrdVNtYjN5UXRlMEhi?=
 =?utf-8?B?dk1ORi9yVlR4UDVFajZ0Z0pkNkhDVjB0Yk8vK0JMYjkySytzTnBPQk1WUTlt?=
 =?utf-8?B?eFR3QmM2K1YzSnJNNnd6TGY0ckk2ZE1zT2ltNFRBa3BQTlVQbmtmU2o1blNY?=
 =?utf-8?B?aXVyNVJ6VnZUMTBlMlpnVE50QWlUNGZWRSs5M2JocHAvVVRHa09QZVpKNEwr?=
 =?utf-8?B?amN0aWplQm44KzZWZ1FGTThLYWFXSitIcDFyTDhsSXNxMUJUUklPVFFMMzNB?=
 =?utf-8?Q?ocYukJ+fdex8hKyVlabw949YUOVz8AnEaznVc4X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c59e801-781f-455b-81c4-08d8fdeb546f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:44:05.0779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wS8UnpC7aPZ1tpKFHskHKWuVAr0Yw1DoVOs7f5STIbrsFXxJINDjU5q9mfwGHGP3qmt7+6kwR8kryyg6b/iAIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
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
index 3c5456e0268a..26c4e6c83f62 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -335,6 +335,14 @@ Returns: 0 on success, -negative on error
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
index 30527285a39a..92325d9527ce 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1350,6 +1350,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1409,6 +1429,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

