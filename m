Return-Path: <kvm+bounces-24359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D59954459
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 10:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4933C281AF3
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 08:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CA712C470;
	Fri, 16 Aug 2024 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bbe73xkp"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.mail.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6782866
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 08:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796966; cv=fail; b=uvFwt35joOvNiYYrpss6C8bGtn/X+OKMMMEX8JIRhKcbPpuinIY+6XrD4uXDbf6/M9cMdZrsbeOUgyNR0wdsdSblHeGm2i9RWld92BrFAi2tmRklQnSTlt14l+fksxvdcDfRQCAjHWTib6i7NezrI1Bv1KsySXdaleOHST5SKbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796966; c=relaxed/simple;
	bh=Z3j2jz6SgRXTYCGtArFtk1uP+k3irg+1W7qyTNyqPH0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M6UfdCtfFjj+EQcMk4LsCY5Wzzc67El0N0VT9TrITmHqT4/w4bFW6qiOrDPJYxAcU+vZufTiF1cnpVYGzmt0MW3KBczKU62fo7nvYi1lzWz3qO2vzTKQFZkZJ6sC4PpGdHCmYoz7rjD5lRHsJROpx3HoIj0I7zeuYauhsg0hZYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bbe73xkp; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bUMcp4UIKU5otTdKk6ZZ9p9/ukDpUTJUnS54XH4RRqbDQy1x8V1jdOEmCrEr+Cv6k3Unqs+w+m1drjzw0jFnhhaJFcLXIUuT2cdeu2kmZLKaKKiXgQtzSd5Cjq6IZdV54Ld7jQrjMMC+sGFlB2uMpjb6DGlLDAKwvrtka7DlbsKQzaAsvLrQlNCR86GoHMvnBtKphCIQKD8A+41kIqfjozqIO1GPhjQpAagnqgkSbDsMlMSSS7xbGoyVvWwB8wr+UcA42GA3B3zGbgzDJAyV+9q8Nx7fJOrTE9K8Vf1sEE4XXieNiRC93yjJ0mNw+axrLoSa204K3xNmmK9zrn86pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aLu0BCM1ajxvNhJHfI75C15kQb1PvGi9jNItkvnCRM=;
 b=cLXfL1X7uzYZpQB/X4vb9TfN6rcr9RmRkypdSnYJtFNto0DbL1hQ77aLcJkbe/J4mqab1Z6696AGCuHm8mQ7f8YaefYDvRONQAgniClqXSio2cUHWbxBvpETGNKkV3Qz406cjt7EBGIBSC32dOGrMfPKo8pQJ7IYQUzw85i10wjtXr6Jv1uwZ+kgfC2Hy8tLF3IfbagTltjHxwA36YileRkEkI9UU/OFWrCT33vUvHKlmbt3iyAVkT4chmox9uIkotaIoA0GdcibNFOPx49wvF0yZYL2tbVjTpvRBAo9sPMvNucTEpFgiBOrrviN86mEdIhc7UKg0aB/cbqtIJJZYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aLu0BCM1ajxvNhJHfI75C15kQb1PvGi9jNItkvnCRM=;
 b=bbe73xkpAJGWOX23Ka6VcSbIVq7SPhndju5/GngDcAmdofSZwWhQ1PMLgj03WBscrW3uY6qZY6ocbFhmInEHY9vWcaG9jPvYvD15DxXuzUVZonEh0N9BsKlU8j4NXyyGL9oKowDKmqSv7jKBoKLyfyyktkSEo64Vouo+lrGhDLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB5878.namprd12.prod.outlook.com (2603:10b6:510:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 08:29:22 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 08:29:22 +0000
Message-ID: <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
Date: Fri, 16 Aug 2024 13:59:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
 <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0P287CA0011.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb126ad-2107-4b4d-ee83-08dcbdcd8769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEFsNndWU2p6ZTZrdjMyUVovTEdodnFXNk11REJsT1BQU2RrMFVkWU92eUYz?=
 =?utf-8?B?enZhbUdwR1MwQ3kwSERhSUNPVVRtaXYzbHRMdDRRZU1xMzA3VXdjNmd1RkVl?=
 =?utf-8?B?cGdJdklxT001OWpNblNUdm1kemw2dlRqbTk4N3Fta0lKTEhmR2p6QkNrNDFl?=
 =?utf-8?B?Y1VwN3JuMFB0eitxNm1UTFFtNjlsZUUzZHl4bmFoTHpCKzhMVXN1N1VHbmtG?=
 =?utf-8?B?R04xU2tJWlB2aW9kNlRRR09qMTFPNWt3RW1YeGt6K3c5Um5DYmZUMHk5dXNo?=
 =?utf-8?B?N280bnlMNUNvZHc1NmpJaUVZQXl5VXV0SnZ3dU1TTkVnY25HYi9QZENiMTNX?=
 =?utf-8?B?T2YyRVJ0QjhzUk03ZzR2NXlMY0cvelRVRHFVaDQyN0w0SWpCRWhuUFQ4NFdY?=
 =?utf-8?B?cytNeGpsVW5TTHBGMUFCaUVwS2ZVcVZoN3VNa1JwWlhxQnZZRUdsMFhiQ2xt?=
 =?utf-8?B?ajFkQm5yeGlYQnBlbENJbjlHZFAyR3FIb3ZjQWFIVXQ4eTlRUFJhWWVLRVpa?=
 =?utf-8?B?b2Qxd1E5d2Q4MG90Qks5djlHQTRDU1VDRXB2Nit5UkxPVDdqTWZGSlV5ekNC?=
 =?utf-8?B?L09HdzYzdnE5MkhWYjJjTlBmTWsxbW0rVXBTV2VCRXJ0R2dMTjVGeGZnOExE?=
 =?utf-8?B?OUdQZU5JdWZBQUpmWk9RYnRxa3FjcFVBQmxMUUtmRXIyM1F3Y1RsR1h6U0N0?=
 =?utf-8?B?SXFrTGpUa0MxYWttVEhlZDZsdzJRY1RsVDY4Q1UwRy9FempsMUd4ZXd6N3VU?=
 =?utf-8?B?Q2NKYWdUemF3Wld6YkhNZ29tZjlPdUpjamI4UUVjbnpjK3FTY0h6a1U2NWlH?=
 =?utf-8?B?WGNJU3R3dHdpaHkvVmo0Q09VNHEvTWE4UEdyZXRNLysyek42OHNHZUZlRElF?=
 =?utf-8?B?K1hIRTIrWVRlSE9ZL2UrOWpVdmpGM3JiWUFhWGd0L2VmZkpWV2xXa3IzNjE1?=
 =?utf-8?B?SDJKQUlCcnJrZzJCa3dHVFpMRjNEVTk4MmJmZzdNN28vRnFlVEhWRVdUQUVY?=
 =?utf-8?B?dU51MGlocUg1RmtjeFpkdjNIanhxOElOa3pYL0htUGU0WEt1T3QrS2tiY0Fl?=
 =?utf-8?B?ZkN4K0JzVUxSVHNmWnJNSE40UzRyZnJmSDJmZVBsR0QrNDVFNVpKalEvVnNq?=
 =?utf-8?B?M21kMUNxUTZFTktRRUprSVFuWUpXVysvWGJjTUI5V1ZkNjkrZzBuY1dUcDZL?=
 =?utf-8?B?TW93TThSZFpsM2xqdjZHRVY4MzMraUhHN1JJSW1LMXBYUEZVM0JqVVNpKzVT?=
 =?utf-8?B?a2RPWGdsMTFzMmZQN2IzZGlNK1NrOTRpNlFpbnpnanNkQWRCVVZkM0lhNlFB?=
 =?utf-8?B?V3VoQ21mT1p0YWVBa3ZKWm1sdXE4elU1WFFYcmREL1JkTytIaDArcDU2VzE5?=
 =?utf-8?B?MlYrVlcwenZuVUxQdlNSMnMwZGx0ZzFyTjZlRlNmRXgxRjJuV055NUhaYzBl?=
 =?utf-8?B?VjVtbmlOVDNmd2Yvc0V5Nng1dHFOVHYyTExxL3BFUUluSlJ0UGZycGFxd000?=
 =?utf-8?B?dklETzdwOHl0eXgyQ3lKa1JFWGNxU2xmYXYxenkrL1N4TGlyZjJVamFDTjF5?=
 =?utf-8?B?YjZkdmF0dUlXTW9SOFIvWlIwSjZ4UTlFcUJCQWFLdFYvcGd5WlBRbHFjWlg1?=
 =?utf-8?B?Z1NrR1FObk1uaUtWMFlWcEZ6VlBubFRQVVoyWFd2aTRvQlBjU1dJeWlTQTU2?=
 =?utf-8?B?RFRWWTFlZzAxaWVZcndrYVphSGZEblNrQ2tEOHZnSXFhaU4wcWptSHRoK2tO?=
 =?utf-8?B?NEd0ZVJ6Sm5aeFlOVnFsd08xNTlpaEIxRDd5YnU3cFQydTdJTnBKa25EMlJB?=
 =?utf-8?B?TnBKellFK0xyYWtKTVlKUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?endKZU5SaTZHL2F2S1ZzT0Z1REtPWVJMZ1NtbUdtV292REIxODYveU50RHlD?=
 =?utf-8?B?WUl2MzRtZUJPR2xweTBndnJkWVAzTlpvMUtIQVdJK01NK2JmV29lbTM1U1hm?=
 =?utf-8?B?dGtYNVBoWVJ5OUZPM0dIWjdoTlFXWU1nd1N5ODQzTU5uTXZnU1U1Vnd4d09P?=
 =?utf-8?B?cUIvTFh5TU4yL09QTGN3SWtWT1cvTFZncnVnaUNJTThlTVVGb04rc052M2Nu?=
 =?utf-8?B?alhzODhtZ2E2NVRNaHBidVI5QUpJT0hwZ1B3Rks0S0VWbmoxTWQyUkEyN3lC?=
 =?utf-8?B?VFlyVzJUVGo3MVM0Vm9CZTZET2sydmNKY0JZM1lZTG9vaXZncVk1UmlmQmxJ?=
 =?utf-8?B?UTVSMHdWZGlqQ01vKzU4eitHTDBIdTBablU2dGtGR25BamdzbDd5YXpHZ2pq?=
 =?utf-8?B?djdyZnE0V0RHM3RyYlFvVm84eXMvSEZFeldGSjBNMEhBbGd6dXIwREZxVkFB?=
 =?utf-8?B?d3RQL3ArVlBjTXl4Si9tUzJvL25pKzI3S3YrUlFXVmViZlFFcEFKaFdHdTE2?=
 =?utf-8?B?eldLSmJJT2FvN1JFL2hJN05wRTNmbmpoUW1nbTlGK0lwa2hNY3dQZG1uWWtU?=
 =?utf-8?B?V3BPb0FxWi9qek00N1FFZjNSbTZ5aDUwM2NreCt3T1k0bnZ3bjVoWTY0NFRO?=
 =?utf-8?B?OWU3bkVncnQvM3RHVXF0SHQ2N2FDZDhhZEdvUHVHcW9Rbng0NVJFd2JobnVJ?=
 =?utf-8?B?SGpta1dqeUJucFNadzYxWitLeVh1RW9OQ1VFMDBhRnhKMmdSR2UzVHljUzB1?=
 =?utf-8?B?SGVjQVdZaDFrR2kwM1dRV0cwNXhadU8xZXlyYUVWSDM1bVlhTk9tUmh6NzQ1?=
 =?utf-8?B?SXBSaFZhQytHcmZFd3Njc2tjOG1zSHpHWnRiN1duNEV6UXIvNGdvU0k5QWd1?=
 =?utf-8?B?d2MyT2FyOFZYSGN6ME1MV0dVc0ZiNDNvekJHUk90aWJyS1M4TTZIWTBDNjE4?=
 =?utf-8?B?c3Bna2hMV3dWK0ZwTVJpbEJQdHFjaG5KVlhDWnZVZnlFT2FONXp5Wlc3TlY2?=
 =?utf-8?B?UVBOZWJ4bjNkdm1JZXE5Y2lnTEJIdUhHeEhJNmI3MFFpRjRNc3RsTzZnZGJt?=
 =?utf-8?B?Y0ZoYmRoTlVPRldMdDFDcFJwZnhmemIzYTliUXI5M3FZYjc1RzBoN0owbGRQ?=
 =?utf-8?B?RzFZbnNQbUcwT2tDK0hYOUh0bFdnNEVNcXVBYzdNR0pnUWJIdFMwVENBTHNr?=
 =?utf-8?B?WmxDYXh3bERjYTI3T0ZTVk9xZFh6Y2t6OUtaYVdxcFJyeHR3TWNwaGU0UG9m?=
 =?utf-8?B?ZFYzcmhYOEx1SlJsOElwZE9LUHFqMDh2VHVidXpSZTI2UG8xVFgzWDZPS25Q?=
 =?utf-8?B?RFNoQTZZQWJaSDl5T0NKWE9kd2tpVGs0VStZWUZ5VFZlVzFUWTBabXNjWTdq?=
 =?utf-8?B?WkVDbkx1YSs2eG1ZMmM3WE5aZnFBT3RoOWxYU0svcis1d2krUHpaVkRLeVlD?=
 =?utf-8?B?T0tXVVRlV1JWZHArTW5keDcwR1krYmVBWkQ2Nlh1WUJMWlhvYTJ3ZnRtTXFF?=
 =?utf-8?B?d2pVaVExNWJ3dXRGa1JrNjVjQUhXV3NmdUJKdC9MTnR0NzBobFJocVE1UlAz?=
 =?utf-8?B?OFdDVXJFOW1DTUxHQ1oxaEUwMkh4WlBHWE5qOTdBZnV4eTRCQlVTNDRvWkxh?=
 =?utf-8?B?TzBvY2gxUnFlVm5nTlIvbG1VYzlUK3BvR1JWRVFYZTBqS3lseUI4NUVUQ24w?=
 =?utf-8?B?RmxSV2RGcG5mMk1ZdXRNUTdlTXUxTTYzcE9BZk9QNllvcUJxQkEzSWVzMEVS?=
 =?utf-8?B?ck1ySndLRXNNWlZReTFxVXQvbUR4WHd5Y0NaWnBOZVg4WXpJL0hvMEIydTRN?=
 =?utf-8?B?c3pya0t0dkpMZHFxdnpTWm03QVRSWmdBVU5tSGJJdlVjN1hYWWFTVGwyRVZ2?=
 =?utf-8?B?YUgxSGpVeXpRL1RobDZpOXFuc24wSW11LzZrT05KdG1sVnN6VHhHRG9iYThq?=
 =?utf-8?B?OTAzWEpsMEhHU1FDeU9lanBtdXFOeWpFZUlyWmFpNDAvOFBjSk00cE5za2la?=
 =?utf-8?B?aGVFVXZ0NExNQlFieEl4Q0lwaUo4b2p1NENVYnZRSVlMV1RTejBycnJHT0My?=
 =?utf-8?B?dEFTQkhrVVBkL2tTVGRMRnZKM29MUE5hRmVka2lJUU1PNjQrT2tPRWhJb0p4?=
 =?utf-8?Q?i5/7g0c2QNwQQDHVwzcXiGYbV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb126ad-2107-4b4d-ee83-08dcbdcd8769
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 08:29:22.0854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BCCmT6O2K5Ta+/3B54fZ/MkszfVPmlsavyefWg1DHGGQYeMas1p0zU0NKK/e7ANxc6uPcT2Q+T1upXEp9vOgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5878

Yi,


On 8/15/2024 7:42 AM, Yi Liu wrote:
> On 2024/8/14 22:40, Jason Gunthorpe wrote:
>> On Wed, Aug 14, 2024 at 04:19:13PM +0800, Yi Liu wrote:
>>
>>> /**
>>>   * enum iommufd_hw_capabilities
>>>   * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
>>>   *                               If available, it means the following APIs
>>>   *                               are supported:
>>>   *
>>>   *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
>>>   *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
>>>   *
>>>   */
>>> enum iommufd_hw_capabilities {
>>>     IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
>>> };
>>
>> I think it would be appropriate to add the flag here
> 
> ok.
> 
>> Is it OK to rely on the PCI config space PASID enable? I see all the
>> drivers right now are turning on PASID support during probe if the
>> iommu supports it.
> 
> Intel side is not ready yet as it enables pasid when the device is attached
> to a non-blocking domain. I've chatted with Baolu, and he will kindly to
> enable the pasid cap in the probe_device() op if both iommu and device has
> this cap. After that, Intel side should be fine to rely on the PASID enable
> bit in the PCI config space.
> 
> How about SMMU and AMD iommu side? @Jason, @Suravee, @Vasant?

AMD driver currently discovers capability in probe_device() and enabled it in
attach_dev() path.

-Vasant

> 

