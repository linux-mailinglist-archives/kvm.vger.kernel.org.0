Return-Path: <kvm+bounces-18263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2068D2C74
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 07:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A84C81F23800
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 05:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C9615CD54;
	Wed, 29 May 2024 05:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CrBPCs4u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C1415B543;
	Wed, 29 May 2024 05:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716960961; cv=fail; b=FRDgFva20nyQEjodnOum8hDWdB68gd7Y0kbiQN0936AEg9DGzjELOOF4EO+VqPCZH75n/r4P5DL6C5/10RHpSPKzcIVvk6vwzfKOkip+aUHWta2oSiPZWmaG5hDSceKTUoJRM1qcVW7tnzAIoj5qSp65uC2yF9Y5s3vmNgC7qsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716960961; c=relaxed/simple;
	bh=c9StK0UnoPHiQm2dQa3+YleetCRIAKuIJlLWXJBFFk8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AqcCeZopFvDyohOLKT74NlitP/cEXlk6zzFFzZCy57nvdaMT1nQuTev+3VWyz8lRmfDRgl7lcL/H0K7OkSRaavhxWFs7BaA/UFLsMKk0na0ha6PYMlHhqTlcAU0dZFgjrFw09d9HVYCn6Q2l+1zRfvb7gV9Ww9BVTpNv7oRFl6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CrBPCs4u; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716960960; x=1748496960;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c9StK0UnoPHiQm2dQa3+YleetCRIAKuIJlLWXJBFFk8=;
  b=CrBPCs4ua0eTFJx+FN91Rqrgxnl3wgU4PrDVvWfJDRuvC/4RYpBXJGff
   i1GzPmWapzL61otUy4mCja16hAMG+mF7deDRuzd4XUDkKmscCUOCWQvio
   OWTKDAHnuUcRAHv/f2VvFXjo+Qw7McxVqC4LXQ5CDCiDsQB/7EN9qWosM
   gybIXez7O0GnozTlA+BLdZt/zVx5XeQ7tfm6FdwR56cY91C/wm939rcGy
   S5Ua8mC7kYppVU68dJISsgKQ3odVCLPwHzXPs1+4+ZtFWf8jp0RYZ9/0l
   XQwgTibc3cwl2zwSafNVXSms9/rzV5SUcdxnfUOYdaHWflqmmSLft8T85
   A==;
