Return-Path: <kvm+bounces-67215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E8188CFD48C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 11:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D3623301411D
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 10:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B03242D95;
	Wed,  7 Jan 2026 10:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KyMR56KW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KyMR56KW"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011054.outbound.protection.outlook.com [40.107.130.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E83C238C3B
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767783400; cv=fail; b=VTJD2D36O3nAOvRvs/jk3Timr/XSGo/m/JyHHGTq4QT4d/ktNDNfB4Skuc/GZoXEdksIayyXeUFLK3N4atHPZxgRMj/xwRLzHCta5bJ4absW8ZRA6fIwfeLffxZvhoS4sMWbp+38HF5VTG1wvW9r4qBUV3KdMdWUyzatCRPIOlM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767783400; c=relaxed/simple;
	bh=tK01K2w6AiRcM2Bg8+tgLGD/iKpkRnC2P7W6YaHZT8E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tFG94/mrVHM0IYJM2h/hGa8CKbzJfJqp3lE98iUqvJABkque6xQX+8Gq2f1cVt50DY9H7xpc8DdgFhVnUXj+9mJzNDiDKaTlKO/yNZdFC+bdHTh4YJr8+zPVufN9uBFLpWaYaV8x92KJgapnFTfMi5DGDJIXZFfM/xDdlzI1RDQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KyMR56KW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KyMR56KW; arc=fail smtp.client-ip=40.107.130.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JD1nXVDMSfXP5Ts2TyjxQJqaFPii0HwAvZ+1mDB8aku+P7mn65rm3fXXVIrfD5hREg4KaS5DnfHv4naCQZAquF2YkpZ1GIkxmp5JEhFm+pdefnP2DBDSfAOYIQzN6CO4oUxc4IEPRIgEOMrtSqFah05pBnRBQrU0Dh2hnHwcb30zVVN2mpTucROOk2LMpebyYSa2UPEM8eeL0+urSZtMUISvYySFqM0FXHx4nzkHfc2RqL4ow+RxXctKu8oZaH1L2atND9SBFEdq2QavaatPDorcQexTC2ma9TSXGDUq6LpB1FoH6zNr5Z3GEj7FrLTVLlfKIUI9pMu4ZIwVHamBbQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tK01K2w6AiRcM2Bg8+tgLGD/iKpkRnC2P7W6YaHZT8E=;
 b=J6JV0gjYgSeQfwG+VHiWpY8IHnnx+rPqQIlSfncBNWTiODnaJqcQ1ryLPbuiQkLAtummqJkTRBWa3DpJeLGR8huGIGoXRVmPhUJbaQnY5bkybmu0Wz2iYzCnxvLU7fGxiK0Wx5TPBvh98hZGT0rkvqq2ipytcQRprUpnVpm5zXDYURRa+29+Z1DjH3vgFHG98lS5dlHpl1WDEGW7mAIk80ZjqyxK95zi5kXwLcQuD2o1axYgHLXLEsAtsoJlAPE6LZryXnggmlvTA1xc7OG6dNKahIQXnAlusuG2jBmAly+TB2WzZL+fC82yUcCXypzkSkVACED6VS+ombydB8y8Xg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tK01K2w6AiRcM2Bg8+tgLGD/iKpkRnC2P7W6YaHZT8E=;
 b=KyMR56KW5r1MYHfKTkf3PyoNcF7ZUtMFDD68kMiKm09MMCeBTcpafAOUT5CWSki6I5T7bt3dE0V5kwKiVTHjAZETuW2vIMD/Byg5Wc+yKzgG2vp/tiDaByGMSFxnokQEgjrtY40UC85oTW8Wxua/wuCc7FrGKutlD8s7mKeEDho=
