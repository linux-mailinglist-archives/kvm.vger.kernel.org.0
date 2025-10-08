Return-Path: <kvm+bounces-59628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEE0BC361C
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 07:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE9953B637D
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 05:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CE02E88B6;
	Wed,  8 Oct 2025 05:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y6mWVZVY"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010028.outbound.protection.outlook.com [52.101.56.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BDE2E8894;
	Wed,  8 Oct 2025 05:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759901442; cv=fail; b=t12nKqNsrHR1BQXJkA9xFx5ZWnJtUN0cGBHToYkpguECxeu5CXKaSYRAaVK03RXc2u80ILh/cTBI3bM80O+7e4IsPzQ1D2BcmkmviJM2n5SG4OhZoJw169TtBsrYZJCtDppA8Iy+4jfd0u6ibCnOp49VKPBqL0ELH9jrUQoiUuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759901442; c=relaxed/simple;
	bh=IlkQCwB4nlRZO+QXNtTDCbLXB9qIwfJKj7J+9yMHpOI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ukul1KTy5x+qZZ7ZcK/xdt0z5mCC8dIN46aCiz7jiednOgVSu5jUB9shL7MvCVhYZdz2257LAB/ckTNZJwDw1p1Oq4vCuArBEFoKQocVBkqMeDWeNxcxbQFNMUWMMa1WdfqdiSql3gzzNJUSVyco6yjTTMl3p64wgKXD3zkla5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y6mWVZVY; arc=fail smtp.client-ip=52.101.56.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3K9rPCyAlftWD+m0OXyjAquKeuDk+TXtZZa+Qg5hC+lXqSnOk7IwvWCEimHOp18HBqwaW1eaT7n06CVcaRnI6FaYZsifOS3hCuewWhbG7bnN21X826dGpIi89tHWKfg1R9/RR08AZnLIAyJm38RLAgD5Nee5+ZYtb8AeW6iEsh7dZBY3JdKPAFGFuG62aaeCPSbP+KatKmxEMnUa1D/Yp9StO606hprrLS/FxrVaf6jzrp/jMvCteohSxci25ICV7lS+eZVE4DXR7q2KLwtv1dO9iQJB9yVaxdtE4GPBmLar941m8E3h6JarChkWFSUXEkeIbmwBo5QVeGFaQKOsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blT+6x9UnDdLCv8CoP8bODi9u6XSZjM32OqBR8CKCII=;
 b=iLC/tKJ5XR1XmQ8IxhhpqVtHP1w1UnI6sDYYbWm9Tk0p6oZkoL54BzRXRTZZzZtc/QHONR7I9XSNvZD+Ao0vuMP0Y4oi5HCchjjluvTT2e+z/bxUJREddgZKtRCNBIU3r0Zd0v+CFLwWmW7sCiKjIxeQDR5V8hSAoCLd4JVnV6/wOyeztdAgDjIJoHdP61H80mrcT7sBJkJzYzeG/lk8sWQW0cQqrOVWIqv+91cQ3BqHglpoCXkBbTbb/Dot2fCbdNbakSp3xKBK037/bTUWfHwQUefgut8sUI3SjJuUmXoPGr5T058qr2GwQXF3RhcjCanMayQA5O36WDaP66/TlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blT+6x9UnDdLCv8CoP8bODi9u6XSZjM32OqBR8CKCII=;
 b=Y6mWVZVYLtYZNhNEmXMYZqg+iHps4GrUk/hsfFj2Nubg3kRTuth0wgXzZSyZIH2yOaieWy+xzG9rmh7cVUCNa8ooK7JLTlKlH4fr547OPT2XeDlCQ1DEW1b6Pr8RKXOElTORAU4TtWVjK/4dIgpXYoT2B1/fJQXxbV769fL1NVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by SJ2PR12MB8740.namprd12.prod.outlook.com (2603:10b6:a03:53f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Wed, 8 Oct
 2025 05:30:30 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 05:30:30 +0000
Message-ID: <dc579ed2-05d9-4794-9b05-a6b403d05eaa@amd.com>
Date: Wed, 8 Oct 2025 11:00:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251007221420.344669-1-seanjc@google.com>
 <20251007221420.344669-3-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251007221420.344669-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0036.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26f::6) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|SJ2PR12MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: 451ea2ab-ce61-4480-5704-08de062bcba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmIzQnRuOUhlVnIvZXFiK3RENnlLSzN2ZHZtVXN2WGVvVElNUmtnR0NGWTdC?=
 =?utf-8?B?NUxVRnJRbTR1WUhYR0NaMXM3cVRpcG1lelV2TG8xSU5SdEdaN3JWU0d2eWNz?=
 =?utf-8?B?djUwK3VlK3dkem0zaEZ6amxzWGtiQ2Q3UUM2dkJvaEVGTXZMWTNhZFl5emJa?=
 =?utf-8?B?Vy9jbE5pbktiTXNEOWR6T0hVSUFJTDM0R3ZycVJlVUwxQ04xakl4WU92SnV6?=
 =?utf-8?B?OVJIeFI5Y0J3dFJpRFBCUEVwTWd4NTBQeE5IMG04SFZKdzZMaTZNblY2d21D?=
 =?utf-8?B?Tmh3M05vV2RUdVpJd3lhZEJoM0lTaFl5M25PL1RyZ3lWTE5NYS9Sb3Z0ZmxI?=
 =?utf-8?B?LzcwSkI3OGxyT2kwczRwcGxHQkFDa3p2bDdSdzYvVTl6aHIvcjBOQXMzM3pG?=
 =?utf-8?B?ZUF4c1d2cDYxZXhlaWR3UDhVclZJcERPL3RGcndLaWFOUlJOMDRkclB3V1FF?=
 =?utf-8?B?ODhGampXVlpjY1pVL2ttc3VucmQwamI3aUpjTkU2Y0ZtWm1tblh6Ni9QdU1F?=
 =?utf-8?B?VS9LWFA3QStLV2pPYzNXWk1qNTVQZFBDY09zQ3BsOVFtbFhQR2lBRWY3K2xs?=
 =?utf-8?B?eUljR0NKazhZcWdVcERybHpOb2ZmSmlwbm5lOTJJWlJ4aVJGTHN3S2NlMDFv?=
 =?utf-8?B?Z25MTkI3TXFYRlZ4MW1OQWtSTXhKT3JKRWxaSGtiQ0VYeGxXZWh6OTJaaG1K?=
 =?utf-8?B?ZWhicDhLLzlFVHBTUWh0YkoyRDJiQ2RNRmlMNHhTUWd5dTEybE1mRGMvc0xz?=
 =?utf-8?B?aEp0QXJPK2FJOUc2cG14L1c1N2pZdHVMQ2tyZFVmZUYxRTRsMmxKQTFSWnpv?=
 =?utf-8?B?cEpVdDFqMWFFTk1sZTNCcTN0NlNSdHZVeGJvT1lhcVhVZFpYLzVpT1VwSlFx?=
 =?utf-8?B?VGczRWY1WE5DbVFxbWl1Y2JVYUhDZm81dXRCWkRIaG9JQXlLeGN6QWVKdmlW?=
 =?utf-8?B?WmRBb1BjT0k2VVl6aGEwWnBEM2gxcFJDNHVsTHdXcXpQTHQ3YlN2cTVtNm45?=
 =?utf-8?B?d2o2ZXRheHBSZ3duS0ozZWdQZFFrTUFMY0ZUT05CcVFBSHMxSmtLRzRXc2lN?=
 =?utf-8?B?UURNSmsrb2VvTytzNFd3SzN5RnVyeFJoQXBXQXlvMjdXL2JkVW9tbEhSSzA2?=
 =?utf-8?B?cy8yZ1hibDRMcXpHS050enlsa1BPUmVZNllrK0UwK3owU3p6b0lQd3JRNDVT?=
 =?utf-8?B?b3NvanYzYnhDdFlreGhTaTJwMmdLMjFYZjl6RlJSVnA1YkNNSmhUNTZwRC9j?=
 =?utf-8?B?ckJ6azFiUmVGRExVeDUycEJBeWQ2TlhBNVZ1aFlVTzRqNk1WMmtTOVh1OXFN?=
 =?utf-8?B?MjVhaTEwdWxoeEJkbk9uenhKSVJOYmdxTWQvc3I5ZWpEY0Y1ZmFiM01SVUd1?=
 =?utf-8?B?UzVRTi9sZlFWc3BVdVdHSlFqSU5KZkw0TVk0N1p5T3VLaThnc1E4TTJ6ZzdL?=
 =?utf-8?B?TUxQdW9yVlVUMWpCT2FkNjY2L0I0Y09PRjVWcXJjWXg1UGdZQUpGUXczTmJw?=
 =?utf-8?B?MnB6eFY1SVIvYXcrQmR2Z296R0dNUEZBc05MaXF4MktGNHUzL1NWSXV2Nyti?=
 =?utf-8?B?YXRGRXRSYm04ZHR6VEprWTFPRDBYaXFUQkpGY3RCeWY5dG5kd2RQZ2dzZ0ox?=
 =?utf-8?B?QWJRZVd6d1VEc3E0Q1FSckhETGs1b0h2YUFLekd6a3NRZTZhd1N4U1Q4Szhz?=
 =?utf-8?B?dzB2dHQrR1RESEpmU2dqeFdWR01Xdzl6TjZsNHBGamQzZUhSSFMyMUJPbTFV?=
 =?utf-8?B?SzhlTDk5MWd0WmxqUGp3c0R2YVlSMzJQUWJwK2JIUVMwRjlHN2U3bGdPL1M5?=
 =?utf-8?B?b2VHOEdDWHZkZDRSMkdnOXVXdzdncGxsa0pSejI5Ym05bU5DOExwVG9Ub0Vp?=
 =?utf-8?B?WE94WUxiNDJ4aVpUVWtmT3Y2MU11M2JYMnVqanNnOEdmWjBjaVczUW5od0JX?=
 =?utf-8?Q?cFY1IoRRlQhcDJ7RbFwb1AMSzUu6FKbc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TElVQk92MVl3RGRNdUpQejdSMkJtREFOdVR5empIbkRYQXJzdFhTNWdJSEh6?=
 =?utf-8?B?R3hvVHY2TWptOEhoL3lCaWI4bmdNdXlraXRZeWY1TE5xNHJnYWVvUGEwaW5u?=
 =?utf-8?B?dmpKRkU0bEdOdWk3MklCNkZiTENQb0drdjEramlSdHliZWpJNFJ3cE95UVBi?=
 =?utf-8?B?NTY1MU55VGZRbjhJOUd3ZDBLOFRoclRjRnV0UlpKenNBaEdpNVFCNDE0ejdO?=
 =?utf-8?B?ektRZVI5dmg3RFBkTnFvUTJBYm1LVk11dnl3MkdmWFFjeWpGUHlDZzdyc2pJ?=
 =?utf-8?B?YXM5bzByWXVyK3VoMVIzcVdpWE9XWHVyMElYSGc1RVlPUHkxTlRqY0ltODgv?=
 =?utf-8?B?NUFxM0k4OVlhQXFJaWlxdm1ML2QveURxdmJSSThxZFF5UURlVjJyNGdsdENP?=
 =?utf-8?B?b29hdnN1N3FDYXhUTmo4QkxHVVo5OHcvWDhrWWdyeUZyc1RqNFBudjVnSVpm?=
 =?utf-8?B?VFVYVjRCWXhQWnhaS1pCMjZtRXpRbUdCMlNiY1Z6eWZaZXRwL2I3eXpwaTFn?=
 =?utf-8?B?c25YRlRvcExySjJONG5ZbmthZVJMVktPeXFzdDNvemp1c0JTSjFXZ0tNbTFo?=
 =?utf-8?B?Z0tzYVhjVmM0SXROOFMzZUFUWklFVTNnaFlUL29VSU9BTlVmaWJZS0JjVUZP?=
 =?utf-8?B?bmdvcXJkRlJ5aW11OFYwRlRSdTVNckpFQ3N6MzJoQnpxd05YY1FEaGowUy8v?=
 =?utf-8?B?bktGSVZUWmorbnV5MDdhanVoOWhSTzRrY3dyZnhsZ2RkV05aQVREZnR6RG1i?=
 =?utf-8?B?ZzNLTmNQTmpQL3lWbWJIUWU3S3p0endFSC9mZitXZlFrb0hPbC85MW1BU0hp?=
 =?utf-8?B?aVlITzhwaE9Pa3laTWlnRXJXMlE3eDhmcGFDc2FlcUYxeUtqVjl5Um1tWG9I?=
 =?utf-8?B?ai96MlhpNDZ2T1Y1M0srMlNtalIrREhraUhhMlJRS0sySmVkQTBRclhlOWow?=
 =?utf-8?B?SnRGbzRlRXJiL0t3K2QrTjJFb2RnVGQ4aENBNGpCUmRSKzV0eDY5WlVDcEl0?=
 =?utf-8?B?QWlnOWxIcVJYeXNBWU1EMU9Ja2xUSWVtMmVHWkFIaDhpK00vb3U4SGVSUzF6?=
 =?utf-8?B?R3lPWE9pVHpCY2VMcWdVcXBwZG5WWUh4TzVHclYyWndnSmR1WWt2Wmo5c3dP?=
 =?utf-8?B?cnhMT0k4cTN3R0JNYVpaQmRNU1NlNnZHZ2RsdzFTTVR0bGdlVHBDdUVDcktX?=
 =?utf-8?B?OGZIM0p2T0gyNzhWWUFJanhqOVBvWmdhN0FVb2lLK1V6T0E2ZWlEVXVVT3Zm?=
 =?utf-8?B?aDlpV21oZyt0Nk1XNk9JVmJNT0UxNE5JY0F0NHdheFpBbXgwcVZNeithdGdu?=
 =?utf-8?B?S0ZXZzBLMElaVGJXWDJVbTRTaFp4ZDZPNnNKaEtoYTlBZDUrL3lHbndHbzUy?=
 =?utf-8?B?bEY2YW9TbWpXNFlzc1JiNXBsTEI1M1NlbmN5LzJsdkE0Y2Y1RFM4OGhUZG1s?=
 =?utf-8?B?MmdTWTRUUzdYdFd4emV4R3JNdVpMMFdRekhhNjhtZVFyL2lGbzU5dlYzS3NN?=
 =?utf-8?B?MHZLY0R3NHhXNzVBZ1ZLWWptdUc1Q3VCeThlSDhjeDJpVEFyQ2p6ZXhqQk1n?=
 =?utf-8?B?WHNrMU5haE9aMmdRN1hvem0xUWhHbDhLaUtCdlgwS2p5dU1QKzdLSVF3RGxm?=
 =?utf-8?B?ckVmZzZYcHY0RFQzem05R09SRXl2endGQkdhL0dZdTVBWHB3WUNiRjdCQ3dl?=
 =?utf-8?B?YnZQckpEc3lvOS9QNWJybFV5Ly9rKzdyVERBaUI1R09XNHFnWlJDSDk2UGVI?=
 =?utf-8?B?Q0dCVk92MVV6ZWZScDdBL2tCanplc3hmdlY5bmxDNkZnTCtOZ0RvN2NEK2hq?=
 =?utf-8?B?RndxMTJxTUxGUjdaeXB0QVhpNWpOemZ5dWpLSFA5VlpvdHFGc2Y1WXJwSlA5?=
 =?utf-8?B?dExJcnZtdzNVdDh2TldzZnVyaGJKODNuczNCMnpWa1ZQUmR1TndDODJtSHY3?=
 =?utf-8?B?UURrNGg2NTd5TzBPempZUjZkN2haaktad001dlpSbjNXb2RxaHF6ZjVNM3dF?=
 =?utf-8?B?VEhhc0llUTZLQXBVaVhRTmRGN05nZU5VdWFaVkU2SVlzVWNhTmgwc0xNUFJu?=
 =?utf-8?B?WWZLeVgwbTRkUDJaVDIvRUlIU1RXcWpNT1BXOEN0UmhBTUtBcTlha003eVNm?=
 =?utf-8?Q?X+o0T7Xm76x6PppU2ypXOO0GK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451ea2ab-ce61-4480-5704-08de062bcba9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 05:30:30.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2rmw+JVGyqcrcqhCGeS4IkAMmKDNfUvPUpN5bfTVkFJQfSvA7wXik4IlmQ2o945ZpRQJTRaYDn2mZRTwDCWqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8740



