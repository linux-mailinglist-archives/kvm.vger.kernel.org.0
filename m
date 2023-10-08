Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461277BCEFA
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344890AbjJHOy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 10:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjJHOy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 10:54:28 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2159.outbound.protection.outlook.com [40.92.63.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C935A4;
        Sun,  8 Oct 2023 07:54:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMmJa60OL51BurQg+847fy5d+UwpqF8hHYXORAKjergNrx9iIH+btJ3YEp964hBfk+El3hpE6gD66QDs1ESHRlZ7MYomIoc6dOBY+aIqWJ/Z9+kzx/ogR10w1aW2asghTwhShggwIELA4DtE8BlMf4ImbFEHilOhx/214hR2+7EqrHQ+rP/LoSKcsrquh8jQ5E36JBVi++aDkOaJ424L6ICU7cPojB7M6Zv11xXOOehZudETj/TClqYp+XehiqHEcx6duz1lFHmdruVPXEX2S68+8DMxHuYwilvO2LbyyNJunE487Tzw9TqWzskuklF70iAL1fH+SLtUQeBDBdbI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4dan7kHVeyvxdy/3lD+tO9lH46m373g697XhVl5n5o=;
 b=CvF8ss5hxHSZ2RFGh5rCoBTg3lL9UnWhZsnN6Hs3Zj+aGGDzTaDxX957O8SxkqcTwiLQmCmWyu+ZrOKJW/1Yd02/Z0t2CdLI3H7ii/LZjos14lDGGnn2VbrqXirx5SiHQLJ1ldSEP5/pwcaxjCIeHP5N9G/mXCD+7XDeQX2ZqBL8Rjt9r56NP9lF5d3c37ny/pNu8uCPKCxh4TaoooIQKNZxs70ZZtNCqtq9msO8cWguWpCpSQgFHHHEhyaN+r/h89TsiTI/nIqjKNTzH3pBd0dTvU/J/K7nnRy0GBa96hsDv7RnbGK8IZkwDCrLC18s0VZpv8ffh++ombsO/cKYAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4dan7kHVeyvxdy/3lD+tO9lH46m373g697XhVl5n5o=;
 b=rStEOiy+g2M3KYn0YHg6AG7GWqNO1I50nkUH5LbNIrlFbiglzFZOnswMfP9vy3NJzQC7o8oCfm/vZjSuI66fovGjn7h4rpNnwdd4evx+rAhmZCURhMH2sJzolZmFTN0t18Qfal/2Dup5BaJZGeQrtcT7kJHF4D5hzndObqU5erkvmktfdGufMWgIpEcOfm+sOHAEWH7jtUaGU9lDjuuXoa0n+oJRJgSvxv/V90skvyjBBCCdC6gKb6OgzI93zu69bFWjKN5VBlhtDODdaTyEjozKPY/G38eLmZeWE8tQqu7y46zyVmV0A9VUc7NHP0XgxLSWEHMQoiYtY+DIpPZX5A==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SY4P282MB1371.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Sun, 8 Oct 2023 14:54:20 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Sun, 8 Oct 2023
 14:54:20 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v2 2/5] perf kvm: Introduce guest interfaces for sampling callchains
