Return-Path: <kvm+bounces-25466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDF79658FC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F4EA1F2429D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E7B158A23;
	Fri, 30 Aug 2024 07:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jgfANTPM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F7E7F6;
	Fri, 30 Aug 2024 07:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725003953; cv=fail; b=XE0WvUaopwnXJ/JGsQVFhg/VHzE1jkzf6Lj01L3HmuF3ZQhTKa71AMF2WuxZ86bV6/Er9R9cw5IHr108fGSYQ477TV2gJyahfFGqFXjdUtzUkY2Mi6x80fV3lGCP/+eqvR2jUphCoI3wSDqCwfrlMCv1hCjpS0ne7are8d6a974=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725003953; c=relaxed/simple;
	bh=WzZs+uL5EdTRaCaze1piSiHyIax9rdXTO5xSwWF6ih8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=flPqR0kVndD837GFwyb+NTUgqoHWXohBFUPTfiWk7BHifVeAn8xXP56F5eLafbxFLtSDLiCsWeUC/PDrcwdwCGnG06AeC3N8opgFVzyOCnwv0ZptSHbAs4yQ6L5EjdokOXZlvaQTT+3HUV/Bt2/BOv+UAp6fqXGCf4hUhAOToHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jgfANTPM; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725003952; x=1756539952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WzZs+uL5EdTRaCaze1piSiHyIax9rdXTO5xSwWF6ih8=;
  b=jgfANTPMbC/6xwsKMnks84sCgEPGWmuEGkfM5zImiAsjamLeiXAeUVyH
   w2KykE4CVLiz0FyYHLYCoOp0Qtag8/hCOhiP4T09cubIDIqw9Xp7qkusI
   s5UpHxQUFlb6Xjh3Bglpeoh4o6ZsqbzVN9qn/e0h61atf7bg7CoR+TLyU
   YbvTKLTs0JjZzBLTT8OZKx363BiowliOYNBwy1nyiL6u2hIuWQiP0TcPP
   DJNAGfk/85bfW5EU2ds1KfFflBTA+FFYVZ+TW0wFzHEkqg2KDM+p4BlW2
   VRP9fwGRzw9zsf6/3ttU/Ow8+MTDjCMjw1mC5NDFq2TPJpj5JxCEl8nbj
   g==;
X-CSE-ConnectionGUID: 8l7hkS9/TpiAe58mbccGRQ==
X-CSE-MsgGUID: blFpdisETJ2hehXeo1b17g==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23150263"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23150263"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:44:43 -0700
X-CSE-ConnectionGUID: Sz+5AbXARaOgeA+R+dilAw==
X-CSE-MsgGUID: xoZGvOPTQ0SWxs6Zq2XQJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63818487"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 00:44:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:44:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 00:44:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 00:44:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQyxnI+KF2ciz9bhQuDuW7GqW9brnl1IDUcPrrLbsvNnsASTHYmzXKE3scNDHZLUH//hFvr2idGmwuVwgTDutWj3EBBz+dyZpU5TnIfjT0TY3hPVBpOwaGKB98WLk5WW7VOtGR0iMFSagRXH/Mo73aKiEiIjMEt+9v7LipPExY3R49kPoeq5rGrREsGliTLKYs8nDLenfiTJ7aO3XLd7fSBVgeJB4I5i2dExGqvwH1N+GwAX0VOxpJvOHAtliy1zvhzlWOvH+8KlX+49+2Mg8PnQL2Bw5Vl6eaIWctOnlvlf1gPaJwYbF18vWijpVwkCFCsEKaDJogj/AuQWfMmABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rE/y7aZUJjnS/63P6syuVupl9PO2BeEGP1It4h6nTzo=;
 b=DEfwUqc2AU+JZ2vp6bf/vnEVGOmUJ7l0k6nhcmDGcx43Fgu/am4PraJ/Ii1GtH00GWqESNv+V6fQW/up2z0PnjSK+NfnHMXzPN2nGf9TfFh20kIreLrXIQlMzM0PK6fR2LFCyOdiUduecNjH8Zo2DW6/1W9ZiLlnxUbjO6JqQpUI5gFHXcSWABOSNtOdlUotLzR1C1NTnbKAIHn1kQjJIVr9pYhuWAP+pzGCJ7KHHuKMslkpQ2SpTzX2dj2ppq72T2kKnzmvDGppmrjaSwCh20oGHtso7pVbYqSzB7ZYrL+9aGIKKTUzBl9hZpC7YwBF6PXG1VsCELEYKDA1/z8qmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 07:44:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 07:44:35 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin
 Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Topic: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Index: AQHa+JkZTSBXuEzIEEGnxKhZRRq9CLI/bzhQ
