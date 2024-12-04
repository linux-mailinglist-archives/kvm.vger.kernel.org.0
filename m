Return-Path: <kvm+bounces-32993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E100A9E3705
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1F7DB249CC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00DE1AC88B;
	Wed,  4 Dec 2024 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MG3+b/UU"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.mail.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D2B1A0B07;
	Wed,  4 Dec 2024 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733306431; cv=fail; b=duSuVU13XDlhitZjO0YZldl/8wlk0eqQaccHo9cCFrpZ10MEUOr6L4x1kg0/iF65IdqVBbddPeMpM3mncvL6X/7GkhOKfiIBaXv17XoqRmCwauL8Wy/MsJS4njsa2FD7aK/cwPypZ6yNvMMD0nxo5z58kNGahc5y3Q9I3kZDtIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733306431; c=relaxed/simple;
	bh=ykoq+HNh77XT5tWQCefbzpj2lOBfFPQf5J164NlWq8g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xd8SO8OOX0arp8YAidLnWyjgXeY1qSzmmb6HY37oL/80qzVb5+7xuOEIH2N1LG0J02OQSlfhELJQpFVZ+bssDVUQjpRtKzwrk2BCJeCfZ/u6uNADotTd7f6aOLg/ORShCXLbYcmv/aguhDDczuBf/n9V/y4U+x0jkE7bCzPwpfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MG3+b/UU; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8XJA4VkIlD2WgaD6BlCZgpsnDnQHlQgaZSWim9zPLixXvvlnj37TPvaSDfsEShzGBN6JHnRssyReryRxkleXflMXrxBNecuOBBKmRgeuz0w3A5OfjQeSu6XWYFCNg8NIzQoLFSInrhLzOFuBSxmDK/PqNdizZHvBblSbG+dFX+QC+qIHgLAg7KOoSSmSR4xJIuoJXXULdrTtVJwUWtabKVzdYNWz8bjy4GxvbNb2gIhsbPGbBAvG4pR2kXvSEmDkkfWKShr0AKyJUWMTcX46NIMx4sRenvT7nbuzugBrYx+dKYG4w00b+t+cq+sqoNSW3ZSAU34bw/i7M2VGDQZmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKjJdpJHC9RndEpFaV1qND04c/bwHC3syvbBtg0tASA=;
 b=F3/jyKEbzeAPGfHhAX2Jf+zLIHZGecbHSfmVbfHXw/POFVbk0cyxb/EEIFvi6BF1Y8E+BaPqzDAfFxFRA+JomLTgtS2D0f4CxPXQrrdMEFD9CFZ0h0RrKHNzd9q47c/G1plV3nAlpr8mUwkKmBJCB4FMxEulxZEKC0vgnItM5Nyb9aZ4rRjbhLBL245YxUlupvUbSrkXeZvNrWSlSjWLbznRDJb8uZcoPxIjjQpiasg0ICa2cDDN0TEJrobs4pkQFB/odcAOG+mxk1WETlvXUJMX3etaAg2aOXkWmY6QeSK+WafrYn41HpA1FPpK9AuN02lqKwVseeS4IAs99DXVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKjJdpJHC9RndEpFaV1qND04c/bwHC3syvbBtg0tASA=;
 b=MG3+b/UUFdYJesuZnqdlVUklteAYdZ0FBK/8z8Oo3WZRAwe6u3gVEh/KVFdrPPIDAXgwwLor7Sz09/AV3Tj4bPpuHrc5WB2qMrosjRkTZMySmoRiNSI9rHqxWsBpWwTLCIL+KEJxuhc9mpYyATNPAj18gUJ/ndvUrxfAWFOPgEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6860.namprd12.prod.outlook.com (2603:10b6:510:1b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 10:00:22 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 10:00:21 +0000
Message-ID: <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
Date: Wed, 4 Dec 2024 15:30:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0176.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::31) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 5526cb96-729e-490c-b30d-08dd144a76e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djBlc0Q2c1VEaEh4VkhqOGd5b3cycUVOdXZaVDlaODhRdERjZG0rSVFPclpa?=
 =?utf-8?B?SUtUN1M3NFNPVVlkY0ZuR2g5U2FLcXpXWXplWVRURjFoOHR5NUx5T0pxNkJz?=
 =?utf-8?B?NTErNFdxU0hGeEhnelBNbS9Zb3M4K2xjRDYvMjY0dTNhMkdoajB1RXV5bTRZ?=
 =?utf-8?B?T0FCT3ppTlpNYjF0am93dEIxa2t4YVduV0ZBUW4rU3gwMmt1TUtCRUtvcHdW?=
 =?utf-8?B?aW8ycERISUpHemxqenozazRRZXNQWDVqS0tQcXdUMHBkVDVTRGJqcGF3eXZ1?=
 =?utf-8?B?Q0tvVXdBaTRVaXdabmljSVR0MnJSNWlVeTBMUUVRYit0TTJlVURIVndKOGQ1?=
 =?utf-8?B?YlhhM1J5UEhEL29SaHhJaU1mcm10aWZlYlVnQlFPVDBmZDlBOVo3TWFhaXpC?=
 =?utf-8?B?RUFrYWI4aDVoUlVyaUJHbVdza0NJNUZHK3pBNDBYdklxM0dQeG44Q3ZuQy9k?=
 =?utf-8?B?M1VVdGh2WHdOc2JnUEY0VmZJZnJ2NHRUYjNBbHZkSzc0MlQwVnV2bmJnZ3hS?=
 =?utf-8?B?azIvT2xidHlwM3hGR2ZKVlpGUytGT2JiMUZ6T1pHeHNLZ3BIRmVGNzlhblpZ?=
 =?utf-8?B?dFk5QjgydXVQNDZXMmo2WU03ZnlYbjVTNDV3OFl4dytRbU5WcWJ6NlRUR2Zw?=
 =?utf-8?B?RTUzeUcvRlBUK0FzMlNiZWxqWGpzQ2c5MXFUZk1hbCtYYUgwS0JycUtMUVQ3?=
 =?utf-8?B?VTN1UlJNeWdHcWxLSUtEekZJclVOQ0thMDM5ZlRTcEg0b1BQcklMS2pyaUMv?=
 =?utf-8?B?Nmk0Q0JjMmxmVmtSTE94cFdjMVZiSTRYMVNzaEpJK08weThqelVoRTBjblRv?=
 =?utf-8?B?MktzTFdVVllOWVpnQmtISVg0QTAzSG9JY3k0VGNXcm9jT2J4VDZvN0FYT1Z2?=
 =?utf-8?B?T2tXaW5FbWg0WnpQSHBSVFdpZDRJV0ZHN3pwYUhsY3hpemJFZFJDc2RXTTV2?=
 =?utf-8?B?Y3J1UWMzSURFQ0ZTbVYxcklJTHA0Nk9DaWFIT2trMFZISEhyc0F3NjB5aDkr?=
 =?utf-8?B?K0FIMmRlZzVvOFA4WGpJN2xRN3lhSVlGNThCTEpyM3A4Q2ljOTFubiszTmR3?=
 =?utf-8?B?WFh0Q29rb1RtRFB6NFhvdDdNL1RPYUZLcHpSSHlHYndiSEJlcUFrK3lvU2Fu?=
 =?utf-8?B?OGtKRVdabnZyT3A1RFBNZXdVQ1BaRkFpTmNGTk1OQ2xpb2h0TURxL3ZsM3hr?=
 =?utf-8?B?NE5XZEE1NjF0OHZKd0x6UHdCTmJPMXJiN2ZGZkpyZEtMMGlhR2p6ckFWUzI4?=
 =?utf-8?B?Sm9COGN2Y3FSRG00emNQalJSeE9RSk5nazlUTGo3cVVLZTZjUWg4L2NmUkJw?=
 =?utf-8?B?U0FwTjdiaktOR2EyNHZkWFFmMFoyNnQ0NkF4RkZ5bU54aGFtaEpxa0MzMXVt?=
 =?utf-8?B?dHpLMVYxNGxzbTAwVEp6S1NhUXp3QkhzUGRBd1pITmhsbWdtczhYQ05jY2JS?=
 =?utf-8?B?LzRFU09sU0VpdzNmZk5haFd4dmErU29KOHJ3SEhKS2xQd0tGK1cxN0VqaWNz?=
 =?utf-8?B?cHZqVHNkamVxN3FvNzhReGF0SzZZRVRpTXp5a0hIbVBRQXB6cFVwZTk3Y1Vs?=
 =?utf-8?B?SGJ3ZjY2dGFEMG00T3NQMWx6Uk95cGJsRllyZjdQTUNSdkVyWVlKQmhIWW90?=
 =?utf-8?B?SXRjTGR1dmpKbmdMcStyNmxQTVU5NkpaSkRLMnhDRWtqMC9QRVQ4V0NRaHg5?=
 =?utf-8?B?bHR2MkFiNTBvRElPZFZPQzg3REdkMVhiNGNRV0pVT25GdmNDZThucEFDZnlz?=
 =?utf-8?B?WkdhNnVGcHBDNHJpTmtxZjhTZjhaTFVZb0p5Zjl3Vk1xRkcxSVpuOEFrU2pa?=
 =?utf-8?Q?1fPj8CpklKAllK74KaQ804h5mvsD3YFXkJ3EY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1Y3ZUREcXdpWWN2REJJdmVHbEtxR0c5Q3pkZ095S3d4V0QzKzJQMkNpdERB?=
 =?utf-8?B?K3Y2S2J3WFRKVE9BTmt4VjliQW1FbHBHTzdqTmpTTFc3NlhXY0czM2YybFBH?=
 =?utf-8?B?aU9sWTZiTUtCRzVFZUpVQXdXWVhZN1pWQjFVSDZWQ1J5MXZhVkw3UytIWTkz?=
 =?utf-8?B?OWUvMS9DRjlOMk5WeExxMDVKb2J1Y3hOaldrL3ROTGJsTU1UTE1ZTUozbHVo?=
 =?utf-8?B?RWtHNWE1c1pxZ1YwYWQwSDdtbTdtbm8rVHFLTytyVEo3cDAwbkxZeG92TFU1?=
 =?utf-8?B?Mnk2Z1F2Mzh2aWFjYlJLZ2hJNEh1UlVNNTJYUXZRK3VHUjJ0T3FUMTN5YVR1?=
 =?utf-8?B?QmRHc0hNbVRIaG8veUN3OFZGSDVWVSt0YnZVVndTb2Jja2RkTUh6SzNYRjgr?=
 =?utf-8?B?L0FlVlkzWFdxOEtjOXl2MWw2SUQ0ZjgxTXBOc3BlTnhxNUVnUHYzell5aStW?=
 =?utf-8?B?L2lGRjRJb01KeEx2b0JkRmNscFhJYlFHb2hRRGVaUzZKMzRYdjRSakFuNDdv?=
 =?utf-8?B?WVkvTlhkZ1EyTnJFTWpkbjNRMEt2YURqVnJPMCticnNsYWQxZzlOS1JRb2ty?=
 =?utf-8?B?QmdDU3hrQkpQcndFQUlsQ2pMWk9jWngrYUVWMXNZMG9VYkdaYWlvMzN4VG9w?=
 =?utf-8?B?dms4ZVVidElBOEdmQ2JBVHRFMDBBajB1MWtZSGdGYXF2aW1QZU56SVg5dzVM?=
 =?utf-8?B?ZUs5V2tGQmtPSFcrUmM0T0theVVISFRLMGp1NXd3ek5JVDcyRElacDRWZTJX?=
 =?utf-8?B?eHhWK2g5QXdvRTBpeTNwTERCZ2xIL24yZXllUTgxdUMrTjdNM1ZsKzNiSGNS?=
 =?utf-8?B?ZnphWDM5dEF2eXpIMkRPdnkwUUdMbEpEczlOTHcvdlg0c3hmdFZ3OWhOSjdr?=
 =?utf-8?B?eHk5T2NaeFo0LzQrMWY1U2xzMTcydUpGdERYbWF3dHJUSnJXRXRrVkllS3hL?=
 =?utf-8?B?a1dwN3BzNnpXeWxxR1Z4SjdFR0RGR2E3dm9yZ3dmdHV1b1BkVDVIUGtGcndl?=
 =?utf-8?B?aUVaZ09sTmZuN2IySWhJM2lIaG5tajE0citDUlZKa2pCeHhYWG5rL1k5UTFM?=
 =?utf-8?B?aFFHVGphSmhLR1BOREd4b3hZV2VmMGdUaHBBNjB0b3BLQmkrWWY0Tm5TRi9t?=
 =?utf-8?B?d3kxT2hPc1FNdk5rZnJPb0tsYnhqZlp5S3RKK29GOHFLVnQzeG51c0ZZNWlz?=
 =?utf-8?B?dW8zWEloY2dtdWk2bzE0djcyOHd5TkluTWZSQUo1OEY4Z0NLWDNUUGxRWStX?=
 =?utf-8?B?OVVGK2w1UnNSV0tzUXY2bUlnUXlEYlpQTEtVcEdNMFZQaWtRMWgzdlhiWlRG?=
 =?utf-8?B?eUtCYnAxMmdPY3pJSVNEczRvT0xLbDhleDljdGZ3NkRpMG93Tlk4L2hPTjhL?=
 =?utf-8?B?UzdkMnpkOUxBTmhRL2xxV2F4R3BNcnNhd0I1dElyUE9QNTUrU0pEano5c2sx?=
 =?utf-8?B?Tks4dVdaQlBNUGZQazNZbzl6OHVKbU80ZXJLSHB3d2ZLd3Ixd1lBMWpNZ1Rp?=
 =?utf-8?B?V05DZm5nOGpjeGRtRFFzWDhRUnlUZ1RUaFRIUG9ha1JnVVlVa0xnN3pPTHdo?=
 =?utf-8?B?c0NtZk8wL0tTVTlBZE5SdmFFVG80dXd2L01Hcm9BU1FJY0RoMTlEZGxGZGF3?=
 =?utf-8?B?UHNGd0JLZllqMnJQdy8wZ0c2dFZJVFNYZEVUVi9PQ2EwNkNnUkg2UCtTZ1Fu?=
 =?utf-8?B?eUw1N0FaMUlmM25rOFVqM3pnV2IzTnB1RFU2THozWmtwVEFYMkkyVE1DUzBt?=
 =?utf-8?B?Z09UdFRHT1U4cnA2dmVIelVnUFdFWCtnNWZ2YlBOT0xnKzB3UDJOZWZYdUJn?=
 =?utf-8?B?VS9iNy9NMGVlT1VXd3hsQUwwSmhiWGhFZk13eUpGWFp4VjNFY3FrTDRxKzlN?=
 =?utf-8?B?OG9FMENWM25kamlUdXFLZ1ZNOXlhQkk4V2F4bDlqZkpYdVJxOWNHVUg4VHV3?=
 =?utf-8?B?Q1psZm1XREowc0xmQnVGSDJVRXd2Q25SdmtTaGt1cUpzNnpDVGxLV0tjZEFZ?=
 =?utf-8?B?VEVncjExT2VTOVMyRVNIQzRrQ0l2ZGY0TXA4Qnl2VDZCZFhxMU5zWU10cHRK?=
 =?utf-8?B?ai9LTkxVRzE5cjM0TVloRUtoU0ttTDNJWWJVTHAwVE1sOVU3ZUEwR0REbG5W?=
 =?utf-8?Q?Uh0EQM50WJxpmDVX8yTxvzAlU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5526cb96-729e-490c-b30d-08dd144a76e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 10:00:21.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPCKlrXFy7SotZWZs1XtT/IvU83eSgj0LvMk5o6ZSsI9rLIS22rfhWxBjblAX2xnNgG8YB/lZ6jP55F8MBH47Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6860



