Return-Path: <kvm+bounces-66397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CC6CD1179
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 44534300DB84
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA2A382D53;
	Fri, 19 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MaKhXiDt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MaKhXiDt"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010033.outbound.protection.outlook.com [52.101.84.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4F537D108
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160853; cv=fail; b=Pua2nGoKqqR9UFskXDxwBRwOzYIq+szWZlPFNB7KxB8LYCRaN6dRo/aEZtO/iYqM4pCIVphAdjCNnljtuY8JE2nV6D7Jkh/14O/MmjDUsf1WrV7cYXJCbNUBn9AYZZMWQerFy41l9GXnUY9ba2mbvU4erHrMSgxk0c6n5SpqwvM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160853; c=relaxed/simple;
	bh=eKhqqeUl7caxdXiqhP6U09VQLC4/sEoicehPgikzRjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ow+aRHqFKfPaQVg93tDijdBsGHdTiIz3XTFuwCQHK+LAlPMnS5J1XYvrfU6hk5cIehZqUo3kwev40j0pKkuO5GaKOptL+deEgLn+BBuzEx/WsU5T7gWk2qgEqsgYqebFf3VWrdSsBwm+rIZj74PQOeDf3jNmZPMsJocIScmVJgI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MaKhXiDt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MaKhXiDt; arc=fail smtp.client-ip=52.101.84.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UTetbrLGudyX1xqPeQz9n1cDbGp9wK2XO0Vgx5GGiveLTa5MzNtOuKcC/TRdqbKlXbQoJoa74gX/XzUC/V2lv+qBt///gE1t7u+qCNPn3D5jHWhgnsj86xXjHvWWw3x4c9MJXDaGBlMIwNg1o251hVH2Zlk6pIrHsDZp4tqm8tWtE58ksu/mP25f9BuxTDS4GoAsAp6G7/tGgjrVVO5McJ2i+nBgnxWSxuXxjGS68E8XK6TstiO3t0K/z54RfoSgUfGmAE9LLAI+0B4lrRcuCW6xQU2T0BWaNPCl58l4XhvLd/p0hj0rEMnu4ae1EzpEh+z5h0yE1if+FlIizmOTYA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TmvAwaVqbQls3h8j7Q/vkbPNq0TnI5h6BmULuoZAcI=;
 b=Y0Qh7QWEpbRhqEesVpJOT4Aaxq0ezs6BuuMQadtqO1Cvl8myP+ULKUxzGcW31xlGNv5BuP7mfqdm1xGSOGwBAk1tGqTyPM53t86IeNusIO/z8JilNUFXz2mSvR9vTJjRAuj23SjSuZo77hotlI3owLVd7MAz7l5Gxn4upgk6S1LjEF1PSHeR3uyUKwZKUTsBxh9U3IfGnzBE3azX2aSIxsuqzuFLRlkgZXidIN9Wf86yXWSm2p7jrqWnb9gdK27EekXfMMR6M8/g5+nYzYVd+d6QNcKi+Lye67316qthPoIjCWsjmUFp94cqdtnCkLYtCOEV9piNHlviaKk6gpLIZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TmvAwaVqbQls3h8j7Q/vkbPNq0TnI5h6BmULuoZAcI=;
 b=MaKhXiDtaKYzmCvU0ojrZkri2fMqcMjsxmSvgWVF9seoHQdwDqBO2Plgvs7rrBDmA6rdn/1SqlXD42QcKrOA/mFSaj17i2LYZGYLURaUgdd0OnCfIAxr86xjRegNWEYodvHt+wYl8EJDMpQ9NGP+K8ITzejUrsP9S4X6GQ6b0Jw=
