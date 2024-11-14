Return-Path: <kvm+bounces-31877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 314FB9C905C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4F1E281FAD
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81263183088;
	Thu, 14 Nov 2024 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oxeTC0v4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC52AE77
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731603577; cv=fail; b=h98aphkfWAPRigeOT8BjJbvo5C3k7BuMuR37TKH/x4xA174kdXNu1lam5OFNrx2dJ7osGHB5G8AkfI2v2KzUTGpUzVz98mLXshb1SLWXo1Uv/p3qLoagLXh5qFlENUxa33IataFDMH1jwb1M1JoZiQEIwcNYhkVgJrSPfInGrQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731603577; c=relaxed/simple;
	bh=bzyzXfb8nvq7l02tmyZ/b97gFmsdbD4vE2sX/7ZOZ3A=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ANjOFrQ1Rc0OYNgjoWyzdlDLjstv22NHIkGoNSCfH1p/HUhJ60trwJSyXdJQgQMQpydwnPotXLbaAcKMLsk42gy/Wywlzmf2pHTpd6Q9q/6jjMqM+f7hvsOyueluStCtbenmEA1saCIZSiqHi2mVvI2vuzq+Akd7xsPLbP7nmg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oxeTC0v4; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BtGZcGIlAwyKdKk8ltARa7lkCchLTgSM12VcwSD8Qi/L4hIW9TYGclT3ANFHDYGEb82szIHde6g90eP9WJ12GZlgv4qniBwuMMSReL1iOYv0uJOP6t/OlYHU3JieLLSCpm5z2auUyFKp2R0Rks9lhV13mgCdzBbSZv5ZKzXJJJUZt1YEpd21P4ntTgtsJx3dGo8Rw7dsV6zlnVWzk1gejD0qQ5Qr9u0Q/oBOOdWR0TcoFycZ7QHBjiKtkkN3QPhPpaoajqUwNwDG58SNobd+2fxHDJrRhTV3P7F1XP477yedvWA9VkrfOEUNPUmyBm9I4LNgG8mhbh/AiqXC6VWEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ip/h5DZ0lQV4JDHja0kfIHPido2tS89jtOhsDs99Di0=;
 b=v/zby0WFLApAk/S47BupYrTFBXta+d3Qi9XHu3zMdDs5sdM6GJb1ZAzLmr5w09OPt7NOPO8P4GoxiZKIX377o2mhiBAfJXbixFwrwnA0C9KTFtjDz4cdjlMwsP5yyUhTW0UL6dC9Ccl2tR4xsiOrYzG+B9KtNbtSB2Bs3ct+cJ9osXQ7VXMdBRokemvgFrF+elRNlDrI65m5gq3aQTuB3TAXmkAqENi19lyJD9o3RGOkn0vQpLWCeg+fSnkEALIbeh+lgljLTeffqWD3pbFh0vd++83PR0oQJE9Ef8Jb8IQ2TOq5nPCQ5qBwOkd1OMa7Dti5qqFuVRYhEdDKi5LIkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ip/h5DZ0lQV4JDHja0kfIHPido2tS89jtOhsDs99Di0=;
 b=oxeTC0v4BQNEog3heGcmvN34a+VC9pRuNPqgVlKr1oRk/IdIcvy4piJoqEdeFsJ88Mx/zOApyGibu9C9pf/33o5YebDb1OyKG04CpwsubAuMpxYxVY6ORbYSVrrQ3o1ssAZ+P2oKsoZosFfMEtLyPxUkX61CtDg1zEiI335l2pw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM4PR12MB6255.namprd12.prod.outlook.com (2603:10b6:8:a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 16:59:32 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Thu, 14 Nov 2024
 16:59:32 +0000
Message-ID: <b3b9361a-d1b0-4430-a842-d50bd19a5f59@amd.com>
Date: Thu, 14 Nov 2024 10:59:28 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 7/7] target/i386: Add EPYC-Genoa model to support Zen 4
 processor series
