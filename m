Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0923F3C2B07
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhGIV65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:58:57 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229948AbhGIV6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrTaX+CsAYrNokH/sgrJM34pOeSkLFXyX1sD5uiUuOuUGqtrGekKZnfTuy2+MpcwNBAl/g3FxO45EzXoINRhJkwqqy5ViRgk1d1nVsklQnfQ7pV2qF/DajgRZyg4gPeYe/JBAYj0mWShK3C7DVgQ8DhzWaPGUr+l9a/N63FgBEB0tZbtLywmGzhWAdP6xBPXhzTCV91uioGuvNjgFr28gOKLDtPauNWGiiMhqFZ/4+TWUV35Ph3E5LNYqKgFUhque9dQ/sqKawd5luW07lGqpJFiwfGmX0u3wPn0Ju7Yt+/klHo7mUCIseNZo4mlO+GoxvH/KmJ5BRLHSyEC/b9FUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xJGT0HcR5qZFQMgoHuLjT8knIauKod8GS2YRW73PeE=;
 b=DDK4gPHfMXDoDyNeI8/WJupYdWaIhrHCcJZ/kPv4MResfwzNfn1b98X3vu3T520GVEfdKFgnLObDFcCSws17MqAfEYX+b8SihETddNBCIH8n1lgVpkTWEAsFv90glBQCNsDFWqMDU0xXHjslIdHzDCxuhCiuVKed/VmvfwuGypOyHTcHOD5gHJl7CrXKqt8QxO/PvfDc1b4wshU/RssVVIIGeS5orFnizdkPrre8H+jRJht0t/e6OcPDsrIMI6TkGG1PEpoMRwF2VJ7oonZpR1mJNKYubZexWazxj0I6qKscY4I8MR5LT17mYZOa1+LME+IO0uBltyM8jh/tgamFsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xJGT0HcR5qZFQMgoHuLjT8knIauKod8GS2YRW73PeE=;
 b=43/d0dlopn0znK0/23fD8UjvNUMtXydT04hXC08Tt211S71Zu9lmCB4xnnW6dlVJHbnaELLpxk/Fdoum6S4DcQjaXdUnahmLaAsRyY0NjH0hpeGpDlESHMih6Jfngw3V6xJUTy/FtR4E381uCkhfg5v/fi4AdvHEoWgphydkaE0=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 21:56:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.022; Fri, 9 Jul 2021
 21:56:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 1/6] linux-header: add the SNP specific command
