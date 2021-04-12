Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861B235D14F
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245404AbhDLTo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:44:29 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:54113
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237430AbhDLToM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGop+zWO9or7XLuiVJOYaEyip9/KjAQ7P7jO4nmvNPVj7vNPEG7qIo5LXNeUnLegXNO//Ff5AZQTR+0/y2mRLzYJKaKH6SUs/Y+j64iVxH0oQ9RGoG61DE3zGqDVbhqeKLSAQvU+ITA3JqbFoUXkQp07NXRpqjm4XOMOeoigQAXBqEUjn0mgjtHT295xtJPzjxsaHJ9UDMmW94p76lExUBgqNYMyjaviSI1tVD6tGYajQuvHJZtHsMqNUGeJ2MaSfTqHiCXJbCpVLaYlNMOG1U2tqYm+W967+8YbTMJWcDKWMITPk35BFeUrpe3sE1FzjG+31AC05SVEV9eUhDnr3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmptNcWrK0Wse7VDXUmUvzb21xGh5dE1N4aXqer08gc=;
 b=hXQZvX0i9s/6CTLPMGPjw2sI8sqJa1uBzvlpS3Ps60gt/eqA5LseSaDT8LPUzrlb3uNxLB9bZb2S/Wh9GeYihXiu4k6fQXLTo3OhGmVqWPSIR6qTt7zgFHYebo4AuL2CUjKyHxwH8enj467cmarIz9HFz6gAKZ9+j/woQU0HP3P8Lj5UOUtZ0OMI457ozmfRx5p8/Om2vizwXoeasyd6RnNT/i5v6ocTAR3lFvx5yK7H7812KxgAcHxPIQb9xZFkl8sP3fZQzDnFzb3VbN0++jS25tg1EOfgFVFL8ASp9VPtf9Yxcpww1XUwzQ/3ER6/aciJoklzy8Iz1ZiQPdUXTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmptNcWrK0Wse7VDXUmUvzb21xGh5dE1N4aXqer08gc=;
 b=MhxAg8oC53ZxWpTlSC6HkwuMQ+3LhpePR9GjnC9ZKaL0oV0gJ+RilHr/ahAULdl9KpoxlgVtBIxIDwIyizFgKF5hNCRKQdWORgwEx+nmDVPMo1/OmQcKZu6Oz4/c4n4aIFPZDv7Q79QrjTe0AGxTnE48PA37HsP8BAXgiRL3jn0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:43:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:43:49 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 02/13] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Mon, 12 Apr 2021 19:43:39 +0000
