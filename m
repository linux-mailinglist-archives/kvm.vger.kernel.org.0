Return-Path: <kvm+bounces-43654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B39DA936FB
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB9638A16AA
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A8C2749E7;
	Fri, 18 Apr 2025 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ynsGbnFx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA8E16D4E6;
	Fri, 18 Apr 2025 12:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744979083; cv=fail; b=CQS2vJ/xYh43fJ61O4zJHAo/H6lvc4OHcFOTEY+KuK9m6QWQZkvq8KYc3gJhOFZ9vgmo8hzbdiP8eUSBd07m5zJm788RqQbXxF/44YPZ7CMl7GRVUgG9K1Ry4zoqfxMKtb0UH5Ef/KD9TsfUUArSTT0PYEjb9Ev4/f2EoK3qg30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744979083; c=relaxed/simple;
	bh=vABfgwQ55up919HhZE69EPvtycoeTQF2FmCy7X9X1uc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b5syTFvrtv8zUlz02lSsFpNWUMPKZrrqB5FxPLuXDZYspFEuMouq71QoVWSAp3x07SgQUlRHCyE4vvb17h9jJnfzmgw7XHNO1EVATR15c/qKQbj29+oSgTk6f4zMTFsHKzfYxTMsctGVMVFQLgLy5hrdVYym0GdaXWYHK20fghg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ynsGbnFx; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwaVWl+HiQALggJbnp+H0zNtRXBkszNEtKYV7QdsZU7dU4m/Oqk+InkfWW0/lXA1QhilHbUYasQ0A6wtAeJ4WavMu7ClmeMOhJ9z/nbNTGID5yRA9Ig173d/kM6baAuXjgeUKH8tiTX5DhfSW1HcgAoz+yWZCIPxsuLYaHskTe8DzUjCydwbRQB/vxUkPkGxJQ0dktZggOgvZVyK9QbSz2ghBYSpHBc7xsuVAvYEPLPXC+yTgMeQgsd6xUY0J8SZBlHgJeM3v2EpfhXCQcBT70qY+N7SIKFy8oOqU3hW/lZw+vqg9fmQgvo5Vr0UYMjE3is13aJ0kxKNl08NV8KCeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nFhUJJxyOxUw0avO/mDWfucorif9gI3Ekrw9iKf8jw=;
 b=gyquOCVou9JFPrG+cUaau4dsbOG7tVGfFAfyqadwMQ9tcxSx9rv/9xxAeYe2iNB2hjfaCYNcC/RSoPRjVOckkOIgNIHxuaKnJgn0QSylTNxbsZepE1obD2UAypaT4a9f/3BQ4ms25mYP1Opp3ACmTCFnJwsstt/74KK71BdkTFltmaZZHFUi3woa0s/wLNNJz4TJWjurVSScgRTvacFsthGwsRgf++mmpCeU90aXSDg14NIVt2WVzOJ3KPgnOjnxSU9DReHpz1uMtpesbkqJPhjr8MSW+kaaFjUWIUhmA5sw/6b+7DNdoM0IxJykorK65cOa+VxZ0v8PrG37j1rszA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nFhUJJxyOxUw0avO/mDWfucorif9gI3Ekrw9iKf8jw=;
 b=ynsGbnFxYBO9/5FvFsP1eqVVlXK1ODKoXw8sxRlH5uM4HU494aH2zS5WwWTJ1I6F4lBTU97fJJPFFB0E8Y8OlQsld2EwjbSwYMJZTRrzDxZ5vwU89Zje3rLYJzAdl7k0GeUnaytaaDampehmTS0VEB1/jivfcWtnWUeiYz7aPm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH3PR12MB9170.namprd12.prod.outlook.com (2603:10b6:610:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 12:24:38 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 12:24:38 +0000
Message-ID: <d6161236-cba6-40ed-9e8a-010646f6974f@amd.com>
Date: Fri, 18 Apr 2025 17:54:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/67] iommu/amd: KVM: SVM: Use pi_desc_addr to derive
 ga_root_ptr
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-26-seanjc@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20250404193923.1413163-26-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::19) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH3PR12MB9170:EE_
X-MS-Office365-Filtering-Correlation-Id: f0c3c4a3-ff4b-498a-6f96-08dd7e73fc9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NllKM3ZYa1ZyMVBVdFJrQmhKQVZKOHNBVW93ZlpkS2xvSFh5ZFF6SXNCU3E3?=
 =?utf-8?B?cERpbUZDZXdDK21sVVI3T2VlWTZ5REpvZnRmcmZ5TjEzVjlxeE4yUHBhVVlT?=
 =?utf-8?B?R3BhaUNKQ3phTCtUWmpQSUFRNk5uYjNQVlVHRFFYRTFvWFQydHBDc3Y2NlJr?=
 =?utf-8?B?cEdabks1cWF0Z09qMDQ4SVh6NDFrMXVzajcxUzQvOUdoZm5qWEFiYkhDajVm?=
 =?utf-8?B?NmxIQmh1bURKUEF0WlZ2a2JJL3doU0NKOTFJYkFSTGNzMldzOU9uVHFnNitF?=
 =?utf-8?B?QVA5dDhMc0NGOExpdGtVa1lhUXdvOERTZjZsZTJhbkE1N0ZJTUxIMm5kSHZj?=
 =?utf-8?B?MG1XUGhZUUNjdEhpYURZN0lnUU42eS9sVVkrQTNqNWE1TGdqVU5iQ0UwRDZa?=
 =?utf-8?B?Zk82RlMrZ1J6OTlPNUVDRjFtVjRDek1hdTBTV3pUNkt4SnRlL0ZvYlM2VVlU?=
 =?utf-8?B?WTFlUVpvN2xhOVhpbDVrNFdBYUFGYXpPNG1nbnEreFljQWFEeThlQU9RZC84?=
 =?utf-8?B?dDJlSHlXdUlQZzUxZUptd1FacmVNL2hUeU1jSHhTTndnY2dBVy9sUkZlVTF4?=
 =?utf-8?B?VDVzWjBRMDVyNnFaa3dUUDJRcWJrZ1k5WE1HajJLRUk2RWZGaW1VSUVlR2l3?=
 =?utf-8?B?cmNjNDdSU0h6NzluaFdHRmpaQjBVd2Jrc2Y2T2VYU1BVQnU0Ky9OT1JxUW9r?=
 =?utf-8?B?aEt0UXpOU3JGdzV4MWhuUStSU1R2Y1NYSEtwNGxwYjhIUFJ4dURVK0Z0ZndP?=
 =?utf-8?B?LzBlZi8zeFhTcExYOHhwNDBCTDZoZ3BpZ0JTVHhiZ1FWcUpCWlNneC9LT2tR?=
 =?utf-8?B?Z2hSUFdjK1dUZjFiVEh6VXlsbUg3NUN3b3lnUXNmK3c5TFUwcTYvdXdNKzcx?=
 =?utf-8?B?aWdFK01lZjlEa0Q4YzJKZy9GT1FEaDB0M095b015SzFFUHg2TTJTblVranIx?=
 =?utf-8?B?ci9KZzhaTzF4QThiTGorZUtPTG9YVWx6QkpYSUJwSi9WSFpvaVYra3RqS2lr?=
 =?utf-8?B?UWZzbEhlbzQyQnZVTWRRUW1wYTA2VHp2VUJ5MHUxQnl2T3kvWitTU2I3bDlq?=
 =?utf-8?B?VmFqRnJjaWZQN1RvalVtREdWOWI1VVZTOGUrNjZDcHhyTk9aTjNRbWc1Mlla?=
 =?utf-8?B?SURZd2toM0lUczFENGNOcEt1bmtwUjlPQkZYUzZ5NlIyQnFuWWhMMjFZbllr?=
 =?utf-8?B?ejRUbFJ0eEZOeGgySGZrQVc3S3RXdUcyaE8vVE9PSk0xMmVabm56NW1nS0dP?=
 =?utf-8?B?dGF1M0hpYUFWdWw4S0VGRG9tYXZyamM3YlA5MTdXL1NRaWprK25KbjZjNnFJ?=
 =?utf-8?B?eFVpV3hvRG4wY254ajRaZnNxd3k3c2U1Q01JbUVsQVAzSGtSK2NPYWNtYllI?=
 =?utf-8?B?T3hFMFpkK2swUUJSVjZTRXc5NnZkb1lqQVVqNUVuQUxUZ28wc0VYWTRpakhB?=
 =?utf-8?B?S0VIbmwrUEFVZW9OczhicHhIRkZtTW5vQXd3Y3EvYldOZElXUHZKNVhJdFJN?=
 =?utf-8?B?K2gxVjFyUGFLSGVldE5sWkdtb1U3cCtKbXM0aUZRQnZ0UGlJcGFrdzc0dnNU?=
 =?utf-8?B?L3UzcFZMaXRTT29SblcrY3R4NGpVTWR1UE9CNVA5YVN2SU1EeExCRkFuREk5?=
 =?utf-8?B?UXoxNXBJNzl5dlZwL1kxS1kvaWs4MXJFOG9Fd1BmUXVKUzE1ckk4TFZhcy9E?=
 =?utf-8?B?Y0lkdGVXV3RRMjNITDFidFd4NVJqMVZnODRaUWpUd1p4enliY0NHMU9ISDRI?=
 =?utf-8?B?bHViRnNXVFhPN1h5Q2YxV1grRjZ3eUxhSXhFcUl0aVFlckNHUTNqRlpJZWlu?=
 =?utf-8?B?WFdEY1hVYVd1eFM3MXNHSGk4YmtyMDJaV2xkT3VyV2NLMDhaZlBEeDI3Wlpj?=
 =?utf-8?B?ZkZSYnJyU0YyMHFXMUJIVmRoblJ3a3ZlZW1peGV0WkdrOU9IUTdmamt6bVRC?=
 =?utf-8?Q?R2jAq3pM/HA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjJGRDVQSXpiM2ZVZVR2TGFiYnRoUGxkR1VqSWNNTUxUbWM5UlRTU2FaZHNT?=
 =?utf-8?B?TExlUmZOTmx2T1VVSzlkR0c2d3pzZE1zanphNmI2bXB0d0o1ZHlkcndNVXhG?=
 =?utf-8?B?SS93dktBSkV6RUlNd1lVL05vcXFMeTR4SXI3Y2ExRkFXUVhBeHFnYmFtaEhM?=
 =?utf-8?B?Wk1EY09KMVQ5eUZuZ0xzVHJIQU9YVzZCS1lCa3dTbXl3UCtGMnZ5eFE1Q0Jv?=
 =?utf-8?B?TkhEMEpDOTdZc3B4SFRwdkRYUSt6MzBnWkdidTROTDFZMzhxU1FXemZLVVF4?=
 =?utf-8?B?a1JQNS85aUlkL0FqZUI2Yy92WkJFK0VrOTNieWJ0aW1EMVVnTWFJWWhrMEt5?=
 =?utf-8?B?NFVJUHkySkxsL1d5Uy9PZEk4TU5WM3pDWjZQUDFwZTAyYmdPTmxVTTFhTEs5?=
 =?utf-8?B?YTl2Z3NCeTVIN2xON210RjMyMTlXKzJxU3ZvWWxIa1Q4aUVvTUVsMk5uaGNq?=
 =?utf-8?B?QVhUaXFkM1drdGNsUk9zeUVHWWJWMGpSdnVZZWVEdm9OcWxRQmVJemprTkdh?=
 =?utf-8?B?UEZ2eEtLcUZuQkREVk1oSWpUN1JmYWhZWFBiUDVNQnV3d1M1cVpOWStYYUc0?=
 =?utf-8?B?NEx3d1ZGbmg1MGtsZURwUTF0UGZVVkZ4WDJQMFZOWFpqTWtpOHdsVmlFbnUy?=
 =?utf-8?B?Q1dkaTVjalZLeFJGSmVranRyVzRFVVhRbytUK1RTd3ByUXRyT3RRRmtQNGxQ?=
 =?utf-8?B?eWRYUUJGRzdWeWxaZFVVdExQYkhIOU1QOTkyYVZoVTJiYU9iUU9WaXNNMTBs?=
 =?utf-8?B?Mjkra0Q0WjJ2dTZtSGZkQlZBa3I5Q0VWZnZjVVp0SldLd1luT3pmUmQ0UnZI?=
 =?utf-8?B?NTNsd05Wall2RGRxdDZDUHVabFRNRmVDTnI1dGpOcjBOdjRFZWQyVHh5bjZa?=
 =?utf-8?B?R1RMZlJnZUR6WVVrK0JPYWl4aitOQ2hhNkRPYUREL2drQWxKNWMxOFVJOG0v?=
 =?utf-8?B?eWZkQTB5UlBrK1doMWIrZy80NXhOT0dlaThCSkF4ODE4eDNXeitWMWtFRG54?=
 =?utf-8?B?Z1YrYlhLVnptLzZITmZUdDI2MGRzMC9MS2dITFFIcVEwbEdXSjhZR1Bzb21u?=
 =?utf-8?B?M0VoNHdXMzlqVDJPazNSbTJHZ0VvNUFlWFlnYkZDUm5xV3JsREFFYUlBYVVq?=
 =?utf-8?B?allHaHZQZHczWW4rUWg0Sk1CSG4rOGErb0xHQVJ4ZEFWYVZJYi94N2UrT2FZ?=
 =?utf-8?B?bHowZUNuWWNtSmFkOEc5M1JmamxIYkQzTWV2bkgrb0dXdzltajM3Vkl3ZG1a?=
 =?utf-8?B?VnA0RUFQRTZza3BGVUxlK1JsRmo1R1lXMlYrSXh4ZDN6cDIwVzQ0Yk9ERExP?=
 =?utf-8?B?Q0IveVVvK1hhcVoyTm1jdklKcElmRHN4WHpVZitpQllDQ1V2c2dnZzRwYi9o?=
 =?utf-8?B?cy81N2lnODhCYmZJRnRMa2dyS3NPNEJQdnJGRHJWQ1JhblhZNStYMHRYQkth?=
 =?utf-8?B?M0xJTHdVUXVVMWllOWc1MlNNV0cwZ3J0OU5pNGtnZm04cVRmTUMvUHlrK3FG?=
 =?utf-8?B?Zm1MQnc4dG5panJoQ1NCT2ZpZWExNjNqUFFWUm5sQWczZFUyY0xMSklnQUZN?=
 =?utf-8?B?dUpidnpzV05Rd3BVbmwzdW5seFdjS0I2VzZSdm5QVDlKb29zcHJqUHlSNk9r?=
 =?utf-8?B?S3RqTUVIeWMzc2psVGRYeER5TVVJNmh2cEZOU0RzUFZ2ZGNzcGhzbmxLeTBy?=
 =?utf-8?B?YlM4UVE3MHFtQmpjUkV2MTZ2eHhxbzhtc2pQN1BIUTh5aTFabWsyMDVYVEhK?=
 =?utf-8?B?WG9tWTI1TDlBRmhkT3NVWEEvMENYSVl6dk9zMmloSlpCc25WRUxJWUJDakV0?=
 =?utf-8?B?Rk80cml6NnZIejFyaXhFY2RGT0VlNWw1K3NjWSt2Vi9EY2tjb09SWkUzUG9Q?=
 =?utf-8?B?ZkFlYVBpVUdFZklLM1J4VEpvQ0pqUUNsTTNBdFVndCtiVUxMdzF1d21kbXBr?=
 =?utf-8?B?bFJxR2pUaDIwVlpYVkpoSUVOblFTc2wwVWU1a2pHcHJUdjJpb3VXRjhObUdF?=
 =?utf-8?B?Z08zVlVwY3N5ejF4aGpOcDlCc2o5RDJNb21GWGt0K3hnUVJPSjArR3FBV3N6?=
 =?utf-8?B?VDZXZFArV3RjaUNIRUtySmI4cjFvekpycGw4M013K3dhN2JDYy84TjFwTGU1?=
 =?utf-8?Q?fYgIYqZKvB6RHFEwlhDiT/Nlp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c3c4a3-ff4b-498a-6f96-08dd7e73fc9e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 12:24:38.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Pvz0jHW17y1C9zjXmg1P5DE7ChEZ9JMKG4AaeZxNM0PwNefDeqC8ZYChd1Xg7e5pZNOm74iyCTOoBW5xAwTvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9170

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Use vcpu_data.pi_desc_addr instead of amd_iommu_pi_data.base to get the
> GA root pointer.  KVM is the only source of amd_iommu_pi_data.base, and
> KVM's one and only path for writing amd_iommu_pi_data.base computes the
> exact same value for vcpu_data.pi_desc_addr and amd_iommu_pi_data.base,
> and fills amd_iommu_pi_data.base if and only if vcpu_data.pi_desc_addr is
> valid, i.e. amd_iommu_pi_data.base is fully redundant.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


