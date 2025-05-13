Return-Path: <kvm+bounces-46401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DED88AB5FB4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 00:59:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 363654A0B5C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3343E21420B;
	Tue, 13 May 2025 22:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Puw0IERs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE79B1E1C2B;
	Tue, 13 May 2025 22:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747177147; cv=fail; b=E4hDXTipkjQGazlpPXQiQfI09s6+evmWCyi+QPxtygq8uWScsOwvYMTKukJUatv//ZcvDRvB9y0dYVElFFiyCHZHD725glpqZ5xKuSuUVyPHtls9Cq+WMylmkR7yopdzYkeH+zvXyEPiS/LjGFw3xS/jc/NgFiXvKoJqHGAyapo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747177147; c=relaxed/simple;
	bh=LSHcqF9Lm3GtUsI5poGk1GKeR4C/KKNJsCM1LM99TW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IBJ0ALZaPXuPR6OQtCpDGmQNRBAbAi1vM+zCdJoMeCi73rU+vJcVTqfkxb//acnslTMGYv/7tGk5l4j+DtV3AB86OCE0HPoi3Nc5+AQNxPErW2Ozcruxwt8t6mdRXgP/GO8sEThN77eXuUrX9XZpK83gUW27fQWT/IIGl5HzsN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Puw0IERs; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747177146; x=1778713146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LSHcqF9Lm3GtUsI5poGk1GKeR4C/KKNJsCM1LM99TW0=;
  b=Puw0IERs1bVcbW/z0Tuxt5DtyTXhfpUKncaJSCWAv9N15ltJFBZRZwXt
   7y/DudCDieq73P4jnNuuVjx/IK3YAs2VJFZN4etxiRd6Fuh9qCrkqCir8
   JUIEvRdHTG3CtPHWrsGNwt7ynGT2tT2YH42vAMGMNoSVVmMEK86qGnjeM
   /7MEs2WpOmPBusqzHhU5xetSvgpDmjez0QesJqoALPLKA4KXuvJNRf+hM
   OMI4YKf5E3oiSQu0hFT4McTpjSqh7fKr8qc7OGnNQb9rw+jZsSbyMCJKF
   +lL8M29kqYpG4ddGC6oosUM/lnQozBdT3F1uF7VtdfszNyPyIuti+RpmQ
   Q==;
X-CSE-ConnectionGUID: D4TpBfZ5T2qSXwMs/G2QVg==
X-CSE-MsgGUID: CZe/xLvaTayEBu7jKSliTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="52713999"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="52713999"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 15:59:06 -0700
X-CSE-ConnectionGUID: 0Uzz8xbOSQyucokmAoxCKA==
X-CSE-MsgGUID: bDe+pXjZQnK652OOxawyHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142956032"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 15:59:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 15:59:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 15:59:04 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 15:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPJ/N1mHn0ub7Juik6KS3wNJebKd28ClwEi8No4Vmn/kej0j3o1WLYf/dg74BTNIB52TaZrS74xeo/MhzmDSSJ2P6NGxJfl+InvCJ/jXWOwLL/SQ4A+qj8plC2RUSpUAP3mHQzbpdiaJ9gTKVBDjssH7oKALzWzl9YeZYCjG/XpCyyruxPVl9wNL3fwz4+mQ8pvueZPeZ6GgeioQQDDEsEAyHIxN6cgAeN9QyVgxLJCr7k2RRbeTD0ENEH0/CkK7MmQ8Q84zPCnBkTckl5JwRxIwMBh2IYFY2T4uM2hzanXKQ/O9fy3ikpNnIIZ80Scc+gkR8o+k7sCoPovYeWnzpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSHcqF9Lm3GtUsI5poGk1GKeR4C/KKNJsCM1LM99TW0=;
 b=WMpDLByBoFDSGi7szp0RjIblp94kabiNC4HFHkwsvC44N4iS2VfbAVvmxbZ2D5eXZGRoYWUuedlC2/PcK6dXG8C7EQgvb3KN8eLimrD4ii3c4HtN3GncUEz7/zD3mMcjZPdHmRHnukBicpwcHBav+XYjUxlLVhLoHfl1ZYM5AZ8PsxFqvxdECVkY+gYXESoos/SOGxgDMGifZ0Nh227zbu+q8yvStwrzfyhiddLX84aMblLrVJvPgjbsCMRHYBoAmeq+g3AGcG+2ZUdeYlBG/IzLctD/IJ5RM1z6SXnBRg/i+AL6ehj3XmDXYR0BxIPxBW+BT7c9XVK3dLSGuEdfxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5970.namprd11.prod.outlook.com (2603:10b6:8:5d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.23; Tue, 13 May 2025 22:59:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 22:59:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 19/21] KVM: gmem: Split huge boundary leafs for punch
 hole of private memory
