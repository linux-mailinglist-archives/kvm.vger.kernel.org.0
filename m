Return-Path: <kvm+bounces-58550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DE0B967A4
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 757AB1882340
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11BF255F31;
	Tue, 23 Sep 2025 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qcPOMfaM"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760A122256B;
	Tue, 23 Sep 2025 15:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639618; cv=fail; b=G4pYZ73XcYOmn/WW12YTCzT5Vh8rvLgvd3em1H4kA2i6+O3HquArXC5OHLYlLro68qyHuovvFsTR0iBjqBnI8fK8iYdjlwykrp8+kmiSBS1zRabANswmqeEhTVXWE18HlDUQYiRxIm0SXJpSy5t+yU8I0EmmUq3wLr4pm9Sj9U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639618; c=relaxed/simple;
	bh=qRMxyI8PubjA3YemyAeGax+A17ypAakenHSDW0f8/fE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TANpGamK8uBXL7abYRreWcHXKf1a8IKFgtWitnymVCUkDDcIziyoZegQS+wZwjDbYIzMt0s6kbOXTEonnuLet2pBiUVBeFPsXL92jhqCgDvluniCndT41bRv0wRyn88OaP9bjpu6R/aKROqNKq/0oShjLC7KZu7rmQo7UEuKOoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qcPOMfaM; arc=fail smtp.client-ip=40.93.194.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOZ/Sn+s2uP76+KnNM/MmrdqQe+RkuJuJ0QEP+OUkcM2K+zAI2OHPoJD4GEJXNT2RIyOCsoVa4LOFK0oe5hSvVIwYs5jVbScKoDtfnWM/pGstCgVXakXE2oQrxer4WswLXe8U/sndA6FFPtmQuQfpBGWHGmAP7k91VL9sltqQd0FKmsM/5UeSkogWNm84hHI/Dy+/wcYIzeVUpwEFNYu+n4jeKGWi1cmkBeefOTrySerjc6XUvIqkMBOHBAUeo68j0yU7g7JGuYvI1M6yOiTN8oMUGHnZG4JtPxn0YluhGURd2+USoyW5lGH9XFgOka9Yx0zfjbrWoDXDSEWxjU6hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dtl7OMRas/CCRGuuZ+IOqYWml+BCPVafV1Axt79k5eA=;
 b=GcBmXAzoRvGxaTldyw1hcPS7s886cIAsefiEn6Nb8Qe4Vh8xMp8Kxq4SQfSU8eFi+7sVk4d2LgsJqbug5UhpuCfeGn1fzFn+gvwssMMNlWKCzn8hiZX4QpXKgxKmhoRsB5N89dc1ogOo8Flwq5MKlpB85DTQmtLlZKBJrE8ivHBf6sr5by7e/4zb47naUCMJ+FMfRXTNUi5Q/NUUYWJ4RTP/a0gUQcvX7n4kp7r8lZqHnIkibZN+DNMygyYC7eaVG4S3QYF1U78pAov5VF9J/15F8BfV6oMSCY8SF//Wd6HqdlTiW8Kc2pe+Zv52WQX23TAi3I+11phF2PnrYxP1pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtl7OMRas/CCRGuuZ+IOqYWml+BCPVafV1Axt79k5eA=;
 b=qcPOMfaMdkkr+o4kQGaJ0d7F00KsKTdCZatIaNuuWUC+qKX2EVufrbm6wM7bgPTciaagFiZiThlhocaa7v2Cf1soxI+0uVIwTUXj5/NbSzoguYh+hf0lQCFmrpCBV0nrbcGvkBnxMdiuGUaP1/mGcGfvcqrrAjwSLKeZUDyTd10=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB6819.namprd12.prod.outlook.com (2603:10b6:510:1ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 15:00:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:00:11 +0000
Message-ID: <712ce306-a910-cc8f-3f1d-4a2523b785fa@amd.com>
Date: Tue, 23 Sep 2025 10:00:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 08/17] KVM: SVM: Do not inject exception for Secure
 AVIC
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-9-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250923050317.205482-9-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:806:24::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: dc481e06-d2df-4cd2-c6f0-08ddfab1e4d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YW5VOWVKbGNQODNLMDJEbkh2UW9OLyt5OUtHS0RUMmVrcnNBajBCeHhrNDVk?=
 =?utf-8?B?Mk9GQlNzeDhrWHpPQnhyZElnMWoxNlY5b2FrZk5yWGp4ek1EUlZZODR4dVlH?=
 =?utf-8?B?NW1qYjU3d2MwSklIejBWZmhpOUJHQmtmSGxZUkFmRTlrR0VDS3RRcHQvZCtn?=
 =?utf-8?B?ZjlHb0FFbzVxMUhpdlFxQVp0RndWT3FnT1BBWTN2TXhDRTAvWTNqTWs3M3JW?=
 =?utf-8?B?c28xWVc4SDVFeitrcEJWdDZ2aXpPVHRDM1ArWThubDJDTU9XU0tEU2lycjBS?=
 =?utf-8?B?NzY3K09MU3Jza005TlM1elM5TXBzNjdqRWdJOGlrWkk1M2dFWG5yTmJWKzlx?=
 =?utf-8?B?dHpsMWxoQktnbnBuaTFkWXRsNTJIOHdsczVQYnNKTE5RWk1kK1Nsei9ab096?=
 =?utf-8?B?L2FyQ0tWVGh6eFVMK2RHTlJ5VWFQNGxWNWR0VHhoVXh6ZFFWeml0eXhTZ3Fx?=
 =?utf-8?B?UGtxMlhvQS9VYXhCRkwxVXBPLzcxb2c1NWtxcjZNU0RWa1g1ZUtieDVZeEpq?=
 =?utf-8?B?TWRtNUs4OUZIa0hnci9BQjR1MlVqMzlXMVZUdDFyWTVJTUtTQUMrZy9aa3l1?=
 =?utf-8?B?Q1NmNUZnOE1QQXBWNzhtUXI2MmZ1QStHZFVnQ2dmSVJaQUhCQ2U0dVFKVnZ2?=
 =?utf-8?B?ZkpCbExEeTV5VW55U1hkWkdabEZXZnUyVDFNbnU0cDZ3dU4rbGhTdkNPRXBp?=
 =?utf-8?B?QTJkcDA1bzBWclA2UEcwa291Z2lzQjBNZktvOWR6QU5EQWphc2FHRWNCbDd0?=
 =?utf-8?B?Y1p6MkJpa1pRK3U2UXd0cDcxbEd6OUoybG5kWUJXRXVtQW5vVFYvOTVWOGs1?=
 =?utf-8?B?NUNHQUlyNXFJb2RSb3FlNzJITzZOYzd4VUpEUm9QbDJCUjFEVllmS042aXdP?=
 =?utf-8?B?R3YwV1dBU0ZzMDdQVXVFTEtSenAzUEJETnlLdVlWZlRBclFQQWJ5M0RwRk5I?=
 =?utf-8?B?dEFDVkhvc2VDZUo2ODJWbFNHaGxHQXBEK0ZpbWFkdnBsWlRUazI2dDkxYmVW?=
 =?utf-8?B?Y2p0UldVTVp3Y25wRmRkV3c4aDM0dVdsYzJpY2J2c256WmZZR2NaZThaOENJ?=
 =?utf-8?B?VStxZmRZOUE1Y3M0L1JVQ2lpelBsWjZlbENWMGlQMndrdFNaNEQvZ3g2OHg1?=
 =?utf-8?B?Z2R3WnhMQkZQaXd3SUd2MFJiZUxCc0ZKc3JMWlNpaExzNC9vWk5QZEdlQXZV?=
 =?utf-8?B?cUMwbE1QWFIzSnBVVUcwMHNEU09YcXkxVWlCbjVaSCtURnFhQ096Z29CL2dF?=
 =?utf-8?B?eGV3Q0ZRZDVIQXdpalNBM3Y1R1JEellYZDdOSG5pNlFVUk9vSUlzbmpPQ2tF?=
 =?utf-8?B?d2tsOXVWbDVGU0VRSEdlU0l4WC93K1dzbmdnS2xkT0dhL3UrUmtBVkFRTkRS?=
 =?utf-8?B?LzIvdE1OVlltaVVBNW1WL0dXRGlmci9mbUJraDlwRExjNEdzUTd2SjhKeFlF?=
 =?utf-8?B?TmZWRmRkQ1FvTHV5ek9uT0Z3OWxsSTJXOEpqblhDTzArdmdwRUNYalBrTjM1?=
 =?utf-8?B?ek85aUkvME94SUdVKzZVZW5KR2hBbFIvSE41QTNoeXZra0ZuVFNtZUkvSEw5?=
 =?utf-8?B?ejFTN2NLSG9nM0NYU0pNZGZFWjVVOVhHT1FNZ2tweVlFUWsyK2Q0VEJiWFFo?=
 =?utf-8?B?UkRESGdtaW9sN0VpRmFkYVVzQzcydHdtdW5kSTdLUlFEaE5GRDdLSkVmNWJF?=
 =?utf-8?B?UWZObWdicE4xMU9xQ0N4UmZ6VEJ5a0d3YXViNmxhdUV3dlBhOHhEVkY4MGQv?=
 =?utf-8?B?ZVN5NFlYU1pWcndnV2h1YmVvVGR2WE9yM2VpSXAxVmRSTm1iU21USExyMGp5?=
 =?utf-8?B?OU9YbEwzVlFabkpPRFNKVzRYYjZERzlxOENQeTlzNm9tc3MxTjNXR1NLQXFU?=
 =?utf-8?B?WHgzOFNnb09BTlF3bnhlbXEzSXVoN290YnNTeFZPT01ZYnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHVySGlWcXFFekZGNjFYT2w0TERudHN4NXltSXVxckQ2WkcwMHBSUUdxajAz?=
 =?utf-8?B?QUtEZUxHL29memJSVEhMMU4rVjlKMzM1MHFPNUc0citZelJtVWU0dUpNMlV2?=
 =?utf-8?B?QjdVZE9tWUIybDdpR2k3SU9LVEFLanpsS1pDZTFKbEVMc0EwbUxZNVFyaHgy?=
 =?utf-8?B?ckRMVm82aGxCeEJkeDdkYVNrcVpmMFREczZSK1E1b2xqdis2Q25kODE5YU9O?=
 =?utf-8?B?cHlNRElmT25ZYzAwUmMyWmFsOENTK2Z1SzZIUkxBeDhGNUovTGZkVHNhN1NZ?=
 =?utf-8?B?REdEek5pNjJnb1c2a0xmSnJVUFF0amVrUEp0R1BaaHNmQWQxL2pKQndYaHRG?=
 =?utf-8?B?cGVuZWZJUXdwRFIxN0d1L3lIdjZsWUF3cEhpM2pYTjVpRkwxMERIaDdiRGJR?=
 =?utf-8?B?S0VRYUlrT0pQTzNMS1p2N21tTERWR1E0WTlySUxGcjYxb0djQWtMeitzOGpL?=
 =?utf-8?B?K1hhajFidXBXTFJVY2FQdVpzQnlyNTIvQ3ZlKzB1bmR0NEFhcDlVcmdSQVZO?=
 =?utf-8?B?L0xhbGlwOWhsL3NOVUFhb3l2aEhsU1BvZ3lSY3lPU0pKZjZaTWxUMWJFNDlW?=
 =?utf-8?B?dUpTVm1NbXhJME9JUlhJcStnVFNGaXY2MnNxTHNIY3k3WUF1Smh1ZmRtVHFB?=
 =?utf-8?B?ZW5ra2l6c1BQbWY1cklpUURtVXNsczY0WmJPWmZ3cnN1R2I0U3BzR2lHU1dF?=
 =?utf-8?B?ZE1ZblZ2UWhUV0R3QWR0YUhEajR0UzVSUlJrVFIwYUFlV21ZS2RkVXVJTVdP?=
 =?utf-8?B?WXhvL2tyU255U1hSbUhWK25ibGJzSUJ0bmZZQUloYyt6Q3JnWVQ0dHA4NXpU?=
 =?utf-8?B?UnJBTUQrYVNmZjNpNDRGTnhtOEtoZ3NCSmcvMnNDMTZmM3M5YlByZWtsbGJP?=
 =?utf-8?B?b1FOTWw4eWs3V2xkN3krdUZDNTVKeUVjaHoyZjhydDZyNWRIRUVHWmlyNGFw?=
 =?utf-8?B?N0V1TXVvVFYyM2crSVZ6VExPQldjVG9YMVk5dW9yVThhK1AxUGlmbmJGUS91?=
 =?utf-8?B?RCtVeW9wR2hVdEtwR1UyS2ZwdTBjanErUml6WUFFNnRlUnR5RDhJTnNDY3NC?=
 =?utf-8?B?M1FzZCtiaHVlaEVZZ1FOZWxWM256dnZPOGxQckdHajFxQzh3MlFvMEVWM1BI?=
 =?utf-8?B?ZEw3NmlNdG14T3FnUW1tT2JvR1BkeTI1SkZjanpGNDJqUlQwRDd3bXdXQTRI?=
 =?utf-8?B?U1Z6WEdZYXYrd3BGd0NsMFdPTWRITmRVdkI5Tndva0NmSzdiSFNEMHJzSWZP?=
 =?utf-8?B?VURxY2RHTmwrL2lFNlUxZFJjemZYL2JiWURGc2dXV2tHRU9WVU1BL2t6alFR?=
 =?utf-8?B?Q2VuTUxHSkFRUG1vQ1F4STk3YnZ2V0dNRGU1SUpxRmtuRWRVNy9ObTZ3a0JK?=
 =?utf-8?B?dWFZdjExbHEyWFBJK0dFU3o3UVBJak5yTHVrVzVmSXZwZkxUSXN3QkZWWHA5?=
 =?utf-8?B?bzN1bmFzTytTaUJwYy9DeFBxcWJ0VWI1VDlXdmk1UU9menBXbVVxZW90cVJC?=
 =?utf-8?B?NlczeFMzWGJ0Wm1OdG1nbzNETTErTHFtS0VQcVNPbHZxanhMbkFweWE5Q2Vv?=
 =?utf-8?B?RFhkaFkxSDhXNllzVjNoWnVXeGFxQlZwZjhOZzAxeUhGaTVORk4yYUxUMFVu?=
 =?utf-8?B?MTBKVDdRcFhYbXVzL2hHVlNuR1JqNldmMGZlaHVERk50K29kdjY3aHl1ZCtt?=
 =?utf-8?B?MU5hL0ZDTDdFaFhETVFQWUwyVGFWK1h6dzNiV0gzZWo1R204Zitva1Y0ekR3?=
 =?utf-8?B?MksvTi9FR2JtdmExV1Q5azN6WjBsbHU2K1U5WUUvZjJHMWhFMzBaem1CbThF?=
 =?utf-8?B?OG4wcXFoUUhUM1BlT2tsOWJySEdWVlFEbllyWGoySXBpUjVSSW95VlF3ZWV4?=
 =?utf-8?B?dERic0U4UzFJNFJrRGI4N0J3cENMa0lPUzRPS2RHbFpFYWJ5a2dCMGk2d2lt?=
 =?utf-8?B?RDRGcWNSRFhhUU5VeFJrMEFBMEFYM3pTb29QZjliMnJCT0QxY3B3aDRFNFlq?=
 =?utf-8?B?bnl2RkpPZFgyVlIxTnQvSUJoTzM4dmNBZ0JNeGNMZVRuSGZvemN5UUVyUUJ5?=
 =?utf-8?B?SlZBbUZWSXQydHBXZ1pTV3JBc3REQzJMYjhULzU4am4yWlZ2TU5LVkNObG5T?=
 =?utf-8?Q?ioSgEGYtgljIOlJyB1Z7KDZoq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc481e06-d2df-4cd2-c6f0-08ddfab1e4d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:00:11.3804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdALzKAgA33IjRukPqJM9dKMm69WNFIAW/66Q5Slnn9GSqNc4nzum4b08kaoPQkUYs5H1JNlRTsd6wf+pembFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6819

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Secure AVIC does not support injecting exception from the hypervisor.
> Take an early return from svm_inject_exception() for Secure AVIC enabled
> guests.
> 
> Hardware takes care of delivering exceptions initiated by the guest as
> well as re-injecting exceptions initiated by the guest (in case there's
> an intercept before delivering the exception).
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7811a87bc111..fdd612c975ae 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -374,6 +374,9 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
>  	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (sev_savic_active(vcpu->kvm))
> +		return;

A comment above this would be good to have.

Thanks,
Tom

> +
>  	kvm_deliver_exception_payload(vcpu, ex);
>  
>  	if (kvm_exception_is_soft(ex->vector) &&

