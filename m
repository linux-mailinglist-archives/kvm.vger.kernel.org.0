Return-Path: <kvm+bounces-58185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C7AB8B18F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7CF31894134
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9557D2BE036;
	Fri, 19 Sep 2025 19:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M4BgPzEd"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A00D1E5B63;
	Fri, 19 Sep 2025 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758310714; cv=fail; b=HGq5lnMKae5WS2MF/xvhT3NvlYNjz0FoELWGnPuFTlgzrfdIJnXY+C153mOLuqJUjHmk/aByInGUef2ZBZwRdUAXpSsC/4oqcjIB9iSbZwxnJw5/vPq/H5fkGM80BqT/vby934rZhrz/Z4VKzXS21PCF7MIxklN4t+/v/hIWv3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758310714; c=relaxed/simple;
	bh=+vzi4zGm4bXnZXaT65vEx9supqGbcFVU+Sb/cB5Ijrw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u8EQcYI5fa/6P/a05OrbdMJb5soxFO/Rlw9ocOUNQFRM+jOx27On5gw7Xbh1Gl1KFOLuQcHlTncMBsyJ3uk+B2BaS0GgOSqR4F/mpkWrYYqaPbLy+x1LI04DzK1bS75UZlxJ7GzFpBUtLdA8lR+FXW23JYCAvbcTmZTU2QFWotQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M4BgPzEd; arc=fail smtp.client-ip=40.107.209.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxJEjlIOpn11oqbE+1vfjc62E4s0QI7XqanObpIpyn85h7u+EzyIjO4HrHxhqs7pGaH6HTJ6gS396AVsoyTn2Cl0c+nQoUB0APYBfNabsx9LHY7Fw4XqMSGrZ1dqPLSzJuDNbJz5nKJc3XREtDA8Z1lV0okULeVkntbWPXiF+ZHvXAxMaiLpLdJDXDHWpPd0BldWiolh7YPNgxXlL07vKx2m7SFItBSYrs4FRKHy9JmcqwyZeM/7hz93I92NKGf1QdBX0xaKVEGrJuNQwQHOaiOtUix8Ol+qhHl1T2ZYzfr39Gyh6zddDsu7NM8jkv0wpM5CCD5TvWM2fKKNeEa4GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlzfwJ8ekCcl1ihND2T3CKhU2E8nb7RQGC5/UkB+ARo=;
 b=r26LbXMW5Fh+H7q3dBCJZmXkKx1ffmnn7uv3nJdZwLXXE8PhObIRMXFD2U27j7TlO9HkNlABdc2JQsiuD8Mphp+/U+TXr/HMEQTSGjEI1R9CwDxTmsQXXfdm2PH4gBdgLG8mHRjmX3Fz8OEnJ2cASWFgpSeiNG3A9Q2Z3au2uld+KixdeiJXIly3QWgyf9j+Bb/t8iG4jSqdgxKQvEHI9gdSEKGDkBybimACVo0VJybe/PKTac99MbtRYxP9/2Dp22jhRpc7bznWcV719mqmeF+ZIrD5ULmY7FMqv28JnyTmlMSJXioqTUXmhFlBGA6Gi5r1ZSD/sfo8/9nMJnAJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlzfwJ8ekCcl1ihND2T3CKhU2E8nb7RQGC5/UkB+ARo=;
 b=M4BgPzEd4Alwmtz+uj2bUgg+Atf0r7Q0XiimQ8EZME7WlgpD6Ho52At+GMAuHq8iKVb9wizx9RNj9XBVsuAnbGSbW5Do74vsEmPUbFRpfcBF1Y/hFl94xgIgcaZBKCAcp6ONnaHyCw7MFjiH7msP+JF90WyD1s1DRg6PJe84yz4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DM4PR12MB7743.namprd12.prod.outlook.com
 (2603:10b6:8:101::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 19:38:29 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 19:38:28 +0000
Message-ID: <4da93c53-54ae-4599-ba40-3ba1cddd5b8e@amd.com>
Date: Fri, 19 Sep 2025 14:38:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/10] fs/resctrl: Introduce interface to display
 io_alloc CBMs
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
 <382926e0decbe8d64df56c857fdf10feef6fcc51.1756851697.git.babu.moger@amd.com>
 <2c3a8282-e876-4cdb-8355-0fd78eb6c0b4@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <2c3a8282-e876-4cdb-8355-0fd78eb6c0b4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:806:120::35) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DM4PR12MB7743:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac9a006-a23f-4dc7-675b-08ddf7b41b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rjc1MEhXUmFjTHpPS0k2dFg3Ulk4QTMySWpIZFNONWN1RGJrUGNFQ3l5YXVu?=
 =?utf-8?B?MVNEdGNOdjkxb0NJaG5Jc3E3SS9qcGppZVB5REVnazl3STZSbExveUJjeWlF?=
 =?utf-8?B?WGZFUGJZZ3NpMk54dXdxWTN0UGdSdDlRbW13RWgyK3c2eFByL09sQSttdnR0?=
 =?utf-8?B?cTJQQjU0dzFnWmdBdVpqMVk0Ri9OODlmR1hDMnJNdXh2Z3ZhaWI5bndqdDB0?=
 =?utf-8?B?YzRiZUc5QTZDVTlwa3pOak45M0Y1SWZsdjNFSFZrcUtiY2VNUnlGdGpKSjZY?=
 =?utf-8?B?YU4rSm5zZzNqdUdzUWRCNTJ5NDZ5d3k1SHBjYXlROXZPOFBSYyt0QmRBc1pH?=
 =?utf-8?B?WHZyN3laWEJ4TXd1bU5vQWxHSUFBK2NPWUdmcTNBdDh2ZVk2amZLZ0ZhYXMy?=
 =?utf-8?B?akw2TFpiSGZNZDcrSkJmaUtURjZHT1QwUUNMRGlFNTdoOUo5aGQ1bFkvVk9i?=
 =?utf-8?B?QndEY2lVUHd5NXB5Y09uRDhoUUJ6S25nbGtJdUZ1QUd3YWtiQTY5QktDVmxi?=
 =?utf-8?B?TVNPZEp0R2JVbDFyYUJIaFRUbFp6Tmh1Z3luK0gzQksxRjk4Tll4djM1UFBU?=
 =?utf-8?B?MDVaaTNFMTBRbCtXdVRkdklKTitEYmMzLzR5WUhwekFjLzJycjcrODNMMDla?=
 =?utf-8?B?azdsdkZPbFVSZm9nR0xqZXFkSndSNG1lSVh0RnhpV0xXVEJPcVllaGhVNlI1?=
 =?utf-8?B?bVJjZTIxdXJzM241cnFEUm5HTkxBYVNrSnhHaXhUNm55WHJLR3ltRWdLQVR1?=
 =?utf-8?B?NVN6THBIK0lha0huUEFsZ2JnMzIvL0NDaGdkYUxZWHVJRVVqQThjdlF6c2c5?=
 =?utf-8?B?ZkxtMHQ0bzQ0RzYyOUhyTDZCekhNRitKNE0rVWFpSDFHVzJ6UmxrOVcyTFVM?=
 =?utf-8?B?aDgrOHJWRGNkdUVMUFVPWXpqekdBZUVzdG5rNVdYMFpvYmg0eUo0d2d5Y0s2?=
 =?utf-8?B?SjFaMDF4d0p6YmR1cHl4TzdoUjFLaldvSndPOWg3WUU3TGNYWkFjSjcycHZP?=
 =?utf-8?B?QkhSdW01TW1PNndoVGp4c0RNV3BSZXlTRGZNQmtZUUNNUlJvQlRUUGpTOWt0?=
 =?utf-8?B?RktPN2t1RnJXbGVuRGRuRWVrRkplT0lZc0J0R3JKVDJmL0czZ2wzZVZHeE1L?=
 =?utf-8?B?TnpCWnZSdm5tVk1SL0dPeXhQWTBlcmlQTkl1VWtJN3lkbGtBdTYzdUo1MERY?=
 =?utf-8?B?ZFczTVE2c3h5YmRkbHN2VkxwMW8yMTlSQVVtaTVFTUxUM2pWMkxBOHVGcVJC?=
 =?utf-8?B?azZabXVBUzA3b2lvZWdmQk9oM0xZRHRONlFnVVdqOS9vN2tKSitmYVl5aDNW?=
 =?utf-8?B?SGdpbktjMUthQ1BNUzhidjBhUUdBMWhMZzZleEU3TXg4VVBTeUdpVi8wYXdx?=
 =?utf-8?B?a25jTzl0c3NDaDdKM3FJYnBwa1l5Q044eDVJaGlLVituNEpYUEtmUW1aYkN3?=
 =?utf-8?B?OWh0VW90ZDJmUkVVdG5PTER3alpkeUhFWHV2cnFtYklERUV3eGpmNXhkanhG?=
 =?utf-8?B?ekhWTXJsaTN5eFlvaVZDOEFVampxaytYU1c5VktqZGVWWURSY1FtaG1CV2Z3?=
 =?utf-8?B?eENCVmtLSS9QbkxKTTEwYkwwMnBqWkhHamRFd1hKQkc0aTF0STVrSnZ2Zjkr?=
 =?utf-8?B?SGRwVjdhb1k3MVpyVEpGc1RMMnhjaUVnaGpHNTIzWVBMVnpXRCsyb3l5WFIx?=
 =?utf-8?B?Y2ljRjloK2g5ZXp0WXMzclNpRzcvaHNqWXpKSHJTbG5Bc2p0Mm5WbU1sWG4v?=
 =?utf-8?B?TDhreDU1TTlldVFHN0taYzlWemJqazVrOWpmbVZKRS9OZzFMNy95N2lLaUhl?=
 =?utf-8?B?bXY4bjJMN3ByeXVPbzFCdTI0dTdDYkFDZjBmTnF0cVVSekdLckJxVHN2QTJo?=
 =?utf-8?B?Undhc0lpR01ZNGtXaTBTcCt6VmxHSnpTa2NRWUhzYVl3VFpSYTJMMnRtbXZ1?=
 =?utf-8?B?YU1oSS80dlJZZ3NMdGM5NzJJVDJWTUp2WDVTUXZHaEIyQXJWSk92WUowWmhR?=
 =?utf-8?B?c2NVcUErc1pBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1NhRW92ZnFQcTZmb1FOSjNrRHRCZktNNm9UdHVCeGMxTHRiTXVUbVdrZWs5?=
 =?utf-8?B?RGF1eTZwWW9wTkRGOHpXaW9zbUxWYytTUjEyZk9ldktIM3U0RUF0TmhpeHEy?=
 =?utf-8?B?YWlLVkhJSGZjTjRGSDBZUFc0R2cwQ2haRUJxWG5ta3FJTk1PNjFuNmRCUmxr?=
 =?utf-8?B?b1MyQjFVdlYrV2V0MWtvcHhzb3hyK2IwMllMSXNlRGp3Ykd5cjYwQnh6cnV5?=
 =?utf-8?B?N0FHZlMxMmZ1VXpMS3I1enNMb0E3OXhTMGl2NFZPMTVmcnZPMmIxZDJybWdM?=
 =?utf-8?B?S28rV2FYVFQ3RzFxR0tzRC9CWTVDYzBJZVhsejFRR2ZkSS9NbUVxZE5GdjZX?=
 =?utf-8?B?ckdKc2JJOE5yWlhxTFZrUG5OWlFCVFA5TEVEMGl0QVRMRjVTYmQ2RTB2cE1J?=
 =?utf-8?B?bWMxODlKOG9hOEQvWWNSL1hDTGYzUGI4NFVrMmU2Z2lQVGw5UWNjdFNranM5?=
 =?utf-8?B?NCtaVDdqQXJLK0RpQUhUV2FuOXdZVnVjNlFsYm92WkF6VlN5UnF4bjUwZ3pZ?=
 =?utf-8?B?cko3QnFHMVNFZDF0VXY2a3dLQlBTWlN4VEFnQ3FmSGhrdDFsT1RJVzhQMElL?=
 =?utf-8?B?Vkp6ZDdkTzZkNGNCdmh5RW1saU5DRW5aVzMzVk9SQWpsQ0Q5S1JxUWFYZ1pD?=
 =?utf-8?B?SGk5THFrWlZwZzVNYXRhMnVIZzJQSjNBRFJVNWlubzBQbVNRcDlTR05QR0tz?=
 =?utf-8?B?Nk5uN0Q3S2pMa1BUaitTSCtSY3hPWFBrblU0RmthL0J3MmxYTnRNQVVhOFlR?=
 =?utf-8?B?MVZDMGlOcU5KVDhTaVcyU3lhRnQ1aG1OS0NYaGRyOWsvLzNWYUZGbVlMU3gw?=
 =?utf-8?B?UmFPVU15dVdvV0U3VU43WXVEWm9tREd0a0thakpqWEhTQzFwd0FTZUlIS0hr?=
 =?utf-8?B?dWdzbVZoNmhUcTFCR1liRnNmRmlxaU1IZ2Q3eFEyR2dkUzFiQ2d3ZDY1NDVN?=
 =?utf-8?B?WlhSZWNuTzVjNndFTXZMSlNNRG9EVmZuM3FRSkI2OFU5UmtIMUFjNkZjWnBu?=
 =?utf-8?B?ejU2OTh1djZaZWFNUys4ZTlZbStyT2tZUUtpVjJ4VlpzRVhDRlpHRWthdWxv?=
 =?utf-8?B?d2wvZWd5TkxxMEIrUlZGTWtXTGV3TzRZS1RvUytMSlpIUkVZRkN3TC9xcDcw?=
 =?utf-8?B?MlpScUxxUUFQWVpkT0xRQWMxREY3WTBxOHJSY2JRdWRYcjc1eTQrN2xrR0ZK?=
 =?utf-8?B?b0lLb1BacmhqdDZlMkdPQ0d6NTBJZG9FWUdySnpmNkNURWg1RDRuNkpsemFa?=
 =?utf-8?B?R2tpdGlzMFhCMEkrNFdIUjdsWE9GNVJibEc4UEkwSWJvaG1DbHJWd2FsWVNs?=
 =?utf-8?B?WndNK0VMa3BGTkVlbEhWS2o1YngzVk1tc0FiV1oyeDBPNXdtUmwrVDRMVE1p?=
 =?utf-8?B?QTRwa05MY0RyTU1jdjNFYUozbW96L1dkMWJ0aTYvb0dLbVZ3eUUyVmlUa2tl?=
 =?utf-8?B?NDl0bHQwQmQxaDMwc3EzMkJ2R3A3Vm9iUENiOVdWOS96b2VyNUwya2NLL01z?=
 =?utf-8?B?a1dIRVRyYzVIYlpNWEtVWFFSMDFZLzZHRXhoS0ZsdWQ5K3cwd3o2Q1ROc1FY?=
 =?utf-8?B?NXdTYXc1NXJ3cFMwMll0K1FJc0Z5SGpVcjZoTjAxeGhISm56aDRrU0psQ241?=
 =?utf-8?B?ZXlTYzQ1dlJKMU9MMy95a3R0UUtRWkhVdERNbE04RnlWUU5WUHErQ29NN2NX?=
 =?utf-8?B?UU9LVmtNT2tDcUIvSENSL21vMEdsbkRLazVhSWh2ZWFBQ2RibXNjdS90TFp6?=
 =?utf-8?B?YTBKLzN3QXQzMGMydFJUeUtyOXhZTXFyTkVXTFhXRktuUFA1QThlYmNvcklv?=
 =?utf-8?B?d3hSUWpVcHZsOUU1TFRYeGVnemROeVZCbm5MWmEyUUVSMTM2V1RCdVJrbzlu?=
 =?utf-8?B?V3ZCU2tJR0wrM2FZY3N1QUs2VGs5eHRKZzVmK1pJTksrQ0dwV3dWbEdvbjBh?=
 =?utf-8?B?M1ZTTitUaWFsUGFrcUxYT3JPcXk4dlVKOVYrOEJZcG5jLzR5cVFHNC8rb0NF?=
 =?utf-8?B?NjFGM3YwckUwdDVrNDByN203bnRGZCtUcktvcEE2N2oyakkzSVUzMDkveTFC?=
 =?utf-8?B?YnM3Z0MwTzVGeTlPcTJCdnYrN0NwNk9KWVNSWlozc0UvY3IyTnFoeVVvVTAx?=
 =?utf-8?Q?kKz0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac9a006-a23f-4dc7-675b-08ddf7b41b86
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:38:28.5994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIPZCL8UPo34u1VrOqKJAG4s4un4GroEswd1x5oaxHhWIPRfECi+PkOE2F6HXdsx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

