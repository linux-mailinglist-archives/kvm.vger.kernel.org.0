Return-Path: <kvm+bounces-66925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EAF7CEE756
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 13:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D1393031A1E
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 12:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EAE130F550;
	Fri,  2 Jan 2026 12:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mnFqQSSy"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012024.outbound.protection.outlook.com [52.101.53.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF9730EF7E;
	Fri,  2 Jan 2026 12:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767355757; cv=fail; b=Y+PHQE+G0pkQIyzzZ/1wCIevtBVSCblRjWGUKmpY0FKzTYKwyjry3kKnzesLtPkAANErq97lAsBVEwZs5QPp7CecnkWzMavvppHg/3EaD6wQWfKUSFJU1f3+WUOxc2mrs3BWcrRTLEuZ0ygCr05Smq1b5NKExVFvlXnxZDLATiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767355757; c=relaxed/simple;
	bh=r5F3vh/pRx2AlDUYOHJgLG1XVNlxBW3yfWCCM06cB+g=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sAyy5vqpCKUBb5ncUSb/cc76vzOhjvojI+KIy/yaWNvk8xuzYXtdatGMYfYXNO3oXa3b9b4e2Mnx9X/2k3CA1VIOuLZzzZWsadsDRZ19eREKXpdUxscIM31FR4d18Qc8Ii4yjkzHtuQ/hBapwg9Vn04FH3dS+CHvrzxjH57pPIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mnFqQSSy; arc=fail smtp.client-ip=52.101.53.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZveA6McocwRrJQ6rix+t6xDD0DPo23PL15mSRJBVrrPOBhGbjHUMBN3j819HKVpq/9aVxv065bHuX/3Ev59ZZ3BGpA2jKNRy50Eq0FWPyH89p0nQIi1KWiioDj9nDnhYBM+l6dNo3zEVYGmE8pBUAKKpqlpCym9SLOyQBX27T99EL9V1dJdT+xKO0hrE3wLXcutWXg6EA+vKNyvUyC0OnnXIREyBH0Bgeam/p9R0sBKYHLFCMeQI6EvCbGPkkekVZ3rV0z8XJkZa2Hk3XrR/vWZnB/4bGexJtgmbCS3B1MjAcdA8Y8kRB1OKLAKtwNlniPiGMhoyhPgBeGd8NcnqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxBCzQjcImqKC1Lo2cE1am9WdZLC/ElZBVRmKhJg3mE=;
 b=hpEgXo25hyvsd176VVkewMTWuXS6XtqY+OAp6iMDurLlD92eMJmZqEMflSwO5lTE7fWrUU6cgiAUVSy6NFRgwseA0ojtxLgjj3VPkU4S89LuKzz21s9IpIk8qovXu5RXcWb9b10do+z4VqS4xwxSYD3YEph2GLLBvVt8wqJi2OdyrgKSkWpUYfT2tepgyuNYBYEeWujh9r8S49xBgf5ylwT/WaFo5RTEzoMkZ8YuWQ6Od5E3xpor5AZzTAa0XUVWxDNVEr9A+HHdTIHx3J/B2K1l+7yu0khMspNlRwhpYRA99dCcALpk/zFSGTn4gjiB+DrpLvdoM6JJe5XUR32F9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxBCzQjcImqKC1Lo2cE1am9WdZLC/ElZBVRmKhJg3mE=;
 b=mnFqQSSyFdPMHOB8sBaR3myagDSTSp5F87YMIdONN6b4fmqnQ2OeoOLXMjG0+kdaIDiUiU6KJGWPeyWD7ne/jq9jQoYglvjauxv+DFswLojUf5ZyHqePslCobMqvnQn8IFGDEauovOZzKEygRycuc/Ioj761bR2PV10jFJtdU0I0o9hcWhWamM+MAhJEs/FcwEPl0O6ESLEVFWX3/MRqaSQmoA5FdalJHgHdI+I4fZH9S9Tp2JMxWRHvQSBb/VlEIz7WGT5ML3wq7cdHagKT3om+rKcxWZx1tEIgK3bKlcf+dKJiruq2gh5pR4FIM9tUmgXgcoyh26h08Sd3n11siw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Fri, 2 Jan 2026 12:09:12 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::7e7c:df25:af76:ab87]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::7e7c:df25:af76:ab87%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 12:09:12 +0000
