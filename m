Return-Path: <kvm+bounces-59695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E32CBC85CA
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 11:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40A3119E25EE
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 09:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D152D8764;
	Thu,  9 Oct 2025 09:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aqibmZmB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aqibmZmB"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB4C2D7D2F;
	Thu,  9 Oct 2025 09:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760003359; cv=fail; b=MGT13MZ0e7wZwGydhPxl+nINm6HqqXfVTYKOo6a0WDNLqFzXLi8C4tx7SkjDCT0bOpODCwpizMjcwTZSBDo4AhN6HHh2KY2XOo7dNTMZliNv14XsHFiT6MVEsOBfqKWjLhRCfKBdSIqoGaEs08CzL0UtkNFdxt3i/ykze0ADoW8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760003359; c=relaxed/simple;
	bh=aLswIq9Snii8DOsi1C1G4zu1hUKW2xBMs65gq3zj1XI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HmxCBcyioSOePMrZ32Eys8RAWHtpRBNWOwA+6/PzniVS3QXyJX7GTfkYGcMzwMQGmw7+9Hw8A0dsXywSUCppGWafUQNBKHvFR5ypDVTtMYXAisGuYVGKoM1zsmSM+oM7V7HXtB1fFP+h74NNXxAt1a6wlsFznw8dceh2n+tVUwI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aqibmZmB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aqibmZmB; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=T0S25FdqjzvGC0/W6TQswPoIB8/aMO7H/96obeR0A7tXnwpcCahWtKf+MMb9uRQpBs4feZGgynTRQ6Zw2XeyVEWJhlM+4LwOMmV5LOlcmf4lhNuZWaqgmZhVjfghuKVTl5YUY5GlSs/G65gUn0+dxPLjAmNWw1ZGWBnqwgsy4nNS2VJEcht1MiDUlOMxgCarEQkQuRpKiMli2Rlg2zuGaIT5uGtonUFmj7g9ZYQTQYxerz/ealUdFVDvmuayP6tS0IfsSnBEF8LXYEROL9er+4B4YLuYxJgStJm3xSIt4V2BVinOmO9fUoyTruPwCdOkYk5wYh+d1o9utACPLKsx3A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLswIq9Snii8DOsi1C1G4zu1hUKW2xBMs65gq3zj1XI=;
 b=bR52ZmIMCl6wcJ+MthBkC5hAR8I+ZEt8rMqa1bT+oAO17Yr5PmvaJazDCuexexuQHbkh0x/fCrEegyefN2Fps1F7Rg93hRkoDvpsot7+8tzengeHDo6Wy8Obm0j7S7hb08EqK8FXCoXgvBDAKJh4E2lfgDcYmrLWslcNcEFVwIior8SAItBUVsKexeD9A20ybgDtZU7pQuBKbDRUFigGI3lqh72Lp0/3rcYjZTt9WylqZJwqNk1QF/A+oLn/HjC7ywtbttkv0FEsbXtOcB7sIi1iFXdqBA2cnfg9YS/bTZLJrRcOHWDLuhK5bz9NR7egsNHV9omnbXHI4fP2Exja3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLswIq9Snii8DOsi1C1G4zu1hUKW2xBMs65gq3zj1XI=;
 b=aqibmZmBwOpXazahKXwYpHt6c1qk3cQUAzHWn9rYWk8rOntt/QtGl7pyvfi5kKeGn9BLQePl1drJZxbBURMquOK37A5xlddubRVqu6YGC3rE8NQvHw6gh4KGXZWat8cC1bL7J0DeiTDnCikfM+owKdWHsxYinH5rShf/c08d0hc=
