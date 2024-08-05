Return-Path: <kvm+bounces-23232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B602947E42
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 17:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01220B2435E
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 15:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A704A15B107;
	Mon,  5 Aug 2024 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AQ3pTRf1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F8D155743;
	Mon,  5 Aug 2024 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722872169; cv=fail; b=Jvn0LJv7GOEih3God1BTPuzzUbUc7tgvZe5FHRjwFztYndhUqchZdTF2MabspvsA6X3F+ussoSn7V5sfrMwFI9VoxCQ5fOoqjXButxhV/4XkHXJ8t7gGOUTu5gl6IDOJPS09CrsFy8KwkndPAV9L+r9ynyLW4zdiTCO2pAf+mvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722872169; c=relaxed/simple;
	bh=BbFOwrii+q55z4NmOQzUD9npVZ9E9Mx5p3AzCatbCqI=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=sfPNHIoZJ5BzRMEHcc/HkRwcirZaa4UH3iWqNFn0Mp0L1hUQXb6EcBo/lPCGD6GXksvkuYB+GB+aRYSCwT1sD2WvqMYO+IqrbpDgJMdwJaWWkuokHtspAxIagCMVRUGJNGSYt7oNIsJ+bIfVkn8n5MNq3noLuIISPn0GYWZfQRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AQ3pTRf1; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGre3CNc01I0ZHc6zpj9FTR8/jeGb0XHMTCAeYpD+NebMK3GkbkI/BW9LkU12B4eEQK8mhHfhCjqo2tShbamZzvxha9eS62++owZFUAUSj+Tw4ZwYpVFIJp69F64uxbU8AQxhesTAUoUHNn/YMQjf6lyAmxH47axQqpxX0D7NRUgsR9iRcfwcYgOkSi2y7WPaRyLvYmGLj0usfv6aeeGFdNPaW9vIWsEyUDZDsBVfsh1Tz2ctQtcNcnjEqKV2HZEOS/nN/fDjCdZz5ih18TQYHn7uwyKCnO2ZiiIPu7pWEskVIQBGIyszORxb6U07XjUdxJByjRuVDnuIjbBsQn18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVb8DRNj5l0sXRmF/Q01SDbq9A1bHC0P/wuGdckHClY=;
 b=XkdlWniIGjtmaAOMs2fQ0qHNR8BHb3/dFSmyDG1mqHMSkEub5qkr9ktFD/CWEZlxi1mCX2mZz5Q5qvpSp25e9BTR3yEYkLi8JodsW/Q3ttUag/oyqGe97N/MYlahcAmEK6Z7L2bLGsuTMpLJhc+GeTmcaYGgysKtldMCnm6bcjETdLqwlfTHvkB+bwt++xlSkRTwFolAEGJvQJJRPan7e30uWRW8JZ/ev+tTBZf4WROisY8xwf1QxEJ3t6B22e0b3t7+zHB1GvnRIxhINEp34Sc5IUXlBPPWsVkZqhUCEEsV3PvzduN4QPfTjddeyHuchvSDT1GDeG/VT86XjwoDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVb8DRNj5l0sXRmF/Q01SDbq9A1bHC0P/wuGdckHClY=;
 b=AQ3pTRf1XW0+vcVd2wck1fILdm1/8quNtPx+3dKmUFuKB4LA/yGKdq8xLxd00k8D3y5HwU2QJ8qUDgVLn7G6o2KysF2PE+nXSS4R5HK3cqnCXR0oUsUM7TR4Ln+l0QcxzxUWxNHX977uwUFOLCaJhEe21jFaVvbTqjyR7HSn4LI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Mon, 5 Aug
 2024 15:36:05 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 15:36:05 +0000
Message-ID: <f55a236b-bd22-46a1-cf9d-c990a11d5c38@amd.com>
Date: Mon, 5 Aug 2024 10:36:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Weijiang Yang <weijiang.yang@intel.com>
References: <20240802181935.292540-1-seanjc@google.com>
 <20240802181935.292540-6-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 05/10] KVM: x86: Rename get_msr_feature() APIs to
 get_feature_msr()
