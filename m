Return-Path: <kvm+bounces-30891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D1F9BE2C9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C61E31F26F8E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068321DB377;
	Wed,  6 Nov 2024 09:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bN4bx5GW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5F91DA2F6
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885851; cv=fail; b=rMEUmr7C2LWBs5luLxV9JxUMHWt3L1s3TbuWn+M0kJFNnnZ97vabDmgSZb1NonV1/9pZQW1nM/gQsG66bCyIW+0JjZfUineizidsHHryGZYQJuoqsi3alNKfx1CjTXCQ8Xgz1WyByxi30KjOV6EllJbhVy961q0fJttOSlSAjmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885851; c=relaxed/simple;
	bh=unI5ShbKbbyPmSfpfYzzo8RFTrGkh7KUozmkxi4TUU8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DpjVbnBXjypCwsD0WZBwTu45SNCfUSX6t6GcfmgiXGAmeJz669eqadOqEG/VkW1glEcRiFfJ0i/eMmEKNrOnrkXp4bCTSKL3JCDFEptd02xHhPB9smEgUzB+84hijLT3VUGxeNeMQctxd9zHnjV9ThaPSwUGHfWdCmZpdQxTJpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bN4bx5GW; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FK6osruLFZP7bvK76y7QOq+0MxS1kY/+cgyjiZ1+qVg8GdT6AzhysrDxo3xEzUzANy+oaoPZiRb7QfssPUM+72gCxReOulJsvmfOPkq4+WcT8BTY+q/jd/5Ssy5bVN+tbdwRp8iId1NQZeKkCjWjtziQEfaoYA3U3hNwmi2Kb2gvzvvtk2NjY+eqy97kkYX9vzNDiSoJ0j+aWjsQpSTG3bpBDt305qR5HbIiiQ8+KlZzpPQKNB6t0FHxGMC312ZWMN/wEDB+EGk/eEG/ndkTbP0pHOMj50bxN3n64A58hToytTrpGKZWGkQ0J9PzHLyWymk5lVfnW6Eo1DVysuPpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaNAk32Oux+oXOjP9CWqp/gPxHsFwpNanIERl2F7r3A=;
 b=k0Eolx6+VrAHUfEBu4UnJ/urfM6Gx53IQn88WHW3I9gjJ0CLRq0+9Rs/6F4Rak2RLmH/85nkjs4p5NzLO4/snelFnMnOAIL+5kmcHQU2s8o252D7z8DsAuwURQnq0MCLArve77162ZSzp/Vp5gJWUZA8CZTZsAJehri+Y21bYHX0Nzr4fOVkvQGeJEfV5HQRWMOa7FM1TzRZoAKGPjpVwNllXZp1w/69Fb5ILO2PuWj1a6HiDmAYzFxXR9NtELH39WJm1smjitXLudkiQmdRmjXyy2dzPHzYIyka1xfhZ1cLyJE0EiT6q47Rlszxzis94KzIAN9LRNvczLNIbFxz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaNAk32Oux+oXOjP9CWqp/gPxHsFwpNanIERl2F7r3A=;
 b=bN4bx5GWkbRPrU3TKfNjyJGMQfU04mITHbbfM+eyfmJDzn5mdlkgZmrzDoe/iNRbd2MkLrRqECVJt4Z2QFf5a6Ta/KuU/cGAB9KFZWWdo9LK4E8AL76FSdNt4aqe8nfylGvrdrq6gLtZWRIxaI7TKnAgJs9jwIcfkWcUUiwhyL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA0PR12MB9047.namprd12.prod.outlook.com (2603:10b6:208:402::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.19; Wed, 6 Nov 2024 09:37:26 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:37:24 +0000
Message-ID: <ef30bcdc-a792-4be1-afd9-37984aa2482c@amd.com>
Date: Wed, 6 Nov 2024 15:07:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] iommu: Detaching pasid by attaching to the
 blocked_domain
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, will@kernel.org
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-4-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241104132033.14027-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0209.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::20) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA0PR12MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c1e687b-22dc-4f6c-fc3a-08dcfe469e7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkRobkdaWXA0TEZOdHFTUno3WlBlK2ZlcEdQS3ZRT3QvNG1RdU1tVDBoSWpP?=
 =?utf-8?B?VXh6N2pKWDhVV3N1RkU1WGNjVnFYZnNrenF5WndhMW9ZUnAxSnNWcXJzRlZx?=
 =?utf-8?B?R2lwS1I2TFpZTjg1MmIydzdWYWJLUHV1WWJhUTRGNTRCUHJCZWJZWWl1VkEy?=
 =?utf-8?B?WW5sU3ZjbDRKR0ZtMHZHMWoySlRjSTZuU005aTFKeXNwajNLQUY4S294R0Fa?=
 =?utf-8?B?MU9HVE1pYkFBcy9vai9JSHNRelM1Nm1WZHhoeHJoVkNEU2ZNRitBQWdZYmhi?=
 =?utf-8?B?R2sxWmIzSmIxeXJyYUsvMC84WjI3aWwvQTByQUtjQmtpanBoVDZ3bnZXT3Fp?=
 =?utf-8?B?YWFqL1NSWUM2cEpkdytZenN3TDdRZW5aVC9RQUR2bnp5WGpTZC9VcVdiWmkx?=
 =?utf-8?B?cStibHM3K3BTTUNub0Vva3lpbDgvVWk5aWw1Q2Y3NzdYTnB5WnB0TXFtVytl?=
 =?utf-8?B?N3BtdFVTazRvbmFjWHl1Qm0rQVAzd3Azci9jNXpTRWhpVlhnaHNCaDZYYWZ4?=
 =?utf-8?B?aWZxT2RiaXVBbnFjMlRTQys3aVJDOW9pMTRFQ2NQY1RGcm03b0hiVXR4RlhG?=
 =?utf-8?B?VWRJNGo1dy94QlpxNkptYlBZclVKa1BWSWVvMk8rM0FiMlJ3alF0NTFGQzh5?=
 =?utf-8?B?d2l1Q09qUFUxQ2ZhQTVtSXhCYmtuVm1uUzhHR2xMRzFLQ0x0U1BISUNIQ0ts?=
 =?utf-8?B?WWYzdkZLYXZzN0lBa2tMcENuekIxdFA4VFRRNDNib0hkVjEzdHRQMWw3ZVJa?=
 =?utf-8?B?bmtwNVV3R09KVlpWM25TSEp0bGs3YkhpVTUwZmxxNGR3VG9PamtFZ2Q0dzdN?=
 =?utf-8?B?YkVRU0Y5aUw2MHhQZWtEaTFFWlArUFRaUWorblByaExMZ3lpSmR4dDZRSlJD?=
 =?utf-8?B?NWV2YkVOWmFic1NQYU1BTjhvYmxrL3ArOTZPd0lnQVBYTlRyWjYwZGM4Qkpi?=
 =?utf-8?B?VDd1Z1lwRVpyZkRZU1BxWDhVczR0aFJZSWhwRkx4SWV6OGtEWjhDMlFxb3ZN?=
 =?utf-8?B?dkRlckpyTHF3cmhlUGVNNThyYm5JSy9HaTRQa2ZYdkNNVkE3L2FRQmFycU56?=
 =?utf-8?B?L3VWTkRlSGs1UnVJWEpRNTNqU2VVaUlDSnJ0RXpKZVROZlNqOGdJdGxkMldB?=
 =?utf-8?B?dHpVT3B0QVlmS1ljYmxYa09ZN1pWaHFGLzdLUGV0bEFPTWcyVEYwbkljbkU5?=
 =?utf-8?B?R2tPdkRxUkMwRmdUS1RPdHBnZTFUeW9Uc0JXQTdVVzFRckFEZjdFdDZhOFdk?=
 =?utf-8?B?c0Mzdk9XTlIzc0w3TnNhVEp2TDJudS9VQ0VTbGc0NjRSZW84UVFLMjJNY251?=
 =?utf-8?B?MEVzUFhxZ2lyMElicTdQRmY4eXFadnVWYU1tMzBudUxkWTdIaFJNalZUNTFv?=
 =?utf-8?B?bW90Uis2RENTYmI5bDFhajVOU2RYbmZ0cG9ybGdYWXZuYmYvQmJoeDFtRkhh?=
 =?utf-8?B?WWJKZG5pdTRjUzBxd1NtK1hYMmtra2hvaEkyaFowWE96WGJycGtWWDFMTUhG?=
 =?utf-8?B?R2JGd2xEU0NNTy9OOVVVOTV1UnRMcE8rOVFLckl3ZzNMRS8rcG5EU0ZYV3NG?=
 =?utf-8?B?OXpRcUYrMkNESFcxNWlOT3l0WWhIQkJkTGdMaGQ0V00wNDdtK2FYQWQ0cnNJ?=
 =?utf-8?B?bjkxOUwwcVZUZkV1YkNkUEhZK0tSTWwyL3BUU1VuMStpaWlLaU9HT0pveWsz?=
 =?utf-8?B?RE9OMVkybFdFSWw3Q3FJNnZCTzBEQlVEcXFFRWE4TkQ3VG1UMHhsZENjbzB3?=
 =?utf-8?Q?QVj12pooK8GUZHe7k5Iz25ka1MURqFmvklzd7sy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGV5VVp6Q0tYbkdMSXdMVGltN3BPaW5sSm1zbWprWk5NbThWUWJrYW5mRFk5?=
 =?utf-8?B?ZnFXMktEQzBrVEhDVFRaejJlWHRqUFJ1R1Mrb1VraW5SU0c3bDNCQXBnR214?=
 =?utf-8?B?MzdDb1FDM0F5cUtsTmVRcXU4ZUhTZmF0UTNBWnIwaXhHT3JaaUhMNFJqVzFK?=
 =?utf-8?B?eXJxcVZlSUpGbStySnlRSGUvWUpIZERFWnBqbk43M200UTE1Q3RYQnhyUno3?=
 =?utf-8?B?ZDZMZEF5RWszVzYzRnhvUzhkYlhrQWg5NXhTQ0xscDV4TTR6UE5nMGkreU9J?=
 =?utf-8?B?MzF2NWM5QjVOY0JtRklwbC9IMG4zbU8xZHhrMU9IOUpDQ0Z2cW8wZEw0R1JW?=
 =?utf-8?B?a0dNN0JnNmZ0UTYzT0dabU1BRXZCYzlNTEFGOHJQZmhDQSsvWDRlaVIxb3E2?=
 =?utf-8?B?SStObmZiUE1Hb0xmcm1TTXozNlA2TUVFNlRBMGtGZTdJU3JzZVdabFFWdDR1?=
 =?utf-8?B?RS9uOHVxTHJESTVSSUViZmRVMWo5V21TMnpQeGtzd0ZGcjdUandxU2d3OVFB?=
 =?utf-8?B?ZEg4V0YybEN1SkdTYkxyMHpNdXgyOHRKb0xwK3F6b2E0UkhxbUZKTWc2aHBK?=
 =?utf-8?B?ZERldFBDSVdrTm9uUVA1WGowN0grd0JIZmJKQmloWlVVSWUvYUlOSWxsMGtp?=
 =?utf-8?B?amFhejBPNUxPL3N2ckYvMWVuZkV5U1I3ZWI3N0pZWjVPS0c1WU5VQjhvNTZu?=
 =?utf-8?B?SDc2UE9Eck03K1MrZ0t4bFhTQVhVYzNlTVQxQXJBdTZKSlU2M1RBTW1DQkFr?=
 =?utf-8?B?T1lIWCs3ek9tZ1gzYjlnTlhGNkp6cnZ3RzJGdEE2SUZqR3BteDZJOHF5QmtM?=
 =?utf-8?B?VVRxS0JaY0xTWnp6Y25ZRDd6RVF2Zis5Qk1nMk8xY1hMazNsUzVVOHRoM3lQ?=
 =?utf-8?B?S241S2ZNQ3dLejJmU1E2RXl6ODI1R0ZnV1F6QjJHMi9DS1EwTXlqZTZOc0ZE?=
 =?utf-8?B?SXpHekxITzhNeDZ6a2crSGFyZ1cvVWp2L2VCRVA1a1dzcGo4L3JGVlNUbHJG?=
 =?utf-8?B?OXBLcWZxSTVZeXU2TlE1QUNMZWtjZlQwS2gvWHltUW1ON3B6QzA5ckJGRFRU?=
 =?utf-8?B?WjlxUUE2N0RCcEZKaWZrWFppQ05NT0kxRDRmNzlWUXQyZWdhcWxqbzByT1Bl?=
 =?utf-8?B?eURueUxRWWVGZDA5Wk9NeUVvekphMkEvRGMyRFEvWFl1MFB5ZlQ2WEdwUVda?=
 =?utf-8?B?cFdiMCtzYlJWY2lEbm1lWGFHUTZNKzBpaXM1TElwaSt1UVI4d0REMmVUdlhL?=
 =?utf-8?B?S1N6aWRhZWFiOThEOXRTcVF3WWNkVjRrNGs4YmZvaDFoTTZSd0xVa2RsVU81?=
 =?utf-8?B?ODFyZitFditZTHN3bVB0WlRSQXVoMkNjWVNMUTNESkFvNHdXa05yV2VEMVJU?=
 =?utf-8?B?MW90NmFRc2FEbkczVG94MURZV0xELzhnUE9id0hiWUwrODRBQ1ArY0hZS1JK?=
 =?utf-8?B?SVNCZ1VFbVhuNFVNWjVlbFlKdVloMis2Tkp6bGd0ZnR2WXVXdGtCOThOaDd1?=
 =?utf-8?B?cnJ1TGRPa2J6anVxTFB1bFpxNWxoYSsvTjlldnAxSEhCVEdTdEo1eXlJY3dR?=
 =?utf-8?B?ZS9KMGl0a25pR0tHSVZ0WkUvYmgwTkRpL001cW82eHFPb1BFM21LOW1iMzlI?=
 =?utf-8?B?TFpyV2NpTmtVWmZtVVlMSWFNWlVuUlp3U0Rib1lPOGZUTnlvWVFiM3RJajhC?=
 =?utf-8?B?M0tKOG1sa01ybFF1R0JjOGpXVkhrZkRnbDlaZzFUN2Q1MnkvTy91M0J2WEx3?=
 =?utf-8?B?Zno5dThnZVdNcGl3M0hDRmFWUnVBbEVZTFNEMTJ3S1Q3aUtQNlRjOUM4OU82?=
 =?utf-8?B?K1J0cjl6dUcvMnNKdVFxeG5Ub3JnQ0VHL1ZlL3BKUUR3Y0pBcVptdVpDQkta?=
 =?utf-8?B?ZDgxemt0UGVoRWlkaDRCQWkvK1ZTbGs3MDNtUCtMaXUvNi8rRnJRRmhBQis0?=
 =?utf-8?B?MnlEVThnSjZrWFN0aDhKdHZxZU5UbXFTWVNkWTA5S2lFVHpUUTc1R0JpMkNQ?=
 =?utf-8?B?cngzVitwRUxYZzN6aEM0ZDdTZ29rMzZ6R2ZHV3BrZytaVFdCU3hiMWpsOVJv?=
 =?utf-8?B?WW9QYmdETDNtWTQwNEhBODZrS3hyNXZyVUdWZjU1TnVTa256Qk93NFVNejdV?=
 =?utf-8?Q?3f8OyGdieJOxzuG+xH7KhgMxC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1e687b-22dc-4f6c-fc3a-08dcfe469e7f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:37:24.3746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vhgwIoATu6nOesw2ZoHLdIws0HGXFsBvPmSlrIyfZjNGcrgavf96ouDu74bmiGu0kfde0zNVcDiSTMxUR0bkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9047



On 11/4/2024 6:50 PM, Yi Liu wrote:
> The iommu drivers are on the way to detach pasid by attaching to the blocked
> domain. However, this cannot be done in one shot. During the transition, iommu
> core would select between the remove_dev_pasid op and the blocked domain.
> 
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

