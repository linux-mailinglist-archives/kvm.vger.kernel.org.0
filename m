Return-Path: <kvm+bounces-63093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 185E4C5A888
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 713523A7269
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC60328603;
	Thu, 13 Nov 2025 23:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bhly+HIx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDD830CD95;
	Thu, 13 Nov 2025 23:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076271; cv=fail; b=pVntZ7URoaHZwl/2yoMweCCg7boIMOcZ92N4xt+3ry77ixatbikaVzYIVkTuJbgEScgpITKv+BNL90hvmIPocCJ3ZLhwCQeNbeDOSVagp3diMHYrGtZvJHfKHX57bbUDcruhAuU3YFV/2H4UyUYk4I87KdaxIctoGxGWnC6+diU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076271; c=relaxed/simple;
	bh=HsbaX6GPC1Fjyw02EbmiyAHfr5WyjeC6wIlRQc/pqhQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hQ5BbYs3JdZtliHsWP/VxBSoTvOGaZ6q861o2zTj6XBByyfMVyVmobNHGSEPSdHQcTW0M4TTlvMIH9sblAApo9Ck+zOQVmN1wPnLm+gTua9EaEd4N0iYjNCCmr/2WSHFkENFTeAtJUN4QcRjbSrgpAOSc5hlANyZg73Ri4l8LqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bhly+HIx; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076270; x=1794612270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HsbaX6GPC1Fjyw02EbmiyAHfr5WyjeC6wIlRQc/pqhQ=;
  b=bhly+HIxyOoMPERwus74np379QIWDlGWHGryQSmowiYcrCPyt+C80Xof
   OfyDLgdiWniZ6mK8PbGeEzmg8cbKXCmvxFLKY8CvFWzyxpnvVSyW0I9wE
   P8GVbrJ9YVENwBYmXNCDNmHYRRIK+WotDJpSEMKIpOkjBBByPH4ShDkmF
   v9KZhSZzEeuNHnxd+P5TVp3zHfXprLGsKdt63wBxOXdszZJ1OVk57klHr
   DUn6ZodBXBdWQzGfoCU/WdU62PbEK++HbPoInuEdoUToOaby16EzqYBUd
   LtY+AApNpKgF3bZ345uLHX2b0he/2+dNYBRm+OqLEqhos3GypNIVG05Xn
   Q==;
X-CSE-ConnectionGUID: gTp0g8l+QByVJjOTaRXtaw==
X-CSE-MsgGUID: RDpjZ+1KStK8Hg7tnROsEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="69020164"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="69020164"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:24:30 -0800
X-CSE-ConnectionGUID: YQNIMQTVR6aIePD7Wse34g==
X-CSE-MsgGUID: yYO112DTSkyksbbhNwSvwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189633973"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:24:30 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:24:28 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:24:28 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:24:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZH9yGqmpEtSPcIvyqCOihSDAAwasYmsCDGaHzFE8w/5NXgy9+r9/x6nPHyJsxMs/EnEGls1PbHNiF1pga9XioZ8qYuTHSpE2kSTCxNdXIk+hsdsnodPbZ4hsLaDb7cb55x3OflxNaKpbUxRKzr9nX7/hW4DjLOoCjKFhxazStbnqTV4X+lQkOPnv+5me71k8ZINONDS14o8yJghN/P5DFg7XY1mLffc9MWJwzO+U+oFA4ZpCt8UUlAVftfzoPy/v6/uR7sXRSt0rosxupIBrv3fZzUdhIwAdG2qObPuFMDPfjNc2YUniYma/C5H7NHTI5QfUAkZuTZTnUDYAaIz6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyXyH4HtOpAFPeHyT6/DsnxgpbgC0mES3odZIdyOPF4=;
 b=eLKQzsY7+H99A/DdaX2neHWt1lUAUwosDEAGcttXGO2pti0jrMhCiQ/8m/n7VR3x5Tj0+c0Uw2cNkn8hCNX09D9edgdHuoO6Cp91twwre8wAXOG8WtAPeLZ9A4GoQOf1MDynLkhzbsuw6RKKUCVsj3HiQVfrOBuaTvFIRNuU2c9+vRdLNMDf/B2/gg8TVdWbq8sbhq+aQmTKNO5gQ/SlBkJ/RfPI2gK61UKhpG768a+HvbM5s+b0Rdv8+p/EnVk+5Fp696OJ0cRv4CKkx+56AkzrDMiHp6jbHe/0R+jGkB4LxvdRGbikSc/WUGY2q+QdGJ1ApsMPHOnXsZjQgIsbkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:24:25 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:24:25 +0000
