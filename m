Return-Path: <kvm+bounces-32253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD67F9D4B71
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F0C6281E59
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8791D04B9;
	Thu, 21 Nov 2024 11:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q0Eaye06"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6174414BF87
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 11:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732187898; cv=fail; b=NVQ8RYltjt83uaLsTHw4hvQeu6LYVHa0z7lJ1hCNbNg1DMt1W/KzwnIYGB2z+69QV5dX8yLyzuHnH9dJTmwRnMo+cFTFf8HVdfK/+pYc1+c6KDBHGKZMxNQNvCGjKPipSABMuCQW3Qdmhsbr8uJQW8ukqBaGLaK9cA6VhxZV2Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732187898; c=relaxed/simple;
	bh=CsRc1MRPKtywF4pz3tcg+sym9E33/VsJU+CqXZkHQw4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tFGXhuRyzVyi0DiDMktGnGI7dKi386v/9f0FFegPyuUNPqUSz+ewGUdxzakK+r47tXIKKnWJHbVRnJ5/7Qx/Gba3nmGGCvxa4h9lK0JZ016uou2qi7zrZfTHQ93Dnf0Z9sf44zrVETrSlNEnKFdRnGWvNHwsOR7/ZkNCTN/vuZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q0Eaye06; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wFTtR0AmMYLJ9t37iNQ3HKT6mPWM2eGnK6aXKIPgjaZeU62CLUnnCA4GdfiHDVhaXMJt1ueph2BDRDDOz8dk0hxvOg55xCnKXBh2iuQRZXCeI8Vt3PBF6Z33FycIVvdJcB/cYyvp9yPS+nbcGshXoOjy6aQmZ+hH3/nzIPpgsR9B8cwrAvGjDWUkpXk6sUHUI/CWnVHzBFx15PNw/G38SAOMpeSCrk0LnZB9HbVJc36QavdkYIYAekGHqHFnP46rAwF9PprRT+WU6bGqHqHZitAgg5P/y6sSZ/pWHcAwwnR4loFloIKrONF+I+MIqaJyp6Zz4IJUss5waSCMDumxSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rNwYTskykBGhOf0HwiU1q9YUHhwO3yifJCoFRNte9E=;
 b=mjZYB3h/z20XgKCss9ID9JnR1LJxxSzUO+SQ0Ucox/G2uKIiiO0H3RL7s5jJOf/MU8pIQqGpSniDE0NGO7rDAs9efru8FMY6Lw5Gke6trZfdTBwbPPbuuyPUJsieWbKs1JzxgefB87EsH6u+bKmbzM3A+KHwyR7PnixdB8L7oDoznzwCBelKbfWHkHkdcPt9cZal93vKd+S5n7oigUS0+ydYoouex0oTOJ9vUSev4W8UEGV07zasnYEIJxnQYoiJYFmCKRv6T/BzNU9g5rta54ovTUsR/5WfdJn8PGpFPU3S9yKYoKDRml0/5MOzoZ7/tafPey/sOOhykf2BPV1feg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rNwYTskykBGhOf0HwiU1q9YUHhwO3yifJCoFRNte9E=;
 b=Q0Eaye06PPZkbfwHdqU7k254FmYA60UR3WL8pZVLJSVAMD7h1Rw0k/pqrPlnBOltJxQeeqCbQCS3WcBWlr/huKV+nGXGy3KltF/Fnih6njatt6tKNMvtRJ2Nvx+mbc0bmiUxQrHMA+2nGpRDFGygbYJbg3RFlzUM++u9XC9eHb4+iSbzJdY1KMsdg3VUsAdTXW9NSfLjhNLlDXYFe91006VjP4fpbrbBtBMJcyjWSTnSfTq+1XSlc4YUYNwqwipOfkEFA8Ca5Ijz2FkMwR6cth3KDbHXVQvcyJN0czANJ5+5r66CY+TIJwWo70BlvLtyf8sRNk+QH5bX7hqvoNFG4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Thu, 21 Nov
 2024 11:18:11 +0000
