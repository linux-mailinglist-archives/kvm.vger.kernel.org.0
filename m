Return-Path: <kvm+bounces-72752-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WMQDIXS0qGlzwgAAu9opvQ
	(envelope-from <kvm+bounces-72752-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:38:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E391C208BA9
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C610301992D
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B4338911B;
	Wed,  4 Mar 2026 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyZgQYZj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E2939EF3B;
	Wed,  4 Mar 2026 22:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772663907; cv=fail; b=aYUZPn2GkjanZ2hTuyfa7Sj0dwERyAgpQc3Ia9ylFTG+QCG+9vvSZ39o1BMznZKLdrIDCNzwo9SWk4uKHfBsVgxCif5YU1MDutMofCYLR6npJVECvusF1Vz2oJO92mSw3de1tuVUSpqYwlFTeyRi3n4OfD4s0aJqLSs582LCUeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772663907; c=relaxed/simple;
	bh=C4g2qmy3XaJC4TbjkM5hjeUUgkdPwWIz6N7lm2IkftA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=idqVTUhy4C8dx3o0kA9rcdhm5V6y5meX3Uc23BhmPr1anXInM7O3Xdk7ERTFK3fU1dNGLrgVpx7SVObnvR7TLiV7GlnJAUYxrT2+nlpoY8slC3ZIya8jjdoaV+OswSgadj0MSiXshumSfPC3GW8joWXjHsP2a1mur1ZTzVkj4dI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyZgQYZj; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772663905; x=1804199905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C4g2qmy3XaJC4TbjkM5hjeUUgkdPwWIz6N7lm2IkftA=;
  b=KyZgQYZjB+vcppjtRd5yPaEzwnSlC50k4epf9GXLT4jiAP4R/73GTG3Y
   JSWG8VcBoqTDrVL28OPcXp2CzAgIG6/ObMeIlOawRWrHSh1lJWRxziKlX
   pjmkLxIUNGMvAHSyuJl+1U0FVS0fIsis0kflLg/c5xRRDJl+KaThhE6mA
   lB4kZDnHph+kZp+xPkBPQXfcYBeixC6EbhaHVOzrQQ6LGsO9AYKTXZokZ
   CLotor0kqOjzZlyAVj7hYgwTxBk6n9oEUoit8f3gyI0QF6Edg4t23FDeb
   TAHJqRZCdDWCCEGuLuiTo64t+jsTtDx5rhogUSbmHmWRQ1O74ZHODOGCx
   w==;
X-CSE-ConnectionGUID: tHaTal8nTzmgcmwRZvC0sw==
X-CSE-MsgGUID: QnMeQctgQcOLB7iDKhFNww==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="96354683"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="96354683"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 14:38:24 -0800
X-CSE-ConnectionGUID: 7wI1aURaStmWTchO1EQi3g==
X-CSE-MsgGUID: 57uot5gfT9yKUkf2XPdc8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="217634269"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 14:38:24 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 14:38:23 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 14:38:23 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.68) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 14:38:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BCIVuUuxjcDgEkG8dHqmly7bgEPXEgb6X1SAxf4+Fzzk7sv5vd+aMx0jy2ozriV49pa61vmqmKd3hDv/E4KQ+RFFlGfVkzLMLO2K4EN9EmwSGUAYnN24y+ymxYsgpf1YNk4dk9sEojIivdGwClEthvKgo/H5S5jczUfUUoXiaidKs+uQVrk8IYaT3onIbXnJvJA8MQVPLumTkqGm81D/nRv0yhFaYLWOlfwBjy+/UFfiWyJLv6h6KQycfZSsnFTjzr75ePOGyUUECYNfy3tx3mcAHSn9s1Ojq2HjSaygVNOpH91WkOPxrNrp/mP9aHakQMoJr49vg6b353satzcQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4g2qmy3XaJC4TbjkM5hjeUUgkdPwWIz6N7lm2IkftA=;
 b=L8Y96HAIVVd3Zi+4qhSNTGdj/wQJH7cZhduIw8SEcX7bd0N6fOB26b5AL08Cip3vRGSowlYxcAeUaYXMh3VlTuNt56UBbeMsEfo5j3B5nKs+juMY4xLLtbC1naEnHBDdQx35LVP1JFOmTbCFZuKxHxPyJlrnWngSru5ikAyWaIUD8tPqN7YWMjC2ia4VVWqwqXkCGzqHwL7/f6JopXmTjRh0q/LOD/KOfIxzsaXnPxA8vTy1m344F1rAfwWIzT07qUZgS+Fb5viaLOWzluODZJ38P2EoZOxhW44YgmQL+jdV5NQYrOSgnRxpu52CLKHDT79vxLJXMpxUR1XSZjBK3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SA1PR11MB8595.namprd11.prod.outlook.com (2603:10b6:806:3a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 22:38:14 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 22:38:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 12/24] x86/virt/seamldr: Abort updates if errors
 occurred midway
