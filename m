Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAF93B7501
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 17:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbhF2PQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 11:16:49 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:41441
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234642AbhF2PQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Jun 2021 11:16:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSPra1eaNBXOqWWLouH2iuJqKl6HmaEozIhXfwwXHZ0l4R8AXwjRCIYBwZ5Z/0xpAWsOL7+etA/JdwWGOWQCdCurqBnGfQ+jfXYVjaEZo99bX33i0eEOc8cMjrw8lESMzJRRyTKzdJcanmFGQsjc5Vt9YRkWewstFvHT8ZYs/8wOkgOT9bNVbMkBqNbh/q3EX6KdN+l97x8hl4hCjv0emPASVQnzRQFGgUutOYpTxL7t4uhV1G4MCfzcS16cG94Fvzx/hYpgIpv6bg4GRpC/iZtoffZ32KYEud0TvaEOK3GBfk6SliWhya4ih7h8qJPxyGIp6Orm8YE/ivxkwYicLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zTW3gIaN5xuLG9gnYJybBASVdTG0s5L9dAdAX3I1Dw=;
 b=f1AEkcOen0YcWzIGECkAxA3l0/h6d1vpMs6EUatPIMdPOwjU0RTD9ekssmHAneyQPGJzLz/tj2Gld1S/nz9jy7KtEIUHNAyckUAAP9PWF2TVmYTJwEJdnuzrGu+0/SBBEsICFyxKQ5n6bzj/qqSH5biMv6C+iVaDgdACzHsm8PJa1xN1U89XkwfEQtgeEstx5pftv4EfTX2CReYT4qE7YkBlpBtazqaDwbpWhLaxq/xgfzQD3vf6ihXWCyqgW/UacFJj0/2KTk9EaGwzRMXDlK3ieZnjYPy+wRe2keIX7MwR5NfaedqoMIejijl53bs2Ky+Re4y4aqqyC03oMfpsGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zTW3gIaN5xuLG9gnYJybBASVdTG0s5L9dAdAX3I1Dw=;
 b=gkgvXSbxEZYVcfLUi//iRwNl6wM1uzlkBGvkDCLaJleJh4jQ2ToNwfN41Ex15ZOlP2YxxAzubA5E3kcDwII39EY1nlO2l0gg9OqKfgMVO+uFM81mkYVkDL5D/z5Erh0RQ9VJA0BRJdzU1ows8YAHYBaWjC34ILD/mYYEpieknMM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 15:14:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 15:14:18 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com,
        srutherford@google.com