Received: from DU2P251CA0023.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::35)
 by AM8PR08MB5697.eurprd08.prod.outlook.com (2603:10a6:20b:1d7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 16:14:05 +0000
Received: from DU6PEPF00009529.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::4d) by DU2P251CA0023.outlook.office365.com
 (2603:10a6:10:230::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009529.mail.protection.outlook.com (10.167.8.10) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via
 Frontend Transport; Fri, 19 Dec 2025 16:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BoOuB+tm7Thia2AlVL+QFF+CKvzJU2r0kHDQ8YGpVyIhHBYHb7nPlKtDKVnE2FXjxX02Ronl+XaKqB0cqYRz/2dIcz7AmjUTi2rc/G+JxysDBQmCZDQ8yKHrqFu2qKRhARtFZLBX7ujFzJSEZIk5RotBlJ1w7B0smLqz1NIXF0rOqallaeChgVq2/qDkZKekqNxo2rAQwekPTFv2XY4NyzYx175++oua4r9M1/jtln8fvZ4EJNnCdUALaOv6AK+Mf5I8TtUd7CMmPSvPdZE6tdeIgNOafBr8bKPM4ceMjX8r3mUjCz70xzIxYR33e4ZQ8JN/qyvDnjbHfuQyI/OoSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TmvAwaVqbQls3h8j7Q/vkbPNq0TnI5h6BmULuoZAcI=;
 b=vFZHcgf0jkuywoBvztVsbTAPNdgm4z+gSguHylBEofr7y1sw2tHYBqzbwnn+yES8UunHuRYRoKmNHQAkGY0ZJim3GQgN5DLH2WZSbtL/iv0BBAXyIklTjiuVyJCQD/kzFN19eN7oDMyiIK97a11FKUWc8V/lvbjibPcuDJilyxSyeLaBNb7luOtI9qJuZQ7DchpqL4Dq9FbiA+nFteXhrdI78Pfa2NMxO5wJCSp6+9hE3m7dEVadnAIBBbHSbRO4GdqX4NG9NBVRmQkHhhbgnxELJOKm1ASYiOyw9m/gGgGdsPSrGOJDx8NQWk12GK6kJIY2cJMl3EubNXbkRJrVHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TmvAwaVqbQls3h8j7Q/vkbPNq0TnI5h6BmULuoZAcI=;
 b=MaKhXiDtaKYzmCvU0ojrZkri2fMqcMjsxmSvgWVF9seoHQdwDqBO2Plgvs7rrBDmA6rdn/1SqlXD42QcKrOA/mFSaj17i2LYZGYLURaUgdd0OnCfIAxr86xjRegNWEYodvHt+wYl8EJDMpQ9NGP+K8ITzejUrsP9S4X6GQ6b0Jw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:01 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:13:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 15/17] arm64: Introduce gicv5-its irqchip