Received: from CWLP123CA0187.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19c::6)
 by DB9PR08MB9729.eurprd08.prod.outlook.com (2603:10a6:10:45c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 10:56:28 +0000
Received: from AMS1EPF0000004E.eurprd04.prod.outlook.com
 (2603:10a6:400:19c:cafe::76) by CWLP123CA0187.outlook.office365.com
 (2603:10a6:400:19c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.6 via Frontend Transport; Wed, 7
 Jan 2026 10:56:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004E.mail.protection.outlook.com (10.167.16.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1
 via Frontend Transport; Wed, 7 Jan 2026 10:56:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eR9YVq9sX+RqiU3VFI3ph8Oz9O2MXaL2Fg5CoXaBRKRagQJpGEj/DZVyj3gsRkabZH/+d7v7JyRpgfGKZGrtTVOlQ5DFh9kWwtC8AqrFEluBO8glekB6eJMkcN2hU24cciDA9B6+198wxzejqiXyyPYoppL17itVz5UhywZSkUzbG89UlB3Fo+rOJzKzeFfqox/UHHMBhcrY0fyCPN/MeUe3bbPzURhDnshnDcsdIe5i39ZmlrAGYoW817FAbydwf4nNNM122A7gxqAwqhqX41vgEpIUlv5AKaD44nuMuLhDJsARyQAHOFlrJC/y7U/wDsWSHuvekYJ8h/UuacKrSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tK01K2w6AiRcM2Bg8+tgLGD/iKpkRnC2P7W6YaHZT8E=;
 b=C5gLOAfBgclP02FZOltpGvXl1zttDMKB85fGEpPcUDK2bDUqTAGUwvVMxlvZxY+aVYBdqid4R9/WyEaB6h6gdiWNM08sq+mvBUCFhl9XTOVBu2Eoq1d/wwVbupv6yAy58jfRkpPLqiBdKI8wGk6PpwPAs5lzVP5+N/wOPUsscKpdkc8cvyOO+z2FwO4u2boRBuaA/cAkgRAp1mEhq5zrx6XKSN2h2mbSGAATWU4BlEwVtFze/9FGBRl2h40UPFLD8HT4bC+sm43frrRsxe4Gk2hibx3qRO2GP5ylfsn39bqr8KpMq2NTrI3OPP6bOdXb8IBxpdUp7PU8WfQ6j36e7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tK01K2w6AiRcM2Bg8+tgLGD/iKpkRnC2P7W6YaHZT8E=;
 b=KyMR56KW5r1MYHfKTkf3PyoNcF7ZUtMFDD68kMiKm09MMCeBTcpafAOUT5CWSki6I5T7bt3dE0V5kwKiVTHjAZETuW2vIMD/Byg5Wc+yKzgG2vp/tiDaByGMSFxnokQEgjrtY40UC85oTW8Wxua/wuCc7FrGKutlD8s7mKeEDho=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV1PR08MB8665.eurprd08.prod.outlook.com (2603:10a6:150:82::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Wed, 7 Jan
 2026 10:55:18 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 10:55:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Topic: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHccP9/cRjaE9ujSUGgGwLBe3eVgLVFiqcAgAEbkYA=
Date: Wed, 7 Jan 2026 10:55:18 +0000
Message-ID: <cdef264835c24f1e2155cadd5a414fb34d06bca3.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-3-sascha.bischoff@arm.com>
	 <20260106180022.00006dcd@huawei.com>
In-Reply-To: <20260106180022.00006dcd@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV1PR08MB8665:EE_|AMS1EPF0000004E:EE_|DB9PR08MB9729:EE_
X-MS-Office365-Filtering-Correlation-Id: 8965dccd-ad34-47c0-61ec-08de4ddb68c0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SHU1c3N3NTBqNDJWcGFudE5MMndXdHB0dXkxYzJPUTc5TFVEWEpjdk9Ua3Zi?=
 =?utf-8?B?Z3lxc1k0aHNnenFRNlVBZ3ZoL2VkTFl2cElrajJTWTBKMkllQWJLUHNlQXJl?=
 =?utf-8?B?aXZmK1FvajF3RExQUGErNno0MnBSUnEyU0wxejNpdmM0R2VFejJEV1UzWVRw?=
 =?utf-8?B?S0doY2h5QTE1Lzc5MFpBSDI3RExMSGdOdThSaXBkSEdPdlI2VTRFd0VNamVL?=
 =?utf-8?B?bStORVhlZFFJZk53eE1ER2V1YkdkU0lneE1SU0g2NHVlblNjVUtMWGhUMzhS?=
 =?utf-8?B?UktvZ2gvbHhUcVlCM1lOaDlOZk1GUXFtVXBkVDdDY0pwbHp4eFpPZ3pTS3lv?=
 =?utf-8?B?K3dvNUFheEpNZVQ5NnZWVThrVjN3NzdYNnZYbUIrVEMrRzlKYk9sRnl4QlE4?=
 =?utf-8?B?NlRDa25Pd3lTb01PS3FoQmEvSDRTZDI1OUJ0SzlGRlZ2WGJicDhEZmt3ekxl?=
 =?utf-8?B?RUNOMlFNZExWMnphYlh1UUZIUW5BRkIyM1ZEQnhBWVJSMlVIWEQrMzdVNkMr?=
 =?utf-8?B?V3VEK1IrV2Y5ajA3NDl2WXpBSDBxOGpMenh2czVPaHpqT0w4ZHExRUZnY1Br?=
 =?utf-8?B?NDI0dkFhVGMrTm54dWtiQ3JmYVpHSC8wTG9VSXd3aHJ2Y01xZVF5UDhRNDdF?=
 =?utf-8?B?S0R3Z21lOUxKcWNseXFjYjBZWFBleXQ0TUlLU0c5aXF2QjdnUCtvdmRhVFc4?=
 =?utf-8?B?SUNablR6aVZ2cUZKSi9pdlZTRkJ4Tk9YTkZWWkxjckxzVHhGN0hUaERNeUZM?=
 =?utf-8?B?YTUxZFdjRXlVOStLVUtrRzJGRGJpNE92UzFXV2lPY0s5azVTWGs0MGJ1WmhE?=
 =?utf-8?B?UzVNTWIydlB5a20vOS9tTTUxdk0zT3BnRStkcmovTEVUV051SVdYcEJyb2sz?=
 =?utf-8?B?UWJLRW5pa1h2MDRoRVRKMUI0bnJ3elZyL3plMDdYRHplMnFrRWF3dUlLVnZv?=
 =?utf-8?B?S3dwbE9sVDFLUHFhQnQ0dzNOdFpMYmd0U2w0YTQ3dWg2TkRPSzhZUTZjZGNX?=
 =?utf-8?B?aGVCRm1lL1JDeDZhRmE0WGdCdk1CUG12eUNaVHhnVzZJQTBnNnBseTIrZE1G?=
 =?utf-8?B?ODhJS1VlNnRRQXg4Z3JqZlQ3SmMySjhqM3BIM1N1OVRqN3h2Q0FEZlV4Nlla?=
 =?utf-8?B?dHZ3SnUvTnFlSmlkU2gyKzdvcXBybVdUWmJsamRnMi9OMXQ1OXIyeUJmNm5I?=
 =?utf-8?B?TjJ0U0Ivck9PdEoxOS9qdVNWM3c3YUxRaTFKbHpOS3N5SVNIZlgvSHQ0NlJW?=
 =?utf-8?B?MzNMUEVrSFB5Y2gyS09abUhnS2p0NjNOa25qSjRWYTdMeEZMZXFFL2FxNm9M?=
 =?utf-8?B?N2FOOUNQa1B3djdXRkdQOFlhNGxQRXdOVjdiR3lCV3VSTnlwNW5ud2hhVXFT?=
 =?utf-8?B?aE9FY0NPR0xVRGtSWXZ4anpYd2Z2TXFhUjhrU0s0allQd1BQSS9JK0xxUnpJ?=
 =?utf-8?B?Yk43N004WHl0bVV6d21qTWN3Wmp0SVRidlV5d21wL2l4VTZPVUs3ZGExVGVK?=
 =?utf-8?B?VzZoanNyYWc2S2h0OEUrVXpseUNyRkozWmpRbk9MY3ROSjVsQlJLWHlISG53?=
 =?utf-8?B?VzFZNWhHNmg2SlQwenJxSEh3YmduUHJvZDh2VWdFeFUxMmVuZmR4ejRSamU4?=
 =?utf-8?B?NzMzVTVFZWpEN3ErVzR0VW5lN29vdmtTMFVONG5ndzYrNlJOTlFUNGZMemFo?=
 =?utf-8?B?bDFka2RQdnI2MjI5Z01CK1Zpdk8wL2tGNXlzUTVOMXc4eVlsZW1mVkhkUlB4?=
 =?utf-8?B?V0FkanJOL2ZKQ1Z0aktXaCtqSjIwbHk1SEp4TTY5Ykp0bmFZN3BBeUZKV2hO?=
 =?utf-8?B?UGxQTWM4WEJNRlJqRFhwVjJZTGxGTzZSZVY1d0RIcVJNWnhPbmNVMkoyQThB?=
 =?utf-8?B?NlFScFdRdkE4Wk8yK0xrN1M2Y3RKNnFIZzNIaWpjR3RzQTc5MWRGUitNQ1B5?=
 =?utf-8?B?NWlFUnJzMHlkQlAveHlzclNKbFRoRENpejNZaEMyaFNFOURYcjk0U3F1Tlg1?=
 =?utf-8?B?TkVtbnhpeEpvN1YyTEpEaHdLYm1Qd2FDUUxpQVMxcER6d3pyU1pianZVeGlD?=
 =?utf-8?Q?q1emge?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EF825192632594193802EF7FB915747@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8665
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	49a76608-55e1-4287-56d2-08de4ddb3f01
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|35042699022|14060799003|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkFTTjNWdVNQMzJtNXFQazN6d1hvcnRxeVBwSnNMa2RRWTlxNHpXdWNRYXlH?=
 =?utf-8?B?RVN3eDRvYVBORjRQamRyNVNHS1didUxWWjJ4dElXOHlZaGx1N0xTMzNaWGJF?=
 =?utf-8?B?RTVsUEM0ekNUZXJJUGsrQ2lFbnlSckpMb0Vua1FrYzN6cHlvZUVUQ2F1dnRC?=
 =?utf-8?B?YkRNbktjaG01ZHpLdS80VkdYTS9kZ0FDRS9qVlNhbTNyejUvdWdpcVNldWR4?=
 =?utf-8?B?OHpHdUZQeWw2L2dDVzhINC9id2RvZHovaGZRWmZRWEs5K0VEcXBWRnhaL0t2?=
 =?utf-8?B?c3E5dWdwbVZXSWFTSkdpM0xZaERTK2NXWk1hUkdPVlUrUHMwSGljMDRyVDZW?=
 =?utf-8?B?SElyREo0ZUdMSHNZQXV4blBKWjNHbDF5aFhhTDkvRU1rNTcyRUJxWm1Fd09P?=
 =?utf-8?B?MnVxVWFTMkNOVEZLMkQ3ZXJTSWRUbkhiOUFjZ25jRFRHcHBsOFBKczByZ1Fz?=
 =?utf-8?B?V0FyY2VjanJtQ3BKQ3ZiOFU1cVVtQzR4elQ5OFdxaEJqcjBJdUtVZExldDNE?=
 =?utf-8?B?UGdQZ2trcnZxd09zRk5RU21EYzlQb2FmdDgvc09iNzJjNmtoQUJRUHhBNFEx?=
 =?utf-8?B?OVhQb3EyNzQzaVZzR05xanF0Q3l6L0xPUTRQK1JlR3dielVEaFVDTXAyRENU?=
 =?utf-8?B?WmZpdTRCaDdMVzdydDdOQjNHc2VoSGVZdXJ4K29ETVQzVmQzTmlNSHluQjJj?=
 =?utf-8?B?UHArN2w4anE0SEtWMktGeDhKRDRVcVp1aUc0ZnE2SCtVTk0yRi9xQ1FZaGJy?=
 =?utf-8?B?VlpxNnRXdEwxYWpCTWc0MlFBWTUwbzh3aFQ1Um5YdjJjbFNjc3IraW9lN0tM?=
 =?utf-8?B?R1JkbkxVd3BHYWZTZG56Z0luZDMwUCs0OGI5TXQ3a2ZEZkRqSFhBRzlmamlB?=
 =?utf-8?B?L0NHNE83aTcvOE5QM1VYUThUeFpDWG84QVpzQTF4c2pIS2lqSm5aYVZvSm10?=
 =?utf-8?B?bFRidTBBcU81WXJURnI5VDhUWlBBT3hzalJ0Ymthd3F2Z0FtSVcwU2VLN3cr?=
 =?utf-8?B?SVBQVXhwQ1FnRTZRSklNcFU5OWtYL1JkdjdibnhrbG1rYnVTK0s0MlUxMEsr?=
 =?utf-8?B?d05zeUR2anFVaisyZ2MwaWl4MUdtZDh4OWdMMUR3QlYydExrNTVYS1RYT2Jt?=
 =?utf-8?B?RURLV1lpSFg4eFFRWWdVOXVVOVYzNERzSUlvRklnR2IrQUQ5ZE14UmJBampl?=
 =?utf-8?B?SG9lVVFmWWFTeURFbE84OUUrSG1KeWpSdFVRYzFoUmdndUVQNFR2cGhEQXh2?=
 =?utf-8?B?OTg5YXNQZS8vZXRMcy9rWkRuUHpBdUZ1N2tTSmVQV1FaaHY2dU8wNzRhYzI3?=
 =?utf-8?B?dWhPdjdRZkFDVkw4bmpzbHljaEozVU5yR3Nvcmhjd0VISkZwNkdhbGljRzgv?=
 =?utf-8?B?N0VnSy84YW1PM0swVjYvYTc1bkpaQWUyYlpwSC91aDdJbXJ3OG9ST0tYU1pJ?=
 =?utf-8?B?VmExTXFad25DUHlPdklKbTRKSVNwbmtlWnY0dVY0UVF0cTZxbVgzUlIyd2t2?=
 =?utf-8?B?eHpXRE9nKzM5TUNYYXlmWFRyU01TYTJTUk01TER4bElwajlWWld4S2p4WEJ2?=
 =?utf-8?B?ay83NFczRUFUSjRuM2MyWDBKYU91MURRZk93K2did2tlRHVRMlZkaTh3allV?=
 =?utf-8?B?djBvZ3d5RUx2YlB0bGR0amorM0ZkdGk2SE4zSGFuYkNqNzVZTlJuMW5BUGI2?=
 =?utf-8?B?TngyamlhbjJQMlVjZFlrZDRBL1lERVFsRzgyaDVpUkJ5NmQ0SHNGL0xoZjRi?=
 =?utf-8?B?K1VnUDhjWCt1NFZjL0hQd2FaYng4emhFWkVNOWZLOTBBZkR0aDlUb1JlQXBQ?=
 =?utf-8?B?NytjcGhGSndOOW44ZmNpZ1BENGd2cFBZUVFVa0VqUXdnMUtldkpRUWluYkNH?=
 =?utf-8?B?dXpzcmNZcCt5TmZFWlZoaWZEclU1eUpLUFZlcVFEZnpJcnpHL2FFY3JWSE15?=
 =?utf-8?B?ZE1CUG9PZmFDWU1nd0l3Vm5NMEh1KzRWNnFqVXduSDVxR0Y5a2FvZGJnYUdK?=
 =?utf-8?B?RUIyZ1NjZzViV2JkUW0vTzBEWWZDN2dxVEcxd1hVQ01DT2NvMU9tTjRBeDRj?=
 =?utf-8?B?SGh2NUtKdnF2VHk2REt6Q3NtanA2bkpQV01OV2xZQk9iNC9qekRHMVBYWWVM?=
 =?utf-8?Q?+axo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(35042699022)(14060799003)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 10:56:28.2724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8965dccd-ad34-47c0-61ec-08de4ddb68c0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9729

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjAwICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM2ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBGcm9tOiBTYXNjaGEg
QmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiA+IA0KPiA+IFRoZSBWR0lDLXYz
IGNvZGUgcmVsaWVkIG9uIGhhbmQtd3JpdHRlbiBkZWZpbml0aW9ucyBmb3IgdGhlDQo+ID4gSUNI
X1ZNQ1JfRUwyIHJlZ2lzdGVyLiBUaGlzIHJlZ2lzdGVyLCBhbmQgdGhlIGFzc29jaWF0ZWQgZmll
bGRzLCBpcw0KPiA+IG5vdyBnZW5lcmF0ZWQgYXMgcGFydCBvZiB0aGUgc3lzcmVnIGZyYW1ld29y
ay4gTW92ZSB0byB1c2luZyB0aGUNCj4gPiBnZW5lcmF0ZWQgZGVmaW5pdGlvbnMgaW5zdGVhZCBv
ZiB0aGUgaGFuZC13cml0dGVuIG9uZXMuDQo+ID4gDQo+ID4gVGhlcmUgYXJlIG5vIGZ1bmN0aW9u
YWwgY2hhbmdlcyBhcyBwYXJ0IG9mIHRoaXMgY2hhbmdlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+IEhpIFNhc2No
YQ0KPiANCj4gSGFwcHkgbmV3IHllYXIuwqAgVGhlcmUgaXMgYSBiaXQgaW4gaGVyZSB0aGF0IGlz
bid0IG9idmlvdXNseSBnb2luZw0KPiB0byByZXN1bHQgaW4gbm8gZnVuY3Rpb25hbCBjaGFuZ2Uu
IEknbSB0b28gbGF6eSB0byBjaGFzZSB3aGVyZSB0aGUNCj4gdmFsdWUNCj4gZ29lcyB0byBjaGVj
ayBpdCBpdCdzIGEgcmVhbCBidWcgb3Igbm90Lg0KPiANCj4gT3RoZXJ3aXNlIHRoaXMgaXMgaW5j
b25zaXN0ZW50IG9uIHdoZXRoZXIgdGhlIF9NQVNLIG9yIGRlZmluZSB3aXRob3V0DQo+IGl0IGZy
b20gdGhlIHN5c3JlZyBnZW5lcmF0ZWQgaGVhZGVyIGlzIHVzZWQgaW4gRklFTERfR0VUKCkgLw0K
PiBGSUVMRF9QUkVQKCkNCj4gDQo+IEknZCBhbHdheXMgdXNlIHRoZSBfTUFTSyB2ZXJzaW9uLg0K
DQpIaSBKb25hdGhhbiwNCg0KSSd2ZSB1cGRhdGVkIHRoZSBjb2RlIHRvIHVzZSB0aGUgX01BU0sg
dmVyc2lvbi4NCg0KPiANCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lz
cmVnLmjCoMKgwqDCoMKgIHwgMjEgLS0tLS0tLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS9oeXAv
dmdpYy12My1zci5jwqDCoMKgwqDCoCB8IDY0ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLQ0KPiA+
IC0tLS0NCj4gPiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My1uZXN0ZWQuYyB8wqAgOCAr
Ky0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuY8KgwqDCoMKgwqDCoMKgIHwg
NDggKysrKysrKysrKy0tLS0tLS0tLS0tDQo+ID4gwqA0IGZpbGVzIGNoYW5nZWQsIDU0IGluc2Vy
dGlvbnMoKyksIDg3IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oDQo+ID4gYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5
c3JlZy5oDQo+ID4gaW5kZXggOWRmNTFhY2NiYjAyNS4uYjNiOGI4Y2Q3YmYxZSAxMDA2NDQNCj4g
PiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oDQo+ID4gKysrIGIvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0KPiANCj4gDQo+ID4gQEAgLTg2NSwxMiArODY1LDEy
IEBAIHN0YXRpYyB2b2lkIF9fdmdpY192M193cml0ZV9lb2lyKHN0cnVjdA0KPiA+IGt2bV92Y3B1
ICp2Y3B1LCB1MzIgdm1jciwgaW50IHJ0KQ0KPiA+IMKgDQo+ID4gwqBzdGF0aWMgdm9pZCBfX3Zn
aWNfdjNfcmVhZF9pZ3JwZW4wKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyDQo+ID4gdm1jciwg
aW50IHJ0KQ0KPiA+IMKgew0KPiA+IC0JdmNwdV9zZXRfcmVnKHZjcHUsIHJ0LCAhISh2bWNyICYg
SUNIX1ZNQ1JfRU5HMF9NQVNLKSk7DQo+ID4gKwl2Y3B1X3NldF9yZWcodmNwdSwgcnQsIHZtY3Ig
JiBJQ0hfVk1DUl9FTDJfVkVORzBfTUFTSyk7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiDCoHN0YXRp
YyB2b2lkIF9fdmdpY192M19yZWFkX2lncnBlbjEoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIN
Cj4gPiB2bWNyLCBpbnQgcnQpDQo+ID4gwqB7DQo+ID4gLQl2Y3B1X3NldF9yZWcodmNwdSwgcnQs
ICEhKHZtY3IgJiBJQ0hfVk1DUl9FTkcxX01BU0spKTsNCj4gPiArCXZjcHVfc2V0X3JlZyh2Y3B1
LCBydCwgdm1jciAmIElDSF9WTUNSX0VMMl9WRU5HMV9NQVNLKTsNCj4gDQo+IEl0J3MgbW9yZSB0
aGFuIHBvc3NpYmxlIGl0IGRvZXNuJ3QgbWF0dGVyLCBidXQgdGhpcyBpc24ndA0KPiBmdW5jdGlv
bmFsbHkNCj4gZXF1aXZhbGVudC4NCj4gVGhlIG9yaWdpbmFsIHNldCBwYXNzZWQgMSBhcyB0aGUg
dmFsIHBhcmFtZXRlciB0byB2Y3B1X3NldF9yZWcoKSwgYW5kDQo+IG5vdyBpdCBwYXNzZXMgMi4N
Cj4gDQo+IEdpdmVuIHRoZXNlIGRvbid0IHRha2UgYSBib29sIEknZCB1c2UgRklFTERfR0VUKCkg
Zm9yIGJvdGggdGhpcyBhbmQNCj4gdGhlIHZlbmcwIG9uZSBhYm92ZS4NCj4gT3IgcHV0IGJhY2sg
dGhlIGhvcnJpYmxlICEhDQoNCkFoLCB0aGF0J3MgYSBnb29kIGNhdGNoLCBhbmQgbWlnaHQgd2Vs
bCBiZSBhbiB1bmludGVuZGVkIGZ1bmN0aW9uYWwNCmNoYW5nZSBsb29raW5nIGludG8gaXQuIEkn
dmUgc3dpdGNoZWQgdG8gdXNpbmcgRklFTERfR0VUKCkgZm9yIGJvdGguDQoNCj4gDQo+ID4gwqB9
DQo+IA0KPiA+IEBAIC05MTYsMTAgKzkxNiw4IEBAIHN0YXRpYyB2b2lkIF9fdmdpY192M193cml0
ZV9icHIwKHN0cnVjdA0KPiA+IGt2bV92Y3B1ICp2Y3B1LCB1MzIgdm1jciwgaW50IHJ0KQ0KPiA+
IMKgCWlmICh2YWwgPCBicHJfbWluKQ0KPiA+IMKgCQl2YWwgPSBicHJfbWluOw0KPiA+IMKgDQo+
ID4gLQl2YWwgPDw9IElDSF9WTUNSX0JQUjBfU0hJRlQ7DQo+ID4gLQl2YWwgJj0gSUNIX1ZNQ1Jf
QlBSMF9NQVNLOw0KPiA+IC0Jdm1jciAmPSB+SUNIX1ZNQ1JfQlBSMF9NQVNLOw0KPiA+IC0Jdm1j
ciB8PSB2YWw7DQo+ID4gKwl2bWNyICY9IH5JQ0hfVk1DUl9FTDJfVkJQUjBfTUFTSzsNCj4gPiAr
CXZtY3IgfD0gRklFTERfUFJFUChJQ0hfVk1DUl9FTDJfVkJQUjAsIHZhbCk7DQo+IA0KPiBZb3Ug
Y291bGQgdXNlcyBGSUVMRF9NT0RJRlkoKSB0aG91Z2ggdGhhdCB3b3VsZCBtZWFuIHVzaW5nIHRo
ZSBfTUFTSw0KPiBkZWZpbmUgZm9yIGJvdGggcGxhY2VzLsKgIE5vdCBzdXJlIHdoeSB0aGUgc3lz
cmVnIHNjcmlwdCBnZW5lcmF0ZXMNCj4gYm90aA0KPiAoYWx3YXlzIGhhdmUgc2FtZSBhY3R1YWwg
dmFsdWUpLiBJIGd1ZXNzIHRoZSBpZGVhIGlzIGl0IGlzIGEgbGl0dGxlDQo+IHNob3J0ZXIgaWYg
eW91IGRvbid0IHdhbnQgdG8gYmUgZXhwbGljaXQgdGhhdCB0aGUgaW50ZW50IGlzIHRvIHVzZSBp
dA0KPiBhcyBhIG1hc2suDQo+IA0KPiBJJ2QganVzdCB1c2UgdGhlIF9NQVNLIGRlZmluZXMgdGhy
b3VnaG91dCByYXRoZXIgdGhhbiB0cnlpbmcgZm9yDQo+IGFub3RoZXINCj4gY29uc2lzdGVudCBz
Y2hlbWUuIA0KDQpGSUVMRF9NT0RJRlkoKSBpcyBhIGdyZWF0IHNob3V0IGhlcmUuIERvbmUgJiB0
aGFua3MuDQoNClllYWgsIEknZCB0cmllZCB0byB1c2UgX01BU0sgd2hlbiBleHBsaWNpdGx5IHVz
aW5nIGl0IGFzIGEgbWFzaywgYW5kDQp3aXRob3V0IGluIEZJRUxEX3goKSAoYW5kIHN0aWxsIG1h
bmFnZWQgdG8gYmUgaW5jb25zaXN0ZW50IHdpdGggdGhhdCkuDQpJJ3ZlIG5vdyB1c2VkIF9NQVNL
IGV2ZXJ5d2hlcmUuDQoNCj4gDQo+IA0KPiANCj4gDQo+ID4gwqANCj4gPiDCoAlfX3ZnaWNfdjNf
d3JpdGVfdm1jcih2bWNyKTsNCj4gPiDCoH0NCj4gPiBAQCAtOTI5LDE3ICs5MjcsMTUgQEAgc3Rh
dGljIHZvaWQgX192Z2ljX3YzX3dyaXRlX2JwcjEoc3RydWN0DQo+ID4ga3ZtX3ZjcHUgKnZjcHUs
IHUzMiB2bWNyLCBpbnQgcnQpDQo+ID4gwqAJdTY0IHZhbCA9IHZjcHVfZ2V0X3JlZyh2Y3B1LCBy
dCk7DQo+ID4gwqAJdTggYnByX21pbiA9IF9fdmdpY192M19icHJfbWluKCk7DQo+ID4gwqANCj4g
PiAtCWlmICh2bWNyICYgSUNIX1ZNQ1JfQ0JQUl9NQVNLKQ0KPiA+ICsJaWYgKEZJRUxEX0dFVChJ
Q0hfVk1DUl9FTDJfVkNCUFJfTUFTSywgdmFsKSkNCj4gPiDCoAkJcmV0dXJuOw0KPiA+IMKgDQo+
ID4gwqAJLyogRW5mb3JjZSBCUFIgbGltaXRpbmcgKi8NCj4gPiDCoAlpZiAodmFsIDwgYnByX21p
bikNCj4gPiDCoAkJdmFsID0gYnByX21pbjsNCj4gPiDCoA0KPiA+IC0JdmFsIDw8PSBJQ0hfVk1D
Ul9CUFIxX1NISUZUOw0KPiA+IC0JdmFsICY9IElDSF9WTUNSX0JQUjFfTUFTSzsNCj4gPiAtCXZt
Y3IgJj0gfklDSF9WTUNSX0JQUjFfTUFTSzsNCj4gPiAtCXZtY3IgfD0gdmFsOw0KPiA+ICsJdm1j
ciAmPSB+SUNIX1ZNQ1JfRUwyX1ZCUFIxX01BU0s7DQo+ID4gKwl2bWNyIHw9IEZJRUxEX1BSRVAo
SUNIX1ZNQ1JfRUwyX1ZCUFIxLCB2YWwpOw0KPiANCj4gQXMgYWJvdmUsIEZJRUxEX01PRElGWSgp
IG1ha2VzIHRoaXMgYSBvbmUgbGluZXIuDQo+IA0KDQpEb25lLg0KDQo+ID4gwqANCj4gPiDCoAlf
X3ZnaWNfdjNfd3JpdGVfdm1jcih2bWNyKTsNCj4gPiDCoH0NCj4gPiBAQCAtMTAyOSwxOSArMTAy
NSwxNSBAQCBzdGF0aWMgdm9pZCBfX3ZnaWNfdjNfcmVhZF9ocHBpcihzdHJ1Y3QNCj4gPiBrdm1f
dmNwdSAqdmNwdSwgdTMyIHZtY3IsIGludCBydCkNCj4gPiDCoA0KPiA+IMKgc3RhdGljIHZvaWQg
X192Z2ljX3YzX3JlYWRfcG1yKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIHZtY3IsDQo+ID4g
aW50IHJ0KQ0KPiA+IMKgew0KPiA+IC0Jdm1jciAmPSBJQ0hfVk1DUl9QTVJfTUFTSzsNCj4gPiAt
CXZtY3IgPj49IElDSF9WTUNSX1BNUl9TSElGVDsNCj4gPiAtCXZjcHVfc2V0X3JlZyh2Y3B1LCBy
dCwgdm1jcik7DQo+ID4gKwl2Y3B1X3NldF9yZWcodmNwdSwgcnQsIEZJRUxEX0dFVChJQ0hfVk1D
Ul9FTDJfVlBNUiwNCj4gPiB2bWNyKSk7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiDCoHN0YXRpYyB2
b2lkIF9fdmdpY192M193cml0ZV9wbXIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgdm1jciwN
Cj4gPiBpbnQgcnQpDQo+ID4gwqB7DQo+ID4gwqAJdTMyIHZhbCA9IHZjcHVfZ2V0X3JlZyh2Y3B1
LCBydCk7DQo+ID4gwqANCj4gPiAtCXZhbCA8PD0gSUNIX1ZNQ1JfUE1SX1NISUZUOw0KPiA+IC0J
dmFsICY9IElDSF9WTUNSX1BNUl9NQVNLOw0KPiA+IC0Jdm1jciAmPSB+SUNIX1ZNQ1JfUE1SX01B
U0s7DQo+ID4gLQl2bWNyIHw9IHZhbDsNCj4gPiArCXZtY3IgJj0gfklDSF9WTUNSX0VMMl9WUE1S
X01BU0s7DQo+ID4gKwl2bWNyIHw9IEZJRUxEX1BSRVAoSUNIX1ZNQ1JfRUwyX1ZQTVIsIHZhbCk7
DQo+IA0KPiBGSUVMRF9NT0RJRlkoKSBzaG91bGQgYmUgZmluZSBoZXJlIEkgdGhpbmsuDQo+IA0K
DQpEb25lLg0KDQo+ID4gwqANCj4gPiDCoAl3cml0ZV9naWNyZWcodm1jciwgSUNIX1ZNQ1JfRUwy
KTsNCj4gPiDCoH0NCj4gPiBAQCAtMTA2NCw5ICsxMDU2LDkgQEAgc3RhdGljIHZvaWQgX192Z2lj
X3YzX3JlYWRfY3RscihzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSwgdTMyIHZtY3IsIGludCBy
dCkNCj4gPiDCoAkvKiBBM1YgKi8NCj4gPiDCoAl2YWwgfD0gKCh2dHIgPj4gMjEpICYgMSkgPDwg
SUNDX0NUTFJfRUwxX0EzVl9TSElGVDsNCj4gPiDCoAkvKiBFT0ltb2RlICovDQo+ID4gLQl2YWwg
fD0gKCh2bWNyICYgSUNIX1ZNQ1JfRU9JTV9NQVNLKSA+Pg0KPiA+IElDSF9WTUNSX0VPSU1fU0hJ
RlQpIDw8IElDQ19DVExSX0VMMV9FT0ltb2RlX1NISUZUOw0KPiA+ICsJdmFsIHw9IEZJRUxEX0dF
VChJQ0hfVk1DUl9FTDJfVkVPSU0sIHZtY3IpIDw8DQo+ID4gSUNDX0NUTFJfRUwxX0VPSW1vZGVf
U0hJRlQ7DQo+IA0KPiBCaXQgdWdseSB0byBtaXggYW5kIG1hdGNoIHN0eWxlcy4NCj4gSUNDX0NU
UkxfRUwxX0VPSW1vZGVfTUFTSyBpcyBkZWZpbmVkIHNvIHlvdSBjb3VsZCBkbyBhIEZJRUxEX1BS
RVAoKQ0KDQpEb25lLg0KDQo+IA0KPiA+IMKgCS8qIENCUFIgKi8NCj4gPiAtCXZhbCB8PSAodm1j
ciAmIElDSF9WTUNSX0NCUFJfTUFTSykgPj4gSUNIX1ZNQ1JfQ0JQUl9TSElGVDsNCj4gPiArCXZh
bCB8PSBGSUVMRF9HRVQoSUNIX1ZNQ1JfRUwyX1ZDQlBSLCB2bWNyKTsNCj4gPiDCoA0KPiA+IMKg
CXZjcHVfc2V0X3JlZyh2Y3B1LCBydCwgdmFsKTsNCj4gPiDCoH0NCj4gPiBAQCAtMTA3NiwxNCAr
MTA2OCwxNCBAQCBzdGF0aWMgdm9pZCBfX3ZnaWNfdjNfd3JpdGVfY3RscihzdHJ1Y3QNCj4gPiBr
dm1fdmNwdSAqdmNwdSwgdTMyIHZtY3IsIGludCBydCkNCj4gPiDCoAl1MzIgdmFsID0gdmNwdV9n
ZXRfcmVnKHZjcHUsIHJ0KTsNCj4gPiDCoA0KPiA+IMKgCWlmICh2YWwgJiBJQ0NfQ1RMUl9FTDFf
Q0JQUl9NQVNLKQ0KPiA+IC0JCXZtY3IgfD0gSUNIX1ZNQ1JfQ0JQUl9NQVNLOw0KPiA+ICsJCXZt
Y3IgfD0gSUNIX1ZNQ1JfRUwyX1ZDQlBSX01BU0s7DQo+ID4gwqAJZWxzZQ0KPiA+IC0JCXZtY3Ig
Jj0gfklDSF9WTUNSX0NCUFJfTUFTSzsNCj4gPiArCQl2bWNyICY9IH5JQ0hfVk1DUl9FTDJfVkNC
UFJfTUFTSzsNCj4gVGhlc2UgY291bGQgYmUgc29tZXRoaW5nIGxpa2UNCj4gDQo+IAlGSUVMRF9N
T0RJRlkoSUNIX1ZNQ1JfRUwyX1ZDQlBSX01BU0ssICZ2bWNyLA0KPiAJCcKgwqDCoMKgIEZJRUxE
X0dFVChJQ0NfQ1RSTF9FTDFfQ0JQUl9NQVNLLCB2YWwpKTsNCj4gDQo+IE1vcmUgY29tcGFjdC4g
V2hldGhlciBtb3JlIHJlYWRhYmxlIGlzIGEgbGl0dGxlIGJpdCBtb3JlIGRlYmF0YWJsZS4NCg0K
SSd2ZSBnb25lIHdpdGggdGhpcyBmb3Igbm93LiBJIHRoaW5rIGl0IGlzIHN1ZmZpY2llbnRseSBy
ZWFkYWJsZS4NCg0KPiANCj4gPiDCoA0KPiA+IMKgCWlmICh2YWwgJiBJQ0NfQ1RMUl9FTDFfRU9J
bW9kZV9NQVNLKQ0KPiA+IC0JCXZtY3IgfD0gSUNIX1ZNQ1JfRU9JTV9NQVNLOw0KPiA+ICsJCXZt
Y3IgfD0gSUNIX1ZNQ1JfRUwyX1ZFT0lNX01BU0s7DQo+ID4gwqAJZWxzZQ0KPiA+IC0JCXZtY3Ig
Jj0gfklDSF9WTUNSX0VPSU1fTUFTSzsNCj4gPiArCQl2bWNyICY9IH5JQ0hfVk1DUl9FTDJfVkVP
SU1fTUFTSzsNCj4gPiDCoA0KPiA+IMKgCXdyaXRlX2dpY3JlZyh2bWNyLCBJQ0hfVk1DUl9FTDIp
Ow0KPiA+IMKgfQ0KPiANCj4gVGhhbmtzLA0KPiANCj4gSm9uYXRoYW4NCj4gDQoNClRoYW5rcyBh
IGxvdCENClNhc2NoYQ0K

