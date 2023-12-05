Return-Path: <kvm+bounces-3455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A89804A82
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1350E2816C4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 06:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A477612E68;
	Tue,  5 Dec 2023 06:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R1+o5MUC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445B9D3;
	Mon,  4 Dec 2023 22:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701758727; x=1733294727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vnO/l0kmGjggmnjR6H5CzA0tIAUCMFeTA1ep0/eUD0M=;
  b=R1+o5MUCOu4/7LUiaCspEUf6jIavx//FKoCbQ3StE2G3gnQk8+nHsres
   zhjrsBocfPbQYmn84TrDYOIwRl/4kx8Ppg/9Cip6XjenqHe0TeC0me5U5
   vlxaaMef4aXRVqkNtvj4FNEeo8b0MbyjbKK54+dPjBny0uXdb8WH3hR9S
   UqmO583xogLr0t9D3qz4k/HefjIrGifqw6+/VKEaDP1fyN2f+5tsTjGHr
   eVcuoI994rgxCJHRrL4EQWU5wN7SUCqJ0cTU0yrCM708dApHw3cKq6sTK
   SGeTZuz10Aet6Iqip1qHqE6DVj20zh6cIsMEUtY3FziO0qkCoLd14dhhS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="396647797"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="396647797"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 22:45:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="12227964"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 22:45:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 22:45:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 22:45:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 22:45:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Dec 2023 22:45:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoUiMY2G8GsCaOkn0C7FEUeLGPteA/fLsJySID2doiJInwIUqbXQobviET7E0EDCDH2kTMsK5IB0NVY52tW70/KZjJHrMD5Ch3otporEnmuybLobTJNXpPRYaC85U66EqwH7G4odZvTIZMg9h6tRsREgWWUxQRIak/IdFZCbhCIJmBs4ZAu9xRdrQZL08U+UHHDfFb+u+TvPc71TpSUCxyo6fLrdrnXQIgPdOtFJ7rFRNlseA94gZUsgbwbqOW3yq7mLEZmpAinx/6GeVPf9xUF+yFoGbBB4i2I4/gkfrkqFT6rWDoMd2hbRlXQS5CS8IYhZNGu6D9QxrNwtzm81lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvdPS+9uWXI+EJq/k3ETApJeS6Dt7opu7SPqwybY868=;
 b=dL0R+QCvK+L0OW5kxx8+jRHvR88lRZss0ysOy9dObBXBMuExl8Uq9mo//h1VrBfhQhc1dEODI1aC97MrDOLeMyRcvL7CiC838pB9Q7fPvRh9S2WyNNGACR+J/izrTww/t8XpmJyC2zgi6cmKtiM1CXT3EGtnlL1Remi7RDvo4x+y72RpRayI1F3ickIdLzhKjoNLCwtGoKOu2tRg/3S68uW4zO/gd/PNXVuiypp+iBxzK+IkO6PW+S2xdUcGYVM71HG4BTupTiJRSdn8sn5JaS+6/PwzEgm5eQRUa4D5vaPBa1kNTEbkw1deQRvhYlJ/XNpC6sUUoSzjlD81PSYpGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8349.namprd11.prod.outlook.com (2603:10b6:806:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 06:45:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 06:45:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Thread-Topic: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Thread-Index: AQHaJQO3kBR+d+LKkUe3K6mDC1fRXbCZPU8AgAAZOoCAAJUZAIAAU9Pw
Date: Tue, 5 Dec 2023 06:45:22 +0000
Message-ID: <BN9PR11MB5276AE6D59274C528F91781A8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231204150800.GD1493156@nvidia.com> <ZW4AeZfCYgv6zcy4@google.com>
 <ZW59jO6FIVHI7Y6J@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZW59jO6FIVHI7Y6J@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8349:EE_
