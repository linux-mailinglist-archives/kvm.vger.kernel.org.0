Return-Path: <kvm+bounces-17559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AAB78C7EE2
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5B17281230
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 23:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EFF2C1A7;
	Thu, 16 May 2024 23:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UDBfMXvn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81631F19A;
	Thu, 16 May 2024 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715900900; cv=fail; b=mnblAWsSy6vFu6XUaKarcADRdWZZ4lHw5ixqZeegjzd6JSsB2enwhZkWivGAZ8+U6W+vkbfQVwUdYSOnAuD6YaQ5AypPU8V2RHJkYB26E/3/RPZlrSNDHjx79D4Ka1qibcamwOMAXYYJ2IUMtlNESprwKA5QJhzARTaAmpIJ0x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715900900; c=relaxed/simple;
	bh=unlO84rv8VN3OkT7m6Xn7olQ8o0kjYtM4DC4iuMU5iM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tl7D7+99KmoAFhDRIDz3t9hdWRxeyeHORWb8RMGEIxPhkDiwffDvOKd1HUSwa2oSNXoGOBBdpcAPkJs5BoidHBcOLkq9pwZ14cuRE47BBuNmebTQStcuCqMK7fb+h9qUKqfHBslcudKae5u7R6MePjKRG9z6745MwtO+e11i96U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UDBfMXvn; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715900899; x=1747436899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=unlO84rv8VN3OkT7m6Xn7olQ8o0kjYtM4DC4iuMU5iM=;
  b=UDBfMXvnfeiwN3cYKzzf2Z4v/DtQH/ibm90LzV5fhjpdxRpEIUNl6kqp
   xy5WSkN5aOLjZ7m04XR56nItXDqPztFrsa5gxJLVIFTqSrbQUf6oHHfM9
   qby6DlacxxSlDjmC8vTPAXLSvf/oSOtU9CihkzA1PLNeSrKO+p1GmTAwm
   bjPW94ZXL6+VptHTJvCrL2irABzqCY/MMdYtbPjQZJDs0KWA7ORPAohsf
   7l8sVRYvnUvh0f8J8QKC3JovKw2Vol/QvlCWXYXEJKK1HEdaxDAP8Q/ZI
   +J0yYejUPoMRHh4sHErgsZLbZkp+Q/aKEgon9BFrlNcbFURlB/iyOFzqc
   w==;
X-CSE-ConnectionGUID: mHN0VYVJRrGzLgbkVF8hCA==
X-CSE-MsgGUID: 5J20wei/QuKBwUtUZ0DU+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12178631"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="12178631"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 16:08:19 -0700
X-CSE-ConnectionGUID: MoKn4Ll3QzWyC36MesIDkw==
X-CSE-MsgGUID: Pmi288pESxmKudsdwFVlrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="62417449"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 16:08:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 16:08:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 16:08:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 16:08:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQe7H9DjqfNA2lob/Ippavqoqqoyg8umOameokSCetoDk5Hydwjdx7VOs+Q94CxdxvZU/C25sGF+jnnjzSq0OukEPZkqJQ+LKIk9Eu+M2WvKaDBRjWPL5uljPYzxBRTpIQw/X9YWuDG6QsDgiOTTnwsvuL/+lQiih46QOcXUULgNVWRpex8phFpahnO6C5gajxs/DZsTV6WgFvothBGCgSNO6YAH4LvNpTLE9cJpN7IkHZ881OmGxlqpr2YfkFtRbGcVAUa6prO91BulpvSoApld/tRTz3ABbcnuwiTg1oU6EMYSSQaZkUDVLJXqcjTm//IignIgouXAnuWP4Z9rBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unlO84rv8VN3OkT7m6Xn7olQ8o0kjYtM4DC4iuMU5iM=;
 b=UoB+HatJLQoV2wOSoPfVUQ391PD9Hb9ncNwkXnrYuc06/NOJlVrVdH+/2SUxgeckeC6ICOe7MOyrgx6rlb2pMvbYXWoMUx+PA0D+HXXWA86z62Xkb2XY38eMhO4xt3HC3cDJmmGZNAheGoZvm0cSerEIdzPQQT8K6dbYPgyaqH4RBZeuQGSHny4wleRf2A/0boD72Bazk0P8wfp7qBCaPK86dsSR5Qz95N41VCuWp42YRTOnFw4Df0hMX4U/X6gXEt6lvcjWzzuosIyGCtasOectnSgDv3/W6TZT4F4ejQFwbZzs+fcNlS1NayyS/cb11PT0wtFYB6rRjUwJH8/Cjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Thu, 16 May
 2024 23:08:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 23:08:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7ACAAAHNgIAAAriAgAAH94CAAAR+AIABbXYA
