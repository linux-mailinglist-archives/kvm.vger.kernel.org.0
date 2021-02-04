Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91DE30E8B2
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhBDAlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:41:01 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234081AbhBDAkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:40:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRj5U2tf5uWPQLC+aYD7OvnU8P2KENIdrfjs7ojsKpuPBnAUmCFBj/mtlM+6xOHjRIoRFKDXL+19wbQ/f+4V0R2yHy7q1J6DHAZt08UUbNthr/XBZG4j9UHbcTsc4LhLztdD9kwdbxeNMfhNimdDkjuP/7IQICSaS4N+v5Px3MLIryQIhcCdP1i83vylZj0aftZuMDda4+1IGIca+keHY7ibDE4a4HdDlN35yyqLdVWZFsL1dyel2Kgs8yrTZqSSvwIKzY4Pk+CGfAqxSqOacrZZWzMnNrzD+MojNq3nT2YsixODwU0wznVKWYmiFtmsIXhHoDHzPhCKQG4ry33Jlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUfjzHBwzYVvSY8IBpI/TL3Y/V2zMRo9Pydf9XurvVQ=;
 b=ciKf6DeEKzyl8VzMYHUPAzyJb8gG0RTfrRafhgaoeaW5DVsLUu+2yC0V/kfbNQpC1+PGrJnYA0rKoXBGuQtqQJ0+q3ZtHtOB1nPKg2/fszQdbDPKioq2eUniO+cHwwem/HKUZeN6w0hD9Rg1h5VYcfcANTCpkNS8oVJw6N/ezrzLw7ZFKOMBreAJoo6uyj4Cdr0/Zf1VAPzWY/b7Orl2XX/ylQW9LsVk6cIrZJxcyZgZ6N+qp3QxJlZNjMP5BSLC+p+Ko9c/Fp3S/4olioR9iZd2LewDpywf5bP4dStK65nMgl58zaCVeDvBjLUWCrbFGQCSO8YQo5vP0hWOZgsbjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUfjzHBwzYVvSY8IBpI/TL3Y/V2zMRo9Pydf9XurvVQ=;
 b=480F44rSJ8jqgfUCspIFrm+TSxS3Eqowiyr/LlMyuT88aOaUaJjXjpJo+Xc6rO7c0o7/0+kz6qHU8pJ/gMx4WVKV6l1pr+NHcSFD8Md8EsS4m7Igi9snP5MjUfAj9Hi81+hQL4vf3Bw6ZM5kWuaPGgjRUIik3MprBl2SPEqcl7s=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:39:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:39:25 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
