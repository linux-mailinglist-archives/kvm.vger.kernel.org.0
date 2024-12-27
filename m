Return-Path: <kvm+bounces-34395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AEA19FD30A
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 11:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 069471883A93
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 10:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8711F130D;
	Fri, 27 Dec 2024 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tFI5jSS4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AC5156886;
	Fri, 27 Dec 2024 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735295793; cv=fail; b=mW70f4kvKMvsQrcSRZzF6KWcReDN6KobU40J8dqaWZ7xbviMVvG/HLyQSbPXKOFtYVQbwqf3393ckLCCzvQc3H3Gg4jVAo/sjL5t6AGcFzMAHDtiXGmkAn9l/ACsbAA/Y47FnQF3o75b2j5b3mRFAYhgmkcR2eN5RuvA8Eu8BGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735295793; c=relaxed/simple;
	bh=2FzMPH7EU8mUrSrsNXeVIj7+3s4gH+bOGxAh9y6r51Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W/4l0Jm9ZR6rPBurFQfI1lbM4dsiezSEf3kLtf1kidohlDaP6PaDDeL9gdSwkD9n7yaaorTM/lbYJFTZ12CstM6WYruJfPnCwZ1HRROzJdDuGoe0q+7CuIndW5U7WplYlUYepE0ZAPCC8jpAGL55VbQoyxoLuvB2w7mhC8IjJgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tFI5jSS4; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQsqaBRwniYZ3hQeEfWuh/dAeuHmHg3287EQEh4qYBWCB02Cbyi9gocoafgJR8/bzS0vm7aJB1IceVVAfr1vZI53CahABOWsSs66pWtSPedbR+HL+OQkatnN8ZnB9BmSlYNviYERQA3pMDb0+5wfZs98ZPLS+sxk419cJT+/j9mrm7pYqwn92Z4O/qxYnyE1hTa0hZWoOuMO3O8zahgFvL5Ko6smnAjX/Eqp3eSmNXKtuabkwcQvITFLfcLaEhZuFCEIlcPJsneRjBr8gTYjJbVTruX6B/YXd89sn30vHl8Fk5TpVrQhswukmlCB/aMAdudWgIqOpHKm9t0du152ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mugPGxV6vwcJTn303VlhYLleh78qHVHyv/m7xqUZlXA=;
 b=VtaL7BHAp0uzPyT0snjxEajs7r+7+YGUwH8gOZE8npuU0cdJQXNm0M8IytJdTwp2r8k8z5/QZ1CX7nz8+arXD9Na4HhN9qtyptqNrTpKxR0SyDvthW9voojOacT+LbgI5OTJ5fqbR05LPLsRm+RGYCdlZfiGjrtfdS0MLF+mZIg83XUTyUf1O4R/giq95K/Oatpiykyi/7qPhpv6813bIRIUnyyTdpis7oepd6oidgTIZi0ytH9HzEuDB2i5WkqY/K9Hryvw24k33rim1ePic9zePRssvOIwMglH7UGDaBgHuZ8niUtPPnHi0rBhfLbcI+V3PSwVY3k60lJ6qNYuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mugPGxV6vwcJTn303VlhYLleh78qHVHyv/m7xqUZlXA=;
 b=tFI5jSS40Ld90SKsba0in/Mo8PExB1uEP0TEWHgyvd4fpS9p1PnE6DLnt01vxXBTu0gWRE/bAo901GFOFXWGaLJ/iVUp7cA3xDV15R7J9w5rvh0yrJ6GS75FkghDw8ESt6ZVxZswDS2BluLMBvHR15e3IVXmqGso2rsuKeI0Pvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Fri, 27 Dec
 2024 10:36:23 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 10:36:22 +0000
