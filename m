Return-Path: <kvm+bounces-19289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79381902E9C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 04:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 141A72831B4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED7A1581E2;
	Tue, 11 Jun 2024 02:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U0Yw4W2v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E915ADBB;
	Tue, 11 Jun 2024 02:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718074429; cv=fail; b=LHvpa0A6sPJP56D5MpuCC0yh+D9c5rH2tJenkEBOx89BM5VOtVzuj860rTu4omTM009gSG8R29u4eovBi4tuVSxl/otTTHzfBUZ7U62WRfKfpPwKNjne7Dk7huFoMiiHOrwvG2+uAW/CpfJ8dDehQcTT09251IHLRel4iiwn6aY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718074429; c=relaxed/simple;
	bh=0u8KaX4dbsrKbECOr6cIHkcQ4GL372WKdu5dlJWhS2k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sCC9stf+XpCKMO3yo28/PEx9MDhCkCS3LfrGxz3S7E364ntX7iVbAKylTu1GUSbGip8aTLSPqn1AaUNyiH1MFtK6p/1Z7+q7U22XKsJJ3jee93LOyiydA61nZFDYVTF/uuIpDUvNbkHBzFU4IQ1JixdrgdNzEEqvSsV0H7I4EbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U0Yw4W2v; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718074427; x=1749610427;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0u8KaX4dbsrKbECOr6cIHkcQ4GL372WKdu5dlJWhS2k=;
  b=U0Yw4W2vUkIMtIlhL86rpEFKajrFHmuNO0NQMHAluVV7+iqkP1adHbZU
   XVI7SD3PvJ2UA2SGk+prgIyYXpYNtzgj4+P4/XjOWUkgFyRks+t7bpm8W
   3dU5RUm5soX1B5suv6g3tm4y8LjJrzIWeAicpZxHEcDs8/XbuycNxGzar
   QX1unoX3+jHTiVO5UhdPj+xacUD49x+Ye3M9hQ5QeWTv9iwMBDJaBStfn
   U5H1Bc8/JVwIK4NgdGrfyGWKMlfwMuVsNHd8UC1H11vztbTQG+isTK8r2
   d4Obnxm2INIClK3OVgWag53F8Oh1Gx558ef6GmS7+mAcWh3mJtKaDD8ai
   g==;
X-CSE-ConnectionGUID: /1mzIYazSTOTw/kGkkpufA==
X-CSE-MsgGUID: uhPoF6w5QW2SPJccNruOLw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="26163161"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="26163161"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 19:53:27 -0700
X-CSE-ConnectionGUID: BXig3eaCQsCoxKQ45/aE4g==
X-CSE-MsgGUID: 7KxdRZSNTMKFEXi9jR/Q6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="39726374"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 19:53:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 19:53:27 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 19:53:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 19:53:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 19:53:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxsaU4IxOCqv9MurouMWCMyw8FDiHtwYzIyzmE4Vs9DNBhrwXT5JzgzxgKvUeeTrdW/WfkwRyNIxLCKIDSk6PDtrOyqhbBW4+5Gk0pjrMCUeeeSyRZCMdCVZa6/R7qdBfEbBpecnVHKxFmQa9O0sOJSC5z6KXesHKnwcxXJA+1pxxikOlKjnDfzkXSmkUC5/j+PFNFmqvF2kzMgqaG6UvOraS39kBRecRuMOeIP4sjbTboxlzWJA9U8tltsRMxKHlbAV6kFstiys7bnf4E6XS/W8RaHvUt7HCgLj1eMdQeK/DNwvtrSc4FpD2OR2Nup4MTjC08g5dtT33jfb/+MS8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5RO/ultItLhnlHfR4F/r3An5ySKWLKiuySlOzCYvq8=;
 b=OI/3SugLWJgZNs+wwiTdSM5KVmUVOCH5clBRmbnwUBvbfRDk9D7HAgwHbi8QsLzKapnkeghav3pW6F2UkwAnvzd1Z9Qq1SS/Dksoiu2vfPGt/86kiUP/mKHZP8OC1XlZDzXo4UkoWft0L5GvDwBQYyLtCfnXADeBPgwweA15Hha6PA4xFTjPz7c1NaV+IuKmIPnZyS3mR8kTUasDdQ5sCw8E/mIvuxDHwGvvw4g463GdeWuX5iU09emM+BNjMB1IV08g+0rY8Et+gSfnmdv3m7WSg2ftQTMT7K0CzH69zJ1gu+rNNVY3C9yhPY7Nt1Dj9Yi+Dhf9Wu7RI/cW65BvkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB6942.namprd11.prod.outlook.com (2603:10b6:806:2bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:53:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 02:53:24 +0000
Message-ID: <f2cd7136-889d-4a3c-b029-07a8c18ef589@intel.com>
Date: Tue, 11 Jun 2024 10:53:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20240509075423.156858-1-weijiang.yang@intel.com>
 <20240509075423.156858-2-weijiang.yang@intel.com>
 <ZmelpPm5YfGifhIj@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZmelpPm5YfGifhIj@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:196::15) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB6942:EE_