On 12/3/2024 7:49 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:33PM +0530, Nikunj A Dadhania wrote:
 
>> @@ -2667,3 +2662,179 @@ static int __init sev_sysfs_init(void)
>>  }
>>  arch_initcall(sev_sysfs_init);
>>  #endif // CONFIG_SYSFS
>> +
>> +static void free_shared_pages(void *buf, size_t sz)
>> +{
>> +	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>> +	int ret;
>> +
>> +	if (!buf)
>> +		return;
>> +
>> +	ret = set_memory_encrypted((unsigned long)buf, npages);
>> +	if (ret) {
>> +		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
> 
> Looking at where this lands:
> 
> set_memory_encrypted
> |-> __set_memory_enc_dec
> 
> and that doing now:
> 
>         if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
>                 if (!down_read_trylock(&mem_enc_lock))
>                         return -EBUSY;
> 
> 
> after
> 
> 859e63b789d6 ("x86/tdx: Convert shared memory back to private on kexec")
> 
> we probably should pay attention to this here firing and maybe turning that
> _trylock() into a normal down_read*
> 
> Anyway, just something to pay attention to in the future.

Yes, will keep an eye.

> 
>> +		return;
>> +	}
>> +
>> +	__free_pages(virt_to_page(buf), get_order(sz));
>> +}
> 
> ...
> 
>> +struct snp_msg_desc *snp_msg_alloc(void)
>> +{
>> +	struct snp_msg_desc *mdesc;
>> +	void __iomem *mem;
>> +
>> +	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
>> +
>> +	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
> 
> The above ones use GFP_KERNEL_ACCOUNT. What's the difference?

The above ones I have retained old code.

GFP_KERNEL_ACCOUNT allocation are accounted in kmemcg and the below note from[1]
----------------------------------------------------------------------------
Untrusted allocations triggered from userspace should be a subject of kmem
accounting and must have __GFP_ACCOUNT bit set. There is the handy
GFP_KERNEL_ACCOUNT shortcut for GFP_KERNEL allocations that should be accounted.
----------------------------------------------------------------------------

For mdesc, I had kept it similar to snp_dev allocation, that is why it is 
having GFP_KERNEL.

        snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
        if (!snp_dev)
-               goto e_unmap;
-
-       mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);

