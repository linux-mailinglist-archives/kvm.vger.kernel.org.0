Return-Path: <kvm+bounces-69649-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBYILjb9e2lEJwIAu9opvQ
	(envelope-from <kvm+bounces-69649-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:37:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49846B5F60
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2C72B3023D95
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A0D29A9C3;
	Fri, 30 Jan 2026 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3VODpHK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1F427C84E;
	Fri, 30 Jan 2026 00:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769733419; cv=fail; b=ePIBebWvg0xAuTONWrQJDOCq6XWpMzuU2oGD9/9LyVpL/yYe9JbDLbR6FWAeDAjl70O4Hn0gNT1ET05DhN5ABTySoCc4tWpI/Rf+HT27eHRwLbjNJdCpZXGhxhLNvJgWpo4fSCoxm/ugdnyQf3/2xW79GQakJCppnmQYDWaUkRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769733419; c=relaxed/simple;
	bh=J5tS9c8hnqaYYpN4f1ZxE1f7wevdu1mLj5Hw7TcQv6s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N0xkx31qHWYaW4svnn57WFYDNE/4pZiTLKhjnBwcoCHn3iBzD8w/un/jy8CsYMtEdgK68sE94C+uKIAPTKC2mbe7d6MnH5CnzsPB+LiV0gLUVOMJLsoGuSsCZkmnH4+gkmcpsd3zUPCqoPGfEh7blNc5iCZ9wkyFFOGkvTd+XA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3VODpHK; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769733418; x=1801269418;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J5tS9c8hnqaYYpN4f1ZxE1f7wevdu1mLj5Hw7TcQv6s=;
  b=H3VODpHK2kQkjBapvBhIFd+OCIl1bFaqMIuh251EZRsIflP2lXSQoEIe
   II70Da+QyMpvaTfaWrZP9UfqVkkjhJOGGqFZvYu6xkWeHWRIlAVNzJJZd
   wlYPINcnNEz7aNofRG8UdOszLa5JphegyTndgDc69uMOCFWDCRvJtrnZk
   2jGeuZpyvrE1LDyPqeWz68u4vfz9KU+xdetdwBOyideQgMUd3IFpQQOvP
   +QXWAlyBv2rgbW7KgVeuM0uGpVTz+7OvC0DweDnnC7QFkmfnWnqMLuCgt
   q4CiYrxOZRNDCo5OPD1ShXjHAYz3s54fQeFjnZAK8t3MnrF8lqXTIh62e
   g==;
X-CSE-ConnectionGUID: eH/D69tXQRmPeoXwxVe4aA==
X-CSE-MsgGUID: bME+vvQdTx6XF8R/CGTkqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70890432"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70890432"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 16:36:57 -0800
X-CSE-ConnectionGUID: zymeIKmTS0Svvr53QI6kZw==
X-CSE-MsgGUID: HJqCO4HATOWkLPGA/DeUQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="246339886"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 16:36:57 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 16:36:56 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 16:36:56 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.57) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 16:36:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vKDkLUqgroVCE6+ttvO+7LQuGjMzT9YlzLAdb4SXnsTtMH6h4nqVQ4Hc3cHU+VflUNQS65x6oW7u0hJs/Z0VyAbAhXo/6zeryyS5yH11EIQfThKGHFZwsxF0faowEIfrxp1GF5ShTkV5FTWsNh27SAitxnHSrozVdQfNoykOXcgICpCKyKmCRQ80jw3MM21jE2DUiBY5DHDHgNvHR+Y5P7Xv67C/JUnyPW+BM6pvr5swpZnTj4pUy4oYm7Vh31+NDeoj7EZkcGKnh8TATcwUe5EEQkwdOBiaKZWP0VKt1sBLKH2BR4QXen+f8Z3fouTNVi6Zm5yitL87z8/3m0MSuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5tS9c8hnqaYYpN4f1ZxE1f7wevdu1mLj5Hw7TcQv6s=;
 b=Dy3oS/HFcoCyfBmVzLZovyysylSuwxa32Fe8OwO/7ZnWvla+tKCsLsZkVgdBkq76oKzd7jTsbCj9tlvnrynmal0wGd6Jb58MV4n1LVjjGhNhMiCHl+l1yQRM4AFSpN0BaqZGduvYWvB6d3eOBRAmJNlR6fcLvFSZEcnnREKUbfqLjP6anklECX4Aj7974+70o8BnW1ViSvohCjRUAhN6jKsGgdobs2qnrmRo2p+ZrhQbIo6ViA3khCBOGhIy0fQNgfX9wW/VChdet/Vxl+qbzWmx8YK1uusmB4RBovDe1NlT8jTo6lfTVNft2A5JIqRV7O9UezlOj9DyhP+5LCpKow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA4PR11MB9177.namprd11.prod.outlook.com (2603:10b6:208:569::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 00:36:54 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 00:36:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [RFC PATCH v5 11/45] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [RFC PATCH v5 11/45] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHckLzYWtCfxmfYu0yVC5tzv7KKl7VpgRMAgAAa+wCAAEOGAA==
Date: Fri, 30 Jan 2026 00:36:54 +0000
Message-ID: <8c5aca4bacb31475a510e6a109956e7fa4a63de5.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-12-seanjc@google.com>
	 <cd7c140a-247b-44a7-80cc-80fd177d22bb@intel.com>
	 <aXvEgD69vDTPj4z5@google.com>
In-Reply-To: <aXvEgD69vDTPj4z5@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA4PR11MB9177:EE_
x-ms-office365-filtering-correlation-id: 4ef289ed-41b8-4228-aea1-08de5f97aaa3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VXN5TXoxQ0NURVczNnJob1U0RVppMXk0cDVzcFVHK1o3Wk9UdXJtM3VCczhT?=
 =?utf-8?B?ZHBiWnl0QU1TUFlxVjJiVzRvKzJhU3hRM2FmclZmQzQ4UElxVkVBaTc4b1Vz?=
 =?utf-8?B?MXB3K3l5c2R0V1JGdlgrUVZYOVFoWUFwWm9jMmhsb2wvMUV6MTlkY0RIemNE?=
 =?utf-8?B?NXRPUFNkRWkxMm52RFYvTnRvWFdrL1lDSDcwWlZvU2hFWWNVZ0ZvQ2c1NTVy?=
 =?utf-8?B?ZmxHRVR4SVNBUzVFYTVTemw2S0hxZ1huR2dmYnNBY0pPMGlOUUordHMyVjl2?=
 =?utf-8?B?UVFhdmpIT3VnRmxMSWRkYkdOcnRrUFBadWNVeFBzUmc0bGloSW9zNFhpVkc1?=
 =?utf-8?B?bW04cTVxamhZTlFlOVBuWjlUNVlBT21hTWZ5Nm9EM3RpTC9JTnV6NWR6RnRO?=
 =?utf-8?B?SDlCWmh3ZndVZ1EvVnBWNDVWeVZpZWRnY2lwUG1NL0NNOGpCQm92NlVRK1Fn?=
 =?utf-8?B?cHBEbXBabXpBRGpGSzVFaVRQRHExTFBVbkhZUTZlREswWEtJM3RIbnRVbXJL?=
 =?utf-8?B?c0hybVRHT3puanhBRGF6WUpRS0VUZUpsT2JkNm83RFJsSVhldG1TQjRaV0tJ?=
 =?utf-8?B?Z2VFdmI3Z2JzMzR5bGtUa1V1SjFjSmMwWHV1ZDdua3J6dWk3czdteGZvTHUx?=
 =?utf-8?B?cUd3SEQ5YkczNkxwbjg3Y0E0UW52NVRyQWNHRmxrNVBMRExoRFRtUE9WazdJ?=
 =?utf-8?B?SHRFVHZ2eHZ2RzFIM3Bia1NjMlBCU0NINnByWFdURGJ4VlhEa3dZdWd6RXFI?=
 =?utf-8?B?Z1d1ekg1ZW1LYWtzdXFhZUhCRm8xc1lWSis4cFhFZklEVzJ2dkRLZVZSVUhH?=
 =?utf-8?B?dmZOa2ppV2t0dVpqWGZMNWtiQW1WaWg0QTJORzc4dGNPTFVIVjMwK2pEejB0?=
 =?utf-8?B?b3JxaGdmVmxpVTcrZUZKZGE1SWZQR1lXQTdrcTFEQzZUbVFRWXljSllMdHky?=
 =?utf-8?B?bWtRMjI4eEt6RTBWS2htMzVsbEJ5d1NLaitrcEhpVFJadFpRRUNKUGJqV3ND?=
 =?utf-8?B?eXRxNDdXYmVIMWFKd0QrVE5OWjRNNzZ5UDJEcWQ1aEMvNm9pVEJLeHVDdkhD?=
 =?utf-8?B?c0ZPKzB6eEY3TzdlVlNISWJhcUVWYzBqSWFYYlBoMldWcWFleG5mcjR1cnlM?=
 =?utf-8?B?aitMaTJGRUpVTmlFc3NrYkpCNlNFdHpDTVlwb2VvbUhxdHlpNnlPdlVoOXdF?=
 =?utf-8?B?T01wOE4yRkpxVnlCZTIxM3Nub2pORXkyeEZNWnFLbUdGSElqVThOdmRETzVh?=
 =?utf-8?B?eHdzYzIza1NzZnJqUStZU3hZMktDOUo2emxocmI4RURLL2JuQ2dFcjJ6VzVk?=
 =?utf-8?B?cVc4VUJaNFFkbytybzBxRVgxRWFGblJkUjVHK1U4RVk2dmhsMjdvcmpNTzBT?=
 =?utf-8?B?WmJOQnBNT0NuUWtMR3RxTWFTNExRbmkwenN5STU2aVhOWDNHQTlyMEZFakZ4?=
 =?utf-8?B?QnFvaTFLRzd3VCsxSkpWY1JhbHNGbFFKb0lIcUpyRlhrOUN5dDZkOFUva012?=
 =?utf-8?B?TzZSQS8yZDFNN1YrU3VCdmZhNktqdmtZL2c1SXNuMDdjWWJuQVNaVUdQTkYw?=
 =?utf-8?B?NFBSWjFXSVBLSHFPamg3ZGk5bms5NzA4K3I0bDViQ1pyaGZKcXNiNVk4VzRs?=
 =?utf-8?B?VVZBdTlHQ3JzaGhkemdZd00vQ3VVTlZLUkNIZE9PZlhCcG9UbnV0cnZxVzNG?=
 =?utf-8?B?cE1NZVoySTZlNFVNUUFranBjTmpNQ1VVTXBma2lxLzYwNkVETWhKMVhvemYv?=
 =?utf-8?B?ODlnSXc0TmJnVGc1cS8zVTQ1RU5TYU1KRkZmUWZuZjFzek8xenZ4a0p6d3Rq?=
 =?utf-8?B?SHJoVU5wTGVUbk53WnU2TGhmUzNzYm1Ld3JtU3ZHMDNORlUvK0ZuSmJEbVBh?=
 =?utf-8?B?MU80TjUwNHNBRUdSVHZjRFQ3dEk3Y1IvWnZNQ3F0RTQ3UWJiVmN0NnhmOVM4?=
 =?utf-8?B?T2VjTll0L0Z2WldIbjYwb1ZLTjN4MENrRXhwMkdZNEpESjFreHFTNDg3dVJJ?=
 =?utf-8?B?M2QxOWNQUTVrSGVnU1NycTZRSmtYaWNnLzFtMUltVDBYemp3SEZSQzZZSGdm?=
 =?utf-8?B?bm13Q0hWUnNvVmpKMnFaLzBZeFZrYXVjUWEwSHZlY2hzZDdrNVZPMkJLNnF0?=
 =?utf-8?B?dlBNTnYzS2J2eWgrV1FuNzJnQ3pocnNwU0RVZzM1QkFVZjBBbzF5VllUMlVn?=
 =?utf-8?Q?ucePHm3VohfrfXN/n3SMMsqhFE+Pkd779TQLgvvHceWh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE4zTkZ1Q2dMbytkNnNqOVRRaTNWR0p4OTRmUzlvS2tKVVJJYVYwb1JCZEVP?=
 =?utf-8?B?aGpBZnB5TnJhb0REREZMZXNhR0wyWktydFRBVnFGbWxSV0xzK3RaeWcyQm0r?=
 =?utf-8?B?VDJoZmNHdE9aU0o1T3lDc2lTS2JhZzdZaUpDOXhKWktBb3dzdXJMZFM3TVZX?=
 =?utf-8?B?QWh4TDEzZUhLSG5vRW8wMzBDS0Q0a3I4bGxiOUU3YkYwRlZYc3AxTG9rT1Rj?=
 =?utf-8?B?Z0hicm9uK0VwZGkwTnc0MkRpOW5ZS2U3bFFjZTZhUmpDL2dXUnNtZkgvaEhj?=
 =?utf-8?B?bEVhZHpER1JGK0JGczVOYkNrNmFCVDd5OTVGWHpCUEs1TTNIaXhPbXVBVkQ2?=
 =?utf-8?B?M1BONEhHNGltRWtmOFlNdm5EUXhRRUNhcnpZRFc0RjlBRWZvaHFlMnlyZnoz?=
 =?utf-8?B?ZzhvTzN4eEZ6N2tBOUZPenk5UXhZSENVUi8xNGxNOWJ4Tk9KVVFxTTZ4ZWlO?=
 =?utf-8?B?UDh6SXR3ZzZUZG1qVmlGVW9xYTRDaDBrSkZpcjlGSTczMHdueHZTNHJNY29y?=
 =?utf-8?B?SmRWbHJ1V2FPNkdKTUNJTFU3ZHBFdHNsTWVoQXFjT28rOE9xd3dHcXhhUjFU?=
 =?utf-8?B?cWhDMXFvazRXWHJjYzYrREpPYkVJVkVlSWUxYTViVzdBVm1BK1FBQW5malQ2?=
 =?utf-8?B?MUNkL25mRnJtOUxDQWt3TXZRd2dCS3RscGR6UUdzYXRsSTZiWWNtVGcvOFJU?=
 =?utf-8?B?RmJkWDlkSWhjNVNLdGZUcnB2RFNJeGsrek1qSHI4eWxJMHBpSHc2SFIzbkdC?=
 =?utf-8?B?ZnFBQW91dnRQUk9FcWVLYnUxSzg5K0xUNHVaQldMMUM1aFJCYVkxUXZsSXVw?=
 =?utf-8?B?QjJjTnFTVVN0dU1TTEhxNi95Zm1KOWdoQVB3R245UHFWdjlEcDd4d2ZQNlBp?=
 =?utf-8?B?Yk1aNDI4OUdmUDJib2JxQ0hvS0k3ek1iY2ZHQytNc3paZXhWdi8wc2ozZ1VH?=
 =?utf-8?B?M2doSnY5QTgxT0Y2Q0ZDZFEydjNaZEsrRkl0TWFnMTJ2bTZUblBQM0FUN3dv?=
 =?utf-8?B?UnNVNi9tVzkxZnQ5MWU4OHRaRUtNL00vNWpoNURHMlk0UE85VmQzcTZib2VB?=
 =?utf-8?B?NFF5WTh6S3ZFcjBYMXN5TEFjZmFrMmw2ckw2TEpwYWdKbURzbUtwWDdYZndN?=
 =?utf-8?B?RTYxMWVldXZ3NkxUc3dVWnJYdkwrL3c3aGdmdUtuTTNDOWFBMzdnazBaaFlY?=
 =?utf-8?B?RUwvajcwU2FZU3ROb2x0MkRsa2dlSy9qdXdOd1dKVnV5MGNPUTVNbUhWT1RY?=
 =?utf-8?B?KzJSNDlmdTRZbmlFT2J2OTdTRmNQdU5vdGhJYjdnZTZ4Q1VCWTMxYUZUTmFw?=
 =?utf-8?B?Q3RDQjlQR3E5TXdyMjFFRUIwRXRnSGJ5cnpuaEVQT3RaMk9NK3BnREphSVRm?=
 =?utf-8?B?dUZmZVFYaXI2SkNCbGNzM2JyS2RLWEtoZXFZRjQwN1J0U0Q3SWp5UFNrYlZB?=
 =?utf-8?B?VEJ3MzI5dnltY0E1S05kSTl0UFZmeHZDWGwvRzJQZ2xKOWhiOXVodTJUcHpm?=
 =?utf-8?B?WWMwUUk5amVwYmFwN2Y5T202S3Bwc1BlZVJIeGtXUmxpamZxY0hjaE9aOFVS?=
 =?utf-8?B?SUszNTFucE9RK0pRcFJKcFdpSjluR2tGdHkyakc3YjVFbXJFMnRRSWNycnJa?=
 =?utf-8?B?R1U1TWdZS09ZMHlERVJ2U1dhVEtMRnUwOXdwVDZBTFJvUFd6d1kwenQ0dDl1?=
 =?utf-8?B?T0QzS0JCY3NBWVRRd0JxYnFoSXZidzc5ZmVxMjkwNS8rRm9jNlRoZjFTRUxK?=
 =?utf-8?B?T05TT3J6dW1oUGd4VGZWeVFsUGlRbUFXL0psN3N4VCtEOVpnM1lWeGNkYTR5?=
 =?utf-8?B?YTAySEJ2ZlMyUEt1cmNtakdEd0hkb0czV2k1enZSMHRxK2d5VnNMTU1oYStL?=
 =?utf-8?B?dUs5TlZDclY4UXpTQ3ZXN0NCa2RyaE5YQlBIU1k4N2JTcTFEekw0alFmWCt0?=
 =?utf-8?B?cTNUVllrb3FlVjBGR05vQlJuRDNuUTdOWXlYUlBRUFBOeEdoNEtXa3JaMWls?=
 =?utf-8?B?Z1JFSmRLdDJyK2hZcFZURDhjZWhnb3QvL3BLb0NHd1diMEVpcktnZzk1Smx3?=
 =?utf-8?B?dy8zcUxoc1hQeHJKMmNUdlFleVJ2ZnFUN3NTNHFGUWVLK3lRdjI0RVFQaVlW?=
 =?utf-8?B?Rk5nYXBBZ2t1WVFVeWw3VjczanlvbDk5VDdWd1NUTFRQbGYwTmNmZUZ0VUJa?=
 =?utf-8?B?TTNwU2NRVnUrempuSTFCOE84YTloS0hOellwT2ExMUdxbkRsenhtQlVlSUJ6?=
 =?utf-8?B?cGhFR0M4RlRlbUJJYzRhYm5nUWNsVnN6RHlEVGNuSlB2VVdCbWcrQWF3YU1i?=
 =?utf-8?B?a09VRjJuU2QyNE0vUGdNNEF3K0JzQXVTcmhtRVN3TXJqbUNDeUM4eUx1RXFE?=
 =?utf-8?Q?a8qrl54UWnEcb93A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3543ABF5BCFB1C4FAFA093DC98A8B6C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef289ed-41b8-4228-aea1-08de5f97aaa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 00:36:54.0651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: snsPZqwXO+TdPkIU8cstExL8PWf+8tVLz6xonLrYB0k8d0OmuqIJge/ZAeHndLwM2prenGZJc1L1Ol5uWZBheDMiFCntWCFqyy0aOQY1ZG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9177
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69649-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 49846B5F60
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDEyOjM1IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAyOSwgMjAyNiwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+ID4gT24g
MS8yOC8yNiAxNzoxNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiAuLi4NCj4gPiA+
IMKgwqAJZXJyID0gdGRoX21uZ192cGZsdXNoZG9uZSgma3ZtX3RkeC0+dGQpOw0KPiA+ID4gLQlp
ZiAoZXJyID09IFREWF9GTFVTSFZQX05PVF9ET05FKQ0KPiA+ID4gKwlpZiAoSVNfVERYX0ZMVVNI
VlBfTk9UX0RPTkUoZXJyKSkNCj4gPiA+IMKgwqAJCWdvdG8gb3V0Ow0KPiA+ID4gwqDCoAlpZiAo
VERYX0JVR19PTihlcnIsIFRESF9NTkdfVlBGTFVTSERPTkUsIGt2bSkpIHsNCj4gPiANCj4gPiBJ
IHJlYWxseSBkZXNwaXNlIHRoZSBub24tY3NvcGVhYmxlLCBub24tY3RhZ2dhYmxlLCBub24tZ3Jl
cHBhYmxlIG5hbWVzDQo+ID4gbGlrZSB0aGlzLiBTb21ldGltZXMgaXQncyB1bmF2b2lkYWJsZS4g
SXMgaXQgcmVhbGx5IHVuYXZvaWRhYmxlIGhlcmU/DQo+ID4gDQo+ID4gU29tZXRoaW5nIGxpa2Ug
dGhpcyBpcyBzdWNjaW5jdCBlbm91Z2ggYW5kIGRvZXNuJ3QgaGF2ZSBhbnkgbWFnaWMgIyMNCj4g
PiBtYWNybyBkZWZpbml0aW9uczoNCj4gPiANCj4gPiDCoAlURFhfRVJSX0VRKGVyciwgVERYX0ZM
VVNIVlBfTk9UX0RPTkUpDQoNCkkgbGlrZSB0aGUgZWRpdG9yIGZyaWVuZGxpbmVzcy4gVGhlIG9u
bHkgZG93bnNpZGUgaXMgdGhhdCBpdCBwdXRzIHRoZSBvbnVzIG9uDQp0aGUgY2FsbGVyIHRvIG1h
a2Ugc3VyZSBzdXBwb3J0ZWQgZGVmaW5lcyBhcmUgcGFzc2VkIGludG8gVERYX0VSUl9FUSgpLiBU
b2RheQ0KdGhlcmUgYXJlIGEgZmV3IHNwZWNpYWwgY2FzZXMgbGlrZSBJU19URFhfTk9OX1JFQ09W
RVJBQkxFKCkuDQoNCkkgZG9uJ3Qga25vdywgSSdtIG9rIGVpdGhlciB3YXkuIEkgbGVhbiB0b3dh
cmRzIGtlZXBpbmcgaXQgYXMgaW4gdGhpcyBwYXRjaA0KYmVjYXVzZSB3ZSBhbHJlYWR5IGhhZCBh
biBlcnJvciBjb2RlIGJpdCBpbnRlcnByZXRhdGlvbiBidWc6DQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy9rdm0vMjRkMmYxNjUtZjg1NC00OTk2LTg5Y2YtMjhkNjQ0YzU5MmEzQGludGVsLmNvbS8N
Cg0KU28gdGhlIGNlbnRyYWxpemF0aW9uIG9mIGJpdCBpbnRlcnByZXRhdGlvbiBzZWVtcyBsaWtl
IGEgcmVhbCB3aW4uDQoNCj4gDQo+IEZXSVcsIEkgaGF2ZSB6ZXJvIHByZWZlcmVuY2Ugb24gdGhp
cy7CoCBJIGluY2x1ZGVkIHRoZSBwYXRjaCBwdXJlbHkgYmVjYXVzZSBpdCB3YXMNCj4gYWxyZWFk
eSB0aGVyZS4NCg0KSGEsIGFjdHVhbGx5IHdlIGFsbCBoYWQgYSBsb25nIHRocmVhZCBvbiB0aGlz
Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzcwNDg0YWExYjU1M2NhMjUwZDg5M2Y4MGIy
Njg3YjVkOTE1ZTUzMDkuY2FtZWxAaW50ZWwuY29tLw0KDQpJIHNlZSBub3cgdGhhdCB3ZSBjbG9z
ZWQgaXQgd2l0aCB5b3UgYnV0IG5ldmVyIGdvdCBEYXZlJ3MgZmluYWwgYnV5IGluLg0K