Message-ID: <eaf008d6-87ec-45b4-9ace-6d499afd140a@amd.com>
Date: Fri, 27 Dec 2024 21:36:13 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 8/9] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <bc82a369d20b82177c3aac97fc5df0d9018c9fbc.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <bc82a369d20b82177c3aac97fc5df0d9018c9fbc.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0065.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::29) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: f626db96-9fa4-4aeb-c7d5-08dd26624ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0kxWEppZ2h3c3ltMkhOS2NleHpOclBLMUpPRXVhNUNKcGFtamF2Z05HZXZs?=
 =?utf-8?B?cXVGdEErWGpUSnFOTHZkWXQzL0QyWUxaUENHaXZTdFZ4eFdPcElveWtxOVcr?=
 =?utf-8?B?c0Q3ckx1aWFJK3JhdjJGanNsbS9qM3l3RmIydjdOYnR2eUs4STgyUzR2b2Rx?=
 =?utf-8?B?OUlORTBlMTBJS1B5MHBYZHBsSVBaWEtNZHplU2x4YW8rMjJHUk9rT1IzWTZi?=
 =?utf-8?B?NjkvWkIyeEQ1RElFY0RpK0NhY1FCOWpJMzRsL1YraENKaC9zMWhORkdUa2Jt?=
 =?utf-8?B?U3BQa1FRcHIvNWNkQzBoVHVCMWtESWdReWh6MmUySkxzQk00aFFKYlVNN21R?=
 =?utf-8?B?WWVxcDI1VjgxamRlSG1BTUlJeFhMUzVOS1laOUNENUZERXBiNDlhTHMvdDlw?=
 =?utf-8?B?a1VaSEQ3ampmcVVzb1BFRUlJYUxHODJKamRHTWhYeVVUTHJQUkhvYTA3aTZi?=
 =?utf-8?B?ZTFPSjF5TC8zS2ZyUkhEWm01UWZHRmhYZ3hmaHRyTEJhZTY0RTRocFVmZ1px?=
 =?utf-8?B?VzlRTmpHL2xyNGhHUTI1U2RiRmZudkVTbkREWDYwT0lvRlJOODB0azVEU0Vo?=
 =?utf-8?B?Z1BVYldCL1NCWkNCVXpkVllqZS9zc2s3Y2Q1RDMxb1VvanJlUjd0Tks5cUJO?=
 =?utf-8?B?U3BKMVRaNXVkNzZIQVZtckxETWYrTzU0ZTViUmp4TEw0TVlwK2tZOG1aR1lZ?=
 =?utf-8?B?V2tnejBHM0FrbkpLanhaNUlIM0QwZEdnOWhwTGdJcHNZVk1hZFo5aTJHN0xk?=
 =?utf-8?B?NDMrUlJRVXdIM1N1clg5WVp4bDBTT1JEMXBnSm1zRW5ZcU9Xemk2TW1mWkdy?=
 =?utf-8?B?cGxxQUN5eVBGUlVVMktybzFvRXdGOWtkVDVpQU80alNJdHNlOGt0UDVCa0Rv?=
 =?utf-8?B?dWo3S1RyeUovbVBPcW1HUi9YRHhEN2NHak1OcWgvSmR3VWliaGZweW9TQ2hp?=
 =?utf-8?B?emRMODRoNzAzMUQ0T3J6Vk1qVlorZ2VCcHUzc0hCejJrbHhaL24wUnZMYVN4?=
 =?utf-8?B?U3ZCMWkvRDNUY01ZU3k5SVpPcnRxMm1GVjEwSThKZS9Gb2hVVnBXRFQweXhX?=
 =?utf-8?B?dkNhNnVXYU9kQ0V1Sm9yV21hWFRsWVYya1hFb2NGcnBudHZOcVNJNXdpTUlY?=
 =?utf-8?B?dnlyU3BkMWhtUEUyNlBsMytCQkl6YjZNeHRWMFE0blY0US9MaFRtUTFCSjhU?=
 =?utf-8?B?ODVTL0JSYjJKcGZuL2Q3aFZYYi9nM0x1NC9aRVRYSGtXZ291M2x4bUxRZTN1?=
 =?utf-8?B?azZJWU95WXlTck9iK0lpQlExQTdTYmZLalVHRktZZWFEWkRIUVJodDU4aVV5?=
 =?utf-8?B?c25mc3c0dmVJRTJMZzhVbC9iSkplMXVIZEFGa3gwWEhpUVE5dGp6dlpjUGNP?=
 =?utf-8?B?MVVVSnF3elFxREtFc0puYW9FbWMzN2Z1UG1yWnhFTDUyVXA1TzJXMFZSL3ND?=
 =?utf-8?B?WEJNRnplUFFpcXlMOVMzNUtvbHhXMlhCRDN4UGJzaE1FSzJsd0d2K05SYVFr?=
 =?utf-8?B?VjUrbVBhUFlvb2daNVZTQ3FTTDRPY2lISWUzbUtFV1ZoT1R3aEpmOHo0TkF2?=
 =?utf-8?B?bTR5TnpjSjlEdGJoQUVEaU5JTUtFSzlaTmltOXp3NXhWV3Joak8rd3YwK3gw?=
 =?utf-8?B?NXR2UVZ2T01wZGtWTUgwZEkrOTU0REFUL015anhORlZoUjRLRE1INTI5N2tt?=
 =?utf-8?B?eHBrN0szRHBnYkxhNUdBZGphQ241RFZSRTRJQXd1VUJtMHpnOTBVNlBqRmhu?=
 =?utf-8?B?SDJpbUVjTWdqNXdtUUhPei8rcFI0dko5b1ZCVzN0clZvUFVKRDE0U0d5TmVy?=
 =?utf-8?B?RkF5WWw5enhnbHlMSUM2bG1jb2pzOWt3TGlpc01PY09JcGNYTkxNTGVmZk9B?=
 =?utf-8?B?ZmpCeGk0RzQvcXo3Rk9jdmpBZzJjVkdoTzJuZ3o4SjZrRVFzN3RkMnlreFBI?=
 =?utf-8?Q?EEQ/qGj74gc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkNYU2QvU080WTlvY2xXZm54dDdwOHhmbWdWL1RkNkprZ0NUQmV4WWlUTlJ1?=
 =?utf-8?B?elAyMlpnY2w0VkV6TWdyOU5ac2hJSHdCaDR0UHYwVTlTN0t1cHhJR1lMM0xK?=
 =?utf-8?B?WkJDeEg4OWRwK3dqZytuT092T2lvbDkvL1VQVkpqWnNoVSttc2ZjSjZqSGVG?=
 =?utf-8?B?UDFjbzRRUENKeGJ5SE85Zlhmd2hLbFVOZWhaSzZ1MFJZZGpzdFdNNGkzV0dH?=
 =?utf-8?B?UFp6ZVNsYmhEZjV0MUZzbG1Lb1pjK0x3M1BDeUt1SFVSc0NwWnFlT0sza2gw?=
 =?utf-8?B?dUU1aU5rMU1sclBZRk9MVVJ1U1I5a2IvSGhiaDczZU5sUHQ5eXgrSUlSd1dl?=
 =?utf-8?B?TEdhNkF3d1FRSzNIWWdnMCswbE50RGlvdUp1cUZSb1FFaEhkeTRPcElUZVA4?=
 =?utf-8?B?N1IzdXhnL2NOcEE5YkZycWhQNDFta2tJbjRTTzJTbDFCZEZxZStCYTVYbkI3?=
 =?utf-8?B?K05KdldqRW5ia09Iem1JUVI0Q3dPcXMvWExzVFY2cVlwRkxiT0ZoTi9FM0hY?=
 =?utf-8?B?d2p3eXh6TEtsSnVrYmJ1ZUNCcGp2NmFaUHQweitydjJERFlCMHIyVlk2dVpY?=
 =?utf-8?B?bE9nMUEzc05BemIxS3NNVERiZ2FZV1Fndm9aZFpLdmljbml5QUtUTmRZSnRm?=
 =?utf-8?B?d28wV1IwelJDM1pTSGdWT3NTOXg2Ujg1aDdxeUVsdTY5anczajJyK1dFNkph?=
 =?utf-8?B?eURPdlZnZXhKYjhTMjFrdmlINGlWZjJtcy9XRVF1UlhCYU0zMStmRkNVZnVx?=
 =?utf-8?B?WFBCL0R1TEo1Rk5leWV5YTZVOWVjcGNxUTBRQ3pNYk4za1Y1ZWxlcEVPbVNV?=
 =?utf-8?B?U1NsWmNWNjkwTEFveEp0c0M5QThOaWtxY0xOM1lFN3JGZG9PVTBIeU1UUTk2?=
 =?utf-8?B?V1NBQlZtTDB4QTJsbk5aZEtQVTZZMDFNRWNXOENKc3lIUmVlUEwxbmFCb3Zn?=
 =?utf-8?B?THE3aXRwU1I1WktUazk5K2tXSXFjdmlZTGlKOTRjUDZwWDhYNjh2Lzg4OThr?=
 =?utf-8?B?Q3ZHbGxsTC9xOTd1NTFBTXZuOS9tdUhFcjZIeGlIOEQ2K3RXK1ltUWNoN2VT?=
 =?utf-8?B?ZGVCa0pGSURDNTdyakZvRk85Wm9ubjdaUjN5dlFESi9nNzRPYVRMWW1pMysy?=
 =?utf-8?B?UXoya0RCU0MvUTBscDFlWHlhNUk0dHN0dHVFbEsvc0tveWJuZmNDNjdKTTM2?=
 =?utf-8?B?ZER1WlcrckZSNzN0U1g3NjdKQjkwM0JabkhUVmE5SVl2a01GMStFQmRnMFFF?=
 =?utf-8?B?dFhCYVhHQWlPOEVRZ2tocTV0ajdKczl0QVVzOFN5MkhqZm9zc29pZEpabW5B?=
 =?utf-8?B?QmcvTU5ZNjB2U3Z0VVVQRlRLekIzVEpzS3h5cHpvemlTblVIbDBiUmlkbVJt?=
 =?utf-8?B?Z3orcjBPcGxnbFlaekdlVk9idkk1Y0QzVEkrY0tlUnU5cjYrMHN5MmdBM28r?=
 =?utf-8?B?RTdoNTF4TEpEZW0zMGhhazh0R0x3WWlGc2pKdFFwaVZqSlBVRDBOTG1IK0px?=
 =?utf-8?B?b3FwRzYxTXdQL05LUTZ6dk5sVmJwR0pCay9JdW95R1hzdVQ5T2hSM1dFL0FG?=
 =?utf-8?B?VGpZcWRKS3VZZy80Y2diaDRtbm82aXZtbGExUkFzenlTVUVQcnc3ZzA3Zmpl?=
 =?utf-8?B?bU1IdSsyYXRsOHFnaHpycmR5T2JYaDNDamdueFZoN29ZcFQxMzJYem5mbFNN?=
 =?utf-8?B?OHltdDRtR2JTYlRiVFJuR3dKYlF1SDJ1ckUzMFdtWWhJSmlyMGlielRuZkdy?=
 =?utf-8?B?c2pzdS9vclhZK1VCYnZzdTJQdzlKQ1ozRzdCeFlpZ2hxb2ZlNllTcHcvRmV0?=
 =?utf-8?B?UElWUzJYeG9FeGNCSW9wN2NyVE1YWnQ3SmFVa3gvNDRtYzYya0RMNGZiUnFY?=
 =?utf-8?B?U2w5czZnM3pnU0FWNWJybzZHbXNHSkdUaUpPdFR3RHViZFo1YmF0Qlp2aGNB?=
 =?utf-8?B?dDI4WFZna1FGQzlQaEMzRWVlMWtXdmNNVnArRHBEazd3aW5YKzROWUpQaVNi?=
 =?utf-8?B?aHJJMWJlVWtkRzVmODdFOFZDM0liVXhxZW1HdjBxbWs1cGxobWw1WU0rcHBY?=
 =?utf-8?B?OWQ3VGVPMWxaS1d3V2RXQnVpSkZQZk1Wdy9Ga1FqU2JCUUNJZERBSlh0NWFk?=
 =?utf-8?Q?+A6tMUzvbmBn1zEmFmqKPoXNy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f626db96-9fa4-4aeb-c7d5-08dd26624ea4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 10:36:22.7583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Q7sJnKSq4N/xhvvKFLatKrN2lc5yMAqLgRrvicMpw2ZgwyO8x9tMQXODxFZOCPInyl4TtWgKrCPVmXKPz+RWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816

