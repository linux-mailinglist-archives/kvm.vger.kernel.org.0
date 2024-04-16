Return-Path: <kvm+bounces-14783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F9D8A6EC8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3915E28469A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AB8130AC7;
	Tue, 16 Apr 2024 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nsRwKZRf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F2F130A63;
	Tue, 16 Apr 2024 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713278783; cv=fail; b=TiO+4898+AIsroaYbLNmGT4PsOA154EQBnZcbUytQ7kQRyCNH1QGIUrK/apcmYufmWOsiU42QfDnnwq09DCK7IxzRI1WePI+o12iBympSCOXhV3qbhsYKL9WzaswlojAL1BpkrrF/RD+qOUoQ+z0kCObLnbtum4cSqLA5+f/03o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713278783; c=relaxed/simple;
	bh=ByxKyj7s4tnv7NKuAdgoW8MOBPbLQm9Nq8sZEbx3h0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kLMuatl8Q6Jj84kZru07K0GHs891SDqKHAs4vwCpsAIiqAtFwyZKzND4rNf042eaGgGoR/wtLCOTVVOixaPEnIgEIeYOTHE0OltDSGglP9xtM1n/toZlsKS9hE596PlPgt0w4osonNwmJL4bb3Fs3BS6piFc+HrbkN1Iu5uxDwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nsRwKZRf; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713278782; x=1744814782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ByxKyj7s4tnv7NKuAdgoW8MOBPbLQm9Nq8sZEbx3h0A=;
  b=nsRwKZRfKnLYvWwPg2p0GfFzZ+ZA0loFBqp33bWvQD8nWE29o09d98zt
   kabI/FB9rIyKkAwNwEYvxG/CIPn+IZRY87m0PBTyzImcGxSCOcxLh5Mi3
   tC9peQg4LcFIpWo+zavjenG5Fr+UAVEifX7ulgkppBViLgWt4dCW8iqUr
   eEqHBM2s1BsuFyg4zHzV863+m454ysgloEymKBbWP1BbArz7B2QcA3egm
   E56iGk5xRghceiXL/KP8guOXBQ1rBaIyoNcc56Veebqg78yPk/hqn68BH
   VMe3ZYc+86oyi6k48/OYYI6ukMDnVOStzZpCL3Q7Vu2H8iM0TQY1tD6us
   w==;
X-CSE-ConnectionGUID: vzhmabH8RrqP/RW6db6MaA==
X-CSE-MsgGUID: gmmNihq+Q/2Iqm+WZaFnQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19868260"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="19868260"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 07:46:21 -0700
X-CSE-ConnectionGUID: 33aD46IIQdG9PsCXrFoSMg==
X-CSE-MsgGUID: jY7BXoMHRSuX1uvZd979RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22291436"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 07:46:20 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:46:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 07:46:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 07:46:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk6rXw4laNsVbgpXE6UBxJHPz4r4rvMl+l6ECwAfUQ7ojVztZaEtSDUgTzoQRFqrGQNW07/jnEV9lTjf0m4FW8MeEYo/sWAL5URf3iyJNP66dJ8TBlKC8skZuz8pK81br4Ogj9IxY+MdO9Q/UEmetZTrvwoqYNtSNOxJo+upiQk165lyPZx5F2IGkhvhpls56HSD9tP/YnBwL6wwN21Eq9FrZ6SQJn79paoN5mMy8oTuUw0CGUgUlslyp7y3CazNdGkjp6D8wA56tbEoEazNE6fBALUtwazXNa+66UbL2qA4zmtSdH2zoiUZmJh2Q2lTH7M3Pi9RyeMG/uWQaD1c2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByxKyj7s4tnv7NKuAdgoW8MOBPbLQm9Nq8sZEbx3h0A=;
 b=VyB9aYmIzpW2AHFprPKIqjjeIbPxAxgfkhqx0j1Qnrlz466dymdw/avxdQ2qAm604CL2T/SS+mY8fviV8wuq/EtZbRZcGZZC/le0FJ2Y7ZSCpftvuTiJAJFZfJZInq4tKYByDjI4ByEiGdwKG2q08GzW7w2T9WzrgWSpwaWfVKM4wIHK4I68bLFZtMMGiNTaK+Q4C9wOOHVJXvCngXuUtopIFIJFi5PGhFhWHs1P5Ql/b1IE2nv9c+vzYxnohwfJv5hoNhqKLj0R82PelJaNa65ACKA+gU0CFmgk7pP3uUd9RM5qzZw1jW/RqARgBilOWzsQOv1aH8XE9Z7U+6VqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 14:46:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 14:46:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 05/10] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
