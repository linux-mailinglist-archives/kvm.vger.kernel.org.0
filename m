Return-Path: <kvm+bounces-67376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF7AD03327
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 14:57:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7AB6831A2F27
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 13:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF59C4DE932;
	Thu,  8 Jan 2026 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I+PuuObJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I+PuuObJ"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011030.outbound.protection.outlook.com [40.107.130.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D43A3EFD16
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767879616; cv=fail; b=PCqDXAgi+bS/GZJwXYTHrV87zq41ZXOWKFhHHmXKr32jwO1hVii1n980NPcUe4ttjy65ZVzGtdXmXl12CKJNKVFXgnkIoxqYMY9g/rqXuJrHDAY2L6HFm+JbrInl9RfY1PKXyXUg12FlyswSf0VuqdrkfNWgKUacHJ2O9kmjjE0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767879616; c=relaxed/simple;
	bh=pI5jqofn8kXnoNO3z2JST5I9HcIW9YBvy6xWbqR+N38=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=agPHoyhFEcxxPOQqFoa7c9zAQQG2B1NOYAknZSxxBEaYCIz7THuUXGOdp7ibjJ8Sk4CMW5L13jx0jmJ3LiOos8yX5884b5KGI9Zt/0mE36gIq/mInf8QBaBp7bzpWcWnsY865vvccDeLpJZgFYpsGMbfBKB/EaDLZuFvIp898Fw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I+PuuObJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I+PuuObJ; arc=fail smtp.client-ip=40.107.130.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=owreGmTwLiYj1YLec9mk8/zoiw2D/H3AkRdogh3mnYuR8aykAtbJKM6FOHQ5ttwex9v3hxkwpQYrvkk3Cr5LBl3mC8RuNEgW0wJUK+ZL8iZKbCuwrv7T0e9EMIp2cRVxCx1hxfGQHNDozsJ/65PkEp2EeIR08/2ItR4YTju/L4YyVsakz/3pq045TuA1LVtM1OH5fvv9+Veo6aNgofwEZx03yI+6fF7OI+vhbdzQnmX4tKqVJ4jAgLsCSU2weNPc0oTULC1yBTM9AYdpnkU5i6qQ9RULR7TePY5qGzFPNeexG2BdK45Sg07SljonITUGsHbUrhSiPkaEsdpfUrIYIw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pI5jqofn8kXnoNO3z2JST5I9HcIW9YBvy6xWbqR+N38=;
 b=LzET5JceA7uy1pbTqDQyFrjiXBBqcR9FrTF5FqFNHWHnquMoALc7o5jBq+sAUnds9JKm1OfbzNZbj8LChZuIZMCbL0ZsI0lNS/E+vWlTs08D1fgacXHngT+ElC2+2/0HXmTp3tI/xc2AQGOPey7660xvknvjDf5nk76yLl60yT1jsLlV66n3ip+e7u5PQGyBpKIDqWQfCRqhrCeQALoLs7R1Ry/LrKQkIJAZLYfE4XoBNzn4GJzugtJvIcGxFvBMy7y7y7Xccu9x4xh/M6EyvE4Fjn8LV5244FHSINr1dHfyrh8V8Oas8ElIBwCRFKdHqzneYzYadl5ZmnyZ9dFgsA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pI5jqofn8kXnoNO3z2JST5I9HcIW9YBvy6xWbqR+N38=;
 b=I+PuuObJSNOWFLXyi7yTTagFa0BrHMsmW+oyOhHTXCFpAYo08HGUKuKsfElyn6LZmKPbmtgw1upIAGQ23Ng1Dx/O/Unj0KrlY3KUQdUj+1F/GaOXEDlaDrIhalSyAHhe7LXfS/ZmVXK5zz+ijOt5ziSx8uOpuDUIZQUr/E8+Ob0=
