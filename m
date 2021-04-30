Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036036F9FE
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhD3MTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:19:14 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232473AbhD3MSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:18:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EacGSnaTFB+qR0a9N4g8Kk+ydUzTngahIrvGojIFUoeH9lgFpjMjtO5Xaggj51Ya5Qgt98Ge1zM8LTcIBaAsat+10NSos+7R3EHCp1I0KFEeQUYC7Ah0Ylx09Mx9uZWx1kulYz/hym72RSmbOPh8FoWdSPCJ0lvYMTy2f3K4Nrc/xYntpQxPb4iwuL4cOdC/DJ/7DlrDpyAku15ASzfDfwRhr91bGQ5pjlB+Zl9JZJNwC8zpGgaVL6GUhPotNFvE7jHaTadWGcKNlWUHdSYFdCxaQGhlCCOI8jK4WP7rn88u0HI+jJm7n0D8WdVP/zEWqYiNRuSESnkNEp0Upx2hNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glD6zeCoDbk4KuheZFM2dMGeSZIceTxh4u+wrzrEoQg=;
 b=b6qFX/TOePC5CLfWyZY3Rk2gTyJET0k7UuI1RkpvFyqW2Eai1MxIbnEgjdDvwEMlsgxhyFBY366ZEew1elDBu5YyI2SF8oDy/k7JTw64yd3uiSQWDkse6NkreGD+n2ltwj+YfwlYzgGZXdMRxRG2h50UOapdYdLs8KMN8QcUMS5IE10bDnQUeF1Ppc9aXtVIGvjWN0BGqesLsOjfxMuedemQybhlzuNvFQ8stFL00czI53l705Nu2WkQM3QEoBh5RPKU6vfKLpLRCIQr9hFBAy/8RCqtl+dKUkCn1WULKCLRsGrXkpbw++dL41JiHoGg8SGRLgfO6CQjVw+sucxeHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glD6zeCoDbk4KuheZFM2dMGeSZIceTxh4u+wrzrEoQg=;
 b=gLeWDQiAC/9RdWu/H0DTty5r+wy4KG0Mfe3I0buZRQG9vw9ayaJwpQZo6o64ygM9zmPLUDVHP6TOU0OJxKzkYpnr/s7blHK93OdN8lah78L54AtGkWvHoGvRM3IWTSN8M+nhWPmNGNK9UEwGb9VUdpiCHehUxZsLrWiBA77RCe4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:04 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 18/20] x86/boot: Add Confidential Computing address to setup_header
