Return-Path: <kvm+bounces-28974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E139A042E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 10:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D903281F88
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 08:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9991D1E71;
	Wed, 16 Oct 2024 08:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zYMgsz+a"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3E61C07E3;
	Wed, 16 Oct 2024 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729067191; cv=fail; b=oW80KliTe1Pp6VYXvsj8H+5NrVVTZwhqSC2a7CF4HZor1cxnFzVgmfHxVqaFtZ2wteodJg3efv/QF3cfDvIC22esD6vMza6HMxFLrfEAuin2JzaEZAQqCMa+M53Z9NYG3ogkvH+T1D2r3C6Tp919BmMoEWtsZihMaIMtyxGowX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729067191; c=relaxed/simple;
	bh=O5C6bpvbOtRPJGVbxLx/s8/RUMtt/KEux7IQaNljhJA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tFnCkVeMK01s/be9Aiv6lSM1ETkf5hqbNsvYo2HVian9MZ7QygnEhjO8GMwNO3+CaFUyUba5KIC+23eLZ6+/LNxY2OJB4EiSGBNsUyjlXBh1O6kfXafdC/+6d7AnGOOjrvfYgl7Tvc0hUOIc7cznYxhZqyThOK5IXylTodanENc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zYMgsz+a; arc=fail smtp.client-ip=40.107.92.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wB6ZQKNwZ9BZvoiVEOLMIadx4DxHRBFq2j57MB2rOuewFUOIXZibGGHNT045FW+KkUNSfjdPuTeCspvdJYJRZt+7FpOtI3IgJLa9RpGLylwrKScLYYAWjpR2sgo8Sb5Cfa7ADGMUFhZFpontnnEySnjsq5vzDnIkcsG0LhLeIZJp7rCfn1KlJDxD3YCBpMlT7NcF0NgdIojQnFqu46jRYtkQ1hhnOm8ZfP7hmhGoujW7QzRUPw/jneqOvZrDqjieQE7mwBbN9fuJsy9uxYX51MU/6s2NwxrzNONodjGh2kWgzbKouYSGTVvSWGLtIUXcUTWoBgfFNdPVhdjk+b+P/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0d3WH+AeNsJ2Ia/LnYDaurnqcS3GdE3KGmi09iu0iEo=;
 b=RPrbh+Rib8KyPQv+yCeI77iDqJLnW+JxybFhOvGJ6uwgpgD/1WvrLFmUI/v4I3p86rTdoRfioWAYYcXI5486Yh/xdthOFIQrNkXbyulwc1GyEUQIat3RK8VA/4sUz+n6bVqZi/AHLWGD4G4e8cjkKvR4+zp+H42NpPIEriWrvBsAea3FYUwh9A7Jyat9qyq7VZPm9cPQuVY3ltNmMLI75HkJKI+JxU5RD5wOrlwW9pDv3mztpZX6AgiZwe/RRnZfrM778yL1+0UZGkJVorZX4qhD7WdMmPur17oFI2hVy51BqkZcULbTmQK31/S1zMYB0BJX3FpIjqtwKYwesGi1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d3WH+AeNsJ2Ia/LnYDaurnqcS3GdE3KGmi09iu0iEo=;
 b=zYMgsz+aWrLe2oe32bwxbWRE757KkX0QBnxHZ4Yti+kGcXkABVC6Ew0I84eLAos3qPIs471MrDUj4ikqvgSENmRMIuFAKPRDMo9kJ/xzW+I6Eg8odFC1t+RPziYIlt62yaJMpx58wZchHS2KmSpE64prxFEhkMYiPiOqz5dfvhw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB5926.namprd12.prod.outlook.com (2603:10b6:510:1d9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.26; Wed, 16 Oct 2024 08:26:25 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 08:26:25 +0000
Message-ID: <6e9dc202-e7ec-8dd9-62cc-66b97126618f@amd.com>
Date: Wed, 16 Oct 2024 13:56:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v12 16/19] x86/kvmclock: Use clock source callback to
 update kvm sched clock
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>, jgross@suse.com,
 boris.ostrovsky@oracle.com
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 gautham.shenoy@amd.com, kprateek.nayak@amd.com, neeraj.upadhyay@kernel.org
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-17-nikunj@amd.com> <ZwaoPJYN-FuSWRxc@google.com>
 <86d7579b-af67-4766-d3ae-851606d0b517@amd.com>
