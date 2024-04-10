Return-Path: <kvm+bounces-14121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D4189F97B
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49BEE1F25B2F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1FA716F0E9;
	Wed, 10 Apr 2024 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IIxJn1ci"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6AB15F30A;
	Wed, 10 Apr 2024 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712757812; cv=fail; b=tyudBWs1sP0s6zBcMECROVHIDqMtNFbJ+SmTY6JQ+m6kxFAHDvfO4ObK8ijDoPsbGlrjw8W/Fs4S/nhKDqW34YubJC5wggKm+46KasJMSlF4vCEzaB++gsCRfxOhDP82glwTCSmFpvVH3e7rsZEhTHCb+JKJPB0vg+6KoUTyoss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712757812; c=relaxed/simple;
	bh=WIguNCwVxoTGa59z9etF2NhscXaFnVwVPTQeyPBcxR8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cm3aKTUqm9sqvMqz0ip1mk/mOFKk031IMtpBgFjtVvMpffUk6INZX+ipQX2DJW6ERY3d12hu4UAjzysp9FpILKECbtLl24f5W8Cm+g9gbWgZzSkk/wJMNwA9xyvelsL6xcqkeYoMfYHAsJ+eb+qbFBAFCT22WsCDua6WJ5ZyfUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IIxJn1ci; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712757811; x=1744293811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WIguNCwVxoTGa59z9etF2NhscXaFnVwVPTQeyPBcxR8=;
  b=IIxJn1ci2G04J3JNALGCWLioOJR+bHXqXf21pbRUmg0yOz3vGXF43CLD
   mo3jIxUI7+iZGmy7QcIk/WthoBpLvfsdGwEyiof5GMOCkwWqd9ZJbHtd/
   UIbogB0yDhPEOprNj10AFEAHch5o8YLqsffQElwyd79MMGphZIYTYfv1Z
   UUYA9an/iz/8LOFZJoWbOj0i0gZ3pyH1OVV41+Qgf5Wt5NJy44K2lRd9I
   GB6opwNItjvJPY6X3kFWdqxn/BKJYpLgjDpqfZN9zA8RLDOJzxnIc7snl
   +Jfm5qRmjwED39OUrUuzRnDWLGa7JOdnu0zKEkjkZRDc3OiJKJkeVhfeH
   A==;
