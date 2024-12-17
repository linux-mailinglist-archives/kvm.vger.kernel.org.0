Return-Path: <kvm+bounces-33997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B249F58AD
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 22:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D3E21895520
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 21:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A829F1F9F77;
	Tue, 17 Dec 2024 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Vz+WZuo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EC6192D69;
	Tue, 17 Dec 2024 21:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470211; cv=fail; b=DUVSpkcPJOxgIT/yRN+NTWumMCw6NdNRwUIJ56xkT6dimsyZTaQW1YCmBhY/yD8YoDnkyqvSMGuGUrTBPlRuddi2Zg32or8f1j8x8Ltm2ENOq4tWyJNtR2RuXL35471ZBU7+xY0EuDY0biIm5jo7XiiTTSSSVtZM08nojVe6ibI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470211; c=relaxed/simple;
	bh=GXnu7QrdIIcbwk83AoQUq+gIshnMuxJYCqfPsOiKA84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p6ZC0vly+nRkIEgwKlopaRy232qeEZTpQW/OIkCXRiOyfxnS9sFV8aikR/dQuWdDALgNAqDQF+FY93T/kzhB1HbtbtPXiK6+M+eUc/eVbGqszAbPrJcbuowNprKCysu+ObN3eZqMVGZYjv4dluNBUFODd4wR83lRE8K8/SfVecI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Vz+WZuo; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I2BIE17Lyv4aMsFryK7eevD25ZbMr0IuM0+IBH2+PzmYtMKloasweYLS0Qq3bNYuqAd9TjDpnsQvnEujt5YciUX1lHW8h5pu7f+7Y9PE8CUtte1d2TK7weHoyhX3AXlqtulViGq8/YPo8b8TVFkS6+0VN4qaTerVi07urFzC0JLEoDjoa8nd10bJdBZW38oz3Jy6nysx6fvA7trU9YdSBWEsYmEuuTZdTLBqd+iJoRGoBOaj/Qhsyd8hbUmatSPHUlKej3a5HVW1Zkg0drfy8shQHJnBwKBdKGILY72Z2qsZPKGv7jBuEWOcKUFdPVQAUwQIrLdeRK5wOm0V25cXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiFE3KZrGG5hcuqqum/R7gJWSPJ/X6NBH2OX+9U/BJg=;
 b=HHzd3BEqnCkjGZr5V/VmCw0hM0swD+BKh/P5NAvfkjXZaJbM3bkP6vHtFQn96xlcpD24mT0xGW32l5eJ6j6Uzqa/SCh4qX3WVkBE0RIDeTMBeKP61s4h056IxPRf3N7FSC45Q3581CbxwpdgC0nW0QB5g0xev60xYHCoC5AY+HGrSEl5vKIZUuCErion2YeIw0UuFERNPayDayBk4lURfOGU+eZgTXdjPzOXFbSdfXCj9/MrmhiZLVGRvUtWP9Hbyjqmzj3Iqi69bboobXOmxHdkNSz2ee/Rs8MrRrSy1+1DV/Rf/wS02LNf/IFYBy1FvyBg6xWfyBEfIMdp3NLD4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiFE3KZrGG5hcuqqum/R7gJWSPJ/X6NBH2OX+9U/BJg=;
 b=4Vz+WZuohRHPO/BVQZnWCv2yOszlk8MeUsDqm68ZM6VhmlOClqpoujgbynEWm6ZS/oVQYSxPknrQoxfmnmLTh7ofg6W84JJkQZKE7IYLzS7tZ8hKA7I+fm6PuhJFP8/WLajZzHU24pejldc2fM6Jztbf79owZ+NA4T9Osaqt0Bc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Tue, 17 Dec
 2024 21:16:47 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 21:16:47 +0000
