Return-Path: <kvm+bounces-18844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 328DE8FC294
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 06:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 817F01F219EE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 04:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADF112AAE6;
	Wed,  5 Jun 2024 04:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KdZxNjXX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812125777;
	Wed,  5 Jun 2024 04:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717560762; cv=fail; b=dkT4wOKvQnDLW7X6/QDYxh4ZRyQyz2a09WIKaRYlTjzr0HeIcPBcBFZlDKV8sIY+0vWIaW7aaaMJm5Zmw6kzD17HzQZuFmTPO0TxOADl/GFXG5N2hAAoscuQZHNKHFy4FmRhQU/Fm+OOTcbJIdH0aPD/u9vzZueQ6p5I7uQosh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717560762; c=relaxed/simple;
	bh=Er71aFPsfGh9ClFQaD+Uf5GaILOBUCg5d62SzO8BeEM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qx8tpKlzw5JKMug1onlvabGa0d+SNoT0tkOU4IaH5wgrSGPPikFYAwvrpEUwPLyIZO/3K+vLX0fu52CnkyMt15vww0B/w8Y8Ytwf7KvSPgc8amgg0B/dpsNNvmvBaFtr1+SqlH0NbCC0HixOPCv1OzrRuEhxP/7HkbSaU79+o3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KdZxNjXX; arc=fail smtp.client-ip=40.107.101.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqEMQlweS6OAHdM+Gy9m/8u7ptjb/niAOv0IslT4cWjXuKAAoz2wMliRCkDAmofU5Y6/dHsFWrYQwge+Frz0dhuoYPZzbefoiu66US50TSdJ9K5B0A3ONPSCao2gvWAE9SgnRpFMw6KHhGuLlOc+RxVa7OAx0p74S/MtmF51nFMTtkn0iEscNSloH3sX7dV4pG9pgzawR26XVkQ2r/F5sMinLNW3VIaYDwIDjySI4TLE0qZXr5TBeJM7ygHsoLvzWz45/5HEB14UqoXRwWHT4hWMEjOeXcMt4m+Up6DcVQW6vsTyD1jAPWHwvh2NVl84h4JHAzsxor9/IRxLdKvG1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmrpebCxK6K9Xc7pkKceCJWJb6VWFIqVtHDHUKT/EC4=;
 b=MMipPMXSVQWQT5FO3PZuMHSuRjVwD1/wUQwGe5/cq+tWAsd4ZP6ks1L/Q8d2oP/DVOXJeT0G+AAilSPR9aNrZDnhbETB2y57SsLOeD5+s+u+ZXoC+uCgVLD8xaEDLBRg/6sw3JrFqfIT6iVGLo5nl0txu4KIcW5Os4EajgDbVkffoLUbgo0pxoIniPYqs2e/9t507IsGYiuephlVkdZ6WZGLYVtR06R3QkIZ/hcoev78oufTP4N/WxGtMMZAjsY6J0Tpc7LO1krKZgOJ2Nf7AXrZ0YMKiF3ydQYTRLqeFtqRgD0SrqT0nz3CDrhuk21OTLJS3DRnIqYrIcE8Slh+xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmrpebCxK6K9Xc7pkKceCJWJb6VWFIqVtHDHUKT/EC4=;
 b=KdZxNjXX0JC85mVz41xjE4CJ6jodwusGGp58M63r6BFIqDBdfCinsPVJwaOata898rEEccekZRsREv8jA/yF9HMnY+9ct31d8UQYQoWsJZBUoo62tFxZd9kJXbMcRuvOmhWiTvGnTqxDg+3ZCSQhTnCsq+8xV8Y+4chS0Wa8VFE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.31; Wed, 5 Jun 2024 04:12:38 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%3]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 04:12:35 +0000
