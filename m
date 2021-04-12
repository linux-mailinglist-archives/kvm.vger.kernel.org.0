Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510E35D15E
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhDLTpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:45:54 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:2017
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237676AbhDLTpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:45:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqjb2/MNJBfbsym00SuXeQ/xCotGEfRtjdltsBv00/IZuzQ5Ylg1Fb82/ebAt7K/Zx+FIR+USnZkC19AixjOFNFer/ozkYpuhtalNKCQTPc4ObMuM/eoFiNhybSuXVHFcZF4x/DAhkqp5+Zf5/bssS7nuk3fmVAEskO5EVbNKZoClbmvhqc6P4BUU231ZM9SOLWVfFBwF7XgXBhOoI1iHCa5hkg+lksttXcRRobA58f+pfBCOz067h1NqrK3oqaGXSxErNRC3Md1WIpP51Z/St1uqmQCivLWOgqE6287Yu63kpYs6SYbGP8e1Fq+9d0lEvR8PZB21w+NhUz4fIX/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGtdcGrqVZU6Laq+07FKKoBBCHS3Yn7tXVpLwRGk73Y=;
 b=jE4V/+dDmo71bMy9yyhi0NFRDWqt1Gu8vTt7zinSP+mYz75cw0mV5SDYu3rdNNdL7p+ddp3IbHbKDZqkSmihSOVt/NypJLI/JDWc8QbFgEWWRB1UsozxfaoTKXh5oR28GCE9JN7BcGNy95Bn8x2MmRQiKBPT0hH/Fgz0ogNabj737jsWFgx4JQUWQRTpV2D0LjSbMeEVjEorJiASYZNrtjCNSr71C6OUhWPYy1h7rKPUoIxiTxs9/ghRBRKQ60ov9dZtO9frEnnII8ZKBkG0jeH2LyQc2xYZ4sxl2ohHeh9HDRlx6guGMuTSyUjYk2EWnA4Wm+Hlw6x4XFzeqA8RDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGtdcGrqVZU6Laq+07FKKoBBCHS3Yn7tXVpLwRGk73Y=;
 b=I96m8/M4n2/7lbHvhfLg7fhg+uV4TaPJorY0yAdfh/55zMyGV5zTqrQfS+w7dgroGxLJ+WI68pIfZPmO8jp1r9f6KyR//gFz5WEkzZowbx4gp2SH5vjB6VYeejUzEyA9EwwFbHUYqsUfMtspyTh5AUF+iwpfeeESM6g+TPqbQIw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2367.namprd12.prod.outlook.com (2603:10b6:802:26::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 19:45:31 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:45:31 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Mon, 12 Apr 2021 19:45:22 +0000
