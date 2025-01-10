Return-Path: <kvm+bounces-35044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 627ECA091B7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EF3A16248E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 13:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E0520DD75;
	Fri, 10 Jan 2025 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SA06Hk5q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCFB206F14
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736515228; cv=fail; b=FBzgwKNLeN8JwNEcVQmL7boL3lPDEXHmCrNtvSq6FsObDg8m9QOQnhm3/LCvZrLPwnlxVPJSdhNWegD9TgRAg/RdUnhcbPhB/2dI4hz9B6EXqbL7bZM5LsxyJNmXmZMGJMGIbyZt9CT93EWt0tOX4HD9ZXf4qA3zDX+i1wu6oe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736515228; c=relaxed/simple;
	bh=AzP70EXurNfFl+Xo+Y1la+HugZ4Hwk9Xm6i1eDwhpUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Nxj4an/qynGudR9HFZfi0oQF1bOwZ7jtVzC/NFm6JnN/GD8Nx6aM8Kq9cQhQukMjpN+Ni2Tvot3XzrK4URdLlujGfCwV61U3bMynnQU9IXFkiQLitNTTwRxo+xdf8yqkt+Wiug5jevpl4BH5rIQATOAunr3zYAprk+n31KQEMjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SA06Hk5q; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u6s4BgI1DNQ2whfjBr6Dj6tLjRdscH5hEqLlcEFq5z2rqfbOHQf3zixWErJyFbyOEnITkyv1r8SZz4I/iIZwCenFVCwPFaoOl4CSfbZt61fJedIMeDkoQptuV6t2YrpMMymrg6GzFDvQFxUU+hTNuGIuMGNX2cKqwjGCEa8RNWVCAaovSTml63Xw6TNjHZDl8p4b47Bu+yXm0PyxYzF50ClMR6QxtkA5nsbWjrwWwqkxQhqJSlepsHKIA5rGYsCmgpp4m9wuupYIQ0RI3bxbkGJcKvGKAVqhqzhLs4a8egYmueIdFwMvTRnsVdlEmxL9gFdVrBATy8TqBckAhhbZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c12+6cDG+c1XPsoIwunqV1nTicFBwQJW9n740T/UON8=;
 b=MjQJhDSWaPR5+6aAeg3emR1wovB6vWhXwAh4AHRudWdCeYrZmDQdq03l5rkGjXMctqB/i5oFGW6mrTCasyZX/UfceqpVHbzhGwA5vCb8ihhZxwVolzZ0YQj0h1GWDDYq5uSzIKu8aNVCPYw00bpOcXdiLa44SSnJlMioNBgAW7mNQc6dsEqC7I3/UJo6KFWEtt7uIkF7WR1kTGuAh+/dfbFyT/kWqywaIFqHcSjEbkFrgQ6vyzaiAYO5OH2SxVTOW4fnZbdhR4iyvISPY2WQMWAUYm7naWN4fo8NN/GryZuvuIG7kBsHeOASDITqJfSY5vvGiMQhZ0mPiNluo3xJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c12+6cDG+c1XPsoIwunqV1nTicFBwQJW9n740T/UON8=;
 b=SA06Hk5qOuBMvCUy35janQLUeeaby9Sb4RE9alaj44oedtTzUUl3VEpEqr3HZ9N1anEaRa/U4/LoUHG8dMCzZBgG0UgFUaa1TqX7VkuvZFOoeykgDhTDSoiyW7di0gIevMAUjRdngVkCN+wE4wob0YAwMfzq5UFFupdGQyDViCvM0fMXwdeuIvwhK6YUAUbxzRuG2iFVkTboZUGhjaPwvnDXH1D5yOtXykl84xUhj/C5J4P7USJeZdWmj1Cd4B0ELe+S+9XsRTYmBtRMxlLpw4io+hANR4jha5lD17KXX0NKnJXpQIpzbkeKzDthR39hFhM2NdH9lZkiATvXKdmG2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 13:20:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 13:20:22 +0000
