Return-Path: <kvm+bounces-27396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BC1984F8E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 02:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D17551F243EB
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 00:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA47D520;
	Wed, 25 Sep 2024 00:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AOCotumr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA7679F0;
	Wed, 25 Sep 2024 00:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225117; cv=fail; b=LUnqOKYrcaqaQMcRjm40qSqbMhP2oSQNVkAUQf0NL4SmydWKbwtAxEAvUpGyu4MpdHYeIDwqDK0dZwQZHZX1x+58nXda4fWA2ad+4YpmX8Zgo3hA7wvJ5rdrIyHo2oqX9u30Sr9WZYdlYzyEaGafDdx2M66YHtRiomICCjj7A/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225117; c=relaxed/simple;
	bh=fJf4pkmTw8+IRq6ll2Km7jxErnRh8BSGwlbSeTzpLXc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IwU4dlOqu4Vo5kOELKXefHIchrTKldeDDqt5Kjl4NDv/aonJ6ImT3tYeWBUMpfv36FepwtPzXI6JWN9H3xCynfjjf0+dO30yXsyMJWSsPbm1OmUMx3qPgU8JhwuEOh799XhV3Kx0PPzsSKGdEl8I8CJtVh7tybHi33kEMXnMDfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AOCotumr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727225116; x=1758761116;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fJf4pkmTw8+IRq6ll2Km7jxErnRh8BSGwlbSeTzpLXc=;
  b=AOCotumrDfObu3Kh76Tv35oE3z3K9Js0JTtFAdrjIoar3rh4Xhpb2cQg
   kVRBGRG18EpWkS5pXjwG/s0zoHB6+QMNbyNJ4/f9AjP6+ojtAX1KjnnsA
   pS53z/QqCwSSenrBf1+Vmq4XTdRD5sXNNOMzOR1WR99z8jzxqjgbluiKk
   KPn5QRGx1zyTGs/DxFZdz75UlTenhLT3aMUhj1ClEMFI00ktxHx5u6uNz
   mY/ui+6U7DA97gRdI/4h9scEOPaysey0x9YLyadbDtfOsjUw1WcBOiZkN
   enJqOK8qaGYWo7ukP8jEOxO1aiAAhqop9Wb76tEdYzTTR0G+iOaMzk8Jc
   A==;
X-CSE-ConnectionGUID: hyGSK1X0R7qZ3AaH53Q1bg==
X-CSE-MsgGUID: THSyBNA/S/mcGZfNrwquxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11205"; a="26398315"
X-IronPort-AV: E=Sophos;i="6.10,256,1719903600"; 
   d="scan'208";a="26398315"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 17:45:11 -0700
