Return-Path: <kvm+bounces-26862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E48C9788C9
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAA5A1C22ED5
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA0E148833;
	Fri, 13 Sep 2024 19:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WckRtlb2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5C1474A9;
	Fri, 13 Sep 2024 19:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726255157; cv=fail; b=IaOm37g1eMl3NCqcp06IpoJB909DYelPA4g9liUEEJ2qWpDOs0Fz7+vzh5qUfCU16r3YwRyTbJQG1q/xhoubKg+y2XaLxjBsJ+Nj2FrKifwkoRsNYQpPMWQgh4ceDWsrLnMi9A3nIfg8LgUzOVELwHuJK8FtIs8alk+JAyxBXoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726255157; c=relaxed/simple;
	bh=+aRPSNmqQzs9/4L/us9fiYB9jE6hvVcmvbHj2WmIZVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WSqJvbY/OSVPJznKQgzaYMuIIdVKuAeg90WCPU9cMcqdG0SUdHbBVGmPmjastJhqxfiI56nH/AyidpGyy5DRHFpDPQYSVA91Gt/WPM6X4QER1oC+N1KZvVKx/kqvpOEK3n5TEw74Up6hccXlsOAzg6tt5qMFHnrseTBWTawiiTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WckRtlb2; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726255155; x=1757791155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+aRPSNmqQzs9/4L/us9fiYB9jE6hvVcmvbHj2WmIZVQ=;
  b=WckRtlb2U6Fwb+tK0T+6xjzTtDhy7oMK3hoX3ktAp7Hsj5xy4UtlKQ9/
   zvspPkiCCuGzmlGzmHjnrfL64zLN5K6qxt1EkwEOHedce51gRosaK6KY5
   vKRFP5BbkP4aBWh4CkDnMVajJb198zpwOHZJ/Cz602l1LWse8O4GSzAfZ
   QrfXWirl1n8sr7pntvhZ9Z5CVAToBD9VkeXdtbOS18lHHIP2sdrgjGaH3
   kqrLhiFUDBiDEYRD9TRU+w/9xvC2y3KIL35inhiGXHVqDW0k9R0ZhDed1
   L8GTwT/haTBKQLGfkUwwC8O2dnEQ+29Vhjp/OntzNxcCkeSU9+2pp8qlF
   A==;