Message-Id: <d6a6ea740b0c668b30905ae31eac5ad7da048bb3.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0151.namprd04.prod.outlook.com
 (2603:10b6:806:125::6) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0151.namprd04.prod.outlook.com (2603:10b6:806:125::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 19:43:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e1dcde7-3406-4f12-7c76-08d8fdeb4b22
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26854A659719106FC5B7C2678E709@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9aOZX5Eh6kUSw3otxtP0cmdpPq4BUNhKQNVK4dZqhnMd91u+RKeB8V6Z6MGc9jwU4oosFXk++BUQAfrmH0Abmml7y/WHn2aD6MMlQo0fNLtDZCexSqdYpn21HjRqt8QndC4cTQGrNoVZCKzJPJe7NFiUrIee4Clm9g92FfNV+EdwVqWbo6XE1xRaQvAzGHFp4R46DPvbaYpzCmTEAer9GA2qNDn4SsG01mqnMOmQ1uJY5jRPPSpjwQum/+lp1W2BWsNhSvN9nan1OuNZJFULJVALUfMqQAetp8acSQ9/tZUQ+gN0I141JWVWQLAuHY5lPkCxC5tTOeJ4/1xXH6/s5Yf4M6cq+drT8mQyLhtNAZKAP1p/gnhbh4x+IjLvGkGIyvt97ScRfgDiudpzjACwUzuCsK6GhUoGwnyKj43hZ1VxYi3M/H15+5lE0NHcqLFIzD3454tQrZ/CzxckTrqj2cQcKG7cm+DeyCwtp7d6jgoEcu+BcB88/yV+f4SHqzFpGsEbwLx8RIk/loKABmUbIX238dZRVPlUxzFmXggE00vdY6s2nUU3OjTNHJuoBnPDAo8FY9edo9pAmjJ8mJhj11BrlhrFILO1LhMSsqzNJJLNyZj16Q6wCox01MuFnndSBrwvoDfQy3uY2vTTzBK3Vuffgd+0e5fRI7933ZY4zA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(316002)(6666004)(38350700002)(36756003)(8936002)(38100700002)(478600001)(52116002)(6486002)(16526019)(4326008)(186003)(7696005)(66946007)(66556008)(2906002)(66476007)(956004)(2616005)(5660300002)(83380400001)(86362001)(26005)(6916009)(7416002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T25LZTBZRjkzUWs2ZnhUTzl0OUZ6YWljdS80bVNsMmNwZDBIN3BScDN2K09R?=
 =?utf-8?B?VjdRM29CajNkZFF2RWJIb0lBVDdWUkZ4bFhTcW5ENUVHZEFOcmN0S2UvbnNn?=
 =?utf-8?B?RTRJVjZKOUs2bS9NUkFtMmQrMTU4MDJUR3hjT0R1VS8zSEpxVmVTanBEbEdD?=
 =?utf-8?B?MnRMZU9lK1dOTjNwZVhzOWZIczQySS8xQnh2YlllYWgyVlhxeEZEVTBacDFL?=
 =?utf-8?B?QTFSNXBaaVhFa09sYnVKNW1STHd4OC9TcGsvM2FCMmQ2aFV4eVJYQXRaR0Mz?=
 =?utf-8?B?WUpiS3M2TXhFVUFRend4emtKZFhaYjZtdEJ2UjE5VzJlV0hHTjNIWTBIbnlP?=
 =?utf-8?B?eHE4QmRZTjFEcDZmdnRoQ1I5ZEpITm91NFVyYm5IVm5oSHk1NWpHZlFpUHZr?=
 =?utf-8?B?Z2J4dGU3RVJEclhYZURuQWNyWHowN0NEY004NFVWRVdVL1ppYStUNTNPQlRj?=
 =?utf-8?B?MktRQm95a0JWNFB5djVybEMwcTRpVngyUm5HYU5FclVUQXZnTTdCU1JRWUpp?=
 =?utf-8?B?eE54YXplMDh2UGFZMDU5K3NURVl4MlRWUjZ3VHcyc054NTArTndzWlEwRzdq?=
 =?utf-8?B?TzZhUmM1akY1L0ZvSnJaV3l5OHdGYVhNcjZnTUEyeDBXT0JyQ2hjbS9sZ3U1?=
 =?utf-8?B?c09YSlJ3SEpOU24vcDRqL0VQZjhnRG5EcUJ5WDhFL1ViY2hCd1dNdDhBeWJk?=
 =?utf-8?B?cXg5RXI3UkFDOG93eER6L2F6aEJ1QUtRQk8vU05KRkRGbGhyMkZnQjBlcjl5?=
 =?utf-8?B?UzdRQ0FXU1JrYXRBczNPeDdnK0NsMDcrdTI2MkczUW9McHdYWEhEbGcvTS95?=
 =?utf-8?B?OW0rQjErY2twQXdIeERkOHBUZ0hpdkFEdzdBSE5JQWMwOEVHUkNiUll4QUwy?=
 =?utf-8?B?SUY2SDVKRXE4RFlYYWNja3pCYTlaekZBUFpKZGRXWDhTOG02eFlnRmRZanBG?=
 =?utf-8?B?dTZxL0toWGxrMXNyUmc1MEJjWVJiNDc1eGtsMmZZTkNFWmVzRjBNSDNYRm9s?=
 =?utf-8?B?Z1Q4QTBPNEJ0VTNCOVFDUHBUTjVIc1JkcGdZaFNrdXNZdFFNMi9XRDFSY0V0?=
 =?utf-8?B?M0I0ZnNrd2VpYmVYSFVzbVZHK1Z0RnZTalVld0hJcGtCZVQvcGJtNjJXU0J2?=
 =?utf-8?B?b0JNQVlxcTFJSG9odlFGNzU3OFBwSGRHTmZ1U1NSNUZIVmtzeDVwWnArZzhF?=
 =?utf-8?B?MjFtWGtNOGp3WFlEODFudzVUMXdwNDhqTWF2dGJIL0Y4TVhTWUJJR3dkemJw?=
 =?utf-8?B?R090ZGc2OHVkSXNNYmp0a0h6NGU2S3c1V29sOVpGZnJzQys0MjQ5TklOTkMz?=
 =?utf-8?B?NmtUM2VKZUx1bStoZ1BZZ2VNNjZaZmpNR2cvUG5JaCtCNUVPcXpQSVpGSjBH?=
 =?utf-8?B?UHhpYk9TNHRzRURMRFc2U0RuVnZJbXVvQk9vSjBPVXZmRjJ0UEVXSXJIWFg5?=
 =?utf-8?B?aDUwT2NqTUxFdHBOLzgvUGZTYkFpSzFpaXNRVkpRZ3Z2UnlKMFFZTUdJWGVX?=
 =?utf-8?B?azlZTVBUS2dtYXNEa1Q5LzZMN2NtejRsVmtFMThVbUswMUxzRndub054dEd2?=
 =?utf-8?B?dzdNdWtNbDRrYUdMOUhzSTlLaXN3cTk5RDg2bjlyc1ZGS2tFRDluK2hrdXor?=
 =?utf-8?B?WTlEc2dJMi9UcENOS0ZKTVljaC9UMHozeXMzb2hvYUZXRmJkWmR0L0Jod3Rj?=
 =?utf-8?B?Q1FZUDZPd20rQm1jMFJmRmp5MUxaQThrekZhMVhXUVE3YWxZSlpNREZQRHBa?=
 =?utf-8?Q?xXMBfv0LidYYtL4ltYRBUmBJCy7oXKw2MXb4d+A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1dcde7-3406-4f12-7c76-08d8fdeb4b22
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:43:49.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHXbVSsrj8VwT1MW6nH0WhlrRkrnaPMy+6LBl8aX4O1tugUQ8I3TqTyGtkVZvuMgvQzolytgh9Z+v+PgKH6MAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used for encrypting the guest memory region using the encryption
context created with KVM_SEV_SEND_START.

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
Reviewed-by : Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 122 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |   9 ++
 3 files changed, 155 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index ac799dd7a618..3c5456e0268a 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -311,6 +311,30 @@ Returns: 0 on success, -negative on error
                 __u32 session_len;
         };
 
+11. KVM_SEV_SEND_UPDATE_DATA
+----------------------------
+
+The KVM_SEV_SEND_UPDATE_DATA command can be used by the hypervisor to encrypt the
+outgoing guest memory region with the encryption context creating using
+KVM_SEV_SEND_START.
+
+Parameters (in): struct kvm_sev_send_update_data
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_launch_send_update_data {
+                __u64 hdr_uaddr;        /* userspace address containing the packet header */
+                __u32 hdr_len;
+
+                __u64 guest_uaddr;      /* the source memory region to be encrypted */
+                __u32 guest_len;
+
+                __u64 trans_uaddr;      /* the destition memory region  */
+                __u32 trans_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2b65900c05d6..30527285a39a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -34,6 +34,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
@@ -1232,6 +1233,123 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+/* Userspace wants to query either header or trans length. */
+static int
+__sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
+				     struct kvm_sev_send_update_data *params)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_update_data *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
+
+	params->hdr_len = data->hdr_len;
+	params->trans_len = data->trans_len;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
+			 sizeof(struct kvm_sev_send_update_data)))
+		ret = -EFAULT;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_update_data *data;
+	struct kvm_sev_send_update_data params;
+	void *hdr, *trans_data;
+	struct page **guest_page;
+	unsigned long n;
+	int ret, offset;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_send_update_data)))
+		return -EFAULT;
+
+	/* userspace wants to query either header or trans length */
+	if (!params.trans_len || !params.hdr_len)
+		return __sev_send_update_data_query_lengths(kvm, argp, &params);
+
+	if (!params.trans_uaddr || !params.guest_uaddr ||
+	    !params.guest_len || !params.hdr_uaddr)
+		return -EINVAL;
+
+	/* Check if we are crossing the page boundary */
+	offset = params.guest_uaddr & (PAGE_SIZE - 1);
+	if ((params.guest_len + offset > PAGE_SIZE))
+		return -EINVAL;
+
+	/* Pin guest memory */
+	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
+				    PAGE_SIZE, &n, 0);
+	if (!guest_page)
+		return -EFAULT;
+
+	/* allocate memory for header and transport buffer */
+	ret = -ENOMEM;
+	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	if (!hdr)
+		goto e_unpin;
+
+	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	if (!trans_data)
+		goto e_free_hdr;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto e_free_trans_data;
+
+	data->hdr_address = __psp_pa(hdr);
+	data->hdr_len = params.hdr_len;
+	data->trans_address = __psp_pa(trans_data);
+	data->trans_len = params.trans_len;
+
+	/* The SEND_UPDATE_DATA command requires C-bit to be always set. */
+	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
+				offset;
+	data->guest_address |= sev_me_mask;
+	data->guest_len = params.guest_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
+
+	if (ret)
+		goto e_free;
+
+	/* copy transport buffer to user space */
+	if (copy_to_user((void __user *)(uintptr_t)params.trans_uaddr,
+			 trans_data, params.trans_len)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	/* Copy packet header to userspace. */
+	ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
+				params.hdr_len);
+
+e_free:
+	kfree(data);
+e_free_trans_data:
+	kfree(trans_data);
+e_free_hdr:
+	kfree(hdr);
+e_unpin:
+	sev_unpin_memory(kvm, guest_page, n);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1288,6 +1406,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_UPDATE_DATA:
+		r = sev_send_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1467,6 +1588,7 @@ void __init sev_hardware_setup(void)
 
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid = edx;
+	sev_me_mask = 1UL << (ebx & 0x3f);
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac53ad2e7271..d45af34c31be 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1741,6 +1741,15 @@ struct kvm_sev_send_start {
 	__u32 session_len;
 };
 
+struct kvm_sev_send_update_data {
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

