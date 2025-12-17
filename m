Return-Path: <kvm+bounces-66199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86927CC9FA2
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 02:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3BD5330101D2
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 01:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED0D24BBE4;
	Thu, 18 Dec 2025 01:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h/pG/ZTy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h/pG/ZTy"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013067.outbound.protection.outlook.com [52.101.83.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7612117993
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 01:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766021152; cv=fail; b=TrZ/5qKnK3QGkKUaRINSlAOwPKuisq8/cAZd8ggkmrV2Utfe7A/nB087hs5wNetc9S8Tw5fBILEvqU2Me6yUxNTvGnfoKQ6L6NcEoG3DENrNaQJZUx5Jkl+V3yZzOVjwFRred/A+1mmG5+iwEShE/qn0zz1oA5wX0AxX6s9P9l8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766021152; c=relaxed/simple;
	bh=fy8xfiOcpRgvOgbXngC8t48f+Pk9cyMVUM4gPm3IAFk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f5ZG7WwFphnRDvlC+OJGQ9IfgJe5C073LI9aFtT3QCy9Zhi+yBMEQ4Mlf3tzoZ8Vul4nKhCNYT6wqBJCv4tRlGNXr/YrEwmjYFNX8QKthcTtCSpsYtAv/+P0tE0gKolKK8PopSYK+eAQCdGxvjrjN9vWFWkxmw0ZujcpUKPqIFk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h/pG/ZTy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h/pG/ZTy; arc=fail smtp.client-ip=52.101.83.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=W3Wer1V3b2MiTtWeyCuwanVoEknj/lSDicY/OPhKBZBnMYn4SHJvRJE+YN/49hHLcCqkOSdLww0XiYTqLI1CR8OaO07cyTYnDvU+3s8VkOaFOcc0R7mBubvq78mT4cn/hkaSxAnarp1EuyGqsxTxb6ZSv7v8eVP9hoC05+S4x7JDFEhNU5FHS/IjDHtHQ+yrQp/3y6fVsgTOcNRE7Suv4vMrfgsEIodjTEE5PXzogpFXNG/sg2Ug5V7cuRTCiw4dWORThYEjnG0uAmqe5lcgW2HZsJ5c2aMYKayvmR3gGA96VL7XpBZsA3x3qDqnI9YrXok4o0odT22qZvb+63U2rg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fy8xfiOcpRgvOgbXngC8t48f+Pk9cyMVUM4gPm3IAFk=;
 b=TjPJ9IvHz5LDRrJbDpXqBON8et7hc+ryTnJ4gGtGlbuRWoacEZXEIVRAgk105T6/yxksdAkqDaYSqQIY//Q/gHLcpozzAzP22IrtrmnmuSh+H/3KIVNbtshrAoFH0eH85llNk2iSwMaMiwFLLN2nwUxLfzUU5Ew10PFuZ3ARdhUpcam2ekdp1vyYSqkiTmEU3nc4TWt852NyWrBfy+C9g6Kcwaq8Bo40rtEz7UiyaZq5p+q6A4g4u7/qGmjQ0qMW2ebsVD6em4xCT04M0pVqAbYPN0GsXJSnReVQ/HRRhSNFowDm+D4pi6XUyo6OLkv+g/bTWymdPPd1i90zogHDIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fy8xfiOcpRgvOgbXngC8t48f+Pk9cyMVUM4gPm3IAFk=;
 b=h/pG/ZTyVwdrGBiho9OsIoOgwjEgBlETOEMSIzBNuiI3ynNsl4A5/4PDTh1geCfH+hqaTrZ8BBUpx5QCsljx1+CkyN3xqSHAlRhOVGUmA/NGDbC1+6EyFPKtIk8XjnMfLp1rT1lpnYhhQX/JCGVdCjhdj8BaKP3lapI5afGzDXQ=
