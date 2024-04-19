Return-Path: <kvm+bounces-15205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24ED08AA816
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 07:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69976B21C6E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99119C122;
	Fri, 19 Apr 2024 05:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DekZhr4D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DEB663
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 05:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713505927; cv=fail; b=C08WU4lC5XewNbwC0vb5yfcu/zvvE63zwf2cYDEYqPSGrGHCak8ZaxX81tAuohM8mwUWoDZ19RS9LSZWGerw/ZZ0c1I7/I65KVHrgq/3zWG2fAn8g0vbYfc0QjS17D890ieNxRfWRRjix+psCbNmkyQfmfzHPquxGhvSSYCXsTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713505927; c=relaxed/simple;
	bh=2hyCm2bXNL0IO5JaCgmHIwXfqjv4pjWGxRL1UH/zXns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DYMMSFRSA7W/b7M6cznzpIH1H7wet28pVZGRbs2a/V/nSl2Z7sUfsgwKnMQQjWZ+ot/B3urUG6L3hJOM3eMNy3YHiWzeHsCwDWKnGFd0cy3WoZAR2ZBYmTLwQ4m88UMUIOD1xRNvrTfaiHOI55558489YpyZzXzC3YPiId+kuwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DekZhr4D; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713505926; x=1745041926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2hyCm2bXNL0IO5JaCgmHIwXfqjv4pjWGxRL1UH/zXns=;
  b=DekZhr4Da84EhB/seBCwsZxpVREWwol3GCEchHuwJMZJjk3x9zBSZp5q
   MC3hGjMBIUQagyJfLpmfgZ04ANUNxe8g0eXpcPj9KZNL4aouVfPL6IFL3
   RjeHXvDZEvvuQw0SIAv8zsdWAqrJnBglJRohuPnLO+8mJG+MZYCKAQcS0
   BGRApLqo7TgWqu14ooVotxNcRqi0AH1iiXmzDAD1gpjObKeIf+dTu6V4O
   +6I+gviZCiz9AfFlKGVUQQ3EClMmDGY9kj6p54m6pPK0m2dmxH+LIhHwq
   kMsRYmKxXq/viQdBtMyLnbTC+WqL0tAjd+fXevgbXMnWEF3b6mRQHcU/4
   g==;
