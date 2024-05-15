Return-Path: <kvm+bounces-17484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDC88C6F48
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29A262812BC
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDAED52F8C;
	Wed, 15 May 2024 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ONcgP1Rk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFEA5025A;
	Wed, 15 May 2024 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715816691; cv=fail; b=S9RTcB2dyh98N74OnJKSkxZmohVEOXUoND6DNX6VAhGTU+bbj3ailJPc6c1013k3eCkj+tp+aKv8qXhJtNPfQaaXNDy1SSpi0iLaDN+ZadEQciipJNCMyz0RIP+zWsOfo9oOB3avsgHNZN/XyZPRMbRWK90Va+hgkxshRHsD//c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715816691; c=relaxed/simple;
	bh=EmoUAb09s7ovJy1EBICj2/u+dwEh6QObfVacvc6vZjU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jt5xTKP3xsCe6nmKI93V565NSc59dwigSO8pfpfzmip+jNjfeRYsCYLd3uQaxA1CR4gHFkSdeIxE861je/moAXBYoPPJ17B+fI+KfMGIRhUV/f022bepBAjJWSffMrLUfC6t3WSoltAgY2XZLp4E9y4CZLa0bYnL3KvCnonEScA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ONcgP1Rk; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715816689; x=1747352689;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EmoUAb09s7ovJy1EBICj2/u+dwEh6QObfVacvc6vZjU=;
  b=ONcgP1RkafXh1wqIodw7cJFegqxR0joyiN89Rq75YFrr3klX35kAHCUA
   Rf9ap/LzVmGmX5vEA+6DjFlaa9aEVC+GAXsmxciZdf/SbepcW+IstDS98
   V36oPG2Z8CrLxUBw8rhJDbdOXLNLVJ9JLJTaxXQIRcgrIbI0eR/SZGm1r
   upIEzRNosPVEK2CVJTb8p2PqkJ8AFopR6WglPXHVqpNQhyon7z6Ujd0xH
   7P9UvnycBEkxmA8Bq7AlAF5roWG12zvpNu49KxKVlGZMUbcZGKkpj1G40
   2IJedh9mLzAwZG6iaA1pchJo1l/D0DfnHWluwCZflIjiKg4Mpu+WW4UDn
   Q==;
