Return-Path: <kvm+bounces-68367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29243D38439
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A0FF305CA38
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C4C3A0B2C;
	Fri, 16 Jan 2026 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="akHw6SFS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="akHw6SFS"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011049.outbound.protection.outlook.com [52.101.70.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A385239C634
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588038; cv=fail; b=I4q9Auvs3d4lgYoUBci8NxBZdgDDU4gZAFcdSUMculwcSn45EDhHVTsTTUjPX8WZWXXxU1Ak73WUg3UIDv2Yvkv0sMCTZUBzjTROgjtE95nHhGqjhQvsgzjhSC/mFSyxQYBs4PBizHv2rfjTGnsMh5NbMPxyn1keNQlDoWs6tLI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588038; c=relaxed/simple;
	bh=XOfnU3mmwUtP2L2hjgfNQjfVwedp4musnatlp2Yplg0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bBL34060Q9zj/H4YF4hFuE4ArG/5vNa1e7ZyO5EE3KKdXq21E/sNNrIt3GMHyHEgjm6F7On+36t1qccrgXXJjWm9XaRYqa/9iqVkFXqwY9XQu1N1EECDyaB8UvWV55Uv6IQA5eHf7GhsONySiutf5ngwbMh1n6oQTTpJFRqCtW8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=akHw6SFS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=akHw6SFS; arc=fail smtp.client-ip=52.101.70.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WHwjODBisGvT652C2jEvr62AGi4i4xZOFrYI3M90bNtW8GkCn5mSzCGjJKW2uAWoi/LwRc+n0DSBqLLPCMcL8roE4b2Xi4xZ39wCtqvs+5FWW70HCffpyhX3d1VywLUmBVgVf8n524EdWVGBwGDdjIUfr50c4wXdY2ghdakUuIf8SKtgxW7jrdVb1+BfW8HV74xSuoyo3KopOvKh0/ZLaSSkxxif9h4GYJXpFqvFLiAl1NQuUviNxB6nRidcIpW3XBxtSMrYr+hwfaQrbqxKG+TGrw5aYzi15bxXQ+JnYZQx2H2pBMMb42FWY1YN4p8woEEfFnRfmFSVAHGGbFBqpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mc7lSdSoFQxO7ahG/FK23G9PXC6f7uXVo3y5cFwWd8=;
 b=DZ1izZZdjrZn/Y1+NTswkUo0O47MPO6j8XQuM0QYC2jf1dFAikv9ulXc+R3clA67wLzBa9/Lx4pN4WevVa5QeygfM6bRYh21qFzznGlJ+PijdpBvi+scaabHwM9vc/l7J0aUlSmoopSPz0ccEfIglIckjkOBW5ctzrf9gq9u9HjStJEjAIdUrxbET0Oi2wsPmT0lBeTfRL+0Kw0fygqXG0myx6NSY2Z04c1f7dOBoEsg8LgjX/DpkxJcD4HMGzidU9TmMvHvrTu9dEJKQskMk0a7sUZPRP1n/nKhHY/ye0c0hVhQ7DE+LHhKbTG1Vl4rtxWV9hE+5rp4SRHFlJjjMA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mc7lSdSoFQxO7ahG/FK23G9PXC6f7uXVo3y5cFwWd8=;
 b=akHw6SFSB/vUL3WZVcDPy3aHNK34j4A/RKJIvwMB+VPFHTFi/PUnJVFKfwmh4DDhR2DltsbaWpjXL2LNsyj9AqLb9gYMiufoihqPCndGq/7DqDgGTTRCgY/EdzZ9r1fRyZDGLdH/e2TNKZbBfNF16hz6rvkpE6NttcMZOT3YguQ=
