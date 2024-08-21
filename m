Return-Path: <kvm+bounces-24677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F37A95919D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55482287044
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089A12905;
	Wed, 21 Aug 2024 00:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VBUZ45Oe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7033B81E;
	Wed, 21 Aug 2024 00:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724199086; cv=fail; b=hbceg2N96RqepnLH1FcZqQW9HuF58iK9z1qqMqrG50EDOWVei5KriSQdsZZruSPPG0V0xnZ+uFktIIbJ/lL/1ZZ4PzbOgJnArYlZcMFzPLOtxRhA5V+9CVgaqYvaZC7Y2gTzO4dCcEFDRIO6puhMYAS1AAPl3rNjtT7oUAqfPkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724199086; c=relaxed/simple;
	bh=YSzK+UgPVCXWZTd/PeCMecWFUJv7JoL/YbQ9aD9bY1o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IUPJeGcL/tON26p8oVIA7lfTjRYLw/mtwhEGbczR5n7nhhch8Hk7ezQoGwPGWWvMeDuqmkUuepGwBCYEd8nMLN+h0bSdxKhIBCYS/XMG/PNo64S37gji5h8tYEKIaM0bWZEHOrRBkai1Dco9u30zNfdbNyPp/tboW8UcN45JnCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VBUZ45Oe; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724199084; x=1755735084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YSzK+UgPVCXWZTd/PeCMecWFUJv7JoL/YbQ9aD9bY1o=;
  b=VBUZ45Oe2dPVmjldSuKSmovKXf9DZZxFgk0VbdTz76iGx3RkAO9wxrYM
   kmhC58eWyDqaYNp9DRPtbQszsMkcYwI4HJ9Znn9LKUZG5+aAibls5Xach
   r3mGFtqHGDQII/nyl3lleJmhY+oZmTfunnX7vdxgFUDTjdaX/468ftaQu
   373ihfooDQhemL4Ef9vRJ2KnTsaBM9EAIWeE8gmYBEkWXjzfobiUcheCl
   3KtrEqehxWSwwPreqAps/vNA9LMsNi/MQSz9EufuPkvHfotnZ9y5GcFA8
   ZwAXGJOww0uy8hVU0lzXGLqViltzivwFiUT9KSmLaohs3N2kGR9XjsZ0h
   Q==;