X-MS-Office365-Filtering-Correlation-Id: 713add9f-3573-42f7-47cc-08dc89c1a92f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V2JQMFhqMitZSW90QXIvQ2J6RHFTM2R4cmFVYXkxYW1zaGwrTnkybTVaSUxz?=
 =?utf-8?B?RnQ1ZmJ1Z0l3Ly8wNWhPNU5TanZMMjVIUlZrR3NsK0NyK1ZSeEJZelp1eVJt?=
 =?utf-8?B?a21HbVhUNnBiVFpuNlJDRVNkMkQzemVzWjUxTDVTajZIQXRDM042MW9heTNj?=
 =?utf-8?B?eG8vQloyR3lmRXRnWE43ZnlaZVVsdEZTOU9FYWxwei9oTUpVZ2srNzBjdVo1?=
 =?utf-8?B?VldrcTU1TG9xMnFjdnYyU1JJdWx1cVBIQ0kyUzV5YktYQXFEV1ljUHFMRFQw?=
 =?utf-8?B?cCttNi85UWRWRFlxKzJzc0JqR1Q5MmdVWVhtWDVFSEljaTVhNjdsQzFLVEU0?=
 =?utf-8?B?dCtlY0hkQndTTUdoeUhmQmx6ZkhsL0dGajNRRUw3NC9MbFpGdERhZDFGTmVh?=
 =?utf-8?B?cGROY1dzNGlGUTB3RlFXUTlZRXNFZjhmMm5ZSDVNellFaFJQMEtPUy9KVU9L?=
 =?utf-8?B?Q0FLTU0vbWNYb25UOFYwSGtLQ0VCdHFaRTJBVFVVZHppYno4TDdQSDZBSEI0?=
 =?utf-8?B?c1FSM1R6YzZSeWRIZHpoV09ZYUxXYzI5K0hRV0VReUVCbDFJenl2aHoySjRo?=
 =?utf-8?B?eVhGNXhSSW16YWQ2TFlzSlFiL1NkdG8xUVVPQ0trWE1GLzBRT3VHT2l3VWlH?=
 =?utf-8?B?cG5HSis0anc5UEw4Rkd1WXByZUJqYUNHbE5KaHNxTUFXYWZtWHVKbVJMQWRJ?=
 =?utf-8?B?cnQ1L2hEN2s0eG4yY29WWkhMTUNTWmRhaHRBVnlXMnZuUjZiRitiTndVUng4?=
 =?utf-8?B?SnBPTngzTHUvVEtqSWF3bVBtQXVIc3V0enZ0dXEva3dPc1BKUmhXK0NHTkpp?=
 =?utf-8?B?Wk1BWGVKVytPaWZDR2lnemJScmYwUTBLV2ZlWkpVMTYzVFBQZTcwWjBrbEtt?=
 =?utf-8?B?NTVhVUJnR3A3UC92UE1zQXc0SkxFUlE5ZnBZdFFaa2R2dXZCUWRTY3g1cEE3?=
 =?utf-8?B?OU5SVTZXN2hzd0VRcU1mY2VOWnlsSmFkMUNBMGc0YU5pMEd1WHVhTVFXS2Z2?=
 =?utf-8?B?YVRFczZ1eDZ3YTVXYlIrZytKMEFrOEFmbmRqSmFXN29tNmFRTlpiNFlRekhn?=
 =?utf-8?B?SDh2WnJFQUtmTGlFamc4RmV5WEhHcFV1a3luS2V5UTZQQVFyb1g4dVZKRFk1?=
 =?utf-8?B?M20vQVg0QWFYbGQxYW1oa01wc3VmNGE5OU5IOTlwaVBrdjNDbWJQQ20rTXBL?=
 =?utf-8?B?b3FxWDQvNTdBR0M3dDFSbmwxNlA4OVh5bGFtV2NuTGFxVFE3d2xySVZOVUo4?=
 =?utf-8?B?VTJHMlBGTnViNW4wY2hJNUN2QzNncUNuei9KcEI0RUlyUnhQZytGaDFSY0d2?=
 =?utf-8?B?OWZrZU9ib2NtY1lVTUtGWjdqQW0rZ2VNOHY3Y20yUjN4MUQ1OXJHMlBoSEhD?=
 =?utf-8?B?SlpqSFNLbXZVekt5d2tJeW0rYzhkZEJxVmJJL3BtMjdPcjNZSDRsbGxGWEF1?=
 =?utf-8?B?dExxM28zWlhybnJpMGREY1piRGVhZGI4QVlsY3d2RE8vVlFJbmlzaXVLOWF5?=
 =?utf-8?B?eW9POTdPZHRIY3NoYXhJQ2hxRUZhZCtReW5BVUJpS2EzK3QwUXkwL1p5S0o0?=
 =?utf-8?B?ZlY2Zk9PT0pIRTMram9xaTBXMGJuZkIwK3lwaUZWWk8rWmRtZDZSYmE5Umd0?=
 =?utf-8?B?b0R5NEk2TGxjcVBhUElMaGZzK2p6cEFWekFZUkFvdGpGcFVuQ2t5aWowak5J?=
 =?utf-8?B?anowd2EwNGlJUWRYNGVYUkxpRitnRFQ5Y2lCMjlLazhhbEdFVnFwN1JlREpI?=
 =?utf-8?Q?gHpdTx/n7UBRvVLGOvoUAn8KcBOAgMfBe4C3sHZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTZmZFVBeUdTL2hEVURmREpTb0ZNbDE0a2VhUUxMV0lGNk0xMTgrUm5NcVEv?=
 =?utf-8?B?dFZTNkZmcTVTelJEVE5wMjRhWVg0U2RUTXY0N3J5U1p1Uk9uNGFNcTZ3OU1T?=
 =?utf-8?B?OUNKdDNYZjMvNXlGc21YYW0wampJeXRVRGg5YVZFS2Y1ektSOG4zK3ZZemJC?=
 =?utf-8?B?NkR5SGkxWEtJMVFFbnJERDdZNlJKUzlxYzhXUWNPNUZVa0w2ZC9jNGtPTXdH?=
 =?utf-8?B?Skp2UElJK1lkMHYzcElUWWx3aHJNK01kMW84eHV6ZkFITjM3Mk9Mb2RtRDND?=
 =?utf-8?B?dnFtYU16UWwzUnQxcHVsNTIrdm1qRkI2ZTloK2tmbCtSUitTQWpmOFJDelVt?=
 =?utf-8?B?K1R3Vk14NEM4aFoxNE5maVU1TDVteVFZRnMrZ1RhMEs3TmNodDlYK1dwQmxP?=
 =?utf-8?B?MW9yWi9vV0UycUxRRkpXVndwOHlhZXNiL09EUGF2aEZyaXZrc2l3SDc0K1p5?=
 =?utf-8?B?OWtpOW1kQ0V6VVF0UEY2cXVVYkZ3T3VLbGg2UFlVTGxkOHZJVy9DVVdWUkJj?=
 =?utf-8?B?YzE2NUpVNEtHeEUyMGI4L2E5WGxvWVI2akFJZVVpdm81aG5aMFZLT3FPSkFC?=
 =?utf-8?B?QWdiOHViLzN1a1BoQ2REVjlIVytHZ2hvOUhCRUZSNEViMUdXYTlkSlRwMjBN?=
 =?utf-8?B?Q0hwNDZwMUZCTXVxb3FZaTI1bjIxZjJRKzlaZGtVN1FMeE9GdnBsUVRiQ0Q4?=
 =?utf-8?B?VDBWd1VNdk9YMHgwUjdSQ0hTR3d5S2Q2dTlsYWRKV0dENWNVV0lKTXU4YXlN?=
 =?utf-8?B?aWRJWCtlRzdWcTdtc1VXRlVneDljWG1IYVRrUlZFbVJaaEl3TDFIcWxFNkJq?=
 =?utf-8?B?M1lYdGlsSkczMm1wQTdWMVVNZFhsQzFTZ1VHc0tKRDFrTVR0NUE4NHNzaFVt?=
 =?utf-8?B?OFdHL0RkcHNKMU85aUJPVVUva0VGVGdYeW53RndLVUE2QzBGaVFDaWM3UE1W?=
 =?utf-8?B?dFFCM0ZBM1NSc255YjYvN1ZJOVFnQXp3ZXRPVFhXdDRraUx1Qml1dFNPdVhz?=
 =?utf-8?B?bUJLNDV3THhTcGhCblVBZWU3SjFqTHNoT1NYREtQcHVrUmZvVURPR2U4czFN?=
 =?utf-8?B?WGpxMExCdEpVdUFFaVdkTzRHVDVpdGRleVI5QkxvbDZ1dGppbnR6REhabFAx?=
 =?utf-8?B?SjFlRDdWejJ5cVY1Skt3UmxZdzUvUFJwYmhDREQxMjhCNDExaXYvVjhQeENV?=
 =?utf-8?B?TGEyTjkzdEFiaUpxM01GMHE0OXplT3VnN1AwY2d6UmVOL0szZ3NBdUpXRTZO?=
 =?utf-8?B?K1dQd3NtajFJMDliQ3Niei9idEtzWk9icmszaGpDUTFYOHVXVXhtYU9jNG5n?=
 =?utf-8?B?MTByamxjb3JqbWFpalVKcElXUTM4UE5mRnRJNHlGdGdTbHUxT3JkRUVab1pD?=
 =?utf-8?B?cjB3bXFqUUcrcndySzloR2dyK2hVUXN5MGpCOHNLMGczUnFTd3Bkc3QvV2pl?=
 =?utf-8?B?bmpBdmYzam9CNDA0em10NzY1V2RWU1VYSGhrS25qSzJEQXo0MDk3aUQyZWkz?=
 =?utf-8?B?OERuZkpudGJyb0ViTEhLTjJnL2Q1QnZVMEEzbXY5MmhyVkFBcUFkY250L2pF?=
 =?utf-8?B?dlpVR1ZMNE4yUU00Vi9lSXdGMmNoRFVYVXRJS3pkRnlBeEd0NVF3UzdybWtk?=
 =?utf-8?B?LzVBaDh1cys3VHhsT1JyTGFrT0haeE5aT0gzMW1IVm1VZ1U3cVF0NHl3SnBM?=
 =?utf-8?B?ZU5Ha3JOOHZsTnZaa1BhY3p1MEpzaW1LMENqbHZmeHM3MHlKOFZXSCszYmpR?=
 =?utf-8?B?RUQ5aktuLzl3Z1AvdDZEWFBPdG9oaEVITHgzUmkvcDFrNXZhRlVBQmQ2eW1l?=
 =?utf-8?B?Q3hBQzBDV3FNaVZ3MHNBbXVvWFdUZVQ2YTZmclVSUit4S3h2NmhWZlhXYllL?=
 =?utf-8?B?MjhiOURyemZxWWhhaGFadExhZnE1NTlUTGFoOXV6YzE2NGZkMk10cVdIRGdI?=
 =?utf-8?B?VFhZZ05xQXNTY2NCK3VIbnRYa1VRNERDcEQyUDlrVDU5L21mczhEWDhxajJi?=
 =?utf-8?B?dXlqejNYOENlU2lReUxBNUJ4OXZjM3VjTHlENWVxRFJwSFNBcTNRNGd3cHlS?=
 =?utf-8?B?V1psUWVGWkQva0hwbVZkMHA4bk9lS0l1RDZySlMzQ3NtcTZiWkx6RWNZTmFu?=
 =?utf-8?B?djVNdHFENmVvWmF2SHgraFJMai95ZHpXaW00dm1SYTBMc0hqc3l4bG1CQWhW?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 713add9f-3573-42f7-47cc-08dc89c1a92f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:53:24.2678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YyVuu5Hbe+iAE31v1Rs2JNF9lz1klbN6Feeqiyep8kw5JTo0Q6hWoEbD0uhylja5dMnFOpALhr6PAmheKfefw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6942