Received: from DU2PR04CA0268.eurprd04.prod.outlook.com (2603:10a6:10:28e::33)
 by FRZPR08MB11024.eurprd08.prod.outlook.com (2603:10a6:d10:137::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 18:27:11 +0000
Received: from DB1PEPF00039233.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::66) by DU2PR04CA0268.outlook.office365.com
 (2603:10a6:10:28e::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Fri,
 16 Jan 2026 18:26:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039233.mail.protection.outlook.com (10.167.8.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:27:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O5c1LxPeM6LpX8hqY1HT1Sk4k/B/uoh/hhLhF9OnLZVSeMaWRrVCrID0lJatkwYQV876EDUuuOeNg/KHWaX5moDZS6Lv3yTqcabNEsB9rgOfZtFBvlPudZRUgxLJHU/MLuKBf/veYlM/dk9MNrYWwNdxEZ0VkJrrpvZaGkh/fY52IGB/kwqElhjV9mSQ46j/+QyWfDoJv30bvQLy8HWTxkqlnhuFyDBCUTi3MyByl3bfNDhd2XVTaFm+rsPZGiCXkBOrGidCqsxs/w7driuIaEHJOpk5+71Bj6YHB+iBubu8pboE8fggzN5Qyxo8CJdj6DlgFYMsZwg5Kig+c4CpTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mc7lSdSoFQxO7ahG/FK23G9PXC6f7uXVo3y5cFwWd8=;
 b=h9YQDx78IdKYYPa7OGVHo/pUHVLQgdVz5ufakteTgt0LyxCqiQx5kYWb/8fcLgQgiXUFwcH1fJCEydcDDGcW3E/2bQqeOWPCRsN6q0SXILePOTzTDzNTBpgSkTROOF734RCy3m/JhnCILQV3VwKhpL+UhZRE7xo7BOfeSzk8a789Dj+htTCcnlqMwFbVWkhq/VH2AGJMOVXXaqC/aVpSZObZXiIYHq0mjP16/X/FbJNt7qaL7/P3VFSefE0VGSdGc45A0SBhOjmRhCLamMQFIK3LGX7/MSZ3HRs6r0WBuHAm+dzy2gNPZxMBI/oEkzHJLCPndRO1FN5cLNQovjhhoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mc7lSdSoFQxO7ahG/FK23G9PXC6f7uXVo3y5cFwWd8=;
 b=akHw6SFSB/vUL3WZVcDPy3aHNK34j4A/RKJIvwMB+VPFHTFi/PUnJVFKfwmh4DDhR2DltsbaWpjXL2LNsyj9AqLb9gYMiufoihqPCndGq/7DqDgGTTRCgY/EdzZ9r1fRyZDGLdH/e2TNKZbBfNF16hz6rvkpE6NttcMZOT3YguQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:26:07 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:07 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
Thread-Topic: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
Thread-Index: AQHchxWUk08/e9r09kyClrbSyi16sg==
Date: Fri, 16 Jan 2026 18:26:06 +0000
Message-ID: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|DB1PEPF00039233:EE_|FRZPR08MB11024:EE_
X-MS-Office365-Filtering-Correlation-Id: c0109ffd-1feb-46f4-cbc0-08de552cdcf9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Bsl8jKCqcCKiOPS4IjlQNoMe9A2+ZnOX7oPsjYbqKqmbRKGRGsDL/dZTYd?=
 =?iso-8859-1?Q?gwZXSDrvriI5iiCwzegaPD88brGxsfwVrKQtwghu8uzfL+i30rCh5SKwvj?=
 =?iso-8859-1?Q?cKh1oZ8zDGCjV1wZ6PkUBlnUtLGPIBQBHD4geSsX+1eruLX6IBrfAUd6nz?=
 =?iso-8859-1?Q?sve7yHC706afz9bcW/Mpma++OAcvFKYA33lDgOZoNW1HZrukf1oWZ9VQlV?=
 =?iso-8859-1?Q?+GLJSDkwQTeLcniWYN0MeLbocQ/f5ZWTA64uY1jHBuwhaQPn0kwHHm1xVZ?=
 =?iso-8859-1?Q?HVEZvDo002e/tlJ8b5S2ccCz2gUqcxUk2PtzlDpXSIA2xA/kOLt6W/vsff?=
 =?iso-8859-1?Q?Gx9xJqkW/pK7itK+lg+GWvfEfzXyIoToBb9VWL2MYI4gVflNQ5kugyKiyg?=
 =?iso-8859-1?Q?lkVNJMOm39+GBd3IbAu0iXpNVKWZq/epE04Pc3eqfSq96AHLU67KysjOyg?=
 =?iso-8859-1?Q?vBot85HTLJw4MVucAxs5OZWXl3S5EfzlooQvNFC2CXqYJrOi/38kJ0iLaV?=
 =?iso-8859-1?Q?tk6uDhQHss2nf4vXsHHjE4w5AtcJmKB7eIqX/27NyRWm8TC8O2Tr64naQH?=
 =?iso-8859-1?Q?GEwxLMeF9Jhx0alVujlt7ed5yG2+fg3NPc5Cf8IPOHVdwQdfHE13El5oOq?=
 =?iso-8859-1?Q?Hr8hAYPh9wrvg4BbSDfrGG+OR4UIC8KMFQ+frIwOxXYssKlW8k/0kqE4QE?=
 =?iso-8859-1?Q?VNtuWzx6N/Hw6NS3EbM5iDO9M4/c3TiTAgjoIdAA2NyVqEIgM18KDz8I6R?=
 =?iso-8859-1?Q?349Qeu8rylJfU7p+nAPwlzH8i4NGd+uJV3q6HFDEn0KNV8ZMI27kI8RflE?=
 =?iso-8859-1?Q?fO24LLlAUtnZG7dI1Pjm5+HYS5dxmLjR6R/Dt5g8zxoODZ+a2smsScMynL?=
 =?iso-8859-1?Q?umzTpD4BlnLXvAIrlr7CYnnSsfsslsnMZlIUvjfmO24qcy4Prs1DeoqyCp?=
 =?iso-8859-1?Q?MlEwD4dBwT+DgR28BgY5NC8R1bFpGjMmg101K8AHFbupMUJabWLCkKoCKW?=
 =?iso-8859-1?Q?scUaAdogcqcpLYyF9VhxZXW/HPArKtjU1B4vKmMSuHWJBg93fIRj2VYOXS?=
 =?iso-8859-1?Q?kaOWSRQPwdhZym6d+1FwcfUr8hyJlzcmp3zTF4UKc8cKi06qVZijtgNMkm?=
 =?iso-8859-1?Q?W40iQkEvGTqyw0W7ll0Xh/QMScjfB6IjS9LvcSJ0xZaqdGg5Yguu9JG7aT?=
 =?iso-8859-1?Q?vGj88RrfBLWl+oDKbs2uhZTO6vlQf5Am1JmPTXURNK3FrW0s9BSnAtfwcd?=
 =?iso-8859-1?Q?ptFBgiq+ggayDsU16qBWTQUVUfzWhx2q6KbXak0lhy3sfLn1kch27GAfgE?=
 =?iso-8859-1?Q?3wsaZq09Tl4inhsu2t1DdTNOnH2QUh59sIUMG4Z58hbJPFclLz/LxmC7WQ?=
 =?iso-8859-1?Q?+IY/1ok8y63VLGc7GoGTUUApoUGdZ52j/5VEnXJCBCn0U2tZbRxo06KK3b?=
 =?iso-8859-1?Q?0Gfslh21pkqcrmXxIpbWqdPM4z03yW82aVQ7DmgnBVbbjLXR62Nz/jK6Ns?=
 =?iso-8859-1?Q?u1KCW2rUzaDuRvep5CS1TZfZD2R22vQjoXnY0P63Ex6R8Y+vtRxpNm5Dpo?=
 =?iso-8859-1?Q?+8+CRYeanXeoGYmpUnWM0oJW7EgwykRARmuEteb2rtB18rVnEfJXDRIsvd?=
 =?iso-8859-1?Q?KUUNkX7qArrY3eXfp3iIVV9upw9BIA+ZG4dkDhYKqWEPZgY3Bz148sJ8kH?=
 =?iso-8859-1?Q?GIAQTvjwhRV0P/PR18DdDXocaMgQKBPm1BriWDkg?=
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
 DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	375a95be-358b-4b8c-015c-08de552cb700
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|14060799003|82310400026|35042699022|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?2G8ceLvmrjftmFloOvQ8RWAKuPNnji73ewGB+OLYwiKERRaReuY0MYu9mm?=
 =?iso-8859-1?Q?MDok7AXvWVLeQV1FKrFr1AULOfPSpOuwyJalMc8vEgvW2WaVU2kPBkxgBR?=
 =?iso-8859-1?Q?EQKB6Z5cMmM/QslVO4l8wt70qTJF707N31wDK7sxkIcv3wwAtUffZecsKK?=
 =?iso-8859-1?Q?Qa+PPtKq8thMlVpmAgrUpMoevKySNQM/n/S5urUiEEOCqKj6igkh+Gb8f6?=
 =?iso-8859-1?Q?2DbIXI9y67VgbLxnOWeV1BNul6XTtSXpX7e+61ojG1zb1RosU8y8jtJU4T?=
 =?iso-8859-1?Q?1yrpd+eOR0kpj1/m5OXAAH1FxFZH06c5YfXkxu2yMK5WtXlzXf/zUoExvm?=
 =?iso-8859-1?Q?nGCBS9nylzF17sxOI2YN2/qtCrYoobtcO1089K5fcDvERV39xhoQ1LVxk8?=
 =?iso-8859-1?Q?H5nt3NszxCJJkBLrkxPTlT1xgyi+IJ47sZpIZBt3rkAstksTYSCnnjizsI?=
 =?iso-8859-1?Q?NgxXKanjcdX9rOFrLUkt4KP0Mt4j85RIolj2KXige4tjrfb3vVx+XZPtEg?=
 =?iso-8859-1?Q?zGU3Lki8JQARQgWuiN/g8hERvINT+MF12k8Z0bqKZYqrkD1Ql2pV38PlJx?=
 =?iso-8859-1?Q?KogntPZKIkxypZgz8Hr0lxB1cbZuHqJ/5gcyIXNQLLhhq8S73jIvOhWJb0?=
 =?iso-8859-1?Q?Y9boxaxf1LoUoEKkxLLPMzeKDmBJ+QFtOyQTC4s7ZmCfO7PIx0CDulaXXm?=
 =?iso-8859-1?Q?3ztYRLyrcafO3OiyoX7YEoFZEKEzh56BtgXeWhnHxJ8rN+/UF9SZ+AR9mu?=
 =?iso-8859-1?Q?z2JXp+slcvEZSq+DB///W2MMoEDwPUT98GydHqNEfQokJuQZUPPRejkyDh?=
 =?iso-8859-1?Q?Kw5A45tVr0FRGcntcBEedkkQ78foRefVBjI1G6a581JmingG6gg0kEE57H?=
 =?iso-8859-1?Q?ual8xwPm765O+F8HiP2v9aRG1gjF1YMxukq2dFTIl4NtA7+8nvzND42mAh?=
 =?iso-8859-1?Q?bUOUIatLBa/X7ZhZbmNQXIezId7bt8mPWqNfHdKoHWysxcnVXMoUyBnN6W?=
 =?iso-8859-1?Q?XTI5Q5M1rW9PZVgXMOmuUMRP0k8E11AE59UTfdjVsQN1QeKFG1sR7y5r5J?=
 =?iso-8859-1?Q?nz70rYYPvPidy+ZQvAhj+KB2C/G4R3fcVkBGDZ6pILqp1Q+qYo+o9Kb0cD?=
 =?iso-8859-1?Q?xp5MC1emegHXf8rLdthV4/nk+iv6B8AiCqWduAY1XuLDZ+SqnpsYZfnHLi?=
 =?iso-8859-1?Q?cRLR/qHfabaF2RN9Y8zCP2adoaqC6QCCY4Q4u9Jh+LD3p2SF+Bn3ZWXjWK?=
 =?iso-8859-1?Q?6Lt+f9IgKEStmLFKpJYw+W8KpU4oyUNzGCUQhLhYmFnIWBVKC3qL9W8v3/?=
 =?iso-8859-1?Q?EidRx+X3fmSajNL9nMYqKscDFs4nD7A+8b0WD9rTooVzoz+Qbu0IxqT8cL?=
 =?iso-8859-1?Q?EIeK0Jb9+OqaHOoe+9IujONDySgPErha2l2tDd7/XmnoqXYt4dmWIoGoiL?=
 =?iso-8859-1?Q?dyS5yx8AXxybJTAKY6n2eoH5y8YWcCGznMal6GkAW/DnlqjVUjZJwE2KRX?=
 =?iso-8859-1?Q?pZFYTlBDt79vvYhGadKyCzoYaKGmw4/BPJXPFhK9MlzGAdK2sPxhSMT1Mo?=
 =?iso-8859-1?Q?n9JNbpfDLEpfRSWNgu3uFzIrCmNh6XOvir+q5aJ0B4bONzgg2qHoZO7R5P?=
 =?iso-8859-1?Q?EU7bp/MWIvp03TvIikJZIlCu9KmWy4EyqmFOK7JpitbPtjnD9lyvZr8BdQ?=
 =?iso-8859-1?Q?wjSJRR0wEhSDPVB48s7lAj6HDhiR2+s/gGGua1Dq+Hylj/xkMpxbbVOw7y?=
 =?iso-8859-1?Q?VWFqmZCWgIdcK6UZe/g4skbco=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(14060799003)(82310400026)(35042699022)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:10.6467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0109ffd-1feb-46f4-cbc0-08de552cdcf9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11024

This series adds support for GICv5-based guests. The GICv5
specification can be found at [1]. There are under-reiew Linux KVM
patches at [2] which add support for PPIs, only. Future patch series
will add support for the GICv5 IRS and ITS, as well as SPIs and
LPIs. Marc has very kindly agreed to host the full *WIP* set of GICv5
KVM patches which can be found at [3].

v1 of this series can be found at [4].

This series is based on the Nested Virtualisation series at [5]. The
previous version of this series was accidentally based on an older
version - apologies!

As in v1, the GICv5 support for kvmtool has been staged such that the
initial changes just support PPIs (and go hand-in-hand with those
currently under review at [2]). As of "arm64: Update timer FDT for
GICv5" the support is sufficient to run small tests with the arch
timer or PMU.

Changes in v2:
* Used gic__is_v5() in more places to avoid explicit checks for gicv5
  & gicv5-its configs.
* Fixed gic__is_v5() addition leaking across changes.
* Cleaned up FDT generation a little.
* Actually based the series on [5] (Sorry!).

Thanks,
Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@ar=
m.com
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/l=
og/?h=3Dkvm-arm64/gicv5-full
[4] https://lore.kernel.org/all/20251219161240.1385034-1-sascha.bischoff@ar=
m.com/
[5] https://lore.kernel.org/all/20250924134511.4109935-1-andre.przywara@arm=
.com/

Sascha Bischoff (17):
  Sync kernel UAPI headers with v6.19-rc5 with WIP KVM GICv5 PPI support
  arm64: Add basic support for creating a VM with GICv5
  arm64: Simplify GICv5 type checks by adding gic__is_v5()
  arm64: Introduce GICv5 FDT IRQ types
  arm64: Generate GICv5 FDT node
  arm64: Update PMU IRQ and FDT code for GICv5
  arm64: Update timer FDT IRQsfor GICv5
  irq: Add interface to override default irq offset
  arm64: Add phandle for each CPU
  Sync kernel headers with v6.19-rc5 for GICv5 IRS and ITS support in
    KVM
  arm64: Add GICv5 IRS support
  arm64: Generate FDT node for GICv5's IRS
  arm64: Update generic FDT interrupt desc generator for GICv5
  arm64: Bump PCI FDT code for GICv5
  arm64: Introduce gicv5-its irqchip
  arm64: Add GICv5 ITS node to FDT
  arm64: Update PCI FDT generation for GICv5 ITS MSIs

 arm64/fdt.c                  |  22 ++++-
 arm64/gic.c                  | 179 ++++++++++++++++++++++++++++++++---
 arm64/include/asm/kvm.h      |  12 ++-
 arm64/include/kvm/fdt-arch.h |   2 +
 arm64/include/kvm/gic.h      |   9 ++
 arm64/include/kvm/kvm-arch.h |  30 ++++++
 arm64/pci.c                  |  16 +++-
 arm64/pmu.c                  |  23 +++--
 arm64/timer.c                |  20 +++-
 include/kvm/irq.h            |   1 +
 include/linux/kvm.h          |  20 ++++
 include/linux/virtio_ids.h   |   1 +
 include/linux/virtio_net.h   |  36 ++++++-
 include/linux/virtio_pci.h   |   2 +-
 irq.c                        |  16 +++-
 powerpc/include/asm/kvm.h    |  13 ---
 riscv/include/asm/kvm.h      |  27 +++++-
 x86/include/asm/kvm.h        |  35 +++++++
 18 files changed, 416 insertions(+), 48 deletions(-)

--=20
2.34.1