In-Reply-To: <20240802181935.292540-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0073.namprd12.prod.outlook.com
 (2603:10b6:802:20::44) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a0f9fa-b4db-45d1-3b51-08dcb56451aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzV0TS9WRk5KU0dscExOcUpSUTlIYmVDU0tUSzZ1K0kxd0xUOG1LYkpCNm9P?=
 =?utf-8?B?SHFxRjlJcktKbWNUSW5GbktYRkk1WU9MdXBLNFpKQlpwcmxSWGhYMUo5OGlL?=
 =?utf-8?B?OTNGS1VVQzk3ZEhReFlsWGpRUU5zSkg1Nm9SbkdOM3ZRaE1yUnliOGNJNlo3?=
 =?utf-8?B?dXlEcDIvU0FTamJWckY1WmtoNzRkM2ZQVExYcnVwYkJDeHBaRFU1ME9yaXJy?=
 =?utf-8?B?cWx0VGYxYnR5dVJPeTlyalFheUI1K2Jya2hWK3I0QmVBbUY0SEFUWWVuanFT?=
 =?utf-8?B?YTNyUXl3WFh5aTYzcFliZEY2R00zS0Q3Y2hKcUxjZzlNaG15Y3dZRE94ekRi?=
 =?utf-8?B?UWJ4YThkMUFZbGpRRnZ0elAwY0V0ODIzUVJ4cHhtM3hoQmNhamh4dXZjVlNa?=
 =?utf-8?B?RXh0bVVDRTBySUo3bEhqNnJndERIVFFEQ0xYZ2dKN05zTnNBK2pJd0prbWZi?=
 =?utf-8?B?akovdThFOEZHVDhUcXQ5REhkRzl5RzRxQWUxMDBvZVpVRTVvbVNJSS9QbmM4?=
 =?utf-8?B?YkR4MFpVVVV2S0pDMXdPa0pPL2xGbW9lQ1Jna3Jtalk2cFJpL1I3M3A0bENl?=
 =?utf-8?B?YnRSemsyclhGRmpFYSt2aHIybTNkZGJTVHY5ZmdkM05uZ3B5eHJaWW5GYm1o?=
 =?utf-8?B?V2VWWlhOVWtBTUdjY3p6MjIxMnh1b3RVdXJxQUZoalVwQkVGWGZ4NEtzOGZz?=
 =?utf-8?B?b2xuV0pTejJUcG11d1Y4OVF0djN6aWpoa3VDTTJpL2RKMmNDbWVwYUNJcldP?=
 =?utf-8?B?dGhORFJWQWcrTGRsV05SUFhSaUZ2V1R2WlBlSmd0d3ZFOXJlcjlSVFprL2RY?=
 =?utf-8?B?TlowZEdTME8yWWlDM3FyWjNaaE5PbEdnZFROY0xWbW9aY3BQbTZJZ013M0xl?=
 =?utf-8?B?cnhJWEVETzVhRzBTaUk4K0g1bENwaEQ2VGtNQythV1hEeWFDaFkxNDhSSDBF?=
 =?utf-8?B?TDJyZGRxOVFkZjhXcHNENnZJZ2RjbDhNK01GZjZXWmc2Y3VNRUZqMUdXTHVI?=
 =?utf-8?B?WllBdnV5eldzQ1dadGgzYWJ6R3h6cTA0aERMeXhJZUkyNWE1czJQYzdNYXZD?=
 =?utf-8?B?R1FkTlZ0Y1dCNUJlUHdTR3JXOGkxMjdqOExmWTh4Y0FiSmgwTG12c0tKSnd5?=
 =?utf-8?B?RVl4Y2tmeElBUWpjcGFWbmRIVko4OUlLWGphRzJjcStQVnB6L2V2bXVlNHBH?=
 =?utf-8?B?VWtDcW82dHR3MEFvNnl5ckFSV1NvcW9FS1BSMGpCQll1Y0JzNjdMK2p5YXpr?=
 =?utf-8?B?WTZZQlNYbU1OM3BsSzVzT3dlakgzRG9Pd2IrSzlneDdKMGx2TnVkOWJablUz?=
 =?utf-8?B?WUNqQ1ROOFg0RnlrQzU3RFRTdUJrUHFZbEhrWVR4WFRET0xpOVViRTJSREhI?=
 =?utf-8?B?UExMUlF1eUlsR1lqcEFLYjk1NzVPZGwyWFRlRDZCeE52cERSZlJXN0R1QWl1?=
 =?utf-8?B?eHFteVRVQUVUVXdvaUhTbDRpMzUzTDBvRkRaMTN3N3dyVHIxUkVPSHovbzBW?=
 =?utf-8?B?czhRTWNQS3BpcmJubUFoOGJVSHl1WlNvS3d6a1RQZ0h6NXhSSFRHTitXTUJj?=
 =?utf-8?B?d00zOFE5RTdQOXllcDZPTCtDMGk1ZDRFdVFibnFWVHVjWUxjNFd6eTlSVjFX?=
 =?utf-8?B?NUVQWmRLWE1FeFFvbUpCODdiM2UxSzlNRk5IWmFHOWRDZWpqQ3BlRVZmclFu?=
 =?utf-8?B?RmVsVVc2ZUZLMjJ2bEI3azRScm0raE5uM2hTZWFtaER5MVFMYmJxRmhsR1Vq?=
 =?utf-8?B?L29DMS8rU0FYTThlZVF3cmllZFpKUE9DL0d5cWlRQTNMVmpqRUtRU1ZRalF0?=
 =?utf-8?B?eC9sS1FkNmZoNUF2MXNXQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nm81d2RhMDVaWnl5ZkJUUGlTVURnUmhaQTl6SGdKOEExQUNqdnlkMEtMMjU5?=
 =?utf-8?B?ZmZKK3BYOVFEYmdLOUV1SE9KNUpDNWJuVDc5RlNWSDZvSVJpYjRtSk5JSHdt?=
 =?utf-8?B?c3duUGtpNEVCaHhmcDZpTnBwZUpKeElBNEY4aldVbWhLcUtjVllQbXRtSVVj?=
 =?utf-8?B?T3FpSWUySm9xMmM2eXNFVmVQOU5Cbm96bmpzSDFJS1NHaHVtbytlQTVuZ0E2?=
 =?utf-8?B?R29qV2dTRHhhQ1pHU1ppeE9BSEZKYVpuQUhmcG13S2tPeCtaSXhoR3c2V25z?=
 =?utf-8?B?NjlDTjMxckp3bVQ4enFremNPRUpPU3Z0T05hWGhDZHNyWjZLOElxY0xjckJ5?=
 =?utf-8?B?NjM0VlZock52RGp5NU9HMzZlek4wbWYxbHU1cGdUa2ttYTI5MjArVXU0VzhM?=
 =?utf-8?B?REgrYmZ3Zlphb2lpTGFFRXd6czJ1RUFiVlZuRERia2xyN3dFbTk4R3RyQ3Z6?=
 =?utf-8?B?N0ZyK3BOdnByZjMrYldxOGswWXUzNndSUklYNkxwYVh0ZHExaFpudWEvV0tS?=
 =?utf-8?B?R1A2akV5N2NHOHVta3hKWG1sTXJZRXBoOVNKYnQ1a2VUdmZvb2JRS0tCVVdH?=
 =?utf-8?B?NGxMVERhMDBuU3V5MEV3anZtdWpiTUFvSUY1UUJYYzg0bjhOOGlUKzluVVp5?=
 =?utf-8?B?SE1iU1VYUTgvNmZUSW5lb0NqZDlVRENoajBXQ1hxR2hFV1pXL2FyR084ZFV6?=
 =?utf-8?B?b0lxdVRQWXd4bWxmSkh6MU1YaXF4cW1JdTRua3NvVGFsdEtKQ0VJSmpMbElv?=
 =?utf-8?B?eHdJUkxOb2k4eE1xd2QxUWZTaS9nWlFpU0pRUXhtbVlxcUYySU5rMEI3MWtq?=
 =?utf-8?B?aGNpS0xPMmwwazdYUUhSUERMTUp2NlFkRURxeWdVRFg2M000amF3VDFSeENl?=
 =?utf-8?B?djUzZEJ5dUx0eXhkanhVZ0NoY2hMMmZ4cVVldjlxb1pic2Y2ZkNMWHdGM2JE?=
 =?utf-8?B?V04yS2xxY0ZtRlNxT0w2RVUrMjlxRjhVbHVqZVhjL1c1OFhtenQ5bWVNazFZ?=
 =?utf-8?B?d1NQMWpJOUFtVC85YXZLSnVJUmJpVW9Nano4SUFpNTIzVlBqUkF3bFpMUjMx?=
 =?utf-8?B?WlhWRWFUWFF4Y2RLK0NZc0lyNHRmSUFUYWw5VnA2ckVOaHplaThrUEw4aVNq?=
 =?utf-8?B?aHpsVGFOUHZ3clA1ZEpOWENoRk56OGZ5dEFSam1kQ0hYYWVxNmZiKzlOQW1J?=
 =?utf-8?B?SWFFZVY4b0M3ZEhPODc4b1ZHMVdiSEtJeHl3UHdvWDlVa1lMY3haYjJubHBq?=
 =?utf-8?B?bE1VVGxyR0gwenpqOUEvTkFwREpjaEZqMDA4bUpyQkRZWk5sZFhtamsxVDB1?=
 =?utf-8?B?QVdyRkt5VXBTUm1wY01iNG5CSllIQXlHNlhqZVBxeEZmUGU1RzRIbGxUUkJI?=
 =?utf-8?B?OUV0Ykxubmp4aUFsOE5aRzJqZ3BDZ1RTazlYK2szbEpFMzJXeXkzbXVHdjQw?=
 =?utf-8?B?ZHRhV29XOHovQ1B0dXYrTDB5VnpibFcvSVh3NjdqellheUFzNnVRZE9WRXhh?=
 =?utf-8?B?ZUlVY0NHbjBxcEpZZHNMT3ZHZFlCVWpYZ0JrZ2JnVmp5cFltbExOWGx5Vm5u?=
 =?utf-8?B?TXFtUkt1MHlJZm80ZUYvTjhETnlBN1htZjJRMUxweWtieUkyMUNLam5jMW9N?=
 =?utf-8?B?VjNYUUlRdmxPWHE1a05vZm5abkk2MkluWEd5RU9XYjJ6dStubUtKaW1HSlRC?=
 =?utf-8?B?LzdKbjJiclROV0xIajBiTkMveFlKOTVvUjNOZWNDUFNSVk8yNFJPeEFmaTln?=
 =?utf-8?B?NEZEYUU5czU4cGprT0dZYjY4dkkvZ2d1UDZGdExjbWE4RGhWdWJTcHB3SzBD?=
 =?utf-8?B?NWpzVzYwWGFyYk5Ec25ndk1VVXNyV2JCQmdkWFVESzVya0xsZkExSEFwVFVp?=
 =?utf-8?B?QXN2NWJkNThNaG5pUm5jaDNNL3YrdHdaYlg3NXBnR2JQNlhpOFNaS1dKN3Rr?=
 =?utf-8?B?NVF0U3k3OVArSnF4eUo0UjB1L3orZ1F6eDE0d1R3MzdUaitad1QwSjBKNWRY?=
 =?utf-8?B?WVpqbXRUd1dZM2FLTVl6RVQxSnFFWVlyWHBvdWpuMGsyMitXVFI0ZjNYZ1Qy?=
 =?utf-8?B?TVZhWkdkZ084bjlvUlQzNVd4WWc5Si8vdlZXVXdVMWJIWnFiZUtEc0YzTVh5?=
 =?utf-8?Q?1FxRVQMONWbLgGcDWAunAnRdE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a0f9fa-b4db-45d1-3b51-08dcb56451aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 15:36:05.2967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYbYp/FWYV9Y/IiQwULe80H+uN27t6C8BkciufmT9a58gIfl8LxJ9KjK7PBwqJwfSUpltfVnLZx1vdr6ihL/nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572

On 8/2/24 13:19, Sean Christopherson wrote:
> Rename all APIs related to feature MSRs from get_feature_msr() to

s/get_feature_msr/get_msr_feature/

Thanks,
Tom

> get_feature_msr().  The APIs get "feature MSRs", not "MSR features".
> And unlike kvm_{g,s}et_msr_common(), the "feature" adjective doesn't
> describe the helper itself.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

