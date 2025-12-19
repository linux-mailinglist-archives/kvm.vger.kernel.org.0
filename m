Return-Path: <kvm+bounces-66389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DCACD0EA5
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE6C23042AE9
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778D0382BD6;
	Fri, 19 Dec 2025 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m2fCPPVp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m2fCPPVp"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013000.outbound.protection.outlook.com [40.107.159.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9834137D112
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160849; cv=fail; b=Jb0vypDIPSLi6mIU1nSILc9C49PLWbSgT7GD5uJq6bGcEptiHLhFyBdCJyCrQTX/rrkyQVkzicDkcYyvAcon5PcpClIWxoRsk85BvgsR8f8yoBpQlzT/qcumrpVVkMR5eeqHDYYss+K4sB2fG5TiDgZKBLiiRaHB6Qh8Yz9Hjpw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160849; c=relaxed/simple;
	bh=Y5AWgV4WUIXORjP7gmDTHDXhWxLBHqk6Kj8gPTLNfIc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p/F2qO1UwHiey59MckqTucaHran/yLx+YZMv4tz1vZv7GPh2B9kCf+igpKX/rCBDqchmVGjcAQcTqGxKIDNe6wO4+AB+ACUqQv4m2E3vSy//t+qbpVmlcStP6NnH/hQ3E8gtrfQjmTM4wFDomJaCzd5CfOIi1uilTzlS0XuPxc4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m2fCPPVp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m2fCPPVp; arc=fail smtp.client-ip=40.107.159.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=E/nQgdQEujpZ+FjAn6sk4xAvnl3gUPCctUbWCNFiN7EK8IwwWnzLo+kEWxmQsJOPxieR6LVhD2AV3PbMplTmUn2lUAaM04azkVnFLa2ZcWq4mOK20J5r7o+Z8aWleEgdH82HF3tLecLW/HK6lkSWTy8CFrEKtBcf64Ttb1hhFaGR00dISinGO5RXxGzPinSnihstoDpAH9gO8pBRbL7Ris3naPPylOfta3LrtPSz22j4nIsEwMgE3iKf84k9riLqlUFMshSR7BBudIRe0D2MiOsiq/i+TkGGwcnNcHcFkSVHnmOl6fED+CIwjF99qMV0KoGz3sUHnJPds6bn3Pb01A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmxXlUM+s6of04PEW/4K3gEUpNuSawmfMbamGtth6/A=;
 b=X/MkkJz51YBqPLXcMGJMmm6BPxL2hWp2rtRsxEue1PNd/3zntEjISBIG/a/FetdQV/Lfo6TT2sFPfje26Yb2mOtWcQ10pAicGjcDIhcfrV/dg+37LDcD3tZT0YjkGj5A32lHDFADUxeH14bYqaL9fFchxr31Xf911PiG+nC7RDHSLeDm+mEpfiq9bzMBgvaqvuZnNASjFOsP1wOVYEmBXXRun49Z/ntfdL5kchbyB+0uxtWnUzMrCTb8jbN6Enb+e3Qr25zo1XFD6VwOsJPwt44egemQGGsubQdOLlRpMbRVeIS3hThCKg26B9OrhW1ikJMJ5LdztEvmM8zVso/Xrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmxXlUM+s6of04PEW/4K3gEUpNuSawmfMbamGtth6/A=;
 b=m2fCPPVpNSr5m63hPaEgOmkBsiL6NuGJUQFubVS6rBleY3EYr+bZz8SzDUcN2hEBGNJQezZRX9XeiX0iXq1oy2r62oLbqIWP6m6y/arrhKAlu59fqVN5mpxJubHY+3E/YauZOvQdU+NFCe0HVJFn3di4nJyDwMOGwQQvLeH6BMo=
