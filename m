Return-Path: <kvm+bounces-48309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F38C5ACCA59
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A65D43A1EA9
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0878523C8A2;
	Tue,  3 Jun 2025 15:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IM8nF/is"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86E023C4EE;
	Tue,  3 Jun 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965317; cv=fail; b=lJVwun5HSpytrgxR4m2XYDNBhX3+f84kdGo4iC0jQDo5aVX8EP7UaGjifuBERSEuhb7TbEXJ/b70Sp4JVkosQNg9D005FJuO/3ODewWoDqCecF3sdA31E7ykcVMd4wNRBdBXpWVavvEJc67JTZ+Ys9YUm85TiNUZFsRxawxZxmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965317; c=relaxed/simple;
	bh=U38ALqgZK55rpP4Rv+uh1rLhJQFkkYBeIeVy66G6Itk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OeJW7zRerVnyeKL1sbHzA4rfswSj6q1aiYcMrNEmbbwzt326m2r9k2t+U3svQpQgmnldKDV8mNdkWKZ9HEOBs7zGb78BRI60zshYla2ut38Ca3v7+HbHEJhWVNmF4OfIhuE+IJXYQ58ZVn13MVLnutF+NmbU8T7T6nj92DgJyXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IM8nF/is; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvK85Sy/Wf3Gcz2kW+oMRqVGWU7vJAgAjyEDm9PmQb0tX0RSiiIvowas4pEUm+IprYlkeV20vjaRkn03AYpaHmZcGvl1G5P6wX60vmNdu+ZcdGY+Lw5ke9ln10Q4CfR12jBYwFov7/Kk0RFQIUSc+ePk3Z2lbkWAXOovtzd0P5/2G/ZpIRCYULZ4dsr5//9NtW20BvEjF8gS7UTBADM9nfdhmbiKb1doGEgqsAN5jX9uO8qTvEfxxuU/7DZKSa9/uIKGw1CaWEqJdsenubFb94RXPVhjE3AdHF6TdhZAclxEjhpu8t/EsOMwsgQ8wp3UvrYcjKNHc5CO4YrarcR8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QoCkWs6454uMDk+B/oJ5l9/o/bjLLIpVq9mb2jN8cw=;
 b=sPVu2fhA61Oi450uOsIdOMaJdx4iy5pk95n/zItUYqe5Qdfbh+pRgTPWc0hKhHaz4rqsO8znPDVHFrxhUXPuq7yjUUqpv1N8fJN1+XKeINdve+coSjYkqed2+eXXAcpjKqur7zs9y10gJ3NsNH+yaFLMsL2kYs+2eVK11HawDE38W0FOPEOjtUT2r72Wn1rYpIbOsz/6ByzHLF2n3Kr9Mgj/DFX0qJc6nFmPwG+XOudZDZQQ/z1TW8wW0R9kAd9bcCt0SD6lZGORctfOdk7BMzejP527FA74Fa08hD/Fmk5PCgXkHkK3CMKFWySYsRrJOII2trFkCVEnF1iL9BquwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QoCkWs6454uMDk+B/oJ5l9/o/bjLLIpVq9mb2jN8cw=;
 b=IM8nF/is13wxj1j+1DIBT6EN2KZVtAEHdB/l5I2WTgMPYPMdnD7BIDYy94OoUIRkS1G50rAWIqKFyJN+krXLLfWaHcgUGwBlWX/OK6lVubwREUSqBNBSl1phKPzjtiQgkC5p0ZapjT13e1qNBDHcwPKkNumb14+EFtjLgY5RClI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6395.namprd12.prod.outlook.com (2603:10b6:510:1fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 15:41:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 15:41:51 +0000
Message-ID: <77350d09-1d51-2ae5-39f9-a62ec29675f5@amd.com>
Date: Tue, 3 Jun 2025 10:41:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 3/5] crypto: ccp: Add support to enable
 CipherTextHiding on SNP_INIT_EX
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:806:126::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6395:EE_
X-MS-Office365-Filtering-Correlation-Id: f2a8916f-a9fc-423a-08cc-08dda2b52897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWJIT1M5aFRVNldxVFcxMUZ4TnVDUUJPb2ZKelpHWjdRVnFvY1pjS01UOCtW?=
 =?utf-8?B?VityK0JmUlg3Z2N1Z3FBN2xyN1JWb1dmK0lmaEp4dWQ0SGVwcVdhWVQva1U5?=
 =?utf-8?B?MlAvbnd3QXZLbndaeEJuMlhoTjdiVDhFWjdnS0p4c1FOL1hvU3B1Um5uU05I?=
 =?utf-8?B?K3U5eXcyYXVKWGJVdWpkNlFhNFFHZ0lQMFVzSFpzQkM4eCs2Rkp6RmhYcnpQ?=
 =?utf-8?B?UEdIS0FzOGlmVkZhV2NITlJHb3VPNC81MjBNQ3JkenhLQmtualgwQXk4d2th?=
 =?utf-8?B?Z0tSdHRBOGM3YkRKZXZyRjlHNnM3QVlndWFta1A4c2t1M3R2bVdaVXRJZEx5?=
 =?utf-8?B?aDdBdFJlbThCdFpyOUdNdDRLK0xaeVJjTTJLUlczQmt4cC9WNjE1SWJCNGFQ?=
 =?utf-8?B?MjRMdk8rV2o4azBkN3g3Z3Q1QzJjbHFMQ05IdHE2YlJ3NXpNQzdXQm5XV21X?=
 =?utf-8?B?YXJHSTZaSzljeE43cVArVE1PMEkvTXV5UmIveEpoT01SVGM1SjBiU29HcThV?=
 =?utf-8?B?RWc5UzJhSndUZHlkZzJpekh2bDc5WUlZZWdmZzFXOU9sZlk0TUw2MTcyWXZI?=
 =?utf-8?B?VUpKd0tvYXUvcHFRc0pYRHhncUUzZ3UxYURJcG9iS1d1RTdPZ1FVZ2NYamQy?=
 =?utf-8?B?Wm9kZWd3RzBETSt5ODFKUlpVTm9wRWEyTm90YXdqb3IwYVRqQitGblFReS9Q?=
 =?utf-8?B?YzVHMDRwaHdyYUhUVCtHNmhsZ28rUTN5VkZCSzVTdDF3TVNxdHk5UzlpK1Q1?=
 =?utf-8?B?TVA3YlRRTTJPamY1YlJaaTFwUlJVcXQ2cmlmYnFPa1JmZ0JsUmNvcTc2S2xt?=
 =?utf-8?B?RTVNcXd1NEpjTUUvYTRxVDVVQm9GYXkyU0czVU5pM09mY3ZUT3FKcjFuYVFZ?=
 =?utf-8?B?Z2dFWkRyVUZSUkdEditYKzhadTlzbUFuUWRoRVN4T3QyQmEwTVRteGUzYTBh?=
 =?utf-8?B?T2JlZ3VleDFsMk5mM2N1RkJwaDNqVXRPdzBnU1F3ZVo2U09jS0RSWC9mdkdJ?=
 =?utf-8?B?dnovbWZ0OEx1NmlDU2NYUmJQQWhmdElzOEFWSHVLaVFJNGRDVU91NTVNWTJz?=
 =?utf-8?B?aUlsemZUbVE0OTFKMy9BYVBSL0FSUWF1eTBid1JHK3M0ajNra2g3RFBnOUNH?=
 =?utf-8?B?c1g1NVJKeDlrQmxjcGpMK1hwNUhLNTNhdWlVeStEUXlxZC9hUTBtMVVnc215?=
 =?utf-8?B?R1NYclBMUXNHemM1bzhPRUo3bFVpNGtadzRtSXA5UGwvbHgxcU80UVVMSGJp?=
 =?utf-8?B?MlV2bTk4NU1wc204MTg4QUwxUkg0MzQzcEE2RVZlM2FxQ3AxWE9naVQ0Mmx6?=
 =?utf-8?B?ZVQydXBlYnhmN2pGaGRtSk5tUjhPRFdaWmwyL1dOTFh0NTZFWFNTY000Yklq?=
 =?utf-8?B?ZnlKaXZoZTV4U3BlaFN1VnFVTmhyWDhsNDFraG45ZlppNjluZ2p5UU4rUFZp?=
 =?utf-8?B?YmhDT092Z1RlTlJ4VDZmUm9DV01XbU9UVGpnTGl2b1RvdmZxNGJOWjh6bmtF?=
 =?utf-8?B?ZStUd2tFcnhHNDdvUVN1SW1ka3djZEdTWElWVGxOSEg0anpkaThOKzVkT01a?=
 =?utf-8?B?WngrbE42YnBteFJwOXJTL2d3a0lJcFBZOVpEL3ZoWkFMMXhWR1hzS2VGNlZU?=
 =?utf-8?B?SnNJR1V2N0IrM2JqNDRTUnVqZm9PWVJScE02NW9MUGpJeEpTbE1oVTIzZUhG?=
 =?utf-8?B?S2x5Y29USzdweUFNcFZTRXhLSTIyazI2a0pMVExpREppdzcxNmJZc0paSnVT?=
 =?utf-8?B?YlpNaUFkNVhkeTdnbEpzVVEyTTVMcW8zT1ZEWVltcHFuVDlpR2I5QmRXckp1?=
 =?utf-8?B?cFFiRlpIcldDTFRDWFB2R09tS3JNbEtkclhhUUdXL2xiajcrNjBBYVJUYkkr?=
 =?utf-8?B?MXFxQ2I1OUUxcDV1amRsamlaSlJuOXBjcDRpNHJSSCs5QzVCekluVHJDWmV3?=
 =?utf-8?Q?sYTzZrqCIws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1pMaFZLRlhTaHNkNkdEY1ZzYnc5dUlDRUNoYi94aWptUFY0Y1h1UmNrOU5o?=
 =?utf-8?B?b25ENUl0eHJoV2MrME4wYjFweldNemxpclFDT1hFdW1mSDl1WWp5dURuU1Vn?=
 =?utf-8?B?akwxS1ZDN3M2eXg4akRCTDYxRlhLQ1hPWGVNRjhtcHlnS1ZST1RMVlJXVktQ?=
 =?utf-8?B?UEw0WG5WcU0zTFZNakNUSzU0UjgyVHJzVTBWQXM2VTBuT0ptaUI2R3ZDTWQx?=
 =?utf-8?B?dGhNUFNLbzRWWG1ueUtGUmw1VVhtL1R5QXdzZEluYTJUc1psMlQ3TFpFRk1a?=
 =?utf-8?B?VTBQRFYyZmlPTGFueGhoT2tZZ1BkK2xCdzdtb0FNL29ON2NXcysrcUtRL21x?=
 =?utf-8?B?c0pvREhNOHB0WmlsbTJ0L2V5MmovQ3VxVWlKY1A5TXpLd05MSXNveFAvRFhI?=
 =?utf-8?B?RFBLaFppaDFFdkJWb2IzWGFnL3EzaVFvb2lreUoxVGtycWRYN0FHd1NhOE1u?=
 =?utf-8?B?TWo4c3p6WVZLdTdyTXJDWmJMdzh6ZndDQmU4M2MxR29CV05UN1RUMjVkM2hI?=
 =?utf-8?B?NVdGUEl6dThaNUVhNnpaNmNRZlBNKzI0VFFUOHRTdFVmL2N3eHkzVUhEdVlk?=
 =?utf-8?B?WkNNK0ZNNXJXMk95MFl1UVdXdm43TWVLM09pMnVqM2h6ZXo2OUdUc05DcXRh?=
 =?utf-8?B?T2t1bWhXZTVZTkltZ0ZjSTgyc1NCNm1vNVg0SHIxYTFsWkJ0cGR4QjlBSmRQ?=
 =?utf-8?B?WDc0NjFpYmZCRWhvMTQwMnBsQllHL2tvSzU2bWQ2dkVlVHp0U0hZb3dranBR?=
 =?utf-8?B?b3lIK24xWXJaZ2pYS3M5S2V6SndJTU0zYk1YM3RxWnlaWXpWcWNRODBtais4?=
 =?utf-8?B?T3lxRGpuVitMNHZNU3NvR1hQa203eEtBdHFoTUNHUGg0VXUrNEJxQjJmd1VJ?=
 =?utf-8?B?NDNlQXM2NVRUUmc0ckJmQktQbEtHV3doend3Tmt1Z0NHNXdkYmRNZy9qYld4?=
 =?utf-8?B?OXQzSUkvYnFST3ZXWlZuY0ZEMEpSYm4wMDBTYWUyZjV0NTRvWnM0bEVPSEpo?=
 =?utf-8?B?NlFrZkh0b1M2d1ExU3l2OXBRYkJXVkJvcXoxOUQwc3Fsa2xnL3JMaXUwcXdK?=
 =?utf-8?B?R2R1UTVhVGFUeHhtc2ZCbmJ2aE1URy9UbHRiWHc0b2c0NThDbTk1S0FVb3hF?=
 =?utf-8?B?bmF2SjNDN1lCSkNvNzA3TVBFSUdOU3c3TkhhdkozRUZTOGxrTm5SNWpxZmUw?=
 =?utf-8?B?WXc5RGcvYXdQS2ZTUTZ1SFVwcDVRUVZRYnkxTnFwc1JBSVozdUp4ZmdEQjZ4?=
 =?utf-8?B?SERGWEszdVpXS3o3Rzhyc1k2VlIyM1JDN2UrRlhQK3k1VUo2d04vQlJOeEVN?=
 =?utf-8?B?Q1JwUDA1cW80aGZjS3hWSjhaL2ZXL0FWckluSXJaRG91elFMNHpCSjRyUU1P?=
 =?utf-8?B?YlRWdmcyb2N4YnhFZ0s3bkpWNUJ6Q1hjL2lBOUFnbytIYUtnVCtadmZEdEVw?=
 =?utf-8?B?VnN5d2dXUWQ5WGc3TWRVLzBmSGtnc0F6Mis4anhxYmlyZTIwNXlkRmlDQ0o4?=
 =?utf-8?B?MnpWNW5xQjROYTNKNUxaN050S2djQVp6WHpNc2hlVjYyMWR5b3QzVHhrcGVJ?=
 =?utf-8?B?TmYxQU1DWnlXMWFXaDI5UEtjWjE5Z3plQ3YxeGdIcnpxV2dNOExiVVp3VFIv?=
 =?utf-8?B?RXQ4TVRMblJKcHRPU0t0YWNPODFwcWtZeUFLYmY3VnlxOG42OEUweVNPZFRB?=
 =?utf-8?B?WUtnOGFiVGVPSnRUamxsNm1yR2I1bHdZYWM3bHRiRVRDbjgrM3kzeFVMVFFK?=
 =?utf-8?B?ajdIUXNFMFhPNFY1L2M0eXlzREJzdzVlcC9LdEJGK1VUNHZVaitXcXdYWUlH?=
 =?utf-8?B?Q3ZjTzhnN1VNdWtuYmFvT0Zaa3hLMmpPd2xRSzF2RzVpU05ROFpRK1UrekF5?=
 =?utf-8?B?M3lpTWx0YnpiY3pCbkdpWW1xVk9uV0VkV0svdjI4WUV3ZEJyQ2VPN1ZsVjI1?=
 =?utf-8?B?SXhMZW4vb2RVdlcwbWRFV2xzeFZNeFNMUVZYUS9nR04xaHIwSGQyTk5wWGJW?=
 =?utf-8?B?bjZ1Nys1eGVEQ0Y1OUt3V2pYeVduV0t6YUlUY2tnaFRvVHRQMkxjb2tIN1M0?=
 =?utf-8?B?bXozaUI2WXltOGZ5WEMrdXRid2oyd2ZJMms1T2FtNUlyK01HS3BIOURMTGl0?=
 =?utf-8?Q?VnYXepaXs7OABF8GZSM8YFSID?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a8916f-a9fc-423a-08cc-08dda2b52897
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 15:41:51.2204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzMXWpo+Q1WrrNbKGClR8qx4WZzripVPxqhWR16UgywMxwZh1icYXU2YWBd/SsDMdE7fc+shzadkG4oX3ArfPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6395

