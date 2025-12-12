Return-Path: <kvm+bounces-65877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2C1CB91B6
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 94FF7300F64D
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B0731D727;
	Fri, 12 Dec 2025 15:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QR/oS4xq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QR/oS4xq"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012033.outbound.protection.outlook.com [52.101.66.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3CB313285
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553084; cv=fail; b=mXKF1dBQ6wal+R3m7qaQJnXhYu9qz/45+rZdN+dXbN3Zx/G5A2LTrWuo7nvKsSfNDa0HLtMujhIs9+9Nfw2uB798le2IPEZWXGWrTVyJYvw5xAdfr9MT2ljcDXuiajpnsNNeEpV4H2X5N6L+TTpZ1/eldBxUGjH8WrpJg5rbPRI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553084; c=relaxed/simple;
	bh=9JuWMH2eLVo24KIlAEMiedGIoYHaEMNyI0AYA8Gg0v0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k76Fb+7e50z5UhQB+o73UGba+0gs55APeC5u+drrjejTasfK9y1EuRuEOha6G3gaNe3S4+4sTeJ+gInKW2++E+VD2Ks91Tg0IqVhQldiLpkcRZ3jOmL6VLddhVNzKixcejULb4gxAred/righqzhlfKrBDk92TGZ+20+b4UBh80=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QR/oS4xq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QR/oS4xq; arc=fail smtp.client-ip=52.101.66.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CAMMZhjqoDqBkfUfYY3dAi0CTXvD3wHPml/rnGdAdgtZBFtoNf2X/L0p7T0qpXAcnPliNqVTBF7kBXqm+Kv0jgjjZVzyXgTc50SxWt4VSkw725OEAKO7Egump/XQUW6DclggTdFcO3+EtyZ0KX3Y7XR8flTVCjOmamjAXrMjDfoufJVUjfVVRBsKMTIgywg6cojmUYZi2mcT0w5VCuycvjhAZ5GWkL69YNt8WOIu+63kH7YzCVAxBdWtCkTluR0GrXbI1T49vd1BnrvCX3Ig5vdxS8RMpzrrVgjCaaW1bFfgA1BLGS7EpaVusDmByYmeNbF1GqhkZuwtjNpqzZoQkA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlgDns31DxdHVmqVubxBK4gY3fhW1oWLf/ohKdwhlGA=;
 b=KFM/eH2vpayhaklhKPYS3Ch2ReeffjJqVcOVt1JuQS4A2nkMI+kW1Mfper4pVDMG2/OiDn/IAi0jGN18xWkTyx68CTNNfD2SVAwqZv4ptITGsfRnqESYXDRJu9MElmlC6sWoQRZueF5s/2qps+2k58I8Tjf+tA932Z3mjQFRL2YpzO8xibJtGjk8xAN/Pllm5ndg0OfVgVTwbmjVn5mXsC1S4NJu+s7M8OiVNM8h9EXANlubVFRjSbRNg4XH5yHCv6m7uWDtZYaYGxSNnANrWYzTmYLg6yQrR/lArqUMwQqqhPnRGbIJU98+dnA1xkOd0VVg1UZD5v+F68hEH0CpCA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlgDns31DxdHVmqVubxBK4gY3fhW1oWLf/ohKdwhlGA=;
 b=QR/oS4xqOJKIZtM5dkx8RpqratPUDZyM4Z2fERiywPEJYpi+lX4AW6zCEZdkhNYh2KguSVlALpvGHkQjPxjnaSq9rNdPjzdR0Oa0Iz49rR1H6IuBdQev4pTpYSq4GKzM9oOa86tTBSDwLxo9dERkukhaXdBmlNx9QtZyE9w83HU=
