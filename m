Return-Path: <kvm+bounces-58554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 739EEB9687C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 240CE18A667F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79EDD1F92E;
	Tue, 23 Sep 2025 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wXyxmZzU"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010063.outbound.protection.outlook.com [52.101.193.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35BE61FFE;
	Tue, 23 Sep 2025 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758640526; cv=fail; b=pnuLhI18D28suUqTB19GypKhB0axi3VYaTyzw5UHVJKeOPd13IN6Q84avoFV97p/oMCGMR3XaKTcmI4Codlktw0MChVp6YZTV6yllC0TfTjmheuv6YoMJLAdWXmF3TonjoufGy4hE7eufvIPAiAhY1rUJrtXAFbt5ixvVGhNnP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758640526; c=relaxed/simple;
	bh=4iFOsiePWZZrVkfDvF8JnkZCQ0yd9MzPXtdzlbv33m8=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=Hb4hV8hDsiFMd+x+PolDSBdnBzVI8fGxfligY56ehksYSzyxnyyV+8eQ8pm8M3ApTpOl2t8E1D6OUywVOmjMUflsyEnknh2GCR+xItafB3LDpvS/okoPsWPVwnrPksXaM3oAtIGzi96scHuKm7PFnC1G+mag8GiroGsULSk78TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wXyxmZzU; arc=fail smtp.client-ip=52.101.193.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KthCBpvcOQOn1olblEl5uZooixt+b3OkhwnQ5snYKHtTNs1mfGQMkmsCRgQ8A9zwjiO44TOi5xiyR8Zr305FkFIo48p4/UX6/340AC6p/WXVAQjowoGl7BfHWxXGzx/wR7EbjHzTo7cavSFPZGZRaj989pc0LiUaKlhxi0Dt2RjmaOxEt4enZkpfhKXlnzroW4X2Q/FdNgC4OnqmPZ1PZs8D9t5ZgiRjXPoPkUga4HzBuxpu6BP+HoKkbuXWcNlNwH+iFcok22yzPFBDeiuPZPQxfK2E1yb3D7a+UDifmqKQdLNtBTLxSRZ3Z0Y0G/fn90NgXpfci9Gq+3JJWdHS6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmeYnsnHB7nCeLsnTWkHdI65EZJfB5pZGt/R1LCsRT4=;
 b=wGOk01H+SFcX8bBf7Rj3gRGLaCD7Hr9bsdUyVBWYeUoF7/GEMBiv+VViUWu3qnMsx9bc2Vk68Q+OQFcEu7ker4g3Wy5L4wbhIej7ZFBM9jtyHbkG0iTa+gE4+puSSAx2FU78UdTfo8GJ9TVAYcB6zFOhYkRT1EA/ZBSEYymHP7/uGnQ9KlnuItVaashn+WWO0uilA8VKho6NLzUoxNjPnxdsp2pl/xPyiNbiicAXwipwXITjrymVOhJg/qqzMTHl+OGzs65V9CNbjkM/Beqp1q25ZyiCpe9cw+IMHQikEge3H18oCgcjIV6h9glhHX2dHjkF2veBq+xAnnKnUkOYvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmeYnsnHB7nCeLsnTWkHdI65EZJfB5pZGt/R1LCsRT4=;
 b=wXyxmZzUVe6TrN1GWruvaRQGl4HETxSNDgfc2Od8VHNp0+skqD2+g7q+DS3ZR/2aTykxXo9NkNpLsURhpPq0kMZxtfI9hd2s7IWmWyD475Hi6BiOv7GnvGDiRrskt/DaSNNkPSetUCyZUPbCvojVrpkdLlvWikFl4stUXvVEbIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 15:15:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:15:21 +0000
Message-ID: <4560e6db-2346-49cf-0410-ebf1804728af@amd.com>
Date: Tue, 23 Sep 2025 10:15:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-10-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 09/17] KVM: SVM: Do not intercept exceptions for
 Secure AVIC guests
