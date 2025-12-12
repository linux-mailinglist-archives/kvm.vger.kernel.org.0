Return-Path: <kvm+bounces-65868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10175CB920A
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A83B131234FE
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1822731DDBF;
	Fri, 12 Dec 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SAvKkeGR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SAvKkeGR"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013050.outbound.protection.outlook.com [52.101.72.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E844324703
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553041; cv=fail; b=Sgl9gi4Mzlaie0Qu4dLiZyWFH74+SqaU4goZ4A+GZ7mjFXpifdBUeiSdsQeHBllKquPhXrqXpTmcDsBIBtU4U4cUWGAJXVonDJkZS1hyjp5aYHE+VKE4dAdnPerNkWwREuCGMkzuA2AQYa7P6JNOHPKg4KoLln2EKylE/7sKLo8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553041; c=relaxed/simple;
	bh=8L1Xd+B4E9pW99l8ie8zOmKMDANJaU5X2oODYYOhz5c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TGShtOkjnggwZb6OnIYadv2LR7446MZegOy5/1uZLIVHxlQFXFus2VCklwpV4Lbsk0oeycKyiat426S5ZJevbPRCBj+wiFFXfP0jgSJZw1bOoO/IZzZXDUOC5BnELFVYhKKpnUnkzpJ6fmmudC1iYmnqfTQCNTnHypKhglO0JPo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SAvKkeGR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SAvKkeGR; arc=fail smtp.client-ip=52.101.72.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Xf+znheWR7W4eQXqmImc6cfMl4N4RLUItPP6mK44UdCCc1JcySUGpXSrCzENjzRbCwi9cq2zcF+YLphgUGWPQw3zq3VQqTNhxJ5g/6AwEsqtuvkoFQ9fCNFLQTTo/GxrzmlfbxoSdduSuyHgWGUB8ZkzqqCYwQCAJxbDKfvpb9SucTmrMchdDNBTEz6C5Y7qoT1zCZcSKXgm3NuNQ27OBSc0LmqMwHYeU9VlwdQMsPLPFBTtiZlRrUouP8NxUx9/Sn+wz/XdPZSg0q+alVA3PUi/7OMzwt0HAmMakcZJoj90lLFyKC1FUrmb6++XFMUQS/9qHLGeuMJznxS4XqsBzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fT+zWc6ubjkv/3GZFX+eMpQNF9pZU/u0PfZ/klMBx0s=;
 b=klmYNQQy9wNmmes0Wg+HxulWaOlESVw42FoluaDP2pQd92rrO+uxkFTDv7W5AVhVTy2pWWCaz8JyiSHXk/HT3CeXzv4e++bnG841C92ol/yjt4XH3XeI4wGIHlcCGCnV0rbflmmDGY39rAwdq31ACBZ2aPGbiVTMz+ZHsx7gIcpWe7RjI4rgxB1Oye9whues5MSB3+uUWbWxqZ4s63/IxYg6Xoa7oyXMb2AkpRteURJAUY+9qZWrCqfGqrIGxU+vcPB2chbf/lothT4MCKQUyiRCaflHVviwY0iZEn6pdL5j6Q8cgLg50OOVts3RP4D03Ne7sKGy6Jqv8UAiAi/Khg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT+zWc6ubjkv/3GZFX+eMpQNF9pZU/u0PfZ/klMBx0s=;
 b=SAvKkeGR+nZELv+uE1iaggZQyzTqBcXBuOzjlhK+pG2SMBesn3WUeTCN3wOJqYPD+v4/emVC/Y+m7U0NBn9lxVYCaWzUe4HHKsXN6O3zzXcjha7KAaoy+12aQB0Cxs+3/BeBdEsXGt2ECDaZ/K41830hvitUCcbBriBJv2xyMoI=
