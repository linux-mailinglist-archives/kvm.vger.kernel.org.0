Return-Path: <kvm+bounces-27334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5C3984087
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5F1FB23092
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 08:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4532E14286;
	Tue, 24 Sep 2024 08:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rykr5QSP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B334A1474A4;
	Tue, 24 Sep 2024 08:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727166623; cv=fail; b=ursPZ1Qvip1bUm1liO46ieq1buA+5FR4M0Np7ATok1MIY3tS9XcdAblStqZP5YQQLrXT+v2xqXYlBzJwIGrD2sP99+mhOxiqyIolGvY1PNJ0jw84VktdGXsi9t/6F77CpYZ8Y2kSJca5Uix6HuFVoNgVppVVt364OjNVHr7VBTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727166623; c=relaxed/simple;
	bh=zDDKYI+bYQ0LhzxZROFjlFiAiMsfOX+PYEMcNaNN74Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u2nFb2e49V8Nahgyzp/dzOLednadCVO0iHEW/cmlRG8dvnnZjhFVafgDw7pn4JL6KZrI9Co14cvwCS0Nb5HQCQS6xk5jH1b1iMNH1vu/uSIE0Likn/M9a7yjTebX+QFhBSn5nwgUDeC8KBAxb0Jva2uHbQP0Vi+WaPKUkBaNX2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rykr5QSP; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HmzMQqz3yJlneDa1rATGpSLnU2sd6Jw4hntbSaVr4YFocOybtPkZ6xoJUk18Ftb72oN9RnwPc88VqzA9DOVsJ5hexBlbA+bc8r8Z9j55Yi3bkwBG4nt7wvycwKFcZf2+kYoPZctuKk/foJLEiumBRvGc49gYs2kbv1FQoHyEqwt3YDPYHLhGeLil2OOF0Lo06mf5oix5b6eLTL56X3VY2B2SBLMij08oYs9QwXFxIWUED5d/kzGdgjA0bM4585i9GfUHef2vtZQAWIYBnfVOAleZ/maAQcB6FaOTHaVGHL763eoOpfT0z2CiH9RmswKAh2I5A9IugORWXfly/KymFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDDKYI+bYQ0LhzxZROFjlFiAiMsfOX+PYEMcNaNN74Q=;
 b=t3f/RLmOXJ3UH8YYICUJcuQFTBSEmAOu2+zjNCvMiCSENCjyC2S+IYATfcFnDi62p2fmfaQ/sKrcFpFuW0HYf6NQ84OAFEIiMqxwQ97add33wZAfoCsGRz+8lLVNK2bJ1XU8b2wW0STZVMe79Gr5MGdUHChvt2MaL/eLqU900Wub0/tA52CgCudhFyhqb6ar0SjTmRkNvuhmbuTomxIsnE0ceOY+WbyR2PTiJlLXjgi+cb4k1uhzAJu3KZgksXuNngjyOCt+X5UrHV4pwUm0Sqa7RVkdpv14RLZHgm3J3f87F7XMb2o867CRdFWOyL8/sSb6Wd4o+6AnUGp//yhC8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDDKYI+bYQ0LhzxZROFjlFiAiMsfOX+PYEMcNaNN74Q=;
 b=rykr5QSPa8g78X1DK9c5fvoL185xTeMODCuUO33037LGORbC06HnRVE7fKXNeJIYPNPDuGzKuU3cWE/VdT6J64u+K7EPv3JYzSvXtuOCgmZ4aSEytN2MlFeJQrdPTb47MYoAb6fRi9S1lYgd9ddT8HOI0Yt++PzH8F9dPEiZMqt7GDxSxtQidqMk575J/QBjbxjakmljZqjM6GDfyH/jhT7wdYFqu/ciXrFQqeygjFg3HonYD/+vFOgQeX1wVW/u162hzPeFCc/s7z8lPhyXxXQh19PkP+R0sw0M7hdJZkEQbLc7UXKeOXKicOja7a5/+rWt7I9rqUbno6HWeyil4Q==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by CY5PR12MB6225.namprd12.prod.outlook.com (2603:10b6:930:23::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.26; Tue, 24 Sep
 2024 08:30:18 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 08:30:17 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"alucerop@amd.com" <alucerop@amd.com>, Andy Currid <ACurrid@nvidia.com>, Neo
 Jia <cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Topic: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Index: AQHbC61b9ki2ojKvx0ySv/3ut0ogdLJlBfmAgAGapQA=
Date: Tue, 24 Sep 2024 08:30:17 +0000
Message-ID: <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|CY5PR12MB6225:EE_
x-ms-office365-filtering-correlation-id: 4b27b285-6085-45b8-7023-08dcdc731ee6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MTFHcG5USE5EZ2VzMGFkRDROWW94MEdUUGtaQVpycFljSUQ5STlnZVBhRVRI?=
 =?utf-8?B?VFEwb2I4YkJSZTYwNDdrSmxSRjNyTkxWenc2L3VESGRoTmZKdFk1bVpoYTZQ?=
 =?utf-8?B?NWtkYUZtc0l3U3ZZS2pQME5NM1FDTEFpUFFiZ3ZmTXFvTURNcUhPZDU3dUV5?=
 =?utf-8?B?RjlTNjBkcXNOME5mUmtrd2RoWkJhODVqNmhvRzkxT3J1U2dqU2YvWmxMY3NN?=
 =?utf-8?B?YldNam5hdkltUm1wQnZMTGdmcytWMEptT0plODVzSDkzZnpORFdwVnVzOWlM?=
 =?utf-8?B?R1JnYnhiMVZ1dlJiNit6R3R1UnF0N1ZRZmQzNlNmUCtQR1Z2N1puSTNDUk11?=
 =?utf-8?B?Sk42MSt0ZHVFcEE3T25xNnRpMXRpTEhGSXpQUnJTMGdUWENqZHZQOU9adU80?=
 =?utf-8?B?UklGV3k4NWVueVhxSVI3SW1GOEVkOXdGeUNHcDA1cXAyRXBnVzRPSUxML0hS?=
 =?utf-8?B?bHhydkJWN2JPQmNaanptWGNzRGNIYnI0azZNTmpaRDJMRGdTdmJKLzdaRnV6?=
 =?utf-8?B?MlNLUlAyZGpIQndibHhyTWdEZ0pWdERYdEF4Zm9sRFlKVk5MMDFOVldPMEJM?=
 =?utf-8?B?MzdJZnZrVTdKb0hNa0w1NTJNd0xFcDZ4NGl6N2EzVEFvRVhzUDBIUjdocDdO?=
 =?utf-8?B?SDRrdHRWeHVvK2FVQkp1QTljbEpwNWN4djNDNGZBMUlNaHFKeXUzZkw5YUhi?=
 =?utf-8?B?dHZlRTVCWlRJMXd2MVZqTUQ0YVhGcUNscm92UHFIakJHQjI5MzNxRWhUejJz?=
 =?utf-8?B?NGVxWVN6bks3RjF4aHVPT1pONFBseGpHSW1mVVpvTnFpdFZUQi9SaXo2T3Uy?=
 =?utf-8?B?OWdaKy9VQ1EyS3oxVWVMR1J2dlpaQ2xaYWZBbDdLeGhYemJGTjJmKzZac0dk?=
 =?utf-8?B?NUlBNmord01jeEtheTlIdVBxcDhUb3kreGpULzJ5SFBpRU5OSFppUkZ0WndJ?=
 =?utf-8?B?MlJmUEpERFEzc055ZFdUSTBSQ3Nvc0h4emJNa2lZSFF2VGtjeHdvOWk1RmN5?=
 =?utf-8?B?OE5PTXpIWWtubWt3RGNCV3ZZTmNqUk5iNVpIWXRTdGh6N0Z2K09SajBXMjZN?=
 =?utf-8?B?SkxvV2htajM0anRBMm92WXVwSnBjMis2eGVxUjg0bnJwdjA0a3NNa1I5QXNr?=
 =?utf-8?B?UENiWTRvbENHN2NjODlJUzBZbU9naWV6THpEQmlPL0ZwdkgyZjJXVTFwV2d2?=
 =?utf-8?B?MUE1NVk1b243UjdzczNNaXZTTnI3cDJ0dlozaEdCSkM0U0JUWGFXcnNGU3F6?=
 =?utf-8?B?Zy9KMG42T2Q0bEUwbG84VkxUb0ZFNHFzTCttWGY2V2s1NjR4RSsxeXBsSk03?=
 =?utf-8?B?VnV0aUJkSll4Z1pwb1ZaekdkSUsxUENFemxZT0dzQUtvRXJFaUU1d2RZWE1G?=
 =?utf-8?B?b0pYQTVXSXNRbVZZM2lsMGZVS3JqcHh1UktyV1Rwb0ZkSGR6OVJQdGxKcWNM?=
 =?utf-8?B?NU9jYy9KYjBINlpqcXpqWkM5ZjJ5REdUOXB1eFFuaDJSa2drbEE0TFhDbThD?=
 =?utf-8?B?VjFOQk1WL3cyVHNjWGpPM1REaHFXdjdZMEVicEZ5SThwUGpSQ2lib1BMTkdv?=
 =?utf-8?B?dTMzMXUrUlNxUnVmdW9jN2p0OUlEdlE1MEFKclRmYmd2TVFPNmRNRGJ3NzZM?=
 =?utf-8?B?d3ZVaGFaWW14QjlvbUp3U2lSZUt4V1dQS0c4SmlHVWc5TzNlcWNCc0VPMSsr?=
 =?utf-8?B?YldBN3hpL0RJczFRRUZ4M1JOemRjcml4M2JsWURuU0U3dWcxQUJhNy9jbUs1?=
 =?utf-8?B?S3ljcHNjWkt2OEk1SWt4N25JcW1xV2l6UUE2VS93U0R0WFpWcWhISno5dzcz?=
 =?utf-8?B?bXg0MHFjZGlLNFBsSEM3OEFkRDU2bG1aMndJYjAzUVpJZ1FzY29GZ2xTcnRC?=
 =?utf-8?B?TmRreHpEWkk2VXlINGM5enN3bUJ0Wk5HR0pQb3dJSlBqN1E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RHI3QS93UUlFOXBaNTJmWXcySXUwRE1OUWx4Nk5qVlFCcXZMMlNuVmMya2N4?=
 =?utf-8?B?NjcwVWtaTjZ1allUQXp0T0kranBzdTNIM2hDUTFmWlZTUmMzVTZialk1TW0v?=
 =?utf-8?B?bmJ2VjRZSHRvOFRWWldaRUtlc0hkczk0SnNKejhxT2FkVHNsdDMwaDlrVmR0?=
 =?utf-8?B?bWdzRzVtQnRFTVBJcDlzaThWRDJGZXZuNU1FdTF3aTlIemtaSndpTkZpLytM?=
 =?utf-8?B?aFNleFpDZDZNVFlrY2JjWVNrdlpmWGxMWERPd1JzcW1hdUVuOHVUTkxFenZU?=
 =?utf-8?B?UVNjbXoxWVpJTm1obVhOWjNpWFE2b3p4ZFZQTnU4UjBqZ3Ftd282cHlUcCt1?=
 =?utf-8?B?ZWh0RWhDOHJBL0ZYSmdwV3VxbU9UdGNVRFcrRGQ2YlpLRkNIVWZ6RnpxMU1m?=
 =?utf-8?B?L0owcU9ScDdmVWhCaDlzRUo4cU51RTZzQzdUWERpQk9VbExURW5QQkdvb1Fw?=
 =?utf-8?B?RlJieWJOeGlQMlJVaGgraWJxdDUxa245aERpVEhmak0vcytLSVBFbGRxTElk?=
 =?utf-8?B?R1huM1NNUDhia0ZsM1pvYkF1b1JwblliOFh3RDJSZWZHcXpJR2VhYkdZcWxG?=
 =?utf-8?B?TUUwQ1pEMW50UEREVjNuK2VYK1VhLzNqU21wWTRQaGs3cGROcUt5V0xOYlhp?=
 =?utf-8?B?MVo5S2ZDcXQ1M0tBSEpoUEFUQjc1UG5mWHZRa2h1clBjNDN5bHBGRjh6YU1z?=
 =?utf-8?B?aXRpQVZ4OVd4dWZRYzQ2aFlIKzJVL1IxVjhFYlVNUEc3N213SHdrdFYvcU1s?=
 =?utf-8?B?bTZUaWtsQzJQd05uOWdHWjA2RFRzYmhDUWtYVjNoNllqbXhTR05ONW9GanYx?=
 =?utf-8?B?YXZhdlFwV2ZTbWJDVGxETmx3bEFJTExXeU82RUR0amJSb1AvV1d6bWZGRDMv?=
 =?utf-8?B?OEJkT1J4aEZtazVpeDlwemw3b2xiaExDZEEvLzk4N3k5WXQydkJERGZnc0Ix?=
 =?utf-8?B?Mm1JR3lOcklpenN1bEdNTjFtR0xLUTJjQmFlSHlYNDJRVzBVcVQrMDk1bXFs?=
 =?utf-8?B?UkFqcW80TjRaa095VW8yVm4wK0lIV1VwYTNhVjJHSUMrUmpNUytIZCtWdEVj?=
 =?utf-8?B?NWxmSlV4SFgvUDJ5bzVvMEJ0cUFqM0VrNGZFenpuZXZNTTJhSndJZjJkdzhh?=
 =?utf-8?B?ZS9UcXZHaEZtNDFVNDFiYzNPV05BMllhN3g0aFBYdmFzMHkyM0ZObUR6VUtk?=
 =?utf-8?B?NW5hcE9FakgwajFHZzhaNUg1TEpSQnVvOFRFNWJnM3BWMmxTSnFJckZUWFpk?=
 =?utf-8?B?VTQ3WmhpeWttR1M1STlzRWgrRjMvMEtlUTBMSlQ2VzBiOXJhd2NqR2RUS2NV?=
 =?utf-8?B?dzF2bTcwdHNxVHJlTUlOeFBPQXgyV2NRajg4djNwd01nTlNBZnRlY1ZXakkx?=
 =?utf-8?B?N3R0TDZtcGVROHk1NTdHME1YQ3lWd3RLeDBDMVgxenJmY2txcG5KQnZrVVdp?=
 =?utf-8?B?N3Z2bkpxYlZJRldWc0F5WkJHSjViNmNMWjB4anR2YlZGQ0R5OTNxekJGdmx1?=
 =?utf-8?B?YlpMN3AyT3VpaU9EaWEvTzlQMGNMU2V4clQ3VTNDb0oxVHNqTytadWd4VGRU?=
 =?utf-8?B?bUhmTkFkNzExbzBTOGdMSVUyRHVFUTU3U0tULzd4M1hZN1ZoTDFyd3JTMXVj?=
 =?utf-8?B?RDdaa0M0MW5sOU5IVytSZFZFUDUza0YwcHN5SjVNdW9pdE1XKzE0VGFRRzJj?=
 =?utf-8?B?ekRSalRHeEZMR3E3Z0xOV3oyOTdZL0ZZUmpnT0I2TVloRlRjRnB0cFVpeloz?=
 =?utf-8?B?NzZSbWgzRHZLUlRFT0E5VTRZQ2ZpNm8yTlI4NmhiZFNveE0vdERvdDErcVBp?=
 =?utf-8?B?aTg3NU92MDZXUWdPS0dDSVlmeU5aeS80czFHTis3SDFNaktCbWs3YzFXNjYr?=
 =?utf-8?B?L1k1cnRWUkl4M3pFb0FoVmJZaWg3UStINExlT3k0dkplWnZpWERzeUprb0kr?=
 =?utf-8?B?Sk1CeE1ZcWhFQklHL0N0NEhjeEZ3UHBxajMvakMralYxZVJ5akoyV0VVakZk?=
 =?utf-8?B?dG9FaW1WWWdRVDBabllwWmxTbkt3M0ErQ2hocUF3bmJyUXNJd3NidjMxQ1Rs?=
 =?utf-8?B?OFRuRmtOY0lYczNWN1V2aklnL1c4TnVKWklxTU1ZTC9MRVpycTdGU0t5RHNI?=
 =?utf-8?Q?ZVho=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54D35161D08EE842B1B6D9AC1BDB0711@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b27b285-6085-45b8-7023-08dcdc731ee6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2024 08:30:17.7269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPT+nab8o3iHb0o2rpxNcD9+fM6I/5b7yxime+tR0v541DRUyDwOrwpseP6pPJYX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6225

T24gMjMvMDkvMjAyNCAxMS4wMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+IEV4dGVybmFsIGVtYWls
OiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4+IEZy
b206IFpoaSBXYW5nIDx6aGl3QG52aWRpYS5jb20+DQo+PiBTZW50OiBTYXR1cmRheSwgU2VwdGVt
YmVyIDIxLCAyMDI0IDY6MzUgQU0NCj4+DQo+IFsuLi5dDQo+PiAtIENyZWF0ZSBhIENYTCByZWdp
b24gYW5kIG1hcCBpdCB0byB0aGUgVk0uIEEgbWFwcGluZyBiZXR3ZWVuIEhQQSBhbmQgRFBBDQo+
PiAoRGV2aWNlIFBBKSBuZWVkcyB0byBiZSBjcmVhdGVkIHRvIGFjY2VzcyB0aGUgZGV2aWNlIG1l
bW9yeSBkaXJlY3RseS4gSERNDQo+PiBkZWNvZGVycyBpbiB0aGUgQ1hMIHRvcG9sb2d5IG5lZWQg
dG8gYmUgY29uZmlndXJlZCBsZXZlbCBieSBsZXZlbCB0bw0KPj4gbWFuYWdlIHRoZSBtYXBwaW5n
LiBBZnRlciB0aGUgcmVnaW9uIGlzIGNyZWF0ZWQsIGl0IG5lZWRzIHRvIGJlIG1hcHBlZCB0bw0K
Pj4gR1BBIGluIHRoZSB2aXJ0dWFsIEhETSBkZWNvZGVycyBjb25maWd1cmVkIGJ5IHRoZSBWTS4N
Cj4gDQo+IEFueSB0aW1lIHdoZW4gYSBuZXcgYWRkcmVzcyBzcGFjZSBpcyBpbnRyb2R1Y2VkIGl0
J3Mgd29ydGh5IG9mIG1vcmUNCj4gY29udGV4dCB0byBoZWxwIHBlb3BsZSB3aG8gaGF2ZSBubyBD
WEwgYmFja2dyb3VuZCBiZXR0ZXIgdW5kZXJzdGFuZA0KPiB0aGUgbWVjaGFuaXNtIGFuZCB0aGlu
ayBhbnkgcG90ZW50aWFsIGhvbGUuDQo+IA0KPiBBdCBhIGdsYW5jZSBsb29rcyB3ZSBhcmUgdGFs
a2luZyBhYm91dCBhIG1hcHBpbmcgdGllcjoNCj4gDQo+ICAgIEdQQS0+SFBBLT5EUEENCj4gDQo+
IFRoZSBsb2NhdGlvbi9zaXplIG9mIEhQQS9EUEEgZm9yIGEgY3hsIHJlZ2lvbiBhcmUgZGVjaWRl
ZCBhbmQgbWFwcGVkDQo+IGF0IEBvcGVuX2RldmljZSBhbmQgdGhlIEhQQSByYW5nZSBpcyBtYXBw
ZWQgdG8gR1BBIGF0IEBtbWFwLg0KPiANCj4gSW4gYWRkaXRpb24gdGhlIGd1ZXN0IGFsc28gbWFu
YWdlcyBhIHZpcnR1YWwgSERNIGRlY29kZXI6DQo+IA0KPiAgICBHUEEtPnZEUEENCj4gDQo+IElk
ZWFsbHkgdGhlIHZEUEEgcmFuZ2Ugc2VsZWN0ZWQgYnkgZ3Vlc3QgaXMgYSBzdWJzZXQgb2YgdGhl
IHBoeXNpY2FsDQo+IGN4bCByZWdpb24gc28gYmFzZWQgb24gb2Zmc2V0IGFuZCB2SERNIHRoZSBW
TU0gbWF5IGZpZ3VyZSBvdXQNCj4gd2hpY2ggb2Zmc2V0IGluIHRoZSBjeGwgcmVnaW9uIHRvIGJl
IG1tYXBlZCBmb3IgdGhlIGNvcnJlc3BvbmRpbmcNCj4gR1BBICh3aGljaCBpbiB0aGUgZW5kIG1h
cHMgdG8gdGhlIGRlc2lyZWQgRFBBKS4NCj4gDQo+IElzIHRoaXMgdW5kZXJzdGFuZGluZyBjb3Jy
ZWN0Pw0KPiANCg0KWWVzLiBNYW55IHRoYW5rcyB0byBzdW1tYXJpemUgdGhpcy4gSXQgaXMgYSBk
ZXNpZ24gZGVjaXNpb24gZnJvbSBhIA0KZGlzY3Vzc2lvbiBpbiB0aGUgQ1hMIGRpc2NvcmQgY2hh
bm5lbC4NCg0KPiBidHcgaXMgb25lIGN4bCBkZXZpY2Ugb25seSBhbGxvd2VkIHRvIGNyZWF0ZSBv
bmUgcmVnaW9uPyBJZiBtdWx0aXBsZQ0KPiByZWdpb25zIGFyZSBwb3NzaWJsZSBob3cgd2lsbCB0
aGV5IGJlIGV4cG9zZWQgdG8gdGhlIGd1ZXN0Pw0KPg0KDQpJdCBpcyBub3QgYW4gKHNob3VsZG4n
dCBiZSkgZW5mb3JjZWQgcmVxdWlyZW1lbnQgZnJvbSB0aGUgVkZJTyBjeGwgY29yZS4gDQpJdCBp
cyByZWFsbHkgcmVxdWlyZW1lbnQtZHJpdmVuLiBJIGFtIGV4cGVjdGluZyB3aGF0IGtpbmQgb2Yg
dXNlIGNhc2VzIA0KaW4gcmVhbGl0eSB0aGF0IG5lZWRzIG11bHRpcGxlIENYTCByZWdpb25zIGlu
IHRoZSBob3N0IGFuZCB0aGVuIHBhc3NpbmcgDQptdWx0aXBsZSByZWdpb25zIHRvIHRoZSBndWVz
dC4NCg0KUHJlc3VtYWJseSwgdGhlIGhvc3QgY3JlYXRlcyBvbmUgbGFyZ2UgQ1hMIHJlZ2lvbiB0
aGF0IGNvdmVycyB0aGUgZW50aXJlIA0KRFBBLCB3aGlsZSBRRU1VIGNhbiB2aXJ0dWFsbHkgcGFy
dGl0aW9uIGl0IGludG8gZGlmZmVyZW50IHJlZ2lvbnMgYW5kIA0KbWFwIHRoZW0gdG8gZGlmZmVy
ZW50IHZpcnR1YWwgQ1hMIHJlZ2lvbiBpZiBRRU1VIHByZXNlbnRzIG11bHRpcGxlIEhETSANCmRl
Y29kZXJzIHRvIHRoZSBndWVzdC4NCg0KPj4NCj4+IC0gQ1hMIHJlc2V0LiBUaGUgQ1hMIGRldmlj
ZSByZXNldCBpcyBkaWZmZXJlbnQgZnJvbSB0aGUgUENJIGRldmljZSByZXNldC4NCj4+IEEgQ1hM
IHJlc2V0IHNlcXVlbmNlIGlzIGludHJvZHVjZWQgYnkgdGhlIENYTCBzcGVjLg0KPj4NCj4+IC0g
RW11bGF0aW5nIENYTCBEVlNFQ3MuIENYTCBzcGVjIGRlZmluZXMgYSBzZXQgb2YgRFZTRUNzIHJl
Z2lzdGVycyBpbiB0aGUNCj4+IGNvbmZpZ3VyYXRpb24gZm9yIGRldmljZSBlbnVtZXJhdGlvbiBh
bmQgZGV2aWNlIGNvbnRyb2wuIChFLmcuIGlmIGEgZGV2aWNlDQo+PiBpcyBjYXBhYmxlIG9mIENY
TC5tZW0gQ1hMLmNhY2hlLCBlbmFibGUvZGlzYWJsZSBjYXBhYmlsaXR5KSBUaGV5IGFyZSBvd25l
ZA0KPj4gYnkgdGhlIGtlcm5lbCBDWEwgY29yZSwgYW5kIHRoZSBWTSBjYW4gbm90IG1vZGlmeSB0
aGVtLg0KPiANCj4gYW55IHNpZGUgZWZmZWN0IGZyb20gZW11bGF0aW5nIGl0IHB1cmVseSBpbiBz
b2Z0d2FyZSAocGF0Y2gxMCksIGUuZy4gd2hlbg0KPiB0aGUgZ3Vlc3QgZGVzaXJlZCBjb25maWd1
cmF0aW9uIGlzIGRpZmZlcmVudCBmcm9tIHRoZSBwaHlzaWNhbCBvbmU/DQo+IA0KDQpUaGlzIHNo
b3VsZCBiZSB3aXRoIGEgc3VtbWFyeSBhbmQgbGF0ZXIgYmUgZGVjaWRlZCBpZiBtZWRpYXRlIHBh
c3MgDQp0aHJvdWdoIGlzIG5lZWRlZC4gSW4gdGhpcyBSRkMsIGl0cyBnb2FsIGlzIGp1c3QgdG8g
cHJldmVudCB0aGUgZ3Vlc3QgdG8gDQptb2RpZnkgcFJlZ3MuDQoNCj4+DQo+PiAtIEVtdWxhdGUg
Q1hMIE1NSU8gcmVnaXN0ZXJzLiBDWEwgc3BlYyBkZWZpbmVzIGEgc2V0IG9mIENYTCBNTUlPIHJl
Z2lzdGVycw0KPj4gdGhhdCBjYW4gc2l0IGluIGEgUENJIEJBUi4gVGhlIGxvY2F0aW9uIG9mIHJl
Z2lzdGVyIGdyb3VwcyBzaXQgaW4gdGhlIFBDSQ0KPj4gQkFSIGlzIGluZGljYXRlZCBieSB0aGUg
cmVnaXN0ZXIgbG9jYXRvciBpbiB0aGUgQ1hMIERWU0VDcy4gVGhleSBhcmUgYWxzbw0KPj4gb3du
ZWQgYnkgdGhlIGtlcm5lbCBDWEwgY29yZS4gU29tZSBvZiB0aGVtIG5lZWQgdG8gYmUgZW11bGF0
ZWQuDQo+IA0KPiBkaXR0bw0KPiANCj4+DQo+PiBJbiB0aGUgTDIgZ3Vlc3QsIGEgZHVtbXkgQ1hM
IGRldmljZSBkcml2ZXIgaXMgcHJvdmlkZWQgdG8gYXR0YWNoIHRvIHRoZQ0KPj4gdmlydHVhbCBw
YXNzLXRocnUgZGV2aWNlLg0KPj4NCj4+IFRoZSBkdW1teSBDWEwgdHlwZS0yIGRldmljZSBkcml2
ZXIgY2FuIHN1Y2Nlc3NmdWxseSBiZSBsb2FkZWQgd2l0aCB0aGUNCj4+IGtlcm5lbCBjeGwgY29y
ZSB0eXBlMiBzdXBwb3J0LCBjcmVhdGUgQ1hMIHJlZ2lvbiBieSByZXF1ZXN0aW5nIHRoZSBDWEwN
Cj4+IGNvcmUgdG8gYWxsb2NhdGUgSFBBIGFuZCBEUEEgYW5kIGNvbmZpZ3VyZSB0aGUgSERNIGRl
Y29kZXJzLg0KPiANCj4gSXQnZCBiZSBnb29kIHRvIHNlZSBhIHJlYWwgY3hsIGRldmljZSB3b3Jr
aW5nIHRvIGFkZCBjb25maWRlbmNlIG9uDQo+IHRoZSBjb3JlIGRlc2lnbi4NCg0KVG8gbGV2ZXJh
Z2UgdGhlIG9wcG9ydHVuaXR5IG9mIEYyRiBkaXNjdXNzaW9uIGluIExQQywgSSBwcm9wb3NlZCB0
aGlzIA0KcGF0Y2hzZXQgdG8gc3RhcnQgdGhlIGRpc2N1c3Npb24gYW5kIG1lYW53aGlsZSBvZmZl
cmVkIGFuIGVudmlyb25tZW50IA0KZm9yIHBlb3BsZSB0byB0cnkgYW5kIGhhY2sgYXJvdW5kLiBB
bHNvIHBhdGNoZXMgaXMgZ29vZCBiYXNlIGZvciANCmRpc2N1c3Npb24uIFdlIHNlZSB3aGF0IHdl
IHdpbGwgZ2V0LiA6KQ0KDQpUaGVyZSBhcmUgZGV2aWNlcyBhbHJlYWR5IHRoZXJlIGFuZCBvbi1n
b2luZy4gQU1EJ3MgU0ZDIChwYXRjaGVzIGFyZSANCnVuZGVyIHJldmlldykgYW5kIEkgdGhpbmsg
dGhleSBhcmUgZ29pbmcgdG8gYmUgdGhlIGZpcnN0IHZhcmlhbnQgZHJpdmVyIA0KdGhhdCB1c2Ug
dGhlIGNvcmUuIE5WSURJQSdzIGRldmljZSBpcyBhbHNvIGNvbWluZyBhbmQgTlZJRElBJ3MgdmFy
aWFudCANCmRyaXZlciBpcyBnb2luZyB1cHN0cmVhbSBmb3Igc3VyZS4gUGx1cyB0aGlzIGVtdWxh
dGVkIGRldmljZSwgSSBhc3N1bWUgDQp3ZSB3aWxsIGhhdmUgdGhyZWUgaW4tdHJlZSB2YXJpYW50
IGRyaXZlcnMgdGFsa3MgdG8gdGhlIENYTCBjb3JlLg0KDQpUaGFua3MsDQpaaGkuDQo=

