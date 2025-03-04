Return-Path: <kvm+bounces-40006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0DBA4D8F9
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B03241885F36
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996861FE479;
	Tue,  4 Mar 2025 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mdyc1AnG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431021FCCE4;
	Tue,  4 Mar 2025 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741081381; cv=fail; b=VIjYQr6lf7hQHkrygK5mf3j1h7v4SpZUhsP3k4Mmb6UK38XyQQNSgUK8vpc7wuMfnMw0+zY3elPyIG+M1VU4pzsOdAdA7Sk7wGneyC1GpoCtn4ySN6Fl2mO5Cf1PoLv4kTxcNpjjj7bUtM7J8nzZ9ERLUZJAajVUpDlEz3r8lIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741081381; c=relaxed/simple;
	bh=leUKo8NsTJFfFzkYJYP2OQ2Qy75+HTjHEx5Gu7rY+O0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PyeEGum7iH8Jn9bf5wwpsCK9Fq+JGK9hMMjuKPBv0etjMF+8m501HeO66qosREOeGT1LPyKqG/fu8qpGtaaLf9LPPJcuY3yaBKcZyUWIABMbHpYSzhaIiRsXne0OUiQs4xqb1YvkvuVbI2zsLOr0Kbqq44S8yqPtVV7H/6vLlIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mdyc1AnG; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741081380; x=1772617380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=leUKo8NsTJFfFzkYJYP2OQ2Qy75+HTjHEx5Gu7rY+O0=;
  b=mdyc1AnG60wedNv2qixziYWp9Uw6T0lWrj7p7jz5LYJBkaQp9bZBqwo9
   GsLHMvAQhMDRiR1vxNL634tiYwwPwjntn2GeG6jKc5ChUiw7H5xAl+kb2
   DAPqsUqBTNsRdxGAj+BXbxGi2ba32/sV9tTI7oIHc82tQBs4+Kl//tKsG
   dPN7hyioawrQX8TrRiayapUtqNVDTAL9z415crB+xsEVgsNc98LJ5xo9H
   nJfsZF3EzQGQADE5rKVU0wVYZQCqmh9fbd63KUb0UHuhKw5IYM3vk6DTr
   C/IJEpxk66iyHzxftVIIiYwjUohNUskCOaWM90PDM2EkDU47XsSSq5V65
   g==;
X-CSE-ConnectionGUID: Dg8y+YbUQSSkKjerr5tUWQ==
X-CSE-MsgGUID: PPr0afp6RWm7J0T5feZ44g==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41900066"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41900066"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:42:59 -0800
X-CSE-ConnectionGUID: 9J03DEFMSASSK6O5Yphiow==
X-CSE-MsgGUID: RRfrg6iJQwerrPPzsGiHoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="122942802"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:42:59 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 4 Mar 2025 01:42:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 4 Mar 2025 01:42:58 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 01:42:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6D0VMZemubxEcsdsUgPQJPPMjmqwliHO3xkOxd1F1DSjkxrOsS+xsoezxzqPBn2sJY6eMyvMsgCPvTmktrYzK+yGNbpXDsUXyC0i4Y2qV6TBsyGM1TGQ1P8hbQzNaVIpwZTm5IW6RGiN1PsqUa3Qlmu83ocC6o3ZYXqSw/EldxOqds7NKRnaY+/0JknVnK/xsTonmyNZz5WUk1z6qJK/8HmDvzHx+JQyJwy95lhO2M8fcNYg2qC+Lsk2+Dfude/F14+lO9Vv1pqxscPus0xfbMaz57qqRbsZgLKnFBHhbTG1zdbvSzg1jSV/Lv/SOw4EumZ/eK6mOaMw3goHIwNqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leUKo8NsTJFfFzkYJYP2OQ2Qy75+HTjHEx5Gu7rY+O0=;
 b=Y2+6jgLATvMrn6qOioESvbpnDL4jdxw+k8yLr6YFcL9HSNhTXmblcnOBLDF9olF+glvrzTQibdwYHX3tY6VHmE0OkMuDHI5vpc6RevMMzvq6nWGckcY7yCazULx+qFS/vMCUpW8Ykf95Af5GM0m79ncYzjWG6sp93PZed4Hh22rOyMg/9MVNSHijMfoFKt+le27mghTaH6reMYTAh7Jg9MMUbOGQuDQHdnA9D/IoxSexwae9N7j0K3D3a7Fa+w6XphbW8Qw2hkitRrOBRRSEJAIBC7oP01sVzBtPKRKIpXMA3YBTJ2zAoGT97PStshFvsCSlVuKPAO2oHhGuOlhOuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5135.namprd11.prod.outlook.com (2603:10b6:a03:2db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 09:42:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 09:42:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"xuyun_xy.xy@linux.alibaba.com" <xuyun_xy.xy@linux.alibaba.com>,
	"zijie.wei@linux.alibaba.com" <zijie.wei@linux.alibaba.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] KVM: x86: Isolate edge vs. level check in
 userspace I/O APIC route scanning
