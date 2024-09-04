Return-Path: <kvm+bounces-25898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A12C196C44C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 18:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C48C11C24B39
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D74A1E0B70;
	Wed,  4 Sep 2024 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="auer/DmO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9D51DA319;
	Wed,  4 Sep 2024 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725468210; cv=fail; b=XwgeSL8Ck3rTOyAE2uTv0bNnphr94tAEab6AdyeWXWgOaEMYloYPl2ZZZEMxAAy+N3y8nIbFAI0K8Cmv5o/TPqBSNO2v8KdBjywFFxyKBTRXd9jSE0cCOG7VzZcv9LobHjNVIqIQCqnTaooLXDZcE+OxD8UQhPuPj8h1MGCfdJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725468210; c=relaxed/simple;
	bh=Lm4XDqVwRqryvDB1SN9wWfy4CwobKbwzRRnsHPrkkk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cubpEPw8qYGtRAsZ8YN4iSMkjf9+mzunqAJE6rvqAbyorS53RQZ1hjTvSdEi/hHUgUIxH8llG/GxqoDM+u0NA6lSWRmxehYs57T6Z8JjO1LuN8YSRc25THDP1Yt/CsMumXjK1lnB+4bpRDSiAE8ZGTyh1rhinyXvr+EQZXBi4FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=auer/DmO; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cafzEwjfOXdPny2hjtVYmaznoDK6PsuHlV26422LKfoTu59HjSo0HRTrG/WJmI+U7KVfXvw/ZzMa4nuHkpGOWpgaL0Lp1uyDMyvVDMz2LcIKLpzBzuurZ20+ApZbiLP1vj1zW90me5IlpCMtmhEDzDP+4IE+p48EjQDlnxofaKxanCzMjtda0lkNZgRK3ePZd1ZDL2R1dmN8SZ48zj7T+9opWjLDhHWQCDPKG3tkfgHyH6BoU1+4b9r2Fm7LJBbBSaxlYo6PG4c8QICoDj6/MkRBG/xmecN6VIastEY9wZlPBF5m4ZVd7tWfTGLuAYTPH6zm0WS4K3oWOS2vy99IEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfRPJ9xccEQ7Cfoq4bi+s3amrT5AxL1N5YgB7wLpebs=;
 b=pAgRrbOHkf678U4yWXE6asbRg2Or50GCzIEv/vKh3O5DqM3nJU0VU74jMFC8AeV+1+DAunFWdEAxaE+0Osm9WL2BtyIw56+yZ1o5g7bXZbgi0tp+yEVO8A75GuZlAGnVr83K0Imyf5JAupwHZr1jFqw3kkVxTEe41V6vGx9XjRBbVhd+YxZMi+FQexKQpvU5M4BuNwpUPvS/srOjLUA6g7QBAUlVOm9CK7Qm6lTL6ypTrzJDleMCibCG3Go4n/mE/KKiimO4hV5+eUmo2uzHBHbDx7vLNrlQ339N95INDeVL5U5MQe8y6RusZ3tyat2fR6L1QxQTWLb3WZStG2Zs1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfRPJ9xccEQ7Cfoq4bi+s3amrT5AxL1N5YgB7wLpebs=;
 b=auer/DmOY9SrhKF3EIglfGsiZPPcn0BcEgSB/ig638kPTfHkFR1i4Vs12ea2XI9hI51HRim+tjp8HNwKaSgur0QigH6lAqAU/v7EdVePMTsuj3HXEmiht8PtTafDFMp2NylB78HWp3D6/iyjUfFBEWalFF011xRdNvNAI70efX5fP9wA/s3V33aqJm/fbW20Z+HbGbJIMfUv3Ue7tIQQpaCIHzfKaBjlF+aPqxvSpcvQXtSaBapqe9OC0R1CDocBjmYXb7tBnYOpA54aQEHJwsHiDAv8lCgMtn6HZWcYWfBYh3X9RA2863Obvjqg8fF/FpBSAlmaUrN9B6r+I0/V+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA1PR12MB9004.namprd12.prod.outlook.com (2603:10b6:806:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 16:43:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 16:43:25 +0000
Date: Wed, 4 Sep 2024 13:43:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>, ankita@nvidia.com
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <20240904164324.GO3915968@nvidia.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com>
 <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com>
 <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
 <20240904155203.GJ3915968@nvidia.com>
 <CACw3F52qyX-Ea99zV4c8NjyWKgtqAKtNc8GP0JTcLOCOjnEajg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F52qyX-Ea99zV4c8NjyWKgtqAKtNc8GP0JTcLOCOjnEajg@mail.gmail.com>
X-ClientProxiedBy: MN2PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:208:e8::39) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA1PR12MB9004:EE_
X-MS-Office365-Filtering-Correlation-Id: aecdc2b3-d482-4aa6-b416-08dccd00b201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHB1TEx1SkdDNnIxU0VRa01PeGhZUG5vK2pWSXdCRTZpK3pVaGdVUDNmam8w?=
 =?utf-8?B?M1ZxUDJ1QXE0OWdqWW1RNzlZUTgvQ1c0cmlIMmxyUXBrbE1ZdGxJNUZHbVhw?=
 =?utf-8?B?SWp1cW5MLzFOU1ZJa1duaitzamRDUGpJbWNUd0xsd05XajZrZ3cvM3A3V0Jm?=
 =?utf-8?B?eHF4TDJoeU1iUERMMStseWpaRndDUitMUmxXLzdzc1h0NWlqVUc4ekNvL2h5?=
 =?utf-8?B?RXZkd0JCWis2VUc3TWFXKzZvdnhwVTMwQUlRdEZKZkVjZlVUSXd4ZUpzU29u?=
 =?utf-8?B?QlYrUGVwRFhCS2FTc3ViTnNFMGthQWdSeG9RT3l4TUtIeWdzKzhXZStMM0tJ?=
 =?utf-8?B?SC9hN1FzUlloR2ZDbWJVOVc0d2k1d3RHZjFCMkhBRDN0MHlQd0R4NlgvNHNV?=
 =?utf-8?B?OWM1VXBIRDNETVYvYUZyL0xwOWJIdUVCWDIveklnM1pxOUIrOXluaVNTLzM5?=
 =?utf-8?B?ZVNJL1lYdjh0dVMwbDNzc2NtSHNKMDBjUHBWNWdXQ3Q1U0ZGanYyYzJ3WXMz?=
 =?utf-8?B?N3VhWnVQRUM3ZmlDb05sdDVwVHloMnV1ZUdSaFgwaVc0SGdGb0o1VkhQOEpI?=
 =?utf-8?B?eGxXeE9SNCtkeG54U0pRcGcrSUx0bDBvZ0V2eGhJbHlidzYrT3JpWWEwbUNv?=
 =?utf-8?B?blpvbVUwSkM2OE5yMUl1M0JVSThaVzNtdmxrQkYvZFRoM3ErcjlZTmpzbXJk?=
 =?utf-8?B?ZlN2bUdjQm1oQjZMbnB6di91Ulp6VEc0cERnZmZFL0xlWk02SnNFU3dmaVdp?=
 =?utf-8?B?MkJlOSs4UjdvZ2ZVZHZvU1M5ZUVKS0tJV0c3VjcyOTB5N2ZWVGFacmhqY0dR?=
 =?utf-8?B?RjhHS3hIQVRabjRUQXBKV3JrY1BPYU9HOXNNcmViSGJaeEdVSG1HYUFkRzdL?=
 =?utf-8?B?V2pzUmlpMk5GNUlWVG5xcjVDT1FVQXhPNEFiSlB6ZW0ya3FCMVpzdlk5bFB2?=
 =?utf-8?B?SHdlVXJ1ZnlVZCtkWFRoSlRIbHF3c0YvYWlHWG02ekNWTzQ0RkxXSW5IQjFs?=
 =?utf-8?B?YzNKUHNMTVlhaG1iMnN6aDZ0Z2NyRy9FaVZHVFEvQnEwZGptVmcwSFRmTXJK?=
 =?utf-8?B?c2haT0M4UjRINUlQMDdoTTV6TVIzVDRJNEVoWm5ZNXg3UVphSzJiK3h2Qmc0?=
 =?utf-8?B?ZElJKzdxdm9MMy9jbHdzTzlWbk9CRkYrdlRQQ2VCQllBQTUrUmFGT3YxSHpB?=
 =?utf-8?B?SnZ2SlNDL0tPeHdsZVFta2IwamRkL1ZjOVBaZ0RSKzR3YWJwNkZod3gzVXdv?=
 =?utf-8?B?MjdKSGgzOEd3VndLUVc0eXlVY2dvNTZJVXhDT1VNTDZ5VnZ3bVYvaUV4V3RV?=
 =?utf-8?B?OVNLYlByZHJOQmhxc1FyQXNFWUxkLytzR2FzWENUcW15L0NWeCtDbjFPcUJC?=
 =?utf-8?B?L3lJcmVBckdqM20wUkk5RkhVNlVEalRoNk9oQjAzWngwdDVXdzRlMnA1bnpl?=
 =?utf-8?B?SFhsOHNkNXFTWmVyaWtCVStYc1dZc3pVQ3R0dytmdEk1RXRXQmxTWXFuNmZK?=
 =?utf-8?B?VDlRZUNTbDRLL0NlcUVSYTBBUVJ1TG1HNEFXNHJwcWhQUTU3VkJId3JuVkpq?=
 =?utf-8?B?Z0twOUJRdVFGZGMwMkJyZVhGd1pERk4ycEV6WjBva3FVTktRMkxRQ2VMUTVB?=
 =?utf-8?B?Ni82SGljalEzalBJL0lnek5KRmpNUjZYTTFyeHJucDZmSWpTVEljOUEzUU1N?=
 =?utf-8?B?T2t2MFJNYXJ1c3l6V0lJUytVa3FPNGhtMmRzNE44Mzhtd2g3M0tHVVhZSk0z?=
 =?utf-8?B?L3hGL2QyYXBZbk40MGFSOTdjQWN4Ujd5c0pWUDJia1d0SEUvYVhPTjQ3SnVD?=
 =?utf-8?B?YVdxS0VmTmtxdWFsZ2NWdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckJxUlZWRjB6VkRDQjNNZE4wKzhuTllXamI2VDVyc2VTRlA5aFVvTll1ODds?=
 =?utf-8?B?YVYrd2h1MW44bkM4M1VaaCtOdWZXKzlwa3lObkJVeGx1eG91aGhMZVVQNDZk?=
 =?utf-8?B?Z21kM2FMWGdpWFFpdkdLYkZ6RmQ2SDJlOVpBMi9TUnhzZmRsbXdLekM0R09p?=
 =?utf-8?B?WUlmcGs5ejh0aW5yWk10eEkzeVU5bmIzMjloOGI2WEZDRDhJNDhaREpMbXFC?=
 =?utf-8?B?bThkdmdNMWlnM0hKZ3ROQ1BVc0NGMGIxd3FML1I0czhVb1ozSzN4QjZuQUdQ?=
 =?utf-8?B?cmVpNFc3Z2puek9HbW1tZnJKRkc1WmZCQTc2cy9Rcmp5WkJneFBmM25oaTBw?=
 =?utf-8?B?SnRHUHV4d0k0SGlzZENOSy9mbmVtUDBMVXFPTndaZXBQQjQrNEJVOWVSL0pB?=
 =?utf-8?B?emMzZjY1bENCNThTZHRGM3J5Vm42dDBlbWdzUDFDV1ZoaWVOMXA0RmRUN2RR?=
 =?utf-8?B?aXBOTzJkNFRGV0J3RjNDTnB0SSsyT1ZJVU1rd1AxdVo0SDdKc3lyOFNTOENB?=
 =?utf-8?B?Q2hoZ0FkNWNXb29ocGorSDdGS1BVUU8zU3J2VFJWV0t1QWRYTWdkVjlMOFFv?=
 =?utf-8?B?TmlDRy8zZE5Eb1RmeUlYUVlQaXZxVVRlUm1iWWdPTnNlQ2FoSHZ5RXNoSFIy?=
 =?utf-8?B?K0JzYVE0Yjh0a0dVN3Via25tSGZ3ZWNDUHlIekNuMWhkbWJxR2VhOXdxY2g2?=
 =?utf-8?B?L1V4R2thTnN2SFQ5SjZaR2JCTVJtQ2pjMGtNNnpuVGhQOVdBeURLSDBuNFhO?=
 =?utf-8?B?R0ZVNFJOenZRd0V6ckVBZ3RkWW5IU2VDWC9mUkVuLzRaYW5JQkZocW1TcXNh?=
 =?utf-8?B?UXc4dXBONDlHczdOeHdRdkNKZEx5WlJlNktvcVBmNXkvMEkxYTRiZGV1Zy8r?=
 =?utf-8?B?RGVsTW9rN3Vxb0R3dHpLa29zTFBxT1Zob0htUUdieExGaHlwM21jU2NEMjJC?=
 =?utf-8?B?cndjQlVhaVQ5UjM0SDA1Wno4clRrc2IwbWVDV1pCZmFpT1ZLNWFQb3dJNVdN?=
 =?utf-8?B?WXdCUDdWcTVwaWNjSGZIN0JDVWxRaUtONWZpcUJYRDFSOGxZU3REL0hlVTZE?=
 =?utf-8?B?S0RDRkkrNDh1R1pxUlBrV1VqZVd2VW9pd09QZlZONkg0VGVtQzJRRFNDNExz?=
 =?utf-8?B?VE8ycy8vcldIY2Vxb0c1U1R1UzhBTnBWMHgrT2Q4WVhJZWFpMjJUL3R1bVBJ?=
 =?utf-8?B?UDRtaXY1c3gxWGcrMTFmWE1lOGtHSG9QUENXTkhrcnN4SUN6NHo4MHBxVUhv?=
 =?utf-8?B?b1BHWGJSay9URlo0V1kxUkNQMGV0OGM1bmluZ21uSk1VMjlETERCL0JpaEUv?=
 =?utf-8?B?WUhXa1hzWFNqcng5cmJjakhMUGJwVTl0U2ozS1pnUE5BQ2NkbTNkTSt3SWFF?=
 =?utf-8?B?ZFd2SUNNb1l4U2YyRmNqSjdoQTRaSGQvMTFCaWw3aExRb0YrKzh5ZUVURW9a?=
 =?utf-8?B?Ym1JazgxaUVTenNYMHVxQXVVb2lUSk0vQmhBc1gxVldWVy9YMmIvLzlhUTFl?=
 =?utf-8?B?Wll2RnlFWjcybjYyMGRYWnNLQjJHdE1JamRPVUNDSFlFeGFUNzNDbDRCR0RL?=
 =?utf-8?B?SE01QVYrQTY1UW5MdzZZQ2x5T3dXNnBtdlNiOWQvQnJTVFJPbnZGbEdRdzU2?=
 =?utf-8?B?Ry9maFdodDUxRUFSdDUxYmViK01US3dOOFFybUJVa2F5T2RPNTZEVEZmWmRK?=
 =?utf-8?B?Y0YwQXJBNUUwTEwwQmZTNXVjSW1lRFFBTk1vTXF1QjE0K3J0ZTYrTVFKYVJK?=
 =?utf-8?B?UytFaWk4R05kTDkraVhURWxhYmJyWFhwMGx4K2RGY0JtVEFQR1JKcStGZzNo?=
 =?utf-8?B?TW1kR0VDNnFTOTFwMWJKT094eUhmeWJzcWF0TDQwRGdkenFIdzhITmVReHhO?=
 =?utf-8?B?SFpabmVIWmh5T1VtTm53ejVJRGdRTnpvWGFRYnFqeE1tenkyV003anNLZ1ZR?=
 =?utf-8?B?eTNPUE9KOFFLTmFPR0d4YWdIZGJoRGlnVVk5UXNjN3RMaE0yNjQyOGtHcUVB?=
 =?utf-8?B?ZGZTSU81TUwzK29STnpHK0Y2NjdVdGE1dk1LU0htMU1HSVk0Z1h0SjZISGlu?=
 =?utf-8?B?Sm9WU0drd004NFh4eWEyeHB6bktsZ3h3NThWMzN3ODVSWGdZVWZtVHoyelhk?=
 =?utf-8?Q?M24utk7p8xtKGfDSC45JeqpN7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aecdc2b3-d482-4aa6-b416-08dccd00b201
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 16:43:25.1312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HxKieEx8/kOBAldJn1teb8FCfLxw3/7pkLEhsJ6PxNveLzLxXUX+40N40jPDYJMl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9004

On Wed, Sep 04, 2024 at 09:38:22AM -0700, Jiaqi Yan wrote:
> On Wed, Sep 4, 2024 at 8:52 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Aug 29, 2024 at 12:21:39PM -0700, Jiaqi Yan wrote:
> >
> > > I think we still want to attempt to SIGBUS userspace, regardless of
> > > doing unmap_mapping_range or not.
> >
> > IMHO we need to eliminate this path if we actually want to keep things
> > mapped.
> >
> > There is no way to generate the SIGBUS without poking a 4k hole in the
> > 1G page, as only that 4k should get SIGBUS, every other byte of the 1G
> > is clean.
> 
> Ah, sorry I wasn't clear. The SIGBUS will be only for poisoned PFN;
> clean PFNs under the same PUD/PMD for sure don't need any SIGBUS,
> which is the whole purpose of not unmapping.

You can't get a SIGBUS if the things are still mapped. This is why the
SIGBUS flow requires poking a non-present hole around the poisoned
memory.

So keeping things mapped at 1G also means giving up on SIGBUS.

Jason

