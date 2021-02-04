Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3EA30E8B8
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhBDAmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:42:11 -0500
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:5024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234410AbhBDAls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:41:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/pDofn1WLrFMUWrQpudKmDGm7q661pBuDnPswX+8p4+TKl+aT5OGv4NBKFoafL6fdJZQhPuYOa4AGVuDZef17ZUmqP1yR9JXXADGGbqtT2C67pioNVrGYc0FXLMPOTQhrXkR7aR8vPEd/DpKbUrLesilEnlMigjyPJkD64aHEqBHpGXgoex4aaZrK595QFxQ3adQ2SRlGVKoyAYBw8woY9MrlzRhJsv+1fgkFAYKJNGb8pFV10MNIs2Vittmq2l7V/sIKjFvF+RJbq5+A0kLGm8x3Kp+I61Zj0i6f6Ke9Zg08vPwAXxKkHWY7agcFWeMFWY0EO2F2CkQ05vye/3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGONI3/EKRdB5D1A0wwvnXAIPORbbYPpLkd82kLuqi0=;
 b=dixA2A7RJ+36pkc/rlWr3JOg8l0yiaannVhcQisWhhzVS7udoQjuQ9t/fge5PsRLzc2h1LAyQsl4uAS76kxmQKtcqDine40FCjBuwlk7wC/QZg03dJlUnvdykCDqrW6W0Rc5jIRzG4sbmcR9F+58qR8etg4X/YdXXIAa6UzZDB2InxCHspQpw38PLuTof8is64/ohZG1E1nRsVkawJmNLdaIUzs7sGXmtlHTSmnx4X+NjhAvAGbGl1BZlBf3BdU2otVgKeN4JM8tBWV0uYResjlOxhHNXR3SD4iB8r12VfEV/aHhpHBBfUhZXBZnV7bbEuBSdPTHqb9Jos+eIBv43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGONI3/EKRdB5D1A0wwvnXAIPORbbYPpLkd82kLuqi0=;
 b=ygyhzQG9vG8miKY2wWpHm7ob3EBABD7DfGRJXLTJfVo4PnM7whhWaEEw3Omq9nPYTWfvNeWHYFHzvCq9D+AaoqiViHiPKh/kXCRk9mJus3qDiXJzYJ/8AT61jSpehk2piwN4d1Dze00BzbFzmD3GsivAbcxw6KIfm0LYMj5xJiQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:39:42 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:39:42 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 11/16] KVM: x86: Introduce KVM_SET_SHARED_PAGES_LIST ioctl