X-CSE-ConnectionGUID: WJUP3i9XSriFsEqHdus27Q==
X-CSE-MsgGUID: JtafFXmjRZa/iNvKgLOG0Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13114903"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13114903"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 22:35:50 -0700
X-CSE-ConnectionGUID: sBiJB/4/RJWz1+qid5ycbw==
X-CSE-MsgGUID: eTx2ubcuSf+38i2+0lE7lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="35366827"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 22:35:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 22:35:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 22:35:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 22:35:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 22:35:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX1lJnFApNaaZdJMo6bX33nhxsk5/JocrfR1okJaGM3FvjywEudj6G92WlqRzk+6Nm5DtS8GjVCUrEbiXVe0alixjrKAKquSigXDXa6lcKKsRScr9LMrg7bJSWjDsIOGzwBe4AxhzSUWoOr2ASiRQG4CGmbV9weXCDagwUMvBD7TG/ZSgMNnYL9f9vFULH5nquzn/noflMQT5NibDvRHShkjtH7ovQQ8g1xXXF+FkdJ1cmbkxU2LT2kNcnyZ50A/bN4QPWth78fav924M33JmqELW2F7f8tcY30YwY4uzAmjC1maJWaqYjX0UQkCuL3g7iZ3pC/+EsN3Gaa/I7gZ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9StK0UnoPHiQm2dQa3+YleetCRIAKuIJlLWXJBFFk8=;
 b=UzOuSuvKWIsprhLk21RwPikJ2NH/UcfZwngcb4SUjK+LIfCxaedT2LxNysR53DyWg5b7XE69pM0PKw7DOSHzFClKOTvm7yOEzdf73IRPuKijaPM+x28oO0ypktMlcmVuuTX8RBQ5VWwlCAYZZBirxhej6PvzGlwIGorm0B0Xz9HglGQsIv+XkKrBn9xJ/stq2WUP+07QlplSK2rO3r4RcjE4BKHNItxe5BHHkp8160s3hMZ0f6+cWuiHa9ulgcjfCNpfvudYLgvGFE7K8wURimVqMBS/XxLSKyPZ3Ohkwgs9PTPrQlsnUuA+Tw3qvd5YUNAV/1R7k6JWRD3v5BK37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7904.namprd11.prod.outlook.com (2603:10b6:8:f8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.30; Wed, 29 May 2024 05:35:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 05:35:46 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zeng, Xin" <xin.zeng@intel.com>, Arnd Bergmann <arnd@kernel.org>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Cao, Yahui" <yahui.cao@intel.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Topic: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Index: AQHasPdozFJ7uzjsf0GWpzSyP9bM07GteM2ggAAQ+ICAACbXMA==
Date: Wed, 29 May 2024 05:35:46 +0000
Message-ID: <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
In-Reply-To: <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7904:EE_
x-ms-office365-filtering-correlation-id: 1eca972e-8fb1-485c-a7af-08dc7fa130f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RnpLR3RYZ3BSV29KVXJtTW42aG5uc3YwRHhCTkZwZDJKWWNrRkxTQis2UXp3?=
 =?utf-8?B?ZzNKaE00aEpsS3dEdFlCbFJCbE95cms5VzZTY2hSTWlBZXkxVTFTbFJ5WDJv?=
 =?utf-8?B?cU4vMWRSUW5WS1BCa3JGdzRjSG84U2F2UmJ4Y0FBVjArZVYzdjRZTUdZL0c1?=
 =?utf-8?B?aFc1RE1hY3dBYjNrR0ptMHpGR1FnT01CN21jSFBKL0d0T1d2a3VBNGdUVGY0?=
 =?utf-8?B?REROZjlNQzk1WjM5NFF5d1F6MmlhK3ArZEE5d0ExUTJlRlFNVWc5WTE4OHN6?=
 =?utf-8?B?Witab1I3TTJRY3hXQUxpdGpHNjhFQkZyZVZZbXRoRXlxL25tTGJPTlFwamJE?=
 =?utf-8?B?dWxWRmplYm5yUXhjc2M4VUpxOGVxdXAwQWNRSWF0ckJ1UlJxNGhYK2l2Qm9l?=
 =?utf-8?B?bWc5UHluTlhBYjJrWEsrcUpCUGRUK3RqYUtBYXd1OXZidys2RUpkK016Q1lO?=
 =?utf-8?B?QWJidHF2aFhRQjdST2xQeTRwUG9MRDVIbTh5aVROVUlDSS9jMHBwS0EvK1lz?=
 =?utf-8?B?aVRWaXNxWTZhcVBHSTRzeklSZTY1VlltMENWUkRLdzlNT1NERDZnWDJDT3k4?=
 =?utf-8?B?WWxXb3lYL0hqYlg4cGtyYSt0YU5PQTJ4dGtrRW1FSlBIRGxyK3NsSnRCSUFJ?=
 =?utf-8?B?ZUZXK1dzaXZQK2FqakxBclFyei9ZTUVZM1VmU3IvbFRDekRjV0MzYWlrL3B2?=
 =?utf-8?B?SzZScFdRUnZJc2FWVm1ZclEyV29JeFJRbzltMkNzMHZDRHVnMU95SWhyeFJt?=
 =?utf-8?B?RkswNndPanlmRnZKVWlTMzhDVGxvRHNvdGs3MC9yOEl4NnVVQm80ZzRIUVFw?=
 =?utf-8?B?NU1iQzJaVXlCNTdoTUVnellaYkcrTXQvcklDdm9IUC9Gd3RDU1RDYk9wOVpt?=
 =?utf-8?B?TXBpU3BXb0dJSStOM25IdHlxOTUwU2NaOStUeXJ1elRzellmbTdySnY0aTJs?=
 =?utf-8?B?ZTdWb05CNS9EVXR5YzBkeTFTOWxRaVlaNXZULzU1TWE5bnY2SzVWTVgwMkxL?=
 =?utf-8?B?UGRxcHJrdjg2cjZobHhZR1dFWFAxaWRJWWw3ZzdLZnI2ZUVycUhZM3Y3ZDV2?=
 =?utf-8?B?NmRSc2ZIbWpBM2hZcjBzMEVMYW9FWTVTRDdpaThJL1IxME9DdmFESGtjWEFX?=
 =?utf-8?B?WS9GTlZLN09GMTgzeklnK0xFeWpZYnZubExGdkZmNlRpZ09JcDVjeFRhY2Rt?=
 =?utf-8?B?c1Q5RGVJWGs0QnV3V1hSRVlIcWNjeEFJbHArWnRYVmpKUDNUN000YWlzQ2Z3?=
 =?utf-8?B?YUVUQWpodkMyOEtvVE0vMHVYaHk0YUQ2K3N0YmZ0aHUrTzN0OFE5OXp6SkN5?=
 =?utf-8?B?b2ZFYkVYY3BBcndNOEVuSGhGZFROK0xRaE5TOU9KQXZNUlhpT1ZKczR1T293?=
 =?utf-8?B?eWJCOHp3SVZzaEhEUHVLSDQveEtybGNWV2xmSlFLQVZYYmp2OENNNml5RlpR?=
 =?utf-8?B?aHdReEFvMmFySlF6SHdnSW03V1N1R2FNTWd4d2dzbzNLRmt1UTc2K3NXSk1P?=
 =?utf-8?B?ajErWERlTW5NR3hSVUUxNVFCOTcyajRmcnp5QVhVaHRoL2lhVXkrVWFTNldN?=
 =?utf-8?B?bkJzRXVmOERLb2FyNlkrUnRzT0docUNOVVEzSXNIZVNmQ3RiNFZ4bGszTFBm?=
 =?utf-8?B?REdXQzZNcDRwVjdCZndyYUw3UlIzb0lxRmhuVlFkYmVLQmlvTFJ1RURWellx?=
 =?utf-8?B?MmI4MTBpV1NUUXBES3NhbmhDMmIzU2ZVbys3T0wyNDNncXFaMFJxZ0VvdVZT?=
 =?utf-8?Q?VVsqaYIYWQgTRITXsYmhWHS9RLIHUQ/vdMoV7TF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUhQU1V2QXUwREhSRGp0QWgzYkRwTVRvTkwvdVVWMEF2R3ZFSlF2TXAvZU1i?=
 =?utf-8?B?ZVpMMGl2VEpvOEhiSkhueWliMHhHYzVYUzNMbUtuS1JVbmJSS1ZIaERRRThD?=
 =?utf-8?B?ZXNTN0JoT294SG1kcVh3OU9iMzlCTHFOTnoyRk5RMjRMZjlOVytUZUtOSVpu?=
 =?utf-8?B?N0dwV1BGVjB2OEZ6K1A3WEVEVERvcVhQMXZoeWE1YS82bkxDNDhIa2svckFu?=
 =?utf-8?B?U2pNZVMxK2hpQ3kyMlhDZCtTcWNNMDBQN2lUV09Ka0c0MnhDdVJKeUZFMS9y?=
 =?utf-8?B?ZzNXMGkySVZSeEkwUis1alVUeWJXUld4VzhxSEVWK1pwSW11N24ySjlQWkR2?=
 =?utf-8?B?ckUzOGVxR0MvbUFUdXo1SWZIZHpaMGZlYlBTRG5VVjQxT1FrbXgvQWxVUFp6?=
 =?utf-8?B?QUFNN1FjZnV3K3F0RFYrV3lnRnpRMld6VktQMzFJUkxrRkRGZ1ZQM2FpOEJx?=
 =?utf-8?B?dmxDSHNJY2ttL2J0cnVKblBVTWRRWkdJVWI4bDl3TU1zcnJjTm5NSlNOTk8y?=
 =?utf-8?B?NjF4aEp4QXliN3Zwa3ZYUEdPZXV2bHdxUG9MM3daR3pXSlNMQ2ozNTZ1UEg1?=
 =?utf-8?B?VnBBNVNzb01BMGdNVWRSakprcmIyVWEwVFZFSEpEQ3plTXFmTVZQazVsM3M5?=
 =?utf-8?B?TU1FSWVGWFNEUVBzbmZZVmZwR3dWUHVWemlUMXMrcDdFSWZNQThQVXYxcU9x?=
 =?utf-8?B?dStxcjhPWDlFaDA1UDNUcHAzT2pNSzBVVktWSmEvRURkWHo2VlRtbmU2a2o1?=
 =?utf-8?B?bVZ1aWVlM25sSm9HdzFyWTdzRnltM3J2L28wOVpMNkFZR0R2a0pWMmI0UzBx?=
 =?utf-8?B?RHc1OTdGdFZPQ05xOEVIY3FtK0lBek40NHJVTkM0M0RJOUxsZVZUdHNoT1Vm?=
 =?utf-8?B?R2d4NFUrRUg2YzdQUFQyTGtuZmZDOHVCY2dtSDlzYURXYjdmTUdxTEtxblFH?=
 =?utf-8?B?Q3FEdno2R1JwSlFGMUZXU2RyYXRnV29aQnlGZnpHWmpTSSt3ME1QMEJDenk1?=
 =?utf-8?B?eExueDY3T1ByVW1SeC8wYXpPUE5yaHJQY2NZUC91SytCbnMwNlpMOVRRY1U5?=
 =?utf-8?B?ZnhTUVZmSTBqUUlJTWhqcW4zZ0hianZxM1hxTGc5M2pvaXgxOGNMaTZQTkV3?=
 =?utf-8?B?NHI2MXE3OW1kVCtIdEZwWkY2TS9IbEFuQkxJNHFzaWFMcW5BczlzYllsUFhC?=
 =?utf-8?B?cG5wNE5CWFpOQkIva0JuRVFzamhBNzhQVnNsWEdCdFI5SGlVdU5YTDVqSDdV?=
 =?utf-8?B?TGtyZFdNMXB0ckFoNEdoZWYraTdRbGEyUG8vVTRqRWJxVi90MnRIVnFPZ2F3?=
 =?utf-8?B?NDJzeEdVMi96NGpVcXltbHVhbVJPWEVjdWVhdUFNa2JUU0ptS0ZNY2NxV3NR?=
 =?utf-8?B?bGJweG54Z05HemE3MkE4MVZNcE5CL0JSWXkvVGhrV1hVSThtNTZlS0lJcERM?=
 =?utf-8?B?TFhERDRtNnNFck1ZenVXSys5aUpqT3VVNDFHTUlyR0l1Z1ppQ09Hcm9mTHdr?=
 =?utf-8?B?WHgwdys0RkRTU0hmWld4ZXM4SkhZdU54dFNETTVwcllWNFhzc1lwcUI1dlN6?=
 =?utf-8?B?ODB1aHkzZGV1a2tnVXBSSS9MWUliMGc4amowcGRBcHFmb0s4RzBEejRZZXQ0?=
 =?utf-8?B?azhyYW5XMTFQUnZ6WENXN2NORjZTQVVldkd2TlUwaVB3NXdzM01QbW9aREli?=
 =?utf-8?B?ZFRXWEk2MU03Lzl4S2l4LysvaytLWEF6SVMzRWpOR3pzNnBGa2lSOWZMdkp0?=
 =?utf-8?B?dlFFUHdGLzRuT2NQU0VrdFpScDhTdjI3OXprMkd6cFlsSm5sdnVoNHVNZGt3?=
 =?utf-8?B?UXpEa3Bhdi9hRlI1QTBFNCsrWTFBUE9HTWJ5QVlqUnJMVmcrOXdJOUROYlpK?=
 =?utf-8?B?SjZsbC9QV2szKzdqbzRZeGR1Y2hMRkpkdDFDSHVYZHJ5b1VsU0R4dFNPdDdU?=
 =?utf-8?B?VEdoUW9TQ0x1cHhwb2srTGJnRDRKbXlXc2lxaXpTK2o2ODhzQzFuSDd1aWE1?=
 =?utf-8?B?N1BFSm5rYjlCbWNzNWRic2w4YWVEQnVCSU54dFoyMXViMFlLSURKWTJkVkVs?=
 =?utf-8?B?U2pMZXFTOWNlZGpOTmZ0ZGtqajlLL2o0anM3bU1tQlpZZTltaFovemRyNWIv?=
 =?utf-8?Q?7PT/V0ccc2HCJk9k/pYSv6wy5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eca972e-8fb1-485c-a7af-08dc7fa130f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 05:35:46.7324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGBMqTpd8hLfvDHBOOHubcbeP6V7jP9i4AZ80Di69flSpQ7lwJdbn4lBo9VvpVbX+0Ii7IoKkWwyxXmK7MMaIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7904
X-OriginatorOrg: intel.com

PiBGcm9tOiBaZW5nLCBYaW4gPHhpbi56ZW5nQGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBNYXkgMjksIDIwMjQgMTE6MTEgQU0NCj4gDQo+IE9uIFdlZG5lc2RheSwgTWF5IDI5LCAyMDI0
IDEwOjI1IEFNLCBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gVG86IEFy
bmQgQmVyZ21hbm4gPGFybmRAa2VybmVsLm9yZz47IFplbmcsIFhpbiA8eGluLnplbmdAaW50ZWwu
Y29tPjsNCj4gPiBDYWJpZGR1LCBHaW92YW5uaSA8Z2lvdmFubmkuY2FiaWRkdUBpbnRlbC5jb20+
OyBBbGV4IFdpbGxpYW1zb24NCj4gPiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+OyBDYW8s
IFlhaHVpIDx5YWh1aS5jYW9AaW50ZWwuY29tPg0KPiA+IENjOiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPjsgSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+Ow0KPiA+IFlpc2hhaSBI
YWRhcyA8eWlzaGFpaEBudmlkaWEuY29tPjsgU2hhbWVlciBLb2xvdGh1bQ0KPiA+IDxzaGFtZWVy
YWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+OyBrdm1Admdlci5rZXJuZWwub3JnOyBxYXQt
DQo+ID4gbGludXggPHFhdC1saW51eEBpbnRlbC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+ID4gU3ViamVjdDogUkU6IFtQQVRDSF0gdmZpby9xYXQ6IGFkZCBQQ0lfSU9WIGRl
cGVuZGVuY3kNCj4gPg0KPiA+ID4gRnJvbTogQXJuZCBCZXJnbWFubiA8YXJuZEBrZXJuZWwub3Jn
Pg0KPiA+ID4gU2VudDogVHVlc2RheSwgTWF5IDI4LCAyMDI0IDg6MDUgUE0NCj4gPiA+DQo+ID4g
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+ID4NCj4gPiA+IFRoZSBu
ZXdseSBhZGRlZCBkcml2ZXIgZGVwZW5kcyBvbiB0aGUgY3J5cHRvIGRyaXZlciwgYnV0IGl0IHVz
ZXMNCj4gZXhwb3J0ZWQNCj4gPiA+IHN5bWJvbHMgdGhhdCBhcmUgb25seSBhdmFpbGFibGUgd2hl
biBJT1YgaXMgYWxzbyB0dXJuZWQgb246DQo+ID4gPg0KPiA+ID4geDg2XzY0LWxpbnV4LWxkOiBk
cml2ZXJzL3ZmaW8vcGNpL3FhdC9tYWluLm86IGluIGZ1bmN0aW9uDQo+ID4gPiBgcWF0X3ZmX3Bj
aV9vcGVuX2RldmljZSc6DQo+ID4gPiBtYWluLmM6KC50ZXh0KzB4ZDcpOiB1bmRlZmluZWQgcmVm
ZXJlbmNlIHRvIGBxYXRfdmZtaWdfb3BlbicNCj4gPiA+IHg4Nl82NC1saW51eC1sZDogZHJpdmVy
cy92ZmlvL3BjaS9xYXQvbWFpbi5vOiBpbiBmdW5jdGlvbg0KPiA+ID4gYHFhdF92Zl9wY2lfcmVs
ZWFzZV9kZXYnOg0KPiA+ID4gbWFpbi5jOigudGV4dCsweDEyMik6IHVuZGVmaW5lZCByZWZlcmVu
Y2UgdG8gYHFhdF92Zm1pZ19jbGVhbnVwJw0KPiA+ID4geDg2XzY0LWxpbnV4LWxkOiBtYWluLmM6
KC50ZXh0KzB4MTJkKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0bw0KPiA+ID4gYHFhdF92Zm1pZ19k
ZXN0cm95Jw0KPiA+ID4geDg2XzY0LWxpbnV4LWxkOiBkcml2ZXJzL3ZmaW8vcGNpL3FhdC9tYWlu
Lm86IGluIGZ1bmN0aW9uDQo+ID4gPiBgcWF0X3ZmX3Jlc3VtZV93cml0ZSc6DQo+ID4gPiBtYWlu
LmM6KC50ZXh0KzB4MzA4KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcWF0X3ZmbWlnX2xvYWRf
c2V0dXAnDQo+ID4gPiB4ODZfNjQtbGludXgtbGQ6IGRyaXZlcnMvdmZpby9wY2kvcWF0L21haW4u
bzogaW4gZnVuY3Rpb24NCj4gPiA+IGBxYXRfdmZfc2F2ZV9kZXZpY2VfZGF0YSc6DQo+ID4gPiBt
YWluLmM6KC50ZXh0KzB4NjRjKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcWF0X3ZmbWlnX3Nh
dmVfc3RhdGUnDQo+ID4gPiB4ODZfNjQtbGludXgtbGQ6IG1haW4uYzooLnRleHQrMHg2NzcpOiB1
bmRlZmluZWQgcmVmZXJlbmNlIHRvDQo+ID4gPiBgcWF0X3ZmbWlnX3NhdmVfc2V0dXAnDQo+ID4g
PiB4ODZfNjQtbGludXgtbGQ6IGRyaXZlcnMvdmZpby9wY2kvcWF0L21haW4ubzogaW4gZnVuY3Rp
b24NCj4gPiA+IGBxYXRfdmZfcGNpX2Flcl9yZXNldF9kb25lJzoNCj4gPiA+IG1haW4uYzooLnRl
eHQrMHg4MmQpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBxYXRfdmZtaWdfcmVzZXQnDQo+ID4g
PiB4ODZfNjQtbGludXgtbGQ6IGRyaXZlcnMvdmZpby9wY2kvcWF0L21haW4ubzogaW4gZnVuY3Rp
b24NCj4gPiA+IGBxYXRfdmZfcGNpX2Nsb3NlX2RldmljZSc6DQo+ID4gPiBtYWluLmM6KC50ZXh0
KzB4ODYyKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcWF0X3ZmbWlnX2Nsb3NlJw0KPiA+ID4g
eDg2XzY0LWxpbnV4LWxkOiBkcml2ZXJzL3ZmaW8vcGNpL3FhdC9tYWluLm86IGluIGZ1bmN0aW9u
DQo+ID4gPiBgcWF0X3ZmX3BjaV9zZXRfZGV2aWNlX3N0YXRlJzoNCj4gPiA+IG1haW4uYzooLnRl
eHQrMHg5YWYpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBxYXRfdmZtaWdfc3VzcGVuZCcNCj4g
PiA+IHg4Nl82NC1saW51eC1sZDogbWFpbi5jOigudGV4dCsweGExNCk6IHVuZGVmaW5lZCByZWZl
cmVuY2UgdG8NCj4gPiA+IGBxYXRfdmZtaWdfc2F2ZV9zdGF0ZScNCj4gPiA+IHg4Nl82NC1saW51
eC1sZDogbWFpbi5jOigudGV4dCsweGIzNyk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gPiA+
IGBxYXRfdmZtaWdfcmVzdW1lJw0KPiA+ID4geDg2XzY0LWxpbnV4LWxkOiBtYWluLmM6KC50ZXh0
KzB4YmM3KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0bw0KPiA+ID4gYHFhdF92Zm1pZ19sb2FkX3N0
YXRlJw0KPiA+DQo+ID4gYXQgYSBnbGFuY2UgdGhvc2UgdW5kZWZpbmVkIHN5bWJvbHMgZG9uJ3Qg
dXNlIGFueSBzeW1ib2wgdW5kZXINCj4gPiBJT1YuIFRoZXkgYXJlIGp1c3Qgd3JhcHBlcnMgdG8g
Y2VydGFpbiBjYWxsYmFja3MgcmVnaXN0ZXJlZCBieQ0KPiA+IGJ5IHJlc3BlY3RpdmUgcWF0IGRy
aXZlcnMgd2hpY2ggc3VwcG9ydCBtaWdyYXRpb24uDQo+ID4NCj4gPiBQcm9iYWJseSB0aGV5J2Qg
YmV0dGVyIGJlIG1vdmVkIG91dCBvZiBDT05GSUdfUENJX0lPViBpbg0KPiA+ICJkcml2ZXJzL2Ny
eXB0by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9NYWtlZmlsZSIgdG8gcmVtb3ZlDQo+ID4gdGhpcyBk
ZXBlbmRlbmN5IGluIHZmaW8gdmFyaWFudCBkcml2ZXIuDQo+ID4NCj4gDQo+IFRoYW5rcywgS2V2
aW4gOi0pLiBUaGlzIGRlcGVuZGVuY3kgaXMgbGlrZSB0aGUgcmVsYXRpb25zaGlwIGJldHdlZW4g
dGhlIFFBVA0KPiB2ZmlvDQo+IHZhcmlhbnQgZHJpdmVyIGFuZCBtYWNybyBDUllQVE9fREVWX1FB
VF80WFhYLiBUaGUgdmFyaWFudCBkcml2ZXIgZG9lc24ndA0KPiBkaXJlY3RseSByZWZlcmVuY2Ug
dGhlIHN5bWJvbHMgZXhwb3J0ZWQgYnkgbW9kdWxlIHFhdF80eHh4IHdoaWNoIGlzDQo+IHByb3Rl
Y3RlZA0KPiBieSBDUllQVE9fREVWX1FBVF80WFhYLCBidXQgcmVxdWlyZXMgdGhlIG1vZHVsZSBx
YXRfNHh4eCBhdCBydW50aW1lIHNvDQo+IGZhci4NCj4gQWxleCBzdWdnZXN0ZWQgdG8gcHV0IENS
WVBUT19ERVZfUUFUXzRYWFggYXMgdGhlIGRlcGVuZGVuY3kgb2YgdGhpcw0KPiB2YXJpYW50DQo+
IGRyaXZlci4NCj4gRm9yIENPTkZJR19QQ0lfSU9WLCBpZiBpdCBpcyBkaXNhYmxlZCwgdGhpcyB2
YXJpYW50IGRyaXZlciBkb2Vzbid0IHNlcnZlIHRoZQ0KPiB1c2VyIGFzDQo+IHdlbGwgc2luY2Ug
bm8gVkZzIHdpbGwgYmUgY3JlYXRlZCBieSBRQVQgUEYgZHJpdmVyLiBUbyBrZWVwIHRoZSBjb25z
aXN0ZW5jeSwgaXQNCj4gbWlnaHQNCj4gYmUgcmlnaHQgdG8gbWFrZSBpdCBhcyB0aGUgZGVwZW5k
ZW5jeSBvZiB0aGlzIHZhcmlhbnQgZHJpdmVyIGFzIEFybmQgcG9pbnRlZA0KPiBvdXQuDQo+IFdo
YXQgZG8geW91IHRoaW5rPw0KPiANCg0KRm9sbG93aW5nIHRoaXMgcmF0aW9uYWxlIHRoZW4gd2Ug
bmVlZCBhbHNvIG1ha2UgUENJX0lPViBhIGRlcGVuZGVuY3kNCmZvciBtbHg1IGFuZCBoaXNpbGlj
b24gZ2l2ZW4gdGhleSBhcmUgZm9yIFZGIG1pZ3JhdGlvbiB0b28/DQo=