Received: from AM0PR10CA0004.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::14)
 by DU4PR08MB11151.eurprd08.prod.outlook.com (2603:10a6:10:574::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 09:49:11 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:208:17c:cafe::33) by AM0PR10CA0004.outlook.office365.com
 (2603:10a6:208:17c::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Thu,
 9 Oct 2025 09:49:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Thu, 9 Oct 2025 09:49:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqBq5YeXX2UgTRVMIss2fKt73tsx4YZA9aob0Y6C8Dlv4sI86j+JvNSFxp2b9M3GktPPzgEe0OMomQr/XVYYbtNHr/AEET70EI7B5ATN3NjdymO166V9uiSdabElkmmJjWKCbIQ50L5n6gyiTBc42JTWeZ4PZX23MWlg8HHSuqVmEyn6CxTyUtf90iuJQqo4ltwxWZvZ6OPcAiUt+hD9Yy6WXoPFtTT7L7qJt24QcfauKdnB1x9gfind9dkGHZ6C1Z9/GvslPw/AnOh7QYPaZDYutqhPBHlGLgY89YUJmRJD1FAUHZOMakfWyz+D1go3mOSDMkG6/IkB5JlJAa9k3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLswIq9Snii8DOsi1C1G4zu1hUKW2xBMs65gq3zj1XI=;
 b=M+pc30jiV2dLvS2VhbbzE4e4aTIQ6AoiADRkWY5VwQVpXacVdaLSNQHAnbBtkFzW8jHdmhmcutRKnG4qU9m4q7dR07cQtFcv6TXZx7+IBHrVU3sSxmRLUVYQWQXvSJpM5QdlhjHdPdoHvkPLm6UYpNRhgGhwhh/viRmm6qWArHK2+0lrKOU5l74RVf68IgwhZfzwO6zVo1mJ47Zb778cgPRFpx2jxxyN3LO0FR6z6Gyu7hcoMdw8eQufnixul5LwSgC6Mh3KrgTRSeVBue5GYY7qoLFodC8ORc3z7nI8ond+kGaoNrAu9WWSHbY8fHmwSIlT5F8SZKHmJTlbYcXCLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLswIq9Snii8DOsi1C1G4zu1hUKW2xBMs65gq3zj1XI=;
 b=aqibmZmBwOpXazahKXwYpHt6c1qk3cQUAzHWn9rYWk8rOntt/QtGl7pyvfi5kKeGn9BLQePl1drJZxbBURMquOK37A5xlddubRVqu6YGC3rE8NQvHw6gh4KGXZWat8cC1bL7J0DeiTDnCikfM+owKdWHsxYinH5rShf/c08d0hc=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by AS8PR08MB8062.eurprd08.prod.outlook.com (2603:10a6:20b:54b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 09:48:37 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 09:48:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "broonie@kernel.org" <broonie@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH 1/3] arm64/sysreg: Support feature-specific fields with
 'Feat' descriptor
Thread-Topic: [PATCH 1/3] arm64/sysreg: Support feature-specific fields with
 'Feat' descriptor
Thread-Index: AQHcN5/5lSWDfFM9m0quOC/kafkic7S2338AgAK1A4A=
Date: Thu, 9 Oct 2025 09:48:36 +0000
Message-ID: <0a3a60082d13b27388a0893abce8be47b045c107.camel@arm.com>
References: <20251007153505.1606208-1-sascha.bischoff@arm.com>
	 <20251007153505.1606208-2-sascha.bischoff@arm.com>
	 <26d69b0d-3529-454f-9385-99a914bf1ebc@sirena.org.uk>
In-Reply-To: <26d69b0d-3529-454f-9385-99a914bf1ebc@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|AS8PR08MB8062:EE_|AMS0EPF00000197:EE_|DU4PR08MB11151:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b27a69-6001-41f2-7e04-08de0719187c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?b2Q4MjJFN1QrOXlrb3lOWG4rdTBnd2hacVdpc0FpNXJoOUlwZWtkZXZNTnZH?=
 =?utf-8?B?SXN1THh2emZNL0hUZG5sSmEvczlFK2IwcGEydkNzMWhXdlFtTXdiU1lOYXRO?=
 =?utf-8?B?MmNoRXVkSDBPYXdMS3c2L3Y4T3FVcFV5V1ltK2tLNmVuR0tGaXpLc2lrTTM4?=
 =?utf-8?B?VlVNVW02YjN0UmZEY3hmWjV3R3lNVFJkcXQ3bmxtWElidGJJbmdqeU1EaHZ1?=
 =?utf-8?B?RDlGR3FMYzkxS3RsNE96NzdkNi9iZGwrMjFIbGhJbm9vMXlZSXVjNmZhL0ZZ?=
 =?utf-8?B?L0dVNkR5bGdWVjVxUUEzOUplRU5LMXhCZVVlNEtFbmpyeTdDNzg0RXJXVUZj?=
 =?utf-8?B?ZzhjREY2dzROTzFvLzVTY25rZjlKQkFIbWE1V0R6TzAzcnFDM1B6NFM2UVhi?=
 =?utf-8?B?UWxOWlY0UHNmbEd6b2FYTmRmbUkwL1diaFpLdGVxQ3BpZkNtOCtWQnZxKzlx?=
 =?utf-8?B?TEtEaVgzNTdRVnRLdUcyYm16b2Y2TkVIWTY5bk1xNWJwRUR0STdHL3lFdUFD?=
 =?utf-8?B?SlFYUkQ5VmFhVi9kelFtTmJma2dHMHU3emVHU0tIeGo1T3A3WTRiTXdYUXZG?=
 =?utf-8?B?ZUFHUWJaN3ZwSjQ3ZlRQOVhrMmNRbkY4OXBWZmMvemoweW0rOFdYalhDNVR3?=
 =?utf-8?B?Qks2VERJWkR1amxuY2ZhMnZmRi9kak9WZTBtVzZVVFRObXFZMkpqQ0kwTTUy?=
 =?utf-8?B?V29LMVhITDFaWXFaYmlhWFVmOFBkZ2hOVlNMajhzZElzQWdIT01qd21vM2Q3?=
 =?utf-8?B?akErMnZCdlBKWWdpYUJnNUgrMTJnbnVHdjFMQ2lWTEhYbkxtanZENERCRlgy?=
 =?utf-8?B?aEhUSTh6aWtjTXlaYzI0d1A3c3Y3SFU5WkRBa0xyTUNSUVRKWW0xMVc3aDJK?=
 =?utf-8?B?WWtMVXVlRE91MTJmajhrWXg2Vm9ZSXhUN2lRVkZ5dmV3RzA0N0ZzRUx0ZnQz?=
 =?utf-8?B?VWVzRFRSRTRqWE95ditkZ05QeFNRZHczSFR2ZHd3MGZ1RTByb0FXeW9rc1lQ?=
 =?utf-8?B?QzdLNitOZHljSks5K1Q5Qm1FNWtubnRySXFzTlpobnBSK1dXcjVFa0tiWGtw?=
 =?utf-8?B?d3VYcmMxZjJueldvcXFyVlNNNWdJVHdBOXdpM0lsRmI2MVNnVW9yaVh5ZzVw?=
 =?utf-8?B?QklRTkVmZWxSZS9leWR4TURSbnd5ZmxtbDVpcHJXUGI4VFB2clJpTGxzdGF0?=
 =?utf-8?B?SXFXVnJYMzQ5MUZSS1QxN001YmpDU0QveDYwemd1YUo3ekdkYXZpNGRiNkx5?=
 =?utf-8?B?dldNNHFTK2M0Rms3NkN5azZNRXZCaThyNUM5aEwrMDdvaktmaUQ4ZW5xRDlk?=
 =?utf-8?B?anZqV3dRbW9TMzJEZCtiN2FoK21hZVZzWFN1NGsyZ2ZxSFBvei83YjIzNzk4?=
 =?utf-8?B?TGlyZTR1N2JJa3dTeDZrcWV1WnlzNmdSRXVFQzZWd2RqUmppZHYxWEgzVWhB?=
 =?utf-8?B?djF5RVlzUTZIQkxmRlNubHFSNEY2bVJiLzZUckpCbjBjUFVCOHpaVVJMQlVO?=
 =?utf-8?B?Zkp3S28yM25FcWRDcFNDK0ZCTGdQaklTNGErMi9uZDVENW15MmJNMC80em81?=
 =?utf-8?B?TXBGT3FlbTE1anBvNWRiMHBYT08xaVkvMUtnY2JLL3hXMFkzeGFsWjhOT1N6?=
 =?utf-8?B?S1hFRXk0bFV5QytaMHU4YlYxU3FzZjJ6endORmNORi9lYTY5dVppTHgyLytS?=
 =?utf-8?B?Q21NQk5TcEFYNDdPL2NiclMxVnM5QW1idytrOE9pQmFCRlVySyticnZiWHZl?=
 =?utf-8?B?aFV4Z1d2S0hsQTY5LzBBZ3ErOUh6K3N1b1gwaW5FWTRUT09hZEducVVOaEx1?=
 =?utf-8?B?SE14VXF6LzFMQ0ttRW1TZS9IZUNGYWlpZUQ1Q3RtUDV3b1h3T2grTGJSR1l4?=
 =?utf-8?B?ZndockFtVnN0VnZMMjNoa0kyRkJzcjNINEhxaWMxb1BLV043YTJCZ2toRFl0?=
 =?utf-8?B?R2RqN0tHMm1nVUZwbTdPNVIvY1Q3RzN5TkhTTGxLRUUxU3IzOTVBaHRacmJv?=
 =?utf-8?B?V3hDNStYQkRvU1AyRk81bXdnS3hIMHZQaEQrb0ZqeU8vUm5jcDA4V0J5b2pD?=
 =?utf-8?Q?SxUoSX?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <847608F04746ED48BDBEED42A7834970@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8062
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3dce1c1b-28a7-4aec-f12b-08de071904dc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|36860700013|14060799003|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aSt5V3p6TFIwbE9TUk1KVkNVMGJzMjBYOXdZR0hFd2d6RW9vNGJ1NEVuMzMx?=
 =?utf-8?B?MWd4blZiU1Q3L0ppT21pRDhQOUVEQWwyQUJ5Sm13djdEQi9QcjlPQVhqUHQw?=
 =?utf-8?B?TGJYRHE4NXJCc2ZXQjZYUitlMGpmRmxXbCt5LzRmcDFLSWJKQ2xOc1A2SSs0?=
 =?utf-8?B?WXI4MDgrK0VVTmRVOW93eDhjRUx2QkZNSkIweC9YQnJDTmVteS9NWTlzMzRH?=
 =?utf-8?B?aDZTVzFIdHJMTHFKeXBaQ2FDZk5nWWpMQzJaUmdUam9OSE9ZMGJVTDhjY25n?=
 =?utf-8?B?NFJ3RjNWNW5SL01leSsrbkd2ZkpGem5OZGtlV1U0Und4WnpmWHE4RFRRdmZO?=
 =?utf-8?B?R1oveC9jYTZOM2lzSm9HbUZIUTk2OFNGV3F2NzFiU01wcDMvZFFFMXRVRCtS?=
 =?utf-8?B?Y0d3TUVoZFFQTHdYNE5ib2hoQmFPS0ZmaWdWR1IzbjEvb05nalBTaUpLdEdq?=
 =?utf-8?B?aW1ja2N4VFJyRFlxSmhzVU0yYjNCM3VVVWFEYmNMUWducktpNEl6RXNOUlZt?=
 =?utf-8?B?cTRMeERsUndoeGl6KzliOUFMOWh0VjlDTC9yeThwL2JaTFpRWVlJTWFiR0Zo?=
 =?utf-8?B?TkJHU1VDY1ppcStoVnZENHdjTWRzZjJuVDJDOUZ2T3VGenVmREZFYWliVExT?=
 =?utf-8?B?UFR6TDhHVFA1cWN1VmJPckVGVVV5bExuSStqcnFIcVhvV29ESzJJcW5OdlF0?=
 =?utf-8?B?dVY4bTNuM2dDOXIyNStqbldzSFB0Rm1HVUlFMVM5NWorZjdqUEFKaXJHTng3?=
 =?utf-8?B?aTNIbVc1Mmc4aXF6SDNmTFhZTFN5QlZtNnBMbHF0UXNyQmRqTmtuKzdCbTFC?=
 =?utf-8?B?V3pQamdmZG9uYng1eEFxM2hkV3h2QXVQWVV6ZTlnenhYbVZnc3hnRndEN2U3?=
 =?utf-8?B?V0ZvRHRqc2dOUThhaEovc3R6SlMyQlhWWExkeWpZM0VpcDh3amF0K00yWHNM?=
 =?utf-8?B?ZVNvcGcwa1dvdHliU1JKUFRtajJCQlk4THkwUVVWeVl2ZnlwdUE4MHFlUlJy?=
 =?utf-8?B?V0ZraEJ2REU2eEtkTkp0UVh5VEowM1VCc3ZoempNdlZVVjhDRDF2d3VSQ1lE?=
 =?utf-8?B?MkJvbWhXTE8rbUk4eVBWanlGWUcyRVFpVFB1dDVreTg2U1hkSVVwZkx6UVJ2?=
 =?utf-8?B?RDEramlWK0tVaWlPaG5sVkJFVUFTTWN1MU5YZUZlb1B6QTBiWEt1QmpiT0ZS?=
 =?utf-8?B?bndaVkJWNUVpUjBJQVJRd3ZkMmpsUVdoWGpNdUZScjYyblZhODdsT2RmWVpH?=
 =?utf-8?B?Sk1VRkJyRG9pMEJiZ0dwa0NJbVFjYnJTbitqaFJqTmk5T1ZDNHgzUUZsUDV0?=
 =?utf-8?B?eEZOd25wSnhhVEtDMDgvZGJ1Y0p2RmFWbmMzTkdYRGZQTGF5Z3kxN2JRVTdD?=
 =?utf-8?B?NDg0M0dSR054MDhMWHFTUWNCSmg4bTlqZ011QWVJeGRleUxZLytEaXNZR09O?=
 =?utf-8?B?eXc0d1RRbVdMTGpUWlB2dGNObDB2VGxSZk9UUHV5RTdqOE5nQjBRdTJIYkhV?=
 =?utf-8?B?Q2hjWVE1b2luRXgwdFl3QnBXb29tVmd0c1hST0E4UXUzOHJVTm9OTnZqNktu?=
 =?utf-8?B?OVlNbndrckFlTk5sQWlzWjRQOFdoVzM1MXYrYWJCU0VhcjhRS0Fsb2ZQZGNp?=
 =?utf-8?B?VGNHUVhVc0NHSWRDNkpYTUY4RUdMVWtZdXlmOG14aXVXMW9PV2xvQlp5VEpk?=
 =?utf-8?B?cXlUaW9OREk3d1hBR2wrckxNWW5UcTkveDFtRGR2QVk0clQxU0pEVXZKeGg3?=
 =?utf-8?B?Qy9NUG5CTzB1RWlrRURDMkhDVmZrNlFiaFpNSDIxRmlsWlhQS29FM2dySkZt?=
 =?utf-8?B?K2h6YjZUODhkS2dNQk1vZm9uVGVRY2YvWCtwa1ZJNUwzSTNNOTA5S29PaFh4?=
 =?utf-8?B?bEdQQ2JGZ3d6VTFRWEVySUo4aUFoVFpQLzZ3UThDeEJCbmIyT3VVTHdTR2xv?=
 =?utf-8?B?NzNYWGZkRkJqVEhpRFYrWHpxUGl1TE5jNVpwcWdDcHJ5M2JrOUhzTWQyZ2hK?=
 =?utf-8?B?Mk8rcjh2VmQ5cnE4dE1xZmlNKzlNNUovSmdCdmFGVitwTFJZMFJoNkJ2NzB6?=
 =?utf-8?B?QnlVNDFXZDhsellzb3BjYk5LbXd2amJwU0RlcEptWHBxM2hrZkNzT0VUUzZh?=
 =?utf-8?Q?xrw4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(36860700013)(14060799003)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 09:49:09.6817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b27a69-6001-41f2-7e04-08de0719187c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11151

T24gVHVlLCAyMDI1LTEwLTA3IGF0IDE3OjI4ICswMTAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiBP
biBUdWUsIE9jdCAwNywgMjAyNSBhdCAwMzozNToxNFBNICswMDAwLCBTYXNjaGEgQmlzY2hvZmYg
d3JvdGU6DQo+IA0KPiA+IFNvbWUgc3lzdGVtIHJlZ2lzdGVyIGZpZWxkIGVuY29kaW5ncyBjaGFu
Z2UgYmFzZWQgb24gdGhlIGF2YWlsYWJsZQ0KPiA+IGFuZA0KPiA+IGluLXVzZSBhcmNoaXRlY3R1
cmUgZmVhdHVyZXMuIEluIG9yZGVyIHRvIHN1cHBvcnQgdGhlc2UgZGlmZmVyZW50DQo+ID4gZmll
bGQgZW5jb2RpbmdzLCBpbnRyb2R1Y2UgdGhlIEZlYXQgZGVzY3JpcHRvciAoRmVhdCwgRWxzZUZl
YXQsDQo+ID4gRW5kRmVhdCkgZm9yIGRlc2NyaWJpbmcgc3VjaCBzeXNyZWdzLg0KPiANCj4gV2Ug
aGF2ZSBvdGhlciBzeXN0ZW0gcmVnaXN0ZXJzIHdoaWNoIGNoYW5nZSBsYXlvdXRzIGJhc2VkIG9u
IHRoaW5ncw0KPiBvdGhlciB0aGFuIGZlYXR1cmVzLCBFU1JfRUx4IGlzIHByb2JhYmx5IHRoZSBt
b3N0IGVudGVydGFpbmluZyBvZg0KPiB0aGVzZQ0KPiBidXQgdGhlcmUncyBvdGhlcnMgbGlrZSBQ
QVJfRUwxLsKgIElkZWFsbHkgd2Ugc2hvdWxkIHByb2JhYmx5IGRvIHRoZQ0KPiBsb2dpYyBmb3Ig
Z2VuZXJhdGluZyB0aGUgY29uZGl0aW9uYWxzIGluIGEgbWFubmVyIHRoYXQncyBub3QgdGllZCB0
bw0KPiBmZWF0dXJlcyB3aXRoIGEgbGF5ZXIgb24gdG9wIHRoYXQgZ2VuZXJhdGVzIHN0YW5kYXJk
IG5hbWluZyBmb3INCj4gY29tbW9uDQo+IHBhdHRlcm5zIGxpa2UgRkVBVCwgYnV0IE9UT0ggcGFy
dCBvZiB3aHkgdGhhdCdzIG5vdCBiZWVuIGRvbmUgYmVjYXVzZQ0KPiBpdCdzIGdvdCBhIGJ1bmNo
IG9mIG5hc3R5IGlzc3VlcyBzbyBwZXJoYXBzIGp1c3QgZG9pbmcgdGhlIHNpbXBsZXINCj4gY2Fz
ZQ0KPiBpcyBmaW5lLg0KDQpIaSBNYXJrIC0gdGhhbmtzIGZvciB5b3VyIGlucHV0IQ0KDQpJIGFn
cmVlIHRoYXQgdGhlcmUgYXJlIHBsZW50eSBvZiBjYXNlcyB3aGVyZSBzeXNyZWcgZmllbGRzIGNo
YW5nZSBiYXNlZA0Kb24gbW9yZSB0aGFuIGp1c3QgYXJjaGl0ZWN0dXJhbCBmZWF0dXJlcy4gV2hp
bHN0IG15IGludGVudCBmb3IgdGhpcw0KY2hhbmdlIHdhc24ndCBzdHJpY3RseSB0byBjb3ZlciBh
bGwgb2YgdGhvc2UgY2FzZXMsIGl0IGNvdWxkIGFyZ3VhYmx5DQpiZSB1c2VkIGZvciB0aGF0LiBF
ZmZlY3RpdmVseSwgYWxsIHRoaXMgY2hhbmdlIGlzIGRvaW5nIGlzIHRvIGFkZCBhDQpwcmVmaXgg
dG8gdGhlIGZpZWxkIGRlZmluaXRpb25zIHNvIGl0IGNhbiBiZSB1c2VkIGhvd2V2ZXIgd29ya3Mg
YmVzdC4NCg0KSXQgZG9lcyBmZWVsIGFzIGlmIEZlYXQgd2FzIHBvdGVudGlhbGx5IHRoZSB3cm9u
ZyBuYW1lIHRvIGNob29zZS4NClNvbWV0aGluZyBsaWtlIEZpZWxkc2V0LCBQcmVmaXgsIEFsdExh
eW91dCwgZXRjIG1pZ2h0IGJlIGJldHRlci4gSSdtDQpyYXRoZXIgb3BlbiB0byBzdWdnZXN0aW9u
cyBoZXJlIC0gbmFtaW5nIGlzIGhhcmQhDQoNCj4gDQo+ID4gVGhlIEZlYXQgZGVzY3JpcHRvciBj
YW4gYmUgdXNlZCBpbiB0aGUgZm9sbG93aW5nIHdheSAoRmVhdCBhY3RzIGFzDQo+ID4gYm90aCBh
biBpZiBhbmQgYW4gZWxzZS1pZik6DQo+IA0KPiA+IMKgwqDCoMKgwqDCoMKgIFN5c3JlZ8KgIEVY
QU1QTEUgMMKgwqDCoCAxwqDCoMKgIDLCoMKgwqAgM8KgwqDCoCA0DQo+ID4gwqDCoMKgwqDCoMKg
wqAgRmVhdMKgwqDCoCBGRUFUX0ENCj4gPiDCoMKgwqDCoMKgwqDCoCBGaWVsZMKgwqAgNjM6MMKg
wqDCoCBGb28NCj4gPiDCoMKgwqDCoMKgwqDCoCBGZWF0wqDCoMKgIEZFQVRfQg0KPiANCj4gVGhp
cyBhc3N1bWVzIHRoYXQgdGhlcmUgd2lsbCBuZXZlciBiZSBuZXN0aW5nIG9mIHRoZXNlIGNvbmRp
dGlvbnMgaW4NCj4gdGhlIGFyY2hpdGVjdHVyZS4NCg0KTXkgdGhpbmtpbmcgd2FzIHRoYXQgZm9y
IHNvbWV0aGluZyBsaWtlIHRoYXQgb25lIGNvdWxkIGRvOg0KDQogICAgICAgIEZlYXQgICAgRkVB
VF9BX0INCg0KT3Igc2ltaWxhci4gWWVzLCBpdCBtZWFucyB0aGF0IGFueXRoaW5nIHRoYXQgaXMg
bmVzdGVkIG5lZWRzIHRvIGJlDQpmbGF0dGVuZWQsIGJ1dCBpdCBkb2VzIGFsbG93IG9uZSB0byBk
ZXNjcmliZSB0aGF0IHNpdHVhdGlvbi4gSW4gdGhlDQplbmQsIGFsbCB0aGlzIGVmZmVjdGl2ZWx5
IGRvZXMgaXMgdG8gYWRkIGEgcHJlZml4LCBhbmQgc2FpZCBwcmVmaXggY2FuDQpiZSBhbnl0aGlu
Zy4gRG91YmxlIHNvIGlmIHdlIG1vdmUgYXdheSBmcm9tIGNhbGxpbmcgaXQgRmVhdCwgYW5kIHVz
ZQ0Kc29tZXRoaW5nIG1vcmUgZ2VuZXJpYyBpbnN0ZWFkLg0KDQo+IEknbSBub3Qgc3VyZSBJIHdv
dWxkIHdhbnQgdG8gYXNzdW1lIHRoYXQsIGV2ZW4gZm9yIHBsYWluDQo+IGZlYXR1cmVzIHRob3Vn
aCBJIGNhbid0IHRoaW5rIG9mIGFueSBleGFtcGxlcyB3aGVyZSBpdCdzIGFuIGlzc3VlLg0KPiBU
aGVyZSBhcmUgbW9yZSBzZXJpb3VzIGlzc3VlcyB3aXRoIHRoZSBpbXBsZW1lbnRhdGlvbiBmb3Ig
cHJhY3RpY2FsDQo+IHBhdHRlcm5zIHdpdGggbmVzdGluZyAoc2VlIGJlbG93KSB3aGljaCBtZWFu
IHdlIG1pZ2h0IG5vdCB3YW50IHRvDQo+IGRlYWwNCj4gd2l0aCB0aGF0IG5vdyBidXQgd2Ugc2hv
dWxkIGRlZmluZSB0aGUgc3ludGF4IGZvciB0aGUgZmlsZSBpbiBhIHdheQ0KPiB0aGF0DQo+IHdp
bGwgY29wZSBzbyBJJ2QgcHJlZmVyIG5vdCB0byBoYXZlIHRoZSBpbXBsaWNpdCBlbHNlcy4NCg0K
SSB0aGluayB3ZSBjb3VsZCBkbyBzb21ldGhpbmcgbW9yZSBsaWtlIHRoaXMgKHN0aWNraW5nIHdp
dGggY2FsbGluZyBpdA0KRmVhdCBmb3Igbm93KToNCg0KU3lzcmVnIEVYQU1QTEUgLi4uDQpGZWF0
IEENCi4uLg0KRW5kRmVhdA0KRmVhdCBCDQouLg0KRW5kRmVhdA0KRmllbGQgLi4uDQpFbmRTeXNy
ZWcNCg0KVGhpcyB3YXkgZWFjaCBzZXQgb2YgZmllbGQgbGF5b3V0cyBpcyBleHBsaWNpdGx5IHdy
YXBwZWQgaW4gYSBibG9jaywNCmV4Y2VwdCBmb3IgdGhlICJkZWZhdWx0IiBvbmVzIChpZiBwcmVz
ZW50L2Rlc2lyZWQpLiBJdCBpcyBhIGJpdCBtb3JlDQp2ZXJib3NlLCBidXQgcmVtb3ZlcyBhcyBt
dWNoIG9mIHRoZSBpbXBsaWNpdCBuYXR1cmUgYXMgcG9zc2libGUsIGFuZA0KcmVtb3ZlcyB0aGUg
bmVlZCBmb3IgdGhlIEVsc2Ugd2hpY2ggaXMgbW9yZSBpbiBrZWVwaW5nIHdpdGggdGhlIHJlc3Qg
b2YNCnRoZSBibG9ja3MuIEknbGwgZG8gdGhpcyBmb3IgdjIuDQoNCj4gDQo+IEknZCBhbHNvIGJl
IGluY2xpbmVkIHRvIHNheSB0aGF0IHNvbWV0aGluZyB0aGF0J3Mgc3BlY2lmaWNseSBmb3INCj4g
ZmVhdHVyZXMgc2hvdWxkbid0IHJlcGVhdCB0aGUgRkVBVF8gc286DQo+IA0KPiDCoMKgwqDCoMKg
wqDCoMKgwqAgRmVhdMKgwqDCoCBBDQo+IA0KPiBpbnN0ZWFkLCBidXQgdGhhdCdzIHB1cmVseSBh
IHRhc3RlIHF1ZXN0aW9uLg0KDQpZdXAuIEkgdGhpbmsgdGhlIGNvcnJlY3QgdGhpbmcgaGVyZSBk
b2VzIHNvbWV3aGF0IGRlcGVuZCBvbiBob3cgZ2VuZXJpYw0KdGhpcyBiZWNvbWVzLg0KDQo+IA0K
PiA+IC0JZGVmaW5lKCJSRUdfIiByZWcsICJTIiBvcDAgIl8iIG9wMSAiX0MiIGNybiAiX0MiIGNy
bSAiXyINCj4gPiBvcDIpDQo+ID4gLQlkZWZpbmUoIlNZU18iIHJlZywgInN5c19yZWcoIiBvcDAg
IiwgIiBvcDEgIiwgIiBjcm4gIiwgIg0KPiA+IGNybSAiLCAiIG9wMiAiKSIpDQo+ID4gKwlmZWF0
ID0gbnVsbA0KPiA+ICsNCj4gPiArCWRlZmluZShmZWF0LCAiUkVHXyIgcmVnLCAiUyIgb3AwICJf
IiBvcDEgIl9DIiBjcm4gIl9DIiBjcm0NCj4gPiAiXyIgb3AyKQ0KPiA+ICsJZGVmaW5lKGZlYXQs
ICJTWVNfIiByZWcsICJzeXNfcmVnKCIgb3AwICIsICIgb3AxICIsICIgY3JuDQo+ID4gIiwgIiBj
cm0gIiwgIiBvcDIgIikiKQ0KPiA+IMKgDQo+ID4gLQlkZWZpbmUoIlNZU18iIHJlZyAiX09wMCIs
IG9wMCkNCj4gPiAtCWRlZmluZSgiU1lTXyIgcmVnICJfT3AxIiwgb3AxKQ0KPiA+IC0JZGVmaW5l
KCJTWVNfIiByZWcgIl9DUm4iLCBjcm4pDQo+ID4gLQlkZWZpbmUoIlNZU18iIHJlZyAiX0NSbSIs
IGNybSkNCj4gPiAtCWRlZmluZSgiU1lTXyIgcmVnICJfT3AyIiwgb3AyKQ0KPiA+ICsJZGVmaW5l
KGZlYXQsICJTWVNfIiByZWcgIl9PcDAiLCBvcDApDQo+ID4gKwlkZWZpbmUoZmVhdCwgIlNZU18i
IHJlZyAiX09wMSIsIG9wMSkNCj4gPiArCWRlZmluZShmZWF0LCAiU1lTXyIgcmVnICJfQ1JuIiwg
Y3JuKQ0KPiA+ICsJZGVmaW5lKGZlYXQsICJTWVNfIiByZWcgIl9DUm0iLCBjcm0pDQo+ID4gKwlk
ZWZpbmUoZmVhdCwgIlNZU18iIHJlZyAiX09wMiIsIG9wMikNCj4gDQo+IFBvc3NpYmx5IGl0J3Mg
d29ydGggaGF2aW5nIGEgcmVnX2RlZmluZSgpIG9yIHNvbWV0aGluZyBnaXZlbiB0aGUNCj4gbnVt
YmVyIG9mIHRoaW5ncyBuZWVkaW5nIHVwZGF0aW5nIGhlcmU/DQo+IA0KPiA+IEBAIC0yMDEsNiAr
MjA1LDcgQEAgJDEgPT0gIkVuZFN5c3JlZyIgJiYgYmxvY2tfY3VycmVudCgpID09DQo+ID4gIlN5
c3JlZyIgew0KPiA+IMKgCXJlczAgPSBudWxsDQo+ID4gwqAJcmVzMSA9IG51bGwNCj4gPiDCoAl1
bmtuID0gbnVsbA0KPiA+ICsJZmVhdCA9IG51bGwNCj4gPiDCoA0KPiA+IMKgCWJsb2NrX3BvcCgp
DQo+ID4gwqAJbmV4dA0KPiANCj4gUHJvYmFibHkgd29ydGggY29tcGxhaW5pbmcgaWYgd2UgZW5k
IGEgc3lzcmVnIHdpdGggYSBmZWF0dXJlL3ByZWZpeA0KPiBkZWZpbmVkLg0KDQpUaGlzIGlzIGFs
cmVhZHkgYmUgY2F1Z2h0IGFzIHdlIGhpdCB0aGUgRW5kU3lzcmVnIGRpcmVjdGl2ZSB3aGlsZSBz
dGlsbA0KaW4gdGhlIEZlYXQgYmxvY2s6DQoNCkVycm9yIGF0IDQ2OTA6IHVuaGFuZGxlZCBzdGF0
ZW1lbnQNCkVycm9yIGF0IDQ2OTA6IE1pc3NpbmcgdGVybWluYXRvciBmb3IgRmVhdCBibG9jaw0K
DQpJIGNhbiBiZSBtb3JlIHNwZWNpZmljIGluIGNhdGNoaW5nIHRoYXQsIGlmIHlvdSBsaWtlLg0K
DQpJIGhhdmUgbWlzc2VkIGEgY2hlY2sgdG8gY2F0Y2ggc29tZW9uZSBkZWZpbmluZyBmZXdlciB0
aGFuIDY0LWJpdHMgaW4gYQ0KRmVhdCBibG9jaywgdGhvdWdoIC0gd2lsbCBiZSBmaXhlZCBpbiB2
Mi4NCg0KPiANCj4gPiArJDEgPT0gIkZlYXQiICYmIChibG9ja19jdXJyZW50KCkgPT0gIlN5c3Jl
ZyIgfHwgYmxvY2tfY3VycmVudCgpID09DQo+ID4gIlN5c3JlZ0ZpZWxkcyIgfHwgYmxvY2tfY3Vy
cmVudCgpID09ICJGZWF0Iikgew0KPiANCj4gLi4uDQo+IA0KPiA+ICsJbmV4dF9iaXQgPSA2Mw0K
PiA+ICsNCj4gPiArCXJlczAgPSAiVUwoMCkiDQo+ID4gKwlyZXMxID0gIlVMKDApIg0KPiA+ICsJ
dW5rbiA9ICJVTCgwKSINCj4gDQo+IFRoaXMgaXMgb25seSBnb2luZyB0byB3b3JrIGlmIHRoZSB3
aG9sZSByZWdpc3RlciBpcyBpbiBhIEZFQVRfIGJsb2NrLA0KPiBzbw0KPiB5b3UgY291ZG4ndCBo
YXZlOg0KPiANCj4gwqDCoMKgwqDCoMKgwqAgU3lzcmVnwqAgRVhBTVBMRSAwwqDCoMKgIDHCoMKg
wqAgMsKgwqDCoCAzwqDCoMKgIDQNCj4gCVJlczAJNjMNCj4gwqDCoMKgwqDCoMKgwqAgRmVhdMKg
wqDCoCBGRUFUX0ENCj4gwqDCoMKgwqDCoMKgwqAgRmllbGTCoMKgIDYyOjHCoMKgwqAgRm9vDQo+
IMKgwqDCoMKgwqDCoMKgIEZlYXTCoMKgwqAgRkVBVF9CDQo+IMKgwqDCoMKgwqDCoMKgIEZpZWxk
wqDCoCA2MjozMsKgwqDCoCBGb28NCj4gwqDCoMKgwqDCoMKgwqAgRmllbGTCoMKgIDMxOjHCoMKg
wqDCoCBCYXINCj4gCUVuZEZlYXQNCj4gCVJlczAJMA0KPiAJRW5kU3lzcmVnDQo+IA0KPiBidXQg
dGhlbiBzdXBwb3J0aW5nIHBhcnRpYWwgcmVnaXN0ZXJzIGRvZXMgaGF2ZSBlbnRlcnRhaW5pbmcN
Cj4gY29uc2VxdWVuY2VzIGZvciBoYW5kbGluZyBSZXMwIGFuZCBSZXMxLsKgIElmIHdlJ3JlIE9L
IHdpdGggdGhhdA0KPiByZXN0cmljdGlvbiB0aGVuIHRoZSBwcm9ncmFtIHNob3VsZCBjb21wbGFp
biBpZiBzb21lb25lIHRyaWVzIHRvIA0KPiBkZWZpbmUgYSBzbWFsbGVyIEZFQVQgYmxvY2suDQoN
Ckl0IHdhcyBteSBpbnRlbnQgdG8gb25seSBzdXBwb3J0IHdob2xlIHJlZ2lzdGVycyBoZXJlLiBB
bnl0aGluZyBlbHNlDQpnZXRzIGluc2FuZWx5IGNvbXBsZXggcmF0aGVyIHF1aWNrbHksIGFuZCBt
dWNoIG9mIHRoZSBiZW5lZml0IGdldHMgbG9zdA0KSU1PLiBCeSBvbmx5IG9wZXJhdGluZyBvbiB3
aG9sZSBTeXNyZWdzIChvciBTeXNyZWdGaWVsZHMpIHdlIGFyZSBhYmxlDQp0byByZS11c2UgdGhl
IGV4aXN0aW5nIGxvZ2ljIHRvIGVuc3VyZSB0aGF0IGRlZmluaXRpb25zIGFyZSBjb21wbGV0ZSwN
CmFuZCB0aGUgZ2VuZXJhdG9yJ3Mgc3RhdGUgdHJhY2tpbmcgcmVtYWlucyBzaW1wbGUuIEFuZCwg
YXMgeW91IHNheSwgaXQNCndvdWxkIGJyZWFrIHRoZSBSZXNYLCBVbmtuIHNpZGUgb2YgdGhpbmdz
IGlmIHdlIGRpZCBhbnl0aGluZyBlbHNlLg0KDQpXaGVuIEkgYWRkIHRoZSBtaXNzaW5nIGNoZWNr
IEkgbWVudGlvbmVkIGFib3ZlLCB0aGVuIGl0IHdpbGwgY29tcGxhaW4NCmlmIGZld2VyIHRoYW4g
NjQgYml0cyBhcmUgaW4gYSBkZWZpbmVkIGJsb2NrLg0KDQpUaGFua3MsDQpTYXNjaGENCg==

