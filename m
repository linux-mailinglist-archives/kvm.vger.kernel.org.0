Return-Path: <kvm+bounces-20093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F9B91084B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8DAE1C208C8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C8E1AE09E;
	Thu, 20 Jun 2024 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VOjHCdDE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155981AD9F2;
	Thu, 20 Jun 2024 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893802; cv=fail; b=gFjWqycBdCqsUUBn1OYrVIAvEtulXGY4npwKauWceoT65iAKcx88Dmo1olZG0MJE8mKjzDIaig7rK4Tz2dJrSYnMBLyhHc+YHstx0rNSryKQ6KlzmmqQROYW65ty3Xexo4SldMihiXsz/fx29Z0WwA6LopzhCXZ8l/G4nOyHORg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893802; c=relaxed/simple;
	bh=1odzaZbm3XVpbfEUkn//WKhYJMVNTCIkvqIBIbBw8hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IZP78MqDjpF/g3x1+OuClDII5iIfIta3lwlCGy1jYmkgftKqP+Dd0BZClC9fet9MivXO/9L5FP9RI1iRKtdXii7cLL6At4Gmg5s1Tf4B7SCH0nrHnlfOio/2B/6Hyk/pynIH9jtWJufb/7vxg0pCooiLhF75J3Y55gYFfK+V1Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VOjHCdDE; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUUVI9X5ySiZ8iPkLpxEW5Nmby7ohHN+NSqqGVT1v83VAE0yLgM19YkDYukFHrfnOeKDG1uYcSQSiYciQ9bzl27VAT31mmgkxYYY0nhoEGuZ6TvH+HFoqRGpWmteNqqaSLz349IuKG6OS+pmreePNXUQgnqCepHg/49RDc/8Vd8+xh/f9zvECqCWjyUmNtyhMBHe7aE2mmmxt6fZcFhbYrzAFTaGy+Flbd5xeK8ZiCsX2ZLEV4eDGOz2e2HllegWBLGbXviWVMUv+6xnUG69CWp/+6z2rntsKbWuvWaio36qJGVL8DrXtLamBpbxW6KEwxcbgFbGarF/LjaFqIMegg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIYjr4aY+TGuCVS2Cyhr6i2MlhIUms+LowtNz0CdtOE=;
 b=fz0NedhPwk2VXDgb0Uo/oiodVrt+iruwLpgquEoHNkyFOmV/3Wmq9zAT0YuqjjgxIkN7iHYYUkOvtqZVsQIbTBIGEfHEss+jaCS/P7PfObwt0BU4/hV2wqm72zphF6qfZg+0ZPOXFiLK/Y4wn9yO8InZ5rbJrh9GyjDkFlofucD9/TY78CvrgLQ0yOejqUrJYok8TCJkxbLQWO1n52KKEJ6VvWInDMo1L590slprAsQ0Wwb4nMwAJnvMfShqL5ruWdI2/oQ9Tumj3tXHmaJYg5Eo1/gWa31szEPnGG8uJC77SdPEkoG6uA0twR4Pm9784qwhBBvGKGgT0EXjboSQ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIYjr4aY+TGuCVS2Cyhr6i2MlhIUms+LowtNz0CdtOE=;
 b=VOjHCdDEMOR6ft/TiHQ+0iDnUuevQnZMKio7THo/6FCZiho3EOVyy/wYHUFt4VVjtBSoCMrFZq3L7+i2jhjlX0ym3md6TVwYsKE0JAU6OB+5nFuBke1Clte8GCzksIPhTP8WmQwSES3eJ+K+V4X+nHZ+JmOvJAv3RkAuIXOTI6yRr9/e2YFPYycuh1AnErxPUEW1YiYE5xW4zyrzUOiTCXuHPPFg8pZFdWrWwVzkqR3XHk6X84nQv7J8HPVvuEmY6SRfnqhmQPbCfh+cZ60t2I8nPEFamJlBAlx1KAVnOm6wCMEcTB0CfrJdUEURuoQgAPP8ke/e9uIUVrbTw0mE2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB5881.namprd12.prod.outlook.com (2603:10b6:208:379::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.20; Thu, 20 Jun
 2024 14:29:57 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 14:29:57 +0000
Date: Thu, 20 Jun 2024 11:29:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, Christoph Hellwig <hch@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	maz@kernel.org, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
Message-ID: <20240620142956.GI2494510@nvidia.com>
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com>
 <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <20240619115135.GE2494510@nvidia.com>
 <ZnOsAEV3GycCcqSX@infradead.org>
 <CA+EHjTxaCxibvGOMPk9Oj5TfQV3J3ZLwXk83oVHuwf8H0Q47sA@mail.gmail.com>
 <20240620135540.GG2494510@nvidia.com>
 <6d7b180a-9f80-43a4-a4cc-fd79a45d7571@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d7b180a-9f80-43a4-a4cc-fd79a45d7571@redhat.com>
X-ClientProxiedBy: BL1PR13CA0299.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB5881:EE_
X-MS-Office365-Filtering-Correlation-Id: 7542edcf-6b2d-49e6-76d7-08dc913575a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUZSUlhKSlh5SzJ1OTI3dEVXTSs1NExEMkxrT1RDWTdzUXE3MkFOUHQwSEl6?=
 =?utf-8?B?ZlNjNWpHWXZjSjZNMmJBMEhJVTd3L3NOazFHUDUvZVVoZE5IY04rZDQzU1l3?=
 =?utf-8?B?MGFod1hTd3Y5R3kxR0t2TmF5akp6WXlrSFhuOHJBa1lEVE5YeHl6OWMrOGh1?=
 =?utf-8?B?VkZTRENWeVROa3JYNncyWFlIZGZZNEtrcTB0QjRqQXh2ZXhHQy9IaFlhOXps?=
 =?utf-8?B?RjNOR0ZJQlJLNUNPV01ZY0txMG4zU09DUEZaNzRLOVhEZ2RScHJxeStHbmFZ?=
 =?utf-8?B?dkNJWEVsSzE0allaSmJ3Y3BNZEcwM3FqWEk5RjVWbERRSm9ndWE3RXBnRmNo?=
 =?utf-8?B?My9MY2xHT0ZBYkEvSlc1bjhNV1VjV09HZDJ1eUxGUExrdk1tWDFROVVlQVNw?=
 =?utf-8?B?YzVnM3F6QitxaHhnSDQzc1hOUTBRU2NtSkt4SmV2a1pZS2Y0YkhjYW1rbFM3?=
 =?utf-8?B?NVVVU2hWUVpXZUpPVzMwdXFVUEVwNDB3QUI0Tnl2OEtGb1ExV0h3R21oVDg4?=
 =?utf-8?B?RDNMc2J2dE4rdU8vZ1FmdWVmM3FjeDBGOFJtKyt2TTArV1h4RllYNUd0Ym85?=
 =?utf-8?B?amxpVjJBd3FpaG5DM25tMGl1RmxGM3RnbHQ4S2MwaCtlajJIallWM1JmWmIw?=
 =?utf-8?B?NGZxamN1eGRxRnlaYzVIQW1PLyt6REZ3a2hZdVpnZS81K3pZRFIraU5YOEJN?=
 =?utf-8?B?akRQcElzd0d2TzVGNzB6MVRYc1pQZHBkTC9aN2dCN3NkWG5IcUJIMHVrNTZB?=
 =?utf-8?B?a2pQZnNTV0svNEUzc0xnYVdkbnp0OENtTFBPM29GdWZka2lqUW1pOTMvdURK?=
 =?utf-8?B?R1hCS3o0bFBVd0FMWTZNdkxQdmJwMzBTdFU2YzNoN0ZwaGxMbktYc3RQSGxq?=
 =?utf-8?B?Z3gxcDYzajYySmN4VWlFcUdES3U1VlBEM2pxOGcvRkRUMzUwMEhYWSszWnNn?=
 =?utf-8?B?clhmMUY5aEd6TC9mT3NaSVpaM0NBYnJYNXZ4eFRhMVVOK1BWaXNmSllVQ0x5?=
 =?utf-8?B?cisvNjVoa0xBQitRdk5IV0dadDl5VEl3R0I3dy9QQzhVdTBqakNKdW5SWk5L?=
 =?utf-8?B?dnRzREsxNEI4TUpvT0g3TjIwVkxRaWl5TzNTd2NYNUFXMFJFSURDSWxFVXM5?=
 =?utf-8?B?Z2RzVnNyWkNnRStCQ2ZIKzVQTE91aXVkTjZKNlFyRzFhZnVHallNTnFiSmov?=
 =?utf-8?B?eW1TbVd5UDA3ZnIwNDcyNFRRQkh1QzR1bTE3bEh0N3lZdExEN2NHSGpaaTlG?=
 =?utf-8?B?WDNuK0RtRUJQVGcrVld3Uks2dDZweXVSKzlhemR4dW9aTzhjbVJqOFlKbllC?=
 =?utf-8?B?b2d3SEhEd1hEeTBIU29lZC8wZGJsVncrVXBwdFVtUHJiNE13SHY2N0F0dmNx?=
 =?utf-8?B?dFdoSlJyM3c1NjRyMTlaUG0vRGFHeWJjTlZnTkJOM1Znb1d1MkMyai9idFVh?=
 =?utf-8?B?NXpUQkZHNTQza0ppRG5waExyeG11NWtwVW9wRFlPaUhDUTNBcmdYNXVSblRZ?=
 =?utf-8?B?YUg0RWVRdmlyeml4Y2ZBZitkeEE0Mll5KytvWTRvVWZhZHBDQ0NaOFE3ZlQ2?=
 =?utf-8?B?Z3RhSEc1MVk3MmQ1aTZEZ3ZtR3BBYlZIVDZQdG1JVEtRckc5Yk9qeXgxRFh6?=
 =?utf-8?B?RGdHK2pIZzIyYXhlcDNXS1lWa0Q0Y3h0NmgzdFNRclhzVFgzd0hKdlJ3dUNZ?=
 =?utf-8?B?S1UwQlNlU0JqSmtmbTlCNnRlczluNHd1UFJ4ZkdrZXJ3UzBQZ1dkSnZjaUsx?=
 =?utf-8?Q?QQBmu+NeS42Tnr4N/xevJtpk/rcSTUmjbmmIgtm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlMzUkFScVFja3dQeW0wMDloSXpKRmpEZjdDTkQyd0wvZkpqNTg2cE8zZWI4?=
 =?utf-8?B?Z3M3QjVpcGZCUyt5UlFkc2RpdzBlTUVBdTBiaStVWkVLNmRrUFJyYmpKWkxw?=
 =?utf-8?B?dVZDakZScXQrOEVBcTluSWNUVGpFQWNPWGZlUUVYeVA0eUc5bXpwRkN0Z29o?=
 =?utf-8?B?MXVXQW94WGd1YXh5clhYaWI4SFBNd1B4L0s0R0libW5EbkNZT0FWbEJ2d0o4?=
 =?utf-8?B?OEEwTDVic0FPSkZhdUlub3dRVzUxSHZ6ajRKZlhrK0NDQytxTTRNc2dEUldP?=
 =?utf-8?B?RDR1OStWVG5tSHJyVGRuaFdaMmUrRnhwNWZ2ZDVaQVdFcGY1Wmg5dmg3T2p6?=
 =?utf-8?B?YVFSdkhqdTNpNWNsbFkybWNyQXJhRytNVEh0Y2RJWS95NkQvYkErTWJUT2RJ?=
 =?utf-8?B?Mm54NlEyU2FSb1lYZFZnMitFV0xNWUFySkZVQ1N4dEhWd2JPQ3QyRmsyL1d5?=
 =?utf-8?B?SWNDZDhtbFlUTVVoYVpSRGM4K3hCb0M5U0swU0VKb2w3K2R1anVpSGhTZXho?=
 =?utf-8?B?a2FiQVR1Sm1FSlEwWkNqYzVGMSs4R0FhTFVjOEltQjFYRkdrVzc3ZEhqQml0?=
 =?utf-8?B?Y29oVzBKL2tWajVBU2pkZHhrYkI4ZEdTVlNiWWJobmw3VmkyODJvTGQ4MDZl?=
 =?utf-8?B?UnozL0EzZkJOTDhtbzRpd1hNTXNvMFNxTE9VRVp3Mnh6OS9GMWEyL1FxNDFh?=
 =?utf-8?B?cU5RdFV4SkxxU2Ird29YUU5FdWk3Q1J3WHVQZVBtTVdMajJOQldtUEdWN1Y0?=
 =?utf-8?B?NVRKS3V6WVNIbmZDOHlXUTQ3OXBBWHc3WWFRaGZBL0ZXSndDdUJuVzhOTFdn?=
 =?utf-8?B?YXM3dVV3aTB4S2IvS0ZKZ3dPbTAyamFNbWp1c1lPS2ZFQmlhVmJWWlhZOVNu?=
 =?utf-8?B?NHhvaHJNS3JnTkpRZ1RvQk8zUWFhR2x2WE5aSTI0aXRIK0JKVyt4d1B2UFJ3?=
 =?utf-8?B?NlI2N2NMRjJYbzk0enNwaXo4OEpUYngxekJ2ak1ML3NCZWVGMmt3ZUtOb20y?=
 =?utf-8?B?RllaUWlzSCtaSStjY2VBeVRBTnRlWG4zLyszcTZEWWR1dkk5NTRZUTU4TkVn?=
 =?utf-8?B?aDM3T2dvYitIS2VPdkpjWlc0VitMeGdkM05Weko1d1VUZURmcDQyU054M2Ni?=
 =?utf-8?B?RWhOUjhNbjJZRy9yTFg0WmxKUkIvYXM1RVR2YmpHNE4wYVpFaTNhZnVOQTJD?=
 =?utf-8?B?SWxkQnBGRkpscnVrTWJqZWJTUzAyK05nN3lDQTE1NHhUZE4yV2hEVlk1Ymd1?=
 =?utf-8?B?ZXRBR3BVNWtJWmxUWVdDaUJVc3JWNFNTaERnM3lTbHNNWXVHd3VnQVhsTmNI?=
 =?utf-8?B?ZjdCa3ZnV3RSeG4zdENaV2RuUkJoSDRjMno5T0FMMnhyckw0TVgySS90dys3?=
 =?utf-8?B?NXhpQ0FWakRqamJPQ0FVbEJSNFZVV3A5S1V3UUo1bUhhS08yb2oxYjdUeHdh?=
 =?utf-8?B?ZndXa2QxTjBmcEcwUFRCL0NhckEzUDJJSFd6RnBQVm9NaHhTZ2d4c28rTjdH?=
 =?utf-8?B?eUZ6Rm9Uc09JNFB1QTgwMEVJeHMvZG8wRTBlR2N6L1Fubk03VTQ0NkI5YUhJ?=
 =?utf-8?B?VTU4RVBNY2FSWEQzZkpvVlgyZHJpZjFMQnovZFdFU1Y2UytvZDFRaXczRTVF?=
 =?utf-8?B?ZDB2S2NzSkJ4dlFUZ3IreVQyMFlacmpwQ05rQVFmYks5Mkh0WHg1Z21ubitX?=
 =?utf-8?B?d20wMzZvMVZuMVVnQ2k4YXpQMjZjMWdSWGJEWlBSVkxaRnFNdkhpVkpqTHBR?=
 =?utf-8?B?TWU5Nm9IZTR4SEJVOENFbEU0T043MldZL1N1MVZ1dEpOQ0kyWG5JODc0eGxx?=
 =?utf-8?B?ekxEaXMrOXBEL0FrVU44V2RSaE9Zd3Y5VU1PWFgvd0J0YlFXZUlEV0JTcS9x?=
 =?utf-8?B?em01UWNvbjIybXRuRjZzZ0FPNTdMazE0a0p0MG9DM2s3T0lWcEZZdXpkdkxW?=
 =?utf-8?B?TUtEL0NVM2xNRmhZM3J3Y2hscGZIMCs3amplZ3RFVmdhcHd5VWZiQXpna0VZ?=
 =?utf-8?B?MkliV1RUdjF2SGpzMHBPZ3d5dmtUZVgvMkNESUR4STN4RzQ1K0VFNG9ha1lD?=
 =?utf-8?B?V2huSTh6SVZVOXdBNCt1QUhyVE5pQnh2alpSWm9UMWRnL0kxT25FUk5TSUxF?=
 =?utf-8?Q?85Hx88VqZQZapa2bhyBbSdkC2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7542edcf-6b2d-49e6-76d7-08dc913575a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 14:29:57.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZZ87R2CvHlh22vl4mjP6xPrcNGND/SPQFxwQLvB6hQtdKpoyKFqdXxCVwBivZps
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5881

On Thu, Jun 20, 2024 at 04:01:08PM +0200, David Hildenbrand wrote:
> On 20.06.24 15:55, Jason Gunthorpe wrote:
> > On Thu, Jun 20, 2024 at 09:32:11AM +0100, Fuad Tabba wrote:
> > > Hi,
> > > 
> > > On Thu, Jun 20, 2024 at 5:11 AM Christoph Hellwig <hch@infradead.org> wrote:
> > > > 
> > > > On Wed, Jun 19, 2024 at 08:51:35AM -0300, Jason Gunthorpe wrote:
> > > > > If you can't agree with the guest_memfd people on how to get there
> > > > > then maybe you need a guest_memfd2 for this slightly different special
> > > > > stuff instead of intruding on the core mm so much. (though that would
> > > > > be sad)
> > > > 
> > > > Or we're just not going to support it at all.  It's not like supporting
> > > > this weird usage model is a must-have for Linux to start with.
> > > 
> > > Sorry, but could you please clarify to me what usage model you're
> > > referring to exactly, and why you think it's weird? It's just that we
> > > have covered a few things in this thread, and to me it's not clear if
> > > you're referring to protected VMs sharing memory, or being able to
> > > (conditionally) map a VM's memory that's backed by guest_memfd(), or
> > > if it's the Exclusive pin.
> > 
> > Personally I think mapping memory under guest_memfd is pretty weird.
> > 
> > I don't really understand why you end up with something different than
> > normal CC. Normal CC has memory that the VMM can access and memory it
> > cannot access. guest_memory is supposed to hold the memory the VMM cannot
> > reach, right?
> > 
> > So how does normal CC handle memory switching between private and
> > shared and why doesn't that work for pKVM? I think the normal CC path
> > effectively discards the memory content on these switches and is
> > slow. Are you trying to make the switch content preserving and faster?
> > 
> > If yes, why? What is wrong with the normal CC model of slow and
> > non-preserving shared memory?
> 
> I'll leave the !huge page part to Fuad.
> 
> Regarding huge pages: assume the huge page (e.g., 1 GiB hugetlb) is shared,
> now the VM requests to make one subpage private. 

I think the general CC model has the shared/private setup earlier on
the VM lifecycle with large runs of contiguous pages. It would only
become a problem if you intend to to high rate fine granual
shared/private switching. Which is why I am asking what the actual
"why" is here.

> How to handle that without eventually running into a double
> memory-allocation? (in the worst case, allocating a 1GiB huge page
> for shared and for private memory).

I expect you'd take the linear range of 1G of PFNs and fragment it
into three ranges private/shared/private that span the same 1G.

When you construct a page table (ie a S2) that holds these three
ranges and has permission to access all the memory you want the page
table to automatically join them back together into 1GB entry.

When you construct a page table that has only access to the shared,
then you'd only install the shared hole at its natural best size.

So, I think there are two challenges - how to build an allocator and
uAPI to manage this sort of stuff so you can keep track of any
fractured pfns and ensure things remain in physical order.

Then how to re-consolidate this for the KVM side of the world.

guest_memfd, or something like it, is just really a good answer. You
have it obtain the huge folio, and keep track on its own which sub
pages can be mapped to a VMA because they are shared. KVM will obtain
the PFNs directly from the fd and KVM will not see the shared
holes. This means your S2's can be trivially constructed correctly.

No need to double allocate..

I'm kind of surprised the CC folks don't want the same thing for
exactly the same reason. It is much easier to recover the huge
mappings for the S2 in the presence of shared holes if you track it
this way. Even CC will have this problem, to some degree, too.

> In the world of RT, you want your VM to be consistently backed by
> huge/gigantic mappings, not some weird mixture -- so I've been told by our
> RT team.

Yes, even outside RT, if you want good IO performance in DMA you must
also have high IOTLB hit rates too, especially with nesting.

Jason

