Return-Path: <kvm+bounces-15592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F277F8ADC04
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A85B1F22A6F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A491C694;
	Tue, 23 Apr 2024 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gfwD5+jT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDEA18641;
	Tue, 23 Apr 2024 02:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713840280; cv=fail; b=F3xlq8od6Yua8HE67iPIpiuiwf6wMfHKYtfC8BpyuflRMV2kYrUM4VWihKtb6TjY8fUePiYTCmgkAag4JbFFFvSzcWqpbVhO2XRh61n/sZR6kZlHPb5Gi7kKt0Bn6f9IullZfKzcfd+za9e97vHoHDNzy6h1VNgGaMzdRM8zzoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713840280; c=relaxed/simple;
	bh=nkgj4u6gZMJuXoD6oRpk8yepRi6i1FSSKI9PzSZ114Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jNU0PNFg0KOotjANA4wjmFENE/O3bG03FpxbTJS3ywd+UQkd5Z0CwVkwp5Goyd15Tw6W9wbgqQTz+eyK3A5uR0mdffB+b3dlwj3oMfaE3E49iVoQM7PzVJ0hIGbXJZsbjjXAz2NnHQ0ir+YPvv/7oWeaX+qeO9KZugfVfaUayRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gfwD5+jT; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713840278; x=1745376278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nkgj4u6gZMJuXoD6oRpk8yepRi6i1FSSKI9PzSZ114Q=;
  b=gfwD5+jT4is7qF7ZNA2ebN0nshUle++ZgyfZ2ZMlRKebwUX/IHlfzSqA
   tLe+kjEdmHJnl5SJhtF1W4S59nH9+o+sQFIpCE2qaFgIKVE9IsEkRKw+/
   2JiBLZh29auM2bmcX8y+CphfHSVIxvh9X/vUoq/sY5e1mOqhjreeoDHRO
   eKkiUHtIwQUTMoR2qlyXT+xbdB9eWbipiWenXiIBOT3WbH6BxadHgOSSd
   n3id2dv6CwwhbUxAEQl7nZAXYIMwcRL4QjSeeffXT6ZBC0SqSwO5kLTSx
   RTpvJb9BzEINE2Tzq3ZTmuFaZ2G6lPcD4bygVfgujkY2N9rHB/A4lLS20
   A==;
