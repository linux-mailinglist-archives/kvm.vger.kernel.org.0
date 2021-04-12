Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30AC35D15A
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbhDLTpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:45:20 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:12992
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245517AbhDLTpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:45:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1FX+9odyShplHX1MeBIRcJqMaPlHW1TmKkRhfjUFJTLphNBLMjAF2n5CU21QA7B/h+5SNwEZE6bRdZIc3Jgu9dIPaK3nBtvaXPq/H8oo6+L757GHrJ0mv5VxdEHXFxYlR7+Csn59IluhQfwb80DN0AdUJevwdlp42UBT/AH3LIfGSqVNpTJBgJWFH6lhLzjlX2UeR+oNMRAEu5u6pJZrBrGfv9Za1fl6hnICcTXNJU9kdIBWib8mGkGTzuMhGKGWK70ogm2dB4VScJ5K9ciGJipPnfNuBvtgOkP6kjSqdeYFiPwfKRbtppZw+IxTOrr2MfEeeG8bdl5GW+hxHVCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecWJetWk79BG8nSoPDpZq7XRRwLaEAjNQ7SI2nOsNIA=;
 b=bWFU1qpy1VrOJj/zpRwwiCw2e2dQ3W8Q2Pige1fPEjdbrsOFS2/stvxwc6UPHFDeoJDbivbRtNu42lVxrWy/sbqQ0nAXiAD2AeNZWybhC2cugadzqN5XGekpov4iywEJo+WG8GxsG6t3dzsDXF5SlTyRa0nAQPMail51CRmzSnp4lUMAemsOX+W4WXFN+1Xh/Dv7R3f8CY5zW+jLtGS7p64emNPOOb03+IozpnT7ASWyx+xHBeJ5zoRhlGwGMCmve0XM3NhpIw9idVzWVm3IzULc/rrURpRPBJg4EkstyOaCMc3H282GFAJSLi0bvSEhp3aicRiaLLxIOcVuwCmbBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecWJetWk79BG8nSoPDpZq7XRRwLaEAjNQ7SI2nOsNIA=;
 b=BHLcaikyGfvI2HuZAXPbbc379R2S9+N5JriJHjiV66t9jOTkHOo5e6rWr6+UtgBpt93tMSOydunHYaJJZoB1YHPQ+DltPNt1YOPstp4tWfbre+3bhdeB3N+6+uBTYT5NbJPy2JLF1+5t2AMml/CGN2kCUfqE4r1ppS4pBDYaQwE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:44:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:44:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 06/13] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Date:   Mon, 12 Apr 2021 19:44:46 +0000