From: "Moger, Babu" <babu.moger@amd.com>
To: Maksim Davydov <davydov-max@yandex-team.ru>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Roth, Michael" <Michael.Roth@amd.com>
Cc: weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
 paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
 mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
 marcel.apfelbaum@gmail.com, yang.zhong@intel.com, jing2.liu@intel.com,
 vkuznets@redhat.com, wei.huang2@amd.com, berrange@redhat.com,
 bdas@redhat.com, richard.henderson@linaro.org
References: <20230504205313.225073-1-babu.moger@amd.com>
 <20230504205313.225073-8-babu.moger@amd.com>
 <e8e0bc10-07ea-4678-a319-fc8d6938d9bd@yandex-team.ru>
 <4b38c071-ecb0-112b-f4c4-d1d68e5db63d@amd.com>
 <24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru>
 <2394ca75-409d-4ae5-b995-27f8b196a1fb@amd.com>
Content-Language: en-US
In-Reply-To: <2394ca75-409d-4ae5-b995-27f8b196a1fb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::17) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM4PR12MB6255:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce581c8-96b5-4ce5-8de5-08dd04cdb596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlBCN0MrOHFrd3JNL2doU1J1b0dKNFIzVE5tb1Q3RVZWd2c3OFl4WVkyYmtT?=
 =?utf-8?B?NEZLVjJyV2t1VktZdXBBc0ZOR3IyK1V2TmswZ0o5Z0VDYmswTnVqeTBzU0hK?=
 =?utf-8?B?YWNwTmJ0Wjh5SlVWVGxQOUtJdUJkNVZVakdZM0JsSkFNU1N1YjVGMCs1QkFL?=
 =?utf-8?B?SFVFOTc4aVAyY1NKSHBKQ3YwZmZBRjM2T0hBVEdXSWp1ZnRIdEVSNjdKMlVl?=
 =?utf-8?B?N1NUeGhBM1VDVjEvbGo3SGFtS0pEUSs4VUFIRGx2SXlDN0t3UWx3cHk1VEZQ?=
 =?utf-8?B?NDl4bkpISHJDd0VLUVhwMEJwcktOMkIxenJ6VURxdGwwSEpobDhrRGxGVm10?=
 =?utf-8?B?cC9uOXNTcWk1M2NraEVhUUNJQUU4b3dybVNFTHNaNzE1QnJlU21MYVBib3hj?=
 =?utf-8?B?VkFaRm1RdnpPVHBiRGRISnZDUXJLUUNYYU91N1kvaER5MHU0VzdIMENqdHJU?=
 =?utf-8?B?U1FMSjBOWVRYL3R6NEVaYTJiSkdPSnhLOHE3clZFNFdxSlozRVhGSzNYazlp?=
 =?utf-8?B?VkowUjB2UTQ3WGxGWmhRSXIzV20zdTFTaTgzbHFKREpzUzUwKzEzWFBFZkNh?=
 =?utf-8?B?aTRDc2YyTDJINktaOXVUMEZKMU9hK1hSb2RvT0R2b0wwT0Z3WDZaanRqYStP?=
 =?utf-8?B?NjdWL3VmdnQ5L0dXb2VIaFp6RHQzTGx5b0ZCekdmTzkyVGpOZUFDQkdma0RS?=
 =?utf-8?B?N3JBYXVxanJVelFuU21sOFdRK0xHWGJaSE9YUWhQZ01oakhvM3c1RzFVMUxV?=
 =?utf-8?B?c3JJVXR6Y2RTZ200TmlJSnJoc1FYZGIxdktUWU03THlJbGdVQU9lZUsxZmNk?=
 =?utf-8?B?ejRxS3Q2aUJxNHdLM2lxZFMwKzJmTzAwWi9RaUhiNmZSWG1XQVN4UnhwTlhT?=
 =?utf-8?B?M1V3LzdweXZucGFIR3VibWswU0I0cVRya1ZNNjVYaE5zdUdKY2plWGdXdzBV?=
 =?utf-8?B?b2dtMVVTMUc1b092VzhmV1daVnBHeWdjd2JvY0JpRnJ2NjBkY2loUEM5UWF2?=
 =?utf-8?B?Mzg0eVliTEx5ejN2RnQzalFlY1phWWFFUDBoK1F6RldHbHZLMy9wWTkzbURS?=
 =?utf-8?B?ekhVQUhCcTAycmNaeUpyQTE5eFovR2J2cEZwTHZEa2NjOWJHSVo3a09mbnFL?=
 =?utf-8?B?WWtXSmdLcnNGcTkya1pPUDNaclpDR2pGN011clEzUWtOdTJXT2tLelRwK0tI?=
 =?utf-8?B?bGN0aXVpZWtaeVJxdWtiK0FQVDgzNEhxaWo4TVgramRMM2Fka1ltMzZScHJ1?=
 =?utf-8?B?NUNCVjE1REhJRFFuUEY5TW1lNjdCNjZtZ3IwZ200WDFDRnNlU3JWeVZhY1JM?=
 =?utf-8?B?dWNVcVpVRWUrTFNKWDl5SXdNaGE5UVlxWGVJZHVQV2hqelI1VERadUhQQUhq?=
 =?utf-8?B?L1F3UENkVkk3N1RmVS9pZk42emprTmVTcWpzaGR4Tk16ZWg1aGJWL2hRMEM0?=
 =?utf-8?B?RHFQU1JiT2VyeTNXYVo3a2VHb3pKWTRNWTU0aTRsSDl3b2l1Szh5Q29XOHVF?=
 =?utf-8?B?YzZtQ3hlelBUZXcvR2dvM1NsMXVsT0JzV2l1Z1NuR1BtaEpmMkJaNEFwc1hX?=
 =?utf-8?B?OWFJWjRkU0RkRjBXc3QxQjlVQzVIOGVoa2JVSmR1NGxtMkRQbkNXWStsTnRi?=
 =?utf-8?B?TVdKZDF1OXV5VTgxQ1VuYStBQ1BDV2t0QjNzU014YjRxRzh6c3F5emozNEFn?=
 =?utf-8?B?NHhZME1qR2VJb2JwWTdHU2dNUVhYV2NJeGo0ejVYVG5ZbERqTUZDQWxNZmw3?=
 =?utf-8?Q?gFjgwyvavpABZbluR3mMxtxYfL+fowVg0rfcLMH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVd3TmhvRXdhSXg0NTMwbW41SFl6eDNuVVBWOWdzRmdCempvT3hvY0tFQ1NM?=
 =?utf-8?B?V1A0MVArVVR6SDlaUkZnbGNIaTJNc3BTc2JrSHZWQW9Da0pBaDh0ZmhkY09P?=
 =?utf-8?B?NE1xNDg2ZG00WHhaK2pQbzY1TDhHb29aK3ovN1lxaUVCcXh4UTJLZzJYUHBk?=
 =?utf-8?B?MlR5K1lHS2s4ZUZIR2s5R09JS3c4TlMxZE8rZ2NFbFBVaGNpTzNzOW1pTWk1?=
 =?utf-8?B?SFZrN25LbWVzL280Wk9YQ0g4Ky9EK3JyTnMxZmFKdW5xZlZaazFrb3puV3pV?=
 =?utf-8?B?S0RCVHRMdWI4WEx6RVZtaXpqamhQTTVSbGEvZytRZzNkMHc4eVNWV3liUzhS?=
 =?utf-8?B?VGkxZENWWEFIWTFqYjA1N2hickRZRzFQQ2lFdnRkeGc3alJlZ2pydlNWNVNp?=
 =?utf-8?B?dS8yalFqa3Y4QW85elRTY3RTbkR5U3QwdlBPS3BwMVNQZVI5SUNEY0YrZHVp?=
 =?utf-8?B?b1N5WnpONzNub0oxMldLYzcxeFdYYVpWb3FrSGpkczVGOWI0c3llWmdxejNR?=
 =?utf-8?B?Y1ozc3RWSmk3NjRTV3ZoaUNzU2VmaVFqUXo4bExtdnNtNWFsODRMTDJQbVJm?=
 =?utf-8?B?TURMZ1VSbjk1dlZRNDlZOW9nTDJJT1d0RW91MU5oTnNZZms1K25qUWo0Y2h3?=
 =?utf-8?B?bnFFSDVsTmQrVndrL0FXcjBhRDBLNGZsdSsvN1gzZDF0OFhNeHdZaXZhOTU0?=
 =?utf-8?B?Rm1ISkZ3S2lvYkt6bWcyKzloeVl1d0ZLbGFqTmZnaWpDV2p3WmVFTHd3dDJH?=
 =?utf-8?B?aHo1QnI5RllnYmF4VmpzSDl2d3hkcnZ0elhDT2QrcHpVYnd0TmJFMDlFeVJJ?=
 =?utf-8?B?TjNSQlRSMHo3V0dzemYyMVM3OW9GMm1reWh4eWNCcTJ1Zk1Ib05QK3VDRUU2?=
 =?utf-8?B?eUdwYkJ3dlllZWtXWE9SK3BYVXN6MU5nSFNkN3RqVitvbjhlV053QVp0NHFP?=
 =?utf-8?B?UDFQVGo4VVJjNFkvY3NzRDg5K1pjU2tJY1V3UFdBRTZHcFcvS2NzTzUrcGRp?=
 =?utf-8?B?TmgvR042ZUwvVGlnaG8yQ2NPa28vWWFuNjlFckpsM0R3V0hXSWdnRTdvbDNG?=
 =?utf-8?B?a2pqc253RWg1L1JJRWVOSUtjSmgzV0FYWmVHbmdGYVlmSktGMFZmdnV0TnFY?=
 =?utf-8?B?WWFxNkh6cmJtR1k4NE1tRmlrYlhqMkdmdng3WHZRd2JuVnhQNmxpVWZ4dlFH?=
 =?utf-8?B?WWlxUTRNQlFsTnNoMm55L25YZVQ0RmJNNUJiSTdSLytmVzF0b1pDQUIrYi8w?=
 =?utf-8?B?Z2drWEtmVGo2UzZrVDZYbmdKT3RLcWsvdGV5Y3VleE1SUmhabGRHQXhmRTBH?=
 =?utf-8?B?UHlpcS9mbnlnd1pZa0syVDRJNmZPNUN6aWlJbWE3andSQlM3QU82UjQ2aDFO?=
 =?utf-8?B?QVlTR3l2V25wQnBNWFBaeXJvcG41U1ZLWDQ5WWpaQU1IRCt2bGFaTlhIN1c5?=
 =?utf-8?B?WmtraFNQS1lHaVdEZlJPWkRNeTFkUWtGTUJQOEVXdzdnKzlZK0NQYkg0OXFO?=
 =?utf-8?B?NFI0WjAvZVRxdlVNbFdTWGxCbVFEK3VpcVpiL3dkRHl3SXRQYnRWaVQyUDE3?=
 =?utf-8?B?ckNjald5YlRHZXJuMmxMQXVFNWNiVHhmZzRNR1o5akxpZlNHYVFabVBod3kr?=
 =?utf-8?B?eXY3TkVTK3I2TlBRbFNuT1pOSE9yaEp2bmtIWWFPQWVLendZTkEydXE4L0FN?=
 =?utf-8?B?SUdiU2t1WjdtVVlEK2k2L0NOY2ZSVUFFaFkrKzR0cXd1c013Y3d4MlVHR0dF?=
 =?utf-8?B?OEQ1b3VnNHRpcnZvSkl4S000RjZEY0JwSjNpSUtVWlBIcU9peWU4UmtENE04?=
 =?utf-8?B?dWlXYk85Y0FtY3MwWkxUS3JLU1poWVpSUEpySHdSU0p3SnlteTZyUi8wTEhP?=
 =?utf-8?B?ekVGRXUvRExNc0Z0eXQyZ3pOajlEa2syYzFqYWRtZEJTbFZTWmFrdVpxOW1F?=
 =?utf-8?B?cTI3S0FQZFlQaURaVDdzKzZ2RnNNbkQxMHBuNG1jeU84WEYzTURtZXMyVUgz?=
 =?utf-8?B?cS9UKzlpZDREa1QwVlRTVlhEUFVuYnFIMjBNQVNDU00rdDRkQkVjWXRZcU5W?=
 =?utf-8?B?WURFNWNGWFZ3cFdxV0s2NzJKTHdlakhFZkxxdU9DcG92TVQrZlhHWm9QKzV4?=
 =?utf-8?Q?MZyE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce581c8-96b5-4ce5-8de5-08dd04cdb596
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 16:59:32.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPRPQjIbm5OnHKFwEyhTSLQQWCmlNnZkYJr6QO5Y970A7s8BKmPfTygM2V186imz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6255



