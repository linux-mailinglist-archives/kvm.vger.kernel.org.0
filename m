Return-Path: <kvm+bounces-68974-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPHEBRONc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68974-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:00:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8061E77650
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D4203302DE1A
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFCC3336EDD;
	Fri, 23 Jan 2026 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xvBd880c"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF731330640;
	Fri, 23 Jan 2026 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180405; cv=fail; b=HiyTOB2FWrjlvYTDrbRfzQtbEe/9KjOAb7tThxepG1QntJBWOhen4ukYT/6oxMhi4V1AZ/nW83tmTOB5tkHuOTJkO102bZkqe92Jmq1G9/DgieoHiCWFNafG2J12hpLMR6GhQ+lBWb72Ct6L+b1m/eHFDqr+q7MtQlSeq6xI5s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180405; c=relaxed/simple;
	bh=vTViHFEEbRyvtcpCs+mKgvASwjQr1zJzCdkcD6q+tmk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m6GzflZCN9V5b0Xbo18rqttgnd59qchI+SE4xZWeaDPwWc7sSEVkq9lxh849Fk114jKx4D+APfwyGH9HKwfc2B2q0B3zTHF3eELjo57hrjYNfftT9VgQ4woLQ5CgbGPrR1lwdk+HV/eaxkZo1mQu40Cb11EO9o3gzzF8BJdOij0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xvBd880c; arc=fail smtp.client-ip=40.93.194.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBtCK9SnhPh9TsfgIWQvlc6VkygTYhwRkiDVkxEnBQ6EamVMCJwVcnkOfKiXfFLx719rkPUaFNIWDMbe8tIdEOYNNvOlXaGhHVnuas8PIKRBU4ekvb97L+trvYFhe84wfdx5vghdRsISrCgONL5Gm2h/0VB8vKiIrtw8ZsYdOIpEgCIC+PT3+IDPCquM+H9NyO0faZS6NT4GzwHFuC7Z7dwDX0+kA2eA5weWXw2OkQoRku7ZLYXUiEO/W8zdQ8m4r3U7V31Nl5xUvhPYpe09b8wD0rtD4Z/CPzfNrQ1hXHt+Z1OffQjaFYEXgzxrGlwQ7TyGjI5lfd5kLDcVEvEsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EOGJ170lwEeTBpQrhUp+QXXty3x5dvOUYikTGMDFTA=;
 b=zJtNLgm83RynGaBo5++MNBMO+PAnN1DLRc0TNbmDYMOhc6EAl9VZtpQiDEssxZ+G70T+xGTmndANegqRvbFCJH2JSVezoRn1GgYH7GK+/zggUh/6uM01pZtalhs7ZQuS3hXt2Yjo4GOkKOdFF6EuoDMqTuXU4EHAoaKYOJP1hU5ugcoJDLIRbWlM5z0uYjAX/UF6miN3hdzGY/zUqOw8eJ4SaGKZ4gCNGG4wUazssDKFn6FbFAVhWVvLYLDT5ebUrkiRPeZUXFkoVAu+t6yeb5aLfSWzB/+cB0uNFiQnuIusbhbr/wdcFv9S22JI3MpotOOccpMVboBxy4GnKqEJ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EOGJ170lwEeTBpQrhUp+QXXty3x5dvOUYikTGMDFTA=;
 b=xvBd880c4RUS5+jSry4zn9+uOFpQbgwjoRcKIgOlsR6RUnnWCh2mEUZfkMCHsTvJaEuw+jNd21gnReqcYapIMeN9wlErIeuXCzpX9mmPAHdyynZh8vU8KVfiNQx+qZvKM9eeYGtmdY5dr54L+9NA9Yoqe4LlpagezYQxQMQA9ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6667.namprd12.prod.outlook.com (2603:10b6:510:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 14:58:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 14:58:51 +0000
Message-ID: <d0b7d86f-48b8-49be-b0ba-82d7c3119745@amd.com>
Date: Fri, 23 Jan 2026 08:58:49 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260123115306.430069-1-thomas.courrege@thorondor.fr>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260123115306.430069-1-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0109.namprd11.prod.outlook.com
 (2603:10b6:806:d1::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6667:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a204507-a38d-40b7-3d58-08de5a8feba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGMrNjEzY1l2WENjcWZmK1VHdUZ0MTFjK0FUa2NTMVkyVnBKUXRPU2JFZk9K?=
 =?utf-8?B?QWVHaXRleUJYeHJ6OEU1MWtjNXRRa2pQQUNRREtUSDh5VzVyTzBaZ2xLRXhW?=
 =?utf-8?B?Qnh4bzJTdS9LcXN2WXRQTUJ3Yms0NWlmZU54eGZJNEFpa3pZbkgrMHhZUG1a?=
 =?utf-8?B?RlNxR0pna0tmdHNVam9qZmJNYXorL3MrbndZNU9ONjhnSzlwbzBnTnJEY3hY?=
 =?utf-8?B?bm5EREJnSi8valBOSnRTQktWQkp4SzFTMGFUdHBScUlFeGVUazQxQ2NTbHZq?=
 =?utf-8?B?OUZzdGNRa0VHZG1mN29WN0p5WlI0dTFnWDdmRHErSmVNRUFtNGZycVFTSUpO?=
 =?utf-8?B?T0UwaXd2MkgybVY0OFhmM05yRlFDNjNQRDNLY3g5ZW03WGkvSDZBWTJES09T?=
 =?utf-8?B?N2lMa2JhczFFdS9Mb3R1S1pubDcvYUY4a2g4MVBOejAwZUxoVDEzLzdCdnZT?=
 =?utf-8?B?dEprc29OUXhyTDB1SVBvZ09BNFErbk51ODVFTWNBQVg3akRwL25ZZmFXM3pZ?=
 =?utf-8?B?d1RITUZVbGlVNVhFdkN0WDlLQ2lYenlBeHdFVmxRblJmeXM3b0VQZGxpd0pQ?=
 =?utf-8?B?czFtdUFCa2EraUcrb0wzZXY1QW5ML2N4TUY3YkdYQ29rd0M2N0Y5U3FFRlhj?=
 =?utf-8?B?Wmh4T0UrQU9WTU9udEJCaUNOSmp5QkpPTklWVTZOWkVkVjQxc2ZWMktoVGpy?=
 =?utf-8?B?RVNiZ0p6RTdzUkEvY1JVNVYvbFBpNVY5MEQwdmRZckd4KzkzdGVoMnRrYzZp?=
 =?utf-8?B?cnl5VnFuaG13dUgxTS9BRTZRdlNoV1RsRVRxU08zY0taOGdwMFNWaWQ0RWFR?=
 =?utf-8?B?T2V6WnEySHZIMkxGVklVRVdydVh0YWxZSGd6ODBpY1RPY091cnBDT0J6REJ6?=
 =?utf-8?B?V0xudk5rUFkwcWhLWmVZNkVGamRZUkk4bXVOUlJGRGN4Q1JvQ0ozTk5MOWh0?=
 =?utf-8?B?TGpNSmVzYnArMXk1NkFBZlozc2dIcVE2Z2loVytDSFl0akpqZXA2ZkNnbUhT?=
 =?utf-8?B?TlFjU2R0ZmpMK0RZY2NhdFV0c3VFT2FPbFJiTHJNaW5tYVFweUdnSmErUU9i?=
 =?utf-8?B?Uzh1NzdTZ2ladTV0MUl3K3ZsaG5uNzZFLzJJZXA2VVBRV0RzRnBYV2RjSFho?=
 =?utf-8?B?cGVBUkVoU1pqYklFVFFJVlFTT3VWNXhrSFZuUmVTaHRYNzFaMHlOS0hpaXJN?=
 =?utf-8?B?b0tKdkVPK2VKNTRnQlJUMGVVZmltZFUxV3ZuampWNmtZa3pPRE5WM0ZqZGU1?=
 =?utf-8?B?S0JYOWsyZys0d0RBNjhDTG5mT1lpQnNXWXZ5VStGUE9COUpKZzF2Y0ZKSjhv?=
 =?utf-8?B?dUc1OE1HMmpScEI5OUNZS2oyYVBBcStuaEgzbGorZlA0cUpadGRQeGlJSWdX?=
 =?utf-8?B?RTJjQ3hDeVdmckdyV3k3c2pzZVBOWXhPSGZkTTN3TVdBMTdCUDdMMHZxbW5I?=
 =?utf-8?B?OTBEUSttdW5hR0dhU0tneS9lVFRGZmQwL0FGbzJuODhLNjc4SVV0OTd5eWVO?=
 =?utf-8?B?QU9rb2pHdVZuTFlvMTlVZEJhcVIrTW5WZWFjbE1BM003Q25zY0RybnJrVVdU?=
 =?utf-8?B?bFY3RWlaQjlMN3VPRWNoaThGcklUdEpldXM0NzNwbk1IUVJ2TVRTdEVkWUFH?=
 =?utf-8?B?RjZJMUZpK005MU53Ly90Kzkra2o5ckZyaVZCYkc2dG9SRW9yajJZZU9YRXVL?=
 =?utf-8?B?eDBhbHJ0d2NWTndseVlYeVRUOE5nTUlnU1FPOGdqZGp3TDRzbXE5ZzVIb1BU?=
 =?utf-8?B?SmFyOVpySVF0SDkwRUttT2Y2ZFhIN09YWTh4NVY4U1VBZmFWLzZoYkltdEVY?=
 =?utf-8?B?TzVEWWtMeVVCMUhyZTh4NU9LbGE3S1NYV01Qa1hWTGE3MnlIS2d6QXh1bnBI?=
 =?utf-8?B?L1FjaHJOZW52WDNheTVlRFBQNmtYc2JaZ1dwZ3JEdTAzNFQ5RjBkcW5wMno2?=
 =?utf-8?B?ZnVzQzVFeTdzaVlBeDJ5Uyt1b3ZLTEUyY2hTRXJabFZXNE1GWVpCdTBBZWpH?=
 =?utf-8?B?anF5emlTQi9YeU13bzRXUjRESm9jZ3dhNXA5SURzU09Cd3ArMUNYTXhTOUdE?=
 =?utf-8?B?Rjg2dFR6UXBsMGxoTTR2OUVLNFloNzQ2WnlLSE9jbkJOclVVWFkyWXpxU3ZI?=
 =?utf-8?Q?suBQKvjkzrAL+ysoWzoqe2Q6j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2t0bk1jenFxdTB4MDU0OTFPN1hvdUJMdzVMY0VRTHVhcDNkSzNBa0NSN0Vs?=
 =?utf-8?B?RkE1YWtNei9KL0lCZkRlb0JSNUNDeFZyQ2tzTVc0dzFhUVlTQ1kvK2RxYlVz?=
 =?utf-8?B?WWI0YU52Tk5yZ1FLUElZaWNOOFJtdGtjdEpndWd6YVd3TWUvQ3cxVThGVGw5?=
 =?utf-8?B?aGFHQThMSmtob2JIVGllbkhpWUF1ZjR3WlRNbHRzNHViUXk4eUdnTVUveHNH?=
 =?utf-8?B?aVU4dktldUdXeTB0UUpSclRaUGVacjduNFdaVE5WcVNRYUtNZVJBeGNQVU9i?=
 =?utf-8?B?bkZlYWpyQ0w4WXl3eW9Fb0ZDSHVPZ3pSLzRaYmllNEZ3dUpiZ1Z1ZE5hODF1?=
 =?utf-8?B?SSthUlJ3R201UEhHWTJLYnZGZERNR25BR0dqdjFwUHppbFc2eEVpMURYL3dO?=
 =?utf-8?B?MzQ2NkFheTN6U1VOeDNXNzhNRnJMT0prS1g5cHZuMDExdnJqeDlhb1YzQ2ZI?=
 =?utf-8?B?c3lFK0dtclBSeUZ6ZjFnM2J3RWZaTHhyeWZQL0RRb3NMR2svdjQxYXMyQmpK?=
 =?utf-8?B?VlJXTDZ0L1plOXFSaXRZU3l1THBUSkFDRTlZUTZGbzI4TGkyeXJKRHFXcDRI?=
 =?utf-8?B?b3dLR3VxcVFZWG1kZW8rSHdJQWFEaEdUQVJPZktpVHc2NFFJV20yRVVCWmUv?=
 =?utf-8?B?d0RBRG03S2pOaDR0UFV2MzNtb2xZTjBjbXpEL3ZBOERZMmlncWZ0Z0xzRlJv?=
 =?utf-8?B?eDlqR1ZFNjk4eVlrMElPQWpld0pFbEdoTnBXR0U0MlB1c2I3dlJ6eVdBYXR5?=
 =?utf-8?B?OWJha01FOWlaOEFkWDYxL3QwN3JDeC9hOFMzeWZ1WW1DN3FpdmNkK2YxNlBQ?=
 =?utf-8?B?TnlPdlNaWTExa3lPT0UzajZNNDRpN1hraDBqTG1MQXBBUFlJVDNJeVdVQjRs?=
 =?utf-8?B?dU5lckxsZXF3YXRpMUNUVkkrSmZtQTVoQTMzUHl4NjJGRVpYVGVNWk41RW5p?=
 =?utf-8?B?N3VERnZFa08xV0hBL3ZaR05MTGNYSnAvZGxpQmxQOGN4NGJFekNyT0pDVS9h?=
 =?utf-8?B?VkFPaUd3dGZjYmxLalRlOXlFQkIvcTNRVmlnbWZGSDY4K0ZGVU1CT2c0U3F5?=
 =?utf-8?B?emZLNmVyRmlpekIyUzIvUkZhM2U5MXNyeGRQbzJCYUFucjNnRUh3bENwbkpV?=
 =?utf-8?B?bkZtOThQNXZZcGVvY2Y5c0NNL1N0MjhZUWRKZDJ5d0kvbC91VG05ZFZoM0tu?=
 =?utf-8?B?V1hwTlh6RlJFQ2RaT3dFSFFFY2R4emJhQmI2UzVUUDZrZlAwQlY3SmRlbU9W?=
 =?utf-8?B?eCs4cm1UWXRUZmM3SlpFcjMzbWZCMlNsbzVvTlJVYnBWdmcwSWtjSlN2WThZ?=
 =?utf-8?B?WXgrK29jNFZhbUR0QkdOZm0wSFBnNmZJU3dRQ1dMdE1GRTM5M0xTeUFLdFN4?=
 =?utf-8?B?bnR1a1ZOQ2xkWlBmc0NUNzNRanluTE53QzBNelVsa0dyMUJ2UmF1UTFXYzI1?=
 =?utf-8?B?Z1hQOStiejBQalJjd1hFendDdmJsTDhiNDhrcTQ0c3F2eGlQRlhwQnRDMjhM?=
 =?utf-8?B?RjczdmNraTNjTVh3bG1FQjhYWGxNU2M1ZVh2UGRCUFludWVpM2xHanVoZ1FZ?=
 =?utf-8?B?MDl0c29YWlpyQXJkRS95aXhod0pMaVhyOTZuOXM1ZGxIZUpFT0NIc0pjR1lB?=
 =?utf-8?B?NjBQazhmVDYrVlFRUUpQUFRyTDV3N3A2ZCtXcDFYSURhVHBMY1Y1bFRJLzRC?=
 =?utf-8?B?SFM4c2l5bldGcWVRQ0pUenFnRXRhbExSWkZ4R2FZT21xbGt2cFBaVS96T3Vi?=
 =?utf-8?B?cnlaSnc3MGo1dUIwZ2g1ZWNCOHhvS0hKb2J1bHlwSTVIME82TlVxRUlzRDMz?=
 =?utf-8?B?TTNOMVNncFdNVlhmbzBsYWJzYmN3Si9vL0hYYjZ2LzJvVUtDOGNNU1BDVTZG?=
 =?utf-8?B?RHhDQXk4ZlRNZWdpM054SUthYjlyT002YkdFeFBlcDM0ZlplWHpGU2RNK3c1?=
 =?utf-8?B?TkJFWkoxUVYvWEphWnZiNS9ETTg1YjVKVWc2UnROUEthbGJrZ055cUVLdlBY?=
 =?utf-8?B?Uk1DTWpQMzBSM0tLR0swZ25aUTE0US95N2xncFV3ajMrbWxIZkVHNkxzSXpo?=
 =?utf-8?B?TUVKMmJrbC9ONFZQRVh3b3NLeE5MTVo1RzhtOTI3cE1OMkk5YUFGWmxEekhI?=
 =?utf-8?B?Nm9pNGVuRlJ4U0h6VjRuS3JrRjl0bXQwOE8zamxQa2srNnlvZWJRcGxweWpw?=
 =?utf-8?B?ejlqekRIRUlyNFlJZThUV1JnKzNGSEZnOGdSUDRjMVd0WEJZY0RqR2FsWGdY?=
 =?utf-8?B?ZmFLUksvY2kreVFYZGxVU2Y2ckxBdVVLSXNjdXRCanIvRmFUMkJGTi9CMENy?=
 =?utf-8?Q?Dx384r3bcJ/Obvrlwd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a204507-a38d-40b7-3d58-08de5a8feba7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 14:58:51.5439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrHEVh0DtzpGC8/ZlQEbUlXySXGtHg089v2HnW/BFqYse7QrVHLmng6ysDWFi1jXa3IFuv0r/1wEwBOHviQ1Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6667
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68974-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 8061E77650
X-Rspamd-Action: no action

On 1/23/26 05:53, Thomas Courrege wrote:
> For testing this via QEMU, please use the following tree:
>         https://github.com/Th0rOnDoR/qemu
> 
> Any feedback is appreciated.

So I don't see any of my feedback from v3 addressed here, nor do I see a
summary of the changes between v3 and v4 (or any of the other versions for
that matter).

Thanks,
Tom

> 
> Thanks,
> Thomas
> 
> Thomas Courrege (1):
>   KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
> 
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 29 +++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 ++++++++++
>  5 files changed, 130 insertions(+)
> 
> 
> base-commit: 3611ca7c12b740e250d83f8bbe3554b740c503b0


