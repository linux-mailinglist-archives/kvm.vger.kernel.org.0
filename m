Return-Path: <kvm+bounces-31772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 759A59C7973
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74F4FB24658
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522A31DEFC1;
	Wed, 13 Nov 2024 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WvDQhT0P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2078.outbound.protection.outlook.com [40.107.100.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9434158861;
	Wed, 13 Nov 2024 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731512400; cv=fail; b=ItRe1g7ZkbyIZTkYEXDffzwN3IDZggBDqmf4oPkdwxe2JwBdxUiMr0qG/GQnVlRnqO3TTJYZdnMlYyQvmKiiGYJl2BCUv5Ac+O7N6bL/GaOQb5992DAZbQcbN/eW9mJXwkOaAPt/FG9r+ctI5Q7OFqNkonYSmsSkWl07uONPzEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731512400; c=relaxed/simple;
	bh=8EmwvRK/l5g/7domStRIKmVeK6O+kn8bWeILPrYjVW4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eJyZ/JN+EAxbr4xUp6GJ8nSm+8lz16oS03DRT/OKX5s/Et3OeCr3YQCqx7HPOSOpcgHDiLWZIqzRH4dEvqyEpCMoWEx+ikPgIDVgqwAUqAzvwiR04uZ8aVMAl1JJvZj2kkUtBFvvLE/2JAfk1qyFqd81UqEc9+8NKax5ztRJJds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WvDQhT0P; arc=fail smtp.client-ip=40.107.100.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOR0TfaPqbp+qpn0Y5NPebZ47+J2tyezPRVV52J3mXm0rNGQU4n+uC95dLZAWZeT97r/lQK7b64jM5ONfkL6KqBLBOURUimFXTytvJhoqSCtrzgkI2Q1ICErXXaphx4N3r2Gr/129WQrE+xdwwMtATiy3PA/2fbloPyqbh5B5I47BIv2ah1SOWL8St1V+zy/qme2wXg/iG1V7COeBG93xmNN4nayXvezxkrUPt16yII7PrmzdKDNxWV8oVeWHddNredfHoVu8mdCUIUmcZWUmK7t+DR21X/ouyHmukHy4YG4EAwbpcYvt41bywuAhVThUPvEY6TpSoe7Ya7bXNW4mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8j7MBGx/tBOH7ZS+X/Xd6rTNS7s+ZZL+PBTxALHBl0E=;
 b=OhX48qscAOUSEOMYEE6FSAYXXvF6dFgh7ADMRCOcyMFaPS3FtEnh65aHy/0hyFLdiqC3SPRFZvFxCUhuq6tWkwulk97tJxpltVSrYm/vNF/szP9BsMmByLshB3ndq1c8C01QA3FkvRB5G6Trz0BtqxIrfknMPkK5y6p8tNFMyoaks01axtPM08mOEpsp1AiVJqOjTlx3/XTYCoA0nVDGkj6cHk8B1jmdGgUQ3IRwSBHePwIWiTH6hb9HjcXZkkRjHyB2RLopnD6EXZhUuFwDomGuOv2KFu/euW0HHdVap1Mi3IbQpzsyRzfIkyaga1vwytzdadVIxW2QaAsRWUvUkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j7MBGx/tBOH7ZS+X/Xd6rTNS7s+ZZL+PBTxALHBl0E=;
 b=WvDQhT0P/hG1hm6B5lBh+ku+Pn7epdMxVmSd1DBZ8F61pEqLJ7x57sQ3f5wTEpVmRB/FdGOcIKFrdeFB6NN+rzTpF9tgxFOMVsGR/9UE6dMMJadM0kR4TGxicfh22WuOFpGHNbNUO8cne+igGtjbEmeCf899cCXCfbYYulx9uro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 15:39:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 15:39:55 +0000
Message-ID: <4d5be1b5-1a05-00a8-bd00-96ee914c38b4@amd.com>
Date: Wed, 13 Nov 2024 09:39:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 2/8] KVM: SVM: Fix snp_context_create error reporting
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Brijesh Singh <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>
Cc: linux-coco@lists.linux.dev, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Luis Chamberlain
 <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 stable@vger.kernel.org, kvm@vger.kernel.org
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-3-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241112232253.3379178-3-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:806:21::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c32f69e-352a-454b-e0bd-08dd03f96c17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MStDTDhOWjlpNENISFlETzFoVjFYUmJiRDNnNmNRNERvaDlBOFkrbVA3dVBX?=
 =?utf-8?B?eUtuLzBLSFczV3NwUmNWMm5sVVVvTDhWMmF5TUlRTzRWaXpzaldNcEV0MHlN?=
 =?utf-8?B?NmpiR29tZnlFRE1tN1NEQkJKUEtOQzRNQmkzcEhXVEhnVDdDR25NM2xjZEFt?=
 =?utf-8?B?eTNNWXRvMFdXYmlsUXByRTIxMndaK2RCNUcvQm1GdWtuZWF0d1RTblNMWVFu?=
 =?utf-8?B?bFBJZ3p3MCt2Q1d0WEVnMjZTcWFZWXBxZG91RmUxdnhtazhQMUk4WVUwRUFn?=
 =?utf-8?B?eld6SndUaHNTUVZGMEZVb3dKY3VDSGwyWE13b0d0OCt2N3Q5dHFyeUw2VWhO?=
 =?utf-8?B?WkxmTEdaNjN5b0dBR3E5SFk4QmdSekxoZkpEaG4vcHI5Nlk3L1hRMzlyTnpT?=
 =?utf-8?B?enNuTi9qWHNxbTFGa3ZpSllWRFA2RFQyOEJiVnJBQ1B6VTVLZU1LQVcyYTlh?=
 =?utf-8?B?NGg3YzBKYVlCSTVKTFZWOUUvNmRMOGZVT1MyOUZjcTlRbUE1V1ozbEJSLzQr?=
 =?utf-8?B?bVA4NlBhM0pTWW5LWDlFdTlYRmdkbm1VSHZ4aHBaU3ZSb3FLOEpUSndTU3pJ?=
 =?utf-8?B?eWVabXBxa2ZYbGE3NzhCY3RoVkVpM1licDlFRmQzcloxKzlIYkZLc2lvY25B?=
 =?utf-8?B?ZXNEWmNIV0pWWVBsd3FlRk95OEpQM0FpcXVGUG1sL2ZBQ0NyYnhEYlZ1Nkwr?=
 =?utf-8?B?WmtlQ3hNODhXc2UreFVrd3ExUWtWUFN0c2pYcGFCYXFQWlc5ZkVZS3NGTGMv?=
 =?utf-8?B?dVlPaE9GSkgxeVhJU1JYS3krNkZSSzBKM0JMb0cyeHhrT1lRRGZaeWE0amo5?=
 =?utf-8?B?Q2V6bzVCVjI3VVFnTzgrNnoreHdzOUp2OEl0RHVrMXR4NkJQSW13ekR0akw2?=
 =?utf-8?B?ZFBvWTBGOTlBTmkvdi9DOUtBRFAybEhhZXgxakxSVW1MNHdPeWh4U1lQelFU?=
 =?utf-8?B?QXBlMFM5YXNSTUtIMDhjY1pnZkdITjR6cGlTdk81T3I5ejBFUFFEa0c0SUpK?=
 =?utf-8?B?ZDEzVmZDUUxWNFdmcnlySnZHa1pLQ3ZIb1A3eGhMS0hnVWZhakRQV2ViTEVv?=
 =?utf-8?B?S3pSTE8xL1NTOXA5UENIQW1QTzlaR08waXJCYkV2RlFKMlV5RE9NWC9nRzRT?=
 =?utf-8?B?WmQzRUYyNHh4ZUVnTTZuSEduc1pBT2xYbzV6SXZic3F4TU5waFJsdDFDVlhI?=
 =?utf-8?B?dExONXlLTXhxcXNLRGJSQjY5ejY1dUNTdk9PNEdRUE9RL0hBRXJxeVhLdWdX?=
 =?utf-8?B?cVpoTVdwSy83d3MxTWkrVi9PZXh5YkJRMUxxeXhtRDhlem5Fenk1d2Q1UFNl?=
 =?utf-8?B?WmUxRWJCVWZvcDNWM0dZcVFZOC9ZRmVNeGZ6eVlZVEoxaS9ENU1rYnNTcU9y?=
 =?utf-8?B?cjRTU21YTXArekd6SndlL0puaDJDcGo1VXc3U1Q0aUFocWdLMHNhdksxMXRZ?=
 =?utf-8?B?TEVWVUp5dTErWHVOZjYyTVlXaUFDd2FEanQ4QVMvbmx1QjY4T0hYNHNCYWJw?=
 =?utf-8?B?QXVNa3pPUjlkMXM3eEZKa1pzTFd1RFB5OExSeXpyN0dSREFBRGVuMk52ZXNT?=
 =?utf-8?B?YTBIQWpsUEZucDE3RGQ2OGlXYWtjWkhyaGE4Sk44cWdHOXgzSkc1NTA2Rjdk?=
 =?utf-8?B?UVdrMTY4UXBzQmNra3FCdVZ6Q3kwbVQ2ekg2VFdyeTVZdXZDNERYNDBrNzl5?=
 =?utf-8?B?ZzZod1RsSUVJLzMzWHdLODZUQ0lPNG51ajNpem1Hc28yZklLN0ZNZmFqbzNi?=
 =?utf-8?B?cThJQVZiMjQ2dEdxR3ZiOWFLRVIyK2gyL255MEVXNXJZNEdnRWdlVlhWRlJV?=
 =?utf-8?Q?ol2G5+29jMZCE2z6IA/TJyf0eRE2JqF6XKLXc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTRXQzhPZHY0T0lYMDFaVUkvNTRQU0phVDRsR1QzbnI4cFJ5NXgzMitkdCtH?=
 =?utf-8?B?c2NjMFRGZzdEWXoydTVWdzFWS1owUVM1aktzdHZsVEowY1A2anliUXpuTnJ5?=
 =?utf-8?B?TjB6Z0xSWGlwWWN4OHFpS3dGWjhOUWUySlQ5ZUtiMk5pQkRwMkpzUzJTSnVC?=
 =?utf-8?B?QXZuU1NndTNuTzdTa1IzMWRsVDRMVE1aMUdVV3hvSHNweWJLR3dnOWhjdTNt?=
 =?utf-8?B?YThCNTI1VzhvSUZiZVl6ekpsNVhaMFJua2dyaW9Da3VhREdISWU2SUVRVFZJ?=
 =?utf-8?B?N0xQOUxmSEFvcGVUWDZpQzB6OXFkd2RObzhzbEp5bFJhR3hicm50TjZTVEsz?=
 =?utf-8?B?U0pzcm9PK0RFNzRLSUVwdGpOeW80Y2ZESE9mbkVHNDc0WHRUV25VUDJlcnFy?=
 =?utf-8?B?c20rTlNVajYvT0NHcmlyakN5QmtmaFpGNUdnZk9xV1gvUTVYVDRCMnNOcjk4?=
 =?utf-8?B?dEhSdlZpa3JDdDc5SUNTUW0yaFg4akJvWDFHeEhSa3BZSXdXKzNoQ1B3ODlR?=
 =?utf-8?B?UExWRGY0SW1haWJ2Y2VINGtTYmN3ZnJEYksweWhTOFYyZ3JFazU3MGdqN2xZ?=
 =?utf-8?B?TEY4bVVHV21wOHRUa3laZXVHek9lQ1RRWldaNkFoSXdhY2ZPdWxaSi8wdmFz?=
 =?utf-8?B?K0RpV3JhSUxHcjI2NVY4K1h6eVNjY24wZTl4bDJXTDdFcXgxdmV3cERQTEt3?=
 =?utf-8?B?R3EwVjVERUhIdGFCTmlob0l4M0pPWHorYTR1VlJZS0thZ05DbFZJWmpsQWx1?=
 =?utf-8?B?RXV3K2puUDkrUmxCM2ZveFFndzI1aVJZbFVaZmZuTmlGa0dyMTA0azFDUlFU?=
 =?utf-8?B?cEEyTVJ1ditwSWc4Y0xWeEZGN3VXMk0zd1h2eW9VbnFpbWFNd3N2TldnWUtU?=
 =?utf-8?B?NkxudTlxeUo4SlpyOXVOU2tScTRHa09BYXlhMDA5a0VJRUQvekZvRWUwYjRB?=
 =?utf-8?B?MWR4YS9DdXJyMitnRU4rQTh2dlJpS1lUZnBud3ZReWNJbDk3L2U3OExtZ1RO?=
 =?utf-8?B?cmpEN1BrOWtEaXhNOFk1cmp3QnhiTTc3SVFtSXVUeFUraEtxa2RyZjZ1c0xI?=
 =?utf-8?B?YWQxU202aHVDUERvUWxPQXBKRmFoa3ZHWEo0SUMvNFlCNktKVExjWG1wckZN?=
 =?utf-8?B?dkYzM3JrcTNwRmFQVG9aeHh0U0R2UjZwVVh4ZXRNYktCUjhSbmZpWit1R0lT?=
 =?utf-8?B?eU9icjNMd1lucnZJb2Q1V2dZU0ZpNUNUYjhTS3pwN0dhNnduN1J3Z1RrR1ZV?=
 =?utf-8?B?TkVZNWF5Z1lPZTJ1b3VoQ1Q0RFMzY2lNaVl4SEhCN0FCL0g4emZYd25jNG9F?=
 =?utf-8?B?N0tLUnovenNKM1hSamVTalNvbTNteUJvdG84cUptTjA5djZDY1BUZmIyc0pS?=
 =?utf-8?B?S1U0SGVZZWVETEsyVnl4ZXNySUtpYjlnY2xPRGhDWnd3WXFqbEZscFdnSHRG?=
 =?utf-8?B?eWZmU1EyeEUrc2VMVFBONk9yMEQ4MTFjSDF1SHBMNXVLS1pSRWRXM0JRejRD?=
 =?utf-8?B?eEwyRlpuT1Myb0t2eWhDbm95cnVVMFlobkdMMUxlbVlBejB2RmYwa3NoVG5L?=
 =?utf-8?B?VVIvczZhamI1UVVWeUo2N0hENnpaSmRwUDRHblVkSGFleEo0TFIzdUVDTVV6?=
 =?utf-8?B?ZE53UitNa3pBbXNJWUp5UmZMaVVqQmN0dWdsenlHU3AvaGF1V2xsZzNNN1BK?=
 =?utf-8?B?K2k0azB0SVlZVWU1K3Y5WW5lTEtGQ243ajdkUXE0bEdmSHFOYTdxK3EvdDFp?=
 =?utf-8?B?dXhIYlZ1QndibTE3dTdHTTIzV25RRkJmWjdaRUV5TnMrYUs4aWNsbnVQY01F?=
 =?utf-8?B?emVic1VPbWFZVHAvTmI2Y3Yyc3FUckVpTVVIdHF2dDFXbitOLzhvNlJ4dGxR?=
 =?utf-8?B?WmI4RnA1eDRCUitmYkhkaHkxbDRzNExUNGN3bGd4Zm5ESzlLeURDTUFQZDEx?=
 =?utf-8?B?azRVaW9JMGtKSjcyeE9sMUdZaVN0N0lDd0xrWUV5MGJ1b1hYOXh3MTFiTTdB?=
 =?utf-8?B?VlEyWWR1b08xYXBKaEJ6L2ZrUUREaWZ6N0pmMWRaUjllZjQrTVBzMTJmbDBq?=
 =?utf-8?B?aVhYY0JIeHBXZkxoRU5yNVFZOHBocWNXeGoySnZXQUprL1RId3cxV2g0WitQ?=
 =?utf-8?Q?pLxksp2c4spKbsn1k5MQLDf+b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c32f69e-352a-454b-e0bd-08dd03f96c17
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 15:39:55.3437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFemxS9qzuyg1TkfxmT2K0l7/fgAPo43fCQ4IfmT7FDT5yNYkLlq35Ghp5TPZwqUWGHcdX4Y4l1DzHC1JZPKFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051

On 11/12/24 17:22, Dionna Glaze wrote:
> Failure to allocate should not return -ENOTTY.
> Command failure has multiple possible error modes.
> 
> Fixes: 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")
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
> CC: stable@vger.kernel.org
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 357906375ec59..d0e0152aefb32 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2171,7 +2171,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	/* Allocate memory for context page */
>  	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>  	if (!context)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	data.address = __psp_pa(context);
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
> @@ -2179,7 +2179,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
>  			rc, argp->error);
>  		snp_free_firmware_page(context);
> -		return NULL;
> +		return ERR_PTR(rc);
>  	}
>  
>  	return context;
> @@ -2227,8 +2227,8 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		return -EINVAL;
>  
>  	sev->snp_context = snp_context_create(kvm, argp);

Since you can now get an error value set into sev->snp_context, a lot of
the NULL checks will be altered. You should create a local variable to
hold the returned value of snp_context_create() and only set
sev->snp_context if not an error.

Thanks,
Tom

> -	if (!sev->snp_context)
> -		return -ENOTTY;
> +	if (IS_ERR(sev->snp_context))
> +		return PTR_ERR(sev->snp_context);
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;

