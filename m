Return-Path: <kvm+bounces-42856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79281A7E696
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14F83445A29
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1239C20D510;
	Mon,  7 Apr 2025 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fRQO//JM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDD22080C7;
	Mon,  7 Apr 2025 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744042802; cv=fail; b=DnoWE1FR9/o/qAfeZzPGS1Nylcg5ygXgly68jqEHHsBwqmCnq8bFlWSws2OR+n8r1eSxicr53Bk2ouCD2UqAJnmW+ye96/+CBHM+HH/ytzt+DVg4JLUJHOatYUlL5Qmbl/yAy+r6NUPbqlzeHR7SPxO4Ksg3SLtpRTzQjik4nco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744042802; c=relaxed/simple;
	bh=ieoRmCvy6ae9rPIR+w6D4kbAGRQxChTdfGhigA735Og=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bDJyKNP1LfXSfGb1qN0oyN7jFhjv0zLtGMWcu9Pfmxuxnh/LGiRdRjFm87WOPWE/TishpM9jG/aV9ZTrEhQdyY9LBlgm77cEoofC5y+GEgRe4DIZtCXqwyba8hlfUz0FArgqqWz1xqMI7lvY2+MRKvkxwek5/tJvmGjXG49qOTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fRQO//JM; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFuewNxgh4JOSe+DiA8pn1txMCLpnCLrCZs9sSOInyND2EBQIlzg/S7Chv5+KkSfstrG8WIEL6202eCj57ajIXFZr/GKU+GhzmC/k12gE1SCxVgjJ4TawTKGF5wbx1FDKZZUNrYIChjkPJcBNvbUg4YBX3Z31O2BWZ1cpR+ADZG/kV5cp1C7qWHOfXmhXlDjd9aJqsrm/cVR720Na55njO5sjQuPm/ACTVJDN1SHxqBrtsm3SvhsILDHM8PNrINuvrLcKERMcT0/sMtKD0Dc9fuOh3OnQffp5eQNGaejdLy8Lh9bnm08uUEVOLXivcN5mNpdN9y5h8akhy+3z7nXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JtKwe50zfxSlhXk5lPoI5dov4BEyUKFQqHEV/b+EPQ=;
 b=rFE6glnX4pLpSpEc2SPTj9ep8Nvz8ndsIji3E5dOBY/RwVudk8+nkmuXt5Lj9yWdMPNDs51ZruHKRByi9rO1WeH+dti6xpxWT10uFdsdjqpSAv+0eZV7K0T5bsd6bGcYep9MQCtc05y6Rm8znmHuCZJgfhf9SBUvqziRSir1HLfupBwjE1c9KNPjM8c/AzIDRVv4CTO0YP1Vlp0vDB4D3J4egoTLHZbt1dtIGfAEsDnQ/GgV0uMzLjGG2AZ2Zt9q+/dBpeTJqPhsovCfNGKcdrKN07FxO74Ys69lxfQaBTojbpE/Vela1sGxdl6A1sBu2CcdG9ra21L8GgOkQ5qq4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JtKwe50zfxSlhXk5lPoI5dov4BEyUKFQqHEV/b+EPQ=;
 b=fRQO//JMZ3oQ/TmFDsUzzd8y1jTGLjGud0Q/ikzwMhaJaHVwxMGfJAAG3M12thPZMZfUbMLoZG7kNKtXKwQBrR3p6zYsZ8aJjq628SdS480UzkVawJaqw1gsj2x7ymBguLZ+vq1yDnBqhzMAV/65svV4OBnT0HVyWHX2B2tdcsQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.34; Mon, 7 Apr 2025 16:19:57 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8606.027; Mon, 7 Apr 2025
 16:19:57 +0000