In-Reply-To: <20250923050317.205482-10-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0310.namprd03.prod.outlook.com (2603:10b6:8:2b::9)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e1540c-f0a8-41c9-ccb3-08ddfab40365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkhoTlByeW5TOVdOcmNmUi81bHg5U0d2ZkM5aEsxc0NYcnRDcFdQVzY1bWNi?=
 =?utf-8?B?eVYxaDYxdk52UmRDeU80d1JlWXIvRDd3amF6Um1RcFp0TmNsTVRENzNZVlJy?=
 =?utf-8?B?c3lSbjhGR2x4c0lkWkJROGNobVRNLzZGeERCRTFya0s2ck1vQVlReWJYcW8z?=
 =?utf-8?B?cEtpR21WS0QzS2IySlQyTU1JZGR1OEJNUCtjR3hEM0F0Q2NqTVdUbmJJOHNk?=
 =?utf-8?B?OXFJWnBsTmRVNGpXWExidHdQOFlkWXZSS0xrc1J3VmMxMHhKVzBoQnJBZklI?=
 =?utf-8?B?dFpDWHMrdHkyWjRKMWp6ZDRlMkRxV1pQcmtUbmNVWXhCTWIyRnV4Tkl1OExS?=
 =?utf-8?B?ekxlMmFaajZFRzVHQmtNV005TlNGNGdHWWtLUitUVlhGczR5Y2dsSnMyYXRs?=
 =?utf-8?B?SSs4TWx6VWZPUytvQUN3UnM2RFRydFJzNk1zcVhJT3JYWnRxNjNXQjJWdlhP?=
 =?utf-8?B?eWZLdDMyeFhaY3hscDlSelp3dGQ3em1kbEFqUjhIWDJkejJVa2Yvc1JsTEhD?=
 =?utf-8?B?ODNEeG4zc243TG5YQWR0N3NVRGFCVjdpOThXU1djVklOcitqVlBmRFI2bEhF?=
 =?utf-8?B?NWxWSXZuSUUwemV6L29QZ0h1T2xmUUIwZWZwWkFVRDVJV2FZVHJoTHl3QmJt?=
 =?utf-8?B?bTVPK3dLNkJxVTRYUlB5cHVzRUFPOWt2MEMyMklIQ21FUHEyS1REM0laeTlz?=
 =?utf-8?B?Qkg2U2JuL2NXN1dSWE5PNUtJdmZrOVdqSm9ObmM2OThNb3hGNFJjTHhMelE2?=
 =?utf-8?B?aWJzeEJ3TUpsVVU1STdkK0I1U1Nab09xL0gxOUpseWNxaTlsKzE4cGFSbFRZ?=
 =?utf-8?B?eXdId0dIdG9KeVlaZll0elByQmZNemIrV2FxN1l6bmlmM3BJVEQ4TElKc2s3?=
 =?utf-8?B?QTlOenBqMWtHUGk2Ny9iOEhzeXRhNXFkekRrVFp1bkhjaXpkZy9rem9Zb0Ri?=
 =?utf-8?B?WTdYYnhHbEhHYkIySmtGV0M3VkxPM0FzdVJFL0lMQzI3ZnJIRlJvU0xTRWpw?=
 =?utf-8?B?MC80KzgzN2EzRXI3RExHa1hoWEU3aGFRajdHNVZyZ1pScWdiQmovays3N0dw?=
 =?utf-8?B?YjNHL3hZbTVGWTZzUk4veXpMeWtTVHJ5N3dBSXhWZFpJWVM5ZUZySXZ4OFZq?=
 =?utf-8?B?UjJia3BkT2JyN2x4dnI1RFFndGliUHNlamhoSHRHdkM5dFBobE05LzlVbXpG?=
 =?utf-8?B?MlFNd0x0VHJrZDJtdmZhWTlVRXlRZ2tKaEJUSktUeDZjVHFVVFh6SVo4L2Z1?=
 =?utf-8?B?QnZQSDhOT3gvQ3NaZEFPNGNRZThWb1RPMlVmMVVvdCtwYzFqR3BuTXhSRmRZ?=
 =?utf-8?B?TTR2L3A0U25pRGwyME9pcnhVeHBFTzh0OUV0anVBanVHcHhNRWxOOUR4Vklv?=
 =?utf-8?B?MVRCcVlnZGFvczI0cGt0VG9GamwzRU1pODl5Q2pRbFBHanNGSjJTMmt1Nm5M?=
 =?utf-8?B?VDhKaGxUZXdwbUcydE1xYVgrQlNNQ3BjQ2dIZEltaTd6TW4yUXlSb1ZSWXNQ?=
 =?utf-8?B?MXMxSHZVSG9HTXdlNThKWlorQTI5MW1oM3UvZW5aNkdPbmdmRUFkNXpGak5s?=
 =?utf-8?B?UTNCYjlTM1dyMG5UMy9sakJoeXR3bWIwbHgzYmRYM2NJdUNkSlkyeDduZldl?=
 =?utf-8?B?OTRiSzBVRU1RVHhkYWhSNm5nZnVvNWxyckFzQlhiMWNGZng5N1FudE1jMVdp?=
 =?utf-8?B?NzF5cU5ZQThJMTRkVWxNR1psZnJ4Z1dOcUE4My9tWmk5Z1JGOFZGNWdhL0dq?=
 =?utf-8?B?MUlwck5TYW52R0Zvdy9rUzFzK1laRFlFc2srTFk3aUZTblc5eE1KZVhWQWc0?=
 =?utf-8?B?SVplOFZzd2Q3UERnWG5NTzUrL2JnNmNNZVdDTTJiZE1ZTXhDcGFIazZsY1Av?=
 =?utf-8?B?b3dkSDFITGpoaWhOcnY4K21Zd0U4bU1rTGNWN1Z4VFBOaEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWNBOHpTWjRQQkRVTzcyay9ORHR2bG9Mc25pVUxuTkJOZGhNUnBGYjBYQTJz?=
 =?utf-8?B?dTdEWGo0NVdsK2FSSjlnc1pWQnpOelVLTXZ1Q0lsRTlMKzFYZEtMdDc2aG1L?=
 =?utf-8?B?dy81NC9hdzlPQW8rNGQ0b0VzLzI1c29JUEMvN3pGUFA5RFA2cTdaV1hxdkho?=
 =?utf-8?B?UWw3UGxDNXplV2RvY0lqcEZQT3BDc2pFell0YnBhTmlRNTFxdDFONm5Xa0Rh?=
 =?utf-8?B?SnQ0ZkpuNU5hQVZyU3psczk0akplVFY4azFodEJVUnk5ZmRTNUo3V2VIMUN4?=
 =?utf-8?B?VjVmQW5GM2VQbnUyRTlTTmE3Y3JhSytCOHF6VEdXb0RVbUVObGlqS2JQOEpT?=
 =?utf-8?B?ZmdvMDRVTTJvUnR6eFg4L1hCbVpUR3VzUVNNUGVsVmlzSGsvVCtUb3M4NCti?=
 =?utf-8?B?TnQ0RUZsY0QxUlRFOXkySnU1NStrMXp3SVNvM0xKV01ldTlJaUxoR3ArNHRj?=
 =?utf-8?B?OEMveGFuTndZdWt1cU9PZXI2U0tEM1pvajJ3MExva2I4K2w2bzBWSlNwYldG?=
 =?utf-8?B?TGlJZFRJRVFZSTRkM21VaXNQSHdxSDFyUXMrSFZvamNZN2U0YnBGSWtyZkt6?=
 =?utf-8?B?OFozYnJScGpXem5tQzAvYUhRQmIyMWE5MmQxK2pLa1FKK0Q3WGJlN1NCREt6?=
 =?utf-8?B?aEpYaHFtU3U1dG01ZE9XeVl0R04wbG1RRUFMdGJkWDdJbVNqMTlRcUNxYWQ0?=
 =?utf-8?B?a1ZRN21XVnVsMlA5OFlpak1RdUpIbEkvVlZuYno1V0dBRmkxdTh6WGdma2kw?=
 =?utf-8?B?V1RiOUI3RllyYnI2alhKaUcyRGVDV0NWSm8rcUdOM0xXQVpSZmJNMnUwWE1Y?=
 =?utf-8?B?eUxTTi9mNmdQZnlwdlRTLzJrRTdoaExMdnkxemhjSmRIeDlTc3JkYUZ4TElk?=
 =?utf-8?B?WFdRTjhTVHFSTmFnM3FGY1hJWmVwNW5xVE9ibXZ6MzhuVGdOTkN5amhha3ZM?=
 =?utf-8?B?UnZPT1FmY2MwWCs1UEo0bFA0ZEl3bVF0RHZLekRXdFJUN2FJVUVoaFBKcmFY?=
 =?utf-8?B?MXdRNkxCSE5Idm5TNHF4UE1jWHVkbmlBNTJQRmNXYnFQZm5kenNaa2pKM3N0?=
 =?utf-8?B?azhOam0yU3k1K1JJdnhydFhaZlB2OXY0WStKcVplN2NHQ0pSMXNHSExmMEZu?=
 =?utf-8?B?eVF5NVNDTDkyVFZOSjNDalV2VFlFeDQyNDRPUVA0VDNHMW9nY0xtZlo3djd4?=
 =?utf-8?B?eGpZNnB3Wk93Qi9zSk1rRmJaYnZ1OUhkbW4vSGxjbFBzV1lXNHVtSVg4Ymwy?=
 =?utf-8?B?bmJvQmdGQ3kvdHc1SGdvMFVMQ0s4d294VGpXYWhsSGd3SzViUXJWclB1LzZo?=
 =?utf-8?B?YXlINlpDSTVHczVPaG5pVjE5cXBCdTA0YUd2SHo5UHNmMXdOdmZTU1hRbzQx?=
 =?utf-8?B?ejJWRDFBN0JicHd4U1o4MFllL1EvanR5SStQaHkyQ1RLb2JrZW0vWnBGZ1gy?=
 =?utf-8?B?NFhQMGtlU216V00xTUl3SE1ITkh0TmVyeERQOVM5a2JZZ043ckI2RUxoTWI1?=
 =?utf-8?B?ZzJQeUNzS01mVkNnV3Bsek9QWit1Z2QxRVdYdFNtL0NQWDVJeUxyeDVvOGU5?=
 =?utf-8?B?akFlTXBNbDdlQ0Ywc3pXSFlkUkEzNHRETFM5NmVYd3lPWDZpTERRZVNuM0k0?=
 =?utf-8?B?VHVlOG80Y2RvT3J4amduaG5tTnpFYTRWcUx5VDcwSUJTa2tLY2YzdE9lNHZh?=
 =?utf-8?B?enU3Tys2L0swWWEzTHV5SFBDZ2cxU3U3ZnhqZlE1M3llR2d5SHdKdWNjd2Uw?=
 =?utf-8?B?V04zTnVZclVuOEprc1ZxcW93a05LNTRvbUZNTi9YQ0JGZjFWSDJoa0xZL3Bq?=
 =?utf-8?B?TXdVZThhUlArcmRuTTREaFl6WGJ6QktSMlgrV2V0c1RvRjVkZ3ZiSk5kYXhV?=
 =?utf-8?B?T1BsaFYzOUZJU3RnTjRYZHZjTWhPZWNJSXpaNEx1Z25WRUVKYjRtdHQ1R3NX?=
 =?utf-8?B?Und6SStaeEVVKzRLa3F4RnE5bThGb0VxQWFoZllvK0dUb3l0Rm5IVDVVWVgv?=
 =?utf-8?B?Sjgyd3NtYSs2cHFHcXlIYVhudXI5Ujd3YVk5MXVoNzN5dEJmZkdlYVRIMDFu?=
 =?utf-8?B?S0hTT2psVHdtVEpNOXVkZUZyTk9JK3BGaEtRQnNaNGNJNE9tbU1ySllzeC9P?=
 =?utf-8?Q?g9XUlAIx/WM4WKjzUT0LWcQPL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e1540c-f0a8-41c9-ccb3-08ddfab40365
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:15:21.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4e+4xqNR3T4qYEZtMd4QUYwaMxjfd+LlU8f3EJY8/qd6RHfAm2hkHjAa9riXlDv+U5EBQ52ZIRCz1BybtZ3OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> Exceptions cannot be explicitly injected from the hypervisor to
> Secure AVIC enabled guests. So, KVM cannot inject exceptions into
> a Secure AVIC guest. If KVM were to intercept an exception (e.g., #PF
> or #GP), it would be unable to deliver it back to the guest, effectively
> dropping the event and leading to guest misbehavior or hangs. So,
> clear exception intercepts so that all exceptions are handled directly by
> the guest without KVM intervention.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a64fcc7637c7..837ab55a3330 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4761,8 +4761,17 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
>  
> -	if (sev_savic_active(vcpu->kvm))
> +	if (sev_savic_active(vcpu->kvm)) {
>  		svm_set_intercept_for_msr(vcpu, MSR_AMD64_SAVIC_CONTROL, MSR_TYPE_RW, false);
> +
> +		/* Clear all exception intercepts. */
> +		clr_exception_intercept(svm, PF_VECTOR);
> +		clr_exception_intercept(svm, UD_VECTOR);
> +		clr_exception_intercept(svm, MC_VECTOR);
> +		clr_exception_intercept(svm, AC_VECTOR);
> +		clr_exception_intercept(svm, DB_VECTOR);
> +		clr_exception_intercept(svm, GP_VECTOR);

Some of these are cleared no matter what prior to here. For example,
PF_VECTOR is cleared if npt_enabled is true (which is required for SEV),
UD_VECTOR and GP_VECTOR are cleared in sev_init_vmcb().

For the MC_VECTOR interception, the SVM code just ignores it today by
returning 1 immediately, so clearing the interception looks like a NOP,
but I might be missing something.

Thanks,
Tom

> +	}
>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm)