Thread-Topic: [PATCH v4 12/24] x86/virt/seamldr: Abort updates if errors
 occurred midway
Thread-Index: AQHcnCz7wQgkHqxXrk+NCj8Gs1BUiLWfFsqA
Date: Wed, 4 Mar 2026 22:38:14 +0000
Message-ID: <06ed30d15fc42263a193515b603fc6fbcce61536.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-13-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-13-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SA1PR11MB8595:EE_
x-ms-office365-filtering-correlation-id: bd6397e3-fca6-4f8d-b8ff-08de7a3eb917
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: xVwjqwyNWQgoCC+4ddzoiy1Go1lZE1PMaHeZRbqjDmhWnZ3JUy079K7kk1bYyid7t+kQil73RGnTtZMuN4qzMyzV1wFkp3WvbVbgyU3QdAGIDhLy+NL/iG/hGV+Z/Iazyj9ImeB+kGBEldF5H/ORhmNe3CEUizCiN3K7ontqtxuwKDnC2/sFX/2JCnzo9W63PY9bhkvUTBMkLqO4q0oi6lMssS58C9t0F6nWXMfq79UDXwbThuskmcxt8ZIMwm6/IFeFM/fvju6e/XRfXyDT4455+b5SPaeBhL1hm9O1xm3K8dOpYAehDTD1Y6YqL+Nlv7n6qzuE37k/vHQwdH7h6dvjn+d1okkfFb+FSxgSTN7JlWTBlXEnhpNHOt5ObwL/G1m3fNE7n7HU4LzDBcF2Ssn5p+4LZnxOUme70nvMI/ht2zAA+8BKBeVlqyHTT/GguVCTPs7Pv8znwthFSr4jqAoFfruOaHe2Oi7Fx3lklkictugMwpW2lO8jX4dZ4Cx2Q5swkdfIMRUQLqCZq/Ec1oGIOFHEmkpVx0CD00srOaBaiWEYuxagjimdt/HdZveSL+FW+RYSSxOghnFNXXdCAVGfp18eVr+OROGz4/N8+J4GcadZkxhs0alqJEpv+gS6+J9k5ZIu3dS1iMvMtzlOtJG4805gUWq3qrcwG58n93Qf03f0XSAb67heYRqyGpp6Ua1AGnhuqxJWj/ApEwAqrYqupksDxbtXKCRseRG/xeJFele8Seu5+FT/6gv6ZsRMRBkbZG9G9s0ch5qAYPAB0r/041NGbLGrM6HnYbKoW3Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clNwSUFZaTE1NEkrYW01ZnVIMDFVU24xbE9nYllwUk56Z2ZIMkVaTFlaYVZq?=
 =?utf-8?B?d1EzbUVJKzVaMktlMEZ4YXN0S3Uwcm5EUVdDUmlvWDIyVUI5elNPVFhxdm9T?=
 =?utf-8?B?SXdONElQM0tuajR4NUgwdmk1eVpIc051MkJRVHZ1ajQ2Y0VIbWRQaXdkc2xz?=
 =?utf-8?B?UFVyY04vNFlyQzE4NmlzZjNSaHhtYlBpbG9wQmttWUJhWFcwcVVBOXZLc1Vz?=
 =?utf-8?B?enlLTFVyTjlkQkpaeGRGN2xNOERjZ0VyQkVGUmozZkh1UnFZc2FxeEVDQTNH?=
 =?utf-8?B?MXUzd2JlNXNOd0pTeGZYUUtqalVscWFXVDl2ODlvS1F3bStlOC81eFJqcUtS?=
 =?utf-8?B?WS9RSkZBU2NIem5TWlJjMHN2WDdxdVI2eDhSU3l1U1N1ejlXc3Q4cmtXbzJC?=
 =?utf-8?B?c0xoSVI4MFBFMUExMnlBaUNzWGltWXFDdWliZjZDQmR1YW9oM1BGU1BOWjJm?=
 =?utf-8?B?bkpFWFNLNkZ6Z0t2ZWZuV0ZIMDdsQXNMVUMvSnR0NDJhckFmRWduaUdqV2Ri?=
 =?utf-8?B?MHNhMjBKSVc1RklQWHdTMlFxT2E2WmdWOURwMHowWGhKUjQ2bFF6MlE4RkdM?=
 =?utf-8?B?dm8rVXdydDIwYlBzUm9oajUvejZaQWhWd1pqbzRRUlYwVGJLTjRFM1NaYUFZ?=
 =?utf-8?B?cEhvVjlNdXQ3RHdrNnlBU2ZEUXhhWHVrck1Lb0FZLzVYZ2pXM3B1OFBacjhG?=
 =?utf-8?B?RnpjazhHd3I4TnNZTkd4V0FuZ2RvNTBUaDUzcjRPbERLK09BKzVpekV2ZTZN?=
 =?utf-8?B?L2R5eTZndzFDV1ZHNmc3ZG5GV3pHL0lKbmFYVXY1Z1YyRjhxWWp3Sk00RW9X?=
 =?utf-8?B?L3c2UHJrdWh4eGtiaGMxWDU5cVdhVG9BUHI5ZitaWU5IVWR6SHlIT2tLZmdQ?=
 =?utf-8?B?S2dWRnYrbnhqU21vRGxpV0tMQnluZXRXL2tUZVRnN05rMmRUOGFOWE5vSERU?=
 =?utf-8?B?RHZ0eUNjM3JIRGR0Z0pjUExDVEhDSmM4OHJIUWdhQ0FUN1dNSUt0RTN0c3JX?=
 =?utf-8?B?RW82czhONEpseWNzbS8vSnZzN0JLSldGeG9nQkdneEwxTnVNdklZNGlXaUtj?=
 =?utf-8?B?dnlKeXV2V3Q0NGtUU0V6NkNxa29NQ0FZcDdwWktqamRnaDNxazIweFJtMG5v?=
 =?utf-8?B?bUlSSEprWnpFanNZS1Jsa2ZJcnQzdjRHMDNxSUgxby9pOG02dnEwZlpKbC9T?=
 =?utf-8?B?K0YyMmFzN2RKK1ZLaFo4T3hQOExibC9oQm5CMWRXR3FWUWU4ZFdQUjkyWDBS?=
 =?utf-8?B?Y2tReUlpaVVGcU5iT1Y2K3hHTVRJVUxNbHVreW9HT2xTOXFBKy9xcGdKdVRr?=
 =?utf-8?B?cjNzeXNNUEg3dnZ1djJWMDhVcWp6S1dFOGdwblBTcXlxUURhZVJibFBHZHov?=
 =?utf-8?B?dXdZbURLWFFsNm4xd3VxQ1ZXaEhyL3owd0h0NzNyM1V1dHAzUnkxSGtKTkFn?=
 =?utf-8?B?UXpTV1REaklrQllTNFI1akwyZVhVT3IxRHAzYjgxelBiMGVXNS83MWdFTGpN?=
 =?utf-8?B?T0s0NmJ3aTVlWktBZkVvMEZidGgyUjE4NU13RWZYTGt5aHV2MTB0SWZiZTdn?=
 =?utf-8?B?QldMbVExZTRsTU9lVXFSNjFqOCs2bktGcjJ1RDgzWTRGcVdLbEU0WVFUcHFa?=
 =?utf-8?B?bHN2QVNZam44V2Y0dGdzNXdJaFJpMUN4MXZWcTdlRjBQY0YxWDczbVVFTFg0?=
 =?utf-8?B?WGY3UHo3elE2MGhteEVTb3l3U2tzcmk2UU1QY0FtV3dtMzVrVk1JVEFaUERB?=
 =?utf-8?B?VklXd1JPOXVxRTZpQjlMK2FRdnViWFZlMEp0eG9MNnoyY3NOQjJCUDdUVWt5?=
 =?utf-8?B?aUVDbWpiaThpVkxQb1o4dCt2N0JScVE0bDByd3NPbnRZM25FYkk4cUwwcFpx?=
 =?utf-8?B?QmVpK01yN3VKQWxnQ1VCdjFJSCtoTUtOaGlacW4wQWFGR01VYk5CQnMvenRU?=
 =?utf-8?B?TmRGZ1VjYVRhcEEzYmhYdXVVVURPdHZBaWpSc1ZNL2tXUWJGWEpGMHZ4TnJY?=
 =?utf-8?B?WjVUVVNORitQVzA4SWk5eUoyWWxLWFZlQ0p3TEVxV0J3MzViU1NIaWJpeUlt?=
 =?utf-8?B?KzVrUllONWNPcm91WjFuYU1iNVhJSkhVd0tmSzRYajY0QzIzckthanJSQzB0?=
 =?utf-8?B?YUcydGtBU2pabWR2YUZPenBjQktrdnhuRkpjSlMxUlJLUVBrNWhWNFk5Q2RL?=
 =?utf-8?B?djdkT3dvaGEwRTFXVVpaZDdEQk44cmRGcXA1S0FlaHU1RUZEa2F4U2xxUlQ3?=
 =?utf-8?B?OXdWcnV5TnNibzFLdkRWM2huUyt6Qkp6SkxmTkp4clVvNGt4YmFDZ1V0Rjl6?=
 =?utf-8?B?Ni9vcEV3MHU1dGxTYWtUckU1bjVNZlQ1b1UrT042Rk95bjJCcWdjUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9E80498DEC31744A9E998E87377B847@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6397e3-fca6-4f8d-b8ff-08de7a3eb917
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 22:38:14.4973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q1aDw5F0pbCQJiyBhmlVUjYSr1AzfPC2e2Tv843CawV+dXwUdfAqPDETryo/AMWm41FcrrdtzTuQ6Jdi+rT1Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8595
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: E391C208BA9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-72752-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gVGhl
IFREWCBNb2R1bGUgdXBkYXRlIHByb2Nlc3MgaGFzIG11bHRpcGxlIHN0ZXBzLCBlYWNoIG9mIHdo
aWNoIG1heQ0KPiBlbmNvdW50ZXIgZmFpbHVyZXMuDQo+IA0KPiBUaGUgY3VycmVudCBzdGF0ZSBt
YWNoaW5lIG9mIHVwZGF0ZXMgcHJvY2VlZHMgdG8gdGhlIG5leHQgc3RlcCByZWdhcmRsZXNzDQo+
IG9mIGVycm9ycy4gQnV0IGNvbnRpbnVpbmcgdXBkYXRlcyB3aGVuIGVycm9ycyBvY2N1ciBtaWR3
YXkgaXMgcG9pbnRsZXNzLg0KPiANCj4gQWJvcnQgdGhlIHVwZGF0ZSBieSBzZXR0aW5nIGEgZmxh
ZyB0byBpbmRpY2F0ZSB0aGF0IGEgQ1BVIGhhcyBlbmNvdW50ZXJlZA0KPiBhbiBlcnJvciwgZm9y
Y2luZyBhbGwgQ1BVcyB0byBleGl0IHRoZSBleGVjdXRpb24gbG9vcC4gTm90ZSB0aGF0IGZhaWxp
bmcNCj4gQ1BVcyBkbyBub3QgYWNrbm93bGVkZ2UgdGhlIGN1cnJlbnQgc3RlcC4gVGhpcyBrZWVw
cyBhbGwgb3RoZXIgQ1BVcyB3YWl0aW5nDQo+IGluIHRoZSBjdXJyZW50IHN0ZXAgKHNpbmNlIGFk
dmFuY2luZyB0byB0aGUgbmV4dCBzdGVwIHJlcXVpcmVzIGFsbCBDUFVzIHRvDQo+IGFja25vd2xl
ZGdlIHRoZSBjdXJyZW50IHN0ZXApIHVudGlsIHRoZXkgZGV0ZWN0IHRoZSBmYXVsdCBmbGFnIGFu
ZCBleGl0IHRoZQ0KPiBsb29wLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hhbyBHYW8gPGNoYW8u
Z2FvQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFh1IFlpbHVuIDx5aWx1bi54dUBsaW51eC5p
bnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBUb255IExpbmRncmVuIDx0b255LmxpbmRncmVuQGxp
bnV4LmludGVsLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo=

