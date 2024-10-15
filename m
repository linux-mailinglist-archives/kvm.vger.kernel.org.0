Return-Path: <kvm+bounces-28889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C5699EB24
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F4085B22C73
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AE71D90A4;
	Tue, 15 Oct 2024 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rXOIwxlw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rXOIwxlw"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C61C07E5;
	Tue, 15 Oct 2024 13:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997407; cv=fail; b=WLhdSRDVOlbWZgG+g0JCgGWnNYIXFBb6ciDk7/ZVJxXl0D75qHBqwpZbt/XniyIT1L6GVgHIrRXQgdnnqtdodiTcnPnq9nmLujpjb/X50M78AM6nhMKCcyJ0ixcX9bypZ50oHFISkiqQNIgVIrNE/ctTHtXiHubC9f7MWNkgAPY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997407; c=relaxed/simple;
	bh=THkUA39DFpz2N0HbXudSmExhgHKOGwClTMeCp8YPbgs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RYi627AUDevXhbdrVdIsMkl7mOFwhTsX0+C3bLDPD6bqMBDbWfADafCQYz7NSCitg9899qexgILvGTu1cj1tggEl54YC/YofuoOCflapkPF0+BzVuqvuyhFSJ40Rf86qN4aNAghprf4jpjOvy8c69nNmpTM1qCjr9Yg9/u1p2GA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rXOIwxlw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rXOIwxlw; arc=fail smtp.client-ip=40.107.22.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JZjqvrL4P36ON/i4Le0NEt6eN3gMMvuqxuUvdA3BOC723HbXpngo/vlSLlpDru/Npy7oVIS+1U+D1LI50Pk4MGmBRJ1ckUw+SWy1hyYe7qeLtrDIfVUnAFJNdlhSHYOHWCif8rZEhqdTGFHtXvxxMcVDN838yK0cBLFaEY7TU4sDGaJSAT9AVW9KAoj47FSuxVlW3Sz1SZ5+gLuqbgr8jHt2jecozxB7vqfH5PgjTaHI0k8PrujCV1P5yMhXtBGL6sbte2Ib4H5z3fs8t02IDmZZE7RKIM0qgRyAIFlpZhDKpKt4Aaoecj7ab5nfMzz8c5p6vqBWEhjIGMko2RvOGw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=Vq5LEPZ+U3rSYTkDsUnMDHV8/2Moye52jxUIZpSIvWi2Fa1yzNaYQnABKdUfUVPtmhycE6MhzODJa4ErUlVBP0eeCrnZTtpMOBTCyZiSp5+cQ5znbUqKsjGpm8BY06RQhvCc+ZFkRMdazxT60hQK86ZYKwP5W7d34RlWw0ZlPN8xjbGnRvwzlC10YNJtFhglr1SUirs+WopPjcqW8cgKXVVF2DiWqmE9cvRoytHA+Q3lVL/0D+K5r1G9O5G6iJN74G0yVjwjMMvnVpKi3a4ZR95U1HzjMSyBQX6undB5rkuAlstZJ+rWCxy9ZqWTDM+xPTgGOLEF0Xl9DfmvJvZVUA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=rXOIwxlwk9Ob0LC/Xk+ibVJr8Zwe65oBxk1qrIJwfaKbXOj/jbJmn4gzPDb7ZkGxcnafCcrg8d6XLHCo0/TamitIDRQR8nrlVzeTsR2oQ6acLFcFTRTfFapBQnnukkKubo2cJsD55Pv+7nRlT7i0wZh5WEHKSIlGMDX615ku4o0=
