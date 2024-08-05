Return-Path: <kvm+bounces-23234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3419947ED5
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 17:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E0EB1F22E62
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 15:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5806915B55E;
	Mon,  5 Aug 2024 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AYnUREM/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D73914901F;
	Mon,  5 Aug 2024 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722873542; cv=fail; b=rQ3DUIjQasg6OacTB1oCH6jkf8jfny+hW6uqeT1Go8pnDmUhrITC3+Esj3CoBUhnwVR5wUwLmFSIQdIJwAt0zEdOUZNuQITqHY7nCQGjqCItD/IW1cNy/B91haKXFhXMh2aO3f1fYBzxpDNz3uLv2aULl/J9u023BfMr+12098Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722873542; c=relaxed/simple;
	bh=GF5dRs/qrIIT8HD8HT5gf1nXZhfSUhZq1B7kvQFGuws=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qd/xuzmnSeIpXUd54Nyv+kHLUc6STqG6JOexuAN5HioIqKfxp8CqUnVFeykbNPMnv1rLYX2RWmGoY5o7YhyWecNGnp+4GjqV42vTJBu5m1Za8KuQMOQibmjEFUcCZnN7swROxnmtWIFyoNpAKuZcwJnq9S82nLdQC9/Z9JBvIIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AYnUREM/; arc=fail smtp.client-ip=40.107.95.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qiZEPzh52g8jomLtbqxQe4NHG4KVt8b3s0eAyVZXvOWXDWFQQQzWNZJ+hSQLqvUjChWz7A9yF0ceAElP3+lHiXXsRkz7LcnVhWiF76VnBi58+AEShpx3S3ZZuVI/epDC2HecqetLIHZGPjmx9RjSNQMWPbtR/DI5bGVz8lRPstyHriXozOjXRFuppVjwuNfH2OfdBI3DpBpVlC9TgiW1w9lj1jn2PcmBs2DMBGJsXGPqypyxaPIJhB162Bc7J8OQTlLifA/lcG7w/lJTWlSalif6I+0/avM7hhAvQLo0sJU7K7IKdgT0E/o2dSjfjNRtNe7EqlaurANBd/swq1rTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdhNQTVxiXjEiB784v4IrWFcPeVV9s8m4MLZL6IOUEY=;
 b=i05fwbU6hRKo+0u1xV5LgzfyV9aYBsgVD5hrheaRI+Gs2S/N9K5ziITyVXoXZfuxCQNrFhX33Ng5No4ZeTxx4PKMxCj8ap3gpFcEHHA9aee6Z/hqjtdgY/rHcgud7VV6FJP06s546JqNknd9G48is6dWmtcmTL6yJuGvmekIlI+enhd6affDW942cJTMMtY2AodogBgit585sYjfirjpHxmpMF888TZKe2V9HRCTna16VpmHn13UV93IvL6NLYyvwZEa1vY3g4l+Cv3/ZPNGa0mYkD4+YsLT3pQEOBK3fFJ0ntVdImmu0vkBhmJuIlNmovX1l2BxwrlJ17d+QR87+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdhNQTVxiXjEiB784v4IrWFcPeVV9s8m4MLZL6IOUEY=;
 b=AYnUREM/Yif254KQBZS3tXPOl4JsJIyMmHoKSoybX4QqaPCdspFcCcQ6tdvscqYJD86ZWAcch2hiJQjRG8vw00PojOlUXF6Xx08e6lHCP7fMliQZqmfbi09sVG1eJ+EovZfi2w8pXthwcrVz5sZnUMSmNFEZm600IKWLI33EdJ3u5jKgyuL2SouPrudYpGAkjNy0P8/iQ0uI62bsaLPhrDhjTCjfaENG4Tjp0VOEDEIkZE5ifBbvMC95VZZCMZgGm6htugYj1P8L5LIt8mMmlrK6Obfys9j+MN0iiMSyXPGdFlUYoVACF8HuWRebwjrZ6o5JjwSi+BaH3PvjPVoqtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Mon, 5 Aug
 2024 15:58:55 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%7]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 15:58:55 +0000
