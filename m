Return-Path: <kvm+bounces-17447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A09818C6A4D
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 136A42813EF
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 16:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C13156641;
	Wed, 15 May 2024 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ko6oTB28"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A8913EFE5;
	Wed, 15 May 2024 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715789563; cv=fail; b=kAViCMHfmH432QC8WzzTpMekxykEr8a5jUDyGlt+dn/BjAWxRP5cj74OoA6zpObrGXj27kFPPlQwqixNWGV7WSzAz0XOUJrw9wk6m/Yu3rt7H+tFUUwUgISjElscVJkmnohQicZid9TaJcqFjM00PzkkL3iGELMoOdWvjVsfZWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715789563; c=relaxed/simple;
	bh=AY3R+kcT6DZekPMLCmgxUeyagDk0W9jgbrfFxeKfQMY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HYo5Ssbij+Hw2YchJoxWfUTZxgH0p68dgue/TSvJ2FWFo5wlie6SU3Yb2IL4hhPqsmilOEz67S8M4og4KXmJk/i8jnbV+RudPeMaBbqTJc8uAJTcyMlKTPyvfu0nvQ+pNsPUuFMHWwEhjhogcHOD6D0uV1FLY7qGHJkNpxSUQEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ko6oTB28; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715789561; x=1747325561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AY3R+kcT6DZekPMLCmgxUeyagDk0W9jgbrfFxeKfQMY=;
  b=ko6oTB28tLOMfaWvdjQOgBwbjYPfZY9vHxK6YxvvLsAC/USgfERuBOfy
   mwnEiRauBxprfxjW1ZBpDIRIIhp7tNASNTVbDU232bgb8HsBn6f0U00bU
   QazHJy7GU5tOhH715zTq5cfmLFELuTDW4MrR4yQZHV4dolVm6wHdafHED
   ZLUKTUcauIP4kf6bxQa6ErZCQoMr0h8aHStrP3e1BuLrOSf3c+oxn/BXm
   yEbe1o+irEuQp4P7hEx3pZJZXOxTNEV3GNdX6DXFUFqtnmLEGw/ARCpsU
   3dBP8Mng0aNSacrIbcwDiiEtzrqw8FKcTmLfSd1WReHgd4iz62c4glR97
   w==;
X-CSE-ConnectionGUID: tbb8OsyXRBe6Xi/3bE8Giw==
X-CSE-MsgGUID: EEOWr2RARpqpra14xUDXmQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11724033"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11724033"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 09:12:41 -0700
X-CSE-ConnectionGUID: G5SWdTXUTUuEY+ML0gnOog==
X-CSE-MsgGUID: lQ9mUc9NQm6WbV4k2dE41g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35654157"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 09:12:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 09:12:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 09:12:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 09:12:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaXqxKD/w2eM3DEmNZ+mYultwo8MswZHnakkAZyF940vrRdlm1/nVKJtC5cnE2yauPBwlIRoppOkh69HuKisl6RNa1of4dd8JmHgrNW/VReVQmeYJYorCQS+4k/+b44TDj21QonsXUhySIUq+ONoR8dUzMnzkljl63nt05Bo+PfWNlukcvMAGgVBZSKrcfVsaC1UY3bb4yCybCSInd4Vr0xDPU95l+Icf4wtuUB+2FEMBzpXaMNROPg7/qAJMHw6q6nrdhDFWjm0xxx6nPD/uKNlz/WZ9lg7m3VE+Bv4ybqtLRee4g6+RikUwRXvcsXK6yIKjUutJFLCB1iQDoiYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AY3R+kcT6DZekPMLCmgxUeyagDk0W9jgbrfFxeKfQMY=;
 b=W2QQikJ52vW+fto/WTt0IXqY/jMQXaCtutZLZBfPSTtS92NLIf2cVEaMPmi22cStrzlW7SJuhw/TdE3ETzAL3n0Za91t7KVoHCxbB6rhI9FG4SQ1HRGvWWLmFdWNPqV19y+mjag3gshuvgTQ6tUVI6tDZioksAdehP0lFgJ89pCrLLQSWUNkOFiV4Ij5gqZfBPcKLsju6Om+Bysl+cMLc6AHKmCl3OEDH26f/l3tuJXCsYy1QfktTU0WCGfUtu4vHSmGsjqk7L7Wx3q9SaqdtCRzo4jcGEvGE6qjG/PVx1OkS7/1BamRhz98rTkSyHieZUnJVBtpstigrCkaqZjv/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 15 May
 2024 16:12:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 16:12:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAAELYCAAAHkgIAAAZ0AgAAC8IA=
