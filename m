Return-Path: <kvm+bounces-39541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F39A4765E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:12:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B17213ABCC5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 07:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9331A22173F;
	Thu, 27 Feb 2025 07:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Px0HCK5z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F8220687;
	Thu, 27 Feb 2025 07:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740640358; cv=fail; b=jTpyNThZ1IwoBEGD8fGT8KxvZEzeQE9ZKNseGRCtlWZVNpfVkLl19VWgJAvBqGTOeUUH1XAQZs+78hC/B1vOZq+K1HJh8H4ALT2qPAGX44kMByx74RszgwCT5mG9gW4V83Q/x3cVWQBCq6YJVsykY0Sy/n9t8bi1mHzd9SMhI14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740640358; c=relaxed/simple;
	bh=hA6qrOGQtbAYvWCXywVfIOv5XobkGsaTn3qZ1gQWZyk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lu20xeA0x4vNs0DXyw27snHy5CQXErpSfppO+XJ1O1EK6ZrsTPXEyECpMFfHYcdJD7IozwjlAu4UtgtrKf8UIA2xmv6L+7PqnI4SSHSzrrD7rorZgLQ+6H9wnr8VKNxH8Cef5Ccm6YhQunKIEgznTww88DxOnDKRhHKdW+uIsu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Px0HCK5z; arc=fail smtp.client-ip=40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAQqE2Hfm3TdO1haMSstxFsZrXKrD+uNOGTgg3XepQ2Yoo9NustZvaBPKLj5qInew5/YMapjDB03uDOafHcaQf0TsCEQSFbVrm1zN3IKF0YIZ9Sc1W9zxqfXs48NyoN0rtGe7jsmP2Ni04oexNWb3+7XlXwJKAZHjR2i9Gz4bJ+zW5NHM2w0oadTOkDWipd4s/IbYfKjQ2v7rkKInp7OJ7Hkshg+Gj5VzUiG43Wfm0kDvrExjRXWEOdWxFk+grl9shwccbPuD1NLCnwVFHEMOBhuUCpn5Ilwr2/xQe2umPzYoXVKXVXk4MXaHaBYi0rm4zchu/UT3Kccpe+4Lb0J6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1xKDzNDzzhKMU1ro09fch1P8R83ykJpFzCS4gLpSeI=;
 b=XLlrtZ7eFdYxU3qZkpmT6+nJNx2BiqUulHE69Jw1CkAYQzVTSCChpeeFuO3FGPtQlRguBBc1dkGRTm1GJ0Vrb1APk7QLNvaApscpUjuRyFV772NIkEQ3I3xeroVB8e4WL2xZfLbchX3zv5zHdUqGWgSpP/+uflV78PrLy6yXCDN2XrImmcQKyE6mokzLMrXg4SJDyYM2HWKRMBxkcaCD/cadO//2tzT4FYIsU7kEusE1dkkmTaqsNWpKoNERSSOzXLvLp6acKs6qpQ3IrRGaMGLiqOE+K4R7+12SFbm3P3m6Yte/GJt8FkbwnOxv5PBL+cJzDNZ6aEvRaRmKaga0Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1xKDzNDzzhKMU1ro09fch1P8R83ykJpFzCS4gLpSeI=;
 b=Px0HCK5z9agsV4DSNnh1tKL2k6OSypVmOkBC4bnRNqcxjSdvqFCt051QDshhzN+HYgNzjp6ND5TYZ8fSfyOKe6g7Q7sQN0L9UH43V8lZHp9vY2aw9W6OKGcmKKqcDDZHKGaDHEDBL/0d+Fo/XN4I4+X3SILn7ZhLWV+6maQv+mo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) by
 SA5PPFDC35F96D4.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Thu, 27 Feb
 2025 07:12:35 +0000
Received: from DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28]) by DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28%4]) with mapi id 15.20.8466.020; Thu, 27 Feb 2025
 07:12:33 +0000
Message-ID: <4443bdf2-c8ea-4245-a23f-bb561c7e734e@amd.com>
Date: Thu, 27 Feb 2025 08:12:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] KVM: SVM: Require AP's "requested" SEV_FEATURES
 to match KVM's view
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250227012541.3234589-1-seanjc@google.com>
 <20250227012541.3234589-6-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250227012541.3234589-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8200:EE_|SA5PPFDC35F96D4:EE_
