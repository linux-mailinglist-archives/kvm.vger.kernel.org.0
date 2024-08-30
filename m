Return-Path: <kvm+bounces-25564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F56966B27
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 23:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70C13285623
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 21:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5971C1724;
	Fri, 30 Aug 2024 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QPrasUig"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C781BB6A4;
	Fri, 30 Aug 2024 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725052123; cv=fail; b=smy100KqN2O+Ab9uTAF85+Toc1xqLOAaQULl8pvXXPiF/f1+h3joDuF29F5u6yT9F7VAL8c4/mqqkwBoMcbvZfEWQZ84YtnyR6ZSL+nvKF9+6hOEvloFFzMWYEbVH7ZjyWxLjQ0vU+aXLnPi6VjHj93NuDzvL6dZC1F/oAFD7mE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725052123; c=relaxed/simple;
	bh=2enruyY2/Z5nku3t3DBeLbdDxBoIrFpRHQu5Pp/8MmU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZllCTkGhc7tp1V9aBimIX5IMOT79VLfSSC3cZbzuYwWtK6Wa5/pDC2SVoWf2s4n8Wvs1nWmgflY2o9O6UF2wIfdetnpECK1jybbrBNKNwmVMRyVwSGb9DMNC0eUuvdd6EHUZaRQcdfXOPyg7dUV/BzrmN0GH0+qx7ppXTNsRpsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QPrasUig; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xguZk9krCCHi6SG0k1dO9U0E0RXlpojJm1LVzV3pX9R0V4gjkInl6rhVFXOYwUVGK04b6Pk+J3e45kdtX/q16u3yqr12/0v06nTUfuWAlwTgTCe7judxKc6gVG5FbeH0ezZ9kG7HO28X34+sCIKfBmdFdD69AsI7GbNdRKtFXbj8RTJVs8iWGNMMEF+26R7DTGGMbIzU8YrPYz6bj6Ee8gtusDvM+CXzgHM9mSsNADc9zXfIMKptOQzn6ZYP3UIBlLAPm1Cjxm1v1br79I8g1L78lB1q0rDwRfZYhcDRqM5mwUodjmBCp5spTzgRCc9dJ9jWl4QG/Wp8HRT5F4qWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwssaCNSF77lNuQ2iL9njrnfUS1PfSU8rPD69iks+bM=;
 b=tFXNkeWaS7tWDEP7JyJlq40SzmvEuSd3mr6cTFYVwxd9XIwwEhZtPDsGSpD+zPeN5Kyi2nl1fTCh2geZruysZvM5qtyZ4MOyYcA5h5GFyYrnc52rYGh7bSnksy4KwIxZCtZhFiA1dGR5akUrIpRZEyBkuMj+8n8e8EgqDmkDNs5sR7BCGThM24WzRFTRWa02yH26awfjEgqaUR0MW+Vh+hrem+c4cvGKfCkmZNrLlIB9G75VMIKswuZ8dv/ISceSebQj7h0qPi0qEevK7E6uvw7zqt+MnLB3AyymkoWMdh4Jl7O4vN4yhVklDSSKbIriiwGepn1WNM56+IZm8LdkcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwssaCNSF77lNuQ2iL9njrnfUS1PfSU8rPD69iks+bM=;
 b=QPrasUigrQsVmD96H3owm0al0uJoY5ZSYy4fDUflQDW+uH2MA4PVzW8VPAyJcSspeOdJ8Bpibt6Ooknh3bcKtgXeIWsUMBxgYMFGxg0aLSKm8F0IIrTOBSYeQKkg1qGbYReddshdJ3Fv/AK7LYwgvGGY8st0U4N1/+dfWE2x9UQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6141.namprd12.prod.outlook.com (2603:10b6:8:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Fri, 30 Aug
 2024 21:08:38 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%6]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 21:08:38 +0000
Message-ID: <26da9c1f-3cb6-45a5-b4df-1e4838057ea4@amd.com>
Date: Fri, 30 Aug 2024 16:08:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>
Cc: pbonzini@redhat.com, dave.hansen@linux.intel.com, tglx@linutronix.de,
 mingo@redhat.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, thomas.lendacky@amd.com,
 michael.roth@amd.com, kexec@lists.infradead.org, linux-coco@lists.linux.dev
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
 <87475131-856C-44DC-A27A-84648294F094@alien8.de>
 <ZtCKqD_gc6wnqu-P@google.com> <155cb321-a169-4a56-b0ac-940676c1e9ee@amd.com>
