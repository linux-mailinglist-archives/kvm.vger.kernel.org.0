Return-Path: <kvm+bounces-50641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 630D5AE7D9F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 11:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7EB13A958B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A116E299A8E;
	Wed, 25 Jun 2025 09:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T2dxzGpX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB90288522;
	Wed, 25 Jun 2025 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843870; cv=fail; b=LpGa2/x9ErUu1NYXk0JKSgwtOljGZ38JpEvjXhaaaD/gX9vpKlULUK4CqV0jRv7keKRouGlU7LTJSoM0auqnuv98MpbGTNHSI48ShbFEJwq+1F5cS/HSC+Kuan6grWhNinNoeOgU9NdgDENprKtga3bIOOMmgKpidX1THhsePlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843870; c=relaxed/simple;
	bh=5nX4ECBRPhu2OckT2vpAFlrBQr0q+8WERTs3481L+eQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aLF5tQZp+jsSzhNjVhSDqcpA3gDv3dMcIGutUXdGqTGyhJLyyr05AjBFp8JyFCP9so0A52GiPZicEZbAnqtNeIoroT9CVhYLXW6a7lXFRwziUUhogpbvtl9ZW/sntptaL0fzbUM66gLMsQr33RGtNAtFz7wzZrMRPLDxHEuIgTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T2dxzGpX; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750843869; x=1782379869;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5nX4ECBRPhu2OckT2vpAFlrBQr0q+8WERTs3481L+eQ=;
  b=T2dxzGpXYr59FMMny9ir8zsnHj/lUwYB3/e6ZPCbwesBaHJcXlzry+K6
   6O65A342GIYpjbCy4OsLP8qjhCXRdejBispKTaMv+Ymq3aYWlkhdPpH1D
   Gj8GrMfAX+EGYE+0XvMTyhbdeemGP/I+usZO+l16AcQhRzM5JE1NKIHT7
   RNG3ln7VoZSE9f0RyCnkz6r2eEEO8kWWFicY3bp1yx0IvNMoqFp1PFwin
   rta10BTSfw/Sdr8djSQb8GEzXlyFKEL2kpQFNAlwV5AEcqiM5jtBZMkNO
   43ESSxORuw/nKD2egDKewD6I7r0Kf1zmH2OtP1IuxRg5rbWvgiD1Bdhvf
   Q==;
