Return-Path: <kvm+bounces-19024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0ED8FF1F8
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D790286FC4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAD2198E8A;
	Thu,  6 Jun 2024 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNLrNOxh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D47D13C690;
	Thu,  6 Jun 2024 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690358; cv=fail; b=AEHeuD/cuLKjQVyOACv3AtpxNHZ6lzEzVmTiZknYFN8v4D5Pc3HICW+Le3B2gGZLlAjoYeP1Fkg7sUQtkcqcskGf2e3wNTTpODHY2f0S10kaqwyH4csqeIguPvrkurRClQrPXWRIJTEXgmq1Ghb/Tpd3TdYZPiINj1OLezfXPvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690358; c=relaxed/simple;
	bh=nJUWMdxBgmOuWXLF4AAGPTPIbjVIBLIw5sPFNgAgPsY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i7IXtxgqIMB2+eoEnTj3y2ftMyjfUpaLzbNXobddX0dpHt/mfSAqPk/mWDozA9w3rX6jjp0UkP2fV4k8JewpB2QlWlHaozrC6JoQIxtgfbLv9mXLYE3o9oAINtjCd1TKQfJwpZAq70gtnVn9MZ2lXb6bPb7KxmnPGGcKzbbUf/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNLrNOxh; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717690358; x=1749226358;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nJUWMdxBgmOuWXLF4AAGPTPIbjVIBLIw5sPFNgAgPsY=;
  b=GNLrNOxh3jfTKeDsk+sZ4uhtuLDTSPNCFoCEEgcNfn1d49UYN0fO0cqL
   VBwNFrVLbJgjyBERCFEL+C30i1HSdAm0OWtxNUYNzfjo4Va3ghbHPxIiu
   dMg9ZcuNXPVvpS6mznYySlLk6xeNb7ZkTJlPvj7m/vpN5L28X043J3zbZ
   tSi/GY8gOwMok4yHPiGv3Ok3zDU1txND8gdpOATeAvhpbJN2lDMuMTYJI
   sJlBN3nlCkodt7cGxJZY2yPR5nyg3apO0EMHRLnYrgW2QiFYlPBonSSzJ
   3FxI4YU8q9czFSrfNqO5ZzXzzCK2QqB+iW2tK93LHykEF0y3RNpb9K7/M
   w==;
X-CSE-ConnectionGUID: BZ1i4SmjTzS/rWMAIRhBEA==
X-CSE-MsgGUID: HReKEMkLQRiK60hW83y4MA==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14208888"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="14208888"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:12:37 -0700
X-CSE-ConnectionGUID: UxvdE+bASyq277OBxwVfbg==
X-CSE-MsgGUID: Z+5n42RQS6uY7ZumLlvIGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="68809676"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 09:12:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:12:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:12:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 09:12:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 09:12:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8RFxHRdynVnaMIQUs99gWeB0d5LQuqzFBrgPeO6RdJl8XEKDiLOoZrg01MzHV7XCt8rFLbzdYEihrbIf7nRObJcmVWZBzXi4gU3LB8ckUQnDP1jnS1qG4InXt8c9GaPHe7xfhWZQ1MtvfGOACU9DhY6MLtFmzkChF0bewrSaDr0GIlyftoySQez+iUA5TNf+hyX4Tz4KRDkAVYVKLIYo+bsscqLW767PIgXsNz/T+hmnFfpMyC+LrGqtQd4+dXop0fmv72mF6hxVS13rT5ukUzhZAQIpVHr/CQsFUUA9oBGgJh4FRyTXotYz7rRy3cp6K68NW1JT87RFIo+wW6Bmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJUWMdxBgmOuWXLF4AAGPTPIbjVIBLIw5sPFNgAgPsY=;
 b=Je+dngz0PrnDvhS3gvUJV+onj7Aj24gGuzecBxTQV6aC7PbN8Owu6Ne7nSYl9LrmY+ZIpRMiExW/8ML+YMR2I2ct5+7c0gFVvIlc2RwvsgwuonBtMZh+A5NhiQF+XzjF7tl4AzeHnavKBE7tgNh0IvN+5GA+HbNjJz6vw7wI3uMSARt3dHOtwMKcCMzV9leRZ0xCROQTi+MLf249avBBWV3QCRGmHAWqFlzRIssi+z14tOLSpDpMv4YG3NwPlCwVneqTiQTFvo7wCuTbGoqiypERtA3TVijYcJeQkxmyyFSrUwx66IwzRjEXoQpYP1GgChX8+QMmwMmjGBFB9eMDAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Thu, 6 Jun
 2024 16:12:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:12:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 03/15] KVM: x86/mmu: Add a mirrored pointer to struct
 kvm_mmu_page
