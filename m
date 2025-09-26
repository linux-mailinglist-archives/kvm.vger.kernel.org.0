Return-Path: <kvm+bounces-58895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF396BA4EFA
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 863EC3B8518
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 19:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6153730DEC1;
	Fri, 26 Sep 2025 19:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UPEciyqM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27BC221FC8;
	Fri, 26 Sep 2025 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758913237; cv=fail; b=SpOjYoIrPvLJy8FKWWX40/q1CTpvwLzCqXwqhL4yzEtYoollWaQhx+L8RGfHvlKCelEl25RisGs/AtBj4DfHhLQiNnsAXh9umhT8Q4dnn2cRLmxzhyWsGRhFZT0573f/Hv69lqmR8AvuV654G4tWE7G9bKvvtXnoHYi/+ox3VBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758913237; c=relaxed/simple;
	bh=DL2KzL45ikqB8pH+/sunu4Xyrv/YQuS+rZFFKLZ+e04=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fCCNWzGYtrulU7fRpZ6hwzyc2ZpUtO+jqoyq7vzfkcvr+g9WlaeJtiQaGropnSaa5qidffVAQKbHsa7Fzuh/cGN6/uKP++BhCde3aPmwU5ZHLjxU529QubuZySKhUDWzFl7fnNp157MPA8SKsvXPo7VEFVs9/qJWjF55rmB/CgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UPEciyqM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758913236; x=1790449236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DL2KzL45ikqB8pH+/sunu4Xyrv/YQuS+rZFFKLZ+e04=;
  b=UPEciyqMlX3wRdsx0IoXlQ6YwqMozkzy8zucg50fEAdK7f3x8a749vBf
   G10cG7QvBjHKBn6dVVSQVoc/GoMYDy1XWOfDVrXKE41d7MEUKtuAg5aAr
   lnbq4l+9MuukAnIDzbZMLNeJclvTWKejFvWiOyFGiJpRFHv41i2gQS52g
   6gBECZqDCUbqCkv4eTYlLxu4KI6degKsvhwGcnrFXotg24WgCk+TSKqt5
   joOt1kFYz+TpYtrrFRWVmlATOeRFBCJ5A33FthNFnMh5IyKt5NrTZYXbn
   ojf5SsvHJyKCNnuEntwS6wB92PK7WQ2orjlc6NLPjBXQKB8HZemsScTdj
   g==;
X-CSE-ConnectionGUID: k0igPIvMTtu7nNeO2mEl0A==
X-CSE-MsgGUID: aOXuSXK+RL2VQLTafCX9Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="86696093"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="86696093"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 12:00:35 -0700
X-CSE-ConnectionGUID: eIkmE1enRACLcRITZ7ScWw==
X-CSE-MsgGUID: QhUDBsWRTLSZImFKlc9I4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="182964473"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 12:00:35 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 12:00:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 12:00:34 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 12:00:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lGCiAD5XMXE1poO/a/+2MrQg7dD4J+8AD7l27e86Hm2D2z4vQtrWDLcEikc5TJSaDHIsG29M8c6DMuAR4FW5a6/kJA8j4bvmsVP1totcOdMHh8adeUuVxRu/j0uTLJm6JlUdD0djCfW/eJHz49kUSQs8JTSTW2wwljVUk5ovmW3OElqwQSBk6vQMsETnRM+VG0lWLwaFBPKXzns6PE3g3PoRsKw2eyewBzODz4E9MSvM+vQYxxHcgB6VT9qOIogIjn6i0L3AX5QmgiG8LxeecpC8g346aQ+asfOc0dRr/wdxEGgfRTtH84CEoknSLi/X2WurUlXF50ixCCgiPZFsPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DL2KzL45ikqB8pH+/sunu4Xyrv/YQuS+rZFFKLZ+e04=;
 b=lhTsz9kvwkuU2TWRwjcsVPsCh4mb1YYEswxNKv9QSBxvld77ZTrduoaty8ICQN02U2zh0EHo5QqzXzFb0mrdD9KKMh9BUjT33kXvagYowx6c97PfcJRWgHlkZ+I5odSSHcJ0npaQAx/M2GGH6kAOaZV1OKtx1WqytCk+moIEE2KylHtTiyvhr5Cc2kRoXalI1o8Itsel8KcBeN+yz6JmXArGQXOsM3HHCl5lyUlQZz9JFB0GIxzr5obwqsyYK/4m9XB/VS0O/jp7VaGjy1QRVn8k9L0yX/CcAzo8oGW2DQ3MdLL6+5J0b4PIvXcpmnKxA4VGsp3dTjQx7/UHTIbF3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Fri, 26 Sep
 2025 19:00:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 19:00:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Index: AQHcKPMxbI3n4d0yEEyHrd2rA1fcBLSkyKKAgADDrQCAAB+VAIAAAsIAgAAvCAA=