Date:   Thu,  4 Feb 2021 00:39:16 +0000
Message-Id: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:806:121::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0067.namprd04.prod.outlook.com (2603:10b6:806:121::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Thu, 4 Feb 2021 00:39:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 386e6716-db70-423a-e23f-08d8c8a55298
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384821428C355BE7C1586D18EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAsIZ6khAeA3yw+qepFf4DMMRGkuEEBVvFFOBUrIdEhsjUyGgSwe3uFHp7PDfCCMubkYzEQ0IS4SQypgsNqhXZZpJEIOcSX0wARgFJUgHcY0YXJTAaXT4nPQpNc2wJ4ZF68VQryRoJFCk3rX8UwwYbnJgJcpZGGXipp767B9WxHKiDqz9Uj/C/G6uPEhVkQfr/yXpOBk2g9VU18R/GKHxtnN0CcFm/bsdn4BcUoYPWDpHzc9EnhOrGDe7RnJiS/c8Fl7S+CIj/MSDekMBdkBuHD3nD5EYiiXjBmlTHM24cPbe1kWJ3BJHpt5jy+AZJNCM1tWETTfgZEsRbM8SyCWyOf1ZBsIWJ1lHNA6WX44vhrO/0qNBWsrYfLxj+7ugNJvVajcP2XN8VQlxt2/3LxlpZwFNm/5UA19EwHUohTYkIQXwmsARw+vwIfbNMgVwT5jsqQ1h+mQT96vCVFdM+Hd/o9ZAWdpivriyCcfmn8QwN/nNVVTvp7bl23+sA0Dff7Tn69kYRrphwPRSsIiFQEaKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aHJNSWtGa1htSVNldG0vbjBnbnl3WDI0c1dGZGdKN2RlL25kUnlwUWZtOGFv?=
 =?utf-8?B?WEgwckErS21pK0ppQy9UUXpKejhqbmcvR29mK2ZteXlXalRjUC8xOTMwUmdH?=
 =?utf-8?B?YThkVjZzOTMxZU9zWEJSWk9OZXNvTndZdDFYVU9CN3d0SXFYQTg5M3RaSmYz?=
 =?utf-8?B?WEVKUVRRVk93R1E4TmNUdDlSbW10UHlXVHk1bERQcVJaRWV3WVNKZnd3RG5u?=
 =?utf-8?B?YkFzbEkwMzFtaHRNVUgza2pwNkRMOU1ucFhsc1lEUzR5VEtaaTR1N2pPczVC?=
 =?utf-8?B?S29HbnhrNnVwaUxuYk9VREpWYXB6cmdQT2c5SzdJRnNpdUlDcWpxN1ZxR3Fu?=
 =?utf-8?B?dUxwOXpzcXpQTzFKRVppRDJjOE1hdkVPWXp3cUpROFZnRHpzYlpHYkg5UHZu?=
 =?utf-8?B?NkpSN08vRzdGbjRoRVVVcDEzZ3A5VlJxMnFGdnlxenlIUlRWVWJuRDE0N092?=
 =?utf-8?B?WUUrTjNjY1RML2RGUjVqL2xQN2wva0Q0cVZrejhHU1VudlFwWDREODZaNU8y?=
 =?utf-8?B?aVV5V1J3UU8wcG5vdndkNG51NnF5T1A1dVVrWTFFN01pQnp0UDd3SmFsYWxR?=
 =?utf-8?B?Z2g2MEpEL1ROMlhGeGREc2YvcW9VWm83L3BkeExJZnozWVdrVWpFUkNrb1Fx?=
 =?utf-8?B?T2wybnFqZGdQY1dIMUd5NTN6ZVo0UUl0UWM0YVdURjU2K2ZjbWtzRjlnc2Vs?=
 =?utf-8?B?UWVFYUlEbHBPR3dBYkhEeU03KzZVUTJWbU9PWXVMMFhOVzE0ZStHZmUzd294?=
 =?utf-8?B?OThUSUZYaVg2dWY5QU5heWZ6VkY2VVBONEJyenNWVit4V2Zpc0dLOXlUMzF3?=
 =?utf-8?B?VWh5bmxzRUVLQUNvNm9tZnN5bUo4K2ptNi9GTjhMREhQTnV6V1RrOVNEbVFB?=
 =?utf-8?B?SDNZcHl0dDFlWFpYVmV1VlVxems3M1gwcElOLzRhYlptRXpibHIrL2l6dEEw?=
 =?utf-8?B?V0o1aTBveXUrSnpZMHRxZXNzVXNtekhlWGJGajA1Wkh5SkNqY1lmNmdYNnJI?=
 =?utf-8?B?aElBdFRGYzlJRUhtTTNzS3FJdldZeFRjM09wRkVDWFFuQjF5bGlOVW5jVTFL?=
 =?utf-8?B?cjBqUDJSK0NQMDFoUG5CZDU3MEp1REpOQWhETUNBRkRUaUlzMSt0Q0R3WUpx?=
 =?utf-8?B?bk02R3kxNHZRMVdWYkQvQkZ2OENJUGVUeVVVNEhGY1p3TE1wRGNyUlZhb3NK?=
 =?utf-8?B?aU04dEdmUk1nSXg2Zk9oT0ZZcE9uYWpuMWNtWDIrWVJJTE9uc2puUXpXN1Ex?=
 =?utf-8?B?Q3crMUZXdTlSVjBsTTU2SU92NDg1VHhvdy9laGhoWUl0cEZWd2IyajlNVzVF?=
 =?utf-8?B?K01XaGRFaXVuOVdwT253ME94QitxZ2Exd0FiWGJwb3ZKcG5lT1B3YVRMNDdQ?=
 =?utf-8?B?WGx1b0piQThjdVlzL3QvYmZTTXpvb1FSbllPdG9YbXJMV3RhYmtENGJTUXpV?=
 =?utf-8?B?NWNWYkFSTHp2QnlndHh5OEV2UXNhWHFCemdhRTdvd3kxbmxZNVB5M2NHRGMx?=
 =?utf-8?B?QVRMMDRhNzI4YlhBU0t6cmFHYUdHRXU3Yy8ySmpKN2tscUQ1aUhWcjUralE0?=
 =?utf-8?B?c0pjWWNRMnBDSWxLellnVHRrOVpOVkNuaVFya090aTkzLzhGOEEvVEk1d3pw?=
 =?utf-8?B?YkpLM1BIbkxpR1RkaXF0T3hWdGo5WHg0c2tqcmF5MG03NHNJTGQwTHd1VlRD?=
 =?utf-8?B?VE5pdjY2aWhaUERqaTNKQjAvaDJ6a1pneCtZT2lZb2JQRzRHd28wTzZkdlYr?=
 =?utf-8?Q?uH/G0UbbfrUNCkaYV20mqVgCa60I8u9nukgDEHl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386e6716-db70-423a-e23f-08d8c8a55298
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:39:25.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZxX/YVrygetXM6iLSMOdIOlf08XgwqooJkmcq0eT7v+O1taHIQDzNFEx8/aywcuPWQ9tqc9QOHqG8H/U11rXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl is used to retrieve a guest's shared pages list.

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
 Documentation/virt/kvm/api.rst  | 24 ++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 49 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 ++++++++
 include/uapi/linux/kvm.h        |  9 ++++++
 7 files changed, 98 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 99ceb978c8b0..59ef537c0cdd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4677,6 +4677,30 @@ This ioctl resets VCPU registers and control structures according to
 the clear cpu reset definition in the POP. However, the cpu is not put
 into ESA mode. This reset is a superset of the initial reset.
 
+4.125 KVM_GET_SHARED_PAGES_LIST (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_shared_pages_list (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_GET_SHARED_PAGES_LIST */
+struct kvm_shared_pages_list {
+	int __user *pnents;
+	void __user *buffer;
+	__u32 size;
+};
+
+The encrypted VMs have the concept of private and shared pages. The private
+pages are encrypted with the guest-specific key, while the shared pages may
+be encrypted with the hypervisor key. The KVM_GET_SHARED_PAGES_LIST can
+be used to get guest's shared/unencrypted memory regions list.
+This list can be used during the guest migration. If the page
+is private then the userspace need to use SEV migration commands to transmit
+the page.
+
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2da5f5e2a10e..cd354d830e13 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1303,6 +1303,8 @@ struct kvm_x86_ops {
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
+	int (*get_shared_pages_list)(struct kvm *kvm,
+				     struct kvm_shared_pages_list *list);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 55c628df5155..701d74c8b15b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -50,6 +50,11 @@ struct shared_region {
 	unsigned long gfn_start, gfn_end;
 };
 
+struct shared_region_array_entry {
+	unsigned long gfn_start;
+	unsigned long gfn_end;
+};
+
 static int sev_flush_asids(void)
 {
 	int ret, error = 0;
@@ -1622,6 +1627,50 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return ret;
 }
 
+int svm_get_shared_pages_list(struct kvm *kvm,
+			      struct kvm_shared_pages_list *list)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct shared_region_array_entry *array;
+	struct shared_region *pos;
+	int ret, nents = 0;
+	unsigned long sz;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (!list->size)
+		return -EINVAL;
+
+	if (!sev->shared_pages_list_count)
+		return put_user(0, list->pnents);
+
+	sz = sev->shared_pages_list_count * sizeof(struct shared_region_array_entry);
+	if (sz > list->size)
+		return -E2BIG;
+
+	array = kmalloc(sz, GFP_KERNEL);
+	if (!array)
+		return -ENOMEM;
+
+	mutex_lock(&kvm->lock);
+	list_for_each_entry(pos, &sev->shared_pages_list, list) {
+		array[nents].gfn_start = pos->gfn_start;
+		array[nents++].gfn_end = pos->gfn_end;
+	}
+	mutex_unlock(&kvm->lock);
+
+	ret = -EFAULT;
+	if (copy_to_user(list->buffer, array, sz))
+		goto out;
+	if (put_user(nents, list->pnents))
+		goto out;
+	ret = 0;
+out:
+	kfree(array);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bb249ec625fc..533ce47ff158 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4538,6 +4538,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
+	.get_shared_pages_list = svm_get_shared_pages_list,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6437c1fa1f24..6a777c61373c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -477,6 +477,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 			   unsigned long npages, unsigned long enc);
+int svm_get_shared_pages_list(struct kvm *kvm, struct kvm_shared_pages_list *list);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f17f0f9ace7..acfec2ae1402 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5719,6 +5719,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_X86_SET_MSR_FILTER:
 		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
 		break;
+	case KVM_GET_SHARED_PAGES_LIST: {
+		struct kvm_shared_pages_list list;
+
+		r = -EFAULT;
+		if (copy_from_user(&list, argp, sizeof(list)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops.get_shared_pages_list)
+			r = kvm_x86_ops.get_shared_pages_list(kvm, &list);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c4e195a4220f..0529ba80498a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -544,6 +544,13 @@ struct kvm_clear_dirty_log {
 	};
 };
 
+/* for KVM_GET_SHARED_PAGES_LIST */
+struct kvm_shared_pages_list {
+	int __user *pnents;
+	void __user *buffer;
+	__u32 size;
+};
+
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
@@ -1565,6 +1572,8 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+#define KVM_GET_SHARED_PAGES_LIST	_IOW(KVMIO, 0xc8, struct kvm_shared_pages_list)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1