Message-ID: <cc771916-62fe-4f6b-88d2-9c17dff65523@nvidia.com>
Date: Mon, 5 Aug 2024 17:58:50 +0200
User-Agent: Mozilla Thunderbird
From: Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
To: Jason Wang <jasowang@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mst@redhat.com" <mst@redhat.com>, "eperezma@redhat.com"
 <eperezma@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240801153722.191797-2-dtatulea@nvidia.com>
 <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
 <51e9ed8f37a1b5fbee9603905b925aedec712131.camel@nvidia.com>
 <CACGkMEuHECjNVEu=QhMDCc5xT_ajaETqAxNFPfb2-_wRwgvyrA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CACGkMEuHECjNVEu=QhMDCc5xT_ajaETqAxNFPfb2-_wRwgvyrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0322.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::15) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: aee732df-05ad-4139-1a3d-08dcb5678226
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alRld0VkeThlTDdzMExsSXRMSTA3UkwxSUd4aUcyWEcwTUhkYzd5aXR0QStC?=
 =?utf-8?B?eGRBeWJDcjMzanFnSDIzZDdCSXE5NUVkb2I2RXhRTXBkZkloLzdGTHRBdDF5?=
 =?utf-8?B?Vm5YbVhKaHBQNjZNRmhWa2ZER0tRL1h5cmNVeXlyZGp2dXUwVEVVMUoyK2d1?=
 =?utf-8?B?VlNOQW1VL2c0N2dLMFZUS2Q5dkRHNHRGcDdoWEdYV2pmd0N5MzFEZ1Y5MEt5?=
 =?utf-8?B?b2VEczQyVTJGcDRvWld2a3FRYXp3c2p0VlhKYUN4VnlXL3JCd3cvMFcvaEN3?=
 =?utf-8?B?M2g0QzA3QkV0SHNmTExZY1h2REZKaDhHOUNQbFd5R3FYNnJKYVB1MlV3WCt4?=
 =?utf-8?B?c2ViNmg2VHh3cEtWSXk4UURxcUtDQjRyc2x6M3NlTWdDUnhzeHJUeWdXUWN0?=
 =?utf-8?B?Tklkdnc1U3BMOVd5a21OWXdwTlRya0l1QVpJSy9qT1U4dHdHTFFBbm5PMXFG?=
 =?utf-8?B?Vk40Q1ZhQkpzN1ZRUDN0c2dCUllQOGQydCtZbzhSQjl1YU9pY0tFTDh2N282?=
 =?utf-8?B?c254L1hZZWdKb2N3SWU2eXZLSk8xKzM5Q1d2dGJoVzF5YkVKcVlaUHFnU0k4?=
 =?utf-8?B?MFh0VzBQRE5KZEJsTjRkL05ZL2hRTDMwMzZHRmZIZ3hhWHVPSWd0anphVEJ6?=
 =?utf-8?B?MHdvZHVNVTZPb2h0bWYrUk5oRWFmYTAxSnRWT0UyWk9NNUdoZXdDN29KRmNE?=
 =?utf-8?B?UExXZnV4ZHpvSTA2a2k4OC9jKzFubXJxbi9KK2JKMjV5TW13OXRCSUp5dUpu?=
 =?utf-8?B?NS9qVWZrS2RxU3U0SGhXR0NjbHJ4aEZvZTdEcXBjKytIUXc2SmhmTW9neFJo?=
 =?utf-8?B?UjhZbGdVYXk2bElFRm9qZDZvbS9XaTNPbURMYmtSUFBadmgrQTZMdEJMb2Rp?=
 =?utf-8?B?TUFVbW5pUzdES1Z1S294V2hPUzVOQ1pGeG1GRlowWHcxMEExNWVWVkZ6R0pz?=
 =?utf-8?B?Z1RuK0hLRGpLa3Q2QTgwNnJwSlllbHBMQndRbEo0MFQ3ZTQ4Q25teVZnUlk1?=
 =?utf-8?B?dzdwck1yTy94YUlqSU1nMU9UdVlxcUJUbFFaL0FwVWg4WGtpRjFhbzYrMUhJ?=
 =?utf-8?B?aXZrcnZDT1Q4bGMwVE9sSFJsVVpPYWhZOXh6WXNFV2RRZ3RtUlZvUS9BNFZl?=
 =?utf-8?B?b3BMRFhYTUlrWmdWSWM3WjAyQ00rSExNQkJ6aWdRcEphdU5sa2ZNNGpVTmJE?=
 =?utf-8?B?eXIzZDNTaTNDNjRURFp5d2VzRzdpSEgrZ0FDdDdmUXVPeklQMzZYOXIxWnU3?=
 =?utf-8?B?TTNJTDdrMTdyQlVjRjltQU5QTStlR3ZIQW4rcEN6SzRPSHJ6L1ZSQXZJKzc2?=
 =?utf-8?B?eFdHRHV0NEZ3MEk2WHl3VytxTFluaVF6bkJWbjNNdWZSU2o5bC9rWGFpcnJr?=
 =?utf-8?B?M2kzaXk4Q0ljenZWVm9kSnhlY0pqaXpaZVlIeEVVMmZwTERTV1BXdkZBR0dX?=
 =?utf-8?B?WURsODRTKzd0OVBmMjB3dlRKcDAvOWJsNStvTEF4UU14MlRWaU5ZV3k2S3ly?=
 =?utf-8?B?Q042SXZvWTlzekFVZ3c0d1lKcW56ZVYxdHdYMGYwY2lxaHNPd3h4NWx3UHJ1?=
 =?utf-8?B?NnBnMzl6SSs3bHBxaDVpTlNONjVlLzZoY2xtQm1EUlBaN21YeWlVOWFNYnNp?=
 =?utf-8?B?N1p3OVdrRkxBdlYyTzFMZmRhQU1IamtKTHpyMVVKVHY2UUFtSks0REhBNHJL?=
 =?utf-8?B?SldsOFNzMnF3cEpnZlFrbC9tMDVFRjN1YmJGVnBaOVhlaTRPb0c4T29PVzF6?=
 =?utf-8?B?ZW16T0VaYWorZHREeWwzUmZpNlUxMUEzcFN2V0RpMHMrTTc5TEE3dmFma0Zu?=
 =?utf-8?B?L2JDejFuTFpFYlNFcWROUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXJVemdQbEl6dGVOSGNlVUNFOElrVWthWEMyeW9EYzlQL1RCR0Y3Q3ZVZU41?=
 =?utf-8?B?ak5HZ1dRMHRKK2wvYmY2ZXlvS01RZ2FuOHByeUpDYzU2aVFPOU5DRjhEUmt6?=
 =?utf-8?B?aTVoeHYvUDZpVnRML2s2YkN3THhwS296MUhpMllPTm1DbTkwMnM2T3JCL3VT?=
 =?utf-8?B?c2dqandTNG05RGl5Y0drdVpHVXE3ZnlxTm9uLzFyVElZbXkyRCtnNlNXcDA3?=
 =?utf-8?B?eE82Z2hmdW1CUHlaNkRtdUlVYUFpTDFvK0hndldZRjBNYXRueFNBNytIaUla?=
 =?utf-8?B?SEIvM0JNTU1DaHYyRG5wZzlaUWJVZUZBSzU4VXdVYlpFckhCSWVFY3BBSE1M?=
 =?utf-8?B?eXlRSjAraHc2TnlyMUluYUNqcGFPdE9JWnR3VzdsK1ZYeGp4cEQyVXlKb1Z1?=
 =?utf-8?B?VmRiOG5HMlNXSUJVYmw5eHlDUkVVaDQxT1NITktHb2dKMGhaWnlWdnBXK1ZQ?=
 =?utf-8?B?RXZjZkFnNzA1V3RlVGRRdy9zOTN5MEo3TDU1U3RFNnFGTXJjUXFWV3NGRVBS?=
 =?utf-8?B?dmxuUzlCUUVadUlIOUJlcXFqc0dFZHVkeHIvQUFzbVBOZ0JjWUhUMkk5bktq?=
 =?utf-8?B?bHRLOUhnRnl0ME5wS2xjQzVmeUVLMXZneDgzRm5VRksyV0c4RHo5UU5wb3JE?=
 =?utf-8?B?SFRscnpjeU1udzUwMVlnc3ZqZTNNR1dVakJlYkpQVjYvRlNSSy91YWJacE1Y?=
 =?utf-8?B?d21EU1ZoS3pLUE9KWmxkU3NLaVhqTHNSNnl1NWhRZkF6bGJaUCtpLzIxMmVB?=
 =?utf-8?B?SEt1aDlDb3ltUk9MUjhMbjNUSmJsaUlkTUZQTHNaOERoWWhSaG1TaGpVL20v?=
 =?utf-8?B?TDJscXdPRG56dllPczltSXlsTW5JS0tOSXVhSDNwNVB2QmlWWkl3WW1acHht?=
 =?utf-8?B?alZ4N3o5Q2tTbzM2M2NmUjRRZHVRS3IvQmdiUk5DNUJ1TGxiUFBGYkhBOHdR?=
 =?utf-8?B?bDFKL2llc0NJcHhHTUxHY09jRi8vSVhDV2ZGcXhWd0JFY3A2VVRNOXpGT0Nh?=
 =?utf-8?B?RkZaRjAzaVRNQWdrUHNFeTcrZzFCTmozUk9ncU5QVzVVRU1CWk43RkloS3Js?=
 =?utf-8?B?ZU9KQ1Y4SVlNYTFKK2tQNlgzQXd4VVh4SGR3cTR5ckFNN1piMERIV05aMzNJ?=
 =?utf-8?B?NVE1ZUlzUUt0SVJqUE05QWpxSjdId3NsT0pldkJrOEZxRTRFWTNDM1dDS3h4?=
 =?utf-8?B?SkdZWFlPMUYxQUdxUXA5aDdlb0k4Vm5vTWl3dCt5Sm1Ldk1lSUVhdk5yWmZ0?=
 =?utf-8?B?d2ZxTVFmR2FDcE9yZkVZclp2NEZmUDROQ1QyTW1Sczl3MkhJM0tWNUZCallR?=
 =?utf-8?B?SWdYYU5oQmVIM1YwWmZma1pnMkNVaGZRY3FqYkVESE1EZlFLRFRyTUVaeHZ5?=
 =?utf-8?B?a3hXYTVGVzl4R0xGbEdDNkR6Mnp5RnppaTdPR091QU91NFhzTWlEc2VGTDVa?=
 =?utf-8?B?TFYyVTdVbzF4aWl6UGdTMWJENkdPRjV6L0E2VFN1QnhES1A1YjRUTVYyYWJJ?=
 =?utf-8?B?REUyeUVvNituRkkvS1BKdEZwbWFjMXBOdkxIc2U1c0M0UG55UDhXM3pLZ2w5?=
 =?utf-8?B?Mk4zRHJoazgzY0cvV29JbTR3Yy9aMGpUMjZ3bjRieE13YmRUZVhDdmludjYw?=
 =?utf-8?B?aFNQKzhHY1gyVFJjdkxKd3lVRm04bCt4OXB0bkpiRVhaRFNJN3hTMERGcS9R?=
 =?utf-8?B?ems0L2JvZ2xFTzJ1SkZGaUI0MFBYYWVCUUtId21HT3l2Wll6cnIrWERJRmFF?=
 =?utf-8?B?K3FxUWlMR2ZHREk4elFTVU5Yd0R5cjdKcXFhNVhkdlRpdGx0cXU5N1picE5x?=
 =?utf-8?B?YmVjaDE0akx1aEFqMTJILzJkRjljSVErQzlNRlBONlVWZWwzUTkzUUtZUmNx?=
 =?utf-8?B?TWZ2VzIrVDNzbGIxbjhvQVNqd1o5ek8yZzdydlBScXVwOVQ0NCtSVjRPdEdq?=
 =?utf-8?B?TXBiajBuRzFmWExyUStsYjM1NjNSOXc5T3dsSDFhMkFVT2ZUcWtaMEw3QXIz?=
 =?utf-8?B?TlZDelNwWmV2UHNWVi9teXF5cDQ3dTBHeEgwdHhNQzBXTmpqVTlQenY4b0JJ?=
 =?utf-8?B?amtzZFFCNG5FUXhRVVRqVjFGZXNDWHZkSGd6MDZCMnNNcjhLUlRLQ2FOWnZT?=
 =?utf-8?Q?p18yq4vAl6FT7/9buDaMPhoXN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee732df-05ad-4139-1a3d-08dcb5678226
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 15:58:55.1732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gyny5/qg6xKGCT5w9JyqMP9BgwRtduRh7Df2KQBILhCvYb96AJkHTW6OnEIYs6HAgJZKZ6xj45yhP2GFt2MFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136

