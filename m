Return-Path: <kvm+bounces-66380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89CF0CD0B8F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1E1833054655
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C4D3624D4;
	Fri, 19 Dec 2025 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ac/hW2iA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ac/hW2iA"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012042.outbound.protection.outlook.com [52.101.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0187C362141
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159668; cv=fail; b=TCnZDfChDCpo8y8pCBTqGP/MvSVdLxYz4mLukO+Jirb3v1CnUOvVWAMV0b8son6AullLFwx7XU9hUfomdTqhQWAcXbL+qLIsg875D19NZMh5+Dmd6etCXgak2SDybOKgrAX/4mn3rlAdjKK2oxVaB5Jwd+29xTVNX2Q5Q6cke8E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159668; c=relaxed/simple;
	bh=C7UboQElWEAMi7d4LDBMWZnBaLNFtFvF9O5CUEpgoqI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sG4POG86lKldoytKvOfGS2K8wHSte2zQRyWhzLJKHchUiSqjmuBTQHf5XJx6TivLnrxnMlahGZUJvmUqcdbUbI92TCJTHdYn6U+NDoyYY48VZlaLom+6EhXk3quiL/lk/bRdBKU/BLsbv9qQlLcS1rZnJAEPlprrHtd1TD4bTmw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ac/hW2iA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ac/hW2iA; arc=fail smtp.client-ip=52.101.66.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hSKTzbVzp1KA6bW/hr/x9RYMbXQy7oXyjjQ9TNIXUIfpQ+Glf28Z50mxDLCvcqW+HFuk5QIAN9LqvIey25YVE++yBSccxne62Zw+xqWsv8idAnAt8XW2ggCb0m/VVo8RhQeH8pjvPbNY7T9Z+Ck/7/Aajkbd3S0KAvtaA9QGu3blTAe1mjNTycBXSi4G1xZhXi24XXsRecFR4HsJTviA5L5I3zXRjY1O91YebygyTbvx/XimsCBhElyJUm+6YZJqMjJpsxbWhq6E7r2ZidWCikjO/A8uPlqYlM3VtwQ5hMwGcXRNNWmcRJxeQzDz6oAENrRA+NUjGC8/k/6u6R15Tw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7NfmYhxHy2pBxuJLfMedUNoSYZixMoTulJ8e0JNQxo=;
 b=RDLYjz0C13w5neJnYMByOwaWncIqs+qn4wrRhbXaSvxXbZXaZgRuDsRFZ4scaGCdCJGwHI/xrcFND3oGTuT53sOReKdUW4k+HapQVnKVLpbmYED3L/K8yxwYs+tXXFHA9YK3JqHEMoShplSByJbKHbhuw+MiME8lh8PSBSx4F3s4Ez1AVTKpsDU7vIM6ohY6jtyv1Mx+Kuzsl9iIbwjJyHaxs+cozOGioVt94iovoNSLq61+XPN/VqxOM2gyXrQWuM96HUYRG5OnTdaQ0VDUdaAcENqXgmOVhj/Tc1SbPyTCBaSdBIw4YC0dPzIKNzWOY9aNVfYC579h3Y/EstCZ8Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7NfmYhxHy2pBxuJLfMedUNoSYZixMoTulJ8e0JNQxo=;
 b=Ac/hW2iAd4DONXr6PZUatbPJiZlM9ZCEeEeBhaL7m7QJ+fcm6uBuXhqk48f011IrX/59mQGbe+w63pEdwwmRFxHPYb3kAveY35+7/vqRv7CHYC85n/hsBgxGp7JimKHNExxjNCjo8mNbncTcnG+8FLVYGEuLPTpSEfboiV7cwMg=