Received: from AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34)
 by DB3PR08MB8940.eurprd08.prod.outlook.com (2603:10a6:10:431::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:59 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:20b:219:cafe::30) by AM8P190CA0029.outlook.office365.com
 (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:13:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stms7cSLFPeXFOji0zA+Iq2gH7OqXdKcguUPUbsSAW/o2xBnouNp0TOc7o5ltbEROmRtLDCmdK/WLn9h+xiyEPWSXZXlbxTgRH101k8rEv0VQlv4Zk1cyiXzusYzm4ZaFItrOo0qiG3dKgxzGTxQKYWi67IgjLjZ6adCROBfZ28uJ0z5B5MXHpITFnZazoWEVeJD1OrTHlT81s830M++utJfULBKam1klSqMtgbWbfKkvFb6XsYwBLquJvIBbLJ9BQtPQGLtW+++DlWxBHsgh8SAPi/4OyPuD6qGC9t5Q/hu6fEMqUoAm377MIWE21jaopI/NrjGvsMG4kLDsQWY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmxXlUM+s6of04PEW/4K3gEUpNuSawmfMbamGtth6/A=;
 b=HlgFt4mty3yx+8SOkCOopWDXW5L8YfJZQ3qcb/JHkcvs1PWr1NWUSyYU0QusnQg0seeCpbbOFMVYfwyn5emwlYakJ+cMGBqd7S49J28D6L3iIiNK7i6Im0N4ED/xPOcqpbaWOsWhXU2pxXqa8WuEsyAt+IKV6n+JgFqV4Ehq3L7EdPge8eq1idIx/N1MwMJkZ6TtPUT0y5QkrqZ3FxY3CqGxjT1/+OwtF82SKsySUTH3/a6x9o/2qtmYIa2aEiKClkgaLgYEk5K9ionYu9k9y7lMjBv9igb+HqjaugXo1SiVJT2iMinfwH0E1QKLEWpmmnieRqvT5c3QjVTS1J4TYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmxXlUM+s6of04PEW/4K3gEUpNuSawmfMbamGtth6/A=;
 b=m2fCPPVpNSr5m63hPaEgOmkBsiL6NuGJUQFubVS6rBleY3EYr+bZz8SzDUcN2hEBGNJQezZRX9XeiX0iXq1oy2r62oLbqIWP6m6y/arrhKAlu59fqVN5mpxJubHY+3E/YauZOvQdU+NFCe0HVJFn3di4nJyDwMOGwQQvLeH6BMo=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:56 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 04/17] arm64: Generate main GICv5 FDT node