Received: from AS4PR10CA0006.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::6)
 by AS8PR08MB7840.eurprd08.prod.outlook.com (2603:10a6:20b:52f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 12 Dec
 2025 15:24:25 +0000
Received: from AM4PEPF00027A5D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::b4) by AS4PR10CA0006.outlook.office365.com
 (2603:10a6:20b:5dc::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:24:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5D.mail.protection.outlook.com (10.167.16.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZKBF5lNggPwfkW3oAwaNOHeA0/pfwmCtvlq/tC+8NXbUR16U/Po8lhfCpQ+5TNtZkZdZIfsmhVM2ZqmgTu/urf4IaZLmLluJhORXXm94wBr/bNsAyflOBm+h5A6xu8xVGbzVG0vi27TrmRRhR8J6/miLpeA+2hiK7TSesvWz1hVdu6htRTSMKlekO0rWm4Lv02LVs9s3M2WcbLx0rs06Pjl/SobVNKYe2CjG9WPf3C/r+za9fQaNV/G2wJtYNAdF5hROln6AWPi8ZLHWPECsS3MzyMCMnoJy00lLDBsRqljbpKVRJVQpivBcW4I4L4l4pbe9hhuczBnLNhTDydA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlgDns31DxdHVmqVubxBK4gY3fhW1oWLf/ohKdwhlGA=;
 b=x2mP2iS5P4xZUT6Y+QxrCAQEHEqk1s860TJytnI380P9yqIUShnMkgWiPOu+7tp7z5y1BGQ+CoXaFF/jcpxVQfRTHWcy/fKQwTZFnh2t2nbVNM27GSaAxkBoIY+v76KaZXQy+s7gPLV4zpCpxTheJjCRDehcn3zH7ZmeVe/bumzaFnhN1+Of6XobBi4/Fe/9D62776GyIdy+vgZqDFphioYbFWjybYY1WKI8hcbPmU0wdmiqJUpW36ZyDXUlPSe7i5XE0beagw554rq7IE5vbzBGucus+v2rM4kO0GjIknzrGwUBS/qrtc3OBwUYhiyG4yKYi99UUlWi0eo2TGt6ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlgDns31DxdHVmqVubxBK4gY3fhW1oWLf/ohKdwhlGA=;
 b=QR/oS4xqOJKIZtM5dkx8RpqratPUDZyM4Z2fERiywPEJYpi+lX4AW6zCEZdkhNYh2KguSVlALpvGHkQjPxjnaSq9rNdPjzdR0Oa0Iz49rR1H6IuBdQev4pTpYSq4GKzM9oOa86tTBSDwLxo9dERkukhaXdBmlNx9QtZyE9w83HU=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:23:21 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:23:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 30/32] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH 30/32] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHca3sqOswV0bGDWUCYoVkka62APw==