X-CSE-ConnectionGUID: +fQ5Hm00TL6Y6kF8w6EDFA==
X-CSE-MsgGUID: BHH494/XRaS9tlJDRmrcoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="52220998"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="52220998"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 02:31:08 -0700
X-CSE-ConnectionGUID: EOFxNWnYSomotUCWp6DwAg==
X-CSE-MsgGUID: f2VNWu4vT7m515mkhMaPsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="156199557"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 02:31:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 02:31:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 02:31:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.48)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 02:31:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x4JBMbUYdX+Rlor2x8KXcX3Wo1IzsKaYv1WDmi6kDvanZxTqfbjTYBBFSCIyPJlwA7Gy5QaMO1DQ8en6GjxJe/MV1oojFsrDYyerHNh57M7rZafYO2C7gOP4If09pBU0Xkp73cxc+CChy7K9/OIAlwdt+wDDO5t0pp9GSBVn0Ba0hY3+pvSMN6ys+QTCA0Nq3xKOCGdCs5jfJ7FWECw3/n5+JxU3Cd4HGb+veZ32OMOgkH2aL7bFzB3GR6To2HpewdR1P046Jb8HwS199xBlSWpId8So3087RS9QPmD2odLbAo/XIA0iLC0QbnSpLSACmEafsKy9bjmRZuTDoqvrTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05fVZieOaTJgtq7gCMuV2vDc5MfostLE2S+ZIf+2LUM=;
 b=qCb2MVsByyu45ilo6sKvaSadOCASmevLnwuHestfaiY66zAHt7zdYr4gptmHzz1AdZpnG+rQ1AzMADWsyoWryS4/edp5imHGRuRrzb9JeL6W57IkUpc2ZLb5r1vl0e9l5tYsrTTg9JQFvw8W2QSo3mQ+x4zIjJHM+WQc4RgkOlS2FisH58X1O8WUnjG7UAVhvwdis7AQifCx31XTpCIdN2P75jkIn8E+4y7dqMitlaN7GQsChyR1N1p6vwpXGo0dWQznb1Q9myHmMHLQGWj66KXybCfonFIdC1fX23pERe6WrAiAUkpFzgf35zO7k6Q7La9HKYgrDaI8xIjbl9N3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7597.namprd11.prod.outlook.com (2603:10b6:a03:4c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 25 Jun
 2025 09:30:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 09:30:56 +0000
Date: Wed, 25 Jun 2025 17:28:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f9e4ef-ad2a-4d9c-0c83-08ddb3cafcb8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bOnbIDNg/kP8R+A2vJjF83xFpWgh2ex5DhejRYKWMRxgO0mRAdpUae30/nwk?=
 =?us-ascii?Q?38jqvvdnyGGZqtPAA+rszwl2BqQkRUtynkQolP9+pFfj1JCBh9FSBF/gMJfk?=
 =?us-ascii?Q?M2J9YPvG3nYHwL1UE+Fa4h5ldzrfnfCj4KKUjTSniEP3Wz3yyu2wIgVpO3TG?=
 =?us-ascii?Q?UuBhO9M4sBu+O6nepWSEGmbB1Igk5ZV42pUMCefIHPMt7+0SoUihiLFz5I6M?=
 =?us-ascii?Q?oqhrrVDvb3p12SQD3g0NZTsxrz17SkP57b33b5YG3BMeNblydiy9NWCGqlr+?=
 =?us-ascii?Q?o0IRpCZtfm/OuDvZ7tNY7ps3JvOtzjMj4d2RrFNuwLsCouVdiCL55QqudWls?=
 =?us-ascii?Q?ePfXFSd6Vvrln370nBziKYu0t7aRZRu1j7S6f/tL+as9XhdCSa6jgYK4sJSz?=
 =?us-ascii?Q?od1dTzBjpMd8owwhY5rX5nGB2VR+xs2d8L9atlWVN/ZmCwYwDOf5DTPljdtK?=
 =?us-ascii?Q?CqGwMNTo5blGRRBly88ZLd4Ny+RteOWJC+EOFti6CW25vDjjIYCCkOaUpOBu?=
 =?us-ascii?Q?028crfhb5pjKwqOGmdhWokDK2UYhHw71TYmp/oT0x93RNq8O+v8xiWh/kq82?=
 =?us-ascii?Q?v8ntGMqToNVBXasirjWSn5xNn9wxsDHZzQXLuQpF1e7trRpgnSA5MOv/Shxd?=
 =?us-ascii?Q?grxkwjhn66nhXRUgo+czfEg83YIgJ1ehFC99yljdzRLDmKtBVUCx3c2JOcfM?=
 =?us-ascii?Q?HhGssPLDjflApHpQ6m3InIA/ayO0SCvv1EyzXJvEAxMB7UNO7LO4qo97H1ne?=
 =?us-ascii?Q?KHGy07zB/PMJRBBjo2mhH2af4/ru9YpfQ1uh3alKVnQocakASnzyoLeg5+7Z?=
 =?us-ascii?Q?t5hXyv87CGX3aJ9m9Kh3SI6KuhRwd7Vf+D6zYytxKmYOsjwnc5LUgeC2cJ0E?=
 =?us-ascii?Q?c7sd76LEK8eH2KeQSNASFhtZ0IYmiHVZrOJlzlrSXsHRuor69sVdw+M5lJcD?=
 =?us-ascii?Q?vYQGE4r0WzORbTlB8MQeI6YpFPvbs8qWPXUkHOoXCxsVv9aBpW1bvBxOp+Q8?=
 =?us-ascii?Q?zSrLvtsKMghjckqD6WvnIJ8Um3vB0iq11LBEWdq7rXzTx/XqIEiCqd1SbOJo?=
 =?us-ascii?Q?bjxDXP7ZDz94ISP3EUf754j+LE+Z3M20mnhKe1FDQ9FOC0oIeVmekMN5RWn+?=
 =?us-ascii?Q?O4sY/ZGlZG+WgK7bcXCBLUHWHJMgvEMTP3t/wLWJ9oW7CuBAC7p5BT/TXymr?=
 =?us-ascii?Q?8y31POFc/Xd4p01JG4MEiSJqOG9DChcjPlvDASLU3l0RMo3XiucM/Em/9vX3?=
 =?us-ascii?Q?J/MwvXzpgzhmpcLGJn7FDbEs+c7vqvdgT0bxphEFXEGUBv4Jlu3xdW2IsvVV?=
 =?us-ascii?Q?XdiK2IZ0NEyZWX6evpaUnwseq5ljlCC8kTKMnPgEIL4X0HdefVAdzxTAhsj9?=
 =?us-ascii?Q?Dt+Cyu1T4JygeQDNRi8q6/py72u/ATTUT5RTn0xyeXe3p7jvk8HOOLXNJVdq?=
 =?us-ascii?Q?cZHC4w2Ncc4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gIaE1wu/qDAXuImFSWrt6/Lh6uPuJJap232MpJt666TUGozRFs4fu/6kIjMd?=
 =?us-ascii?Q?Gh5wRmDeFNSU8WaQpBCjfpIJ6OLJGsq8TqTx21O5kHQlLoavpPNv+b0rD3UE?=
 =?us-ascii?Q?Cf0ZCKvg1cq/9MWCVqJPZVDIz9uKmZZ/58SiW4cKXHsBzUVnZHpE+DVPgqo4?=
 =?us-ascii?Q?YOzsy4RVSrx5JHGanEiuOshid0m3Yx3E57IVvDYcziDJqoMjp5nnyWtqpufi?=
 =?us-ascii?Q?vnonoKN4g5lYGcdfOPLw7LGiMSYTGpTpHkh/XGWNu2cGZU0/TnhvxYEAxQUs?=
 =?us-ascii?Q?ock/qYRtq9EK7gaYZNyfUEj8uJ9HjWj5v8JrRg8mUs9WvOh5wKHWaBJ8yQhX?=
 =?us-ascii?Q?YsRlnM5v1+ob66xxwg5XvfWcqlWzclXOenZI4rKv20tt24TYpTiqTlblysz+?=
 =?us-ascii?Q?KHVchrqHChi+ZBryvwJH9e2QdMEt958hQr25ZXeOmscSxyIYNUCMVnusmjB1?=
 =?us-ascii?Q?LPzSshiBP16dSBAegJSGNW18Ozl9elxAdy69EchdLakYr0Ugw/OL4mAkYpuB?=
 =?us-ascii?Q?NyhY/ZT2W/S36gaXOx5TsJOXK0XfBjyqkgck5HIb0GVd8cua56X7ep64MZre?=
 =?us-ascii?Q?ZKqnKPeJTelV+nT89tMFPCkuNHocUVrLU04LBu/EyYPblcEpiYwxU493sKXo?=
 =?us-ascii?Q?GhQd6FkFiW0KkJR1Y6IPxurYr13SR0imjCQxIr7j+7WyOg8pY9IJtzM7n0lO?=
 =?us-ascii?Q?xtxMKEaPdKeDXWRC86++eIFgnwaXOV9ZiO/biwoIovIAKMitDPt1ZD5z7qoy?=
 =?us-ascii?Q?VXssh8JoetNbTlkBWuGDgWTNz32AfHhbcv8rGqi68/DieeI9/SUKShZPTpdD?=
 =?us-ascii?Q?5WxRCsJpTDCu2E5e44k3j/o0JDr3z9zxzgDh/lqJU5rTWTBdz30H+zmfIosv?=
 =?us-ascii?Q?OarTKUcrT2w1IVwbhkNjaCskCD1tYe94giG22N2DuB8CX2eD8EOa8piyudtu?=
 =?us-ascii?Q?ZVA2dRUYZZVqZZO6TI1T31c4kqLMVeyNkIzNwbloDqTjJoT4X9kozC0klAn6?=
 =?us-ascii?Q?kHFztU7vjZTl0Z7v/w65vwJ8lytEs74pUHgEi/IYz+kOKuUNU18EaKmniov8?=
 =?us-ascii?Q?uwkqd2MPDTxXt8dRnwr93vGrJApPx/mxZki3nb4PB3R4R13Zn1mqvrn9u+8D?=
 =?us-ascii?Q?WikOOJAzXW8/QfILq6F8S6a+RgAepEvVghp2lCUTEr8CfV2oU1lfxqb1AwMx?=
 =?us-ascii?Q?cCwJrY9AU1yEFpHBgkBFEfKTOBZj/Jz/HyEiThpBs5RgujS1+r2SCPu7iJKy?=
 =?us-ascii?Q?adf++wjilcTMgzREZ/bL2l2f88EDP2ItB5O9RnExSNI72sAckdLOQlN/3OMm?=
 =?us-ascii?Q?R12cbz2rqKPTCm8j5xDmLyY/tDpMdkYNO1T3mNDS2b38J9x0CDWyAsZz++To?=
 =?us-ascii?Q?DggAswA/diV/bYul3GCOzEV9v59Edv+KL+mzMshyOt4N7gisQ3PxuOItqJYT?=
 =?us-ascii?Q?/J5LiNZ5xwXAeZ24fvd9vYG1LGvFd7qLzu2xZ0eWMd29CcRhyMinMkWgP2Rl?=
 =?us-ascii?Q?J2R4XZwHvWUkZqLdGcIqfEPPyEY52pjJKHJyiwQ1gshM/s00CC0YppmcyCwY?=
 =?us-ascii?Q?PFsXUN+uBZlMhT7DC4WjPTJWO18vo0PTrBPKFSev?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f9e4ef-ad2a-4d9c-0c83-08ddb3cafcb8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 09:30:56.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDHtAMKSFr7B2mBsF90UKqoo4H9d8XJI1XLphkrfTlCYWLB42jXXqLm2bjC2qNpXdQenWqNK+cKOlDuCOrw+ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7597
X-OriginatorOrg: intel.com

On Wed, Jun 25, 2025 at 02:35:59AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-06-24 at 17:57 +0800, Yan Zhao wrote:
> > Could we provide the info via the private_max_mapping_level hook (i.e. via
> > tdx_gmem_private_max_mapping_level())?
> 
> This is one of the previous two methods discussed. Can you elaborate on what you
> are trying to say?
I don't get why we can't use the existing tdx_gmem_private_max_mapping_level()
to convey the max_level info at which a vendor hopes a GFN to be mapped.

Before TDX huge pages, tdx_gmem_private_max_mapping_level() always returns 4KB;
after TDX huge pages, it returns
- 4KB during the TD build stage
- at TD runtime: 4KB or 2MB

Why does KVM need to care how the vendor determines this max_level?
I think a vendor should have its freedom to decide based on software limitation,
guest's wishes, hardware bugs or whatever.

> > Or what about introducing a vendor hook in __kvm_mmu_max_mapping_level() for a
> > private fault?
> > 
> > > Maybe we could have EPT violations that contain 4k accept sizes first update the
> > > attribute for the GFN to be accepted or not, like have tdx.c call out to set
> > > kvm_lpage_info->disallow_lpage in the rarer case of 4k accept size? Or something
> > Something like kvm_lpage_info->disallow_lpage would disallow later page
> > promotion, though we don't support it right now.
> 
> Well I was originally thinking it would not set kvm_lpage_info->disallow_lpage
> directly, but rely on the logic that checks for mixed attributes. But more
> below...
> 
> > 
> > > like that. Maybe set a "accepted" attribute, or something. Not sure if could be
> > Setting "accepted" attribute in the EPT violation handler?
> > It's a little odd, as the accept operation is not yet completed.
> 
> I guess the question in both of these comments is: what is the life cycle. Guest
> could call TDG.MEM.PAGE.RELEASE to unaccept it as well. Oh, geez. It looks like
> TDG.MEM.PAGE.RELEASE will give the same size hints in the EPT violation. So an
> accept attribute is not going work, at least without TDX module changes.
> 
> 
> Actually, the problem we have doesn't fit the mixed attributes behavior. If many
> vCPU's accept at 2MB region at 4k page size, the entire 2MB range could be non-
> mixed and then individual accepts would fail.
> 
> 
> So instead there could be a KVM_LPAGE_GUEST_INHIBIT that doesn't get cleared
Set KVM_LPAGE_GUEST_INHIBIT via a TDVMCALL ?

Or just set the KVM_LPAGE_GUEST_INHIBIT when an EPT violation contains 4KB
level info?

I guess it's the latter one as it can avoid modification to both EDK2 and Linux
guest.  I observed ~2710 instances of "guest accepts at 4KB when KVM can map at
2MB" during the boot-up of a TD with 4GB memory.

But does it mean TDX needs to hold write mmu_lock in the EPT violation handler
and set KVM_LPAGE_GUEST_INHIBIT on finding a violation carries 4KB level info?

> based on mixed attributes. It would be one way. It would need to get set by
> something like kvm_write_track_add_gfn() that lives in tdx.c and is called
> before going into the fault handler on 4k accept size. It would have to take mmu
> write lock I think, which would kill scalability in the 4k accept case (but not
> the normal 2MB one). But as long as mmu_write lock is held, demote will be no
> problem, which the operation would also need to do.
> 
> I think it actually makes KVM's behavior easier to understand. We don't need to
> worry about races between multiple accept sizes and things like that. It also
> leaves the core MMU code mostly untouched. Performance/scalability wise it only
> punishes the rare case.
Write down my understanding to check if it's correct:

- when a TD is NOT configured to support KVM_LPAGE_GUEST_INHIBIT TDVMCALL, KVM
  always maps at 4KB

- When a TD is configured to support KVM_LPAGE_GUEST_INHIBIT TDVMCALL,

(a)
1. guest accepts at 4KB
2. TDX sets KVM_LPAGE_GUEST_INHIBIT and try splitting.(with write mmu_lock)
3. KVM maps at 4KB (with read mmu_lock)
4. guest's 4KB accept succeeds.

(b)
1. guest accepts at 2MB.
2. KVM maps at 4KB due to a certain reason.
3. guest's accept 2MB fails with TDACCEPT_SIZE_MISMATCH.
4. guest accepts at 4KB
5. guest's 4KB accept succeeds.

> For leaving the option open to promote the GFNs in the future, a GHCI interface
> or similar could be defined for the guest to say "I don't care about page size
> anymore for this gfn". So it won't close it off forever.
ok.

