Return-Path: <kvm+bounces-24065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C2F2950FCB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 00:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD9291F242A4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 22:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450721AB513;
	Tue, 13 Aug 2024 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eLZDL3mG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A01370;
	Tue, 13 Aug 2024 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588468; cv=fail; b=ZaQrM6AIowkZCrozyGr3cOCdA1apEtT2PrmiYGxZULbVfs17wwBZ8jgM+1MyCHoLDt8Bt/f6956I7WpqoPT7VylRwMfPIY1a2TcmOb5mL3SxtxZCpInB5Vl9eGuj83OrdOMew56eYh4jokmj8ZNjB+yfkp/PMiNwA+8WirLu1KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588468; c=relaxed/simple;
	bh=F27Iz/UaD4VYDziFqMUkHrbTQiy92RVEqsckPMz710Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fc2320TAvAY0yZ7dhYLPxJ1oQHF3QNXVVT5pSlKzzLMIPfsvxlTFa8cp4TQ6tPL9KsZ9WP/W4VV5/AOgjwRV+PrtvuipmngSrUEc6b+HhbWOJEJWV63Eh3IuNkI6B/kiBHDSKQRMVevgSfRdbqoPtP0j1chSZMfkrzcQa33macw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eLZDL3mG; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723588467; x=1755124467;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F27Iz/UaD4VYDziFqMUkHrbTQiy92RVEqsckPMz710Y=;
  b=eLZDL3mG91AlOtQk07X1l9LxPxrB403ou+2ZxiIuxzGtMH0yXafLrg2F
   IdQZzWf4Fn00OLeyxR+BwksFrd/1xYo9T8My9NTeu5wATXatmPbkTZS7U
   qM6cha6e99degkyVwuLaeDbDgc5V6K/uVVVbKNsBFkEo9a5Nnu9n33clK
   v1RMhXtlIyd+/zcwS/upyg7fxOpOz1VNI+aeH5EHxs+VIMi0m58GhUVu/
   pKH1BoKomSa+PH3L/6FB4kM5d5wy+7tqhpUaPx4LM8dnxu6GWuvAHCDkx
   Rsiv6Bn2dEzdrrLiHNIU5JKsCeF62ul202ub8tQyy6kXiztAybpOk/cVc
   Q==;
