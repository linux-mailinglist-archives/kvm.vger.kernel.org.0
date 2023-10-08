Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F617BCF01
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 16:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344847AbjJHO6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 10:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjJHO6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 10:58:15 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2159.outbound.protection.outlook.com [40.92.63.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FD6A4;
        Sun,  8 Oct 2023 07:58:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYHA7nfuRuhvLMy72MpWJ4mK3Jm0xZBoL4TvC3AZpUGkObu3MqIGpPAdNq6CRxINikHisMUbFuSjGEW38COSqRnkdr0BS1DGvEQ9QHfyr/27lCyP6i6gPKQCOluAdUv1ijgPUhEDqzJLAC9iKs1IDbr2WB3w8TnEsncomocLtFx6xqk/qr1o+fQK5rVVpDVRLH/96fyWeprLL0SJ3+tT9CwDGbCS/lUcdfEAfR/vWTU+poS2FW3bG7UUM+j+xYxfelQ8Pgdnj2uWlolyIOXOqLALv9jxTtvHsmiwl++kzpAkfHeTjwFAW3ihnqKl6P9flpSLpTT5fbWlYXEbut82pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/lFtn/nLc2LrnucpQ3epHICG2GV9+ahNS6ImpVxMfc=;
 b=TkGgw0cIwiupQksITQIn8jAh0E54fPLFY/XgrbEEwAiUI20Z6gsXfFk7YK+4wEdrVZL72hlU/UR232OEju1DszJGkUVQmkunHFUzz7KkntaX8a5aoUEO7zqby4cLCxW+HXdRO7Pad/Gvn0M+4ZuYe8LCLJhk+YC+Q6U6Eyaif01HL7FGbG2fsohqqdku4QU/1SLpVNOudvIvZgyIfhyZACRmNICa/tpfk7Rkgl72RDr4aJxRXNEuCWpwDQb73ydN6FaOPweVXebbg3OZCKHk+wXt0raryqspNrob9XxJxEfXA0nd/9/FmjLgXLq+Pw5NZiLUg4DDTgfLYnbGR2cpxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/lFtn/nLc2LrnucpQ3epHICG2GV9+ahNS6ImpVxMfc=;
 b=FKhXYTsr2zTk/gvEePAaOzVmVfxlx3K2gXV4OWq4nlAeFmALWbAbOAA+tZ04CR1hcUeHcLj2mdGbmmqAreDA2dE+618R5jU2bbzf+QoxyJWx/66qtESsEu4rOyaKQFhwq/GXSqOHTkLpRHGQmVn4rD1N9hxla2jYhKfWdfHh2pUqVRoeydGjQnsEiQXYu2dP+RIP+P6c1wlRX5GU0442yW46ciOBVvrk1u7BRUW2swZmARqXG8E6k88WTItcfFuvjUyTkaXmxX/SSdLtB3nV3WJxiLTGxZgH0tNiWTISUgmt/o11x+nVcftwMJxEEYfgtu9MQcOdZRBR+HAMAu127Q==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SYYP282MB1101.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:bf::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.36; Sun, 8 Oct 2023 14:58:06 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Sun, 8 Oct 2023
 14:58:06 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v2 5/5] perf tools: Support PERF_CONTEXT_GUEST_* flags
