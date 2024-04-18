Return-Path: <kvm+bounces-15044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2EA8A9060
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 03:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CC701C21387
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCC6AD21;
	Thu, 18 Apr 2024 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SCo/jink"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD05053AC;
	Thu, 18 Apr 2024 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713402592; cv=fail; b=OkGSHutn3fO0Mk4sn8sur3+8h7uM4uSHee67TZtkScUlxZiMusGANDXjBGb5GhwfmHVBQYHfITmYJeq8r6ybIvCos+YTNwZTWwGsPvN1Gh67Udc3IZBJphLQu/7As12+0kV3Y/dxI2bX4D4J1gE6RMNZbidV4xQXouH5Ix+HBQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713402592; c=relaxed/simple;
	bh=X0mTM25pvuVJu0sNOILs5kY9oKOKmY10kiN3qMauWdQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YTqLoMkB9LTSnoXDCY4LgOedfQqRJK+WemTC9CZWZo2gnCg54PVBK3a0kvFGOKQw5M8S4lGe5WvR2yJ8X1WVhfNzUDdj1/sSYo48N9wwNTQRXyLzsr0flnduPToUFaSH3A8W1w/pd/pN25VZifZikFun9JkCI4NaNK1UfRVR5+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SCo/jink; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713402591; x=1744938591;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X0mTM25pvuVJu0sNOILs5kY9oKOKmY10kiN3qMauWdQ=;
  b=SCo/jinkE0IMBL6muVukl64VmnngAlM6NSuvrh6Ju0LzYqtTlJYNS05w
   7EyNJuP/tscVEjOAF9vm6tGxpRgNfjCy9Y95ZaAF9TqZUHuq8v8t3yVuz
   zziq6vSLcli3dUHu39LJs6Wf3LqttGTt6Xtq7H8cZH7mdH5A38rlVQJ00
   GrExwp1b3oxxqrMA0ezYhDbmacZVdvGJrsQMHI8IpaILsHLeeqpe6rJB9
   WzURfTR21vcrn93VFvVFewgK7ofppRbzKXKY72FBeCdGW18nxEC+YEW/C
   q5VjNbnGx/Wm/+RB4zcRA2G5OwOgci4zPGnuW+5vIC//i94Z0sx3FhGeQ
   w==;
X-CSE-ConnectionGUID: na23GvwKTMW7gAYUEYfv1A==
X-CSE-MsgGUID: 6e9pCN9bQUSmvD1hTr2CmQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="19627829"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="19627829"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 18:09:47 -0700
X-CSE-ConnectionGUID: o39bujFVQE++AbjuOifc6A==
X-CSE-MsgGUID: PWaUS4tCR/qLVVeaUshaZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="22896776"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 18:09:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 18:09:46 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 18:09:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 18:09:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 18:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j25/2ZyqRKZ7aktOcixCyoVz7z3SSoTYjo1aqYqeVGW2/HuNiuJFksy+AM0o26X/M/dABuGgr4eBYYwV0Cuocenitr4A8TEkxxG/iqI/tiU7src1ncl8EtWqSr+0I8QhwcIJb8hqzVXkIsCaLt5L9/ePzB97T0a3RY17xnUtlsxu6b9GfqbDVJB9ukbzEmGdGxOREl+3f/4S5R2FaKojIax93BGHMa9JaU+YWReXscUNxH+7uk5GMoejnuwutW/syGFOFDJkXTxbBaO5lNcznGnfYu26wUMYuOAy2K1wFXwy+ofHJwInFW5PGnb0GdSguls9WlHFsr9UdPSvli8SvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cl2zoA2L2KHnxWCIJi+2YQcr5L8ul8MMwExQ1ezhusw=;
 b=O7fHnq7qNnDY0AZVQG9wMnnTn29ew9pVIoMv14zgoOvFnuFwct0mFTmPPNJL69IyEO9QcLsf1Uv0YVTuGYdl36jLG9qEOsXFFvupDHpXzWNzRT/v4JfWHZte6nPrAMLPv4yYXxCBe8tlpBCs/RU5FQD3unzIovZxVcvszQz+yi1GPGhZaP4xLS1QXmh+WK4gUmUqLDIRV9K8Buv4b2F4cIVXXUSddGZ9+NiwGyZ1HT6sMs2YTYcT4bgBdqb1toJY5K6BpEzO2HN9agYp65rZI8Xw8u73IEqO8QLsC0SDZ1raUVjV72jCHegKbyYw8TShzHvhZVRA7zV83ZRTQYljDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5778.namprd11.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Thu, 18 Apr
 2024 01:09:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 01:09:42 +0000