X-CSE-ConnectionGUID: /4uCr2cRRfC/yZ3DgOQFpw==
X-CSE-MsgGUID: P0BW/Yn/Q/K3p88hFT4XeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="25626623"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25626623"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:03:30 -0700
X-CSE-ConnectionGUID: AgNqkR+zTqy66yzQ4Xk+XQ==
X-CSE-MsgGUID: ht7HmbL6Su6kMaA51aONZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="58011792"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Apr 2024 07:03:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Apr 2024 07:03:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 10 Apr 2024 07:03:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 10 Apr 2024 07:03:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JE/GsUtiVE4rv90MWU1arfX4FvQFYCJmwSvsngK98sewZuWS7mWxEsCoaMQPnb4kB4yNyMnsQllkl8Zqmif5dVfU/N15VXttx3gG3eiLdFnN3F26stZdr12zePak9Q1H+cII3Zp4VanWChlC5uQioNh+z9npjYzH4AQevYejb7sXvdAAhHrlfnEA0nCgEDFJl7BOfCPYLiypDMlkEbthXqB48M317Yh3U4ovBlAfRc+j+uEVZkHoqE0kx3KKPQ/TqA/WAnG663iZ3UXueNMM22CbzameuUMI5J88BDYQ+bkqqxlmTkUzQn7YttWiw9HJI5xi8b454YRjX0Xi5xSz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIguNCwVxoTGa59z9etF2NhscXaFnVwVPTQeyPBcxR8=;
 b=Crml+5PqsrZxO5LD+KG0pQBeREYKhtLU6Uw2kOSI+C3hSar4qW6j7oNcWe3N0H2DGXwHUSPxyjULpMDgXLBgJ3cHiJLFp3oLTgAYFNTQYhAGNcHM+NYv7fGVzwQvVT2mZ8gFTLBA4LWbYazWUxkR/YcE1iQl0ZKw+otsHBsQWLTAODpSZnLHY1yjXxP5Vj2ZkzMaGTCZJt3vkM+8ljZHopXRoeLg6Hju0YjTdUPZOQytXYdnTEKWYngx7tnuSzvtk+v5ArcB7d2NXwE6lo7iLhU7sQ0qf580jPQNYGjWpendB0+rDZUbBBGwxWr1viISoLfYGAnAk3d5rm7k2YrEEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6369.namprd11.prod.outlook.com (2603:10b6:208:3af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Wed, 10 Apr
 2024 14:03:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 10 Apr 2024
 14:03:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"srutherford@google.com" <srutherford@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "Wang,
 Wei W" <wei.w.wang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qR2Nu/69AJukeQby+vmb9H27FcJJkAgAJt44CAABa1gIAAE28AgAH8yACAANdXAA==
Date: Wed, 10 Apr 2024 14:03:26 +0000
Message-ID: <1628a8053e01d84bcc7a480947ca882028dbe5b9.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
	 <20240410011240.GA3039520@ls.amr.corp.intel.com>
In-Reply-To: <20240410011240.GA3039520@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6369:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2N44Ao1HLNWreYg/YAcCSPFrnJUxoZx+ss3DDtZPJT/pHzGwT7rmikFum7zghiM8yYYjs67xwJHbSBOLlxoU5jAAXY3s0oQON9y3eguuB/ghmYCF+E7GOSohzhGURJrOW2hP+MOPb9fh6KCv1EX/QummxgfhcY5DpJi2gkFcveFvcXBfqu4+P4qYyVXWkXLTVXBT296PR0hpwmtXg6B+5ZHMC9oWi/Ms/jYwCcrAwqR046L3Bxef2ucA85dsUhbOeys4lPlsEJ/CxstESYk6vn5BgsBgwOd1msE8n5s13I9v3E0q2jnKXBBm2XuRLn5f5jmzazZdA/0pYGOnU/UI0NRmHvji2otB0onfUxT5CNDLioZzPjhdjEuhlErwC6T3HJqaSRCIOoiuNe8JPWybdCPynNGEZIlQdB0vogugMttyArx+DDXibrj4ZpOagqrrXPL891KZSQiscvjHcdJeGV1xRxwk5kzAGaMd2vayhnnZT1bsYc8Ct6f8czwlQaJzUep6moyln//GgT4m9aFA5RmglMcK6bs+165Y5n13YaYkUCUUgfNJNNzjD2SO1j7LQ2HvLNEoW/M++kND1bfYe/OmZQ8GbOyXZ0lxpWG18Gc7jcd9gdKDumhEksHccszGwZ1p76AZzDSQLANaoYrWxyX3yMNDmxlZ5XbFaCgXhYQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzYzN29SQWIzZjE4YTRLMm1xYWFWV3hUOXcyWXpxQjlXMUxYRFhLeWlZWGZu?=
 =?utf-8?B?T3h5ZnVsOWtRbmZkeDhubWFyVTFYNzhxWTVvaHR4cHQ3NThycXlENHc2VFpE?=
 =?utf-8?B?UkE2WTlkTGh0Y0xRaDJMN2xMaEE1REdRdThyKzdzSnYxV2tXQmFSbTBsZWFU?=
 =?utf-8?B?aE5LQnZoc05UZmE0cjBwdnBRNGF3cEFoRThTUHN6aC9VeXgzb1RVVmFIT2hq?=
 =?utf-8?B?NVhSTUVLRFRmTndBTk9YQ2JBVC9hdzFGTHMwaEhTaDdxa3ByazBaQk1zbXhj?=
 =?utf-8?B?R2ovT01FR20yT0poQUdMUTdUR3F5NWlXSVN2ajdLZ2VQNkJ5TmlxbkNVOGZs?=
 =?utf-8?B?cFdDdVlpaElpU1JveDFNb2ZzaU01WkxuazBZbjRsY2lOMUtCamhaOXRJbUs0?=
 =?utf-8?B?UEVTV2YraVZTRFJuUVJLM1ZQdzBmVXp2ZlhmdkVYVklJeWh0UFRUMVU4dFQr?=
 =?utf-8?B?ZWlaMERHRzdWdWlFb0UzRGtCVUFKSXJhaTJPN2ZJcFVRSmpiTGNZWHN2cldu?=
 =?utf-8?B?emdQMzlYM0JUN05iWGhZb2lZTm11am5TNXdVOVVuUks4NEdGOVJUQzAxaU8y?=
 =?utf-8?B?c1Zlc3ZOdEUrbVdIdkc3QzhLYmxKRVk0dEYwMG84aHh2dnZnVHdqYmtwZzdu?=
 =?utf-8?B?Mk92WklLRXZob3pTMlgvRGJNZFdYdWdFMmVEWjNCYlhYc0NTdUxUa2VybWUw?=
 =?utf-8?B?eXRyejJ5RkgzVXJNaEZoQ1JCMVBhRUlGMWJXbk04ckxoQ29WT2x5dndxclJm?=
 =?utf-8?B?ZzhkRTM4S1JCbmhkQU1BYWRxRlFrbUhTZ1VEeFMyR25WYUNuc1cyQ1ZGNldB?=
 =?utf-8?B?ajJXQXMyNjlCREN3SlZHZmNMalJzc3E5VDZxRzM5R0V2UXl2V1FhRFd2KzMx?=
 =?utf-8?B?MEJtRFg5R1ZDZXFNcGthaVBUUkNrMTNLdTQwdHdHZFJHYXVFSmlxVjAvaVNz?=
 =?utf-8?B?NjdvSlBVaEEycXpRWFJlcXVXWFRQQzRqNVlhSUgyQUpKcnBaU2gxd3N0Sncx?=
 =?utf-8?B?NTZYcmxTWU1VRG5oSng2Q2hTaXdFZVAxeklBMXg4MjNPbVVUSUdQQ20wZ0ls?=
 =?utf-8?B?bTUxY0h4TjJhRDVpV1ByOFdYRXBkeFdUU3pzbDZOanhPenZBZU5iR2xrQTZq?=
 =?utf-8?B?dGV1NXRLMmhOQVdXYXlySWFpL0ZJQy9mODJXbnRXMWtnaWlucm9zb0ZPTFNE?=
 =?utf-8?B?dXMyRHJTZEhzLytGMElUaXRwdVNaeUg2V212a0lBMFdHZEZzd0tBR0hSRHRv?=
 =?utf-8?B?Rmo1eVR5MmFNNDZrS0p1OVhnOFpxUU43cjdpNDNNRGphSG4vUkhKeWZqR2M5?=
 =?utf-8?B?NEJGOHNIRGNCaHZXLyswVmpxZXVweWU4dDFDZ1hlZFR3VVdvQmdydU5BTTVJ?=
 =?utf-8?B?YmEreHpCdHpLVVA2UXRwR2YwY3dMZ2p3MWJEdjViMjVSZ2h5dHJkZmRaV1Fn?=
 =?utf-8?B?cXhiWUNDT1R5MmtraXFyS1RlVW5kWEFLVmFuU2ZPRkU2TzBpT1Rhd0RXNTkr?=
 =?utf-8?B?ZTBWcnd6S1EvVHlpWlpEVjBtTUwybWFPZURlZjhZZzkvL2xrZmtxTzNIbFNQ?=
 =?utf-8?B?WkZRdDVGaTFvclhjNW5yWWd4OGYyQW8vWUszWkJDZGtVcm51MDFiQ0VuWTlV?=
 =?utf-8?B?TUo2QTJ3alNhcVlyRXordWlLQlBLQjRieXB2WlZmcDNObW5BSDhpeEFmM1Vk?=
 =?utf-8?B?Wk1nMU5KN3ZkNFFaVzI3bUZOVHBsV2l0SDhWNmduSUdqbUlNVElkYmZVZlRY?=
 =?utf-8?B?TUZoRUFzSXFjcVpnc2thZU5VeU9Ubm93UkJIUGpKOUxkNDNqZitVcXBaYWVO?=
 =?utf-8?B?UzZ4ZWJQb2hnZENMZHNkMjNsbG1xWnZhMWQ4Y3VGYTBRbk5tcGE3ZHh5UnBu?=
 =?utf-8?B?TWhCY3c2K1poRWFhMlVodmNSbnMvUjdYUUFLRFlzcTk2cmFFMkpjL092ejhu?=
 =?utf-8?B?MCtJUThtZVZoTVBLVDBFamhlNlMwS21TR0tmZDdOU2lESml6REVBVzBkRXBt?=
 =?utf-8?B?TW9tdk9tNFNtMXI2cXNRb0c3dXY5TFhaemZMWm9kV3czUE5DZGk5WklRUlIx?=
 =?utf-8?B?Tk9kcTAwcTR6VUlibTQwNTQvMXhkd2JEeldpWUlaTGJ1UkxldXlHZ29rVWJJ?=
 =?utf-8?B?RDJvME1oUHhYTzltbGtmSkJjUmczWUZmTVVXcUt4QjZWOUJZa2VadlBIcnFO?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55DD8A4B668041449CE78A60B290A412@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396c339f-0c8e-48ca-961b-08dc5966fe28
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2024 14:03:26.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ad/Q6iRKjRSzbaX09Ym9LPiDMUSLzyuRcsOcFKR/I3QeJgtZN6R/othZe3MRHPlBL7o9WJLIOXk/KxaBdi5KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6369
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTA5IGF0IDE4OjEyIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBBcHIgMDgsIDIwMjQgYXQgMDY6NTE6NDBQTSArMDAwMCwNCj4gU2VhbiBDaHJp
c3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBNb24sIEFw
ciAwOCwgMjAyNCwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gPiBPbiBNb24sIDIwMjQt
MDQtMDggYXQgMDk6MjAgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+
ID4gQW5vdGhlciBvcHRpb24gaXMgdGhhdCwgS1ZNIGRvZXNuJ3QgYWxsb3cgdXNlcnNwYWNlIHRv
IGNvbmZpZ3VyZQ0KPiA+ID4gPiA+IENQVUlEKDB4ODAwMF8wMDA4KS5FQVhbNzowXS4gSW5zdGVh
ZCwgaXQgcHJvdmlkZXMgYSBncGF3IGZpZWxkIGluIHN0cnVjdA0KPiA+ID4gPiA+IGt2bV90ZHhf
aW5pdF92bSBmb3IgdXNlcnNwYWNlIHRvIGNvbmZpZ3VyZSBkaXJlY3RseS4NCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBXaGF0IGRvIHlvdSBwcmVmZXI/DQo+ID4gPiA+IA0KPiA+ID4gPiBIbW0sIG5l
aXRoZXIuwqAgSSB0aGluayB0aGUgYmVzdCBhcHByb2FjaCBpcyB0byBidWlsZCBvbiBHZXJkJ3Mg
c2VyaWVzIHRvIGhhdmUgS1ZNDQo+ID4gPiA+IHNlbGVjdCA0LWxldmVsIHZzLiA1LWxldmVsIGJh
c2VkIG9uIHRoZSBlbnVtZXJhdGVkIGd1ZXN0Lk1BWFBIWUFERFIsIG5vdCBvbg0KPiA+ID4gPiBo
b3N0Lk1BWFBIWUFERFIuDQo+ID4gPiANCj4gPiA+IFNvIHRoZW4gR1BBVyB3b3VsZCBiZSBjb2Rl
ZCB0byBiYXNpY2FsbHkgYmVzdCBmaXQgdGhlIHN1cHBvcnRlZCBndWVzdC5NQVhQSFlBRERSIHdp
dGhpbiBLVk0uIFFFTVUNCj4gPiA+IGNvdWxkIGxvb2sgYXQgdGhlIHN1cHBvcnRlZCBndWVzdC5N
QVhQSFlBRERSIGFuZCB1c2UgbWF0Y2hpbmcgbG9naWMgdG8gZGV0ZXJtaW5lIEdQQVcuDQo+ID4g
DQo+ID4gT2ZmIHRvcGljLCBhbnkgY2hhbmNlIEkgY2FuIGJyaWJlL2NvbnZpbmNlIHlvdSB0byB3
cmFwIHlvdXIgZW1haWwgcmVwbGllcyBjbG9zZXINCj4gPiB0byA4MCBjaGFycywgbm90IDEwMD8g
IFllYWgsIGNoZWNrcGF0aCBubyBsb25nZXIgY29tcGxhaW5zIHdoZW4gY29kZSBleGNlZWRzIDgw
DQo+ID4gY2hhcnMsIGJ1dCBteSBicmFpbiBpcyBzbyB3ZWxsIHRyYWluZWQgZm9yIDgwIHRoYXQg
aXQgYWN0dWFsbHkgc2xvd3MgbWUgZG93biBhDQo+ID4gYml0IHdoZW4gcmVhZGluZyBtYWlscyB0
aGF0IGFyZSB3cmFwcGVkIGF0IDEwMCBjaGFycy4NCj4gPiANCj4gPiA+IE9yIGFyZSB5b3Ugc3Vn
Z2VzdGluZyB0aGF0IEtWTSBzaG91bGQgbG9vayBhdCB0aGUgdmFsdWUgb2YgQ1BVSUQoMFg4MDAw
XzAwMDgpLmVheFsyMzoxNl0gcGFzc2VkIGZyb20NCj4gPiA+IHVzZXJzcGFjZT8NCj4gPiANCj4g
PiBUaGlzLiAgTm90ZSwgbXkgcHNldWRvLXBhdGNoIGluY29ycmVjdGx5IGxvb2tlZCBhdCBiaXRz
IDE1OjgsIHRoYXQgd2FzIGp1c3QgbWUNCj4gPiB0cnlpbmcgdG8gZ28gb2ZmIG1lbW9yeS4NCj4g
PiANCj4gPiA+IEknbSBub3QgZm9sbG93aW5nIHRoZSBjb2RlIGV4YW1wbGVzIGludm9sdmluZyBz
dHJ1Y3Qga3ZtX3ZjcHUuIFNpbmNlIFREWA0KPiA+ID4gY29uZmlndXJlcyB0aGVzZSBhdCBhIFZN
IGxldmVsLCB0aGVyZSBpc24ndCBhIHZjcHUuDQo+ID4gDQo+ID4gQWgsIEkgdGFrZSBpdCBHUEFX
IGlzIGEgVk0tc2NvcGUga25vYj8gIEkgZm9yZ2V0IHdoZXJlIHdlIGVuZGVkIHVwIHdpdGggdGhl
IG9yZGVyaW5nDQo+ID4gb2YgVERYIGNvbW1hbmRzIHZzLiBjcmVhdGluZyB2Q1BVcy4gIERvZXMg
S1ZNIGFsbG93IGNyZWF0aW5nIHZDUFUgc3RydWN0dXJlcyBpbg0KPiA+IGFkdmFuY2Ugb2YgdGhl
IFREWCBJTklUIGNhbGw/ICBJZiBzbywgdGhlIGxlYXN0IGF3ZnVsIHNvbHV0aW9uIG1pZ2h0IGJl
IHRvIHVzZQ0KPiA+IHZDUFUwJ3MgQ1BVSUQuDQo+IA0KPiBUaGUgY3VycmVudCBvcmRlciBpcywg
S1ZNIHZtIGNyZWF0aW9uIChLVk1fQ1JFQVRFX1ZNKSwNCj4gS1ZNIHZjcHUgY3JlYXRpb24oS1ZN
X0NSRUFURV9WQ1BVKSwgVERYIFZNIGluaXRpYWxpemF0aW9uIChLVk1fVERYX0lOSVRfVk0pLg0K
PiBhbmQgVERYIFZDUFUgaW5pdGlhbGl6YXRpb24oS1ZNX1REWF9JTklUX1ZDUFUpLg0KPiBXZSBj
YW4gY2FsbCBLVk1fU0VUX0NQVUlEMiBiZWZvcmUgS1ZNX1REWF9JTklUX1ZNLiAgV2UgY2FuIHJl
bW92ZSBjcHVpZCBwYXJ0DQo+IGZyb20gc3RydWN0IGt2bV90ZHhfaW5pdF92bSBieSB2Y3B1MCBj
cHVpZC4NCg0KV2hhdCdzIHRoZSByZWFzb24gdG8gY2FsbCBLVk1fVERYX0lOSVRfVk0gYWZ0ZXIg
S1ZNX0NSRUFURV9WQ1BVPw0KDQpJIGd1ZXNzIEkgaGF2ZSBiZWVuIGF3YXkgZm9yIHRoaXMgZm9y
IHRvbyBsb25nIHRpbWUsIGJ1dCBJIGhhZCBiZWxpZXZlZA0KS1ZNX1REWF9JTklUX1ZNIGlzIGNh
bGxlZCBiZWZvcmUgY3JlYXRpbmcgYW55IHZjcHUsIHdoaWNoIHR1cm5zIG91dCB0byBiZSB3cm9u
Zy4NCg0KSSBhbSBub3QgYWdhaW5zdCB0byBtYWtlIEtWTV9URFhfSU5JVF9WTSBtdXN0IGJlIGNh
bGxlZCBhZnRlciBjcmVhdGluZyAoYXQgbGVhc3QNCm9uZT8pIHZjcHUgaWYgdGhlcmUncyBnb29k
IHJlYXNvbiwgYnV0IGl0IHNlZW1zIGlmIHRoZSBwdXJwb3NlIGlzIGp1c3QgdG8gcGFzcw0KQ1BV
SUQoMHg4MDAwXzAwMDgpLkVBWFsyMzoxNl0gdG8gS1ZNIHNvIEtWTSBjYW4gZGV0ZXJtaW5lIEdQ
QVcgZm9yIFREWCBndWVzdCwNCnRoZW4gd2UgY2FuIGFsc28gbWFrZSBLVk1fVERYX0lOSVRfVk0g
dG8gcGFzcyB0aGF0Lg0KDQpLVk0ganVzdCBuZWVkIHRvIG1hbnVhbGx5IGhhbmRsZSBDUFVJRCgw
eDgwMDBfMDAwOCkgaW4gS1ZNX1REWF9JTklUX1ZNLCBidXQNCnRoYXQncyB0aGUgdGhpbmcgS1ZN
IG5lZWRzIHRvIGRvIGFueXdheSBldmVuIGlmIHdlIHVzZSB2Y3B1MCdzIENQVUlELg0KDQpBbSBJ
IG1pc3NpbmcgYW55dGhpbmc/DQoNCg==

