Return-Path: <kvm+bounces-65858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0104ACB91D1
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 38CD530D845F
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32184324B19;
	Fri, 12 Dec 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dZvJpIiC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dZvJpIiC"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4266031770E
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553034; cv=fail; b=pPLLzciGCczqf3z5u7CrjWjcQnpJEFvAaHLAK0AcS8fVBIp+qieOhb4DqQYqVm4yhdSsu1YtCDSDFrtgbxDfgnp7/30wFDSXmVP0mhXyEHWyXc5WLs1vnRmVvZk8FIYQl29DiIH61yHsK/3FA51d6egd4rcMRVG1jr2putXEhac=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553034; c=relaxed/simple;
	bh=zdQVW2xTpyJtP7hdYWJTqzMjowy3KFf0TR0yJw3XZG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pXtu3XsRzZLhPcSLpwDWUuwejm3VhVgjDUEId2rh9eTDbLHIM10CetD3HkKfIezoezS54AQ9liUPjhKQ/3GrRT+D3CIB1rYq1464FvfPrGI7yDHuPxpyX7YIrap5lNt95aA0WrElwNwpMCjWees2UVfkjX1OdM3mYIXkdoxx9ag=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dZvJpIiC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dZvJpIiC; arc=fail smtp.client-ip=52.101.69.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mNgYsL2zXs3fpQAMAGq8gwBec/J+AemFKfUD+03GhYfbfzR4L1xgVFA21FxFMVl5q0t/ZIj7LRHlu8GqRHS81oWZ2nFozf4swzfo+Bg+YCrgG/44E38gkvlBiYomNQXnkqYznjCnCMF1g35dAeTHgFKzS7WS31zK6gc2OTK6X0sQUTm2nmXQF7O8d8sgpGuogCCV9d3evWwajSp+Ii9VPUkBMcIGYnWagx8CFfuo2fChYjgSaoJjZoLuSP4R6Ya0IX8QobO+Jebz2bcZjzA0rjCJQ4QsXTaP2+Vwme4pqZ+6MwPywAwTYvaNfpNafZ3LSBhKO3qKU9l05FnCuFR2XA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jW5PH8ubDjyHpIc0LGLxvkt3dgx+B0ldP6QbhsqzeWo=;
 b=aMPOSsLZNpsYb8Ir1STjxu3quwhCj7ztZnQ/kVV4dGg7qW4vVDqibbTuIm4WfZk7loFqFva/EAGW2pp/JLAvgUmlw7XVqeKZhMRKuVSMZRwloMQ85bhb1hgTpnoUxZZqwXfl2ISZv/AypBsu4P7OsiZxMfI7Cr1YTOW1y70kdfuxJnwMj/Y65z8m4Y3EADmRgV0QxHs+UFxjHcTClyy5M0mxVGyJP1kOPs7jEDqO0IjeB8uYILAUrhWIlHxSptc/vAstFP6PMiApJUlnJ67S7DlNS1yfph2lgGbmK5672lHfhfob0la3bANgbaY790l+16zsz8+07qpIyErFoUeYeA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW5PH8ubDjyHpIc0LGLxvkt3dgx+B0ldP6QbhsqzeWo=;
 b=dZvJpIiCE2s+vqGJhpJpGI1w59MX8lxtgjyjgiSwAKwG0NKSNVlEoerXeaYnyjmiHnegSX88ZpbK5NhvrQ3YfOBD0s7x5m24MQWWnvqDHgUKEFdVJGysv45yLnVQxl/k7cyJmt9alPYnz/8H60bzfpoXAHpwa2LL4FLExZfRaIw=
