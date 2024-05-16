Return-Path: <kvm+bounces-17502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 109A38C6FF8
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E0D2B21A9C
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494591366;
	Thu, 16 May 2024 01:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GORAYNxy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731BEA47;
	Thu, 16 May 2024 01:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715822516; cv=fail; b=TxqVXT+K4iCuMQcKt+jhDOyduWwXTRPe2I88+mxIaA68qlb0B1y4DpYGJN1D4n6aVvPObunRq/2crjoFrjro6nosBT4Stfj9ji1BF0jNG4h4najxqFZGYo2lSbPdYRtUc/gKSdLGPcnarucCVwjkjMYvLbiyAdqxeixcbhnAQ40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715822516; c=relaxed/simple;
	bh=YzuXhGnCBj6Kwk4xgq4tcdWlhk3l6mdX1G3x+x4ScAw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sr63gFJ/xL9MyHau5D1/SnyzrcX7WdmWYArpQuBe00O0OZTmF5znq+9wTZbj/Oxg7fCIMkInOs1Gy1/k8rt5cWr6LYhVuS4RPAtqbjJHB4v+2f1yq3lc7Ce94KgIEEowtA67IhJ+jWRsifCboEcPo1NK5PBneiATYNXnldWkuvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GORAYNxy; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715822515; x=1747358515;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YzuXhGnCBj6Kwk4xgq4tcdWlhk3l6mdX1G3x+x4ScAw=;
  b=GORAYNxyOWA0aRjEUhwXWc2CQSjh6Ya7b77iWHOGHgg7Hvjdtxyr8r87
   mpFdVHs2DcsW/1v4cofVZY2Vh1LoMHP+pRF0JinqFJx1cfcLGH4szpQcs
   18Sic1pLwPiN/+xPEGBMGej0xYPxUelRm4ZJckYmvlI1y/45ZVaZIK1tp
   /pIvCsI4/92q0VkR577GysQfn5GnGxBU686wdx+vtsqmf4qCa8HWbQRSQ
   jlfpPMmSKau6IjK1EVl8kXPQNcel+L4vQ/b9GIywKBlVJ0bWWpjM8llsv
   KZW/4Bo+PXbHW3mB7b6U/83krqbaDzVHjfBPtfbYOhiFJQysEkQWfole4
   g==;
X-CSE-ConnectionGUID: lVKNuWtmSPuCDLEgeAKM8Q==
X-CSE-MsgGUID: uLmazuLGQ3atUF5i6nD0QA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23308658"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="23308658"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:21:54 -0700
X-CSE-ConnectionGUID: Daz6SVoZSYyoWqjcWV6fww==
X-CSE-MsgGUID: MrNJRpt9QVmMxAcHNl99fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="35777919"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 18:21:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:21:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:21:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 18:21:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 18:21:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIsF/tNQs8W/UAozoXnG+rPaZSe9DmRSRIql2Z6BU9n2AhqQxKL17giwG60AewaSM0SvxhQQMCot3DETMvmet+LNJ6gbj+8HsQWKxMO5LKBG/J4KwMfqkvehJU9KHOT6bjnv2fbTtAdbBRGDEBsUX6mHJZg1PNSku4hoV607tzfYjUWHYapw4njFOaMYqrIZLIvEtcAxQ4NQwbrtZQoYjGm8xIHhTndSbZe18tXr0wnCMRWes86dS3aEKambhBVo0vtTKZEag9/Vjrbg9kPox37Mp4O9fyw99O4ViuRNa8rDfnHQ+6zEv/Y7ya4tiYUpAfGs9pY4Uj8JBI3W+PbYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+A7P1Stu4kvoDVHKsly27zlpECKchtPwq0LqHSf8e4=;
 b=Xdy1SrUOFoxwVwXENYMaI7QQVrf8sc5fd5dSuzHsoyxt9Nz2bxLgFZM64pLd5ZOPsHFcWttOVKAXeWv5zV/fwB4SIDVTHslaRoVBMVAQtD1/wS1Q98mBi76LR6i9d7MSCXUcXm1uSUJGqW0ihz+CjQGVkRzWTs0K5G0aRtPsCRNEX89VeqfbAsnxlOygEmYFjyxf5TQ5XWrib7keadPOZFCpjV7WNrr2WJInlUYj1//FAXYeXPlujejYPv/sR2E45y7NBAYT+IbxoSlL0IK6fWcyRoMlnAuQN9EegXTTjjDkEYEo5gWHh0ABplcBUCVuz7n4v2h6f5dYoAikoMaRng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6028.namprd11.prod.outlook.com (2603:10b6:208:393::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 01:21:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 01:21:50 +0000
