Return-Path: <kvm+bounces-37728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D92A2F7F1
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFAE016681E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C4F25E450;
	Mon, 10 Feb 2025 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OicnhnB5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641125E441
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739213627; cv=fail; b=QnoGx1+W3RNI1JikNi4TbJj76iOjGZRtlDXNL3GMOpy7FGqBpvu8MI2nvXnUuqK9YryjoAvqQQTPzKr2u/pGS/NCG9EXhHlAGtjqWw3pzw3negNtKfITIIBY9xzBXXW5e19mpg5LWRO28gI23X1PQzGU5wn2Zclk0tps15Ec4Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739213627; c=relaxed/simple;
	bh=14ZNUlj8pEvkFeIMK4qJFPa6fclDyb9HXf/TQBxlkEw=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=O/TP7Kxg555+gcteCBCw8rAOOMqUzTKdAWC++5wm6wmD5iwY3uNIcV3I0BdLDS80Gn3+Q2ONMbfnPDCunrRwojDZDqzsVFWFoZ8mzXH+q36cd0nPqtFZkK/bx7HZkgCnUx7Oc+PChTcFN8zGYjzkZQ9konjG0TMgFohjKr9pT5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OicnhnB5; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qf6UXODInp/NlIbUX4mHpY2UGzx+X3EIGPW1SOIwEtHdscPOGJxPp6mAgVrxqk6M4g60xT755xUDk2Xg6qmFTU6Bm0MOdOSoK9mqYrxNqTxxd24NhXtx/uCpjyF11LYtrIXwuwRu4VG0gMvKQR3r0t3EysS3WLH9Tt7hJ1wVREOqqS4iCxE5CtZxoz9rTiJaWG4+lZI6zksa/cEjaXfJTMxmgx///2e16FV4dcEsTyrnVmGXjAzRsSh0WCcOG9E+IftgiKEcBltvCn+SSGkdCYKGxIuwaq5IItqP50Gp93aEyTwtC+mWGUxspv6QzE/Qo5tNj3eQVQFLk4gfFlrcoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXs4D6Fm9JYXEOzXBs/pnYUKhpX7uNlaUlZ8S+0magI=;
 b=RZeY5sBTW/Qpytv9OvJGEcSBdXit59OPUgLQsfUc/kHZ4ONKLo3Yo8PWfbsHMSi/C0dWzHRsk/4+C/YICfvuJeWDP59JCyvNAVhvv46HLYapq8XzlLAvQtSDizx0g/fU+WAXpdXQ7/NU5UvykLMkL2HDaR1xE2+LQMxbxLEZ1d0VMhaglAHV7tevS5U1VSem1UKjFzDVQAWG9YSS580jqVRtgXt0mYgvhXuTCXwlnea8loy/J+LwZVt+SGFluTGh4HzGhRbJuVOGGm5asAZeG2zHuBEqW+sTR48whpBk8ubVMjQUNXo9+7fGFqOXqercKS83R9xMEnz6vw53z0aaYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXs4D6Fm9JYXEOzXBs/pnYUKhpX7uNlaUlZ8S+0magI=;
 b=OicnhnB5gkPwhqayCmcojV6kGHT3NiWn816lPnmRfHxrDVNRocw7kJ6uazl/QIc27FQfWM066RC8QzCJwlBMSeLr+UUx+bOpQ1/ltCW48wl0aqnXg/9XxhdtBeYZBMx9Jw335QwPWASFOa36UhHRYDSCVIVYW/ebM0SFMnq/4+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.18; Mon, 10 Feb 2025 18:53:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 18:53:39 +0000
Message-ID: <9d1643f8-f9f7-137d-8105-e9c06e2c8b72@amd.com>
Date: Mon, 10 Feb 2025 12:53:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20250207233327.130770-1-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC] target/i386: sev: Add cmdline option to enable the Allowed
 SEV Features feature