Message-ID: <b7a12756-88b5-4758-8e6d-b6538458c81e@nvidia.com>
Date: Fri, 2 Jan 2026 13:09:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] vdpa/mlx5: reuse common function for MAC address
 updates
To: Cindy Lu <lulu@redhat.com>, mst@redhat.com, jasowang@redhat.com,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org
References: <20251229071614.779621-1-lulu@redhat.com>
 <20251229071614.779621-2-lulu@redhat.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20251229071614.779621-2-lulu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::18)
 To CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|DM4PR12MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f7f52d-a330-497b-662f-08de49f7be11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0R3QlNRb0drMFlKM1J2U3d1eHFTZnd6dUtRUWR0TmZoT0J2U0hHMlZ3bDA3?=
 =?utf-8?B?TW5XQkJva3dsT3RUbjEwdXVpeEo0dE0rS3ByZVVlSDFoTi9VQ21YZThPTUhV?=
 =?utf-8?B?UUtwUVdSbTF6N1NBOUhMR3NWK2Zod1lkWFRpMGtZbEozR1J3VWxFaVp3NWor?=
 =?utf-8?B?Zi9vdkg2ZG1FZVFKbWtzVy85U1JVa3BNUUNOVmtWWlJqVWhXSWFycEZDRU43?=
 =?utf-8?B?U2tKWVR2ejhnT2JDa2tSMVYvbEtmeGJiQUR3M2Y5MGVQdmNFUWpmUDlVNS9z?=
 =?utf-8?B?bEpqcWN4TE96UjMwWlBFaHBoUldSOVFHazZsZXV3a01lR2tTZDJjZ0lWYm5t?=
 =?utf-8?B?a2xPREdZZXFVcjluM0FqRU52K1FFRDdvaFQ1UiszcDRxdjlJSy8xdS9jY3NF?=
 =?utf-8?B?azlhR0lxQzF5Z2JsQkNWMkVaUnpuNm9kSkhHNU01eWx6bGFZNWNBeGtUK1g0?=
 =?utf-8?B?UjZndUhwZHpaRDJWUVhqSUtVQkV3RnU0ZzNsWmVubGlhQm5MMCs0Rk5MNnY3?=
 =?utf-8?B?TlVweEFwci9ZaUw2cTE0Ly94MExRSkFvc1BoRThUQ0ordTg1d0FHNkFlRjVB?=
 =?utf-8?B?aXQzUmxrLzFwcG5TZFN6eFhFbDBjcUhEa093YjNMZVVkdjNVaHRyVHlrdWR6?=
 =?utf-8?B?TEhlTERtd0JXQldkaklQbDd3RUN4UWRTK3RWVTFuVXBGUGJkWEFaU1N4cHdl?=
 =?utf-8?B?YXVkbzd0bFNZTEpHL2xhNlpXaU13YUVNTERaSEU1bHFQQ0x1MUh4SjZlV0hm?=
 =?utf-8?B?Q2tRS0hWeEtibEhJSGZmMXltSEhYekR3c3FIcWZmN1NLK0NyQWVKZlZmN0h2?=
 =?utf-8?B?czFoV1o5U0ozUWVLMW4zeDE3NS9JYURZbmUrTmROMncxanE1ODd0TUtWS3dQ?=
 =?utf-8?B?VTcxazc0STltODhia0pOS0dOczFETkFnbDNWUlQwZzFKVnhhZ055aStON2Np?=
 =?utf-8?B?djcvR2JGNlpXVTM0TUhsNG9FMmRva01ITU1RVjNXTGMxeXR5TFZxWXE4U3hL?=
 =?utf-8?B?cmZROHFXNmhPaDFiM0dtUlVMUmZXVFlnMm1zKzl4TnFwbGpmMllVUDRyL0JS?=
 =?utf-8?B?WjUxblV3eE0ycmJvUHJCU2ZjK3BUUWtKVjlya083cUF2WnMvcnJLV0sxVGVQ?=
 =?utf-8?B?dnQ5WkE0T0tvanZSOTMwVGlkSWQzVGFZbjhvbk0zU0J5bDBFNVU0VzhqbEU2?=
 =?utf-8?B?d1lkbUZCR1VYMWZVNkJ4c2NmdmFQODMrRUMwdWFpUXlwWjR5UjlQVS94akFo?=
 =?utf-8?B?TjhzenVJZUxvOHFsOG9vRHUxYzF3Qm16Q2MrR2VPL3c5M3RrTWdmaHFYMmZa?=
 =?utf-8?B?angxbkNJSEQ3RGRsemVGc1czdDNOWDJ6ei91aXRUQ0NNUHkxSVhTeGwrNXQ0?=
 =?utf-8?B?UWRnV1FUZzRmK293cWJoeS9PYmF6RHBDL0YxUTBFbG5oMUdTbmcwdUV2RVlV?=
 =?utf-8?B?U2hJV215SzhWYjVTNlhOd2ZZaHlqZnZ5YmZqcE1pZ29yZU5mNi9Uelo2b0NJ?=
 =?utf-8?B?SXJTTEtKTW1iMVVBRk5vK3QrV0NMSmk0QkdaVno2UDBKcVdrcWZHeVZlWGk4?=
 =?utf-8?B?OHBubW5pL0dGMHFZMWR1ei9seXJzazZOOVlta0ZmSHN5R1RBcjErTElvN2F5?=
 =?utf-8?B?eWs3MjViSU1SNlc3eTlDeUg5MHdNb0NNWVZzT3k5UmN6VjBXd3RVUDVLUHBj?=
 =?utf-8?B?cHJ5T1VWUGo4eEphcVJzTGRjMDMwZU9raUlsSlVDdkt3bjhySWNPcy9peGZV?=
 =?utf-8?B?MFNSVGZPUy8wc3NKcmlQSEM1Sm9pTHkyYTJrZnI4TzFWUFZnRWJyeTRObTM3?=
 =?utf-8?B?SHgvdUkzOGx2RXdNZHFib2tkM1lGY0orbmhjTWVvQXFkS2FkdGhYYUF0Y2Vu?=
 =?utf-8?B?U1l4UzVrOHdBb09SeHJydkMxWXJuUzdjcUlkYUJ5dHc0ajJUaW5WOFpMU1FS?=
 =?utf-8?Q?DJzQc+7BjtkK15c2OE74rR/Jr+kn9iYm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFZLVHJxKzdob09kSXdpY3VEa205OFFpbThkZ1cvQjVoMHBKL0cyZVByMXo4?=
 =?utf-8?B?QVJXMThzUjZOUk9vZE11NThCM2hYQUJjNWp2STBQQTZhamFVVlF6QUc0STFO?=
 =?utf-8?B?eGt1UjAveUdsNXdvMjRVWjBQeGtGTnkwWmt1TWVCTDBDdEljcy9XMUVVdFJj?=
 =?utf-8?B?U3gzWnIxVW1kaFAvc2JoL3VuanpQaWswblFSN21uQ0NyVFYyUFg2QjVjSHlx?=
 =?utf-8?B?alVycnNaTDhwWWlXOHZMWWtxV28zdFNoTlFCeCtnYVc3Yzdia09zWDBIbTdH?=
 =?utf-8?B?RktzZjdYODZDNFNLV1IzOW5IU05wL01XekRBVENZTzlsNnpFVGhvT0hueGp6?=
 =?utf-8?B?cm00VC9JeStqNjJKWFJaZUN2VnUzOVdicCtCMDRpV3VqaHVvUjVVcUZOeHlJ?=
 =?utf-8?B?ckxWczhZMTFMM1NKdUdXOVJkMDBIM1NTOWIvYXlvU1A5YTRhN1VXNXhXQkhZ?=
 =?utf-8?B?VVV5L01aYTJERktnbzArTGl5dzY1OUdZRERxd1QxTnJybDNmdXZLMnpWTFds?=
 =?utf-8?B?R3ZLcHArRi84SDloM2lYSW13SmxDc3FldnRpOEVBbzNmOFBPUEsrNStIbEpF?=
 =?utf-8?B?L25tZm5zb2ovYTQ3VVNXL3VMdnVGc1VLcjRnVnY2M0JSTFF3OVlTSjdQRzRj?=
 =?utf-8?B?VC8wdHZ4TDZkUldDM29ZVFBNN2JweTNKNHdIdUMvL3pwTmFJWndIUGlzQk9x?=
 =?utf-8?B?c2x3eVBNRDRZNnNoY21NNEUvYmdGeGYyOXpKbUJ6Q2lZYllpMVJNSllJN2RV?=
 =?utf-8?B?ZDc2YWdpQjNqMmJsL3hsNzVFTnFTSzVMTENhY1ZtRzlFVm9PTDlUdFBaeVhj?=
 =?utf-8?B?dGZySWZtMXN2c051N2FrcDRaT3Y4QXBBcGVRTGZiT2pRNGRneTUvcTdHYjVa?=
 =?utf-8?B?dktJeWQ1VENkTXFZeUFJTWF6M3o5WVUrOEUveUllUGhucjZDR1FTTlhSU3Vk?=
 =?utf-8?B?S2lsU2JzSmw1VjhYODl1cnBTU1E4ODFMYmR2SzZNUFZvOFRGcE5TMXNHSXlR?=
 =?utf-8?B?MlhMenRwTDl3Q0JaQjhsSXd5YXBEc0cxV2hmZ1FWQlo0d2tXYnNVT3lUVFZ3?=
 =?utf-8?B?TDc2bVRqN0pvQmJ3NUgxckMzWXVVQjhnQ1Q5WEQ0RkpabVllbVQwL0tZb1hB?=
 =?utf-8?B?ZjdhOEp1YmlGbmhPSHQ0NHhnclhMVlNKV3NVTndCZTZud1NuVmhrN1pmWEhk?=
 =?utf-8?B?NEZ3WmdLOGhjZDA1Y3JPY1AybGRHenBsb3U0dFVxYWV1L1BCZDZIQlZBbTY1?=
 =?utf-8?B?VWhwZ2Ivb1lvV3FiWGlqQmZuS3R5aEJoMkVCdE13T2VEV0tNeitxZUIwNkVU?=
 =?utf-8?B?MmZENFE2VkJ4dDVHTUozMEZ2WENyMTA1WEJYZzg0azNQb2JmVno4RUNIVzhL?=
 =?utf-8?B?RWU1cEQ4akVYdnhaLy9WVTdLRFpDWkhzandnR2NJbUNPNDlSRUJtbU5CdEw4?=
 =?utf-8?B?cWREUitLdDZUbCtQZ3VpSHZ2azZ5NlhuOG1sbDJTTkEyRFo0WmtSMzhmVkJO?=
 =?utf-8?B?NDdCRXV3dW9zM1RSTzhIeVlTUWxZYkdYMUtKbkVqSmZ2cm5iZ2FsaklLeTZv?=
 =?utf-8?B?MmFlTmZPR2pjcTgvYjZwYWF4SzkzeVlBbVVSZi9aUldZckorQW4yOThMaE1M?=
 =?utf-8?B?elhZWldad2ZxYzIrQ2tvYVE1aTFzNWRLamhDd0YwcEM4cGZ2WDJwc2JDSEtS?=
 =?utf-8?B?T3BGaHJMU2xXdnI3L2lnYW5JdFJSeHV2MTk2K1JnNlZ1S0FCNVRWWW9xcDdO?=
 =?utf-8?B?QVNPUFdJVnp2elY1VlJNbGc2U0pKV09TZXFnVmZONWpoZm1HakdWMG9meCtj?=
 =?utf-8?B?Y2c3ajIvUjI0NUZnc1BsWmlQbXlLVkNOVHg4V243YzZxMWE2aFM1dFV6Mkpv?=
 =?utf-8?B?QUZMYnhSSzZ5blpWMkRJaDdLcEVCRHhNVUhiZXRFc0hqejY4VEhxUmtVWXo5?=
 =?utf-8?B?WHBDb2VmWXd1NlJndHJ5blNIVzVCdkF4YXd6UHNpTkJqSFVGU3BoM0tXVWdF?=
 =?utf-8?B?WVUrcXd1ejdUK1d1SWFqSDI0UjNqdFZSTXJFRVlPdkNLVTdEOHYzOGpWWkpx?=
 =?utf-8?B?eG1Ed016RVM0OEpOVlVXeCtKR2lEdWcyNC9XT0FkejVyTDZYWFFCK1pMM243?=
 =?utf-8?B?dGpXUzhQeWlvb0sxM0N4ZVNhanBMb3pqUkNpd2FBUjVpNWtPMDR3VzRueE9r?=
 =?utf-8?B?VW1ZYVNSdDhNeU50VFZFVUdISzVHMmROR3RVWjlpMTdObklsVFU0U2UyeXJU?=
 =?utf-8?B?R1lZMmNWYXVHd0xMc2pOWm9admk3Q2dEbm1nNXpsbHMvNWU4WVZNWlU2czhu?=
 =?utf-8?B?VHNyRjV4MVk4anJrY2toRVlsOTFpNE8rUXpWZGFtQmZ1S3ROKy85Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f7f52d-a330-497b-662f-08de49f7be11
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 12:09:12.8659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1u8SZnjdnf/704Iy3JEPKN8T3ouabuq2X/xVqSKcQlG+Tr1gIG2O4n/3DbOzVWU6mkUdOmyn7SoUSopbvss7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6373



