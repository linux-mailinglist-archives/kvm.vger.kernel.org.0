Return-Path: <kvm+bounces-53470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE84CB1243F
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 20:46:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C85AE1CE0886
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 18:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3846E254854;
	Fri, 25 Jul 2025 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1Dtd0fVP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFE3111BF;
	Fri, 25 Jul 2025 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753469188; cv=fail; b=iMKgywzRxFH/xcK8aawfHs+f523DLu26Cz9eBMCkfUHAT2EvqAe9e7BF6n+joMc/PmX1Ehts3RF03mPsni3DUwvud+OM1iTYDn3zRaDlvKe62w9/XbMuL15Bphryfx1R+ZCL2Q54z5/9mtaxxZnjOO9HREYG2R7IryQR9lisMEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753469188; c=relaxed/simple;
	bh=WRKcuDfQOKrZ/qX1373coXdL9F3NSSPKBGfVXxFVJyo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NWRVh5ASaVvg7uqYjjpu94TSRC/xtN05Z2aCvri7lnovUonYhiCgrqBqaQn108rjncHioJfxRj7AG9TLizBrVhaA27pjhLYTmec+aga7Mz6zvKI92W//pkBPodI9Jd9n80NBhOOAi21wmDsn4Zf2uRE9bvacFKqhzr7WBWSGIxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1Dtd0fVP; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ipqx2BeLnQBIwQMIfjAQz75EFH4PD/Yi4qn6K1LLRDkyDBtiLXNa9v2setIPp7SIbzNwOVvf1I0jqaezxzJ0+JlfIJRBTDOnKv/72VzeaC5W3P9WhCvtypsXvfMU1opWjxjGO3er71+Q2KLYAHiLp0Usbpmhf8+lZmU4lhcsaaXan2Ss/v+07gbeFfohfNvs9RNNOiJDAA6+rDjJ9k67O/QhqTApIp7asmEqYN9Pmc/mhjdG22qV5qlcVUrAnGrDlnjSHTBd1fSbXJ0SOZGnQKZmdN+c/eJL8H8PASeQisI+9ZExeqyCS8NykAB/cd1QGXzGJ6NTaPw44KokzEWjuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w463DuW0ZckE3r12fldrxT3b1fcLJF6ofaycEZmSPDc=;
 b=CjOPK3XmrjJgE8wExWfRFOGOtO+he0Z26Kam9FbAWc5gvHIhGLgjGhHLfEFqlYx+NMgDwOP7mj5gfnzlmRliagtOi3rhofTfOZiYGA8SzupVdZJaDITCfkmkvRx1TlE+OhQP4MC5RgVtq4LazGleYVsCZ1eUmn6J6vx590seXYBR1cpXXjsIkiOoR1AVuUvfUC5paQ7jHfpGlndvzXyEQ+yaeGc5drsws9IwyTd966wDV+bSfTD3iKN2akwyXYL+nRAQRFTRld5o7hjxJaelnL2+CoXxAiWVKHw2WRN7/JKghoABhVWPZWN7kjS0zuQeZ1jeFCEonmybEQnlpAwD6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w463DuW0ZckE3r12fldrxT3b1fcLJF6ofaycEZmSPDc=;
 b=1Dtd0fVPVvN1kCQxz0Y1YlpZLLFpK7a7/kO0n7WjRgrI8PZl2b95jV14RiljEP0hwsjqqjpk41bu172jIHRKg4FK89r1R1HJTpKcv54l64NnddL9xQuhBDTlQt7OWgA2TFDwCizYmqbZv/bMHHIK1t9nG768e+Wjba6ScqgOmsQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB5903.namprd12.prod.outlook.com (2603:10b6:510:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 18:46:23 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 18:46:23 +0000
Message-ID: <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
Date: Fri, 25 Jul 2025 13:46:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Kim Phillips <kim.phillips@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: 0869226b-ef40-4980-bb96-08ddcbab8d5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXFIRGtpV0Focm9BSWlMS1Q0Rm55VXg5dC9Wc3JzZitwRUtFVzlIeTdaMkJX?=
 =?utf-8?B?UTVWdndPelp0L201N3Y0Z0ZOYk1NV1M1N0s0ajFvU3pxQ1M0WUxXRzNrenB5?=
 =?utf-8?B?L21mV1ppdlNwT1d0UnBJSDZqK0ZZU3NCbFRjL3NGalhweUpqMmRYY25CSklq?=
 =?utf-8?B?aTBnWCtVWkFhNWdBbXFhZXlxU1dCWTI2N1dXM2UySDArV1JoKzhwQTA1ekZ2?=
 =?utf-8?B?eXZySGZpd2FPRVpiejAwVnEyZmFuUjFPMGVDOHBFWGlqdTRTOEpVWE5jOVQ5?=
 =?utf-8?B?NklZVUo2cG5LRnFxYkN4NmhOU1dldFFpbHhMcUt6ZVo0V0VFRWNHZzhwNzFz?=
 =?utf-8?B?V1hkUVA3MUNRRytLMjFXelAwanNlY25pTnlQckFyaERuZVc0bkhBZ2xvSXNt?=
 =?utf-8?B?UlRrMlhDUHpncmdHMzMxOG9SWEVLUUZLNkt1SVlKUCs5ZUhSZmtqTWl5Sm1s?=
 =?utf-8?B?dmxXNFlYYUVyUktKYjVoVFVRWmVDQ09WMmNjbmRZQ2hRS2xZN01qemdDVGhQ?=
 =?utf-8?B?c2d0QXdVU1BST2RFOU5lZFZDNXMrMHB4SEcrM1R4VEQzVktvM2JQa2s3UkhF?=
 =?utf-8?B?WlJ1b1UwS1FoQ2MraU9ieU9iTUt2eWVQaHBDcG5oZ1dxbHg2M2t5OWR0ZHlH?=
 =?utf-8?B?VkJ3WWUzUW5ZS00ySUhlYk5Kb1pMbmJ2S1I0QjdUQ2dtbE9aVXdpaFE5dTZK?=
 =?utf-8?B?T3haR0xacGJNOHg1QzNIRU80NnRMVFNtWG85M0pmU2tBYkM3bXlyNHJqR2pJ?=
 =?utf-8?B?dFlGY09uMTgrOXpOdG9jWHdTeEt2bHU0a25TUERRdnVLRGg3Zmx1U0s1aW5Z?=
 =?utf-8?B?RG5SUWdwMm1MdlVlS2c4MW8xL3hUTU1vTnBDRVB0TTlJRDJ2VElycHhiY3l3?=
 =?utf-8?B?Yk5DcEh6TEcrUXlPK0JTYmxMWU1RNU01aEk3ckd2V05tYy9KRlZrSW1MUG9X?=
 =?utf-8?B?cU44SkFvWXFlcFBRdjdUaUdjWm9IMktZNzVQcUpRRVMzN0U5L2dtNmpwZHZL?=
 =?utf-8?B?NDlNUUx6ZFRFU3RjWkFUMEs3aFA5NWxnR0VKQ0FsQ0czUWNSV1lmV0dJMXNU?=
 =?utf-8?B?MitSTStZMVc1TGNXand3aEVLRy80b2lub00yWGNzRERhUDlUdTBVY0kvQ2tE?=
 =?utf-8?B?alFmT3FTNVJBY2hMMzFvdXRuVGNTcThXSFl3M1BvTTNoQmNsRTZWSUgrK2pX?=
 =?utf-8?B?WXdkaUFpWWROUHl5Y3czc2FJOXUvQURwdHlFOTNqVE8zSjd6TmtIK0lmMjRx?=
 =?utf-8?B?MlloUTE2Wnh5RlFMUXhMbHpRZWlOWVdVcDVoVEw0UnJhYjFLVDNHV0lheUFm?=
 =?utf-8?B?M1dtdjM3ZTVsVzdRazRLeFRDaUZmUGZIVm9hOWdPZUFWcVJMQzkwdkRGM0FQ?=
 =?utf-8?B?UHhIRVlrYjVjYmN1SVlRWW5IbFFBclRrM2FRbFJIZXR6aFkrQ3BaaG9tNm9F?=
 =?utf-8?B?RlZWSXY2THBNTEw1V0NScTJuR21RN0VuVm1ENld0U1JGNUN4VXF6em0xbmZq?=
 =?utf-8?B?QmNSUWgwTEgxNURjU1dQT3lOdVdPb0lCRmR5MUdiSE9ONnZQY0t3b3dpWGJK?=
 =?utf-8?B?MyttS2EzOU1EeC9pZkE5STVnQnhGcXdBQTBVZ2NycndQQjhrNkhxNWpkVjAv?=
 =?utf-8?B?N1lLMUtrNWczakNDVXl2SHFvU3htWFFzdVdxRmJERlppTmZDaGM5dnlhSi81?=
 =?utf-8?B?a3FPVjNDZHd6VWhXSVUzM2lmZjlqamZVc3ZrZy9EYlhEcDNRSlVwbkV1VWFr?=
 =?utf-8?B?NFk5WGZXRU5NaUhHSklicVh6aWtRMzAyemV5cWZvSHFreUg1cS9GYmJvZmVI?=
 =?utf-8?B?UTBhSzlMZjNla091ZXFWRE0zZnlZU0ROTVJjWlo5Y3VwbWNIb0kzMEp5QkQ4?=
 =?utf-8?B?czJmTU5TSjhoRFIvWU1UWkJkbTJFTUdMWHRQbjluWmpQaXNXTmdSK0RsSUZF?=
 =?utf-8?B?cWF6MyszOE1iSkhmeUI0LzlMbysxZ1BhVHh5VU92UWNIaDlENHNCQkUwdE1G?=
 =?utf-8?B?a3F3dTVVbldRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFBOYU02UWkwTWluTzB0aU1JMERYRTZIUE10YjBxUVR6SG9QTC9KNS9aT3N1?=
 =?utf-8?B?K1NkWUlWWGU3Sjd1NjN6dHFsMkl0UnZoTllVTVlYNm00dmhyY3BkL1IyUTZS?=
 =?utf-8?B?NU1Mbk1FOW1WWHFqa3JYZTJxcmpLMDFsN2pRVEo2VXU0QXcvY09pWm9oOFdT?=
 =?utf-8?B?SCsvVlZMdnpJbUx1QXVMREUxM1NlL2JDUVg4QVYweUJzSU4zSVRUTGFITVM5?=
 =?utf-8?B?N3l5MVNBRDZNVE5WRlE5TWFpL1lGT0NONms4ZC9nd3picmVIL3o1ZEdEQTJQ?=
 =?utf-8?B?SnpyUVFOYUpJb2lCMWpVckh6TUp1U2lBVy85RWt1bk9GbDJJMFVXTDhCajZ3?=
 =?utf-8?B?ckVSZUN2aGlqdk1wYnZBdWNpcGVMMnZQK0VEVGJrVkdwSFNJY3hneFUvWTZk?=
 =?utf-8?B?MDRGNnh2T2d5cDJuNnZGVkwvSWpEeEo2RFZ6dldqdWJGdENsM1RiYVZBbTNX?=
 =?utf-8?B?L3FEMmZGQnIxYVFWTkl2czVLUjBpM0dJNVQ1SGpnTThmd1RFbGVMUkQvWjQv?=
 =?utf-8?B?a0Jyc0grb0YyYklDWlNjVXBwbzQrZVBtSUdmR1RKSUhMSUdHRmdnOHZEZVh0?=
 =?utf-8?B?UHdDSlYyUFRPU2RQUUxvWkhnOTZPcFYrMXdOR0V6QzQvMGI0Z0sxaFNVQ01T?=
 =?utf-8?B?UktmY1puZ2tFdUZTRmV0SWFmOU5TOFpEcjA1R08vdVRLcCtLVnpjdjc1NmdK?=
 =?utf-8?B?THdseEhSZHFkcjlzRm9xZ2cxVi84RG5FelMzNlpXT2c0cjF6eVJqK1BXcVNR?=
 =?utf-8?B?Z1VITCs5OE8xWmNjekJHQWtNSmh6c0xOMEtkZEZDbFduOSt0aCtFWXgzcExx?=
 =?utf-8?B?SXBxUmFyVytaNjhyNThNOUNVOHFOSnVpZEFSVnNpOWMxQ1JNQXBCc3F2cDFB?=
 =?utf-8?B?NlhkcWcrM3gxVVQxbmNRZGFobUVZOXg1dWtpY091SGRBQ0w2OUh3NUdPSkt4?=
 =?utf-8?B?MkdRbXdaQzVhZXNQY2xUUmxSN1l3SGUxRjIwODNYRzh5VmtqekkxbUNSTWI1?=
 =?utf-8?B?YjgycTdYSkhLLzgyako2YTBMekVLMkRjdVprT3M2UDltV3A1amwvMjdJS2Iv?=
 =?utf-8?B?Nmhxd3g4dXlNUTV3WnB2QWdJOHNpbjlhZDlKQVlUa0dmbTJ4RXEyVGlNaFBB?=
 =?utf-8?B?aXdyQ3U1YUdIS1lqQkhXdDVaL1ZnMDNvQWdKOXBEYi9vV3J2Wi9ZOVFON0tO?=
 =?utf-8?B?dnRXWlFhOHJIU1F6UTNXMDJkczcvTnJiUXA1dlMwN2dNUlF6OWRLZ0JsMUEx?=
 =?utf-8?B?b3YxVVNBbWV5SEdva0pWQXZ2ZWF2MUlKUGtDUWpheDl2R2Q4Q2RUQjBENnYx?=
 =?utf-8?B?QkJLdkVBVnVzTDFhblRqT2VHbjlZTEJoUGVVK3hhcXlrbU9qTElFUVF1VWNr?=
 =?utf-8?B?djV5NGYrdHdCcHZYVVFkdUllVi93TFYzQzRuY3I1MmxnY0VYMnhtR0lkNjRa?=
 =?utf-8?B?cnlPVCsybFJ2aHZ4NWV5Qi9YVTJ0YlR0SDdaeHQ3eC8vL1d4RHh3cFpJd2lF?=
 =?utf-8?B?MjZEeUsyYW10QUR6N21DQkNVLzlUSEpNL01BYzFtQ3FzM0NMcjFpMVd6TXBn?=
 =?utf-8?B?N1ArQk8wQTJBTy9HWlZNYXZUSzFBYzF1bEpQQk40c3dOQy85NFBwd3BHL2xO?=
 =?utf-8?B?ZzFlQThyWDRxTkhabTI3VTlKOU1BcFNCTGRHM0NVclBqcXFqS1Y1b0tpNlBu?=
 =?utf-8?B?SmU3Z3F0NVBYZzNwaXVIcGNPall0RUY4dzdiV2NwZjJIVkMyY3B6dUVGc1Fr?=
 =?utf-8?B?aVBUM2lIellacENSbWZYaG9nYVNNL2VlU05MZEhjVDZnSVVReURXZUhSWkRj?=
 =?utf-8?B?VEhqOGJrbGZtWHAwZzZtM1NGMXVpd1orMmpISGZRWnNscThpSm5wdmFUQnd5?=
 =?utf-8?B?aHUzZU5PaW0vT1k1Yi83b2ZNTjhUUHpoUzlZc0dyQm9veEtmTVRyUSs5V0wv?=
 =?utf-8?B?ck1Ob0V5MVBvU2ZkMnd2eGNzam5nSllSZW1wclJDOGxudWFuZFc0bUtyTkE1?=
 =?utf-8?B?aUc4czVVdlBVeVlQYUpFYW9wdmtXYzNrb1JyS0JqeHgwRHhTUG5DbmhpYXVC?=
 =?utf-8?B?YnMzWEVtaVBBdjMzaTZPdWc1MjdBUG1QbFpNQXRTaGRPU05WVjZ4TzE2c1Nt?=
 =?utf-8?Q?jZL2j6WCK39oZOP5N5EP3aKjW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0869226b-ef40-4980-bb96-08ddcbab8d5f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 18:46:23.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qvddy3ZlR68BQZjVuEV5hj7FyHkmVHrxrOgy/2qp/Jy4fmW/i5Bj+Ng3U/WOwBMZCs3hIe4mE5JWaruGy7HkfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5903



On 7/25/2025 1:28 PM, Tom Lendacky wrote:
> On 7/25/25 12:58, Kim Phillips wrote:
>> Hi Ashish,
>>
>> For patches 1 through 6 in this series:
>>
>> Reviewed-by: Kim Phillips <kim.phillips@amd.com>
>>
>> For this 7/7 patch, consider making the simplification changes I've supplied
>> in the diff at the bottom of this email: it cuts the number of lines for
>> check_and_enable_sev_snp_ciphertext_hiding() in half.
> 
> Not sure that change works completely... see below.
> 
>>
>> Thanks,
>>
>> Kim
>>
>> On 7/21/25 9:14 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
> 
>>
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7ac0f0f25e68..bd0947360e18 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -59,7 +59,7 @@ static bool sev_es_debug_swap_enabled = true;
>>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>>  static u64 sev_supported_vmsa_features;
>>
>> -static char ciphertext_hiding_asids[16];
>> +static char ciphertext_hiding_asids[10];
>>  module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
>>              sizeof(ciphertext_hiding_asids), 0444);
>>  MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for
>> SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize
>> all available SEV-SNP ASIDs");
>> @@ -2970,42 +2970,22 @@ static bool is_sev_snp_initialized(void)
>>
>>  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>  {
>> -    unsigned int ciphertext_hiding_asid_nr = 0;
>> -
>> -    if (!ciphertext_hiding_asids[0])
>> -        return false;
> 
> If the parameter was never specified
>> -
>> -    if (!sev_is_snp_ciphertext_hiding_supported()) {
>> -        pr_warn("Module parameter ciphertext_hiding_asids specified but
>> ciphertext hiding not supported\n");
>> -        return false;
>> -    }
> 
> Removing this block will create an issue below.
> 
>> -
>> -    if (isdigit(ciphertext_hiding_asids[0])) {
>> -        if (kstrtoint(ciphertext_hiding_asids, 10,
>> &ciphertext_hiding_asid_nr))
>> -            goto invalid_parameter;
>> -
>> -        /* Do sanity check on user-defined ciphertext_hiding_asids */
>> -        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>> -            pr_warn("Module parameter ciphertext_hiding_asids (%u)
>> exceeds or equals minimum SEV ASID (%u)\n",
>> -                ciphertext_hiding_asid_nr, min_sev_asid);
>> -            return false;
>> -        }
>> -    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
>> -        ciphertext_hiding_asid_nr = min_sev_asid - 1;
>> +    if (!strcmp(ciphertext_hiding_asids, "max")) {
>> +        max_snp_asid = min_sev_asid - 1;
>> +        return true;
>>      }

As Tom has already pointed out, we will try enabling ciphertext hiding with SNP_INIT_EX even if ciphertext hiding feature is not supported and enabled.

We do need to make these basic checks, i.e., if the parameter has been specified and if ciphertext hiding feature is supported and enabled, 
before doing any further processing.

Why should we even attempt to do any parameter comparison, parameter conversion or sanity checks if the parameter has not been specified and/or
ciphertext hiding feature itself is not supported and enabled.

I believe this function should be simple and understandable which it is.

Thanks,
Ashish

>>
>> -    if (ciphertext_hiding_asid_nr) {
>> -        max_snp_asid = ciphertext_hiding_asid_nr;
>> -        min_sev_es_asid = max_snp_asid + 1;
>> -        pr_info("SEV-SNP ciphertext hiding enabled\n");
>> -
>> -        return true;
>> +    /* Do sanity check on user-defined ciphertext_hiding_asids */
>> +    if (kstrtoint(ciphertext_hiding_asids,
>> sizeof(ciphertext_hiding_asids), &max_snp_asid) ||
> 
> The second parameter is supposed to be the base, this gets lucky because
> you changed the size of the ciphertext_hiding_asids to 10.
> 
>> +        max_snp_asid >= min_sev_asid ||
>> +        !sev_is_snp_ciphertext_hiding_supported()) {
>> +        pr_warn("ciphertext_hiding not supported, or invalid
>> ciphertext_hiding_asids \"%s\", or !(0 < %u < minimum SEV ASID %u)\n",
>> +            ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
>> +        max_snp_asid = min_sev_asid - 1;
>> +        return false;
>>      }
>>
>> -invalid_parameter:
>> -    pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>> -        ciphertext_hiding_asids);
>> -    return false;
>> +    return true;
>>  }
>>
>>  void __init sev_hardware_setup(void)
>> @@ -3122,8 +3102,11 @@ void __init sev_hardware_setup(void)
>>           * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
>>           * the SEV-SNP ASID starting at 1.
>>           */
>> -        if (check_and_enable_sev_snp_ciphertext_hiding())
>> +        if (check_and_enable_sev_snp_ciphertext_hiding()) {
>> +            pr_info("SEV-SNP ciphertext hiding enabled\n");
>>              init_args.max_snp_asid = max_snp_asid;
>> +            min_sev_es_asid = max_snp_asid + 1;
> 
> If "max" was specified, but ciphertext hiding isn't enabled, you've now
> changed min_sev_es_asid to an incorrect value and will be trying to enable
> ciphertext hiding during initialization.
> 
> Thanks,
> Tom
> 
>> +        }
>>          if (sev_platform_init(&init_args))
>>              sev_supported = sev_es_supported = sev_snp_supported = false;
>>          else if (sev_snp_supported)
>>
> 