Date: Thu, 16 May 2024 23:08:13 +0000
Message-ID: <9556a9a426af155ee12533166ed3b8ee86fa88fe.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
	 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
	 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
	 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
	 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
	 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
In-Reply-To: <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7349:EE_
x-ms-office365-filtering-correlation-id: 76d2d79f-53b1-471c-0e0a-08dc75fd0fdb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZjlWVHQ3QmlrMXdBb2ZrUWwzMWxkMEI2TmNHeFphazhpZjlUcURYbkRqWjJm?=
 =?utf-8?B?d29UdXVsS3l2c2NjOHd1ZHd5dHZVVWxUWnNzVmplakpPS3RmSDlCYnhQNFRz?=
 =?utf-8?B?Z1NMNDRrOHlpaXRwaWRuMk5UV0gyWHNCUU9zRTBpcDlKU3hSbFA0cVZ1Sk1r?=
 =?utf-8?B?R3lxWGxFd2VWaUJSaVJxT2pHeE9SSHdOMnljT1RGRCs4cVB3MktLUnp5L21D?=
 =?utf-8?B?cm4xenM1ZnZrU3MyZXFjNCsyTmpxUUgrQTdnQk95U1V4Rk8vanRXdlYzM2Q4?=
 =?utf-8?B?MGxzd0l2alBFOUdHbTJRVHFRbVZXaXR3L2JNaC9vQmR2QklDYzgvdXd5NndX?=
 =?utf-8?B?OGcxRnJyamxBWUgxMU51WmRUZjJNZXBzSnFvRTV0QXN4b1Z0Wmg4a1pqaEVU?=
 =?utf-8?B?N1A5YWQrL1gwb1lic2dTbGJMam5vWk1lVUNpRVJvNGtFSmVmUWdzWm1GUzhm?=
 =?utf-8?B?d2FaUUtEZTM1YUJ4WGVYMTd0MWdzUXFNSHZWMSt3N214Z1Bua0pNbnM5MjlT?=
 =?utf-8?B?L1hORlhHWFhjKytkZFVqaDdORFNNTUxmS0lpT01QaHdva2ZldVdLMUZETDly?=
 =?utf-8?B?VEs0U1M2dzUzbnVVVGJ5dDNyZkV6OHVVQ0FXM0FaODU5djRrSjhJUS96MjdY?=
 =?utf-8?B?cHJhWG0vSnU0RzFucE5uS2dYZmJ6S2JnWld4a2ZsY2l5anlhcXJhS0FlQ3BK?=
 =?utf-8?B?ZW5jV2FPWjFMNTBnb0lLK0t4RzUvR2ppclN4MHl5cVhXblR3VjgzOGQwendQ?=
 =?utf-8?B?a2pNejVYbzZBeWwwUm9mcHcxTXJYOXJUYU5pWFV3UHN3Ti9uKzg1UmdzZzFO?=
 =?utf-8?B?U0hsdjd3eXZjQnZHam5QSUMrSlIyaTdFc3JmdXhsN25jRndWeGdXd0tvWitQ?=
 =?utf-8?B?bVMyRHZrQnJaeFVma1puZjdTNEVxM2o3bXptcExTYnJIaENHQ283aEd5enNG?=
 =?utf-8?B?cUJMVVAzblF3N2dzYzkxS1JsbW44Y3U0UXRiZnFxTGhiQzJTMjd1emNzN1Z6?=
 =?utf-8?B?a3dXVkJDOEpQU3lzUkxVWHRDSEJlRWdHM0JjVnNJTHhFNW1ERnRPcFlYNFEz?=
 =?utf-8?B?ZkhCWG5pcVRsWEtzaUowREptK3JmTy83MlRzaUU2bitDYUxDakRZK3Z2WmxH?=
 =?utf-8?B?RTBjVUpGWkpqK0N4UW9kbithQWJwWmlnRHZCbW9xS0owL29pbUM0Mnh4TFNs?=
 =?utf-8?B?eHNNK3YrdnozWU9qbHo3MGx5S054REkrVTJ3aEJ1QVFOOWpiZEJ5b0t4d2pH?=
 =?utf-8?B?aHAxTW5CZGRjMTVlOHFKODdJckN5emJNd29EMDRxR0RUNFdsYkJZcWRpeU9U?=
 =?utf-8?B?amxwR1owY3RvdnM5MldDTjhGQmxYR3l3cEVBVWlpajFBZjZhNHM2aDRDOFdV?=
 =?utf-8?B?ZzBudGVJZEo3Q3djaTdEc292Vkd5N0VjQWlUOVRBZW9WZ1kweW12cVBWd3Z2?=
 =?utf-8?B?Y3ZmNDd4U2ZYcGRqT0FyQWZ3akVIdktOVFBnN1RnRndsYTFBQ0VHK2VuWmp4?=
 =?utf-8?B?NklyWGpCTWRQcGd4QWxwRURRWmkySTI1NmFKYWxBdVJaU1d3d1ZPMlFGcWtC?=
 =?utf-8?B?MEExOVlDNXVEb3lRL0tiSlJsY1lOVjgxdElRSkdEQzhYMERFMFhHSFg4K0Rp?=
 =?utf-8?B?VnBvcS83dGJlVHpQR0ZJSllhMjNNSC9OR1pON3Ayb3h0d2txbGJDU1dJODI5?=
 =?utf-8?B?dUt5dFprQTNiWGVBVU9sWVBmUSsxb3RIMlkzUVk5WCtQd1BYQVg5RHRTeEw3?=
 =?utf-8?B?NEZtMG5lcFFxNGNid0VuT1h0cGVueGwreW5maHBNc1hMWjNnRGhRblFGR2No?=
 =?utf-8?B?RFM4aTEyeGNzR2lseHRnQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVdjdTNhUVIrOTNaTmZyUDdGbWlDVFE2WWRrUnJvaDRjbWtrT3FrQ2dscE5y?=
 =?utf-8?B?eEZ5d0htMjBydllZZXdMajBjdlYyaENrZDRHS3pNL1AwMG5NSUcxMkJBRTVK?=
 =?utf-8?B?cUQ0Rm1Fdk1GRFcxeG5pWkRFQXBmcmhNOGpudzVPYnZmdE1WYm1aRHNod2Ni?=
 =?utf-8?B?aXRjZEg0YmpJNWE0eUk0dzUyaG9INHN4N096SHVKNElQam9PTVZ4K045OHJL?=
 =?utf-8?B?Y056L1lxVmhzdjZaN3luUHZWdGpSL3h6aFQ1WEJOL091ZjZFRlRxZ3BXN3JP?=
 =?utf-8?B?QUJYVU9SY3VkdFMxcS96Rll5NzNUcnZkTTZodEY5VmlOelkxQzhCYmRKcCtQ?=
 =?utf-8?B?bUcycUN1LzcvcjQ0Yk0wM0J2Qjl0NVVaU1hGZ1JhYlRlQW9sbURyVUxXUENh?=
 =?utf-8?B?MFlOS2RSTEQySUZMcy9TZXc5Tk1ha016YUI3U2czOExrZWg2SXp5L0ZMNVVZ?=
 =?utf-8?B?V0dnRzRaaURIdmVxK3FQam9MYXg0NDdlbVE1MXdUVjhvNUNGWEJzd3B3VUxR?=
 =?utf-8?B?KzJ0MDAxenNBOGFTRitJdis3eFdnRThHTksyT2xHcGE3N3FJYm9QTTlBRHZ1?=
 =?utf-8?B?SFVOVHdtYVh4MklnOG9kRUZ6K1FxVzF5QVE4VjRDQmIzRkh6UmEvR200c2tM?=
 =?utf-8?B?bms0TFNiai9vblhMNC93SG9USFpCUFhtbmpQMVVuck5EUHVJUlQzTCsxejU2?=
 =?utf-8?B?UkxEdjViRVdMend1aDVwWk1ndzM4SWNuTGN1eGxqcW1Oc0JTZlRaL1ZvUE9x?=
 =?utf-8?B?c0JrcEhUVmt4ZHd1c0EwVTU0UG55Qk9PSU5jZll6My91SzFhUjB2SXc1NGxh?=
 =?utf-8?B?KzBiOGFOUnhteWZLSytrSlEwQzdIdlZkbWN4YjEzNzJMb3VQUmpEbHR1R0F1?=
 =?utf-8?B?OWlFd1VhbW1vZ2RvdG01d0xzVzl5UldmU0pEellPbE10eEUvbkFZM3BlcHZB?=
 =?utf-8?B?YWtHWlpWWXJIYmtheGh2RUR4L3FhVjFuYzhvdDNzNmhvYU53QkxzYnJVdVNW?=
 =?utf-8?B?NytSMmJNbjBjQnhRUG9uWUFZTks4VlNvenJ3dE5aWGZGdFpLM055ZEY1TDBP?=
 =?utf-8?B?V0pUTjdtcWFpVDZtNUVnQVcvOSt4TnduaTY2SWRCTWRDMTFyaEl0R0hEL1JR?=
 =?utf-8?B?SW42SVV3dzJsTEI4RHpSb0NHZHBjcDlnc1Qzd2xrRzVlVU82NkpBa3NZb3Ri?=
 =?utf-8?B?STJwZ1M0d3BPMTdxYzhlbDdNUFNrUVh1M0doM1UwR0k1YUMrL0ovMXljVE90?=
 =?utf-8?B?LzRWWUFkRXJRVmpQRlEwcVBLK1pyMDVhUVJBbUd6ZjJGcGF2WVdxNTZxandi?=
 =?utf-8?B?bk82TlpQdVlRVUYvcGZhdzI1UWRjVDgzWTRROUkyQTVPY3V1eno0N3BTNmJM?=
 =?utf-8?B?UHoxdDZKVi81TmlFY2dwTlZHa1IxU3BybWRzVGRVUEVPMVczSURDSDF5Y1hz?=
 =?utf-8?B?RkZPN0NLeWZ0cTRXTFlibm5YVWkwemgzdDk3L3E1Wk9HSFZscmIxNzVwY0x1?=
 =?utf-8?B?S2k2bXRDUkwzOXFsNlBSc0RSUG14TFJoM1JTb05nbCtsMkt5QStOak94eDFa?=
 =?utf-8?B?RGhvQkkzVkFyZGxqcE96WVZXOU1HMEZHVzdwR0oyZ2hQdU82RnUyeGE4bGlT?=
 =?utf-8?B?Vk5uaUlSUndJMm1ibno0cUdseFE5WGNRLy9HR1o4Z2UvRUlkemJGQkdWbk1v?=
 =?utf-8?B?ZHlNbGpQeW9KRmk3VFE3VTd1TUpGdlRDa3RyRHBObHFkMVBXOTR0cEF2VzB4?=
 =?utf-8?B?WUlGY0VubFdTWHpTZWp2OCt3WXFtdGVFZDZQWTUweDd6Z2xoaWkrL2tUcDIv?=
 =?utf-8?B?SlVoSmxBRzhLZTV1MmluS284RG56bG0yUkEyZkJ5NXE2R0lLdHdIVVV5QU5C?=
 =?utf-8?B?T0x2TGQvcGRhMytQUmVVVy9EdXJLeGVPbUE2Uk15VGRaajJvZithQUJOaTRU?=
 =?utf-8?B?SlBIMklWNFVpSXIrNENuYXdaQStpb0VLVWVyZmNHVjZWY0ZaZ09ZSjZtQnVi?=
 =?utf-8?B?MkR1U2VaNTlkTmUvY2NOR0lpZkdLT2VpRitNTXJkR0YxbEw3Y0lPbmI1OHVx?=
 =?utf-8?B?UlFiNTFXdGFZMG51VHp4Szc0cXRiZzlyc3J1VytXVW1XRGFOaE44Q3FSMmE2?=
 =?utf-8?B?WGJrYTlseWZTa2liUGhkRnVzUXlyb1MrQmUvVTkvV1BaSUl3bVNKa0xzTmhM?=
 =?utf-8?Q?7z5fmqigtiHr5aNHGUTwoqc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91629CAA7D27A2409F0F8B29F5A565A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d2d79f-53b1-471c-0e0a-08dc75fd0fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 23:08:13.2037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cGlpgKbInu2sKN34ldCdpY6z/3YWDl0MpLHFSbnqgD0/c0q/yvUVFpLI+4VdqwFGOY79+9U2zILJv+5NhK1asUsxUX1X8a3wBWO9FkLw0es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7349
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDE4OjIwIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gVGh1LCAyMDI0LTA1LTE2IGF0IDEzOjA0ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0K
PiA+IA0KPiA+IEkgcmVhbGx5IGRvbid0IHNlZSBkaWZmZXJlbmNlIGJldHdlZW4gLi4uDQo+ID4g
DQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlzX3ByaXZhdGVfbWVtKGdwYSkNCj4gPiANCj4gPiAuLi4g
YW5kDQo+ID4gDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlzX3ByaXZhdGVfZ3BhKGdwYSkNCj4gPiAN
Cj4gPiBJZiBpdCBjb25mdXNlcyBtZSwgaXQgY2FuIGNvbmZ1c2VzIG90aGVyIHBlb3BsZS4NCj4g
DQo+IEFnYWluLCBwb2ludCB0YWtlbi4gSSdsbCB0cnkgdG8gdGhpbmsgb2YgYSBiZXR0ZXIgbmFt
ZS4gUGxlYXNlIHNoYXJlIGlmIHlvdQ0KPiBkby4NCg0KV2hhdCBhYm91dDoNCmJvb2wga3ZtX29u
X3ByaXZhdGVfcm9vdChjb25zdCBzdHJ1Y3Qga3ZtICprdm0sIGdwYV90IGdwYSk7DQoNClNpbmNl
IFNOUCBkb2Vzbid0IGhhdmUgYSBwcml2YXRlIHJvb3QsIGl0IGNhbid0IGdldCBjb25mdXNlZCBm
b3IgU05QLiBGb3IgVERYDQppdCdzIGEgbGl0dGxlIHdlaXJkZXIuIFdlIHVzdWFsbHkgd2FudCB0
byBrbm93IGlmIHRoZSBHUEEgaXMgdG8gdGhlIHByaXZhdGUNCmhhbGYuIFdoZXRoZXIgaXQncyBv
biBhIHNlcGFyYXRlIHJvb3Qgb3Igbm90IGlzIG5vdCByZWFsbHkgaW1wb3J0YW50IHRvIHRoZQ0K
Y2FsbGVycy4gQnV0IHRoZXkgY291bGQgaW5mZXIgdGhhdCBpZiBpdCdzIG9uIGEgcHJpdmF0ZSBy
b290IGl0IG11c3QgYmUgYQ0KcHJpdmF0ZSBHUEEuDQoNCg0KT3RoZXJ3aXNlOg0KYm9vbCBrdm1f
aXNfcHJpdmF0ZV9ncGFfYml0cyhjb25zdCBzdHJ1Y3Qga3ZtICprdm0sIGdwYV90IGdwYSk7DQoN
ClRoZSBiaXRzIGluZGljYXRlcyBpdCdzIGNoZWNraW5nIGFjdHVhbCBiaXRzIGluIHRoZSBHUEEg
YW5kIG5vdCB0aGUNCnByaXZhdGUvc2hhcmVkIHN0YXRlIG9mIHRoZSBHRk4uDQo=

