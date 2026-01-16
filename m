Return-Path: <kvm+bounces-68380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E47DD3845B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71D71316F9CB
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028CD3A0B3C;
	Fri, 16 Jan 2026 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nOXVBQNv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nOXVBQNv"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010050.outbound.protection.outlook.com [52.101.69.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1123A0B0E
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588111; cv=fail; b=ahlApEb9UPb2qAFbswM/WLkEYSEv3Xao37/0vlnr34LEGdc/+lv23o7kafFC2U5NPWETTAhyTeWeA9W6r+iLeTJV7fBreeIHe75agwsz/QLBzdLWsSuJOMJ8EEIDc8uPVFYvqoRH89i/r60n7M+miJAa3z++UNp1iGE7PKmpBSo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588111; c=relaxed/simple;
	bh=CV/xcYzCP6sOXCrXYwnAGe5KW/qi3mu3twSGgZSxRwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PSNvJ8OvrlLh3uuB5Z0/oRNr7bSsQZv/4uPyJfO+5AGMPT/N3aw1SliwMv9PkREZ98+kLHAyXzF9P7LIVifYciJIH+/qijA4OorAEkCZG633ZH6dccMzifGGN1iPh2/PEAcoKb08eG+9tB/JcvVyjvuvN05DrhekPBRfgAhMG7w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nOXVBQNv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nOXVBQNv; arc=fail smtp.client-ip=52.101.69.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NYiKdhjsY3zBMgP2gKRLDlrXseGzTeHzla1W5c3i0tM+gPXc+zCH3cAw0ZIhYJtmQrRLh7tnaOxi/aHdXeFyUu8nPia1155vRyId0G4HAsyDfexP7Kz2EcTZGusaR5kdm46mmZfp3HxROO8rMaPXajm9R5E3guWHrqRkxYg3jO+UouRBcD3SRzip+chbUkwmYvO9LB3sIMvllAs09inP6ftxHuHiXbasZeEyiCf5MATsqOR6WJlNq2iQc3SKIszYttkF9aVw2FNRScNwUyOyBHd7Evp/XMxkOaad2x0+nk4nZAxGZTuJGj8mC+cxCUBP65oFhOlw0Nm4FBxTFw57PA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=eARfOjSutoomNE8CyEKw3hvtfEi0BjC7zLlg6J58Nt3vfYMlSkeTpgF5S0vWYr1vRbuSt8sjhQCTIP5Ns/Wo7TWaBQv2hqe7KFzfO1YtUU4Q7ai2TI7i/JWuu65rgq4+8TTXEQErr0Ud1UQuVZ0Q6U/3Dm5qvBZfawgx+jLIqLIqwGq8P22hwYUJvX33IkT9BnhwiMkrosn5dt4+MDrvtNWf3refPlEL07uyd09OtEiQY5pZwsew7M08arwB8QBPzTkHfk1W63xXdZcvEDJHXuJxOtuYRGRDen+iqnPQhTZzmDhVP5eyNvQEKrBoHTcKQGzaxr6U4rsC6RudtSftlQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=nOXVBQNvR2bxU3j8nNpwlLJabUSvwt5u409isBx1MrzcLi53isxvPb5dm0dPtG4s6eZM9BUWDUEzekUP3d9znSh+Ztp5SuEXBdRQy5XrbuSHbf+L4i8Pt54hPmOjn8MLdLmPSYMNsM8bDYO1ORZ/Uf483JHVDq09inNhuVjiY1c=
