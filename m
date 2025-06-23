Return-Path: <kvm+bounces-50347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0536CAE41F5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3916A3AC273
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B422C2512DD;
	Mon, 23 Jun 2025 13:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iebaNJNm";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iebaNJNm"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010032.outbound.protection.outlook.com [52.101.69.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBEE23F295;
	Mon, 23 Jun 2025 13:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684388; cv=fail; b=K2WZedT80mjRrxIkCCEXVolqKgq50rjCEHbNHrR7vJWUxDP5gfXCWcIZ848FMqD/T3dWcG2jDMbXA1Tq/n9Kp8mTY2mslwaz9r0D+LyADCu6IRVAHFd+QwexmidXOAKF1rQcWs03Xc4L18ZgHCeyvsw32oF2FLXJSgsg+KE9OLI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684388; c=relaxed/simple;
	bh=R2jSG4N3q040N5t4pw3RUwoCD47rVY7BpmP0pzbyvgI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SZ0t65yAQ3Sv0PpAdZ2fZOlNZruFd+QyCEYgnRUA46zmU8tC3a0s+6RFEO3B3RFc/CuRtzr3e7V7D/QoaWFFFeUa/LWxz+lD5e40V/ul2EhDfNui6O2XM92ZfQXp8p193Ns3qAKduPMLCIbWM0tN5poU6KAfNcZqC2x+L9Nxiqg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iebaNJNm; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iebaNJNm; arc=fail smtp.client-ip=52.101.69.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FTp45m9Fd+6elEGjd8wfBfU5SfRubp8/dO07BLdHfVN3ZbFgpRpmyV2MR7eetNdLmJ1OnX3+Iv6fHhqfsYT//MS51ZGTh6TGQGAiw/7RrTnUc0nj7KrZC98sdxG/FMuV9OdEGYOd66ipWgpaQWsNXJqATjLEr/18CNOM0nM4Nhq34BALZyWYZOhBaQkEiMSRUbcMT5dzA6aiMAL3kR57YQ4H5Jw/HBFB0ePFEBgybtpWh48n4fVnWtDds+bwhKnnfjYSUzGFlRW14ncFbKoMnnf84vuGGm3HuvPosE6wW9qnqPXGqZGMBzGvTT9Wbp6AgV/Mnv0rEniIdiJDtonyNw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2jSG4N3q040N5t4pw3RUwoCD47rVY7BpmP0pzbyvgI=;
 b=dF7U3dHWj/WmrG3DzAm0sTJJE+pVh8LOE/Tv1O+nzasiQfkcnPy4gmjuhoXjsWvJvhh9HVeOdbN2/5TPAqfvU0/IK39QsA3XRz/0fyNkmFkh7KvJ9Ek/5LM3oxAthu2vXlInUzy0kM8BHUZivwAQV2/O2KJdM/P6m75r/2I1HwOLWxLfDAkJby1mwsydIm4rnWBvfInqyud4yBhCk3qyZIKHGbq56vb65UEwuya5njWQ/tw3xN/2y6jZJCY3KzPHO4fEF6q5jt9LSmENS3wTNFRbZuyLKcYt7ZHz+k67xYVX+vCtPeECfflyFbRvRnwC2+ryg0a4OE4UJ/jcTOaFmQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2jSG4N3q040N5t4pw3RUwoCD47rVY7BpmP0pzbyvgI=;
 b=iebaNJNmbIqMlfxTLdKWwbVHADa29cx8BDLjH9/HTeBaMQsLQwiEzPc3BX3m+eMa2m8vHm4H+qy+fUTMD2Atlzs0S5Yy92R6j0o0v5HM4OAYJNLznXCWoDjfXBFyQCXSmbUrKFJ42ds6gK8p+uEnQ9j5yc1+TpPbbeJLVT13rA0=
Received: from DB7PR02CA0017.eurprd02.prod.outlook.com (2603:10a6:10:52::30)
 by DB3PR08MB9036.eurprd08.prod.outlook.com (2603:10a6:10:435::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Mon, 23 Jun
 2025 13:13:03 +0000
Received: from DU2PEPF0001E9C5.eurprd03.prod.outlook.com
 (2603:10a6:10:52:cafe::2b) by DB7PR02CA0017.outlook.office365.com
 (2603:10a6:10:52::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.29 via Frontend Transport; Mon,
 23 Jun 2025 13:13:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C5.mail.protection.outlook.com (10.167.8.74) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21 via
 Frontend Transport; Mon, 23 Jun 2025 13:13:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rKT5PavDVqYwHqJ40f96nthQfWlxSjXALw8whyI6t4safsAX8IiNIYWKw2LHfVLCzIpx1wkxCotlAwq+mXYpO8XjfOadfjuXJBZnlntoQOHoOu+3C3q463kvDN3arwiQp5Ld73I/v+OJXXSV4CVlbPjWmbyVsZY6+6z4OmZcujKvHYXewKI89ScE7FjpiUNJHGeoohNomdEcFs/Em9hV6KM2v8Bq0G/kuU1FWV52OjshqdC0FLH4Hs5AQykrTEB0frnKdVaaJlhrLAIqSfYWXy8ndhMn3pDgiQVsZ6RdhjTEq3B74ruAj2ZCxYbRiOoTHutkd81roqNE8tNra/EeYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2jSG4N3q040N5t4pw3RUwoCD47rVY7BpmP0pzbyvgI=;
 b=i041xwh+4NjpNQ6AT+a00gWSlGkP4xW4u1bxHuPgB1ZfRZg9nBYTxiPEDjrjuOso02MHr16anbU47l6MmrrdpM6EVwlGqUS+/8w1UC3aNtcKC0SNhEhbvJ0YJz7FzaA0saEOl06fFKss2/Qfikhvg2JJ8y7hhePH+Qywi6+lw2T3V+bVovsC1sQcsCS9wap3ql5AS29+Fc7a+0iQQ7myBlH46CTblRzriAfRKZVZgf7O09Uj8YrZHzRH6hcFkI+66xI+QGLEciqJVGEAfCA4EzIXZR4CR9FP4LPxK89UJhxx+XskGDVodcqTHi9e72JVrd6Z3BPTyW3dZFxeVquiAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2jSG4N3q040N5t4pw3RUwoCD47rVY7BpmP0pzbyvgI=;
 b=iebaNJNmbIqMlfxTLdKWwbVHADa29cx8BDLjH9/HTeBaMQsLQwiEzPc3BX3m+eMa2m8vHm4H+qy+fUTMD2Atlzs0S5Yy92R6j0o0v5HM4OAYJNLznXCWoDjfXBFyQCXSmbUrKFJ42ds6gK8p+uEnQ9j5yc1+TpPbbeJLVT13rA0=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS8PR08MB6200.eurprd08.prod.outlook.com (2603:10a6:20b:292::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 23 Jun
 2025 13:12:31 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 13:12:31 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH 5/5] KVM: arm64: gic-v5: Probe for GICv5
Thread-Topic: [PATCH 5/5] KVM: arm64: gic-v5: Probe for GICv5
Thread-Index: AQHb4f15UlqrD7JLkk2rg+S3NQZyF7QMftWAgAQ+IgA=
Date: Mon, 23 Jun 2025 13:12:31 +0000
Message-ID: <f38fd2d51242f8b2e81da774426c5cec28e23fde.camel@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
	 <20250620160741.3513940-6-sascha.bischoff@arm.com>
	 <aFXDobZ2GXPC4wOJ@linux.dev>
In-Reply-To: <aFXDobZ2GXPC4wOJ@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS8PR08MB6200:EE_|DU2PEPF0001E9C5:EE_|DB3PR08MB9036:EE_
X-MS-Office365-Filtering-Correlation-Id: 39eef2b8-e18d-427c-292c-08ddb257af8c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?U2V6Z1FKdk43YjlUWGFXK3NPOTJhTExoNEZFYWZkNm00enhvV2IxUHNjN1hq?=
 =?utf-8?B?TjVEWXdDaWhEQzNDQk5HVmc5NE5SUWJMTmlWZCtFNjd6SkhzWkliUmFZZFht?=
 =?utf-8?B?NUhlWUVHb25FVXhISzNMWThuVGZpVmxyUS9YVnYzZ3JQazlGNEJHLzl1MndW?=
 =?utf-8?B?LzZzWDYwK2hwS1Q5cUMxQ1c5NW04bk8yYVkzN1ZkdUIwZnVUd3p5YW4xc3pq?=
 =?utf-8?B?L0JEQjZrRGFFNElOV3ZlVTdhTXdmcFQ1cjNYMVVyeGg4NEpYOXU1N0hHazVh?=
 =?utf-8?B?Qm9yUjY4d2ZnbUdPdC95TTE2dk5kSzBGOFozZ1hKVCtRYWxjZ1VPZ2ErVFBV?=
 =?utf-8?B?MU5kNlJ2SVV3ZlhmYzU5WlBSV2xWK0VqYnQ0YXlKcGVKNXo4K3lzeXRzaHF4?=
 =?utf-8?B?eWFBc0xzOTByMnRrRFFMYkxGUFkzcjJBUzNKWllhajB2UUdzdXVBT1kwL3c3?=
 =?utf-8?B?QjMzNGY4VGZpWUlucTJUamxVSjZ0UVhLYml6RjFWU0hSVkRyZlVDVlJ0eHVh?=
 =?utf-8?B?VEdFRWxYK2VUSjM3WXRxTWxRcWpCTzlCN3UvdDU1VDM1L3kvQ29NWVB3enhX?=
 =?utf-8?B?VlpUWFFXUFRmWFJZU1JObmpyMG1GQ3U3d0hzVHozUFpkdG0vVDlUSHB1S3RH?=
 =?utf-8?B?ZWsvN0o4UGtyVk1mbUlGOHBxeUVjK3pMcVZlZU8rcU04dzQ2NEZBanp4RUJU?=
 =?utf-8?B?WWowN1Z4UWNEalFDRys3QldldE5LY2RxTE1IMVNIeGJ2T2txU2VyRzZmSlN0?=
 =?utf-8?B?eE13RTU0K29mY2JiQWZwV2lXT2dVUHIwUnF1ZjR0eDNZOEprL21TZUEwZXll?=
 =?utf-8?B?aHYvZWdaOWdBNVFCM1VMSVhHbTRCU3VGYXpCVnFlanpRTThYbUMyREZmMXU4?=
 =?utf-8?B?amxsRUdVS1pOZEFrMHZXTnlJTkVCQnp4K1NXbHVkWFRZbWNscWZrZWJDeTNz?=
 =?utf-8?B?VzRGMmtNOU53U3Vyd0xyVTNJdE5MV0JFMEh6N2pTalhhaDRwS2tEci81OTBj?=
 =?utf-8?B?WTh0QmNIUmFkSWpSeHhzUS8rVVVGWFM2M1BpeGZOQTBBUkpjcEpqazlkYWls?=
 =?utf-8?B?ZFUxRnlKdzVSOVhIYXZ2Q3dQTWhEYjZIRW43c213WGJoZkhxZHRNbThVUFZl?=
 =?utf-8?B?QjhzWk0zelBiMkNoZlM5SEkzS2h5N0xPL2VQb3Y4bFBCUUIzQ0REU1NQVG90?=
 =?utf-8?B?NEtsdDM0bmZzNC95SGZjVDZHcHZHdXVwYld0NGhVdnFGUW9pU00rY09lVng3?=
 =?utf-8?B?VGZ2RHFjVEE5Rnl2SUY3RTJxdEpqeVpTWS9pZ2hZNjlzM2ptS3lvb0xZNDlk?=
 =?utf-8?B?TXJDVUtkbzh1b1M3dThIL2V1Z0JnY1E4UVIra21TZGxnM2EyTmtQWWZOVE40?=
 =?utf-8?B?aVdwUk9TWldRclBydTZDejNQdk5PU3h6RG9lTEsvWUpYYzNkNUNBUkxnVVZL?=
 =?utf-8?B?ZGF0U3EzUU11aHhSVS96elZ2cEpjOWFMbDBLRFdYZ1ZNL0RPWnBpVTVqUVBC?=
 =?utf-8?B?dHNBRjBndGUyYjl5RGxLOWRaYkxKZ0RGdk02MVJuWU5tdktVQThHUDNlZDVn?=
 =?utf-8?B?VGNENHVYWUVvNnpuZjJRaUN4b2RUQ0UvY0dYK2VlaExhRUF1YmNwMmtxSDJa?=
 =?utf-8?B?T3pONEJ1T2RWY3gyenZEVkVneTYvVWRzZlBISlFnZ21MQlhDTW9aejFmYVhs?=
 =?utf-8?B?OGRZSmcyZWtSUUJhZitRdllzaUU3RmU5NUhmSUhsT3h6Q25JRDB1T0thOFB1?=
 =?utf-8?B?cWdmYXJuTVpmNnRsZjBUdXZndjA2WktMNlR1YlRpYjB3ZTc4ekpmZXZOSnVj?=
 =?utf-8?B?U2Y3MWE4dFB2TkpRUFMxUUhlcHRJVmd6WUQyMXN3YjdMR1ZvRVhmdmFJNG1j?=
 =?utf-8?B?UjFrN0dIR25HaFBpUmpIRWx0eGNtZWV5MEFSTUhlbGJERHlFWHBPODVNRW92?=
 =?utf-8?B?MjhIYkNHdlF3TittM3ZmQmZZRmE1MzEzcmpRTTlZZGk3RDY2M2ZPUDJYWng5?=
 =?utf-8?B?N1A3VUxlVWlBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A86C8C098AFFFC4AB1AF43CE8F7E1325@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6200
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2a66a2d3-f412-4c7d-e38a-08ddb2579c69
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|14060799003|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZituRUFDL0RkdlI5RTdwdmRwT2pBT3hMNkJ0UkhqQ1RHYThSVTI2ZmRVKzgz?=
 =?utf-8?B?c0tWZTRyWnNsSStESVJxUk5GV2ZLQ0NST21ZRkZJVmFpN3NzTk1BdkpqZVNF?=
 =?utf-8?B?TWdLZEtYR2xwOWg3SUdBbkdYZVFkSkE0ZHlXeXB0WFluTWRURXJ3anBjdmVw?=
 =?utf-8?B?NXZhWTlkdzBFeU01SDNMSkhESEtsYXkzeFovUlFhSXNXWllYek1ySFZVaXBM?=
 =?utf-8?B?RmsvRzVPMWROQm5nWnE1WjFDdVpQRUE5c2FZOThiRVpMRlRSNEFDV0dCTnQw?=
 =?utf-8?B?Q1RRK2hjUnM4bzFoWktIcWRPZkFGWTNWRlBzWlNwTHpoandJbVpIRlNzMm8w?=
 =?utf-8?B?R2F3TVB1dXNuSUNQMG5GU2FtTDlOai9pWmpqNGlWdmxib3hIODlLR3RKUHM3?=
 =?utf-8?B?VWczUkMxZDVVVUN5eTZqTnFnaWt4blJjQ1FmT0R5Q3dZUTFDVmJEMng1TDA5?=
 =?utf-8?B?MmVOaWExaURYQ2E1MWtKbENDTlpibHMranlHa29SL3Urd1E1bVZ6STlrUHY3?=
 =?utf-8?B?QjdPZHNtbXN0WG5kaUhodFVCTG1PVzdRaUVwODNGVXZhYWtKUDNJQkJITHpZ?=
 =?utf-8?B?djlUS0xvQnZhQTY1N25jR3VWSlZQcFYyWlI5SWxzcHJ4RUxmTUhVMFBOWUcz?=
 =?utf-8?B?SEcrZ1lzcWdLS2QySTNoRDd5dlEva3dZNk1OWnMrbjFDaSsySTBBeENhRnh4?=
 =?utf-8?B?ckgwa1kwY3VTcFBveWp2U0o1KzJyb2FVU1crbXRyc3BtS2p6OE9kSVljQWhR?=
 =?utf-8?B?NzBOckM0K1dsTGdXYlFTYTdtWlZYQTJ4Z0k1U2VwcUpsKzNMSWdPN1pkQy9u?=
 =?utf-8?B?MXFuUUZsY0ljdWp3S2tsdGw1bWtBdVBKdFB3Yk5wOGJNOGlSM3h1cGxkQ082?=
 =?utf-8?B?MkxiQklOaTRhaHNHd244N0tlK2wzSzE0NFlibEVDdlB0WExrKzZ1cHNtbVIx?=
 =?utf-8?B?dG5uNnM3eVE3M3MzU3oxU0dXRGVhQ3pibldiVjZCd2hBeEZrb2VyWWg4dXY2?=
 =?utf-8?B?Q2Y3Y3Rrd3pyY3BEWlFhRkpkUGF6L3JxNFVxSVdheXpndWxKY0h3eW5Pbngz?=
 =?utf-8?B?Rmd0V1RnVDFVMVlnSXU3di9rcy9tVkRwa2VRSk9Nb2RoSXpYdXJzc2U1ZTIw?=
 =?utf-8?B?TWxiSE5BVWhHYzEza2ZzWk05VElkbk81QVNzRXlzR1QvY25qMHZzNUxZMFNj?=
 =?utf-8?B?eWJKSlBsN1JWdlJJSnJPUGwva0pSdTRMV1MzaTFuV2dFdDhpbEhVc0JXaXVy?=
 =?utf-8?B?SGozWWNwZXUzZS9SNDBpNzFYRWtrNElTbFBWOTY0UjZRWmo3dWJaT3lUZGRK?=
 =?utf-8?B?TEJyNVNHcTVDOC9hZUJPQ2Y4Mmk2NWs0WE1lV1Z1bDBlcmtpVUU4NEtRL0Vs?=
 =?utf-8?B?MWRQZld4RFg5dHhZQ3ZOMzhhdEdsMTBpU0FjK3luUVRQZjRnMDJMVXV4ZENK?=
 =?utf-8?B?RnRqZjEwbnRZQmIrYnc5cVV2QnFEV05qTitvQTY1dUkvbE5MaEViMWpqV2d4?=
 =?utf-8?B?SzMwQnZTTVNlZ1IwbWNadUIvRUFGQXRsZ3o2RFAzZkhlLzErQUpXWFZzUXRo?=
 =?utf-8?B?eDBRV2s2cU9tTEZMcDhOdU5iOFUrSktHTHRBZWZ3UEdpRWs4bTM3aVduQW82?=
 =?utf-8?B?aFBQQ1h4ZVJnYWM3UjExMXBoSUJUTlY0VFh6QWU1UHhveXRQdmRyV3M0N3hm?=
 =?utf-8?B?ZjUwUnJ5cmU5MVNmWTZLVUo1U3NKMW1HWGdGRC9RbWRtSmt6ejI2SHF5SmNK?=
 =?utf-8?B?OG8zUll3Um40KzNUV0NLbmJya1B0QUZNSFhnZ21vWm1YWTZnUjBnMnpIdlJt?=
 =?utf-8?B?a3hKWlRhOFlNbmZnWmFVQ1RtNjU0U3ZkUG5EWmh0N3RVb0tYKzMrRzhrT2JG?=
 =?utf-8?B?dWR1Z2hHbHRRbkVja1BLTDJXblJ1SjJHRzBIYXlPYjExRllkTmhkZ0Z2dnJn?=
 =?utf-8?B?Vk14ZUNpT1pRYVlrOWUzVmVFSUNqRVpqaEw5VEJReVZjbFhnekFPMDJZSkxO?=
 =?utf-8?B?dUh4U0F0ME9QZ0xISzEydWJ2OUUwaHQyZkl5MlFkemQvMldOV0ZUSW9GSGFU?=
 =?utf-8?Q?C3unvH?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(14060799003)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 13:13:03.2394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39eef2b8-e18d-427c-292c-08ddb257af8c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9036

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDEzOjI1IC0wNzAwLCBPbGl2ZXIgVXB0b24gd3JvdGU6DQo+
IE9uIEZyaSwgSnVuIDIwLCAyMDI1IGF0IDA0OjA3OjUyUE0gKzAwMDAsIFNhc2NoYSBCaXNjaG9m
ZiB3cm90ZToNCj4gPiArLyoqDQo+ID4gKyAqIHZnaWNfdjVfcHJvYmUgLSBwcm9iZSBmb3IgYSBW
R0lDdjUgY29tcGF0aWJsZSBpbnRlcnJ1cHQNCj4gPiBjb250cm9sbGVyDQo+ID4gKyAqIEBpbmZv
Oglwb2ludGVyIHRvIHRoZSBHSUMgZGVzY3JpcHRpb24NCj4gPiArICoNCj4gPiArICogUmV0dXJu
cyAwIGlmIHRoZSBWR0lDdjUgaGFzIGJlZW4gcHJvYmVkIHN1Y2Nlc3NmdWxseSwgcmV0dXJucw0K
PiA+IGFuIGVycm9yIGNvZGUNCj4gPiArICogb3RoZXJ3aXNlLg0KPiA+ICsgKi8NCj4gDQo+IG5p
dDogYXZvaWQga2VybmVsZG9jIHN0eWxlDQo+IA0KPiBUaGlzIGFjdHVhbGx5IGdlbmVyYXRlcyBk
b2N1bWVudGF0aW9uIGFzIHdlbGwgYXMgYnVpbGQgd2FybmluZ3Mgd2hlbg0KPiB3ZQ0KPiBzY3Jl
dyB1cCB0aGUgZm9ybWF0LiBJJ2Qgb25seSBkbyB0aGlzIHNvcnQgb2YgdGhpbmcgZm9yIHN1ZmZp
Y2llbnRseQ0KPiBwdWJsaWMgZnVuY3Rpb25zLg0KPiANCj4gVGhhbmtzLA0KPiBPbGl2ZXINCg0K
RG9uZS4gSGF2ZSBtYWRlIHRoaXMgaW50byBhIG5vbi1rZXJuZWwtZG9jIGNvbW1lbnQuDQoNCkZX
SVcsIHRoaXMgd2FzIG1pbWlja2luZyB3aGF0IGlzIGRvbmUgZm9yIHZnaWNfdjNfcHJvYmUuDQoN
Cg0KVGhhbmtzLA0KU2FzY2hhDQo+IA0K

