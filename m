Return-Path: <kvm+bounces-28879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFC099E58A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91FC01C22F43
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1731D966E;
	Tue, 15 Oct 2024 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j2m/iWPV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j2m/iWPV"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2041.outbound.protection.outlook.com [40.107.20.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EEE174ED0;
	Tue, 15 Oct 2024 11:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728991549; cv=fail; b=o5PVh6567g9m3VdvwYF2akcbaEzjTi8UMLb8w5n6Lbs2G/5U5F7+MRUSpFEEs2Vkw69gGwuCL1SiN48vZ/LXB/69B2ogYEMHQiI88NOeT+dNn5HVSclrfjQb+XKGGuBwEOX2Z5SEyZaTxUpJ5QiIdeFJsjeoVOcx2WFX70neU2w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728991549; c=relaxed/simple;
	bh=MvGfz2NBN7TOg8tOyV+VYxO72Rt1rDuy7CodSYNJshY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e9faHQzrBJqWy/pGge3lCZfEgHCrZ0ro7dV8Bb860f/pMVXwnJ3Snn8F+/C0VfBZWBZ38hpg/yQlV8GJqiz47TShnc5Zceq2hFvkA+6lTWIHS1eLYoXunrhtqEQBCkeKc5C85gfarwpvTdv6KipayiHJHCs5gaJWk7sl7YJEGNM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j2m/iWPV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j2m/iWPV; arc=fail smtp.client-ip=40.107.20.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dI/5kBrUpo9SOF+cwB8eCGkTBIlFj+fyOsVgOJHYRwz5ngEQn4BKCKRSYKuOnVTbfUZFJ+U/5+nEtqiFfwAxl+xWXdkCHn8pbxklB05daRkSyMDhtizaE5jsRnipJ3KuMpcsdGY9V0D8TWmWzlu8Eu6wpcBGVRXujPBZLJF3bdHpayc2uj9K8f9k6QclQbZBunwluE3wPPvGxcNc/xrjmXauWudvC3kgoDPXac2tC90XZJ45v0HZxxl1uIB1oPJBLR99NlBQEJ7QY1x0eS06H6BDtV+VbTiSItATColcGXtGwSOkNW4kPs+vsRgACXARUItrWjTcb2vuEroNcAjGpQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVaj6u9gN/0b2azoV5+owxNk+IWcEozwb0v8T4iiLhs=;
 b=oroC3FCzTVyOMNGKx+2CcGgEqoEWUrQYNZZ2q5ge0phGRQYEtFaSlL9xQ6msrU3TA33TqvIvIRh53dyHG4/3t0YQNESe7XVp+3JtKBnTUrieiTvNv6FjZS6n9SmeRy5FGtw6vhXTyZxy1QUiJ3UuVZJqBWPzilr+QSQeYo/qA6KMiGU8Mgmt8OrynnNTRmL/l3lZvW+4a8I185cCajJHO7CL9O03BVRb5wd6noVr1d0TKvartvQSL2NVA8wjL3WJkQ+FgDEEsufiqDzM4T9C7B11CbRNT0SOVzsJWm4yRgxp0hntBrvCObFb+gBU50H0PDbrpggGQ+z5+Ef8r7ieQw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVaj6u9gN/0b2azoV5+owxNk+IWcEozwb0v8T4iiLhs=;
 b=j2m/iWPVhAfgKWfC6EY5EtREEK1MP7qdnqt2MwiTyZalDkC4EJWJMylDNOFzpU5kgAi8SlOM83jyFG4/hLMgILB+l3Qel5m8ou6JU/AMB41maPYnFfSxWmu0d9jbAVkFbUSLOQIUqoY3LqKyg+Bj0DwpjdmeckYm0Nyy9LHob7I=
