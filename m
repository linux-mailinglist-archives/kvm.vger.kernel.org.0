Return-Path: <kvm+bounces-48032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FABBAC84B4
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00DAC4E5974
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B574248F57;
	Thu, 29 May 2025 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBrHNJ0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD2822B8CF;
	Thu, 29 May 2025 22:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748559109; cv=fail; b=CChX4wWf862J1bG+DjYXmS/gktucLJWfRNTGDqISuVy1KGK8kQCVIQhqPbaFS4XZaijWJvr1Kt4iOFqg2uF+mS0rWSQXQ1CF2XSBrDM/z0ASMN9OP1CRr8L4t4kmRtHOi0HX2BNmzDqUTVjUTXGeKW36DTseltwtTiGwtjMonzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748559109; c=relaxed/simple;
	bh=ugHSk2w56NeC7H/t6U2/eDWT0BHrCKACKI5GIkB5l0c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ni0KWCQFSZm2NQvBG8q0QE122gzHsFdVKQOICO68kRpir6y2Wfjp7+ywHbvEUln/qAAbAAufn0ktVrbFmDvVZbFbJKA52lNZQFKexY/t+5AD4raJ1GMOj7MrtyCF7rwsxWFCk/EJ06/aQQkYzuccddZGUoYz99CMbUBOYhvFODU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBrHNJ0Q; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748559107; x=1780095107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ugHSk2w56NeC7H/t6U2/eDWT0BHrCKACKI5GIkB5l0c=;
  b=FBrHNJ0Qs4hd3sRjYQ1QOfetEit8GU9vrFqwiC5ZC9etuLbPb35ro8z0
   59ZoNKeoBt3olz73HJxVVPEPSorkg5TaNZd3ilQTnUFTA5IQkFmmaF6/t
   RwN/2fTlnlsNIekb8x2kuUBShNMrCXuzjkGV64xEU9KkTdZoGwbAbbFqA
   cUyBQjQw6v2d2OmwEg+YuFsbSeN/pPVzifgQnq4q09vHzVoJDDwlxSe0D
   dM/ToL7YWjfN7v5/ijnuyyiZCY4fMceDFVVqgcIOMlA6m4mUn5EUyraXN
   N2BUcZGm9oYc8QUX29sp4DYKfMLa+VqxxA14BFU1HZHp0bbKP7DbRkIq0
   Q==;