Date: Fri, 10 Jan 2025 09:20:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 0/7] Enable shared device assignment
Message-ID: <20250110132021.GE5556@nvidia.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
 <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
 <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
X-ClientProxiedBy: MN2PR22CA0027.namprd22.prod.outlook.com
 (2603:10b6:208:238::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5ebac4-581b-409a-e21a-08dd3179899d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3FCSWlEdmY4M3prQlh1RTlHcjgzS3BxNHduai9reFhxK1I3NSt5eksvV2xN?=
 =?utf-8?B?Q1dnUFdzLy9QN3hiTmJrSGN5cEN6N2RSMjEyMWVJaWFJaWoyLzh2UUFCc284?=
 =?utf-8?B?UnYwZURzRkJRVUZMSXlHUnMzVkpGWnF2VUo5QStFdGhuNENjTjI4amVEdnJP?=
 =?utf-8?B?cGNWbU1KWllHZ2lYTUxjdWFhQi8raThpaDk4VDl6Vm1qZW5UMUlHZHQwdjNN?=
 =?utf-8?B?a29lRmxxVXNoa0dxR2FJNTNxTk5JRnlNejdjNWptbmNlWGdBWUN3S2ttaXc0?=
 =?utf-8?B?TWRMZDN0NTNMMC9DMTFEK0tkejZqS0tLMHd0YmJUMVIvRk5ZN0hKczV0VFRk?=
 =?utf-8?B?NEJjNHk5djkyVndkYlA2VEdRanJpUWtkeFU3REpJbmt3SHlGc2RwMVF3TmNz?=
 =?utf-8?B?Znl4V0JIZU8xNWZyU0V5WldnWWZRUmw3OVRiWFdOaGZRaUM1OHZFU0I1UUpJ?=
 =?utf-8?B?SENPczUvU21leVhwbHlLTEJrUHUxbXpNRU5va3ZIWkRiaFVud09aekR2QzJi?=
 =?utf-8?B?WUI4WGVvOWpYYm1WeTQzSlZLZDZpeGtQdHgvTVhsYkhPd2FBRkJiUVhNWjZr?=
 =?utf-8?B?aUM2YjFKb09sOXFSaE01YTBkbEwyZGk3ME5haUpUUjZQY0M4eFY2eTBkdmhP?=
 =?utf-8?B?VVpKbTg4SjN4c0hHWUJrUXBFVlZQQVo2UzdjTTJvV1NBZkVDWUt4U1ExSUhS?=
 =?utf-8?B?eFFSYnVtd3FBSElFK3FBZHdVMmtUZ0VteGM1RmVyUGtiTGhJZ2RxbzBwZFVs?=
 =?utf-8?B?Z2c5RXIvTStsL0wzak5iRnBBOGJQVExxVEJ6QVlNR2VPYWtjbzJmMVl1aWNL?=
 =?utf-8?B?eUxhdmRoWTEyMitJM3p4NDdvZHgrcTlyV2dZTHg4dURRS1lNYzNyWHJ5akps?=
 =?utf-8?B?ZTFmL2NaNW53bUEyZ2E5ekdjYTZJRElaZEFPMk90aVFwaTFoQ0NwRWtUUjFB?=
 =?utf-8?B?SFN1Q25QL2h6YWxkV3dhbTl2RVRaRW5lQml2STFpUDFYQ1RxSGlya0x5YWJC?=
 =?utf-8?B?dUdVbTllVm1hdk5rc2t4UWlTMTdOcit2ckVBQXlPVDF4bzhYbHhOWExiWWpT?=
 =?utf-8?B?NHpxREYvV2EyOVJ3NkFEbTJnd2orNDJONWM4UkFNdkh4bVdES1ZCSU90QkJU?=
 =?utf-8?B?dDVCeUZ5VWszdXZ1aG9xbERoRHlMaXQ1aHRFQm9GTHduTDlsMXk3enJUT09u?=
 =?utf-8?B?UG9xbTUrOEs2UmZvNzBvRmx5SW9nUzUveEtaMEpyYWdObTJvaUpTNEU4bDhT?=
 =?utf-8?B?cW5uVVZ4QnE0Z3VZVVhNWkkyYmNicFpZS2R0L3FneGdpNmFjQkdQNzI1bXh6?=
 =?utf-8?B?SXNzKzZCeWhUOTl2bDVlTnFPbExFME55Z0xaUnRxblRiNlBXQkEyN0hLT1FB?=
 =?utf-8?B?SU9JVWZNQ3BSOTV5YzZPZEZ3blloc2kzY2t5a3JqdkpYNk5Ud0xGbTNpdmNr?=
 =?utf-8?B?dTVnWVlXaFZIemFQTGF6L2lBY3ZKUjVBaVdlQldNQ3Z2K01yZUFLT0ZMTmR2?=
 =?utf-8?B?UWY1SWs2V0JsMXdxMUNGcHliUDRMS2hSSUpmK01uVVZjOWFtMk9rS3dHZkJS?=
 =?utf-8?B?TlhNTHRYcFVpSmoxaGxOY1gvS1NIcEhFcEhTR2tCZzFsL1RkUjBOZmlMOGZM?=
 =?utf-8?B?SmxVZmtMWTZ0YllqMVYrVW1VYWJoN2FId0tjakR5OHpoRTU3cUdVdkdUbjNT?=
 =?utf-8?B?STNkV21tVVg4YUt1SEJ2MzV4ZjVJWVFpUmh0Rm5CQVlxNS9Rdk5HKzNFNWc0?=
 =?utf-8?B?WmJZZkltMVNjd2ZLWUNpNVRxekoydEtsRWhicm1abTF1NFdwMVhNaVJRMVpp?=
 =?utf-8?B?Q3A3UGJ2QnNJcko3TXNkS1NVRUFFemNGT20rSHUwL21uZVd4K3BrdFdScjVk?=
 =?utf-8?Q?KFV2J3Cm8pNiK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWpTRlVpZ0ZNNm9nTHhaRnh5bmF2Z3RCOGZKcm9MUUpISkFBdVdFSHkzNTBy?=
 =?utf-8?B?K1ZMd0RuZ2R5djVlL1l6Q1NSa0thbzhnclJVaDExQU9ueGtob216Vmcydkll?=
 =?utf-8?B?OGM5eGpRR3dHN1Bkc2RyWTNUcnVNVDEyZVdJa1FrZ3d6VStDVnRCNm5sU29J?=
 =?utf-8?B?ODFWNlVwZC9EUWRoY0wwM1AxMnhJUTVseUNmaGYvc3pPWTY0WXNwVEpQVGla?=
 =?utf-8?B?Z0VqOG1STDkwZFhGQkczd0wzMUwzcjNjOTVlbWd4RVpBT3F1dVBEVlRXV0dQ?=
 =?utf-8?B?T0Jzc3ArTXc2NWVBaDRvb3ZzWFdvNjVMZFp1THRkNUpyVnJJZ2JLWllkalF4?=
 =?utf-8?B?Y01LcXdOZG5LM1FacUVkdllrMUR1N1hiR2VFcEJ6cTZPRXVIeCswQlRKb3Z6?=
 =?utf-8?B?dUlvaHk1Tnowb2xwVFkwSlBxV3ZQUWpyazR5aXp6Umx4aGpUWHo2T0hZMXd1?=
 =?utf-8?B?Vmswdy83cGhDRHZJVmFFVG5OR0N4TnVxcThqbkJDSDZqSTBYQmp5akNBWHJS?=
 =?utf-8?B?UTN2aTdQc3NZMVA1aHlTWnB1ZTY5WFRDNDFpdlFnbHpQK2NPK3VrWVdPTzI1?=
 =?utf-8?B?aHl2cXRsWERWSnl4a2lFSE1yWHlKeHMrKzBYOGlUSlVzUHc4Skx1cnptQkxx?=
 =?utf-8?B?d2MzR1pJSHBZVnA3TmQyb1NYam5SenNuN2xrcFhNTWxiM3Fkb1dYUGtuRmdU?=
 =?utf-8?B?WU9sN0JQREVtQ2U2RkRyOUJodlFoalNwczFpRFVjTFNBSmxVZGhWYkVWaTAw?=
 =?utf-8?B?c211bnEyZ3U3MzdrdnZBZ00ySWpLNnZsMHVSTHpnSGZFLzdUTVBHeTJNTEYw?=
 =?utf-8?B?UHh1RW81MnR3Z0U1K2ZoaWF2ZDNMb2FvanVjamtPVkFqU1hsQjd5QWNDcFRU?=
 =?utf-8?B?VURndlcxakhpbENpblFTMWpXcmdNSjVpS215emZlL00vVWJadzluUkM4bmlG?=
 =?utf-8?B?UHdkWGVYNzlhSUp6dU1SbmlLdmlnNDRmZUkrSHRpODJiaHRDWmdMdW8vZURt?=
 =?utf-8?B?RllINTN0NnRhamFaWTZDWUw2bHJyU0hEQklhK2Y0ZGZDajdtQ1kyL3Mrbis2?=
 =?utf-8?B?S2FXck5Zc2xOK3Y1T2ZFUEVzNUZreVNYV200V1hGdHhwOVI2bnNRWW1sdVlN?=
 =?utf-8?B?S1RZL1pCcng1ZFU4YzRXWFl3dStHTElxem14OUFBMWh2OWxlaWZhRUtnbHpC?=
 =?utf-8?B?T2VzcG9uQUl3WE9rcWtkZytvNlM3OVNDK1prMXg1Vno2TGt3N2ZERm5wdWF3?=
 =?utf-8?B?ajhIcFBpbWhLUDhMSlBveThWQitaemxXZjdQMDJTUDZXa0VIRFFEV1NnMDJR?=
 =?utf-8?B?MTNGc2tOcmF3em8wQWR3RWpBQVNtbUVYa2dHMk1BUDhKUkgwaHl6RXFvN2hY?=
 =?utf-8?B?SldOVW11dGJ4NEJYZGJFRHRJR2tWVk56dGQxMWVQZmNFcHorTnNzR1FuNDNX?=
 =?utf-8?B?WWlzUXJvREJUTHFtencvc3lZRDhyRStBM0lBM0NRMFpiR3orVDloWmNMUXdH?=
 =?utf-8?B?d1NjSGJXbnRhellXM01vNTg2TnFTWGVnLy8rRXFpL3l5ZGV4Y3ZEV1Vmc3Mv?=
 =?utf-8?B?QkZ4ZHExYjgwSWRScTJpVnRCaER2alNnTnJTUi9NYnlPTkhtaTBtOWpEMWtS?=
 =?utf-8?B?Vmw2b3ZDUUZUSnEvV3JYWnhGN3VmNTBCMFdoMGY5STlNUzEzRHloT1pNc3lw?=
 =?utf-8?B?WWNxZzBoU0hlRlduUzdlY3h4bktRdS95dWNlWlIwUk85RTlnZGcrSGNJUnhv?=
 =?utf-8?B?VzBqcWlEaFNUajFHQWplay92dit5ZFFYamJKZmkzTGs5RWt1M1E2K3grdU94?=
 =?utf-8?B?TVFEUnJBOE5qTzZXeVJPbUZnNDhNbHRNYjE1TFlYOExNNkEwY1hrYXhVNEtx?=
 =?utf-8?B?ZTU0UlZDdktXaDdwRG16YVBaSllJaWZXandhRUVsZkZRbWpLcVJrVEp3WUJX?=
 =?utf-8?B?RjRSYy9ySkhNMGFyajRNNys3RUYrWCtGcW00VG1uY1RUVVJVK3diRG5QcGE2?=
 =?utf-8?B?ZHNIandiK2pRQS9xdGRKZDVoYjY5Q05RbnpadTJlOGV1UkJxbm9uazNSV01n?=
 =?utf-8?B?bkNMdU14dkt5cVplcUxqWHE0bWk1UkM2RG1SUEN2Q25mM2hzcmJaKy9iRnh4?=
 =?utf-8?Q?5yQgsHjW6h+zodWTxaAmx6gpw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5ebac4-581b-409a-e21a-08dd3179899d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 13:20:22.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeZ1hVvQqaHJMxcb5llnFb7WMLPqRUq884pzttUGYHl4TLguXKpk2oFYImyeE9Mw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520

On Fri, Jan 10, 2025 at 09:26:02AM +0100, David Hildenbrand wrote:
> > > > > > > > > > One limitation (also discussed in the guest_memfd
> > > > > > > > > > meeting) is that VFIO expects the DMA mapping for
> > > > > > > > > > a specific IOVA to be mapped and unmapped with the
> > > > > > > > > > same granularity.

Not just same granularity, whatever you map you have to unmap in
whole. map/unmap must be perfectly paired by userspace.

> > > > > > > > > > such as converting a small region within a larger
> > > > > > > > > > region. To prevent such invalid cases, all
> > > > > > > > > > operations are performed with 4K granularity. The
> > > > > > > > > > possible solutions we can think of are either to
> > > > > > > > > > enable VFIO to support partial unmap

Yes, you can do that, but it is aweful for performance everywhere

> > > > > > iopt_cut_iova() happens in iommufd vfio_compat.c, which is to make
> > > > > > iommufd be compatible with old VFIO_TYPE1. IIUC, it happens with
> > > > > > disable_large_page=true. That means the large IOPTE is also disabled in
> > > > > > IOMMU. So it can do the split easily. See the comment in
> > > > > > iommufd_vfio_set_iommu().

Yes. But I am working on a project to make this more general purpose
and not have the 4k limitation. There are now several use cases for
this kind of cut feature.

https://lore.kernel.org/linux-iommu/7-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/

> > > > > This is all true but this also means that "The former requires complex
> > > > > changes in VFIO" is not entirely true - some code is already there.

Well, to do it without forcing 4k requires complex changes.

> > > > Hmm, my statement is a little confusing.  The bottleneck is that the
> > > > IOMMU driver doesn't support the large page split. So if we want to
> > > > enable large page and want to do partial unmap, it requires complex
> > > > change.

Yes, this is what I'm working on.

> > > We won't need to split large pages (if we stick to 4K for now), we need
> > > to split large mappings (not large pages) to allow partial unmapping and
> > > iopt_area_split() seems to be doing this. Thanks,

Correct
 
> > You mean we can disable large page in iommufd and then VFIO will be able
> > to do partial unmap. Yes, I think it is doable and we can avoid many
> > ioctl context switches overhead.

Right

> So I understand this correctly: the disable_large_pages=true will imply that
> we never have PMD mappings such that we can atomically poke a hole in a
> mapping, without temporarily having to remove a PMD mapping in the iommu
> table to insert a PTE table?

Yes
 
> batch_iommu_map_small() seems to document that behavior.

Yes
 
> It's interesting that that comment points out that this is purely "VFIO
> compatibility", and that it otherwise violates the iommufd invariant:
> "pairing map/unmap". So, it is against the real iommufd design ...

IIRC you can only trigger split using the VFIO type 1 legacy API. We
would need to formalize split as an IOMMUFD native ioctl.

Nobody should use this stuf through the legacy type 1 API!!!!

> Back when working on virtio-mem support (RAMDiscardManager), thought there
> was not way to reliably do atomic partial unmappings.

Correct

Jason

