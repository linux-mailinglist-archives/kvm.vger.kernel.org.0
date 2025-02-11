Return-Path: <kvm+bounces-37869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0FB4A30DB9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E9397A4272
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8E724CEE7;
	Tue, 11 Feb 2025 14:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wjlm/KnR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2EF243965
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 14:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739282645; cv=fail; b=jkoyslxF3M9lGdGDc6DKbJvDOqyOtjWPuaJV/vs4KQWakrUugAqzXfVqLkgnCwEgr9QLbSzCULvdB2jIZ7mNj9dBgk6DVw/LKiJfhQGKutuC00nfgvXpAIKUKXiVP/9yzuAjLE74kzPw2VZV6WdpCO8RS9bml73eXnR+m4gpsLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739282645; c=relaxed/simple;
	bh=2pRZ5/N3PDGams6QhXm7RxBq5wDfaCIpMs+N85UaTfs=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=AakVD6Km7vf9uZtgKPN9Ty72MPe8KYO2jPV7xuzFvLwQUyYm014A+Q6H4SH8II5ChJZDj3rBi03qB4HwdXFY/GzAser9y83Pl+hgPbMn9f9UOuMsysz0I04diH/NMVlzJxS6TfvLKkB/7CG/mre99KiowBHBzrvOPnNWbFcDBVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wjlm/KnR; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HaP2+dZkEUlUE0FxGpaKny+0+JVB1Z8e3ldEEi/oz5veRvrHx0PPkiwUSGyv3aW8ulZh6xBPF/G6EI1MEMXmwkHcEK/9b2odqnPN5E57JepaQui/7iHkvKItaI40amDIULV+3lZ4fWQi9fDoA9vv1+sPNMpqW6jzQn7yfGGjfq85MaJO09LzY++FagceS16ymJ2oXY9xV3yoIXA9ka/iAeN3ErHoCa2sU26k5ZEsvi03sjJTPzKoqq0qdy7wDV885zdYH9GJMBwW3bJQXhU1IDdBqzZ8RwFcfQK7stmx5U/N8Tiuvm5wC0kDyO4McIdoSjGDz2XnKrk183cfoE9yPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbnTBV+9SBbMHhHhPLkdMukYlW37xZVEA7QkLsuJrII=;
 b=EW23JOC27KU8rQgQ6/G3A0IKBM//FxI7YTJ+JhoV5hOkyY5rHtkHVfDAVunIcuBu83LbIgmMPoqKo/4nZ8wkOcAfGDSmh4PTWLMz65Lb6tT6vEmtB/Clb+HDYrbxFOoPcZeUogrWfo5idqJrafGRmpJ6OLPSGXZCtfbCTtizWY8tm/0E0xch2B8Xsf1raQGjOxZHRX8eWfwuc5PUsvjoskFSlUKo04tpPgdq30KyalZirSQwCiVnN4OxGOt4sMG496t5JiWVDomykApGIl3sGyAH3gdnyMb8IfivGq06QmsUetwfUunaUPOOuGDPbTI29PGu62kOaEDF7a6t4f2Itg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbnTBV+9SBbMHhHhPLkdMukYlW37xZVEA7QkLsuJrII=;
 b=Wjlm/KnRv2K4fFatNkGSTVHZ1vVwIX9mHEt30O646xlvBV38X6k+HgHAuJCTOye3zA6lLgUgb+q8AFyWvwyAQaiXBeu8HPiPV5sqFEz2aYEkflfViHlWTCOLnC/HSMf4cAareksNMwra6VzeZOGKf1ITiFBg6FK4ZtaxwUN16RI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB7591.namprd12.prod.outlook.com (2603:10b6:208:429::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 14:04:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 14:03:59 +0000
Message-ID: <33fceaf0-ab35-cdcc-6e4f-16b058a96b42@amd.com>
Date: Tue, 11 Feb 2025 08:03:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com> <85ed04ubwc.fsf@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <85ed04ubwc.fsf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0141.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB7591:EE_
X-MS-Office365-Filtering-Correlation-Id: 937cd89f-2473-4ce2-b302-08dd4aa4ee65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEpJV1JCTHVIWXBBTHhiWnlIS2NhNVRRMy9HSGU5N1d5UWx3dHoyY0lzbWxJ?=
 =?utf-8?B?YnRVaGtVT3VFRjF5blZBWThhaEJPclJwM1pHN1dzWEtUQURFL2kvSGJ5c3NN?=
 =?utf-8?B?bUl0ZkgvUUFtR3Q0Yk9tOWM3NldOYUU5TzFSZ3FiMXBXQzlIZXFTS0h3Z252?=
 =?utf-8?B?ZUNkMGVLY1ZGTjJPYmhIV3dIK09JRGVLcG4wdG95ZkpLRVUwamZ2ZFJFaVBX?=
 =?utf-8?B?aXp3emJnZHhzd2dMS3lFcWdrT0t5WDN2OWEwd0w5VFdsZDlEeEErOEgwSDVG?=
 =?utf-8?B?a0w3SWdyTXZJYitrREhlK1lNS05NNUtsS1RXSXBCa2UrZi8xVDFnRmIxbGln?=
 =?utf-8?B?bjBYeWlQbEJUQ0Nmc0Jhb2NBNlJFakNldE9uVnBHeVBjbHRqRkVyUTJGSEdt?=
 =?utf-8?B?UEhDTlJaVFlBL3BiZ1JOVGN0L0puNHhaTHY3VnlDU1liaWpNTzg1T0N1N1BY?=
 =?utf-8?B?U2hoRFdmaVp6RXZ4NU12SjNkN3o0bEFJenNkVnJneFFYRlY0Vkt1QmJYZEQ0?=
 =?utf-8?B?UTMwMnZSdy85Y0FHSndsQURGY1BiRnRTS2JnYVY4N0ZrdE5BNW1EaWJUN1Zy?=
 =?utf-8?B?b1JGWE1aRENKL2pHOEpOTXhhaWlYWXNGdmtCWjBXbHNwNmdpcnh5d2RnRy8w?=
 =?utf-8?B?LzRRU1BmQUphQ1krbDhQSjBQTTcvM1YvNzFxamk4SnQybGI1NkdOV3dJMkh4?=
 =?utf-8?B?Y1NvcmZwOEhUWUprWFpnSWxBZEhrbTdCTHBMU3YxazI2ZUlmV0p3NHBaSU9E?=
 =?utf-8?B?THQ3bFNqQTlpemJLYnQyRy9JeUsyOTVTUzgxRlArdnNUT1UwZFpneG0yWlo0?=
 =?utf-8?B?TittMUxNWmJranh3QnNudXE5OE9JblJDMXpNbmcrUUJoRElaT1dQUzl2cHJq?=
 =?utf-8?B?VEN5QlpaQkZCUlpRa3R4SDZQTHBrK0JYcy9kYnNzOHpzL0ZuTXhwUURaczVy?=
 =?utf-8?B?MlRyWG1DS3pwZzFzeGhqZ0taRXltcnc4NFdwcUpzZVYvUjBlTHI0QlVVdVhi?=
 =?utf-8?B?U0dJS055NHFLVTN2RzBZa2hzdiswOWZkUDY4eUE2YVBzYW9XOHVsS1RudVJV?=
 =?utf-8?B?UzA5MkhLMGh2K1lCcVFWWjkvZ09ZYzhIbTlSNytjT2dNRjVDRHdqNFVsWDNx?=
 =?utf-8?B?YmRCV2FPQjFxaDAzS3pIQXlPNURKRnJ4VXhWMmVuUmlVcENkRjl6RnNobXpP?=
 =?utf-8?B?dE9qUjBiSk02ZUk2WjlySCtlTjNHOFd3UU94MEp1ajFpd1BGTFczYTdIdStG?=
 =?utf-8?B?L0MxaFlpaExqUXBFL3VLY2JqLzE5aDBTdlNtZVJjZnRYbktuR0FWL3BsWjJO?=
 =?utf-8?B?M3Z1ZjUwL3UxUUZaSnJrQ21lTndYMnZRcUR1R2p3VTVTb2NPaEtiT3ZpbUJx?=
 =?utf-8?B?cThiR2doenhtallnTTFwM3hHNlhEaWJQRmMrdVl2ejUrcjl5VC9hNTNjY2Fk?=
 =?utf-8?B?aVlGOHhjT20wRElsZUdwMGNNcyt0cmNpT3BBL1AyeDBuNEI5QVA1dXk2OC9v?=
 =?utf-8?B?c1l5ZFNJSG1nWUdaS0FCekYwUXZQdTdSRlhGZlc1YnF4MDdYYzI0WUx5d3E4?=
 =?utf-8?B?QW1xN1JBNmF1QURXa0VoN1IrQzl6TXpzclVGRTVlN1NoeXh0dXZFNmpoL3k0?=
 =?utf-8?B?VmVmV2o1ekNjQlIrd2EzcHZFZndZR1R6V0pRQUxPQW1BVHZ0aTBhOGh3bVd5?=
 =?utf-8?B?aHprb1IzWUpLc0dpNzlWWXJkaU5JTWo5OU82WFcvVUN2L1lYaUhML0JGaTgv?=
 =?utf-8?B?Qm05ZkIxT3RTZVdwcDN2ZjNWb0pFYlNQY2VjUlQwZnpselFoV3l1ZFhud0tR?=
 =?utf-8?B?TkFmNzJxcmdMcnpGSmlxZzU5MWtkREUxZVcrSDE3TXZ6ekVlMGgzZnBJR1B2?=
 =?utf-8?Q?Cc6ZQp4ZutXFb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVFReko5UXRUNDhXVWh4K3R1Ujg5clR2aTc0U2dCSXNzd2o5cmVXUHlEVHVR?=
 =?utf-8?B?aGUvSUU5RmQxWDFZV3JpSUhaSkViM3MranEvZEZNZ3AyRWVZdGJid1pVVC9r?=
 =?utf-8?B?WVJWSjdrWmNXNGptYTE2bzZYQXZKdmlRM25na215MWFMZU9Na1MzTWZ3UmVF?=
 =?utf-8?B?cTh4dkc2bThERDNXT0N6YmxwekVtejBJamxLSVlwTW55SGNyR2NUZ2hCN011?=
 =?utf-8?B?eHRtWDJmRGlkK0wySzgzUFZZT2tsdmJsKzVCdGtYdDk2S0FJUFBESzhwbDhn?=
 =?utf-8?B?Q2JPT3g1a21YVmxqYTFBLzY3MWJUYm5kZU5LUnUxNEhBN25ORlMyVXpMdTJq?=
 =?utf-8?B?ZUhUZDJZakk3UUE0WDN4QkZTQkRFOU92VWxWU3h6MlQzR3o1VitPUm9SMnpv?=
 =?utf-8?B?Z2x1eEIwZVcyMTZqN2U2cUxqSjI2c3VvWkpxUEJBRW12YXJ1cENIWGdoRTBr?=
 =?utf-8?B?MXdpN0lSWndSOXdJeG1jNVpjZStITUhvRnRnYUpiZGw3WkxqdUFyNEMrK3VM?=
 =?utf-8?B?c3JFNXNIeVAzT2E0MGNMU3h5R0VNakZlV3JoeVk5ZE9UbGlvUUh3S0FXdHdr?=
 =?utf-8?B?S0l2Tmgya2Rzc25lNktEM2xIRHVJTWo3UldFZ2swbEQ0T3NBbjljZERwKy81?=
 =?utf-8?B?RjFnakZmM3gva3oyWHFFR1FBUEs1NXhsZnVLd3hFL0o0cW1qdGZlQzI0Und3?=
 =?utf-8?B?bXV0dXd0YnBObmYyTXdvTjdDWTBPbGlEMHV4NlN5Y2RqK1ppd3J2MERXQ1lx?=
 =?utf-8?B?d2VjT0lIa1lNZWE0VVM0VDA2VjZ2WFBKUkx6dldWMHYyWlZZSmUxSXB1WlRW?=
 =?utf-8?B?Ym1XUW5lSy85alFEa3Y1WVF6Z1B2RDVBYWkwSFdsd0FqQ2JuNDVJVGU4Rmk4?=
 =?utf-8?B?N2lQV20wZFBWRTFUbWVqb1hheTFsdWR3czRwMjdZWllmWkxGMHJVZFNTYVBm?=
 =?utf-8?B?NzBJNlRWNCtHU0tLT3NIY3d0V2pNMWYybkw5cHRYUTR1aS82b2FTemZFeUw3?=
 =?utf-8?B?enR1M2gwRzdRRXFmVzZLaCtxUWNkOUtScVBPc09La28yS2MzZDQ1Tjc0aFpm?=
 =?utf-8?B?ZDQxVlRXQTFJOE9PRENOS09EUFBYQXlkVUNxV1BPK2lpWXdwbW1wY3BYdHFo?=
 =?utf-8?B?Qm0reHpZSGxZY08rNVVJVkJCcXhoeURWM1hVTHNNV1JHQnF3d0xUVlNLR1lK?=
 =?utf-8?B?L3Yzd0E1U2ZLYS9KRFprcWt5SUxXcFRHUUZDZXV2Qzg0WHUrMHBCVWtvVk51?=
 =?utf-8?B?ZGkweTFrY1AvenFHNHJrbFRCV1VMcnd2ckcyemUzb0V4OW5jM3NVMkV1WXRC?=
 =?utf-8?B?K3pFLzBiZi80ejV0WXd6R2xzbGtKZ2xyd2J2SjBYZUZKM3hFMSsxREV1Zld0?=
 =?utf-8?B?RHIzSFRsMDdNSkRXUVNDc3k1Y1VnVFpOUXB3WUl2bnp6QWdBMmJLSWRPZ2Y5?=
 =?utf-8?B?VVg4cTloa3BQZ1p2Y0NEd3RqWEhkbGxJeXdmL1h4eXNRTjB3Mm0rdDlKc3FI?=
 =?utf-8?B?VUpadUZZbDRSOTJjL0J5ZWJ6UEtyT3NYSktPcm1veHoxSCtnTWtJT3RRVVEw?=
 =?utf-8?B?UmIwbzNBMFZHS1BXTWhPNHg0R2NWelBEYzZYbTV6QmFCUmZhVzVSVDBnSCt0?=
 =?utf-8?B?cGNkNTRGczZkcUQrSEk4RVBiOHZORktrRGVTK3BhYldqZzQ3bENWakhEdENT?=
 =?utf-8?B?UDRyM3hmNUtIQW9hNkphWVBiUDl0Wm8wdTVxNW9rbHRsZG0vME15SGtsMjZS?=
 =?utf-8?B?VXBNdDJzOEVaWDYzTjRWeVd3c1R4aWtOZm9HdDU2d3o4UTB0RnBzL0tVTm80?=
 =?utf-8?B?cTVIUnFnYWNvSFd6V1YvNVRScUlKb2FBNmdIRjdzdE5UcXVEbDB4WkdFZFRJ?=
 =?utf-8?B?QmFzMTVjWlBCc1FybnFYZ01ZUkVtd0MzaENTaklpV1F3WHZ3djQ4K0JSM254?=
 =?utf-8?B?ajhTbG4vcmFTYkJrS0F6b1dEclR0RXBZL29NTkhsV2xIbFg1enZlZGRHY3Fm?=
 =?utf-8?B?ZmI1MDk2cktCSE9xN091YXZnZkgrL1QwaUZyeE9jUTQ4cCsvQVpjTDgrV1Vi?=
 =?utf-8?B?SjJtWkVwYm9KNTBKNk5wSkNTcXQzVjYwRG9YNUZZVXBmdHl2ZzVQcnJBS3hM?=
 =?utf-8?Q?5Q72bp7NwftQLdCE6GrZ8Yw6Z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 937cd89f-2473-4ce2-b302-08dd4aa4ee65
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 14:03:59.4006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQW966nxoUVvGCgrQgEcz2BvjZSgy44omzT6YGpNZnrh7FzeNeHBpv4/zjm61AbMWFs7Xy0UfGFhQZhWqkeASQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7591

On 2/11/25 02:24, Nikunj A Dadhania wrote:
> Tom Lendacky <thomas.lendacky@amd.com> writes:
> 
>> On 2/10/25 03:22, Nikunj A Dadhania wrote:
>>> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
>>> writes are not expected. Log the error and return #GP to the guest.
>>
>> Re-word this to make it a bit clearer about why this is needed. It is
>> expected that the guest won't write to MSR_IA32_TSC or, if it does, it
>> will ignore any writes to it and not exit to the HV. So this is catching
>> the case where that behavior is not occurring.
>>
> Sure, will update.
> 
>>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/svm.c | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index d7a0428aa2ae..929f35a2f542 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3161,6 +3161,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>  
>>>  		svm->tsc_aux = data;
>>>  		break;
>>> +	case MSR_IA32_TSC:
>>> +		/*
>>> +		 * If Secure TSC is enabled, KVM doesn't expect to receive
>>> +		 * a VMEXIT for a TSC write, record the error and return a
>>> +		 * #GP
>>> +		 */
>>> +		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
>>
>> Does it matter if the VMSA has already been encrypted? Can this just be
>>
>>   if (sev_snp_guest() && snp_secure_tsc_enabled(vcpu->kvm)) {
>>
>> ?
>>
> 
> QEMU initializes the IA32_TSC MSR to zero resulting in the below
> error if I use the above.
> 
> qemu-system-x86_64: error: failed to set MSR 0x10 to 0x0
> qemu-system-x86_64: ../target/i386/kvm/kvm.c:3849: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

Should KVM be doing anything related to MSR_IA32_TSC for a Secure TSC
guest, even handling this Qemu write? That Qemu write takes it through
the kvm_synchronize_tsc() path, does it need to? I'm just wondering if
the Secure TSC HV support needs more handling of MSR_IA32_TSC (in both
set and get) than what's here. Thoughts?

Thanks,
Tom

> 
> Once the guest state is protected, we do not expect any writes from VMM.
> 
> Regards,
> Nikunj

