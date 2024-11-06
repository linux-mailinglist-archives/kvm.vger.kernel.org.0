Return-Path: <kvm+bounces-30962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F359BF091
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8F151F21A90
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754A620110E;
	Wed,  6 Nov 2024 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yf6PVBnh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD970191F62;
	Wed,  6 Nov 2024 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904323; cv=fail; b=oyXZ4HUFLN8CLub9TVuo0u221nKSDmEUE634+8SLKkZnTMDXm882Lf+FkLHg/SSlCOwmas3P1rr2HIitp1YbXOu86uQzNKVP7vBi/imbGlD41VkOPFjLnHVJ85C18pvpoIGdbXFkjSwd7NzrvKRysjqVrScFMhI8TRwiW4g9PWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904323; c=relaxed/simple;
	bh=7xh/BsEoTmvQdrHrW02+T09Du5kibtV/REzmUfqPPag=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WZLMgbWv7mJGRrBPA28ocZrhB43h0Ol8DfZvpOcpIga75A7g7hoqcbiUCmdC0F6AGYsFqJ6z5JqcBUDJ9jku75G8mJFGwbPUo8Ww5OEVxyvr/Lo7ZRRQTC8LGe9FXHHtgZyeCf/tKL+80JamlJf45q1aPXqAZovmHseXYVyjgz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yf6PVBnh; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tfJmuYJmsuDzL7HD9YCxxfT+n4MONXkTESviNybopFeRda/PQb23OaTrW/W6BMigfj90QVOtdYXeGt0dpuyVEgaYYrFY/xPLDSAxjlRTX7/HfHkgXBFDg0psyqgvH3NQpfrgnzKtzm+cvPJaVg7JH2UwVlmkiw6eBay8sAvKXDytyWXhiHX0AjF8BnFmN116uPkz10me1aMFDUlXl8OJwOzfDZxnouF8w17n4iy0yOT/MsBYJT6TC4wh9dCR0WLyy5avxJouUKsqLIg8gcZ4hbZsZek2luM0Dtm5TQrv1/1QzEoBhc+oECGkvausOtcgfYdGMw4T63UUhaEoGx/FNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxZ71LVer7zU5DXRAziOqCvgq2QfzjNJAtXCxoXw4oo=;
 b=evG7YqI60qyvYPccaW3m0ok/0svs0OqoRBCGCw4+SIkl0WjPcGGzfcPUyOHzCje1ZgNkHT3TOE0mOXgKsXisvZOQIXURfwQoLuLN7+NlEOY1lnxSSpJTuq3bpB9P0uChB8s9qanEoGV/EnQJ/nXZnUIFQzZcSIpEP2tj3fCVgZ5uT0XvyxSpTZWZ+eOWNxrbiK6oT1Mgq+S53aYnjVPH6l4Be7YPMwdMh8yoC68GgMu3g/eRbG50crcR45/B+qiA8lBY7HWq564DupXcp1KqPsYr+2AF6/vuItCKjrj7YIXptUY92Q8j0KjmJJOM6lFK+04MwUUNBoQkfSjWpRYaiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxZ71LVer7zU5DXRAziOqCvgq2QfzjNJAtXCxoXw4oo=;
 b=yf6PVBnhuEJkppyfaaS8cWsCJeSnt4qn7w1X8iovTHVOZQTQmzT5AgxtbxAx0c6xVkr1vnY3+bl6Sameo1DhG5H3tGxsY03mLqbPfk37bQ7GsUINSOBse10aQFpY7nSy3D3RdJXBKxnZHjRrQeAcRZT8uS7GS66goD/oSkbRv7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV8PR12MB9133.namprd12.prod.outlook.com (2603:10b6:408:188::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 14:45:18 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 14:45:18 +0000
Message-ID: <3f60b8cc-1075-be41-eb31-f802cac0d315@amd.com>
Date: Wed, 6 Nov 2024 08:45:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 6/6] KVM: SVM: Delay legacy platform initialization on
 SNP
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Michael Roth
 <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-7-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241105010558.1266699-7-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0105.namprd11.prod.outlook.com
 (2603:10b6:806:d1::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV8PR12MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 735a69e1-9184-49ad-d7dc-08dcfe71a1d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ci9VNSt1Q3pSUzRLeU1acm5lVXdka0FTekpLMEgxeWl5TU9tWDdGREQ3VXYw?=
 =?utf-8?B?by8yNU5NNjVHTVQ3Qng3eTh2dmdoWDJMQjBrMGFvZGhPbFdHa3hZYmluZ2px?=
 =?utf-8?B?Vzlab1BxYlBPRlliOURuMkpVUTE3WVBoMElWcnZkc293QzV5NVFWNVJvRDlP?=
 =?utf-8?B?MDlVUml3SGRac2toZnh3dG5PSUh0T09DUWo5RXhsdStUZlBxeGxNUjBLeXB2?=
 =?utf-8?B?V0FmRHc1d05uTXJ3RXpwMHdxNHVhU2RnSFBoWGhWRXhzQ3hQUWVUR0lUU291?=
 =?utf-8?B?Nk14QUZNTm9vTVRlczVLck1IZFMvQUY5TG9KTVVZVDBrSnBua3dYM3VJRE9Z?=
 =?utf-8?B?STEvb3p6akxFdWxmZHJ5dC9YZGc4NkZJN3krdEpmcW1pMVJsTnJmbERjMHdJ?=
 =?utf-8?B?UmU4TkJ3blpiaUVJanJMdmsxTlpKTi9pb1pKS292UlJPQkdUQTJpejlVVktQ?=
 =?utf-8?B?TWpRUkE3NU5HbEFScmFyWDhuMENwZG9yMThuSUNheGl3V2ZmYU92Zjg0R0pB?=
 =?utf-8?B?V2p3MnUxOC9QMUlZbURaaC9nbXR5cU15YWpleU9scCtMVlBsVkVaYmlCaE1u?=
 =?utf-8?B?aU1OU3hXR2t3TCtBNjY3bVBWdlRkY2Focm9ncDRKeXlQVDlVQVdrdGhSR096?=
 =?utf-8?B?NUVrWC9LTHFwQWV0c0NZSWlJdVVuSUZuc09PYjBtSklhNUxYcnRWKzlPTVlJ?=
 =?utf-8?B?WWI5NUE2MndEVklPNGpRTXN4Ui9nRmlPa1hrMTZpYTA1T2pndDNhd0lLS1o5?=
 =?utf-8?B?QW9WYkMxTDZHMURJYlBFNUFFV1k1RStFRUI1M3AvcFRGbjhjazMxc3FDR24z?=
 =?utf-8?B?ZEJ0dXRLbUFQWjdINkROTHJoS1YzRFNqMUkyYWRKdUcvWDl2RE9HRFpMdmVw?=
 =?utf-8?B?WC9lSFZtejB5VmVZdWJlSGhYeUI4bnBQUGxxTERzVXlqNFQvSWlaaFlZQnJR?=
 =?utf-8?B?VFJhdXBpeno5TlFRSzJZTEJreWlaYmpKckI4RCt1bFFPRUd3VExrUFpTcHVo?=
 =?utf-8?B?Umowbkw3ZlNKNzRYNlk3NVZxYU5DQmpWNEdGNUs2YkZKREdWNlVtbFFOMEo5?=
 =?utf-8?B?QTF3N0dWNnRhc1VwenFXMmNvTHdFK0V0emtmamJIVCtUbGNWUFpQNGJHZDhU?=
 =?utf-8?B?OW13TU9NUHVVYW1BU0Y1bkZLMnBQdEVxK0JCRndpNGFDRHRUbjc3Y01aaVBF?=
 =?utf-8?B?eExFSUVId25xczNWUDVEbnVhSXJlenlaMlFoZnhiYnhyaVM1VlRhZjdsSGZW?=
 =?utf-8?B?ZUdFSHgzVWk3ankzeEM1NVBxSVZXZmJyVkNick5vWG9zVGMvM3dNUEhITTBL?=
 =?utf-8?B?RHp6Tll0S0xUNWJFNWRua1pyN2hJOGxXd0xlZXNBNklBM0U5Wjd2eUN6ZVdZ?=
 =?utf-8?B?S0hESi9xUkJiZHVMdnlYMGlDMVp6Q1UwMFl0dGdITUEwZGV2REEza0NjdjZH?=
 =?utf-8?B?SGhHZUhiYzN0V0k0eFpkUlRqZ05BUjhFOTd2eVRGaWw0YTg1cUIweWk1UG1P?=
 =?utf-8?B?T0xtL2tBdHZxK0QyWmVrR1luaGdyZnVJZTRhKzQ0bXI1M3VacXB5QUcvYVlV?=
 =?utf-8?B?alhpWFZpV3MwZ2pBbEtJcFBFS21FNDM5d3RpMXlqOFVkaDBPQ3hVNTE3eXRQ?=
 =?utf-8?B?a01aWGoxSTdXelh3dkllSFk1VFNvVGYxRWVmVFRsbEdyOURCYTlEV3M0WTRL?=
 =?utf-8?B?YTRZTkVrS2FBTmlwMzZ5MTZjbDlWeUVIUWRRY3h5QkVnMzNPUkE4TC9UK2lw?=
 =?utf-8?B?d2wvZzhJdm9xZUsxS0NIQjBNWkd0QW83OVFUeW5pMzBxVk5JelBEMkJORWQx?=
 =?utf-8?Q?DewHaXRdtqGH320FM4hG9eFZrl7Ss3cYLKs0s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHl6d2FNYjBTS2ZDdVYxOEFWNDRxSDRvSUhCYStjZFFqYUFLV0xDNWw3eDhl?=
 =?utf-8?B?NmhjVlZ5VnNSa1hKbmJXaytNZzZEeHZDRjZITEhxQWFjSjA4Y2NJUTBRdHZm?=
 =?utf-8?B?MUMxQlllU3RFc3B0TGhGdi9RZWcrN0VQdjZlWjZJN0tzUVEvMjNpL3FUcnYw?=
 =?utf-8?B?Ym9VTDljZmIreUpmOHp2TkQ5YnpZVVNVbThOSC9jazN0SWxCcjEyZExtSFN6?=
 =?utf-8?B?eUxtT0ZnbmdqdWdudnBVM0tzajRVYmRNRjM4WmNrYUhROTFQc0hTN2JTbklM?=
 =?utf-8?B?a3BYYmppbU1JcldMRVFPQUErZVh3cUcvalRMRlhWK1RaQzNSQjhhenVFUmpa?=
 =?utf-8?B?dTgzMlJ4aU41a0VLZFNjNS9MdWZ1dEVCSkloNmUwTWV5b2Vwb1grWTlwTFlZ?=
 =?utf-8?B?cTJMMU96c3d6TkFhT1BZb2tTazhsUWd4ZVFJbU5iUDRUelJZYVh2RlNlWnJL?=
 =?utf-8?B?aE5BbWhpSVMrUWI4NE1sa01GRmEyMzdWdjhDaE54QkdwQUJWK2E5WU1NdEwy?=
 =?utf-8?B?NFIwaUlpL1pRMFVpZFdUb0EvUEk3YjFGU1oyLzVqNUJ0UU1tdnFEd2ZWQ29p?=
 =?utf-8?B?TC9TaGdOOVByVkdVd2tSclBmV1pEa0dZSzYrSDB6bTN2UTNEVkdxdXk1V3ZT?=
 =?utf-8?B?ZVJnUlFhaCs5U3VISHpYNzRtNGhqR3NGakgwN0E1ZVRYZks3S1FxdEFwS1BZ?=
 =?utf-8?B?RG16ejVMdll4VVB1WCtwSmoxZEp4RHdmWnFuNWNCV0ZKcnVycEdrV0ROclhD?=
 =?utf-8?B?VHQ4b2wvWHpERDltbE9rd2F0WHJrd2l2cjVQWHdKOExhdklGMEUrRU5KZmVD?=
 =?utf-8?B?Y1krRDhKUS9pdkNmZS9YdVpudDgzODdyN1lycVJTbWpTMHQwRlJibHlNcE83?=
 =?utf-8?B?VFRiWFR3bkI4TW9QUW5oY013elQ1RU01V0RiMlQyRVNGYUlWbW5TZXVzRGNi?=
 =?utf-8?B?REtvVHZnbjZEM1gyS0lqY2czQ21vTlg1L1RwZGluUGszS2dWTTVldXY1NmJG?=
 =?utf-8?B?RGFXVXR5ck41L1Qxa24rZU9JTkdHd2NlbC9TNnE1U0pJMDdheXVXSVQxbjRo?=
 =?utf-8?B?eE50aGNYN2RDazVrM0lXTTVZRDRqSDBTSXBoWDNFZWdiNHlqU2VKZUpQdXZk?=
 =?utf-8?B?TFJoYS9OdytrcXArRG9kcW5RZUVGdThGV3VUZ1ZTSFRacE0wRWlPRkxhb3hJ?=
 =?utf-8?B?K0kzOFFEZ2Mxbno1cVp3U2dKdzVmOHdKM1hKeklnbzZPZG1TdzVBbXRsQzVY?=
 =?utf-8?B?UWU5cE5pREkwN0l6a3ZVRk15RGw1R3BoSVFiOS91QTcySnJZem5ONUNZWE5Q?=
 =?utf-8?B?MlR4cU4zRENYM0tnRXZhVVpreUxtcWZuWjB2V0M2bWVEQzZVR2JleEwrQXAx?=
 =?utf-8?B?K0tvcUExMHhpVHhiRnlPOU5vdGFvVlREeUJQcXYrVHF5Z2VXL250dXdUL2Fj?=
 =?utf-8?B?L0RKc1IzQSswakRUMm4xNXAxUm5tZUFHUnYvNmNLdU10aWVabEo0NytXcHY1?=
 =?utf-8?B?U05YcTN4NU4wQWIzTUoxdU9lM3haMmVGTW03SWlrUjZuYUZGK2prdTZvYUFD?=
 =?utf-8?B?dG1FS091L0NNeE92Z041NE0xRXpSb0lOSVZ0c3lmbEQxNTZpaFBMZ0RQbERX?=
 =?utf-8?B?OXYvV3hIS1Bva2lqRzI0VnJycCtvMm9nOG9GVktFTlNYWVhJenZxVVZFanFh?=
 =?utf-8?B?NlZITXJaSVI3SDBhcTRYOVFNVVpLQnA3K3pzRGNsY0NWeWJwVXpBaFZXdUk4?=
 =?utf-8?B?c3F3R095MVJwSHlGNHEwQzd5dCtLQWxDb0hMSldnN3I5aFRad0hSZnhieWtH?=
 =?utf-8?B?cEZRL1JTcXVHTDlyd0F3WUFncUJLeU9yNEtzb0ZOT3NsZEhYdGhkM056WmNU?=
 =?utf-8?B?SHd0OGxQenFUdGQxdGFFU2c3djRBMXJCd2l5L1dVVWdtSm1DYURFMDV5WENx?=
 =?utf-8?B?UmdzL3RsOUdObGh0SHdackRUTGJsbHR5cU9FN2tVdE9vVHd5SXc1azVBajht?=
 =?utf-8?B?aUNWcnVUR05EM1RSWTFaVDQ2ZHRVdWhMbmVteEVrdWdhcXp5MGliQXpkcXk5?=
 =?utf-8?B?U2N6UThRVVJ5dGFZMEJzYkkwS0FUOEsrejRjNnhuekRvMXNBbWpzNHpabFc0?=
 =?utf-8?Q?XR41kzKSIMwo8iAsP+op5/EUG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 735a69e1-9184-49ad-d7dc-08dcfe71a1d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 14:45:18.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KwZMU+BoK+A88FyDgVKFkNLRtaXrZk0OumRC7z06knEtrwK8iUSU+EzTST0HxhfJMSNUIHTi4PidkZRwFASyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9133

On 11/4/24 19:05, Dionna Glaze wrote:
> When no SEV or SEV-ES guests are active, then the firmware can be
> updated while (SEV-SNP) VM guests are active.
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f6e96ec0a5caa..3c2079ba7c76f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -444,7 +444,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (ret)
>  		goto e_no_asid;
>  
> -	init_args.probe = false;
> +	init_args.probe = vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;

Add a comment above the setting of probe to indicate the intent of doing
this. Otherwise you have to go to the ccp code to understand what is
happening.

Thanks,
Tom

>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;

