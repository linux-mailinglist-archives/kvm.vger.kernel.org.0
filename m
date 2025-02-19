Return-Path: <kvm+bounces-38550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B046EA3B02A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 04:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D45916E240
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBF01925BF;
	Wed, 19 Feb 2025 03:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hSpuVoah"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2B58C0B
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 03:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739937004; cv=fail; b=RdqVQqBSzYu1f6XJNhwFN7MwftGhMK7BHSRPxxyMLluLgsoAA0Y/eHKRhiCPAJyxWoPN53SnmOOjkwbSvjsO4eNo0v8/NroWqANIa2Bq9ynzqqEzYYhaGXmKyKIINhdVDp9ZyN/8Dqf8Ga+WmSdDBpGLxFIUZ5pb3AhQ/exi6Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739937004; c=relaxed/simple;
	bh=24AKVfxVcw5lAaPu021OPdtv51/7bBuj1jqVuQUEGqs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DElARPo9voa/kHJvSscDJ4F0jcTTco97SzzLrLquAP0Oui8zHFNDrSyFd6jWp6wpLPjfMo2uYC+P5y8xYPX0XBsV+GRy+nCM0/cT8liAHthTtYxX3J9YYkb9EvU3ELdT/3NkapRH9IYfcIm/M5G9kdWAQF2QwlaydfNysjOVlZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hSpuVoah; arc=fail smtp.client-ip=40.107.212.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeFI6DE4BWOppzAkVDFmkTBRYaF7Eys8A84DjGOeUPWYJ8g2zzqWVFTSnAqMuE/WH2//7nsv4s8rtmn7Vw7ZCkYGsbYoLSfwk2mnahGzjwBLsnbSz73HxR85YjQ0buXrQigwJMicgK8s6WksjPcnDYYo49CHfKpofTC9IbxxZ5B+HDN1A3SLkHRDO0lQA69ZDCMnsNQ9D5y6Ku4tM8pVKC0jMldLXH+jqJlJzqPqfZ8gRhUxahiuQ7VcLMTT38Xf9J9Vl3NcI5nXXsd1euZATPBk6dC6AkH0c0Y0i5yiW6j1G4lHlHvpSUaMZTyXxIxWvxOqfPLqoyeGdWzKn9qPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGo8cTIr6wruZKmDBPZ5I3Fh6se4whg+E1TDW/fbRt8=;
 b=Hx7tQmnEAAgWXloDF+lYRHJMnB05nJSK8cu1coJ28hX68piaTiqd1OQMkJUgYl/OW6gLDA+Av6jwOUsyAq61cU5F62EbK/PHlM5O0QBbd6yQsya9/GiAehJ5GCM9/tuAKtno6Qb1SWuvFHxWSpPkMlsITpdpmogpjmuZFPzlPtCa5cy08ROwyYq/4fqUvJ6fYgcaf8D25dKucOff0RRfIjmxAKx8bWNWDFv0Eimy1KpH9t3G//rSOtFUrh/HK5/fMnAvka+ktOJKm1r6O1jQx8rul204zO4fHObAYbMo1z/jMK8DbtgO/JItTkkMjEWIC6BWMaIh10hM5NI/5nubKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGo8cTIr6wruZKmDBPZ5I3Fh6se4whg+E1TDW/fbRt8=;
 b=hSpuVoahJ0rtnNCnWfvpnh5Sdil0ZTwuVAiTzs/Nq2v89KmggJZ/b2M98pnYYE6NuBtTGacSpUfcq7uwe+NZTTZdOfWSA+2xYeD0hefXVsoq642b2KiArKD+Sqz99sAhFnQ2kSsBfrg7RD9zb4WnXIFpOOPRfZNL9PZ+DGlO64k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 03:49:59 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Wed, 19 Feb 2025
 03:49:58 +0000
