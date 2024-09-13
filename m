Return-Path: <kvm+bounces-26781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4959777E2
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 06:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97873284C6F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 04:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3866D1D414D;
	Fri, 13 Sep 2024 04:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ipG14bHv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32001C461C;
	Fri, 13 Sep 2024 04:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726201628; cv=fail; b=haH3JFZkkjbn9Yp6AEQMCCWcq183XwyTDKe7OGqp3YLEAANCh0FOUu8yvPgwREu+bIV5LsrWy1VXjLxxoluZh4Q/Q8FN/MkmuLXaVXiwBf10mJOuaJn2udItlTtXAvx0YL0nr9/M+4Ai11aao+tCs59pTtu+rvs/NOjFwiRqdJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726201628; c=relaxed/simple;
	bh=pJFhok5GOEml9U4cBy8LiMW+QiF1Usy6YYL4stXoHjE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c0QJ1xc3PUMFK3+BcRCk2YRgQoYSClAMT4tNMz2YMPgp2Aztbo+N21FWenqDWZsw62FFQWWw4+WKKpML6jSnocYyte4BZdcfE4YFb24A2c6lDVCAhYmoxVziGhePFVrYviuNieON5N6UgJ8ysBTKnW9tePiv1CoOXrGl+f3Q71k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ipG14bHv; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iizw+EgKco5pijP2Hn4osvvJCHriJ660F60uKp5dCOt6bLj21qANB6OxOpNqZ562OGXmmr8i3xxVmH7izDdnKrObRSCq+SmMBDn0IPf0UfpVmExsP8QAn78QuVmlCPLbZYv4/OYqCH1V+cYznxpQrXbWarF5mDUOCw3VbkXu70G4TpB+EvLWayLebij2Uom7mWgoZWHMRZKyUiObNeiIcucon7r3o8JPUhanwU1zOOn39LoTOiVnh4+jhQUlQT64AoKirPYO5NsyR5jS7EfAdlqbXbuGBLGXJto7x9zXUfzEsSRIzq3J6UazJ1Zf1Ec3J+g25EONqVKB0vb6KwdRaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uXBemPPfVkfH15v/DxLzTOB2Er1JuL18lzcKqsx8/U=;
 b=tW/Goci+1xbJKwNAx9HC3mNtjAe98Z9v7yhE24uq78DULmjPg12FIyiRDd5zRiRE3X4kxJScxvl4OjgxHN9e2Mv8y6FGfz4Np3e6ZH8qz3esKuVy425jiEdvUaKUpemg0eEgs4/xUls1cINWUd+NB8GTxQmfYZB/eGYAZP1gorN7mkINyjTq2a2yaWvlL1Qv2dNUEm7083BFOt3JRUHO8PYY6tmf8/FFPaZyWsJkMtpZy5QnQbW9y2Dly/57C5iS2yH6c5diLOyEvUUgZI1d9V6O0ZMhpnjhbmbGhWt26tFRbx039nJmwHU8PUZI9FNfHGjvq4oYXwQPzu+Pc5ZFLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uXBemPPfVkfH15v/DxLzTOB2Er1JuL18lzcKqsx8/U=;
 b=ipG14bHvLX5CsZ9ORu6KjhVMS+D2GQ/E2cxt49axmqYlU1/x+nTQcu99doV45KCsBLzBe7Dt95lWv3jeXQX2zsoTT8UJAG+H83ycbDoLB2hw1IIQDCldpXcRSVFsiz2dISi/utj6LPXZGfID0g3boFHpdwiLzLNfboFPo87+cpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ0PR12MB6943.namprd12.prod.outlook.com (2603:10b6:a03:44b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Fri, 13 Sep
 2024 04:27:03 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 04:27:03 +0000
Message-ID: <a826082f-d80e-4aa3-982e-df7c723e2d2b@amd.com>
Date: Fri, 13 Sep 2024 09:56:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 09/20] virt: sev-guest: Reduce the scope of SNP
 command mutex
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-10-nikunj@amd.com>
 <30a5505f-8c9c-6f13-6f90-8d5b6826acb5@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <30a5505f-8c9c-6f13-6f90-8d5b6826acb5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0240.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ0PR12MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: cdfe7eea-a2eb-436b-d776-08dcd3ac5123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjBnT1NxRnBCNDdPQk8rMXY0elM3K09oU1RsdDIzSVlIQmQ4TW1qNjlveStO?=
 =?utf-8?B?ZzFFdHE3OWVKejc4d1BuVmxrQm1tVlN4Z09Da1l3bTRia0swa0p2SFQ1cEll?=
 =?utf-8?B?OVI4eEs2blFuS0pMbjBsMWNIODJNMG9Ed1N3K1FjSExBZTdHOUNSbW5lckMv?=
 =?utf-8?B?WnhFK0RIWjdjTWY2REVCcUhobmF3VjhzSkxwMnNZV3ArNEJsdlhKM1hDTlpu?=
 =?utf-8?B?NGdUNGZoczU3Uk1OUjhXNTdLNWFIVDlFOWs2Q2VUUXU5QUpHYU8wb01EUDR2?=
 =?utf-8?B?SzNveWUyb3BMcjlpYktSVFNHZ01pNFRDeThVaUdxNVdqMHVLY0lZZEc5K0NT?=
 =?utf-8?B?TEtIbkk2Nno1aUwwT291ZDlGRXExVU9zeVhmdEZnNldFMWdHQWkyOWoyUVkv?=
 =?utf-8?B?c3pDZ1R4NFR5a08rYTN4RXg4c1paT29YRUw3ZCt4MW56UFp1NzVUQVJsNG0r?=
 =?utf-8?B?d2ZuamI3QTlQK1lkdUo2TnNxY29GbW15eiszVC9aZG5peDhVUnIzbHF5R3NL?=
 =?utf-8?B?SU02UzZqRngvNW9mNEVyUnJxWTQ2Sng4WWFVVS9ydXc1a0NLaWpFWk1VNUpp?=
 =?utf-8?B?OFYyOExxRk5hVFZoeWVYMHJ2UlBhWWRrM1FzWklpTU9qSGJpcGJNM2I3aTlM?=
 =?utf-8?B?ZFFIZHVWNVY3S2dlOXNzcyt6QU1wTkIxMjhWYlVONVVINU5CK3NZczY1OEpp?=
 =?utf-8?B?ZWtKeVNiNHhDdDdieFB0RWdiOGZBVGMrbU1XYzEvUm5TZzRKRU5DdjRtemZv?=
 =?utf-8?B?b0E1MjYxUy9hbnp4U01BYUNLYzZkd2pFNEdVcEdwR2hGbkx2UjVDckxuU1FW?=
 =?utf-8?B?WkNZMG1ITXI1S2ZQN0ZFZ01ubStGdk1Ca2V5VFZ1Mm50TWN6U0VoY2h3Snp2?=
 =?utf-8?B?YW1SaTF3aVh0OGNPWlJzNTRMRDNuTHhjWGk4aWRpRWxCRGpHZlV3bFExakQ0?=
 =?utf-8?B?QWFqNkJLd3d2UU5YbXNzQ2IrWVNEd2NoRGpQWTNnaGxIc21jZlNENE5Xc3I1?=
 =?utf-8?B?dDc2WmRsZHpOaURROFk4NnczWTc1c1VkU083K0FUVThiNWhzTVQ5QWd6d2lw?=
 =?utf-8?B?OURTUzU2N2VOQnoxVkhGVDRaaExZU3N1T3p2YmdYSlRYdlBndzRpVlZmYWFI?=
 =?utf-8?B?UFBmczBpMTArRVo2K1dWa1pOTzkrVmo3ZlJCR3dIUDVEaS80YkdsOFl0VDNl?=
 =?utf-8?B?N0ZGNGdWS2dSU3BpeHhSOGdrbkREWG9jZmQ4UkZybnRUWkljei9ONVAzQlQ5?=
 =?utf-8?B?VkF2U2pOM2IwaG5iTkNLeTIweGl1bTRUQWJIWnB3LzZwaXNGTUJaL0VDc2Y0?=
 =?utf-8?B?bHR0YnBWV2RGbll4L0VxNmJGWExTVTFWamR0WUlod3U5SGQwWlVjM2l1b1cx?=
 =?utf-8?B?bk1oYmNTMWNwZzBncEZ4dDZINmltMU4xeXJraFFETjVqT3gwRmVJVkQ1bDM5?=
 =?utf-8?B?QmJnNXZ6bmt3RUl4cXE3WGorNnJSeWJ6eTZUbG9rTE5WaVNydjVVV28xbmZj?=
 =?utf-8?B?S0Mzc3VweExEQzJ5S2U1RjczK1VpTTRSYzFrektWa01EdmNMaXJnTnllYTFw?=
 =?utf-8?B?eDBmTHZqUGJieHdpZURaQi9TQjl5bzJyY2w1cTJlQWVZUVdQQlZGV3dVTXVj?=
 =?utf-8?B?dVdwcGFSZlc4L1c2OGt2NTRKTkovTkVab3YwL2NJVkNWbkZNS3crNUxhWi9y?=
 =?utf-8?B?RXdWZGIwMGYvNXMzc1RtTm1yamZUeXNvUmZIcWVndGhCY2ZxTW1xSEpiUTJ4?=
 =?utf-8?B?THBYVnJZRzQyVDJCWmhqbzNSYnhXdXp6VTFxckdiYjh0UWN1d0QvbHFTTW1C?=
 =?utf-8?B?aitZdTB5QmpxOHJGZ3k4UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0J5VUhFL1NjbmpPcENLQ2dDd1d1SmJmL1gvM016U3pRRUV5WE5CZ3dqMGdn?=
 =?utf-8?B?eGRBU3dVeWpROWFaOVY2UU5Hck8yQWFNTWlCVHFrV252MFNMUHhyNjRmdm9j?=
 =?utf-8?B?dTU0Wk5lZEk5RkNHeERkNnlUU242cGFaWjZEWEhvZndGRzNoNDF1WlJRcU40?=
 =?utf-8?B?cFA2aDNxN21XekEzYWdtK1JveTZ6SHhZL2Y1RHE5aXRXRk9IM1E3SkJEWFN2?=
 =?utf-8?B?eVF2VWFaSTJoZDFOcnRwaHVnanc1Y1V4RmJZcXdXMU8zZDZQcnNVUGEvRnAy?=
 =?utf-8?B?dVhSczFpekp4SFBkdWszVVNvL0pLUVQ0S0MwMGRjUktBNWRDYTFFQ1EyOHhV?=
 =?utf-8?B?NnV4WnhRNk5sdTY1WGdzZkJhNnhybDc3anR3cHBGRytadlFOSXNRZC9aa1VK?=
 =?utf-8?B?enRpdldBR2tOQ1k5V3VGNnFYY1FKNGNzSC9HRmVpOGhsVnF0VGZtKzlJSW5Z?=
 =?utf-8?B?M0FuTzZuU240Um90U21VK2VwUWpiUG9pb0liY05YdjdNbDdvbzdRRXlVZllY?=
 =?utf-8?B?a1NRNHVuL3RBRXZkRjlUUktYTTBXeVNlV2xUd1ZQaFA1YXo3SFg2Rk0rSFBo?=
 =?utf-8?B?NDIrMUpDSlc4TTVXeVNJazhFY0VwSU5uSVloa3JYMVUxU3FmRHljTVoyY0Z5?=
 =?utf-8?B?dUcvaTlWUit1UzRhTXRiNEdSeTB3ODNERnQ4THp1REVQVHBLMHZaSnVXd3c3?=
 =?utf-8?B?ZmpGbStLZ2RNU2lXR1YwWkhQY0drK0xkSU9lNXVvazVUT0JOVHBielFoTUZ3?=
 =?utf-8?B?MW9GMElNNEZ6NXNGeGFoUE94M0FNM3llaGVuZlFSSkhnV2RNRlpma0VoLy83?=
 =?utf-8?B?Sld5MEo5ZzExdXBzZXVoR2VyUjdSK1NEbE1MZnVsc1hsNVN1c29lbDRoNUxO?=
 =?utf-8?B?NHVzMFdyRndCSDFZMjk1UG9LVmd1Mk9ORUY0NWtDTjN4djNxa29UNS8weGlI?=
 =?utf-8?B?ZmZHekh5R3gwZWFwMVcvbXU2K2N6TkdTdiswUkJiVlVrSnd2N3FqNTZ4dERL?=
 =?utf-8?B?dW5xbWNyNHRTeldYNFlkNFpiMUk0aXZWVE5PZ2ZaNHBVZmJ2NTJCc2xxazdN?=
 =?utf-8?B?L3k3eVV5M0Nid2QxdjJDK0Z1d25WeFJLcXJGRE52Nk9raWlOSzkxMkwrYkJj?=
 =?utf-8?B?Q3REZWwwdTRpQ2JEb2pmSGV5djQ4OFZQUW1mWExYZVlLSWQ4SWFBOEU5MWd2?=
 =?utf-8?B?dWswd0JmM2J3cHR3Q1cyREd6M0U4VC9MNmVRN3gvdy84cUlkTEY4dHFRQm9J?=
 =?utf-8?B?UmRtY1MrbW1mbWIvcjNhSGVRZVNvTGJ0blE1ZUtPM2pqMStBOGtWYTZteVA5?=
 =?utf-8?B?ZkRZenZVT1JYenZCa2tWZU9rQmgyTTQvTFV2WTR1Y21WbVRPSWJqZm8wcUh0?=
 =?utf-8?B?aGptbzY2ZFh5bExDbTkvd2xrNGR6NjZSQnpwZDNsQlgyTFlnQUN5SFlYakVh?=
 =?utf-8?B?dzRsVk1FN0NPaG8yVGFnaHdrMkJtSml6T0JuT0pScmhPMDJZNFV6bWwyNEtR?=
 =?utf-8?B?Tm1XRjhyMXNsWUZpa2FjS3hmbXJYUnN2RzFPbEVpajVmS1VsVmRaTWRQbjY5?=
 =?utf-8?B?dU96ZnRPd2FNK0VOTmc2OFFvTDcyWElFYytuVTZQcGVwZndYYnhJY010USt5?=
 =?utf-8?B?eDVtVWhmSldiTmR5K2ZCelp6emJVbzduU1J2ZVJRVnJGekFZM0JpSFJwK2Rv?=
 =?utf-8?B?dVU0bFZFMW41a1IyckhYNVArS0paemh3THo0dGVFTnZPOHJqSVMvaVVrZmtD?=
 =?utf-8?B?RjRZclQyM2dhTG0zdmpFaGVuWDVxZjhtcjRyMExoVFd1bTd0dVJBRS9HN2U5?=
 =?utf-8?B?UmhzRFFyaE53V1M3N1Q4ZVpteE9aeHRkSEdaWTdmYXFNdkJPbkhCeXY1MVB2?=
 =?utf-8?B?SmZKRWVDR250QWdCaElhaTRHMGh4VXFBS2pTVzZkRm1HRUkvd0VXaEhCY21m?=
 =?utf-8?B?R2hmOExmRjFNa0ZpWlp1YjViQk1DTGRNajJsdk9Wb0E5YldZYURSWjFEalJP?=
 =?utf-8?B?bDVSMTZQV0FvVDFOUzkrSWhGcm1kT2x0ZzNkZ1R3VmQ2MVJXNDB6V0RTNTAz?=
 =?utf-8?B?NE52bHdjWnB1QUxyU0lrQjBGWjBkbDVheU9NUXN2NUYxNUtHajBQMElpMllv?=
 =?utf-8?Q?BBcJm94OEvao1458Vqp0CBSwE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfe7eea-a2eb-436b-d776-08dcd3ac5123
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 04:27:03.2382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/NnK5bWT/XIWlFWABbFLXcega0Ft9flyO9dNpIv3Q8HwVIB8a5JDK95gZl5hDNYSTaL62UWX9fxYZLAOe8mNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6943