In-Reply-To: <20250207233327.130770-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 78855dc8-342e-4df3-0a4b-08dd4a043b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUYwSnVZNXJVaWMyNWRoaGRnTThVTUI3RzJucS9uR1ZOL3BkdGZCWTJneFcz?=
 =?utf-8?B?a0RaR2F0MStHdlg0UDJuMkVzcUg5ekN5QzI1K0ZOYVZFYkJuRm40OHdpSFVF?=
 =?utf-8?B?VEtwS0QySldGMTUrVHA3WUVOVlNBQ3ZHd0lBYW9BVWJRaTBYY0EyaEtNajA2?=
 =?utf-8?B?SUx6TlgweEJnSUd4RHZHUkV4Uy9DUmkvWk1MV3lPRFh0eGdQL3ZUcnZWaWJ0?=
 =?utf-8?B?TXFqcmxpVXFITmsvekl4RG9UME9MazRKelFqNTIvZlhiRitidFNFbHRSbU9n?=
 =?utf-8?B?UkZTdWFTaUdtNDV2cEo5V2dLMDJ3Mm44K01sWTl5bEp0MHEwSkNKY29acllU?=
 =?utf-8?B?OHBOUWtiZ21GVm0xbkRLTFVsdU1iT3l6MDBLbWthZjNORVZtL2N6djNwcjhJ?=
 =?utf-8?B?a3J5SmJYSXRZVi9KdisycHNjd1IxK2RZajlZalJid1F5QjhGa0NuNTBOa1po?=
 =?utf-8?B?SVRwME10c3BIOEJNdWd6eFlMcDZLVWlSVGN6SFpMV2ZDaVFiNzBRQXZPOFVy?=
 =?utf-8?B?TzlWMmtCVjg5ZXEza2IrYWlGdXRQZjNLa1dMMm02TC9JcXFPWmJ0eGVQaXpI?=
 =?utf-8?B?dEFkTjZrN1dFRkRQdmtEY1FmVWVqSldKK2Yxb0xOc1YreGF2SDVyMGdKQTBu?=
 =?utf-8?B?aE95MHY2MHd1eFoxTFlEc1F5V2FmdDV1TE5LdC9LQ2lNb29nWlNNMi9KVDBM?=
 =?utf-8?B?UllrT29jRHdtL1VMYzZKcUxETDR3NmpkZ0lSaEx0anBvVTVsT0tIcjI0SmJT?=
 =?utf-8?B?bUgvcEJVQkRWY3ZlMVM1T3gyNXVvelZtUjZqdDRDSEJRVHFqOEV4aEc4TUZy?=
 =?utf-8?B?UFdWSE8yWDJXMWZqYmtjT3J2VnZPMTJRRTNpU3ZSM3l5ZzJHSkJpMUNjZDdW?=
 =?utf-8?B?d0F4T05zR2NVL25iUzF3VHZFVjNxWDk1Qi96NkFaSEpMSk9QRHJFV1BMU1ZW?=
 =?utf-8?B?YTJTN2swUHkyS2pTT2xpempzNmM3NEQ1ZWcvQ0RVU2tqQmtFNjJuRzFrSjE5?=
 =?utf-8?B?WDRYeUZmRXIwWmVkWGdCRElLV2djUHIvekNmNjh0NVRqdmVjWnRSZ0NsQXd3?=
 =?utf-8?B?SkNNVWJ3ZnNna2JBdklRc2JnM29XakZYOHBDTnVDWUpyMHFmSVRqY2c4cmM3?=
 =?utf-8?B?ZEY2WllZcTJYa0tscll2Q1dpZFRDZWl2eW5zZEpSUWFlTGxlbHRwbmdwbjk2?=
 =?utf-8?B?N0ZtSU9NYytMTENKR28zTElXWTZSTE9zd0svNlRxcXVYeEFaNmthYWxCNGRz?=
 =?utf-8?B?ZzhMM1VsWnpxdTh6am5iV3QrVUpiZzM3eVFxZ0Ezdm5MKzNGZEd0TG9nUHRK?=
 =?utf-8?B?VGM0MjRTNVNHVWpORDJPQXZwbnhkakd4VkREQU53TCt6Nk1DaXJYYWk0aGp3?=
 =?utf-8?B?VGRhRUVBazVJUXJPWVhkM3lORXJURmJRN1pxWHY5VzltR1NFN285U1hkdnAw?=
 =?utf-8?B?VU9NWEFLZERPdEpoS2FaM3pMdVhrUklkUnBJb0RUSVltSGorS0liSkhGczlp?=
 =?utf-8?B?aytweFRxSmRLNWp1SWN0Z0dCZGdSQjBPZlhJbkRUZm1OUERRWDIwRWhHTmFi?=
 =?utf-8?B?VGpNVEMxSlFOeWVZRnBxdzY5a2Y5eEZMYTJOU21rUzRwQXVVeEZJVTFVdG1I?=
 =?utf-8?B?QTFWOUI3N2Z1SVJ4NWdpc0ZIWmpQeVBFSnFXZk5lUVM1Mnc2MVVDZ1JYakZI?=
 =?utf-8?B?eXhHR0Ywb3VDV3E2UFdVWjBYMis1ZVh4eEdSRGNianN4Z2ZrNUVVRTBXWVlJ?=
 =?utf-8?B?TjZUQ2RwcWY3QUE0eUgvQS9MS2RDMWNEaG43ZVYxV2dGY2d4Z3FtSmExVGRO?=
 =?utf-8?B?eHBuSzlPZTlrUHN0NEtmQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2dJR2hkdWNvUnc5MkF1UFR6NHJhKzdua0xINy9ZSDV1NjZ0S1Bqcmg5UWFr?=
 =?utf-8?B?bGhOc1VDQjlVNXRNY3VpMUwzb2dHa05tUkJxZmhDNGplbGVaT2tDbWlUcWhX?=
 =?utf-8?B?UEt3SmJkZnFFc0FXQTJKbzV4MzBHQzU0TTFzSFVoaGZRVWIzalduQlBQeTA1?=
 =?utf-8?B?TnkwVy9FL2VCKzhxS3kvUVN0SmZvWkJ5QUZsV0JEQnJMbkdrUlhDRW52aU1v?=
 =?utf-8?B?S0p5NUJEamxmMm9FaldHWThzRXlNTVVNUzJ3UHhTOElXMy80VjBOVFZtRU1I?=
 =?utf-8?B?ZWRZTk0zUWV3bFNSdHlIc3RmVnJEUEZ3eUVMRWNqWXNLeDcrWXlVUU85YWlv?=
 =?utf-8?B?L2Q1K29vVnJmZVNvM2Jnek1zditkVVJJamNXMUNRZ3NMRUI2ak8rTWptWXpv?=
 =?utf-8?B?cFRFMFFtZWxOb1NZWWg1REFYNWNGUytVT2VIdWVXZEp3N2p2Nk5sd3ZBSUdC?=
 =?utf-8?B?a3pQU25qdzlITEpKN1Z1NXE0QklBWG1Vc3FsNmRObWEzMU0xaTJwcWszbERv?=
 =?utf-8?B?dnUyZmFzNVgyNGc2QWFTdmFaSDB0eFRoUkFYb3phMlM5SVFqVGYvWGc4cmlY?=
 =?utf-8?B?YUR2RDN6VHN4QndNOExxNlFKT3lvRUNBS3JJcW8rTjh3Mi9XMWRVa3RaR0E0?=
 =?utf-8?B?UmJLdEdTNzJSTXBHMTNNSnpzMTdFaWF3N3ViZWFvWUVydzJxbUdVaXNaL2Fo?=
 =?utf-8?B?YnZzMUFoTXhPZXQxK09WMUxBOVBidm04dndyd3FlcEViQ0lYMk5kS3pTU1RE?=
 =?utf-8?B?TVB6VENScE1tT3NNc2JkYSs3TkRXZkxDcndrR01MLzVudGJybXJiQUJjYkhu?=
 =?utf-8?B?cndhajREY2RFcUEwck9kN202dFRDVDBnbEVqKzJBeGpGaHg5di9INTYzRzlj?=
 =?utf-8?B?eGh3Rk1PU3dnNUxtSzJHYmlIcjI4MTVBamJ0MzBRaFdmelZYVWlEWjYzbUgy?=
 =?utf-8?B?cksxV3pudlZDczVsSktyT0ZLSElNb2lVd3Q5WVA4WWFnRGhGd0JETDJ1Wjc1?=
 =?utf-8?B?b045MVBxS3BMZ1FNWUJxVG5xQXJrRlpNdkNhR3hpUC96Uk5RRW4vRGNJVUQv?=
 =?utf-8?B?ckMvSmdMVkNCaUNDM2c5ajE5a2p0TlRwMmVuc2hHaHdOT1VrN25PVWplWkdB?=
 =?utf-8?B?dHZXNGVtRUd0RmZ2Q21selRKTW85SEh0aDVhZFdxWE54SS84T2dWaGpDbDFE?=
 =?utf-8?B?YnIwVlNQOVhaSnQ0NzJuZ05wSWFBdzdMbkJWU0VOekIvelZkSlBmL1dYYWJJ?=
 =?utf-8?B?UTVLS3R6RFpGb3FiNEtmOHV0aC9ObFlXcVJ1SU16TXg2ck94ZkdtaTVjTkFQ?=
 =?utf-8?B?MkZINEdHVEtNTzVwVGd1TS9Odzg2N3NHUDA1WjljUkZIcmkramgrY0NPYjRS?=
 =?utf-8?B?YktOdkRDNzA5bWdQOXk5YXlZeU54MCtyWDdFWCtMZU05WUtwVThYVGZlaVpY?=
 =?utf-8?B?U0dEVjVnQ3F5S0E2SEwyNkxDMllnMW5NcURBRWdhblhtc3J1ZDg5SmV6NFc0?=
 =?utf-8?B?dnRNRXJYQXh5VVlDMVJ2ZlBlYUFsOW9zQ0pEOFdsVmMvVHN5VHdkWVFQbUZq?=
 =?utf-8?B?Mzd3bG9sWUh1anFib0licXpOc0s4TWZGNzJyZXBPQ0ZuSmdmK0k3TUcvUWZF?=
 =?utf-8?B?NmZPamlvc2ozMDVSaHJOMVk3TnhWSVJrZVAwR3dDNXJoZThzdUI0Q2ZuVXZ5?=
 =?utf-8?B?bWcwWW41aTVHTzl0bnNRdUVvSXN0OVNjMVBkRUNhakN5ay8vMFh5eXZTZ1VH?=
 =?utf-8?B?d2c0eS9hYnVOTEcxNTZaUzlHaHFxbFUvQVZPQUw1WEVNSVNjS29kWnpaREYx?=
 =?utf-8?B?OS9ubEthVnVUbjZXQkM0L1JYWG1ncjRWWkpjd3czYUhwWXd1cStuTkNnZlo1?=
 =?utf-8?B?aTdleW9tM2tJSERuOFpDMzFlQ2tQa3FZNjg1eVUyVXZmQTh1dzNzNnpnTFVQ?=
 =?utf-8?B?UzBvZ1d0REgvbmNNMjNMaTM5bGdNMG9yS3NNdGlRM2NQNk9QYTRTMko5UEtu?=
 =?utf-8?B?bWNOeE9iblU4YjBuUnNTS3c1djRpUXNhM2YrTkNzeHFDUm84UlZ2Y1BROThz?=
 =?utf-8?B?bmZPZlVnWlRtRzVKdEwwZUJPK2xnNDZHMTh5WnI2MTdIU0swN3ZQb3l1Z1RH?=
 =?utf-8?Q?xOcyWqriHWkR/CZNMTGCwMl71?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78855dc8-342e-4df3-0a4b-08dd4a043b25
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 18:53:39.1236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7WhZEIbw8olF4vUQYZcfoU/P5LXN4tdDhcKRwMe7w5FPc9WRqkXVqi6txBFQUA29ipKJi7Ce/lE19ONjzyjRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069

