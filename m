Return-Path: <kvm+bounces-19616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7537E907D0D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CBC51C21E80
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA8F131E33;
	Thu, 13 Jun 2024 20:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sa1ebAEP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E257C8D;
	Thu, 13 Jun 2024 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718308875; cv=fail; b=AfTciUaMEXLn2803B0qMQ5Xtstt196vw7AxlpMLfi0SY/ctP4/2NUuD+qS1MTk/8nYQVBcptx6cOzTNNVNwYdU29zIWwFjePff6sqC4Z2/n3RVI+NyBEin9YlIAkefxL9LqAos9Wzd80pJqhNEG8iVg1HlxpowLOFgxiRR8xYCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718308875; c=relaxed/simple;
	bh=x8YEZr4Lb4/UfMHcjaqskbsuuxxfAzWtPtdnmIRvSXs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BgswxuZSgSal+6sgVmgkErQ1M+/xitxffRp1W3zw2w3/wSleI854Y55Mahc/7whqDqNrxjQKzbXjvgB8y+bppTBcHTAU9E9hsFvOqPFgCJsiuc+9mNIDpVaF6WCK2Hn76JLGuNEDK0WcUJwoX5Ir8OewyXg6L8yCDpP+0gYdg/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sa1ebAEP; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718308873; x=1749844873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x8YEZr4Lb4/UfMHcjaqskbsuuxxfAzWtPtdnmIRvSXs=;
  b=Sa1ebAEPBSGlYs7iNluC67JsPB7MudXi2WGzcxcab9RbS41H/C9AMUhk
   oS7LwrTZlU5WDA7dfKogZ49FzLQ+FJhq1uGv0H6PUaLYaerqIBrHhMmwG
   rlln0O6/KwuAeohspRPmSqsgMVttLHYxH+Ef/HFCZDATKY5xuE5jKGweh
   /kAaIoN8S0689VZEX2W5D+QSxNQWRY8O2q+CSUEceTfFnIP3lywdVkFuH
   wO7qUXubnoO5cK1COqJFcoNCa8PgSElHMnitpYdzZKnPtzNglXmouzLCA
   YH/Hb06P8fbKkwu5F1tRLcIk8okFeROkEwX6Wac0Bq0IFROPDGXoNwOEq
   A==;
X-CSE-ConnectionGUID: QOP0JjzxQ4e9kCd4RdAuIA==
X-CSE-MsgGUID: ojnAIvRvRHCT5VmwG5OnsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="26564707"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="26564707"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 13:01:12 -0700
X-CSE-ConnectionGUID: myePOOXFRGCqGmIO6cuNjQ==
X-CSE-MsgGUID: 6o7+avBFTO6IsTLb1Fd7rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="40150634"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jun 2024 13:01:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 13:01:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 13:01:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 13:01:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 13 Jun 2024 13:01:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7d74e1RVgL/doO/opSzXFsGo059Ozdq6YyjvVOiQr/2ALHIU4aBmLbDIDm9CY+91n62eG8WJdWA1bylBJPRlKmTXTUhBsmy9het8nScoKpWUtChwOyk5l7AHDybLPljqSxXn4in9FmzBrWtZ/LV4G8grf+/gg7GsmuEarubeJfJW3r79AGWOr8c7C+EwjctmMDcekH0pNNMmQpdNC/3eiVTn/OJ7G0eCqsDP8fePe8x2PDdF/ECvNuxY/MC7noLpnFWrxaka7mzv20CtuPvcP2hVssKYsXx6NYWz+E2CxlaJRhmv0/od+lWtg7gx/4qb0yaCVGhbJRBHbi0i15H9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8YEZr4Lb4/UfMHcjaqskbsuuxxfAzWtPtdnmIRvSXs=;
 b=eerPIBTIOgV5WXrfUiiYQUY0lhsRVhwIBBFCFORWUoO/I+VO6Y9Ud0CV604nsAMzITbXSce/wzTPljmuMl9qEEy++SiEUvRNcpeYLB9Jv+n49dCTdx0G+u8ogI50MT1xK9PGdYwzayupqvy+/c1dp7s2F5LuCgfPoupILiSIyDpHCFFeFogpf0J9EqG/sQYYwOa2GcZ+s0z7XfYDyI3bvOvr2XzQJRRriX7l1srzslq6aeBauXE/xsusFHl/3rjzkurU84QHXziLMu8wMafAKQXC72RzthzFUNBeIZl8sBEHGIqWfoVuZUPn2vHlxjQiNTrCXMIr5fEtEN5BtMyw6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DM4PR11MB7208.namprd11.prod.outlook.com (2603:10b6:8:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Thu, 13 Jun
 2024 20:01:08 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%3]) with mapi id 15.20.7633.021; Thu, 13 Jun 2024
 20:01:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Thread-Topic: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Thread-Index: AQHavVgfQPm70dQw5Eee10kcdYgSb7HGHiqA
