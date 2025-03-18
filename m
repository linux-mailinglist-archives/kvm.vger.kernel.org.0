Return-Path: <kvm+bounces-41447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF01A67E0D
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D4CA19C297C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7582211469;
	Tue, 18 Mar 2025 20:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QEtg0aqj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9CD1F3BBF;
	Tue, 18 Mar 2025 20:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742330131; cv=fail; b=WsPEmwvdfALovnujthnyzcxfsdQh3zbInjXH1RzcRRBhPswIqNgJ9mG/KgfJOChx/hHORoaW0BcCfjbCVCHeXx6jN7iWdm4sI8diuav5ClIT4Fvn66czepbdA+EOhi6JfhMWtexKKEkJc6/bSjI2wNke+bl+sSKshpG9somBgRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742330131; c=relaxed/simple;
	bh=KhbBB8/z9p1J0GUCpXG9fm74pxxlLLbrYl2HxZeMTvI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XMu4L/wWDDdIjKzPxhzhKjhq4I4gGABduGHilxuQ+E6vax3N/tW0xpos3iTnJ2LE/HUDL7ADJwbv3anIGfCOh8IuCl8ZWGeNKAMY8RzdWxxBBfGTPQ+uubRP/EWfxbP7hSIUEo89JaD8u672ICHVb4t3pE/gfoz/G7HqzVQ8bRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QEtg0aqj; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4wI8iYDwSGz82e7HMYT1qr4h1cDQf/LFcn1fdJ6KNW9vVuJBJESyoeWRYh3EIwXT2kU8IMWMpX5EZsQFPmh1Ap0MxkqbOetJ9xKT2tzfJF6I8bF1yZlbqdum6KKyDMgwDbgoADL0/sVWj2wqm+Vb57bK5UDsjCC1CmfsurQLY+BvlwCJ6YrOd3njM07ZSozJh963Zy9ucP5klfu8fOlDcUUodqZELpyklXyiHKRXIlxcdpvzSzY1VSc3Wm6LWPVqWbMZzmtFOkScpIzxhBI7JlkKJP9q3rgNIQZ9NGF6SncHfwXsO5/vSuzCizBrODW91k1wbJno2I3a9+H8J+tuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7Fq+mpJ+jUnRS+XfYXOhHYnEoal5jHQtkul96UW1NY=;
 b=wSsv4CbD8IsFR6GShhOha2fw5DIixicL0JyK4mQ3hC0I16wKbaou5TKdjJdJDIPVuTBW3Y9y6lTUCCeH1PyUjaQz1SqEwNCNjmrv3k7TfQLYn0kUxVk/TAqOpF/IqVCgqH2lCwebcrVmtqnYRWCMmlamtcYd7Y0jrrH1hpwCBTJZmbCfbw3ASgnFQvWJb0GQK3S4zyg3XAUNhYvVjMocvyRSyVqxPXKNOTzT+Ii63lfORkI1tiWHieRGz59l7pwY9eHE8bsvU2bNRJbY+9u6ODfxtzIiK6WIMmOGHyQyV0ojbpvy73c2jcsQ2iTDayhYWuK/Wx43E1fOnz3wOU6n5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7Fq+mpJ+jUnRS+XfYXOhHYnEoal5jHQtkul96UW1NY=;
 b=QEtg0aqj3Y9Let4/Wc3oZJqkwo2Ke7Wa21HkB8lZsPWMngMt+VPRi1XHC5zBxQERybnOIWxxfvVgVy8UtrVTT/0k6niM8u/MQbGUUW31Y9sJC3UhlgF09r6J61zWk//4S3ITmCtZRMsQkV4fw7CVoAmtdfAw5/MRAGyJRp4zjqw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BY1PR12MB8448.namprd12.prod.outlook.com (2603:10b6:a03:534::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Tue, 18 Mar
 2025 20:35:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 20:35:26 +0000
Message-ID: <d8275270-cae8-4b35-8088-32da759a5e94@amd.com>
Date: Tue, 18 Mar 2025 15:35:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp: Abort doing SEV INIT if SNP INIT fails
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, bp@alien8.de, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250318200738.5268-1-Ashish.Kalra@amd.com>
 <93e7bd21-b41f-8d78-f9d1-1868e944efc6@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <93e7bd21-b41f-8d78-f9d1-1868e944efc6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0103.namprd12.prod.outlook.com
 (2603:10b6:802:21::38) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BY1PR12MB8448:EE_
