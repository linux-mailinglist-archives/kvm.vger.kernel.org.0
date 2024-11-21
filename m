Return-Path: <kvm+bounces-32245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 997D29D488F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 09:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B30E282E3F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 08:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971A61CB30B;
	Thu, 21 Nov 2024 08:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="vqUR5aw8"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022110.outbound.protection.outlook.com [40.93.195.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73AA1CACE9
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 08:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732176676; cv=fail; b=Y0EUNeAgI9ELx+p+1RBe+6C1Dymh8OVse10Odng52TVeZNbwER7u/JBRVAqea2LfBb18xD29PmGIQpjZsvifRgNbMgT7q9MCTaXJ8n9fqqtd2qJOsc9zaNBkxr0uPY9X3H+TTkaKdkeLGk9DE3NDvXt9tAuu5Pbvw8D1xxejc2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732176676; c=relaxed/simple;
	bh=E1DkzalBTOzROh2W2SvrGe8QA9WdqGaWd+74IZEkt10=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SWrqMYHQAPfoV9bVDsOwBTlQL8DwH8Sl8U7au73K5E4a3n7pSQSssEDNZibIeZ63kk4vJTMN+JRNyhzxmj6i4EicDsCKrYqm1ApWrrBvWTijQ1wui+U3tUU83+87lXZXjfloN+2+0t0pgWrYNVWJK1wHeTwGU9MfI3HHKZiQH0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=vqUR5aw8; arc=fail smtp.client-ip=40.93.195.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=so6szRFrEODvieTSLz+kId2s2+HZslfWs3VWRnqj7u3Yi2vvlJ3ca7r3Di8h5QiCBvXz+gBwDyIK80abP+0r4Iy5yTk4qbNb1Qs8IRJ94FqlUQ4JobQaay6cyUG5RYNOZd3K9IdMDNcD2znnGpwk8VRQlQ8/nBOkKQPYa798Mjah4h6exuLZ0Cl2eklxaSZW3wnJqLQFuq/Oy2gs1em+JkppowMQVOhpiuFNZDvKlLHorNrfsrqAElXN3N1k9whodzgIXmUePIVvJu3amkcix/Hg91bo6kp47Pps2BpXQOdNr2ea7ZtnYFVrt8fRet0Pmx0WxhhVetXbly/T8R6tGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3t/+UQflSFs8dsgctIV0+OLRz3ub8mvxR7E2UsdQW+E=;
 b=hcHtUZURAlMXeOETGagQphpREzcJSBh/oOLHaP8xlTI7ojWP0YrlAYjMli//lXHuD47cP/qImv2//IrZJuGSTc22LLCndxNef8mLvyPXcROot24JbuD7+HCOncNkWmj15Fqil75Wwdww3vkbKtEgAPAJGIrv43wUrm6v4Lbob63/TFxYoAnz0UrPQ87dG7OizlAtPo+Fj+TMQycKNj/jvJPju+i5jQjnZXHI6mdmfir22TypR7MNcsXwx99Z7PqfH6GkWgjfRzabI12qGbdVqUcQU15SI3bEzw/qH9z6ACWta4FuaFfv5B6QLphoeyWtcUNvt14VY/NIIhidakOLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3t/+UQflSFs8dsgctIV0+OLRz3ub8mvxR7E2UsdQW+E=;
 b=vqUR5aw89wryCXi5xjQwdGWGV4OvNlBYmQzyAiOaVl/nVGcYf2VQgiapUzw/Va0/nJaB3Hj0W8tu//+V9ku1Z1ogDA1MA5lWVBJ5O5fPrqg1WQXtjlhyYr5pSMkgzQjY4qpVO/E/na2j/SdBxZZiR53XytqX4QdPXfBj5stK5f0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BY3PR01MB6612.prod.exchangelabs.com (2603:10b6:a03:355::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.14; Thu, 21 Nov 2024 08:11:08 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.8182.011; Thu, 21 Nov 2024
 08:11:08 +0000
Message-ID: <46bea470-3a3b-4dcc-b4a8-a74830c66774@os.amperecomputing.com>
Date: Thu, 21 Nov 2024 13:41:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/16] KVM: arm64: nv: Shadow stage-2 page table
 handling