X-CSE-ConnectionGUID: G0VNfpJZR7KJ08VllWBFhQ==
X-CSE-MsgGUID: 1t9Ta0MPTs62w0R8BaQk7w==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="26603731"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="26603731"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 22:52:05 -0700
X-CSE-ConnectionGUID: X8MLnnkiTVKsUrUZ/1T3fg==
X-CSE-MsgGUID: Lfxq69XHTEulpEUQfvUMkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="27777142"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 22:52:05 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 22:52:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 22:52:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 22:52:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lC9meyVsjiCbnenap0sJ142nBjNId/GkDaX9MLZ95YoN03qUnggM5Wm+SnaAyVeWvWJlDSRCzfq5mGbXlz+qqUfV2WQR+nfdXr1JzKg2KkjVTSK1EAFOrLJgWEOXHjUx9IRtRBbnBDGZvJ5Cy4aHyAqc+uSlePfbZEJDA25X1GFutyCZNTuzzmX7pAC+HqKgXuwMofg5JE1+mF0f560+6SN0rsZrUuDmJwoKtLMLfAsFVq7UrPwNul23Vr9YTfulOxre57iTEJwCuntg+37Vk0w8yNfgWFKER+QMoEO/Q9B9Y8qFtmW+fmFJu1uhxQuy5UleqglgUcot5PkaD6rMtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hyCm2bXNL0IO5JaCgmHIwXfqjv4pjWGxRL1UH/zXns=;
 b=hfrxbpedjJKjkyirBzFq6XPISfnzQmzEmLM9znMZWXkCYM4WHrebq6DHymI91PzoirPfeOf8HhMYW6DmGD4od3GYOdmrgj1PwrWZPceFKrRiL+UkkulfYb05DHsiZDBClKtnwbGYvD4xKaK4sTcy2mlrh1UsAu5KY2sn52CLTDDjWPrBqzkAzo0G7QXRTNyOenzs099WvJODqLMNzJfQK4vBsKVqyI3WdqNdDyDxxn1XHmrsPd0m59BSdzci/IFB5SbypIpU3Tunn41Xo9WwWlGiEps863Jd2oOVt3lXQeoZ9fJfR1JgTJ/MvcJ0IHYT7BS4thn+mvLIsL9c66FjyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8362.namprd11.prod.outlook.com (2603:10b6:610:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12; Fri, 19 Apr
 2024 05:52:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.010; Fri, 19 Apr 2024
 05:52:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIA==
Date: Fri, 19 Apr 2024 05:52:01 +0000
Message-ID: <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240416175018.GJ3637727@nvidia.com>
	<BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417122051.GN3637727@nvidia.com>
	<20240417170216.1db4334a.alex.williamson@redhat.com>
	<BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
In-Reply-To: <20240418143747.28b36750.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8362:EE_
x-ms-office365-filtering-correlation-id: 2e485e34-a072-4909-19e9-08dc6034d5a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?STRodEo2TjRDYXdxaU1UODh4YXB3RGROaUVhaWJid3BURVY3MXFIMnJoT2F5?=
 =?utf-8?B?Q0NoUks3bEpSL1ZmN05ReWlKTHA3UU1VZnVyZmFQMGx1MXdQTE90cUtYR29u?=
 =?utf-8?B?MzB1Yk5IblJYVm8vQ3N5bHVMTmgxTDc0SFIxQ0JtK0I5bGt4ZmhDdWxSTU1q?=
 =?utf-8?B?dEtGbFFGKzRGNDhkRkpEZFg0NmRxWERydVlDc1BsWEd2ZVFuWldpeGRsNnVu?=
 =?utf-8?B?b24vL2FlWTg3dnN1ZDQvS1ZVTmNNdFdyQmRueXNGMFhLZnpuTHlzY0xRbXhI?=
 =?utf-8?B?TEJtd2lyWVZqRTF6RkVKRWUwdXBTTHNGeDl4RkNFeGhmamNRZWtpMmVUQVE2?=
 =?utf-8?B?OUEyeitYa0lZWlplQWZrZzZwMU9ONlc0NjZabnNMZE9iY25uVXUrQ3RsMHQy?=
 =?utf-8?B?dVVCZzQzcVBEY0hmN0dZbXNyOGoxMCtsUUFMSDFZVWc0bExQY0l5WFovWHR6?=
 =?utf-8?B?c2g1NWYvQ3lRRzBLdjk5bzdmUjI4bXh6UWJRVjVVdFpudlhEbGw0TW1UVS9w?=
 =?utf-8?B?bGlmZ3NrR3haQ2ZaWWE5MWxpTWVNU1l6V2dWMVhjNThRbEYyNUpudlhTQzQw?=
 =?utf-8?B?anNhY2Q5VFQ3REJsN2Z1R1BOQ014cWJ4bUNZcVBkWTdmNFBBbG9LeDJERXVC?=
 =?utf-8?B?U1M0c3k2ZHRPWDNFME9QK0lnUU1ySDJmTTdteTdhb0JnR1pGc0RFWTdtRUZS?=
 =?utf-8?B?dktNdEFFQ2lCU0NXR3hIOTZabWlndmZvWDZ1dHNoRGxhYkFmeDJlMEw5U21I?=
 =?utf-8?B?MldNaFAxRjdXS201RnpIdEhwYi9yaWhyVjZCbXg0Vlp4SUdyRCtKR0Nwdm85?=
 =?utf-8?B?S2tQZ3hHam5GZzBnU1AxeExrM1NBS2xyTUx4dm9EVk04RHJkeW5tQXFsL1ZW?=
 =?utf-8?B?Vm5UdWloalNwZExEanlCckROTGlRUGhaaWJEZ011QVhTNWtYTk1pVXIxaXdC?=
 =?utf-8?B?QVpBQUo2TnM3S1lhL1VmOSt6WS9pRmVPOWY3YnIxcDcwOFo0ak5iTkJReGZY?=
 =?utf-8?B?RmMreUp3ZHZULzlkRE5RL2RTbEVHV0Q5L2ZYMHB2Q3h4d3VsanA0WVRnNEVj?=
 =?utf-8?B?TGh6c2IwTFNmOVczWkU5WTZOYW50NXJ1OGhEL2VaQlE2ejltbzF6Z2M4dDgw?=
 =?utf-8?B?bFN0ODlnbysrN3RjcEw3dU9ZbmI0aVJYcitGUW5CWmVLQUczWXRPeGRUdkFW?=
 =?utf-8?B?QzgxeVFxYks0RTVyVGxUd1NPVXRwNGFWTmkyV1lQQU9pK0ZxVmtOZFc1MVF0?=
 =?utf-8?B?Ty9LVEJXOE1nQzhRSFl6N1dycWRKbWNxOWNQcmkyL1EwNmtHY1Nzd0YxT1Ru?=
 =?utf-8?B?QmJBRnNZOFpYSlpjbFBNazloUzhod0NsU0M3QXphWFNrS0RLZFlBdEZpUmZI?=
 =?utf-8?B?d0dUb3dneEFCbkthTmpPWklMSnVNam9HMFlQRUp3aUMvaTdNRFFFVGlVSWFx?=
 =?utf-8?B?amVZYnVoZVVldy85MHdVWGJqU1B3TUFFaWgzYjNlMmZTSnpDZ0cyT0t4YkZD?=
 =?utf-8?B?M2h4V0x2Qk5JRFk3a3ljWTNiMlF1cVhSMDJkdy9raXVKbkRpbjg1aGhQcDhJ?=
 =?utf-8?B?bGlRaCtvWEpzckxGeHoyeU15cVV6SmRUUkhBMUJJSTFHaXNRbzRwUUFJYlJZ?=
 =?utf-8?B?U0JjcWtzMWxBa0ZtQjVYWXJENndpL1FlQ0RyenhrV2RVNS9OZXpTZGRub2Ju?=
 =?utf-8?B?cXgySm00dzRoOE1yNzRqOHYyVjlodkxNekpsTmxsOS9CbUFkZCtBWEZ3QlRp?=
 =?utf-8?B?MXJYTXNnNWh2Y0dDQ0VrZVhNNmMvdzJDU09Kd2x2OEh2bWdzT2ZXLzNIWlQ2?=
 =?utf-8?B?OGJxQ2pMcHBSNEVyTUpTdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWd0VHAxWFRjcjNJQzgyNHc0UkxmMHU2cVNWQ3FBbGxoUzh1M3RSTjZDaGMw?=
 =?utf-8?B?b1BrY0R0Q0xGYUJwTUkwakRxRGJEM05OWHU0dEIzbEN3Y1pId0lndU5vRjg4?=
 =?utf-8?B?b0lXeVpVaGhwc2ZqejV4Z1RFVGxZSmtJMXhxczI1K00reEZienZSeFMydlpQ?=
 =?utf-8?B?cWhtdG9SMFI4UkVIaUdIY2x4UUxvL1FTYWxWSXJjTmY1QytmT09vSnR6RzdU?=
 =?utf-8?B?WU1sVzlGWUhkR09tR1lBMzJrVUtaQi9qMUYyTFRTWjdQOS9WcWdDdm1JNEFt?=
 =?utf-8?B?aXJ1akhIb0ZBVGtqeDQ4a0g1QXhsVDRsc1c4VVdWMG51QVhBVWJKNjRqY3Ez?=
 =?utf-8?B?UUcyUnhiS0xQTEZCazBaZlpaSWRvR2xZckF3cHM5QmJQS0kxY0tMU2JYZkxl?=
 =?utf-8?B?Z01MYnI1TlRrWWxmNFk3TDFBcjNLQVdKcUpmNVlVM2l5dkMvZVdINHJ2NXZY?=
 =?utf-8?B?MitoQjMyYjR5TTJuNTJHdU1rK0VyUGVvY20rNWlBcDdoTFhQcUd3TitLZTBa?=
 =?utf-8?B?Uml4NjI3TlNPanphdWMxQitnTWJVQ2M1UnpUY2NCTHA0azg3M2s0WW9jVEY5?=
 =?utf-8?B?cU1ZL0sxYUJwZjNkMDRsYkNMenZ1dEFLclU1TFJ4elA0TU4xc1lRc29ZaENo?=
 =?utf-8?B?SEljR2tkdThHOU9oUjMxejNyUkpMSFBBN0ZzQVNWWU1ZYW5wUVZRRnhBTDZM?=
 =?utf-8?B?azgwell0UWFGOGk5ZzdQME1vMGgxWDVxQU1oQ0hmZk5DeXpjblE4ak9yKytZ?=
 =?utf-8?B?enM1UlVQcGJmZTBQUUljWmZMbE1Ja2IrTzYrR05PaW82ME51WHlyRHA2NGpU?=
 =?utf-8?B?Rmh0V0k0V3BHTERKbk5UQWNNME43Si9KeEViZDNGOGtGRXJpU1NhazJRS21O?=
 =?utf-8?B?V080bUwzNkV4RzB4Z2JXelhnSHNLd2JLUVpKM2Z1RFZ0Z0Eydm5ZbENNQ2ph?=
 =?utf-8?B?SmZYbUg2VTRxQ1ZsOUx1TE1ySlNybXEzM01MSWNWTFRVM1RUdnZvZEI4UVJW?=
 =?utf-8?B?OUlETmRiMFJHSndkMHpDSmpqNytocEtPN0s1d2N1djlBWjNrUTdZZW9GSmdp?=
 =?utf-8?B?WTllY21JSWJwd2hxekpnRFlrcmpuRDl4d1FjNzRFVWpnMzVMNVNHUGI4MDVJ?=
 =?utf-8?B?V05zd3BuUHVtSXVCeExucDlXNDVwdFBWbHJHUUJRVXN2ckp2L3FTeXNHK3hj?=
 =?utf-8?B?M01RTEc0NVozUlhTc1c5WlVjSk5tL2oyQTA0V2ovMVZBUHpRZWZiMmg1OTVx?=
 =?utf-8?B?UGd6Z3FkdkRUUGhuRzVXT1F6NGFxeHJhSC9HWmxMU09OeFNWR09iSmV4NE9p?=
 =?utf-8?B?WHFUaW9SSUQ0c056NmNjcWpMQXplV1BYVlpNRGlmTHdQU3VSNEdBNkhsVE1t?=
 =?utf-8?B?SU00UDhmL2NNTFlxNkpFdTB6Z1RoWm9Na1cvQTZLSUNyeUFVdnd6TmsvQy9K?=
 =?utf-8?B?Q3JMT29RVGxoZ2ZkVFUwL214bGd4L0JTckMzaFZiRlFxTWRjekFrZGp1SHBL?=
 =?utf-8?B?Zkl3eVRVNjF4UllVb2VNSm1URWpOeWdjTTNqSDFYQnFVemZGNlkzVmRKQUlu?=
 =?utf-8?B?Z3E1dlV2cDFXR3NVTjYxSCtSOVptak4vVm90SHBBUVcvcDZaSHVCeHYxQTdz?=
 =?utf-8?B?Y1ord045ZjY3SC91RXhTeE5nRmJPWVpKYVR5MnhqRERpRlNKR29SOTRmT0pW?=
 =?utf-8?B?L0xGVkJZU1NhYjBIdUZMZjFPaTlsbTNnaHpDSXlJR0JCaWdPMG9VdGE3N2N0?=
 =?utf-8?B?M2Y0Zmp5TktqRS9IaURoTDZQamdjcjFUZGdKNmR4OHZLOVFIL1F1eFdpSHYy?=
 =?utf-8?B?Z0FGWmRncnJVTUFpNVNLaERYRTBSZFQ3cWNQMUVBRGJCK3lsV0VXTno3bndK?=
 =?utf-8?B?QWttbVhOOGU0SG5pQ0RRa0NhVXYwREswaWVJSTRCODRWOHlvQ1hteW1WR1U2?=
 =?utf-8?B?ZVEyYzdtZ281R0o3YzZRbElZamRIQ0JSckltYTUvSDZCbDA5UTFFdmhvcHFE?=
 =?utf-8?B?dlRFdEtiRGVmMzR5ZitwMnNJRnFHaGdBQmhpR1oxZEF2Mm0rMHRxcWY3MTJI?=
 =?utf-8?B?dGQxNll2Ky9LV0hhRzZ1T0svOWVXMUYzelNlR0hyZjRTUGVJenNTNUJNU21j?=
 =?utf-8?Q?+qDGv2XY3L7L9UIjuiNQZJvVQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e485e34-a072-4909-19e9-08dc6034d5a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2024 05:52:01.8618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G088anH+msWj6P9qwqxCyiiKxQpXCEO1Ldhqnjg4sMxnn/KCnVP7/e1yEN/RLa90eDvM7coPhSc/uYHgyCh5Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8362
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBGcmlkYXksIEFwcmlsIDE5LCAyMDI0IDQ6MzggQU0NCj4gDQo+IE9uIFRodSwgMTggQXBy
IDIwMjQgMTc6MDM6MTUgKzA4MDANCj4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3Rl
Og0KPiANCj4gPiBPbiAyMDI0LzQvMTggMDg6MDYsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4+
IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4g
Pj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDE4LCAyMDI0IDc6MDIgQU0NCj4gPiA+Pg0KPiA+ID4+
IEJ1dCB3ZSBkb24ndCBhY3R1YWxseSBleHBvc2UgdGhlIFBBU0lEIGNhcGFiaWxpdHkgb24gdGhl
IFBGIGFuZCBhcw0KPiA+ID4+IGFyZ3VlZCBpbiBwYXRoIDQvIHdlIGNhbid0IGJlY2F1c2UgaXQg
d291bGQgYnJlYWsgZXhpc3RpbmcgdXNlcnNwYWNlLg0KPiA+ID4gPiBDb21lIGJhY2sgdG8gdGhp
cyBzdGF0ZW1lbnQuDQo+ID4gPg0KPiA+ID4gRG9lcyAnYnJlYWsnIG1lYW5zIHRoYXQgbGVnYWN5
IFFlbXUgd2lsbCBjcmFzaCBkdWUgdG8gYSBndWVzdCB3cml0ZQ0KPiA+ID4gdG8gdGhlIHJlYWQt
b25seSBQQVNJRCBjYXBhYmlsaXR5LCBvciBqdXN0IGEgY29uY2VwdHVhbGx5IGZ1bmN0aW9uYWwN
Cj4gPiA+IGJyZWFrIGkuZS4gbm9uLWZhaXRoZnVsIGVtdWxhdGlvbiBkdWUgdG8gd3JpdGVzIGJl
aW5nIGRyb3BwZWQ/DQo+IA0KPiBJIGV4cGVjdCBtb3JlIHRoZSBsYXR0ZXIuDQo+IA0KPiA+ID4g
SWYgdGhlIGxhdHRlciBpdCdzIHByb2JhYmx5IG5vdCBhIGJhZCBpZGVhIHRvIGFsbG93IGV4cG9z
aW5nIHRoZSBQQVNJRA0KPiA+ID4gY2FwYWJpbGl0eSBvbiB0aGUgUEYgYXMgYSBzYW5lIGd1ZXN0
IHNob3VsZG4ndCBlbmFibGUgdGhlIFBBU0lEDQo+ID4gPiBjYXBhYmlsaXR5IHcvbyBzZWVpbmcg
dklPTU1VIHN1cHBvcnRpbmcgUEFTSUQuIEFuZCB0aGVyZSBpcyBubw0KPiA+ID4gc3RhdHVzIGJp
dCBkZWZpbmVkIGluIHRoZSBQQVNJRCBjYXBhYmlsaXR5IHRvIGNoZWNrIGJhY2sgc28gZXZlbg0K
PiA+ID4gaWYgYW4gaW5zYW5lIGd1ZXN0IHdhbnRzIHRvIGJsaW5kbHkgZW5hYmxlIFBBU0lEIGl0
IHdpbGwgbmF0dXJhbGx5DQo+ID4gPiB3cml0ZSBhbmQgZG9uZS4gVGhlIG9ubHkgbmljaGUgY2Fz
ZSBpcyB0aGF0IHRoZSBlbmFibGUgYml0cyBhcmUNCj4gPiA+IGRlZmluZWQgYXMgUlcgc28gaWRl
YWxseSByZWFkaW5nIGJhY2sgdGhvc2UgYml0cyBzaG91bGQgZ2V0IHRoZQ0KPiA+ID4gbGF0ZXN0
IHdyaXR0ZW4gdmFsdWUuIEJ1dCBwcm9iYWJseSB0aGlzIGNhbiBiZSB0b2xlcmF0ZWQ/DQo+IA0K
PiBTb21lIGRlZ3JlZSBvZiBpbmNvbnNpc3RlbmN5IGlzIGxpa2VseSB0b2xlcmF0ZWQsIHRoZSBn
dWVzdCBpcyB1bmxpa2VseQ0KPiB0byBjaGVjayB0aGF0IGEgUlcgYml0IHdhcyBzZXQgb3IgY2xl
YXJlZC4gIEhvdyB3b3VsZCB3ZSB2aXJ0dWFsaXplIHRoZQ0KPiBjb250cm9sIHJlZ2lzdGVycyBm
b3IgYSBWRiBhbmQgYXJlIHRoZXkgc2ltaWxhcmx5IHZpcnR1YWxpemVkIGZvciBhIFBGDQo+IG9y
IHdvdWxkIHdlIGFsbG93IHRoZSBndWVzdCB0byBtYW5pcHVsYXRlIHRoZSBwaHlzaWNhbCBQQVNJ
RCBjb250cm9sDQo+IHJlZ2lzdGVycz8NCg0KaXQncyBzaGFyZWQgc28gdGhlIGd1ZXN0IHNob3Vs
ZG4ndCBiZSBhbGxvd2VkIHRvIHRvdWNoIHRoZSBwaHlzaWNhbA0KcmVnaXN0ZXIuDQoNCkV2ZW4g
Zm9yIFBGIHRoaXMgaXMgdmlydHVhbGl6ZWQgYXMgdGhlIHBoeXNpY2FsIGNvbnRyb2wgaXMgdG9n
Z2xlZCBieQ0KdGhlIGlvbW11IGRyaXZlciB0b2RheS4gV2UgZGlzY3Vzc2VkIGJlZm9yZSB3aGV0
aGVyIHRoZXJlIGlzIGENCnZhbHVlIG1vdmluZyB0aGUgY29udHJvbCB0byBkZXZpY2UgZHJpdmVy
IGJ1dCB0aGUgY29uY2x1c2lvbiBpcyBuby4NCg0KPiANCj4gPiA0KSBVc2Vyc3BhY2UgYXNzZW1i
bGVzIGEgcGFzaWQgY2FwIGFuZCBpbnNlcnRzIGl0IHRvIHRoZSB2Y29uZmlnIHNwYWNlLg0KPiA+
DQo+ID4gRm9yIFBGLCBzdGVwIDEpIGlzIGVub3VnaC4gRm9yIFZGLCBpdCBuZWVkcyB0byBnbyB0
aHJvdWdoIGFsbCB0aGUgNCBzdGVwcy4NCj4gPiBUaGlzIGlzIGEgYml0IGRpZmZlcmVudCBmcm9t
IHdoYXQgd2UgcGxhbm5lZCBhdCB0aGUgYmVnaW5uaW5nLiBCdXQgc291bmRzDQo+ID4gZG9hYmxl
IGlmIHdlIHdhbnQgdG8gcHVyc3VlIHRoZSBzdGFnaW5nIGRpcmVjdGlvbi4NCj4gDQo+IFNlZW1z
IGxpa2UgaWYgd2UgZGVjaWRlIHRoYXQgd2UgY2FuIGp1c3QgZXhwb3NlIHRoZSBQQVNJRCBjYXBh
YmlsaXR5DQo+IGZvciBhIFBGIHRoZW4gd2Ugc2hvdWxkIGp1c3QgaGF2ZSBhbnkgVkYgdmFyaWFu
dCBkcml2ZXJzIGFsc28gaW1wbGVtZW50DQo+IGEgdmlydHVhbCBQQVNJRCBjYXBhYmlsaXR5LiAg
SW4gdGhpcyBjYXNlIERWU0VDIHdvdWxkIG9ubHkgYmUgdXNlZCB0bw0KDQpJJ20gbGVhbmluZyB0
b3dhcmQgdGhpcyBkaXJlY3Rpb24gbm93Lg0KDQo+IHByb3ZpZGUgaW5mb3JtYXRpb24gZm9yIGEg
cHVyZWx5IHVzZXJzcGFjZSBlbXVsYXRpb24gb2YgUEFTSUQgKGluIHdoaWNoDQo+IGNhc2UgaXQg
YWxzbyB3b3VsZG4ndCBuZWNlc3NhcmlseSBuZWVkIHRoZSB2ZmlvIGZlYXR1cmUgYmVjYXVzZSBp
dA0KPiBtaWdodCBpbXBsaWNpdGx5IGtub3cgdGhlIFBBU0lEIGNhcGFiaWxpdGllcyBvZiB0aGUg
ZGV2aWNlKS4gIFRoYW5rcywNCj4gDQoNCnRoYXQncyBhIGdvb2QgcG9pbnQuIFRoZW4gbm8gbmV3
IGNvbnRyYWN0IGlzIHJlcXVpcmVkLg0KDQphbmQgYWxsb3dpbmcgdmFyaWFudCBkcml2ZXIgdG8g
aW1wbGVtZW50IGEgdmlydHVhbCBQQVNJRCBjYXBhYmlsaXR5DQpzZWVtcyBhbHNvIG1ha2UgYSBy
b29tIGZvciBtYWtpbmcgYSBzaGFyZWQgdmFyaWFudCBkcml2ZXIgdG8gaG9zdA0KYSB0YWJsZSBv
ZiB2aXJ0dWFsIGNhcGFiaWxpdGllcyAoYm90aCBvZmZzZXQgYW5kIGNvbnRlbnQpIGZvciBWRnMs
IGp1c3QNCmFzIGRpc2N1c3NlZCBpbiBwYXRjaDQgaGF2aW5nIGEgc2hhcmVkIGRyaXZlciB0byBo
b3N0IGEgdGFibGUgZm9yIERWU0VDPw0KDQpBbG9uZyB0aGlzIHJvdXRlIHByb2JhYmx5IG1vc3Qg
dmVuZG9ycyB3aWxsIGp1c3QgZXh0ZW5kIHRoZSB0YWJsZSBpbg0KdGhlIHNoYXJlZCBkcml2ZXIs
IGxlYWRpbmcgdG8gZGVjcmVhc2VkIHZhbHVlIG9uIERWU0VDIGFuZCBxdWVzdGlvbg0Kb24gaXRz
IG5lY2Vzc2l0eS4uLg0KDQp0aGVuIGl0J3MgYmFjayB0byB0aGUgcXVpcmstaW4ta2VybmVsIGFw
cHJvYWNoLi4uIGJ1dCBpZiBzaW1wbGUgZW5vdWdoDQpwcm9iYWJseSBub3QgYSBiYWQgaWRlYSB0
byBwdXJzdWU/IPCfmIoNCg==

