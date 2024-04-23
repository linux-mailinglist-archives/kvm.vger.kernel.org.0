Return-Path: <kvm+bounces-15627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D81C8AE0EE
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 11:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A934B1C21852
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 09:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BDB5F860;
	Tue, 23 Apr 2024 09:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OMQmap5M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3339E56B69;
	Tue, 23 Apr 2024 09:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713864139; cv=fail; b=m9s4qfrfYwosaRdLG1LN+JZOq7wnCfkz0yWd6KQ3UA3GD69XU9h4RoLaNTWqAYygOn8B6AnKivzH7geWcvWrE6DvZg6g0tnM7E/ttI68LNjIGKKcmqYBpIugpVsnQ6qCq/SbbTwZg+s/gMVXgmlKvXxc4JQREltBhortE5WVp7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713864139; c=relaxed/simple;
	bh=xuHHbZQicq49oRqlj5RlUa7C3W7KJOM2x4iMCuGUChM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qEf3WFgM1dBkQoruf8eyvChkQOr3eMe5+7kEsBiDCsYXC4316aMXAIQ9IKKhJILgNwj0VWd+62GqClBLhAncjJ49OCS+0ycB2wrX+AB8saPpXBuTm8OrLuPng3ZWxUPmSZlWfKMxYu/ZN53qqw/kxbuxwSjZyuXXjgs0JG9Y5+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OMQmap5M; arc=fail smtp.client-ip=40.107.101.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNta1l1MBX853nKn4a8Myi1Phay3N7Xq/bkX/ELmxqBU6rpFFt5Gc7oEF3blXsmMulD7G8zKUI9Rwl7YWAJHKybYA9QJ8LKLU5B7d6MlPiR61U4u8p9e62dJ+HBnGSxCwwaeVCzj1DL2EdIrzZtTApEzVwKKX7yKnnwHKSI20SNWZUH478JeBo54//0PIjbZzR9MeA6BYOsQstruf+jtLyidHp6iSRL+ETSU1AUi49D1GfPuKYh5fRPyWG1kRHVshYkWo37/ksscPQHuMRzEXeCJlJoH02qHJ5kAHE+qlu7URTRvGmZSm1zsc8OP4wsdSEygQQwjHwLVU3Ni1ndISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvS1IVOIAmGYUK5NNha0vugtIUp6xOPG15BbmlMCcaw=;
 b=hQLflVwNdA3eJ1lPzGcsZ43DTU5HlxBAiqCcK3ALVtg8VXfiU7tBCoArKpT5j5rlMWwR3ecdR4xlo72LVTwRhUzvfXZol53ka2L7wozPhsS2494eN87mVE3S10UJnnGBKRPoKqHAOV/rx/hVAiBuH8ATSI08l45lykrmYDCNrs87rh0mT0gF+vcpHtwjLdxQDjl+WjGfkUJbLhY5PzXLc7jIRy2Idhnva2lSWQqfKQ289QkAR+dS5fa7P+ICE1zZ+b7wePMvIoSALZZPEKjUXcorjxvl7VtFsZ/cYHc25zSKMaXbJKaSUo4vOn+gYlP4vC0rADlLRAW29CwjqOiNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvS1IVOIAmGYUK5NNha0vugtIUp6xOPG15BbmlMCcaw=;
 b=OMQmap5MqitQyTPUSJwRyq3qgVW9nJ/MgRK+A8hQsqe3Z+r8fBTDmlj/Uuh3KBQn4naNRgaz1BqaUGfjBUjV52pO3LjhwZbVFQqysli1qvASYVDXWD7jsct4PFVP6l0U9g6ObX5pGowaHT7UWujZn0d6qalHFTA4rJOhecdA/FFyjcKJCwArD3lAbHsKCbceoL+dsJSEqllwmViiklT38VPNjEcdVqsjYzmU9BSFzwrKaDo2k/ekGg4sWJ9a5Nt09QO2FlLhWgt9O0VusUt9SHTNo9YI2WTEzDj7sVHZuZRXWSymvbL4L8rx8+/fTlcsScee6md75NZmDr1iHUCgJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH2PR12MB4056.namprd12.prod.outlook.com (2603:10b6:610:a5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Tue, 23 Apr 2024 09:22:15 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 09:22:15 +0000
Message-ID: <14667111-4ad6-48d2-93ee-742c5075f407@nvidia.com>
Date: Tue, 23 Apr 2024 10:22:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/15] KVM: arm64: nv: Add emulation for ERETAx
 instructions
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>, Fuad Tabba <tabba@google.com>,
 Mostafa Saleh <smostafa@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
 <20240419102935.1935571-13-maz@kernel.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20240419102935.1935571-13-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0094.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::34) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CH2PR12MB4056:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b59f069-d97a-42a6-52ad-08dc6376dd40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXhiTmtwdFpJWW9pL3JTaUtFNi8wMTRzNjhDNWhsdG1paDFZMFMrV3RENHRO?=
 =?utf-8?B?eTVPcnFMdkswWHhrUWNubkpjelJOWitjVk02aUZvQjV4TmVQb2xMOHAzZlhI?=
 =?utf-8?B?RWxENFpLSStCMmxsbWNZdVRqRGdzRXN3VHlHMHkyNFgwYmt2MXRmQk9CZGVM?=
 =?utf-8?B?WTNnMG5lbzM0czFqTDBQZE8wVFRxVlYrdXg3elJDWTBMRTh0RGV0SEJkb2ZV?=
 =?utf-8?B?MkJicGdPTzNZZVdNak82T2pTdjQ0eGZVQ3NuTFZFaGY2OENRVjR4UnBiZWtt?=
 =?utf-8?B?VkFMVWdsQkI4M08zV3NTOWE0SGxJSVZSR1FUcUd4ak1UM2l3OHkvVlE2VUdH?=
 =?utf-8?B?dGxQRWVUdHhqVTEwWjV0cFhUQjY1OTdjZjFEWnRiZTM5bkRtb2svOE9sSUln?=
 =?utf-8?B?Rk0xZWtEV2VJOGlrZzdVWkVJTmJrOU9oTmVISjdPSVRtWVljbEtRTTRETGZs?=
 =?utf-8?B?dmh2YTg3dnN2VTg0YnR0QlRHZXhhSzRjMkprWGVsZm5jRUgvTlllcWlrSFF6?=
 =?utf-8?B?b0tHR3BNU0JSUUxhZy8rQjFCR3VXa3RvRVZ5dzdvdFE4eUtwNitQY3FmdXF6?=
 =?utf-8?B?czVHREl3S3Zrd0twTHBnUG1QMk1LSDIyTFZvcHNGdXhDQkJKRG5JUjlKRVB3?=
 =?utf-8?B?UHlNd2ZjYm9ZenArUmh5NmN1ZXJjSnRXemJXRTIrWmtldHhadzNnV29SVW5a?=
 =?utf-8?B?N3hoK1R5R3E4aEdJV2NpUWZlcm5FVmV4NjdsOHorbkc3Q2kvbERXQmwvaTIx?=
 =?utf-8?B?MUNUWWo1a1Rody83YytIU3dMUzFsUGhlcFYzZUh5dFI2dEFuN1ZORFlRcHFU?=
 =?utf-8?B?UkNqSkJlQWV2RFJsREhTU296aVFnbC9DU3hTRkRJSDNwb0lTTmxsUFpmUUpa?=
 =?utf-8?B?dkw4U0pKd05ldkVWL3B2TkkxbWZyQVhGV1BQWFVYOXVEQXE2OWxHUG02b0xS?=
 =?utf-8?B?WkswK3lmb1BRZTRZMXZpZTdnVmhLUkZCTGdKUmlleUVYVGVjNlJQMHdUOWxO?=
 =?utf-8?B?TmZmRkNnMHBSeGJadHdqWFFyVDRGcVc2Y0dJa1RMSXRBSmdJM0dRVzh1bXlt?=
 =?utf-8?B?Qjl0YzRpTVBFSURkdkFSak1DeUp0RTJVS01IU2VrQVFmb3pBcUNJWkdJandC?=
 =?utf-8?B?UEh1ZDJVMzlUamNFOUZrcTJlV1JTQ2RGM1ZkUk04OHZaNzNCeEpER0lNSVpB?=
 =?utf-8?B?V1lEWVFHS1BRTWpWZnNyYzhTRGlWeVBLZS80TFlwYUw2WjZETndHcmdoNHRN?=
 =?utf-8?B?eVhxTVJEMVRvNWtPZHJDazVKL1MvZysyblBaTkdqK0FvR1N3Sk9aNkJuV0VZ?=
 =?utf-8?B?NVZna1VtaGtBVHM2UWtyek9STTMyZXc0SngzcU1JRmN4SXV6dzFqWFdkZzZ5?=
 =?utf-8?B?SzU1Qm5aZElvWXNteFJidGlXNXpLQjJaSVlkVGNnenZrWURYbXN6aHpGTkF5?=
 =?utf-8?B?NHJVR2dPZkM4eGs4ekJsTjFENWpVS01XQzdWSGVOL09aVkxzSWxmckZ4OCt1?=
 =?utf-8?B?NlU2UDh5RUhhdVpoVmFiZzJ0QlVCNWhTMm5uMGlrYzZwTWJEN1lZQjNDRWdI?=
 =?utf-8?B?NStYcElVYW1YenZNd2F6b2VaS1Bqd2VSVVBWeHFkMjlwVXFxa1YxVTZ0SGJH?=
 =?utf-8?B?R2pvRWk4eko1ZFVZa2JsdUpUL1RVdnVHb0RONWVIcHVNcURzUEp3VHFpV2tH?=
 =?utf-8?B?ZjZEMVFrVHVUdTJ0K3o4cFgrU1lpNk5wWktTcm1xdVlTb2RFUWNUQTlnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGNqYVhXQ0pGRTA3ZWVLUXp6Vm1tRW1lWkxWK2xUdGlBUU00V3IxeVAwRFVw?=
 =?utf-8?B?UWpJR1lOdWdqeFNWeHcxdUxYamw2VVBMa2EyMjJzdFpwWUpIWmxIT25jSmp0?=
 =?utf-8?B?RGRwMFRXQS9NblRCVG94Vk5vc3pLcnYrK3dTQlphYTEzdFlES0tCLzJmWEpJ?=
 =?utf-8?B?MWZFUFNUUHcvMjU4Q0tVU0QyaEZ1TFZVKzA4NUpvS2F0bEJQSjV2M1ZvOVRB?=
 =?utf-8?B?cmVHRmJBdXZIUVZTNW9CWVArLzNua2Zick1hRkJJOU5aVGJpOCszVUcybmpu?=
 =?utf-8?B?SkowTHYvQnQwWjY0NXFsb3lMYkZFUTZPVndwd3lRZzFKSGJBR0srdlBBaWFX?=
 =?utf-8?B?T0M2Wk1IRkZFRGI4WFhkQVh6cmF5TzhDOU1HYWZXMElLblZvZVdFVU15bW9w?=
 =?utf-8?B?RmFScms0ZEFGWGZwYzRMUVJ2Y1ErWWZaaW0wRXpWdmEvMU5tOERkcjFoOVFI?=
 =?utf-8?B?UmFjMWQrUC9KWk9BT09mMTlmUTRtZVNDT25hT2ZMMHk5MnJxS2RoK2F6dEx3?=
 =?utf-8?B?U2VhQUpUNXc0Q1d0TkxYL2N5VGc1Q2gzTGVKRTRtNHlGWGEvZlVNS1dxemNZ?=
 =?utf-8?B?Tnc5OGpFbTZ2cHIyZmdFYVl1OUYzL3RPWUsrSHBDcGl1L0NVaXdqeU1mdVpv?=
 =?utf-8?B?L2lrOFFjYksySUtsaERRWE9HT0p2ZnJwalcwcUxmL1hmdzJUMWlST3pPcnVE?=
 =?utf-8?B?QnNueUNQbFNwMnlxV1dncW1hOGlZbUt5NUpuakFvZWF0RW5EYTVWOWZPU094?=
 =?utf-8?B?aUt1SjF2Smh2ZkV6NlNjVElMOXk1Vy9UZXI5SzVRKytUSE4rVW0yT2tibmxy?=
 =?utf-8?B?bmxlRU0yZnN2L3hMRzVYVVpUUHR2cHRaWkdZUFpicUo1ZHFYMHpudHl5N0xl?=
 =?utf-8?B?a2FRNElLQnpsNndkSkZSdTlCNTlrKzZQWXFmTHQ1UVF5U05XaDBNeUFUT2Fm?=
 =?utf-8?B?SEY4QzJtaEhxWE8vWXlla2dLek1BU0tXRytNUWdlME1GR1V4YWsxTndaTk5a?=
 =?utf-8?B?Ulc2OSt0cjNVcjZqeWRkZVlZaVNRRmdFSG9Fd3M4RnJqOUNmbjNIZHN1aDZJ?=
 =?utf-8?B?a2pZZ3R5Y0FZeWtZeTZTWU5HbVhOcGptSjE1d1djTFYxa3RSalpoYUUxN0Q2?=
 =?utf-8?B?YTBYZEJwT0tLaDQ0SnVjN2t1TUthN0dadHcvS21valJuaXY1U28xZWlUSWU2?=
 =?utf-8?B?QWlxQjRBTE1SeXZCMkNsalk5YXcvalQ3NndrR2NCYnpzaDcrM1FWeWxRMTNl?=
 =?utf-8?B?ODFyWmdmcUdaZXZPMVZwTDdOZ01mYVJ4R1R4dDlBMU8xQmt6VmQ5bnFZRG9K?=
 =?utf-8?B?LytXcHJnN2toMkJNRXMzQzN3N0dUanpEOExtNUtpZXpLS0crd255OHg5MmI1?=
 =?utf-8?B?ZVlSN3NicVZUVWxtYXFzeXBlRy9RMFpyV0JFaWR1dnZvMU56Y0kwMk1VS0NX?=
 =?utf-8?B?VlFoOFY4T1EraktZdDdNWlhQdUJSTklYVFNZWkE1ZHlCbWtzMWdWYzN1Y2ZT?=
 =?utf-8?B?cC9JWWc3RkxuUVUyWTZPSWFWWFVabmN4WHVkU0lSTkFTNFRpYjIyWWxPSm83?=
 =?utf-8?B?S2NJUjdxOU45aUJnOFYyYVZBcnFnbkxZWWNIVDN4eU44eDFUeFJCR09OaWNY?=
 =?utf-8?B?bXFsYStpRmdmM2FKTUJwNmlLUTVqOTFsaWxwV3NzNlE5d1VvMFpvcXhBSTJn?=
 =?utf-8?B?NGE3Y0JRQ3pmbG9yNHZSUWVNSm9NRi82bjhuQ3F1N29hSXNUaTd1LzFvZlBB?=
 =?utf-8?B?NFJ6L24xQmZNbytRaC9qb3JnUU0vb20zdm5yajBWTjR2MEprVlBhcnpFdFJJ?=
 =?utf-8?B?MHpHT2lqWVNnVGdpSm8rVytkZUp2NDVDS2lveFUvallhcGJPc0R1L2g4RmEx?=
 =?utf-8?B?aUZzL1FIU2ZmUWpYM0dQTjhzQS9YMFcwcHpaSXAweGNNQUExY1lFSTAza0pS?=
 =?utf-8?B?b0YrdC9zY1A3eWxxcUd6cTlnaG1acUt0WHlnMkdRcnJiTTFEUkFtTGJMdUpS?=
 =?utf-8?B?TmYrU3hZWUw2Ny96ZzV2NC90cGdSb25PNmRKOHUyUmlReU1wTmJQNTlhNHlU?=
 =?utf-8?B?eUd1d2RuZkROMjR6QTlicUMvZmo1VHMrR2xnMkpUbVM2SmljUnVseE5wRDhM?=
 =?utf-8?B?amhUZWoyRTJCSGNubVlpcXZWa0l6di9tSGh0WWRZa3E0RFNINWRFNlpXbHIy?=
 =?utf-8?B?amRmME5HdzBZdW1NblY5ZVIvZFFnVXFhbFNDNWFwNVlaRzNqdk8zMEVsT1hj?=
 =?utf-8?B?SG9va3ZTVkFBY3A3NThqeFk5RVh3PT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b59f069-d97a-42a6-52ad-08dc6376dd40
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 09:22:15.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbbKxcvTbrWwUXXEKfiDGSaqFE2/Nq5LxhvT8GRuMOhYt4T61va6V0yPdz99XysjHEK0q0AYQPd6s3ZdKFoG8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4056