Thread-Topic: [PATCH 15/17] arm64: Introduce gicv5-its irqchip
Thread-Index: AQHccQJXssSXSeUKIkWUR6Lf0ktdCA==
Date: Fri, 19 Dec 2025 16:12:59 +0000
Message-ID: <20251219161240.1385034-16-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DU6PEPF00009529:EE_|AM8PR08MB5697:EE_
X-MS-Office365-Filtering-Correlation-Id: ec87917e-3548-4a09-862b-08de3f19a127
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?2agRBxuDzxk+q+k3lg08v2/sgJQOzs+sn0DQpesPUd6jjNwti614Y8ScYy?=
 =?iso-8859-1?Q?jSmkLCKpUCM6Ig393vTIsQDcNBn+7Q8vb0BvHGNCA1rGD3rg321QWt2aou?=
 =?iso-8859-1?Q?zsIpVD8UsN0AOSJsJof1xku36cG7ijs/cQ/GO87mUUwaPzna/LFcZHl3M7?=
 =?iso-8859-1?Q?ZgySXIfneeow9ba9ATZkTiAs3tXFQ+dV0cNnI1fAM/QX6vQ76RhftOLM+l?=
 =?iso-8859-1?Q?as1VKHrQAM4oYcPthtfc/2JFB9FfcfQ4astqSZGj6/jVHBWNLaeV28+9h8?=
 =?iso-8859-1?Q?mlnCmKLJVD+89H6ms20SEKJuHsZ/ZxUuebRJRH5eEuU0qK29s1xZn5f9wv?=
 =?iso-8859-1?Q?3H83rmvxOuKnh26BVZrQYx3htWToH+liYXvCIxc9A6YsRlggdrQmOPjghe?=
 =?iso-8859-1?Q?Zz18gbIpLAS9jrpvn+NXw5oPTelWq7mCw8vFDSOGFsu44ZJWr072R1bSKS?=
 =?iso-8859-1?Q?M9Uip+U5PpOXXONG+tdhfJt2B1pdacdaz/FSxv8IbHBoURLo1OcVtT/LPA?=
 =?iso-8859-1?Q?+JUz48t+EdNrORmwpM46d0dJV0ppLOV5W9Jct4m40mNMMs1HzMxxAaoOmb?=
 =?iso-8859-1?Q?cJs3z7Lapqkh+azu7TF8j7C+vKolaUZE6EUVK8KNiIgBX7llAQ6amzLdA1?=
 =?iso-8859-1?Q?dxO30pbJOy/WqpANphC5RnW1o2Sb84wnnQ5EAiAsEEXV/Jeyw6yrYOuG5l?=
 =?iso-8859-1?Q?ZqcbyxaeOKL5haHWm/IzncjNe4vrdZJuWZuJrrB5A6RFOpo5nOmIYF3i8G?=
 =?iso-8859-1?Q?0Mo0Cvirk2HmKZkeLNFiw3jq4A0dTIwIZTlO9LTxaeMjhkUE3o02WJAAhL?=
 =?iso-8859-1?Q?Al933863sUtNA4NQ5doVXVpYCGO0q29C7z/y4fr5ZyhVtzksDS7xddg6vu?=
 =?iso-8859-1?Q?RjtzjYZUvotn5d5cm4UXCcysoGG23JDyteks6jE4HYZBN1It7gSRFcONd/?=
 =?iso-8859-1?Q?lC5ArCZI/ahFzE9bbmModwThpq03sflSdTTwWcJq1Z0pP9jxJNDYT42odb?=
 =?iso-8859-1?Q?2uln5MhjCukFT3v06rvbBnr1Qb2ZfnK07lJK0zoRqfyY29PVb3NjC/t7LU?=
 =?iso-8859-1?Q?gheJlGMYJ9mDEVvVcQkKoFPTgCaSwZXwD0xeHFgenKXov+axFCVd+v82eV?=
 =?iso-8859-1?Q?Ukixoy8HRyJlIN4w3QiQTd4R6RRLImaqM1wUUa9A/aFbJ3PR7m60CZm7tb?=
 =?iso-8859-1?Q?tqOll6v7g3qmjFBqQ2NsX0VM1/JdbbMs4gX5NyEJ41Fv1dzcAkjFK2PwNA?=
 =?iso-8859-1?Q?nO/iMGr8NQB2KrNfdUc2ifzEHRzAWz6s1CuCu9xwXpX8RMIbNnctKNgqAM?=
 =?iso-8859-1?Q?pEvQdCT7iCybaCL5rHuFnnw6Bos/STtGiEnArGQSEF3v9Bb81f97nMtPLG?=
 =?iso-8859-1?Q?LNXAGbh29++EWCYZsf/IONOzTZTNYqMeKGNSU7yQsvTdnKp1bKpNm1efH7?=
 =?iso-8859-1?Q?TYgzslrIk4IDPYk7fN9edIy/R5R2g8hizdaP00k1zgELHrtJ/El954FKo6?=
 =?iso-8859-1?Q?NScLNrCQkIiJdX57dQDuxSyQ1XGuZvglWw19pEbKfv0krg9+pn7aTCxbwX?=
 =?iso-8859-1?Q?rpL0uCsbbtdhOnA+U95q3Au6MmCF?=
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
 DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7c59bc13-c1a1-42fb-fd15-08de3f197b9a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|14060799003|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?wXQK0I4Jvms0KH3FS/es/jipD3hTMB1PT6/fzAHl50Cqsnbp413j9qGlsU?=
 =?iso-8859-1?Q?ykoKHK5oyDXkQL4ZDk/0ai+Y6sLLi5m2rLWlOIbT1iRVdkVTYIQSEO82Ox?=
 =?iso-8859-1?Q?/RHZuON7TdpTY4CflzDs1vJsc+ZkKBiEMQOPV0vZrk/T7A1o9sNIMBa3ZX?=
 =?iso-8859-1?Q?/BVA+B9+QA8nCb8ZbYsx1HjK4tp5/ttROA2tFuJrncIFkFSddX6aYfEKRW?=
 =?iso-8859-1?Q?JO+3h9Y7YLh2fNYjG5Xb3WS+5t/ryBBowquoqSUs9wytv4SMndGtkeWoXj?=
 =?iso-8859-1?Q?NYAdyarQmkoeWTI+iLAQIfToPY59+4+YnD0EkouXHVSoiTOIzU7HQSA6vK?=
 =?iso-8859-1?Q?I494BO0X/ppDxDgxjY1B3KooyBA7IE9qLaa9o8ulx8OrRP83yrAwj9kXt0?=
 =?iso-8859-1?Q?Y0CYwgmNG26MmluOIg7Sh1zTOCZl8+bzrYUkahtefCLImkfTcQ8MnKpmGd?=
 =?iso-8859-1?Q?Iv0wVQ86gfWmABTg97CXhcnXZvz5wIGeXjrgJF7LGT/NW2ELK7UJtNV0fr?=
 =?iso-8859-1?Q?CSd4LdlVGDlWrnc89WnHHBTqqOa206BPwYw2+HNH/FPea7efpp+s3TOHkV?=
 =?iso-8859-1?Q?pjw4JPZpBzHAkFxxUval8lShrMQ+KfmEqi4Wpt9hZFdg0f9I848GxtDKLs?=
 =?iso-8859-1?Q?nk7HFSy6s54A7U5AQ2YCZUlG18G1mUak3SOItHceW+ifDQt4wVReJrT/+j?=
 =?iso-8859-1?Q?JFd6APeVG5MlP/20NeNEWn0lUUNu4fWG4sJgxroUKx0scinn04LjUKknI1?=
 =?iso-8859-1?Q?p1bCxNCs7BS6PQdYqJloaquh0qMPaN06htDF0helN68X2YuOx/t8ueXHoS?=
 =?iso-8859-1?Q?Msf5YfjWcEzeS748l3bjPcqgwc2FOP/KALw26/dNz2ZxHSASPnw4YbHKHi?=
 =?iso-8859-1?Q?P3PupBulc5bGaVnQ5x1xc+8YLeSdA9+NutxgNvGrYuf4pMI5k0tWP8Bh+u?=
 =?iso-8859-1?Q?g0zokexMdkpgs1QQwAxzzIJc5dhVlzATZ8SPwJ/1ZK6NW/w+tE3uvQwukp?=
 =?iso-8859-1?Q?haGE9lDbxkvfXFPrOgKT1LGZkcZInhBJXfKD+VWrIgWxyrVCXRIv4yBOG2?=
 =?iso-8859-1?Q?nzBF3s260KWkm7BiQ8VcCnrIWbJbvfxl/zX/CCKgQbrCwuiSN/zsOp2tDn?=
 =?iso-8859-1?Q?DmvTYGFS4KNcYV7WjhBpWdEaDvmt28+SraaSD4gHIUi8JFCSzSrvvcV9IE?=
 =?iso-8859-1?Q?O3gad6rMHIalKahxoFupnIV1LxSBjJJpXPt+JIN76nhsvkN6NoAgDPzwjt?=
 =?iso-8859-1?Q?rWz9XttbHqse2Cb3Ee/LVfb0FBhZdEjif4FmjHfPc8o3h4F7/o072Vbdma?=
 =?iso-8859-1?Q?EViS+aL55uLi+tfaEB8BQqnToH8HyXGre2O7qFYVF8quzOA1TSB2xjji+0?=
 =?iso-8859-1?Q?Y2Vc2KCumpoa8dvggz+4qAqI+/MBFX+ILXm326YhwL9kOMOZY0R1IupdE6?=
 =?iso-8859-1?Q?kKL7tCmrVWDcDZ3UFo9wyEXNMQYkx7p4bg9Kk84/3+E6MSA+1pTV/wu0fC?=
 =?iso-8859-1?Q?eIpxeoWuV7T+63G9RvXmmi2/4BMsNVZS5ryO1rBZ0PkcdWrhAyf4ohSqva?=
 =?iso-8859-1?Q?yQrgumqoIBFmR1zs28u9cBPgaKMAUtinuDzlZW7EHGf71xpWUDsy/znJcG?=
 =?iso-8859-1?Q?q6JF0DbK0yN7M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(14060799003)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:04.2576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec87917e-3548-4a09-862b-08de3f19a127
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5697

