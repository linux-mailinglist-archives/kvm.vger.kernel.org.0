Return-Path: <kvm+bounces-60827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6D8BFC549
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C1F8567632
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B381634C812;
	Wed, 22 Oct 2025 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UOIBz7MC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UOIBz7MC"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013070.outbound.protection.outlook.com [40.107.162.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B3A34B40E;
	Wed, 22 Oct 2025 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140780; cv=fail; b=P5wK0V3KXRTNj8F5b+HDiDVPwY11zPI3OqRFeujyJn5vYc+RN7ro1AKYVnr6iR6+75IhE/XWRnddQYREi2z3TSxG1aaTZjPqHGLvUeFZ7U5X5kxkPBOzHTOJWAf/mAE1gtJTm0p/0zC/Y7ws6J61FCJyV65bweBXWw0STa1wVV0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140780; c=relaxed/simple;
	bh=j55BzvXvClqkS62PF+LNQKv0Ice5aK/+xbHtRs1l0wk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FFWgZZsZdCRt1I1D3IWQPqt8BxUJoBceVnU14KnjwFDTGZEjJwJpUrT4OLggUY4YbuQnwS3Z0m3p0x/50ZZ2M1HfzIEJTV1c+rWTYhvvzyUAm6EApRBYdd24XVxHR6cj7o4I3XgVlw45NSuKgtKTcpTRz+0F6/5D2QC5EusJjQ4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UOIBz7MC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UOIBz7MC; arc=fail smtp.client-ip=40.107.162.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rkXwqFZh7tIiJ/jgtXUR8uegWxUSTuglhO6FvwgLMFMTEoNxo4dkkkmvl7YNsyi3DEOPIs9UX75JIu6XZVV74bDLlERN+nQywX5VkU7H51O9obA76gJQz9dG5jmXcfKmcXhJaq1x8/TThlWIqev7illvJLhN4NN6In9sAphLZ4AeGgGp0E183B4bIKnqWcMLBX9MIGe9nFTTBs9bxVkKEFA3qFpd8Py0fz43bW3GlCBHCwZ6NUQitxz6L6o6meKvP97+831rYxFqgZaWsHXgSbCRmihl9RP/zDgEENapFmdwKorBsMiOhPmbjzJ0mOVVRNbaEpyXUzyPzeNGhiA+kg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NnqajoGvSYii1utgrB1jkm1v/nq+Dviwjf7KE+ayHE=;
 b=J1zGRUnOUoMTzQn6nduhKp6GT6j++srjxMWgrcyrmgEdFVA3eE+GSadkovv35MekgSGJREMysvKQK50RQVc9xiOwioO0MlF5C+vSDCbhI034zZDpT5uv1C4oJHohwWGCxFWDdFCzkCMlCJ5jBrFQ0bHCdtJTmkh9ikVzDSxqZUwYgGZPRKWD9e3bZmwbSuECa4yyZH7SuFKYxBoPtl6ZvXykN9dHyLUrpNmIb0GysDfc/rfpYN9P3oM6J2P8EllPFvdVbQFrocQUXjJ9PP42UGVu8bNRQZ93P0I2y8N2gyKiaGYw+VB7ibcKeeGpN6V0G9QMdinJdeVFp12jC8DDjg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NnqajoGvSYii1utgrB1jkm1v/nq+Dviwjf7KE+ayHE=;
 b=UOIBz7MCf2y1LdPunGgFueuXcGnHHVX37SFvcoUmG+K/rtCAMTLk5OosXgnqen7ZczgdVZf65FSogc07NkrYFmwuoF51CkxL2g9HpKZ5BVF/AYOazDIoZJ0L+/uYaafhx48+KFnT25Y16ZEiZnISjIjJxeCz1hkmIUujh0iFyzM=
