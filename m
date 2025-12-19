Return-Path: <kvm+bounces-66355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F17E3CD0A70
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:57:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2254F30EC810
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E003624BC;
	Fri, 19 Dec 2025 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L5bByoNA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L5bByoNA"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011029.outbound.protection.outlook.com [40.107.130.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE7361DC9
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159632; cv=fail; b=luqb/+VWWwe2TEJNFhVe20V155IF5qiw58XC6LlZkAVYchKBTNM2T9QnXC47aBbyMaoBw8rDVSe/ofmRXx/KHVqZfQrCO5wNa9nJbhqYZkfzslu1NAOeZ9dLd3qcNx4mgsEvgwl19bjhIbKzxTNKINJHBKpezGaHD47BgF16cvI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159632; c=relaxed/simple;
	bh=s0v7KpqZfffyIHDjeTFFTbUz90lZ5EciJHwzQtc9twg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IKQr0aXcfTnqlW4JhRw/KBVUPV7pUTfi9kJ0xHWrCfSuqKM8BFLbyVnKzESASrX4waD6MZS/oeMo9hS5pXtkfRjogVrVZGkee9dvMI+/kw7mMUxt0iwSpZhuoyR3ckkCKJaZUC18tcRePFcDceCvUFPz1/KLx7nhSgxJd+pqfD8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L5bByoNA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L5bByoNA; arc=fail smtp.client-ip=40.107.130.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rM9vsXwOV1HK2mNLV81kBv8kRDIAOb8iiVOauaS/KrSm7mifFmRQyAckWis6+7YibjCPFfh6WIbYG8bBAmp0QKk1QXNKRKlotjVwyZA7OyOffSchhSGujtaOcKkYl37fJm39rk0UDHexgOXNqdW+ni5JEqaJCzwm75v7MV2YThgeWwiXg8lCZbfxv9qpVFJrdfVS6l+2N2DVLPJj/v6MT/9yfUt15UKU7inE8WydamxlhcXT1lXhJwilZBqiEmxysb7N88hoGRefQ3IQqKKLoS2C4G6pIROBHl2YXSX/FWTVE41nDcIjE4fbK31TJDHFy46hBVBFO7yjOFDdHL2m0g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56BUUN1/+y+3Wq7OVCouGYFPUoqEEYdHQTJAVEhXk98=;
 b=bwecKTjuozq8tupN2Ag1yqVTxxTP435lSBTHH82s4cCdedW5Fx1T9FZGW20xU/v4WDGqOUVsHCVpghZxcilM01gwncX6uZJ/8AOPt+aKf+cP1JlMXNxG0B4V5kPubu6nSGESmrcGckzHJIszxeEBpVaDcuDxHSo/IyRi8sCbduu0JoYgw/NpNDxMXNVMONbjrSw36UU3ZN0bp2CKU7/Y49XpHpZhV3kXO5Tkmm0RQOWN2NTkq6FLVj49Qwa18aL+jY2enIg3MRs41Q4J4nwPiCQx6YaKMc7PO7d8Sr8km/qakqS73JUlxck10BYvnI4WzcJ0Cv1j3E0njcIfsCB4wQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56BUUN1/+y+3Wq7OVCouGYFPUoqEEYdHQTJAVEhXk98=;
 b=L5bByoNAT8jDHkIfqSC3Y77oqcVBzXiV5Z/OxL6jsPGy/+yULZvdF5Jjp9WEljdwUb/wxpPClngj3RBLrPXQvbzKslnrzL45Y41dYTNnbV5iy21gcZ61zgjiHQBPFnTlSdsYZxW87PTUDj0gl20vSEiIs07mAl9lFTZ9A7yAd9o=
