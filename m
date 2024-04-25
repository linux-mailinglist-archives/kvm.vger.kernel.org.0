Return-Path: <kvm+bounces-15997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDF78B2D71
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2702B22823
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF8615624D;
	Thu, 25 Apr 2024 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hPb+wKY3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D273C15623B
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714086525; cv=fail; b=ILayZqYoYmRppq8vWhGCm0NEYGdc9VkcjjxvW1OFqHxGQei65m0/lEEkpIhAqwkZ/TGAC9Wy2AR5gnW9hBGFhpNW6txDA0Ak98Bo4Gf3+8HTJuDNjYADl/GgUrNZm/1yZFhqF1Xi1qtsUrQP1drYY0VUFOYS+LmgFK/6PRnYlEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714086525; c=relaxed/simple;
	bh=nPzi+RYy/xq7xu/z6jCp0RN9CNubMTkvudam7tZCd/8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HjFzBkEptSHLjYUnGCiYFvsLf8srPBIp3MS07hrlRJOYT2lrzuk4PM9608TQo0LTWdCJjn32qWuwD+DkC7PERx2hZn1zvShFRy3mU8aI157Y/H4ViHD+bGeAHVtaaOR6TWEGVhfNiaY0MMyUEwUMzSx+Vy2HnSOZz3GYXUscD3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hPb+wKY3; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714086524; x=1745622524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nPzi+RYy/xq7xu/z6jCp0RN9CNubMTkvudam7tZCd/8=;
  b=hPb+wKY34YoUeLG88JekYgu6LhhRFqWJjcc5m4KqN2MFjUb5a65Xt7Mi
   uqJ1Q5WN8BGyzwfsQoyed4v1f83I21lsuNenaQugx30yw0zEaSOgtsjpH
   5u6kWdEZ/f3kBLNubLEdH2DGXm9VgqAq1++4SH60+tR27lnaRnNt8n8Wk
   2k+S1TLL0+pnqPCA/aLLt9oB1PgCb/1QaysD1XdQcBWJU32hQH5diJaDz
   pFNtHfegMxJRg6xMD4pLtg0MFpWMOsv3V7LFvcfCujphHDy4w4k5/z1OT
   JyDXCnLocyuApO0Q/0yRhDhlEbzh5YZ6RtFAmX8gd1rL2hYfslOGzJwrg
   g==;