Thread-Topic: [PATCH v5 1/3] KVM: x86: Isolate edge vs. level check in
 userspace I/O APIC route scanning
Thread-Index: AQHbjKV/M0qbU9Fs+UaPUGQ6Z+WXdLNiujgA
Date: Tue, 4 Mar 2025 09:42:36 +0000
Message-ID: <5ca74373f6bd09f1f0a4deff8867cfb07ffe430d.camel@intel.com>
References: <20250304013335.4155703-1-seanjc@google.com>
	 <20250304013335.4155703-2-seanjc@google.com>
In-Reply-To: <20250304013335.4155703-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5135:EE_
x-ms-office365-filtering-correlation-id: aa41c856-4a73-4353-576a-08dd5b00e5a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bzhkVUpmRUkzMmQvZnNVTW96QUJ5S3V3anFHdlBwb21TdjdNRGs2eG5uM0Zz?=
 =?utf-8?B?UE82Zk15NDQxVVptclQzb1VnaFZHL1ZicnNUVnQxenB0MlU3SmVqK0pFcDVl?=
 =?utf-8?B?ajF2Z2o1dlFjOHVlbzJKY1FyN3VkVkl4WjM0cDZUUUtJS3plaVlXMXZWSE9u?=
 =?utf-8?B?RXdDMWh4QVFqbHpIWXZDNnhNQXVabm9wQ3NucDE1SmlwOUxJYWlpa3g3Tjlr?=
 =?utf-8?B?aTlsT280QmZMd1JleStuRHJkWnY3NEUrbVhkSzJiNGd3d1MyencxR2RsM2l6?=
 =?utf-8?B?YnphOHlyanF4d2pBekpvdGFpZDhwNzVzTEV6U1MwSFNLMWZQK3NyaTcxazhQ?=
 =?utf-8?B?SDlQWUFYblFkZHpmbTl5VXh1TEVRV3lDTm1ES21QWStsY0NBUk43Yyt4RTBE?=
 =?utf-8?B?cnl1VUpyTzNHZFFsMk9pTXZNc1dNRHlESFpnU21zOTZGRGVCcEx1NkRTM1RK?=
 =?utf-8?B?SjM2K0Rzekc4b0tOL2Rib2hnV3ZoRFBEZnBvOEV6VHkxQ0ZrU2ZuNnVqRTFJ?=
 =?utf-8?B?QjlaS0hZTDZMbGZhVk1GZjloMVZtMVUxM0dabDhWQnVId1VXZDZFYVF0Ynoy?=
 =?utf-8?B?VUFRWGNhUDFFN05UNEJ1R3NEMDZmcTBMMHU5TlFkemhzaUI1K2xUdG85WU5I?=
 =?utf-8?B?QTd0L1NxQ2tJQ1BGVVRxOU1oWG5TMU4reWpyalh6aGJQeW1nVW13VGNTb1RK?=
 =?utf-8?B?cFNTaEg2aE4vMWhTNzlvSWJKYjdMeURSc0Z6b2tuT1RxSGhTV01IZnBEWE4r?=
 =?utf-8?B?cWhRS01GTHZPRDJQM2tway9zQlN0Z2ptVC9RWlN5UHZuV2lTbm5GdjZjVUcx?=
 =?utf-8?B?eGtMUTh6WWhXS004aXVJOVNka3g2V0xpeEFBQlFnZkNPNkNQUlRwajhpelA2?=
 =?utf-8?B?VjZ1SFpCamZaQ0dqcVkxN21aT0Y4TjlIbzdOTmt2SGk2bG16eEh4MW1ZaENB?=
 =?utf-8?B?V1djQWd1YWlFUUtiUm1BY2xjZ2hvZnVnZnpxdlpNNFBBM1ZRV05ITUJYM3NM?=
 =?utf-8?B?TDVkeEZ0UDd0L29KRHdMZUw2dTBGSWh2cUdyMUhrQ2dDWDB0dzZ0c3ZvUm1Z?=
 =?utf-8?B?M3hlUjQ0NmVxazUraThMdmRyanVFY2o4ZGwyQXAxVE43VUdFaUZFQkpXTG9P?=
 =?utf-8?B?K1VuTTRXNDl1T3puYTUrOFk2TUlpV1ByVFBGOGFvK1llc1JsdzZRSG9CRDhT?=
 =?utf-8?B?Sm9TUU5mbXNIVFhNbS9KMkJRbjBadkNXTzFiMmpmS0c0cFRQd2ZFYzg5UUdJ?=
 =?utf-8?B?cHFWVlM2eXFBRm1Od3ExcXA1ZnIrS3dqNzE5cnphQkQ3ZU16cm9Xek9ta3kr?=
 =?utf-8?B?M1kzZUl5OXNkSkk1VTVMbkZsWlhzVlNuWDFYMTZsL01hZmVYMG95dStBeStu?=
 =?utf-8?B?UjkyUFFGWTZoRGVoV0ZSWkMvWXdkb1FwZE0yTDNYSE9KWUYwR1dWTzF3R2pF?=
 =?utf-8?B?cEFPWHk0bUFuMjdLUXBSUUpCU3RFS1g0cVhuZlBIUkt2NkNrdzVvUnRsTDcr?=
 =?utf-8?B?YzkzUDd5OHBIT21SOFRadWt4WnRRQTB5YmJWRlI3NVpTOHplcGFDLzFqV3RU?=
 =?utf-8?B?bFQ3bXArK04xMzhQbE5IWnFIb1huNWU0b25FZjltbXNMamhkSWhzemFTZThF?=
 =?utf-8?B?b24yRzgxYTZmTkdDNnB1QTFnNGNtSU9uV3BRbnpPTjRkNWpnUU1FVDJzWWtY?=
 =?utf-8?B?UklRVE9IR0s3enFuYlc4N1l0K0haNzBrd2RQeWJqWlU1WndObmQ2cWVWSkhO?=
 =?utf-8?B?TXZxbDI5YVlVbFNDUENjaFBKWjBNUFhjNjdNdkk4SmUzaEI1WUM4TlNaUGJr?=
 =?utf-8?B?ZERhL011L3RaN0lUR0tKbzc4K2RwcDJJeXZDUXVmNGYrdVJyZkRsblRYWSs3?=
 =?utf-8?B?V1dtWUNxRlRTa0syOER4ZHpmb25sUncyTmNVYVFYWGxwRWhDbE05MDBmMElZ?=
 =?utf-8?Q?7jSxQyvDiD2Ql4VTG9Ybk+vSCj4pkO3t?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDBCVHhJeGZZdjhwZXJhQmQyeWVDTnc4OEEvTjV6Y3BoRm14ZFptL3puVjJs?=
 =?utf-8?B?bXNCdW55VkRiVlBybDdndjVHQkd4TnU0aTk4UStzUTdIWXdtR2VnUkkwV2pn?=
 =?utf-8?B?SVdweXZOd2ZmMUtzcGQ5b0FHazFsNDNFbWllU2s1T2dSMjdGTUVSR3FXSTEx?=
 =?utf-8?B?d3k4RVd4WUxDNGJGRzdDTkdHbTEvbGFMNUM1d2ErVGJ5dXBFRGpLUmpMZmdF?=
 =?utf-8?B?MmF4M2s1cE1qRkQ3MFVmMm1Rc291N201Y0lxYmx1UEhpSlFMSEVNUUUrangr?=
 =?utf-8?B?dkdGS20wZWdNTzZUUXVtdnNveU9uZDdSd3pQbDNsaXZZRDFVbkt4ZHBCR2lC?=
 =?utf-8?B?NGVZMTVETXJGcVh5ekZibmM4bzVWOVNwV3V5d2ZBUm9kTGxKLzdocDNJTnJP?=
 =?utf-8?B?UU5BT0FUb05sMnZramhtZGhkbFBCTmFKSngzMGZWSHc0eGNsNlozN2xHMDlO?=
 =?utf-8?B?a1piS3lIYmF0SFV3b0RxNzZNdldlbnE3UE1FTWZySit6S2NJbnB6UTNEc2VV?=
 =?utf-8?B?TGpkU2JOQzNUNlpjbjduWnd0NnVkK29Ud1JCUnBSMFhYeWJLcG9DSTg0RDM2?=
 =?utf-8?B?eGNjQWdWdHJsVzRZZkxVNHIyTFBvYkl6WHhWelpGZGEvWUpObzB4VkN6YXZW?=
 =?utf-8?B?dm52c3g2dGdGNXRrOGgyR2tEMWIvb0R6L3BDMDFiTjJhekkxZzA0U3dacHE3?=
 =?utf-8?B?V0NmMEVFMzhRNWRyOFJ3VmRSSmpnd2JSNk11d0FDaVNhWElLc2gxY1FsNG9i?=
 =?utf-8?B?SjFWd2hJd2x1OHJncFhiOW11RTFuK0w2d0thR21mekk0NURKRjFXUVZlNUVa?=
 =?utf-8?B?M29VZHArNjl3aWtVS2ZwKzE0aEU1Rm01WVZqQm85NkgrekJoaU5kWXFQRllq?=
 =?utf-8?B?RUwwVVJQVC9pTmxnZitDVkp6b21vNjU4SDVkRkJYRUk0QWVvQW1zdG9zNHov?=
 =?utf-8?B?MUc1cnFseThrUjdISE12OFIvdUpPN2ZEcU5BUXpyOVd1NGt6YTVZN3VDb3Bi?=
 =?utf-8?B?cG9wOWRCdTJ6NEtGamZyWGIwcmRJNytrSDFWa0lHVURjd01WZllveDV0RzJ5?=
 =?utf-8?B?QlFwNzhxalpYZlFnVW1zOXJlMy9QdnE0WE5XVHlrOHNNSEF6MWQ5bHhoN2Fs?=
 =?utf-8?B?ZEpTNnQyb2RKeTRnUXU4WkpXaTlBSy9TNDVxTXBMVW9xdTZBVlpUV3psWDFj?=
 =?utf-8?B?eWNtOFRPY1hGK2U1Q2RRQVIxanVMQkJ3R0JycDRNVDNCY2toVHk5dGJmQUt4?=
 =?utf-8?B?cXBoSnNLc3lsbExnb1dGa1BMZFVUYzRXaGJ3WWNoK3JhRVNCNkNGVGVtM0p0?=
 =?utf-8?B?WGtzSXgyelZXZHFXMXo4SXpqcHJqWkg0cDZiNytaZGsxRHJrSlZqanhBTjBG?=
 =?utf-8?B?TmRTWEk0alBmYkpEVWMweTVTT3JSYlRCYzE2d0NqRmQwdGYyaXRRR3Joc2k3?=
 =?utf-8?B?YjNHYkZoZDJvTUR2N01JOHJFa0I5OStheCtadFg4QXpGWFpnU3RLSXNVclN1?=
 =?utf-8?B?bk80SGFlMFlPc3JDeWd2QUd1THoycGtUSC91bWxrbS9sY0tyTmRJOWY3Z0I1?=
 =?utf-8?B?KzVwUTkrVW1TcnpSc0dCOXFXMExkSU15NFJJa0lYTkc1a1UzYjNubnArN2kw?=
 =?utf-8?B?Z1dLeUtWY1lKaUJwdWNZL2dySGxWeUd2TERVU0JKMUxtSjlPYm8wenptUjJG?=
 =?utf-8?B?QWZCNkpQc2RDMjVhVXZlMyt3T3gwN3gvd0lVN21PVWlvSDRaaGFYaGs4bEpa?=
 =?utf-8?B?Yi9DblFHczQwQXVXZFZnR1VmKzNKdEcvdExuZGl4UEVKdURWa3dOSWRIdUZn?=
 =?utf-8?B?Qi9sNEhsalNXUi94bFF1ZU5GM243NFNkNlF0N3N3d1JyUE5qK29xV3VTMzlC?=
 =?utf-8?B?Q2x1d3Z1N3ZxZG90Qmd2NVowb1lYZEN1RDN3RFlsSlZmUldmTDFlMTFVY0Jz?=
 =?utf-8?B?Q0hpdmpZUkhNbmlyejdIZEVZMkhsUDVsUjFQRVNvd3RsbGRSb3M0ekJtNCsr?=
 =?utf-8?B?KzlpK1ljb1ZmdUZkQ21tN1ZacjlNWE1Tbk0vS0xQTEtsTVlzL0d6NUtobWhX?=
 =?utf-8?B?UEVYZllxeWhEajM5aXp5SDI3elVpQWtDQWl1M1VOeXFQQldvZlNkdmhxYVF4?=
 =?utf-8?Q?bbWQiZ4JFfeiebkqHK1ZXHAcO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD6A9E3AE5DC6B4C988A42BDD9E14F11@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa41c856-4a73-4353-576a-08dd5b00e5a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 09:42:36.6999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7aspb7ghkEbpwUVvo8sTTyHsqXr4d5qzotJDV/Pvwpc4KCBaRDF3XdWMlLzsxikfzNyUREwEmDqGvs9QldPGMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5135
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTAzIGF0IDE3OjMzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBFeHRyYWN0IGFuZCBpc29sYXRlIHRoZSB0cmlnZ2VyIG1vZGUgY2hlY2sgaW4ga3Zt
X3NjYW5faW9hcGljX3JvdXRlcygpIGluDQo+IGFudGljaXBhdGlvbiBvZiBtb3ZpbmcgZGVzdGlu
YXRpb24gbWF0Y2hpbmcgbG9naWMgdG8gYSBjb21tb24gaGVscGVyIChmb3INCj4gdXNlcnNwYWNl
IHZzLiBpbi1rZXJuZWwgSS9PIEFQSUMgZW11bGF0aW9uKS4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwg
Y2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNv
biA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vaXJxX2NvbW0uYyB8IDEwICsr
KysrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2lycV9jb21tLmMgYi9hcmNoL3g4
Ni9rdm0vaXJxX2NvbW0uYw0KPiBpbmRleCA4MTM2Njk1ZjdiOTYuLjg2NmY4NDM5Mjc5NyAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL2lycV9jb21tLmMNCj4gKysrIGIvYXJjaC94ODYva3Zt
L2lycV9jb21tLmMNCj4gQEAgLTQyNCwxMCArNDI0LDEyIEBAIHZvaWQga3ZtX3NjYW5faW9hcGlj
X3JvdXRlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICANCj4gIAkJCWt2bV9zZXRfbXNpX2ly
cSh2Y3B1LT5rdm0sIGVudHJ5LCAmaXJxKTsNCj4gIA0KPiAtCQkJaWYgKGlycS50cmlnX21vZGUg
JiYNCj4gLQkJCSAgICAoa3ZtX2FwaWNfbWF0Y2hfZGVzdCh2Y3B1LCBOVUxMLCBBUElDX0RFU1Rf
Tk9TSE9SVCwNCj4gLQkJCQkJCSBpcnEuZGVzdF9pZCwgaXJxLmRlc3RfbW9kZSkgfHwNCj4gLQkJ
CSAgICAga3ZtX2FwaWNfcGVuZGluZ19lb2kodmNwdSwgaXJxLnZlY3RvcikpKQ0KPiArCQkJaWYg
KCFpcnEudHJpZ19tb2RlKQ0KPiArCQkJCWNvbnRpbnVlOw0KDQpQZXJoYXBzIHRha2UgdGhpcyBj
aGFuY2UgdG8gbWFrZSBpdCBleHBsaWNpdD8NCg0KCQkJaWYgKGlycS50cmlnX21vZGUgIT0gSU9B
UElDX0xFVkVMX1RSSUcpDQoJCQkJY29udGludWU7DQoNCmt2bV9pb2FwaWNfc2Nhbl9lbnRyeSgp
IGFsc28gY2hlY2tzIGFnYWluc3QgSU9BUElDX0xFVkVMX1RSSUcgZXhwbGljaXRseS4NCg0KPiAr
DQo+ICsJCQlpZiAoa3ZtX2FwaWNfbWF0Y2hfZGVzdCh2Y3B1LCBOVUxMLCBBUElDX0RFU1RfTk9T
SE9SVCwNCj4gKwkJCQkJCWlycS5kZXN0X2lkLCBpcnEuZGVzdF9tb2RlKSB8fA0KPiArCQkJICAg
ICBrdm1fYXBpY19wZW5kaW5nX2VvaSh2Y3B1LCBpcnEudmVjdG9yKSkNCj4gIAkJCQlfX3NldF9i
aXQoaXJxLnZlY3RvciwgaW9hcGljX2hhbmRsZWRfdmVjdG9ycyk7DQo+ICAJCX0NCj4gIAl9DQoN
Cg==