Message-ID: <23e2553b-0390-4215-a19d-0422b55efa38@amd.com>
Date: Wed, 19 Feb 2025 14:49:50 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 3/6] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-4-chenyi.qiang@intel.com>
 <60c9ddb7-7f3e-4066-a165-c583af2411ea@amd.com>
 <c5682028-b84c-4b4c-8c4d-f3b43d412e83@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <c5682028-b84c-4b4c-8c4d-f3b43d412e83@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0291.ausprd01.prod.outlook.com
 (2603:10c6:220:1f0::18) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e1d8a49-9b1c-43c3-e581-08dd50987b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTdSZEkvQnpsd3drWXpUSjkvLzlxcnpNb014RWgyTUtya2xnaE1COXN6RVlo?=
 =?utf-8?B?b0RWWDljSUpORmkvS0ZkTi84QVRTRXdPaFRhY1JrWlVFTllYQ2U4VXRaM3dX?=
 =?utf-8?B?THFuSy9YZjh4OU01V2xKN3BiUWdwWU9RN3JlQUNCZ24rRWpub1dHOHkvb0Zu?=
 =?utf-8?B?K1J1TklmTEF2cVpHcCt0S28rYWcyT2ZDaVphc3hWTkQ1UG5YT0ZsdG50WWVy?=
 =?utf-8?B?SCtmYWhWL1NON0pXZU5aRkUvSGxFaVVNalBPRGNOUUVrajR6Znd5QWN3Zy8z?=
 =?utf-8?B?elpFZUswZHBCMmlRZXBnYWc0OXAzQkJDSUVBVUNFNXQrTjR5MjdhQlNQVXl6?=
 =?utf-8?B?NE14TUEzSHJFZUFiQjAxQitYQ2cxRDkxZ1BCbDZYK2F4TjNJM2Y4REh1Q2pr?=
 =?utf-8?B?TXJab1dwaFdGL2xDc2ZyWmZTYmE5YkZ1aVpXZitteUFOWVVocEkyWjNoeElv?=
 =?utf-8?B?bGZtNCtDektCVkJwc3ZKNWNyUW5PaUdBbjB5S2VMRnhaZkk3aWFhTHpXMFA2?=
 =?utf-8?B?dE5XQ1pIOW5wYVJRampQd3BUNk9OZytMbG9iQStBMEFtbjB6TDZqT0lCSEl1?=
 =?utf-8?B?a3lxMjYwS2ZTZExqYmJHUXo1Smx5dStWeFFCSUpKWDFVMHFOSmVsTzhoOU5U?=
 =?utf-8?B?TTU5VDhMMWZ2RUc4alI4dlRoZ0NjdWVXYlRoMHMvYTdXN0J4U3AzQU10T2ty?=
 =?utf-8?B?TEYyMWt4ZGNLS1dSdmF1OVYzUDc2TXVBdmsrKytJTTJUZVQ3Njljcm5teERR?=
 =?utf-8?B?ay8rUEhmRndUMlFOVER3dWR6VENXK3VpR1Q2OVBqSWsweWg3Vm8yUVl2emtt?=
 =?utf-8?B?M3JqQmxGTFlUU01hU1ZjZ0JrTm8yaTRJY3dhUmZTYURyT0cxOTkrTzMxeWlY?=
 =?utf-8?B?SmZDd2lTbUJGaDdybmoyVnNLelJmWkZmV0FkK0F0ZTdkR2hhaE9MMTdYYjgr?=
 =?utf-8?B?ZjRzTUdyaVJtRGR0bVY5YlFpcjgzWFAzUHR3TkVOYTVCdnpQTUg5c2NkWU9I?=
 =?utf-8?B?NWoxUTVETERpZVdVY3BGbFp5Z3IxMi84YmgyRTlwSTVpeWQzRnhkZm1EbDRu?=
 =?utf-8?B?ckRPRm5uUmdxaEhWazlVdXlCbjV5NUNFbllaZjN3M0pCVzVVLzlSNHh5RG9x?=
 =?utf-8?B?R0xiaEVIb210YSs0SnZtd2RKWDUrMEdQOFFwRTVFWjVpMWQ3QnNwQkR5MVk5?=
 =?utf-8?B?V1cyVjN0YzM5YjVjemFDd0dtQVFib3BNd1ZIUGh3RmRkUDJkaFRZbVNNOVRJ?=
 =?utf-8?B?OThBRUhlM0ErWmFJNitKeUY0aWMxblkySTRkVGZJcXkzYXp1SEVwU0trNWxQ?=
 =?utf-8?B?Nkg0dFBHUndwVFlaK3FnMWhuTHlSY3p4dWxZTy9Qckg3UXBzQTZHK1VvMW9i?=
 =?utf-8?B?R1BjUGRnUVd2VW8rRG03T09iUlZsWmJqdGMvNEUvYm1kSTl0TmthWWxEa0xG?=
 =?utf-8?B?YmZWWExwNTNISlgwaWFodGZVNzZLNTI3QisvelZJTGdtYVhhR2Y0TDN3ZWxJ?=
 =?utf-8?B?QVgyeHdteGs3NnNMRGpLSUZpRVo5d3JjQzNkaXhBVHJuYm9RK05rejdWSDFU?=
 =?utf-8?B?QThuR0c1NGw0QlpxdFlKNENKSG94WmRVcGlpTGhNOHA2cklMZDVpZ21GVThr?=
 =?utf-8?B?YmszQTJJQ1ZFcmZabTArcGlPWHRZcllYVHpiNnhibnZMU1hJR0xieDc5VFBx?=
 =?utf-8?B?MnJBRXlKUm5rZWtYZE9EZG9mNnRNeTJRcjlsM1hZekRTQlRQZnowZnFQMVVq?=
 =?utf-8?B?MTNOWFlmTVgxb1FLeGtMU2hYUmYraTNaSFBRampRbVh0dnZ4WXhUUmo5dnV0?=
 =?utf-8?B?d0VMTGpFdVZPRlNzdFloekFCN1ZBUzJBK3dqM2ZGeUUwR3ltUk1IbkwyWUZK?=
 =?utf-8?Q?EzEzyUOOmJgHv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFBoNXh5Tit6dEtZQ3JZMVl0UHdiWXI3QjhweDVCSC9KUVB2cVNWY0JzMVVJ?=
 =?utf-8?B?dWVEc2kxTElZZ1F4SU01Sml2cDFjREhzRGFOTWxHQVh5Si9xajBjTUVhUEh2?=
 =?utf-8?B?UmtTU3RGa0FCdDI5UjhkZHRsa0JrUWpoc2VoZ2xtYWZtdmgzRDBEeFBleGZ2?=
 =?utf-8?B?ekdYa0VodzIwWHBYRTFwUDl5TUVtczdDNXhTVG1FYUZuZ0VBYzRYaFhWT2gr?=
 =?utf-8?B?eFpkZklPbkgwZU1wWDJnbmNuMHlwZU4xdU9jaGZDRTg2OTRFSWthZU1HSGlK?=
 =?utf-8?B?cytCbmg2dU03dnZ0NU9TdCtJZGloYU42Sk9qQ2kxNGQycFJJdDlWQ0NtT1pt?=
 =?utf-8?B?TXJpUWUvcFMrVVZGdGJpTEV5VVFOb1JSa05XVDVvODl2clhuRnF5QnB4UENx?=
 =?utf-8?B?R2E2TmEyNVAwOWRLaVowMkhNYXl6OFZmcWY1NituZTJydzg0MWJ2UzhzUzBX?=
 =?utf-8?B?dE5CQitVekJCTW9LTkpaamVoVW82M21BaVliY29yYXQzVU9QR0VVcFIzd0Q4?=
 =?utf-8?B?UkdUNzZCNDMzMDg4K09wWGVWS0V1TG5Hc2U4aVJZNkJQOEYrV3JmZ2VVWm5n?=
 =?utf-8?B?OGt1cDFYVnE4aVEzTGtSbVNtZElwYkJQQ2tpSHRkYklYZHhDc05ENHhUd0F5?=
 =?utf-8?B?Sm1aMHplR1UrQnZDdEZ6SEFWYkxTczlPakVuQnVucTBpSUNLQzRZWjRZYUpL?=
 =?utf-8?B?MFVqM0Urc2R6bUVYSUxid3BUeDhHRSsrUVVSUmpUa2haY0hEUSs2OVE0MGJi?=
 =?utf-8?B?aGxMZC90bkdNb2RRR3RWd3dyWUtwMm13Y1hhSm54RklSWVFQVUJLQTczcFdE?=
 =?utf-8?B?TzVncDhLUXgrY3VnUVdqdENhMVRVbkdTUXRQRWhJeDBmay9OUm5ocW5WcEZP?=
 =?utf-8?B?N2k0d2FJRjRITWJ3UjRNWlgwVGZTNXR3KzJuUHloRlY0dCtFSnI2aVZqU2NH?=
 =?utf-8?B?WXpDWXpjWlA1TysrWGFYTWp2QzJoREhyZElHaHU5Nkgra3FwU1dhZVd3Tnh1?=
 =?utf-8?B?YSsrNlFOMm1XeEVJVTZ4dis2VjlwMThRSENWYXFKUWxDY29PQkZaenJ0ck1Q?=
 =?utf-8?B?Yi9WcmpWN3FoSVF5a3VnVkhSOWs4MVhJS3NYcjk1b1BDbjhmUWVmL2toWVpG?=
 =?utf-8?B?NkhBMERJMmNnYVhiWDU0SUhQMTdvMm5GaE5hYkxhTlkwMnJScmdudTJwbXRT?=
 =?utf-8?B?SnpMZWZKdkxZcVZZcW5DUXNaekxPbGc0bEZRUzloV1FKNUhkclpFNDFEWHE0?=
 =?utf-8?B?T25nM3k2ZE5JRjJaZVZuTS9MUGMwVUNRSVJiLzI0cXYwSE1tc3Y1NzBBNEd5?=
 =?utf-8?B?MnNwQ0srMzFUYTVEN2YzWDRLeU9rb0ZZS2lhMEJPRFNCTFhwbUxoSmVSczln?=
 =?utf-8?B?MlZCK1h5V3pkeXQxWllxRC9rVm9MNk9kOVJsaUlpaXBnVGduMTBhOHBBalhF?=
 =?utf-8?B?YklNQ3JqSnRXUmRGOWMxd0Z3WlJYN3phT3RKT0NiOXRxYkFZOHU0L0M4cStN?=
 =?utf-8?B?OGoxZisxanlKNUVYd3Zsd0RSK0I4ZU9ZMG1VS2ZYS3hoSlh6MWtNTEFCTEpK?=
 =?utf-8?B?aGJzNk1qL3JxYndSUXBxNkxDUkE2cjJ4eHVqaklpMzc4L0FuMFdUeE5EVS9w?=
 =?utf-8?B?UGEwMXNuTFVuNXFhUG11UGVFY09wK0FlWGNzVFF3TERsemlHNFVjSG5TQlhh?=
 =?utf-8?B?N2pKeng1RFZubDNic2drck82bEp6RDZWT3I1NVlVK281ZnBvaUJDaTBIMTg3?=
 =?utf-8?B?UzdWanQ3VEFuV21ZVTJPNmRFMUtxNkNOcysrREdzdzZhT1lPMmNEaEtZY2ov?=
 =?utf-8?B?WEVkaWErVElDejlVU1BydzZMWFlpU21KOXJiSzdBMUNlTm93S1BHbU1qSHdP?=
 =?utf-8?B?R2xYV0dpSlE0UmtFallXNk5Nd1Frd01ucWlUTE9iWnJ6eWN6UmUvZlI1TWFR?=
 =?utf-8?B?Ykk3M3NWZnFoRzBMOWk5cFpMSUE4NDdVMStVMUlSNEY2WTQyaTJScHZzRnZu?=
 =?utf-8?B?VjlSeTM1VkczTmRlMkFvMk50SURDOTdmOVFuZUplOVBXRVFQL1lnYkVqanhl?=
 =?utf-8?B?Wk5RQjFmaEhIdDRMQVM0TTZ5eUs4M3doMGFDNmZ1TzFET2tqK1VxMDdCM3Rt?=
 =?utf-8?Q?3DcPBusDEbEQcML1oNBD5upo/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1d8a49-9b1c-43c3-e581-08dd50987b0d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 03:49:58.7854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9ZMz1lZI1IXYVNfb7VyElN3IsT1N+o0UhhEhdIV6khpnWeFbCtp4Wsqg2ePmpMAmLjtIFiUbVhQ0qide1R7Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047



