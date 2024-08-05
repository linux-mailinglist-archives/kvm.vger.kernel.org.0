Return-Path: <kvm+bounces-23231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE39C947D0D
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5C41284F9E
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 14:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2168213C8F3;
	Mon,  5 Aug 2024 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N7k3LlHM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7758F13C3F9;
	Mon,  5 Aug 2024 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722868964; cv=fail; b=rBSTQ6PcMsfk6Kdlbn7Sgdb5g+ubc5e9Wpl5pWojjy6TGqpQ8G/2PsINe5K4b470vQgRZJifCNhp/1ShYq5ciDIT5f46bUHUkt2ZP0zMbIqI05uvllIaXx2l2MoIVlc8DDmXQXXBPCVcuP7UJbzCmgIegwNRZjMEN8Ri9yr/y4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722868964; c=relaxed/simple;
	bh=5JnN5HPpN3WZJdyvrvLQilroBYTfwF0PCvu36F9NTag=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qLdOtQ155b3AkGfZja7Xy7fViunOMv8FLUnSz+QuBCbKnN/jKyMqNWi8A6kUfFKlgA6yvjNbcKkPZOlt7AZDtozrwHq66smgoSfEpo5e0dKBsDmiJAJkhPPEFRLCWYCiY37T0zw0Cc66YIVgGG/2LcQrWZuyGVPyYAQ9dBMayfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N7k3LlHM; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwHreFS6OwtQwXIF99VeKCyXHAPMcmCTvZ3xuNBXoSdKTkQ2U445n1hJsVQmmixmSfrS94boFxrwEfJIY1Ma4rCVFB4rJN0gesWrhHbFofWXFYjftBMSAuidCLFoilid5YrP1SUlSKCgy4DlHiXCydnUi1FbuelEG9cBw99kzCd3A5QnhpjdoOqEtDsbbpbsy+6pqgyzuHaBbpqv9S3egSHqUXTXpllrRIBRMJOHzoWIDo/w9V2y6UimCGVuY5k0O7pH1Q6guQIGQRvQp7rnrjs6sRaT7TX5M5rh6FaJDaYx/WIdOMbueFJH8Fzj2Dwol7YLBYbJTIkXVI38Nuoejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMwFKls0m1OFZsefh6F+zmSBJb9M72N+eliTI6PxrfY=;
 b=cVYN81CtcZpU6amlqN7vjN1YsvVgig/qZC27mcok8ehxnBkp9LypSi7IlqHR5ac8jztLwFyBkbO+cE3S1lFcE+IJ3d3xbjdVNLgkCukOwEIcXOxbygojETraOTaqugvp34pfrjSDzqPlSJo5G6suoPx0Woj4xgaCaFHDA4wZu+EHS8thMyLnIw/a8qRZkDpEvojcMW1DPWtmaJ+rGqMT5nZaXDf4H3+XB0XgO/nv8cUjXjTz0R6q+etadxZg+GlERY94BrAnp0RJS1KmHAPuBXdelBAifPCE3uaKlh63xWxty05jI2D5+9X0U7TQi/jFQgqaMtL4EB8GePI8SrKP6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMwFKls0m1OFZsefh6F+zmSBJb9M72N+eliTI6PxrfY=;
 b=N7k3LlHM1+LFUO89+4Zp0Jaq6+8IeHBuLIeoOR00p3oNtMh3yL7ikvVoSKwrK3uCFmPHTKCcnYwjGHgL36BstK2PuyoXVGH1xgPQLip0gclju0cCmQgakLUWUobHAZOmtIrBXNALEaftE84w6f170QyLCQFAvkN6jDxSwiJznGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Mon, 5 Aug
 2024 14:42:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 14:42:39 +0000
Message-ID: <7ca86282-6a6a-8f64-6ad9-20c9581841eb@amd.com>
Date: Mon, 5 Aug 2024 09:42:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 01/10] KVM: SVM: Disallow guest from changing
 userspace's MSR_AMD64_DE_CFG value
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Weijiang Yang <weijiang.yang@intel.com>
References: <20240802181935.292540-1-seanjc@google.com>
 <20240802181935.292540-2-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240802181935.292540-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:806:d2::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM3PR12MB9434:EE_
