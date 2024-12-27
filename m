Return-Path: <kvm+bounces-34382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FEA9FD025
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 05:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 528741883588
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 04:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8464477F10;
	Fri, 27 Dec 2024 04:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GWrW8+XT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209D3191
	for <kvm@vger.kernel.org>; Fri, 27 Dec 2024 04:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735273285; cv=fail; b=N91GBVpvXfXi/EeGXH0pueALz0Tcp5iJ6StjSpfwS6h1a7NfLSAsgMpQ//cVNvsUluLiwRcKtVHieeBCo+OeDyrm/Bo5tYEwpjD348tV5aXNJ/RFO6iJ93ZqhYiP5XyT1gD8+WeqjPoj2qH42ADLSbNLh7csQxNGdaEnzjqN0Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735273285; c=relaxed/simple;
	bh=50x+F/zLy71k6vH7s0kC5AI6ruC6/HRrqixzGLG+7Mo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bLEg2iVICYGiiImNsTAaXQdKh5hmeMVz5wz+eUQC0YDvJFQfrksnGtfQO8IubikPWT7Ds04/Havkxc5D2vn8BEeY7ZBD2G27s+W9/d+ymh12PrGh1Hy7MafmOuYiZ5W8L9Ucv0UeyN7DUyzspZHWvM2NH6fZIvceNMm2OWffPhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GWrW8+XT; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=klELiFwOfujmdjsOc/isq/t4xs1tiXNJPOrkKDK0CZPsc5BmJzm/M1EGvPH+nSFksEY0dNs8H5Q+NdlBK2bDb1ZIy1R6yYMcr5ny3llOgamZTRwaM5FTQIx/PTShXmCIRAQr0K6Vt+MRTolbzOk/RS1zkDaWWQ+duCKOv3BxPlVFMAb+gGSNTrkxbM0gUriKI724d6YAV9vi6/a7X5QcmXhT0syTQqUxVtDMlqn+mjIlAQmhlQnv3MVyeyQrmOtZzpsxYpP/2DIzQF2Zle7T2//+V6PqTJcAcgr1Xa4DR/ObRxkZZEOnd1muOKeaWg1D65lLL+GH1HyikNtzWcSBkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ib5+fgk7Kmq7ElZNs1R519N9skkgDk87qqSt0Mefz94=;
 b=Nap7gLtULH0elE8d0YX3SGcJ/pRQT77OVPnR0J23QCIMSuA/YckgsEqx+RC7uBQ8f1rKBHIh1k3RqF/KXVPlgo+En90Q8pLunFLfPVwss6GOXg0bBXyLpOwXNqqYmKkOzG2rR9QEOmmlXKg1Iidn/IhpeOgZmJcq3TVDZuyrG9RwlLPrI7km20HyO7B55bE8riOzcXB4eFrQ5ENP/94ucrBUTLpH/ZIKqYVeDtGwvyG6LExny/FdUTXTm3lbgXuf6YZSq/oL30GGMB/WmQK4MSv/bVG5p4Rn4RokqYks0NpLqXSEG6AYev1nKdrn4adMhiyogn5LCT1pb66+3l0Qfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ib5+fgk7Kmq7ElZNs1R519N9skkgDk87qqSt0Mefz94=;
 b=GWrW8+XTPiGGjZ3l3xrF6lD/fCxIWUyqkFqN6pqYxmna5LOn9NeXovqMpw6jyrYWEzwDo5oLhcj82iv3YccLHuwklmQsUoGkX9sFaczUt3vluFnlE0GHfmT09b1+HOjshtH3IwaIQOW4FqR6ds+ltbRSFH92gOj+Ke+LIu2gCmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 04:21:16 +0000
