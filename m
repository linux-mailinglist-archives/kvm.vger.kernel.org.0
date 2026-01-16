Return-Path: <kvm+bounces-68376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E7122D38450
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3C43315643B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033EB3A0B27;
	Fri, 16 Jan 2026 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rsGHAb6Q";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rsGHAb6Q"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010068.outbound.protection.outlook.com [52.101.84.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FE939A7F7
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588087; cv=fail; b=jhQV8wS/m/6EHmPczhZKmNfoPs0iBXZllN8gJbYZwI1pGykdJWq46uVbQX0+0cKAIt+HXhJZl28q9fPuXC4uFfJNouEQiylidNVIdSG0V0u4ia5gSiBLDkEIdGxf/g2X1u0zzbNFjqJU9dmxrivHYn9/pVUzVwgCdkUYKMmRIcE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588087; c=relaxed/simple;
	bh=sNUljG82h3yW59v952AIaMjnaiQTNGyJldaYrYY5bss=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ggWQ2+gViLTQT2htN49FETNsICy5bOUyqIK4iAp73muriSAJtw/A0JRf1mkilpCXjyk39TEEannRSJ514bIXWOLY399/95KOA99ugB6eXVdBtCof6Q6r3bqiQsCDmVp5Wkx14tldi2R/T2T8OaHyfHR/fSX2jteCQCcaLWtogaw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rsGHAb6Q; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rsGHAb6Q; arc=fail smtp.client-ip=52.101.84.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yz9VJ2UdlnHJAxP/cMLo9VQVXF80SC/wNp7g0n8twbcud/WramTQxCXXM4PNv2yCsMA2/VXdNsu5tCTYh63OqRVx56klQIesPj2pnvYy83b/3x13wPDyDSmkYVQiaEvBoxzVU/MRNZfeX6b3mFzjuXfHloHvXu0NJSLKCTQPVWbLGjG1ETA3nUsE6AeFPgh8Fw4DPiabwZ4nI5V6pJsg9LLOYskfV9hW7CTEfTnhDILr5h1MbACfaxXpAGoTaDlykFzBm7NtAZKdKLSxQYl6KYb8cK7VlKyt7zVxjZ6cchkF08tguskbT3dE3aXYWCzVxLI6ZXYv3Dx+W0PKOXWvCg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbs9tl8fH+Hsu9ljhK5uEy03uI9QIsEuIB++5J9MjDY=;
 b=vvAPONUuvj+EoO9ky2ZCRmOOmgVnJ0C7/zdKAp38WCWY3F7IYN7frg9shu1OJRBbp8SNxOZTxB0B2SfQ9X124LKn2v1K21yXcSA393JveTDvxcZAuYlk5H0Nz1oHz4Knao+gBJAjSakEeh0GJ4CZ2tWEPt1GjfMXYJXKm76qRf1BzDj9G64TLSN98ydnRfUzx1h0QN1N2TFv0NIhrobi7gmOVLVuvQv+R9WcnjQg5uQBty51274VqJuWutQPfPlHaeyMrVTJBYWGmlybziuqXyWXXd39D7C9KD/wgNItNHYKROtLT5g19Y0LgLEVv4hc0RvVuFw9KonK2zNfG9pz9g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbs9tl8fH+Hsu9ljhK5uEy03uI9QIsEuIB++5J9MjDY=;
 b=rsGHAb6QdS9RWqUI+Fx8qsoBvlBdENaCWAFWl16eVobyg3eqAQjhUPXt+sRLnaiQrzVYR+niWBXF7KYHc6ik0hlTDVcXHiLSwPN9gDGlKUFe17gPP5ynQsm/uTOIn571beVH0AptTamuNDEzNV4UhJ4vi20i8M9B99y8dVK5HBw=
Received: from AS8PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:20b:311::15)
 by AS8PR08MB9550.eurprd08.prod.outlook.com (2603:10a6:20b:61d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:27:59 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:20b:311:cafe::b8) by AS8PR05CA0010.outlook.office365.com
 (2603:10a6:20b:311::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Fri,
 16 Jan 2026 18:27:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:27:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WWqUoXYfZKN9xLBoBEZRqotqwVS5C/ml3C4oXkj8231/rn+TRAr20iNKVNB4Sm7KG/hs74neYgUYO2jLmb7tE5/DrMKshn1kBzTFHm7s0ZYcMrdOCwe0LzxeUpzjdeRid+FiuyG9k3FwL5tFi9Uex5f01uEGNOj+MrkcwsZkMzb8LscuyBRsSpy9Xfm4m+7xPjggS5O9hS8LDNZqLX0ix2MlIHJEb67WSODNH/MXikjGvPkERgDvCr4Wd8tH5sbcbEnNrGyLAgegv/yBgD3Z1aJZhxTojf1M7jyjWtj24MyYZNuaSgKwOWHC16GloYr2SiiMHjU9nPxAiS/JN8B5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbs9tl8fH+Hsu9ljhK5uEy03uI9QIsEuIB++5J9MjDY=;
 b=de8Ok3NMlEDyUCFEH5rDpZwIVX37xnlVlav8azgr2ZHKlYohJ2kBnmxeWeA8Ki1a4o4AfbstxNtalQhL0sfSQ7yuCnYU6OfzFvdsN/UshaEaUM0MkQ6XY4hsiA9oubhhNmX1yla9Ab8Z8CtO/Unp8qA0Cw4oKadpzjZ5u6jaoJtm6tiat6VdCt3y6dzpd5OayIuIVAcNYdhssp9GAdH+MdfOLTvn5V105SYMWqsOlfFnCLrzB8dlH2EHtibZdPuX3GncWlp1ageS4XB9jDo9Rt0Y9y34460Mtqc6C3y8+qX2YB2BH35aAsD5KelZ/nXF9httYE6PFmYAnUiK93y3xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbs9tl8fH+Hsu9ljhK5uEy03uI9QIsEuIB++5J9MjDY=;
 b=rsGHAb6QdS9RWqUI+Fx8qsoBvlBdENaCWAFWl16eVobyg3eqAQjhUPXt+sRLnaiQrzVYR+niWBXF7KYHc6ik0hlTDVcXHiLSwPN9gDGlKUFe17gPP5ynQsm/uTOIn571beVH0AptTamuNDEzNV4UhJ4vi20i8M9B99y8dVK5HBw=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:26:56 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 09/17] arm64: Add phandle for each CPU