On 19/2/25 12:20, Chenyi Qiang wrote:
> 
> 
> On 2/18/2025 5:19 PM, Alexey Kardashevskiy wrote:
>>
>>
> 
> [..]
> 
>>> diff --git a/include/system/memory-attribute-manager.h b/include/
>>> system/memory-attribute-manager.h
>>> new file mode 100644
>>> index 0000000000..72adc0028e
>>> --- /dev/null
>>> +++ b/include/system/memory-attribute-manager.h
>>> @@ -0,0 +1,42 @@
>>> +/*
>>> + * QEMU memory attribute manager
>>> + *
>>> + * Copyright Intel
>>> + *
>>> + * Author:
>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>> later.
>>> + * See the COPYING file in the top-level directory
>>> + *
>>> + */
>>> +
>>> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>>> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>>> +
>>> +#include "system/hostmem.h"
>>> +
>>> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
>>> +
>>> +OBJECT_DECLARE_TYPE(MemoryAttributeManager,
>>> MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
>>> +
>>> +struct MemoryAttributeManager {
>>> +    Object parent;
>>> +
>>> +    MemoryRegion *mr;
>>> +
>>> +    /* 1-setting of the bit represents the memory is populated
>>> (shared) */
>>> +    int32_t bitmap_size;
>>
>> unsigned.
>>
>> Also, do either s/bitmap_size/shared_bitmap_size/ or
>> s/shared_bitmap/bitmap/
> 
> Will change it. Thanks.
> 
>>
>>
>>
>>> +    unsigned long *shared_bitmap;
>>> +
>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>> +};
>>> +
>>> +struct MemoryAttributeManagerClass {
>>> +    ObjectClass parent_class;
>>> +};
>>> +
>>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>>> MemoryRegion *mr);
>>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
>>> +
>>> +#endif
>>> diff --git a/system/memory-attribute-manager.c b/system/memory-
>>> attribute-manager.c
>>> new file mode 100644
>>> index 0000000000..ed97e43dd0
>>> --- /dev/null
>>> +++ b/system/memory-attribute-manager.c
>>> @@ -0,0 +1,292 @@
>>> +/*
>>> + * QEMU memory attribute manager
>>> + *
>>> + * Copyright Intel
>>> + *
>>> + * Author:
>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>> later.
>>> + * See the COPYING file in the top-level directory
>>> + *
>>> + */
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "qemu/error-report.h"
>>> +#include "system/memory-attribute-manager.h"
>>> +
>>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
>>> +                                   memory_attribute_manager,
>>> +                                   MEMORY_ATTRIBUTE_MANAGER,
>>> +                                   OBJECT,
>>> +                                   { TYPE_RAM_DISCARD_MANAGER },
>>> +                                   { })
>>> +
>>> +static int memory_attribute_manager_get_block_size(const
>>> MemoryAttributeManager *mgr)
>>> +{
>>> +    /*
>>> +     * Because page conversion could be manipulated in the size of at
>>> least 4K or 4K aligned,
>>> +     * Use the host page size as the granularity to track the memory
>>> attribute.
>>> +     * TODO: if necessary, switch to get the page_size from RAMBlock.
>>> +     * i.e. mgr->mr->ram_block->page_size.
>>
>> I'd assume it is rather necessary already.
> 
> OK, Will return the page_size of RAMBlock directly.
> 
>>
>>> +     */
>>> +    return qemu_real_host_page_size();
>>> +}
>>> +
>>> +
>>> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager
>>> *rdm,
>>> +                                              const
>>> MemoryRegionSection *section)
>>> +{
>>> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>> +    uint64_t first_bit = section->offset_within_region / block_size;
>>> +    uint64_t last_bit = first_bit + int128_get64(section->size) /
>>> block_size - 1;
>>> +    unsigned long first_discard_bit;
>>> +
>>> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap,
>>> last_bit + 1, first_bit);
>>> +    return first_discard_bit > last_bit;
>>> +}
>>> +
>>> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s,
>>> void *arg);
>>> +
>>> +static int memory_attribute_notify_populate_cb(MemoryRegionSection
>>> *section, void *arg)
>>> +{
>>> +    RamDiscardListener *rdl = arg;
>>> +
>>> +    return rdl->notify_populate(rdl, section);
>>> +}
>>> +
>>> +static int memory_attribute_notify_discard_cb(MemoryRegionSection
>>> *section, void *arg)
>>> +{
>>> +    RamDiscardListener *rdl = arg;
>>> +
>>> +    rdl->notify_discard(rdl, section);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int memory_attribute_for_each_populated_section(const
>>> MemoryAttributeManager *mgr,
>>> +
>>> MemoryRegionSection *section,
>>> +                                                       void *arg,
>>> +
>>> memory_attribute_section_cb cb)
>>> +{
>>> +    unsigned long first_one_bit, last_one_bit;
>>> +    uint64_t offset, size;
>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>> +    int ret = 0;
>>> +
>>> +    first_one_bit = section->offset_within_region / block_size;
>>> +    first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>>>> bitmap_size, first_one_bit);
>>> +
>>> +    while (first_one_bit < mgr->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_one_bit * block_size;
>>> +        last_one_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>>>> bitmap_size,
>>> +                                          first_one_bit + 1) - 1;
>>> +        size = (last_one_bit - first_one_bit + 1) * block_size;
>>
>>
>> What all this math is for if we stuck with VFIO doing 1 page at the
>> time? (I think I commented on this)
> 
> Sorry, I missed your previous comment. IMHO, as we track the status in
> bitmap and we want to call the cb() on the shared part within
> MemoryRegionSection. Here we do the calculation to find the expected
> sub-range.


You find a largest intersection here and call cb() on it which will call 
VFIO with 1 page at the time. So you could just call cb() for every page 
from here which will make the code simpler.


>>
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to notify RAM discard listener:
>>> %s", __func__,
>>> +                         strerror(-ret));
>>> +            break;
>>> +        }
>>> +
>>> +        first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>>>> bitmap_size,
>>> +                                      last_one_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
> 
> [..]
> 
>>> +
>>> +static void
>>> memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
>>> +
>>> RamDiscardListener *rdl)
>>> +{
>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(rdl->section);
>>> +    g_assert(rdl->section->mr == mgr->mr);
>>> +
>>> +    ret = memory_attribute_for_each_populated_section(mgr, rdl-
>>>> section, rdl,
>>> +
>>> memory_attribute_notify_discard_cb);
>>> +    if (ret) {
>>> +        error_report("%s: Failed to unregister RAM discard listener:
>>> %s", __func__,
>>> +                     strerror(-ret));
>>> +    }
>>> +
>>> +    memory_region_section_free_copy(rdl->section);
>>> +    rdl->section = NULL;
>>> +    QLIST_REMOVE(rdl, next);
>>> +
>>> +}
>>> +
>>> +typedef struct MemoryAttributeReplayData {
>>> +    void *fn;
>>
>> ReplayRamDiscard *fn, not void*.
> 
> We could cast the void *fn either to ReplayRamPopulate or
> ReplayRamDiscard (see below).


Hard to read, hard to maintain, and they take same parameters, only the 
return value is different (int/void) - if this is really important, have 
2 fn pointers in MemoryAttributeReplayData. It is already hard to follow 
this train on callbacks.


>>> +    void *opaque;
>>> +} MemoryAttributeReplayData;
>>> +
>>> +static int
>>> memory_attribute_rdm_replay_populated_cb(MemoryRegionSection *section,
>>> void *arg)
>>> +{
>>> +    MemoryAttributeReplayData *data = arg;
>>> +
>>> +    return ((ReplayRamPopulate)data->fn)(section, data->opaque);
>>> +}
>>> +
>>> +static int memory_attribute_rdm_replay_populated(const
>>> RamDiscardManager *rdm,
>>> +                                                 MemoryRegionSection
>>> *section,
>>> +                                                 ReplayRamPopulate
>>> replay_fn,
>>> +                                                 void *opaque)
>>> +{
>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == mgr->mr);
>>> +    return memory_attribute_for_each_populated_section(mgr, section,
>>> &data,
>>> +
>>> memory_attribute_rdm_replay_populated_cb);
>>> +}
>>> +
>>> +static int
>>> memory_attribute_rdm_replay_discarded_cb(MemoryRegionSection *section,
>>> void *arg)
>>> +{
>>> +    MemoryAttributeReplayData *data = arg;
>>> +
>>> +    ((ReplayRamDiscard)data->fn)(section, data->opaque);
>>> +    return 0;
>>> +}
>>> +
>>> +static void memory_attribute_rdm_replay_discarded(const
>>> RamDiscardManager *rdm,
>>> +                                                  MemoryRegionSection
>>> *section,
>>> +                                                  ReplayRamDiscard
>>> replay_fn,
>>> +                                                  void *opaque)
>>> +{
>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == mgr->mr);
>>> +    memory_attribute_for_each_discarded_section(mgr, section, &data,
>>> +
>>> memory_attribute_rdm_replay_discarded_cb);
>>> +}
>>> +
>>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>>> MemoryRegion *mr)
>>> +{
>>> +    uint64_t bitmap_size;
>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>> +    int ret;
>>> +
>>> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>>> +
>>> +    mgr->mr = mr;
>>> +    mgr->bitmap_size = bitmap_size;
>>> +    mgr->shared_bitmap = bitmap_new(bitmap_size);
>>> +
>>> +    ret = memory_region_set_ram_discard_manager(mgr->mr,
>>> RAM_DISCARD_MANAGER(mgr));
>>
>> Move it 3 lines up and avoid stale data in mgr->mr/bitmap_size/
>> shared_bitmap and avoid g_free below?
> 
> Make sense. I will move it up the same as patch 02 before bitmap_new().
> 
>>
>>> +    if (ret) {
>>> +        g_free(mgr->shared_bitmap);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
>>> +{
>>> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
>>> +
>>> +    g_free(mgr->shared_bitmap);
>>> +}
>>> +
>>> +static void memory_attribute_manager_init(Object *obj)
>>
>> Not used.
>>
>>> +{
>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
>>> +
>>> +    QLIST_INIT(&mgr->rdl_list);
>>> +} > +
>>> +static void memory_attribute_manager_finalize(Object *obj)
>>
>> Not used either. Thanks,
> 
> I think it is OK to define it as a placeholder? Just some preference.

At very least gcc should warn on these (I am surprised it did not) and 
nobody likes this. Thanks,


>>
>>> +{
>>> +}
>>> +
>>> +static void memory_attribute_manager_class_init(ObjectClass *oc, void
>>> *data)
>>> +{
>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>> +
>>> +    rdmc->get_min_granularity =
>>> memory_attribute_rdm_get_min_granularity;
>>> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
>>> +    rdmc->unregister_listener =
>>> memory_attribute_rdm_unregister_listener;
>>> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
>>> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
>>> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
>>> +}
>>> diff --git a/system/meson.build b/system/meson.build
>>> index 4952f4b2c7..ab07ff1442 100644
>>> --- a/system/meson.build
>>> +++ b/system/meson.build
>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>      'dirtylimit.c',
>>>      'dma-helpers.c',
>>>      'globals.c',
>>> +  'memory-attribute-manager.c',
>>>      'memory_mapping.c',
>>>      'qdev-monitor.c',
>>>      'qtest.c',
>>
> 

-- 
Alexey