X-MS-Office365-Filtering-Correlation-Id: d5319533-ba15-4ebc-57e0-08dcb55cdae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFpvVnRIN1IvQVVLeFBrTTVXTU8zNnU4M1p4ZWRzWGZ6Z3VDUm12QXp3bk1y?=
 =?utf-8?B?MTZRSzl4T1ZNYlFybEd0aWJCR1I1R2I3MjBhanhHd3VGRWdmSGFjR0FJN0ZJ?=
 =?utf-8?B?UTVpc3NqRWtwNm5Ud1llaEMzcFBScSt2RUFEaGRLSlRFczRLNnVnNGVQNnZQ?=
 =?utf-8?B?UUdKSUVLLzU2N2l1Z3hveVo1NlBwRVVaOHJMdi9UK25TTnBSM0IyQXB3ZUxL?=
 =?utf-8?B?UkRmZVJzamVlVW9mNmtKVG5pMEMvM0lTZXRJY2Z0cGVjTjllblp6ZmdkbUVN?=
 =?utf-8?B?RUVKWDkxUTFXbnkvb2E4bThvdi9IdWJZeGJLMnpoLzd5UC9heWdCMStFcFdt?=
 =?utf-8?B?ZWNGaTZvL1FaVld2bG1tVnlVMk8ybUVNdUt0bkg0REg3Yk85YlNWcTJTVW9R?=
 =?utf-8?B?Y3BHY2grVFl0OGlMSlFPcXAyUTh0dnI3Tm5QV2NoZ3JBTGpmMjREbnErdjBN?=
 =?utf-8?B?N3h3b291eml6TlRVanVHSy94bm1NSytYT1EzTjN2enRnamFxNDdnMTY1RTJF?=
 =?utf-8?B?b0p5VUtORHdadktJTWtXclRSb0dGRlFpL3N6UTFQUy9sSGlkTGwwT3EwTjVr?=
 =?utf-8?B?VFZzNGpoTy9MTUJMMkt3R1BKd1phczdVZ1JMajFQV2s0bEJQMmQrTERuMVBE?=
 =?utf-8?B?cmRET1cycGo1RGhtaEw2YUMrcWJIVEc5TFFPM2FkWHk5VHNoT2JBUkdKekhy?=
 =?utf-8?B?Sjd1Vk4xTXhxRnI2S1RIVFRsSy9sSWlsQnVmTjJDQ1JYUUdRcVEvM2x6WnNo?=
 =?utf-8?B?dXNWOE92UFVITk12N1Q4a01HRDMySm5aYTl3RXBPdWkydnJCZSswVDFiMVlT?=
 =?utf-8?B?a2gzQmQzQ1BjSCtuMzRybTV6YVZJZWlLMmJXSUNBVUhnelEwYkszdXBVcGhG?=
 =?utf-8?B?NURXdHhzMVFObzJ2L3dscUVuczNDUVNaM2h0OUExU29SMS9uVWFuV0ZuT3Ry?=
 =?utf-8?B?ejBwUDhZQVAxbzRnREQ0M3p4amh5V3hqLzVEV1FxYnM3QjhzalJEUThRcU5u?=
 =?utf-8?B?a3dsNThlWTE2MnI1dVZGU2NPOVpEK2ZBdWcvRlN6amxkNGlRZTJta25tRTc2?=
 =?utf-8?B?UVMyNzJYeTJxbjlvQk5iK2pNMk05YjdIMHpRWnZ2Y0t1OEpOaXpleTcxbC9t?=
 =?utf-8?B?ZUNYdFVIcjA5TFFzSDM1TVdBZVpneWdTYzhnTGdMQnYxdmdtVmFscnZlQ09Z?=
 =?utf-8?B?OUhRTEFENXJSL0VtUUlidHBJOU4xN1JkL2lYNDVKK3Yyb0IvNmZYQW42RUw4?=
 =?utf-8?B?a0JOUks2c1VFYTdWQmp1Y1Jzekh3d1kzLysyck9SdnA0bkVjS2JYSHlJQVVB?=
 =?utf-8?B?elhsQkRtWGhqdE1mM29BZ2hlWmNFYUVOTmN0MTVjM3B6dEp3YWpYdnV6YnZi?=
 =?utf-8?B?blM0cXI2ZGtLUWFiMDN1UUVTUlZVZHlKWkZlYU92a2UxSzdyZklzSEFLZ09V?=
 =?utf-8?B?MUdhTHk1b3lHUERLY3JTSDljZm1Ccm82OGFhWnZXTUFRZWE0NHZTYVVsMkJv?=
 =?utf-8?B?U0E4TDVRemdaZy9mZFYxekgvKyt6Y2t4ai9pOXhDU3VPS0VYVVdQZjc4SDNX?=
 =?utf-8?B?d1I0cWNrNCtiQTZzTk5IeXI5ZDUvODBMMkkyWmJZbXQ5aWMzMGdwZG9EVEZu?=
 =?utf-8?B?OS81UkFYTS9IK0JFampjMnBZaDVENE1veEhQWWlvVzMzemdydkZGQmFGUk9H?=
 =?utf-8?B?VkhiYlFuSnlMaXJsZlF0eWprd3FQSmN2SHdabVpLM29lQXV3ZnJPQm5TSVAx?=
 =?utf-8?B?VWtEZDU1azRnaFJrWnpxQ3hwR3pXcHdINlFSTnMvVE9XSVFNaDBVRmpzVHMz?=
 =?utf-8?B?ZVFIVHVDb1FvTnlyNk0yZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmhycmlvTXNvNW54RzIxMTYvczZkMERYbkFlbmc5ZjZnYzZ2czlWVEtTdlVT?=
 =?utf-8?B?STgzYUVKRU16TDJFNWFENlN4T3dsbTZWbE5jZHZ3YVJkQndDR2x4SmlXUnZ3?=
 =?utf-8?B?QzRnV0MrbVhGZGVla2RyeHlCNVNpd0tsbU92T1NPQWRzNHRGTTY1cEZUOUVt?=
 =?utf-8?B?dkRlTjR6ODdqbWlmRWJ1Z092Z282bW0zNW8yV3hYenpmeHFLNXF0T2o5VFps?=
 =?utf-8?B?WnVsRWhZR25lY0xxa3d5eHpwZ3VFcnpWU1ZtS204UlU5VklYK280MWtHcm5E?=
 =?utf-8?B?b1MrejR4RDdPc1J0UnQvMHlDMzkvRW5lalhSdGRWUll4bjY0TkFDTWJRa0pF?=
 =?utf-8?B?MnNDbnhBWk96U0JOMkt2dTJlZEpydytTeVFEZ0VxQXVsOTFTWkRxbWZlZ096?=
 =?utf-8?B?Rm5TMkxrVkdxam1GKzNjK2V5WjZHT3dqL216SVdzeTRKOUFXa0JJWDVCSTB3?=
 =?utf-8?B?UjBqT3V6NTdVeUJaSzViYWovWE1zMXlnUTFYcXNEOGQ4OS91aURpY1l0blNz?=
 =?utf-8?B?aVRZR1l2eWxhN2Z5cXl6SnlQUlE4eTJud3ZyeHF0d2JsRkExTnRjWk1MRUdV?=
 =?utf-8?B?ekFwMmJFSVZLMTVDYkNxVWxoOFloUjZ4YldES1d6VHRsak1FZmFRK3FxY3ZI?=
 =?utf-8?B?TjhmSWpldU55QVhLWlNSbS9EVzRlOGNxOW9ZUWpTcWJJR21FQjltWG9zSXFS?=
 =?utf-8?B?VVNERURHM1ZmT3pFRVE2dGV1ekNxTUtFMzdnYUlKRHFPRnNoZFlzbzlVdlk5?=
 =?utf-8?B?STEralQ5UWgxL0YxTXBQcUVMN2VLekUrOG05YlVmRFFUNVh1QnlJSjNGcFJp?=
 =?utf-8?B?UG83ZldDV2d0SnFjMWlpUVNKd1VjV3lvbmFLd1hhNjNwWHhFZDVReDhYNzRO?=
 =?utf-8?B?akh5ZklKMVRheERqTW85d3BYWDlxeFZGcnFBeVVzRHdsQzZnNFlpSWxGYXh0?=
 =?utf-8?B?RzJQWVMxVmdVS3BOM3lTU3NDZUxYL2NFLzhWcnVuZ2RXZDJYQ1dpOVUvUmtL?=
 =?utf-8?B?aWFhcWJlUGxtbGRjTWpESkJzN2hpYmsxYXAyenR3d1ZHeVphYlBXYTJTUklJ?=
 =?utf-8?B?dDFmTTdaQ1QwTFpMM3lEbUc0eS8vb3FmUjMrMytHbmtZNjZoOVc1OE1VVUo1?=
 =?utf-8?B?N2ZURmg3dE40NEk4TUxNTGhBM0E1RzQzNmJoL3dOdzRPT0FEVlJvQWhmQ0Vn?=
 =?utf-8?B?UklTbE5Mc2Q1andJSW9YcWJFNFVUNkhHSjlBWmdqRWpJTk9NWVBDY2xubWNZ?=
 =?utf-8?B?cXlSakw1Vit6NDQxWWxYMmdxNHVtV0hGaFM5V0J6WUMzWHBGQ0FER3hycnA3?=
 =?utf-8?B?MW1HbTg4Z0xmVDVLY2V3djF1TTZSQzlPU24rVjlVeGtpc2NpcnhGdlNhYXVt?=
 =?utf-8?B?K09sRGw5NjVMdDdCb0ExUk1WZGxqUVU1cXpwKy9mU2J5MXdJcmdmWFVuK2Yz?=
 =?utf-8?B?ajZ2czRuWTBSclFMeFRnd21IR2lUbkgra25kWC92dmgxMzJaV3dKVjU2QkZt?=
 =?utf-8?B?STZvcnJJSGxMT2wyOUtiYWVZSmJmeVhUOXlrSVRhdU9rM0J6dXI0dHNmU2FC?=
 =?utf-8?B?UzFaMUZTaXZGRDRRQTVDQnFCNGxsRmwwSzRQamhlVWltNHo3VWVvaGh3Y1V1?=
 =?utf-8?B?bXlpUk93ditFU3F0dkp0ZXIrMnBLRnEyUy9SUDBEeDlDa3FPdVZldjA1eEdU?=
 =?utf-8?B?eGQzdy8vcWtOQVhDTEtVd0JLYW9peWlNSnZ5TnZTRlZvb1NYYnljSXcwaGM1?=
 =?utf-8?B?UVN2WlZ4RTl4OWNvelJHaGJFVUszK2VkQlZtQVFRZ0o4YzliMHBKclFxbkVR?=
 =?utf-8?B?Vnlnd3ljMmUxNkdHUWhTWjNwS2VoYUZnNkpXV1RrU3RxSkFKY3pBUnNxdFE4?=
 =?utf-8?B?RTd1bVU5T2YvMThrM0xqQytsZDV5QTZ6L0krUDhRclBhY2R6K2hIUzJJaTl6?=
 =?utf-8?B?VjNWZC8wcGUvWEFXZThKK1R3ZG1ncno3OCtjVU9DZ05sckMxMHllaGNyRnJy?=
 =?utf-8?B?N2tTZG5acmp4NG9RMVVuOUNvN3I0WU0vSWVyUHNuQ3BzbGZCRUFoYk0vRlVL?=
 =?utf-8?B?K1o0eFg0WTNNenNzTC9POThQVExuZGZFbExURmdxUmF1L24waTF1NmlYV1Jl?=
 =?utf-8?Q?tFVm5z0xRRRjSkZ46md2Q1bPd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5319533-ba15-4ebc-57e0-08dcb55cdae0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 14:42:39.5162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nu5tRlLSJO0PvupEBh1WTsfr2vl4PPJsDci1C7im6WNBvCkXoqSd2jLBlLQT3py4C6h/sMMqinCKVxFi5+wpug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434

