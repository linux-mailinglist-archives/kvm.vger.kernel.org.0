Return-Path: <kvm+bounces-68382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B2389D38462
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFA7A31778B9
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D663A0B2C;
	Fri, 16 Jan 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OR4G+HOA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OR4G+HOA"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011024.outbound.protection.outlook.com [52.101.70.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1BC346FAD
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588117; cv=fail; b=OjMXdIAHWWb1CabRjRlkKQ9Fdp+5kVgIDgTePnL52gse3VZkBU7OBwZt6GTh2GfmOOpwlSyPW9tco+buLkrGZIm/RFCFYz/2R3uSPEvZWyTitFHprYAVbzthcnscni/r+mn/qGT/XJ8sqhl2tikBFc2i9eo70vDheN5gCteJahA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588117; c=relaxed/simple;
	bh=js8XBCAYihZe6JhBAp+G95dbbMke0YM+EyFz926ebKM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V29EYhYfQIwdPR6nGJqzrdDhuiexek8MKXhhuFe8+VwcKYq7uvFLTRoEMSNtOCSS+oxjbj/SeerexnTFJRnFPCH3na7HZK2T0H9QwmQA8JPgKbQys+mFYtxrxOKI1tcaj7limMnfZkS5ZaVJkjuBYMFkWvR0SBz52xVY9v5tpOI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OR4G+HOA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OR4G+HOA; arc=fail smtp.client-ip=52.101.70.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=O58mqEDSO+iWes+StAZow0LAS+0uLrWXA34DH3L6EOZB01EEP00WNOYHYl2pyf/d1iYk3pGyOLs7LCCAt3RGpEvwP7jsFuECTCzU3KTq6PXtG8dq5+nyEUaBpckfHCVVcan0Vc670+//KFgnU6AjiyARXzZi2eWvBNFA88Jc+WwRs+RE1LQZHDl5Iqth2L89mjIGfTSkkeqNYG+Pe/m/ZChw9UL+mV7VKl9R6lLm30l4MlWAudnMUjD7bWV8qnyqHDYTe1JJQez+Fo6YTF/ZqHFY3DUWn6cP/myFDsqxmVlJX8pcCF/Ze28fuLYDAKHIn4R/hS40AveBHuMOn7h9TQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ut8XiuxRUDxheTpxyMMDDcjqp2MpbYXhtKbLzCJGR0=;
 b=u331pJi5AN0GciNCIZCEw028JHo+DivyWPDHyBYKmZfvWq5tGFcJqW4M48vt/2dEEdsTYYrZpW1Dfd1bbZpgcxveagB4zfUIYkwhhXfhOFo528RQfRD6snPLlwj4GqRPMeN3dW4+pjOlEwsFI2eAfJPWSg4itvrGtmwDVHYErTQ9gXXfH5NugwUU3dIU4WTvrZxjCQXwPQm59Eu1d7ZWtziy79dB4B4YK6b26NfNn6kZzOSizMV4FSkZBNWvXNzF6WV9rMClCoaqVqXO9drFe7V5SKxFy/0OcbZNTmJ3tQLSYjnWq78cCsA08yzP9teevgD4kejMq7+L5x4VFo9UMg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ut8XiuxRUDxheTpxyMMDDcjqp2MpbYXhtKbLzCJGR0=;
 b=OR4G+HOALWdUMcfF9U82WGwyhIAHkCXMKYc/88HfreH9gkTtttrL0wjErpKQ8NZcFR2eOcWvH/Xcf9BB5GrFqje7Z26/yEfWsmDAPV4XLDRBkWax1oB0LDVcUDwQVbj28FOX4+KAh6kqVHoNrAczXyMSWK3bSIIk1ykBw4lzVO4=