Received: from AS4P195CA0006.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::11)
 by VI0PR08MB10826.eurprd08.prod.outlook.com (2603:10a6:800:202::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:51 +0000
Received: from AMS0EPF000001A4.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::c8) by AS4P195CA0006.outlook.office365.com
 (2603:10a6:20b:5e2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A4.mail.protection.outlook.com (10.167.16.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaGvKdt+PTTR0r0eBuWQ4Tk1hXzPGkEFDKV6F66pDkpRMEsbzv3KuP1qbBdl3Fr61dBwufjL1KCrXCdzoquSj7dMQXXqxAk9IOIN4KYwRS2lUrywwox2GQAfYd9/lNg+UWMqjb7gYG+83ICZPPQeXVMRaBl0GhRb5ziWPOcqgN15FAuh/0AbkNWSF5wQFDsURnj+kGv/ZLCFXvAIlO6bXLBaDpUytK7l91I/HXG/2UDT2ILV8/CMC5hrr7YbOvvaE7mrI7pzr5wI8vyiUmLrNMlnn2gghsYqX43ux/ex6YK9Xlc5fKHfAtW32zRAAVT5iI4yBNtAWc4K918MQdm+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fT+zWc6ubjkv/3GZFX+eMpQNF9pZU/u0PfZ/klMBx0s=;
 b=YMunfIsnM2iZCRj6iPZvvG5hViTJvRBSGECvgyFek6ZLOW4QwuM8FhyGyEw6UYwrpGX1lh7TV5htarDGFjFV3aRiXx5+Ydc/1zO6+4iSb7X7bu/d/0/KZgjog08/aHQTLDtDDe/5n2gl4xi7xi3cgYPvh2F10adqKzJ9pbEg1ZJHFn+PC3TIySiFyg6O7l8CmYI6sltVP8mkEa4oWqjJeuAA3zG79Bm2xqIuGMfVFt63KuKY6AH7TFkXWgUuvY95Qyr03O6dabim8W2QepmfQqPHXHH+3P5jzgCmNEWYSh+/6HYYRvTZPV0tchxLNsjVZy8ahCrijoRXkpoYEuYzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT+zWc6ubjkv/3GZFX+eMpQNF9pZU/u0PfZ/klMBx0s=;
 b=SAvKkeGR+nZELv+uE1iaggZQyzTqBcXBuOzjlhK+pG2SMBesn3WUeTCN3wOJqYPD+v4/emVC/Y+m7U0NBn9lxVYCaWzUe4HHKsXN6O3zzXcjha7KAaoy+12aQB0Cxs+3/BeBdEsXGt2ECDaZ/K41830hvitUCcbBriBJv2xyMoI=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:22:49 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:49 +0000
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
Subject: [PATCH 25/32] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH 25/32] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Index: AQHca3spkgE6QtNJ60KCz7+TT7+CwQ==
Date: Fri, 12 Dec 2025 15:22:44 +0000
Message-ID: <20251212152215.675767-26-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|AMS0EPF000001A4:EE_|VI0PR08MB10826:EE_
X-MS-Office365-Filtering-Correlation-Id: a333a14a-1c5b-4e7c-68ab-08de39927453
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?hKT6UfM1djqVJLpnk+kDsx0h/I8+UzgYjsKGM89Sv7i/nqbNckW1qorbT5?=
 =?iso-8859-1?Q?/OZ8gZgdRfEs3uzQqPykrGJEZ8S+eOuF41uZfgIGCaPAk8/ybR6etbFOK9?=
 =?iso-8859-1?Q?P0Wp7uGv2964zJrFnor5YRNNGWlnkUQ44pnKg8DzyZ79ghqvhoMJWXtyfR?=
 =?iso-8859-1?Q?u3YeCIVy+0bqGlt/0eLBHf5R4DvwgeTC0OZW1S0fLmm5VB3xu72Aq15yNA?=
 =?iso-8859-1?Q?0v3NKL2AfxKuaecATjofVhIzlrVdrmEzMASZGlL8a46EcspvOpsVlLWq9m?=
 =?iso-8859-1?Q?iPxqbHRhHWrf2cp9vLYi1Qx9gBlpjfrCyUY6wXOINE82Ga1zqR6JHsgnkt?=
 =?iso-8859-1?Q?mX94PGejhw5NRSIL1IJ2DEzwlsQFft1Avy6cEfZUrbN08wnWCt1dTI02KZ?=
 =?iso-8859-1?Q?/wM3/tiAcKYROokeaTrthAn0awrap4wdi/M2iCvyYG/1KoFbpVSwWeVz/i?=
 =?iso-8859-1?Q?1+B54FjBvxpfwu03LCLQdXKVS0N8ISjf/wUgPudnJGF2ozl2lx4HpriteZ?=
 =?iso-8859-1?Q?9/bd5O7p+o9mOSOZ/fwfR9Nlzn/q0zUQvkAagrUg4ToIzr5VHPw40xQEhR?=
 =?iso-8859-1?Q?R8saDJB9NuqBzxlT8kk8lXhYAwjDHdnG7dHTjpuQ1t70yRTX3+SFpa3PR+?=
 =?iso-8859-1?Q?okpKBTa6VejgOpb333fosH1BLZNgUp4XMwGVZ9dfe9EEvZk6LQk4rTDtjC?=
 =?iso-8859-1?Q?SNDfY8YhUTKRaUD9D+b91XhEOho+Ax9PGajJ5JBsTXhX6C6roEDwYMIuON?=
 =?iso-8859-1?Q?EzebacjcuwJ/xFxAm4ZUB4CGo8CK6U5VneN2o19Oeq1Y01LyV8SaQypY88?=
 =?iso-8859-1?Q?Zvq8ZKSg9bg+SfNFuUYI1Ag9oFAQiVuERrvlNd6Xz7ljT7ugNwm6o7tMTq?=
 =?iso-8859-1?Q?ifPxF4vXmOEwNcMq50kIfEg3JfxFMIRjYku6+K+5j/CV6xAADpB1dB1dfk?=
 =?iso-8859-1?Q?C1GtMiZBrScRqpD6jdZnRe8EZYYt/E024cSHBIz84cvnnxQRQ2gwYNQrQt?=
 =?iso-8859-1?Q?alxBm/oujnjS+fPMIwYiQ7A9PnMn7SpWVnChGhahpKCgl8mOUbmKhVaZd7?=
 =?iso-8859-1?Q?6ZCuNQs3SZNnHrMVs1WtLZ83ZQKnCOmeJ3j3A43KbWSP98YlNXakq/ClUY?=
 =?iso-8859-1?Q?u77leT/Lm10TvWWSayTCOnbbdpdgegaEjpSDIaIARQ9CpWteASgD20jPfN?=
 =?iso-8859-1?Q?n/y91I29+6NMWHBEavJK4pTLZEa/eMALeq2wbjHZMgXkyujpjfWlrC0qTD?=
 =?iso-8859-1?Q?mjDR5q24rtHS07VloDKlmULrGA8iUh33bpshZIFIsX55e4JKVhjpkE5BYX?=
 =?iso-8859-1?Q?ETv+QeYv8YV0LrvfLetR9pc8VtFxTcP2Qs6F+uAjYHhkVyLrzeHtMj6wAK?=
 =?iso-8859-1?Q?IctJyD5Xkd5TGtp3mzHqMNDQ4r9skiX0wW4uAI1NJxtzPTYu2/HrFQ482q?=
 =?iso-8859-1?Q?J1hYJTasbG1ZzB5ejEPFHNCQnnlf9YkMSd2i/Gj7ylg9/72juYKqvgwCg3?=
 =?iso-8859-1?Q?11/Jc5zPYs37i1VoQIfqtmyGIeSO37AAxcenS0WXbHuLWrlkRTUpvjy65L?=
 =?iso-8859-1?Q?Y8Ko2aoKYxqeeiZyVlJi5Xr116+b?=
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
 AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	26907cc0-7826-4d72-7a9e-08de39924f2c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|14060799003|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?WhEfYT8OxMaqvdzcsaK3vYuPBvlolCrYhMdFRQVg4PA4fRR/g34111+G92?=
 =?iso-8859-1?Q?aW80MLHXzSdcWqFPAzjlZXtZAuYq8s52dvSL/cxJN+o1yO7YXHllNcBjAD?=
 =?iso-8859-1?Q?muUWTbWx87q1tz8UpU3GmR+oNi36YDnXSjy23zwe973iFp2nCFNnq6TDJB?=
 =?iso-8859-1?Q?5bQeBr83av46sZkbn6lf28oCik4+Cryr0eVIArzmKFaETqQKdOZCfpF1F5?=
 =?iso-8859-1?Q?cWR2nNk0asuDdSyl6vtajB2+d0duhdt5ajQEKEBnpxp4DqRSzurnk5t9dl?=
 =?iso-8859-1?Q?VedpLqJ+DIl9csxwByk1jNzletQOYYH+R/egz818DTWK0goWhmLGmrY/O1?=
 =?iso-8859-1?Q?NEDmTLwhfOuhGZ8Y7Ops/zhlzXpJkpCugTyLWyX5ot197dBXVQ76mOJEgr?=
 =?iso-8859-1?Q?KN7VNVQMOcy1dhZ/vifiPVik9nILCKA8Ug6sE2jsQw9v0/WZ/ZuuxZoAc0?=
 =?iso-8859-1?Q?QNe5vwOD/mWF4q/KetqMkmLcAABgsAkuIcMus0wQIPhHmcB+LiemNgKR/0?=
 =?iso-8859-1?Q?1hBRomMcZgyqYem8pqqIIoTy+/ufVxmvG/4KhWGn3aSv3mXMfdnlmy4n6y?=
 =?iso-8859-1?Q?z5h7UtyV54gGhzj3ABLF2oXWBTLYk+jNrxL5rxJ5iO6qs5RrP06Y1hN/hc?=
 =?iso-8859-1?Q?n/Ikwd0sbuJdvoBzsav6tRSQdopDM6G6K42UjjSWnzmfzaoG0aQBHD4ReZ?=
 =?iso-8859-1?Q?csvvmis6qgeHIu3vH383KWLhkTuMKgDoaPkV4ZGh4cDqu5NUUtCRnx1/CO?=
 =?iso-8859-1?Q?sAT75oOGuKl6fyHv0/jpgxu/AMLy0UFTpZI07W1sYUpgZNP2FjooYCdVFY?=
 =?iso-8859-1?Q?Spy8rX3EgEngpxh6FtqgynS+e6w8G/dHEN/q8/o/IMkttE3mAYWiJt79vy?=
 =?iso-8859-1?Q?KT1cP4pr6q9xSh7kjkZFVOPCqPGFkeuo/Yo/2LoT6o5wzddz6F87dMnAqz?=
 =?iso-8859-1?Q?6GTgcMcxY18lCvmV/RISByjMxdNWaa2EBeCKkubzoEpH6me8o0m+P6RXAQ?=
 =?iso-8859-1?Q?xtd9DSf1JMIAryRen+4TZiTu9caiWAdcWaY8zcWIl9fanNvuxKTUC8ugMe?=
 =?iso-8859-1?Q?ZYJvhbkAU5aLXWAyY1LxqMv+PFtEe9PLi2Vh21JsJJt1ll7fCxnj1bPKjV?=
 =?iso-8859-1?Q?6YbzNDj+xpVZUPZb/ziCG5tfAUIZDPVSj0efcqDDj71Q1C8IXWcKTR50J9?=
 =?iso-8859-1?Q?dN941ITZfuEdiKZ6uQYnMmw/XhHI9bfES4iuz4vPDm5YUsoASUoYEvf1eN?=
 =?iso-8859-1?Q?EEQ9Id9zTJDVnGWFDC9uBuPYHYainhjeewiAwyaFxEJv1hdAWVFkWmgFDq?=
 =?iso-8859-1?Q?DWHuGnjTCd2bViViSqvjjJYUTEZWvcS3shkBhJLQX6u+Cfc3Oc5Vrz0mjw?=
 =?iso-8859-1?Q?GiZKYUBxOx0YnUtzrPtpZsNQnw4a4Fbpfsn7Bd2xcPG3cHCrNo000GAU48?=
 =?iso-8859-1?Q?RV0G5FFG4WYKB9Ec7QMGm+FJJr+EpfmZaVjaxUGBB1+WNqefbdd2VwG+Y7?=
 =?iso-8859-1?Q?Wu8mW/kgJY/+cvxVIZBWyL3FRU+9fP58ZvW2l89PU6dKbogBO+UhVXB6yw?=
 =?iso-8859-1?Q?fpxNv4mpELhxWqheoymTCEdr7dyUSHzDLcYaRKUnqA1zmNfBsdV1OsdMsX?=
 =?iso-8859-1?Q?eWyqcB6Kb1yuM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(14060799003)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:51.1940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a333a14a-1c5b-4e7c-68ab-08de39927453
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10826

We don't support running protected guest with GICv5 at the
moment. Therefore, be sure that we don't expose it to the guest at all
by actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index f6cf59a719ac6..824c00c3e32c8 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 22f618384b199..ac4e6c4d06b0e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2467,6 +2467,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 3108b5185c204..9652935a6ebdd 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1

