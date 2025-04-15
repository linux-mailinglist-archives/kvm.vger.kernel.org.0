Return-Path: <kvm+bounces-43329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9378A89565
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D9991898F0C
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 07:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A325E27A917;
	Tue, 15 Apr 2025 07:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/Rnh999"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A4727E1B4
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 07:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744702934; cv=fail; b=G18xb0Kmh/kPuBjGu+sfgz4s3IganIx9plotv3yfTko/M3v4FQA9bW95M0oAiNhAAxpPzcabOkhV1VBl5vgR0mWrJO5nXmqu3AuNEOFpBbsgF2e5/I2xoRzty22Az45Ei9n+6gLjck77zkkXJgtd4zNrw16n03Iv/mN5vo660I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744702934; c=relaxed/simple;
	bh=Nm9+6Xr4hiwXayL9PcccOnv8tHawxoGHXHtIVENCvJM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kdHI8PSIXcu6BTZE3UCWtf5FKRQWkADC51WHtckMmN7IHZqzmJBsy5PMsj9k9j0oCjY89Qjp/lQes56JoMLul8DeVmaC/lzJ39lK0K/BKNAlFLVXLab4RWhZUMMqNNl+juyvfydFo4BNdvzWRFqqjwVDuze9n9mECuodyUa/dCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/Rnh999; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744702932; x=1776238932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nm9+6Xr4hiwXayL9PcccOnv8tHawxoGHXHtIVENCvJM=;
  b=i/Rnh999qhgudOSpYRt/v167BCq5TTZESTpb7Q57XooRTXIs0T4ZCQeN
   qtHyv+ICMcInJ/IuTEfyvQTp7PNE6f7R4xSVfvADknzOgUCe688pSH4SS
   4qra+Y1JCsmXOQs8OLS4g+HL0WIIvfux17J9VwoAfKIb5bgHOtfvsI9tx
   42M7294q2ZiHrEOrM7hcwrpAwI8qkjIFKCSvWvKZzg27JfNBOsjOJFZKA
   OqboHZ0oM1HUTW1gx49zd5Ngq5CpHuj/YlW+Cpl2Jd9o5rfE4lIn+cApv
   YC1ukYzIKg4Szy65+KdwTTw+nTiSf7euACqQSVQ40gYyCwiTiwTATWNwW
   w==;
X-CSE-ConnectionGUID: qoBbfIQpS2C0EWuUBJakGA==
X-CSE-MsgGUID: 6vXoJMWTTM6E8hctAEtE+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="63738252"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="63738252"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 00:41:05 -0700
X-CSE-ConnectionGUID: thpzXGbxSvOQtsf6la4U7w==
X-CSE-MsgGUID: Wj8h0452S42PuiHjai8u6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="134902712"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 00:41:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 00:41:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 00:41:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 00:41:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bkkmc/DMy7iMDvCEaskdPc0VlMAv1gF+AyhPoMzxa7iXcsQ6MMgLSwHCEj0qDa14AUEnqpnyhfnCFDRoLfdYTuxFF414tqoVk5QEXmMZhqCzBx2bPo5ewh7GXTMdLTBHpnKLgPeOaNLMUcJSSWpbhN/pXroBc9FhqXTUaDHmb/L41y2cwVAX0W/tX4WGT5HBRfWzVeTxz5JKpphfntfXrN/LyhBAeNNrdkhUlD9EuyrhRTD5k6BIZPhiaUtkeX2jcwthuh/aEZ44T8Annez8H/J7aAoVy5qZ9ZhZ1/3fMCSU5DsOExeZiN0UWRfZ2W8q4zAyJO9cMMwSStNAytmyLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm9+6Xr4hiwXayL9PcccOnv8tHawxoGHXHtIVENCvJM=;
 b=Px1D35D21YRZclqRAWtpV2pfqXKFjRC0WalSbQkf2Cb87KOt4Rfn4J+7TuqKrufd31AePbpqAXDv4vAhTra2kYne9tERFrwLnLEZwzQQUqvrrXWnl6Ij02X/ZKSKcEVDN0YCoFg4E4tkk8xt+iYWGWsMyl77pOhxktyPMW4uWeaKCWRua+/eIGzjIxLbYHuziydDiRCUFR8DYOwvwqENUJKp0/bFZJpJEcETDf6B83ML8vW+AGG6JVGl4d/j+GlPJJdvcb5lMMRPJAbmuKRrW3cH6PqW4cjtiRwfNqkOYMJtQYNzXHV0RzWSfFEPSthTkgV8lnSWECGg7CZDEILcvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8801.namprd11.prod.outlook.com (2603:10b6:208:599::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Tue, 15 Apr
 2025 07:41:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8632.035; Tue, 15 Apr 2025
 07:41:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2] vfio/type1: Remove Fine Grained Superpages detection
