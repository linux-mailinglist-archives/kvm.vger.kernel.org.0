Return-Path: <kvm+bounces-67227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB4FCFE709
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 16:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A7E6A30019E6
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 15:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC32D357731;
	Wed,  7 Jan 2026 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ATSXLq5j";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ATSXLq5j"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010038.outbound.protection.outlook.com [52.101.84.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A1434EF05
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767797585; cv=fail; b=OF+I5YLOhn2F08sKb1elH1OQEswp0PynzbXM35YQEpaNPnsSrp8eto14jEQic0yLONrMQHFBZriQevp/GE032ioEo6iDYR/XRAgaAKmiS8voAaLczRx4MsJvLxbV8hf9Fp8hatByxVt+liT1REPPdL/RNIpB63YdjOqVAjd23jI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767797585; c=relaxed/simple;
	bh=5GDEbwPy6aRLbzsFrRi7zRyYhSU/ky9e9DFKE0nHyow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L40PUJjxahsnDrYYG2Vbu+2jJIuhwxeauDM95lQHSZfQw6qBTDSgxB+36AYMk7GpAdLX19RKI9TLYdcWj9DIyN4tfx+wDf/7bvT71XjvXVew81pA1y23uu+lNTYI0DuVBfyVODxkx2TbFP6neZvxTMFrYsfpHIpIvIOLKDyzXpQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=fail smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ATSXLq5j; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ATSXLq5j; arc=fail smtp.client-ip=52.101.84.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kazTFxXnlNUCc0jA+h0+W8PdUK6S0ezoHEbRlHnoEyJtEapuIBgoxeA89C6YHFUiRYqM119L5uj3wGOChT1Q84JUCS3ZD1VJMY5XPldjW+ysNLMKJSCREyPyqPy0WWi+A2Y7V3XGxUJAp1GXbjX6NAnnk2KxNxnZ+XfSiPD7hfvN2jZ7fSVZFUlcf9GVlOJZkQ4PoMpwTtXKSLLe3O8W6HEBZNCeWNfaSNjlt1dDtnGBkP2HJoyFQU5UOZfvhVwa7puRlxxiJ8oRuOm1XX0x9elc+Zoo4+gjWyqu4T9dqNiYNDt7C5oiuKDk4TCMDGIsW+3BujrBBft3BudKqRaMiA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GDEbwPy6aRLbzsFrRi7zRyYhSU/ky9e9DFKE0nHyow=;
 b=jGiLwsLvU65gxRQCNFF7eZAVQnUee/g7bI0w4e6xwMFML3zgSVyWchvK+bgjVtacRmbfHZsEidzip7YQu1ShD5HspKdAoGY8Sc4+P5Xj084ZyHp/3VRYXBaRhwYmkGORsUBLUa/dO+PU/6OPH4fefjOxH1+zaMApnGjLsQ/a4KswL5eb696A56+Dz7CTbPbTVh+X2B4Tah2J7BBMyN51ucO6gU/MfFeHor7V6eTfwrS6elrs3YcCDBjNPEfq51wk1zUWGoshcn3SnoVCXIgnlD3kzE3cmQsCNsUBMN+1xmHPxFn2HgEzjPhl+3S0LU+/lCv4o5ymlq+E7YRlyZmStw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GDEbwPy6aRLbzsFrRi7zRyYhSU/ky9e9DFKE0nHyow=;
 b=ATSXLq5jW/l0rObxd3oavtRNesxnAf+ju3LRzTq9QqRrdJW5kpOFmwiymzb+qhBJLQNTYx2bhsM4hIyw2djSCkxyrpc7KLh9FBq1zwtLcB0ir6fNYv+hixHAK9VmU3dEEhzAf1+aw23eg9ibHARWK9quQ0kyWOJ5OnvOBAhc410=
Received: from DU6P191CA0054.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::21)
 by AM9PR08MB6066.eurprd08.prod.outlook.com (2603:10a6:20b:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 14:52:58 +0000
Received: from DU2PEPF00028D0B.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::3e) by DU6P191CA0054.outlook.office365.com
 (2603:10a6:10:53e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Wed, 7
 Jan 2026 14:52:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0B.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1
 via Frontend Transport; Wed, 7 Jan 2026 14:52:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEcUjUJpxvBR4JM/XHlE9fMlobJbgh0+jae+RNCYc50PbNL9/wpZDJMsE6lQe6ockuRlbyHIWcs6t6mnDcELX9qtAv2MQV+NYUcPcdzT4NkyvjTnCSUBsXw9SLd4qtCZdZ0iBefIGJTFSJI3AMEMrSgGZj81ne01UCWyeaB4N0dcIl6mJ+M14RqXiM6iGm5Z4LLjkzIs/VQCu0rGhPF1NLzGJT2HaAmATX7+v34PCZUlhRKKEd2++HpnCnpg0WVbub0ciFxNPvJYhDJu/yEHzzag1+1BeemuXhI14S1srK6p2UH0kJfD0xq1mt4LKzCmLyvoqNL21PZaVIFlHTtLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GDEbwPy6aRLbzsFrRi7zRyYhSU/ky9e9DFKE0nHyow=;
 b=cwV2eImbI/VQEyJsRH5700VguzYTowvoz7MHALQUgKKtCebwkT8Im7L8mdyY15EiiekHrQbwwkKbb0iaGCHJnlADZ4Zp5yFrakizSJsGMDheuIW6UC6hDxtoOV+PUx4Te8JYqiqA/JBVgnqh3+cDwxdmAq3euBbLH4J669SwOkCqH+3WeZwoRlGYf6I0hcmmWGPBlIqKSIR3dd/hr/0w1MHQSVl/Y/8HZ5+jVn5VhiqIdyM1euwxx5NW6ex3+06BKirRxFL5Re131UTZ/smEQ1m8XYxZHTUzH6bT4X6vZK4eAat0JqUXnxaZKi4JIZMY8oWeTVBoFIDNYz10XP4N0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GDEbwPy6aRLbzsFrRi7zRyYhSU/ky9e9DFKE0nHyow=;
 b=ATSXLq5jW/l0rObxd3oavtRNesxnAf+ju3LRzTq9QqRrdJW5kpOFmwiymzb+qhBJLQNTYx2bhsM4hIyw2djSCkxyrpc7KLh9FBq1zwtLcB0ir6fNYv+hixHAK9VmU3dEEhzAf1+aw23eg9ibHARWK9quQ0kyWOJ5OnvOBAhc410=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU5PR08MB10468.eurprd08.prod.outlook.com (2603:10a6:10:527::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 14:50:38 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 14:50:38 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 15/32] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH 15/32] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Index: AQHca3snOVn3vQjJPUKUcgOiolLUfrUlvO+AgCE2EoA=