Message-ID: <4931e927-e0f3-40a3-89d6-6d21c51804be@intel.com>
Date: Thu, 13 Nov 2025 15:24:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 11/20] KVM: x86: Refactor opcode table lookup in
 instruction emulation
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-12-chang.seok.bae@intel.com>
 <0de0215b-6013-4565-9cda-92a7b6f8c34b@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <0de0215b-6013-4565-9cda-92a7b6f8c34b@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0390.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::35) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f2b608-ac6f-41b5-eeda-08de230bc8ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YW1RTmJ4L09FZ3BXaUZwSGtPWVB1N1VtSDd5VGtBNVN4WklpN1lFWHhDMVcr?=
 =?utf-8?B?Z1paQmFTR1VWdnhMazgvemo3NEk3cnpxRWtib0tzb0pDQlpDdmFPWGV0YzZF?=
 =?utf-8?B?bXhUK2E1WlVwMXE2aFpyNjMrS01Zd1g0TW01NVltQmxNdWxMaVlIYWV4bWRI?=
 =?utf-8?B?STc3aHByUFZjSnBQQlhaRkRzVFFRMGJTakRsUjdIaFNobU1XcjRONzdTR2xt?=
 =?utf-8?B?OTBSSGtUc2FtOHlVaFV5TnFmZE03d1hnK2JsQXEwTEJZTXBHdXFGZnZwWmJy?=
 =?utf-8?B?QWFNZ1VHR1ExTmg5YjRMQjRDVklJZUhuRk4zdDdGVFpVSE9rMDJrdDlxZnho?=
 =?utf-8?B?YUlOYW1GVHMybGk0UGRQajl2UWZHN3k1TEYwQXA5SEphTmN5TzBVNjRsRCtm?=
 =?utf-8?B?N2pFeG1aWWw1Kyt5UFdSMXFWOUR1cU9lZEpBNDA5b2p3YWU3UDlHOWY0eTJa?=
 =?utf-8?B?T0lKVnV1SzRTRXpZa1ZTd2svcWJ0b1Q1RllPOWt4UHh6c0xPeEUrNHZFZENx?=
 =?utf-8?B?SU1yb1VRT0tiVThFV2hKOE9LdjNUd2w2OWdTVFFYakY1MndENWF0ckhJRWJq?=
 =?utf-8?B?cGtyMkc2NDBvbURRVHlEb2VVNEFKMGpOa2lUTUtPM21SUjR6dElQKzRCZFJy?=
 =?utf-8?B?TS94TENyT3pUckZncG1keDhEemcyNDB5NkRGYmdRTWZGTDlOVEYxeE5XRVdw?=
 =?utf-8?B?ZjlkTWcxOWpUQTFqWlRENkEyNW9yZTQ1UGdaZFM5TVhxS21yaURVd01ubkJ3?=
 =?utf-8?B?RHJsVzNIc2dBazZtdVpOVnh2aUFIWHlvWUx0WUxiZ3ZSMnNvekNwYm9JZzBk?=
 =?utf-8?B?Y3BSS3MwUk96aTZaVzlvRE9vL1VCeTdlSWxoSHlyUWx2a29xRFFzT21SVnZB?=
 =?utf-8?B?cmt3QXpmbmN0RnMxUlZXZS9hMy81b1NUdUN0eEQ1V1RlNjE2SVdHaDJGQmUz?=
 =?utf-8?B?U0IzQlNmTnorNWZ4dHZlUC9sN3hQK1RJR0VYaGN5K0FDeUh1c2VsWlJYSDd4?=
 =?utf-8?B?UUV2M2pocGFYNjh5dTc2dDZmOGlhbVROMERseFRGQzV3cVB3cmhZdUoveXVE?=
 =?utf-8?B?KytpaklKc3VtLzJweU9SQkRPKzU4Wm5kY0dlbmZzeGlhZTZYWjkvNlVDeFUr?=
 =?utf-8?B?TklYYWpCUS9RMERYcjcvd1paWmgrclk1U0ZTa2w4YUZ1Tm1ucmI1TjVYeUdi?=
 =?utf-8?B?MGpya1JyczJwby9GN214aEJyS0tPeDl6djllaVZ6S0ZzdFBOc2k5RTJCZ2tL?=
 =?utf-8?B?cCs3dmE4WTJxTWhEcmc5ZmJkdy9oNEJSaE9ScmxhYW9wci8zUXZ5eCtGY0dZ?=
 =?utf-8?B?UkRLTU1TblNVa2ZYbmJxeU15ZEp3Sjl2ZkpSNnhsdnduSUxpZlJsVnIwZU1G?=
 =?utf-8?B?M1oyQUxkcTZqSis1bEk0bGxmRXlxTzVYS1VwYXBIRlpyekVualIxZ1kzeVdv?=
 =?utf-8?B?K0FnOE9vSkxSZ1JDVU4yZG9ma2xqdG1abEFtYUZRY3o2aVZGb1lnN0U1Vi9W?=
 =?utf-8?B?MGQ0MUl6MHE2Y3VPMUJrcUVWdjVlNE5wS29MYlZDeHBQTHI1NS9TazZCaFhH?=
 =?utf-8?B?dWJCMlh6MUV4TlNrNEZoUUQ1bGNGaUdnR2JuY2c1eFZsSTdwd2h6eXp6LzIy?=
 =?utf-8?B?alFpc2hzZXQ5c3ZKV1NyOGRQSkhSeklxa3duZVlHbVNWUDlWSllqN1Z6bjNP?=
 =?utf-8?B?R1ZqTE9zaVhzdEdNYzU0Nnc1Qm14RklXRDVzaE8rc0NpT3JFVEU1Z2g2cDR3?=
 =?utf-8?B?RFl4Lzh0TC9EbHpoU1F5NFBDY0l5ZWk4bVNIdHBpN004RElFNFF0TDRUYkg4?=
 =?utf-8?B?cUovTFVYUVdhT2tXWmo3V0hhWVVMNmYyVHhNVFJrM2UvQSsvcFBJZSt5N0ox?=
 =?utf-8?B?aGgwL09LekUvZG1WQzcwWlhBVUdtaFV1VUExWmlFWm1vZ0N2eis0b0NuYnlu?=
 =?utf-8?Q?RqfeDiqlqIqnHBCV1WA+xdEZkqNpOadW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFppNjR5MGhWTmtjaW5pNjdPTEZQNnc2NTJaYUUzNzNTUzlNSTlXOEJqa3hT?=
 =?utf-8?B?bENLbGVQOXdGSjQvemV3T2p2NEh2Y3V6SUkwRE9Cd2x4Y2NoYW1ON3hoTDFv?=
 =?utf-8?B?OWxObnJyL2tWeFQzdXZ3QS93TkZQNVlkbHhtVndhWHJqVVFUMi8yclhVWi8z?=
 =?utf-8?B?QmMxK0tPVVZGclJFODdEZGNPczBtZGczWEtWTHFNa0VGR0UxdW5lNm9rZkdC?=
 =?utf-8?B?azdFdmhmRkd2RWw4SDkvU2o5VG1lRk9CTHhlSTR1OS9QMWZxWVRoY3pGR1pT?=
 =?utf-8?B?MmpmazhmWmZOa2UwU2ZsKzQ2T3RmTm9LWVpQWjZzWWtzVE53TEtlNCt0cDMw?=
 =?utf-8?B?NVFVQjdva1Z6Q2QwSWdBU2dkeXV0LzRDOEZqMS9NYWpyamJielpBZGZldU4y?=
 =?utf-8?B?NHhQc1VJWkFod2JiL1NGejZzUEgwZU04TFpLTXJab2x6alJ6NktVMzVzRTli?=
 =?utf-8?B?UVM3RHZFTk5wTTFobjd0Z1NvRnZlV1ZiSnZRVW1wSGhyTVBZNXVZa0UyVmNU?=
 =?utf-8?B?dUhhWWRyU254dFB3OXZGMVBKaThGb0kwUFV3eVlMYURUZHRFdmdiNnMzcjJS?=
 =?utf-8?B?TDVHUWZFUVJESkZYeFc0NHR2Nkt6b3BvOW9CSEJFTVVmKzJJc3lhemx4cHky?=
 =?utf-8?B?dENXSk1SRHlvd2h5M1NGRzgxY1Axdkt6QnJNYVBSbjZ6QjdNOWNzdFc2M0RK?=
 =?utf-8?B?ZXE5NEx4TFdHaDRMV0diMWdSMVBSbXcvYXhuemt5K3hVa2ZtTnhYazRBK2Zu?=
 =?utf-8?B?dGhJL1BIYkFPaWhicHcvNVgzYXp6YjVSNmFLUE94bWMyTTM3R0czSVVvY3J0?=
 =?utf-8?B?bW0vdFBTdUxoRTV1VkZGeXJQbldidkdwZTZjcjB3MkUwL3BOdkFwcTNHV0I4?=
 =?utf-8?B?V1UzdFMzOFJxYUdORGozT3MxeFNReDFmRFh3UjJPUXVBVWtxMmk2aGx0Z0RX?=
 =?utf-8?B?azI0b0FEdFQvSnY3NjFJeldmbloxY2h5cFhrK0REb0psUm9HdmlyNzNhdlZX?=
 =?utf-8?B?SnVoenNiZ0NTSWxISmNJZHhaZTlrMnpiaUcvQjZxMHUvQmNzMncvRmlJSzZa?=
 =?utf-8?B?Ty9YekUrc1pZbUVOVkJLK3UzbTlycU1GdjcrYWVneVVWSEZkZGV6dWNsT0Vh?=
 =?utf-8?B?ejJ4a0lxdFdaY0dyZDgxSE5MSG9VSXJEQ1dZOXpTQ1FHckk1aTBDYTFvdG9j?=
 =?utf-8?B?YytUdkdSendvWHJWZXhzb3V2MUM2MzU2eWNyTE9NLzYyUW85a21taUpaTGlO?=
 =?utf-8?B?MElOdjhzN1NCZGVGbmVITFNtR2xnV3BFUHZDbTVRVGpwcGxQNk9HOEJqNXly?=
 =?utf-8?B?Q05OSUZkZHFvbURtUHBUMDhENVRBUjBuSWdTbWZGN2YwbkM0ekkvcHkxZGF3?=
 =?utf-8?B?cEFVZThRaFBkdmoxS0RUMW1rUldSRTRNdUxJVy85bFZReTllOHM5YmhSUXFX?=
 =?utf-8?B?OWVWZ2VITUg2c1REQ3pjbVMranJ2VlVyVUYyYi90ZWV2R2VEeWpIK1dFS3F1?=
 =?utf-8?B?UGlwbkJmSk9aK0ljOTUyT214TkllR0RhakVEMmFTVk5IYUg2ZFFhYk1yZURM?=
 =?utf-8?B?R2diWUtCbm13cVkyelVuYTkvdGRuOWdMZXhkYVJUTzY1S0J0MnVtWmhLTGZj?=
 =?utf-8?B?djBLVHRpS1FxTEJoV2ZTYldFRGdLMTFlSVZocHBrQ09vVGM0Y0pnSER6Qy9s?=
 =?utf-8?B?R1g2TUtqemZYME5pdXY3VDdSMzZkVHorY2I3V3Z4VXdRSWVzcnhOaTBMLzVI?=
 =?utf-8?B?UXJ2ZUhtcGJVSjdTZUE5MGNJVThRdEI3UUtUQ2RILzRSUXJ0Q1plL1RLT3ZJ?=
 =?utf-8?B?Rjc5L2Q1NUdjMXRDK3lvZ3F6TkdZdUxDeE43RmlnT3FWS3A5N0pqM3prMVpD?=
 =?utf-8?B?RGRGWUcxbjJrMXo1N09FQWt1UkhvbnFoTzQyRUpSakFwNXpySncveXNQQ2Vk?=
 =?utf-8?B?VXRnYjlVRldNM3BIOTJpa1ZQaDI4ZlQ3cW1PRjdtU2VteFlMUGtyNXRHdUti?=
 =?utf-8?B?S2YyTnV4QWNubktUT2hSdUNDcTFxWjE2VndzMWFWaVY2ZW10RWhKVyttd0ND?=
 =?utf-8?B?WEtWUzhIdktqM0tPQnRYajJhS00xbXVvN1Q1YWFlbnB4eEF2T2x5VlQvMXhm?=
 =?utf-8?B?SlJYS2NLR3Q4UzJ6a3dEUGdCbG9oNERDT3BQbDBLTWNHQXdUT2Jrc0w1LzIw?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f2b608-ac6f-41b5-eeda-08de230bc8ed
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:24:25.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrIp/YS/ReIN9Q9HYB7LQvwBA1Jw695n1lIFt0AyrMUSw74rFPHkz/C3PeU5+KolAi+Nstavu2Lrp7BZtmRity/JPoQ/ic3gkFp6eSygz3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

On 11/11/2025 8:55 AM, Paolo Bonzini wrote:
> 
> This will also conflict with the VEX patches, overall I think all 10-12 
> patches can be merged in one.

I initially split these into micro-patches to make the first round of
review easier. But yes, now that the series is shaping up, folding those
preparatory pieces together makes perfect sense to me.

