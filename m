Return-Path: <kvm+bounces-67418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0804D052C5
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A7BCC32FBE3D
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F782DCF4C;
	Thu,  8 Jan 2026 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HnK5/aOS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HnK5/aOS"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013043.outbound.protection.outlook.com [52.101.83.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388A92DCF46
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891207; cv=fail; b=OSxhn/S2YP2qhVskFjRVoWZxj0tL56HJuOcjEWtEFjikHO9ySrb1NbZx7qJ3GBV6Q/nI4uap+9wd0YHiedxNvbhLB+7d/eYci0p2glWDR8uEXvqsx+ixdKkx12eAVZbyfYjAqxzjGQeztgGcXoB1qSqahu0xR0pPgCyNeZy9dH0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891207; c=relaxed/simple;
	bh=h59MiTGgT6+vmdmQTY7pRzZ7tqNI9A6JQN/GuHZsSx4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ya7tA8xA4qaPq5vIM/O2zaVdr+skRquhJ1pW+/n6ofBTaiA3WshW/rirloMyXSL+al+Vj7d+aO0rTApSUSxEO9UVEXyttvPUpyIf1dNRoXTl/jbAQsNBUvwiDhArR+YtdDnO42KO26+IibU7hPP+7IBMDGxTCwEX3R7ibWAvTNc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HnK5/aOS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HnK5/aOS; arc=fail smtp.client-ip=52.101.83.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oQjF2DjiQ8+i1I599R4fCL01HLaUR723d6I5b02YnXuu/lgxkVDquGL6gorAkoqc9/1YmyqlizIj0EOb6Zd+d30tdD66lLWDrxmf1qK8nS9Dk2qHAvzbPxXLxwYEK6uVYImOT/2UnfrvZoSTLhNEW0MBoH2Gl/dpk6SdviVggVRLkrnP3yV8z0quvydmL8gX+S4CdvojLFb/y4h6C40FjrKiyhVQLBztSbOEjPdG42E1GgI8dU5zXqvInhPVVgnG3Q1SxWlguOY7AZ5wmdiwqbr6lShUYGHCn9cEydvJCJ2zYyeouhDr7MAuU/mFjEHfIU/pfVZH+1zEJAVWh8locA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h59MiTGgT6+vmdmQTY7pRzZ7tqNI9A6JQN/GuHZsSx4=;
 b=zO83jF7hy890W2AawcfzNpZtHmC0W7aa2vG7sBaKqBqDojnpgSHRWLMiMQq96SvtR/V96A/Kz7ZrP7ublr1ZFc9rCNmOrqLgZEWlDV/HRhn4KExV9wBC+YRPKzT3GRiM+N2K40d0nYLelZUPAMgoffI3Q09h+jtlpUybvC8vsHhpXb9qOCIll1L1LFROYXWr7RAaK+nuBrrBExCzPm+zBTcjeBuua9u7Ri2keFrrLOT5RCqy3NUtqZL3Jo1pVmhuPQV0KXbbTaab2FOoE5Is2QwSom7eJIUfHhJk93ixNyi/xtqkW6FWwj1kLrVZecwBWNtyIfOR4a6hb+Ob/dm2qQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h59MiTGgT6+vmdmQTY7pRzZ7tqNI9A6JQN/GuHZsSx4=;
 b=HnK5/aOSvr+psSkrK1aLjaXERve6HL4ePUATKuO9tOeUHk+dARM7ucvKSap639shnOuiYGXv/va7bTG9548KOLpnNj/XzW6OLNbOq2ea45azy5Tkf1W/EYfvvNTvJfcQaVBt/CGMXHRM6+sBjMCP+r6a8d5yn585aaNdzDwMwkw=