Date: Fri, 12 Dec 2025 15:22:45 +0000
Message-ID: <20251212152215.675767-31-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|AM4PEPF00027A5D:EE_|AS8PR08MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 23fe111d-2b56-4831-f1f2-08de3992881b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?FJFlAtsqClq6L67rZ0xbs7UcLIYVA2YJsowtRUjR+wUMjzrNEjKRAKrpmA?=
 =?iso-8859-1?Q?6leUnkN5GoS3NC41QBFEYOU8E6BUUObb77SHVye93cKaGJvmLc7aB5st72?=
 =?iso-8859-1?Q?zyKDocVBGh6S8XZUFCP3A/9FximWop6l064LqnadU6ny43zwgXfJvru6pj?=
 =?iso-8859-1?Q?MyBu9+WDYfm2Av8KS83zybRq5XyXOorc9AriYaHr5jeV4uAl9gp4NDATfY?=
 =?iso-8859-1?Q?flYizCj9v/A/OT7svBXGo9rfs6ulWv8aXs1P2xGS553ekZ812L8rOQS0iH?=
 =?iso-8859-1?Q?Xs4D0vfj4rSTbjId6B7d0enogtLXZW6jFFmczPwuaTbVgSoDj7qRruGVmU?=
 =?iso-8859-1?Q?aAcVHvXBnXNa2o1S1S6bQp5TFFHp/0t2jh9xkBmtZJNj1ivqldRnj8J0mZ?=
 =?iso-8859-1?Q?BE1L8yPCFZCrctjLbd/vtWUkrZoB7yfwZTnZF1Oz/6gXsALGYF1/2QlXjP?=
 =?iso-8859-1?Q?GS4hJVkNNFZOoSFzQYd+UzNDBRGPbKD777Nvoa6nEWe3aoxscxHNoB+Vyi?=
 =?iso-8859-1?Q?IVrqXEputSO5VAadLy4ITZJOJ0nqVIO6A7B12obJAU2+Egb24npyobrABp?=
 =?iso-8859-1?Q?/gxN0sz9eH2FAADzgiwZr+yWVuvATiRVx9cw2LPKc+F0ew2PDg1d1CkH30?=
 =?iso-8859-1?Q?k4aNFK3yEN78qLykZAkzJkcTpaOEnMtEbcwhbL/cRjTn+aZ61+ljW/S7p9?=
 =?iso-8859-1?Q?wS1lkvL8Lk5UUJO/Eg/IABY+TYZhdaitp5+5X1lT5nofoYuLQi+ZuJVzBO?=
 =?iso-8859-1?Q?Rn1nKOm18ke4q1eel5MMNN1Ct8xo/jkegO0CBKqUy1tA2IN5AZjk4c2mQQ?=
 =?iso-8859-1?Q?jdmWnKm2ObKFXU1wm7J05B22vQeX0Lc7jKA8vOVY1xjORr0glAyhSliApN?=
 =?iso-8859-1?Q?+KVdPuLfTVQpn5PvRM8wWQ3fOuQkvRSzhUUTSCNGq3wOqQlQuLybtUoKoU?=
 =?iso-8859-1?Q?TF4nwOZhnio6y/ACGhCQB5rvqaFRDYJT8Yqrj3w4PLYoPu6FGyNU7Nmg/A?=
 =?iso-8859-1?Q?4xOt55fXGkJrgG/9GX6aQdEl83F2FPqTZcQHYHxrogIgpwzk2yFbBx0sSO?=
 =?iso-8859-1?Q?yoqZNiUkuGPLLTZs5J69IhtD7jRgW2B++6VQFlKTa7AjuwxOJtX70GXB4j?=
 =?iso-8859-1?Q?VWII8UmCU4+q+YgJy8Ed5H3VMV3XERaeNC0s8vZMmfT73V29WSOgKcN3Ur?=
 =?iso-8859-1?Q?3mceAPjEfOa2hQXt9Ysay+Uxrmdj036bp8EOor36ZQpS6vhh1YKgtvtRbf?=
 =?iso-8859-1?Q?N7IWci8/gBkdlC1/4gqASccEmZ4DVJC+6W7hHxvC2wdsH9h01R1IzZtTO5?=
 =?iso-8859-1?Q?9c32A4QfcD82GUMxeCe1OZuyJkMpOh6WfSEMh22NXRy5CaSODeZmMV4kAm?=
 =?iso-8859-1?Q?3LmY3Ezmso4GZqZCLjURYB4zZpiMUiZ/Rb/7wu95xCNgsWlZ+E/KqxLtJ4?=
 =?iso-8859-1?Q?qnejlt32TBAdKH8MusR5DmGh0t2W5DWPcjYirhEiau3xPTUjXxBQ+nVjrx?=
 =?iso-8859-1?Q?vwZC8EJY0ldyY3N5MAW1eMg0P/d4pR5wSFQlvTGNlshU5kml8Q0ThMYx6v?=
 =?iso-8859-1?Q?2vcGCJ9qYVY7LNuAJQum/HHUSVBf?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9edb9214-f71b-45d8-67b2-08de399262c0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|35042699022|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?qcQGI2vh6So2sPYvyC7UrAUi0WuBSO0MCZOAYx1HIAF773uIpagSSjS/vK?=
 =?iso-8859-1?Q?WVjEnjqwoQRQstAK+3HOVNM5pXt5BTM6dGhRUZPNuxW/AU38BqhB88lJWH?=
 =?iso-8859-1?Q?fJdeN+DbSnwkLQMLaf4XmHBdQg9RLcNfKiVDzekPEHmnObGS0cNhCVO7CF?=
 =?iso-8859-1?Q?W6oo/CNdZBnq3DvQqj94USIfwgCvkPxUKO2M+dZxIdSGRlOciQ6HVOop7D?=
 =?iso-8859-1?Q?0vOz9RC3SkwSkyT2knpGSJEKJCrh4pn81LM2apE9uWrzO+5dRC5urHNmXD?=
 =?iso-8859-1?Q?65NQOrEFkSFLqRNfgSJl/3fydpU4zqXJzouMILqRd6Q2rgRkfxHlmxJGDh?=
 =?iso-8859-1?Q?RpolD/XElrSau/xxlSPOWD2EHc/D/geHzgGW1q9koBcJSwO/vQB3ylALa7?=
 =?iso-8859-1?Q?8HZLeSh1hcy9/VQReXqA2gyE0dV1Gug/OZ5Qhh0xfM4otpyT4FHzhmh8+w?=
 =?iso-8859-1?Q?i3lIRRY5hnBnpfgrIi8OHOWsxyuf5raBHL8TbIKyH5/eRlosG6Sok9bv2K?=
 =?iso-8859-1?Q?5LiQuMHUuFYOoUreyHXxMER+pYBFkdQ/K2mTUvdwc7UjvmSY70DgNviYTL?=
 =?iso-8859-1?Q?GJF1QqmeeY+RgUCnsfrdwd8+uFhG8ElT5rc/1R6P39Q/J45fC3ICipU5I3?=
 =?iso-8859-1?Q?Hw+i+INTRx1lVmwSNDICiMb/oezR7RxEht8U2XKcDaRNA2SUO6dQuE6ytm?=
 =?iso-8859-1?Q?mUrXOU/xqHot6hSEnjXU1vG7T/rhIGSFZjbO0nj/a8kKuxEF5RoN92lUTL?=
 =?iso-8859-1?Q?nmwIbUc1csAcOS3ti9aCFvUnO6Em5Ed51vXS0GWKBBCzdm3blc8zP/nW7X?=
 =?iso-8859-1?Q?aYkyuIgIyU4DcQyz5iVWsm6PyuJuZ1Yi2uI3+KIbLVdU27yjAsoBJCnCm8?=
 =?iso-8859-1?Q?ethc65flssJWqddRCrxFm8zfAsMs79RBHVcqz/0amQdt01MOzHSPDS/8El?=
 =?iso-8859-1?Q?b/+Z/YAIhSo+9jNI8HXkR9l+6FdRFyBuLZP1/y3qw+QnD2AEnwFwUw9JDt?=
 =?iso-8859-1?Q?50JrO4zT+i2qOhi1kqahkrsnxJpX1ws3Os3R9BDLBDXDINSQUNZi0iZnUs?=
 =?iso-8859-1?Q?rs99h24igR/21+xP/Ky0EkCyDN8uXaFMSzDNmACI/oHWFP2BFBZSAD5h69?=
 =?iso-8859-1?Q?J84ZhVtB3udFlKh5OOUtD2d+TJA47rSUs5uZH3hjsRnXuEjDjcoyu398os?=
 =?iso-8859-1?Q?q226sCJOX27tgsTD1PtnLsbFcrArf/xIoIoITv8ye6WNpNkfbXpShxqvvz?=
 =?iso-8859-1?Q?MnJ/VnN1T7pYux98zfYjoffW6rlnelwtKGQwq/cGl8CyTmE8Wlwlhf/bt0?=
 =?iso-8859-1?Q?Ly6csZRWQBCtnficRX7ZsBMhRrnEQssEIRKi/7Ele5P6GYC6mZ90abLmJ/?=
 =?iso-8859-1?Q?OUw6owNYI5aX/u5FBx8AplRlOLqHun1rrn5Ktm1xpWJoSWsQU79S2JA/H7?=
 =?iso-8859-1?Q?ZnEo/krjqoCn3nq76YtQvCpsQYVvOqgR8kSDq10BZyxNR8gqVdLSjarPSH?=
 =?iso-8859-1?Q?PmbSteAjLLaGVfvD7p+9JNQh8RAkXHPugyl3+LxPz8Ti51l435JZHAEzcq?=
 =?iso-8859-1?Q?rd1UoHGL6esEOCBgOrw1gyiALsa31Xri8bLxHJrVu2CNlldQzkcYwE1HJM?=
 =?iso-8859-1?Q?xud/499OmXiT8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(35042699022)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:24:24.3819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fe111d-2b56-4831-f1f2-08de3992881b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7840

