Return-Path: <kvm+bounces-56120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9379B3A2D1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 16:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D1917A089
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 14:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2BB3126C7;
	Thu, 28 Aug 2025 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lz+JAbag"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9165C2C181;
	Thu, 28 Aug 2025 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756392623; cv=fail; b=sGL41lbaoGmRrvvbuvB+ujJw30hT+4/sObjLy4qIIEPFBlRHAWBLIVbZgopW/VzuIIO9L/nkQWrb/PTAuifR9LhEG8nXRROGYAiOhD+xKaYaK9qqCSEz21PbJK4t0vz2v1XRpCDxtrt9Qm/qH1pxXpbVuku9/bg7D3rCH+oQjRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756392623; c=relaxed/simple;
	bh=9ChE8bPv3EmdcRG5P7dqppGfWK0tORW/fCB/N3qSCAI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SSBaBrlVOpIZ5D80TeDGIOKiKThxzkugx5NrnwY5+sExAwxYD4za8jvOBQRajrN9hfOhxNQVIvOiZqJqswV2ZKPFo1yva5MThWLG/6RDlX0lZRRGFBA92SsGoD72PZCZK3Hio71HH24gzf+fnL+n7XwtRZ8Iv61YTvxYJ2yICoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lz+JAbag; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756392622; x=1787928622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9ChE8bPv3EmdcRG5P7dqppGfWK0tORW/fCB/N3qSCAI=;
  b=lz+JAbagrimkJI2c2MSBSUBUCMkKOOoo/FxvIo+/Q4Q29xTD+uEbayNt
   3gG3uisi0L6ajfcwj+UGWdhRRIjjUDke1rwR07cDuEgUlMsqkNhrQovDJ
   lfQGRDRhiVJMylCtrBkZ2KNWpC88oHaB3Z7GN3owFVKm7gg4dOv5md4NJ
   7ExFzI71FEdj9hCfYjPBTRSIRrshF+QoNJkPdreaAhR1ts628aO2C1RVM
   tvQyZqnKq9fh+YCNFki2O8O9S+nNK93eWShEf0j+ZP58E8yv+FWyDR0Zb
   aoJMbvmAFgN+4MIFzdXf6dqdMwwLgmGwHIMoJb17u7FnaH2qJPetgachg
   A==;