Received: from DUZPR01CA0186.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::15) by MRWPR08MB11760.eurprd08.prod.outlook.com
 (2603:10a6:501:98::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:28:31 +0000
Received: from DU6PEPF0000B622.eurprd02.prod.outlook.com
 (2603:10a6:10:4b3:cafe::4f) by DUZPR01CA0186.outlook.office365.com
 (2603:10a6:10:4b3::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:28:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B622.mail.protection.outlook.com (10.167.8.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:28:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeNI2En4IN/Bj9cjFi00VSM57DtdXnMaWDSNyTSUhzQSt7wK1/w+sPjj9Ly2bqcV8yJxUF2upLTZLziWpr8B6Skb+5UeRiHqwvO4GHAiQCIl8ZVMs4O8sOdyTWORqI2E6fVYmwpMBT9JoRjBq25lk15jHdpbdC4qYZjnfVtzTCDHxvEmhFcd43qON2GGH97rLBB0LH80VFaUHHME3ll4+R80BwIbmt0ylxtRAPwAgaOd5xF/R0De+uj5VisDctzbQk6ym2va9o5aoNp1zO/Y7HEaLlsi0pm9EJBu2+eZ+4TQlaHlu3jUU614YNNsoX2nWWQe/kQn+0+TR+L1t3D9xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ut8XiuxRUDxheTpxyMMDDcjqp2MpbYXhtKbLzCJGR0=;
 b=az7pF/5X1sz2GHNED0uBrOu73SUGL1HWCA/8tCBoq0JkDIaKZPfFXoUzWQtPQatGNrQ7OsttgUVXx7UH+tSvzLWIVoVBnV9aeED6x7y+zZezEQPu7SB82KVrpbjXuKqsHwrcjcoxIr+q9CAlGCYKzBwf9loKNU4VGhDbF3PoMubNK2uKOovbztAkoHjIrFwilKrZ0p/oDuewroU/OtdeZqhRpygXRvbB7PLccLPYtHa3kn20gvCu42is8KuH3uP5xyH0zAD/N+mc3A8OBoyAFygFgiOecYH/7S5HBYD0WP+Whe3TN8SgdisxXzFafYAm8NS7F+udys4z/oPbVG+q0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ut8XiuxRUDxheTpxyMMDDcjqp2MpbYXhtKbLzCJGR0=;
 b=OR4G+HOALWdUMcfF9U82WGwyhIAHkCXMKYc/88HfreH9gkTtttrL0wjErpKQ8NZcFR2eOcWvH/Xcf9BB5GrFqje7Z26/yEfWsmDAPV4XLDRBkWax1oB0LDVcUDwQVbj28FOX4+KAh6kqVHoNrAczXyMSWK3bSIIk1ykBw4lzVO4=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:29 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:29 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 15/17] arm64: Introduce gicv5-its irqchip
Thread-Topic: [PATCH kvmtool v2 15/17] arm64: Introduce gicv5-its irqchip
Thread-Index: AQHchxXFLmtoLfBvDEiXQVweDQorUQ==
Date: Fri, 16 Jan 2026 18:27:29 +0000
Message-ID: <20260116182606.61856-16-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|DU6PEPF0000B622:EE_|MRWPR08MB11760:EE_
X-MS-Office365-Filtering-Correlation-Id: cb02fb38-f5e7-419d-b57a-08de552d0d00
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?9X1vHVEyp9krBNXQA3yBZJNko0dSxurR2fZt7GmXM4mWqAclC0qbDSeC0G?=
 =?iso-8859-1?Q?BzTirtHoJlsTYjCdhuQGXAEuTjSFhLA++A+VHwm1/1f2ABgXbaueCVKJ9e?=
 =?iso-8859-1?Q?tCMh3jU+HR7bA2xFV6kh1D+c/XSd7eKIqEzFQxtMW04vUF+DrtaIZQqWCl?=
 =?iso-8859-1?Q?8uhKzZgVUt+cKjOqdeZw9U3EtLs2EIw1m6Gknb6BgbNMOHj+tW1vKySK59?=
 =?iso-8859-1?Q?i8HLpCOHKf+GIiX8PaHjgwBUOj6Ri/cZLkhV/ila8S5t9ZpPWZrSTtybR/?=
 =?iso-8859-1?Q?JBZygWmybvHeihn2dUKMAnN9elr+aCm3tsquCJ6TJ/sjqlGxBwgQXoxvLA?=
 =?iso-8859-1?Q?VWsbcEm9a1Jlz1gyDdR96xBLTgmfdcxEu71HHsnaxTj0s2jFk8u23fp0FZ?=
 =?iso-8859-1?Q?UfWgOuMOvrQvBwAz+ZggiPoZVHIvFvcpBFBYTqGZuawUDk38PYwMpeDFMX?=
 =?iso-8859-1?Q?Ym4jfXw8NkvgJzOXOqXg8eemF+c0dKyCjtPtFZknTfcT9wEZRZ5saHDN34?=
 =?iso-8859-1?Q?eC4P5FAuc9kFrziJ6YJ5DY0zGZsdmBZilcslGGSGVYL+/9rqe7g5F4WcpG?=
 =?iso-8859-1?Q?uqauvcvZE5K8v/OfLPx1VpyzJUWd2+kz9MAt0oks/8dkCKAabJVxN+nNaA?=
 =?iso-8859-1?Q?S0erG7hguJcV+lK/cns0ImXNENRBQrds/HKAwxRmpI7eUUcNZj86jOmicY?=
 =?iso-8859-1?Q?9CJEp0/6SpQ4MiVfAxr+B4CPhbe4UTCILVzev7YN2iL2Zf5gwnNWDrB45l?=
 =?iso-8859-1?Q?TMBp1sAo0C/rNB5dpPHJqKH+mPvSnIREtt0B02vpr6Kvl+7kHdc8QGg5hn?=
 =?iso-8859-1?Q?1G0Hl9tCaF+oGygDSIwmOxiuzgNaiukkSe+Rwzq1YMxRO10fYonymda8hY?=
 =?iso-8859-1?Q?o5R97LsvO/pd7X6U8jLRu6r3KaFWTSvJp8b8kQviSW7R6S+3bNHIRAUl49?=
 =?iso-8859-1?Q?6/tg6DoUdz5k1wQRjr9a9H7YAK55EvZR7UblMs03ZUEDpf2ULBDjHmsZm0?=
 =?iso-8859-1?Q?sLWGfBvQUEtt9n2ZwJ82huWbqQqN7EgHp7mAv90UleswWNW406Ki8MW+mA?=
 =?iso-8859-1?Q?QlleyMyEckNTr6wiTYfQJvcEvuEhaWJY5mbIZOkEwbV2dMHioqy8rhDZbJ?=
 =?iso-8859-1?Q?IzVoLjnUs1vH/8oQM+8Uaf4ZRF0oxERg355lUkoUyx1KYaozgpDKITS6ER?=
 =?iso-8859-1?Q?WAyHDtDV/MQWVESy3BTVRTUi4/mmCwUARptOy+PhudQ/BgA10lvvHeuz7r?=
 =?iso-8859-1?Q?Qsrxv/FzN462zltdv5mDm9aGF0ToQKFgOtyxoe8igoOVGyvZx5KwDEZax9?=
 =?iso-8859-1?Q?9Aiye/QG6wvtuRGBZSbYMeCn3/GRc05TGD4QOUI6JI4/6MnZDRDtRZlC97?=
 =?iso-8859-1?Q?0LQdLdH/6jETyBSBJ5bBo0Cfj5UVUxG73wCt1mk98CN78a9E3+79kf9zql?=
 =?iso-8859-1?Q?KjeiL9ZbmZN0OF611Q1TIOelj089vhafpF6jgqTUOq8ZgMrVji7yFKdRK5?=
 =?iso-8859-1?Q?zH+l42+Ul9bujM24eoaHD6fxu8aZVcgtcnr+wywJSfzalv4I/SFnIq/SU6?=
 =?iso-8859-1?Q?T5LPbp0i19WNCWKE4Xudo2Lll1YL6Pm0KPhd6kzxoMJYMCTAsqfI2UN8jM?=
 =?iso-8859-1?Q?Ttux7Sy0oOkX3EXTBT8XDvIPrj5/XqbEOduJRMnLoim3Rc1fVGz+eewV0M?=
 =?iso-8859-1?Q?dx1wGMUfX4H1MUoQr1I=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a1db27e0-022a-4b83-05b5-08de552ce7e4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|14060799003|35042699022|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?DyhyJ7SGaFjuRFLWofOjDmwL/iueZmQ7fWvI2u5JRAip0K5nT8ydTLmWjo?=
 =?iso-8859-1?Q?gMnU2tMifIcpjbRw5NTu0aq7Bhj0cISst68rA6fOrurS37lrcIGCer8J1e?=
 =?iso-8859-1?Q?dixYMJMPbT5dBYnhhxm89gFRmfCz0utZF68+TIvrSddMIEMb2y67iWa23i?=
 =?iso-8859-1?Q?A4qTr8JPGbWw5v79Co/OAyVAC6HsUN1Cfji+wpi7/JJ7VGa6qJq2nUhF2J?=
 =?iso-8859-1?Q?gndKjl1fkuO/FXkfPzT1qw5P7xJLnTFeOT40YZ+MzolIk5KQs2qEUdtURL?=
 =?iso-8859-1?Q?zQLAaE1GZAQbryNrLWhqPszEuagq6VscE7y0AKXRx5Lx4XPGyt5uX851Xg?=
 =?iso-8859-1?Q?FRHGMMEJETM4ZH2usyX5nAroNgoFPYTebEgcHAZw+Au8fja2+FLRcEjX+s?=
 =?iso-8859-1?Q?xDqUUL6oLv1DtLhFyKfV0LcBVtwMGOvFGNJId7R2yPfacip1w7gfunMUlg?=
 =?iso-8859-1?Q?2wbzGYZ1Twn2jjcOfhvAA8ox4kCxEZ3qnQ7+DNZB8BPyLkwLaejB0J3Gpc?=
 =?iso-8859-1?Q?ZZUzClxzL5SCLXaQ+cSz8EKtXDFmhccfBsq+3/qfpwl8PhbEA0cX3Fx1RQ?=
 =?iso-8859-1?Q?tGpHFZO9XeX8FNvpMe6vJ7UDqDJfnsNudfWcF/e4NF8Q5/9SOlTLiBHpu1?=
 =?iso-8859-1?Q?Lb/ELDS5MrNTK8J+hFH8Kbkoobs956CsG+3Q+/kNr790l3nBhXKal8ierk?=
 =?iso-8859-1?Q?pOoXyMRKYPRZhbEFhyUOeW65nuiYkkQmEurbaXKw2tsK6jvgS//GzWWahs?=
 =?iso-8859-1?Q?5q/XaDX6z+aEht5IA28wAdoWyB5bqdwmv9F8apIeq8CkQCssl5VaXzuDTo?=
 =?iso-8859-1?Q?V6SO7Xqq5n1dbTx32lhKV62CzD9tPVkPewKsP/s1y3HlhE+STrmjbwoFNa?=
 =?iso-8859-1?Q?uF1oHz4Tsc3CWnMXZdZfBJwxg4hDPh/LUnjDddUVAN7hdRr9pq3QKxrC0t?=
 =?iso-8859-1?Q?H3z+3wJ/Jr+nGCbxVlbMe8DTqvBbUxV3acNbRnE08kmeNQ0x/HvUPf5XBa?=
 =?iso-8859-1?Q?v40popj9WOlKeY4tyBgNuRqfbV2AThFGEx7hZ8E1wsmBwNN/oRvxxdB4f3?=
 =?iso-8859-1?Q?iih+f4dQIp0OVy+GP8Mw0MUCAlyPvwVdh2jdzmnUFZyJmkW9voGNuX4iDD?=
 =?iso-8859-1?Q?z0t76/SIuk2Bh41aL42aE2zzZlMrqiQLY4gL0kF8i508fAsK+oc90EH1Sp?=
 =?iso-8859-1?Q?tbzU28wAXqTVIlsXVM4EzcQ/5EcPsr67CM9m6ESXP3l6+dnEbkJhAu0Nry?=
 =?iso-8859-1?Q?q1WFsgayfd8DyhARik9b62sjkzozJteVVRPMCcrNS7Yd+3tkqCYV4RVGhN?=
 =?iso-8859-1?Q?B6AdF552g5XUsJbNZcCxNytBOtOSsfU0bBncdOMdIfzaDiIi+hd4N/ee3n?=
 =?iso-8859-1?Q?ih5HqX+e+Z8XPTzJdWiBDXGS5xIztGzxrvRxyv+5UxD1PbIkoepMOxKrsK?=
 =?iso-8859-1?Q?gdZhtQP4oMPpufwBQjLY2yKlONQHutCkMyMyNvMee7lpWIyjSPBZ9rugG5?=
 =?iso-8859-1?Q?/Mfl9fZJVNECMyIdtNkVlBo+6UzjOnl+UAMmLwoWnaMss0yPBrWBByt2aD?=
 =?iso-8859-1?Q?np2hsJOfcLwVt0nLcfY8xip0lPqd7w8dIIOtuBqNTNgNAr3zIT06Bhl155?=
 =?iso-8859-1?Q?T0KOMQJB4pHwoIW3q/Yiw7/R8MC4KmYXSRZhThrnLhabqvFBFYAjBpF+RI?=
 =?iso-8859-1?Q?lIAFX4RgxU39uUGCUpr07VNlxBmqus0iLeFUf0Vi?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(14060799003)(35042699022)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:31.2151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb02fb38-f5e7-419d-b57a-08de552d0d00
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11760

Extend the GIC code to be able to generate a configuration with an IRS
and an ITS (`gicv5-its`). With this change, the guest is able to
support MSIs.

Note that the FDT changes to add the ITS node are made in a separate
commit.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 33 +++++++++++++++++++++++----------
 arm64/include/kvm/gic.h |  1 +
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index c144b42a..e0fb2547 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -51,6 +51,8 @@ int irqchip_parser(const struct option *opt, const char *=
arg, int unset)
 		*type =3D IRQCHIP_GICV3_ITS;
 	} else if (!strcmp(arg, "gicv5")) {
 		*type =3D IRQCHIP_GICV5;
+	} else if (!strcmp(arg, "gicv5-its")) {
+		*type =3D IRQCHIP_GICV5_ITS;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -107,15 +109,15 @@ static int irq__routing_init(struct kvm *kvm)
 	return 0;
 }
=20
-static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
+static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr, cons=
t bool v5)
 {
 	struct kvm_create_device its_device =3D {
-		.type =3D KVM_DEV_TYPE_ARM_VGIC_ITS,
+		.type =3D v5 ? KVM_DEV_TYPE_ARM_VGIC_V5_ITS : KVM_DEV_TYPE_ARM_VGIC_ITS,
 		.flags	=3D 0,
 	};
 	struct kvm_device_attr its_attr =3D {
 		.group	=3D KVM_DEV_ARM_VGIC_GRP_ADDR,
-		.attr	=3D KVM_VGIC_ITS_ADDR_TYPE,
+		.attr	=3D v5 ? KVM_VGIC_V5_ADDR_TYPE_ITS : KVM_VGIC_ITS_ADDR_TYPE,
 		.addr	=3D (u64)(unsigned long)&its_frame_addr,
 	};
 	struct kvm_device_attr its_init_attr =3D {
@@ -126,8 +128,9 @@ static int gic__create_its_frame(struct kvm *kvm, u64 i=
ts_frame_addr)
=20
 	err =3D ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
 	if (err) {
-		pr_err("GICv3 ITS requested, but kernel does not support it.");
-		pr_err("Try --irqchip=3Dgicv3 instead");
+		pr_err("GICv%c ITS requested, but kernel does not support it.",
+			v5 ? '5' : '3');
+		pr_err("Try --irqchip=3Dgicv%c instead", v5 ? '5' : '3');
 		return err;
 	}
=20
@@ -152,7 +155,9 @@ static int gic__create_msi_frame(struct kvm *kvm, enum =
irqchip_type type,
 	case IRQCHIP_GICV2M:
 		return gic__create_gicv2m_frame(kvm, msi_frame_addr);
 	case IRQCHIP_GICV3_ITS:
-		return gic__create_its_frame(kvm, msi_frame_addr);
+		return gic__create_its_frame(kvm, msi_frame_addr, false);
+	case IRQCHIP_GICV5_ITS:
+		return gic__create_its_frame(kvm, msi_frame_addr, true);
 	default:	/* No MSI frame needed */
 		return 0;
 	}
@@ -197,6 +202,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		gic_device.type =3D KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  =3D KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		gic_device.type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
=20
@@ -223,6 +229,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &gicv5_irs_attr);
 		break;
 	case IRQCHIP_AUTO:
@@ -232,7 +239,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		goto out_err;
=20
 	/* Only set the dist_attr for non-GICv5 */
-	if (type !=3D IRQCHIP_GICV5) {
+	if ((type !=3D IRQCHIP_GICV5) && (type !=3D IRQCHIP_GICV5_ITS)) {
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
 		if (err)
 			goto out_err;
@@ -296,7 +303,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type=
)
=20
 	switch (type) {
 	case IRQCHIP_AUTO:
-		for (try =3D IRQCHIP_GICV5; try >=3D IRQCHIP_GICV2; try--) {
+		for (try =3D IRQCHIP_GICV5_ITS; try >=3D IRQCHIP_GICV2; try--) {
 			err =3D gic__create(kvm, try);
 			if (!err)
 				break;
@@ -321,6 +328,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type typ=
e)
 		gic_redists_base =3D ARM_GIC_DIST_BASE - gic_redists_size;
 		gic_msi_base =3D gic_redists_base - gic_msi_size;
 		break;
+	case IRQCHIP_GICV5_ITS:
+		gic_msi_base =3D ARM_GICV5_ITS_BASE;
+		gic_msi_size =3D ARM_GICV5_ITS_SIZE;
+		/* fall through */
 	case IRQCHIP_GICV5:
 		gicv5_irs_base =3D ARM_GICV5_IRS_BASE;
 		gicv5_irs_size =3D ARM_GICV5_IRS_SIZE;
@@ -348,7 +359,8 @@ static int gic__init_gic(struct kvm *kvm)
 	u32 maint_irq =3D GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
 	u32 nr_irqs;
=20
-        if ((kvm->cfg.arch.irqchip !=3D IRQCHIP_GICV5))
+        if ((kvm->cfg.arch.irqchip !=3D IRQCHIP_GICV5) &&
+	    (kvm->cfg.arch.irqchip !=3D IRQCHIP_GICV5_ITS))
 		nr_irqs =3D ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
 	else
 		nr_irqs =3D roundup_pow_of_two(lines);
@@ -525,7 +537,8 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 	/* Only for GICv2 */
 	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV3 ||
 	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV3_ITS ||
-	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5)
+	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5 ||
+	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5_ITS)
 		return 0;
=20
 	if (kvm->nrcpus > 8)
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index f534ea5b..40ed500e 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -36,6 +36,7 @@ enum irqchip_type {
 	IRQCHIP_GICV3,
 	IRQCHIP_GICV3_ITS,
 	IRQCHIP_GICV5,
+	IRQCHIP_GICV5_ITS,
 };
=20
 struct kvm;
--=20
2.34.1