Message-ID: <f1097d63-2266-4e2d-996a-a387f497b4c7@intel.com>
Date: Thu, 18 Apr 2024 13:09:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: Sean Christopherson <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, Sagi Shahar
	<sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>, "Yuan, Hang"
	<hang.yuan@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
 <20240412214201.GO3039520@ls.amr.corp.intel.com>
 <Zhm5rYA8eSWIUi36@google.com>
 <20240413004031.GQ3039520@ls.amr.corp.intel.com>
 <Zh0wGQ_FfPRENgb0@google.com>
 <20240415224828.GS3039520@ls.amr.corp.intel.com>
 <a552a48d-81b6-441a-88cf-63301f6968a2@intel.com>
 <20240416164432.GZ3039520@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240416164432.GZ3039520@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB5778:EE_
X-MS-Office365-Filtering-Correlation-Id: 205d5ba5-6d6e-4dde-4ff5-08dc5f443a83
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/nIndK8QOaScLvu+F+TAduJuU16ah0trUo8yLv9vy1ro/tMj9neae8hQ+ARDw2RMXNtHXnBXRuHIQoVkQEx2+BC9QqrpkUYFHoinljWSon/bIppWsn9RvEKOfFFilXIPSvZAdzdZawWYaj8OPf4vXf+UzudmE9vQ2mWhqUVaO9YtBkEa4tlesGjPJ+aPKPUk1eA/sLsctKfZDUVuxlaZv4CePNE4BcIHnR6zlTArrYq/dvNu65F4wA6GKqJGDPDDyFk6O+WXGFRX31lge7AIZZSr5lNCB4pLdWIc0rMiq+r0r3X7v1/wdYF4jbIZFjQq92PpA1f7hippNWXnR/rl24+9vNV9dbaNuD9axqUel/nhbRvNtVbBwKe09GsUqhxfVZQneCq/yIOqZVIPFrc2IbI1+7pP5apSkHSrQQK7hIZjw6CGsK0dQ7VzNZlXCvkU2VuCsthKUsCLyiQN5wgZArEukhz9+FK5g8G7Snp4yguuJ3n5Dg8lga2Ss3ESkyRFk7PG8B/I5nn9yw/A8hcAaEgjGw9EuoS6YHApTKAg+U58TCODDsCemXBaJYTt7O6e8zQleCDM+qazlUZ0LNOE0bV5x8n/6PGUdgcPTH7JeKPh3z3TZHSMkgmgo89dd/2nA19URKAqae16wnM7aUajs1QAEClZG6dK9/VP5jNczs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjhTWlVESkZodURWRnJNaTI2U2JSZWptM3FPbVNMM1pvZHEvVjJlRjQ5WFRF?=
 =?utf-8?B?YTdRb29CanBsNXRBbXFVYU80WWtWV2llYURQZFNJT3B4RXZFU2x0Rnk1SElH?=
 =?utf-8?B?UUYxNmRIYXczT3BwQ3pWSVkrc003dlhVaG95aXo2WVBGRm9RNGZnN1lvSFdv?=
 =?utf-8?B?RFM1WjQ2Ly81VVE1NDFDbzJ4QnhzMEQ2VTNMQmpYdjNkYXA3UnYvam1XS2JJ?=
 =?utf-8?B?aUQwQnNYa09EQzZzRGVNbWF6YjQ4REhCLy9oM3BYdXJrN25xcUJEaWVMc2l2?=
 =?utf-8?B?S0l2U2ZXeTY4NWFBUm5LdVRCZUtBMUV1dkhYVStFcU5RT1ErTzh1TFdxZU4x?=
 =?utf-8?B?cXFwUThYK2Zzc2tDZzZCNlFXWmZKQ0VxMm5TbGErNFhjb0d6NGh5K09jaHFk?=
 =?utf-8?B?aEN0aHhjRUdVRkthQmpVZDZqTnRLU2NCaHoyOTZpcHpaNmYvTzI3MnUvSXJh?=
 =?utf-8?B?dzJib0djb0piVkdNQ2E3UWMwaGRyc1poSUkybEl0WjU5aUZWUUtNMHFxR1VZ?=
 =?utf-8?B?OGZVTkttMVdOR1lxUUxEbzd2a3lNSGdieTQ1WG1RdTZ6YTNQNEhuait6VGZt?=
 =?utf-8?B?QnlzUUtiK3RkRjlOdXZwdFk5WkZqV2pTRGVIQVpISklrdE1tVEo4ekFzZ0w4?=
 =?utf-8?B?U1F0WlliWHNteE5XUEZLbDdTUXluSEkrTEpxaGVQanlQbHJNelRoR3JmcVVv?=
 =?utf-8?B?QnJ5UkFtWEhObUxRZkNCR2lmaFI4QkZlQnVrQkdmZkgxUWhsTWowQUZkTi9P?=
 =?utf-8?B?eVBONjhPK25vandBWU15S0NYMXVEN2lBODVTNk93b1llYWt6aTNuUi9VZEdj?=
 =?utf-8?B?SFFoV09LZlNQL2hsZG5MVXVnbVA4MHpLaUJ2S2RpcEdYZ2tPU3orbnRid3Q3?=
 =?utf-8?B?V0hGWTZBY29FQXhLSFJzcjV0NDJvN1o2MDBYcGhyaVFFSk5FQWRBTXBEeXVN?=
 =?utf-8?B?ZnhSbGhTam5Kb3RnSFZiS0FlUWFTVkhESU54cUpnZnhlRlJRa24rWHg4dTdo?=
 =?utf-8?B?ZllwUTk4djE0c2h4R3J0ck94QkZVYUJMS21hdm95dmdrQlNGczJGZEtpeVZs?=
 =?utf-8?B?ZlB6blJTZEJHMVZwS3FYVHdYQXhpWlJhUFBLT09lWU9qKytTRXR0emNERzFR?=
 =?utf-8?B?NkdGYWNXVXN4dGp3UklMeHJDd3ZJRmdMWmFrRTRKZWxNcXUyN0JLTDVtamhx?=
 =?utf-8?B?RTB6L0diL3NMUUhvS0pFYWxZZCtKb3JMRXRkYUJWWUdBMEdjckd0SUI2dnJT?=
 =?utf-8?B?dmtnZ1owZGw4ZFFJcmVwNkVWaTMwN1JOMDVPZ3NtUEVaLzhLZFNRbEV5VU9I?=
 =?utf-8?B?UGYvUEl4VXdHSWJ2VXBqRVpvOTZqNzQ4UXR0aXN4YWV0c0dYcXQ1ZlRDWEF2?=
 =?utf-8?B?cGRQTTNrWnZLM3hRUnZ6K0Q0VktOdWJ4b1p0L0dwM3lUM2dXdnlwVEZoV2p3?=
 =?utf-8?B?N2QwaElJWGhQTmFVM2Y4WGdVc0JsOHdHSlYrejd5d3VQd0l3eEVueFcvNE9Y?=
 =?utf-8?B?cG1ucVFlbU8rZXZ4SXd1a2hBdXhIQkxybEQxb1I5NkFvWmVTOENwV0dFVmM3?=
 =?utf-8?B?ZXE3M0FHWEpVcmNBMW91WUdyRW9tUTg5ejI2UGVoUERTL0ttTXBtSTVKU3Zx?=
 =?utf-8?B?WFFjcHRmVkFINTFWYzdoNEpiVUJTZzhicFZ3eFpOUmRkMWpkSUZDRlByd1gz?=
 =?utf-8?B?ZTJaVG1WN0NzNzFFUVFPb1E0aUZKUHh2UzlFZkdWYmhQcWQxcWR2amovYTBY?=
 =?utf-8?B?dnEvaENuRmhwWEJrbmJ1bXNDRFVUWXd2RDhkUmEwZDd6Zkl5YTM3Z0RFN04x?=
 =?utf-8?B?OXZ4VmxVeDcrTVZrbVFYS0Y2T04ySGF0eE55cERvMWVEZlVyUXB1OTQwRzNX?=
 =?utf-8?B?YUI4Z0FpVEVXNWpoeTN1RUNpbzBiWlErS3lFNExZMGh6VWFFVmpNczhYajdQ?=
 =?utf-8?B?cTFsZFllRDBlZ3lEYjVEUnQxRWlGTEk3dm5qZmRaNzlSWktlU2NwTFYwS3hh?=
 =?utf-8?B?a0FrZXVJODFNVjR5ZlBJWTFxeU9FSW95eXJyVGE3Y2ZQa3FyR2tLakFLaGt3?=
 =?utf-8?B?bjJzZ0RaQ1lWSnVnaXJoVGNMaTZadnV2cGUzaWdUMGlMU2tmQmh3cVRsVFh2?=
 =?utf-8?Q?s7Odcjzr7krrJezeFZ2MVwZsM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 205d5ba5-6d6e-4dde-4ff5-08dc5f443a83
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 01:09:42.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EDelQdHvMhC9k+447idzrjGQsme+RemwIIJXfK3rRcP59LpJmwvpHcTM1TPl4hqUAHJdcld5R2h3unrXTxL6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5778
X-OriginatorOrg: intel.com



