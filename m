Return-Path: <kvm+bounces-33685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C702A9F02BF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 03:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF7B918817A7
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 02:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9396584A2B;
	Fri, 13 Dec 2024 02:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UiGpCUxH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0B5589B
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 02:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734057832; cv=fail; b=FZncyMH6VATkLy/Umc3aBltfFt/8XaFr2h6cfl6p2jKS7TUfmnn/XTA3+ulrNOw/IUgubijEuuBj0KRD5YkAVve3LzIRvzrgFC3pdWcnup8EPWgq75B5vO0yG/lbuyH5fxturf5L3A+h+48FVDc+ohNacFZ0e/5TgjFY/Aolzz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734057832; c=relaxed/simple;
	bh=TVm8+8tF8TEwl1DCm79ZD0HhJer93YeDkNhFZbMpg0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gMvGlEA4blD5xRVymeRsjUVl2+Nl3a4X7usbr7/YoLTuqZJhzA4clgKJDBBanASizscZvzbZTTc2AzBfhMqHJQ0TWZlTLtLOcSNpABlpLX3PiE6mOB13FBQOaklaDqQ8GkHeNPDM/F9UqFwvrQAJtyklqG0NE6BKeIuoD9gEiuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UiGpCUxH; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734057831; x=1765593831;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TVm8+8tF8TEwl1DCm79ZD0HhJer93YeDkNhFZbMpg0o=;
  b=UiGpCUxHHOZWdHpFkjSGE9Vg+7SuR2W7plxILLe0vgEEUZxQ7kLHYwoJ
   DlifOhBDL+s26V5BWaVgBWu/eQ9vZLbxWDHvUqq4xjW84UMsU+wPjGalv
   ecNkgT/endYX4TW52jx9p9svn7M9Ugb8xV3ei6bl0OIbke4sf3DAPKeHM
   JfioT+ulZigaITs2fapPx6jElR34PeIb0LGda7wcxAxNLlRofdn4eh3HP
   e9RAxWXOtXAs+2G2sivEC2KSi5ViiMy2EhBgfuYWUoB57ZM7aFb5LI3Y1
   v+2dNCIpk6IJSdD8pXPvrxnNwfEQgoSR/KbGsLIOLjQ0UBK3qEZt5PhYJ
   g==;
