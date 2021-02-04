Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4420E30E8B0
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhBDAka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:40:30 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234329AbhBDAkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:40:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhxsxis08BcAwtVYqstkGOIrr190HDuB0rRaXXVYfVIWbcwoDScarXyiwp/UGGjExp8N83pkNtmeTLZ8aS1oSkoLp3oqdqrwN5LG9c/9ZO61/PowSCrExriQbadIHNeqCc8NCLqcpEOUUWAVkKYZASzpxEvbOIDIinHG2eHQ7xrG91OtTpUGyVbW84j1/17RZnHBrVxio24CWGzwupo/qvPZfjDZk9zWOxRa3UNjoWrMnjo3iuybwkVmHPlDoX2np5P+DyQIpkt+pJJADKg5X8+hGfg+bh7JfKo+u05OqHkDX42W9PLreYEyPsqn/m29IY06WT6mJ5Aork5MuBly1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDn3PuhK32U89JlOnx3WGQyX77N2sIjY5STzuv0EcQo=;
 b=b4K1fSKmlNzhr9v4r+1IOr+FdFrxoTXB7xZ7GoNS2xzAkDCLV/boS+UEv5/pHoOjpyZ1PUf1Z8MjQpnlvti7EJ5o+hJvV3mKBpUgCEiqUNy/e+Q0xbjtujkQdfkmRk8KJiROhKyJ/QPl6tgHWrCtqY/v0WMihruD4WohJjpW88e/RV33QDxZ14NFjrdnda6KYToM3ryO7CW5y4eC1XG6E4XYbVbCzyzaCiMUei22W2xNi30BEDmbg19svib+evUZ9rAO5QlCeHaoXEEAD5LJLo7Rv3x78mVmAABBBoFrsiU71ChNnRfetLUYA/QQT9M4/6MH5Ukum9HeIQ5BZB1XGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDn3PuhK32U89JlOnx3WGQyX77N2sIjY5STzuv0EcQo=;
 b=FJyc++9YW4LCQO5nGeeLHLMv/SsRLIA7tcrPu3kOA1FIewy5y/Xd+slV1ZeLDE7G0HIHX9Jw6Ts7PUrx8bV2uzp7t/ReV3BRO5qZz2J2DjgNc6N76qnbx71AC1mCI4+V7jrtAQoCVOqNECCHJ5UIqOZuMtTnZZHwBJwrl3Dv1TE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:38:38 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:38:38 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 08/16] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Thu,  4 Feb 2021 00:38:28 +0000