X-MS-Office365-Filtering-Correlation-Id: 1db9be20-9dab-4b2e-1ee4-08dd56fe1b24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnR1dUxpSWtnQ2NudTczcFVQR1JjQmt6RHA4NXBCeEV1WS9kSkxxc09HeDBE?=
 =?utf-8?B?YVQxVEhTOHBZMkt1aHRsY2MxMzYrdEdVK0NCTHVpc01JRTI2WHM4OHhmbmZo?=
 =?utf-8?B?WXZ0aFZUdTdvWmhWd3RPYzhLVDhYL2ZpaHJnQkhydU55QnZHelNHYjVXVTNh?=
 =?utf-8?B?L2pkWnY5WXhEKzR4eW42eCtiLzhzMDM2bTJ6eTR1UXY2Yk5BbXR6MjNlNG9F?=
 =?utf-8?B?eTdSVDZCNlJpZnoyZ05leXl1bEJGeUFrbnNnSUFPK1hsUXBSSURhUXFQbXR5?=
 =?utf-8?B?QUV3QUVaMi9WNmF5bVdZbk56b0pBYjRqczg3ZDdYTWN6NzJ2UGJ2THR6OHl2?=
 =?utf-8?B?VHlCejV6V2pPL1ovSXJZTmZ5RVREdG10OVZJRlNnSjNONGtWV0JaMGpNbEcv?=
 =?utf-8?B?MGdwT2toK3ZvdTNyOEp3ZHNLd0NrK2VEaWU4VGhwSGsrOG5qd2E4ZTkydGl6?=
 =?utf-8?B?UTFubmkwclpuK0k0Q1hhdmJhNVdyZEdaQjR6ZG1VT1VSbVEvbkpnWmJ3eHR3?=
 =?utf-8?B?OFlXaFBvUTNVajEwVi9nMUNEZldtVlNOdlBNbzYyaFRVOXMzMU1tNWYyUjVE?=
 =?utf-8?B?MW5DQUFnaFBzdTZKVW5hV0JMNTF6UHhsRytia2p3MkhwN2xGVldFQUx3RFEy?=
 =?utf-8?B?L0FVTUF1ais0WlV6eHpaaHJMV2drSGxyZyt3R1RHQzllaUJNSk5HL2FWU3A0?=
 =?utf-8?B?TEx4QXZWdHo4MllGQ1JBdUVQN2pVRURlNnROaHl4REQwYmF3MnFHRGdvMTNy?=
 =?utf-8?B?NitBaHdudWNISkhveFU4bUxTZVB6RTMxTzJqMzhGNGpPb2pyYTdWdk1Banli?=
 =?utf-8?B?N3M4OEZUYzlVaDJhWHRkVmNNN1hRWDlhRHdxd09jeXFMR08vZDQ1K3A2K3BK?=
 =?utf-8?B?VlJoRmpSTUVhaXNYUFhObmxxV1hkWXh5cFBtdGgvZDhod2RPNFFZWWtYS0Q2?=
 =?utf-8?B?djVVTHlZU0k0NU51WmFmbU1KL0dEdXYvWHJ2ZDc2WnFVR1I5R1E4SzFGbHRt?=
 =?utf-8?B?c3JWd1Jua28zVEY2Y203NFNGc3p2eHBWc2pkLytmcklZaE9kTHRseW1JbGpo?=
 =?utf-8?B?djA0M0cvVDlmR05uMmRjenlGZXlrMzBWdWdrQkpZN2pseEVyc2tlenVOdXNT?=
 =?utf-8?B?VkZPWEUvbERlZ1BTQW85cG02bko2R29lM2Jpb3VQY0NlRkdYSWdTTzhUQmlM?=
 =?utf-8?B?TnpXWFdONkFrTmxKSEVRZEZFdWJqZGQzc1BrOTBnUWxMZnU5clFxWERMUU1v?=
 =?utf-8?B?YkNmM2I2T090N0hKWFZVR2s1SjVIbVdKZ25ObDVWbzJkUUhvQ0ZsWHBKcnJG?=
 =?utf-8?B?NVlONGVkS1FHblJ2TythdjdzMHpqTkxDY3R2MElFZzN4c1lpdStkUGhuYjFY?=
 =?utf-8?B?RzFOWk1jN2xVUXhJK1lQMVoycHdBb1NLNTMrbk9aNDAwR2dBQW9qUklQWGQv?=
 =?utf-8?B?c0dyY21LUXRKTmp6ZklWazViQjFwNW83N2QzMUgzd2N2eml6dXZ6VWJvank2?=
 =?utf-8?B?VURPbHNzUTAvc0o4VzBKMTJWMmdBK01WbktNaVhHWXVpeDdMSFM1TEdFckYw?=
 =?utf-8?B?N20wSlNXMVVlbU5oWThrR1BNNTZnWHN2VlhTeDViK3VpbzRBYWRnYUxJY1Z4?=
 =?utf-8?B?R1hFYXlkNWhjUXBob2dVQkFMVkFhRHJzMy9sUWZjZXpIRVVqOWloTTQ0OFhU?=
 =?utf-8?B?eFlhSDJia3JTdnFZVmI4Ymt1ZlQ0dktiazVRckZMZU9vUTRkZXBMVVRhNFlS?=
 =?utf-8?B?WnFDNk11eS9BbVZHMU9sOW15USs2aysvL3N2dG1PZHdLWG0zQXJyOGVMRHhr?=
 =?utf-8?B?YVN3aFNnU1pkZHlONmswbEs2cG5OdCtBRmw4ZUhuMDY5N0RVQzdYMGZNYis4?=
 =?utf-8?Q?/lb808x4lRxWJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8200.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWZ0RTFuR0VOMDZwUVh3OG1kc2tmVlFEMDZCVDNhMEdnZGVEbElsYlpZYUVN?=
 =?utf-8?B?d29BVUZmdDF3dTArcXRZRkdHcTJqakpiejZPMWJwUzZBSGJDT3l3SkJ5SEZ6?=
 =?utf-8?B?cExIM1lSdDcxenAvNDdVQ1AwUFlZN3lRR1gzZFp0VzJiN3piNU5jMXFZVko1?=
 =?utf-8?B?cnc1YjN1UGowR3pjam8wUjlzM1lLSyt5NlBLZFB4N1dVZjF1Y2J1SThPbXZ5?=
 =?utf-8?B?ekNOTlJLcEY4ZzQ0aTNidFlMc3J0TTdRSFJDMjB2OXJiL0h2eUJpMkFVMS9Z?=
 =?utf-8?B?aHMwdXhtTWZPYTY4dFRDK2w0ZlJPQWpCM01henY0eFdzelJ2QlVvWisxVHBF?=
 =?utf-8?B?c3l1dGdlSjlKL1l6cS80TU1RYlZjbWVLeFhIdC9aZmtNMGNoVlErK2JmMnZu?=
 =?utf-8?B?cUpJQjBuZ3p3ZzJXTmNLTkh2MHRpaHF3cUlwZFI5RFNwMEcwNEZ0cWFXRmk3?=
 =?utf-8?B?bXpVZEw5TUVMMThUOTIzT25RL2JxTkFoNWd0cWQzWW1KbUgrOCsxby9rT2x2?=
 =?utf-8?B?ZTZ5RjJQeGdjTG1qaUxIR3ZPZDQvOEhMZjdpOS9uQ1JFbzlDZDd3L21sdlE3?=
 =?utf-8?B?Q2pRckF0eDgwb2lVZ1pXNUE5T0N5WTFMNGtoZnI3MjFOL0I3L0lJb1hzSlli?=
 =?utf-8?B?c1IrRTNLTnJhc0h1cnZtQUxJcmFIOW55YjJVSDBRMlJpV1ZEdXllVUlDNWdR?=
 =?utf-8?B?ODZQU0s0UExGeXNwbGJNbThoMzNZcHFLbDFMWGxNM0NkY3NwOERwSG1OUm1o?=
 =?utf-8?B?cDNEc3hmOGYvaU1iMk1QZURCV2kxV2M1TkZzUjVSdzBQUzYwNDI2bXM3cStn?=
 =?utf-8?B?QUJEdmRUMGtEQ2M0dXFIL3pFWHYwcEE2d3h2eEw5aWhqYlVhbmRBMUxsUjZB?=
 =?utf-8?B?ZTJRUmVQZkQzZkVrbW9CcmZNZzloQzY1dHEvK0JBa0wwRnRnMEJBbk5DUUY4?=
 =?utf-8?B?VDV1QUlySE00cUgxREhZeVFkZnU0VHZ3Mmkxdm1JUFlFblB3TXBHbzUyVEt0?=
 =?utf-8?B?SjJOeHMrYTRzNHB4Y0NUcWh2Z08vSHM2ZFIvUlh3a1NPd1J5MWVueGwrckth?=
 =?utf-8?B?YXVnd1Fxck5CRVVLVmlJRms1MnBaemVMcVBxL3k3NmVwa2kzNS9PSFk0bk0w?=
 =?utf-8?B?VEx2TzY2MzRkVEhkd2UxVmJpNCtTZi9PdFZyS25jTFdwRmxWbVJkaXZxTUly?=
 =?utf-8?B?TC9jRGxzMnpFaUsyTUM5eDAxRC8rUGRSZ3lCc1lxSVlGcnZyT1R3Rzl0NTZ3?=
 =?utf-8?B?bDZaY2wvYXY5a3gvWkYxdlZQcU1WOExsN00yYmtSaDNYNDlrTXpoZkxJd0lT?=
 =?utf-8?B?TGtUSlh1d0RrT2pUZE9lRlltdllvNHFoaHdDTXRoWmg1d0RWczE1aHdkK1Zt?=
 =?utf-8?B?OFg2enUvVWo2R3U0UHhaR3FVdzY2VDkySGd0NXN0QjdPZWRXelozS05qemhL?=
 =?utf-8?B?R1Z5amNsODhteVdseVZLZTVjU3V5aTNCaXg5NElGOXQyL1Q1WjB6cklFbUZ4?=
 =?utf-8?B?V2hpQzFBQmFPUUpmemVJMXg0VGZ3ZVRNeDNkTlUxVFU4a0JMaWp4cURXRjdF?=
 =?utf-8?B?SUhtaGZ4cFl4bUJ0OXh3QmUySlI4MDEyamRkbGZIZGpqMmRXVnIvTTg0SjFq?=
 =?utf-8?B?ZXU3bG50K3Y1cEluajhLRVNKdE1BVWFJcGcxOXVFUTdwSXJnTStLZGk2cWNv?=
 =?utf-8?B?QlhEb3Q3V3lwVHY3ZWFreEEybXpveVRRRjYyV2lmT1NlYk9qQjd2ZnR6aHlY?=
 =?utf-8?B?em9lcUUrU05OSzVqV3NYdHBkTnlSZzZiSjcyVXNPUjczckxnTmx2L0ZKdnhX?=
 =?utf-8?B?WDRadTg1R1VncjVJNnd1aC9jMml4STA0UWl2eUNEQmV0V3Rkak9VbXU0eWE3?=
 =?utf-8?B?VUtiRENWdUFrRVVHamplWnVXWFdsQWF3YXlCUWduVmVtL1ZUai80ODByeW9D?=
 =?utf-8?B?R1pUMk9qRVROS3loN0ZQZ0VnOWNobUtiaUQ4MWF4Q2FtY09EV3ZTL1Z2TC85?=
 =?utf-8?B?cFRrZnYxMytFbm9OOE5SSXBQclZ2U3lmUUJvS2VReldYSzlBWW9sZzdJOG1Z?=
 =?utf-8?B?RlZka2EzbXNUZG4vcnRQekxxMGlOVGpWaHY3TktPRHFkUTEzampIRERuL3kx?=
 =?utf-8?Q?Q0HtT3PYX3l9WIt3Yw7bK/BHj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db9be20-9dab-4b2e-1ee4-08dd56fe1b24
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB8200.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 07:12:33.6413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Br0a92zwKz/qNiFjH5CvyDEajDbu6WYW37kpLfmIddtwx0CY2VuEcBEGmjP+yz1mwNfQBQpcqxBnnFH9N9jxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFDC35F96D4