Subject: [PATCH v5 6/6] x86/kvm: Add kexec support for SEV Live Migration.
Date:   Tue, 29 Jun 2021 15:14:09 +0000
Message-Id: <8fce27b8477073b9c7750f7cfc0c68f7ebd3a97d.1624978790.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1624978790.git.ashish.kalra@amd.com>
References: <cover.1624978790.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:806:d3::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0008.namprd11.prod.outlook.com (2603:10b6:806:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 15:14:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 228246eb-0d2b-4b0d-8ef0-08d93b1090d8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB441322D9318215F51C30182D8E029@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9b4TnzSciORtaeAqWIJWTGSg2oWTbd6JELNotPBpcwoLI3LTCbdNjxugOhFlEQUJJjFmwr9o+Rh1r4Bt+Li2ruybkpaBdx2AmV7ZorIFYtxak5gQ9vdh4nxyJ9alcjE6PUbPLfsoXCPHQ34OcjMlho/vOwS150tjId9HyAoc/25Z9TRE1ulVTkNJEQ4uyqwMoImc8NgrX3J2Th/scdHlBDZGbRFI8zhDrGEGOTFb966/a26wYnGZ5BqZmHEoU2a5s5n3f+lGZeMrouOQw0A+LykkVeTku5SArawkK43NoqaFrUN5RDRPwMx5M9fmB5927qdviSDUDfMHeaewOHHnexBGSbMv6z53Wp4zprHsxjcwlSZtp+gg933Vfg4tZHvwEg1G9ypYL9cOJ8pshOT5HmnVmzLF0P8PEAM78IkMTXntpkkGFvkogj5K3Mg4MttpoPhhDakgAoRferpe6u15iIejEtFJ5fkTHwP0PEmz5kBypUtXoMmDkrbOZLyNWcwndV5eCD2gD108lVuCrOn7oMjqy/3vWe30rwrUAaQT9sN1UDDARGOtDEa1INDyxAsM9xyloROP/5hDK/SS3a6khicaCzJERuRD7rRTWa8cm2zL9vrmj4FeSWs/Wm+rmvnrJUmdKaMLrp+vqQmOwJSehAPmWzSZz/pUuSZOhvzWDOagXhTgSG/AtmO+mzIPTOL15IOdaxUspdRwz/ad2GZuBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(6666004)(6486002)(316002)(7416002)(26005)(16526019)(186003)(38100700002)(38350700002)(4326008)(2906002)(478600001)(66556008)(66476007)(5660300002)(7696005)(52116002)(956004)(2616005)(66946007)(86362001)(8936002)(36756003)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PNQA0uyti88+OEsg1xNxaqJz7QIHpUS05skmiPiAKkp2Dep5sgAkj4Q2rO3e?=
 =?us-ascii?Q?M/IiYy8ceGu24s3HQXGbVW87Nnu/HcDugcjCvF44DtVUJvtvdjq4Xi6zwpCu?=
 =?us-ascii?Q?suh86CTh4D3dGISUDB4BvCNp0gvTM3d/2dtobzx5XIVg4FfPqLmRO4Y6Kr1X?=
 =?us-ascii?Q?vwre9QMwhDj1HNTtYzds/3/f511HzVn8HynRwLrn3BOkT3gFyvdAkGYcuDwM?=
 =?us-ascii?Q?X1V2vsCCqZtLoY+H8R7HJzWHc8TEyz2nExXRiNk1+AKmkdE1by655GH7HIzI?=
 =?us-ascii?Q?brlJWfQyB7nd2CsUPeWrupaugLMWOIIhXeFuLpTlrT9c1oRRBiysCg3f5hp3?=
 =?us-ascii?Q?PCYhD/HOJ/ztrwWyqnIZlHx2ap60Vs0g2ZTEyQV3VjragIqXsrkMfZWIJTIa?=
 =?us-ascii?Q?+MW1Ht329ZjBGRG3mG34hJumBtWHiaF1XCnoQb28960Yh8EcLPx3iV9MG0qX?=
 =?us-ascii?Q?MnAL79jd6hLp6d3cEBd52wOTcKRMIaIs4W/yQIPQontu7FsnZfoJmJ5/KXnN?=
 =?us-ascii?Q?XNujpMFLEcCrH3M0Ai5anpDx8ZIOrADz02k22CnUIkX0P4Uf5wtnoKDIpNGh?=
 =?us-ascii?Q?OuzFOSnxKlu6ELO7h3nvjdWpfGQptR7Oeaw4jSydxTcO6YfP7iyHUazZHQw9?=
 =?us-ascii?Q?bX7QIoe0GrUexC703xDdxVK1YTn3o9H0qkEEKqCqwtbQloUKzS48C8jipFKi?=
 =?us-ascii?Q?W5Dvs2OvcTwuW+HcG1ZlIlwwu+L7qG6qzY4GE8dvS+WCXQERL2/DuhZ0lcZb?=
 =?us-ascii?Q?pdCOwmhqz5xdRk4VyfEJnXT5RIB+nLMDEi2YJEtaaP7m713dd7UVIzT6VKCk?=
 =?us-ascii?Q?Ingi3dzd0a6UN1wGt0tfQwYSyOW/nroTVE364gBRLS5/bbv+mefJP3Z0vVmi?=
 =?us-ascii?Q?4jZrh1MhGApxaRvSC9wrGaZAXnDAibs/94M/MXiboyavTv5xLd02YgPbC4sU?=
 =?us-ascii?Q?6sOcOpc72M/KTrcXfJjtaBfS5lLB05LPJbpqIrVjrI5IHgdZ7PyVGM+OvBQ8?=
 =?us-ascii?Q?k4eT1EenwhC/8nb6l39l3JwO4MbeCAQ2OsZ53YnMYkcnpWNjaWA857xrojH+?=
 =?us-ascii?Q?wWb87EJbEKmdfPsJ7VHn9vMD4MVYSztX1zEyAHInRRv+I5kS6BmTzxCiLmv3?=
 =?us-ascii?Q?Y2R2fiFgrFQiJYttoD7kCUyxKeMmUIdMBpxhNWTGRTv9b89hDr9Jkr1jNuxB?=
 =?us-ascii?Q?SaF9Cfh+Jr7nw5aKESYDtwpTG32k38JBrvbee57QSMkOncrV8VG38uKB0pjH?=
 =?us-ascii?Q?bTUOdwPWmWViyp9nDbtaNDDNcXKJj1ytXMftGulkmm6NtdF+17oionoLASuy?=
 =?us-ascii?Q?/lHhbBqBjlg0WpaAqzsiJWBP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228246eb-0d2b-4b0d-8ef0-08d93b1090d8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 15:14:18.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jiey+Bf4wSuVI32OSZ288aIz2fhZLZJ8fl5H5Vl2gvIjuRJZIDBqa04FF/NqOB6krr1QFEtTdcXN7BTXxuEkVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Reset the host's shared pages list related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
shared pages list here as we need to retain the
UEFI/OVMF firmware specific settings.

The host's shared pages list is maintained for the
guest to keep track of all unencrypted guest memory regions,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a014c9bb5066..a55712ee58a1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -869,10 +869,35 @@ static void __init kvm_init_platform(void)
 	if (sev_active() &&
 	    kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
 		unsigned long nr_pages;
+		int i;
 
 		pv_ops.mmu.notify_page_enc_status_changed =
 			kvm_sev_hc_page_enc_status;
 
+		/*
+		 * Reset the host's shared pages list related to kernel
+		 * specific page encryption status settings before we load a
+		 * new kernel by kexec. Reset the page encryption status
+		 * during early boot intead of just before kexec to avoid SMP
+		 * races during kvm_pv_guest_cpu_reboot().
+		 * NOTE: We cannot reset the complete shared pages list
+		 * here as we need to retain the UEFI/OVMF firmware
+		 * specific settings.
+		 */
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
+
+			kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, entry->addr,
+				       nr_pages,
+				       KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
+		}
+
 		/*
 		 * Ensure that _bss_decrypted section is marked as decrypted in the
 		 * shared pages list.
-- 
2.17.1

