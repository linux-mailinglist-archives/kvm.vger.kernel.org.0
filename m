Return-Path: <kvm+bounces-24787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BC095A332
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 18:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E7731F256EB
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572111AF4E0;
	Wed, 21 Aug 2024 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fySsfvk7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9505A14E2EF;
	Wed, 21 Aug 2024 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724259145; cv=fail; b=OnMtbfQDWpzt/iaTN6+XEz367sciuyHOPyxTG6SwrF9B6lJyHUu2AeBR8UoMcUf7rdEsPhUwx6K0+8Y1dhSDXu3BQ25HUCft7NTQurnwBEKmWvU7m8siCtjyHd40kViDb/Dyw6b0DqHJajypWC4v0uM+Ah5W3WhYieZVSS41b1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724259145; c=relaxed/simple;
	bh=mLHFaKzHCmRWUvEJJ8nhY2FUAPWO9BcmqwS7KsL6Wjs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RFN+Tp6wWQeNQwNsxnWLkdn+p65HUiLT0uh6qtfe1glut4bFsY5i01HaXdnvAzb6y78KNzBiDXNGU1yQfpsI/PSLuBTamdrSAGKUwwSvHYPoVdn9hnsjfurdAPa8MXcy1On4/eBiSW9HHNjBj4d7awAFK20fpsSazM9kt1mPo8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fySsfvk7; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724259144; x=1755795144;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mLHFaKzHCmRWUvEJJ8nhY2FUAPWO9BcmqwS7KsL6Wjs=;
  b=fySsfvk7yJ6een7yrAI8U9rhVp/Rffuuwakd2wEQjWwkYbJqyk/r71eJ
   GtBG8EqpynfwO0puXyiAbwMZnF1QUPGjTHXPOofObt9R+7WkSPQqh9CSv
   tGCb4nsopS5vvXqfV4N70LVD9PB8HlrXqNfQQDMnVQ3Q/b06p2tkIpAy+
   rdFfuOFaY2oHOo7RV1EPxQGfTWToApWU7Ve+/1JDAzX1g6cWANldACkD1
   2XzOeQQEO8tBdOFiH+hZMwNTHQzd/xJgDEzuHmGqFTqCaZ80rnLdjge8Y
   PKpd3/H8FbYYaOEb3fy1zslvBAafIjKuQKkhgmp2Rwn+TghP4H8Q1paJ6
   A==;
X-CSE-ConnectionGUID: 5t0sQXAES9+JgEmNnk4JMQ==
X-CSE-MsgGUID: cmPF+yl4R4O0wx/nWbjkBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22798804"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="22798804"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 09:52:23 -0700
X-CSE-ConnectionGUID: v6zMWzoOTP+YYFsL1t/uPQ==
X-CSE-MsgGUID: YzyfCDggTWKO4Q4LK+zjHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="84318474"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 09:52:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 09:52:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 09:52:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 09:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kzirSXYzQkKt1HhNRZ483RXJpMrN3UySHK5iFSy1CtA2V7csSSmmwdlPEB+6K3IJCYadQ7iXgMEOagT/qwy1X1oxnxHztzntrym+EQX3BSfyDAwhLvpTwJoAxzzHlXrhtMPT0b9pP6t4/OoV4BXeOiayiKVTO/1rEElejt060hHwgEMpTSqoDRZmTHP8u2tG0Cyf3ErsKCrIx/D4eeiEwB/8lV0ea1wOa6b0mpLhSmQXFvCHeBw1MHZacWNbwGda5nvXSITogtRXTVqrgo8IKcYEybf1Z9P1AaR7uRzkBPlhX7ppgVvY+4wgmgKEnFgltRBHOByFuv0DCl7aHFmyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLHFaKzHCmRWUvEJJ8nhY2FUAPWO9BcmqwS7KsL6Wjs=;
 b=vgT8eeWzJS2dmLQG2LM4SvmMaZrLIJJ9l0rbtyX+SXC/kwdjs08jIkWqDuROPe9CaZFqnn3tJIEr35513P6dhrzUteezLgQv+x42ppbw96UYmrY9jsiInSmzqpzBpIQjWyubqqWRJRw2iPzJ9SeUwYle6KvpAlBXuWOjTRqXP+c0Vz9BLd62W1lRk8aQLZNm4OVqvok1yIwviVEojdP45iWT4ybnROaLP16J5fw+gvSDQhx3cBC2u+qIsa2+0vsKE3UqfxD1W3OyCPUbTuyB38lb1SLnx5FFEw3ZLrHGyGcELOI6Aw4cq/elIC+aN3P86z0o8Y3aZXDwif5GbiMKoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Wed, 21 Aug
 2024 16:52:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 16:52:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Thread-Index: AQHa7QnMPfu1hYwqqUWmu9DbeieC5rIuuWQAgAItR4CAAFhaAIAAu9iA
