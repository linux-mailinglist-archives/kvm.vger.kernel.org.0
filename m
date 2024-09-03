Return-Path: <kvm+bounces-25716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3327F9695F8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86091F24B2D
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51071DAC78;
	Tue,  3 Sep 2024 07:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QkZ5rlsJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5181865F0;
	Tue,  3 Sep 2024 07:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725349688; cv=fail; b=ackXev8AktkR0mw2898+j0NSdJoOcuwvCgg6KJjGQlR3nPkf6juVO5QnttgSQIfLr+oNgFlS6yyO3uDBkn8fhgcZAZlB6h9HaWLvcZtStAnMH8RIxpmhIXanj2fpmnc48HDlFb4Idr0tEuuheKNVCl3VTS4ybz9+EH3vGodNbjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725349688; c=relaxed/simple;
	bh=sMjBQEc6DeSYfD9zLhTKnF0j+j/XIV0PfbrYxe+aksc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UttfyM347ol8q0yO4E2E3btPsCpmsVP9ya2SUazFePmopT70muh8jRImJPjvOk661ypSCb6NhqLHs/Z+lxPItj9jZ79szqUklIfHP2fcAOBdBbnEnWdmOCJBoTE8JjMtlHREktB4EgdBp3SDaFPNbuMCodf/TYGBsA/Q2pOrGWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QkZ5rlsJ; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxQogdeNHeeElX706sgxM1f7GfP1Ke6gbyAMYD0t7sTsKgJn3pPJCJVnkNGDui0rIw9A7O2+gxRCsT713xf9TQzD2d033Xbdo39Bl4laVIEaKZhgX6fMaIrunhm2k/S1A9rXBGtv2UlxQTcvp4DHvXNAr5nHbZCkceB+wsYiUkENv+BaB9MehBLqpXvGdZNFZWDpuoZG1Pz9KFPBkM2O2vZ1RyAPowVtIuk6HvHw/owNVC4V3KC2PR1O72OXvJ3WruAYnC0xw2l0hI9BCTJojaA579mnzf0fqaCeJdCcg2Tv6VL3kRMoheNLwkUwB2rAsih1TXhFw5KNffxRykmvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5W54XZ1VOEfnHzpDbqEGkQQmlAEUGhfInypOztnGNg=;
 b=FJu/sEHAVDjzPKsz7LP0yuk927bWOPqhcXQ1kRPulG//IFxh3eccRfaXAhmyNbyywHT3cZNDAoyaUd5IC+Tgp8e0An7tLrZ+5zjdEjtT9Sf/RS8Jedu78FhuOtidtDO8KM3WKFXMtPle1QPPjWK/F2X/KjeIpqwuZFYGpzDI9geF8zyn+D1vj9HqnA6tphr396ZbBvrHhHvOH4w4Y23Eg0cJxl5OTEv+zP96cwt778AhFSH++vQp+fJkGy8hi7qXpus3ocVH8ctN/nLu2vP/5qLeVYEGOMSdJeazHyqWO9gG0q5ZusUtnzcKBijnZnfx7JvwQBSjRj2BQ4o31jHYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5W54XZ1VOEfnHzpDbqEGkQQmlAEUGhfInypOztnGNg=;
 b=QkZ5rlsJepAxmz4poPzfm8hoYOg8r77X4h1wnXYJGGo0dcxw4lYHwkfyPBealCFocGy6PM/dJ/uTLNu171o6Kib9jrQLDwdVYZm0hhZiSsloAu9j3GtQfL9fPT5mwrm7H+/N0+BHiUKBSsr9aPJeaCQTNmmlJkNrB0yFUhP5g48tGU0phffbIEpTJ2s9ye1OJ8esVorfL4dlXOcMUe6sQrhFDmKADyBsX0/oJZxkEVGnXgaRNAlmn5ZCsGobu+IAJ2W+LSe+RDwDWW/PGzyIwHuRHlbWYKXeizlTsAKRsTc9qNsLUOAHE4SkPZ+f2ayuzXxwinjWWZxwciDTuoU17Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB8295.namprd12.prod.outlook.com (2603:10b6:8:f6::21) by
 PH0PR12MB8008.namprd12.prod.outlook.com (2603:10b6:510:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Tue, 3 Sep
 2024 07:48:03 +0000
Received: from DS0PR12MB8295.namprd12.prod.outlook.com
 ([fe80::c1ec:bd68:b1e9:8549]) by DS0PR12MB8295.namprd12.prod.outlook.com
 ([fe80::c1ec:bd68:b1e9:8549%5]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 07:48:03 +0000
Message-ID: <e08c5cc6-27e7-43b7-8337-095a42ed9698@nvidia.com>
Date: Tue, 3 Sep 2024 09:47:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device
 suspend/resume
To: Lei Yang <leiyang@redhat.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Michael Tsirkin <mst@redhat.com>,
 Si-Wei Liu <si-wei.liu@oracle.com>,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 kvm@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Saeed Mahameed <saeedm@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
 <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
 <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com>
 <ea127c85-7080-4679-bff1-3a3a253f9046@nvidia.com>
 <CAPpAL=wDKacuWu-wgbwSN3MORSMapU8=RAdzp3ePgPo=6EMFbg@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAPpAL=wDKacuWu-wgbwSN3MORSMapU8=RAdzp3ePgPo=6EMFbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::11) To DS0PR12MB8295.namprd12.prod.outlook.com
 (2603:10b6:8:f6::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8295:EE_|PH0PR12MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb57294-b255-4615-686a-08dccbecbd76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWJqSlJjK2xVRUNRRnVscXd3MTFmaVA2d0NnbWphQXVORE5jZk93VnpocHNG?=
 =?utf-8?B?RGJ0YUc0dVpyNGF2bDJGdWRaZzhqU3lNNFZBNThDYVd6NUsrUFgvWDZVR3VQ?=
 =?utf-8?B?OUdMSmhuUlBxOUFBU1lsNHIzYzFnSy83alJaTzJ3SnAzMXJMY0NwT2g4WUIx?=
 =?utf-8?B?UmQ1d3h2TFo0N0RaeDdhUTd2VGZ6YzZKKzFOVzFTVllIMWh1WWRPUzJWZUE3?=
 =?utf-8?B?YkZRZkZTbTNDWE9LUlh4ZnNPZEJCbFo4Wml5ajc3T3k4dmRBS01TM2t0VTQ3?=
 =?utf-8?B?RnhTVmlSaUVxNm1MZ1NENEFDMGtLWFl4aWpISzlmZi8xYk5GT1pTU2psd3Ay?=
 =?utf-8?B?bmx0U1IyYkxvV2hXYzh6ZXBsalArSGxSUjFOZkplN2RxRnFZQklVVXNzb1pa?=
 =?utf-8?B?KzdnV3luOG5ybktURWJoTzRmVWRXdjlkRVN2TDBqRHo4ekhSR3kzbVJ4QXhN?=
 =?utf-8?B?YnNkSUVUTi9jbFlHTDFrK0o2alh3MldrbTVxSVZXNjJVYU9hYjMxcWdTQmMy?=
 =?utf-8?B?ZG1jK3l6OTdhN2FWTEk5ZWM2ZzZxSjVRamRhaHpqNHVJRUN2MW9aSzZRU3hN?=
 =?utf-8?B?R2F2bkdPdFJ4QjN0SXRWSzVhNjF2YTlSQjNaQ1AwWVhNNUxMZFJ0djNJR0Qz?=
 =?utf-8?B?MHB0dS81OHRudERaZmgwS1BVNE13d3RWM2M4SU9tdnFXZUEyOFY5ME9JNGta?=
 =?utf-8?B?eVQySnYrUEtqUG82M0VzczRSS3RYUzNUQTZxVWM2UHFsNkU2MGI4RXVHajU5?=
 =?utf-8?B?U0YySTFDNjhiMDBleEdCTmhmbEpqNmg1R3JKY1NFbklSWDFhTEh6MEFlQ1pX?=
 =?utf-8?B?aE1ZWTFtem5mdDFTNTU2N3BPKzJwRFdKNGpyU1dvZHIzU3dIK3pma1NrM1Bm?=
 =?utf-8?B?eWhhbmdSWGlyTDZVNFA0WWNEaXNlcGFPMDd4KzdvU0ZYamsxTWFPb1Y1WWNn?=
 =?utf-8?B?NlZ3c0tCakhNVERRSnZTeER1dW1xVmMwQldBalk4TkJ4VjV2VkFSL3NXS3dN?=
 =?utf-8?B?OUo1dXc0WXRLdGRNVzhnY1RjcmdUdDc3ZnhXM29aOW9oc2l3dTRJaE5VdnR0?=
 =?utf-8?B?UGc0RFQvT1NoaVBsRE9YSmIrZzhMR0NCSjhQQ2laZlR3b2xOLzEwTUxiOFBM?=
 =?utf-8?B?WTBzNEhLVTFVRUw3N2tkeXkzdVNFZWJ5NTlKNkJ0K2kvbFgzVmhyMVk5SFV1?=
 =?utf-8?B?a2VtWDh5eCs1SzFMbDRrMy9RNk1Pd000Ui94QWVtTklBVEZIZTkva1NrRmt4?=
 =?utf-8?B?N1A2cWxJZGdlV21sWEVYUnQyNk1ZK2p6amI0d3NQcVdsd2JYanNjNkhtcmJW?=
 =?utf-8?B?dC9PeldsbEJnOE5CV2tqNmJZbG9SdGtueW9TbHVIcWlVV3JXSEMzaGpSdkpG?=
 =?utf-8?B?VUh5QUxocWhIckhEOTlNRnhCVWV6Nyt6eWxiUSt4cmZTWWlWTHRPTVJleERj?=
 =?utf-8?B?MW4yb2wzYTVYazcycENoRFNTMUpKMUptUTlEMmFCdklqdDUzN3grWE1NaG94?=
 =?utf-8?B?cEhpc0p6eERFWERLYlQzWWtDQ2pHQUM1NnYvMk5mbVhnVUVOZlhPejlXdlo5?=
 =?utf-8?B?MmRsT0NBSFZSSDR0QjhnY3ZFTVhRSzFLNjRpRUxvV2Nudm96SEZ1KzljNFJ3?=
 =?utf-8?B?a2dCS0l3TndtRmpsbjFQZlpGZ1k4UTJiYTFFRUVkOWpUZFlBSDdUZVdES0s1?=
 =?utf-8?B?YS8xSGtqYXMvbldKbWZHMDBBOHlkVjRhR2JQaEk1TE1oaDJVNldOYTdnVWtW?=
 =?utf-8?B?dnRoekVKYlA1NUNQcHh4aUxJY2U5elF4alA2WExZQWFGanZveStqTERLdmp2?=
 =?utf-8?B?T1p3SnlQWHdNek9aMkxtdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8295.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTZDTkgxcStmK3cxM2JvTTNIUHV4UEs3cC84WGNaaUFLVlQyb0FRMS9pYTkv?=
 =?utf-8?B?RWJpYVFSK2tjeWJiL3o1anlHWEhhQ3hUaG9RY3ZqKzg2T09jZm01SmdCQTJj?=
 =?utf-8?B?cGhTOW9YMXFBa1ozUTMzVnFMajJad1RXOFpBOFpGSWl6dW1DcERhNURaNGcr?=
 =?utf-8?B?OGh2RmMxeFVvQ1ZzVnZVZVlaS095RW9OSDRiM1lUY0Y5UkdCSzBUY09DN2cz?=
 =?utf-8?B?OFM1NTZkWkdYTjVtMFByYis2c3Y4QzMyS1FJbmhyRnpKcVN5VVFtNDZwZGdF?=
 =?utf-8?B?Q25GRUJWOHpiT1hGTGdobDM0RE53a0FXMUpuU0FMZ1pFK2s0ajZ1YmxYQXFD?=
 =?utf-8?B?Y2duc0FKb3dPeENHVkN1WXpXajhxbDJjMjJSOUwwOHU0cm5haU9NZlRUN2VX?=
 =?utf-8?B?TkcxU2hrTGdEWGlORlBNYy9wYlQrZGZpR1VPdmYxYTg3dWVNUWZZY25lMFla?=
 =?utf-8?B?dzU5MXVwWUgzTDM2Uzd2VmVQUEZWOUtRV2ZNYkVFbytVU3lVOVN4N0p1N2N3?=
 =?utf-8?B?M1BsbFlyM1RVc1d4bjN6b3BvWkRzaXkvRWhhanRpaTBFQTFKZXZzUEJBMU1M?=
 =?utf-8?B?cmRMVDRaZ2VQNnFFNEplM2VySVFMeklISWhwTFAxZEZUVCtBVjN3NFRyQ09P?=
 =?utf-8?B?YXBsN1VEMjlrR0tiV3E2bkNmV0RLN0V0R0Y1Q1pmK2hYZGdlWkpDZkZyZVlo?=
 =?utf-8?B?aG91TUdhM2ZkdkhLNW12MUorQnJ0ckREMUI2ODQrbWdLM3pySlQwOHhwS2cy?=
 =?utf-8?B?d1NJS21Ra3l2ZWI5dzJsY3htNmFYVXptRTVZSEdYcmp2R1d5ZXFpZ2tpa0JQ?=
 =?utf-8?B?eUpqOHVKSnE3WnZJK0dMQVp4NUR0UkRUckRlOEs1RWVJZko4WnREcVhOSzlC?=
 =?utf-8?B?cy84eXBJYVJ3UGdCaFYrWXhyVXN1UW05d09MVGpPTDRuelVIeU5PZWNxcUR3?=
 =?utf-8?B?Qmw5dFVjOURyS0Z3UVVkejQ0eW9GNkhjUVJmcU5KN3FyY2lLeFN2eExxTHd0?=
 =?utf-8?B?ZFBiUms0dFlxRkdJTG5KYVRsTlBZbHprMWpTZm95Y1c0bkhQRHR6bDc2dllT?=
 =?utf-8?B?Yit4WGhQUCt2K2VweUR6VVdmZ2RvdjNkbDArOHJ0cjZrN3FxalJrYjNBUWlL?=
 =?utf-8?B?Ni8xVnowcUlHd25JYlVib3FkR3ZJamk5Tmt4bU03VlJNRVpidk1FdUlpeFBm?=
 =?utf-8?B?eWNBWU5maElNSHYwVk9GSy9RRXRYTkcvbUYrMzdUOG9vcGtrN1BRdXpnL2V1?=
 =?utf-8?B?ZTNiVFhYRDNYbWVRbkQxSzZmTmVITEN3OFRsb3ZlNVBra2VxT0h6MzZscVhv?=
 =?utf-8?B?Z3I5ZEI1N0QxSE1mdlhnZmpLTWQ0SXJWL3o5RnZwd1IxQjJJQzBHZmYvWnJz?=
 =?utf-8?B?WGNkRmR0VHBrSDd0R25Rd1pmRDQrM2tXb1BMQ0FMWnNYenhjZjZ0cG5tS05I?=
 =?utf-8?B?SHVmR3I5RitFbjRqenBUVXJXNGlQdGNBb2hHeEFLZ0ZMcGdzd1prc3h6azhx?=
 =?utf-8?B?ZFptQWJDV2xzd3BOZTlvWXdONkl1V1N5ZmdwUklaRDFZdVBYVHdCalJJNEt4?=
 =?utf-8?B?eWlZeVdNMm04bUFrWC8rQytsN0ZtdDZlcyswbGJDVUNpNnJlYXZiRzNTQUtS?=
 =?utf-8?B?Ti9zNUFHZm54dGZoTWhrMjVYYTk2ZDhKMUJiQU41a2YrZEtzUG9UNVJBZ1Ux?=
 =?utf-8?B?MCsvVXJ4ZWp0NnR0TDJjU281cmdxMkdGcjliQXJQQVJZZVBMY1VBRDZPYk5v?=
 =?utf-8?B?Y0ZUbStyNE04ZXg1MnpMRzVXYWRJUWJIV2oycDlNR0dwV2ZJVVBlZ0FwQjM1?=
 =?utf-8?B?WEd4V1RNQnZXZHRwb0VpOGFSWE1PbHFYTXhMTlNPOFMyeHRWQzBJbi9JL0hp?=
 =?utf-8?B?b29YUDBUdFk0NUpaUjVURFlvR2tRbzJhMXVNaUY0RElpNGlnd1U0Y2VvbHNz?=
 =?utf-8?B?R1k0R0F1aEpUYTFleWZpcjBJTmhMdk1EQ3Z5Q2dpVHF4OUsrZDdFa0d2YUZj?=
 =?utf-8?B?eEFoSGtnUzZWZFlXMER6OHViUEtwd3FVbXgyN08zdDY5ajlPeitCK1N1UVlJ?=
 =?utf-8?B?Q0RxL3BXTzIvUXhheEo5d1FodFhjZzdhN2F5eG5sbzIzK1hnYzFXVm1UU3Vo?=
 =?utf-8?Q?899z8tVU/XRIQ6fEtR3H4YwzV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb57294-b255-4615-686a-08dccbecbd76
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB8295.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 07:48:03.3708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fr1SDpf3PlUy4+PJwn9bVJ7hu2lM8t019QIt36B3QvSiSe0bX/7swEw9aYrhMJ8bTh1wMXW3k86J3VkTdPAaTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8008



On 03.09.24 09:40, Lei Yang wrote:
> On Mon, Sep 2, 2024 at 7:05 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>> Hi Lei,
>>
>> On 02.09.24 12:03, Lei Yang wrote:
>>> Hi Dragos
>>>
>>> QE tested this series with mellanox nic, it failed with [1] when
>>> booting guest, and host dmesg also will print messages [2]. This bug
>>> can be reproduced boot guest with vhost-vdpa device.
>>>
>>> [1] qemu) qemu-kvm: vhost VQ 1 ring restore failed: -1: Operation not
>>> permitted (1)
>>> qemu-kvm: vhost VQ 0 ring restore failed: -1: Operation not permitted (1)
>>> qemu-kvm: unable to start vhost net: 5: falling back on userspace virtio
>>> qemu-kvm: vhost_set_features failed: Device or resource busy (16)
>>> qemu-kvm: unable to start vhost net: 16: falling back on userspace virtio
>>>
>>> [2] Host dmesg:
>>> [ 1406.187977] mlx5_core 0000:0d:00.2:
>>> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
>>> [ 1406.189221] mlx5_core 0000:0d:00.2:
>>> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
>>> [ 1406.190354] mlx5_core 0000:0d:00.2:
>>> mlx5_vdpa_show_mr_leaks:573:(pid 8506) warning: mkey still alive after
>>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
>>> [ 1471.538487] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
>>> 428): cmd[13]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
>>> a leak of a command resource
>>> [ 1471.539486] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
>>> 428): cmd[12]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
>>> a leak of a command resource
>>> [ 1471.540351] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
>>> 8511) error: modify vq 0 failed, state: 0 -> 0, err: 0
>>> [ 1471.541433] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
>>> 8511) error: modify vq 1 failed, state: 0 -> 0, err: -110
>>> [ 1471.542388] mlx5_core 0000:0d:00.2: mlx5_vdpa_set_status:3203:(pid
>>> 8511) warning: failed to resume VQs
>>> [ 1471.549778] mlx5_core 0000:0d:00.2:
>>> mlx5_vdpa_show_mr_leaks:573:(pid 8511) warning: mkey still alive after
>>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
>>> [ 1512.929854] mlx5_core 0000:0d:00.2:
>>> mlx5_vdpa_compat_reset:3267:(pid 8565): performing device reset
>>> [ 1513.100290] mlx5_core 0000:0d:00.2:
>>> mlx5_vdpa_show_mr_leaks:573:(pid 8565) warning: mkey still alive after
>>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
>>>
> 
> Hi Dragos
> 
>> Can you provide more details about the qemu version and the vdpa device
>> options used?
>>
>> Also, which FW version are you using? There is a relevant bug in FW
>> 22.41.1000 which was fixed in the latest FW (22.42.1000). Did you
>> encounter any FW syndromes in the host dmesg log?
> 
> This problem has gone when I updated the firmware version to
> 22.42.1000, and I tested it with regression tests using mellanox nic,
> everything works well.
> 
> Tested-by: Lei Yang <leiyang@redhat.com>
Good to hear. Thanks for the quick reaction.

Thanks,
Dragos