Date: Fri, 30 Aug 2024 07:44:35 +0000
Message-ID: <BN9PR11MB5276AAA6242BE404D43F0D348C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4860:EE_
x-ms-office365-filtering-correlation-id: cb1980fc-2577-46ac-abd7-08dcc8c797f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?gkrST6QIEjYku7hY8ubZoDqj27i7p1kHvoW2as3DCmFhZEH4aBnCFS4TlZf8?=
 =?us-ascii?Q?og2Vh4vLbmd7aHMz70r2/aPX96tKRH3es1n60amfWPxBYw1JKvWdgsUSWyiD?=
 =?us-ascii?Q?gLQEceFw92RjP6iYVb6ODTDfykoQfbShrwMS7B5Cg/25lg0Ej2NH89QObCHJ?=
 =?us-ascii?Q?rU6LsDSUXq21pigwtzG7cujjMxZ0kAVwq8bF/fnZsp8Rr3YTqXOxnCiEXreT?=
 =?us-ascii?Q?EYr0AiN53cGSDlo7Wnl0BzomoS/hiZI+szqfkOfO3NsyOhBrY8xsYBdoUQlW?=
 =?us-ascii?Q?5xUUqBxdTubJQvPFU+9F9gEklwr46f5RG6fzWSpubWTov83KVmJTHxGbIRoJ?=
 =?us-ascii?Q?laU1f1kr5mCIPSyu88b5xfCqjBTpJhyr6KPGcHjB4cHoW4jdNUruunjnDNc6?=
 =?us-ascii?Q?amEVNBRlrqF8nu0EPA8v3i2Dk2lUvgRUxf4+JpXCblXuo03jNbBffHQ3kNIJ?=
 =?us-ascii?Q?6RqBElcr5cqNF5Vhj1csArfVsyy5UtpjeWsVkGl+doTtmoPgpdE1mebBe5W/?=
 =?us-ascii?Q?8XOv1ROhtw+NdJvE/tT8XLjFB+AcrTZvTsetkzn0lDskM9YMfLc4DSRoiI2Q?=
 =?us-ascii?Q?SIVFxmgWqZn9cT4BCtPaM4HAJcjxz/vGleZCFlHRnSdOdfJP2ZlLJNgoW1Q9?=
 =?us-ascii?Q?OWNuSNbb44ThQKlMP2KXBxv2A/qWMcARnC4lEeuJbSBmS5ShljKSsCXwPstW?=
 =?us-ascii?Q?6rBYYWVYd89DclCncwrJ9Tm4E11FFAHoZ+hOIx9NNqBDcgd7O2YfQEtH8/JV?=
 =?us-ascii?Q?dD1u/7xC4B+ofZFrrNs0ASNnulr6+nV/TFbhoqLm+RZ8tzypDe73pHCiJ2Sl?=
 =?us-ascii?Q?N2ysji1hH01zKSYHyITbNF2aUD7E78mizK22TcGAaaZkpHYpYeAvededownj?=
 =?us-ascii?Q?DNAuuuVe7Cro8c41Gu1EVhuCkvRLMh49DfpcNWDAKZFG9B4W7Nv+mlCWj3sc?=
 =?us-ascii?Q?l2fHxHl1btsRIv4UCcNkC5bL+KPD+my13l6gd+ut1+gb1A0a0iE1Ap+fJ81g?=
 =?us-ascii?Q?3uSTTUmM566KFcAcLn4qlHyc4VvpfEzIhB4zAxSRCPBfhC/Dm90I0Jo6dlYA?=
 =?us-ascii?Q?mhsKVnbEZnoxpI83qWKRm/c+Y7KhVyDgoubKrUjSgbiba7NKoFTJ3RgAuR2E?=
 =?us-ascii?Q?jaBph/MomdV0Affs+XSuIzSlvLQUnQymYWRBfs9dlDMrW62DLf85f2HTNZuV?=
 =?us-ascii?Q?t1ETJl/kKNdM039mK37vJrACvl3g0LMJ1B0uBplGz0+QhifwVOBzM1Nh5ski?=
 =?us-ascii?Q?Oh9RZvS8fDTv/t9NeAg47d/OaMiit5Ko84anpsS4YWrp+iE1oSvYU/gyX+xo?=
 =?us-ascii?Q?lW4F2K5sTR42Y/OjriEmTnrs1LanZB2fTZVjmi0zoZUIM4w2squf10XOUYhg?=
 =?us-ascii?Q?rBuzwNf88H1pBSKSb4aR0KUso5xzTK2hs0gjFHH6K4QNqpnqRYQYCg0am3xy?=
 =?us-ascii?Q?Ughd88WZF40=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?49Oe3U3PUHOmjFrRoGwdFkLmn4mc1Z98ShQkOurXbOqKY1ijBuSMxUkTs58W?=
 =?us-ascii?Q?6qwRsAjtLx2MpycJKAAxgs7ZkpaD9R6f81CYI0rfxowNT4H40GznhAdBXVf+?=
 =?us-ascii?Q?DtXEPgBCS/C6hm23vOdJVLSa2ZLlABCRzjgE5+ahkVdT4ueo4tcgoS1aGfKA?=
 =?us-ascii?Q?7e/7xuY8oY4arFCipwi60H+MV2ootjV2sqhU412gBFUkhfmegyoqUQhNTPu9?=
 =?us-ascii?Q?MBzFKp7Q1PELhw0T3WXBBKtk97qUKUtF6WRC21mi6sp78xFgmmQXXDYUauXZ?=
 =?us-ascii?Q?7oJoLTkubk0+eN/PH5Qly3CDex+OEdoHLOccM+vx7dqKNtnvB1Ele6N5FYtT?=
 =?us-ascii?Q?I3E9yUFx7gVT9XwpzF8vQgCCgUidL9HbUaQhQRNkMSNLh0aB/OF8KipJLIxi?=
 =?us-ascii?Q?W29L29eLMlp1FbVIOnXRfj0MXm4bjsAvcbSOZtbiLUaqEJ2Zyvro/2Q9m4dd?=
 =?us-ascii?Q?iUD5vx3idu/9f/KC1nkQZk4lFxF79PzurQEQDQm67xhzwJnhzaY6Gi5LoW7c?=
 =?us-ascii?Q?teahdBKl8P7NIUwWc39y+id3YEtfk7fbDLM4avdn2J6LqEcH6U0AmADuHOBo?=
 =?us-ascii?Q?Eco/e7u0Qb002I38+v7RS9PoZaUaFDpes42pkF4UDMYVuVebWqjDWLdxdOys?=
 =?us-ascii?Q?/1qH/um/lu1VoTy+4hpOwkUYxQ3qLzi8zuQVB/fq2fiTq0RdctgtphxxmoTX?=
 =?us-ascii?Q?4O/903CzJbgmNR6hscxHfPF9MRNjA6tvF5w6j7PpGbTXmfijcyIMWHTbSUiW?=
 =?us-ascii?Q?0gz1LlJ2IqRGmwpufmdm1IzaE7hvPxrEakAiSjd7iDJVFpoFKxoGiwjzXDp3?=
 =?us-ascii?Q?JYckbJaT+0ihp8BjwY4m85Hbeeih1+tR8y1hbvV9nIURaocPS5sxmn34lS/b?=
 =?us-ascii?Q?M5nfqt1x/FXZTpfVyN7dUqPMvd2vzIIIKVOTdJmHdVQPAP5bREyjDXAKEWqV?=
 =?us-ascii?Q?mfQzRf6DK1IEL7hR4NAKvXyaQLYLXxJsdzpR5f9AUHG7A55eIjfrj2u6g5MY?=
 =?us-ascii?Q?tdOvrswVj7nByGFCg36y8+o35BA+l85t3eY9+9ec1/LrXQ6hpksMoI8CCkjY?=
 =?us-ascii?Q?gaMu1yKzVuaVlTT3Pw22uqnGeyXFsU+tCGtHPiZIewnX1A18dTvkj9HBvU2c?=
 =?us-ascii?Q?+MtagfSeQB9t14sUgU2UKnmHgEr4byBNv0Ihc52D5KJvV5vTfZ46dVZ+WUqU?=
 =?us-ascii?Q?xujZt0kvIuWJpMTT8BMjcFpqfCElE7nIo2BFNwgzzqxvFT6IUVn1q/oEy0tA?=
 =?us-ascii?Q?NxjgVD8wfIFrVn8jKAT+LFt+DFeFToTh4pqT8ST4SYuH59l6KVG6YerWhPD9?=
 =?us-ascii?Q?XKLHDa0jdbYl8TSbAPD+wKljgKvSrP1V4VHlj/9L+Ag+J23JPGP8UR253SBl?=
 =?us-ascii?Q?WnBGi8QRn0kpqGr5QqS/LkRdw385Apb/auZVc9OmpPR2TT3H4V9+GMny+dAw?=
 =?us-ascii?Q?JTqDiRB3uYUMwwYqyWMYhY7LGObo7ZwzSM09xtHyCIuzCUelDlkImAxMZhtC?=
 =?us-ascii?Q?cjucU6lKy0SpT9kkMe6lQUj7rVOseuhmeV6xtsBZ1qkwbrrMXHvJPgFmlPlO?=
 =?us-ascii?Q?MYti2smXsVXL/RZt9IT50G2V/MAkXc7D6u3aQN0u?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1980fc-2577-46ac-abd7-08dcc8c797f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 07:44:35.2580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b6UPsWDkw3Wz59bySCAqukPCyQ8sUCdloL/OC1uxwVfoeVIdAieYRYrKM44Lfrix+zGVvQLZAuGEo8Mvou5yfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 27, 2024 11:52 PM
>=20
> @@ -4189,6 +4193,13 @@ static int arm_smmu_device_hw_probe(struct
> arm_smmu_device *smmu)
>=20
>  	/* IDR3 */
>  	reg =3D readl_relaxed(smmu->base + ARM_SMMU_IDR3);
> +	/*
> +	 * If for some reason the HW does not support DMA coherency then
> using
> +	 * S2FWB won't work. This will also disable nesting support.
> +	 */
> +	if (FIELD_GET(IDR3_FWB, reg) &&
> +	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> +		smmu->features |=3D ARM_SMMU_FEAT_S2FWB;
>  	if (FIELD_GET(IDR3_RIL, reg))
>  		smmu->features |=3D ARM_SMMU_FEAT_RANGE_INV;

then also clear ARM_SMMU_FEAT_NESTING?