Date: Wed, 21 Aug 2024 16:52:14 +0000
Message-ID: <0e283ec8bfee66c01f49529f924a0a8c43d22657.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
	 <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
	 <850ef710eac95a5c36863c94e1b31a8090eb8a2a.camel@intel.com>
	 <ZsV9qouTem-ynGJA@tlindgre-MOBL1>
In-Reply-To: <ZsV9qouTem-ynGJA@tlindgre-MOBL1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6365:EE_
x-ms-office365-filtering-correlation-id: 5c41b6d8-f96d-4647-eadd-08dcc2019bd9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RFpXcGcxMlZscStvNEtYUG81SjlXQUpzR3Z3ZUZ6MVl1WFcwQWZXaGk5Tm15?=
 =?utf-8?B?WDd4eUVrWGg3UlpEdEloOG0wMC9DcmNQenllaGtKc1FvNDNFV1M2eVJPSzV5?=
 =?utf-8?B?bkF4NHk2OXhVamtYRjJlbHRzWkcvWUx3cUtyTEJ4RFZkY2lJdnppbTN1Yk15?=
 =?utf-8?B?MnluT0xBdWkyVDArcFFRSWJ0SE9OTWU3S1pYZmFqWEtEUnBYaXduRURNUGNv?=
 =?utf-8?B?SWVleUYzZXBDV1VZZW96elhYSEdQZFphUDBGbXVBTEZ6RndqSjN1Q1dtU01K?=
 =?utf-8?B?SXN6QmZabjRRLzlxdXE2bm1DaVYyRHBGSmFMRm5rMElRM29ySlJnTVNKdmJ4?=
 =?utf-8?B?dklXSnQvcEhmSW1vWmVmZ1QzaXdTcXFBMGt5RXNuWFMwOXVvMXhzK1l4T2J3?=
 =?utf-8?B?SUU4Ky9hUW5PVVJ1dDQwRmdmNFFPR0pGTHZuRWV5VGJEcnV5NkJLL3ZsR2lh?=
 =?utf-8?B?ckxNU1FVaDQzQ3N3MklqOXU2SlNqZUQzOTdYOElYWDM2d0F2dDFuMEtnZlZz?=
 =?utf-8?B?bEZJNUVMZXdWUGNxUmFiN3AxWEdiK3plN2FhYWNSNUhNK09SUkhGZUl2Umlm?=
 =?utf-8?B?MjVoVm9oVnhWR2t5S2VLQVRsdnlzODI1YU5EZGkrMTFhdEFZbWQ4OUZsYXMv?=
 =?utf-8?B?Y2wzV3pmbTAyT0RZYUVXSXN3RnB1b1ljYyttT2x5NnVVbWh3M3Q3ZiszWkla?=
 =?utf-8?B?Q1EvaHlXUWFIaGtxNFRrbG9jOGV3dCtkc3RxUnorNkcxd25rSDBNOXBhazMv?=
 =?utf-8?B?dlE3OUl1NVJabGpmUEtKYXo1WFhHeXhHaW0wckIrZFJpUmZ6Wi96OUswbm0y?=
 =?utf-8?B?U3dreTlIbnd5UjEyblcyNnllS1c5NytLSWplL1Q4YWVwb29ja25HL3daV1Y0?=
 =?utf-8?B?MVZNUXVnb2tGaEs0SW5NTzJTTXRvL2hhMmt3czNucWkxQUlSWi9CaDdMM3k3?=
 =?utf-8?B?MVdxWnlodzJDOW04WFp0aU43cmhncm9jR1NSR0hTbzRwOWpQMm9Pd3hNb1h6?=
 =?utf-8?B?eTI1UlgrMWFaT1FKY0x0TGdsR2t2RDdZZzNNWmgrZmJtY0R1eVRoQm5lL0VP?=
 =?utf-8?B?bENtKzdoU0lJa21ya0FCZ3VYc0hEL2IxK2dXQ2p6YmM1a2ZBcW1jQ3JLWlAw?=
 =?utf-8?B?WWNpM0pXVS81VEl2eHdlQk0rUGllN1g4dE1xdTZiMUtVWGppTm1SeHl5ODM3?=
 =?utf-8?B?dndhc2sySHVCS0xoVWNHcVdGeVpOb201RUkyZWRWcXlpemtMLzI1UUtyMjlP?=
 =?utf-8?B?Y0dNeUpDNk9wVkR5RHBDUTRTaHU3NjJBeDZQcHRmSUNqdDlCZzRpS3NWTml5?=
 =?utf-8?B?YXVsbStkV3VwTERaNm0xeUVBeGNjMWlNdVMxUXJkSk4zekFtM1pZUFJ5UFBi?=
 =?utf-8?B?Um03UENTQUtNWnhBVE5UZG5PV0Z0dVduL253K3dFcTlhcjNkRThJUFFyTnly?=
 =?utf-8?B?ZGg3VEhpMVZOR0pibjhLZWU4YlNqUkdxbEZJWkU5Zi9qdHo4WE9uT1lEYjBj?=
 =?utf-8?B?UFVVOVQrRUg0SU9HUjdDYkd1MTkzM2VobW1panlHL2VoWGJpd2Z2SUVGTXZB?=
 =?utf-8?B?bnMxbWpFNW1wMzVsNnNxUVExOFhEc0c3bGpWNlZCdWNIVWRvc0RLNkVvZDdC?=
 =?utf-8?B?RWRPdVZzL09Cc2tvdVUxdFV5VnVKMlFWY09LQVNOM1FUY3JmeWMxSlI5ZFQz?=
 =?utf-8?B?ZlNkaENmeDNwUWJwWjR3TkQzenRrZThZZ1J3eHBDRjRvR0IydG83blI4a25Z?=
 =?utf-8?B?U1ExZ0w5ejUyNEZvZlVBbWJ0TDIxQzBtcDM0SnF4bkNLU1NicUNmb0htQU4x?=
 =?utf-8?B?WGdrS0tBUkgvYmFxRCtEdjVDRmpCUStYVXBXUFQ4eUlWVEN1MkNwSHUzMVZC?=
 =?utf-8?B?RHYwcHZZQUF1OFQ5Vi94eHVXbW1peUN5UDliRHczdHcwQ2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWxWWEQ3dTVNdUZoWFczYXYxeU5Ld0VIcGlMK0pKdnNjOU85bStPM0JoWUtX?=
 =?utf-8?B?MGpQY3RtZ1czNUdJczFFMlBlZFh4ekRrU29nUWlUT2UyZUpDUXVGUjVpTFIv?=
 =?utf-8?B?Q1REdEZJNVM4aTZYUHFuSXJmQXJQRkdaTzYyd1lHYnlVUWV4MC9DMzA0Zktl?=
 =?utf-8?B?T0VldUlKNTNURkRzenRheXNRRU5oVHBEQkNiWkxKRmI4VFZIYisvZW11Qmh0?=
 =?utf-8?B?bUdhUWtaNkUvbnFCRFpDZDY3akNZakdyQTJLRUt3T0VjMjlTNVFlSjVuUXZ0?=
 =?utf-8?B?OCt1NHVsRXl0cEg4bEFQbGdiY1JnZzZDdC9QRTVlRm9aTHVvOFZlYzZsU2o3?=
 =?utf-8?B?NExXUHMvakNwd1FsVXBacVF0Nyt0Q2xydytoQnBVQm1lZm1zbGxSSGRGdyt0?=
 =?utf-8?B?NExnNUN3WWt5M0hkRStyc1pLaUljemgyWi9OdFRPaWIrTG0wRGhDZTgzMWNF?=
 =?utf-8?B?YWRVRUQ1NnkrMXdPL3pXUVNLbHF1MU55c0c5dlFYdVRDdlU1L2d1Y0YxNEVv?=
 =?utf-8?B?MzFmNCtxY2t5UjBIcDhkMitjUVlLNXdDTC9VR0RsSVhUc3luS1dQYVlHdnN6?=
 =?utf-8?B?UDlaeXF4UXZIbFJGSnBTa1REMzhsWnBTdFNiR0pieTFIOTVWTjRndjR0Q0E3?=
 =?utf-8?B?dm5sUXhFWTU1bUFIZzRjQzB1MjloRFJTZks3OGpOcUswM2JiWFVnRTZYNWw1?=
 =?utf-8?B?QlhXOUpvRHJzWUEvYlBWVlRHQ2JWazdXUVdyZk9lSm5ncmpUYVF3dk1acnR1?=
 =?utf-8?B?VVBmYi9GMUtHaEtGbHBUN01TdWhUdjNVRXd0WEhFSmlUdElpRUQ3QUhNb2xz?=
 =?utf-8?B?UUtuRktQRldCUy9QVGhFYkFOckpjM2JYN3lCMkdKc0JYN3FmY2RkV094U0FH?=
 =?utf-8?B?eHhMbHlSUW1iUFYzRHNOZTVZQ1V3RXlZVE9WUFFBOUZXeU54eSs2RVAwS3Ex?=
 =?utf-8?B?ckxsNTJPcEJCYi8rT0tsN2VmZkVnb0xueEF1cUQzUjl5NzhudlhqQUczd20v?=
 =?utf-8?B?ZllyL25xSDVBcjF5UmRHNXhRelphV2VGMGVSRi9nODg0cWpUV29zblZDUUhs?=
 =?utf-8?B?bk9RZVExdlVjYlUvVFJjNld2RkkxNXVwc25KR01RN25OMXJkTkZPNmR1VXhC?=
 =?utf-8?B?NUNWZ0ZmWStDUStDMkZsdFRwSTJ3cTFNVm8xc0JHanJ3dnhKT2RWMXpDQzBs?=
 =?utf-8?B?ZVNvWE5iNThMWlBGTE9TZlpLQ0d0Z2RaakFLZ3dHczZLcmF0ZWZZcTIzY3Uw?=
 =?utf-8?B?WVdQUHhRTU0xQXRzWlNQQVV5R2NacDRWZTRraTRDSlpJU01sRkd2aEYzNWUx?=
 =?utf-8?B?dWJUOElRYmkwc0tqY1kwYS9oWDRUcEJXRVpqdzVNZTdERnc1Q0Mrckc1eXFS?=
 =?utf-8?B?OFEybnlSQjFxWk8vbGRwYTJjWER2dEx2SHZCN2tCSjdpR0ViSXQyRFlIYkxJ?=
 =?utf-8?B?dmxibCtGOFh4ODl6eitKSmxFclNyS2h4MmR6UnRSbEdHZ25rdTI5MGZsazI5?=
 =?utf-8?B?bng5WU5JcHVpSHdZSE5zblczMVhEYklldzNONTV2ZHBGTzRUTDBMOEF3RE0w?=
 =?utf-8?B?Y2pVOWxiUmdGb0FIVnlqbE5HUVpJQWtFdTJJR1N1SkJpWEVQMEhhMmt3c044?=
 =?utf-8?B?RGwvSStjVC9KaDZ0Y0FRNmp6NElSSUxrWENiYjdoM2xZc1lpcnFiSjd0VmZs?=
 =?utf-8?B?bm9LSDByQ2p3cUlNUWZGZFNYM2g1OGNBMGNSUGlKVWlFTkxsMUZuNmRvS1FS?=
 =?utf-8?B?STFTWVdENzhneHFDTWFETE1tV1dsQjI1Y2NrS0NFSWVRcFF2M2NEMTlScVpW?=
 =?utf-8?B?MW44bE9zd3ZDUnZlY2gwWDF1eEtIYjRDSnVNUnRIdnJoQUIyMDJoRmM3Zk1X?=
 =?utf-8?B?eDNkVWRjSUZXVlQ2eFlBckVSR2d4OGQ2YW4vRE1nNzZWQUR3YWZ2K25BNDZX?=
 =?utf-8?B?SFZ3TlBCTzJyZUFaMlRhdjlXZEdkSlo4M09CUGdjTjdhbjlWMzFiNW5IaE4v?=
 =?utf-8?B?RlRBOGgxak5DeFM1VGxQT0h6QmQ4cnFGS2w1SnN5VElpak94RmRRUG5ITWFC?=
 =?utf-8?B?cEhUcFcwazkxd1htVHhUS1UwaktEUjNBREJWTHRoUWROSG9nNG9wSGVtejhm?=
 =?utf-8?B?bTBDRzJTN1VLZmFIQ0lEdU04MlNES29FTHdOa0NaRjhZOTFwODBJeUtaVnJ1?=
 =?utf-8?Q?6iJ+TBzESqkw+Ah0gg8XjT0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D95E79B35F6B34C994DD6D22FEB7D7D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c41b6d8-f96d-4647-eadd-08dcc2019bd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 16:52:14.4663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/D+Qtt8CqMgTt/ASvYWYySk/v/KbbyDGsjXIbbwbSU/Nyy5AgDr9bzG/6XG9AIYGe8HHLhCGVFUBUnHtF7WTXv03Cs2DMni/edEzIWVjZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6365
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDA4OjM5ICswMzAwLCBUb255IExpbmRncmVuIHdyb3RlOg0K
PiA+IEhtbSzCoHdlIHdvdWxkIGhhdmUgdG/CoG1ha2UgU0VBTUNBTExzIHRvIHNwaW4gb24gdGhh
dCBsb2NrLCB3aGVyZSBhcyBtdXRleGVzDQo+ID4gY2FuDQo+ID4gc2xlZXAuIEkgc3VzcGVjdCB0
aGF0IGlzIHdoZXJlIGl0IGNhbWUgZnJvbS4gQnV0IHdlIGFyZSB0cnlpbmcgdG8gbWFrZSB0aGUN
Cj4gPiBjb2RlDQo+ID4gc2ltcGxlIGFuZCBvYnZpb3VzbHkgY29ycmVjdCBhbmQgYWRkIG9wdGlt
aXphdGlvbnMgbGF0ZXIuIFRoaXMgbWlnaHQgZml0DQo+ID4gdGhhdA0KPiA+IHBhdHRlcm4sIGVz
cGVjaWFsbHkgc2luY2UgaXQgaXMganVzdCB1c2VkIGR1cmluZyBWTSBjcmVhdGlvbiBhbmQgdGVh
cmRvd24uDQo+IA0KPiBGb3IgaGFuZGxpbmcgdGhlIGJ1c3kgcmV0cmllcyBmb3IgU0VBTUNBTEwg
Y2FsbGVycywgd2UgY291bGQganVzdCB1c2UNCj4gaW9wb2xsLmggcmVhZF9wb2xsX3RpbWVvdXQo
KS4gSSB0aGluayBpdCBjYW4gaGFuZGxlIHRvZ2dsaW5nIHRoZSByZXN1bWUNCj4gYml0IHdoaWxl
IGxvb3BpbmcsIG5lZWQgdG8gdGVzdCB0aGF0IHRob3VnaC4gU2VlIGZvciBleGFtcGxlIHRoZQ0K
PiBzbXBfZnVuY19kb19waHltZW1fY2FjaGVfd2IoKSBmb3IgdG9nZ2xpbmcgdGhlIHJlc3VtZSB2
YXJpYWJsZS4NCg0KTmljZS4gSXQgc2VlbXMgd29ydGggdHJ5aW5nIHRvIG1lLg0KDQo+IA0KPiBU
aGUgb3ZlcmhlYWQgb2YgYSBTRUFNQ0FMTCBtYXkgbm90IGJlIHRoYXQgYmFkIGluIHRoZSByZXRy
eSBjYXNlLg0KDQoNCg==

