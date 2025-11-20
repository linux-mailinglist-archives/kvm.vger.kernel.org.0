Return-Path: <kvm+bounces-63889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DDDC759E4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9A5E94E5B59
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98823346772;
	Thu, 20 Nov 2025 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WhWJewt9"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBFF18DF80;
	Thu, 20 Nov 2025 17:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658803; cv=fail; b=cZMtZ/WcRndLy352712NiHmuZ1AOIHgN4Zk6dT5U8ap68vNKVSMzFxFl84RM2myRevnM7eq2dzVasOyZfmuVGFTNhwQ1t7lYfwT5TXdmbbKXrNRFxmDIzUHNie5HcAuB9WATSwTP6i8MSw4Ja0wn/v9haYvTlJaDnwvUKQQ264E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658803; c=relaxed/simple;
	bh=ueReyUd/clxUCPeYxsUeGzslCCZDKn3U4DhzTjw3Bhg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n6gJqErEVwwj+IGO6TydnN8Mzt/m0aU5JDU/S68lT1mnr8FY61C1bEQNMbWf6V5+Ot/sLPxTO/kXeX6PLRjgzAw7eHdZKYTXC8IxiQFPB/PZbDSZvFiUy+x5y2wmL6nGNpYNCBoLWipvUdYw1pirczJexCcru5KDUXNiFUqAhr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WhWJewt9; arc=fail smtp.client-ip=40.107.208.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwlguWTWs4dEHYvVYsWQKogU3JCr5usPFPPpuryhTSEDQ0Pw7KtHEDw5B+YnoG/OC6nDsMSQQ1lN/uheFLWFVkLPpeEuafTc/U3iEDiotQhHytlYWu+Xh3MtVdkkO5J/PdTCIqwIdd8gGnqtvD3H58ZPsy+ai11hbmoHIidZg8kIOWshP2Lh8ldfO6LtToGfqm3MqM7UTlpF7Hp0/r2eVkPGjlsbrJDnXN5RmbPUoxzONT/ufb3kdihzU8EP7jmQ2jTZTiNDdBFOr/rF5K+g7Tbd4nZrtRS1egSJDCG2RUBFrYnB/xYJuwH+KbE8eUbsXtuPDoACaopJ73MUUMB7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueReyUd/clxUCPeYxsUeGzslCCZDKn3U4DhzTjw3Bhg=;
 b=V1u1ilDcDnXkLTkgm4JAKscpE3bqk4co9r+RfRpNGuibk2Nx4mNgF0oqSr9D2UeOKcnPVCWaIVDRL0wOeQMzY3Ka5yf1FwYHl276H96E9sxMnOE7wySiciUdj6MDzyHrV0mm71AsWhtpLbMMQAkntliC9ITMC2Fbr2+XN16gmlV9hTbCIIVuNJGTWhVi7+3K9lgvpBCcO1+F9fjyzKIcfW2l/q6hFudAgdu9NbEiKLi3rejoQZ2ijfvI8Uu9M1jxdnCENa7hixJmQbA0lBHb/ldhaPDtido2Gi1RrdLE//3IZBMug3M7ZR/EBT3unNiqqq3/9O0GTJQLAxkbd+zgZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ueReyUd/clxUCPeYxsUeGzslCCZDKn3U4DhzTjw3Bhg=;
 b=WhWJewt9cWxCfLOafluiv3qZUVgaWFyqM7PtNGk/8if9DYzvXHrTF7J0pFvtWoIvvhtsaS/DfH7A2sCJh2L/wcSfz/WElMSo8C6xiUxcMH34l+Sdi6Yitc3ECfPsiFKkfkb9ZdGFvGkqcuRL9HqRv+BIXlUpCmCG571hxdTy5kiZH83fGfGZPU7rAYYiTEq1FpJnUEL7S7dEkE7KsZm204Qge9zU9fOQMGQR3/5YikwDqOqRUlfp5JetEMXqYIwaJfRrlJhRK3Luy96cPAMgFJbLHTPXptOhBY0paKPoekqzz8q+V9JLWoVOyRyMkfsOCJY8UDojonnXWgm1bwmLyA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS5PPFBABE93B01.namprd12.prod.outlook.com (2603:10b6:f:fc00::65f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 17:13:05 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 17:13:05 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, Robin
 Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, Jonathan
 Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, Yishai
 Hadas <yishaih@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>, Kevin
 Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>
CC: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, Alex Mastro <amastro@fb.com>, Nicolin Chen
	<nicolinc@nvidia.com>
Subject: Re: [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys
Thread-Topic: [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys
Thread-Index: AQHcWgAs+ixHoXcoSUC3aT08aR+6zbT7uJlO
Date: Thu, 20 Nov 2025 17:13:05 +0000
Message-ID:
 <SA1PR12MB719993F747B09154A3DDA788B0D4A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-11-d7f71607f371@nvidia.com>
In-Reply-To: <20251120-dmabuf-vfio-v9-11-d7f71607f371@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS5PPFBABE93B01:EE_
x-ms-office365-filtering-correlation-id: f48bc750-6a3a-4945-18f5-08de285811b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021|921020;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?cjIaEK/tVvTVZXpwpovCni3KHELH8hQF3811i+HBgT7osmi1W5M7lYrRym?=
 =?iso-8859-1?Q?m7kklAcGtKJlS/XSRYwQnfWUdg8IROUd2fsS7DyscezZKa1dlQ+GggrLGo?=
 =?iso-8859-1?Q?knTmzwY9VuDNB6pXzcqcof1IQ4Ic/OajQSk8EShMConIUjyESs01do6+Zq?=
 =?iso-8859-1?Q?OBqw3TIqS1hacvYIq1c4RueuRDj+aeD21L5AzMmgYlYHsJidlRnhim4U+Q?=
 =?iso-8859-1?Q?dtluwfg0sMsh4Lu5h4J/OIZcklrhB6Ht8Zv2R69H/2m92qVdWCVUpr32Es?=
 =?iso-8859-1?Q?j8kjZR5/HuIFsYnPqiFj8UlHAGBOXWwIZJ+iU1bpWcyA+C8NE09fLs5GZP?=
 =?iso-8859-1?Q?IhsF67h5KvUqUsV22+uE+NHPyi/AtVvhYLd5mLv849Y5b1r4XTuQ17dHDj?=
 =?iso-8859-1?Q?VQ4oRTJeASJE8439WE369lXBUpGozemRcKMiAnADtjm4IAmXXhrRUHUbcg?=
 =?iso-8859-1?Q?vxiaXCpptaVEAn0RTWsJc/vhJ4/aX9Fmx7ex8ER0Vp3+eVTYSBKG+OqCY3?=
 =?iso-8859-1?Q?aLsC5ia9uM9uM0OyTHBsTcSWoDrCpAYzJr90Vd1wMfcrj4e+ntFOAYlEhS?=
 =?iso-8859-1?Q?C1HIsOJTpaMJGhOWzAs9F5Q14eAYkeXZYXLelmoLAGYKHISf4asxAkEOqI?=
 =?iso-8859-1?Q?InGF6m5DJSR2KxVW0TTtHnZgJNyVFI/GJyWH0RPiF0LF5087rltlFGLbXv?=
 =?iso-8859-1?Q?TH0mN+bGJG62S0zgnK6b5KP5wqz7gOtFUK81pcpwyGSALWCjLFYcUYix3l?=
 =?iso-8859-1?Q?MTusY8VTfYHwDUJGUq25dvrBpNIrHHIoUMGB9ouW/ab3+wbq2yu0j2aGlB?=
 =?iso-8859-1?Q?Oa1iE4I18PwROF2P332rknUaGRkcs6QTMV5wJZFEv/3mLj6N+PhI/E9ZbZ?=
 =?iso-8859-1?Q?WCTtu5KCdAr1jQ1HOmvjAMolcX5Cl/6dIMsy8iVVd+VXR5oAM6MFhcP837?=
 =?iso-8859-1?Q?Y/kUN11ncVWlejYV5T4DuV2HO1ggh02fG/djCa/NP6ok6rJBshD2EbUrom?=
 =?iso-8859-1?Q?vgP/HcjyZ0vjxUURINun/gBfIw3IBHl/JXzTU6XrJMIYJGFwU2Vl38xTC5?=
 =?iso-8859-1?Q?dRPzzc8SX47p/9Gzzw6q+j+n/x4ofqFZpD0W2vwd6o9GX2YTWl6h4Kbr7b?=
 =?iso-8859-1?Q?hH6WGHVFaqAjWGORYBrZOyWE64UdYsay6obB+j899aR4+vGhPYjhVmYTVY?=
 =?iso-8859-1?Q?EI2YDVMIs/FB26As2Bfi37vGX2G519OzoxVkXy13J0E7mJI/6iawxOcpRp?=
 =?iso-8859-1?Q?WCZPRA86N0RG2PnLDkb5uRsmULCUbmVny/vcPNwgRblBvnD5JrVxYeEBi1?=
 =?iso-8859-1?Q?6ayPCJBB9V+2FGamG7/2VY7qpwE7T3OrUfdiNXbJnYSdImXojdVfKABqn8?=
 =?iso-8859-1?Q?tzIBLEIytFkjhwp67CqoUukqGX9FezOMJvWyGu4xRbnYKGDfprYeJRKhHu?=
 =?iso-8859-1?Q?LtDHDJdiGcNFlTWbxmTG/aPugQr2zfF5tPJqD3CaY2PXVMYABOvouLqTde?=
 =?iso-8859-1?Q?b9691L6jsriPcben23rJRs327Kn1c71O9RqlAKLNAjqfRSzMusVJwS5gpr?=
 =?iso-8859-1?Q?72UZ9TMPTWkbOkVNyBZ/TeCuAn82a43OvEKWbKiaSdKBYVpC4g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?bM3zs/GB5WQ5w6MS44YWuO1rWrybf4KPCnHuPwF93xwb2YCUtZQQFW/+ey?=
 =?iso-8859-1?Q?BPM13CQ+CiG018QzMGnt7PGhhOa7vclGHI5tWP26ePUCUXTKLEoaENjrVw?=
 =?iso-8859-1?Q?/MbH2UqKO3i1Hvw9Apwfx271cn1DaVa/PzmblfmB5CxqkzE3uw8B8PJJZs?=
 =?iso-8859-1?Q?p+uDSmsT07Y9kiARfPqiqSmFhtGQlpaojdY4QWhswt+JALrf3txGRAcWJq?=
 =?iso-8859-1?Q?MGFqLSzoqOHFXJ3rYIoCVh5fpJIIVWf6DuA0sP34KheZUmk7NrUYCBwqR/?=
 =?iso-8859-1?Q?AWlXmqyi6YOeQ4ruHnmhQkm3vsIlk2s2QsJDhpnWHharQHCtEi/frrgTMH?=
 =?iso-8859-1?Q?nUP+aiFDQ0Sf01IYl9W+KT8KEjNyI5P+aJytDHEQZYRAWtJWlyTCjEPD3v?=
 =?iso-8859-1?Q?aNSI7CopcUSo7XpRSx0504UrhK+qida9tl+k7DlDiTkfIzbr36sefSg5el?=
 =?iso-8859-1?Q?m8YBUJ/u9dazsnEIsa5z8A+Qh/3aAhsehxQSDUt2TTr14MqNaw2mW9AnCR?=
 =?iso-8859-1?Q?O2ejTEBn9yeg8P+nYc8Oo07hRjHloI9jrT1hhY7QbblHx1iczmgOEAAXpm?=
 =?iso-8859-1?Q?UOYFv3oBE3uozP6JW09P+hTWOICr+VrAbIHtOYsMundVMR83jWR1KsM9YK?=
 =?iso-8859-1?Q?JLogRaekCJil6c5kcwrrINr3cxBocM/O879aHc6Jf+kDzdB+sQKhDzPcVs?=
 =?iso-8859-1?Q?D9pPZTsPAwatUFQelJXyK9w+mLeRA9mX1UqxBQUYukXeD43FcxMEbJykMT?=
 =?iso-8859-1?Q?THRAxveYQfp+tQGgFZqNZHIkQpE2N/+MVWrWqTS24P4Y2AfElTiFO8+S6s?=
 =?iso-8859-1?Q?0UfAnFIBgUgp1sDSlOSw8E/GXz0IIJPCzCKogpMFDdnWBZ1P8g6DpVU0ni?=
 =?iso-8859-1?Q?UOFC1Glv1zv+7ikaaafioQ4NvGR1bxy19nQ8Oh8MbPtVijOLRcXiT+IB6w?=
 =?iso-8859-1?Q?Jy5x2scVvEGBKBLYSsty4nfsNVJoCuxMkHrWG2biWDlbJaAPtnNUn/n7Lh?=
 =?iso-8859-1?Q?tY/suT7DvXsOmjOXURW2aCFeYmpZIqOSsKJkX0ttPW9/t3HrUNDrtACo2u?=
 =?iso-8859-1?Q?UaRQn/43/5DX0xJFViZOp4nTluyOHYy2Voi2pjnWpTTIaUMw6yyRh/Uh3X?=
 =?iso-8859-1?Q?bfkfVrrvBYZ3tVdNsSMVOQBj53Q8/68gr3DbKH1ZsTUO20pEY76MnNcWhS?=
 =?iso-8859-1?Q?h19wh0VesbYFy124LFo07jpyAJHQfEp0ORPmM+nYxHvYtg9j2fvPPatTY2?=
 =?iso-8859-1?Q?NgrKgf5e+8kh1Hns/oD/imXX24wNhkn4WpEHJKXkKsr+xg7MEBqtX7q1sU?=
 =?iso-8859-1?Q?+JwskaiS8Uow0gUKzdT20FvRfqgI0cpWdNA2Yz4iJDtRy64McqNKBcq++I?=
 =?iso-8859-1?Q?23U9hDSJIGE9cNYLIJ+Vt+eEXqud4AUdX6hAjaJjWixjQ2m0mHWHfpBxeP?=
 =?iso-8859-1?Q?smAAHcKYosb9QFTsyDSFmqmowjG5eC29ZQxgHA9B9n4h64bL8RSJKVvJhU?=
 =?iso-8859-1?Q?1Xdk/Q0xx9yYacdet7578SmBNT6iIcR6mKp4swzZXR2IJhgCnlh6F7IK+K?=
 =?iso-8859-1?Q?8Uuc5TB9FjdZSdGM6Npw7IDfzqjfm/Mok39u9G2f6krWbWjyGuR5PGqqPC?=
 =?iso-8859-1?Q?edu99kGoC9Cag=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48bc750-6a3a-4945-18f5-08de285811b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2025 17:13:05.2368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g21sYZC9KoTgR7vpp+ZqzPYvTNoKNmeZbGKHTWNmdiPEYzcsidZk1+O10LVnwkfN0dTZr4V46jQKjj5xIEES6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFBABE93B01

> =0A=
> The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI=
=0A=
> MMIO, they actually run over the CXL-like coherent interconnect and for=
=0A=
> the purposes of DMA behave identically to DRAM. We don't try to model thi=
s=0A=
> distinction between true PCI BAR memory that takes a real PCI path and th=
e=0A=
> "CXL" memory that takes a different path in the p2p framework for now.=0A=
> =0A=
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>=0A=
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>=0A=
> Tested-by: Alex Mastro <amastro@fb.com>=0A=
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>=0A=
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0A=
> ---=0A=
=0A=
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>=

