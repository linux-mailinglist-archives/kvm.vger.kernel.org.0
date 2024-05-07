Return-Path: <kvm+bounces-16806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FA98BDD3F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C923B2178B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC1214D2BA;
	Tue,  7 May 2024 08:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGJw3up/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D471613C9A2;
	Tue,  7 May 2024 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715071173; cv=fail; b=KUhJ1OOESxE62SKhVPJ5hr6DlmNWCqTMhVOTe3ac4/9ABbEaHoB1wBQUT28xe/w5o+qReVnQD0tlh/94IzO30ij39jbw3uKB7bKkyhQuvLnIX9wU4kclxNPYPHhGM6aQhxoyZY7XUvNtl0i9+GyJyYkvR5nu8uWM6dqpnhVc7kU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715071173; c=relaxed/simple;
	bh=i5qOz3WJAx7Ux21WtBP2eyJ0//otk/9v7EavqYuHvig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j37iUUbqnok0ZTtmUcnOrjpqD2Qg4E6C/8RITyqr3F9mQxJcVps/DkZ/VBkc7TtmVgbmqt3G+Cza96ddyiQamZ9oPz7t2z+OAcbZ1zNNhmCz03kXnn1BHkqId9yRB+fAqk8tI+HxVg0Xjc81NhFcdBSqq3YZLnvcpfNEEcnsxDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGJw3up/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715071172; x=1746607172;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i5qOz3WJAx7Ux21WtBP2eyJ0//otk/9v7EavqYuHvig=;
  b=RGJw3up/+NFUv84ECkaKth+cfGOQQrcX0HedJl3RdzRFG2jR4ZVZk0n9
   1QT+03LDfBxkuKYNIaUzQH6PdSh7d+OXj+zifdJOyRVjMerg6t/rsq6cF
   DuUkAvOsRD8V3O+VGI8ucKyUyPtQehULzgZQ5t9jH4NqXNlaHKoQkg201
   /AFvNxh0E9aTRivjfECjDEaPP4E8nb5eQEAkhJbY0waxcFLmVNAbbgcrZ
   DYpAvITWDzdWX4syOR/jPQOdNgjLzefYYoa8SLjPZ0UftWIDZvFai0qFb
   6TIlN/3hEmgGca2A4xmnQt25QbVHogG68WfFz27Pg7CtnZ0rZtK5c3gC9
   w==;
X-CSE-ConnectionGUID: mACIQRBtQgSqvqbNTVy9nQ==
X-CSE-MsgGUID: l3+gKx7eQZ2W7/G47DWZIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="28322559"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28322559"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 01:39:31 -0700
X-CSE-ConnectionGUID: kqgWroX1R2aR35O16yAvXw==
X-CSE-MsgGUID: P72sUKeJT/eT/Dx8ZtV+EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="32909683"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 01:39:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 01:39:30 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 01:39:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 01:39:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 01:39:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZp1stmYOxk7EtMcZ1GENXWi9OLbtRqHjX4uCTpL96TtPgNQa1tg8ivHKwUfNq8T8MBZqULgKcKmgwTjEGCDya8joMML7Ao3imLmk6kq3VYl77+f6u5aD9TYlPt93uyYc29sH0EgeXrpnZ4vZ6erxyclov7bEMBx6ceswryGgV/fJ12wnnVu2gqXryjnSt23S6CVXAGd7KqfCuGsm17Mys2hWSmkrfTOvETrz8Gb+sGCAg7jtDtcUxbvQaKKEsCNUp7xaQVAnivUJrLSYCgibAmYJ4VR0NH6BjB2oU2TzleVPUzci+It1anrqamV4JendEcwy1zeIApdIoN8S7aNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEc6eXFuvXL+cxvtE6zMOI4fGlmqX3vgo9+V9DG3esI=;
 b=LJrc5pg0NYDSHuQGPdlpgVUISBxOzx/GfcsHKphzP1QGaXWNNINRPm6j+t52k0+D8JwtWOBiVB1NV3XcVmhwWOB1mW3JT+H66s930gPJ4DpdGFnw6EpkyFqBHzkgMPSHGAdwE1WrdF7+d9Aa/jqM6fqv+aHn4QhDtfYpV8fun7wVg4XF89b66/TEGnzIQEkUrkAvzOCbuJPBURtwg+QFQzuSx9uO+pPxJZf2k4ZJedE+eS+kaJTrcNxLQC9hacoaxe5peKD3kkpdz1CcbAVyPETrLKJjJcsz6E/YNXloxtWTE8cqpmoKvmHyIV33E8Rgmm/l6QDkgKIx2JDIjhdBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7716.namprd11.prod.outlook.com (2603:10b6:a03:4f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 08:39:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 08:39:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 2/5] KVM: x86/mmu: Fine-grained check of whether a invalid
 & RAM PFN is MMIO