Received: from DUZPR01CA0257.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::29) by VI0PR08MB11513.eurprd08.prod.outlook.com
 (2603:10a6:800:2fa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:45 +0000
Received: from DU6PEPF0000A7DF.eurprd02.prod.outlook.com
 (2603:10a6:10:4b5:cafe::ac) by DUZPR01CA0257.outlook.office365.com
 (2603:10a6:10:4b5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DF.mail.protection.outlook.com (10.167.8.36) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4 via
 Frontend Transport; Fri, 12 Dec 2025 15:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6hxemS8Aq7xSHr+qUcJsqslCzBumZPCeWi66+NpntOmaBlbtum8gasI5M//vyS9dHtBNS7/VeZsERWyYCzeBCU2ozH97oMa0OPpfTOJK5Z9Rsm5t9k3WDYljgXil5DsD/P9T+Ef2Kz9BdmgTZwJBvj+yCHirWecdPkTrYdWadZRNcNnKdJoPg4sUSMoWsYfWPV4kR/ywedMZ97/Qm5+jyfScZpmnmBaHLaSGBQtJxjjK7XC87z96b0YTkSaLmdmSkf53lOsAa6u7k46z3rJiU1lae91GurCixSsT9NOMOa6xDU3S+t1Lymk59dtAu/ZH2mNrjumnVZswqFIQqObSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jW5PH8ubDjyHpIc0LGLxvkt3dgx+B0ldP6QbhsqzeWo=;
 b=CqFMiI7RfX0Yz5EGTo6Wvaglg50vwon1hox1rg2lDDt6+T+Lb4NyoCxr/Mbn+RmMhOGBincwrtXA+rqbkGAZQ3sOJJXf03sVV2RcuVIz/DSiZw/kAEi59DH4WwAZomfo3W31cy8B4r9gupvcHOBm2ANa8Q1rGyscBh++qVmx35XFzBjYxc5tKDuI2QqJJ5/OsF6onScpcK27upQpqjol84vq25/nF/HTvB+jEtcANOnYtwal5khGzDdycuyj3BrdsluXtFFr4aTyR+mu5vRfLfhb9b7QVcl05Ae/+wiM4zJIqgKWAC1iCpWurGJcZ7gd5cy5fZBdcgsPuaP5C/ofSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW5PH8ubDjyHpIc0LGLxvkt3dgx+B0ldP6QbhsqzeWo=;
 b=dZvJpIiCE2s+vqGJhpJpGI1w59MX8lxtgjyjgiSwAKwG0NKSNVlEoerXeaYnyjmiHnegSX88ZpbK5NhvrQ3YfOBD0s7x5m24MQWWnvqDHgUKEFdVJGysv45yLnVQxl/k7cyJmt9alPYnz/8H60bzfpoXAHpwa2LL4FLExZfRaIw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:41 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:41 +0000
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
Subject: [PATCH 16/32] KVM: arm64: gic: Introduce irq_queue and
 set_pending_state to irq_ops
Thread-Topic: [PATCH 16/32] KVM: arm64: gic: Introduce irq_queue and
 set_pending_state to irq_ops
Thread-Index: AQHca3snKFUfGawyy0G6cq0rHQaFWA==
Date: Fri, 12 Dec 2025 15:22:40 +0000
Message-ID: <20251212152215.675767-17-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DU6PEPF0000A7DF:EE_|VI0PR08MB11513:EE_
X-MS-Office365-Filtering-Correlation-Id: 33885596-1fb4-4c2c-bd1a-08de39926fba
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?OCRrWva8CRFjs3zGlrcOhpAuANr0obBtnpIP/rWsVC5N+dFGyme/2pycI+?=
 =?iso-8859-1?Q?eAeFj2GFzz5MimomHnGhAjzhLeDBGBHGMnNZWBi4WGi7BGIBH9+2sqTp8v?=
 =?iso-8859-1?Q?ts/oUEiUlN5D97HVb9cFabw2W658+5VvZSIE7XO+eQT9smlxBsGNTzfexU?=
 =?iso-8859-1?Q?cHwC56DvR495VEVyrzWF8p5RMuYIkxDfn9UdOW46Quj7VO8BsaPHBscdHI?=
 =?iso-8859-1?Q?TLRhGiy8oktaloEDHV1nye5gk1oEXxTlw2oqd+WE3kh/6N45RT9ZYz1n2A?=
 =?iso-8859-1?Q?kC8QRgQZhsp7NlwKEllyl0usaUzpI548J2gxLzdRdpl6pTIpgJIjpT1BhG?=
 =?iso-8859-1?Q?N9BTwFbiLHHJUeTGRX6Adv0rDfBhaWWdORuCwNn4oByPRi5oUu0R4wo43J?=
 =?iso-8859-1?Q?gm+7rBj0YlxtFqnA0OGopxnoomPS4/Ma+aqN7/FNDX4ixL1P/earGkHza8?=
 =?iso-8859-1?Q?uuiEWy3FWIZoHP5Z4TmMIBdBiZh5SE5ETnmbNDVe+CiuTWwtQT1dX6GMAn?=
 =?iso-8859-1?Q?JoXSe4iOPPgn/iVFz9DI0iZtj7Wd+I6HC1E2AgtEQeOqH37/116MmW6vTt?=
 =?iso-8859-1?Q?2K7VGl059D0PsaBrJKVliVaQqja6tUhnZSWlBV85P6IlESpz33xJaWeygz?=
 =?iso-8859-1?Q?Ih+NjgcX7jPvLNxxTNetozagsOZ5A8lxzn5upvb+/+72H21ctFGt9kLZLr?=
 =?iso-8859-1?Q?7GGSGbXz5z6y6kwznkZOZT6MvXpCkISdQDNu5+MdIlfGFp4jLvyXNGLsgo?=
 =?iso-8859-1?Q?gsYdpUtml4mqMgfXbKciIy+iozHOc4NvLj2I0K0Gbq3cqnqrtTSZVlYtD3?=
 =?iso-8859-1?Q?Gl+lTfrvs+twOjUsoPHJkFN3hqnPuSMeHKmWdd03r7omYZTQPIzY3qLy/s?=
 =?iso-8859-1?Q?NQoF7n2TRPARTXurVZVUxUZBb8w9LN2we00Eioovfx2D8ZVXdE3+kuU8ZP?=
 =?iso-8859-1?Q?lpKmeLUZ4cae3WW1yp2LOOoC3n1ELi+n3pGZnkoSVyy6eYdXvd5EdGTTXr?=
 =?iso-8859-1?Q?wApH+TJL0rPxcBb67NXYa7Ct0371E8yBsRkX/uJYEs7+T+xwtWWsFsKil5?=
 =?iso-8859-1?Q?nh+/z5gngW7VBZQR+ObHbzjl1c95XvYHzaQpv7SetmToREPgDymMS1zjk0?=
 =?iso-8859-1?Q?YKhN+3tFOdk+qxF/OUln4rzCnCKxo3DjhW3tVDxrrDuKs8B0YPXXNv/oVi?=
 =?iso-8859-1?Q?zE6eZbUXkLTX9zqapg1geFvvsSfrRU+/1bgHz/Ygivf1t2co9BAu79MjPG?=
 =?iso-8859-1?Q?obficiSvhtsm4u/LJdh8hNO+mC40LNecxQ3J6GNTQA0SmsojFVge3T778J?=
 =?iso-8859-1?Q?ctqy6scz6LGFEREFjuLmismWOy2lYRMqMVl+qd4ek7ShaVkBQ2zvnNCOob?=
 =?iso-8859-1?Q?XW6Ts4oEdkOzpeO4PNhpyyYfa3d0WwJwR1q4j1bC0/gE0/Mm/KX4cm7gno?=
 =?iso-8859-1?Q?SY3MGNU78xIZ5fspENgwc7705/kdL198PRYYeSOGDB6f6lnsXnU+canU0H?=
 =?iso-8859-1?Q?X7nTwB0z/NKOb85+SyEfaVvq3xxwSHb1+mas0sGovhL22Z1JH1pftxaVJl?=
 =?iso-8859-1?Q?h6dxZkYFXELt9JxUl0XrDig95kgu?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e8754077-a9b0-44fc-94e3-08de39924abd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|82310400026|35042699022|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?CeRqLtcEliRw97YY97Xrho6Ai0as3ILDJ8RvQMj2YED6m3VrLaz4YeAk50?=
 =?iso-8859-1?Q?htxlvjO+byUpo+ITUCxK68vX4LfCKHUUrfZLX/wvbI2CByQBPv5WWUJ9JW?=
 =?iso-8859-1?Q?r3637/8qkqBdbfgtRmBzKbLQg3I8d4HPE+1nnRXaS+qexLiwuNB5XA3Qiw?=
 =?iso-8859-1?Q?j0hpytHsSqOeNE6Os6C/jAbFuG6OgFWLEX7QPB5+UMaMDySeEEUmzxscTu?=
 =?iso-8859-1?Q?S1EAbHQfTU73WzfgeNOnzT3clGHUxXJDA4/H4YqnRgz9i24MD/Fu0g4f3o?=
 =?iso-8859-1?Q?rJrTd5dDM8IdlF/GzGMA3hhp/BosWAxm4isfRAODacN7UNUMldnSdero5F?=
 =?iso-8859-1?Q?WiIoTyB1UZYfBDqQIjH4GINZh/DzE8oJuOtq9eQXU9MnxRbrodbVKcYMpS?=
 =?iso-8859-1?Q?57XnOTZKl6IDD3W8yQUMeb5MMXOcJPE+PtJocgCzt46DwvTUc8MetFfxkG?=
 =?iso-8859-1?Q?mQqpvQuHYHXPyXj2q5Urh/a74OMtwsh7GIFQKDpkp/J+cxRI9QHoYJY1gv?=
 =?iso-8859-1?Q?U+enDG7z/T4NZAWGPiXSUsbcCNiUfzHOwqWbfeyZlk06SAEv4eU/5p4qvi?=
 =?iso-8859-1?Q?OGAR/cQle09SMKHMGaMYJ18vZwUQNM+UPLci8754DFuZoPIcNGcD6rPytk?=
 =?iso-8859-1?Q?QdIbWxSEawYNNn/BcTYUpjEhcSNOhWvs2mTP8koGRy3eal1LmWZS3lTCp4?=
 =?iso-8859-1?Q?5n9kv3OGzAoXZbO3EjYoxXZEXF0b4X54pX6atJCuwvNgL1IcIE6XJn0+DC?=
 =?iso-8859-1?Q?b+7sM1536MKHUEWf72YA174B9xu4CaTOB/hTHJjSr359kdqfnb84ELjWwP?=
 =?iso-8859-1?Q?aMbCBpbw5g2xdMdxz8OvZx+a+Ri3YEKHoycn97lZzYDVFB0qIA5jAe9nY8?=
 =?iso-8859-1?Q?+UnS7nXXKmh+fxtjY03Wl23jA5wNvMWUv2BUOr0IBqH+q1YB2sT0KjdyH7?=
 =?iso-8859-1?Q?CBNKi8TtYI4loGA0+27jBOVUGgvmc1Vz6L98kCB+SV7kn5LyfYdEXPDclz?=
 =?iso-8859-1?Q?eeeXt7CSq5oUPiy9wnwEI7f40bBIjWt1bAPPBY5BfHX2/5dO80GWZkgnzE?=
 =?iso-8859-1?Q?rPamNSwkPxx6DLUQGYW2ucQoZtksIC9ARHU76Ib/s7No1JNR9BvfFMbXjL?=
 =?iso-8859-1?Q?JbtPFpiiKcAU7jiDp/X69cpHhjH3FiOntN10EB+c+Gm8pgN+O6sb3K1BrC?=
 =?iso-8859-1?Q?BbUpFLLMAi4k1Q8igQpXKheER6PcdDEyi+cATV3sQVQBjqtUY5da+EFnbX?=
 =?iso-8859-1?Q?RchHZOwBaefT9e4AjcLnWsTWmDCNmkpgJDT85kKs6gPPFS0QURLnMvlqwJ?=
 =?iso-8859-1?Q?wL++AqOM8XDMj2EjLKe1Z+2iO/HdTUJSrst1aGi/2tv46G1trFM8sYqhS7?=
 =?iso-8859-1?Q?tH6t3k0rXYGiDpEYmagEZ5XqRzJlNVbiX7oUd4IPNXbZTwsELYTWHfRK0i?=
 =?iso-8859-1?Q?Bu8CJ92HXyVl2H3ymWD90fEPmgsQZ9KvRAtO7oA2txEKbuqIy1jKnIG5kD?=
 =?iso-8859-1?Q?sS/dE62oJ7Qb+MP/x1p6o1G/Rzn2AS+v4Z4Nti5rKkHuGlnOU0+W0uizhk?=
 =?iso-8859-1?Q?JX+Ot64u2hs7fE8PkgWCvA7sECJPnrnLTRYjikf/zbvsYMu/TDDz3V9QMb?=
 =?iso-8859-1?Q?1llcbyRQeF2xk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(82310400026)(35042699022)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:43.4357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33885596-1fb4-4c2c-bd1a-08de39926fba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11513

There are times when the default behaviour of vgic_queue_irq_unlock is
undesirable. This is because some GICs, such a GICv5 which is the main
driver for this change, handle the majority of the interrupt lifecycle
in hardware. In this case, there is no need for a per-VCPU AP list as
the interrupt can be made pending directly. This is done either via
the ICH_PPI_x_EL2 registers for PPIs, or with the VDPEND system
instruction for SPIs and LPIs.

The queue_irq_unlock function is made overridable using a new function
pointer in struct irq_ops. In kvm_vgic_inject_irq,
vgic_queue_irq_unlock is overridden if the function pointer is
non-null.

Additionally, a new function is added via a function pointer -
set_pending_state. The intent is for this to be used to directly set
the pending state in hardware.

Both of these new irq_ops are unused in this change - it is purely
providing the infrastructure itself. The subsequent PPI injection
changes provide a demonstration of their usage.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c |  9 ++++++++-
 include/kvm/arm_vgic.h     | 15 +++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1fe3dcc997860..fc01c6d07fe62 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -547,7 +547,14 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vc=
pu *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
-	vgic_queue_irq_unlock(kvm, irq, flags);
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
+	if (irq->ops && irq->ops->queue_irq_unlock)
+		WARN_ON_ONCE(!irq->ops->queue_irq_unlock(kvm, irq, flags));
+	else
+		vgic_queue_irq_unlock(kvm, irq, flags);
+
 	vgic_put_irq(kvm, irq);
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ce9e149b85a58..20c908730fa00 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -115,6 +115,8 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
=20
+struct vgic_irq;
+
 /*
  * Per-irq ops overriding some common behavious.
  *
@@ -133,6 +135,19 @@ struct irq_ops {
 	 * peaking into the physical GIC.
 	 */
 	bool (*get_input_level)(int vintid);
+
+	/*
+	 * Function pointer to directly set the pending state for interrupts
+	 * that don't need to be enqueued on AP lists (for example, GICv5 PPIs).
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
+	/*
+	 * Function pointer to override the queuing of an IRQ.
+	 */
+	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
+				unsigned long flags) __releases(&irq->irq_lock);
+
 };
=20
 struct vgic_irq {
--=20
2.34.1