X-CSE-ConnectionGUID: +ffeWHyzTN6fip+oNFRySQ==
X-CSE-MsgGUID: iSnPsn0jTiq+Snz/TMk+mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="52028683"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="52028683"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 18:43:50 -0800
X-CSE-ConnectionGUID: KjevLhKLRo22jgI2jj6qLg==
X-CSE-MsgGUID: XPyQFOhBQA2qARKjBIBsgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101371867"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2024 18:43:49 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 12 Dec 2024 18:43:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 12 Dec 2024 18:43:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Dec 2024 18:43:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2U/+65FlJS0DonIVE74oIS8tGYLeCjAMEodreep4j3KSk0PlFCe2iFW5XSoEGa6hgzQj6sl/0/e7o86hGsfjloTChD5QKS5ttXaQ7qeumapdGeKBakKOLgzDVScF6i0fhyPwntRHue8/i0pqpa7AUV9Ukftziyq+cB4mdhjUmH6d4ClaKMcmQ2H9n1DjE3hV/FF1yjZDI/EfEI4te4xcwmHrlR6n8EV5Ew8Uw40N6U/tQSES/0rN8bg0QQRJ7BdBQeQJR8HdJnMx7f0bXPP3fSXGiKBJb7/xtxw5zcooKfBCj7N64OXim4nDYXJYkZ5YG/AGRzAloprvSvKuZ44XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVm8+8tF8TEwl1DCm79ZD0HhJer93YeDkNhFZbMpg0o=;
 b=t8JE2pUh2Xc9VEBVJHAfbhqsd/MpOjJ7ecOnoYQzydbPsHRwWgxTMvbl67M3XfnI2TNAPQUcUHwejLVkZ2ASsjspXXYI5kOBvlOD8pc3WVPZh+JAYZcKFWi1JZKx7iko0nj4L2LAYj7aeeXE2Z08SwAEvk5so6nDyJk7mN4k8hNab64oeDpjG3gZMzdrUEYsOZQAV6R3qIPaEiOcVglecXoEsWUa2LWZkhukhYg+jSiUPRe7l3TavfN9Sz7+jYzv/CdzRRnpyVnDNSAO3xh3AtZo+cn2pq5nm7Z2Cwb0As7k/ZSB0d+E6B7Mfca+P9RJE5Yhx6eArseQ+cmbmuAvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB8250.namprd11.prod.outlook.com (2603:10b6:510:1a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Fri, 13 Dec
 2024 02:43:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.008; Fri, 13 Dec 2024
 02:43:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Topic: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Index: AQHbLr0MyG3oX7KdYkCnpIbZw3bHE7LZC5CAgACnwQCAARp4AIADagUAgADOLICAAe0wYIABN4YAgAAqgnCAABfyAIABQn8A
Date: Fri, 13 Dec 2024 02:43:01 +0000
Message-ID: <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
In-Reply-To: <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB8250:EE_
x-ms-office365-filtering-correlation-id: 97eaef25-04f3-4d32-f56b-08dd1b1fdcca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RE1KWm42OE44WmVLMUV5M1VzcTZxVTVOQmgzazUvejQzQ0lLVEwwMTZIWXRw?=
 =?utf-8?B?eXNLTjk5bm5jcExSeHFIbjNldWRQUUZmdFUzOUtLUDNFR296VWJuRGVTdjJT?=
 =?utf-8?B?T1ZzbzBmcktJM3M0S3hUTDhwcVpCaXphTDJtUGl1cHFFOGpkY0JOWGEwNTU3?=
 =?utf-8?B?RCtnamxpUktUdnBkaXFQazNoTVlwamptVUY1aVhNL1NGSnZ3WTVOcURmbTBJ?=
 =?utf-8?B?dExRRXN5d2w2ZzRuWGhNdHd3Rkd0K3B0eDl1ZlJ1OTk1UlFQNHA5aTIyU24y?=
 =?utf-8?B?R2FQMTlxMnR0djRlUEJmQmZkTjYzRVNIU3dwT3V6RUxpcVZkQTBzWmZaaHh1?=
 =?utf-8?B?MmlhN3dEZVdxRVlqZ3NYY3RvVStBdXZjVGlPVGgrYkFGNGRlZ1ZDbkl5eGdZ?=
 =?utf-8?B?RWdvV292NWZaU3pSVDRrQklzMmRESllsMkEvZjFNazdMZVo4ZERrU1RFeFpn?=
 =?utf-8?B?UExSYXZRWXk5Nnc4OFhVV0pNaDUzcDFpd202bzdJL0tNbkd4SmlhNVZ6V3Jv?=
 =?utf-8?B?Vi9OeDhJQkxvdDZ3L3JlRHRhU1pHT3FXWWt6d1oxcVdKaFZJd3p4SGhUaVBF?=
 =?utf-8?B?UUdaVWpoSEJDUTJoamZVRE54VWFCaTF5ZVUwaHl6bXFPVjhIT0hNTDI1enVM?=
 =?utf-8?B?dk5aQlBjSmRPZEkvbGFkVzF5eFFIeVFiQkF1bXJKSGR1RitHYmVhSE9KNmwv?=
 =?utf-8?B?NW9MWm56QXdPTkdDTDJHanlmUUoyQU5KMjdjTThUWHVmcy9JNTg2eVd5RG0z?=
 =?utf-8?B?MUNCaGM3SGUvTVhFd09heUx5N3pMYWJXeDJjTmI4Kzl6c1lKY3VSejFRckd4?=
 =?utf-8?B?RERsa29jNEcweG5xYmVCemZjN2NBYXBPY0ZoajJheHBxend2K293NWFUYkhv?=
 =?utf-8?B?a09mMm5kN1F0dmxyc2NER2RJaHdWaklWQnhKcXBxM25WTzRUM0NPaHFaTGhZ?=
 =?utf-8?B?ck8xVk5wTlBEeStReE5hRUk4ejBaWFByQ1N2TkN4dFh2K2xHeFZNWm5kdzc4?=
 =?utf-8?B?V2YrMmJrNUtjRkxHZUxwNElLaEMrdmlKMzI4bGllUkRMa1A1YU56UmNmOW1Z?=
 =?utf-8?B?NGxsK2JIMG0vT1plejJCOGx4M2V6RFZUeE5OcDgyRU5PU1YvaEJoMHUzZlRt?=
 =?utf-8?B?bVlHdFkxTDFRbjNrZ3FTa09MVWVPWS9mR3l0dUppUEt2cG1vcDhTbEtKeGI1?=
 =?utf-8?B?eVdoTDIzSmhVaUQyUUlTUmRlbktXVVNCaFkvRG9rTU92NThBcGhqTFgvdEwr?=
 =?utf-8?B?Z00zdHlXbE1wTVUvRXZucXdEVmk0aDhOVFhiTEJVYkZkK05BcnQ4MXE1R2tH?=
 =?utf-8?B?QjQ1TFBoYlF6OWprOENVemFlc0xxY1JsTHZ3VjcwY1ZjeDFwbUJheXZmWFRI?=
 =?utf-8?B?elR6R3d4ZmNtM3R2cEVPRERycEtkSWwxTms4UkZzVjlpcE1mYzZ3R0pGRnM0?=
 =?utf-8?B?cC91NGE2YVB3MjBJUTNhVk5QaXNncGV6MS90ZmVuWVFHZ0dRYzdLbEliTjNo?=
 =?utf-8?B?UU1Cd0RUSnE0emlwUWdFWnIwbEMwT3BoUlVaTDhleFQ1NUlQbjgzK2NTdmVQ?=
 =?utf-8?B?bmh4QnlNOTJRMFNTaVZlQzJxblloZE5aVHBySTVWdzJLVnRETWFyRTJmc0Rs?=
 =?utf-8?B?OWVOMitLSFRFSHVZeS9lMitwYW5GSmtNL1FJcjVXeGhWbEN4cFJLZGwwYnQx?=
 =?utf-8?B?T09RdkY0dGFrU3lEYzlzVHR3N1gzMDM0NXNVejF2aFBVa3laeUF3a3JibTJG?=
 =?utf-8?B?dk03R2k1eUhHeXhwT05LOVhYaW9GcVVGWXZoQXVOWURrU0hMc2cwQ2lLZnY0?=
 =?utf-8?B?N0duYmVwKzRSMG1OcERodDZ4eWJadm9iUWdUcVl2YWd6eFdsdU4wNGxaMzlK?=
 =?utf-8?B?dkFlcFQ4eGJWdW01Qnc1bXJLMkJoTFhYaUdGUUlTa0M4OXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVJuaFQrMnpuRTJ5bVVhT09OVjBVa3lkdFRmVWtFMy91UE96bEI2bXJaSTR3?=
 =?utf-8?B?RytDV1lJQ1AvaHlIVXN5bmJhQWxyenQzK2FOY1FabDd3NG9vTWhkcWN1VHVN?=
 =?utf-8?B?UnNqZkg5VHJpYitLV25BOHkzYnViK0dIaVA3YmlWUW5pa21nZTZUZUVlWEV4?=
 =?utf-8?B?SFdGVjRrdXpLVk9WcDMzTWt4UDRTU05EaGFBSWRCa3c4OE0yeFhOaEVSSUJS?=
 =?utf-8?B?RXBIN2FIa1VIeTVMclVJM1FTZzZRRnA4TERtdThDUWJJLzVMOFlWY3VmTUg1?=
 =?utf-8?B?UWcycHRFbk5ZRHNQMU4zQWFudk4vdllqNkNRYVhYbk1KY3VnVEQyd0U2K25W?=
 =?utf-8?B?TWxHTFZsOW92aCsxeFAwZ09rWnBOWU9IbkQxeEF5czFxZFJkY2VCNXdyQndX?=
 =?utf-8?B?eFJJOEFOQlBmRENaOEhUSklKNWh5RTVyR0RiSTZwODF2NktDeE5aR3J5YTA3?=
 =?utf-8?B?SlhNVGNob3R5dmRxZFJqOVpXSGZ1OVBtQko1ZW4zV1B6aEV5VExtSkp1anM5?=
 =?utf-8?B?UFpuUVFjZEJEWVJvYzdTL3BseHJFQVdscmEyRUpna1d3eTM0TVN6SkhXNjk4?=
 =?utf-8?B?ZXJsV1NHLzBQdW9Ya0YwWS95SmRFZXlXRWNqRGVXZWVxR2N0Z3F3blEyazFr?=
 =?utf-8?B?Wk5nZEw0VDc4bnl6S3RMNlhMeDVMeDJnbHY5dzJKaDBXdm1xV252Qmk1RDJO?=
 =?utf-8?B?QVE1UlloUnlYYjA0TXRRZHhoRGg5T0poZE1vdy9Rcm9QOFpldUMwYjVLWS92?=
 =?utf-8?B?bGIvMTJkZVdRNmFRMzgrdWVhVU5NYTdCSCtNOUFlQW04cHljTUhIcXlVVlBv?=
 =?utf-8?B?NXFGNVJIYnNZSUUzQTdiZkJKUVdpcVUxWG1uVUUvMEVmclZydHNQYmJ0Zldr?=
 =?utf-8?B?WXZJbG0zQVV0d2tLeThYZEtDRUNyYUdQV1FrRXZ2VnZTSFF4bVVTek1mRjVD?=
 =?utf-8?B?dXZacVFFbHFzVUMvVE5jcFFEbER3Q1hnOXBiS1c0VlVhU1dtQ2V1YS9RVHJj?=
 =?utf-8?B?dHFsN2VBUW80S25sdVNLUWNwendIUmxZenBVTzFGTkxodFBXekZCZndHb0Vv?=
 =?utf-8?B?SnVxcVFnOXMyOWlINkVNblRGSUUrR3F2NmJldFd3SkJBdlpVM1BFeUFOL1NS?=
 =?utf-8?B?UEVHTGwxWlZvei9Da0J2cnJQa3Z0aERlN3lQYUI0SFF6QnB6dkFYU3JaVFMy?=
 =?utf-8?B?bUZhQkR2N1podWlaM1RvRytJaTBJa0cvQmEySGZ6R3dWbEtmV3ZJWUNJVnEr?=
 =?utf-8?B?NnNVOE53SGM1bFlYRXIxdVd3bEpnNnIzQWM0dW1PdThBRnBPNktZU2RPbU8x?=
 =?utf-8?B?TmU0NUFMTUl6UFA1bERxamQvZDc2RzFJd2o5Nng0Y3lwcHkyTllFVTVDa2JH?=
 =?utf-8?B?b0FlOGM1R1V3cDVCSktRaFpLQ2xLWHBmSHo0eWhoaWh0bHd0dFRzWmlEUGR4?=
 =?utf-8?B?d1cyT3E5RWwwSzhpa3hFUUFGUmNKUmw3c0pxVjhqR0hTTml5bGhwWm9TNFVT?=
 =?utf-8?B?RGlhcjJPcFNWWHhXZlhuYnhKRUhIdlBZZE15ajVqWXZ2Z2JTZktIaWVBeTI0?=
 =?utf-8?B?S1FrdWJXaFI1Wk56ZVpDSkJxYUkxdWlaWGxrcUk3STYwSUtVUEgwdVZJOU9E?=
 =?utf-8?B?b0lMVDA3ZUtyRlZNTzNqbjluR1dnc2w5VTlER2QrQ3Rkc0Q3ZVFWWGxzeUdE?=
 =?utf-8?B?VDZmM04rZ3F4SGRMUk9QaUpOYnNkby9sVmJ0WElNSDFKTkMwdERpNmpsUEpz?=
 =?utf-8?B?dXM5UnBvKzVJTFNPUTJmMmpOdkFnazlLZ1NkS3lxZEJYdVY5MGVqeFBJOUps?=
 =?utf-8?B?RUQ2Y2tTWGxuVzdtSzcvbnpTVzBTNlROTFZQeDh0Q0w4dnppVloyT1R4ZlRV?=
 =?utf-8?B?RHZma2lXbWwwd2VtQnZ4R0RDUGsrVGl3bFJUdGxBUUNjWG9ydzI0N1NsMS9q?=
 =?utf-8?B?U2RoU21pd2w4WGxRc0IwUHdZaE1ackJ3dEJKcG8yTEl2cXFwbnl3UndacnY2?=
 =?utf-8?B?YzdLZEpvQmY5NDV3UmdUeEZJVXk5ZUtaSFZ0VTJLQWo1MWh1RmVzeHliSEVp?=
 =?utf-8?B?RUlBRFFpaUxFZ2VGRDlnZ2psQVZ6cU54WFZnVkxwVHFycHBRNVhMK0s4a0I4?=
 =?utf-8?Q?XMS5BEW+zZAj0Iw4YjGlIGYur?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 97eaef25-04f3-4d32-f56b-08dd1b1fdcca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2024 02:43:01.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyPzoMIrT/f89LI5BhRl9BnU6tzmZZ7Ey8rudosr5SZRvTOJphc7snozVUpLL91lfeHoBPHLpz93rKypQZ9N/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8250
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IERlY2VtYmVyIDEyLCAyMDI0IDM6MTMgUE0NCj4gDQo+IE9uIDIwMjQvMTIvMTIgMTM6NTEsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT4NCj4gPj4gU2VudDogVGh1cnNkYXksIERlY2VtYmVyIDEyLCAyMDI0IDExOjE1IEFNDQo+ID4+
DQo+ID4+IFNvIG1heWJlIHdlIHNob3VsZCBub3Qgc3RpY2sgd2l0aCB0aGUgaW5pdGlhbCBwdXJw
b3NlIG9mIEFMTE9DX1BBU0lEIGZsYWcuDQo+ID4+IEl0IGFjdHVhbGx5IG1lYW5zIHNlbGVjdGlu
ZyBWMiBwYWdlIHRhYmxlLiBCdXQgdGhlIGRlZmluaXRpb24gb2YgaXQgYWxsb3dzDQo+ID4+IHVz
IHRvIGNvbnNpZGVyIHRoZSBuZXN0ZWQgZG9tYWlucyB0byBiZSBwYXNpZC1jb21wYXQgYXMgSW50
ZWwgYWxsb3dzIGl0Lg0KPiA+PiBBbmQsIGEgc2FuZSB1c2Vyc3BhY2UgcnVubmluZyBvbiBBUk0v
QU1EIHdpbGwgbmV2ZXIgYXR0YWNoIG5lc3RlZA0KPiA+PiBkb21haW4NCj4gPj4gdG8gUEFTSURz
LiBFdmVuIGl0IGRvZXMsIHRoZSBBUk0gU01NVSBhbmQgQU1EIGlvbW11IGRyaXZlciBjYW4gZmFp
bA0KPiBzdWNoDQo+ID4+IGF0dGVtcHRzLiBJbiB0aGlzIHdheSwgd2UgY2FuIGVuZm9yY2UgdGhl
IEFMTE9DX1BBU0lEIGZsYWcgZm9yIGFueQ0KPiBkb21haW5zDQo+ID4+IHVzZWQgYnkgUEFTSUQt
Y2FwYWJsZSBkZXZpY2VzIGluIGlvbW11ZmQuIFRoaXMgc3VpdHMgdGhlIGV4aXN0aW5nDQo+ID4+
IEFMTE9DX1BBU0lEIGRlZmluaXRpb24gYXMgd2VsbC4NCj4gPg0KPiA+IElzbid0IGl0IHdoYXQg
SSB3YXMgc3VnZ2VzdGluZz8gSU9NTVVGRCBqdXN0IGVuZm9yY2VzIHRoYXQgZmxhZyBtdXN0DQo+
ID4gYmUgc2V0IGlmIGEgZG9tYWluIHdpbGwgYmUgYXR0YWNoZWQgdG8gUEFTSUQsIGFuZCBkcml2
ZXJzIHdpbGwgZG8NCj4gPiBhZGRpdGlvbmFsIHJlc3RyaWN0aW9ucyBlLmcuIEFNRC9BUk0gYWxs
b3dzIHRoZSBmbGFnIG9ubHkgb24gcGFnaW5nDQo+ID4gZG9tYWluIHdoaWxlIFZULWQgYWxsb3dz
IGl0IGZvciBhbnkgdHlwZS4NCj4gDQo+IEEgc2xpZ2h0IGRpZmZlcmVuY2UuIDopIEkgdGhpbmsg
d2UgYWxzbyBuZWVkIHRvIGVuZm9yY2UgaXQgZm9yIHRoZQ0KPiBub24tUEFTSUQgcGF0aC4gSWYg
bm90LCB0aGUgUEFTSUQgcGF0aCBjYW5ub3Qgd29yayBhY2NvcmRpbmcgdG8gdGhlDQo+IEFMTE9D
X1BBU0lEIGRlZmluaXRpb24uIEJ1dCB3ZSBhcmUgb24gdGhlIHNhbWUgcGFnZSBhYm91dCB0aGUg
YWRkaXRpb25hbA0KPiByZXN0cmljdGlvbnMgaW4gQVJNL0FNRCBkcml2ZXJzIGFib3V0IHRoZSBu
ZXN0ZWQgZG9tYWluIHVzZWQgb24gUEFTSURzLg0KPiBUaGlzIGlzIHN1cHBvc2VkIHRvIGJlIGRv
bmUgaW4gYXR0YWNoIHBoYXNlIGluc3RlYWQgb2YgZG9tYWluIGFsbG9jYXRpb24NCj4gdGltZS4N
Cj4gDQoNCkhlcmUgaXMgbXkgZnVsbCBwaWN0dXJlOg0KDQpBdCBkb21haW4gYWxsb2NhdGlvbiB0
aGUgZHJpdmVyIHNob3VsZCBkZWNpZGUgd2hldGhlciB0aGUgc2V0dGluZyBvZg0KQUxMT0NfUEFT
SUQgaXMgY29tcGF0aWJsZSB0byB0aGUgZ2l2ZW4gZG9tYWluIHR5cGUuDQoNCklmIHBhZ2luZyBh
bmQgaW9tbXUgc3VwcG9ydHMgcGFzaWQgdGhlbiBBTExPQ19QQVNJRCBpcyBhbGxvd2VkLiBUaGlz
DQphcHBsaWVzIHRvIGFsbCBkcml2ZXJzLiBBTUQgZHJpdmVyIHdpbGwgZnVydGhlciBzZWxlY3Qg
VjEgdnMuIFYyIGFjY29yZGluZw0KdG8gdGhlIGZsYWcgYml0Lg0KDQpJZiBuZXN0aW5nLCBBTVIv
QVJNIGRyaXZlcnMgd2lsbCByZWplY3QgdGhlIGJpdCBhcyBhIENEL1BBU0lEIHRhYmxlDQpjYW5u
b3QgYmUgYXR0YWNoZWQgdG8gYSBQQVNJRC4gSW50ZWwgZHJpdmVyIGFsbG93cyBpdCBpZiBwYXNp
ZCBpcyBzdXBwb3J0ZWQNCmJ5IGlvbW11Lg0KDQpBdCBhdHRhY2ggcGhhc2UsIGEgZG9tYWluIHdp
dGggQUxMT0NfUEFTSUQgY2FuIGJlIGF0dGFjaGVkIHRvIFJJRA0Kb2YgYW55IGRldmljZSBubyBt
YXR0ZXIgdGhlIGRldmljZSBzdXBwb3J0cyBwYXNpZCBvciBub3QuIEJ1dCBhIGRvbWFpbg0KbXVz
dCBoYXZlIEFMTE9DX1BBU0lEIHNldCBmb3IgYXR0YWNoaW5nIHRvIGEgUEFTSUQgKGlmIHRoZSBk
ZXZpY2UgaGFzDQpub24temVybyBtYXhfcGFzaWRzKSwgZW5mb3JjZWQgYnkgaW9tbXVmZC4NCg0K
DQo=