X-CSE-ConnectionGUID: E2UVcgmFSE6ELXt1gDFj8Q==
X-CSE-MsgGUID: QevOpYeXQG+6EVq7IgywoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="36548755"
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="36548755"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 12:19:15 -0700
X-CSE-ConnectionGUID: t0l83rnHQD6PLoZsnOcrGw==
X-CSE-MsgGUID: yq/dInekRnWEWzLRWerIAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="68948853"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 12:19:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 12:19:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 12:19:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 12:19:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 12:19:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdnkBKhVs3iPd+lJzc/p9QeZdrvp/6T5s05+RUM4ggjggRFo+2y8uWATfIOltc34XWaSNFOQ+qksMUw0HEWdKKG/alZ63pNPiwncXZYzV+kbQ8vA1CZ2eJV/+DeWyrJ9+0wGsrCF7YWZ+OTfO2ep6zIBJAT4B+IhLDrU/wcGX0hkTau+wIYEg6pCKCRpWgiSfB8WppMmUpYKznj82ylYAPtAHJngYcMYRlKMLTCEnJdd7g979spvVFTfSBDCxLN0vu4o9KZnGkS3J8nFbvGu2+WxRX3q784zd/sHQ5R2TOGI7qFLbRvxBNV0JUrPNtcjZOkUanSYwvnEUgP1tQERXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aRPSNmqQzs9/4L/us9fiYB9jE6hvVcmvbHj2WmIZVQ=;
 b=t8kKLS1kxF+nSSPRJk+/Hmg0zFZgwIXoapuZ2RF8sGY0Oapu/p4nRBucBSkkOfiEWfCdn5ud1ZwkNJXDkzArhhs22QV6/9Wg+wbKOOyZ/Rh8piWc2o3wZ0V5Udinzo6LyZAcZszNNaQtBAVDvqWHUwolyyHO2mO7UI6TTetaIW4nz2akB/dSH3KZRTERdKJ0DoN2+QmWk73wGczO+hRi61RCDXJA4JPDehmVhH12Nl74rjdpIkmTT3atIVlsQhEJXzaJbTocwLe7RelcDtucTiv4k5+Fv6k2bcIRX+7Ru7xaMdNUAhiPrcZ1hIg2P3MwxTSvglbRuP61tMt6VixnCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5228.namprd11.prod.outlook.com (2603:10b6:408:135::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Fri, 13 Sep
 2024 19:19:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Fri, 13 Sep 2024
 19:19:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIABDTgAgAAL3ACAABXhgIAAC2gAgAAItQCAABS2AIAEHmMAgACzn4A=
Date: Fri, 13 Sep 2024 19:19:02 +0000
Message-ID: <33b60d50b7aa8ab7d984f9eb216b053e92e3184f.camel@intel.com>
References: <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
	 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
	 <Zt9kmVe1nkjVjoEg@google.com>
	 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
	 <ZuBQYvY6Ib4ZYBgx@google.com>
	 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
	 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
	 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5228:EE_
x-ms-office365-filtering-correlation-id: 859df34a-dc9d-41e0-a5a8-08dcd428ed8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZFQ3Z2VZenZxZmJpUGVCQ2Z0Qmx6VHJBUzNCVXhBNkEwRGIvWTVFMU0rcGpD?=
 =?utf-8?B?OUNHM0UvL1BuRlJUZittOFc5TE40WC9QVkdnVDJualZxZmtMZFNpaWo4Q3FV?=
 =?utf-8?B?ZDErQ0hLbXdUZUk1ZmxXZ3ExaWc5OGYwakdrMEdUWTVoUUVhZ005R0swREpz?=
 =?utf-8?B?eWVkays2Q1F6bFl5K081YUk2QlE5RkRxWmNsTktRN05kSEYzblg1NEFZWkxq?=
 =?utf-8?B?N2FwM0pINGM3cDVlcG10MXM4K2tBMjBqVWQzdDRZalYyMzNrbVZiU0xnWU9t?=
 =?utf-8?B?TjZBTFlwd2lnQlpiMzEyYTRtSFhMMjhSVlZQdkpoZzdyRG1BSXRzbXZMd2Ex?=
 =?utf-8?B?KzFJdUg4VjFWSjdReVd0djkxdS9zYXQvZlp4NnpzRGFlMVQ4a1dkaE9kdEJY?=
 =?utf-8?B?Zmlua2NXRGE2OUVMZ2NxRDZRSFBTdU9RbTQzNENlNVUyZjUvNUJnVThNOVVZ?=
 =?utf-8?B?NWJJUkhXU0Z4b2tVMjg5bmNwdnpyNHdnYjhLejI0RTFyODcvT0htNTJhK1Qw?=
 =?utf-8?B?SWVxVE5kUkRiN1VqcEU2MXY3bURMckgxYW1zaVZUZ3o3UEoxaXdFNTJqcktN?=
 =?utf-8?B?dUlrWGVKTEFUVjk3YmVBSWd1N0N5VHkveFpORHJkYUM1YUs5eHVQQURkZGRy?=
 =?utf-8?B?c2theGJFZEpMUXFuZk5TQ2k5cFJGVHI2eWQzRlQ5TmpaS1NIU2V3RzVCb3ox?=
 =?utf-8?B?TDZKQ3BhdmIxSCs2M2RZUDNNSXNOeXp5d1JuYTZ3RWZCdTliRmxwWm05VTN2?=
 =?utf-8?B?enR3MndFTGRTdlcxUjMxakZjdC8wRkhjQW9GbXpsRW9LcGZTTmd5T1diZmVU?=
 =?utf-8?B?cHNITHVKRHlYbDEvQkFkOFdHV05HK0lDRnlMSEdmektEdER6RWlKVVlPNE9X?=
 =?utf-8?B?dnE2ZjlyYWV3aFZHd1RjSEpQVTFNZ0dETjBlVEVTenpCOGxGUUxjZm40UFFL?=
 =?utf-8?B?MEI0eEhIeHk1MlRQc0lBazl2MXhsSEFPZzJmbFl2cHVYdTJKSk00S2VaMWJP?=
 =?utf-8?B?NTEvSmZzak9wRzRERW96WnZZazg4UXltMzI5LzZSSmtBblg4d3hqK3pIUlkv?=
 =?utf-8?B?VEF5TWhQR3V2WEhwVmtBdlgwVEx2ZTZ0ZjNoaXhHdFJVazllS05UUmg1azZ0?=
 =?utf-8?B?MEtMN3NFUmExUkdzSC9wLzEyb0dFMnZzODNLTXFwQjIwVkVaS2ZtdkcwWlJX?=
 =?utf-8?B?ZkVrRENlS1hUaFFaUlpOTGFNU2I1V256Q0hhMFJWS016S2VJaklqOVE4RzB3?=
 =?utf-8?B?TW9zU1RyZDBBcUZLbkM5Q0sxdEtUMUtjQWorclVHSkU2TVhMZG9jUmxWVEc4?=
 =?utf-8?B?VXppN2JTaW9lUzY1YUFsdGF6bzB1TWVTQmVWajV5azJXdDdVL1psQldwMFo1?=
 =?utf-8?B?MWpYTTFTUy9rNkVWY3g1VTU2RGFZS29leE9JV2wxK2FVeExONFVmbHFiZGph?=
 =?utf-8?B?L3pxa3RwbHZWZUZRdTQ3VUpldTNFRGJxb0tZK2NIOWlqZUNmM3o3aUloaXBH?=
 =?utf-8?B?V01HMU9zUXNSRGVHOG94dDQreDdJaG1DNmpuUmZncGI3N1NybmhBSzlFd0dh?=
 =?utf-8?B?Qk1iTGllaDVXOUsvWjF6QWJiV016cFRUemV4Tk1KdTN2a2Z5ZjI5MFN6RlJp?=
 =?utf-8?B?cnZ6cFRtVnBRNk13SkwyaklVZ1pJNmFJc2pWb1ZZa2ZWVFNGb0UrRnNXT0k3?=
 =?utf-8?B?Z0ZkR0RXdkRVcTg2NUhXZ2tTeFdldkdGNG94SCtsdXg5NmV1UzJRekljeTRB?=
 =?utf-8?B?bmEyU0U1SjA2MnJ2Y1NNenJZS2tJay8rMHE1ckF6b0k2Z092YTd2TzkreFpr?=
 =?utf-8?B?c0FqOGY4bjFwdmpTSHZva0tweXFLK3lrRThhRmxINk52a3ZnQjRPb1lTNUcx?=
 =?utf-8?B?eXl5SzJ5UXNhWmNnTlpvcnRFUW1BQXEvOUg1KzJOY3hTM0E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjBrYXFRZTBOa2tYMGIyaFF3SVJPMExyZjRobEF2dnBZYUp4bUFYMUNCeE9O?=
 =?utf-8?B?ajVxWHljQlhoUnRua3lPbGNac3RvcVZUZVlGbkhmazdQa0RLa2FQSVlVZDB0?=
 =?utf-8?B?N203L09JT3F1QzA2UjBOb2RDUGxYV05rZTM2U2ZpM3o5RU9URk5TK2hXcVZx?=
 =?utf-8?B?bGdOWlJmeG4rbjNveDRGL1RQakw4cWZwMnJCczRnOXFPZWU0cllPRisxbVZp?=
 =?utf-8?B?bWZraDU1Z0F2aEpPRzRIaWtZcmVzelYvOWdUN3lhVG94Rm9UZ1h6Nk9lUENq?=
 =?utf-8?B?Y2hDSHlkaEVwRHo4OFZ4YXpweHM2Z21WQ0ZsM00rSDZWNEhSdXVtMFNIRzRo?=
 =?utf-8?B?c2h4dEc4L2kyVS9zS0h5aHFmS0I2TmVndUozVkVxaXFXeFRteTZNSUNXSlRT?=
 =?utf-8?B?QjV0dldxMVBQdEhLVUxUYWZjemVRYnExVVI4RnZBMDNvQWo5OUtzT1dZaC9t?=
 =?utf-8?B?NmdWdVJ2aFN3MCtJMTN6eGpQWGhONlpJenVXQTFPRDZtV1phYzQvVXBKVzI2?=
 =?utf-8?B?ZFh6S1RGdVJsNjJZRGFjNkNaN3VTV0NiQ0pidWRFNXhKa3g1RlFIcGRCRjcx?=
 =?utf-8?B?eDc0VjJtL1dha1JFZ2k5c1Q0eFFqMzg5MjlOTjgwUXNUUjl1VksvSWs0SjVr?=
 =?utf-8?B?WWc1cWpZYU4zQ2R6SWd2Z255dTBWS2Z2aGlqRU1id1RUZC9ib0JuVDV4TVRv?=
 =?utf-8?B?MFh1WWNFS3R4WE9kRWFyUnJpUmRvRHIrTDAwUnlmYXhuZUE2eXd2KzhWa21O?=
 =?utf-8?B?NjVVV3dUZXprOEhGNmlPQmRxUFFIbGQvdS8rTlVva2kvZU9tdnlVYXVKSjVm?=
 =?utf-8?B?Zld0dm5FMjVCSDJqV24xNEhPakdxcVRsUmtKcUxWVDlJVEtOdVE1eENnckpu?=
 =?utf-8?B?cWpXQlppV09WRElGbW0raDZHSnQ2Qjc2SWtLclJITFlYeURSZzB2cHFFWkZl?=
 =?utf-8?B?SFRTTDlWQ2syUUVFUXIxNnpzYldWZW9NK3MxMmZaMWYrOC9CNDZiNXlWN2xH?=
 =?utf-8?B?NWthNDNhUkk4cTExWS83Wml6T0dveElSY1NZTE1KR0dWNytFRGxWalF4c3p0?=
 =?utf-8?B?WEl0d2ZMc1NrT0hVY2tFaDFldUplMi9NbDRZdVk0Y2ZVN05XUnUvUU1RTFlC?=
 =?utf-8?B?NVFBQXNDOWFFejk4ajJRM3pRZ2hiZDhmcTZ5QVVkd2Z3a3J0VG5uZVRaYkd2?=
 =?utf-8?B?ZEUranVBOEpMTEM0aWczLzhBdUNUejN2WWtIVkt1b2VJdXpwRmowNFA0RE5I?=
 =?utf-8?B?bjRQZU10RkpJRVRHYTllLzBNY3MvQ1RqR1JZMHpxQXV6eEpOUEYzVU1iWTlt?=
 =?utf-8?B?ZE5JUWt3ZDlKMThwMDdvR2dSdTdpR2RoS1IrSVFYNkJLNlF0a2VOV1A5aVhS?=
 =?utf-8?B?SVpkZGZoTEtqOFNBU1B2akFKS0NNb3JtQjgyR1E1MURiUW5XL25NVkc3Z2pC?=
 =?utf-8?B?VWowNXg1TlJBQmpzY0hsU2FOdzRIZU9zQ1ZTMXgwZE1sb1BhcVA0dXNUTGow?=
 =?utf-8?B?ODNibUgzUTlTRm95WXVkK0haL294QTh4M2xjUCtPczhWS1lmWDFLMDFLcmll?=
 =?utf-8?B?Vm5ScGNNRjBseFVHaWp4R3ZESlE2WVAzZkQ4UTgwWFFkV0ZuTnloN2M5dk9D?=
 =?utf-8?B?WmdPNDBLS0xRS1FRbmJDNVFuVjZJbzJCR3gxSjBhK1dueWJmMUxVb0x3c3Av?=
 =?utf-8?B?cVVBNkE5dE5LeHFwRDI3NHhNazZhM1ZRVnp5cUpFdUhvWkdMMDFLYmdKSTdl?=
 =?utf-8?B?QU9zRDJrYXhSaGlxeWVVZkh5eFRzQUNTbVljQlB6cDRXcHdGWGxtdm1pcUNB?=
 =?utf-8?B?OGpvQUdwcDJmcXhUcSt1YTVDWk1DbTZwZ0lteDZFcTFGM2trNllEdFYvZU1r?=
 =?utf-8?B?Qk8yZlJET28ydW5RKzRkeStOQ3J3TmhzcWJlbElSOHFVbkRtMDNZSE5ESDB3?=
 =?utf-8?B?OGsxaTR5SUQ1cGtKZ2wvYWc2RHVGTExZeXJpR0xJV2xFY0xpUENpNFQyRmFR?=
 =?utf-8?B?bzN0OWUvTC94VVFGZ0dIUnBkT2lTc1lEbncxY0lQOGh3N3JZeXRkSWxaUTF6?=
 =?utf-8?B?YkNXUFFSdXZvV01XRmZ3cUNmU2lka29adnBKZ3BqZWpnci9QZ01SY1l4aS9p?=
 =?utf-8?B?emt1Z0VOWHE0VzFHVGdBN0ltVnBlYmVXa2wvYzR5MGp2ZmNyUk5MT1EvRVhT?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85A7DE92FDE29C47B9D580A9D1854332@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 859df34a-dc9d-41e0-a5a8-08dcd428ed8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 19:19:02.8396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hftz6qFj/zQcS/Ceokz8v/T8A4p6lewOl8oNa8od10Bak8RTJgxx5zezGO9V65xjUZ57EQImNpcJZ87PGmPpN4HyFv/JRlkDuWiDth6TM24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5228
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTEzIGF0IDE2OjM2ICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiAKVGhh
bmtzIFlhbiwgdGhpcyBpcyBncmVhdCEKCj4gVGhpcyBpcyBhIGxvY2sgc3RhdHVzIHJlcG9ydCBv
ZiBURFggbW9kdWxlIGZvciBjdXJyZW50IFNFQU1DQUxMIHJldHJ5IGlzc3VlCj4gYmFzZWQgb24g
Y29kZSBpbiBURFggbW9kdWxlIHB1YmxpYyByZXBvCj4gaHR0cHM6Ly9naXRodWIuY29tL2ludGVs
L3RkeC1tb2R1bGUuZ2l0Cj4gYnJhbmNoIFREWF8xLjUuMDUuCj4gCj4gVEw7RFI6Cj4gLSB0ZGhf
bWVtX3RyYWNrKCkgY2FuIGNvbnRlbmQgd2l0aCB0ZGhfdnBfZW50ZXIoKS4KPiAtIHRkaF92cF9l
bnRlcigpIGNvbnRlbmRzIHdpdGggdGRoX21lbSooKSB3aGVuIDAtc3RlcHBpbmcgaXMgc3VzcGVj
dGVkLgo+IC0gdGRnX21lbV9wYWdlX2FjY2VwdCgpIGNhbiBjb250ZW5kIHdpdGggb3RoZXIgdGRo
X21lbSooKS4KPiAKPiBQcm9wb3NhbDoKPiAtIFJldHVybiAtRUFHQUlOIGRpcmVjdGx5IGluIG9w
cyBsaW5rX2V4dGVybmFsX3NwdC9zZXRfZXh0ZXJuYWxfc3B0ZSB3aGVuCj4gwqAgdGRoX21lbV9z
ZXB0X2FkZCgpL3RkaF9tZW1fcGFnZV9hdWcoKSByZXR1cm5zIEJVU1kuCgpSZWdhcmRpbmcgdGhl
IHNlcHQgZW50cnkgY29udGVudGlvbiB3aXRoIHRoZSBndWVzdCwgSSB0aGluayBLVk0gbWlnaHQg
bm90IGJlCmd1YXJhbnRlZWQgdG8gcmV0cnkgdGhlIHNhbWUgcGF0aCBhbmQgY2xlYXIgdGhlIHNl
cHQgZW50cnkgaG9zdCBwcmlvcml0eSBiaXQuCldoYXQgaWYgdGhlIGZpcnN0IGZhaWx1cmUgZXhp
dGVkIHRvIHVzZXJzcGFjZSBiZWNhdXNlIG9mIGEgcGVuZGluZyBzaWduYWwgb3IKc29tZXRoaW5n
PyBUaGVuIHRoZSB2Y3B1IGNvdWxkIHJlZW50ZXIgdGhlIGd1ZXN0LCBoYW5kbGUgYW4gTk1JIGFu
ZCBnbyBvZmYgaW4KYW5vdGhlciBkaXJlY3Rpb24sIG5ldmVyIHRvIHRyaWdnZXIgdGhlIEVQVCB2
aW9sYXRpb24gYWdhaW4uIFRoaXMgd291bGQgbGVhdmUKdGhlIFNFUFQgZW50cnkgbG9ja2VkIHRv
IHRoZSBndWVzdC4KClRoYXQgaXMgYSBjb252b2x1dGVkIHNjZW5hcmlvIHRoYXQgY291bGQgcHJv
YmFibHkgYmUgY29uc2lkZXJlZCBhIGJ1Z2d5IGd1ZXN0LApidXQgd2hhdCBJIGFtIHNvcnQgb2Yg
cG9uZGVyaW5nIGlzIHRoYXQgdGhlIHJldHJ5IHNvbHV0aW9uIHRoYXQgbG9vcCBvdXRzaWRlIHRo
ZQpmYXVsdCBoYW5kbGVyIGd1dHMgd2lsbCBoYXZlIG1vcmUgY29tcGxleCBmYWlsdXJlIG1vZGVz
IGFyb3VuZCB0aGUgaG9zdCBwcmlvcml0eQpiaXQuIFRoZSBOIGxvY2FsIHJldHJpZXMgc29sdXRp
b24gcmVhbGx5IGlzIGEgYnJvd24gcGFwZXIgYmFnIGRlc2lnbiwgYnV0IHRoZQptb3JlIHByb3Bl
ciBsb29raW5nIHNvbHV0aW9uIGFjdHVhbGx5IGhhcyB0d28gZG93bnNpZGVzIGNvbXBhcmVkIHRv
IGl0OgoxLiBJdCBpcyBiYXNlZCBvbiBsb2NraW5nIGJlaGF2aW9yIHRoYXQgaXMgbm90IGluIHRo
ZSBzcGVjICh5ZXMgd2UgY2FuIHdvcmsgd2l0aApURFggbW9kdWxlIGZvbGtzIHRvIGtlZXAgaXQg
d29ya2FibGUpCjIuIEZhaWx1cmUgbW9kZXMgZ2V0IGNvbXBsZXgKCkkgdGhpbmsgSSdtIHN0aWxs
IG9uYm9hcmQuIEp1c3QgdHJ5aW5nIHRvIHN0cmVzcyB0aGUgZGVzaWduIGEgYml0LgoKKEJUVyBp
dCBsb29rcyBsaWtlIExpbnV4IGd1ZXN0IGRvZXNuJ3QgYWN0dWFsbHkgcmV0cnkgYWNjZXB0IG9u
IGhvc3QgcHJpb3JpdHkKYnVzeSwgc28gdGhleSB3b24ndCBzcGluIG9uIGl0IGFueXdheS4gUHJv
YmFibHkgYW55IGNvbnRlbnRpb24gaGVyZSB3b3VsZCBiZSBhCmJ1Z2d5IGd1ZXN0IGZvciBMaW51
eCBURHMgYXQgbGVhc3QuKQoKPiAtIEtpY2sgb2ZmIHZDUFVzIGF0IHRoZSBiZWdpbm5pbmcgb2Yg
cGFnZSByZW1vdmFsIHBhdGgsIGkuZS4gYmVmb3JlIHRoZQo+IMKgIHRkaF9tZW1fcmFuZ2VfYmxv
Y2soKS4KPiDCoCBTZXQgYSBmbGFnIGFuZCBkaXNhbGxvdyB0ZGhfdnBfZW50ZXIoKSB1bnRpbCB0
ZGhfbWVtX3BhZ2VfcmVtb3ZlKCkgaXMgZG9uZS4KPiDCoCAob25lIHBvc3NpYmxlIG9wdGltaXph
dGlvbjoKPiDCoMKgIHNpbmNlIGNvbnRlbnRpb24gZnJvbSB0ZGhfdnBfZW50ZXIoKS90ZGdfbWVt
X3BhZ2VfYWNjZXB0IHNob3VsZCBiZSByYXJlLAo+IMKgwqAgZG8gbm90IGtpY2sgb2ZmIHZDUFVz
IGluIG5vcm1hbCBjb25kaXRpb25zLgo+IMKgwqAgV2hlbiBTRUFNQ0FMTCBCVVNZIGhhcHBlbnMs
IHJldHJ5IGZvciBvbmNlLCBraWNrIG9mZiB2Q1BVcyBhbmQgZG8gbm90IGFsbG93Cj4gwqDCoCBU
RCBlbnRlciB1bnRpbCBwYWdlIHJlbW92YWwgY29tcGxldGVzLikKPiAKPiBCZWxvdyBhcmUgZGV0
YWlsZWQgYW5hbHlzaXM6Cj4gCj4gPT09IEJhY2tncm91bmQgPT09Cj4gSW4gVERYIG1vZHVsZSwg
dGhlcmUgYXJlIDQga2luZHMgb2YgbG9ja3M6Cj4gMS4gc2hhcmV4X2xvY2s6Cj4gwqDCoCBOb3Jt
YWwgcmVhZC93cml0ZSBsb2NrLiAobm8gaG9zdCBwcmlvcml0eSBzdHVmZikKPiAKPiAyLiBzaGFy
ZXhfaHBfbG9jazoKPiDCoMKgIEp1c3QgbGlrZSBub3JtYWwgcmVhZC93cml0ZSBsb2NrLCBleGNl
cHQgdGhhdCBob3N0IGNhbiBzZXQgaG9zdCBwcmlvcml0eQo+IGJpdAo+IMKgwqAgb24gZmFpbHVy
ZS4KPiDCoMKgIHdoZW4gZ3Vlc3QgdHJpZXMgdG8gYWNxdWlyZSB0aGUgbG9jayBhbmQgc2VlcyBo
b3N0IHByaW9yaXR5IGJpdCBzZXQsIGl0Cj4gd2lsbAo+IMKgwqAgcmV0dXJuICJidXN5IGhvc3Qg
cHJpb3JpdHkiIGRpcmVjdGx5LCBsZXR0aW5nIGhvc3Qgd2luLgo+IMKgwqAgQWZ0ZXIgaG9zdCBh
Y3F1aXJlcyB0aGUgbG9jayBzdWNjZXNzZnVsbHksIGhvc3QgcHJpb3JpdHkgYml0IGlzIGNsZWFy
ZWQuCj4gCj4gMy4gc2VwdCBlbnRyeSBsb2NrOgo+IMKgwqAgTG9jayB1dGlsaXppbmcgc29mdHdh
cmUgYml0cyBpbiBTRVBUIGVudHJ5Lgo+IMKgwqAgSFAgYml0IChIb3N0IHByaW9yaXR5KTogYml0
IDUyIAo+IMKgwqAgRUwgYml0IChFbnRyeSBsb2NrKTogYml0IDExLCB1c2VkIGFzIGEgYml0IGxv
Y2suCj4gCj4gwqDCoCAtIGhvc3Qgc2V0cyBIUCBiaXQgd2hlbiBob3N0IGZhaWxzIHRvIGFjcXVp
cmUgRUwgYml0IGxvY2s7Cj4gwqDCoCAtIGhvc3QgcmVzZXRzIEhQIGJpdCB3aGVuIGhvc3Qgd2lu
cy4KPiDCoMKgIC0gZ3Vlc3QgcmV0dXJucyAiYnVzeSBob3N0IHByaW9yaXR5IiBpZiBIUCBiaXQg
aXMgZm91bmQgc2V0IHdoZW4gZ3Vlc3QKPiB0cmllcwo+IMKgwqDCoMKgIHRvIGFjcXVpcmUgRUwg
Yml0IGxvY2suCj4gCj4gNC4gbXV0ZXggbG9jazoKPiDCoMKgIExvY2sgd2l0aCBvbmx5IDIgc3Rh
dGVzOiBmcmVlLCBsb2NrLgo+IMKgwqAgKG5vdCB0aGUgc2FtZSBhcyBsaW51eCBtdXRleCwgbm90
IHJlLXNjaGVkdWxlZCwgY291bGQgcGF1c2UoKSBmb3IKPiBkZWJ1Z2dpbmcpLgo+IAo+ID09PVJl
c291cmNlcyAmIHVzZXJzIGxpc3Q9PT0KPiAKPiBSZXNvdXJjZXPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBTSEFSRUTCoCB1c2Vyc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEVYQ0xVU0lW
RSB1c2Vycwo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICgxKSBURFLCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgdGRoX21uZ19yZHdywqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhfbW5n
X2NyZWF0ZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRk
aF92cF9jcmVhdGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhfbW5nX2FkZF9jeAo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF92cF9hZGRjeMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRoX21uZ19pbml0Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRoX3ZwX2luaXTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdGRoX21uZ192cGZsdXNoZG9uZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF92cF9lbnRlcsKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgdGRoX21uZ19rZXlfY29uZmlnIAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHRkaF92cF9mbHVzaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdGRoX21uZ19rZXlfZnJlZWlkCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdGRoX3ZwX3JkX3dywqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhf
bXJfZXh0ZW5kCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dGRoX21lbV9zZXB0X2FkZMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF9tcl9maW5hbGl6ZQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF9tZW1fc2VwdF9y
ZW1vdmXCoMKgwqDCoMKgwqDCoCB0ZGhfdnBfaW5pdF9hcGljaWQKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhfbWVtX3BhZ2VfYXVnwqDCoMKgwqDCoMKg
wqDCoMKgwqAgdGRoX21lbV9wYWdlX2FkZAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHRkaF9tZW1fcGFnZV9yZW1vdmUKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhfbWVtX3JhbmdlX2Jsb2NrCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRoX21lbV90cmFjawo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF9tZW1fcmFuZ2VfdW5i
bG9jawo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF9w
aHltZW1fcGFnZV9yZWNsYWltCgpJbiBwYW10X3dhbGsoKSBpdCBjYWxscyBwcm9tb3RlX3NoYXJl
eF9sb2NrX2hwKCkgd2l0aCB0aGUgbG9jayB0eXBlIHBhc3NlZCBpbnRvCnBhbXRfd2FsaygpLCBh
bmQgdGRoX3BoeW1lbV9wYWdlX3JlY2xhaW0oKSBwYXNzZWQgVERYX0xPQ0tfRVhDTFVTSVZFLiBT
byB0aGF0IGlzCmFuIGV4Y2x1c2l2ZSBsb2NrLiBCdXQgd2UgY2FuIGlnbm9yZSBpdCBiZWNhdXNl
IHdlIG9ubHkgZG8gcmVjbGFpbSBhdCBURCB0ZWFyCmRvd24gdGltZT8KClNlcGFyYXRlbHksIEkg
d29uZGVyIGlmIHdlIHNob3VsZCB0cnkgdG8gYWRkIHRoaXMgaW5mbyBhcyBjb21tZW50cyBhcm91
bmQgdGhlClNFQU1DQUxMIGltcGxlbWVudGF0aW9ucy4gVGhlIGxvY2tpbmcgaXMgbm90IHBhcnQg
b2YgdGhlIHNwZWMsIGJ1dCBuZXZlci10aGUtCmxlc3MgdGhlIGtlcm5lbCBpcyBiZWluZyBjb2Rl
ZCBhZ2FpbnN0IHRoZXNlIGFzc3VtcHRpb25zLiBTbyBpdCBjYW4gc29ydCBvZiBiZQpsaWtlICJ0
aGUga2VybmVsIGFzc3VtZXMgdGhpcyIgYW5kIHdlIGNhbiBhdCBsZWFzdCByZWNvcmQgd2hhdCB0
aGUgcmVhc29uIHdhcy4KT3IgbWF5YmUganVzdCBjb21tZW50IHRoZSBwYXJ0cyB0aGF0IEtWTSBh
c3N1bWVzLgoK