Message-Id: <d08914dc259644de94e29b51c3b68a13286fc5a3.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:805:f2::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR04CA0078.namprd04.prod.outlook.com (2603:10b6:805:f2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 19:44:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ca071ca-fa0b-4e91-0e66-08d8fdeb72eb
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271704122F87673A3A5FF73A8E709@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FAXRYMNVw+pO2jg3N5R6G9o2wZWUbMw2E1qB/Tqo1k3NDmQlZ7PisGMa45cPqal/OsNMHWhNHEXZ4niuL2I4Aj3n9cUs7bx8BXvXgDXN+7hxuB6vGTzHb9JunUXdVOemYXQQbAa+3nPEgF6zHIEzltPPvpksV/OPcVDopZIoEMU1jahXNBCBC5fu1fys9TK2bGp3zURijn0c92DD+1afPfDp3Zwg15T3QOfraZOpnU3VGAYtZJ26ijsa3CQQFohRvEcc8zpWfFvAZ7ssCTtnif8WrxaQ55Caj/9ZZwIDXfSkDC7l91880Jd/RCnW5eERC9/hstXDuWwtIfzY3m/TinIaGVSS9koQPae/vtpeOj0l974yrZvKrRLEgEcqqWuPNyYV3+0semXoryQ+got79tznOkmVCEwUMVOhorwHgxY0Nj2xnfOwu5Rfl0blXEI6sJ/Xtx7jwabTzTRw+m37fpUhc+cm6ar2gEwWl3CHGNebQkWhPVqLUMDh6cf/97l5yDhkVnqHyr5u0VE1bpueGpAZc2OGYAxhQcBzNeXSbmi6BUJSIBaQiTH5eBGAi/C2BbBWa+y3R4i6R+wBylxWLP+9IhUJU1XTgQ0cEZiK/RkJFD+DsQyFGAY48dSY2NSewrBubQNzlhJSLh7J9pvumQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(36756003)(8676002)(6916009)(4326008)(316002)(86362001)(2906002)(52116002)(66556008)(2616005)(8936002)(6666004)(83380400001)(38350700002)(956004)(186003)(478600001)(26005)(38100700002)(5660300002)(66476007)(7416002)(66946007)(6486002)(16526019)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aW5tT0pwK0tUd3BueXBEbWcyd3BMaGhGMWxLcjZuRHZLa2IvQW1lZ3ZadG9F?=
 =?utf-8?B?T2F6RDQyck9CNEhMQitHWVB5TTIzVFQrdGU2SUpSVFBZYlp0RzU5dExKeWJq?=
 =?utf-8?B?ZWhnaCthSHF4QjhPNnV6UnhJNVF6Yzl1NXFkU1pmSmlqZlRYTkZnRFZlZW5J?=
 =?utf-8?B?SWF1amxpMUREL2tpeXRKNVcyaXJkM0VsYVhHMlpCbWxhR0lpcSt0WE5tY083?=
 =?utf-8?B?VVhZMFJDL0tPeVBRSHA4S0Z6NzM4M055SmVWNEdMQ3h5NTRnaTQ4Z0ZDMFh3?=
 =?utf-8?B?Y2ZTcHZLalorVXF3dG9vWFNmRnRHaFB0ejYzVmVjWDgrMUpKaFVDd01xUmMr?=
 =?utf-8?B?YTlVWkp3Q29MWkYyRUR6MjFGc2RGUXZabFVkRUVmLy9LQ3hDcGgxaWI1OENQ?=
 =?utf-8?B?L3ZDd2lEZnRMUTZRNktSUEVtWWtISzkxU2tIbXhmR01CZ2NaSkF6Q0RaRE5a?=
 =?utf-8?B?dVpLVFVVZ2VtbW42T3B3N09rWGZUdmVERmhiT2dhTWVXVmJ2K3piRXRnK0Fv?=
 =?utf-8?B?eWhiZ2d2SmIyOVBGQ0UxM0cxd3pwWGg2OTJPeDM2Um5wcjdyU3VxQjJKVS9o?=
 =?utf-8?B?dXVueFRyVklEazBXN3dPY21BaHNQOUhTV3pUWDdtMm1QRllPL25WZjNwQXVa?=
 =?utf-8?B?aFMzeCtSNjlwU0c0MVRxUXBjVEYzZFUvQkZLSUVGbC84VE40ZExwQjJGMmVy?=
 =?utf-8?B?N3pnMEh0TW1hbG1zUkxhWGkxLzB6MmlmNVMwSlZ5RWFLekxhQlo2bTUzSGc0?=
 =?utf-8?B?b21RSEcrWGhNQWI0a1puWmkyeWVyVXJvZUttTVJyczdLZDNHcm45QXZHSU92?=
 =?utf-8?B?SG9ydXdlSzdub1dBQjU5VWw4VFNUa1psNmhmTXZHd2luZG1xbEZNajdOV1NG?=
 =?utf-8?B?OVp0TUdJdVFaNUhhL1BUbHdwMElOQm5WZ1lnbUlqQTBVMkp6SEl1VDFXOWhY?=
 =?utf-8?B?UktDN3hhcm9saHdWeXAzV1ZpVThTYm8yb051TmM3OHlXcU9GVGw0QVBoZ0sx?=
 =?utf-8?B?cTJTN08rZkl3MWlWdGxGVjBMd2dua2kxSUsyaGFYSnBQMC84TmJEVVM0b2xL?=
 =?utf-8?B?WVRsVzR0cFU5a3pSMmV3ZVlTekFJSVYvWUg4MmN0R3dpYnR4T09uL0NYQ0Yy?=
 =?utf-8?B?WUVqUUltYTBLZWRTOGNvS1RkSWNad2c4eFNzRkM1ZkVhc3Nzd3lOdnFjZnVM?=
 =?utf-8?B?dmVhSVc3UEZLVmhNSk9tbDI3ZzRESVBTWHFvdWhFcDJPeHBlRW1UbW53OFpF?=
 =?utf-8?B?L2g2T2hJRi9xVU5KcVJ2andtajE2RXdFQ25qYjZKcGZKSmJxU0RKRDlPMCs1?=
 =?utf-8?B?ZzlweGhWakx6cjNZV1ZMK0hrWXprL1MwamZIenkrWVZLUmJYbkZwakNsajRR?=
 =?utf-8?B?RmJiSkIveGxuYUdIYkZiVWZLeDRTZ3B1Y3gyeUlHSW5MSVgwK3NuZjk5dEQr?=
 =?utf-8?B?aU5vUEJuWElIb2V0LzFlazI2NStqQU96Q3ZuQkVOam55cElKeWN5ZmczTlVT?=
 =?utf-8?B?bmgyVHkyYVhCVWp1bE9VWkE3Q1Fwd1NkMHgyN1VMM29GNVFuSklTSXQxMU5W?=
 =?utf-8?B?YW1uOE5ocERhYzhkZGpUYWRFNy85bGk3VXRkcXRQVnArK1ZSanJwNzNTQjNj?=
 =?utf-8?B?Q1RNTU9CandDR1hyVEtEOXcweHRjRkt0dzJIR0ZkY0REOFN1LzU0bFpiTWtm?=
 =?utf-8?B?OEdvK1lJMmVUMW5ndjBPRmtWN1AxSWRjZ00rbUp6eldXTFJUYWQvNEg1TVVu?=
 =?utf-8?Q?KwaTDxWDIH040oX+H5Y3G3fJ1MyX5lZTxRRIaNR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca071ca-fa0b-4e91-0e66-08d8fdeb72eb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:44:56.1223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shD2rpUpEzdDwf/nXW2BX7NbQ0ZYa5iWXTEDpz3gGqyOFytBzFjC98zkB9+mcXiWiPqBFGZ4HqzULhuileMbwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
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
index c6ed5b26d841..0466c0febff9 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -396,6 +396,14 @@ Returns: 0 on success, -negative on error
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
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2c95657cc9bf..c9795a22e502 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1524,6 +1524,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1592,6 +1612,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