Received: from DB9PR02CA0028.eurprd02.prod.outlook.com (2603:10a6:10:1d9::33)
 by VI1PR08MB5503.eurprd08.prod.outlook.com (2603:10a6:803:137::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 13:46:14 +0000
Received: from DU2PEPF00028D0A.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::8d) by DB9PR02CA0028.outlook.office365.com
 (2603:10a6:10:1d9::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 13:46:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0A.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Wed, 22 Oct 2025 13:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVSJX+dFfcLStWFwA9+HZ8Nqfu7AQeFppmfYkdEPlFt8OMdZK0ZGS6pfYB6vluItF2g6WvAt7z0pvRjl3TSmxKggBjTAimMFlxfwzOJ5EfFCwBibpSwJMnvr71jqxE5Z4LHO91HZjjWCxCE5fTW0HhNLh2re6I8ew/of2iuC6vH6fMqDfJCZkyOkkD3enyUQpHTWalT5MCpUcoKJJ3F6EuGnelY/MJsd8PbvzCuWBwZ8mV5vAlNsoPLyNNMEGLh0HAxnh0hVk3N3w4i0mgOfdVd10gnpk8JufZ66KhBUTUeRuu9ShdyH6atJLIJ3JEzovQZ1ZT1FlONMXWOAreZyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NnqajoGvSYii1utgrB1jkm1v/nq+Dviwjf7KE+ayHE=;
 b=xqgf8Ewv7oHnbRa6iiWn8SroEGEw1U+WA0tpGSkI6Nz6VebtaZJ9wyx1NhCMtv/0Zi08KCQpl8Fp33wPrFQhPERLjS1J2GTyhir0LNKX3DEORRm2qIhQg6pVbTWLHmPzbIQWYz/aOeLz4uYMDmlKJeXJCIxBzzdkntV7s79tDDyvs3Lsq1x3dBJ8c2QAvXbmVfMtrDyDn+AIcJWaaxDWgbk8ZD4Ct6E1rEYzADXwOlWiAfKKNFSKXv3Q6XaUjvTH9fz5w9nx0QpPP2yLfEMW2/OicqVcE6An0/xtiD/PsSzOMuFATyKo1OivLF0GhKQ9LxdBicvnml434ZrwHBO6hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NnqajoGvSYii1utgrB1jkm1v/nq+Dviwjf7KE+ayHE=;
 b=UOIBz7MCf2y1LdPunGgFueuXcGnHHVX37SFvcoUmG+K/rtCAMTLk5OosXgnqen7ZczgdVZf65FSogc07NkrYFmwuoF51CkxL2g9HpKZ5BVF/AYOazDIoZJ0L+/uYaafhx48+KFnT25Y16ZEiZnISjIjJxeCz1hkmIUujh0iFyzM=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by AS8PR08MB9244.eurprd08.prod.outlook.com (2603:10a6:20b:5a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:45:38 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:45:38 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v3 4/5] arm64/sysreg: Add ICH_VMCR_EL2
Thread-Topic: [PATCH v3 4/5] arm64/sysreg: Add ICH_VMCR_EL2
Thread-Index: AQHcQ1olriD8ar1h5EmSA2Deb8RyIQ==
Date: Wed, 22 Oct 2025 13:45:37 +0000
Message-ID: <20251022134526.2735399-5-sascha.bischoff@arm.com>
References: <20251022134526.2735399-1-sascha.bischoff@arm.com>
In-Reply-To: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|AS8PR08MB9244:EE_|DU2PEPF00028D0A:EE_|VI1PR08MB5503:EE_
X-MS-Office365-Filtering-Correlation-Id: d31499d5-15e7-44a9-786c-08de11715cfd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?59HoTHLG9U4/3vHK+L/A3KlSCWOS0pNXHNKiMoDSMRTH1+xxJcUZtLBE0P?=
 =?iso-8859-1?Q?XJV0hZXZgT5WsW9shxdAHYO4FnDEOzaAmFHf6yvBW+zaAdmO0V/nNJcbPk?=
 =?iso-8859-1?Q?DNqx0Z+lpcPNvXl9zo05Uh7863TeGIYUH+iZWuA7isJpLk0b1MMz2VT1aj?=
 =?iso-8859-1?Q?A1ACoYAP6jP6c294IBOSMKlzmCo5t0mwNBi8tFmeWYMgpjFguERuKdWvxu?=
 =?iso-8859-1?Q?XUTf9yKWmmn0i/dhRXGoOWMpBVXERQ6HEtAmWps8LxBtlGHn0TEQwvE+9X?=
 =?iso-8859-1?Q?+NsXDTZLLq9547BmXc9V8QaF1ytVqQ74408KmBjmg+mVqHklNVxSQ6DPPN?=
 =?iso-8859-1?Q?iKq5FQSQInuz2EXdMzQtZ/qMcgz/DaWLDXvrXvm5lCsz0JW91N31r41W1m?=
 =?iso-8859-1?Q?vkGLcIoiSP8c6VeANRe84DmQohoMZUqQIAIC5KXORL4SiHCpL6SYIMbo9d?=
 =?iso-8859-1?Q?Te3lbClq20bZk9gavDnhE9cd0gXC7K7llRzPxlxXLoTLQybrQ1LHZ8nu6Q?=
 =?iso-8859-1?Q?JhNUWcFy8L1JWFkfSDJ5xdz6IGhTfji7pbKdq7mZHF4p7+agyMsFE4y/Uw?=
 =?iso-8859-1?Q?cv31tWwRyZk6Z2WgKjehc2hJ0kteNrv8Yh7MMrra1YWS6LAW3/KsiXTZdN?=
 =?iso-8859-1?Q?LX+l8NKVVZDUPb9anwapgn2LQahtD2JYFG2O30ZJ6KgdCC/mdGkKZcwYJC?=
 =?iso-8859-1?Q?PiLnAY8hT94rhF1ou01JWju2dNkGd3ltS9bjlAyQ73G34d7ji8I/tG+OM2?=
 =?iso-8859-1?Q?h7gAt4P8PZwhpIw/Pw4qaM8Ymj7kwH8CE8CtdfmiqbRJ6vxVfgSLacax6Y?=
 =?iso-8859-1?Q?m89LJLtBMQtc+42rIFZ2H8v6vqK6C3/dFHj4fgd8NWkxsi9+ogvf6tFLDa?=
 =?iso-8859-1?Q?vvv0cIGUA/7zaz7KaDrQrQ+8Focf8uYoPIalifc68Xr72da5AOlWMBTYcH?=
 =?iso-8859-1?Q?5R2QdgkzLjgFuaHYVbXV79yPEqA1zeJCA0qDDHM4+o7gGGjnaeStgYgW1n?=
 =?iso-8859-1?Q?3XS7B/hHJpRmxfCkF9HAFtGdSowmpuXk3EreNEM8zif24z/kVV9+LKymSQ?=
 =?iso-8859-1?Q?pc1+U5dQUPnVUTwgYAaPhkolGk0zDPm3jrOQujsF4DoByu8KmmW3j693D1?=
 =?iso-8859-1?Q?eaqTfzibZS1W2IhXmJioIr8z30aYZqJo9SShEZxRpZUL6Qo1e6oUWzH7bt?=
 =?iso-8859-1?Q?gogtvMZXw95OO32yIsujbc/qacFI32y3SmLHx0fgWBlaOHNa8jG2WnLAYH?=
 =?iso-8859-1?Q?9JzgUUT+jVEQV0cntpG5sbB9GznlAZgrGhBKzG5xSwnIWX7QqupH+bQk3g?=
 =?iso-8859-1?Q?bWbV/phOEShqC0Xz00fxhuif8ClC9rDq5nFc6dvTQrOfQ0FO3VSTRBBgnt?=
 =?iso-8859-1?Q?s3ishUcd9kmTKsRpqFQ1fy9dcNfVemlVn7Dw4lwgxKZpcxfrYnR/kt/FIN?=
 =?iso-8859-1?Q?UxzEZ6zcD6V1CoS14gDu2ItITB9ooLb7LRV4KkcgmrXlASZq2WtLNcD570?=
 =?iso-8859-1?Q?Zzvt/P41CfEWiA+nJZcUWwRmwDtwkGwpj7T22OB7+JexXbUeciR1nzpg9Z?=
 =?iso-8859-1?Q?j/tGO+wM6+kI/Iq6R3/WbeXrvfN9?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9244
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0A.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4f29d3c2-d76b-4f62-33fb-08de1171490c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?04IcObECeK6jIPHpAOgAA5BDPvwq/CTj0pS+FHCW9PQuMudUVwsv4Xv1fL?=
 =?iso-8859-1?Q?4dnn5wymcSS44E8AvjFJbBTHhDkWxo1VG2RMdPd573Yd0vJDk8HFQiEtHG?=
 =?iso-8859-1?Q?N2R5ibFWM+8oia2FlmvllBR8VWA/+hyA4HekmRT2uRBXkE3CPl25fPIHzb?=
 =?iso-8859-1?Q?xrNVFHGgcnuPOreqlqb1za0GzideIE2Ue7sY+yrWYbjRramrEKulP1SR69?=
 =?iso-8859-1?Q?uu89Ivn5jKt7p4oUHZ7AxeVHnOsHmXSU6PMEZ9qXX61LcnI0LB113uG10R?=
 =?iso-8859-1?Q?h/QdsjybDmkXbp9UXcePwz/aCFQSISBdqcYt8IS+Le/C6qNm+2uqfhUW0y?=
 =?iso-8859-1?Q?D0/zyFrDajU2HR0u8gMwpjl8h7ivPRPYmZ6MVsq5bTVDyYuOxygEpPmr/c?=
 =?iso-8859-1?Q?mi/O4SuXDpeTZJNZgwEIU3dIZSjk1B5TrNKk6zy2N//ksO6u3XQA5RTK1F?=
 =?iso-8859-1?Q?3qcxYmMVGj7jEK0oAEdZ+g0laVY2ax+yK3vLu07RicVTECBrziY8ZxUU4G?=
 =?iso-8859-1?Q?S91gGWSboWdSGwlsezPapdqZD3sjXkHZ2x69yM/Ow5lZkeZfJ3OAJ/Qcma?=
 =?iso-8859-1?Q?22afTI+mUqo2BHZZQaY9QOTTqH3uywdG3nZMgHSBgJRhd4p+v5LQnmxpHJ?=
 =?iso-8859-1?Q?SeurturbBIDJeQtlNCcrbuMS7g4QDJfxnzrZu2iUodNUoCCDCl3V3E/HeF?=
 =?iso-8859-1?Q?U9qm99gPqh7F16MaQXaQ4LK5dsJq3ogIThZChQZyCCba/vlkb1m936+Ejq?=
 =?iso-8859-1?Q?bg72Z9t3IDaEBKIIgpK5z5vX6J2SD6vsXBFd01oEzbsPsxOESGreP7eiOG?=
 =?iso-8859-1?Q?D8+c8amPtNR5d1c8UYxBLSybgXyvmboIAlsXBWzvPhuJtiGTC5jjpZ7xvx?=
 =?iso-8859-1?Q?w1Y8MW4jqAcv7UcJR/U/usFj8by2jYvOEoAJD/52B/weAiadB7Ex91D2jv?=
 =?iso-8859-1?Q?ftBA5x+oHmrsYrIl0eZJh9c07End1v0D3yNQisl/VWskHNZCJAuiGYk752?=
 =?iso-8859-1?Q?/ppJPe/w6Lk+1YwR9pAG6cqk/QdIZr0YqrdoCXYl5DRJu5sdp/aYMoLSIQ?=
 =?iso-8859-1?Q?atDFqmXPYhl88GUXEuMR8DsWUaUU/o9EEihYfO5KreRABA7HKqeq+XZ7YP?=
 =?iso-8859-1?Q?xkZDtj0hskBUtsFiGr6FbCRdEL66zS66KDNHIZdsDAdUl7vyA7gxyojnmv?=
 =?iso-8859-1?Q?IFtLu3V1+vpth37DqeOV5wILPAeeTX4B+P50FsjIOj+fStoZEytugfy5Vx?=
 =?iso-8859-1?Q?jCcFWm05lwWwQbslsKMjLhU8eFVxNQBqmzizDy9z4CQO83KpMg5cWg2QZD?=
 =?iso-8859-1?Q?wT87r7GMYyVOxb1t0pUH4EjMIAA80U6WGHqTA+ihjRgGYhr/1446p4CrdI?=
 =?iso-8859-1?Q?EejJJzRfHMssqlcomY2zpBfxDL7pf5ovQRBANZNiZzLbxaN6bb+NGH5+c+?=
 =?iso-8859-1?Q?9ZXd8KMMq4/j8q3ohIatLMGUvC1Ontwxp+S7qnZedKQ5o6KFLxBMih9dEW?=
 =?iso-8859-1?Q?8sBQgcw/piX+jhnVQiT6JYMHpr5D7vj4WAMTfmEnGPmW7eFcHOTqsKqxKu?=
 =?iso-8859-1?Q?7p08C4VDPAAZ9tn/F+/Lks75Fth6bNV46Ce51AERNLwPHlQL+qkQzpHmKw?=
 =?iso-8859-1?Q?VRIfKFje0I8sY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:46:12.1321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d31499d5-15e7-44a9-786c-08de11715cfd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0A.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5503

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

Add the ICH_VMCR_EL2 register, which is required for the upcoming
GICv5 KVM support. This register has two different field encodings,
based on if it is used for GICv3 or GICv5-based VMs. The
GICv5-specific field encodings are generated with a FEAT_GCIE prefix.

This register is already described in the GICv3 KVM code
directly. This will be ported across to use the generated encodings as
part of an upcoming change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1c6cdf9d54bb..8921b51866d6 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4669,6 +4669,27 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_VMCR_EL2	3	4	12	11	7
+Prefix	FEAT_GCIE
+Res0	63:32
+Field	31:27	VPMR
+Res0	26:1
+Field	0	EN
+EndPrefix
+Res0	63:32
+Field	31:24	VPMR
+Field	23:21	VBPR0
+Field	20:18	VBPR1
+Res0	17:10
+Field	9	VEOIM
+Res0	8:5
+Field	4	VCBPR
+Field	3	VFIQEn
+Field	2	VAckCtl
+Field	1	VENG1
+Field	0	VENG0
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