Message-ID: <07bb7d6a-f06d-7787-f76a-56a78cfb54e9@amd.com>
Date: Wed, 5 Jun 2024 09:42:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] KVM: SEV-ES: Fix svm_get_msr()/svm_set_msr() for
 KVM_SEV_ES_INIT guests
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Ravi Bangoria <ravi.bangoria@amd.com>, Srikanth Aithal <sraithal@amd.com>
References: <20240604233510.764949-1-michael.roth@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240604233510.764949-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0012.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::24) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 326b3c0a-adf1-4528-935a-08dc8515ba13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enVvOFcwUllpOUkzL2VSS05qZFJqWTFiaU9tdzRUQThZUXQ5dm5CZWFiNVVS?=
 =?utf-8?B?ZW0vZnc0U0cyczdjYzBOeXc0eENSMEE2ZEN5UFRBcW9aL1F5L2dHNm50ZXZk?=
 =?utf-8?B?bGJWMVZndkIyRmpTUGdKazUvQXUwaXhWV0xnN1RybVFZMVI0azBsY2VMci8y?=
 =?utf-8?B?Mm1IQlp5K05lRUJTQ0ZZY3c1M2NlL2QyM29SanZ1OGgvSkdqT2pmMjRRQ0J0?=
 =?utf-8?B?emtKNGtqQ0NQNHptalluK2FMVGw4clRRUmExMmNITmdPOWZVRVNybGJlOHRH?=
 =?utf-8?B?RUh4aXZzZ25acUZFTUZtU2hWZXg2ZEZPaS81OHVIY1VoZnBKMEYvL2tRUzlv?=
 =?utf-8?B?NSt0ZnRkOVBUcHBrT0E4T3JNVFJDdWF5Y2dlSVV0UlpJU3NvZWErSHN3OGpt?=
 =?utf-8?B?dXo2b2J6dysxS1hZNXBUMWNzUDl2UmR2bzR2MU03UlVJYWlUQzRmeG0vRTBM?=
 =?utf-8?B?Z0FCd2dmUG1samV5cnVkRWtpUHlOWU90YUQzd09Mb29raUVha3l0bi9Jc2hv?=
 =?utf-8?B?UmgvdFN0R01vc1E5UlV0ZDY4V1BhRllwY1FwbWJvUHpRdWVCMXRVdTZaZkhh?=
 =?utf-8?B?emFINnlOanlBQk5iZHJOeUFMSmpXbklzL2srYld5TW41THdWckVKbjBmRGtJ?=
 =?utf-8?B?RXorR0tweVZ1TEdyVTN5SUg3TGZoWTZWbWxnZ1B5VzY2T3VJcjFQSDdKamRh?=
 =?utf-8?B?QjFKODlRL1ovNGxSaTVtc3RpYnpvbWV1WWRURGtWcFlEemh0U2ZIdFh5aXdH?=
 =?utf-8?B?YklRTmxKS1g3RzNjYTlVdlo0a3I2djZUTjRZcUhxWnR3anhJR1NPQmJLc1RV?=
 =?utf-8?B?K203a3MveUhNRlZTZ25zb09vVkxRdFE0bmFNS2kxSUwzeWNwcVRjaXNxUGho?=
 =?utf-8?B?TGloMWJqQ2xnS01QS3BMa25DRGFSQVVmVUtmVnFVNlVBMG56amhSLy9JYTE0?=
 =?utf-8?B?ektiUlM4M2NDRExRNFcrTWp3TWFxKzBIWVhJWldYRk93VHMzUk1vZDluWVRP?=
 =?utf-8?B?eFdXd21QWHQwd3NBb2NxLyt4ekFuZ25iWi9iQ3Njb1E5TTRCTFdsbTZIWEd3?=
 =?utf-8?B?TTdKbWs2a09xanFnV2toc3UwS0pqNTJpSi9wdEJ4cmhiUzhEd3hLdVU0ZkJT?=
 =?utf-8?B?SCtUbXB2TVJsRXA1Y2EzcmI3eFhHQzZHOVFTY3V4UVNPOWpXbS9Fa3BNb1RR?=
 =?utf-8?B?SkV2VDVVWHRqTHEvaTR2VkVORkhYM29zUVpwWDZkWDB3d01LRUhOVFU4VFJQ?=
 =?utf-8?B?NU5vUGFaUS9TVy9YWlZuVGhOMGRzalZDUU9jcktUbTZYd1puYk9QT1hiWkV4?=
 =?utf-8?B?UEFDa09QWnk1UXM4Sjd2TDBMRXpzUHEvWkZzWkc3VmVha1BBYWpqOW1EbVRq?=
 =?utf-8?B?c083b0ZtT2kxQ0JNZU9vVGUxSVBZVnRqdVU1bXNIWlF3UTFsa1VGaWJTY2RD?=
 =?utf-8?B?MmZHQkJQalJsalprc01zTEdLSEV4Wmgzanl1emswblB3K1NiejBGMm5pVS9O?=
 =?utf-8?B?ZTl2L1FpK01YZmN1L3ppWXQ0UjFQTXJvVTc5aklaNGRhY2pyK1pENER6ekQ5?=
 =?utf-8?B?WTJJUmM4eXJiL0hab3h5bHdJWWdTd3oxcFd2MDlLZ0pJWXdvVXJicmVMRzlk?=
 =?utf-8?Q?YqZPWQYpN4KVNUmlF0p8Xp+ryULqT1gTLHNRhYWZ7E8Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFJ0TjF4UTB2ZlVlN2NBMWdKN2s2VUM2cDllbEd5T3F1cEhRTFZuOGZFeUV3?=
 =?utf-8?B?d3k4WVdBeTJ0enFmbmlJWUhQVHRSVy9vczIzaHdOaVVwTVUzUTRUSlBMR2tW?=
 =?utf-8?B?WHJMS2FyVzJ1M3ZjUHl3VXBFOHkyTWZJcjV5endiSmM2LzZwR0JkOFJiNFVG?=
 =?utf-8?B?T3FybnhuMVF6RldTdmlYYzlCUVlzYzUvNEI0ZVg2aDFiT2JZR1VGYzkxWW0x?=
 =?utf-8?B?ZG5pSUYxbmc3U3JWOXA2NnF5Z041VHNMTThHd0UrTzYzWXFTeENMZmN6bUIx?=
 =?utf-8?B?NmExTnJiQVQ1WUV4K0dUbkFaRTUxMkMwbG9ZRFpYSTdnQmdFdkl4aXBVeW5G?=
 =?utf-8?B?cUV3ODN0TDFpck5MOTAzdEhwN3VhWWpCVnJmUVNIZjVYZCtQZVhWeHR4My92?=
 =?utf-8?B?WmdzNFhQZHRzQ0VIdWx2TDhrSGlqNkJSaDJSa0M0aFlxMFNRVFg5N0kvL1g1?=
 =?utf-8?B?eVNoZ2xiUDZBVmp2eGVicFkxTW9EUDNMT3JuMDJTQ3FQOEZ1OVVtTENOc1NK?=
 =?utf-8?B?akJuOTg4czFZdVZGbmNNNnVhSllGUStaWGJ1eWN5djZuNVp3WURBWFNwNkVw?=
 =?utf-8?B?ekh5UjR6N0NzcVNkKzU5ZnpRZVR3cW9oRzIyRS9tT3BMZk5LWlJFVDQwTy9G?=
 =?utf-8?B?bDVEWjk5VGdqSkhkenFaL1pHckxGUEoyUFhsdVducWlRRXVQZGRWZFdpWk0w?=
 =?utf-8?B?SzFMamZZeTkrNXREZGx4a2FVUnkyUmlQdUhHaFlIQmd3WVNnN1k0bWQvWGUx?=
 =?utf-8?B?L0ltcTVxT09IcGpEOTR0LzF2amtua01QTzZ2bXBjZHFFaisxRkdPRVhFU3Fy?=
 =?utf-8?B?Nnh6UVlPRGJJMG1LbnVsaVJ2eldLRWF0eDFMamRua1hLODdJdFl6YmczeXY1?=
 =?utf-8?B?VUd2UGtMMEdoUnR3REdCNDhJZXJic0dYNDFJcWQyNkJ5UUpyVXhGbittRjcw?=
 =?utf-8?B?bnBQQVJIa2YyU3NZRnNTcG9uaU9HZ0c5c1BNVUtNVlVDSHd0QnhTUkxIVjN6?=
 =?utf-8?B?Q3o0VE4zUGI5TXIxU1dNWlFpQW9ydHVuTXJCSitTTlJITXpXZDVjZi9QSlJm?=
 =?utf-8?B?SHVIOHpHeEc3dURva2x2dE1jMDRkd3dLQnozVXprUk1jN0VuMTV4L3R6a3lY?=
 =?utf-8?B?Wmg3YUJYQkJhYXNSWlBReFhEcVV2Y2NkUjJDYXc5WVFweHFsN1dpN2NGZXYz?=
 =?utf-8?B?OVhwNzFwNXpoeXYrLzlXaUFabEw3QnkxUnJOaXhyUCsxZGg4anIzVnhlU0Yv?=
 =?utf-8?B?WEx0bGdJalVSTXBwenNmQmQ0SXZQa3pqL3NTTGhWSGl1aFRzd3g1UnQ4b3dM?=
 =?utf-8?B?Q3F0V3oxQ2dFendyQXNTdXJtTDZuYnJINTVmamNaMHFmWHRCVndiaDRyb2RT?=
 =?utf-8?B?Q2cwdWNMeTJhNjliU2NKRmdkWnBZTzlycVRqWFRVcDJaczZJK0FiZDdHQzFE?=
 =?utf-8?B?d0o3SmY5VVBsRzJIb3ZZdlFWOGZpUkdNY1RhaXBVam1RVVNkNUd0SjVlK1da?=
 =?utf-8?B?d0xCamJ4cWV3S2FpeXJZdWs5OTlWamFIbWg3NjZETVhuQThOdGtqa2RYZWs1?=
 =?utf-8?B?LzhuTWwyd3BlR0JOeUpJOGJqclZNYnRFenRGMkh2T3VPNHU5N0FBbkhDRHBK?=
 =?utf-8?B?NGZwUlh4M05BVjdGaUFaZ3pHOU1ieDdEeVRnaGpVMzMvSzY1Q1NCQU1rbHgw?=
 =?utf-8?B?NnE5ejhEckFyMFlGOTZPbEpabGxySzZBU0d1cDFKbDhDamxZeitEUndhOGtn?=
 =?utf-8?B?dkZNMXgyV0hXUzR4Tm8remNlSjM2d1hvL2F1ekEvbFRqckJzQzd0b05xQnZQ?=
 =?utf-8?B?YVQ4RUJTc2hQcGZENjZRMVlQcEZSckFsS1hPZCtlMXFTVzgwaFo5c09Rd1Qx?=
 =?utf-8?B?eElZdjFJVGlFRzFYSDRmYy9hc3M4WUxPdkZrSkFudTNyRGhzdkhvd2NHWXNv?=
 =?utf-8?B?T0JQeWxiSVRPcUk0M1JoUnExU0t4WnJzOUc0eVZjd2ZsRkEwbGFCTEhER3ZP?=
 =?utf-8?B?WXFLTVFvbnpnWUNoVmRtWE5ucnpSOTdRVFhvUmNyTU9JNGIrOFdMVXRadTA0?=
 =?utf-8?B?ZC8rTVEyS25mMjF3Um43ZDl0R2JuWkhuMlUwZXZNeHFkRVpqNWxjTmVJekpN?=
 =?utf-8?Q?7LUAolVX6DF1E1ORzNZRzSIYd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 326b3c0a-adf1-4528-935a-08dc8515ba13
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 04:12:34.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bY3lJT7rBoOERIvz0x9AftEMc3TCfKrE6uR5+/t+gMf7kfji9EQfWVXjp6aUsjvA1wY2dzJcIvpwdiHQ+rHtUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395