Thread-Topic: [PATCH v2 03/15] KVM: x86/mmu: Add a mirrored pointer to struct
 kvm_mmu_page
Thread-Index: AQHastVp1sVeZEMm1Eqq2+Yxo7cj8rG68LKAgAACRQA=
Date: Thu, 6 Jun 2024 16:12:25 +0000
Message-ID: <639dbbf803b670ffdb9681c3c76bb91eae0f729a.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-4-rick.p.edgecombe@intel.com>
	 <CABgObfYO2FgAOpvp-9jexp5fMh2xoYyE1CNs526z9S7i2Gao_g@mail.gmail.com>
In-Reply-To: <CABgObfYO2FgAOpvp-9jexp5fMh2xoYyE1CNs526z9S7i2Gao_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4854:EE_
x-ms-office365-filtering-correlation-id: dd14e206-fa9c-42a2-3a98-08dc86437468
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?KzJiZ2kwMElabytiRlYvaCt6MDlQRUdmTHI0enNZaGwwb0pwbyt1UW96S25K?=
 =?utf-8?B?YkdFQUphbmpLS2w0NFcrSzlKTDhxMFM5anluQ3kzcktNaW1YZWdoUm44NWJv?=
 =?utf-8?B?S3RyNUlrQkdDa1RBeG5JMG1iekZPVHdSamNDdklxZmhwZFhJTk01MENON29i?=
 =?utf-8?B?Q0JzYkQyU2o5b3FjbUc3Rnl6TDhYKzkrc0tNS1JTU2QwNENLbmREMGFmdldD?=
 =?utf-8?B?bnphbUQzSTF3NzBjYmMyZmxvdjdpWEhZb3UvMzhHSWs0MmFZTFkvbitVTXBa?=
 =?utf-8?B?MlBCMi9nWVpVNE5SMkkwellkMWpKS3FLYmpNMzgzUGVjRngzcHZhMit6OUlv?=
 =?utf-8?B?TzF6LzBIVmFmZUsyYUxmb0FHL1h0ZkM5N2Y3TGlrZGZoWHoySW0xQWROc3B3?=
 =?utf-8?B?U1RzTzV4R3FhbGJYb0FmQ255aG51d09kQWNKa2NxMkFZcXQzaDV6eE9FTm9a?=
 =?utf-8?B?OTJISGNUUUxBSUJxRHkxZWVBY294V3BMQzM0STdoSGZzTUJSR2Zxb3FSQVN3?=
 =?utf-8?B?c3JyMjBQdUpMK1ZUalRtWWxRbzZpSDRsRXF1Q3VDSHJKQW96Rmg5dlUwY3BZ?=
 =?utf-8?B?aWdnQ3ZEZ0duTkZZL0hTWnp5Z2pFWjliSjBrZmNwMy9seWZlcHJrZ3RxL1BP?=
 =?utf-8?B?NEdweWFja3pKZkVHZkVqbHlVNjM1eWN0UUtmOGxWTVF6YjgyTVNLbHAzdnpB?=
 =?utf-8?B?NzRINlgrWVh3bldvMmJmTXhIRG1vWVlYWXgyeVNvWWJzMCtLSFpMVnIzWUgx?=
 =?utf-8?B?UnM5N3BMV3czRUxFTGlCQ2orY0hlZ01jYXhKYWsxOFlNc0ZsSCtuVFZtb2w2?=
 =?utf-8?B?ZE5oNlFTdmdQRndNMFdEM2VPQ0dXSUppTExaNGZuRm9YQkppTXlPMVlrMzdr?=
 =?utf-8?B?Zm9uUmVGR0pocGMrcU81UU1XTTlmSGJvV2xqemdCY2h1Vk84Zks0VFFtcU9S?=
 =?utf-8?B?NGcwWjNuOTdQOFA1N1IwR3NCbEh4eFdzSTNndGM2Rm5xSG5mUXBqOCtqMWJJ?=
 =?utf-8?B?bTF1czIveWkrKzNsQW1tMU1Oc2dsVDBRdHNXcXFhNHJHUjRJVmRoWXNHdFVk?=
 =?utf-8?B?aktiSXNUdytlNkxCR25qZ2F2WUZwSnBGMFZzYjdBdXoyRE95eWFhZTJ0aVVH?=
 =?utf-8?B?TEtjLzlHd3U5U1FpUmIyQ3ZTVjNWY21iOXAzdWMzRVZaUitSeWdRbnc5RDAv?=
 =?utf-8?B?eTVtd2xVOHh5aTkrMTN3Z1ZkTDJKRGNWY2dDRlZ6U09BQlF2N21EVWU5THJn?=
 =?utf-8?B?WEk0NG9NdXJHaWZiTi9FQU5aWXNyOXRUWDRIYkNLMmhkakNidENLVlZYV21P?=
 =?utf-8?B?MnFMV1FVeTFUMGc3eTUzeThpTW9rZE55WUhHZ3NXWlNqOWtsM1NkS3VtQTU3?=
 =?utf-8?B?cHFxOTZwZ2I3QXRRYTN6dzlacWhycW01QWJVSi9SSVhqa0pzVWpjVFM5c3Np?=
 =?utf-8?B?ZGxaMmpOU3hJSzE2OGRXL0E5UGo0a0NUNC9ZdUFERVZQZFNOSmZuN3RQRVp3?=
 =?utf-8?B?S2d4dlBHWklBQmlLamZOc0RYb1hhNkJUZEdpYmV0cGdpWUZ5aE1mUEU2dUZ5?=
 =?utf-8?B?VmE5VE92K0l0VmhFRnFnUW0rWTlmQm1xYlZZVStaOXZ4OWJ5N1VHb3VDckxq?=
 =?utf-8?B?SnVablhEWldhb2JMVmhLSjlWM1RHaTlLaHRXTFFsMngzYXRhbkdBMHhtSGxF?=
 =?utf-8?B?Z1ovYzZGRktYSWsrNXdUelZhdHZ2WGtxNWtrQ0tlcUdvVzY3ekQ1cTRRamRi?=
 =?utf-8?B?enhKamNrZFBtVzlmTGtwa2xqOGdEeC9vaWZ5dUZndlBOZVRlZUpXYXpLWVoz?=
 =?utf-8?Q?5YbtaFb5S28alypozldwtWhUyMwyYH+RgQaGk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVd2UExaRXUwK3ZGZllzM2NhaVc2eG5wQkhkdCtOdGpaRUY3REIvNVI3N3lU?=
 =?utf-8?B?RWVnenFNdFhXOWZJRzRpZE9sWFNtbGdlYlZOWmRKTW1MWVc4OGZkcmxsRDht?=
 =?utf-8?B?Vm1FY0FDVGJWekhrNFgrckpBVHdOM0NXdVdsd2FnbC9ud1U1ZWNnYm1IcFFu?=
 =?utf-8?B?MEE5QWRQMGlLQ2J0S2ZoY1Zya3NQcXdSRVdMSkJCRFBLZjh0aVVpQll6NFNS?=
 =?utf-8?B?cFNBNXNqSEFxUnUyenRPWTg1ekRPNzNxOEdSY1ppWlNTSTVuSjJWL1NRVTZu?=
 =?utf-8?B?VXRvTkNnaHgrbld6MTA1SHRaUll3L0tDUGJMTEVFUHZtRVBUNUdTaTduNFhY?=
 =?utf-8?B?MVZ4NUtocUlGNjlmWHVQNmxLVXlPRmdXdnVRSkkxTUorYlhFVWlvMTh1ZE8y?=
 =?utf-8?B?MmwrTUd3ajRCbUdhZHlJQWJyYlR6MjlTV25EQWo1WVdKWnpKdnF0ZzVwdi9N?=
 =?utf-8?B?OG1rQ2dlUS9LWWtGcVZEWUU1RFU0SW95VjZ1UGNrMDJMRXNPY1p2SjkvNTFS?=
 =?utf-8?B?WlNGR1VOdEhIejUzanRubVdqV1U3YWRFWm0xM3BydkZQRjljWjlibCtFMXlY?=
 =?utf-8?B?Yi9EZWRRUHdCZkMvZ2l1TzlNRkVkaUs1em0rVys4bTU0YjFWZzl0b3UwcUxX?=
 =?utf-8?B?R1RBOVdXQndaTXR4VWM4QlRUZzdSUlJBVUxUbGZCMjhpQnpZNkpqQ1Y3a1Aw?=
 =?utf-8?B?dFRNV3ZDSmRXbDNiTVVFclphSW40L1U2MTZtYmpIVWxDdUdTNStqZ1BqSW9r?=
 =?utf-8?B?OHRLT3YwSHdmS1FuVmtveHJGckpHME1zNE5lOWo3OFhVejdKYnhJOXRyNitV?=
 =?utf-8?B?dHdZREgycWV0TkpjRjU1cCtBVFVpSWVFTm10dzBCejFzT1pqRFgyaDg2NWFk?=
 =?utf-8?B?N0RJVnZ2bWpybkFIcDJOQ0pDdUN1MUdUL29CVVFRNnNrZEdNdStOcGo2ekcw?=
 =?utf-8?B?Wk1BK3h4WkxVNXpUczFHaDN4MjFoNXZ5YlNQMEpKenZ1MzBsTU42SytJby9j?=
 =?utf-8?B?T1pwVHlaU0pxY3VoS1I0NWQwa1Rvb2hLclBoMVpONjRFZVF1U2ZVSENTTzMz?=
 =?utf-8?B?R0lrU2xQbytYWnI1SnRiWC9aN0pwdkMzckNKTkRTcGFBaWdxdVZCamhFSVBN?=
 =?utf-8?B?VkszekFlSFM3Nlh1ZzBoRHA5bEw2T1FFc3pJTW1mWnJBd05YTUc3SnFIYW1w?=
 =?utf-8?B?VnloWDV4cXZQdkZuc2R0VkExV1Nla2tWTmJaaWZXbTVoZCtpTEllM09mT0wz?=
 =?utf-8?B?VkhLQWszOG82bkE4VnFzcXRVWWVSMFRDS1NKNEFBaVpUeHErcGloZVlxS3VZ?=
 =?utf-8?B?bnNLT2FVbkxUckxiY2ZxaG1DMHBrZVcxSGtTVzUvWTd0UVM0TWpuVFZBNyt2?=
 =?utf-8?B?T0dFdXA3V3MxREdkd1hyME8xckZ5YVZkL2Q0QXgybTQzendNV1dzbks2cmxI?=
 =?utf-8?B?cUZSTEtNdEtxWkg0dFhleTlWeUN2TTNWU3g4Rk1jNHFveHFOWUZqRmgxcVFQ?=
 =?utf-8?B?NkFreENZbzhZa1VoQ25BOGtDQVl4YU9XSHhLVHlucmFvcWc5VDVKK1ZDdmFV?=
 =?utf-8?B?VUNuUHErRWVPNGJLUUJ3RlF0VFFVV3BjRDk5T3QwcnpvMW4yVlJ5VHdvb1Y3?=
 =?utf-8?B?alR0d0hSYk83WEwyNCtGbUdZNXV1N0FRcnZrQStRSytteHVpNTNCSXNLRlRm?=
 =?utf-8?B?dDYxN1V2MHVHZkdYREpDK2xWMzI0NGdsaDVRTmVaYnZzVC9iTUJTNHBSSjdM?=
 =?utf-8?B?YWxzaDliZHovbDBtclVEbUZ6WnV5Mk9LZlVWSmdoR29aZi9oYnNCcXdRTkVI?=
 =?utf-8?B?ZVI0UVdTNS9GVEQ3VU9jK1VMcXdPMk53Rys4elVpdVFNc3FRVUdQV0daM3ZC?=
 =?utf-8?B?QkVGditIN29IelcwaHpNRHMyZWFaS0tHdUtXeW55WW0vckg3d2hLL1I5Qjkx?=
 =?utf-8?B?MGc5VEtKaUZXTDRBV2ZwMTJWODJrS0NOM2NxbEtVVHVKUTJ5aGRNSjBQdjNM?=
 =?utf-8?B?bTgwbm9ZUEEwZTYzWE1rSzM4Z3huL1NtZW14MVRlR2psTE45OE5Pd0lIR3Uv?=
 =?utf-8?B?ZERsb1p0REFITk1zQWE3clorbHp4UTFLcEFlSmt1RHBybTdzSVBTb2xQWTZI?=
 =?utf-8?B?eHZRSWtKckpHRTRyWG1XbmIwQmZFVURrczFGZFBSSUlJS2JZNkZUOU1kdWdj?=
 =?utf-8?Q?AHcR8YV6WypGbb96ThKbS3Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <517A83BA0BF4C6488FE65521D5754A99@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd14e206-fa9c-42a2-3a98-08dc86437468
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 16:12:25.3127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4MiZbJPcuNshtKcOYR67QByoCSyNQe5s25AuNYYS71etzf6nN97d/Vzr2t81/bvJVQF9ED7S5dtZYSdAuRVv4VSV28JwMJI/ELtTvVbp/vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTA2IGF0IDE4OjA0ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IFBUOiBQYWdlIHRhYmxlDQo+ID4gU2hhcmVkIFBUOiB2aXNpYmxlIHRvIEtWTSwgYW5kIHRo
ZSBDUFUgdXNlcyBpdCBmb3Igc2hhcmVkIG1hcHBpbmdzLg0KPiA+IFByaXZhdGUvbWlycm9yZWQg
UFQ6IHRoZSBDUFUgdXNlcyBpdCwgYnV0IGl0IGlzIGludmlzaWJsZSB0byBLVk0uwqAgVERYDQo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1vZHVsZSB1cGRh
dGVzIHRoaXMgdGFibGUgdG8gbWFwIHByaXZhdGUgZ3Vlc3QgcGFnZXMuDQo+ID4gTWlycm9yIFBU
OiBJdCBpcyB2aXNpYmxlIHRvIEtWTSwgYnV0IHRoZSBDUFUgZG9lc24ndCB1c2UgaXQuwqAgS1ZN
IHVzZXMgaXQNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0byBwcm9wYWdhdGUgUFQg
Y2hhbmdlIHRvIHRoZSBhY3R1YWwgcHJpdmF0ZSBQVC4NCj4gDQo+IFdoaWNoIG9uZSBpcyB0aGUg
Ik1pcnJvciIgYW5kIHdoaWNoIG9uZSBpcyB0aGUgIk1pcnJvcmVkIiBQVCBpcw0KPiB1bmNvbWZv
cnRhYmx5IGNvbmZ1c2luZy4NCj4gDQo+IEkgaGF0ZSB0byBiaWtlc2hlZCBldmVuIG1vcmUsIGJ1
dCB3aGlsZSBJIGxpa2UgIk1pcnJvciBQVCIgKGEgbG90KSwgSQ0KPiB3b3VsZCBzdGljayB3aXRo
ICJQcml2YXRlIiBvciBwZXJoYXBzICJFeHRlcm5hbCIgZm9yIHRoZSBwYWdlcyBvd25lZA0KPiBi
eSB0aGUgVERYIG1vZHVsZS4NCg0KVGhhbmtzLiBZZXMsIG1pcnJvciBhbmQgbWlycm9yZWQgaXMg
dG9vIGNsb3NlLg0KDQpLYWkgcmFpc2VkIHRoZSBwb2ludCB0aGF0IFREWCdzIHNwZWNpYWwgbmVl
ZCBmb3Igc2VwYXJhdGUsIGRlZGljYXRlZCAicHJpdmF0ZSINClBURXMgaXMgY29uZnVzaW5nIGZy
b20gdGhlIFNFViBhbmQgU1cgcHJvdGVjdGVkIFZNIHBlcnNwZWN0aXZlLCBzbyB3ZSd2ZSB0cmll
ZA0KdG8gcmVtb3ZlIHByaXZhdGUgaW4gdGhhdCBjb250ZXh0LiAiRXh0ZXJuYWwiIHNlZW1zIGxp
a2UgYSBnb29kIG5hbWUuDQoNCltzbmlwXQ0KPiANCj4gPiArc3RhdGljIGlubGluZSB2b2lkIGt2
bV9tbXVfYWxsb2NfbWlycm9yZWRfc3B0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0DQo+
ID4ga3ZtX21tdV9wYWdlICpzcCkNCj4gPiArew0KPiA+ICvCoMKgwqDCoMKgwqAgLyoNCj4gPiAr
wqDCoMKgwqDCoMKgwqAgKiBtaXJyb3JlZF9zcHQgaXMgYWxsb2NhdGVkIGZvciBURFggbW9kdWxl
IHRvIGhvbGQgcHJpdmF0ZSBFUFQNCj4gPiBtYXBwaW5ncywNCj4gPiArwqDCoMKgwqDCoMKgwqAg
KiBURFggbW9kdWxlIHdpbGwgaW5pdGlhbGl6ZSB0aGUgcGFnZSBieSBpdHNlbGYuDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgICogVGhlcmVmb3JlLCBLVk0gZG9lcyBub3QgbmVlZCB0byBpbml0aWFsaXpl
IG9yIGFjY2Vzcw0KPiA+IG1pcnJvcmVkX3NwdC4NCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBLVk0g
b25seSBpbnRlcmFjdHMgd2l0aCBzcC0+c3B0IGZvciBtaXJyb3JlZCBFUFQgb3BlcmF0aW9ucy4N
Cj4gPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiArwqDCoMKgwqDCoMKgIHNwLT5taXJyb3JlZF9z
cHQgPSBrdm1fbW11X21lbW9yeV9jYWNoZV9hbGxvYygmdmNwdS0NCj4gPiA+YXJjaC5tbXVfbWly
cm9yZWRfc3B0X2NhY2hlKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSB2b2lk
IGt2bV9tbXVfYWxsb2NfcHJpdmF0ZV9zcHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QN
Cj4gPiBrdm1fbW11X3BhZ2UgKnNwKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoCAvKg0KPiA+
ICvCoMKgwqDCoMKgwqDCoCAqIHByaXZhdGVfc3B0IGlzIGFsbG9jYXRlZCBmb3IgVERYIG1vZHVs
ZSB0byBob2xkIHByaXZhdGUgRVBUDQo+ID4gbWFwcGluZ3MsDQo+ID4gK8KgwqDCoMKgwqDCoMKg
ICogVERYIG1vZHVsZSB3aWxsIGluaXRpYWxpemUgdGhlIHBhZ2UgYnkgaXRzZWxmLg0KPiA+ICvC
oMKgwqDCoMKgwqDCoCAqIFRoZXJlZm9yZSwgS1ZNIGRvZXMgbm90IG5lZWQgdG8gaW5pdGlhbGl6
ZSBvciBhY2Nlc3MgcHJpdmF0ZV9zcHQuDQo+ID4gK8KgwqDCoMKgwqDCoMKgICogS1ZNIG9ubHkg
aW50ZXJhY3RzIHdpdGggc3AtPnNwdCBmb3IgbWlycm9yZWQgRVBUIG9wZXJhdGlvbnMuDQo+ID4g
K8KgwqDCoMKgwqDCoMKgICovDQo+ID4gK8KgwqDCoMKgwqDCoCBzcC0+bWlycm9yZWRfc3B0ID0g
a3ZtX21tdV9tZW1vcnlfY2FjaGVfYWxsb2MoJnZjcHUtDQo+ID4gPmFyY2gubW11X21pcnJvcmVk
X3NwdF9jYWNoZSk7DQo+ID4gK30NCj4gDQo+IER1cGxpY2F0ZSBmdW5jdGlvbi4NCg0KQXJnaCwg
SSB0aG91Z2h0IEkgZml4ZWQgdGhpcyBiZWZvcmUgc2VuZGluZyBpdCBvdXQuDQoNCj4gDQo+IE5h
bWluZyBhc2lkZSwgbG9va3MgZ29vZC4NCg0KR3JlYXQsIHRoYW5rcyBmb3IgdGhlIHJldmlldyEg
U25pcHBlZCBjb21tZW50cyBhbGwgc291bmQgZ29vZC4NCg==