On 17/12/24 10:59, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Remove platform initialization of SEV/SNP from PSP driver probe time and
> move it to KVM module load time so that KVM can do SEV/SNP platform
> initialization explicitly if it actually wants to use SEV/SNP
> functionality.
> 
> With this patch, KVM will explicitly call into the PSP driver at load time
> to initialize SNP by default while SEV initialization is done on-demand
> when SEV/SEV-ES VMs are being launched.
> 
> Additionally do SEV platform shutdown when all SEV/SEV-ES VMs have been
> destroyed to support SEV firmware hotloading and do full SEV and SNP
> platform shutdown during KVM module unload time.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 33 +++++++++++++++++++++++++++++----
>   1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 72674b8825c4..d55e281ac798 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -86,6 +86,7 @@ unsigned int max_sev_asid;
>   static unsigned int min_sev_asid;
>   static unsigned long sev_me_mask;
>   static unsigned int nr_asids;
> +static unsigned int nr_sev_vms_active;
>   static unsigned long *sev_asid_bitmap;
>   static unsigned long *sev_reclaim_asid_bitmap;
>   
> @@ -444,10 +445,16 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   	if (ret)
>   		goto e_no_asid;
>   
> -	init_args.probe = false;
> -	ret = sev_platform_init(&init_args);
> -	if (ret)
> -		goto e_free;
> +	if ((vm_type == KVM_X86_SEV_VM) ||
> +	    (vm_type == KVM_X86_SEV_ES_VM)) {
> +		down_write(&sev_deactivate_lock);
> +		ret = sev_platform_init(&init_args);
> +		if (!ret)
> +			++nr_sev_vms_active;
> +		up_write(&sev_deactivate_lock);
> +		if (ret)
> +			goto e_free;
> +	}
>   
>   	/* This needs to happen after SEV/SNP firmware initialization. */
>   	if (vm_type == KVM_X86_SNP_VM) {
> @@ -2942,6 +2949,10 @@ void sev_vm_destroy(struct kvm *kvm)
>   			return;
>   	} else {
>   		sev_unbind_asid(kvm, sev->handle);
> +		down_write(&sev_deactivate_lock);
> +		if (--nr_sev_vms_active == 0)
> +			sev_platform_shutdown();
> +		up_write(&sev_deactivate_lock);
>   	}
>   
>   	sev_asid_free(sev);
> @@ -2966,6 +2977,7 @@ void __init sev_set_cpu_caps(void)
>   void __init sev_hardware_setup(void)
>   {
>   	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	struct sev_platform_init_args init_args = {0};

{} (without '0') should do the trick too.

>   	bool sev_snp_supported = false;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
> @@ -3082,6 +3094,16 @@ void __init sev_hardware_setup(void)
>   	sev_supported_vmsa_features = 0;
>   	if (sev_es_debug_swap_enabled)
>   		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (!sev_enabled)
> +		return;
> +
> +	/*
> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
> +	 * VMs in case SNP is enabled system-wide.

Out of curiosity - is not SNP INIT what "enables SNP system-wide"? What 
is that thing which SNP INIT does to allow SEV VMs to run? Thanks,


> +	 */
> +	sev_snp_platform_init(&init_args);
>   }
>   
>   void sev_hardware_unsetup(void)
> @@ -3097,6 +3119,9 @@ void sev_hardware_unsetup(void)
>   
>   	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>   	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> +
> +	/* Do SEV and SNP Shutdown */
> +	sev_snp_platform_shutdown();
>   }
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)

-- 
Alexey