X-OriginatorOrg: intel.com

On 6/11/2024 9:17 AM, Sean Christopherson wrote:
> On Thu, May 09, 2024, Yang Weijiang wrote:
>> Enable guest shadow stack pointer(SSP) access interface with new uAPIs.
>> CET guest SSP is HW register which has corresponding VMCS field to save
>> /restore guest values when VM-{Exit,Entry} happens. KVM handles SSP as
>> a synthetic MSR for userspace access.
>>
>> Use a translation helper to set up mapping for SSP synthetic index and
>> KVM-internal MSR index so that userspace doesn't need to take care of
>> KVM's management for synthetic MSRs and avoid conflicts.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/uapi/asm/kvm.h |  3 +++
>>   arch/x86/kvm/x86.c              |  7 +++++++
>>   arch/x86/kvm/x86.h              | 10 ++++++++++
>>   3 files changed, 20 insertions(+)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index ca2a47a85fa1..81c8d9ea2e58 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -420,6 +420,9 @@ struct kvm_x86_reg_id {
>>   	__u16 rsvd16;
>>   };
>>   
>> +/* KVM synthetic MSR index staring from 0 */
>> +#define MSR_KVM_GUEST_SSP	0
> Do we want to have "SYNTHETIC" in the name?  E.g. to try and differentiate from
> KVM's paravirtual MSRs?
>
> Hmm, but the PV MSRs are synthetic too.  Maybe it's the MSR part that's bad, e.g.
> the whole point of these shenanigans is to let KVM use its internal MSR framework
> without exposing those details to userspace.
>
> So rather than, KVM_X86_REG_SYNTHETIC_MSR, what if we go with KVM_X86_REG_SYNTHETIC?
> And then this becomes something like KVM_SYNTHETIC_GUEST_SSP?