Received: from DU2PR04CA0275.eurprd04.prod.outlook.com (2603:10a6:10:28c::10)
 by DU2PR08MB10188.eurprd08.prod.outlook.com (2603:10a6:10:46f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 13:40:08 +0000
Received: from DU6PEPF0000A7E1.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::60) by DU2PR04CA0275.outlook.office365.com
 (2603:10a6:10:28c::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.5 via Frontend Transport; Thu, 8
 Jan 2026 13:39:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E1.mail.protection.outlook.com (10.167.8.40) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via
 Frontend Transport; Thu, 8 Jan 2026 13:40:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3EsTbaUP3m4W2Bb8WaFUbQONMZ+M+k4qFyj/e6goJgLqRi1Hvk+qnH4Di1+DG5o1U8Axn79GEd6rc+TYMyhlSX+zMEdJ7lQOtmz4ZnqVRJLYvKb+/DwPBNZBVvyFnOk05Hv2Q5GCsU0D+xn37SfguEXrSqGIrFRj77nBkUJjAAxX7nISko18na++m0w6KGCZqgCuwBJDXYT7UpZNxS3I4U1pYZW7FCD4OEs7bGxPkMWw8UQhahvjvg7AIWYl0FyHjFRpsw7b2IhLgHaueXdq/kwZ8c9YE8SNHVSE6kLupE7AWRHbYIBdqZTEka835k7ShSsamqrrglr+Vf94HJx6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pI5jqofn8kXnoNO3z2JST5I9HcIW9YBvy6xWbqR+N38=;
 b=uDN+hScXbLs83TrG8cXSrSObtvZZWS37VR5y8AnB8eCqzJPFS2CjSnMKKnNyWLRbjj8VkWO64w1rTWU/0mtJsDHQQQnzWCmMKvluXekSRR+HlC3irZ+zgWw6wq/xnsY5PsjBY+Q8CDF4wvhtBKWnUInGvfh38fyxtlZ/CEa7PoLATRdsezt3lyfd+QAygKV9V4qQe/3ZYJvDNBHsQ7Zgph5Cj5KoXDdBlTT/HfX3p550fctQn0whfdzlRIAVY5AnhC1rg9UdKwRsQQEFlPeG4MJ+F2osAXp8c71kLuShstsqCsj0wt7pM4FAsoo5Sdxg6wG2AlAxv6E9uGqHVNgqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pI5jqofn8kXnoNO3z2JST5I9HcIW9YBvy6xWbqR+N38=;
 b=I+PuuObJSNOWFLXyi7yTTagFa0BrHMsmW+oyOhHTXCFpAYo08HGUKuKsfElyn6LZmKPbmtgw1upIAGQ23Ng1Dx/O/Unj0KrlY3KUQdUj+1F/GaOXEDlaDrIhalSyAHhe7LXfS/ZmVXK5zz+ijOt5ziSx8uOpuDUIZQUr/E8+Ob0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA6PR08MB10624.eurprd08.prod.outlook.com (2603:10a6:102:3d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 13:39:06 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 13:39:05 +0000
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
Subject: Re: [PATCH v2 13/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Topic: [PATCH v2 13/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Index: AQHccP+Bre8XGF01UEabuPk2JDO6jrVGrn2AgAG30gA=
Date: Thu, 8 Jan 2026 13:39:05 +0000
Message-ID: <fd91d97795f135d6c130e799371eb7ed89851b06.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-14-sascha.bischoff@arm.com>
	 <20260107112453.00004fb9@huawei.com>
In-Reply-To: <20260107112453.00004fb9@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PA6PR08MB10624:EE_|DU6PEPF0000A7E1:EE_|DU2PR08MB10188:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e558725-81b9-4deb-6af4-08de4ebb7082
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?WXV3ZnpOWlpxYWVDVkRFZ0o5anlVc1VOZUI2NDNLSGZSM0U0U29kZElGQ1Zm?=
 =?utf-8?B?Q2crNTI2emJFdVdaZUt5bThWWk4rYUtydDFQVEZjMWt1d1kzMHVEM2FSUkxF?=
 =?utf-8?B?TzdxbmhBcHhJWG5pc2x4bnVVR0ZpNDQ1M05aT2RvdytlY1ZQL2ZKOGFxcEM3?=
 =?utf-8?B?cmJmV2JJU3M3VDQ3ZUcrZzFRNzJGOEVoWnErcFJNYmJVaUZYUFowOUVmV05p?=
 =?utf-8?B?UXpMVFNWbzJxTUFpSTArOW8rNWlIblhRazVRV1BMSkdhb2cvZzNZMmVaelZm?=
 =?utf-8?B?S212N1p5OVJIcGJTNk9WMFRPSGZjSVFMUDJpK29uaHM4ZE9Qa2MvZFJ0aTB2?=
 =?utf-8?B?YzExbW1WY2QyNGo2WnUwc0tVNDZXVDBsSnRGOTdFc2h6S0ZFeTJTSmExQ2E5?=
 =?utf-8?B?bFRWdGw0aWZwVWc2MGpocWN5RHRuL1BjOWV3MlRxNW5pcFg2Wm5EYlZRcG5D?=
 =?utf-8?B?WHFGekl2SVFBeWZvelNZYk1vdEpxZTNta1UydU5KUnlwaDIzQWJ4Y0hGVUMz?=
 =?utf-8?B?TkQxK1p6SitkN1c4MHBlK0g3bXB2T252SlFvUTM2T2FmdEVCNlFwSVRONVho?=
 =?utf-8?B?TUVrVWJCUUhaUWNnS3R0OVBFWlNqUUJiSnlIOTdwalhHd3ExR1FNby9HSVBO?=
 =?utf-8?B?YUZQVjErK3NSTkQzdUJXR1Y4blNpOXBucDIvL1B6QTRZaTVPNW43QkhPeWdR?=
 =?utf-8?B?YVBCU2QvY055ek1DV2g1K1ZRRk5ZSnVYc0xYWVFFZHdkenk3ZEJQNFI0ZU55?=
 =?utf-8?B?VmRsOERuNlFBSGVoTGxWQ2RtZ0tBOU5KVFMyOFYyaDI4Q0hZNkpVdFFhRGRS?=
 =?utf-8?B?YysrK3JBSWdiOUNFcjVtT1BweFFibHh5NjlwQ3M1M2VZY21SVnhSWjhlbGdE?=
 =?utf-8?B?aUZGZk5MdnJCUjNzTXZ0Y0IyS2xQbGo5cG0zYVVLVVdyTlBsb0ZlWkdyaUFZ?=
 =?utf-8?B?eWtKUzNBVXFicythY290VnRqOW03cWVZbVJraE80dm4ybnhKRUpkQ1cva1By?=
 =?utf-8?B?ek9SZElCWHBkaDNEa2Z3YXNZeTJjSDZkaDdmNVVTOGRjZ2srZWc4K3ltYkNN?=
 =?utf-8?B?K203bExDR2F4QUdFQU1HbmFnQnJ6d2RheVBubTBmWm9xZUxzR3p0SG1hS3E3?=
 =?utf-8?B?NnZwQmQ2c1MxRDd5YW5NU3VzS29GWkozZXByNHh6bzFlcVRqQjhGT1NUOURI?=
 =?utf-8?B?TFJRS1E5VnJmeUxSZXlwWnprblEzWVpwNkovQjA0cjE1Si9uaTFGNFFsUkE0?=
 =?utf-8?B?b2VLSm5MeEx6bE1Id1NtRVFUaTgxSkRLNkNsOGVtT3U2MlJ1dncwMFZwRzFR?=
 =?utf-8?B?RTBHdEJsazB5bDFtWEgrUFZRY2pKMlVXbzZQZDZVTFplVWlicU5tWW5LejVO?=
 =?utf-8?B?NEwzOS9rd1ZsS043aG10QzE4eVNEUndJRjhlSTNRK0tPUXY3NmNDV0pUb1lt?=
 =?utf-8?B?c1hvTFFJSmk0U2NUMTVWUmF0WFI5NitRMW9jbTRHZUl3YWFYeHhQdGZ5c2N5?=
 =?utf-8?B?Ry9sdnJ1KytvOVpPb2l1b3VDbmkvTnRveWtZdUVRWEgxWDdoUldLMFBPOWxE?=
 =?utf-8?B?MVhsbnMzMWlxUWlmTFBCaVRhcmRhb3pQdmgwcFBFRVFrZG9FTmxnczU1Uk5m?=
 =?utf-8?B?WHJJZ2wwQll6a3FLQ2pqZXg0dGFZU0hrNU9nOUlJdjl3VlZYNjR2MncrQkJi?=
 =?utf-8?B?WTlsVkdKeTBJbkpIWXZ1OThCMlY4cWtvaEJFSDEydFF0MEF3TmtlOEtsaFlH?=
 =?utf-8?B?cERJN0dWSWxvS2JnWm9PNGtaa3JGcmRtNGNzWFowTkw5V253cTJLNnl1VlQw?=
 =?utf-8?B?eitWMUZEUmlhbWQ3NFlLK1czSDc3NGdqWDVhMjdIQXZkUmNFNTF6ZVVsdmgz?=
 =?utf-8?B?VVR6cEtzRTdmanhEQXY1dEVrd1FmZHlDZlJqK2NxZDdXanEwK2VNd200cjhN?=
 =?utf-8?B?c3lnQVZhWUNHRHRkN1pWaTRwa0pZQUhBUnlOVXRyMlhSeC9nVzVsakxyT0o3?=
 =?utf-8?B?K3hLSm9PQmpEd0Q0ZThUb2Roc05wNUh3SnlDUnpaU2ZnV1lYZzVXUCtGUEU2?=
 =?utf-8?Q?7HErFO?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <72D349C37EECCC4D878ADF54BC7CBAB8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10624
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ec0b9e8c-6703-406b-472f-08de4ebb4b0b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|35042699022|82310400026|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2t5K0d5TURHdEs3UkN5Q2k0OW51cytxMTNkWWZoTWswTkJ4eElrOEtFc2VB?=
 =?utf-8?B?eXd4MDdIeS9xbVdFQ0g5NEc4MDF2YXMvdWVxcjkyMnQvZHNHRmQxVmMvT2cv?=
 =?utf-8?B?czJUY0JtVFpwQ0VCNUw5Wjk5MHl3UkFvdDVBSWlOMFBSNjhXY2JTZXJJS25U?=
 =?utf-8?B?amJYY1FYa21yTnM4V3prSVlWMVFsMm51M0VYWWE0S045OGlIN0ljS0pjUm1B?=
 =?utf-8?B?bWtTbWk3RHovZ3Q2UmpickxBK2V4aGN0M3dzaElEbC8xRWx5YitPZFBsbHc2?=
 =?utf-8?B?T2dHMzhPWFZqd3YxTWlJSUZFSHVWQUROMllXL0NncmhNeUkrcGRVeHlQSmhF?=
 =?utf-8?B?VnBFdXdCQ0ZDVC84bzV4M1pSQ1JPdEYranY1WEJvUk91eG1SMGpkRXR3bkpQ?=
 =?utf-8?B?KzJDc0dxRHovckVFTHJtRWFYVjhkbDFMWVZpeDQ0Q0FBa0ZVbGRvMWpQNWhW?=
 =?utf-8?B?dzVjV3hhSGNoeDVpdTBDNVlmU2NnMnpuZTNBNUlFWnNFNy82YUp4cDBKSUc0?=
 =?utf-8?B?UUNQN3RRdng0SVlrWkRzTDVrQU03MlBnc3R0MFhLeEVSdGFQb2JGaUxnMndx?=
 =?utf-8?B?NEFRNW5Hb2ZUeDZXUHV5SmNEWDdzUzU2bm0vYnBKZGxYOENyRjFxZm9aeEk5?=
 =?utf-8?B?V0VyN3hKaEtqelhSOFM0ckxvNTYzSHNxUVR4K1RjOTJzdlQyN2F5Vmk1SmpT?=
 =?utf-8?B?M2szTnZoSlluS2dwa3Fjc0p2VjNwc0l1RjRpdkE1NS9wWjE0MTlnSnFsRWIy?=
 =?utf-8?B?L010bnUxSG03ZVdncjQvbmgxa1R1QWRGL21USHFYQmYvci9XK2NRcmQ4NkRt?=
 =?utf-8?B?ZnBoUVlPbmd5UTF1cjEzYkRiR2VURktST1lwc0pZdVlwU2FqL1MvWEtTMjAy?=
 =?utf-8?B?UUNpQjhKNVp6Q0w0Tko3ZG5tL05XbzYyTW1NaUpoZ3N6YmFxOVk5NGF6WkxI?=
 =?utf-8?B?ZTZVRnZMckhOQnhPMmwyZUxSLzJPY2RGYTJtNEQ0ZVQ3US94TXBKS3Y2dWM3?=
 =?utf-8?B?bE5HNXV5T2o3bXpESlpHRE5RbEFFbko0dEtzR0FEQld2R1VRTXBCTVNYODlY?=
 =?utf-8?B?bWhFZXpTM2VOeG50NUNGTlpxVzBSUHh2cllldG12SzBPWHA3L3llV3J6TXox?=
 =?utf-8?B?anBsN2t0VXFsR05DWStNb3NHcE9MSGZVUVphZ3l2cWdRdWFTMzFEdHpRM1Bs?=
 =?utf-8?B?UFp3UXFpZk1RajhSVm9TblM5UFNEV2tjM0N6UXdhV2RUWnh4UXF6VVZmMXU0?=
 =?utf-8?B?Mi9iSEQ0THNLZEl5UmQzUlkrOEVQTnZCdlVSVzNmR21rUlFTaDFzeGZqQW16?=
 =?utf-8?B?UGw5aW5TR2hwcXJqeWduQVUzZzJoZVl6VHUwbmYyWjh5UFNQLy8vNVI0T1JF?=
 =?utf-8?B?ZXJlaW50cDh6M0orSzZRbGJxMzZCWXdJRUo4WGM0STZGSy9QNEs1b2ZUeEVO?=
 =?utf-8?B?MHRRTWI5TWQ2bEQ5dFJsNWRzQ3hnNTE3VWZnb3NjYTk3VTlMM0FraSs3TnVL?=
 =?utf-8?B?WFVqSzB5bU5WS2pwQThsSnFWa1N6ekN6SnBWMzNWU0xRK1ZnWDNIa0V4N2dJ?=
 =?utf-8?B?ZnNpQk80UzJXUVRPTWZuY1Z2ZndtWlVJQW5UbmMvano5U1pkdDBMOFZzbHpp?=
 =?utf-8?B?VFZDWWtScUtEKzhPUENPTWNNWXdybC9JTVc3RXdmMnhIL2ladnpzNXgwNll3?=
 =?utf-8?B?anBOd2hPTGFYb1YvSmtDNjJTTWVPUGNseGw1ejZER255MlArengyVmpZZUJY?=
 =?utf-8?B?NVVnRGxvNFNzL1hPdGlpZzN2R01WWWZUR1E0S3dXUS9YZWZWMDU5Ty9ySnEy?=
 =?utf-8?B?SjMrYlRyRjdhaGdQSW9yUFNZVHdhekRZbHN6RHdhdE9OTDliL3Q0OWZLeUVG?=
 =?utf-8?B?cFZsb1U2cWZmc0VBejVKbVFUcHZQS3hVak5BaGtvWG1ZOVZBNWZLUUF5V1Ft?=
 =?utf-8?B?WXc4WmZ1ZWNKVjhpSHpDTTFIR2FocG5INXNIbHovaW5mWGpscnpkNENwcE9Y?=
 =?utf-8?B?V3dqRjk2bjc5UWdua1c5bEZydVVEK1BJSGlnRlk2aWJ1c013MlFRVFAvS2FH?=
 =?utf-8?B?ZXlTcnd1WTdkT0cxcG5YOVVvMkgrSURuN0VndUlJbC9OTFlIV3dBMStDL1Jz?=
 =?utf-8?Q?kj2Y=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(35042699022)(82310400026)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 13:40:08.5512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e558725-81b9-4deb-6af4-08de4ebb7082
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10188

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDExOjI0ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQwICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBEaWZmZXJlbnQgR0lD
IHR5cGVzIHJlcXVpcmUgdGhlIHByaXZhdGUgSVJRcyB0byBiZSBpbml0aWFsaXNlZA0KPiA+IGRp
ZmZlcmVudGx5LiBHSUN2NSBpcyB0aGUgY3VscHJpdCBhcyBpdCBzdXBwb3J0cyBib3RoIGEgZGlm
ZmVyZW50DQo+ID4gbnVtYmVyIG9mIHByaXZhdGUgSVJRcywgYW5kIGFsbCBvZiB0aGVzZSBhcmUg
UFBJcyAodGhlcmUgYXJlIG5vDQo+ID4gU0dJcykuIE1vcmVvdmVyLCBhcyBHSUN2NSB1c2VzIHRo
ZSB0b3AgYml0cyBvZiB0aGUgaW50ZXJydXB0IElEIHRvDQo+ID4gZW5jb2RlIHRoZSB0eXBlLCB0
aGUgaW50aWQgYWxzbyBuZWVkcyB0byBjb21wdXRlZCBkaWZmZXJlbnRseS4NCj4gPiANCj4gPiBV
cCB1bnRpbCBub3csIHRoZSBHSUMgbW9kZWwgaGFzIGJlZW4gc2V0IGFmdGVyIGluaXRpYWxpc2lu
ZyB0aGUNCj4gPiBwcml2YXRlIElSUXMgZm9yIGEgVkNQVS4gTW92ZSB0aGlzIGVhcmxpZXIgdG8g
ZW5zdXJlIHRoYXQgdGhlIEdJQw0KPiA+IG1vZGVsIGlzIGF2YWlsYWJsZSB3aGVuIGNvbmZpZ3Vy
aW5nIHRoZSBwcml2YXRlIElSUXMuDQo+IEhpIFNhc2NoYSwNCj4gDQo+IEdvb2QgdG8gbWVudGlv
biB5b3UgYXJlIG1vdmluZyBhIGJpdCBtb3JlIHRoYW4ganVzdCB0aGUgdHlwZQ0KPiBpbml0aWFs
aXphdGlvbi4NCg0KRG9uZS4NCg0KPiBPbmUgcXVlc3Rpb24gb24gd2hldGhlciBpdCBtYWtlcyBz
ZW5zZSB0byBtb3ZlDQo+IHZnaWNfZGlzdF9iYXNlIGlubGluZS4NCg0KSXQgZG9lc24ndC4gSXQg
aXMgYW4gYXJ0aWZhY3QgbGVmdCBvdmVyIGZyb20gcHJpc2luZyBvdXQgdGhlIFBQSQ0Kc3VwcG9y
dCBmcm9tIHRoZSByZXN0IG9mIHRoZSBHSUN2NSBzdXBwb3J0IChjb21pbmcgc29vbiksIGFuZCBh
Y3R1YWxseQ0KSSdtIHN1cmUgdGhhdCBpdCBpcyBub3QgbmVlZGVkIHRoZXJlIGFueW1vcmUgc28g
aGF2ZSBkcm9wcGVkIGl0Lg0KDQo+IA0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBC
aXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jIHwgMTIgKysrKysrLS0tLS0tDQo+ID4gwqAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+ID4gYi9hcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+ID4gaW5kZXggYzYwMmYyNGJhYjFiYi4uYmNjMmM3OWY3
ODMzYyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+
ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYw0KPiA+IEBAIC0xNDAsNiAr
MTQwLDEyIEBAIGludCBrdm1fdmdpY19jcmVhdGUoc3RydWN0IGt2bSAqa3ZtLCB1MzIgdHlwZSkN
Cj4gPiDCoAkJZ290byBvdXRfdW5sb2NrOw0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+ICsJa3ZtLT5h
cmNoLnZnaWMuaW5fa2VybmVsID0gdHJ1ZTsNCj4gPiArCWt2bS0+YXJjaC52Z2ljLnZnaWNfbW9k
ZWwgPSB0eXBlOw0KPiA+ICsJa3ZtLT5hcmNoLnZnaWMuaW1wbGVtZW50YXRpb25fcmV2ID0NCj4g
PiBLVk1fVkdJQ19JTVBfUkVWX0xBVEVTVDsNCj4gDQo+IE1vdmluZyB0aGVzZSBsb29rcyBmaW5l
Lg0KPiANCj4gPiArDQo+ID4gKwlrdm0tPmFyY2gudmdpYy52Z2ljX2Rpc3RfYmFzZSA9IFZHSUNf
QUREUl9VTkRFRjsNCj4gDQo+IERvZXMgdGhpcyBuZWVkIHRvIG1vdmU/wqANCj4gDQoNCkkndmUg
cmV2ZXJ0ZWQgdGhpcyBsaW5lIG9mIHRoZSBjaGFuZ2UuDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+
ID4gVGhlIHJlc3Qgb2YgdGhlICpiYXNlID0NCj4gc3R1ZmYgaXMgc3RpbGwgd2hlcmUgdGhpcyBj
b2RlIG9yaWdpbmFsbHkgY2FtZSBmcm9tLg0KPiBNaWdodCB3ZWxsIGJlIG5lY2Vzc2FyeSBidXQg
SSdkIGV4cGVjdCBhIGxpdHRsZSBpbiB0aGUgcGF0Y2gNCj4gZGVzY3JpcHRpb24gb24gd2h5Lg0K
PiANCj4gPiArDQo+ID4gwqAJa3ZtX2Zvcl9lYWNoX3ZjcHUoaSwgdmNwdSwga3ZtKSB7DQo+ID4g
wqAJCXJldCA9IHZnaWNfYWxsb2NhdGVfcHJpdmF0ZV9pcnFzX2xvY2tlZCh2Y3B1LA0KPiA+IHR5
cGUpOw0KPiA+IMKgCQlpZiAocmV0KQ0KPiA+IEBAIC0xNTYsMTIgKzE2Miw2IEBAIGludCBrdm1f
dmdpY19jcmVhdGUoc3RydWN0IGt2bSAqa3ZtLCB1MzIgdHlwZSkNCj4gPiDCoAkJZ290byBvdXRf
dW5sb2NrOw0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IC0Ja3ZtLT5hcmNoLnZnaWMuaW5fa2VybmVs
ID0gdHJ1ZTsNCj4gPiAtCWt2bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPSB0eXBlOw0KPiA+IC0J
a3ZtLT5hcmNoLnZnaWMuaW1wbGVtZW50YXRpb25fcmV2ID0NCj4gPiBLVk1fVkdJQ19JTVBfUkVW
X0xBVEVTVDsNCj4gPiAtDQo+ID4gLQlrdm0tPmFyY2gudmdpYy52Z2ljX2Rpc3RfYmFzZSA9IFZH
SUNfQUREUl9VTkRFRjsNCj4gPiAtDQo+ID4gwqAJYWE2NHBmcjAgPSBrdm1fcmVhZF92bV9pZF9y
ZWcoa3ZtLCBTWVNfSURfQUE2NFBGUjBfRUwxKSAmDQo+ID4gfklEX0FBNjRQRlIwX0VMMV9HSUM7
DQo+ID4gwqAJcGZyMSA9IGt2bV9yZWFkX3ZtX2lkX3JlZyhrdm0sIFNZU19JRF9QRlIxX0VMMSkg
Jg0KPiA+IH5JRF9QRlIxX0VMMV9HSUM7DQo+ID4gwqANCj4gDQoNCg==