Received: from DU2PR04CA0157.eurprd04.prod.outlook.com (2603:10a6:10:2b0::12)
 by AM8PR08MB6625.eurprd08.prod.outlook.com (2603:10a6:20b:357::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 20:51:41 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::db) by DU2PR04CA0157.outlook.office365.com
 (2603:10a6:10:2b0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Wed,
 17 Dec 2025 20:51:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Wed, 17 Dec 2025 20:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQIBE5B3uIs6U50tA2XGJesIfFH9EelwIyYSlzSW0a2P8mDCie/dxtDyVLPXZvWbyAIFTMKNkrA2qIYRaBa2ynf+S1rlegrxzALi10UU+ekVAaOAe6eJ3nGNSI11yAQ+twDSn0NK+bEBZtagPetwQZT5UUbli7sumxb5nuCvqjOtit/+gM7DmvN6ZYmaitSVy0Fk4OIl2fBCbkQn7Kuv778mZZsH5ZJvfz2rdyqmVlynigVogIdrB2l21tc+kpdUEJVtO8FQGTzbUADza62jkoTUxcnsn2KbqM0phrugWaakvqLnJzpaQ9UFuyfz9WdsKeVbtHJ3c5jFr+A9e55PcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fy8xfiOcpRgvOgbXngC8t48f+Pk9cyMVUM4gPm3IAFk=;
 b=YlQa0m70J3twOIrnewlITCGCzXOI8BKkvosdpWeRr7l1MUcbiB08W50zDIkeb0EhlWviQ15bWsBYuIQjR+06hzAMVZ6Km0YyO1eO7zoWHm/4hxgr91CO9yNvgZ6la2chKXC+r9P2TdUNLF0JebqdDmxq1gLBn2Ar5jbNxLyMEL16l5PC0usnqmkWYaAU3iTBuCGGQwAluPF/WhEfu6S5BCv8PMdziZPoPoAhy6u2l1UeoFw42ro6xoG2lNU8oAM7cyPgUqv63jHVSJKV8ZAk1WYzNW9qVohb7hGZk7h6nnDUhdlud5Gu5QiQlqda8G1vivGfkg/mNOH1XkLPjNe/9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fy8xfiOcpRgvOgbXngC8t48f+Pk9cyMVUM4gPm3IAFk=;
 b=h/pG/ZTyVwdrGBiho9OsIoOgwjEgBlETOEMSIzBNuiI3ynNsl4A5/4PDTh1geCfH+hqaTrZ8BBUpx5QCsljx1+CkyN3xqSHAlRhOVGUmA/NGDbC1+6EyFPKtIk8XjnMfLp1rT1lpnYhhQX/JCGVdCjhdj8BaKP3lapI5afGzDXQ=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM7PR08MB5509.eurprd08.prod.outlook.com (2603:10a6:20b:10c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 20:50:37 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 20:50:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 16/32] KVM: arm64: gic: Introduce irq_queue and
 set_pending_state to irq_ops
Thread-Topic: [PATCH 16/32] KVM: arm64: gic: Introduce irq_queue and
 set_pending_state to irq_ops
Thread-Index: AQHca3snKFUfGawyy0G6cq0rHQaFWLUlmcMAgAC83QA=
Date: Wed, 17 Dec 2025 20:50:37 +0000
Message-ID: <26bbc034a355fed965261beaa93b9a3895918504.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-17-sascha.bischoff@arm.com>
	 <865xa5o3ip.wl-maz@kernel.org>
In-Reply-To: <865xa5o3ip.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
 VI1PR08MB3871:EE_|AM7PR08MB5509:EE_|DU2PEPF00028D0F:EE_|AM8PR08MB6625:EE_
X-MS-Office365-Filtering-Correlation-Id: f81faa6e-c785-40f6-6f5c-08de3dae1481
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?a1ltUlY0aXB0anlWV1hsYzBHK052dkNwcUlJbm84emNHR3N2RGJyN1pocFZC?=
 =?utf-8?B?aG4ybGNlaDZkTzRuRmo5Tkthc1lUVy9hb1Q1Wk5CczRJejkzdU01aTRncHkw?=
 =?utf-8?B?MFFwWHpxK2hJc0hJUlFKN3lSMlUwb1lHZThxMXkyVDhYcUFUWGE0UWRpb0ZT?=
 =?utf-8?B?b3lGalRWbUxJemllMjB2TVZkYk5OaFdRa3RWQlpoT2I1alZ0TjRiVVRPNm50?=
 =?utf-8?B?UVlCTUZSQjNNWGpmUVRsRVdQdWVXcDNvVHZmUExXK1FqcWtvTEtiakVuUFJr?=
 =?utf-8?B?TnNpOEVNOVlaMktQVHdmNEZFaW54ZjMya3RoS2hvcmNGaElRbmJSNThOR2Q0?=
 =?utf-8?B?NjI1THA0TGNpZVZYWXlsbjZremUwL2FyOGUvQk5uSkhOL2o2STljRytBRUMr?=
 =?utf-8?B?MHlYM2J4dVhRaVE2aTIrZXZiZUZiamltRXl4Rjg3RWhLUE55RGhKd09CRUxw?=
 =?utf-8?B?TVB1MVBTMURyblB3SVRKVGFTSzlTZ2hNcW9ZSUQ1LzNTVE12VGFYK1YzM2Y3?=
 =?utf-8?B?d1ZkTzB5cXdpdExaM0VCdUc2RlJTTXNjK2orMnI1c0MybzFIWEYvbFZibnAz?=
 =?utf-8?B?eUdMeVdoKzY1c0xKcFY0aTNiTmxqaElLY3hHd1JTbzNKeHg0ejNWT3pJL3I3?=
 =?utf-8?B?R0lHVmtzaElPWUppSlc2Y0R3Ymc1enRoUXdhYnU3NlcvSFlzeU1pbTNxdS9m?=
 =?utf-8?B?NzA5dVdFc0dYM2NIdVZDSmlPMzlKS0RXU0hsRnJOMGJnb2Q3VWNVZ3h6elFH?=
 =?utf-8?B?MWlJVzFUTzNQK1NPNW14YndKcVMzKzhqWGZkT2VxM3Q5ZzJlMjBtVFJET3lH?=
 =?utf-8?B?RUxrSFdlVTk4UHNXTWZkYy93eDdxYVI1QS9sTWVCMGYvRkVmSVpHUWFhUktG?=
 =?utf-8?B?dnNGWk0veHA4WFgvdUZVMEx5UkFBaVErZlBaRzNWZzdyREZKL0hkQnpiZlhK?=
 =?utf-8?B?Q1RsU0I1c1FiNXhrTlBQN2Z2S1ErYnZyOUp2TittN0JiT3JlWFFlWHdEb1Vu?=
 =?utf-8?B?VlFKdzlHakFOYUlrLzdIZ3dQdDVzNVYzbmQySzFFSS9XRG84WkwvRUQ3UUZW?=
 =?utf-8?B?aVJNMDJFUU9OSWRaQ2ZPWW1MR1RDLzQySWVQekN2NVBUT0V5VTVNcXpOZHdB?=
 =?utf-8?B?N1hGWmh2T2pIMnlGYlE4RCtvdHpxYmZUVHJWa0dITGJaZHF5SHVybVpMNm0v?=
 =?utf-8?B?aCtkVUtxaWFiYVpwRXRMeEZoVERWanlucnhBY1ZnYjZUME8yZGJNSHVSSC9q?=
 =?utf-8?B?Nll3aXh6bURwRTh1eUd3cVFwODIvb1JoZC9nQjFNWmRqdlI0ZjZOZkl5STNq?=
 =?utf-8?B?akN6UGRSSkhkOEFxUXo3N0dQU2doNjVaeEVEQytLdTJZdWowekVsdFpodm44?=
 =?utf-8?B?czJVeU5McWNDa3MrbTY0cEpad0RsQllqaHZxZXNtVHJibHJUM1pJRjUvSDNX?=
 =?utf-8?B?eG5SZUxTb2Q5SEhjdnkwa00yRERWTTZEbVVSZzFRQ2xSa2hIQmd4NEs1ejhT?=
 =?utf-8?B?RitHczFWbEZvbmNvR3luRjN6YTFBRzdiZGhDV2xEWTBlaU1GNHp0RGJxSDlO?=
 =?utf-8?B?QUI1aldJdHBXL0lFdmYvK2VDTGRFSWRFMVRzUWNVTTdSS2pkNDVaQk9kdWJK?=
 =?utf-8?B?Y3hRWTl1TU5DK3IvM1hOMXVmVmNSdTNpbTN0NUpVcXN3b1ppYjBGQ0VoM3Zk?=
 =?utf-8?B?SDVFclBpNmMzamV3TklFb0cvbTRYUDY2bmJwbzFqSkpDWXIzWmorTjlxZ1A3?=
 =?utf-8?B?YVlkc1lFdzYwcDdzK2xyekc2WlZZMnFkajczV3dTekwyT0FGUGdraFJpN2k1?=
 =?utf-8?B?eG42RlZYcTRFcEFFM2FETUZubldmL1c3K1hBaTFMajNReXBnZkcyOWdtbWxi?=
 =?utf-8?B?bThmTy9zTmdRSEhQNWhLclZMcFIzU3pRc2htc0g5K3F4dm81bCtLRkxCUUtK?=
 =?utf-8?B?OVRVOGswcXpQdXdZKzc3VEp2VmE4WCtTQzllSW12RlBWckU1TUZtSHY5UU13?=
 =?utf-8?B?NVJyZDA3dkZxekJmOWRhNnZFVGN6NUllOVVyWWdVTXZlMyt3dXNwa1lSTHlI?=
 =?utf-8?Q?iKrDPl?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0095C56DB767742AAA57B2786280828@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5509
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
 e30ceeaf-d90a-42e0-461f-08de3dadeeb8
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|35042699022|14060799003|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?dW13cjJ4ZkNvRGdna1JHNEx0QXpId0hwSEx0TE5vRnl1d3NjcHhweEw2dEti?=
 =?utf-8?B?bGFnangrZ3dpb09ocEZORElESmRxQkhKRVJUaFB1RndockttY21UcFBhVFVr?=
 =?utf-8?B?TFFud1RLSUdkV2FLZWVNWEgwTHF1eHZpYlFvTlpKRmpVYjVFTlhLS0xJTWFJ?=
 =?utf-8?B?OHdQclRKWmdXT3RZblN3R1JFeW9mSTZrY2JBWlZzWTRIdjJObzcxNEMzQlc1?=
 =?utf-8?B?Rm5YMGNMcHh2WmpTVWkvd3N5SHpOeFFINGxBN0lPckpidllUdkxXMEwwOXJK?=
 =?utf-8?B?VjA5d25FeEFHUVhDRFluaStSS0VDaWZ0YUV4SnZYM3g0ZE55Z1l0MGw0Z2M4?=
 =?utf-8?B?c0NsZm8rQ2szNzJXUnVENlYwRlB5L0Y3NkthNlNvYVdaQ1FSekhDeTRBYkht?=
 =?utf-8?B?N01tUkdDS2pldXRreDFiRVhHZVZnUndjRm9iYjFTaTViLzNXNXJadzZrMEo0?=
 =?utf-8?B?a3lXWTNVd2x2N00zZlg0Z3ZlWXdOeWo4SjBqcDN5UVc1QldheWNFM01CRUFT?=
 =?utf-8?B?M0Vsa2RDZGs2WmJJTGdaUVQzdFR1VDRJT0RoRitmSEFCRm1vc2FVeGVMekVr?=
 =?utf-8?B?N3h2SFlXRjBZUVQxVkMxN2dMdkZlOHRPOGJBSnliVmN0WVMrN0xLS0tWYnRk?=
 =?utf-8?B?QUZHenkwTDk5dWZWclNtRUdHbWZFMUZNWG1CdCtsanNCU3NQemdQNVJmQmZj?=
 =?utf-8?B?YW5PaUdORDZ0TFJJYXdNZThNd1A2anhuTGdHbW0zVzR1S05UV08xVFVFZUFB?=
 =?utf-8?B?OTc5VVVIN3VDOGZUOFplU1ZDSWlIamZLNVMxcDluZXl3dC92RmJWdGRtNE5x?=
 =?utf-8?B?c0NXL2hiSVNpUzlpbkZjS0ZaZEViR285c0tXTUxDUmJsNGhuSUYxVlBrQVlU?=
 =?utf-8?B?S1dkL0JGUUNmWnJrdVMwY3VHaW5ISFE3MFpTUnNEMjRqb1VIV29OaEUrUHNw?=
 =?utf-8?B?ektpNUhnYWtDcnROYzFTMlk1amptaTNBUTBjcGg0c2liR3RwQURoUFB6Zm5Y?=
 =?utf-8?B?TklVbytLTmpkUXlpTEdyNDhrOGxrYVQ1ZWkwMTQ3ZE5jUGhNV2pFL2x3di9W?=
 =?utf-8?B?T1BkbFpMZE9vS3plNUgrb2ppY0lSQXF2MVpoNm54a1dNT0QvUHEvY012NGVm?=
 =?utf-8?B?d0FmSjRWUE9jaWdWQVpYSzB2RzJRT1piWU1oWVF2ZDdYQjBpN3lLVG4yZkU0?=
 =?utf-8?B?cUIxajNEcFN3NFFBemxHSUlpdTMwMlc1ZG1wbEIyMndCWFkyOFFlN0U5K0d1?=
 =?utf-8?B?T1J4cm5ENHF4M1cvZUsvSWJqUnhhNEFhemVTWFBDMks5YWtIMUVtVWRxWWhk?=
 =?utf-8?B?bmhudFhVTjliQnFjWjhtNHJTdkdySUU0N2R6eW1ieTRMZ1hvbXVMSzBad1Q2?=
 =?utf-8?B?NHdkQ05naHRkZWJQaXFVYlphNkVpMW51UzRhL3BzbVozM1I2bmZBa2NhS045?=
 =?utf-8?B?ZnpBYXB5a0l3Nmt5MWVTN053RUxvSHZaQnZKR3Bqd1JsK3hkQXdVT2tZdy9S?=
 =?utf-8?B?MlNOWS84Q21iVi93ZFBsekNFckVYZWM0N0pYdzdVbVhVdFUzVUpwVVBGZy9W?=
 =?utf-8?B?SGRIcGZpb0cyTmFCb0ttQUt5b0JVRTU5QWJSdDJKeWg3NTNmdmJlTW5tNStO?=
 =?utf-8?B?Wm03TWE0TGxjZHVvWnlDclJJQldGWHM0RE9hcnY3dXlRSWNnZCtsemRyK29V?=
 =?utf-8?B?bTFqeWVvejFWN2x5WHlBdXJJVVlqNlQxRmFaQ0ltcld3eFFXOWdDMFgwUjhs?=
 =?utf-8?B?L0M1K1hjNi9POFFQSDBvTlY4RU1mMnFSNWliQitzRW5ReXg3ZDMzZkdzb1Bu?=
 =?utf-8?B?dlJPYTlEQ3dJT3VVVzE2OU9hYU8rZUU0dU9kanZJZWZmU0wyTjVZOTVVM0o1?=
 =?utf-8?B?c1QxeEx3djZwSEZGRmJETW9mZkdnZ3dKODRYZTFlWlZjRndMSzhwR05NWUQ3?=
 =?utf-8?B?Q1NIeENlRnZqRzlwcFlPTFAzQnBVRlIwQ0JyUGdoM1BaOU5KUGI3bHVDVzMx?=
 =?utf-8?B?UkZ4WWw5TnZFcExqT3RuSjB4NVBKbm52aDRQTnRlbitxbUhsSnpmL2ErMHU5?=
 =?utf-8?B?THZGZk1IcWVaWERsTGFGOVZZZkpDYUtwZG9VVXRrdjc0bmtFVWt1WkJ5VDBt?=
 =?utf-8?Q?FLcE=3D?=
X-Forefront-Antispam-Report:
 CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 20:51:40.9743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f81faa6e-c785-40f6-6f5c-08de3dae1481
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6625

T24gV2VkLCAyMDI1LTEyLTE3IGF0IDA5OjM0ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6NDAgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoZXJlIGFyZSB0aW1l
cyB3aGVuIHRoZSBkZWZhdWx0IGJlaGF2aW91ciBvZiB2Z2ljX3F1ZXVlX2lycV91bmxvY2sNCj4g
PiBpcw0KPiA+IHVuZGVzaXJhYmxlLiBUaGlzIGlzIGJlY2F1c2Ugc29tZSBHSUNzLCBzdWNoIGEg
R0lDdjUgd2hpY2ggaXMgdGhlDQo+ID4gbWFpbg0KPiA+IGRyaXZlciBmb3IgdGhpcyBjaGFuZ2Us
IGhhbmRsZSB0aGUgbWFqb3JpdHkgb2YgdGhlIGludGVycnVwdA0KPiA+IGxpZmVjeWNsZQ0KPiA+
IGluIGhhcmR3YXJlLiBJbiB0aGlzIGNhc2UsIHRoZXJlIGlzIG5vIG5lZWQgZm9yIGEgcGVyLVZD
UFUgQVAgbGlzdA0KPiA+IGFzDQo+ID4gdGhlIGludGVycnVwdCBjYW4gYmUgbWFkZSBwZW5kaW5n
IGRpcmVjdGx5LiBUaGlzIGlzIGRvbmUgZWl0aGVyIHZpYQ0KPiA+IHRoZSBJQ0hfUFBJX3hfRUwy
IHJlZ2lzdGVycyBmb3IgUFBJcywgb3Igd2l0aCB0aGUgVkRQRU5EIHN5c3RlbQ0KPiA+IGluc3Ry
dWN0aW9uIGZvciBTUElzIGFuZCBMUElzLg0KPiA+IA0KPiA+IFRoZSBxdWV1ZV9pcnFfdW5sb2Nr
IGZ1bmN0aW9uIGlzIG1hZGUgb3ZlcnJpZGFibGUgdXNpbmcgYSBuZXcNCj4gPiBmdW5jdGlvbg0K
PiA+IHBvaW50ZXIgaW4gc3RydWN0IGlycV9vcHMuIEluIGt2bV92Z2ljX2luamVjdF9pcnEsDQo+
ID4gdmdpY19xdWV1ZV9pcnFfdW5sb2NrIGlzIG92ZXJyaWRkZW4gaWYgdGhlIGZ1bmN0aW9uIHBv
aW50ZXIgaXMNCj4gPiBub24tbnVsbC4NCj4gPiANCj4gPiBBZGRpdGlvbmFsbHksIGEgbmV3IGZ1
bmN0aW9uIGlzIGFkZGVkIHZpYSBhIGZ1bmN0aW9uIHBvaW50ZXIgLQ0KPiA+IHNldF9wZW5kaW5n
X3N0YXRlLiBUaGUgaW50ZW50IGlzIGZvciB0aGlzIHRvIGJlIHVzZWQgdG8gZGlyZWN0bHkNCj4g
PiBzZXQNCj4gPiB0aGUgcGVuZGluZyBzdGF0ZSBpbiBoYXJkd2FyZS4NCj4gPiANCj4gPiBCb3Ro
IG9mIHRoZXNlIG5ldyBpcnFfb3BzIGFyZSB1bnVzZWQgaW4gdGhpcyBjaGFuZ2UgLSBpdCBpcyBw
dXJlbHkNCj4gPiBwcm92aWRpbmcgdGhlIGluZnJhc3RydWN0dXJlIGl0c2VsZi4gVGhlIHN1YnNl
cXVlbnQgUFBJIGluamVjdGlvbg0KPiA+IGNoYW5nZXMgcHJvdmlkZSBhIGRlbW9uc3RyYXRpb24g
b2YgdGhlaXIgdXNhZ2UuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2Zm
IDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5jIHzCoCA5ICsrKysrKysrLQ0KPiA+IMKgaW5jbHVkZS9rdm0vYXJtX3ZnaWMu
aMKgwqDCoMKgIHwgMTUgKysrKysrKysrKysrKysrDQo+ID4gwqAyIGZpbGVzIGNoYW5nZWQsIDIz
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5j
DQo+ID4gaW5kZXggMWZlM2RjYzk5Nzg2MC4uZmMwMWM2ZDA3ZmU2MiAxMDA2NDQNCj4gPiAtLS0g
YS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy5jDQo+ID4gQEAgLTU0Nyw3ICs1NDcsMTQgQEAgaW50IGt2bV92Z2ljX2luamVjdF9p
cnEoc3RydWN0IGt2bSAqa3ZtLA0KPiA+IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiDCoAll
bHNlDQo+ID4gwqAJCWlycS0+cGVuZGluZ19sYXRjaCA9IHRydWU7DQo+ID4gwqANCj4gPiAtCXZn
aWNfcXVldWVfaXJxX3VubG9jayhrdm0sIGlycSwgZmxhZ3MpOw0KPiA+ICsJaWYgKGlycS0+b3Bz
ICYmIGlycS0+b3BzLT5zZXRfcGVuZGluZ19zdGF0ZSkNCj4gPiArCQlXQVJOX09OX09OQ0UoIWly
cS0+b3BzLT5zZXRfcGVuZGluZ19zdGF0ZSh2Y3B1LA0KPiA+IGlycSkpOw0KPiA+ICsNCj4gPiAr
CWlmIChpcnEtPm9wcyAmJiBpcnEtPm9wcy0+cXVldWVfaXJxX3VubG9jaykNCj4gPiArCQlXQVJO
X09OX09OQ0UoIWlycS0+b3BzLT5xdWV1ZV9pcnFfdW5sb2NrKGt2bSwgaXJxLA0KPiA+IGZsYWdz
KSk7DQo+ID4gKwllbHNlDQo+ID4gKwkJdmdpY19xdWV1ZV9pcnFfdW5sb2NrKGt2bSwgaXJxLCBm
bGFncyk7DQo+IA0KPiBJIGZpbmQgaXQgc2xpZ2h0bHkgZHViaW91cyB0byBXQVJOKCkgaW4gb25l
IGNhc2UgYnV0IG5vdCB0aGUgb3RoZXIuDQoNClllYWgsIG5vdGVkLiBUaGF0IGdvZXMgYXdheSBh
cyBJIGhhdmUuLi4NCg0KPiANCj4gTW9yZSBpbXBvcnRhbnRseSwgd2h5IGlzbid0IHRoZSBwZXIt
aXJxIHF1ZXVlX3VubG9jayBvcGVyYXRpb24gdHVja2VkDQo+IGludG8gdGhlIHZnaWNfcXVldWVf
aXJxX3VubG9jaygpIHByaW1pdGl2ZT8gV2UgaGF2ZSAxNiBjYWxsIHNpdGVzIGZvcg0KPiB0aGlz
IGZ1bmN0aW9uLCBhbmQgaXQgaXMgb2RkIHRoYXQgb25seSB0aGUgaW5qZWN0aW9uIHByaW1pdGl2
ZSB3b3VsZA0KPiBiZW5lZml0IGZyb20gdGhpcy4NCg0KLi4ubm93IHR1Y2tlZCB0aGlzIGludG8g
dmdpY19xdWV1ZV9pcnFfdW5sb2NrKCkgYXMgeW91IHN1Z2dlc3QuIFlvdSdyZQ0KcXVpdGUgcmln
aHQgaW4gdGhhdCBpdCBzaG91bGQgYmUgYSBtb3JlIGdlbmVyYWwgdGhpbmcsIGFuZCBpdCBpcyBi
cm9rZW4NCm90aGVyd2lzZS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IFRoYW5rcywNCj4g
DQo+IAlNLg0KPiANCg0K