On 2/7/25 17:33, Kim Phillips wrote:
> The Allowed SEV Features feature allows the host kernel to control
> which SEV features it does not want the guest to enable [1].
> 
> This has to be explicitly opted-in by the user because it has the
> ability to break existing VMs if it were set automatically.
> 
> Currently, both the PmcVirtualization and SecureAvic features
> require the Allowed SEV Features feature to be set.
> 
> Based on a similar patch written for Secure TSC [2].
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>     Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>     https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> [2] https://github.com/qemu/qemu/commit/4b2288dc6025ba32519ee8d202ca72d565cbbab7
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  qapi/qom.json     |  6 ++++-
>  target/i386/sev.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
>  target/i386/sev.h |  2 ++
>  3 files changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 28ce24cd8d..113b44ad74 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -948,13 +948,17 @@
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
>  #
> +# @allowed-sev-features: true if secure allowed-sev-features feature
> +#     is to be enabled in an SEV-ES or SNP guest. (default: false)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevCommonProperties',
>    'data': { '*sev-device': 'str',
>              '*cbitpos': 'uint32',
>              'reduced-phys-bits': 'uint32',
> -            '*kernel-hashes': 'bool' } }
> +            '*kernel-hashes': 'bool',
> +            '*allowed-sev-features': 'bool' } }
>  
>  ##
>  # @SevGuestProperties:
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 0e1dbb6959..85ad73f9a0 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -98,6 +98,7 @@ struct SevCommonState {
>      uint32_t cbitpos;
>      uint32_t reduced_phys_bits;
>      bool kernel_hashes;
> +    uint64_t vmsa_features;
>  
>      /* runtime state */
>      uint8_t api_major;
> @@ -411,6 +412,33 @@ sev_get_reduced_phys_bits(void)
>      return sev_common ? sev_common->reduced_phys_bits : 0;
>  }
>  
> +static __u64
> +sev_supported_vmsa_features(void)