Received: from LV3PR12MB9213.namprd12.prod.outlook.com
 ([fe80::dcd3:4b39:8a3a:869a]) by LV3PR12MB9213.namprd12.prod.outlook.com
 ([fe80::dcd3:4b39:8a3a:869a%5]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 04:21:15 +0000
Message-ID: <07f437ac-5278-4f50-9443-39511ecc14ba@amd.com>
Date: Fri, 27 Dec 2024 15:21:09 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>, Fuad Tabba <tabba@google.com>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
 <ZzRBzGJJJoezCge8@intel.com>
 <08602ef7-6d28-471d-89c0-be3d29eb92a9@redhat.com>
 <ZzVgFGBEUO7sU3E4@intel.com> <d6b74ccd-47d3-4fd6-96e7-3027dd13faa0@amd.com>
 <82c53460-a550-4236-a65a-78f292814edb@redhat.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <82c53460-a550-4236-a65a-78f292814edb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY8P300CA0003.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::20) To LV3PR12MB9213.namprd12.prod.outlook.com
 (2603:10b6:408:1a6::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9213:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d64ee50-942a-4665-5baa-08dd262de741
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEdkTEMwUnlqVlArcFI0aktuU3pRQjFwdmhRRklhVUkxSkN6K2Yva1pGT2s0?=
 =?utf-8?B?azZzTFlWNFNGRVo3cDRmVFl1M081T3NVaDlhWjJUdEFEZStZTStTS3NBUkhU?=
 =?utf-8?B?QmVzdERnVUFGMEk4Q2NLcWxaNXUzMmJ4RWhPOVdlcFB6V3VlVnlCYkFPSXFu?=
 =?utf-8?B?WlJpWkY2cHN1VU5ZeXRETk5PT29hNEVRaTdSbVRkbzJHVjdWR0FLa2tXMS9F?=
 =?utf-8?B?Qm9ZQkJSWE5NVTNHcmdqL09RVWhmM0hMaDZwZisweEdSY1NBVXJyZVJFL3JU?=
 =?utf-8?B?OWgrWnlLbTIycm1jdVJKM2c2S09WZndzU25lVXNUS0pXYm5IU0dtMVc2RTRp?=
 =?utf-8?B?Zy91S2hmOWtzYURueU5XQ0pEZ2VaZnVvVjFVc0JFUnI0SS9nRnM5SVQzeDdy?=
 =?utf-8?B?TGliNDhyLzZEeXVZc2Y3dENUai9oVVpycXp1cDZGK3BuN0JXQWUvUEYybGVN?=
 =?utf-8?B?RHFzWWYvVm5LR0pacnI5SDMwNVRraXpMZ3Jhak12M2FIY1hKRk54M0RtMll0?=
 =?utf-8?B?ZFhycGordXF0ZDlpL2ZLSURBTmlxZHVVaUJ6cDdsZWd3V1JqT2kyT3hTTkNZ?=
 =?utf-8?B?S2xSNWswTE10bGd3OEpQR01nMlFja3Rvem9qQlVwOHhpcVJrUXlUK21UZUlv?=
 =?utf-8?B?NEdmYmtDVUhtZlhKb0ppUHVuY3hacmVhYW9RcGV3cEZzNHpOQmJBQkFzWXJR?=
 =?utf-8?B?SHpvNjM5Vkk4Z2NKcFlubk5GcjJVZUxSaWlTZW95Z0d6YXM2clRQYURMTXFp?=
 =?utf-8?B?K0tMZG9TRDA0OFg3Sjh0c3NMWTVBSUt4VHpLc053N1BHd1lSWWE1NGdFcnpK?=
 =?utf-8?B?akFFeERYak11eG16YWFoR05EU3BqWVROaVFQenB2V2IyVEhPeVVWTEE5cVRl?=
 =?utf-8?B?UzFyZ2xhazlBTGFKZk9xK0FJeVpQMkVEWHJ5UlI2b3ltU1RySlNZUHNXZGVK?=
 =?utf-8?B?Z3NNT2tuYlBWRVRrbUVrdXpYemF1SksxbzlROUh3b1NNaWZmYVQ1eEYxaVBO?=
 =?utf-8?B?aVZxLzVsc09SaUQ2VDc0c3NHcXYwRnBVWEhWZmRISEI4dXMwL0Y3SHVkMytZ?=
 =?utf-8?B?dGZQbThIa0UwSnRSbURkemNIVVk4T1E1dHh6ZklYQVZ1eXRBcTRaZVBndFQr?=
 =?utf-8?B?QlhSUjRUMVVHYkZmcXRVeFdNZndSN25FTkdBRm55ci9yQ3FRbVc0ZmgyL3Z6?=
 =?utf-8?B?L0F5a1pidzNQYnRUeFVHVld5dHpscE92NVlESnBTeUNYY1hlWHlnMFFHYWJ2?=
 =?utf-8?B?eTJhVWE2NllaSFpsdm9UQjZnRWJlcnBveitacFFGTW5kWDYvZC9JMExLRHRR?=
 =?utf-8?B?eXllb1ZsNzFmZzYreUpJdC9GRmliK0Y5UGIyb1p2NjJMUlY1Z25sdHBIbUdz?=
 =?utf-8?B?YStlQmVsMWhPemx0MjRFSzZmRktKTjJkSTJxT3k3SzJJc0RwalhxNEZwY3Fp?=
 =?utf-8?B?Z1R3alg2QjRmZERzbmQ2SElWTnRDMm9UdHFCK0tQVm9LMzgveXhVZUFZUHBk?=
 =?utf-8?B?dmZRQ2dBR2QzK3lOQ0wrdDU3UXovWmxXZTVWU2N6bUJwanFEZkltdERpMXlO?=
 =?utf-8?B?OUI1OGhsbmUrWnpIeDE0LzF6eW9JQWc0d0ZyTFlEcE9DMUlwTFJjQmVOUDZa?=
 =?utf-8?B?MFpDQ2pMZzFOTDFUTkVtejlKbW5WNVM2dzZPNXQrSjE4QkNvU0daRjNidFhj?=
 =?utf-8?B?MDJmZGRuWVFTMVhMR1oxRkZod25PeVhia1p3Z0xhUzhScDJIamE2dm1jV0Q0?=
 =?utf-8?B?UWtOWTgzV1FZb3dlU0hrRW5ZNGZDVjVtRUZxaHhXQjVYU2p1VThLL1JxY3hi?=
 =?utf-8?B?clNZcXpYcXdPMlZnQ0RCRHJPelBTSjIvZUVwYTdOWmRQWko5WitYY1B0Sll1?=
 =?utf-8?Q?swiNgviE2bWdc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWIyYXJqVFNzUU5TR0ZrZVEyV1JnRmNVMGFaR2tqc3JkK09QQzdERHY4VHNW?=
 =?utf-8?B?VnFMNG9nOFk3Sm9YWlp3V25aSjg3ank1d3M4OEM1S29ZUXZGRVFWTXdkWTR0?=
 =?utf-8?B?bk9pazZ1MEprWk5sYWxOVUFGZmo2WHlITmpESUxVWXplcTQrUzdUM3lUUE9K?=
 =?utf-8?B?L3hLbEFSWVA3cHFRaEhXTUF1V0h2L3JZT0E2MjVkbXNMUkpQb3hGZ0RCQ0Nu?=
 =?utf-8?B?TkpCeFlZbG5ZZk5KcFdSTytnV251SWhBdi9YZnFCRXFJbmpFNlYxdndDM29E?=
 =?utf-8?B?OFhJMFJsQTZBQzR6eFNsVzAva1dHbU1Vdm1mNGxpTHBmaGUweU8vTC9PWEN2?=
 =?utf-8?B?Yjl0YXk4VHhVcllRRnJUREtld2dPdkpRZC9OYlV4KzI3c29NT212QzI2ZkJP?=
 =?utf-8?B?MnNLbTMxNjFVci9sZDVrUXUxNGlOYlhEeXV2UmxaTVJZbmNQYXhEd3ZHbFNu?=
 =?utf-8?B?V0IwVlI2RWVDOFVFRkI5djVjYXNyVTd5bWJyMXRYTGRVWFBEY2NTeFNObXMy?=
 =?utf-8?B?YjhrRWxlWnhhbkdOSi9IaWhBQkxKR2lsVzV4VlhQTW9rWDE5TmlJeUlLY1Nj?=
 =?utf-8?B?eDNVTWV1WEQyeU1wQnFmN0xnYnArNXQ2ejkvWGI2WlRyTGNOaWU2a2t5MzlB?=
 =?utf-8?B?cjhKVUcxTDVTUjNzbTVaTVVVZkN6K3FLN1p6dE1CYzJVYUF4ZmFFK1RhdGdJ?=
 =?utf-8?B?cTdTMmZtV1kzSVRXdFZFcy9xVEdyUDZZcjhpMzNBaDdieDA5am5UejVYanlD?=
 =?utf-8?B?WHI5Z0V4dS9WRjNhUDZPQXhsTVVrNXE1TGRJblJHdmQrTDAzakloTFNSYnZy?=
 =?utf-8?B?RU8zRFBzMnBvL3NxZDJRVld0UmdLd3M2bU9GVzdMQ0MxeHFWVkN6OWYvcE5H?=
 =?utf-8?B?SVllZ0xvcUpWQTk2RS9haFhhbU8rRXlrVUI5b2cvU21yT3VVOUtIeWRoT1RY?=
 =?utf-8?B?WXkxTzRWTFU0aXE0dEpQbW01VFF2R2F3RU5yNmhYenhNRXVIVDFpR0dMMEky?=
 =?utf-8?B?NzgrTE9qa040TERKUGVGSVlzc252ZTNpdTY1TnlIZXppdDhGMVNiYWtKUkt6?=
 =?utf-8?B?NkpRSHBJQlUyTm16T1VrMEVLeFFTZS9DQm9KSkEreTRuTThReWV0eFRpUW4y?=
 =?utf-8?B?VnVyRWd1OTFNQVc3Y3E4aVIxdm9JTkVCSS9naHJMZ3pKMGoxYmhBUkxrS0RD?=
 =?utf-8?B?WEY5WENpR2FLSURXVjB3WE53UXlFaEFXZ3RNT0I0UU40S0t5OGJwNUVFSFk1?=
 =?utf-8?B?Um9QZzNLRzZidXNnd21wOU91K0lzZVRya2FiSjV4WDRDVmdFUjM5U2VXV0Yy?=
 =?utf-8?B?M3cxS1pDam5qZS93dVFBSitxQ0ZaZDVSM0dCdDFtajkwYmxyaVFhNWR6Z1c2?=
 =?utf-8?B?ZmRDTCtSMXJaM09panJWQjR5c1VsaFVmZGh6bFRoTEp5V0l5NXFqdHMvemtT?=
 =?utf-8?B?RkJWODYzTEQ3WnhsaUlDejgrdWMySEJUZkpDbC9JMVgvSEYvNk54ZXNBVG5z?=
 =?utf-8?B?SzhWMTBTT1QyRGRtVzZBR1I2cXd1OEF3R0YzdnZnS2VrT1o3L2Jack4rMUhP?=
 =?utf-8?B?c2Z1bFJWSS9WeklKT2NtNUNYSjlvUkVtY1dNc1NmR1c4aS91RHlXbVk4MHBn?=
 =?utf-8?B?enFzSGIzTUx3bjBPZkZoNzVZdmVWd2ZBMWdNR3I1ZUVQUko5dHh5Z0pJMDha?=
 =?utf-8?B?U21BZWlLNkwxUU9zL1VaN3d5NnErWXJFOFNXTVRsTGEzNjkxRnBpOE5CbkRI?=
 =?utf-8?B?eWtJRnlsZG1hcDVRTkF3RjZuVitQU1gwY0VOZitSZkVyS1U3RVpxc2RPcm5Z?=
 =?utf-8?B?Tmk2K3ZiNVcxNnZUVkRFZEprWjB4ZFMwSHR1NzVEWDRjZEdPMTFGRWpVdlUx?=
 =?utf-8?B?WlpZMzJlSVVWM2dUS21GNEV0c0EyR3JDVUpxMFJlVHNNK3M4UERic1NBeXFD?=
 =?utf-8?B?K3liMmJCZDFSMjZTNVZESStmVTlGVVpwRjEwUmczcS83NU5ncVZybEx4akp5?=
 =?utf-8?B?Tk9ONytrQndqbmwwUCtORUxOTW53NHRubElnelZTK215Z2xDbE9PYWVKditl?=
 =?utf-8?B?RU8yRzZENWg0NWp4dis5eURzdThycHE2cVhhZmtxaXVyTUl3eFIram8za0Zj?=
 =?utf-8?Q?DsCWyxzA30m1jwCZhBSoau6X+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d64ee50-942a-4665-5baa-08dd262de741
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 04:21:15.4888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWlMHOOc4HCbN5zca/O/qiaWX3PwmlpPrDWBe0nMBAbWFCGkHX3NOtva886dDBLfqgnWv2WmZsxwn7GFvSt9dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116



On 24/12/24 22:27, David Hildenbrand wrote:
> On 24.12.24 05:21, Alexey Kardashevskiy wrote:
>> On 14/11/24 13:27, Chao Gao wrote:
>>>>> With in-place conversion, QEMU can map shared memory and supply the 
>>>>> virtual
>>>>> address to VFIO to set up DMA mappings. From this perspective, 
>>>>> in-place
>>>>> conversion doesn't change or require any changes to the way QEMU 
>>>>> interacts
>>>>> with VFIO. So, the key for device assignment remains updating DMA 
>>>>> mappings
>>>>> accordingly during shared/private conversions. It seems that 
>>>>> whether in-place
>>>>> conversion is in use (i.e., whether shared memory is managed by 
>>>>> guest_memfd or
>>>>> not) doesn't require big changes to that proposal. Not sure if 
>>>>> anyone thinks
>>>>> otherwise. We want to align with you on the direction for device 
>>>>> assignment
>>>>> support for guest_memfd.
>>>>> (I set aside the idea of letting KVM manage the IOMMU page table in 
>>>>> the above
>>>>>     analysis because we probably won't get that support in the near 
>>>>> future)
>>>>
>>>> Right. So devices would also only be to access "shared" memory.
>>>
>>> Yes, this is the situation without TDX-Connect support. Even when 
>>> TDX-Connect
>>> comes into play, devices will initially be attached in shared mode 
>>> and later
>>> converted to private mode. From this perspective, TDX-Connect will be 
>>> built on
>>> this shared device assignment proposal.
>>>
>>>>
>>>>>
>>>>> Could you please add this topic to the agenda?
>>>>
>>>> Will do. But I'm afraid the agenda for tomorrow is pretty packed, so 
>>>> we might
>>>> not get to talk about it in more detail before the meeting in 2 weeks.
>>>
>>> Understood. is there any QEMU patch available for in-place 
>>> conversion? we would
>>> like to play with it and also do some experiments w/ assigned 
>>> devices. This
>>> might help us identify more potential issues for discussion.
>>
>>
>> Have you found out if there are patches, somewhere? I am interested too.
> 
> I remember that so far only Kernel patches are available [1], I assume 
> because Google focuses on other user space than QEMU. So I suspect the 
> QEMU integration is still TBD.
> 
> 
> [1] https://lkml.kernel.org/r/20241213164811.2006197-1-tabba@google.com

thanks for confirming. I saw that but could not spot the in-place 
conversion there. And I had to re-watch how pKVM actually works :)

-- 
Alexey


