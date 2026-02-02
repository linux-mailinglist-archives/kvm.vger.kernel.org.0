Return-Path: <kvm+bounces-69837-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOJYDdqNgGkl+wIAu9opvQ
	(envelope-from <kvm+bounces-69837-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:43:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A365CCBDBD
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42BF43046EAD
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 11:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8570C3624D4;
	Mon,  2 Feb 2026 11:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="xDI3qzwr"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A8B21B918;
	Mon,  2 Feb 2026 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770032149; cv=fail; b=gYZpujX99AGBxusHXY1bwYsIZ3EFKr0d3gO1EKJn4jhzxxTWaqK4U7PwAOGXpIZOKGsim7S1IkBeVNFWdBeFEzBL3kvFM2eocYmrWyBGP+JwPDQT+6WTkBvqaTlBGjHyusu8d6ktnS1PSG253E7oGomC/GMD3NQxs0ThuAz3qLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770032149; c=relaxed/simple;
	bh=nUvLbunyLG9gT+4kw7weJPgmRuoXSR7T9R26hlt22KI=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ixzZxPfrmW2otUq6kisZ+Fz/m1wmPmUqq0Dh/4A+NH20InXAF6bWH2XgdiEF/4jsdWkdv7A3BVJkAmD1tsXGLAEkBu6Y9TWXmNDzS67qzSEIIfqA/mq1a3Cyb+accegxrSoW3GIBXBj+WkIjLPLG0Yg8Ks9ZUDz+C/E2GWLbvlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=xDI3qzwr; arc=fail smtp.client-ip=52.101.56.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OuOaAeXrTUJ2pNrH8yr4dc7Z1wpw+X+48pI6cIvjDjcC+7uR9Vm9uaTICBJYuRQsjEBo3r/BIHt4Rr8SMgrYdf+ZD1LifMJ7dQHe2wVLaXxWW5dQ681CC8GjRc60TalLwBfw/5agO7DO1NHP0e16rVJSWsPImzoqa8Ekz56PHhQGGx1ixFuTIhvZsuRFaQR3UXhDh1KjeUs8RsnmvbeYiL6jBeF09SiPe4VAT/2356MbxnE5FRIoHO2qusZxCCdlS7GwvweAd+2gLCdjmzKsz5gd8QWAZehpgJPHygqaMQWSCq1UgW/wPvc+X127FnzLEiiMdIQ6JQ7RrJ8phapS8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUvLbunyLG9gT+4kw7weJPgmRuoXSR7T9R26hlt22KI=;
 b=AwyFTwTrSEuoC1W9wGwhqs3+rbHyXoBCx22dK+D+MZ7Og2Sy6HN4iOfdZ6p38EjhMKqjNs1GvB/69JEI7s+lmit3bjDf5eSTgRhu35wgKmaaiySD8/Q7lN04odU86Y/43AGJME+WsGS4vVZ6n73vV4g02TiRclI8+Rhawvksmucy8th3kzzGjEc6EEKEHi2wl1bpRRmdvLpECxYlhE8GOV6tF4kKBdN4Uuo9CX8Z2vl7D+njRaNI1jXyA2dhwpeU6XWvQ+M6KlCSErn+0J8yXY1vl6Pz4uxL7rdoO95+dNh2QJXhGOVvNZhrsDagFlDtgfaaIZM0PdszGpo+4drR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUvLbunyLG9gT+4kw7weJPgmRuoXSR7T9R26hlt22KI=;
 b=xDI3qzwrjmcz0TrxTsqmkZ+dd2GdE6kPeudhEDRhoLoZgw5JMIVu5OOKBUAkBl4CTfEH9/vxKEbpjFFi9UoEceK1gBHwpwVbmSp2YhhaiRQW9PZnmpuuXcMi6PguFSn7YCR7mlcHKXrlQtShVOq19LCsckSImhMO/9IRzmVzX0E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by LV4PR03MB8187.namprd03.prod.outlook.com (2603:10b6:408:2e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.14; Mon, 2 Feb
 2026 11:35:46 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:35:46 +0000
Message-ID: <a7d93306-42e5-4617-91df-23f7dd35aa1c@citrix.com>
Date: Mon, 2 Feb 2026 11:35:38 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Ingo Molnar <mingo@elte.hu>,
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, jailhouse-dev@googlegroups.com,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 Rahul Bukte <rahul.bukte@sony.com>, Daniel Palmer <daniel.palmer@sony.com>,
 Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH 2/3] x86/defconfig: add CONFIG_IRQ_REMAP
To: Shashank Balaji <shashank.mahadasyam@sony.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Suresh Siddha <suresh.b.siddha@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Jan Kiszka
 <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-2-71c8f488a88b@sony.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20260202-x2apic-fix-v1-2-71c8f488a88b@sony.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0284.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::9) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|LV4PR03MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f063a44-8b77-4480-aa43-08de624f34cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tmt2VkQxR1R0Y3pNZEpSVWxjdU1xdXpMdnNtQ3ZsK1FSeldWYmpzRDhZdzhr?=
 =?utf-8?B?dzdRNkNQZVhzbGRXRFU5OERwaVpta29qdEJuMFJHSTVBazBLRzVVQ2dFTHpK?=
 =?utf-8?B?anBhellGU2k0bHY3ZWdhNk04VkhKbE5nN3JvbE8vVmY3WTZpbkV0Yzd6VjZo?=
 =?utf-8?B?YzN1cUFOeWRvWU5qNlFGVUZjVDVXaGpzNDhSemczRmRGN2pCeHRNU2R0UWts?=
 =?utf-8?B?OU1VN0QwaldJeHViSk03N1hRWlhzcllPSVVUNXlSMHVKT0pQcEh6Tm5VdXBL?=
 =?utf-8?B?TnovQzZPckVrTmdlTHhsbzZYaHhDL2FhcndYQlhtTEwwcThMaUFvTHg2V2FQ?=
 =?utf-8?B?eEpqWlA0aFdubU84NnBYT0VvRWMzd0lmYTdwQzJaZERNMjdpL1lVeFJxNGtR?=
 =?utf-8?B?K2o5THVWUDJ5OWpYOTVTRzRhSHorcXBrSFZmLzBwZlJWL2ZKSnFhRFZtMitm?=
 =?utf-8?B?S0ZBQmxqZ2R1STJzQUZMQ2toRTlmcndSSUZJc2FJYVBkcXNZVlRLcXkyQmpo?=
 =?utf-8?B?LzRvMzQ4N2ZUOU5Mb3haaWRnSEdmUWxrQW1LYVFUeU4wZ1B2QUE5UnduVGV3?=
 =?utf-8?B?RFFKTnE5OUdWaSt6UzVvSlhnOGVsTE1NODhsb0JNY093L0plSGdZU2xaTkY4?=
 =?utf-8?B?QkxSbmN5c3VxTUNXcnpUTE5PWHFpQllPdDBMUXpvQmNBVDQ1OUcxOWxpd0hz?=
 =?utf-8?B?bzlUZEVINU1KVHpsVGM4THZvb2hSNkcrOURJZDNMeG9FcHQ0WXVCdy81OU1N?=
 =?utf-8?B?QUJGeTNoMXp5VXBiOVFXakpuWThES2hyVXVPZGJtUUMyVmJOMi9TZmhUbWFy?=
 =?utf-8?B?SlRMRFA2R0xwQUc4c3lENlNDcXRkeXRqQTNWN0dHckpOeVAyci9YOUxTalBT?=
 =?utf-8?B?dFVWQUZKbkh3a3RhR084REcwQWNmV05OU2lDNElJNzU2N0VyQkx1aTgwZ0NN?=
 =?utf-8?B?b2VhTGMyWUJucnY2Z0tpaDZxengwT0MyVmZQT1ZJdlhqYlhFRFMzczFxS1RL?=
 =?utf-8?B?N1lFVDdyMDBJNXFMWlUydUR1NXlLYURrNXF4S1NScllVbFFiZ25vTnJzV1cz?=
 =?utf-8?B?SS96SENpNVJyaFZXM1FGOHd0Tzk2QmlTY25JYng2eHVpcTl0MG5FK0Izalhz?=
 =?utf-8?B?azhFKzhZZmhtSm9ubHpkR1I1K1VNTXo4QjMzTXIzUnpsWkNBRkZiTkE4T0dw?=
 =?utf-8?B?b0drczFieXp6VVdNQUFEU1M4enB5T1U2cS9DK0hnZWRXVGNML3YwK2Q4RVh5?=
 =?utf-8?B?bFZ2aHJrdVVGcmxVNkR3MTlkMnpwTk9yN2Jnbm5pRnRXT0M0dmRDSWF2RWtv?=
 =?utf-8?B?dWl1U1Y3MWF0a2h4bzNwWXpHYVQvaE1iR0tzV2ZNN2JheHIwUDNDZ2RGUzRQ?=
 =?utf-8?B?a0xMaEcvb05RS0R6YUlTdDV6QkpJY3YvYzBzWmpZU0NPZW5uUGZkWitUZURj?=
 =?utf-8?B?QVU1dExHeFh5Z2I3YVFCUkJqWHMyNmpDKzZFbS9LMGdXbHVwcjJxTXpReVVT?=
 =?utf-8?B?cDJBY3VNRnMxVE55YmFOMU9xeXd3bm5oeU9RQ1grQm9ZQjRqTUMvOVZjQm1V?=
 =?utf-8?B?RUN1Y2NlSVNBTFZEUlVaZjFCbnJ2L1l2YzZDeGtYZHg4RTh6d2llYWROUXg3?=
 =?utf-8?B?L0owaTV5V0tlZ1Z4YjhySHIxZTh2Y1N5QnBRWnNmT1RXemNXK0EyTDVtSXRC?=
 =?utf-8?B?b0NpWWl4N0Z0Z1k1QkZ5blk3VzFkTC94UUUwZFM4ZkVsbUM3WDBUN1kreTNn?=
 =?utf-8?B?SHRoWjBBMEg2SzJHU2VNR0dOeFpGZTNHTGJ4NEx4T05wU3VrRWhLS1o3a1hY?=
 =?utf-8?B?WlR4Zm8xb2U1UWkxQkJlRWZSRGoxUlZuUHZMaWM5NitKUHJjTm0weThqOSti?=
 =?utf-8?B?Tm1Nbzhya29hNWNVWW1KRDB6QXJ6YTZCMGQ3dksrTzRaQlB5WnhqWW1lMkZS?=
 =?utf-8?B?d1JZd1lhWUJwOVJqcFNybTlGSHVaZC9peXBPZHVLSXh4bElrc0RQa05YUW1j?=
 =?utf-8?B?dENTNmlJTU8wOTZRd3gzYXd5ckJMNDlnOWhpR1JuU1FPK0JQOUtpSVRQN2py?=
 =?utf-8?B?WjFtMTM5WXRFUmhtdGJUamlac3Q2Q2lXaTk4NGJQWDhtQU1ZRjhPTmJOMFZi?=
 =?utf-8?B?anY2ZEpiYzFmanBJeE01VWxzTUtqVEVxQ2FlcWF3NlE1aVBDSitPcjg0L2lP?=
 =?utf-8?B?anc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXNmZFFiS0lVSHowM3JyZXBhNStONmoxbGkwbEZNWXkzMEo3aGk4VElyUWk5?=
 =?utf-8?B?ZnZlNGdDNCtaR0ozaHRpUEMvNDhIb3MwdHNLdmZZSFNXSFFpZ3JhdmtvZjZr?=
 =?utf-8?B?em9XaERPWmJ4VFlnREFWYTZ4YVlKVkZObExSWklaU0F1S240US9KU1V1ZjZu?=
 =?utf-8?B?T0Z5eXdaSmxOei9jc3VyR2N3NnpuaXluZmZUZG1zcVJkMndhNEhDYnVFQnI2?=
 =?utf-8?B?bWZrU0YzMlR0ekFRSExCRGJPWGpCdDE2N1JTUGRkNkk0ZHpKUW1pRmVaN3ov?=
 =?utf-8?B?VUZFRDM2d01QYlNqaEY4N3lBOEt0dzNRVG9KcWZSc0FCSFJ6VmlHZXM1VXJN?=
 =?utf-8?B?TmNBMDVMZ1VsMXgyRkFCMWUzN0Naaks3U3lQZm93YXpwVDdqVXZ4TnVwQkli?=
 =?utf-8?B?M1Q2UElBQXp0SDZJM0M5TjJMd25Pamp5RTNNK3h2dE5udkN3aTMrUmRVRHdj?=
 =?utf-8?B?dFQxbW9RVVNtQnZSdkVaN1lMRkg2S3FSR1NJVU92endNVGNZbWd0QXU2b1FT?=
 =?utf-8?B?cTBTSnBOdC9qUlBUelJCckNuQ3MxU1ZJdlhtRWoxTG9TTW54SzlCRG14bzFj?=
 =?utf-8?B?dERuNUxqT3RSMVlNV041cnljYVA4Vlo1VUxDb3dyUGlvZW5YbkxMRVB0eHIx?=
 =?utf-8?B?N3dLNVFKZ2NLelhlbXdtM2pYUVFWNjl3aGV1RGMxVzU2WkhNZnZEa3Y4NXhS?=
 =?utf-8?B?dmFrQ3BvUUNMMmxjMU4xdGR6amV6aFpZcitZSmFXUEhVVE9valVrSE53d2Jx?=
 =?utf-8?B?ZXc1V1NNRWdMTVd1amplUm9GK0ZtVjh4b1hBVUU2djBZVG95N0NrQW5Jbi9J?=
 =?utf-8?B?NUdJRmxWMmFDamxQUnNVM1pVNlZZYkhRSXR1Y1NWNWZqbUt5eXBpS1lpNDd6?=
 =?utf-8?B?Y1pRSzlVY09KK2dHMmNHcnZ6enp2eU1JWUt5Z2l5Z0xvcmwzUzFIRW9CZ2o3?=
 =?utf-8?B?SWRabVhjVGtwaEZiUE1mQTdhY0dONktVVVJIYVBvL3p0bThoaGtBZVpoQUcw?=
 =?utf-8?B?UlRreUFrTW1DMGdpQ0xJRlcwU3JzUWJvaDltZ1F3ci9Jakh1WUR4SllYVTZh?=
 =?utf-8?B?eUxtSzZtRkkxUEgzS0UxeDlzcHBoNnA2Ti9lWFEyVFk2bDVka2QrdkVubXFD?=
 =?utf-8?B?RmozQW5Vam96NGhMUGhmTDFxNUJpQXVQL1FzckE3NlZrcERNRWF3OW51NDhR?=
 =?utf-8?B?MDdHVjh1U1BOemI2UWIxVmppc2R2cCtlbWpybXdzdURNRDEwZzRBUGJpdGw2?=
 =?utf-8?B?WWxJYzhsQm9KRXJwOTNGbE1QT0wzaFNZZTdhOUlNSHRpUWViY3dIWXkya3U1?=
 =?utf-8?B?ZldWWWM5L2lRRkRUeUxUaFpDUVExQ2pRSjdGcUtlQ2VHMGlDT29zTTk3eDky?=
 =?utf-8?B?SWt1eFYvSzhLUFYzbmFhMDBsQmRNbVJpVm5EU3paRFYwSlVPWTRTL1hwcnl1?=
 =?utf-8?B?YjIrdEE1WnNGMTFaVVRDVDRLS3dzSXdCWXFsOXoxUklVWTFOVHRZbkxCdkVk?=
 =?utf-8?B?UC9GK1hFZlJtZjdnR24rYkFBR2pKVmV1U3Y0b2pCTE95Qi9OT0UwTzZmT3NN?=
 =?utf-8?B?eG1xN2pjMXMxWCszeG9lakR5blUrbXh3b1dvYWZ6TzFXRmdpNU5hRjcvSXI1?=
 =?utf-8?B?Q212eG1DK0paNXBING5JRzRIOHUrOFltVTVpMXBYUmVjdDQxbnNpRnduTXdP?=
 =?utf-8?B?Nnk3ZTdKenZKTmJ2N2FtYW1XcTdyd0wwM1VOVFZOd1VQd3lqNWE4eE5nY0Jh?=
 =?utf-8?B?aW5weXF6ZytCYkRnYnkzUkVlZGdjN2JEOVQ4RVUxZWZpR202WVFleVp1S1Jl?=
 =?utf-8?B?ampSRHErMTQ1dEpMUjV0NFpreWUwMUVPN0hjZXlLYjRWYUlqRDNQMys0VHdX?=
 =?utf-8?B?L05NN2p3eDdsU29kYkw4L1Y5aVliYUlRSWgzdVMyWlVmRDF0aURoT2xuZlpY?=
 =?utf-8?B?NmUxZmUxRVJkZHQ0akM4M0V3VmlHa29WeHJ2Qi9yenlBejQzajNueVR3U1lq?=
 =?utf-8?B?TGRPY2VpSlA2RFg5RmlIeGJIOGlmSHJZSVFTMVVOY0ZZUWhleXJ6dzNKME80?=
 =?utf-8?B?SzdzYnVKanRvaDRORXQ4SnhqQUp5OHVreFNZVjR1MGRLQXJVWCsvbERkbExa?=
 =?utf-8?B?c3lDK0RRb0FWSlFTdzJlVXE1bVlSRURJVG5TNjZ1UE9iWXdZZ3hITEkwZGtH?=
 =?utf-8?B?NVdTaitmMUxTcjMzMWFoMnZMZkNTUVh2RzFMN0M1U25jNGZqazNNMDlVTTQv?=
 =?utf-8?B?bUl2K1o3WEtORmhZcVE5VVdBTGZ0S0FGNWNqOEYxVm56TUVaRHgzOVVWYWdn?=
 =?utf-8?B?WUV3ckxpK29GdkQwWjJWTkxjOXZGejFTQU15aVd1ZktvamJuN0h2MlRydUN4?=
 =?utf-8?Q?ANIS3X9GTyQseGHI7MIBqJshyiXnVeUlsnlEeZX0TF6p3?=
X-MS-Exchange-AntiSpam-MessageData-1: pXzgfuuPwNYKqIewdzoSfAI+ecahOTH00bE=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f063a44-8b77-4480-aa43-08de624f34cc
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:35:46.1746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n0YI8SfjTRnOHcz1ag/OuEb5QwzlKAOu4/25uqMDb1qYLwJ7YiNEM1DquxgnXtmFqhde2soC4uABCPR65NCPRkDlPpcC71CrUWBSkjCmyhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR03MB8187
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69837-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[citrix.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,citrix.com:mid,citrix.com:dkim]
X-Rspamd-Queue-Id: A365CCBDBD
X-Rspamd-Action: no action

On 02/02/2026 9:51 am, Shashank Balaji wrote:
> Interrupt remapping is an architectural dependency of x2apic, which is already
> enabled in the defconfig.

There is no such dependency.  VMs for example commonly have x2APIC and
no IOMMU, and even native system with fewer than 254 CPUs does not need
interrupt remapping for IO-APIC interrupts to function correctly.

For native systems with 255 or more CPUs you do want Interrupt Remapping
so enabling it in defconfig is a good move, but the justification needs
correcting.

~Andrew

