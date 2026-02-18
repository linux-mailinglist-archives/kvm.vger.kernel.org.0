Return-Path: <kvm+bounces-71208-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Mk7H148lWleNgIAu9opvQ
	(envelope-from <kvm+bounces-71208-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 05:13:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D12F4152EFD
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 05:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF961303D330
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 04:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D9D2F5492;
	Wed, 18 Feb 2026 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oBlBHA6R"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010032.outbound.protection.outlook.com [52.101.46.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F442E229F;
	Wed, 18 Feb 2026 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771387979; cv=fail; b=buohv2fyrzTc3RIwwk/3+XtVdi0KL648lgbUZVj2l3fzuynuVSidAeqHkJBv5Et5HsDGUWUxFTwhgEH02O1erxUZmgH8aNbCycECyrGqaBYth3bH70bsROOzA3X79w+OIBo/BnrGfiMamib6ENBID2JDDg6syw/XYLT52+SRwVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771387979; c=relaxed/simple;
	bh=y4+xsTCnKI7PXuzbfMIRYp5E94EY5Mn89Sqsw/vHubU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VC++OCNSwH3vU0zsmiRRVe48Btd5r83S1lzwvp2re3mDILplzYb/E2dMwkqKB/zDD9R/aJuSQ5R2U+VtoxhMpBSEim/CgQ3iMlD2Bpgznq7H8Qd+kFMDHyAKJdxejJLbsLK13XxXz3wC2iZFwzBRM27dr3CNkql81RtUb79P2Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oBlBHA6R; arc=fail smtp.client-ip=52.101.46.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9o/3UTWXrYsK3W3lgDaKu5lw6x4PzohFaCmYAZkwMwSl1usWtXNEtSwhicKkINYA6/1JAOeslxfZVF0tGQSsryO7R/0BZEmKLy5hw53oNxGybXTWl4neX+kohbWoZYn1HOHw/R+I0Y1lq++UbsZ0Wz6l/y8ntoDWQ2z0OBKdB8ozVs11UdOlIhm1jq3gXhFIh59FJg3qi1wpSgaFuwQrOJY4Oujzf5w0IwT7VbbE9pXzzBz2BJmPYUvXLaW84l3L5g4qlYHhV/mkAYp1yNipqm88T745DYRt8PyHz+l23j2Ip11SWu9jWh7TjeUUYUTjSLquGeqd3pW2UBgpQB/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWOH1DvjkvwFd2+fwkPkuRJWY4Bwk7FDtu9THUDCnBs=;
 b=D8YYhVIeFO3VH25ksd3/KsLct2MUwQmLdDsen92tIYoXcjRq2Ncy2IYnkLmVCAdVCoZ9sCS2Q8NdNlldd7e43SD3rWfAZ9US5IKhE57Fs/Aydm+8ojH/rabunDixIvfViSVj/SsdQZCzvDyFltlXxLrAeUa1PXXZDgj7CNMo9TV6Fx3ytsrv6EaGvLllCWNXjJN9zqqHuuti0Lomc56dj0NVRdMopbbr6RKSkdiiA8DRS932E1fiJ+BPBTu3ccdz39WXf/zjaV899T14qm7rTWGyB5VR0DdFBfxmMxUOoR2akMsXXvGdMiJgubUZvbG0MY+wAzT4dk8cVWDSEBEgdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWOH1DvjkvwFd2+fwkPkuRJWY4Bwk7FDtu9THUDCnBs=;
 b=oBlBHA6RbtZwADhBxEZtOsF2PXTLT7nyH9cTupfzh9amV0G3+Gyp4SHA/gSLV1HsA8sDFTK/kWbbHIz8EnuJf8VX1uDGs8oromGkrH4CutTtynTAB+0ytjFguUA6jf4J3Ri3aP1pCI5fWqonZBIGtKara4vE/xs/f4VxyX2Bm7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA1PR12MB7367.namprd12.prod.outlook.com (2603:10b6:806:2b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 04:12:52 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 04:12:51 +0000
Message-ID: <65986f9e-59e8-4f1c-aaa7-1edf45af24d8@amd.com>
Date: Tue, 17 Feb 2026 22:12:46 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Add RMPOPT support.
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
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <9c77e206-442d-4891-bb29-295bc8bffe20@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <9c77e206-442d-4891-bb29-295bc8bffe20@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:805:de::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA1PR12MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b00c9c-f0c4-4341-32a0-08de6ea3fb9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXN4VU5pNGgwa2hOWDJkbzRLTWNqckhXZmxpV0R2Z2w5NFc1VGU1VnA2RjJJ?=
 =?utf-8?B?NDdneDVGQ1hIUUhIZGY2dEZBOVp5VERoa1k5SGhzRjUva0IxZ1NyZU52Y00w?=
 =?utf-8?B?R0VCUlNiK3NRS01VZkh1WlROU3hxOHU2OFkrRWFCVCtubit6U3pDcFgrK3Qr?=
 =?utf-8?B?Z2I1TVVEWENWUldOU3RYK0FwZ0E4cWNaOFpOVGJPNHh1blNObDJXOHpZc1Bk?=
 =?utf-8?B?WTBSTGkwRXI0c2lSWHNFZUc1MVd6YXYrQTVPZG04U0hlSXFGN2dFc29kWjdo?=
 =?utf-8?B?bzlIVmxIZllUSlhkQUdHelRGdFdMSlB6dkJmdjBWdnVCdnVaN0tub0dRb1Qw?=
 =?utf-8?B?dTVIOXkyMEgwdkZZVEtBQkxvMVBLbS9NaVIveUNmUzVCd3hWTHg4Mm5qUzFX?=
 =?utf-8?B?WjQrRzBEWGZLUVNVdFpUSm1nTjhFSlFMVUZkN0JmckZKenMwV2Fid3dYUEtV?=
 =?utf-8?B?Qjd6TjJNUDIybWFyYThFUlAwd3dKbDBLWERtOFI1S0dzSlBkLzB0Nk9LcURh?=
 =?utf-8?B?cjlOdGpUK2IvVFYyaE9tSEduL0tsYXk5TG5Yd1RyZVJpWWhXUjlJSStKdFY2?=
 =?utf-8?B?KzdDRkEvaGJPVlc1eWVsblIzQ1JwK1UwUU4vbzh6ampFVmFJbmxnMnROMWcz?=
 =?utf-8?B?dWp0S0FtRlA5ZjJmUzRTZUZLOEJ4RnpKcnpvOCtVU1o3cmsxQXl1YXBwZjF0?=
 =?utf-8?B?QzAxSDdxQ1BadEhTTW9na00rYUZzRm1MdWdSSE91MmpBZ2JHZmg3QThZaFdC?=
 =?utf-8?B?dHFhL3M4WFVubW9GL2NWNHRvaHRKVms0N1FUYmpWcGkvbjM3aERDbUFVWHhY?=
 =?utf-8?B?dkVKS0IrbW9oVWhockF5enJqc2xQc0ZINmM1K3F2NTRUTUczaFk2UnpmY2Yx?=
 =?utf-8?B?dW0rcGFFQ202VFNQdWJhTVhJK1o5YkNYK0NhTXJGK1pyUUV0dk14SVBtYTZP?=
 =?utf-8?B?UWhBMkswZnJBbkIzVU1ZdVRoVXkvUk9BeDJRcncrdzZnRWxGcEtPbjlVTllV?=
 =?utf-8?B?OEZOc3RDaHprWEpGTmlvdk11STBDUElaem1pLzZtcHZNZ1FrbkFtTDdYZ3Bp?=
 =?utf-8?B?QWQ4OEtDL1dUQ1g3aDRPK0xkV0RSSFU2a2tnVHZrcFoxY0dLaDhMUWdkQUc1?=
 =?utf-8?B?bnZjcVJhSkJvdmVOM2x0NGNTNmlCVDU4bWRuK0JPZHA5RDFWbDhOUmpBR00y?=
 =?utf-8?B?QWJ3dkRaLzIrTnlKVk9BZFFReFdZemZMTmpWWGVjLytwV2RIZEI1bEI3N21H?=
 =?utf-8?B?Y1grdGg3WVppWkkzbjZHbWkwbVRtQ3drai9HRHFuR2Z0T1luSEZBZEdpd0o4?=
 =?utf-8?B?QmRSTUtDNGozWjZKTlVRVktjRnhKeTA3WjFFaldVTE5KeWVmV1JIcDlRZHJm?=
 =?utf-8?B?Q0NxTWxqa2tCUDhFUUwyWHNHVnNwS0ZkYUZ4Smd1MWkwaDZBZGUzanU2eG9h?=
 =?utf-8?B?QjhYOCszNEFGYnVsczZCNjhJbWlicGJmVk5UTyswZ2s0cGM4ajR5WWJqZXhm?=
 =?utf-8?B?bnpKZ0xlRW9RdCtOeW9aMDFSRlJjc0pOUTZsVDlTQktaYnFxSGVOOTZ2RS9o?=
 =?utf-8?B?alBJZjk4NUtoQ1phdjZLWVZxbTljbnUzUnVzVVo0MkVULzl1RzMzRmRDSTJ0?=
 =?utf-8?B?b0UrQ3FsaXFuT0dYSDAzc1FNTE0vTFl3cTdzVkNvWEEwUkIzZHprM0Rrbi9E?=
 =?utf-8?B?U0lJaUtlYnRLYlU3QTlRVW9mVnkwNTMvc3ZVWTZGMXZiZ1JCK0tacFNEVnd2?=
 =?utf-8?B?dVIyWGpxSWp0aXdOQXlOUTlGY0V3aXd3Rit6azFoeUgrRElzSDNxZ0dDV200?=
 =?utf-8?B?bSsyN2lUVFFQa1ArZDBjRVpOSmttUjN1SDdzdjRab2k0MVViK3RUZ3gwMGgw?=
 =?utf-8?B?ZWduUGZsM3JHY1BDcU9vU1d5Z1FZSC9XV2d2Ym5pL0t6NEY4cDErdFFuMUw0?=
 =?utf-8?B?aGloYzZiaW5DMzFidmlvNEQ4WGVNcUR0YXU5NWJFb205V3dUL2NHSnFXRklQ?=
 =?utf-8?B?SDBLdC9rV1BCZ2pzOHQ2NjZlN3JEeVEvdEV5SUp1aG9NMldTREhLMVR1MXc2?=
 =?utf-8?B?RjlsRG5STGlOTFovcW5KRjFlM2hKTm82MjdvMzNsbGtkVzVxaTMwZHZPa3FZ?=
 =?utf-8?B?TThGcWJXV2wya3RTNFpJOHhvZWtuMnpQUlY2aGlOWWs3eHVhWG9RYTBqN295?=
 =?utf-8?B?ZkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0tzY2NOcHUwelBsQ29JK242b3ZwN2hERTBUclBnMzg1UnAvS1ZOUVdIc1hL?=
 =?utf-8?B?Z1QvMWFzbU5qajhpYWNXZDN3QXVMOHovVWlMeVB3enJicVcwZzhpWVdPR0or?=
 =?utf-8?B?cDdjQlRnai84MjF1TWtqUDBCUThFdHVmZmJEYnJLdDFIRFFrVTgweXB2cVM1?=
 =?utf-8?B?Z1gwdVZYNUlsNXA3alI5QlBjYnplZDBtcUkvcXNtTkYrQWo2NUF3L3RRRXIv?=
 =?utf-8?B?MitIcG9hT2pEaXEwaTdpWlpET2Z5c1NiVzZmcDR4bGJROC85NWRReHBoWXg3?=
 =?utf-8?B?Y0ovVVVJSGFiZTd6MTR4cEp5V3BsVjdYYnZYSGxaTE9tYVVvNFVUbkhuVkJn?=
 =?utf-8?B?c0V0bHU5R25EVzVwMExHS1lUdDBtV0ErV3h2VHNrYzYvSWNTZEg5R3M2SzBZ?=
 =?utf-8?B?MHh5VjQ5UmtKYjkvNlJpaHNGZTZQdUVGK3hmaWM3dkJIVDNubGVRMGt5OUUy?=
 =?utf-8?B?RStVaG0vRlRyYzZqSWhjOGdsbDhjMmdaVUNzVXE1VFhUZjZ4RTFEbnlFR09r?=
 =?utf-8?B?OGp5ZmlvRXNNc2RiZysrZjZBdC9lQnJkd1FkeWk4MTNPVmZEUWZmVXpHa0pl?=
 =?utf-8?B?Nmwzd2xvRXZoUk10VGJjaUY1UTZDZURhdU9sVlZPZVJNVEoxOEd0UGZxNTFa?=
 =?utf-8?B?SHF2M0FGTHYyeFJIQjJESTJHYlJvSEZNVmJVaUZlbXRhd3Y4ZnQrdUl2MDRo?=
 =?utf-8?B?MVczRUowbEltYmRmdkVVS1lLVUREM25qNVlVZjU5aHh0Q0pDYnJ6TGViV2Zh?=
 =?utf-8?B?ZDRSQVVIcHpMVVdMYlNncC9QWFB6R2ZnMjZmMUVsb25Zd3o1d0xLTWxxSThI?=
 =?utf-8?B?V2o5ZHlFdGNXTHlFcnB0QWlUUXZuSVVIWUpjUlRoMDhTcC9LZWtzS2FnVU85?=
 =?utf-8?B?WjV2d0NON1dFTzBKQ1RSc1dSNThWRSt5dGZuaFpyMHdaeFlwVkRMWFdDaEhp?=
 =?utf-8?B?L050NTFlMHlKelNVcHFYanREeW9aWi94azBKWFBUYkRMZmxDbkdmN0RwUFVG?=
 =?utf-8?B?eUJkUWwvMW5DL01OU2xhdUhWaHMyNVQ5ZjhtRHl4TlZTM0EzUFdTOWttWmdD?=
 =?utf-8?B?VzFXZ2V2TmxBM3RUbE5TWlFwaGRHSUhabmtmYllIaFVKQlpya2VFQS9XeDVv?=
 =?utf-8?B?aFJHT0p5dlRtQ2gyeitsWW1VU3hyOGE1VVdFdUpuR080YW5LYkxiaitOSFd6?=
 =?utf-8?B?QUJHMnVTTFhGYWUzZVB5d1RQTUhKRGFudU53WFlvalVCQ2hVZ1RKSElLcG9Q?=
 =?utf-8?B?blB1dm1hVTQ3UmpkK1NkaW9OYTlJekxEQlNERTJWdHpPazR4eDF6WFJ4ekVm?=
 =?utf-8?B?eTVsdkY1QlpZUWNVTGFtbFdzN29UTEoxR0VucDI1eERsYitMRVNGd3hXTWZj?=
 =?utf-8?B?dEJ5d254NUJpdXVUMHBNd0JJQTVySUkxeUZqWTZpN2s5STZOa3l3UUlPRWlq?=
 =?utf-8?B?OCsyWUR1cFkyc1V5MmFIY0YwaHpndTAwdVBGSW5Qd0MrdS94QUlGSTRQdzgw?=
 =?utf-8?B?ZW1NQzNQK1FqaUtZem50NFZNNitvSlRCa0Ntbi9STTFYTmdadDc0Y2JjTzJZ?=
 =?utf-8?B?cU16cXYxclVZbnVzLzh2UGxQTXZLR2doY2Y3WmFwQXhqNU4rS2Z6K29WT2tR?=
 =?utf-8?B?K2xFM1d4cUc5dUNiaUVaSElaT25YQXJmWjRzcVQ1dW05MTQ5bTFIcmQrZjhp?=
 =?utf-8?B?WnRNTmsvaE5rUkU0dnBZTExKTGV4b0VlR2I5UUlMQUhyTW9uUk5oM0podmt1?=
 =?utf-8?B?a0s5Tm02dTNEbm1NNEoyTVdQalZncndTejFXWmdYNGlLd2FydzJkc0pTZTFt?=
 =?utf-8?B?SitZeVV1am9WbFVnSEtjOXk0U2JqcXhGMXJrV3IzYUloQm5RUFFSdXV1eXNj?=
 =?utf-8?B?Q2lWQjVqdENYZWJPUnRoZnZ2aUdVVE93Mm9EeFlhanJtUDZXaEJzNGRkcTgr?=
 =?utf-8?B?MG44bC9EZjY2Z3ZsdFhzZTZXRWxGRk1CMCsvQXlHWjJjNHFFWFd4UHpsc29B?=
 =?utf-8?B?d2NSZFQ2eGZnUXVkaXo4NWFqc0VSK3JrcXFDTms4S1ptTW9MSzBEVlRtMVps?=
 =?utf-8?B?L1BkOUVVVi9Hclc1eElGMkhERXJzL2FxSHdyQjd1WW50M0lQWXhBMVk0a3Ez?=
 =?utf-8?B?Uml2Skd6Z3pjWDZpSlRvVTFlL2swT1ErS2l6VXZYUWFKZnpid0JMMVV4WkhP?=
 =?utf-8?B?ZDFSTHBPbi9qTlVqeXE0SzkwUGpMRFhEektuSGJDYVFXUGV6STZOOHVGOWpL?=
 =?utf-8?B?NXVQaldTcTh3YzNLUzJZMGY0RlVLRmNSQkJNQ2JHQ1BhMEdyKzd1bXpDTEgv?=
 =?utf-8?B?NkE5cWpPM0VFRUlGeW5RVlJYeFQxdHJtRDFkZ3hDYS82bFRkODZ3QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b00c9c-f0c4-4341-32a0-08de6ea3fb9a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 04:12:51.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LC51tKqD+cJevhvtjUU97h1p4+Bx2Dg2dEKCmon7a15/NhoZ2EXGIuG/Dz8feAwYZ8l+YiT+eeTLd1OoBaomFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7367
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71208-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: D12F4152EFD
X-Rspamd-Action: no action

Hello Dave,

On 2/17/2026 4:11 PM, Dave Hansen wrote:
> On 2/17/26 12:09, Ashish Kalra wrote:
>> RMPOPT is a new instruction designed to minimize the performance
>> overhead of RMP checks for the hypervisor and non-SNP guests. 
> 
> This needs a little theory of operation for the new instruction. It
> seems like it will enable optimizations all by itself. You just call it,
> and it figures out when the CPU can optimize things. The CPU also
> figures out when the optimization must be flipped off.

Yes, i will add more theory of operation for the new instruction. 

RMPOPT instruction with the verify and report status operation, in this operation
the CPU will read the RMP contents, verify the entire 1GB region starting
at the provided SPA is HV-owned. For the entire 1GB region it checks that all RMP
entries in this region are HV-owned (i.e, not in assigned state) and then 
accordingly update the RMPOPT table to indicate if optimization has been enabled 
and provide indication to software if the optimization was successful.

RMPUPDATE instruction that mark new pages as assigned will automatically clear the
optimizations and the appropriate bit in the RMPOPT table. 

The RMPOPT table is managed by a combination of software and hardware.  Software uses
the RMPOPT instruction to set bits in the table, indicating that regions of memory are
entirely HV-owned.  Hardware automatically clears bits in the RMPOPT table when RMP contents
are changed during RMPUPDATE instruction.

> 
> That's not awful.
> 
> To be honest, though, I think this is misdesigned. Shouldn't the CPU
> *boot* in a state where it is optimized? Why should software have to
> tell it that coming out of reset, there is no SEV-SNP memory?

When the CPU boots, the RMP checks are not done and therefore the CPU
is booting in a state where it is optimized.

The RMP checks are not enabled till SEV-SNP is enabled and SNP is enabled
during kernel boot (as part of iommu_snp_enable() -> snp_rmptable_init()).

Once SNP is enabled as part of kernel boot, hypervisor and non-SNP guests are
subject to RMP checks on writes to provide integrity of SEV-SNP guest memory.

Therefore, we need to enable these RMP optimizations after SNP has been 
enabled to indicate which 1GB regions of memory are known to not contain any
SEV-SNP guest memory.

I will add the above details to the cover letter for the next revision of this
patch series.

Thanks,
Ashish

