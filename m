Return-Path: <kvm+bounces-50970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 653B2AEB367
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C963C560FA8
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44577295DBA;
	Fri, 27 Jun 2025 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D2J78yhn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D2J78yhn"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR03CU001.outbound.protection.outlook.com (mail-westeuropeazon11012064.outbound.protection.outlook.com [52.101.71.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24B296140;
	Fri, 27 Jun 2025 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.71.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751017833; cv=fail; b=Uh7JR7jo+F7oHJn0tOm2qwDIotAIA9BqiTyVEH/PAbZ3lAqqdKKa65wnxw9W00rx5x8fI/EsMk8jXAMAwR4Ok2WY3D+RXshJymI/orN/FewUs3STOc7i8UMPTeu029M/idI/YMNHqF2/f2SZkd8h+hVKFkJkqOIWA/Pwq0JkOCE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751017833; c=relaxed/simple;
	bh=3yXQHoPDU7c/3jlJ2fUHXCOoaBIhhFMs37eVNs7MGrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tmnbr5TjnQIP549rFWD+6wN7KLB+eo6+okmO8iTsa+Gj40t3ZwwITh7tNvkr6I9a/ZbXkW1ZqBXM/kXe0SuZCEem5kIG3NHZRus4dfC9WotpTurXxuSwdujNkxolmviFUf9n5h9Bc6bZ3HFynuFQ3fcfMXTFYYduPAj9nMKg08I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D2J78yhn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D2J78yhn; arc=fail smtp.client-ip=52.101.71.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WAGOAcZjCr4qD2v/H0tVsp3iI6JULtubuYmmncF+G5tg35w0Qa7fNuktI11CZYLFKBCROUoZRx+AE2gs65S/8DyuZVpxebDk+thAFbKji7Fsb2KD94GffxmIzYeLMoA6ygU8xp1ZGEH5fozffb5YmuafZ/kkZEsz0bekNlrU38g0qhEsVnUUd19SX8oe899uFEyKMzjLZcX4FdosdasdgglNNxRXwNZS84DbyWyajQrWclisGbXrNSXNZs0wCBebEhoeccgDn9g46lGYj6ZKLbSSULE0oBa+v53dgQ62elrB7xm5UKGThoNCxy3tRhSdUCBn4RUIREQkY8B3zUa+uA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yXQHoPDU7c/3jlJ2fUHXCOoaBIhhFMs37eVNs7MGrs=;
 b=Wmk9/yBXPaPQVmg4Bj6t0rbrHfUDNEMNEoPiX2xjk3EiTIu0hSe9Vq4Ycw0zxW2el/TT0g3Gk5/9hxHquSu35/esW6RNLN35peOaoDwCSriwQyzhFWTZQpNwCJaCBGd+dlnf2o+1YDEtecpgTULk0mmH+Rd51W6pP3C3SOD+AmbDLT5LzFMZhmsJsbQORGS77I3Sj5ZDiCxhWsmJFZFUtbK6n/1JUmVfj9dOt4vTJC1PsaCEbChRX0HuWXnXcMgDlmHs8TzqOYTpbspUYP0YGREZH/Tbscx9At1jWYsCV2nTVdxFCTfWIf08QQbu483S3oUjo8Dd5JXarytNcztcuw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yXQHoPDU7c/3jlJ2fUHXCOoaBIhhFMs37eVNs7MGrs=;
 b=D2J78yhnu5HtpxpzydZ5E36i0h5SM0N7SW61JGWy3n+uGFbmFNlFapjKF3wm4DZdboJJaFcFMmag8kbnP25YGvPgsocU7Nj2I53jBvMbWkZO1zDZP63JocHW6JZ7e6Ubaz2m1LhtY/absRrKcJwVvyDzb1UgswyAsDg5YE63rVs=
