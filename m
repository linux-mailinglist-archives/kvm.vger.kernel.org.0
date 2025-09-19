Return-Path: <kvm+bounces-58170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED904B8ABA9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 942911CC5439
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6957126D4C1;
	Fri, 19 Sep 2025 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B0qcpMtw"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B7C22F77B;
	Fri, 19 Sep 2025 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758302333; cv=fail; b=OYoOAVIco+lZPNPuvW/pYtzo+dgKuZKUy9xSe3K3qZMg6bdQkHA2chhqLfXHtabaHpE3M1SinBnF07hI/ul5wgkh0vVJiln2Il6thctSCPK0LrfbgU21giDRU09Kr7bTxdp6llR0birBmbqXOqnJl+rO0jLu4xp9YORbnv089/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758302333; c=relaxed/simple;
	bh=UsTHDIgC080mqZWWpSgeKQLitzdSQntZXRuD6RnA8Bk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=swvsLdqDvHjggq9xr5lr5Ekq+6MRrMCfOApHkXtdplHt04bBcwJnql5p3F1UCjXpRBZ/1g1UVEk5w8r2vtK+FaNeQTycOARLBvOlzVwpmc3TinTo0lLQms0nk8Sy0iHWiS1tgGDwTs7vRBEwsEJVFTpbt70lmcYVp3r83CkW0Ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B0qcpMtw; arc=fail smtp.client-ip=52.101.193.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vbZLnpAqkTIzF0i7JPBZvByOAfQLbRfz8hMqM0bKOrHiAZdq3DvtW3vPZrNZXbSg2E+1nBh3IXPw7KQakmc/vTRf58NgYWddjE3rkMindeOSCCV7JJNW+6aIElx/MG6EDTrFmr1qbv9MlzoILqcHfas1ZPQqy1t+9270M/qXRGwckBwYliRzfCi0GyxQ+Sd+Wiss6Mw828CePCGOuky3c9hA5XcQMMB8k5tmQMOJfzZEOkoD6lYqzIod3lOdQFHsBcaDYUdJYi7ptPswu1fOnsx0kfXMVUKO9X+IFlhCfzoh8HlLDLEEhCk8hHbqQEI1OVtxjiia/huVJblBI9MaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNx5jqWfBo2U4crlQMKeNKFLiUkvvbRsUl2nkegLqaU=;
 b=p7N3KDp6RTK/MGcel5x0OD8laU29wAESUQnumAU2luYkMvL/jn3rizFTgBLyQvRstP0N6Dyj/cMcTKGiGkmJgSMBy1TlavmCCJgWTy4X5YvUYLOcPGGiAzhAgjwv44oIlxw9hz57vWKpDalkj1bwwTnzIM0kwOUTY/KAHThQljrk4hTMO5gIg4hzI4eAPXqoHr58zmaIxzo3HeVjr4/72YftTjbIZiIqZF0XGtbxAx2n+B+MtwJq9VFNE04xiVmGgN0RvnfJ5NOYH3Grh7ufSrGpQnLIWKS/E3xEiEdu57rOgET4f1fwNeoZOTj2exoKjo1RLBBUPTA7DpCJiSzLqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNx5jqWfBo2U4crlQMKeNKFLiUkvvbRsUl2nkegLqaU=;
 b=B0qcpMtwB8wh2mE3LQc/cbDd4se/wX7ZYBnDOKFfT+4IR9NoDZYU1uQsexAKfwECVBuQwhMT8jZjnFYqkhIqIXLLEfyPxb4nrInOL8q1XDOGVxh9jDEXkFKom8mz/3nF2wSJK4G6uAewEzb0qWPZuf0PPFVomJEYMi5Wo9Y1ki0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DS5PPFB297DAF97.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::65d) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Fri, 19 Sep
 2025 17:18:45 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 17:18:45 +0000