Received: from AS4P195CA0021.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5d6::9)
 by AM8PR08MB5748.eurprd08.prod.outlook.com (2603:10a6:20b:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 11:25:41 +0000
Received: from AM3PEPF0000A793.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d6:cafe::73) by AS4P195CA0021.outlook.office365.com
 (2603:10a6:20b:5d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Tue, 15 Oct 2024 11:25:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM3PEPF0000A793.mail.protection.outlook.com (10.167.16.122) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Tue, 15 Oct 2024 11:25:40 +0000
Received: ("Tessian outbound 5e8afd4f8faf:v473"); Tue, 15 Oct 2024 11:25:40 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 2a24a7b67aa09fd4
X-TessianGatewayMetadata: iRhuCb73GAbupech5lqzvGgx+TFcaU7RXE9IxhNggmMlQJoHYeynQLDJ2J0jeJG2C6nWsYoHOvpQMLd5K4a4fCJq3vtGOR6mz+rggnXIfYl+cCkLjXkyYTqX3wYDNJ4/VvaMTBnelJOIghjDXN9QHtzozq0+GCRb6viAIbGMJYs=
X-CR-MTA-TID: 64aa7808
Received: from Ldbf9df790959.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8C241E60-52F5-4924-BB1D-6B8CFCA0538D.1;
	Tue, 15 Oct 2024 11:25:28 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Ldbf9df790959.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 11:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRTAG5wTbW1aSkKedWhU3DWnm30SL+9OjQAHtFSdBQXFOyGyFo8jowac6tKWSP2UM2KebH46XTaSgsvIXl9xTq6tCAMrUi+7tDYuSqkbRAm3L5ik6OeV+M7Qz5o9+BrqyJlg1vVLeliTRHwNQrbYqKdPmZSZkHQ3MqTC9/3siT2gppsKBgO0gnm+8sUg/+4gEctC6aFrLZrIx+yxUT9YpFvjlD8g8NeTnpUB78pQD4PkEKntKXDz327G77N8DnjHzA6M3X2a16Kun7l2aA/8fQZD58beZGRXlkNCDHMTxz5PXwhspwDk0weIySNYwnCFBj/qC9WsJ6BbPvemRsReVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVaj6u9gN/0b2azoV5+owxNk+IWcEozwb0v8T4iiLhs=;
 b=V3fzSpDa6yBzfVMONtXFvzL2K8emC/SOwHjs+pgLy821w4ioUtvP0erLKJNKX2OEkUGbtpVV2P12TWxj0ouc2KGpwpzLanpyEzQsF9yep76efu2n2mhGNm4qYLEH1Resf/UCrDtni4crYVlOWwbiS0DxkH4xbtgMuIT4rGbQn688mKoGwJ5e0Ih3V5IA4Nvg0ZWdKKJH7L15q7m2HC2aZ2xb2QNviyCQpEEJbs/jyXoDWTv7EKzdGe/5Nuj16UwNVxHGw8eNOeNs5DiqLWNL1mjZ8SWXZULH1+bpz/2hY8/3/7suAcsvuYJMtYVJbVE+Nnu5MBuq/66a4ttAVeJGYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVaj6u9gN/0b2azoV5+owxNk+IWcEozwb0v8T4iiLhs=;
 b=j2m/iWPVhAfgKWfC6EY5EtREEK1MP7qdnqt2MwiTyZalDkC4EJWJMylDNOFzpU5kgAi8SlOM83jyFG4/hLMgILB+l3Qel5m8ou6JU/AMB41maPYnFfSxWmu0d9jbAVkFbUSLOQIUqoY3LqKyg+Bj0DwpjdmeckYm0Nyy9LHob7I=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by GV1PR08MB7914.eurprd08.prod.outlook.com (2603:10a6:150:8e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Tue, 15 Oct
 2024 11:25:22 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 11:25:22 +0000
Message-ID: <a4dc1efc-8202-4440-8106-cf475da1a7d5@arm.com>
Date: Tue, 15 Oct 2024 12:25:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/43] arm64: RME: RTT tear down
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
 <20241004152804.72508-14-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-14-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0166.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::10) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|GV1PR08MB7914:EE_|AM3PEPF0000A793:EE_|AM8PR08MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 60f7550d-c4f2-4252-ecb7-08dced0c19d6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?NVlUY3VnYk5xU20rdGJSR01nQUgxY1lTMXZORXcwY0FvLzJDdlJ6Mmp6TTNU?=
 =?utf-8?B?OEhvOWZGUzRyZFphdVhrWVJLdXVxNzA1WmxLb1hqbTBueS8rM1lEZUhHWXh4?=
 =?utf-8?B?Ry9aYkdubHVoY0dBbUpMNHF6ZkhKaUczSFZTcUtTQThpWXQ2cFE5Zmx5NDJV?=
 =?utf-8?B?RElzY09MRExrMGpwVFFFTUVpbFlqd0hpMVVzZFJDNllDcDk4YkJqV21HbW1p?=
 =?utf-8?B?UVpxSk9ncmNpNW5xL2E5MlUzVjZjYjBsWTRTcXIvVkFUYjhSM1FMVmg0OFhm?=
 =?utf-8?B?YTl0bWhlOFBsNmFtQUlKV1E5NGN0dkVZejU0aGlDUXhGM2hISHpaWjhLZnQv?=
 =?utf-8?B?dnpqUmM3UGVTOUs3UE94RnhUSlA0Smp6WVY1MWdMdUpteGY2L3U5TnpxTzR5?=
 =?utf-8?B?SG90elpub1g3bWozTWh3SlVNaUI4Mnc0aTBkZzhIcUIzNnYxdCtDZklTV3M0?=
 =?utf-8?B?djNraDJBc1l4OGhXZytGRzVQeEJpQjM0ekpiMlhSR1Q5M1ZTbllQR1FtVXFQ?=
 =?utf-8?B?QndsdzRKZXp0VnBOZ21JdFpqRWREMW9nYmNOSkVMbEpwVHViSndIOFljdUda?=
 =?utf-8?B?ZEpoMjgrbHhLNmJQR3hVNG9kQ3VpZjNzc0ZrWGExUHRyK3NMeWFXN1VyT25M?=
 =?utf-8?B?d3JSM3NBbEdiTlRKL21VTEV3aE94VDAyWGZFVjdrRDZJTkRjKzIwU2xZYjds?=
 =?utf-8?B?U3pJeDVtVHpvUmNzR0tqLysvNm5VWjBqSjg2SUx0WlNPRHJabEV0QWNaMWgw?=
 =?utf-8?B?VGpLVVZxUzJqMExBSVJTVy8zTndNUDJhNXFpVUdRZnRIM0VUaE1nVEJMdE0y?=
 =?utf-8?B?MmNjNjJKWStZN3J5cFhwbE5VQVlTL0pVeTF4MmVUWWxJSU9uUmhraEJsNVlH?=
 =?utf-8?B?OWkrS1RLL25YZnc2VEZIYlhKdHZHZkJMRFZsNm93Ui9ya1ZJQkEzRWxkM0JX?=
 =?utf-8?B?bCtkemRocEpiNXluNUc3bk1sTUxYVXM4MDlYM0QxWGg5ZXVWcDFGQ3YvNXFm?=
 =?utf-8?B?UWx0SCtxeFBuRUtPbUQ5Mk5HWGpoNXpWN2VaVVZ2bENOVDJPVmFrMXBnZ2No?=
 =?utf-8?B?WGtRa2ZLeFM2RTJFUG5ER0dia2t6Q01jUlRzOTNsd1FtUmN4aSsyOUpYWnU4?=
 =?utf-8?B?bnF2QWN6TmlsWjVUeCtaQkhjNkMrdVpQL3BldkxhQ3h6R2lWczVyQ2d1WjQz?=
 =?utf-8?B?QmFMd0FlZHE4NkxIQjlJR0RKUjMxZWlwWC9Ydmp1WTRqLzI5bGpadmxuOE52?=
 =?utf-8?B?RU1oTGZrWlY2Ny9kZlZ6VWlTZVZteUo2VjVzYkhIR3RxWVVuellyaXJSejVC?=
 =?utf-8?B?MWsrUW5KZ055MDE1V3F6NXh3QThCN0VVN0JLQ3JtT1RDTERZQXlibldBQ3BE?=
 =?utf-8?B?c1VkVDVvTlNKVEVsSmc5VytRMHZmOEhQRjdNek9GWTg3Vm1wVm1Yc29CQkNH?=
 =?utf-8?B?Y3RVMXY5eGRabmwySG91T2tBTGVVM2dLTVRGWG1QSXk3TzBUNkQrM2I0elFr?=
 =?utf-8?B?eFBIZkU4NzNBV2JURW9sSFh1NXc1UTJvSk1OSE5tc2Q1UG1XK1hLUzR3SU5l?=
 =?utf-8?B?N25iZHhpcGN1MlZrTzUxU2NyUnVDOCtQWnFhVW56MnlXMmRFOFdXaUtOQjNP?=
 =?utf-8?B?d1B5Nld1eGtoYk91ZExORlN2MWd4endqRzFUWVB0UEkvRzhocnFKc1J5RGlo?=
 =?utf-8?B?T2t3MEl6cENpejQ2U2czOTB0bEVCZ2lKUU0rUFZwWUxWTmxCQ3JPZ2RRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7914
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f3953311-8517-4018-feab-08dced0c0e7f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkJkRzBuTUhpb3hlcGFhdTU3aHZ0TFlLQWxtSGo0Y010NzhQMkNQSXlZQ2s2?=
 =?utf-8?B?RTdJalFCeFlocSsyaTB1SjlJTnBTaEp0L3ljY3lmeGRyS2wyenVmMC9mNS9J?=
 =?utf-8?B?OEJHOHFpbkRYNmoyNlRBWXV1TjBQNlkvbXhlVGNsUVlncnBTRzJOT0xMdDBR?=
 =?utf-8?B?blg0SkVEa2ZJV1daVlFMd1g5cGxxUzZ1TE9tOCtmRE81U29ERGhuU1RJcnNp?=
 =?utf-8?B?Ym9nS0s0cjNaQnZ0M21JeGhTTEFlMWpkZk5DQlBEcm50b0pIM3MyUE5UcEpN?=
 =?utf-8?B?cHdSZURxR3NBSFlpZjE1ZmhnWjdqbjdneURnRHhEKzNqQmMwWm94RDArZlNy?=
 =?utf-8?B?MkxnY3lNejlVRysycjZGQWZ6ZW50dEhGZjNtbkdTRVVpQTFoN1QxRHY5OXNT?=
 =?utf-8?B?aEtwYUpBWmRlQVZuQ2cyL1FyNmFkZ0ZYN1FkZXVBSEppU0Zxd2o5TGhQUDJl?=
 =?utf-8?B?ZlgvRWV6cjRsOTdBSkZEVVRYTkY0U1hzY28wQkFpbUQvMDdwN0RnRlJTVlFV?=
 =?utf-8?B?NkNkbkQ0MWlzY2Q5b0VwdndKU0RuQUJBNGhVL25nL2N3V3F3enk4enhMU0Nx?=
 =?utf-8?B?NGtRQW5wZjRhaGk2WklidGhzZitPaXhFd05hR21uVUg3dU9EOTRIWmt2WEo4?=
 =?utf-8?B?c2VSQVlBUXdQMW9XMW54SUMxTjFrRUlkT0RYQTVBK2w5N2wwRFNyY1Q3NmpV?=
 =?utf-8?B?NElXMmxYQ2swYWpwNGxDdlJqUHp5M2xWS0hQZWZQanNpWEQ1ZGdhV0FKUzZa?=
 =?utf-8?B?bFR5MWp0SEZUSUZtQU5xTG00R0EzZjJnRmFCZ3NvR3E1amh4a0VkQUcvNU9w?=
 =?utf-8?B?M0FrUm81Q1YyMmlwYjRzTG9FdkczRUVsd1lsOWljbG1HNUhHOStGU016T00y?=
 =?utf-8?B?U2FSSjhQeEE3Y1R4UkRPZ091TWNweElWaHFQRWFOLzVzbzZkbDVHQXFiZWZu?=
 =?utf-8?B?VmczMyt4VnVqQWd4RllyalpGRVg4U3NmanpaVkdVOEpkUjBvY2FFeGVUdkQv?=
 =?utf-8?B?QlRaSVZXQ1luZzdDeHc3eFhVSkpMcXlpSWJadUliMGVhYnNSSUozQ2pBNlRa?=
 =?utf-8?B?eWF4alNaaGZic3pEUHhEZWNBSzZQTTd0d0JCL1BQSTNKVy9XRnNWTUI4OUp6?=
 =?utf-8?B?SGhEYk9wMVZEVXFtRDFkZUNFMXVwMzBrZXMvTTJIYkJpc0lLOHBMNTNwL0xC?=
 =?utf-8?B?ZFRSeTFSVittM0lIbnQwVjNacmxnUExxTlNuWHJYSUtOZTkrSDJ0RFQ2L3d5?=
 =?utf-8?B?S3RPdjJmM3ZSQ0VQODk2VHVlc1M4N1F3SVI4WHhHQnBxWTNJeFhGdzJpNXpW?=
 =?utf-8?B?RVAwYkZoMjdwb3FqYTduVkhnZ1ZIREI1WW9mZGVLUys0cERlK0dKd2VyUzJz?=
 =?utf-8?B?ZlpqQ29MY3B1LytpMmRybkowRjVWdVRZdHlaQ3hyZjRqSmZxVTFlWHdpMzM4?=
 =?utf-8?B?bXlvNUorRDhnK2ZjVGg3cGVvSlZSank3K3BlY1Z0czFLTGN6cE5KNGZQNE96?=
 =?utf-8?B?MzdCZXdWbllyK1FNVFVMVlZYTlFHMFZmcGtqUmVzZ3htekR1R2RXM2dsN3lm?=
 =?utf-8?B?bnFGVGh6dWNGNnJtakZUamVCUllXZGRuWHFPdi93WUhYYi9Pd2dzOCs1ZzZs?=
 =?utf-8?B?Y2djVGxjVE5CY3VqQWZSNUxFcG9ZN1JlUGIvemhKTEJyZHhrNHVEQm5vRWha?=
 =?utf-8?B?cnNZSFk4Mmorb05NNFRKUWFIUVlXU3RWNlVhMHR6dFZOYWpCZm94VDZKV3lH?=
 =?utf-8?B?WGx4b1Vpb0RyQTlObklKK2hSQzFBSEVxeXNKQW1CQTlyN1oyU3piQUxRSUpw?=
 =?utf-8?B?N0U3RUNrM1lqVHdiK0FFZXQ3aDhvc3h2dEpiTmQxT3JKQ0JxRXpUOStxYXBH?=
 =?utf-8?Q?haytg7oB7uAAE?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 11:25:40.7736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f7550d-c4f2-4252-ecb7-08dced0c19d6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5748