X-CSE-ConnectionGUID: A1oAXb6rSTWM0UluefjZMg==
X-CSE-MsgGUID: uVDO/opjTK6XU89OgC8Bxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="62487293"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="62487293"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 07:50:16 -0700
X-CSE-ConnectionGUID: DJlXgzvPS4yWN4SLu0iCMw==
X-CSE-MsgGUID: QQDcFae+R8O8fpupcvfNzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174299322"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 07:50:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 07:50:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 07:50:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.70) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 07:50:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pC1Ej5YN4s8tNvCmSAwzFbds3l1onhOilb3kIkuc64xIDnf/LHKGbqFHj/nQ4PlBa80y6DKP9VViXtb149k/RRoetDprSt9sHndDZ8uA8Fda5g1pf2H8FnF6uZFzzZpx48PJpTiMaubjQUEE6GL/fpg6aczn5jFhZ2J2sVGBlCX2Wg5iv70OP/AeLgmU/QqvSVrqxSSc+pfkH2qvuX22NIlh66dF/qQLL4POfZIXdeLHURzO2Rk4BGbKY5x55l+vhL8f9Ov/01Roipyso6+nCWknxHds8BpxBIeOJqfO9jYWmDBQ+AbTkQu15POZco5FKefYvBo5MTnv5L3EZST5EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ChE8bPv3EmdcRG5P7dqppGfWK0tORW/fCB/N3qSCAI=;
 b=HwjwUl4isf72zmvw2ehd+ReeM0NQ0Ldd9gUk1O9mhcn3xX028OvaN3qZ6pSeeVwO5MSGxHrFsuYqMOcY+4H9wS6bXz2E3i+FxVZKBmA1iEM+7yVXTcL/C81ccdsXZq11r9iGno62knsGmF9cCGKU0bo4QzRwxbAh5AyFODK8JfCbgFvMo0HfQ8OLpNXRu8FFBs74vXsC81H7p1eh6UdLfyurAuIXiStPhNFNEudndOkxWuN1R3xivXXoZecy+3X72Btk1d8jmrykkO0bJCk07Ym50JCDWJRkhtPhVvsqu6WxyrEv7vdrbPwmLwGNf4G8bPVkayZsV25LZekdksIPYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS4PPF30373102B.namprd11.prod.outlook.com (2603:10b6:f:fc02::1b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Thu, 28 Aug
 2025 14:50:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 14:50:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
Thread-Topic: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
Thread-Index: AQHcFuZauISCgf+9Q06NADP+L9uuhbR3Vp+AgADRpwA=
Date: Thu, 28 Aug 2025 14:50:06 +0000
Message-ID: <3224d2c78710b41c2245576c2b8ffa1bf0512fa9.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-8-seanjc@google.com>
	 <f0ab4769b3c7b660b7326fa7cb95c59ebe8a4b48.camel@intel.com>
In-Reply-To: <f0ab4769b3c7b660b7326fa7cb95c59ebe8a4b48.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS4PPF30373102B:EE_
x-ms-office365-filtering-correlation-id: 1f7b9e70-8efc-40d9-6856-08dde6422db4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VklpUHRYYXdCR3NkNmRKcndUdVI0bUFDcys5MG1QMjlBYzh5STZMa3FEczVK?=
 =?utf-8?B?bWRJQUtUMTkwekNkaDhjbDRKZlJwdW1sbGt1R2tSa2J4akhjUThKQmdqYitX?=
 =?utf-8?B?UnNSUzBrVWJRdExEZi80TjJXYythL2FoR3l0R2pnK2tlRENub3o4MzIzQ2RH?=
 =?utf-8?B?TzA4VzY0TC9ENVdIdCtLQWE3cGdBT080V3djdkMwWm5ReTVvN1hOeGtrbnla?=
 =?utf-8?B?N0tLRkRLMzRBZ293ZTFGdmtJTXJMa3pPclBrNjBxcmpCZ2JqSFRoTDA1dk9Q?=
 =?utf-8?B?aXEyVWxrZDloOHA0OVlwamZvZm1tK214ZmMyUDlTOFZaSnF6QnpwTUh4SzdD?=
 =?utf-8?B?ZWRYZTZsZ1FNQ0ZJN09nckRVbnpUNUlvMXgyL25NN3lPQzBTOVJPTHVUSHpV?=
 =?utf-8?B?a3NVeFJTRHZpRDJhM2JnSXJiMFBRWGw2N2RXckkzR2dxemttYklRQkVGdm45?=
 =?utf-8?B?SC9IK1dtdFlSazl3VU5OTWVNVHpSTC83OEZWYUJnSE0xckV3UHBPeFJsblVJ?=
 =?utf-8?B?MWNSdldkUnpQUVFkUm9CcEFzQVk1S2g2NzdLTjJsaXZUOTRoaTZpTVFqL1o3?=
 =?utf-8?B?VE1IRnFoR3ZKejg5YXdtZmxwSUxGWXhSbHBHcFVyYXlXZGJXVSsvbWVrdktM?=
 =?utf-8?B?dnNJVnVsb2pRSVA5bGF4Yno5RzBqcDVlSHlNWDlCOGNLTndEbUczODJEOUo0?=
 =?utf-8?B?c1NsQ3htdko0eHVseHI1SWdwOXdET1JaSTNSNWZhaDZmYzFhRmNSVGpWQ3ZL?=
 =?utf-8?B?ZENsdmMxU3p5bElQQVpVTjhLbkpvQm82Z1RtVVNuU1NiZVhjOFRkL2pqRzRQ?=
 =?utf-8?B?WkkrVUhKUVVxRi9Da1BEZDZqNFZxNTBTcXl0VGxLMDRsdVZEZHZkcHlnbkhq?=
 =?utf-8?B?eWhGaFhoK1h2NVVrUE1sajRFQ3R5N0ZjSFNZSzFHMmo4cXVuSTh1N2pYUUNF?=
 =?utf-8?B?SEdmUnlod2dicncvOWt2ZHpHeGlaaTJSVlRDTk5GZHhWYzdZZFZwQXltN0Rk?=
 =?utf-8?B?Z01QZmZvSmU0REI0WGlXUFcwV3NVTFNVeUFVaHFnTXFvbnpuTndNYnNmUkxj?=
 =?utf-8?B?aG5Kb0o4Ty9MSkxtdnhRbWVYMU54cjVKUEl2amZxVGQ1NFg5WmtUUys4ejl4?=
 =?utf-8?B?cUgyTGpySVppMTIxSzJkRndxMWx3bEhXc0NJYlEvdW11YW4rdmhCeWVSZXln?=
 =?utf-8?B?bFJjQkFYeEN6dXNLblVlcHJNUkxJQjZSaVhmRm04YjNNWG1WUzdOaUhyKzJu?=
 =?utf-8?B?Y0RoSWJmSFMrM3psRmxndGVGUVhlbFBwWVRXVHZ0dWQxcXk0Zml6T3VtTUd1?=
 =?utf-8?B?em1jQkxIS0NFWjNaWmRheDNiQkN2LzRnbXZVd2t1cS9YWnFwbmZHRFhnanMz?=
 =?utf-8?B?ZXBtcUp5d29lUEppOFhEZjFFZUtYRjVDRTl3VUE2WDhMMFk5UThHcjByT3hx?=
 =?utf-8?B?azRxZWdxWFUxZVJIQ0FYckpsV1VVNmF0ODA0OSs2a3RTU0M4YkcyUHUwQVJp?=
 =?utf-8?B?S3lJZmFQeUcwL3dHUkd6TXozMUc3MUtaRWZYeHUzVG8yYTUySVZkMjc5L1FJ?=
 =?utf-8?B?L3hrcjlGcWlIRFp5d0FWdlVEKzNnT29ZZitDclpwVGROVmNEOGhvdGtrMXRY?=
 =?utf-8?B?WnZYTlRodjlXM3VnZDdtNXdwZHNNWHU1UWxManJtN2Z3TjZDZUNQOHZQNnds?=
 =?utf-8?B?M3NORy9xS0t0Nk15ck14MVUrT3U3RVNQeHIxZ0F4WFplL21TK2N2Z3pyZWtK?=
 =?utf-8?B?LzgzdHRkQjhMYUlyVjRmbm9HV01hMjYvWXQ5a1k2WWx3clpqOC9JRnJqMGE2?=
 =?utf-8?B?RjJVVko5SmN1d1U1K1kzVFZwdy9XL3NkVEdEbGZhcWhGcDA1b1dTeDN2a2NK?=
 =?utf-8?B?L25YVjJpMXp1dEdSYXk1OFd3STJLdjA2L3VjSHFXaXpYT3JZNFlVZjRLSmNN?=
 =?utf-8?B?cUhEOFMraEVFUnBIMitYRGdlYkdIa1pnZUZJUnRWd2czT05WWVBUVXJldW5U?=
 =?utf-8?B?MlBHRUtiVGdBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmpMazhaRFR3dlNITW1YVnVpNFIrbTVlYXpDNklCUDBzTjVxOXphVytBZFNH?=
 =?utf-8?B?WkNJYk9oeXRNTCtlTWkzUUNjRTJpTDcyeWlVQStwemFpckRoRURqOVpRTkd4?=
 =?utf-8?B?Nm8vNVVnUzVtNmlPa0pXZkpZVkdzMDViNENzek9hNW95WUd5QlFnVll2ajRt?=
 =?utf-8?B?NXlzeHZnczM2cWFHQ2p0ei9rN204ekxmNUZNMkU5dW1RckNpSUJuKzNPNHNJ?=
 =?utf-8?B?VmltSjRlR2IzbXlwcXF0UldGd3hQM29iaGVsQVV6b1lEL2hSeUkvdDBocWFx?=
 =?utf-8?B?L3NwVlFENE1NREgySGdKTDhKZXcrR1RwZXorYnJuN1dWUzRvV2U1NTZmdndK?=
 =?utf-8?B?Qno2MVU2MExESmp4MitTbXBKSk9DTm9ZVjF3MzFTSGFMUnhoMm8rVkVMRXRB?=
 =?utf-8?B?UHhPMDNpZjdJMjRDSEIybkxZUk9XU0dRRndRR1l4YmwxalRkRXVjSGlQYUwx?=
 =?utf-8?B?OWU5SWVZRkpDaVFRZllXejFnM00yc2Z5Z0ZhV21nbnhUSzdSeDdkbTlZdXds?=
 =?utf-8?B?Y3graVFvcnQxZ0trenR4d2EzK1NaeTBmM2M2dXlBNkN4NUVCR1p1bkFDSTNa?=
 =?utf-8?B?NUhBT0lEQjNDU0I5TmwrL2g5Z1hXdmlZYVhGczUzOHBzb0hxaEppZ1Zqazln?=
 =?utf-8?B?NVJYVEhPcjZJWVFpS0wxdW1YWk1tSG9yNmZ5SzNIWFRnQkRTODhVZkRwU29W?=
 =?utf-8?B?TURxc3lTTzI2dUNzRWgxc2ZwVHAzM2taMGMwM3B1bFRJdmVGcjk3dG9ES2ZS?=
 =?utf-8?B?SURFZXNkempxRUphUDJ4WndmcHM5eC9xaUlVdjhIVHA2S3NPbWhBQ2x1bUR0?=
 =?utf-8?B?OXBhZ1hPTGZ0Qk0wL3kzZkVBTXpmYUhkQXVwOE0vd0lkWUwyTVhFVkVHWGtO?=
 =?utf-8?B?eUhRWURFVmJFWGJsY0duSHQ0RGEvdmk0RlVzaG4zc0d5WXJUYWdiaGg4Yk03?=
 =?utf-8?B?bVVCaXpoVXRBdzhIb2lnNG0yYVhTMFIwZzdGbEQzVlJXdWN6a2FXeUg3Nmtv?=
 =?utf-8?B?emhmRUp6Mnl0WVg0blJnRGFWSHhFRFRTRmFpMW5HNVdQMTk4NHlFZXI1allo?=
 =?utf-8?B?bjlvVS9xQmFrSHRvQStsZGRpREQrMGlBV3A2a3Y1TTZGVnRVcVRYcGR1V0xB?=
 =?utf-8?B?T05YdmlnYmdvZ0dOc3RiSUJiL2RveXpjR0ZaVmp2ekw2bWJmZ3ZRd0R1c2xQ?=
 =?utf-8?B?cld0WUlHcmFSUFJjUFo1SFV4NDV6VGEyMnE3SCsweUJIbW1DQW45ZCtqTDFo?=
 =?utf-8?B?NHBJSExTbEwraFNITXdXQXYzSFMwSjF2NTE5WTNtczRIZlFhc1VNUDVTOHJD?=
 =?utf-8?B?SlF4V2FzcS94TFhUVllOZzM4ZXJCNlNjT1M4Z0k4V2d1dUZGZHl6TDAxS0ls?=
 =?utf-8?B?L3o3bFNzVS9vYTFVajVQNjhvcGtxVUs1UnFYWG9vNUhFeUxuU3lOT3lYcWdV?=
 =?utf-8?B?R3ZQWm41M3QyTUd5djhCc1BLQ2ZJS2tRMFBMNjlWRGRtM2hjVERFenpxYXRn?=
 =?utf-8?B?eG5DZVIzMGZSR1NEQkdJcFlERmhKZWdoMlVVdDlWMk55dTZsWjRaRFlFVU1N?=
 =?utf-8?B?dmVZeG1TbXJtM1hoNmUxbGMzVnRISCtZYnEzTkphM0xaQy92VlBYUEppT1NF?=
 =?utf-8?B?cXBjaEZTWFovS1BFREhGSjh3TTA0MUN2RlJ3dGpWa2ZtYkxQZmJtMm1kdWsv?=
 =?utf-8?B?a2JlQXUxb2V1bExxKzhXcEg1ZDUrMjR2VUt4aDhpdUUrenc3TDJXNk5oZFRq?=
 =?utf-8?B?QWljcm8wUjVyMTY2cFhYUGEvSjM1QmI5UzZ2eDdaT2N6ZEUvOXU4dUN4ODI5?=
 =?utf-8?B?WGkrWUhWYXd5d2FWN0Z1dGNwQjVxMmpoc09SQ1F0R0NPOTc5amVZQWxJUWl6?=
 =?utf-8?B?ODVkc3lzd0hDR3JvUm5DbXR3OTJjYXUwbDlMMXppYWtpL1BYUkhrZjhqOVVj?=
 =?utf-8?B?dVBqempEZnM4K2RMWE1MSkR2VHJ5d05XWWlNWFQyaEpxYTZWSjNGTHlEcmVz?=
 =?utf-8?B?dGs2MTlVM3cwUldYT1AzZDJRMmVYQjRSNi9YdHRLM0IxbktEZ25wNVBoa1pq?=
 =?utf-8?B?OWM3MU9pZlo3djVZT3RFS09TdG11VkdhVjBZZFBuTmM1cW5oVGs0a2FrcGpL?=
 =?utf-8?B?WC9vTkpXVHZoM1h2Smc5bjlDNUpSbmlEQTlUTmNrdXBRUnQyYmdKMHRlbUln?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A854BF401D940C46A118655B36CFA8C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f7b9e70-8efc-40d9-6856-08dde6422db4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 14:50:06.5271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XoWTIACgJcMmtoSIMu/D+6BhrDIG8lp0/7O9zCCdrb5v7xLVjlxHdw5Bh4/oFwFGfv22grDtlR+BuUR/wqSs5hBHhVYfgIiQRmRK2ADegjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF30373102B
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDE5OjE5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiA+IFJldHVybiAtRUlPIGltbWVkaWF0ZWx5IGZyb20gdGR4X3NlcHRfemFwX3By
aXZhdGVfc3B0ZSgpIGlmIHRoZSBudW1iZXIgb2YNCj4gPiB0by1iZS1hZGRlZCBwYWdlcyB1bmRl
cmZsb3dzLCBzbyB0aGF0IHRoZSBmb2xsb3dpbmcgIktWTV9CVUdfT04oZXJyLCBrdm0pIg0KPiA+
IGlzbid0IGFsc28gdHJpZ2dlcmVkLsKgIElzb2xhdGluZyB0aGUgY2hlY2sgZnJvbSB0aGUgImlz
IHByZW1hcCBlcnJvciINCj4gPiBpZi1zdGF0ZW1lbnQgd2lsbCBhbHNvIGFsbG93IGFkZGluZyBh
IGxvY2tkZXAgYXNzZXJ0aW9uIHRoYXQgcHJlbWFwIGVycm9ycw0KPiA+IGFyZSBlbmNvdW50ZXJl
ZCBpZiBhbmQgb25seSBpZiBzbG90c19sb2NrIGlzIGhlbGQuDQo+ID4gDQo+ID4gU2lnbmVkLW9m
Zi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gLS0tDQo+
IA0KPiBSZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwu
Y29tPg0KDQpUaGVyZSBpcyBhY3R1YWxseSBhbm90aGVyIEtWTV9CVUdfT04oKSBpbiB0aGUgcGF0
aCBoZXJlOg0KDQpzdGF0aWMgdm9pZCByZW1vdmVfZXh0ZXJuYWxfc3B0ZShzdHJ1Y3Qga3ZtICpr
dm0sIGdmbl90IGdmbiwgdTY0IG9sZF9zcHRlLA0KCQkJCSBpbnQgbGV2ZWwpDQp7DQoJa3ZtX3Bm
bl90IG9sZF9wZm4gPSBzcHRlX3RvX3BmbihvbGRfc3B0ZSk7DQoJaW50IHJldDsNCg0KCS8qDQoJ
ICogRXh0ZXJuYWwgKFREWCkgU1BURXMgYXJlIGxpbWl0ZWQgdG8gUEdfTEVWRUxfNEssIGFuZCBl
eHRlcm5hbA0KCSAqIFBUcyBhcmUgcmVtb3ZlZCBpbiBhIHNwZWNpYWwgb3JkZXIsIGludm9sdmlu
ZyBmcmVlX2V4dGVybmFsX3NwdCgpLg0KCSAqIEJ1dCByZW1vdmVfZXh0ZXJuYWxfc3B0ZSgpIHdp
bGwgYmUgY2FsbGVkIG9uIG5vbi1sZWFmIFBURXMgdmlhDQoJICogX190ZHBfbW11X3phcF9yb290
KCksIHNvIGF2b2lkIHRoZSBlcnJvciB0aGUgZm9ybWVyIHdvdWxkIHJldHVybg0KCSAqIGluIHRo
aXMgY2FzZS4NCgkgKi8NCglpZiAoIWlzX2xhc3Rfc3B0ZShvbGRfc3B0ZSwgbGV2ZWwpKQ0KCQly
ZXR1cm47DQoNCgkvKiBaYXBwaW5nIGxlYWYgc3B0ZSBpcyBhbGxvd2VkIG9ubHkgd2hlbiB3cml0
ZSBsb2NrIGlzIGhlbGQuICovDQoJbG9ja2RlcF9hc3NlcnRfaGVsZF93cml0ZSgma3ZtLT5tbXVf
bG9jayk7DQoJLyogQmVjYXVzZSB3cml0ZSBsb2NrIGlzIGhlbGQsIG9wZXJhdGlvbiBzaG91bGQg
c3VjY2Vzcy4gKi8NCglyZXQgPSBrdm1feDg2X2NhbGwocmVtb3ZlX2V4dGVybmFsX3NwdGUpKGt2
bSwgZ2ZuLCBsZXZlbCwgb2xkX3Bmbik7DQotPglLVk1fQlVHX09OKHJldCwga3ZtKTsNCg0KV2Ug
ZG9uJ3QgbmVlZCB0byBkbyBpdCBpbiB0aGlzIHBhdGNoLCBidXQgd2UgY291bGQgcmVtb3ZlIHRo
ZSByZXR1cm4gdmFsdWUgaW4NCi5yZW1vdmVfZXh0ZXJuYWxfc3B0ZSwgYW5kIHRoZSBLVk1fQlVH
X09OKCkuIEp1c3QgbGV0IHJlbW92ZV9leHRlcm5hbF9zcHRlDQpoYW5kbGUgaXQgaW50ZXJuYWxs
eS4NCg==