Received: from DU7PR01CA0045.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::18) by DU5PR08MB10634.eurprd08.prod.outlook.com
 (2603:10a6:10:51c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:40 +0000
Received: from DB5PEPF00014B92.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::37) by DU7PR01CA0045.outlook.office365.com
 (2603:10a6:10:50e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B92.mail.protection.outlook.com (10.167.8.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jrbaFFFgz/HcHb16GWENKzYC/vSjRJ7I45DNN9Pg66gJxzRwEhuRBI7Y9LjQynY1IbCQmg6AgJeGRrzg7+Ew+VhbhZrXsZ/8TMEOzj7RajGZeitzXP7rBLlLo4ac2/uv5rLGCNS+ie3Ez8oYo2hMhVdZVojsmzNWtQ+dycUE0nB/W9+yO1CUqD6ElpyXT3pc0g6rOz4Wyf0wLJGuUw/fNZzE7RzIXQ5TwhHL6u7KKEeV7mKhWi/yPlUKs3m/q9pwY+p8/O6sCCq7mcFFaqMQTYAFAg/Yz+LkDVKdv6R2MrfFtT2LxAj4J4iuUxJk6gDR0tvfAfvIGoF0DR8/HV+nWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56BUUN1/+y+3Wq7OVCouGYFPUoqEEYdHQTJAVEhXk98=;
 b=daC31twNtQZ5z0smTc/LT0TxMvSa9Tm+C3LutUIpTmuJdIOeVRseZpwA2aiFg2FHXgUt/0GNMaYmCJhyKjilRZBUaipP6+vVyy8JU6i/MytgaFPOQdVLBC2CeObP7hKKcUkCwX5lGB9d4reeuax+VCI75ft781ts73jr9w5OrjYxfWvbA2h/MyRKa7VQOHFm/55X2kV6Dii0ZFMKZ/pmeAY5zR5x0dyeYEGJVqCYeIiEEm4Rj5Lp2sN5Xg68ZoxU6lqyZxM8jPMM821Bm+lFTMIJkRtu5C/U49JN6uEdLO2AipRdvdaanWyelZtSFOBbDwrCsRTSODxv9kjCFYkKCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56BUUN1/+y+3Wq7OVCouGYFPUoqEEYdHQTJAVEhXk98=;
 b=L5bByoNAT8jDHkIfqSC3Y77oqcVBzXiV5Z/OxL6jsPGy/+yULZvdF5Jjp9WEljdwUb/wxpPClngj3RBLrPXQvbzKslnrzL45Y41dYTNnbV5iy21gcZ61zgjiHQBPFnTlSdsYZxW87PTUDj0gl20vSEiIs07mAl9lFTZ9A7yAd9o=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:37 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, Sascha Bischoff
	<Sascha.Bischoff@arm.com>
Subject: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHccP9/cRjaE9ujSUGgGwLBe3eVgA==
Date: Fri, 19 Dec 2025 15:52:36 +0000
Message-ID: <20251219155222.1383109-3-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|DB5PEPF00014B92:EE_|DU5PR08MB10634:EE_
X-MS-Office365-Filtering-Correlation-Id: a6f07392-b449-47df-9092-08de3f16c76b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?iq/DZLxp9y35zJm2cHG1+tnattbIuN88kAg0pWItmeiknOK0Jfe+vybIIv?=
 =?iso-8859-1?Q?74TaIxX8/FCJISpKLmOWjzW6DULHCtJZJx3EbykjlGKpu/Et3SvCejgTub?=
 =?iso-8859-1?Q?k1Yhbb/YXHKnow2BrouW5jeal8a9bbvtLdB/MiZWCoZF0vER67DeDGtV78?=
 =?iso-8859-1?Q?YldNMOOBmwNe0LbOU8iW+Uol/2qosirNZUY0LCE+UJR0ykk05EI+Kn2plk?=
 =?iso-8859-1?Q?cr1Lv4aNtI+DsZ3ieb36aHaxqbPHay+MqtEZOswHEjStk38I5oSbepzCOC?=
 =?iso-8859-1?Q?Wx+Nx7OMDiIsB8K4H92TeGo+ZfqOpvTzdP6/YZdVaccM4GJFs9dZQq2U6w?=
 =?iso-8859-1?Q?IAnGIiM1Z/Uidgy/9EjT/jz8xP+iULtPPEucCiT17HanUEhJLpweU2QOBp?=
 =?iso-8859-1?Q?CWMB8cnqxYPC4W++9sSf1I15yhrR2c6SdKhPmtSRJi6Hs3K1QRJ/hMLxXc?=
 =?iso-8859-1?Q?Jx5osSZJSccpksFqAFJOI0zOqkbuqc1iTBZdmCxFSIxupDbzoGeyuRAGTF?=
 =?iso-8859-1?Q?bJlurk28bOxKz1T6cp2lZiNlWgstvdSa9uzMqX0j0aWhx62WKoDBcN2ngB?=
 =?iso-8859-1?Q?J7ARMwUW/8z8loUSM5xQl7mEDfxdCymxURPqBSwZJQCJDTGuKFXo/XsBYW?=
 =?iso-8859-1?Q?nP1AlrPhpqQxje0SD2rGCinoI/nS4d1PS3A0QzCk+nA1eh1KtNOuFDdAY/?=
 =?iso-8859-1?Q?BfEAqrfeN1MU7ZXSTvoeomgGBx9JBeF6B/wRu69laIbnrIm9d7Pxx+nEUX?=
 =?iso-8859-1?Q?LLjppqloqYqK0tLBHDY4mbMChnd7JoEEaSd1T6ubBYczN3SHWcJ4krxs1v?=
 =?iso-8859-1?Q?lcJiB0GEoQQG2uEPREHxoGIBA3EsyZEaglzIucujKXJUvlNZS/3LFMV2nO?=
 =?iso-8859-1?Q?BgvbvpNxg5mhEeFGSsmEdkOqTLPQ0XV2Ou0Q1zr0C7mttNx6EuIDwVbK0d?=
 =?iso-8859-1?Q?zjWkSgXQWWGUZMD2IsPLoT1uOUWmmAQ+w3FilEMvdKGPXGf4bQg/Xhmb5z?=
 =?iso-8859-1?Q?MwyPpQt+H+7GQBlOwCwUwGNjgtiUxvlyzszUIp2ZzYi+lZvm5KqsmHcKL3?=
 =?iso-8859-1?Q?Aj0M3XXn6jpw1KmRZAcL2Z1CKw9rHrOsLxbph6ksgqNJL5CxMQCqoVdWwK?=
 =?iso-8859-1?Q?QNWcTCO/HHhWgRoU8wtIRbdOsmSWL4IGkyrPc24vcRvK/Bvss1BzZ4dan1?=
 =?iso-8859-1?Q?n3Y8WgTwVNPLQVMW0W17v+HENbQeXbOPf2SyjmFLI2Akk++z7+Y5QfJmsM?=
 =?iso-8859-1?Q?Gkqzic2PU3mr9krGDW1Kv0PqrstOJcrtMIXL2xxKxWVwiPp+yBhSzq9q/y?=
 =?iso-8859-1?Q?JnRjuCczyrq5E24xmqN1CmEPC5u6JNOI684FnvDhVrLwWYtrxZ54V0PTOZ?=
 =?iso-8859-1?Q?xSC4vl7kqqHc36W+aE5+jN4wKcS4sbyoXjXPlktCe2sqI1Oisf6lMDlgIA?=
 =?iso-8859-1?Q?+CP4TIhy944Y3g9cR79rlNuJwx2HAlOAuiy2kHai+oGz1FBEiTWMnrrLu/?=
 =?iso-8859-1?Q?O/8amDbQxhQ4ytyWaz44MkhPYlhm/j4jXqpycgloS8tmMCa00PmixyW9Ps?=
 =?iso-8859-1?Q?u6UdsrGCo6WiwkF65T16n2rzCeFH?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6546
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	32eb3bc3-fbda-450f-16dd-08de3f16a206
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?zXh0ZUt5ZnMiBTyQ7p/kCF4GAo3IZjhAPsCW/D3B1mXD3Y8Z3BFOuWxyvZ?=
 =?iso-8859-1?Q?kE8hcceQTW0zOaRPa6jHJL4NVs9mALkjnFaUKx37QVzMUw896qX55+1EBI?=
 =?iso-8859-1?Q?OnBjw9/UYLu6+plcU0DkCAu0AE+Kcr8M0RaREQsnSN4ZkzRsA3zBDgMOj1?=
 =?iso-8859-1?Q?3ygvBeI6gN8XQ+t/oc5JdV9FP+vv4o/rNDatshI4sbvwUBkpOuuiXtHs+w?=
 =?iso-8859-1?Q?AfLytnD8Hd9dhf9BUb/nKVsXLPEim12PcWPI+0JgBnFjtD2hkbxphtWJLt?=
 =?iso-8859-1?Q?if+eYlyEEVWujRfJBIFri9bHFFtGPukp0KGDOezv0PxILaR9a6AFI4evkQ?=
 =?iso-8859-1?Q?JYHECbZSZMmtcLJJlNWvexdVXnoQZxQCxbrgZ3d/DgrflrJ37tMWtYPVMI?=
 =?iso-8859-1?Q?zF6RyEzTisdb6auopiGeXt4hxXPyVc09m6Otz8GCQWlbKrfd4dm4oJkjmK?=
 =?iso-8859-1?Q?qHJMTzPrz3P9Y0sRt/isY6nm+i6g3gyBJ5cOWm3XONwOMrju7B0YsfFs0w?=
 =?iso-8859-1?Q?8TBUiyA11dhYKfedWtUAsIXtIJjUgWiVGTPaaIjK2/+jxL1cYkRUUQax4O?=
 =?iso-8859-1?Q?twfGWNNLeCmu3ZG96VWu2QnGOFM2uu2BzU7E9T89LNB3Or35KHHU5Js+Y+?=
 =?iso-8859-1?Q?VQDIGeUavapjGIvsDevYaTG18+aW7owvYiuXwQVEz63PK61m1swrD/6PnI?=
 =?iso-8859-1?Q?UGECoNnH66O555qxqHKcMEVMB0yUndUFmlWn/2h6JExPfNrDxSRVh1yv99?=
 =?iso-8859-1?Q?ozcQQ9yIUCtGPKpALMMB4tsMs0UTHJizK1hUnbr7uEwvrcUr7lvsKDUfZq?=
 =?iso-8859-1?Q?dDFyHAx+zfpZZuQupGxxbTtEMq9Oha2mD4jbR53QZBrOwdXkWVh/8J1Kbg?=
 =?iso-8859-1?Q?VupsPHqzYrsMCJ/ADuUYP7f7ds7qTbv9r0Z7hLXHx51NcEOcAaN30mHf7f?=
 =?iso-8859-1?Q?eqRWRtxuAwhA2LhMyQP++EKcW0nDp3Y7/Tey0NIyD3Mentq2fbhFuBHapF?=
 =?iso-8859-1?Q?6gbSnOdl9i05Wvl/JLqdrrXhk2fwFeXUjVhYDSzs+CZt+Zj4Q1zFzEj2vI?=
 =?iso-8859-1?Q?n7HldxCo6sPa2VCSlMpR8lUi2qayZCSZjaFdRhjkiX7dJnPp2m1tin01sR?=
 =?iso-8859-1?Q?sxy132IfJP4Am7+/YLkyZYf39a7JeatbHgDRKuKjFHdTTr3RVpWVi66QnY?=
 =?iso-8859-1?Q?x99C+RcjB/nbPyDPnlW/sNlggmHl/Q0rGRVJR8uhERKq76l8/ZI4xIuK2Y?=
 =?iso-8859-1?Q?7+f3ACE28mSPGRGNImcej7+p0Qsh5IMEnAtWGAXTDtrnAMr0BbH0SG4JSe?=
 =?iso-8859-1?Q?7jMz4xpuzkyUVD74V2AzpsGFhDnFe0zHjGit8wHv8RZ9Iyr03ACMhAkbCF?=
 =?iso-8859-1?Q?XTrPw1YmTJvWNsaveyiPbod0jikQSzZLOo6RBj6bLjOt5KtTKrbsb1jaSC?=
 =?iso-8859-1?Q?66zx2wMK7sN8m67ZZ5kR0eyipVc0N22OYx1IzYYewr4AlCOIJXbNGeDn7t?=
 =?iso-8859-1?Q?wmd8OA6iIdZtJwlyeunzluLTeJxRzAaazze0bmlkA1bMzJzr2wDJNGyIEr?=
 =?iso-8859-1?Q?RWKEdqeLY4xSyzRjeoy2h41xbkSwt6syTspmd1qm8GbHCxI1pM4aS2ew/O?=
 =?iso-8859-1?Q?+jGnJxWODmtLc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:39.9664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f07392-b449-47df-9092-08de3f16c76b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10634

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 64 ++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 48 ++++++++++-----------
 4 files changed, 54 insertions(+), 87 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 9df51accbb025..b3b8b8cd7bf1e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -560,7 +560,6 @@
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
-#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
=20
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
 #define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
@@ -988,26 +987,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
=20
-/* ICH_VMCR_EL2 bit definitions */
-#define ICH_VMCR_ACK_CTL_SHIFT	2
-#define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-#define ICH_VMCR_FIQ_EN_SHIFT	3
-#define ICH_VMCR_FIQ_EN_MASK	(1 << ICH_VMCR_FIQ_EN_SHIFT)
-#define ICH_VMCR_CBPR_SHIFT	4
-#define ICH_VMCR_CBPR_MASK	(1 << ICH_VMCR_CBPR_SHIFT)
-#define ICH_VMCR_EOIM_SHIFT	9
-#define ICH_VMCR_EOIM_MASK	(1 << ICH_VMCR_EOIM_SHIFT)
-#define ICH_VMCR_BPR1_SHIFT	18
-#define ICH_VMCR_BPR1_MASK	(7 << ICH_VMCR_BPR1_SHIFT)
-#define ICH_VMCR_BPR0_SHIFT	21
-#define ICH_VMCR_BPR0_MASK	(7 << ICH_VMCR_BPR0_SHIFT)
-#define ICH_VMCR_PMR_SHIFT	24
-#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
-#define ICH_VMCR_ENG0_SHIFT	0
-#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
-#define ICH_VMCR_ENG1_SHIFT	1
-#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay=
 Extension).
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index 0b670a033fd87..298101434fc75 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -569,11 +569,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
cpu *vcpu, u32 vmcr,
 			continue;
=20
 		/* Group-0 interrupt, but Group-0 disabled? */
-		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 			continue;
=20
 		/* Group-1 interrupt, but Group-1 disabled? */
-		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 			continue;
=20
 		/* Not the highest priority? */
@@ -646,19 +646,19 @@ static int __vgic_v3_get_highest_active_priority(void=
)
=20
 static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
-	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	return FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
 }
