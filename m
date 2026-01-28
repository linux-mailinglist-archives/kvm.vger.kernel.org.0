Return-Path: <kvm+bounces-69415-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEznLf5yemme6gEAu9opvQ
	(envelope-from <kvm+bounces-69415-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 21:35:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBFFA8A2F
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 21:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8F52A300830D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF6D37473E;
	Wed, 28 Jan 2026 20:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MPOwM6+1"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011014.outbound.protection.outlook.com [52.101.62.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38F233032C;
	Wed, 28 Jan 2026 20:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769632503; cv=fail; b=Kx6lpIUHu80yO5wQ/iZHJzWvdLdMQbvqIdWtXyaf+5dVzwavgYAFcLuBcWNTXL27i7awen1b+aiWtmRAU3sc8WyvQONc2WXUk7okEjg0ZPl37Tv4fdxm7GKxsoJhJR8mX/Ygcf8MXFnF1ddyHCiBSpdQ31Cx/dUTEl61nZa5m8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769632503; c=relaxed/simple;
	bh=bnxXB3dlUTAT+zMDgy+9pbMZSFSeEjrjyA9jada7EbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z0d8W7Vu4338qLGOZR9b6XcxyLYBSawJZMSHM08kgReQG2MQ32YOFgh7yfrDb4sHceHgI2DS6MNyzS3k/3Sn0oDarVg46v1cU4/yKpMhnR0ZezXPPPLJNLTNjFusNjQp1f/DCe2xC8WAmh/BZxaM27fWmS09bId/xglwYCcgfaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MPOwM6+1; arc=fail smtp.client-ip=52.101.62.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIaA7vdIdosqqCANDISPITRLsoAfkfaTX0PzIkCrtRehHji4x95KeS7RAbak/wQk8qbU1XsNe5aFZy/pB9yyMCzD6PICBxHFCRKOs8mp9OPIlfFgusvRmTGYGelj5FB8TCtYY4ue8h/Cyv3X8UdgnEXmA34gKrCImovyr+uAxhRcx5aJ3QGgSiasDaT5MYW5VjF9CrSf9n3ks9w86/+nWvvVcyaCjGQL8ixUiW5ikXKFVCINe8xOVS4njAccGpkxpGN8jrYZV2KZrGM2GjoqzO88+Vqsf5qIgpupV7fO5kbhvPQqkO8xGNholwkhdKTv/Ox/Ebx8Dc2t5AzJYQ2ETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1H13YaftQ5/eYamYiUwTmyI49IBKMiMF6KS36wR8LkU=;
 b=FtIe/fE60XewspJ1PLFHyy8HEgajEmbqdmKrAmmUCSGmN86y2R0uNbvI3wjAWoPikKp/qaRp04vxr0TwQKJrgY8JjN1T8hE85lM4m068yjF3wPfz5svi8b1X7bq6+x0RJpST2j3HdE3HSrT9beMeA0sQoBf25EIta8YmIpV5tvcVE8C6kC0m5k6xiY18mSoQhVkYpAgXWy4eNbaRoxekNjXm5y3PwklRUL492HlWNJOHOgle/OPjocMd25P1qlALN5fSAmcfysti4h4EGOuQkcol86WaNIjJHgSFB8kmezCD4NAwXhTJ+0YH6GzoSe91v2pEyYyH/NBin+iipx3/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1H13YaftQ5/eYamYiUwTmyI49IBKMiMF6KS36wR8LkU=;
 b=MPOwM6+1gFsKYK7ow0GUHfUb9W7tLgJiMTmbwHme412i4aNrPMe3NyZycwS0KScQOE3iaZ405sTFq1dPij/nWscGW9649slU4fS1Efhiig5AScIm5vE2SbW2BjnL8Q/xQtUtE5107A7p/Bw1xcSicLPK7bUys9zDyqvQf6ccZ8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 20:34:56 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 20:34:56 +0000
Message-ID: <ff28b3dc-a695-4569-a7c7-6fb0db90bb40@amd.com>
Date: Wed, 28 Jan 2026 14:34:33 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0135.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB6032:EE_
X-MS-Office365-Filtering-Correlation-Id: c799ec45-fa5d-4812-b8c4-08de5eacb2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzRGWTlmUW9tbHJtdW81SDEvZFRMWlkvSEk2cDk1SkJlMklrNUloS1E3UjhU?=
 =?utf-8?B?K2xxN2gxRHdTVEtmaVpUemxueGVtZDFYL0RRYlF4U291VjU1elBKemZudFJq?=
 =?utf-8?B?c2NoU0U2TWpiRk55TXNJNUdEU1E2eFlIbkFrR080QUc3TW1oN2tUUEVTdW5L?=
 =?utf-8?B?c2ZncHZSNzRDUnNPSE55QmlESFovMjM5NVNaVzdDVExDcjJadnlPLzFEL0Ni?=
 =?utf-8?B?dmJUVHNGMDgxSzVPbkFmTWpyNFFyTzA4eFdlY1lUbUlGV0k0dFdKQm5lOFp5?=
 =?utf-8?B?emFGMDdTRWZDdFpWUGhLRGpRWW05dEJjRERwbmVLckROR3NKaWpkaFBjYVdx?=
 =?utf-8?B?WFRTa2gxS3pBZElhWUkwVXNWTXFkWGxxODlJZ2hNc2FNVlovaXY0ckZTNSsy?=
 =?utf-8?B?RWdVVFBxaTdWckUwUUF4cWo5OFdTWFlSeUt1SFRwTDJXY1VVK2lrU3NYU2FI?=
 =?utf-8?B?RTc2aVlTOEsvZUlRdUQ3dFdLekd0M2xxYUs1d0JhdVEwbXRrbjZmSm0vWHQ5?=
 =?utf-8?B?L3JnQlVRRWFpb2FpTjBtTnJtM1pPL3ByeVdxRXF1Q2hPWHhWdmgvanhUUFlX?=
 =?utf-8?B?aHRGbmtvNllBMVZ5UTdtbEpiMGI4cW1YVFlzTUpNMWo5Z3B3OE9CZlBYbXBB?=
 =?utf-8?B?UWEzUzk1SUZmZCtwZ3lWRVRTVHhZcTFBMW85c2RGRzQzaXNiQWRpcWxUUFpy?=
 =?utf-8?B?WDk2ZEVLVXU2bkhCd09BOHhLVENNdE5kZFRhNTg5MkdocC9idGxQSWFhVEt1?=
 =?utf-8?B?Yzd4RGlweGQvM1Rxb0pPK09sZXlWRTJmSjdWaHZhaGNBdHhrYkVzcXZjZHZK?=
 =?utf-8?B?VEJUNEVzY25XeDUyajNBTW9uYkpQa2pmaGR3Vnl0NTZDMTBoZ014WjFhSmpy?=
 =?utf-8?B?ZEhDMllmU282WGRESFBINkVRbWQwekJQNzV0TURYV2ZXL3FNYnBVNzJWdE8v?=
 =?utf-8?B?K09scVV0ZEJTQlVzZ25Mb1gwZm5SZWoxRGpWRzVaV0RQaUJvK2JvMzhvbitW?=
 =?utf-8?B?cjM0TXg2ckJ1aXpRTWpDaS9HdGFaYnlSSU8rVDIzcXAvbEdJbmkrL1RKZ2hh?=
 =?utf-8?B?Q2FrOUtYU2RRd0d4MXcvbjFFelJqdi9qYnhYR0wxSTJEbGNBZ3F0U3c3Zk02?=
 =?utf-8?B?Si80Q0xicW9HU3BJRWRLVncxaGhUSGE2K2hKSUlGRDB3NUFHRnZ4aWZiZHhD?=
 =?utf-8?B?Z3dMUzFjTUNLWmNBTGc0NndlT0E1RWRiZVliYkwvbmRsTWxBYllzUUxjRGxL?=
 =?utf-8?B?TDVxVmlJWlJ1Z09hVms1OS80SHFqU2NxSXBKaE5DeUdSZlpvRzhNUnpWSnAz?=
 =?utf-8?B?cGJwRUpwcEh5ZU40anQ0aUgrWG01bnB3VkZHNXJISjVYbnFWeWhtVk1DK2JI?=
 =?utf-8?B?ekVadFlQcGYyYlRYSHBDTDdJMVRtVEVQeVRXWGtteFVsbVEyQms4Y1pUSGR2?=
 =?utf-8?B?eVlTaTYySE5jUTNTa3BuVlg3b29NVWpMdjJpQTVHWENBbkQ5ZDBYS1FMZW5v?=
 =?utf-8?B?THJxSTk3ekVuakNiaXM4cHllK21mcXJSdzU1dWFSWnJTUk1ReExhQXNmL0Ez?=
 =?utf-8?B?ZE9NNEdHR2RTeDJmZzFLMFByYjNJd3dRUnVCRlBpTjdpcy9yQ2NMc1ViL2Ey?=
 =?utf-8?B?dGZBRVEyTnNFbnFINnNJd0Z3eUNGdnFpN05wRlRMdXFvL1IxNGVWd3l6WFVI?=
 =?utf-8?B?M3haOGE0ZXNNTlpCL1F0aS9TcGJUUVRueW9PMlU1WWtHUW01NUhmRUtEOWFa?=
 =?utf-8?B?VGRpMmNMSW9LWExERm5haTZnQkk3K3FHN212WkRnbEp2QjdpcHJSeExITStR?=
 =?utf-8?B?R05rV3dUaDVtS3p1T0JNb0haN0V0TWxJeUZ4U0JwR1VFTDM0QjJvMTUvRGhC?=
 =?utf-8?B?bWNkbWZCcGJoaUxaSXJraWZKMDlSUU1aRlFJRXhYREozWTJncm8rMTM5OTM5?=
 =?utf-8?B?TnVLUkdDeGl5dzVJazY4ZHBmOXpSYkptd0VRMDR0d1U3VExnZ3h1a0lKeW9p?=
 =?utf-8?B?bDNsdnBoWUFRR1JISVY1RHVMbTZrTDI5YnZsMExmN2FEd01nNFViRUxnNld3?=
 =?utf-8?B?WWI0SllSU2dnaDZ1TnNQVXQrYkVkaytvT3dYNU8yWXpYdHZCKzJNZWVPbWta?=
 =?utf-8?Q?1g0E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXM3MGVpT3p0dHRJb0pIbzlpcysrNVBFUU5scTkrRHZHWmRnLzBKbVk1Unl6?=
 =?utf-8?B?ckhkMk5wK0FiUjJSTEcrU3FLTUQvdndRQ2E2TzBnZm9HNUIvZE8zdGE3Kzk3?=
 =?utf-8?B?emxoaUFKeUN1NGNlMDRyaU9DdnppcGpjQ05XSG96QWVWamNLbWNWUGZVSXJH?=
 =?utf-8?B?Q3ZtMVdieU5pVFpraE91cmVSYzJvZjlHZVVKTUVNSjl3RUl5WWRnelVCeENB?=
 =?utf-8?B?cWR1Qlp4RUt4SUhqajVScUhhTC9DcUhPRDRUa1JlbFZVZDhpYnF2ZlZaVEQy?=
 =?utf-8?B?d0NNZ0JLVmJMWGlrdmlHTTdsZjhpVmFMbGlLUjBRQ0VkUllCNEk2QVlIM09T?=
 =?utf-8?B?NlIyTUgvekNQbHdSNkZNYVliQi9TYmg2ZFhlVGNhamdINkRSclFXYys3bUhy?=
 =?utf-8?B?NmV6MWw2bS9YUUdmWnl1SWtmUnp1SnVOSkFVWnk3ZVJXN2dFTDV6MU9wdnh5?=
 =?utf-8?B?a2xtSmNDcVJOTzNYNDdZU25aYnBWUklFMWIzazc4YW5QL3QyZEtMVWxSTDBU?=
 =?utf-8?B?WEdjeHpHd29FZ0VHSnN6NVpqZzBkSzE5QWU1d1Jtc3N0WE1BMnlqMTZXMDhx?=
 =?utf-8?B?eFdrTUxBVis4ZkN5TXEvZ0ZDQUMrMGNLTlZRbE5pdnQva3RNOENwS0c3TWx6?=
 =?utf-8?B?bkpUY0dWWUtVeUE4TzB2QjN4cG5Za3h3aG9YT1FqVEp2bmRKMzJ1SE00V1Ez?=
 =?utf-8?B?bmFYQ3ZIREUrTWw0cXJaOGhuemp4RjdjYVQrUUNsbGozdEduVldiemFJa3VJ?=
 =?utf-8?B?M1hwRHlxc3U4allXYldZUlc0RGdLWFNFWlZoZnFhcUpuSVBuY0RVT2RlWkh4?=
 =?utf-8?B?clBmTkhwV2MzRzJRbHI3QXp2bDZkQWx1MkpIeGRQNGhOSmxjZWR1VlNod3Rw?=
 =?utf-8?B?TGJyeDNUcnNUZnRaSU9ybnVlTys1aE5nNTU0V1NaMllYTXd1UjQ4b2lDWU9O?=
 =?utf-8?B?aFAybHNMM1hDaFRLQ2NSYzE3QWMraFVrcjNUK3JyT1FzZnh5aCt4WGFDZi94?=
 =?utf-8?B?bUZ4NzJGcUxDdS9ibHI2R0wvK0M4MGQzSjY4L2tkYTdPTnJxQjczcVM0UDMv?=
 =?utf-8?B?YmhOdHNTOVliQXBoZnVxZjZhVmQwY1lzMjJsdUl5c2UvYlVHemtXYmR5UU4y?=
 =?utf-8?B?N0taZlpxaWdQdWIzNTNFVXRGdGhBNFA4QWlHakRDZm5jMGxxR28xaXBVS1ho?=
 =?utf-8?B?Q1E1TEwzajdqNXVKQmVJTHB6UGo1bXpINEQ2Z0lXUlJrT3VUZ082NTlxSktG?=
 =?utf-8?B?dFF2M0JyaW9mRkxVdk1LKzlHdDBNUTJLSHhpMkk4R0ZXeGRyek9UMWszK0F1?=
 =?utf-8?B?c3pjMUMvWG5oTFlvakZ4Zy9Vbzl0NE8rRUNFdEV5Qm5zclhteXU4WThzZW9H?=
 =?utf-8?B?NzVRQjdneXpPalplbUJNVFkvN1EvcXBXU01lVElGbEVoUmhZSWk0UUJOL2lF?=
 =?utf-8?B?eFE1VkpsSE1QVk4xYUIrd1IxRmVjZURMS2dPZDJBa2YycGorOWM2VGxXVDg4?=
 =?utf-8?B?aHZTdjJndE5QK3FFSDlleTRFbitFNG9sbzhtN3VXWDFSMnBQSXlXSEgyUXBP?=
 =?utf-8?B?RUFkeXNiL3VzdEcxT2VZbjBHbFNLTWh5eFFlYUdLeUthOTlNaG83V1M0aE50?=
 =?utf-8?B?RUJ2QitYUjQ2b2ozUys0UytqenVTelhQM1Q3U2ZYRGlYbkUyNmVKTWVpOENU?=
 =?utf-8?B?RDV6cE1pSnZPMFZHRUR3aUZ6NGNpY2dWYTVvRUExb0pxV0NOZ2JFc2lHNERw?=
 =?utf-8?B?MEc5UUcxeEdIY3p0N3NkWUdzaExBeElHNExJNU4zT1lsem81V3dIdWZ1Z2tm?=
 =?utf-8?B?TUVRWTJub2daNlVMdlVPcHRIYWFaVUdhK05FU25pZlhXMUNaT0RldC9ZT1Fm?=
 =?utf-8?B?NnFyY3JTSWJJOHJXTlNnTnV2MkwrYVRuRmJ2YkJ2NTE3eXg5cmpJU3NoMTlM?=
 =?utf-8?B?S01kSmNXR3R0T0ErM2QrbzlVdGo5STQyOU9IdGZ2WW11d3JLS3dpTXIwZWpP?=
 =?utf-8?B?UTA1L2JTYXdweTBPVmRRekFDL29yMXNtR2IxaklGeUlmSXJJUEZMZGNORExM?=
 =?utf-8?B?UlB1bzdSekEwNU9WazAyWlRaemluOXE1TzVNaFVSTWJlZlpWT2VyM0htOG5Z?=
 =?utf-8?B?aVZyNm5WUFJsb000TXRZTktyZlhmRmV1eHlwREVCYXR5SmI0Mkt6NkkwZEhh?=
 =?utf-8?B?cWlEQnlYdXp1dm9pUnB4Qi9nTVdiTkNQR2dRRG53bm0zck1jRFdqOEVGWkpP?=
 =?utf-8?B?SWFwZXpwaEpDVk41OUI4ZVFRYzVKMkdOK3Y0RWYxUTVycklQZ1JDdDV6NFZv?=
 =?utf-8?Q?42REmK3ZuJfmEF9dGi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c799ec45-fa5d-4812-b8c4-08de5eacb2f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 20:34:56.4768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dSZhC3Z6g45A39pj8oslXZczUmfWPy2PuIdhoE7Z0HIVkx/GvG0p5KeLcjQflf6I/liYDYS9BpZ+LKBKICXRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69415-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 5EBFFA8A2F
X-Rspamd-Action: no action

On 1/28/26 13:49, Thomas Courrege wrote:
> Overview
> --------
> The SEV-SNP Firmware ABI allows the hypervisor to request an
> attestation report via the SEV_CMD_SNP_HV_REPORT_REQ firmware command.

The code looks good to me, but you might want to reply to your cover
letter with more of an explanation as to why this is important to
include in KVM.

Thanks,
Tom
> 
> Testing
> -------
> For testing this via QEMU, please use the following tree:
>         https://github.com/Th0rOnDoR/qemu
> 
> Patch History
> -------------
> v5 -> v6:
> Fix typos issues in documentation
> 
> v4 -> v5:
> Set variables in reverse christmas tree order
> Fix and clean the rsp_size logic
> 
> v3 -> v4:
> Add newline in documentation to avoid a warning
> Add base commit
> 
> v2 -> v3:
> Add padding to structure, code format
> Write back the full MSG_REPORT_RSP structure
> Remove the memzero_explicit for the report
> 
> v1 -> v2:
> Renaming, code format
> Zeroes the report before returning
> 
> 
> Any feedback is appreciated.
> 
> Thanks,
> Thomas
> 
> 
> Thomas Courrege (1):
>   KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
> 
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 +++++++++
>  5 files changed, 132 insertions(+)
> 
> 
> base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00