Received: from DU6P191CA0038.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::22)
 by DB9PR08MB10377.eurprd08.prod.outlook.com (2603:10a6:10:3db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:28:20 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::38) by DU6P191CA0038.outlook.office365.com
 (2603:10a6:10:53f::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.9 via Frontend Transport; Fri,
 16 Jan 2026 18:28:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:28:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fL6AsGgzbGP9K7qnkht24dCHXveDNqvxBThWqBqhJEs0gM1SBxkTbHj1xFrUTjuFHC7eaDzJ/so6vMELqQuFD4ltuO6W41AMWSc5q1vCwl2SADvtOW0tcKtr+5xPlSOXCsOv0SxUsTw+ewZ7odXW2ppUgDRy/LjksyghWZyPGZot/eS4NFjNIpzEuQLA7dPYQ12E+8QlRVqMymlScz4mDlWaeV4ajW/TQ9xXhwUY1UMkwiWWO+FczAhdza4/3k0E6Yz+SPlBxiYCu6RjsQjDIwfz/YD5LwDcmW5Ch0exUnYON3ArFU5ihYDZFqKQ63GfFCoNYk61p/bm218r49gs/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=WuWrOTPadYrY3tU1zlB+l4IR39TqMupYrN2pETCFFXMr5irpRA78DT6QwjW5YTzStJZpTMfnfbSpFdyW3MdeUBBtaauEf2zjZsr81HSOFss40nqtPfkYdEYOJ/WiV7XlJGN8GgxkNZfsCB71qsxxx5iIqB7pRZJbeJ1ipgPJvPqIyZzwFr1Nx+RmLgQwYSAhFWpp8D8di5aMZWc6W7KrELvKOh4DtnZKl4S/83MySvddV/nX339itwziasDOFD3t470SN/JVZWd/uQfY7X+D4MvJQsiXFd4j2KGLMBp/uosBRJOdsdcF52sbDVXSP8C80wfzVR8EZOCTAD+T5NLVBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=nOXVBQNvR2bxU3j8nNpwlLJabUSvwt5u409isBx1MrzcLi53isxvPb5dm0dPtG4s6eZM9BUWDUEzekUP3d9znSh+Ztp5SuEXBdRQy5XrbuSHbf+L4i8Pt54hPmOjn8MLdLmPSYMNsM8bDYO1ORZ/Uf483JHVDq09inNhuVjiY1c=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:18 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 13/17] arm64: Update generic FDT interrupt desc
 generator for GICv5
Thread-Topic: [PATCH kvmtool v2 13/17] arm64: Update generic FDT interrupt
 desc generator for GICv5
