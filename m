Return-Path: <kvm+bounces-48743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D428AD23E3
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 18:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ECDB162B44
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 16:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0983021B9C0;
	Mon,  9 Jun 2025 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="QSdA+QYi"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR03CU001.outbound.protection.outlook.com (mail-westeuropeazon11022094.outbound.protection.outlook.com [52.101.71.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF3B21ABD0
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.71.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749486414; cv=fail; b=Z1C8rNhGqs0W/skfANZGLW8d0kP+GaFE862esiqQo93VjFv1v5NZgxymTvJi/7Xwpi1Bbk9+sagpVvovQJbKaGE5EvQIXFxoeO27v8R2A9ipxiH4IENNSgzxDJs6oxyDwM+ACgJroBcEv0pyN41BbjSY/K1qf9QFA1wVlgirv60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749486414; c=relaxed/simple;
	bh=rpjWawORIaFSbMIf+LsSy7p2UIZhaqZ3+ddbOYEc1LY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p+fg4bs251t4Fu9jWlzQ1KQAJBrZodNE80I3WbjZ77GIBcDQdeyc60MipLjiGp4dm+CBSG+ZxNN8Aj8bi4AXHcP/K+oYSkoYZkm4WN6Ww61+VIrSZPw/zfL76rfPlfHZrj/ef5NkW7TFmddqooV2UFaUwKxkEH9yi5GgPmLCPX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=QSdA+QYi; arc=fail smtp.client-ip=52.101.71.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V6Jr10/N1oTyvRG9nCaCk/wUg76NxJcGakdoFthH90gsXUxObK2IznhST7o5Tlx6uO+5vsA0JCGCZPl6/t+l7U9xNqc+Us9y7LKAq2h/esFk7VYsOxebTydz5yxNfbhw1AJCQf79m9jhADOfZ5vj3p9HwTfAn0+qvqdpgHM9WfbgeH+DN5ML2xeg/6XC0Ka2+g2ykO65HDqBt3WNyhanjH1wPb9Oe6mu8oKz5FNjOjqF0HhRA2CzVSUibO9CFfue/EZBpmbUma5hbfYiTYuyIntAihXuJHixr3kfHH5UnUQOV3NGhTqXjEOfiqhf/7arnia3KcU5xiVBATEVdBdkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3f6aRw2O++RIC2wpPVz6YT1C02rccv8xiDYBKaMZH4M=;
 b=J8I2xAYjntYf9N7EHN43uOPcFNDwJiAW0EElITx3+jkHSgDxCT3ZWEjJMhBILlCrEYnTZFztklkTVBg+Mz3j0PvqYRPSHB7IJR7Pq68SLbeSvFt6xhn1KHkTj7eH1rpCqhGMMtRMPtKSFUbWt81saZC3AZyQMsRJxhEXxxw/6Mj/rzllvdMUukT9sWp+Z5NtQoHPMcim4pV8U8wLbk43mb+bLL9KMR2IYdi46TQ+f9zY08KGfnPx/imXRwOtH8E4AsQiC1CwspSOUFbMELP1VriUSy7A570aj5NaMSmjtOdDdIhKm99bTOPW84gU3nPUA8oTGnhBKDgfDVrkf4oozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3f6aRw2O++RIC2wpPVz6YT1C02rccv8xiDYBKaMZH4M=;
 b=QSdA+QYixl7R2rHBgHDglX74SSnZbc7+Bg4MCwWmOMllHlI4tOJDF4KO91JGXmax4o4NbaHvqnI5dkiI8PcVajAc5zsIe8CrXcsM7oJeOS/4MKIxlRpi/zEHSEQ4H6QCYdXV8FFsXQL/dQGumW9h+LPNUqbZLoB4dfOlRBIsB3IpqFPsPstv7uPc0kpZtzKBDRsAuzgjJTV658Zz3ZwT6k42HbZ0dpX1YhuHqWrNm3W2FKVcBTGJ16/qrVJl6f9QYVXPInfdhk3T0uB1ZjNWPv9B3zKpDJMgEsSs0HeEfRN5IXIXCdyj8g1QWTodYh7zvEIrodOnGfkJhDa1ld0R2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AM8PR08MB5810.eurprd08.prod.outlook.com (2603:10a6:20b:1d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Mon, 9 Jun
 2025 16:26:49 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::59be:830c:8078:65d1]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::59be:830c:8078:65d1%3]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 16:26:48 +0000
Message-ID: <4f19c78f-a843-49c9-8d19-f1dc1e2c4468@virtuozzo.com>
Date: Mon, 9 Jun 2025 18:26:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with
 SGX
To: Paolo Bonzini <pbonzini@redhat.com>,
 Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>, zhao1.liu@intel.com,
 mtosatti@redhat.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, andrey.drobyshev@virtuozzo.com
References: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
 <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com>
Content-Language: en-US
From: "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI0P293CA0007.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::10) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AM8PR08MB5810:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ce34ab-13f2-4199-8c23-08dda7726ebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aExNNjRaSFIrdU5qVGUvenFqQnlJY3FHRlBMRVRSZDFvcXlSdmJyb1dKT24y?=
 =?utf-8?B?bjhrSmc2b2dBQVljQzFldHVlQzJ4eUpSNVBnTG9sWWg5RVVIUjgzeE9oMURz?=
 =?utf-8?B?K2FtTlFVcXNnWDNEWFRFbmNLYWJDd3VMQm5qSFJxMU16ZEdSZzZSUUJINEI3?=
 =?utf-8?B?a3NvNUM1VHNSVHZCV2xvNE9xbkZac1FTZWlCY3dBMCt5dUlXamdGRDF3b1RW?=
 =?utf-8?B?bEdCTTBSa3lRakpnMDl3YWhaWklzajU5eGRHR0Z4R3JVSnZ2b0FnbWdMUVR0?=
 =?utf-8?B?MUlSUkxNRGNmQ1htZ28yNzY4SHVaSTRua1BrY3h1YkluWEpNZDRMZldRZDdl?=
 =?utf-8?B?cGYrL0tjd011WUY5WGJpeXZXUElVSjNHc2pqZ1FwV2RYclUwTDNrdkFwRUky?=
 =?utf-8?B?ZlorRTh1VVNWRzZZbVFxeGp1RTNwQjEza3p5L1dkd2RoN21NV21LaUhUNW1Q?=
 =?utf-8?B?aVZLQVAyamRXRHNNWFZ2KzBsdFN2dnJLdS9YYjJ2L2NER1drb0hzS2djRlVO?=
 =?utf-8?B?UWxyOGtlMWpMc3Nnb3NkRmVrQituNWhoZlpoa1ZGSjM1N0NVZ29OYnpVTitw?=
 =?utf-8?B?bzVmbjJIZVE0OWtza0l1MDVFRWhZNFhoTnhlY3d4Tzl2VFRLcDMxdGJFQmpj?=
 =?utf-8?B?ZFBpTUVBWWZRaEcwc1prekcxa0FMQVg4UmdMY011Myt6Q3pvek5wVi9mRkhx?=
 =?utf-8?B?SVdHTitCQkNaWmI3elNCZGdreWxpMG0wR1VLOGJCbXJXa2ZqZEFoZ1hlM3FX?=
 =?utf-8?B?b0Z5alhKUCtLUDJwb2NtZmJFMmF6TElFRFI1M0x5OTFXM3RBc09ZY3ZpS25C?=
 =?utf-8?B?K2loeldtRjJJNlA1SkhsVmlQTkRuSlMzT1k2ZkNHVWRRd1QrczFuSTdGeW9B?=
 =?utf-8?B?czBWTWwzUUc2MXNyck50M2JTNkdYYXA1ZEJxZE5GTWc3amtzQ2FYaUttUHJM?=
 =?utf-8?B?K1NPbXoxKzNLS1NrZWpNaHZGZ3V2ZmdCVGo5aDVsazZnRG01WWJTRVlqRGVE?=
 =?utf-8?B?VzhuZGRyMWo0QTZNRHA0MUg3eFY1bmdkZ2h2MlVaZGh4OUF1RGR0SkNmZXhL?=
 =?utf-8?B?L1A0TVZSdUh6NTFQWUFpK3hyY1FQZWk0YmFMQXUvYkVZME5VOW5WbE9zNnlN?=
 =?utf-8?B?M0JtYVVmbXczWlo4cUM1dnJ6QjgzQXpDQzFVSXYyT1d1NVFoSW8zZ05mYnQy?=
 =?utf-8?B?YTE0QTFzejBXZ3R2Mm5WYksvOVFrZUZZNlRVWnlXbmNaWCtEWWwvNUpKRndP?=
 =?utf-8?B?R0UvR0lnRDJ5NzlvL2NuZkVXNXp5c1lnbmdJWlBlWkhWRllRSm1uWkJqS29J?=
 =?utf-8?B?ZElJMkJLWklrb1R1dDU4MVFQbEZmRW52MTdTNXZEWWczZFcrdTVBVWFSaDNy?=
 =?utf-8?B?VmsyTWtMSEZtb2ZQanRVVmk4VVF3QjlUemZrbDhnM0U2aWR5T1Vva1VvV3pO?=
 =?utf-8?B?QzFMRjRpUjAwdUZ4enl5WGUrVzFwcnJaZ3g1NmsyWVdLOVp4L3JVd29PUEor?=
 =?utf-8?B?dG9sSnRjTEJqclJTaXN6TDhFbHh6OTA2ZkE3bnlock12SlFvN0drcmZFbnZH?=
 =?utf-8?B?ZDh5VTMyOERuOGs0VGN5NjUwWHFDME9ic3ExdjNpZUdBaE51UVFpSXdldXdQ?=
 =?utf-8?B?cU56ZXhxYkY5eU1ObGRNcnhBMi94Tld6UlVJN0pMM0U2MFVLelJBcS9VVm1I?=
 =?utf-8?B?TXBQUVZTR0tlYVdURzZpM2E3Qm9VcmRwVVlYb1JDVTFRbDBVcWpiT1cwNmpN?=
 =?utf-8?B?UURkcUpNcVZnZE5GNVJmLytFcEtrc2RSTTEza0NXbjRWQWdnM0I5ZXQ5Tm8w?=
 =?utf-8?Q?rTV/rqYGAr5nn9I7zpbWFlstjFYOvEliX8aPA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3RHQ3d3M1Y2MTM4RUpuU21XUVNoNldYcHp6dlc0dUhoWUo1allFTVk0ckdl?=
 =?utf-8?B?WkJMTGdkZHdqTE5TQjJ1ZUZGWXFzckNTbmROWUY5UEVRR1ZGMndXTXJnSXMx?=
 =?utf-8?B?ZzlRdDlRVUY3Z3ZwSEdiWHZuUEFmeUtmYVpETE9qR2l1VitDTUdyL29aUVFq?=
 =?utf-8?B?aHphV1JVOFJBWnd3a1crbTlSY1B1WjdSbGlneXhnZlRGb243Y2o4ckhWUkpX?=
 =?utf-8?B?Q2c0bkhFcTZGN0FFaDJBN2poVUVTK3NidTF4alJCMmUzWkZPdG05dUNYMklS?=
 =?utf-8?B?eE5WNnZEdEd1U29DbHV4NGxudFpsbU0zZ2RnTjc4elhQYllEM3AxTVgwWS9C?=
 =?utf-8?B?bmJ6RUJOTVcvVjRIekhETGVTU3NoNjFVeUZEUERPMERyZEhjMmV4cVhCL1Ft?=
 =?utf-8?B?bG0raTAramZIWUtpM0Z3SXJpeUpTaFNqME56TkkrNTBXbkJWUXFGdGs2QmVy?=
 =?utf-8?B?alBQbDdVY0FKY3FxZm5Fcjl3M0ZsOWR4bjBlczlkcjRWRWxpUHZuRUNEZndq?=
 =?utf-8?B?Rlc4L2M1a09HN1dja3QxbWtTZnp2a0JOOGs2M0owTXpXZlNRejNpUHFaTGk0?=
 =?utf-8?B?WXFRZ1k2SEFuYWxsSjdhczV1ZmZqYVYvYXMwV3A5RGs0Y3JVSmYxblh0YjRI?=
 =?utf-8?B?elNXSGFjeE1jTHBYZVVKdkp0em1NeHhnVlJKNVNJY0lQL2pWNTNTc0o3N1N5?=
 =?utf-8?B?aDdhd3R6cmJ4RDRUYmlzVVRTb0lZZmZtMmtCQmJhTitTSzhpelcyODlCZkoz?=
 =?utf-8?B?L1VmbVd1cnN5NVNSQm9selhNVkxLWXU0Q3N2UG9Ec3gxV2R2N3hzR3VhSGRJ?=
 =?utf-8?B?ZmgwQjc4ZXQxNkM1TUFjOXlOWGVzZWZLclVRc1hUSlNqcm1KTElMd2g4QXdi?=
 =?utf-8?B?NW9iWk1tUjI3Y1U4akNrR0RvV1grcGcxZHRlQ0tkUVUyTWFRSlVsQkRPTUdW?=
 =?utf-8?B?SWdSbXZWUnIwS0M0TG16M1FHN1E0eGtLUDhZME5BaTEyWTV3ZExLeHJCaWFr?=
 =?utf-8?B?TmtKNVh2ejA1Z2RzeE1HbUMxMXVuQUZabEJ6L0h4cWRWTnNQYi9QRk9PUmNt?=
 =?utf-8?B?QUUwcHZxN29vQkVOaVQxZkE1WkJQS0kzYmR4MG1lclc2SXJPNFh1OGFQSzgy?=
 =?utf-8?B?bWlVeXpkL3VJRXo4M1ZCQ2N5MkJPaDJMM0N4U3JGZ21pQmNaSHJ6MTNXTlJ3?=
 =?utf-8?B?QXV6WVRiUmdpaVpnWWZPUElQOE5CbE5DNFI5VmNRSE1lVjJDQ3l2MHhKVVNh?=
 =?utf-8?B?c3RNd2xCbXNMR09sSkxxSDAyaXdxak1VVExna1dxZUluNkt0TDdrSDEzUkUr?=
 =?utf-8?B?UEcvTUlVdU5oQmpkWUNQNHBHSGxOK3hpWjNsY1lZVEdXV3hRQWZTQmZrL2Z1?=
 =?utf-8?B?Y05OZTdvd3ZaN3RRRmp0MWNxUWJ5YXY5bGRzOFRwaGcvSlE4S0RCVUtJRWJF?=
 =?utf-8?B?UzhPdUZWNncwZ3Fjb1oxL1dhcW9yMEZtWXJXS3kvc3BhNUJHdWdTQzUrRjNx?=
 =?utf-8?B?VHpWVGVHT29ldnVHSDFROUhMUW15aEZhVWh0Ti9uRXFxeEx1OGMyVk82VmVP?=
 =?utf-8?B?UkdIcjhkYzFVc1hzcUNLWmFCS0Mvc2dsSDFXdSt3dXBNUTFaT29ncXZ3M0xN?=
 =?utf-8?B?S0hKYXNBQXFNY2lsR2hKOTJvVlgzaG9xdEVoYUdzaWJnVmw3bVV2R3FNbnQ4?=
 =?utf-8?B?UGN4NWhvU1BFTUlTVG0wTDc5aWUwVG5mMjZ2UTZodmw4VEpCcHMzVzJtbXZV?=
 =?utf-8?B?MXVMd2E0QW1RQ1ZrOVUwd3BWMm5RU3hRN0c3N2orYkNKVmRvLzY1ZW44aXBn?=
 =?utf-8?B?Yzg2VHRLNE5rMnEvQ1ZGRVhSQWNCSFZOL1R3cHB6RnNnMksxeEZ1NEVMdTZX?=
 =?utf-8?B?TUNuWExWYjRySXk3d216cnk3dFVFbDlvS0QzNU1RNEpzVzdiUHhQTDlHaUVa?=
 =?utf-8?B?RWZNZlBUeHg2T01vbjVTS09zWGlPbWY5ajNUeW1uRFcvTG9KcVZ0ekJjaUZq?=
 =?utf-8?B?SkRvNi93d3JQeXlNMGhsek5pOEFXQ3AxbHcwUTdYVWJyRmdYWVFMNGhpYWo5?=
 =?utf-8?B?a0k0TER5NXkvOFp6M0Y5Qmk0SkxOZTVreXhXekhLeWdRelUzVU5QQ1RQUkYv?=
 =?utf-8?Q?NK4NAfh6UiT2VG4iUBqRaNQVZ?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ce34ab-13f2-4199-8c23-08dda7726ebc
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 16:26:48.6537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDx4YuLAxJ3+UWEEBwoiu8x2fdDJ7rYjrqd8mj7iEhh4teUCgl7eDzRLb/Vb7rNFXPQTOkzJbJqq8vvfzzQ3Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5810

On 6/9/25 18:12, Paolo Bonzini wrote:
> On 6/9/25 15:23, Andrey Zhadchenko wrote:
>> When hotplugging vCPUs to the Windows vms, we observed strange instance
>> crash on Intel(R) Xeon(R) CPU E3-1230 v6:
>> panic hyper-v: arg1='0x3e', arg2='0x46d359bbdff', 
>> arg3='0x56d359bbdff', arg4='0x0', arg5='0x0'
>>
>> Presumably, Windows thinks that hotplugged CPU is not "equivalent 
>> enough"
>> to the previous ones. The problem lies within msr 3a. During the 
>> startup,
>> Windows assigns some value to this register. During the hotplug it
>> expects similar value on the new vCPU in msr 3a. But by default it
>> is zero.
>
> If I understand correctly, you checked that it's Windows that writes 
> 0x40005 to the MSR on non-hotplugged CPUs.
>
>>     CPU 0/KVM-16856   [007] ....... 380.398695: kvm_msr: msr_read 3a 
>> = 0x0
>>     CPU 0/KVM-16856   [007] .......   380.398696: kvm_msr: msr_write 
>> 3a = 0x40005
>>     CPU 3/KVM-16859   [001] .......   380.398914: kvm_msr: msr_read 
>> 3a = 0x0
>>     CPU 3/KVM-16859   [001] .......   380.398914: kvm_msr: msr_write 
>> 3a = 0x40005
>>     CPU 2/KVM-16858   [006] .......   380.398963: kvm_msr: msr_read 
>> 3a = 0x0
>>     CPU 2/KVM-16858   [006] .......   380.398964: kvm_msr: msr_write 
>> 3a = 0x40005
>>     CPU 1/KVM-16857   [004] .......   380.399007: kvm_msr: msr_read 
>> 3a = 0x0
>>     CPU 1/KVM-16857   [004] .......   380.399007: kvm_msr: msr_write 
>> 3a = 0x40005
>
> This is a random chcek happening, like the one below:
>
>>     CPU 0/KVM-16856   [001] ....... 384.497714: kvm_msr: msr_read 3a 
>> = 0x40005
>>     CPU 0/KVM-16856   [001] .......   384.497716: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 1/KVM-16857   [007] .......   384.934791: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 1/KVM-16857   [007] .......   384.934793: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 2/KVM-16858   [002] .......   384.977871: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 2/KVM-16858   [002] .......   384.977873: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 3/KVM-16859   [006] .......   385.021217: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 3/KVM-16859   [006] .......   385.021220: kvm_msr: msr_read 
>> 3a = 0x40005
>>     CPU 4/KVM-17500   [002] .......   453.733743: kvm_msr: msr_read 
>> 3a = 0x0        <- new vcpu, Windows wants to see 0x40005 here 
>> instead of default value>
>>     CPU 4/KVM-17500   [002] .......   453.733745: kvm_msr: msr_read 
>> 3a = 0x0
>>
>> Bit #18 probably means that Intel SGX is supported, because disabling
>> it via CPU arguments results is successfull hotplug (and msr value 0x5).
>
> What is the trace like in this case?  Does Windows "accept" 0x0 and 
> write 0x5?
>
> Does anything in edk2 run during the hotplug process (on real hardware 
> it does, because the whole hotplug is managed via SMM)? If so maybe 
> that could be a better place to write the value.
>
> So many questions, but I'd really prefer to avoid this hack if the 
> only reason for it is SGX...
>
This problem was originally reported in the scope of
     https://gitlab.com/qemu-project/qemu/-/issues/2669
and is fairly reproducible on
   vendor_id    : GenuineIntel
   cpu family    : 6
   model        : 158
   model name    : Intel(R) Xeon(R) CPU E3-1230 v6 @ 3.50GHz
   stepping    : 9
   microcode    : 0xf4
We are blocked completely without this patch on our test
cluster with this hardware.

BSOD is namely the following:

|MULTIPROCESSOR_CONFIGURATION_NOT_SUPPORTED (3e) ||The system has 
multiple processors, but they are asymmetric in relation ||to one 
another. In order to be symmetric all processors must be of ||the same 
type and level. For example, trying to mix a Pentium level ||processor 
with an 80486 would cause this BugCheck. ||Arguments: ||Arg1: 
0000046d359bbdff ||Arg2: 0000056d359bbdff ||Arg3: 0000000000000000 
||Arg4: 0000000000000000|

|STACK_TEXT: ||ffff9b81`085768e0 fffff802`adadfa45 : ffff9b81`085771b8 
00000000`00000000 ffff9b81`08577160 00000000`00000004 : 
nt!KiStartDynamicProcessor+0x417 ||ffff9b81`085770e0 fffff809`d2c11c08 : 
ffffab8c`dbbcb820 ffffab8c`e4561e40 ffffab8c`e4561e40 fffff809`d2c0c340 
: nt!KeStartDynamicProcessor+0x69 ||ffff9b81`08577110 fffff809`d2be4363 
: 00000000`00000001 fffff802`ad6e0000 00000000`00000004 
fffff802`00000004 : ACPI!ACPIProcessorStartDevice+0x275b8 
||ffff9b81`085771a0 fffff809`d2ac98e2 : 00000000`00000007 
ffffab8c`e2f14970 ffffab8c`e2783c60 00000000`00000000 : 
ACPI!ACPIDispatchIrp+0x223 ||(Inline Function) --------`-------- : 
--------`-------- --------`-------- --------`-------- --------`-------- 
: Wdf01000!FxIrp::CallDriver+0x14 
[d:\rs1\minkernel\wdf\framework\shared\inc\private\km\fxirpkm.hpp @ 85] 
||ffff9b81`08577220 fffff809`d2acc431 : ffffab8c`e2783c60 
ffffab8c`e2f14970 00000000`00000002 00000000`00000000 : 
Wdf01000!FxPkgFdo::PnpSendStartDeviceDownTheStackOverload+0xd2 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\fxpkgfdo.cpp @ 
1100] ||ffff9b81`08577290 fffff809`d2ac6a89 : ffffab8c`e2f14970 
00000000`00000106 00000000`00000105 fffff809`d2b43290 : 
Wdf01000!FxPkgPnp::PnpEventInitStarting+0x11 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\pnpstatemachine.cpp 
@ 1328] ||(Inline Function) --------`-------- : --------`-------- 
--------`-------- --------`-------- --------`-------- : 
Wdf01000!FxPkgPnp::PnpEnterNewState+0xda 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\pnpstatemachine.cpp 
@ 1234] ||ffff9b81`085772c0 fffff809`d2ac41a8 : ffffab8c`e2f14ac8 
ffff9b81`00000000 ffffab8c`e2f14aa0 00000000`00000001 : 
Wdf01000!FxPkgPnp::PnpProcessEventInner+0x1c9 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\pnpstatemachine.cpp 
@ 1150] ||ffff9b81`08577370 fffff809`d2ad6e9e : 00000000`00000000 
ffff9b81`08577479 00000000`00000000 ffffab8c`e2a40270 : 
Wdf01000!FxPkgPnp::PnpProcessEvent+0x158 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\pnpstatemachine.cpp 
@ 933] ||ffff9b81`08577410 fffff809`d2aa3e7f : ffffab8c`e2f14970 
ffff9b81`08577479 00000000`00000000 ffffab8c`e2783c60 : 
Wdf01000!FxPkgPnp::_PnpStartDevice+0x1e 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\fxpkgpnp.cpp @ 
1845] ||ffff9b81`08577440 fffff809`d2aa34f5 : ffffab8c`e2783c60 
ffffab8c`e2f14970 ffffab8c`e2783c60 fffff802`00000003 : 
Wdf01000!FxPkgPnp::Dispatch+0xef 
[d:\rs1\minkernel\wdf\framework\shared\irphandlers\pnp\fxpkgpnp.cpp @ 
654] ||(Inline Function) --------`-------- : --------`-------- 
--------`-------- --------`-------- --------`-------- : 
Wdf01000!DispatchWorker+0xdf 
[d:\rs1\minkernel\wdf\framework\shared\core\fxdevice.cpp @ 1572] 
||(Inline Function) --------`-------- : --------`-------- 
--------`-------- --------`-------- --------`-------- : 
Wdf01000!FxDevice::Dispatch+0xeb 
[d:\rs1\minkernel\wdf\framework\shared\core\fxdevice.cpp @ 1586] 
||ffff9b81`085774e0 fffff802`ad908d7d : ffffab8c`e2f10e20 
ffff9b81`08577604 00000000`00000000 00000000`00000000 : 
Wdf01000!FxDevice::DispatchWithLock+0x155 
[d:\rs1\minkernel\wdf\framework\shared\core\fxdevice.cpp @ 1430] 
||ffff9b81`085775d0 fffff802`ad5512f6 : ffffab8c`e4561e40 
00000000`00000001 ffffab8c`e2b95bf0 00000000`00000000 : 
nt!PnpAsynchronousCall+0xe5 ||ffff9b81`08577610 fffff802`ad57f738 : 
00000000`00000000 ffffab8c`e4561e40 fffff802`ad550e14 fffff802`ad550e14 
: nt!PnpSendIrp+0x92 ||ffff9b81`08577680 fffff802`ad9084c7 : 
ffffab8c`e28b8190 ffffab8c`e2b95bf0 00000000`00000000 00000000`00000000 
: nt!PnpStartDevice+0x88 ||ffff9b81`08577710 fffff802`ad8ff8c3 : 
ffffab8c`e28b8190 ffff9b81`085778e0 00000000`00000000 ffffab8c`e28b8190 
: nt!PnpStartDeviceNode+0xdb ||ffff9b81`085777a0 fffff802`ad96670d : 
ffffab8c`e28b8190 00000000`00000001 00000000`00000001 ffffab8c`dba25d30 
: nt!PipProcessStartPhase1+0x53 ||ffff9b81`085777e0 fffff802`ad9063ae : 
ffffab8c`e227d990 00000000`00000000 ffff9b81`08577b19 fffff802`ad966c17 
: nt!PipProcessDevNodeTree+0x401 ||ffff9b81`08577a60 fffff802`ad550176 : 
00000001`00000003 00000000`00000000 00000000`00000000 00000000`00000000 
: nt!PiProcessReenumeration+0xa6 ||ffff9b81`08577ab0 fffff802`ad4ff6b9 : 
ffffab8c`dc66e800 fffff802`ad7ae380 fffff802`ad8502c0 fffff802`ad8502c0 
: nt!PnpDeviceActionWorker+0x166 ||ffff9b81`08577b80 fffff802`ad5957b9 : 
ffffab8c`dc66e800 00000000`00000080 ffffab8c`db6b33c0 ffffab8c`dc66e800 
: nt!ExpWorkerThread+0xe9 ||ffff9b81`08577c10 fffff802`ad5f6966 : 
ffff9b81`08100180 ffffab8c`dc66e800 fffff802`ad595778 00000000`00000000 
: nt!PspSystemThreadStartup+0x41 ||ffff9b81`08577c60 00000000`00000000 : 
ffff9b81`08578000 ffff9b81`08572000 00000000`00000000 00000000`00000000 
: nt!KiStartSystemThread+0x16|

Linux by itself handles this well and assigns MSRs properly (we observe
corresponding set_msr on the hotplugged CPU).

Den

