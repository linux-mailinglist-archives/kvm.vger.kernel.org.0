Return-Path: <kvm+bounces-72438-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFVTLWsbpmmeKQAAu9opvQ
	(envelope-from <kvm+bounces-72438-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:21:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE60F1E6880
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8A2FB301FE60
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D5A32C94A;
	Mon,  2 Mar 2026 23:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NcQX6wJ1"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA450320CCF;
	Mon,  2 Mar 2026 23:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772493127; cv=fail; b=laKMVtNWLPw5TFhkr17/DKmVRq4wtfI6Yx5pHQKFLJ+uqbi6bp8KYhPbq6N9IUrJ/WHgikhJMME9fkwpD21pJR+y3twGygQ9gLevHl/redN2N1rKfRvRSI84OUfw+j/EwHQQEArxZiwanqtxJSoXcsUzqfAxHUujCatcoSb1ls0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772493127; c=relaxed/simple;
	bh=VO1RVFH6DEkcaxtTDT3JClGLvrkZI46MKI0oXZmobos=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fZIoysqFIpuOU6V3AfoXCtdf+Tb3+AzApDYPyQawwvMdGBlhd4B7ACfYrGb84djP+UAftk16lnkZagH9QAGM0JhIYnEQsCzu4EsFpwn+/+ywIk9KgZmWvufobeM6Nx2lpaQxHx8Bk3Jh8/fXS3WqrK736KURdAOsQAYdbCvDLdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NcQX6wJ1; arc=fail smtp.client-ip=40.93.196.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pPt+AvsoyMMEpKpPpBEK3lcEkpshh7jSZn1uXXNh0UOpiDg8E5YRyZAUovbg3wvUCI00Bp1uHgNhOOKioIAFHBKBmUN7aFY2jwwLQQQSj0Mhu1k37+KTjw8LbKlrwCR7j/iUDiRo2eO0dpUa4WA0ot9HDaY8Fx2ct76UFLMZ59HLccWAuE4+PFanCXn0x5I1R2tSxzSSy+ywzITjkXlmGmHdvaZI5YQoKsNS8nFeAele5rjwkzeiSAbOUJBYUDNTNFGG2qmHg3wgvtMuQEqvcbUeeVLFUvpcYqz9HxZHhGNK/hvo993LvjYz4DAqAUSTn+fpI0EHhcG0B6QECZR8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzCWa1In3P7BlMxeAM2crhJ6ahyOTD6c86voKdJinRc=;
 b=n0yj7/zxV4aYOYOaOxi18wDAjB7t6uvvnwpBoRuBNYDgkVtsf8B6IojpDXWOkM4iLLPibdfV+/QhXciKIvz2lFT0s/ce2j0Qaqchj0gwv/YCPaomShiIfcfNDek7ZGR+nXFC2uEQNAdXjaUkjoYbfLtQzyFojRmpLjC77zjy96FUIeWj62HJkQq8CjYsnL/wdl3HpgmQsE7/oDBFfXtFkZDmWGsZ5yPv5Fnp7gAB8nR4RC2vL9IoUx6w10svRNY2wpsRHw1mw/vAnymCEV3mkRPlsMLOu6hJLyLfBteVh50CX7B8qNz3WxWI9XN3gCUvyrkKs+dRJh5VFDVQiR8EAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzCWa1In3P7BlMxeAM2crhJ6ahyOTD6c86voKdJinRc=;
 b=NcQX6wJ1j3744KGLOzs5UpIxmu0ayz7XOden3QuCrMVOseViESrvulijZnj2cO7kWysFhPMb6gjmm21WHkGEc8V5+EOCoTzR3X0jV6fgZyVZswCeyH1M7lZbBEtTfMIRmfsCinjBprenK7IghouwewzJORyqD+bRs4hs9FmUjqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL1PR12MB5923.namprd12.prod.outlook.com (2603:10b6:208:39a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.19; Mon, 2 Mar
 2026 23:12:00 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9654.022; Mon, 2 Mar 2026
 23:12:00 +0000
Message-ID: <6c2b6e6c-f321-436c-b4d6-c29195951592@amd.com>
Date: Mon, 2 Mar 2026 17:11:56 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] x86/sev: add support for enabling RMPOPT
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com>
 <b5a44f79-8f99-4e61-aaa2-e8aec6f0cf69@intel.com>
 <6a50d050-f602-43fd-a44a-cecedd9823eb@amd.com>
 <86bcca73-0c1b-405f-a72d-debb3c696333@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <86bcca73-0c1b-405f-a72d-debb3c696333@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:806:f2::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL1PR12MB5923:EE_
X-MS-Office365-Filtering-Correlation-Id: ea03a928-8857-478d-2aab-08de78b11b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	2A2MqGIHmTpBJN7imb4p5jA6UWwImVWUomW8ZePvtOxAncmMqN+pya6jZkPTAuYoIDM+uFvkZFWk48aEY++WHrmDMYP+rSdYtlQY+oOwbCmZd3YTWU4Hx56G3r1nDngX0X5ej3lpXE7NjWy/ZuXfuQ985IW0ybqACEnFSp+FvgrzpzlR0VhGHpZ30MOiD5jTk0TH2Fq/rfycm9cxORbqK9J+ZmhyM9p7EbTkVU0t0NGccAuLnIim9vHQZVOLXSCKlKaFkObS4wpFuAREKzVLZrtvdYHzfIHzVkazJ1BpbDa6I0rwilAwWDuL40ru04xlN9R4CBFqmwO0sGZa+J71HZ4kr4P6vhP8VsZeVVtNeglAJAwCycS+TgBPMKTdf269ZEOOMo/Qj778s/mUCqC8GARWpRovDWb0MjfCZgwEfH8HgQpGVNYCJ3SNu+rAUBjSuuSdb1Mi1AE597BlgPoERwQ61bgMtPS963oDCUdWQjd/gFUCpkqvfDe1C+OkdxTPk7g0LWFW0BC9wTOhWHsvRnRGdazOcI4QwGOubVkTvzOdPbOV7afUFcI0PO4Gc5Izmk/o1cIjTRcJ/bQORMQMA1suuc/g2Vg/Oe98Il/Ga5G+EdCVwCwPTNI9+hUVbbkNBBpuvdzluL4OgkC7X8hAYBHH/kMawGhyIhrV+luA2zl8P8KxQBQ+qI6f5Q7qN60lhxVbHP62nz/e7w4aYMjo+zXygLLnxqV812oD+pEQzGL0e3NLLeB5Z7Q27YP1xWdIGbQh99WF8DqeIOi3wS1tnQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnpJOC9ZTzJqVlRwZkRpaEY2TUVjL0I3WjI3R1puTGJ2U2thRmNkNTZ0Q1hF?=
 =?utf-8?B?UldXYmt3T2I3TjNsemtKYUlGZHFydzUwV083YUUwNGNudy9ENHk0WVBCU3NE?=
 =?utf-8?B?V2hLWHowNjRaSEFGQmUrdGI5Y25xT1dXQVNCV1JGK0N1S2dlb0R3WFBXdUZh?=
 =?utf-8?B?RDMrcVRzVWNGWDk1eVVFRGVoblRBYjNSOEpCeDUzeVd4R3doQkhrM3FhUUY0?=
 =?utf-8?B?eTZKM3liYWEyL1FkSVA5OGVUQlkxL0JlNi8rUGxvenh3NFBCa2piOG0xM0lC?=
 =?utf-8?B?SWVmRUZQeFNDTUIxUGVsa1M4aDVuSEtmU3YweXdIUGRCV0c4U3kzbWdaK3Vn?=
 =?utf-8?B?WE51MldYNXdPNFpwb0ZhT2FQZkttYng3bm5HWGs4dkthdTFOVTRnTjNHR2JM?=
 =?utf-8?B?K2U2c3U3Sk9vRTN3eUpxRmtBSzBFc0playttM28vVGU5alN2VkxJTzhJSmxR?=
 =?utf-8?B?RkJxTWhoQjQ1WndwWWxxVVF3TzFGWXU2VXVDMTlYbW1VbG9YRmpMMk41VWJU?=
 =?utf-8?B?WWptYjFpUXBsMld4aXpKc1ZDSGlTQkRZRjhYU0ZNd3MxZ0FVTmRnMWgrWFJI?=
 =?utf-8?B?UjdSRlFzUEhrc3ArdnY2TThpZjhja0JZODJOdUpDcnhraktvaTBvbXgrM1Ja?=
 =?utf-8?B?TGhzUGdSWEtkVEJpYW9EWnkwZmxWV2tNOTJRb0g1S1l6dFdLWlFlWHNOQnM5?=
 =?utf-8?B?Z1BpWVVmMnpHdzRxeUxpNGxvR3kxd1BJZUd1SGJodkw1c05sMEN4Tms5U0Ns?=
 =?utf-8?B?MmRSU3lKcXo2UDBUQ3Z3VXhYL0swTHBGYUNER3R6WGZQUUV4MjlsN040TEov?=
 =?utf-8?B?QWd5RTArZUZ3anNTUGE2cCt4SFpyaG4xNURiZEhGcitjakVEazE1MmdnRkFy?=
 =?utf-8?B?Z1FMUGZlTlpHRkQ5dFJHL1BaNE5KalM5aEZkN0dkZFFFZmIxZDltYUh0RVZP?=
 =?utf-8?B?RGJsYUhJc1ZvU2t5T0MzYVU3L0RMYzk4MGlTOUY2T2ZMSEwxZjI5eUlZdHVi?=
 =?utf-8?B?M3JSUDF3emdIVmJuZUhtYVFpSGVWcjIrTCtwVHoxeGFjM2F2R1RwV3VJaVZD?=
 =?utf-8?B?Q29KcElITFhrSVVEUlNES3BGWHNiNWNKb3h2ZTlNY3NtL1pYd0lVb3pQbHUz?=
 =?utf-8?B?bGloZnJYa0FzTDVVdUhoNDV2ejJoanczcGEyWWNGOXlVLytuaW1SSy8vbE5N?=
 =?utf-8?B?VCtnV1c5anNLRDl2bXhnbXhrTis2VmtiVjkvVHJTZ0phUWx2blNFYzJGTzJp?=
 =?utf-8?B?UG9jOTZEK1BSWXdIZ1NnTDMwWkZtbkVKQWU3T1I5cXdVRXhseWJnRWRBb3dJ?=
 =?utf-8?B?TVl6TCtSOUEySUJqU0o5Ly91STZtci84TFFndXVqTjJLUTQ3eU1Bc0EzWTl0?=
 =?utf-8?B?Qnh0MVBQcEJWTUpwQWlVNEhtZzl6NjNNRG4ydmkzdmhGei90dEF4dCtEaU9I?=
 =?utf-8?B?YlVJZ3JFZENEWjdEeU9nUjlWc3lxZklUR3pBL0ZSbDVDWlFzaUZrZWFxQUt6?=
 =?utf-8?B?SGZlU2VwZzZDU2ZROXR0RENxdmdtd1l0KzEyRUVtK3FkV0hIWjYxYjFBY0tK?=
 =?utf-8?B?UXErdm83U3dlOExmSVQ3TUxoWXRlZHVFVWVLZkEwWmZHRVNmY29rcXBWTkZQ?=
 =?utf-8?B?WCtLR1NXQnE0OXR4NXZZUTZ5OGxzOE55RG5ScEpYR2NvRWpEWmZWNzhRdXdC?=
 =?utf-8?B?bVhtdThlaHlnR3NiOC9pNzl0b2pIbzBiNlRGTUs5ZVdQVTRuekhoeEU5RjZx?=
 =?utf-8?B?d2RLMnhnbTVzTllOZU5zQk1Xd0NmRFlFMGhNam53aUZXazFJNXVYdG1LSFVz?=
 =?utf-8?B?T1ZLVnM5MFcxN0Q1QWNQODFXbGY1YlRpMVF1bEFFM2NrcVZjaFVabHI5TU1n?=
 =?utf-8?B?c1c2RjZqcXllUlVpYkJpanI4cVRJRmhUcGVERXVmQW5UVmp4K1cvNEVmTm9i?=
 =?utf-8?B?dittQzRyL2ZTS3N0NTBQRmRaR2RuVDNScHRYTTJEaUdzWXYzcDRFNEU1YWRJ?=
 =?utf-8?B?V2dDdXFxSEc5SnRVOUttekxKc29QdHY2ME5ISTdmSUtPUVlNSitnY0t0R0hm?=
 =?utf-8?B?aXpOMUxxaDV5UVY4bVBNYVpnUzZhblVTUER4bFZEWVExb3htVHp6QUxaSUdF?=
 =?utf-8?B?d1V3Z3VETFVDRTc2YWFQbUUwNm45S0lJeTNrRzVNSTdwN0pEL1kwb3FuWENa?=
 =?utf-8?B?WXVXcGp5ek01QnpJVmo5bE5hbVUwM2x5M2lIVDlDS1dUZTN3elo0TnYzYVhD?=
 =?utf-8?B?ckRHeXlHamlGYXhuVys5MkYvSjJVZTJVY2Y3b2k4bWxhM1ptbEczZUZCZm1v?=
 =?utf-8?B?UU81dnFQbm9UaU9KZ3MwYjQ5NGFJZmlkWlJYUmNIS25sNHdyKzZQdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea03a928-8857-478d-2aab-08de78b11b7c
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 23:12:00.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+yBm24x04FNaYc1ReZP7xVSG7nrHKe3QIrJR8NcI7QBIjgzWb11flkpLHxerYCZKye70fLJgUEo+7ZZVmbO0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5923
X-Rspamd-Queue-Id: AE60F1E6880
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72438-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,amd.com:dkim,amd.com:mid]
X-Rspamd-Action: no action


On 3/2/2026 5:00 PM, Dave Hansen wrote:
> On 3/2/26 14:55, Kalra, Ashish wrote:
>>> What's wrong with:
>>>
>>> 	u64 rmpopt_base = pa_start | MSR_AMD64_RMPOPT_ENABLE;
>>> 	...
>>> 	for_each_online_cpu(cpu)
>>> 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>>>
>>> Then there's at least no ugly casting.
>>>
>> RMOPT_BASE MSRs don't need to be set serially, therefore, by
>> using the cpu_online_mask and on_each_cpu_mask(), we can setup the MSRs
>> concurrently and in parallel. Using for_each_online_cpu() will be slower than
>> doing on_each_cpu_mask() as it doesn't send IPIs in parallel, right.
> 
> If that's the case and you *need* performance, then please go add a
> wrmsrq_on_cpumask() function to do things in parallel.

Sure.

Thanks,
Ashish