Thread-Index: AQHchxW+uUFuPdFep0+r+tahi9Vhtw==
Date: Fri, 16 Jan 2026 18:27:18 +0000
Message-ID: <20260116182606.61856-14-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|DB1PEPF000509ED:EE_|DB9PR08MB10377:EE_
X-MS-Office365-Filtering-Correlation-Id: 5355f1f6-3c19-4322-9bac-08de552d0699
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?dI071tOlWQOYmorJKwIIGPphpcrn3oGtnG8gV0GZo6XOH6h2/f9btqpGD/?=
 =?iso-8859-1?Q?lzU+h4q/LCbXUNZvEK1d8+ksNYTsi5zxH782W5kDD/B0u+hO+Gp2fOT+Ks?=
 =?iso-8859-1?Q?ibOv7+h43rGf2qXSJyhLIUC9zTvdg9QT0RDtpOVfftu/KMG9AcoMvf+Lcu?=
 =?iso-8859-1?Q?PipZltNF4eRbAICv43h3BGNw7QsvxwYH3GhpRDeBTQ2/maUkFtJMnrva1Q?=
 =?iso-8859-1?Q?QagdBPno3GMHLjQG0c8DwoG6nW3lBymXN3EaEdqm8Uk2/CfpolwhuDGuZ+?=
 =?iso-8859-1?Q?z75cur7qAjhf3ZzABbYqlH5JeBqLD53Gk0x1nVQnOjRqn29+Va6WO/B7gV?=
 =?iso-8859-1?Q?sYb/y6OwL0O19JMcHqniJUSZ4HyfZ8aeRQzyFXGavUcJfkqnupQ8fSHHVI?=
 =?iso-8859-1?Q?D7qkCOVyuA937wH3sC6zXoDZDFooBLrcUuVWkdRJ9xSMBk0s1YPL58ZKcB?=
 =?iso-8859-1?Q?CCRro/hgfZAimbZoF7Alh8zyf5mJW6HPYlbclUcXcNFra91yDGpy8dbYOn?=
 =?iso-8859-1?Q?xXuds4FiIH4hVzddNRcEaiKp5ngi+XxMi1Efk+OvFFUs10tijXvxykp3oN?=
 =?iso-8859-1?Q?RiONEKQAH3YDVTNwHbHivLS46rZIQmHbXgPfie8nDirgGbSv+32EJA3M0w?=
 =?iso-8859-1?Q?1wZqCWYbF68PFVU1t+coVi/FRxlVVl/qY40ZZPbcyGreDhDApl/bbEvLjJ?=
 =?iso-8859-1?Q?bKZRBl7EU7f42efpbFoFDNvBcp1x9D4Yomln37H/GUqb8gYnKcU+drPYYH?=
 =?iso-8859-1?Q?oKYYGkYyDqH8OpOKg1c+F5reXpIaYyhtbYb8v4soH/ibnaMb7jvs84beUn?=
 =?iso-8859-1?Q?eBAxCl4wx/5cgRvjsbPE/IEUBWM2rn5pvqm9ypqXryLO14tbm5L/47RiKL?=
 =?iso-8859-1?Q?j/U8PqA6KCQEMOBpf38P4zZdw9Ji4CylUhRZSSJT5n9zxfHNqmwUZpkYui?=
 =?iso-8859-1?Q?rfulp+EjY62MPXJVJXGooADaXzkB0dWP/g2h7aWnsnfPsNRq+L9GE2BT6z?=
 =?iso-8859-1?Q?2wFSA+UJz78mt0wGlfHt4RkkeBdj+NAaUjJ6xeR9LhL7GqLfqZws7CnXt5?=
 =?iso-8859-1?Q?kNPpt6Qvj4W/RB3xlbfd+8lSynFgiYg/flnfFmV+aaUXlbDyJZ7rrH5fmt?=
 =?iso-8859-1?Q?vf0l0HOPOoEbHAKi/ZxDpFApPE6jqvr/2vmfTISWmaLS5yf4N/1/1s76hB?=
 =?iso-8859-1?Q?ASbwuhce01EFlkXjyAOs8zqVhUT0NN2LuVZE0zREXW1UIXmP4qeBHzuGzj?=
 =?iso-8859-1?Q?kUyRXFrWNV3Pi+NC0b7/NKvg+a6J4dqDb5Ggai1Lc/JYy7b15VU7MUvweZ?=
 =?iso-8859-1?Q?gaa/l92R0+yoPuazOsukKD92PMwtVb42jh/qOoJy2uypgSAXcZrZKpMLpc?=
 =?iso-8859-1?Q?8UiUeYlaPuh1sOocNmUvVGhgSHxqh8OAeBs+NLui+HxA5gk8tOp6MMWMDK?=
 =?iso-8859-1?Q?vVdA5K9NN62eOGet+T6rAEvRUXGZq8NZioUTzOOpKGyXzRcFbaY5K3XXeB?=
 =?iso-8859-1?Q?ge7FRxrR+xXY8pR4FYejJ86bX640FeaJdQw6IRVox5M8azhO3H0pxVR3D+?=
 =?iso-8859-1?Q?Juqss8jeO8JauuvB5Zr3qDq/X+fqoyEWhOsKE52gDqZA9u8khcGJubDF5z?=
 =?iso-8859-1?Q?JOZxnaXDpu0xUSyAn02YzDj7NGrNeLUTIXcLj8wQS6rbeuEvKQ5nqP3Y27?=
 =?iso-8859-1?Q?eWOfwAm2GuAUJwgrwyc=3D?=
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
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	93a11b27-ca6e-4b68-592b-08de552ce17b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|36860700013|1800799024|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?FniRKQv31v3dARoyRm5PmOGdDMqgiJy7+X9Su0/dBrcXW8gVRVb7APwDpu?=
 =?iso-8859-1?Q?jYv8bi8efJznVVKRDHLNtySKeqYh1RVzrmMrLTghCl9IbJ276khSo0rATA?=
 =?iso-8859-1?Q?nxwppHE1C1ozVdFgDffml0S6QKU9J2f+edqZ037kFHFxeK/KfbwVSambfE?=
 =?iso-8859-1?Q?SZqNVSE473mWKKqRDiQw2rfNnKwjtmBQgZ5/6+9ig0vkVhFHsKAYe7w4rq?=
 =?iso-8859-1?Q?6svXoYyDELHDI9JJzc/cuN/MUkmQIrjekzZs67FrEH2g9b3AQsaBHKAtXw?=
 =?iso-8859-1?Q?qt2Yed4X4rg0k92SJpol1nx9/j8vmNJ3GYwuzc14WGA1xQ34N1VinpaHhz?=
 =?iso-8859-1?Q?27NBTflFtKE5dpMgN8JSD+gbrgwH/u1h89U2OnuxT1sEYXYdaNjVAzrjUM?=
 =?iso-8859-1?Q?GQwnQtIHH+wP1sa+TFH/onsxVbLIzomYomtKA11YT9orbfRKxaT1TI8jHe?=
 =?iso-8859-1?Q?MXR7WE1tkZV4HiLqk2bDEQbGkPVGRT4t5KJBr/7g69oofnQjC/bQgD1+X7?=
 =?iso-8859-1?Q?B/imNSfYR52Sj1OeyGQp7pXIQNq0LFInIuPIy6uRSKUXLY9NsQBONNJe+H?=
 =?iso-8859-1?Q?qKhCdeCNvFohxNq/bB19DMOwl8TBBxpZGckIofdCT6/iSmkL7AmUifusG+?=
 =?iso-8859-1?Q?mHH+bO3kMeqajbAZsJo4cpUItGlFElsH3lTMvnOwPeCpFQVd1ByehVBQhu?=
 =?iso-8859-1?Q?AbEMG+WsPl8s8vG0F8SA9d7wx3+q83SSGXqLQoVfPHInEFXKXI5pwqBkc0?=
 =?iso-8859-1?Q?KUL5LkddnNCmwGPkalyDrPi/BnIFfmsAs6GQzlMc0Dm/lEBr7jdcTJbdLd?=
 =?iso-8859-1?Q?WW6JTpsVlMnCZ/e8JpzoVwYWKjuT+5WuIyg+kBLyog3+5JKCjykoATlJNi?=
 =?iso-8859-1?Q?nQaoz5XuqRvi9q0N0mryJOdLmobPZlH839PszY/KexDLQdEH+fXx4c140t?=
 =?iso-8859-1?Q?tDcbXx3YqGdoYa8HgoavBkTsKvppH2SDW9gw3Q4Acp5MKsNGaqhZXRQhpA?=
 =?iso-8859-1?Q?RPfYyFgsP5HFrseoBlOjXg/wJE+1jJCQ6LYRj/6DiLiYqXNnp+S/mZsnTh?=
 =?iso-8859-1?Q?atPBfCHhNoGVM1e7KjsT11HDcyPztkhQ6tOckgHT677ZyXETfbgNCx6jjh?=
 =?iso-8859-1?Q?JDP0NySwh1rL4rxzSMs/9qcXPfBi5rhkRKP7hsW5KWU3OGPr1XUNw+zm+J?=
 =?iso-8859-1?Q?KOEgQanqCh+j9O5LgxjQIIb1mJ7x2rlM7u2feBMVipi1pdcP9mV82amb0P?=
 =?iso-8859-1?Q?DrfOLuy7KO9/i/lRFPwL2QbfO7MT68LcfAa7y/uy9E/dITQwHyfiPzenmI?=
 =?iso-8859-1?Q?GPl0+OIu0ngx/6dVZozS45o34ChCT/jeYaJ8YFA6qSeo8A6oGgQUWX0lS4?=
 =?iso-8859-1?Q?uLFF9NR2aKU7/yFeEpOxQPh5iKZYg5G3VS8V1tchSkDhC450AJ5uYR0rdr?=
 =?iso-8859-1?Q?kgSvFkhuZjGkMgH71U/+Zz6dqS7MAg/nW8+keFRQc47i9TDCWPoYCn3m0l?=
 =?iso-8859-1?Q?YMVaCTVZnOvtuRsmVtvtMAZ6SsBhi6vc5shtxRTZa9ZRfif2sg0QirGmEb?=
 =?iso-8859-1?Q?KQ505za1EoyMBuAzn494/dx/jG+ZCiVfzx1dmhy1Cy7NxOFd8S/vsvCT0E?=
 =?iso-8859-1?Q?TKNAaw/UA5xd6q64accpAM75ddLpsb66PgW1Qnc1HRqfNu43Rro/S3rE8z?=
 =?iso-8859-1?Q?5GEVDtZkrtog+AvMWZnRAvMK3U2bx1WKX7t9ipgzHsJd1u8oz0sNhUr594?=
 =?iso-8859-1?Q?9ENw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(36860700013)(1800799024)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:20.4813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5355f1f6-3c19-4322-9bac-08de552d0699
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB10377

