Return-Path: <kvm+bounces-33215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D969E75A8
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC05F166D89
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697B0215F4A;
	Fri,  6 Dec 2024 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cTHagNZQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3137F20FA99;
	Fri,  6 Dec 2024 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733501643; cv=fail; b=RKUQ0PDJKsRejnxrdqvxAj3eZoD0DsJbE5pJ4KAczKkryPmzW0sJBegR4PAAHYRNFe33n4+JMIRlQ4T6AsBcqoIqfWJcrBxw+FkqMvtWOdD/UfD0X1qS+Aq5KajWBiHE5/MSJuhVqKttUT2vs3fxzzx0Atqq799ylyvRfWGJhkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733501643; c=relaxed/simple;
	bh=z0Gj7AUvX9JILsxnQKY9J4EG9DHVeCEMrxQcGKdJ+k0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Byf89mQPGY68U2tPPH87EG+gcMMMnsYJm+fJROLrmlPasrf4Zkyk8q1WjDZF4Z89i0uLQnBOaxXawcs40us9uZdDrToDw5Q9quZAy0TD3yvbOFmP9unMN7VrlQGI2XhqHwbTXbkxvHv8gVDtcIRmRgWpjdWvIPXRROplHsnrUSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cTHagNZQ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733501641; x=1765037641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z0Gj7AUvX9JILsxnQKY9J4EG9DHVeCEMrxQcGKdJ+k0=;
  b=cTHagNZQrx7yARX/TAbIQSB/6g52CvRkMUfPCRya5m2ElYeo7SYMvxee
   ZTYl3KHvq9dBOMYWdz6dTC/wwyiaftIeSxjF20b3vqkkeadNZJcLM003q
   Gsfz5AWXQ100LY/HZHbR0q7g07gWifRG2zLLWVLwiFxiwdZcfRrHF7Uwa
   Yvd4smlJzB0ie1fD7Wn+PAzGbJeu3WPZyZU5AekGWWNdS+9Z6T7AGA7F3
   gFOXrcpYcB18ZlKAIjv9kjqTUzGWC1idkpXAW6Cp3JyRDfWQt73y1o+e6
   CZYfkZgluibCRDP3FOYrqFxO/1Lbo8AzQtfWwNN0bwrBlrNKE/zyLq1c8
   A==;
