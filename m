Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939AA678A91
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjAWWOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjAWWOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:14:08 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2104.outbound.protection.outlook.com [40.107.247.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FDA3A5A3
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 14:13:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQHd0jHXE7ucdGsQ6DHbK5Y+JRUK1UuESqk3RNzEAje9nBYogF99f+F0ZDtTOXUsMtLKND3WYEOd3/wWs7q4N21TQj7wCjS0OA3/Pnj9Ky8ykUEHLx/G8r2xdUHRmkHCHgpH7ZRAz78hAPm+O24ArOfWgu0sFLGbiOYEkNSCewxvpi9moK96goL1M/LzvNH/WTLpWeXE0MqJcUMyyCwOnYtO+T36C6sskV86h2nagjycOds9RHFqDile2swGwTzPzN4lS602vPUAQPPR4og/PX+/Q6gnt2NUHFlHP/6XIMa0q43WgndILVQECjXzkesJUJv+EeHuKeHHTM1jx5vOuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNRiFUosl6nGC060NdETbBXQzI5avogNFPe48Ox9k7w=;
 b=F1PsV0LTuI2PqcWfdFQoH9Tvzp/l+vWHSrw4GpEj08P6eMdlgIiW7eIsvDulr5hX25QynJXqZzavKYm7GwoNpnjP9Bn/b73MTtkQzMHVYskvq0a2hzdF5GNvA99s0+NOQuLXQCAJI3PVwAwjgmCzTFxI+9RsduGvuR21vs5hHkBP+vAV6x6ApvWJ18WsYktdwKoN61KiOtJtS7TITu/xxImeW1wk7Jo47VhB9dN60ww/J3Koz7nsuBLxlVXDAF7RJsgsfjC7zZo1l1ahLD1CkXvgKWmIcwQFRR2eahjUN6EyV5INpb3n03q+AcNwSlWf1J03Ma0lh+yI5x/DgU7r9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNRiFUosl6nGC060NdETbBXQzI5avogNFPe48Ox9k7w=;
 b=QrgHn1pD7X1Rmlgw3QTsHwbrT71/1SPEXHmbrERvKNhbC5BA1bwujsXpJvNrQ+2DTQe6Drv19I7HaPai3v7tYk4TdyVB6yA9Jja07UO4fM3u6YIGmCbV0BVnvjaii8Q4t1HeBsxiY15IV05cnGoZ5ioOZ/Y2enfVciz0b/FQLJi1NHv2PWvuvMuQX2in6hNG0qNGnPB2K9QfDDWZZ4w7Xm7biXrOjJXVp+Z5p6D25oJnX3s4oYvAr7W5FL45LHVpWFwv2SsxbJsrxwZ7Z0ZFPRYur/nHcHO4K6mp9ICPjqTH8RxRmfhikeQiNnWOe1AYlp2gHwbXytp6u3xg2tMk7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PAVPR02MB9378.eurprd02.prod.outlook.com (2603:10a6:102:309::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 22:13:40 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 22:13:40 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH v4] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Tue, 24 Jan 2023 00:12:08 +0200
Message-Id: <20230123221208.4964-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0072.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::34) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PAVPR02MB9378:EE_
X-MS-Office365-Filtering-Correlation-Id: 0edc9f32-527d-4611-235e-08dafd8f1513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BY5zHG1VpbxidyLXOobqO4dGYACreVQAtDOMi43V/jO+NUvGbj4bQ585rTVrEhVmeePAITIXPcZr6QOsYce0J3sV+nHCi7Kc9rlWwkLvbpi+cB0cANQ52SSNmbuWSF05AnA+YL6YN8gAE46B4M6NHJQ6q6M/pY+2jC+8++wypHc82Z4PFpJ8j61NYiSkUUS6KOjpSQiDZcrQ4ts3xpqDLuIxw7hwgUjJWkPWyjIzbmGu/QBsvdQMf9KRmKBgttElAO7jyjYoAOAQeRLZCua7zvV1RHdHtDrhrQ1azpIG+ZHufFzQfySC1rLYgg8Ji4MdUK16r+rDKqow1c4f9QTUtl8mDu5L/QjO8I2PWeMMnVN+r+uVXZOjJH85ERcYkTi388VCYVYY3/U212S7U0qyeb7XIBEdSNSFpNmKoAFJmvhxGBIoZ2fzxqHNotwpBVlktzgzx4WPsnN3ulzbU3LvvzSv4T2rcbemm9lCZx8YagtgXA7oxf/rTMG9T0CLFdr9kJ2B8jLJmmcBxNok7BK8OHLjdo07u0w9WGKtQX803mCnp9V+U4VIfSC3KXQg2F/qDIaJ3dRYYs5Ic0PyEFey23uuIfyMMn8VF7MR1lEuIst6bw5qawC1R2y9KZuRX15QKT7/TTsnkmU0CC9W7Gg2Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(38100700002)(36756003)(110136005)(86362001)(316002)(478600001)(54906003)(6486002)(2616005)(66946007)(4326008)(66476007)(8676002)(66556008)(1076003)(2906002)(6506007)(107886003)(6666004)(6512007)(83380400001)(26005)(41300700001)(186003)(5660300002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bk56W9MH4DS91CF8DqVKl/6BOjuiTDek4g/x/bJNjDT/WDwNn7d01mOenBJA?=
 =?us-ascii?Q?5n+BeCLHw2qfTjo0sdcEz6NPVddoroA3z8mk44u1rl+ROIMjMx8uqPmkr7V0?=
 =?us-ascii?Q?SWC0bn4jY/EKJ8IU8iesv7QKxTUvH53SvImfPkmQEBTNM27UxR97zJ8gjWHU?=
 =?us-ascii?Q?ikQ2qC/v9z2iG6FjjRFJMJOSpDHOAHtxcMEf7OAcxdhbrFeSnBGqB3Ysn/hD?=
 =?us-ascii?Q?UfXoi5WWD4XvJ/9Cfsp28tzbAnPXqBrGYd+gZ4W4xB1F6+gNZ5xGgjYjt1kw?=
 =?us-ascii?Q?bimo25rkMn53HCnD7X09b/ZDgH8QYqpr3Pg4ZgvuCKiIFv4dX1WQNZxdAk4B?=
 =?us-ascii?Q?+K8VEIaPNDgbQQF2RAH3tE/RjxEfuYYReDlqMyyk8KtaHX41FYqR4z+3HTn/?=
 =?us-ascii?Q?aMR8ZMucRAX25v7RSG60dst8EtwucNELd0nYeMvyOgWSFsL/+mq9dErL9JYX?=
 =?us-ascii?Q?nfGsqwrfyOz9l0L7TXQ/+p759bdqjkkwj7XIKsXTzG1/DOlin+I9kdjhM7IQ?=
 =?us-ascii?Q?NF47FnJGQgDpF8zvqFcEo8lAtg3rDxE9l3DrQLVOJjKC1vg5jK5bi+Ov0Ozi?=
 =?us-ascii?Q?BfMPg85HBir9bTNKdF95vgNXTQ2u9MJQ+cXmqeFZUyHeEhQc3Ohgxsp+5PC6?=
 =?us-ascii?Q?vzMbElUdfuGD7SDoYgL9jxOnczaQeTTgXtb3Ks9zLF33iiZfYcKzG6Dtq9cL?=
 =?us-ascii?Q?pPNyuyn3WEYQGMcZAl8p0t+Yz+nFR6Yt2YjqhWdyDXv/CkmJngxwp3TSIzte?=
 =?us-ascii?Q?+QtE75XxtV5wQjbv0wAD5wRDZr1lDrr3EI5L0gzd1l8XCG7tZfJeEG4r6iuk?=
 =?us-ascii?Q?+5TaWzrw15cmTQ1t08cnpRzISIaV9EJaWnXcpeEwiGA23nnPlc8UjP7rm/Ed?=
 =?us-ascii?Q?w4CB3mWxeLn1jx2pVXj+0Hen6SoUDwP3gYwNf1Unad4gRPFamqSitJYPYiId?=
 =?us-ascii?Q?mi8YqPX42bjHqIlah8aJ83imgY/G8jMlnfNGywmQ00rIcTtJE90VUbcC6/Lb?=
 =?us-ascii?Q?n2vrW3c7s72k1KehYwmFSSLjBHxGI7+2cMlSm6gZzFDwafDPCd+hIOtzR9Pt?=
 =?us-ascii?Q?RZ/Nl7IcBoJOR9MhIEVXXUTJ3Kyjcv45Gf8NnF9DI76yFToUb64M02qT0nbt?=
 =?us-ascii?Q?PC+aTO95PHKPg3UcK739N6WCyVBcKcN4wLArC52XyioREyM9a6Owz3LoBN+z?=
 =?us-ascii?Q?iHNjbMfNu5iRF3eStemBf5QtSVBePN5yBNinVvoxQyQxD9YFH5PInb9FPpZh?=
 =?us-ascii?Q?i9Iz291h2Iuef294Icxo/VCpcuRb4yO/ch2FXOfiu3F3xdhIWqFtHLMiNr/V?=
 =?us-ascii?Q?Fse7MIEcRu4FRm9IykY0D5RFXhbjC6kSHERNkM8WXeRJuCQPjLsrEJUqDpLM?=
 =?us-ascii?Q?3qm8xb+wi0P0qcKpELdH3FN67W7hPX4HtNMT+5faVnb89pYAlQ4TpnWQvpwV?=
 =?us-ascii?Q?grjM+dVrBgpWf3g3KBl7xX94BeORp5jixc094yYSSL20qgPLKHnttl8gAx0s?=
 =?us-ascii?Q?B2nehujVYE9vCuuZHDnSonmP1g4fZ27rpqN36r39Jqy7219Zd+Q2zBtZlxTc?=
 =?us-ascii?Q?TqfKLBmF8/vi38FaZFh8yvlfHBD4e/T6B0wkkoebAepd8u9WZvwcuR0jaBoD?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0edc9f32-527d-4611-235e-08dafd8f1513
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:13:40.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrFVZTQnTFbwccTebOqX77hqRvcNn2U8mHRUBPAV4IGliUzoJ94qqkcp6lzE3AM7RpqQbjQU/92Z3rdtX3wZ6gdgPlqae3fYavOPOqWyHC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR02MB9378
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
v4:
  - merge evmcs_touch_msr_bitmap into vmx_msr_bitmap_l01_changed

v3:
  - pass hv_enlightened_vmcs * directly

v2:
  - pass (e)vmcs01 to evmcs_touch_msr_bitmap
  - use loaded_vmcs * instead of vcpu_vmx * to avoid
    including vmx.h which generates circular dependency

 arch/x86/kvm/vmx/hyperv.h | 11 -----------
 arch/x86/kvm/vmx/vmx.c    |  9 +++++++--
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 571e7929d14e..9dee71441b59 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -190,16 +190,6 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
-{
-	if (unlikely(!current_evmcs))
-		return;
-
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
-}
-
 static inline void evmcs_load(u64 phys_addr)
 {
 	struct hv_vp_assist_page *vp_ap =
@@ -219,7 +209,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..65050efb8ae3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3868,8 +3868,13 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		if (evmcs->hv_enlightenments_control.msr_bitmap)
+			evmcs->hv_clean_fields &=
+				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	}
 
 	vmx->nested.force_msr_bitmap_recalc = true;
 }
-- 
2.25.1

