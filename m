Return-Path: <kvm+bounces-3454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E53804A15
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6530B1C20DF0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 06:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3D210A14;
	Tue,  5 Dec 2023 06:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZzjfNVBJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97319FA;
	Mon,  4 Dec 2023 22:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701757836; x=1733293836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x94P45GrQGYj+/GnBcb2dmyKvchw3WrOCvK5BwJcVpY=;
  b=ZzjfNVBJ7glJJbASQc+ZmD8UGsKweic0FRLbj2rOyDurHQV/YWaesRKX
   zEuWCkqwfskGd0HVt2cqloQf7WU+xkRsPvrM473Z03vftCFoHLFPbWJpc
   kR6gPt/8OnouH2vx8Cw72dwMJLAfyVKovuLdLjK8Ea1uiN7v+Z1dzS1xp
   k1cM3HGctts3ikSKeXG5d1x/rlTqkHQArUsP+HgqVgiIhN/c95iBdBB4e
   lwAXB1337PLYXopReQ9YVp8NcqVZ34AnJhUx/YnIs+1rsgprhzJSFG8DC
   UNXbo4KeyrMNNd7sVEEjzQCj2PTk1iLyGxdiG/r3EtcF07uMIAT1MYLue
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="458170356"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="458170356"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 22:30:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="747112152"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="747112152"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 22:30:34 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 22:30:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 22:30:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 22:30:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eo6gWN30cksriywF/b5ZYjyEtBB/wjd0g/T529Fd2DzMM+qz2lI9wezGsC87Ngp3jsWROwEn5OqNWunCxuV8m0t3t+C05RkDcN6NcBcKEnY9kcxs7W3IvSynDmLNW2qiEJdudHdwkrIGsSiQ0MMga5oguvhk5rz/O8O3pg13byo8YVwOgIGaKeq19FrWGqczHZUhXehvNRHHUSK1xT9Hot6vYS0evXySeEZ0+bnfijJxluFBntkBInzayY02Y3MI4rFVKS8uK7ZWp//67mBoWpFvz/CQO1ZRbJqwm0eOymEvHtl21Yr2InEmXyEwp2avwQifzQLV0xyloM6oIEqSug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x94P45GrQGYj+/GnBcb2dmyKvchw3WrOCvK5BwJcVpY=;
 b=Hu0iLuQ68Wru8kQ09tF7sMX/Kc8aLFlgTLnqIt7rIq5utkeF6pO0hDFIRZWmjgkiVbjeIWLkXwN8pYpNuBTf5XX0wd3R3peHjkhUGs716znaZCWeVrl54lHRwJ14kKs/rRDRBq0oaKeoZBBNEcb/afwtiwIxz9pjZ4K+tRekBeY80JaBV5fG6C/EJT4ybRSk3MQSrfHJFY4vz97BHq3Rh/wjIGaxeNfXfxp+6S3dQXCIsJPcSTM/Pns8GqvcBirXkEoS7gbDJyhKrx38AT4084LDRr11u2RcZdWBeXRRCZyQcBQDFqHZyhfhJL15/Re3ZBY855CWB5dW7aTcf/SYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6510.namprd11.prod.outlook.com (2603:10b6:930:42::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 06:30:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 06:30:31 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Thread-Topic: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Thread-Index: AQHaJQO3kBR+d+LKkUe3K6mDC1fRXbCZPU8AgAEAytA=
Date: Tue, 5 Dec 2023 06:30:31 +0000
Message-ID: <BN9PR11MB5276F4CAE60B0C199A9308BD8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231204150800.GD1493156@nvidia.com>
In-Reply-To: <20231204150800.GD1493156@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6510:EE_
x-ms-office365-filtering-correlation-id: 17c69d98-466e-4c88-220d-08dbf55badd7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iDrd6NCY4y/t+8Q8DDKKnr6x2B0K4XcwLhMIttzuv6eSJNKqd3AwXA+GXnJn7vFxmPRP3oS2H00NutjX+W2y+eTXmwArCVKxlqQ97e6beGEqRZOa0NNnOLfJJV/Uay1F8ZTm1K/KiHMn8FzFsv4lNkax8DYSl9rX8/yZiggiEufVegHoOTrnmNjhN7mvthMy3RqjJKVaNqlw1A1DFF9jg/cnVAxW3Q+NjNzxy4AUKlbX7mFelkwZFOrQG3P/1M7DIBuF+Z0n+YwfPel7qGAbfz+sP/GwAwtA5cSxWlSMRaPzPOiwEIK+iimLlNqtdPj7InYscq5n9njJA2kNW/Ozc8QPrHOZGXgkCM+B0quO5kS+pvREmzdl5c/v16HW2fnGe/WB7eUOqGzjCz11zSXPgNdk8oKML9uOhl+yt2spypxGqL2J1c8yIc+lcQcGAI3rXQXcSnoplenvSuakVHdeIstZr8giIekX5uirX67oxOHHg+XLVvxJ2rn7QAfo2sgBzdWG9pBtxlehoSJVcYVo3T3bF7dkMaUEPUPnTh3c4EcFXTW3NQcGSgwMN0LrwtbG8mb37yNvo4NY5k+Z/ZBxk6j4C+GqhIRYGy7iz/QiImbJsnReckOMSN1qerH/VzNo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(39860400002)(366004)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(38070700009)(55016003)(9686003)(478600001)(6506007)(7696005)(52536014)(122000001)(71200400001)(26005)(8936002)(8676002)(6636002)(110136005)(54906003)(64756008)(4326008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(38100700002)(7416002)(4744005)(33656002)(41300700001)(82960400001)(5660300002)(2906002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Uya+mm99+R0WInq98b080X9eYglxtuGxittvsJZkM0h36vnmWerML8bZ1Ajl?=
 =?us-ascii?Q?HCVFNOWMDyOwS4jb2uPtqAnb9wx1A02bvrXPjdBYWFWnjhM3tdp5b86+K06U?=
 =?us-ascii?Q?qSIHMGLFk/9nh7qeccvL8/DQJnOJrC+A/anA7WR/foLbX+FVh9TxkDzPy4Yh?=
 =?us-ascii?Q?xhvff3KM/FuAQSAcJKdkWz+MOa75UQMxSmzR5W0xKpK2sMkmeoWb2U8ZQda5?=
 =?us-ascii?Q?BBh9AadWxUjARUM0iUH6VjhFhi/f6hvSdjA1e00vz1tP5sbu01Ci0BOhu3cm?=
 =?us-ascii?Q?jOd3GL0CopCPQd6bylyE048nm7V8+EIHEJfzG7k2HWKw4PQBHiSH/rR6NHQ2?=
 =?us-ascii?Q?KPWxMVcLpwn61d26LmI5/6XcNiO8GsfDmAVKQLS7BXqVGtUpd0v0roJ2DPc5?=
 =?us-ascii?Q?dGrf1W9NJpO8EHT7nf/5feAbhf8BMFVbdqllTJDqAXcz+h8oXBcUGB1ulb8w?=
 =?us-ascii?Q?1MA2MJMyuSx3bVOC3nPmMgBkWZsAg4NM0Q+QI4ZJpJ1KsEcnbeO8WNWFSRUw?=
 =?us-ascii?Q?kYjhCoXo9YMvIUwDxmdHayq5pRcUHy4HGRY1DFKVG4c41fyiRLYPyWZ6LaHc?=
 =?us-ascii?Q?yyKDBOCbzc1Qp8QKzunS94BBzZQqC7itF6dGhZbNILGp1JbULaj6bCznKBW1?=
 =?us-ascii?Q?KP9kLqHYpHPKL0ws+WQ0J2nEWQHLHde4Og5/nFUurnt8J58zUiYSQbv2Tl1b?=
 =?us-ascii?Q?xUAqMMdJytJ/a/nK2j6XJ4Pyed8J/augTkqlfTIbyTIwTqozQj20y/RPnVcj?=
 =?us-ascii?Q?4XIP1kXT5ysDJNKM8APqJMKWI/Ad340oHauUbZ20qxDE1BgVacR7FVi625NP?=
 =?us-ascii?Q?LS31GAgi3eJUkjw0B30qOl5BsI3Cj8bkxNul43N3Vldi4lzzXSocT9AHPoTG?=
 =?us-ascii?Q?SY4TxgBuA9m3aJ6BO5/8JEGzvLb9/MapiVn6yctwbGfyMuSWQ7pad+e19EN6?=
 =?us-ascii?Q?qbcIOT0p02HNUyvf67Ld/iCy8yctls51o0FOu2kcf+Fg6q39Zb24/GUNUqIP?=
 =?us-ascii?Q?7ZqUDaKPUxo9LAKg+qacsTX+d9k0qbZWaEa3bJBF/nP4ulu0wEmG37htjH2e?=
 =?us-ascii?Q?egzp880B7FwTK0GHGbRMBM9tqWnu3nd3orYImljxqRLPHuQYP6PlcwsdCzhQ?=
 =?us-ascii?Q?oO8ecoHkitLbNzhiuAUJh2BEyVoLu5HP8GO23jUEDwgTFs55VJ6usMeIUSG0?=
 =?us-ascii?Q?YJ63/9UrupreM3qipb81WlHjSj9oCtjFF2j/azamkStpoIPQstfYbquhzOUQ?=
 =?us-ascii?Q?JpsbDCNB9xevXWtWMb/VhXZqNJu51LEdedMZplrrHW2uQsnoN/TZp4dNitZg?=
 =?us-ascii?Q?m3a4W2zEOQG1xTi5i244oTySui32S+QTVFvC0kbKuMk+f+i+aMMTbWWfx7H/?=
 =?us-ascii?Q?IlmNCRkf0DcXY+C+n5+CSYoQuE+p62btIIqc+b5ZxzZal3te3juQL68+9KFV?=
 =?us-ascii?Q?U/7CGFCIcfGXMs1Cc1OaSvADsWjgVp5p18cw0Fn+bQT66ySZgb4LxyeSAtU5?=
 =?us-ascii?Q?ZJpdCuz6eMyttD5zXDpikG0/5JEty5BDgBHJuP22DQESVX7PyVfBBQktGEhh?=
 =?us-ascii?Q?fxqKH1vffzpvtko0zeLcnFc5GQEaYw2ybXG58j65?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c69d98-466e-4c88-220d-08dbf55badd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 06:30:31.0415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GYh5SRiU1kwlSVGi2OZD/9KKJtmdFC313hOdxNzGWofwZqqE8XmYqeWASclOpRD/7xa2VF9N44yBbcdurk3i7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6510
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, December 4, 2023 11:08 PM
>=20
> On Sat, Dec 02, 2023 at 05:12:11PM +0800, Yan Zhao wrote:
> > - How to map MSI page on arm platform demands discussions.
>=20
> Yes, the recurring problem :(
>=20
> Probably the same approach as nesting would work for a hack - map the
> ITS page into the fixed reserved slot and tell the guest not to touch
> it and to identity map it.
>=20

yes logically it should follow what is planned for nesting.

just that kvm needs to involve more iommu specific knowledge e.g.
iommu_get_msi_cookie() to reserve the slot.

