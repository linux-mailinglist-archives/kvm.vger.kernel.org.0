Return-Path: <kvm+bounces-26166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B03FC972555
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4CA71C21B71
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9663618CC17;
	Mon,  9 Sep 2024 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJeQwPdV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF9F18C923;
	Mon,  9 Sep 2024 22:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725921314; cv=fail; b=lvHty/BRtxVWHwfpyRcZoeQcvU1no//0Mc+d0OCXNMvyneFdcgid+UNslQ+jiEUcVhEYtsRTzb+oVX85QfI8Zryy6nzz8lB7JeYLI7Ig8AF3dvhtRr+4pSXucKaHKL9QMHWwPMH9isBHfZCcuIhUjCzn6zSoZnXuewp7Jq/Yxvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725921314; c=relaxed/simple;
	bh=W37o7XGS+6FqhjjVxoGXgLPsxF14KR3heKW/CpbtVRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pFCGMWt5r7xczrdKCX490UkUx6HhAQbgws4HkmgXvaSRH1xRKhq/zb/QZLvtsex/QC1eMjuU0E/9w1NQjlMfznVAXbngQ515pYvHfyduRY56tEOXZwvUr/TBVdBqO67dd/G629AuC6b9qQRxpqyQsAsAtThVH4uLVQm/cgHvXtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJeQwPdV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725921312; x=1757457312;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W37o7XGS+6FqhjjVxoGXgLPsxF14KR3heKW/CpbtVRM=;
  b=kJeQwPdVRlcDnJUWHSQaETos0SERRAeUyR4cHmLmS9NQci30IGsRpznU
   RYUbK35ZAz16GN1eemkPrGnSOvo/6wGg9r3kMFAQ40az/X4rzhq0sxAnO
   zqMZ15sTZlP1b8RLV2juSYzgG2YHMBsJMBZHDNEq5qyxCbFBwekCv4Do7
   4p0Uh6rZzF6BGOsKZf3TM8WNA9T+7fyKCatXER7qV+Joe2ZJnZOPoDT85
   fxC4zjuOiLtusNcQkTK7pupwu8DC4KkRiVdEr8N4ftjJbbBgUifRFrfpm
   XIEZ5FDJd+pQkipe1sQEoTO8sOZk4dtaqxX9IsbHKInupaf4xX/ew9Fvl
   A==;
X-CSE-ConnectionGUID: zZ5zd+yVQnewsfISpBPGRQ==
X-CSE-MsgGUID: f0Y9+xtUSp+k1vRIa58G7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24511606"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24511606"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 15:35:04 -0700
X-CSE-ConnectionGUID: kauS0vG0R4mLeK9U6UnRsQ==
X-CSE-MsgGUID: KQr2fcSiRcuUAvRFz5lSEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="71608889"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 15:35:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 15:35:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 15:35:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 15:35:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 15:35:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKBqraluPuE7kOnGIokRVGmx+mOORLIxhgXAfuMHHTBc+luWsbbUXeFlPdhku+/H9ES94NKg6jD8SJ3m8CxvP3hfcDcM5RsgdLBKuXQdEI2tZYvGr/dS/vp3Vt7S2f+V94zpt8Qp9LeJv1apMJsaRtiQou2rYFXQtbaKVXVCGc0k355zUY4WXdgO0CQ9RHS3t5XLx10ERHbgNBF03iK0LKV0PhbYhKnCqlA5SGMjnV/HYnQ1CxNTE1laeajA3nPsHsoXf5vcNOox/pTQv75Inl5jqDrtHcpSFNIW0nKNo7Rscn7Rx5WRVjx6xcCHmUbaJX5zv7RsdPiBf7pMiEaeYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W37o7XGS+6FqhjjVxoGXgLPsxF14KR3heKW/CpbtVRM=;
 b=ao9XcBiccDPZwjlk7xIVtoR9YtXqP2vVt9DP/0lf3iJUuHjHcFnuUW0Ntgx6++j0lugtZa+yOmQ8uJMJfCh4+KZgPLpD1SvWI7uKdsMsE9kBtSEKWNLQwgIpv6ovh/HbeJFK/D6Wpv5StRhtHl0SHiwk7te81glQmxOX7LI/Znv6xt2yPetw6WFSrOLW7WHpU+mV/uEmVTDuvuRM5Av6ITATNkws6wnutU1UoEy+zGBlTp7TNvFArKH0AvjP6ECimZ9C+/+VlZXP/kDfLAGegMOcvaQA+iiMoKeChbqmPXIAp39MUwUtEMHZqnRc8uwQv1VtV76+68deqX1rbNFt5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 9 Sep
 2024 22:34:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 22:34:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yao, Yuan"
	<yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIAAA0gAgAAT6QA=