On 17/04/2024 4:44 am, Isaku Yamahata wrote:
> On Tue, Apr 16, 2024 at 12:05:31PM +1200,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>>
>>
>> On 16/04/2024 10:48 am, Yamahata, Isaku wrote:
>>> On Mon, Apr 15, 2024 at 06:49:35AM -0700,
>>> Sean Christopherson <seanjc@google.com> wrote:
>>>
>>>> On Fri, Apr 12, 2024, Isaku Yamahata wrote:
>>>>> On Fri, Apr 12, 2024 at 03:46:05PM -0700,
>>>>> Sean Christopherson <seanjc@google.com> wrote:
>>>>>
>>>>>> On Fri, Apr 12, 2024, Isaku Yamahata wrote:
>>>>>>> On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>>>>>>> +void tdx_mmu_release_hkid(struct kvm *kvm)
>>>>>>>>> +{
>>>>>>>>> +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
>>>>>>>>> +		;
>>>>>>>>>    }
>>>>>>>>
>>>>>>>> As I understand, __tdx_mmu_release_hkid() returns -EBUSY
>>>>>>>> after TDH.VP.FLUSH has been sent for every vCPU followed by
>>>>>>>> TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
>>>>>>>>
>>>>>>>> Considering earlier comment that a retry of TDH.VP.FLUSH is not
>>>>>>>> needed, why is this while() loop here that sends the
>>>>>>>> TDH.VP.FLUSH again to all vCPUs instead of just a loop within
>>>>>>>> __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
>>>>>>>>
>>>>>>>> Could it be possible for a vCPU to appear during this time, thus
>>>>>>>> be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
>>>>>>>> TDH.VP.FLUSH?
>>>>>>>
>>>>>>> Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
>>>>>>> When KVM vCPU fd is closed, vCPU context can be loaded again.
>>>>>>
>>>>>> But why is _loading_ a vCPU context problematic?
>>>>>
>>>>> It's nothing problematic.  It becomes a bit harder to understand why
>>>>> tdx_mmu_release_hkid() issues IPI on each loop.  I think it's reasonable
>>>>> to make the normal path easy and to complicate/penalize the destruction path.
>>>>> Probably I should've added comment on the function.
>>>>
>>>> By "problematic", I meant, why can that result in a "missed in one TDH.VP.FLUSH
>>>> cycle"?  AFAICT, loading a vCPU shouldn't cause that vCPU to be associated from
>>>> the TDX module's perspective, and thus shouldn't trigger TDX_FLUSHVP_NOT_DONE.
>>>>
>>>> I.e. looping should be unnecessary, no?
>>>
>>> The loop is unnecessary with the current code.
>>>
>>> The possible future optimization is to reduce destruction time of Secure-EPT
>>> somehow.  One possible option is to release HKID while vCPUs are still alive and
>>> destruct Secure-EPT with multiple vCPU context.  Because that's future
>>> optimization, we can ignore it at this phase.
>>
>> I kinda lost here.
>>
>> I thought in the current v19 code, you have already implemented this
>> optimization?
>>
>> Or is this optimization totally different from what we discussed in an
>> earlier patch?
>>
>> https://lore.kernel.org/lkml/8feaba8f8ef249950b629f3a8300ddfb4fbcf11c.camel@intel.com/
> 
> That's only the first step.  We can optimize it further with multiple vCPUs
> context.

