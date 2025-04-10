Return-Path: <kvm+bounces-43046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E770DA83755
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 05:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9A324A0221
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 03:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F6B1F0998;
	Thu, 10 Apr 2025 03:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QY6XXPQy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8540E63B9
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 03:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744256909; cv=fail; b=RajxKsxQwtosey/b4fUj3Qcs/qohN5UshGpYUNZeUXMfZSNFB3YPxRRYNbw4mhwHS2cJWGglj3SzNrkhiXVne+WAZFy0d6Ll5Ekc+sAsZZMcNIpjGSaqjAQ8lEv8e94C3pr53XryEw0OUN9Z1yvN29c3+2AAUXwJAyn07Fgohwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744256909; c=relaxed/simple;
	bh=PaXBRMzrDsnmo6EfntomlADomTwXSRcZ0jd0R5//imQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=naoQNYDYYyURFCVojnbw8/Eyz2LbQPduEXEaM1ueeW7L0RL7gTeoN9DM89vmtogm1KYr7HV1AayKFtE1zVmdv9ttDh/Gx96G5ULIH66HA5igLb4rkl1kH/+DxD9qk2ch2sh61uNAETHpkLm4Px/PHsgIlRmHKbpaxK4/YPXZvVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QY6XXPQy; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744256906; x=1775792906;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PaXBRMzrDsnmo6EfntomlADomTwXSRcZ0jd0R5//imQ=;
  b=QY6XXPQyhYerErbZ/ghH6dGMnP07bx2kyn+MJ94L+aKKU7cVW0gAsIgh
   1jUeCRBIVegoPR++naokfTtzpaUlyY+c/+W84CH82KcipLde5pf0+/0ns
   BJqbxdcc1OR2N+IkgydGwCErjSv7ZXEnvsf0tTbmwDYuqX+ktK7LlaKAo
   NxMolM88r4Xp+iqjWZsEPX/+/HXCbaPeTktsIcEsaT9I6hyng65Rgp1aC
   sWj8KbIRK410rmY/I4r7L3Shfpn6efDHPmXLn48hzjoGnP/kcXL9XlJ/g
   XPbfiXjh++Rb2pbHOxvlsuAraoScBCntKKDHthujwHvCdPg478sbsCytS
   g==;