Received: from DU6P191CA0046.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::20)
 by PAWPR08MB10118.eurprd08.prod.outlook.com (2603:10a6:102:368::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Tue, 15 Oct
 2024 13:03:16 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::6e) by DU6P191CA0046.outlook.office365.com
 (2603:10a6:10:53f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Tue, 15 Oct 2024 13:03:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Tue, 15 Oct 2024 13:03:15 +0000
Received: ("Tessian outbound de6fe3af73ff:v473"); Tue, 15 Oct 2024 13:03:14 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3fc22c22d7c35add
X-TessianGatewayMetadata: vqU1OiIRKLLMuHHJPbZ/uHBBabNK4k6lz6PuwhoHVT+W4/YaezqEIra9ufM/OXAUiXeOIDJUj1segXJeUpIqP+wicc8z3TbP94/ZiNQmJF1YhVAgXTB0vdxoGpwD+KNDTsZ0Zr4OP5uwgyCvn+WStbm7ML8mZIk0/4AMtYxLlbY=
X-CR-MTA-TID: 64aa7808
Received: from Lb11795a18fa5.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2FF9EFF4-2A81-48C9-88D6-FF13E8F5C77A.1;
	Tue, 15 Oct 2024 13:03:04 +0000
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lb11795a18fa5.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 13:03:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AOfwdlvy7NM87LMdapTH0DOsIVtsLpFUbu62pZptDpdI1GHhpfkboX2BgJCifxWds8nKPQRtXomKtOZqOFdHGd/ug7R4gOVABFunuIVyPhO16Ja4mvwFXSbElLwTOKo9mYOyw8RQxyzFJfryekPsjQomQD46iAPfExJmTS26CfMzNkY1ndao0fkZr9PAy/sFIWploJOykO4ZIfXAEENbWQuepjNoU95SGYYmu8EkHzk5IxTndAUnRlJQ09d1doYCW9Vv8aHUzShyqQBYRkH/w/jRoyeql2oapsU6I5UG/w7eDBm/0Uf/6NyEpZaL/y+giUFaTEiN09U/wBRxcb5SZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=oWSbkWfax9Z2LUm1QhtqR0+NhdtgjD/ifOeFJ2lIaBVMKiNtEq15/KcSLFtmdkdF/YImJk4USFoa+rVSA3zdWfHlmcWxvUO+xY/iUePaeobogTbFg7y+EpZhtSFyFCExCaCnxhB76/q+xSghzPj/2TOebTVwzje51WjD1azxEOj52R+IaJ7RaNXk9IIiEt3+umT/08Il9AoWzJlzQVHDZNAz01zo5E58leHz4rXqszJRwJ5W6hmGbDxHdw4FMAxO+gHg5Fgfzx4iAJjGUMzd3n4rwyAV7Ss78MqX40DbRmZIhlJNIrSxcPuUYKu/xxnX41yAxoVmy4J6tfN19ftWDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+569R6Jmva7fy0j0x2UmHQefmx67PZdI5hWhVGvwgw=;
 b=rXOIwxlwk9Ob0LC/Xk+ibVJr8Zwe65oBxk1qrIJwfaKbXOj/jbJmn4gzPDb7ZkGxcnafCcrg8d6XLHCo0/TamitIDRQR8nrlVzeTsR2oQ6acLFcFTRTfFapBQnnukkKubo2cJsD55Pv+7nRlT7i0wZh5WEHKSIlGMDX615ku4o0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by VI0PR08MB11134.eurprd08.prod.outlook.com (2603:10a6:800:250::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 13:03:01 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 13:03:01 +0000
Message-ID: <ee899720-7b13-4609-a00b-86af868a0b1d@arm.com>
Date: Tue, 15 Oct 2024 14:02:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/43] arm64: RME: Support for the VGIC in realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-16-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|VI0PR08MB11134:EE_|DU2PEPF00028D07:EE_|PAWPR08MB10118:EE_
X-MS-Office365-Filtering-Correlation-Id: 48041c24-7750-4be1-59ca-08dced19bb54
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aEZDV2lFQ0FZYXhReUJyRGNyK2dLdVI4d0c3QThsSDQzZHdsYmlwNjhkNlo4?=
 =?utf-8?B?YVdiQXYrWWVNY1RjSktKdjFsYUhRNGpRdHZHWWZDUTByTGZ0NlZ1UUlMQUFo?=
 =?utf-8?B?bVZVRmY0Wi85bFFZUTZEZjFSRnF0RHdFZ3Q2SSsxb0I1WWxsWEZoYVBVeE1V?=
 =?utf-8?B?cDNHSHllNnUrMXdmVVVPUnMvS21uMXJPQVV2czZhcXJVaUVhbm5lVG5XOHRk?=
 =?utf-8?B?Z2ZxalFBNW54SVNubUs0QmVaaG5YZUpUZ0x3ejUrNnFlN1FtQ2M4RGtFOGE4?=
 =?utf-8?B?d2pIZUlDRDV0YXQyS0NYT3hNNWY2Tzl1L3hIYWs5V2JUMDZHUmFEUjU4eDJE?=
 =?utf-8?B?cmxzU1VoQTF6a0g0cWZ0MzRNQVpJa0pFamtrVVpXenZJQzN4VXoySkdBMmhp?=
 =?utf-8?B?R3VEdG5PMnB5MjVTOEJsOG9Rd2NDaGpIV3FSaDVOdFVWOHZKQzlqNXQxL1Zl?=
 =?utf-8?B?SVJWdXJ6dkhEb1JTZDh5eXA5SUdEbys4NmxzdXRFNElja3YzVllrUWJwa1E0?=
 =?utf-8?B?WUxNZXRpNU5nM0lyMlovVHpDSGFON3gzL3N1d2JRUXpBNFNUcGJNcEU4Vkdw?=
 =?utf-8?B?OG1rcUU0bnI2M3A4THZQMnVPeFZlMjBuL3MzTUkydG9sWXdYUFo0YytOQ0lk?=
 =?utf-8?B?ZDR6eUV5OXhydGNiQnE1TWo2TlVMOVJZQ1pBY2Ntb2psWjRDRmlISUhibm5C?=
 =?utf-8?B?MTI5YkR3RGVCSEphYzliT2NNYzVQUFM4Wi9DSWZudTVTd0t5N1BiNTNrSjRE?=
 =?utf-8?B?YmhrZzUzd3l3TmpYM0FaOEtUVmNrNGVwQVRtWlRXWHF1YXN6QTd0d1hsTXhW?=
 =?utf-8?B?d3FMWk82L2RJTWVGK0p3N0dJaS9lTVpCOFFIRmFseGFENy9TMmZpcWdBK1RK?=
 =?utf-8?B?WHBSa2NpMW03SnBxVE14aUVHamljWi9MN0hWQTRlQkFob3BlN1lzQ0F4MHd5?=
 =?utf-8?B?aEcwZFNYdS9ENVhMUW1OL001VUNyVmZ2YUtvWG45NW1nRE5zcGw1UHhGRWov?=
 =?utf-8?B?Ui9DaGEySm1LVElRdDlFWGJrbHkvSjQ0Nm8xYTFFL3AzQjRTRTNXbGVlUDVt?=
 =?utf-8?B?WG0vaTFwUDJlVGp2c2NpV2hNME5KdlZZY0RVQXlHaURZZ1FLakdka3Ayd1B6?=
 =?utf-8?B?eE5iRDNTL0VJMXg4bEgxWGZsV2dlbVFGOE9wdU1ZL0pJeXh6OGhLYzgrQVVL?=
 =?utf-8?B?SFBHOTFRV1h0dDZtM1lxc3VqMjI2eCsrQnltTldQU3ZCNDhmbm5OTmNWell4?=
 =?utf-8?B?SWdGQXNJMENicUM5d3lTMU81aVNQY1lXeUROTUJYUW5ySFFjci9oVW90UDhD?=
 =?utf-8?B?TkF3OEJHbjUwSE1uK1hOaTNrUmRHejZ4enpjbm00YjFwQVNWWXo1bTR5VkVs?=
 =?utf-8?B?eC9NeTZnVjQ0VnVSeUd3VzBtb2paQ2tJSVI2QnI2WDhaTzJJOU54NkxhNFY0?=
 =?utf-8?B?aG1aYndjTmZqZHNaa245TnBmKy92dkdFVUFLRXZNSTN4b3V6bTlXd1F1ektF?=
 =?utf-8?B?VHNaN3JqQ2NvRkFoc09Xa0p5LzhwWTR4WmZFbFF2RFVRV0VmRkVmcEVEdE85?=
 =?utf-8?B?alo1WHFVQUNpOEJ3alFFeU5hR2pkZ05WU1JraGtRNnd0Tk5mMDY2dG9yQjVo?=
 =?utf-8?B?R1pxSnk3OHMxd3h3UEkySFBvbjBOSXJmWjMyOWQxYmU3SENzZFZpcGNVcmto?=
 =?utf-8?B?enNJZjF5S3BVV0Vwa0U2UEVIdE8yMTUrMDQzelRRakFiSWdZUE9QUzBRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11134
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8a430732-3145-4c75-7264-08dced19b2d5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eU5CWkszOXlLMDdYNllxbGMrMW1jWjdSWElmbTFvM0o3blhDNW16ZzUrVDdY?=
 =?utf-8?B?cDIydUtWdTdSS3p4dlc3QUFxOU9GeUVJcVNlUUpVSUJYdFZxT05YZVdMd0NP?=
 =?utf-8?B?LzZlSTJ0c0trd1ByT1Z2TGFJME8zMitMd3MveTZGaHNFZ25XSXpTUTJhT2c4?=
 =?utf-8?B?UTJUdlZENmhtc2s1azFOZFRaT25WTHYyUzBFNG5zQ0cvS1hvcFh0eWtPNk1L?=
 =?utf-8?B?VnpjY2YzSE1BYmwySUFiUCtkdjB1dDRtbERqQk41dHhEOEwyWHN5aTRsb2dP?=
 =?utf-8?B?UjlvWVRWdzIxVkVHTGRLZUt2MXVKUFRLUEZ3Q3BQYVQ5dDY3WVM1b0QvaVVE?=
 =?utf-8?B?dlY0b29rRXB5SVlNaHhCSk1BS2xqZDIwUlpTRnJXSWRZV1cwZi9PVHYzanVu?=
 =?utf-8?B?NlRPdnVFaGwxMjlybFArMENHMG9uNERnSmFHVzN3eWM0ZUFGTmNpdyszZ1oz?=
 =?utf-8?B?UXJOQVgxRHhPVjhKRXJlNTZpUlgzUlFNeVIzdGxTMmhRcDdDakw2Z1JiZlY4?=
 =?utf-8?B?SWVJZkNQZ0RQdXE3NVJPSkJxM1dqSndadUF0bWRNaHhsOXRRZEdjZVpMZ0pi?=
 =?utf-8?B?QVdlSllVYlUzclRHMzk1RU5pUElGLzVYSFFFbTdnK1BUUEwrNzZDYTVibitN?=
 =?utf-8?B?NFIrTnFRMWhYOGEzeDJNWkhsYmVickhlMGRsWnZ0bENCeGp0a3ZnUk1vb1dp?=
 =?utf-8?B?Njh0Zm5JdXo0anVLeER5clRyNVhWbXJpRWI4ZWZUb0ZXcUo4R1FOY0R2YVZy?=
 =?utf-8?B?YXA2N0psTEVkQzRiWExaWkZDV1ZUVHMwd2tiQ0N2YldRbnBPcStYYWlwRThV?=
 =?utf-8?B?QTZqNHlqWUJoQ2V0c3RmZmdycGZLTUVEdTdIbzVsMkNxd09XUDY4MzdGUU1w?=
 =?utf-8?B?TGxFMUlWWUJJZHlLZWg1eUdBMjcwMGswdkxaNnppSGlHRUJhcXpYcHJrcFlB?=
 =?utf-8?B?TVVhTTZ4U1V6d0hGcmtpVVMrYkNiZERENUliSGhBWStHdE5RK09rSnVONC9w?=
 =?utf-8?B?M0JlV1I1WVE4SVBvbVNJUkt4clFNT3p2UWxxRVhIdjN4MEhJd3pmaVBEQVdQ?=
 =?utf-8?B?dGdTamx1OUVNREVhbk1Scm5lU3hYdHBpK1pOV0Irc3dWUUJjSHVzR01ITVVj?=
 =?utf-8?B?aDhKbFBWLzZOM29vMjdLTzVNa0ovUFlCYmRkTzNUYzlCRU41MzVYQzdxVVZj?=
 =?utf-8?B?alBJTEtaL3AybXNDdERQQ2pvckRta0R0bFJnQW9NVGdrems5SWMxRVl2MTJl?=
 =?utf-8?B?aHc3cm50aXFsdDU0Ui9QSHllWlk5VWtCSXErZHhvN3BxTHY0RDdkU1VTREk5?=
 =?utf-8?B?NlZUNjNTUE9YcjNjZ0pWWGU2UHB4M0JvcCtFRnZNVk50YStZVVZiQzFHc2xm?=
 =?utf-8?B?TlV0dURyVFlTTzVLQnIxQjk5ZWt3SlFadnNZc2ZQUFdhTElzSDVBZEIxVEZi?=
 =?utf-8?B?c1Fvam56YnZiU1FRMmhPT0Nhem1rYkQxY2xTdGhTSWJRZS9sRnh1YzZSdDlO?=
 =?utf-8?B?Wi94Rm5hbHFDSnhaYjV4RFBYNWRTck45bmwvSG04amNhNEM4c09xT1hjb01K?=
 =?utf-8?B?ckRTN0pKdXJ6Y2FVWllpR1dZQjZtRzVnS2oyZ2ptNUZCbU1kajdQSndXMjBK?=
 =?utf-8?B?RkNBWHNsSEZNU1A2angxU1BkSFluQmxxRHZtRHMwdUFWcWNKYmpLZTJVK0ln?=
 =?utf-8?B?Q3dwMFZzN2h0Tnh6bnEydDJEZlkxNkR5NVA5N2cxMHUrMlBZRjdTWUtwaGpJ?=
 =?utf-8?B?M0pMcXppc1VvWSs5WnJGYjhVcEpnam5VWVQ2czBnVFVzQVMyVGU2L0s2MUkr?=
 =?utf-8?B?Yy9XV3Y1b2dPblRwS2dNMkZObmRINTBhZTNZSmw3aGJGTlhVSW0vdkFhd3hB?=
 =?utf-8?Q?gmFp43VbqrO63?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 13:03:15.1506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48041c24-7750-4be1-59ca-08dced19bb54
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10118

On 04/10/2024 16:27, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest but delegates
> much of the handling to the host. Implement support in KVM for
> saving/restoring state to/from the REC structure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v5: More changes to adapt to rebasing.
> v3: Changes to adapt to rebasing only.
> ---
>   arch/arm64/kvm/arm.c          | 15 ++++++++++---
>   arch/arm64/kvm/vgic/vgic-v3.c |  8 ++++++-
>   arch/arm64/kvm/vgic/vgic.c    | 41 +++++++++++++++++++++++++++++++++--
>   3 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 87aa3f07fae2..ecce40a35cd0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -687,19 +687,24 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   
>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
> +	kvm_timer_vcpu_put(vcpu);
> +	kvm_vgic_put(vcpu);
> +
> +	vcpu->cpu = -1;
> +
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +
>   	kvm_arch_vcpu_put_debug_state_flags(vcpu);
>   	kvm_arch_vcpu_put_fp(vcpu);
>   	if (has_vhe())
>   		kvm_vcpu_put_vhe(vcpu);
> -	kvm_timer_vcpu_put(vcpu);
> -	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
>   	if (vcpu_has_nv(vcpu))
>   		kvm_vcpu_put_hw_mmu(vcpu);
>   	kvm_arm_vmid_clear_active();
>   
>   	vcpu_clear_on_unsupported_cpu(vcpu);
> -	vcpu->cpu = -1;
>   }
>   
>   static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> @@ -907,6 +912,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (!irqchip_in_kernel(kvm)) {
> +		/* Userspace irqchip not yet supported with Realms */
> +		if (kvm_is_realm(vcpu->kvm))
> +			return -EOPNOTSUPP;
> +
>   		/*
>   		 * Tell the rest of the code that there are userspace irqchip
>   		 * VMs in the wild.
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index b217b256853c..ce782f8524cf 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -7,9 +7,11 @@
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   #include <kvm/arm_vgic.h>
> +#include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/rmi_smc.h>
>   
>   #include "vgic.h"
>   
> @@ -679,7 +681,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>   			(unsigned long long)info->vcpu.start);
>   	} else if (kvm_get_mode() != KVM_MODE_PROTECTED) {
>   		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
> -		kvm_vgic_global_state.can_emulate_gicv2 = true;
> +		if (!static_branch_unlikely(&kvm_rme_is_available))
> +			kvm_vgic_global_state.can_emulate_gicv2 = true;

We could avoid this restriction for normal VMs by adding a check in
kvm_vgic_create() ?

>   		ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
>   		if (ret) {
>   			kvm_err("Cannot register GICv2 KVM device.\n");
> @@ -746,6 +749,9 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
>   {
>   	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>   
> +	if (vcpu_is_rec(vcpu))
> +		cpu_if->vgic_vmcr = vcpu->arch.rec.run->exit.gicv3_vmcr;
> +
>   	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
>   	WARN_ON(vgic_v4_put(vcpu));
>   
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index f50274fd5581..78bf9840a557 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -10,7 +10,9 @@
>   #include <linux/list_sort.h>
>   #include <linux/nospec.h>
>   
> +#include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
> +#include <asm/rmi_smc.h>
>   
>   #include "vgic.h"
>   
> @@ -848,10 +850,23 @@ static inline bool can_access_vgic_from_kernel(void)
>   	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
>   }
>   
> +static inline void vgic_rmm_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	int i;
> +
> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {

I believe we should limit the number of LRs that KVM processes for a 
given REC VCPU to that of the limit imposed by RMM 
(RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS).

Otherwise, theoretically we could loose interrupts for a Realm VM.

e.g., KVM populates the maximum vgic_nr_lrs to rec_run. But RMM
on rec exit, populates only the "number" of LRs from above and thus
KVM could loose the remaining LRs and thus never injected into the Realm.

The rest looks good to me.

Suzuki


> +		cpu_if->vgic_lr[i] = vcpu->arch.rec.run->exit.gicv3_lrs[i];
> +		vcpu->arch.rec.run->enter.gicv3_lrs[i] = 0;
> +	}
> +}
> +
>   static inline void vgic_save_state(struct kvm_vcpu *vcpu)
>   {
>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   		vgic_v2_save_state(vcpu);
> +	else if (vcpu_is_rec(vcpu))
> +		vgic_rmm_save_state(vcpu);
>   	else
>   		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
>   }
> @@ -878,10 +893,28 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>   	vgic_prune_ap_list(vcpu);
>   }
>   
> +static inline void vgic_rmm_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	int i;
> +
> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
> +		vcpu->arch.rec.run->enter.gicv3_lrs[i] = cpu_if->vgic_lr[i];
> +		/*
> +		 * Also populate the rec.run->exit copies so that a late
> +		 * decision to back out from entering the realm doesn't cause
> +		 * the state to be lost
> +		 */
> +		vcpu->arch.rec.run->exit.gicv3_lrs[i] = cpu_if->vgic_lr[i];
> +	}
> +}
> +
>   static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
>   {
>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   		vgic_v2_restore_state(vcpu);
> +	else if (vcpu_is_rec(vcpu))
> +		vgic_rmm_restore_state(vcpu);
>   	else
>   		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
>   }
> @@ -922,7 +955,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>   
>   void kvm_vgic_load(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm)) ||
> +	    vcpu_is_rec(vcpu)) {
>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
>   		return;
> @@ -936,7 +971,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
>   
>   void kvm_vgic_put(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm)) ||
> +	    vcpu_is_rec(vcpu)) {
>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
>   		return;