Thread-Topic: [PATCH 04/17] arm64: Generate main GICv5 FDT node
Thread-Index: AQHccQJVYOfeBp6jEEePvLGfglWBQg==
Date: Fri, 19 Dec 2025 16:12:55 +0000
Message-ID: <20251219161240.1385034-5-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|AMS0EPF00000197:EE_|DB3PR08MB8940:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f93adf8-b570-4e55-14f1-08de3f199e15
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Oe3zMZ3mDA5pb9caY/hXj766cHH/fW3WoLC76ZHk+c1A7ystmvXOiAMDgH?=
 =?iso-8859-1?Q?4EZANBDe4Y/l5bX6FWqAP0VG5JhgYYYLcTVOIrjuq5JaQIDH8qGcXxgtt3?=
 =?iso-8859-1?Q?h6ELtb+BB3BE5CNdyhGMqffaEdOPA7wnDohr7NPJhFTlMOOvykhMHQtyQO?=
 =?iso-8859-1?Q?tjcNsn6dIhf0IRDw47USfnm835ZQIACSeRJ2KN5iUlFWZdCxrj8+sn90X3?=
 =?iso-8859-1?Q?51iM2mMqjAYGoSUqgFElpfdp6xWvm6QLmcItbk+gVSD3RYMM6vs0c9hYRh?=
 =?iso-8859-1?Q?5CDnw4084IYCuCENlSx8G2EmVdMn3YIk4zeZ+IeFrG9VI6EsiVMUzEOaSo?=
 =?iso-8859-1?Q?lTEYGJlkR7DKSHb09RoSXcd1sphr8x3vnic+LGFh23v+4Cr+ZEKYqfsDhY?=
 =?iso-8859-1?Q?e4L/O3cBqVo0MTfKXedNKQFT0xNe0ltFrwh6ZcuHDzhz9gbZGlsS2w0YEl?=
 =?iso-8859-1?Q?Lbk9kmDtVjycxtgwj+2AZoFOdDsaQ2gVR5YvcNLQk7eFD/LcoSzHM0pi6E?=
 =?iso-8859-1?Q?7fIdYAzWziCky23YjMhlFhAQL5K5feH0+VnaeubmskJSnOxBj54sF7+YVx?=
 =?iso-8859-1?Q?8MDBj77qN3btHIzjENULHieGputomBKcXnYCKNf/ivpACyrA9MdCLlVx/P?=
 =?iso-8859-1?Q?QFNVmBruDcRlP9mCd2F34hnLiG4/iiejuVE5X7Zj+Im7f4bxm+nXPwdrRM?=
 =?iso-8859-1?Q?VbzVUre7JysCzlb2PMyE412Jal+Jl3iHG/bWxKUnHkXhEC+WLn0fQu+gIw?=
 =?iso-8859-1?Q?1n9kRiutOdjZ4x2N9KAhUUrhwhE2UrBfRNpDuLdHt9Kfg4ICKaKO1332rS?=
 =?iso-8859-1?Q?Ir9C6wZoXQRWS8Fh/xVEOC9nKAmEAb/1lJDuu4mW7cAZ7VwfIYqmrWu0yR?=
 =?iso-8859-1?Q?+6FgAp6novWcdXRRBNL7BcLgxcTc3crWocN5q7YcVnEBFw+3vKuRs+5Rsy?=
 =?iso-8859-1?Q?9tuNZd1ZbdBXoB8vOfX+ncu5Y9/JVkJeoAiabmuyXk7+V9Ti4+kgxmDi5i?=
 =?iso-8859-1?Q?fM386AT8sLIEuQlNM+aM15qz2AzHjGFZF6Z88PHpwT3M59g8xYEmMrs4wR?=
 =?iso-8859-1?Q?3fgTaVX+AyvBniOAYfdOKlQjn9AOX+iX/cUV/OHjIBSXkru2q1cVNqk+Eq?=
 =?iso-8859-1?Q?ckRvDKMTcwpQhwaES8EJ3WMhFgQa1OpcnVhPjonSxxayeiIPOV1GSRpMGG?=
 =?iso-8859-1?Q?LySZEcgpivM3Vpf7MaVnFbG+VnSOkZldKdgkoHkDGlaI3QTy7pAfC6u5Uh?=
 =?iso-8859-1?Q?Jvsim7rEqlHqn8QsNFaCir7Fi/C3yCmDG/a49kyMZpscNFFPHliFL8BwF8?=
 =?iso-8859-1?Q?w5F0quTWD3cV8UFOcfOxccUArZ4IO4R058BZMzrcH+j013cIFpx5U8X8ar?=
 =?iso-8859-1?Q?vgPBo1bwkwcmGgstlBLYEnkG4Qk9gC/XMSWijGEaZ3VQ9i3IEOFI7BVKXx?=
 =?iso-8859-1?Q?jT2vsOV4riWDoI5zj5ASH5/aQWo3wbk0gE8oWVPyqwxWNWnSseFfmvDQCB?=
 =?iso-8859-1?Q?yNNzZ7VGhc8GpoxwG/iTsFoBg6sRUH6XHGSpf4dKWcV+65fKcPCPcAx0/U?=
 =?iso-8859-1?Q?1NO1h2peo4XAVg7FZ2IUoEROfJXr?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9362bcb8-dab4-4c75-22c5-08de3f197873
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?YFbGmBidraukOblPjbDSLafntYlVQrC8K6hwyxGp2hMe/H4T37Q8oOBH79?=
 =?iso-8859-1?Q?oL1JWlUA5pmKvcabuyitNHIyTHI0PjbVUZg8oqdnZFRyTEVTiDqrLJswYt?=
 =?iso-8859-1?Q?bQdZ2l2rh+c8HF7yce6fl2Gs7uJiRsJMNFUyLg9riWLZOSKtQXizW+nN60?=
 =?iso-8859-1?Q?/l3ugf57QZXEcY0WDeGUzR5KBXd+TuAsbe5XV8qpbbv7faCzpP/FyL2nSA?=
 =?iso-8859-1?Q?m5lzJ8eHSEPT8GxBiwr/QkJjr7I1uX/2E6YeOO6PHYQ5WgaSx3aO18z6vU?=
 =?iso-8859-1?Q?Eh8NDyAoI8k6ZHwm3keW9PWDsDg4quDnqW6EUVasGMvG6Vlc8e4OTfzFaR?=
 =?iso-8859-1?Q?03OiwldN6VBrCJj5zTBUBLzMVu9R9mlvZ/O5pLM5/f3XGK3EP7L42jcyRO?=
 =?iso-8859-1?Q?ZlQss/X09iyh1wSWH3LyOo4MZaBr7rjOxRVNvjfvw+Lzf95vCDz149VyZ2?=
 =?iso-8859-1?Q?Cg6MZf1zV2u6OVpwoZ9SpG/ShYLL9Lj+ibMe9XEAd8w267AoRyXDB2USgo?=
 =?iso-8859-1?Q?wTY8mbmOYolKbBrlQ/fmBNytrFq/M3Tnvk4pwSrBrbu78V20ry8hJ5ntXI?=
 =?iso-8859-1?Q?AvRvtFen378WycQosAZNDIIiSZE23qzcyUV0GOlUsxfyCNXX8RHwhvg+Gp?=
 =?iso-8859-1?Q?3XVzqIZu6574BpdGT9L67OZRAdnP/Y6P1+pX8QtGYoQGRj47HxskyCRUrD?=
 =?iso-8859-1?Q?vI9uegVZByzxZMiR5mmapow+3fDAelqJbxZ2Nb873GNS1eSsfZVSILLL7x?=
 =?iso-8859-1?Q?/alXTF7FTygEsSE/B65nxjueucnmf1LbMq/M8s5o6Zf8sFKqltoHO9x0Pl?=
 =?iso-8859-1?Q?a4XLC4fz7kXsl3UfNXMDZC3gnzbnTZkDkBrLr1x4pY/DmVD/WJ2r1YiuwD?=
 =?iso-8859-1?Q?ijlLsjMskSUip+PR1lHKU/NtPsAuR66nFL3gPKWt7GRbCnQV1wMStinBmt?=
 =?iso-8859-1?Q?mI8pqsGle9V6tRwgQHsGkWyd3p8rab3/KfekXBRKFobKbjy6tZwBVkWE08?=
 =?iso-8859-1?Q?I9dtaNjqsILF8f9ycXlgJtpOU4M62yDsW+DdKnNFTPVWnvQ1YIO6Labn0a?=
 =?iso-8859-1?Q?27pnDCI/87VIs5kckYB37qM9b49Mu9SQibaWf0ev/D/b0RPvOSjHZsItaR?=
 =?iso-8859-1?Q?tNjfHLqo8kL+9c5uG3ypxBAxoqWx7qNyRv9+/AXGJMPbA8k/weQwxK3gXp?=
 =?iso-8859-1?Q?zBO+Hh8BWnnhwO/uwlEh7skUBMGruPrJ4oQN/hrg9emzhEvB1XjMVrcEva?=
 =?iso-8859-1?Q?WerZCHbZica72OZHewI15rZEWPVhla1KMzA7KX9fNfVrKlPz9IsYbx4XIJ?=
 =?iso-8859-1?Q?xjFEtzWd0mSykchSxilfYLyKIaDebqnbAkAq8qYW35YfTz80GxV70O9hgI?=
 =?iso-8859-1?Q?YYvCGNzMbxOQpazr35G07cJUyiAZdph0EBjJ4kSR05Qv6kbcPEKfLgkVuW?=
 =?iso-8859-1?Q?xT2j/botUCjGqbRONmI82QNeCz7N9SGX0K8rBK7/bbHZ9+YECsxGbDCpMh?=
 =?iso-8859-1?Q?uQ6+xlzTVELwux5zxzR+PmEO+M0eBoyo6RgKIiX7JtSsEzbV9l6KrUWaZI?=
 =?iso-8859-1?Q?Za8JZ5mtyAhoLccv55Q2ymeMmwpwqOyi82RCqESGg4dp9xWwlhVJ8/tXFk?=
 =?iso-8859-1?Q?ilj9Nd4LnZEGU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:13:59.1176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f93adf8-b570-4e55-14f1-08de3f199e15
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8940

