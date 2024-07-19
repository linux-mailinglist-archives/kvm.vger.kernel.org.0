Return-Path: <kvm+bounces-21930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D54E937953
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50A891C21EE6
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 14:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5396A145334;
	Fri, 19 Jul 2024 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cRVIu4V4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895AB13D532;
	Fri, 19 Jul 2024 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721400271; cv=fail; b=im5Je3JoZTW4bq8GN3BpMrc3nr2N4sYTcTF5cYGgV9+gGSJuwycfKSdvasXcVzJWTa3Zj+1DhZ94IwgzcAYeeeqz+CtmFQE4WVE8YNNmTRu3hlZ4LEqI0irFfmYorpOKX6LL1mRKdCVHUVyuNX+NPt6pyPz/NB9ApWs6Zfh+SDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721400271; c=relaxed/simple;
	bh=Xxm0xYZIX7WX1gIMqPyFkKQJcZnRF09FGPVRGu0otoQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bm3glTJgSFmXHetx9t5hMa8rrNl8XDuk7lKVOJ5xce1R9Pao0rflaOxSD2k1CAl+eENmLHODPkLEzxmm5Iape8cdBzdJoO/EA8MIXVEGKmKRTYnJ79yJEz33qQ9Qz6ZVNfxuTS0ByWkk1KGey+xnm0j4g0PA398dMSLle78g6Xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cRVIu4V4; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721400270; x=1752936270;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xxm0xYZIX7WX1gIMqPyFkKQJcZnRF09FGPVRGu0otoQ=;
  b=cRVIu4V4/bwKi1Gv1gWcEv/FIYsy/DONJKhJp3d4hXPsDGkeATMT8uCl
   e44u4ruc6HTw8zBYodMSBECO6mfbQo3ZyKO9cmam1AEYv6YV11sRj7+nC
   PUlW8+mzVAz5U1BMRTeXWaWvyaNJG0oUWlznrCesHhbChmeyN7o7W+g4S
   vJx0G2VhbJsVMRQnFPY5oYUNczR10kCkw1vtn1bWzzH+JbMcmtkDxV57g
   zz0fwWJiwNHOpt/lSiu59OWqApxmsIKdRwVSLQ1Y64ehtBWESzBlQhhAL
   8ijLOWKoGNI2acGLSG34X0zMs5b1uhDsQaSs96TSTEOhUmEARtzIqiWhM
   Q==;
