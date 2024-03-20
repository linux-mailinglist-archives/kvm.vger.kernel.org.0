Return-Path: <kvm+bounces-12195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F16B8880866
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 780E21F2355C
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E18801;
	Wed, 20 Mar 2024 00:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dPuAGsAm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92900384;
	Wed, 20 Mar 2024 00:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710893488; cv=fail; b=pCbBmUoXxXf5EtEuMun4YNsfv4NyErcMec6ROdhTCNuqCef1/Fn/pAvOlJXlnzKplHeqB+UIgWXEFw+ypjf1/wyK1OAdZJOlzR6KbvN0ob/11ALclilaT76MlSsY6yAyjzDg0j0ALf7xK4F+OTbZvV/mUhuaAZoYMpE/yOx81Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710893488; c=relaxed/simple;
	bh=xPQLWidXMbV5XvBwJnEnSUsm7S8MxStEbMnsJ7XHJPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CYV4ST5btodEqOo8WvDEhULDfoKE2gHu80KG1P7e5gB8YbbVMHaRSFkKAFNyHN9KRORKDiUuSDjvVczBFkCpJIFqA+4LbSFeLoycdhJDuEZSWrvRIFWQsHVRolmWn+SGWjlntu3pecPNyQdYMPIpwK4jwsoEXSeGZVK6xIuhJv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dPuAGsAm; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710893487; x=1742429487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xPQLWidXMbV5XvBwJnEnSUsm7S8MxStEbMnsJ7XHJPs=;
  b=dPuAGsAmWpamajLKIFSqsvXr17sKs83UAb1qEnTdGbQZZIajmm+2mbaH
   7oAkohQRlGUHOCdPawzkN6J6LyXRbgpE3enNt5r95VuKPXxED75GyvJXH
   mqC28pRjrE0mf3sDHcEOFVuWXakMJCkK1dkU12dM6tmfr1BNNqAvH/++Q
   hW088zOzqNQq4zY4iDCksL5mbDlivmWVvtlSsLMgNwYxmuVJz5jdracQQ
   evoiTUmCJwGC/057x37BFnGUFDYqMQxp6XmQIYj5T84AOTev1i8uBHjSF
   2aCHCQSpygRWCEn03B15XhpQhbefdaWnjER5Y2CD0QVVooNHnRoau5quo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="23255871"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="23255871"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 17:11:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="51424966"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 17:11:26 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:11:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 17:11:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 17:11:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBdBxX/gyrlibs9y0h1360LiGBJPoqoIFGAPLDBL1rOsnTp4npQuOu2Ajjs4hEdcI341mcGe3LnPyu9ZKaMxs0QO87ONcKeGTZOmpsnodT7Gjs2c4Kf86A8zAoMGsp2jutw1FxMgDkzPUIODCUlNpJFEgn9udf318jtn05OmyLBAgndDEmpTAB6+sx8rEYDrXW0+jdUzFP9STSW1wk/XQLKYVq8itfg2nw7EQJv1hyfaVgS5d16mmMC3MHpSN3FAM5lGOyUoXYBec3NsOT7SU1nLDoSKAch08ZIJXUZcvNvtMolBdKt9SG9ZRcy/NEibL34GlnDlY+KpQDWToekhOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPQLWidXMbV5XvBwJnEnSUsm7S8MxStEbMnsJ7XHJPs=;
 b=c7KTEQHuDb+3uR1O47zVY+TyQUnLTQ28E43/AOpJumUSRPNBrzCPnuQFo02rTTQ3SJd73p/MOOBgspkDM8HZC4VMzCOduaj/fJADT4lp2UjOAnJtQQAFwL8+yQiqWdsKp0dd5iQGJj6prQYt3cUjMgr3OfZcxm7lGizdL9CsswaVhol9FPoqui7K0/pR7ZNMtqNZFXRDFkyAs22cxE9ftspPlk1563GFLudOWqIZtete+46TF2VS0AwB+/g2etUfggQPMCdy5NIGVI18dSZe+Xvb6u142Pjm07P5ia7r49DB39sj9kU5w3FAySS/OalzWvAyVHCI2LgAFm1MLBfGvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6414.namprd11.prod.outlook.com (2603:10b6:930:36::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13; Wed, 20 Mar
 2024 00:11:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 00:11:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yao, Yuan"
	<yuan.yao@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHadnqew2ceoSLqG0SnDLEWlzYIqrE/vEEAgAAMfwCAAACKAA==
Date: Wed, 20 Mar 2024 00:11:17 +0000
Message-ID: <97f8b63bd3a8e9a610c15ef3331b23375f4aeecf.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
	 <3370738d1f6d0335e82adf81ebd2d1b2868e517d.camel@intel.com>
	 <20240320000920.GD1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240320000920.GD1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6414:EE_
x-ms-office365-filtering-correlation-id: 2d895523-92f8-4220-b59d-08dc48724382
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gM2WX6eWXhx1WDfD2W+mDf2IpReKqWgaqoN5H9mDYJgEnTb2jCtp9sltPkngrdvdAY29zbr/RLndVjlLeuxEGdaU+cwjPWThN2yrayZ2gLFenFjLF/7iBty5Hu6My7KTcEBya/sx42+GiQAEF/Ks7uKHVXrPBuOAiEneA3QAoorJGxJmfR5kZI5lF1nW9IHreMWxcs2exRsVKzxzswik0E6UlrVX1aa1Nya7wDWnSH6NhHDvXRoNbTfhNz33lxT3Bu1vZYxNsJmWbP4tkLWUkN8XPF7ivHZvTYeQe+EgBeEmBmp97o4dIGLEitCgb6QUyeneuKnR5JXFQOXIyQhD8GtXXUUHfOx5DcG8hdQYcvgB0DqdIeHq9iA/EjgcqnIScvjOWcYp0WR9+194/Ci7n1ghOJEJLbmkgkOwvoJVfP2eeo/p2TTiouAJRyePC6tdjcynpoZ1MP+uft4Ez4YX+aBbFoJhydB2CeACGiorGymtmXfj1ttWrPAbe7cm12ud/YAV6E/dyCmKPAuiPC7YoUcTt1JL0JVh8ku9qjnaq3UHkqW4jjf3I9raOmcr3EBHzacoZzzfZvbSZDk9moy2IX2J7FylnItNt/Fp+cIp2/5coWhup8ueaaQsRnL7uMZ8MW1SW+e+RExrn+yE2J54xfk3RSrZUABxK0paNutmcnViEpxoDCi8Wfv1J8gXA/bA65iPXQTvqtzswf2iEhjCjP5GqhN4Qb1BlE19ZTC+FDA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHBjOU1raDQ4WEpVRGVPNTNNVHVTeDRWdnJWTjFBcXdYTjhYL3FMS1B4blpx?=
 =?utf-8?B?NzYyQmpKays5bndUZUFiOEw0dXc4RllmSnFoNFZuOUkxVjhnVzF2ZlcySU5I?=
 =?utf-8?B?UUVpNEdqd3lKYWQ3ekhJRlMrdnJLQWRSd010UWVDeUJSNXJYVnF6V2FZUDhi?=
 =?utf-8?B?dDlXZlFhZkx5Tnp6VHRIVkZzT3RVd0xXWU1VK0hSblk3UGN4OTlYZ3ljWEx2?=
 =?utf-8?B?aFVDckVpNGd0MG1iTjdrb2U4VXBTZXF5MkVzQ1ZUOGV2WC8vQW9FelJCZU5L?=
 =?utf-8?B?M0RmR0ZiT2VaN0ZxMFFoTmxaS2NYQXliOVprN2VQN2YvZkdPOFFzV1BSUFZ0?=
 =?utf-8?B?OFRiNFRNbTFKR3ZPUHZsM25uVzRPcDdnenZubWlNcHZxQzZIOWloV1V0QjlB?=
 =?utf-8?B?azhwNXhReFh1dGlrWmRNYTEyWGZGNVFFSWRLbUtZM21FSmxmajhXNjgydjgx?=
 =?utf-8?B?OFlubnRydEZXWFpGc0E5TlpxV2JLWUVxdnMvcm5pU09wbnNYNmVyaHhrVTR4?=
 =?utf-8?B?VnhUblVhb0FrbWpDSVVIQU52R2FoZnNoa2FXZlVXcnBCcVp3a3VtZjJvNXA0?=
 =?utf-8?B?bFpDSHhpOTY5cHYvejFoL2p3aWhla1lRWjFaekRCWnVQRE4xZ0xvcE16YTZK?=
 =?utf-8?B?am1LMEM4cTB0WnM3cmFuMWc4RlN2WWw0YWo4aTd6bldGKzJtb29pRWpiSklh?=
 =?utf-8?B?YTJuWGEzd0Z1Qmlycmo3SFZYTUtSa3c2TUhrTlIvVDZMdUxsdElmTVNDNzJH?=
 =?utf-8?B?UXQraFYybzJiRUlZVUFoWGlpdFdwK3lRbE5DYThJRDFTM0dNeW1PYWQ3aFBH?=
 =?utf-8?B?NlJ3RVdWV0grUmJ1SlpHZENHbi9ERnpsNnNuL0RLOEkvVUUwOGIvRzc3N3BL?=
 =?utf-8?B?QTRvNWZ0dm9yeTFCK1J3cFE2a0RkcVRTNGtBRnFxbzV4N2x5TjlrK09nQkxJ?=
 =?utf-8?B?WVBPRVZQalEwTm9mZkhkbUFNUEpPOWlrSlZZVWFiYVdsQTV4NXNVVDhaemRx?=
 =?utf-8?B?MTBkUnB3K0ZDNXJNditUWUY2a3FORERjZ1FXbHBRMjlkNkk3VzQ0ak5SSlZC?=
 =?utf-8?B?M3pycEJXaGdhTXdEcHlXOEV4Y3hhc1lIa1A3dG5WTFdqS0VTU2FRNXJZemxE?=
 =?utf-8?B?ejg1dmdoNkZtQ3ZYQ0ZnY1BIS3JMRWIwdmNQZ3FaZjBQSEV3bkE0WDNyUDNl?=
 =?utf-8?B?V2hmbG52RmFEc2tlbldyRWtDNUJCKzVrcVFYdjNXN2o5Nm12OE5GbnZITndY?=
 =?utf-8?B?VERYelBJMzJpSzNjMjJDa3l4cnJFME1QM29ubTlBd1hlUDkzY3hzakQ2ZnZG?=
 =?utf-8?B?K2tPWFF0Wk9HcjNKUHJaR2N6eGdhQm5YWHRRVDZ4eVQ4WXJ3c1VmRDVSOTFK?=
 =?utf-8?B?MGR1RFpjeE13Qy9ObmpRZXhzenZ5K3ozUk5zSWlzM3NlRHVQK0hsKzlCYW9q?=
 =?utf-8?B?QzRlbTlyZksra0paV1RXakI4dUhtZU5teXphQUkrY0Z6MnBqOFY0dWlrTkt1?=
 =?utf-8?B?UmtpWktjZVcwK2RRRktOWEJyMUUxUUdJMi8rZVd3eUM4bVFZTjcwdUFPOEFq?=
 =?utf-8?B?N1F4ZzJLdm9XYWlSUmttd1g4Nk5PWEprWVJjeXZlU1dyM0lvUnkrb2hTeDJV?=
 =?utf-8?B?ZisrN0pBNDhTa2ZCQjk4eGxEUzc4ZkJZUnBFdUU2ZWNXTzJCMXB5bnhNTlZW?=
 =?utf-8?B?VGR2S29TL3NJbnhReVFmUFJBYWtscTZjVmRUVWw2NTBYNEZlUC9KME0yLzJp?=
 =?utf-8?B?NkI2amI1elBqMnVxMTlLcURaUDl6b1lDTG1JYU1sb2tVL0IwaDNqMlRtRHo4?=
 =?utf-8?B?b3RtcmFSRjVKZThBOGtWQWxEM09CTWVmMUFTOWF1aUREUS9mZ0tEeDk0QWRP?=
 =?utf-8?B?MXFOQ3BxS1k2ZlN4WE93ZEZHVVpidFBXRWlTNXpsYktDQVc0ZzFWUzlHa3RT?=
 =?utf-8?B?YTA4QS9mNUMvclhJYTN5MUE4RHYzYnV1ZGR3bDZ1SFd5bjAxenNiRWxLRUIv?=
 =?utf-8?B?b05ESkl2M0RvcnFaTzN1ZEN5L1BKTmxHUVg2U0UvblZKRFZKZTNTQ29LRGhy?=
 =?utf-8?B?UU9MeDQ1ekRESHZJNjRBL2RLRlV3dzZFMVRMOURYcXFiNW1xdHZ3ejBzV0ND?=
 =?utf-8?B?YlBNV0tDcExsUUsvdEtxYm82QjRZSm44dmo3a3pGdVlYMHdSbnd5azFXWEU1?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AFDB229796D2F44B3AD7DE621C8CC16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d895523-92f8-4220-b59d-08dc48724382
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 00:11:17.5243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y3YCdKyqOKsUHvOOTZaSddmdFPJtXYmy3CxkkyJCDybFdG6uSEAPFAoxl6nHFbQ7b1Q5afNS1ISEguxNS5q+DrGGUsqGsy3gqojpPVyRKBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6414
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTE5IGF0IDE3OjA5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBUaGUgaGVscGVyIGFic3RyYWN0cyBzZXR0aW5nIHRoZSBhcmd1bWVudHMgaW50byB0aGUg
cHJvcGVyDQo+ID4gcmVnaXN0ZXJzDQo+ID4gZmllbGRzIHBhc3NlZCBpbiwgYnV0IGRvZXNuJ3Qg
YWJzdHJhY3QgcHVsbGluZyB0aGUgcmVzdWx0IG91dCBmcm9tDQo+ID4gdGhlDQo+ID4gcmVnaXN0
ZXIgZmllbGRzLiBUaGVuIHRoZSBjYWxsZXIgaGFzIHRvIG1hbnVhbGx5IGV4dHJhY3QgdGhlbSBp
bg0KPiA+IHRoaXMNCj4gPiB2ZXJib3NlIHdheS4gV2h5IG5vdCBoYXZlIHRoZSBoZWxwZXIgZG8g
Ym90aD8NCj4gDQo+IFllcy4gTGV0IG1lIHVwZGF0ZSB0aG9zZSBhcmd1bWVudHMuDQoNCldoYXQg
d2VyZSB5b3UgdGhpbmtpbmcgZXhhY3RseSwgbGlrZT8NCg0KdGRoX21lbV9zZXB0X2FkZChrdm1f
dGR4LCBncGEsIHRkeF9sZXZlbCwgaHBhLCAmZW50cnksICZsZXZlbF9zdGF0ZSk7DQoNCkFuZCBm
b3IgdGhlIG90aGVyIGhlbHBlcnM/DQo=

