Return-Path: <kvm+bounces-41667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5EAA6BD33
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7385F480328
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D061D5CFB;
	Fri, 21 Mar 2025 14:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RN/12dre"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83C315DBBA;
	Fri, 21 Mar 2025 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567828; cv=fail; b=pcMDAY+qW+gHOmbnzAx3cXWx8QMye7Ec0IJ1Wd1wGm3x2icDcxV/rkmvblRzyAsnOwM2J2Ly1VOdyE2sZd0AK74eHmfopFnKBKj2O8UL+97pVd5mzoxryZf5kq0tJ+odAjToClb4YbZErNqNESzC3hv2E/aCQoPCTKg7FMLTC4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567828; c=relaxed/simple;
	bh=oruvrxnbqSfkgdTXjK1JKYD+gEFWHPfICKGS3gyHIu4=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AghQmzYjbvqdJdmguS6o4a2iFhbHg3t6bANdOUNi2BQRH//udnBZ6zjaWIkpasoYRm6iQJ6SCG8rBpAIUuCWGIL8Iy7S83pt4okFyd+e+fsKBtYlW1f9fSDrxL/Oe4SAoTnb9RG8OlGy/qhSu6Yuz+s2KF/5nl3eewLC6ZS05og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RN/12dre; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiG3lsWA9WMTUEmd8/if1Dal+hzRBB+3Gnf7ANP2XE5RU1oPXIVLOiT5xIEgWAO2AU5JI7nAhL5VFdJi4gt1U/+jmEns/idFtLNK0qQEoYzUi6bItv1jKHxigr68nj67SC8ylHuRqD9OHT2aKGi6osdrnWBl1O57abgzFPEPDXPohlrrsvoo6Q1vcfPKa5E5Ozxu5phVKBh3ZHH+AwHGnnmDD4f5m38QCr9pTHaAc3201Caf6vREHNuvdB7b4x4nse+PgY2drlPHjuxgOIfdKAPRHORhch5KMuuf/4NmGsTjfHyPzXIcSF04Erh6+CnPI0gpZOd4lva2FY9uYCJ7+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ti0IhhyyV8YYJ2EgkOwdCyrDvqWPjXeB1qAw4VRY2sw=;
 b=X68UHZLDLcXxmcErPHV+Nsbh0C5NsyngzAhSENCpHa116Gs8bCkb9Y7J5uxCFGJA3XSnPhJBDdv/nOooZ3/42HwXmvM/IxDwrK+8YPp3dg9iMoL7VSSqVx36YJ5wOubuBWANeJOrDO8yFG4Cn+GTR/vGQGex20FyNz1uFxVTS9Kh7xr0FEbEY8wRGxqeEfBzeZeR2HnRjAeHEt6VxTQVzuXCAlrM+CMiBtJqv6mof/m3dhFW5gC7qhxb3QHFAg4dDcH5VE7X7gO9G/5cLAxggMmv0GnaJvdebu77RA2sYAUQRAqUc18OTiCWJctKApnoVr+Vbfa/w1oWK99SrRilUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ti0IhhyyV8YYJ2EgkOwdCyrDvqWPjXeB1qAw4VRY2sw=;
 b=RN/12dreKmbgol/VKtnQIK7B7asMqvkV0MXld2Fs5oOq4aREp3CacfrTKTqqZyqkS7pxOWB4QJu1kKqR7OR136ReHjujZ6o5ouJjOrAuXQgnRHzrFizhW4SjqcYF8DHNzQsP6dQD8PrLIusvPVAdCIdVFFulaciEhm9/5GoopVY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 14:37:03 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 14:37:03 +0000
Message-ID: <419e72d3-5142-41c0-61d8-21b9db14ec5b@amd.com>
Date: Fri, 21 Mar 2025 09:36:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if
 debugging is enabled