X-CSE-ConnectionGUID: nHHzxbWZQLCbwpvaqTHIyw==
X-CSE-MsgGUID: gglrCYuARh6m19poB3Xdig==
X-IronPort-AV: E=McAfee;i="6700,10204,11138"; a="18718424"
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="18718424"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 07:44:29 -0700
X-CSE-ConnectionGUID: GBiPpJTQRaOOVInWSQhTdg==
X-CSE-MsgGUID: 1rdnnP8zSQi0ANGdwas05Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="51866019"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jul 2024 07:44:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 19 Jul 2024 07:44:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 19 Jul 2024 07:44:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 19 Jul 2024 07:44:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBDZfDc+nncMDLc2l28b3MOsyyVYLtNTOrKdjaJQio7CsHZ7PXYHppCxbcziJJzvzNbaaaYhPXL9hx14BMQqmij0U6cwgUWfVi5R2kjCm3ma9VW3vYzj0iJT8M+cKMyPxjnIRNjVMBb69f1CO29/x+UGWsC3ngDzfBlJaAanvkzoIFXU6yDpVg/hccz+ao7WhUx1/zG1lyJOZztA02CAzByVYPZzAVvQRMHPf1GC++0d0Y33BC/ElXRMUsOiOf3MK+XyJNtzY3p6ELOuQqNuFmtbk/MeeGZwh/NLcDVWQZctq6i3P7sgEhXKMlpIM2WJ12qRgDl7P9ea3mZ1STqKFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xxm0xYZIX7WX1gIMqPyFkKQJcZnRF09FGPVRGu0otoQ=;
 b=RF5eiG4IoKqswgMN4QEyWViWR/432sJhtsM6vfuVXQ4rGtpVB8R+plTHuX01JOQN2qc06PjROLl3a9hZgNxxFJWVavskmZdMRegJy79Q4md5dZnLJxXfONO2eSe2pTkWDahCjvyRR9bkGfC94m8hEgLc4UOqlgXSk8V6izHueUOzxdz9cim1tWSp+fiEcolumiHdXRwPyDM5iT+FweOC832thQXCG+oOAKlxR+iC4lQVkjzEB8Q4WMtFJNPOxHeKJCOhzvBVJqOa1D1GwtBmwu8eavE00IiuatJRdwdgxpXv32JxTxiMqadW3RVqmbN5XpHwRiM+2qvwrsnoplztpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA1PR11MB5780.namprd11.prod.outlook.com (2603:10b6:806:233::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.29; Fri, 19 Jul 2024 14:44:19 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7762.027; Fri, 19 Jul 2024
 14:44:19 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Sean
 Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, "David Matlack" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Peter Xu <peterx@redhat.com>
Subject: RE: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
Thread-Topic: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
Thread-Index: AQHa0yM7POpElz68ZEeIzVnb9wOHdrH3jBVwgAU34YCAAKs9IA==
Date: Fri, 19 Jul 2024 14:44:19 +0000
Message-ID: <DS0PR11MB637372143BBA7424D2E2EDAEDCAD2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-9-jthoughton@google.com>
 <DS0PR11MB6373C1BE8CF5E1BCC9F2365BDCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HVDUG7OSN2ERmmiXeg8eT8D6edoSiqYKsnjAnVbhGAX9Q@mail.gmail.com>
In-Reply-To: <CADrL8HVDUG7OSN2ERmmiXeg8eT8D6edoSiqYKsnjAnVbhGAX9Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA1PR11MB5780:EE_
x-ms-office365-filtering-correlation-id: d61b8a64-4ffc-44d2-5518-08dca80145a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?THNmYVA3RmY2TzZZWmgrM0NITHk1RGpHWXlKL3hWZStoc2RWODVFZTdqdHF5?=
 =?utf-8?B?RkJrdFpJUXozT2VpNCt2cnkwUlBGVWRXWis0WEFPWFFTa1B4eUxRZC9RdXhF?=
 =?utf-8?B?eUI1dVJBMUZ5MTNiRmtaS2VDTGtFc2NvZU9INDdMeGNIckxyaDU5S3dVZzkv?=
 =?utf-8?B?cHd6MmV4aVhmeURXZ1V2UER4VVhubDR6alFuaEVZVHZrYWd2c0p4OURQLzU5?=
 =?utf-8?B?WDlSZDIzNnphTHd0MWpkRE1teWM2OWU1Z3hDU0NXSXNxc1JURUNPRFNUMjY2?=
 =?utf-8?B?eXBTUWkwcEZYYWJxSXd5a1RKRGdxamxYNG94T0pyV2FzeFBGMkZLY3dSNmRE?=
 =?utf-8?B?ODlFRUwwV3dSaWNERnlMLzY2em1ZcEozUkNPdzhiZUN4THpIWStha2xjRE5U?=
 =?utf-8?B?cXd2WlliVUE5TXUreWthdERMK0dNTERyM2UzenNPTTA2bC92dlUzQjF5TXlR?=
 =?utf-8?B?ZFFzWDN3dnF0Y3lOYnB5UEpGbFVZTzdDQmZDTzRiOGM2ei9KK0R3Q2c3MGVx?=
 =?utf-8?B?c1ZtZWRFQ3I3SFppVG1oUVJrcWhJUUZEdFVrREpHdFZsbkFRb0dpdzYwQ216?=
 =?utf-8?B?UmVRWlAxRGEvU1VMQ215SmZyWFBuOXMyYlRXV0xzVzdYUzdpa1FRcmQwRFhF?=
 =?utf-8?B?eGs2Z2ltUnhYWDRFWDFJY1ArcWh1NXM5ZUZQSm03MWJ1RWNZSjk1UVF3V2RV?=
 =?utf-8?B?ajZHSU1ycW5KUlJCL0NubmRjN25YRlpub3ZhcUZPRVlTZ2NTc3hTb2ExQVpR?=
 =?utf-8?B?dU1XdU1wdW1uWERkUmRYTlRab1BmYlQxUDloaFVUZ1BPaFIxUEg3MEtUTm5J?=
 =?utf-8?B?TUo5ME1tWkhuaU9PYU91NHdydzBac2NDcWpJYUZuUCtwLzJHNWM1VlRSRnhC?=
 =?utf-8?B?R2RaMG5HVzFwYnFUZUtoeHVBNkVtWkNxdjFzQmFhbWJJRXloWTBHVTNFaFlh?=
 =?utf-8?B?RTJzU3NHalBTQ1R4V1F3eC83NWE2b3l0RGN5VUY1MWFmMy9UU0lZSGZXSEdZ?=
 =?utf-8?B?UjQzcjdreW1KVmR1OWcwcitkMUhUWFBpbm4xNHB5Ung3YnlnMWkrRWlLbUhU?=
 =?utf-8?B?Y3MwZG5KM21XUlU2NjhPSkhDT1J0eFIxcSsrOTE3K0NPc1UvS2ZNcStpUk9W?=
 =?utf-8?B?b3RwUm1USno4RWJ6WmRmckwvSE82YlZTaWxSNm0wSXkzNUo2U3kwSlhGNlFT?=
 =?utf-8?B?K040SEd2N05Ea0xPS01IRy9DaHppaXZaQUZ4UDNYUDNIeDFhYysrbTFuRFZy?=
 =?utf-8?B?TGR6Z1NJeGxjNjVkU0tYK3lwRFFiRHNqKy8ySnVNajBDZ2tjeXRueFY3WEZn?=
 =?utf-8?B?S25xUE9Md0Y3STNQNGJQK2NHa1llMlh5SEp0S0YvTjRESTcvUW9udXVaTXFt?=
 =?utf-8?B?MVF1VHlUR2xGK3E0WWlnOXpEb3d5MWF4ci9CWG9MY1RqcUdqUFNRUWhvQk5K?=
 =?utf-8?B?VWNueTJRTHJMdStmcHdQRFpJTVRUTkE5TGozbnVkQWhzZjd3TVo4eWNtU2Rm?=
 =?utf-8?B?Nk44ZVRtUmF3c1JGWHk2OVZWT3A0NXF1amk4QktZVlZBb2lvT25RczNsQjUr?=
 =?utf-8?B?RHIzN2U2WSsyMDNnYTNvOXBaWHBSWmlDK0crZ1ZlNksvSUh2ZS9YM05RRVZY?=
 =?utf-8?B?d09NQzN5OEkwWkx6VGFqekRjNkw1RkNEcHlqOGZJaU1vV3o1NWlXV0JZRFkz?=
 =?utf-8?B?L3llcC9PbWlhNVh4aEhTT2hnMmpwMkJuYmlzc1NJRHMxRks3bm5VakRYRnVZ?=
 =?utf-8?B?R1craDVDN3dabGZoakxwejc3RGNNR29PNmIrNE93aUw0YjBFaTMyMG84U1Vz?=
 =?utf-8?B?K0ZvUGxYaFB4QVo4QkhnVW9mYkwyNXN1bC9hakRaeko2WlZEckhlbUx3K1J3?=
 =?utf-8?B?dWVJUWFKSldhWnlFZjZwSE13U0k3VGlWc3VIdEVRWi94eFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d29vQ3N5YWl0WVh3SVBZblVVeVNEdjNNOVZoS0tGQjhBc2pudVJxRnY4RFA4?=
 =?utf-8?B?WVl0ZmZEaDNzUEJlSkd0Nzh0S0RINFA2TG9yWEZkL2lmbk1LMG1meFpMMFVw?=
 =?utf-8?B?eG1TMkFNbExJRG9DWkF3bmticEhRdlNpdFFUL1kydVZIcy9HMlkxUElZcWwv?=
 =?utf-8?B?WEhxdTRaejZkQWY2SHY1dEtLbzRCajBlUXZmODNKVW1yVGMxU2ZIWE1ScFRN?=
 =?utf-8?B?OUlBN2tQaUVvWlFRUHpXcGVFcVkzRFpCbVF3cWhiZjltY1hKa0ZSVmJSTmlV?=
 =?utf-8?B?WFdpL29PQktZa2gzTHRrNmFhQlFSazJEUHRmWjRQd0FBdFBjYUVSekNkQktW?=
 =?utf-8?B?QkkvRVlwdXhWMm9ncElaQnZZSmZPVEJ3ek5zSjFSZmEvcWEwY2FIWFA3dUtG?=
 =?utf-8?B?NHVUdWw2dy8vUmlnVXRQcDNyWVZYYVVpWTJteHlST0J0S2lNOE11bllmYlFZ?=
 =?utf-8?B?WSt4RCtaczVVV3VTQXVSNkpFZGw4ZnlHTlV6WFYyaktreVZpcFpxeVFCb1Q4?=
 =?utf-8?B?di9BRUMweTJDR1MvQldiRm1jSUh3dGFtQjlBMU5DOFBIcFRQWG9XdDNxei9R?=
 =?utf-8?B?T0Z3TE80SHlBZElSd3lJTG5hMUtYTVRWYXJRVVV3VE9RTnhoV25wV2pRWEdo?=
 =?utf-8?B?TGFmZnJkRzFnUlNXRGgyN0JLaWdnMlhQMHF2SnAxR3V5TFdNN1RaUnpwMENy?=
 =?utf-8?B?NXhmZHQ1QlpIU29qWVVFVU1PZkMwZE5xRkZaNEQzME1WN1dWTC9sNHd1eXE5?=
 =?utf-8?B?MU5OenlGMmlFWXpnZFNFZlFXU2g4MkFrd1lpTHVFcXFCZU5US3lzRVNVNktR?=
 =?utf-8?B?SGw4RTFTcEVrbE1CN3NVcXl0bGd0UjZIT0ZCM3JzUTBSVzhNMVV5K0hCbUFD?=
 =?utf-8?B?MCttZXoyTTNEekV0UTNVekZLZWg4TjFvSzRTOGlmZ1lkUGR5eUVDZ2Y5aHU4?=
 =?utf-8?B?VUZ0b2tDNFpPalRrYysvcHdiM1l1UTRWRjNNemJ1Wmdzb3JoTU9DZW9ZMitk?=
 =?utf-8?B?ZzhLTllrU1VlcVJVWml6aGk4OSt5N0hDb0tNYzJtYnV3ZnhYazlxVVBzaDFj?=
 =?utf-8?B?ZHlxVkhjWFB6aldaYUp2UUlzVG10WTkxSUtNS2pCTnBjNVlRVHRWL3lmWlhu?=
 =?utf-8?B?UHFpWU9ldy9tT0FwUmt6cFlEUytOOEhvbFNzSWhESS9FQTNGaUYyNkRKRjNK?=
 =?utf-8?B?WUVrRUN5eHc4dFdFZk5vTzczM3R3dy9GTlh6V1puaEtWY29FcjdMbHdMZjlm?=
 =?utf-8?B?cmRXMkJ4NVdPY3lVb042TlpQNXBZSS9SS05oa2VPMjVFNmg4aWVDT1VKWm9L?=
 =?utf-8?B?czhXK3B5cjh4UzNkYTUxZFlSNlNIZXVMLzAwTzhoRHhjd3ZWaVJWUWZnQ1ZT?=
 =?utf-8?B?TWV1RDhJWlU0SkU1dnk4aS9ZNnY1S1BSTG1hZzl6Uy9Zc1VjVmxpT3RXeXVH?=
 =?utf-8?B?dG1LMWdDNHBKNzBocnQ4YTNYRXpNSjA2c05RV1VaVjhFQ05ESllpazZUSEFI?=
 =?utf-8?B?UzBQazlBTDRmR1Z2MURaT0tvQmx5Q1JUZXR1NmZmRVppOUt0blU0U3pTTGJj?=
 =?utf-8?B?STVEM3d4UWJVUmpqVWFUZkZ6Z1hRUDBxQVFJWndtQzhvbEJ3aDA2UXRJTnJV?=
 =?utf-8?B?RktFWTEvR1FBUGFnLzQ2Zkp6SjcxWGlnV2hySHg0SlB4U1JuK0tNZE9sb0li?=
 =?utf-8?B?ZUlad0lSckg3dVo3TUdIcHkzcENzeTRjKzhla3FOSElYT09RRjI1WlRCb2pX?=
 =?utf-8?B?YmtHbHZwQm9xdnBmWmpVZmNqQ01tS0VPVUlxd2VQL09GMUNpZDNXcGtURHNY?=
 =?utf-8?B?WlVQb3BMeDA5cTRlOHRKemVkYnIxVTRkRXZwSm1RZXBUOVVVcVluMEpkSXNw?=
 =?utf-8?B?NE9rOTR3eGI3YnhMWlRXdzVad1RObTJHT2h4Zy9yZDJHUTZiSnAxOG1IUUZL?=
 =?utf-8?B?dTlVRUczZDVleFBZTzA0VCthYzBKMVM3cHhGVEtlTk1GMi85OEMzYWNSY3hQ?=
 =?utf-8?B?SVQzWEhGK0dEWTRZOURrTUI2NFY4cjhPZ0lPRGZFcUg4K0hLLzQ5V0Q4UFFq?=
 =?utf-8?B?ZGRpUFlsWElrOW5hN2p0S01SMjdua3ZXVWZadmJTZDdFNXdHd1VvRzBJRzdl?=
 =?utf-8?Q?2uAzfSLCXdnbOWpUd2Qc2qNYx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61b8a64-4ffc-44d2-5518-08dca80145a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2024 14:44:19.6032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cNFIkD8c+Uas/PsN/UEM8FD8WsOo40lnUZZVtUu4UJQS/YOXrZyGgiqnZnaUNFki0WDTY9cRgjiy4KlaZJQe1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5780
X-OriginatorOrg: intel.com

T24gRnJpZGF5LCBKdWx5IDE5LCAyMDI0IDE6MDkgQU0sIEphbWVzIEhvdWdodG9uIHdyb3RlOg0K
PiBPbiBXZWQsIEp1bCAxNywgMjAyNCBhdCA4OjM04oCvQU0gV2FuZywgV2VpIFcgPHdlaS53Lndh
bmdAaW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IE9uIFRodXJzZGF5LCBKdWx5IDExLCAy
MDI0IDc6NDIgQU0sIEphbWVzIEhvdWdodG9uIHdyb3RlOg0KPiA+ID4gVGhlIGZpcnN0IHByb25n
IGZvciBlbmFibGluZyBLVk0gVXNlcmZhdWx0IHN1cHBvcnQgZm9yIHg4NiBpcyB0byBiZQ0KPiA+
ID4gYWJsZSB0byBpbmZvcm0gdXNlcnNwYWNlIG9mIHVzZXJmYXVsdHMuIFdlIGtub3cgd2hlbiB1
c2VyZmF1bHRzDQo+ID4gPiBvY2N1cnMgd2hlbg0KPiA+ID4gZmF1bHQtPnBmbiBjb21lcyBiYWNr
IGFzIEtWTV9QRk5fRVJSX0ZBVUxULCBzbyBpbg0KPiA+ID4ga3ZtX21tdV9wcmVwYXJlX21lbW9y
eV9mYXVsdF9leGl0KCksIHNpbXBseSBjaGVjayBpZiBmYXVsdC0+cGZuIGlzDQo+ID4gPiBpbmRl
ZWQgS1ZNX1BGTl9FUlJfRkFVTFQuIFRoaXMgbWVhbnMgYWx3YXlzIHNldHRpbmcgZmF1bHQtPnBm
biB0byBhDQo+ID4gPiBrbm93biB2YWx1ZSAoSSBoYXZlIGNob3NlbiBLVk1fUEZOX0VSUl9GQVVM
VCkgYmVmb3JlIGNhbGxpbmcNCj4gPiA+IGt2bV9tbXVfcHJlcGFyZV9tZW1vcnlfZmF1bHRfZXhp
dCgpLg0KPiA+ID4NCj4gPiA+IFRoZSBuZXh0IHByb25nIGlzIHRvIHVubWFwIHBhZ2VzIHRoYXQg
YXJlIG5ld2x5IHVzZXJmYXVsdC1lbmFibGVkLg0KPiA+ID4gRG8gdGhpcyBpbiBrdm1fYXJjaF9w
cmVfc2V0X21lbW9yeV9hdHRyaWJ1dGVzKCkuDQo+ID4NCj4gPiBXaHkgaXMgdGhlcmUgYSBuZWVk
IHRvIHVubWFwIGl0Pw0KPiA+IEkgdGhpbmsgYSB1c2VyZmF1bHQgaXMgdHJpZ2dlcmVkIG9uIGEg
cGFnZSBkdXJpbmcgcG9zdGNvcHkgd2hlbiBpdHMNCj4gPiBkYXRhIGhhcyBub3QgeWV0IGJlZW4g
ZmV0Y2hlZCBmcm9tIHRoZSBzb3VyY2UsIHRoYXQgaXMsIHRoZSBwYWdlIGlzDQo+ID4gbmV2ZXIg
YWNjZXNzZWQgYnkgZ3Vlc3Qgb24gdGhlIGRlc3RpbmF0aW9uIGFuZCB0aGUgcGFnZSB0YWJsZSBs
ZWFmIGVudHJ5IGlzDQo+IGVtcHR5Lg0KPiA+DQo+IA0KPiBZb3UncmUgcmlnaHQgdGhhdCBpdCdz
IG5vdCBzdHJpY3RseSBuZWNlc3NhcnkgZm9yIGltcGxlbWVudGluZyBwb3N0LWNvcHkuIFRoaXMg
anVzdA0KPiBjb21lcyBkb3duIHRvIHRoZSBVQVBJIHdlIHdhbnQ6IGRvZXMgQVRUUklCVVRFX1VT
RVJGQVVMVCBtZWFuICJLVk0NCj4gd2lsbCBiZSB1bmFibGUgdG8gYWNjZXNzIHRoaXMgbWVtb3J5
OyBhbnkgYXR0ZW1wdCB0byBhY2Nlc3MgaXQgd2lsbCBnZW5lcmF0ZSBhDQo+IHVzZXJmYXVsdCIg
b3IgZG9lcyBpdCBtZWFuICJhY2Nlc3NlcyB0byBuZXZlci1hY2Nlc3NlZCwgbm9uLXByZWZhdWx0
ZWQNCj4gbWVtb3J5IHdpbGwgZ2VuZXJhdGUgYSB1c2VyZmF1bHQuIg0KPiANCj4gSSB0aGluayB0
aGUgZm9ybWVyIChpLmUuLCB0aGUgb25lIGltcGxlbWVudGVkIGluIHRoaXMgUkZDKSBpcyBzbGln
aHRseSBjbGVhcmVyIGFuZA0KPiBzbGlnaHRseSBtb3JlIHVzZWZ1bC4NCj4gDQo+IFVzZXJmYXVs
dGZkIGRvZXMgdGhlIGxhdHRlcjoNCj4gMS4gTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9VUyArIFVG
RkRJT19SRUdJU1RFUl9NT0RFX01JU1NJTkc6IGlmDQo+IG5vdGhpbmcgaXMgbWFwcGVkIChpLmUu
LCBtYWpvciBwYWdlIGZhdWx0KSAyLiBub24tYW5vbnltb3VzIFZNQSArDQo+IFVGRkRJT19SRUdJ
U1RFUl9NT0RFX01JU1NJTkc6IGlmIHRoZSBwYWdlIGNhY2hlIGRvZXMgbm90IGNvbnRhaW4gYSBw
YWdlDQo+IDMuIE1BUF9TSEFSRUQgKyBVRkZESU9fUkVHSVNURVJfTU9ERV9NSU5PUjogaWYgdGhl
IHBhZ2UgY2FjaGUNCj4gKmNvbnRhaW5zKiBhIHBhZ2UsIGJ1dCB3ZSBnb3QgYSBmYXVsdCBhbnl3
YXkNCj4gDQoNClllYWgsIHlvdSBwb2ludGVkIGEgZ29vZCByZWZlcmVuY2UgaGVyZS4gSSB0aGlu
ayBpdCdzIGJlbmVmaWNpYWwgdG8gaGF2ZSBkaWZmZXJlbnQNCiJtb2RlcyIgZm9yIGEgZmVhdHVy
ZSwgc28gd2UgZG9u4oCZdCBuZWVkIHRvIGZvcmNlIGV2ZXJ5Ym9keSB0byBjYXJyeSBvbiB0aGUN
CnVubmVjZXNzYXJ5IGJ1cmRlbiAoZS5nLiB1bm1hcCgpKS4NCg0KVGhlIGRlc2lnbiBpcyB0YXJn
ZXRlZCBmb3IgcG9zdGNvcHkgc3VwcG9ydCBjdXJyZW50bHksIHdlIGNvdWxkIHN0YXJ0IHdpdGgg
d2hhdA0KcG9zdGNvcHkgbmVlZHMgKHNpbWlsYXIgdG8gVUZGRElPX1JFR0lTVEVSX01PREVfTUlT
U0lORyksIHdoaWxlIGxlYXZpbmcNCnNwYWNlIGZvciBpbmNyZW1lbnRhbCBhZGRpdGlvbiBvZiBu
ZXcgbW9kZXMgZm9yIG5ldyB1c2FnZXMuIFdoZW4gdGhlcmUgaXMgYQ0KY2xlYXIgbmVlZCBmb3Ig
dW5tYXAoKSwgaXQgY291bGQgYmUgYWRkZWQgdW5kZXIgYSBuZXcgZmxhZy4NCg0KPiBCdXQgaW4g
YWxsIG9mIHRoZXNlIGNhc2VzLCB3ZSBoYXZlIGEgd2F5IHRvIHN0YXJ0IGdldHRpbmcgdXNlcmZh
dWx0cyBmb3IgYWxyZWFkeS0NCj4gYWNjZXNzZWQgbWVtb3J5OiBmb3IgKDEpIGFuZCAoMyksIE1B
RFZfRE9OVE5FRUQsIGFuZCBmb3IgKDIpLA0KPiBmYWxsb2NhdGUoRkFMTE9DX0ZMX1BVTkNIX0hP
TEUpLg0KDQpUaG9zZSBjYXNlcyBkb24ndCBzZWVtIHJlbGF0ZWQgdG8gcG9zdGNvcHkgKGkuZS4s
IGZhdWx0cyBhcmUgbm90IGJyYW5kIG5ldyBhbmQgdGhleQ0KbmVlZCB0byBiZSBoYW5kbGVkIGxv
Y2FsbHkpLiBUaGV5IGNvdWxkIGJlIGFkZGVkIHVuZGVyIGEgbmV3IGZsYWcgbGF0ZXIgd2hlbiB0
aGUNCnJlbGF0ZWQgdXNhZ2UgaXMgY2xlYXIuDQoNCj4gDQo+IEV2ZW4gaWYgd2UgZGlkbid0IGhh
dmUgTUFEVl9ET05UTkVFRCAoYXMgdXNlZCB0byBiZSB0aGUgY2FzZSB3aXRoDQo+IEh1Z2VUTEIp
LCB3ZSBjYW4gdXNlIFBST1RfTk9ORSB0byBwcmV2ZW50IGFueW9uZSBmcm9tIG1hcHBpbmcgYW55
dGhpbmcNCj4gaW4gYmV0d2VlbiBhbiBtbWFwKCkgYW5kIGEgVUZGRElPX1JFR0lTVEVSLiBUaGlz
IGhhcyBiZWVuIHVzZWZ1bCBmb3IgbWUuDQoNClNhbWUgZm9yIHRoaXMgY2FzZSBhcyB3ZWxsLCBw
bHVzIGdtZW0gZG9lc24ndCBzdXBwb3J0IG1tYXAoKSBhdCBwcmVzZW50Lg0KDQo+IA0KPiBXaXRo
IEtWTSwgd2UgaGF2ZSBuZWl0aGVyIG9mIHRoZXNlIHRvb2xzICh1bmxlc3Mgd2UgaW5jbHVkZSB0
aGVtIGhlcmUpLA0KPiBBRkFJQS4NCg==