Message-ID: <f58d300a-45c2-494b-98da-17ce7105b3c6@amd.com>
Date: Fri, 19 Sep 2025 12:18:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/10] x86,fs/resctrl: Implement "io_alloc"
 enable/disable handlers
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <c7d90ec5ab2c96682b6eca69b260631847061a61.1756851697.git.babu.moger@amd.com>
 <81d4fd30-9897-4322-a8af-a78064d238fb@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <81d4fd30-9897-4322-a8af-a78064d238fb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0146.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::28) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DS5PPFB297DAF97:EE_
X-MS-Office365-Filtering-Correlation-Id: aa17881c-2551-4b4d-6b01-08ddf7a096d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3VJeVRtU0M4aWxFMW1qQm1sV0d2N2E1TDhCWWdTM09KOUJnanBvY2pVTXJw?=
 =?utf-8?B?MnJPdHR2YVlUc3EvMUdSa0dGSHhscWpmbGZ2bk5rTG43MmhTeDVSRWRaVjk5?=
 =?utf-8?B?UVQvYmJkVkx5OXhLK2pJb3F5MWVoNHk5aDhIREdnV2Nwc0lMdXNHdkkwOWVF?=
 =?utf-8?B?dHV1dXFUcE5DRDJxWmljWWpZUnhNVEpkN21XVmRaenNjc09lYVpJTWtwWG5F?=
 =?utf-8?B?eEdOM0tQdy9qT3N0NE1CY29LUDc5YzJ1aXZVUkJBU1JyWlRXRlhiQVJVVDNi?=
 =?utf-8?B?cVUzcEVVcVliRXNYdndFTnEwR01qa0FGdmZWZ2RhS3lTdUtpRW0wTjR4VUNI?=
 =?utf-8?B?TkUwQ0dWakJVNVRRNGtZL0Y5TzlmOTlsM2gzSlo3SFVFUS9nY2lQV1JVd3BO?=
 =?utf-8?B?L1JMQk94RXFsZCtxaWg2aEdQMGdHL0hGS1p3WW9GSm5mVFp1QnJPRDhWTUJm?=
 =?utf-8?B?dzlJRVNwRkQvejZSYmhnTi9FczNKd255a2JMbW1VTHlsZjliOElBa1JGYVV6?=
 =?utf-8?B?YWs4T1RxQXFHVHhVUFZWdlgvcTRBUjRHZms0TUwvRSsvdGFYd1JTZ2NwSE8z?=
 =?utf-8?B?b2p0TFdwVVpwanJmclJkNGJ2cWxJalphclNWaXhuWElqS1pjVE1xZlEyNnB2?=
 =?utf-8?B?OHBmMVpyTkpZM0p5bnkvcEN0Mm00VC8veXhzQXEwNWZ5TlUrZVBwdXAvSzJo?=
 =?utf-8?B?eWI5SlpkeS92Q1UyWXMxN2JyNlpzN3h2MG9zM0FKY1QxUjBoYlNtZDBEbXJH?=
 =?utf-8?B?emdaZFl4UExWTzVnZTNVVTFobmtLdDVYZ2NsUXdvMUhuRjREU0hueE00a3ZW?=
 =?utf-8?B?c1VaSUpSK0RPRkFKZUMxV3N6YkdsSmR0blV4d1JxT20vcjRrUjVVV1puUWk2?=
 =?utf-8?B?dlFLcllXWTRweDRxdDVaL2JkdTVJUUhvUDR1YjUrZFlNR3UrV1JRQncwRWUz?=
 =?utf-8?B?SGdxZlIzNkRTL2FnbWM5WE92OTY5ZEh3dWJWWHRlSHVxaFd3ZGJMRGFTU2pF?=
 =?utf-8?B?ZWlvOVNNdmJXaVRjV3d4SGtvVDl6elRhb2tsOEdQc1dla1NCc3BaSVFqYXp0?=
 =?utf-8?B?Q2ZobmJYbUFmUFRZQXN4dW5LRUxWSHhrVDlwSTdrck9reWVEU0k5dyt6OUtN?=
 =?utf-8?B?aWNxNHNaOTdBMWphVVhyTVQ1RHE2ejVuR3lKYW53WmZnMVYxQk1jeGlmQW9N?=
 =?utf-8?B?L1ZycTBMRlcrUFJnNWMxK2lRVUZZTXFtNFdIWEUrWTJIaFBYRnlpQlFETThi?=
 =?utf-8?B?cEk1anZwU3liY2E5L2hQK216ZlpXdmRaTzFCOG1DcXllVnk5TjlZRlNxWGZi?=
 =?utf-8?B?RUJnSi8rNGFKUUdZbFBLK29tb1pxU1kxbjlISWwwQmZBZFB6TGhXaDcvSDNj?=
 =?utf-8?B?ZzhWMjRFQXFUNWc4dFFIRHlubkhGN0FCbVhFT210Mms1RHd6Q3Z1UGRveUc2?=
 =?utf-8?B?c2k3d3g1KzhhMlZCTDRxK2lhbTdOeVRXRVpYMUxXTUlLQWdTa2FBa0lEdDdp?=
 =?utf-8?B?UHU1bXlycHYvWU1FN2dRRXpEakE2ZDRGRldST3NydVh6TlcycnhIWitCVlU3?=
 =?utf-8?B?c1dRTU1ZTGFRVWdyNlptcWprSHdZUW8vUDNjVUlyY0h2WnpRZWw5VTNDQXVJ?=
 =?utf-8?B?bTFiZlV3a2Zzc3BsRGJRL1ZxZ09BWGxSUFdSQ1NwOHlPL1pJUWRJcVNObUUv?=
 =?utf-8?B?a0ppMEY5aUllSlR5eC8xTHRKZUFVbi93TnAyNVhmS2pCMXhFR2Q0RXNtQWFl?=
 =?utf-8?B?SkJOeWRXMWlGK0tBeC9iRjE0Qk1GRGZTVUJRNkYwdW5kWjk0bVNKcGl2T1c1?=
 =?utf-8?B?QlhEUks4cThseEs4ZVhmSlNHWW83UkZjYU9rMzVvaXZaU043UDVhdTUxUlkz?=
 =?utf-8?B?SC9odDFtNWNBaTVHM1FTRk8ySGUrWmlZVVBxMERwZ2RROEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEFkL3Y4UTdMNWc3ZTJQVFQwMUdNNE83OXd1WGtwRk9ZWXdBNWpIeUFhTS8r?=
 =?utf-8?B?ZkxOWm85VjE2VnhRbFZBTU9VL0l0ZVZRV1Bqc2xERG5TL3NHWllDL2lwL1JK?=
 =?utf-8?B?SFdKbFlBU1p6S3Y5aXJLb2QxRW5seDdFZllrV2pzeUI5RGhpVmY4TGxaRjVl?=
 =?utf-8?B?YzUrdWRzQmJXblJBV3E2UjcwUms0WXk5QnhUeG81aldzM3RhdzA5amE0UU9B?=
 =?utf-8?B?NTZFeVN6TmVLOFA5TTRFaFJCVVowWkFQRWd1NDh6R054QU56eHRjVjhKdTFh?=
 =?utf-8?B?Z2YwUHY2RzFNb0dUd2ZtWVo1T2lhOXJHeW5FeDNhbGZ5QWRBQjZhOThvK1pu?=
 =?utf-8?B?NWZQSEM2VlNObzRsUTdXb0syT0lvRzRkSTAyY1VIMHh0c281MEs1RkJkOFFT?=
 =?utf-8?B?dnJYOG1paldIK0paVEY2N2NmUTc4SnlrTWhLcGV6Vzl3NUMvRm93dHgzNjdo?=
 =?utf-8?B?YjdQWmRoN0xxYzM1alFIeTBIREp3WWZjc0RXVmFsbWR6dW91ZWF0SXY0Tkdt?=
 =?utf-8?B?VVFHQUZ0S29EWU9sdTVYdnBMRHRueG5lakNyWkUxM0tNb0crZFpHb3lsdzBJ?=
 =?utf-8?B?eGlIZVVubjR2TWxKR3ZvL0RRT1pRZk1YVnVBd1ZxZ0djTTd2bER1bndTeDY5?=
 =?utf-8?B?a3IrRWZpNVQwSnE4bllvYUZmTXBBODIzU2dZaiszUW41eTlwSGs1cUJQYTNO?=
 =?utf-8?B?ZWZ4d3BHWXRiWWVJMTU1WGVRUTExMGZpN2x4YUkycVFFWjhRcHpyZittdTBa?=
 =?utf-8?B?U216S3RBbjF0TGVJTEZPNVlUWk1yOEp5WC9WV3hhYlB3YVlXYkxnWXMrQTYy?=
 =?utf-8?B?bzNJb1NIN2RMcWc1NFFQRWpQamdENURncjk0bDdFM0x0SndTTEw0eVlMT2dD?=
 =?utf-8?B?TEpqMnBZRHZNaStSOVN0OEVBc2p5bW1XVjUrUGJISUc1YmVSQ3JDUmlCTisz?=
 =?utf-8?B?N0Q3L2xWdVVYYTRJd3liVElhUlFnL25XekNOQldXTFRXZFFOcnJhNGx5aDZT?=
 =?utf-8?B?SWZCUnFUblpHZFRMTTVLOGVOSE8rSFVib2lKTjI5YmV4UEpPN0w4R2JLZzht?=
 =?utf-8?B?K01QSjBpY0RvRTdyK1NzMlJiczcySkdyd00vQnNsbXh5ZVpkb3lsd2w3eGNt?=
 =?utf-8?B?OUVuWkxnUWVvRHd6c2J6TUxZeTV4Uk00Y1ZHVmthUENKRnEzb2tiakMwZnE5?=
 =?utf-8?B?NTZ6TG4rQ0k5b1JPUExmNVV6dmlLeWxnMkhneHpHY2pZODZMYlRyUlYyMkZW?=
 =?utf-8?B?bmZYQXpscHh1QXdSaTZ6d1E4elBjZ1IvdEpseStqWm1IQnNET0NJOGJ6N3hT?=
 =?utf-8?B?am4zYkU0SmR3MlVLTGNWbG1VdmJZSllwSkhOWHh6OWVEQnB0VjNGaWVDZEoy?=
 =?utf-8?B?azY1UXBPNTM3bVpyaGJoRkZPYUE0eDZZK2xYUXk0VlpGUjRIeGZacjI3dC95?=
 =?utf-8?B?Mk8vVnJCck1WM3B4ejBWZC9zcU40UUZVM1FISXFjczhWQ1NtaWpIa1pnTGp4?=
 =?utf-8?B?cXpqQkxBc1VxVnZxTWFCNmdJQzRoY2xIcUQvL3YweDFQMjYvd1JuT2JMTlFs?=
 =?utf-8?B?ZWU3Ni9yQm81c0wxY00vdU13dWhLbk1Cbmd0dVB6dXgrTE1ncFlVdlFaUnd2?=
 =?utf-8?B?RithRVRyQk5tWkVTVW1DWnY3YUs1azJOUTRFN1RGelFrVkRFS3B6aVl3WG8z?=
 =?utf-8?B?VHBHYVA3aFdVOS9FdXlYa0JGQlpBQ3R4bitSVkZPRjdub20yRGNxYzlzcEIy?=
 =?utf-8?B?bkh2Nmxab21PVExXRE5kT0hCUnNhZEdDV0xtTEgxemFURTNVSzdUaGd6RHRh?=
 =?utf-8?B?U1JJeHN6UkV4ZFdEa1p3RFQvUnZQUnBSUzkwTjZ6b0R1eHdXRmVIRnpmQ3ky?=
 =?utf-8?B?ekdtek9jV1A5clEwQ2hORFBvQUV0L1YvR3RoYUcyYzd5NzE4SWJsUGQraG04?=
 =?utf-8?B?U2RjV1ZwOEhVam9MMzAwWkVBZXFsei8vV0VHMjNIRXhFMy9Kb091SWNBV2dm?=
 =?utf-8?B?d2hnL0tNaUYwcHF1elIvdGVxcnNZb2JJTGFLT25mb3ZVUzY5dnBSZTNqQVlZ?=
 =?utf-8?B?ZDJEMk1RWloyUUx4NEoxV29CejVmVXAwY2k2Yms1a0treVUwUi9PL0NXbzVO?=
 =?utf-8?Q?JYQjVLuO9FsczI/yEAZjvZ3qu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa17881c-2551-4b4d-6b01-08ddf7a096d6
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 17:18:45.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFGBwr287B+k5kK2tKLrQO4BNA6ijQXXWAK04PFVN3s4TOw9j6NiCE7xNTFYxGu0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFB297DAF97