Hi Tom,

On 9/13/2024 3:24 AM, Tom Lendacky wrote:
> On 7/31/24 10:08, Nikunj A Dadhania wrote:
>> @@ -590,12 +586,9 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>>  	if (!input.msg_version)
>>  		return -EINVAL;
>>  
>> -	mutex_lock(&snp_cmd_mutex);
>> -
>>  	/* Check if the VMPCK is not empty */
>>  	if (is_vmpck_empty(snp_dev)) {
> 
> Are we ok with this being outside of the lock now?

We can move the check inside the lock, and get_* will try to prepare
the message and after grabbing the lock if the the VMPCK is empty we
would fail. Something like below:

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 8a2d0d751685..537f59358090 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -347,6 +347,12 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 
 	guard(mutex)(&snp_cmd_mutex);
 
+	/* Check if the VMPCK is not empty */
+	if (is_vmpck_empty(snp_dev)) {
+		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
+		return -ENOTTY;
+        }
+
 	/* Get message sequence and verify that its a non-zero */
 	seqno = snp_get_msg_seqno(snp_dev);
 	if (!seqno)
@@ -594,12 +600,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	if (!input.msg_version)
 		return -EINVAL;
 
-	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		return -ENOTTY;
-	}
-
 	switch (ioctl) {
 	case SNP_GET_REPORT:
 		ret = get_report(snp_dev, &input);
@@ -869,12 +869,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		return -ENOTTY;
-	}
-
 	cert_table = buf + report_size;
 	struct snp_ext_report_req ext_req = {
 		.data = { .vmpl = desc->privlevel },


> I believe is_vmpck_empty() can get a false and then be waiting on the
> mutex while snp_disable_vmpck() is called. Suddenly the code thinks the
> VMPCK is valid when it isn't anymore. Not sure if that matters, as the
> guest request will fail anyway?

The above code will fail early.

> 
> Thanks,
> Tom
> 

Regards
Nikunj