Thread-Topic: [PATCH 2/5] KVM: x86/mmu: Fine-grained check of whether a
 invalid & RAM PFN is MMIO
Thread-Index: AQHaoEa3CD/Y9R0aGku+9PW3d/i4u7GLcuAA
Date: Tue, 7 May 2024 08:39:27 +0000
Message-ID: <BN9PR11MB5276CABD8B3E1772932E2E3D8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062009.20336-1-yan.y.zhao@intel.com>
In-Reply-To: <20240507062009.20336-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7716:EE_
x-ms-office365-filtering-correlation-id: 01bcb297-cbf0-4a5b-cd4c-08dc6e71347e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?cplggnTUGV6O5UdOMTK4zzsvS4vAHvKxehKu7HCn6LxFiN+k09E/GHbh4r+E?=
 =?us-ascii?Q?uEEM71XADwr0G5eAFMUeCqSuv0wdGRkxoERuVq9JuIiRY77QVQGuxXjmz/Wz?=
 =?us-ascii?Q?ejMHe+7iSPQ8J9t+7RhOGH7HgVhp44YCY3PIxvMj0hxB4lXBFKAWp8SKYi97?=
 =?us-ascii?Q?xf8bYbUZ9H1tPzJAUHfUdL9XZ4Eg3lFVQvKZ8NnfJRHqwOs+9/ONMugr6R+L?=
 =?us-ascii?Q?NFY8mLNJDvc4D+49fqFk6cKBbO4to7iaB4bc+/wMGUu981ON9S8CDmU6zpqG?=
 =?us-ascii?Q?KAFZDQIcf5C5wE1WsWvgm9XA8wwV9zZrLaahvlry3n/oHlgPIUuxswEqc90k?=
 =?us-ascii?Q?HtQpN7y4VoL4l8DufHnbKQNQMl4HeYCt7tjnrh4ehQLfFdppyakcza1qoZOa?=
 =?us-ascii?Q?+8wwfd6SwTNxyV87eBhsBp9yXSVwnn6Y5aza2S0BlcR0uKtqWLTTLuyhCFP8?=
 =?us-ascii?Q?RyUWUaKdbnWFOuUP1Tz6arHY5BalF4pwkIrH0itSkQJYa7MV9fZGrNeg6+vS?=
 =?us-ascii?Q?medD4xWdUXx8c3ht0uw3rRk2mjGu1xX0VHTLd6kvctKRp4tU3m2pwzDoaYT+?=
 =?us-ascii?Q?2vbcDUq6Xogxh0F4PUZe12Uf2xpaCZ+PYjSM8sqdLUXiOhB7HJpOYVobz2ZX?=
 =?us-ascii?Q?jqWU9iOg29pgSkebzMfRMEeWxjHWn4IHoiFEcXEU8ejN7nU168dVL3FKtTFw?=
 =?us-ascii?Q?jwuAkjm0AZnmDEZ/PFt8jHI1YnIoiLL/N6/WR2RSEXAbPDTj6qkn9kJ+q9dO?=
 =?us-ascii?Q?9iN8aWvgYz1UNwwNL9JUF2fJ/IRg22LCiugEYCwdI+YqQOJIkFl0MR7SW6w9?=
 =?us-ascii?Q?XuCyjvYJxRvQaOBkg2SW9P/fp48vnp0Hxzi45KrGriMN2qWAelmNWZ/LWcMc?=
 =?us-ascii?Q?wGV9N93jbqoSfjNnJyZHYuT7I1YkFdMs9ADjxzglYZ4MEpT0l9Q6nvZZ4mrU?=
 =?us-ascii?Q?xcUXarATDvw8dJcYy8TtKHDtgCbORxGyMCK4DoHsi/oER98TtIdELWjO6ptW?=
 =?us-ascii?Q?6dJKTH3kQdA0+xsS9JNmCgoNqAM7uMbNosT0ZN3/PZ2hZg/TiwdYc1g8pPt2?=
 =?us-ascii?Q?3/bOLxQajI2LYBE3Q4cfksPKrhpgiGzx2mMV8339T0P9zRZuyXePbaEOQ1GD?=
 =?us-ascii?Q?JYN8P+zLiclASXk106Y3CTv85sAQL/K3eRI9DHYH/Shcgg+424WHSqvLyIwz?=
 =?us-ascii?Q?Pb0o0jMA+YdH5yk/d0SwN6I+iSaxacMstCNVKR4UG5O3V2P0VJ6z2lR+mdhs?=
 =?us-ascii?Q?AXgOwYckbMwI7AHA0H7sbxymBLSXy3GPRfAQh1e6IlOh8FsFXd2pI5vFGP0Y?=
 =?us-ascii?Q?HyEX7SSteYdppBReJQYlzJUq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4k3w9Pznt3lnZ0Cj01vpkvgmc4B7u5wf8cjcjqHjTMCHrKaO7AtfjoCS5Vzq?=
 =?us-ascii?Q?8h2wsMJrTZgOO41fRa+fDSSUB0d/kdUMFeGE1Pl01pjIXOPTFzPhXgBTWq8r?=
 =?us-ascii?Q?ZgAXQGWdNNo4xKGba2vZ7NkDnDLib8UWzqdGH3jFSIO7HBysTFzQJlxx0cNJ?=
 =?us-ascii?Q?JaCSNflrhsacBOXUx25yp/IcKvDlhryo4l00AhKqVqmUF7gbR+BhyvGD7jYu?=
 =?us-ascii?Q?nZDnrZqlxOLJCEq4Gl9ga4ksCfu2LyiD0yuHtgLr+Z1IMpOAfZqvgsE6s1bt?=
 =?us-ascii?Q?zrSwsCTvFW5934eqL1KSoKNejIe+uViEwgH2xoQ8b8bAWnAHNne0X+OSGdbA?=
 =?us-ascii?Q?kIcOAVswX+33sWMXepjp8ltBLftLuVerC1NYFu63h1ofQ+GwhnYi8NAtyvDO?=
 =?us-ascii?Q?aTQYu0aaDXm+ScuEAseZ4ReFcIiji49AHaRaMmF5AbQr2SIg8sZ8VJBduzN/?=
 =?us-ascii?Q?TeKgig36hf2DCVBaubeQ0D6EoxQF8rgT/XIxKvW9blIRHn0WybfSkggcnZWO?=
 =?us-ascii?Q?nkjDsB1YPfMXwWZIpSpG/e6AZDKiIQ4c3xM+1glT0wXxJfGbatM0cc8NYcIH?=
 =?us-ascii?Q?Pn7PCsXa0dBxdJtxQUJiG4Qz+O6NmKdL2veDQ/ZJV/v67MZlVT4JRrAYSKBf?=
 =?us-ascii?Q?Q0Ha50LnvfjzVm5n15lt/bfZ1lSTpDgM+WsoySKsHYm3Dt1lk/7knqBFv64f?=
 =?us-ascii?Q?fZF7VehDSV14xuP6vDGOcrnlr6FGjvJmIvZq1NS5AWWjSMbJAmrC2h3LeCz6?=
 =?us-ascii?Q?hWh5wXu/+VmyHsakxMj6mvoyx5wDogNgXROfMtCYY6r1KFmrqMKbBneiMiwW?=
 =?us-ascii?Q?AqNThFxLCo8N1umtYDFQgyPPvb7Pr27hC56q4GSYEZuN3XLgnS6H2Dp5MAZL?=
 =?us-ascii?Q?EEM2pfswHteluuzV+80m2fp0+MZq8UA4mo7fBmNbeeEEQGXv0l7I14187RX4?=
 =?us-ascii?Q?sEmaPG5R3TE0LwCjIQIaV64VzbdU1NUTnNov1ObU84+k05ynuLRUNTU4WVLt?=
 =?us-ascii?Q?GU+Hcc8ArkbRvchzVLi3Dk5GpTP0WkxrLaArrYzkAEV70OoGuNFsbpoceZXg?=
 =?us-ascii?Q?efCLPsrBnz21/akPyLi9fQA+2hbDj1gpnR7TEWp3fhKHaDpXvSD8GaSX2ccB?=
 =?us-ascii?Q?SjBz+5b46N7G3BUlT4W5VDU8CI2OCNoTdlPooNGNAS0h9tc9woiLRcx8ZTp9?=
 =?us-ascii?Q?ZK52zUyvxfmAvpwC/hjtOsYlzUho1leHPvYYyAuDqpt1J6jz8nA6qiOqbMZN?=
 =?us-ascii?Q?4KA8MF94fmsoVZC+35Sg2JFIgxlwV6jX6M8Bn2XEJyBc6x+z3nBYToTwJQMA?=
 =?us-ascii?Q?UGAp27HuXqoGaOCKbJeMvNP2/IvfSh01B7AHdT5ax10MSwEFnJz3Felr60ml?=
 =?us-ascii?Q?AtdNsMEinFg6DNvG4gJBdiZqlvwDAzDgP/M4tIWflVN2Chws/Hgp5HTB5Gul?=
 =?us-ascii?Q?XxPoasz2w1Z+qwl26CQGr5coZjzPwn6JFwSWvXoo/3vpTr6eR6VuJH4tlqJe?=
 =?us-ascii?Q?z7KMBUDW32mjsqo0lFXIi16gq9dXfQQ27nJkTQs14qhXdPqtEQFTDi0Hh1C8?=
 =?us-ascii?Q?wffpV6rWvyb/nQdcOT1YNzq33cDx33MYha/DOJwJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 01bcb297-cbf0-4a5b-cd4c-08dc6e71347e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 08:39:27.0484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: citHLtJm0JHfM24SU9hm+jEwLvnZnqLTmnIMbhCL9q6m+CP6cSROv4BDCg9IxHBX8dxDPvn3vFlRGoCrX6dUQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7716
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Tuesday, May 7, 2024 2:20 PM
> @@ -101,9 +101,21 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>  			 */
>  			(!pat_enabled() ||
> pat_pfn_immune_to_uc_mtrr(pfn));
>=20
> +	/*
> +	 * If the PFN is invalid and not RAM in raw e820 table, keep treating i=
t
> +	 * as MMIO.
> +	 *
> +	 * If the PFN is invalid and is RAM in raw e820 table,
> +	 * - if PAT is not enabled, always treat the PFN as MMIO to avoid
> futher
> +	 *   checking of MTRRs.
> +	 * - if PAT is enabled, treat the PFN as MMIO if its PAT is UC/WC/UC-
> in
> +	 *   primary MMU.
> +	 * to prevent guest cacheable access to MMIO PFNs.
> +	 */
>  	return !e820__mapped_raw_any(pfn_to_hpa(pfn),
>  				     pfn_to_hpa(pfn + 1) - 1,
> -				     E820_TYPE_RAM);
> +				     E820_TYPE_RAM) ? true :
> +				     (!pat_enabled() ||
> pat_pfn_immune_to_uc_mtrr(pfn));

Is it for another theoretical problem in case the primary
mmu uses a non-WB type on a invalid RAM-type pfn so
you want to do additional scrutiny here?

