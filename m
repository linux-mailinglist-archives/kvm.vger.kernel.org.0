Return-Path: <kvm+bounces-54110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFDAB1C687
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 15:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B53E3A5EBB
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 13:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AED228BAA5;
	Wed,  6 Aug 2025 13:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nhQmKigu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0246C23BCFD;
	Wed,  6 Aug 2025 13:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754485257; cv=fail; b=kqmBevtqEt6hmH4a5JMQ+CgiPaXtO3qpz9r6i9FKv4IqOYUNL/ieqO3y4aNdtcQNby+Wtw8o6wBji81mxIunGPZOd/QzTD3hy7rXCy7BmqPnwph7fNaipn2pIzOJ6wgyQXTioQOeFXXLKrusbyrHurDbAyEBdeGIWOrm8VrDL4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754485257; c=relaxed/simple;
	bh=x9QqP1r6oXoyCxGfBh45HvaYCcRl0ksmZYPc56x2c/Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sSEgCP/9Rh2WsaWGbWpPJ95WlXji3fFSSRHB9Pba0TNFtHRzzEtEK/0rn38nreTgqPgSEeHpr5hOb95ToNoHOvm3BURi/WHYIRy/w4ToAAEAd9TAU8OfGHJoItS1kDjHXLnGRRzeqT+jQkymmM0/7ZqP47BEb7QfAPOe4hwfQFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nhQmKigu; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcH7triKGExQNCbuDW2smN6Zhr5bFofdjgeGQgsPnyqIZ8pHoRk5xSQr2kYGTJmB1U1FqwcRmjZN11FNKz93zGWk9cA2iz1ssSJVJTi0UiWI0h596g6QD1hwnlGXHKnzvSiVYAuAoKbyoTkJ9JXbbEYVDUMEdQgKIgZbC8ZBsyHwVRpDHiq5TqWWpBWee6/lZULAWhqn6NcM+cfZk2WJctIhflekUDlFkSJmn35j94vj1IvMYs6N21b1UXMbkdO1NIWRX/PzNpY/1653pZJ1r6rD3MI645LsSpCKJTciq+1LPfqdk6dMhPILPMVGRX+/6bvdKypAq5mrPC2hiwgnhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0OS36Smzjnok8mtn2JMWKUn1/Jtae4jzq0n48aZJaY=;
 b=jyKWmAPDoY79biv9mSRYwXmrcYkBIPTHc6Rg5rpWNj+wcizB7RYpZaR+K2F34ZvJzY+gxULJR0Mkc2/Ef/GLHaFelVqETqHDaifdiBoxmfmpKqiHwEPAAdum6rwtPAEJXyeG1mvgYvRX6ZB3SrgRkpsRF21+e3nMzFxkJ09TbrvWJV8ARAQxFq//NM2/3ScU7QgoSdvcdofNSMFqJIS144K3skC5RQOrH8gAJuuuj5vYdygOHk9XGORObT/h0k71CBPsT+Wf2MjW0WOW8KrZ1fSiJRMvr56uQYNMoHDkfCcC/HwfuLx4Mf3gLKbIVEqnM7x8ScBdFgIcG55KTMlCTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0OS36Smzjnok8mtn2JMWKUn1/Jtae4jzq0n48aZJaY=;
 b=nhQmKiguwr/yht00mr3q2t+yCPqpDTzfkbV4Xw7uKgC2Vd0WCcmxN39uQILuzt5LtdE+kAj2onaWbQoD4YXFIPvV2jRkT5Ru264gOeO+JW/nT5toSnvuSaZQmGxsvqyzXeHiBwF2eZ9YwMwUeSpZ33Js+LygDB9ZjUkkT3EfDEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7443.namprd12.prod.outlook.com (2603:10b6:806:2b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 6 Aug
 2025 13:00:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8964.025; Wed, 6 Aug 2025
 13:00:53 +0000
Message-ID: <4d761b2d-cdce-1aa7-d138-59dee82e730c@amd.com>
Date: Wed, 6 Aug 2025 08:00:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
To: "Huang, Kai" <kai.huang@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "Hansen, Dave"
 <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "hpa@zytor.com" <hpa@zytor.com>
Cc: "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
 "kas@kernel.org" <kas@kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "sagis@google.com" <sagis@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>
References: <cover.1753679792.git.kai.huang@intel.com>
 <48b3b8dc2ece4095d29f21a439664c0302f3c979.1753679792.git.kai.huang@intel.com>
 <d3c5417d5aaf0b02fb67d834f457f21529296615.camel@intel.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <d3c5417d5aaf0b02fb67d834f457f21529296615.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0162.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7443:EE_
X-MS-Office365-Filtering-Correlation-Id: f7001258-5e7a-46b0-fc92-08ddd4e94632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzlLUnZpS1NOU1lWTXdqZFFhODZMQzYzQTJUdi94ZldUNGY0MUVuYmdkbHBi?=
 =?utf-8?B?cHJ5d3I1S05mV25QbXhWNXpTWlh3S2phMjVoMDArOXErZStwUHNoVzFMV0tQ?=
 =?utf-8?B?OFArNDNQWlVsTkdsN0ZnNDI0VW82OTB5Y2JvdFlNOFZRbEovUVdtZ0drMEZu?=
 =?utf-8?B?SWR2OUtvMDZDTUt2V3VpWENGMXRPNEFzTWJ1ZEF1SGQ1L2Y0bkM3STNUYXla?=
 =?utf-8?B?Z2VPbUtjcUxQU3FpUzkwem5TaEpSNUJPbnVZVFFRS0VsazhTdjVQWmtOZmkv?=
 =?utf-8?B?UWZhb1RMZGdSaWQxcXJEYXNuMk9BSUN2bHlTZDZnSGl0UEEyYlU5YzFZT1Rz?=
 =?utf-8?B?Vm1NZmhiRTFNM2VnSXExNk43dWk5MUhZMG5zQVg2ZGJzdXVqT2FKVmE1UzFn?=
 =?utf-8?B?WU9oSEVna0I5L0k5MXRaNUp0cmNJZVEzVFBQRjJkeGROUGZzeHdvQS9TR3pv?=
 =?utf-8?B?SkhEOXo0Yk5ZcFJ6bElQME1GMEtwTUQ5U2w3eGw2TmdGQUxoSmdwK1RLcXhY?=
 =?utf-8?B?QWhyc3pTY3E2clZ6ZzBDdDlqbENNK0pLTnBTOWdEb21wSVZJZEpRcEo5R3kv?=
 =?utf-8?B?cXlpRnlBTWl0cnh4OUszczdwQmpmVUJmeTVGL2hidFROMlZwRHJ5NjlWWnVw?=
 =?utf-8?B?ZzZ2OEJRelNYczZMU2RpWVBSTUZzbWZJTFJDQmk0YjFWRUdpQUc0dzVQNjRq?=
 =?utf-8?B?bFAvdHllWXlVZG8rYS9QN0t5NFBDbFRJcENORUV2aUZNL0hBc2RyeU1ZSXRI?=
 =?utf-8?B?azBPNTBicDNoYU1QZFBxVUxMMHRNZzEydGlsTVVvR1R6ajVCY0tROUJ6NUpQ?=
 =?utf-8?B?dkJxUFU4TC9NbFBhWXpwZHZXRVFCUnhnOHA3M0l5clFLUGo3c1pWYVQ4dlZx?=
 =?utf-8?B?eGw1R3FMbTk1RlQwZXUxemVJQnF3elBEVXo0bzNzcTR0MmcxUzE0QTVROC9P?=
 =?utf-8?B?RFQvdHAyUWRINngrQkZDenl4Z1p6WnhuczdRNTVud2lXRFJIbklpZkQ1aTNm?=
 =?utf-8?B?UDZCdkVLSUEvdEN4eDNFSHNiWjEzc21ObzlYb1NPVExiUHEzMWFYcTJVTVAw?=
 =?utf-8?B?amFHRHN6RmJjcHJMWmtXbWVBMkl2anFJT2VwSUJYOGdPNnhHTVZnc0EyVVNB?=
 =?utf-8?B?TE4rQlBEekU4YkV1YnlxNVpad2UrV2U3TkVOM2xEVTZacmswTmFMRHc1Yi9B?=
 =?utf-8?B?dUZ4SVI5d2hzUHkxUDNoc3ZyMXZhSlhseGxLMXExc0pBYUJTYjMxa1dJOWpH?=
 =?utf-8?B?MHVTR3lGY21LNFhCTGpWZUlkL0grZkIyNzE3dGVCTUt0bThEdHRpOGpEZkFi?=
 =?utf-8?B?UTc2SGlIRDhYV284UjA2bWFtTDliMldIeDVGVzBNMG15bU5lSm1HVjU1MytB?=
 =?utf-8?B?UG9SaE01bCtxZy9vYldESDdIRlluRXVZS1oxME91ckt3ekk4RWlqbmFieGJD?=
 =?utf-8?B?U0JwYy9NQlE2VmNiek1uenUzbnNCU1lEZVUyMnY4WXlDa1dJSzZBRmo2bG9B?=
 =?utf-8?B?WTVpV1VodUtVOS9WeXErTGRhaVRuSGpETk5CbFArbHdCY2tSNzNnNjMzSDNZ?=
 =?utf-8?B?OEFDcER6RnNoT2l6WDMyUTNqcFZQWm1GSjNDaGhNajhLclY5UnlKSTJOM3Y5?=
 =?utf-8?B?ZFN6WTJIMno0Vlp0VndFR0x3MkxDcnlhbmJwMEErOFpMUitFbjRFMWx2NnpF?=
 =?utf-8?B?SHpDYjMzdGs0UnRka0hucHNUSmhNclBrU2E1c3pZNXdYZHNQWFBMZjY2dXIv?=
 =?utf-8?B?b2srYk1pWk9XWDJNY1lhQkU5WkdlTW1BLytManlvd29VMTdjMno3UUU1N2lz?=
 =?utf-8?B?c2F5NkJBTGZrdm1ySWNCYXVHZnN6V1U1MlJ6a1U3WW94anY5dkc4TUZ1Misy?=
 =?utf-8?B?VkZpeDFWeVFVSXlYYXEwdDEyTW91dXRIZUtLKzlhdFRnd3ExT2NDeDMxcDJo?=
 =?utf-8?Q?jn6x0DzbdFE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUtPRWFnYy9wVFFhSzNtQStzU2tyQktoc2JKa2FNQWREVTI5NjNibm9ySjNr?=
 =?utf-8?B?ZE13MHVPVUF4ZU5mUVZEZUN4Yld1Rm9jUmllRnk1c3BxNTd5Z2dGN0owakVh?=
 =?utf-8?B?NVM4VFE0M1ExN0x6UjhJTnZCaWxlUU1nOFNwSS9iTEdUb2s2cnhYSWxodmM5?=
 =?utf-8?B?ODNhYkszR1RpaWhKeFNvQkVxRlM2Nml3V1FUc0Z0M0RQMHEvZWhsMmcyMWZC?=
 =?utf-8?B?Tno3KzdUZnR6NVZkRmQwSUo3bHZOWnlBenR3MVg1WEFCMVR2bDJaYWFkbzRY?=
 =?utf-8?B?QVlGaTU5bjZGL3dTZFo5M1IzZTRSUkNpbnhmbDJ5cFBVZWcvakx0ZFhTNVlh?=
 =?utf-8?B?WnJYQm9mbHVHWlFQczcwZmhZYkcvbktFRTlrbmJkR2JJN2phT1krckNnZm9I?=
 =?utf-8?B?d0JFZCtBcEJxdG54VXhETmdzSU9KVDhQSE1idnZGMEV2bDE1OTVLWG9CMTlI?=
 =?utf-8?B?U1FxN2U0MXdmOXFTclhrMzdDOUdmMjRUVGlHdWhuU2JjQVo1cGljZTl2T1hH?=
 =?utf-8?B?dkdUbkQzTm5saHBvV3czNmg0ZHBwQTVWaVVJNFNSYlN2MU5lTTFFK1hhQnVq?=
 =?utf-8?B?S3RZVS9YVUV6N0dPRk1hTEh6SmhDWTFDb3RkUi8wMmk2aVRFL1hDRnpvb0Ey?=
 =?utf-8?B?WGV4d1pBYlVicVVkTjJRbmN4TVE2T2x3OXFoQzBZQ1BOalFHcTVaVVJ1amhu?=
 =?utf-8?B?TFQ2bmtlcHk2OGRKaUU0VTBKL3ZRZXdCaEdJTXNnN1JhMVVCUE5MUkFaK3hp?=
 =?utf-8?B?RnZKYmVCa2NVVUtyMDJ1MFVVQVlSQ0Y2TE1Nemx1SFJxZk9JdjBxcjdhV1Bl?=
 =?utf-8?B?K0hiaXFTSVlmM0dKWm10VGpNeG5GVFlqSkRyQ3ZFN25oeFlRNVBxM3lMdkNW?=
 =?utf-8?B?STVuNTc4SXZXNHJiU2I0RlJxRExJWG13dmtTaWl4alBJVVZLM3FKWHFLVFV0?=
 =?utf-8?B?V3orYjdrNnlLOEJvcWQvSkZhSmFkclNMdlpCVWNzM1JnRzd6TTFKQ29WSUFB?=
 =?utf-8?B?a3pESEE5VGZqRk1YNC9DZHRHREZmNzJ6d2RHS3IxMXNqRHQ2ZE1acXhQeU1B?=
 =?utf-8?B?T1diQmNYYWk2dDgyNjVnWStDNWNnc1BhSGl0M2VxSisva01kMDFwNTZUZjJC?=
 =?utf-8?B?cm8vNlNXUzRISm8zMnl3eHFWK3d4RVg4TldabGJMU3Y4cFBOdy85cjRwWkI0?=
 =?utf-8?B?elV0SWRLdFhKa2ZGVzhaLzZlUktXSyszeFNBdWR2WW1SdjNSNzFZUWF2RjJI?=
 =?utf-8?B?Q3F3YzRpbjZWRFZDNGZZd3h6aUxvRUtnNm55TXluNDBDSWRjRGxXZFgxVy9v?=
 =?utf-8?B?MStJT3dHUDI3c2djN1ZwS1M0WGcrN2pHL1dGM3ZGLzFiNW1xemdwVGNpTlVC?=
 =?utf-8?B?R2d2aFNwRS9HcUlKSHFhQUVsQ3dBdmxmYkRWZkoycktJcFkzUXdwaElBSGhH?=
 =?utf-8?B?THRYMXpmYlJOVkkwQUhpVTdmV29wMHc5STNjRDlmUXMzR2JWNTdlQWJHaHc1?=
 =?utf-8?B?emJZYjRHZU16OWR4cTRldVRtVk5CRGNwQnV6N3QvTFFSSEtjVXhpelB5T0R4?=
 =?utf-8?B?OUkzQ3VyTkczSHd0ajBuZU9UQmdVR3UzaXJtTFFYYmVRZnBsdzJUOVBDUC9S?=
 =?utf-8?B?TTlPdXVQOHdBZUJiQkJmelFtb2NSMzFYdFUvTHJBMzZDUHU0TnU3aWVUdXFj?=
 =?utf-8?B?WnVMSXRveUp4UWJNQnlaWDNhNjJKSjFOYzJibjV5RDFkQjFKSE43NDBjQ3hI?=
 =?utf-8?B?WVNiUXlYaTE1amVmN2F3V1VodVJXZWJMS3lHRVdBZlQyNVBqRW43SEk2bHA2?=
 =?utf-8?B?NjFwVk5IUWtJOWRsWnBCNHozWlJRVXJSZVlxcnUyaWIrSUYrTkMyK21sQ3Rx?=
 =?utf-8?B?ZUpHQTBaYnRGR1VpTlRVOTU5ZEdDczU0Y2F1VzVRMjg2dVdpamVoOHNSQzV0?=
 =?utf-8?B?Rmg5ZWFPUUI2T2tNM3VLa3BLTXZYTG80QnRtYmZTZlZFcWtkcUtJeU5BNlhD?=
 =?utf-8?B?d2xwTXcwbUFpRmRMZE0xalplcjN3UzkrMnp4S2lWblZ6S1Q1K2UwRmtrbnFa?=
 =?utf-8?B?cjdXTVJkdm1HcHRMUGxkVDZKclpvMS8yeXBRQWZhOHFZUzZMdVBBdzhxL1hP?=
 =?utf-8?Q?d66ZYKt8m00fum5EOSCaMCUz2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7001258-5e7a-46b0-fc92-08ddd4e94632
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 13:00:52.9342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lE8Ri1UoaGFwlc5iUAM1WK9WvJ6QNSTpvmR9+naVuccu8r/fbDy3Bh/TfcZ7PYQiOplicwaL4USEUE7r1mT5IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7443

On 8/6/25 01:53, Huang, Kai wrote:
> On Tue, 2025-07-29 at 00:28 +1200, Kai Huang wrote:
>> During kexec, the kernel jumps to the new kernel in relocate_kernel(),
>> which is implemented in assembly and both 32-bit and 64-bit have their
>> own version.
>>
>> Currently, for both 32-bit and 64-bit, the last two parameters of the
>> relocate_kernel() are both 'unsigned int' but actually they only convey
>> a boolean, i.e., one bit information.  The 'unsigned int' has enough
>> space to carry two bits information therefore there's no need to pass
>> the two booleans in two separate 'unsigned int'.
>>
>> Consolidate the last two function parameters of relocate_kernel() into a
>> single 'unsigned int' and pass flags instead.
>>
>> Only consolidate the 64-bit version albeit the similar optimization can
>> be done for the 32-bit version too.  Don't bother changing the 32-bit
>> version while it is working (since assembly code change is required).
>>
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>> ---
>>
>>  v4 -> v5:
>>   - RELOC_KERNEL_HOST_MEM_ACTIVE -> RELOC_KERNEL_HOST_MEM_ENC_ACTIVE
>>     (Tom)
>>   - Add a comment to explain only RELOC_KERNEL_PRESERVE_CONTEXT is
>>     restored after jumping back from peer kernel for preserved_context
>>     kexec (pointed out by Tom).
>>   - Use testb instead of testq when comparing the flag with R11 to save
>>     3 bytes (Hpa).
>>
>>
> 
> Hi Tom,
> 
> Wondering do you have more comments?  Thanks.

Sorry for the delay, LGTM.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>


