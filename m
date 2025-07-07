Return-Path: <kvm+bounces-51675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E72CAAFB78F
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73112424EFE
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9901E3769;
	Mon,  7 Jul 2025 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V2cqb3NY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D186323;
	Mon,  7 Jul 2025 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751902663; cv=fail; b=MR2HPzyhntoew6ducBZ5VLtRboQxIVgfRkra2qfU7l/Xy4OXyPLNar1g0T789ej0LcfpX7n9JYyX58w0zkvoumTtJTqVXuKxIhyxq7XqPtkxacoe+seo9PeUxAC7MdWV+KXv8EBqzz1gyvlfe3XZi4ZLqpMfGe4Ytqqd9d4yzdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751902663; c=relaxed/simple;
	bh=UB8Dpr54pxdF7uwvTVMYRlAfftiyeac5yOTLo7gs1bM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EhNYKP8eL9472Rl1j4jc0W6hlyMJrzXWANuTqr0gZfr/XUrxMRIMq8Y0/necx1HrQIRP0jUJcihTGnH2a+cEUZvQAu4xonZmuAgIrWYRmamEk2tY/l2vovE+wEbMU7pwUfwC0hhy91Fqjg0D4UpueQGjI7qunv17D8TlaSk4BDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V2cqb3NY; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THq65gjvs7jBvvSGYlap7DezLjmq4w4v0ppHx9V1xui7JD59zF7eIiOx8dNyOn/ZfUSjE7676UX6IlqL7lv0P3/dVsral9TFxE141H0O+p/NGuUj98pr3QKtN+daOnsPw89865uo1bMWZlRNc3789eVv23+KqK5gaxGbXJ0geEBqV7Ww+IxhzJ0VSY/ySATMOTZML8962BC8vSs9Mw5Ejjjwzi4XDcZxqpz0u/YjfY+mYCNoMYTOPXhsHfjFLvVf1U45xFqc112upQGTMRSra+TXLI6mD39XIlkiLaittZcSBsqh41LuzOTjsEGnRT/xbi4PgfUxQHPWx8MUiQNNrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAdQUfAUvIR4SyVxPAdRmotDXe0Q4TlfNX5f2yjT/Js=;
 b=v/gMlxmSqIJCmNRBWX9kS3yekztC7DOn+9N+OVNtiZEY2y5CtOeg7tTqXrKmtvq/HL7BiqQU7lTFrnys88R/lvJfhwTzM8QA5hKLfB8MKA34W2Gu0+XYEyiF6Q2jE9M6qr0yj+9jISkU4OGVLV2JhE3XDvnK73WLWr5Yv7KmsH5u8B3d3zc6PijaxQtAjIO2/RyKxXOkiYnzAP5LvoS8swHOA2N6K90DxkGe8yZZ9C+kSgIDxTYkSRGW/KTdzX1rIYtY1t0M0jHGugZyyhGVGlpdVfqi5VR904oGGSo7oRBQ376omLdM93saNRMAIXd9fs8uH0KfIN4Ed3LBYjlE9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAdQUfAUvIR4SyVxPAdRmotDXe0Q4TlfNX5f2yjT/Js=;
 b=V2cqb3NYyP+rCG0qWuwKCoADCmvhTybw7IGXWnaKpOTswfS9uO7OfrswaHMBcj6pBQOf2sB4qOomov9Ssz5z2b2FHy8lBWx58BXKf8UhQRu22gwodnR/7GO/uvRtYOTFk0tPTWIv1/ZMPjO0bJB23HMjIpM302bVdQ3Q4SfnY/4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB5929.namprd12.prod.outlook.com (2603:10b6:208:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Mon, 7 Jul
 2025 15:37:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 15:37:28 +0000
Message-ID: <cd7479be-c65f-054b-7ef9-a0f6a73d67cd@amd.com>
Date: Mon, 7 Jul 2025 10:37:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 2/7] crypto: ccp - Cache SEV platform status and
 platform state
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <69f95a382a6b5a6fb568aeba39b7c937fe552ed4.1751397223.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <69f95a382a6b5a6fb568aeba39b7c937fe552ed4.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0114.namprd05.prod.outlook.com
 (2603:10b6:803:42::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 43919fce-c008-4b7d-33ac-08ddbd6c2e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3U3VWdCR0QyZWlCZkRySHZQSVBMbHRabU1iMVJYRzdZelhITGFvd095UkM5?=
 =?utf-8?B?eEREQ1QvZ3VhOGNsSHdvUWlhYWpsS05oKzVILzZLRFVobzkrWTdUUUZNUVVU?=
 =?utf-8?B?ZGxsVDQxeTlQMUw5SDVvdEdacU92VElqNkZqdEpsWUdUL3F0RnI0eC9lQk1k?=
 =?utf-8?B?VUE3UThYUWttbmQ3RWdLRmxTaGVpY1k0V29ML0pRcmE2c3NJdVlQWVhka3VD?=
 =?utf-8?B?WSs2RFdpaVFXT0JrcnJyZTlGaFNKSVJpVjR5MHFYOGFMakNoRVZhVGJzRVhK?=
 =?utf-8?B?ampzT3ArUEZUeWJnRk5KYjlEN0g2N3RxKzFrVWsxVWVxSlI3ZXZ2RzRiditF?=
 =?utf-8?B?MVA4Y0RZMUN1OFYwWUtYYkRPM2lIaWtBaG5tYnM2YXRLMVdIUmJSS2xQc0ZQ?=
 =?utf-8?B?YjdXQlJXMVpoN3NlWFhkakpBV2loZ3djRkJzVkNyZHVUV1I3RGp2WnpXUWxO?=
 =?utf-8?B?NXZoRGRhWDJrTHJIVmVBNjdhMWVXSnFNeGpQZkxRZ2VRNVJ1R25rTTdqS3ZE?=
 =?utf-8?B?VVdZdnJMa0JiUWJmaFUzSVhlMThleTB5ekZPUU1LU3duQTZPTkdEakNZR0Zm?=
 =?utf-8?B?TFFsRzA3NC9RK014ck5xUGIxYURrR0N3Nkg0LzhtdERVTnhBb2xKRTF5OGRG?=
 =?utf-8?B?S3RXTXFYWEh5SUFzM2EzTTVRWGUwaHQvVUwyVUhpbmNwa2VZWFdaQTRUMDhn?=
 =?utf-8?B?bDlMS3VJU1hFYm1QU1QxVnlhZGFWN1Y0OVd4MGticSs4eUo3U20yZmNua3Yz?=
 =?utf-8?B?YkFlOHFsR1dPZ0wvRUJVb3ZlRkQ4SzJWb1NFUVNtUXdDTUNDQi8vY283QVZ1?=
 =?utf-8?B?dUlVOWM2MUFiNGJrQVhNYzNzZjNnZUNpZXNBemFhM1crVnVvK0pFZlpvM3FM?=
 =?utf-8?B?eEcvYXloSEptRDRRZFhYcitmdEtsVVQwWU4wMVhCNCsyNmxhUFMzdmNiOEh0?=
 =?utf-8?B?ZHNFT3ZqSUJEcmpiNmd4NzJpc1A3QkR3VXJCRG8vWWVrZ0JwczJ3aXNoREJt?=
 =?utf-8?B?eDgrcXN1Qm0waFpPL0JzMzlGMHVQT3BETmo0Nld0Nyt1Vi9QTUgrREU1MlJY?=
 =?utf-8?B?b0NId3crUW11Z2RIeUxNSUUvcEFOUWNtZE1Jek5jbFNFMG9wMnZVbHllVEx4?=
 =?utf-8?B?Z2ZGUXV1UWxvcWtBSXRqeEtpSU8vTFVyZG9yTE0wRnlXREJaWTRGdHhIM1Za?=
 =?utf-8?B?aHhuR2lEaHV5aEJlKzlOZkV1S0hITDVUSlZmSG1iSFYvR2M5eEhFZkR5TGVR?=
 =?utf-8?B?bzZiMlhCdlFxR2xMZmtVVUZKS2JnUG41SFFueWFJMDlGYzB4akVFclZkSHpw?=
 =?utf-8?B?S3VHMHZnNWtoOFN0VmhjMWp3QkFIKytzVW1tOWFiMnFOWkx5NHZnSzN2M3cy?=
 =?utf-8?B?TGVpNHBYUlh3TjN0MkhiaUFyTkZnYWRSUTEzMmFrMSs0TGdSTDVEQVNXY1JK?=
 =?utf-8?B?VXoxcUtqMnZKcGx0OUk5b3RQRngvZHM5WVp0SzRSRXkzRTVXZjh0ak1zUWtK?=
 =?utf-8?B?QjRUZVh1Ky81Rm5tenNyeG1SMjZsaHYveFoyUUR4akxjYld5RFBjTmtmSXFT?=
 =?utf-8?B?U0s2WVYvZHlzV0tScHJ0QlB2Umc1YlFBMkpSZVRrVHY0UFAyaGpPM0pLYXpD?=
 =?utf-8?B?Q2RQbUFzLzcrYzAxNTY3UHNueWNxVEc2STFKU0FPOHJIQk8raDVuK2VLZEtX?=
 =?utf-8?B?WFROeU43NE05NDl4WjRmc0I5bjNmNlJVeTlIdjJoeXVyd1NjT1cvMjZIZEl5?=
 =?utf-8?B?bjZ3MVlsMDRzSFhKTDdKMlB0dkc4QXBORTVMYmJSUFRhSTRWTFY4SGk0MGNK?=
 =?utf-8?B?V0taUFVPaWlZNDBVNUR1Z1JtZUh2RnhUbDAyVHFUa0lwVW1xMGFGZTdaNmt5?=
 =?utf-8?B?NXc2enhFR01vL1FzQXYzTHg3VWFib01xWkNialA0RWRUMm9jNFFvKy9qWThQ?=
 =?utf-8?B?TW94WTdScEJqcE1hUFdta2U3K1V0YVBoOWNUR25wNjFseDhOaDlDLzNhR2wy?=
 =?utf-8?B?SzBiYWFNN0JBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnVoV3NlMVpRdjRCSzB0cW1QU3dTcGNSRElJTHlkWkpSMXEyTG9hazZWUHpo?=
 =?utf-8?B?ODdTYjdZUTRkcW1mYUVyOGtwRlpJWDhmWE5XRDNvV0l6ZDVHQ1lIL3NUUDBw?=
 =?utf-8?B?NXE1RVFmak04RVJMalZGSWI5YXM1OUVVNFNJVWxMemZpcWFQNFdrcGp1R29N?=
 =?utf-8?B?VGNnRS9YZ1Fia2lPSTI0MlNQVEhESi9xK2tlQjVRazVTd3RiVzdJTDRyWjh6?=
 =?utf-8?B?UnJFOFpMZjluRTl4aTlnbXlJcTJyblJWS1JETmh2ZnNlbi9waWhvSGU0SVlj?=
 =?utf-8?B?Wk1SMUtGamIvTmlZeDVjWjJ6cWxoTFRtNXIrWDc3VWd2aG15UmZIdFFURjNs?=
 =?utf-8?B?ay80NkNkc2hvbm5PY2svbU1LZnQvdkkxSERSRDVaVkxnVmZISFBMZWR4cS9r?=
 =?utf-8?B?KzFnK1RKb1IwR2EyLzE1WHhIOEF5ZFFPVGpXTXp3SjNYRmhKZ25PZis2Zm9i?=
 =?utf-8?B?Wlk4NStHenphNURPWnlNSzZPMmNGN2M3UFYwWEppdW5jNnNTSm5ycUJuSWU2?=
 =?utf-8?B?bU52R1NhMkxzc041aHloQWEvRTFlRmVUZGcvd2d2aTMzd0VvN2szUWoxM0ts?=
 =?utf-8?B?L0d1a29nS0dzSFZsUVRPdU51Ulk0S1EvcGRzN3NQd25ldGNQYzBxS05zdEFY?=
 =?utf-8?B?VStzRjdSZFZUeFFET2pkQ0hzVDJZRmhsOHBtMTA3RnJaZEZrS0lLclV1ajNW?=
 =?utf-8?B?UnZMN0ZtUG9tWU13ekJRaFFKdDNrVzZPeldDb1dBK1lIcHZpWCtYNmpxa0to?=
 =?utf-8?B?Q1hHL2NGcVRWeHBSY2ZtVjNsd3RUVmxWZk1PMzVHNDBBRmk4M0ZhSFc3cm02?=
 =?utf-8?B?Y1VBbFdJcC9QTmorZ1ExcHNWRWNNUzJ0bG9OSi9tcTRNUHF6SWMxbDB3Z0F4?=
 =?utf-8?B?TjRuN1dDL3VnYzNLa1ZVSm12Zll4MzhSTTBxb2k4UVg5VXBSVDc0WlV2USth?=
 =?utf-8?B?QU8xTHR0azViMkpnSWZxOUZHa05oYlZlODJjM2lXYkpNMUxJV1pKaVNmaTZx?=
 =?utf-8?B?ZThJcFFLTlhRdUVXdWoyNnBBTHJHSmZvS0RVVHZwR1gwaTU3K0JOSmVvdCtU?=
 =?utf-8?B?aXhWUnFNa01tWUFMTlExYVprRVoxU3l3R1NwSmlERFdKWkNORFBxSWVLRkl5?=
 =?utf-8?B?VThBR1V1Y3BPakd4bTJmV1Z3SS9jT2RMdTFjdGRmZittcUZvUUJxeHpCTURk?=
 =?utf-8?B?R1A5aGZ1YUFycW13d1JRakF5RjRxWkdnWUsya3Blc243ditLNTAzTnQwK2tp?=
 =?utf-8?B?RVNQUWkrcVVsZ0hBT2E0amNDUFpnZVZrQ3ZFNnRnNGd5OU1hbFZzdzY0N0VJ?=
 =?utf-8?B?ZnpycGNIdlFFeSt3OGFLN1piWjk5WmM2OUQvc0VrRS9UcVhGOG0vcWNvY0dN?=
 =?utf-8?B?UEd3czRzUmJqd1dmY1pmaFZmdUw3b0RCVVRuYzlKeXhoSy9kTk5oOXU1TUtK?=
 =?utf-8?B?R01TY3hWR3pIaEtheWZRaDhjK3VrdWlDcWQrRWxMQ0pCVVpzcW0vZHdlTGUx?=
 =?utf-8?B?WnNnbnZoSTJnYVM1MElLRTZFcUdTdjNpQk0yVERzWHRDQXJrVjFzK0hhS3FX?=
 =?utf-8?B?dnFsRC8xajR0LzNIbGkxeW41WGprcjdEVEQ3eTdJdTZicnlHK1N1Q2g1RHd3?=
 =?utf-8?B?YjJ6aFlUVk1QSVZOby8yd2YxdGRabENwS1JYVWVhMytVc0Q2ZDI0NXVJV2F5?=
 =?utf-8?B?dzRNaUJsMUJPUFdVbGVlaHZHNVh4bmZxR0x4VSs3NlJ4SzkyR3NPdTRpMlFK?=
 =?utf-8?B?eEZGMTR6ckt4ampvMHNLTittbDFyeGYwbEgzTUJ5dEUyTG5wVzNpNTZmeFJK?=
 =?utf-8?B?QmZ4dEZscDRubllYaVFUNmRXZmVoeGFoS0UzZ3V0UXJJYTA4SExzbzFWT1FX?=
 =?utf-8?B?dTY1Smo3STcvZnZFRkdpZlJTQXBqaXprZ1BzVmh0akNnbWhqUk5jUnFJZlVp?=
 =?utf-8?B?VndYZUQzbnYwaVd3bVdnL1Z0SXQwL05ZbGM3Mm5QSFlBVWE3SFZYQ0poeVM4?=
 =?utf-8?B?Q1ViTVdaMXRHV1EzME1laWFVbkpFSFBvb0lPb2s1TG9oamlhL1JjTXdZUENW?=
 =?utf-8?B?TThFbEcvMXdHNnRlVHg1MDhkekhHd0tXZUxXa2dBL1ZudWs5S3pCMEJPbFZr?=
 =?utf-8?Q?M3DmqarTdIUFYz+fJ6pehlJAg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43919fce-c008-4b7d-33ac-08ddbd6c2e2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 15:37:28.8061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLBr+xy32jPSilhbu2ge+ax74Iap2vdb0nRetzaVYg3qVsddkuujCDdocbkooI4LuAz3W0y2B5IpqXRkAZpp2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5929

On 7/1/25 15:15, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Cache the SEV platform status into sev_device structure and use this
> cached SEV platform status for api_major/minor/build.
> 
> The platform state is unique between SEV and SNP and hence needs to be
> tracked independently.
> 
> Remove the state field from sev_device structure and instead track SEV
> state from the cached SEV platform status.
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 22 ++++++++++++----------
>  drivers/crypto/ccp/sev-dev.h |  3 ++-
>  2 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 17edc6bf5622..5a2e1651d171 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1286,7 +1286,7 @@ static int __sev_platform_init_locked(int *error)
>  
>  	sev = psp_master->sev_data;
>  
> -	if (sev->state == SEV_STATE_INIT)
> +	if (sev->sev_plat_status.state == SEV_STATE_INIT)
>  		return 0;
>  
>  	__sev_platform_init_handle_tmr(sev);
> @@ -1318,7 +1318,7 @@ static int __sev_platform_init_locked(int *error)
>  		return rc;
>  	}
>  
> -	sev->state = SEV_STATE_INIT;
> +	sev->sev_plat_status.state = SEV_STATE_INIT;
>  
>  	/* Prepare for first SEV guest launch after INIT */
>  	wbinvd_on_all_cpus();
> @@ -1347,7 +1347,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  
>  	sev = psp_master->sev_data;
>  
> -	if (sev->state == SEV_STATE_INIT)
> +	if (sev->sev_plat_status.state == SEV_STATE_INIT)
>  		return 0;
>  
>  	rc = __sev_snp_init_locked(&args->error);
> @@ -1384,7 +1384,7 @@ static int __sev_platform_shutdown_locked(int *error)
>  
>  	sev = psp->sev_data;
>  
> -	if (sev->state == SEV_STATE_UNINIT)
> +	if (sev->sev_plat_status.state == SEV_STATE_UNINIT)
>  		return 0;
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
> @@ -1394,7 +1394,7 @@ static int __sev_platform_shutdown_locked(int *error)
>  		return ret;
>  	}
>  
> -	sev->state = SEV_STATE_UNINIT;
> +	sev->sev_plat_status.state = SEV_STATE_UNINIT;
>  	dev_dbg(sev->dev, "SEV firmware shutdown\n");
>  
>  	return ret;
> @@ -1502,7 +1502,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>  	if (!writable)
>  		return -EPERM;
>  
> -	if (sev->state == SEV_STATE_UNINIT) {
> +	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
>  		rc = sev_move_to_init_state(argp, &shutdown_required);
>  		if (rc)
>  			return rc;
> @@ -1551,7 +1551,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	data.len = input.length;
>  
>  cmd:
> -	if (sev->state == SEV_STATE_UNINIT) {
> +	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
>  		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
>  			goto e_free_blob;
> @@ -1606,10 +1606,12 @@ static int sev_get_api_version(void)
>  		return 1;
>  	}
>  
> +	/* Cache SEV platform status */
> +	sev->sev_plat_status = status;
> +
>  	sev->api_major = status.api_major;
>  	sev->api_minor = status.api_minor;
>  	sev->build = status.build;
> -	sev->state = status.state;
>  
>  	return 0;
>  }
> @@ -1837,7 +1839,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	data.oca_cert_len = input.oca_cert_len;
>  
>  	/* If platform is not in INIT state then transition it to INIT */
> -	if (sev->state != SEV_STATE_INIT) {
> +	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
>  		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
>  			goto e_free_oca;
> @@ -2008,7 +2010,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  
>  cmd:
>  	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->state != SEV_STATE_INIT) {
> +	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
>  		if (!writable) {
>  			ret = -EPERM;
>  			goto e_free_cert;
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a..24dd8ff8afaa 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -42,7 +42,6 @@ struct sev_device {
>  
>  	struct sev_vdata *vdata;
>  
> -	int state;
>  	unsigned int int_rcvd;
>  	wait_queue_head_t int_queue;
>  	struct sev_misc_dev *misc;
> @@ -57,6 +56,8 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +	struct sev_user_data_status sev_plat_status;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);