Date:   Thu,  4 Feb 2021 00:39:32 +0000
Message-Id: <89a3e3218f3b08be562f68a9c0d736030fff9b1b.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:806:24::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0106.namprd13.prod.outlook.com (2603:10b6:806:24::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Thu, 4 Feb 2021 00:39:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cbe3a24a-8c76-46b2-2118-08d8c8a55c4f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384F5DB3753A02DC2F5E49C8EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0LbrfngPNiu4lhaYRMeNbS6GapLIsC72qB5+hC/KbDeW62MQ9/fGDGtI12FsHhKWjFowApHMqsVWlMTVuSRLjpEjv9TULOhJTZ5yexWItGUnEJIvb7n/3dfTdat7jae9axjRmYD/iaIBjfn9Gs8sQs2GwpIezw6i3FkOTVdmW/dQBJpfq+bvq3QjoC/S2H37+B93a7nU365FZadlg1GdMNuZ6eCudR8mbUIPwY/0I04hCQ4nfrdl1UK7nj0GFx4g+dB3DcxAY/oKo7rNO0vjbvEvhPJYCe+8lpL2S1hb+o2Z8aSLJrJjHcQWUvZyQfVg4Z1Qtt2iKEXNSi0MM2ErPwJtXJpu2bUN7zu3NEQOPiIGRbqrgEh0SP1bGuVLlsMCXPlstQ8AIKjcfwZN9DpSUQzpn78jMmr7hUf6nVENRS6MMB4MVx7H2NviOe1ZwtEZlCmBMLKZdT2Wa+oMGAPMF8AccS3VYzOEV4PVkYEb/hquwyAK87PzYHdhX2xYHOSGjvYzRR69mIYa2+I4bxDKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WFYwR3hvOVhDYnU5d2hYRzlqVFFNSzJYN1ZiNVhzR1pQV2c4dm1mR0g3Umdv?=
 =?utf-8?B?U05GbWlDcmxMY2I1MUp3OWhMVzRqWG5FNWR3ZVJBWEpWazM0TWx2ekczYXFM?=
 =?utf-8?B?cjVUNGVMemFEYklYYnY3ZSt4L2N1MVBSQ1hiaUwxcW9TVTZ4M1F6QlZ3Tjhm?=
 =?utf-8?B?QjJFQnJGazU3dVEzR1RvdHVuMEF1dmtncWtsMXgwZVpsS1A1OEgybzNYWEVT?=
 =?utf-8?B?NGg4N25XaWVhM2o1K01oYUlwWWhrUXcrK2pUekxFQm9mQnB4aHhGakgvY2Ex?=
 =?utf-8?B?UE5wVzBYT1NYS0phaXZUVy9jRjU0SDJ1anRQd3RFcytZMmNnUlVXZ2pndUlu?=
 =?utf-8?B?QUlmd21LZEFwMTBqaTluaEYvOVBvSUVIamdWZlNJMllqME54UFlUZjl3VnhC?=
 =?utf-8?B?WExGWCtGMFZPam5RYytxK3MrOVNUVGxra1UzQmtnZ1RuWjgvZzhqRGRHY3VN?=
 =?utf-8?B?WmYvYzlwR1gxeVprblZDWTFIWjR3SjZHb1N1bVlyTGlzY1BwYW1Ib1ladU00?=
 =?utf-8?B?TEgwYWdXbHF2MU14V2hxbEdNYzlPQWo2YTcwLzc4QXAwTFdIaEJxUGkxRnlZ?=
 =?utf-8?B?ZnpHU2dCZjRtY2ZEQlFmNHFJN3NBQUFZVUpsYTEzY1NqeWRzdFJZWnZQdkpK?=
 =?utf-8?B?anl0QzNub3pYMDl0T1l1RndHc1lENDNkbDhObUxDQzFhb2FLTU04NWJIbEtl?=
 =?utf-8?B?eVJYUFlVM09JeEZ5WHQzdHpNN1dUM0hmRUpJUDBXdmZnRXpualdPeW9lUHBp?=
 =?utf-8?B?UlZpN3dRNHZmTzIrNXEzczVsbkR4bFV1VDVPdTk3VHdsSEdWWFpMSHdIQmlu?=
 =?utf-8?B?ZzB2OTdRYU5FNnYzWmhrdEtCWE04Z2JCZXJJV0VZdDlvK0tnQ3o0WUVkeUJs?=
 =?utf-8?B?em1wRmZSYWt6bnE3UEFlWndNbjQ3K3lJQWh2R1R3VWNwcHk1cFB5Tm95eUNQ?=
 =?utf-8?B?Z3lqYXdMbVhHNDRFa2FNS2RYVE1ablJuWXBGLzZNZ0p2S1lXMmhXMjBHaFR2?=
 =?utf-8?B?KzY4b1FETWR4bVVkcjc2UTlxTkZ4ZzhPMjhQYnp5S2IwQnd6SlpScWg3UUNE?=
 =?utf-8?B?UWtkaTB2azZ2djFDVy9YbDE1QVlkbG03REpZWXVtcTdOaTJVcTlwaEFzR25Y?=
 =?utf-8?B?L3YvakNpTEpPTlplWTUxYlp0cTA3dHN2VklSOE9vYldBM1JsMGx4T05wUGZX?=
 =?utf-8?B?aEl2M3E3UEpGY21sNEJpdER1UldrdE9XNjhyVlJNYzY1WjUvY1ZUdDB6K1ov?=
 =?utf-8?B?RWNjdDVqVlVxZ0k0M0xIdWthcjQ4SDF1d3RoOXZQRko0M0RJVlhGZjhkcURk?=
 =?utf-8?B?LzRRZllRbzU5TkFxYnRmb0NyRm5jUnlQQnNVQ2FWNzlSemtudnJERFl6OUs0?=
 =?utf-8?B?eGZyeDhWL1hwTEVvSnBXZGVJTUJwb2RDNWxES0YvWDRWZGlzOGI0WFZqZFBh?=
 =?utf-8?B?Q1V6dlFLV2NnSFl3N2dPWXZQKy8vSVF2RmFxaU9WZ1V2MWVjN0U3aVdldnVU?=
 =?utf-8?B?aFJBd0xnN2M5YXMxTE1FRkRUeTBhLzYxL3dmc29VOFpJUk1hKy85NU1hSE4v?=
 =?utf-8?B?VmVUZ3FMb09MVUxTczRRRTltQURIVThqSk9FSHJIZ1QwY2RocXVwN0lnZEdN?=
 =?utf-8?B?U0c1YXQ4RDlZaVVFNVk2aUhYZVIrYzh2eWZTNldZaTVrYjVGbVRNZXBBVU1z?=
 =?utf-8?B?cVE2ZG5JaERoNEc5S1l4TnhCNUV2NUFqMjRGNEZuakgzMkpDbGJEOVc4Y2c2?=
 =?utf-8?Q?ypJQX1zH2abHvvAK+6YQfhFjtuXVyPz8L2r6UzS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe3a24a-8c76-46b2-2118-08d8c8a55c4f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:39:42.1351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLu3i6H1jmvyu2LwAzX/Q+QTEMffhhPjQg4nFiXO4dxG8veqzcZSyULmQuHS46K8z1ohBT69vCmKGh8iTVZt0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl is used to setup the shared pages list for an
incoming guest.

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
 Documentation/virt/kvm/api.rst  | 20 +++++++++-
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 ++++++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 59ef537c0cdd..efb4720733b4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4701,6 +4701,25 @@ This list can be used during the guest migration. If the page
 is private then the userspace need to use SEV migration commands to transmit
 the page.
 
+4.126 KVM_SET_SHARED_PAGES_LIST (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_shared_pages_list (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_SET_SHARED_PAGES_LIST */
+struct kvm_shared_pages_list {
+	int __user *pnents;
+	void __user *buffer;
+	__u32 size;
+};
+
+During the guest live migration the outgoing guest exports its unencrypted
+memory regions list, the KVM_SET_SHARED_PAGES_LIST can be used to build the
+shared/unencrypted regions list for an incoming guest.
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
@@ -4855,7 +4874,6 @@ into user space.
 If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
-
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd354d830e13..f05b812b69bd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1305,6 +1305,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_shared_pages_list)(struct kvm *kvm,
 				     struct kvm_shared_pages_list *list);
+	int (*set_shared_pages_list)(struct kvm *kvm,
+				     struct kvm_shared_pages_list *list);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 701d74c8b15b..b0d324aed515 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1671,6 +1671,76 @@ int svm_get_shared_pages_list(struct kvm *kvm,
 	return ret;
 }
 
+int svm_set_shared_pages_list(struct kvm *kvm,
+			      struct kvm_shared_pages_list *list)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct shared_region_array_entry *array;
+	struct shared_region *shrd_region;
+	int ret, nents, i;
+	unsigned long sz;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (get_user(nents, list->pnents))
+		return -EFAULT;
+
+	/* special case of resetting the shared pages list */
+	if (!list->buffer || !nents) {
+		struct shared_region *pos;
+
+		mutex_lock(&kvm->lock);
+		list_for_each_entry(pos, &sev->shared_pages_list, list)
+			kfree(pos);
+		sev->shared_pages_list_count = 0;
+		mutex_unlock(&kvm->lock);
+
+		return 0;
+	}
+
+	sz = nents * sizeof(struct shared_region_array_entry);
+	array = kmalloc(sz, GFP_KERNEL);
+	if (!array)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(array, list->buffer, sz))
+		goto out;
+
+	ret = 0;
+	mutex_lock(&kvm->lock);
+	for (i = 0; i < nents; i++) {
+		shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
+		if (!shrd_region) {
+			struct shared_region *pos;
+
+			/* Freeing previously allocated entries */
+			list_for_each_entry(pos,
+					    &sev->shared_pages_list,
+					    list) {
+				kfree(pos);
+			}
+
+			mutex_unlock(&kvm->lock);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		shrd_region->gfn_start = array[i].gfn_start;
+		shrd_region->gfn_end = array[i].gfn_end;
+		list_add_tail(&shrd_region->list,
+			      &sev->shared_pages_list);
+	}
+	sev->shared_pages_list_count = nents;
+	mutex_unlock(&kvm->lock);
+
+out:
+	kfree(array);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 533ce47ff158..58f89f83caab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4539,6 +4539,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_shared_pages_list = svm_get_shared_pages_list,
+	.set_shared_pages_list = svm_set_shared_pages_list,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a777c61373c..066ca2a9f1e6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -478,6 +478,7 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 			   unsigned long npages, unsigned long enc);
 int svm_get_shared_pages_list(struct kvm *kvm, struct kvm_shared_pages_list *list);
+int svm_set_shared_pages_list(struct kvm *kvm, struct kvm_shared_pages_list *list);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index acfec2ae1402..c119715c1034 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5731,6 +5731,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops.get_shared_pages_list(kvm, &list);
 		break;
 	}
+	case KVM_SET_SHARED_PAGES_LIST: {
+		struct kvm_shared_pages_list list;
+
+		r = -EFAULT;
+		if (copy_from_user(&list, argp, sizeof(list)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops.set_shared_pages_list)
+			r = kvm_x86_ops.set_shared_pages_list(kvm, &list);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0529ba80498a..f704b08c97f2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1573,6 +1573,7 @@ struct kvm_pv_cmd {
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
 #define KVM_GET_SHARED_PAGES_LIST	_IOW(KVMIO, 0xc8, struct kvm_shared_pages_list)
+#define KVM_SET_SHARED_PAGES_LIST	_IOW(KVMIO, 0xc9, struct kvm_shared_pages_list)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

