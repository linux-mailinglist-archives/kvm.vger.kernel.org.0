Return-Path: <kvm+bounces-4001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B81EE80B9D5
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 09:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD65D1C20951
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 08:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE0F7477;
	Sun, 10 Dec 2023 08:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="czuqyxI+"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2174.outbound.protection.outlook.com [40.92.62.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D7E3;
	Sun, 10 Dec 2023 00:16:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj7clTcRpmfwzuRoAM2B6W3luIjSu7oVWJ08o0LokHbqJWcbKerHEzHo2+uduiaaHohLMg/FFiUoq7u+k1dCAvXFCuaBRJRtlAkEYe2PJpBgA6VVPWK6ilkRk6cIp6pK9b7H02u4WVNQ/UUQo1b1ULotD03+qqRh5NLpTqqr0LdcOvApLk3aMfpzbKeB4nTWmwUDdw9t4400LuygtROOH/tgHCG1zwPCUp7HHW6HKEBnCXe4YaKgEkiUvcd1DI6WecfNZC1Qg7z5+KKsFcFjlOtCq/wYUD9s9ZVzvk0RfH/wKxr1AjD0CV25h3wbnyOpUEUmaZHWGhjkih0/3ghaMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mhds1yoBbjrhkjhv8XPbO4OPO72aaoNMvMxayRbgsR4=;
 b=MRClbKtrKhZpjDdAAOpgwOjwoU8o3wE5WJveyCYqWIpUX1rONUmCyFPvbRTg48/ilYO73ZYqZn1iqLO6+NK57/cEc6HdgHjOBM2im2TVUnuQBW0m5ewtGGkUBURMTNpZKU2xWpEdELGo7sQY4cJyw6JF/DG1I/AkF+2y3Dumg0ihmAH58amWObIYMvSfC1JQeUB6gWBZKLnZJPA66WSwvtLdLT0mSHFE2KuI8fWFq2hNJx6E3adFZdW1WDRFbx001y9LlrYg3iZAqbsysMYOXMwEd2rDI1pLcBm96sbeZeJhyV7/bfe1B8vbhXl8uu2hJ3aZF6o6+7VKINSzRJZZpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mhds1yoBbjrhkjhv8XPbO4OPO72aaoNMvMxayRbgsR4=;
 b=czuqyxI+/jLrCtACYpUdol1ZJojbdl0voVkq3eixcteJ/IE90MsP6luwZCfzcMzdvTlKYVTLbi5tJb+h9aNfrVOFxJnH69DNtENmv6KffJaUTdtGodx0F49pTD4Dzcip3O1KqcGcKmlT5mycXGQMnohF+kTO1Qf1L+EnrwUNk0sh62pgFgjjjSbLWXJ+lr7Nl+J/gy5BSRK7yEOzl9t52m+9lBpceHVArMqZjv1Ic68R2Y+A7mmvQvwd3fS/tnoSjD4f8Fga9Lom5WRg9u8wILwMvi8lg4WBYpPrXsbKSCYTtSAwfKqIF61Rtvi0pE1LjckqfSW8kxu8aSHGSAefmw==
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
 by MEYPR01MB7339.ausprd01.prod.outlook.com (2603:10c6:220:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.31; Sun, 10 Dec
 2023 08:16:38 +0000
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb]) by SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb%5]) with mapi id 15.20.7068.030; Sun, 10 Dec 2023
 08:16:38 +0000
From: Tianyi Liu <i.pear@outlook.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	mark.rutland@arm.com,
	mlevitsk@redhat.com,
	maz@kernel.org,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	namhyung@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v3 5/5] perf tools: Support PERF_CONTEXT_GUEST_* flags
Date: Sun, 10 Dec 2023 16:16:14 +0800
Message-ID:
 <SYBPR01MB68703FCDA8424EC486BB208E9D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [8UVhiSmk+ilYe9quhayyz4kLLAPhV41H68ne61CRE+RkAwuHwNnW+A==]
X-ClientProxiedBy: SG2P153CA0040.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::9)
 To SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