From: Tom Lendacky <thomas.lendacky@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
Content-Language: en-US
In-Reply-To: <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:806:130::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: c89b5a0f-36d7-47f3-d4cd-08dd6885d87d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGtUbDE0YWFhVDJ1TktkN3dBN0U0eCt3NjN6dTAxaGpLaktodDJNQ0NOZEhP?=
 =?utf-8?B?ZW5aZHhtczNEWmJvbWJrdzArN1FEU0ozRTluT1JvaDE5WXdNV1pkZ2RTb0pV?=
 =?utf-8?B?MkxZT2xEMm1pV2d2NGVjbXczQi82QkRVSGNmV0hOMExrV3VOQklDNjFENURQ?=
 =?utf-8?B?bENsSjYrVTRSdlRXUk9yVE9ndDhxUU9lQWlKQmRTVjlBTElaalZrb0YyVXh3?=
 =?utf-8?B?Um93WTNLZTlRcFdaRytzMndXMDdBWGtjeWFMS2d2Wk0rYTZtR1I2aWhxS1RS?=
 =?utf-8?B?cUg3K1ZyVGt4T0haWmJBblRnWGVERVZXK2VtREk5aTJ3UDUrOHVCdWNJazdC?=
 =?utf-8?B?NW1HZllZV1RZQUdiekp1UHNaSEZ4YUsxZ1R6TEdNbzhuMUF2VFUxKzVHaVVB?=
 =?utf-8?B?Snc2VW8yQ2xjY1ZwQy9jMUxMR0xFMlkxZ3hjK00vNU9QVXRSUHRkd2Q0MDdV?=
 =?utf-8?B?U1JsdDd0dW9rOU15bHV3bWtKbGsrbklmSDFld3RReXhGN3htL0lobC91MjNw?=
 =?utf-8?B?eUJiRVU0NW9yNThyWmEvTjRrZytaTVhndENOS205blVRM1NMR3UydCtQakhp?=
 =?utf-8?B?aHlpU0tNOW1SaGFmcUJlY2tvSGQyeGhoa29odGVVSy80Q0RLMUFhMnIzTHFo?=
 =?utf-8?B?V0dZd2Z6bHpOYng2emZGbnc0UGNEQkZ5M2pTU1poZy9HV0xySkE1RDBUSjVQ?=
 =?utf-8?B?Szg2MFUyR0hnTnA3NjZQVXh4MHlTd3JRSW1wbDR6SHdScEF6YVQrbzg3Tm9H?=
 =?utf-8?B?NTJ1ZTdNRHhScHBlR3lUQWxsbW01Z2UyWWUyQWh0MUROOEFBSkdzaVpJWjhz?=
 =?utf-8?B?OUM0KzJLZkw3RVRSeFNTcERWd1U3QSs4MEprc1pkUGx2OXFkdC9nZ2JxS0hl?=
 =?utf-8?B?djdJNnEwSFlOYTR4MnAwdENiTjltMWM1VzFaR2FJQlFTVjY5NUhWOTdwNDE4?=
 =?utf-8?B?QWdJcm5EWW11Vy95K2xWSnJ3SnhyNS9iMURuNjlMSzMzcnVHaGxGYUhHZGNR?=
 =?utf-8?B?YzY5OGd5cmVaRDB5clJrVEJJR29CcDVXL1NmRzlQRzREb1p2OVhQVmJpOTJB?=
 =?utf-8?B?TUVqLzNlbkxoNUJDLzRML1Y4MEQ1WEJTbEZGWmtBWGQrWnd3YjdNYXlONUtr?=
 =?utf-8?B?Qk5jR1Y5WWVBd0s2UVUxUmRUZTdJT2tkWWNWVU5RbzNWVGYyRXVPYlp5U1c3?=
 =?utf-8?B?bXUrdE1qOVdCd04yTmJpVXdab01WKzF1RkxWcEVPZjczbkJxZGxjS0F5Q1lK?=
 =?utf-8?B?eXZPYkxGaWtMZVE4SDB4SW9VSkRXUVhIbXpaaGZKMGpaTjB3OUh6Z0pYMEhZ?=
 =?utf-8?B?L1ZaV1pUT3d2dDQ4SWUwTmozc3l4VHNEK2ZBdW1OQjA5MlAySnc5cUFBMHRK?=
 =?utf-8?B?eDdpZnZONTdVYzE2TGNGcGtPK0RTTDFITVRibE9CVkJTWnhDbWZuQTNFRk44?=
 =?utf-8?B?SGJYUUVabEphM2ZLbkwxWUtRUis3RE5saTdTVWl2UGQ5NXU4ZmRJcVdaaFJ3?=
 =?utf-8?B?dmQ4QkVmcUtFM0pRSkxicHFuaURlS21xV1FCaVZyZWY5S2tZQlpGS3NZN0ZT?=
 =?utf-8?B?MVpESG5wVGdrTUM3amVCMDNKSTVNeStadDJmb05Cb0FoME1wWnVaVzRndkJi?=
 =?utf-8?B?VnVSZFBpZ2dSbzhKY0QxS1U3VDZ5NG9iSXhnUU9NUlpqT2xxckFoVzZneU5D?=
 =?utf-8?B?RzNka1YzQzVhK0t0V3NzNUtPT010Y1RjK0NjQ0lkMVJtWUZrODJTM1Zadmxn?=
 =?utf-8?B?L1k2cnEwRnE0Zkc3ZUVjVlV1VlY4bUtyQkMxbjFTTyt2MjRKTVVuTHRKM2pB?=
 =?utf-8?B?SWltUEUrdXo0TDhkYkJ2Rm90NnR5NTc2eDQ2K2hXSGYyZzVvcUU4V0hBcFZk?=
 =?utf-8?Q?S1gpW5B+hDOVY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3AyRlVMRUVSNXFUK0g0R1ZCYlQyRDhIU2Y2VGhaSlFSSUtOaWRhelIwM1Nz?=
 =?utf-8?B?eDM1V3U4S2I5MlVpVTR2UVVJeUJCV2t3cE1hQ2JpMVFXdUZNdmh5cUNvdk9I?=
 =?utf-8?B?UURJcnI3K1g1YlV2d0pKZjBhV0k1bDkrQytqTHZkNmNGaEk2b25tdG1aZlFz?=
 =?utf-8?B?SzZrL1R4OFlXMUl6SjN6QzRwU0hvTmNnMEp2bzVjd2U5aWJjdCtxZmVZNW5l?=
 =?utf-8?B?N0RFcW1HczVLSW1ObEJVZlY2NExnSzQ4dXZ1eFYxcWh3OGdJTjRDYkZuOHkv?=
 =?utf-8?B?YjVmeEM3NHhZZ1IwWnBjY3NiTnRFeGVvN0RCd3BSZU92aTFhQ3d0VWNnY3Jn?=
 =?utf-8?B?OGZUV2tMc2lwcWVBMzZvWnhTOWMzUldhOHRJanBqREphcHZ0WE4vbmdGU3RP?=
 =?utf-8?B?MkhRYlVHLzdSUjZFdGhlejB3OG9WUXE4eitIVTQrbStOalZOOWFwVVJMZUh6?=
 =?utf-8?B?bXR1bnZzdkUwODVkcnVMN056emR1YnNVOG92a0c2RnFBTC9jL0xXbWczRXpS?=
 =?utf-8?B?OXhvU245dnY0cEp3N0RCaE1NQlJ4TXJIY2dOTVpZZlpVbnpqN3dsL2dPaktj?=
 =?utf-8?B?YUxheS9aWXhRaXo4cnhXbzhoNUZNemZ6WUdBaU9xK2FiV01pKzhuRTZRNVM2?=
 =?utf-8?B?Y1hCRUErQjU5UWhWNkdSUFJ4aW11U1ZDclVTV0FIZmRyak1oOTJGY2R2Ylc1?=
 =?utf-8?B?dVVZUGF1bEJocHFaRkpFVC9NY1hmeEsvVWMxVDZoR0RCVEh3b2drLzQ2cm13?=
 =?utf-8?B?OUNSeFF4ZzdDRXRWQkhleUpGQ2ZuZ3l3RG1uRVZkWUV0dmlKQ3k3WE81Wlhl?=
 =?utf-8?B?OTZrbEgvZWpZSU9sYklkTWlleE1naW9UajNrU0dtMCttSFFkUzFlaVA1emox?=
 =?utf-8?B?ellRNUl6Zjgva3hWb2FUa1lteDdpMXZtZktoWFNkUFZNajB1SGtKK2tnZmx5?=
 =?utf-8?B?UTFadUxyTkRqRnlESGt3KzJIK3A1ank5MDFyZVdrZHowcjYzZjYzZG5jUzBE?=
 =?utf-8?B?RmhXbjlZS3Y3aDBkVDJnUUhNYlJGdXlPUFl1US9NdW1YT0ZkZ25YMkt3SFhu?=
 =?utf-8?B?bkFRTkxIQUk1Z3dCMFBqZ1hVNmlYS2hIa3JYeVREbG11Ky9PZlptMUJZYlho?=
 =?utf-8?B?L1ZUNmlzWUxUb3llZzRDNlltbmZwb3VXWGFHTm9hNEh5bFNEbHFYWFVrK1l1?=
 =?utf-8?B?d3NRWkR2S1JkZDMyTmN2cTJBSlhzMWJWaTZsVGpsYUJ1dlpJVzdSS0g5S2V5?=
 =?utf-8?B?cEVuQ2RUZ1ZDaHpFekVtbU5XKzhCODFUcGNDNDdJYXJJV2xZNTFpVUIxRnpY?=
 =?utf-8?B?ZHFadzdUSTNrdFdXOXNheGVQNVN3ZDFoa0hxdkNzb042WU5YdjhKdXBYZVVv?=
 =?utf-8?B?eHVTU0RLc2w0RDgzSlFOQWZPbDNPakNMODIvZHhmUTZlZS8vMUlIc2d6MG83?=
 =?utf-8?B?YWwrQzRSVjJKc25pVDRHY3FRYjRoUEJYaVNyTS9NNm5Gem55TW9Yam84WFlY?=
 =?utf-8?B?dXdFRXVPNkxVbjFFNjZPa2htZ2VQaFFMMmFRQUQvVUNNZjNkb3IvT2FXbVYx?=
 =?utf-8?B?N3VmL2VvQ0NEbUhyZE9jcUEwbVZIYjVFSGJaQ0ZxSUhvVWFwYXBtTWZzLys4?=
 =?utf-8?B?VnpWZXJXMWNyZGp2cU9MaS80UmhoQ2tSM0ZicGJtN2ErcnlrWHhiUHUxSXdh?=
 =?utf-8?B?aW1KbDBwY3FKcnd5T2szWk45a2FKa1BZZ2J3em1iZk04emdYOUUwVUxicDhU?=
 =?utf-8?B?Z2VPR1JKTTJUUjkzOGZmK2VyTHJnY1pIY0NHNDRZS1B0eHFhL0ptMDVRZVF0?=
 =?utf-8?B?Sy9YZW40ZHNFOTJYS2FGWFJsNEJmN29iTFJZY2g1WE1SRHFGVWoyblBlTXBr?=
 =?utf-8?B?UUs5ZG02L0J3cmRiQTQ5eVN4cnRJQnJBNkJKOE5XOEx6UHYxSElHRi83VUUw?=
 =?utf-8?B?WG93K3ZRZjNiS2x0MnA0cUlSYnp0endjYWpFUWxXaFBQeXVjVGlRTVptOVhv?=
 =?utf-8?B?QVNxM0J5VWFNQXkzL05abW56QnU1U3YxQ01IZFFaSUk2ZS9ManhEL1M2NHNq?=
 =?utf-8?B?MUkzMFNpL0twM2pqVytFVC9sQVVvWGRIRzN5cDgxL0dtcURuTkZ0OFg0WXc4?=
 =?utf-8?Q?/FVnuxLDapHNMQ9P9rcBCP4Dj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89b5a0f-36d7-47f3-d4cd-08dd6885d87d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 14:37:03.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOpkM7Lb0wfHM8paBeCsIHsFU3JFdQ08+wi9SYXcA2pZu1Cf8j/mgLKS0lvaDDGPi5Oyo+Hx1dw/AClEswUh3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476

