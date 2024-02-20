Return-Path: <kvm+bounces-9165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D6285B79D
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78A21280EEC
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400B860DD2;
	Tue, 20 Feb 2024 09:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dbRwJhsv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D760861;
	Tue, 20 Feb 2024 09:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708421630; cv=fail; b=IpN80dLeHZBISOcQk48g58LZLiuvCiLrLu/WIaCnqIdjcUBvDa4wCPUoxten7D3jk2pyZWGbI1tJUnMbhSPfMfoIogVg0sQBXE+q7GY6cULtpK4KFrpFcZ1YRbDXoBalEgmW4RAVvNdPQ/uw/DAIZvbgVcSy4jCcFUmGEkcZuUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708421630; c=relaxed/simple;
	bh=enJgL1yoo6mi8ICzOkGoifquzv0QFkF/GhTf/VTRKgE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bc3BW65cOpCDH+DK6xn+9sx/8JTZ/yKJOroSmeb9eomtgz8/3+rt4N4uiEx2pmf0FatWCQ0IZNRAS6bmmCnuARAJJ4KsqE9SwwP6ue+fPMg6dqnvslSK+FJMz1TjW21A5AuVoNHpJWGWST1zeQIKM+yiM3ESHuZTW+KynLE+m+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dbRwJhsv; arc=fail smtp.client-ip=40.107.244.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoGqplyrPrTIJB5VFYPxU4nxfwg23Tr1wi1v2pkYpJbHFoCeV1ubB9ZavRV9GN+Jh0ghDFgD6FAb7kxzjcpQxU473/ouSCCArhttF1V5E4lfufjTzOHtNRyaMC379KN+jyfyr0vbm71a6wRB7/3ZtvYTjsisse0Ij+o03CRooM4lG6FbBlKjlLGmafhl6bwOEQggsHAhp7w3GPMNBdGLSETJ73GD7llKn6ogZWXZmUem5VnyDhsVV2WHCr6AAgjThHsAy6Q2RMtg7qPbTpwzMSm7rwgK+4uen8NBKdjiSiYc6DRuloiamXhbyrh3e6miZhsmS+RU3i1Y/0xGsYPoxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enJgL1yoo6mi8ICzOkGoifquzv0QFkF/GhTf/VTRKgE=;
 b=UY/lkMIHsAnZ8pFfNxy8amGnfRuaYsfi6uqLkQK+RVgJ+/ZjEbdtt4oeybu3ycBnZNHh4q85raoq+YWInUXOnAvhTGWKapS5eQ/xLe0G+C2O7i9Up4vmOQcN6vuATmQgXi3CKB2KCAWiZbOi1/G60HGWcG758yrsZulqGQDOcE+EBiYA4pUEWfMGp3Tk92oep4VGZNOShOJ6jIcT4XgxnLFooaJHy6fbl5D4TeLOQ6AFcKJGYFulUl33zAb4N2qBaAMOyOEyZViI7qpTiR3TX5VjRk97SW9B7jV0tz2BbMjDs8u/BKIWCzQeeHmCWvfMBIm0G9Oj60mKREa6FzqxvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enJgL1yoo6mi8ICzOkGoifquzv0QFkF/GhTf/VTRKgE=;
 b=dbRwJhsve1u1tVgHemAC7acJj71t0S8cg181rvKBI5/ZnhmVBJqc7FzpnQbDOlXl1kYozNNaNSYdhaKbSbPYOLkrYxikNoYZduQwIfjnmNOxRBVaZPAaxwz3btXlN0U0R0ZXVRMoNiWbxnXmnSkYtQKAPy2oCev64AYHtRFSBGbDRzhXTq/NSjT0Mv3SOq+rLZO6L0OP9IyL2lUCUDcVZ73kT6EMuReWkr+K9A5kTRNUGbOLpAd16/W9n1yk/Kxjca6j9maJ/CjkMwb7BT5b3+zqABpvxkvzYYU9CwQGl6Ym8+w+Pq6zeTg7YPnZxbGHNPBfO3IgcqaJl5gGVC81Lg==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by BL0PR12MB5011.namprd12.prod.outlook.com (2603:10b6:208:1c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 09:33:45 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::97d8:a505:950c:6e89]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::97d8:a505:950c:6e89%4]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 09:33:45 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: David Hildenbrand <david@redhat.com>, Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>, "bhe@redhat.com"
	<bhe@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Topic: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Index: AQHaY86q3o4vxPMh/EWney6fGMJmL7ES5W4AgAAHBICAAAT+gIAABr6A
