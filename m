Return-Path: <kvm+bounces-43070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7A4A83B56
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55C0D189F2AE
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8E820AF9B;
	Thu, 10 Apr 2025 07:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnstnoK3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E2E20766D;
	Thu, 10 Apr 2025 07:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270473; cv=fail; b=VfITZTqbgTis+YqAuXi6vvHpbOkWvTZ7GMI/0G1oqZ6GGv3mLOzaMSiUAk28dvRPwIW4YIw33j6VQ0b4iTJZetFlHGjLlcoyFh6xWeq3AvpAVOwTJyT5gU+hCQ0RXeULQPwHA3cvT0MTpiRexdT1v21c6Fosx4+rzpq/hWSlEJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270473; c=relaxed/simple;
	bh=hq+nYtBTyAWYkVMaoVqs+863VHoCEJNa/v56ZA6o0cs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=opGlLgNy7CA21y/QnjYiqCN4ozJDghKD+5lJI+7aK9HwZn+zjW2RRkY4X6JUgTIgjCYD2egZYwJwu0tP+SFJ9P29VCKK3lcVZjG3cc6hQYJhQqnY05+oiYu+QXQvHnTVA1pNsfDBIUa2SVX08Vh8wBjGBB9O7O3UcaeUSnKL4Jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnstnoK3; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744270471; x=1775806471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hq+nYtBTyAWYkVMaoVqs+863VHoCEJNa/v56ZA6o0cs=;
  b=dnstnoK3W0HHAERs+yKBSUGNImgH/EO6lrxSDtnScwroBIJoOYxveDW4
   I4yRs2vYOIFQDSa9y6j5L31cvpRP/cXC7+dtJQJj3E5PHAIaFlYOuZpjc
   1eFKghXASBT4itPuRRIzfzEowOLzVEGaJwv7riQYHtHHn1yScUHWIlhv0
   mFZZHuuJIVF/YfCPqvTAjrHES65x7TGDhyT0mZhBzdPTNj4xtZ2jcskeb
   TsNok6Z/kn2pCm5dC6hRBYNV4bAkLtfgJ6gjBkXozX+SEUK1XX2tbbzUL
   ruafAcS52gYfNno/8Qsnf7mh7M8X0C5YLVsoM6XuYbEFi4KA0M21da22Q
   Q==;
X-CSE-ConnectionGUID: Bs8viypYQAC9JHf7n5ldcw==
X-CSE-MsgGUID: 7sYPft5aQNetqowHOqO5dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="33381821"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="33381821"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:34:30 -0700
X-CSE-ConnectionGUID: KEs8p9NjTD2j9nbFq5rusQ==
X-CSE-MsgGUID: ZKV8UmtyQcOJDIxKl32iLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134011776"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:34:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:34:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:34:29 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABqBbmv7Z/jUrfSSJPUwgi5RQBRwWo7bFjxqMEMdICS+bNxFZQBw/m4d3e1dukbZYk9ldFAEwWLjtbGbrSPJ86rsg2uozmsPqnnWJ4i+FRJdUCvHsa154MdeQpcJbMAh8C//NggnabAn/PdEDavcteLaIWDn9jqHwFCifgE+HkFgj49zOVXKyBMw1nL289/Zc3DVC/zW8hWHNIgsy2bImw+egophrLrjaapmy3Jk4Copu4Yz1hI2VF+eUEUV7rI+74xVUJnvXC6PE8/M6f/U7lXpHCPovxAMDeZga8C7/da2Elb/+s7YxLV8l76NIevZVZWgGALCpJTwHjVACbvuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hq+nYtBTyAWYkVMaoVqs+863VHoCEJNa/v56ZA6o0cs=;
 b=dFZYRalKGF8Q6Gmss9VgBgjiXccCGFUZ/ThWnccK08hELzKLRlIeVrlVvSOaID8DYecq7ZRTkkqffStP9Kib10c69Nm6JSs8xwDtpsB2x/c9jbRQXJ36soTQQm+FEKo1bgq/KoPMqzhGx6cAuSY0kEHXE6pxxVGUtvGWBFjkmSCac28qtwHpWZceONpH+ia4HbkLXiKiWz+vnBLiFBu3CBwNQFcycLioH2uO4t38Ulh5t7ynG2BD+cq4Z25g0MFsvFhw5lXICzBf2bMrepk740ipxx5nBQ8q6KTtuRzsbaOJIwZN220NkcmQv11eYhwr5GPTOm+BYtaQMmUFoGKSCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB8585.namprd11.prod.outlook.com (2603:10b6:a03:56b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Thu, 10 Apr
 2025 07:34:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:34:25 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 6/7] irqbypass: Use guard(mutex) in lieu of manual
 lock+unlock