Yes, makes sense for me.

>
> Aha!  And then to prepare for a future where we add synthetic registers that
> aren't routed through the MSR framework (which seems unlikely, but its trivially
> easy to handle, so why not):
>
> static int kvm_translate_synthetic_reg(struct kvm_x86_reg_id *reg)
> {
> 	switch (reg->index) {
> 	case MSR_KVM_GUEST_SSP:
> 		reg->type = KVM_X86_REG_MSR;
> 		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
> 		break;
> 	default:
> 		return -EINVAL;
> 	}
> 	return 0;
> }
>
> and then the caller would have slightly different ordering:
>
>          if (id->type == KVM_X86_REG_SYNTHETIC_MSR) {
>                  r = kvm_translate_synthetic_msr(&id->index);
>                  if (r)
>                          break;
>          }
>
>          r = -EINVAL;
>          if (id->type != KVM_X86_REG_MSR)
>                  break;
I assume reg->type translation for GUEST_SSP is due to the fact it relies on CET common checking
stuffs underneath for the register, i.e., it goes through existing MSR framework. But for future other
synthetic MSRs, it needs to refactor the code here so that it could be routed into new handling.
e.g.:

if (id->type == KVM_X86_REG_MSR)
         go through MSR framework;
else
         go through other new handling;

But currently the new uAPIs are only for GUEST_SSP, so above suggested id->type check works.
Does it make sense?

