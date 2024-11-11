Return-Path: <kvm+bounces-31422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF53D9C3A55
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FD581F22012
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75E516F287;
	Mon, 11 Nov 2024 08:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c0/HLaFA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2066.outbound.protection.outlook.com [40.107.95.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB9A16D9AF;
	Mon, 11 Nov 2024 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731315514; cv=fail; b=iL8P40NwQmw2a0JRAIZyaO3uxl7/n7I/8eBHCL5C9TW23FITSNdI8oUiUZv8U4PGWY+GX+8d/3MCrvIAYAAXYKYP0NGMf25nSrv8K5CNzQ42yNA5P/hnTGhRkByhA6U9/d9xzvC4xJS2uQMijLDghYM5iW4PLKQkbr1KCZHwHyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731315514; c=relaxed/simple;
	bh=i1Ec5FsG4AmS7QVGSbumKCzi3V+b90PKisELF+QHK0s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ezr1uFLwrJD7bhB3AhBjJBi3vcjSfTwaLnk2ptHBimffZTF+ERU3E/4gurWTByHbm1kTh8lS3yZVhQLgpxPyqsek9MSvOemXDawknWGBnFle0EqkQhWrFEyoFxVWdsjY99DCrulHJmkI6ae5fKZW8LZI3M3tALkOhT7tOOIUhxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c0/HLaFA; arc=fail smtp.client-ip=40.107.95.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bf8burDY7cIl8F/v6lw+muEbO8T2SiazWgUIhaDMsLkHEpODgLZJEPKgyTAKnHUC7DpbGrYUYUIWntL57Yw9X3MVofZwlWV/p1K1aWc1t5zhBQAc17OyRyuO9h0z8HE4cqkt89Rk5LCu0JcCESWgEq7GWBYBkJ4Cr3V6zX6zMU9GtFAEdM/B/nEPteqw5anZD2o8WTlYlRAmyXXQrV8DFxuwBhG4hOCpXdPa7yBvcEJ1bcI19euqBY928AAycDgZtSFJnxWFvS2EU+lfb71/cAyS6oObzV4WLxYhhnHkicR/51p+0g8TrCbWyWbsMW8A7VKTICCLlCAXLl3jyLyf1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sz+iufSOhAbF0xcPP6jNgzUAur+fyVoM26/jhDY6wCI=;
 b=FCOqwXvyYgMhsTP7WmWvu7v1V+Lbk9tYfDkKi3lNGe74hbcHALBJiGlyQUug6vzjdqG2aYP2gb+rmGRf7sQvA23Bi3YzVZaCuJkN3cJgyNcyTpCtYlA5VwE1EWwgqdItIhkUuhWtlcOgWW9MG1nuJIZVJ6rOIscvsAep/qWOTcLpoZgAe0vocZjoURBcYmBN8hGkVFyP7Bjn5MG0rdfZkbYAo3Khp+2MyfrPxa2qWk3xG0qXSaldY7SqI2vym3t0BJbcK4/0syb7UzjtuXjj3K70iJrq6nOOmAshrF6wHhpwCa3/vBrAeV4WPgvnyrjT7NufLtiokJb9c5GObwCWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sz+iufSOhAbF0xcPP6jNgzUAur+fyVoM26/jhDY6wCI=;
 b=c0/HLaFAlJcPdaVmlkqotgBks7914oovcIkdMChdn/UxMC4KYjNkp5tWU3HSd5CgyXFdd09qYz/W1FzRpzP2WVcSF8sshKhwwluOA3p3/mvTDmiX+fLdcDR9jYqK45pq6d//SytqwaUW8LSizdt1Kje5chkOf3tTCsLgSarF6LPI9z4C6Da7tIv5wzM8jh/tEeWJOi93MHVM17YFEI8eR6BaJ0F6ikmXChp4qhitmxs817hRjj4bsi8fyJ9WCW8su8G1jretKYKGgcfRjbRgbnZcHn7HbzS/JYx0C+t3Phy1AimvCTtl23rsC4P19jKjRwOQ8NJCSm1mmlXfjehepw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by PH8PR12MB6940.namprd12.prod.outlook.com (2603:10b6:510:1bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Mon, 11 Nov
 2024 08:58:27 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%6]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 08:58:27 +0000
Message-ID: <8e93cd9e-7237-4863-a5a7-a6561d5ca015@nvidia.com>
Date: Mon, 11 Nov 2024 09:58:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost 0/2] vdpa/mlx5: Iova mapping related fixes
To: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev,
 Si-Wei Liu <si-wei.liu@oracle.com>