X-CSE-ConnectionGUID: ukEJv9kNS36J1L+z9B7EYQ==
X-CSE-MsgGUID: +5FDWiZ5TUKUgn/wKqjJWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="39992066"
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="39992066"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 17:11:24 -0700
X-CSE-ConnectionGUID: dg2vBGRASISTEBkUQrdnbA==
X-CSE-MsgGUID: Pl1UitBCTZKxN5wpy4/G2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="65863736"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 17:11:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:11:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 17:11:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 17:11:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SeaTTbrRBe/qp9VvaGy56PCOgzK3YrINhNjhijG1QbLYh0hpS9WAyR5HmgOOyFjdLu4EB6IwRXLH3d57/q98t6ud3tg1aVVJ0yhZHa5HQ0wqc/XzbGF5QzdvDqRopInYlfx/MlMCBA/y/phq4rZkzF2ysIi4Ar1DzBnY/a0u8i299esWK9KOp0w2usdSpaVsgO1KNMCZC7WuDMSHkDY0DlXYEIfy+8PVQb16tcU3eoegiuPLu1tAEQRGeHnVFZxblYwzKcHdRI1wr6q2RrTLTz5+wYstl+9Opp0ANbFnCIZ02GvEvwcfcuyqnaNK5saym1qdKnE0L6xsdqgocZk6bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSzK+UgPVCXWZTd/PeCMecWFUJv7JoL/YbQ9aD9bY1o=;
 b=TnIdKOmK+zOX59jHHZ24QHKrWoFLq5TRJPPkUXQ7xxDUXr68PMPMu40OCObVS+hfWpP955WnkHW9jK6hBY1ZUGWPMWVHRUCULKW9Lgdgu7DboHaOUvyzRMdN4T8zmuGQamjXBrg55Q5TUh5Q9uEcW64GHR4S6hmeIVIN73GLTxVDPSL+m4ccgo6fqje39B1Y9Tuxhaj9+v6iN4nNGbIfQpFWVsX+fCkgduM8K0q8d89UuDwow35q4xk9wOL13vAlKaw3g8AGzvY4TIHUC0cWJROaOU24btaLTKgHfrz/iuAHLul8SANjVqPWl115WK2n/Ti6k8Sl4niAopcAOy7lKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8588.namprd11.prod.outlook.com (2603:10b6:a03:56c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 00:11:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 00:11:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Thread-Topic: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Thread-Index: AQHa7QnLnLdgweSHG0+IS+go/dLgALImSYyAgAqZpwA=
Date: Wed, 21 Aug 2024 00:11:16 +0000
Message-ID: <0591ce2b1470bc5495ca0b6a5aa1376262714e97.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
	 <3779ae2f-610e-40b9-ad87-3882e9d88060@linux.intel.com>
In-Reply-To: <3779ae2f-610e-40b9-ad87-3882e9d88060@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8588:EE_
x-ms-office365-filtering-correlation-id: 2a5d9464-d4c3-4d0b-27c8-08dcc175c680
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TFpxMDZiS2VqUFlyMXFQUmtCcCtITzlqYTRiZU9nWjRZcFBTNllRS3M3aDJ3?=
 =?utf-8?B?bk5nTzNXRGR5cHgwbTZLMnBXOGVtUWNmMFJPdkhCeHhKTU91WFlGUW44OHJM?=
 =?utf-8?B?cUEzaWpKSFJmMmxVZGF5a2Vjc0ZUbnl4bTN2TzhIc3hVWnB6QWVWSWdpWVo0?=
 =?utf-8?B?RUROYloxOEJiMnlmNnkzRzE1LzY1b3pkZkI4aWZFdEJUQlByRGNWZ1lwT3Bx?=
 =?utf-8?B?TzFBcWNhdUpXcWtMcTQwcXFrby94cjZLQ0JJK2ZNUm5VQWpKSGo2bkdEOEU1?=
 =?utf-8?B?YjVaaTVrVW5TVHh3K3BUdjRKbnp1d3RzNkhZelVXVkVISGE2QUlKQkQ3akl5?=
 =?utf-8?B?d1ZyNjF4NXRiZjZpallIQWVoYmMxSnF1aUlvcnBkQ0ZEbFVjRDFmMmR5Ulll?=
 =?utf-8?B?TjVoTzQvbzN4TEY3a3pZNjJUM3ZTbDh3NFBuY2tuQytwVy9Bb2I5YSsvOGox?=
 =?utf-8?B?Ulp0RXRFYlhTOXpnSmI1a0x3SExBUURycnp1cE9QNklVVEQzTG5ZQ3ZnS3Rh?=
 =?utf-8?B?bFd4MG9rOE1NNEhuMXV4OFNOaU14ZHBZMzRpaUJ2ZXZxa2swdWlIYUQ4ZjFC?=
 =?utf-8?B?elh2bis0T0F1ZXF2YTBMaUlWL2lsVFFlSWQzZWdjbWk2eDJqSm9obmJtOVN2?=
 =?utf-8?B?c0QvL2w3OWg1N0Mwb2tnQVEzUnNqdVpTdVRQMjBtV0NYZ1owMzhYcTBNcUdY?=
 =?utf-8?B?SFIrSnp3OTJvUTBIZVh5bzVhSUp1OEdsYXBJN3FWREppQXgrc0hQNWx6cnM1?=
 =?utf-8?B?MDJBYy90RGRFRXpxeTVVNjdDK1g4bnNCQTk5V0YzK3NEYmpBYUpFcmtNdWly?=
 =?utf-8?B?QlNrVTlRNEZnWWtSdmVyNS9NK2t5NDBxaTVrSzYxSmhGaGRHeE9IampNMFhv?=
 =?utf-8?B?N1RtTWMxdlZHdkVES2lkTnJTR2FqZUZuZHZ0WldtMjNnVHMvYzZ4OStRVHlK?=
 =?utf-8?B?Q2l1Nm9jQXhMUElScmxscWV0cnlOZGg3eEtKRTByQkN4MUhjZHdJWGtRUjBo?=
 =?utf-8?B?OFZ2Y294VVMwcEloS1hOMWs2U1JiTVZVUmhERUlmOTVIU3AxVzF3VW1lT1M1?=
 =?utf-8?B?a2s2cTdWb3gvdEVlaDR6R3UwanVvZVFoOHdhV3FMeGdXcVppOEZzSW1HUC82?=
 =?utf-8?B?Q2lDcVBXM3RWcVpTSFRFNzlTMTZORFRTR3lyUzFCYXZORHNGSTkwbTBxZGh6?=
 =?utf-8?B?UFF3K25QZUFBR056L0w0RUN6WFVZRHhQQWcxb3BGeFR5d05vOEwyczZjRHM1?=
 =?utf-8?B?VCs1Yks2V3VLMjZhWTJjam9FbmhxTDdrZlJLSW1LQzJHeUR3T2tNUE5sRUgv?=
 =?utf-8?B?V2ZXUFN0SXdkc3UrNUsyVWlMUUxxaDRMekw0NGNMNklRbW5oZjVlcGNmMlI4?=
 =?utf-8?B?ZkdVZTdjNnhrUng2OUhkVUJEd05VQTlIeXRLU0hteTUyMkVKSDVDMkJLQ1Q2?=
 =?utf-8?B?UmUzbnZBdWc4Z0dibjBlRXpGSVkxa0hTTmZBZTBPUWtSZ3E5d1ZNVmIrRHRo?=
 =?utf-8?B?VkpEUnBnSkZtWkxVdjZHRXQva2RnaXFISWxaeU1CR2JjMTA2dGZOREo2MkFE?=
 =?utf-8?B?VGJOeUZCMDRIdkpSajliKzdVcXdXeTRyRUQ0R0xWVktGUkNSMERrUldvVU1L?=
 =?utf-8?B?bXJvS2xqOGZGVklzT200WUoyWW1EREdORmxXdENmNzhjNjU3TDJWMkJmY1k4?=
 =?utf-8?B?cmNtdEtOcEQzZS9OM1NSY29BQjlqM3pGRTN1amZQVVJOWWtDeEc5aHE1aFcx?=
 =?utf-8?B?KzJlR21Dc2FjUGl2bmVzNnp5bWlZNHcrVGQrL3RWQ3ZNUDhuMWVMQmwxMXdz?=
 =?utf-8?B?SGhQVGpLUktOeDVTbVVCeDlHL1NjeHRTdGMwcEpacE51clZucTJpaENVajlW?=
 =?utf-8?B?N2Q5eHRTTVpld25Ka3RzSUpKbllISVcrTGZ5NHdkMFFRR2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yk5YSU41SXFaa2E2K2FNYTZFN1NBK1JERExxWjJWdEtzOERUNG1WeHkvb1VP?=
 =?utf-8?B?NE0zSm8rN2dEUmczM2R2UTlYYndEYlJ2UG9TQjM4RUFLVTh0am9YRy8vZlRz?=
 =?utf-8?B?OHFxK2szd3hWMStlZzhCMWpNR2pML0Z3cUdjVzEvQTQxdHkzelJvWEtEaEE4?=
 =?utf-8?B?SjNHaVlzZDVNYngxSVY1TXpEdWxjMytVK1BCaFR3R3FSQmJKbXVtT0tVckow?=
 =?utf-8?B?clhPMXIxRkxUQXhQU2hHT1oyN2FYU1NwdU4vUDRMM0dteWl0dmlKbTJVZkR1?=
 =?utf-8?B?UVV0Q3ljWUozTXBMbTI4ZlJtMVJJWnE4UkwvSVFGdFM1Rk9pNmZGMjZkb0xr?=
 =?utf-8?B?Y1YvSE9paC9sMVVYaUNvMUEra05zdWxnaWhiWDAvTEo1Qk9lc2ZzRnJQTW44?=
 =?utf-8?B?NWZpdW9hZVZiREpkaEVRK1FyRHhGT1c0M1NqbFFWL1NvRzJXMmR6OXFxay9Y?=
 =?utf-8?B?ZzdQSGF6R0Jna0JlTHdSUE5neE9uVXhpNXp1bTZlUFl0T242Y1Y0NTM5elBY?=
 =?utf-8?B?SWFuVCtid3V1bXI4aVFKcW5xSjBtNVFGSlljb3E0czE4eGs5NGdBWDNJZDNx?=
 =?utf-8?B?SVE4ZURoM3NyUittRGptQThMczNQRHVaR2hSUEJidUdWTy9uam84eFd2ZTF2?=
 =?utf-8?B?OENDajZZQW9sMVgwZ2J4b3g1NlFhdmRnRkorRFFhWTRNWmIvc2xBVGpXV2Iz?=
 =?utf-8?B?VERxWHF0L0ladVNNTGVzc0pJdUNpbklNZHhuTWsvOUFRZHl3cndwRW4zWldi?=
 =?utf-8?B?UXZueWx0clhVTmpzTU9va1lSbEpEYXR1cVpSOWc5VnFnckhlZEQ2Y2ZKSTlR?=
 =?utf-8?B?UVNyZnR4OXRnK1FFa2g0bGRGZ3pIM0lwZzl6cnhvM0UxbnUxK3pEWWtJckND?=
 =?utf-8?B?Vm9kT2xXZlRBZkFBMzdKcUxJRUN3S29ZUnRreUxWZnRkWUM0VFE1dzY4bS91?=
 =?utf-8?B?QmVORGVLbDc3VDR5OVVEZUZZYVVqbW5ZSFFLRGdhNXgyZVJwc1pYNThmdHFr?=
 =?utf-8?B?TVVGZEwveStKejNnYnE4TnUwSTVHeFpCckFHbU1nWDhtYnlJSCt4ZHdzWFVu?=
 =?utf-8?B?SkM4dzJLT1diTzRlRGRScmNtLzNEcjFrZ3F5OWZNbzlXWkxrUFMxRHk2am4x?=
 =?utf-8?B?UzFEcm12bUhERjdBalZXWG1jWjlOODlKZnRReVJma0tGQnNzTk1yYkw0dHNt?=
 =?utf-8?B?RU1abW5ybUFPY0UveVBmZEx0c2ZNZ3lzQng3QTRwa1MxOWRpMGd4Uk4vdUNK?=
 =?utf-8?B?S04xdkNWTlo3SWYyaHUyT2NidndNRDluenRzUmVNWFBPbmw4RWNpa2ZTWitt?=
 =?utf-8?B?Tk1lNVJITG96ODNub3hHWEVDRXR2M3BFdDQ1Nk82TXJaWjdxVTg3QTlFL3lJ?=
 =?utf-8?B?Nk9WZFdNT3pTeXc3Wmt0ZS8xTzF2cDYrbmZ0M2RIOG9IOGl5TVFySW5Sb1R5?=
 =?utf-8?B?VXpBQWlhVWtXeXE1N2JhaUJiRjVFRStvcXVuaUhENGhad29iUHBaYnBXcnNG?=
 =?utf-8?B?QUVhVTQydzFBakc4aHpWcXVnOVV2ZGdNanhVUzJRYUxTQmFiaWFwYjdGU01W?=
 =?utf-8?B?QVEweEFxODljUTJpZlVoZTFNd3F0ZnhjR3pnUkpudGwzak9za0R0VDR3d1RO?=
 =?utf-8?B?cTViM2RVMEtvQWJVc2NUNVNSSVFiUkozY2lsaG1jL1JxaVpvczM2TERzbHZa?=
 =?utf-8?B?M2NCWkJFZDZsQkdsbnc3TWE1N0lzSHFzSXEvdkF4MmRMNlFpcitsS0p4V3ls?=
 =?utf-8?B?WGx2OEF2bFgwaEptRXlUaTAvTXBNNDZlTnVRMXhTZG9PeVQ3QU5vOVpYT0M0?=
 =?utf-8?B?TnFKMWRpTkZOWDBXMVFreFArNWxyNlRWVjlQNGxnMXZrUnhqM2hZWGRzRitO?=
 =?utf-8?B?WDFMc2g0eDNjeTdSMEZWVG51S2VZb3ZCVTdTUFhBL24vZ0hBdUNJTHpFZEtQ?=
 =?utf-8?B?Q2VHMjAyYW43SnJkL296YzhOVHlpeXZSbXNwOVNmWElVUDcwdTBUVG10amZD?=
 =?utf-8?B?cjI2cldSU3RIWkNUQ1pQVFF6RjY5dTZWR2dIOUtJcTV6VzlIMUhXQnBoM3ZP?=
 =?utf-8?B?VmdGT0NlZzBPeWV0czIyVWt2d09NYXNrZG9rRUhxNzRTMFpta3J0MVF3Vm1l?=
 =?utf-8?B?NUhjL1NOWVlLOFpzZGpYQXJYZUE1bmQyZUlNUTJxS3F2MU1HRVhJNnFOeEdJ?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55A53431179A6844A6F6653D0E106B59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5d9464-d4c3-4d0b-27c8-08dcc175c680
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 00:11:16.4935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LYtxRaSc5TPG0l8tinyklkAiP0bDud2bB/Od4Pqr9Li7sXRFRDzATKa3eNzdqfQF2ESYnkNvTPgANgxLR8dcm+eU4fI8X8DWmSPCOypy7I8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8588
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTE0IGF0IDE0OjE4ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6Cj4gPiAr
I2RlZmluZSBLVk1fVERYX0NQVUlEX05PX1NVQkxFQUbCoMKgwqDCoMKgwqDCoCgoX191MzIpLTEp
Cj4gPiArCj4gPiArc3RydWN0IGt2bV90ZHhfY3B1aWRfY29uZmlnIHsKPiA+ICvCoMKgwqDCoMKg
wqDCoF9fdTMyIGxlYWY7Cj4gPiArwqDCoMKgwqDCoMKgwqBfX3UzMiBzdWJfbGVhZjsKPiA+ICvC
oMKgwqDCoMKgwqDCoF9fdTMyIGVheDsKPiA+ICvCoMKgwqDCoMKgwqDCoF9fdTMyIGVieDsKPiA+
ICvCoMKgwqDCoMKgwqDCoF9fdTMyIGVjeDsKPiA+ICvCoMKgwqDCoMKgwqDCoF9fdTMyIGVkeDsK
PiA+ICt9Owo+IAo+IEkgYW0gd29uZGVyaW5nIGlmIHRoZXJlIGlzIGFueSBzcGVjaWZpYyByZWFz
b24gdG8gZGVmaW5lIGEgbmV3IHN0cnVjdHVyZQo+IGluc3RlYWQgb2YgdXNpbmcgJ3N0cnVjdCBr
dm1fY3B1aWRfZW50cnkyJz8KCkdPb2QgcXVlc3Rpb24uIEkgZG9uJ3QgdGhpbmsgc28uIAo=