Date: Wed, 15 May 2024 16:12:37 +0000
Message-ID: <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
	 <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
	 <ZkTcbPowDSLVgGft@google.com>
In-Reply-To: <ZkTcbPowDSLVgGft@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8027:EE_
x-ms-office365-filtering-correlation-id: 98187a49-3dda-422d-6b18-08dc74f9d6ac
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UkFmeG1SWUQ4bXBjZXY0RzVRNG8rMm9DK285UnNNTFpMYzc5aVRDV3Ntdnpt?=
 =?utf-8?B?Yms4YUwra0pqdnl3dzQ2UklKTWtYakhmNjhvVlEzZVI1ZXZRTG9UV0ZIWDB2?=
 =?utf-8?B?eUgycGRiZ1pLUG83S0s5THBqL0RZaXVqRWVFUklsQ2xUTVNaR0s3aE5wRnUy?=
 =?utf-8?B?QzM1WTMxZG5rUEpHNEVPb2xrVHpPRVI5Rk9Cd1M4c0lkQjBKUnlNZU5Fd2tS?=
 =?utf-8?B?RUQ2STlnUWhic0xIME4xTTB1YWRJcS9teXhVMHZlSlZ6M1IwcDV2ek9mcm84?=
 =?utf-8?B?WGVQVXoxNlo1QllVY1k1NTU5OVZEbXVCSEU2czUwVGtNV2lxNmVVakRteWVm?=
 =?utf-8?B?a1d0enAyZXdkVXNKZ044L2tSZkM1VW1Jd3dUeFUrN2RROTBBN3RYYzhiYUgy?=
 =?utf-8?B?SUorSE1wVjc0S0pzcitET2IyaG1hS2NUcUxmbTNFZXBlK0FvUHVtMFprQms2?=
 =?utf-8?B?L285bDhsNTBnS0NhU245cUZpUzRWd3VvNHJKZUNNKzZXNHdpdDZESC81eFlW?=
 =?utf-8?B?dTU3R21jZnRwMklsV015SlErL0c5enM1dTZnRkFiM08rMHJGWGE2NXhCdjlG?=
 =?utf-8?B?RG4wcUMxL2hDN3o3bHl6eEhwSkRkbEF2U3I2M2N3NkVRdTFFd3AyYmdvMTdW?=
 =?utf-8?B?Z0dySFdhcDZEMy80Vkpxekx3NVptYzc2aGJlNFFrM25GMTEzUm5HVjZUTFVP?=
 =?utf-8?B?QjJ0TUEvYmJxN0hnODl2dkZMbk00Z3JBSWdvcDQ1TVBQTXBNbW5OTWNnOEw1?=
 =?utf-8?B?K3hoUjV1dm9oKzdiNGZLMndCaVlvTVJiZmRTYUpjZXNFMUliSUdXb3N6aHZh?=
 =?utf-8?B?VEVoOVdjdnM5SG1GRk9IczI1VUtmOTlCdTN5N3FPTGRYcjFIUVp0dW9NdlN6?=
 =?utf-8?B?eFNvd0FQUzhSdzQxY0pYUEQ4bkhPcDBUQnRuZm1ONGhtak1MK3U3MmFNUmFE?=
 =?utf-8?B?RHY1cmJNUFVVVmRiRkM5ZWExL0pqUUtYejlXcWlaZXpaOUpqT1lPTG5qQ05Z?=
 =?utf-8?B?Tmo3UjNVeE0wdC9oNXNmdWhFTFVOY3hNeEdzRjgvWkdzRE41b0xIcGRQRDg4?=
 =?utf-8?B?K09SSmJ6aHVjOFhIdUc5TXBpZk5lV0JhM2dwOWFtdnFzdG01b3lYYU1PNURN?=
 =?utf-8?B?Y2ZhMUM3R2s3THNGb0grRnBjZ1pBekJOM3QzMW9Lemw0SVlJZnd5OEZhU1Fy?=
 =?utf-8?B?eEZwcW1la0lQODA1U01hY2FHZE9ibHo0a3lVV2JuYTZBRE02U2QvSTQzakxm?=
 =?utf-8?B?djJWN005MnB2UXBwSzErbVRicEtxc3lKME42Y01mcHdwVTVTSVQwbktQdkdT?=
 =?utf-8?B?N0lGN1ZSK1NkdDg2bitlRzB2bXBiYktOUTJUeG1HNkhBVVUxWklFSVI0WFpT?=
 =?utf-8?B?elBQZXh2eWhyMkFTZGhCRlhsNHZYWUJaNERvWDB3SnNPajlodzdqZVlmS2o2?=
 =?utf-8?B?NnlsdUFkRlZ5V0srL2ZyUlpDZ0ZXTnFyY09UNW84Y2ZDNUxmM1lFVC80QS9r?=
 =?utf-8?B?c2g4SG1CUk16WjVWRXd4NzZyY2pzWjJvbVk0Zys4VVRCbEhzaGZuWUNiMHJ6?=
 =?utf-8?B?c0QyOTU1ZkMwTUxWWkJ4UGw2dlpPMFgxTWlGalZSUmZxMFd5dWVET3MxUGpk?=
 =?utf-8?B?c2dWYUZFSCsyNjduMjNUaFBOeHB2RjNTblp2QzFMWnBiUkVDTUpQOHgxRVNr?=
 =?utf-8?B?djRTQ0VwSkJlbS9nOUN1UUxtT2VZcXZVSzlyWE1JbGFjSCs5UlNwZExERFc0?=
 =?utf-8?B?b0xpQlZTRmUzUFRZam9RNlVxY1hQNkVaZ1YxUC9iUlU1akpPSmxWMTZDSnNR?=
 =?utf-8?B?bEFJNEFlNVh2Vy9ld2Nwdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clI3dnJYVzJ4VW1mbU9RanBnK1R0VXVRUVZxZmJBRHZWU2FVN1NzeTB6ZEhW?=
 =?utf-8?B?SzV4MEFGK2I4a2c3ZktYeS9WbkJvZHNyOWhiT3dIVlg2RUdEZHIxaERzWU5X?=
 =?utf-8?B?UlBzSlJoOHFieXZNWE0xMjBPT1c1SHVzODNVUnJvRHZYck95OUUxSVZYbkly?=
 =?utf-8?B?N01kNDkxSmdiaklBbTZuVHRhU2d6Y1dnMnE5YU05NEp2V2JEL3ltcjZBWTlB?=
 =?utf-8?B?eS8zQ1FPamwyVFFzdGFmT0dXV28vMDNuZUhmSnhscDkrWnBSNVZXWU80OFJ1?=
 =?utf-8?B?NFlzbnZLOFQrMmNtT2k2azZvc29YWmJiaEVOMmV3a2ZzRVRlUHVBbUNYRjZk?=
 =?utf-8?B?N3gwWE03dEZON3ZMVXZ3NTJOU1pDNk51aTZjUFNNWXJCc0ZMTDR3VDNmNS9E?=
 =?utf-8?B?NzFuRzV5L002eUlwdS9paWJGWHpnMEZXYVF4Zjd1SDJmZERoRDl6dE9nNU1x?=
 =?utf-8?B?QTdtZUVoNjM1dDlydGJab2dUdTlXMk92UFlqTW54bTdZcHFqRG90WUpRaS93?=
 =?utf-8?B?Skoxa1JYL2c3MDB3NndHZFJSLzVnVmJhdGxkSUlsQnhlSGJ0aHdyVWJ1OE1U?=
 =?utf-8?B?YnZVdFN5bGFzMVpORFdFa2JoYlNCTTJXcjZvY2psRThlVGRPRFM2R2xpdVRp?=
 =?utf-8?B?eTA4R1dQSlhQWG9XSkhZZzBoaHQ0QXh5Y1FMZ0JtL2JUanVjZ2YrcWYrTzBv?=
 =?utf-8?B?cFUwc2pwQUxKblJZSzZSQ3BJWW5KNG1uYSsxTlp1Tmh2RVhIZkY2bzEvRW81?=
 =?utf-8?B?d2RGQkpjdmpnRWFkelpkaGNuY3BPeURIbXpsU0xlcTVBZW93WXlvNVF0QXND?=
 =?utf-8?B?MWlHUXJZQUFXdFlITHBoczdSVjRIQ2FrbjFzQzlycFlHcFNZK0tVV0pkMHg3?=
 =?utf-8?B?M0x4dkU4RTRDOWtTT0dxalltQlJ5WENtOUFhUGdyajRTSVdXTGM0bnQySWtV?=
 =?utf-8?B?Y3RoelMremJLMmlFVmxuTmhLZlpxaTF0c3RRQU9xalJaQkppRE5GeFVabDZE?=
 =?utf-8?B?Tk1zVHArVW9nRU9EYVV5WENHRjVpYU1MSFhtUWl2a29hYWhtakRpZHJPaWVr?=
 =?utf-8?B?bnptUkZINE11RWU1MVdiNzBZQkdKbGZIbzhDYU82bjRKRmhPSTIvUTNDKy9Y?=
 =?utf-8?B?RnFJaEtVak8vTlk0ZWVGT010TG9WRlRNN0xheFZRSkdwTGxXM1ZyVmF1TkVn?=
 =?utf-8?B?eWZGSy82Q2FURHl6clJQc2pwQ0tMek1tejVRam1pZjNMMU54YTdEd0piWXhi?=
 =?utf-8?B?bEhrWUFrOGtQTzBVTHB5ZnAyeFZtR3V2RGhESjVVWDRsVXVZM05UbmQ2SWp0?=
 =?utf-8?B?V0JhbGU1Wm1pbWRVRUs0c3BjSGFiQ0N5ZzBrTWRpaGxTSTZpcnR3Ulp1MlJz?=
 =?utf-8?B?Tk11MzBVZkVLVDRaeUxtZnZVeWJQY1ZXSkpFMjFDdFVPcGJVOGFXcnpNaW1m?=
 =?utf-8?B?NERTdE9SZW1Ia3YxbjFUa1J0UjBNRHdxMTZwYlppbXdUSWpQSWhaRTYvMVV3?=
 =?utf-8?B?V0R2ZHN3Q3k3dlF6MzdUc2c2YVV5RXFyRC9mUGdBbUJGa1p2R25Zb1I1UGxN?=
 =?utf-8?B?VkJvc1Jja3A1ZWlxSjJMdEl4ZkVEWDFlREliMUYwRnp3dkxNRTdVbFRySFM3?=
 =?utf-8?B?K3pHeEdubTM0UjR5R3dUaHFOdng0Zmd6RmJ0Z2k1VGJXUnh5SkU3WVhISHJQ?=
 =?utf-8?B?MXZaZTFlY3dMWEZ2QlVKMXVjV3l6TnJBeTl5S0VUdEF5aVhuaGoyLzJ1ODBl?=
 =?utf-8?B?Wk42bkU2amkyQysrV1FtTVpBekVrbDVjUVpXSW52WHZZTkNTdW9vamgxSmZH?=
 =?utf-8?B?YzRYM3V6K2ZibmtnQWUrSmdyYW90bXRMVVU2SzdaRzJlWjFxRC9UVmFvbjhU?=
 =?utf-8?B?ekRzakwwSFFuZlNZZExPMDlpVnFVaWVRVFA1ZUpYRTByWjJ1RHZ1L055THlq?=
 =?utf-8?B?MnBzTEJTVDhhSkR4Qy9UdWVONkYzTnRQOWlPeWphMHRsbVc1bVEzWkpYZEJ5?=
 =?utf-8?B?d3RDTkFsOHFDS2V0OE1qcEFlWnFyS09HTTFnREhiVnQ2Umgzd24wWnBBcy92?=
 =?utf-8?B?SERoMkpmV1FPa3d1OEROdlMycWJUQTNXSElNNnlGTm41VGZRWUEwRVVGTUlJ?=
 =?utf-8?B?Vk1kV0F1Uitaa3pEb2d3Z1o2ZVlKSkE0U3lLNDhiakhiNFBKMEh1UnNTUWw1?=
 =?utf-8?Q?YSs1rXNAp9MRiYenFA6P+rs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00C122AEF3883244B39DD71035BB3446@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98187a49-3dda-422d-6b18-08dc74f9d6ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 16:12:37.7007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IQctUBEeu8AKBjCWuUrltb9bTsqYEpKgx121xEM2pEhW6QyUfkqpp3YLgWHE4DZuKDrCpt1urAjHmLHAYI//mtX9XKACZMczUy14dmYMlmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDA5OjAyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE9yIG1vc3Qgc3BlY2lmaWNhbGx5LCB3ZSBvbmx5IG5lZWQgdGhpcyB6YXBwaW5n