X-CSE-ConnectionGUID: UZ7fFpxeQqijzwjIZI1oIQ==
X-CSE-MsgGUID: 1FZy95tlQEasnYa6IsmbRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="61305971"
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="61305971"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 15:51:46 -0700
X-CSE-ConnectionGUID: mgUlmpciQHeMHPZUuQoSJQ==
X-CSE-MsgGUID: JvOdj0BDSTeGsRX7ncYEcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="174591894"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 15:51:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 15:51:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 15:51:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.70)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 15:51:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gdwP+PD2GN2LYFc5PFPzgQ0DrT6DpAe2ZcaHf2WQgqylsmOu9eyJkLUQieM4gU2Xyjt/Du6BciVq26Cyij+aeTzpWYlhbKbhYG0cnM6nY3jLkFbSC3L6F16FJThK7HJabULdWqDjyh+IRwZCanMMNcX27DM2DDJb+JjE19q7z0azuF8XQlU78tpeBUUwCTJVuJCuZh5EOyTPpJHjX4RdLLM3+dqS8H00cYPc2SBCTEYikLpx1zDRILhSmR1w1BIPy8kI4jQQPvJFvyUSDJ7R9rQM6QRuhC19dfRxrTjBP3Cae/mVfcZdndYD9LR/jdXaC61FnU25I/V0m3t1WZ2uHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugHSk2w56NeC7H/t6U2/eDWT0BHrCKACKI5GIkB5l0c=;
 b=JJVyD0fGuCnEyhYYmSLnu0vrEKMr2LSu96hxLJRfFcUIaGBs7/hG4tDG085vET0ucHcJsLaRF7NmGe69iZ/EudbLkexsmTsGKQzkG342eQsaepzMRP/s+bBHsGmaKskvJgZWLRpPoqqYeNcvhUe010RfNJswt8wKNF7K0nmgt3Uo7eaxQTq4WLWQJRfACmHilTmpnRab56nNEaj5KLUh8XTh23xI6n3LxWdBkKbM0q/ReJpz0SXFdJx0tr8pnr7qe7WYVbKtH0fZ3Y0UHO8a59RhaBCy95oUKqtlFGnIuXSOxXU+Jc9mKrCwcJdwWwTaAvMkDK92STDH2NjiXPuQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV8PR11MB8584.namprd11.prod.outlook.com (2603:10b6:408:1f0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Thu, 29 May
 2025 22:51:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 22:51:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Topic: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Index: AQHbyRYxNH/GJBJvrUmF7CZUp+ur/rPpjuOAgAAAgICAACsbgIAAi6uA
Date: Thu, 29 May 2025 22:51:14 +0000
Message-ID: <58a580b0f3274f6a7bba8431b2a6e6fef152b237.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
	 <20250519232808.2745331-12-seanjc@google.com>
	 <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
	 <019c1023c26e827dc538f24d885ec9a8530ad4af.camel@intel.com>
	 <aDhvs1tXH6pv8MxN@google.com>
In-Reply-To: <aDhvs1tXH6pv8MxN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV8PR11MB8584:EE_
x-ms-office365-filtering-correlation-id: 343ea10b-2703-4f02-2940-08dd9f0350ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cDJoSVBqNitTd0FjRGtSUXRCeUxnUUY4Lzc4cGpIRzMvdC9aNkY3bU5nRFhN?=
 =?utf-8?B?UnZEZGdxMDNxakpaWGJKcUZEa0RSZ3AwTTRoeEhMeUdrOHZ1WDRlN2xhRzh0?=
 =?utf-8?B?SjRNSUhzQ3BnY1NYMWpUKy9JL0VPdllOZmgzZEIwcUp0aS9VZk51SkRWK3VF?=
 =?utf-8?B?UTM5NkhYVkN0Tmxkb3greGRoOGpacXZnRFhmV0FFSkRwVmJTZWVrY1VlREZI?=
 =?utf-8?B?OGMxcFJOdlUrNWFlVmEvcVYvUHgrN0IzRFBibjNNaDN2RG1ZVk9YMjZqZEhw?=
 =?utf-8?B?MVdFN1Q3NVhMUjVjL1V3UXpDVHJYVTNhcnZMV08yMlJtUVNPRWFiYTkreHph?=
 =?utf-8?B?N09TWnNJSndJaWg3WStMeVZmYTlIVGtnNTFDUGk0R0tMY3BKeWpkeTZkdTgx?=
 =?utf-8?B?UWd0Y0N4Q1dIdnhOMkxsQ0xURmJKdXhoRDRmcFJxYjZHNVEvMVdNYzFicDdn?=
 =?utf-8?B?aHhEOHNJMjk0RVJXV0lPN3N2eFE2Y29wUkdIcG9Rdmk5M0g5aktNOFo4Smds?=
 =?utf-8?B?NmJpYk9OVFYwUDZ6eUVVQUVwcVVSeG95REFaOU1JMHdYdVZQK3JFdlNjTDlt?=
 =?utf-8?B?WTNUcG5IblFHdWtGSXZTbWNyR01lT0toR3o3WC8wZFd6VndDQmVMN2cxOGs1?=
 =?utf-8?B?QUowN25VTEoyU1VsZFJiSGlrRWtpZjFLVGdDazFIeXk4THMrWDdGS0JwZkNI?=
 =?utf-8?B?U201blF1c1NONDU1MTVDZG1NRWxPZmYrOG95NFcwZDRLbFlUdkNFYzlFTXJG?=
 =?utf-8?B?ZEM2UlBFYzRCWXluUmd4UUhpTzh1UjR0WWJnS0xUdjFabFRnWUp4bHVJZjFM?=
 =?utf-8?B?cFJQaTMrREdUTWtuRlRRZmpoM2V4dUFhYjBNQ21GcnVaZ2RDYTVSVHh3TW93?=
 =?utf-8?B?MHpJNSsxckFsY1VsSy9yWDJQVE9oWDVZQkpKZnJHZ2l3U2tKUXFQUmEwUTdK?=
 =?utf-8?B?bzJVL1ozMXVUK2srZDhqcStsMVQ0UHFQR1k0S29ZQlNHSWJOOVJwa2NYZnZR?=
 =?utf-8?B?YmNPT2o4LzhFaktOTk5XK3dCaEtFUjZZZUV5b0dRL1hrTUVjRkZVU3VHNGdm?=
 =?utf-8?B?anlSNitjbm9lY0EyMFg4Z3VoQ2lLck5NVFJtS1AyU3JGS3lYUFdwSytRbzhC?=
 =?utf-8?B?L2JsRDNqemJIcXNNVUlPdEFOeG5LOUpjOVc4Qi8vM3NMZUtKZW5IQVBMVmxq?=
 =?utf-8?B?bk5QQml3d2QwU1MyZjZvWGNFcE9xSW9FTzZIS2V4a2hwV2hVUXB6cGprK2RC?=
 =?utf-8?B?dW1CSHRlazRjOU1mQjZaYWVZOXRVbURyZlBBdStLT2pXUCtnT0VHN05lRDZW?=
 =?utf-8?B?eUp3QytFWXRtWm42dlhkZkdzNkYvUSt2bSsyc1IrNE5ySkI1UXIyRGpsWk9u?=
 =?utf-8?B?UmFJcEdVN3p2c3l5Y21WUFNONDJDeVRjQ0hxa29vcGhGSGtXZXFsNVl5NHc1?=
 =?utf-8?B?bUw5ZXpvYzhTMmpuajNURTk4MS9oRUVuL0U0em5PMlIyNy9vaG5uMlZNNVZ0?=
 =?utf-8?B?QXFCVFlYaWlOcTBUUFJwekZNL0xjSHhUaGxDNzNNaFZSQ2R5RWZWRWZGSCs0?=
 =?utf-8?B?SHBqNThCR0lxVzNkaXFwK21rVE9tbUE3MnJKcUNiaklZR1lHbHpMNFR5ZWVQ?=
 =?utf-8?B?UzJZRENDeVdHOHpHS2VjUE1tNnNWNGs2WGJvd0J1MkM1WHpvZjcxaW1MNHFz?=
 =?utf-8?B?dFFJT1FnM3VDMUxmWDlHQ2todXFzMFpkU05TU3NPdXJNUW9icmNVeWxNK0pB?=
 =?utf-8?B?MDUraVU4NGd0QXRPS2M5citvMVJFdXppNXEzREU4NjNiOG9Cem1PdWNmNURt?=
 =?utf-8?B?ZTVGUTY5K2VGUUM2NFBpRVphYnhDUWg0TUh5YXR1a1VMcktwSWhLK1hPaVZB?=
 =?utf-8?B?aVR1SnRveVZ2WGZrTGtiYzlMVWdYQmlZT1BsMmZWeTYweDRtNzJMMGxjV1VD?=
 =?utf-8?B?VU5ya2J4bVYxUloyd0pTc0Zjay9vLzhPeWpNZEV4UlQwdmhxRVJqQmQyVlQ1?=
 =?utf-8?Q?p1xWQaXvSna2SSmCzNgRenoYm/t/O0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N21mcHYwZUthR3hRM0JnL0E3ZnBGZVJnSnZ5bGNZTzd2cTVWZjRjaDFoVWFi?=
 =?utf-8?B?YXhoTEVQRHFsZjRSSkV5YmJ6WlVaT1QxaVpMSWtqYytTWlJwWEJlWjZmc2E0?=
 =?utf-8?B?RVhVZWltanR3NFVab1hLQXB4MjFpcTdyelRrL0VHZHUrQ1BLYXd4QTkwSVpt?=
 =?utf-8?B?dERlU2RDZzJ5V2xqc1VMRy91Z3U4azFTcEV5eWNDTDFvdVY1VDNadkxLZkdl?=
 =?utf-8?B?NzI5MTdkZ1pOSGUvQUZlSjVIUzF4aVl1VEpHcGNoVjlwb1JUUmpGdzM1SlBB?=
 =?utf-8?B?Nk1YZEVJMDY3SS9vL2syaW4zN3A1TlVoRDJ6bnVKNGNhKzJrKy90cXJDMTdY?=
 =?utf-8?B?TDlNcGJCbGo0UG0rekpyOFRoUGpjNGJYNWYrRVA5VTRsdmFDOHdRcjUxeTAw?=
 =?utf-8?B?TWdWZUdJbHE4dG1ra1hrL0JSNUd6M1I5Yi9XS1c1OHFwQUxCemd3R1dEKzAz?=
 =?utf-8?B?SlZxWjhZMmVKMUFHOHZkRmxyTGp6U3oxR1lJVEc1TUJBTUwrYitlL21tcWZq?=
 =?utf-8?B?MWh6Wk55b3dyendjOVlXZFJUb2prVFZmNjJWM3JYTG1wbDZVSG00ZnluR3FU?=
 =?utf-8?B?TldJMWdhV1EvQXBaRFk5alZyWWtMMTJ1RHZQRXk3NTYydnp6U3dKQ1dnbVdW?=
 =?utf-8?B?NzdUQTVpV3kxdUVudUtCQjYzdENTdkVjcjB1NXdWbUR6RGo2ZnJRbDVNdlhH?=
 =?utf-8?B?YXBKMEN0RERiRm10UUpGZ3FJZlZxMnF6TlA4OFgrNEdYY0luSkNHTW51VEhG?=
 =?utf-8?B?Qzl2eThJVXl2c1paN3l1bkhMQ2lTRCtyeENoeWRzVGlCVTFtRDhXemlMVmVp?=
 =?utf-8?B?UTBMMnBmaFhqbGd3bHN5TTZobXZRYldxZ1NvMWZmblQ0dlJZdlNjek1tbjNC?=
 =?utf-8?B?SGptMUFra0lLTzQ0aW1acE9wT2xNNEJOQmJIMTJyZHRqd2VtYlhtbTZIWVc2?=
 =?utf-8?B?WHRmK2JQMzIxQzFMbUVWZkc4aVdFSTR0dURxRlFUaDZFQ0o5b2R6bjNVLzRk?=
 =?utf-8?B?RWkvT2JIMXd0UW9XS2c3a3MvbFM4R3JnVm5iOVRRakFMQmoreGhrdG5DRTcx?=
 =?utf-8?B?bGw5SWE5N1dUaFF2cDQ3SllBRkNIVmhsVmlialkzVXV0ZTlOaldmZGVjdU5O?=
 =?utf-8?B?ZXJFSFBCT2IyTzZXU1NEVE9tc3ZNTkw5YUJjd2kzNjY3dTVjUWtFd2NObEZW?=
 =?utf-8?B?YjE3MHh4eVZnZHFlYXc0OXVBZUdRVmV6bTFYL1l5WlpHUVNXYlQxcVl2dTJW?=
 =?utf-8?B?amVuVWdEb0hRS3ZqdkJZby9UMkNLeHY2a1p0bExVSDMxbXBWcldmaWFWZ0hy?=
 =?utf-8?B?Rkplb2p2Qm02R2hEVGdhODhMZTlQZ0J3UGhsS2Naelp5RXpoM2w5QnBQVEZ6?=
 =?utf-8?B?RzlieUsza2JVT2hEeGtydmFSMFAwT1Z2UFpNcTUvRUJreVUyUWdFcUU2Z3Na?=
 =?utf-8?B?cGxwN296L3BqaERjMExqVjNuQmUrUVl5OVkyOGd6Wm80R1AxRWNCZzN4N05p?=
 =?utf-8?B?VUxNZW8yZngramNmSW9ic05wN29LRzhDN0gzUjA5QmwyQmphOXpTVjU0emhV?=
 =?utf-8?B?b0cySzBOMGNRVTlQM21acncrT0Z3eDlNNGxod3B4WVhUNXlVRGVKUVpxcEVJ?=
 =?utf-8?B?TitMUDJpclZ6dExGREFseUN5ek04NlQzenBXTjllbkRCTCtlU2RlM0crR3pT?=
 =?utf-8?B?UXJCcDMvVTNSb0d1Q1JmY0ZPZncxcDcrZFQzYld3L09lKzdjTWdUNm5mRFgx?=
 =?utf-8?B?amJReXlaL3FmaUczTU1ucWoxaFVvNlpmbUh0aGRXenNJdDd0OVA1SUxIVWJ0?=
 =?utf-8?B?RnVKTDdVN1RJWmN0NVlmM29hQjR5Ui93ZnFQa3VhWlFzQ3RXS0x0VTBobDZW?=
 =?utf-8?B?eC95ZWVMUGhXU0UwYk15UTV5a2tmZ2NXTUpFNkhUdCsvMHZoZGYwUmJocTZ0?=
 =?utf-8?B?YnBqT2Uxd3FScm5WYkpuNzVSR3p3dlNVRkMwU0xiMmE3cGlQYUF5cHNaK2NM?=
 =?utf-8?B?QVdEdEZBcHpyQ0FiRWZkQURaRENkL2t0SmEzd2huamVWRWRZODEyUU4yeUsy?=
 =?utf-8?B?SlZIZ1lVYTA3VVhtT0JnNzJ4bmd1bk41K1hCMlZWcyt6eU5Ybkprb2g0SDR4?=
 =?utf-8?B?MW1XOEJOQTZsYUx0U2dKcUlyLzYvZ092M3MxQUVUVmZiYUloL0dhMFlzSUo2?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EF666491DD9504193B2376CC8A29161@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343ea10b-2703-4f02-2940-08dd9f0350ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 22:51:14.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: duvJr0RTxMfJ15ItKQOWxsk1KmEzwNZT7KO0adFNgiW4jEFeAWabrHGNHDlLodaAklT4VF1vc5XWDtBCR3mTCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8584
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTI5IGF0IDA3OjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1heSAyOSwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0wNS0yOSBhdCAyMzo1NSArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gT24g
TW9uLCAyMDI1LTA1LTE5IGF0IDE2OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3Rl
Og0KPiA+ID4gPiBBZGQgYSBLY29uZmlnIHRvIGFsbG93aW5nIGJ1aWxkaW5nIEtWTSB3aXRob3V0
IHN1cHBvcnQgZm9yIGVtdWxhdGluZyBhbg0KPiA+ID4gCQkgICBeDQo+ID4gPiAJCSAgIGFsbG93
DQo+ID4gPiANCj4gPiA+ID4gSS9PIEFQSUMsIFBJQywgYW5kIFBJVCwgd2hpY2ggaXMgZGVzaXJh
YmxlIGZvciBkZXBsb3ltZW50cyB0aGF0IGVmZmVjdGl2ZWx5DQo+ID4gPiA+IGRvbid0IHN1cHBv
cnQgYSBmdWxseSBpbi1rZXJuZWwgSVJRIGNoaXAsIGkuZS4gbmV2ZXIgZXhwZWN0IGFueSBWTU0g
dG8NCj4gPiA+ID4gY3JlYXRlIGFuIGluLWtlcm5lbCBJL08gQVBJQy4gwqANCj4gPiA+IA0KPiA+
ID4gRG8geW91IGhhcHBlbiB0byBrbm93IHdoYXQgZGV2ZWxvcG1lbnRzIGRvbid0IHN1cHBvcnQg
YSBmdWxsIGluLWtlcm5lbCBJUlEgY2hpcD8NCj4gDQo+IEdvb2dsZSBDbG91ZCwgZm9yIG9uZS4g
IEkgc3VzcGVjdC9hc3N1bWUgbWFueS9tb3N0IENTUHMgZG9uJ3QgdXRpbGl6ZSBhbiBpbi1rZXJu
ZWwNCj4gSS9PIEFQSUMuDQo+IA0KPiA+ID4gRG8gdGhleSBvbmx5IHN1cHBvcnQgdXNlcnNwYWNl
IElSUSBjaGlwLCBvciBub3Qgc3VwcG9ydCBhbnkgSVJRIGNoaXAgYXQgYWxsPw0KPiANCj4gVGhl
IGZvcm1lciwgb25seSB1c2Vyc3BhY2UgSS9PIEFQSUMgKGFuZCBhc3NvY2lhdGVkIGRldmljZXMp
LCB0aG91Z2ggc29tZSBWTQ0KPiBzaGFwZXMsIGUuZy4gVERYLCBkb24ndCBwcm92aWRlIGFuIEkv
TyBBUElDIG9yIFBJQy4NCg0KVGhhbmtzIGZvciB0aGUgaW5mby4NCg0KSnVzdCB3b25kZXJpbmcg
d2hhdCdzIHRoZSBiZW5lZml0IG9mIHVzaW5nIHVzZXJzcGFjZSBJUlFDSElQIGluc3RlYWQgb2YN
CmVtdWxhdGluZyBpbiB0aGUga2VybmVsPyAgSSB0aG91Z2h0IG9uZSBzaG91bGQgZWl0aGVyIHVz
ZSBpbi1rZXJuZWwgSVJRQ0hJUCBvcg0KZG9lc24ndCB1c2UgYW55Lg0KDQo+IA0KPiA+IEZvcmdv
dCB0byBhc2s6DQo+ID4gDQo+ID4gU2luY2UgdGhpcyBuZXcgS2NvbmZpZyBvcHRpb24gaXMgbm90
IG9ubHkgZm9yIElPQVBJQyBidXQgYWxzbyBpbmNsdWRlcyBQSUMgYW5kDQo+ID4gUElULCBpcyBD
T05GSUdfS1ZNX0lSUUNISVAgYSBiZXR0ZXIgbmFtZT8NCj4gDQo+IEkgbXVjaCBwcmVmZXIgSU9B
UElDLCBiZWNhdXNlIElSUUNISVAgaXMgZmFyIHRvbyBhbWJpZ3VvdXMgYW5kIGNvbmZ1c2luZywg
ZS5nLg0KPiBqdXN0IGxvb2sgYXQgS1ZNJ3MgaW50ZXJuYWwgQVBJcywgd2hlcmUgdGhlc2U6DQo+
IA0KPiAgIGlycWNoaXBfaW5fa2VybmVsKCkNCj4gICBpcnFjaGlwX2tlcm5lbCgpDQo+IA0KPiBh
cmUgbm90IGVxdWl2YWxlbnQuICBJbiBwcmFjdGljZSwgbm8gbW9kZXJuIGd1ZXN0IGtlcm5lbCBp
cyBnb2luZyB0byB1dGlsaXplIHRoZQ0KPiBQSUMsIGFuZCB0aGUgUElUIGlzbid0IGFuIElSUSBj
aGlwLCBpLmUuIGlzbid0IHN0cmljdGx5IGNvdmVyZWQgYnkgSVJRQ0hJUCBlaXRoZXIuDQoNClJp
Z2h0Lg0KDQpNYXliZSBpdCBpcyB3b3J0aCB0byBmdXJ0aGVyIGhhdmUgZGVkaWNhdGVkIEtjb25m
aWcgZm9yIFBJQywgUElUIGFuZCBJT0FQSUM/DQoNCkJ1dCBobW0sIEkgYW0gbm90IHN1cmUgd2hl
dGhlciBlbXVsYXRpbmcgSU9BUElDIGhhcyBtb3JlIHZhbHVlIHRoYW4gUElDLiAgRm9yDQptb2Rl
cm4gZ3Vlc3RzIGFsbCBlbXVsYXRlZC9hc3NpZ25lZCBkZXZpY2VzIHNob3VsZCBqdXN0IHVzZSBN
U0kvTVNJLVg/DQoNCj4gU28gSSB0aGluay9ob3BlIHRoZSB2YXN0IG1ham9yaXR5IG9mIHVzZXJz
L3JlYWRlcnMgd2lsbCBiZSBhYmxlIHRvIGludHVpdCB0aGF0DQo+IENPTkZJR19LVk1fSU9BUElD
IGFsc28gY292ZXJzIHRoZSBQSUMgYW5kIFBJVC4NCg0KU3VyZS4NCg0KQnR3LCBJIGFsc28gZmlu
ZCBpcnFjaGlwX2luX2tlcm5lbCgpIGFuZCBpcnFjaGlwX2tlcm5lbCgpIGNvbmZ1c2luZy4gIEkg
YW0gbm90DQpzdXJlIHRoZSB2YWx1ZSBvZiBoYXZpbmcgaXJxY2hpcF9pbl9rZXJuZWwoKSBpbiBm
YWN0LiAgVGhlIGd1ZXN0IHNob3VsZCBhbHdheXMNCmhhdmUgYW4gaW4ta2VybmVsIEFQSUMgZm9y
IG1vZGVybiBndWVzdHMuICBJIGFtIHdvbmRlcmluZyB3aGV0aGVyIHdlIGNhbiBnZXQgcmlkDQpv
ZiBpdCBjb21wbGV0ZWx5ICh0aGUgbG9naWMgd2lsbCBiZSBpdCBpcyBhbHdheXMgYmUgdHJ1ZSks
IG9yIHdlIGNhbiBoYXZlIGENCktjb25maWcgdG8gb25seSBidWlsZCBpdCB3aGVuIHVzZXIgdHJ1
bHkgd2FudHMgaXQuDQoNCg0K

