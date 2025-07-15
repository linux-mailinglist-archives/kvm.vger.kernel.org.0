Return-Path: <kvm+bounces-52429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE98B051EA
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8361AA7765
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 06:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869E926CE18;
	Tue, 15 Jul 2025 06:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="se7EQyKB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A241719F424;
	Tue, 15 Jul 2025 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752561443; cv=fail; b=tjMJVnL7Uuy0v+0EkcCPRciz0xHFcW3HiDsrotYMz1dcLqHYPLUSry8lHhODTWbdK44xnkeh25ga8QDnuz/suRiSXH7MJDDcrHp/4grR1FSww3ZdH1fYquqxukUFAVqlD2PwaVs/uivHvQJSnLlfyN4znslaSiNcPaVVTq3GtTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752561443; c=relaxed/simple;
	bh=rDhN8Lqo0fF1gi4sPfdGonMAzDApGjcg80rlQTP2a+I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Utk0p35y5uTtLa9LFH4Cz5DzPpeM1lhKs4lBitTXjwq1Yt7XFyLD3vLJdht1JXOC1KfZP+TBDu4vObY8iIWK+peUk4RSUiiAYDoACEhwNHc1ZmjKvxPNnE/WnDpMjhXT1Lql7EznxgKZy57pDc/W8yYxMqIdlHxoO2Egf14Ichc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=se7EQyKB; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPPx1s7a5rx6pYIcFlj0FjzhSpEh8aDlYmFfFzyiqB5gw4oLiy1s3UYwgN4aNokncldi7lR5ifPnwp/jIuu7MLbNbtTGjO81P9X4HXRFjag9WfsCpyc66sxAJcX58RXntQfzkAjsTx51BVMGArZgTqegU8+A0ELPUAaykDNIMa4lFqxeN762k4RlJCKVGcHA8fE3FeBuVBMAOaq2LJeASMXj5zplwi0+0yn9qek9ijq1Z3MHN4ILV3WH3lyJtjxhc5oBoviwDa8XC3ghQ0IxqD9V2V8kxKSXTIiWOb44K9UuyS5o5J36koOkcvq8I8C0iWHaCaGANCk5+RM9qn8OeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+k83KWZDTuZV7mCDnA8ENPdf45qfnnK6N5vrxvN1bM=;
 b=kJPc90CVZ28yOI5mG5zKKJqyG1f+5lM6sURKow4tOUtHeb/gTxDMzy6npZ7HkOYeAXHZcYahQ2adJrztnrqrcC6+wB08/gEjB/zvLmMhvvwRr7CwyxomnRXjyeC52Df9VktR3UpmBx3w7bvUcQOiEs1vYi5gLkXojspYC/X6CEJ7zXtgc8l0vCb76hY8qWPurFgHVlQQAVfrpvsXX7zPXplIfb5x7qp2bPIdOmnYiRiPC2VRrHZq3P7wEVW08gaXYtKs4dqAn6TOQgSRlRgAV0uvaFMXM4rGq/E3okPGD1kuzpTtGqKdkAq9OgFyCbyW4c5dDJ1JcFGuNBWbCaZW1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+k83KWZDTuZV7mCDnA8ENPdf45qfnnK6N5vrxvN1bM=;
 b=se7EQyKBiSfDR/eNQ/gPKjbU2oy0gHU6O7BmI627ryWw4Gpvw39/ARplw3lDsCD3CrXQ95wH6iZtIPfAVQ/Lahn5RaM/NIYdgViI1efkRcDRxFd6Q0JJnb83qYg/qnjMCehtVy7+oe7alUjqJpcQwvyb8fUClGv41hddMzndUmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by LV8PR12MB9081.namprd12.prod.outlook.com (2603:10b6:408:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.27; Tue, 15 Jul
 2025 06:37:19 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf%6]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 06:37:18 +0000
