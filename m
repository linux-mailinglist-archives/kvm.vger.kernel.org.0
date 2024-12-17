Return-Path: <kvm+bounces-33908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 048CF9F4592
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 08:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91A77188DC3C
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 07:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E511D86F6;
	Tue, 17 Dec 2024 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PPVSyzQ3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2051.outbound.protection.outlook.com [40.107.96.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B6FA29;
	Tue, 17 Dec 2024 07:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734422265; cv=fail; b=DClpfyzP17Yxl+wq1cA0YNUY9eNCt7ncB7kJtG5CUDWu1zpteL1Fwao3PRyaUR8iRQOcM8G4Y7xTbz5S0U/wI/HIEenFQt9Jtd70wON9QYDF6rMHVkXqiCQCBKrkL86vZJh7bA1IDRxsqTwAGQOXiGzasAKRU3dXodLxlLuazoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734422265; c=relaxed/simple;
	bh=DC67OmAPTMZ3EFuqSeAvMQIOpdJMXf+46m6oAqfYhcY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qZ6Y/oOXuysDg4I3tAN87I4B+DUErqIm5fwb31wnJ3TvDCGYQLqdeBhdm0ELMpJbwKVDclagS5eTk8EWHW+ghZ+KGtJhJX3EhGSLinlws6AM3KBle3yehFSdh7pUrHI/W2p/cCpBYd1EUGowzou4I91Skf5RC+P1APJ1O71tCaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PPVSyzQ3; arc=fail smtp.client-ip=40.107.96.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cXsUSOekxKwyh3CXOKJfSWY0qfcTCKxVpXDRk7wts6EByuzvYvSmV+dCZhQ5zCPI39PFbYqXmBtK0TTHSDD6jBRuKuEJj8/EEdGUrkTNkmX9vD/oJ3R3hD533UNPULM6vkz+dQrNOqLkZtbI3GmCVkcsPSHi9Ei5NF//ykxn/Cyby38BGHoZiSfKu3EzA680gUrZpvh29lKtfSoxNz6STduC7T2bMkjY6mndJT9qV3zKvfM8p99juMhStitzvFea4e1FvntTriFdScWaHsZurVAMmHzxAOqF8F/F6G7ewAk9F8xFzcKJj91NlfdAo62HAr3jzyGIGqCuFWm6mZiEgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Fc9TTqYlETPdVVbx3ZfQ4ZEpsjBC68gkUnlTQRWehU=;
 b=vL5uPFeBwTG5gDecflo9mOtincAoCT14feEetpO5yekg4kJvKmKvKWBsX6LZst8SBGL+yU9icOYhAAR3b5s0ZmglfRSfocZ0uUxz9xcIXmJX+txZMAnja8O7Vb/CTQYsMbscFEILLMaL0gZ1fd4WwuAig6LvzR4Uy8Ot+gasGgkrWlSMVhGvkWcT6aPIxHWVCmWuuuMTVm/LrsqLss2r2qgpqMLo8jx4mzzJ8meG9RQsLf6CYPmi/G6wgj0UTlDrqMXjG+4BRQjypn5l93tiZEBCtByuTKw7EjC8TMXTdp6KOVMP2SvGsZL5inV9+TwSauFJ0ecWNqz+F/b9uly9sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Fc9TTqYlETPdVVbx3ZfQ4ZEpsjBC68gkUnlTQRWehU=;
 b=PPVSyzQ3kgfGhXUsoG6yiIRLgDBa/cAolRKnw3hKNKtUd7kpEoLpsfm8aGDmDO7LciTqtOL1Jlob1KaAVLdoVlprG46F152oFej22yOrTsJ7vAbX7A784H1ymQ9oAVJBof9ef0yFcI0i88hxRrATJ/Dt8WBgz0RvqpGA/0rSVwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH8PR12MB6844.namprd12.prod.outlook.com (2603:10b6:510:1cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Tue, 17 Dec
 2024 07:57:41 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 07:57:40 +0000
Message-ID: <a200bb73-9e6c-48a4-a123-372b7ec2baa9@amd.com>
Date: Tue, 17 Dec 2024 13:27:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <4dc0f6d9-764d-69de-6a4f-ae0f9a4ca7a8@amd.com>
 <04ce52ca-4123-42e5-924c-1c0c47a7f268@amd.com>
 <1c7734a4-e6f2-378b-cef2-af087a51526b@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <1c7734a4-e6f2-378b-cef2-af087a51526b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH8PR12MB6844:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a74ae2a-9b67-4e08-de86-08dd1e707aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1k3ZmxBc2V0ZFRnc2xKeGVQUUtFazNrVkw3NWoxRkR5QUVQRStDSjJXdG1J?=
 =?utf-8?B?QWFIZGpjc0R1ZW5YTlduNmtSVUgzYzV6RDRVZTdiU2hpM0lYNnNETmhFdUhn?=
 =?utf-8?B?MVRrSml3TW1GQlNLanF1dTdJQUpDSUw1VFUyV2MvOTRaeFdoMkVqL1RpMEpt?=
 =?utf-8?B?M3lGVEJZeTBEVFJtSFpjbWhPclVlRHVieks5MDBjRGdobU9GZUF5NDZZVFN3?=
 =?utf-8?B?VHJ5VVZkVkUyaEVSTXEraVRKa3lySWpPWjJudVlLUHJ3MmJ5bG5HR014NnVt?=
 =?utf-8?B?azhlTmVSYnBnbm5lS0JIMXlEeWxwSmpnRm1reUxVbndzaDdDU2VibllNbDlx?=
 =?utf-8?B?azZ2YjZwOEc2c080Qm1KVnNWOVYvdy9SOS9nTk5HVkhtK1RiTWVuS0NtbU5o?=
 =?utf-8?B?TFZFbnh3ZkRXbWVHbnJCNmhGOWVxaW1wWW92UklVNVY1UFVmcGgvbCtoVzdL?=
 =?utf-8?B?MHlVaUh4dFVXZFJ5cXBzQVdhVThydk8xTFRNTEpiNDc5YjY3VGFicjN4OXdk?=
 =?utf-8?B?NzFoYnRSV2wvVU9hd3hMVGIxV0RjWHF3cXBWNjZBVnhXd2VJVGhyK3NrVC9G?=
 =?utf-8?B?UTZTOWdwT2YxcVZkWWZpUklHWTRRUWNkb1BYV1BvMmR3cHljdU5GcnE5M1lp?=
 =?utf-8?B?S3dkSjQyRnhZVm0zRUVwRWp0N1krak9JNXc1YjRLVlJlYUQ4R2NGM1ZQVFVI?=
 =?utf-8?B?UE1meHlhMk00dXRWRzZ5QTczMXBybnJVejdaK2Q5blY5SGxDUHpYYW1sTjJZ?=
 =?utf-8?B?RE9YUWF3UWQ3NlFVUk5EY25CMHc3WUVwRlVLQVg0dUJ4SHBWZEN1clU0OWxk?=
 =?utf-8?B?WFRPd3dlRytsUmpocGFzdnRTS25YQUZFWkpSZ2RRSTNDQjhjZlNrcStjQ05i?=
 =?utf-8?B?MEVWYlowU2gyZ3pCdmVVM2tCcXA0RnhWT045LzBOYXUyNTlhNkNaWW9VUjJG?=
 =?utf-8?B?cGNLUWxneEpzT1p2ck1mSEc5UFRGam1IaDl1RVdVblB3ZUpPWmgxUVp0a0tI?=
 =?utf-8?B?SW9KVVdPb3VUUXlFSVZITzJDRGJSc1hrRmhuRHR5MVpLbE1PL0k1S3ZFREhj?=
 =?utf-8?B?THloR1hSa0xvd2VTZ3NLNWZPOHBNR2VQTW1IYXpmRk9TbVpZdVBGNGZqdm5v?=
 =?utf-8?B?V2UzQmFMcmFOK0UvVUVGc2cxMWs1dXpMRm4zRzF4aVI4cXJFMFI1dFVyc3lp?=
 =?utf-8?B?Z0JONmllb2Z0NFRXd3I4c3ZwTGpCYlNqVGFXU1ZzZWxKUzhhK3JidW5GVElW?=
 =?utf-8?B?Vnd6UUJBb1ZVdVB1WFdvSTFFN1VibThiSlU0NXF3UGhFSTJKRzZFTWNBVE54?=
 =?utf-8?B?NXhMaVg5bWlHa0xEa1JBcXF6NGR2bVRDb0dhekM5Rkd4ZHJudlFlTSt1dDVu?=
 =?utf-8?B?V0l0M3pOdEJESzFYZkloV1h6WTJFcXdSdm8yN2NSUThqV0NhMU5QcG9JS0dJ?=
 =?utf-8?B?UmZGOGhoZm0wbVhsdlkvdHl1VUVyZFJiSTBUbU1ZYnNFZVhPeGlhckVudmpV?=
 =?utf-8?B?M0xhWXBicm8yRmhuUnd5dHhlbzhrL0txSmxMc2FoSFRrN0tqd3l0dC9qVjVD?=
 =?utf-8?B?T3J2SVZldk0yK1V6c3l2UDFJWVNDdytib0JOZ0ZxVytiMWYvUnZ4ZXRpb3Ny?=
 =?utf-8?B?U2RFNTd4Njd6dUpwYlZ1RCtyNkp1RzBtRi9CbVFIVTYzcHFLUnBEK0x1dHhH?=
 =?utf-8?B?UGJmR0pNVVNHNnlZcnVEMGQ1RThZN1F2YW5LWlZ6dE9tUHVmM2JwNlliOEJl?=
 =?utf-8?B?dkVEZmdiajIxeGZYaG8rWXJhazYweFRaamxXVjBDRGkwK0NKQWQ2QzNJeEpK?=
 =?utf-8?B?ZWNQYmdDMWM3SUdsWTc1L2l1SVRJYkIvQVFPNFNVNUY1R3JOd3hvQ1pxQjh2?=
 =?utf-8?Q?Gg91/hQySI+ty?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVk2azdkbzJndi9YOS8yeXQ0Zk1neDlaQ2hXL2NCMmZBaTBYSGNRdUd5R0NF?=
 =?utf-8?B?NDFMZ3V0L2w4WXhtbWJUckxseWNyOUIyL1ZHcjhZMEpVYnlSVkh6YmZnNzlB?=
 =?utf-8?B?MDlaN2d3YXBPMjRJOThCaVo5S3EwbVpoMTdCNytSWCt5MmQ4NlNZaVFyZEpU?=
 =?utf-8?B?cTlTSWcxWGxnNGxmUGJieHFGYkxFeGlsdERzdWdLWllqSWo5SndLcHlDMlla?=
 =?utf-8?B?d0lxKzRwL1RPZHdMWE0veTFyRFdGT3FDV0dZWCtpSjJ6NHdiV29JMTVxODNi?=
 =?utf-8?B?RmhSMnZOTnZ0ZXZrVEUyYkhLbWJNcG1UanJacllmd3ppNXRRbEc2RVBkeERu?=
 =?utf-8?B?N1FFZ2dlZEw1RHhlV3NvMFlULzMxQXJJS1JOcGR1TnR2WmlWTVBSdmtzc3hY?=
 =?utf-8?B?UVdsSnRpL2E5OGkrZkdFZmE3cDlpclJranEwdDJZQ3crMEwrNDRSZ3pJczhX?=
 =?utf-8?B?czBWbXdEU3FGdTdVTE5UUWNhY25SWkFOQXg4Qy93SDRFazVkVk4vekd0SGtP?=
 =?utf-8?B?ZE1wNlEranBlQTNWUkZqL1B4NUVuK1AraEhKdU5JMDR1NXptcGUwNlA0MTIr?=
 =?utf-8?B?b3VFYjMxMHM2MDVZby8yQjNESll4RksrUVJBOVY2QVkwNHk0eExjODJkZ2RG?=
 =?utf-8?B?eGNBWitscjE2VmRSRVdoZ25pL3pSdlNnUXppU1RvZ085ZU1wbDdKZ0lBUmpB?=
 =?utf-8?B?akFqeDV0dmhCNm44VnBRSVRJK1JneGowcTE4OUJxdXZkc3JUcTRML2lTeXlN?=
 =?utf-8?B?SFozZU9xaTdtbWtGL1IvYks2WXkyK21xeStYTXN4MEh3a0U1ZGNHKzc4VVRx?=
 =?utf-8?B?RDlib1h1dFhSdjFldFNsbkhyMS9rMjFjaUl5dWplTkF1NUVvdm4zNlpLdmsx?=
 =?utf-8?B?OTUxVmlHbkpES2g5ZkUzMXpGam5aRUY0c3FvL2UzSjRJdHkxdEp1YmluWkhU?=
 =?utf-8?B?MmxkdU5MRzBLTThHMkxvOEdQaWdlNTZxVDE1eWNVd3l0a1EwYks5ZEZ1b2xt?=
 =?utf-8?B?Mm53d3JDVTMxMzYzL3owVlVraEdzWFF4WkM2S0VVamdWSE9QSXpRNWZWcWx1?=
 =?utf-8?B?TUdTVENKL2liMFpWYjFOT0lzaS9qNndIS1R4MEV2SUE3UmU1WkdxVmFKZU40?=
 =?utf-8?B?VWNwRlVJUVUzUy9KVW10SmxKQ3g2OStGeGVxeXF1WnJkWXRHam5ZMmVnQ3Vw?=
 =?utf-8?B?YnhhVnQyK1Vqc1J0VUErQ0ZqNmpFT2RLS2s1Qk1tclI2RWJzVy9HNnlzUjdN?=
 =?utf-8?B?U2JBaXZaZ3hTT2IzelBoNkxTUnliR3VPNWJ2MktNdXBVWXduQUJqS2Fmc2tV?=
 =?utf-8?B?c0lWTFVpdzlrcDBkOHN2a21Uc0VMMXR2T0ZLSDFyM3ZPV2RjQTFiMjlRdERG?=
 =?utf-8?B?Qjhtc3Fhb2JBQ1NQYWQvN3N0am0rcnlPL2dpSldic2Zqc0svbGNVQkk0VjNI?=
 =?utf-8?B?dTlDdWloMTFFZUxGcXk1am9EdmV4VXNKSllGQ2NSeFZ1R3Qrbi9EZ2I1bU1z?=
 =?utf-8?B?K0tjTko0dUtxZ0VnclNoRVl4MFc0YzNobmVseTk1U1lFUkVpWjUzOVAzUGxq?=
 =?utf-8?B?UG9BRUVzYWxNOFdCMHY3T09tcEFSUnM3Rk1yNmNCcHo1c2hhbEF1Q0FzaW5N?=
 =?utf-8?B?dTJnbm9FeGdQTFNxTUJJVnpQMU5PRkNzU3h6T1d6Szc2ZmgwU3BwSGg2RCs4?=
 =?utf-8?B?RXRMaC9PNGpjbENWQm4wb0JtUkRRZHVDZ1J6S3p1VE5wUWZrMjM0enBQY1VJ?=
 =?utf-8?B?S2NoMlV1bnltRHNLSEE5UWhmcm9YUk9QbHRzL2FoTmU5MU1uRHI3MzdUZ2hH?=
 =?utf-8?B?VWJEdHhKUVlSNzZHMCtzQXJiaDh1Z09lOVdKWFFzV1VoM2tudjdOYk84UWFB?=
 =?utf-8?B?WU9iTFdyalhzdFlIUXNJb21CcWI5RVkyaUhncVc3ZEZJczR3K25kTHIwMkZy?=
 =?utf-8?B?UlVaSDRhcFRXcm1zMEJHR3lpRFBoT3ZJb0p4WUFCNlZLUzVoY0lrRUtQb0pM?=
 =?utf-8?B?cGpFYndjbWVFd1ZKVXZqNzlpbVdoVnZ5a0xVaFVNUldwb0hSaUJ2anNVZk1z?=
 =?utf-8?B?RFVBVmtLK0M2cFAyai9aWEU5N3dwSGJSajVaZ1NwandsVHVVNldycVg0cEg4?=
 =?utf-8?Q?ZUvio+tXpWYRyQmnZapTysSyQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a74ae2a-9b67-4e08-de86-08dd1e707aa7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 07:57:40.3279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnDURqTobcYJggEiaVTlyCP4QhGVx54N9DVPicMXbYfiDaGDD4IG3SADWOQAzJ1XaY6DBAqRTh+kK0tCbz0veg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6844



On 12/17/2024 12:35 PM, Tom Lendacky wrote:
> On 12/17/24 00:27, Nikunj A Dadhania wrote:
>> On 12/16/2024 10:01 PM, Tom Lendacky wrote:
>>> On 12/3/24 03:00, Nikunj A Dadhania wrote:
>>>> Calibrating the TSC frequency using the kvmclock is not correct for
>>>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>>>> GUEST_TSC_FREQ MSR (C001_0134h).
>>>>
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/sev.h |  2 ++
>>>>  arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>>>  arch/x86/kernel/tsc.c      |  5 +++++
>>>>  3 files changed, 23 insertions(+)
>>>>
> 
>> @@ -3282,16 +3283,18 @@ void __init snp_secure_tsc_prepare(void)
>>  
>>  static unsigned long securetsc_get_tsc_khz(void)
>>  {
>> -	unsigned long long tsc_freq_mhz;
>> -
>>  	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> 
> I was thinking even this can be moved.

Yes, I am testing that out. If there is no dependency, I will move it.

Regards,
Nikunj


