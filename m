Return-Path: <kvm+bounces-56716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1A0B42CDC
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 846651BC7240
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDBC2E972D;
	Wed,  3 Sep 2025 22:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AwNDPWLX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5574A2D
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756939024; cv=fail; b=VQAOytErZGUxn4L/kwG+mYwyKeeFzitBnbZLNJIWMStIH9hDUSq4yFkSwmUTekYlEP7E0slS+UoeyAdyTl23hXdSNIGe8ANmG65QeTQ/QJSHDGaROz+8pzLMBUA9e4be3IebOSAZOjlloGMaUuoWk5Ji9bfAVV8RnwjiEUuOhGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756939024; c=relaxed/simple;
	bh=BnzpDbjwewYFWIcc/YHxHRkK63uXy9JeGKWkML1vSGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ujDB0NP1fvTaHYRmlOonDRoXjlteq+rP8toGuMpiIL5EX55sEa1X1bNzLd/rcQICdNWGxSLSpyBhWw8VmbljjwMa0Ykjmv5Ut18XiTSMsSnY7zmumiG+mmuKGWy7tU+z0yC8x/U6urQZqNC9BHQVCh3wypzbgaWYutoNkMK+m7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AwNDPWLX; arc=fail smtp.client-ip=40.107.101.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4OuC06OIJW/Gq1rBzylW9z+xlZZVhqlTGZ98Zsk6rvZrYEfVtRCn2khHWFyc9bAPNO928Q122EJ9DGhT2HUBos1pRp42TVSXgHZbDcuE+i/y+7IKoDXR3OtjQpBcAocOkZb5E5D8QmVJLhRkPJv65FhQGYkOainSXpuZpjgOH5iYl/P7+h+nYIawl9Ofk0OPZqvBOkr1RevqT80TwYN/K0cmkN9JDcMB7rUKFC7B/V3sJ8jtP8w/ZILkywrVQ1gw+AgLOCDWhFa7F0/WC8w+Pfdv6vJKWGz3HrEJlmzEJxCjw7iEpGWxvL+LXKS51U8YOXKqLgB1bYUBeuMVijTBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnzpDbjwewYFWIcc/YHxHRkK63uXy9JeGKWkML1vSGg=;
 b=eJf1pwouUb7jBnkSBfbB5z15X2IWQyypOYGWWLN1Qa8QVs0fujOuDW0OaMS1nOVVOnLzzkWsZ8vtfJWbjFbP9faob3XahTKtoa+QHpcCEHQRRwrUNoohWmtW5EBJJIMuQFX85zemErmbZAe963fq4B2grOgrnp/ysKW8Rxr0q0IQj5axRupy+iLg7/ipBGttMmfzHm3z6OHKacQDLa7X4PwcAOoqzH1Yy38anrQRoEDgSFuBj5XfPwQQOHkbiWPTr/xGKSl22txjXmfNU402Vuz+DyznGHdJMozgNdedH/4PfkB0KufyurOGoa7k3w4hyUkLK/a7yX4Xqv6aJjx0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnzpDbjwewYFWIcc/YHxHRkK63uXy9JeGKWkML1vSGg=;
 b=AwNDPWLXncmQi1CC+qOzTLmmI0OI5Tmh6jaemuuhVusJzTmAdnAeVw7Os7QDTppP6foBUFNaoHQwBN3aNVPflYc/UyUTSVuEVZBQzu30LD7AGtXSAWvbvFE3oNbI2MHqam6RNLh54ThPc1Npur5KSOsUymzoFoUYTINY8ROOsY2B+chkZbdWJKVM0UoWKAK8X9uuFRCmG5Bf06NYpO38xuaj2GYr8sPeRMubZYNUjJnkgbFBgDFZfq8jlcyq/DyNwm+R+WYrpXaPsY19U1cRO9oLNAAtD+a1KtslELasgWgn2m0rIMUxi08yQsCr7pR7V0V4nMAHpsOWYr11MScj7Q==
Received: from CY5PR12MB6526.namprd12.prod.outlook.com (2603:10b6:930:31::20)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Wed, 3 Sep
 2025 22:36:59 +0000