X-CSE-ConnectionGUID: Xe3XE48qSta5YZDh7GZtGg==
X-CSE-MsgGUID: KHh0un8cSdWqFarHnO0Nng==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32460632"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="32460632"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 15:34:26 -0700
X-CSE-ConnectionGUID: 52q4E/IzRHCUuLFVe9CIMQ==
X-CSE-MsgGUID: srWU+rO0QeKgLqH6wO1ZJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="96331014"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 15:34:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 15:34:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 15:34:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 15:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cISC4xiNj3RkGtteMBvPARxApjQjJte3iNkUe94ui8/36V43OIgq+oKAk1dEQYWWz++mVR0GCVuhx31lFQ272Wv+i5Y+zw39KJ1oTexdbAGbnEfD9Jchk1XbUjOqBRlNrZ2QHF+gUGxMqMqxs+gelehkbv7//iEFi3Fhu99A7YY0DxVKGFXrjjUV42rQllIVOnqUHOmhqNOHFq4UbD/48eUczuDB7FTKGhhuRxtsO4w7A0SVybD6u0C9HxGkEXJM1Lxpcth9vhVxvyOvi0MjrG4O1VRVxbQaa1lp52tXoD1p4+gBSiWPtTPYLhmB3j/TjWWDKC38z1lKOyiLdXlnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5iUsam2Ebc0uqR72F/yVbNftkRQzPVgRv5kgw758Q4=;
 b=GXvgxhzvHwA3ZQofIdAUhGS+Dj3ao43zPkZP+wP7JKy2eFa3lx5b7m7+kSp790pG6b3bcFg1h4S6/Y2YrEFJIKI/qJ91YBc8xq24YT52MmUTzR2qkVX7RLRWEoDPleE7XvQNjYwZGjmjPxEthnWyjUQZyL8KAveGbDWKQBdcjJGoTVDdnXGatdsI7VcjtCd9cenbziTDKuTDFKbinzXLDqsBwUx8wyGLext6hjBohuFj2S87gedNLWhIk2MAO6Fa7sNc6OpOxGXKQ2Tr3CUk9wl1iX+4VOb1Hbw7IZex5hdDNH+/dK42E7/zt006fnh/pxtfQ61Zeq66NyvP2i3+xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW5PR11MB5810.namprd11.prod.outlook.com (2603:10b6:303:192::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Tue, 13 Aug
 2024 22:34:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 22:34:21 +0000
Message-ID: <61b550ed-c5d1-44a6-89de-cfa04ddd59c8@intel.com>
Date: Wed, 14 Aug 2024 10:34:11 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/25] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Li,
 Xiaoyao" <Xiaoyao.Li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-6-rick.p.edgecombe@intel.com>
 <ZruKrWWDtB+E3kwr@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZruKrWWDtB+E3kwr@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::24) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW5PR11MB5810:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cbea64f-e234-43cc-b675-08dcbbe81363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?KzFJejJBYnJuam1ha05QeW11UmFab2FSU3lEWTdXSGxqYUk2ZlVucmJ1eVRn?=
 =?utf-8?B?UFc3OUNQRVdzMk5mWU5jUnBhbDN2eTVuQWJONEkzb01MbVZxUVVyeWVJUzNQ?=
 =?utf-8?B?b3dkNGVvcnBFQSs5c0psbXFZOXFVNWlmL25ZMWxFSVVCZzNjYjNkRnlKSDVC?=
 =?utf-8?B?T2YzUGZRNUxRdlNaRjdNVGQxZklrWEY3TWJkdUtPSUlOTWJyL2l2TDVjR21W?=
 =?utf-8?B?RG5LdHhsdUVIa2Q0Sko5MmJiUGxLOFBFT3QwcGRhQWJidFRoblRpd3VXaCsw?=
 =?utf-8?B?RkxzUExUOGNOdmJpbFBxd0hPdEp0RlAvNzY3NGtPZXBHMmdCTFVsdVRQb0Mx?=
 =?utf-8?B?akIxT2hIUmk4bUtmOFcza0NhKzN4TmdwS2pteEROcTNUcHFjeGtlWUVBd3p1?=
 =?utf-8?B?dndaVndydUtnb1ZDNTBoTEpFY3dFU3BJZlZ6V2h4T0FVcGJrYjdlNldPYjhE?=
 =?utf-8?B?cHhVVHRnRkNsMDlldHNHTzd6VXY3aEZSTmloYUQ0OXpkQUJVcExUQUJOdWRw?=
 =?utf-8?B?V0Z0UVhpdlcyWWFiR1hPYUM0cW81eThxME5rTjhzb0d2NHEvdG1hazR6bk9i?=
 =?utf-8?B?c1dxQW01RUhuOUU3Z01WbnBvVkJJYmNkL2w4TGpnYllDQTYwOHB4SmJaSWFS?=
 =?utf-8?B?dUcwV1JQN1FRUzB6NHFmeGJYVGRnUm5IUDMra2JOWFR6clJiUDBmbjFmdjBh?=
 =?utf-8?B?NXVNTFhCSFpWelpoc2VsMzNLZjkwQkVFYU44di95RGNXVS9qMFJXYmpzN1ZX?=
 =?utf-8?B?REdRNTcyQ3BVZVJ6VjhWQzFDcElIM28yZHNWMW84bldyc01SSitCTnZBamdp?=
 =?utf-8?B?ZTVGL3ljdmg4Ny84dm8yeU40MHJLMVltWm1kK3Iwdm1WS05mY3J0ZlpmSHZX?=
 =?utf-8?B?NzcvK0oxYU5GMllIQ3Z4OEJlajFYTUYyd0FNbFIxb2JKKy9tTG9oZTEyRjRx?=
 =?utf-8?B?NTRCS0E1c0IxelllbEJ1TGdCd1FSM3JDbmJTb0F6NjNHUVMvUUFHV3RhVTJh?=
 =?utf-8?B?a0pwTHJkOGpvYW96cHQ3dzVSbGgveERnR3FmUStBSXovK0JVZURBZHMrZS96?=
 =?utf-8?B?Z2hNZVpEYThRWGVZV01GdGJkWXk1NmErbDJwRHBUVDVSTUZ0Ly9nUUJPdXQw?=
 =?utf-8?B?ZExleXNFL0dNMEExOFpwZThBeHpJcVNwWTEvbUkrek1HM0M0U0R1b2V6NHhL?=
 =?utf-8?B?dFdlMmt4dlRpa2UwdVU1Z2s1S2pGdFBlcTE0cHBkd2NqamJCcDJ0a20vcnla?=
 =?utf-8?B?Z1VRTVlHRUFSamllOTFwVmFTTDhPVmMvYmE3dFVaMTBkdXZHSndqeldyMGky?=
 =?utf-8?B?Z3R6cDBVUlduOXlCVE5LNUV2citpREc2RklJcGJzS3JXQUR1alBIRElDdDhV?=
 =?utf-8?B?MlNSbEZmY2k1alAxT1VZaiszKzRWMWcxbmlwblhsaE1Cbmp0dkpuWUx4YTdw?=
 =?utf-8?B?Tm8vdUNOcFlpUXV4K1NGeHRwUlhDWTBwVnpUU2tEUVJVZ0JsOG4vSnRjZWZr?=
 =?utf-8?B?RzFSOVBlNExOSGZZV0lYcEJRQzVGQ3Z1a1RCRG9WcG9WTE56ekNSTHJzSk9y?=
 =?utf-8?B?Vzg5OVNKOTAwMll3UHZ0dXFpUlprM0hkVHovcnNZMlYrS284TlU0L2FKdzFs?=
 =?utf-8?B?MXNvdXJVSE9uTjErS2NLNHJUTndlbGZzWjJTaGxKdjhZN2NnOW5tajNSTE9R?=
 =?utf-8?B?ZzF3UlhhVXFUQWg5bjFoZzJ6dHFoeG4zSkpxU25xOE04cHVPMnVCQ213a3A4?=
 =?utf-8?B?WU5mUlo4RkZDN2pnVksyYTVaVVB3TE9ySWhjeURzekZ3Sjlsd2lJQ09jU3Nz?=
 =?utf-8?B?KzV3M0VMVEZubXU2MTk5QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXpvNmwxOUI5QnJNMm1jd1hiWDRjcEttOVlLUStDeTNuT0dOcG52c0I0NzlV?=
 =?utf-8?B?ODNCZXkvbzAyWW1ndEIwejNvYmpROTJkYVpVaVU1aXpOVE5hSnNIazAybmlz?=
 =?utf-8?B?NStGUWg0aE5CNGF3c052OXF2VCtnM3hjcCtzUU5lOHhoK3plMXFpWUowZW9E?=
 =?utf-8?B?MG9qWjQxcXZXQncwWXBoNGlqak1tTll0OWFydDJKMGF4aVMrbktabW5EM3RT?=
 =?utf-8?B?Rk5yeSt2RVVpMDU1ZmdPeHZCbVZiTUdzb1A5eXFVd2hiN2lLbE51QlJmWW5U?=
 =?utf-8?B?blNJVXNCUDVxQ2lsZ1JmaGNGaFN0ckZvWWRoaFMxOTQ3STRqUityZzcxNm95?=
 =?utf-8?B?THRmSm9XOVhwbjdDRnpEMHM0RHMwZGFsSk15YlIrcU9KUmR3enlDam5EV0tH?=
 =?utf-8?B?Vy83UnlpOVlVUnIvNGhFNkxuLzNLMjhoTEtJUElMMytJRGdNcWlPOU5vYnk0?=
 =?utf-8?B?cHlxM0I2b01ZeUlFTHJHSHFRdjBwSVhsZWFUNFlleEtwdk9ISVpscTg5N3Va?=
 =?utf-8?B?dThFcDcvRzN3TTNjVENYTUtiNC9yUmVkMStrQURWbGd0MzFLV2lUaFgwa3lW?=
 =?utf-8?B?S3BSbDZtT3lEY3dsSms1c3JyckdUQUZ6K3gzMFJzZTMxUGlvRWdCbWhBbHhN?=
 =?utf-8?B?L0NYM2FtaUFwcy9VMHpIbTNtMWhIZmFJdnBJblkyM2dQd1VqRTBVOFFJaXNl?=
 =?utf-8?B?Y1hnN01oeHFWRE0xMTdna1JVSWNKTU1hRzJWV2xYZ3htQ2dEWEltMkxRRm81?=
 =?utf-8?B?UjBiblppYTJwWndSQ1NwRjMzb3M0ZUNUWGk0dFdublNJMDZSeVhZbmVnanM3?=
 =?utf-8?B?K2oxTlN5Rk9SODhxTURRZitnRm9mNFJwVnVMa3Z6Y3VHMzhPS1VuVnZ5dm1I?=
 =?utf-8?B?RVJVakcvU05aSVJWNktxMVI2dFcvQzg2U2l5NElycXV4cElUR0dTb1VaN05t?=
 =?utf-8?B?ckEvczVVdDlSckNFM1RvVnpVMXFQbmxZNzdnaDBHRnJsbjRUb1Jja3czekRw?=
 =?utf-8?B?ZWIvc1lCelJUT3NiV09MZFJEUW1ab2FCc1BRVTlPcEx5QU5FM1dyT3RvY01s?=
 =?utf-8?B?L1FxS01jVmw1Y1JpMnNvV09XVnZkb29USnByQXI0aXJac0JhdWI0RUJMN05i?=
 =?utf-8?B?YU5JZkp0TWlWVytyZW8xd1JuTlJKYlJoN053WENaMGRoZ0hGODh2bUovK1k1?=
 =?utf-8?B?eTF1dUp3d3VPRnVvcHV4NmZQTGZzWTlPc1BZS2lXcExkNVNYY1VIZlI5cDJZ?=
 =?utf-8?B?SWJlVHk0aXl2NEV4SHNyY1YyTVdqbCtQSUY2NGtGWk5CaTFvYzAyQVVpc292?=
 =?utf-8?B?eEVmbEkyZUk0UUxxOEtncXlkTGRtVjlwY0hRZzJ5cFBWdEN6ZVZjNjVsdTR5?=
 =?utf-8?B?VjRHS0tFZTlvOVA3ZG5ldzVJQ0dPS3F0bHpvZi9FTHU2WFUyWGhNd1lDanEr?=
 =?utf-8?B?SmM5STU2MmllODNwdmtKWlJpUllwZE83M29PQjBkRytNTTdSYkE0Mk9VYm5l?=
 =?utf-8?B?Zk40NEcwSzZxek4xU3pVSEUxZ29HOFlZdENJdXY0cUthNE4vR1NWVGlKQk9z?=
 =?utf-8?B?aUZTR0ZkRVhlMHZsMFNTMERYUHc5RHZCOFE3UjFWVlllcnZKM1Bsc3VZS2xJ?=
 =?utf-8?B?ZUo0cVRUUTZYV0hPWnp6eHdOOElXRXhEaEhVemRPMjdsQjhMb0ZDYVVQeWww?=
 =?utf-8?B?Z0FXQ2NmS0tidWUxRCttaEZoOHlFTTRGMStBQ1pWR1BhbWxjSTZEVXB1OEdm?=
 =?utf-8?B?Y01vSERqTXdVbjd1ZzNPcm5jTDQrN0pqbUxzdDMxQkJITHZBNE1TalRXaTRz?=
 =?utf-8?B?Q2hXU3F2cGs0a0dwQURzc1hic293N1lleHFrQUV2YXhwampkWU1XeXRhSkx3?=
 =?utf-8?B?ZnpTY2ppT1M4R3dyZ0wvN1pvWHpadFFQT1BYVHdoODR5dGYwVjVKVDR5cngw?=
 =?utf-8?B?NVArQll3Y0RrRVJrano0Wmd1S1NLSGFZK0FXN25rYk5sYmtWbVhBckVaMERQ?=
 =?utf-8?B?Sld1Ukczb1RsbXFrRkp4ZlhnZnhWY0YyK1J0b2dtZjdCL3FyejJRd1FZR2cw?=
 =?utf-8?B?cW5lUkUwbzhlMXliZ3NBZS94bXE1Q29qbzNFaVdXMWE0ZnZ2VUx6S0k1Z3Jk?=
 =?utf-8?Q?DU8aeeUAfzfZbks3u0Er/vR57?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbea64f-e234-43cc-b675-08dcbbe81363
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 22:34:21.3659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWYgHWDuOcth6hrgvrnLetRaoGzGO0M564JRS7FDC9CmbCodPZ9sBkjqyabxY+ctko8X/QwPClDvXcDj3Rx0ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5810
X-OriginatorOrg: intel.com


>> +#define pr_tdx_error(__fn, __err)	\
>> +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
>> +
>> +#define pr_tdx_error_N(__fn, __err, __fmt, ...)		\
>> +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx, " __fmt, #__fn, __err,  __VA_ARGS__)
> 
> Stringify in the inner macro results in expansion of __fn.  It means value
> itself, not symbolic string.  Stringify should be in the outer macro.
> "SEAMCALL 7 failed" vs "SEAMCALL TDH_MEM_RANGE_BLOCK failed"
> 
> #define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)           \
>          pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
> 
> #define pr_tdx_error_N(__fn, __err, __fmt, ...)         \
>          __pr_tdx_error_N(#__fn, __err, __fmt, __VA_ARGS__)
> 
> #define pr_tdx_error_1(__fn, __err, __rcx)              \
>          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
> 
> #define pr_tdx_error_2(__fn, __err, __rcx, __rdx)       \
>          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
> 
> #define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8) \
>          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
> 

You are right.  Thanks for catching this!

The above code looks good to me, except we don't need pr_tdx_error_N() 
anymore.

I think we can just replace the old pr_tdx_error_N() with your 
__pr_tdx_error_N().