On 11/13/24 10:23, Moger, Babu wrote:
> Adding Paolo.
> 
> On 11/12/24 04:09, Maksim Davydov wrote:
>>
>>
>> On 11/8/24 23:56, Moger, Babu wrote:
>>> Hi Maxim,
>>>
>>> Thanks for looking into this. I will fix the bits I mentioned below in
>>> upcoming Genoa/Turin model update.
>>>
>>> I have few comments below.
>>>
>>> On 11/8/2024 12:15 PM, Maksim Davydov wrote:
>>>> Hi!
>>>> I compared EPYC-Genoa CPU model with CPUID output from real EPYC Genoa
>>>> host. I found some mismatches that confused me. Could you help me to
>>>> understand them?
>>>>
>>>> On 5/4/23 23:53, Babu Moger wrote:
>>>>> Adds the support for AMD EPYC Genoa generation processors. The model
>>>>> display for the new processor will be EPYC-Genoa.
>>>>>
>>>>> Adds the following new feature bits on top of the feature bits from
>>>>> the previous generation EPYC models.
>>>>>
>>>>> avx512f         : AVX-512 Foundation instruction
>>>>> avx512dq        : AVX-512 Doubleword & Quadword Instruction
>>>>> avx512ifma      : AVX-512 Integer Fused Multiply Add instruction
>>>>> avx512cd        : AVX-512 Conflict Detection instruction
>>>>> avx512bw        : AVX-512 Byte and Word Instructions
>>>>> avx512vl        : AVX-512 Vector Length Extension Instructions
>>>>> avx512vbmi      : AVX-512 Vector Byte Manipulation Instruction
>>>>> avx512_vbmi2    : AVX-512 Additional Vector Byte Manipulation Instruction
>>>>> gfni            : AVX-512 Galois Field New Instructions
>>>>> avx512_vnni     : AVX-512 Vector Neural Network Instructions
>>>>> avx512_bitalg   : AVX-512 Bit Algorithms, add bit algorithms Instructions
>>>>> avx512_vpopcntdq: AVX-512 AVX-512 Vector Population Count Doubleword and
>>>>>                    Quadword Instructions
>>>>> avx512_bf16    : AVX-512 BFLOAT16 instructions
>>>>> la57            : 57-bit virtual address support (5-level Page Tables)
>>>>> vnmi            : Virtual NMI (VNMI) allows the hypervisor to inject
>>>>> the NMI
>>>>>                    into the guest without using Event Injection mechanism
>>>>>                    meaning not required to track the guest NMI and
>>>>> intercepting
>>>>>                    the IRET.
>>>>> auto-ibrs       : The AMD Zen4 core supports a new feature called
>>>>> Automatic IBRS.
>>>>>                    It is a "set-and-forget" feature that means that,
>>>>> unlike e.g.,
>>>>>                    s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS
>>>>> mitigation
>>>>>                    resources automatically across CPL transitions.
>>>>>
>>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>>> ---
>>>>>   target/i386/cpu.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>>   1 file changed, 122 insertions(+)
>>>>>
>>>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>>>> index d50ace84bf..71fe1e02ee 100644
>>>>> --- a/target/i386/cpu.c
>>>>> +++ b/target/i386/cpu.c
>>>>> @@ -1973,6 +1973,56 @@ static const CPUCaches epyc_milan_v2_cache_info
>>>>> = {
>>>>>       },
>>>>>   };
>>>>> +static const CPUCaches epyc_genoa_cache_info = {
>>>>> +    .l1d_cache = &(CPUCacheInfo) {
>>>>> +        .type = DATA_CACHE,
>>>>> +        .level = 1,
>>>>> +        .size = 32 * KiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 8,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 64,
>>>>> +        .lines_per_tag = 1,
>>>>> +        .self_init = 1,
>>>>> +        .no_invd_sharing = true,
>>>>> +    },
>>>>> +    .l1i_cache = &(CPUCacheInfo) {
>>>>> +        .type = INSTRUCTION_CACHE,
>>>>> +        .level = 1,
>>>>> +        .size = 32 * KiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 8,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 64,
>>>>> +        .lines_per_tag = 1,
>>>>> +        .self_init = 1,
>>>>> +        .no_invd_sharing = true,
>>>>> +    },
>>>>> +    .l2_cache = &(CPUCacheInfo) {
>>>>> +        .type = UNIFIED_CACHE,
>>>>> +        .level = 2,
>>>>> +        .size = 1 * MiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 8,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 2048,
>>>>> +        .lines_per_tag = 1,
>>>>
>>>> 1. Why L2 cache is not shown as inclusive and self-initializing?
>>>>
>>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>>> * cache inclusive. Read-only. Reset: Fixed,1.
>>>> * cache is self-initializing. Read-only. Reset: Fixed,1.
>>>
>>> Yes. That is correct. This needs to be fixed. I Will fix it.
>>>>
>>>>> +    },
>>>>> +    .l3_cache = &(CPUCacheInfo) {
>>>>> +        .type = UNIFIED_CACHE,
>>>>> +        .level = 3,
>>>>> +        .size = 32 * MiB,
>>>>> +        .line_size = 64,
>>>>> +        .associativity = 16,
>>>>> +        .partitions = 1,
>>>>> +        .sets = 32768,
>>>>> +        .lines_per_tag = 1,
>>>>> +        .self_init = true,
>>>>> +        .inclusive = true,
>>>>> +        .complex_indexing = false,
>>>>
>>>> 2. Why L3 cache is shown as inclusive? Why is it not shown in L3 that
>>>> the WBINVD/INVD instruction is not guaranteed to invalidate all lower
>>>> level caches (0 bit)?
>>>>
>>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>>> * cache inclusive. Read-only. Reset: Fixed,0.
>>>> * Write-Back Invalidate/Invalidate. Read-only. Reset: Fixed,1.
>>>>
>>>
>>> Yes. Both of this needs to be fixed. I Will fix it.
>>>
>>>>
>>>>
>>>> 3. Why the default stub is used for TLB, but not real values as for
>>>> other caches?
>>>
>>> Can you please eloberate on this?
>>>
>>
>> For L1i, L1d, L2 and L3 cache we provide the correct information about
>> characteristics. In contrast, for L1i TLB, L1d TLB, L2i TLB and L2d TLB
>> (0x80000005 and 0x80000006) we use the same value for all CPU models.
>> Sometimes it seems strange. For instance, the current default value in
>> QEMU for L2 TLB associativity for 4 KB pages is 4. But 4 is a reserved
>> value for Genoa (as PPR for Family 19h Model 11h says)
>>
>>>>
>>>>> +    },
>>>>> +};
>>>>> +
>>>>>   /* The following VMX features are not supported by KVM and are left
>>>>> out in the
>>>>>    * CPU definitions:
>>>>>    *
>>>>> @@ -4472,6 +4522,78 @@ static const X86CPUDefinition
>>>>> builtin_x86_defs[] = {
>>>>>               { /* end of list */ }
>>>>>           }
>>>>>       },
>>>>> +    {
>>>>> +        .name = "EPYC-Genoa",
>>>>> +        .level = 0xd,
>>>>> +        .vendor = CPUID_VENDOR_AMD,
>>>>> +        .family = 25,
>>>>> +        .model = 17,
>>>>> +        .stepping = 0,
>>>>> +        .features[FEAT_1_EDX] =
>>>>> +            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX |
>>>>> CPUID_CLFLUSH |
>>>>> +            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA |
>>>>> CPUID_PGE |
>>>>> +            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 |
>>>>> CPUID_MCE |
>>>>> +            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
>>>>> +            CPUID_VME | CPUID_FP87,
>>>>> +        .features[FEAT_1_ECX] =
>>>>> +            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
>>>>> +            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
>>>>> +            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
>>>>> +            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
>>>>> +            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
>>>>> +            CPUID_EXT_SSE3,
>>>>> +        .features[FEAT_8000_0001_EDX] =
>>>>> +            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
>>>>> +            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
>>>>> +            CPUID_EXT2_SYSCALL,
>>>>> +        .features[FEAT_8000_0001_ECX] =
>>>>> +            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
>>>>> +            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
>>>>> +            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
>>>>> +            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
>>>>> +        .features[FEAT_8000_0008_EBX] =
>>>>> +            CPUID_8000_0008_EBX_CLZERO |
>>>>> CPUID_8000_0008_EBX_XSAVEERPTR |
>>>>> +            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
>>>>> +            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
>>>>> +            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
>>>>> +            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
>>>>
>>>> 4. Why 0x80000008_EBX features related to speculation vulnerabilities
>>>> (BTC_NO, IBPB_RET, IbrsPreferred, INT_WBINVD) are not set?
>>>
>>> KVM does not expose these bits to the guests yet.
>>>
>>> I normally check using the ioctl KVM_GET_SUPPORTED_CPUID.
>>>
>>
>> I'm not sure, but at least the first two of these features seem to be
>> helpful to choose the appropriate mitigation. Do you think that we should
>> add them to KVM?
>>
>>>
>>>>
>>>>> +        .features[FEAT_8000_0021_EAX] =
>>>>> +            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
>>>>> +            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
>>>>> +            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
>>>>> +            CPUID_8000_0021_EAX_AUTO_IBRS,
>>>>
>>>> 5. Why some 0x80000021_EAX features are not set?
>>>> (FsGsKernelGsBaseNonSerializing, FSRC and FSRS)
>>>
>>> KVM does not expose FSRC and FSRS bits to the guests yet.
>>
>> But KVM exposes the same features (0x7 ecx=1, bits 10 and 11) for Intel
>> CPU models. Do we have to add these bits for AMD to KVM?
>>
>>>
>>> The KVM reports the bit FsGsKernelGsBaseNonSerializing. I will check if
>>> we can add this bit to the Genoa and Turin.
>>>
>>>>
>>>>> +        .features[FEAT_7_0_EBX] =
>>>>> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 |
>>>>> CPUID_7_0_EBX_AVX2 |
>>>>> +            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 |
>>>>> CPUID_7_0_EBX_ERMS |
>>>>> +            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
>>>>> +            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED |
>>>>> CPUID_7_0_EBX_ADX |
>>>>> +            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
>>>>> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
>>>>> +            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
>>>>> +            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
>>>>> +        .features[FEAT_7_0_ECX] =
>>>>> +            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP |
>>>>> CPUID_7_0_ECX_PKU |
>>>>> +            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
>>>>> +            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
>>>>> +            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
>>>>> +            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
>>>>> +            CPUID_7_0_ECX_RDPID,
>>>>> +        .features[FEAT_7_0_EDX] =
>>>>> +            CPUID_7_0_EDX_FSRM,
>>>>
>>>> 6. Why L1D_FLUSH is not set? Because only vulnerable MMIO stale data
>>>> processors have to use it, am I right?

Yes. That is correct.  We dont need to expose this bit on AMD guests.

I will not add L1D_FLUSH.

Thanks
Babu

