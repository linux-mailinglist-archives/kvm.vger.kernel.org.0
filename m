Return-Path: <kvm+bounces-51870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D90AAFDEB8
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 06:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65E9A4E7832
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 04:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97E525FA0F;
	Wed,  9 Jul 2025 04:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lcQevUOC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37343147
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 04:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752034370; cv=fail; b=UhGRtKKjyRpNGyAsM8EEDIw4oHkz0mcL+37Z+W9KFcmq9Yx39wzrBqiy/Ld70TjM8RlJUKYoPwYNv0jhwVyspiljjRSWx2AV8lKHiIX5SyqLbXqS1ar3iU49aWtq3Cvt0heIpFtgBLkCmjo14J4du8E6KPfD463u6mRaHZdN7jU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752034370; c=relaxed/simple;
	bh=MaNCrHO/nAFCid9VDDR/H/fgMDAQbl5VkweeXAdUcz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dw6g6XXrIn+OTV46LEnMBnFKp0fIf/jWetTUxrTxOxpfxtRBzTdYhKGcOGFPbFyENU1tlNJdoCAsjfJTTUD0DKVjpxuS9YzHIjG8rT1H7yV+mwPwjyw3zLlPJjM8bZ9x/baqqgEKjejubviJY4iVhcH/ONxQ6yFh0v7wbE1/K9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lcQevUOC; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YY85P/Jq4NXF/58+8vQK3Bj7BowNB3kyVUEt+TYmDfP4MS96MPLJbRUv9mtzNsvxBShLnX8F7Kz4vIvukhKxYtNV67CshTJIbLId2zEwQ8YZXkQpHGGT3thTOToWla6FyFfPmBWuIB+PUhW+YL7e+23StNFVV3/tyG2PQrAAgXSHV2z3cgG3NYq1s58VvdNv8snzKUSL1jKMIAUcqHHcI4AtEa2bk5ZNYMozBtkU875SKBemSasKPnzqvZOFh0YeDQZQpgYRD7Ty8ttIOy7J2Gqnm5hFhxRHPHFkAmFMITNMBdXNbE+pAa+cD4gjXXGQ1f5T85Oq8BKRV56xVm9+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlVqT4JzWRl6Fn/oGNS6bpln8ikkpAKs5WVUsU6gQ7E=;
 b=sNL8KWhyRYw8n44cqzJ1RUoorCcPyYdWM1GkCbMfEPh1SmyN6zn+QEvjrnKq7PcUA083gvb7UhRya6+ffNwqFX4FIR8wUk1anaOL859ooptjO5ITOX537SsaUsM8l8ZPrR+lcPN/VVVLigQqwXVvmW2IrTwXfoknq5LPfGw5RcSBYVtHDrPkUed4B1fQi8QwHTfK0ErWdccBXowPlxNZPW1Uy9ebhn0QxX9xgC2eA4zoQdvjqs9cnU9KHjhjh/F4HfXdylSzJoWuwakcn2HbOF8sJx3pD/l5yLnS9iXbNRkpV5Sk+oEEEj+QO1hxeE4U9mr8urE9UGWyBW5CvmLVbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlVqT4JzWRl6Fn/oGNS6bpln8ikkpAKs5WVUsU6gQ7E=;
 b=lcQevUOCg3Wf8zxtrpUGHMZ9HcbOw1/pdZa83k2CROzUlSplVbRMTCt/ZPd+k5dT7a2+FGrXt+qMjFYznv0fKmClC2gL3Lxt8kbwioZep8gSzweFFbgwNL/K4Bp5PSdLCZONwGJYKOcySfv13pnoYMCz6y+JexgZACSQJro8qFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 04:12:46 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%4]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 04:12:44 +0000