X-Microsoft-Original-Message-ID: <20231210081614.2435-1-i.pear@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB6870:EE_|MEYPR01MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: ea4a1d05-76d7-4776-7e34-08dbf958554b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8KlL61KGK3844bxqcw2mjgws6tBrdbjGDYJLTUij/sCbrkbRQ9yEaxqamA5ScAvluCCmn5N/sVhI7etP8Grtx20mq9nYuREuuIRcf7sQoX35ZkFcaWWTmEmAolzKfhhy9YTa3GIow3x1DrR26RpnEDOhFOMuNMT9ndbUXrdTO1tijtCixldnQ+sEU1TotpzLEfbkByd1J5N5n4yiWMs+LTR0D6uwehA8ypOw9t3SYl8abVWwTxPQkS4YrvIIATv+9isVIdC8MNnxmTY2280yuRPce74WnF9T1W6rPo8+yS5+vNHkEhbetC/Lt8RDf4siTWmeqNdKmPSYoaeuVUIW2x5S4MlENHlbHaRHC6tOLHLGst5kQ86nkYnRruEa/IxMhtVNxPEog3mqZCQWl9afEWTHWlYUXVaDiIJvvTo5SDyIJMmEdHSrMpw9R9ZA+PGiPQVN+gxvxTXjbLm6VZHR++BtBLVp07kbNUeRS1ars6DErcgqyl2y/9SaBJSa3VmT14knUt5Inqj5VSzg5BafYp52mJMIA9vQOCFZAj8EnIbdDW1QwkW5Y2NZ3L/XYz4hUGYPnkkZA7vcVqOWF4SDWoTJShlOFbq/upMwa0P1dF5kFlTg6UvWHSspWoE7MIEv
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KfEbjl6a6Sqms5Et/MeX36Qw/8VPmzfQ/l24QGo9AzUEAYvEhe/XKQFi0HiU?=
 =?us-ascii?Q?uLdJtjjeWxkV9CbU16DjwhY4NJvTyKQ2Q1IwcOMgnwl9RxhfJfrfe7QBHfqz?=
 =?us-ascii?Q?r7CzFR4yPNskOZkcdiwmG7e4eFPyLAZQFBRWDS9B4O92p1u0Lz/x41uUsEce?=
 =?us-ascii?Q?qM+qua2lkIaDuTqiDmFtNn4yIrAN3XOvALwlL7eZcKmnpduQ6N3iicyojbSR?=
 =?us-ascii?Q?dnxTdRAxhSwEzHsBwY5G0xAdiO0shG8zlBhWlGORZ7BkJ+iBjGdW0A5Oa9TR?=
 =?us-ascii?Q?cAgFNYbLtvxoQrqUW2AtuMHoQPLGGMGzp3jWBIBJyA5JFzuSeAEXiEdXAM03?=
 =?us-ascii?Q?n4/OsGGprziqjLFX1Q0Gkj8eunkfQ0AdJn/QhlxpSffJby2verSBwD0bLXtr?=
 =?us-ascii?Q?43ResD7TrvF58c7FFkKeNVyK6zrzy8dxkvRdXLmkqvCtB48FRDLolEXpz5p4?=
 =?us-ascii?Q?NZXBTzxFn8uTmZHDVwQgmY1hL+4lQLazqQar11Uyuhg1GsCg4tXL1bo4w2jb?=
 =?us-ascii?Q?jkLnOV/s4KGbOkBjAo3/UBnNAbrlJBHFjkaaPd/7M5rOsaIfvZtWuclQ7LYq?=
 =?us-ascii?Q?kGw/mWXNsWCRKc4Q7pArjkJPiI9Y1TP5bzOJLpzjbafdFLBs7K7TPYyJ7gId?=
 =?us-ascii?Q?/OJuFp63Ps3K6FZ+AZIsNh1LB5QC+/nbX6nB80qtK2YKdW2l3cNPaVNJ07ay?=
 =?us-ascii?Q?ApbjN69a/hI5LsVWo40l7CMyKLaJ3bUTPmwZC0Z4TwurZrrYqUWWA5RuIFac?=
 =?us-ascii?Q?IglBm0TTopp8zQ4eRlBTKjPAFg07ryA9EOPLOmFiqRUQWbksE6/8Z5XmceA5?=
 =?us-ascii?Q?mvCuW5ITzyP5KTUtRUjUizWqgIa7N5T+fujzcTkannuCKNZ61Bqa7DpewIz4?=
 =?us-ascii?Q?xWCjTelW71QJre1aWOtoDSygZAKj5iwZoB5aPnVkoT5eDojCyC+rNQ6XZT5U?=
 =?us-ascii?Q?5alCoAl/5P+XrA8PSUUeeLVaU4BxPXkeCNFcTUc26/yZ2APDg/QfP8romr/l?=
 =?us-ascii?Q?onN/Zoy1faXmhBL7iD8qSQQDMfBQ4ndz7h1VibyWE6zn+CYsdBv4uyAibKxr?=
 =?us-ascii?Q?/HszVvkGTJc5Zu6eaS8XFojieu6AzEuzDMV6pEyhq3m0zQ9wdPmBRuQGm6QW?=
 =?us-ascii?Q?PTSzhpeIloU0y1PvZhjJJgnOhrLPJN6ldj5cEBxiRkc7HmKWmPnZoQAHa6Lq?=
 =?us-ascii?Q?hotUe9DY2aYNWhHlxUjKUz7vDGFn/3Wl25fqPQiWOUZndr1zJsdvrZZY0uAS?=
 =?us-ascii?Q?9VZqthVg+h498A6Ddnq7?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4a1d05-76d7-4776-7e34-08dbf958554b
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB6870.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 08:16:38.9013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB7339

The `perf` util currently has an incomplete implementation for the
following event flags. Events with these flags will be dropped
or be identified as unknown types:

`PERF_CONTEXT_GUEST_KERNEL`
`PERF_CONTEXT_GUEST_USER`

This patch makes `perf script`, `perf timechart` and `perf data` to
correctly identify these flags.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 tools/perf/builtin-timechart.c      | 6 ++++++
 tools/perf/util/data-convert-json.c | 6 ++++++
 tools/perf/util/machine.c           | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 19d4542ea18a..6a368b6a323e 100644
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
index 5bb3c2ba95ca..62686f78d973 100644
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
index 90c750150b19..28eac11d0f61 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2343,6 +2343,12 @@ static int add_callchain_ip(struct thread *thread,
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
2.34.1