Date: Wed, 7 Jan 2026 14:50:38 +0000
Message-ID: <8cc7fd36a1259354fc9f6c2cdac26e9e1f884607.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-16-sascha.bischoff@arm.com>
	 <861pktnxow.wl-maz@kernel.org>
In-Reply-To: <861pktnxow.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DU5PR08MB10468:EE_|DU2PEPF00028D0B:EE_|AM9PR08MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: ca991f99-5897-4def-6095-08de4dfc71f9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Q0hNL3ZKUk1rbE1TY1VmaWtCd3NnT3hrL0RzSnBSd3gwMktEc3BMVUgyQnZK?=
 =?utf-8?B?VnY3eTc1bTBqSkhwR0NBMkVJWlZ6amNhM1NMNW92QzRmNVZDU3dzMUk3Z2RL?=
 =?utf-8?B?ZVZpMWhEQTZHYTdBMmZBSENxSnc1TG14Y0lIYWF1RDEwV0VURm9yMk1aVjRS?=
 =?utf-8?B?bnZOQ3Z2a1gzd2JlbmlwNS9TVGRNSk9iVGFoanZWbFBKVzRuOC8yY1BDZ1Uv?=
 =?utf-8?B?K096NGd2NXkwTEFzZ2VZU1FEY2hnZ0lVUDFHUDBMYk1zeThWT2d5NTV6eThK?=
 =?utf-8?B?ZlhzcDBkQ28vL1c3T3h2US9XY1NLUGFPeDRqMDM3bzhQYzhacjNOY3RzeTBQ?=
 =?utf-8?B?MGd3M1RYamdJa1J5S1FBOXEvUmM0bldEUDFKWVRzdXo5Vy9aVEMwYXk2UnB3?=
 =?utf-8?B?VE83dHpYYjdiQXpEN3lJVmoyN2FyRWozQ3M0RWdRSUtsRWtJNWdlU2syZUd3?=
 =?utf-8?B?ejUwQlB1NzhGSzAzTG1TN0Fva3hlbFhiUFdjbFg5NWlML2hVTXM3bXFyR21F?=
 =?utf-8?B?b0xjY1lMZmxhVVBmRFRGaldFS0ZRbmZmOVN0eHFPTjMvVkhBMEpac3FsMmVj?=
 =?utf-8?B?TFhCUUFNaUF5VWUySE1xdEZ4WWhJSjI1Zi9jakdzRlR1V0ZzZ0FDVkpDMDFi?=
 =?utf-8?B?QWVOZUJWYlZldmtpemtZNk12VWFKZFdVdmdPSXlYdHltM1gvSkRWM2pWc0tu?=
 =?utf-8?B?WmVLVEx1OVk3V3lhSG9wanZHcElQUmFYT1AwYjNtaWZvSVJUTmVPUmNOYTlZ?=
 =?utf-8?B?TmJvSXVLcndVTlpwLzR4TnViemRlS2xVYjhnV2VLN3h1L3EvbHh0b3psWVd0?=
 =?utf-8?B?TEJkSC8rYjRwY0xuQmU2L3dGWjhhcjIxbEVVemN2VnlFNG1KZ2E5UWJvWndD?=
 =?utf-8?B?elVyMGh4cm5vTzZEc25NZnBmdXR0VmtROGVVL29Md0ZjajFiN25jYWYrUkNx?=
 =?utf-8?B?K0JGQmFpdFFGSSt6KzlHQXV0U3o0WjFWZjN3ZisvcHoyUnNERVppSGY3MDNy?=
 =?utf-8?B?dVVYOW5ERzB4OURJbUIyaS9EaVhhRG5ZbzFiRXo3SVNLcFgzd1RKVStmZy9C?=
 =?utf-8?B?UWhRQXJsbXZldE91M1k4cU9xMzN3TVVGbkJjRitJNkhhMG5KU1pwRmpHUSti?=
 =?utf-8?B?RWFlR1pUMEdwaG84V2VxenVFOFBDUG1iYVRHcGIwQTZuVUhMVkx6bkIwcDRa?=
 =?utf-8?B?bGxRbzkzcHhKZGJFVk5aT2tPVVFPVHRRYWRKRUxCQ2JmdnZCY1BXOU53TFZ2?=
 =?utf-8?B?SnhVQ2x0UERyVWY3WGVMcEwwOTNZNzBVVC9hdjFTeU4reVk5STZvdjMyZXFr?=
 =?utf-8?B?NVNTZkVWb2JzUXRMYkpPY25yZ0hPUys2QzNQWUJQbVF6V0RNd09XOG9sRlFX?=
 =?utf-8?B?ZEtDZW1UaitENUNNOGRtdWFmVjJFS2lsRkhuWHRpZ2I4d3hscHpCZ3NkeXhB?=
 =?utf-8?B?d3NBdDNQbGJOd3BzbmJHQWJodnBPTjRybk5oTzM1Z1lodG1BVFlxVVJCU1RD?=
 =?utf-8?B?Z0dTOE42RCs5VkNqTk95bHB1TXFuRlhqeWxUSVhlSGs4M0FGSDVOaU03em85?=
 =?utf-8?B?YldGeEZSbEQ5YnZjbmh5b0hJWW1kVlZzUjhvcGNZam5kbWpXS1AvMy9NN0Vn?=
 =?utf-8?B?c0JLRVdWeVMyT01vU2ErSEp4MHJMUTRITjB6WFo0Y25rUkxXNEFQVXF6Rk1w?=
 =?utf-8?B?WFoyQmxocVV2ODhyVlVHb0s4TlpsakVIV0MrblptQmhFWjNSb1ExSTNha3JE?=
 =?utf-8?B?RGxqVjZyVHczTE56ZEJ1ZGxyV0hUZTE4azhzaXAvRFY4V054ZHhQeHNCd2hu?=
 =?utf-8?B?SkQ5UzUxajZadDJtamp6cE93VVpEMmdNdy9UUktIdUVidmYwbnJtUGFnMnox?=
 =?utf-8?B?Q3NOemg0NGJEK3BnenMwT2k5U0c5WkhjbVNKWXNjSmtrUzdYdnJpcEVUVHRW?=
 =?utf-8?B?cTZhUkd4d24vYjdPa0JHZnc2VVZzZHhRUmliNzlNZXJ1U0JEMzhlUkI3bXJC?=
 =?utf-8?B?V0l2a3g3VjZKblNUV21VQUpCOGJRZmZvRVhGRmIvVkdIRW9CZGhNVEtsaXRX?=
 =?utf-8?Q?bvZ1al?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DCAF483F1E97C4599B0DDE170FDF7D5@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10468
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	99b3f5fb-c1e5-483e-8b0d-08de4dfc1f23
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXZKVmdBMXNIV3JHUS8xd2JVVzhTVnRUckVYN3RhRjBXQmM4VjRUWW53SmN4?=
 =?utf-8?B?clgvRG1XdHkrOWYxM3B0OEE1c0ZNTnpxc1VzRi9nTXRGVFRtUVdJMkVoTGVa?=
 =?utf-8?B?dWtQRDJDaVR3aGVWL1BIZ2VEeS8yRFpQSjc4WFg2S0ZqWmUzcXFEclkvUTdJ?=
 =?utf-8?B?cTNDQUZsQzFibGZJejRuKzZtTER0ZndobDhLOEx2QnN1SC8xYkkzdG8zY1Z3?=
 =?utf-8?B?NElDQmJWcFBnSWdBcng1UGhxYmxMTDJ4eFdsdXUzNlBMQnVFUGdGWDNXMUg5?=
 =?utf-8?B?L21jYUtPUzl0S05NSkJ4aG1lWFRpaWNtZ215K0c2ZjFSZ3Q4WFJMN2tKWjA1?=
 =?utf-8?B?UE9CV3Zlb2JuUCttZjNheGhRN0puZVE0dzV1UWpUcDgxMlJoOFJlNEgwd2lB?=
 =?utf-8?B?KzNhdGxXTnZXcmVmWElJRTg0RU9qOHozRDRlL3RtZ2tVeUtYRk0yanNzRm16?=
 =?utf-8?B?V1BkUm9KSGFzSFJnZ3daSWtjY0phMU9RN1dWZTJPQzdEL3BJeExNY3k5UEtl?=
 =?utf-8?B?OXk5VGYwRk5rb0E0aXpoNUMzNm5qK0svVk1vMjNwTXk5UFlhSVZSQXkyZFNU?=
 =?utf-8?B?UmZDOHZrZ25vOE5hNXM0bXJPM2JXTGw1R0VJaU1GRDRiYzBBcmltU2hScWV2?=
 =?utf-8?B?NlNHSWFydmEwUlBtWno2K2FPa1JwMFV1NmJYL29UT1U4b3Bpbm1WeTA2L25t?=
 =?utf-8?B?WkQyaEhOcFh3MVJEWXpMZHRBWGZVZWtBWlVKdVlPVHFMZThaaktmUUFsMmdM?=
 =?utf-8?B?VVBTcFlKVGpPaSsrMHNOTWcxWXoxWUxFYWF6VkRreVl2U01oSzRLNjB4UWVR?=
 =?utf-8?B?UE1iU1JtZXE3enhmekhmV1N5Zk9LL2JkRmg1UFBVazAzUDVXZHp3enkvUHpi?=
 =?utf-8?B?YVlhUzBmMlRiVy9OYm1HTEZva0J1dnNZT0lFZlA4b2xwUFFMTm9ZeCtaeFpm?=
 =?utf-8?B?cVZoajVZS1pHeGtVVTc1UUU3Q2djb0s3WVhUV2FGOUpubGRrVDlDbHBjODZN?=
 =?utf-8?B?RXpRdEcwdEt6cGpqSDN4WnltK1dzQkR4b3l3MVZCcEVSYTZ2ZWVyR2ltWkxH?=
 =?utf-8?B?cTFGcGdSSktTdkRaYzRKVVRvVEZzUWQ2QXl4K0M2WXZzQkYvUFU4UkJpNkxv?=
 =?utf-8?B?ejJFRnRpMTM1dzgydjZ6RlJ5WW8vWk9oMkZ5SzJlQXZ0aTVzdGNCUlVXc2hh?=
 =?utf-8?B?WnQrZnFyU3VVUjd1STJvNjNxbTNtcS9TclJxdkJYcjJDUDlGZFhEWFVnb0to?=
 =?utf-8?B?cU0vUkhNK0s0bDR5U2R4c2xEdE5JRGcrOHZ4bzZqVnBJWHZTVFd0ak1hMHpJ?=
 =?utf-8?B?WjZkWTNmSGFoQXNlZTVZR0xWNERwdUtqa2NSZmZjRWQzWmxWTldWYnRJUitk?=
 =?utf-8?B?R2pYRTRDeGNQTWtVZ0Z4S2taci9oZ0dnV0ZFSDVGMkNUSWF1VjZUSnBkQVhP?=
 =?utf-8?B?WHJlWElVQUIwTzlIcEE4Y3pmUU56NlZuVDR1VlVZT2duQjMycFNMYUoybmZY?=
 =?utf-8?B?NjJnelBXaVI0ejMrUjFSTGd3TmNSMnpTNmVNZmJ0ZXJtRW9FSkhLZmoyUDkz?=
 =?utf-8?B?WEtKemNSdVBkaDFjS3RvS243VHBCVGdyVmJsb1VhbjlaTW5DbENzNmR5dVV4?=
 =?utf-8?B?YmpMMFdPVHhOcUFNZWZLMlFnZzVTa2VVOUlFQVZGUDJESFVBeXlIbi8rZklN?=
 =?utf-8?B?SzNGYVMyNjdqUFZaUXFpYmQ4ZjYxd213Z0IxY3BNTG9ESHA2QVROYStRV3pU?=
 =?utf-8?B?MTZsdkgzeHN3SXh3R0J5NUFmY2dKZGowNnVBOUd0WUhsdUgyQ2o5NUxZblhB?=
 =?utf-8?B?MUJsaFpMT01nWTVaM1NXVi9zdGt2a2dnMVNIMTBuaHgySldLcDJKOWRWQXJW?=
 =?utf-8?B?b20yTG5oS21nWmVCcXg1OU1PUlBmb0Vod2Mzc3hjUzdVQ3ljNW1GcVdKNmNE?=
 =?utf-8?B?THZBald4VDFsL2FNbHRnT2RLVmhRL1NUNWE5dTlzaVUxTVhKNHVIeCtVdUJ2?=
 =?utf-8?B?Y0ZlK05XeFNJeWtsbmg0S21WR3pzcjZLMDdMQU1GMGI2aHI2MkRRMmpEN3lR?=
 =?utf-8?B?ekQ3MXJyVW9DK2RramhOYVZmSHZmWmNrVWozYklDMzIvaFRNbk9aeXlLcjJM?=
 =?utf-8?Q?Uv2M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 14:52:57.1273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca991f99-5897-4def-6095-08de4dfc71f9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6066