X-CSE-ConnectionGUID: KfXXziCpRQqFijkSiZcxgA==
X-CSE-MsgGUID: YaKNneNzQRuk2qCSuaehCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13598049"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="13598049"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 16:08:43 -0700
X-CSE-ConnectionGUID: WvAUv/peTYCKJlrkBIAiiQ==
X-CSE-MsgGUID: rr39eXFNQim0cI1x6PKVQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25247163"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 16:08:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 16:08:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 16:08:42 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 16:08:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhdpmnysHVoJ2E8l4jYBxz5oPDaUtkvf3GtTS8BF2vDz9JZ/7iZnWqtQn479Xo+yJtt7euosQ8tmG1ZL26Nul91W5LCz/YmoMMIwkrIvPseW8QFF5w73SQgKnwzJvw1dXq9NLg6qAkgijrZp5ieCjg5tnhnez7Ye3s7PxrYIJzyP2qiva7HTnhLf3rXeTeRxWo4Bik0r6gqCs3gl2qC90fPoX5bcDn4ac4WJ+ftaex4cWaZg2CgmvgTWFAqBg9jBFrH6vzvRdGydDhz2kZzNetAa7ka3ntlOKEQjTa5TsrPGuG6z7GMDBVEeWVw3ksx6Z4uQWIFh6iJTQOeWhM9WbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPzi+RYy/xq7xu/z6jCp0RN9CNubMTkvudam7tZCd/8=;
 b=ORvJJyV89jBVnMQgYMexlxrdce6/KYln38Yka+d1I3HeyYWJbKisufQz33UzXKB0FpBxfKe88W0U7+aGLVkP4UG4WlTvFFB1OxETkElTWnXNi6Us0O3Up/PAUkIkR/r2/q3wSFeswaiEfmLcMgqyfI17mS5BmJkmYXROCK1lmU5pbqjIzTbwDGu4sW9+GGnsvfYZBriDS3NcFqYxmI5ouwuzFVrt0tvVNm2/Du/TrkWpSmhSe4ah0o69NNrYqRdFs9NfbV4/M5sLrxJIV/yvB5VRKCpFNtz3YZTgjvGkjfxTFz+yzWhTfoIx4+ukNbQxXJA4+hv+/1DNYa6wLgMpUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8511.namprd11.prod.outlook.com (2603:10b6:408:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 23:08:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Thu, 25 Apr 2024
 23:08:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoCAAAekAIAAFtYAgAA3YoCAABFSgIAAA1+AgAAETwA=
Date: Thu, 25 Apr 2024 23:08:39 +0000
Message-ID: <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
	 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
	 <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
	 <ZiqL4G-d8fk0Rb-c@google.com>
	 <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
	 <ZirNfel6-9RcusQC@google.com>
	 <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
	 <Zire2UuF9lR2cmnQ@google.com>
In-Reply-To: <Zire2UuF9lR2cmnQ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV8PR11MB8511:EE_
x-ms-office365-filtering-correlation-id: c91aff0a-ab0c-4bc0-1e67-08dc657ca52d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?clRuZUQwMmY3TkxlSWF4Q01FZ3ZSblBsLzJtb3c2cnJ2RFVodXZzM1p0bXcr?=
 =?utf-8?B?Q3JRQ1VpcjJsU1lwS2lra2NYSE1NZlROeFYyUFU1eU1hUnl3aUl5Q2F4K3Nt?=
 =?utf-8?B?M1pLQ0J3STlZdEYzNEJYRTBoZjJteHNMRmR2VjRRRVZxZVJjbzBHWW5pTy9I?=
 =?utf-8?B?QkhtRmludmI2NXBxQ3lTZVZjS2I0MDZMUEpCVEE1YjZaZEhVL2N2VEZXRXk4?=
 =?utf-8?B?RTNTSFlBbzRnSlpKL280Ykh6Z3pWcmpLVmMxRUI1MThXOU1PNzdYcUVQengr?=
 =?utf-8?B?UUd3UEpHaE51VFpoREoxQ1RHd2NhZ2xveHZiMVJ3OTA0Sm1FY1E3RHpxZVdl?=
 =?utf-8?B?S1NsY3lvRFRweE9melYzNThwTlNzZ1pTakdLWGwrU2Z3cjUvQjduVGFhWjMw?=
 =?utf-8?B?Q0hFQjU2bzhxcFVoM0hZMTdVYXhZdHhkeWVSdVlqcTc2TTlJRUR6NjZ3U1lL?=
 =?utf-8?B?d1pkTWdxVmc0Qm8yTGd0UnJabE5LbVIxZmtGemlrVFlKMDBsdU1lclpJRXlj?=
 =?utf-8?B?cU4rcWE5K09pQ1NHeUlsTHJFaDhXalZnbTJWakRPYnNXdkRmeUM4ZHNJZ240?=
 =?utf-8?B?RG5UT21KSCtMTUdXUTdIeSsxZldMNEU5TnZ5bWVMT0xYeC9EU1hpQm9scnJa?=
 =?utf-8?B?YlRUbkhObUhFL2ZzYmhVc3NwWmJzaDFxMjlxTnJaQnJwTVNkQW1ZMytXWlZG?=
 =?utf-8?B?YkxWKzhIOTlEU3BkSUE5Y1FKQTZVUU9DWmc0RlY3WGVRNzdCcEFhZ0lBSkZT?=
 =?utf-8?B?WEZ6VEpoOVRHNXVCSW5tbHZPZHhvRTRpa3NxbUNQOG1aMzltdnNNQWpTcHpp?=
 =?utf-8?B?ZWZHbWFIQ2haU045aGU4LzhQRkVuN2xQeU0randJNzk3YytZd1Q3emNmbDF4?=
 =?utf-8?B?OVFsMU41UFlFNzdNeHA4Ymh6c1RmcVJ1YjNpWU5qR0JldytsaVFKNzEvRFdo?=
 =?utf-8?B?VXNaNWtUT3hpaHM4aDErcDdlekJlQ1JVYThrdE9iQ1pLa3Y3T1JCK2MzaHVE?=
 =?utf-8?B?ZG5IN1IxV0lmakN2WFJaMmlCeGYrUnFBZmw0MXg4WWtTTkNlcElNcEtMUFhl?=
 =?utf-8?B?M1M1VXJ0Y0hWcEpsTGQvOXdUKzQ1MnRwNFpBTWpzdWM3dXZGWmJDYkU0VDl4?=
 =?utf-8?B?elp4NmJkblFlVGVBaDVLaDZFSm5zZGk1NGFoYnFzV0VsNlAydEVHeFZJTWp2?=
 =?utf-8?B?TDNpTXJGSy9DNHBGbEExOHVCOHIwcml3V2xWTnQzK2lxazBHRXBhYmU2Sk40?=
 =?utf-8?B?ZUl1Nm5td01zdzFXZFNtYWg4dTJmRmppQzVTbDJtNG9ESVluVjQxMFF0U2xI?=
 =?utf-8?B?djZuRE5EMFVEZTJFMG9BR2tTRlRJSmI1a3BsNlF1R2pkVTV3ZDN2WUw2UUg0?=
 =?utf-8?B?YUdnVHdScHRBMlp2a1YwbWpWK05wajZCVWU1K3VQMmMzdWJVVzVwTUVFU0xs?=
 =?utf-8?B?c1l4Y0FIdWZuRnhHNnllS1RmMDhSeGhraTloWmp6QUVWTDRKWkNKcGcxWU9h?=
 =?utf-8?B?cWdBa3VObTlBeEthTzFKTjkzd1FSbFBQWHkzaHV0dElBYWdEUUFMUHBFZGlQ?=
 =?utf-8?B?U2VhUzFoQ0oyM2ttaXZ3SVlvNVZQc3hmZGRYbWVibGNDWTJBdUVJbWVTdTVV?=
 =?utf-8?B?dWFZWlAyNmdIdnhESTc5aEhSRDRYaVVnM252UFdpWlB2NTdsc0ZTUTBMcTFG?=
 =?utf-8?B?Sm54aWRIYlRMdDNpQkFIVFpmWUkrOWNEM0R0TENaTlJtSXMzOVU2UnZDTlRR?=
 =?utf-8?B?YnphNitYS1FaS0RqWWE1L0xrQ204bExUOXcwTDU1TUw1SnR6QzBCSkdqVm1P?=
 =?utf-8?B?UzQzMWwweStyWFAvNDZKZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm5Mek1IWXFBbWJGcDFZQ2tqQzNXZCtuWitVSWZVUkxxaFZnRzlaa0MxeExo?=
 =?utf-8?B?MG1pVSs2Yk4vdURjZDB4WVhDNWVIVnpEZ3lkTnUzT05tMnUxZi9KdGt2cFNI?=
 =?utf-8?B?N2pDUzc2eDlKSC9UY0JzL3d1OTA1RHQ0QnlYeFpxbW9MMnJMQWZkWDNza0ow?=
 =?utf-8?B?bHdIRThBNkMxODB5SHd1MEJaS0hLVFhMOVVudWpVRytWTTR5MkJqZHdvRTYx?=
 =?utf-8?B?U2lTN0pGa1NYMlIrajdkRUlFaThiSWdyanY1RXNOL1lOT0RTMzE1RERSRjRJ?=
 =?utf-8?B?ZjEydjkrOVVxZFlpbTFPek4zVlBWd2NsbzBocks4YzI3SnFOWkU3b3plVDZn?=
 =?utf-8?B?SlI3Y1E2Q1hCWHFCTDljV0ZJMlRHb3BIN1UwUi9xVXBjOHl4enlsRXNRejlQ?=
 =?utf-8?B?dllOL1hSc3MzQ0VBNyt1YkVPaXdkVW9Ba3BpOTFxbUU1U2pKMFBSc05ERjJi?=
 =?utf-8?B?NXpkMmxsSFdvME9Fck9lNXpRdndINjQ2MmtzWVBQRGFCcFVCdTNsZ3RrUVFu?=
 =?utf-8?B?TFNWUGt3Z1VHM0pDemd0M2FZdWpqWm01MDVYU3FISVQrR1FiSGNGMi9LTVJ1?=
 =?utf-8?B?bE5PNEE4N0REZTRmRmdGK21tL0VJYTJjVW8xSlVQYzA5UGY2bFFiK3V2OGlW?=
 =?utf-8?B?SGdhaFRTK0Y3YlVhbWFKVU4xVm1qckJQUGEzUnZpT2NudkJQM01tSTVsS3Bt?=
 =?utf-8?B?NStySXlycnQ3NG5QdUtwVGZRaW51Z1lDUjh6ZHN1WHlFRktDblRON3AxelNY?=
 =?utf-8?B?cGlJZExtQUFPcjZSZGVVQTZqZklEWnkydEtBb3ZrL3lCT3c0WERqUmxrZmhT?=
 =?utf-8?B?RjZjWi9OdWw1aGgwbTR6TGpTVnJDbUYvYlRoQWU3VTFvaHk1UkRSMDdUQmFW?=
 =?utf-8?B?c0dxMUE2a1JkYlQ1UkhUMjI1WTNVRUsxcXE1WGV2eSszM1doZUVFdUREQ2tr?=
 =?utf-8?B?VUVMV2hKRkE5ak41VzR4K2VCU0VyNGdaazBEQ0hETCtHbm0rdk9qSFkzdCtu?=
 =?utf-8?B?QnZPVWZRK05tR1hGM24xOTd2TlUvSERmN29JTGtXb0lHR1FKNjNTQ2dwNExq?=
 =?utf-8?B?ays3aTc4eEFCVVkvcVBtUVNhbGJ5cDBIUVpIMVBZU1dRbmNJLzhZSGdENGtQ?=
 =?utf-8?B?WW5oV0VBU211S25keW5qc3VUS3d2a0pqN1c3OXNleGJGcmhnam1vT3RKcFU0?=
 =?utf-8?B?RmtCOU5VWlNyOWhYZmw4eUlmTTFGSXM3ck1IR2lUdEQ0em9PMWNCM0NodndT?=
 =?utf-8?B?YThUQmRFVEhOVisyN0RSbHRpYlZvNUp3TUxhYTNtZmRYZ29rb2hmZjg2RFA5?=
 =?utf-8?B?UWNKYkVza0hKQ0JpT21sSEpxcTlwUmJzb2hMK01ZREFiM1FQc29INHdJb3pU?=
 =?utf-8?B?VXdpNWJPS1dlTzk0UC9hZURmM3FFZm5aNjJaSDJ5QVpDT0NjTnlJVWlPYXRL?=
 =?utf-8?B?WmpQUUN4Qi9mMnBQYnhPRHlhWUdWUWNORWdSVTQ0d3BPeWtzOElFZGxkcmZn?=
 =?utf-8?B?WG9pRlJjc1Z4WmduUlB0ZmhoL3Q5NkNzSVBleWlJQ1NxZ0ZRQVNhTjNSWEh3?=
 =?utf-8?B?UWFCZWhXZ05MbGRlODRJbWVURnV2czhyS2pzQjZQcUhCeFcxTmNiWFZIMllU?=
 =?utf-8?B?bCsvd1hVQ0xpRjBpbmRweHJWNjd2eUZCMVVuRWtlNXpkY005bXMwV3pNdldr?=
 =?utf-8?B?ZXN3c0NVY1JBcVU4elU5SG9Bc3hRY0dNZklaajlsb3BNYkpZb0VnZTNSMXhp?=
 =?utf-8?B?TFBJTlB2aGZRblVFb0FXS01RTkVWdjVLcW9rcGRVQkpIZEZPWTdPN2pQZ0ZX?=
 =?utf-8?B?MmpVNnd2eCtqNy84YVZUTkg5eEYrRlJZQnQ4WHJyTFFINm5rM29VOVFhYjJq?=
 =?utf-8?B?cWJGWFF1ZlFIRWZ5MWlGYmdhOUNzSEZrSXBGRVJ6K00yUlpiRWN6YTZRUGlL?=
 =?utf-8?B?cDkzSWJ5SVpxUk1mR0pHSjJkeVc3aU1IWlJrVFJMNFlkT1grc29rM1Z4TnFJ?=
 =?utf-8?B?WWoxYXN5U0RDaFVsdE1ucUsyUkdMc1hhMlFod09QMXVvRGkvT1JneEpqalYz?=
 =?utf-8?B?OThpSk12cmtnNEVndFJJZ21oUk85R3Z5U00wRVJTVlBsdkM1ZnpNNlp5VC9M?=
 =?utf-8?B?TngrUFppMUxEZm1OcFZwMmIvY0VGNnRMTWV5aTVSZVpSVG1CT0h2c0o1TXN4?=
 =?utf-8?Q?d2K0t1rhpcEAejiYqqBYr3A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F18538ED74EE34AB337E8AE9AED8E55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91aff0a-ab0c-4bc0-1e67-08dc657ca52d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 23:08:39.9742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sz043ENW11zhl/9VAJHBQ0fLgzxJezmGYKxfFNhO1h3rHQ8W7lzjEc2Nm4b8zCPYEO8WXpsBdFnI2xpga5mKVrfAyUiDfWw2XuvoJGz9BaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8511
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE1OjUzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEhtbS4gSSdsbCBtZW50aW9uIHRoaXMsIGJ1dCBJIGRvbid0IHNlZSB3aHkgS1ZN
IG5lZWRzIHRoZSBURFggbW9kdWxlIHRvDQo+ID4gZmlsdGVyDQo+ID4gaXQuIEl0IHNlZW1zIGlu
IHRoZSByYW5nZSBvZiB1c2Vyc3BhY2UgYmVpbmcgYWxsb3dlZCB0byBjcmVhdGUgbm9uc2Vuc2UN
Cj4gPiBjb25maWd1cmF0aW9ucyB0aGF0IG9ubHkgaHVydCBpdHMgb3duIGd1ZXN0Lg0KPiANCj4g
QmVjYXVzZSB0aGUgd2hvbGUgcG9pbnQgb2YgVERYIGlzIHRvIHByb3RlY3QgdGhlIGd1ZXN0IGZy
b20gdGhlIGJhZCwgbmF1Z2h0eQ0KPiBob3N0Pw0KDQpET1MgbmF1Z2h0aW5lc3MgYnkgdGhlIGhv
c3QgaXMgYWxsb3dlZCB0aG91Z2guDQoNCj4gDQo+ID4gSWYgd2UgdGhpbmsgdGhlIFREWCBtb2R1
bGUgc2hvdWxkIGRvIGl0LCB0aGVuIG1heWJlIHdlIHNob3VsZCBoYXZlIEtWTQ0KPiA+IHNhbml0
eQ0KPiA+IGZpbHRlciB0aGVzZSBvdXQgdG9kYXkgaW4gcHJlcGFyYXRpb24uDQo+IA0KPiBOb3Bl
LsKgIEtWTSBpc24ndCBpbiB0aGUgZ3Vlc3QncyBUQ0IsIFREWCBpcy4NCj4gwqAgS1ZNJ3Mgc3Rh
bmNlIGlzIHRoYXQgdXNlcnNwYWNlIGlzDQo+IHJlc3BvbnNpYmxlIGZvciBwcm92aWRpbmcgYSBz
YW5lIHZDUFUgbW9kZWwsIGJlY2F1c2UgZGVmaW5pbmcgd2hhdCBpcyAic2FuZSINCj4gaXMNCj4g
ZXh0cmVtZWx5IGRpZmZpY3VsdCB1bmxlc3MgdGhlIGRlZmluaXRpb24gaXMgc3VwZXIgcHJlc2Ny
aXB0aXZlLCBhIGxhIFREWC4gDQo+IA0KPiBFLmcuIGxldHRpbmcgdGhlIGhvc3QgbWFwIHNvbWV0
aGluZyB0aGF0IFREWCdzIHNwZWMgc2F5cyB3aWxsIGNhdXNlICNWRSB3b3VsZA0KPiBjcmVhdGUg
YSBub3ZlbCBhdHRhY2sgc3VyZmFjZS4NCg0KSSB0aG91Z2h0IHRoYXQgdGhlIHNoYXJlZCBoYWxm
IGNvdWxkIGJlIG1hcHBlZCBpbiB0aGF0IHJhbmdlIHVubGVzcyBLVk0gZ2V0cw0KaW52b2x2ZWQu
IEJ1dCwgbm8sIGFzIGxvbmcgYXMgd2UgdGllIEdQQVcsIDIzOjE2LCBlcHQtbGV2ZWwgYWxsIHRv
Z2V0aGVyLCB0aGVuDQptYXBwaW5nIHNvbWV0aGluZyBhYm92ZSBpdCB3b24ndCBldmVuIG1ha2Ug
c2Vuc2UuDQoNCkkgZG9uJ3Qgc2VlIGF0dGFjayBzdXJmYWNlIHJpc2sgaW1tZWRpYXRlbHkuIEkg
ZXhwZWN0IHRoaXMgd2lsbCBnZXQgbW9yZQ0KaW50ZXJuYWwgc2NydXRpbnkgaW4gdGhhdCByZWdh
cmQgdGhvdWdoLg0KDQoNCg==