Hi Reinette,

On 9/18/2025 12:19 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> "io_alloc" enables direct insertion of data from I/O devices into the
>> cache.
> 
> (repetition)
> 
>>
>> On AMD systems, "io_alloc" feature is backed by L3 Smart Data Cache
>> Injection Allocation Enforcement (SDCIAE). Change SDCIAE state by setting
>> (to enable) or clearing (to disable) bit 1 of MSR L3_QOS_EXT_CFG on all
> 
> Did you notice Boris's touchup on ABMC "x86/resctrl: Add data structures and
> definitions for ABMC assignment"? This should be MSR_IA32_L3_QOS_EXT_CFG
> (also needed in patch self, more below)

Yes.

>> logical processors within the cache domain.
>>
>> Introduce architecture-specific call to enable and disable the feature.
>>
>> The SDCIAE feature details are documented in APM [1] available from [2].
>> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
>> Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
>> Injection Allocation Enforcement (SDCIAE)
> 
> (same comment as patch #1)
> 
> Changelog that aims to address feeback received in ABMC series, please feel free
> to improve:
> 	"io_alloc" is the generic name of the new resctrl feature that enables
> 	system software to configure the portion of cache allocated for I/O
> 	traffic. On AMD systems, "io_alloc" resctrl feature is backed by AMD's
> 	L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE).
>                                                                                  
> 	Introduce the architecture-specific functions that resctrl fs should call
> 	to enable, disable, or check status of the "io_alloc" feature. Change
> 	SDCIAE state by setting (to enable) or clearing (to disable) bit 1 of
>   	MSR_IA32_L3_QOS_EXT_CFG on all logical processors within the cache domain.
>                                                                                  
> 	The SDCIAE feature details are documented in APM [1] available from [2].
> 	[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
> 	    Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
> 	    Injection Allocation Enforcement (SDCIAE)
> 

Looks good. Thanks
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
> 
> (please move to end of tags)

Sure.

> 
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
> 
> ...
> 
>> +static void _resctrl_sdciae_enable(struct rdt_resource *r, bool enable)
>> +{
>> +	struct rdt_ctrl_domain *d;
>> +
>> +	/* Walking r->ctrl_domains, ensure it can't race with cpuhp */
>> +	lockdep_assert_cpus_held();
>> +
>> +	/* Update L3_QOS_EXT_CFG MSR on all the CPUs in all domains */
> 
> "L3_QOS_EXT_CFG MSR" -> MSR_IA32_L3_QOS_EXT_CFG
> 
> (to match touchups needed to ABMC series)

Yes.

> 
>> +	list_for_each_entry(d, &r->ctrl_domains, hdr.list)
>> +		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_sdciae_set_one_amd, &enable, 1);
>> +}
>> +
>> +int resctrl_arch_io_alloc_enable(struct rdt_resource *r, bool enable)
>> +{
>> +	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>> +
>> +	if (hw_res->r_resctrl.cache.io_alloc_capable &&
>> +	    hw_res->sdciae_enabled != enable) {
>> +		_resctrl_sdciae_enable(r, enable);
>> +		hw_res->sdciae_enabled = enable;
>> +	}
>> +
>> +	return 0;
>> +}
>> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
>> index 5e3c41b36437..70f5317f1ce4 100644
>> --- a/arch/x86/kernel/cpu/resctrl/internal.h
>> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
>> @@ -37,6 +37,9 @@ struct arch_mbm_state {
>>   	u64	prev_msr;
>>   };
>>   
>> +/* Setting bit 1 in L3_QOS_EXT_CFG enables the SDCIAE feature. */
> 
> "L3_QOS_EXT_CFG" -> MSR_IA32_L3_QOS_EXT_CFG
> 
Sure.
Thanks
Babu