On 8/2/24 13:19, Sean Christopherson wrote:
> Inject a #GP if the guest attempts to change MSR_AMD64_DE_CFG from its
> *current* value, not if the guest attempts to write a value other than
> KVM's set of supported bits.  As per the comment and the changelog of the
> original code, the intent is to effectively make MSR_AMD64_DE_CFG read-
> only for the guest.
> 
> Opportunistically use a more conventional equality check instead of an
> exclusive-OR check to detect attempts to change bits.
> 
> Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for serializing LFENCE")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

(one spelling correction below)

> ---
>  arch/x86/kvm/svm/svm.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c115d26844f7..550ead197543 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3189,8 +3189,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (data & ~msr_entry.data)
>  			return 1;
>  
> -		/* Don't allow the guest to change a bit, #GP */
> -		if (!msr->host_initiated && (data ^ msr_entry.data))
> +		/*
> +		 * Don't let the guest change the host-programmed value.  The
> +		 * MSR is very model specific, i.e. contains multiple bits that
> +		 * are completely unknown to KVM, and the one bit known to KVM
> +		 * is simply a reflection of hardware capatibilies.

s/capatibilies/capabilities/

> +		 */
> +		if (!msr->host_initiated && data != svm->msr_decfg)
>  			return 1;
>  
>  		svm->msr_decfg = data;