Date:   Sun,  8 Oct 2023 22:57:29 +0800
Message-ID: <SY4P282MB108462B1895A79A8920DD6849DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [brT8iFehEOwCNXRw/nHup347yUJJMi8XhYPK+wacExEAGNvB18G62w==]
X-ClientProxiedBy: SG2PR06CA0235.apcprd06.prod.outlook.com
 (2603:1096:4:ac::19) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231008145729.7886-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SYYP282MB1101:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c550b0c-fb1d-492c-ce93-08dbc80efa0a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHeHlcHDe59T0Nksh3RMSTCkhCHOh9vZsPg/95V2XqN0q2P2+7r29qRIwKl/SpRRUHFpxFWeQA2OWsl3JMvr98XswCt7ZZkNa0XhTUQ0576IDW9Op3WoUzC1o/mJyyyK0W/deJGGZPVKkVhCwNjrOqE3jGe6gSyG8LX2bDNDTjs0QzFexZvY5uR1Lkbm+Wsh6edF8mdkMeLkoCKC5X6ApUHQWFRB1KAr07rKdcQhVsZA8Kgahnj67XsmXCYq0BU7gTDm+AyCnG5SZtR6kxNaDTt1GGFW5xjcIu2ytfgs1OJ1vlHfHdE8pDgMpQUdsYERkTBpoJEr+I0ytXrwWQEOF3edIAvJdN7d1zfhwYxBJE6dyVgJQV7qEjE+9EZHflohxX2T59pgd3BYjKndmKiapv4okGjGKGgoCOdUoVRI/k0zerPYAyUuSwfa1z4zk4pqg/QFYVjN8YVEuSiAM2/F4UE0dc0sNQrrrP3c7d74zR8RkJAXfdzh5l5ntC6BlckEUA1z8MAob0rqQQQllxVmqMfM49i4BFAOix4tPTz/GNCWgWJsnDeOaBA1PXUaHzQlmmGyZIaA9oHGSjsW5FrZPg5jUtubzil3k5ZOXMbuZ3SJkvfFPOMe4BWGcQIE9vbG
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+73wY44Qoc4JgWLeOlFDx2MdotZXzfNBpG1vDLXXeAS77wHJ6rAV8Em7MIWp?=
 =?us-ascii?Q?4wS4b5KEJOVr+TqtGtc/EnWLH8bxZwm2ECFoG2HC0eEFiMogpDhqWln19jDu?=
 =?us-ascii?Q?7DCU52FlF8JD56pMvo8wj+j5XW163sn/Rex5gMh02odQ73H4z5OgQEcd1Icn?=
 =?us-ascii?Q?RyysmTxC1JtdfBWtWWq4x9Ll+t60vEOldCa1nbBGo0GESV61Z4t1/Pa3G3JM?=
 =?us-ascii?Q?aZ9V+A7GudImH0WLGD6EJvIkb2YtfuV0TTmQUlpy/TZEqSQxx0yOIK1bOSh0?=
 =?us-ascii?Q?2B/YGdvfdqGg+zU5iSBVNH6y65uAjOhpdbGBpM86ItMjiX9FejVmXs2ZaENk?=
 =?us-ascii?Q?RzkdETbvS1gja0OyRrQde6NjtWt4SHForgSk9LrJfdaEvCj8toDta6c4Y3+1?=
 =?us-ascii?Q?8xagzTKQgVyac69M6OJNLGXa7dVkTHpGaRh429liIsTCuXxFSd4AxfFDIRbX?=
 =?us-ascii?Q?NXnlcZeVevGsSsq+9sPmq+FvC9pLquk9iGfA28GAnMD/UyE1A2tHah+2juKb?=
 =?us-ascii?Q?Jb+Jd38huKeBTYIJU5iiJRpjdiEDMPYkGxuedoUH+ib6xc76qzgoGIrLEeCC?=
 =?us-ascii?Q?3Us8pXXBBDh2eOZXkRKuuiGcgE7liaK06uWaV8Uh3lGQOfQF6sqFi7f/1y7e?=
 =?us-ascii?Q?cTALLew/HFHuEufTjA0X5DitkzNY5EugXM3DGYIhJrl67F9f4w0yy+rzctiJ?=
 =?us-ascii?Q?lsjhR8JOrjp3YAqBlIdj0lu9YgmD0zP8UP4XUwJ8kOZ4P6tV+/SOBvos71Is?=
 =?us-ascii?Q?Coc5BBBtp47OkJZlrTlD3eSn5BGmrUlo1iKY4uPvpBtt+taQfQqHpvGPMVGP?=
 =?us-ascii?Q?ElPpKRnhs659Ua7G06vzhgzfA4ziHq1UIO6/dIgyDuAf4mIglFR/e5vg4Zp1?=
 =?us-ascii?Q?MwmPtfRzaDZlEH3reuXRct0sdxvdREyDmGtprQ8YFA6xeSuvw1GuH+uL+6x7?=
 =?us-ascii?Q?nvgNly33F8TyuzOhQXJHWYBr+u0BLnwTK3drNG2NUf8VIWEmY1t/ZfYWI4GM?=
 =?us-ascii?Q?mQgKEhK8RpH8aQu1bC5PnPDj2cXxlfkbv4H4H8h+Y269AjDIqW4dwmeF9p/0?=
 =?us-ascii?Q?H18ww4F7DhumaM6X6lnDZT3+sGinTM6yBftC7QT0c9opy7MCMjqOTOBjRA85?=
 =?us-ascii?Q?9svMAQXHsL0bJa7vzN1GL38k25Cp9rDCTkRbWgcnJwCpry4uN9SLhXcryuOM?=
 =?us-ascii?Q?X1h+vqDd9hDe5Ib1e6vpd+PN14ksHpSALXVjGLmUNrRnp3/cq1dBMb4dQD8y?=
 =?us-ascii?Q?BYPSUKcM2EC49AWARdg7?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c550b0c-fb1d-492c-ce93-08dbc80efa0a
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 14:58:06.4846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYYP282MB1101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The `perf` util currently has a incomplete implementation for the
following event flags, that events with these flags will be dropped or
be identified as unknown types:

