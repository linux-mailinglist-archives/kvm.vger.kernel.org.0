Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC0360F94
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhDOP5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:57:41 -0400
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:56416
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232769AbhDOP5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:57:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmrDpTtt2eG6AS3f7a5BLZWJ10dv7XZTHne7QaOXxpgfkRLJ2PIDB0D7Q0bO+yOtabzJbZonsXNd1Jw+g/EEkr1ZT2H+lkXhNC67w5Qzuk7+RR6luMRHfSygSSW/niIGuHMTmsyop7XGDAezRLEZhoZ9P0W9kJG/AZj2ztckcJG7sH5tXeG2KEgoK/AocfLuwvDLttSkm4/L4z8IcepjTjfPPWtiA7QTuzcowxmUy7iMQgSh+8GF+BLc4l20SERSzkD1CPfcN6h13c3vKSLJaz6AqiP7jSkJF6zt+JZh2gEqKrLwoiTK/MG/1/8jNkYe005GOLuw6kKAkdj9F2mnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du+thO9ohpgzgOkPsRWmn6Ieq9jDz6CtEVwC7pMeS40=;
 b=d0/xlIAZO1/oTOg5w+/QeTYRXLJpz4rP5qS0rxE9Nzw/dtnSNw5kNd1yctEh0P/XEIXUuRBefK8BnPnWkhFf+i/uYbvu3MnuAk9urj0UwnPwPu/kBTAWZPsGGGEjvnfoNvpmmXyxfYa1gd5AengS/bQgROslFLtVxWudBFInPg6ZDaN9visUsmgRVklZlSl1uF9pC4JQwyAN73LlIHKAiJ0/Bs7pjAn8Yf1B5F025BjytN396f/sOhLplo/ciGfgzIIk7/iiq0Z9qbOYW29tcFZzn2ii2bEsdEKLvRMsu0o1y1KsXYWFnmT4L2AZmLyFCegw9IwHav81AU3jE3pXZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du+thO9ohpgzgOkPsRWmn6Ieq9jDz6CtEVwC7pMeS40=;
 b=fzlABt8rp93t6AUs1OqrlZ5TStAuPYYTKTTmqF5P7kt7sKfHkpttAD+K+fjo6Y8S93ksKKXWi/wPraF7hRBuiHKFGeNtTdyKUJsR3E7L6D6XJ7PncEZvMz9l9WYN7l1O1XJm7B1dDEOnNPBHvcGIQul/23a5wY2GgabFHO1w0hI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:57:13 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:57:13 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 08/12] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Thu, 15 Apr 2021 15:57:02 +0000