X-CSE-ConnectionGUID: K4X3baMZT1Cs7610uhub/w==
X-CSE-MsgGUID: Tachdb9PRUKdjLdBcIRdVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,256,1719903600"; 
   d="scan'208";a="76526297"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2024 17:45:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 24 Sep 2024 17:45:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 24 Sep 2024 17:45:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 24 Sep 2024 17:45:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ln3L4STUk2BHxaaXQhsTMcPHqGTnd0yuUUZpu28Q1BsAERaUupMAUaBAMYe4UVXCyXV/tn0GzH4PAcsF4n45ww3viHYfurTfVs6v1R4j9h/O21SoB8fqOwoYUjRIwt42XLns5Ibs6NAie1PwwXJcxi8ZI4f7piFpLe/8bmM7x2sqA/HFNduFkxKLyhATpKbxuwaaf9gLNdNhkuEnMz3UgCg0mQYkQ+KFXLIWMtK3GtPqFKcAHMUU01HwsrandDK5cZP8THIwCs+9JdWIoqyxljiJP3NRGQ9nmo1M16HV/DEzIRDW0mLc3CI/cKAOB34UdabdMZZiTC5dvYK/0NZZag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okPYpAi+HrVe1rDJbtRx56bj20mL4/UcsOnKt9cPMbA=;
 b=Sdsii2ALIoj4bfpDOpAWS8S7+YUH1RDBmciK8kLcPLx7fwbSg2/jwpZdWKguhdtpBgl5Hrhz4wJkTife/ATTCxzCY1EyvsyRsAompkcTn4eQiql06pBlGNE9rW4j/5nTRxk7YoOa9Vpmbhzapm6tfbrSgUsMQDExjUpsburbmi7HsIUNGnfldL+si6X5N5GeedZeFmWxmJlHFg8wShhDeVEaa45z4WlvzEoRttX3yMpAZIm3reGnxRo8JhA2fAapH3Jqiyf9Xal4lQtfSO0u7IuojwxCXBqI9F8AXsKBiccbRBdstIkhouUz6RrD5JQSaUt2CCsN2S1d6rYeOPPe1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7722.namprd11.prod.outlook.com (2603:10b6:610:122::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.26; Wed, 25 Sep
 2024 00:45:03 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 00:45:03 +0000
Date: Wed, 25 Sep 2024 08:42:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Aishwarya TCV <aishwarya.tcv@arm.com>
CC: <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <dmatlack@google.com>, <sagis@google.com>,
	<erdemaktas@google.com>, <graf@amazon.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<seanjc@google.com>, Mark Brown <broonie@kernel.org>, Naresh Kamboju
	<naresh.kamboju@linaro.org>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Allow slot modification stress
 test with quirk disabled
Message-ID: <ZvNckKjlieCN56th@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
 <20240703021206.13923-1-yan.y.zhao@intel.com>
 <b9367e1c-f339-46e1-8c44-d20f112a857a@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9367e1c-f339-46e1-8c44-d20f112a857a@arm.com>
X-ClientProxiedBy: SG2PR06CA0231.apcprd06.prod.outlook.com
 (2603:1096:4:ac::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c12ef5-fe6e-451c-57e9-08dcdcfb4adc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MFdTS0RjL1lEV0prM1RUOTc0bk80MjVTcHlZZG5MZTVISWxrNGtYRkpmajBh?=
 =?utf-8?B?Q0NhazJVWVB1cm9LUEJldnNZVW1pZG9NTlBaVlBzVGdYbWRrZXY1OTVyMEYw?=
 =?utf-8?B?NFE0T0pYSXpZVURwSzBCVUpXR2w1VXZKeFZIRjcyVFA0THl3SGRmU0ZUazB3?=
 =?utf-8?B?UDhXM0sxUVoxWmRrK2tvQU56UStyZkVZdnpqRTI4SVowYWNiZ0VHTld0SDZm?=
 =?utf-8?B?WCt0bUF5aHhUZEd6ZVdkNXZXenc1QU8yK0hlYVJ4dEQrbUVYOXB1ZnhFbEJv?=
 =?utf-8?B?bXRlczIyOVJZRzdaRkpCVUpxZVhmcTI1MFdtbEcyRlRtczVQcjlZZzFzZ0ts?=
 =?utf-8?B?UitvanpkZ0tkb0xnY2ZVa2kwdmlzQXk1RXMyVmo5Vm5QcmpVRGtBZUM0SWJm?=
 =?utf-8?B?eDdMS1BaUHJ3RXR3cEYzeW0zNnZTR0dRS29VS2d0NU85RHhLY1NUNFBCbmIr?=
 =?utf-8?B?Ynk5Y3ZVelBveWpranNpOUtHRklROVJlOEVQSnUvSnhMcHowRDIvQjlleWda?=
 =?utf-8?B?MVNPc0p2Z1UxdXliT2ZJdXVwek0zcENqQ2ZCWS9nQXJoWEVzWktRYmk3cTJ0?=
 =?utf-8?B?Z3EvRVU1eWIyMkxsdjNqejFqdTNleXN3eDZBZm5HVFRlbG9pdXZLSitOR24r?=
 =?utf-8?B?TWM3a3R1azRRUFNucWtHN3h3T1I4Z2xlbTV3aEUxNEs1RytoWTU5a1NMQXI4?=
 =?utf-8?B?YnlqVTg0cGtRWVZBWGJORisxYkZDUmw5VUhyQ21vNWFlY1NJa2tGaWo4T1dZ?=
 =?utf-8?B?U3hZUVRKb3d3Sk5uRWdEQ3AzRlhuUlN1b0dBb0gvWkR6WjhFSk5wL09kbVlr?=
 =?utf-8?B?eW45eDlWa0NWREs5Qk1uV3hwamhzZlkyVElOZDBzbXNxRWNZb1pjVHcvczJK?=
 =?utf-8?B?OG16aFFxS29zK2JQcjkzeHpsWXV2NkpsVTJadGV1a0Y5QnZOYW9QVTdNZUtE?=
 =?utf-8?B?TlhQMXR3VVZzbXV1RGR2RUZ2T01aMkV1YkVZYmFoOVdYYzQ2eFJMZlVwcnJH?=
 =?utf-8?B?K1U1TzhsTFZwbW9pSFZuWG9XejhxSWhzakFZYm5zeG9hMGl0UlJoRVNRb0ZC?=
 =?utf-8?B?UlVrSE5EY3FCVjhyS3RDOGRrVXlFNWU2VlZRNis2aHA3TSswak5XVkNFdSto?=
 =?utf-8?B?T3NkaC90OWdGaWx5SW5ScmZNK25wRXpBVEdkaDlNUWpSSStBbGp5ZDVQVEJv?=
 =?utf-8?B?S0RLSThZUGcxYmpyZ3J0YkJxWE9Za3JPZ3NTNUZOcnlxY2VCVzJ0d0cwRk9z?=
 =?utf-8?B?SmZ4bnJrS1N1VDBVK2pwMWl4ZTNEeWQvSlo3TkVVL1RmUXUzNFNqTWFBTTgy?=
 =?utf-8?B?MVoyZEV1Q05zbEJGdDNxT0YyOVRqUEd5bFI3cmJVcWlVZlRha2taSnJzTGpu?=
 =?utf-8?B?QVFyMXU1SVp3alNNZ0x4ckI2UW1YdytVOEdxK3RQRGwyMjR6SGo2OFdSWWFn?=
 =?utf-8?B?YlFaWitrVzFJcWNNanhiOTE5LzNtNDNyZzhUYWZ6N2tiYUQrbWR3U0lZNUNh?=
 =?utf-8?B?ZE1TajNkQnpudFNiQlVvbW82VWwycXJjODdiVklPWVN2NWRCL2FMYWtzNmlQ?=
 =?utf-8?B?RmhFU0R4VnJTNDNMblh0UUZ3NEF2S25tVVlsTTRPcUNobmYrbEhjcXZGWWRp?=
 =?utf-8?B?QjFIWG9NazRWU2pmU2FkTTAzenBFR21wQkFvVmkvK1FFZ3BjaEo2YUZVNURJ?=
 =?utf-8?B?YStYU0U2YVJNM1B5akpHK090ckcrOHc2TjdPWk90TDNCV3dUYUpSRHcyYkg3?=
 =?utf-8?Q?3vysYjy+LhhH+79CKo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzJNVEU0YktMY2RESzJjbzIrM0pkd1FWdjIwVXJpaGR6RnBENjhZY00zYmZt?=
 =?utf-8?B?QlJDc3ZxL0Z0eDdoWnNGd09SN2RRbHkrRFRCNnAvaHowTU9CeXBveG1pYWZu?=
 =?utf-8?B?WVZtWGEveFpJVVdIdGRDc1FTV1QrZ2MxY1Vva1kwL0ZtVU82WGkzTzR3TjI3?=
 =?utf-8?B?cVZBMU95ME00OVZSd3BxY1gzS3haRldpZHZUOHJaazFTYThXSU10TS91RVpN?=
 =?utf-8?B?QldIa25SZFU1eWlCSFVWekUzVUdtNGtkc3F1K1YrYmtUWW8xTW5qUWRjZ0pL?=
 =?utf-8?B?QnlVWVdjL0FpM3JkcVdEenVUVVNFZ2JMckJ3dDBxOUdBa0xlcEpVOUZtMnI4?=
 =?utf-8?B?N0pCdlkrb0F2ZVAzaHFwL0Y1enlRL05IK25HSXQ3RnNnTWlqUDVpYk5HZ0d0?=
 =?utf-8?B?Y1c5Z3RMT1MxUFdwNnU3MFRtaTJjM2w3dHp3MVVKd0Q2am5FU0IrYVk0TUFV?=
 =?utf-8?B?NkxqUTIwdWpVVVYvZkVuNjZhMUtUb1BUbGxWZVNsWXdWY3UwZVJGV3lSYkRw?=
 =?utf-8?B?V2FZRk5mdzRpK1Zzd05iV09WOGtzNzl3b0RXS1pmbXdmNG96aVZmVjYzdXMr?=
 =?utf-8?B?V2F0TXAvclhhNkJPWG0zWndHUlIxcmthbHdId1hvNWlmbXF6U3psN0hsekVI?=
 =?utf-8?B?YnM3aENCSW1TcmRpQ1VyNkpramFCM2dMem5FN2EzSjNDSWZvWmVhM0RYNVlI?=
 =?utf-8?B?Unl5b0NHTThGc082SmNjRG5nREU2ZEtNTGpHbUk0UzNwaHhUZTFjMWZwc3py?=
 =?utf-8?B?SFNHMXBNSnA2d0FJMkZMVk5pS3l0Z0hRblkrcjNpK0U5Rjl5ZUdKek1XSGNV?=
 =?utf-8?B?ZE52amFTd2xUZm9naGlQUzA4a1QvUDJoZWI0QlNjSk9CNGlRbFBqbGxYREVI?=
 =?utf-8?B?cTFGcnNpenh3cHZ5akZCN0RPME9Xazlod1F6VzVRMHJ0VS90U0pocnEvT056?=
 =?utf-8?B?eWFENnhzVnZQRjB2WW82Z282SmZ0MWRCZ2lCWFZsU0RMRTNOQWtXbnh4NUxC?=
 =?utf-8?B?N2Q4dzFQY0VHRnZpNjRqWDVrWFY3QmVIL1NONExxWFlac3ZXZTMxMmFsaTNj?=
 =?utf-8?B?NFRjN3owWmxva2tybW5Pbkk5RnZoMmdxZWtMWWZmUDUwQTI3ZUlNTnVQZGh0?=
 =?utf-8?B?SUo4ckk3Z3UvWnY0eEtyWXhXQXNJY1lhWm0wSWF2Mk5ZbDIrWXJRSHhZVDN3?=
 =?utf-8?B?RHM1eXJNbDNPc2NsS250TFczQ09hejBSTnVqUmtuM3orQmZxM0dqVlVUZDEv?=
 =?utf-8?B?TnllTGhtOG9xUi9uaUpRTWhxSzNhYU95SWFUTU4rR0xUUUMzYUd5NEpsUW1w?=
 =?utf-8?B?bVpySVBnbTJYMzN1akVWQjhNRjYzclowVXF0dloveWdxTkdyTVhNWG0xL2NO?=
 =?utf-8?B?NjFXYXI2MTBXNzV1eWZkcVAwRndPNkQwc2VYOGRBV0R1L3JUSDE4c0FJdUtC?=
 =?utf-8?B?MDkyZEUwRjVjRjMxRG81MlkzeDZaQjE5WXBYZHkzdXJ0SWtuTlRObWhZbTBW?=
 =?utf-8?B?V0pIZStvc3JQejFJeXpjdHUvbTJPampKcGNXQmtWMlBlS2JoSHhSc3ZUbXJa?=
 =?utf-8?B?dmVDQk8zOVJJcE9adzdhbXZCeWRVUFFxbmlacUZrZ0pWOXBuN1FRUUkzaklw?=
 =?utf-8?B?aTlmTUYwOU43c1kwRGp1Zms0aGhFbEliZSs2dFJtVVlFbTNaazZ0eUs2aVgz?=
 =?utf-8?B?RlNpWjI5alIrYmRjRlVkYVcwZlZHV0t2MUt3QVJuQ04rSzRUNTNaOEZVVW51?=
 =?utf-8?B?bjFWL3dYNitNL1dIWmZSMDJiQ1BwZXU2eDZlbFdnUThORkxBV3NsTTRIR21l?=
 =?utf-8?B?RFJJb0c4NDczSElUNER2bnBGdHEvSFJKd1pET0tLY0tHRjladmVuaGcxb0Rp?=
 =?utf-8?B?OXlweUF3bjNCdFEvNGcydk9mZHJzR1p3YWdid0VSWUFrdzFnZU40MjFFVnpj?=
 =?utf-8?B?dmRJSDQzNnc0ZlJTYmx6N3d4R3QwUCt1cEFiQ2tyT1R0NFBzZWFENDhtWHF3?=
 =?utf-8?B?SzBWeHNnM0Z5ekdTQmpvVS9wMDlLUTBzbzFRTDJQdVlsZzI0NThOUmhxOUQr?=
 =?utf-8?B?b0ZIdWZENGRvSWNiK0ErdDFaalQrYzdsTS9wOFhtRjdQbEc3WjNhVi9pbmZo?=
 =?utf-8?Q?141hTv1pS+2bMnN0VFb4QcPML?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c12ef5-fe6e-451c-57e9-08dcdcfb4adc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 00:45:03.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PjhsebvyrnFNLzYMCFSk9ueaAmqlEtq4+8j63ljf/jQX4DIy+STPdu5P1Yt6U1epGe+4lFqMoatdOlESGBvceg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7722
X-OriginatorOrg: intel.com

On Tue, Sep 24, 2024 at 01:26:20PM +0100, Aishwarya TCV wrote:
> 
> 
> On 03/07/2024 03:12, Yan Zhao wrote:
> > Add a new user option to memslot_modification_stress_test to allow testing
> > with slot zap quirk KVM_X86_QUIRK_SLOT_ZAP_ALL disabled.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  .../kvm/memslot_modification_stress_test.c    | 19 +++++++++++++++++--
> Hi Yan,
> 
> When building kselftest-kvm config against next-20240924 kernel with
> Arm64 an error "'KVM_X86_QUIRK_SLOT_ZAP_ALL' undeclared" is observed.
Ah, I forgot to hide  
  "TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
                       KVM_X86_QUIRK_SLOT_ZAP_ALL)"
inside "#ifdef __x86_64__" when parsing opts though it's done in run_test().

> 
> A bisect identified 218f6415004a881d116e254eeb837358aced55ab as the
> first bad commit. Bisected it on the tag "next-20240923" at repo
> "https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git".
> Reverting the change seems to fix it.
> 
> This works fine on Linux version 6.11
> 
> Failure log
> ------------
> https://storage.kernelci.org/next/master/next-20240924/arm64/defconfig+kselftest/gcc-12/logs/kselftest.log
> 
> In file included from include/kvm_util.h:8,
>                  from include/memstress.h:13,
>                  from memslot_modification_stress_test.c:21:
> memslot_modification_stress_test.c: In function ‘main’:
> memslot_modification_stress_test.c:176:38: error:
> ‘KVM_X86_QUIRK_SLOT_ZAP_ALL’ undeclared (first use in this function)
>   176 |                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
>       |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> include/test_util.h:41:15: note: in definition of macro ‘__TEST_REQUIRE’
>    41 |         if (!(f))                                               \
>       |               ^
> memslot_modification_stress_test.c:175:25: note: in expansion of macro
> ‘TEST_REQUIRE’
>   175 |
> TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
>       |                         ^~~~~~~~~~~~
> memslot_modification_stress_test.c:176:38: note: each undeclared
> identifier is reported only once for each function it appears in
>   176 |                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
>       |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> include/test_util.h:41:15: note: in definition of macro ‘__TEST_REQUIRE’
>    41 |         if (!(f))                                               \
>       |               ^
> memslot_modification_stress_test.c:175:25: note: in expansion of macro
> ‘TEST_REQUIRE’
>   175 |
> TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
>       |                         ^~~~~~~~~~~~
> At top level:
> cc1: note: unrecognized command-line option
> ‘-Wno-gnu-variable-sized-type-not-at-end’ may have been intended to
> silence earlier diagnostics
> make[4]: *** [Makefile:300:
> /tmp/kci/linux/build/kselftest/kvm/memslot_modification_stress_test.o]
> Error 1
> make[4]: Leaving directory '/tmp/kci/linux/tools/testing/selftests/kvm'
> 
> 
> Bisect log:
> ----------
> 
> git bisect start
> # good: [98f7e32f20d28ec452afb208f9cffc08448a2652] Linux 6.11
> git bisect good 98f7e32f20d28ec452afb208f9cffc08448a2652
> # bad: [ef545bc03a65438cabe87beb1b9a15b0ffcb6ace] Add linux-next
> specific files for 20240923
> git bisect bad ef545bc03a65438cabe87beb1b9a15b0ffcb6ace
> # good: [176000734ee2978121fde22a954eb1eabb204329] Merge tag
> 'ata-6.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/libata/linux
> git bisect good 176000734ee2978121fde22a954eb1eabb204329
> # good: [f55bf3fb11d7fe32a37b8d625744d22891c02e5e] Merge branch
> 'at91-next' of git://git.kernel.org/pub/scm/linux/kernel/git/at91/linux.git
> git bisect good f55bf3fb11d7fe32a37b8d625744d22891c02e5e
> # good: [1340ff0aa9e6dcb9c8ac5f86472eb78ba524b14a] Merge branch
> 'for-next' of git://git.kernel.dk/linux-block.git
> git bisect good 1340ff0aa9e6dcb9c8ac5f86472eb78ba524b14a
> # bad: [51d98f15885e036a06fef35c396c987e80c47a27] Merge branch
> 'char-misc-next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> git bisect bad 51d98f15885e036a06fef35c396c987e80c47a27
> # bad: [4f216a17ef0dc3bf99c28902abbc6c70fb7798a0] Merge branch
> 'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> git bisect bad 4f216a17ef0dc3bf99c28902abbc6c70fb7798a0
> # bad: [b11ba58b0ef5c932303dac5ce96e17d96c127870] Merge branch 'next' of
> git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> git bisect bad b11ba58b0ef5c932303dac5ce96e17d96c127870
> # good: [b7ba28772e5709196e3efffb9341c7fd698b2497] Merge branch
> 'for-next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace.git
> git bisect good b7ba28772e5709196e3efffb9341c7fd698b2497
> # bad: [c345344e8317176944be33f46e18812c0343dc63] Merge tag
> 'kvm-x86-selftests-6.12' of https://github.com/kvm-x86/linux into HEAD
> git bisect bad c345344e8317176944be33f46e18812c0343dc63
> # bad: [7056c4e2a13a61f4e8a9e8ce27cd499f27e0e63b] Merge tag
> 'kvm-x86-generic-6.12' of https://github.com/kvm-x86/linux into HEAD
> git bisect bad 7056c4e2a13a61f4e8a9e8ce27cd499f27e0e63b
> # bad: [590b09b1d88e18ae57f89930a6f7b89795d2e9f3] KVM: x86: Register
> "emergency disable" callbacks when virt is enabled
> git bisect bad 590b09b1d88e18ae57f89930a6f7b89795d2e9f3
> # bad: [70c0194337d38dd29533e63e3cb07620f8c5eae1] KVM: Rename symbols
> related to enabling virtualization hardware
> git bisect bad 70c0194337d38dd29533e63e3cb07620f8c5eae1
> # bad: [218f6415004a881d116e254eeb837358aced55ab] KVM: selftests: Allow
> slot modification stress test with quirk disabled
> git bisect bad 218f6415004a881d116e254eeb837358aced55ab
> # good: [b4ed2c67d275b85b2ab07d54f88bebd5998d61d8] KVM: selftests: Test
> slot move/delete with slot zap quirk enabled/disabled
> git bisect good b4ed2c67d275b85b2ab07d54f88bebd5998d61d8
> # first bad commit: [218f6415004a881d116e254eeb837358aced55ab] KVM:
> selftests: Allow slot modification stress test with quirk disabled
> 
> Thanks,
> Aishwarya
> 

