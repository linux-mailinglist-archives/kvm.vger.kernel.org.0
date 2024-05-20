Return-Path: <kvm+bounces-17751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C62A8C9A0D
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 11:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 852B11C21095
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 09:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975F41BC57;
	Mon, 20 May 2024 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPAyGMq5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF60200A0;
	Mon, 20 May 2024 09:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716195742; cv=fail; b=brWKyykuw5Rdmj9FliFmw+dWkd4/fHfDvIACj3waqIMLSTDxhQ0IUm/BWfd3dChTsJ/rm7IUXOgpg1YEUgndpQLRCRBXTK4ZFZ3N00P732NfF589jjU5UOOU+GBJuRAu0QrpP8xSIn4eNK47AShns4dJbjKVuxMR8HffZSOIuwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716195742; c=relaxed/simple;
	bh=vzbTaDb+prHshYibdSQx8lvtu8zNAjXovi3pfpSJXEM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VSB2GaXopq83ECrYEnKyvXgrg1u1wNwSda+9N/K3UB9PmRFA+bi7LDN+2A5q27rLB6+I3AyhXjFmAoEteNgRVt40ILBvvh5YEXgLvFhvIFpYI7wdY44u8TjN/15l+cjHsIVHb80ASpHWlbs1XLm9QFs53jfO9b1BAzUeuEWFvW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPAyGMq5; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716195741; x=1747731741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vzbTaDb+prHshYibdSQx8lvtu8zNAjXovi3pfpSJXEM=;
  b=IPAyGMq5hSUVMXx23AuN0k1NjGRO1geSYHmBL/9xPO3Npb6XgvZbEhIS
   VBPpdE6+sg3pl4KT4u8HkBs7dIf1/09r4UNICHIuqWyZ9+1eIgbp678M2
   Msh3V4b63f7/5LszJ+7S9rAT4L5a5KB3sNXMT88mxRunDkaL8ejtscCSg
   QYJfd/nzuOKioxSMwtxHRO8kYWwf1974DX7eychXMnyIIfBbXUqF2hDHH
   oovCwFYqVttvS3FOvQm6Q2Kc3T1nsRm/eRDa5/SUyEwAPR1yLolE7LDIA
   9yYmQP7HkIxr7Nw7FI6PW1Yq0pfuwWW/gBaHUf1Cyj+GNHbEnnTn7k1nt
   Q==;