Hi Reinette,

On 9/18/2025 12:43 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> The io_alloc feature in resctrl enables system software to configure
>> the portion of the cache allocated for I/O traffic.
> 
> (repetitive)
> 
>>
>> Add "io_alloc_cbm" resctrl file to display the Capacity Bit Masks (CBMs)
>> that represent the portion of each cache instance allocated for I/O
>> traffic.
>>
>> The CBM interface file io_alloc_cbm resides in the info directory (e.g.,
>> /sys/fs/resctrl/info/L3/). Since the resource name is part of the path, it
>> is not necessary to display the resource name as done in the schemata file.
>> Pass the resource name to show_doms() and print it only if the name is
>> valid. For io_alloc, pass NULL pointer to suppress printing the resource
>> name.
> 
> Related to changelog feedback received during ABMC series I think the portion
> that describes the code  (from "Pass the resource name ..." to "printing the
> resource name"), is unnecessary since it can be seen by looking at the patch.

Sure.

> 
>>
>> When CDP is enabled, io_alloc routes traffic using the highest CLOSID
>> associated with the L3CODE resource. To ensure consistent cache allocation
>> behavior, the L3CODE and L3DATA resources are kept in sync. So, the
> 
> I do not think the "To ensure consistent cache allocation behavior" is accurate.
> This is just to avoid the possible user space confusion if supporting the feature
> with L3CODE used for I/O allocation and L3DATA becomes unusable, no?

Yes. that is correct.

> 
> Also, this also needs to be in imperative tone.
> 
>> Capacity Bit Masks (CBMs) accessed through either L3CODE or L3DATA will
>> reflect identical values.
> 
> Attempt to put it together, please feel free to improve:
> 
> 	Introduce the "io_alloc_cbm" resctrl file to display the Capacity Bit
> 	Masks (CBMs) that represent the portions of each cache instance allocated
> 	for I/O traffic on a cache resource that supports the "io_alloc" feature.
> 
> 	io_alloc_cbm resides in the info directory of a cache resource, for example,
> 	/sys/fs/resctrl/info/L3/. Since the resource name is part of the path, it
> 	is not necessary to display the resource name as done in the schemata file.
> 
> 	When CDP is enabled, io_alloc routes traffic using the highest CLOSID
> 	associated with the L3CODE resource and that CLOSID becomes unusable for
> 	the L3DATA resource. The highest CLOSID of L3CODE and L3DATA resources will
> 	be kept	in sync	to ensure consistent user interface. In preparation for this,
> 	access the CBMs for I/O traffic through highest CLOSID of either L3CODE or
> 	L3DATA resource.
> 

Looks good.

>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> ..
> 
>> @@ -807,3 +809,40 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
>>   
>>   	return ret ?: nbytes;
>>   }
>> +
>> +int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
>> +{
>> +	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
>> +	struct rdt_resource *r = s->res;
>> +	int ret = 0;
>> +
>> +	cpus_read_lock();
>> +	mutex_lock(&rdtgroup_mutex);
>> +
>> +	rdt_last_cmd_clear();
>> +
>> +	if (!r->cache.io_alloc_capable) {
>> +		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
>> +		ret = -ENODEV;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!resctrl_arch_get_io_alloc_enabled(r)) {
>> +		rdt_last_cmd_printf("io_alloc is not enabled on %s\n", s->name);
>> +		ret = -EINVAL;
> 
> The return code when io_alloc is not enabled is different between reading from (EINVAL) and
> writing to (ENODEV) io_alloc_cbm. Please be consistent.


Will change the return code in patch 9 to -EINVAL to be consistent.

> 
>> +		goto out_unlock;
>> +	}
>> +
>> +	/*
>> +	 * When CDP is enabled, resctrl_io_alloc_init_cbm() sets the same CBM for
>> +	 * both L3CODE and L3DATA of the highest CLOSID. As a result, the io_alloc
> 
> Not just during initialization, they are kept in sync during runtime also (when
> user writes to io_alloc_cbm). First sentence can perhaps just be
> 	"When CDP is enabled the CBMs of the highest CLOSID of L3CODE
> 	 and L3DATA are kept in sync. As a result, ..."
> 

Sure. Thanks
Babu

