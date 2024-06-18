Return-Path: <kvm+bounces-19904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A950590E03B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 01:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADAEF1C2099A
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787611849DA;
	Tue, 18 Jun 2024 23:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dcD3o3ao"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E1711CA9;
	Tue, 18 Jun 2024 23:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718754876; cv=fail; b=BhdAGcuptsI96PI8yF8GkYyHZsM3fo3WGfCwnbIkSFNk6Q5dCyTLn2LNFg022uGwEOp9ERHLE1k71nHNmGe2/WS3soh6dROsLFqBAEobHVfuj7PcFxnfXDya+LegEop8nXYx4Nyv6UjSTjSLF3CdtnX0FRmA79MsR6uivRox+rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718754876; c=relaxed/simple;
	bh=TgE65Dt9buKc4ZlbKY0ufneoH+eH/Hriw8RHpUW4VWA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uR8sDEI72HYYxo+mXmrUP+/aFDQL2hFGo2EvME2xU+VgKrOIV9lbi1ZC3kGC4EjOl0q+kB+BaAGq4uSSvQr3bCIWOy0iXRnre1JAWAL8CeSscxK/93lDAxFkfGTyVZLCAWYO3O3hswQPLjC5jN30rMWoxsXorzR2j3kMaFIPYl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dcD3o3ao; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718754875; x=1750290875;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TgE65Dt9buKc4ZlbKY0ufneoH+eH/Hriw8RHpUW4VWA=;
  b=dcD3o3aoVhj7cmZoDQ3FHDsWZEX28FJezX75YLDTg08ONAAIgmhWeEkV
   rXGqh3iwuYiDCPDw/w/D8Fe2hgOc68Cpj/9/jvWeIfVh5GoxVdiPyFgxu
   xWKWkiCOeYyrc/R73hW1e7OE00EbONjf2NFULCCglpg+AkwWrBAnp0c1Q
   2h/uUgzguM1JSxv2f4tRAB/AClHENHTgDWguLxCJ4Bf0WpdO/kWGOwd+q
   +rO6egpCjuBL7WjEWbLFwlLEZnLYdR5RsLAKBqiEt0Nv/cGEm1Qd79ycp
   FNTi/pd7wZEgRPLppabz2DFDqZHBqcTDutOvPD2mq8RxUZJxAbD0zQsbe
   w==;
X-CSE-ConnectionGUID: dMOixN0NT8uPo4ev5hrTdg==
X-CSE-MsgGUID: Gytdlj4tS8qdepMVkOP1Hw==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="19492716"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="19492716"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 16:54:35 -0700
X-CSE-ConnectionGUID: V/u+1l+rSiOcC3PTVzrYbQ==
X-CSE-MsgGUID: IZgg9GYWTm+Y40/W0vrQxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="46102849"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 16:54:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:54:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 16:54:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 16:54:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eE/4BvQnGZAzTSto7+fUJQVyOM8ZnEobimfrgKi8R/g7Ondux0viL8TUf8GnX3DCvLEVbrprzdhAYpZ2djoyZVqut+774OAXGM78g0gnTdbtAT1gOWKwJ6NtyeJ7XiowbBuIzVPnU1Uu5X3K1rcw1KGRpyyPxDO1tbmFvFwhXOWuI8p0wtkE2+E8xh05apVIddFWzsKfkyhFfF1gs3puDPTXabLpuoISu20K5rNJp4vPwYRc+drMLgKlOtb3xF6MXG0Mz6S7zAHI/mOgKVZsdi3pZJba20eHVfpbJO+lZWCDLK7lPbhEyWhy+nRHQrK7JfInstipHHtlHcL5cjgtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgE65Dt9buKc4ZlbKY0ufneoH+eH/Hriw8RHpUW4VWA=;
 b=eMOeyeJiIQroJ+9C/aq/NO/qf46BLitT6llfWxiF207Yr3vGvXmeAblauS4O1aAunzoODTL2AmpdKASePElXlKhVbrka1mXbXRvjCFFjIKmiHf+cQo9sOtoGAG5mLzXVAkLkz/gbkWqY1lkfN3j94AY09opaXA5mHR9Hc5kR4jz+xuYdwQjhcBqb7Pdln3b4O/1kEPehgCElxm+bzwAZaTdJzIA2UqmulFv0BEBZmQWV5H7zD8Kv5a8S5606AY2l3j/H/FwyQ0kL5hgIbQ2nrQ3bdtipwC0nwCBlzbDrTOCe0dmXt19wvPtvgsvSoE0qjiznOdKBjBEGhoDMpfkaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6788.namprd11.prod.outlook.com (2603:10b6:303:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 23:54:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 23:54:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 6/9] x86/virt/tdx: Start to track all global metadata in
 one structure