Hi Marc,

On 19/04/2024 11:29, Marc Zyngier wrote:
> FEAT_NV has the interesting property of relying on ERET being
> trapped. An added complexity is that it also traps ERETAA and
> ERETAB, meaning that the Pointer Authentication aspect of these
> instruction must be emulated.
> 
> Add an emulation of Pointer Authentication, limited to ERETAx
> (always using SP_EL2 as the modifier and ELR_EL2 as the pointer),
> using the Generic Authentication instructions.
> 
> The emulation, however small, is placed in its own compilation
> unit so that it can be avoided if the configuration doesn't
> include it (or the toolchan in not up to the task).
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_nested.h    |  12 ++
>   arch/arm64/include/asm/pgtable-hwdef.h |   1 +
>   arch/arm64/kvm/Makefile                |   1 +
>   arch/arm64/kvm/pauth.c                 | 196 +++++++++++++++++++++++++
>   4 files changed, 210 insertions(+)
>   create mode 100644 arch/arm64/kvm/pauth.c
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index dbc4e3a67356..5e0ab0596246 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -64,4 +64,16 @@ extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
>   
>   int kvm_init_nv_sysregs(struct kvm *kvm);
>   
> +#ifdef CONFIG_ARM64_PTR_AUTH
> +bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr);
> +#else
> +static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
> +{
> +	/* We really should never execute this... */
> +	WARN_ON_ONCE(1);
> +	*elr = 0xbad9acc0debadbad;
> +	return false;
> +}
> +#endif
> +
>   #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index ef207a0d4f0d..9943ff0af4c9 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -297,6 +297,7 @@
>   #define TCR_TBI1		(UL(1) << 38)
>   #define TCR_HA			(UL(1) << 39)
>   #define TCR_HD			(UL(1) << 40)
> +#define TCR_TBID0		(UL(1) << 51)
>   #define TCR_TBID1		(UL(1) << 52)
>   #define TCR_NFD0		(UL(1) << 53)
>   #define TCR_NFD1		(UL(1) << 54)
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53157..04882b577575 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 vgic/vgic-its.o vgic/vgic-debug.o
>   
>   kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> +kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>   
>   always-y := hyp_constants.h hyp-constants.s
>   
> diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
> new file mode 100644
> index 000000000000..a3a5c404375b
> --- /dev/null
> +++ b/arch/arm64/kvm/pauth.c
> @@ -0,0 +1,196 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024 - Google LLC
> + * Author: Marc Zyngier <maz@kernel.org>
> + *
> + * Primitive PAuth emulation for ERETAA/ERETAB.
> + *
> + * This code assumes that is is run from EL2, and that it is part of
> + * the emulation of ERETAx for a guest hypervisor. That's a lot of
> + * baked-in assumptions and shortcuts.
> + *
> + * Do no reuse for anything else!
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_emulate.h>
> +#include <asm/pointer_auth.h>
> +
> +static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
> +		       struct ptrauth_key ikey)
> +{
> +	struct ptrauth_key gkey;
> +	u64 mod, pac = 0;
> +
> +	preempt_disable();
> +
> +	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
> +		mod = __vcpu_sys_reg(vcpu, SP_EL2);
> +	else
> +		mod = read_sysreg(sp_el1);
> +
> +	gkey.lo = read_sysreg_s(SYS_APGAKEYLO_EL1);
> +	gkey.hi = read_sysreg_s(SYS_APGAKEYHI_EL1);
> +
> +	__ptrauth_key_install_nosync(APGA, ikey);
> +	isb();
> +
> +	asm volatile(ARM64_ASM_PREAMBLE ".arch_extension pauth\n"
> +		     "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
> +	isb();


Some of our builders currently have an older version of GCC (v6) and
after this change I am seeing ...

   CC      arch/arm64/kvm/pauth.o
/tmp/ccohst0v.s: Assembler messages:
/tmp/ccohst0v.s:1177: Error: unknown architectural extension `pauth'
/tmp/ccohst0v.s:1177: Error: unknown mnemonic `pacga' -- `pacga x21,x22,x0'
/local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:244: recipe for target 'arch/arm64/kvm/pauth.o' failed
make[5]: *** [arch/arm64/kvm/pauth.o] Error 1
/local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485: recipe for target 'arch/arm64/kvm' failed
make[4]: *** [arch/arm64/kvm] Error 2
/local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485: recipe for target 'arch/arm64' failed
make[3]: *** [arch/arm64] Error 2


I know this is pretty old now and I am trying to get these builders
updated. However, the kernel docs still show that GCC v5.1 is
supported [0].

Jon


[0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/process/changes.rst
-- 
nvpublic