Message-ID: <4ba18e4e-5971-4683-82eb-63c985e98e6b@intel.com>
Date: Thu, 16 May 2024 13:21:40 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<erdemaktas@google.com>, <sagis@google.com>, <yan.y.zhao@intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@linux.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com> <20240515162240.GC168153@ls.amr.corp.intel.com>
 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
 <20240516001530.GG168153@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240516001530.GG168153@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:303:b4::32) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL1PR11MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: 135fef85-d8cf-423f-bcd7-08dc75468fb0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cmRDNEI2ZFJzdjU3MUpsMnoyNWI3M3NRdkhXUlZyS2ZySmJ4Vjd6SlF0YnFX?=
 =?utf-8?B?YzdPdTVFM2l2TUt6Q2I5c0VzQXdsVnc2VHpSc294QmtsYWp6Ri83QytMekJZ?=
 =?utf-8?B?TVVOdEN0YXRZM2NZSUdKSE1SRE1oVnJNNHpNQ1JYRmluekVDRDlndkY4RWFs?=
 =?utf-8?B?RUlXNE1sMVpzUWpxZXJxYmIrcnNJckpNVDNSZDNGTlJMK3YrNkNNNERYS01z?=
 =?utf-8?B?RnZNR0hPclZGTmFHZWNyNHZxYitVcE4rdTN0b2tFTU42cEdZNS9CTEV0Ynlt?=
 =?utf-8?B?RjdSK25HUHo1amRmM2U1MnFwNGtOV2NQdlVZMTl2WUNIT0RiMGk4c3dLSTZj?=
 =?utf-8?B?bHlhekcvZ2tTeTRJV0o5R3BQWWFvaTJqR05VUi9hemc4NUtaOGhYOFo3YkxE?=
 =?utf-8?B?K3NRSnI3N3N4OGhGanlwK3NQU1IvYlhCd1Iza29DOGVLOHJpWGpoWGc0M3kv?=
 =?utf-8?B?VHVJUGRGTVJJU21Qc3dDTHA5WG40NlNwM09CamI3VEN3THNxUVN4WU80RGxL?=
 =?utf-8?B?TUdCYythYkVlblZSVmNRTHEvak1QZzI3RGVGc3pGNFJkUG1TdWpFeEtsQmpW?=
 =?utf-8?B?ZmUzc2RwSCt0bmhQZkFRSERaY2lIelRRa3ppaTd0KzN5YVFZbTB4bXBLamJX?=
 =?utf-8?B?NzZTellrdThtQzB4QXA5aDFNc3pNQm43em8vTzIwUzNlZitmL2k1NDlWNDRT?=
 =?utf-8?B?NjZlWXF5akR2L21sWlN0cWwwbDFhdEgrK2pOMkRqY0oyZ1VpS2ZUb3RJNC8x?=
 =?utf-8?B?ZThkZ1g4ZTNzQ1Y5ckpiRS90Qk9YdlhvOVc0TTBLUGhhYzhUOGZ6Y21aSmI0?=
 =?utf-8?B?SnkycXBxYU1WandEazYyUVVYMFNVcE1zU1pDVk5MSm5VN2pIVHlRRVFhNnZq?=
 =?utf-8?B?ak1ybTFNSDM3alR3eVpxUzl1UFkrejEyU285eTEyeUZqYUtQYS8relFMdEJC?=
 =?utf-8?B?eW50SVc4U2EyUDlBNmhEQjluSlNqQzk2Z3MxTi9Vc2ZFNGdobnBpZG5QTHY1?=
 =?utf-8?B?azJhWVRzaStmazB2bVM3WUhRanBmZXY1ZlV4bVFOZVU0cVd1T0lUdXFkQUxO?=
 =?utf-8?B?WEd1bjFGQ3dKRXRBMlh3ZVRjWTJHWkN0d2xsY3ozc2JmVnhtTStzSTROaG1C?=
 =?utf-8?B?RmpJeVVoWlFDekZ6ajlCWmhBd2ZhMXVDcEYrUUl4elZqajhvUXd3RTZ6RDEy?=
 =?utf-8?B?bFVoVzlEdHpvNDlselFMcTFKdW1vOWhwaDduOG1DNlZhNUdzN2VmYStySmpL?=
 =?utf-8?B?OGczWGNnKzNqNWx5QVY3SkJObTl5bnJxeU1pTThoMnBMbll0eldaRHBtYU9y?=
 =?utf-8?B?bm5sd1l1d3FwUlpFcitIMlF4bldwY3Q2Y0R4aFlGK3dPeGp1QlFHWmxjb24w?=
 =?utf-8?B?eS9KNkxFU0lJSGYrdWFOdlRaRmlIc1VCMDhvTTBjRnppdnRjZWd5MGNqK3E5?=
 =?utf-8?B?azBJdHVVVmNTNXlCVFJISTEzdm9mRFVRU2toWTllOHo5YlVET1VHK2FVMlBo?=
 =?utf-8?B?dk1IN3FGd2tKUHNDU29hTkdTTGFsb0trSWlrYmJwaEZ1dTlKQzhGMXY3RXQw?=
 =?utf-8?B?L0ZZcGloSjZGLzVSbVcwRFhPNS9Qb1RySTZVVkZ0M3dHMkJUTU13bWVEck9Q?=
 =?utf-8?B?aG51ckEyenFhNUh2UFp2d0tHNkFDc1oreDZsK1JjOVR0SUhzV3ViRFUvUzJl?=
 =?utf-8?B?N0d6cXdJTkcxVmU4bS9iUXROTzR2NmovWEU3N0dFNGYxSjFlRXJOUk1nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk9xVEh4YUg3Ym5SRFNrZ1lObndsb1hOLzY1RTNpQkFBNU5odkt6c25wbnF4?=
 =?utf-8?B?alAxL3d6ZEo4OEkyUytSeVpmd3dCeVR0QkdNbDFoZTNaSkRNYmwwQTcxM0Zx?=
 =?utf-8?B?ZHhZaTFlQ2FFdU5OckEwYkErVEVxTTltbURsMGUraDBLajVYY1FBbENrZDdN?=
 =?utf-8?B?Sm5BVVJBQ29CL3ZocEN5VWZhTUlxdVo1anVUcnc1ZmVJM24ydEFHbXFGSzYw?=
 =?utf-8?B?cC9DNG9EOUJiZ2FkcUI1bjZ2dEVjd1hBRCswRWtvSXhaaTNWME5HTkMyK2gy?=
 =?utf-8?B?clZ6V2NnOXNHaThCUGg5U29mR2w3OWRMZ0pKUE9XZmt5VGNiMTk5aUtZNHlI?=
 =?utf-8?B?ZE55YVQrUlh6MTA4amlyK1hkbUoxUGxaRURIUDRrOE8vRTF3Q29HUk1EcmVQ?=
 =?utf-8?B?RkFHaEp3QjdPb1NKKytzak5rUEpxMFpvQWs4bEkva1lxa3NjUWZ2UXZIQUNu?=
 =?utf-8?B?U2MrWjF3QXQyN0VVbGNMcGNGcXZ2eldMVEs3NlRNMXhrSGlTYlBxdERYc1Jr?=
 =?utf-8?B?NHhEaFJJajVIQVcwOFNHbnovd0h1d1JqKzNTWkFobm1wTGx0bExpUVpDaTQ4?=
 =?utf-8?B?eGM3cGlYQnRBYnZuOGRURHJwd1FSd2JZSDFrUjFoVm5Rc0RDdi9rcnRoYURa?=
 =?utf-8?B?QVJpUUlrWkRxbHpHWjUzMWV3UFNBZGVwcHNSRkpmYzhDWHNYLzh3d2JJczRE?=
 =?utf-8?B?NWgwUnZSemU0dTBZQzZha3hRL0xQMVlRdXduT1hHSlYxUEZySVRqRVYrTGZT?=
 =?utf-8?B?TU9qVjN5NnpmaGNOaHJwVURsdzV0dkZ5NkJxWk5GRlM2UjFoN2E1d1BYZ1Zz?=
 =?utf-8?B?WVZMdFRQcFFKbEJRZVZvb1RaQ3NVZDNheVhZbFVScFh4Zk5YK1pFS2tDbm9y?=
 =?utf-8?B?Y0x5T2hlclJEclV2NVB0RVNTOTMzaEFEZ3JDd2dEMEIxWUNqWjAzZTRUYWV0?=
 =?utf-8?B?V3psamJ6djl6aXhNcTh4dnh5WHpyVGhsOWVjKy9jd2VZMlIwdE1oVWRKK3dL?=
 =?utf-8?B?RW5pUkp1TTB0dVYzaUh0K3Urc2JEdFNGSW5FWlFBckVWTEY1cXpyWU0yRW5q?=
 =?utf-8?B?U2ZQWG1LVjk5WGZtOVI1SVJKWGVWOXRwMUlBeUhMdTFkRnlmVjRtczJQbzl3?=
 =?utf-8?B?TnNiSkhsTk91S01Ub1VoSFpLQVV1QjJqbnd3Wmh3ZTlXTFViS01RbTVHOFZE?=
 =?utf-8?B?YnJjUnBRTDhhbkR5OGpMOC9VbXBzWGNtQi9ML28rTnJBNjEwYlpuNHhEdnk0?=
 =?utf-8?B?cDBBOFg4dkFRYmVGZmhQaWFJOTFscFhSMjJJSk9kbDRyZXNaNEZRSzhVOVNF?=
 =?utf-8?B?Z0FuZzRlbEJSY3VPZlphMGw4cDJvdHRTNW5lTlpFQWxnU2hFcElYSXhtUDFl?=
 =?utf-8?B?T2ZJbE5DTEVpZXhFa2FwQjNLK3YyVmxXRFlNbUEwSCtLNXlsUVpLb2U5Zi9E?=
 =?utf-8?B?Kzg1THN6ZGZ4d2dnZkFaeE5MQ0dvalBlVm1YU25yY25zazFiOEZERXZSRTUz?=
 =?utf-8?B?TVdydHRXbW1pQVU0YVN5bHpIUlYyUGlnLytERVRkZWhGZy91cXcyeWJCS1pw?=
 =?utf-8?B?a3o4QVdIbmVrWTkvMzB3WXBwM3VpSitEd1JFRjhGL3BGT29iNWFyaitIbm1E?=
 =?utf-8?B?S3dwUmxLU002N0xsK2gzck5MUVdsRkhOYnZzNnhUYWtsVUdhL3N1OEIvODJi?=
 =?utf-8?B?QWpBUDd5TWhOamFNQzlFcHRFa0ZNM1FMeWdla1NQcUhYVlloRVVuZmNLMFVu?=
 =?utf-8?B?U3ZxNFBHSlRVMTl2aUZKbjdJSE9hMlBjOEp3VEhlMjg1bm5LUlRNL2dZUEhK?=
 =?utf-8?B?dytQSVplK2FoK1VMTVRBT2VMRmZkaUVEMnhKZS9iUXdZcjFxYVFFcnErbEZZ?=
 =?utf-8?B?TWRBUE5IN2YwU09xYzRqN3BQVzlpdVE1OFRBQ093aDgyTG5rTmZHU3RRNmNi?=
 =?utf-8?B?OW5oU0FON3pQRXh4djkxOFpDMkJtOXgxUkJxaWlHZmNhWlVYWXFzdWQ1N3lD?=
 =?utf-8?B?WEU4Y0xQbjUrVWtGc0JMMFU4by80Si9sUXRZQlNNbU1GbHJ3NzRia3Z2MDU3?=
 =?utf-8?B?bXp1dGFSaEhNL1NMWVZlVENCUHBHZ2JjNXgyb0dHaXE0aWtDbWl6U2FMb0dM?=
 =?utf-8?Q?YQJDFQd2txEOsaPR+V8i5Bo3T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 135fef85-d8cf-423f-bcd7-08dc75468fb0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 01:21:50.0550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGVQx/DIh7omUZqVJEDXNSP5Jpu1WyHgH7OsmL9ziZKFCulr+/Mmc9Exex6XRZIQYuHKshWbmKiTTRxFOmxcPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com