On 05.08.24 05:17, Jason Wang wrote:
> On Fri, Aug 2, 2024 at 2:51 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>> On Fri, 2024-08-02 at 11:29 +0800, Jason Wang wrote:
>>> On Thu, Aug 1, 2024 at 11:38 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>
>>>> The following workflow triggers the crash referenced below:
>>>>
>>>> 1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass producer
>>>>    but the producer->token is still valid.
>>>> 2) vq context gets released and reassigned to another vq.
>>>
>>> Just to make sure I understand here, which structure is referred to as
>>> "vq context" here? I guess it's not call_ctx as it is a part of the vq
>>> itself.
>>>
>>>> 3) That other vq registers it's producer with the same vq context
>>>>    pointer as token in vhost_vdpa_setup_vq_irq().
>>>
>>> Or did you mean when a single eventfd is shared among different vqs?
>>>
>> Yes, that's what I mean: vq->call_ctx.ctx which is a eventfd_ctx.
>>
>> But I don't think it's shared in this case, only that the old eventfd_ctx value
>> is lingering in producer->token. And this old eventfd_ctx is assigned now to
>> another vq.
> 
> Just to make sure I understand the issue. The eventfd_ctx should be
> still valid until a new VHOST_SET_VRING_CALL().
> 
I think it's not about the validity of the eventfd_ctx. More about
the lingering ctx value of the producer after vhost_vdpa_unsetup_vq_irq().
That value is the eventfd ctx, but it could be anything else really...


