Return-Path: <kvm+bounces-41680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08056A6BF31
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF6644642FD
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696BF22A7E3;
	Fri, 21 Mar 2025 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j9jB+01r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025D478F51;
	Fri, 21 Mar 2025 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742573378; cv=fail; b=TMzmYAuj0O7Y5wvZ0pUrW7ZFWlw0o8M61+NqW+oHe1Ww9bsbYyvBRD45sU25xbfL+6+41bn0UWLh5TwsopIFhMYxS/J3dn2SWKY6J+5+GnPUN2MqH3w4DoReL4MCeFmCZOtukcBD5ak3Rwd02tRLQHbAHqOYA6/Ofd0kH5aVWH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742573378; c=relaxed/simple;
	bh=7z3svyFZOMLfkXuyo7weWcao53AiL46/wH0PIEyQQw8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TfjBRrY2rk+PQSs3lwlAGUZkXyMa5I2AwPuVHGSfe4LUhYDNa21mwr+8W+zmN69+XDqM67U1WYFCQxugoI4yDgAoO1DX05u8rByYhAcCu/QnoGimAaG56smg/WWs4lk5WcSpPmHsWT/jgJv8cW/EI6XolR/HxP6VdOteGiOWPMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j9jB+01r; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elSp8K3PbZWubYXYWHHljzbuCCyPJ/wAEMfGpFZNS2RavuAKWEQYekyd8QHthqaE6BTcsmzqpyE87jF5e0H5wZew3eU9CiXGRZL4Mratg0tmt66qInFR3zb1rT1uzWqRsLAfAKafmAhS2iDDMrNgQuhcFAutzB8LzVUm6WwGKYwQRSc090UUieXIgVLwweF91AumuVHsgJFx1UZAZkHIfGW6U+UCIZIjFpsyqwO9VyQT4XYgJrsljRCkXY3gyelbHd6aS40I21Q0YnoYZXBfGrvaQep1/0yHE5+a9aqnO+fFWbO8FgPMkbHGbNsLXUG+666VlCk4v75OSNOGDYS4FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYo/b9zlQKdFIIJbd+tXIt6k857RN5pMAdrvK8mxD1Q=;
 b=g2Uht2EiY8THnJfPT0w3oMfqdMStGp9eDNzX+YF++AjhLxZ09Bqjy1WBOFHZRFPldUEy5M/En4d9+FCUVDjgV7Z0Wbuj3owpTV3gux4YVt2sk+nwrYilHHLXhn2S5JkkwJyKdb0CmmoPAN7dWK5Xr4tGBPRpZacWSs33gge+Kh1+Q/6HsaShT98TrUBp6kslOYnJCh/i3pp88zhnXDmdyhq75UsaXDjYrdtFTmQGYBXjlyTt0pWb7s2WIGoV5wO59so86ql2rE/Al3BM20xapBHemsqLHbzhF/uabVRmyKqDC48X1przSAX1RP8TTd0i1ompCB/hTBtwvljDIpoNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYo/b9zlQKdFIIJbd+tXIt6k857RN5pMAdrvK8mxD1Q=;
 b=j9jB+01reKs729Q9Zwy1g8tYYxhEryv0Xl9hyMsJInLTBD/kHhwM0mTOFVwuoEdDn6CZWTP12ucP3O9oriYT/IAAYmXfCAPcklN8LuZcwO22zWl1hvZ/J3ti4sLEtr8DP042RWCzVNKejgFvaGUBSJ8EXZFjzHUpge1FJ73cc3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.37; Fri, 21 Mar 2025 16:09:32 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 16:09:32 +0000
