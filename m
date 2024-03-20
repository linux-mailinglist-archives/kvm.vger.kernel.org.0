Return-Path: <kvm+bounces-12328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED4F8818E1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C30C1F218D9
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D08185C45;
	Wed, 20 Mar 2024 21:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmQV/4Gn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E6EDB;
	Wed, 20 Mar 2024 21:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710968447; cv=fail; b=dtFDN+Q7L/cKPixBolyBpNV2P7XRHIGhhglgLHZWJ20hGk+1yWb5h7DH7HB5bACViPkyYS9twr+dTTqoUo7hOz2mnivkJwvwQgoXXO7DcsBTpwzmKJR19eIxljAQ+ai0SDxJJLRBiwa1IFvVygX1DFK+hA8tmZ6+NvTQmbBj1QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710968447; c=relaxed/simple;
	bh=uHpzS+fLg3+viI5dIjKIGmGqVirSb8h1b3le54N3t6k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=unGGwgP5Owa9olAXUOEkzNsYF8sKMQe0k+xR+JOKwzjY5QPLXinbrxw9rCcTlE4IC9ZCgzZyJ1sfDX35K4smJM1h0bfOy5aFQTsUNLtX3zijuVapSKxMQWJsDME+HHR6hthg4JGOLKdJaR9JiqT1yZvvHfSVU6NkRNKENNdKjes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmQV/4Gn; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710968446; x=1742504446;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uHpzS+fLg3+viI5dIjKIGmGqVirSb8h1b3le54N3t6k=;
  b=WmQV/4Gn4CSX/daKoItUpbqNJ5I67UG0NW7vToyGZfMAGjl+nmxPM58I
   oeZCcHmQ1bkCpRISQGgf0f50mc1B997B3bkeFsS6UmihLB697+TePraG0
   7GzqWLHZ8HuB9SecuY+2156DtR5n+sMzx+rm2f71lps8WuTJJJpL8XjIu
   IaNeFcIU8jaAJAU+NIHakexYMTr0HlNZ9biEnsX5gWx8c9Rqwg2wdNcY9
   uk9xXn9YsphW25mglyeISupsWXuxTgvHluOP6bzlNrZ5k0vunJ+GvuaQJ
   XBQ2653W01M8JpMR8nFNXXSOBexMTbjbsmV1jzGyJVeUXNiXvWkCXhx2W
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6133077"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6133077"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 14:00:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14360687"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 14:00:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 14:00:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 14:00:44 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 14:00:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6bmPzGYux1L9/VqfXEu7HlSTBce2IZ6RCuCd1gQ+h87o0Wx/Whk/rq/h0sVD2EYtVdPChNvqoaxwMxG+dRTynruTJYIYvhgxn2PFrHHilMP/G16jrWNqs7Km0S21Akx3i6+8C1Gq/gumKLM/3v/RzkDsT3YAM2ZKdjC2U4Hu33x4J2k1g7CsGuN7uOWo1Mtw8yyUomwJGQBCgSjQjg1Aov7CDny6t6HpPFqBqZoJp3q+IWVXjFJlH/MWtQmF8XjHEeojbIElo6Lw+MwLBmvy9auM42tzZ5EA8mzoPuoYkHnEQd98On653vtrL6tNfLDkpi+artxopBy6vAKdBP+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pk4RxMaRIsqLnncBxUxwFvjE2ZpbLAmMVvGn0bbELYE=;
 b=CDgmQbMdo/jlidL72vsQ0/1cQj+sJMNcw6/ShbR58TCVzfNhWA5dKHrgYkeGwnpa2kxG7qn9MVvenG4Vrxti4/JAsTOcSrSfePoeXdjx6RqR8SOq6Qaw2ym3QcDa1SC9NiTZaCmCl9UjTe2yIyLhE3WmowYCdfQ8BRMVnvel44Ot410j6PFStVdJPIr8ZzSCpFcjpUGWi+Te7QeqkOfXRUs//fvRKuINf4C9HxF6C63fyWhOKBmEP8u5Q247EdosWDt+4jrjwLEaaFKdtaAZ9RETgCtYhLvGRzZ1IUTLbz411vUb8ksTwjhF2vdvIoB7W/ln7ZPsQfkw9Pv1dh0o1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB7094.namprd11.prod.outlook.com (2603:10b6:510:216::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 21:00:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 21:00:39 +0000
Message-ID: <cc3a968d-c581-4784-b69b-b887d3b90a94@intel.com>
Date: Thu, 21 Mar 2024 10:00:24 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com>
 <ea85f773-b5ef-4cf6-b2bd-2c0e7973a090@intel.com>
 <ZfSjvwdJqFJhxjth@google.com>
 <8d79db2af4e0629ad5dea6d8276fc5cda86a890a.camel@intel.com>
 <70d7a20a-72dc-4ded-a35f-684de44eb6e6@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <70d7a20a-72dc-4ded-a35f-684de44eb6e6@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:303:b7::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB7094:EE_