Date: Thu, 13 Jun 2024 20:01:07 +0000
Message-ID: <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
In-Reply-To: <20240613060708.11761-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DM4PR11MB7208:EE_
x-ms-office365-filtering-correlation-id: 9c247509-17cf-472e-2c10-08dc8be3908c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|376009|1800799019|366011|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?THZCMC9EeXNxZGZrOGdESlB0OEtiY2tJQmh5OHFEK1kraFlqY09DZUkydWU3?=
 =?utf-8?B?ckg5MkJ2Wjh2a0F6SW5hemMzeFhxdzhIS2E0NEhWWS9qOVVoTnduQ25XcHh1?=
 =?utf-8?B?UCthUXcySGVlRVRxQnVvdUJqZlNVZ1VEa1VVS0tnQVVPVkxNMGdGQjhWR3ln?=
 =?utf-8?B?Wit0NFRyU0N2RmZaSGhObDdDdWVJbUpaazkrQ0lRcEs5bC9yckQ4aE5LMkty?=
 =?utf-8?B?emJaOE1UblZjZGFucUJ3VTdpMk16VVJRSFhYL1JYMVBQbW9DbFdVRDFmdXRT?=
 =?utf-8?B?aTBPd1gzUVoyWVVCUEFiZkQ0R1pkL2I5aFdXOEVtM1V3S29VZVlyVkFBQnk0?=
 =?utf-8?B?dXZJdTdNazFOYXFab1FxVngvaEVqT09LNk1HLzVkaVBLc2V5NWRoL3NtMmJn?=
 =?utf-8?B?WERmYVpyMk40Z214REVBL0ZrZ2paR0hjU3hrdkgzWXo3dkx0TXJqajlYcU42?=
 =?utf-8?B?UXdOcnpXOFpscnVBUWJVQWVWVUlOT09zZ2JyRk5OcHFxazlvK0NDbVFnMDF3?=
 =?utf-8?B?NXkvUUF4MGR3YWNPRUVHN1VrcHJKaW5NQm5zNUFrVngwVy9ZUHpaeUdaMERt?=
 =?utf-8?B?ZXdUUWNpbzl4dVJhOFJDOE9kM2ZBRUphYUZWRnUzbENjMXpVQXJIMldoVG5K?=
 =?utf-8?B?Nzd2Szc5T2lrTWlmTE9RdS9iUVVaSzhLNkNUWm40bkZPVzJLdkttNTlvTjBz?=
 =?utf-8?B?MVpwVW5jb3UyWStEaFlBTG9YSm1lZytRYm9JQVJ0UGR4TldEM0cxa1FjRG5X?=
 =?utf-8?B?ak5rMmMrSEljU3JhcDE3QmZ3UEs5dHRpVFQra01lc3FQNUJnVTRnZ3hLRUNC?=
 =?utf-8?B?bGFSYzI1Qlgwa0Zqb0t0ZlBRRU56OHdaOHhiTjNNRDZzU0lPdXlzWC9FTHBZ?=
 =?utf-8?B?eUFEV0Z5U1lyQkdza2ZHSXUrZ0ZvMHJPTW1mY0FqcXM5cTRqZFpubDZFcVFG?=
 =?utf-8?B?RkhZbXpGTGo0TWpqNXVWZEd4VExxOWFnaFZsWG5GMWhkc1pXSVhpWk5DNTdo?=
 =?utf-8?B?b1B2UHIxYmlBcnA4U1REWHpLSis0WVE2WFhrSEVVV3NxOVNaaEplMlIvYWND?=
 =?utf-8?B?TmVvQUlNYzBjek5sem1WaEl5SHAzdmxUQnloR0E3bHphWWlvOHdRcjJSY1lJ?=
 =?utf-8?B?OFV1ejh5a3VDWHRhLzczOE5TVS9pVzJ0UjVXSHVhbG5PNENIRTB5K1U5Vm5t?=
 =?utf-8?B?NjBJR0FkZWQ1OEpSTkZJbkJ5Tlc3Zm11b2JTT3ZaWXR3SG9iRHZVcXNmb3lN?=
 =?utf-8?B?cXE2L2lMalVENWc3cmYyRHNRdnh5NDNVOGVyMURkVUNQcVltZVNhR3ZOblBo?=
 =?utf-8?B?SE5YRFFBbG5rVm5qUmFlMkFwakRxeG1GcjBZNGljREhFTFZWZXkyNmlPSnIv?=
 =?utf-8?B?ZVVJYzl2eXZSZzhiNWFIa2ZMcFBpUGFSZGJscGdUU1RYMTZ5bm5hSE9vQWNz?=
 =?utf-8?B?ZW1CblpTRUFrVWxDRUtUY084K1M0U2o2d3ZXQm1vNFppaDFqQ29JcFJrWEdy?=
 =?utf-8?B?cjgzb3VqR2cvNmNtdFNqQ3ZKUXc5UW9hN1djRnZxTVd0VEtTL240T1Z0ck8r?=
 =?utf-8?B?djR2Y01zY2pwejAxZXZ1bjA3cW9ubWdNaGI2aS9reWpjcy9ENVdmSHJjR1Rr?=
 =?utf-8?B?V3ptalJ5ek8xdDU4SzhQdFh4Y1EwV0Y2OW9qRGMyTVFuREZ5QXRaSHRzQ2Ux?=
 =?utf-8?B?L0V4SVdJRUhXMkhGcy83WmZ6Mkh1WHJzMm9wV1BvMHFqUFVJYmhjcW1zUmdF?=
 =?utf-8?B?emd4QnFXcHJtcFpSRVUxNlY1NlgrRTd6Y2RRRmJRSlFEc2ZXck1yVnZBUnBS?=
 =?utf-8?Q?9liTNQUkE8s18gtHwFVeiNE7dIdiWdmmDPl+g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zmp0QVlLQWVVLytvUXlyU3YvcE1pTmMzbEVJbnNoVTJnbG9SRCtQTE9SSVpq?=
 =?utf-8?B?RWxyZ29NbnVxK08wQnVseUtkWkFML25YSTVKQWR0OEovV3BqbkRKMmw4R3dx?=
 =?utf-8?B?bitBZUpscGloRTdheDIwb1FVMU1PR0NJRDNBVUtuaTliVGcrbTFXVC9qeVIw?=
 =?utf-8?B?djhySVp4MFkyVUVXY1V1NjFFZy9EMlFWdnVad2NLdFZ1OHM3YVNlK3NxT2U5?=
 =?utf-8?B?MHRJdU1nS29sdkloQ1FxVUU5a0pmaVYvV2grZUVjQ1J4ZnJaUGlzNllSUFdW?=
 =?utf-8?B?bFRMVnp6cDJkL2tDVzMybVJWY1l1OGVvemhRejNlbjloL240cTUxUDJoWEJh?=
 =?utf-8?B?Si8rbXdYYkxJbVdqejBwaXdVdnNUVmpZUFh1WDBpQjNDc1ZFbncxVWlIZ01j?=
 =?utf-8?B?cE1CdGhxYm85Snd0MlV2M01ZNmt3NjQvekRSWFZVQ1RnckIyakt0NHdKTDQ0?=
 =?utf-8?B?N3JxSXlXa1FCcVhXWTdDazQyRjJJaGEwY256MitNMHp4d003b1BJWXZxcEpT?=
 =?utf-8?B?STZiTER1enduTHU1eUlEN2dXMDBLVXJyVDZib3F1Q2ZIT0lTSzQ2am82WFNQ?=
 =?utf-8?B?ejdHbFI1aDhaNEZ6RGNnZlZFSFFmdUNmM2JjZkVLWHMzZlJQWklVVDZLV3VP?=
 =?utf-8?B?VFoybmRVei9tZjYvdDhkNkRVd2tDUVhhdks1RklwV3JjbnhmUEZNNE5mUXdk?=
 =?utf-8?B?Yk00OE53R05yeGZXUHkzVzhTZ05XV1c5SUNvK3pLMnYyWFJlM0tPVzhFZCs3?=
 =?utf-8?B?WUMwbi9IeVY3SFRSUFpYRlNJNmNhdkpUSFJKWHpZRG9acGwrSHVGV1NnL09a?=
 =?utf-8?B?Q0F3cnFMcElGMk5PKzh4NHlRNkZjMXVBQzc4ckpKbW9JR0x1enppMkN1VHJI?=
 =?utf-8?B?VHZRLzVnREM4Y3lDTUZNeDNUODFTamhOc09SL1hueHlwaHhweWhacDl1dkZ6?=
 =?utf-8?B?eSt1aFRla3Y1R1dxRGhzTHZjOG0yZ2NiZG9iQTZMaVhObGQ2dENPTEhGVlBX?=
 =?utf-8?B?a1FtZG9sM1E1YTNQSmpZby9zMjRXeHQ2NUhCWDJiSmZxMHhOd1poRXVhVkR6?=
 =?utf-8?B?WDMyNXRxandML2l1NGZDc1BUWXZWMi9TZ2I4LzJPOEpSd1hpUk0rbGFNdk92?=
 =?utf-8?B?ZTlhbHFQQVYxVnBkNFY5UUhSUjdKTEtuTFFjMzNrOXp1UWE4Zk9CUTJOK1JC?=
 =?utf-8?B?Z25qWHlocVBJa3dJUUlyUWxEQWVOS1BneVpCbXl0U0g0TTRUeFdIZldJNXR0?=
 =?utf-8?B?aVdVMVl6WDVFdFJqVFhDOVkrMUR6VlBRMjVPZnN3dnJkb29rcFZXNEFtL1Zl?=
 =?utf-8?B?cXkyUUROMXJvWjBxU1FSc2pzWlFId3M0ZzU1cllEdUJ3R1U4Um1JWmdQRkxW?=
 =?utf-8?B?SFJwQTlCTllBSkZLUm1QYzNES3RVV0duc2o1YmVBd0dzWVVtdFgvS0VXdGt6?=
 =?utf-8?B?R2xWM0s5Vll1V0pRY2NEdHFGdG84L216cFFwbGRDdXRodVhRU0l2R2trMDM1?=
 =?utf-8?B?SkF0bjN3MzRJbWRPV1pUbFRCd0l4eHhFdGZDL3dycHBtRW5lVXl6NmlIWjRy?=
 =?utf-8?B?UVV4OVB3UVpDTlBOc0hYSlpOWHdjUG1yUWNNODBId1JhcWMvN1N6a0FLMERI?=
 =?utf-8?B?YnVhT3JhVVUzYlliSTNlZmt2aGdtR2IxL0Z6TUliMU1sS1dMa3VRWXRBakpo?=
 =?utf-8?B?Vko3QU4vL0VoOCtGRS9Cd2YzUkZmM0hGNnlSY3VtNHpGaTBwMHI3eU5GcVo0?=
 =?utf-8?B?TkFDdHY1QXhjZ0lNY0ZybjhGQ1BXbEEwRDlpWUtVMEsycm9WS3JQSzdnaTVL?=
 =?utf-8?B?QmZ0b0FKZklscW92MlV0dkcxbWhaNExwcHo5YmxxNW5DNnlqN2tTeUZSNksz?=
 =?utf-8?B?ejdmYTZlWWJBSWNBOFdBcXRDdlViKzJhekU2ZitwaVBLMitsUjNsTG9qYkNu?=
 =?utf-8?B?bE5VRUZTYTZ2RktQbXdqY3RWM0FzcjhwcktLSzNWNTk2ak1YenhCUnlRajZn?=
 =?utf-8?B?U29vTEI0Q2c1U1A0eTZRUVNqS3RhOURROVJnd05NRUtQeVVxVkFxb1Z4a3RR?=
 =?utf-8?B?eElsRFhJOW13aVNDUERJdUZMSG1SL0lsMFdvRU5ieitTb1lkTEZ0b3kyM3M4?=
 =?utf-8?B?K1FTZEpkMkIrVTJUVy9XVG5BTEM1Z3d2cHpnNGZ6ejVTQ05HVlJabTUrSFVS?=
 =?utf-8?Q?WN9OguMrXzJ+J10J+vqiAfI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D1A5C4CDC5C324DB47291932264C6C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c247509-17cf-472e-2c10-08dc8be3908c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2024 20:01:07.8232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uxWjukMoVGXljc0Jm0Xr+CjCn5tyxQ2WyWP/96N5UN/xaYJNJZYkLWDF5PHif3mfnfw3Vhlk2EXP9oijDWQ9BYVRE8fhzcZYCTd3hneyIvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7208
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTEzIGF0IDE0OjA2ICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiDCoMKg
wqDCoMKgIGEpIEFkZCBhIGNvbmRpdGlvbiBmb3IgVERYIFZNIHR5cGUgaW4ga3ZtX2FyY2hfZmx1
c2hfc2hhZG93X21lbXNsb3QoKQo+IMKgwqDCoMKgwqDCoMKgwqAgYmVzaWRlcyB0aGUgdGVzdGlu
ZyBvZiBrdm1fY2hlY2tfaGFzX3F1aXJrKCkuIEl0IGlzIHNpbWlsYXIgdG8KPiDCoMKgwqDCoMKg
wqDCoMKgICJhbGwgbmV3IFZNIHR5cGVzIGhhdmUgdGhlIHF1aXJrIGRpc2FibGVkIi4gZS5nLgo+
IAo+IMKgwqDCoMKgwqDCoMKgwqAgc3RhdGljIGlubGluZSBib29sIGt2bV9tZW1zbG90X2ZsdXNo
X3phcF9hbGwoc3RydWN0IGt2bQo+ICprdm0pwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKgwqDCoAo+IHvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgCj4gwqDCoCAKPiDCoMKgwqDCoMKgwqDCoMKgIMKgwqDCoMKgIHJldHVy
biBrdm0tPmFyY2gudm1fdHlwZSAhPSBLVk1fWDg2X1REWF9WTQo+ICYmwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX2NoZWNrX2hhc19xdWlyayhrdm0s
Cj4gS1ZNX1g4Nl9RVUlSS19TTE9UX1pBUF9BTEwpO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAKPiDCoMKgwqDCoMKgwqDCoMKgIH0KPiDCoMKgwqDCoMKgwqDCoMKgIAo+IMKgwqDCoMKg
wqAgYikgSW5pdCB0aGUgZGlzYWJsZWRfcXVpcmtzIGJhc2VkIG9uIFZNIHR5cGUgaW4ga2VybmVs
LCBleHRlbmQKPiDCoMKgwqDCoMKgwqDCoMKgIGRpc2FibGVkX3F1aXJrIHF1ZXJ5aW5nL3NldHRp
bmcgaW50ZXJmYWNlIHRvIGVuZm9yY2UgdGhlIHF1aXJrIHRvCj4gwqDCoMKgwqDCoMKgwqDCoCBi
ZSBkaXNhYmxlZCBmb3IgVERYLgoKSSdkIHByZWZlciB0byBnbyB3aXRoIG9wdGlvbiAoYSkgaGVy
ZS4gQmVjYXVzZSB3ZSBkb24ndCBoYXZlIGFueSBiZWhhdmlvcgpkZWZpbmVkIHlldCBmb3IgS1ZN
X1g4Nl9URFhfVk0sIHdlIGRvbid0IHJlYWxseSBuZWVkIHRvICJkaXNhYmxlIGEgcXVpcmsiIG9m
IGl0LgoKSW5zdGVhZCB3ZSBjb3VsZCBqdXN0IGRlZmluZSBLVk1fWDg2X1FVSVJLX1NMT1RfWkFQ
X0FMTCB0byBiZSBhYm91dCB0aGUgYmVoYXZpb3IKb2YgdGhlIGV4aXN0aW5nIHZtX3R5cGVzLiBJ
dCB3b3VsZCBiZSBhIGZldyBsaW5lcyBvZiBkb2N1bWVudGF0aW9uIHRvIHNhdmUKaW1wbGVtZW50
aW5nIGFuZCBtYWludGFpbmluZyBhIHdob2xlIGludGVyZmFjZSB3aXRoIHNwZWNpYWwgbG9naWMg
Zm9yIFREWC4gU28gdG8KbWUgaXQgZG9lc24ndCBzZWVtIHdvcnRoIGl0LCB1bmxlc3MgdGhlcmUg
aXMgc29tZSBvdGhlciB1c2VyIGZvciBhIG5ldyBtb3JlCmNvbXBsZXggcXVpcmsgaW50ZXJmYWNl
Lgo=

