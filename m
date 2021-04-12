Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B257935D158
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhDLTpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:45:01 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:25824
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238234AbhDLTpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:45:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJTHc5VjI7koyJV1mX4wgpzfCX2oQ6y06akYW82/BaMxTMtDhWTza2Nq7wG7ZXPIrYaX8g5TUec4TEPJmTajmwlJ5hXE1UOWUJ8Yz1WgiBbmBHbriHx/jDUeU9Qjs1nUdSCGnCZ8gajMNbdn0Ax99UDknoo9ir/uAd+zVCPLMjwET6gdz8YDeoYARzOUwrYtTS/mflc3xK4ypKH4ze3Dq8dpO4DsXru1sCrv6nZRyC94oVkRWhmm4YeCrf7tTELfYh008EkuFAji7vM7XXCohOTxV3VXdH1/vjHXdmvdWOvqPxMc8w52vMrg4xo7d3O0Q1lpvL0wVq5rWz7VlRnAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAR4TeFg0Nlu/8iO2BhJJHdmuEIITuF8bwy+t8L0m98=;
 b=Em7L3yuBV+anNgQnwdrwjxANyOEbAnjO9oIEfx3PTrZlyYjWUIjFkacYc2CPcNdNyJVwnmEEdmZvMa0/9g0+kKwZohikR8sxVnMAGSXMa+a0D4zL47WUvkSeBY07pOrt6Y8TaSFaWl8xljSdmvTr7oIzlFd/azF9SDZBfRhrWgHfVOBv8Iz5pjyIsU1UFw7wsp41+BDcfKplTaK0YlZHNH2Facq4j39JnGhti/IWLHbe0HBpTHJ2PX8UC+xIboK0X+MX4/g4LP4g2KyD9Rt3H4kX9Hee1GpQLuYoVrLAH/Iie+MJadTOZOhyG0JYqeTu+CIBO9QGeaYOeZlBRJ0aRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAR4TeFg0Nlu/8iO2BhJJHdmuEIITuF8bwy+t8L0m98=;
 b=egu/rKsdO4x5Yw28+7f/inrVfJW0dBHqXr0ucBTJodgCHqMMDg8TMWVaeACecT+e57mT3BaKYh23BhD4wTE577C0XzoJoYvjKZJ+SVSmmhqfnb1plfJKcxYMmCvSMH5GDxzjXozNiu26/QKZCVugPd4j4Bq6oWcZogGX1k/1/14=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:44:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:44:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 05/13] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Mon, 12 Apr 2021 19:44:29 +0000