X-CSE-ConnectionGUID: 2uM0li9bTQW0hG6OYMz7jA==
X-CSE-MsgGUID: XLbyqQmlTzyhBcv/ooUCDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="57133339"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="57133339"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 20:48:23 -0700
X-CSE-ConnectionGUID: waIQehINSK+jkuVWahLNWw==
X-CSE-MsgGUID: SZnk5OQwRP+v5pSxZ61ohg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="128736903"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 20:48:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 20:48:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 20:48:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 20:48:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kxn7jDYvagCFEgE5zbsX6Iz8824ah5p/ashLqmDgnyV7Lc4TtVkfqI/fMX5j0NS6KY+paLsnDYHLues6NZKJMsgIBoOMy5x+cw3rYG1B4hTnak/qTGiaHR2juDWXZ53/lSp3X9Mfi3Dx7+Hz+cX7eIFrGRHJmdIvM8UfWg+wRk1rzpKyAYkw3zJxscZ24eKMDH45KTYSWv1HAWODEY0lamhGtkSVSznv95OSLnQkXd93krZ90oL8o+9kpIvA9pL0Rwt4BDpEaSSomyzEYCEtU9uJDWvM6po7NeiI0SCmH0Qq6p21n+6TyH2Wgdd9GcChBUnSYm8XylQRTcdNpWYa8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQQCu1wEgzPOBeA2aok2NYoVLmTaX8NLqt4R821UdDE=;
 b=jLB5xP09CiDBDKe1v7b2NOT0Bpy+f1VNkcv0CJgDv0f35PBqvdPAmHX8rdwyOuJ/p3YUVeivjz2tHgWzP4foJGyeyB51WVGD8IQstW62d2CU9c6y9vpaEJsmykLCqzR8KA15nBNr31R7uK6/97an7FNKbEtX1D5aczgIw2f7qEK5y7p5e3kl5L4f/qy5H9yTQZHY9s0CJ5lelkigtgvDwN4h2era7Vp10D+uND8lhDqTbRx58Mic67fFBNBoBhQrlAb+rtG4W3WcWOuCZw0VShzZRzWQjeJS2G8fdA6iZjTd8p6EW+luV/1gRzjmT0+iF5oQaZd/3JX19hJmRFnUMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ0PR11MB5103.namprd11.prod.outlook.com (2603:10b6:a03:2d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.23; Thu, 10 Apr
 2025 03:48:06 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 03:48:06 +0000
Message-ID: <906246f7-07a1-42f8-b7dc-b271864f301b@intel.com>
Date: Thu, 10 Apr 2025 11:47:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] memory: Introduce PrivateSharedManager Interface
 as child of GenericStateManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-6-chenyi.qiang@intel.com>
 <a72382ad-ae29-4e5e-b2e8-ebb378861e30@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <a72382ad-ae29-4e5e-b2e8-ebb378861e30@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0159.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::15) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ0PR11MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: a526ca2c-8749-47cd-1535-08dd77e2809a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXdxa21oR1pEam9lQ0NMUmFmZ3lXbkQxbzgzV1k1a3ovRVNybUxiL0wwdjJq?=
 =?utf-8?B?bFZ4czAxRU5SejY2RnlnaGdYY0VYMjdId2ZCaTJOU1Azbnpod2FyblByL29w?=
 =?utf-8?B?MUIwSXcvQStuUk05ck82ckwwbzJFaGo3YUJqaGZEZ1l6RUF3UXpSaUQ0cSt2?=
 =?utf-8?B?Q1hPbUdCeFFtLzd0UlYrWjYrWkhSdlZ6cVBYdXRPNkZTU2RJejhleStEcFFB?=
 =?utf-8?B?SlNRYXkwazNkVW5oc2JqQnZZY1RnTUJ6ZmtHWDIweG5HQWVSZFpJdVVWcFFo?=
 =?utf-8?B?ZlRwRXV6b3JibTgrNERqd3FXc3o1TmNudGliK1NsK2E2TjZGUlFxZ1MrUXYr?=
 =?utf-8?B?VzM0UE5IZ3daNXZRZGdkWHAyQncwTUxYQlQ4NWgxSGhwOTAzUjFPQnBZQXpG?=
 =?utf-8?B?YmUxY2cxNzZyTlRTRzBtZS9lT0IwVzVMN1c1d3crNG9JMUY1bGwxU1NONGVU?=
 =?utf-8?B?Z0grY04xZFk5RytpNm50aEs5TmE0dnhXcjR4eU0rdjRycmFEWHNMUkdrVDd0?=
 =?utf-8?B?elR6WklxRnhPOHpjZ0dMYVR6dGxCOWxaTjIxRUxFRzMyVDIrc2pDYUIvTjVw?=
 =?utf-8?B?SXgyclRHdXlpRERqY1JvQ0YxaWtHSUNTbkwyRS8yNEZDTU5lREFHaGw0U1l3?=
 =?utf-8?B?Z0ZQaEVxdzN1cEVjbjZ4b2ZIdWoyWVRKMm9HVkg3eFFidjFHeGd5dzVob0xn?=
 =?utf-8?B?U2tzTHpOYzE3a1Y2ZHozLytaQTJtbEVxQUk2ZnJYMTY4aEJ1NTFDV0JzbTNo?=
 =?utf-8?B?MXhOUXA4R3crME5DdG9KQ05ON1RZZlVyelJLOG9sZnV4TVlERFErOEhKOHV4?=
 =?utf-8?B?b0ovODM4WHZpODJSckNsYTA1dVJTQlJmaW9FUlF4ZWRlOEtUSmZQaTdqdGsv?=
 =?utf-8?B?WXlSeGsweGdGOWFCVWk5ZTRvQzN2a2JIdzJ1U0dZYkhtckJ3cjQzVjFtUHUz?=
 =?utf-8?B?MnFvNEpUY0Z1bUxNbS80bEV5T1BrYTFCbno5SzRPa09pcmNxdW1jWFAwSVk0?=
 =?utf-8?B?MERsb0hFajNySjNXZjdwYmZkMi9qdmpXSkxPamx3c2dkM20reGxUWjhnSEl4?=
 =?utf-8?B?NWNzQnR4RXZ3Und4a0dmUVVQZTNoV3FNcGkwM0syMlJKaEE5YVNKcmJwRy90?=
 =?utf-8?B?YW1TQ3B6ZlNaa05HTUNuU3RmWUp1emJNWE5ER0JWNUpGeWpwSE5VRVMyOGhF?=
 =?utf-8?B?UjIrS1Q0K0FiSmRFMTAvUFR2OXRoTWxFdld1dUh3bS9iR1UyelU2SlpudWYx?=
 =?utf-8?B?TnJMQUxDWlFlU1RJUmhEVE1yU1NsdU5LbEtablZHajBlN3hpem1iZFVPcGx2?=
 =?utf-8?B?WkMzL2dXOU1tZ0VWZVV1MkJKOURNbTdTMTZwbTdGeHRDdWtwRVFJeEtzWG1L?=
 =?utf-8?B?ZTVvbmpMT0Z0VVROd2J3N3IwMmFZRGd6U3pyRHJobk0zQTZMbEFwVUx1SS9L?=
 =?utf-8?B?QnMxMUFQN1NoUlY2YXJ3MzJXamkyTTdiVVZlOFJ5YVg5UFhhZGlQWTZtQjNm?=
 =?utf-8?B?aVVTWE42cUVjdTgwcEVyREJDLzRYTHBqU0hNQlNsRkxpVTdkL1lmSDNEUmhx?=
 =?utf-8?B?c2ZkaGFsaC80NVgvRzF2YXZxWFR3RGVtQ2JwTk9uZmNIbzFmeE9aOENjM2tT?=
 =?utf-8?B?RlY0bkNRakJ2OE9GSGZQeHFXT0VhZlY5dlZIWjAwY2FyYStQOTVvVHM0aG82?=
 =?utf-8?B?UDRVWmYrT1BMOFJaUzJOYnNaTWgvOFRPTTI3Uk51TnRseWpabUVqaHE3SXQy?=
 =?utf-8?B?MURUam42Vk1QSmFCWTV1RTZpMTl5a2ltbExvUDZ5Mzh1T3NKQ1dwUlo1WE9i?=
 =?utf-8?B?SkdydzBaQllRa0dNejVDRXVzOVh3cUQzYTJLdFBYdm5vU1ozNERQU2NNd2xr?=
 =?utf-8?B?YTlFTFhndk5QSDZoL2pwNVJhTlQxYWp3QnNMakt5OWpPdHFhS1FCcEd4YWFI?=
 =?utf-8?Q?oMyUwVLO9EA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?My82NnFwRm9KcjJrWE85WkNiQWU0VFFURkYzcHZZYUZxeFJqVEJYRlNSYWVu?=
 =?utf-8?B?dmxCNThlcjV4ZTB3Tmt3MUs0Kyt3ZEtuMmttNFpVY2Ftc1JoNE9lanlpUVhv?=
 =?utf-8?B?SEZBT2RzR2lLT1kzb05TUzByZmRaekQ3VzRHL3phMThObUFpdzE2d0hCTE9Q?=
 =?utf-8?B?NUdROVlLVlF2OW9QRW1CUFBXZmRFcjdXUmZWRStvTDhqNkxHNWhOcEZWVlor?=
 =?utf-8?B?RUFHNVd0UmFML2Z4cmxJRXZwWk90eXNmWHMyNk4vZzQrYVRxMUx6VGh5SUlD?=
 =?utf-8?B?eFFhZ0tHR1JmMHdnNEtSLzhtcTVhTktNakMxTDQ5TkUrNi9kRDR4SUlOcEpN?=
 =?utf-8?B?ZjcxTTF5RG1IdVFXMmZmVG5VTTczQ3I2N3FCd29HelhOV0pVeDUzSVpxQlg2?=
 =?utf-8?B?aDI2NGRxL1RzZWZUc2xiRTBHdDQrTkpZRFU4QmVpeVFiZFdINjFweXo0bnlK?=
 =?utf-8?B?ODdNTCtKWUNXdHJ0d2ZGSjBBMXNodkxxMFlJSEN1SUk1SlpxUCtRVHdtdlov?=
 =?utf-8?B?TVk2bldVaWVLV2JDOUF5WWNhemdqVkxwVTQ0ZG8xenMreUJTTU9kR3RhNllG?=
 =?utf-8?B?YktjQ2RFYUE2Qk5tOHBOaEdiQVJLbWdjSHFmZVV5UVdMT3haYWE0UHNXMDFr?=
 =?utf-8?B?bUhqanhJSXU4SVJWSGx5eHhtaEpsNmpYalhmUWNwYXNwWk1PSGYxemJ0ZmJ3?=
 =?utf-8?B?RUxBd1B5K0NyaWY5ZlV1amdLclpobEdwRDFidGpEYTlzRlpYRll1TEkvV1I3?=
 =?utf-8?B?OEE0bUJDK1c0RDM4b1JDblRaaEwxc2RValhaVUpyNEllczZOUnMySFE3Mmdn?=
 =?utf-8?B?K1o1Y1Npb1FBRjRTaDlZajUzUjhoWFlsOUxtdUlSZll1Z29uOFdCLzZ6SHY5?=
 =?utf-8?B?OGNnd2s2bGJtdWo4c3pTRktIL1VGak0rSWxkeEE5d2NXNW4wWk5xVTk4U1Nj?=
 =?utf-8?B?UkJtWkJyb29WeEQ2c1huWnNzR2lpQ1lwL1MwZm5xenpsQUo5SW9aQWtWMG1X?=
 =?utf-8?B?T1I3c3dIa1lLK2xPbGh3Rmt6ZnV1V3lKdXR5ajkzUHBoSFZUdmowd2tqNVBx?=
 =?utf-8?B?MEYxTFhVM0w2RlNHR29oRHBMRFlwWWRFalhtdVFFZTRrZlBKZVRETkNCdXVY?=
 =?utf-8?B?SGtmLzhSMzZXSXJ3d3ZvNUxCa3d6bnNEaTNmK3UxOUlsa2ZmL1M5SjMyK3VY?=
 =?utf-8?B?YjBTWWdDaDM4T1ZUdEt2NHBvN3EwNVN5ZmR3S2t6VjJSVDEwd0RTVEtDdW5F?=
 =?utf-8?B?MzdsSXFnZTIydDd3cld5b1hvSkZQSXp1bHNNL0NVSUZWT1dESzNMQTNrZ2JX?=
 =?utf-8?B?bStoeXpacW15NCtJU28weW5ubktnMDlDMUZmeGlFSnhWMEZPZEJGVVFFQ2cw?=
 =?utf-8?B?V3g5T1NQcnJveUdmckw5VGZhbUZsYzhETCtQWjg1OGRhQXZSMlZqc3dwcUxU?=
 =?utf-8?B?WE5LcnZNNUlDc0NlSERnR3RzbnRIOFdYSkJPeE9paC9PazdSR0hUQjF6K2h1?=
 =?utf-8?B?U0JaWHdxK1h1ekMvS0I1RWJxZkRpZmdJQlhyMm9vME9QUCttdU11UVB4ejFU?=
 =?utf-8?B?TEFrNWJWSEluZ0ZobUF4Y2FMcGk4Z0RXZy9FV09KeWtVL0JwRkVUUUNINFM2?=
 =?utf-8?B?bXVoL2VTZzNld3h0VUYwNkpZMC9LOFpDRVNQbHF2SkV2dnNVdmhNUDlHWjB2?=
 =?utf-8?B?Q2d1UGxWbE5YOTNVS0RMMXVHQTFyQndUR09aN3dsclduOWhBRjdROUNaZ1hj?=
 =?utf-8?B?WERJOWlMbTdER1ZoYndsek5XVjdmeWdzRDlmaDZqQmZCelFnOExZY2JoUWFO?=
 =?utf-8?B?bjJPZTJlUW4xSU13bmhGaFBlTi8xMnBtTlZSTm1QY29uR3RqYVh4MXdqWTBm?=
 =?utf-8?B?L01QNHNoaG0yS1ZPby9aNXdUNDRad0VBcXBqbjZrNDUzNGFld0JYMkZRUGxR?=
 =?utf-8?B?emhNRzZoUlhEYmgrMURuL2ZWd1NBYTU5aUovcjNZMDdVd2NvQkowdmMxQUVq?=
 =?utf-8?B?aVJBT1JOTXlUdW9DVnFxUVBxeVQrZ25ZNDYwRmV1bE9iMUdEalJjYTdUQlEx?=
 =?utf-8?B?b1E4Zk9mUDJWbDlicTZNOXZVZEhiTFZyWFNGYkhFZmdJeGdEMUY3VlNnRFBO?=
 =?utf-8?B?VHNPY2hvSTRqbTY3cUs1ak1LRGdnK0pOVm5kQTJjbHZOUGZZVmJDeGxSRUtO?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a526ca2c-8749-47cd-1535-08dd77e2809a
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 03:48:06.3619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JQWt3ZvAc+ai4QpPnb+LGBZJeL79HJDIen5+MsTlgF2OamMm5pcnxxVrf3vqW0nieb6S2YXKarwODpEhENK/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5103
X-OriginatorOrg: intel.com