In-Reply-To: <155cb321-a169-4a56-b0ac-940676c1e9ee@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::22) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a95bc0a-addb-4475-f424-08dcc937eb20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3JkdzZhQ2FacmxoczU0R0M4Ly9MZXoyajNUU3AvRVZRTkFwSG9ENGFkblB4?=
 =?utf-8?B?MmFuRnhmU3BiWXIzNjlPSTZQL3ZUeXdmQnpqTXBUc1NnUmVZV2FlSm1hUkpW?=
 =?utf-8?B?NDRnT3RyRDZFMktnNWJQYUpVZXJESzVmdUE5VHRIUGR2ekhUTk1LejRIQ0JG?=
 =?utf-8?B?RThvTnh1bEpLSmFnRGE2Z2FlMldvUVQxZzMvMysrb1pjcVBieU9JQWEyRVY1?=
 =?utf-8?B?YytyU3Q3QnoxRDBTS1I3S1JWYlZyaHRLOVlVemNJKytNVCttd2RxR25OUFA3?=
 =?utf-8?B?bHNCdmEvbWVGVFR1TVhlZTlxa0RybUQ3ZyswejhjWStVNjFqays2b2VNOEJP?=
 =?utf-8?B?ZXVpMWRFeXh2WVJRWUVFbGtRSUhHSFZDRFJtWlNWUk5jU0ZMWXVsK3ZMS1RI?=
 =?utf-8?B?aGJNRVVQZFE4L0cvTm9UL0t5WXgvN0ltYjZXdWlSZnhVTFljSFlsb1ZpZHdM?=
 =?utf-8?B?QnVaWUF0SFhzcHlyOGZaMEU4QzdhamJIZWpzdjdiajZFc0ZPV2NvdG1OTTlq?=
 =?utf-8?B?bHVndWxhWkdJOXM3d1loaTBUTzl4TnFsdXJhUzVmTy94TEZPLytkYVNkU05n?=
 =?utf-8?B?YnZka2ZwME5PTmlTNTlIc0xBTHIvckFjVGphdERucG9HT0ZTZCtxS0RueGlK?=
 =?utf-8?B?TVpzbWxOS0NqRFJQMFgwaVhiUHN6UlFzU3hyVlF5ZXZHcjc3dTRFQjhBRld0?=
 =?utf-8?B?ZVBQbVVqVGtxZkVtdVY3Nlk0SmVRYWRocjdPVkd3MithcXlDRXljWGNkanR3?=
 =?utf-8?B?NXNuc1k5Q1RMM2Ewb1gvMkNSRmhVa0FTVDE4VjZUK2NGNkVJUjV6Z3VRWEpM?=
 =?utf-8?B?alluMnlub2x3UE9laHdrc0QxYjdrK3ppNWxIKzVFWUdsV0FKNFJYbm9IZTNY?=
 =?utf-8?B?eTdReWRnR1pkZVRVSm93OFFJczBCNlZhR2VESlhSbUFkN3EySXFnaHc2WTZj?=
 =?utf-8?B?UW5uRXh2RGtMaTZOUjdGZG4zU0NDVzNSNEM1V2JBZStvemxhSE5WQXd1aFZL?=
 =?utf-8?B?YUpYN3Y2NEhrRFBjbDkyRjRiVTdJZzNsblVjMkFpc0NWdnllN2ZwZXRkbE5C?=
 =?utf-8?B?a2w2dlZDbVpNdWhKZEJlMU50aUNuTE5hRVRWV0taNG82VXM2bk01UWY3WURa?=
 =?utf-8?B?Z2pjSjBxTjJOWG1PRm9vTXFRUDI5RnZ1WjhiOTNHeHFoLzhXZnJUc1Rwd0hV?=
 =?utf-8?B?WHJnc2VMekJoN0tQeFhXY2JSTWVyZzFEK2p1NVhzZllZNjVMTnlWU21BblZT?=
 =?utf-8?B?a2NTdlBmakFyZmZLVFNycjQ0a2JlM294S2c1eU5aMVJIdXM3QlpBQTNjMHBS?=
 =?utf-8?B?NXU5Ym1pMUp1RzF1dEd3eWNGSmxtNVhRV2g0ZnBuZUFoOVpHYjA4NVR1ejY5?=
 =?utf-8?B?RXRtS1g3MElUeWticzh3TzMwdDVJbWtHUHZhZjFwVGE2WW9WbVcxblhjS2VG?=
 =?utf-8?B?YXNQWmtFYjkyMlZyL2RWYUpGOGhRT2IrZUpJM1doc3RTcWIrR1o3d092ZnpF?=
 =?utf-8?B?R2l4RVp3RDYrdWNhL21UU2wzQUZDOU5LaHNLMUowMk92bVR2NVBGNDQ0VEdO?=
 =?utf-8?B?UjZybnljMlhDc3BrNG8wVnNDQmxPTjBSWmtQc3V2dEFyNkR0WU50RWlhc0NR?=
 =?utf-8?B?K0dERHNEanV1dW1vV1pEQnRPT3YzWlpmOHA2Tm1DMGpZY2NrbU9wUHZjWVBy?=
 =?utf-8?B?T0c2bDRPWlMwRUgxa2NwejhEakh5djZKd1pOajJ0eDVFdFpjVU5YWmVNWjhD?=
 =?utf-8?B?ejY1MFhQaGRpQi9KQXo1OG9NWmUxaloxRUNjZnJ6OGgwaU52TEkyR3dyZldn?=
 =?utf-8?B?NGNFVUIwQjhmUWx6T0Npdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enNYazNFTG9sS2V5ZTREUnZVZWFRYlFPbzh5a0NWVG1zT0JxREhKN2x4TUxn?=
 =?utf-8?B?bHNsT0hQUnlVMWpMdHhUa1J1eUNpdDEwNHRWaHo4bTZLOXV3SEMrelFnMEZI?=
 =?utf-8?B?NFBSU2lWcGZqSlQ2c0dRTkJSYjF2bEtqUktnK2oxTk05ZmNGd3E4MXhJcDM5?=
 =?utf-8?B?cEgzOVlqWGlxeWhPQU9VYmZiclJhQnRKd3o5bFYvSmV2M25LM0YzUWVuMjNT?=
 =?utf-8?B?VXdIRWRYN0tMSGVXMXZ4NW1qZU9wYzlZVit2Z2pibmN3VXlPakd3cFMwY3g5?=
 =?utf-8?B?N0d5L2VIMlV1cWM1NHR6MWNobUFaRndWbXFBUzN0akpnV3ZFZzJqejcxamNB?=
 =?utf-8?B?b2ZpVkFYQ2hrV1QrQ0dXbVphZjY0UW55Z3dOaDltVXZPWXdhbW9uV3dkTmNK?=
 =?utf-8?B?SUYxMStKemlhd0dka2FGaUtPejRCbndRWFNHbWduVzlkSm5FODNnaUFYdTNB?=
 =?utf-8?B?SHlscmdab0VOdDh3dEJTOHdyRWlKRUhOUG4za1hyb2ErMk1GZjJySElmc1Mv?=
 =?utf-8?B?WmdyWVh4WC9wSSt5YjZLRzBMUFJYQnAyZ1pxNXc5UG40VHEydTZTcjB3Tzc3?=
 =?utf-8?B?TmVoQktkSC9DdzA5SnBJdWN1MFZMSDRLTTlmTWhBMnZJN21MQzhmWVQzQ2pI?=
 =?utf-8?B?YVJzWWNMY29BdndqeG1hRy93SGp6NVZJakx2UWU5SzJpUGMwb2F4NktZQ0VK?=
 =?utf-8?B?eXpkby8rV0dheUxtR2Y5M2haSFYyUXdtT01RY2J5R2lNQklIZzRSSlU3dUV0?=
 =?utf-8?B?SzdCeWFEa2ttcWhSYkhOUVl0SnNkUGhlNWJRKzY4eExidit4bW1FMEFTcmN4?=
 =?utf-8?B?TUlJWVNNTzVCZVpTTnFHV1QyTHBaYzNDMDV0aFJnQzFwOCt3NTRXaW55NmNN?=
 =?utf-8?B?bnNoZkwzdnNjUlRiQ2x1c3luRFBPNjVTeGRHb0pMQUVpVnl2Vi90SGpDVHVj?=
 =?utf-8?B?ZzlqM2NyakhSRllwd3oyNHRDMElteUtvOHRzV0s4UlBrYXczVlpRT0tCYmFK?=
 =?utf-8?B?ZTJMNjFyTFkvNXUxVmhIOEhBS3pXV3hwZVRLb0JMRExtZ1BHaURCTXZ5ekcx?=
 =?utf-8?B?VUx6ejBPZTNuazRHWjkvZ1E4eHh0Mktzcmg4RVJKVDZKMVU1NkorK2hRYW1x?=
 =?utf-8?B?eW9kNHJMVTc0cXdybWYrR0hkVExQNjdvYlh5Z283OEl1MWpTVjV4aG1MdW9P?=
 =?utf-8?B?amtBeHpJNUFhQlh5ZXdoSnBHQ25CVHZ5K0tubENwc0JkY3JBVnJvQ3BRNEl4?=
 =?utf-8?B?bkczYzRuOHlkNVJ1TG1TeElEcXgvaHhrUStYVitNc0lESndwYy9GK202QWpq?=
 =?utf-8?B?MXdZOHVHT2ZLc3dHVUo1TDFXT2NQY3JoMWVMZWNyQlIvd2t1SkJtdFAxS3dF?=
 =?utf-8?B?RUlid0ZWRUhPSlQ0VXhkOEpNeGRDOWFMMUE2eUVPY0QxZlZJQ1JVN0oyWFA1?=
 =?utf-8?B?SGhxU3ZTbGt5N2UwclY0TmZOM01qRHNYdFpGY2o1SloxUHJBTUQ3NSt3TGx6?=
 =?utf-8?B?UjRKRk5Bd3FnODRjeHVKZGU5YlpsMEpvaGFJSDlaNzFKTFp4QnBLeUgxTlFQ?=
 =?utf-8?B?SytrbG9JUDNvalVTRUhzRnViT2J1ZGg4Z1JJRmZWYjBYZEFZR0cvT050dTVO?=
 =?utf-8?B?d255RXpZUlFic2hBTE1QM3YyUEwvcFZxQVNXZUhJcG55VlVpTCswWTFBQ0Yz?=
 =?utf-8?B?WDR4bjhrK2JrOTZwMW5LemR4UU9Jd0pyZzFPM3JYUlEwVXVFa2RzV1h3dy9Y?=
 =?utf-8?B?bnRGeUQ5WkxKMkdqR243ZFpXSzJHUTZ1aDJ5L2JNWGNWTWcxMXBBUTduMlU4?=
 =?utf-8?B?K1E0eWl4TW43QlNqbnlLTHgzMExWWkZzd2Q1YVpEakNvL0ZHWjZKSHFpSkow?=
 =?utf-8?B?aEFYL0tQSnFPQkdPUVhDQTU4VjgrZlg1L3dCQlAxMVFNQW9vMi9LK2cybmh0?=
 =?utf-8?B?WjRKZ2VGdVlpdmh2QWhhRE5ZZHMwOVhmNm1qeFU1dS9JSUg1N09IbmE4ZWVZ?=
 =?utf-8?B?Y2ZCeGpqU2Rla3NSekhDcFpBVGJpRDNHcXJLTUYySDRveXd6YXZ2cU5GM09Y?=
 =?utf-8?B?d1J1Vzd4cWFZVmRFUlJGZXB4WHBnN0JzTGdlR2FsbktHRkdvQ3RURy9jMnAy?=
 =?utf-8?Q?rJWuhTHglSeTZvZHzk+Mv/Tzg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a95bc0a-addb-4475-f424-08dcc937eb20
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 21:08:38.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XyxWBZP5neT2jMwvmGx5oOBuy4W+ure5t9S211cCMuQrtUwIwcAyCoUIYfOOT7NWChFRFCQLkp/NK1qUXHbaHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6141