Thread-Topic: [PATCH 6/7] irqbypass: Use guard(mutex) in lieu of manual
 lock+unlock
Thread-Index: AQHbpacAp3VPCgY2XkmFhFsqBr5f0rOcipaA
Date: Thu, 10 Apr 2025 07:34:25 +0000
Message-ID: <BN9PR11MB527677C6D48F820FDB8950868CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-7-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB8585:EE_
x-ms-office365-filtering-correlation-id: 6ef63681-9acf-4258-54eb-08dd78021e8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QzMxdEpmRHU5dkgvNjBhajdnR0NPL2N2Y2NBQmRvcTJJUU45SnYvQ2ZRdUtB?=
 =?utf-8?B?cEJBUmc4eTlaRlpJQkNKb2JGVDBSNVcyemFubVBGaU1rVzNtekoxM1dGNG9a?=
 =?utf-8?B?Y0NBaW56dDJmRWp0UXdiaUhVOVVLWDRMR2gyemprUVBKUXNxZHBsOXUwYzZ3?=
 =?utf-8?B?RENWN0ZZSDdMTnN6Z3NlNVhvNndsUS9LVFNnVjROQkNBdEZIdHE3cnpLTXp5?=
 =?utf-8?B?UlVkN2FHMFRzRGJNT0tNSEt4TCthUkFjRnYxY0lUeU00SitsdkpTTEVsVDZ5?=
 =?utf-8?B?NzJ4Qmovd2xuRCsyNEcxdHh0dVhzZTRwNXhnd1JhUlRHS3dEOWVRQkU5bTVr?=
 =?utf-8?B?SFpEOVR4bjVyam5xZzBUT2dMTVgxdTluNXA3a0cvL3BTcEMxV0JsY25lY0Vt?=
 =?utf-8?B?bWJvTkNNQllSckx1Q3hscGFCVGhDYWhSRnI3aU5EOEVCZy9reEltRDFQTVJI?=
 =?utf-8?B?TSs4L3BLNVhVZDVRMDRONWlYa0lpTk5oMnp0bzAwNU1PVjVibEdrcUttbm9Q?=
 =?utf-8?B?ejdzS3RwL2lBSUdWUTJuM1FhZmNBdERsRVFTTnNaSm9Cb0lXd3JKcEd0eGpz?=
 =?utf-8?B?RSt1K0VwNGw1V2xxWXpCZlNlK1FDY1gzdFB3K2xFS2NwNzdmN2Rtam83Smpi?=
 =?utf-8?B?bHM5RWVrL1NmY2trTmgzVlhpS2tSYjRTWVhoYTRtSmt3OEtoSmVIVlRzS0da?=
 =?utf-8?B?UEc1OEtHdXQrZjJ1R1FNY1JTTG9XWVNNOW9BbC94L1lUc1RlL1ppN2lvNTlv?=
 =?utf-8?B?Q2p3c2xHdHFITTVmWXV0cUZHNU5UN0Irb2c2d2JsaXR5K3JIWXFhb1lJWjBE?=
 =?utf-8?B?RTVtZVdFTHZWMzVXSnhFUER6SzdiMlRUc3I4aU5GTXlzc2MwaS8rSjJBUGRD?=
 =?utf-8?B?ZFJWM3FrcGJ2Vkx5NStQWi9FczhRelFxWWdhQlhFS3A2NnJ0SXMyVVFnbkVL?=
 =?utf-8?B?eTgxdjJvRlBIYUdndmJqWDV0aUUxVlA4NFJpL0RYS2VXV3FsRXJPWSthWWJ2?=
 =?utf-8?B?NnFvWDFHOWhwbThMMURCRXFoTVdNK2hKNGVySnk2dXIxWnAwWjBCRXd5eUU5?=
 =?utf-8?B?REZOUmlmRE82a2xNTDYxWHpzUkZHdmEyTEUwMnJ1ZFcwdS9TNHFWUEl2bjBo?=
 =?utf-8?B?aEpyckY1YUh3RENqMDlpY2IzUWs5aitMRXEyblpUZVBWL0ZwZnlNbmFFTHo5?=
 =?utf-8?B?M3pvbWpHUFU0bCtLSE85cWxnOVY0Y2Y1c3BIb1JLMnJ3Sm56VE9QNGlQQkFu?=
 =?utf-8?B?UnI0ekF2ZjB1eUo2M05oSlVUMkYwbUdDZjB0WklhbTBUMGhlSU5JenBPU0Zr?=
 =?utf-8?B?OFh2TzFEcHZ0bnJHZWRHOGZFUG5sVk5tK3JobFdrMzFoRFhrSVFNWjNpVXlW?=
 =?utf-8?B?YlpzQmNCOHJDOERyK1ZUOStwT0Y1NmNnb2NTZUg0R1lRSFhEMXBpRGRLMXNB?=
 =?utf-8?B?Zlo0WnRueUg5ZStldjYyMG5FUDI1ekJNYS9RYlhDeEJmS1VwZENSRWNlTTcx?=
 =?utf-8?B?VU5ZSjl4dTQ4aTQzUkxKR09xVHRxNmJjWjFCYzZMUW8ycE9ySEhDaDVwVXR6?=
 =?utf-8?B?RTVQL2RMYWhicGRJMnBscXFSSFRrZTIwN25pSnVQRmk5ZXlIaEpWRDJGNklj?=
 =?utf-8?B?Q2dsQ2lxbW56Y2VhakxBU2lxZ2tyZFF3dzlRbEM5aDJyb1l4QkszZVlaNzlM?=
 =?utf-8?B?Tkd2VTZ2Qk1hRkdyNzZWU1N0Z0JZOE9ZdVNJLzFUdnl1ZVZweExHbE95bW5a?=
 =?utf-8?B?OTNYRUNRQjBOdC9EOXdQY2V3dHA5bFhxQTdJeEV6L0cwYlBDSTh2RWsyVEVB?=
 =?utf-8?B?WFloWlNRdnhEZTJHY1hXTDJMd2svaEUwMHNWdE5wTkFmMXFjMGJUbFlUb3hx?=
 =?utf-8?B?SWhMa2QraUZJWElWL284NFV4M2xqSHVvUStkU092TzJ1RVZjd1RYZlVuNUlX?=
 =?utf-8?Q?yiR1/L/pw1iv98uSNzs36Iy7E7+4k9d9?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXEzRE80aXcweHNLWXA0TVJtYjk2eTVKSVV4NVBXckl3cGlvVVNNNkpFVWxN?=
 =?utf-8?B?MU5pK1k0TkE1WEJ5VWUvbjNsbGM2Z2N5L2tzamx0N2crdzdjSjVyY04yalFE?=
 =?utf-8?B?TjdqT3MvTE1MeDRaSlFDRHhFbjZadk02VmhUdk1ZVEwrdnFKRytjdkZGOG45?=
 =?utf-8?B?ZlVvNnlFK2RncmVaQkZEZnNSMWZpVlJrK0x5cDhJUy93L0ZqQzgrUlEyV1dp?=
 =?utf-8?B?ZG1hYVFWbXlWbXdGZDQxSjBIZUJkZkdINWxKSWJpUVRVY0FzZE4ycnRhS1NL?=
 =?utf-8?B?ek5TYlNNdHN4M1hRbk9URXhNQkhFalROMnE0dVVKSTNKVllybVB1SEdsZ2Rs?=
 =?utf-8?B?d0poc3ArcVk4UUVTZ1BZZ1ZGVjZURjdjaVlCOEE5SjRuS0RLZ05XZjdoemgx?=
 =?utf-8?B?TEhDV0VkRVNZWGxuRmNGQ1hoUERQUXRNbW80Q0VaRGZHWHNzdnhFYkxPNlo3?=
 =?utf-8?B?cFplb2dOMDd0VEFLUGNVR2Mxa0lGNG84cDAvLytWTHZVUzE0NDRIUk54eWR4?=
 =?utf-8?B?c09XcjZQZURPUmloVEFEV2dMaTFmMDRjMStxTUZoT0NCc2ppb3Fhb2tKVEhO?=
 =?utf-8?B?U2pyUkY0SmZOQnZvd2lPVTcrVUt1NGFsWGV2V1llRUlYNHdoUTRRV2dNMmgy?=
 =?utf-8?B?dnQ1N3oyRnc5SDhRbnRldHNqaGJnQVQxZFhiVmZBYkVTZ3k3N2R1OHhpNmlz?=
 =?utf-8?B?MkdiUHdTb08vZGtzYjQvenFyNThsdmNaMDlaM2ZDdTJ5N0RBU3JDd1BlbWNJ?=
 =?utf-8?B?S0Uvem5KbkRVN3JUMnBTTnA5Z0ZBRmZmT29QQjZFNDRJSWJJRUM4VkptL0Y3?=
 =?utf-8?B?Mk5hMW8vTjJaRjM4dkwrTU1lUHorUE41ZENSckk1aHVoeFV0dWF2QU93enV3?=
 =?utf-8?B?a0p1a0VZRjV6aXhSWVV1dkpncEo3K1U0ZExNR2JWZThKNC9RT2htQTlGTkZ2?=
 =?utf-8?B?Q2xUSjc3aTEvMGwvQ0hmUTBDNXRrVzFGQUhSS1h5NnhlNzFBQUhiVkVKUktw?=
 =?utf-8?B?bzVMRVp6SjE4WjI2L0YxZ2ppK05kRTl4Z1RUWURoaVFqdlNhcUNLYVpOUnFZ?=
 =?utf-8?B?K1FXd0tPVHJNRnQ2d0hLc2NkKzRYVHNLOFR4RmM1WTJWakxxQ3dRNHdpTUtr?=
 =?utf-8?B?elNYWmhIZFNUOFVBVVVBNmg4NWNwTmd0aFcwZmRESktDMzBUZFJpZVFSaXpP?=
 =?utf-8?B?dElaVWM5RkhQSkRLZE9yc0VQcnR2NExxZ2p4WDdBN1VOYW5zKzhSN3B5VVo2?=
 =?utf-8?B?eU94b1FrLzZhWjdRODZ0M2tyUzJoN1JKWDhBaXc5WTdiUitYWHlVY0xLUElo?=
 =?utf-8?B?QSszaVFRYVFLdHhrNUV3UE1uY1BlWWYyVVMyZzg2MzZ6NVhEUk5WM0cxK3Vo?=
 =?utf-8?B?bG56SFd0RkdQR3dHN0JTUDJ4M1NQd1d3eEQ1VHpDRmNNaWhSSFNKTjV4NHFp?=
 =?utf-8?B?c3lkNTY5bGd3UXp5RnhCVkJQNTRoblpwdDZrM1FzdHBFblpUS3JIaWJnV3VZ?=
 =?utf-8?B?TjExTVI3UWc1RFVqL0dXTml2N3hpVDFSdEEyVVZSdGhPdkJJRmxJWllvSlFl?=
 =?utf-8?B?emRIb0QrdzQ1WFJZNVQ2cUcycEtZdXJKZ1dRWjIwRjZsNk93bWlkemoxL0l1?=
 =?utf-8?B?eERGU0VJWENyS3d5UDE4NVlQVXZFK0lMYUdGMkVENWFHY2liOWlwdVFDdDVx?=
 =?utf-8?B?YnF0SEtYb3piTk1qNitrOTRtdFFqQThNbG1jTHc0OGxWNkp3cDhtM1lhb2lh?=
 =?utf-8?B?ekh5TGN4NFRMa0tXRmR0b01xUUh0UGhyd0R0RGdoTmRFWWNNdWZidlRYYTV2?=
 =?utf-8?B?bzcwNW94NUdKNFQrd3d3ckVVSWJHek5HaWNsSmhpTzQ3cjQrWXpjVUp4aFp5?=
 =?utf-8?B?aVd1RkpmTXRuNTRuOUN3NGpDMFpHbERZWHFDV2c0Y1NPVHRHMDJkeGFxZXJy?=
 =?utf-8?B?NkNIWDE4YVYrTU5YTFpKalNUYmFEQlZIT0daZjlpVFlCRWRoU0w4UFU1ZUJn?=
 =?utf-8?B?ckM1WXMvRUZJUE52WlpQVWE0S29GMFVZc1RNaVZieTQ1ZEI1YjdwNFBlNWhU?=
 =?utf-8?B?M1p3ejlrWDVuaGxZQVZRTlZyd0RDN1pFRFpLU05XOTVGNEFmbzk0WDFxYUdD?=
 =?utf-8?Q?uqxH5B1gDXMfQI8c1dNVHNxrX?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef63681-9acf-4258-54eb-08dd78021e8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:34:25.3560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ad8PQx1JV+zA2jdoNDnDGfg34AAKI82kOmVn4pw3jU4uJwliQisY4QBcxWcqsbs2xOEnsIbd5264nEJYlwvzyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8585
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPiANCj4gVXNlIGd1YXJkKG11dGV4KSB0
byBjbGVhbiB1cCBpcnFieXBhc3MncyBlcnJvciBoYW5kbGluZy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1i
eTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo=

