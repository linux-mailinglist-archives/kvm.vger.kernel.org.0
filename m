Return-Path: <kvm+bounces-61122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A07C0B5A4
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 23:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ED29434A5DA
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 22:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A332D9492;
	Sun, 26 Oct 2025 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RD1ETJX2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442CB286430;
	Sun, 26 Oct 2025 22:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761517475; cv=fail; b=PATuHjgx0DdJGighTbJ+QQCCsEsBwgqrFBxOcIt354gXNSmuqBhBARugS6NJcV8abnzGg+tvyxjkYlyi3uiqdagYFTfm3/nnkPgTV602t9LTGoPBUij0pO06+e0r6J3c7+ctAyd5deDrXdv1jj/sM5bP4Ps3zCEzITxFhdgd2bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761517475; c=relaxed/simple;
	bh=+FDQJ5SONuoOx9VxbEyyaVketTx5OEdltZpL2KyPA0Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uAtpbjiAIZp3cI5ngSpiHtx1s5M9PaN9Ln4I0cN5iK6pLxYp76kAadW0IkWaV/aX1WMkT46VSw09VmXozUk7HuAWGZdeNHG2P74nRPbwFGyiveM0i3zjpb/9Vx5jDEBhqPGrxdswgSvyRXPhZxvT5GmnPbCtI76YjyG2npauTQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RD1ETJX2; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761517474; x=1793053474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+FDQJ5SONuoOx9VxbEyyaVketTx5OEdltZpL2KyPA0Y=;
  b=RD1ETJX23gDqf5YnmNIYXoX8l0bBmqtmXtFT8Ow0ZgeMLa2M+JeGQ6X2
   56RSrAb2x7KxVipK/hqxwC4a0BRUT0aiNyCbRd475trMjXXW60OxzY2g5
   OwOU47H1uLI2Z3kPHyJj4bSj2QyX1mt9x1QBmFtLT1oMBzo606jrCgkvh
   rr5XQyWOa8YdB3l7DNzjmkEOw4uALUNUKY7Iqg0HoqZ7xhoNevqsRSOIm
   N2gk8CneGhUK6iEMOipO8LQkl6lPHGjQubY5RrNLtuYh7sofqCT6NykRO
   D9xCKJqeAxrT9eMuZf9og73a9x6hxm4A9bJ6uiiBM4kUp7vgjcvv61dcg
   A==;
X-CSE-ConnectionGUID: 80yduY/fQXasZXjeSAHf/w==
X-CSE-MsgGUID: 7as4xHuzTh6n7JuJim3ZRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63493358"
X-IronPort-AV: E=Sophos;i="6.19,257,1754982000"; 
   d="scan'208";a="63493358"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 15:24:34 -0700
