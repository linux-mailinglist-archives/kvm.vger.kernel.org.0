Return-Path: <kvm+bounces-66351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D8E5CD0A61
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DCE530D128F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9613624CE;
	Fri, 19 Dec 2025 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LM6wdZna";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LM6wdZna"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013036.outbound.protection.outlook.com [52.101.83.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0B8361DCB
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159629; cv=fail; b=GOow1xLVA24bCaTdR8OnGFNgmyy9xGKAbUKVFytgeWWog0ErIoBy9JR6/RP7nPKYy/3etNCrPWFnfOL0x1ibsqIoBTziBU09tjrTs99hHjz+gCnNwvNpF/CUk7gHPTBgbEw8Nl1yWP4fEPTzHmm2WFiAzeqhrbgzAA36CcSwsbU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159629; c=relaxed/simple;
	bh=TrfjCAgSKuwBkoz7+YWx0JzERW+AjNTg6Opv8M2+670=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MhPy7L53NP/H3qQ0LoGt6qYEko3V3F+v2X9wIOKn9V19XdM5HhlGkJHoAhAxOL9GbfRy8dVcNFJjLd+QN1ns32LfgkqjLf4rr3Jzu/Dbvt9pi8XBcNmD6P8fu5mJ7ZxwFat4mHs49SfPtncVSNcghBDYdY+jMRoD2tcXe+ufG80=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LM6wdZna; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LM6wdZna; arc=fail smtp.client-ip=52.101.83.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QJEU0/iaUNOpr6W4MNwn4O9Fuk5Ze3TTio5ZLyjT3Ta0tNNAAHt+mcrOTN0KxeSsAR38AsfNFGOmX142EAo1aqqjykny1+CFb5OvZGtD4EiMUfk7m96FuMbu2wrpZpN1YfnnAv3qDaEXFN3TqrWVtROnLVFf1ERX2IDtJ/mYzvntIRzGqvPSFlL5IQU6mkHVd/9KdSiZ9f5r+sQ5mHOEwPPQXW0JjNI8jsv/W1rU622eiGVMxHJt3dIVrXOWxbjcdbNg8h6yRaY8kma13dG4V8npGdPzGouU/YET/9fLySFhWGw1LyRt2lyFJBeNA+eXMlFct01Z/juq4fdN4Uz5zg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=Z4B9fG2n0crNOSKO8mlAOe50f6US4qH27dpEzWU2b7INdBSM1AdzVc267ZPS5Y9nwbuXZCOoZMf2YEJgAQbGjAFxkU7RB6x+mpsBlr5UhWkrh+DJ2KII8WSGBbfuSmV3u7qgplZWMjbFAFG3dWdxRIV3td73z8GzDWUOhqud+k1Q0RLhJA4CFq1zNBnLSSw+OKVBYf7fgI+wmW5OA2T86tfcoGy8bYd9isaKV/vUsMILUl8XHhEUSMT7BvVuNtf4cY3V17ucLOmXdgcInHy9OisRFqxgtOl2qIAg0fuAgSoKbcf2KE0GphItJDbfMSKIt0KsttCYVfQxh2fDYaoSrg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=LM6wdZnaIm/QtMoZgsvSMArrSHBkLR0itKEpzZqZBASAwTPTj2KAkH13f9zV+VjHiYF12PauwnyknfN2pRa8kK8drGUzzFFJSrfGY6TLXJ08jTVGrv3BSu6Eb73kGJBUPSckCJPK0Ju2V9aujp3zIp1Bd7YndEmTw1GsFKHzIfk=
Received: from AS4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::7)
 by DU0PR08MB8399.eurprd08.prod.outlook.com (2603:10a6:10:405::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:42 +0000
Received: from AM2PEPF0001C70B.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::2f) by AS4P190CA0017.outlook.office365.com
 (2603:10a6:20b:5d0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70B.mail.protection.outlook.com (10.167.16.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNOlPg9pwQNmxTmMeRHzu7N+LUEQC4SMTHN7K0EKBGMg3N89hqIBVy2VQ0jXBkqdxItiwFBxGPyYJctLmDyV1ubM3umsjiocLteT5dRMh2Egs19WFNFnNQkLb9NT/y3YaZ4s+Ua/nZzAdpXLJ8eKFssy0/tuRmXWTE+HYkFi+k0Z7bdu4hbza8zg3i74SaAcL2YXDeQQFcVdeVwMlkVbCGUTrxTQgJKrJAqJ0B+ETf+5RVbTqlpx38M0Tvvm0PdgkYFI+30s64DSnqD/aXoEs3CRJAO9E+aj2CWR/km+lYnu+J38CaKSi0domopX+rf9pwHztSe7uKBnRvUlI3BvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=nd8BICLFccdPMO3xt2lKWUWVt6AqrYTF6aSEnASfhAb0LACCAdikhzBaeXJM7pS7aoBF9Mtw9o7V09Ch05oe4eIYtjbml0ezjvuwLbHs712HTSLOL3sQjVli5nc+cIPeG3DKJA/bMPZZiyrBgAPex6X7VB7CBA/qpoJ1t3t9KusYAOIKvekDQpZSnMbTjKVyoTK6HWWwQA6aYhcUKa3tV1/ZnunOmHZwjsRarnAkQBV2UCshmKKIiXCIgvNlJiPvpQY9ymFXtRvCT21XcmuBUdrrW5ToxvFnbciAJJmBj3x7iOLKsfXo4c/CX9KfCkkOo0SV+xVYcuuA5iJ57qPUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5RwkHpjSUZk7Rzm0ikgxUNBiO1kxEhXMjLxQoKi7X4=;
 b=LM6wdZnaIm/QtMoZgsvSMArrSHBkLR0itKEpzZqZBASAwTPTj2KAkH13f9zV+VjHiYF12PauwnyknfN2pRa8kK8drGUzzFFJSrfGY6TLXJ08jTVGrv3BSu6Eb73kGJBUPSckCJPK0Ju2V9aujp3zIp1Bd7YndEmTw1GsFKHzIfk=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
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
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 03/36] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and
 make RES1
Thread-Topic: [PATCH v2 03/36] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1
 and make RES1
Thread-Index: AQHccP9/0lHngM4qx0WM3cXpM0t+3g==
Date: Fri, 19 Dec 2025 15:52:36 +0000
Message-ID: <20251219155222.1383109-4-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|AM2PEPF0001C70B:EE_|DU0PR08MB8399:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0054f3-0b10-42d1-2893-08de3f16c877
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?O1pIt1VnvXTcgP5hQ0iB7cdLShaINyhspYt57/4vWGjJw/hBvrp2RV6ku9?=
 =?iso-8859-1?Q?7FYGZyXIm6tZ+JjGqgtK6CX4LgfviTU86ge8FIwKtZMmOfFl6My+B9yZfY?=
 =?iso-8859-1?Q?+xriNodLDJsUOltU2u/7h95kIC20QhjO74APkknRoFQsfBE0MXnto2Qt//?=
 =?iso-8859-1?Q?4dA+Q9g/oJocNjWsbnEdlk8q9mraiViM+IhTc45wrbxJd1UBXKx7JZyd2p?=
 =?iso-8859-1?Q?fiy8D+1vVu6Hyj9qnThj88eRxp7zft4BTVzfcfVgOpP94n3UiIRNzIrxKx?=
 =?iso-8859-1?Q?fVDhGIQdh8BsN67GdVuljaYOoVywOoeHeaUWDjTWrRVQGRPcx5PJ9eHsw8?=
 =?iso-8859-1?Q?lfDlylKqr3vmQXzEOEtEcv6EDcfsbVvM3HP3nL73jd8R1khStTuljLtGvl?=
 =?iso-8859-1?Q?pvw1JFrcenluvfTAd/WS15cW7IQwK0/uymPsTOXU0iH7FlExVbPS6hwwEF?=
 =?iso-8859-1?Q?CurklB2gBglXt0otrU8CrjOkFg149816jVqVn/rj0G9dYQke5oWTiRltwy?=
 =?iso-8859-1?Q?cQye+WbjHogvb32NGdYD4pTeWVDrkAgYyOgAn4mdsW4LHat01D/kmhWXG2?=
 =?iso-8859-1?Q?BhbVVBG0d68wFQtvBPF4NKQZV+73mX/Rk84M/yR9MGUAHGkzGCQSqaadMR?=
 =?iso-8859-1?Q?66sSOR/O/YtrKj+jVyTlxV3NTr36/ifDykGd/7mCY/teh7biXo1+NTMzQa?=
 =?iso-8859-1?Q?YHjXctBZIsYz1lf9mcdyul93nXR9t3246wrR4FCVnZoA/eiPz7dM9XSCQV?=
 =?iso-8859-1?Q?oX/wT7TJty8cyepNPV6+Mgra0buTJA0VbUzTxdtJloywlspsuK5XYv0FTP?=
 =?iso-8859-1?Q?f+hLivY+Go4wH7DJ6nlwwzzEMmiSJhgJ9/xnBd3oTXl6RMltnEmn5WWmfO?=
 =?iso-8859-1?Q?I/F0V6cjzGfQmUy4v3b0pB+0yMPFMhi+psBohJ3Ek1nIasKGLXc3mk23H1?=
 =?iso-8859-1?Q?AWJWYLxwGNQceaZZo9jw+BuCn9cjRHIxcaFa+2j5AaERC0j6JYgMQRwxQF?=
 =?iso-8859-1?Q?8LAGZkG3bmX1QVmPXviuzwAzonWqgvSB02V59KGzICUP58rVVvGsnRO0ZW?=
 =?iso-8859-1?Q?n1k81vCB2KTOAmyDInj828Z/0gvoZQ+VyrqPwijfmIzw8PixfforUgOvuz?=
 =?iso-8859-1?Q?bhIwOY4TE3VWyVTdWgeJ5u9IDpmbWGNBQYihYWV1uJYPzZcHWUNPyoh8HV?=
 =?iso-8859-1?Q?6kSaBKCb3VQTa6VrqzHWsPEpGZumhkYR9XDCRsanjVmA9m141Mj6QItPWk?=
 =?iso-8859-1?Q?j3+KDeYHYutNl64mdKzCAxEE6Bd16bNRpixcpKpyQ84f+eZQJmb7mx+YVn?=
 =?iso-8859-1?Q?PH/BKHd7gQ+DTECf/RcKM0Zoko/SBEqTjsuui+FXKZ3oRUyw+7Rb7WJWd0?=
 =?iso-8859-1?Q?Gm5bf78xL0KmAMWawf0o+pgfPVjIqrpGNr2FtU25w6EckraXgqEMUlOf5j?=
 =?iso-8859-1?Q?UrllZkYAdIdEzpKhkB+IsjR0Fg+3feHhAMmsoDK1tshhQG6U3wDJWmhxSz?=
 =?iso-8859-1?Q?FoRIpMsGJv+jZ7MYfolxhEIYNPQkjz/A0DWjzQemO03kOFf5f8SsEcmG+W?=
 =?iso-8859-1?Q?d65+9RXZaeU7lgHq1Z6vv2Uk+R7I?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70B.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bf90dfc8-53ea-40e2-1c60-08de3f16a242
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ysTpXO2k6BiCpMJhv4MHeZt4S60Yrh9ErzLXMDb1MO5jCyUejwuWdy0UQB?=
 =?iso-8859-1?Q?qbG/yCwSezdrez3YmFI9Xt+K05k+ON7NnSxG3VGYvHhYS0185BvXPmXHC0?=
 =?iso-8859-1?Q?uxxjyArZV+P4GlpPikWPPr2BYWoJ8/BTuBuBPvgGuantSbmZo8yDZsR8PU?=
 =?iso-8859-1?Q?TNbHK+G3pBMY9wRAGmqv2KOiCu4XzR47IB8K6d93M5V7yBoTEMvJ1W9gwT?=
 =?iso-8859-1?Q?xXQLyGFSoe1ltwBPi60CrPp/5PSuabE5FfvpsIN8sm6+1jtXgeKBSnhjSz?=
 =?iso-8859-1?Q?02MUzrG3d74o4inVK4ICgfBwgbeB3TgaX6jFYQmqAQaMaJ/xmfJ/d6KHJ5?=
 =?iso-8859-1?Q?PRtmqCbWy11cPwmFsOC8LJ1GA9kfEEdfW6IswL/l6XRc9/nwoHXPovyUsk?=
 =?iso-8859-1?Q?WdHelSlQCbMHRAzuwyZPIrBP/9JtvZB63KHKTwPo3/VDzgGeaGK3mB2hDb?=
 =?iso-8859-1?Q?IABQuGfA4UHyok8z8tZ9F0uFmESFi3lXshrh7doWrWDp5UGqFxsArpD8T/?=
 =?iso-8859-1?Q?0Nt5HVfyTXriNlIXKa4hT0lgDiFk/UFHNQnKfhiRzrcyhoTo98++QrZ4WH?=
 =?iso-8859-1?Q?qEcbq7F/f3rSU09wZTdlLPdbhNzDWlBz9NDbb/M01DX3iekRISd+l7ZBT0?=
 =?iso-8859-1?Q?92exK9RR9hINC2liny23O/QADRmjzGl2GVNsWqmCnXew0gTen4gXDVrHkn?=
 =?iso-8859-1?Q?ZYukQ8x/9VvngCo33Jx0fnXRTWQzLQmSC47q/etW2VLlXyMnrzFh3C5IMh?=
 =?iso-8859-1?Q?NBPICpfULG6rI/7GHBj1yFlPbuJhiX4gV1YIFoi/ZGm/xme85xLULUIGMs?=
 =?iso-8859-1?Q?yg7n6AzH+ft7B+FcOH5xSRyqViWjmaGxXMCh1YNtWlv8DVdY5/o9Tm5Nnv?=
 =?iso-8859-1?Q?Ydiz1uDFpTMpxGt1yHVF8IknPQ0QBTxfzxwMI4UE4EUB8oatVgX6UpTYyZ?=
 =?iso-8859-1?Q?3iHej5ykQGaZ8d6w6Gkl68xcI1FEk4nZGKRfp+J0dkVAHCdkxGMUuzk6O1?=
 =?iso-8859-1?Q?E7b+vtBJDrFaCuwTcedCarhLTqUBOnUBXy7m91wPuiRZRzWWpn2EdRXudC?=
 =?iso-8859-1?Q?gdVppJKtQlsk33M34qlixrHbRXQlbzNBSV1MpPZ9yBHV2CCpr8wAc4tXko?=
 =?iso-8859-1?Q?vB6CnqNW+XJsCt1vuVgqt6Ia3pCdMuCiIG3BP0DOOxqYUXoIjjUIAPmLXE?=
 =?iso-8859-1?Q?MVErHlKEjVUGxZVv5MkGOtf1LOs8o9XOEq5j2PZVPt3/mgSqM/pQQCU0V3?=
 =?iso-8859-1?Q?cGijwJnn8c1blvPpbEAZEUL5oup8qz8dHGpRav/Yz8ZzmtB0rUoTXJi/vw?=
 =?iso-8859-1?Q?U/YfXCGl27Hl+5+pUcmiWHSEPvjacHH4wYrFRV4vF2wladKzS0QLg1jukS?=
 =?iso-8859-1?Q?pVgVGL5yDHkq6awOVz5wQWoqD141kjb8cMkXVw5pJ38H/d8cmyVNFQx1IZ?=
 =?iso-8859-1?Q?WodtklrWzkJPz+nkXYsEDe3xXbkbYOLJbgkpXgY0/MXpNsRbZwdgT5lGln?=
 =?iso-8859-1?Q?3ZtPtPhbzv1FcEb0Kxio2sSwEbmtj4thcp7NcIfRen6EZ6mbNwH+nif/Rz?=
 =?iso-8859-1?Q?Pk0Bg9Zr1sZITzqBTHchrbqFsnKLE2jBligoWwZj46ZpkgWyMWhdLp6IPb?=
 =?iso-8859-1?Q?G8ZgFhoRiQv8k=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:41.7325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0054f3-0b10-42d1-2893-08de3f16c877
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70B.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8399

The GICv5 architecture is dropping the ICC_HAPR_EL1 and ICV_HAPR_EL1
system registers. These registers were never added to the sysregs, but
the traps for them were.

Drop the trap bit from the ICH_HFGRTR_EL2 and make it Res1 as per the
upcoming GICv5 spec change. Additionally, update the EL2 setup code to
not attempt to set that bit.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 1 -
 arch/arm64/tools/sysreg            | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index cacd20df1786e..07c12f4a69b41 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -225,7 +225,6 @@
 		     ICH_HFGRTR_EL2_ICC_ICSR_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_PCR_EL1			| \
 		     ICH_HFGRTR_EL2_ICC_HPPIR_EL1		| \
-		     ICH_HFGRTR_EL2_ICC_HAPR_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGRTR_EL2_ICC_IDRn_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_APR_EL1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8921b51866d64..dab5bfe8c9686 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4579,7 +4579,7 @@ Field	7	ICC_IAFFIDR_EL1
 Field	6	ICC_ICSR_EL1
 Field	5	ICC_PCR_EL1
 Field	4	ICC_HPPIR_EL1
-Field	3	ICC_HAPR_EL1
+Res1	3
 Field	2	ICC_CR0_EL1
 Field	1	ICC_IDRn_EL1
 Field	0	ICC_APR_EL1
--=20
2.34.1