Date: Fri, 26 Sep 2025 19:00:31 +0000
Message-ID: <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
	 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
	 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
	 <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
In-Reply-To: <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5144:EE_
x-ms-office365-filtering-correlation-id: 397ae3dc-f359-42a0-5833-08ddfd2ef74d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UXp5eU5FMkhzVG1rVnFyL3BncGNBK0s3clZhZWNVazVDcHRvUi9LQ1ZUUDEw?=
 =?utf-8?B?UjBudUVFTGcraGpGamNrSlBGQXBlL25BRzhZb1VneE1qTWZaN2s0NkxMM1RJ?=
 =?utf-8?B?QjEyMFRRcGROb1lteHM4TEE2dk1uNXZuRDlnMTFiUk5JbThsTmhVUzR6NVdK?=
 =?utf-8?B?cXUzVWlNRXplUVc3YVlqTmNzZDV3bEdhYkF2a2JscW5xNmNuSWE0MWg3T1dn?=
 =?utf-8?B?bythVVhFcnAwRkUvUnFsazRTRGIwSEVha1ROOWhHa256Zm0welBHK1N5cjNw?=
 =?utf-8?B?bnQ1TUpUQlFoOFFQM3FCZEZleFpxeS9FdXg1YkdtSEQxUTJRQk5rTXFndmRh?=
 =?utf-8?B?UzI5OUs0eS9GaklwRE04QnBnMXd6dUMwbytDaDQ3TmZSQkxBdjhidEZTSlVT?=
 =?utf-8?B?bENFUWtpakRKRnZFUmwya3BiRDk0c0lSeWVQZFdDY3JkR1EyYk0rYVlNRWNP?=
 =?utf-8?B?dUtoc21DbldBUFZwZXZwSnRqNE85N1FldGlPY1dqVVkyRitRRHNvMnRVZ05j?=
 =?utf-8?B?dlhoL01uamRjTHdUeG0zQTYzdklqd0hNc0U5Uk0vMFdydjhhakZUMUlrblVB?=
 =?utf-8?B?Q1VPWVd0MUNhSFJaRFV6ZVlGVVJTM0x5VXJodEpQd0YyeEJYbUxnSlNEVU9D?=
 =?utf-8?B?Vm9ISEY5Q1l3WnJDVkZCdGpzOHlyTFJDb2w3TEtIelNPd2VoL3hTRXBQcnVn?=
 =?utf-8?B?aU5jaHJtSjNsTEhsWHFHT3IwR3IvK3d1WGxkeW5HMjByQUx5VHJvK1BjTmhk?=
 =?utf-8?B?YXQxWnlkemh5OWNwbDZRcjVxcy9Jd2tUeW5jc3pMbzYxRUFFNTVJM0d6cEJY?=
 =?utf-8?B?b3BVRWlmVDl1VEFESnlja0dIWVVoc0h4Ry81KzlPdmYvOVNRMXdIcWRDN1c2?=
 =?utf-8?B?dUU3bXlvdVN0aWIwcCt4azU2djNuK0VKOVFVa3pTQlR0aW9UMUtOdEdwdmw5?=
 =?utf-8?B?NGIwdmZtQWpBWTh4MTgvL05odDRyMjhlaU5WYVUrVmpvZzJITU1aYVlrVlpo?=
 =?utf-8?B?Y0xIenlvak16NE5EKzRWUXUrY2JBeFlRdzJvT2pFMjlXTG1ITzN5TGlDbTFj?=
 =?utf-8?B?ZU1mV0c4c0t6UmhBY3N2U0dtUmllK3c3TEtBTDNTTHdOUFQreGJON1Iza3JM?=
 =?utf-8?B?ODZCZmREcG5sUWxXdGRRYjB0K016ekk0RzVtTWMxZzBxUW0wOGlVdk5OS0E0?=
 =?utf-8?B?bEhWV1hFTHVITGNHWE0rOGFrcDN4dmZmd2t3cmpab2xVYVdZL2hoYXBjTDlR?=
 =?utf-8?B?N1Z1N2tYY2NKTkMrUkVJeXJlWmFxK20zSFlGWUNFd0RGMlJ2SmEvbHpLM1ZL?=
 =?utf-8?B?Zi9VUHRLb2RxMTJPQ0lYNm5qbGdXa2UxM1NXNlhZTU1PS2xxdnNpSnZOcnJI?=
 =?utf-8?B?U1NuczFOWU9rSVZtRFVZQ2ZpdmU0TDM5blZHdEdBc3VlcVMyV21SUnAza1Fk?=
 =?utf-8?B?ZVI4MUFxV01LNDhwaTA4WW0yeGVJenRodkh1NVJWWXJpLys4M2RMbDNVMlRz?=
 =?utf-8?B?N25VTytlWkE0NWNlVFJuWU9XNGFCYzErMTFyK1FJVHp3cjRKeHZaYmZjWWtH?=
 =?utf-8?B?ZXB3OXRVZHFxZDRZNllHL3VsaUVZVEpWOEx6Q2F5VStPdEc2aG1OWHhSZ2pO?=
 =?utf-8?B?NjlMUElvZEdXM1JuMHF3c0VBaTVwemg4NStPVEtRU1VyNzBQcGxjaEZqd25V?=
 =?utf-8?B?S0p5L05sczFtQUp2N3pNcTlTS2QvamJDT3V0TC96cExLQXFwV1gyVnhCNFhm?=
 =?utf-8?B?aWRodGppV2VzZ0RraDdBNzkxaGxVRG9OUmNWYThnS29XQS9jcnpvRDdTbHJT?=
 =?utf-8?B?aWUydytNVEpuOWJhZHQ4T2czV2RnTWYvWU5qQUFEd1pjdFh0VTg2Qkg4aDY5?=
 =?utf-8?B?Vy9OM1hrb3ordlcyUEpSbGYwZVJISkJvNGRuM1N1bEoxTldzTTR4OTNJMHJl?=
 =?utf-8?B?T1pxbmhkY1JjTld6SFJOZEIwZHFFMHUyN1kvTXdGbmIrU1lOVVh1S2JJR0VV?=
 =?utf-8?B?QlJTV05DR2gwWUxBNjlJOFNOcURkKzZGbHAwbkpGZkdMaTJPbUNDMGpjbnIr?=
 =?utf-8?Q?kaxnsC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm1senUvSFNsK0tDZ2FNVStLQktaQWkzMmFjcERvT2owQ2pNeDg5Y29tMDB1?=
 =?utf-8?B?ZmQxeTRFYW12Y1h3Snd3U2VVSDVISkFvVjBSbXN4RlFrY2JpM1lLYjZ4NlQz?=
 =?utf-8?B?WUUySmJ6SVRKeU9WK1owQVJWZlFxYlhrZHlGZUl3SzVrRGtiT3k4U3dZT2to?=
 =?utf-8?B?ZTVaU2hBbTdEeUE2Y1U0RkFMUmE0dTNWajlpZFhHc01NZTd3OU0wbzh3ZU9T?=
 =?utf-8?B?WnpqRE9lMXlWQXZzLzF4R0E1TU5uWWxiVDY5MDAxdi9ydWNUMkhkdVFvWk0x?=
 =?utf-8?B?QTN3bmdrNjZJUmNRSkZLcjZmQlhZMWM4M1YxUUVRTnZkM3VhNEtKNVJLeEJT?=
 =?utf-8?B?cUdmMEN0OHdIODR0b01JRW5uSnNYUlN1ekRTTTZldVl3Q3JCeEVIQW1vYTNq?=
 =?utf-8?B?alp0S1dyUzcxL0wvM2IxZmpNWFh2N1B2bCtzV3oxSHAvNlJnby9XeGNUcC93?=
 =?utf-8?B?cWtvVnZScUc1a2QxS3NkZUhSZ0tNb3ZCYkY3ZUxXTjVINW1yRGZZdHRld0xw?=
 =?utf-8?B?UytmM1N3MUNHZXJqT2dzQmVsSWxPNzVBNEZRQ2NMWFE3Vk9FWms3MHM0SUUw?=
 =?utf-8?B?T2FhVXpUNHVZUVhadXJESFZPM3phTTRoQks5WnltNERVL3lxT0JJdHhnTHB6?=
 =?utf-8?B?ajFTYmxKdmlXcjloZEZNV3ZhWjZlOXZKWE4ycE4xbm5sNjI1Z0dqaXJWa1hJ?=
 =?utf-8?B?bXlYZUlQT0ZCWUxSanllZitwVVZWMXB3cEl3bFJRQjlZSEU1WUJhVHR0VXpk?=
 =?utf-8?B?S3BNTzlZcjVraW1aOGdrclZUalF6MVlmeTQ5WlRjS25nV0J6c1pMZHdLdGp5?=
 =?utf-8?B?cUxGc2JnVk1ReG5zTGNIZVRWdlRRM1NzOHV0dHVtam1GZDlXTjhlT3J2WkNJ?=
 =?utf-8?B?RTd5SWlGbi9uS0kzODBPcG5wS3haR3FMcmh0VjVFKzJjaWE2U3E3WUZ4ZzQr?=
 =?utf-8?B?NFQrT0xRSHU0N2hIcEVjK1dOaGJhd2l2d3RVeDk0TUpIcldpcktEcVpGMk5U?=
 =?utf-8?B?SGRKazJjTlJldDdxK2Q3S2pIUXQ0NllrNGxLRE5od1h3dUJCT0VXSFVzYnkr?=
 =?utf-8?B?UXplWUNKSFhlN1d0RHM5NFJ2WWVoeFhsNWlsS2gwdlM2R2xSWFErR2d0dHVj?=
 =?utf-8?B?NENFRkNWUXdIa29kUndYcnZSaWZYMXljZm4wZnMrOWpobUd5WENDNFpZVVcz?=
 =?utf-8?B?R3J4dlhLZEhPdUpsSDBTTnF4OWVjeGZ6c2lGY2Fjd1c2M0NaeG9kWkk2M0c0?=
 =?utf-8?B?bWx4Z3ZMUFhlQWQ2QWoyaDFkL0N0TmdwUVZ3YXhnMjRtaDhydmVRS01iUTNT?=
 =?utf-8?B?TlYrU0ZhVEY5RGFMT1JHa044NVhvT2tQcXZPcmlhckh0T0xCQnpkbTg4RHMz?=
 =?utf-8?B?NzZQS2FuNUEyd2RkRzlVU1FickFYWmc3L0dpdHRya2V2RTJzRnhobTNsYk83?=
 =?utf-8?B?UnM5b2dUUWhjRUlYblowOEZjREhUdGxzRUdrSWQxSHFaUWVlL0Z1S1dhK0RE?=
 =?utf-8?B?V3dhWXFyZCttQUpxenNBT2J4MWdLT1VLNmUvUURibUdmSGRPMFRZTTlkQ3JR?=
 =?utf-8?B?UW1GditGUkFkZkJBS2ZTTllkNHlML3ErbFRUSUdHSmQxQVpKOE9EUlNLY0ps?=
 =?utf-8?B?Zm5JOHgyQ0FEL0puMUg1NHJQNkJ0Q0UxWm1sODE2RGJWZlc3akdpb1dNSTlp?=
 =?utf-8?B?YmtHNUo2OG02bCtnMXF2ZDhNb2tPUU5LaUt1ZGFpRExCZ25rUEN4SGNCamtq?=
 =?utf-8?B?K3dueXJrUGVkT1VkU09DZWpnMmFnZjUwT21VdlFVeWk3eTE4Ny9xaThOSEdj?=
 =?utf-8?B?OFdDK0EwS01uczI1Y1pJU3dTbVF4QWZlSTVOTFJBOVNDZVA0RkNpRkY2V3dl?=
 =?utf-8?B?aHFqRnhtWWoybnZWdVplZmdLOUZSbXhTV2pKTDFlQnhrL0pEaUVqaHRVYlYy?=
 =?utf-8?B?OHRDRkhoMGtpM0xMZVlqa0JIb3dPM2N0TlRqZG53Z25DTmRXV2dBbk0vZnRp?=
 =?utf-8?B?Vk1lQUFRd25VcFBKZkNYb2g4ZnVTMlllNWlDK2RlOHpTMFNaRFRUSnFsd2Vq?=
 =?utf-8?B?RjVRWW5Vazg5WTc3TGkyVGxHT1VPcHE2WjFyMEdYT21FY0VmbUZhTGtvNEo2?=
 =?utf-8?B?R2VmV1lmVG16ajlNM0x3YkF2Q3BySXJYSWdXay85MXBhTE1Lb044MzFrS2Vy?=
 =?utf-8?Q?X7E/vo+5SrVI90XepK4RjGg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <419B3D8A00CB0A4FB0D720CF3FDD5077@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397ae3dc-f359-42a0-5833-08ddfd2ef74d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 19:00:31.5642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdTLavTdhPLVtr6nwXxagCgYuCrQnWjrQA2o5TeRh0zJX0sYMXeWXOZY3jk0pxNV/pYxeOWvq5KSlWedq66yHPUoC+9aH31nrmzq4TZYZmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5144
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDA5OjExIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SWYgaXQgY2FuJ3QgcmV0dXJuIGZhaWx1cmUgdGhlbiB0aGUgX29ubHlfIG90aGVyIG9wdGlvbiBp
cyB0byBzcGluLg0KPiBSaWdodD8NCg0KWWVhLCBidXQgeW91IGNvdWxkIHNwaW4gYXJvdW5kIHRo
ZSBTRUFNQ0FMTCBvciB5b3UgY291bGQgc3BpbiBvbg0KZHVwbGljYXRlIGxvY2tzIG9uIHRoZSBr
ZXJuZWwgc2lkZSBiZWZvcmUgbWFraW5nIHRoZSBTRUFNQ0FMTC4gT3IgcHV0DQptb3JlIGdlbmVy
YWxseSwgeW91IGNvdWxkIHByZXZlbnQgY29udGVudGlvbiBiZWZvcmUgeW91IG1ha2UgdGhlDQpT
RUFDTUFMTC4gS1ZNIGRvZXMgdGhpcyBhbHNvIGJ5IGtpY2tpbmcgdkNQVXMgb3V0IG9mIHRoZSBU
RFggbW9kdWxlIHZpYQ0KSVBJIGluIG90aGVyIGNhc2VzLg0KDQo+IA0KPiBJIHVuZGVyc3RhbmQg
dGhlIHJlbHVjdGFuY2UgdG8gaGF2ZSBzdWNoIGEgbmFzdHkgc3BpbiBsb29wLiBCdXQgb3RoZXIN
Cj4gdGhhbiByZXdvcmtpbmcgdGhlIEtWTSBjb2RlIHRvIGRvIHRoZSByZXRyaWVzIGF0IGEgaGln
aGVyIGxldmVsLA0KDQpSZS13b3JraW5nIEtWTSBjb2RlIHdvdWxkIGJlIHRvdWdoLCBhbHRob3Vn
aCB0ZWFjaGluZyBLVk0gdG8gZmFpbCB6YXANCmNhbGxzIGhhcyBjb21lIHVwIGJlZm9yZSBmb3Ig
VERYL2dtZW0gaW50ZXJhY3Rpb25zLiBJdCB3YXMgbG9va2VkIGF0DQphbmQgZGVjaWRlZCB0byBi
ZSB0b28gY29tcGxleC4gTm93IEkgZ3Vlc3MgdGhlIGJlbmVmaXQgc2lkZSBvZiB0aGUNCmVxdWF0
aW9uIGNoYW5nZXMgYSBsaXR0bGUgYml0LCBidXQgZG9pbmcgaXQgb25seSBmb3IgVERYIG1pZ2h0
IHN0aWxsIGJlDQphIGJyaWRnZSB0byBmYXIuDQoNClVubGVzcyBhbnlvbmUgaXMgaG9sZGluZyBv
bnRvIGFub3RoZXIgdXNhZ2UgdGhhdCBtaWdodCB3YW50IHRoaXM/DQoNCj4gIGlzIHRoZXJlIGFu
b3RoZXIgb3B0aW9uPw0KDQpJIGRvbid0IHNlZSB3aHkgd2UgY2FuJ3QganVzdCBkdXBsaWNhdGUg
dGhlIGxvY2tpbmcgaW4gYSBtb3JlIG1hdGNoaW5nDQp3YXkgb24gdGhlIGtlcm5lbCBzaWRlLiBC
ZWZvcmUgdGhlIHBsYW4gdG8gc29tZWRheSBkcm9wIHRoZSBnbG9iYWwgbG9jaw0KaWYgbmVlZGVk
LCB3YXMgdG8gc3dpdGNoIHRvIDJNQiBncmFudWxhciBsb2NrcyB0byBtYXRjaCB0aGUgVERYDQpt
b2R1bGUncyBleGNsdXNpdmUgbG9jayBpbnRlcm5hbCBiZWhhdmlvci4NCg0KV2hhdCBZYW4gaXMg
YmFzaWNhbGx5IHBvaW50aW5nIG91dCBpcyB0aGF0IHRoZXJlIGFyZSBzaGFyZWQgbG9ja3MgdGhh
dA0KYXJlIGFsc28gdGFrZW4gb24gZGlmZmVyZW50IHJhbmdlcyB0aGF0IGNvdWxkIHBvc3NpYmx5
IGNvbnRlbmQgd2l0aCB0aGUNCmV4Y2x1c2l2ZSBvbmUgdGhhdCB3ZSBhcmUgZHVwbGljYXRpbmcg
b24gdGhlIGtlcm5lbCBzaWRlLg0KDQpTbyB0aGUgcHJvYmxlbSBpcyBub3QgZnVuZGFtZW50YWwg
dG8gdGhlIGFwcHJvYWNoIEkgdGhpbmsuIFdlIGp1c3QgdG9vaw0KYSBzaG9ydGN1dCBieSBpZ25v
cmluZyB0aGUgc2hhcmVkIGxvY2tzLiBGb3IgbGluZS1vZi1zaWdodCB0byBhIHBhdGggdG8NCnJl
bW92ZSB0aGUgZ2xvYmFsIGxvY2sgc29tZWRheSwgSSB0aGluayB3ZSBjb3VsZCBtYWtlIHRoZSAy
TUIgZ3JhbnVsYXINCmxvY2tzIGJlIHJlYWRlci93cml0ZXIgdG8gbWF0Y2ggdGhlIFREWCBtb2R1
bGUuIFRoZW4gYXJvdW5kIHRoZQ0KU0VBTUNBTExzIHRoYXQgdGFrZSB0aGVzZSBsb2Nrcywgd2Ug
Y291bGQgdGFrZSB0aGVtIG9uIHRoZSBrZXJuZWwgc2lkZQ0KaW4gdGhlIHJpZ2h0IG9yZGVyIGZv
ciB3aGljaGV2ZXIgU0VBTUNBTEwgd2UgYXJlIG1ha2luZy4NCg0KQW5kIHRoYXQgd291bGQgb25s
eSBiZSB0aGUgcGxhbiBpZiB3ZSB3YW50ZWQgdG8gaW1wcm92ZSBzY2FsYWJpbGl0eQ0Kc29tZWRh
eSB3aXRob3V0IGNoYW5naW5nIHRoZSBURFggbW9kdWxlLg0KDQo=

