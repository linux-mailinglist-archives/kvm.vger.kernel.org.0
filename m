Return-Path: <kvm+bounces-68365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 11405D3840E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49AD6306024F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AE5381C4;
	Fri, 16 Jan 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HJo65F7y";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HJo65F7y"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010039.outbound.protection.outlook.com [52.101.84.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D9820DD52
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768587331; cv=fail; b=ElbxUHykNbXUvFtyS/AoNTFYFd5n5kAnplwQBF/JCNG5A0LGknYBSxBkSArHMJDn6XClsro6laj6d/hmCIDvkX2lE6kABjlwabAofN7i15KvfT65VjSWMV3BEiRtXi4QM3RIaTMOEWGu2vDkrlb8lRfjocz4GjUZoVddQIWyuqM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768587331; c=relaxed/simple;
	bh=9BGVG5gCV5scjFOeqMnVoVkZ2t9PohzNR3ybDCBoEKc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y9yvA5qxZZB7LyktUz16ic4pbPpm8v91P8wJ5nqCoLbdS0+GvFIg3LReZ9r3u3BfgTuZ96h84clEXz/8ScyWU3KIrzAYNq2m8+MUc6zzQev2ngTNI7LYgPI8wBbUyH3pcxNvuBYfC0xDRrMvp/aL0mNTAe1+rl0ehBGeHsd99fA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HJo65F7y; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HJo65F7y; arc=fail smtp.client-ip=52.101.84.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GXHi6K98qacuXmM7vcFP7RYEO8WCQy7YbaDq9XrPWWIR9wxMjvwknpS8ugGrvZTT4vqNhuSoJrDR1wM/U3Scyu/t8+hlfci2rgMZbe6F4kytp7/0XBbvvdDjRmC8/xgO5OMPhfv8cUTCC0I+UPPxBLZneQ+vz4tfX1p0wqIPski34GlzZkk0nFaZsUjI/xcgInr76lPY5YXzZyuSJdvabYwQx0iYkTGkd6ycivPH04/Z3rYCUbaTZGtgYKtP2UKs0REAxPexrJQyLyX1jqmlMUoi+yXQZ0vB/Bn6H09VhkPOFS7vYSEuju7xpdPCuqaDVyFz4I68cMvNVi2XvcUh7g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BGVG5gCV5scjFOeqMnVoVkZ2t9PohzNR3ybDCBoEKc=;
 b=d1cnj7jAJQWttyFS22izKOlcHRckwO5/dntCWDG5u0b7MNJVD2/oFmNBh3Chz0KXXAl5tATPNg6N5CfFXDqWPsn73HohN52yfg4e1RJjYpY8orjLpVv5CUFb5xb4n42OGVRGq4C1UqbXFGXhY/Rv+knggl4/E4smAO8PX3tsF1m3RR2rfYNdmWrd03IzwV1KKh5QwQ9xnvtOUpkF4xR3L/qLQPP1jjWDBnsnLomU2f8/CW4QdUT+2v30hpVqT03O8Y0P9jkyz2ajT4W9FfN3wYnTeFtZs4ppksOpsU0MXudgb0KoPCQYvtwMG7EEvqIGFetqvdiJAffD4KfwyDml2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BGVG5gCV5scjFOeqMnVoVkZ2t9PohzNR3ybDCBoEKc=;
 b=HJo65F7yEiEVwKuQMXo4vrstB5SZ1j5hnTROjeTM7iJRPtyF0oR15orWArWvRxojQiqBK2c79LZ9F1en+SwMBBlmXdP51aG6vkNxNaWnu8b2rSamVHKCVO6dj70exi8TdOzpmGOO5Q//7vqjV9Es5vZ0ArNIEkOl+hfWr7TlXoI=
Received: from AS4P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::9)
 by PAVPR08MB9698.eurprd08.prod.outlook.com (2603:10a6:102:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:15:23 +0000
Received: from AM3PEPF0000A78E.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::30) by AS4P190CA0023.outlook.office365.com
 (2603:10a6:20b:5d0::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:15:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78E.mail.protection.outlook.com (10.167.16.117) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:15:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a9C+XsWsQlEiSSr99Di3i62OxKqWw1lRPBOS09KEwOr1F7uq2hJBWYgSGiokGmnOFcUUNQbhwSBjsulF5iKpHsXd69xyOpSx/Efe0fpmJ8pYuZdcWgYKhdT2Vq7qZD44szcb29IbN3jx1ylDDpLSJA80HgrdZUZbq3nkSmxyrcQc9sI+d2LOgnPw7uuW39GotGzASzjr22fujFXfSuBjXN7AjCECjBtLH9apJduMDKr4WnGr23wq0ZVmAUVG6IsrqDfP2USqniP7oFnTcPVnhTpxI9UkQPVSDwL39vOeDU+4vFzoO2bm66OQ4r0lwSaROglciVa08IM7RSIpzXt9hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BGVG5gCV5scjFOeqMnVoVkZ2t9PohzNR3ybDCBoEKc=;
 b=vo0bD7QceCn1AxAiEVtPwrsVBXH1EEy62MxbKGBs/V8FT3sPoxmbCqYmMTZhxP3RQFLaor1YMQhiW1aXUJk6osDDMsqV5qG04ensfuWUv9/vml5kKGWybrQFU2tjn+fCZyJgv8PBxY/5Q5/lF1hICMdJTurQEr/X7CW3LhBSzqQgOTxpWY+vZS4mwjoUXNLUM9k7xs0TC+XVPqNHfn4u4RKNyX6uBD4Yd2Z/doqEBUvbO6KWp0CGBmHU0BfOsrx6O8TviJBRdEekYiBUaNiJGd6QDA/DaIs5SCA6j/7JIlnxhd402oFn+B9GJBtJ3fA00ZeRfKN/+KlcYr31RySBRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BGVG5gCV5scjFOeqMnVoVkZ2t9PohzNR3ybDCBoEKc=;
 b=HJo65F7yEiEVwKuQMXo4vrstB5SZ1j5hnTROjeTM7iJRPtyF0oR15orWArWvRxojQiqBK2c79LZ9F1en+SwMBBlmXdP51aG6vkNxNaWnu8b2rSamVHKCVO6dj70exi8TdOzpmGOO5Q//7vqjV9Es5vZ0ArNIEkOl+hfWr7TlXoI=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB8PR08MB5324.eurprd08.prod.outlook.com (2603:10a6:10:11e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:14:19 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:14:19 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v4 6/7] arm64: Generate HYP timer interrupt
 specifiers
Thread-Topic: [PATCH kvmtool v4 6/7] arm64: Generate HYP timer interrupt
 specifiers
Thread-Index: AQHcg6rlw/vdGJ6WwkuaeLV827+pgbVVIIeA
Date: Fri, 16 Jan 2026 18:14:19 +0000
Message-ID: <f477ae8c22f65f7f6a5f58aa8871e1ee354c5bda.camel@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
	 <20250924134511.4109935-7-andre.przywara@arm.com>
In-Reply-To: <20250924134511.4109935-7-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB8PR08MB5324:EE_|AM3PEPF0000A78E:EE_|PAVPR08MB9698:EE_
X-MS-Office365-Filtering-Correlation-Id: 629dff4b-e8cc-494f-4102-08de552b376d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aGpHbUhVeTFGSjRoS2xmYis5VWZmd0VnMlg1ZmlhYzAwUit0QXBpbkE3NzhK?=
 =?utf-8?B?YUZzY1FNT04wUk1zQjY0MmczTHR6MzVQd2k1M25GTVl2MHRyWGd6MjJaem1B?=
 =?utf-8?B?bXFIWXFzTjR0RWYrRjhPdUxjeGNHZzRoYUgxeEpQMG5oMXFObzZuR1pDOElF?=
 =?utf-8?B?RTJFbldjb0EvaVl2MEVLSmJvaXZQdTRNMmk3NE1FU1Z2R1hSZnFxNWg2OFZE?=
 =?utf-8?B?YWg2cEsxTjdDTFZKVXNVVkJrdGpFUHFuTVRsNFh6QmpkUHFkK1R6a3UyVHk1?=
 =?utf-8?B?RHRuaCt6eTVHd3d3UHVSWkFxTXBLQ0dQeE50MStPbnpIZUtoRWVEM3hrdm9C?=
 =?utf-8?B?THFpQy80M2EwTHpzQVBBSjRYTnFtUEc5S29FeG9uSU9WbWcwa09aQ25tdFJz?=
 =?utf-8?B?NkFiTGRCVXF4clZpWXlUeGFqbElIWFR6RnNmVjBNeDdOZXl0SVZESzZ1OWZO?=
 =?utf-8?B?RHVtb1BuczA2YjJZS0YraHZ2elRaOVJaeTBBUVBCd0YxT2dHODhwTDJLak1U?=
 =?utf-8?B?cDZnM1FCQ09GZ0RRRG9xYXVPRFF5VEo0czAxRWpmQ0xnbVJ1eUpJZ1JjYnEx?=
 =?utf-8?B?Z0RDeXVJSGRBTXdseWw0enhVdXI5UWI0M3ljaUpOOStOS3ZMQkRMcWJuYnBI?=
 =?utf-8?B?c3FCdHF0V1hpVzZwY3VQRGUvQXBUbDBVZnFEOTIxTW0vdFg4UXJDaUtRZWY4?=
 =?utf-8?B?b29ObmgvTzFmcEYweUpiMXd3QllaRFEvaEFwOHU2YVA5TjNqaVdaK0IyOGNX?=
 =?utf-8?B?Rm54ZlVTMitkNXVLRXVKcGRwZ2ZmV3lZWk1KeDZkcW1ZdkMrN0d6dTMwcjlP?=
 =?utf-8?B?YVNFQTUxOVBUL2QvWlVlcXdnZDRLNW8zb0huakFzaXRYY2p3d3NMOCtFM05D?=
 =?utf-8?B?c3JnQmc5Ni9tTzErRkdzRzNDdldKRDBtYWZvSmErUWFKbVZoYjVUVHpibGVh?=
 =?utf-8?B?V08rRXRUckRWWjFMSWM0VHk5VEdZb0xJYXlTMTROUUx6OEFLdXMyR3hibk91?=
 =?utf-8?B?OWpTclkyL3pDZjFsZmJORW9YcFlQdEpnN3M5T1UwaDJkaUYvVXJQL2VVOG1w?=
 =?utf-8?B?KzFKSTAzNnJJWXg1eEJIYmJ2dWlRdUg5U2FHT01Ba21FWVlFbDkva1NLSyty?=
 =?utf-8?B?cFZOMlc3dGNXaWhza3FiVUtqWktaRWFybmUwT3BwSXVOeG1LaFM1Z3RJTmtI?=
 =?utf-8?B?aXF4UGtteTJxd1A3cUczdk1yY1A1TExGU2FzYWV4cFBXUklxWStaWUFYL0M1?=
 =?utf-8?B?cGZRTTl3eXRwbCtlK3BrV1Bham1sS2ZWT0xxS0F1YUoxY3lSTVFsdEJ6SFRo?=
 =?utf-8?B?RU1CLzN6RW92TFI5VWFSb0xrWUxIanI2UTRKanRHRzg0NW9JZk5LbEVKUVJK?=
 =?utf-8?B?cEpZSUtiYVdRUk5ZMlA2bXp0WmxYSXhvOE1aZ1h1bzgwNFpVcklpSlpiaHc2?=
 =?utf-8?B?Q0diamxxVjBtSGU2cUdCaURGOTBBTGJjejVUOGNMRkRUSDlhL21VWEQyZisx?=
 =?utf-8?B?V0xMZmFaY2c5Y1BwZmpaUGdMWnBFS2tMOHYzcVNBSHFlNGhnVVhXWTF3ODA5?=
 =?utf-8?B?emd3M3Qxd3NxekljOU1uVzUrcWJxN216TVJyeENqSXhhZmdhL0hkRWJodThi?=
 =?utf-8?B?V3BGYUxiWFEzRjVQei9WV1QrU24yamkzS2gwYWl3UHgvdzZrNTFIUEJydGR4?=
 =?utf-8?B?eSsxd1hZMXlxcExjQStXWHJqRGl3MFNpTDZXaXFQSHowSzFOWnU2cThjUHB2?=
 =?utf-8?B?b3llSTJVV21JUkw3WkRYYUNXVS9IcjZ0a0tncVNUU0lISDNYK24rRlNWbDc2?=
 =?utf-8?B?TWNzNWxIbUNDSlE2TVhwTXZoNnhoQ1JlNThibE9GNDFjN3VFZy91OCtlZnRH?=
 =?utf-8?B?OCswMGJLVHpSWUdNNDVtZFNzSmpPQk5mRWxyQkc1U0g1NTJIWDdZWkJxcmxL?=
 =?utf-8?B?Z1VsRzl3aURLUERPazk3MU0wV2hKZTR1OXZKUm9Ya0kzSFUyYUFrVjVPWENT?=
 =?utf-8?B?bnRMSUVoeTJKc2pJWW5taUZQdW1uTmVsUHlWdDZlRkk4VEFVT0I5Szh3UC9l?=
 =?utf-8?B?Y3VaeU1IK3M3aHNwN0FxdXBwRlJEdzN6MG42VktweE5MMWxXSHBPVmNtTXZO?=
 =?utf-8?B?dGRHK0lkN1o5UGIzQ2oxMmVudkNXV3lMaG0yd0duOGIrWHl6NGk5MGhTNTlt?=
 =?utf-8?Q?t9WM7qQdwnIlIQ7mFxIbFdY=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <866C54A23F7190449370E337AE6E843F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5324
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	65166d0c-6979-4759-08f9-08de552b1175
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|35042699022|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amFDQitiTDAwY0p5QVN4cUdKbkNZZHhqRmcyRG5qUWozaUZyS0lwZW5MQWlv?=
 =?utf-8?B?TWo2S3ZIOU1FNmlFYkFUL3ltbjNwRmVMUmpQMHd6VFNVZHBXZzJyS3dpbzV6?=
 =?utf-8?B?ZnAyWmZEUis5SVkwR3pHMi9RMDFVTGpBQ1dkTWwrdWEzZHVVbTQ0YXhLR1Z1?=
 =?utf-8?B?M0J6aGhraGZUcHhaRWlYUkRSTjVWMzk1ekRUM1hveW5kanRtZlI2ZWR1K1Ev?=
 =?utf-8?B?RGdlOHo4bTlxckNob0lvUmVEbStwWVU5RzhGZGVEYlk3TllrWTk2ZmpkYllz?=
 =?utf-8?B?VTVCMkttb2pOZUxYU05oRkRJZTdYK0pYenJadHFlVTl4cXlxMzExU1R1b0Ir?=
 =?utf-8?B?YjhqQlV6b1hidG1QaGJMZktRaStBN0pRNjdpLzE0N0I2RTlPMUZLWGxPQUFs?=
 =?utf-8?B?Z3Jxd0Vpd0x5OVpQbUFkMW1aTmNoV0NlZHU4dnN6TWRQR0JFUnBYVGtwVTZz?=
 =?utf-8?B?NzRNV1ZBa2phV2VWWTFlRURsU1NVZ3h3b0daaVBhOGE4QkdTZ2laUjY0enVK?=
 =?utf-8?B?aTFVakxpQnMrUVc0R1RDUXU2SmxvQ3BvS0k5aTJmaXBuWWJhMGNrTWtFQnQz?=
 =?utf-8?B?VHVjTlBCQWhsUmVjaHM4NUw3clRBaFZxbU9QRmhWQUlsSUdXcHpQdm1kazZq?=
 =?utf-8?B?anJ5bCtFOHVFRy9sMkkrS05yeER1UHk3eFRrN0o2YW9vRjNGaFVic1ZEUWtH?=
 =?utf-8?B?OUdoSTdEc0llRmNiVkNYVFkvcjZqWWFKRlFDWFd4T2NXM2MrMjcxWGJhVjlo?=
 =?utf-8?B?QVM3YkdzWFhWaTlxOFZianQzVSt6TjQyeHRHSjBYMVZFR1VSNG5sVHJJcTNU?=
 =?utf-8?B?ODBWSHNxVE1tTERYWmdyVkw0amR6cjdFNVJ3VWlUcXNWVUFXM0dhTUVaVnVN?=
 =?utf-8?B?cm1ER2FZWlpmVVNwb2NyYkZEaXJlSTM5cU8xOVpFbDhjOHRoWGVYWGcrditp?=
 =?utf-8?B?MFlvME56RENtaFZHK3lLNk9HLy83OGkvNVN5NVNMWXJVbkZ1MlNWR2dwU0U5?=
 =?utf-8?B?SlMwODVVaUdiK1UwcWxrcEFlck52d3RuWVZzMGVzSU11RlI5UGRKOVA5WjBU?=
 =?utf-8?B?RjV0OXZJcytETHAxV0VFNHpDT0RlTDF0cTRhLzdFOW9yaEVmRjRZcDlaeFF4?=
 =?utf-8?B?NXIyTE9TbXc4VFRmY1FpQldhejRMMlR4c2ZlL0RqOU5VejFiRHhTZ0R4ejZj?=
 =?utf-8?B?djhjRmZJbHlzUXZaanJ0SlZVOGlmNlBlaE1uaGFBU1p5WGc4NTZEQWdBb1ky?=
 =?utf-8?B?eS9PMmYzc1NXYmhJYXRIOUdqcjg0S2x6UDlCUHdlNGdna3RacmFYYnhDOW1D?=
 =?utf-8?B?b3JzcFF3UERMZmZXUjErWnU0WDNoUEs4RURlZFRmS1c0dGpVaFQyT2laSmZu?=
 =?utf-8?B?eE40YXlLclo0RmJlQ1Z3TjlUcEdDQ0o3ZlJ2OUoyNE9mcTMxNThTZHQyRitR?=
 =?utf-8?B?WFB0Y1A5NUJaR1RCWlV6aDB5M3FmaDNnSjFZalI2Q1dic0VScnBjRHovbFRP?=
 =?utf-8?B?aGtwQ0VyWGxrbWliMGRzSEVSc2p1dHpUdTc5dGRkMDdCUVF1SmorMXlvckU3?=
 =?utf-8?B?RzVsMGNaZnFBNFBtU1RZSXc5dnNpTmc2aG01MEhsdjhxQndQczlsdmQ5anZy?=
 =?utf-8?B?ekE5RE9XY0c3OTdiWDFTM0lJZkJWUVVCbDVMTkM0QXczMDhKcmxkNnB6MkJG?=
 =?utf-8?B?ejZ3OFRRZkJUc01ScGd0NzhmT1U3YTZOQXRsVHdabkIxaFRuTjgzZytQZEV0?=
 =?utf-8?B?a1MzOVdJbDNsZ244MkN6ellWaEV2SUIrTUhZUnNUQjlhb1NLTFhaaHEzTFhX?=
 =?utf-8?B?M3czbjNGVHFPaGxsQ0JKUGI4MWd0M1lFZ09naHFZTWRJSUhnVTdIb0c2TDg2?=
 =?utf-8?B?dEFCcDdKak9xOS9Ldys5N1lxcFRZbHZORFRKM3phWXVud3IrM0FSRnB1Qzdw?=
 =?utf-8?B?ZDAvZkt0WktTMXpBbHU3UUMwT0ZFNEl4WTZPUitHUUNucmRHTjRMVnhyYTdF?=
 =?utf-8?B?YlZ5VXNleHV5SzA4QVYzSnlrL016SmZJUHNhQzFmSXpRSUhnZjJrQ0ZMcnow?=
 =?utf-8?B?REhpbjBHd1NYcUZYTXN0RnBFdTd1MkM2Z0M4UWszK3UwaWJwZkt5dFNkRlNj?=
 =?utf-8?B?NmNWK1o1dHRHOThzV29uY1duQkNUaUgzeTVMV2hFUnVoTlBKQWxmUkwzdklF?=
 =?utf-8?B?UXJzMkxuZTBicXkvQUdDN0lrZmVmOStQRkkvOWM5OVM2ZzlmcGJRRE5RTzlS?=
 =?utf-8?B?cnZhK3I5eEsxVzdCbm5TRUJoMTVBPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(35042699022)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:15:23.4161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 629dff4b-e8cc-494f-4102-08de552b376d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9698

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE0OjQ1ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gDQo+IEZFQVRfVkhFIGlu
dHJvZHVjZWQgYSBub24tc2VjdXJlIEVMMiB2aXJ0dWFsIHRpbWVyLCBhbG9uZyB3aXRoIGl0cw0K
PiBpbnRlcnJ1cHQgbGluZS4gQ29uc2VxdWVudGx5IHRoZSBhcmNoIHRpbWVyIERUIGJpbmRpbmcg
aW50cm9kdWNlZCBhDQo+IGZpZnRoDQo+IGludGVycnVwdCB0byBjb21tdW5pY2F0ZSB0aGlzIGlu
dGVycnVwdCBudW1iZXIuDQo+IA0KPiBSZWZhY3RvciB0aGUgaW50ZXJydXB0cyBwcm9wZXJ0eSBn
ZW5lcmF0aW9uIGNvZGUgdG8gZGVhbCB3aXRoIGENCj4gdmFyaWFibGUNCj4gbnVtYmVyIG9mIGlu
dGVycnVwdHMsIGFuZCBmb3J3YXJkIGZpdmUgaW50ZXJydXB0cyBpbnN0ZWFkIG9mIGZvdXIgaW4N
Cj4gY2FzZQ0KPiBuZXN0ZWQgdmlydCBpcyBlbmFibGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
TWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmUgUHJ6
eXdhcmEgPGFuZHJlLnByenl3YXJhQGFybS5jb20+DQoNClJldmlld2VkLWJ5OiBTYXNjaGEgQmlz
Y2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiAt
LS0NCj4gwqBhcm02NC9hcm0tY3B1LmPCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArLS0tDQo+
IMKgYXJtNjQvaW5jbHVkZS9rdm0vdGltZXIuaCB8wqAgMiArLQ0KPiDCoGFybTY0L3RpbWVyLmPC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyOSArKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LQ0KPiDCoDMgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJtNjQvYXJtLWNwdS5jIGIvYXJtNjQvYXJtLWNwdS5jDQo+
IGluZGV4IDA4NDNhYzA1MS4uNWI1NDg0ZDhiIDEwMDY0NA0KPiAtLS0gYS9hcm02NC9hcm0tY3B1
LmMNCj4gKysrIGIvYXJtNjQvYXJtLWNwdS5jDQo+IEBAIC0xMiwxMCArMTIsOCBAQA0KPiDCoA0K
PiDCoHN0YXRpYyB2b2lkIGdlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsIHN0cnVjdCBrdm0g
Kmt2bSkNCj4gwqB7DQo+IC0JaW50IHRpbWVyX2ludGVycnVwdHNbNF0gPSB7MTMsIDE0LCAxMSwg
MTB9Ow0KPiAtDQo+IMKgCWdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3ZtKTsNCj4gLQl0
aW1lcl9fZ2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3ZtLCB0aW1lcl9pbnRlcnJ1cHRzKTsNCj4g
Kwl0aW1lcl9fZ2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3ZtKTsNCj4gwqAJcG11X19nZW5lcmF0
ZV9mZHRfbm9kZXMoZmR0LCBrdm0pOw0KPiDCoH0NCj4gwqANCj4gZGlmZiAtLWdpdCBhL2FybTY0
L2luY2x1ZGUva3ZtL3RpbWVyLmggYi9hcm02NC9pbmNsdWRlL2t2bS90aW1lci5oDQo+IGluZGV4
IDkyOGU5ZWE3YS4uODFlMDkzZTQ2IDEwMDY0NA0KPiAtLS0gYS9hcm02NC9pbmNsdWRlL2t2bS90
aW1lci5oDQo+ICsrKyBiL2FybTY0L2luY2x1ZGUva3ZtL3RpbWVyLmgNCj4gQEAgLTEsNiArMSw2
IEBADQo+IMKgI2lmbmRlZiBBUk1fQ09NTU9OX19USU1FUl9IDQo+IMKgI2RlZmluZSBBUk1fQ09N
TU9OX19USU1FUl9IDQo+IMKgDQo+IC12b2lkIHRpbWVyX19nZW5lcmF0ZV9mZHRfbm9kZXModm9p
ZCAqZmR0LCBzdHJ1Y3Qga3ZtICprdm0sIGludA0KPiAqaXJxcyk7DQo+ICt2b2lkIHRpbWVyX19n
ZW5lcmF0ZV9mZHRfbm9kZXModm9pZCAqZmR0LCBzdHJ1Y3Qga3ZtICprdm0pOw0KPiDCoA0KPiDC
oCNlbmRpZiAvKiBBUk1fQ09NTU9OX19USU1FUl9IICovDQo+IGRpZmYgLS1naXQgYS9hcm02NC90
aW1lci5jIGIvYXJtNjQvdGltZXIuYw0KPiBpbmRleCA4NjFmMmQ5OTQuLjJhYzYxNDRmOSAxMDA2
NDQNCj4gLS0tIGEvYXJtNjQvdGltZXIuYw0KPiArKysgYi9hcm02NC90aW1lci5jDQo+IEBAIC01
LDMxICs1LDI2IEBADQo+IMKgI2luY2x1ZGUgImt2bS90aW1lci5oIg0KPiDCoCNpbmNsdWRlICJr
dm0vdXRpbC5oIg0KPiDCoA0KPiAtdm9pZCB0aW1lcl9fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQg
KmZkdCwgc3RydWN0IGt2bSAqa3ZtLCBpbnQNCj4gKmlycXMpDQo+ICt2b2lkIHRpbWVyX19nZW5l
cmF0ZV9mZHRfbm9kZXModm9pZCAqZmR0LCBzdHJ1Y3Qga3ZtICprdm0pDQo+IMKgew0KPiDCoAlj
b25zdCBjaGFyIGNvbXBhdGlibGVbXSA9ICJhcm0sYXJtdjgtdGltZXJcMGFybSxhcm12Ny0NCj4g
dGltZXIiOw0KPiDCoAl1MzIgY3B1X21hc2sgPSBnaWNfX2dldF9mZHRfaXJxX2NwdW1hc2soa3Zt
KTsNCj4gLQl1MzIgaXJxX3Byb3BbXSA9IHsNCj4gLQkJY3B1X3RvX2ZkdDMyKEdJQ19GRFRfSVJR
X1RZUEVfUFBJKSwNCj4gLQkJY3B1X3RvX2ZkdDMyKGlycXNbMF0pLA0KPiAtCQljcHVfdG9fZmR0
MzIoY3B1X21hc2sgfCBJUlFfVFlQRV9MRVZFTF9MT1cpLA0KPiArCWludCBpcnFzWzVdID0gezEz
LCAxNCwgMTEsIDEwLCAxMn07DQo+ICsJaW50IG5yID0gQVJSQVlfU0laRShpcnFzKTsNCj4gKwl1
MzIgaXJxX3Byb3BbbnIgKiAzXTsNCj4gwqANCj4gLQkJY3B1X3RvX2ZkdDMyKEdJQ19GRFRfSVJR
X1RZUEVfUFBJKSwNCj4gLQkJY3B1X3RvX2ZkdDMyKGlycXNbMV0pLA0KPiAtCQljcHVfdG9fZmR0
MzIoY3B1X21hc2sgfCBJUlFfVFlQRV9MRVZFTF9MT1cpLA0KPiArCWlmICgha3ZtLT5jZmcuYXJj
aC5uZXN0ZWRfdmlydCkNCj4gKwkJbnItLTsNCj4gwqANCj4gLQkJY3B1X3RvX2ZkdDMyKEdJQ19G
RFRfSVJRX1RZUEVfUFBJKSwNCj4gLQkJY3B1X3RvX2ZkdDMyKGlycXNbMl0pLA0KPiAtCQljcHVf
dG9fZmR0MzIoY3B1X21hc2sgfCBJUlFfVFlQRV9MRVZFTF9MT1cpLA0KPiAtDQo+IC0JCWNwdV90
b19mZHQzMihHSUNfRkRUX0lSUV9UWVBFX1BQSSksDQo+IC0JCWNwdV90b19mZHQzMihpcnFzWzNd
KSwNCj4gLQkJY3B1X3RvX2ZkdDMyKGNwdV9tYXNrIHwgSVJRX1RZUEVfTEVWRUxfTE9XKSwNCj4g
LQl9Ow0KPiArCWZvciAoaW50IGkgPSAwOyBpIDwgbnI7IGkrKykgew0KPiArCQlpcnFfcHJvcFtp
ICogMyArIDBdID0NCj4gY3B1X3RvX2ZkdDMyKEdJQ19GRFRfSVJRX1RZUEVfUFBJKTsNCj4gKwkJ
aXJxX3Byb3BbaSAqIDMgKyAxXSA9IGNwdV90b19mZHQzMihpcnFzW2ldKTsNCj4gKwkJaXJxX3By
b3BbaSAqIDMgKyAyXSA9IGNwdV90b19mZHQzMihjcHVfbWFzayB8DQo+IElSUV9UWVBFX0xFVkVM
X0xPVyk7DQo+ICsJfQ0KPiDCoA0KPiDCoAlfRkRUKGZkdF9iZWdpbl9ub2RlKGZkdCwgInRpbWVy
IikpOw0KPiDCoAlfRkRUKGZkdF9wcm9wZXJ0eShmZHQsICJjb21wYXRpYmxlIiwgY29tcGF0aWJs
ZSwNCj4gc2l6ZW9mKGNvbXBhdGlibGUpKSk7DQo+IC0JX0ZEVChmZHRfcHJvcGVydHkoZmR0LCAi
aW50ZXJydXB0cyIsIGlycV9wcm9wLA0KPiBzaXplb2YoaXJxX3Byb3ApKSk7DQo+ICsJX0ZEVChm
ZHRfcHJvcGVydHkoZmR0LCAiaW50ZXJydXB0cyIsIGlycV9wcm9wLCBuciAqIDMgKg0KPiBzaXpl
b2YoaXJxX3Byb3BbMF0pKSk7DQo+IMKgCV9GRFQoZmR0X3Byb3BlcnR5KGZkdCwgImFsd2F5cy1v
biIsIE5VTEwsIDApKTsNCj4gwqAJaWYgKGt2bS0+Y2ZnLmFyY2guZm9yY2VfY250ZnJxID4gMCkN
Cj4gwqAJCV9GRFQoZmR0X3Byb3BlcnR5X2NlbGwoZmR0LCAiY2xvY2stZnJlcXVlbmN5Iiwga3Zt
LQ0KPiA+Y2ZnLmFyY2guZm9yY2VfY250ZnJxKSk7DQoNCg==