Message-Id: <245f84cca80417b490e47da17e711432716e2e06.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:806:120::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0039.namprd04.prod.outlook.com (2603:10b6:806:120::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Thu, 4 Feb 2021 00:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2ed334a-4df0-4eaa-afdc-08d8c8a53601
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43843E4785ACE888BB29250B8EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGExSmTDeypv13y71UPM22fxywDR7VLbT0JTsVv/TPNXZNzJuiqhgOaoo/W1xwXLe5Da856YMZ5mz4oeK+ciZ8tfadjNBel3TkW+ryEcGY1TvMq5PVRQQVp8qoWAwtqBtVPVQRtirmOwFe0TC+cNOZzUl+vFeH8r7SziKBFH4KYKvsCHcuzBkfF2m6O6rX/5oo4nSi2DfxEIuIq2bq2zmKZgIE+SG8lcDyQ6psahecUV5krdAdnIFPWqfSkKDQQZQTY0+rw5WbG1HF2/KjiHV9yuN/syDFJgKZCdPIcxr9lzIq3JA1Pfn7xtypWcjCp73pWsbfUPQxAGjrNwyqtN56ipgyKsp0hNmYiQ6CrUUG96cUEopuP2i2X5t6Qo/1wT06/KtkHsfLjNjHZxuMlwOdrhGv9iO6DYT8vAHhbnbcwbHXtTs3yI9E5ELo/GPzrcLGqq1ouPgz3AtsdkBmEGUQ9ZkKB7z6YVP0V5kfv8vAslzVn/H5P7ZNB/O9R5kFm2FwJuG/7XXW8wBcDG0VY2cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z2NMcldlYVMxSk0reENJK0VKeWpEeThRVUdUcFlKaE1nWkl1eHlYSllaeUEv?=
 =?utf-8?B?a1NrMTRrMFRxZnRlZVNvdENMTlY5MmtKaUZUUEd4WE9qcG4xNzhBQ1lVRTVY?=
 =?utf-8?B?VWxOdk1LS1J6akVhWkxCM1N0UXBlVFYwdVF5TnN2YXRscG0zK3hzcEE1MURp?=
 =?utf-8?B?Znc1OE8vaTRZemc5Z3NiUDFhZ0RGKzUwUGdWRWl1ODQrV25zcSt6S3R0TjJz?=
 =?utf-8?B?SHZDaXVzNTQwckVJNk9udmZGdm1UcXpRbFViT2FPZTh2RythOUZ4d21TVHN3?=
 =?utf-8?B?RXBzQmJXZzU4Q1huaWdjZ2xwRS93WUt6cGpwdU9zcGJxK2ErY2pLZ1JXSno4?=
 =?utf-8?B?d0ljNlhKYmRXeXF1RU0yandGMVNlZ0VmcVF3RWlKU2FWTXJTa1M1QmQwVWVS?=
 =?utf-8?B?Y0NROVE5MXlQUXVIakZoeFoyeWx2V0dFN3oxc2dRQ2FMUnk3U2RpTFFidW9H?=
 =?utf-8?B?ZGppOEtwK2VEOG0zd1RUS2dYdThVRXVVZk5LRXpJVzdic1hGUzdSZVJLRlg4?=
 =?utf-8?B?QlEraWpaQ1BtQXhuZE5LWkhQb3daNmtSc0paZkJSd2V5NzJBUnVYbzJtVWo2?=
 =?utf-8?B?NmJiZ0VXYnAwaE0rNGZjRnRmNEhHcW9JZ3JSTTR6czlKM2pmeXltUmxraGNk?=
 =?utf-8?B?cXJFbitud3poYkowZW9qVDVOM2JtQmZPZWZmdUl2Z1Azc0hiT2p6amlnMVhE?=
 =?utf-8?B?NDVndXdYVGd1Tmk3Y3lvRjFBaVR2d3l6QTZPZFoxeVY3WWRIcEoxY2M5dG9E?=
 =?utf-8?B?WVdCRk5DQTNHYXVscHRzeXpKaFpuU0RYRGVEUGZ5V250WUJYMXNIQU90OUpo?=
 =?utf-8?B?bWZhRFRtMFNUV0pFQkYwVjVQVURyWXd0b1BFNndHekUwMnJEOXV3QWVNMEtX?=
 =?utf-8?B?U21mNksvbGhsY2VjTzhBTWNtcWM2Rnl3c09FTDIxdklHN0phTC9oclJSMjNW?=
 =?utf-8?B?QWlNWGJDM0xvOVQ2ZWhKclpMNlJlYmVCVjdaWC9UMEF1R2dCVkNRd2RuWDh4?=
 =?utf-8?B?dGwrbTRQQWJGR25GaDdIaFNac2NxdElwY0lKQmwzZFNpeGdyOUNNOEgrWGVy?=
 =?utf-8?B?UTdwelZrUHF6VlNacGZwRXQ0M0RFVWtqODN1ellhaWxQWERHbGZnZXlCU24y?=
 =?utf-8?B?dDhwNnRhdEZVbTR6TmhDNWpnWTJ2ZVFFNk1jakNBUENiT3F2eHhtQVhvMnor?=
 =?utf-8?B?UGppd0MyTWYzRWxRQzc0RC9tZjJ4SHNiaXdWN3NZcEtPckRNTHRWZ2RFQzFO?=
 =?utf-8?B?eE9oNnZ3S0tzbW5XSWkxVHR4dnRLdnJzYVQ2YWEydHd5bDNsK094aTEzVmRu?=
 =?utf-8?B?cHluRW9lSEZadXZQZDNWWTBLb1Z1WWpFZDdYL2E4MUp0SlVMKzJHTVdkTS82?=
 =?utf-8?B?MFpRZFJpOUdjNzhRWUNsSlh6NFl6MTM4ZUtlbDQ4SG1ibVI0QVRSS0VqcXl4?=
 =?utf-8?B?bjZJUk9lSk9ZS1EzWWlDK1N5cTdBVVRNbmwrMUMrRElmb2NzOEZpUjlmMlh0?=
 =?utf-8?B?Tk1nanpJZDh6dXpadGRKVEwrZlZDQjViTXY4VWZBdGFabjNubzdpT3dENGhV?=
 =?utf-8?B?TU9KZDY4VXBjdmh3ZG5FOGkveWFkWWdrZ3dqY2wvU0lQbWxqQTg2cmZuMldT?=
 =?utf-8?B?OFBrRTdoMTJlcW5lT0c0bTZuSktLTFR6ZXhVU1hTaHlieW1pRzFkQjdEWk1Z?=
 =?utf-8?B?QlRSTTFPY0dtSS83cXZ3ZWkyb0QzNXduMksyRDlPYkVEUkYySFBDSk0vTktl?=
 =?utf-8?Q?/1i2GflHYu0eV+Y1iL7GMDC0eKrKnBMGoElc0Jm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ed334a-4df0-4eaa-afdc-08d8c8a53601
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:38:38.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BY0t+5r5+AvFZa9OkvwQMUH5cHQSrnGJ7C5+DaIOZ7XWK9mwFUTpGlgSknvn/AGGmB4UyErJvQ8pnj2akqF0wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

This hypercall is used by the SEV guest to notify a change in the page
encryption status to the hypervisor. The hypercall should be invoked
only when the encryption attribute is changed from encrypted -> decrypted
and vice versa. By default all guest pages are considered encrypted.

The patch introduces a new shared pages list implemented as a
sorted linked list to track the shared/unencrypted regions marked by the
guest hypercall.

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
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/hypercalls.rst |  15 +++
 arch/x86/include/asm/kvm_host.h       |   2 +
 arch/x86/kvm/svm/sev.c                | 150 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c                |   2 +
 arch/x86/kvm/svm/svm.h                |   5 +
 arch/x86/kvm/vmx/vmx.c                |   1 +
 arch/x86/kvm/x86.c                    |   6 ++
 include/uapi/linux/kvm_para.h         |   1 +
 8 files changed, 182 insertions(+)

diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index ed4fddd364ea..7aff0cebab7c 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,18 @@ a0: destination APIC ID
 
 :Usage example: When sending a call-function IPI-many to vCPUs, yield if
 	        any of the IPI target vCPUs was preempted.
+
+
+8. KVM_HC_PAGE_ENC_STATUS
+-------------------------
+:Architecture: x86
+:Status: active
+:Purpose: Notify the encryption status changes in guest page table (SEV guest)
+
+a0: the guest physical address of the start page
+a1: the number of pages
+a2: encryption attribute
+
+   Where:
+	* 1: Encryption attribute is set
+	* 0: Encryption attribute is cleared
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..2da5f5e2a10e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1301,6 +1301,8 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
+				  unsigned long sz, unsigned long mode);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 25eaf35ba51d..55c628df5155 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -45,6 +45,11 @@ struct enc_region {
 	unsigned long size;
 };
 