Received: from DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::e2a0:b00b:806b:dc91]) by DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::e2a0:b00b:806b:dc91%6]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 11:18:10 +0000
Message-ID: <d5a14eb4-decd-45f6-8564-ca3c4c302f84@nvidia.com>
Date: Thu, 21 Nov 2024 13:18:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: Properly hide first-in-list PCIe extended
 capability
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
References: <20241120143826.17856-1-avihaih@nvidia.com>
 <20241120164232.6b34596a.alex.williamson@redhat.com>
Content-Language: en-US
From: Avihai Horon <avihaih@nvidia.com>
In-Reply-To: <20241120164232.6b34596a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::14) To DM6PR12MB5549.namprd12.prod.outlook.com
 (2603:10b6:5:209::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: fdbfd179-7c57-4cf0-f5e3-08dd0a1e2e86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWRZTzhDU3hEazVtSVA5cHN6TmxlY1BnRUJmZFdCdGt2ZWR2THlTVTY3eUxH?=
 =?utf-8?B?aWRJQWpHOTZ4K25Kb0ViMUVuVFNXRkJNSE1keTc4WWM4SVE3d0hPRDAvN1FJ?=
 =?utf-8?B?Q3hNYUM3WTN6dmRlWFpwcHVKOFd0QkFKb2tFR0c2dVRFbkQ5U1dXQ1d3SVhl?=
 =?utf-8?B?SFlaM082NExUK0lya0oxSEF5dDRTckNPOFV1cUNGOFhYSWZiN1pqQzJTWmhQ?=
 =?utf-8?B?cEV6UkZ6SS92WDFiWnkwcHc2QVBCVEpDa3dzZ0MxcHR0YnlCc0tad2xKL2pT?=
 =?utf-8?B?dTljTkg1eUpBY3JaQ2ZXWXlqbGhPaEZhL0ZmZmg3dXExaHZkaE9QZkxzK3Nv?=
 =?utf-8?B?OGFYcnd0UGp6bW1GN1QyQ1JlZERuTURrMi8zRlgveFJ5TktBK0x3V05zMHZq?=
 =?utf-8?B?Z3k2eW8vTDJMK2pGMWFiRlhia2J4WjJJTWJHQkVrTVU5c1VIL0V5di80YmZk?=
 =?utf-8?B?bGhNZXAzdTVPVlp2S01Pb1pENWl2OTB6bmdldGNYcWs1OHgvNEFwRjQ4T0FU?=
 =?utf-8?B?dWVRWDJLaEk2cDhaUDFzZHFXcmdMNmtKNHJidFhQNWF1cjBTOW5NMEd3cGxz?=
 =?utf-8?B?STE2dUxmckRlTjJ2dzVUVmFIVHhnUHplL0tITUgxU3k2QWkwTmdtdStMaGUw?=
 =?utf-8?B?TXJEM3Q4cjJ2cFlneWNlVkNkT3l6L1ZkZGNjcFdHRTVCK1VPdjQ5bmx1ZHVV?=
 =?utf-8?B?MFN2UlJPTHB5WDRVSG44QmdjWTRYOXB0U09aWkR4Z0hZYUt3elZ0MEt0WXN2?=
 =?utf-8?B?UE5HcUgzU2NrM0ludy9wclA2RDJkNFE1TlRkZDZYaytuQVN6VTRzeXA2WjFZ?=
 =?utf-8?B?VUdQM1p2R0p4U3F4emRqUkRiSXIwV05TUU9EakZhdHJvRjR0aTVRL3F0TmpN?=
 =?utf-8?B?UEo5NVNGeXhZQUFzM1RpSFo4SytBaEJZaW83aDVaWWdNbXRSMGhuei82VkNi?=
 =?utf-8?B?MTI3WXRxOVFxVnYxSlZDazBnb2h4THU3NTE3aTZ6TVRIQi9RZHZZTXRrOWVT?=
 =?utf-8?B?SnBvMmpsSGVuYnIrSDdORTVtd3RFNDJpRDBzVTRvZUVwSWsxd0k2SzRIeVlu?=
 =?utf-8?B?OWZ6Y3A5UllDTFhmb2MyQURiT1dXaWlHUWpJZm9CdWc0N1Jqa0ZhNUZmekhQ?=
 =?utf-8?B?SXZSc1Ztc1ZXdkc5dzZnTGNUbis3Y3FPRlN3aXRaenF3a2NoekZLc1VJbkhC?=
 =?utf-8?B?NFNOMkYzb2Y1T1l6VEFEbFFZeVNZeG5Ub2dtUHJUM0NwUkZmZXpMQ0ZiNmNZ?=
 =?utf-8?B?UE9UempmblNZN0RlVzBRMVRrOHVVUVpSdTFXQUxtNVJFL3EwYnNGL3Q3Vm9C?=
 =?utf-8?B?aTZQTlM2N05tZkFWdmMwUHVGM0ZRN0JveWx0L0ZsL29ZOWVOdmhGcDJhMkp6?=
 =?utf-8?B?Wm05VHUzZkw3bGhYMGhkTGpkWGRmcTIzYmROY3RTTm43c2ZKOThjaU9lMmly?=
 =?utf-8?B?WHJvSDFpWERyNDJkVVAzd1ZTbVJvektDY3FzamlBUFNqSkxmM2tKdGQwNElJ?=
 =?utf-8?B?MDN0MitLdzRrWTBBSTBocjJ2MjJmenR6di9yNmFyTFhFUzZscFdYWFR6SG0y?=
 =?utf-8?B?bWxocC9KU0tSUXBWbXRTU1pIb0IrNG00N3p0YlNyWmhXNHRsemFyWW1yZFZV?=
 =?utf-8?B?ME9wLzh1M0xUcFFsNWVGS25EdXNKUnJTbFlEaW11NDVER1E0WG1hdHBUbGdO?=
 =?utf-8?B?T2N5REdobFZ4U25lU2RLaFpGaXg2M0o5SjJoQmJtSnYwYTFyNFlRMFFnN3FE?=
 =?utf-8?Q?SkdGuz8sUX+Rzp5i4psTb5fC0ct4RizovvjT/AE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXJRcHdsU2d1SjUrcHVhbEhpSTYxMk8vaTJtVzgwVURqQTVnQ0R0WE9zT3Jp?=
 =?utf-8?B?a3lvZFk5VVNwRmhSUzhaRmN1MzZaNTB6a3dGV2ZscUZxcGw2N2Ftb00zRGxh?=
 =?utf-8?B?U2JkM0F0ZEU5V1dma3RUZU1ndFhKcmRGS2xTUm5WQWRjNVdDNDc0Vk11RUFv?=
 =?utf-8?B?amxSVTU0TSs4SVZnWFEyZkNzdjdkZk9SUEppWDdzZkRVd3VZQVRNV3RyUWFO?=
 =?utf-8?B?Qy9pbkp0MTBFeG1PWFVRQzJvdDZybjZoY29BR3RVK1BtbjZYdnIySm93MHNI?=
 =?utf-8?B?RlVZcVJvd0VkbThnN0RTSERRRDZYVU1uU0YzWVczNDNUT0V3K0VkcFA4WXJE?=
 =?utf-8?B?ZUFPTU1ZMFBrL25DSUMzc3VTWDNYcnRlV3B3b1JrQW5ZZGdLc1VHakVURmVx?=
 =?utf-8?B?TmM3WWMrNjNad2FWUDViNjhjKzBGd3BzbUU4dlA0MGZjYTNVZ3pSQnZUVSt0?=
 =?utf-8?B?M3J4Y3lTbjRlQmJXNEhlTTlUTzY3dnFZaTdGdWZvTXJpZktwMnFrYXFNVUYz?=
 =?utf-8?B?VGs3OXlBRm9tMzNnZFQzR3A3WDZUUlBTUXVkZldRaXJtVTY2L01QbkI4NmRO?=
 =?utf-8?B?MkdPUkY5amtyT01OSUpJSDNEWi95Q3FlVm82RFRoYzNCc0FXOHdkVE9zTy9m?=
 =?utf-8?B?NG9KOVk1V0NNUlF2b21OMEJTeEo3OFJrTFBBeFpVZTZuT3JwM3RIUTRKSEJM?=
 =?utf-8?B?eWNXY3c1VVlYaE9KSllmN2tTUTFYYysrQWZMWUZLRk43VWlvcDU5V3ZPZXJW?=
 =?utf-8?B?SkhjdmFVN0Q0SWVVUEFlOHAwYi93aVFXR0szMGV6M2NjcWEwSi9tN0gyeUpz?=
 =?utf-8?B?c0tJN3RkKzBCR3U4TFZETHp5dzVpQmQzSERQY2xnbnZSOU5pR0QzMUxPOWEr?=
 =?utf-8?B?eGxiU0YrQkZkZU1rS2s4VkRzWW9VV0RRNDdrZkFsaUxNNUxIV0F1MGhjY3NB?=
 =?utf-8?B?NDhNZnc3MUxpN3lrcmNIYWhOd2toTHdhSnRQc0Q0K1JGTnZTR0hPNU85V2hK?=
 =?utf-8?B?QlpxRS9RSm1ydm0wNFhIMCttK2M5QWtTaUR4UVpiakJadVlCV24reTlZdzEw?=
 =?utf-8?B?OWlrRTlsdVpmWkhKU2VGbzBKeG4xaTlyVk50ZFh4cFgxd3MzNDNidWlQR0Vs?=
 =?utf-8?B?Z2QyQUplMDA2QTVDVSt3bjJTMU1NQWNyN1FoREhjczQ2ZytGYlMwUldjN2k5?=
 =?utf-8?B?bHJQWlk5OWlpeDc1djNKTWhKNUJ4SFc1Z3BuSVJwTHc5cTRORDhTak93VHNJ?=
 =?utf-8?B?T3N1d0ZDbllMZzVrUnVhTElqOFhjd1FldXNqMDJNVmRtUFUvOGd4REVhK0FL?=
 =?utf-8?B?b0Z3N29uOWdSRlFDaXZwU1RrNjYxbkUrc3MrcExDWXBZRVVPUVpYcHkvZ1Bk?=
 =?utf-8?B?QVhSSkduUWM5RFFKZkhGYlpNYmtaWS9WeEwzbHRpS2ZxL3ZyaW9DYmdQU1lL?=
 =?utf-8?B?VlJGOTBiUXlIMkJ2cTRXRFlGL05QVkVOM3MxaGt5QzRxRTJaTzJsUjkvRStp?=
 =?utf-8?B?cnZWNndmdDZITzgrWCtSdkVjS0EwcUhDRDhWcW92OFRFUWNwTEJDSTd5MFRN?=
 =?utf-8?B?ek5aTlN0cDRaQ3VQcDVKclJQV0hLZmxEck53R1BBeHJwelYrU2kvaEZaQUkw?=
 =?utf-8?B?RVNmNnJlNjFVRXFSbktpZGVPT3lpQlF0NlluRnI4cFhDdTB4aHQzc3NQcm9M?=
 =?utf-8?B?bkxhcFFlZGl4Tjg2bVlGTmNySWd6bVo0ZmNmK2VYL0pLQVdDVHZuNTZGSzIw?=
 =?utf-8?B?WktaYTVvMWoxRGJmU3BGcjdIY1FKMVYzbklsT0JUMGN2YVVRanMyMmk1WFl4?=
 =?utf-8?B?WHQ1dmY4WER3T0xHRnluQ0c2emNPTGg5bkNJOWdVS1dxUUR3NjBFazMxVEVn?=
 =?utf-8?B?ZXV5MjVzdVdaTTBJN3E0OFdWQ1FHSGl5VEJhbzg0aEVBVXozQUpTUVc1Y25l?=
 =?utf-8?B?TUg2dGNRd0dHYWdMamRoNklEVWEvTUE4KzRKNXRUb2Jrd2JTaTdFNStZNEJt?=
 =?utf-8?B?TUR1OVdGOUVPNStQR3ZJQUNFbFR6Q2EzR0J6OEtGV21YOUp1WXhOWUlPMWFS?=
 =?utf-8?B?eXFHY1VvaWlRMStYNi8zc1JDTndlWUZ2SzM2UU9SQXZMQ0VrbVdYbTVBWnZR?=
 =?utf-8?Q?H8rfi7B/iV7IEHYz4Ypv8rRzq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbfd179-7c57-4cf0-f5e3-08dd0a1e2e86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 11:18:10.5270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9v1IWh02lagfbNEA5m/cXJoi+2mzHn9OTXdrqpmxy6goziqFWaWU9xiWKs4YPVcioRm5JVabMK/6qzwsBoNRtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248


On 21/11/2024 1:42, Alex Williamson wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, 20 Nov 2024 16:38:26 +0200
> Avihai Horon <avihaih@nvidia.com> wrote:
>
>> There are cases where a PCIe extended capability should be hidden from
>> the user. For example, an unknown capability (i.e., capability with ID
>> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
>> chosen to be hidden from the user.
>>
>> Hiding a capability is done by virtualizing and modifying the 'Next
>> Capability Offset' field of the previous capability so it points to the
>> capability after the one that should be hidden.
>>
>> The special case where the first capability in the list should be hidden
>> is handled differently because there is no previous capability that can
>> be modified. In this case, the capability ID and version are zeroed
>> while leaving the next pointer intact. This hides the capability and
>> leaves an anchor for the rest of the capability list.
>>
>> However, today, hiding the first capability in the list is not done
>> properly, as struct vfio_pci_core_device->pci_config_map is still set to
>> the capability ID. If the first capability in the list is unknown, the
>> following warning [1] is triggered and an out-of-bounds access to
>> ecap_perms array occurs when vfio_config_do_rw() later uses
>> pci_config_map to pick the right permissions.
>>
>> Fix it by defining a new special capability PCI_CAP_ID_FIRST_HIDDEN,
>> that represents a hidden extended capability that is located first in
>> the extended capability list, and set pci_config_map to it in the above
>> case.
>>
>> [1]
>>
>> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
>> (snip)
>> Call Trace:
>>   <TASK>
>>   ? show_regs+0x69/0x80
>>   ? __warn+0x8d/0x140
>>   ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>   ? report_bug+0x18f/0x1a0
>>   ? handle_bug+0x63/0xa0
>>   ? exc_invalid_op+0x19/0x70
>>   ? asm_exc_invalid_op+0x1b/0x20
>>   ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>   ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
>>   vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
>>   vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
>>   vfio_device_fops_read+0x27/0x40 [vfio]
>>   vfs_read+0xbd/0x340
>>   ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
>>   ? __rseq_handle_notify_resume+0xa4/0x4b0
>>   __x64_sys_pread64+0x96/0xc0
>>   x64_sys_call+0x1c3d/0x20d0
>>   do_syscall_64+0x4d/0x120
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
>> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_priv.h   |  1 +
>>   drivers/vfio/pci/vfio_pci_config.c | 18 +++++++++++++-----
>>   2 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>> index 5e4fa69aee16..4728b8069c52 100644
>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>> @@ -7,6 +7,7 @@
>>   /* Special capability IDs predefined access */
>>   #define PCI_CAP_ID_INVALID           0xFF    /* default raw access */
>>   #define PCI_CAP_ID_INVALID_VIRT              0xFE    /* default virt access */
>> +#define PCI_CAP_ID_FIRST_HIDDEN              0xFD    /* default direct access */
> Thanks for catching this!  I wonder if the explicit tracking of this
> via another dummy capability ID is really necessary though.  I think
> the only way we can get a value in the pci_config_map greater than
> PCI_EXT_CAP_ID_MAX is this scenario where it appears at the base of the
> extended capability chain.  Therefore couldn't we just do something
> like (compile tested only):
>
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 97422aafaa7b..beea05020888 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
>          return count;
>   }
>
> +static const struct perm_bits direct_ro_perms = {
> +       .readfn = vfio_direct_config_read
> +};
> +
>   /* Default capability regions to read-only, no-virtualization */
>   static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
> -       [0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> +       [0 ... PCI_CAP_ID_MAX] = direct_ro_perms
>   };
>   static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
> -       [0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> +       [0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
>   };
>   /*
>    * Default unassigned regions to raw read-write access.  Some devices
> @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>                  cap_start = *ppos;
>          } else {
>                  if (*ppos >= PCI_CFG_SPACE_SIZE) {
> -                       WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
> +                       /*
> +                        * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
> +                        * if we're hiding an unknown capability at the start
> +                        * of the extended capability chain.  Use default, ro
> +                        * access, which will virtualize the id and next values.
> +                        */
> +                       if (cap_id > PCI_EXT_CAP_ID_MAX)
> +                               perm = (struct perm_bits *)&direct_ro_perms;
> +                       else
> +                               perm = &ecap_perms[cap_id];
>
> -                       perm = &ecap_perms[cap_id];
>                          cap_start = vfio_find_cap_start(vdev, *ppos);
>                  } else {
>                          WARN_ON(cap_id > PCI_CAP_ID_MAX);

Yes, you are right. This works and appears to be simpler than my fix.
I will send a v2 with your suggestion shortly.

>
>>   /* Cap maximum number of ioeventfds per device (arbitrary) */
>>   #define VFIO_PCI_IOEVENTFD_MAX               1000
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index 97422aafaa7b..95f8a6a10166 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -320,6 +320,10 @@ static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
>>   static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
>>        [0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
>>   };
>> +/* Perms for a first-in-list hidden extended capability */
>> +static struct perm_bits hidden_ecap_perm = {
>> +     .readfn = vfio_direct_config_read,
>> +};
>>   /*
>>    * Default unassigned regions to raw read-write access.  Some devices
>>    * require this to function as they hide registers between the gaps in
>> @@ -1582,7 +1586,7 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
>>                                 __func__, pos + i, map[pos + i], cap);
>>                }
>>
>> -             BUILD_BUG_ON(PCI_CAP_ID_MAX >= PCI_CAP_ID_INVALID_VIRT);
>> +             BUILD_BUG_ON(PCI_CAP_ID_MAX >= PCI_CAP_ID_FIRST_HIDDEN);
>>
>>                memset(map + pos, cap, len);
>>                ret = vfio_fill_vconfig_bytes(vdev, pos, len);
>> @@ -1673,9 +1677,9 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
>>                /*
>>                 * Even though ecap is 2 bytes, we're currently a long way
>>                 * from exceeding 1 byte capabilities.  If we ever make it
>> -              * up to 0xFE we'll need to up this to a two-byte, byte map.
>> +              * up to 0xFD we'll need to up this to a two-byte, byte map.
>>                 */
>> -             BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_INVALID_VIRT);
>> +             BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_FIRST_HIDDEN);
>>
>>                memset(map + epos, ecap, len);
>>                ret = vfio_fill_vconfig_bytes(vdev, epos, len);
>> @@ -1688,10 +1692,11 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
>>                 * indicates to use cap id = 0, version = 0, next = 0 if
>>                 * ecaps are absent, hope users check all the way to next.
>>                 */
>> -             if (hidden)
>> +             if (hidden) {
>>                        *(__le32 *)&vdev->vconfig[epos] &=
>>                                cpu_to_le32((0xffcU << 20));
>> -             else
>> +                     memset(map + epos, PCI_CAP_ID_FIRST_HIDDEN, len);
>> +             } else
>>                        ecaps++;
> We need to add braces on the else branch as well, per our coding style
> standard.

Ack, I will remember this for future work.

Thanks!

> Alternatively we might overwrite the ecap value where we
> previously set hidden to true.  Thanks,
>
> Alex
>
>>                prev = (__le32 *)&vdev->vconfig[epos];
>> @@ -1895,6 +1900,9 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>        } else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
>>                perm = &virt_perms;
>>                cap_start = *ppos;
>> +     } else if (cap_id == PCI_CAP_ID_FIRST_HIDDEN) {
>> +             perm = &hidden_ecap_perm;
>> +             cap_start = PCI_CFG_SPACE_SIZE;
>>        } else {
>>                if (*ppos >= PCI_CFG_SPACE_SIZE) {
>>                        WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);