Date: Tue, 20 Feb 2024 09:33:45 +0000
Message-ID: <709fe097-9cc0-4d61-89e5-65147f541e95@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
 <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
 <6ca94bf1-68b4-4a81-8cd0-d86683e0b12c@redhat.com>
In-Reply-To: <6ca94bf1-68b4-4a81-8cd0-d86683e0b12c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|BL0PR12MB5011:EE_
x-ms-office365-filtering-correlation-id: 4e5cc462-34b8-46a4-8512-08dc31f708c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 dNoaIjMy0sf/PL5yssC/mJShSkQBQA52Gt5FhF7Nv2QpWhKXvXCQlU/v6j5xRKf6SXwXxM8MeC81+sZpk7QCYOpE5TFv2NEbn+ybtuh3dXkgUI4FUDEXwfkJXOVx/mVxnwAWfTWmzt+ocfyGwMhY5R0kqPP1Q0FY8uqaEcPvDsQCNoBtqHgZene321VK+hqBUbMkri6i8RvzSw0I66voJJrJNvogeNob0ND/cOEnSw/MLB61RhbxYUBhaFVTOqPxURPX98M1p4i0b4VBBiaLj/ZZ0UMGsdJPcwCxvpNKDGNXyIf8u4yttMtLS58qkDpeG2Qk44Fd9QGsI5ZRn2KUQCjckwmLgQMaGluUUQAeOFNhFHa0rZHG5kdY/Jpnbv9/GDP+tOsgMlBUQ0bx/bDN8i4hH5Xyut05FFdK2i1CKFISmtlTWwuKuGs6k++KFNhkighThlMmKUKITMBr0sfOe+2lBG9WOwN29EP0CO4z7NhX5iqIgUkp7N4PQrIiZHtlYzxrWIRvXr2A/C6NuoD/H6KJSHuGV2UReW5oYH+q89LP3U9TWJGeGBPJkEXvbppVEAl3fXfeJitQ5l3b7nYMS7wQzGCFxKPNQuP3iMf9iJlSsHWT988qcU9EdhZSLweIIeysFAPBhU+PYUUFe9GKcA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SmNLZFJKTlp1aXVIMExxV2ZjbGVYbEVOTDZ3eE9RcSt3eW1kMnJlKzBjdlFs?=
 =?utf-8?B?VjB6TlhjZnJPSGlBdVpxQjNNSHoreTdqTVpOYTFPZTNuWnhaN2l3MnUvVGpV?=
 =?utf-8?B?N3NGenc5d2JkcnlPY0MxYVJWaTlEK2RHRlNhUEp0RUhFdS9yaUd6L0tFVFNV?=
 =?utf-8?B?U280MHZUUkw3cWVzRnpiYnFacTRKNzBWY1llRUs1N2UrMGlaaWtXVHI2OHlP?=
 =?utf-8?B?STUxZmZWdFI2bm1tbWgzbktYRVR5d0NBTGdxVW1ZRWlvUkJJbEY0a2hsWHhJ?=
 =?utf-8?B?TzhrTzBTRHZTUUh0L0N4LzRKVENBaDVYN2kxRWZaWkx5MVd0Nk5VbkdGTWVL?=
 =?utf-8?B?WVRMRi9zRE44ZzZaSGRiaTNGMTc2YlJ4ZmdjRE4zcTJCa1RzTjI2dFJrQmU4?=
 =?utf-8?B?S2EvRjNEVG00anc3WHpZK2JhL3E2RHZEWE9iVll2eFZISjZwUTdKVlljamhM?=
 =?utf-8?B?Wk9DdkowbzZWV0VIWTJsejhBY2U2QThsWXFUV3g5TFE3NzI2TzcxNExTZ2wv?=
 =?utf-8?B?dlN6eUhKbm9ZQXZjMEZzV0xhUmZKUU16Vmc3eEtZU0hUQ1BQWW1xNE9MNTd3?=
 =?utf-8?B?ZDltVm1IcFhsL0QxcEsyWWVEdlNkUHRzcFE0QnYwM0Ewc2k0VHplT0lFZTBk?=
 =?utf-8?B?WDJzSDBTUWZibFJqVk5ocmdjRGdBMVZPcjgycVpyVTg2YktMNlNmMzZ4amR5?=
 =?utf-8?B?RlNLcUdpUUJ4cUdBc0hZd0tRVmVwQmZKaHZQOGU1bU9sc2F6bjFDQWJHVU8x?=
 =?utf-8?B?MnVMbHl3cEdZOEcwa2oyUEJDTndLMlNGMnFNTU4wbGRGRlRCSGVXY2E0MTAz?=
 =?utf-8?B?SkJ0WFZncUhWMytOeWJYS3pmaXlkMW5abmlFL3lUVmcrTWxETlU1UDJQUTZr?=
 =?utf-8?B?SllnWmtiWkZBRGczcFRmZVRvN3haU1VOc3lyQytZSU15a2ViMUt2aXVLUjUy?=
 =?utf-8?B?OExLWXZMVUtxenFHRC9vNE1GY3o0WEhiZjVmQ0ZEMUMza3NiWTN6OEg3eUR2?=
 =?utf-8?B?aFJxU01NdWgzNzZHVGFUMnlNMEs5M1EyNzRjTGs3UCtoWnNIMmswd3NKeG1q?=
 =?utf-8?B?WTIwa1Nnb05CR25pbU53L1FaY1Y0YXBCTjl2MWNyNGRrTjk4emFsUXBIMDhu?=
 =?utf-8?B?THpKOVJmN2N5aTNZaGtmQlNZRXZWTy8xSTJvQ08vc0NucWxISU8vL0NBQmxG?=
 =?utf-8?B?M1I3RkRjUytmTjlmeWl5RHp6aGlUa0wyMm01eWFZUkY2eUxxOUJpUjlvWXkv?=
 =?utf-8?B?TGRZNG8vMDRYOS9wS3FzRnhGYW9SME5QTjdsNDF2aUNMMGt2TjBzb09lYmdj?=
 =?utf-8?B?a0k0aG9wUTV1RGtaMm5RUGNsQ3lFVHozeWtpUWxtV0NtZnVCMmUyQVRWTW9T?=
 =?utf-8?B?Z3ZhK2FtdEhQSy9NSFFvL2hrbEt6UXBFaTRueUhXK1VBMWtPNStWQkUvTVNY?=
 =?utf-8?B?K0xWcm1CV24wcG82R1hEMndScWdhTllvbWZtVGM3K0RhVVVpdWVMOUZuYUl5?=
 =?utf-8?B?N2ZBSUVUeW03KzVtNlN3NE9BSmlLTVFScG01SG9Oajdyd1oyUlA0RUtsWjRa?=
 =?utf-8?B?RW94bG4rajRZUUk4U2hackRvbHVhRWJyWndkLzFKUWtFeDlKTXVTUDVhR2N0?=
 =?utf-8?B?T0kxN2JyWGVEZ3BORm9IZDlJQmpMSFo2MEQ4UWFlMURlbTRjWUZTaUlPVzNC?=
 =?utf-8?B?dUhXMGJBU2NOTTZNdDc2SGhrYkNISXprQzdwSDBXY2NpSnhaU2VCcHhzbTJz?=
 =?utf-8?B?ajU1SnFSNkUySGdCQWNuV0k5QlkyQzFSVVAyQXBWdTV2eGxFZFVjdzVwaytM?=
 =?utf-8?B?RDhDd3NDaHUzdEFqbzRVRmNWV2lDdHk5SmNqeGpFSFVkQ2xhdWoxUjc2QWtM?=
 =?utf-8?B?V2w1RU5oaW9lazBnYVJEK21SdXUySTc4V29sdG9QSEE5RzVXWE0rVFZUcnhT?=
 =?utf-8?B?dVM2dUg5UnNLa2tzMEgrcnhZUitLZkp6QnhuTHVKWktpcmI0OE44YmhvM2ox?=
 =?utf-8?B?M3BaWGdSczlDamRHRE03ajhjZGJYMjRxRDlLbndjSCtMck9rS2tOMnFRVTVR?=
 =?utf-8?B?UWc5eG9pZ1dMNXkySVluVFBuclNmelZ0RllFZU1SVHdwRGxPU3NMc3hrYS9B?=
 =?utf-8?Q?fUJw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C55D8DCFD2D944B953E6F064FDB58E0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5cc462-34b8-46a4-8512-08dc31f708c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 09:33:45.3352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvsLRJDHuQ+UBKv/0+BmcZSHCy7j/ZUTfZ5aPnrgFXAbKsiNIS9uGRiSlz8RUoHA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5011