X-CSE-ConnectionGUID: NyPnx+XFSieplE7rc4HXnw==
X-CSE-MsgGUID: YmojP7LQT064siRjI9QKTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="12252989"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="12252989"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 02:02:21 -0700
X-CSE-ConnectionGUID: lr/PuSHoQ6GvOZO6wVDzhw==
X-CSE-MsgGUID: qmgohraDQ7G2FdtqJpgCHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="32368251"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 02:02:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 02:02:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 02:02:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 02:02:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hziklOwo87midpZB9zVz7zBLr6l8B7ISIAsRlWnqYOC1vV9GfpQHHYu1OOSkhtUlsvdGHG2ncdZM+qcY50Btl8Mf7vzJd49ofvG2DaqJqS9Myi7tkc15fWsya5iocI0u7ANGuAmKzaNhejjLYXG4PK8sBah9/n4N1f/HD1YdCZ1KBsvhzruS0Q2FXARAzLDaDMuGFV5i45K+smNx17ZwtY8ukvCo+qKYOFyyatePCW3PezvRPMU5GdxmSmCih1mGqDYoIekvoV9MQrn8TU+JjaRROyJh3jzRHZsy10uFuzbzrAcqv3Ppge9UMORfHeQ3c3dwZYg9KeydCPmLV0Ky7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzbTaDb+prHshYibdSQx8lvtu8zNAjXovi3pfpSJXEM=;
 b=VaXZdKj5F+wSZSYZ37MHvKmlZtWL7ulK+wBJlqrR9wNXrL+MUwbysamvH9O3EByg1j1V1Rl/AapkGwkGAEdacGvgR7nIo1ltoaCyvmKSbztMrKkafrC0Dn1r/IQEoCvpvN4OCfhohTsTSkhSb28+GBcG0x7dDPhFF/slwIZ9hn3GL0s4MMQjCP50+a+r0BkQbatauJWdjBXFjn7yVw0jGJrU0t1q6KG7y9ISJMVwYHemeYu+Qem9rey6qT1mK0fSeNlNjG2pX1bBMQhCiEafUEKOw0aPvp03D/DtBfXTrgJ1lXQzBZoT8coI7y9OoAbLbvMtfFvODe4IRPDzGngFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6417.namprd11.prod.outlook.com (2603:10b6:208:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 09:02:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 09:02:17 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Thomas, Ramesh" <ramesh.thomas@intel.com>, Gerd Bayer
	<gbayer@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Niklas Schnelle <schnelle@linux.ibm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>, Julian Ruess
	<julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>, "Thomas, Ramesh"
	<ramesh.thomas@intel.com>
Subject: RE: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
Thread-Topic: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
Thread-Index: AQHalzGQ+7A272GmCEOxwr4AhFHNf7GbW+6AgASdMhA=
Date: Mon, 20 May 2024 09:02:17 +0000
Message-ID: <BN9PR11MB5276194485E102747890C54D8CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-3-gbayer@linux.ibm.com>
 <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
In-Reply-To: <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6417:EE_
x-ms-office365-filtering-correlation-id: 24e58d4b-e4ee-41b4-06a6-08dc78ab8ccd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ekU4Yk4yUkhmSnBtaGpDS3RkN3RkN3RJc0RRMFJCL3NoQmZJdzcvVG5IUnhj?=
 =?utf-8?B?TFdibVgremlwdzBWY2kreWFPcm5LaU9QeTYzTXlZaXRZQVNwZnJDYXgzSHV6?=
 =?utf-8?B?RjNKazNQNHZoS3pSSml2YjNnK05PM0tIeWMvVU9IZ1hySm9nZkl3NjNFeWJO?=
 =?utf-8?B?UzYvRkxZbEF6WnhOOVVDaURLQzZWa2t3NkczOUZkSWZZaUgra2kyM3BHb0xx?=
 =?utf-8?B?OEhHYTlxSUMzZzVLU1AzU2xEZ0x6M3hYTkE5TzBnc1MxK0lUc2dNM0lKWUlP?=
 =?utf-8?B?Q2t3UDJ6QlR3VG4vUkhzZlhaMzdZRVdtYjhJSXJqSC84dkFIclozYVEvZm5P?=
 =?utf-8?B?T1JrM1dBWDFJUlZ6K1ZXOUJqK04xY2o0QXN5L09mZkpmOFBDVng4Q0FkUEJM?=
 =?utf-8?B?NWVtZDdiQ2RNRlZ6bXd0U050QTJ2UWhXc0hCVmp0WDlLZTNJcnVRSFlXUVI0?=
 =?utf-8?B?eGF3bjdrZy9nc0JVQzVRRERBRG14NFY5aWJZWklkbkMyd3gwK0l3ajVyamgz?=
 =?utf-8?B?UVlraGFEemExN2tvWGVVZThXaCttQnRqMGUxK3dhcWdia3lDeGpBZ0RRQTdK?=
 =?utf-8?B?RjZCb2JJaUFnRFB2UGRsR3hVdUVZWWxTRExIeUgyaDloVnc5MHpDRVAweUpH?=
 =?utf-8?B?NE5qY2lLNFVHc3JBOUtwUVJRWFFnYVpJOFBzVnR3TTk3WjhHVi9KYkh4Z08v?=
 =?utf-8?B?N1JRVFZvaU5tSFBXWWM3YXk5Y2hZRkJ4UVNITERaRlhVR1NQRWdYMm41Nytz?=
 =?utf-8?B?Zy9BRW51YkxVbXBKajRCckU0T2g5RzZyeGZ1cnd5a3FxVkJ2VjhjQTZCMTZP?=
 =?utf-8?B?Q0EwYnBYWlF2aGFDWlJDNERpRVBJczFEVGUxL3RxRHBwd1hzekx2dUdpZ2VG?=
 =?utf-8?B?WThGRWxBdUZZSGw2SUZvck94YmhKUmtMdXJXZmZMbEIvSWtZaDA5bzdVdk5s?=
 =?utf-8?B?U01kalEzb3dxZlhRSHR0QmNydTVVTk1rZGJtRnRxNkgrMkdlOU9UT2lsNldl?=
 =?utf-8?B?MXJ1MGxncGtKWi8rK0liM0gzM3pBOWxzUThHZGhPcXAwYjc1VGduSzJkQkdz?=
 =?utf-8?B?RHVWWW4rckxFS1FFK1IrTnNjcGZJUENSU0NmVmg4cXJEVzF1d1ZUbjBQVjVl?=
 =?utf-8?B?QzlwU1lKUm1HTSt5cVZxUHQ5U3VNc2piKzJnUlZScjJQc0xjWWM5M1VhQWla?=
 =?utf-8?B?bG9CMVEwUmJyMWY1VlhwU1p5cjg1MWExVDlyb1lyZncrWkQvR0lINzR4VHVY?=
 =?utf-8?B?WWErcFJzdy9rTUY3WVowNld4aTgxZGlWaVRnQk9heW40c1FlSHFIMCtwMEZR?=
 =?utf-8?B?QlZGUHhGNElmdjhHMU1vMzAzM25GT0lqZ0FsRGN2NWtWWnpVZTdUeDhHSUxC?=
 =?utf-8?B?R2xNcERTWlZtakdGbnpta0JzUGlVeUI5L1N6VXB2VmQvTHhRaVVnYUE4TnBm?=
 =?utf-8?B?aW9pL0xNVTNMYjl1WG93UVpQRlA5QU5IbDUzQUg1VVp5M29iLzhXeVRPZkRD?=
 =?utf-8?B?dWhqMGozMWxYL1VTOUEvYldJRmsxSWIvQllQV2JuT0t2ZVlLbkpObzEyR25L?=
 =?utf-8?B?ckNsUlJuMDFETTBuYnBtbXhjR2E3Y0UxSVgyRWdSQ3lWNVZUajhmS2dERUdY?=
 =?utf-8?B?U2ZtbGtRcFdzVHdWS3ZHU096aTlOSnBicEcveXNabG5wbDc2VTlXZk0zdHQ1?=
 =?utf-8?B?dWZyem5NendUUldJTkFsZ1UwVEFZNjV0SlAvRVNoWGJZODV3RHdzWXNzZ21U?=
 =?utf-8?B?Ym1GeUpRaGcwZ1VwNjh5dU9sTEtqelVCRUxLZWwzMXREV3ROYWMzZXMrOTM5?=
 =?utf-8?B?NzBqUGN3ZnZET2hXWktxdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnZmd25Hb1NFb3RZeGhJWkdLYWtKdUpOMlhSbjNUL2E1cEZHNE9ObmMzUitX?=
 =?utf-8?B?ZmRwRHo0WDd0N1JlUUpiMFZoUGdYZFA2UVRhUjlYaW1YV2I3U2lOMFRkb2NX?=
 =?utf-8?B?L1ZiQWVLNlRIQWdCR2xMdzhkd2ZkbDdveUdaMUFOMytycDVGaFN0ZVk0eUFw?=
 =?utf-8?B?MkthQmU5L01nL2tQdlpKUjZHTUg3U3g4Q04yUmJOa0NnZjBMK1ZabE0vYmNk?=
 =?utf-8?B?WWt2R3p0V1JteFhBbjRXSU52dnhPQS8wa29sYVQ3bUxseHlKUFhWNGN5Qmtz?=
 =?utf-8?B?YjZOS3dZa2htTjhjZ0xLS2xxYkJxbG9rdWxteWsyZklFVW9WSmtIdER3UlNT?=
 =?utf-8?B?V3FBV0hXWWthSmJjc0Y0Y1lsQlp5bSs2dzdVQlkvTUFGYnN2dEIxbGhsdEts?=
 =?utf-8?B?UENZLzhSTmJmNEp0RHZNdWdqYTQyRlVCeUF3ekRRdmxaZDBMVVAxNkJ5eGU5?=
 =?utf-8?B?V0JTU2JEaTB3Q0RESFBpNFNvcWgwanUySG9EQ2RGb0hyN0ErYWxxUDlGaUhj?=
 =?utf-8?B?YU5mamR4dzQzajJLYUJKMmQ5NjhnVXlRM2llN0NuSkdpTWNvTFIzcG01MC9m?=
 =?utf-8?B?K3BRUjhpNGp4MWdvV2lZdXhyNDhIZDZBVUU3OWpMcU9hcFlxQkVsSk0zN3ND?=
 =?utf-8?B?dEM3RFV2eGpxWjBkTUloQ2lOSG5YeU52TFk0QjJMT09mOVVRb1dlOUdwOUZV?=
 =?utf-8?B?VGlLMXVWVXlPQ2hRWExndld2MFowQklCTGRPd2hHQXoyWTJMMHBJYmZGU2Z2?=
 =?utf-8?B?b1k5bjJBTkNEOWhrWWwxbHY0Y0EvUEhzdDgzNnNXaVozNDVpY1E4S0Z6RU5H?=
 =?utf-8?B?SjY3aGREbWJiRThFaHFrU3ZVc3lEVE9Fb2g5a3QwdUZSVU9XOGFReEw0UVFh?=
 =?utf-8?B?Z01md2srOUx2M3p3SUtoU2E3eVdsakdDTW9VZWRMVFE4Z2JyM1kzc3Bab1o2?=
 =?utf-8?B?MVN6QVNsS1hRSDdPcm45NHprdjVueWNWbWlGeW1Ub0lzZ1NleUJtSmVmSVJt?=
 =?utf-8?B?NjZTM1pUUno2cW5ZZE5JeGVuK0pIdWhaME1od2w0VzZDQ0lmYmlDVnJnSlRJ?=
 =?utf-8?B?bGRnSFRVVWdSbmJxSzc0cndXRVhrcTNvbzhDbnVHVDhKRFUvQ1J1OGMwUjFz?=
 =?utf-8?B?VnE4akZMdXpzQ2dpd1JKV1ZnSXdHSEpqRGhmeVQrVDIzVDgrN3pNRnRORHRN?=
 =?utf-8?B?eTJUS3BKUFBsYmdaYVNDbVBwelM0VnZzVU5HQXFabkZHeWRsTnBKcVRRSkV4?=
 =?utf-8?B?WmZZQTRvdjdta2hLd2g1cGVlZVlXQ3o0bzZ5T0RyaHhUbi9YaVBaQlZKeE12?=
 =?utf-8?B?Q0pLTkdhSTJyUUI5Z2FNV1FBZEJvTzNYVVVpUm1JalpOTk5OWCt0WDBHdE9n?=
 =?utf-8?B?bG5JSVArTGU5VGduRVhOOHhETnQzdmNqbDJLWHEyQ2t2Q2JOcDZtODUwTUdY?=
 =?utf-8?B?TUxQNzkyOHlGYm90YXYycWMyUjh5ZXc2TUVXYzJVd0NVZ2hjRjNmVEkyZG85?=
 =?utf-8?B?NVQ2ZUpuNWlBbnd5SmxlSGJIdTBNT2Q0K0FXYUdVOEZ4WnFpZmgweWNZWnNh?=
 =?utf-8?B?dms1Qk56WHorZXBmSmlCNFNkSmlUQTJpaGcxS1VjMDBmVmF4U1dtWjU0Rkdh?=
 =?utf-8?B?eFdscXh5emhUejdBQ1UzVmFtWWNIemVqVGVPKzhsbjFoZER0N01ZRzU4anht?=
 =?utf-8?B?SGhNck0yVlZTMWRHNUlvQ3ZqQjRqKzhpMHFvNE1zbUxvYUQyRVJsb09OcDZG?=
 =?utf-8?B?WkhtRC9pb1VWTUZlZHR6MU9hbkxsNjdEaHBaZFpyR2I2Q0tyNGtKdTRHU2o5?=
 =?utf-8?B?OE56OUd2N2lQWVRJWkJjaWF5eC9Ib0Z5QXZYY0JpZ2JaL1FMSndlR3RxS3lT?=
 =?utf-8?B?dHU2ajJSbktodzU5c3RzcEplU0wrTWs1MFJhU291S0JlbHd2ZDYrQkJtRFk2?=
 =?utf-8?B?UTU2UWtlUHU2ZGlkaGYvd3hWcHZ2QTNtb1VTVzFPM0lMNXNjYU1qTzVMbjdl?=
 =?utf-8?B?VDJSVmNOYXI4eW13RGRTeWhSaXNabkRVT0NvRFk4b0dXYWFZbGVCOE43WktE?=
 =?utf-8?B?MEF5MTI0Z09nNlRvaUZXc2lzeVArY2lUU3UzZE0ybDJ4aGpSRDJvOWducDMv?=
 =?utf-8?Q?Yb0NmMVfPEhhrys0Cyl0TyGWc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e58d4b-e4ee-41b4-06a6-08dc78ab8ccd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 09:02:17.6572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBN3069BHQ7u8wFLv7pO563oiRDFI6CIvGDmdq028esDACCnXQAYvuoXRo2AtkeQYZWjLjCyAFfppofr5qXTKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6417
X-OriginatorOrg: intel.com

PiBGcm9tOiBSYW1lc2ggVGhvbWFzIDxyYW1lc2gudGhvbWFzQGludGVsLmNvbT4NCj4gU2VudDog
RnJpZGF5LCBNYXkgMTcsIDIwMjQgNjozMCBQTQ0KPiANCj4gT24gNC8yNS8yMDI0IDk6NTYgQU0s
IEdlcmQgQmF5ZXIgd3JvdGU6DQo+ID4gRnJvbTogQmVuIFNlZ2FsIDxicHNlZ2FsQHVzLmlibS5j
b20+DQo+ID4NCj4gPiBAQCAtMTQ4LDYgKzE1NSwxNSBAQCBzc2l6ZV90IHZmaW9fcGNpX2NvcmVf
ZG9faW9fcncoc3RydWN0DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LCBib29sIHRlc3Rf
bWVtLA0KPiA+ICAgCQllbHNlDQo+ID4gICAJCQlmaWxsYWJsZSA9IDA7DQo+ID4JDQo+ID4gKyNp
ZiBkZWZpbmVkKGlvcmVhZDY0KSAmJiBkZWZpbmVkKGlvd3JpdGU2NCkNCj4gDQo+IENhbiB3ZSBj
aGVjayBmb3IgI2lmZGVmIENPTkZJR182NEJJVCBpbnN0ZWFkPyBJbiB4ODYsIGlvcmVhZDY0IGFu
ZA0KPiBpb3dyaXRlNjQgZ2V0IGRlY2xhcmVkIGFzIGV4dGVybiBmdW5jdGlvbnMgaWYgQ09ORklH
X0dFTkVSSUNfSU9NQVAgaXMNCj4gZGVmaW5lZCBhbmQgdGhpcyBjaGVjayBhbHdheXMgZmFpbHMu
IEluIGluY2x1ZGUvYXNtLWdlbmVyaWMvaW8uaCwNCj4gYXNtLWdlbmVyaWMvaW9tYXAuaCBnZXRz
IGluY2x1ZGVkIHdoaWNoIGRlY2xhcmVzIHRoZW0gYXMgZXh0ZXJuIGZ1bmN0aW9ucy4NCj4gDQo+
IE9uZSBtb3JlIHRoaW5nIHRvIGNvbnNpZGVyIGlvLTY0LW5vbmF0b21pYy1oaS1sby5oIGFuZA0K
PiBpby02NC1ub25hdG9taWMtbG8taGkuaCwgaWYgaW5jbHVkZWQgd291bGQgZGVmaW5lIGl0IGFz
IGEgbWFjcm8gdGhhdA0KPiBjYWxscyBhIGZ1bmN0aW9uIHRoYXQgcncgMzIgYml0cyBiYWNrIHRv
IGJhY2suDQoNCkkgZG9uJ3Qgc2VlIHRoZSBwcm9ibGVtIGhlcmUuIHdoZW4gdGhlIGRlZmluZWQg
Y2hlY2sgZmFpbHMgaXQgZmFsbHMNCmJhY2sgdG8gYmFjay10by1iYWNrIHZmaW9fcGNpX2NvcmVf
aW9yZHdyMzIoKS4gdGhlcmUgaXMgbm8gbmVlZCB0bw0KZG8gaXQgaW4gYW4gaW5kaXJlY3Qgd2F5
IHZpYSBpbmNsdWRpbmcgaW8tNjQtbm9uYXRvbWljLWhpLWxvLmguDQo=