Date:   Sun,  8 Oct 2023 22:53:59 +0800
Message-ID: <SY4P282MB10842B9353422CD2C86DCB929DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [iekiAmTYnBBVvcmUmOfpwm9LbawksJQ1ZghS3+UOfjPumANR7m9DTQ==]
X-ClientProxiedBy: PS2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:300:59::35) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231008145359.7269-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SY4P282MB1371:EE_
X-MS-Office365-Filtering-Correlation-Id: 57133fc6-dd08-4e97-d9d1-08dbc80e738b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qf6odUHCy1AankStOFkVtSxY9m0Sq9VLW7IJw5hiqxXsrzkt7PL1Scln628kVsZSSXHO/iqBQQZ907wnHf2JgBr6KjcgOvxgVhK428UtgZAtuQa0b5ZdzckRixvRLR3RURwgMskQH88qIHFh11tV+V0OOhJMGcF5+UulU69Z9BliO7HkrzrCQQepOkazsylX29sfhDnrfrgvFs4rGkxMPC/qPbukOOjk9ohyaCd9r92Fb1pmLiifBz+VYvWKllwQ8az5fbLf+S0d2KqzWo6bFn5yfyPbX4LNyhXgYgiHfRYv58Ai6gIKNOpPENmInHfHiyQuGwOe7lDn/nyTdbRuH43Y3NIS5l4Q2pbQGrvtxmE/2CItK0WKTT9BTEEI2IsevjslxL+QMg2jC39zwXuo4gQhg3OnzMkQVt2RR6iKXUIT9zv87FMkQUngCINGsDGX3ec/6Td1/a4aWm40aIXeUxg179H4KbRxsBJ0ns8kacIDHQh/JMyS4w0vOwMlh4NiC6xnDQOQb3z1CyseuLWHde0ARb6TnImii5eioXXulTTGP2U57tZc0vDn+FmZJsycRyXoHbmkIQL+qkLGGblmEEVQ6w/LV+wenJ3BUqfQpdTrwQBrP6PXkE0FeMge9hpj
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTl+zseYA3aMpBGUHatuh9UjG5ma3O9e1XER06oDU98fC5s5nD+97kSfEGs6?=
 =?us-ascii?Q?+tR5msYzlqKLpz/3BpD3RuvcdW2ntbbHyWPRFVJJCF4BfBj5YyA59gzHzZ9y?=
 =?us-ascii?Q?9Po6Is5b8m1L8fTSnDVWpEcJkWGls4nSTRLj7rG1Ug4t7UP7OzkjSWAaYMwR?=
 =?us-ascii?Q?Mx48L7rtnXQ2FsramireeQBxenv4nfuupLbMqXCJ2Vpz5Je4tLtjqu1k51vH?=
 =?us-ascii?Q?q2i7lLyHNlJQwpSRIJsiFGIdgHSJcC8RKGVrUnIbYL4Vn42dHwQUOTCl7oI7?=
 =?us-ascii?Q?gcKvnvdsRYGyiCCMtqmOnyRuUEJ5zWcdkOpFVg0ogM20rXMDoetQ5PnzapaP?=
 =?us-ascii?Q?ZEZE0XK24hr100WOSQydLV0XLxyftT4KWT5nC6bkGC2YQ6nmQB8TbuhUWwf4?=
 =?us-ascii?Q?qh7YMbbuXK5QMlPK4VjnYV44AZzIWnvcaPebNimwwx8rxgp44WSI5XZ1McNQ?=
 =?us-ascii?Q?ByOes8YiuOIj1+PTSTdne4ECiLDv06fZUoS9xA8sgEMdMQZPxaXMr/Ws+JpV?=
 =?us-ascii?Q?O6jvSxd1AVIQF3bjAFD61C1Or9wfVE7Dqt7CYoUukY3Ad/lo3ts0MA6LZc+2?=
 =?us-ascii?Q?y4a53AA1nMfnPz69osfn1uqZS4WJijOstNwU8/KUiztAsYf5hcJpyJ9UIEIq?=
 =?us-ascii?Q?3L27+G0mU5IlVcGIjyYi8dnCbR5IQcnWAFGOnKyy8CzXYoonjCr1sunnBE7m?=
 =?us-ascii?Q?XnJ36mttjDHJiBE2q5mjeGcGNKhdsVSP+thLeW4xp97AGuCbZhXNQjWQmTr8?=
 =?us-ascii?Q?efodif3Ee3Rzhg0IGJsh1dDEJyMrzsQl8vtDLBEERSMRld9m5Rkg0p9hilVn?=
 =?us-ascii?Q?XXMDD+yM5oe1xZvaBNqVgxIRgDve4hNZZJ175w8heD73g6Fhczp/s/DEjG8G?=
 =?us-ascii?Q?brUBXvTP4+SWOR6Y29P2c6BKnNqukmhjO6uP+Syo0tzooIN6VTGt81LIn7R1?=
 =?us-ascii?Q?r55XFjA7Hob7sCRL8ncf1av1p9z5xQu2L1036Y4dyn+figMZWe3ofvi0gQKt?=
 =?us-ascii?Q?aHVbkqRr+p2a0/b63Y1hpiYVxBU0vUT4vDSUKSIFkzRu+2lOsZcNzQfvrMeD?=
 =?us-ascii?Q?nVAwChEkwoUptCi9nF1LX9R5R14fDAO2sZU8jbWzuGWDd2cURsyE2h5bVgvu?=
 =?us-ascii?Q?Xhu7V6WzGeSRz9Y7j88/1loyk0gMagYOtdtrN8bmDPuvheXphxi03sOKujb+?=
 =?us-ascii?Q?HVCMaJAEnJTMesOKhber8BpAzsAI/kKlwc8EZRre3li2eCJcAekEHx1H3cW/?=
 =?us-ascii?Q?I+/uNRekbXb5OtAD8ggw?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57133fc6-dd08-4e97-d9d1-08dbc80e738b
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 14:54:20.8541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1371
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces two callback interfaces used between perf and KVM:

