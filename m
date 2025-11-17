Return-Path: <kvm+bounces-63416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 48BB1C66085
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A8BEA35A7CD
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18571330B02;
	Mon, 17 Nov 2025 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCS5RKcK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42F025782A;
	Mon, 17 Nov 2025 19:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409269; cv=fail; b=NHp2rZiUxFEJNAY+ShTxeuiXtEaB1xK1GRlKitlbgqJ9mW2iyHNM2E7NwKLTPL+yTRa+Whex90XxjLxve1mLyL+r837QVGn0CZ2V+uCzYRm2PlTabPidVccs8JyagmOzIwjzWn7axauPykRzbTLjg07jULym5p74y4ZxJ+lIdqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409269; c=relaxed/simple;
	bh=vlByu2QXSZttyN/QqHD8pAJvWY+4AiJBZpAGR5b2K9g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rDckp64vdp1qIM9fFNBTRXxSK2SD+8cJXDwUim9FliPPGLC5wIZq/pqdFwFI+EjJzmwnxEa9+KRlpaaAcn1kyVMRVFBI4B1ufzynbEfVq+FO7bi9WqreOs9jX21G3QdDosiX8kVP87/YLyVvJLy6qZL972tsrynQA1snI5Uy7nE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCS5RKcK; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409268; x=1794945268;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vlByu2QXSZttyN/QqHD8pAJvWY+4AiJBZpAGR5b2K9g=;
  b=mCS5RKcKfNBN7EEPe4MbrMOZVfgvMyddtieUj1XV32kUfDklSS+9/hZZ
   KaHDHzgl4eBgnC8lsFCY9WImzD/NDOW+Nzh51OOe+rVXmDHYWfxnqU7mB
   faxi7zXCvinGJxHY0iVFW13Xo19yldACz980b5SylrE7GOsifEbg27HCK
   W206QaKDElFMA7a+9PotCWgZWvLUvjqnOZPu/0CyxFmgBngCsww22YEH5
   ftIMtZefkguNLDqDmLUInGnEO4FWSFmglKNBYE2Wi0IM41+kVrZQHYtwv
   x+tcmWGPo5cPiCuX3VXalAGjBl4BH6bABszTvRNTBAnnzuqYaTn5MrbSk
   Q==;