Message-ID: <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com>
Date: Tue, 17 Dec 2024 15:16:44 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2421f3-3942-419e-4615-08dd1ee01d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0sxZTBySWFYWGFIbFUxOGlHSE5PSzhCOHdtYW96S2NWdXNCWDV1N285Vm9r?=
 =?utf-8?B?MVJ3bjdpRy9Cc3UvWjlXenhrSHJCUWM3dDJKcUVVNFZJbzFXb290RHI3eElr?=
 =?utf-8?B?NkJlUmlMWGdzSmZjVGJPdDNMMldRdXlCSE1Uc2JkWkR4cTVvQ0ZWRENWaTdu?=
 =?utf-8?B?UHJ0YkRpeHNSYnBKU2lPT2pqQXVNdDhxWEg0OTlyOW5ZZjJxdUdOb2Fxa3pK?=
 =?utf-8?B?QlJhQkxoNjF6aGpaQ0w0VlVWMVZqcjgya2NrNSswQ1RHRFluK1AyTE1hdGF3?=
 =?utf-8?B?eldqdzlEUlpUY2RoK0hMRllITXJLRzJnN3dmOHdaVXNPMlFwYnEzS3N6cVRY?=
 =?utf-8?B?TTIwYmczQ0ZVaURneWJ6T0MzNFdHRm4xbTJENUJQNWlIVWdWSEdZQWxYL1Ax?=
 =?utf-8?B?Rnl5elYxZWVmMVZ2d2ozQzYyWHJhelFwZ0RyanRMYWlIUzFkbVMrdnA4eVNS?=
 =?utf-8?B?empZWUxJdG9Ha3k3L0dWYncvZVE3T2owQlk4V20wTS9tT0tPOTN5WHhsczdk?=
 =?utf-8?B?S1dyWVpINnMvVEpWM3hiT1REYzBtSC84Q3ExU1BGUEh1UGtMRklPbGVaUVo0?=
 =?utf-8?B?dVRTa2IvK3JLR3BmZnBKN2FtT3huSnkvQzNISEhiSG1hczFyRkkxenQyNEZp?=
 =?utf-8?B?cEFwdmlYZEFsWVFtWFd4ZVEraDNqV2szL2tJVjhyVzRielRZWFN6OTAvUUs4?=
 =?utf-8?B?MWtDRDQ2ODFWdzcrV3ZWVXJtLy9kVlZaaUdsalRGL3BWR0NrKzQ4TjN2aVlO?=
 =?utf-8?B?cmJUQ2pXWjY0SVpBZWpXV1F3SmpwWnJRRW9HQnNjSDhLSmUxcGR6ZUFSUlNz?=
 =?utf-8?B?MktDZlZlVy8vRG84bFRRcjNWNDN2dHJmWlVXMGZlWjh6RjFocjVyY05OZUdD?=
 =?utf-8?B?SWRuVW5WelgwUkFnVDNZRGxjZ0ZLWDBzbWhSYVdJaTQrbUdrM0RGOHZJcEpv?=
 =?utf-8?B?R2JiTXBRdUc0MTJITUQ5L1RqSlIyQkYwRFNoYjdYRFBEbGpyVkxYV0haaUNw?=
 =?utf-8?B?UDRhcDdPdUhlR1lsdWFCWTJhd0pXNS9sOFNtc2UvZWwrOU50MWtISzlNUHVJ?=
 =?utf-8?B?NTY2VURRYWVjVTNqTWhuTGJnOGpBaERiZDMxSis3T1d0WFpxWVNZM2xqZ1I4?=
 =?utf-8?B?N2VRT2QvaXR2T3hLVnh6bmFKeG1CalpPQ3RiazBQNWwvcmU0Mnk1ZUM3RUR3?=
 =?utf-8?B?cnMwMTJlZlN1MFp1cEE2YTZndGNrc1ZLbXl3YzFtL1ZtaUZ6Z1BMQmM2cWNq?=
 =?utf-8?B?TGFWVytJdllsR2RUZ3RaVFVUREczZ2x1ZmRLTkVLaVkzellxc0RPRVVMWVJ2?=
 =?utf-8?B?UEJSNFZhK0s2TjZZaGc1TXUvcGxHV29vVS82TXdGL01QVEM2U294dk5lS21C?=
 =?utf-8?B?dktHWjVBZkhHSXVzOEo3YlVySFoxZjNWNDVTaDNSdktWUXpKUmdQS1RoK0JE?=
 =?utf-8?B?YUk5ZmtIWnpkMEkvVkhyRnhXM1BIeFpnTW10by94bzRPUUI2bXJJQXRTdzFB?=
 =?utf-8?B?SmhmV0R5Z2duWXlCdUlCK3JBY2x1V1JsbUl0R3dCQ21FK1JFOUJVMTAyTFR6?=
 =?utf-8?B?SG9NYUlmUFcwRXVINndEcGdETFNJKzF5dFlhaHBPRTMydUlsTnBmYUErRllG?=
 =?utf-8?B?WjA4MWV3RWJqR09wbEtHNGt2SHdXa2FYMFovM3dFV25TdmljWmNwYjc5dmtE?=
 =?utf-8?B?YURnOFFCOFI1VlpzSkRVd3lTdXNWNjVlMHlPNGprbDYzeWxUZUh6ZThMNWxp?=
 =?utf-8?B?MEZBRVhXTURlSmF0S1o2ZDlTeDkrRnpkTGsrcmY4TjI5WlYrL2hJdXZwOUNu?=
 =?utf-8?B?MU5GRkJYaW5Sd3dPNDZabTJzaVRSQkR4UU8wQ0h1cXpMWHBQNTgxaVkyTGhP?=
 =?utf-8?Q?8xnaqJlBW9zbW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDB5RzJkMVgvdUpHT04xUGZ3cnFwYTR3RGVIOGpFZ3ozdi9vcC9YUjRsa2ZI?=
 =?utf-8?B?NFoyWmhlczMwSFVPTmhqZTBpYXpkQTRDaVVhZjBzSnVRQUI5NFEyK3Q3aG9C?=
 =?utf-8?B?ak56bzh4NlJKY3F4NGhOcGRBTldqTDZEcHl1SGE0N1F5L2dqbWdHbE9KaXR0?=
 =?utf-8?B?Y2NJNVgwelhFRW5RN2kzK3lvUGRNWExDOWVaNG1mc2pmUmFjeDZrWjMxMFJH?=
 =?utf-8?B?MzhRNFcyYTZ5REhIcUp5d3I2OVBaa1FjcUpoSmpYUlRxUWRXT0VCQVN3VVpn?=
 =?utf-8?B?YkNIOFU5TS9XdkFuY0lnS25zZUkwNTVuNGpqRno0ejNMRk9SbnRWTTJkclF5?=
 =?utf-8?B?MmZ2RjF3eThVcHVJYktBNFJlNzZSSXhwOTdEL0FPdEUxUHluc2ZnSGYyRUpp?=
 =?utf-8?B?Wk9RSHgrVVNJOHNMUWJYTWw5b2lBYlR1TG5qV0loaFNpUmNUWDd2NnFQU2wx?=
 =?utf-8?B?ZVNNUGs4Q3J1bHdrbjVrTnpiZ0ZSVVk3UDZpVld5MmZESXVSNk1ZQ0Z6clRz?=
 =?utf-8?B?N0JKN0sxY3dvQUxSS0toOTlmY0Urb0Z6ajNuTjdRVU9ZWlROeG1UVmllUlFM?=
 =?utf-8?B?SW1laXEzYzJCVE5QY2l4VUtsRUg3RFZDQjRERG5YWitVc1FRdTdhRW8zZ2lr?=
 =?utf-8?B?TEd2RUZ3RDZ0NFRueVE4eEU4M2lHYVc0Qm1sZUZpUyt5azBMRnVVZkZrYUNm?=
 =?utf-8?B?MWRSQ1JIRWRIVGdvUm9FZWpDQ2tsRUprYTl6cDhqN0Z4WWx1RkhTanFpN2pa?=
 =?utf-8?B?bXhmall1bE1ySERFVTZvQ3prcllqQ3g2V3RncHZWSWF0d0l1SjZ2SkloNTE0?=
 =?utf-8?B?cXI2UERISktwUzg4T21CUFV5YW91eGRCZFNXRXFZeWVjWk9yRGova0VFQkRF?=
 =?utf-8?B?Z1UrbVB0djZnN1Y5aVNiN1RNdEw2L2hWQTdLeGhBeGdPdEVLSUFvd3ptMjY0?=
 =?utf-8?B?Z3J5Ujk2ZXJxVWJOSFpWOHRDRENFRDEyZmxWZm05ck9UQkRWdFlCUVhhb0tP?=
 =?utf-8?B?T1N1NFN6aEFQUmozZVpUU29iRFBBYUE0eU4xWmlLdWpkdW1wMGxFYkIwRnFr?=
 =?utf-8?B?M1FyNWh4SSsrLytXUkFRWCtIeWl4bzlrVHh4QXJPdHgxdTFwd0JBb3pCNmov?=
 =?utf-8?B?ME0yWExxbVpDbmEwV0hDNnVMVjhMWnd6NStMampldUZHK0pnbUphSlg5aU5y?=
 =?utf-8?B?dVZiakRrSkdDT0NCQWxRMGxjL3F3U29XeWQ4dFExM0tKckRibllzNWcrNkI4?=
 =?utf-8?B?WklUU1AzWnVBQzV4OE5BYlRoc25veU80RlA0aTQ1SjA4cUcrcHRQbEE0bFBN?=
 =?utf-8?B?dlVQUVVYSUgzWENUN3Zka3FvaXhlUDhyRTFXdWw2YmFHVU56S2huWEVqbTBl?=
 =?utf-8?B?WHAxcVlkSGNxRVBZT1lNK2VhanhtVjQvM2N1TWtZb0pvaEJhTnhySnpWRno2?=
 =?utf-8?B?Y1ozSUMyaks4K2laNzZHUi9rUnY2WVIwWkJOeDgwTWsxK2gyY2lQN3lqaHZ0?=
 =?utf-8?B?YlZyL1lpVFY4NWRIMUFDNkJHWGMzUWxqQVViYStHWDdocUFocTZBMFc3LzIr?=
 =?utf-8?B?c3Y5U1V6R21NRDBNZVJSbFNJYlUzMkJEcUtzNWJKTkhjblNBOG9tVmdUY3Fy?=
 =?utf-8?B?RVRVaUVzMCtQV0Q5cjhRMzUvUmo3WXgrVGZHTlQyK2l6UjhwaDJLaURkVGN1?=
 =?utf-8?B?YzBCTTRwS1doVVZmczFkYVhiNVc2ZTY4SlFNZDVZbDFuZGJsWFVQdVZxWktx?=
 =?utf-8?B?WUMxbnVEdjJzdVk5eDdBQUdYVXFuS0hJZ1NKeDNFYXBqYUplZm11MDZRVktn?=
 =?utf-8?B?R2wzUkRKbXBmM2tXWXFKdlZseGNoWVhnSGY1NGY3NTdRNDhNYTJGd0djRWZr?=
 =?utf-8?B?bHhxVDIzeTVMZWlZcW9lVzB6QTJWQmNpQjAvMUpuOXFBc0t1aEVVcnFTcEI2?=
 =?utf-8?B?dzVCTkFkNnAzUFlxVHQvUlQvRmVLUVdST0xGdlF3T29hUlZEQkJxL3ZwZlhi?=
 =?utf-8?B?bW5IUnBRNC9GaXVmQ2Rtb1NUZFpOQUxLNmY1VWprVXlzS1l3OVRYMTJpSmZT?=
 =?utf-8?B?RVVYU1IxcjdHUWlLaTA2YXJOcGxrNlA1aWI5VHNJUXJOdGhZUEJIdmwwUjhF?=
 =?utf-8?Q?P9dslI+7U5HDdWIs5ZTFGqIRP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2421f3-3942-419e-4615-08dd1ee01d73
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 21:16:47.4301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Caz8rl2cTJ9gOWai5xB1vod3WZrTrLR+C8MGXrTRNgLl3WOD0d2pyKXhYNQuS+fZ9NoN8GSYdXYOBdY0OnFwwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496



On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
> On Mon, Dec 16, 2024 at 3:57 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>
>> From: Ashish Kalra <ashish.kalra@amd.com>
> 
>> The on-demand SEV initialization support requires a fix in QEMU to
>> remove check for SEV initialization to be done prior to launching
>> SEV/SEV-ES VMs.
>> NOTE: With the above fix for QEMU, older QEMU versions will be broken
>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
>> older QEMU versions require SEV initialization to be done before
>> launching SEV/SEV-ES VMs.
>>
> 
> I don't think this is okay. I think you need to introduce a KVM
> capability to switch over to the new way of initializing SEV VMs and
> deprecate the old way so it doesn't need to be supported for any new
> additions to the interface.
> 

But that means KVM will need to support both mechanisms of doing SEV initialization - during KVM module load time 
and the deferred/lazy (on-demand) SEV INIT during VM launch.

Thanks,
Ashish
 