> I may miss something but the only way to assign exactly the same
> eventfd_ctx value to another vq is where the guest tries to share the
> MSI-X vector among virtqueues, then qemu will use a single eventfd as
> the callback for multiple virtqueues. If this is true:
> 
I don't think this is the case. I see the issue happening when running qemu vdpa
live migration tests on the same host. From a vdpa device it's basically a device
starting on a VM over and over.

> For bypass registering, only the first registering can succeed as the
> following registering will fail because the irq bypass manager already
> had exactly the same producer token.
> For registering, all unregistering can succeed:
> 
> 1) the first unregistering will do the real job that unregister the token
> 2) the following unregistering will do nothing by iterating the
> producer token list without finding a match one
> 
> Maybe you can show me the userspace behaviour (ioctls) when you see this?
> 
Sure, what would you need? qemu traces?

Thanks,
Dragos

> Thanks
> 
>>
>>>> 4) The original vq tries to unregister it's producer which it has
>>>>    already unlinked in step 1. irq_bypass_unregister_producer() will go
>>>>    ahead and unlink the producer once again. That happens because:
>>>>       a) The producer has a token.
>>>>       b) An element with that token is found. But that element comes
>>>>          from step 3.
>>>>
>>>> I see 3 ways to fix this:
>>>> 1) Fix the vhost-vdpa part. What this patch does. vfio has a different
>>>>    workflow.
>>>> 2) Set the token to NULL directly in irq_bypass_unregister_producer()
>>>>    after unlinking the producer. But that makes the API asymmetrical.
>>>> 3) Make irq_bypass_unregister_producer() also compare the pointer
>>>>    elements not just the tokens and do the unlink only on match.
>>>>
>>>> Any thoughts?
>>>>
>>>> Oops: general protection fault, probably for non-canonical address 0xdead000000000108: 0000 [#1] SMP
>>>> CPU: 8 PID: 5190 Comm: qemu-system-x86 Not tainted 6.10.0-rc7+ #6
>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>>> RIP: 0010:irq_bypass_unregister_producer+0xa5/0xd0
>>>> RSP: 0018:ffffc900034d7e50 EFLAGS: 00010246
>>>> RAX: dead000000000122 RBX: ffff888353d12718 RCX: ffff88810336a000
>>>> RDX: dead000000000100 RSI: ffffffff829243a0 RDI: 0000000000000000
>>>> RBP: ffff888353c42000 R08: ffff888104882738 R09: ffff88810336a000
>>>> R10: ffff888448ab2050 R11: 0000000000000000 R12: ffff888353d126a0
>>>> R13: 0000000000000004 R14: 0000000000000055 R15: 0000000000000004
>>>> FS:  00007f9df9403c80(0000) GS:ffff88852cc00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 0000562dffc6b568 CR3: 000000012efbb006 CR4: 0000000000772ef0
>>>> PKRU: 55555554
>>>> Call Trace:
>>>>  <TASK>
>>>>  ? die_addr+0x36/0x90
>>>>  ? exc_general_protection+0x1a8/0x390
>>>>  ? asm_exc_general_protection+0x26/0x30
>>>>  ? irq_bypass_unregister_producer+0xa5/0xd0
>>>>  vhost_vdpa_setup_vq_irq+0x5a/0xc0 [vhost_vdpa]
>>>>  vhost_vdpa_unlocked_ioctl+0xdcd/0xe00 [vhost_vdpa]
>>>>  ? vhost_vdpa_config_cb+0x30/0x30 [vhost_vdpa]
>>>>  __x64_sys_ioctl+0x90/0xc0
>>>>  do_syscall_64+0x4f/0x110
>>>>  entry_SYSCALL_64_after_hwframe+0x4b/0x53
>>>> RIP: 0033:0x7f9df930774f
>>>> RSP: 002b:00007ffc55013080 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>>>> RAX: ffffffffffffffda RBX: 0000562dfe134d20 RCX: 00007f9df930774f
>>>> RDX: 00007ffc55013200 RSI: 000000004008af21 RDI: 0000000000000011
>>>> RBP: 00007ffc55013200 R08: 0000000000000002 R09: 0000000000000000
>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000562dfe134360
>>>> R13: 0000562dfe134d20 R14: 0000000000000000 R15: 00007f9df801e190
>>>>
>>>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>>>> ---
>>>>  drivers/vhost/vdpa.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>> index 478cd46a49ed..d4a7a3918d86 100644
>>>> --- a/drivers/vhost/vdpa.c
>>>> +++ b/drivers/vhost/vdpa.c
>>>> @@ -226,6 +226,7 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>>         struct vhost_virtqueue *vq = &v->vqs[qid];
>>>>
>>>>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>> +       vq->call_ctx.producer.token = NULL;
>>>>  }
>>>>
>>>>  static int _compat_vdpa_reset(struct vhost_vdpa *v)
>>>> --
>>>> 2.45.2
>>>>
>>>
>> Thanks
>>
> 