X-CSE-ConnectionGUID: s1q+Vs6PQV29RrShWHUikQ==
X-CSE-MsgGUID: R6tSHdS5SJaCEVu4AVX6UQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="20103238"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="20103238"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 19:44:37 -0700
X-CSE-ConnectionGUID: Pl4HoDgtRXm7rCGBPkzKeg==
X-CSE-MsgGUID: hT7/05F/TiaicwB3ELohIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="55430373"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 19:44:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 19:44:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 19:44:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 19:44:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 19:44:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNHWN9FS8nLwX0OVyfU/U8zu4k4xrcbMcEAV5cK37AsQJ8nQSmS5ob4ybN9k5PS1n2IUzcAVabOXdBZSJf/BOtrLOUhRcfzozxeTYOiktoDbNajIytXqQjDvdpUu5/cBnSdUQUcXNkkx536UVkP0V/rSBT23dTUSV5DMz/hILprBJQ/2ckVFysrVhP17Boq8qmPOTcE0R4yxeSuTSPwXw/0IBBadNmF23xy6BQJ1h+HmC2W3/08327wd9t/pz7UiOzIdmXWiYD9Cq2jvglqaiov53Leg1k9KWsYIj/EyPa2lKqHvUPVyCHwoF2dSdD+PDRTTaqiq6wfE6vcJSlAZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkgj4u6gZMJuXoD6oRpk8yepRi6i1FSSKI9PzSZ114Q=;
 b=guvkQyVXbf0SLF5gAJ2KTeO1nSDHVBGHG2A8niFWrjjV1+V0ViyPX8M7IacISEjcWXPH5NwKfT3e69ELfJbpTS1J836c59a7ox9Nsc7QhN8+hUq6+2G33884XQt3Xt0UCvpao6XALsTZ3SBcXclcBJRkTtCh5qki8eOr0tyA4SGghBghIQtC8EERzNIFbr95b011lLEASb7bFhJX1jkV/aBT9rsHg2cFcXQzBN3txUCIsFgHZdpK1iDMSJ4XQfxwhQQhhJ1fqcy5lq7dwW8prbOT1exCJUXHakqA6vC3Pe1uOFD1LSOqS5evvADbWYAtX++0KEvPQj3oNVWvKPmj8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7550.namprd11.prod.outlook.com (2603:10b6:510:27d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Tue, 23 Apr
 2024 02:44:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.020; Tue, 23 Apr 2024
 02:44:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "Zeng, Xin"
	<xin.zeng@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV
 VF devices
Thread-Topic: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Thread-Index: AQHakNVVVTUb/4qbx0yNW3Gu0hQhQbFupRgAgAA6STCAAMXAgIAFgaEg
Date: Tue, 23 Apr 2024 02:44:33 +0000
Message-ID: <BN9PR11MB52768D9ADA48E18CB99BCB768C112@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
 <20240417143141.1909824-2-xin.zeng@intel.com>
 <20240418165434.1da52cf0.alex.williamson@redhat.com>
 <BN9PR11MB52767D5F7FF5D6498C974B388C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419141057.GG3050601@nvidia.com>
In-Reply-To: <20240419141057.GG3050601@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7550:EE_
x-ms-office365-filtering-correlation-id: cf31ce04-02bc-4c5d-b75d-08dc633f4edd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VVFCNnBkOHp0T3F0Rm40SEtBSmp4d1VTTFJmVGdkaFY3NC9MbXQ3MGozN2po?=
 =?utf-8?B?WDFiQUlwRUVKSERxYUhzR1A0em00bTRwWXR5RnU5V0ZiTk9takxKeFYxVzZi?=
 =?utf-8?B?SUdRVTNwWlRUZmJUVG53Qkd0V2cvNHpYTERkTmpqMnJrTXBSRzdTZmx6V3Qw?=
 =?utf-8?B?b0VvSUp6cFFYTmFUVXl0K2RLaW52dWlxc1BXeXcydVVxRUM2b3FmOWVxZnZE?=
 =?utf-8?B?UFd6aDFXLzJWckVsRzZHNThpOUFWUE1UQXg3NWorRktxYStCZGxOd1I4Vmc0?=
 =?utf-8?B?NGZXNFQrZ0tpV2dzYVI1T2NaMTAwVWJpK0hqdlZuZHIyYklEbHk3a0xSNGlC?=
 =?utf-8?B?VEtMczlkakJGeThrNWgwbThLVUNHVnFLcExYYytUck1NcWlHZGUwRHA1Tjlz?=
 =?utf-8?B?ZXpvMGtMb21jcElDRjdiTDhQazJnOWovWHBRbEs5ZFl2bFBYWE8ydE81RW82?=
 =?utf-8?B?cEthTHcwSlF3WlhXOFFOb2UzdThhM3g1MWtYcy8wNlFITUxTUzhFMW1WNXh1?=
 =?utf-8?B?ZWY1UWF5a29XWFZkSFZtS2VBVzZIeUtMeXVvVnVmaTBUWmwzcm5weFFLbW84?=
 =?utf-8?B?MnFXMUhrQ3pMY0puVzY2aERrQnpHUnFCSldkTDJML2JUb1N1cG9OK3Q0U2Mr?=
 =?utf-8?B?bmw3VXlWL3hCeVM3Q293M0t1ZHJmTXYvcWcreWRRUGVzdDFnM0Q3dWxyYVR2?=
 =?utf-8?B?Zjd2NTlVc281ekVRNDlWWFRHWkdFbkd3eTY0a0k4bEtKRjRkTlNIem5aQWRF?=
 =?utf-8?B?VjdBNTByRCtxbGpqRlhJd0xiRkxHblB0ZitEMVdLOWg5cmN3ekJ4MGUxVkpO?=
 =?utf-8?B?dDV1OXcrWFpJcEpXYm5sSFFhYUkzbTgrcHNyakdtVExCMTk0SGFuZHhnRG9M?=
 =?utf-8?B?YlVKUVNpUlFpZFpFQ3NFb3dsL05SQU42UTZLYzdXWHNJMGZ2amp3d2xkMVJQ?=
 =?utf-8?B?SGtIR0d6TDg0aFcveGlyVklMSk13R005YlN5SWZ0aDEzZ0x1dWJpeDlFTis0?=
 =?utf-8?B?QTYwZVNVbzhpZEhZVWNFa2pjdW1XeTE0UWRQV2ZVU2t4QzZnVDFHZ0tBTDdz?=
 =?utf-8?B?S1NCS1RnU21vU3lXcS9yZTZSeWpqYzd4amhyK3lrbkZLbEh1SXlTTnR3K3Qx?=
 =?utf-8?B?MThwSHBWRVM0QkNPOFRnWWxxbm5YbC91WkhYOGNmUzhDOEtjNUNzMGExeW1P?=
 =?utf-8?B?S05SVlVmdnQxKzJQdDBjcm8xaGNrbzk1bjdGT0gxQWI1Z3Y1Mk1MWDU2TEll?=
 =?utf-8?B?SUNFMER0VVpFSmYxb3krU29XZXVROTA3N1lZeEtQa1MrM1VOUHNESWxaOVYw?=
 =?utf-8?B?amJ4ZGh1cSttVDNXb1BCanN6Y0ZKbThoTjBEK2tSL21sL2ZNVjExR3RTbjBB?=
 =?utf-8?B?T2RoQXF2aVhyOHNFRlNHM2tVT3ExTzhTd1RoZjZHMnIvOVB1REVzNlFrYytx?=
 =?utf-8?B?M1ZaemJXSnAyaGhGNTJPT1NKb0ZmcEVscFlMK3NCR09QaUhRZk5hWmFrRk5T?=
 =?utf-8?B?L3hRdkJsOEpBc2pkNFBrL2hYWHRlNEx5aW14YzBCcG5ubjJ6ZGpSTm5yUnRs?=
 =?utf-8?B?S3d6QlRJblptc081cXc4WGcwN21ENFFUVjlSLzJXUmFsUVJwelU3eCt1bi9x?=
 =?utf-8?B?REIrbHpwT3VHOEdKdHNTVStkY0xOcTI5Y3g0OG1MSW91dHZFYmZqS1Z3Z09V?=
 =?utf-8?B?YmlrMUEvR3hQYWpjbTZuRlZjY2pVU2pQWkNqdTc4SlFBUWM4d3A3ZlFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXp4Z2kzMndPVVp3YjZSc1E4SnBZM2JPcjBiV0pZS1kyekFXaU9nNVJ3di9D?=
 =?utf-8?B?TnNvaGlHY1FlSlRlMDVEOUw4WkVtNFhsMzB6V3hmSzYyKzl3UGFMb1hSYjRn?=
 =?utf-8?B?QWtEci8wT3NKUElIUnZrOVFPc1ByaWVGRjFDNUlMQ05qY3lkTG03SmRXRVdW?=
 =?utf-8?B?YzRPSWNzRlpWQWErOWdlTE02OXFQWFcxTUMyNWhadHI2bzFUckh6Yy9ydGFz?=
 =?utf-8?B?NHV1VWorWURCbmlFZHBVU04rUmMyd2JldG51YU51elFGSTdSTjhFdXJNbXp2?=
 =?utf-8?B?Y09GcG5oci9sQnZXa2Q2ZG45QU5uYVkzVzBFanFvRTU1VUZqS0tPcHpTSXNQ?=
 =?utf-8?B?U09BTkJGTHdLdlMwcUdRSTU1bHRTLzBuTFE2K0R3RHA4K29IY1FhM28wMjhm?=
 =?utf-8?B?STBjM3NrRUNKSTRDNjIyVDFhbGlpRHFKZ2crcEk2WHhjZWNsVkhSakxhOWZu?=
 =?utf-8?B?SUUrOE5YRXU4eDlqdFZDTEM5V2pTQVlPb0NucTJsazJkR1JldEdtaVhGTk5C?=
 =?utf-8?B?cEtjWGpPTDY2eTM0SHZkRUVsWjlHMUFEVEFzTzlCZDI5cmthQlV4RmpIUUQ4?=
 =?utf-8?B?RjlEOGJTa3J1MVpuUlovOGJnZ2x1ZkNtT1dJZVZZMHdNMDBodnk4Ly9MWUJL?=
 =?utf-8?B?MDVjaHBYanM3L093VHZ3OHJGMk1ZSkg2TkRrd2RadnVab1dSUmViYy95TFpD?=
 =?utf-8?B?OTl0TFltS1czbFdjdVBoQ0JEUDNDMDQ3U1BTRGdacTJZa3NqalNQNWtXdllx?=
 =?utf-8?B?TzdVSTYxQ2dQTkJNelhHc2ZBR1lBZnUxNzF5QVcyS0VZYThzeWN3YmFFWHJu?=
 =?utf-8?B?WU9ZTEIzaVMzSW9Nck1uMERJTnQzQm02MlRyZmQ1U3NLdkNzb3JnU0xUSzdp?=
 =?utf-8?B?MHFRNjVOL01ESmJTT0VsbEIycG5TbTBwTksyN2VvTmNpellYN0x0QUtsc3Y4?=
 =?utf-8?B?Nzc2ek91VXdabVVQRWJtN01MQ1BscnRsc2gxam9QNXFCL2l6UitzWklicWdi?=
 =?utf-8?B?QkYwaXAwS2VpTVJWZnNkWUx4TmVEK1drQmdzMmxzQTl4STFVclB0NkRWRktS?=
 =?utf-8?B?ek1pV0hQM05Kc1dCbERQVHM4S1p4dmFzK2VJdis1MU5wVDhOK3dlRHd3UHJh?=
 =?utf-8?B?WVNvWEJWdWlGR0tzZXB0U3dteXI3Z1owNUt5Rk4yblI1ZzBiZzNidzB0UDU2?=
 =?utf-8?B?NG1qS1R4YnZxdUZTK2RuTjI1aHU0amNZeHhEVTdtTWxPUUFUZTVZZ1oxS0gw?=
 =?utf-8?B?M3ZDQWxpbVV2RmNla05Jb2dWdTd0aXh6ZHF0NWMrS1UvWFBOOGV6V29EQmZK?=
 =?utf-8?B?WjkrRDl5QmxqZE0xYkJNZE5nR25jV1hUaFRrVzhIUGoyQUIxdGUrM0ZwYXBq?=
 =?utf-8?B?NlZrUkQ2cFlySGtNRGJzQzc3K0dicTVjWEkrVlhvMjNjS294ZGhaT0JyRkd1?=
 =?utf-8?B?UDNLc1cxNEJnVjBaUHJhbFRUblJUU0pGR2lRMmViWUY5ZU83YkVDajloSGxy?=
 =?utf-8?B?RXA1R0s0WmdVaUZ0M1NaNzl0TEdQRGZpV2ZZSUlGdEVZRnQ4cmI0bGxGbFJx?=
 =?utf-8?B?YkNmYmwyK3FiZkVHZmJubmI1UnpoU0k2K0trbVV2cCtZdEdqWWl2QmFzZWVp?=
 =?utf-8?B?N2U0c2JUS2FydHNydHFsaFg0Zk5WamlwYmdtL0tpT3lLcU5CNWhCb1dqeWtS?=
 =?utf-8?B?L0JoTFRuZVdGZkpRZ01YWjExZDRBZ1FKNDhrWWd0bnc4YTk1R0lLbmMrSFVX?=
 =?utf-8?B?WFh3SERPeThKczlMTVMrWktXeTliZ2hWYUVQYy9iM1RBbjd5ZnEvSDd6MmVq?=
 =?utf-8?B?c1hTaUVyZmRaeFYyb2xXOVAyWWdJaUdLbnpWd0N3OVVWVExUY3BBamZrdUJL?=
 =?utf-8?B?OGZ6dnlBbzFnZks2eTcxYnJjdnhxVWttby8wZndTOTRiVDdmbnVHQjlrQmFx?=
 =?utf-8?B?NmVOdkVmUkJwUFBrWmx4Q3MvK3F4Vlo4RkFyZUpDZ3Uya21tZStsaXl4bjlD?=
 =?utf-8?B?TnRHei9CN2NrZy9KcXNuT3B1bnZDenNwUjZHKysvZDRnV3RPK0JVT3pHcHdj?=
 =?utf-8?B?VmtDaEFyWGZHYTNoelB4azhpZGIyMEpGT2tvN2l5ZGVuRXpWQXdjZnNuUkwv?=
 =?utf-8?Q?L+CvZ038UsFgZEV6n2npT8gcC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cf31ce04-02bc-4c5d-b75d-08dc633f4edd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 02:44:33.6609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DF+Yn+QTXHpl5IHbau0HjISZDNA8gQ7XnLWmVhPUUKZ8vcEqWkIsmsZEWiA3NL1eAd1SgWwOQuvkrDgdep2O0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7550
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEFwcmlsIDE5LCAyMDI0IDEwOjExIFBNDQo+IA0KPiBPbiBGcmksIEFwciAxOSwgMjAyNCBhdCAw
NToyMzozMEFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+IEZyb206IEFsZXggV2ls
bGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXks
IEFwcmlsIDE5LCAyMDI0IDY6NTUgQU0NCj4gPiA+DQo+ID4gPiBPbiBXZWQsIDE3IEFwciAyMDI0
IDIyOjMxOjQxICswODAwDQo+ID4gPiBYaW4gWmVuZyA8eGluLnplbmdAaW50ZWwuY29tPiB3cm90
ZToNCj4gPiA+DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkvKg0KPiA+ID4gPiArCSAqIEFzIHRoZSBk
ZXZpY2UgaXMgbm90IGNhcGFibGUgb2YganVzdCBzdG9wcGluZyBQMlAgRE1Bcywgc3VzcGVuZA0K
PiA+ID4gdGhlDQo+ID4gPiA+ICsJICogZGV2aWNlIGNvbXBsZXRlbHkgb25jZSBhbnkgb2YgdGhl
IFAyUCBzdGF0ZXMgYXJlIHJlYWNoZWQuDQo+ID4gPiA+ICsJICogT24gdGhlIG9wcG9zaXRlIGRp
cmVjdGlvbiwgcmVzdW1lIHRoZSBkZXZpY2UgYWZ0ZXIgdHJhbnNpdGluZyBmcm9tDQo+ID4gPiA+
ICsJICogdGhlIFAyUCBzdGF0ZS4NCj4gPiA+ID4gKwkgKi8NCj4gPiA+ID4gKwlpZiAoKGN1ciA9
PSBWRklPX0RFVklDRV9TVEFURV9SVU5OSU5HICYmIG5ldyA9PQ0KPiA+ID4gVkZJT19ERVZJQ0Vf
U1RBVEVfUlVOTklOR19QMlApIHx8DQo+ID4gPiA+ICsJICAgIChjdXIgPT0gVkZJT19ERVZJQ0Vf
U1RBVEVfUFJFX0NPUFkgJiYgbmV3ID09DQo+ID4gPiBWRklPX0RFVklDRV9TVEFURV9QUkVfQ09Q
WV9QMlApKSB7DQo+ID4gPiA+ICsJCXJldCA9IHFhdF92Zm1pZ19zdXNwZW5kKHFhdF92ZGV2LT5t
ZGV2KTsNCj4gPiA+ID4gKwkJaWYgKHJldCkNCj4gPiA+ID4gKwkJCXJldHVybiBFUlJfUFRSKHJl
dCk7DQo+ID4gPiA+ICsJCXJldHVybiBOVUxMOw0KPiA+ID4gPiArCX0NCj4gPiA+DQo+ID4gPiBU
aGlzIGRvZXNuJ3QgYXBwZWFyIHRvIGJlIGEgdmFsaWQgd2F5IHRvIHN1cHBvcnQgUDJQLCB0aGUg
UDJQIHN0YXRlcw0KPiA+ID4gYXJlIGRlZmluZWQgYXMgcnVubmluZyBzdGF0ZXMuICBUaGUgZ3Vl
c3QgZHJpdmVyIG1heSBsZWdpdGltYXRlbHkNCj4gPiA+IGFjY2VzcyBhbmQgbW9kaWZ5IHRoZSBk
ZXZpY2Ugc3RhdGUgZHVyaW5nIFAyUCBzdGF0ZXMuDQo+ID4NCj4gPiB5ZXMgaXQncyBhIGNvbmNl
cHR1YWwgdmlvbGF0aW9uIG9mIHRoZSBkZWZpbml0aW9uIG9mIHRoZSBQMlAgc3RhdGVzLg0KPiAN
Cj4gSXQgZGVwZW5kcyB3aGF0IHN1c3BlbmQgYWN0dWFsbHkgZG9lcy4NCj4gDQo+IExpa2UgaWYg
aXQgaGFsdHMgYWxsIHF1ZXVlcyBhbmQga2VlcHMgdGhlbSBoYWx0ZWQsIHdoaWxlIHN0aWxsDQo+
IGFsbG93aW5nIHF1ZXVlIGhlYWQvdGFpbCBwb2ludGVyIHVwZGF0cyB0aGVuIGl0IHdvdWxkIGJl
IGEgZmluZQ0KPiBpbXBsZW1lbnRhdGlvbiBmb3IgUDJQLg0KDQpZZXMgdGhhdCByZWFsbHkgZGVw
ZW5kcy4gZS5nLiBhIHF1ZXVlIGFjY2VwdGluZyBkaXJlY3Qgc3RvcmVzIChNT1ZESVI2NEIpDQpm
b3Igd29yayBzdWJtaXNzaW9uIG1heSBoYXZlIHByb2JsZW0gaWYgdGhhdCBzdG9yZSBpcyBzaW1w
bHkgYWJhbmRvbmVkDQp3aGVuIHRoZSBxdWV1ZSBpcyBkaXNhYmxlZC4gRU5RQ01EIGlzIHBvc3Np
Ymx5IE9LIGFzIHVuYWNjZXB0ZWQgc3RvcmUNCndpbGwgZ2V0IGEgcmV0cnkgaW5kaWNhdG9yIHRv
IHNvZnR3YXJlIHNvIG5vdGhpbmcgaXMgbG9zdC4NCg0KSSdsbCBsZXQgWGluIGNvbmZpcm0gb24g
dGhlIFFBVCBpbXBsZW1lbnRhdGlvbiAoZm9yIGFsbCBkZXZpY2UgcmVnaXN0ZXJzKS4NCklmIGl0
IGlzIGxpa2UgSmFzb24ncyBleGFtcGxlIHRoZW4gd2Ugc2hvdWxkIHByb3ZpZGUgYSBjbGVhciBj
b21tZW50DQpjbGFyaWZ5aW5nIHRoYXQgZG9pbmcgc3VzcGVuZCBhdCBSVU5OSU5HX1AyUCBpcyBz
YWZlIGZvciBRQVQgYXMgdGhlDQpkZXZpY2UgTU1JTyBpbnRlcmZhY2Ugc3RpbGwgd29ya3MgYWNj
b3JkaW5nIHRvIHRoZSBkZWZpbml0aW9uIG9mIFJVTk5JTkcNCmFuZCBubyByZXF1ZXN0IGlzIGxv
c3QgKGVpdGhlciBmcm9tIENQVSBvciBwZWVyKS4gVGhlcmUgaXMgbm90aGluZyB0byBzdG9wDQpm
cm9tIFJVTk5JTkdfUDJQIHRvIFNUT1AgYmVjYXVzZSB0aGUgZGV2aWNlIGRvZXNuJ3QgZXhlY3V0
ZSBhbnkNCnJlcXVlc3QgdG8gZnVydGhlciBjaGFuZ2UgdGhlIGludGVybmFsIHN0YXRlIG90aGVy
IHRoYW4gTU1JTy4NCg0KPiANCj4gPiA+IFNob3VsZCB0aGlzIGRldmljZSBiZSBhZHZlcnRpc2lu
ZyBzdXBwb3J0IGZvciBQMlA/DQo+ID4NCj4gPiBKYXNvbiBzdWdnZXN0cyBhbGwgbmV3IG1pZ3Jh
dGlvbiBkcml2ZXJzIG11c3Qgc3VwcG9ydCBQMlAgc3RhdGUuDQo+ID4gSW4gYW4gb2xkIGRpc2N1
c3Npb24gWzFdDQo+IA0KPiBJIGRpZD8gSSBkb24ndCB0aGluayB0aGF0IGlzIHdoYXQgdGhlIGxp
bmsgc2F5cy4uDQoNCk5vdCB0aGlzIGxpbmsgd2hpY2ggSSByb3VnaGx5IHJlbWVtYmVyIHdhcyBh
IGZvbGxvdy11cCB0byB5b3VyIGVhcmxpZXINCmNvbW1lbnQuDQoNCkJ1dCBJIGNhbm5vdCBmaW5k
IHRoYXQgc3RhdGVtZW50IHNvIHByb2JhYmx5IG15IG1lbW9yeSB3YXMgYmFkLiBUaGUNCmNsb3Nl
c3Qgb25lIGlzOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9pbnRlbC13aXJlZC1sYW4vWkpN
SDNERjduSitPRzlCSkB6aWVwZS5jYS8jdA0KDQpidXQgaXQganVzdCB0YWxrcyBhYm91dCBsYWNr
aW5nIG9mIFAyUCBpcyBhIHByb2JsZW0gc2ltaWxhciB0byB5b3UgcmVwbGllZCBiZWxvdzoNCg0K
PiANCj4gV2UndmUgYmVlbiBzYXlpbmcgZm9yIGEgd2hpbGUgdGhhdCBkZXZpY2VzIHNob3VsZCB0
cnkgaGFyZCB0bw0KPiBpbXBsZW1lbnQgUDJQIGJlY2F1c2UgaWYgdGhleSBkb24ndCB0aGVuIG11
bHRpIFZGSU8gVk1NJ3Mgd29uJ3Qgd29yaw0KPiBhbmQgcGVvcGxlIHdpbGwgYmUgdW5oYXBweS4u
DQoNCnllcyBidXQgd2UgaGF2ZSB0byBhZG1pdCB0aGF0IGV4aXN0aW5nIGRldmljZXMgbWF5IG5v
dCBtZWV0IHRoaXMgcmVxdWlyZW1lbnQuIPCfmIoNCg==