Let me know if mdesc allocation need to be GFP_KERNEL_ACCOUNT.

>> +void snp_msg_free(struct snp_msg_desc *mdesc)
>> +{
>> +	if (!mdesc)
>> +		return;
>> +
>> +	mdesc->vmpck = NULL;
>> +	mdesc->os_area_msg_seqno = NULL;
> 
> 	memset(mdesc, ...);
> 
> at the end instead of those assignments.

Sure.

> 
>> +	kfree(mdesc->ctx);
>> +
>> +	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
>> +	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
>> +	iounmap((__force void __iomem *)mdesc->secrets);
> 
> 
>> +	kfree(mdesc);
>> +}
>> +EXPORT_SYMBOL_GPL(snp_msg_free);
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index b699771be029..5268511bc9b8 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> 
> ...
> 
>> @@ -993,115 +898,57 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>  	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>>  		return -ENODEV;
>>  
>> -	if (!dev->platform_data)
>> -		return -ENODEV;
>> -
>> -	data = (struct sev_guest_platform_data *)dev->platform_data;
>> -	mapping = ioremap_encrypted(data->secrets_gpa, PAGE_SIZE);
>> -	if (!mapping)
>> -		return -ENODEV;
>> -
>> -	secrets = (__force void *)mapping;
>> -
>> -	ret = -ENOMEM;
>>  	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
>>  	if (!snp_dev)
>> -		goto e_unmap;
>> -
>> -	mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
>> -	if (!mdesc)
>> -		goto e_unmap;
>> -
>> -	/* Adjust the default VMPCK key based on the executing VMPL level */
>> -	if (vmpck_id == -1)
>> -		vmpck_id = snp_vmpl;
>> +		return -ENOMEM;
>>  
>> -	ret = -EINVAL;
>> -	mdesc->vmpck = get_vmpck(vmpck_id, secrets, &mdesc->os_area_msg_seqno);
>> -	if (!mdesc->vmpck) {
>> -		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
>> -		goto e_unmap;
>> -	}
>> +	mdesc = snp_msg_alloc();
>> +	if (IS_ERR_OR_NULL(mdesc))
>> +		return -ENOMEM;
>>  
>> -	/* Verify that VMPCK is not zero. */
>> -	if (is_vmpck_empty(mdesc)) {
>> -		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
>> -		goto e_unmap;
>> -	}
>> +	ret = snp_msg_init(mdesc, vmpck_id);
>> +	if (ret)
>> +		return -EIO;
> 
> You just leaked mdesc here.

Right

> Audit all your error paths.

Sure I will audit and send updated patch.

Regards
Nikunj


1) https://www.kernel.org/doc/html/v6.12/core-api/memory-allocation.html