X-MS-Office365-Filtering-Correlation-Id: afac53b2-6428-481e-d1f1-08dc4920cc3b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: urKsSF+NUr+A/iWYSNoofub9ZxavyXvnIqvAzK332KfMDFMVJWRLF7gFxek/BfX/ECvE/8F78Ow/O06ul78D7F7cR0QXR/1bAUde157dLTK+teqShO9Okb3yC4HUZcseD/2InzWVSMYZMWGVYYodKtQlHw0+b0kaCOdqSZ9OZxuKSAUTxCMD9teSgyjqzGJ6JiZ8fbK/GP26xuf5oLJoD+Lq2qYpgj/PqQZKYGaZE5yLGcgPv+dScG9kLRMoTcTA0b5G8S27I3o4XFfoXvGqelSL5kkulp/YIDK8DhQWycYHcQj4xfek/SYj4MsGeABTVRneSC51d8hZRzousH3vxyVaxgEd1IbfDpDSEuEZc27U3OOuWh5Rb90hosNAPdU+/KADV2rJfWDJnnH7s5G5pXOr3XloZ2aw0E/BW/dEIErOq4NPfv4EzDWG4q788Z5g68uG3InMLNJRG76UPWLw/BAsjqTG8L0zE6Yv9904ImLRliVbXdj5q+K+wZ6N2iWCyAqOV2s+y4BwT9V90J1oONJjjaLreWiCBWO+BooYAN21/r768dCMn1E0FtjXk99sY5bPoNEF9xkvFyNeD2aPHV5qdvXZQo7HXqdwNfuykgQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2FuSVVCT1o0WnUrQ3h4SklOQ1hzVGZsTUdCTWU3UFM0Uk5JT3FpRWc5YmNW?=
 =?utf-8?B?N2RMZE1DdDNhem8rS013bEJNWDZuRUU4Z3prQnBtb3RlWkJXNzhIMjJnVFZt?=
 =?utf-8?B?bmNidmN5VkFxY2UvckdJWCsrWTEvbXRaL1E5SE5NK2tnUytSOHZaTVpZRUFx?=
 =?utf-8?B?ek9LTEtyZHY2ZkZKTFBGbmZvN25ld1h4cWRHVFNadEFiSGlGSDJNZWhpK3l3?=
 =?utf-8?B?NWhDWjMxU2t2c01XTnZ2Wkx6UGpQVmNvWUNDcGVCdWI5NEREL01qdkc1V1Bu?=
 =?utf-8?B?QmhkeDAxalpqQXpXNWYzNWFwUXBpMXJ6QkxsUkl1dGt3bmtCS3lxNFUvY3lw?=
 =?utf-8?B?RWIra2ZrNmJTSVRvYjdYb0NZeGo4a1ptNHpabng4b01HMDVzNXc1N0ZaZVpE?=
 =?utf-8?B?aU04bFBSZ05XNHl2cmFLU0E0aDc0Z0I2Yk1qTGo4Y01ZZVZsN3JyZFZ2V3dR?=
 =?utf-8?B?cmd0U0NBMitKUGJlTldyclpqaDRsVGVXT1hYc3oxOVVRQUUzOGFHNEF5VkhC?=
 =?utf-8?B?Y0NFb0lzcVNKTDFFUjdFUHhxM0xVdXNqU1dvaEM5Z0lJQUU2MnhHbWxKUzd3?=
 =?utf-8?B?bVVySFNBdjVTSWtTM1V5bE5RbmZLQnBySnFnc1hBQ1VsWjhxdENFNnFyNzlJ?=
 =?utf-8?B?Qms2STA1N24rT0RqNTlsWVhySmExcGZUYkp2bXlGem1raFJWOE1BOXFINVlD?=
 =?utf-8?B?TUk3R1NxamoyczBwZkNDS2t4VDgzdHZIMjF2ajdoay9OY1NoeDA4V3NiZUxY?=
 =?utf-8?B?TmZPdldhOHNNT1RwSjI5Tks0Q0FwYWJrWU5EZUxNV0UvaURkakRka2lKajd1?=
 =?utf-8?B?ajU3WWRmaWJuNEw4cTd6TkVhOElwVFQ3L3ZPdEsvRXVXMHRBZ3pKVkp1Um5t?=
 =?utf-8?B?Slg3ckFUR2FCajQvVUlxY0g2Qkl1MU9aUWI5UGdUeXpBNXZmQ0N2aHVVcjly?=
 =?utf-8?B?RFJHbTFUT1Z4dThXclJPeUkwOG42ZnN3cld2WXZGZTlEWUI3V1dMeTd3Z29x?=
 =?utf-8?B?RThZdmQzTEtUdFl4U045N2FFdWxhbU0velNwK1BSY0hXdEh0NUpISFdnb3JP?=
 =?utf-8?B?RHhqRDk2US9Fd3pCYU5na2tTeisrWEZCKzVDZk1rR1lyNEYxaGNRVVk1aGtq?=
 =?utf-8?B?RHF6YlkzSy9WV0hFMEVCdm50NEtiaHJIQy9CdHVjKzRiaDU0QlFzWnM4SnFt?=
 =?utf-8?B?MVFUdUVJTDhxOGk1QnpBblpRU3FoZ0FOVU5sSHJmeFBBcWdiazlYSXUxM1NM?=
 =?utf-8?B?UnV1bktpV2ovb3QzTzI2c212TE1nNnE1SVJTcVRVNGYxZzRlNHNCY202blpu?=
 =?utf-8?B?OGNuNVVYNkZwbHFwOVRYY2JIdmw3VnljMW1NVVJDT2FqbWIvRUlMVFlzb0pR?=
 =?utf-8?B?MkJqZmZKREZUU0hZN1lwNjBNaEdnSWJObWxra25RcTEvK1Avbms2NDVEeVFD?=
 =?utf-8?B?SGtObjRyZ00yR2hjMUpVWC9aRmUvZnNMU2xnckp1QnA4WExZMWhUZnZvS3Rq?=
 =?utf-8?B?TjZBc3RNMU5LOU02LzFJWjA1TVBuckJqaDRhTlBZWTd5SzNWOXI5LytPeVZS?=
 =?utf-8?B?SWl3WFd3R2ZoUXNCc3Z2dnB4R2gxNklwTDI5WHFwazFYaVVrcXdsZnJEWEdy?=
 =?utf-8?B?UGJaOXF1aGNSTnhIbnFUU1lVcU5OdkEzZ3E4ZmNFUEFwNjJnOUhlOHlJdm5N?=
 =?utf-8?B?UU1Xb0xQUHVOUCtoemUwQXBZRGZNbHkyd2RVSVJpVk80a214RkYwUTdOelpw?=
 =?utf-8?B?aktqRkFWbUlCQU5YZlY0S1k2NWs4QmZWOTF0Z1dRQU05TS9FaXRkdnhCS3Y0?=
 =?utf-8?B?V3kxMC8xaEFGZlZHQlRPQlp0OW5uVlNySjBFMU5SL3gwcTFWbFRuSWpnYTRC?=
 =?utf-8?B?bVI5OHNvVnJNNHlSNDhhdkdJaG5FZTMvYUUyOVVKMGtCMU9IaCsyZDdTL0wr?=
 =?utf-8?B?TlIrOHhSL0w1cC9ZU3JLOXB3c3hmRFlKSENpVU00NnBhR2c4MFBub3pkQ0tH?=
 =?utf-8?B?KzBvY3VDQ0VCWnltU014UHQ1Vy9saVB1cGsrNUxkSHpuQ2JNbU1BWC9wK0p3?=
 =?utf-8?B?aGFhQmVOTTNNbW1lOUhCT0tPNnBvaVZLaVNVemZONGxuc0MzOXdndHIxaWhP?=
 =?utf-8?Q?fABk+3gJYxdonPG8e3NInux41?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afac53b2-6428-481e-d1f1-08dc4920cc3b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 21:00:39.5518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChwefPmXNg3iiM38G6TT/pEqefnbrPVd14+JrnjCvOhp5Z6sZ27fsPxecVPGFTam9nZRDkGT2BrqNG7PulaNUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7094
