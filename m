Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B48B678170
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 17:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjAWQaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 11:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjAWQaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 11:30:10 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2113.outbound.protection.outlook.com [40.107.8.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D8929E12
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 08:29:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XP7uPBwfbqtCAAt17fGkNR1BIFC0yteEHh3t46fObSxcGZ76MuUP/MPnnfQodNxfFtshUucir8D5zD55SZMC3jix8nBj2QGpPG8WcEaO2ptzJfSoq83dcBY2Bj6YAu5LfYl/EODSteNbiJmhMNvXBA0E6ehKQvoJYfr6gZ/p7eDr9HUIt/G1QbAydu1tze5WsWGMWtSrth/UtmFyuSHQ/NYy2dmnNqVscUZdacGI/NCWOsv5nf6FGL/2bc1as5ffTIoaAptwIE60eKtw21AEFsEymW/tc5CzR+uKmqnesBTpe2ghHzNQL0dJg+TQV1osGgjaPwlKUi425AHuMg0IfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Betuk0oUOQoy7DnZjCNwE7zx0B/6MCHGCrwKkIxNkig=;
 b=gFa7oYm4ny5Ab43lgV2r2EjR576hzN4btPwWF11NBHPz2Yeyigwhu7y2/sTuR7xtS7j+xQd7D+0ffxbcoC9Ce0wkiek6Px/Oiq4cVkFsL0BxxuC1dUx5DF1Rr7GiDtsbnqsZXO/qBZJd78daJMgBQ7b2dIjhkHXZITtYjQifTJ6u5n1AXqZMR745Mj47kLK+7XzJPdfYjBaNTg36uVbG7L5tFRx+dPld6N+MvjqfTmGfPrRIkw+UDOmP6mzlzUlITIRNAuGHAZVA0UdxKwNADTTFZdYIRd7xZfw3bd8epR1Lv5/Kl8/tFmJSJ7glIStE/mBrWl0aErj2TAlbN5t/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Betuk0oUOQoy7DnZjCNwE7zx0B/6MCHGCrwKkIxNkig=;
 b=DB6fqkTtbnSb5GoHtKYr1ZEI2BNzCOz3BN9tVqbAsoXx8CLyOLz7CELABYT95Is7KkAB4eMPHPy0HFA1cHBpL6sqNyv8QEp0HttujW70pzlkNcsitpTEL771F46zKcsZ1CjCJUBtp6ITfC4brCYnsqOtBPvlV28Gene2jHLX+ZLcr2MUz4bAv8AGndY0Q/wN2XE8pMdIu9sctDOSOJ3gwEzEQbaMLI8+lex4zEj2u2vykImT2nC1uXOUb7U80yRPU7OIs9O2Ikjw0BRR4AhmD6/cexS6wECnd3FsjQBdMIjWgmpl+uPfS1IWbFnNyc58fgg9vL4L+qVPbxp4q8NF4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS8PR02MB7190.eurprd02.prod.outlook.com (2603:10a6:20b:3f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 16:29:46 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 16:29:45 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH v3] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Mon, 23 Jan 2023 18:29:29 +0200
Message-Id: <20230123162929.9773-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0010.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::18) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS8PR02MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: 091a2b55-1421-49de-e7ba-08dafd5f09dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4CqxCqh/erph8oTq2E7SM8F2bNumCtQmlYna2E/1v3Zohi/C3btvPS/KZ3SFlxg7rKTVq7jMDy+y8JYbWG5kMw/vNIyTskzPPrhkO5Ta5Cts6UaFxUP0BBB3E44V1dulJTt2Qz3oPQ1udBdFX0gHJTV9Jb5FkgqV51cVpjM6yZMcFgX+KmacMj08r7rx+1ng1IpGGZhd7/w2g1WlTbXxEIhs+MOTuYmaYWIChrdUZBSVEYZyEQOhcYyjWsZEYcSm6S65xDXHBx0KXU7AS4QuYcGtV9CBCtvEc8qMVso1gOR5xCpuI/9s5ary1C0V7HBwR7/v8x94JTDEu9t1L+tIUVjMw3b3v4k0n/zwjxkQBNcgw/bTCRxDUOJXBD+nvgFEBWZPTWS6mU8SVcrRU0XsRO8+MfoPQST8hgoB39Lpkyemtt71BMcJw/leqtSyYOj3N8j1t65f1FI8KXMY9h6cLmzb38JYM0PCYmpzIKgv71rTS3EYGT0LooNnfsLLAX907IC2K1FA9ZR7x8TCpBQgC4LGoSVHEYqQtl2/y3g6Y8bWR2XES7/eD6ahH+RdHNUfHsOSTjYukeMP1VlyE8Gv3hO8GtElgJ6ofH2RW+Jt6RyRIHhQv7gMgQlz5f+jIZxl8CJLfL5ytEQZ4NnZGACQ6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(1076003)(66556008)(4326008)(66476007)(66946007)(8676002)(6486002)(2616005)(41300700001)(26005)(186003)(107886003)(8936002)(6512007)(44832011)(5660300002)(83380400001)(6666004)(6506007)(2906002)(38100700002)(478600001)(110136005)(54906003)(316002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NWVSHMZfFY3hPEvg0MLlkr0ATmE6twAN8Gsya7N5A44LRUHULqowjTouuWNc?=
 =?us-ascii?Q?t0x14l9OqCyswReCmMPUSTRnMLjTwc9OAyDrXgR6pUpBgFNh/gpEKAES05L0?=
 =?us-ascii?Q?aR+soSahwWJLK+TKB5gKl+GI4pMzwmnPq2Ld9lrOIxUnzh6ZdiWdeOhGi++9?=
 =?us-ascii?Q?dhsxrI2Lj1YUZkDWhMEUg3WAkUZtSFHId4Z+OhMRKPTrJCUPjX4bwET8BUbB?=
 =?us-ascii?Q?+ToemYnIBQcpC6wveN/nDJ1UDVPehGx73mIs3ilV7QAG1PXOAtTWqW7ph+QQ?=
 =?us-ascii?Q?WmOX2a4O+rHN8kqsYud/T7UWRgKEuOYTMYyIalemPhAZDboBFrPoAXnNOpEq?=
 =?us-ascii?Q?EIljMpIQJ//2v7prHsZLwFMfgAERcOobR05GBTkRpbPVEn1IIrDMS1Vx9rfg?=
 =?us-ascii?Q?MWnvwbKKtpAxLwjPpP8rpr4104/HvGMKMYg+tvnbXh8WGlV2kH+1ztWu6eYS?=
 =?us-ascii?Q?ypCs+TBnF/Mhaq2K2zUy23Wvc6cucq+Zqhxl+6WItAsg6WP/78p0ahTTnZ2W?=
 =?us-ascii?Q?sJEIumocVgt/PE+uEJIOB5UxqkGVFAKypESPL+x0fcIiRxDbWG/FDjQF5+8C?=
 =?us-ascii?Q?0/FAyF8KzA5wZwqyF9LYhWvutoD31JPhiKaWvE1mO7di4rEze7y6RQlhxDna?=
 =?us-ascii?Q?jVwLwrWj754mi5YKzqUjblvS3ie+cXk6EyIqsCvOJtExYZf1AI9pud8eual+?=
 =?us-ascii?Q?pNzLbdljgprdbFAz0EwKOPbvOC+kTfp0a/3G9zG3har9Dboz+ZqVaGoFYyy6?=
 =?us-ascii?Q?00PgR69g1iwG4BkzXM2zjLhVKEJrrI4f/UJASeEyz8Fd41393gbr2qWtYhAo?=
 =?us-ascii?Q?3qbpwf6oR0/J6oVSYT1UDdm01Tl/0PK8m4fEisSwR0RBtJeXtj4lucuxgEKF?=
 =?us-ascii?Q?O7nr3gPqbyx1C5nULe6B3TA8plR45bkAjX0NOEvbU7lpPbCulM5WPgAADZ16?=
 =?us-ascii?Q?ccTD8CN42UxccXMdd3jEdSHjAIbmDKwjB0J141BLcPcuJRC3iaCuobA02sV4?=
 =?us-ascii?Q?boB5iW8yVfgSFNnHW/BQC6QTbckjS3S5kvQrrD0dfKwyCV3s3jn12h61SCJ6?=
 =?us-ascii?Q?ejKijpZTWOjBMCZiRZS7kxTFnKYfCrnh4ARBj4ZI3TvT1zHcDW3jO5/oZqGs?=
 =?us-ascii?Q?8OLS1y6L/a3HuBBhXxoknVJhAeqX+ki73IFOD/5pCurdYnPzMLtNZkzXiNWh?=
 =?us-ascii?Q?UltHCmBs62IY9YEROIuMymhigSRRHV+VWrdH63qFGATMD0VEzgkaXF+cbprg?=
 =?us-ascii?Q?PKy921ODUKZXf6IDF/zu3ZWpTE7yRT+0RMizBpDHD8bcdCsokSznbXgAOkg5?=
 =?us-ascii?Q?dBJxtlFY428dmbJ//dLs1vnBW4F5YuWZwl+BS2quQlDPsACqFlif/w2DDhj8?=
 =?us-ascii?Q?IxPbWCX2S8oH3dP2waUSeQjsraQMU/hbUpGabfHLkaBZO25k2EFf9MfYnPey?=
 =?us-ascii?Q?aZm4xO50aQpBjaHLiRl62NusGXEPuuaItMu9FY74z/0z6SbALioDqV3ORAV3?=
 =?us-ascii?Q?yf/3NGtB8/2uEROrKZYdK38ayRh3yrVtyd3Hs6OWExgR8NJJPcdiWX79YxHR?=
 =?us-ascii?Q?vii10tqf/4LfMUJwi2EkInQ4hGvkEl+OSbufD3lKM7LVazJYnBOJl5znxYcP?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091a2b55-1421-49de-e7ba-08dafd5f09dd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 16:29:45.7792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3N6qltR1dcKfJ1Dk5A5NQ7UGSbaNu/97R50d6Cx2SYAIiZsfXV+YHdj9XJKOnV6CcQ9bXATD0J2L5MjvnN71OFX6LrF5fo57UndRc1fEvKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB7190
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
that the msr bitmap was changed.

vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
-> vmx_msr_bitmap_l01_changed which in the end calls this function. The
function checks for current_vmcs if it is null but the check is
insufficient because current_vmcs is not initialized. Because of this, the
code might incorrectly write to the structure pointed by current_vmcs value
left by another task. Preemption is not disabled, the current task can be
preempted and moved to another CPU while current_vmcs is accessed multiple
times from evmcs_touch_msr_bitmap() which leads to crash.

The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
solution is to use vmx->vmcs01.vmcs instead of current_vmcs.

BUG: kernel NULL pointer dereference, address: 0000000000000338
PGD 4e1775067 P4D 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
...
RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
...
Call Trace:
 vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
 vmx_vcpu_create+0xe6/0x540 [kvm_intel]
 ? __vmalloc_node+0x4a/0x70
 kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
 kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
 ? __handle_mm_fault+0x3cb/0x750
 kvm_vm_ioctl+0x53f/0x790 [kvm]
 ? syscall_exit_work+0x11a/0x150
 ? syscall_exit_to_user_mode+0x12/0x30
 ? do_syscall_64+0x69/0x90
 ? handle_mm_fault+0xc5/0x2a0
 __x64_sys_ioctl+0x8a/0xc0
 do_syscall_64+0x5c/0x90
 ? exc_page_fault+0x62/0x150
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
v3:
  - pass hv_enlightened_vmcs * directly

v2:
  - pass (e)vmcs01 to evmcs_touch_msr_bitmap
  - use loaded_vmcs * instead of vcpu_vmx * to avoid
    including vmx.h which generates circular dependency

 arch/x86/kvm/vmx/hyperv.h | 14 +++++++++-----
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 571e7929d14e..4ca6606e7a3b 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -190,13 +190,17 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
+static inline void evmcs_touch_msr_bitmap(struct hv_enlightened_vmcs *evmcs)
 {
-	if (unlikely(!current_evmcs))
+	/*
+	 * Enlightened MSR Bitmap feature is enabled only for L1, i.e.
+	 * always operates on evmcs01
+	 */
+	if (WARN_ON_ONCE(!evmcs))
 		return;
 
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
+	if (evmcs->hv_enlightenments_control.msr_bitmap)
+		evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
 }
 
@@ -219,7 +223,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
+static inline void evmcs_touch_msr_bitmap(struct hv_enlightened_vmcs *evmcs) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..1d482a80bca8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * bitmap has changed.
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+		evmcs_touch_msr_bitmap((struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs);
 
 	vmx->nested.force_msr_bitmap_recalc = true;
 }
-- 
2.25.1

