Return-Path: <kvm+bounces-70836-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJ23DKtgjGmWlwAAu9opvQ
	(envelope-from <kvm+bounces-70836-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 11:57:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9B6123AC4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 11:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0FF3C3006455
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D38F36AB75;
	Wed, 11 Feb 2026 10:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="A/ujT+Hl"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012006.outbound.protection.outlook.com [52.101.48.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499A5367F39;
	Wed, 11 Feb 2026 10:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770807458; cv=fail; b=rUhRIc92wU8hIdMYd2bqz5BUUakx0q7Zw/3lXVLaUihTP7Ss8FtfVyoXuriwroo9nRiNbiQIRJ4T0jGmVYRLlLzXqWw5KcbQHCMsXkB4CK4+p40u+T5C48zk9Pz4kbKMf/YBUZSe7LP5o3mR4p64xDVSmebpNc6lTpyuxeITlhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770807458; c=relaxed/simple;
	bh=zSDI+6QuWxgWnPnqNX2Pxn4H6Z4dLaFw5Fqt0rBmCcE=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uxmxGhPgx5WnQz9trg7I7GW9Ma8N8YLrr92cJrA5PJrtj4/cAK/wVMQVKTFBX4Hjymfp1UlSyn/Ry8m1EG88g8WhYSgHp8++7EPwJvTnPHf/PisEB7dTwE+M/5dvsco0vi26s9wlzVO0TedjA6/qCqLdTQ7f6b67lkXOgcOTgxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=A/ujT+Hl; arc=fail smtp.client-ip=52.101.48.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r3DTsphY5VO+hk8Y9gR+R53Ep0h6Tg2buQCDHfelj8V6dEh6hYj0YboiF0WjR47ts5UucRfToxE5o0+UhqInUsbAyfTCiINNqa1ZcSSuB17+zamEOoWeRbrIeI1qhFHiQtPKzByQIBtOTvCVe/Bz5xJCqxkNyFD7WY85EYGnmY6sBfVQlc3PIu9+nido9Qv4L/p/cqVAfvlYGnGXgvQlOqip6nqLnBLH2oCKUP+DA95rEaclYixTJgBLCBSSwCOOXlyjgwBzlOTVmMhFgKe+IlMqjhqr+um9JA/9lIprXoBD5+PGXgBhjsNMROgp/40UDPzielv02Ac+FUuxmWCchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSDI+6QuWxgWnPnqNX2Pxn4H6Z4dLaFw5Fqt0rBmCcE=;
 b=QQIJdcdIQi2EfCIdRH+s3YdmRD0hHGNm74qZF8X81Dc60RxkDmN8zR/tjYhJtO3dzKmijshRGGfO99ccglaxlNKzuiVaumrRzuYGZU/+dDIVeICG2Y9mrbcGsUhMtdIjMJsacbdOFhDDEW3rRN9LZIZHM7xIvk+qGVTr5iYj7fJjvNdlsGtT/EjaPHwMzbrZJsv590yTp/vjROPov0J3TbowgTNPzCy6RdzwYbLq3JiGH+Mt3BsxF4vdYAjJs50r252XBsY+0qt3hsi4uCR6HPjVoEOUf+MmFRNXUvlK6r4S92PcBlZ2SZb+WRErGhmBKaSy6przV3QU0Ikjf0IXtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSDI+6QuWxgWnPnqNX2Pxn4H6Z4dLaFw5Fqt0rBmCcE=;
 b=A/ujT+HloVOcHgRd3uMphmgemptmpX+hc6NzVkjT8aanziInxCKGCubbDbZB1Lh88VNDAlZFsBeu0Rmrlo2TzBBG9Z6H+TzQhzh+eN+iWkp7TUrXyC54Cv8m29uYDstY7JjEYQH3OvXAgSvhmJaT4SfHIA7aUjgvi+fNSW5IcNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS7PR03MB8095.namprd03.prod.outlook.com (2603:10b6:8:250::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 10:57:35 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 10:57:35 +0000
Message-ID: <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
Date: Wed, 11 Feb 2026 10:57:31 +0000
User-Agent: Mozilla Thunderbird
To: ubizjak@gmail.com
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@kernel.org, pbonzini@redhat.com,
 seanjc@google.com, tglx@kernel.org, x86@kernel.org
References: <20260211102928.100944-1-ubizjak@gmail.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20260211102928.100944-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0066.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::17) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS7PR03MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: a1229c9d-09fa-46d0-619d-08de695c5d2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmdMcFh1aldVNkRXbEg5OEZjV0tKNlZrSGtvOU1MTWZwN25HVU84cEVKWlZN?=
 =?utf-8?B?Q3N3Q3Z4SFJlY0dLUHFTNnRKYlExS0h6N09Cc0o2aTAza0h6eXE0WGFQQTlt?=
 =?utf-8?B?WENZdWw1dElXNVZTNkVMYnQyZU85R25rYm9GMk9ER3FIT1NDZDdtbFcvN3J3?=
 =?utf-8?B?WFllQjV0ZnRFZ1lkeVBaMjB1REgxb1dhSVBhSVhHRXQ2TE5iR3JDV1hLVEZx?=
 =?utf-8?B?dm80c1o4THVZMmx3SVhLZXluZnJRUHJoR2h4WDZuK0dIVmJyT3JpcEFyU3Er?=
 =?utf-8?B?WDlpeEx6QitIRDRZT2R0bWpSTjNicTJXUS9IQWtSNVlDQUJvQlRqUE5lY0o0?=
 =?utf-8?B?TWJ1S3Joem9hbVpHV2RkSGkxdGNLekozeFlYRWRGRWRNN0xNaUZFdFkvZnY1?=
 =?utf-8?B?Q2tXS1phZ0o1ZjdYZEpzL09OWkJuTFQwcWNvVUVYVzl5Szc1a2YxVzhPbEh1?=
 =?utf-8?B?L21mUytCUFQ2SG44RTlaUkhmeEJoaE9BZDVXc1hEeHpOcG9KdGF6UFU2YVM1?=
 =?utf-8?B?dm56Z3kwUmVnWUl1bk1VZjhYMUd5cmRWV3BzSlR0djE2WEZjeVBzclJnbnZN?=
 =?utf-8?B?Z0ZhK2pKRFJiR2NJRmEzdVJFM3A4STl4cXl5bGFvSEN6eW5YcDMvUDZiL0VC?=
 =?utf-8?B?TU4vNzAvdEVidHZlTG1XYjlDdFltb2RVMWtkY2oxUUVIaHFVSmlpL0xjMGNz?=
 =?utf-8?B?OHRQbFFnWWw3Z2JuYjlHeEo0anlEREZHbEMrVS9RT1BhdHpsNWh1YmJJdWFr?=
 =?utf-8?B?dGZoUFBsTzFoZGtwTUtleWVZNmNnZFllOHo5ZUxtTllqcnhudDhUWVJoSFRF?=
 =?utf-8?B?ZDhnUW1WNmpzTWhMVFI0akh0OVVNY3djTythLy9HMG1KeHNFNXVtTnZBRHZD?=
 =?utf-8?B?MGExQ0Y3ckViZkJHTjd0QUh5bEIrWXdBKzdsWDR4MUh2cUxZQ3dEaGgrdUto?=
 =?utf-8?B?MGlsTHFQeHlCcTVYL1Qyd1N2dHFBM1NxWHloVUJOLy9HMEdMQzZ1ZHBHaXVv?=
 =?utf-8?B?KzZhWlNSU1J5K2xsT2xEbllGbmp1RHdFTjAyRnlwb2FncU12cmd2MHYrYkpz?=
 =?utf-8?B?ZHZsdUxJZkpUTHFZZ2hucXdWWEN0SjVWYVNRN3JLMTVkSE8yWmQ3OXlNWVF1?=
 =?utf-8?B?Qzk2RXhPSHhzakVPeklCaVNzR3UxOFpRNDB2dmkreTZMZXRqaXNEakMvQi9F?=
 =?utf-8?B?SzhHTTJkaUZ1NmtubVZGeWhRWDdHVkxkcjUzM1RkVGg0N2tQYzN2VkhsczY4?=
 =?utf-8?B?cGZsTWYxL1V0QWhBa0pyS1NCa2EybXBKc2Z1bU9kendSc2hNcGZ0N2pkOGRh?=
 =?utf-8?B?VU1nN0psYkY4MEZ0SlpnVXAwdFB5SHQwYkVVSCtWTEVvSFdESFcvRUhoT015?=
 =?utf-8?B?SmJaZklDSkRZRjhtdXRkRHV1cjk3WTVUSWF0QTN3eTJEWUdTMk5YZzZRK3N4?=
 =?utf-8?B?VGFFYkd5VG9BempZRjZxZ3NIRzJJK0hhUzNhcUtIbE5idUhGaFhHcGVUTVNy?=
 =?utf-8?B?ekw1ZEpQZFlmdVNHQ0RSRjIzanZUbXpCM09QZjBRQUJBRGF5NGZhVmwwNGlK?=
 =?utf-8?B?V0ZYVVQ0MUxnMC9HbXNHY2tlb0ZCeThMbXFWUEZScVNzWDl1QjlCc3pUdndm?=
 =?utf-8?B?V2Z3eks1OGRCeGJKV1dIdFc3MnFEYWJ0dWM4ekp1aDdkUy9hbWV1S1paK0tJ?=
 =?utf-8?B?bVEyYVlDRXZwZzc3L2RaV1FDNkc2UmZvMjhTVU1ULzgwMytpTHlsa3Z1TDRi?=
 =?utf-8?B?c0E2cU16QWtoUnJMR1NaQUl2OEZRL3IwZGRMblN5MVdVUGNNemovcjhBY0p6?=
 =?utf-8?B?UFNvY2RndVNlN0dHenU0MHlpbTdVb01EZVhjWm82aG5vZ2xqUVFvb0M5ZStY?=
 =?utf-8?B?QzVXb09mclhQK3dSNCtPaTUxaW9lY3NmWGlPbGFER0hGTWx5akF6angybUUv?=
 =?utf-8?B?NDZTbXRCWkwwU3gra3pXQUg4N3lMbWVPbVA2MU9VTlo2bEhNczBtLzdKUHpD?=
 =?utf-8?B?WG5STnlIdkRiaXh6ekxmZTV3dXF2T0RPVzJQS2RxSVVTbHQ2WDFDcVNnM3Vu?=
 =?utf-8?B?R3Bjc21aSGEveVZ1VldIdGIrQnluU1crUW9sRDRiRllTbk5mcXZTblR1YnVo?=
 =?utf-8?Q?JXhQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDNlRFNqTmFYQXhKVU1xQWREWU16dzdaUVpMZTNXTU5LY05JYldnQ2ZyTlkz?=
 =?utf-8?B?bUtyYncrVlNRbnQwZFRlOElzWlpHNFdRbkkybW5MVzN6ZVZrR2pCUnNZaW5m?=
 =?utf-8?B?QVBrRyszNi9yRTBEUGxXY3YrQUoyalpUMnAxb3NDNzh4S0hhTWxMQTRQUmN6?=
 =?utf-8?B?MVY2V09abWdCN001V1NaSExUdW54V2RubG5VVzFteHl1c1U5WHFUN2ZJdXRt?=
 =?utf-8?B?WXh5OXIwWmhseW9GOXlleXhLWVlDalorczJRNHRVMjlaTHpFQXRzaDlFRVp4?=
 =?utf-8?B?akNaKzNScmc3YWlCQkhSdzg4bmJZYWVWL2QvaER2V0Z0bFMzMXpxaVVNdFhM?=
 =?utf-8?B?VVN3VXoxTkYxM2RvbGJERHdOdXBQaHJ0c0lVV093cEt5TWhQd2w2NEZYQWo5?=
 =?utf-8?B?bTFpQmF1Vis0V3pkLzVINXd5Y2VZUXc5Z2kwU0tIQ0MzcDR0cDI0NVo4WUIw?=
 =?utf-8?B?UzNjbmp5UU1lVFgwTnFRSXBINTdLMmlKZS9CNEhWNHJjWndqS3pyMzVTdHFj?=
 =?utf-8?B?RGprdjJ3Y1pWMUVpbVlGdTBvcWFQMGpkRHdtV2laTXBpRjBwRmVRbm9uV2F5?=
 =?utf-8?B?YWZLYTRjcmRqdGkwYXA5TFBkck9oNWNuWUdxcVZXTnVXUGp4UzNUaWZVMFpl?=
 =?utf-8?B?MmlvaElSMVRGWVloZXBQUitIOEhLVmZIMFRaV3g1bEFwbEJ3djN4ME9KVDNk?=
 =?utf-8?B?ZnZXL1pMMENzdFVsVTlDTitGcHR1STUxZXdSQXpXdzZRZG1RZnoraEY2UzBq?=
 =?utf-8?B?ci9GLzNRemZ2ZHZMTkNGcXV5MWI1ZGtFQ3M3WHB0cmQxMkNKOFdaWU9LY1VE?=
 =?utf-8?B?aWJ3WVJHUGJaZ2FucEtXVk9TSm81KytOdUFTNDBwa3Nyb0Vyd3Q1Q1plUTlY?=
 =?utf-8?B?MFh0eHhCb25wemR1ZVNpTFg1UTFaRUtHalU2MTd3L2NsRGpiQ1RqWUJwSUcv?=
 =?utf-8?B?WEo1MGpHd0VnRnpuR0dsZmZXNUh0NFdseTM5YTZBL1pza2dONVV6eWVCSjJ2?=
 =?utf-8?B?bi9LK0dvaFVJR09OblhyWWNMYzhVcS9POGlGTjVLc3JCWU40ZCtNbklNcWE2?=
 =?utf-8?B?a0x0QjFMSFRUT2lwbGc2eml2eG5KVUc3Ty9wQVF1Sk5kSlJXbTJBZHMyUnRO?=
 =?utf-8?B?NVl3N1BqM0x1U1ZBb2RWc0IrUm10Wkl3OUR6V0hXcTYxOUg0K3dLUGdDMDRM?=
 =?utf-8?B?Tm1na254VVVzNzM0eW43ZTdtcmRhY2hJbkU4cWJBRjArejRjdEtVVlVCbHVi?=
 =?utf-8?B?RWdPYUsxNDhDK2w1cUtTM3dHTUxWbVVFWUJlNjZHei9NMHZzQ05JcGt5YUJ6?=
 =?utf-8?B?N3ZYbWEyb1FkSmU0NEoxMWJIZ0hnYXFMVU1lK1ROTXpkNm93Nm94aHo2Y3pD?=
 =?utf-8?B?ZG9XS3liKytFYUhpZURFVWtKMTRnV2p3QmNQTHpNclVMbUxmK3RBaERsWXY3?=
 =?utf-8?B?akM1T1gwTEREejJBRlBHcW45YUxRcnpzaHBndmZ0QnFhNDlCMW9DRHYxWlRo?=
 =?utf-8?B?VHdpNjUwOWFPL3JuQ0JxRTNxQzI3NnB0VDA2bzVYcDBudjNHbmFpTEd6dXJU?=
 =?utf-8?B?RXBhSjBUWmQ2NzRuL2toOStVTWxqalU4SDlON01EVzFYMFZxc1BPMTRkQ0Fr?=
 =?utf-8?B?bnJ2aFpYUzVFRnVlQyttV3pScUZsMkQ0OHRLbUpqVTk4a2w1Q0IvMG9ESnNP?=
 =?utf-8?B?aEV1S2dQRFpHdFdBV1lCb3FqSEhRMlI2cDFzdlRuYmVvdVNSYm0yQzZxOTFq?=
 =?utf-8?B?WDBUazg0RWtwcmdQdTc5Mi9pekZFZlFMZFQxdDR4RkN3QU13TE5mZTMySXBi?=
 =?utf-8?B?KzhxRWZBZ0wzZ1VrM0svUFAwWG04UlZCYVVZL0FLajhjWjlncUE0QktPOHNa?=
 =?utf-8?B?QnNtcWNZNStZeHFlZTZ1L3RvMXNzdUNOM2phWUtzdTBVS3pmVHpYbmswRWxs?=
 =?utf-8?B?aU8zTTZ1KzIxbkxYQm1NdTJqQmllRTZzcldqTllsSzZNaHhqaVBrZ1pIZmZV?=
 =?utf-8?B?dmZIcStCVmN5YzdKcDluQ0w3dzBXdnlxNFkvR0UrbEJpMEpEbFVqYngvbUNJ?=
 =?utf-8?B?b0h6Mk11cElWQlZ6cXFYck5wcGpkalg2eW9jcVFpeHI3b09JQ3RReThDNTRW?=
 =?utf-8?B?OStxQkM3ZXcwYnhhNE1GTkVid2tCSC9TUno4WHRxQ0twWktnWDFtSDZwOWY5?=
 =?utf-8?B?ZWE5ZjRJUFpDSVFBT3F0d3VGeWdnaDIwK3o4SjhJQjVxY2pzWDhWdW9VUHlk?=
 =?utf-8?B?bi9ES09JTTZyMFVuQlBYUDVHY1JoSEtKUFRKeGNnRWxNWXZzQldlaitRU3Zk?=
 =?utf-8?B?djAxN3M3WHovS2owSGhhbzJuUEc2TDZmYVd1M2JhZDRtN1Y1TFdiZz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1229c9d-09fa-46d0-619d-08de695c5d2a
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 10:57:35.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gs0bCxSnP/zDMmpetTRYEhIbUkZ01pSJs3u0HtsQzlQA5nDaL7VRikx8clTw8YEMWgP5by2B3YKTxYXQlB+4bg1e1isbKSCHkM2fDDs/NWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR03MB8095
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70836-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[citrix.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,citrix.com:mid,citrix.com:dkim]
X-Rspamd-Queue-Id: CC9B6123AC4
X-Rspamd-Action: no action

> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> inline assembly sequences.
>
> These prefixes (CS/DS segment overrides used as branch hints on
> very old x86 CPUs) have been ignored by modern processors for a
> long time. Keeping them provides no measurable benefit and only
> enlarges the generated code.

It's actually worse than this.

The branch-taken hint has new meaning in Lion Cove cores and later,
along with a warning saying "performance penalty for misuse".

i.e. "only insert this prefix after profiling".

~Andrew