On 16/05/2024 12:15 pm, Isaku Yamahata wrote:
> On Thu, May 16, 2024 at 10:17:50AM +1200,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>> On 16/05/2024 4:22 am, Isaku Yamahata wrote:
>>> On Wed, May 15, 2024 at 08:34:37AM -0700,
>>> Sean Christopherson <seanjc@google.com> wrote:
>>>
>>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>>> index d5cf5b15a10e..808805b3478d 100644
>>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>>> @@ -6528,8 +6528,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>>>>>    	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
>>>>> -	if (tdp_mmu_enabled)
>>>>> +	if (tdp_mmu_enabled) {
>>>>> +		/*
>>>>> +		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
>>>>> +		 * type was changed.  TDX can't handle zapping the private
>>>>> +		 * mapping, but it's ok because KVM doesn't support either of
>>>>> +		 * those features for TDX. In case a new caller appears, BUG
>>>>> +		 * the VM if it's called for solutions with private aliases.
>>>>> +		 */
>>>>> +		KVM_BUG_ON(kvm_gfn_shared_mask(kvm), kvm);
>>>>
>>>> Please stop using kvm_gfn_shared_mask() as a proxy for "is this TDX".  Using a
>>>> generic name quite obviously doesn't prevent TDX details for bleeding into common
>>>> code, and dancing around things just makes it all unnecessarily confusing.
>>>>
>>>> If we can't avoid bleeding TDX details into common code, my vote is to bite the
>>>> bullet and simply check vm_type.
>>>
>>> TDX has several aspects related to the TDP MMU.
>>> 1) Based on the faulting GPA, determine which KVM page table to walk.
>>>      (private-vs-shared)
>>> 2) Need to call TDX SEAMCALL to operate on Secure-EPT instead of direct memory
>>>      load/store.  TDP MMU needs hooks for it.
>>> 3) The tables must be zapped from the leaf. not the root or the middle.
>>>
>>> For 1) and 2), what about something like this?  TDX backend code will set
>>> kvm->arch.has_mirrored_pt = true; I think we will use kvm_gfn_shared_mask() only
>>> for address conversion (shared<->private).
>>>
>>> For 1), maybe we can add struct kvm_page_fault.walk_mirrored_pt
>>>           (or whatever preferable name)?
>>>
>>> For 3), flag of memslot handles it.
>>>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index aabf1648a56a..218b575d24bd 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1289,6 +1289,7 @@ struct kvm_arch {
>>>    	u8 vm_type;
>>>    	bool has_private_mem;
>>>    	bool has_protected_state;
>>> +	bool has_mirrored_pt;
>>>    	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>>>    	struct list_head active_mmu_pages;
>>>    	struct list_head zapped_obsolete_pages;
>>> @@ -2171,8 +2172,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>>    #ifdef CONFIG_KVM_PRIVATE_MEM
>>>    #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>>> +#define kvm_arch_has_mirrored_pt(kvm) ((kvm)->arch.has_mirrored_pt)
>>>    #else
>>>    #define kvm_arch_has_private_mem(kvm) false
>>> +#define kvm_arch_has_mirrored_pt(kvm) false
>>>    #endif
>>>    static inline u16 kvm_read_ldt(void)
>>
>> I think this 'has_mirrored_pt' (or a better name) is better, because it
>> clearly conveys it is for the "page table", but not the actual page that any
>> page table entry maps to.
>>
>> AFAICT we need to split the concept of "private page table itself" and the
>> "memory type of the actual GFN".
>>
>> E.g., both SEV-SNP and TDX has concept of "private memory" (obviously), but
>> I was told only TDX uses a dedicated private page table which isn't directly
>> accessible for KVV.  SEV-SNP on the other hand just uses normal page table +
>> additional HW managed table to make sure the security.
> 
> kvm_mmu_page_role.is_private is not good name now. Probably is_mirrored_pt or
> need_callback or whatever makes sense.
> 
> 
>> In other words, I think we should decide whether to invoke TDP MMU callback
>> for private mapping (the page table itself may just be normal one) depending
>> on the fault->is_private, but not whether the page table is private:
>>
>> 	if (fault->is_private && kvm_x86_ops->set_private_spte)
>> 		kvm_x86_set_private_spte(...);
>> 	else
>> 		tdp_mmu_set_spte_atomic(...);
> 
> This doesn't work for two reasons.
> 
> - We need to pass down struct kvm_page_fault fault deep only for this.
>    We could change the code in such way.
> 
> - We don't have struct kvm_page_fault fault for zapping case.
>    We could create a dummy one and pass it around.

For both above, we don't necessarily need the whole 'kvm_page_fault', we 
just need:

  1) GFN
  2) Whether it is private (points to private memory to be precise)
  3) use a separate private page table.