Message-Id: <93d7f2c2888315adc48905722574d89699edde33.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0002.namprd05.prod.outlook.com
 (2603:10b6:803:40::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0002.namprd05.prod.outlook.com (2603:10b6:803:40::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Mon, 12 Apr 2021 19:45:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9eebfb9-dcb9-4fe5-a225-08d8fdeb87df
X-MS-TrafficTypeDiagnostic: SN1PR12MB2367:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2367B01D1372500498EC015E8E709@SN1PR12MB2367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uQkNUiE9+SbCdU3vyGJLUHLOqLLtl3YYydvKFDxR3pyR8C0xHkvJOI4N1IQwHHqIQovhx1/9FC3bQUFpskW3/PjXNfuLtbQbVzGnSpWN9vSdp3jabObhG2MYlC8qr3NHFnXJygWN98CDl0IZKNJboR8DHByzoTlTp6+jfM5sKEIvo4MyH+aC/4Vbq5JMr3MBQnUpMvU9OFnMmiok/rosQQu9QHFyhlQN+COUV658bowFxJLRNIici6GDeF1W7JenX5OksiU6jd51wWUWy1wIiJnU8mLN1AUr09jhxm4Kx6opv3TgkRf6itZPUPBKqFPzVp1g5gkAmQ5es4g5HBQVLL0mOYLvHzlbZUcVshFW9eXvPQrc4ArlX34yD56O6vF7Ux6elh84+xwd2XgksHdu5TEJVgo3CkSPUs0p76+aOrzTvdBPujY9woHtaocMlaA0YleZLAmmqzxwf4a1aHpya+wylJUrgcZXYeDgziCEygF5OKBb16ykvcxjPWaJNf1F1ie/HzAFEqa1GSSPoKVzm2FUtP+66IxjBGiQ737X3unv86Upx8JPvW/IUDTZZatLLqmZ6mwSJeV4635AZScNnGPg8sC0J88Wu0mMW11n+ACNZkLQEAdVB4OZEzsSPxfHf9GB1luh0ND4iF1jrKHSdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(6666004)(36756003)(16526019)(7416002)(38100700002)(6916009)(956004)(38350700002)(2616005)(8676002)(8936002)(2906002)(26005)(478600001)(5660300002)(52116002)(86362001)(316002)(4326008)(83380400001)(66556008)(66476007)(186003)(6486002)(66946007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?apu41oKSP7yW3N9qNouSQ9Z6EPISesSfR9cZ+87+JD1JRNWBHd/utdUlVBwL?=
 =?us-ascii?Q?kWgRdlA63VHTXT9t7kV+WcrC4DyXMiicBtP0avwYwRDEReUDNx6cAAh9UtSQ?=
 =?us-ascii?Q?j0eqK0KHdMhIII15gbvQ0NDyclAe7RVy4/WHxwz5yEy6P+qMTEoOGh0LrI+t?=
 =?us-ascii?Q?6Sw2lxm25jMDFlOijUjhVy0vTCzSL4jbeI8HBqSZxw9DtmMrjbXvOZ1oCvL9?=
 =?us-ascii?Q?K3vlzK38HHQZQSMsV/qoI0uAvwclEDA+h4W1dTMmnDhVCZAxBhD6X9REwATR?=
 =?us-ascii?Q?uW4uTa8fV81X5MpMHZcRgeGQsgfmGzWlSIesC+RyurN4NgFZwkIQ0yX4u8Tp?=
 =?us-ascii?Q?Ol/C7Hrtrij3TgdDEOisBjBIYy/+7ggslEemiy+CDJ1g54z7GEeJjW0nIt8A?=
 =?us-ascii?Q?XypJ5TLe1ww2/36vdEg7p6at91Kw//XAy07GLvSFUWcmvZRF/DhdWadbExfe?=
 =?us-ascii?Q?owoKYseSY1D+SyVOo3GKkuov5z7lAd4bCdIdLBnWP1+2o82ufWm9UXh79IQG?=
 =?us-ascii?Q?sL1iBkG/sSegq+xzbaXSgBCT+Z448rha8MfHoEz12oDIJQZTDlqZiAustCMX?=
 =?us-ascii?Q?OTAKvoBT8ZUgjRJPCpcpfIUBlG98MXPQAoQdppsSPg+Fw5LFpm0KmtxZayvE?=
 =?us-ascii?Q?4lwGNvqMr466gZg9AX8pbxTI2ideWvZEyacWjmrDEQcMQBvjGdob/JMo3viN?=
 =?us-ascii?Q?s4d1uosijb3f4pq9/aJTZWfsXM5atkGfWtE13bKt2WxPD5KsFTzWXdNeNn8N?=
 =?us-ascii?Q?IrXfygPD9LivLs1clXKtHzqipDhdnAcOj2MzAGV5ozMd+Q7QyhAYkFr1P5wv?=
 =?us-ascii?Q?BnMDFqySiGng22P/d+GXolsVPWrh0B7X83wJ4MqfEPrTSvqgEpREN0p3eXbt?=
 =?us-ascii?Q?X5fErZOi7797bEQMtAzDSdPzPvP4Pu+Yma3U1HEUABzq6Mfc/t/9+jj4OiPn?=
 =?us-ascii?Q?L2yM+yamdibteJCMLHnlMMWxh1lZy47GZsT+ko2iCB+Cy5OUHkHZHeCrK7ke?=
 =?us-ascii?Q?ecl8SxypMkCpX6MNQzshOk6+WHWwGNznAL7TJGwOwl2Vo6cvrJL82YzK5QEN?=
 =?us-ascii?Q?H/Et1VPsb55yjvG6D7cgWcUBFmQ1mA4N33NBBALO/YB+s7tlTi/DaLlmBogP?=
 =?us-ascii?Q?nFNIic2G9VYmijon7yZPwOcB8O/EHmF4sdFYL3e732TMoPOiwDSEi0CrXOz1?=
 =?us-ascii?Q?Kq2t76RxuKepAn3DATpqFry2aBwzCWiCd5wg09yY5rvrnR5igxAaUXuUE8I+?=
 =?us-ascii?Q?0pZUj9zSmAN254SDOJbqRwOKPoXkIIW79w/5OlPn1NylFiQcKjrReByT8kHk?=
 =?us-ascii?Q?af0XFNCQvZ9hwEggXqZ3lnDr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9eebfb9-dcb9-4fe5-a225-08d8fdeb87df
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:45:31.2866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyIF0MexV81iVkK9XyC1TCOGufek/f0YkQ5PaIRBdmJFi2jftoxpRQGmHtxWwwMlXKyaWIGqUYC2f6235Exv6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2367
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