- get_frame_pointer: Return the frame pointer of the running vm.

- read_virt: Read data from a virtual address of the running vm,
  used for reading the stack frames from the guest.

This also introduces a new flag, `PERF_GUEST_64BIT`, to the `.state`
callback interface, which indicates whether the vm is running in
64-bit mode.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 include/linux/perf_event.h | 15 +++++++++++++++
 kernel/events/core.c       | 10 ++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e85cd1c0e..d0f937a62 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -28,10 +28,13 @@
 
 #define PERF_GUEST_ACTIVE	0x01
 #define PERF_GUEST_USER	0x02
+#define PERF_GUEST_64BIT 0x04
 
 struct perf_guest_info_callbacks {
 	unsigned int			(*state)(void);
 	unsigned long			(*get_ip)(void);
+	unsigned long			(*get_frame_pointer)(void);
+	bool				(*read_virt)(void *addr, void *dest, unsigned int len);
 	unsigned int			(*handle_intel_pt_intr)(void);
 };
 
@@ -1495,6 +1498,8 @@ extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 DECLARE_STATIC_CALL(__perf_guest_state, *perf_guest_cbs->state);
 DECLARE_STATIC_CALL(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
+DECLARE_STATIC_CALL(__perf_guest_get_frame_pointer, *perf_guest_cbs->get_frame_pointer);
+DECLARE_STATIC_CALL(__perf_guest_read_virt, *perf_guest_cbs->read_virt);
 DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
 
 static inline unsigned int perf_guest_state(void)
@@ -1505,6 +1510,14 @@ static inline unsigned long perf_guest_get_ip(void)
 {
 	return static_call(__perf_guest_get_ip)();
 }
+static inline unsigned long perf_guest_get_frame_pointer(void)
+{
+	return static_call(__perf_guest_get_frame_pointer)();
+}
+static inline bool perf_guest_read_virt(void *addr, void *dest, unsigned int length)
+{
+	return static_call(__perf_guest_read_virt)(addr, dest, length);
+}
 static inline unsigned int perf_guest_handle_intel_pt_intr(void)
 {
 	return static_call(__perf_guest_handle_intel_pt_intr)();
@@ -1514,6 +1527,8 @@ extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callback
 #else
 static inline unsigned int perf_guest_state(void)		 { return 0; }
 static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
+static inline unsigned long perf_guest_get_frame_pointer(void)	{ return 0; }
+static inline bool perf_guest_read_virt(void*, void*, unsigned int)	{ return 0; }
 static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
 #endif /* CONFIG_GUEST_PERF_EVENTS */
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c72a41f1..eaba00ec2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6759,6 +6759,8 @@ struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
 DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
+DEFINE_STATIC_CALL_RET0(__perf_guest_get_frame_pointer, *perf_guest_cbs->get_frame_pointer);
+DEFINE_STATIC_CALL_RET0(__perf_guest_read_virt, *perf_guest_cbs->read_virt);
 DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
@@ -6770,6 +6772,12 @@ void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	static_call_update(__perf_guest_state, cbs->state);
 	static_call_update(__perf_guest_get_ip, cbs->get_ip);
 
+	if (cbs->get_frame_pointer)
+		static_call_update(__perf_guest_get_frame_pointer, cbs->get_frame_pointer);
+
+	if (cbs->read_virt)
+		static_call_update(__perf_guest_read_virt, cbs->read_virt);
+
 	/* Implementing ->handle_intel_pt_intr is optional. */
 	if (cbs->handle_intel_pt_intr)
 		static_call_update(__perf_guest_handle_intel_pt_intr,
@@ -6785,6 +6793,8 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	rcu_assign_pointer(perf_guest_cbs, NULL);
 	static_call_update(__perf_guest_state, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_get_ip, (void *)&__static_call_return0);
+	static_call_update(__perf_guest_get_frame_pointer, (void *)&__static_call_return0);
+	static_call_update(__perf_guest_read_virt, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_handle_intel_pt_intr,
 			   (void *)&__static_call_return0);
 	synchronize_rcu();
-- 
2.42.0