Thread-Topic: [PATCH v2] vfio/type1: Remove Fine Grained Superpages detection
Thread-Index: AQHbrUhsvfvyTSlwq0KJNfpCcu7pw7OkWNOg
Date: Tue, 15 Apr 2025 07:41:01 +0000
Message-ID: <BN9PR11MB5276222EB477FAB3D607B3238CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
In-Reply-To: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8801:EE_
x-ms-office365-filtering-correlation-id: e4456912-5361-4304-66f6-08dd7bf0de9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?tyJ8mMuu3nJOtvSeQ3uSROH70soHKPRntpcs3fcA/C8JqNYCMSWYqZ9C4CFp?=
 =?us-ascii?Q?qQlyqOEk3q5v0b50y0gibxkbV4UkCXffgCw9JBRz6S8BGKYhPDXTJ4tNMyMc?=
 =?us-ascii?Q?gg829C2OEc/1JFt6oybfnCs2EiTixyV9nklhEv5uIUFQL6hJVd1EflmQhfdH?=
 =?us-ascii?Q?thAgb9gC2K0/zWEfW1655dYdI3AYRgzTA3eFEhiQ/WybF7unx8ZeE+6ciyFG?=
 =?us-ascii?Q?91LL2jI6zdU9t62UUKi/N2z4REUCKYLGh6yTH5zGvx0wjWb1OU4MSd5GUwaG?=
 =?us-ascii?Q?6nUPrSL0s4Gdr6c50zxoHBqtyXVcp7YXGkilFBWk0xvgiKILbV9ultJXWwvI?=
 =?us-ascii?Q?2Gb8FNa7SjR+Q996gLMX70qsJ7/8V4xI9Bw6aDuCota/DtVyW//NRjmTIfrk?=
 =?us-ascii?Q?OcItYcHPD9wUTReRQvKbUiW3PrZlIf+pRPevxOOXvr1HAzewbSUC0D1FqLhD?=
 =?us-ascii?Q?m0kuGKfLpXJ+8bhq1XsVv/R17r/7M2IwjrgxQbuPjMXmPB3/3FzRwruj7NyL?=
 =?us-ascii?Q?uk/QOqR1JDYc5TzquIpyP5QJ1aWseNPtpt6Rb0PHeGqg7S6PgUVAKOIuq3bo?=
 =?us-ascii?Q?o02IaIijTcH5WVjz68wr874Hdd7lEyp5wRT+ItxtKKqBkvkcDM9IfPGOF7w8?=
 =?us-ascii?Q?1o7EhI6wTQ0YuXXncyEtu31Ev7zWI76SKItIQZJCjO64FY0JGPtJrTwSjLHJ?=
 =?us-ascii?Q?QvVFyUOfESUkZjOyjEQmaKbeJV1rdYIby5vjq6olZ3lLb/sMRTMd2B3Ben2s?=
 =?us-ascii?Q?1dUAAA+FflPp8AJZy5Cb6ZDcZEMSqqmzMArm/BsAMv48q+ovlwnYD9lbJokk?=
 =?us-ascii?Q?jfDqpV3blkMC0TofC+SLtX0jDbZTTGTYt9LRjvaoKE/8b9Y68jxM0Ox95upX?=
 =?us-ascii?Q?8wO5vb8bcqNT1vimVIC7ilbZD/rvMywxmwuUlCAWl5U5QpqL+xfyRXLfskwe?=
 =?us-ascii?Q?N5LG/D17pe/xQt1qQfBdqX9Cpwqe1fURTeNN/Gi8ZSohrvQt+GsI66551ZrG?=
 =?us-ascii?Q?HQcl6cRk/IhAWKh9CMtjEbFMLV3AYiYCr9cIbG9Ot7tAbL3CElnThFXHGfVm?=
 =?us-ascii?Q?S53tdCaHczaOd87GolGWsdBvnqPYqfSTVPqZSZ7DyS16ci9I9G/76S0PdyOg?=
 =?us-ascii?Q?o50np5id6QMPwTyu8KPl23sUL39I5URhqMeExlAI4IZ8XRc9/hD34qgrgAeJ?=
 =?us-ascii?Q?kdt18JOe6a/lscIdlA3PcMYkfMC87FutXmLxpzolNJsHG/FKy/IuWGwFOqCc?=
 =?us-ascii?Q?EbYoY+l+Nmog39GEQha1fQTMjDc+LbfNfSFIVTFWZSYlvFWiCGEAC4Tu4gwU?=
 =?us-ascii?Q?3dpSqkRIB8vCPxDrx4mQ5N+rZoCWcMoOzFdv37wz5cl3Anu812YzsmJa+F3/?=
 =?us-ascii?Q?ncNDBsq6MSszZ+3dRk+l/MzZLSzihO3PyetXOs4Paj4PWO8rB9mT+IBtgT86?=
 =?us-ascii?Q?O+TBzbJ12Mf+N2tJXFrrZioxpgfRbtWdLRXY5qHpuqxUGqhOsRiJkg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7hVPXKPGCllZJ4ok5FQ6RCiDGFh++1a3gnX7CcDqPunfSAhVAT6xqLNzFS8k?=
 =?us-ascii?Q?ZekMg+4i+DT52WBr9c2e4OantGQGGQDNavAxLtjgsOocFogXHDyYG10ACCU0?=
 =?us-ascii?Q?NCOIEvUdO7FSBr70CwrSoBOmrYta6Qwc+GFgDHk16Y6JwuzKR2BfD+OM5/4A?=
 =?us-ascii?Q?/IRr0XWRCHHpbw9rOO3IzhTPJEeBjUL9E9Tf0aoMSzfsCVP+3rA4J4ylY2Ga?=
 =?us-ascii?Q?6C5zlQ/phe4yDEenzkpyh0Phr2l1qQwE0inqrKwioU+HVnc/Oc+MDo/Q8aQ7?=
 =?us-ascii?Q?+q3cO+RVnAYrSPePipMfKl4ETpBZY6FqinFkTyRuIWIJjfQz3ObyKxG3VnKQ?=
 =?us-ascii?Q?wBOFskV0oEvExLPD5rMUu9eOT8yCgIBaWo3UCSuhsArt+sw/59vWF6S/OC05?=
 =?us-ascii?Q?vteAep5XGgT3nULkLg+tvR+CGMghDqkJxrwUEHfYFi35Vt4NxunzpQ7Kg/bK?=
 =?us-ascii?Q?3WSfMGMxcQ32ejMqgOGBoAvq3L1XDusiFfIw9qPtKSGWo7lF72VrvUJ7sPTS?=
 =?us-ascii?Q?x4j2GnLvON1bpVAmyVMK2AGIo74arHWX69B62Ru+/R+CeW5K3k0JQrGaUfSN?=
 =?us-ascii?Q?2zJf3hxF4Em2VQgUNMZyhXo7E6terTiaOUiX8VXHx86E1cfdLLppZL8/OLdm?=
 =?us-ascii?Q?HS+I3cviScw+6GVjL5jONux+QLSlFvVjj/rNaXouvMsLCgRrXWdqoYp3ysde?=
 =?us-ascii?Q?xoDPeglnpGQOCvcO3HFjzVQDVoj/ZpPmUZXoisnIkvfkMi1S16rV/aR9ZYkO?=
 =?us-ascii?Q?r8na13mgbhdSlgXOzXh8onacTptIaavnPCzm10ba9m7pcnryrBxTjjoLymaP?=
 =?us-ascii?Q?/ilxXN3sU9qpt1WWXlEviMKV7LBZYk59uoxz9zP43A4bizGJ6MRFHj2Dmoqn?=
 =?us-ascii?Q?ZDSxr0Hada5RZQ3tV4vPKhSdqMLyxrmZVHkeI7zp8rLuEgwwjVfoA5SKsku2?=
 =?us-ascii?Q?Gbo+jjjP6n4gDBCLZCLJh+EvvVnE5tF1CyC0IvlZ7TFkWo75/65K75sUTZep?=
 =?us-ascii?Q?Y0W/l79QHPy2dv+640ky/0YHkFRKjoquqWOqzROdRU2OwRfSKSNvNt4FPmfc?=
 =?us-ascii?Q?Es8LxBNweAjSf54zqi5MS/99K09jFZQ86tnppPeYT3Fp+qyNbqUfx7heMYVh?=
 =?us-ascii?Q?H3PAnbB5z8UuWNQgi3KKE2H6MHFTHVsDOmjBTapfTlsMEKE7+wdJkL7Mlc3u?=
 =?us-ascii?Q?ze0E1ZkyotBFyOa5FFtXjZkF27cvuLDx3/JDcrVzEbPM9pH0mPrMhkN/p/Vu?=
 =?us-ascii?Q?CdWm64hYrrkBlYwTXVjDV8H5Onhmn9DEqk+i01UBrYEa30KE0zn0PHd9OlgS?=
 =?us-ascii?Q?08m7c9H8gUgAWdt7D96tbx8iM+J2Frh+uHPbvCDe812VF+bUcq0H3c/G92ZG?=
 =?us-ascii?Q?2YKDXb3IjxBnuN0Ba+b9yOHLfUjbWJgImBDLSvCkSrjDZ+MWYpaTEUvu/5YM?=
 =?us-ascii?Q?+N3gzIgJeHwDVec7GNh2zYTsU5941EV7SfBlAQCKdce7zKb9dSfBZgrpzbD5?=
 =?us-ascii?Q?Tl7p+K+Vu3VFubWYvcn2hQoJSfnTdE2tdZ2gpwUZuAARdsjxyXYUwITRUhUr?=
 =?us-ascii?Q?GdQvaX+ccCZ9BGIULvgjtFpliVB+hYZVN17nJHMq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4456912-5361-4304-66f6-08dd7bf0de9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 07:41:01.3496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+hLbN3fkC6LIzAYcl08CoGBlx48qeua+q6C40B9aYWUcN/9iIXFYHroD5dl9SluBc6Eb6vQBqHRKZrQCv0qLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8801
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, April 14, 2025 9:47 PM
>=20
> VFIO is looking to enable an optimization where it can rely on a fast
> unmap operation that returned the size of a larger IOPTE.
>=20
> Due to how the test was constructed this would only ever succeed on the
> AMDv1 page table that supported an 8k contiguous size. Nothing else
> supports this.
>=20
> Alex says the performance win was fairly minor, so lets remove this
> code. Always use iommu_iova_to_phys() to extent contiguous pages.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