Message-Id: <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:806:f2::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0010.namprd04.prod.outlook.com (2603:10b6:806:f2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 19:44:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f654217-9d71-424a-ba22-08d8fdeb68a9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26855F56439AE1F06ECF5F528E709@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yT5v3qr4BWVViWNAfqnEIn+V5CNiEZowI6eMuaWWs2sLzHfNnBfTkWB5hvKwp6rT371brlWa3ZKCwsnk3CSgydY39CWnZaTaWDV6pk62ToAMsWDt7VX8AEZuDS25fjGUpQjlIXACCyAxwaXU+fa7jjI4WPa4AeoM9/31xCqI25mV5sOlPovmfbhTfGOdWwC+W2cGpPb0tMODBrOc8ckSqcKRJIoisruAicBXVGzBQqCBxaT8GON0uu9QFhcyAQpUfBX7lJG24aLANPlK6mHt0KCdhdxEuFWYoUzBarQXB7CPMn/IFGl3C8I29JzjBVeMfXAxrpGAFBAGPnhy2WuanM1fpSxuOIsLq5s4bYsSFn/WKkNsrKCzbE2GwBBNJxlKdZIJyy7jX06YP2TmeQELn9TXiOCqWUxsFnjtxZyWCuRC62vfHPteTBGjHvSyP2TSWFUY4SmOj6UMzmsnOM3z1cK0oUUC0PdzMO6H+wuVQLXDGC6+XSO1AEVEoC3XBf3QJRFzuSCxbI8oDi4n55CXb9giU2gX4MbVs83eSxMlN9uBs0zl5xPSC6NhAZi71wifIlO8VLWCWYwJe+U2EZFuOTV/K3n5PmsdQB5+j4ETRogVXv8nrFGBY0AK6yR1TjgNTeF/5KAHiFXno+S8iHMI4FdmIctGBqFzQbZ1l+bIkFM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(316002)(6666004)(38350700002)(36756003)(8936002)(38100700002)(478600001)(52116002)(6486002)(16526019)(4326008)(186003)(7696005)(66946007)(66556008)(2906002)(66476007)(956004)(2616005)(5660300002)(83380400001)(86362001)(26005)(6916009)(7416002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OWg1YTRxaFRZeUdTdDVrMDlOQ3grc3ZpaUZxTTd2VmJRYkEwbGl4ek9pMzJ6?=
 =?utf-8?B?enZ1UUpCZEg0eHFnQitYbnpzUmhyQks3SVRoTVJEczdWb0xrSHBqNk1CU2pB?=
 =?utf-8?B?NUZLTWRRMXFQVmpZcmdGbWR0Q2RNWFQzS1NzUSthd3lyZW5wUXNvbW1yelhi?=
 =?utf-8?B?VlVWYjIzNG5yb0NrUlNTS01NcGFjY3Fhb3FQK0E1dEY2UHc0SmZGWXFXMEd6?=
 =?utf-8?B?Nm5zWnp6TzZTeGdqcDF5aEVKbVdqZVcyWnY0c3lVWVZmYVNrVWdKZW9nZ2pr?=
 =?utf-8?B?WkQ2Q0R3ZDd1WGJJeVZIU3VIZnUrUWFNYUN0THB5YkFIeXlMMGU0R1gxVmJG?=
 =?utf-8?B?SGFkWEkwQ0lMejdXQTJQOXVyRWtUOW1yNTdtd28yb2luVUpGWjVYQU5HbXNE?=
 =?utf-8?B?UUhIMDJWMG8ySDEzMGtKZnBhdTFMdXd2MzlkMzQyRFc0UVR5N2s5VmhKZGYz?=
 =?utf-8?B?UWxqY2Y4Tm1QMUVLYXRUVW5GMXNsamJ0ZkZYUE0veW1rVE14TWJKRk5sZXBV?=
 =?utf-8?B?VmQrejB4K25YUjg0bW1CVldHQ1FOd1duWkdrVERhbWdIZU51SnhEdit5bjZJ?=
 =?utf-8?B?eW9GVWcweExTQ09DYnludk9qeWVYSXpTbG5YWFB0Vk5wQzR0WXc3djdRN3Qw?=
 =?utf-8?B?bFRySUllUGpLVVVEK3MzTVFQMENTSThpY2NvRkJ3UXBsRDhuSE1IOEd5VE14?=
 =?utf-8?B?eW1JYm0vNEpXN25CdVNqV205OEtvRnd4eVlnNWRqdnVVd05ZZ2grUXVUWmdY?=
 =?utf-8?B?SUdaSlpGaWZPYk1FWGJxY2IvZEE1NDMzNGVocVc2aDBpeE5PbFlPakpKVWIx?=
 =?utf-8?B?dW8xMm9PY3l4MlBQYlV4WEpuQjNKVmJsOFlpWUpZaS9GU09aNWdPN21oVkU3?=
 =?utf-8?B?blFTcVA3dlJ5OG51UlZNRXp0cnNZYll2dE4vUnBqdVJPY2ZUcnB5UDJ4cHIw?=
 =?utf-8?B?azZ2UEk4Yk5PTUNPYjVFK1JXL2QvVXd1cmEwOEpsMFgwaU1FVHNNaGxRQ1FW?=
 =?utf-8?B?YzJ2TXp3OWJOUjRWRUxZK2RWalY4Zy9GOGFNSWk5THBjYmpDRGpGenczY2hT?=
 =?utf-8?B?QmM1YzJNc0QzVSs0eHZ5VFBBU29Cajk5LzVxQk04Rm8wSU56RmZ3Mnd0dWxo?=
 =?utf-8?B?blowOXFFNWZVYkxmamhQeXZYYyttVmNsOTNGY2JPemYyUHZWcGtiR0R4V2Iv?=
 =?utf-8?B?cGxnMGJuSHN0alpWd1RnUzVJby83YitFbkEvamhVVm1acTZZbWpXZHMxbDNP?=
 =?utf-8?B?dVNOTkhWZVhiZjVoNHBta0RHeEVZWEtGdjlIaUVMamorTWwwek8rZlBjSzF4?=
 =?utf-8?B?Y2RZN2FUUG5OUEdTTldFRzVuRkJ2S3ZGbnhsckNKTDVkZFhrVU1FVHVnZzFx?=
 =?utf-8?B?aDY3eVptMGIvZk9UTldHWHdRVkMrZmNvaXNscFlYb0pJb1h3c2QrcGlyM0Jr?=
 =?utf-8?B?MXNOZzRYTVI1Z3F2a09lQU9UeVFQYzRpdWxyVDFvZjdsam4yTlM0WnFVTVdB?=
 =?utf-8?B?bUY5U3FGVmZGSDlZVXdDK3ZFTFJQRVFaY1lpQk1FZSt0NHU0YkxQbmtLR2lK?=
 =?utf-8?B?bTh1MFF1dUxjblJwT2toUHNLT3BrYlpZYnFURnRBS09OOFNKcWsxc0NjWjJw?=
 =?utf-8?B?WWE5SDYwbkxOTDQ5MEVGTmpoWUI2MFc3TWErSGR3Z2NyUDlVdmNoMk03aEc4?=
 =?utf-8?B?blRjR1pnZE1jVlpwaURiSzhtMDBJUm9JYmpxaTYrRHIzcUxBUWlQTXJ0aEk1?=
 =?utf-8?Q?nnoFhfD36qa2pHKfUR7GQwhLGKmRM69i1ejEwZJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f654217-9d71-424a-ba22-08d8fdeb68a9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:44:38.9220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MfIHtT+fSmrE1LPkD1lar8kqJBwa8MbYTig9Ah6M5Pj54EqxOQy0G2XOvB44FpBJpY4IREa8faK+MqESGfEDng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used for copying the incoming buffer into the
SEV guest memory space.

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
 .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
 arch/x86/kvm/svm/sev.c                        | 79 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 112 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index c86c1ded8dd8..c6ed5b26d841 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -372,6 +372,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
 
 For more details, see SEV spec Section 6.12.
 
+14. KVM_SEV_RECEIVE_UPDATE_DATA
+----------------------------
+
+The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor to copy
+the incoming buffers into the guest memory region with encryption context
+created during the KVM_SEV_RECEIVE_START.
+
+Parameters (in): struct kvm_sev_receive_update_data
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_launch_receive_update_data {
+                __u64 hdr_uaddr;        /* userspace address containing the packet header */
+                __u32 hdr_len;
+
+                __u64 guest_uaddr;      /* the destination guest memory region */
+                __u32 guest_len;
+
+                __u64 trans_uaddr;      /* the incoming buffer memory region  */
+                __u32 trans_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e530c2b34b5e..2c95657cc9bf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1448,6 +1448,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_receive_update_data params;
+	struct sev_data_receive_update_data *data;
+	void *hdr = NULL, *trans = NULL;
+	struct page **guest_page;
+	unsigned long n;
+	int ret, offset;
+
+	if (!sev_guest(kvm))
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_receive_update_data)))
+		return -EFAULT;
+
+	if (!params.hdr_uaddr || !params.hdr_len ||
+	    !params.guest_uaddr || !params.guest_len ||
+	    !params.trans_uaddr || !params.trans_len)
+		return -EINVAL;
+
+	/* Check if we are crossing the page boundary */
+	offset = params.guest_uaddr & (PAGE_SIZE - 1);
+	if ((params.guest_len + offset > PAGE_SIZE))
+		return -EINVAL;
+
+	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
+	if (IS_ERR(hdr))
+		return PTR_ERR(hdr);
+
+	trans = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto e_free_hdr;
+	}
+
+	ret = -ENOMEM;
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto e_free_trans;
+
+	data->hdr_address = __psp_pa(hdr);
+	data->hdr_len = params.hdr_len;
+	data->trans_address = __psp_pa(trans);
+	data->trans_len = params.trans_len;
+
+	/* Pin guest memory */
+	ret = -EFAULT;
+	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
+				    PAGE_SIZE, &n, 0);
+	if (!guest_page)
+		goto e_free;
+
+	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
+	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
+				offset;
+	data->guest_address |= sev_me_mask;
+	data->guest_len = params.guest_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data,
+				&argp->error);
+
+	sev_unpin_memory(kvm, guest_page, n);
+
+e_free:
+	kfree(data);
+e_free_trans:
+	kfree(trans);
+e_free_hdr:
+	kfree(hdr);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1513,6 +1589,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_START:
 		r = sev_receive_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_UPDATE_DATA:
+		r = sev_receive_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 29c25e641a0c..3a656d43fc6c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1759,6 +1759,15 @@ struct kvm_sev_receive_start {
 	__u32 session_len;
 };
 
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