X-OriginatorOrg: intel.com



On 21/03/2024 4:07 am, Dave Hansen wrote:
> On 3/20/24 05:09, Huang, Kai wrote:
>> I can try to do if you guys believe this should be done, and should be done
>> earlier than later, but I am not sure _ANY_ optimization around SEAMCALL will
>> have meaningful performance improvement.
> 
> I don't think Sean had performance concerns.
> 
> I think he was having a justifiably violent reaction to how much more
> complicated the generated code is to do a SEAMCALL versus a good ol' KVM
> hypercall.

Ah, I automatically linked "generating better code" to "in order to have 
better performance".  My bad.

> 
> "Complicated" in this case means lots more instructions and control
> flow.  That's slower, sure, but the main impact is that when you go to
> debug it, it's *MUCH* harder to debug the SEAMCALL entry assembly than a
> KVM hypercall.

[...]

> 
> My takeaway from this, though, is that we are relying on the compiler
> for a *LOT*.  There are also so many levels in the helpers that it's
> hard to avoid silly things like two _separate_ retry loops.
> 
> We should probably be looking at the generated code a _bit_ more often
> than never, and it's OK to tinker a _bit_ to make things out-of-line or
> make sure that the compiler optimizes everything that we think that it
> should.

Yeah, agreed.

> 
> Also remember that there are very fun tools out there that can make this
> much easier than recompiling the kernel a billion times:
> 
> 	https://godbolt.org/z/8ooE4d465

Ah, this is useful.  Thanks for sharing :-)