Extend the GIC code to be able to generate a configuration with an ITS
(`gicv5-its`). With this change, the guest is able to support MSIs.

Note that the FDT changes to add the ITS node are made in a separate
commit.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 35 ++++++++++++++++++++++++-----------
 arm64/include/kvm/gic.h |  1 +
 arm64/pmu.c             |  3 ++-
 arm64/timer.c           |  3 ++-
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 2152abf6..45dd2dab 100644
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
 		break;
@@ -220,6 +226,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &gicv5_irs_attr);
 		break;
 	case IRQCHIP_AUTO:
@@ -229,7 +236,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		goto out_err;
=20
 	/* Only set the dist_attr for non-GICv5 */
-	if (type !=3D IRQCHIP_GICV5) {
+	if ((type !=3D IRQCHIP_GICV5) && (type !=3D IRQCHIP_GICV5_ITS)) {
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
 		if (err)
 			goto out_err;
@@ -244,7 +251,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
          * and not at the legacy offset of 32. This must happen before any
          * interrupts are allocated.
          */
-        if ((type =3D=3D IRQCHIP_GICV5)) {
+        if ((type =3D=3D IRQCHIP_GICV5) || (type =3D=3D IRQCHIP_GICV5_ITS)=
) {
 		err =3D irq__init_irq_offset(0);
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
 	u32 maint_irq =3D GIC_MAINT_IRQ + 16;			/* PPI */
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
index 805f4247..0ef3aaa3 100644
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
diff --git a/arm64/pmu.c b/arm64/pmu.c
index 1720cc00..42cf81d3 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -200,7 +200,8 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 	u32 irq_prop[3];
 	u32 cpu_mask =3D gic__get_fdt_irq_cpumask(kvm);
=20
-	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5) {
+	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5 ||
+	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5_ITS) {
 		irq_prop[0] =3D cpu_to_fdt32(GICV5_FDT_IRQ_TYPE_PPI);
 		irq_prop[1] =3D cpu_to_fdt32(irq);
 		/* For GICv5, encode the full intid by adding the type */
diff --git a/arm64/timer.c b/arm64/timer.c
index 0945510d..20a4a808 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -17,7 +17,8 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 	if (!kvm->cfg.arch.nested_virt)
 		nr--;
=20
-	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5) {
+	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5 ||
+	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5_ITS) {
 		type =3D GICV5_FDT_IRQ_TYPE_PPI;
 		offset =3D 16;
 	} else {
--=20
2.34.1