Received: from DU2P251CA0019.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::26)
 by AS4PR08MB8045.eurprd08.prod.outlook.com (2603:10a6:20b:585::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 16:53:19 +0000
Received: from DB1PEPF000509EC.eurprd03.prod.outlook.com (2603:10a6:10:230::4)
 by DU2P251CA0019.outlook.office365.com (2603:10a6:10:230::26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3
 via Frontend Transport; Thu, 8 Jan 2026 16:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EC.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1
 via Frontend Transport; Thu, 8 Jan 2026 16:53:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=td5JxzvEcdsoTbACebPfxbu/abxVC6M17TJkppg2lLWxrLJN7JOJP6kllAhSg47WBqaVo71o3ApQaLaGkl4wgf+tz+mglgswy7L7Wgf8XiT9ljq0nLDZCNziRt0928p3hDSoBGCaRgcFHjmBNQyr5jaiEBymJ9qdcl+5QMjvHW/BM7lLb4F4sHX8wPY8Uvusnhz4KU8UvHFwMinD9OmgjCf7oT7kaWmtF11RdhjHuqVNFUzajxg/RHxVddnqYwzH+ypa6UhBHNqXg0eFVDRKmqAfx4sVR5+hYfNf/+sp+hNxc91rhuylamSbra2dcbHbXPo+HD6Aet9q9EeI3VBqnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h59MiTGgT6+vmdmQTY7pRzZ7tqNI9A6JQN/GuHZsSx4=;
 b=cWcclEhT0qNUxNPj133wTV//4F6xapEArR3AB4jUzjLtvB5LYFhqhHjUobuZVj9nslMJKxHmqoFUETTdBLR2qC/1uiok3UKX+mOdwmcmC0F7eLMk7NlJGliDwE+afVlXRwBzwhmgU2B3rhGD/i8rUmjEN7R/lmJVRLllUGoQhNjSbeif+XAPIpW5/N4yfbmD082DOtNEDKTx2E9E7f0NTq78RB8/3lxeClDmmJGyAAtrheETmYBzNDFRr14aya9DviWslyYUwKcw14hvvSLS0VJiLtg9LiSiJjsAOuBmgzN+gM01ttYhDjYBVJ0UnxgXGJTsESApNAk50jOCW5PqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h59MiTGgT6+vmdmQTY7pRzZ7tqNI9A6JQN/GuHZsSx4=;
 b=HnK5/aOSvr+psSkrK1aLjaXERve6HL4ePUATKuO9tOeUHk+dARM7ucvKSap639shnOuiYGXv/va7bTG9548KOLpnNj/XzW6OLNbOq2ea45azy5Tkf1W/EYfvvNTvJfcQaVBt/CGMXHRM6+sBjMCP+r6a8d5yn585aaNdzDwMwkw=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAVPR08MB9377.eurprd08.prod.outlook.com (2603:10a6:102:302::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:52:12 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:51:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 21/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Topic: [PATCH v2 21/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHccP+DOirGMbr2k0aWwKAdr6jb4LVG7QEAgAGvIwA=
Date: Thu, 8 Jan 2026 16:51:45 +0000
Message-ID: <ce2c6e24caf1a2f027245dd1f43f7d5f6f54822b.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-22-sascha.bischoff@arm.com>
	 <20260107150838.00004e00@huawei.com>
In-Reply-To: <20260107150838.00004e00@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAVPR08MB9377:EE_|DB1PEPF000509EC:EE_|AS4PR08MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4054d9-b35b-4657-dada-08de4ed66cbc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VnpqQVJvbGpQRS9oMFRVU0xneXlCT0VBdjQybkc2ZEFLamF5enh6Y0s0N2hI?=
 =?utf-8?B?ODNNaDZEV1JuQ1JXWUROcnk5QzBZL09qd05SakdLNzdVTWNpQWhybUxjMnRl?=
 =?utf-8?B?bWE2QXRtNnI5TTFrL0tFV1hMMmEzaDMydTZGR2dWanYwcDNJVDhTaFFRdVJo?=
 =?utf-8?B?b2tYWlRtMWsyclltRUlIZFNyWGlWaGtkbXkyazI0Nm9zOVZzeXlYWU9uektL?=
 =?utf-8?B?WU1KVS9RQjI4bWQ3S3BudWpBRVQ2QXA0RGQ1UktiTVEzVUNQMGlReXBSYlc2?=
 =?utf-8?B?T3I4UTZYeGl5dnl2R1BDNVNTR29uTHZwODVPbXNFUzBkZWRlWU4zdXMrYWdU?=
 =?utf-8?B?cDI5dXl6RlN0eEtmVWpxWXd0MUFQQkxCWFVFWTYxQkk2WHJoVW5oODA1bWFT?=
 =?utf-8?B?UlNjSEEvdWVJbldSZXZKVFFDL0tsTUVvRGJwaElsZk1WMVYzK3EvVklKN3pD?=
 =?utf-8?B?RFArMWRNQUdlNG5wdEFHblduK1NsZ2orL0ZPamZNdmt6SFJCaVhYSnR5eisy?=
 =?utf-8?B?RU5nVE92eGNkODhjY3BDbmx1K05aK3NGMi9CTzVpN1RpeXIwb2ZoNWx1ZStv?=
 =?utf-8?B?aGxPN2FZQWREbkMzckoxdkg1aytaS2Yydzd2aHEzc2hTMGF2Mkd3eUVUbFpk?=
 =?utf-8?B?TnU5VytHbXNrNUhZQ1Fla0R5TGJ6SCtnb2dTbnBieU9DYlJudTJSR0JUaHlB?=
 =?utf-8?B?T0FTdnhsTGlOWmZuZlhMemNPMWphWDNBekRtY21DNlpSS0V2TnArWGl3Rjd2?=
 =?utf-8?B?dm85bTNmUmVYUi9TTEg2SDVyZ2V3MDhHbzdaSXptQmo0WnFmRGRYS3dYME9V?=
 =?utf-8?B?d29aTkhRUEExcVpwbndLOWQ2dndoL2pTRDFNL3E1NVB6dFpwa3JJYWRmbGpK?=
 =?utf-8?B?T21ZbmF0ZFJ5TG0wR1pNbmVpWk10UWlvSEk0MXVHbFlBQ2FEVEsrRzdORW5v?=
 =?utf-8?B?OUlhd0dHRnFCekExUHM4TkRNVEV2a0NFNEJWcFByZTJVcEtCcklYUDUxNE5p?=
 =?utf-8?B?NWoyQjRlaW1hcnE3c09qZWtpUTRIMjRjVlQvQnJmZktZVzI2R3Z5UTBEajFU?=
 =?utf-8?B?WTJoV09FdVBYbmgvcGJQVDN6eGxDUXFPTGRYTElGVGw2bzd6elh5WDA2WmRN?=
 =?utf-8?B?WXk2T0pBOVkrVUxZSm1sb0JFQ1FjTXVrcG4wMjF6SVRsWDlBWW5BVko4Y2Rj?=
 =?utf-8?B?ci9xQkZxUWk5TEFhNndmVXlCdE52S2lIVWFvOHZxb2R5YUI5dUdtbUFISTNC?=
 =?utf-8?B?VVM4SlNyTHhLdlVORkxoVnEzVTNpZ2VDMlgwbVZmTHkrcmtrcVJpSnd5N2dh?=
 =?utf-8?B?SEpJcFFvY010TW1YbzJBOGZIMGpvaHVhSWFjWlNOOGZQMjJhVmpxV0hYOUtn?=
 =?utf-8?B?L2ZJVFh5UTVlL1FZVEp2SGlVUm1oOVdUeTZpMHcxd0NLRGMwaHA3WjZtYXZD?=
 =?utf-8?B?WG1yS1hpVHZhWmplWERWVGg4R3ZwRzAyaXVwZzU2Z3VGV2ZhNDFudlYvd1hU?=
 =?utf-8?B?OSt4blZhbGtiSy8wSHVDVnBGUjZiejRPUVdpWXUrcGVRVlcrUUUzazhUVmlu?=
 =?utf-8?B?SlJqYUpwVXMzOTZZM1BYL2s5UHlGQmNBdzJaZWwzQU83STQ5a0wySVN4QUwv?=
 =?utf-8?B?TWQwd2w0QUM3STZvR2kwbFhEc3JZQ045cDA2TmR6dDZ3Z0NzSStxRHJkRGIv?=
 =?utf-8?B?eUgvNmJzcE5sTTUvbUNtSklPd2JGeHJEOG43Z2VhUjR3S0NHdllBVmRnMml0?=
 =?utf-8?B?VEFFYnBDYTk5a1dxN2k3MHZyNTFRRWJWc2U4eWVNN3JwbmY4ZXBFQzVtekRC?=
 =?utf-8?B?K3pqUm8rZVpIWWpsY0NYb1h3aUpkSUIyWWpwT0tmcU0wSEtWTjFqRm5BeE5V?=
 =?utf-8?B?N1F5R1NFMmZmQ2lMcDZ2ZWFWY1NDTUlLVlo5Qm4yclRHNGJkQURYSmdQT1NT?=
 =?utf-8?B?YnVTNDVscnFhN3YxNUErK2NXdVNPMDdqd2EwakdTcmFVS0hjRU9mbDNLek9I?=
 =?utf-8?B?SmVJRW9nSk5NeENXbzNHU1ZRVXViSlBvcG8zby9TcnJnOXdCM0paVm9Sc3FK?=
 =?utf-8?Q?4SuGF6?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <100BC7491FEC64448ADC67726D25FB08@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9377
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bfc4e253-40e9-4d7e-6e24-08de4ed63551
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|35042699022|36860700013|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDRZb0RDSWZyeHhxL2N4YU9WbnNiNkxFOUVXVFZackRndTlRcFM5Y2tjeGRq?=
 =?utf-8?B?WHNMVnZFU2F2Zm5jb3NHbTh0bTZDZVlQSVFxNklaS0dGNWRJRzRVTlpjQ2Mx?=
 =?utf-8?B?Yy8rRVg0VHcvYVJLZzRWYk1MWkRFenZ0SmxrT3hYc2VYa3hURnFIVVdEazh6?=
 =?utf-8?B?RjNuSXZNNWQ5eTRhN1MrS1ROK0tvOG9kTmxrSnhKM3hlNWxmVlRTQ1k5VEY2?=
 =?utf-8?B?bGloS2tvYmt3MmFpVjFTSlN4NEZyNXNEZWwwSzN5MUUzc3JibVpwTDVVbU5W?=
 =?utf-8?B?TExtRlNlSytRNFE4TkhxNHlJYWtDVXJHUU9nbXZaUEJUTHp6Z3g4T1k2dkMw?=
 =?utf-8?B?bmlsd0xrSGVhTUdzd3VyaXM2dkJTZ2FFaUowMjNGT3BwbCtYejNXM1g2QjM2?=
 =?utf-8?B?cWQzVHhPVENTSk94OVdHaFZBUjZ5Q2NlNnpnNTdhcjhYUWRsMUhPcTZ4SU00?=
 =?utf-8?B?ekJ1cnBPb0ZxeDRLSnAwdW4vM2tIQ25GQ2hFS0JnUXhIc3FNYkN6UUlEaE5T?=
 =?utf-8?B?UWdaU1ZtZWZwMWRodjZEUmtQc2ZoZFdXQXRJdEdoU2JVUUFROC9oOW9DaGZl?=
 =?utf-8?B?bGRUZk4xVks1eEFEWkt0cUkzSzJNM0MzbGE1TXkyVVVxUkpMK3h1b2hNRmV4?=
 =?utf-8?B?c2FIQUozcDZVUlV3SGVTSnNtL0tnQ1VzVFg4TU5SelJoeldSWml2WTNVcGpj?=
 =?utf-8?B?aEdRQzVxQkcwUnNjNmswcURqbWcvWk5xYlR3UDFrZlNzOHBvcnBjcy9MdGJX?=
 =?utf-8?B?VnM3a3Z4L0p0NE9HNVFkZEMyejNvRVA5TXRIYkhNaWR3QXlrZzN3U1l5OUJS?=
 =?utf-8?B?cHF6WDRUa3JScHJqejZYa2dJWVpxNHlydVd4ckRiTmdLcUp6M1JEWVErTy9s?=
 =?utf-8?B?NEpKcFE1MzhMV1JBSUpzTExwMlBKQnY3WUl0YXhKUi82WDAwNCtFS3p1bE9q?=
 =?utf-8?B?RHlRd084NEJqOVA0alBXNnE3Rmx0d0xFSTBncGFEc1BIaktlWU1ZY0Z4bWtZ?=
 =?utf-8?B?MHNHR2xtZmZEb01rcXNueHFSSm1VL0NSdnJUQmVXSGVYR09EN0xEREF6RWVG?=
 =?utf-8?B?Y1Z2VU8zc1BTVG5qUVQrZzg2YVB0UUNjaDFNUDQ1UXV1U1YyYkxINFpIVVFK?=
 =?utf-8?B?bHNPRkRPenI0RUZhaWpFRXlwTjBhYnVQdnhVdFlQMzJoL2VBUGhKV2RTVGwy?=
 =?utf-8?B?Q3VOcmdZVHpoeERqditUcVhleEk0TnlzeGRWYmFGMWd3MEUxd3BibUdkS04y?=
 =?utf-8?B?N2hWSy94NThnZC9MN1F3dkhJNW1DakgweTBsaW1rT3lXWHpCUnowQ25rT1Vj?=
 =?utf-8?B?dlh2M2tycExlN2NBRWVLWG5rQWJxVHhpem5SUCtwR1VEUksyZkozVjVkTlFI?=
 =?utf-8?B?KzlRTFZJWU9vOGpVbDB3UWRmdmUrcWM0UkZGQ2NHQlJFVFI3YXQrTVBoQk16?=
 =?utf-8?B?ZWkveVdlQnRkbDdmWEJMaDhwajFOY3BHWmZsOHpsaTNnSEh2WDZYaUpGdkk4?=
 =?utf-8?B?STZzQS9XWWVmcWFDUTlTZ3lmWStQL05ZK1AraXZhL1h6NnJ0K2J5RWY5N1RI?=
 =?utf-8?B?OE9FSDFZV0tINCtMdE0vdkcvQ2F6NlBMWlNpQndPWWZ3c3dIbnptLzlNalRY?=
 =?utf-8?B?UmxVbXE2aytuYVh0blM5eVV2QUpsWEFySHI2ZnBoeE1UbjJMQTJzMkhZMmRl?=
 =?utf-8?B?UkUwWlpGYVptRm5MMzhreHF0VVduemxHVnp5bSs4bW1ZNjY5SHdrTzVyQXF5?=
 =?utf-8?B?YUJ6Y1VmY2QwTko4dmRCajhLWW1sZUZ1YzZjSlJqcXFvQnRCZ0RvRE9DbFVq?=
 =?utf-8?B?QzYrOEo3UVVlU1JVczdDZnkwN05QYTZGc1I1aVdMTmdad0lnS3JJZ0lid2Jx?=
 =?utf-8?B?bTZjaFBrMGlvS1BTSFZNUVVWUndsOVdlc2dGZTBEN2RtL21hOUFVeVFaMkRD?=
 =?utf-8?B?cWl1RHdSWkJuR0JQcDlFUWxYYm8zWEpmeDM3UWtUU0pPVm94b1VHcTMvdHFZ?=
 =?utf-8?B?cmpEODh2c1NmWm1ENkJXb3A4WGV4N0Rjb0dyU0xrN2Jhb0JaN2pwYVpuV3Zo?=
 =?utf-8?B?MCtYOGJtaGFqelRlWnhDTklnbWJYbXNoakVVOCs0aW5RUzEySmQ2ai9vMmNs?=
 =?utf-8?Q?CaL8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(35042699022)(36860700013)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:53:18.6360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4054d9-b35b-4657-dada-08de4ed66cbc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8045

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE1OjA4ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQzICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBXZSBvbmx5IHdhbnQg
dG8gZXhwb3NlIGEgc3Vic2V0IG9mIHRoZSBQUElzIHRvIGEgZ3Vlc3QuIElmIGEgUFBJDQo+ID4g
ZG9lcw0KPiA+IG5vdCBoYXZlIGFuIG93bmVyLCBpdCBpcyBub3QgYmVpbmcgYWN0aXZlbHkgZHJp
dmVuIGJ5IGEgZGV2aWNlLiBUaGUNCj4gPiBTV19QUEkgaXMgYSBzcGVjaWFsIGNhc2UsIGFzIGl0
IGlzIGxpa2VseSBmb3IgdXNlcnNwYWNlIHRvIHdpc2ggdG8NCj4gPiBpbmplY3QgdGhhdC4NCj4g
PiANCj4gPiBUaGVyZWZvcmUsIGp1c3QgcHJpb3IgdG8gcnVubmluZyB0aGUgZ3Vlc3QgZm9yIHRo
ZSBmaXJzdCB0aW1lLCB3ZQ0KPiA+IG5lZWQNCj4gPiB0byBmaW5hbGl6ZSB0aGUgUFBJcy4gQSBt
YXNrIGlzIGdlbmVyYXRlZCB3aGljaCwgd2hlbiBjb21iaW5lZCB3aXRoDQo+ID4gdHJhcHBpbmcg
YSBndWVzdCdzIFBQSSBhY2Nlc3NlcywgYWxsb3dzIGZvciB0aGUgZ3Vlc3QncyB2aWV3IG9mIHRo
ZQ0KPiA+IFBQSSB0byBiZSBmaWx0ZXJlZC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNj
aGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gTWlub3Igc3VnZ2Vz
dGlvbiBpbmxpbmUuIEVpdGhlciB3YXkNCj4gDQo+IFJldmlld2VkLWJ5OiBKb25hdGhhbiBDYW1l
cm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+DQo+IA0KPiA+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLXY1LmMNCj4gPiBpbmRleCBjN2VjYzRmNDBiMWU1Li5mMWZhNjNlNjdjMWY2IDEwMDY0NA0K
PiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysrIGIvYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtODEsNiArODEsNjYgQEAgc3RhdGljIHUz
Mg0KPiA+IHZnaWNfdjVfZ2V0X2VmZmVjdGl2ZV9wcmlvcml0eV9tYXNrKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gPiDCoAlyZXR1cm4gcHJpb3JpdHlfbWFzazsNCj4gPiDCoH0NCj4gPiDCoA0K
PiA+ICtzdGF0aWMgaW50IHZnaWNfdjVfZmluYWxpemVfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KQ0KPiA+ICt7DQo+ID4gKwlpZiAoIXBwaV9jYXBzKQ0KPiA+ICsJCXJldHVybiAtRU5YSU87
DQo+ID4gKw0KPiA+ICsJdmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1LnZnaWNfcHBpX21hc2tb
MF0gPSAwOw0KPiA+ICsJdmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1LnZnaWNfcHBpX21hc2tb
MV0gPSAwOw0KPiA+ICsJdmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1LnZnaWNfcHBpX2htclsw
XSA9IDA7DQo+ID4gKwl2Y3B1LT5hcmNoLnZnaWNfY3B1LnZnaWNfdjUudmdpY19wcGlfaG1yWzFd
ID0gMDsNCj4gPiArCWZvciAoaW50IGkgPSAwOyBpIDwgVkdJQ19WNV9OUl9QUklWQVRFX0lSUVM7
ICsraSkgew0KPiA+ICsJCWludCByZWcgPSBpIC8gNjQ7DQo+ID4gKwkJdTY0IGJpdCA9IEJJVF9V
TEwoaSAlIDY0KTsNCj4gPiArCQlzdHJ1Y3QgdmdpY19pcnEgKmlycSA9ICZ2Y3B1LQ0KPiA+ID5h
cmNoLnZnaWNfY3B1LnByaXZhdGVfaXJxc1tpXTsNCj4gPiArDQo+ID4gKwkJcmF3X3NwaW5fbG9j
aygmaXJxLT5pcnFfbG9jayk7DQo+ID4gKw0KPiBBIGxpdHRsZSBuaWNlciBwZXJoYXBzIHdpdGg6
DQo+IAkJZ3VhcmQocmF3X3NwaW5fbG9jaygmaXJxLT5pcnFfbG9jayk7DQoNCkhhcmRlciB0byBi
cmVhayBpbiB0aGUgZnV0dXJlIHRvby4gRG9uZS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gPiAr
CQkvKg0KPiA+ICsJCSAqIFdlIG9ubHkgZXhwb3NlIFBQSXMgd2l0aCBhbiBvd25lciBvciB0aHcg
U1dfUFBJDQo+ID4gdG8NCj4gPiArCQkgKiB0aGUgZ3Vlc3QuDQo+ID4gKwkJICovDQo+ID4gKwkJ
aWYgKCFpcnEtPm93bmVyICYmIGlycS0+aW50aWQgPT0gR0lDVjVfU1dfUFBJKQ0KPiA+ICsJCQln
b3RvIHVubG9jazsNCj4gYW5kDQo+IAkJCWNvbnRpbnVlOw0KPiA+ICsNCj4gPiArCQkvKg0KPiA+
ICsJCSAqIElmIHRoZSBQUEkgaXNuJ3QgaW1wbGVtZW50ZWQsIHdlIGNhbid0IHBhc3MgaXQNCj4g
PiArCQkgKiB0aHJvdWdoIHRvIGEgZ3Vlc3QgYW55aG93Lg0KPiA+ICsJCSAqLw0KPiA+ICsJCWlm
ICghKHBwaV9jYXBzLT5pbXBsX3BwaV9tYXNrW3JlZ10gJiBiaXQpKQ0KPiA+ICsJCQlnb3RvIHVu
bG9jazsNCj4gYW5kDQo+IAkJCWNvbnRpbnVlOw0KPiA+ICsNCj4gPiArCQl2Y3B1LT5hcmNoLnZn
aWNfY3B1LnZnaWNfdjUudmdpY19wcGlfbWFza1tyZWddIHw9DQo+ID4gYml0Ow0KPiA+ICsNCj4g
PiArCQlpZiAoaXJxLT5jb25maWcgPT0gVkdJQ19DT05GSUdfTEVWRUwpDQo+ID4gKwkJCXZjcHUt
DQo+ID4gPmFyY2gudmdpY19jcHUudmdpY192NS52Z2ljX3BwaV9obXJbcmVnXSB8PSBiaXQ7DQo+
ID4gKw0KPiA+ICt1bmxvY2s6DQo+ID4gKwkJcmF3X3NwaW5fdW5sb2NrKCZpcnEtPmlycV9sb2Nr
KTsNCj4gVGhlbiB0aGUgbGFiZWwgYW5kIHVubG9jayBjYW4gZ28gYXdheS4NCj4gDQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gDQoNCg==