X-CSE-ConnectionGUID: FGy/1+C8SKeKAtwmNWcJkg==
X-CSE-MsgGUID: z4JQ9G13QUK8QUdxPCT9GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44882225"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44882225"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:14:00 -0800
X-CSE-ConnectionGUID: EB0dtHMvTbaPrx6YIP5dZQ==
X-CSE-MsgGUID: xanU6jzbSnys4dXIkfA3sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="94805944"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2024 08:14:00 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Dec 2024 08:13:59 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Dec 2024 08:13:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 08:13:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLOGgWxtsj1++lgnCjRWjZQHF4S1aEk7W/Pj2t/RRe3uhEahsWi2Y3jMFVJxMI20tHtjugmU1xSan8bQLS4FhXLTP2dthwtz9ak2ZBymXTBIwoMvcLtyhcy/9bgZwAbdrsOL6EJUgkODj8xummBZbFdzUVBQxLPcDzSLOcegInYeiZGW2wI97YrKOiMEzsudKiKZzHs/UzdE6BM9FaYuRiLTF+tSaETqqLm6e5smCdo9KuJ7T+FlR8BZZkz1EIuLwOMnIupBdhxU853SZJz/0Sm1WrIxy8lN9lrfWlkbfyI1Ji6u5nhv+1MRZTMHviMwoqK7z2BhU33eo58CXWffSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0Gj7AUvX9JILsxnQKY9J4EG9DHVeCEMrxQcGKdJ+k0=;
 b=Hg6O5sW/4VICji+Kx8a3tRklLOfdNUF9gYz/7sm2UqmPL8b5enjcvVu5aYemyxJtrnnOJKwRJOYbZY2L7yoIA5meiIPxgzuFuvqq7SoZrhVu9+dOyFz48R7NNM010hpwByysQgYfUKhntjRvmGduMrKxZ7vIrWpoDnCe1GmdgIyf0LUQu/CFTj1eYcFK3c+nJTuQFdVh5UrAqXdP7taC0l/A32VCpV7BBxu+MEeFGy04IlTmdAzazM26+X/guvGgQJdkMNccKg+xSc8bHYQD88d3kwFNvNkhrr+8fzSUECQAEsmkKEIqlivcMYP5WmX7nIJSLxFaXTTYr9zLbW30Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6840.namprd11.prod.outlook.com (2603:10b6:303:222::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 16:13:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8207.017; Fri, 6 Dec 2024
 16:13:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for
 KVM
Thread-Topic: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata
 for KVM
Thread-Index: AQHbKv4/vFuDP1VR6k6F9GWSzEVqNbLZHhwAgAB/agA=
Date: Fri, 6 Dec 2024 16:13:48 +0000
Message-ID: <47f2547406893baaaca7de5cd84955424940b32b.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-4-rick.p.edgecombe@intel.com>
	 <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
In-Reply-To: <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6840:EE_
x-ms-office365-filtering-correlation-id: 52041d3f-8655-45e1-f8a1-08dd1610f74b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RDUzU0t5cXA0TXJTdnMrWE05TG5lTGF3WG1jRnk0dzNBc3dkYkRtaFpuMDdt?=
 =?utf-8?B?NER3bjZPQ1pscGlKb052WEFlWk5GaGdYeUNYWTRRTnRFWTU2M2JwM3FVN2Rj?=
 =?utf-8?B?bHVpQzZad0QyUEJLdVVMbnNydmxtWEl2OEVackR5NzNqRkhGNGI3ZUlhbXR4?=
 =?utf-8?B?Q1NsWnNrNWdXNTFYRWMvNEppRFd4WHZqOWZRZ2tqVlpleUdJNFF6bTJaOFZ5?=
 =?utf-8?B?RmNnZW52R096UTJRYVFVVnJrOE41eWhNMEYvVzJEeHFHOUk1WDZ6cmV1TEpL?=
 =?utf-8?B?NG41OGNZL3prK0lQcjJXTlRNM1BtNVh2eDlLd2RRbmFScmMvWVBrbFI0TVJE?=
 =?utf-8?B?MFBmbUNIWGh1bzJVcVdiVWwwMkhpRm9CcmNoeTNGMTVTK1FNWjdGSFNDMUlD?=
 =?utf-8?B?eVc3eGdRSFdXMzBtM2tNZFZzSXF5ZDY5Q3NkQ3FtMTVkcmxNU3J4RG9aUFc0?=
 =?utf-8?B?OFpzM3VhSWcyK1FhTUxlWVo5VzFXNnFzV0JQd21wd0ZEbmUxM1dXR2Z0ZmND?=
 =?utf-8?B?NERBZWZhR3kxaFVHK3FLeFhzNktjeGVHNVF4YUd2ZjFyM05GNmJDNUVVWGtS?=
 =?utf-8?B?Tit1TjJTOVZteVJtT1M2SlFHTjdLNFBkc3JKOU5ZS0VtZktHOEFIT1ljcE1M?=
 =?utf-8?B?dzloOW9QSEtoMjFPUE1aTXFXTDRjaEdqcENwTjNhYkNGQSt0Q3BHWWFPRUJq?=
 =?utf-8?B?YTJJa2lLZjdmd0FzSGJxZEI5MndZRW1uS2NmSzJXWkYwMTkxeXl0T0RuNVFv?=
 =?utf-8?B?SHhOV1lUN0xuNkpXR1VZZHY1UjV3dlBTL1FVQ3EyTG0zMmE0UXlqckR6UWh1?=
 =?utf-8?B?WEozUEd5OWMvaHRQU3JXbU1IQVRoUktWL3QyNDZjdEszMXNKNE1yOWsrcU1o?=
 =?utf-8?B?MStiL05tV0doWmdTN01XTW4yRmsvOFNwMi9vSGlFb0dGTkx4RW9UWnF5RklW?=
 =?utf-8?B?dEc0dUk2VzNXb09OK2xOTWk3Y3o4VXA3RHJsS3RRaW45OHFMaFNOUDUybzVr?=
 =?utf-8?B?OHErNlRhMGU1dmQ4YTF0eE5kYmdsMHV5V0VIU1NwekFJUFRUMGE2eGtKeUNU?=
 =?utf-8?B?R2xoTkJXdlRpM3pKUDNvT3ZDRHdQUFpnQ3F5OVY3WEtXZld4RnFZcUJzWjZD?=
 =?utf-8?B?UnBUSm91OVRiUnh3UjZ1S1ZGMUUrdlJuVUxtVHA5T0J5QnZ5RDRYVEdYelJT?=
 =?utf-8?B?STQ1V3ZpRFQ4d1RqVnpCaEJpZWluKzl6Q21keEoyUzkvbExUbE8wZ0YrWExs?=
 =?utf-8?B?WGtGK2RZTzliOFJEN1A4VjFLdHgzcEZKQ0FOUEJ2dHhRQXJNN2pWWWtJVktE?=
 =?utf-8?B?dUZxRmNMQVVaemRzakhvUTd5eitDV2l1ZFJSdWxGczFqRGVKREZobEhjM0VH?=
 =?utf-8?B?SC9wTndEVnUzVCtnTE9SM0t4THNuZWFnaVdFNGNUZ21FKzhydWtzWEJPWTk2?=
 =?utf-8?B?UnFweUV4ZElyOG5NRU44VnZwWWt4SmxWMnVwY3pkWThWZXhpSUREKzNBR2ZT?=
 =?utf-8?B?aXNnaGFJTjRQOEJlWVNrN042THREZE5vYVNQMWNEb3gzVTRMMWh4ZGtnbExS?=
 =?utf-8?B?SnBnQ015YlNCbzBkZmdWdFpXb1NET1VmbTVJQ1Fqb3ZpVllIUzFEM0dmNGFi?=
 =?utf-8?B?TzUzekZydEV1TEZRbi9ieklhOXlYQU9pMzU4ekJkUTlXcGxiVGhaeGhIeXMr?=
 =?utf-8?B?WklHTURhOWgrd09Bc09hMmpGV2F0VDRrcEFzRkUyNUYySFlSTVhpc1ZmMnA5?=
 =?utf-8?B?d1FGeENWL05PcGtnTksrZVl2bTJScEtBdmQrMTMvSUVFN3FYQ1FkVDVMK0U1?=
 =?utf-8?B?Qks5Z0RDTzRNenlMMnZseXBocEhkREpsQ2w2REVWMWhYbytob0VISi9HZnNC?=
 =?utf-8?B?WEdhS2tlL0p6RlYxWHpKUHMrQklxM3RwRDBjOStvcGR2eVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWpWcFgyb0JwTUxmNkRGL0tKV0UrT3N5MEplRTZPaWZlSXpQYTNhRkZoZlhI?=
 =?utf-8?B?UEtlVjRxZ1JyVlZZNmNiMStZcytBRGFkMXFkNVBESC9qdUN5QnN0dHo4UEUz?=
 =?utf-8?B?Q1VaUlJxK2tlWkRDVTNJNjRUZjRkWjdOeGM1dEZZZ3JqYjV3SnlVenRWRzJx?=
 =?utf-8?B?a3JTdi9zcWZBMnBHNDNTckdNRjg3ZUM4SGRzWDJ3Q0E3azdYN0NtdGlFTGxv?=
 =?utf-8?B?dk9SUlRudmdsQnZHcnVyMFlja2JBdTBiQ2FUSWRBOVNSd2daTkw0akJtdFJI?=
 =?utf-8?B?YitaS3YzdjlMK21zL1RhVzNTWE0wejdLUkx0Q0VWa01FTkN6aG5TdG1mSXBt?=
 =?utf-8?B?d0d2STJGZEFMUFQ0cnhET0huMm04a1phVEc4dENBVXdrNFF1VTVSMTZ1SVhL?=
 =?utf-8?B?SEVSS2d1c2lKOHNBejh4WmxzZkEvOFFwNFBoZ0dlTzRONVkrZ3pLQkFvRXpS?=
 =?utf-8?B?TDMwVVpjZkczUU5tdUxOY250ckQ2T3hraDllTzVqUkRkWlBoSEFHZnFOSndn?=
 =?utf-8?B?UUI5ZUtldEluK2Nlc3RKamlOL3JQY1F0V3JSZkVVNmRvVjA1VE9KOHFEd2lI?=
 =?utf-8?B?elR3Wi9TQ3pCVnNzU0hHYW42QlVUMklDbFpmbkRRODdaandRbGRjRlV3Qm5q?=
 =?utf-8?B?SnNORWYwNEhFYnNaZlIyL0dkY2Ezbjl6TWo3dkJ5TnY3Z0xzMGNha0YyYWt1?=
 =?utf-8?B?bGkyZ2sxL0JFZ3pkOWVCamdhTWF6emN2dDRBcGVTc1hSM3Zhd1ovdU1kMnVj?=
 =?utf-8?B?elBRUmhzbnREVUEvcjRrSzVSZXpTSHJQZ2JIMWM5QytHai80cE9HUERUQ29j?=
 =?utf-8?B?eTNuakx1ZG1nZ1ArcFRNT2N2MDVOS1krMUVRYnNlclRLcUw5bXhqOWVhbjFr?=
 =?utf-8?B?UEpUQnVDVElYcmpaZDdySTlRa29ja29jS2pWQXkxRGsvMkJHejR1a1RFSHU5?=
 =?utf-8?B?eWJqOVp0RWgwRnBzZ2wxTmp2T0l5S0k0N3J3Z0IxNk5VUy85NnhBeGl1MTJq?=
 =?utf-8?B?MGJVR2cvbnhIYWFFSngzelMwajloYkJJM2RFaUdHYXR3YVgzNWFtN2pwbEhB?=
 =?utf-8?B?OUlOUzM4SWFxQkdLY2tHSGVCcE1tbEhUSkpBNEdrdGxJeWxVem93eCs2RGUv?=
 =?utf-8?B?Vks1ZktSTlBWUmlXaEo2VFM0Qk9Tb3FCaW1MN2pvY3loWDUyMnBkcXlNVGIv?=
 =?utf-8?B?Y01NMXMwV3NwUFVrVWRlY29XVmFnbzViVklJWG5Jdy9UUzJWdStRdm91eVdq?=
 =?utf-8?B?VFJmSjhtWHpRVit3dCt0Uk1BODZqcFFuZmV4L2trV0hMcm1JRGUyMEg4U2FW?=
 =?utf-8?B?S1oxd1hEeXhSREZoa0hGTS84OTdjYk1xNHl5MFV3dzdOOHlrbk91ZDNqVkxS?=
 =?utf-8?B?MVQyUENxb3FhSENTcmNVWkY5K1E0aDNXU1Y1SzVTREpoTU1Zb2M2RytRdW1p?=
 =?utf-8?B?S2RZSTNZcHljVUhYaGI4V0pxTldiRlF3NFBEdzg2K3J0YUt6ZkwyTTJ1SUdH?=
 =?utf-8?B?TllIbXZtVmpPL3lnOFR5clBHemFYUDE2Mkt2L2dsaGJDcTJYcW1oWGEyUEJ2?=
 =?utf-8?B?TEF1NXVCMitYSTNYaWxnY2R3UEdPdncxWGpRMC84L1QrZG1nRmdKM29wdXBa?=
 =?utf-8?B?OXhqUXFvRjZUcEZsUzNtdmFqTExibzliTnJJaWtQWUZKT1loVmF6ZjRMbk1m?=
 =?utf-8?B?dGFBZk5HUGdPbi9KMzdPc2V0TlcxakFQS3M3SzFOZ3Zta0hxYTgzOWtwK09U?=
 =?utf-8?B?d3hCZWZZTG1td2xMZ05ySWJOZldNZndpTGFIVytIc09IT0U3TnM1dEY2ZHll?=
 =?utf-8?B?ekF2K1liSll3OG91Sng0T1ZtcDkvQ2NEeFRua2JTaWpLZkpZc3p6emVjNnFQ?=
 =?utf-8?B?bHhWajRnanRlSi82THhxR0t0VCtVaFhxbEd4a2k1TmJCQitZdFRXODBHZjk3?=
 =?utf-8?B?WmhjQmdtQnNPZDFLV21IalEzOCtVTld6YStsNkZjRWs3L1p1ZEw0RTlhRnZm?=
 =?utf-8?B?eEdrb2ZEc3YxVmhNNTZsK2NLRVpOTTZrM1hjemx5bFVHOFg0eDRFdXhNcnRT?=
 =?utf-8?B?V0Y0YnNKNExQSjNWR01mb3EyOFM1WXZOODhCMWlYV2p4TUpDc0VFMys1dEdu?=
 =?utf-8?Q?Urkv+NjOm3R5uYYYymI+78fuQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1EF53087459DA4D927618F2CB2BCD87@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52041d3f-8655-45e1-f8a1-08dd1610f74b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2024 16:13:48.0443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SO/rDUklifpFEABx5LuOjraPWV3S+xKkCGbnqi22GEgXgjuYzJMZ6CDybqIPTVMBr7Pq7gKAY0QI7v72+rabkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6840
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDE2OjM3ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiAg
K3N0YXRpYyBpbnQgZ2V0X3RkeF9zeXNfaW5mb190ZF9jb25mKHN0cnVjdCB0ZHhfc3lzX2luZm9f
dGRfY29uZiAqc3lzaW5mb190ZF9jb25mKQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmV0ID0gMDsNCj4g
PiArCXU2NCB2YWw7DQo+ID4gKwlpbnQgaSwgajsNCj4gPiArDQo+ID4gKwlpZiAoIXJldCAmJiAh
KHJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKDB4MTkwMDAwMDMwMDAwMDAwMCwgJnZhbCkp
KQ0KPiA+ICsJCXN5c2luZm9fdGRfY29uZi0+YXR0cmlidXRlc19maXhlZDAgPSB2YWw7DQo+ID4g
KwlpZiAoIXJldCAmJiAhKHJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKDB4MTkwMDAwMDMw
MDAwMDAwMSwgJnZhbCkpKQ0KPiA+ICsJCXN5c2luZm9fdGRfY29uZi0+YXR0cmlidXRlc19maXhl
ZDEgPSB2YWw7DQo+ID4gKwlpZiAoIXJldCAmJiAhKHJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2Zp
ZWxkKDB4MTkwMDAwMDMwMDAwMDAwMiwgJnZhbCkpKQ0KPiA+ICsJCXN5c2luZm9fdGRfY29uZi0+
eGZhbV9maXhlZDAgPSB2YWw7DQo+ID4gKwlpZiAoIXJldCAmJiAhKHJldCA9IHJlYWRfc3lzX21l
dGFkYXRhX2ZpZWxkKDB4MTkwMDAwMDMwMDAwMDAwMywgJnZhbCkpKQ0KPiA+ICsJCXN5c2luZm9f
dGRfY29uZi0+eGZhbV9maXhlZDEgPSB2YWw7DQo+ID4gKwlpZiAoIXJldCAmJiAhKHJldCA9IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkKDB4OTkwMDAwMDEwMDAwMDAwNCwgJnZhbCkpKQ0KPiA+ICsJ
CXN5c2luZm9fdGRfY29uZi0+bnVtX2NwdWlkX2NvbmZpZyA9IHZhbDsNCj4gPiArCWlmICghcmV0
ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoMHg5OTAwMDAwMTAwMDAwMDA4LCAm
dmFsKSkpDQo+ID4gKwkJc3lzaW5mb190ZF9jb25mLT5tYXhfdmNwdXNfcGVyX3RkID0gdmFsOw0K
PiA+ICsJZm9yIChpID0gMDsgaSA8IHN5c2luZm9fdGRfY29uZi0+bnVtX2NwdWlkX2NvbmZpZzsg
aSsrKQ0KPiANCj4gSXQgaXMgbm90IHNhZmUuIFdlIG5lZWQgdG8gY2hlY2sNCj4gDQo+IAlzeXNp
bmZvX3RkX2NvbmYtPm51bV9jcHVpZF9jb25maWcgPD0gMzIuDQo+IA0KPiBJZiB0aGUgVERYIG1v
ZHVsZSB2ZXJzaW9uIGlzIG5vdCBtYXRjaGVkIHdpdGggdGhlIGpzb24gZmlsZSB0aGF0IHdhcyAN
Cj4gdXNlZCB0byBnZW5lcmF0ZSB0aGUgdGR4X2dsb2JhbF9tZXRhZGF0YS5oLCB0aGUgbnVtX2Nw
dWlkX2NvbmZpZyANCj4gcmVwb3J0ZWQgYnkgdGhlIGFjdHVhbCBURFggbW9kdWxlIG1pZ2h0IGV4
Y2VlZCAzMiB3aGljaCBjYXVzZXMgDQo+IG91dC1vZi1ib3VuZCBhcnJheSBhY2Nlc3MuDQoNCitE
YXZlLg0KDQpJIHRob3VnaHQgMzIgKHdoaWNoIGlzIGFsc28gYXV0by1nZW5lcmF0ZWQgZnJvbSB0
aGUgIk51bSBGaWVsZHMiIGluIHRoZSBKU09ODQpmaWxlKSBpcyBhcmNoaXRlY3R1cmFsLCBidXQg
bG9va2luZyBhdCB0aGUgVERYIDEuNSBzcGVjLCBpdCBzZWVtcyB0aGVyZSdzIG5vDQpwbGFjZSBt
ZW50aW9uaW5nIHN1Y2guDQoNCkkgdGhpbmsgd2UgY2FuIGFkZDoNCg0KCWlmIChzeXNpbmZvX3Rk
X2NvbmYtPm51bV9jcHVpZF9jb25maWcgPD0gMzIpDQoJCXJldHVybiAtRUlOVkFMOw0KDQouLiB3
aGljaCB3aWxsIG1ha2UgcmVhZGluZyBnbG9iYWwgbWV0YWRhdGEgZmFpbHVyZSwgYW5kIHJlc3Vs
dCBpbiBtb2R1bGUNCmluaXRpYWxpemF0aW9uIGZhaWx1cmUuICBCYXNpY2FsbHkgaXQgbWVhbnMg
aWYgb25lIGRheSBzb21lIFREWCBtb2R1bGUgY29tZXMNCndpdGggPjMyIGVudHJpZXMsIHNvbWUg
b2xkIHZlcnNpb25zIG9mIGtlcm5lbCB3b24ndCBiZSBhYmxlIHRvIHN1cHBvcnRpdC4gIEJ1dCBJ
DQp0aGluayBpdCBzaG91bGQgYmUgZmluZS4NCg0KVGhpcyBhbHNvIHJlbWluZHMgbWUgcmVhZGlu
ZyB0aGUgQ01ScyBpcyBzaW1pbGFyLCBidXQgSSBkb24ndCB0aGluayB3ZSBuZWVkIHRvDQpkbyBz
aW1pbGFyIGNoZWNrIGZvciByZWFkaW5nIENNUnMgYmVjYXVzZSAibWF4aW11bSBudW1iZXIgb2Yg
Q01ScyBpcyAzMiIgaXMNCmFyY2hpdGVjdHVyYWwgYmVoYXZpb3VyIGFzIG1lbnRpb25lZCBpbiB0
aGUgVERYIDEuNSBiYXNlIHNwZWM6DQoNCjQuMS4zLjEgSW50ZWwgVERYIElTQSBCYWNrZ3JvdW5k
OiBDb252ZXJ0aWJsZSBNZW1vcnkgUmFuZ2VzIChDTVJzKQ0KDQouLi4NCg0KKiBUaGUgbWF4aW11
bSBudW1iZXIgb2YgQ01ScyBpcyBpbXBsZW1lbnRhdGlvbiBzcGVjaWZpYy4gSXQgaXMgbm90IGV4
cGxpY2l0bHkNCmVudW1lcmF0ZWQ7IGl0IGlzIGRlZHVjZWQgZnJvbSBGYW1pbHkvTW9kZWwvU3Rl
cHBpbmcgaW5mb3JtYXRpb24gcHJvdmlkZWQgYnkNCkNQVUlELg0KICAgKiBUaGUgbWF4aW11bSBu
dW1iZXIgb2YgQ01ScyBpcyAzMi4NCg0KSGkgRGF2ZSwNCg0KRG8geW91IGhhdmUgYW55IGNvbW1l
bnRzPw0K