In-Reply-To: <86d7579b-af67-4766-d3ae-851606d0b517@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0016.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: c309a571-66bc-426a-e40a-08dcedbc3970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1RmaHp1U1VNK2swSDl6VG9Bd2JvaEgyWWhZeVZGa0VnNlVBSlVteW5GL3lH?=
 =?utf-8?B?MFJLU054S240NXhOY3JkYjhnV1BTQVlEbUNpWUF5V1Y1ajMrMnFrTWxNNW9m?=
 =?utf-8?B?Y21NeUMvTnVRbjBnTFdKc21RL1dwMitHa0tqWjdDS0VIcXY1ZTVSNmxxYVBK?=
 =?utf-8?B?aEhMclppTlRVMEtkV0FnNVFKam9sbllxcno1M2J4aGRId0RpQTFEZkhrdVNU?=
 =?utf-8?B?NHpqVlZjWTFFRGdybTFpa0c3S2FmSEtURE8yLzBSTzdGV1ZpWStUQXo5WEp2?=
 =?utf-8?B?bW9ZVGdZT3lMdFZIcTNiR1h2SFg5Yy9iKzVueVpSUXFlQ2wyVVlMbEIrRWRU?=
 =?utf-8?B?b1JEMWZOQlRIa25PakJGUHh0U0M2SHZRdVdRemdsaVI4MGc5SlR3YjBVbkRu?=
 =?utf-8?B?NXFIVE50RFYyQ00yMEVxY2Y3L3plMnJZV1ZRR2c4TVd4cExTNnZhYzloT2xn?=
 =?utf-8?B?alJHSkgyWGRJVGY0bjZqWHkxWlIxNkF0Q1Nub2lQRjl6ZlA3bllpaWo0MWVB?=
 =?utf-8?B?ZkptNVhySmtJbnU1ZzJIc2o1b1ZIem4xWXEyM1FUSEJhcktiL28zWktSZ1pD?=
 =?utf-8?B?R042Wlk2TUhMVkpkTXAzd0xDVlFDRnBhOVdFRXo0RERoM3dYaEkwRVpFaHhZ?=
 =?utf-8?B?anMzU1RHdFJuMlp0aHZlL1UzSnNmWFVCckNmaVROb2l3WXVwTDd2aEZ3eUk3?=
 =?utf-8?B?bXRFbU1WdC96Y3FBSVg2cVNES2tTU3N5TEFFYmppcThkTittZlp6LzlsdnRO?=
 =?utf-8?B?clBFMkc3czgxaC9WN0xaV1dnZFg0djM5S0NVaVM4WFMzZ3FEY3MvQjdxWjRa?=
 =?utf-8?B?Lzc4bC9oUHd3NTYvSFIvRHRnK2l0ME95R3NqMUVBWndQK1gxOUFsM09scTJm?=
 =?utf-8?B?TkNldHB2VWVzcjZsY2F2a2s3eWRVVnJaYmYzclI0aGVjUTVRVFl0cXNIczdT?=
 =?utf-8?B?NHYyTm53Sk9panNGR25oNktGeE9UVkRpdk5zUkhlb2FzaUdpakJwWHRkRUNz?=
 =?utf-8?B?SEZUdGJzSmpmNEtZNlZIRDJrR0xoZ2tmYjBiUXR2b1hlN05UYzJPQUNwUzJt?=
 =?utf-8?B?NHZvc0tzQWU4STJ3SDc0THd1QTVJV0l0bVp5OTBUREFSMXlKZmRVbkh2UllU?=
 =?utf-8?B?c21EdnBrbHI0N2VpNlA3UUJKd2swR1EvL2RDejhJbnZRYzBzTS9Ma0JvbkRa?=
 =?utf-8?B?QkxXbGdqenh4SXdlMGJKMFJGRER4ZEpyUzM3L3FwaTRQcE5CV0U2RDZRTE05?=
 =?utf-8?B?akdUQ1VWbWg0ZGJua0JlZkFsODY1TzcxdklwWnNUMlRlTFBVOUF1R0dpTFFz?=
 =?utf-8?B?aVp4ZDJEUmhUekRKUUlBYWdMUmpaaW9ubERBaFVQZllNNzkzQ1I5VitRK2FE?=
 =?utf-8?B?RXN5MnpOOEkvTXlyRTZHMFY1aTNjTW1FYjhmT1puZkdSZGdMU1pYQ1pCYVU4?=
 =?utf-8?B?SHlVK0lRODNCQnJhTnRwQk5ZYTMzcTRlNk1QWlRLa3ZnTXBBWlJ6RGpzOVZO?=
 =?utf-8?B?dGVycjhvWC82OXRSdVgrWFJHM1FscHBzZWtSQzd1UUo5V2hzWnh6SVdmekhM?=
 =?utf-8?B?bFpBZDhKKzZBNENHZmNXbmlLOVZnQlJOQUtyblA2eFdhMHBaR0tSS0ZvZ1Bs?=
 =?utf-8?B?OGlWVU9jYVc1NG5aSTdiZ0ZnQmd6SlBVbzQ0VE5BRHBEZDY1Uk9mTFpYM0pI?=
 =?utf-8?B?cGZvUHJWZ01halAzN1lPckdvV0Q3dUs0OGxZcUZ6eWNhbGRablNCSWN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHhha0xlbkY5MGxkYktYaTlMOFBSYjlmaGRtclk1VUpMRWR1VmR2UHlMS05k?=
 =?utf-8?B?TzBkQ2wvazh0REE2TmxlZ0dianAva3J5K2o5cFN3UU5saURXeXBVZWNMd3Vp?=
 =?utf-8?B?VUdLbmxZM0RPNWM5Y28zQThXWmRUMHViemQ1V0RPZzNCQjZIMCt4TVppdWZj?=
 =?utf-8?B?aGl0ZnRKdFhXaXBhYmlCcFkxd0JhaE5RVzlBcFk1VHc0MGxRZGlCbEMwa0Jm?=
 =?utf-8?B?SU5zS1pIYW10RVdUc21KK1J3c2svSVFMakNGMFdsOHo4cGRDdHBPa2xndWRx?=
 =?utf-8?B?ZTc0UFhxVVZLK1pnazdCNDRSV01yVVh2NUhueElLRmVBRUsrV1FQNERDR09n?=
 =?utf-8?B?OSt5REN3eWJLUVpwSVZlMDVnemZjeDNLbHlRdHVCVWVnRklNKzh5Ym8rUzF0?=
 =?utf-8?B?UUtSZndXd2lkS014OTNsMkNJUGMraGkzMjVZMFI4RkZSTC9kWUJFeEZsM09v?=
 =?utf-8?B?R2lha1VBUHpSRHE4dzdvQ1lJSzIxUDUweXN2TVVnbW4zL0VMOGlNMStWR0s5?=
 =?utf-8?B?V04xR2RrL0VKL2tzbXlXQ3BWcFBLVy9GODQvM1ZaQkFkZHkzUzhQbmxQcnJo?=
 =?utf-8?B?OXhya2RIOUJMb2NvSUFjSlVuWmNGTC9VdVFWYXdtYWQxMnl1aWZKUEhvN2d5?=
 =?utf-8?B?ZWxCMHJuVG5aUWQ2YmJSdWd5WGw2U0ZLaW1BM1luUlVUMmFKRTVqSjcwU0NZ?=
 =?utf-8?B?Vi9XMDFOZUJRaEFzVGd3Wmp1bmZ6S3hqR043L3IyTDEwaXhsRjJrcWlVeTBS?=
 =?utf-8?B?Y2wvM2pPNXBnUjhVWG41eGQrWEZCbmVFS1hyNHFlSUpZMnRRdy81VVBwR2Yy?=
 =?utf-8?B?SmRzY2hqMEIrSXdCV29UL2xpbkFQWVBXZUJSWFpMeEF6MFZKczZvVHRnZ25R?=
 =?utf-8?B?S05idDJBYmdPci8xV1RvaDVjMWFZVWxYZWhKc3crelJ2SkNPQU1DWVY5ZXNO?=
 =?utf-8?B?ZkZxajNTUkpVcTBDVFB5M3crYWY2aGs3SUdINVdsZmlGbThUNE16QllJN2Fv?=
 =?utf-8?B?NjJsUElBbiswTnZHNklWY2F5djZ5YUNEKzB5MDlLWkdTa2lNSzBPNi9XM2Ra?=
 =?utf-8?B?emJwNENhOGVwdUxNU3NFSGFQNGljcG9SZkJwc3NqYUFDTFZzRHpqYjVsNWVu?=
 =?utf-8?B?VWhWN05GTGVGRGl4K08zL0lTalhjdWY4Z3B4RWJNVWFDZXU0ZWo4RHJvYlNY?=
 =?utf-8?B?TktaZ29XSXZHOXQ5VlgweDRxYWZsbVlqRzB3YS84c2x2dkxBUnF1eElWd01p?=
 =?utf-8?B?OW5JMFA1MW9pYlFqdzNSYUZlVVhUaTd4NEp4MEUvWksxYXNLV3Z0TEpnSVpp?=
 =?utf-8?B?RjFwZW5GeU1VMy84TnNuRVNBZFBGdnovZDZaUCt3cEVhalM1SjNRSTEvS295?=
 =?utf-8?B?S2d3RGQ1SFg2ZWh2QjhHb3Z4NXFDYktXU3R0T29UL09lU3VEejlsVTA5bnBy?=
 =?utf-8?B?cmxnZHljOFkzZThTZDZHVmZNQi9RUmhrMmJNTnFtVDBSVWJOR1BCMmd4QUZ2?=
 =?utf-8?B?UU1qaWJrMWV2UTlObnpCOUlWTlIwKzhXK2xlc0dza1FnR1hWc2l3Vmxoc0VI?=
 =?utf-8?B?M0VlQm9KNEFEbDd1UncyRHBRWk10NGJzNlZVdDNCVFUzM3FiK3ZPS2VRZStw?=
 =?utf-8?B?cFBpQk1ubUJEM3RVNnFLcnk5Rm9lKzdpVTV1bmZmTWN6TE50VVQwVEJsL3FH?=
 =?utf-8?B?L0YveTN3S1FYR2ZKZFYxV3BZTkI2cVU5VTBRaTI2OTdnTnVVUHJ2TkxiUUly?=
 =?utf-8?B?YzlYblNTTEtaTnUxaUk3d0FYbDFETS9WQ0UrUzFac2EzUWh4bzExMzVuaWht?=
 =?utf-8?B?dFhZYUNTalo1Q3puZ2tMTVZHS1pnNlNOVndyUzd5VTdVeTk1MGFNWUdMbHNy?=
 =?utf-8?B?THE1WDhkaXQ0TkplcVBLaS9TYnY4VlV4VmxZa0pQSDBrV2xTczdyNkV1U0FC?=
 =?utf-8?B?WGYvQlBmQXJlbk83Mm5scGZvaTVWMS9GYUVwSy9RTjlRMXpjSjB2cVQ3c29h?=
 =?utf-8?B?S3FCd2IzYU15eW9VWi9idXZTcDJmWHlOZ0dyUnA0QTZ0bjZVb3gwWjhYMHdQ?=
 =?utf-8?B?aUxBTVVpaHEwNWxGWDlXK05xSzVnSjZXWUhBdDhseDVVNGlsb0ZFWDFqaC9E?=
 =?utf-8?Q?vMDaiqmlO7uUi9AcUG15lPaEa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c309a571-66bc-426a-e40a-08dcedbc3970
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 08:26:25.6358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fythvvqc4pbqbQUQWK7tD3LmxWdJcLHx20gY2WuZqWZGkq6rtQy0CpbKc+dT03a/9pFissS1DKYEu9nayRwFmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5926