T24gV2VkLCAyMDI1LTEyLTE3IGF0IDExOjQwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6NDAgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEdJQ3Y1IGlzIGFibGUg
dG8gZGlyZWN0bHkgaW5qZWN0IFBQSSBwZW5kaW5nIHN0YXRlIGludG8gYSBndWVzdA0KPiA+IHVz
aW5nDQo+ID4gYSBtZWNoYW5pc20gY2FsbGVkIERWSSB3aGVyZWJ5IHRoZSBwZW5kaW5nIGJpdCBm
b3IgYSBwYXRpY3VsYXIgUFBJDQo+ID4gaXMNCj4gPiBkcml2ZW4gZGlyZWN0bHkgYnkgdGhlIHBo
eXNpY2FsbHktY29ubmVjdGVkIGhhcmR3YXJlLiBUaGlzDQo+ID4gbWVjaGFuaXNtDQo+ID4gaXRz
ZWxmIGRvZXNuJ3QgYWxsb3cgZm9yIGFueSBJRCB0cmFuc2xhdGlvbiwgc28gdGhlIGhvc3QgaW50
ZXJydXB0DQo+ID4gaXMNCj4gPiBkaXJlY3RseSBtYXBwZWQgaW50byBhIGd1ZXN0IHdpdGggdGhl
IHNhbWUgaW50ZXJydXB0IElELg0KPiA+IA0KPiA+IFdoZW4gbWFwcGluZyBhIHZpcnR1YWwgaW50
ZXJydXB0IHRvIGEgcGh5c2ljYWwgaW50ZXJydXB0IHZpYQ0KPiA+IGt2bV92Z2ljX21hcF9pcnEg
Zm9yIGEgR0lDdjUgZ3Vlc3QsIGNoZWNrIGlmIHRoZSBpbnRlcnJ1cHQgaXRzZWxmDQo+ID4gaXMg
YQ0KPiA+IFBQSSBvciBub3QuIElmIGl0IGlzLCBhbmQgdGhlIGhvc3QncyBpbnRlcnJ1cHQgSUQg
bWF0Y2hlcyB0aGF0IHVzZWQNCj4gPiBmb3IgdGhlIGd1ZXN0IERWSSBpcyBlbmFibGVkLCBhbmQg
dGhlIGludGVycnVwdCBpdHNlbGYgaXMgbWFya2VkIGFzDQo+ID4gZGlyZWN0bHlfaW5qZWN0ZWQu
DQo+ID4gDQo+ID4gV2hlbiB0aGUgaW50ZXJydXB0IGlzIHVubWFwcGVkIGFnYWluLCB0aGlzIHBy
b2Nlc3MgaXMgcmV2ZXJzZWQsIGFuZA0KPiA+IERWSSBpcyBkaXNhYmxlZCBmb3IgdGhlIGludGVy
cnVwdCBhZ2Fpbi4NCj4gPiANCj4gPiBOb3RlOiB0aGUgZXhwZWN0YXRpb24gaXMgdGhhdCBhIGRp
cmVjdGx5IGluamVjdGVkIFBQSSBpcyBkaXNhYmxlZA0KPiA+IG9uDQo+ID4gdGhlIGhvc3Qgd2hp
bGUgdGhlIGd1ZXN0IHN0YXRlIGlzIGxvYWRlZC4gVGhlIHJlYXNvbiBpcyB0aGF0DQo+ID4gYWx0
aG91Z2gNCj4gPiBEVkkgaXMgZW5hYmxlZCB0byBkcml2ZSB0aGUgZ3Vlc3QncyBwZW5kaW5nIHN0
YXRlIGRpcmVjdGx5LCB0aGUNCj4gPiBob3N0DQo+ID4gcGVuZGluZyBzdGF0ZSBhbHNvIHJlbWFp
bnMgZHJpdmVuLiBJbiBvcmRlciB0byBhdm9pZCB0aGUgc2FtZSBQUEkNCj4gPiBmaXJpbmcgb24g
Ym90aCB0aGUgaG9zdCBhbmQgdGhlIGd1ZXN0LCB0aGUgaG9zdCdzIGludGVycnVwdCBtdXN0IGJl
DQo+ID4gZGlzYWJsZWQgKG1hc2tlZCkuIFRoaXMgaXMgbGVmdCB1cCB0byB0aGUgY29kZSB0aGF0
IG93bnMgdGhlIGRldmljZQ0KPiA+IGdlbmVyYXRpbmcgdGhlIFBQSSBhcyB0aGlzIG5lZWRzIHRv
IGJlIGhhbmRsZWQgb24gYSBwZXItVk0gYmFzaXMuDQo+ID4gT25lDQo+ID4gVk0gbWlnaHQgdXNl
IERWSSwgd2hpbGUgYW5vdGhlciBtaWdodCBub3QsIGluIHdoaWNoIGNhc2UgdGhlDQo+ID4gcGh5
c2ljYWwNCj4gPiBQUEkgc2hvdWxkIGJlIGVuYWJsZWQgZm9yIHRoZSBsYXR0ZXIuDQo+ID4gDQo+
ID4gQ28tYXV0aG9yZWQtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW1vdGh5IEhheWVzIDx0aW1vdGh5LmhheWVzQGFybS5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJt
LmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jIHwgMjIg
KysrKysrKysrKysrKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmPC
oMKgwqAgfCAxNiArKysrKysrKysrKysrKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMuaMKgwqDCoCB8wqAgMSArDQo+ID4gwqBpbmNsdWRlL2t2bS9hcm1fdmdpYy5owqDCoMKgwqDC
oMKgwqAgfMKgIDEgKw0KPiA+IMKgNCBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRpb25zKCspDQo+
ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4g
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IDJmYjJkYjIzZWQzOWEu
LjIyNTU4MDgwNzExZWIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IEBAIC01
NCw2ICs1NCwyOCBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZv
DQo+ID4gKmluZm8pDQo+ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArLyoN
Cj4gPiArICogU2V0cy9jbGVhcnMgdGhlIGNvcnJlc3BvbmRpbmcgYml0IGluIHRoZSBJQ0hfUFBJ
X0RWSVIgcmVnaXN0ZXIuDQo+ID4gKyAqLw0KPiA+ICtpbnQgdmdpY192NV9zZXRfcHBpX2R2aShz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBpcnEsIGJvb2wgZHZpKQ0KPiA+ICt7DQo+ID4gKwlz
dHJ1Y3QgdmdpY192NV9jcHVfaWYgKmNwdV9pZiA9ICZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNfY3B1
LnZnaWNfdjU7DQo+ID4gKwl1MzIgcHBpID0gRklFTERfR0VUKEdJQ1Y1X0hXSVJRX0lELCBpcnEp
Ow0KPiA+ICsNCj4gPiArCWlmIChwcGkgPj0gMTI4KQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0K
PiANCj4gU3VyZWx5IHRoaXMgaXMgYmFkLiAqdmVyeSogYmFkLiBIb3cgY2FuIHdlIGdldCBoZXJl
IHRoZSBmaXJzdCBwbGFjZT8NCg0KWWVhaCwgdGhpcyB3b3VsZCBhYnNvbHV0ZWx5IGJlIGJhZC4g
SSBkb24ndCBiZWxpZXZlIHRoYXQgd2UgY2FuIGV2ZW4NCmhpdCB0aGlzIGFueW1vcmUsIHNvIEkn
dmUgZHJvcHBlZCBpdC4NCg0KPiANCj4gPiArDQo+ID4gKwlpZiAoZHZpKSB7DQo+ID4gKwkJLyog
U2V0IHRoZSBiaXQgKi8NCj4gPiArCQljcHVfaWYtPnZnaWNfcHBpX2R2aXJbcHBpIC8gNjRdIHw9
IDFVTCA8PCAocHBpICUNCj4gPiA2NCk7DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCS8qIENsZWFy
IHRoZSBiaXQgKi8NCj4gPiArCQljcHVfaWYtPnZnaWNfcHBpX2R2aXJbcHBpIC8gNjRdICY9IH4o
MVVMIDw8IChwcGkgJQ0KPiA+IDY0KSk7DQo+ID4gKwl9DQo+IA0KPiBUaGlzIHNob3VsZCBiZSBz
aW1wbGlmaWVkOg0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12
NS5jDQo+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gaW5kZXggZDc0Y2MzNTQz
YjlhNC4uZjQzNGVlODVmN2UxYSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLXY1LmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gQEAgLTE5
MSw4ICsxOTEsOCBAQCBib29sIHZnaWNfdjVfcHBpX3NldF9wZW5kaW5nX3N0YXRlKHN0cnVjdA0K
PiBrdm1fdmNwdSAqdmNwdSwNCj4gwqAJCQkJwqDCoCBzdHJ1Y3QgdmdpY19pcnEgKmlycSkNCj4g
wqB7DQo+IMKgCXN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmOw0KPiAtCWNvbnN0IHUzMiBp
ZF9iaXQgPSBCSVRfVUxMKGlycS0+aW50aWQgJSA2NCk7DQo+IMKgCWNvbnN0IHUzMiByZWcgPSBG
SUVMRF9HRVQoR0lDVjVfSFdJUlFfSUQsIGlycS0+aW50aWQpIC8gNjQ7DQo+ICsJdW5zaWduZWQg
bG9uZyAqcDsNCj4gwqANCj4gwqAJaWYgKCF2Y3B1IHx8ICFpcnEpDQo+IMKgCQlyZXR1cm4gZmFs
c2U7DQo+IEBAIC0yMDMsMTAgKzIwMyw4IEBAIGJvb2wgdmdpY192NV9wcGlfc2V0X3BlbmRpbmdf
c3RhdGUoc3RydWN0DQo+IGt2bV92Y3B1ICp2Y3B1LA0KPiDCoA0KPiDCoAljcHVfaWYgPSAmdmNw
dS0+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiDCoA0KPiAtCWlmIChpcnFfaXNfcGVuZGluZyhp
cnEpKQ0KPiAtCQljcHVfaWYtPnZnaWNfcHBpX3BlbmRyW3JlZ10gfD0gaWRfYml0Ow0KPiAtCWVs
c2UNCj4gLQkJY3B1X2lmLT52Z2ljX3BwaV9wZW5kcltyZWddICY9IH5pZF9iaXQ7DQo+ICsJcCA9
ICh1bnNpZ25lZCBsb25nICopJmNwdV9pZi0+dmdpY19wcGlfcGVuZHJbcmVnXTsNCj4gKwlfX2Fz
c2lnbl9iaXQoaXJxLT5pbnRpZCAlIDY0LCBwLCBpcnFfaXNfcGVuZGluZyhpcnEpKTsNCj4gwqAN
Cj4gwqAJcmV0dXJuIHRydWU7DQo+IMKgfQ0KDQpJJ3ZlIG1hZGUgdGhpcyBjaGFuZ2UgaW4gdGhl
IGNvcnJlc3BvbmRpbmcgY29tbWl0IChpbXBsIFBQSSBpbmplY3Rpb24pDQotIHRoYW5rcy4NCg0K
PiBAQCAtNDQ5LDE3ICs0NDcsMTMgQEAgaW50IHZnaWNfdjVfc2V0X3BwaV9kdmkoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LA0KPiB1MzIgaXJxLCBib29sIGR2aSkNCj4gwqB7DQo+IMKgCXN0cnVjdCB2
Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0gJnZjcHUtDQo+ID5hcmNoLnZnaWNfY3B1LnZnaWNfdjU7
DQo+IMKgCXUzMiBwcGkgPSBGSUVMRF9HRVQoR0lDVjVfSFdJUlFfSUQsIGlycSk7DQo+ICsJdW5z
aWduZWQgbG9uZyAqcDsNCj4gwqANCj4gwqAJaWYgKHBwaSA+PSAxMjgpDQo+IMKgCQlyZXR1cm4g
LUVJTlZBTDsNCj4gwqANCj4gLQlpZiAoZHZpKSB7DQo+IC0JCS8qIFNldCB0aGUgYml0ICovDQo+
IC0JCWNwdV9pZi0+dmdpY19wcGlfZHZpcltwcGkgLyA2NF0gfD0gMVVMIDw8IChwcGkgJQ0KPiA2
NCk7DQo+IC0JfSBlbHNlIHsNCj4gLQkJLyogQ2xlYXIgdGhlIGJpdCAqLw0KPiAtCQljcHVfaWYt
PnZnaWNfcHBpX2R2aXJbcHBpIC8gNjRdICY9IH4oMVVMIDw8IChwcGkgJQ0KPiA2NCkpOw0KPiAt
CX0NCj4gKwlwID0gKHVuc2lnbmVkIGxvbmcgKikmY3B1X2lmLT52Z2ljX3BwaV9kdmlyW3BwaSAv
IDY0XTsNCj4gKwlfX2Fzc2lnbl9iaXQocHBpICUgNjQsIHAsIGR2aSk7DQo+IMKgDQo+IMKgCXJl
dHVybiAwOw0KPiDCoH0NCj4gDQo+ICh5ZXMsIHVuc2lnbmVkIGxvbmcgYW5kIHU2NCBhcmUgdGhl
IHNhbWUgdGhpbmcgb24gYW55IHNhbmUNCj4gYXJjaGl0ZWN0dXJlKS4NCg0KRG9uZSwgdGhhbmtz
IQ0KDQo+IA0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+IMKgdm9p
ZCB2Z2ljX3Y1X2xvYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgew0KPiA+IMKgCXN0
cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0gJnZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUu
dmdpY192NTsNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4g
PiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gaW5kZXggMTAwNWZmNWYzNjIzNS4u
MWZlM2RjYzk5Nzg2MCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMu
Yw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gQEAgLTU3NywxMiAr
NTc3LDI4IEBAIHN0YXRpYyBpbnQga3ZtX3ZnaWNfbWFwX2lycShzdHJ1Y3Qga3ZtX3ZjcHUNCj4g
PiAqdmNwdSwgc3RydWN0IHZnaWNfaXJxICppcnEsDQo+ID4gwqAJaXJxLT5ob3N0X2lycSA9IGhv
c3RfaXJxOw0KPiA+IMKgCWlycS0+aHdpbnRpZCA9IGRhdGEtPmh3aXJxOw0KPiA+IMKgCWlycS0+
b3BzID0gb3BzOw0KPiA+ICsNCj4gPiArCWlmICh2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpIHsNCj4g
PiArCQkvKiBOb3RoaW5nIGZvciB1cyB0byBkbyAqLw0KPiA+ICsJCWlmICghaXJxX2lzX3BwaV92
NShpcnEtPmludGlkKSkNCj4gPiArCQkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJCWlmIChGSUVM
RF9HRVQoR0lDVjVfSFdJUlFfSUQsIGlycS0+aW50aWQpID09IGlycS0NCj4gPiA+aHdpbnRpZCkg
ew0KPiA+ICsJCQlpZiAoIXZnaWNfdjVfc2V0X3BwaV9kdmkodmNwdSwgaXJxLQ0KPiA+ID5od2lu
dGlkLCB0cnVlKSkNCj4gPiArCQkJCWlycS0+ZGlyZWN0bHlfaW5qZWN0ZWQgPSB0cnVlOw0KPiAN
Cj4gVGhlIGVycm9yIGhhbmRsaW5nIGdpdmVzIG1lIHRoZSBjcmVlcHMuIElmIHdlIGNhbiBlbmQt
dXAgYXQgdGhpcw0KPiBzdGFnZQ0KPiB3aXRoIHRoZSB3cm9uZyBJTlRJRCwgd2UncmUgc2NyZXdl
ZC4NCg0KWWVhaCwgdmFsaWQgcG9pbnQsIGl0IHdvdWxkIGluZGVlZCBiZSByYXRoZXIgYnJva2Vu
IGlmIHdlIGV2ZXIgbWFkZSBpdA0KaGVyZS4gSSd2ZSBkcm9wcGVkIHRoaXMgY2hlY2sgYXMgSSBk
b24ndCB0aGluayBpdCBhY3R1YWxseSBtYWtlcyBzZW5zZQ0KYW55bW9yZSBhbnlob3cuDQoNClRo
aXMgaXMgdXNlZCBmb3IgdGhlIGFyY2ggdGltZXIuIEZvciBhIG5vbi1uZXN0ZWQgZ3Vlc3QsIHRo
ZXJlIHNob3VsZA0KYmUgYSAxOjEgcmVsYXRpb25zaGlwIGJldHdlZW4gdGhlIGhvc3QgYW5kIGd1
ZXN0IHRpbWVyIFBQSXMuIElmIHRoYXQNCmlzbid0IHRoZSBjYXNlLCB0aGUgYXJjaCB0aW1lciBj
b2RlIGhhcyBnb25lIGF3cnkgYnkgbm90IHVzaW5nIHRoZQ0KYXJjaGl0ZWN0ZWQgSUQuIEZvciBh
IG5lc3RlZCBndWVzdCwgdGhlcmUncyBhY3R1YWxseSBhbiBleHBsaWNpdCBQUEkgSUQNCmNoYW5n
ZSAoZS5nLiBob3N0IFBQSSAyOCBpcyBkaXJlY3RseSBpbmplY3RlZCBhcyB2aXJ0dWFsIFBQSSAy
OCkgd2hpY2gNCndvdWxkIGluY29ycmVjdGx5IGZhaWwgdGhpcyBjaGVjay4NCg0KVGhhbmtzLA0K
U2FzY2hhDQoNCj4gDQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiA+ICsNCj4gPiDCoAlyZXR1cm4gMDsN
Cj4gPiDCoH0NCj4gPiDCoA0KPiA+IMKgLyogQGlycS0+aXJxX2xvY2sgbXVzdCBiZSBoZWxkICov
DQo+ID4gwqBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX3ZnaWNfdW5tYXBfaXJxKHN0cnVjdCB2Z2lj
X2lycSAqaXJxKQ0KPiA+IMKgew0KPiA+ICsJaWYgKGlycS0+ZGlyZWN0bHlfaW5qZWN0ZWQgJiYg
dmdpY19pc192NShpcnEtPnRhcmdldF92Y3B1LQ0KPiA+ID5rdm0pKQ0KPiA+ICsJCVdBUk5fT04o
dmdpY192NV9zZXRfcHBpX2R2aShpcnEtPnRhcmdldF92Y3B1LCBpcnEtDQo+ID4gPmh3aW50aWQs
IGZhbHNlKSk7DQo+ID4gKw0KPiA+ICsJaXJxLT5kaXJlY3RseV9pbmplY3RlZCA9IGZhbHNlOw0K
PiA+IMKgCWlycS0+aHcgPSBmYWxzZTsNCj4gPiDCoAlpcnEtPmh3aW50aWQgPSAwOw0KPiA+IMKg
CWlycS0+b3BzID0gTlVMTDsNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLmgNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oDQo+ID4gaW5kZXggNmUxZjM4
NmRmZmFkZS4uYjZlM2Y1ZTNhYmExOCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMuaA0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oDQo+ID4gQEAg
LTM2Myw2ICszNjMsNyBAQCB2b2lkIHZnaWNfZGVidWdfaW5pdChzdHJ1Y3Qga3ZtICprdm0pOw0K
PiA+IMKgdm9pZCB2Z2ljX2RlYnVnX2Rlc3Ryb3koc3RydWN0IGt2bSAqa3ZtKTsNCj4gPiDCoA0K
PiA+IMKgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0IGdpY19rdm1faW5mbyAqaW5mbyk7
DQo+ID4gK2ludCB2Z2ljX3Y1X3NldF9wcGlfZHZpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMy
IGlycSwgYm9vbCBkdmkpOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X2xvYWQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KTsNCj4gPiDCoHZvaWQgdmdpY192NV9wdXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsN
Cj4gPiDCoHZvaWQgdmdpY192NV9zZXRfdm1jcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVj
dCB2Z2ljX3ZtY3INCj4gPiAqdm1jcik7DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUva3ZtL2Fy
bV92Z2ljLmggYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQo+ID4gaW5kZXggNDVkODNmNDViMDY1
ZC4uY2U5ZTE0OWI4NWE1OCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5o
DQo+ID4gKysrIGIvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaA0KPiA+IEBAIC0xNjMsNiArMTYzLDcg
QEAgc3RydWN0IHZnaWNfaXJxIHsNCj4gPiDCoAlib29sIGVuYWJsZWQ6MTsNCj4gPiDCoAlib29s
IGFjdGl2ZToxOw0KPiA+IMKgCWJvb2wgaHc6MTsJCQkvKiBUaWVkIHRvIEhXIElSUSAqLw0KPiA+
ICsJYm9vbCBkaXJlY3RseV9pbmplY3RlZDoxOwkvKiBBIGRpcmVjdGx5IGluamVjdGVkIEhXDQo+
ID4gSVJRICovDQo+ID4gwqAJYm9vbCBvbl9scjoxOwkJCS8qIFByZXNlbnQgaW4gYSBDUFUgTFIg
Ki8NCj4gPiDCoAlyZWZjb3VudF90IHJlZmNvdW50OwkJLyogVXNlZCBmb3IgTFBJcyAqLw0KPiA+
IMKgCXUzMiBod2ludGlkOwkJCS8qIEhXIElOVElEIG51bWJlciAqLw0KPiANCj4gVGhhbmtzLA0K
PiANCj4gCU0uDQo+IA0KDQo=