Message-ID: <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com>
Date: Wed, 9 Jul 2025 09:42:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com,
 santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com,
 vaishali.thakkar@suse.com, kai.huang@intel.com
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com> <aG0tFvoEXzUqRjnC@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aG0tFvoEXzUqRjnC@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26a::13) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f6163b-235d-44e1-b15d-08ddbe9eda86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dW9BRW1lRkN5TmdYMG9Zd0wyaXIrOXF2Q0ZyUzZOUHV0K09QMjdKbithbUsx?=
 =?utf-8?B?S0h1RGFjNHhFMHZwRU9MMTA0anFGaFRsTWdRb1NzbHhxaEIxU3RFUGNTdGox?=
 =?utf-8?B?TlpIY0Y0a2tSSTBvM0ZZWkJYZDdyaFliYlNFUW1WWktiaEJxRU9ob01naE0r?=
 =?utf-8?B?RTFzRkhpVHpGTVdrLzdyS2F6MmVmWW1zWUx1b3VaYVFFT01ueUdoOUtyUnpJ?=
 =?utf-8?B?OXlXVjFOU1NFOG5oSWhGU1hHWmE2QmlGQlhXQkVUaWdwRllYVHBpbkR5T0lT?=
 =?utf-8?B?L05nN041S2dTbnNSR0c4azhmV1VMeWlLbkdMSGlNdlYvSWhkYURLZUthbUtk?=
 =?utf-8?B?WCthaTgrcHUrZTJlb0hseUtFd25CYUJuWUd4Tks2Y25XNTNHNERzOW9FSHpi?=
 =?utf-8?B?UmR1QlJtbXdKVllUWm9RNE5BUGxraCtIY0FLNjFOM0RlVXRyYmFIWmZYOXlW?=
 =?utf-8?B?OGR1Z1JSMy9VTCtGczFseGk0WTFVS3VIaHBGUFF0RVQzdi9OaXlJTitZMTFQ?=
 =?utf-8?B?NGFWRGlrM2tESTZSYnFOcXRHdmQ0R0t6aGxoc0NoeXZkM3UyeW44WWtVQ293?=
 =?utf-8?B?MHhYc3pST3J1dkdlakpiY0M5NGRmRHlYZU1IcmcxLzNGRGprb2dMZ0pqUU8y?=
 =?utf-8?B?NVkxZDJyS1cyQjNpS1loamFOUG13Uk8zNXhGK0s3SXVONitaSVVoaFhHSnlz?=
 =?utf-8?B?dnQwWFVqbUhhVUxYaHFIbHBYT1NPYlZ3TThJa0RUei9CUE5tUmF6VlVDZktp?=
 =?utf-8?B?Z0FWcVJyeG44YW9YMzZ2YlYzSHB1TzNPZ1ZTb0ErQWliN3REOWEySGtmcTE1?=
 =?utf-8?B?NHM0cVJFcGRubVNYR2wyQ214blhVRjlsaWszSlhkWUc1TlVCeXFCZGk2c3pv?=
 =?utf-8?B?Vm85eWdQMjNXWWo2QzBkcTRTMHF1bUxlYXc5ZVRhT3lpT0t6OEVoZHA2ZEVj?=
 =?utf-8?B?V0cxdnlyeGMyb2dYc3hhcGFuazJjZGR2R0JDbE5TMU5RVlFwZVIycEcxQ05h?=
 =?utf-8?B?WDR0S0FKWFpTeDBsdEFUWWpHS2QwQ01LQ2xTL1AwS2IzNVRZRVYxSy9PeDhV?=
 =?utf-8?B?aC9leFl0dzluczI5d2I5VXJ1SE1qdEtVOVBsUjFEcit4dFNFRmJFVTF0UUdG?=
 =?utf-8?B?UllMUzQ1dnNVS3ZaUkk2aHRqRmZmTWdXaGpaK2VzeENla2I0YWUwbHRQMUx6?=
 =?utf-8?B?Z3RWMzBnLzd6YlY2aTc3RkZJYjRYUFd4MVJ0cjl1UTkrc0FEaVlSVHRPSnpS?=
 =?utf-8?B?ckYrNXVmYWloUExUb1ZXYzZyamRZaTI3RkVPWWpKblhGaGFwbDVkbm9pelU3?=
 =?utf-8?B?eXlXOTIrNTd0d0VFaDNGZFBaN2FVYzdkK2xYQW5TZDFyaTF2VkZEWk9qV2sv?=
 =?utf-8?B?enQ0NHYyTzhQcUV0bUJHQWJ6SG1yTE01VXo3U3lrYzFCRWJGVXBUY3QzSFRN?=
 =?utf-8?B?S0Z5ampFclhITDZ2U2hiemwySllKaDd4eVhCcGxVajdGU2NUTTdCdHhoTjVv?=
 =?utf-8?B?cHM1L1B3V29GZVJxVkZJNnMzd01idE1OUU5RbVRvemIyc2o1TmZ0R1J5N2hQ?=
 =?utf-8?B?bWdqWWZsWUk0VWw2L25kdGl0d0gxc3NJaDJqWHA1YzNWb2FuT0dDajNnY3dv?=
 =?utf-8?B?amFjTi93V2NvVGQwR1Rnc2laTVFiNldJWEViMUlSQWhvMi9qTUNJWkszalZa?=
 =?utf-8?B?cWdndGFxWHhiWER1U0VIdUVzdTJJaTYxcXdOZDdwTHBaYmtyZjVsYm1DMTMw?=
 =?utf-8?B?TEUzTDNISzBQcnZ0ODZsRUdZcytSL01IdTNMUVhCbTV1VWZiWUhSMUpyaGd5?=
 =?utf-8?B?L0VlbEMwWGRnNUU1WFJZNFRqSFFnelJCR082LzE2V1BlSkdmdG1pWFZzZWtQ?=
 =?utf-8?B?TU5Hakk5YXRXQjV6Rzc3USswanQvazhxZ0QxQVQ0SGhsajhHblNMazE2TFdZ?=
 =?utf-8?Q?U7/tuUUG1NY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akZaRFE2TWY2STJkSExTelU3YVloeVdtTnMwclM2THhGd2RWWGREQ3U0cWVM?=
 =?utf-8?B?cXM4RFo1U0NDc2tOanM4Z3Urb29XalBiUGc0VmlRdXhUWk8rbGNhbElha0Fq?=
 =?utf-8?B?SC9VRFV6dTZ1QWJZdXFvbWRLWlVFRmtNdU5meDlNN0l5MWVGSzdxUUVkNVdj?=
 =?utf-8?B?NG1hQVh4aWtLV1AyS3RNck0xa3U2Z2hnVFRRbkhnVHBpTGJkeHpmTlpzaTdG?=
 =?utf-8?B?Z3MxeFBNM0tNemdQQU5JVStIVW5qNjhUY1hKb0haNVZXOTlJajZjL2prMTcz?=
 =?utf-8?B?Q3VGOThHTXh3Q05yeTBEMTMzemFHTEZPMUZTd2szS3l0VSs0WG52QnVoWkdY?=
 =?utf-8?B?NjhvOFNhUzBpZEdUT24vOGExaGYzTUFza2crZ1RDUGFIRjVSWmlQZkUxeExj?=
 =?utf-8?B?T2JKclprU2crNDgrN1E3TFk5VjhmR3VBZlpZZkVBZGtDYW96cmdhclFwdmgr?=
 =?utf-8?B?UzlDMXhGeFdVRUdvcDgwL3Z5Y0dFNytRYmNxcVVOeVlCSjE3SDhucGFaN2VM?=
 =?utf-8?B?M2E5WGRsTk90TG5NenZNV2J5Z3Mzek05QUdHdG5jTThCZi80RnZsWXVNZk9x?=
 =?utf-8?B?UHFrZUZ6MHczUjV5dVlGd1UrNVYvNnJ2L2thRDkrRENTeGZ1dWx6M3FIR2NV?=
 =?utf-8?B?ZW56TW9LSlhDR2VlcG1pZnVObzBKb0pNRTh1eitLTk56UE5CaDVjMzVwZkdq?=
 =?utf-8?B?RTRBTE5wN2JXRFoxZW9rd1NtL1YrRUtYNDVZWHFXc0Zvd3N6RS8xK1FXMGQ3?=
 =?utf-8?B?aUhDVFc1THQ1akFhU0tZYXZLVSs2TDdCTmJKR3hKSnlIakhNZ1RoL0NYVGlS?=
 =?utf-8?B?czRlZE94QVlEYVVyY1N1UWUxMVNsd0U0Q0o5dVE1NkdCcVJHUnk3eElBRTdn?=
 =?utf-8?B?WEsxZHROMEVEOUg4ZmJyZkNUZWFGTFpTUDQvaHpOM2x3MEFkOFN4aTRWMnBP?=
 =?utf-8?B?TmdST3dyMmUzd1BnNWQxRGxvTldPeThuV3pkSXhiK3RKUUl2MlZvOTFwWmlP?=
 =?utf-8?B?ODJmV3VmR1BRZEVtWXRkYXZjL1VLVzVDMHY2cm96UndWSnlNYldIRGlJdVpH?=
 =?utf-8?B?MnloQ29qd0d2WTNZMFltczdxOEt5SVcrWUF6UUpnOTduTWNCU3dRcEpFN0s3?=
 =?utf-8?B?MWtlbm9CMlNhY25xUmMwWnRZZldZcU5CQmVVREVPSFVZcnRLeGtWdXpEa0R2?=
 =?utf-8?B?NlJUb1VoU201UDRRVHdQRTlsMi9Iait1dmZVYU8yWnUvNXNhdXltSy8xaUhm?=
 =?utf-8?B?ckJaZExUQ0g1ZlUwTzZtL05qR3lmNlVqNHR6MS9KQjQyNlo0cGdZOWlCdG5O?=
 =?utf-8?B?TW9rUVFENElQRmgyKzhnaVY5bDJIcGNUSGNsT2ZMeG1UcUw0c2YwSzdyc1Av?=
 =?utf-8?B?WHprKzNrUldWRDNCZUl5c3ZRU2tLaldkVzBzZ1NuNkZ2a2dGZW9xV3dPVC9B?=
 =?utf-8?B?L0dSZWhLWFNtQWZlNjVsVmpWcW9mS3owcHpvRTM2UU5UQ0xIbUZmU3ZLVjhk?=
 =?utf-8?B?VjJBSmRDUFk5Z3ZLdDRKYnBsRXF2cGRxcFFqUGpRNXowOVFRcm1wMHphM3I0?=
 =?utf-8?B?NkZSRWg1VWJ1dnpndTJDbnJhUTNveGwrZVRSVkdXRXpsV0p6ZTY1cHh1Tjlu?=
 =?utf-8?B?YWYxbmFVNTRFeDIwUUpOR3F4aS9WbldMbWc3aWFYWk9uZ25oR2p1b0tCZndu?=
 =?utf-8?B?YXVoZEVUd3FGN1hQZkp0elBRUTdsdmJoWG85aDBGbDNQYjJTODhyMk42cWpi?=
 =?utf-8?B?ZVpLbXdTanF2LzRBVXhobVZOWWJoL3I5dURHeUxJVVllUjNSSGtjQllWc1lM?=
 =?utf-8?B?VmR3T0NqTUwwbnRKdWNqYy9BNTA1ZWQ1Mmd2S1dkSUJ0SnNUcWxCY2l2L2Np?=
 =?utf-8?B?TGRpdFNYdXZ4TENPZksvM3dtTHBtOVAyb1BSZmZZWWpER0tNSHRHTThMeFow?=
 =?utf-8?B?QXdod1haTmN3a21NdVpoUmZmQ0gxUzFMam9SNU1jaWZKYTMrMkduS1EyR1Y5?=
 =?utf-8?B?K1JjbFFIdVJudVgxcjZPSnJJNnVFdHZGc0NNTjRtb2RKWllEZ0E0STNmaktm?=
 =?utf-8?B?K3lNRHIrYU4zelRiZ252QmltSmdCWjBpZEhzOTJMQTRiMnhaNnB4VzlSdUww?=
 =?utf-8?Q?R4VnaV0xa7uplkRFs1+dMlBn2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f6163b-235d-44e1-b15d-08ddbe9eda86
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 04:12:43.8354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfWP9yFWcpd0D80QdbDQdN+piSPxZU0xwtb8lGU/j0VhEDy/nmW/hq5SwDbLUDYApUmzIkrtMZu06yImTyAC6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883



On 7/8/2025 8:07 PM, Sean Christopherson wrote:
> On Mon, Jul 07, 2025, Nikunj A Dadhania wrote:
>> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> hypervisor context.
> 
> ...
> 
>> @@ -4487,6 +4512,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>>  
>>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
>> +
>> +	if (snp_secure_tsc_enabled(svm->vcpu.kvm))
>> +		svm_disable_intercept_for_msr(&svm->vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_RW);
> 
> KVM shouldn't be disabling write interception for a read-only MSR. 

Few of things to consider here:
1) GUEST_TSC_FREQ is a *guest only* MSR and what is the point in KVM intercepting writes
   to that MSR. The guest vCPU handles it appropriately when interception is disabled.

2) Guest does not expect GUEST_TSC_FREQ MSR to be intercepted(read or write), guest 
   will terminate if GUEST_TSC_FREQ MSR is intercepted by the hypervisor:

38cc6495cdec x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests

>  And this
> code belongs in sev_es_recalc_msr_intercepts().

Sure.

Regards,
Nikunj