+struct shared_region {
+	struct list_head list;
+	unsigned long gfn_start, gfn_end;
+};
+
 static int sev_flush_asids(void)
 {
 	int ret, error = 0;
@@ -196,6 +201,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev->active = true;
 	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
+	INIT_LIST_HEAD(&sev->shared_pages_list);
+	sev->shared_pages_list_count = 0;
 
 	return 0;
 
@@ -1473,6 +1480,148 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int remove_shared_region(unsigned long start, unsigned long end,
+				struct list_head *head)
+{
+	struct shared_region *pos;
+
+	list_for_each_entry(pos, head, list) {
+		if (pos->gfn_start == start &&
+		    pos->gfn_end == end) {
+			list_del(&pos->list);
+			kfree(pos);
+			return -1;
+		} else if (start >= pos->gfn_start && end <= pos->gfn_end) {
+			if (start == pos->gfn_start)
+				pos->gfn_start = end + 1;
+			else if (end == pos->gfn_end)
+				pos->gfn_end = start - 1;
+			else {
+				/* Do a de-merge -- split linked list nodes */
+				unsigned long tmp;
+				struct shared_region *shrd_region;
+
+				tmp = pos->gfn_end;
+				pos->gfn_end = start-1;
+				shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
+				if (!shrd_region)
+					return -ENOMEM;
+				shrd_region->gfn_start = end + 1;
+				shrd_region->gfn_end = tmp;
+				list_add(&shrd_region->list, &pos->list);
+				return 1;
+			}
+			return 0;
+		}
+	}
+	return 0;
+}
+
+static int add_shared_region(unsigned long start, unsigned long end,
+			     struct list_head *shared_pages_list)
+{
+	struct list_head *head = shared_pages_list;
+	struct shared_region *shrd_region;
+	struct shared_region *pos;
+
+	if (list_empty(head)) {
+		shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
+		if (!shrd_region)
+			return -ENOMEM;
+		shrd_region->gfn_start = start;
+		shrd_region->gfn_end = end;
+		list_add_tail(&shrd_region->list, head);
+		return 1;
+	}
+
+	/*
+	 * Shared pages list is a sorted list in ascending order of
+	 * guest PA's and also merges consecutive range of guest PA's
+	 */
+	list_for_each_entry(pos, head, list) {
+		if (pos->gfn_end < start)
+			continue;
+		/* merge consecutive guest PA(s) */
+		if (pos->gfn_start <= start && pos->gfn_end >= start) {
+			pos->gfn_end = end;
+			return 0;
+		}
+		break;
+	}
+	/*
+	 * Add a new node, allocate nodes using GFP_KERNEL_ACCOUNT so that
+	 * kernel memory can be tracked/throttled in case a
+	 * malicious guest makes infinite number of hypercalls to
+	 * exhaust host kernel memory and cause a DOS attack.
+	 */
+	shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
+	if (!shrd_region)
+		return -ENOMEM;
+	shrd_region->gfn_start = start;
+	shrd_region->gfn_end = end;
+	list_add_tail(&shrd_region->list, &pos->list);
+	return 1;
+}
+
+int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
+			   unsigned long npages, unsigned long enc)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t pfn_start, pfn_end;
+	gfn_t gfn_start, gfn_end;
+	int ret = 0;
+
+	if (!sev_guest(kvm))
+		return -EINVAL;
+
+	if (!npages)
+		return 0;
+
+	gfn_start = gpa_to_gfn(gpa);
+	gfn_end = gfn_start + npages;
+
+	/* out of bound access error check */
+	if (gfn_end <= gfn_start)
+		return -EINVAL;
+
+	/* lets make sure that gpa exist in our memslot */
+	pfn_start = gfn_to_pfn(kvm, gfn_start);
+	pfn_end = gfn_to_pfn(kvm, gfn_end);
+
+	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
+		/*
+		 * Allow guest MMIO range(s) to be added
+		 * to the shared pages list.
+		 */
+		return -EINVAL;
+	}
+
+	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
+		/*
+		 * Allow guest MMIO range(s) to be added
+		 * to the shared pages list.
+		 */
+		return -EINVAL;
+	}
+
+	mutex_lock(&kvm->lock);
+
+	if (enc) {
+		ret = remove_shared_region(gfn_start, gfn_end,
+					   &sev->shared_pages_list);
+		if (ret != -ENOMEM)
+			sev->shared_pages_list_count += ret;
+	} else {
+		ret = add_shared_region(gfn_start, gfn_end,
+					&sev->shared_pages_list);
+		if (ret > 0)
+			sev->shared_pages_list_count++;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1693,6 +1842,7 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev->asid);
+	sev->shared_pages_list_count = 0;
 }
 
 void __init sev_hardware_setup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f923e14e87df..bb249ec625fc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4536,6 +4536,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.page_enc_status_hc = svm_page_enc_status_hc,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..6437c1fa1f24 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,9 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	/* List and count of shared pages */
+	int shared_pages_list_count;
+	struct list_head shared_pages_list;
 };
 
 struct kvm_svm {
@@ -472,6 +475,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
+int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
+			   unsigned long npages, unsigned long enc);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc60b1fc3ee7..bcbf53851612 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7705,6 +7705,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+	.page_enc_status_hc = NULL,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76bce832cade..2f17f0f9ace7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8162,6 +8162,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS:
+		ret = -KVM_ENOSYS;
+		if (kvm_x86_ops.page_enc_status_hc)
+			ret = kvm_x86_ops.page_enc_status_hc(vcpu->kvm,
+					a0, a1, a2);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..847b83b75dc8 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_PAGE_ENC_STATUS		12
 
 /*
  * hypercalls use architecture specific
-- 
2.17.1