On 3/20/25 08:26, Tom Lendacky wrote:
> An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
> policy allows debugging. Update the dump_vmcb() routine to output
> some of the SEV VMSA contents if possible. This can be useful for
> debug purposes.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c | 13 ++++++
>  arch/x86/kvm/svm/svm.h | 11 +++++
>  3 files changed, 122 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 661108d65ee7..6e3f5042d9ce 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -563,6 +563,8 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
>  		return -EFAULT;
>  
> +	sev->policy = params.policy;
> +
>  	memset(&start, 0, sizeof(start));
>  
>  	dh_blob = NULL;
> @@ -2220,6 +2222,8 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
>  		return -EINVAL;
>  
> +	sev->policy = params.policy;
> +
>  	sev->snp_context = snp_context_create(kvm, argp);
>  	if (!sev->snp_context)
>  		return -ENOTTY;
> @@ -4975,3 +4979,97 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  
>  	return level;
>  }
> +
> +struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_save_area *vmsa;
> +	struct kvm_sev_info *sev;
> +	int error = 0;
> +	int ret;
> +
> +	if (!sev_es_guest(vcpu->kvm))
> +		return NULL;
> +
> +	/*
> +	 * If the VMSA has not yet been encrypted, return a pointer to the
> +	 * current un-encrypted VMSA.
> +	 */
> +	if (!vcpu->arch.guest_state_protected)
> +		return (struct vmcb_save_area *)svm->sev_es.vmsa;
> +
> +	sev = to_kvm_sev_info(vcpu->kvm);
> +
> +	/* Check if the SEV policy allows debugging */
> +	if (sev_snp_guest(vcpu->kvm)) {
> +		if (!(sev->policy & SNP_POLICY_DEBUG))
> +			return NULL;
> +	} else {
> +		if (sev->policy & SEV_POLICY_NODBG)
> +			return NULL;
> +	}
> +
> +	if (sev_snp_guest(vcpu->kvm)) {
> +		struct sev_data_snp_dbg dbg = {0};
> +
> +		vmsa = snp_alloc_firmware_page(__GFP_ZERO);
> +		if (!vmsa)
> +			return NULL;
> +
> +		dbg.gctx_paddr = __psp_pa(sev->snp_context);
> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
> +		dbg.dst_addr = __psp_pa(vmsa);
> +
> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
> +
> +		/*
> +		 * Return the target page to a hypervisor page no matter what.
> +		 * If this fails, the page can't be used, so leak it and don't
> +		 * try to use it.
> +		 */
> +		if (snp_page_reclaim(vcpu->kvm, PHYS_PFN(__pa(vmsa))))
> +			return NULL;

And actually I should call snp_leak_pages() here to record that. I'll add
that to the next version.

Thanks,
Tom

> +
> +		if (ret) {
> +			pr_err("SEV: SNP_DBG_DECRYPT failed ret=%d, fw_error=%d (%#x)\n",
> +			       ret, error, error);
> +			free_page((unsigned long)vmsa);
> +
> +			return NULL;
> +		}
> +	} else {
> +		struct sev_data_dbg dbg = {0};
> +		struct page *vmsa_page;
> +
> +		vmsa_page = alloc_page(GFP_KERNEL);
> +		if (!vmsa_page)
> +			return NULL;
> +
> +		vmsa = page_address(vmsa_page);
> +
> +		dbg.handle = sev->handle;
> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
> +		dbg.dst_addr = __psp_pa(vmsa);
> +		dbg.len = PAGE_SIZE;
> +
> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_DBG_DECRYPT, &dbg, &error);
> +		if (ret) {
> +			pr_err("SEV: SEV_CMD_DBG_DECRYPT failed ret=%d, fw_error=%d (0x%x)\n",
> +			       ret, error, error);
> +			__free_page(vmsa_page);
> +
> +			return NULL;
> +		}
> +	}
> +
> +	return vmsa;
> +}
> +
> +void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
> +{
> +	/* If the VMSA has not yet been encrypted, nothing was allocated */
> +	if (!vcpu->arch.guest_state_protected || !vmsa)
> +		return;
> +
> +	free_page((unsigned long)vmsa);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e67de787fc71..21477871073c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3423,6 +3423,15 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
>  	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
>  	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
> +
> +	if (sev_es_guest(vcpu->kvm)) {
> +		save = sev_decrypt_vmsa(vcpu);
> +		if (!save)
> +			goto no_vmsa;
> +
> +		save01 = save;
> +	}
> +
>  	pr_err("VMCB State Save Area:\n");
>  	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
>  	       "es:",
> @@ -3493,6 +3502,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-15s %016llx %-13s %016llx\n",
>  	       "excp_from:", save->last_excp_from,
>  	       "excp_to:", save->last_excp_to);
> +
> +no_vmsa:
> +	if (sev_es_guest(vcpu->kvm))
> +		sev_free_decrypted_vmsa(vcpu, save);
>  }
>  
>  static bool svm_check_exit_valid(u64 exit_code)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ea44c1da5a7c..66979ddc3659 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -98,6 +98,7 @@ struct kvm_sev_info {
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> +	unsigned long policy;
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> @@ -114,6 +115,9 @@ struct kvm_sev_info {
>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
>  };
>  
> +#define SEV_POLICY_NODBG	BIT_ULL(0)
> +#define SNP_POLICY_DEBUG	BIT_ULL(19)
> +
>  struct kvm_svm {
>  	struct kvm kvm;
>  
> @@ -756,6 +760,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
> +void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -787,6 +793,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  	return 0;
>  }
>  
> +static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
> +{
> +	return NULL;
> +}
> +static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
>  #endif
>  
>  /* vmenter.S */

