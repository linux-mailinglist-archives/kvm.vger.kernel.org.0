Return-Path: <kvm+bounces-66363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AC648CD0BA7
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8ED823006C68
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1898A362138;
	Fri, 19 Dec 2025 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jJf8HeR6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jJf8HeR6"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011000.outbound.protection.outlook.com [52.101.70.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04542361DCE
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159638; cv=fail; b=Npzg7oS+l5xIMAKFzwvd5rPD79GlcT46xz3z/aiH1FKL1F7kYXo3LzxZ7KSGbXoshq9gJtaIY62MU+c7R1aQ0qjweYjtVpe9xprWcdFc84qGfpjWNZ9B7aMRhBZr7wMRH6x3xfEyvlGSY44eQEQ5P0heB3bCtOZHYpt9My+6zQo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159638; c=relaxed/simple;
	bh=zM98x5+lKt6sSkRRNG7vldGiramZXUbM+pEXz/zSfao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NT8B4vb48YgvqBNlGpk0RsbDqaBca5yobD3teYgvZhUdpzSxLz6ahPKPujBup3u+k/8X4gkeqNO1Z51MBGtTNXk5tp5xckkL1NeHiAEmCHuZpOqofgkq0nf2u93WbmwRJB6dSgMQE1lwRMcXCYmBIZMgaIDjd/ZJXe5XitswUSQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jJf8HeR6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jJf8HeR6; arc=fail smtp.client-ip=52.101.70.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KILnzd9sKnh7RxO9X4+qpVEAETrGwp6UQbXfcHpEbvJMNIs1T9FJnLQ9ZzExjW6ABGANVIYrDPK90+JxG9iRDPyVE9R/Mq0an2xlZi+6OYuJyNJqIonluGTiRVYYSRGQHe4NBfSbMs70VTlpNBfkcukoh4oeMKsnJoMWuQsiLtnZ7ms4ppBW9tg1ktuVPMQeE5pwHTknJY7wNWRIRwIHinHKuGs8hUJDkV/6usv6i+4f1DbO3dbdCyAamUUm9zOc2HBgrsAe32j7++ylF9bGHTEe64xBOqo2s9riulTRglwdGCrU9QNsjrOcQE4CvpJsHmJvQHJ9cO2A2wHfAG6NMw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=P3RaeqDDsoBuG0cUk4/AUioP39DSGIEMTmZudJb9zggXVS/UgkUMDILFEsV+ISXuRH4LLSDegTfwIGHp1f4GadEp+O1F5yRuweZg4PcZijnm8XGmJpj0Im+4VoqoIHNqgSbJm9PqyCJa14fd+bv+m6McODmbC0FrNieD5T15HaL45QZh/t4J4B6OERIff2sSxfgCcsMXVvDtUZfmxyJiT4FZ9tEBFFbXehcfVDvtdob34EYyT2bl/Bez/Kd5CvwmVGzQRWxB+ePNgDADNXu3lqXGVeHQg9Fz51XpeIdHzuGJUdIAg9qRr9kZ8/+EdYu7YgutOVahPLaf/Pn3yXWyyA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=jJf8HeR6LsO/0Qdh0CHFK9wJ0pSZg0yT+EbyOzjfoAmT4GOA4pXYRuXknP7bMj4lVrQpQ4PerZpzVHkOaTAvLDzsBW7Xc8FcpFoScnuJVBEOMoF+PUX77zB5li6qkoUWo8dADJwuFvoIp7KfB51ZwBrRZazeP608NXYa/yGRqPo=