s/sev_/sev_get_/ ?

> +{
> +    uint64_t supported_vmsa_features = 0;
> +    struct kvm_device_attr attr = {
> +        .group = KVM_X86_GRP_SEV,
> +        .attr = KVM_X86_SEV_VMSA_FEATURES,
> +        .addr = (unsigned long) &supported_vmsa_features
> +    };
> +
> +    bool sys_attr = kvm_check_extension(kvm_state, KVM_CAP_SYS_ATTRIBUTES);
> +    if (!sys_attr) {
> +        return 0;
> +    }
> +
> +    int rc = kvm_ioctl(kvm_state, KVM_GET_DEVICE_ATTR, &attr);
> +    if (rc < 0) {
> +        if (rc != -ENXIO) {
> +            warn_report("KVM_GET_DEVICE_ATTR(0, KVM_X86_SEV_VMSA_FEATURES) "
> +                        "error: %d", rc);
> +        }
> +        return 0;
> +    }
> +
> +    return supported_vmsa_features;
> +}
> +
>  static SevInfo *sev_get_info(void)
>  {
>      SevInfo *info;
> @@ -1524,6 +1552,20 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      case KVM_X86_SNP_VM: {
>          struct kvm_sev_init args = { 0 };
>  
> +        if (sev_es_enabled()) {

Shouldn't this be

if (sev_es_enabled() && (sev_common->vmsa_features & SEV_VMSA_ALLOWED_SEV_FEATURES)) {

> +            __u64 vmsa_features, supported_vmsa_features;

s/__u64/uint64_t/ ?

> +
> +            supported_vmsa_features = sev_supported_vmsa_features();
> +            vmsa_features = sev_common->vmsa_features;
> +            if ((vmsa_features & supported_vmsa_features) != vmsa_features) {
> +                error_setg(errp, "%s: requested sev feature mask (0x%llx) "
> +                           "contains bits not supported by the host kernel "
> +                           " (0x%llx)", __func__, vmsa_features,
> +                           supported_vmsa_features);
> +            return -1;
> +            }

Add a blank line

> +            args.vmsa_features = vmsa_features;
> +        }

Add a blank line

Thanks,
Tom

>          ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
>          break;
>      }
> @@ -2044,6 +2086,19 @@ static void sev_common_set_kernel_hashes(Object *obj, bool value, Error **errp)
>      SEV_COMMON(obj)->kernel_hashes = value;
>  }
>  
> +static bool
> +sev_snp_guest_get_allowed_sev_features(Object *obj, Error **errp)
> +{
> +    return SEV_COMMON(obj)->vmsa_features & SEV_VMSA_ALLOWED_SEV_FEATURES;
> +}
> +
> +static void
> +sev_snp_guest_set_allowed_sev_features(Object *obj, bool value, Error **errp)
> +{
> +    if (value)
> +        SEV_COMMON(obj)->vmsa_features |= SEV_VMSA_ALLOWED_SEV_FEATURES;
> +}
> +
>  static void
>  sev_common_class_init(ObjectClass *oc, void *data)
>  {
> @@ -2061,6 +2116,11 @@ sev_common_class_init(ObjectClass *oc, void *data)
>                                     sev_common_set_kernel_hashes);
>      object_class_property_set_description(oc, "kernel-hashes",
>              "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_bool(oc, "allowed-sev-features",
> +                                   sev_snp_guest_get_allowed_sev_features,
> +                                   sev_snp_guest_set_allowed_sev_features);
> +    object_class_property_set_description(oc, "allowed-sev-features",
> +            "Enable the Allowed SEV Features feature");
>  }
>  
>  static void
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 373669eaac..07447c4b01 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -44,6 +44,8 @@ bool sev_snp_enabled(void);
>  #define SEV_SNP_POLICY_SMT      0x10000
>  #define SEV_SNP_POLICY_DBG      0x80000
>  
> +#define SEV_VMSA_ALLOWED_SEV_FEATURES BIT_ULL(63)
> +
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
>      size_t setup_size;