OK.  Let's put aside how important these optimizations are and whether 
they should be done in the initial TDX support, I think the right way to 
organize the patches is to bring functionality first and then put 
performance optimization later.

That can make both writing code and code review easier.

And more importantly, the "performance optimization" can be discussed 
_separately_.

For example, as mentioned in the link above, I think the optimization of 
"releasing HKID in the MMU notifier release to improve TD teardown 
latency" complicates things a lot, e.g., not only to the TD 
creation/teardown sequence, but also here -- w/o it we don't even need 
to consider the race between vCPU load and MMU notifier release:

https://lore.kernel.org/kvm/20240412214201.GO3039520@ls.amr.corp.intel.com/

So I think we should start with implementing these sequences in "normal 
way" first, and then do the optimization(s) later.

And to me the "normal way" for TD creation/destruction we can just do:

1) Use normal SEPT sequence to teardown private EPT page table;
2) Do VP.FLUSH when vCPU is destroyed
3) Do VPFLUSHDONE after all vCPUs are destroyed
4) release HKID at last stage of destroying VM.

For vCPU migration, you do VP.FLUSH on the old pCPU before you load the 
vCPU to the new pCPU, as shown in this patch.

Then you don't need to cover the silly code change around 
tdx_mmu_release_hkid() in this patch.

Am I missing anything?