Message-ID: <5e2d0b4c-fd1b-41f0-a099-64c897b7ec6b@amd.com>
Date: Tue, 15 Jul 2025 12:07:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
To: Sean Christopherson <seanjc@google.com>, Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: linux-next@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com>
 <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
 <aHUYwCNDWlsar3qk@google.com>
 <15D0C887-E17F-4432-8716-BF62EEE61B6B@sjtu.edu.cn>
 <aHUe5HY4C2vungCd@google.com> <aHU1PGWwp9f6q8sk@google.com>
 <aHWB-JPG8r_x2w-A@google.com>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <aHWB-JPG8r_x2w-A@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0012.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::11) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|LV8PR12MB9081:EE_
X-MS-Office365-Filtering-Correlation-Id: 588f8ea5-16d7-412d-29f7-08ddc36a0ba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUNYY3V5ZzZtSzBLMUxPYW1nUlVMRkV1dHlVT0lXR2VxMUcyR0J4TlVwTkZE?=
 =?utf-8?B?Z05QMDNETHhWcjFWNE1kcFZUTEVVcTZHZmJkRkkxdnQxcE9EZXpjOE1lZ1E5?=
 =?utf-8?B?a1c3NFNhNDlkUm1LYXg0M3R4cGIzNFFPdmlIeTFTWEhRQ01lbGwzVTZqdlZ6?=
 =?utf-8?B?YlBqeXVpWmZoVEV3VU9QczkvbUo2cmNZTUhpMHk2VU5zOVFua0IxVC90SDkv?=
 =?utf-8?B?Zi9LWnFTYnFUWC93aDJFY2hOdWlmSkgrZyswSEJ3SFJVTmJna2xUaG9RaC9v?=
 =?utf-8?B?TXhDRktqOHRDYWdKTmlVOVVWdm54aERUbXNtWGpRbi9udTdKK1RHR1kvVmhp?=
 =?utf-8?B?SGdpVzBSQjFjSzNxMUEyV2R1V0RwWTh4U21FN2pVZGxDVVFNekpEM3kyaUox?=
 =?utf-8?B?TkwxZlJUNENUdG9tMzY0VTNWWFkxMWg1Q2lnWTNXZjJwdEhGZks3SEpidFd0?=
 =?utf-8?B?eFRtQ1dJekdOZWQ2cDJGYzdRbmRDWUs4TjN0c05sUzJQaXUzMzJrU29Wc2ZT?=
 =?utf-8?B?eG5pdTRXeWtqN2tZaDRuYWNSS3JlakJHNTEzbmgzK2hyUDQrWE5XaTB2anRZ?=
 =?utf-8?B?eDBZdzFRR3pBMjFuV3R1c094dm1GUVU2TVM2RTRpNmZWOEtIbENObkYybHhD?=
 =?utf-8?B?S0FDbDNTN0p5Mm1udlRnd2J4UmxodHc0amE1QktuNTVreWJaYWRaTzB5ZkNV?=
 =?utf-8?B?Nk40OWFMdHFBVnVTTG1xaUlGRGUraVJMOStBSVZuV1RiYWVUcDYzM1VyUlZ6?=
 =?utf-8?B?dUJEM0wvMTBYUDRkUDBJNXBqTW5xMU1LdWdSUGlCKzM4UG9SNFpHQlhDK01x?=
 =?utf-8?B?T2VxNHllNnNHOWdodjZQSHpTeE5uODNoYnhQMVE4bnIyaXgzNndkbzdxY0Mw?=
 =?utf-8?B?OE4rdHd6cnFpbFBaWS94Zm9xbTM0QnpEZit1MUhnM1FJbFcrMjd5THcrcWNs?=
 =?utf-8?B?WXllTVg5YnNCOU04NlR6TnJzWVM3RDIwczlRQ2lISm9tMllCOEdKc2pVS3FX?=
 =?utf-8?B?RWlFcEJROXordGtRZHc1RmRkSnRCeG5GdldiUXNBKzltUVkxQzh4VWFTVTFD?=
 =?utf-8?B?Tyt6RnJ5aDA3am9oSUszRUxZeDhpV2ZLYStneHZZVlJxNWhHOE10NkY5Q2pD?=
 =?utf-8?B?OXdSVkNBMmdKUUVBWURpZzY5NHRISEpMTEk0TDB2b3pEdjhHeGJuNlRpRmxo?=
 =?utf-8?B?TVI5SlJ1Y1lkdzZQRVlQTklTa0dwUTgyaDZmb1FSY2RteEx4MVhSa093RXZ1?=
 =?utf-8?B?STU1TE1DaENyeHlDTUQvcWk1NERtSjR0NWw4QVhVL000clY3Y1dGc0IycmRL?=
 =?utf-8?B?WXFjSlJZUTZsSjB1RzBXTWtjQ0U3c0RLenhkSEZVc1lmcmw2ZVNoemNaZTlO?=
 =?utf-8?B?NzFXdldNYWNVdlNJSStBenhucy85OWh1MEhQUjJLWnRNK3IwZXM3M1FyK2c0?=
 =?utf-8?B?eG5RUGt6S2V2T1ZYVFhvMXlieHpGVGFyUjNiQWlyd2c1ZjZQUThOU0NaWmpp?=
 =?utf-8?B?SmJJbXorWUVoRmlOUUFrQysrYXBvRVJsSG1EbVRoQ1h6Q09uRE5lWEhLZjQx?=
 =?utf-8?B?MS9JU3pFWVBYcGdUN1FoUEoxK0JTMmFSRHBtYmZvT2pOY2Y4S24yM3h4WEZF?=
 =?utf-8?B?MnpXaHFLaUdHelEzV2k0a01lT3ZuMUhQQm9mRzZ5YXRKN3lJYUhQMGVQOXFE?=
 =?utf-8?B?QU4zNm5LQzBwRTNMMWlTSXE5T2N2MnJCQnpkYUp5VjRldERoREQ4TER4Ym9E?=
 =?utf-8?B?VGp1c1RxT3VWQ2Ivbmx4UDJiUUlSTHVNbjlTQ3p2d1AwSk50dzBJZmNPUU96?=
 =?utf-8?B?RitqTEptZ0hyQ0VLTElheFF1MEltbTIyL3daM3ZhejlhbFcvU2Y1WmQxZVYz?=
 =?utf-8?B?RWE4UDRYQmV0K0wzbjB4TzVQZXFQTW5ReVVLQkh4ZmdYWU82cXVZWnlHQ3ZT?=
 =?utf-8?Q?415eI7cLyI8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzlSajlDSWJUdXd4bGJhZld0MmpmMHJPWXFwQjhQZUZjU2FMcFp2S0VHWGIy?=
 =?utf-8?B?bllERVpkQVQrL0pubHdYeHBoeFAvcmZaVjEyT05DWXdDVEVEazVhaExzRVpl?=
 =?utf-8?B?cE5OQXM4OVFjais2YTg0S2gzTXh0dUFFREIrTlYwMEltbjluSllOSndmaU9y?=
 =?utf-8?B?Z1E1U1hSekdaOTdxUks0RmppQm5oaWdXaVlkTkFJaDZMbnNzUDMvekxCVi9s?=
 =?utf-8?B?ZFdra3pqM3V6a3E5NFdDUnZDOHE0eUc0VDAybHI4azFPQTBWRG5wck83bzBj?=
 =?utf-8?B?aUkyQ2JXVG5BTzljVlV5ZjJBRWVGYm9OdWVUaVg0VE14OHkxa2htR04zTXpJ?=
 =?utf-8?B?bElkYjlNVkg1MmlIRFQ0MHdCTCs1MGVYdXVtZ29mSFBiRUNheW5UdkthaHg1?=
 =?utf-8?B?TVFuaktyWGd0bk1JVTBFZ21salFCRnhsY1FROWJwaklwMXBiUVhNRmJjUjBD?=
 =?utf-8?B?dkhyTHVFSlhFTy93dU12UTNjbjhvS0hxNW16bEdrcTBPVzJtVVdDYzJnQk1Q?=
 =?utf-8?B?dWd2YmNxWkdXTTZaK3hhM0poV0ExK3BLc2ZDaFRoeFNsZTVweWpEVmRFcE1q?=
 =?utf-8?B?TGp2ZXJhWDdBelBKSGFNNE9KRGxYNk9VK052a2pBd3BUWDV4SU9UNjF3YzFQ?=
 =?utf-8?B?ZWtRdDhDOEd1VkFSTUNJQzVPaE8rSG54NWJxYkJ4WVNZRVlHNkNLQlpVMUtj?=
 =?utf-8?B?SUpSYUIvKzFPVEV5aEJ3b2c0R3hZYlhjb3Y5QXE2OWEwN25HRDF1Tlpyd0pP?=
 =?utf-8?B?eFByRnhmUDVOZE9iNXJkc1poWnpZSUJQWXNSOTcxa3BPYnRSUkRPYnhUU2Er?=
 =?utf-8?B?bVBVTEdNUUtTRU1vSHhZbEhBdWFOakVxVCtZTkR0Z21GQ00xWWFId0dOU1A1?=
 =?utf-8?B?bDdSaC9CRjF5QjFmMEZYbjJiQUMzNXRENFhOVU9sY0R1OWwwSC9welZhSUhV?=
 =?utf-8?B?QlFraEJuUWN3QlpHY3ZRYkFmNXk5bXk1VTVKbkNiMTBHbThyQnhEUTNrQnZP?=
 =?utf-8?B?RFhSMUFXNXB5bXhPR1dFNEg3bUlEN3I4MzYxWFpySkMwblJ1bFgxeFVORk5o?=
 =?utf-8?B?RlhvZHVHRVFDUGh4dHZGNGpYazRyMi9KanNWSms3QVdsZTZKL0g5c0FxYWJt?=
 =?utf-8?B?amlTSWF3NVVkWENlQVJaaThySEdqTStSZU9KK1NYbFBBK1Z3VjNxTXJvL3R6?=
 =?utf-8?B?VnU3ZXVzTDFncVRTN3g1dVQ0VjEwZzREUFBZekMyaXNGNEg5bkVRSTZYZTE3?=
 =?utf-8?B?NG51dlJmekMydDkxVmtiZ1V0aWFaZFpOOUdKK0gvWm5CR1J0Wng4ckd0K3Zm?=
 =?utf-8?B?QmlkU3d3TEx5cnB2ZGhtdEhHd0FWNEhkQ3BibDM4QXJMQUU2dWU0a2xva2hV?=
 =?utf-8?B?SE9PYllBcXFoeEtHNC9oVlFnTFVTZHdCSS94TThmUC96dElvY2FkQ3piTytD?=
 =?utf-8?B?c1p3Q3hLY3RVOVZqRUVXZnlpU2FJcTEwVm51MnJVUGRrZVlEVFRkUWNFd0ZD?=
 =?utf-8?B?NFFqSkdDMkVZejhqcFMyTjRURUNJWlR3d0N3MWZqenZHYVBhblM4ckZRTlZI?=
 =?utf-8?B?aUFsRUVZM1YrYWNyZjVtRGRZZDVldEh3YkJhdXZvTm5rbkx6bldsM21MZ25t?=
 =?utf-8?B?VkFWazJSaE0rcnZjd2lEQnRzdFBoL1ZvQ2JjSW5iRElsOXY2YzlhemppR0wz?=
 =?utf-8?B?aUhFWStrOUZrWGlMbkdDNVpUV0tueWJUdnVEdlpkdUU0NlRKeDViUTlNRWlq?=
 =?utf-8?B?QlVweUJjSU5UREpKVzM1cUxBcHNVRDFZVnE5R0U3YTIrWGNIdlZFaWNPb24y?=
 =?utf-8?B?dVhOSEJGWXRqL0FTY2RjUTU2N3RaRmxtSXpLcFhhSzFtRXhYNERNVlNaY2Fy?=
 =?utf-8?B?WEpSSUNZcEpnRXBJSVEyOTQyd1dLdjIvenVVRkVFVXFOZnBVQWR2MGRrbVU3?=
 =?utf-8?B?SWlQN1hPWFdsSGcxc3NQQmUxdDEyRkdEd1NnSWNZVHo4dkMwdkpVSmpkWHlI?=
 =?utf-8?B?a1RGRGlheG1ZT0dPOUpiN3BNQnF3clpxc1p1VjJxYWZoZnA5TkIxWDhzMytW?=
 =?utf-8?B?bGJTM2l0MldVVnFGT0FYOHo4WlZ1YmI2YXptcGF5YWNGOW5nR05iMDNBSWlx?=
 =?utf-8?Q?AV3oZpAgP82nKte0Axt/R8V8s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588f8ea5-16d7-412d-29f7-08ddc36a0ba7
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 06:37:18.9168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8Bb6ovNHlBck75QhHWOKQg9drNESQRS9gMtJm2L3+SMhq/FuaQBCNUwL89oEBQ3xZ6YIVY+bzdOPNGSNwYGLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9081