The basic GICv5 PPI support is now complete. Allow probing for a
native GICv5 rather than just the legacy support.

The implementation doesn't support protected VMs with GICv5 at this
time. Therefore, if KVM has protected mode enabled the native GICv5
init is skipped, but legacy VMs are allowed if the hardware supports
it.

At this stage the GICv5 KVM implementation only supports PPIs, and
doesn't interact with the host IRS at all. This means that there is no
need to check how many concurrent VMs or vCPUs per VM are supported by
the IRS - the PPI support only requires the CPUIF. The support is
artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.

With this change it becomes possible to run basic GICv5-based VMs,
provided that they only use PPIs.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 39 +++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 1a6c9fc86ed07..d74cc3543b9a4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -10,22 +10,13 @@
=20
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
- * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
- * registers a VGIC_V3 device.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2;
 	int ret;
=20
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
-		return -ENODEV;
-
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
-
-	/* We only support v3 compat mode - use vGICv3 limits */
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -33,6 +24,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.has_gicv4 =3D false;
 	kvm_vgic_global_state.has_gicv4_1 =3D false;
=20
+	/*
+	 * GICv5 is currently not supported in Protected mode. Skip the
+	 * registration of GICv5 completely to make sure no guests can create a
+	 * GICv5-based guest.
+	 */
+	if (is_protected_kvm_enabled()) {
+		kvm_info("GICv5-based guests are not supported with pKVM\n");
+		goto skip_v5;
+	}
+
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		kvm_err("Cannot register GICv5 KVM device.\n");
+		goto skip_v5;
+	}
+
+	kvm_info("GCIE system register CPU interface\n");
+
+skip_v5:
+	/* If we don't support the GICv3 compat mode we're done. */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
+		return 0;
+
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
 	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
=20
@@ -48,6 +65,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return ret;
 	}
=20
+	/* We potentially limit the max VCPUs further than we need to here */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
+						  VGIC_V5_MAX_CPUS);
+
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
--=20
2.34.1

