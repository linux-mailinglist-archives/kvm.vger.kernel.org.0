Return-Path: <kvm+bounces-55045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9586EB2CEEF
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75EF5560D90
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9E334AB00;
	Tue, 19 Aug 2025 21:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9dG+7Yw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C3131AF26;
	Tue, 19 Aug 2025 21:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640427; cv=fail; b=pesSCV7344RjPiU6RxJdFO3+knG+hQ4nm8mLrbmFYCjTsG7+WoLi1BbhtSYnb13cRoAxE5dfOEyYcursogeMNcXoEm4RVeksEBJoLRd6/gXiZJh2m88O2jdiz1mE+ZQgOZIDRdsPeQlS3FbaHzNUrD/7Gi15fnk2m+5hZEyQCvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640427; c=relaxed/simple;
	bh=KG75ygHwauR8Lv89OHSbP9/GheOGROOMcH8BHnqY22c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YKmzTJ99r7eTVE+50XX9cmfDhXOLetH5ZyQn/EWjFHegpvnaTDKKGN75MnP6Q9aunJwD0wafuyYmhCuk2hRWOvoKZln8JADd924V44nnhcGm52fafx5ypA/RrYOgvtFELRKApX8PUPllz9GjKdlfOS1EjHaqZjFwx0NbZ/GCM2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9dG+7Yw; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755640426; x=1787176426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KG75ygHwauR8Lv89OHSbP9/GheOGROOMcH8BHnqY22c=;
  b=X9dG+7YwjR3QGMhedr7K76LFVrherIYeaxx/BQRnGx5fjTTXrVmA82vX
   6E+pWr45Hn9teqO1O1b1Qzhj1iv3jmR8irjIy/Mb7NPQIDazlKzLkw7Zt
   L68gCCeXZgjiiY2S8TXeRYnjmcsoMtxPYgoR0be5S17UGesyW9r9VBKoX
   GpGwFsxa+kKvPoOaFf4G59ked0A0ZtNofkS1ifzabaA6/dL/IKVPf3T5C
   4h0NdkZBTvgajnwW+hWNHpVIrDOdEkGAzQLdELUREUxCh5oFsj23XZLqr
   aBC/s0i3CACsJ3nFJdeHgGkpG/ktdKf/LGjc1oDRPD04YYO0OQWm4vgwJ
   Q==;
