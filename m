Return-Path: <kvm+bounces-60678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DECEBF76B4
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3891E542561
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BD9340A76;
	Tue, 21 Oct 2025 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FAguaSV0"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012005.outbound.protection.outlook.com [40.93.195.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDA8340DA5;
	Tue, 21 Oct 2025 15:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761060692; cv=fail; b=kdISPuND/RhOmJGnoGz/1InjyeMtSaMXWg/NVyAQYMUes5XJVUBdqOjdBOo5BDaPt6ckhOIFQV1lVFt60KBzA4OMmyrITu5uTksJp93qw8TP9ofJgHR334Zlb8yV1Cpfr84OO6+aBGXOjXZH/jEqBOoS9yyLS0YNg18BdlS+o1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761060692; c=relaxed/simple;
	bh=9jtT+xMH/e3rJZvsL+M24NMlo9lyXJuoF/2pESKusFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fX0n3PXvxzHFpvl5w0li0seMMVmZjWKdLdC5Jn970jb7ArMpqE0Msd7lYr7LhTJep/Q7pdtafZg/tFKp3oKh/UJQj7m/jjTtbHLpKfGRIw5O0G/+oIuFVR2ntvd1h3eABMIifPvhonfecV3oOwQdrmipb8itnOa1qmsJ4z3w/rA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FAguaSV0; arc=fail smtp.client-ip=40.93.195.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFTj2HQw100Ift7tm5h0AQteyz+U4g/e6sOnc6sUXuj72NOLVxv2Y6hPxO6aCwhOjcJ/tle5Xjx0P4tuSej98upG/0Con2nsi9RWCSF49DckQJdrWLbS5H4t/j5VNTvRRrr2jgUtg9eGMKI1lZN7kG1/1ZwjgVSX9B5B+l+O4sYQzB5sFFy1KRkS7ATxb738a3IR103scvr4x8iExTYqRJBKZqgbanrGg1IE8sypegUhlBpgvraO8XU1ByoCKrfGy3mt/txoCk3H9f6YVzOUre/VGCMVePjaQmIWihvyNUyGxdExkWMwoOy3G3S0vcq+LjCFnGNfroztwgbNCbZZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jtT+xMH/e3rJZvsL+M24NMlo9lyXJuoF/2pESKusFk=;
 b=C5pEb6KuENzhVMV4+QksrIRWPWak/xdZHl6yYDxYpMpVHFOIN6K4tiWItCCXy4UIDfsGsHDJHmqb66bU0ro2vCNCv1XvnUaLKxgfGWWndX6dejMJmp97DCYiLb8C14IQSrDNLFC83DJSaXIyCHGnTNy7LLUTG90IHuWxJz0JB4OImGhG466dPjpN+JHSmYR4gjOoVNpFIk8ZVF6jVomMZfVmzOV24qQWUSCpfCSERrSnfhyxpLmxihIvSjC8yKqijmkkrdtjPsrE0m1Xei//kz4SyswDrJYFV84a7G0xMKUEda/qkUdYCDwA5+Ut4c4KIhtlmE9zUcl6X7eaGujIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jtT+xMH/e3rJZvsL+M24NMlo9lyXJuoF/2pESKusFk=;
 b=FAguaSV0huKsg5lrv52cAawzdIENTqbwdb9As2w/fCxfPttKZuH4efuTDP+ndO3eDYU0QWpxEubqv+uCELO9NmlQvwPhZfFuNrJAXDln3cLdr0/p5jDifKw/2dvt82vVzBycLsPojyUdYCfk6EdlFltlQU/MSkCDbW/AvMJP8Ke/W9iiBPYbVD6BN2xCx3/M7iZy5haOm79mtefb2zNiVmbPbUSXRSGSyAeTe68LZNZ64k1eB7JM5UwwQvt10lqV0INIqWpPedhM4cB9sEsGvuh9LPYr3ohZnC3TiuL8a8VZSY9hvffldns25OIE4IWPL9krYM2+BXeRjVlXcg8cuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by PH0PR12MB5608.namprd12.prod.outlook.com (2603:10b6:510:143::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 15:31:27 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 15:31:27 +0000
Date: Tue, 21 Oct 2025 12:31:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Guo Ren <guoren@kernel.org>
Cc: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, pbonzini@redhat.com, jiangyifei@huawei.com,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com
Subject: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
Message-ID: <20251021153125.GA699957@nvidia.com>
References: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
 <CAJF2gTRwHJsA7jFvAXbqy-6LyfaVTqfsFXgHfAeOZ8M3JNsikg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJF2gTRwHJsA7jFvAXbqy-6LyfaVTqfsFXgHfAeOZ8M3JNsikg@mail.gmail.com>
X-ClientProxiedBy: BL1P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::19) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|PH0PR12MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: a24054fc-5e93-4bd9-132a-08de10b6e665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGlncnh4TW5GOUdja0VnNUFXS0cyQWFRSmFWSlVLUVMwdWRncWxrLy9CRTZ5?=
 =?utf-8?B?ZUZBODEvTnJUeUMzMFJVM3dMTjR5QnEzeU1vdWhSV3F5MytLQ3ZuajN6RHFQ?=
 =?utf-8?B?UGh0cDNUd01QU1FlM2cvWkNwVzZuYlFDa0c4ZDl1LzFQOVdiWkdnTHIvS0U1?=
 =?utf-8?B?M2xoTDZrUUR4Um0wSmFHcW5uT0VqbHpTbFFpeUpGV3ZOR2VmRFpsTEc3NzRI?=
 =?utf-8?B?YXVYd2oyTENzeHhQZW5ZbUtNVEFMQVNuWkd6VnpzSUM3TGlSVjRvUHR0a2Zv?=
 =?utf-8?B?UkF3VEliSkxZaVNTU1l5SjRPMlpia2UxSWkxaThZQldBNVZlc3VzdEJLWkZG?=
 =?utf-8?B?eGVhRjhiS1VLOG1CMFQ1eVl4Q2svUHpYTW1ETXVyMDAvZ0Rqa1dreklIQmds?=
 =?utf-8?B?djlsaDQrUVNNTU1ldndtdEZTem5VblQ3dld2dkYxVjJWSGFnUWU1Um1qRVFs?=
 =?utf-8?B?SlpjQlhIWnMxbkNJenRWTXVIV3c1M2JaQXhjN0FoRVdIcUZrRjNzTU8wbWVz?=
 =?utf-8?B?bEdSNG5OOHVjYWVkOExYdlBQRFZ3TVJwajd6bjJyR3RidFdaTmhHbzJvWXpv?=
 =?utf-8?B?RHduMVpMT2R3U0NGNmJKKzQ3M1hObXBGbTRBSW9SZlYzQ2tuSndCMC9FdXp2?=
 =?utf-8?B?TndseVBxclNiMlo2MWJPdHVDc2VabmZlZGtFZGRZdW9Yb0Nvck1XNENaQXhF?=
 =?utf-8?B?T0QrMXJBdEJiYURFSUtJNXhVcG1ucFI3VlRmN0V4b3BVR1R6TlMvdkR5VFho?=
 =?utf-8?B?VXVFc1ltUjY5cmRBTWtFWXNYRUkzdVpWRXk1b3ZYeEkrUkNoMGpISkY4cVdU?=
 =?utf-8?B?eCtPLzc1TXFFdHJPZVNnOGorVm0rckswQjlXa054TnZWUjVyV2hNaytUcTNY?=
 =?utf-8?B?eWg4N3lKYUpCbkZnbzdxekVEamgxSG9SNzJpSUlEYVdwK2paM2FNNG04NW9D?=
 =?utf-8?B?ay9CY0VhYXpleWhrcmxZalNNajZMWDZBaXZ6UW42TS9hUHYrVlVsWVJXdzAz?=
 =?utf-8?B?YnFBeEczd2JmZ2E4dlZXTjNsMEpnRFphSlB4WUovNWpieXQ0YTNJNmRwcG1i?=
 =?utf-8?B?eW13S2Z0a1U4WXo3R0JjZndrZkw4TDVCdnVTOW5YWE9DU3NJSW1DRVM0Rkt5?=
 =?utf-8?B?eVRVZDhZZUNtU3owZnZZUy96MnhCUEQwWTM4T2xzYjVadktVb3VvSGVteUNX?=
 =?utf-8?B?SWIvMWpNREtlY3hXT3E0RHFoYXpZbUM5OFNJdDVDN0NvSUNma2xXazE2SkZz?=
 =?utf-8?B?K3NjS09pL1NrTU5hM2JqSjg4MmhUdWdxb1RReUgzSWMycTBxRm1McFF1RVhS?=
 =?utf-8?B?aW5NbUNRc2o4Q3A1R0h1Q0RvaDFZVEFIb0RvbTdvRFhuZ0ZtdU1ObHJuMmEw?=
 =?utf-8?B?aE9DbnNJNGg2ZmZPWWYwMmZuemd0ZytrNW15Q3QzUUdDS29aeEtFNEp3TU1z?=
 =?utf-8?B?ZHFudGc0M2gzdEhEVHY5WllnQ3pCOS96cGNpNzZLNVF1R3dNUldOd1lnbm53?=
 =?utf-8?B?TnFLd1l5anlvT1BLdWsvZmVRc3c4c01wUy9uWFBNdFVyKy81cks4UlZKclk2?=
 =?utf-8?B?dVhSdVE3Wm5GUWtXeC9teVErMFZTdlorcDNwODV2bFZqQm5Sb0h0K3g3Smp4?=
 =?utf-8?B?STZ4aWUyWnFFNTVFR250WG1xMHV5YmU5Vmp0RmRhVXRXMGhDa0RUSHJWbmZ5?=
 =?utf-8?B?ZGlyU3YyR2hRMjEzVHRRUzl5QzRZRUZjZ0lCeUlLWHRGRGMzUGo1SmVUa2c4?=
 =?utf-8?B?MzNra0VVY09kL2lXQ2dEeldxWFBGWmovMUhvZXFMUXZ4eUZadWY5MVBFZFpk?=
 =?utf-8?B?TE9mS09aODE4WUJNUnM1dHZOcVBCY0JpQVgxWUxBNEkwTDBjU3dRRnF6VzJY?=
 =?utf-8?B?N0U3bnh0TzRjeFFXM0FCUGRqeFBMV1JkTVZCNThSK3FtTm1xZ21nVVhvbHFH?=
 =?utf-8?Q?nVVEUDBgrIz18w72lgOlZ1/GxCsgVT9T?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0VRR1FWa21OQk9XZ2tEQUlJcG0wM2s0dUZUM0NkTXhKSmpUamEySUhnNHh2?=
 =?utf-8?B?Sy8wdHRFS1NXMHJiSVhJdnFJbE5ZNE9aM3FOQmphd3BIZ0JLbFRMem8vOGM0?=
 =?utf-8?B?bVgwK0dWQWo4UGFFNmFHYWM2Y0c2anVKTUxINnVZTHB1Tkt3N1IwVmd6SEY2?=
 =?utf-8?B?ejFnM1pLTkxzSnlqVlFsOWtmM2NtOWJhSHc0N0lFZDQzcFE1S2JzRGNtS3VV?=
 =?utf-8?B?OFFINXVhdmxXSjEyQ0hjenZKRlBUd0xiOXFxVEJpcFhDcmtXMHRkbTNzbldi?=
 =?utf-8?B?dExCTHFJSTN0d0lDY2kwZGloZ3dJL3ZwNExIYXJmclpkYlpHN2xrcGNmTnNy?=
 =?utf-8?B?UUlsOEZNcGRWNWp6cTZsZVRGNEVXRmVxbUxyMzhWbEtyN0Y0OXFoajk0T0F6?=
 =?utf-8?B?dEhOOXVhaHRtN2RpTjNyWjlacmxyMnlyMEwvc1VNdTZRc3JWNDMyMmJLOFI3?=
 =?utf-8?B?Uk1vSGg5bndWcVd3cnVCYmdJak9kZjgyMkNtaVJCU0htQVUxNEtDSmNEdVhT?=
 =?utf-8?B?SjIvem54NjcrMC9uOWhZbU1OcFhhVW44K01CUlVwcEMydWY2aUpRaTdSVGpV?=
 =?utf-8?B?dGJ5dGM4MFBrV0J1L2h2VXlUT1pMVWJLRnJ0ZHJXa3RKRVNUdUZicUV5cVoz?=
 =?utf-8?B?a3Z3SHpGd3AreG5RYmxNWXZ0TDZyYVlUOUt2ODlDWGdzYlliSk12ZXFFTFAr?=
 =?utf-8?B?UEtJcThqY09ZNU45a3FjOXNtQk84S0NmcytKVGdvcTUyamJSTFRNTW5GaDgv?=
 =?utf-8?B?eTljVUdDcUd4WEhRSy81NVU5Rkx4Zk0zYk0vS0I5Sk93RFZiQ04yaHJwbnor?=
 =?utf-8?B?Q0hEcmdmU0pBR0V2WEVYdW1SazNWN01qUW5TQkRoUGw3Z1VyNGI5VTZSOHdC?=
 =?utf-8?B?aFRWWEhNU1p4Ti9oeDgvZ0ZBc1g2ZnM5bUE4ZWFhV0ZFem0zYXVweEJMcG5l?=
 =?utf-8?B?dVRuRnRDN3REZlF4QkpmM0puZkxveTRSZGxtNjRmYlFHLzkrdzFlYjdxS3c1?=
 =?utf-8?B?eVBPakFVWjE2UTZXaVRyeGdnREV1VkM2Q1lCdmpoNjJOd01sMXZkVFlEUzRE?=
 =?utf-8?B?R1ZIZ2dzRURadVo1ZEw3bzVodUh0MTlXekxYT0ZLbWxqS042SlVvaDhUK0hn?=
 =?utf-8?B?N3JTTkNsUExYR2ROWld1R0FZOGl6NTVnMk9qc243NFFVYzdBRlltbWVTUmkx?=
 =?utf-8?B?Yk52eHVYM0FaZ3JadFl2WFJCUW94cFBqUzZRNFVOWGZzNkV0NUZIdU85OEdU?=
 =?utf-8?B?QW1ocTdiNENXNmJ6eEllbFpSWksyMGFkYnVuMVlUdXh0N2xGSmsrS1Brei9p?=
 =?utf-8?B?V09hZlkrRXBHTXEyMkFaTkxpd3h1Qy9aenV4UlVhZythM2pibU16cXk1bUlm?=
 =?utf-8?B?MXR0Q1NaOW1GeGpaZ0NDZ2RRQWc1Y3J5UVFyM1pDUE92R2hlVXpYK2V2aVdh?=
 =?utf-8?B?NWZ4RVVtOEhjdUZTd3RubnpLc29ianRkVlJ4b1hrOVlJR0dMVWpWUDNKT0R1?=
 =?utf-8?B?U3J2aUlVTkNpd24rNUpOdERQdDVhVG5Mc1ZqNFpwcjMrY0ZsdzRpQlZBRmc0?=
 =?utf-8?B?NktoeWl2c3RBdWl4T1prWWNQRjdnS2l1ZlJvWUZpT3U4M2xZU2o1TUdOc3Qr?=
 =?utf-8?B?ejZaRitEYkVjd0c1S004TkJZaC9CeUFGeS91UG1zaHJzQ3FSRUF6U0pJZlZT?=
 =?utf-8?B?V3V6L0syR0lweGY5QlpoVTRzTkVSbmlETHlHejhPQWg5UFFQcUtoUmdEZFVj?=
 =?utf-8?B?dHAxOWhadGVZUmJDTm5YODZUK0hsSEdlaG1pWk9VYTRRWGJrL1BmSnhiQjNV?=
 =?utf-8?B?M2dlT3BRQzl6UnNQQ1BVL3doem9tRWgxRXZPcjNybGE1YllUcWZ6Sm8yUGM1?=
 =?utf-8?B?bmp2Q2FESlNqNkdVUmdUSVZkN2lDcEFwRk1IVUcxSGFHU1B3WGNUdHRCV040?=
 =?utf-8?B?YVpLNXlPcWNZL3Y1NWk0WUxQbGdPRGFhc3Y5ajJKUlBsN2lKVmdPSDBqczFW?=
 =?utf-8?B?TUUyNUhwV251SnlqaGZwK1NSUEt3SXRtK1lNNVlPQWZtZ2ZTRFFwMDk1c0NY?=
 =?utf-8?B?c2t6MTZJYW1YbnkxVXF6UzdnS3drdmVwSk1ZeitHajdzcjUwd2F3emxCY3c0?=
 =?utf-8?Q?dTFzIsRI0suSSlv3ULtYoTw8+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24054fc-5e93-4bd9-132a-08de10b6e665
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 15:31:27.1253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPVKMvz9KuRbc0X9Y3fFCjPQJfFYbzkJhjnj6taRSWrktnANO0bapBUv29K3yjnF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5608

On Tue, Oct 21, 2025 at 08:27:50AM -0700, Guo Ren wrote:
> On Mon, Oct 20, 2025 at 6:08 AM <fangyu.yu@linux.alibaba.com> wrote:
> >
> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> > As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> > vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> > regions. Using vma->vm_pgoff to derive the HPA here may therefore
> > produce incorrect mappings.

Assuming things about vm_pgoff is certainly incorrect. Handling it
during a normal fault by looking up the actual PTE seems OK to me too.

Jason