Received: from AM0PR05CA0092.eurprd05.prod.outlook.com (2603:10a6:208:136::32)
 by DB5PR08MB9970.eurprd08.prod.outlook.com (2603:10a6:10:489::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:43 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:208:136:cafe::54) by AM0PR05CA0092.outlook.office365.com
 (2603:10a6:208:136::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Fri,
 19 Dec 2025 15:53:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CF/rSLo46CqINNjLmQQw53lxcy7rdTTYR5n8et3SDI8SbJFb/9anZn08jwcUtGeuk/7Prtk2ypqnTLUWI+OF1bPqh8Exw+UpHRTVk9S16kAM7NrRAweG5mQU/qk9+XJYqrci8ArqpsQzLNLOS6c2EIc6AcxPeET6FWFrtJI21YzAlfbMGffE8PjBb0wfRo0L7pmRvwTjtTgGmZXIbWWX+arDl0WIDTiHxmjUWOTRAOgFqdXw2PKWw7gIJOGwp5FoWcsagIqBqLzBQBGnMYcDOkygp09y7sJqEz+dmFDmfzEc94YoDILzwxmOk+SzxHA3gx701C4caaol0b1a3xCiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=c1wPTjPG0RjUG3UC4RTUStQIslNVKR+cmhyR3jdhLSm0gsn7EIqLShCZxJgdJkjpTgxCPK+CHM3nulbY788xKvtym6Wq2IEoF+iyTuBjXQCmAMSqVNznYLSGNYmrjdouX8+O/2PPRD3Mtku5M/01Zw9CMQsRsTsaMox5lw8cOuUe+N9dn3fEJ6fGOtGBGYumVaFoBdaGgdW1HHGg+4QA+YaED+CQyaJCLIMfH0dj5HGdbXt2Ah3OS58XNV7s3rM7jdysdF1MFyLopHambqgHXkoNCUuiMPR+a1Aeb+SHUV0kn0CgjEgvfkVNvhbG5bi+VQL5iR7Q9CmsfbGNXCNiaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=jJf8HeR6LsO/0Qdh0CHFK9wJ0pSZg0yT+EbyOzjfoAmT4GOA4pXYRuXknP7bMj4lVrQpQ4PerZpzVHkOaTAvLDzsBW7Xc8FcpFoScnuJVBEOMoF+PUX77zB5li6qkoUWo8dADJwuFvoIp7KfB51ZwBrRZazeP608NXYa/yGRqPo=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:38 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:38 +0000
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
Subject: [PATCH v2 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Topic: [PATCH v2 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Index: AQHccP9/t1RwmpIxKEKvH8ZY9flMKQ==
Date: Fri, 19 Dec 2025 15:52:37 +0000
Message-ID: <20251219155222.1383109-5-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|AM1PEPF000252DE:EE_|DB5PR08MB9970:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf4c458-3fe3-46e4-b6a3-08de3f16c89d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?QfgtHh2V/jGjTScQspKvfMC+arhCqDc1xzZkEQA/Pbodb/hB8ohHnbC5rY?=
 =?iso-8859-1?Q?YD6oFWI40C5lB/wNqwiGB2UKUUlQyOwicnHc6kgHtmcqLRAMgoaO+l34zo?=
 =?iso-8859-1?Q?A0C8TvDCxQRQ3YlYD0A7Z7IZsm11xCrBhwGhT6WCo94nab6x2i6CYDLk83?=
 =?iso-8859-1?Q?pp1dVgV0GZZ24clvI3EtHkGr4XMZm5a31QtCTKIDdessCA25z7lUvz5eQd?=
 =?iso-8859-1?Q?Ouaxuytuwd6BA/4e8iwjpMm4GXXHq3EOsZHFyn8D8v2ZGYpuw4WlKsKI+I?=
 =?iso-8859-1?Q?CjvObHOmwy+wLHbY2hConjkR6eUaSZBy6tCEiJoB9bKRkmONhLX6jfq1Oi?=
 =?iso-8859-1?Q?QFN8F4x2xpcErQItJdohv3YxpYRjXNLmDiok2fectMBk+Ae4/2us2aBBVY?=
 =?iso-8859-1?Q?jVRxw0bjWcEaEzof2WlzXRkg5BGAmq1QPA8Ibs1AV2nL5Q/5a+t3+5JR2E?=
 =?iso-8859-1?Q?qHMRCvLFtameSv+XHQMFdcKFVuGSnmLRS0X8BEPjBSr2WlH9jVawkZTzIK?=
 =?iso-8859-1?Q?NXqHMk5OnQbkupGFhKwQSH+1tUA6cPaMwb6vsGJORjW8jEq0dY17I8gz9P?=
 =?iso-8859-1?Q?5wZVzLv9GfWF5zZTdIl+fG3FL7CJ85m5KtJhP9Scseb6IHU5KxUPrKwZnP?=
 =?iso-8859-1?Q?glqS8AFW7OEAhW/MZNE+lnAkTfAzcBPv1+6iBPjm5LWkqT0oNtmTCybhHH?=
 =?iso-8859-1?Q?Ho9qpOgGp/yJPrJ100Ngjd9He85axLRqP60XE10gp9xUEAnq/vBURGYIc6?=
 =?iso-8859-1?Q?/3Ffw9xAEgSGBs96BJLaEI3fkjJotR/r22Z/2cGE2rIV4jphyHQYIzGCgT?=
 =?iso-8859-1?Q?6381i/0X77o7hhtGbnEQkt+vWJ3e2XbFImRR+5yq9p9eUFXNC6POUFh6Vm?=
 =?iso-8859-1?Q?poWJOklD0y+/jn/6uRvFfr3j29NB3XhJyw4Zn9Ts/f6x6AP/d0pfiulBtn?=
 =?iso-8859-1?Q?i1OOeFCQT/lkm9+mvgpyc07HoVqtvc1yl+ss/XythOifSyAxW3P3pZokDV?=
 =?iso-8859-1?Q?VImCswyOh+Hp82wyEJi6P3FxnMqQRoWM8PKEYfModZecFozzrGeIgkZZ6H?=
 =?iso-8859-1?Q?xbYkGorjJIExdH0DvUIBuFglK9JnSX5TUxhovmJSdv1a2YI2745FGCnArM?=
 =?iso-8859-1?Q?9CBnbOk6kYhUmLQeehqbknprwfvPStvsqDHjbiJunlAyMygINog5Qr3+fV?=
 =?iso-8859-1?Q?+hj/RJ334jU/9BWULtFb2I4ejN404zWo9F/qq9WqM56AvbdZ9EsbiR+Pib?=
 =?iso-8859-1?Q?bIObq/B4eG60+mkzuf6qQyswyh769OJ0jUjmNKMmgAgNI82zh+4ePl7E3S?=
 =?iso-8859-1?Q?AblKhCVKFvpJuG4goEkG1aTc5ZpiU0kYTEpxwRd229G+xtEnQMkFz8JNzx?=
 =?iso-8859-1?Q?0SunZYhoN0LveKi4lpRkPN3790HndfEwcmZNdA1OWcOlGXUhcNZbj+apL0?=
 =?iso-8859-1?Q?Q45hVMcX+A3LXtJc6FYTXCENZqhrLHjLTB+Mz1Zv0oR5evPilI2yIK7FyJ?=
 =?iso-8859-1?Q?4q8YBbTY1554J/4cMnxabFnru+99WqAIncM+7A8EPzZ8o5JDi2h+KQSIxx?=
 =?iso-8859-1?Q?p05P95/6EAhDND3YbVcNbLfl0Fqu?=
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
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	db9517d3-773f-4ca7-de67-08de3f16a27f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|376014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?LeB4t3LxIZBkzOmoXlfLArlL098sYM1GfI/K4i5AqwdYZqPXEX53FH6qGq?=
 =?iso-8859-1?Q?gLScR7REimRLVgYhMmjGm3XfYG0PyRw1aAcRYxCMuAnNvw18pP0qUgZVGv?=
 =?iso-8859-1?Q?WyvqWKZDf0oeGEsv6hW6ExEfwA8d7OVH1ODUh2D3wUlP0ZSQ2/YcBeKwD6?=
 =?iso-8859-1?Q?GjwAugok9JFu1WCxdzxOvNGV+AQzgAGXiOfxaqaa3siWF68vsNm7HNGX3s?=
 =?iso-8859-1?Q?E0jmT4qrRDedULvxz8/wpJdL4g3TUY28SsVkGEAAJedQskxyIIjD34LdIB?=
 =?iso-8859-1?Q?Y6k2Eu4ViHhv+xqa4hUNpQX/+lMsVpAGA2Q2CG+EcY2DHRafIUqnK2vGs7?=
 =?iso-8859-1?Q?l2DqAaAbygOaUVZImcGvSFue8vWp0boTMTa0+KpAGHZ4GtK57nG4qpn0GQ?=
 =?iso-8859-1?Q?KOKAZoOktVRP3MIgodJhNRnZiUgqGd46xuNB+HUD4xlYbHDvv/HsymlbzT?=
 =?iso-8859-1?Q?UMggogwpe1LfX7k8L6DFR9I0KR8cde/19sP05f7MZ3xxkn0664ZEnDip3I?=
 =?iso-8859-1?Q?ReVbrhRrM5Xl/rK8PwQ5taK9HLSn71AARD30LB+FEzdxvNMB5wkTtcMJ55?=
 =?iso-8859-1?Q?W9nwOy1FcqZOH31dE+O42aKWhu3Iiur7zAo+u0IDnatiEs9XOqVyjISQDA?=
 =?iso-8859-1?Q?W3YWz8X0g0/3Xrvas8ugqmbAIgTwfJFQhls6+h/ZbiT0S5140XSalhpUr0?=
 =?iso-8859-1?Q?7a7QUfON+V9WjynMcRof3B4LHsHXM7w40XztsTfE/snUEvfWMB3+fHQZ3l?=
 =?iso-8859-1?Q?6NtD814ij33wGa1i/EVBsTNSGy8u14kqBNMFVrfqOP9Vah95pyYbWPFoIg?=
 =?iso-8859-1?Q?p10wefBbMRpH+MZ9IFYFdtSDfn4c0lHfYZZGIRyJsxFWGryE6eRtHyjIVT?=
 =?iso-8859-1?Q?spEIht4HuzCq73KMb+ZM4KmDqHgaJq0X7SE4VtBS227yTd5RsNvafBxF5A?=
 =?iso-8859-1?Q?/0+MmfNp0FlEczQxNQtOGpnlV0EgeeYG/W75TMZF73ZZLxDLw6WfTvbvXh?=
 =?iso-8859-1?Q?DqqwFUNtM7mRXh/5YsfXfGJivPrnGNmoUhrwIDC/8zsKuLX0JdDS7/et1Z?=
 =?iso-8859-1?Q?5ccyV+2zkvuWyLD5a1bX9ht1C/8UW3yxv4bwGIK1tBFhDRnhRcw8lbVpIv?=
 =?iso-8859-1?Q?aNmUpmk+FxnzdwHeg3QQsGENNReRpfxyqpXpAOr9YKFHYwUOiV/iHicYWQ?=
 =?iso-8859-1?Q?38axw1UwnGxigTPP/5Tl6hiKXoAri6Rg//wzYcRlmXc7mPo3Lk2XyY9yyt?=
 =?iso-8859-1?Q?N76S4zK/yBYgyX4WDD89IPJWVVjMpopxc1UWWoPEVD779Qb0E3dYuWE0B/?=
 =?iso-8859-1?Q?1aeTQRFF5rUpasamXCmAR8Qi36UoPu3w4bMYWMDn2klaNegANioevBmsbJ?=
 =?iso-8859-1?Q?W5TqP6j02QijxKknKzrTxhVaBtcxYVmuv6BGDY3hkMPVNVh4fUSBzLchX4?=
 =?iso-8859-1?Q?necn+XMmdLxZRDxZ1WPYqZqCEvOugPqDPANIdg5I8sTgl0RaVXgXqO0Nsh?=
 =?iso-8859-1?Q?6rSiADXGtzXC+yaao4Gn6E7SWutlneibhdLu7HYKPWcD8k0SmdVWK+eiKf?=
 =?iso-8859-1?Q?rxrKoQsZ6AZMBWthRR0BvyAoLP7hWSvN+s52ZFt5N+8F6tJvlpIUwumsom?=
 =?iso-8859-1?Q?QAV7rLXM1Un8U=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(376014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:41.9698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf4c458-3fe3-46e4-b6a3-08de3f16c89d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB9970

Add the GICv5 system registers required to support native GICv5 guests
with KVM. Many of the GICv5 sysregs have already been added as part of
the host GICv5 driver, keeping this set relatively small. The
registers added in this change complete the set by adding those
required by KVM either directly (ICH_) or indirectly (FGTs for the
ICC_ sysregs).

The following system registers and their fields are added:

	ICC_APR_EL1
	ICC_HPPIR_EL1
	ICC_IAFFIDR_EL1
	ICH_APR_EL2
	ICH_CONTEXTR_EL2
	ICH_PPI_ACTIVER<n>_EL2
	ICH_PPI_DVI<n>_EL2
	ICH_PPI_ENABLER<n>_EL2
	ICH_PPI_PENDR<n>_EL2
	ICH_PPI_PRIORITYR<n>_EL2

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 480 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 480 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dab5bfe8c9686..2f44a568ebf4e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3248,6 +3248,14 @@ UnsignedEnum	3:0	ID_BITS
 EndEnum
 EndSysreg
=20
+Sysreg	ICC_HPPIR_EL1	3	0	12	10	3
+Res0	63:33
+Field	32	HPPIV
+Field	31:29	TYPE
+Res0	28:24
+Field	23:0	ID
+EndSysreg
+
 Sysreg	ICC_ICSR_EL1	3	0	12	10	4
 Res0	63:48
 Field	47:32	IAFFID
@@ -3262,6 +3270,11 @@ Field	1	Enabled
 Field	0	F
 EndSysreg
=20
+Sysreg	ICC_IAFFIDR_EL1	3	0	12	10	5
+Res0	63:16
+Field	15:0	IAFFID
+EndSysreg
+
 SysregFields	ICC_PPI_ENABLERx_EL1
 Field	63	EN63
 Field	62	EN62
@@ -3668,6 +3681,42 @@ Res0	14:12
 Field	11:0	AFFINITY
 EndSysreg
=20
+Sysreg	ICC_APR_EL1	3	1	12	0	0
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
@@ -4567,6 +4616,42 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
=20
+Sysreg	ICH_APR_EL2	3	4	12	8	4
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICH_HFGRTR_EL2	3	4	12	9	4
 Res0	63:21
 Field	20	ICC_PPI_ACTIVERn_EL1
@@ -4615,6 +4700,306 @@ Field	1	GICCDDIS
 Field	0	GICCDEN
 EndSysreg
=20
+SysregFields	ICH_PPI_DVIRx_EL2
+Field	63	DVI63
+Field	62	DVI62
+Field	61	DVI61
+Field	60	DVI60
+Field	59	DVI59
+Field	58	DVI58
+Field	57	DVI57
+Field	56	DVI56
+Field	55	DVI55
+Field	54	DVI54
+Field	53	DVI53
+Field	52	DVI52
+Field	51	DVI51
+Field	50	DVI50
+Field	49	DVI49
+Field	48	DVI48
+Field	47	DVI47
+Field	46	DVI46
+Field	45	DVI45
+Field	44	DVI44
+Field	43	DVI43
+Field	42	DVI42
+Field	41	DVI41
+Field	40	DVI40
+Field	39	DVI39
+Field	38	DVI38
+Field	37	DVI37
+Field	36	DVI36
+Field	35	DVI35
+Field	34	DVI34
+Field	33	DVI33
+Field	32	DVI32
+Field	31	DVI31
+Field	30	DVI30
+Field	29	DVI29
+Field	28	DVI28
+Field	27	DVI27
+Field	26	DVI26
+Field	25	DVI25
+Field	24	DVI24
+Field	23	DVI23
+Field	22	DVI22
+Field	21	DVI21
+Field	20	DVI20
+Field	19	DVI19
+Field	18	DVI18
+Field	17	DVI17
+Field	16	DVI16
+Field	15	DVI15
+Field	14	DVI14
+Field	13	DVI13
+Field	12	DVI12
+Field	11	DVI11
+Field	10	DVI10
+Field	9	DVI9
+Field	8	DVI8
+Field	7	DVI7
+Field	6	DVI6
+Field	5	DVI5
+Field	4	DVI4
+Field	3	DVI3
+Field	2	DVI2
+Field	1	DVI1
+Field	0	DVI0
+EndSysregFields
+
+Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ENABLERx_EL2
+Field	63	EN63
+Field	62	EN62
+Field	61	EN61
+Field	60	EN60
+Field	59	EN59
+Field	58	EN58
+Field	57	EN57
+Field	56	EN56
+Field	55	EN55
+Field	54	EN54
+Field	53	EN53
+Field	52	EN52
+Field	51	EN51
+Field	50	EN50
+Field	49	EN49
+Field	48	EN48
+Field	47	EN47
+Field	46	EN46
+Field	45	EN45
+Field	44	EN44
+Field	43	EN43
+Field	42	EN42
+Field	41	EN41
+Field	40	EN40
+Field	39	EN39
+Field	38	EN38
+Field	37	EN37
+Field	36	EN36
+Field	35	EN35
+Field	34	EN34
+Field	33	EN33
+Field	32	EN32
+Field	31	EN31
+Field	30	EN30
+Field	29	EN29
+Field	28	EN28
+Field	27	EN27
+Field	26	EN26
+Field	25	EN25
+Field	24	EN24
+Field	23	EN23
+Field	22	EN22
+Field	21	EN21
+Field	20	EN20
+Field	19	EN19
+Field	18	EN18
+Field	17	EN17
+Field	16	EN16
+Field	15	EN15
+Field	14	EN14
+Field	13	EN13
+Field	12	EN12
+Field	11	EN11
+Field	10	EN10
+Field	9	EN9
+Field	8	EN8
+Field	7	EN7
+Field	6	EN6
+Field	5	EN5
+Field	4	EN4
+Field	3	EN3
+Field	2	EN2
+Field	1	EN1
+Field	0	EN0
+EndSysregFields
+
+Sysreg	ICH_PPI_ENABLER0_EL2	3	4	12	10	2
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ENABLER1_EL2	3	4	12	10	3
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_PENDRx_EL2
+Field	63	PEND63
+Field	62	PEND62
+Field	61	PEND61
+Field	60	PEND60
+Field	59	PEND59
+Field	58	PEND58
+Field	57	PEND57
+Field	56	PEND56
+Field	55	PEND55
+Field	54	PEND54
+Field	53	PEND53
+Field	52	PEND52
+Field	51	PEND51
+Field	50	PEND50
+Field	49	PEND49
+Field	48	PEND48
+Field	47	PEND47
+Field	46	PEND46
+Field	45	PEND45
+Field	44	PEND44
+Field	43	PEND43
+Field	42	PEND42
+Field	41	PEND41
+Field	40	PEND40
+Field	39	PEND39
+Field	38	PEND38
+Field	37	PEND37
+Field	36	PEND36
+Field	35	PEND35
+Field	34	PEND34
+Field	33	PEND33
+Field	32	PEND32
+Field	31	PEND31
+Field	30	PEND30
+Field	29	PEND29
+Field	28	PEND28
+Field	27	PEND27
+Field	26	PEND26
+Field	25	PEND25
+Field	24	PEND24
+Field	23	PEND23
+Field	22	PEND22
+Field	21	PEND21
+Field	20	PEND20
+Field	19	PEND19
+Field	18	PEND18
+Field	17	PEND17
+Field	16	PEND16
+Field	15	PEND15
+Field	14	PEND14
+Field	13	PEND13
+Field	12	PEND12
+Field	11	PEND11
+Field	10	PEND10
+Field	9	PEND9
+Field	8	PEND8
+Field	7	PEND7
+Field	6	PEND6
+Field	5	PEND5
+Field	4	PEND4
+Field	3	PEND3
+Field	2	PEND2
+Field	1	PEND1
+Field	0	PEND0
+EndSysregFields
+
+Sysreg	ICH_PPI_PENDR0_EL2	3	4	12	10	4
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PENDR1_EL2	3	4	12	10	5
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ACTIVERx_EL2
+Field	63	ACTIVE63
+Field	62	ACTIVE62
+Field	61	ACTIVE61
+Field	60	ACTIVE60
+Field	59	ACTIVE59
+Field	58	ACTIVE58
+Field	57	ACTIVE57
+Field	56	ACTIVE56
+Field	55	ACTIVE55
+Field	54	ACTIVE54
+Field	53	ACTIVE53
+Field	52	ACTIVE52
+Field	51	ACTIVE51
+Field	50	ACTIVE50
+Field	49	ACTIVE49
+Field	48	ACTIVE48
+Field	47	ACTIVE47
+Field	46	ACTIVE46
+Field	45	ACTIVE45
+Field	44	ACTIVE44
+Field	43	ACTIVE43
+Field	42	ACTIVE42
+Field	41	ACTIVE41
+Field	40	ACTIVE40
+Field	39	ACTIVE39
+Field	38	ACTIVE38
+Field	37	ACTIVE37
+Field	36	ACTIVE36
+Field	35	ACTIVE35
+Field	34	ACTIVE34
+Field	33	ACTIVE33
+Field	32	ACTIVE32
+Field	31	ACTIVE31
+Field	30	ACTIVE30
+Field	29	ACTIVE29
+Field	28	ACTIVE28
+Field	27	ACTIVE27
+Field	26	ACTIVE26
+Field	25	ACTIVE25
+Field	24	ACTIVE24
+Field	23	ACTIVE23
+Field	22	ACTIVE22
+Field	21	ACTIVE21
+Field	20	ACTIVE20
+Field	19	ACTIVE19
+Field	18	ACTIVE18
+Field	17	ACTIVE17
+Field	16	ACTIVE16
+Field	15	ACTIVE15
+Field	14	ACTIVE14
+Field	13	ACTIVE13
+Field	12	ACTIVE12
+Field	11	ACTIVE11
+Field	10	ACTIVE10
+Field	9	ACTIVE9
+Field	8	ACTIVE8
+Field	7	ACTIVE7
+Field	6	ACTIVE6
+Field	5	ACTIVE5
+Field	4	ACTIVE4
+Field	3	ACTIVE3
+Field	2	ACTIVE2
+Field	1	ACTIVE1
+Field	0	ACTIVE0
+EndSysregFields
+
+Sysreg	ICH_PPI_ACTIVER0_EL2	3	4	12	10	6
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ACTIVER1_EL2	3	4	12	10	7
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
 Sysreg	ICH_HCR_EL2	3	4	12	11	0
 Res0	63:32
 Field	31:27	EOIcount
@@ -4669,6 +5054,18 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_CONTEXTR_EL2	3	4	12	11	6
+Field	63	V
+Field	62	F
+Field	61	IRICHPPIDIS
+Field	60	DB
+Field	59:55	DBPM
+Res0	54:48
+Field	47:32	VPE
+Res0	31:16
+Field	15:0	VM
+EndSysreg
+
 Sysreg	ICH_VMCR_EL2	3	4	12	11	7
 Prefix	FEAT_GCIE
 Res0	63:32
@@ -4690,6 +5087,89 @@ Field	1	VENG1
 Field	0	VENG0
 EndSysreg
=20
+SysregFields	ICH_PPI_PRIORITYRx_EL2
+Res0	63:61
+Field	60:56	Priority7
+Res0	55:53
+Field	52:48	Priority6
+Res0	47:45
+Field	44:40	Priority5
+Res0	39:37
+Field	36:32	Priority4
+Res0	31:29
+Field	28:24	Priority3
+Res0	23:21
+Field	20:16	Priority2
+Res0	15:13
+Field	12:8	Priority1
+Res0	7:5
+Field	4:0	Priority0
+EndSysregFields
+
+Sysreg	ICH_PPI_PRIORITYR0_EL2	3	4	12	14	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR1_EL2	3	4	12	14	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR2_EL2	3	4	12	14	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR3_EL2	3	4	12	14	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR4_EL2	3	4	12	14	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR5_EL2	3	4	12	14	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR6_EL2	3	4	12	14	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR7_EL2	3	4	12	14	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR8_EL2	3	4	12	15	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR9_EL2	3	4	12	15	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR10_EL2	3	4	12	15	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR11_EL2	3	4	12	15	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR12_EL2	3	4	12	15	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR13_EL2	3	4	12	15	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR14_EL2	3	4	12	15	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR15_EL2	3	4	12	15	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