x-ms-office365-filtering-correlation-id: 2edbabb4-8a31-478a-e8e9-08dbf55dc16e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zssJa+eLKAI/jl43piheGixSZFbELSycj7RyOlMW2eutbK+noivu8wjkr85TUEwKzkAGJ6HsD3+oW6Qh0aWo7g10dr5zhCxhLWvIcHQZH94FEtGyzDy29Sz42D46S/qA70ni7sJbh/Gp42N0Sg/1V7JS9+tPyOuAYSWNe9q/FBKBZ32QNtwxQa8U6JlO2jjSFRD0rGyS9P42pXdjKgpsVIeBTaoRWkDHTKQycrL8e5FSNQ/KbcuvmbxucRS6asE7t+aTi9IL2a638rS8rVjrUEATm6gtqN2sCkO7xzYhI7dKo53erpN+xbTZlNH5mzxAeyqNWnBth1TIkQCYwK7788c2lRVOz8gGZ0EhVWZrprE2TyvGqINGPGSkA20T8pL8l6UltmKfPZ+zIvkIzzYaCnwKXrz6N70QSiyP3YNrlQsnv9bce1baWEej4iXvVqC9rYtWwiuqs2lfPVWL59hnqY9wq6i7LjKl/BvNcPSGU9RlfIciEfLNy2j1eeWKwat73uD6NIdHKkblURsN8j1BZ8IS7+xeljuF4YjDebnrzs8JPGhxfASqByJ0rhVM6B7NWgKrpKlo92kmbzJFFg3Cw9mfJZo2f1XjpVFsnOjN4yM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(346002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(5660300002)(52536014)(7416002)(86362001)(4326008)(8676002)(8936002)(2906002)(38070700009)(41300700001)(33656002)(9686003)(6506007)(82960400001)(478600001)(26005)(7696005)(71200400001)(38100700002)(55016003)(122000001)(110136005)(316002)(54906003)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Gi4t1NDP0rLPUEX91hHAKDwh5LC4Pw8VYJHnIgb3cOUam5miKooPIzAvHaC?=
 =?us-ascii?Q?JuavHrzY7G0deIZXZsTeYwXOpOMBcmmK7CXftaPpe8O+w4TTx01m27/m1FdW?=
 =?us-ascii?Q?YOzXc/2TNoagFUQWBtpKh8aoUv6mYFHp3GJ4FeFTcDXl8QECVKeZcsIcB4GG?=
 =?us-ascii?Q?GL7GlKTzKDPY/76BDTdGgH685eXl6vJAr/hZ5au1dW8vTlb8XGrZg2jMA0/L?=
 =?us-ascii?Q?X1x17kWz2pklVlK1RzRGTfzok9B19CkIkAm40ugIbF07+lFU1mifpCvY65p0?=
 =?us-ascii?Q?PCPlVpp/Knb0sZ2vLoK4AAZX/46wEP/N2L0JztyPEZ5QoIvwkD9A0vT266v6?=
 =?us-ascii?Q?9CJGgTGTx94xMYpyejC6G9jEuWfOx7cNATbQz8GU8dBPbPNn2u0LBOVfmx3b?=
 =?us-ascii?Q?rA+VVMCvU3j5CVNIMp0phWZj17eaE0hd2rliXTtp+gBMhsKBMY3OTEODhRDm?=
 =?us-ascii?Q?7DixgIPAS6YLZqtAarTJqvTkgKJC5D64cAqwOatVIBtqIya+dBYOkXJo6hKA?=
 =?us-ascii?Q?TiwsYXfZHAdU5n7iugT5674JzO6NRbVfUYSNuMDeoKp7kWPHGOLRWb+bwPw8?=
 =?us-ascii?Q?OY1C+aFU4CsNr/2JI/TMjR4MFvaeSUBwKQow2fMJKDT/ao29OKHDTBloL7lI?=
 =?us-ascii?Q?FlaNpbuydrz7sqbsjh6+roM/e3zDWuqjY5rwRQjpCu24GPGRnbm3IptDoQCB?=
 =?us-ascii?Q?tOzYrNP0KrRSrGTp42rr6zK/aXzspJrSV/ucmMW7Gy9GX2SGj7rhdGFye2RS?=
 =?us-ascii?Q?W6XPEGjzyAsRXtcFSbzUTCisCbNVC72D3YNhHZcu0yhxELq6JNvYHL55AfGh?=
 =?us-ascii?Q?nS1GuSGIOSmQBfeCjRbl//Fy3jkHRmH9vHOmv26Prgj6BGMX/5SMAPAi88n2?=
 =?us-ascii?Q?CYWq139umPskgiHSeeNIbFGdB1aSzEzitIMUVlyWbzuvX+QxfDL3SzQMELlg?=
 =?us-ascii?Q?1ksGprTefKONcnkL6ockuQKg2RsARYvO9NrTya0xf7s4V3QYouqGliqfbeio?=
 =?us-ascii?Q?TXlLuT3Defax69vYivGefSay19MPkT7tAWJN1GYmfL9/jKC19W8DkUIVAQbx?=
 =?us-ascii?Q?GkmZiluQ2YfOHlvexW+9HAg7t9Zy3vKnP2UI+VKVCE3CavlTsAZ/wy7pfBHO?=
 =?us-ascii?Q?s6twc1lDkIaYgOhmtdzdvfr9wATyNirrzVcQ19EgXAV7mwzfXVC18TPZK1QS?=
 =?us-ascii?Q?aJMBlciPG0yGQzWC5P9bGmKYK1UeMCdXPwONZJ9FEr7xEEuIeR5QABtOqN0W?=
 =?us-ascii?Q?2PoDXyRMvPwArkI85B6xGEtC3qoTalnWVkLx6ot4/YVkzJ0z2FiHmt6iNgs6?=
 =?us-ascii?Q?W5ntOSQNk4nuO8Xe0VYxb73dbUSCHRQZYlB2ArhT+24/wHDxqJI/E57YVzSi?=
 =?us-ascii?Q?aSsB4qFiTAZgzDB2E2DUyr6ZMTipp+BRLGWdSDryX4RAh+L/qlnXXjUNyoIG?=
 =?us-ascii?Q?cbzKADZpxr1v3Ed0SwHLQPhgOtPsaNTXikE0+ymDSwzN45Y2uHSxpO8hBSp3?=
 =?us-ascii?Q?VjtbI7BlB8XdMRgNZstDi+J5DiZq3JEAMYy9Cs84hNixFo+r+p1fj3MUJput?=
 =?us-ascii?Q?MLgWCny17hCPlzs4MP4vT5mdUCo+EoEPH6VWFMOL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edbabb4-8a31-478a-e8e9-08dbf55dc16e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 06:45:22.8596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BYe+psa/TvlBGhGp4YEPtYO/EYqFUrIbn8AjS2NN0bueHut55yudN/3VqqevDxHULrOLbRpHdUzowWwW6KvKdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8349
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Tuesday, December 5, 2023 9:32 AM
>=20
> On Mon, Dec 04, 2023 at 08:38:17AM -0800, Sean Christopherson wrote:
> > The number of possible TDP page tables used for nested VMs is well
> bounded, but
> > since devices obviously can't be nested VMs, I won't bother trying to
> explain the
> > the various possibilities (nested NPT on AMD is downright ridiculous).
> In future, if possible, I wonder if we can export an TDP for nested VM to=
o.
> E.g. in scenarios where TDP is partitioned, and one piece is for L2 VM.
> Maybe we can specify that and tell KVM the very piece of TDP to export.
>=20

nesting is tricky.

The reason why the sharing (w/o nesting) is logically ok is that both IOMMU
and KVM page tables are for the same GPA address space created by
the host.

for nested VM together with vIOMMU, the same sharing story holds if the
stage-2 page table in both sides still translates GPA. It implies vIOMMU is
enabled in nested translation mode and L0 KVM doesn't expose  vEPT to
L1 VMM (which then uses shadow instead).=20

things become tricky when vIOMMU is working in a shadowing mode or
when L0 KVM exposes vEPT to L1 VMM. In either case the stage-2 page
table of L0 IOMMU/KVM actually translates a guest address space then
sharing becomes problematic (on figuring out whether both refers to the
same guest address space while that fact might change at any time).