On 10/10/2024 3:44 PM, Nikunj A. Dadhania wrote:
> 
> 
> On 10/9/2024 9:28 PM, Sean Christopherson wrote:
>> On Wed, Oct 09, 2024, Nikunj A Dadhania wrote:
>>> Although the kernel switches over to stable TSC clocksource instead of
>>> kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
>>> This is due to kvm_sched_clock_init() updating the pv_sched_clock()
>>> unconditionally.
>>
>> All PV clocks are affected by this, no?
> 
> There are two things that we are trying to associate with a registered PV 
> clocksource and a PV sched_clock override provided by that PV. Looking at 
> the code of various x86 PVs
> 
> a) HyperV does not override the sched clock when the TSC_INVARIANT feature is set.
>    It implements something similar to calling kvm_sched_clock_init() only when
>    tsc is not stable [1]
> 
> b) VMWare: Exports a reliable TSC to the guest. Does not register a clocksource.
>    Overrides the pv_sched_clock with its own version that is using rdtsc().
> 
> c) Xen: Overrides the pv_sched_clock. The xen registers its own clocksource. It
>    has same problem like KVM, pv_sched_clock is not switched back to native_sched_clock()
> 
> Effectively, KVM, Xen and HyperV(when TSC invariant is not available) can be handled
> in the manner similar to this patch by registering a callback to override/restore the
> pv_sched_clock when the corresponding clocksource is chosen as the default clocksource.
> 
> However, since VMWare only wants to override the pv_sched_clock without registering a
> PV clocksource, I will need to give some more thought to it as there is no callback
> available in this case.