T24gMi8yMC8yNCAwOTowOSwgRGF2aWQgSGlsZGVuYnJhbmQgd3JvdGU6DQo+IEV4dGVybmFsIGVt
YWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4g
T24gMjAuMDIuMjQgMDk6NTEsIEFua2l0IEFncmF3YWwgd3JvdGU6DQo+Pj4+IFRvIHNhZmVseSB1
c2UgVkZJTyBpbiBLVk0gdGhlIHBsYXRmb3JtIG11c3QgZ3VhcmFudGVlIGZ1bGwgc2FmZXR5IGlu
IA0KPj4+PiB0aGUNCj4+Pj4gZ3Vlc3Qgd2hlcmUgbm8gYWN0aW9uIHRha2VuIGFnYWluc3QgYSBN
TUlPIG1hcHBpbmcgY2FuIHRyaWdnZXIgYW4NCj4+Pj4gdW5jb250YWluZWQgZmFpbHVyZS4gV2Ug
YmVsaXZlIHRoYXQgbW9zdCBWRklPIFBDSSBwbGF0Zm9ybXMgc3VwcG9ydCANCj4+Pj4gdGhpcw0K
Pj4+DQo+Pj4gQSBuaXQsIGxldCdzIHVzZSBwYXNzaXZlIHZvaWNlIGluIHRoZSBwYXRjaCBjb21t
ZW50LiBBbHNvIGJlbGl2ZSBpcyANCj4+PiBtb3N0bHkNCj4+PiBhIHR5cG8uDQo+Pg0KPj4gU3Vy
ZSwgd2lsbCBkby4NCj4+DQo+IA0KPiBzL3dlIGV4cGVjdC90aGUgZXhwZWN0YXRpb24gaXMgdGhh
dC8NCj4gcy9XZSBiZWxpdmUvVGhlIGFzc3VtcHRpb24gaXMvDQo+IA0KPiBJZiBpdCdzIGp1c3Qg
dGhhdCwgbGlrZWx5IG5vIG5lZWQgdG8gcmVzZW5kLiBNYWludGFpbmVycyB1c3VhbGx5IGNhbiBm
aXgNCj4gdGhhdCB1cCB3aGVuIGFwcGx5aW5nIChvdGhlcndpc2UsIHRoZXknbGwgbGV0IHlvdSBr
bm93IDopICkuDQo+IA0KTWFueSB0aGFua3MhIDopDQo+IC0tIA0KPiBDaGVlcnMsDQo+IA0KPiBE
YXZpZCAvIGRoaWxkZW5iDQo+IA0KDQo=

