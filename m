Return-Path: <kvm+bounces-65851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B405CB91A8
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10D1A30A2156
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3587131AAA0;
	Fri, 12 Dec 2025 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FJ/oC3Hs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FJ/oC3Hs"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013017.outbound.protection.outlook.com [40.107.162.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E993115B1
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553029; cv=fail; b=sUC3MnewLfKG1uKceV77MictiRaOpQek6xVxOYcp9KvlRcvds0Y9ThKu4OTiFypxZrWYpnSoLpfWCvvK2J/Qb6KXwpD/eieOXrPJNhA/nzNS+PfThFER9JddfV7fMkZI9ssL9Ji9lztrkxzfWKQbXYhWHtqi/LdlQ5PBpIoaUjY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553029; c=relaxed/simple;
	bh=iqKoVDpuBU7VNB9pUL8wAVUyCjd1XuqMZsFXC3bwTqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i5MP9C7Ky5CwIzFlj77CwVW/ik/CBYijKcHOzUXIkG3lY7WVhj4k7Oj3fXlZMQ7QWcLt33MULoqkGzcD0FLc5cFFBAc8Rt9xLHZN9Mi3i6tlryPd3qzll4tbBQhHAILzPtc3z/BXFnMS7clXRiNPBGSmH4xFwiIY8snCegXsA3s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FJ/oC3Hs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FJ/oC3Hs; arc=fail smtp.client-ip=40.107.162.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vN5TXNxiR9CMSd3cQfnLuofnn3YdQwLrSJOFBBnNPQRDXafiJNGWuZHGzAqSLHvVxKV7SpgcB6bL17xoWNWRQUESJKFk+TkKZjpYSWuApFipp+RwCZB3XSo3v1FmT3oKklvCIKYxAFys0sirX2aBuuEuZx1z1hszg8bdEjBXTjHmpi7YCV37iJiAMJqPSsSPmn5VCTZL/58lVbBXedoMEbJk2BnwwMDtpQ4eJfRx1H2yhvLmHAHG13fyxrwY8OQEgGFFmJPz4monFvZDrq0u2JioRyaCb4/KwgE4gNoT3Z72aQ3FyAHgk/aOGvTu5uoVsMXlrFeBJGs4s0QXJV7xWQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=jk/3y7sPgvcCETQFf0hNAvJzUFRw5mLDwOXJDphtduhrMMjlmybYYHtS1WT2oYQ85Me6MqlZm/x8Zesrt+r3KpfnyqqQBqA0wzf7PHrkcmFo+EwHiIFhQ+cA7GQC49L9XFJb3s1tpz3pp3GwndBAZc1O7+oFuVzg9sCnrKYnHJzMcERYAk2DOVxbQh7yL00tZAZNciaIAjmmJGXvfLrcLcQrrLZA73PRjgpPJB2AkbHWW0VvwgPXl98v/WUzMbcvIULMTUJTyMm4AfqLzdYaGYCFy962m/+PQudj0kHgb+Jl0G7ysVB7Wme87FZiZvX4zTsceAmN5FrFBRuUpDsZAQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=FJ/oC3HsDp1NOcnoLDBqDWRH2A/bmnv2Eax+eRmCQqKKIeip+VMuR+SJeuHVJZsBXLk4tcA0rnZkLn/T7RZXdxGC1/HCUERK5/mrNnZCRLNhY2N8cM+KgxYGJjmQ2IbskHvzvvr25ABUxZpeUgDNf6EuerZoMgJtelTnfWxlslM=