Thread-Topic: [PATCH 6/9] x86/virt/tdx: Start to track all global metadata in
 one structure
Thread-Index: AQHav+UKWkVfDAVRlkiXZ8tP8PK67rHNhAaAgACx34A=
Date: Tue, 18 Jun 2024 23:54:28 +0000
Message-ID: <ed0aee511389e7ce52b5b6d390d12ccbd346cfb4.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <9759a946d7861821bf45c6bc73c9f596235087bc.1718538552.git.kai.huang@intel.com>
	 <54324a46-a196-4e6e-a623-b4bf39cbb5a6@suse.com>
In-Reply-To: <54324a46-a196-4e6e-a623-b4bf39cbb5a6@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6788:EE_
x-ms-office365-filtering-correlation-id: 41c6d071-5104-4db1-e271-08dc8ff1fd8e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?RXFrSzlQNGJhZDZnRWNyMFBxUVcyb0NQMU4vMGk5TVhoT3hVckoyQUt1NjBF?=
 =?utf-8?B?WjZJUnlCU2Y2TkJLUDVuYjMrMjJtWG9iZlcwZDB0SC9YbDFtWTgzZVAxVGpm?=
 =?utf-8?B?Y0UzbjBzTGhYNlN5WDNVdEd3bWdoa0NHTW5yTCszMlcxbG14MVVrRk5QK2p2?=
 =?utf-8?B?eGpLNWR0YnlIc2VwbXlPKzNGaVpXdGZWUS9PdWRUYmxpRlZDdVBSb1hXV2Ri?=
 =?utf-8?B?NmlWcmhqdUZHSGFTMGFxWjhEdlJJaDZTRSt1d3Y5Zmt2OEliRWtVMVNmNU16?=
 =?utf-8?B?a3MrVENIWlh2Mjg1Rm1nRCs5YWxvSFUxSktXSzUvK09hUWtiNkJHQnJVWEVC?=
 =?utf-8?B?RTNTK082Rkg0RVdqZisvR21xMDFiNnRUdFVjREJRU2ovOTdvemNSME1kSWZN?=
 =?utf-8?B?ZWRNUzU1UlppQ2FueVc3K0FOZWtKRGxCUmFjL3NFTTVvTUFCRzZPUExNY0VT?=
 =?utf-8?B?Z0F4QTdoL1RLbUR2SUFGYVBETG5xMVJNVC9VM3ZxUmZKQ2JUQ0FpdithakFE?=
 =?utf-8?B?TmJ4N0VJQ0V2VGJjai9DNFcvMVpXZGRTRmhZMitBSVR1UGtTTi9mRWNIeTlK?=
 =?utf-8?B?V2VJMzU2OVFYRkJnZDFmeHQvNDErejFmaUZGcXRpMnlITkhuTEo0ZDRjRStv?=
 =?utf-8?B?TE53ZW9SaXdPK3NWeGtWQ2p1S1k2WFlXTm9PbVIranVKWk5leDNhdDJBRGtJ?=
 =?utf-8?B?Z1lDQTM0NERiY2ZlS0JQNXdnK0ZXaTdOUEc1V3o0M1JFS2RmaDNTdmJmd3B5?=
 =?utf-8?B?VHNIcjNMOGE1NkdzNzlYMTNsYjh0YVpwejJBaDBuQ21zaXRTdDNvNzlYdjVx?=
 =?utf-8?B?ZjBtMmxyeDdFL005T3g1VCtmWVpRVWZaN3IrMTc3djUwaUJEdllHUW5SR3la?=
 =?utf-8?B?a3lPMnlYVG1sZjVnWXdWR1pvZ2pNWk8weStMd2VXRWlOWTFMVDNnWVNXbzcv?=
 =?utf-8?B?MnNXblFCOHZCbHQ4WDV3VWVvMHhQOUdFS1dVbmJNNjhXVWkxRHYvVTZnMUxR?=
 =?utf-8?B?OGxuSjlqa2l4aTBKRm1DZGNnUC95MThLRFFZQ0JGby9jT09oQjFaUnVWU3dL?=
 =?utf-8?B?a0VLK1JpbHdsMHhvOXF6ak5Xam8yMXpQWjYzdTlLVjlxTlNWc3Z4dlBtalZH?=
 =?utf-8?B?WmpJeDAxN25MMFBqbUFKOVBHVTJqSmFQek5vVDA4QU5xRXhSdFlFT0w2Z1Vu?=
 =?utf-8?B?WHhvQXN2ZWlId1NGeEZkN2s1dGF5YnBRR1I3MlpaYTdYUDhuODZyOEJSU01S?=
 =?utf-8?B?aWhkbitkeExncHcvYU11ZDVneTJ0MXByWGhTRjdTRUhmVXp0RzQ0V0JQVFlh?=
 =?utf-8?B?Y3pQeDJKRUVjZTRSWUJ0bFVPM0lKVkt4dEdvWDBJdzdCTzJCcEtJNWtNUkJE?=
 =?utf-8?B?b1ZNZUZmaUk0TmMrUFBiR3M4OXJWYUlndFhMazJJMzhFRUZ4QWtLRzg2cTNY?=
 =?utf-8?B?aVpLMERkSmRzdFQzTlhnWkFzdnlBWCswYTZMM0Y3MjdnTHIwNW1MeURXQTVV?=
 =?utf-8?B?R1VkQWZmSVljWEZZOHRWcThDQ29uaEdKdUgzVVlRSFRpaWlCNjVFTUVOYXNp?=
 =?utf-8?B?VHh3WWdyUWxqUW5mN3lpTUFSRlFBNjRqYzgybVBwa1AvSVFVM3V0alZEN0k3?=
 =?utf-8?B?b2VUcTlHc1QwR1hRcVFZbEdNdUxGL0RZL3RrT0t5WnNkMGJHckpoUXhkRVBC?=
 =?utf-8?B?dUZGYnYxZ0p4VGNCVzAyczdWQVJCVmg2ZmhuMFhPc2lGRGh3a25QTVI5ODhF?=
 =?utf-8?B?aGFqaVZYbDhER2RjL1RvcG5XcWJMNnJxcHNuZndiMWVGc3JjM1BtekF0M2s3?=
 =?utf-8?Q?J6Ef2FYz7lbinBVXxuAPXXx5E4ISto1kSd5CU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDVjakEzUzloMStsYUZvT0pwVi9WbDNrbGx6SzArSzh4V0pBOHpvc252eTR1?=
 =?utf-8?B?aHM3NTh0dXN6a29NVk80K0hQUkhwbDhudXlaVXdsM09IcnpneTBhaXBDbnJ5?=
 =?utf-8?B?ZDdCT3A3TFRIZVRaWFNjMmRRRWg2Z3RBeVdLOXZCeG9ucmNyWFp4cTFGYW4y?=
 =?utf-8?B?RGZkQm1oRkNEYTVsRzlsMnY1dDQvZXd0WGpiR3d5V0xUUTRQMmJ1SnZRTGlU?=
 =?utf-8?B?MVNuZzNYWm1McStGTTBMbUZ5ekNkRWoxRnEyckJQUnJEVzEzY3lmRWlkVEZD?=
 =?utf-8?B?YkUzeTVibm93Q2lJSndUVnV4ZmpRVmpXOFNxYmhtMVIyZkQ5ZFd6elRKWVZV?=
 =?utf-8?B?MXZYR3ZoOFl2K0M0c0FPdCtoc3FOMVVEOXdGUW9CZGtaTXQ1Tkw3Wjc2TnpI?=
 =?utf-8?B?YlNWMTJrV2xZTkFmbGIzYWFrOTR2T3UyUWNvbGt4bmVkajFQbWhUdEE1d2dN?=
 =?utf-8?B?bnFHemFwTzdmODN0bTgxSTJPd2lVRmQ5MHBHbWxsWVp4VWFpSWhQeEdYVUVw?=
 =?utf-8?B?OHo4YkswSzRZRHpLNlhHWXl4b2ZaeUJ0bW94eUpocm9iZUhqSlc2VG8rOXZ2?=
 =?utf-8?B?MGFyV3pORmF6SXpkaFFBOXAxcHdVMGxmK2NPTHJCL3Ayc0YrY1RNQlJBaDR5?=
 =?utf-8?B?VjQyaGgrR1FqOHA0MVREdDVQNVQ5YWwwMUN3SjMwbURTbDJuYmNCYXgyc1Ix?=
 =?utf-8?B?bHhCRXgwWlZRblVkemtGQU4zM0J6UUNhci8rS3V0K1RDMFUveVhET3VHZ2Yy?=
 =?utf-8?B?Nzh0Vi9TVHdlL0FDUmd0WVdYL2k4QjFaenMydW0yOUhxRmdZZHNjanpINExj?=
 =?utf-8?B?TG5VdE94UXNhMzk0NzNRWUdQNFRBYVV4TEVJN2hPWXpWNU9nUHptWmNZcmZz?=
 =?utf-8?B?cUtEcm1yL3V3cDM0clBEL245YzNORnhQL29nL2VCMWg4SmJtZTZndzBuMjJR?=
 =?utf-8?B?OTFId2xuVDFvTUVaTmkyK3hZOVRNTTcxYjVUanBLMVowK0xFRWdNRlYzM1Zy?=
 =?utf-8?B?TFJCK1ZDYlJxclUyUzdQQUlhSHREMVAyMmM0T1RWVnBEellOYldObVB4bGZI?=
 =?utf-8?B?LzBpOW83NVd5VCtnV1dOM01Ib2xtRHZSOFZmVytDZXZKbWJ0czljQkRqNDJj?=
 =?utf-8?B?bmNyTFIvT2RGMitSUGkxcEtaV0ZvN1oxN3A2REJ3cGYwaDZUbjFZTTArdGdO?=
 =?utf-8?B?VW91YnQ3akc0WXBhTXVJZnljdU9DQjhmb3RSZXBucXh1N2paMlBJZVNKY3pX?=
 =?utf-8?B?VVpDY0lCdVJmYWt4L2F1SUM2N1QxMXVzUTdwMUg1MTcrR1pJUmhKaWZRVDRQ?=
 =?utf-8?B?eGxNQS93Sm5ETkoyeXp0d1VWQ1A5amtBQ2RzTnk0VVdnYnVJdXNmS25jOVRF?=
 =?utf-8?B?MDFtSzRTcElReVRiUXo5cXJMeTNGRU5HTkVvdW9KVUlkZDFEeFBuNFMzb2x1?=
 =?utf-8?B?M1dtaFFWYTJESzZJaVpKRXFOcEs4Rnh6UFhIdG81cE5oRG8yT3Nsdkp0L0Y5?=
 =?utf-8?B?ZVlIQ1Q1VlRyVkp3S2FSaGxLREZJbUpzVFJIeGpiVnZaRXFqajU1bk40ZWs0?=
 =?utf-8?B?eGJDQ0F4MC9uVWFJYkllQUFOQnNjTjQ4Y3N3OGVVeGUrQjN0VysxS2I4Y0Js?=
 =?utf-8?B?SVJIejBxTlVSQloxTTlHZUNYWXhLOXlVS3JTdnhIbDV4NjBVU3RnV0lJdXJu?=
 =?utf-8?B?TDBmSFVCbVBjVjgzcUluOXFMK1JXWDl5VWpSVytPMGdXY0pOckRMVlVHVk9P?=
 =?utf-8?B?SjIrbzNpSjlpSUNVMGZ1QWpXRWxDWjVMZjBvRUhTQTN6aXZ4N2ZabnZFdVlD?=
 =?utf-8?B?bVN2WEFyUGFUZUlSaXFtdkhFZ1pTVzU3RFNHY0dqQm1xbVpDc0pMS21UVlRo?=
 =?utf-8?B?NWg5ODQrSlFQYXRuQ05rTjB0M0pLOHA0UHF6dE9Db05BUkVBZzZaMUdwWGpD?=
 =?utf-8?B?Z1FIT3pGZElHNHpDeGRhZFlva0tqN1kxT0pGZk1HT1dqSUd3Z0FBUStmazVI?=
 =?utf-8?B?dHV4VjhKdVRLYmpGL2tiYXRTSjdNeWNPdUtFTGpWcTNUelRmdTFzOG1yWmt5?=
 =?utf-8?B?elcrdXhlc3o2eW5NczlBS3l6eHlrcTBMV0JnVGxLZmNnWXY3djE2V1U4cmMy?=
 =?utf-8?B?U2Q3RzllS01Kb2xqZGdha2w5Q3pzKzNTcDFJUzhBQVdWamhEclY3YTd2OVly?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC64D9E2C1FB0C4F9C4662881964A1EB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c6d071-5104-4db1-e271-08dc8ff1fd8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 23:54:28.3185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DC2vY9YjKWKLJyqMz6wz2qhxIpSDZjfLTJW6ldp3B1YsAfJzzrPnFmpG2xThm/Sewu9CCGrXNSAZMDptAxaZKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6788
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDE2OjE3ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNi4wNi4yNCDQsy4gMTU6MDEg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
VGhlIFREWCBtb2R1bGUgcHJvdmlkZXMgYSBzZXQgb2YgImdsb2JhbCBtZXRhZGF0YSBmaWVsZHMi
LiAgVGhleSByZXBvcnQNCj4gPiB0aGluZ3MgbGlrZSBURFggbW9kdWxlIHZlcnNpb24sIHN1cHBv
cnRlZCBmZWF0dXJlcywgYW5kIGZpZWxkcyByZWxhdGVkDQo+ID4gdG8gY3JlYXRlL3J1biBURFgg
Z3Vlc3RzIGFuZCBzbyBvbi4NCj4gPiANCj4gPiBDdXJyZW50bHkgdGhlIGtlcm5lbCBvbmx5IHJl
YWRzICJURCBNZW1vcnkgUmVnaW9uIiAoVERNUikgcmVsYXRlZCBmaWVsZHMNCj4gPiBmb3IgbW9k
dWxlIGluaXRpYWxpemF0aW9uLiAgVGhlcmUgYXJlIGltbWVkaWF0ZSBuZWVkcyB3aGljaCByZXF1
aXJlIHRoZQ0KPiA+IFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gdG8gcmVhZCBtb3JlIGdsb2Jh
bCBtZXRhZGF0YSBpbmNsdWRpbmcgbW9kdWxlDQo+ID4gdmVyc2lvbiwgc3VwcG9ydGVkIGZlYXR1
cmVzIGFuZCAiQ29udmVydGlibGUgTWVtb3J5IFJlZ2lvbnMiIChDTVJzKS4NCj4gPiANCj4gPiBB
bHNvLCBLVk0gd2lsbCBuZWVkIHRvIHJlYWQgbW9yZSBtZXRhZGF0YSBmaWVsZHMgdG8gc3VwcG9y
dCBiYXNlbGluZSBURFgNCj4gPiBndWVzdHMuICBJbiB0aGUgbG9uZ2VyIHRlcm0sIG90aGVyIFRE
WCBmZWF0dXJlcyBsaWtlIFREWCBDb25uZWN0ICh3aGljaA0KPiA+IHN1cHBvcnRzIGFzc2lnbmlu
ZyB0cnVzdGVkIElPIGRldmljZXMgdG8gVERYIGd1ZXN0KSBtYXkgYWxzbyByZXF1aXJlDQo+ID4g
b3RoZXIga2VybmVsIGNvbXBvbmVudHMgc3VjaCBhcyBwY2kvdnQtZCB0byBhY2Nlc3MgZ2xvYmFs
IG1ldGFkYXRhLg0KPiA+IA0KPiA+IFRvIG1lZXQgYWxsIHRob3NlIHJlcXVpcmVtZW50cywgdGhl
IGlkZWEgaXMgdGhlIFREWCBob3N0IGNvcmUta2VybmVsIHRvDQo+ID4gdG8gcHJvdmlkZSBhIGNl
bnRyYWxpemVkLCBjYW5vbmljYWwsIGFuZCByZWFkLW9ubHkgc3RydWN0dXJlIGZvciB0aGUNCj4g
PiBnbG9iYWwgbWV0YWRhdGEgdGhhdCBjb21lcyBvdXQgZnJvbSB0aGUgVERYIG1vZHVsZSBmb3Ig
YWxsIGtlcm5lbA0KPiA+IGNvbXBvbmVudHMgdG8gdXNlLg0KPiA+IA0KPiA+IEFzIHRoZSBmaXJz
dCBzdGVwLCBpbnRyb2R1Y2UgYSBuZXcgJ3N0cnVjdCB0ZHhfc3lzaW5mbycgdG8gdHJhY2sgYWxs
DQo+ID4gZ2xvYmFsIG1ldGFkYXRhIGZpZWxkcy4NCj4gPiANCj4gPiBURFggY2F0ZWdvcmllcyBn
bG9iYWwgbWV0YWRhdGEgZmllbGRzIGludG8gZGlmZmVyZW50ICJDbGFzcyJlcy4gIEUuZy4sDQo+
ID4gdGhlIGN1cnJlbnQgVERNUiByZWxhdGVkIGZpZWxkcyBhcmUgdW5kZXIgY2xhc3MgIlRETVIg
SW5mbyIuICBJbnN0ZWFkIG9mDQo+ID4gbWFraW5nICdzdHJ1Y3QgdGR4X3N5c2luZm8nIGEgcGxh
aW4gc3RydWN0dXJlIHRvIGNvbnRhaW4gYWxsIG1ldGFkYXRhDQo+ID4gZmllbGRzLCBvcmdhbml6
ZSB0aGVtIGluIHNtYWxsZXIgc3RydWN0dXJlcyBiYXNlZCBvbiB0aGUgIkNsYXNzIi4NCj4gPiAN
Cj4gPiBUaGlzIGFsbG93cyB0aG9zZSBtZXRhZGF0YSBmaWVsZHMgdG8gYmUgdXNlZCBpbiBmaW5l
ciBncmFudWxhcml0eSB0aHVzDQo+ID4gbWFrZXMgdGhlIGNvZGUgbW9yZSBjbGVhci4gIEUuZy4s
IHRoZSBjdXJyZW50IGNvbnN0cnVjdF90ZG1yKCkgY2FuIGp1c3QNCj4gPiB0YWtlIHRoZSBzdHJ1
Y3R1cmUgd2hpY2ggY29udGFpbnMgIlRETVIgSW5mbyIgbWV0YWRhdGEgZmllbGRzLg0KPiA+IA0K
PiA+IFN0YXJ0IHdpdGggbW92aW5nICdzdHJ1Y3QgdGR4X3RkbXJfc3lzaW5mbycgdG8gJ3N0cnVj
dCB0ZHhfc3lzaW5mbycsIGFuZA0KPiA+IHJlbmFtZSAnc3RydWN0IHRkeF90ZG1yX3N5c2luZm8n
IHRvICdzdHJ1Y3QgdGR4X3N5c2luZm9fdGRtcl9pbmZvJyB0bw0KPiA+IG1ha2UgaXQgY29uc2lz
dGVudCB3aXRoIHRoZSAiY2xhc3MgbmFtZSIuDQo+ID4gDQo+ID4gQWRkIGEgbmV3IGZ1bmN0aW9u
IGdldF90ZHhfc3lzaW5mbygpIGFzIHRoZSBwbGFjZSB0byByZWFkIGFsbCBtZXRhZGF0YQ0KPiA+
IGZpZWxkcywgYW5kIGNhbGwgaXQgYXQgdGhlIGJlZ2lubmluZyBvZiBpbml0X3RkeF9tb2R1bGUo
KS4gIE1vdmUgdGhlDQo+ID4gZXhpc3RpbmcgZ2V0X3RkeF90ZG1yX3N5c2luZm8oKSB0byBnZXRf
dGR4X3N5c2luZm8oKS4NCj4gPiANCj4gPiBOb3RlIHRoZXJlIGlzIGEgZnVuY3Rpb25hbCBjaGFu
Z2U6IGdldF90ZHhfdGRtcl9zeXNpbmZvKCkgaXMgbW92ZWQgZnJvbQ0KPiA+IGFmdGVyIGJ1aWxk
X3RkeF9tZW1saXN0KCkgdG8gYmVmb3JlIGl0LCBidXQgaXQgaXMgZmluZSB0byBkbyBzby4NCj4g
DQo+IFdoeT8gSSBkb24ndCBzZWUgYnVpbGRfdGR4X21lbWxpc3QoKSB1c2luZyBhbnkgdGRtciBk
YXRhLg0KDQpUaGlzIGlzIGEgcHJlcGFyYXRpb24gcGF0Y2ggdG8gdHJhY2sgbW9yZSBtZXRhZGF0
YSBmaWVsZHMgaW4gb25lICdzdHJ1Y3QNCnRkeF9zeXNpbmZvJy4gIEV2ZW50dWFsbHkgKGFzIG1l
bnRpb25lZCBpbiB0aGUgY2hhbmdlbG9nKSB0aGVyZSB3aWxsIGJlDQptb3JlIGZpZWxkcyBub3Qg
cmVsYXRlZCB0byBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uIGluIHRoYXQgc3RydWN0dXJlLiDC
oA0KSXQgbWFrZXMgbW9yZSBzZW5zZSB0byByZWFkIG1ldGFkYXRhIGZpcnN0LCBhbmQgdGhlbiB0
aGUgY29uc3VtZXJzIGNhbiB1c2UNCnRoZW0uDQoNCllvdSBhbHNvIG9ic2VydmVkIHRoYXQgYnVp
bGRfdGR4X21lbWxpc3QoKSBkb2Vzbid0IHVzZSBhbnkgdGRtciBkYXRhLCB0aHVzDQp0aGUgb3Jk
ZXIgZG9lc24ndCBtYXR0ZXIgZnJvbSBmdW5jdGlvbmFsaXR5J3MgcGVyc3BlY3RpdmUuDQoNClN3
aXRjaGluZyB0aGUgb3JkZXIgaXMgcGFydCBvZiAic3RhcnQgdG8gdHJhY2sgYWxsIGdsb2JhbCBt
ZXRhZGF0YSBpbiBvbmUNCnN0cnVjdHVyZSIuDQoNCj4gDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1i
eTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4gVGhpcyBwYXRjaCBzZW1h
bnRpY2FsbHkgZG9lcyAzIGluZGVwZW5kZW50IHRoaW5ncyA6DQo+IA0KPiAxLiBSZW5hbWVzIHRk
eF90ZG1yX3N5c2luZm8gdG8gdGR4X3N5c2luZm9fdGRtcl9pbmZvDQo+IDIuIEludHJvZHVjZXMg
dGR4X3N5c2luZm8gYW5kIHB1dHMgdGhlIGFmb3JlbWVudGlvbmVkIHN0cnVjdCBpbiBpdC4NCj4g
My4gTW92ZXMgZ2V0X3RkeF90ZG1yX3N5c2luZm8NCg0KV2hhdCdzIHdyb25nIG9mIGRvaW5nIHRo
ZW0gdG9nZXRoZXIsIGFzICJzdGFydCB0byB0cmFjayBhbGwgZ2xvYmFsDQptZXRhZGF0YSBpbiBv
bmUgc3RydWN0dXJlIj8NCg0KPiANCj4gPiAtLS0NCj4gPiAgIGFyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYyB8IDI5ICsrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQo+ID4gICBhcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmggfCAzMiArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LQ0KPiA+ICAgMiBmaWxlcyBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMo
LSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIv
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gaW5kZXggZmFkNDIwMTRjYTM3Li40Njgz
ODg0ZWZjYzYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+
ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTMyMCwxMSArMzIw
LDExIEBAIHN0YXRpYyBpbnQgc3RidWZfcmVhZF9zeXNtZF9tdWx0aShjb25zdCBzdHJ1Y3QgZmll
bGRfbWFwcGluZyAqZmllbGRzLA0KPiA+ICAgfQ0KPiA+ICAgDQo+ID4gICAjZGVmaW5lIFREX1NZ
U0lORk9fTUFQX1RETVJfSU5GTyhfZmllbGRfaWQsIF9tZW1iZXIpCVwNCj4gPiAtCVREX1NZU0lO
Rk9fTUFQKF9maWVsZF9pZCwgc3RydWN0IHRkeF90ZG1yX3N5c2luZm8sIF9tZW1iZXIpDQo+ID4g
KwlURF9TWVNJTkZPX01BUChfZmllbGRfaWQsIHN0cnVjdCB0ZHhfc3lzaW5mb190ZG1yX2luZm8s
IF9tZW1iZXIpDQo+ID4gICANCj4gPiAtc3RhdGljIGludCBnZXRfdGR4X3RkbXJfc3lzaW5mbyhz
dHJ1Y3QgdGR4X3RkbXJfc3lzaW5mbyAqdGRtcl9zeXNpbmZvKQ0KPiA+ICtzdGF0aWMgaW50IGdl
dF90ZHhfdGRtcl9zeXNpbmZvKHN0cnVjdCB0ZHhfc3lzaW5mb190ZG1yX2luZm8gKnRkbXJfc3lz
aW5mbykNCj4gPiAgIHsNCj4gPiAtCS8qIE1hcCBURF9TWVNJTkZPIGZpZWxkcyBpbnRvICdzdHJ1
Y3QgdGR4X3RkbXJfc3lzaW5mbyc6ICovDQo+ID4gKwkvKiBNYXAgVERfU1lTSU5GTyBmaWVsZHMg
aW50byAnc3RydWN0IHRkeF9zeXNpbmZvX3RkbXJfaW5mbyc6ICovDQo+ID4gICAJc3RhdGljIGNv
bnN0IHN0cnVjdCBmaWVsZF9tYXBwaW5nIGZpZWxkc1tdID0gew0KPiA+ICAgCQlURF9TWVNJTkZP
X01BUF9URE1SX0lORk8oTUFYX1RETVJTLAkJbWF4X3RkbXJzKSwNCj4gPiAgIAkJVERfU1lTSU5G
T19NQVBfVERNUl9JTkZPKE1BWF9SRVNFUlZFRF9QRVJfVERNUiwgbWF4X3Jlc2VydmVkX3Blcl90
ZG1yKSwNCj4gPiBAQCAtMzM3LDYgKzMzNywxMSBAQCBzdGF0aWMgaW50IGdldF90ZHhfdGRtcl9z
eXNpbmZvKHN0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvICp0ZG1yX3N5c2luZm8pDQo+ID4gICAJcmV0
dXJuIHN0YnVmX3JlYWRfc3lzbWRfbXVsdGkoZmllbGRzLCBBUlJBWV9TSVpFKGZpZWxkcyksIHRk
bXJfc3lzaW5mbyk7DQo+ID4gICB9DQo+ID4gICANCj4gPiArc3RhdGljIGludCBnZXRfdGR4X3N5
c2luZm8oc3RydWN0IHRkeF9zeXNpbmZvICpzeXNpbmZvKQ0KPiANCj4gV2hhdCdzIHRoZSBwb2lu
dCBvZiB0aGlzIGZ1bmN0aW9uLCBkaXJlY3RseSBjYWxsaW5nIA0KPiBnZXRfdGR4X3RkbXJfc3lz
aW5mbygmc3lzaW5mby0+dGRtcl9pbmZvKTsgaXNuJ3QgYW55IGxlc3Mgb2J2aW91cy4NCg0KVGhl
IHBhdGNoIHRpdGxlIHNheXMgInN0YXJ0IHRvIHRyYWNrIGFsbCBnbG9iYWwgbWV0YWRhdGEgaW4g
b25lDQpzdHJ1Y3R1cmUiLiAgJ3N0cnVjdCB0ZHhfc3lzaW5mJyBpcyB0aGF0IHN0cnVjdHVyZS4N
Cg0KPiANCj4gPiArew0KPiA+ICsJcmV0dXJuIGdldF90ZHhfdGRtcl9zeXNpbmZvKCZzeXNpbmZv
LT50ZG1yX2luZm8pOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICAgLyogQ2FsY3VsYXRlIHRoZSBhY3R1
YWwgVERNUiBzaXplICovDQo+ID4gICBzdGF0aWMgaW50IHRkbXJfc2l6ZV9zaW5nbGUodTE2IG1h
eF9yZXNlcnZlZF9wZXJfdGRtcikNCj4gPiAgIHsNCj4gDQo+IDxzbmlwPg0KDQo=