Message-Id: <93d7f2c2888315adc48905722574d89699edde33.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:806:130::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR13CA0021.namprd13.prod.outlook.com (2603:10b6:806:130::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Thu, 15 Apr 2021 15:57:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 603a7daa-a8a2-46e5-8502-08d900272234
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592C0C35331421C804753018E4D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ol8JMrsSX6aUpGK4Q0+UPmU3K/ZQBl1Hnt0TZO2kjh5nKDephYyLCvwjvQSzBVKJlfMhsfdFqKsDum9e2ba0AoyyOL75I4/x+yKBZj2kmSOOutMsUsfdl2g2aKwRA6djqwKAonniPDAgOp4K3Hh2oqYGRDR/ussaAQMHOewByE0d/QCEF2HXMRl56SuAybcF7SzWKcNxXzQ6wxvAWH/VipH+U40pgwJ0zM7oqjTAKGQJZHwWOonYUW867spsidTI5Diqfbnetlmi80nCKbDBrP3/I+klUWQZAtWeykjIpbx6qYcwS8coxy9BqXBmEDulTKgfxARTrqh+OzLXI3QQBtZioVvWjAwHDPXRgxLbEvVkHKOe1XgZ24Y23oVS6fTkTQA6bexj/sYnKFfbSRTYMweIKwsljrPzGHKTe7xQvG0YRtsy+84xsYiLywKc2OBHOtNa1JXL4p11nOVzxTGrQI7S1UfRb9TIRbMtq7fHSVBmuDcjAMDYuoTl9or883JYPthF/CQKEvw8DAgdXpMqx3fi4fdNsQAu3J5ixzgKjQIeh7Cb6i1ZTZzH5Jl/QbPlzelLuqVt1pn6Ju27ZCJqmfRL6tprt4LiHUEUE+DdT30kXu2fsPG75ZukYPBay+arBu8WitK/30AN1x5NyAlTAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(5660300002)(186003)(26005)(956004)(66556008)(16526019)(4326008)(83380400001)(478600001)(6666004)(2616005)(6916009)(38350700002)(52116002)(86362001)(36756003)(7416002)(7696005)(8936002)(66476007)(8676002)(2906002)(66946007)(316002)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8FW9IsnbpVzwhLkhBnJbNo7fTG0Pr1wPCIgin2btFAIz3qvBM+mWtFcJ/oxO?=
 =?us-ascii?Q?yHuOzHTvBYxez2ponFLa4Zx7WrUG15G6DayyztDibr932Fo+hAQhsWpP1KuP?=
 =?us-ascii?Q?PqCl+0L184RjCUQOtaHXZM+pdno8g5OhqFguvKjWegQhnFtEgxCUw4Tv1E0g?=
 =?us-ascii?Q?co1dWaABm8vCWKpc53C4eWH2Yf86pgwHrYYtbprey8ZEWXWT+yTikYFyEQt7?=
 =?us-ascii?Q?MN1bZBqXOGdix2/lSB0GtWgD1cdLTBcNUpG9YcsPHVJgbRyUobuCw3EcxTG/?=
 =?us-ascii?Q?ibYBzQLGgo6Isf9pK1cv3eYUwc8hFnM8VeNWGuwew/ruQXaIbSIHhWXFjG0B?=
 =?us-ascii?Q?1U93g6RebG8ED5XR83fdaFwqRH5yp+VPr0GxriYEUDGGZ112eCsKrSziXPyD?=
 =?us-ascii?Q?DV6k2a1PORcGPRWd7AnlQ2zEw4nYPkbT68+/j9AViiaqZyOQ5lu90d7k7zk9?=
 =?us-ascii?Q?QT6QOYvAv5KYSa0Ewonj4+BlLzCZ6C72ArFmF8XDvft4SXn+on19oJVsAI4i?=
 =?us-ascii?Q?rO8c9ExBKsfeih07bzowAiCfwVHrPX0tZCt46HMCTDFm7gpQuXgD9jhgcfm6?=
 =?us-ascii?Q?DylL1djMe+M6zi5WBlGhjKjaOVLC1FTlzkXHRftmf1qa8r84PSa6J+XS2gRe?=
 =?us-ascii?Q?bdtzwQpShIxPYiSZbxbI0/FF382m+uAWaExwcbjM1pY/RXooQ3F+4fDS5FFn?=
 =?us-ascii?Q?Keu0T4RfBNAHd14/eoTBrjaQpXk6aYxsXh8HZyCWj/R0h/YkYANnS1vT3J0X?=
 =?us-ascii?Q?y6Q/rnBi225D9ehzG4vKN+V78aENiTtRz++MxN4ULdqV9HcttFb5/47t3ymr?=
 =?us-ascii?Q?Am89vd6KNnco5oswszewaXYIL/zc5Nl4RFsZcXtRt/tPR0fWikfKRE6DxCJI?=
 =?us-ascii?Q?Gr6DoJBi4GiqC4AVEuklN1ubZxtzh8mSQvAEy/hI4aVDmLjYfae5gFCVhYWb?=
 =?us-ascii?Q?N22B7XJ6B3W5HP/L99nnb0zNYA9cXFIoHZt63tUV1QSLoX0CumIJtD7rTePL?=
 =?us-ascii?Q?7t5xWrDq1RM1+znwTzGAllPNDHP6a/3ZeBnVmfeTjNSt6QSnjoNiAkwsX5Gv?=
 =?us-ascii?Q?szekZluaiq/zv3gWPaFf9TX/fE4ZHGoX9kasbLwxwxc65vXNmBgjNySijMw1?=
 =?us-ascii?Q?vPd6wVHuRes7MJrKZYHdarkX9vessXMURZAj7biIxBZ4jVCNOLcHMUR+9wek?=
 =?us-ascii?Q?5cs2RInNvxRmWfqOUHzROIAk4EqONsfL4ppPs41V0tqEDHvI1cJ9i7pQyypr?=
 =?us-ascii?Q?PDUlWr0Tw43fdM3xN3Th6uzUb9yRbyhnUOcAwBb5UFXSzTf0HuFg1TmrfGhg?=
 =?us-ascii?Q?8WEQKpKlrEVGfgfN7V6NK+4Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603a7daa-a8a2-46e5-8502-08d900272234
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:57:12.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkpg1QiAhrCL+96wI9xhU8Sfy7sIww6CzRaUCX/xWxPlkh23lsXPo7MMc/6M3n+XhhYQdhz9yaXukyE3UZ55UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This hypercall is used by the SEV guest to notify a change in the page
encryption status to the hypervisor. The hypercall should be invoked
only when the encryption attribute is changed from encrypted -> decrypted
and vice versa. By default all guest pages are considered encrypted.

The hypercall exits to userspace to manage the guest shared regions and
integrate with the userspace VMM's migration code.

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
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/hypercalls.rst | 15 ++++++++++++++
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/kvm/svm/sev.c                |  1 +
 arch/x86/kvm/x86.c                    | 29 +++++++++++++++++++++++++++
 include/uapi/linux/kvm_para.h         |  1 +
 5 files changed, 48 insertions(+)

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
index 3768819693e5..42eb0fe3df5d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1050,6 +1050,8 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 
+	bool page_enc_hc_enable;
+
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
 	struct kvm_x86_msr_filter __rcu *msr_filter;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c9795a22e502..5184a0c0131a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -197,6 +197,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev->active = true;
 	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
+	kvm->arch.page_enc_hc_enable = true;
 
 	return 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7d12fca397b..e8986478b653 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8208,6 +8208,13 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 		kvm_vcpu_yield_to(target);
 }
 
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	kvm_rax_write(vcpu, vcpu->run->hypercall.ret);
+	++vcpu->stat.hypercalls;
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -8273,6 +8280,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS: {
+		u64 gpa = a0, npages = a1, enc = a2;
+
+		ret = -KVM_ENOSYS;
+		if (!vcpu->kvm->arch.page_enc_hc_enable)
+			break;
+
+		if (!PAGE_ALIGNED(gpa) || !npages ||
+		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
+		vcpu->run->hypercall.args[0]  = gpa;
+		vcpu->run->hypercall.args[1]  = npages;
+		vcpu->run->hypercall.args[2]  = enc;
+		vcpu->run->hypercall.longmode = op_64_bit;
+		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+		return 0;
+	}
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