Message-ID: <3aaedf1c-e710-4037-bb2a-6c65359bcdac@amd.com>
Date: Mon, 7 Apr 2025 21:49:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/17] x86/apic: Handle EOI writes for SAVIC guests
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
 nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-14-Neeraj.Upadhyay@amd.com>
 <Z_PzDyiyLGq2tJl8@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <Z_PzDyiyLGq2tJl8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0053.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::7) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 626c1c1b-b1d8-4134-51c9-08dd75f00978
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHFWSm8rR25Sb01KNE5RelBFeXRYLzN5Q09Gbmo2d3I0QjdvVkZCQUJvNWpG?=
 =?utf-8?B?b1hFSHhDZUJDYzNXeUkrWUhNUW4xT3RRMXFOaEo0QVVUUTdNYTA1Y0ppL3l4?=
 =?utf-8?B?RE0wNVZaU2FJN0tWNzVrdVU5T1pBaGR4QXg5UzZERDhpYjBjOHZESDJtU2xw?=
 =?utf-8?B?MXVJb2wxZTZLN3h2ZkdMdkF6TzB4c0JCUkc0YUlUZG5HQ2d2VHVhSkVzUy9r?=
 =?utf-8?B?aEduTG5uZkV6WDlqRmJBWEw4cStmNjA0ZnJuWDZCd3lsSEhsVUhOUnM1amtl?=
 =?utf-8?B?aUtOWWRieStGQVZQMDBKc2doYndQL2xDc201aGpNSXhaQmh5YUxFMHZqS0Nz?=
 =?utf-8?B?Nmx0bWpiT3JuVVlZN1VWaUdhWW5hUzFPL1Z3UnBFWlVuSHJya2RIdXNnMVFq?=
 =?utf-8?B?UFd0OUs4Z0xNY1pBb1ByM1MwQk5Jb1U3anVmOFI1R3lEaGl4TmhOczk5S2lZ?=
 =?utf-8?B?T3B6bnhCRktJakQ0U09IeFBiSDlpQUU5QTRmbjkwVDdBdG5JZUF0b3Qyemtl?=
 =?utf-8?B?dFVzeis0MlVZNTRkL3N6T1pJcVMraGsvT0R2ZEJlT3dVNGpiQkludU9WMVRN?=
 =?utf-8?B?UVg2dXZNYW4zRE1KdGZwMFRyaElOWGRnbi9LOXF2dDZsVkFKZzh3YzRTQVhw?=
 =?utf-8?B?VkM1WjRBMXRtaklYbk9tTjBVM2NnWm1wL0ZObjlMSzZ1QWJFU25YcStqc1RX?=
 =?utf-8?B?Rll6ZUNqQ2FCbkVzQzEzeUhhTGUwNmpCSXg0cG5mZjA1RUMvZFI1dFp0ZnFB?=
 =?utf-8?B?UnlRdWxnemcxMlJpZ0o1VmdzZm9zd0F2N1VFS3U1MDdCWW1SWFBXU3R6YkFY?=
 =?utf-8?B?SUJrQStjaDJSd0t5eUY5TmU5WWlsZG5IK1pjckEyalR0ZmRXcEdZR3FUd0dH?=
 =?utf-8?B?Rk45cXpRSEprQlRncWZ6ZzAzVFFqZ2JSRDZBYlZNVEhGb1d6RENhemUxNWRD?=
 =?utf-8?B?dnV2d3U5NG53bTZOOEZFK1ZvVWUrMzBKNXlOL0hJaXBZTlZyWVNjOFBmU24y?=
 =?utf-8?B?dytmejBKRHhURlJzdnY2M3Z1UXQ3aWt2UnBzVTMyRkI4OHFpZlVJNXIwSlFW?=
 =?utf-8?B?NnFZNjdaSTRlOU01VXRQaWV1dENsTFhKS1EzQ1A5YldtQWh5ZWRlbk11TklZ?=
 =?utf-8?B?eVdoK1VWTURRS1UyZ3diamdmNmVSbXhLWEJQM003cTRhSVlVaGh5aWZTVFdT?=
 =?utf-8?B?RExWeHVaMXRRQkVIajMvUEZDMllPRnhpbTVqNER0WkE0WDk4Ti83S0VtODRy?=
 =?utf-8?B?blhINTZaOFRGKzhRdUxBQzFOS1h1MFRTMHkyUE9lVER3cm9peEVuNGJmTysz?=
 =?utf-8?B?WHVUWGhEdXdWeVVtVGpGMHJ2eHRKcXN0bXdCZVVNbCtlQ2tJcElIUUI3RXRr?=
 =?utf-8?B?RkZZTlo3OFM3T2hrQnRoMVU3YzJRb2pkaXhFSksrUURsbUlMRTY5WHdtVDdu?=
 =?utf-8?B?cXQxKzRVTEM0NzBRVmluVU9DOWpDb1NIU0RPZnZsaHk5Qi84T2twSjBva0JI?=
 =?utf-8?B?dkFMbEJpcTI4eEV0dnZ6L3FpRlhpRTZwaUsxeHIwY3BSY2NLWFh6Q0gwZGVY?=
 =?utf-8?B?Uy80STJNS3RSNXcrV0ZCSk5aN0lUZjlUZGNPWjBGcTdRR1VDWVVkcjVHR1Jl?=
 =?utf-8?B?bUVFN2hHdXJFejRtOVE1U3pYd1NQN01rUlhVZXNBSFQ2K2k1cW91U1dPZU9T?=
 =?utf-8?B?YkxaQmRHdUpLTFh0YWh0TTRDSnd1bnBIRFlab0x5QzRFdUtOUUY0YWdnMUQ0?=
 =?utf-8?B?aEFYRWJYa2dUMDFQMWh1MXlXU0FXTEVOUEFlT2ltbitXMmsrUUttU1VadjlH?=
 =?utf-8?B?VjJHOVNCUlBlRm5IZk9NMElnb2puTHg4ZlovMDFLUE1VWTFpcEJSaTN4TmdO?=
 =?utf-8?Q?n33SNuGgQ4p4H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXFzYmVXN2xWQVpmYjJpdm1PRXVYNGttRm1DKzJldFYxUURJek11RWxQNWhI?=
 =?utf-8?B?L1dUYW5uQURURzhsNGo0cGVBc0RWVVBmdEIxRnhCTys4RTZ6djdFN2tUSlNF?=
 =?utf-8?B?akhKNVhkTytJdDArRHBuNGxubDY1d0xzeG42Y2dLUDJ3cTdKME14OXFiUGhG?=
 =?utf-8?B?dHJUS1p0OVZncWVlSGp3LzdQS2tTdXNoMzNzU1hTYStJVDVpbWl1b2NqMmFR?=
 =?utf-8?B?NDhuSXU5RG5kWkhNTkU0YTNsbFVvbStaZkY5VktPVGNSTkNvZi9USWtBZTgr?=
 =?utf-8?B?UXB0RW84di9EMVdhU2hsRUFyMXo4Z2ZpdjJyYkJsZGttZGpPTExrUEN0WnY1?=
 =?utf-8?B?Ym1KZFlIRXY2ajhLVytmTWxwcDhTNkQ1ZnJFd01TS0NlU2NGTTJrem1LMTlr?=
 =?utf-8?B?QkMxaDQ4RVpQZnpyZWFBLzR4NzVKL2R3R212dXB6bWFDWmt6MERqOU1DanhN?=
 =?utf-8?B?ZTVNSFZrVTBqTThGVG9ubkxwYzNYVVJZTTN5RTVrU2RFQnFIeHRHZTZHMkE5?=
 =?utf-8?B?MkVkSW15NllMcjZLL0xnRFVaSFpONWFjS2YxVFVGdGVyLzc4c3BxUlFJRkFK?=
 =?utf-8?B?OVZqT2d1bnRlem54ZWRpb2ZoTndVc1p2Z0psaGxscHVGeVZxeHgyNE1VaUpW?=
 =?utf-8?B?VVhSQWQwbWYrdDdQNytCQ1VmMjNma3NyRDU2TFJOamczd01aR0JsNHZuWGxa?=
 =?utf-8?B?K0FCNGpFTWRxc1gwT011SFg1OVp6NzB4aEF4VyswVGdQdzNGdXJuM0dXMmNO?=
 =?utf-8?B?ODhWUDZZQ3ZIRTNRZ0EwbFl6N3RqbElyQ1R3ZjBRdHRweVc4QSsvTzByajhX?=
 =?utf-8?B?SmFnaFEzMTlPVDB1OXZndTNhdUQ4S05yM3dWbksvZ2VDMTNlOVhtemdmd0ZD?=
 =?utf-8?B?N1pQaFFNUmdPbXJDM0NzL290U0FzZXFsUXVwRG5nazV1TlNPQ3VTLzk0M2JL?=
 =?utf-8?B?ZGh4S21uNGJNL2REUy9iVjBPN1JDNTU1MkV6U0ZTY25HbkF6Y2dqTm1xeEdL?=
 =?utf-8?B?clBIVitjVVhXYU9jc0VicTg2RndiSFZhdzc5Nlk1dW5tRFNLNHQrOXN6alV4?=
 =?utf-8?B?SDVhd0tqeitLOUh5U1p6SlUvc2MrakFkajlLVGtSbU9kYU8rTzdOKzZHQzli?=
 =?utf-8?B?NnZsa1lGelJzOWVzRzNJa2RZYndZdUtIZWJpY3NScEM3QTFuUU9Zejd0Z0Zp?=
 =?utf-8?B?RmdwVjFBaHZ2a2lvenpSQlJCZ2NiNDI4aVdhOGhQMWdTb3k5dXRyd3d4OFNG?=
 =?utf-8?B?d3pKTnJvY1Y5cVMvWUpzRU9jM2QwUGpBVSs0eXBwMEd3NkkxbTB1QmYrMkZp?=
 =?utf-8?B?NWI2L3phUk8yaEJZaGhtTGVHa0xCOUlRMnEvRHNLNFdORnlob1Y2K3FIUko0?=
 =?utf-8?B?TCtTb3NpUHBwNnFWKzFKZzdUZGlPSVAvUHVEcWJwT2RmdWQwaHFidHoxV1Bo?=
 =?utf-8?B?MElwNEE0TTVwWHJGNG0xd2pQVFpOOVE4S3ZRdURTYWM5WExtN21mRkZ6ZTIw?=
 =?utf-8?B?ekl0ZTU5bVhhWmNQQ1VwWnR5NFpLdWN2Y3JqZGhzTDhzTEhUZ0dWNTBEajRK?=
 =?utf-8?B?QUNtSW9pbEgrSEZxdE5oZmZlZ2lWYUFVYUlvai9KV0E0aXpucVM4dEtRQ2pl?=
 =?utf-8?B?a0RvdjI0NndIZXdmUEZJMmhJK2VUVGp4eDIvbG9rL0FKaEZIOFlJUGRONUl4?=
 =?utf-8?B?blRuby9pMTQySWxUODUyV2ZzenM5U0FOZHJTM1d0ZU0xb1ZJV2NGRjBua1VV?=
 =?utf-8?B?dEVDVmtmekFKTVlWN3hJTHNYemptVEU2ZVJxR2hXbUtaNTIyNytiMEthaGVS?=
 =?utf-8?B?UjF4alFHenB0R1ZIaGRrY2d5d3VJUXg0Q3ZXZlJycGl1S3pVUEdnMEVld2lV?=
 =?utf-8?B?NEFjRWhIWm8yZzE2OFROY0p3d2dvc3B4dFErdWdjZWRQQ0k2ME52MWxma0xl?=
 =?utf-8?B?ZFVqNi9RWjZCcXJLTytpNldvYlVaRlpBZ2ZYQUt2TUZubVcvZHd0OFBWaXRV?=
 =?utf-8?B?Ny9GYUhxVHlSbjZmdkJmbEMrZUVkV0YrTnMrVHR6UmNnc2x0YUdWa0VLR0xK?=
 =?utf-8?B?VjJkZFh2a1BRcHdlazI3bEtHQ2llN1FDeUVNNWptVDJ3ZndzZVNWNlNjMjdt?=
 =?utf-8?Q?D1mGVOIt5wlljyHUdQbiUyAan?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 626c1c1b-b1d8-4134-51c9-08dd75f00978
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 16:19:57.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvYU1dZMRS6tV/4pkUgv6AvsIZRPtXBrlpbwlBVULeAyH7f1WXCvubzKDsTa1hzQsMOWgJgcsEZBYf6w8dRoHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156