Received: from DU7P194CA0016.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::19)
 by AS8PR08MB6040.eurprd08.prod.outlook.com (2603:10a6:20b:296::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from DB1PEPF000509EC.eurprd03.prod.outlook.com
 (2603:10a6:10:553:cafe::de) by DU7P194CA0016.outlook.office365.com
 (2603:10a6:10:553::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EC.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Fri, 12 Dec 2025 15:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zU9WBE1lXMm75BBCk3PoLMfTQvyoBZQeyRxMHOANJA/oqak2cSaIEkCVlHERL4oSv9WrSh4Z8QGJHsQTBZHNzSJWv4D8MXcB89xr5laxUt1t5ofDRiuMH87iE11kyr6OxI3ey49zIo5FUkDAZaKlG8i+KfHgQ+Vwwa9QnFHPX5t5WtEaC+hBYjxZyrqwa21Y89NCJrFbAP1Sxw065Bfw5Z0S/Q1L2JjTCMaLxv4FqQOJuoaOfY6rz0kdOzuGBOx347U1EgYZY/QmNMCGryoc3nWJvCHCxrl0c3gXX0orCpCeEEtT2ctBhNoVbz4/F+A5ag63EmdApF/Zx9XBNoLIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=mTpd0bDTjXmH+gkGh61pBb46woLF423rviOYjG09f1lqUl5td0bhTy8lR2TIhqh51DgAY1Durn0yj5Kb5SoFk6y12lJuKP82Yy8ulgh6qE2z6ptjqRuA+8U2mN7nc/Jd+eiy2fDFxIpe/atI+BZxoHYyJOcIC2bnXHntQ7BfyKVf0al6P68uUUgNmMPqLpH1RlCOdZpmcs31v1QPpx4TvuRpiORRekQ1ZtYvUNUnKlOjtFLsJv5SzVTHKDsxIHx7FPrbUN7t5rHtFGTAiUYf8ORyso4roMDgIG+uL1w0/XZZXIJHo+lxFxmKmASmn4lv11H6c+h0YG/sGcsMqrp5lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=FJ/oC3HsDp1NOcnoLDBqDWRH2A/bmnv2Eax+eRmCQqKKIeip+VMuR+SJeuHVJZsBXLk4tcA0rnZkLn/T7RZXdxGC1/HCUERK5/mrNnZCRLNhY2N8cM+KgxYGJjmQ2IbskHvzvvr25ABUxZpeUgDNf6EuerZoMgJtelTnfWxlslM=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DB9PR08MB9756.eurprd08.prod.outlook.com (2603:10a6:10:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:22:35 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:35 +0000
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
Subject: [PATCH 01/32] KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP()
 and co
Thread-Topic: [PATCH 01/32] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Index: AQHca3skDRyz3uyPD0Khj9Kmigkc6A==
Date: Fri, 12 Dec 2025 15:22:35 +0000
Message-ID: <20251212152215.675767-2-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DB9PR08MB9756:EE_|DB1PEPF000509EC:EE_|AS8PR08MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: bef9cc1a-9f19-4b71-2c81-08de39926e87
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?RYi+1tnbG5j4jcr5PwJDfg7C9NPaK4Lk1kSGSXjN0t1dus8AlQRcEa9qQZ?=
 =?iso-8859-1?Q?kHJEdZQ0psM+WYSm9rPvOiIro/x2ZQ8KVO4I9QLcS2rZM0ocG/TAAMBtpR?=
 =?iso-8859-1?Q?4DDH7SW3DcZ34I6ACFTPUyKtQyxHD+AV5xRxZ/tY4wchaFZtIEtflxuIXo?=
 =?iso-8859-1?Q?PmXwinYfLLbox4jc7n2ZFIIIzVpN7jOUhBAx79DpbIx6U4ekMtCCVp763E?=
 =?iso-8859-1?Q?6b6QRIkzRuHkhKSoaW0ZiQBxxfqeXecQu0IfKsoC2Rgx5TN3xK3V3mXtNe?=
 =?iso-8859-1?Q?TT1/rki2kISklU2s4U6ABKSS0VqXftTw3yq2rVoHQkCvy9P4FzJbektxwt?=
 =?iso-8859-1?Q?XihW/d2vKxeK0ngzwFdU9Gl41xW/TgUkJDNeviECWJTLlHXYw8FuJXRpPY?=
 =?iso-8859-1?Q?1dXiRD1bUIB6wD5TX3N5jrPhQQVybH+ETJ3EmFGw80IJGcgNP2syG/vW+0?=
 =?iso-8859-1?Q?XFuPJbgHseRfFlrI7DioL70dEoyTB1C+4b92Sq/It/JxFJx4u/GoxCuK27?=
 =?iso-8859-1?Q?E8xnwYDWHoFnfthpFuOKCFzRr6jKhlQ4ScTZpcOkJnU/pi8huqNuSrZW+N?=
 =?iso-8859-1?Q?z1jmeKaINrprXNPf7IdLMRjs/TXFm5gWTx5DUo9Pn7W6MjjImyDQg2Jr7Q?=
 =?iso-8859-1?Q?UqGU9x4Q/HwcVM+NV1HMF+MREoqp4Y78Yi/W4+ulzO0y89uSgYo7WYsk0/?=
 =?iso-8859-1?Q?1LcHRYpz7otr6OlVeq6awRplF6fJHXCpfUapSlDV+amYG3ApH8TK3pyVz4?=
 =?iso-8859-1?Q?/28Flfi/Mq+pAvzAh2a7zrOpt8fqzY6eoyJoATsRLTsRZTVeVvSgliB0YO?=
 =?iso-8859-1?Q?Jg9N9g1NAnWs5kvdUA82soZzPWd8QImgbDtm84Wum3Vko3xFHYFZi0Im/p?=
 =?iso-8859-1?Q?Jf5aXztgg+Qb1UMhqu8g8Sy5CuENxKJoVsTmDuc2rJgROfSIJChLyKbK8U?=
 =?iso-8859-1?Q?F65wfFV/zujZ3Xm6bmKDPe9ZvnIbGwIjbeEm6LYxQBcp7hS98CPNy40nFp?=
 =?iso-8859-1?Q?trx/1fFNmZHjQ4JFSZ+rg47TwvyZqybVlTe+4dEoM30HSf2FHKTmxhAVrQ?=
 =?iso-8859-1?Q?JtWKn6aXXS9oY3bOa/QC4d5lRjH3lNJOkeDSIYlyLQw6o8UfbzyEynxOv/?=
 =?iso-8859-1?Q?4hrgZnWe7oRX9vURrum9aI1wGX6NHlpPyhtUxviLJAeu5SrUnE9C2lYnD2?=
 =?iso-8859-1?Q?PFajc1lGq9/FehP7v6LAWAYayYUcKI5E/1FxuCu+DgiDqOFbOrFGuoSC/Z?=
 =?iso-8859-1?Q?LLzJHsJ+r8MpUZx0M4h9CpO0Dy4FUnjiKDqavSZDWzT3YeBbzy5LJQvCHM?=
 =?iso-8859-1?Q?aGjkm/pOvslsOalJ2458is+HzUC9rPEeS20C+RWYSSGZjMgRfyr5+SdSLb?=
 =?iso-8859-1?Q?p2m55YQcApSAuugr8BB6Ig+VxX6fB+lhcBvJVrsHryaLhfgnBqVu6cVaOF?=
 =?iso-8859-1?Q?Sz2/q+c/357YSZD+8Mhkg7uVd95b0lWeAMHwKLnV0HxKpYjVegVo3tZ7nr?=
 =?iso-8859-1?Q?gjgdvEhbpPVo0LRXBkUsOJJYZzWG+/x1ic9VxXSM6OXE85UO/y4N/Fe95X?=
 =?iso-8859-1?Q?tuLrR1/IMMcftMvgGQpVOqaSjUV9?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9756
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	168f780e-f22f-4c46-fd22-08de39924722
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Zft6CT+zi9ITHjEeWSmA9EIyG0X9dEo6J+1WKmGwqqIWVXCtZai/m9y9uC?=
 =?iso-8859-1?Q?g35uTJtRadUFEp2tIU8k/yojbnIN0EXfZWIBqsecKO79G1aFG+0BDebCO7?=
 =?iso-8859-1?Q?eL/OIDzKKK+cIVAwySrBmOo/Q4nsf3mU0clq6FrcfXPtAw7Wk6IoFcuGHn?=
 =?iso-8859-1?Q?iUhoeQTQRyqaNP7mdzXfB8L6/YsLv3DXonXY6vsqIWs4tr+y9IgOAfLGfZ?=
 =?iso-8859-1?Q?xbPn+VMn7Uo3nwGa7xoNCPWpcIGct6a223p8vbq6N3UISWJQucxUGP+n97?=
 =?iso-8859-1?Q?NxwGpcZbuUAsbugY6da05uKXSvaRXFY6GKXFwyFkTgt43moME3t7OMsFsj?=
 =?iso-8859-1?Q?jf1Bc9b0OocKK2AxpNKcVTNYsHM2i3iBO/FyUrkSRi94EtojRX8lx3+awy?=
 =?iso-8859-1?Q?LJ8Ai2rLpzaf4rlogV7b9hDCzzaNyHgsq5/Kf1ywWFkKGEHAhCUZGsnxSK?=
 =?iso-8859-1?Q?UA57+Kal4J1D8Rjb/O/pefN5fbHkNCcY5rHEUf5881IdV0mO2UzP8tYcBW?=
 =?iso-8859-1?Q?ieNb/zH/Do7zebwNFqZiN2ozT04lrMYsJYu0KNH1lHw9NEaLoaGbfWGYd0?=
 =?iso-8859-1?Q?GRoIjBmKf1G3hgOvL7IUtLfG667O8Fwny/o5h+VscelUgbVuHzavfhxwWM?=
 =?iso-8859-1?Q?BDrpWDJQk5YKkQrneAIlQCIM0bdyJKGGHnwj66KY2LWRihs/T0mE04ZQzq?=
 =?iso-8859-1?Q?ATJ0N3ZemrMP3YKyweHtidWjaMNfOq1UshMeaatwU7QIpTvmtF9dWqquxe?=
 =?iso-8859-1?Q?PWug+Po6DBQl81vSVtxbP6ETHGJr3mlXB5DHxCxp3rq9f3Pb2oFPuR912s?=
 =?iso-8859-1?Q?HD9f2cY6fbabxcsjMVs1zsEnYT2xYNS4weBijMz/qZWd6bUKgaVYRBph+o?=
 =?iso-8859-1?Q?/5e8U+8+ZLV/X52qffwqnIVtiEvXCUOATUrZwf5TxfuiU+WXN/OC27eHzy?=
 =?iso-8859-1?Q?pArAfKuVAOSHBUbIjDjTyjNMrmSKwEZyOhl2oOGvkLdBsrvnl4n/KKtmEK?=
 =?iso-8859-1?Q?ooP7Mtvk2KkFPBbOmeVzuzVdZEyE5OQg2FZan5w/l/C4PM1vdrAWVn1/g2?=
 =?iso-8859-1?Q?NXU12iNWtuHjTwEVfu4lCyqCbUzvbkHDqSgOOU/gc+k07s283+JkkzdffO?=
 =?iso-8859-1?Q?5yBnUYiTJoBBQamsiEk7kuO+WBA1SjQcdNtUTusePp768E7Lrj7UrOoUdW?=
 =?iso-8859-1?Q?C5dlVBYjygY/tjHFfp+iavYEEjp/TtisUQaRhc/+psNQm2ouodlzhSpURb?=
 =?iso-8859-1?Q?0jlYop+IaPH1V3hLnVkR7xusQ9GMfLKDRDa0/y67qgHQEIho+/G5VUkHab?=
 =?iso-8859-1?Q?HQXzc064kZV+gbAQuD6DXFa40WMP3F79r3iDUTVZOd5/zM5Uu12H/e7TGd?=
 =?iso-8859-1?Q?uE0Y7PmZZ3+k5tFU+WmETFPIH3kYqwdKxpIVaDDqjEtOTcxWqdISBKwLNT?=
 =?iso-8859-1?Q?kopdrz4g0wcpU+Jkmj81JYl4jF1V4AjBI/FsnaebgRBS3aJbonAgOcMG6N?=
 =?iso-8859-1?Q?gF3KzpulE3AIu9EnaQ8MlPYoFWjsB8uOG9DB7Ij1/TzytGLmZvhTUGIX00?=
 =?iso-8859-1?Q?fyd8dkmzikT0jW9f5p9PapMj3OgE9q+oLo5UJxwrYIWwP83s2ORyNP50LY?=
 =?iso-8859-1?Q?m9QN/DsjB7QD8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:41.4401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bef9cc1a-9f19-4b71-2c81-08de39926e87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6040

From: Marc Zyngier <maz@kernel.org>

None of the registers we manage in the feature dependency infrastructure
so far has any RES1 bit. This is about to change, as VTCR_EL2 has
its bit 31 being RES1.

In order to not fail the consistency checks by not describing a bit,
add RES1 bits to the set of immutable bits. This requires some extra
surgery for the FGT handling, as we now need to track RES1 bits there
as well.

There are no RES1 FGT bits *yet*. Watch this space.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/config.c           | 25 +++++++-------
 arch/arm64/kvm/emulate-nested.c   | 55 +++++++++++++++++--------------
 3 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index ac7f970c78830..b552a1e03848c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -638,6 +638,7 @@ struct fgt_masks {
 	u64		mask;
 	u64		nmask;
 	u64		res0;
+	u64		res1;
 };
=20
 extern struct fgt_masks hfgrtr_masks;
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 24bb3f36e9d59..3845b188551b6 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -16,14 +16,14 @@
  */
 struct reg_bits_to_feat_map {
 	union {
-		u64	bits;
-		u64	*res0p;
+		u64		 bits;
+		struct fgt_masks *masks;
 	};
=20
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
-#define	RES0_POINTER	BIT(3)	/* Pointer to RES0 value instead of bits */
+#define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bit=
s */
=20
 	unsigned long	flags;
=20
@@ -92,8 +92,8 @@ struct reg_feat_map_desc {
 #define NEEDS_FEAT_FIXED(m, ...)			\
 	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
=20
-#define NEEDS_FEAT_RES0(p, ...)				\
-	__NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
+#define NEEDS_FEAT_MASKS(p, ...)				\
+	__NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
=20
 /*
  * Declare the dependency between a set of bits and a set of features,
@@ -109,19 +109,20 @@ struct reg_feat_map_desc {
 #define DECLARE_FEAT_MAP(n, r, m, f)					\
 	struct reg_feat_map_desc n =3D {					\
 		.name			=3D #r,				\
-		.feat_map		=3D NEEDS_FEAT(~r##_RES0, f), 	\
+		.feat_map		=3D NEEDS_FEAT(~(r##_RES0 |	\
+						       r##_RES1), f),	\
 		.bit_feat_map		=3D m,				\
 		.bit_feat_map_sz	=3D ARRAY_SIZE(m),		\
 	}
=20
 /*
  * Specialised version of the above for FGT registers that have their
- * RES0 masks described as struct fgt_masks.
+ * RESx masks described as struct fgt_masks.
  */
 #define DECLARE_FEAT_MAP_FGT(n, msk, m, f)				\
 	struct reg_feat_map_desc n =3D {					\
 		.name			=3D #msk,				\
-		.feat_map		=3D NEEDS_FEAT_RES0(&msk.res0, f),\
+		.feat_map		=3D NEEDS_FEAT_MASKS(&msk, f),	\
 		.bit_feat_map		=3D m,				\
 		.bit_feat_map_sz	=3D ARRAY_SIZE(m),		\
 	}
@@ -1168,21 +1169,21 @@ static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_E=
L2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
=20
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
-				  int map_size, u64 res0, const char *str)
+				  int map_size, u64 resx, const char *str)
 {
 	u64 mask =3D 0;
=20
 	for (int i =3D 0; i < map_size; i++)
 		mask |=3D map[i].bits;
=20
-	if (mask !=3D ~res0)
+	if (mask !=3D ~resx)
 		kvm_err("Undefined %s behaviour, bits %016llx\n",
-			str, mask ^ ~res0);
+			str, mask ^ ~resx);
 }
=20
 static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
 {
-	return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
+	return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask=
) : map->bits;
 }
=20
 static void __init check_reg_desc(const struct reg_feat_map_desc *r)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 834f13fb1fb7d..75d49f83342a5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2105,23 +2105,24 @@ static u32 encoding_next(u32 encoding)
 }