>    
> Essentially the issue is how to pass down is_private or stash the info
> somewhere or determine it somehow.  Options I think of are
> 
> - Pass around fault:
>    Con: fault isn't passed down
>    Con: Create fake fault for zapping case >
> - Stash it in struct tdp_iter and pass around iter:
>    Pro: work for zapping case
>    Con: we need to change the code to pass down tdp_iter >
> - Pass around is_private (or mirrored_pt or whatever):
>    Pro: Don't need to add member to some structure
>    Con: We need to pass it around still. >
> - Stash it in kvm_mmu_page:
>    The patch series uses kvm_mmu_page.role.
>    Pro: We don't need to pass around because we know struct kvm_mmu_page
>    Con: Need to twist root page allocation

I don't think using kvm_mmu_page.role is correct.

If kvm_mmu_page.role is private, we definitely can assume the faulting 
address is private; but otherwise the address can be both private or shared.

> 
> - Use gfn. kvm_is_private_gfn(kvm, gfn):
>    Con: The use of gfn is confusing.  It's too TDX specific.
> 
> 
>> And the 'has_mirrored_pt' should be only used to select the root of the page
>> table that we want to operate on.
> 
> We can add one more bool to struct kvm_page_fault.follow_mirrored_pt or
> something to represent it.  We can initialize it in __kvm_mmu_do_page_fault().
> 
> .follow_mirrored_pt = kvm->arch.has_mirrored_pt && kvm_is_private_gpa(gpa);
> 
> 
>> This also gives a chance that if there's anything special needs to be done
>> for page allocated for the "non-leaf" middle page table for SEV-SNP, it can
>> just fit.
> 
> Can you please elaborate on this?

I meant SEV-SNP may have it's own version of link_private_spt().

I haven't looked into it, and it may not needed from hardware's 
perspective, but providing such chance certainly doesn't hurt and is 
more flexible IMHO.