On 4/7/2025 9:15 PM, Sean Christopherson wrote:
> On Tue, Apr 01, 2025, Neeraj Upadhyay wrote:
>> Secure AVIC accelerates guest's EOI msr writes for edge-triggered
>> interrupts. For level-triggered interrupts, EOI msr writes trigger
>> VC exception with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. The
>> VC handler would need to trigger a GHCB protocol MSR write event to
>> to notify the Hypervisor about completion of the level-triggered
>> interrupt. This is required for cases like emulated IOAPIC. VC exception
>> handling adds extra performance overhead for APIC register write. In
>> addition, some unaccelerated APIC register msr writes are trapped,
>> whereas others are faulted. This results in additional complexity in
>> VC exception handling for unacclerated accesses. So, directly do a GHCB
>> protocol based EOI write from apic->eoi() callback for level-triggered
>> interrupts. Use wrmsr for edge-triggered interrupts, so that hardware
>> re-evaluates any pending interrupt which can be delivered to guest vCPU.
>> For level-triggered interrupts, re-evaluation happens on return from
>> VMGEXIT corresponding to the GHCB event for EOI msr write.
>>
>> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> ---
>> Changes since v2:
>>  - Reuse find_highest_vector() from kvm/lapic.c
>>  - Misc cleanups.
>>
>>  arch/x86/include/asm/apic-emul.h    | 28 +++++++++++++
>>  arch/x86/kernel/apic/x2apic_savic.c | 62 +++++++++++++++++++++++++----
>>  arch/x86/kvm/lapic.c                | 23 ++---------
> 
> Please isolate the KVM changes to a standalone patch.
> 

Ok sure.


>>  3 files changed, 85 insertions(+), 28 deletions(-)
>>  create mode 100644 arch/x86/include/asm/apic-emul.h
>>
>> diff --git a/arch/x86/include/asm/apic-emul.h b/arch/x86/include/asm/apic-emul.h
>> new file mode 100644
>> index 000000000000..60d9e88fefc6
>> --- /dev/null
>> +++ b/arch/x86/include/asm/apic-emul.h
> 
> I don't see any reason for a new file.  arch/x86/include/asm/apic.h already has
> is_vector_pending() and lapic_vector_set_in_irr(), this functionality is more or
> less the same.

Ok. The intent here was to separate out emulated apic operations from the one
which go through the native apic driver.


- Neeraj