Date: Mon, 9 Sep 2024 22:34:55 +0000
Message-ID: <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
	 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
	 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com>
In-Reply-To: <Zt9nWjPXBC8r0Xw-@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB6791:EE_
x-ms-office365-filtering-correlation-id: fc0bdb65-90d8-4e91-7b4d-08dcd11fa0e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUdmQ2NMZC9oQjZsNjJRNGVlL3dicStNT2lSTlBoN0lHM2QzQUxtcStZRS80?=
 =?utf-8?B?RFJObkY1a1RLWXV4Tjk4SHl5WlBHeEV6dVZaVnQ1Q3IwUjQ1YnFtM2gwRGYr?=
 =?utf-8?B?dndjcG04K2xsVlN6TURCQUVka0JFVm5CbjU4bDBiekszMnVkS2NKWXZ3Yms5?=
 =?utf-8?B?cytaZGlyaWdiNUNPb0hnb0ZwblJIeEpOd3VZLy9qbTVUR0NhOVlzbGtDR240?=
 =?utf-8?B?aUgrUDR0MUJRQW1QQ09Vd096aVFHUGx6YmVJM01VV2hldTFNWVNQV2tIVkZC?=
 =?utf-8?B?VG9hZ1VvYlBRcXRuVFczKzU2eEIxbWdJcDJaUXFldVZ1Yis1ZVNzWUQrWUJo?=
 =?utf-8?B?WkhMK0d0Nnpob012ZzRNeVFCS1d0Tkt5SXZaZWIyZ0tkN3VZRGExd3dFUGE0?=
 =?utf-8?B?NDZWSTkxRFRhd2NMK3pVZXJiVTJXeDk0YXJNcVpITFBTbmFrdVluT1Zkckl3?=
 =?utf-8?B?REt2Y1RoZk5LL2lPcG9aRTNLdTBTUjArY0RtQ1RySUVVR0YyZm9wUEUrYWhL?=
 =?utf-8?B?QUJHalp3NzkrY1M4cExvSEhSK3h2QnlrdmlXZTdGNU9LZXpTVlJWQ29OYnZ3?=
 =?utf-8?B?V3dYSkVKc0VOYzd0RDZjeTJvNVp2WkpObDNwdGZ1VTFHa09CeDZVV0ZKUExH?=
 =?utf-8?B?bit0c0srczdLT0hueHhPRTkxRWZSUzErQzliL0dSbWl1KzVWdmdiZTZmVFFB?=
 =?utf-8?B?dStZanFkV3dEc2RBYjBtZmdVS0xZQlZEdm1RMHNpbUhMdEJvY2xLdnFKYldn?=
 =?utf-8?B?TkxyVHJrbVQrcWtPTmlvcGZESU8xSDd1eG9PS3g1Y0dWNFhMOXBZbGd5VHdO?=
 =?utf-8?B?VHl1cTdBWUUxVWJLaGh5ZXUxcGFQUmpEbzA5Y1Fzdzh3RS9kbExIOCt1UGtN?=
 =?utf-8?B?ZTh0TGU5eHRmSWluNFhqcXRQSHErWm4wUitxeklURlRTU29ra1k1U2RUZjhM?=
 =?utf-8?B?RkJHTXA1STdpVHlJT1p4Q3ROM0xoYTNuckxMdWtOdzIxa0NiSWY4RjdlSXhY?=
 =?utf-8?B?amRNOHk5TGhxM3RYVzllMEsyczZXSjFQWUN3ejlocmlBa2NXTDF4eEdIRTJ1?=
 =?utf-8?B?eXpJVGxpRlZRTU9QWjlnMW54NGgwemhYaHcxWDRoTTQ2bVdpVmdBLzAvUkVj?=
 =?utf-8?B?QldrcU1QY3JWakxudTVBZXZ2MEp2MHc5VWtaajBSeVJBTUUyYmVrYTc0bEFY?=
 =?utf-8?B?QTRXbnRxTEs4VzZpNEdWM1VrdSs3dG02ZzF4dFJ5N2phR2M3YkVEd3dLTDVu?=
 =?utf-8?B?K2l1VStZWDhsV05jeTkwZzQzN0tpcjN2dkRFU2loSlJNZHZUZDB2QlJtMlI0?=
 =?utf-8?B?V0hpcVVrQW1MaWt4aStET3FsalVwUVUxcHRGRDlQazlRcUJLR1pFbGVtVFVV?=
 =?utf-8?B?aUlraTdMZWNGc3VTZHowUEUwdW1tZ3pINUliVFdYbW93T2MrRVhFQ3BHbmVJ?=
 =?utf-8?B?OHgvZGpaUmd1Z3ZuRGtObm95NHh0K3RXc2Z3VkFMMVV3eUVIdk1pZnBFNCt3?=
 =?utf-8?B?N2ZDb1FqMXhQZUdjd2dMd3o2Z01FU0hNbFFJYzRUYWZOZEJOaEtrZ2VtdDU2?=
 =?utf-8?B?K1NVV3JHazc0MVFEczFHMVdQVi8zTm9WWGgvY25LbzRuUjVZc0FuQ210Yllo?=
 =?utf-8?B?UTZxQjNucHkyNEZQY3NmV0h6SFNSaDBnVVl4VVF5Q1d6RU1jbGtIQmZTMnkw?=
 =?utf-8?B?SXlKcjM1czhMVkFRY1dNMnVYL2Q3SkZtemNYOFQzWk5CN1pIaE9GM3QzNkNP?=
 =?utf-8?B?VTFneWhJcHpiV09EaDRka0svMVJFOUtIYnFhdFcxV3ZhZVBHdHkwRzhnUXZz?=
 =?utf-8?B?dWNpU25qcUNTdFFLTGtWNXNxVVBXOTB5UFZsbDZYRDNYR3BscHI4UFo2QTdn?=
 =?utf-8?B?ZFJTZnN2M1pzSVhFc2FJWG0zSkJvTzNhWWRHVDNSQkhVdVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlBmMXlPUGhXTWkxdFpiOUtndzlJUW5RTFZtRW1sWGdGM21HR0E4WENva3d4?=
 =?utf-8?B?WUxyVDh4QW1hUGp4ajVTdjdWS0tLTU9KUUVqOVJld3lVWlZYb2dxZ3ZXaGlS?=
 =?utf-8?B?MmpYRXVnakQyZUluYU9OeDAwRWhYQ0hIYW10aGhCQzVBMm9tdlBRL3N2b2I5?=
 =?utf-8?B?UGJjalhQZ21sV0ltbHFjRGk1SkFwTUZjeUhDVWZ2UkU4S3ZvK09ERnBjWkVn?=
 =?utf-8?B?Smo1TitIL2pPekpISmhXNnUzZ3JYK2k4SGl4aXRKcmE1bnNYU0hxcHNSL2NR?=
 =?utf-8?B?NlRwdGF1eWxBRkxrT3B5MkhTd0JtdmI2TDRNa1JhRytCUVQ3blBJa1htN0Nx?=
 =?utf-8?B?eTJ4ZndJMlZiSm11YXZhNXRrQ1d1TWt1QnpLazVqMzhjdE90SHByT2pJU1Bj?=
 =?utf-8?B?KzYwVGJGN2FKVDM1eVNaOE9zN3lRRzRVTStsU05MSGF1cFFKQkNwN2NSU0Zo?=
 =?utf-8?B?ODR3SXYzby9KRFUzTStWckJwcWgyZHdNMHJjbmgzOHVYZ3FYMzcrMVR0WGVh?=
 =?utf-8?B?WjFlMjVHTzh2YzVBMlBOZ3I1RE56ZTBJQXV1aXdXKy8wNmlYK2U4dHBLeCtj?=
 =?utf-8?B?UG9FenF5NWVuR0xPSWMrZXVkUWZ0Q0x3cllXR1VsSFF3L1IvQnQxdFBDWUtD?=
 =?utf-8?B?ejdScUFVQUZYVHFjOWZtR3RSSUJOMmRhVk55M3BpN3M1dVVxRXozMnN1Z1hC?=
 =?utf-8?B?T0ZQb05leHhnZFd0Szg4aWVIeGhxV1IrR3FOaWdmNHU5enI1TmpmS2FjckRj?=
 =?utf-8?B?ZVlHWDYxb3hXNjdHTWo1ZWU0N0Zwc0U1NU5sQWFyWTFoajR4MENlWk1vM2ZF?=
 =?utf-8?B?dFdpL2RnSE0zZjA4WFpSSVg0bHlESk1tQ0ZUVm1MQzhxNUFlN285SXVJSGtT?=
 =?utf-8?B?MEgxSC92ZzNQbTNBRDE3NXNUTmNudFFLeHA5WlNiQUt1OG1QcjlNRzFOeGc4?=
 =?utf-8?B?azdUNDd2VGx6bDhRYk1OT05EQUthRzJpSHNzUkkrVllYLzJIOVZxRC9aem94?=
 =?utf-8?B?aUh1QlQ5VmV0M1ZkV1RtbmNjSWpzTmNWUEVOZ3AzQm02ZHJYMGllRzhkT3Np?=
 =?utf-8?B?ZUp6c3EwR2hBUU5mT0VmaytxZjYwRmVYRXh3RkxQcGRrOERRSVFYdGxrSUZw?=
 =?utf-8?B?dXZMU2R6ZlBRQlJRWDhreXRCMVhHN1lveE1KV0h5M2p4UVRNZW1nSTNnZ0wv?=
 =?utf-8?B?dVRaM3g5OWxGNTlhbGp2YklCdmJCTCtUc1dKK2ZCTWp4OUovZUYxdGxDTXQ4?=
 =?utf-8?B?SFJYNjZndWFBT0IvWVFoU0xxODRZaENkOURCNDNnUndnUmVNL1oyaUVrczNG?=
 =?utf-8?B?V05pNWtkd0lDKzAxQWc5VFFzME1iYWRYYUFEREhZcDkybVNZNnVwODFiZGxC?=
 =?utf-8?B?MEphM1lBQnl0UWg5Znl2aFVCenpXRE9sQmowK0RuR1BmcW00blJRVjIxalFu?=
 =?utf-8?B?UlF2N202RUhOMDhYYmd2Z3AzTDI4U2lqTFYrZ0VML3pyZzFLdStRVG5ROXho?=
 =?utf-8?B?R1N4K3ZqOEsxdllZQ2N2ZE9UWHBlVTZ5blEwdS9OenpQdHZocWpSL1RTSVFj?=
 =?utf-8?B?ZTZjT3ZGUXM5WEpUVStpemoxWllOZkNmZnA4enN1OXdlR0lXa0k1TGRnZWk2?=
 =?utf-8?B?QUV0YzF0OUR4TjUxVWpMd3RnMC9wc1o0bzM2SldJNEVrVGNYaDFlVG9LejQ4?=
 =?utf-8?B?cS9SOURKR1p5OEZQQUdPNm4yeVFSQ2g5Z1RFSW1aRWJSVU1DbGsrSUVGdWhl?=
 =?utf-8?B?YjlxVFpXMnkzakVQTkhxNm9wWmR1QW9yNE5tQXlKT0taSU9mZGhJZElUd1Rq?=
 =?utf-8?B?cmF3UlVGa2o0WEx3cmwydk1vY254YlJ5eTlsVVpUWnBwdjBSQlpvbVNraW9P?=
 =?utf-8?B?OUttSWRmNGVvaWk1WG8yRUtZbGVWTUtOU1MyNjBiTkRwL2dJMW4rSU5wbTFr?=
 =?utf-8?B?aS9VcEh2YU1HdkJFcGtvY25pbk9lN2tlRjJmRU5qZTNJTzNDS0g2Z0FjNzlE?=
 =?utf-8?B?bUlzb29tZjI4cU9pSTZJbEF3WGEyT2R6MFZtTi9MRHdwUXNjeUxhUnJvNG5J?=
 =?utf-8?B?bmFjOVlqbFdDQlBMekpkcXpQc3JwNkFtWXRmdDY5T3VLQlVJY2FHNmxjcVVj?=
 =?utf-8?B?bnhoSTVxNHltVzZKaGp6bm9HdEFwaVJqT1ZOVndxMHNZTjBJbmNYdDVKd0lN?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C9F486CA6B9EE44A139388BA0C1A8AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0bdb65-90d8-4e91-7b4d-08dcd11fa0e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 22:34:55.3277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cs3YIMMqGk76aLJXLs11qpnm4CFuKdBDS6Nfhtp21JNHx3DmT8qQSAD99x+Xpj2c+b+HcWDZELyVtj58c2Q/C5Dr+u+PmmoKCBQLRVXXZUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE0OjIzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEluIGdlbmVyYWwsIEkgYW0gX3ZlcnlfIG9wcG9zZWQgdG8gYmxpbmRseSByZXRy