X-CSE-ConnectionGUID: 2sjCTaUpTlC/UiNwHJR1IQ==
X-CSE-MsgGUID: bJSIuK7IRvWTalpbGiwbhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65451356"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="65451356"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:54:28 -0800
X-CSE-ConnectionGUID: LXUoPVeyQOeZkfewVVSVkQ==
X-CSE-MsgGUID: ejXfQY0xQD6ST3RoLe81lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="195012441"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:54:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:54:27 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:54:27 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:54:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gFt4JfoB3iUPXC9CfewOPirgM9IVGAfjEHD6A2tvUG5VP3ayYeZCBoU7MSTvPYhu4M5dWIPKiPYvtAQrzSThbMRhP7uttz5yti5TTNbmFoKYumhP1DzGcE7h1y8LId20v9pwxyPv5vS5PQqPluaaVofvPqvTxFPUZcUYj2xYcp9F2iiDmaYBOrgVX1UoZKw1WMn4tHY+X0TkQW0GvJR1h4xYh2YhSKqu8Znhbk1b21Hyib6XICustAXyED7YEu/OMXE2kXS79tRn6dyUUPs7oS6ViBox5ddRA3S03XzCfJgk5rjBK5KksQ/aSkz1O/wmFBsXkYCAxt8bkriXpOp29Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VylH/uObMmhLG1zPpVztRX0E0FkoLYTpQwZPgqH16j0=;
 b=diZyBMW6P6+yeEPNFDy3hidAo5Z21rGoVSBVXYzhzWtBP3+CtBeraOEwyDYBbAF6y821K6KOW25UbqaW1RpTYricwxG2Ed7aCww6PYnyKpbKDgOy+DlqEcZxrKlFcwS5UnlY+ML5dZFD3jAq6xIaRtJ8UlnZ6i9P/TjEFMMwSbxGF6F6fQWp1hqdvXyezOUPGeATMP9NCL8TeCH0YmqZpBiRARbok88JsuCxT3KunjeVdKBpNEX5dJF0bav73uJpjNKGmtgqjYV3It0fvHG3MJyBvMQumUBf19wzU7Shoq5bjA0f9o+/JrH52+pBzOCA9rBLrFzM6Bf7u+PcW6hgXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH3PR11MB8562.namprd11.prod.outlook.com (2603:10b6:610:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 19:54:24 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:54:24 +0000
Message-ID: <c139a59f-e952-4a09-be33-2bfa6f6e84cc@intel.com>
Date: Mon, 17 Nov 2025 11:54:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] KVM: emulate: move op_prefix to struct
 x86_emulate_ctxt
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
 <20251114003633.60689-5-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::14) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH3PR11MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: d3852ea2-5412-4cc9-01f1-08de26131bd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dzd6alBYaXgvdkhlNWdNMHdDTzNtdUUzZ1BBa3VxZk4rM1JWUngxZmw2dExY?=
 =?utf-8?B?azBYV3U5NkJEbmxaUkszdWk1RXZXZGl3SnI4TjRWYmxQbENvMlUvN3RnRGND?=
 =?utf-8?B?YWtPYzEzQUVtY3hXZ1NJNEZ6ZmROeVJhUEVuUlpVQUh6cUphT1VxRzBaQjRX?=
 =?utf-8?B?bzVIL3NlLzdicGFhTjBXVXBOZnhQMldKQzA3NjZDNE51eElEb3pPekdsaVJG?=
 =?utf-8?B?M2NGU2RlSFJoS2kyc0NER3V5Q3pQVVB5S0dQMjNpK29iR1NUY0JjS0EyVTAw?=
 =?utf-8?B?UmU4bUYvb2M4RWh0OXdBL0NyaEwxZGZEREFjV2VXZXNPdUtxMFp1a2toT2ps?=
 =?utf-8?B?am5vRGQ4Nlp2bTdTbGlTUTZoOERvWkNCd3FLOEJCNG8vUUcwUlNBZlArd0R4?=
 =?utf-8?B?Q2UrOTdORkJSUmpsTGN4aGVEKzlvbVlhdkNrMXNYclZVSzVScklNZWZkRmp2?=
 =?utf-8?B?UTEzY2h0TXYrbkU3RjZxNFFUVm5mNFBrZktTMTd5N1lTRkNNTzJsbHYzSFNT?=
 =?utf-8?B?VFNZbTF6WUt4TFp6MDliQ1prYVAxZU5NM1hwdU4zcnBTZUdCMUhramdIdjFW?=
 =?utf-8?B?Qkk5VE1jdyt5UTlqVVdHOTNBUURVU3JuMitURWpTczRNR3BZc0VkWTFjWDBL?=
 =?utf-8?B?cTBPbVYzd0Z4WFdkbU04cWRkN3FPdURLS1hkVGg2SDYveGpmZGQxdEg1VUlw?=
 =?utf-8?B?ZExHSGI3ZHIzRmlNeHJmV0tUbGYvMWVaRG5PRFlUR2NIL1QwUGovd2JGdzFK?=
 =?utf-8?B?SDNBTjZLQ29NYjAxbjRhNWRLaERjTEhnUXhWakZTRThJMWE4cnFaVkMvdlk4?=
 =?utf-8?B?clZ2U2t1a2RDUnZvOEFXQ3NiTjVuRllLRERpdXNpVGI4eGVUcER4Z1FUSUJo?=
 =?utf-8?B?RnNUZENkK1ZvV0xOWlRSdEdxU3NONmR6OGxaTytGa2F2Ym9SZzNMVmV2RFB4?=
 =?utf-8?B?dEpFeHBsRWlBcGx3TGNlaUdxWEdpMmtGejZGUE9wVndramgvdDN2TVU3d3p6?=
 =?utf-8?B?ZU11U3RjTkprQ1FFenRDWnBHN29ENVFOV3NXVEpYK0pJVkR3VkpVZFJROXJK?=
 =?utf-8?B?cVQ5bXVEd2pESTVRRHRiK2w3MGV2WTI1N1JiWktZdHJpL1Bxb2xuTXQxazk4?=
 =?utf-8?B?b1VSb2lKVTFrc1VPK3ZpcS9JOWQvTXo2eUxTVXlSTUFMcW1IMkM5ZGZ3N0ww?=
 =?utf-8?B?RytSd2pFOWlYQkwzajhuOXdzczYzejlYYzlYaG9ubWRaV05nU2ZhMklzdU94?=
 =?utf-8?B?SGQ3dFQ2dU9LSlV2TmovL1cvdERKUnc3dkNhcVVnYSsvRFRTaG9tM0oyRW9N?=
 =?utf-8?B?THp4SStOTnRCNVJFWFkxbUJDaGNmSldHVVFFV1UzR3VSS2kveWF4eU5xbEx4?=
 =?utf-8?B?WnlLTXkydktMbDRYcTRJQ1hzM2lBbXVDL2lMa3JXSEZGU04zbFo4ZFR1a2FL?=
 =?utf-8?B?eXg1S2dpTTlDbkxtYjFrRytMbXcxTVF3WU4rWGU1dGJQcXpVUWswcy91cnJo?=
 =?utf-8?B?NEFMRXkvMXE1Ymh2bDVuZmhQNU84NGh1T1k3d3J0T0RqQUU1c24vTXRRNlB5?=
 =?utf-8?B?b0hMZlkzcnhhU2dtUTdpYXRGdngwOTJIcUFGa1Bod1dJTVpRZURObk9EcTlu?=
 =?utf-8?B?WHNSaGVnU2xubFdIQ0czTnlqTTBKcXd1L1FWcE1jVVBobVRQNVRsZGF6UHJE?=
 =?utf-8?B?WklwVlBSNjJGWHBxOTN2cy9jdFdIeDc2QVl3a0hPeDhwSmp5OFN5T3Z6dlU1?=
 =?utf-8?B?Z2VCQ1lvbHJOd0lEa0U0RzdhazZwaFExa0pQSjc2QnBNNTRiVjhQZWE5bEtH?=
 =?utf-8?B?UEZWOWdkNkhxaVNGK1MrRW52bzYrNjdYY3NUZGU3SDhud3pTUzdsY2NnOW5N?=
 =?utf-8?B?bHhJaEkzcytKQml1algvbnFnWFcrMlAzM2laTTRyUCtKZjV4eWZTQndYOWhN?=
 =?utf-8?Q?hen4G/5CUBGks/lvN/lXpsXAO/AB/zsy?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVZacUtpUXN4emlIeDU1R3BFU2FwWW84OFZtZitmMllKbUNzZEpCVTZOemJj?=
 =?utf-8?B?c0V1WkJLTXVPZzJna21ueXVBQVJtWTU4UDdsSVNKNVVDUFB0cVlUcDNEVnVI?=
 =?utf-8?B?cmkxaGpGU3VtUHhZK0pQL0UzNG9SUklWWHpaU0Nxb3JFOTg2akJtUDRscGtj?=
 =?utf-8?B?SzFabUN6bzJ0czNMeTJ0aFVJeFg2VXlRbnQ5cmhSRlE1NEtrZTZKbTFhQXBp?=
 =?utf-8?B?STBvRVdzWmhlWWZ2Z1VpOUJpZGQ1elZHZ3J5OU5IY0syQ0NzUXp0bUpnaElK?=
 =?utf-8?B?VnNLWnM4ZjVVQWVuRnRCZFVxSmE1L2dCU0o4R3o4Nkl4d0UxajBPbGhLbmVj?=
 =?utf-8?B?V3lPK01WSFNwdnU3RTMwWWgzY3N5cTdDQzQ5WVJocDdNV2ZDZjNKL0o0dTE5?=
 =?utf-8?B?WHNnYzRkZWpCNzhmZi9xRDNndS85YWRZVkRsL1hweG02RU50aGJYZStKVk9E?=
 =?utf-8?B?MForeEFnU21WVzF6UE5vTUVVY3VocTNic0g4d3pJM0pHYmhOeU1BWEVQWDAw?=
 =?utf-8?B?U216eVMvbjhxTVZBVE9QRUVtSm9udzhNU05ZbE5lenc3VW9jSzFHMTNjRkt3?=
 =?utf-8?B?dW16amVDRTlDTWxwTCtFZXRUVU9wK0RBNWVVaFZIR0pVSW0vL1E0QXgzUFVm?=
 =?utf-8?B?ZEZmWFVQeko4Sm1ZMkhQUi9iRG1WSnQrRnp3RzVXR2VRRmlyZ2Z6QVYrdXdB?=
 =?utf-8?B?T0hhWEZVSmFUblBWdE1wSFpFMXhoUmVDOGdKMG5hckx0b0htd0hXZWU5MGEv?=
 =?utf-8?B?aFM1Z21XdHZyVndVUytERExKYkN3cm5Scit6VnkwemIrRzlhUUR1cm5uQkVY?=
 =?utf-8?B?QWFieFRRVVI0M2c3Vjl0V3l0V1Fqc1crbE9sZUtNU0R3T215R0xQWGNhL2Rh?=
 =?utf-8?B?UVd4b2x0a2RiMnBFSU5iRzgvUEt4WFliSFhHUG5NK0ViS1JncVJaZ1dDaVZL?=
 =?utf-8?B?dkhkU0NsMlRhak5NZTgxMi9JY29pWVlUZ2lLR1ppbmxnWnVLWVRxYTU0ZEh2?=
 =?utf-8?B?VURnS2V1MkRGV1YzdktpTGFyZGlpdjU2K1o4VmNSRHFSa01xTStaV2oyMmMr?=
 =?utf-8?B?dzBLNHlLazdDaFpnckk0QVlIN1BaeUFkVUpuK04rNHZEOXRDSXVJMXcwQzRW?=
 =?utf-8?B?RVJsSGxxMnlIUWJyVmZHQ3lyR3VFNk5QRUVrVkVZKy9XcGY0NmYxR3p3SDRi?=
 =?utf-8?B?VlJTU1F5VnhldGlHMmFtanQ1UjlxYWlNY2N2WU81SStrTUFvRk9XTWZwTEE5?=
 =?utf-8?B?UnRvaHNTK1p4SkpqNFFWQWN0WnA5TzNGemVpSGhEY0thNFRQTGJmeWIrOE9n?=
 =?utf-8?B?eFpKMU9yYzFqRU45MHhXUUM5NnN1Ykw5L295b3FpWUpwUWdtR1ExWU5LUGk4?=
 =?utf-8?B?dm9CaVRIaEV5UFJlK0pGWGtrMkE5Q2FvN0ljL2dEZkxsV2EwM2dMQ1NuaDNO?=
 =?utf-8?B?YnA1ZmhtVVIwSEUrNVhKb25waUtWMG0zVnNLdTBrajhaMzV4QVluV2JpQVRl?=
 =?utf-8?B?YzhiMEIwZnV4T2NWSWxkYzZOQ3ZaN2Z0eGRIWE1iRjNnUDJyVGhsbzZjeGRm?=
 =?utf-8?B?Z3lXVjlLeUNGSmFmbmUyemNzU2t3VDBvY0NKYXU1QUxIVTBUQzF2NUE4ZWdU?=
 =?utf-8?B?Z2x2MFBrR05NRjBxcTFOY0dGTkZ5V2s4OUFjeDhjU2RTMlBrWUxTcklvUk14?=
 =?utf-8?B?b3VCaEN1YkNpa1Z4aURHa2FMOVEwdFExMlhCRHI2NWhiSUJDcFB6d0pidDZH?=
 =?utf-8?B?aXlEdzE5K3pyS21LWFp0eEFlVUozTEZVaTJDZzJKMk9oYkNvVkthRFFxVTBX?=
 =?utf-8?B?Mjg0RVFtUXZDTzBoQng2NFBRT2x4eVJUd3ZSMkw2V1ZLb01TKzRJbDdSSmtX?=
 =?utf-8?B?ZVNrRmNQbVhoYTZUNDJFOXp0MU5DaUxldXdLbHJPa04xR2swTys1SlZBSjkz?=
 =?utf-8?B?cEh2Z2FYWFFXWU90bEViMUFnVHpIUVRPM1paZ1l1Tmw1RmUrbFpkTFg1WlBM?=
 =?utf-8?B?OU5odVhkWnFVV1h5VC9VRWRGN3FLV0I3Z2N0UDlGY3B2TE9WZksrejZ4TitM?=
 =?utf-8?B?TXM1bHRrT09yS1J1a3hnQ0VhNzRDQVVwWExETHduWTk4ZjR1RVpUbEhqcWc5?=
 =?utf-8?B?aFNLOWhVTFpmMmNWWXlERUVvcHhvQXNaMStmbHNkN1k2RnV3YXdiM2NSM2FY?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3852ea2-5412-4cc9-01f1-08de26131bd0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:54:24.7788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+XbbA4dy43iA6uwHzL8ui3rYtKhUbr2+CvEByxa6gYBEJ7wpwAhHmOfpjyOlAte1t76s7vjJUXEvxfMfzixcael4CBwSmUoAcHEl2IZ57Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8562
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> VEX decode will need to set it based on the "pp" bits, so make it
> a field in the struct rather than a local variable.
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

   Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