On 6/5/2024 5:05 AM, Michael Roth wrote:
> With commit 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA
> encryption"), older VMMs like QEMU 9.0 and older will fail when booting
> SEV-ES guests with something like the following error:
> 
>   qemu-system-x86_64: error: failed to get MSR 0x174
>   qemu-system-x86_64: ../qemu.git/target/i386/kvm/kvm.c:3950: kvm_get_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> 
> This is because older VMMs that might still call
> svm_get_msr()/svm_set_msr() for SEV-ES guests after guest boot even if
> those interfaces were essentially just noops because of the vCPU state
> being encrypted and stored separately in the VMSA. Now those VMMs will
> get an -EINVAL and generally crash.
> 
> Newer VMMs that are aware of KVM_SEV_INIT2 however are already aware of
> the stricter limitations of what vCPU state can be sync'd during
> guest run-time, so newer QEMU for instance will work both for legacy
> KVM_SEV_ES_INIT interface as well as KVM_SEV_INIT2.
> 
> So when using KVM_SEV_INIT2 it's okay to assume userspace can deal with
> -EINVAL, whereas for legacy KVM_SEV_ES_INIT the kernel might be dealing
> with either an older VMM and so it needs to assume that returning
> -EINVAL might break the VMM.
> 
> Address this by only returning -EINVAL if the guest was started with
> KVM_SEV_INIT2. Otherwise, just silently return.
> 
> Cc: Ravi Bangoria <ravi.bangoria@amd.com>
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Reported-by: Srikanth Aithal <sraithal@amd.com>
> Closes: https://lore.kernel.org/lkml/37usuu4yu4ok7be2hqexhmcyopluuiqj3k266z4gajc2rcj4yo@eujb23qc3zcm/
> Fixes: 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA encryption")
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b252a2732b6f..c58da281f14f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2855,7 +2855,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
>  		msr_info->data = 0;
> -		return -EINVAL;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  	}
>  
>  	switch (msr_info->index) {
> @@ -3010,7 +3010,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	u64 data = msr->data;
>  
>  	if (sev_es_prevent_msr_access(vcpu, msr))
> -		return -EINVAL;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  
>  	switch (ecx) {
>  	case MSR_AMD64_TSC_RATIO:
> 