Date:   Fri, 30 Apr 2021 07:16:14 -0500
Message-Id: <20210430121616.2295-19-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:17:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37279f1f-8693-43ef-64e7-08d90bd1db41
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26405391315E7B95F0C72352E55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0gmGZTT6D090vyehMDRwZhuetG84HXvwE5hnE5922zv398NYQ4MHK18p3RtdchQwd1mELb+6U1DpvisLX0ZQd+A6+rpMKL/CEdpj8Ar6sRth+5o1b78UUbdMkvTfkjZs1+QOWrCb8zhq0SgA8K7a0QSH7Au8XxCenJqBtf7EeVwUXfzFX6B9DWXo7AchTqiab039Jg6LLMhKyqJ/+kMZbrVdNrGtiUf6epYdEZbRD5e+HUeK4r6Pn1eyFYNY1QImFf3pp/FhxGd90W0b235kJ95wcnpq/9DaEnbRf+KdFDPXtmDa6bvcQ9cbV4igF9XGfUWPP9Ksz1Ndmt8VTV76ceyP6qvc54zqdRai8uhiNSZtgrW4fJnj41ziz7l6FjcD1SToufBxFMW+U2qTaJzzcM9fIYZN7b+hAM14Jx7Tj42YUPM1MYA65k0Am6BvmkCmZXZ5zucjh3/5pR/X6sGwqNvYFKSAWWuCLouPj5U63zjxBijY0g8Ib43Q/uu9NCbu5xNb0wuURhGLbFB5jgy6aT/WylgcSWF3POV71Lv5hf7ZF2OsIYbJ4xybJsmGP7/Xaqme49P2tIdwEtX9xzqPvjh0O0qc5hONmG76pa1R9wPdKUIsrRO7SPfw9K6WWFsYar845NahOgpI9und0UtQVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f8NBhj5EgsJDFAcgEtFUU3dY3dRtDTjMxMr2misxeS8bbTSizBspHJQE6EDp?=
 =?us-ascii?Q?0Tefquwtn+fHdhDKyn767Iiw/8xCDX8dzTJtM6LU//niSAg3uZNo/35LrJ+M?=
 =?us-ascii?Q?ELUiY4gVl6pIXEuslycdyV0ZqrZJuTMItuuu/eBb2p6QKVe3mmEQVz2RV+yp?=
 =?us-ascii?Q?xuVSq7MUICk2U5Jbgw0CadZEUn338pmyWc/4fe61T/Da6EWaa/mBaSNEZGM5?=
 =?us-ascii?Q?jjTAKRiN17jYwEE1K8baHHNvFPA42zySRh0YYIM0TZboV0N7r3cYgDoQ5v4C?=
 =?us-ascii?Q?nou3eFHOc6oMI+zbg/ukOcX22eBpjPIHZPMp/j81+lxElQRsAeN8EZTf1Omc?=
 =?us-ascii?Q?vt0yQLEw7xvsNijVnWaQjvneqo6vfiT4wlwy8ob77EZM3RqYVWyBsTo2HKvQ?=
 =?us-ascii?Q?l1niWjyV9qXboK1YqalnJlJY1MN4ybTQH2sfMZ5CuNcftibqK01+PkwpIWAG?=
 =?us-ascii?Q?UGlswLgbFkSoLm+nsdaJNtShUGHL88d6PPkzO3JaDjiiJRPv/1fYvm0E9kVl?=
 =?us-ascii?Q?m6wr348Eoq3UZaxfH1K87o57kwmJeUmlQNkP/v5MTvzZGTpuoV3xmQhQ7+Y8?=
 =?us-ascii?Q?ty8+pFBQEWimcZWEQGfnRyef6ZOWXoX9tXwWT90nw3YMTGNLq79o4hti4t15?=
 =?us-ascii?Q?/hJcle8eUztbKg6DNN5PAFc9ImSPlvOahOs2xPeGqW/BPiH49BYpj96zQ0Rk?=
 =?us-ascii?Q?Nja4b+QpGzkRMgDmGHSucRaIBWrVm0OF1U3GJvBIiHB9q2lyZZ4BcBTfzfAo?=
 =?us-ascii?Q?F49mQAhXQjyPcCvgZg9zE4QNrGCJQoQAs78OyweWTIQ5yPnYZyX7CXIz2GuX?=
 =?us-ascii?Q?wFKVqQgUDfpLGPEb8/EFO18gFf5DDwGZdpUPpvM0d9E1dqta/7pzgsSK3vsG?=
 =?us-ascii?Q?HeMFA/x7zt3us+9Gz50BbfNd7aUXwrbbPL8B7a1cOLW+z3uvlg5ed9sf/dW9?=
 =?us-ascii?Q?lFfkNp8bl1ycoAYBro5do/VsvBWSH01b2q+Y1t9twbxyJfbfuxMk46bsmrGb?=
 =?us-ascii?Q?XiepVDulxT6/x1QxzMPM9PFXaSfkpDVZGC2Wm1aO7J4GnhUApC6Eh0UxFTRE?=
 =?us-ascii?Q?wcSMBx6ZL0TGeHb+RkZhUq/ye4HMfrFAoZCc3b6M/qc+Pt6WMX9MLPRCV3dm?=
 =?us-ascii?Q?Lc2v4Ol/rqyOv/v+THYVTyn/TrKUWibRqNqo6TuzXxbOMw9+K2sMDEgL5cVp?=
 =?us-ascii?Q?i1l1OHGdFHlLBrccSfhLvz0T/pWpM6KXkksFRe0ht+aC8ATAEuXFpneLV/o0?=
 =?us-ascii?Q?OLKflzmDHbcm3ZeFHNquMK0orB//3gJ1JdhmJ7udbHo2BmFtQhfVhcfpp/zK?=
 =?us-ascii?Q?G0l2EmdqBy0v+p+xCav60+Li?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37279f1f-8693-43ef-64e7-08d90bd1db41
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:17:00.5811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tRGzaylXjb2Xcad3rxBhcNwuwekAmz2+HH4WYtL/M1yNLbsXftWhNqGLtBFuxvQlmpWbThs3SkcH3QW538zwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While launching the encrypted guests, the hypervisor may need to provide
some additional information that will used during the guest boot. In the
case of AMD SEV-SNP the information includes the address of the secrets
and CPUID pages. The secrets page contains information such as a VM to
PSP communication key, and CPUID page contain PSP filtered CPUID values.