Received: from DB9PR06CA0029.eurprd06.prod.outlook.com (2603:10a6:10:1db::34)
 by DB4PR08MB8127.eurprd08.prod.outlook.com (2603:10a6:10:382::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:54:21 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::d5) by DB9PR06CA0029.outlook.office365.com
 (2603:10a6:10:1db::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:54:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YiPDRnr93jxnUQCxBS1S7BoUPiiylM4h9mkT34A6MzDP0z4yjVnMVHoHASCy7InVpB1jcFogpiU8fL4/vj2lFsgyDTjV8M03AX4XMs8ZAAKhZCqC8e0sazSN6hHN7oUKlDX9BYXugpegAecJc4zkFuT1VjRrQwLUKjJUBg3VZEwlSFimiBUArgFF3AzrpHLpSp3NwWNoU/E3C8qnF8qTum6LQyWQ4krLVaVBKgBGtRaaTbONK5tFuMAX+e1sMWhd/RVE/sGEWmVHrFn26MjnuLHOHS4sDZ3rL1hICTi/NbPe6ITu501Csh1LdYeOo2kqU9IaxPS2/4R6/cOyy56faw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7NfmYhxHy2pBxuJLfMedUNoSYZixMoTulJ8e0JNQxo=;
 b=YCqnc0GYnTjew2afUyZUwJSAR0MdgdX09Y9HrzpjolQpnB7pTPKf7h7fHh+C2I5l6iiV0gVhSKwykJSv2UDzLxsnw3RRXnUr5S4vGiob8QZNIFzVCTpQhKzHYxoC1Xo327fO35hzjM8Hk0LTNwQlF3BNVdT2mUj4Q847yExbIUFYOpAC7gaHW8tBVA0xLxnw3NrZRP38OfxTS2Qv3sdb6r9z52gat/vyxJlvty6xb7DgUleAy+MEETQ3sSsd+OAKNsz+FxYQ5fW8T+7kr1YFnCymn7Yee/bLaghkRtDdYsE90oucZcDDrq6BECULpDtExZwkdH2+gHBp311a76sSlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7NfmYhxHy2pBxuJLfMedUNoSYZixMoTulJ8e0JNQxo=;
 b=Ac/hW2iAd4DONXr6PZUatbPJiZlM9ZCEeEeBhaL7m7QJ+fcm6uBuXhqk48f011IrX/59mQGbe+w63pEdwwmRFxHPYb3kAveY35+7/vqRv7CHYC85n/hsBgxGp7JimKHNExxjNCjo8mNbncTcnG+8FLVYGEuLPTpSEfboiV7cwMg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:19 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:18 +0000
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
Subject: [PATCH v2 34/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH v2 34/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHccP+FFQeJf0hpJUy6Oc2PJQMZkA==
Date: Fri, 19 Dec 2025 15:52:47 +0000
Message-ID: <20251219155222.1383109-35-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|DB3PEPF0000885B:EE_|DB4PR08MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: b719f8ca-0e03-4add-7a32-08de3f16dfec
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Akz5SDD5B1/EFzuhg8mzlprJTMvM6KWT5imidLTK0xvw/h+ZP/fwiR8Fl9?=
 =?iso-8859-1?Q?+Wvz2NgE8W6FsfOYUosIfmKd1aTv9NTIwFIezsxcvhXAdShU3aRew4OWky?=
 =?iso-8859-1?Q?WaWdd5BY3JUcv9whBt0pXR79kGhmWdpSstk6QGpKjJz6ys06qWGgjn8MUa?=
 =?iso-8859-1?Q?ikErnMnafrrAMdDoJ06XJG6PwKdl5p7+1fBpKgfrXKqNaglHxmlmxv4y8W?=
 =?iso-8859-1?Q?RKpMeDxXqJqVZrbNTrxZ7e9MwQRGtQkbYg9F70WWqBgNLc87dUQTbwCDYm?=
 =?iso-8859-1?Q?+OekOeiyNm0Tf5HRLY3YVbWXzmNZ/qT8KmoB/4s92urvQsSlx9YoI7mH4a?=
 =?iso-8859-1?Q?C+FzwjjL+62gv7F2fV0rGpXVbQO5jbaIL5Re47/TAR1b8RrGBx5CgjBaNh?=
 =?iso-8859-1?Q?Sd01wE6VpN41+qP8VZuAHHDoZk0DXT8Kv/OKAxoeS/c/b2NyVia+5F8w6L?=
 =?iso-8859-1?Q?mXSm+ZJUa6Roi72WVMIx/WPPpMZyBaV9sUyaNk5nyXGalJKs8qzsGsBELv?=
 =?iso-8859-1?Q?LcO/aBAfnQalCJKwN40EkuHkhn5eLq/v3QPZ/E+s+DClapyN6tQmmA8+IA?=
 =?iso-8859-1?Q?FHoG+kGQfS67Aq1im1LE+3FMfTwYxkHD7tinuuiJgogo1aVdgnYNPeqFAO?=
 =?iso-8859-1?Q?eNFGwOvfEO7aqIzyfSl5BHKpy2UnoopUAIidNa12kKzydOHzOFsVpR61XP?=
 =?iso-8859-1?Q?jzxPH+GS/d7DbyWsnpXAsjT3u3SpW2ba6xOb1KTVI4f0IXE2XcquRQvzdJ?=
 =?iso-8859-1?Q?lXQQ1YhbaBBHuiAvaGQUxAT8owFAha3OnCgWa1YaevIc4F7BFtz0Giz1cu?=
 =?iso-8859-1?Q?AaPi3vQuBvydaOP8Mp9ek7DuV93MooEelvUeqA+Dqe47dKfvRZT4Yw8H0D?=
 =?iso-8859-1?Q?XK7NDf+AqmKRFsOSL15UHiAqSjUB6mOWGNpDyLdwU0hei1BSecs9UT/lsj?=
 =?iso-8859-1?Q?NV+UGIQs5eLGksyoKLdUb7m+Q08FHZ1liY22VEd3hRalJfMdMt2nUlJjQi?=
 =?iso-8859-1?Q?y5N8y5P2Q35TM3hcc28ttm7ONoHoZnruWoS+qUbE0T7hx4GKbIg/D1yh+F?=
 =?iso-8859-1?Q?bqR3RrqPHs1OHQCimNXeCHVhV4EsaapsXt0xO9qOKi3VYJLxDyCqaBC4Ms?=
 =?iso-8859-1?Q?Q4VfjypoFdHL0ISQGxve/ztArSAYjiIqvAk4adaV1D/t50g5NhY8aIgWSj?=
 =?iso-8859-1?Q?3yVIQZvjmQCkkXtCnViZn1X17WfeTsMlrt6hmhhNT1zdsE+p6rFwLbScl4?=
 =?iso-8859-1?Q?fZpo8Hv2wc9BUwDm/BJqk2KA1eI5eFqkZ7vO8qCsGKuVKG2DwC+kJCNSWo?=
 =?iso-8859-1?Q?vq8gRZ5S5d69k7ig3WSu3pKS9UyI0VZoNnBNbQVE/k9Zf8Lye6qRW/kRIK?=
 =?iso-8859-1?Q?jABMARymdWWsT3Uj/TFNc3TT9+PGz49jydUoAhspNhTbfOoPiYtdMeAyHZ?=
 =?iso-8859-1?Q?gFmATqnUZa/Ur12IPnz388ZRIevTmoZNU285ec5vGosjRX05fYmL3GG8DR?=
 =?iso-8859-1?Q?iAC7yqt9YPdTCtmnd/byI9MAsyWAPW/uGZET8qi3I6o/w4jTM9GjozgfxN?=
 =?iso-8859-1?Q?yVwPQy0BXa80CSV+3yPqOgRULAC9?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6515
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1333f0ae-96b0-4bdd-eadc-08de3f16bad0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|30052699003|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?8JMwVMRBqdO7i93sK+y/1/xeX+Frpx0FpdZnNj1UsuQoWXmcoMVMalgkEd?=
 =?iso-8859-1?Q?UwjSQtWikYwAwR/VVO8RpXsUSM+BJPJdCVPB4/IqZ+CHZR20MXHGZhP2KT?=
 =?iso-8859-1?Q?oLRdaB0nP/VQorKX29AoBW9R+B7fqAXEmkzFXqrp9k/IbZA4X4IJT7a7bX?=
 =?iso-8859-1?Q?Kje/EEWGSv0ayKrc4gLDVXX0xoVCW9rtIcGsVsYizPxqzxuUR7b6tTyqW2?=
 =?iso-8859-1?Q?uvs0HzKjvK4JTejt5tke4nu1GJETu4RbW1QGpu0YsoSeNYQW7X6gm4QneR?=
 =?iso-8859-1?Q?n9s+D3ZgZynsfAuzDi3AKPCo+d4Y1Jytvr/aGTv2am287dglGeigsvotQH?=
 =?iso-8859-1?Q?T5ypbaRNCUUo8in0vtl/7lXZluaOwtJrjcGKXxLScgxBfHDKDh9Dhlru/x?=
 =?iso-8859-1?Q?+gs1zc6PFiDC4I2WS+rqK3irp+eeDH9IGJje+p55JInm29E62RegxkRJxL?=
 =?iso-8859-1?Q?agTsbGn6aUQ6yuBCUxWpGAJj3XqKWoCmRqMsPABEGMgsoyhWkHyDvN4otb?=
 =?iso-8859-1?Q?hQAesgqbhFHDpZWDER6f8LSy5+x6eLnzv16H3jP2FnPeVmPsRyzPYo8l6x?=
 =?iso-8859-1?Q?JggCs6e16132va0Qj6oIlAXmFJdt0EiOXH/1Hl+lwCfvbMB6eUhv0yZc5O?=
 =?iso-8859-1?Q?nH/Zt52mEa7UND5fZ+S3jdCXS+GLZqHex3Q5DCdlETWE8LBzWX9TUJoNmf?=
 =?iso-8859-1?Q?LrTwBswH7MILtzZbBX9w3OVvcLbKvxDWaF1yFGN+2ksEUJAKYK2VzNuuOt?=
 =?iso-8859-1?Q?+LRWKAXP9wLkY1k3574ygswdUwK1rp2A/sSpnDx2uS3VzJ9vo97xsZ2iU0?=
 =?iso-8859-1?Q?yA2bG7HNd37xnEXpfaZrLOyoSZOuaV9eZaFyUhEL82GuWLpf+Rd10ecRZS?=
 =?iso-8859-1?Q?c4TzYwJNkMKBXGshVgATos2hSdYqeU8sLHByYuX625DaRU/Q0CF5qGHLHk?=
 =?iso-8859-1?Q?/pjmxolnWJeqqSmPwnC1MoIdm1c4zpIAadxZvag4YxPQWGED6+aFwkIaiI?=
 =?iso-8859-1?Q?ISJU0cVcvfbv2xr/ag18SHqm8mAgygvumqkgt4Rn6x4l4Xs0jNJTvj4QxA?=
 =?iso-8859-1?Q?GnZFaNkFml1cFi1A1AOTeD1x4A7MSaL2F8h0y4cZW60Ubu/YxWTS3d43Bl?=
 =?iso-8859-1?Q?1v3YM/QFle9m0bdbxFWIe9E/K4p5YGyuLlqLCflWmpgr5Daq0uOONslgiv?=
 =?iso-8859-1?Q?gvpwvuRy9vau480xkt9Nqqus6M7PbbnlFCbH0el3iKrdaLNWFIP1h7xbUS?=
 =?iso-8859-1?Q?oyGQDAAcQ7aWsnSS5/0V3/1VmOwvWtFkd84QAQf79nMlKQDb7flpMg8dDW?=
 =?iso-8859-1?Q?o93vFU1+GYX3YAsMNfuZL/KQFKxu67GsoJMMWxK4B1qFDh1KvIpRqlD7iN?=
 =?iso-8859-1?Q?Tmz4O9+LBio/rlS28QgPgVcnSNwaLJXfwFu9kgIyI9Fb6Ff3Dvn1aXUZi4?=
 =?iso-8859-1?Q?BPcZawiFydzl7+QBfQ65/zahoz/qdlz0Lct0CAMeGOvvBfhvlrlS8ods3o?=
 =?iso-8859-1?Q?H9WmAIiNU1GSuvLmQMsLQhXBiWhoYBWv99eLW4l+k+X7lzPPiJEaadvbFt?=
 =?iso-8859-1?Q?2PFVsXryhiHZB5XzGh9YX9lJybg+OG4f1t42/mtwSPH3eJzPuhyD4FLzpd?=
 =?iso-8859-1?Q?2rc70kE25sIiQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(30052699003)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:21.0862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b719f8ca-0e03-4add-7a32-08de3f16dfec
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8127

Now that it is possible to create a VGICv5 device, provide initial
documentation for it. At this stage, there is little to document.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 37 +++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
new file mode 100644
index 0000000000000..9904cb888277d
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+ARM Virtual Generic Interrupt Controller v5 (VGICv5)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+
+Device types supported:
+  - KVM_DEV_TYPE_ARM_VGIC_V5     ARM Generic Interrupt Controller v5.0
+
+Only one VGIC instance may be instantiated through this API.  The created =
VGIC
+will act as the VM interrupt controller, requiring emulated user-space dev=
ices
+to inject interrupts to the VGIC instead of directly to CPUs.
+
+Creating a guest GICv5 device requires a host GICv5 host.  The current VGI=
Cv5
+device only supports PPI interrupts.  These can either be injected from em=
ulated
+in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
+ioctl.
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/=
kvm/devices/index.rst
index 192cda7405c84..70845aba38f45 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,6 +10,7 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   arm-vgic-v5
    mpic
    s390_flic
    vcpu
--=20
2.34.1