On 5/19/25 18:57, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding needs to be enabled on SNP_INIT_EX.
> 
> Add new argument to sev_platform_init_args to allow KVM module to
> specify during SNP initialization if CipherTextHiding feature is
> to be enabled and the maximum ASID usable for an SEV-SNP guest
> when CipherTextHiding feature is enabled.
> 
> Add new API interface to indicate if SEV-SNP CipherTextHiding
> feature is supported by SEV firmware and additionally if
> CipherTextHiding feature is enabled in the Platform BIOS.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 30 +++++++++++++++++++++++++++---
>  include/linux/psp-sev.h      | 15 +++++++++++++--
>  2 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b642f1183b8b..185668477182 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1074,6 +1074,24 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +bool sev_is_snp_ciphertext_hiding_supported(void)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +
> +	sev = psp->sev_data;

This needs a check for !psp and !psp->sev_data before de-referencing them.

> +
> +	/*
> +	 * Feature information indicates if CipherTextHiding feature is
> +	 * supported by the SEV firmware and additionally platform status
> +	 * indicates if CipherTextHiding feature is enabled in the
> +	 * Platform BIOS.
> +	 */
> +	return ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +	    sev->snp_plat_status.ciphertext_hiding_cap);

Alignment.

> +}
> +EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
> +
>  static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
>  {
>  	struct sev_data_snp_feature_info snp_feat_info;
> @@ -1167,7 +1185,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> -static int __sev_snp_init_locked(int *error)
> +static int __sev_snp_init_locked(int *error, unsigned int snp_max_snp_asid)

s/snp_max_snp_asid/max_snp_asid/

>  {
>  	struct psp_device *psp = psp_master;
>  	struct sev_data_snp_init_ex data;
> @@ -1228,6 +1246,12 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		memset(&data, 0, sizeof(data));
> +
> +		if (snp_max_snp_asid) {
> +			data.ciphertext_hiding_en = 1;
> +			data.max_snp_asid = snp_max_snp_asid;
> +		}
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> @@ -1412,7 +1436,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> -	rc = __sev_snp_init_locked(&args->error);
> +	rc = __sev_snp_init_locked(&args->error, args->snp_max_snp_asid);
>  	if (rc && rc != -ENODEV)
>  		return rc;
>  
> @@ -1495,7 +1519,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>  {
>  	int error, rc;
>  
> -	rc = __sev_snp_init_locked(&error);
> +	rc = __sev_snp_init_locked(&error, 0);
>  	if (rc) {
>  		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  		return rc;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0149d4a6aceb..66fecd0c0f88 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -746,10 +746,13 @@ struct sev_data_snp_guest_request {
>  struct sev_data_snp_init_ex {
>  	u32 init_rmp:1;
>  	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 rsvd:28;
>  	u32 rsvd1;
>  	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>  } __packed;
>  
>  /**
> @@ -798,10 +801,13 @@ struct sev_data_snp_shutdown_ex {
>   * @probe: True if this is being called as part of CCP module probe, which
>   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>   *  unless psp_init_on_probe module param is set
> + *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if

Only a single space between the "*" and the "@"

s/snp_max_snp_asid/max_snp_asid/

> + *  CipherTextHiding feature is to be enabled
>   */
>  struct sev_platform_init_args {
>  	int error;
>  	bool probe;
> +	unsigned int snp_max_snp_asid;

s/snp_max_snp_asid/max_snp_asid/

Thanks,
Tom

>  };
>  
>  /**
> @@ -841,6 +847,8 @@ struct snp_feature_info {
>  	u32 edx;
>  } __packed;
>  
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> @@ -984,6 +992,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
> +bool sev_is_snp_ciphertext_hiding_supported(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1020,6 +1029,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>  
>  static inline void sev_platform_shutdown(void) { }
>  
> +static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