Add support for generating SPI interupt defs that match either GICv5,
or legacy GICs. This checks if the GIC is v5 or not, and generates
either a GICv2/v3-compatible entry, or one that is
GICv5-compatible. This ensures that devices using this interface (RTC,
Virtio MMIO) don't need to be aware that a GICv5 irqchip is being
used, and are able to directly generate the correct FDT entries.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 44361e6b..07556dff 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -65,11 +65,20 @@ static void generate_cpu_nodes(void *fdt, struct kvm *k=
vm)
=20
 static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 {
-	u32 irq_prop[] =3D {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-		cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
-		cpu_to_fdt32(irq_type)
-	};
+	u32 irq_prop[3];
+	u32 type, offset;
+
+	if (gic__is_v5()) {
+		type =3D GICV5_FDT_IRQ_TYPE_SPI;
+		offset =3D 0;
+	} else {
+		type =3D GIC_FDT_IRQ_TYPE_SPI;
+		offset =3D -GIC_SPI_IRQ_BASE;
+	}
+
+	irq_prop[0] =3D cpu_to_fdt32(type);
+	irq_prop[1] =3D cpu_to_fdt32(irq + offset);
+	irq_prop[2] =3D cpu_to_fdt32(irq_type);
=20
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
 }
--=20
2.34.1