Thread-Topic: [PATCH kvmtool v2 09/17] arm64: Add phandle for each CPU
Thread-Index: AQHchxWycCnLIznfjUCEgikgFXDkmg==
Date: Fri, 16 Jan 2026 18:26:56 +0000
Message-ID: <20260116182606.61856-10-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|AM3PEPF0000A79B:EE_|AS8PR08MB9550:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a188d36-d796-4c62-61e6-08de552cfa2e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?g3FQ2m5cC02STpeENd64H4c8BDU+RQYCHinnf3AiEwBQI3cMMd1pD98VzC?=
 =?iso-8859-1?Q?47GOAFzLtq4hJXi65LlUJTGRQRi4kvs7UAaCnZyxLOHouFWcLDWHF2XDgv?=
 =?iso-8859-1?Q?QdyKzHjcpoYzl7YGqsrjCtPTWgBjzhuaqdP/VW9btHQxMJ7fg+bC0cPHD0?=
 =?iso-8859-1?Q?L6g7wNNNFbUack1FWBftf0M4wNuoDqIQDjr/pnh/T+zLpJr9i6ykLe8nxn?=
 =?iso-8859-1?Q?lS8xe5uecYeQiLziJK6PTNrbwpCaDm4xwlEEQYOsRYzf0a5gkGPKUoic1L?=
 =?iso-8859-1?Q?Rmdm0HsP2HO4oY7/Acru0N2uSY73a5rn5PnHuq0/G5yRa4KXKm/nrs+tEl?=
 =?iso-8859-1?Q?4XNh3dq9wE8AIn3td10pUy19vi/j0XT4BI6jl508/fqE/doWaRAOyswNTb?=
 =?iso-8859-1?Q?CLLvTpvf72F8wqgErfJejS6UYIZadcAXV8eBRuMiS8Iqu1DFRMQeyCsKox?=
 =?iso-8859-1?Q?WCWWxVY3KJ347nuCxOV9pMMs2BNIPxHIU0I0p4gzm8mTfn/9oVse4v4Ki6?=
 =?iso-8859-1?Q?HGHwQ98zDbtJeMOuA36qGErpLVqU2aez2VDHdlTdz7qlHqgJKbzgeS3ehJ?=
 =?iso-8859-1?Q?9pF7XfuhPM8TkY4U2rHxhbIv4UQbh8mfUThTGVzx4TDaV5WPKcsC1x6M8M?=
 =?iso-8859-1?Q?rgZSfpgC5q5/xEPVGnGiV9t9XZPVgZ6CKubE404vnqkx6sWmJFll/wYT9Q?=
 =?iso-8859-1?Q?i6Slp3Fx6lRhRupQapbW57j/x8BaZel4HMyLxC5kQZpaUKet1SFmuh9JFM?=
 =?iso-8859-1?Q?50FsJxp4WJEewpTYSHEvyhNRgRmzprnOzCVaGHNrSPOPQQ86cOGoLWxLLQ?=
 =?iso-8859-1?Q?ESAnH6RDVHNEJ2TIgIikgDUnB8h8BJ/PduTg0NuqjGUVC5VdcMX09i0ONA?=
 =?iso-8859-1?Q?zsVnn9vJCpmmSG/OxdvRaQeDswR9ERgceYFL1HZ+2nGjiLLbW/yit7VLAt?=
 =?iso-8859-1?Q?WotzkifG5cEk5iNbtXPAwVLFafS/m4QGcCy+iyh77SX59u59PXqXHLj31B?=
 =?iso-8859-1?Q?uPgdtbaKt8ZI+GsjiOy/BcmttL236vldkCCjJ87OWvpk/RIMQmiqfsWNI0?=
 =?iso-8859-1?Q?Wc26ms6WT3s8DN2F31ALSPFYsodPkJxgwhxb7SG3hjuDNpAf8X9/+UrGLJ?=
 =?iso-8859-1?Q?5yNYcNserfI5+hGzrg8FNAxhOBGEXV7jV7NwTN/2u4xmb2qIyBusPVBxui?=
 =?iso-8859-1?Q?WkiDZRXk68ozgtOR5X0vkHV65La360myIdXzN3PmRX8vwvPFYenm+chxHD?=
 =?iso-8859-1?Q?XvoNNfWbxCaJSRW42m4AHA8KYDM5KN48RY2OQZqtrHmaFgAdUVhi2L4rAY?=
 =?iso-8859-1?Q?Eb4dKdwZv+GCEs3rs8K81Z5/2NheF6XNSzjAW+hbaFv8FUnhwgqg7zsWzK?=
 =?iso-8859-1?Q?TXLXMD/LeQUin0Y9bq8U3+m5Rp2/chnMKYMsUom3KHBZjQSr8lIlR2LBvz?=
 =?iso-8859-1?Q?n2H6NJtEESIH6AkXdMwGmo/UzoHe+8kMchzlHYLSA/ZG5kgcQVzZxlGjvM?=
 =?iso-8859-1?Q?DSjuNB/Sd2Xp2401k+31NbnRkJZtsQkJxwubApDjNW3jl6LlhoA2WWvCPC?=
 =?iso-8859-1?Q?a+8i0RBDv/DmZzOti1F+4PINAB/6vVh/7Ayn/yxQB8mVHc9Qrm61+mb7Xr?=
 =?iso-8859-1?Q?HbzlOFAN+Yfpyf4CPnv8MKBRVsr8u8JNRnzuCNk2BhId2MG7vt81wu6wX4?=
 =?iso-8859-1?Q?LIN2qNVat58QkINIqkI=3D?=
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
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	933728d6-975d-4302-e2ff-08de552cd4a1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|1800799024|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?4qXdtZw+iwdrr1oTiiO3ZHyQKqwLZ0h9e5an2aMcwTrNCcc3nJyzaJYeFj?=
 =?iso-8859-1?Q?FVAyAAZDsZcgYXKaLWBUs5CRfKosjSr/vkCPwQyD7ozkArzY0mMECQwCeX?=
 =?iso-8859-1?Q?T9lxR5wTSSwtTRvxnc6P74AmqnDRL2nITWS162YWYyNIBf2xVy3S5yEGL/?=
 =?iso-8859-1?Q?7L6ysB+EOptvbVvCSQ2ZZq2/DgwQWk9FoJ+O95gaCmZ9AELLkhx2o/kK7Z?=
 =?iso-8859-1?Q?joNGxilXIhsxHofHLYtDriiVy4ZDUZBHs8m9Tr4b6nXnC/PEFicHLN4mYK?=
 =?iso-8859-1?Q?BHeycKB+agh4xOE4Dq6xxjSVYKQe8n9V6zsuj1u4tMgPxDR1IQpQ0sHHEd?=
 =?iso-8859-1?Q?GWzv1BdQd7FcmUEguuaMRzMaY7GnEtOUMAo2fgIgvQ8i0Nrq1EuqxAoYPc?=
 =?iso-8859-1?Q?/hxjKFOuEU2L74Mtn685QJzi6uH9EepBBKObO2h1NLPjfJKTKx6uOyTRLo?=
 =?iso-8859-1?Q?BRjYR77pFRJeGAs1yUKeKUU5YlomGMa0NNUl5QsTPtaFNyUmDcUjmvlktM?=
 =?iso-8859-1?Q?vM7VyFjesn1DU0qhJBVffNYMOgAJBpjCErgcjR2pD7iqSPwBnYWvYCydQv?=
 =?iso-8859-1?Q?ATAajje6olLeYoWhZ7NbIDkNaLDqUJBfyFC0VfVf4vWVgxMX3MqAkOQxoj?=
 =?iso-8859-1?Q?QiZ5segv/fE8emySo2HGBbCWl7hqG3+mm7x72DqLP66Embwf1I23epICIe?=
 =?iso-8859-1?Q?jZfXVHS/nLwwKLfxn6V4yQMKAbKPw7rsu4aN+sybzQSy2nkAWETuGFHnDe?=
 =?iso-8859-1?Q?lbhnftRkLIkYUYWBfmy+BGBeOj+heyQcM4eGhZP078JBX96/FsB3/RUMnb?=
 =?iso-8859-1?Q?vSC2/GcFU3PC4ymON4rCoGOos8zgIy21XvnQ5tfvqhXB3kyri34o08Q3uA?=
 =?iso-8859-1?Q?qct47XhWu+LL8cOAV8igmynz5gQIYC8HWtIwVx65iimpeaJ2GmdS4ilZH6?=
 =?iso-8859-1?Q?Qv4oFKRY2vjcaTs6mPrPqAYdx/BCy8We0fV6s9UsFRyFQSaCPhqoS/gqM0?=
 =?iso-8859-1?Q?lX8c2PP7dSzHCMuRDLvSkmvoPe/P7NMkiFXk3wL0yXIumSV1OvXqHwr9OX?=
 =?iso-8859-1?Q?jB8HWkdPa8wPfGxps49a2KLLk1UTfQisibjlcYord2FwrPI6m9roj8ofQ+?=
 =?iso-8859-1?Q?Cn68C86/JW01NCeR9bR/6CcGwOvLdOE8dVtj6zaOnjvSLeJfstT1ZnadH7?=
 =?iso-8859-1?Q?oVrwThV2I6ZgNNdRCKSNCGovTBFvSm8hHUI5BCJy5MBwHkFod913r8Qhv6?=
 =?iso-8859-1?Q?/2s9g7Qf9Zql2Om5Rm5C1KJFVy/KyNm3kjC+Lcbz65n0fV99Rg+s4k8LUC?=
 =?iso-8859-1?Q?09DK5VaV/ds5cZgzL7F4bHLKrZVUyumuWMvTXrOYT5608wev/Ufq0BVeo9?=
 =?iso-8859-1?Q?Dck4qiEG62UgGTovC3e3Wt9fZrpam9ykzGrvd6Qc3jUCGN/mQ7+lAXvpsZ?=
 =?iso-8859-1?Q?K34HGue5LOlehwkypyPzMfEzFVoCx0D3Bc9hkLtnsVLS0HyoyG4NYzoY2Y?=
 =?iso-8859-1?Q?8BfG6IyxhH46vgsp+kco/M7bPP/p92XxoUb/xN5JdjX12BRynjtwdrOmLE?=
 =?iso-8859-1?Q?le4G4+BXQY+Z4MEYG8RIzQFidszMmywl+w0hsoQTohj77E4HbHeJ2AxlLv?=
 =?iso-8859-1?Q?nGX0QH76Sr2gDqyEr+NU6uKZKLyzUkPuqpoXPxhMb9VlwspoqUu6IH92Lm?=
 =?iso-8859-1?Q?Di/dBfkvjkWsgV4XcjI3zG8cN6q6S35rEDFsmi/oylEhfn9dCjp1iO3rvf?=
 =?iso-8859-1?Q?kYZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(1800799024)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:59.6576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a188d36-d796-4c62-61e6-08de552cfa2e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9550

GICv5 requires a mapping of Interrupt AFFinity IDs (AFFIDs) to CPUs,
and uses CPU Phandles in the FDT for this purpose. Create a per-CPU
phandle when writing the CPU FDT nodes, which can then be used later
on when generating the FDT to create this mapping of CPUs to their
IAFFIDs.

These CPU phandles come after those hard-coded for the GIC and MSI
controller.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                  | 3 +++
 arm64/include/kvm/fdt-arch.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 98f1dd9d..44361e6b 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -54,6 +54,9 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm=
)
 			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
=20
 		_FDT(fdt_property_cell(fdt, "reg", mpidr));
+
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
+
 		_FDT(fdt_end_node(fdt));
 	}
=20
diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
index 60c2d406..3c3bd682 100644
--- a/arm64/include/kvm/fdt-arch.h
+++ b/arm64/include/kvm/fdt-arch.h
@@ -3,4 +3,6 @@
=20
 enum phandles {PHANDLE_RESERVED =3D 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_=
MAX};
=20
+#define PHANDLE_CPU_BASE PHANDLES_MAX
+
 #endif /* ARM__FDT_H */
--=20
2.34.1

