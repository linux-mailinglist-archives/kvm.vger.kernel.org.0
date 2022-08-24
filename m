Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA1A59F35E
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 08:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiHXGDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 02:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHXGDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 02:03:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE2F91D3E
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 23:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLpNID4YkxvTB3t9/CIX8S/4tbMYgq6mJ7SpH9u36BTYGW8coI4BeVHGWTroiDiiW0TypQ0ImYobTM2yhap/ODOwqTM9/iq1ART3pwzGjrMhX71H/21Tu59g/AchcysCbI5upthrtARby8grZahovcoQzkP6PiRF4gqZsvp34BivX/QclTCLekT65nzue7uh5QmVr2mReIlTZutaayaoFeCkQYHX06lMi0dhRtaFKpHwnztuVLQqDnHXg2+CfiC5uacr26vTa2KJpppUQsrKlbP/E1JIKCP1RXCfqecWteI8flzoVIo7ZqgLhSxOmOKPsRSS9mugFql+vZLjvzvfMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrFHdmlh/0Ys+L38kDhMFewTignwonVRVzXZQinc6Rg=;
 b=XPOJhwLdDJnhA9nFHAiesFBHjmKON1stEt6VtPESWbpAEUTznDkqc6YBMeuVPv3WdQeoJ5dgdgU3C2Yyt87rTtFHPq/MwwtPT6jWZRSXP20XlxMIn0cOZ/OzI2r0pKU/Y9ezmsTR6i2h16Z3IdZ3kpMsua1jhgtnPrrqpUlEhDyXBrpvjS7EdeynjZYqbuO4eUwKcJ8+xWX7lmZC6zGsBipyX8oPMezjL4GqWV/AJT5Re6beab5x3PR0oT+OqO8409W5qrrYDQ6ocZQyo9S/YFxSCfXjwq8lifkW0IN/PI1/1cIpkoKVOvmp/iDbv+b3TlbU+djGFUTtGw6xUMMliQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrFHdmlh/0Ys+L38kDhMFewTignwonVRVzXZQinc6Rg=;
 b=fbsAANdJiVj85myP5T65tS2S9emBxgXQUOBi1c4I35TX+TQsTrcx2sOxCGGZsWfSQ6PXJC5NqScqTuL12t0VDdk0j2R/7Wq9jbZbGjn6v+IXkRFzjHEDA5fVIoUg0Rg3NHLkxOmrZI1MviVeFnyksEyX7Abj93IEUUzGBOLrJO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB5914.prod.exchangelabs.com (2603:10b6:5:14f::31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 06:03:19 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::7058:9dd4:aa01:614a]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::7058:9dd4:aa01:614a%4]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 06:03:19 +0000
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        gankulkarni@os.amperecomputing.com, keyur@os.amperecomputing.com
Subject: [PATCH 1/3] KVM: arm64: nv: only emulate timers that have not yet fired
Date:   Tue, 23 Aug 2022 23:03:02 -0700
Message-Id: <20220824060304.21128-2-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::28) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eca2283-afac-4ca0-fff6-08da859657bf
X-MS-TrafficTypeDiagnostic: DM6PR01MB5914:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4PpEvLFvN5FTEPCYCQiGlqPYu/7VxYZH3svGLkLcGTQ9SrYSMWnZkXK5eW2U3Q9eIYY3dm8wYhdLgJrxtVmuD+eUpplPJHtvO8EUgf7A7ta9GQ9M7LWtA2Eddy/Ua7/IgFv58R/CVT34Xr0arO5lxS1bQpbX8d29rL76Fe8qqLmiqQfYXyE6+2xMryJsccWFGs21Y8PTwpTrHloCaOtEqdCUideVkDArgDFWhstWrLV4+D8ezCkAFlbvUj/5KgB6PDmEPkDbcWZrhQJeASaRGdiFqkjarqVDNzT9VsS7Q/kZhHkgyRRQvT1ABqppnXCZQ1E10LE7kjooPW6dRCgEgX7kr7l4TTlwyOX9iD/TnqTRCySrYJQv/w1F2fpzmxh+hXDJ4BCP/5n5/j3Dw52FZv5oAOYE3kawN9jnMd780liJIAJ8cbHpVwUkQFF0VC7USv6AnbNZiupWYQYZoNh3kgP2LohIZdn4kLWXIfuUej8xr+QNubcWrtrA+lmfl2gaQ2shKjEwIopvzVRLTeBF6hlu0t5bX7oryX2sBc2JiYose2TRm6x6nk6DOcobOMvX2IDL5FUbObgOT1AGI0K1rj9XW3UW+xC5AvePyd99GRV5nhRDIIXkWoXG3WtM7uQImkT33tm6UcyeE23kEsxu32O1hWOy+NnKzvxbha6sbeQPywfR4sMyxf8Jfx1y7j4WF2khGPPS1Ddnz9YQzexOnNqZImDKYt/0m8hCwlmB/+D1ip+r8Y5nz3NLi6PzEX1jLLKLH6nk0rnWajem/5Vdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39850400004)(396003)(376002)(136003)(346002)(86362001)(38100700002)(38350700002)(6916009)(316002)(2906002)(8676002)(4326008)(66946007)(66556008)(8936002)(66476007)(5660300002)(2616005)(1076003)(41300700001)(478600001)(6512007)(186003)(26005)(107886003)(6666004)(52116002)(6506007)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O/ya8Pz/VwmzUfcz7EyiwSYqj0pjjlgM3eyX7hDMEJ8uLUa3JXwSOM4nRaz4?=
 =?us-ascii?Q?gpOOK+NC8+h38mq/h3xKrSETnJYUB6WqVbdtr1GnvNVuHGkht2NyBkJe6929?=
 =?us-ascii?Q?HNqs9pk8Cvt3FhLvNi++UsRZBinTpTA5QSEKgHa6LUPRkvvu12KKDg2dTwvA?=
 =?us-ascii?Q?l/pbUibOMjVx/6ETRha53sCCb/NoD86ftOBUu8nekLmQgLljwlDzjHvK/klV?=
 =?us-ascii?Q?hBaErSL3mB0dM7BL4r15EviEvv/f3HPqTyg+n4GJJ1wgc44XSU0sDTTWzm3W?=
 =?us-ascii?Q?ZWILysXs+O8phCQfP/IX3r2/4DfGLdE3Ql05fbncJ+CbrTvjJeAw3YPVfWbv?=
 =?us-ascii?Q?nx3PiPrPTXoB/W/GDwSa0srBIbia2TkYmykBoBPqfkY98Y2VPMQp9VJLTU2I?=
 =?us-ascii?Q?LM4Hq5jFIPmWqiYHwNg3o0nRUxDChz1VozfNglmgPiVFekDyXRl008mZ2z9s?=
 =?us-ascii?Q?nS5r6J6nT8PWGaT8BZ2Whk2vmuVaB4McTaXqrwE0Hq+Vu5iur3Q7IkQGe/aZ?=
 =?us-ascii?Q?dlMHB2gQo6KG9ez1v0vA7GOWEaufhZStbkaH++dU6r2mAqbJal/ILDOJgW5X?=
 =?us-ascii?Q?H6mkUf8mOruFlSwkg0fN4byF2xzQB2JgQbBjnjG2oI5gSxmTe8ffwwO52H7w?=
 =?us-ascii?Q?W187gfTbTtlH7ifARa5Mc6cEFMsZmnGc0Tb8ZhSjcBax0X9hhY0WnXyF3ZwU?=
 =?us-ascii?Q?s9xLQskaoPbYV7vXeG2GWmiYV5+9hrCEpmHZlyUZvcmRhte5uAqywSKRZMqc?=
 =?us-ascii?Q?4FUTDA5c9+EVSrbjgT3WtA0+M4TKY+KCq0W0nJyr51f8T0DR2GJutMeL4eeq?=
 =?us-ascii?Q?ydAPf0Yu1bX2LFXprlfCDAEtqEigMbAfwzrTCsoWb+EV2JoX4ui18OmGu/4Q?=
 =?us-ascii?Q?xyrEeIC3Y0jY7ewfpFca8qBfLytjPl77KQKC5V3/RQlcCZGMGSEB46dHwv4x?=
 =?us-ascii?Q?uHuvlKyLCoybMjjMPQrgxyFEV3XEZfzoCgKxv53SDzbJ9Xk7AYG39R1jue0f?=
 =?us-ascii?Q?kb5yow8e/6Vf/QFlFGWBLxPMymwx8rge/gBnbggBkH9gmRfF+dRJGqm8eQ2y?=
 =?us-ascii?Q?uFYQhq07jUjMOY4zGmjjT3ISeZT5st83MFzKXmXMpbJ3jOyjw4gE9nc1A9Zt?=
 =?us-ascii?Q?5AAE+vPfRGRdvlcMKrZtMH3OkREJdALXetTEC4ZaKbZLhqYTMb68eYF2aEZ9?=
 =?us-ascii?Q?zvPvctQgys560w2TdDJvPa8ZnrkvdeMkKZiF9xGXfBuIgVYP6TcvwIpkWKiE?=
 =?us-ascii?Q?VrcY8EZCIMCnQZJIX4AmJcUWVvAqy0o4o1PTOPjaVkL14ucdXJq3vUpJ4432?=
 =?us-ascii?Q?Si7Ia1LBxz3jffkSYj/XKN5V1k0RujA/0U885mKVrGf1/WPbGXxPwuSIt+y/?=
 =?us-ascii?Q?98C/0C5JOOicNUEr1wT+ot0Xc+10zF89g3FC+w7z0yUxQc4Mad4c1Hk2FTUx?=
 =?us-ascii?Q?BYkhHgwTwWVNTEU+n7X55N8SqdmAmQoyNwNveq050ib+PeEwEUadZnclUtzX?=
 =?us-ascii?Q?8S0WvVOS3GxTvw0tcCnS7W4PAXrFHomqNRKOz8/gqh4taXdfp1YcfGKwIr6u?=
 =?us-ascii?Q?mldcYfxnIj5U7tc+BpagkAh8VvmLdFRt+3LoezKbdyyQ2vzIDEMvL9BxN6Mt?=
 =?us-ascii?Q?uVgPkF+nBzU8n7vSiYn5JwY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eca2283-afac-4ca0-fff6-08da859657bf
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 06:03:19.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VeH9axaXcvJ3XdIjzehy6d9bjNezPSHzGr4kSUoqReWWjT+DYFSBbBtRBlhLKpvYoujtyLZkHzzThrD7tW2fUbzvI8OBHhCXVzo0kQ8RRJHLN9+uiXOlU0TaeGpfFzQP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5914
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: D Scott Phillips <scott@os.amperecomputing.com>

The timer emulation logic goes into an infinite loop when the NestedVM(L2)
timer is being emulated.

While the CPU is executing in L1 context, the L2 timers are emulated using
host hrtimer. When the delta of cval and current time reaches zero, the
vtimer interrupt is fired/forwarded to L2, however the emulation function
in Host-Hypervisor(L0) is still restarting the hrtimer with an expiry time
set to now, triggering hrtimer to fire immediately and resulting in a
continuous trigger of hrtimer and endless looping in the timer emulation.

Adding a fix to avoid restarting of the hrtimer if the interrupt is
already fired.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---
 arch/arm64/kvm/arch_timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 2371796b1ab5..27a6ec46803a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -472,7 +472,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 		return;
 	}
 
-	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
+	if (!ctx->irq.level)
+		soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
 }
 
 static void timer_save_state(struct arch_timer_context *ctx)
-- 
2.33.1