On 7/15/2025 3:47 AM, Sean Christopherson wrote:
> On Mon, Jul 14, 2025, Sean Christopherson wrote:
>> So as much as I want to avoid allocating another cpumask (ugh), it's the right
>> thing to do.  And practically speaking, I doubt many real world users of SEV will
>> be using MAXSMP, i.e. the allocations don't exist anyways.
>>
>> Unless someone objects and/or has a better idea, I'll squash this:
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 95668e84ab86..e39726d258b8 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2072,6 +2072,17 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>>          if (ret)
>>                  goto out_source_vcpu;
>>   
>> +       /*
>> +        * Allocate a new have_run_cpus for the destination, i.e. don't copy
>> +        * the set of CPUs from the source.  If a CPU was used to run a vCPU in
>> +        * the source VM but is never used for the destination VM, then the CPU
>> +        * can only have cached memory that was accessible to the source VM.
>> +        */
>> +       if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
>> +               ret = -ENOMEM;
>> +               goto out_source_vcpu;
>> +       }
>> +
>>          sev_migrate_from(kvm, source_kvm);
>>          kvm_vm_dead(source_kvm);
>>          cg_cleanup_sev = src_sev;
>> @@ -2771,13 +2782,18 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>>                  goto e_unlock;
>>          }
>>   
>> +       mirror_sev = to_kvm_sev_info(kvm);
>> +       if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
>> +               ret = -ENOMEM;
>> +               goto e_unlock;
>> +       }
>> +
>>          /*
>>           * The mirror kvm holds an enc_context_owner ref so its asid can't
>>           * disappear until we're done with it
>>           */
>>          source_sev = to_kvm_sev_info(source_kvm);
>>          kvm_get_kvm(source_kvm);
>> -       mirror_sev = to_kvm_sev_info(kvm);
>>          list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>>   
>>          /* Set enc_context_owner and copy its encryption context over */
> 
> This isn't quite right either, because sev_vm_destroy() won't free the cpumask
> for mirror VMs.
> 
> Aha!  And KVM will also unnecessarily leak have_run_cpus if SNP decomission
> fails (though that should be an extremely rare error scecnario).
> 
> KVM is guaranteed to have blasted WBINVD before reaching sev_vm_destroy() (see
> commit 7e00013bd339 "KVM: SVM: Remove wbinvd in sev_vm_destroy()"), so unless I'm
> missing something, KVM can simply free have_run_cpus at the start of sev_vm_destroy().
> 
> Ooh, side topic!  The fact that sev_vm_destroy() wasn't blasting WBINVD would
> have been a bug if not for kvm_arch_guest_memory_reclaimed() and
> kvm_arch_gmem_invalidate() taking care of mirror VMs.
> 
> New hash for the patch:
> 
>    KVM: SVM: Flush cache only on CPUs running SEV guest
>    https://github.com/kvm-x86/linux/commit/6f38f8c57464