X-CSE-ConnectionGUID: bV+9a0CrRnq+QscZMjJHRw==
X-CSE-MsgGUID: aOjJDItiQnOcP+E5nitdFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,257,1754982000"; 
   d="scan'208";a="189203108"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 15:24:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 26 Oct 2025 15:24:33 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 26 Oct 2025 15:24:33 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.32)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 26 Oct 2025 15:24:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAEZ2CJ02MNYVZDpU39L/7VxnGUDtIzL+6zjp8nllTjQtIFU+J96RiIvSeZjEKS15t8JlLjOm/aR0zw4RgKEAD1TMU4LAbvb0jIQ4UJO7Lu/Zeim7de+VdhOMBgO2fspmkr9xZwZTuRXiy3Qd7fazOx1XM2gMvISWwFtOkREJLCO2PUGEE3/LPxvDU6fT9sn4g+6ruvLvLdBDx7+S9XocaAkWRStmx3FYQSrXd9RNWJI7+XFoMZe5XfVj1ohsjshF/N32gTNcJhN/zZzrqDmwshDeX63L1tWEvPocuiUcbBZ3UcQfvUhmaP3ALAs0Aqxt57abRl0hb2zNXxLuXns7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FDQJ5SONuoOx9VxbEyyaVketTx5OEdltZpL2KyPA0Y=;
 b=hN0sODHj8amyuKPlCXiVyVWFuRWYJQLWEXBSOu/UefEAAWIISn31C+dboWGe2j2HlKlrUFUqTUtLVqRy/5xUiANRmRk7y6vchLAVgy9nXilekIs1blYgyMiOhmdNZFf0Nz/QDIBWUDCTpmDn8vdPP1hOMLGB1ols4cWgJL2v0hCGbtx6PoESk0atYoloDWGayjoqm/ul8eG9j09YiBUvokeh2OgRlfLt9AJuiR3K0NT2Lc5FjopDGCckQIXqDarwyLgrr2e0NWEr4KIqpnhduRNLN4gfbx9uaCeSCI+QZzAY5yt0Y4/KLnqMHZQaJsDQrAM+7jfIcIZKg712NFg9+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7778.namprd11.prod.outlook.com (2603:10b6:930:76::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Sun, 26 Oct
 2025 22:24:25 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.017; Sun, 26 Oct 2025
 22:24:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "sashal@kernel.org" <sashal@kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "mingo@kernel.org" <mingo@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "coxu@redhat.com"
	<coxu@redhat.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"x86@kernel.org" <x86@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "alexandre.f.demers@gmail.com"
	<alexandre.f.demers@gmail.com>
Subject: Re: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Thread-Topic: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Thread-Index: AQHcRcumqtsA743H90KS4YZNwnQICrTVAvYA
Date: Sun, 26 Oct 2025 22:24:25 +0000
Message-ID: <834a33d34c5c3bf659c94cefc374b0b7a52ee1a6.camel@intel.com>
References: <20251025160905.3857885-1-sashal@kernel.org>
	 <20251025160905.3857885-288-sashal@kernel.org>
In-Reply-To: <20251025160905.3857885-288-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7778:EE_
x-ms-office365-filtering-correlation-id: 91fbafdb-2db4-4f6e-029d-08de14de6bc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R3c5cWkwa0ZoRTBTRHVNcG1ZSitYdENZaHhUUnYvd2hkS0xsVG9OWkE2UTNP?=
 =?utf-8?B?ZWl3Mk0rVkRxcy9XbTRLSnpxMWJkMWpTaHpBeVQ2cXdua0tTcG8zZ09yTkNJ?=
 =?utf-8?B?dzl5UVRseHliMk8zRi9jcTVMV2ptUzhEMlp3YUh4ci9nZTZxb1NhUkhSQVZu?=
 =?utf-8?B?Ykt5RXA5KzZKTjBqU2VMdHYrb2haR0h6THdaa1RhZ2FjQ1F3L2FhRWFUM3hI?=
 =?utf-8?B?aExhU0w2NHYwbFgzMnhubXpsTjQwWDZpaW0xenN4K3ZRWWlOWEY0bGZnSHox?=
 =?utf-8?B?YUdRblZ6Wm1TcC91ZWJJblFnblhGWDYycUIyem45NERubTR1cWtyVXBFbHlB?=
 =?utf-8?B?WFZ0Nm1GQXBtS1Z0NHFBYy9TZVp1U2JhSVlCcklMZDdPQ1dIbFpROGZZZ214?=
 =?utf-8?B?TjlKQ3oxVFdQUWM3ZVhGSUcwS1ArMC9kTnNqREtTaENvSkw4OXRsSmlSdkF2?=
 =?utf-8?B?ZXh6a2tYclVmVWNaUGwzbk1HR3JrTEpUVXRhTklzMkZ1NTBPdWNCVTNoZU9z?=
 =?utf-8?B?aVJkZ2lBYVlXc0JvWlhUczlqallzY2RMa2VVbTVBSUNib2ZHYkVYanMxUEVZ?=
 =?utf-8?B?TTdoS256ckkvaHZDUVh1K0FDS0dJMmhLaVNDR0dmTjkxU2F0eUM1QUhjOWU4?=
 =?utf-8?B?T1VnUHUzUmt5RTJ2bERiNTFUdld0dU5vQlM2OEF4Y0IweWMya3JnUHZ1eDlP?=
 =?utf-8?B?QVJTNTNOU015NGxvTWhsMzdjdFRWRUIyaDk2ZkdzYmV0Unl3L1ZLT2JkbTRF?=
 =?utf-8?B?MDNEajdGWWZ6M1NyeGw0UktTSk9tcnBzMzVtY0s0dEgvRHlNdVJoR1I1TzNK?=
 =?utf-8?B?WDZyOU4rZWEzdXViMFpTa0RqclkvY2NSZGNKdUErdXhQUzhRY0VyVFJQVFBn?=
 =?utf-8?B?SXU5YU9zMWhSS045c3JrNHcvYTlQT21VWUZHVVVNc0pLVnJwSGVNQTNJQ29D?=
 =?utf-8?B?aUloSFZ2d0tVcTZYcmhMeEFjT3BkcjRCbFRqVEIweVRkR1RlTnBjbVc1dzMr?=
 =?utf-8?B?bzNYbTdsUlJTOWs4czNVeGZQN2FHN1JBQ0ZUSjBTeldROGlUNFN3RzhhbEl4?=
 =?utf-8?B?Q04zRkJaaTY5dzN3MEt4Si9MK1VWb050M2F2MlJmWnpEaTFGQjhWdm1oeGZs?=
 =?utf-8?B?SitHUHRxSFAxMyt6d25lazMvY1BiMFZnQWtBM0g0RjljQVZlUWVKSmN3QTFr?=
 =?utf-8?B?eEN2REk5WFdZYWF0U3dncnFBNENyNCtJR2tiaEp3TVFmSlFLQTQweGU0cktP?=
 =?utf-8?B?OVBLb3cyTHBwTHJoeURKK3hCS2t1VTdWL2IrRkdhVWE0cDJCdmdidEwzNG5F?=
 =?utf-8?B?RmJYUGVFQktaRjlxdVNDVDhLQ1UzYXpKUU0wY002ODA3VXpuQ25NMVVhRGN4?=
 =?utf-8?B?bDI1MThoUFNwRnZrUDR2K0RoSml5UGtmajJmcGU5elRRY2w0TkpPMFpPdkto?=
 =?utf-8?B?SVJXU2M1WjVmWTFQYUdzTXpCcFV2Vy91WFVFVW44YzdhOC9nM0dvV2h6WTd1?=
 =?utf-8?B?eWh3ZkY4anhPY1NVWkVoSFdBbUIvazZNRjNKRG05c3ozNjFobHEySDdLWVJO?=
 =?utf-8?B?dmwrYnorME5Ud0JhcEpRODlUZjJPQ1k4YmdXcWpoNmlkeUNMMVMvcjB1WndD?=
 =?utf-8?B?amdYTnBTbjBjQkVtZHlhWVdaY05sQ256WGR3NzFmRWdDOURXWHRvV29zVHRU?=
 =?utf-8?B?SVNFeFZaSWxVTUsxenRuMVYyTlRvbm9JeEFrZ09GQ3EzZFlJNHpCeSszbDNM?=
 =?utf-8?B?dlhUb3FiMWxZaCtEZmFBbStvYld3ZWh5WUx4Sm5xaEV2RWFBdG85QWdKTkh4?=
 =?utf-8?B?cXBhemdRZW50KzJXTjRKcXA0ZktmN0gyaExkeDBZL0d5YjNuOEtyK1h2Qk5Y?=
 =?utf-8?B?NXk5eEhKQ0VtUHYrQWx2NFpQdWZOdG5nWjUzWHcwaHoyOWExOC9GU2hIbkUz?=
 =?utf-8?B?Q01JQ0JXVldjQTZBWTN4TEJGTlRsY2srM0ZMYzdZamtXeDZHeGppWWZyYWtU?=
 =?utf-8?B?NmRBc0E1WFFBa2NqblcwbVBKRWdVaUJmMjJzSU92Y3FqbWhGQkducUFpenY3?=
 =?utf-8?Q?yd3+eA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkI5UWFXWDJ0b2VNR28yclFERWViL3pSNVRnQlZDTXI1RW5xOVd5WWJYTmdX?=
 =?utf-8?B?WW5BYUlFc0RYWUFwc0pVUnQ3L3pBanlIblFzdXFEY1VYMnZjQlBjendEU1B6?=
 =?utf-8?B?TWV5QjlrSXRKdXhKMU5jdzVUWmJpQllyRTFJV2MwUHJzQTA1Nk9DREduZzBx?=
 =?utf-8?B?bk1hZzhRVHBvZk1JKzR0VFB4d3g5a1YzbWNvWG5hTEZsYWRURkFhZldiMlZQ?=
 =?utf-8?B?aE1IQ1dnUXkxZXQ3L05UcC84cU1TUytISFl3OEhyNjZHZUtHSndVLzZ4K2pU?=
 =?utf-8?B?Vkd1cVlUSnZFbXdyUTlFdFVSbCtnODB5Vm9ZYnQ1UVIyRWRPYWI0clo3TGZW?=
 =?utf-8?B?NTh2dllnTFFMTVpOMWF5VC9UZGhUOW9Vc2VNclY0RXI3My9NaVdaaW91TkNx?=
 =?utf-8?B?eTJ5Q3JEMGtRUWFPSlVIT1dCRjhCTGxMdXJONFFIdGhBWEUwOENNSE9OUHJU?=
 =?utf-8?B?MCs3OVpSd1hQRFIxa2xnOVV4eGh4N3ROaHFpendHc2R2UG45MXBCMGN6SzBu?=
 =?utf-8?B?cmlnaE1Rd3RNdmswVVREWGRRajMxU2FzbysrNjFZTDlWZThRZ0wwYVZqVkJn?=
 =?utf-8?B?TGYreUtZa3dNcCs1YVNxUHZPSm9BSmxGemJEZFZpcXpMWEhCVE1YdFBGMzAr?=
 =?utf-8?B?aTIrOS9aNUVLdGZ6bzFaWk9ENUg2NzF5M21VaWlra3FKdmhKV2JLVUljaG91?=
 =?utf-8?B?ay9FbWRCVFQ1ejFTSzJPUzZEelUvYzYzOXJGS1BJeC9heTVPQlZSUTRmZTlP?=
 =?utf-8?B?Z2xWV3ZiWjR4dGUzbForUk5kZVBuL09VdVdSQUdBVUlGc3ZBazNkNUVLSGJu?=
 =?utf-8?B?S2kzazA4WWNZUDJnQjFkRjBTaHYxRXBHWDZEWUV4Yy8ydFJ1Z3U5WDFtMGx6?=
 =?utf-8?B?SmhFTWRwZU1GM0grVnUxd2RrVm9ZUlZxc2QxclhIVTRVSUh4cnRuM1MraS9K?=
 =?utf-8?B?cStHc0J4Z1pQcmxCbHlKOUMxeEk4cWU2eGpkaE1PWWhoZ0ZtQXJoZll5OEhD?=
 =?utf-8?B?ME8wczBzVUlEZlRkS01VT1VwS2NVcTBPTkRMdEtSWXQrRG43L215N1pidjZZ?=
 =?utf-8?B?a2Ewd1B1OCtYMjhQK0hCWEFsRUpxSlUxUFdUWTk0UHltcmU4bTVwcmxsNWNS?=
 =?utf-8?B?SGdQVjkrelQzLzFmVW1JTVA4NmozTEU5SnBCQ3JHU1kza3BINVEzbmhWb1Ir?=
 =?utf-8?B?VGl2bHJnUWR2Rnl6K1VCcGYreFc4NkNzM2JSQ2JwTVJXSGdWR0x6MkpFZjhM?=
 =?utf-8?B?MlppYTRpNU5McndMRW5OWEFZN1JLNnZQUE5PekliODJFc0o3ZVlyRTQ0c0d0?=
 =?utf-8?B?WmhrMS9HUDE5S1JWTnhJYy9EY1l5TnBnWGZJUWZSUEZOZyt4NVhkTTRIQWNU?=
 =?utf-8?B?all1Qk9GZ1dQeE9vQlYyVmUzWVVwd1VJTDMxbEJWSWQxWmpNRW9nL3JnY0xW?=
 =?utf-8?B?MGptY0F5VTJSbGFuejVIK0hPTzdabUhmR3ozNktiYUhMbkxTUnRJUFVnbzNC?=
 =?utf-8?B?N0w2OTFrN3hhZXprRHZBMlF4aERqeEszVjZ5emt6RmJBNzJ6SFo2TWp4WjZG?=
 =?utf-8?B?U1ZRU1VpZlh3UkV3eUdSc2QyY0tISksySjZpNE5IaWJqV0ZzNmhvWTk2dXZp?=
 =?utf-8?B?bUZWcmk4ZDV3cURnMHkyTmFnR0ZoNjIxTVJYZmlZb0NPcnZSRllRYzRVNXFG?=
 =?utf-8?B?N21NZ3l6VnM1M0g5NTBUamJWUTdOTGlTWFpsOXFxQjV3MEpRSmRSSlJ5UVl4?=
 =?utf-8?B?UTI1K0FuMnpYS2cwc2dKQzRrS3JWSEVuTFZ2MXFORFpUYUczU1pGcTJJNVZM?=
 =?utf-8?B?MlB1WHhGN1JFb0c5NDY3c1ROVDdJNExxcUM1OUk0bTFWTlNoYThtTWZFWWJU?=
 =?utf-8?B?R1hJNWJ2OFkwWExwMlo2Y3J5UXU1b3JlTUVsakVFSURubGlxQmptbUVmd3dX?=
 =?utf-8?B?bGR3NlR2Vlp1UmtreVE2aXBVWlBRcTdqZjdieXhyZVg5Sm4rVjhyUFlVRmZz?=
 =?utf-8?B?RXkrQzUyV3pSVCs1R3JtN043Z2hTTXhzdE1EN2c4MzRFTC9YRUY2blRlck5x?=
 =?utf-8?B?cUhyWkI2TTNjTnpKTHFNVGZ5R1pwRytNNlB2aFlrNG9saVNhQmxydTU1b2Ux?=
 =?utf-8?Q?BgAlXD0UM96jaDy4cHDgRgmPv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <885ACCEC1CEF284DBB9898F26A9F3995@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91fbafdb-2db4-4f6e-029d-08de14de6bc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2025 22:24:25.6395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wBOpxORgN+D/07hI2OAvkC794NnNCNTJ/EmXHuu1wmeQ04xKcMkBItRNOJAzhmNfrBHYLjXztMq96wPMQsT/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7778
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTEwLTI1IGF0IDExOjU4IC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
RnJvbTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4gWyBVcHN0cmVhbSBj
b21taXQgYjE4NjUxZjcwY2UwZTQ1ZDUyYjllNjZkOTA2NWI4MzFiM2YzMDc4NCBdDQo+IA0KPiAN
Cg0KWy4uLl0NCg0KPiAtLS0NCj4gDQo+IExMTSBHZW5lcmF0ZWQgZXhwbGFuYXRpb25zLCBtYXkg
YmUgY29tcGxldGVseSBib2d1czoNCj4gDQo+IFlFUw0KPiANCj4gKipXaHkgVGhpcyBGaXggTWF0
dGVycyoqDQo+IC0gUHJldmVudHMgbWFjaGluZSBjaGVja3MgZHVyaW5nIGtleGVjL2tkdW1wIG9u
IGVhcmx5IFREWC1jYXBhYmxlDQo+ICAgcGxhdGZvcm1zIHdpdGggdGhlIOKAnHBhcnRpYWwgd3Jp
dGUgdG8gVERYIHByaXZhdGUgbWVtb3J54oCdIGVycmF0dW0uDQo+ICAgV2l0aG91dCB0aGlzLCB0
aGUgbmV3IGtlcm5lbCBtYXkgaGl0IGFuIE1DRSBhZnRlciB0aGUgb2xkIGtlcm5lbA0KPiAgIGp1
bXBzLCB3aGljaCBpcyBhIGhhcmQgZmFpbHVyZSBhZmZlY3RpbmcgdXNlcnMuDQoNCkhpLA0KDQpJ
IGRvbid0IHRoaW5rIHdlIHNob3VsZCBiYWNrcG9ydCB0aGlzIGZvciA2LjE3IHN0YWJsZS4gIEtl
eGVjL2tkdW1wIGFuZA0KVERYIGFyZSBtdXR1YWxseSBleGNsdXNpdmUgaW4gS2NvbmZpZyBpbiA2
LjE3LCB0aGVyZWZvcmUgaXQncyBub3QgcG9zc2libGUNCmZvciBURFggdG8gaW1wYWN0IGtleGVj
L2tkdW1wLg0KDQpUaGlzIHBhdGNoIGlzIHBhcnQgb2YgdGhlIHNlcmllcyB3aGljaCBlbmFibGVz
IGtleGVjL2tkdW1wIHRvZ2V0aGVyIHdpdGgNClREWCBpbiBLY29uZmlnICh3aGljaCBsYW5kZWQg
aW4gNi4xOCkgYW5kIHNob3VsZCBub3QgYmUgYmFja3BvcnRlZCBhbG9uZS4NCg==