On 10/8/2025 3:44 AM, Sean Christopherson wrote:
> Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
> iterating over guest_memfd _files_, not guest_memfd instances, as could
> be assumed given the name "gmem_list".
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3c57fb42f12c..9b9e239b3073 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -22,6 +22,9 @@ struct gmem_file {
>  	struct list_head entry;
>  };
>  
> +#define kvm_gmem_for_each_file(f, mapping) \
> +	list_for_each_entry(f, &(mapping)->i_private_list, entry)
> +
>  /**
>   * folio_file_pfn - like folio_file_page, but return a pfn.
>   * @folio: The folio which contains this index.
> @@ -159,13 +162,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
>  				      pgoff_t end)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	enum kvm_gfn_range_filter attr_filter;
>  	struct gmem_file *f;
>  
>  	attr_filter = kvm_gmem_get_invalidate_filter(inode);
>  
> -	list_for_each_entry(f, gmem_list, entry)
> +	kvm_gmem_for_each_file(f, inode->i_mapping)
>  		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
>  }
>  
> @@ -184,10 +186,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
>  				    pgoff_t end)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	struct gmem_file *f;
>  
> -	list_for_each_entry(f, gmem_list, entry)
> +	kvm_gmem_for_each_file(f, inode->i_mapping)
>  		__kvm_gmem_invalidate_end(f, start, end);
>  }
>  

Reviewed-by: Shivank Garg <shivankg@amd.com>

Thanks,
Shivank