=20
 #define FGT_MASKS(__n, __m)						\
-	struct fgt_masks __n =3D { .str =3D #__m, .res0 =3D __m, }
-
-FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
-FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
-FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
-FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
-FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
-FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
-FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2_RES0);
-FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2_RES0);
-FGT_MASKS(hfgitr2_masks, HFGITR2_EL2_RES0);
-FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2_RES0);
-FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2_RES0);
+	struct fgt_masks __n =3D { .str =3D #__m, .res0 =3D __m ## _RES0, .res1 =
=3D __m ## _RES1 }
+
+FGT_MASKS(hfgrtr_masks, HFGRTR_EL2);
+FGT_MASKS(hfgwtr_masks, HFGWTR_EL2);
+FGT_MASKS(hfgitr_masks, HFGITR_EL2);
+FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2);
+FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2);
+FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2);
+FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2);
+FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
+FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
+FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
+FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
 	struct fgt_masks *rmasks, *wmasks;
+	u64 rresx, wresx;
=20
 	switch (tc.fgt) {
 	case HFGRTR_GROUP:
@@ -2154,24 +2155,27 @@ static __init bool aggregate_fgt(union trap_config =
tc)
 		break;
 	}
=20
+	rresx =3D rmasks->res0 | rmasks->res1;
+	if (wmasks)
+		wresx =3D wmasks->res0 | wmasks->res1;
+
 	/*
 	 * A bit can be reserved in either the R or W register, but
 	 * not both.
 	 */
