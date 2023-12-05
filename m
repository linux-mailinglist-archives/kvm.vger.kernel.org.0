Return-Path: <kvm+bounces-3464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29582804AFE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0E2F281727
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931C616400;
	Tue,  5 Dec 2023 07:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H8gp/kYw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFAF134;
	Mon,  4 Dec 2023 23:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701760657; x=1733296657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uFtH1XkaBJAKJZ9AzBXIcnELB4+h+sJ6f6nhvH66AT4=;
  b=H8gp/kYwloXRm+lUcL6YWLlG3s9B3za+oshIdN/vDw0RiRpcG2xIweej
   fVI7dAmRvwqMaidKNW3JZkshS/oeTZx6kj5H6kYGoykpnqqnEcwVyS45d
   C33wj4v/EJL/Kd5vobKylgUY8vzI7C+sTCmuN7as/gnicLvomMZZGRTM2
   VBT7e9e644E3Y+fd5NbxzuUOhJY0R+WfyYGii6w4r4dB67C9YmZHAuzeJ
   lFmZaiI1hXM18m4WVuLY9hqxNgqrrxR+H82UEpfeIX382OXHOVF/OIlsc
   0wNGM5yIGS33aH9+6d/7qmaMvwkiQixDuMnYglrxxRhBemTYZ6NM1OpEf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="378882314"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="378882314"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:17:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="747123381"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="747123381"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 23:17:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:17:35 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 23:17:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 23:17:35 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 23:17:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2UKKGzCHWvxTxWiKmt6abOmHz2JWXDcqkQ8auHFacefxNQSKfPcJIqy0pmcOg06GkQP9QKgA2Af7YAwJGnRG24tD63AzIGhu4EqDSDExTqTenROpd5plBLywtCCFzFrueRXOyyeW+NT5UkxNR9jGTuceeWT4xcDkEnDobq4a/p5pJIhib9e2fS+QHEqmSVMo3CbM5yKj5jWRLFz4pYy3sFYrUueqZXIcHazqkK/H0CsKX81UIipJsCHsEMJOWPbpNGScyPSmWAT2SgJEsJcBM77AOPwUaHsUY56B8UDm7sl5t4rNTSjk9k7i5D6kyPrUmX8DsQglQxojp1uXd694Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFtH1XkaBJAKJZ9AzBXIcnELB4+h+sJ6f6nhvH66AT4=;
 b=PEzOn91jGdhOsYDBfwh3DwZJTW5rCL9G2vAI8bBmAklZ9gOtj4X1F574KqZhdsu9vU/c8+X22skPaw1X3BPZ/0vDYFlywWfs6HunH01f54rgArUuW025geJuHPwCyHKIJZidYBEyZBmt8842k2LVBcJXZ89qGAIf7S9yWJtm8Ap5twGRdd9mJcx4WupINC+P2e2ED4K/mbVOTMV/fOkKZiTtYMo+WmKP7lf4qNWZpGrTLdN/MnKQd3Vac+MqMuSxikF6Ynnw/By16qpWGgcrWQBc7+MG+HR3huPXFi0ccfJDDb5WhtL9EtBVEooxflchHBbXZfuMJBxqM560h0qa9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6981.namprd11.prod.outlook.com (2603:10b6:303:229::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 07:17:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 07:17:32 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Sean Christopherson <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "iommu@lists.linux.dev"
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
Thread-Index: AQHaJQO3kBR+d+LKkUe3K6mDC1fRXbCZXNyAgAAIQQCAAB9kgIAAB9qAgAC3GPA=
Date: Tue, 5 Dec 2023 07:17:31 +0000
Message-ID: <BN9PR11MB52762F1CE520E127D0B7250C8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <ZW4Fx2U80L1PJKlh@google.com> <20231204173028.GJ1493156@nvidia.com>
 <ZW4nCUS9VDk0DycG@google.com> <20231204195055.GA2692119@nvidia.com>
In-Reply-To: <20231204195055.GA2692119@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6981:EE_
x-ms-office365-filtering-correlation-id: a1df7865-5b8d-4e40-6053-08dbf5623f1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LiQel7CWnxC3zFJhqd3Rz9OVk+L/Rmv9GhKyM369XtOeuC/VHmJj91/rituABRoToTWUklINnyevnvZTTwZeGc0WvQsTO2+zQ48efkqUa+EpcsME+AS0qfiLKJGlLpXJsSXq+8ztF1FTOT0tyEuCvwriVEYrVf3HizdK+BjGotsQqgqHHUDpEtVR8mR/WazMawZpv74uIo/a6LTDUVDakRcB7afFIIl8cAWK0qdF2e+jL8KUvLWTkmxiM7sgYMNcw7Bpu7TXSV4v+up82mdvcPgQAWqLd+5hrgRK4zCcKavchM267scoS3Mkuh/J8d56/dM+ThxtvV/mizFILIXoHafkFXTejzEcJlTo+qQISXHsirJjR1Lz8Yn32GfJ6juKpdKjFz94ydDjOWM7LzgoGuW6FT2wm5QzfYpfavzokJ9SN0W7rTfu/stbZxRUgUVC+gjR0Ir3GpjDiqcP+k6bS5t6s8xSMkSZxs2qimEAxKfXgj2bS6B+PAUtsFg0mAOyb+CaY5xz3NA3ibLFHg9yEgu/pKCMOxRYkevBmZRKFs7fdr2J9ptLH2g5QhlvVnVtVc+WQw4wBXdqaGzwFDY8mumqlIMpt400TsfiQohSgcDRy4vm9Qnel8HCdGFz0eJl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(346002)(376002)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(54906003)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(4326008)(8936002)(8676002)(316002)(110136005)(478600001)(71200400001)(7416002)(5660300002)(38070700009)(41300700001)(33656002)(2906002)(86362001)(52536014)(9686003)(82960400001)(83380400001)(26005)(38100700002)(122000001)(55016003)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8WNip2meP4XdS0QpooomPrSphF6H0qs4FEWhP6/hfK/sPeK3I6rfQX0YmNfH?=
 =?us-ascii?Q?M1Jq7YT8+otnnfOWGyMqOkSvEawOi2XTrIglV4mqVEwk29C+wFJjxizXoi2l?=
 =?us-ascii?Q?aUCM2xOZbSmE9N5MTcIr8edIJ0zA9qwIy+G5i6JKHzmrYpmNTWkVSL7+AXq1?=
 =?us-ascii?Q?b4b7dQ+ftO62Dxok2ZhLbukb1YYdHwuO9zRF6k9b8Ki1vegMd5uDtM7E0b9J?=
 =?us-ascii?Q?gIwijMUFISck6RhEcdGYigDIYwkF6FxEuO8M5hJm4h8+VZkv5+wvH6Y1kGGY?=
 =?us-ascii?Q?mchazAoSmQ8XiIDL1KHcJUf7gDfs4LZrC6YDmLPAW1vUFaCVBnCfC83lnfSb?=
 =?us-ascii?Q?UurOEuI3173M5MdWELRyMVW9sKLWT56s7ahEuOVzwJpMjwWb8vYJqbetabNx?=
 =?us-ascii?Q?lV9KLbbaXfdGz3jdz7Y6WEr/WSD3FfpaPtnKwSqoeHdmcpVXF8yeUCAXQdZb?=
 =?us-ascii?Q?DUX5wYfnwQLkjZSiL5IwK15LueVD1nL/72zOr0gHANDDcvtEsTqA6ZXhqZrH?=
 =?us-ascii?Q?TjXag3E1WyWwC7VYwKZ7U7iYglvYCsLmul28TjaqpM10pJWxRGokbFsa8jfI?=
 =?us-ascii?Q?FjBZjHI+LNWT8iWT0JCH7bVxSNac/ifELosOjt4Qu+ZeaRdTKut8pwTQWPmd?=
 =?us-ascii?Q?jlyXwODvRRBGV2IR8yvkfafgHV0DK9BAfzY172rt4393ZqWcRsOzJY/b9mbN?=
 =?us-ascii?Q?yit91lfkxGMGs757gN9PLQr6bVnoPbTIcRUSVWGOvPJbat0bNc+5lGUPUO/j?=
 =?us-ascii?Q?0sY0BipRrbBZ1Es2tzd2q6aJ9LXmxGcnihv9vx8PtPdgx10k7qaI//dvrRWA?=
 =?us-ascii?Q?466aoFlRTfFV2vIrwNhpsUnw4iBwjfOucuuStxWB2puO2GfiucVTr1g8u4ZS?=
 =?us-ascii?Q?XCBdDzwd91SeDSdgu7o5hWIHH4C08ftyvkQotn8vARe9xyDt32O+fnX5ePAH?=
 =?us-ascii?Q?8JqvSqYgnqB3haIPw6MslNEr1ASxUsqjvFBUxuoJ2iF1b6bgNuwfCjJHNjt3?=
 =?us-ascii?Q?xjl1nZsIYSImm5PPGD30776gkYQr+Xk/5w9/N10dMKHr3QCSmbCcO7lnS8o2?=
 =?us-ascii?Q?ZDHP1qNp9ctElWBHdVPSBM869fYpZKl48J/ampTTTgPnbl2NyU9hI40hZpGD?=
 =?us-ascii?Q?3G5vRVpZserD1qSdJyP7nFnm3ix80yr2sfUU6Ew6ON/ocHSg+8VcIQPEuxcY?=
 =?us-ascii?Q?Fp4FyBeRN9hgCnkN1Z0jqtKX7rE53/Tz2vVPVE3lFYbi9keAik7KhvALxpVV?=
 =?us-ascii?Q?UeFvX/t4ow4i/xkr6vDAVMSmbBuAUuGrDECnNTYtZEAPluALt4Uo8L/oEpIq?=
 =?us-ascii?Q?xEq/aIK/a28InNo4GqF6/VIUmK4bazC9cuw8xIli7WPXmHxvZVhztZDUZLEC?=
 =?us-ascii?Q?edBHuMRaBToSy+fQhTzViJTCe8sMigVO/xbEkcBXhohRR3ApPE3qBThQiZrA?=
 =?us-ascii?Q?7uXqE4wLTyZEEqJ0KSAOsBEDt14RSQFHlOurKILUz6XDfpsVHrvzWwaDtXTr?=
 =?us-ascii?Q?Q/p/17oCckRgQ8xnEOSlt63VGiESMspT7lZAJwVU22P7cUXlobahznFwFd3K?=
 =?us-ascii?Q?NwjI5n4zv6K+uL5FBI1+/+tSyjWdvIUxso0YGCob?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a1df7865-5b8d-4e40-6053-08dbf5623f1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 07:17:31.6847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +wAoUk0CR9hPgqzwtEZS8SW+BfpA+zWvNiGCyQQGZflCCiBcvMtGPanvHnPnw6R1dgJjCVhxQptnI7V5WEy3FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6981
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, December 5, 2023 3:51 AM
>=20
> On Mon, Dec 04, 2023 at 11:22:49AM -0800, Sean Christopherson wrote:
> > It wouldn't even necessarily need to be a notifier per se, e.g. if we t=
aught
> KVM
> > to manage IOMMU page tables, then KVM could simply install mappings for
> multiple
> > sets of page tables as appropriate.

iommu driver still needs to be notified to invalidate the iotlb, unless we =
want
KVM to directly call IOMMU API instead of going through iommufd.

>=20
> This somehow feels more achievable to me since KVM already has all the
> code to handle multiple TDPs, having two parallel ones is probably
> much easier than trying to weld KVM to a different page table
> implementation through some kind of loose coupled notifier.
>=20

yes performance-wise this can also reduce the I/O page faults as the
sharing approach achieves.

but how is it compared to another way of supporting IOPF natively in
iommufd and iommu drivers? Note that iommufd also needs to support
native vfio applications e.g. dpdk. I'm not sure whether there will be
strong interest in enabling IOPF for those applications. But if the=20
answer is yes then it's inevitable to have such logic implemented in
the iommu stack given KVM is not in the picture there.

With that is it more reasonable to develop the IOPF support natively
in iommu side, plus an optional notifier mechanism to sync with
KVM-induced host PTE installation as optimization?