eWluZyBhbiBTRVBUIFNFQU1DQUxMLCBldmVyLsKgDQo+ID4gRm9yDQo+ID4gaXRzIG9wZXJhdGlv
bnMsIEknbSBwcmV0dHkgc3VyZSB0aGUgb25seSBzYW5lIGFwcHJvYWNoIGlzIGZvciBLVk0gdG8g
ZW5zdXJlDQo+ID4gdGhlcmUNCj4gPiB3aWxsIGJlIG5vIGNvbnRlbnRpb24uwqAgQW5kIGlmIHRo
ZSBURFggbW9kdWxlJ3Mgc2luZ2xlLXN0ZXAgcHJvdGVjdGlvbg0KPiA+IHNwdXJpb3VzbHkNCj4g
PiBraWNrcyBpbiwgS1ZNIGV4aXRzIHRvIHVzZXJzcGFjZS7CoCBJZiB0aGUgVERYIG1vZHVsZSBj
YW4ndC9kb2Vzbid0L3dvbid0DQo+ID4gY29tbXVuaWNhdGUNCj4gPiB0aGF0IGl0J3MgbWl0aWdh
dGluZyBzaW5nbGUtc3RlcCwgZS5nLiBzbyB0aGF0IEtWTSBjYW4gZm9yd2FyZCB0aGUNCj4gPiBp
bmZvcm1hdGlvbg0KPiA+IHRvIHVzZXJzcGFjZSwgdGhlbiB0aGF0J3MgYSBURFggbW9kdWxlIHBy
b2JsZW0gdG8gc29sdmUuDQo+ID4gDQo+ID4gPiBQZXIgdGhlIGRvY3MsIGluIGdlbmVyYWwgdGhl
IFZNTSBpcyBzdXBwb3NlZCB0byByZXRyeSBTRUFNQ0FMTHMgdGhhdA0KPiA+ID4gcmV0dXJuDQo+
ID4gPiBURFhfT1BFUkFORF9CVVNZLg0KPiA+IA0KPiA+IElNTywgdGhhdCdzIHRlcnJpYmxlIGFk
dmljZS7CoCBTR1ggaGFzIHNpbWlsYXIgYmVoYXZpb3IsIHdoZXJlIHRoZSB4dWNvZGUNCj4gPiAi
bW9kdWxlIg0KPiA+IHNpZ25hbHMgI0dQIGlmIHRoZXJlJ3MgYSBjb25mbGljdC7CoCAjR1AgaXMg
b2J2aW91c2x5IGZhciwgZmFyIHdvcnNlIGFzIGl0DQo+ID4gbGFja3MNCj4gPiB0aGUgcHJlY2lz
aW9uIHRoYXQgd291bGQgaGVscCBzb2Z0d2FyZSB1bmRlcnN0YW5kIGV4YWN0bHkgd2hhdCB3ZW50
IHdyb25nLA0KPiA+IGJ1dCBJDQo+ID4gdGhpbmsgb25lIG9mIHRoZSBiZXR0ZXIgZGVjaXNpb25z
IHdlIG1hZGUgd2l0aCB0aGUgU0dYIGRyaXZlciB3YXMgdG8gaGF2ZSBhDQo+ID4gInplcm8gdG9s
ZXJhbmNlIiBwb2xpY3kgd2hlcmUgdGhlIGRyaXZlciB3b3VsZCBfbmV2ZXJfIHJldHJ5IGR1ZSB0
byBhDQo+ID4gcG90ZW50aWFsDQo+ID4gcmVzb3VyY2UgY29uZmxpY3QsIGkuZS4gdGhhdCBhbnkg
Y29uZmxpY3QgaW4gdGhlIG1vZHVsZSB3b3VsZCBiZSB0cmVhdGVkIGFzDQo+ID4gYQ0KPiA+IGtl
cm5lbCBidWcuDQoNClRoYW5rcyBmb3IgdGhlIGFuYWx5c2lzLiBUaGUgZGlyZWN0aW9uIHNlZW1z
IHJlYXNvbmFibGUgdG8gbWUgZm9yIHRoaXMgbG9jayBpbg0KcGFydGljdWxhci4gV2UgbmVlZCB0
byBkbyBzb21lIGFuYWx5c2lzIG9uIGhvdyBtdWNoIHRoZSBleGlzdGluZyBtbXVfbG9jayBjYW4N
CnByb3RlY3RzIHVzLiBNYXliZSBzcHJpbmtsZSBzb21lIGFzc2VydHMgZm9yIGRvY3VtZW50YXRp
b24gcHVycG9zZXMuDQoNCkZvciB0aGUgZ2VuZXJhbCBjYXNlIG9mIFREWF9PUEVSQU5EX0JVU1ks
IHRoZXJlIG1pZ2h0IGJlIG9uZSB3cmlua2xlLiBUaGUgZ3Vlc3QNCnNpZGUgb3BlcmF0aW9ucyBj
YW4gdGFrZSB0aGUgbG9ja3MgdG9vLiBGcm9tICJCYXNlIEFyY2hpdGVjdHVyZSBTcGVjaWZpY2F0
aW9uIjoNCiINCkhvc3QtU2lkZSAoU0VBTUNBTEwpIE9wZXJhdGlvbg0KLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQpUaGUgaG9zdCBWTU0gaXMgZXhwZWN0ZWQgdG8gcmV0cnkgaG9zdC1z
aWRlIG9wZXJhdGlvbnMgdGhhdCBmYWlsIHdpdGggYQ0KVERYX09QRVJBTkRfQlVTWSBzdGF0dXMu
IFRoZSBob3N0IHByaW9yaXR5IG1lY2hhbmlzbSBoZWxwcyBndWFyYW50ZWUgdGhhdCBhdA0KbW9z
dCBhZnRlciBhIGxpbWl0ZWQgdGltZSAodGhlIGxvbmdlc3QgZ3Vlc3Qtc2lkZSBURFggbW9kdWxl
IGZsb3cpIHRoZXJlIHdpbGwgYmUNCm5vIGNvbnRlbnRpb24gd2l0aCBhIGd1ZXN0IFREIGF0dGVt
cHRpbmcgdG8gYWNxdWlyZSBhY2Nlc3MgdG8gdGhlIHNhbWUgcmVzb3VyY2UuDQoNCkxvY2sgb3Bl
cmF0aW9ucyBwcm9jZXNzIHRoZSBIT1NUX1BSSU9SSVRZIGJpdCBhcyBmb2xsb3dzOg0KICAgLSBB
IFNFQU1DQUxMIChob3N0LXNpZGUpIGZ1bmN0aW9uIHRoYXQgZmFpbHMgdG8gYWNxdWlyZSBhIGxv
Y2sgc2V0cyB0aGUgbG9ja+KAmXMNCiAgIEhPU1RfUFJJT1JJVFkgYml0IGFuZCByZXR1cm5zIGEg
VERYX09QRVJBTkRfQlVTWSBzdGF0dXMgdG8gdGhlIGhvc3QgVk1NLiBJdCBpcw0KICAgdGhlIGhv
c3QgVk1N4oCZcyByZXNwb25zaWJpbGl0eSB0byByZS1hdHRlbXB0IHRoZSBTRUFNQ0FMTCBmdW5j
dGlvbiB1bnRpbCBpcw0KICAgc3VjY2VlZHM7IG90aGVyd2lzZSwgdGhlIEhPU1RfUFJJT1JJVFkg
Yml0IHJlbWFpbnMgc2V0LCBwcmV2ZW50aW5nIHRoZSBndWVzdCBURA0KICAgZnJvbSBhY3F1aXJp
bmcgdGhlIGxvY2suDQogICAtIEEgU0VBTUNBTEwgKGhvc3Qtc2lkZSkgZnVuY3Rpb24gdGhhdCBz
dWNjZWVkcyB0byBhY3F1aXJlIGEgbG9jayBjbGVhcnMgdGhlDQogICBsb2Nr4oCZcyBIT1NUX1BS
SU9SSVRZIGJpdC4NCiAgIA0KR3Vlc3QtU2lkZSAoVERDQUxMKSBPcGVyYXRpb24NCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpBIFREQ0FMTCAoZ3Vlc3Qtc2lkZSkgZnVuY3Rpb24gdGhh
dCBhdHRlbXB0IHRvIGFjcXVpcmUgYSBsb2NrIGZhaWxzIGlmDQpIT1NUX1BSSU9SSVRZIGlzIHNl
dCB0byAxOyBhIFREWF9PUEVSQU5EX0JVU1kgc3RhdHVzIGlzIHJldHVybmVkIHRvIHRoZSBndWVz
dC4NClRoZSBndWVzdCBpcyBleHBlY3RlZCB0byByZXRyeSB0aGUgb3BlcmF0aW9uLg0KDQpHdWVz
dC1zaWRlIFREQ0FMTCBmbG93cyB0aGF0IGFjcXVpcmUgYSBob3N0IHByaW9yaXR5IGxvY2sgaGF2
ZSBhbiB1cHBlciBib3VuZCBvbg0KdGhlIGhvc3Qtc2lkZSBsYXRlbmN5IGZvciB0aGF0IGxvY2s7
IG9uY2UgYSBsb2NrIGlzIGFjcXVpcmVkLCB0aGUgZmxvdyBlaXRoZXINCnJlbGVhc2VzIHdpdGhp
biBhIGZpeGVkIHVwcGVyIHRpbWUgYm91bmQsIG9yIHBlcmlvZGljYWxseSBtb25pdG9yIHRoZQ0K
SE9TVF9QUklPUklUWSBmbGFnIHRvIHNlZSBpZiB0aGUgaG9zdCBpcyBhdHRlbXB0aW5nIHRvIGFj
cXVpcmUgdGhlIGxvY2suDQoiDQoNClNvIEtWTSBjYW4ndCBmdWxseSBwcmV2ZW50IFREWF9PUEVS
QU5EX0JVU1kgd2l0aCBLVk0gc2lkZSBsb2NrcywgYmVjYXVzZSBpdCBpcw0KaW52b2x2ZWQgaW4g
c29ydGluZyBvdXQgY29udGVudGlvbiBiZXR3ZWVuIHRoZSBndWVzdCBhcyB3ZWxsLiBXZSBuZWVk
IHRvIGRvdWJsZQ0KY2hlY2sgdGhpcywgYnV0IEkgKnRoaW5rKiB0aGlzIEhPU1RfUFJJT1JJVFkg
Yml0IGRvZXNuJ3QgY29tZSBpbnRvIHBsYXkgZm9yIHRoZQ0KZnVuY3Rpb25hbGl0eSB3ZSBuZWVk
IHRvIGV4ZXJjaXNlIGZvciBiYXNlIHN1cHBvcnQuDQoNClRoZSB0aGluZyB0aGF0IG1ha2VzIG1l
IG5lcnZvdXMgYWJvdXQgcmV0cnkgYmFzZWQgc29sdXRpb24gaXMgdGhlIHBvdGVudGlhbCBmb3IN
CnNvbWUga2luZCBkZWFkbG9jayBsaWtlIHBhdHRlcm4uIEp1c3QgdG/CoGdhdGhlciB5b3VyIG9w
aW5pb24sIGlmIHRoZXJlIHdhcyBzb21lDQpTRUFNQ0FMTCBjb250ZW50aW9uIHRoYXQgY291bGRu
J3QgYmUgbG9ja2VkIGFyb3VuZCBmcm9tIEtWTSwgYnV0IGNhbWUgd2l0aCBzb21lDQpzdHJvbmcg
d2VsbCBkZXNjcmliZWQgZ3VhcmFudGVlcywgd291bGQgYSByZXRyeSBsb29wIGJlIGhhcmQgTkFL
IHN0aWxsPw0K