Cc: Jason Wang <jasowang@redhat.com>,
 Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20241021134040.975221-1-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::18) To IA1PR12MB9031.namprd12.prod.outlook.com
 (2603:10b6:208:3f9::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|PH8PR12MB6940:EE_
X-MS-Office365-Filtering-Correlation-Id: edab8020-8748-4358-e891-08dd022f018d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHFVNWlVRi91bzRjemdLSG94eko5Vmc0WjJYTkRmZVR6Wk9XL05iWkluVEUr?=
 =?utf-8?B?ZEUxWW9kVERIRnRGckJtbnZNMS9TSFpvbGRuQ1FhTDdLU2Z1SnJ2aFZWUVRs?=
 =?utf-8?B?b1FuMDI5bUFEaFVGdXZMZFZ2cU9nZ1owNmJwVmhyNVJydXo3bXFqbFRxV3dz?=
 =?utf-8?B?UEZjaXhNTjNwTk03dTgxbHdFbkwzcjBHSXVCRTZPOTdkSytxRkRRMmZ5SFV6?=
 =?utf-8?B?a0dMUjZUMUxFaU1GQnp3SjNPUGVPVlZORVBnQldxaHdvQmxaZCtGMlo2V3ZR?=
 =?utf-8?B?dUdDc1VmY2oxcE9zcm1yYVJOY3U2a2pWelJlYUNGRmcxZ1RNTS9UQjdGakpS?=
 =?utf-8?B?Y0JxT05ZVVVuNHh0Y1hZaDRzK2xLLzJUSmpXb3ZwSnQvVGRsdHd0ZHRBekF1?=
 =?utf-8?B?UXRXT0g0OThHdXlKM2pBck0zUzM5STdkVDUxbHd4U1JrSkNmTEdOTkhla0t2?=
 =?utf-8?B?dzVqYWdiMmpoQlBpaHUvbXAveGFmTmtuS0NSMVFWaVVpeC9WaklwamFWMVFo?=
 =?utf-8?B?dVVBa2dKMU1aWjNQWnlBZzA1NlE1Lys2N3RCM3dDdXNGYWdTbFRreDBVUkFU?=
 =?utf-8?B?ZEJVQjNxZVZ4Y280eDNjRjNoVjV3Y1V0cGVSRHc2K1FnSjg0MDJBMzlmaUhK?=
 =?utf-8?B?VjdRZHpmSG1sY0pKNVBBMFpFeWNQTmFQNEFSeDR3SmJPRU41OGJmQXFGU0lx?=
 =?utf-8?B?KzdIeVpweTdhOUFBckZLZzNEeW1uRCtrWWRvanQxcUFSWnJqbk9SdUdnUEhw?=
 =?utf-8?B?UjRDL0ZXc01rYXBabElNUGdUUlpXcWtoQnBWandPdEJpZmc2dVY0SjlpbVUv?=
 =?utf-8?B?ajA1K0Z3OVBJTzZYUDlwdjJWS1VpYnBWbVFYV1B2OWxjOVpOSFljVWhuSmxK?=
 =?utf-8?B?WTBvaTJoUDhQTVN0eTVTUlVyRG9pZ3JISklGUUhqdEFhZVgyTHhFVnBPR1h4?=
 =?utf-8?B?N0NHT0NSQnlFS1RwVE51UklLemlvdUJpQk1WRWVrRklaNU11Q1BpRVNtT3JP?=
 =?utf-8?B?clI0S0NXc0ZMR3pYRzJlT05vYmZoL3hUamlwMlhjR0t5Rk9xTW5EbmlRVGVT?=
 =?utf-8?B?bVJVdUdUbFlJSkpHWUduN1NFRFB5Y2VPQi9MMW9pN2xJVXoyZERQM2xrTnZE?=
 =?utf-8?B?WGNYbm5pVDBpQXZpN1piczZQRWdGeWdVbC82VmhHWXJWQW1zV1EzNFRUbjdF?=
 =?utf-8?B?WERNLzdKeFdMMklMVFZGbW96TmtJSEh5R0lCTHpMZXluYmZROTdJaGlKYzFG?=
 =?utf-8?B?dGVrV0EyY3FBQnRJZEhhTDNvUWVXc0xVZXFWNVJid3RrN1BEZXJJRE04TDAr?=
 =?utf-8?B?ME1uRm0vd1F5dmMvRFRFZkFFWlJrNUpJMHV5aWI2OTdaajBqWnBnQms1eEx2?=
 =?utf-8?B?R0xubFJOUlJQaDV0THl1c2JHNHRwU2Y0UzlUZVpZYTcxUlc0cmFYMDZpd1Uw?=
 =?utf-8?B?Z3pxa2x5Vm4vS3pRYThHRHdKWnJFWUdzS2pKaTVXWkI3VTc4amFVQm5kYzJZ?=
 =?utf-8?B?K1NoRnBZbUkyS1hCTDRKODg3dllhdVI2T0dJUDd2U1cwbmZ2VGJDKzJ5YmE3?=
 =?utf-8?B?SjRhVmJoWFhkNjZPU0lYMTA2K3d2R044akpDWFlZS0p3MnJvSU4xbTg0ZEJn?=
 =?utf-8?B?Y3hxZXdIeUZ5V05UcUZmUElCbHZ5RFQrZ29RdUJvQWpVWkQ5VFJRNCtMYlo4?=
 =?utf-8?B?OVNNcnNMWVdmV28ycG93TXRsaDdjYWV1bGIwVlc0aGNqdE5SQkFySU8xd21m?=
 =?utf-8?Q?6hkN0WLQ9V4C8pP79Ik9NWVK40NzNUDFvCyG154?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2hiREZRbEFaQ0RBODViUE84aUN1THZoZjU5ak9JbjNJOWpEaXlZdHkvaGo3?=
 =?utf-8?B?WEM0cjBsQk1ZWmQ0RE5yQUZjYlpwSitHRFhpWUV3b1d5TERySC9aNGJqcllV?=
 =?utf-8?B?ekhyS0Fhak01ZEF1bWdHdUJlQzYzdVFGdmtFWmRFQVNDaTMwamFnRFJ3MThs?=
 =?utf-8?B?TE5Wc0FTdkpGTHJUUXpxa0ZianZYd0k5ZDFyUWZiNGg4K2YzTDA4MURqWERZ?=
 =?utf-8?B?RWhiZGM1UW1PNHZHVnRObEM3UVJlL1I5ZDZJQUR0TWFvTXJxWm0weE1lZ1JI?=
 =?utf-8?B?c0xrYlhLbEFlelU3cloxL25vYnVxdjlQMlFUQ0tveXJpbzhFQ0ZjMnZFUWhj?=
 =?utf-8?B?V1BLZTcyM0cxOFM0THUvbTUxcGw0VnFDU1ZmejRld2ZJTjNVVUc2V1owZkw0?=
 =?utf-8?B?YVVpanZvdkxUN2JaQk5jYmJ0WEh3a3ZUMFBkMjlINklzbytORTM2K2R3bXQ4?=
 =?utf-8?B?Q3dLU0txd3p1ZzZySkkxK2ViMnpzazJMclpmQkpiSU1objhMTDlPdXNQQVcy?=
 =?utf-8?B?Ukd2M20vd2Fjc0pjYzNMRzBTcWVEWHBxWUloL0lNZDFYV0w5UEdKU3ZudkFY?=
 =?utf-8?B?Z2g1cXpFZ1JQQlZqWkNKZ0hnN2J4NmVXdUpETEJXOE5XRXQ4TGcwZXdjSTlT?=
 =?utf-8?B?Zkd1NVlYMUg1Nm9Nc2o4QkJ2QThrOWVkbUhOeGUxeFRaaWJYSG10MDIxdmdy?=
 =?utf-8?B?dzlvQ0FBdWFlbis2TGVPbWV5MlJoWmxUeDhSbC9tR2xXSmpGMUl0OVRZc3A2?=
 =?utf-8?B?anVSVkhVSmlSbktRWkVKRGJzUzVOTHZYRU1ZSXNFUHdhMmQ0bXc0Nm9EMXVU?=
 =?utf-8?B?OHQ1dnY4WGVjNEJqd0tUR2xlYm02ZTd2bnIrTEdiazlYN1BLRjBWRXNXVnNk?=
 =?utf-8?B?N2RWVExCSnovL3M1ck5vSmlTNEw5RGRzSG1XbUtqZnhuWVA0UDlsOGlkem9K?=
 =?utf-8?B?aE10RmxNOXFhdXA3ZkdWQVdZMmNpdUtxNHhVWG13QTMwWS85amZYcUJ6bXNh?=
 =?utf-8?B?UUZZVGRpRm1ndmtqdWQ2aFJOS3B5VGZYcmFaNUxERkRPRENUK01HUGV4cHdx?=
 =?utf-8?B?SXdUY2N1azhEYWpmYVNHaTZUYUxuTDJGOEFhbWo1dWdrQ3FSNEZtT1M4dlB0?=
 =?utf-8?B?VVdzWjNuSlBaUkI2U05mNXpLUFRVSFhNbHZoS1h6K2o1YnFsREVpbys2Yy81?=
 =?utf-8?B?eVlhVzltYjZxTy9FZHNjOEc1U05qbnJteUhySy82WTBkeElXK3c1akkyRTBG?=
 =?utf-8?B?b2VJMU5LRThlODFzRTFhQVFRa2ZaR0pGQ1ZzcEVjWjBrQnhWWlMySHdEWitW?=
 =?utf-8?B?Z0IxQ2FiWVZDSjByQWFYSHFPM1NqdnRURGJ5ZElWaHJXNGIramt0c0c4R3Rk?=
 =?utf-8?B?RFdBdDg5M2M2UG5pWUhLUk9GMlVyQXNoeUxGQWV5bVhaRnRPZWJadC9CVEQ5?=
 =?utf-8?B?WDFRbHRqNzhCTGVKOEFmYS9VSEFjOGMweTJLSjNaMmNsd0pTTU80VkVDMlZj?=
 =?utf-8?B?eUtBR3R2R0puMEpKSzNadUZhOXBCZUF1WU54cTdYV1BmUTd0Um1ydzBDMWVn?=
 =?utf-8?B?SCt6Mm1vZm9uR0xJSVpPcjQvd01Cb20yWGJMeDgyaEM5VERab3V6czNMS3ZE?=
 =?utf-8?B?TUhRUEZOZUpSTjk2Wmhud0NJNFNRYXhYNEUwVW9VcGZ4VWZlZ2JjeUdYUHBQ?=
 =?utf-8?B?ZmhPdTVKY2k2Z09XaGJTRUNtanZRTEhNbnVnTzRqbUpIcnUvOTZFNlNIaXdr?=
 =?utf-8?B?OWRzdjJWQVdweHFqbFAxMnpBVmVId1pLZW5oclphVkpFR0x6b0lrZjRxRzM1?=
 =?utf-8?B?UWhFMlRtbGNUcmhFWmtlMEl3RFM0UzRsU080Z2NMemJ6VEZlbHozU0JFc0Zy?=
 =?utf-8?B?RVNTZFF1NHJnRGhOaEk2S0NzYW5XaHRncSszbXJBRktkNEh2a0NVUmZub2I0?=
 =?utf-8?B?UThjSnNhSC91S0h5Y0oxVXFrY0lzOFdxT01OVDE3a0VVZnZ1cVlpWEpoZkFL?=
 =?utf-8?B?NTdHTzZ1cWhzenNwdHNpd2tFNnlqRHBnRDdNZmI4MVJMa2FlMHVwLzMwcSts?=
 =?utf-8?B?L3JnNUtnV3JPay8xL0NoNTNSb29Ba3pSZEZaajlNREtPcnVGMVA5TllpQnJB?=
 =?utf-8?Q?GsNC34fdsTrPfAGSTva45GxBS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edab8020-8748-4358-e891-08dd022f018d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9031.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:58:27.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mF/8UqrBc5Hiun82C0NBTc6JUZ06xEVIKRWu3Pd6HFxoHX294SnxjVDPOh2a/0dG8oc3mDiqYVBm1qSDBYKa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6940



On 21.10.24 15:40, Dragos Tatulea wrote:
> Here are 2 fixes from Si-Wei:
> - The first one is an important fix that has to be applied as far
>   back as possible (hence CC'ing linux-stable).
> - The second is more of an improvement. That's why it doesn't have the
>   Fixes tag.
> 
> I'd like to thank Si-Wei for the effort of finding and fixing these
> issues. Especially the first issue which was very well hidden and
> was there since day 1.
> 
> Si-Wei Liu (2):
>   vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
>   vdpa/mlx5: Fix suboptimal range on iotlb iteration
> 
>  drivers/vdpa/mlx5/core/mr.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
Gentle nudge for a review. The bug fixed by the first patch is a very
serious and insidious one.

Thanks,
Dragos
 