Thread-Topic: [PATCH v2 05/10] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
Thread-Index: AQHaj4x+zLcigCB+BU+1i3MZJkQzV7Fq+pIA
Date: Tue, 16 Apr 2024 14:46:17 +0000
Message-ID: <8c4ee32de5016f7ebeaa76fcff7c70887024c34b.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6115:EE_
x-ms-office365-filtering-correlation-id: 8a77a6b6-003e-4c7a-985b-08dc5e23f904
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7FU7mYeFvNB1o2FWUzQ8HQct6J3CI8BbgmzUCB5ayAAVGuHYbwk6fEaOxRNqeb5gJ8wOR5q8jRIXozKK4o+YbGY83mb3uo6yPjzdBOuB17t1U4Mem6eSHnoE8BqgXcoHTRDSRoxubk0EMljJXRgilfiWQ3vwKxPTrObWKiQElnW10cz0OxpjnwSFj+s9RQTeiC34RkzmNZUw6lX9C24Qjcw0TNYHjeRlhbg7t5IeXMvCOkKNkoWYsNbkKXTT/OD27Bj93bwCEdVYolHyGmIpsrJmRqzSLrx7064rDKGZKA1XYE4UZQBnQ0gLembwlDq5N9lzrWuIL9bHh6BFLvfZBzO61GT/0HUwaqsh781Bghn00l6l9NA+xTKH7opfV+D9AyDaWPfWr50Uqr7yMfKZJ7qReQuWrQOX9muiFEvzsehWH3tGYUCvvhqsgfCkvjA4upZtKd9yNbGfr88NVcCiamgJ//aKcsJGbvu4lit3vbahSb/VHhjxqUQIS9iB1KXglP3KCQCa/q4HchFnEz4oO9bIuxpJx4I0+i9HQ9QkKkJikz7vaZFY6O+89Z0En2oRK5wzrd/W4Bh1dsIeJwCbkYJi4gx0ih2n4ejr4ORnQdzeGDIleSuS41H6DppKP3Utve0tRc9g6HRUEn3JQFvEgdqoSvXyDeB1aeryoDgBr3sszSfTNequ2XSAqNlz25DnbQmteHx8nq/OSRbHaoh+Wb0iuWaxiGO4jkivxmI+uhY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXYzc3R0TS9ZakRKNnJaRHdacStmK1I1ZklJRldUNC85eFpvN3pjZ1JEVjhI?=
 =?utf-8?B?N3pSU0tDUUFVbmZRNlAyd1pTdUo5MjBxQm4za0JrODVtWFJjRE5yMkRScmZD?=
 =?utf-8?B?ZjJrcEZZNDByaFhhTG0wN3NOc0M1RE5ObEdqTkllVVFGZW5GeXp5RDVUUU9Z?=
 =?utf-8?B?SEtSa2VyLzdLeURNSDlWV3dMNCtqbjlSajNDelk4akZNdHoxcHUxZ1ZwTG40?=
 =?utf-8?B?elZMU1FSRFhkRVBWSjR6TUhWTmwzNGI1Tk9Ya2IzRm0wNWJramVvQzVqdlZj?=
 =?utf-8?B?eXRyM2E3MmRWSHU5WXBTcjhHUzJKUW82eS82NVlXQllrK0Nac1dXNE1MTjVX?=
 =?utf-8?B?eVBhcldTUFdvUUk2YmkyektaN2s5bGhzQkx3anBUWUpGSmFlSG5JRFM1Qjh0?=
 =?utf-8?B?cDAwWVFrL1labm1JOG5mNkordDVNR05KcU8yZy9BWC9WaXdPa2c3NGUxZk1I?=
 =?utf-8?B?ajMwcmI3SUFlYWtWRnUzMWRrbWFHYUI0SE03Mm9sTXk0cFovZEJHKzFENWNY?=
 =?utf-8?B?RU55Yk5FM09pNkRGell3VFNwK3F4eGhPd0JIcnJEZzlVVXg4U2RSQjU2eDl0?=
 =?utf-8?B?VjB6VmxhaFkyZTliaTZYMmdCZG9DWDg2Q1h3Ymh3U1pTRTdhTmpmaWk1cEVR?=
 =?utf-8?B?eFJaL3RhNnBKYURSeFJibjhvNGlCY1NWOWg5UnloNVNZT2RLNVlsNTBuREYy?=
 =?utf-8?B?ZjZLTkR4bWQrclhGMVJSbHFSSU91Ym1LYndic3JzRWhRNG9BZHFLUU1KNzZk?=
 =?utf-8?B?RUwxNHU0UEdkLzhWYWluTEdlLzFpSWtsVmRYcThMU0dmY0U2VVRycElFaUVT?=
 =?utf-8?B?czJyREcyeUZUeFdJOVppYld1c3hVdVIwWHdOSWFkOEJBREF6OS8zZFRoUHgx?=
 =?utf-8?B?TWZXL0ZPYmIxdi9kWFI0YkVLV1FnVmJ1NEcvYjltREJ6cHBMZVNwYStGdWpX?=
 =?utf-8?B?dzBMSlhXZk9ra25TSUFtbnY1Wk1TRlNhNm4rNFZGaTNWNTlsMEN1cEhpdHJD?=
 =?utf-8?B?bXplL1NvRm5vck12Wk9KZWhqNnVreFNaS0V3bU5XcWhRcWdFd3FtNE5vRnhU?=
 =?utf-8?B?b3RTNVFEQkQ1U0p0WEh3emhTMm1EdHl2WUZtc0Z6MC82QjFnc0x1eGIrcCt0?=
 =?utf-8?B?Z3FPV3NFTUZGNVp0VFN5cEs0Z0xuMkE4cnNMZ1Q3ZzMveEQ2cmc2OVNkcTdL?=
 =?utf-8?B?djhLRDFNbWJkcGJhaEdMZnQrMC9QYUJneGZBczZDSlNYejdXWUMxdEw3Nm5r?=
 =?utf-8?B?UCtXZlFKd0R3Y2hnaUNWY3hCRzlXS2JVbWJkT2dwanFlWG1LU24vaHo2UkNK?=
 =?utf-8?B?dUhURW5oWE96RG4wbVVsd3R0UmJJVGRPVkw3ZHJPY29Sdnl4MmVDTkF5SlJF?=
 =?utf-8?B?UGR4U3FIR1d2RXQ2dEVDTDlVaXZYL1VXYmUvbWRsOHJ4Zmw1Uk1xTWZvWTVh?=
 =?utf-8?B?RmU3OXlNQjljUnM3OXNQd1A4aVhnelZKbjZxbGJOR21JQlVFYjdXRGZXZllP?=
 =?utf-8?B?WjJWWFJUSm9RRXUzeFN2SlE5WGI2VDd6cVo3bXF2bWhxQVRHa2ZSUnhKQ1Y3?=
 =?utf-8?B?L2RzamdzWW1Od1ZBV2RZNVBBVXRqV21wcFJ3amN2NERZZUhhWUxxSlVrU0R5?=
 =?utf-8?B?a0ozamwxSHpvay9HL0dEa3hORGpMRVdWem9jdlFqY0h0QjA1cmJ2clkxZXp4?=
 =?utf-8?B?aG1hbWVSMHBvVVhGSGRVbFN4NTZlWjBqQURxSDRuUDJWaWt1SGZWZ0RTckth?=
 =?utf-8?B?aGcra2VLaVo3bjQrZ2orRTc2TFQ3Mi9BWVpUWGJrTXBuMFhtRTdSbitqeHdY?=
 =?utf-8?B?MXI5a0JGKzk1bnhKbmZIVUFpTzVxTE9oSzZLYS9telFJaVNrSDlQTG0zcnZW?=
 =?utf-8?B?UG1UTGl2SVlIRWJ6YmVqS3NMUWJud01TV2N2d1ZOQnBmVkZYdjVYY3cxS3hD?=
 =?utf-8?B?aW8zZEhwenhkNXJIYVNKbUhNQS9mVFZpa3k4bmkwMjB1aURBZVRjYlBnZElN?=
 =?utf-8?B?dmJ4WGNaRGRFVnlMalNRZCtvUTRCYUZPOHl2M3ZPMVR6Z0pjUHlSU1N5Z0Rl?=
 =?utf-8?B?dUJia1IvdS9JUnl3ZEttUGFiVEFJSGJrY09TTGlXclBLSWpHdGhGZUZ4SDJi?=
 =?utf-8?B?NlptRzU3alVUdWVGY3h0ZDV5SVhrREJHOGV1Q3pxWjROL0FwWHJuY0dMNGg4?=
 =?utf-8?Q?4efXnmi6orxpdtim2qMpUOE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3267D1F366B8894C9F540BDABCA5376B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a77a6b6-003e-4c7a-985b-08dc5e23f904
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 14:46:17.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OisVHa2zcMd9zRX47GdzPiw10GA0auF8JsGBAFhmkKFBT74T974Fo5Yq4MVvFw2lMWxccRMCoMu+qwnOV6AUC7Qb/uo+euW8wQvYdNY8+vQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gwqAKPiAraW50IGt2bV90ZHBfbWFwX3BhZ2Uoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBncGFfdCBncGEsIHU2NCBlcnJvcl9jb2RlLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB1OCAqbGV2ZWwpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBpbnQgcjsK
PiArCj4gK8KgwqDCoMKgwqDCoMKgLyogUmVzdHJpY3QgdG8gVERQIHBhZ2UgZmF1bHQuICovCj4g
K8KgwqDCoMKgwqDCoMKgaWYgKHZjcHUtPmFyY2gubW11LT5wYWdlX2ZhdWx0ICE9IGt2bV90ZHBf
cGFnZV9mYXVsdCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5W
QUw7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHIgPSBfX2t2bV9tbXVfZG9fcGFnZV9mYXVsdCh2Y3B1
LCBncGEsIGVycm9yX2NvZGUsIGZhbHNlLCBOVUxMLAo+IGxldmVsKTsKCldoeSBub3QgcHJlZmV0
Y2ggPSB0cnVlPyBEb2Vzbid0IGl0IGZpdD8gSXQgbG9va3MgbGlrZSB0aGUgYmVoYXZpb3Igd2ls
bCBiZSB0bwpub3Qgc2V0IHRoZSBhY2Nlc3MgYml0LgoKPiArwqDCoMKgwqDCoMKgwqBpZiAociA8
IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByOwo+ICsKPiArwqDC
oMKgwqDCoMKgwqBzd2l0Y2ggKHIpIHsKPiArwqDCoMKgwqDCoMKgwqBjYXNlIFJFVF9QRl9SRVRS
WToKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FQUdBSU47Cj4gKwo+
ICvCoMKgwqDCoMKgwqDCoGNhc2UgUkVUX1BGX0ZJWEVEOgo+ICvCoMKgwqDCoMKgwqDCoGNhc2Ug
UkVUX1BGX1NQVVJJT1VTOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
MDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgY2FzZSBSRVRfUEZfRU1VTEFURToKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5WQUw7Cj4gKwo+ICvCoMKgwqDCoMKgwqDC
oGNhc2UgUkVUX1BGX0NPTlRJTlVFOgo+ICvCoMKgwqDCoMKgwqDCoGNhc2UgUkVUX1BGX0lOVkFM
SUQ6Cj4gK8KgwqDCoMKgwqDCoMKgZGVmYXVsdDoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgV0FSTl9PTl9PTkNFKHIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gLUVJTzsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gK30KCg==