On 29.12.25 08:16, Cindy Lu wrote:
> Factor out MAC address update logic and reuse it from handle_ctrl_mac().
> 
> This ensures that old MAC entries are removed from the MPFS table
> before adding a new one and that the forwarding rules are updated
> accordingly. If updating the flow table fails, the original MAC and
> rules are restored as much as possible to keep the software and
> hardware state consistent.
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 95 +++++++++++++++++--------------
>  1 file changed, 53 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 6e42bae7c9a1..c87e6395b060 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2125,62 +2125,48 @@ static void teardown_steering(struct mlx5_vdpa_net *ndev)
>  	mlx5_destroy_flow_table(ndev->rxft);
>  }
>  
> -static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
> +static int mlx5_vdpa_change_new_mac(struct mlx5_vdpa_net *ndev,
> +				    struct mlx5_core_dev *pfmdev,
> +				    const u8 *new_mac)
Nit: I would drop the "new" and leave it mlx5_vdpa_change_mac?

>  {
> -	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -	struct mlx5_control_vq *cvq = &mvdev->cvq;
> -	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> -	struct mlx5_core_dev *pfmdev;
> -	size_t read;
> -	u8 mac[ETH_ALEN], mac_back[ETH_ALEN];
> -
> -	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
> -	switch (cmd) {
> -	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> -		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)mac, ETH_ALEN);
> -		if (read != ETH_ALEN)
> -			break;
> -
> -		if (!memcmp(ndev->config.mac, mac, 6)) {
> -			status = VIRTIO_NET_OK;
> -			break;
> -		}
> +	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
> +	u8 old_mac[ETH_ALEN];
>  
> -		if (is_zero_ether_addr(mac))
> -			break;
> +	if (is_zero_ether_addr(new_mac))
> +		return -EINVAL;
>  
> -		if (!is_zero_ether_addr(ndev->config.mac)) {
> -			if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> -				mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
> -					       ndev->config.mac);
> -				break;
> -			}
> +	if (!is_zero_ether_addr(ndev->config.mac)) {
> +		if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> +			mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
> +				       ndev->config.mac);
> +			return -EIO;
>  		}
> +	}
>  
> -		if (mlx5_mpfs_add_mac(pfmdev, mac)) {
> -			mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
> -				       mac);
> -			break;
> -		}
> +	if (mlx5_mpfs_add_mac(pfmdev, (u8 *)new_mac)) {
> +		mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
> +			       new_mac);
> +		return -EIO;
> +	}
>  
>  		/* backup the original mac address so that if failed to add the forward rules
>  		 * we could restore it
>  		 */
> -		memcpy(mac_back, ndev->config.mac, ETH_ALEN);
> +		memcpy(old_mac, ndev->config.mac, ETH_ALEN);
>  
> -		memcpy(ndev->config.mac, mac, ETH_ALEN);
> +		memcpy(ndev->config.mac, new_mac, ETH_ALEN);
>  
>  		/* Need recreate the flow table entry, so that the packet could forward back
>  		 */
> -		mac_vlan_del(ndev, mac_back, 0, false);
> +		mac_vlan_del(ndev, old_mac, 0, false);
>  
>  		if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
>  			mlx5_vdpa_warn(mvdev, "failed to insert forward rules, try to restore\n");
>  
>  			/* Although it hardly run here, we still need double check */
> -			if (is_zero_ether_addr(mac_back)) {
> +			if (is_zero_ether_addr(old_mac)) {
>  				mlx5_vdpa_warn(mvdev, "restore mac failed: Original MAC is zero\n");
> -				break;
> +				return -EIO;
>  			}
>  
>  			/* Try to restore original mac address to MFPS table, and try to restore
> @@ -2191,20 +2177,45 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
>  					       ndev->config.mac);
>  			}
>  
> -			if (mlx5_mpfs_add_mac(pfmdev, mac_back)) {
> +			if (mlx5_mpfs_add_mac(pfmdev, old_mac)) {
>  				mlx5_vdpa_warn(mvdev, "restore mac failed: insert old MAC %pM into MPFS table failed\n",
> -					       mac_back);
> +					       old_mac);
>  			}
>  
> -			memcpy(ndev->config.mac, mac_back, ETH_ALEN);
> +			memcpy(ndev->config.mac, old_mac, ETH_ALEN);
>  
>  			if (mac_vlan_add(ndev, ndev->config.mac, 0, false))
>  				mlx5_vdpa_warn(mvdev, "restore forward rules failed: insert forward rules failed\n");
>  
> -			break;
> +			return -EIO;
>  		}
>  
> -		status = VIRTIO_NET_OK;
> +		return 0;
> +}
> +
> +static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
> +{
> +	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> +	struct mlx5_control_vq *cvq = &mvdev->cvq;
> +	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +	struct mlx5_core_dev *pfmdev;
> +	size_t read;
> +	u8 mac[ETH_ALEN];
> +
> +	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
> +	switch (cmd) {
> +	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> +		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov,
> +					     (void *)mac, ETH_ALEN);
> +		if (read != ETH_ALEN)
> +			break;
> +
> +		if (!memcmp(ndev->config.mac, mac, 6)) {
> +			status = VIRTIO_NET_OK;
> +			break;
> +		}
> +		status = mlx5_vdpa_change_new_mac(ndev, pfmdev, mac) ? VIRTIO_NET_ERR :
> +								       VIRTIO_NET_OK;
>  		break;
>  
>  	default:

Besides the nit, the code looks good. You can add in the next version:
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos

