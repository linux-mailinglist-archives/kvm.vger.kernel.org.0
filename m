Return-Path: <kvm+bounces-50411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14390AE4DC1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 21:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 730977AA375
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 19:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93D12D4B68;
	Mon, 23 Jun 2025 19:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BduQMLoi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B781EEA3C;
	Mon, 23 Jun 2025 19:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750708213; cv=fail; b=OFuQg3CW/37lq+Nu9cOiMX584qZtAgblNp2VIKhC4DWWhEnJiZpbOUBTuQ4L3CtgNgjBEeNAK5C6CjU7vSDuKEO+pwnfCmW86odh5+zSPpdFjBMEio7gy0lI3laCDlNjAew2l7G0Aw511x6PRYoN20V4E8wOEXzWdUZQXm7aQdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750708213; c=relaxed/simple;
	bh=BgLYID1IZinTcYZ9v4AF87lBjwYjSJiwqqD5YhfYrt0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A4YvdXhOngP18ie9jTXVUPApFiL76FZMAbn8Zl51hHQRufXHWCDTtkt5VtBvpdOhF6IuJzyiEwiMkX1J+dJi4tQPAA6Y8l3+mkEx5R35B+aj+8skc8vxJFz3F67IxPW88bnzVUe4uEJPFjsRVEMqv4a7I8VgmVAPJyuSg3Gx9Dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BduQMLoi; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TifefiapYiigVBFLN/5pDSErYOt7KmsQqWrEa/1TrFUNiTK9GOZph3s2jMW9gzcCvD8q1umASlIUhuT+mGL8IE5xclyo9YcNMMywX4/ysCEKWDJxt7ujCRvF0m5OxkYblMXwafmxQB2/g0jopD8tq3SYBCzzUxReVgjCKSBiFZaYobImD/OB5UqhHVgeUeYPeTdVfwoa+xcprtKTiZmG7uMBNDHtUeusgNIP4v9KT1WtWz53G0/fdAyZnE9UcjQT5/RWhmQgv4r0o2rmEBc5UODGFpIfxRWkQHeAheQF8JWW8nP0WNk8NuEW9ZWFA0IFBgGA83FrpjexbQLtbrz1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHrcJuFDFjAr2prRmlQ8rwHg6ERB/vhlsdcaRkZH4Sk=;
 b=ySw3o8lK7UasjAw9mrjGKIpIHjOfNQE5ZpFeZ3ZUSDv5BMBmURoax5MBQFnInr4CdkmPe9yFXSxN+DY4ljdPae4vAjuMdW7sYld4zqcf8AwA76NzRERe+2KXbIdeutZBu3YmIQ2X+x68OjYjSl6sTICjp8C8h0pH+VXvRorYP3Ekem9csLjel6Xm1ebqKVCJ3LR/svfs/zrH94h98yUxOKLBOLCMyNudCV9pA1MMEVYxBX7OmvxeJCePURpkEiboUorIREJjH628uABeo02wwggktBsKEzLBq5dJ3KD8U15dYdCi4i7/o5I0o6uE+18UWhGQNxqSvzYOC9hEcz+sjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHrcJuFDFjAr2prRmlQ8rwHg6ERB/vhlsdcaRkZH4Sk=;
 b=BduQMLoiPsiC4R8Wy5Vkj2YVX2HWvUFaA9yKc7buKpA0UDXBO68yPKNJ2X4VaEOuY405mcgzeWweYpKPNd/sG57KyYZxzP5eoP6b1OVVSuZS0TflXHONqm4fQuToz1WSRUiPAkzMX5g6NSVcvJs9RFBj3ic5yWoYsgV24sToSTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9079.namprd12.prod.outlook.com (2603:10b6:610:1a1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Mon, 23 Jun
 2025 19:50:10 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Mon, 23 Jun 2025
 19:50:09 +0000
Message-ID: <6f5af820-5ccf-92e6-1acd-b87aef9885e6@amd.com>
Date: Mon, 23 Jun 2025 14:50:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH 06/24] KVM: SEV: Track ASID->vCPU instead of
 ASID->VMCB
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>, x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-7-yosry.ahmed@linux.dev>
 <aFXrFKvZcJ3dN4k_@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <aFXrFKvZcJ3dN4k_@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0014.namprd12.prod.outlook.com
 (2603:10b6:806:6f::19) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9079:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a492cef-8c55-4661-e509-08ddb28f2927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckF0SVZvYldFRHlZcFRnZExhSVBSbkVuUkNVM1o2Rjl5Q3R2eEpTL1dFbnNy?=
 =?utf-8?B?MFluMXJPNW1MaHV5bnZzdXg2S2JYTEpQeWlUMnBOSkU5aTZLZW90NHNwRFVR?=
 =?utf-8?B?UUlud0kzVndqb3h2NzRWWS9OeDV5YVlpc2JDUGN1Kzd6QWhGSmplRnN3a0NL?=
 =?utf-8?B?MGZ6Sm1EZ1pCK0gyZk4vTVpnVy9YdDdYaW43MTlJTzVjYTh2RkZDcUo4U3li?=
 =?utf-8?B?QU4wbGtlQVpNT25jSmRMaU02MFI2dVNYQ0pGR0kzRkx2eXpTcU56MWJ2QnFr?=
 =?utf-8?B?NUhMZ054bjRIV0lhcXIrbjFJTzR3cmt3NzNuK2tqY1RCWDVEdVo4VXZ3WDBC?=
 =?utf-8?B?M3QxR1FFYkFzQ2RMQU9Mam9sWmRkYk5pNEZMdHcxQVNkWm9oOHZNL2FNcnVI?=
 =?utf-8?B?K2JWNUxlRGRDT0FhNzBFeXl3U1dXSGpBb3NPK0JRaHZsdnN2bTFRZUZ1TFc1?=
 =?utf-8?B?Um5ub2s5VnIwQWw4anY3ZjhEL1ZrZ3RNS0lWRDZzdm9nSHQxdGdDRlByNVlK?=
 =?utf-8?B?TXZ6d0o4bEV4Q2hjK3ZPa0J6TE5vcWNMc0RKVFNrc2JoYVMxanhSeE1lUjVL?=
 =?utf-8?B?dUx2V3BPQ29GaXZwcUFpeS81OVNWMlRJMk1sSFNDdnJHUmJnZForaVRNUU9J?=
 =?utf-8?B?c1Zab05EWnhrUjZPWm9GMjdCbTFhQ2lZdTI3dURwQitMaS9HMk5DVkRPcDg3?=
 =?utf-8?B?ZlN1cGZLTHFGYk9Pdnp0V2dDVlJDQWlsMFdteEpVK0JsMXF1enRXMnVDY2xa?=
 =?utf-8?B?bFRDOTMrSnVJa1Z0L2l0UFZUNm1teGttNWl5Q0xOWTNMejI4TDJyQlE0aExm?=
 =?utf-8?B?UHVnMTIzeFZVem90c2x6L2NIMVV6UkJjNmlmQi9jZHJiNFlEQnlaTGhxOTla?=
 =?utf-8?B?QUR2TEFtVnk5M1VqQXhxRHd4R2tnQWlVeFN3U1BHR0ptcFNGRFBEd0JwaUx2?=
 =?utf-8?B?MG4yclQ2M3liYnI1eXVjUTk5c1A2L3NyaU5COTNRbkxXSkZ6Mm1DTlczRWdC?=
 =?utf-8?B?V1l5NHY1Z1c2OTdOVThnWHpZRk53a0xVVW1DSG12Rk1YUTEycUk4emZ5N20r?=
 =?utf-8?B?blF4TFZUWDFJZDhoTDNCL0k0dVF3T09FRG9TaGp5dzNJcUhhZlUzZmFwK0h5?=
 =?utf-8?B?OFlHRDVyRmZUZ1ZYdEp6b291WWtvczNIUm9wUzU5WWVUS2FvK0tlYWJBd256?=
 =?utf-8?B?NGI3RW1qRjJ3dHhQaGJsODdnN3duWXNobmJmRFdBWC9KbTN0MTBtSGZxaWNj?=
 =?utf-8?B?K1I3dkNuYWE3TDBqNE5qaVpqMDYrUStsVWZBR0xRMHRyWUZ3aVZsVVNTcUxw?=
 =?utf-8?B?RHo1amlpZ0hDSzlDU2xwT05mRDNSYWI4SGJ0ZWVTaXZhVlQwY3AwaVI0eTRD?=
 =?utf-8?B?ZHZHbTMzVFFxVTV5Z2htRmFrUUs5Q2FQKy8vSFlaY2E3SlFHeTZSS3Y5TkRa?=
 =?utf-8?B?UHpuUkJHWDVpKzJGVjYwRkxHTTdyTklwUStmRWtmeEp6SkhaeFA4SDI3a1Vi?=
 =?utf-8?B?aUFLY0JDdTFFT2pycjBseDlSRjdDOWZBMTVENElWSlNyYjJTcWNjRXVYczBi?=
 =?utf-8?B?U3B1RkRMc0VpODBjcmVpbnYyZ0xYRjA5M3JyZVJOUzU1ZmRTKzIrTnVOWTZ1?=
 =?utf-8?B?SFErZElEMUptbzJyaThQbDJRYlJVdUdoNmd0Z1FEN2J3WTgvdUE2TWR6ajBm?=
 =?utf-8?B?Rk52dlBLS0ZQQU9XSm9Zb3BOSGFRRW9vU1cySmxPQkRvVjBzaXJLeEhOZXFu?=
 =?utf-8?B?QUdZL09zenJJMU1XRzBnS1ZKSkZmanptMUVtWjdLdkhEbVhoK1EzOUE0ekhC?=
 =?utf-8?B?Zm8wOWxBT05tOXNtcERrbDVqbThnL3ZQZVF3TEVrTHVnNE1PVUJxU3lqcDlD?=
 =?utf-8?B?UXYyZkhTZElYQmxhbmtzamJqTzNCK1l0L3M4TlRXZEZaaFZ5eFR6WmdYSlFk?=
 =?utf-8?Q?NOaG5CNKmrY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2RtVlNtSFZPN21rN1JBNEEyYVk5NUtJb2wrVnN4dmpWQTV6MHkvbUI3OWVu?=
 =?utf-8?B?VzVTNkU3Vm5mMlpGQkJtVVFtQmovOTZUUlFNSUFPQm1YOGlYcTZuU3diSVBI?=
 =?utf-8?B?cGxIUUFKa0oreEhsc05mbVBkc2Q5RVVhZmJFQlZycUN2eW9rR2k0ejRzanBq?=
 =?utf-8?B?UFM2TUx0M1VwMklRY1BMNXRGM0gwVTRHUnk0bHNxN0FoZU1oOGFqUHpSK1NC?=
 =?utf-8?B?d0lESVpzciswNXRUVzQxMkdaemNGN2ZNU0hMc1FFUFdsQlhtWU9YSFo1QVZq?=
 =?utf-8?B?L1N0dWVzUzR0Unl2V2dSTXUwQUFyWmRwdi9GeFpJdE1LVmFNVTdCY2dtaGt3?=
 =?utf-8?B?TEtyZFNYWldDdElBU2RycFRJQ2RZTlN0a283RkFxakdiQ2hQc1gxYXVVTy93?=
 =?utf-8?B?dVlYaDdNMWRBc3FjTkFsSDdQWlVaR0R5bHlpZjdrQ1JtTmVmS3VhSURYK0ha?=
 =?utf-8?B?djB4blBFSFMzaTBUYUROamtQTUJHOXU1dGh1ZWV4cStpQmcxdjU0cnMyR1hv?=
 =?utf-8?B?emdNZEROR3dRL1hMWkxvTGptcnVFOExtblQweGIzVWc1c3d5Ync3amtDSG5y?=
 =?utf-8?B?S1JBWTJJbUdxU1pNS2hVaVBSMU1tYk9pLzlEUGRNZEVZOFRkSDRMOUM4aGR3?=
 =?utf-8?B?UmUzT1NFNGgxb1Q2T0IwOWdoOXNLYXpkVTk2dFY5SWpvenlLRDJrcFFXOTRB?=
 =?utf-8?B?ZE54U0hSREw1MG9tbzduc0xGZVBqR1ZLcVZGd1BvV2dSb1dZTER4YWl6M0VW?=
 =?utf-8?B?WVVWTEtQeWpjdXQ2dGFVQ1B1dCtSRmlZT0p1TEc2bU52d1hTMTBLWVJ4M0Ey?=
 =?utf-8?B?MUFxSEZpejlreFMxb1F1cXRObDJ5bFJwMSsweS9GVHExam04aHR6U0MyYnlq?=
 =?utf-8?B?a0ZjanRnQkNaM3RENkZLeWNkR1Jqb3JFOHBMbW0vZUhvTnRrb0pFc00zdDRW?=
 =?utf-8?B?bUNCR0JCUktyVXp4SEtoOEl3VFN1MTd0enRTMXJDMkZoMk9sVVlKUUFpNmwy?=
 =?utf-8?B?dWliQWR3U240cmoyRGtGbEpRU1ZEVVd6WUhmeXc3QXhocmMzbmNyWW1Ob3A0?=
 =?utf-8?B?dFdUcG1sUWkwbEJXb2NaU2pRTFNudytTcTRZWWlybTB5bk5DeTkzaUlyU0ds?=
 =?utf-8?B?MUJzYVJid0NhL2dtNnVmQk5nTURzSXVCWS91RUIyblJBbUFsbFdLL2xiSVpD?=
 =?utf-8?B?QVdRU1FJeG9QT3QrRjQrZVYzVlV0K0lVNWVCMEIyejJGUEREMWVVZThIKzhz?=
 =?utf-8?B?U3VGcWlmZ3cvUXRMaTdVS1BnMC8xaWlyOE4waW1pZHFjNXhxMWZMVVJlN1M4?=
 =?utf-8?B?aUpQc2RBcktJTEZsYTFGMU9sOVNkR25hbTU3aWtabUl4WEpaRDNJelZTREsw?=
 =?utf-8?B?Y3o5UEZDT1NrRXdtRFBBSFRxSDJBT2JzQ1BRekVwTjhzV0ZNSmdBVUlIRUpt?=
 =?utf-8?B?VDdoNHhTRCtnZlZkU1gyb2NxTVRDSUtQY0hvSCtJazU4bnlGYWt5UGRmWXFR?=
 =?utf-8?B?cUpXMlZOMVp2MjZGZVlacE11bDN2YnAyb2VUbXZIQUZaN3VPdy9vRjFocVA2?=
 =?utf-8?B?bTR5UE5yUmI5ZGJMcmRMd0thMVB0QU45NmlRS1FTQ01IVUg1azZRU0hWYWpy?=
 =?utf-8?B?RFhNVGlEcFlVMUpQK1ZVeHlOYy9LL05kS0pJRjYzVGxsMFZuNGdiV0p1bjRt?=
 =?utf-8?B?VHlyNEdtZEM2WHZNaXNXWnNRc3JNL0JQMlRiMXpoLzZtOFRwNW5VQWs2Vlhi?=
 =?utf-8?B?TWN0SW9XUElhZ1lYVmRtUWNKTVM4a29DOFp5d1I1UWpaL3hrdzhRYVhCR2tp?=
 =?utf-8?B?a0RMVFpmUFFHLzFWcldNU2ZYdXN1QmhNajY2RjZCbEtET0J4QnAwUG1LSXVZ?=
 =?utf-8?B?bElOSUtUdkEwcllBQmMvZUI5TGEvT2lNNUJPdmxBeXczbDcvM040TW1Ic0xa?=
 =?utf-8?B?dmQ1cE9xZ2dnQ0RjNTNoeThwSzkzVmZWWmtja0RQallpekVsQ1ltZWJ4Vjhj?=
 =?utf-8?B?RnJHWlA0ai9xTTdJUmViTGZZSS95NWp5Q21ZSTdjYStvaXNpVFpLbWdISWRx?=
 =?utf-8?B?aEZJOWdqTVRURWltakZxQ0FqQk5lZW9uV29nendyQ25PQXM0N1VxYnMzRE5v?=
 =?utf-8?Q?sS0B1ykkpjKIIQndJFJX3Lbwm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a492cef-8c55-4661-e509-08ddb28f2927
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 19:50:09.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eytN0JolHrOLcAOYQR/jucXciMPLzIFa1rXn+6U8R2hzUml6Qs6pbiFOx8y5WRFXcd47MGut7gyHiL7ebjDcOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9079

On 6/20/25 18:13, Sean Christopherson wrote:
> On Wed, Mar 26, 2025, Yosry Ahmed wrote:
>> SEV currently tracks the ASID to VMCB mapping for each physical CPU.
>> This is required to flush the ASID when a new VMCB using the same ASID
>> is run on the same CPU. Practically, there is a single VMCB for each
>> vCPU using SEV. Furthermore, TLB flushes on nested transitions between
>> VMCB01 and VMCB02 are handled separately (see
>> nested_svm_transition_tlb_flush()).
>>
>> In preparation for generalizing the tracking and making the tracking
>> more expensive, start tracking the ASID to vCPU mapping instead. This
>> will allow for the tracking to be moved to a cheaper code path when
>> vCPUs are switched.
>>
>> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
>> ---
>>  arch/x86/kvm/svm/sev.c | 12 ++++++------
>>  arch/x86/kvm/svm/svm.c |  2 +-
>>  arch/x86/kvm/svm/svm.h |  4 ++--
>>  3 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index d613f81addf1c..ddb4d5b211ed7 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -240,7 +240,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>>  
>>  	for_each_possible_cpu(cpu) {
>>  		sd = per_cpu_ptr(&svm_data, cpu);
>> -		sd->sev_vmcbs[sev->asid] = NULL;
>> +		sd->sev_vcpus[sev->asid] = NULL;
>>  	}
>>  
>>  	mutex_unlock(&sev_bitmap_lock);
>> @@ -3081,8 +3081,8 @@ int sev_cpu_init(struct svm_cpu_data *sd)
>>  	if (!sev_enabled)
>>  		return 0;
>>  
>> -	sd->sev_vmcbs = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
>> -	if (!sd->sev_vmcbs)
>> +	sd->sev_vcpus = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
>> +	if (!sd->sev_vcpus)
>>  		return -ENOMEM;
>>  
>>  	return 0;
>> @@ -3471,14 +3471,14 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>>  	/*
>>  	 * Flush guest TLB:
>>  	 *
>> -	 * 1) when different VMCB for the same ASID is to be run on the same host CPU.
>> +	 * 1) when different vCPU for the same ASID is to be run on the same host CPU.
> 
> Tom, can you clarity what an ASID actually tags when NPT is in use?

I ran your questions by David Kaplan and hopefully his responses will
helps clear things up.

> 
> The more I think about all of this, the less it makes sense.  The *entire* point
> of an ASID is to tag TLB entries so that a flush isn't required when running code
> for the same address space.
> 
> The main problem I'm struggling with is that, as usual, the APM doesn't properly
> document anything, and just gives "suggestions" for the VMM.  *sigh*
> 
> As I read it, these snippets from the APM are saying ASIDs tag only GPA=>PA entries
> when NPT is in use.
> 
>   TLB entries are tagged with Address Space Identifier (ASID) bits to distinguish
>   different guest virtual address spaces when shadow page tables are used, or
>   different guest physical address spaces when nested page tables are used. The
>   VMM can choose a software strategy in which it keeps multiple shadow page tables,
>   and/or multiple nested page tables in processors that support nested paging,
>   up-to-date; the VMM can allocate a different ASID for each shadow or nested
>   page table. This allows switching to a new process in a guest under shadow
>   paging (changing CR3 contents), or to a new guest under nested paging (changing
>   nCR3 contents), without flushing the TLBs.
> 
>   Note that because an ASID is associated with the guest's physical address
>   space, it is common across all of the guest's virtual address spaces within a
>   processor. This differs from shadow page tables where ASIDs tag individual
>   guest virtual address spaces. Note also that the same ASID may or may not be
>   associated with the same address space across all processors in a
>   multiprocessor system, for either nested tables or shadow tables; this depends
>   on how the VMM manages ASID assignment.
> 
> But then the "15.16.1 TLB Flush" section says this, without any qualification
> whatsoever that it applies only to shadow paging.
> 
>   A MOV-to-CR3, a task switch that changes CR3, or clearing or setting CR0.PG or
>   bits PGE, PAE, PSE of CR4 affects only the TLB entries belonging to the current
>   ASID, regardless of whether the operation occurred in host or guest mode. The
>   current ASID is 0 when the CPU is not inside a guest context.
> 
> And honestly, tagging only GPA=>PA entries doesn't make any sense, because
> GVA=>GPA needs to be tagged with *something*.  And the APM doesn't say anything
> about caching GPA=>PA translations, only about caching VA=>PA.

VA=>PA translations are always tagged with a TLB tag value.  Outside of
SEV-SNP, the TLB tag value is ASID.

So for those guests, VA=>PA translation are tagged with the ASID.  For
SEV-SNP guests, see below.

> 
> The thing that doesn't fit is that SEV+ uses ASIDs on a per-VM basis.  I suggested
> per-VM ASIDs for all VM types based solely on that fact, but now I'm wondering if
> it's SEV+ that crazy and broken.  Because if ASIDs also tag GVA=>GPA, then SEV has
> a massive architectural security hole, e.g. a malicious hypervisor can coerce the
> CPU into using a stale GVA=>GPA TLB entry by switching vCPUs and letting guest
> process with CR3=x access memory for guest process with CR3=y.  But again, if
> ASIDs don't tag GVA=>GPA, then what provides isolation between vCPUs!?!?!

No.

For SEV/SEV-ES guests, the HV (which remains partially trusted) must do a
TLB flush before running a different VMCB of the same guest, in order to
avoid this problem. This code is in pre_sev_run().

For SEV-SNP guests, this is handled automatically by hardware through the
PCPU_ID and TLB_ID VMSA fields (documented somewhat in APM 15.36.15).

In short, the TLB is tagged with {TLB_ID, ASID} and TLB_ID is managed by
HW and guaranteed to be different for each vCPU of the guest running on a
physical core. This ensures that the TLB tag is unique for each guest and
for each vCPU of the guest.

> 
> Assuming ASIDs tag VA=>PA (i.e. the combined GVA=>GPA=>PA translation), then I
> take back my suggestion to use per-VM ASIDs, and instead propose we treat ASIDs
> like VPIDs, i.e. use per-vCPU ASIDs (well, technically per-VMCB, because nested).
> All server SKUs I've checked (Rome, Milan, Genoa, and Turin) support 0x8000 ASIDs.
> That makes the ~512 ASIDs reserved for SEV+ a drop in the bucket, i.e. still leaves
> ~32k ASIDs up for grabs, which means KVM can concurrently run ~16k vCPUs *with*
> nested VMs without having to fallback to flushing when scheduling in a new vCPU.
> 
> That way we don't need the complexity of the xarray ASID=>vCPU tracking for common
> code.  And as a bonus, the logic for VMX vs. SVM is very, very similar.
> 
> Given the SEV+ uses the ASID as the handle for the guest's encryption key,
> changing that behavior isn't an option.  Though I still don't see how that isn't
> a security flaw.  Regardless, I definitely don't think it's something we should
> follow.

I don't object to the above, there are plenty of ASIDs. Per-VMCB ASIDs
seems fine. I suspect that the per-pCPU scoping of ASIDs likely dates back
to the era when there weren't many ASIDs. But now that everything supports
32k, that's not an issue.

Note that SEV reserves 1006 ASIDs in Genoa/later, not 512.

Thanks,
Tom