Message-ID: <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>
Date: Fri, 21 Mar 2025 21:39:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
 <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: JH0PR01CA0055.apcprd01.prod.exchangelabs.com
 (2603:1096:990:5d::6) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd1db4a-d7ce-4218-e731-08dd6892c400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eldiejVsTWZIRWwvL2VHSzdzSEpNblpSeXI1aUhtaGx0a0FHVjltN2pscjl0?=
 =?utf-8?B?c3JQSGEveXk0bG5YaUxiWlZhM0REODJRS0FwNVhLUTJJM1YyMGlWaVRsUGNt?=
 =?utf-8?B?Um5BTHh0bEhZMndVVXRtUzl2ZnIyZ2FjS2FveVlEeGVyWnd3STI4dnN3YXFx?=
 =?utf-8?B?NTZBNHlUenpxWTQxeTg0cmFCelN6Q01qd25VYU5KN0NPamNzcFByUms2U0s5?=
 =?utf-8?B?S0dIK2N2ZkVpSlNtckNPVjNyR3B4WGlncFA3TmRqdzhaNUlvV0luUWEwUE1x?=
 =?utf-8?B?Vms5d2xucnBvL0pudFVCeGtEbFVUaTd5TkZmRTFUNUdjSDBmUFlSRXQrWTNU?=
 =?utf-8?B?L3JKQm04WEd0ZEJZRVJzL0ZpMW9GQmtjMEhxakhPcVBLU2dHdUd1eWpici9Y?=
 =?utf-8?B?RHdBZ3FzM05DOVg3a0VrQVN6cTRxTndWUC9PdS9Nd0lDRzFTV1oraDN5Vm95?=
 =?utf-8?B?dW5zSFNkbDZHQlZsQTBEV3JJeHhhZEovaytjcU13SGw3YkI0Z3hoZkk4NU5y?=
 =?utf-8?B?RVpoRjlEaTd0SmYwV0FkSU1KRTJvNnBDQXdrWDBMTm1wdDJ0cXRaeDV1QU41?=
 =?utf-8?B?MDJING55MWJOdjRISXhsU0ljbDdYS0RvTnh1UVlrN2t1T2J4RkhLZlk4R0ox?=
 =?utf-8?B?ZjJQYWJZaWdOcS81Y043ZThCNTdXaVM4Zy9FOGpNek1odzVNdC9lM0x2bm93?=
 =?utf-8?B?NUVMSlJuKzVZYmZKa0R2aENWZFdQeFZGdFE5OEJhSFBIaDFBWFdhbTZJQ2dS?=
 =?utf-8?B?TjJPVmlablAzd0R2UzVHcFdmS2Q3VXJELzNlNjB6RlRFYUJ2SGR6RE5ZQ1VU?=
 =?utf-8?B?L2dTdGh4TTBLeUZHaGl1Mk1YK2RuWExtYlNPcitxdU1nMFUveFgxS3FzcmxH?=
 =?utf-8?B?Tm1NWXlTWWhLQ21JRU5zQ1ZWcnFER0ZIZFBSWE1FcGxWdmhFRytCSUFMQUp4?=
 =?utf-8?B?OEhxTjYrRnVaVGhiNklQWnYrbXlkdU1Jc0FHb0V6ajF0THN1Mml1OFQzTlli?=
 =?utf-8?B?TDN0eFZQMWFtVlZ6K056bkdLZHFzTUZOV1krT1NrTFFOYVdkRVhXUjl0T1dk?=
 =?utf-8?B?dkxYdVpmQXlzVmVhZnVvRExlYjNjMUk3N2dNM1hRMDJ2dS8wRmFiMFB5Ui8v?=
 =?utf-8?B?aDFNRHdJOWc4TEVoQ0NPRlJDV3dvZkswaVpMaHhMQ2JUR3lQYnVlaXlxbjVp?=
 =?utf-8?B?d0lQYzFUaGZWYmJtV2J6YmMvZ3BKSDU4WTd2VVlXNUd3RDZKMSt5TDBUb3lz?=
 =?utf-8?B?eGFDRmFISWhjUzg4MXRqVmoxZDR0WVpoTlpJM1BvL0UwNC9iNnNOYnlLOUxM?=
 =?utf-8?B?WlltdStYT2VqZklzWU9SUVpiaG1UbURtaXd0eEhnNU5RR1pqV0d5VVRneE9y?=
 =?utf-8?B?SitzSDBCUVlHNmljOXpiemxqUXhVTCtEb0FBeU9TWnJkbm0zeGFnbTlVRUJH?=
 =?utf-8?B?Qytock12SnJLQlFTckhYR1dmUE1MUFZXVXdBTDRzZ21KT2ZJamZEWG5zTlFj?=
 =?utf-8?B?K2NSMjZ6amdsMHIxYU1QbitiNVQ2K2kzOWk3WlA0b0dLN1NFYUdJWlVtakRQ?=
 =?utf-8?B?d3BSdjB0MXQxaGZDdXBhWlZRa3BBREZZSG1QRTlJM2IzRklZN2ZncmwxaEVp?=
 =?utf-8?B?WWwrc04vczhuMHNHeGwrMHliVW5Pc2g3OERFQXZLNGQ2YkRrZW5CczNJaDFx?=
 =?utf-8?B?dkg4YlRBYVNGU0xsMzhUTmhMbUExQ1VlRW1ZRU9YRUY5bjJuMW0zZGlFYUZC?=
 =?utf-8?B?VkJyallGaE9xYzNqRVV3QkhXS0p3K1FVTlh5cWJsVFhXY3VhNjFudUFLL203?=
 =?utf-8?B?cDdCdkMxTHdSVGdWeUIrTittTXpCcFk5cGllLzNHWU1vbmhxR3hXWjlsWnJE?=
 =?utf-8?Q?YCXEZy2AND2ru?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFkzdWpUMHcrbVhmb21KTFZlc0hiMFgrK2RCSnE3UzRRdkowRnJ6Q25rZnNu?=
 =?utf-8?B?YXR1bFlUbThyZ0ZCRlBXUldlbmlRSDJHQW1BdTNLVTVhMTJzRklRVFEwZWFh?=
 =?utf-8?B?bHVyK0FkWGlVYUw1RS9CUkZ6bXNLaXdOckpUVnFUd25BQi92QUNjR2FnclIx?=
 =?utf-8?B?YkZsVG9SeGgwOUIwR1RNZURQeklRaXREKytuUzNqbTJhRXpmTjAwdFJkY1A2?=
 =?utf-8?B?ejZZVmtoOGMwTGxmbzNWOHFyckNQTjVaV0tnOUpyQmJydEV3L0tLbkZsWjVm?=
 =?utf-8?B?dWlWV1pDUXp6cTdJOGJkazZXdm9lWHpuY1NpWE4xaGhSS2RxaXRNZHlqS096?=
 =?utf-8?B?VmxBZXIxbTRCeGl6Q09ITytjU2s5U2t4cTVLUzZ6cC9pUzVGN1o5MDBPekZm?=
 =?utf-8?B?b0lmSHY2MzdyUUg2ZlVHRDV2anQ3N3Vwc2FuYTY0dHE2SkdLYmdsM0ZXbEV3?=
 =?utf-8?B?am43RUQ3bFdnVDltYUlSTTJzNklhQkNVeDUyNVZJL2xrUmp0V2dIK1hUQnV2?=
 =?utf-8?B?QUJ4TC9vTmRWUnljRXBnR2JqY2dGL2pNcGtrK0JkckpiR2R3NzlTZ3kyQnB4?=
 =?utf-8?B?M2tyeXY1YlBzTGhHRS9HeXhQNk9LZFRnVklaa1lqUnBQdit2b29aMnNRV3FP?=
 =?utf-8?B?RmRHMTNQVk5DY3hqMjRKT2NDalppYzBmbkFzV0c4M3k0cUpreUxIVGp5OUQx?=
 =?utf-8?B?YTVnNVZUTjR2ZVJxc21HNW43Qm83b3ZpNUdvMldpbm9UNWNzZFNMUlBqTlNQ?=
 =?utf-8?B?MHBLT1BkTU5DbzFCd2ZOQmN0QUh1WE5uakFqQ2tBNTVuY28vYXZnRzdKcHpl?=
 =?utf-8?B?YkhuUWlocnFSL2tGTVJyOGxHNVQvNUdSclNiL2l4RDM1VUZ4UGZTa3pNR1lv?=
 =?utf-8?B?NVc4S1k4S1dqb1hBanJtOXhVbWFrZVdLQnp2c2V5WjhsSWJoODkxejNPY2d6?=
 =?utf-8?B?VFRyc20zMG84VTJidEFHYVl1NTFSMzJobzZtRGFHTmh6SHZ0Um1GWWJGTWdQ?=
 =?utf-8?B?bnY5SmR6R3JNY2dKV2sxVnh5bGhwNWZmNk15bWtaNFNua2tLbDJEQW4xbXVn?=
 =?utf-8?B?eW5FVGIwd0dJdFAxUWRIR2tCS2VpSVpVK3BVRTVlam1aN1lFVzdNb3Vzc2F1?=
 =?utf-8?B?Q1RGVWhnYVlnVnh1Zm90Tm92REVLNWE2Y1BUT1pRZ1JpWWozb1NRM0tWNFZp?=
 =?utf-8?B?NVJGYm1JZVpZR2hqcXVEU2xVMFZlakNnUFdHT1JKMkpaTDUwQXBaRGFkcnNv?=
 =?utf-8?B?b05wZWh3TXpxT2gvaWxyN2tKUmdJOVM3V1R4Q0FoWGRBUEo1SzlDd2FBNDNT?=
 =?utf-8?B?bmR5NjJORFlMS0Rxb3JWYXczK3pUNGx2Nk1CampsUk1UYkxMVkxNMUJhbjg4?=
 =?utf-8?B?RitNUE16a2U0TGYvcGRUdDFiLzMwTitlTElvMGRKUERkMEJPOVloY2MvSGJH?=
 =?utf-8?B?Z1BkaEdwbGNyWEc2VlJLbTA0blp6Z3B6Q0VMQ3czVGZ3L1VXT1dkN3RvTStR?=
 =?utf-8?B?UXRkU2Z0MU5tUnV6K3Jxdmc1dXVYcDV6TW9tK3hwQWNrT2JYUzBWUGRVRS93?=
 =?utf-8?B?UWRwTm8rcCt2RkNKem1ydDM3bHQ2MWt1RHc5SkxoSlFLc2J4ZGE3c0hlQklP?=
 =?utf-8?B?YjJVMUJ6SXVjN1d0YnhCUDNXck1pVVVYZ1BNVkhRbTF6eG1hVzNCdkIzMmI5?=
 =?utf-8?B?ZnE4eFd0OWNpOFFNTUg2ZkVrMmJ2ZzZZSGQ2bzloK2JSbWNjVVZpcHpKSEEx?=
 =?utf-8?B?Nko4cmRBR2NDcThUZ0ZoNDZVL0p2cGs3STRGelY5bXFlcE56TVlFYmNteGh0?=
 =?utf-8?B?VnptdUY0STM0UDNzSnNETmVjTlJUcGJaV25ycTBta0E3WTVESTkydUF5eVQw?=
 =?utf-8?B?Mk5lVi9qRXVzZWpuUDlpcU5RWDdITzZwUlJsSnhka3I4bFo1ZmhuMVErdjRN?=
 =?utf-8?B?NzdLT2FCd3IzdzdlWGZQRGZTcTRZaTlES1Y3Yjl0ZEI3WGN5K2dkK2JUckRM?=
 =?utf-8?B?c0toV2x6Z1F0N0RqVFl2ZVdhb2dHUmtyR0JlMHJ2K20zZlY4THRnUktQYjVp?=
 =?utf-8?B?MGUrUVFwUHBRUU9XTERTeWczYnhVV3RMS3ZIUjBBYnN1NXppYUZZdjRkdk56?=
 =?utf-8?Q?vg0nwVQUQcxMfsg69aDZ0DHoa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd1db4a-d7ce-4218-e731-08dd6892c400
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 16:09:32.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtEJOvUzPjOfoGOUl6DvNFcZT01M3iNqowYJCOB18ZOoF4uSY/dl0qusQCjQqnVe3MsiybeBt/es2emTo2x3fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088



On 3/21/2025 7:25 PM, Borislav Petkov wrote:
> On Fri, Mar 21, 2025 at 09:14:15AM +0530, Neeraj Upadhyay wrote:
>> Do you think we should handle this case differently and not force select
>> AMD_SECURE_AVIC config when AMD_MEM_ENCRYPT config is enabled?
> 
> Yeah, you'd have to do some simple CONFIG_AMD_SECURE_AVIC ifdeffery and add
> (or not) the flag to SNP_FEATURES_PRESENT, depending...
> 

Ok, something like below?


+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_SECURE_AVIC    MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_SECURE_AVIC    0
+#endif
+

 #define SNP_FEATURES_PRESENT   (MSR_AMD64_SNP_DEBUG_SWAP |     \
                                 MSR_AMD64_SNP_SECURE_TSC |     \
-                                MSR_AMD64_SNP_SECURE_AVIC)
+                                SNP_SECURE_AVIC)


- Neeraj