X-CSE-ConnectionGUID: wlsa9A0tTV++LnR861kIig==
X-CSE-MsgGUID: Ti8VTxdATX2jgFTvPgydDA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11546071"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11546071"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:44:49 -0700
X-CSE-ConnectionGUID: 2VQDgTvLSH+1kIduFoi97Q==
X-CSE-MsgGUID: g6j6xpdMSUuJDGEPHvLRTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31232019"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:44:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:44:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 16:44:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:44:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:44:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BE9HtxWQGInjvvs8jAVnbLahRlA3wCblra90Jxhe/6ml/o01qYoSbIDi6IYwdAB2BX6i99OoUsq3GQu6rpdY5sboNu/TLkM+gZhHxA8O5QT/pGEf5fV3r8F2PR4/QdkZ16Xfuohsg76Fwk7l/DdnpFyD4SDswiW4breVX7YwYfNUbBpeznBpV6cXSkvUEHP7cECc5gWuP6ZpXDWG4SZ1F3WC6xRJtH1HICGFqXIv31YcpndgKOLzizq65rftwx1aZZuERPHUR5lMNsLfeoLQ9fJoZf8AkSnBOZHVrOyQXLJblLg+4kwpSoycbTV4Z5s0onrQ0t7pf08+GPOA35DAZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kh9veSUSG/XxAat+mrtqh9+cEWRZd1AP531II+8Sjgw=;
 b=Q9eVBnBDtzTJgpJmUQexFrfB4MztuUJknwOBfE0oakdIjE46EamJDVkcZPF3R1Evk+22XYVkW6b2MxwJyuKSkMPMH6TIQw6MW7FsIy97keFlyV+bO79y5jQ9N1HQIuca9JWvJEdJ1DHWO0rKUkzzOFPg9rweK3wSYxXPgkFcvP5oIqTk1V0L9wcpryV6Ly0kClrq0wIecpz0Dak8Rfnus7NqV7BcyVBXCNx+oQ267QsDTClZH0W6tHOwH178ij/aV/SzOgRbP0gT+06dluc4kkPIU6Ycv5scI3iXhSYHU+2Qd1r3u+pM2rpyS4eKBJGuHXy1mI20fuHD2nHj0Q8hag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7342.namprd11.prod.outlook.com (2603:10b6:208:425::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:44:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 23:44:39 +0000
Message-ID: <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
Date: Thu, 16 May 2024 11:44:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0289.namprd04.prod.outlook.com
 (2603:10b6:303:89::24) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: e77786b9-4d6d-4a5d-b3ce-08dc7538fc93
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RTdERjI1bEFYU2Y1QkVHSUc0djZHUjhIQ043TGFhVG1UTlk1ZzkxMlJUcTlO?=
 =?utf-8?B?ZWRPM0lQYllmOTBiYlNpWVc2TUp3bjBhcytQQTdTRnBLMnNoa2lIWStYVzRL?=
 =?utf-8?B?NXFvWW1CSWhMcGRUVHBnT2lvMW9EUzNydDhnZzNMZjZWRXBOTDhnTmVodFdj?=
 =?utf-8?B?Z09RSys2b3kwZmpOV2tNTW42OVJTakZqWE45aUZiVy8zeUFvd1dYLzc2VWd6?=
 =?utf-8?B?UGJRbXBOSklTcXAzV1M3akVuSEwrSTJNeVBQNlBna3JRQk9UWCtpNU5NNHN4?=
 =?utf-8?B?VTRyTHdlWXhKa3p6NzRWYUp2Uyt5VEdlVXM0b3RsK2dkUkhCQlBmbWd2clhu?=
 =?utf-8?B?Ukg1TnFhLzN4QVRrZVJpVmVvNlltU2orN05HaU45d29oUDJjd0tBdFBjcnMz?=
 =?utf-8?B?Z0JWWXRIRkhoTFFoUzRLV2Y1bFRFSk9kQ1pBNXJ6b09YcWNXcU04SWpBVUI5?=
 =?utf-8?B?eHJsTjNDSUpDNTRSN3NZejRGYjZGWGpsT213SVlKUHkyanVxMi9NMys3ZVFM?=
 =?utf-8?B?Z1EzOTViM0JseWFyMFJHajFtQ2pFNlM5aU5aRnFSRStjSmEyQ0Y1YUs0cVFV?=
 =?utf-8?B?WlZTdkVUVi9POCtYZmZDVC9EUm13ODA2MmhmM2ROYjlYMjFjd1JUMlBSMy85?=
 =?utf-8?B?ZkpWakdaL2tJeDZRSDg3cmptTFhaY3QxdTRyUjh1Q25kb1NYdHNUS1g4QkRQ?=
 =?utf-8?B?cFNoeXFBeTBJSERKWTMzM2c5UEEvcVJiWTc1SEozU3ZWVnpUdEZwUlJwanNY?=
 =?utf-8?B?MHF3SG5DTVVrQTRJcnJRK1hTVTBUNndhQXJIdVE4MWY3QlFmaFNkWklyNGZO?=
 =?utf-8?B?YWtLVnNrVnI0RWdwcjRUQnpmT2pENHE1S3V5Y2hYQjlpdWtLRitoVWlzNmF0?=
 =?utf-8?B?QmNWVzJuS2xqQWJZNm9ON0o5ZHk5RVRGMHBFeVYxUTFFOENTWHhlZkhKS0wy?=
 =?utf-8?B?SXlYZjg3SGtVcW1CSWY5endMV0FYd1p4aXFrT1UwWlROSlIyUHhZM3hxaGN6?=
 =?utf-8?B?aVBQckZtUWpjL2F2NWJ3czdMWUk5MWNGekZzSW5OK3BaakdnaHlCZEk3cERj?=
 =?utf-8?B?bnJMUWl2WUMzOTBpRmR4MWlldEJUT091Q1hkcEVGOGFUMnNNbmwrNnFPMXdl?=
 =?utf-8?B?YTNOYlgwNTY2WVpRTjQrNm93aFhxYUdjUGp3UzMxdURKMTc2eXd2ZVdDMFZm?=
 =?utf-8?B?ZUFHYlhZYm9BN0xFVmRneGtTQWxTY3VVdVlOZERJNTdUem1Dc21LUVg1Mity?=
 =?utf-8?B?VFA1WkhZbmRhcXRmbzJVc3g4VkJzdjBBbzVsaEY5R0Fxa1YvWTdkTGpNeVdQ?=
 =?utf-8?B?TXBUcWppYjdKaWJJdXNNUTRYWVRreTBIZU5ycEZ3cFdLVkI1dVpodDR5TC9N?=
 =?utf-8?B?bjJUN0pEZHNFdHZKbW4vZFMvaDNrcnFGV2xDMTJKUTlUN3k2dk0zZ1lOOEtW?=
 =?utf-8?B?UTBxQnZ0OEgvaUNESmlEM1gyYmdna29kTCt5L0tIQlZJMURvREo5RVpQMmlw?=
 =?utf-8?B?cWI5QitIOG1qdWZpK3NtdW82cFVRVlozNTdsc3YzakFMMUFoeWxmcE5FVmNM?=
 =?utf-8?B?dmllRFBxTkFLWGVsczAwWVpLV284dHNtZTlWTWV6blRRRkZpVFpRUFpEbEdC?=
 =?utf-8?B?Ti92RFMrdlFaMXE4TEpRQWhVdVAyTHh2QjhrUW92ZVB1TnlPTUVrR3ZEeHln?=
 =?utf-8?B?Q3JlZlBqd2RBbzdjM0xVSHhVRzNXdnk5ODF0bHpJTVhQbXYxSGRYMER3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFIxeUlOSEM4WVg1QkxSWVhMN0xXOVVidFEwSTM1d3NmSWtxNFN2dzlaVzhw?=
 =?utf-8?B?V09Ud0t6ZDg5RGJXOVdTakx5RWZwdU1ZNFBRbU1OSGRqWVZDdll4VnBLNUxa?=
 =?utf-8?B?WGpnZzhwanBkeGpVQi9RWlROTU9wS1BnZERXYm9XM1huVVJzcklQYjNHSC9J?=
 =?utf-8?B?REZncndyZ2RNd0FlWVc5VkdsVGYxdm4vVVo1TDdZL3NPNkhwOW9NVlpQNXdL?=
 =?utf-8?B?Nm5JKzZYeHhSY2EyTG8reU4yVWM5Q0dCT1k0N0w2MG44clJvOFJYUWgraDFn?=
 =?utf-8?B?dFl1c1pwSkJHOUdwVXJLS0N2bCtpbUprTTVxTmxXM1lMSzUwWFhRTkJZL2Fa?=
 =?utf-8?B?SmZoSXpmWmpCL1Y4UVViQzgwUDYvTmpGOStqeGxrelB4UldlMlhzVVluU3hR?=
 =?utf-8?B?eFhMZTdzL0pBT1RPM3VmUWE4VlpHWmZtVFhma0h4ZG8xOFkyd05PSWpOTGZr?=
 =?utf-8?B?QXdENC93VVFLVUYzLzVtSmFjeHhlNFBBYVovS1BtNnR5cUFPWStwYnFFMUY2?=
 =?utf-8?B?VkJtOFk2NW9EbVJMdUFITTFyWTQxTjMwdFEwUldoSHFPbHlLY1k5ZjREWHBm?=
 =?utf-8?B?ZG1GYUhrSkNxOGU5MTVSNVZZY0ptVndhd1V5VnFiS2NyLzNFZ0pkT2t4RWVR?=
 =?utf-8?B?bEMyTFdVS08zVkUxam5HbW1mN1ZYdmV6NnNTK1o4NDkvRUZaVllpcGJhelpO?=
 =?utf-8?B?MmU4WVY1b0JTTEZGL1NIN3FkU3NxUzRnaUU3RG1xVGN3MEN6TjU1N1d3UjdZ?=
 =?utf-8?B?MUo3cWYyWjR4ZEUvcXI2clFsNjFHVUcvTjF0Q045QnZLSUYwR3JiZ0t6aE13?=
 =?utf-8?B?V3VOYk9TOWV2WmJiTndlM09wM3J3clNvc0hpRXdjOUFCOWUrRVhUeEFUUFpr?=
 =?utf-8?B?WGM0Z2Nuemp1dkJhL1NMQWRQcGNmQWJxQ2Q2SEJrUld2NWpkaTVxS0VLcFox?=
 =?utf-8?B?cURRUk83UkJpWDVLUGthVUxyWkNseVdjZXl6T0ZuSS9nRUJ0RTd4eTg0a2py?=
 =?utf-8?B?Y2RhVGdGOWt5dUh3dXFUeVFZai96QW5MS3Znc2s1MUVVQngwOG5FWG1CSktw?=
 =?utf-8?B?VjJpVkkwVEpvRWY2UDJ0MDJEQ3NZMW0zdTd3d2VRaXowdG5ZWnY4TUNFTXM2?=
 =?utf-8?B?WDBPektCcGJ0TzFzbWlBK1NmenJjdDNsMjZhU0liQWs1azFyS09BelluL05u?=
 =?utf-8?B?ZGp3N0psS1ZUa0hOVGpaTno3V1d2T2xkNEpVd2prWW1rVTFZMSttdDhyUmI2?=
 =?utf-8?B?VG5XZVZmWXYzUmlnZmdSZGc3Q2dUR21CY2plLzZjeUlzMkNKa2lhckxOSHM0?=
 =?utf-8?B?RGVYbW84NHBia25UTmtLSFB3czFBSlFnK1paL1JGU21GbnMwOGlleG50OVlB?=
 =?utf-8?B?YUk3bXZVSU51Z1VVdUlhN1JyYTdjdEdhWUhqTytiQmxKVEs3d1plRnpSRDRj?=
 =?utf-8?B?YnRHZEZGQ09xSTR6RXlkNUlvdGJobm5LaHo5TklUYjBJQ050cGgyMFF3SVll?=
 =?utf-8?B?TGZHeWdNOGgxUENqQmVZNGhvUzdvSUxMb2V2dFJNR2xhUXd6Ung5WkRKLytj?=
 =?utf-8?B?a2NNUjJ6a3F5OW4rV0FCdTA3L1B2am9VNVRoa0hIZDEwSWVuNVBPYjFaRjRj?=
 =?utf-8?B?cE9kWUZLSGtXaDhJUnREKzBKRGlJY2ZoMndmRlBBU3NMdDc0Y242eUx4TGlp?=
 =?utf-8?B?cVMySHJrZEh5SGt1aWxCRHZXQjIwRndxaG9FL1ZzV0tPbkNmUk9IajN6TTIw?=
 =?utf-8?B?RXQ3OG5ocVNDNVpCRFBiQVhxa1NnN1BLVWRjNFBVRzNwWC9LaUxxb0p3WXRq?=
 =?utf-8?B?dHIzaExVV3NXOUNmOXhHbzlmR1dJVkhUc2lJYlVDdWJhM0o5RHJCN1RwdHRv?=
 =?utf-8?B?Nkd2NGZQRFlzczdZNGRzd2JQRXI5b212T2JleGhoaGROdUpiUGt6K3Fid3RG?=
 =?utf-8?B?d2pRYlR5QmdFUjJnZUc4VWdLcXRlVnBYRFRZSnpZZm5vTE14ZkcxWlFadUwz?=
 =?utf-8?B?VkZ2b2JLTjBmdkkwRDNxdTh3QWp4YTExR0UyM25XRVhSL2tjQlk0dlRQQS9J?=
 =?utf-8?B?TzFpV2tycWFCSFpIMjUxSE1zRUN1S0U4bmlDUlBxTm9ZT1ZBak1EOFgvVjF4?=
 =?utf-8?Q?l13viGtOjim6+kLsVWkhEyAzl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e77786b9-4d6d-4a5d-b3ce-08dc7538fc93
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 23:44:39.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DACsyQqQV0osiL2ZhF8t98/rVSidSAeiB5/jVY8TeobBYs7kBr6UeXxqTe2DdzhX7rkfWy1wLRRhr7Cmt7bPqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7342
X-OriginatorOrg: intel.com



On 16/05/2024 11:38 am, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 11:31 +1200, Huang, Kai wrote:
>>
>>
>> On 16/05/2024 11:21 am, Edgecombe, Rick P wrote:
>>> On Thu, 2024-05-16 at 10:34 +1200, Huang, Kai wrote:
>>>>
>>>>
>>>> On 15/05/2024 12:59 pm, Rick Edgecombe wrote:
>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>
>>>>> Introduce a "gfn_shared_mask" field in the kvm_arch structure to record
>>>>> GPA
>>>>> shared bit and provide address conversion helpers for TDX shared bit of
>>>>> GPA.
>>>>>
>>>>> TDX designates a specific GPA bit as the shared bit, which can be either
>>>>> bit 51 or bit 47 based on configuration.
>>>>>
>>>>> This GPA shared bit indicates whether the corresponding physical page is
>>>>> shared (if shared bit set) or private (if shared bit cleared).
>>>>>
>>>>> - GPAs with shared bit set will be mapped by VMM into conventional EPT,
>>>>>        which is pointed by shared EPTP in TDVMCS, resides in host VMM
>>>>> memory
>>>>>        and is managed by VMM.
>>>>> - GPAs with shared bit cleared will be mapped by VMM firstly into a
>>>>>        mirrored EPT, which resides in host VMM memory. Changes of the
>>>>> mirrored
>>>>>        EPT are then propagated into a private EPT, which resides outside
>>>>> of
>>>>> host
>>>>>        VMM memory and is managed by TDX module.
>>>>>
>>>>> Add the "gfn_shared_mask" field to the kvm_arch structure for each VM
>>>>> with
>>>>> a default value of 0. It will be set to the position of the GPA shared
>>>>> bit
>>>>> in GFN through TD specific initialization code.
>>>>>
>>>>> Provide helpers to utilize the gfn_shared_mask to determine whether a
>>>>> GPA
>>>>> is shared or private, retrieve the GPA shared bit value, and
>>>>> insert/strip
>>>>> shared bit to/from a GPA.
>>>>
>>>> I am seriously thinking whether we should just abandon this whole
>>>> kvm_gfn_shared_mask() thing.
>>>>
>>>> We already have enough mechanisms around private memory and the mapping
>>>> of it:
>>>>
>>>> 1) Xarray to query whether a given GFN is private or shared;
>>>> 2) fault->is_private to indicate whether a faulting address is private
>>>> or shared;
>>>> 3) sp->is_private to indicate whether a "page table" is only for private
>>>> mapping;
>>>
>>> You mean drop the helpers, or the struct kvm member? I think we still need
>>> the
>>> shared bit position stored somewhere. memslots, Xarray, etc need to operate
>>> on
>>> the GFN without the shared it.
>>
>> The struct member, and the whole thing.  The shared bit is only included
>> in the faulting address, and we can strip that away upon
>> handle_ept_violation().
>>
>> One thing I can think of is we still need to append the shared bit to
>> the actual GFN when we setup the shared page table mapping.  For that I
>> am thinking whether we can do in TDX specific code.
>>
>> Anyway, I don't think the 'gfn_shared_mask' is necessarily good at this
>> stage.
> 
> Sorry, still not clear. We need to strip the bit away, so we need to know what
> bit it is. The proposal is to not remember it on struct kvm, so where do we get
> it?

The TDX specific code can get it when TDX guest is created.

> 
> Actually, we used to allow it to be selected (via GPAW), but now we could
> determine it based on EPT level and MAXPA. So we could possibly recalculate it
> in some helper...
> 
> But it seems you are suggesting to do away with the concept of knowing what the
> shared bit is.

What I am suggesting is essentially to replace this 
kvm_gfn_shared_mask() with some kvm_x86_ops callback (which can just 
return the shared bit), assuming the common code somehow still need it 
(e.g., setting up the SPTE for shared mapping, which must include the 
shared bit to the GPA).

The advantage of this we can get rid of the concept of 'gfn_shared_mask' 
in the MMU common code.  All GFNs referenced in the common code is the 
actual GFN (w/o the shared bit).