X-MS-Office365-Filtering-Correlation-Id: fdc8ec49-e02b-4ceb-75b8-08dd665c6a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEhERlpKZzRiZUpVbHl6ZnZwTllpY29RMTQxV21CUzRucVZ6bGg4RTNNU2Fi?=
 =?utf-8?B?cXZvS3VuVDl5Vmk2YVMzdmswWHJoLzFGQjNpMkNybWNSd3lFU3VWaTkwNHVW?=
 =?utf-8?B?N3dRYlAvaCtFTXo3Y1RMTTlFcHRjem42L25wZlJSakFqYzA0bXRHbzdueXRK?=
 =?utf-8?B?Z3lZZnhFVGdYUUk0a2xaNXo4Vk9qU2I3U05QMkk4clMvVVVXWnh5ZlpCL0Uw?=
 =?utf-8?B?V2N2VVpFdnlPT3VWblRGV3FxanBUL0kxQ05vTC8wWW1BK21uRGlkUnVDZ0hW?=
 =?utf-8?B?dkFRUWYrdzJmTVlDWVBuYncyQjdJNkNqd004Q25lVEFObTFUazZWc05vWDNt?=
 =?utf-8?B?WjJBMG5jMHE1anoxQ005cU5xbGx3NXpHV2Y0RHU1UWdlbHFubWhZclQ3L21Q?=
 =?utf-8?B?V0drVjJLYWZxTW5CcWlvcFMvaU1uZmZwT3VuWWRVS0RGTEZWNWorWkhmckRz?=
 =?utf-8?B?My9QMFl1TVAyR21RRmYxc05FdDJ0dUEyTUVpMUhJQlpWT2JZQXJaTzRzV3JL?=
 =?utf-8?B?TlhFK01qS2hkRTh3UUc2blZnUFBjYmV6UDQ2bm1zMXhKRjY3enBYOC9HMnBX?=
 =?utf-8?B?N2RvZ1pORkpBZXYvT29sbGl3a3JmSjlneW9GcmRMRCtEdHF3Y2hMbWlxUEtx?=
 =?utf-8?B?Q1JTMTVieDZ1MzZnR1FoeENiZFBMVm9LSG5vSFlkcmZpVG5rdmtPaFFnV0sw?=
 =?utf-8?B?ZkNRc0V2VGRtNUNkOUxHRGdQMWdSL21UNndWTE1TWnkrVG9ldno4WTdIUkQv?=
 =?utf-8?B?MG9HQ00wNGV4QU9QbVlCQWdCZytlTXJXVm9WNy9nc1YvOHJmT0NVYWR3eXlZ?=
 =?utf-8?B?YXZoQkU2cGhUVlk2Z1Z2ZkxOVmdBTWhUbjhNRS9FK05pVFAyTmpsNHBKRG1k?=
 =?utf-8?B?clNCQ01YK1NLU0R3dk9CejhJUG5rQTBuSmw5QUNWK1cxa2p5YXRlWDVoUUhx?=
 =?utf-8?B?bWhwcTJ2SVdSMnZzYzNNWUtOV0RTUExjZno1ODIwUHl3WGZBTXN1VEZwT3F5?=
 =?utf-8?B?eFNyS1NwMkhJa0JJOFJtNzdHRW82Wmo1RCtlUjArLzc3ejZpSnE1dFpxSmdi?=
 =?utf-8?B?bzRGOFJ4UXpvaFZrU0d6NDM0cUdIZnh2NmhBWWdpaGZLS0NmS0pQQUFYME1q?=
 =?utf-8?B?YjlSSGZaU2xSdElaOHV3cU5kSThKK2ZpQ0NWYWhUMWxoRXdNVkwybHg4OUN1?=
 =?utf-8?B?Y2lTcXhYR2F2V0JUaHhiUmpwRlp0SVBlZjFLY1VSaHNZNDR2Rmt0enY3OFFS?=
 =?utf-8?B?RDRnbDY0Q2xyeTdUc2RTT0hmVEVzSjNTTXJ0RDRTdWMzY2RYa0hvWUU3Zmh0?=
 =?utf-8?B?TU5ZY2xzSlJYam5NN0N4YXErTm1Qelk2STJtUTYwVmxGUzl1Y3M5dGxSeVky?=
 =?utf-8?B?b0hGeFBLUTlVbkp6ZUVDN3JPckdIMUlNVlRsTWVqaXpBeFhVVThUUEhzelli?=
 =?utf-8?B?Ym1QNXpkQzQ0ZmRtZzNEUGcvcUkxZUx6cWFDR25Jd1BTWGozclZjaENzQmw5?=
 =?utf-8?B?UEQ3ZDhvYVJXb2xlaSs5eS9Gank3U1hIdi82cGp5blRvN3ZwblA5MUxVcnh4?=
 =?utf-8?B?dGEvRDNEb2RKUGhDcWhvSFp4bUx4SnVCU1U5Q3F0NHhpTTc3ekk4UEhXZ2hL?=
 =?utf-8?B?ZFg0SC9lYTlIRkhMTzBIOGhUT29PNjRJazJiMHdJT1VMaFNQOG9oUXZxZWU4?=
 =?utf-8?B?cVlTWndVbTZsWVY5ZlZOaVNXV1B5T1NjUjd0dVFNTm1jalgvbE85eFpBWUp5?=
 =?utf-8?B?alpyNk1lblFCaXBsWkIxQkJIbzM2NFkzY0Z6dFd4NFFKSGlaUUJwa09qdWd3?=
 =?utf-8?B?Q2djOHRjazVQaUZMbDRzZVNrU3RZSU1oMkRSWnR2UlRuSEhKQlF0dm4vMFhN?=
 =?utf-8?Q?j9OawrEmpiI4U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ui81TE1sTmJldUlXdnpCclc3NDNFV3FpODJreFVXeXhDNzBrM3kvR01CcWZl?=
 =?utf-8?B?aTNkQjlXSjBpdFA4dTViSS9pczM5UlBFSXdPblNKNWdwR3lTYU5rK2tXRkVw?=
 =?utf-8?B?QmJaMTJpczBCN1hLbG4wVGs1WGRRVzk2WjM1QUF1R2l1d0huU1VoYXFTUmxo?=
 =?utf-8?B?YWlPYVcxdkxZOE51a2s4S1pRdEVTeXNHS2RTWWUzUHR4YXNqcjdXVlUySW9C?=
 =?utf-8?B?bE1TUm5FVzcwSUYxQm9wWjFONzIrUUxkMHJLU0dWcUpteTU2ajA0aVd3b0Ex?=
 =?utf-8?B?QlNBOTYwZDZxc2JaWkMvVHV6T0srbzZsYTU0dE5MR3VqMTEvTXlhV2ZIR2R3?=
 =?utf-8?B?c3lwL0ZWc2xkZU5kdFlIaDNiR0hRL21qelhtczd2VTNVQUZpVHAwaWlhMzZ4?=
 =?utf-8?B?SmhKd1N0V0hoRjJMSkZ0YUdBOGVacnZ5aGY1ZDJML3VGN29MbkhwOU5xemht?=
 =?utf-8?B?MkM5RzF0RUNVZXZ4a3N0ckZBbXNqdmZTY3l6QlpRNkF5ZmVLTm9YS0cxWk4y?=
 =?utf-8?B?TUN6MmduNHM3RlVyaFVnMFRFTkVRN3FrUHNZb2FQbFVBOS93Q1MxK082eHVG?=
 =?utf-8?B?OVlBM21iRzZwMWRXTGJyOENEYTd0Y3Z0cTViSk55NjRUMXNKdU9qd29ZVzB2?=
 =?utf-8?B?eHg3QzFLM3dlM2czSW8xUnF1UnBIRXpzTGNzRHdFWkJzQkJscHk3N3N1VEZj?=
 =?utf-8?B?clBNR0NCMUp1TEZ4SHZIT2RjVEs3V3Urdy9ZeFFZVkxKQmxBaitPNnhKZVAv?=
 =?utf-8?B?djBJQWFUM2RkZWVWczlpK1pDN2IyczZKN0haT3VwemJ1a0ZlMTVibjVEQ250?=
 =?utf-8?B?SUNSOWk0cUhGcVF1QVdnd0hXbUE1UFVBS2FVQ1lNNGxrbnhyYXc0WXdBMVd0?=
 =?utf-8?B?Q1lMUEtiNFJzN0F3VVl5S3M1bERhUlM2QmRpczVlUDRBeCt1N1lCMTZRcGY0?=
 =?utf-8?B?WEZHTHl0dG5BSHNjZU5RWnlONVBSV0VhNU1yOEY5VWNwQVV4Ky9oaEYrZ2p4?=
 =?utf-8?B?bWppQ05lWEtTaCtVeExBTXU2YWRGQVphVTNTRFgvNnVXUEV4RXlCS2pad014?=
 =?utf-8?B?NitzVEMvaTNvSis3QWZzOVc4VTczUGpXU1lKVFQ3OUZ5SFVsOExnQnJmSEo5?=
 =?utf-8?B?MTZncUFzaVh0UEhuaVZCSGMrRFJKNEhRcXdzc2pqVmdyRFNHSSs5Z0Y5cGN0?=
 =?utf-8?B?NGVoanJSN0pRNmFaT1BwYk5EcUFZRDUwNUxOeklMa2x6eGlDS0xiSFdMZ3Nm?=
 =?utf-8?B?aEozdzNscEZ2dzhXdjIxZVVEYS92NldMNnF5RGJNOWoxSDY2bTg1VVNDazhk?=
 =?utf-8?B?U053RHFjU0IrN1Q2cnJ4OGRXQUs2M3paSTJNd0Q1RXFuY2x3SlkvQnpEbktN?=
 =?utf-8?B?N1ZIc2NZNFpVbjd3RkcwelNJQ0pwbTNTeEliUWZlQ0ZPOVArTkpIamFteW9K?=
 =?utf-8?B?bmpzN0RRQnR4d1cxR0ZZWkNWcWdQZVNHV1hnRlUxalF3Vk1USXNuM05BNWF3?=
 =?utf-8?B?Rkt5MWthdzJvZ0tyQ0t5bTZ5alEwY1krRWpPbmFaUkptZFQrc3ZseFJML0g2?=
 =?utf-8?B?VWY4UVB2SDdaODdRRXBncDU3S2Q4MFJ6Q0NCLzA1STg2SXJDVFBxbGdYNXl2?=
 =?utf-8?B?RGFqcGYwTkpaMGJVWWhyT0pRK0RZQmU2KzRKaTNkU3EvdEtTU05vYVRTQTF6?=
 =?utf-8?B?WWNZQ2NkNGs5WEJPOGd3SGhvU09sNzZySVpPM2ZKanlKdnNNcWd2YzNlNENy?=
 =?utf-8?B?MnYzVU1qcDE0TldTeU50TElKanpROFVjTi9WUWtwZGNjdnoyeVg3R1JWbmNB?=
 =?utf-8?B?YlJGa0MxQ01qS3VtZUJUUjdnYTJwTXdJZjl5Qk5wQUdiQW0xRC91YVFTckZB?=
 =?utf-8?B?SlVqTElyUllCNmY3cXpQYmhscERFbEVTQUJncVJLeEphVHJrUzlZUG5uNHZy?=
 =?utf-8?B?SmVMUXdDa3Nxam9BaGpFVXBDNUpaMGY3RDlnZGMyamRVTkhhZkRaQzVsQWdC?=
 =?utf-8?B?eWhrckVuclJGc2dTb0lmSmdKeVowOUx4Ymw2bTMyTmtSQ3J0VmFhelFZV1c4?=
 =?utf-8?B?VENlMXR1YWJkNEo5VHZ5d3V5bC9pSHNwTXZ5VEp0REJGcHdaeC9KWFRlcXM1?=
 =?utf-8?Q?/rOwiRiM7qhga0bNB5LV/tE16?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc8ec49-e02b-4ceb-75b8-08dd665c6a50
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 20:35:26.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvoV+Ln6iuvW2Bei5HVdjTtV5YbFH/Gzv8guldZHgxExUybapxzqnDDDZp26R2qRVRF1dPgxKfpEseIHI2YVJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8448