=20
 static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK) {
+	if (vmcr & ICH_VMCR_EL2_VCBPR_MASK) {
 		bpr =3D __vgic_v3_get_bpr0(vmcr);
 		if (bpr < 7)
 			bpr++;
 	} else {
-		bpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+		bpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
 	}
=20
 	return bpr;
@@ -758,7 +758,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -806,7 +806,7 @@ static int ___vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!(vmcr & ICH_VMCR_EL2_VEOIM_MASK))
 		return 1;
=20
 	/* No deactivate to be performed on an LPI */
@@ -849,7 +849,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if ((vmcr & ICH_VMCR_EL2_VEOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -865,12 +865,12 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, vmcr & ICH_VMCR_EL2_VENG0_MASK);
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, vmcr & ICH_VMCR_EL2_VENG1_MASK);
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
@@ -878,9 +878,9 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG0_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG0_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -890,9 +890,9 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG1_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG1_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -916,10 +916,8 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR0_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -929,17 +927,15 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR_MASK, val))
 		return;
=20
 	/* Enforce BPR limiting */
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR1_SHIFT;
-	val &=3D ICH_VMCR_BPR1_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR1_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1029,19 +1025,15 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vmcr &=3D ICH_VMCR_PMR_MASK;
-	vmcr >>=3D ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr));
 }
