Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D15F1BF35D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgD3IrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:47:14 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:6047
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726531AbgD3IrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:47:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOJdi+v/Tw775zRDrttkCZZUK+9pC6hk9KnvYCCjDSHdshLTrF1NkzutiWqFRDZy3r0z0M3Z2dTfXsloMi7Jpj84jgl3/S06LcExSymEctHzmnSrFk3RY16alxpEom1/9l0B3yamntlNbxuA76iJWswJ0TDt5ENYVEpxgIZoubzlUWgwJj5fRS7AsbLCcfIkJeOzamqABBZXAyIJDKT0KVl4jXq7fFi3faojLkEx48R8hmjN6p1ZTiJK49Jz3c9KG4cbOdaTwaVlkCql0rLC8GlIpFKj7WvBpQnf6ScOu7ZNNGzYkYiPWnN/rXN0M3Squ2FCXad/lJCpvHMewXeTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms5T1TbPWzXX58Hb+fiuk/V0KrkIf2MtQZxaywTUg50=;
 b=Ge43m7NLhkBS6UGze2XCARDMY5E+IOkMWj/uOjEwRol0uOOr+6GO9J3V7BuG7hf+zKueY6wQIFfuz3eXzHjADin4E4DABfV0krl9EAYTetfY4KTrVKmV2x1QOeSO4sppk+lRzH1890+n5D7lj0YoP6JCzcLwc16ytnMFazIQU7dv4a+8KjOg/NHKTE3axkUdMDZN4Eq/2iMinlUuctTDrkLuNGLVb3vLeiiygpCrx2Ln17Wr+B2ulWpUoj3OyU3zvt2XDwGhowjjfwuNQh00KMpJLsxHO/3xfp6JsneW3bI/rbXyADDM2YILmLgIeQ0WwvHDr04cZsKe0CuV+sha2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms5T1TbPWzXX58Hb+fiuk/V0KrkIf2MtQZxaywTUg50=;
 b=T5CqBX/6zrpu2TReQ0Lw5VvJMXregFuYEbw6qcH1L07IK5tR/Mfwa6W5zMgHNllH2Qt/66H/EEPb4SdXTqyCLwJHZn0U+UKYzjcSIzpOTvrpp/Zku0oeA5HAd03dn7P9DR44vx4Rh/3ns4Qm83deF/vvkkhWpBTr60FZfk2lwd0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:47:10 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:47:10 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 17/18] KVM: x86: Mark _bss_decrypted section variables as decrypted in page encryption bitmap.
Date:   Thu, 30 Apr 2020 08:47:01 +0000
Message-Id: <864a701c953f01ff12f97f4215512901b4d933ea.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:805:ca::39) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0062.namprd16.prod.outlook.com (2603:10b6:805:ca::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:47:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 318b1ebb-28fa-469a-fb04-08d7ece3122d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1465732967D7D37EC529B7C48EAA0@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(7416002)(66946007)(26005)(36756003)(86362001)(66556008)(66476007)(5660300002)(478600001)(186003)(8936002)(2906002)(8676002)(16526019)(6916009)(7696005)(956004)(2616005)(52116002)(316002)(4326008)(6666004)(6486002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6YwnWhMUIXu2IGbyq9XQsyF7BQBw7psrgyXcrbGNkG4TLdwXoCdZEcupJcIQQjfYIW1x4QmJMAyffHXqJwnkjy3dGY7hM5LPAdmR0XyzP896xKELBDx0wQUmd7gdHSoJVznqJqyHqAZtTvABTajr3AQb65umZUkUCv4oHCUDMkEF1TL7q1KlqjPFIH84PzJM+uXrbsLGaZ4xqEEVAhBURRV2mAunoWbxwLp20+9BX9yyuNIeGOhwLQlD+I+WgX8UXvKGW27Exg8QmS1llXPk5WZtJQi3Par/wW0KDC4n3kRYYk+/kAGDr2VlQU0Neh8zNkERJRuBEUot5zsBx1bu6jDrB8ADJ23bpk9uQZu8+M6/6451AvtaBGt0TnDi91R3/VSnJB0zarh2B6EBz8OnbGPdW7ZIbc/MbBC3uy1Wk6R2GLWP0u3CrASbRzU78fNHZup/9QYta1QCylQJBucRb7kK8z6uUktIsGouRFTa1GBZjxTqbRfAiTkzXQvFAqf
X-MS-Exchange-AntiSpam-MessageData: paiWBeaXBRnVtRxoeHDlwQmbdn5lUCln0RuE/ug3yp4ZOQrtbdoJWjVJSQjcL+FGvintd+FhlYFWRKMHsY5wVNpNKo4DDLZJImmKPe2niyGncDDg1JY+K0grsPgRDRmHe+wPlyG2eI2v8RoKIypqzXrXj/G/ApMKq4l5CV7auDubeyexQwa186MHZksMTMzjWX31FqVGtYxy21P/5Fn/qplmaU81irkUMEf82vs04hrSItf+OyRW41MXHsEoht5OlwHYBBX+CXzmW87ahcH66EcSWD2L7mRR/t8wR3gR2ZB2erJmeBuynQ1R1dNUL7/hwS0jm11fIPy6eAdvGq6fR+c2DxoqojCG595Vynr9ANUJ/g+DWRc5D/RDhJku56YP91XTY6hDUBV75Ce4Nl0l4Gzr9J1Z7Uea7XCPew4olu7q95Y+OgoIg1QTGZVYCPns70fYMm1xXUeSBx5kwWX8ARiW1TJg0EHKmYvPYlYTgTpO1t8lP9xfknshUE9SbWngI/S8C5qe/NW27DJNEnx52RElqZGDTe/Wn9p0m/PZ2m3LkJCJVEWnta+rZBYblL7OmwYI0VGmSRaIY+AbuKBf13cTd4cjKA4M2mCVFli6ns8rxAWn5jGzS0ZwEWSYZDK80IJZ3/Zma0JAKhwirdYK/gCSNfYlXHYVFEN/WPl3rcncbs7qenehkVkdlEdMlkrvwmTOY4+TLNqE2VbPDPLZ6MgzCne9Oxg8BlvAlWlW3T0qLPrfDayBJ0gJdrX//2kgF2MMEtMTkKV+CzQQWN9ZSE2KAJvLIcbYtlwGNcovEZs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318b1ebb-28fa-469a-fb04-08d7ece3122d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:47:10.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/3+xDFD+XvPZ/vbrTC46Yg6PWDy/PrENNcAFya210H6xJsL73evllnNMI9ho4KR+v+OxLRt0vLT47ZfD4e51A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Ensure that _bss_decrypted section variables such as hv_clock_boot and
wall_clock are marked as decrypted in the page encryption bitmap if
sev liv migration is supported.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvmclock.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 34b18f6eeb2c..65777bf1218d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -334,6 +334,18 @@ void __init kvmclock_init(void)
 	pr_info("kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
+	if (sev_live_migration_enabled()) {
+		unsigned long nr_pages;
+		/*
+		 * sizeof(hv_clock_boot) is already PAGE_SIZE aligned
+		 */
+		early_set_mem_enc_dec_hypercall((unsigned long)hv_clock_boot,
+						1, 0);
+		nr_pages = DIV_ROUND_UP(sizeof(wall_clock), PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)&wall_clock,
+						nr_pages, 0);
+	}
+
 	this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
 	kvm_register_clock("primary cpu clock");
 	pvclock_set_pvti_cpu0_va(hv_clock_boot);
-- 
2.17.1