Hello Boris,

On 8/29/2024 10:16 AM, Kalra, Ashish wrote:
> On 8/29/2024 9:50 AM, Sean Christopherson wrote:
>
>> On Thu, Aug 29, 2024, Borislav Petkov wrote:
>>> On August 27, 2024 10:38:04 PM GMT+02:00, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers causes
>>>> crashkernel boot failure with the following signature:
>>> Why would SNP_SHUTDOWN be allowed *at all* if there are active SNP guests and
>>> there's potential to lose guest data in the process?!
>> Because if the host is panicking, guests are hosed regardless.  Unless I'm
>> misreading things, the goal here is to ensure the crashkernel can actually capture
>> a kdump.
> Yes, that is the main goal here to ensure that crashkernel can boot and capture a kdump on a SNP enabled host regardless of SNP VMs running.

Are you convinced with Sean's feedback here that this is a required feature to fix ?

And it is important to reiterate this again:

SNP_DECOMMISSION mainly unbinds the ASID from SNP context and marks the ASID as unusable and then transitions the SNP guest context page to a FW page and SNP_SHUTDOWN_EX transitions all pages associated with the IOMMU to reclaim state which the HV then transitions to hypervisor state, all these page state changes are in the RMP table, so there is no loss of guest data as such and the complete host memory is captured with the crashkernel boot. There are no processes which are being killed and host/guest memory is not being altered or modified in any way.

Additionally, i believe that the support staff will absolutely need this kind of support which enables crashkernel/kdump for SNP hosts.

Thanks, Ashish