Received: from CY5PR12MB6526.namprd12.prod.outlook.com
 ([fe80::d620:1806:4b87:6056]) by CY5PR12MB6526.namprd12.prod.outlook.com
 ([fe80::d620:1806:4b87:6056%3]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 22:36:59 +0000
From: Timur Tabi <ttabi@nvidia.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Zhi Wang <zhiw@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Surath Mitra <smitra@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Andy Currid
	<acurrid@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"airlied@gmail.com" <airlied@gmail.com>, "zhiwang@kernel.org"
	<zhiwang@kernel.org>, "dakr@kernel.org" <dakr@kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>, Neo Jia <cjia@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [RFC v2 10/14] vfio/nvidia-vgpu: introduce vGPU host RPC channel
Thread-Topic: [RFC v2 10/14] vfio/nvidia-vgpu: introduce vGPU host RPC channel
Thread-Index: AQHcHR+6Mo+iJdRE6kyDHh2v7t9OmrSCDEQA
Date: Wed, 3 Sep 2025 22:36:58 +0000
Message-ID: <4db1511072f680aa814ee1da21c9054fdf5365e2.camel@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
	 <20250903221111.3866249-11-zhiw@nvidia.com>
In-Reply-To: <20250903221111.3866249-11-zhiw@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR12MB6526:EE_|DM4PR12MB6302:EE_
x-ms-office365-filtering-correlation-id: 045b0940-5d19-4598-319a-08ddeb3a64ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VlQwWGJ3Mm8zZFh6VEMwWlBkMHY0WVpjS2V5WEJydkdrbCtZbWIrandZakRt?=
 =?utf-8?B?SU00OTAyZnZ4VkRvYmV0MmwvajRpNHJsWEVxZ2JzaHRZQzd1OURudDNXMkdS?=
 =?utf-8?B?THRRTHhSYkw4RmNlR2ZnWENtTElzbDkvd2didEtVZlZ2NmpRZzNYd1lmcXBy?=
 =?utf-8?B?cDByTnhBWmh2b1A3OXkwVFM4dUNoYUwxTzNta21jY094SmFETVZpTU5wUGwz?=
 =?utf-8?B?Q21kdUVTZm53cThCVTFweWtyMi9OeUJEM1NyODRHNDFSOFBydjJiUU1UQnhJ?=
 =?utf-8?B?c1RBeE5rWkdQbmVDNGpDQU1hYU1UKyt5RUl1UUgrQTNnWnhkYnlRUzFuOGRn?=
 =?utf-8?B?YzJmQ0hNZEI0TjRYNThLc1FUWlg0ZU1BbG4xaEdDREovejd2Nit4MUZKcmZo?=
 =?utf-8?B?Z0w5NFJiMjNUR2wxdU5Jc0NOeG5ITEVHeXRYNzZnaUxTMmh2cVg0WjFMc29W?=
 =?utf-8?B?RjFzSmd3RDE5OUdPQldiLzhwOWt3ME81TThhM1d2OXNzZ1VoV0x2eGNWQTV0?=
 =?utf-8?B?OERmUTJ1MStjcG9sUGJleDNGNjVkanlIWXI4MldqY2YydHJrcWp4UkJvOFpU?=
 =?utf-8?B?UnA3U3FnT041T2hmaHl4TFRaTHIzQW1XZ1B5RHJwWGNTcU45QlFidnhsaW81?=
 =?utf-8?B?RjZIOUZ1ZDJjK1Zra2hPWEpaZHRuRHNiUnRNY3B1ZXNjcHR0eVZVYkk0ZHBW?=
 =?utf-8?B?TDlhSHJaaE1hZUZNcGFZdFRVS2FLdTA2WmtFNzEvclAwSld5SmNZanJlVjBk?=
 =?utf-8?B?QnlDQmZLM2dnM2cwSlJBYlUvK2l5bU5kLytyaU4ySEUvOUlGUWRSWGQ5ZHZr?=
 =?utf-8?B?ZzNLYktjd29xN3NZSkxTb21hUzFmTnoyTWErYkpPZEovZU5HZjZuWDIwN3BN?=
 =?utf-8?B?d1FmdkJRdStFbTJQUFpYWWJqRFdQT3lySk1laVdEUkQ2WGdmZ25lRVovWktR?=
 =?utf-8?B?WmFUcEtKTGxaSWFqd0t3RGdPVldqS0lOUXlvY1psRTY1eDFwVDdpTFJ0THlM?=
 =?utf-8?B?YzRHWU1UQi9ZMUhqTkI0QXJtaXFpWmkzWDI1SHpFV1BPM0R6N0k3QW8yZEJ1?=
 =?utf-8?B?ejVXazkxU2VBZk9saDcvUFlDcXRhV0kwRlBnY2tWZktlTXhYa09VQnB6QXU5?=
 =?utf-8?B?cFd6NE9zYU94UHpFZzRtYXdoMkt4ZFcvWVZBWjRKbDRtYmc1MmdkRjYzNGFP?=
 =?utf-8?B?TDBFTDh2SDJaZ296THFFUFpjYUVlazJjMzZsUVQvWUVYWm1jRitYOHF5akVs?=
 =?utf-8?B?SXgyYTcwK0Z1U3Vyd1N4K2Y3SDFlWklhSG5VbWdzdEgvT3FEcnpENkFLQVFv?=
 =?utf-8?B?WmlBVzJOemMzbmhvd0xJcTZiUjdNbGt3eVFibDFqVGRnSFNTZWdhM2JCU2J1?=
 =?utf-8?B?Z1RHejdobEZORzZWZ3ViVmFTMXByTXBwME1DbHNnNllwMm4zb2R1bFh6ejVJ?=
 =?utf-8?B?YnZzNWhFT0NNUnVWdXJ5MFpHNFNtRHJXdzRyZnhPd1VDaVlZY3hJRmV5bUtG?=
 =?utf-8?B?KzVja1RoN1dmdmlya2cybEo4TlRoUE9RNmppRFhNSWhPbDd5UjVjSDdpeStH?=
 =?utf-8?B?R1dySWwrMWlOVmdwM1VaenkvWkxFME5wUzk0VVQ3cXpPSFNPY3NtcldiTlRZ?=
 =?utf-8?B?OEFQM3BZV0djajR3UVkyVG80VWYvNzAzNnBjNy9YWW9QeUdhNTJWRm5ONWFJ?=
 =?utf-8?B?Qy8vTy9HRjhhR0ZBYTRNNk5mSzZKd25FWW1jNDBJUkpTOVVvTE9rOWtHUFpa?=
 =?utf-8?B?RUlnbFUrZ3Z1alFXNUhnUlFtUVZvQjJ4b3hFVEZHbmtlS1MwYmJ3VkZwT2ZE?=
 =?utf-8?B?SEFpRjRrdGk4OTlOOWlEU255VUw1T0crd0xocXpPUVZ4SU1zK3ZlemNiV2w2?=
 =?utf-8?B?WjRlelcwejA3Yk5TN3N4QUJhMmRFZWtrdlprOXorNDQyaEc4bFdxcWpBL1Ja?=
 =?utf-8?B?bFZMTENOVzJQVHdINlhSSjhXWnlMYWZGdytQL1ltYWpJWHFXWER0VGFaWlRP?=
 =?utf-8?B?WnJFdng1bkdBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6526.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T0gyc2JRME9TbWIrNmVkMzF2T05GaUVwa2RlN3ROdkpXY1Z6cGdUWDhJRXpw?=
 =?utf-8?B?TmdqdVYwaWZWTVRLY2krcGZtcEdQK2pxdFV2TUkwZ0ZyTmxTemxMWjBZa3pn?=
 =?utf-8?B?VXNJOXFKc0FTV25jQXloTExiQW5FMVp2WlFwdm53Ry9YdEdjcjN6Vmo0Mjls?=
 =?utf-8?B?eWpYRklGN2NhVndKVEkrdmQwR1Z3cVpReWM0TllUZVIyZjlyK1dQR0MrNENF?=
 =?utf-8?B?Z2g2T09jdlhlWkRxWDVJWWRwZUMwRU5NLzd4c0FzWXNkSjl3N082cUdDdXlw?=
 =?utf-8?B?bHVIOWVqaE9PU1hlRnNZNHM4TW1QYWtaaFlVZWJhUk5rYWNFb1lBdlk1Uksz?=
 =?utf-8?B?d2JGTHQrTEdDakNsTkRlK1VrYXFEZityckw1VkRlS09KbDBaeVBWR0ZVbVJR?=
 =?utf-8?B?bW1IYTlvUkZqZyttdEx5TXZvQjk3MlBaZFRPblF3RHBrbUcrb0ZpRlNLalFY?=
 =?utf-8?B?Z2JialFvVFZ6TDUwOU9UazZ5SkdtbGN6eEx6QXRjZ1E2WFRqQmJvbUpMMVJL?=
 =?utf-8?B?SW1Nb1FlV0Y4SThRU0hLM1pwWGdoYWJsUFVZRXNvbXF1QTl5cEtwTDFIMXR5?=
 =?utf-8?B?dnBGUEhtaHZBYUwvSG53RFg1RXRzZzhab2VWTWE0QkdSRTIzT2hPLzJVRm1B?=
 =?utf-8?B?ZC93MEVhTytGVHNoNTdveHRyVEVWcGFmNmRmdllrM3ZNRm5QZ2N2OGc3UFpn?=
 =?utf-8?B?Nzh2NDh3VHNQeVFCTXN4aHY0MGpSTldMZ2FPckZZS2s3bHErRXMxeDJ6MzM2?=
 =?utf-8?B?T3lyVGhIelNaNWM3M0s3Y2VibENkT3J0S3l5SnMrd2dwclprOGJtTGJDYkZp?=
 =?utf-8?B?N3VjamlNZFoxZStaaG1iai9TS25qM3lvclNXWFZndnFPMTBpbWhsL3ZRays3?=
 =?utf-8?B?a0VkcnZQZk1qa1F3KzFMcWdqOVEyUkVjMnZlSGkwY09UaTBHV0Q5V2hLZXJU?=
 =?utf-8?B?VkVYZ0lZb0ZDRWRSY3ZtUVFYVkdMbVdrUW14WkY3OGtDTkQ4YmU2ZnllU2g3?=
 =?utf-8?B?RlJNd0MrWTUwc1VVQ3dGTDJ5OUcwUWZiUXJ6ZElSL2FONVk4WUVKdHBwdlNC?=
 =?utf-8?B?djJzZGFscUcxRUc0bjdSd1h4S0ZHUnZCT2p1T1ZvbndMeHRBRFRJUVJHaFpE?=
 =?utf-8?B?Ty9PcnBMbmhhOEl4Y3JsakVReDdMNjc4aXpwYXBjTXprTWtsdDBCOFB3eC9S?=
 =?utf-8?B?S1VONWx3Q3FrYW5zUnpjQXhyb1ZjM2NUNzBWNmxJemQ1YTVDbU5jZFdmaXFo?=
 =?utf-8?B?TjlkbGtrUWRwUzFYbDBlRnR3UWtzRUFQd1NhUUhvaGFudVFCaFdndzdTalNI?=
 =?utf-8?B?RTZ3dCtITzhmdFdSSU55VHBHRGhLY1M4T2srNFNLM1pvczN0M3hsdHIxelpm?=
 =?utf-8?B?bDNjdTN5ZHNKQTdMR0l4N29nKy8rWFZiYVB0ZHVpZlA3WEhtbW9ZN3Y5TTZI?=
 =?utf-8?B?Syt2STdoZkpUeS9uUUVMM01vdEQ0SUx4S1dPcEx5OXN1QmZUZE1DdDdDLy9H?=
 =?utf-8?B?VjgyQktjVDFFdCtIdTFyMUVscmEvc2t4UkpRUlhVdzlLZXg3VDVNWG1EUHdw?=
 =?utf-8?B?ZjFISitiN0VnamJVeGhTeHNHZjVBQXZXT2lSL25aZkdJS1ZhSkFEMURMeDVk?=
 =?utf-8?B?ZTdQanRuQU5yWmxPMzJCTWFHYzdNQmVpVlVOS1pKREpPVFd6Ym5yVmV4Mzl1?=
 =?utf-8?B?V0R5c0tmTkJaZ2w5RkpVanR4UkN2Ym5LUi9MT2NiLzkrMVQvU21zeVEwRUd0?=
 =?utf-8?B?T2ZMSlFrZ1RTOFFkYXovVUUwdWJjaktXNUJyQmxCRU9VQ0ExQU5OdmRQdE55?=
 =?utf-8?B?MkorRlJnTVhTSlAyKzEveFBMRXBRYVM3cThUSlJId0JvVmNRVzA3dUVONUMx?=
 =?utf-8?B?SnBIR0FMaGhkTm03Yzdtb04yaUIveXJJZUpPWkFKdDhmSzN3YVRWMmkyU2oz?=
 =?utf-8?B?RHBsTjU1NEc1OEd6U0dIaWs5UW9zZ0pnRFBPN0s5QStyQTBKa3l4TmQ2U2t2?=
 =?utf-8?B?TjlmanE3YmtDdU9nRFlMK1hPVVNmM3hnZTdQczUzKytPYWZmWUw0U0ZQaXZ0?=
 =?utf-8?B?SGhVVGNMU3AxV2VTUmJCR2FNZ1lSWUZ2dkVxVmJuNGtNK3BaVVNLdmRabmxk?=
 =?utf-8?Q?Q0l/qpe+spCaFYUO4p5o8aqNz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48F4B96DE49B3640AFE6866B35663D47@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6526.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045b0940-5d19-4598-319a-08ddeb3a64ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2025 22:36:58.9858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2UoMPynBHiYIQiANDutdevG0tzE68A/gwWUgg4bApegmpMsRuS5tpXP+9zDjpKCJ1Z46wi4cOEXOVgqq0FGHnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302

T24gV2VkLCAyMDI1LTA5LTAzIGF0IDE1OjExIC0wNzAwLCBaaGkgV2FuZyB3cm90ZToNCj4gK3R5
cGVkZWYgc3RydWN0IHsNCj4gKwlOdlU4wqDCoCB2Z3B1X3V1aWRbVk1fVVVJRF9TSVpFXTsNCj4g
KwlOdlUzMsKgIGRiZGY7DQo+ICsJTnZVMzLCoCBkcml2ZXJfdm1fdmZfZGJkZjsNCj4gKwlOdlUz
MsKgIHZncHVfZGV2aWNlX2luc3RhbmNlX2lkOw0KPiArCU52VTMywqAgdmdwdV90eXBlOw0KPiAr
CU52VTMywqAgdm1fcGlkOw0KPiArCU52VTMywqAgc3dpenpfaWQ7DQo+ICsJTnZVMzLCoCBudW1f
Y2hhbm5lbHM7DQo+ICsJTnZVMzLCoCBudW1fcGx1Z2luX2NoYW5uZWxzOw0KPiArCU52VTMywqAg
dm1tX2NhcDsNCj4gKwlOdlUzMsKgIG1pZ3JhdGlvbl9mZWF0dXJlOw0KPiArCU52VTMywqAgaHlw
ZXJ2aXNvcl90eXBlOw0KPiArCU52VTMywqAgaG9zdF9jcHVfYXJjaDsNCj4gKwlOdlU2NMKgIGhv
c3RfcGFnZV9zaXplOw0KDQo+ICsJTnZCb29sIHJldjFbM107DQo+ICsJTnZCb29sIGVuYWJsZV91
dm07DQo+ICsJTnZCb29sIGxpbnV4X2ludGVycnVwdF9vcHRpbWl6YXRpb247DQo+ICsJTnZCb29s
IHZtbV9taWdyYXRpb25fc3VwcG9ydGVkOw0KPiArCU52Qm9vbCByZXYyOw0KPiArCU52Qm9vbCBl
bmFibGVfY29uc29sZV92bmM7DQo+ICsJTnZCb29sIHVzZV9ub25fc3RhbGxfbGludXhfZXZlbnRz
Ow0KPiArCU52Qm9vbCByZXYzWzNdOw0KDQpUaGlzIGlzIDEyIGJ5dGVzDQoNCj4gKwlOdlUxNsKg
IHBsYWNlbWVudF9pZDsNCg0KVGhpcyBpcyAyIGJ5dGVzLCBmb3IgYSB0b3RhbCBvZiAxNCBzbyBm
YXIgLi4uDQoNCg0KPiArCU52VTMywqAgcmV2NDsNCg0KVGhpcyBpcyBtaXNhbGlnbmVkLg0KDQo+
ICsJTnZVMzLCoCBjaGFubmVsX3VzYWdlX3RocmVzaG9sZF9wZXJjZW50YWdlOw0KPiArCU52Qm9v
bCByZXY1Ow0KPiArCU52VTMywqAgcmV2NjsNCj4gKwlOdkJvb2wgcmV2NzsNCj4gK30gTlZfVkdQ
VV9DUFVfUlBDX0RBVEFfQ09QWV9DT05GSUdfUEFSQU1TOw0K