To: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240614144552.2773592-1-maz@kernel.org>
 <171878647493.242213.9111337124987897859.b4-ty@linux.dev>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <171878647493.242213.9111337124987897859.b4-ty@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BY3PR01MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: c0836897-e8a6-485d-e32d-08dd0a040d84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0JYaW10TEt5amlQUTZLTXZyMk9KUlkwaDBLMDFKajVwOHdjUkZFS2dmSDlZ?=
 =?utf-8?B?bVNmSDQzc3VGcHdrdjNsMEpIZlZKS3dIcVdiU3F5enJ5clVkektrYkRPZWVG?=
 =?utf-8?B?VjB2K3c3RGlJejhESGNBMUMxSDFRUDYvcjhCSW9KOER1bXU4UWhtOURzcDQ3?=
 =?utf-8?B?U1ZKblNJOStSVlJaWVpGZzVQYjFvaHk4OVF1emQ1amF3d05ONkNJRTEra081?=
 =?utf-8?B?ZFp2TS9xNW9UdXZ0aTJ2TUZMSjZCamJOaVBIek1TYXdSMzhCdW9pblBkdWRn?=
 =?utf-8?B?Mjd3VEprVDJPbC81TjRFRTdlakJrMkZHeUhCSlBGQTlYTGdtdWdHTFpzcWJ6?=
 =?utf-8?B?Sk9xQnZuRnJ0N1RZbkdUL1BqakVxS0JsNys3YzMzRGg5VkdHRlVMdG1aQ1or?=
 =?utf-8?B?WWJOOGRHNXFkb29XYUVWMG5lTzB1bXZwYmVRYjdUQXVHa241ZnFpb3NRbVVy?=
 =?utf-8?B?SmdmeFdWcCs0c2sraWpoc1ZNUWN3a0d1OUhGN21pYU8yQ01qZDQ0VjRyRTM2?=
 =?utf-8?B?YXlqTUpvNHRmN1pxL0tDOGRwbHhoZmNyaU1UTkl0c0sxanRibVdRZy9xV1hm?=
 =?utf-8?B?QWIxb09sMGQ5QVIvSmlIbVNNK0NWVE42Z2JLVXdtQzlnWGphandqZjZtN2RC?=
 =?utf-8?B?SjdubUFOdnY2dGRzZzlNdytSaE81TEJNcUpJYUQ4Uy9WMkZ6K1E1UHFmZEk3?=
 =?utf-8?B?Q0QyZUt6S3RhSHVDZEErQlFubVdkOTg1OVVWc1NEdVU3SFo2VWtBMjd0TFJk?=
 =?utf-8?B?bnRRb3h5MVFYekpEREpVQ01SRzdaSXdUVEY2cHdDRXc1Y2NnT2FpUEgzRnZO?=
 =?utf-8?B?K1NIVHlQaHZsM2Q5NGRoNk5sQko2eU9JS2FhUFc1MUFrcDdmWUxNVTdQR1BP?=
 =?utf-8?B?bDB4ZHRCWWl4K2Q2N1RhOTdnUWhkSXVSUFVFZU15SEsySlBHYk4vM1pvU1lQ?=
 =?utf-8?B?YnlYTXNiT0ZkdGsvUzQvaVkvckltaTY3SndSekJIQW9FN0tESjkzN3V2QzdU?=
 =?utf-8?B?WHduK1EydlZMUHVxZGtkQldxemNIakpjY1FaNnhyS1Y3eHB0ei9wOWtjNlRt?=
 =?utf-8?B?L0orSDN2S1RXczJtNi9kNkJtUUY2UjExemNmUE9TQlVWMnF2ejV3WDJNZTAv?=
 =?utf-8?B?Qmg4Ukg0YmdWM0F2T0FIUGRaYXZuV0U5aWU5T0tIc1FEOVFZa2Q1VjdsY2dr?=
 =?utf-8?B?NWVYbEJ1VWZWL2xId0lVZE5QZ2ovWktGcEQyWCtrNHNMTkxOVUJxcWJtSVdR?=
 =?utf-8?B?WXRPcmVzdGFhakI0MVlIYWtqb2pYSmtXUVRieFhCaEFLOHJHSG5CYS9uMTZD?=
 =?utf-8?B?UUxnYUVTZkpOR2tGa0J2WHRzT2pZS2tSV01TT1JKWWJKUXJXSk9pTThadlVU?=
 =?utf-8?B?OGoxai82RXZZY3FHc1U1OVBHTGFLV1dES3ZhbDVTd01lTW9ONDF6OVhPTDNY?=
 =?utf-8?B?OEM1Y0M3bHB3U1hEWE1nY1lmMGVINGlXMGxleW1kYXU5Y0pXajQ0NlpZaVFu?=
 =?utf-8?B?S1RTTWE1cDRxMzl4OUEyMzBtM2V4cHY3Q0FxRFg1SWgvSmhYeUNmdkN5ZkJn?=
 =?utf-8?B?dllQVTFzWFN4NmQ3QWxzclJSNHJBY3ZuRGErRTNTUU90V1BQNDlycWZIRXdy?=
 =?utf-8?B?YkZVTjErSndscG9FRlMvbGlOMmhUOVh5T2duRFc1YldKQ0V0Vk9QVTdJdkl1?=
 =?utf-8?B?bmdaVkY2cVl6RzdhNTJBdGlXbkNzMUxqYW9EQXFtdXhvd0haR0hSWlZrMlhq?=
 =?utf-8?Q?IZgiJ6EFEuFObB0Wi/Jm1L97lZjTPTnlEWmtKrU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0U4VDExR3J3RnFUdlAwTDFjemEwaDc5VENUYWkxalFwbVF2V0hhbjA0TDJW?=
 =?utf-8?B?U1ozOEtyaUh1L1gyVERRSTg0WWNuczMxc25QNVF6anRhNDRvZWhOUUw0eWps?=
 =?utf-8?B?dEZNditaNkE3Ukp1UTdjRmhYSkEyYlpoVkdOcXVqVTBheStkNGNhOWZkZ0hv?=
 =?utf-8?B?SUFIKzhidnQ3ck9hLzJ0b1FQRStYa0VYZXB0L3BIYVArbHVvYkdEZzNwcGVO?=
 =?utf-8?B?ckRONUVDbmEvcEZubWR5aHBrMHQvakR3MFU5K1FSYzBiQ0p3VDYyQkR5NHRN?=
 =?utf-8?B?NmpKNDFMTVFjaXowdjQ2ZW5Mcm0rdnhkZ2pNWHQyamg1VFNTazZueU9jUDZ3?=
 =?utf-8?B?T0wreXFVcGYzaFFOc2lYZmRBd1lDRzdId0hyZmFGOTJXU05vcm1oUVAweTlm?=
 =?utf-8?B?L3czMDFyQTludEsrVk5FeHRNa0dHbml6UFplYjBYbFRlV3hnNXhxbTNhVDhK?=
 =?utf-8?B?NytoQk9EdW1idXRtL0EvZHU4cWxObXlCbUdSK05UR1UyNVJPNW0zZVQ2L3JC?=
 =?utf-8?B?RGZXYW1wb20zWTRUVWJKbkY0am5qRjZVUldmK1QvREZHNitOK1kxaUoxVVFj?=
 =?utf-8?B?NUZvZ1ZZMEVLVzF3YzRlc3RSWCtHZUJ1SUhpRHJzMXRhcXhBMDZtV1l5Rzli?=
 =?utf-8?B?SUFWMWtWRFp2SndyclI5UTdBMG90bUJhcXFDZnlvN1cwV0FrSnhGb0EzOGNp?=
 =?utf-8?B?QWczZjR4WVU4ZHMrTkp6WmkzMktHdXk4S1V5TlFNQUp5SERXU2wyaGtKTXVI?=
 =?utf-8?B?VkFObnA4ekNLNWxKL3pxYVluL0JCZHRPRm01NHg1REVIVzhyRHpYZlhMYStX?=
 =?utf-8?B?VWlNUHRnWHp5RTdudEQ4aUFjQklUblVMclE1cUlaR1M3MVhUcytyWUhSSjE4?=
 =?utf-8?B?YTVtb0VMd3V2aXZxRWlJS2l4dGY4YmlrT0xNdWJ5cEhGbkxzU1M5UkdWQkxL?=
 =?utf-8?B?WVBmbDBPLzBadDVlcnNmWjBuSzE4Wkt2cWVGN25uNVhyV0NOZkdjWGNIWWxY?=
 =?utf-8?B?a051VkliZkRib3pIZk1Ib2JRMCs5ZWcvd093UnFGdVl3T3lVeVpycVJUclJM?=
 =?utf-8?B?TDhuamd2cVB6ME10dHpHdGdxcXZuZXBhWHVBajB0WUZNMEtYNXJrcTM3eS81?=
 =?utf-8?B?Wi9UYjJ3cEVkQ2o4ckpkMElEQy9QTHMwRm9sVkU1cHpxcll2V25Rak9PaU9Q?=
 =?utf-8?B?ZmczTGJkY0llaWlCYjdmcmJ4NHlBbzVqYjdtYlJML2gxc1BvSVNsYTlnMnlI?=
 =?utf-8?B?bzM3U2Jnb1ZIanljR2xpbkxNOWtSdWtQOE14Rk56VzljWERsOVdQZXR0QTlQ?=
 =?utf-8?B?eFFwanVubDk3d3hway9yM1RqWWZ2VGV6dy80REF6MWh1OUR4MXh4U0VUb1hE?=
 =?utf-8?B?TDVhcngrQ3hzc2NXNkh2bDhjZEc0blpmTEtuRFYvVWpKUVpPV2pZTTRRZzd4?=
 =?utf-8?B?SFAxZlNDelVKL082Y1NDeHBvU1lqZ21Nd2dSSDJvMnRDNTJISFNTditMVVZi?=
 =?utf-8?B?TVA5bGQ5dUIyQTJuM3MxcUduV3VNMjRSR0FjUWd2N0Q0VFgvNWhySzlzNTh2?=
 =?utf-8?B?cDhxQllNcWhkR3hDRlBrNVNXRUh3bkVrWVFiZnNmREZ5REdNVStYSmFEOWdG?=
 =?utf-8?B?K3F4UUhaU3dHd1pTQkE1K3daUlJrem9GV01EVlJnWFZ0VldJSXRYS2dLcHpu?=
 =?utf-8?B?eTNTcWg5ejIxN01IS1kzS1RjRWVGUVBmNjJqZVY2MWk5c29OZ1lXZFBJeG03?=
 =?utf-8?B?VnllUU9HUVJHdkdLVXpxZG9ZeVRocTc4OGNvVGNEa3FmeW9waW0zRlIyNXFW?=
 =?utf-8?B?Yi9TSEpXQ21CdXhHZUJNL0lXcEU1RUtqaElWVlVGMzdiUWRSWDZBYVd0TkF6?=
 =?utf-8?B?TmZBbjk1dGFjaWcvT3J6RHRHVjc3aXo4OFF5NGRUbFQyd3p4bE5NWkt5NWlr?=
 =?utf-8?B?WnVEb2dQOUtEMVJUK29HdnNsdHJKUHRtSlBIbDBVcUoyWWhhL0p6QjdYYXJP?=
 =?utf-8?B?NXErbVBvZUtvRW1zMysrNjRnTDdvV2h6ck5XQ1p4Y3gxNldwQTYyNVg1WE5h?=
 =?utf-8?B?Tmw2aTQzNGlEYTlPZDRUM1k0MW1XUkJJRzNlbzhKTkJHNVZDYjJ1VGNna1pm?=
 =?utf-8?B?UEJHay90cmg5MGxxNlFuaTlBYXFzdnRJblBIUTRJdmdxam9WbmJscUdsSHh3?=
 =?utf-8?Q?0MwgqXUEpw1Zxio9t/8F1ok=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0836897-e8a6-485d-e32d-08dd0a040d84
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 08:11:08.0704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jn8xqHtjuNadYxJMm0fLc3z+1qr85TI+dZk3T3Qzk6EQeZOTKtykq4+7uly3s18LHJD07KueEi8Sp1tm3QEd6jNw1yqe67gi9u2xZt1r+RB9PVZELBptonHCXun12ixe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6612


Hi Marc,

On 19-06-2024 02:11 pm, Oliver Upton wrote:
> On Fri, 14 Jun 2024 15:45:36 +0100, Marc Zyngier wrote:
>> Here's the thurd version of the shadow stage-2 handling for NV
>> support on arm64.
>>
>> * From v2 [2]
>>
>>    - Simplified the S2 walker by dropping a bunch of redundant
>>      fields from the walker info structure
>>
>> [...]
> 
> Applied to kvmarm/next, thanks!
> 
> [01/16] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>          https://git.kernel.org/kvmarm/kvmarm/c/4f128f8e1aaa
> [02/16] KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>          https://git.kernel.org/kvmarm/kvmarm/c/61e30b9eef7f
> [03/16] KVM: arm64: nv: Handle shadow stage 2 page faults
>          https://git.kernel.org/kvmarm/kvmarm/c/fd276e71d1e7
> [04/16] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>          https://git.kernel.org/kvmarm/kvmarm/c/ec14c272408a
> [05/16] KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
>          https://git.kernel.org/kvmarm/kvmarm/c/82e86326ec58
> [06/16] KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
>          https://git.kernel.org/kvmarm/kvmarm/c/67fda56e76da
> [07/16] KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
>          https://git.kernel.org/kvmarm/kvmarm/c/8e236efa4cd2
> [08/16] KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
>          https://git.kernel.org/kvmarm/kvmarm/c/e6c9a3015ff2
> [09/16] KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
>          https://git.kernel.org/kvmarm/kvmarm/c/5cfb6cec62f2
> [10/16] KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
>          https://git.kernel.org/kvmarm/kvmarm/c/70109bcd701e
> [11/16] KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
>          https://git.kernel.org/kvmarm/kvmarm/c/d1de1576dc21
> [12/16] KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
>          https://git.kernel.org/kvmarm/kvmarm/c/b1a3a94812b9
> [13/16] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
>          https://git.kernel.org/kvmarm/kvmarm/c/809b2e6013a5
> [14/16] KVM: arm64: nv: Add handling of outer-shareable TLBI operations
>          https://git.kernel.org/kvmarm/kvmarm/c/0cb8aae22676
> [15/16] KVM: arm64: nv: Add handling of range-based TLBI operations
>          https://git.kernel.org/kvmarm/kvmarm/c/5d476ca57d7d
> [16/16] KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations
>          https://git.kernel.org/kvmarm/kvmarm/c/0feec7769a63
> 
> --
> Best,
> Oliver

IIRC, Most of the patches that are specific to NV have been merged 
upstream. However I do see that, some of the vGIC and Timer related 
patches are still in your private NV repository. Can these patches be 
prioritized to upstream, so that we can have have the first working 
version of NV on mainline.

-- 
Thanks,
Ganapat/GK