`PERF_CONTEXT_GUEST_KERNEL`
`PERF_CONTEXT_GUEST_USER`

This patch makes `perf script`, `perf timechart` and `perf data`
to correctly identify these flags.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 tools/perf/builtin-timechart.c      | 6 ++++++
 tools/perf/util/data-convert-json.c | 6 ++++++
 tools/perf/util/machine.c           | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 19d4542ea..6a368b6a3 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -536,6 +536,12 @@ static const char *cat_backtrace(union perf_event *event,
 			case PERF_CONTEXT_USER:
 				cpumode = PERF_RECORD_MISC_USER;
 				break;
+			case PERF_CONTEXT_GUEST_KERNEL:
+				cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+				break;
+			case PERF_CONTEXT_GUEST_USER:
+				cpumode = PERF_RECORD_MISC_GUEST_USER;
+				break;
 			default:
 				pr_debug("invalid callchain context: "
 					 "%"PRId64"\n", (s64) ip);
diff --git a/tools/perf/util/data-convert-json.c b/tools/perf/util/data-convert-json.c
index 5bb3c2ba9..62686f78d 100644
--- a/tools/perf/util/data-convert-json.c
+++ b/tools/perf/util/data-convert-json.c
@@ -205,6 +205,12 @@ static int process_sample_event(struct perf_tool *tool,
 				case PERF_CONTEXT_USER:
 					cpumode = PERF_RECORD_MISC_USER;
 					break;
+				case PERF_CONTEXT_GUEST_KERNEL:
+					cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+					break;
+				case PERF_CONTEXT_GUEST_USER:
+					cpumode = PERF_RECORD_MISC_GUEST_USER;
+					break;
 				default:
 					pr_debug("invalid callchain context: %"
 							PRId64 "\n", (s64) ip);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 88f31b3a6..d88458c3b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2346,6 +2346,12 @@ static int add_callchain_ip(struct thread *thread,
 			case PERF_CONTEXT_USER:
 				*cpumode = PERF_RECORD_MISC_USER;
 				break;
+			case PERF_CONTEXT_GUEST_KERNEL:
+				*cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+				break;
+			case PERF_CONTEXT_GUEST_USER:
+				*cpumode = PERF_RECORD_MISC_GUEST_USER;
+				break;
 			default:
 				pr_debug("invalid callchain context: "
 					 "%"PRId64"\n", (s64) ip);
-- 
2.42.0