When booting under the EFI based BIOS, the EFI configuration table
contains an entry for the confidential computing blob. In order to support
booting encrypted guests on non EFI VM, the hypervisor need to pass these
additional information to the kernel with different method.

For this purpose expand the struct setup_header to hold the physical
address of the confidential computing blob location. Being zero means it
isn't passed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/x86/boot.rst            | 26 ++++++++++++++++++++++++++
 arch/x86/boot/header.S                |  7 ++++++-
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/boot.rst b/Documentation/x86/boot.rst
index fc844913dece..f7c6c3204b40 100644
--- a/Documentation/x86/boot.rst
+++ b/Documentation/x86/boot.rst
@@ -75,6 +75,8 @@ Protocol 2.14	BURNT BY INCORRECT COMMIT
 		DO NOT USE!!! ASSUME SAME AS 2.13.
 
 Protocol 2.15	(Kernel 5.5) Added the kernel_info and kernel_info.setup_type_max.
+
+Protocol 2.16	(Kernel 5.14) Added the confidential computing blob address
 =============	============================================================
 
 .. note::
@@ -226,6 +228,7 @@ Offset/Size	Proto		Name			Meaning
 0260/4		2.10+		init_size		Linear memory required during initialization
 0264/4		2.11+		handover_offset		Offset of handover entry point
 0268/4		2.15+		kernel_info_offset	Offset of the kernel_info
+026C/4		2.16+		cc_blob_address	        Physical address of the confidential computing blob
 ===========	========	=====================	============================================
 
 .. note::
@@ -1026,6 +1029,29 @@ Offset/size:	0x000c/4
 
   This field contains maximal allowed type for setup_data and setup_indirect structs.
 
+============	==================
+Field name:	cc_blob_address
+Type:		write (optional)
+Offset/size:	0x26C/4
+Protocol:	2.16+
+============	==================
+
+  This field can be set by the boot loader to tell the kernel the physical address
+  of the confidential computing blob info.
+
+  A value of 0 indicates that either the blob is not provided or use the EFI configuration
+  table to retrieve the blob location.
+
+  In the case of AMD SEV the blob look like this::
+
+  struct cc_blob_sev_info {
+        u32 magic;      /* 0x414d4445 (AMDE) */
+        u16 version;
+        u32 secrets_phys; /* pointer to secrets page */
+        u32 secrets_len;
+        u64 cpuid_phys;   /* 32-bit pointer to cpuid page */
+        u32 cpuid_len;
+  }
 
 The Image Checksum
 ==================
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 6dbd7e9f74c9..b4a014a18f91 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -303,7 +303,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020f		# header version number (>= 0x0105)
+		.word	0x0210		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -577,6 +577,11 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0			# Filled in by build.c
 kernel_info_offset:	.long 0			# Filled in by build.c
+cc_blob_address:	.long 0			# (Header version 0x210 or later)
+						# If nonzero, a 32-bit pointer to
+						# the confidential computing blob.
+						# The blob will contain the information
+						# used while booting the encrypted VM.
 
 # End of setup header #####################################################
 
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index b25d3f82c2f3..210e1a0fb4ce 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -102,6 +102,7 @@ struct setup_header {
 	__u32	init_size;
 	__u32	handover_offset;
 	__u32	kernel_info_offset;
+	__u32	cc_blob_address;
 } __attribute__((packed));
 
 struct sys_desc_table {
-- 
2.17.1