Received: from DU7P191CA0021.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::21)
 by VI1PR08MB10074.eurprd08.prod.outlook.com (2603:10a6:800:1be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Fri, 27 Jun
 2025 09:50:18 +0000
Received: from DU2PEPF00028D03.eurprd03.prod.outlook.com
 (2603:10a6:10:54e:cafe::70) by DU7P191CA0021.outlook.office365.com
 (2603:10a6:10:54e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.30 via Frontend Transport; Fri,
 27 Jun 2025 09:50:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D03.mail.protection.outlook.com (10.167.242.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 09:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVvW31xqo39KKYv5n3w91ld3v3Wo8yOKeCpq+nfpNNzGxnp455IUDC3rIxIT+dtmgjIwPkBgSzN7el9L/pMFTvenlbKlqSDj6rWiiKi4NvrsO5+J5ODBr5YfUVt0ckEXaQirdpEku93o1nPOmazOMSaCwZNZJ9hsT3fxcRy7bzzjodu4KyvFxN8sbBEq1FPtId+KubJ1FQQqn4rN0xyjRSjrB9VPRAlrXk37sTBbADYuzUEYy/af1cTZPooI1mZKOeSuIwr5kXcTxTrMxbDEcxQ2chqCqtX/Yy4sqECl3YKVNu/O4/3TaBvnBRSsXYTeqAcmvszCGEC1EwrA5B0LKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yXQHoPDU7c/3jlJ2fUHXCOoaBIhhFMs37eVNs7MGrs=;
 b=adMGlbAwoW5t+HBKsT6wWLKtCB3oBGLCN490YUCd7L/tXWgE1qr9mPRVjaTyBl7On2KboddfNWeL3GPr3S8HqTZw48Bv9ULVAqD70PwEq5tFg2sMYtbcnZgvGPwEJEBOJ53D7Du2ik9ZQVHF+77+aHGuW2ccMBSGGjQK/Fi70eTCmg+CTEH8ojkhppAQzgW9vd2mu5iSqXVq5HaE0nRbAT+IaB1ZfYDp0YC/3Hqp44qcaE6lVXYK2wNvRUK53cdIrqQegQ8ybL73taDwqp0nfJxolGQZlNWfcQibho/V1g7WMbUqWGgDEhaNWxbmFMaJ2bsUdGObyqi21d4WldM/kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yXQHoPDU7c/3jlJ2fUHXCOoaBIhhFMs37eVNs7MGrs=;
 b=D2J78yhnu5HtpxpzydZ5E36i0h5SM0N7SW61JGWy3n+uGFbmFNlFapjKF3wm4DZdboJJaFcFMmag8kbnP25YGvPgsocU7Nj2I53jBvMbWkZO1zDZP63JocHW6JZ7e6Ubaz2m1LhtY/absRrKcJwVvyDzb1UgswyAsDg5YE63rVs=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AM9PR08MB6289.eurprd08.prod.outlook.com (2603:10a6:20b:2d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 27 Jun
 2025 09:49:45 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 09:49:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, Timothy Hayes <Timothy.Hayes@arm.com>, nd <nd@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, "will@kernel.org"
	<will@kernel.org>
Subject: Re: [PATCH 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Topic: [PATCH 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Index: AQHb4f15DzAi2U03S0y45nxFpD/PTbQQ3xOAgAXukYA=
Date: Fri, 27 Jun 2025 09:49:45 +0000
Message-ID: <eff240ca9901d8527774114f6a952777be789dd7.camel@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
	 <20250620160741.3513940-3-sascha.bischoff@arm.com>
	 <aFlvW2FNCyCi3h3Y@lpieralisi>
In-Reply-To: <aFlvW2FNCyCi3h3Y@lpieralisi>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AM9PR08MB6289:EE_|DU2PEPF00028D03:EE_|VI1PR08MB10074:EE_
X-MS-Office365-Filtering-Correlation-Id: 76854857-8586-4089-9096-08ddb56005fa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TzFIWmtnT2dLUHN0NFJTSnZsSEt4eXBSdXlnMk9zc0JXdURRekNzUHZIdUFV?=
 =?utf-8?B?Ri9odzhXL1lEV3FPTzMzd2JkR1kwZ21YQ0JBMGE5N09FZmU1aHJwWURKNVVS?=
 =?utf-8?B?ZWZvOG1ZWmJMRjJNYjhlNnVNSTlWVytZcTZVaVpoY0huNkxoRGJzVEVnbWhp?=
 =?utf-8?B?WlFhS2NZZFJldjM1Q1NtVU5tU1BTYk9nUTczZ2JUb2lSUWFRODloc1JEc2FN?=
 =?utf-8?B?cmpueENDbjFJQlRFS0owNHhGMytyWllrYmJTenM5eEw5eVZxMFg2OWFTMzhT?=
 =?utf-8?B?cDNFMjV5cHMvZk52YitmQ1Fybnl2T1VVMDdydjN5UjVjRlVocVV2VFVFNXA2?=
 =?utf-8?B?NTRsMitGVzdKWHlCRFlSaDRBQXNHUFozTnk2SVRUclZrWEJqTWE4TlIxSUtM?=
 =?utf-8?B?TXhUY1M0MXdnQSt3QWFlYVNQTU5iMU9CUjI3eUFZNVJHNXF5bS9BWDN3OXdn?=
 =?utf-8?B?SWNnZ0MrTzl5TElveXlGaUpqVHBIam1helBEZnc5VUN2V1J1a3ZaODVvemFx?=
 =?utf-8?B?MTl2aXJUMnJOcEdhV21xZDJJbGNQSUkrUEsvRlpPSms2YjNyYXlDRFk2em9H?=
 =?utf-8?B?OEFlZVZGbVNEZlV5MnR6N3FnaE14dURYRzM3ZnlmL2Jib0F0R1ZqemliTjBv?=
 =?utf-8?B?K3dtZ1F4YVd5ajBVd1pCL0Q1aFg5YTBkbVdlY3VmU3VMMmtLdlZQQjZuZEhT?=
 =?utf-8?B?MzhxWkJPamppOUh3M25rQVVXRTlyUmFCSU92UDlQRk5oZ2FFdDZ3bHNuL0hF?=
 =?utf-8?B?WDdWUVFwa3JZVnViVGJ6NWdIR2tXbFZBbVd6aTBITUx2N2VkdU9QaWY5VVUx?=
 =?utf-8?B?WE1tUTQxeS82NlRwOGRwMlZjT3dpbjFjbmdLZ3dmdTR6Q2VlRW9RUHZ5ZTBB?=
 =?utf-8?B?ZGx6RHB0YlFudUdVV0dwRGkyTGM2UG1YaFl6YTJLanVBN09qdGlFeEprMnU1?=
 =?utf-8?B?OU9XaDBLZEhMenBCSSs1OTRQUDcwUmlNR3hoRUk0WU9nSkt0bm1QMm1KenRK?=
 =?utf-8?B?ODBLUUhCTFB4OXlTci94a0JNTGtqS21kQVJBalNxd1pURzJwQVRSSUlMaVU2?=
 =?utf-8?B?WkpYZEQ4cElZWnJLTU1KTit6YVF2TlRWTlIzUHI0eXE1RUd5ZGNiUHZzd3FJ?=
 =?utf-8?B?UUowcktCc2FnTithVnFHQ1hDUndWNDRTcmpEN1p0b1FPUWxVYitIVHNFdW9L?=
 =?utf-8?B?djZ1c0c2QU42alE5SFl6VS9TLzZ1SFZJVVFjRW9LdEQrcExMZ3pyL3NHQWpS?=
 =?utf-8?B?WmVsZnB6MDI2cjRlNWRCMDc1TXZlQU9DY0lIWTdYNmRUWkZJZnNyQXg3OGtD?=
 =?utf-8?B?cEdZN1FhUFhyRzRnd2pzdjFub3BHR0Q3WkVsaktNTjRxS0xKRjNBRnpteSs4?=
 =?utf-8?B?ODZDRVZRMlhmaUZJMVpDVUNJQjVTU2ptTnVxNTdzRTkxVStndVVkL0RldnY0?=
 =?utf-8?B?cUNiREhUOCt6TXdwOWtTM25lM3c1bm1QU0RCOW5ZTVBqaU5MT2lUbitXb1JP?=
 =?utf-8?B?QlVaN2xJdm9ERTNsNkJkdi9hc2M5Z3JvSEVEUXBIWUZoVDRvOUQ2MzdrMTBP?=
 =?utf-8?B?OUhWTVFLL01hTitRbHhkT0tkNDhqN2tJb1BDNnlsSCtPWUEwckJsL3lzZStQ?=
 =?utf-8?B?eW5yM3gveVBRU2Z1SDZkREpLM0Uyb1J0cjVqS1V1dHRjdEZtOUdFQ3pkdStK?=
 =?utf-8?B?bm1TK0NvY3NYc1NrQVpsOCtSQ0MvdjlVZzBrWFkwamNlSXAxRTdmWlRENXNM?=
 =?utf-8?B?TDlzcFpTMTBKOU5tNDJ6VS9zYlR0MjJXQ3lGUnl5a0lCbUxUWXYxUE5QcGpH?=
 =?utf-8?B?aEVDRFQycjY2VU9Ga0ZxdS9JNkY1dVB2cmZkVUFuMjdxeVJQTm1EcjR5Znp0?=
 =?utf-8?B?MklxTGl5dEMzYU5VaGcrODcvUmZkaFlCSlcrVDRjeXRGOENxdXhXbHVrMkNG?=
 =?utf-8?B?NnVXUndDdVdZZzdQd096Yy9wTmtpbExsMG92VCs0clFFU2VhN0pQUmtWVWY4?=
 =?utf-8?B?MUYyNGpESVFBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <334C3C420BA28D41BA94EC31B9686B4D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6289
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cea58c23-6f7f-4857-2215-08ddb55ff2c5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azJKTi82WVMwR0ozRHlWaS9KODQ2NHlaSXdLZ2cwWnlHcjZMUkwxZjhtSFN5?=
 =?utf-8?B?MFN0eDY2ZXg0NUZiVURlUU1WQS9RWTBOR1VjQTA5RVA5eGV0RkVDOFdEWDdD?=
 =?utf-8?B?eGRSQng3ZHFrVFpCRk5ZMHBXSnRPemtJQVdRL0hsbGZUZkR5cWR3bHVhY1FE?=
 =?utf-8?B?QllaSlNYci9INWloVGpuS0xTVTloRUcyZ3FDNWxGU1Z5VXB2YnJrZWt6d1Zv?=
 =?utf-8?B?ekJaZGhkQVhQN1cwSlV6ZVFpSUk4Q1ExbXZPd0hhaUkwUC8remFkRlppYjFZ?=
 =?utf-8?B?VkJMaTEveWFYYmZIWEJ6bUVBTGZrWVRBazJ0VjlTRXltUEo1SmU2c1JucVdw?=
 =?utf-8?B?UUZOSDcyam9QKytIWFhBNUxtOHhkNjJTVHg4emNrUVUvQTlNcEF5a0RPa2lW?=
 =?utf-8?B?UnJwV1Z4T3Jla1hXRUVDamJ2MTdHTFhhL0tBVi9NN1p2UmpGWEsreFp6RW5T?=
 =?utf-8?B?UHFMS1hYdVpTN2RZUUlGQk5kMEJsalNaZHBYeUdvT2hyaWFSL2R4cjRNa0dm?=
 =?utf-8?B?WFFQc09aVCs0YzF0c3NXdG1hNk9XUTk2M2pEY0VnMXQxYTdTZHN0c09KMVph?=
 =?utf-8?B?clp5Tm1OSnJRNnR4YVkrbHBUaEhlVW82UGRYMnl3TXdBQmtuTzNmY0o5WU44?=
 =?utf-8?B?dC9QUG1GNUErUVBiYitTMkxwL1NQR2xVVVBVT29vMUhyS1FHRWxzOSsxaFRv?=
 =?utf-8?B?VWJxWno4T1MvY20wcTVtclc1RzJuZ0xPaUpJRVZRUk5ydk03TmkwNThpV3Uw?=
 =?utf-8?B?RkNObTd0YngrRUd3TTJwV1pLTC9QcHpjMkNBTzVZZGYzcWlSbkhhbEtkcWZR?=
 =?utf-8?B?aW1rNHloN0Nkd0VDYlNvWTlvNGwyekpvTWVseWY1ajkvS2RJR3NtZWkwOHhF?=
 =?utf-8?B?M3RPSTJwaVZSSXE5ZkpxZjBtc1IwaUNCd2FReUFrTUd5Sm9lRFpyWWM0NW9m?=
 =?utf-8?B?SSs3RUNzclhxVURoUnF1bk0yUm9aS3FGYmoxMFRUZlBZajFHWG9GRGU4RSt4?=
 =?utf-8?B?YjhHRzU3a2FVYVFEcEFXd2R5QmlQMHp6TWZoS05kVUVyVzBtSEM0RmNaTnV2?=
 =?utf-8?B?WUxtQzVhMFZOYlo5bGhaYXZyZjhINUk4Y2FmT1BtZ1NxcWZJZEptWHUrdmF2?=
 =?utf-8?B?K2Rpc25Ob2NLTXBwMnMvdmVQOUZHTC9aSE5XWnNzUmJ4OXJCNzVIV0tMRlJv?=
 =?utf-8?B?Q0VRdm9wRnhDZ2pNdFZpRmN0Y0xzUW1TSHZ3anlWdWJXZnpZSWJlNnZPS3o5?=
 =?utf-8?B?VVhyTXZjVDNRdXRSdVlmNWN2bk82TVphUmJnenhOUjZnUlVPV3k0RlNQNFZs?=
 =?utf-8?B?WFRiU3BCOGVONUV1ZG95Uld0WFRCS242VEQ2dU12U1hFWkxNNWhUak5CUUxN?=
 =?utf-8?B?Z2hPNThGVVg5cFhUak9tQWpkSmQ4MGJwQUdwditjOFg5T3VGY0w5WUZVNHd0?=
 =?utf-8?B?Ykk3bUJLSHJDNllZSEFBZ1F3NU56ajdPaVBxcjkxTE9yZG00bzVwZWVJYkgr?=
 =?utf-8?B?SnhqU2MzNHRLZFdVT0ZzaXBxKzdwbjdXdk5CVlVsaXU5NnpIS2JxeTU2TjB2?=
 =?utf-8?B?N1NwMXFPc1MwOVF6UEc3QnE4dVhnUHhGZnZpaWxoUFBNUHdpdnlPeXU0YVJ5?=
 =?utf-8?B?cjJ4RGRUaFB2UXNjOWgvUVFIOGoyQ1BDbzh4SEZOdzFzT3p5aFNubG9kMGNn?=
 =?utf-8?B?c1oxOWF3c3ZLZjRBaEc1MkI3aW5Pa0UrdmtTRVlmdFNCTXUydVEySE5HMFFo?=
 =?utf-8?B?MDRmWE5sWmZyR0pZRHp0NGZsZWt1a2FjanBTK0dzSWtmZElxM0ZyVHVqOVpX?=
 =?utf-8?B?cy9Ob0p3emF3UTN2c3Z6Q2VhaERtNjFZQllTVkYrbURJcXU4MExRcXVXdHNi?=
 =?utf-8?B?ZVNJRzZEQU95czNkdCt0MGtDVjY2anhCcnBkVjhibjZ5bXpNOVV0ZGZLazlP?=
 =?utf-8?B?MUtRa1lSNDVXcmdZUGIzQTFuV21MU05IYmZ0RnhQaHgzV2ErOTgyYTU5YzIv?=
 =?utf-8?B?L0dWZ0N2allhaGNRaHRzemd2cE5tMXc3ZTZOb1ZUaFZON1BaRS85Y3pTUHVL?=
 =?utf-8?Q?0c3PxH?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 09:50:17.7207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76854857-8586-4089-9096-08ddb56005fa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10074

T24gTW9uLCAyMDI1LTA2LTIzIGF0IDE3OjE0ICswMjAwLCBMb3JlbnpvIFBpZXJhbGlzaSB3cm90
ZToNCj4gT24gRnJpLCBKdW4gMjAsIDIwMjUgYXQgMDQ6MDc6NTFQTSArMDAwMCwgU2FzY2hhIEJp
c2Nob2ZmIHdyb3RlOg0KPiA+IMKgDQo+ID4gKyNpZmRlZiBDT05GSUdfS1ZNDQo+ID4gK3N0YXRp
YyBzdHJ1Y3QgZ2ljX2t2bV9pbmZvIGdpY192NV9rdm1faW5mbyBfX2luaXRkYXRhOw0KPiA+ICsN
Cj4gPiArc3RhdGljIGJvb2wgZ2ljdjVfY3B1aWZfaGFzX2djaWVfbGVnYWN5KHZvaWQpDQo+IA0K
PiBfX2luaXQgPw0KDQpEb25lLg0KDQo+ID4gDQo+ID4gK30NCj4gPiArI2Vsc2UNCj4gPiArc3Rh
dGljIHZvaWQgX19pbml0IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25vZGUg
Km5vZGUpDQo+IA0KPiBzdGF0aWMgaW5saW5lDQoNCkRvbmUuDQoNClRoYW5rcywNClNhc2NoYQ0K
DQoNCg==