=20
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	val <<=3D ICH_VMCR_PMR_SHIFT;
-	val &=3D ICH_VMCR_PMR_MASK;
-	vmcr &=3D ~ICH_VMCR_PMR_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VPMR_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1064,9 +1056,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr) << ICC_CTLR_EL1_EOImode_SHIF=
T;
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1076,14 +1068,14 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VCBPR_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VCBPR_MASK;
=20
 	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VEOIM_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VEOIM_MASK;
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 61b44f3f2bf14..c9e35ec671173 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -202,16 +202,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
 		reg |=3D ICH_MISR_EL2_NP;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0D;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1D;
=20
 	return reg;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1d6dd1b545bdd..2afc041672311 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -41,9 +41,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |=3D ICH_HCR_EL2_vSGIEOICount;
=20
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG0_MASK) ?
 		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG1_MASK) ?
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
=20
 	/*
@@ -215,7 +215,7 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 * We only deal with DIR when EOIMode=3D=3D1, and only for SGI,
 	 * PPI or SPI.
 	 */
-	if (!(cpuif->vgic_vmcr & ICH_VMCR_EOIM_MASK) ||
+	if (!(cpuif->vgic_vmcr & ICH_VMCR_EL2_VEOIM_MASK) ||
 	    val >=3D vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)
 		return;
=20
@@ -408,25 +408,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 	u32 vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcr =3D (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
-			ICH_VMCR_ACK_CTL_MASK;
-		vmcr |=3D (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
-			ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D FIELD_PREP(ICH_VMCR_EL2_VAckCtl, vmcrp->ackctl);
+		vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VFIQEn, vmcrp->fiqen);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
 		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
 		 */
-		vmcr =3D ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D ICH_VMCR_EL2_VFIQEn_MASK;
 	}
=20
-	vmcr |=3D (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
-	vmcr |=3D (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |=3D (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
-	vmcr |=3D (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |=3D (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |=3D (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |=3D (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VCBPR, vmcrp->cbpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VEOIM, vmcrp->eoim);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, vmcrp->abpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, vmcrp->bpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, vmcrp->pmr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG0, vmcrp->grpen0);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG1, vmcrp->grpen1);
=20
 	cpu_if->vgic_vmcr =3D vmcr;
 }
@@ -440,10 +438,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
ic_vmcr *vmcrp)
 	vmcr =3D cpu_if->vgic_vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcrp->ackctl =3D (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
-			ICH_VMCR_ACK_CTL_SHIFT;
-		vmcrp->fiqen =3D (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
-			ICH_VMCR_FIQ_EN_SHIFT;
+		vmcrp->ackctl =3D FIELD_GET(ICH_VMCR_EL2_VAckCtl, vmcr);
+		vmcrp->fiqen =3D FIELD_GET(ICH_VMCR_EL2_VFIQEn, vmcr);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
@@ -453,13 +449,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 		vmcrp->ackctl =3D 0;
 	}
=20
-	vmcrp->cbpr =3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
-	vmcrp->eoim =3D (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
-	vmcrp->abpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
-	vmcrp->bpr  =3D (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 =3D (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 =3D (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	vmcrp->cbpr =3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
+	vmcrp->eoim =3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr);
+	vmcrp->abpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
+	vmcrp->bpr  =3D FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
+	vmcrp->pmr  =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
+	vmcrp->grpen0 =3D FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr);
+	vmcrp->grpen1 =3D FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr);
 }
=20
 #define INITIAL_PENDBASER_VALUE						  \
--=20
2.34.1