Date:   Fri,  9 Jul 2021 16:55:45 -0500
Message-Id: <20210709215550.32496-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709215550.32496-1-brijesh.singh@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 21:56:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a092e81-0390-4534-df84-08d943245c88
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45759AFF1D597A34061E90FAE5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8vqCiWZNRqNUyOeNkMXCYH08yqzDKaBN6HQ5zOjs1ZsVHZPFpiEluymnU/j/0ljaD9gv2okIn1/5VX4g+qwrW9V2r3LBprdIZ4mnEMIa4PgWd3ecVCAgr+UK0l4cv4L+VjjjHzN7RxtvQC+LEL/bmU8ZTVCpVcfjI9O88fDvMe7bGS7tGlLp31FfCAtDGCj2L0GzzvnoXxi9k47qRH1+Eb4qWhbWy5r4TPbXSobzrpnSeHYfF+iG5OvkqRidkm2V2+sFxC7sWO4OtOZJ7Crl3NpifIJ5Qs3/dZ/MMT+p0Yg38tjuUdvO7Ergr82Gc4PhJmWbqNJqgcK8C/5VSYgaXOGcFcresn3sZzdS2cL3uV4gZDTC+mGSPDa+x+eH12wOsrzNvKPuqj0EZkiZ5PQe3Sfhvio9ldhCgDajhHJfQN1xqGW3+xysDHg1hjqrRuzXBnj+K06qI44ABCaKxlgL9pZlLu57g4JlIijAYs/OdB4zNQ7WLOotBsJe/pGgD3fbRmpei+3tjW5KvqHv7nPrcQZeucV+bfrEtZYPJfM0Hr9V9YqLhBl3l4TqI2FABpDOBjzjxsQQmFYvIw4AJvhX02+kETY6/H818V4jdP8geZ0eGcN9jE62fUanIpBj6gfwFvibdhezUMYZH2MHCH3OrJqHfU7mNcUqwj3IkMuq5AO5wU6OwXKUdwO0eLWnhHNgvrfMJs1bipFuAJdTucNlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(54906003)(478600001)(1076003)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzGiQxlQ4lrjypRCpehiZqhHBaPic64HS90XyBPt3H7JMxKA3uoQY5I6Aig4?=
 =?us-ascii?Q?cnjlLqFlO3ScEA+hZf70JOW71VEd9dQwjdy0SjVOWRM8FVfXWxA+ZJSfuW7N?=
 =?us-ascii?Q?v+N1O2n42tY0fdH4Jt+scAQZC/if0v/m5iK23H/kdkldRiAHI5ZIUz+/JjMF?=
 =?us-ascii?Q?dM+Mt2AymwYMALX57yHJPbYBfF1JCogLUCEJoNlTMxbeg9W8/YPD2l4u3Iyw?=
 =?us-ascii?Q?Ui8nRRIuHjF0MHABOsot0t04REika2EiU7UQPDqPHywSCf+CyaSDZec6d4DQ?=
 =?us-ascii?Q?X9Q+6LbZ42VmPLhKEi2dreXsDrFTotpejSypEXNzZzfBsVOe2Bznts84z5XE?=
 =?us-ascii?Q?sgbqWkYfYM2hEsLl7riRUHMWPiISXPqNjw1sMXrx8sSbmkBPZfH/lr2lqO7I?=
 =?us-ascii?Q?0cL7XB0uMKa+K/6zWrh4nTk2hKkPCHyVDqvg2p4MM+ttzEedRyWq2zZp394v?=
 =?us-ascii?Q?csL3KEk2Ytiv9+GZ7wxZ00L2M3X+8E3zySU3SKjrjMbPupWVEnyp++JLsihE?=
 =?us-ascii?Q?G3Jh+fL0D8sERfx6DPu8lg+42cB+Ysd2/FDxjJL/dzCIQ0bBHdenKg3x2ncR?=
 =?us-ascii?Q?0eOEwpUyqSGff+wAmht2fyUPtxT8BT9ujHFxEMFR2F335/l9Qt5tOI36Ji2W?=
 =?us-ascii?Q?ANQBrMXjxRpvO3BSWHE+6n95ykxHcjXdcqginzD1Bv3kVskVc7fadXL62JBm?=
 =?us-ascii?Q?pL4DeKMxm6G9e4heJ6o92UpaEsaZhCQE+NMpnwQVfAlA4TCNO/PxHiyK2dsK?=
 =?us-ascii?Q?+slnIXK3VYReRI5I9wow73qQA8twqjOaBDy4NFXSzDowG/6IuIc5igZ/argb?=
 =?us-ascii?Q?ipXbqMZym/8aBoRiJyv69qI0ammRFJdqlPI/JR/aY430ib9zirjeouO/+aBe?=
 =?us-ascii?Q?rxmBH/p7bTJGvavUM4bii4Y6SUUVzfnjt8sfZvirAmgoYZe6mdB0UZjF0jFh?=
 =?us-ascii?Q?VVIV8MuW8YctCsYkMhn0hIkSiPOWyDM26yJp1u/5v33ehkgIqqumBt87FzsO?=
 =?us-ascii?Q?3R1zfXs5Ci1H/9opJWCMrCuUjRTBiJp/dY7Y45cHM68XT1LHemnR9V8CmZNH?=
 =?us-ascii?Q?1jzsKUfDFhga5t2rVtVVMA5jJimiDOvcjFoZfa6+RSJVUV231WBX+ktPjkwf?=
 =?us-ascii?Q?kQcXItWw2RCOs0uZOWTrsoOi8BWuJlhEqQT13vZ8OcJuJfantnA51f+e1Y/0?=
 =?us-ascii?Q?bkZQCIj6rCuJxJMR6R0nS4UwNJxnwNpEqZ9/TMXc+6kIj/XYJvvyc4UVU4sF?=
 =?us-ascii?Q?kXJUNWLGjElJfx3DbR6VXRRdZzMeI788R0Y+8MiHZUWazz/0CQwBKQnmQr3u?=
 =?us-ascii?Q?NgtvbyD3VGzwiy2i5QiS8HvC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a092e81-0390-4534-df84-08d943245c88
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:10.1402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SaLsfUSxIgurZrz15m6BrUgdKJdqVATd9nLYZCNzOlV7mPjc915u/C/1JBq/vnwRZ0Fa7/pO5UqPU+mAjCk86Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sync the kvm.h with the kernel to include the SNP specific commands.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 linux-headers/linux/kvm.h | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 20d6a263bb..c17ace1ece 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1679,6 +1679,12 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT = 256,
+	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -1775,6 +1781,47 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_snp_init {
+	__u64 flags;
+};
+
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u64 ma_uaddr;
+	__u8 ma_en;
+	__u8 imi_en;
+	__u8 gosvw[16];
+};
+
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 uaddr;
+	__u32 len;
+	__u8 imi_page;
+	__u8 page_type;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