Adding Xen and VMWare folks for comments/review:
For modern systems that provide constant, non-stop and stable TSC, guest kernel
will switch to TSC as the clocksource and sched_clock should also be
switched to native_sched_clock().

The below patch and patch here [1], does the above mentioned changes. Proposed
change will override the kvm_sched_clock_read()/vmware_sched_clock()/
xen_sched_clock() routine whenever TSC(early or regular) is selected as a
clocksource.

Special note to VMWare folks: 
Commit 80e9a4f21fd7 ("x86/vmware: Add paravirt sched clock") in 2016 had
introduced vmware_sched_clock(). In the current upstream version
native_sched_clock() uses __cyc2ns_read(), which is optimized and use 
percpu multiplier and shifts which do not change for constant tsc. Is it 
fine for the linux guest running on VMWare to use native_sched_clock() 
instead of vmware_sched_clock().

From: Nikunj A Dadhania <nikunj@amd.com>
Date: Tue, 28 Nov 2023 18:29:56 +0530
Subject: [RFC PATCH] tsc: Switch to native sched clock

Although the kernel switches over to stable TSC clocksource instead of PV
clocksource, the scheduler still keeps on using PV clocks as the sched
clock source. This is because the KVM, Xen and VMWare, switches
the paravirt sched clock handler in their init routines. The HyperV is the
only PV clock source that checks if the platform provides invariant TSC and
does not switch to PV sched clock.

