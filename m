Return-Path: <kvm+bounces-25034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A0095ECAB
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 11:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC05281C1E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 09:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAB41422B8;
	Mon, 26 Aug 2024 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RBHFPDGB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2054.outbound.protection.outlook.com [40.107.101.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E36EAFA;
	Mon, 26 Aug 2024 09:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724663179; cv=fail; b=pHFhU+3qeCTEUrnDv+Kdxj4A/mghvrZgaWgYcCsbloUCrzMrW2+bvEX7cHndUVdcmilAdA5GGrSdbCYKYsAk0tgHs2HP6hqsndGajI3guOqsNJO+o+5R8t7KRLICBNeB/32/lSDXbY3x7E/z0wq21SaOtIzcqOyY/Efjv/BwsBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724663179; c=relaxed/simple;
	bh=hUIZIP5Y9IAttjfxKZznd90Nug2G1/LE0xa5UWe2dKo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZzYtgtuafKaMsw5kSzTSmwt8EWzawO48p2rJfXU6vwlRr9k8SwYqLu0/nxv9uhkYwNZ/O3TPZpyS9DnAI6OIfUBW7AD2X6woBxyr/9ak1bUhLkqSdAycKyAl+gzRlAhdv1UAzUqdCnHJ1ctgYORfl787NX0mVv9dCoNtgZTlacg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RBHFPDGB; arc=fail smtp.client-ip=40.107.101.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o00lu2Ugvg1XWK8HKby8X9Bwltf5l8y6ild/7OZy0CtQgWRLNFkG/j70Cix8f7Qr6Ims2Ynzc/dqDlV7C70VBML3TqkJKZ52JfARj56yzkUabJ6mWDQbVzxHtMdvu9LMQBM2QUnX/lcmZUSgeu1opv6YQEN2aPatsSt5eLsBgUPhR19UMWkQBI+bePqvD5Q181n1ba0hblsLljnvJNvEtelmAmcXH3oOFfku9+7o2rI4mk09to60jTE2gcR8MHRqNkXnUF5z+3oBBtDsKJ5fvUr+AL2a9Cdt9E4LVkWjiFI/rQJQFMI7sZi2YxbixhwfBKSL9EATaD/f1KT637M2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPUu7IR3kanO/LVo8zem4hmfPdTL0mCUbBXofmAb9ZY=;
 b=PNlqHkKg2b/Kayxo1ZmVXuSI8spgsQpyPLXD45xeEWvkRrrVgL7xTuENjYJk3yBLMPK5IkNjIoeqmdeVsPfRm3oE+UNbuhEZpqEMNp9flxp9PX0IQw0GyXKsdPrUp4BJwciwT+zoxYDJopXovW1jquLJTpCI279fAt3/uLEOsJCT+PUeQm6V7hwuXJmtemy0KGh6pDWHnkLOryBfJrnfxm8JzpXI1vU5K5TSLkXvS7lbIzWEHKKe+anEt91KkLnEY97jM7dY531iL37KYyJgeyMu34mRnLNXTsTPyd1eGFMBmXRKs/5SYmZlVPyzCJPdo9FMWUbgsC5XX/cbM3Fkqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPUu7IR3kanO/LVo8zem4hmfPdTL0mCUbBXofmAb9ZY=;
 b=RBHFPDGBPAnXMJOiBGmPAHYFv3lyAUZL1Olwz9RYlHTYG0AQJ6HL6xzaSbt018lrmZoV4rq1xbTg3Hlmlphe3epHohtXx0xCT6Z5kCC3zrgfI1fgKyQt/Cc1n7nXR1HM7R/ycq8JArUblp88/kYQxsa53AbvLLln26bP2xriiHmfo51FKCR6yxUGX3DH9oXZyyufdUUAUn2wqyd65gb9/ByhXs16jidyvOlFMF5kM+MfRGqPO9mSVNaPJge9VFbQ+zXYCjCIwKWWtZwGVq3R0lLv/JzQjAQqvAnrQs7gnAplqhcpsSLku2ePrpUAoYk8JUbC6yWStQEGr1c56relww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by IA1PR12MB6530.namprd12.prod.outlook.com (2603:10b6:208:3a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Mon, 26 Aug
 2024 09:06:14 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 09:06:14 +0000
Message-ID: <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
Date: Mon, 26 Aug 2024 11:06:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Carlos Bilbao <cbilbao@digitalocean.com>, eli@mellanox.com,
 mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
 sashal@kernel.org, yuehaibing@huawei.com, steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0421.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::6) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|IA1PR12MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6a91aa-1e37-4aeb-68af-08dcc5ae5660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkgrMGdCbkJXc09ETHZGblJ0TWxCTVFUa1RObXcvdkd0eXNNR0NIOXF1eTc1?=
 =?utf-8?B?N25pV01VSjJyOHBuaFpSQXg2amFHTlNtVzc2aHdVUHlneHVZWEllNmduSDIx?=
 =?utf-8?B?QkErcVJCUFpVTmVySDdScVhGS3NhbUhDemQxMkVValE3M2tyZTNhaTFkNXp5?=
 =?utf-8?B?WS9nSFUvMENEbmpWTWVkbmdiV1cyd2lreGd4WXdqV0UrZVlXZ2VRNjdLVnpZ?=
 =?utf-8?B?alIwd1JxZUdOWmhBbjR5UzM3Y0t6Uzl4Q05PRUROSlNyOWFhcmhueTlXMEFL?=
 =?utf-8?B?cVdBNXNQaWRRMkt6QW1pMmYwcUh6aDlCYk1KbDZ5aTlvdFRsMGo2ZzM1b01L?=
 =?utf-8?B?UE11bHF4eSsrbnhFNUhqMEFOcmIzMkRBSFd0RW9CbWQrSW1YcW1hekpCL2Q4?=
 =?utf-8?B?dEIvYUxuais4cCt4ellFNXF3Q21EM3BJL2JCRENTaXd2b2JobDhhbms0U3Nj?=
 =?utf-8?B?c2lqbXN2aGNFbnh5alg5c3ZKaFNTN2drNlU1Z3g2WWczVkZLZFc4a1JsZlFl?=
 =?utf-8?B?RUpOVysvSUFGTjdISGtmVVFmNVZ4ZEF4aW5LMk1PanFYTEtFMXllYW1iRjkr?=
 =?utf-8?B?Yk11ZlJuM003UUZUYVlhdFBETW4rU0l3ajhadGlodnZQS3VhNVFjVkJhTC9Y?=
 =?utf-8?B?Yytza203ZmJQVkNVSC9WazJNUFpmcDhYNzlIaHQwVlVqU0RRdWRRcGJKSVo0?=
 =?utf-8?B?cFNudmhXS1ZZalR4OGV0U05RaDRjaVBnVlkzQW42N0xRb01VbDVmMFc4NEUr?=
 =?utf-8?B?NEd5YU5hT2dCbEN6NWJKOFBONXV1ZG9VU1llNzNTN05CZUR2UGgwcGVucmdU?=
 =?utf-8?B?bGVkWmxtbHlwdzYwamFkNmdYekoyazgrak5DTE1wQlhnYmNnZmdEWTV0eVJR?=
 =?utf-8?B?dlMxekdDWGZDUHJjN1pmYnc1NGpaMkhxQ21YZ0owcEtNTFBuSFd2MkUzZHhC?=
 =?utf-8?B?aVE3bmFSSjdhSjdHVFJvVDhURy80MklWY3JzK1hjeEhqUWEvOEJIWllvMnly?=
 =?utf-8?B?K05QL1JnRGhjRTBPRlhZZHl4VHRlOGVCVXluaG8rVkM3L2o2bG5XSTZOd3BK?=
 =?utf-8?B?MzBvR3JpRGd1elFWeGVSQ0lGaERwdmFUWnZiRm1XcWk0TFp1MFlzVS9HRW94?=
 =?utf-8?B?TlV6dXBtVEZmMlpNQmtmdkhlT1pEdGRacnVRdXdRRjBwRGpMY1BsZHgxVlZY?=
 =?utf-8?B?MmhMdk1GQW95VTJsZFIyUGRsM1ZZTzVWK1UveFJYRFNjbGk4dW9CaVhmTlJJ?=
 =?utf-8?B?SzZoQ1RKaU81S3dNRnhmUGg2VlZGY3RqNkpqcDdCV294MnNzcFgrL3ZCOFNz?=
 =?utf-8?B?Tzg3S09MekkzQ3AxZk5wdGI0TG1aSGszTzNFTmlwZDJlSHdRVnNPaEFQTTBE?=
 =?utf-8?B?MlVxOVdpRWI1T2hGd3NzU1ZzdTFuSENYeHd1MnFhM1JTOEY3RFYvcCtSVzIw?=
 =?utf-8?B?UnN5cUU0Y3lMNjZJMW1YRlVoRFJaQkE4aTNReWZqVVJrOU5XcEJLUWxxNUVj?=
 =?utf-8?B?VEIzREpFaEJIeHVLQlpZdkVjb3IreHY3NFBRNkhpakZTSTFDMWREc2JLdENt?=
 =?utf-8?B?VkZJQi80V0xJVnk2bGN6aHBkaDJhWFlXTTI1Z2FwWFFOZU1wcytkcUNSa040?=
 =?utf-8?B?RHYzdmRnZSt5dXNOSjhDTUxFcEFVK1l1RmM3Z08zQjZZeXBxcUpJRDN5R0h1?=
 =?utf-8?B?NVVHSytjV3crVUQ2b08wTjAxTkxtUFFtWjE5Sm5xT3BvT3o5SUtlZ21QQnZC?=
 =?utf-8?B?ZWNOQUlPNkhPUm5LOVNhRkt5VS9NVnVoVHRYRTFwUkcxTHJpbERRUGp3TWlR?=
 =?utf-8?B?TUgwaU53cHRQdldocDVMUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGZaUy9IRGtjUC8zN29VTzFuZU9IQXNyOTRCTXdDZGtwRjFrOTh5b2F6UVYx?=
 =?utf-8?B?NStENFp6L3hPTkhPRUFVbU41OEFSd3J2c2ozY1d0QXlCc0VvRlZEV1NKcVdE?=
 =?utf-8?B?S2gxcE15aVNTSngwU2RXdEpPNW9NdzFKNzh3YWtzVE02VmJ5Nyt3SFVEYnJ6?=
 =?utf-8?B?Y2JZMjhSUEVCUE9BZ3ZBTlJxdWo0OFRYNXVhMW9SbUJ2VkZCTDgzWXMwSW94?=
 =?utf-8?B?ZUEwbTlZTkVrb1JwR09vbEx4MVJtNlFPdnJvYUI1eE5YVnBkamJDMWc3Sk1E?=
 =?utf-8?B?NTN3alVqbVVOY01tckdleWxPVmQ3VnJUaGFhbTVwa29paXBNRUxub0JGTkVG?=
 =?utf-8?B?bVE2NENyVWVzQW1xRWxiMEZkNFNMNkxqbC9SUjRhaUxaRzg2OGphdEg3cmQ5?=
 =?utf-8?B?Ym1EbHBldkRma1ZTNG5KWVN3akxMYU1OYWxDWFYvWDl4K0dCZXhaWVcyeFFK?=
 =?utf-8?B?MGE2aGhuTjRaNGJVUyttdFpqTVJ0WnZON3dzR0E4c05xREV5b0F3Qy9sVVZP?=
 =?utf-8?B?R3hYUzVFUU9CVG4yMitVWUdvdmhTbk5QSTA2MWszU2c0Z0hUeWtxbTFxQmpO?=
 =?utf-8?B?NVl0ejV6eFVOcDQwek9wTnluU2w5bW5Nay9CQjVmMGZVUXVHR1BOaGliM05p?=
 =?utf-8?B?UDVCV3FaODRDK08yakZ0blZNcE9zZ3l3MFhmeGwvckRZZ0gvTktiaVhjdzBw?=
 =?utf-8?B?T2VnYktoM2ZBZThRT3JRTjFNa1BGTkhtUTIrSWJDcE43Z3lZNSsxU2RNNHRD?=
 =?utf-8?B?ZTNLQVg2MzYrb0RHOHN3RVE4c25CZzRkTkszR1pkQ2QyZXpoNGd0RW5SdFpV?=
 =?utf-8?B?Tm5sN0J6OG9RVnFjY3R1eUh0Zk5Bd2RGS25GWWRGeUN0RlM0K0tRNWZveTBs?=
 =?utf-8?B?REMyWVZyc0FtWWZRYnd5UlBsNUpROTQ1cCtUS0ZiYVF6cTBHclZaQjdiQnhJ?=
 =?utf-8?B?MjdLa3VIckZjSHR2RXkvTDg2SEZnSkNtYkd2Mlk3dTFFNnJBN083M0NoK3Y4?=
 =?utf-8?B?VDNUdG9TdEJlTWRFejQ0ZmVVWTJ6QTZNS0ZCRURhdG1KYm5nK0EyOUF0aUxm?=
 =?utf-8?B?TTRLaS96T3dvS3B4R0dwNThFRnllZ2dCSzE3bTQ1ZEtzOFNBTkpXQkxkMCs4?=
 =?utf-8?B?b1FOeFppWk5KckgycHVEb1Frc000R0ptRSt1dXZ1YjlsVGdjV21sQURSRHJ2?=
 =?utf-8?B?YXp0TW84ZmQvZnBwN3JVNDhNN0s4N1BQUzZFRDJ3ME5RSHNtczQzVFhiL292?=
 =?utf-8?B?L2N3NnlITzYxcVJwdndEc1dYMjZuZ0srMnJPK2JMUWNWaFJDYXFlREtOQ0Yx?=
 =?utf-8?B?UXd2R2cyQ0xWWHYzWCtYSnprZG9VeXRieDN1TThheDlVM1FFODRzUlZ6dEQr?=
 =?utf-8?B?Sk9BWU9TWkY3YXR4UTNJUG93QlA4dFhLN1FPV2xjTmYzeFNEWGZPR3A0dGNW?=
 =?utf-8?B?UUF5MW8rWlpwVXdMZmdISjFSaFRTcjBjenZLdmYrZFc4OHAyemhpK2c4R0ta?=
 =?utf-8?B?WS9oZThRZmRQb1BjbVFkZ0xpU3pheVdkSTJ0clhCTWdEY004OUZ4Y28va1hj?=
 =?utf-8?B?bnJSaVpJYlpsUUt5VC9QaWFMS2p2N1YwOUtwdWJ2NG52Q2JNRWFEN3YvY200?=
 =?utf-8?B?MEJDakRhMDA2Z2lpRHVjdnUxV3Q1MXV4dExacm9Ra1JxK0tqYnJUYTlFc3k4?=
 =?utf-8?B?MHFjK1N6b3ZnWjFERUIzNzMxODhxZmRubEV3N2R5M09sMnYweVNtS3dmcksx?=
 =?utf-8?B?L0ZOWlA1SzJ5b1NkWXVuRUwvU1BsSS9Qdjh4QVhhWnRwS3RrTVNpdnhsVERC?=
 =?utf-8?B?YWdwVjlKamthQWdIM05oYzlmaUpGWDRyTnpkK1N2dGYwUXBvTWtPWWF5U3NW?=
 =?utf-8?B?cEY0Q21mM1JHbkQ5b0JKb3lya0dYUWtTRktYQVgweUVTS1c3R3RPTlFhL3ZE?=
 =?utf-8?B?aGdMNS84YmhZRmY3dDMrM3RxODB6RU5SeXhoWG1pTUZLOG1CUU9xVmZVaEkw?=
 =?utf-8?B?TXlmN0d4V2hkZWQ1aFV1a3VJWmNQQStJVlZkZmZyeXdXKy9GQ21lRkkzb3pE?=
 =?utf-8?B?ODI1ZFYvaWJHS3kzUjhUK2lSdFBlaWNRTytaTkpBWFlEaStaWlJCL3BjN3Ro?=
 =?utf-8?Q?5Mn0VCKZ2s7rbzKy8e3B3i1pQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6a91aa-1e37-4aeb-68af-08dcc5ae5660
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2024 09:06:14.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNM+o7qkUgLLHo++hodb0ntUbH48+VgaJkmk4IMGWnEqC2VJLhCzGmHwE69NArw3jdby8/Kat6EMNWnEU/bsoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530



On 23.08.24 18:54, Carlos Bilbao wrote:
> Hello,
> 
> I'm debugging my vDPA setup, and when using ioctl to retrieve the
> configuration, I noticed that it's running in half duplex mode:
> 
> Configuration data (24 bytes):
>   MAC address: (Mac address)
>   Status: 0x0001
>   Max virtqueue pairs: 8
>   MTU: 1500
>   Speed: 0 Mb
>   Duplex: Half Duplex
>   RSS max key size: 0
>   RSS max indirection table length: 0
>   Supported hash types: 0x00000000
> 
> I believe this might be contributing to the underperformance of vDPA.
mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
feature which reports speed and duplex. You can check the state on the
PF.


> While looking into how to change this option for Mellanox, I read the following
> kernel code in mlx5_vnet.c:
> 
> static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
>                  unsigned int len)
> {
>     /* not supported */
> }
> 
> I was wondering why this is the case.
TBH, I don't know why it was not added. But in general, the control VQ is the
better way as it's dynamic.

> Is there another way for me to change
> these configuration settings?
> 
The configuration is done using control VQ for most things (MTU, MAC, VQs,
etc). Make sure that you have the CTRL_VQ feature set (should be on by
default). It should appear in `vdpa mgmtdev show` and `vdpa dev config
show`.

Thanks,
Dragos