IGlmIHdlICp0cnkqIHRvIGhhdmUNCj4gPiBjb25zaXN0ZW50DQo+ID4gY2FjaGUgYXR0cmlidXRl
cyBiZXR3ZWVuIHByaXZhdGUgYW5kIHNoYXJlZC4gSW4gdGhlIG5vbi1jb2hlcmVudCBETUEgY2Fz
ZSB3ZQ0KPiA+IGNhbid0IGhhdmUgdGhlbSBiZSBjb25zaXN0ZW50IGJlY2F1c2UgVERYIGRvZXNu
J3Qgc3VwcG9ydCBjaGFuZ2luZyB0aGUNCj4gPiBwcml2YXRlDQo+ID4gbWVtb3J5IGluIHRoaXMg
d2F5Lg0KPiANCj4gSHVoP8KgIFRoYXQgbWFrZXMgbm8gc2Vuc2UuwqAgQSBwaHlzaWNhbCBwYWdl
IGNhbid0IGJlIHNpbXVsdGFuZW91c2x5IG1hcHBlZA0KPiBTSEFSRUQNCj4gYW5kIFBSSVZBVEUs
IHNvIHRoZXJlIGNhbid0IGJlIG1lYW5pbmdmdWwgY2FjaGUgYXR0cmlidXRlIGFsaWFzaW5nIGJl
dHdlZW4NCj4gcHJpdmF0ZQ0KPiBhbmQgc2hhcmVkIEVQVCBlbnRyaWVzLg0KPiANCj4gVHJ5aW5n
IHRvIHByb3ZpZGUgY29uc2lzdGVuY3kgZm9yIHRoZSBHUEEgaXMgbGlrZSB3b3JyeWluZyBhYm91
dCBoYXZpbmcNCj4gbWF0Y2hpbmcNCj4gUEFUIGVudGlyZXMgZm9yIHRoZSB2aXJ0dWFsIGFkZHJl
c3MgaW4gdHdvIGRpZmZlcmVudCBwcm9jZXNzZXMuDQoNCk5vLCBub3QgbWF0Y2hpbmcgYmV0d2Vl
biB0aGUgcHJpdmF0ZSBhbmQgc2hhcmVkIG1hcHBpbmdzIG9mIHRoZSBzYW1lIHBhZ2UuIFRoZQ0K
d2hvbGUgcHJpdmF0ZSBtZW1vcnkgd2lsbCBiZSBXQiwgYW5kIHRoZSB3aG9sZSBzaGFyZWQgaGFs
ZiB3aWxsIGhvbm9yIFBBVC4NCg==