When switching back to stable TSC, restore the scheduler clock to
native_sched_clock().

As the clock selection happens in the stop machine context, schedule
delayed work to update the static_call()

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 8150f2104474..48ce7afd69dc 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -272,10 +272,25 @@ bool using_native_sched_clock(void)
 {
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
+
+static void enable_native_sc_work(struct work_struct *work)
+{
+	pr_info("using native sched clock\n");
+	paravirt_set_sched_clock(native_sched_clock);
+}
+static DECLARE_DELAYED_WORK(enable_native_sc, enable_native_sc_work);
+
+static void enable_native_sched_clock(void)
+{
+	if (!using_native_sched_clock())
+		schedule_delayed_work(&enable_native_sc, 0);
+}
 #else
 u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
+
+void enable_native_sched_clock(void) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1157,6 +1172,10 @@ static void tsc_cs_tick_stable(struct clocksource *cs)
 static int tsc_cs_enable(struct clocksource *cs)
 {
 	vclocks_set_used(VDSO_CLOCKMODE_TSC);
+
+	/* Restore native_sched_clock() when switching to TSC */
+	enable_native_sched_clock();
+
 	return 0;
 }
 
-- 
2.34.1

1. https://lore.kernel.org/lkml/20241009092850.197575-16-nikunj@amd.com/