Thread-Topic: [RFC PATCH 19/21] KVM: gmem: Split huge boundary leafs for punch
 hole of private memory
Thread-Index: AQHbtMaFg/GSMt27wkiz0Tsmzyey2LPRS66A
Date: Tue, 13 May 2025 22:59:01 +0000
Message-ID: <5749b89695679d21542efea03035dc5a682fbbeb.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030858.519-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030858.519-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5970:EE_
x-ms-office365-filtering-correlation-id: 7e16743a-cdd3-4e5a-8628-08dd9271c0ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cjZsQ0I2Wis4VkUvUGRHbGh1QlVhSU5TMFJOUVp4M1ZlNlJlM0JTSjBVL2RE?=
 =?utf-8?B?MGVmQmxMcUxQaXB2SHI5c1lNeXlLRFdVcmxVYUgzdHlFU0RTMjNRN1RMcjlK?=
 =?utf-8?B?Ni9CSVVaWS8wVGd6VWkwbUdmaFp3TnJESldWUU9aZFVUQ2ZCZWpXUlkxNm4w?=
 =?utf-8?B?Z3plNjhYc0RWTGdZR1hZUUZNRkZ6WkRaQVplc2NUUjd1SlJ1eFpNbFBEVEN4?=
 =?utf-8?B?STJOSU9TVlhXSjRXT2R5Sk10M0xPeEYxQm1sUHFiSjNuZnFUbDcvZ1JMZmpX?=
 =?utf-8?B?VUtmd2E0L2ZXQlAxMU5DQjVCQ0pLN0p3Vzlxb2ZjTFdaemZxaGNzbmxxMC9q?=
 =?utf-8?B?QzNoSHZ6OUVhWFZ6NC91bjNEUTV3Ry9iNmd3bW00eWNUZ0pmL1FtMzhWTG1O?=
 =?utf-8?B?MUR1S0h2amVhWUtlYnMyVjY2MnFCaFB1czhVNWxTMjdtMENORDhWK0dya3V5?=
 =?utf-8?B?VFU2czdXVzl4R3g2OTZ4eXJMaXhiZ2lRdjcwakswRDRtdWsxY2xEaWdQbFkr?=
 =?utf-8?B?dkU4RVFIMXRkeDEwcXF5TWFQTVNUdVBJd0VSVlgrbkVxS0VpODhqTEpzZmx0?=
 =?utf-8?B?M3VPOGQrVHBGMm15MWFyMWFaaW9zTVdCNWtFTktHUSs1RFNEMitKVE9Na2ts?=
 =?utf-8?B?cXpEbmI0bHVoTXZzN2JoSUtWMVp4R0oxaHZ0L0xURVRCY01MeUxLZkNuZ3JY?=
 =?utf-8?B?YUxGZitXZVFoUkpRSEV4MGFpUlBNeGUxVlMxVldwZStQNWNiNWJnMTFsa3ZE?=
 =?utf-8?B?S3VySUEwZTY3dHFqY0FUZ3NVWVpCVGZnQ3FlZ3hqRlo3ak9zNnlzelJYbkUv?=
 =?utf-8?B?WnMwNThETnFRQUN5aW1wbHVLVHhTeUpiaWdMNHNtME1VTzMzNDBEbTllZzFH?=
 =?utf-8?B?WCtqaUJqRWIxQitqMkVXZWJnam5ZT2JVUzNML0RuOFpMM2xJZG1HWTBWSU4v?=
 =?utf-8?B?eUdtQXJwVHkyaXhXRlJmVU1weG9kYnl0LzJCbFBVbEovUWRoL1hzQzJmb0M2?=
 =?utf-8?B?eXRpa0o1SzFzcGU0aGUyWXp3dkpHQmVkM3lvUFhuMDc2S0tRU0FkV3lROXdD?=
 =?utf-8?B?VzZPYk5IY3NnQ29STTVZRFJOaktCU1E0cWRmWm8xR2t3MzJBRDJpY0t6QVll?=
 =?utf-8?B?d3hOOGsya2RmTjJ4Qlh5Wi9UdHpMRXNSL1ZZRS9vWTZ3cWxoSVRwZTA4YU1U?=
 =?utf-8?B?TURlUGY2c0VPS24rU01wWnFRbW1MU2twbVVNK3IvakdHQ2ZxUm5zbXh4REpO?=
 =?utf-8?B?Yk0zTEJ5S3IxL0JaS3hTSTZLa09DRndsUEFoTlFWamhUUUlWNjZQMkdKS3hL?=
 =?utf-8?B?S1F6aCtJODBLQUlKWFZGQkFIb0dhQTh0SDVxUzFNV0lmaEI2dWNLb3A1Q0px?=
 =?utf-8?B?RG9Jc1orOVQ2UnRwcnlKR0o2KzQwRnBNejd2MUJ1cjBIWUdXMGZiSU5DUFZO?=
 =?utf-8?B?Rm9LTm1GTEF5MXlTcmxBbVBoTGo0S09OMWV3QmVZaUpDM3ErRjBDVms1bE9U?=
 =?utf-8?B?b3hxdEovYWZSbkwrK0ppOTRVNGJoeHFlMTJaM3k1QXFkejI1Z2lRMDVOWnJQ?=
 =?utf-8?B?UGtCaXJSdGZEbnFraXFJTEdSNEhaU25yTy9tUlBaT0ZsWkJFSTFWWmVQRUtn?=
 =?utf-8?B?ckZKdXNmWFZSLzJFWjFtbHZkREl2Y1lQZjV6dEpaMWk2YzU0MEtzbXV0RXJN?=
 =?utf-8?B?cC8vN1JZa2k3ZEoxZWNwTXNOWW5odGZWeWp4Mmk1Q0I1VmtiSmZtZEg0KzhU?=
 =?utf-8?B?aWZZM1dtcEJBQ0s3dG02dVdhQ1J1Zks3MEJaQStCQTY4dHZ6aG9oRnhHeDJh?=
 =?utf-8?B?TGdvUXRXaG10UGZqeUZ3azNWREJtZExoVUNWT0l0anFVL1dYa2dFaXE0S1NF?=
 =?utf-8?B?WUR2SUx6Skhpd0tLR1FIMXJvNjhFQTZsNkJwa2Q5NVpiMkt6TkxtbFo0WUdn?=
 =?utf-8?B?K0dnR1Fram9xMWdiekNaRWthbDhRQ1N4aEZwR0tkSXd6Qy9NVWhjaVg3Y3Bp?=
 =?utf-8?Q?HFfQslcytnZdbEtvXtaFCnmeQD8rc0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkg0cDVOUVNOTWN6WktRbE5oNkJHam9tOXVQclhGK2dlM3BJUzhmaUFoMkhN?=
 =?utf-8?B?bDY3anM4cE1jSlNYOTVqTkpEazJCRW11dml1eEhWMWRFWG9hRjgxR2d0aUhI?=
 =?utf-8?B?cUgzaXYyd2JSbVB1Yk5ma0NuVnkzRXZoUlozeU5pN0cxYUFVSlA1b1oxOTZr?=
 =?utf-8?B?ZkQ2MWdIaEZ5eDVpSXFIUmJ0SEt5VTRvTyttYUQvY1E2SE8rUVpOdXZwTmh3?=
 =?utf-8?B?QU1jOWRPY2RmOEFTeGVCdHhrTWJvelZHZFFzcG44WGprcE03K0J6SkNwZ2FD?=
 =?utf-8?B?Z2lMUmNveWVzekNZck9MQkUxTENraHJxdGs2RGpUMEY0dy9jSDRGNEFKc0NW?=
 =?utf-8?B?K25KdCtmZkFKTVM1QWU0UXlnWDUzYUR1U0VsZUIra0tuOHJkK0pWMGlzUUJs?=
 =?utf-8?B?SXA2QXpQY2tmYTJMeHprYXl0N0ZlUnIwVVovUHV6TWd2dm50UU5lNU5lVnJG?=
 =?utf-8?B?YTRYeHBGNS9oaDBaWFV6N2dUdUVOeit6K0xwd1gvaTI5TGRtSWxnck1raVBu?=
 =?utf-8?B?VG9TYkhqbjd3UDRaeGVheTlKNlRlMlNmMkJNS3BYVEd3YVFXclExckw2dHlY?=
 =?utf-8?B?dWhySnNJbnlnSUdkYTRCcDZNbUlIcjBHSHFJbXZ6aU1JYVMyekJJQTdMcXlX?=
 =?utf-8?B?aTd6ckVmUGlxT1VtcjlQUWl5Q1U4bTFMSHVuNE9UQlE2cndTMnJoaGE2RG5Q?=
 =?utf-8?B?OUg4Z1pWSFNtalRDNkpxckpqQ3dUMnNObDJ0WEJ5dHQ3WXU3RDVabDJSSlRF?=
 =?utf-8?B?eHBPRXh1TFpsd2hTUHFLMWZoR2NGVUV6dkNSU2lCOGg4QXYzK3oxVjl5Q3pE?=
 =?utf-8?B?YW9LRnZMU1p0a3ZJdG81SXZpL1NrQk43cjVOcDJlYmhMSzZWN1pmRG9Gd2F6?=
 =?utf-8?B?WnNaektMejNDQWEzcHlLdjcxN1lrbnVXbGFEZzhySklXakFQMFI3dHVLcU0v?=
 =?utf-8?B?emx2ZDk2S1MweUE3WUNBWW1ibk8xdGJOZndWQ0RuZTZiNnV3SHFPQ20xek83?=
 =?utf-8?B?N0NUNHQ2dTZGaVlpZlc5b0o2Lzl0SGM3RW9sYVdCRFZhMERyUHBxWS9PM0FW?=
 =?utf-8?B?MWtmRHNidGRDVnpjOXVDMHh6ZVhIeHBPR2NFNmZoMEZLWC9peU5SZUxpd0Zi?=
 =?utf-8?B?YnhCYXY5Sm1SQVdLTTVvd1BnWDhheE9iVjQyMDhuNSs0dTFEL01lN1o3RGdz?=
 =?utf-8?B?MXpiZ3ZZWTFwZ05PRWczejNYN0ZjNnNxVWRkUTAvYllyNXNIYU9nZ1d0UUI1?=
 =?utf-8?B?VnlFeGlOTlloSjVrbEpyeFpiR3ZHYkh5ZXdubmY0WThSdkpxbnNpMkFwT3Nu?=
 =?utf-8?B?RzRJbE42amswb2w2eGYwWWprNjV6RnYyQnNGRldmQmlleWlOcjNadlBvMmVB?=
 =?utf-8?B?RDNTbjhDNVRjNHRYYmoremp3c3lES0REZUgwOXVKZzBXWUpRd1NYQ1lscFEz?=
 =?utf-8?B?bXdiT2tyWU10bWJ4ZkRQNEV1SlQ4RUxzUm56bXpwQjFKNWxNUGpYRlZ1MUNo?=
 =?utf-8?B?SkUveGVEVHlsU0ZtQS92aGlZRHFRbXFPams0YThuSitORHhUaG5uWWc1Qzdv?=
 =?utf-8?B?UWpXRFlvRVFxa2V4WVJDTFlaaFBxL0JOQjNIbGpFZ2pJWUpiRVorYitIdE9V?=
 =?utf-8?B?NW9qa0dJZ0lYNVZ5UnhueC9kYnJERHhJd0N3UkdpeU9ncUVmOSt0Y2YrL3JK?=
 =?utf-8?B?TW9GMEtNbnRPTjhoQVpockFGQ0hlY0U4V1NHVFhCSkw3NkZRTVBKMFV3RlVp?=
 =?utf-8?B?eDRmZHRhRWdiS1U2SVRxbjZ1VGR0ZHl1a2trUU9nZ1oveCt3VHpYVW83VXVr?=
 =?utf-8?B?RngxWVpnN0FhQnRDVHV6NnIyN3R3Mjl3djczU1dPcmpaSmFBekFvT1YwQkVh?=
 =?utf-8?B?ekNZeFEwK2FCMktVbXZ4T3BuRFRaUkpSUE1KbjJaeXN1VWd1N21mazFlbjMv?=
 =?utf-8?B?Ny81eU56MTFjSHRuQ3VLZHpWT083UUlZVHZkNDdKc0d1NzN3NW1HRU9QS0ww?=
 =?utf-8?B?NWRkQTdtUWVwaW44bk5XMDhmTERUSzV6SlY5aklaMzMzWTB2N0txcFh0YTlu?=
 =?utf-8?B?MzhGalpka2ZnVFovcDZzQ2ljV0ljYnpVNGlpNVpFZ0gxOXhXaG9OZ2Z0ZGJP?=
 =?utf-8?B?WGlCQ01vSmhSR1RaQjAvaDJTZHlzb0JtK0ljdWxySDRWNVJuQXlGUmJ6bDA3?=
 =?utf-8?Q?JxCt4udYt6zUHE0flfDNgvU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5E4DAB6D8F72549A9587214A2653AF0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e16743a-cdd3-4e5a-8628-08dd9271c0ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 22:59:01.8330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mIVdt76a7fMc8eKs/wv/Clolp2tomW/RMj1TeqsP7ZMDfI7KiVBFWlkU/WKQMnOTOmQnT2efLmApWsTw7i1URgeAw2RFvhF+7fGPmiWQrNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5970
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gK3N0
YXRpYyBpbnQga3ZtX2dtZW1faW52YWxpZGF0ZV9iZWdpbihzdHJ1Y3Qga3ZtX2dtZW0gKmdtZW0s
IHBnb2ZmX3Qgc3RhcnQsDQo+ICsJCQkJwqDCoMKgwqAgcGdvZmZfdCBlbmQsIGJvb2wgbmVlZF9z
cGxpdCkNCj4gwqB7DQo+IMKgCWJvb2wgZmx1c2ggPSBmYWxzZSwgZm91bmRfbWVtc2xvdCA9IGZh
bHNlOw0KPiDCoAlzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90Ow0KPiDCoAlzdHJ1Y3Qga3Zt
ICprdm0gPSBnbWVtLT5rdm07DQo+IMKgCXVuc2lnbmVkIGxvbmcgaW5kZXg7DQo+ICsJaW50IHJl
dCA9IDA7DQo+IMKgDQo+IMKgCXhhX2Zvcl9lYWNoX3JhbmdlKCZnbWVtLT5iaW5kaW5ncywgaW5k
ZXgsIHNsb3QsIHN0YXJ0LCBlbmQgLSAxKSB7DQo+IMKgCQlwZ29mZl90IHBnb2ZmID0gc2xvdC0+
Z21lbS5wZ29mZjsNCj4gQEAgLTMxOSwxNCArMzIwLDIzIEBAIHN0YXRpYyB2b2lkIGt2bV9nbWVt
X2ludmFsaWRhdGVfYmVnaW4oc3RydWN0IGt2bV9nbWVtICpnbWVtLCBwZ29mZl90IHN0YXJ0LA0K
PiDCoAkJCWt2bV9tbXVfaW52YWxpZGF0ZV9iZWdpbihrdm0pOw0KPiDCoAkJfQ0KPiDCoA0KPiAr
CQlpZiAobmVlZF9zcGxpdCkgew0KPiArCQkJcmV0ID0ga3ZtX3NwbGl0X2JvdW5kYXJ5X2xlYWZz
KGt2bSwgJmdmbl9yYW5nZSk7DQoNCldoYXQgaXMgdGhlIGVmZmVjdCBmb3Igb3RoZXIgZ3Vlc3Rt
ZW1mZCB1c2Vycz8gU0VWIGRvZXNuJ3QgbmVlZCB0aGlzLCByaWdodD8gT2gNCkkgc2VlLCBkb3du
IGluIHRkcF9tbXVfc3BsaXRfYm91bmRhcnlfbGVhZnMoKSBpdCBiYWlscyBvbiBub24tbWlycm9y
IHJvb3RzLiBJDQpkb24ndCBsaWtlIHRoZSBuYW1pbmcgdGhlbi4gSXQgc291bmRzIGRldGVybWlu
aXN0aWMsIGJ1dCBpdCdzIHJlYWxseSBvbmx5DQpuZWNlc3Nhcnkgc3BsaXRzIGZvciBjZXJ0YWlu
IFZNIHR5cGVzLg0KDQpJIGd1ZXNzIGl0IGFsbCBkZXBlbmRzIG9uIGhvdyB3ZWxsIHRlYWNoaW5n
IGt2bV9tbXVfdW5tYXBfZ2ZuX3JhbmdlKCkgdG8gZmFpbA0KZ29lcy4gQnV0IG90aGVyd2lzZSwg
d2Ugc2hvdWxkIGNhbGwgaXQgbGlrZSBrdm1fcHJlcGFyZV96YXBfcmFuZ2UoKSBvcg0Kc29tZXRo
aW5nLiBBbmQgaGF2ZSBpdCBtYWtlIGl0IGNsZWFybHkgZG8gbm90aGluZyBmb3Igbm9uLVREWCBo
aWdoIHVwIHdoZXJlIGl0J3MNCmVhc3kgdG8gc2VlLg0KDQo+ICsJCQlpZiAocmV0IDwgMCkNCj4g
KwkJCQlnb3RvIG91dDsNCj4gKw0KPiArCQkJZmx1c2ggfD0gcmV0Ow0KPiArCQl9DQo+IMKgCQlm
bHVzaCB8PSBrdm1fbW11X3VubWFwX2dmbl9yYW5nZShrdm0sICZnZm5fcmFuZ2UpOw0KPiDCoAl9
DQo+IMKgDQo+ICtvdXQ6DQo+IMKgCWlmIChmbHVzaCkNCj4gwqAJCWt2bV9mbHVzaF9yZW1vdGVf
dGxicyhrdm0pOw0KPiDCoA0KPiDCoAlpZiAoZm91bmRfbWVtc2xvdCkNCj4gwqAJCUtWTV9NTVVf
VU5MT0NLKGt2bSk7DQo+ICsJDQoNCg==