-	if ((BIT(tc.bit) & rmasks->res0) &&
-	    (!wmasks || (BIT(tc.bit) & wmasks->res0)))
+	if ((BIT(tc.bit) & rresx) && (!wmasks || (BIT(tc.bit) & wresx)))
 		return false;
=20
 	if (tc.pol)
-		rmasks->mask |=3D BIT(tc.bit) & ~rmasks->res0;
+		rmasks->mask |=3D BIT(tc.bit) & ~rresx;
 	else
-		rmasks->nmask |=3D BIT(tc.bit) & ~rmasks->res0;
+		rmasks->nmask |=3D BIT(tc.bit) & ~rresx;
=20
 	if (wmasks) {
 		if (tc.pol)
-			wmasks->mask |=3D BIT(tc.bit) & ~wmasks->res0;
+			wmasks->mask |=3D BIT(tc.bit) & ~wresx;
 		else
-			wmasks->nmask |=3D BIT(tc.bit) & ~wmasks->res0;
+			wmasks->nmask |=3D BIT(tc.bit) & ~wresx;
 	}
=20
 	return true;
@@ -2180,7 +2184,6 @@ static __init bool aggregate_fgt(union trap_config tc=
)
 static __init int check_fgt_masks(struct fgt_masks *masks)
 {
 	unsigned long duplicate =3D masks->mask & masks->nmask;
-	u64 res0 =3D masks->res0;
 	int ret =3D 0;
=20
 	if (duplicate) {
@@ -2194,10 +2197,14 @@ static __init int check_fgt_masks(struct fgt_masks =
*masks)
 		ret =3D -EINVAL;
 	}
=20
-	masks->res0 =3D ~(masks->mask | masks->nmask);
-	if (masks->res0 !=3D res0)
-		kvm_info("Implicit %s =3D %016llx, expecting %016llx\n",
-			 masks->str, masks->res0, res0);
+	if ((masks->res0 | masks->res1 | masks->mask | masks->nmask) !=3D GENMASK=
(63, 0) ||
+	    (masks->res0 & masks->res1)  || (masks->res0 & masks->mask) ||
+	    (masks->res0 & masks->nmask) || (masks->res1 & masks->mask)  ||
+	    (masks->res1 & masks->nmask) || (masks->mask & masks->nmask)) {
+		kvm_info("Inconsistent masks for %s (%016llx, %016llx, %016llx, %016llx)=
\n",
+			 masks->str, masks->res0, masks->res1, masks->mask, masks->nmask);
+		masks->res0 =3D ~(masks->res1 | masks->mask | masks->nmask);
+	}
=20
 	return ret;
 }
--=20
2.34.1