On 2/27/2025 2:25 AM, Sean Christopherson wrote:
> When handling an "AP Create" event, return an error if the "requested" SEV
> features for the vCPU don't exactly match KVM's view of the VM-scoped
> features.  There is no known use case for heterogeneous SEV features across
> vCPUs, and while KVM can't actually enforce an exact match since the value
> in RAX isn't guaranteed to match what the guest shoved into the VMSA, KVM
> can at least avoid knowingly letting the guest run in an unsupported state.
> 
> E.g. if a VM is created with DebugSwap disabled, KVM will intercept #DBs
> and DRs for all vCPUs, even if an AP is "created" with DebugSwap enabled in
> its VMSA.
> 
> Note, the GHCB spec only "requires" that "AP use the same interrupt
> injection mechanism as the BSP", but given the disaster that is DebugSwap
> and SEV_FEATURES in general, it's safe to say that AMD didn't consider all
> possible complications with mismatching features between the BSP and APs.
> 
> Opportunistically fold the check into the relevant request flavors; the
> "request < AP_DESTROY" check is just a bizarre way of implementing the
> AP_CREATE_ON_INIT => AP_CREATE fallthrough.
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks good. Even makes code simpler.

A minor query below.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
>   1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9aad0dae3a80..bad5834ec143 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3932,6 +3932,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>   
>   static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   {
> +	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>   	struct kvm_vcpu *target_vcpu;
>   	struct vcpu_svm *target_svm;
> @@ -3963,26 +3964,18 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   
>   	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>   
> -	/* Interrupt injection mode shouldn't change for AP creation */
> -	if (request < SVM_VMGEXIT_AP_DESTROY) {
> -		u64 sev_features;
> -
> -		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> -		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
> -
> -		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {

'SVM_SEV_FEAT_INT_INJ_MODES' would even be required in any future 
use-case, maybe?

Thanks,
Pankaj
> -			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
> -				    vcpu->arch.regs[VCPU_REGS_RAX]);
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -	}
> -
>   	switch (request) {
>   	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
>   		kick = false;
>   		fallthrough;
>   	case SVM_VMGEXIT_AP_CREATE:
> +		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
> +			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
> +				    vcpu->arch.regs[VCPU_REGS_RAX], sev->vmsa_features);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
>   		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
>   			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
>   				    svm->vmcb->control.exit_info_2);