> ---
>  arch/x86/kvm/svm/avic.c   | 7 +++++--
>  drivers/iommu/amd/iommu.c | 2 +-
>  include/linux/amd-iommu.h | 1 -
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 60e6e82fe41f..9024b9fbca53 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -902,8 +902,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>  
>  			enable_remapped_mode = false;
>  
> -			/* Try to enable guest_mode in IRTE */
> -			pi.base = avic_get_backing_page_address(svm);
> +			/*
> +			 * Try to enable guest_mode in IRTE.  Note, the address
> +			 * of the vCPU's AVIC backing page is passed to the
> +			 * IOMMU via vcpu_info->pi_desc_addr.
> +			 */
>  			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
>  						     svm->vcpu.vcpu_id);
>  			pi.is_guest_mode = true;
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 4f69a37cf143..635774642b89 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3860,7 +3860,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>  
>  	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
>  	if (pi_data->is_guest_mode) {
> -		ir_data->ga_root_ptr = (pi_data->base >> 12);
> +		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
>  		ir_data->ga_vector = vcpu_pi_info->vector;
>  		ir_data->ga_tag = pi_data->ga_tag;
>  		ret = amd_iommu_activate_guest_mode(ir_data);
> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
> index 062fbd4c9b77..4f433ef39188 100644
> --- a/include/linux/amd-iommu.h
> +++ b/include/linux/amd-iommu.h
> @@ -20,7 +20,6 @@ struct amd_iommu;
>  struct amd_iommu_pi_data {
>  	u32 ga_tag;
>  	u32 prev_ga_tag;
> -	u64 base;
>  	bool is_guest_mode;
>  	struct vcpu_data *vcpu_data;
>  	void *ir_data;