kselftest sev_migrate_tests passes with current 
https://github.com/kvm-x86/linux/tree/next (head 2a046f6), which has 
commit 6f38f8c.


Reported-by: Srikanth Aithal <sraithal@amd.com>
Tested-by: Srikanth Aithal <sraithal@amd.com>


> 
> And the full contexts of what I force-pushed:
> 
> --
> From: Zheyun Shen <szy0127@sjtu.edu.cn>
> Date: Thu, 22 May 2025 16:37:32 -0700
> Subject: [PATCH] KVM: SVM: Flush cache only on CPUs running SEV guest
> 
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to do WBNOINVD/WBINVD on all
> CPUs, thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Take care to allocate the cpumask used to track which CPUs have run a
> vCPU when copying or moving an "encryption context", as nothing guarantees
> memory in a mirror VM is a strict subset of the ASID owner, and the
> destination VM for intrahost migration needs to maintain it's own set of
> CPUs.  E.g. for intrahost migration, if a CPU was used for the source VM
> but not the destination VM, then it can only have cached memory that was
> accessible to the source VM.  And a CPU that was run in the source is also
> used by the destination is no different than a CPU that was run in the
> destination only.
> 
> Note, KVM is guaranteed to do flush caches prior to sev_vm_destroy(),
> thanks to kvm_arch_guest_memory_reclaimed for SEV and SEV-ES, and
> kvm_arch_gmem_invalidate() for SEV-SNP.  I.e. it's safe to free the
> cpumask prior to unregistering encrypted regions and freeing the ASID.
> 
> Cc: Srikanth Aithal <sraithal@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/r/20250522233733.3176144-9-seanjc@google.com
> Link: https://lore.kernel.org/all/935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 71 ++++++++++++++++++++++++++++++++++++------
>   arch/x86/kvm/svm/svm.h |  1 +
>   2 files changed, 63 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ed39f8a4d9df..a62cd27a4f45 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -447,7 +447,12 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   	init_args.probe = false;
>   	ret = sev_platform_init(&init_args);
>   	if (ret)
> -		goto e_free;
> +		goto e_free_asid;
> +
> +	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
> +		ret = -ENOMEM;
> +		goto e_free_asid;
> +	}
>   
>   	/* This needs to happen after SEV/SNP firmware initialization. */
>   	if (vm_type == KVM_X86_SNP_VM) {
> @@ -465,6 +470,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   	return 0;
>   
>   e_free:
> +	free_cpumask_var(sev->have_run_cpus);
> +e_free_asid:
>   	argp->error = init_args.error;
>   	sev_asid_free(sev);
>   	sev->asid = 0;
> @@ -709,16 +716,31 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>   	}
>   }
>   
> -static void sev_writeback_caches(void)
> +static void sev_writeback_caches(struct kvm *kvm)
>   {
> +	/*
> +	 * Note, the caller is responsible for ensuring correctness if the mask
> +	 * can be modified, e.g. if a CPU could be doing VMRUN.
> +	 */
> +	if (cpumask_empty(to_kvm_sev_info(kvm)->have_run_cpus))
> +		return;
> +
>   	/*
>   	 * Ensure that all dirty guest tagged cache entries are written back
>   	 * before releasing the pages back to the system for use.  CLFLUSH will
>   	 * not do this without SME_COHERENT, and flushing many cache lines
>   	 * individually is slower than blasting WBINVD for large VMs, so issue
> -	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported).
> +	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported)
> +	 * on CPUs that have done VMRUN, i.e. may have dirtied data using the
> +	 * VM's ASID.
> +	 *
> +	 * For simplicity, never remove CPUs from the bitmap.  Ideally, KVM
> +	 * would clear the mask when flushing caches, but doing so requires
> +	 * serializing multiple calls and having responding CPUs (to the IPI)
> +	 * mark themselves as still running if they are running (or about to
> +	 * run) a vCPU for the VM.
>   	 */
> -	wbnoinvd_on_all_cpus();
> +	wbnoinvd_on_cpus_mask(to_kvm_sev_info(kvm)->have_run_cpus);
>   }
>   
>   static unsigned long get_num_contig_pages(unsigned long idx,
> @@ -2046,6 +2068,17 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   	if (ret)
>   		goto out_source_vcpu;
>   
> +	/*
> +	 * Allocate a new have_run_cpus for the destination, i.e. don't copy
> +	 * the set of CPUs from the source.  If a CPU was used to run a vCPU in
> +	 * the source VM but is never used for the destination VM, then the CPU
> +	 * can only have cached memory that was accessible to the source VM.
> +	 */
> +	if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
> +		ret = -ENOMEM;
> +		goto out_source_vcpu;
> +	}
> +
>   	sev_migrate_from(kvm, source_kvm);
>   	kvm_vm_dead(source_kvm);
>   	cg_cleanup_sev = src_sev;
> @@ -2707,7 +2740,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>   		goto failed;
>   	}
>   
> -	sev_writeback_caches();
> +	sev_writeback_caches(kvm);
>   
>   	__unregister_enc_region_locked(kvm, region);
>   
> @@ -2749,13 +2782,18 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   		goto e_unlock;
>   	}
>   
> +	mirror_sev = to_kvm_sev_info(kvm);
> +	if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
> +		ret = -ENOMEM;
> +		goto e_unlock;
> +	}
> +
>   	/*
>   	 * The mirror kvm holds an enc_context_owner ref so its asid can't
>   	 * disappear until we're done with it
>   	 */
>   	source_sev = to_kvm_sev_info(source_kvm);
>   	kvm_get_kvm(source_kvm);
> -	mirror_sev = to_kvm_sev_info(kvm);
>   	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>   
>   	/* Set enc_context_owner and copy its encryption context over */
> @@ -2817,7 +2855,13 @@ void sev_vm_destroy(struct kvm *kvm)
>   
>   	WARN_ON(!list_empty(&sev->mirror_vms));
>   
> -	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
> +	free_cpumask_var(sev->have_run_cpus);
> +
> +	/*
> +	 * If this is a mirror VM, remove it from the owner's list of a mirrors
> +	 * and skip ASID cleanup (the ASID is tied to the lifetime of the owner).
> +	 * Note, mirror VMs don't support registering encrypted regions.
> +	 */
>   	if (is_mirroring_enc_context(kvm)) {
>   		struct kvm *owner_kvm = sev->enc_context_owner;
>   
> @@ -3106,7 +3150,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>   	return;
>   
>   do_sev_writeback_caches:
> -	sev_writeback_caches();
> +	sev_writeback_caches(vcpu->kvm);
>   }
>   
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -3119,7 +3163,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>   	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>   		return;
>   
> -	sev_writeback_caches();
> +	sev_writeback_caches(kvm);
>   }
>   
>   void sev_free_vcpu(struct kvm_vcpu *vcpu)
> @@ -3451,6 +3495,15 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>   	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
>   		return -EINVAL;
>   
> +	/*
> +	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
> +	 * track physical CPUs that enter the guest for SEV VMs and thus can
> +	 * have encrypted, dirty data in the cache, and flush caches only for
> +	 * CPUs that have entered the guest.
> +	 */
> +	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
> +		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
> +
>   	/* Assign the asid allocated with this SEV guest */
>   	svm->asid = asid;
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index e6f3c6a153a0..a7c6f07260cf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -113,6 +113,7 @@ struct kvm_sev_info {
>   	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
>   	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
>   	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
> +	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
>   };
>   
>   #define SEV_POLICY_NODBG	BIT_ULL(0)
> 
> base-commit: a77896eea33db6fe393d1db1380e2e52f74546a2
> --