GICv5 requires a different set of FDT nodes to what was required for
GICv2/v3. Therefore, add in a GICv5-specific function to generate the
FDT nodes as this is much cleaner than trying to adapt the existing
code to generate both variants.

This change generates nodes for the GICv5 CPU interface only. This is
enough to support PPIs. Additional FDT changes are to follow as the
IRS and ITS support is added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/arm-cpu.c         |  3 ++-
 arm64/gic.c             | 25 ++++++++++++++++++++++++-
 arm64/include/kvm/gic.h |  3 ++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index abdd6324..f460bee7 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -13,7 +13,8 @@
 static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip,
-				kvm->cfg.arch.nested_virt);
+				kvm->cfg.arch.nested_virt,
+				kvm->nrcpus);
 	timer__generate_fdt_nodes(fdt, kvm);
 	pmu__generate_fdt_nodes(fdt, kvm);
 }
diff --git a/arm64/gic.c b/arm64/gic.c
index 8e4ff846..67b96734 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -368,7 +368,11 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
=20
-void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type, bool neste=
d)
+static void gic__generate_gicv5_fdt_nodes(void *fdt, enum irqchip_type typ=
e,
+					  bool nested, int nr_cpus);
+
+void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type, bool neste=
d,
+			     int nr_cpus)
 {
 	const char *compatible, *msi_compatible =3D NULL;
 	u64 msi_prop[2];
@@ -396,6 +400,8 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_ty=
pe type, bool nested)
 		reg_prop[2] =3D cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] =3D cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5:
+		return gic__generate_gicv5_fdt_nodes(fdt, type, nested, nr_cpus);
 	default:
 		return;
 	}
@@ -428,6 +434,23 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_t=
ype type, bool nested)
 	_FDT(fdt_end_node(fdt));
 }
=20
+static void gic__generate_gicv5_fdt_nodes(void *fdt, enum irqchip_type typ=
e,
+					  bool nested, int nr_cpus)
+{
+	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
+	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	/* Use a hard-coded phandle for the GIC to help wire things up */
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
+
+	_FDT(fdt_end_node(fdt)); // End of GIC node
+}
+
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 {
 	/* Only for GICv2 */
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index dd7729a2..13742bd5 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -43,7 +43,8 @@ struct kvm;
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
-void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type, bool neste=
d);
+void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type,
+			     bool nested, int nr_cpus);
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm);
=20
 int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
--=20
2.34.1