Hello Tom,

On 3/18/2025 3:29 PM, Tom Lendacky wrote:
> On 3/18/25 15:07, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> If SNP host support (SYSCFG.SNPEn) is set, then the RMP table must
>> be initialized before calling SEV INIT.
>>
>> In other words, if SNP_INIT(_EX) is not issued or fails then
>> SEV INIT will fail if SNP host support (SYSCFG.SNPEn) is enabled.
>>
>> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> 
> Just wondering if this really needs a Fixes: tag. Either way SNP and SEV
> won't be initialized, you're just returning earlier with an error code
> rather than attempting the SEV_INIT(_EX) and getting back a failing
> error code.

Yes, that's true in a way, as continuing with SEV INIT after SNP INIT(_EX) failure
will still cause SEV INIT to fail, we are simply aborting here after 
SNP INIT(_EX) failure, so i will drop the Fixes: tag and post another version.

Thanks,
Ashish

> 
> Thanks,
> Tom
> 
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>
>> v2:
>> - Fix commit logs.
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 2e87ca0e292a..a0e3de94704e 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>> -		return 0;
>> +		return -EOPNOTSUPP;
>>  	}
>>  
>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>  	 */
>>  	rc = __sev_snp_init_locked(&args->error);
>>  	if (rc && rc != -ENODEV) {
>> -		/*
>> -		 * Don't abort the probe if SNP INIT failed,
>> -		 * continue to initialize the legacy SEV firmware.
>> -		 */
>>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>  			rc, args->error);
>> +		return rc;
>>  	}
>>  
>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */


