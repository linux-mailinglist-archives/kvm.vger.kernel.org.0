Return-Path: <kvm+bounces-50341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D470AE4186
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A29C170454
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68DB24DD16;
	Mon, 23 Jun 2025 13:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="COtP41o6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="COtP41o6"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013033.outbound.protection.outlook.com [40.107.159.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2CB24DD0A;
	Mon, 23 Jun 2025 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750683781; cv=fail; b=CYwMydcjZ02zkD5sJjOWaSSC8zGQsg7Eai1rpXDWV7CAdn7m7IrtaSKRe9Or5OOg/mW5zYgbimUH80/1SL40DX0BfweT6y/k/hs/NrwVWiw42+eVz8qZTeTvQr6t4Tquh5bh35ueGk1+BBVuZeFi1Sk3F1Pb5VEfcLZMcVrC/s4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750683781; c=relaxed/simple;
	bh=FShVfrphJQhsN5OZMrtm4P/4mLqgjHwW+vmlMo5uxaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ajldxt2dyPv4o+qM+MyAxDMcETr8nKOmqT36utx8bpctiT6fIpzMLs3822hnwLg53Km+EkaLroAhe2kwaHO6pT/XXjNrC6xeV3eAxU+jvCCk8+vfsNoJkGJb6S/7Kdtmwmy4W3/ioyzSkoPitcd/Wp4X9bzGQ8z261I1MGgcDeQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=COtP41o6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=COtP41o6; arc=fail smtp.client-ip=40.107.159.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zLF0HDrF2AKXlJ/gUEQKGtuFKZoMo+21tgZu3KMqxp9Tho82JF7CxC0LYCNi/SRI0rbieu3Aov9avZdKFwky2ukvT9XFPWiIQR4g8MamqbGrCj/FIKLZcG9Ob/9kOKTq+MiNV5qnXjYeQnE5eXVkaGyAcl5wQNggoAfuIiwbzAgvwkkZadPefBP30x1H/dZYWlDkp7mt7mNjA3M900Tc51VHdxFlaPGG7/GlyUZjx8Z9UfGvfNLzasb326V0c3zCOwN3xKk0QVNozHTcvinvKFT3jTdFkMvAgMXjBAcR/K+kk4ZZg1/8h6EwQYN9emZsDOWW0kNJHzRy/lGQax0Jpg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FShVfrphJQhsN5OZMrtm4P/4mLqgjHwW+vmlMo5uxaY=;
 b=t1m0Zm+hCEwy/HxHcnsublbkjVsi1S6C8MnXrIRup1sogDmAfJxpUikPQbA/R7DW4HOIdPFI+EWgJ+88T9QEavCKt2/aFGUr/XphoJcwxipURVS8pcgLv4BY46DD5u34SnQO0WdGm3Xthdjz5cld8gf3BacEj6N7XeA3xxooVL60A2mVgz8tArrSBI1PoQYcsFV8mYk1AIgbbj3CqLeTBJ1BycmAZk2QozJLaXX+p4r+Ilpeat6KKpQCLQ5/Pn/d/uT/8MhiT5be9rGKpErjJjDLB82yEZSWUE7Y/vxx/BDGVIgNuoHYhmLxwPlrpo82n9vU/17JoZaNcFpBzppjDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FShVfrphJQhsN5OZMrtm4P/4mLqgjHwW+vmlMo5uxaY=;
 b=COtP41o6OzTplrnD1vDvAte7298uLucT16Bscl0WkLSsqolkKqHp4DFd+1lFMHOCMHy2FMMbYFpmAZpYUH+L+NYtGfgOBbKe433IeHEFIMCpmWwWAjTLEYtuwjfDF/U/8gn/eCa+CvB3xh5k4m2oJ3O6/L/8Nq33jcekD0VXVDs=
Received: from DUZPR01CA0062.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::15) by AS8PR08MB9742.eurprd08.prod.outlook.com
 (2603:10a6:20b:616::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 23 Jun
 2025 13:02:54 +0000
Received: from DU2PEPF0001E9C0.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::b1) by DUZPR01CA0062.outlook.office365.com
 (2603:10a6:10:3c2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.29 via Frontend Transport; Mon,
 23 Jun 2025 13:02:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C0.mail.protection.outlook.com (10.167.8.69) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14 via
 Frontend Transport; Mon, 23 Jun 2025 13:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3uDGFZ/kgPTMwFCRWyuv2taLzy7Z9xmdjyu+KqHnTNzmKtYp3dSEK9x5nZ3xCh81wxUT7b7Ugm1C/u0ODCPwq+z/GlFw1uRqlYZy6Qr/zZ+dVfV4aItt0XNz0eNJLB7ImXG+shWqWgHBM95YSh9waP7/zYJ6HgfN1YCQujboQMk9e9IVKQfGTCMo9boVFpth9NwfYirA5EcHo16rolcrnX6hIjk0k0q6JenUgsjAXbll4GTexi0AT2KpZeTeJnlnD3snDShpBnfQ3m/Ow+gcXSS3P6e/qiJCNIwj8mlQXHA22ELoVQMEnfLcBzedHZFfDBa4jnD/BP/9EgZuTH0yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FShVfrphJQhsN5OZMrtm4P/4mLqgjHwW+vmlMo5uxaY=;
 b=DYpHypek282bYfsZFnpvbfElwe48lBpk7CFLjZkwHWWVQh0tYvPzvZFJS8mEj//Zhq/vu1+49c90Mjwmx7BKJw6rcXsNpnBbDKhLYPaxnpmSy/J5TOGu9RyIPBJhPApohtOjYMZMw3Pbmq3CTRwUSwt4jHPZD/nJeOIKaklTqyiXUnjs4eE8RSs+RGLFTco5kebCOjzRITpybWU++u3lO76NqNkOqYRbUm+OEuVVmUv0JXvygpS1XDGYwRnaYpw0s6uTwZ9HD9I9fm7DzOfX6Mmfc+SkaOClABZ4xj7hzcGUsKxus44BlS+wfU1V9AkB3cx7gSI87F2aKqWp8noKZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FShVfrphJQhsN5OZMrtm4P/4mLqgjHwW+vmlMo5uxaY=;
 b=COtP41o6OzTplrnD1vDvAte7298uLucT16Bscl0WkLSsqolkKqHp4DFd+1lFMHOCMHy2FMMbYFpmAZpYUH+L+NYtGfgOBbKe433IeHEFIMCpmWwWAjTLEYtuwjfDF/U/8gn/eCa+CvB3xh5k4m2oJ3O6/L/8Nq33jcekD0VXVDs=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by VE1PR08MB5646.eurprd08.prod.outlook.com (2603:10a6:800:1a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 23 Jun
 2025 13:02:21 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 13:02:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, nd <nd@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Topic: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Index: AQHb4f15BBM4oiETR0uMyl7uJd3tLbQMfZUAgAKeKoCAAAUkgIABmT0A
Date: Mon, 23 Jun 2025 13:02:21 +0000
Message-ID: <8fc1fa1f97c5efb46ad6eca41d76f03ed4bd4954.camel@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
	 <20250620160741.3513940-5-sascha.bischoff@arm.com>
	 <aFXClKQRG3KNAD2y@linux.dev> <87a560ezpa.wl-maz@kernel.org>
	 <aFf5EYvF3NVr9MKm@linux.dev>
In-Reply-To: <aFf5EYvF3NVr9MKm@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|VE1PR08MB5646:EE_|DU2PEPF0001E9C0:EE_|AS8PR08MB9742:EE_
X-MS-Office365-Filtering-Correlation-Id: ea0cac39-e641-4365-bb5e-08ddb25644a2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?ekF2OTk3YjZCazlTcTg3dXlrWnBkNExQRHFrV1Zybk1LNzZ3K0I2bUJEUWpt?=
 =?utf-8?B?VndVaXg2UEFOZmJsV0cyNGxZVGI2dmhYTytTbFZxZjB0RmxwZ1Q2UCsyOFFx?=
 =?utf-8?B?WFQ0T3NNbTVXMG9VZy8wNDlmcWNxQ25mYVczOGk3TE9QQnNsZlQxS1RMa2Rh?=
 =?utf-8?B?ZlE1Y3JZQS84c1oySW1FUmRPTXhwMWc5WVQrcFFCcXZuajJTdVlyajVtYU9L?=
 =?utf-8?B?eUVOS2xYN3JPSEIxUzlNWUdzU0pnZ1lQR1FmckdoeEx4YzAvOWdhMXRsS0NW?=
 =?utf-8?B?c2xvVUpUVk1leWsvVUhWNnJnRG9Nb2ZBbWNGV1ZTYzlmVnlzWmtwQUMwZHFQ?=
 =?utf-8?B?MHoweXpzc2xFRml4eU9MUDMwRWI0aXRaNERrbDlVSDlUQ1EzT1d2RFE2S3NZ?=
 =?utf-8?B?ZmdXZW9BVlV2REsrbS8zVHljWE12QWRnbndkL2lINVRraGI0WXRTeDN4T0pB?=
 =?utf-8?B?RmZTb1N4NWlVY0lYZVdNT1c0WVBWbE9UZ2ViRllYWXNYK0ZZcklNL0sxVFN6?=
 =?utf-8?B?bG4rSGhMMXB6QWl3bDdieXZDRlZjWGZ1T2laZmxvdHkwbXErdWtldldQckZq?=
 =?utf-8?B?UFlyV3d0c3V4YUJnOENEN0lpdVBVZ2J1bmF0M2M0TmMvb3h0OFYveDR0SUNh?=
 =?utf-8?B?SzN0MWtScC9NRkdDU2NML2Mrd0JKQUJHb2o4UU0ycFQzQm5VeGZQR1c1SU9O?=
 =?utf-8?B?U1luVmxqcW9lOW43TWJTM1h1TnhQVmRpMGdHV1ZrQUtJc0ZXei90OEQzYnR2?=
 =?utf-8?B?aUlJRVhtSEVqOHZHY1NjTEtuZ2l3ZTFDRHFvTVlIWUN0UWpVSEd1N3BMY2F2?=
 =?utf-8?B?RXpCa0U1RVlEUHIva25RMktwU0N0MnN2RkFGbVhKVzRaVW9KczFNUi8vMlgx?=
 =?utf-8?B?bmQrQ28wYWJZY3YrNWVVUWp6NUw4cGQwQk92ZmhMcmFlRUZuVGxSR0dBYXM5?=
 =?utf-8?B?ZFhEMTZqNm5hNXhFS3BKemFOL2dMcFdUYjdQcUZVSGNwdUVpQ3FCSW5HS1Ba?=
 =?utf-8?B?RWpxKzluMlhGNEI3ejY1NzFnUXMwZlVLRGdBZUtDYnVXUGxDbmtOLzk4UnhW?=
 =?utf-8?B?VjVjZytFeFBLV0lGU2wvM01WdUcwZk9LS1hEZTFlTXhHUDBZYUFhVFF6K0I3?=
 =?utf-8?B?VzV1SzgwMjdNRjlFZ2xiQlZ4UGxxdzJVM2Vsb1JLVHFxVnVjVStpeVRKcWZo?=
 =?utf-8?B?UXMyT0tMWlhSWVhZeWRWWktLWjArYXdwUlVUU0x4KysyMzZiYy94Qnhqd3g5?=
 =?utf-8?B?MWVVNFowd2FSNEZPbzJ0b3FxZ1NGUGpyWkNmSG8zc2VVUzE0VTlFc0NBM2xF?=
 =?utf-8?B?cjhXNFRqbXh2K2J1WSs2d1pIdllkMzh3bjcrck9aRlRmYkRpbE1DTFFxeTJy?=
 =?utf-8?B?c2tZV2cvc1E5Z0xBYS9GV2I5M29qQWx5cDJLbXA4amN0bHErdTBuYnpsQ2Zh?=
 =?utf-8?B?VlZpbFFzVk9Oajd0eFJndE51b3MrNVU1YWc0aStmYkNVN3BPbXRLcTd6am1Y?=
 =?utf-8?B?UmE1VDBCUHc1a0ozMVNoSUZGU3FqNmRCTkZLeGhhR25IbXdxQy9Tcm9zSzhE?=
 =?utf-8?B?Nys0dlg1N01qVTQrOFYwNjVnZGFhK2hrQVJsWEt4ZTFpWFZsLzl4Vmhtdmdi?=
 =?utf-8?B?OEV4WWdaZjlMb0NiRWxua25ZS0gvbVlYdERVbkJlTXl6UVNxcHh0d3BTaUdx?=
 =?utf-8?B?cXZ3QkVhNlVzbmVCcU9XWUZFbkVZOHdVcS9abVFCR0l5eWxQQnNGY0tYZzBD?=
 =?utf-8?B?Q1VNeVZmY2UwU2c5anFuR252RWplWXk1ckJQK3dZT1BFOUNPR1ptblFzZDZj?=
 =?utf-8?B?dE5UeVU3QmdkWFB2MG4vOGpjdnI0QTQyOFl6MUxidzZYcG80OStOR05aRFRJ?=
 =?utf-8?B?R2JyaVNhWjl1SDI0SXg1aXQyNkhsTmRNOUJ3bEM5OXI2QVVnaTliNzZTRk9Q?=
 =?utf-8?B?QmNzYzYrVk9IMFBMd0t2cXZVK1Jtd2Y0Qk9KZy9yNk5vbmVSQWZZRGhKZ2F0?=
 =?utf-8?Q?zjA969J7U19PQx9ODmJjWO0DMf2z5k=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CAFBAD7D9C3CF41B4F2A7BF1FA88F5E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5646
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9239e71b-5899-4c04-9963-08ddb25630fa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFdETDdMdkxkRXlLaXJBTTZKaklPa1Y5dUF6L29qcm1CaXJ1Nkh6Z01zZ2g5?=
 =?utf-8?B?d1RBdXk1dmFZMnc2bDRZNmdJd05pUWxBVVlHTWNTNHdHVTBGNzk3YVp3b3lB?=
 =?utf-8?B?aXlobmJGQkRkNUdQMUd5aTFZckdYVEo0WnFxMGtZZXFlV0hCaGFCLzdhcDh5?=
 =?utf-8?B?eE4vdzZvR29uZjFqNDdPcVpZZ0tuZ0d6QzdJbHRxK00rTCs2a1MwZHF6WXdv?=
 =?utf-8?B?c2NFdlYvak1wZ1NlMDJTMlEybEw5RC9GNkhhc2t5TzdxVFBBOVV6QkZhVSt0?=
 =?utf-8?B?a04vdE0vSVlPQndtdHlhUHZNU3NOUjJ6RS9kNVZlRUhnR3dVRW9zUUxMeDRF?=
 =?utf-8?B?UTAxNmUyOForbGxrUlk1U2Y0KzNoajcvanljTE92YXM4REptUGRkdXNFZ1Z3?=
 =?utf-8?B?L2ROSHk2QmUxcjU1OFRHZEZMS295Z2FXcWxreVptZ1BybzZuZFNjLzVEb3Qy?=
 =?utf-8?B?MEhSLzcrM3VDU2h6TksxRWNyTDkzNGhaT0oxRTN4K2d2dFBkOS8velh2VXdh?=
 =?utf-8?B?cm5qN09hOGNyTWNrRGdGY1JwejlYOGZiaVpwbUF3N3ZwUlBaSW9QSTdMdXpM?=
 =?utf-8?B?aDZuM1dYaVdlSkgybEdOaFlqTXhQS2NvZ0RzRGlKWkt5aWVnNzlva3lxbVpP?=
 =?utf-8?B?UEdvckUvM3hDQVlZQWsxZUFET2l3UmRpUXBuTVVHdUUwamh4REMwSWMrODJJ?=
 =?utf-8?B?ZDJJdEtnVTFvUnBHUnJtTUJ5ckJjRmx5RTFiUmMrbjBMK0xjckEvRXZ3ZDRT?=
 =?utf-8?B?TXR1WEdFa1J6Mld6cmJSSjZucmZwVWZhUHFpNFc2R0pTNkViaGtQQnlMVFNR?=
 =?utf-8?B?MWp3ZCs1R1FDSXRCd2NCWk9JckNKMjNFUTdYb2lSNWRlN1FtOFRyRDJYdHA2?=
 =?utf-8?B?b0V0K0M2WlpuWG10bnBaNHVIZk1FdWprWlBIdDRxZURPdUczVmlkdWEyd1V1?=
 =?utf-8?B?ZmJSbHk4QXFmbTBkTkIzNUtER3RhL3hOeTZvZVBYYVVNZk5Cb2dSL3RzYTZK?=
 =?utf-8?B?d3QzY1UxaG9FSXVueFU2R3lmazgyRFd5NVFrYUlKZ3lsNW5Ballod1lFakx4?=
 =?utf-8?B?djdlMTJlNk1NaWtGdk12T1QxeUFKYTZzV2hKUG9ZOGRWZGxLVFJGOWoxSTBn?=
 =?utf-8?B?RGJIeGI5a1BaYTcrSjFsaEpadi9PbnNreW9OZUlTeCtySkQrbmpXVmtRRFdW?=
 =?utf-8?B?a21NYWZEampSY2NuS2lCeUlvWDZGaktCK0NVOUYxNWNFcTVqUloxTlo3SW9S?=
 =?utf-8?B?SVl0WWdGdmJTSFZpcVdKdHBJMnRHaFdWdzFLUVdHUjlNZFB1djhMTkFaLzV0?=
 =?utf-8?B?eDR5NnMxSjdYMDFRTWZCbG52bmtaTlNvWElCcC9GY1AycTB2emc0ZkMyZjh3?=
 =?utf-8?B?bjRqM0MwblBUZ3Zic3RqLzdjdmFVdlFFSjVCUklkTWh2TkI2TU5Wd0xkaXlN?=
 =?utf-8?B?V0hCWkg4ZVJldC9TVUUyOEgvTGxSV25za3Nqbit4clp2OU5lYUhYcE1NS1h4?=
 =?utf-8?B?VkRIa1BRdE5sWUg5T0xnTGl6SEZCY1JLWXUrOTkwVTRtWjRIZGhhVk03dVdk?=
 =?utf-8?B?RU1FRm1tbmxRRlVJTmVnRm1GQTQrL0QvQmdFQ1pYQXhRMGhRTWlIdVcxWWFx?=
 =?utf-8?B?dXl2ZldDL2Z0ZlM1UWJocTU1Y2VwQTRGUU54SWlKR2JSNlZubThOeC9DZ01x?=
 =?utf-8?B?eGZ3RjZDek9Wa1UvQzNxOTFXejVpeEMrSDduNlBLNDJxZ2FyS29lenY4dXNz?=
 =?utf-8?B?TjRjeVJmWVlFSUVCd0xKdXlrcFo4OVFodDliUXBvSGRjQUFYSFRobXJXYWRO?=
 =?utf-8?B?WEhNSEU4ZkJNRjNZOURIMGJ6bi9qSFlkbG15TnZmR2RQTVFpNjBJN1BFTDNU?=
 =?utf-8?B?dTRKcGZtQVdBdlFRbzRlWVVaTVQxVXlrMnBYaENzUG9NcDI5bStrUmRjdEg1?=
 =?utf-8?B?cnNBWVprNFpGdG9sR0Fzc0xwa0JqUDdzM1BVU3k5ai9sd0N2WDIvNHMwc0Fr?=
 =?utf-8?B?b3lKbGxmS0JPSEg3eTFQc042NG5SYUVDYlRET3puQm5TS3ltcDlIVUVmZHJG?=
 =?utf-8?Q?EpyWZ8?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 13:02:54.3837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0cac39-e641-4365-bb5e-08ddb25644a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9742

T24gU3VuLCAyMDI1LTA2LTIyIGF0IDA1OjM3IC0wNzAwLCBPbGl2ZXIgVXB0b24gd3JvdGU6DQo+
IE9uIFN1biwgSnVuIDIyLCAyMDI1IGF0IDAxOjE5OjEzUE0gKzAxMDAsIE1hcmMgWnluZ2llciB3
cm90ZToNCj4gPiBPbiBGcmksIDIwIEp1biAyMDI1IDIxOjIwOjM2ICswMTAwLA0KPiA+IE9saXZl
ciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4gPiANCj4gPiA+IEhp
IFNhc2NoYSwNCj4gPiA+IA0KPiA+ID4gVGhhbmsgeW91IGZvciBwb3N0aW5nIHRoaXMuIFZlcnkg
ZXhjaXRlZCB0byBzZWUgdGhlIEdJQ3Y1DQo+ID4gPiBlbmFibGVtZW50IGdldA0KPiA+ID4gc3Rh
cnRlZC4NCg0KSGkgT2xpdmVyLiBNZSB0b28uIFRoYW5rcyBmb3IgYWxsIG9mIHlvdXIgY29tbWVu
dHMhDQoNCj4gPiA+IA0KPiA+ID4gT24gRnJpLCBKdW4gMjAsIDIwMjUgYXQgMDQ6MDc6NTFQTSAr
MDAwMCwgU2FzY2hhIEJpc2Nob2ZmIHdyb3RlOg0KPiA+ID4gPiBBZGQgc3VwcG9ydCBmb3IgR0lD
djMgY29tcGF0IG1vZGUgKEZFQVRfR0NJRV9MRUdBQ1kpIHdoaWNoDQo+ID4gPiA+IGFsbG93cyBh
DQo+ID4gPiA+IEdJQ3Y1IGhvc3QgdG8gcnVuIEdJQ3YzLWJhc2VkIFZNcy4gVGhpcyBjaGFuZ2Ug
ZW5hYmxlcyB0aGUNCj4gPiA+ID4gVkhFL25WSEUvaFZIRS9wcm90ZWN0ZWQgbW9kZXMsIGJ1dCBk
b2VzIG5vdCBzdXBwb3J0IG5lc3RlZA0KPiA+ID4gPiB2aXJ0dWFsaXphdGlvbi4NCj4gPiA+IA0K
PiA+ID4gQ2FuJ3Qgd2UganVzdCBsb2FkIHRoZSBzaGFkb3cgc3RhdGUgaW50byB0aGUgY29tcGF0
IFZHSUN2Mz8gSSdtDQo+ID4gPiB3b3JyaWVkDQo+ID4gPiB0aGlzIGhhcyBzaGFycCBlZGdlcyBv
biB0aGUgVUFQSSBzaWRlIGFzIHdlbGwgYXMgdXNlcnMgd2FudGluZyB0bw0KPiA+ID4gbWlncmF0
ZSBWTXMgdG8gbmV3IGhhcmR3YXJlLg0KPiA+ID4gDQo+ID4gPiBUaGUgZ3Vlc3QgaHlwZXJ2aXNv
ciBzaG91bGQgb25seSBzZWUgR0lDdjMtb25seSBvciBHSUN2NS1vbmx5LCB3ZQ0KPiA+ID4gY2Fu
DQo+ID4gPiBwcmV0ZW5kIEZFQVRfR0NJRV9MRUdBQ1kgbmV2ZXIgZXhpc3RlZCA6KQ0KPiA+IA0K
PiA+IFRoYXQncyBleGFjdGx5IHdoYXQgdGhpcyBkb2VzLiBBbmQgdGhlIG9ubHkgcmVhc29uIE5W
IGlzbid0DQo+ID4gc3VwcG9ydGVkDQo+ID4geWV0IGlzIHRoZSBjdXJyZW50IEJFVDAgc3BlYyBt
YWtlcyBJQ0NfU1JFX0VMMiBVTkRFRiBhdCBFTDEgd2l0aA0KPiA+IE5WLA0KPiA+IHdoaWNoIGJy
ZWFrcyBOViBpbiBhIHNwZWN0YWN1bGFyIHdheS4NCj4gDQo+IEdlZSwgSSB3b25kZXIgaG93Li4u
IDopDQo+IA0KPiA+IFRoaXMgd2lsbCBiZSBhZGRyZXNzZWQgaW4gYSBmdXR1cmUgcmV2aXNpb24g
b2YgdGhlIGFyY2hpdGVjdHVyZSwNCj4gPiBhbmQNCj4gPiBubyBIVyB3aWxsIGFjdHVhbGx5IGJl
IGJ1aWx0IHdpdGggdGhpcyBkZWZlY3QuIEFzIHN1Y2gsIHRoZXJlIGlzIG5vDQo+ID4gVUFQSSB0
byBicmVhay4NCj4gDQo+IFRoYXQncyBmaW5lIGJ5IG1lLiBUQkgsIHdoZW4gSSBsZWZ0IHRoaXMg
Y29tbWVudCBJIGhhZG4ndCBmdWxseSByZWFkDQo+IHRoZQ0KPiBwYXRjaCB5ZXQgYW5kIHdhcyBt
b3JlIGN1cmlvdXMgYWJvdXQgdGhlIGludGVudC4NCg0KQXMgTWFyYyBzYWlkLCB0aGlzIGNhbid0
IHdvcmsgcmlnaHQgbm93LiBPbmNlIHRoYXQncyBiZWVuIHJlbGF4ZWQgaXQNCnNob3VsZCBsYXJn
ZWx5IGJlIGEgY2FzZSBvZiBkcm9wcGluZyB0aGUgdHdvIGNvbXBhdCBtb2RlIGNoZWNrcyBpbg0K
X192Z2ljX3YzX2FjdGl2YXRlX3RyYXBzICYgX192Z2ljX3YzX2RlYWN0aXZhdGVfdHJhcHMsIHdo
aWNoIGFyZQ0KcHJlc2VudCB0byBtYWtlIHN1cmUgd2UgZG9uJ3QgYWNjZXNzIElDQ19TUkVfRUwy
IGFuZCBoaXQgYW4gVU5ERUYuDQoNCkFuZCB5ZXMsIHRoZSBpZGVhIGlzIHRvIGV4cG9zZSBhIHB1
cmUgR0lDdjMgb3IgR0lDdjUgc3lzdGVtLCBhbmQgbm90DQp0ZWxsIHRoZSBndWVzdCBoeXAgYWJv
dXQgRkVBVF9HQ0lFX0xFR0FDWS4gOikNCg0KPiANCj4gPiA+ID4gK3ZvaWQgX192Z2ljX3YzX2Nv
bXBhdF9tb2RlX2Rpc2FibGUodm9pZCkNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKwlzeXNyZWdfY2xl
YXJfc2V0X3MoU1lTX0lDSF9WQ1RMUl9FTDIsDQo+ID4gPiA+IElDSF9WQ1RMUl9FTDJfVjMsIDAp
Ow0KPiA+ID4gPiArCWlzYigpOw0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+ID4gPiANCj4gPiA+
IEl0IGlzbid0IGNsZWFyIHRvIG1lIHdoYXQgdGhlc2UgSVNCcyBhcmUgc3luY2hvbml6aW5nIGFn
YWluc3QuDQo+ID4gPiBBRkFJQ1QsDQo+ID4gPiB0aGUgd2hvbGUgY29tcGF0IHRoaW5nIGlzIGFs
d2F5cyB2aXNpYmxlIGFuZCB3ZSBjYW4gcmVzdG9yZSB0aGUNCj4gPiA+IHJlc3Qgb2YNCj4gPiA+
IHRoZSBWR0lDdjMgY29udGV4dCBiZWZvcmUgZ3VhcmFudGVlaW5nIHRoZSBlbmFibGUgYml0IGhh
cyBiZWVuDQo+ID4gPiBvYnNlcnZlZC4NCj4gPiANCj4gPiBObywgc29tZSByZWdpc3RlcnMgaGF2
ZSBhIGJlaGF2aW91ciB0aGF0IGlzIGRlcGVuZGVudCBvbiB0aGUgc3RhdHVzDQo+ID4gb2YNCj4g
PiB0aGUgVjMgYml0IChJQ0hfVk1DUl9FTDIgYmVpbmcgb25lKSwgc28gdGhhdCBzeW5jaHJvbmlz
YXRpb24gaXMNCj4gPiBhYnNvbHV0ZWx5IG5lZWRlZCBiZWZvcmUgYWNjZXNzaW5nIHRoaXMgcmVn
aXN0ZXIuDQo+IA0KPiBZZWFoLCBJIGhhZCBmb2xsb3dlZCB1cCBvbiB0aGlzIGFmdGVyIHJlYWRp
bmcgdGhlIHNwZWMsIG1vZGFsDQo+IHJlZ2lzdGVycw0KPiBhcmUgZ3JlYXQuIFB1dHRpbmcgYWxs
IHRoZSBjb25zdGl0dWVudCByZWdpc3RlcnMgdG9nZXRoZXIgaW4gdGhlDQo+IGNvbW1vbg0KPiBs
b2FkL3B1dCBoZWxwZXJzIHdpbGwgY2xlYXIgdGhhdCB1cC4NCj4gDQo+ID4gVGhlIGRpc2FibGlu
ZyBpcyBwcm9iYWJseSB0aGUgd3Jvbmcgd2F5IGFyb3VuZCB0aG91Z2gsIGFuZCBJJ2QNCj4gPiBl
eHBlY3QNCj4gPiB0aGUgY2xlYXJpbmcgb2YgVjMgdG8gaGF2ZSBhbiBJU0IgKmJlZm9yZSogdGhl
IHdyaXRlIHRvIHRoZSBzeXNyZWcsDQoNCkFoLCB0aGF0J3MgYSBnb29kIHNwb3QuIEknbGwgY2hl
Y2sgdGhlc2UgYW5kIHJld29yayBhY2NvcmRpbmdseSwgdGFraW5nDQppbnRvIGFjY291bnQgdGhl
IGV4cGxpY2l0IHN5bmNzIGZyb20gdGhlIEVSRVQgJiBJU0JzIGFscmVhZHkgcHJlc2VudC4NCg0K
PiA+IA0KPiA+ID4gQ2FuIHdlIGNvbnNvbGlkYXRlIHRoaXMgaW50byBhIHNpbmdsZSBoeXAgY2Fs
bCBhbG9uZyB3aXRoDQo+ID4gPiBfX3ZnaWNfdjNfKl92bWNyX2FwcnMoKT8NCj4gPiANCj4gPiBJ
IGFncmVlIHRoYXQgd2Ugc2hvdWxkIGJlIGFibGUgdG8gbW92ZSB0aGlzIHRvIGJlIGRyaXZlbiBi
eQ0KPiA+IGxvYWQvcHV0IGVudGlyZWx5Lg0KPiA+IA0KPiA+IEJ1dCB3ZSBmaXJzdCBuZWVkIHRv
IGZpeCB0aGUgd2hvbGUgV0ZJIHNlcXVlbmNpbmcgZmlyc3QsIGJlY2F1c2UNCj4gPiB0aGlzDQo+
ID4gaXMgYSBiaXQgb2YgYSB0cmFpbiB3cmVjayBhdCB0aGUgbW9tZW50IChlbnRlcmluZyB0aGUg
V0ZJIGVtdWxhdGlvbg0KPiA+IHJlc3VsdHMgaW4gKnR3byogInB1dCIgc2VxdWVuY2VzIG9uIHRo
ZSB2Z2ljLCBhbmQgZXhpdGluZyBXRkkNCj4gPiByZXN1bHRzDQo+ID4gaW4gdHdvIGxvYWRzKS4N
Cj4gDQo+IFlvdSdyZSB0YWxraW5nIGFib3V0IHRoZSBjYXNlIHdoZXJlIGhhbHQgcG9sbGluZyBm
YWlscyBhbmQgd2UgZG8gYQ0KPiBwdXQvbG9hZCBvbiB0aGUgd2hvbGUgdkNQVSB0byBzY2hlZHVs
ZSByaWdodD8gaS5lLiBpbiBhZGRpdGlvbiB0byB0aGUNCj4gZXhwbGljaXQgcHV0IG9uIHRoZSB2
Z2ljIGZvciBmYWl0aGZ1bCBlbXVsYXRpb24uDQoNClRoYXQncyB0aGUgb25lLiBXaGVuIGl0IGNv
bWVzIHRvIGNvbXBhdCBtb2RlLCBpdCBjYXVzZXMgaXNzdWVzIGR1ZSB0bw0Kc2FtcGxpbmcgdGhl
IElDSF9WTUNSX0VMMiB0d2ljZSAtIG9uY2Ugd2l0aCB0aGUgY29tcGF0IG1vZGUgZW5hYmxlZA0K
Z2l2aW5nIHRoZSBjb3JyZWN0IFZNQ1IgcmVwcmVzZW50YXRpb24sIGFuZCBhIHNlY29uZCB0aW1l
IHdpdGggY29tcGF0DQptb2RlIGRpc2FibGVkIGNsb2JiZXJpbmcgdGhlIHNhdmVkIHN0YXRlLg0K
DQpXaGljaCBicmluZ3MgbWUgdG8uLi4NCg0KPiBEbyB3ZSBuZWVkIHRvIGVhZ2VybHkgZGlzYWJs
ZSBjb21wYXQgbW9kZSBvciBjYW4gd2UganVzdCBjb25maWd1cmUNCj4gdGhlIFZHSUMgY29ycmVj
dGx5IGZvciB0aGUgaW50ZW5kZWQgdkNQVSBhdCBsb2FkKCk/DQoNClRoaXMgaXNuJ3Qgc29tZXRo
aW5nIEknZCBjb25zaWRlcmVkLCBhY3R1YWxseS4gSSB0aGluayB0aGlzIGNvdWxkIHdvcmssDQph
bmQgd291bGQgY29pbmNpZGVudGFsbHkgd29yayBhcm91bmQgdGhlIGlzc3VlcyBjYXVzZWQgYnkg
dGhlIGRvdWJsZQ0KdmdpYyBwdXQuDQoNCk15IHRoaW5raW5nIHdhcyB0aGF0IHdoZW5ldmVyIHdl
J3JlIGV4ZWN1dGluZyBvbiB0aGUgaG9zdCwgd2UgcHV0IHRoZQ0Kc3lzdGVtIGJhY2sgdG8gYSAi
Y2xlYW4iIHN0YXRlIHdoZXJlIHRoZSBkZWZhdWx0IGd1ZXN0IEdJQyBtYXRjaGVzIHRoZQ0KaG9z
dCwgYW5kIHRoZXJlYnkgd2UnZCBuZWVkIHRvIGRvIG5vdGhpbmcgd2l0aCBjb21wYXQgbW9kZSBp
biB0aGUNCnZnaWNfdjVfbG9hZC9wdXQgcGF0aCB3aGVuIGl0IGlzIGFkZGVkLiBJZiB3ZSBtb3Zl
IHRvIHRvZ2dsaW5nIGNvbXBhdA0KbW9kZSBpbiB0aGUgbG9hZCBwYXRoIG9ubHksIHdlIG5lZWQg
dG8gZW5hYmxlIGNvbXBhdCBpbiB0aGUgdjMgbG9hZCBhbmQNCmRpc2FibGUgaW4gdGhlIHY1IGxv
YWQuDQoNCkFyZSB3ZSBoYXBweSB3aXRoIHRoaXM/DQoNCg0KVGhhbmtzLA0KU2FzY2hhDQo=