X-CSE-ConnectionGUID: yPL9U61HSfOkWGDRKZ2iDw==
X-CSE-MsgGUID: vICp9XnNR8CldDPObE60+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="61712396"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="61712396"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 14:53:44 -0700
X-CSE-ConnectionGUID: 3lXsEX//SZCn+VuUtjmKxg==
X-CSE-MsgGUID: 4VmITnKDTzq7ghmkSfy43A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168374723"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 14:53:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 14:53:38 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 14:53:38 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 14:53:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AIBzd+i+QSrCOydpX3R0K6lrQgO5+H/QMIHVflPr4gq/ArLQGhe0qGUosBhcZv5iyALRqyQlC/t2Bf6r8/VGSuIcLfMRrSdLbJXtV1LejWsxSWDGGbUmJF7NA4BL0uTyRtjbGdcBB3+JJIBKBV0GWAqthl8VYkCGJ8jxe/XuyICh4d+34aDljQ2SrkOqgrYm5wXOUlF4kHHank5OLlLX1KEn1X9rsfySL8YnQKbYHn/D8kJZA51PXofA1pOYubmO+jCDOzBLFGbV7Au+jnGiCmi0YqWfuQEO2Xkl2VT3DYV4d+/w514aGLf7L3T+MwXIFyUS5MWuVSgakvBCQSqsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KG75ygHwauR8Lv89OHSbP9/GheOGROOMcH8BHnqY22c=;
 b=eZyyk+sEakfg/XazcfqcwPiLRf3FMQk3wmA1j+0eSswJBstT3UMIPO+Lsi7xZX6RjKf/gGK6jQTewg7x17mv3gn+5hjzaAyw0dYI7gUToq/T2K866HqDGgcU0nhuF8Zxt/mTMxz4PQo3xf7bjnRtHRjp9HYsA51TSR2PkYcKrEc+tkP5ckLYhSnDmMg9y0itb8HSyq7d1aOXLZjcT79dK45dgED7MlLEaCh4PItvqqLqoRJfp8dk4NBRbzEk92s+r/XfltF8RcHJeAYP9IozKXU/RJckuEHm3IMwSwdFczWdEiwkLv2NzIBJZioFInUmjnmb2qPVcpNKLnhY8yxu7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB7711.namprd11.prod.outlook.com (2603:10b6:510:291::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Tue, 19 Aug
 2025 21:53:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 21:53:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org"
	<kas@kernel.org>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDKj0KRQjWZhTjEidjLxSJo7SHrRiLIQAgAAdHQCAACfSgIAASCAAgAAR1ICAAAqVgIAG+YkAgAC+koA=
Date: Tue, 19 Aug 2025 21:53:36 +0000
Message-ID: <a418f9758b5817c70f7345c59111b9e78c0deede.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
	 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
	 <aJ4kWcuyNIpCnaXE@google.com>
	 <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
	 <aJ5vz33PCCqtScJa@google.com>
	 <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
	 <acbcfc16-6ccc-4aa8-8975-b33caf36b65f@redhat.com>
In-Reply-To: <acbcfc16-6ccc-4aa8-8975-b33caf36b65f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB7711:EE_
x-ms-office365-filtering-correlation-id: c68eeeaa-bc0e-4df7-afb4-08dddf6ad947
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UStzS09ZdDg3bGp2SElva242anZHZWNCQjRNdFIyTm9MRDQ5QWxkeDJ1MlRn?=
 =?utf-8?B?YU5IZ3Zya1NZVVJHM0dDdVJzTHNnYzg0WWlUTTNpL3ZNbTlvVEF0RE9jZnAy?=
 =?utf-8?B?RXpFSjR4cXNvK1RZQVFUUXFzS3NNWkxMa0Vscjh6a1kvYlZUMzhrczZ5QTZq?=
 =?utf-8?B?aWtvMlovNDlVZ3l6TU1ybXBhcnYzYzdBODIzNWNOL0RHOW9xYTFFS1VYV3Iz?=
 =?utf-8?B?d3A0MVRCczI5T05MdWkwSWJ3STQ0VEgxU0M5bDR4TFUxd1VMMzFYM2ZMb2VX?=
 =?utf-8?B?cjJtSmVKUUZWcmtjUUdGZGF0TUdQN2VibzZBZEl0R1FlVG53TUxZKzRLeE5j?=
 =?utf-8?B?N0E1eFlBS3BKc3VNcld5ZzIxMlFONGxjVjNGcXVmVCs4NnhYZHhnZGdCbW1q?=
 =?utf-8?B?cTcwSTF3Qk5iYWV4UXoyVC9iTklHS3B6RlQwVm5zZGIwc3JuVmtLVVVPWjVn?=
 =?utf-8?B?YnRtSjR1SmZJYVprNWpTaG16WFYvL1Y5alUzT3d2WFBxR242eGFwVkxqalQx?=
 =?utf-8?B?eHlhaW5FY0lZWTVQUXhMellDMExEMW4xcms2OXRjN3RadzhGNDJOdXlic1pQ?=
 =?utf-8?B?RGFCeEJZbzdOUksxY2dyK2Fwc2xGekgvUlltWWRnZXJVT3JjWXFDa0hTZ2Yw?=
 =?utf-8?B?cFJXQ3BwOURJakMxMGxzaThic3ZBUSswUEdzTEROV1pvTG9zMFdFcUNJVXd5?=
 =?utf-8?B?VE82UVQxMWFRYW9KSWpXQ3haZEZTSDNXREIzWDRMTERJdzhTQkNBTVNRaEFx?=
 =?utf-8?B?QTc4WTBUck1WcWFtY1BnZzFEZTZDNWpXQlFIeE01ZjBJb2FaM2RJMGEwK09G?=
 =?utf-8?B?am40WHFTOVlJTW1vSTd6bndVVThXc0RydFc1TkpXY0llRWxBQm1pdlhrOGJN?=
 =?utf-8?B?Y2VpZFRFaVFaU3pGR2k2YThJREowbDB0SFUyQWhKSjdFYUNSKysvNk5OOVJu?=
 =?utf-8?B?M2UwY2RCNkZhLzR3cnRRcmY5SWRDZlVWRFVOeDZVc2ZEeTZQZlFoZDkvcjlr?=
 =?utf-8?B?WFY5QllsaFVMTHFSZHA2WEZWMzRicGRWOE1qQUJSZ0ozdFU1Y1E0SDhMWk9G?=
 =?utf-8?B?bmNhMStlRzRmcmpQWTRjZUVPNHBZeUE5TlV0TFlRUWljQ1MzbExrMXBFUi93?=
 =?utf-8?B?QURqak4yY3hRZjNiUTAvNStWNDBRSUVxekkva0xIWjJEM2Q3RUVZaXZncVV3?=
 =?utf-8?B?VWVVNE5pbi9aYXBYd1puR0dJdUlraERIMlRpSnA1aklBSUtnd3dvMjRZU0Fz?=
 =?utf-8?B?WEprZ0RmdmcxNDQ2eFNURXFZZC9GWkVzeTJyMHQ4MXNXWFIzdDFVV00zRXRj?=
 =?utf-8?B?SHdIcTlMWTJwV0lxUmJtUU1aZVNibUVVQy94TG50SEg1T0gyb1pTT2M4WS9v?=
 =?utf-8?B?NXhqSXRDVG5nc1pkNjVMYWJRTld5VC9SUkpIYVN4Z3h0L0xjbDkvcGcxWk1R?=
 =?utf-8?B?bmJpRW9JRWtiY3VHYUpIcDk3ME9leXFNTGVZQi8wTU9aeEZHMU9ZRnlVbTEr?=
 =?utf-8?B?dGlBUjBzMGNHZWlvKy8waXJpODJTQVc2ZWNEYjZHeERzZG1VMG1lM09POWdI?=
 =?utf-8?B?YnlmemhrNVY0QTl4SG52VVhSUXpNUlgzM0Rya0t0SWFoV0dySzJxVEtUS3hw?=
 =?utf-8?B?NFhhakFoRzROY2dvSnVHQ09hSG1WL0VMRjJHNEZ0emcyTFVYbHlSbVVua1pF?=
 =?utf-8?B?S2tRMjZjdVc0NWNVTGp2NlJMaFd2NDBqY0NYdndMZlU0azNCYzRxbTJ1a3pv?=
 =?utf-8?B?NUVEekMvQnFlZkpZRmUrbXJqRy9hbGprRlNVeGs5MWRsNTVVdGFXYkVFb3kx?=
 =?utf-8?B?QlErQnd5NjgxbG9hRExlWjBwSGpiREdWQkowWVl0elhVVjRjZU4vb2ZFZk9i?=
 =?utf-8?B?WDhxRVJTVlZSSHdWTjErMTlENGk2QzRNUkdJenYyRDhkQ2puODhYczBkZkxF?=
 =?utf-8?B?MTI1cldjQnhVWk5NRUxmcmZRZjhqQUdMUUQrVkI4V3Jvc1d1WHJ0N2IzWmh6?=
 =?utf-8?Q?tpnk6lj4bb2E+ZttfZSfwvfdXlwuxg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0JmU2taOStvRlZRMFQ3aUtDNVZFMHZWL29OTXo3SjNKR1lWZ0FvT0d5dVMy?=
 =?utf-8?B?c1V4MmRwWm1Pa2RQclJzVmg4UjNJOE1iZ0pEVm5sVERnb3BrRXpVWnVaenYv?=
 =?utf-8?B?dDVtSjFMNTBOY2xtTjVyRTJLaTRzYWJaeVpjVkZtS2lwRXFjMmpTaW43YkIy?=
 =?utf-8?B?d0Eva3hoVHVRYTl0ZVphNkRiQy9DNEFlR3JVRll2R0puMlFBb1Bjd3A0SE1v?=
 =?utf-8?B?QlBhdENJTEUrS2g3Mm1RWnkrOTY5WGNLemJjR2k4czdPTUFSK0xxYUlwMC9P?=
 =?utf-8?B?S05zLzRpcnBoRktsakk3ZzVYZ0VJeWR0b0owQW1hZ0tObHZGaUI5cElGNGlo?=
 =?utf-8?B?MGdrRVpTcGl0MUpOdlRuY3paMFFqV05paG5wWkxMQUplQTFVSW5jME43UDBD?=
 =?utf-8?B?eEFuSmRrT2FCSUw0dStiV3RLd3dZUlMyb3h6SXg2bnFCRUFvbnZTakt0ZWk5?=
 =?utf-8?B?VUVIR05ySzVBSTU5bUVsZUo1amxic0FvazYwZzRycjc2SEI5ZXpJbXFiTDNH?=
 =?utf-8?B?U1VKelRQQWY4eDdKYmp3Yno1Z2YrOGV0ZUNOVDV3eGIrMmhkcHk2MGRIMjEz?=
 =?utf-8?B?bzdTY1ZiYW1Qb2s2ZjR6UFd4SHBaeHFCRTcxSkdxNFVNMEVyaG9FZWczcDdi?=
 =?utf-8?B?Z1RWTllJN2NvcmVxMXRmR2RYYVVqekxyWEJoeitaSVFlaUhCRlBONENqMnpE?=
 =?utf-8?B?b2xpS2N0U1ZHZjRpbXFVL0d2NnBmT29RdDdKS05VSjBMQStGU21lZHJzS3Aw?=
 =?utf-8?B?clhxakpsVklyYng2TGpWakk1bUNOUC8ycFUwZE50dlFQQ0NBQS9MUjlrR3BO?=
 =?utf-8?B?ekhEN0w5VDVJTS95MXpnem55OFZ2dGd5WG5CNzd3S0F6U09NUjl0MzNkS2ly?=
 =?utf-8?B?Wi82TEg4bFBTbTVXTjVDWlVVd3o4bEc3aVF3cGo4ZzR5dk0wZmtnR1JHemJ5?=
 =?utf-8?B?ZUdPVitFSitWT3N5dndPU3QzU1lUQ2M3NTg5VFk4WW5IUWIwd055MEhjcmp4?=
 =?utf-8?B?VnBCckZrNXRFUllBTFZNN050cjk4a1BHR0hWQ2pEQzZ2cGI1ZkJKenJaUUg2?=
 =?utf-8?B?VGNZcHNCZ3U3d000V2ZFdFRjanFrM2d1V2M5end1SFhzMUw3Yy9OWW9Sb25I?=
 =?utf-8?B?Y0Yzcm81M013TjFSOTlhZVI1L1M5UTR3VFUvdytyL2h3a0ZzZ1FNV3ZjUzl6?=
 =?utf-8?B?aVVBVzlCL0NkWUVFci83MjZBaUlrL2NkcWhEVXZ2KzZZTTVkNCtSOWlvZmg0?=
 =?utf-8?B?ZVlWL2tmZmg5U3BRelFYTFNIWUhTbStEOFlHcmhNUC83ems4TlZ6SGZDTUZX?=
 =?utf-8?B?TnNXVS9adFZBRUVSMmtob3hZTHNob2FSL215R2FUZnFIcjRNeEVJMzV5R0VY?=
 =?utf-8?B?akxuU0NiRm0vTUhDTlJhVW9RQXI3djFwRUE1WE1RVCt3dlZMbkZSaEhRYzZn?=
 =?utf-8?B?dkJwSFRoZ01aaDhPYU5XRHhIRzluRnBVcWlodVhsN2V0WDZCK0hKY2k1TEg5?=
 =?utf-8?B?ejBlNkU2SFVFTmZMMi85bkoranFseUg1SVlEelR2REx2V0xqSEdIVk9NaXJt?=
 =?utf-8?B?eURMWlNsazhraVBOYmtnTzZ5bzh4eVpWd0FHSVd0UUtHZnA5aTdQNlg4bThT?=
 =?utf-8?B?RXNmSE11bUd6S0ZGbnprUVExMkgwOTZmT0xWRWRFYUVMWXlHT25lMFFMcnU1?=
 =?utf-8?B?UWZKa1A2MTVlamtCSnBtRFV1cWV1d3lOVkZ5TXZ4bUtmS0V4OXMzZWhacnpZ?=
 =?utf-8?B?ZTAzeHF6RmVpbGtyUmRIVUJha1hCTVRQbWlCRXVSclpITmVhZDBwbmNpRmMy?=
 =?utf-8?B?UVV4WmlsbXJpcW5aNExFbVQ5c2QvbXVuRE1Ya2QrMXJyVFVqbENkOEs0TVIv?=
 =?utf-8?B?N1RjSFRGRGFRRk4wUDIrRFRMeHFrbFVkTmxCR3k1d1k1RHFzeTJYaGc0TGlo?=
 =?utf-8?B?OFJ4anpqc1RTeEV5K2lROFJ3NE10aVVock1BakxKaVhlZ0ZxYXZrRHlwQXQy?=
 =?utf-8?B?a1EyL2hyYnhQYS9LM2wzQ1VXQVV3NVAzemR6WlQ2am9QQkRtd24rOHdySHFZ?=
 =?utf-8?B?YzdiL054MTV6ajBkVnRVeWZpVVFkVFZBK09nR3hDc1dPN0ZRc2ZtbkdYMmZJ?=
 =?utf-8?Q?GfkAE8q962gTSsHCCBqZ34A9m?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EDCDAB6E142C24FB5BBC059F65CB53E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68eeeaa-bc0e-4df7-afb4-08dddf6ad947
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 21:53:36.0907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rgqGboPMCz2QB9dnHYocposwcxc/ZEA9/4UnQ4GcIX7Obi4mbfbMIQXdfjTMfHIWhFzfic59kCNuB21suu7k7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7711
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDEyOjMxICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiA4LzE1LzI1IDAyOjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyNS0w
OC0xNCBhdCAxNjoyMiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IE9u
IFRodSwgQXVnIDE0LCAyMDI1LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IE9uIFRodSwgMjAy
NS0wOC0xNCBhdCAxMTowMCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+
ID4gPiBSZWR1Y2luZyB0aGUgbnVtYmVyIG9mIGxpbmVzIG9mIGNvZGUgaXMgbm90IGFsd2F5cyBh
IHNpbXBsaWZpY2F0aW9uLiAgSU1PLCBub3QNCj4gPiA+ID4gPiBjaGVja2luZyBDT05GSUdfS0VY
RUMgYWRkcyAiY29tcGxleGl0eSIgYmVjYXVzZSBhbnlvbmUgdGhhdCByZWFkcyB0aGUgY29tbWVu
dA0KPiA+ID4gPiA+IChhbmQvb3IgdGhlIG1hc3NpdmUgY2hhbmdlbG9nKSB3aWxsIGJlIGxlZnQg
d29uZGVyaW5nIHdoeSB0aGVyZSdzIGEgYnVuY2ggb2YNCj4gPiA+ID4gPiBkb2N1bWVudGF0aW9u
IHRoYXQgdGFsa3MgYWJvdXQga2V4ZWMsIGJ1dCBubyBoaW50IG9mIGtleGVjIGNvbnNpZGVyYXRp
b25zIGluIHRoZQ0KPiA+ID4gPiA+IGNvZGUuDQo+ID4gDQo+ID4gT25lIG1pbm9yIHRoaW5nIGlz
IEkgdGhpbmsgd2Ugc2hvdWxkIHVzZSBJU19FTkFCTEVEKENPTkZJR19LRVhFQ19DT1JFKQ0KPiA+
IGluc3RlYWQuICBCZXNpZGVzIHRoZSBDT05GSUdfS0VYRUMsIHRoZXJlIGlzIGFub3RoZXIgQ09O
RklHX0tFWEVDX0ZJTEUsDQo+ID4gYW5kIGJvdGggb2YgdGhlbSBzZWxlY3QgQ09ORklHX0tFWEVD
X0NPUkUuDQo+IA0KPiBBZ3JlZWQgb24gbmVlZGluZyBDT05GSUdfS0VYRUNfQ09SRSBpZiB5b3Ug
ZGlkIHRlc3QgaXQsIGhvd2V2ZXI6DQo+IA0KPiAxKSBUaGUgYmlnIGNvbW1lbnQsIGV4cGxhaW5p
bmcgaG93IHRoaXMgaXMgZG9uZSBmb3Iga2V4ZWMsIG1ha2VzIGl0IA0KPiBjbGVhciB0aGF0IHRo
aXMgaXMgd2hhdCB0aGUgV0JJTlZEIGlzIG5lZWRlZCBmb3IuICBJIGRvbid0IHRoaW5rIHlvdSdk
IA0KPiBiZSBsZWZ0IHdvbmRlcmluZyB3aHkgdGhlcmUncyBubyBoaW50IG9mIGtleGVjIGluIHRo
ZSBjb21tZW50Lg0KDQooVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suKQ0KDQpBZ3JlZWQuDQoNCj4g
DQo+IDIpIC4uLiBidXQgYW55d2F5LCBLVk0gaXMgdGhlIHdyb25nIHBsYWNlIHRvIGRvIHRoZSB0
ZXN0LiAgSWYgYW55dGhpbmcsIA0KPiBzaW5jZSB3ZSBuZWVkIGEgdjcgdG8gY2hhbmdlIHRoZSB1
bm5lY2Vzc2FyeSBzdHViLCB5b3UgY291bGQgbW92ZSB0aGF0IA0KPiBzdHViIHVuZGVyICNpZm5k
ZWYgQ09ORklHX0tFWEVDX0NPUkUgYW5kIHJlbmFtZSB0aGUgZnVuY3Rpb24gdG8gDQo+IHRkeF9j
cHVfZmx1c2hfY2FjaGVfZm9yX2tleGVjKCkuDQo+IA0KPiBQYW9sbw0KDQpBZ3JlZWQgb24gcmVu
YW1pbmcgdG8gdGR4X2NwdV9mbHVzaF9jYWNoZV9mb3Jfa2V4ZWMoKS4NCg0KQnV0IHdpdGggdGhl
ICJmb3Jfa2V4ZWMoKSIgcGFydCBpbiB0aGUgZnVuY3Rpb24gbmFtZSwgaXQgYWxyZWFkeSBpbXBs
aWVzDQppdCBpcyByZWxhdGVkIHRvIGtleGVjLCBhbmQgSSBraW5kYSB0aGluayB0aGVyZSdzIG5v
IG5lZWQgdG8gdGVzdA0KSVNfRU5BQkxFRChDT05GSUdfS0VYRUNfQ09SRSkgYW55bW9yZS4NCg0K
T25lIG9mIHRoZSBtYWluIHB1cnBvc2Ugb2YgdGhpcyBzZXJpZXMgaXMgdG8gdW5ibG9jayBURFhf
SE9TVCBhbmQgS0VYRUMgaW4NCnRoZSBLY29uZmlnLCBzaW5jZSBvdGhlcndpc2UgSSd2ZSBiZWVu
IHRvbGQgZGlzdHJvcyB3aWxsIHNpbXBseSBjaG9vc2UgdG8NCmRpc2FibGUgVERYX0hPU1QgaW4g
dGhlIEtjb25maWcuICBTbyBpbiByZWFsaXR5LCBJIHN1cHBvc2UgdGhleSB3aWxsIGJlIG9uDQp0
b2dldGhlciBwcm9iYWJseSBpbiBsaWtlIDk1JSBjYXNlcywgaWYgbm90IDEwMCUuDQoNCklmIHdl
IHdhbnQgdG8gdGVzdCBDT05GSUdfS0VYRUNfQ09SRSBpbiB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zv
cl9rZXhlYygpLA0KdGhlbiBpdCB3b3VsZCBiZSBhIGxpdHRsZSBiaXQgd2VpcmQgdGhhdCB3aHkg
d2UgZG9uJ3QgdGVzdCBpdCBpbiBvdGhlcg0KcGxhY2VzLCBlLmcuLCB3aGVuIHNldHRpbmcgdXAg
dGhlIGJvb2xlYW4uICBUZXN0aW5nIGl0IGluIGFsbCBwbGFjZXMgd291bGQNCm1ha2UgdGhlIGNv
ZGUgdW5uZWNlc3NhcmlseSBsb25nIGFuZCBoYXJkZXIgdG8gcmVhZC4NCg0KU28gbXkgcHJlZmVy
ZW5jZSBpcyB0byBzaW1wbHkgcmVuYW1lIHRvIHRkeF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tleGVj
KCkuDQoNClBhb2xvL1NlYW4sIGFyZSB5b3UgT0sgd2l0aCB0aGlzPw0K