On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> To manage the private and shared RAM states in confidential VMs,
>> introduce a new class of PrivateShareManager as a child of
> 
> missing "d" in "PrivateShareManager"

Fixed. Thanks!

> 
> 
>> GenericStateManager, which inherits the six interface callbacks. With a
>> different interface type, it can be distinguished from the
>> RamDiscardManager object and provide the flexibility for addressing
>> specific requirements of confidential VMs in the future.
> 
> This is still one bit per page, right? What does "set" mean here -
> private or shared? It is either RamPrivateManager or RamSharedManager imho.

This series only allows one bit per page, let's continue the discussion
for this in patch 04/13.

"Set" just mean the bitmap set. Maybe rename to RamPrivateManager
(corresponding to RamDiscardManager) or CVMRamManager (Confidential VM
Ram Manager) if we want to introduce more states in the future.

> 
> 
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - Newly added.
>> ---
>>   include/exec/memory.h | 44 +++++++++++++++++++++++++++++++++++++++++--
>>   system/memory.c       | 17 +++++++++++++++++
>>   2 files changed, 59 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 30e5838d02..08f25e5e84 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -55,6 +55,12 @@ typedef struct RamDiscardManager RamDiscardManager;
>>   DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
>>                        RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
>>   +#define TYPE_PRIVATE_SHARED_MANAGER "private-shared-manager"
>> +typedef struct PrivateSharedManagerClass PrivateSharedManagerClass;
>> +typedef struct PrivateSharedManager PrivateSharedManager;
>> +DECLARE_OBJ_CHECKERS(PrivateSharedManager, PrivateSharedManagerClass,
>> +                     PRIVATE_SHARED_MANAGER,
>> TYPE_PRIVATE_SHARED_MANAGER)
>> +
>>   #ifdef CONFIG_FUZZ
>>   void fuzz_dma_read_cb(size_t addr,
>>                         size_t len,
>> @@ -692,6 +698,14 @@ void
>> generic_state_manager_register_listener(GenericStateManager *gsm,
>>   void generic_state_manager_unregister_listener(GenericStateManager
>> *gsm,
>>                                                  StateChangeListener
>> *scl);
>>   +static inline void state_change_listener_init(StateChangeListener
>> *scl,
>> +                                              NotifyStateSet
>> state_set_fn,
>> +                                              NotifyStateClear
>> state_clear_fn)
> 
> This belongs to 04/13 as there is nothing about PrivateSharedManager.
> Thanks,

Will move it. Thanks.

> 
> 
>> +{
>> +    scl->notify_to_state_set = state_set_fn;
>> +    scl->notify_to_state_clear = state_clear_fn;
>> +}
>> +
>>   typedef struct RamDiscardListener RamDiscardListener;
>>     struct RamDiscardListener {
>> @@ -713,8 +727,7 @@ static inline void
>> ram_discard_listener_init(RamDiscardListener *rdl,
>>                                                NotifyStateClear
>> discard_fn,
>>                                                bool
>> double_discard_supported)
>>   {
>> -    rdl->scl.notify_to_state_set = populate_fn;
>> -    rdl->scl.notify_to_state_clear = discard_fn;
>> +    state_change_listener_init(&rdl->scl, populate_fn, discard_fn);
>>       rdl->double_discard_supported = double_discard_supported;
>>   }
>>   @@ -757,6 +770,25 @@ struct RamDiscardManagerClass {
>>       GenericStateManagerClass parent_class;
>>   };
>>   +typedef struct PrivateSharedListener PrivateSharedListener;
>> +struct PrivateSharedListener {
>> +    struct StateChangeListener scl;
>> +
>> +    QLIST_ENTRY(PrivateSharedListener) next;
>> +};
>> +
>> +struct PrivateSharedManagerClass {
>> +    /* private */
>> +    GenericStateManagerClass parent_class;
>> +};
>> +
>> +static inline void private_shared_listener_init(PrivateSharedListener
>> *psl,
>> +                                                NotifyStateSet
>> populate_fn,
>> +                                                NotifyStateClear
>> discard_fn)
>> +{
>> +    state_change_listener_init(&psl->scl, populate_fn, discard_fn);
>> +}
>> +
>>   /**
>>    * memory_get_xlat_addr: Extract addresses from a TLB entry
>>    *
>> @@ -2521,6 +2553,14 @@ int
>> memory_region_set_generic_state_manager(MemoryRegion *mr,
>>    */
>>   bool memory_region_has_ram_discard_manager(MemoryRegion *mr);
>>   +/**
>> + * memory_region_has_private_shared_manager: check whether a
>> #MemoryRegion has a
>> + * #PrivateSharedManager assigned
>> + *
>> + * @mr: the #MemoryRegion
>> + */
>> +bool memory_region_has_private_shared_manager(MemoryRegion *mr);
>> +
>>   /**
>>    * memory_region_find: translate an address/size relative to a
>>    * MemoryRegion into a #MemoryRegionSection.
>> diff --git a/system/memory.c b/system/memory.c
>> index 7b921c66a6..e6e944d9c0 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2137,6 +2137,16 @@ bool
>> memory_region_has_ram_discard_manager(MemoryRegion *mr)
>>       return true;
>>   }
>>   +bool memory_region_has_private_shared_manager(MemoryRegion *mr)
>> +{
>> +    if (!memory_region_is_ram(mr) ||
>> +        !object_dynamic_cast(OBJECT(mr->gsm),
>> TYPE_PRIVATE_SHARED_MANAGER)) {
>> +        return false;
>> +    }
>> +
>> +    return true;
>> +}
>> +
>>   uint64_t generic_state_manager_get_min_granularity(const
>> GenericStateManager *gsm,
>>                                                      const
>> MemoryRegion *mr)
>>   {
>> @@ -3837,12 +3847,19 @@ static const TypeInfo ram_discard_manager_info
>> = {
>>       .class_size         = sizeof(RamDiscardManagerClass),
>>   };
>>   +static const TypeInfo private_shared_manager_info = {
>> +    .parent             = TYPE_GENERIC_STATE_MANAGER,
>> +    .name               = TYPE_PRIVATE_SHARED_MANAGER,
>> +    .class_size         = sizeof(PrivateSharedManagerClass),
>> +};
>> +
>>   static void memory_register_types(void)
>>   {
>>       type_register_static(&memory_region_info);
>>       type_register_static(&iommu_memory_region_info);
>>       type_register_static(&generic_state_manager_info);
>>       type_register_static(&ram_discard_manager_info);
>> +    type_register_static(&private_shared_manager_info);
>>   }
>>     type_init(memory_register_types)
> 