Hi Steven

On 04/10/2024 16:27, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>     later patch when they are actually used.
>   * Some simplifications now rmi_xxx() functions allow NULL as an output
>     parameter.
>   * Improved comments and code layout.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  19 ++++++
>   arch/arm64/kvm/mmu.c             |   6 +-
>   arch/arm64/kvm/rme.c             | 113 +++++++++++++++++++++++++++++++
>   3 files changed, 135 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index bd306bd7b64b..e5704859a6e5 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -76,5 +76,24 @@ u32 kvm_realm_ipa_limit(void);
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +
> +#define RME_RTT_BLOCK_LEVEL	2
> +#define RME_RTT_MAX_LEVEL	3
> +
> +#define RME_PAGE_SHIFT		12
> +#define RME_PAGE_SIZE		BIT(RME_PAGE_SHIFT)
> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
> +#define RME_RTT_LEVEL_SHIFT(l)	\
> +	((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)
> +#define RME_L2_BLOCK_SIZE	BIT(RME_RTT_LEVEL_SHIFT(2))
> +
> +static inline unsigned long rme_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return RME_PAGE_SIZE;
> +
> +	return (1UL << RME_RTT_LEVEL_SHIFT(level));
> +}
>   
>   #endif
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d4ef6dcf8eb7..a26cdac59eb3 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1054,17 +1054,17 @@ void stage2_unmap_vm(struct kvm *kvm)
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	struct kvm_pgtable *pgt = NULL;
> +	struct kvm_pgtable *pgt;
>   
>   	write_lock(&kvm->mmu_lock);
> +	pgt = mmu->pgt;
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> -		/* Tearing down RTTs will be added in a later patch */
>   		write_unlock(&kvm->mmu_lock);
> +		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>   		return;
>   	}
> -	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
>   		mmu->pgt = NULL;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f6430d460519..7db405d2b2b2 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -125,6 +125,119 @@ static int realm_create_rd(struct kvm *kvm)
>   	return r;
>   }
>   
> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
> +			     int level, phys_addr_t *rtt_granule,
> +			     unsigned long *next_addr)
> +{
> +	unsigned long out_rtt;

minor nit: You could drop the local variable out_rtt.

> +	int ret;
> +
> +	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
> +			      &out_rtt, next_addr);
> +
> +	*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +
> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rme_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (next_addr > end || align_addr != addr) {
> +			/*
> +			 * The target range is smaller than what this level
> +			 * covers, recurse deeper.
> +			 */
> +			ret = realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							min(next_addr, end));
> +			if (ret)
> +				return ret;
> +			continue;
> +		}
> +
> +		ret = realm_rtt_destroy(realm, addr, level,
> +					&rtt_granule, &next_addr);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
> +				free_page((unsigned long)phys_to_virt(rtt_granule));
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr > addr) {
> +				/* Missing RTT, skip */
> +				break;
> +			}
> +			if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
> +				return -EBUSY;
> +			/*
> +			 * We tear down the RTT range for the full IPA
> +			 * space, after everything is unmapped. Also we
> +			 * descend down only if we cannot tear down a
> +			 * top level RTT. Thus RMM must be able to walk
> +			 * to the requested level. e.g., a block mapping
> +			 * exists at L1 or L2.
> +			 */

This comment really applies to the if (RMI_RETURN_INDEX(ret) != level) 
check above. Please move it up.

With that :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>





> +			if (WARN_ON(level == RME_RTT_MAX_LEVEL))
> +				return -EBUSY;	> +
> +			/*
> +			 * The table has active entries in it, recurse deeper
> +			 * and tear down the RTTs.
> +			 */
> +			next_addr = ALIGN(addr + 1, map_size);
> +			ret = realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							next_addr);
> +			if (ret)
> +				return ret;
> +			/*
> +			 * Now that the child RTTs are destroyed,
> +			 * retry at this level.
> +			 */
> +			next_addr = addr;
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int realm_tear_down_rtt_range(struct realm *realm,
> +				     unsigned long start, unsigned long end)
> +{
> +	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
> +					 start, end);
> +}
> +
> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;


