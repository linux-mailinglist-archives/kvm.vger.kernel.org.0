Return-Path: <kvm+bounces-13317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 841CC8949A7
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 04:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF712B24343
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 02:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739491401B;
	Tue,  2 Apr 2024 02:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XXMcIdlS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67EA6FB5;
	Tue,  2 Apr 2024 02:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712026447; cv=fail; b=E5KdaRsoidLfC+ApE8xrIRLY0UjIcvuEhuJJS4eni1S/e7qXYd/uSsjAT607pkSut2UKgkQUprNlznD67nxNDzx6HeZWikhq6on6C15ZZF6ER6lj4GZQ3/HlWWN46RO1wVMdD09Xy/uiBm0WC4eAJS0ViZaT+qna+tJ1c40mLQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712026447; c=relaxed/simple;
	bh=iaiq2EeArPGFYM6auzo9ejdp5/IvYnZC25fWgofwHsA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u/DNOfs8Oh9q8RdSVfiFBtxZSxOHqfVSYc/OYLWEB2r9oOsUDh8geUqsqRjz8mUcFChCUpd94PUK4TqOgGlJMj3T24E9vWDS0tYWF8CVCXmFm3PVXk4ygQ5ehOd9hsfS22c1p/FAKyD79ry4wXdb/IBGkj70TedRw2hfCed5fWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XXMcIdlS; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712026446; x=1743562446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iaiq2EeArPGFYM6auzo9ejdp5/IvYnZC25fWgofwHsA=;
  b=XXMcIdlS5wbxkLtI0TuM+l+VrcY5JewK5WyayYnBYF0MkW+hn+Rdl5g3
   ymtOn23Km2b56mNJYFdzTYmC6i0+wjPn0QGOAphBdmN+XWv+qc+MJ4vZJ
   eHTrZa30nykfUx+7ic2nzSCnmFZx1lMnJXPNSLCWiRtO+MlBRKoNb1SeV
   9yctUazhBmk2N///kvu6vfD0aEnwXSe6s9/k/ZAiQVOyXcf6D5BrrENTW
   +uIGPZkJyRsPhzqDv+XSiWfVLjKb+IyT2VyXP1XRi1e6S83lej2JqWMDf
   uO+srK20dC7bYZIX4YWFLDP8h2y5NH9s9wn4uvTGVT78TcocLZBg+eHnz
   Q==;
X-CSE-ConnectionGUID: qTsAJWgrRA645RadGCTepQ==
X-CSE-MsgGUID: pLFADw2vSQukb1TQXTjDEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7041437"
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="7041437"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 19:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="17986182"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 19:53:38 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 19:53:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 19:53:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 19:53:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwxMGMEmgetu4E7VJ8s/4q6eJ5K9XK99uP6yDcs0fDPrRUA9pbPJ0kIMwnkMhJRZPksPK9nVJiteDwsMF/hirUPiPBirctHAcnn7IjFQ9kNwN3H9xK12qKvZLEFKP5vCHi9vSoNPyWteOUCDATJ7zpqNlCHNeNbwLQTrXBgKjYtXT2VIBT1c+Cm1jsjV1VWRaRRvqw52j8D3J5U7YBBVJg/7AWQpc19n1aL8fSU0tm6k5fFAK1UjVkV3z8e8yLpDSVj1Vm3ezK8RV4IJm9WU/CdK9ZBbC1yv3wAe8bmG6tF3u9L93kQPe3j8GRitLZzQeoFeqGKqoW2ECqrSkDUb9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F54X/MF9XthEWSi5oJ0gY7gAt8YiZSjlZr+VIS8Qdqc=;
 b=OzeVi1hl7lLGhmAhvQa/JXfsw72yEjyedzS75pIV7n+6+sTfSPSfnaEZw0E6mPRWGzWRNQMxqd3STsJbYh9y4Ri55BNkXQ7/dFhmD00Pv2YARForzCdjjsbEEMyg5EdFDZaTTY8aYUYRONVbZkrLUxqDaSUhxRlLHtgmv8z476p7aQcz61vGx80w4pSqK6yDsBgNokFR85OZm5ljZC3yGXuTU+l65i+UM3Bu1d8dPyLuGtFh6c7FAhl+9jQrn0coEWQ2GCHDQNkh+XquinrLKCHGvyrORlQfa/X6LL2kialwM2sCDw3XllHdMkJDEobEt4rpUVEc1ClzWS8eB/g1vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6515.namprd11.prod.outlook.com (2603:10b6:208:3a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.24; Tue, 2 Apr
 2024 02:53:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Tue, 2 Apr 2024
 02:53:35 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "diana.craciun@oss.nxp.com" <diana.craciun@oss.nxp.com>,
	"stuyoder@gmail.com" <stuyoder@gmail.com>, "laurentiu.tudor@nxp.com"
	<laurentiu.tudor@nxp.com>
Subject: RE: [PATCH] MAINTAINERS: Orphan vfio fsl-mc bus driver
Thread-Topic: [PATCH] MAINTAINERS: Orphan vfio fsl-mc bus driver
Thread-Index: AQHahFZyRNTPJ9NerUyWde+KqOy63LFUSPoA
Date: Tue, 2 Apr 2024 02:53:35 +0000
Message-ID: <BN9PR11MB5276B332882103EF50BBE33B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240401170224.3700774-1-alex.williamson@redhat.com>
In-Reply-To: <20240401170224.3700774-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6515:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zy1J2EQM9UJqZ+cB35AjWEmuL+A/WTZHd9TkyPcnq3ZMMj2l7SWt+TMmJzE7ceiDkEzI8ORUl5NQFipSEm2hjIjBd8XkyZsDa/3UMSiBIUpYt1E9jnDoIwI/uSXrHmeC3DR55KKlfI1aAa+ZG3iE0u0rdmKgJ+/wh1IlPo9mCE1hu73B6+68CRXBwpGxNRm2Iq4874W9h0nWY6Z5bLEQoMUI+IetGJ2OVZ4VR9F344WsDjA8JDgYPv8S13PrIVAUniiOjN0Baj82KEBOZ4mgJlBzXqFlTB6HIS87K3rg9Gv3YDQZGXECD+JrqOfAB2PQ+OK+skXBBd83iZzm5UGZojRpX5WOJCO+24eInLz5G/F+rLmUg3JwEkt3+IAotZF8WhbtrNPAXmIMZ7J7qO9K+6C9+3cQe5fsceS8g3MeFy+zHwdKepsCZl2tZbHQHCuUFf06+Qpt2KBnBeidkI/i25GC8uVRwugSxN5ChGHh+YAsbjnyJSHiq5I9R5OmwZZ5Ja+EbIG5p0tWIbd3NBw1LUVRZLa67Cr7+8SSorV8eLahCrwMFUOsTA++Grq6rIpu4kz7pgubjgxNZM22zq+GCXCSqB0yZTlg4dGq3e25niGJbRUF9ymVMjD5MsN+4bfc6lekVsvqV2nHvu6/PkNLkD6GMZN8fCAETpHJAwO2LcA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cRKta0YEBHiekNi9c4jj9CKGvmXBsNh73+HuoFuVhFrxJKqJPWJeokJST7a1?=
 =?us-ascii?Q?Lc4/xHenTnk2+lZY+kjV+KHOv9+67DN6LmAmnoZNVtmdUi4huGNjaq74Dy63?=
 =?us-ascii?Q?XSKvHIsqM3+OHaKZChcKyyaFaVrARfRwVdFuTR0dYEtrc/cg8g/ucTmnq2NE?=
 =?us-ascii?Q?txkM9yoEcCe/zdpjNuWO4bRI1SOE9rk0CqN53yRExXIxrBLHmcdvrepMB1Ts?=
 =?us-ascii?Q?LizJckk5ECW0MKX1Nl1ILoABlmMaZA0IPW4C5xrB3C2xt9ncMXpJxT8XQH+x?=
 =?us-ascii?Q?QawbbHvCBrdXFkJvNDD5BX+cKrY65lLmswgwFSEHoQFUToV4Hp8PqYjQUB5L?=
 =?us-ascii?Q?gesbaSVBMovPn7q+SymmddlgUSZti2YMjhaBFyMsAEP4GDVXBWies5LhheGE?=
 =?us-ascii?Q?IBm2ZCSGlxnWU3abmuMhQvWvBA4lBfJEaTKcmY2VnO9mJsRIUr3OfRCeyXBr?=
 =?us-ascii?Q?4Qs2JzHcjk2bQ+eCNf/bpGhXPUT7jAX7Mqpg0ynN5HFuh+6y4Ykid2BlUjnd?=
 =?us-ascii?Q?7CTIvRb7cNun0XvnfApAm5HdmnXblt49xm+GSmA12ZMh2h7ouAILILghRqpY?=
 =?us-ascii?Q?BXNSBGCOG2l9X+K3tvaas4UYqTqwXLQuV5pdgD5Xf6bG75noRCV599QTFHSx?=
 =?us-ascii?Q?nHa8LlwN0Oj1jT8S4gZqDIglbihGMGT0CzmLKKGdG+Mr/CId4hmvB0bdJowi?=
 =?us-ascii?Q?AO84j0Z5AdZrHYT0KvnthYv8+eUTd2wAoW2rGIbSeLPMvPsMhlJkXIeeGr4C?=
 =?us-ascii?Q?34Rib5Pxt3AfW5G1znSzSs5rvK/M7T0BU76tjRm0Ern7tjLn06SOt2QMoqY3?=
 =?us-ascii?Q?z7/AoHFiAwWjk7tA2jVus0Fyd4ljNX1kEG0qOnzZBwvHeXFJ2ocqn9Cm5th2?=
 =?us-ascii?Q?MPjEhsBLow7BFf/NmFGMpIqdYFr7c2a0NPh+0kToNqKiFYYs7YV6eYBknIgR?=
 =?us-ascii?Q?K4QNkxIH+z6S6wHr4yffcNqi81LTkYN7w/yTNgnLKYKdfICcz04ZkspzSVFy?=
 =?us-ascii?Q?DxeCbOC4ff8DhlzfbPJFeaOM7w5c4ZBGX75xsv/m7UjzTineL7PJisAeAXME?=
 =?us-ascii?Q?5//qiGlCawv45eFaw/DpqQvWwFeWRxwmZ7oxMr0HFOG0uH/n+Eop2VVNsZ18?=
 =?us-ascii?Q?gLhNtbG7GSBcvaxEbZVgqyqD/pbxmrk9qhvIf7cOey8hf6PcRi8HLnr/WMfS?=
 =?us-ascii?Q?+edF3SZ54IAW9NY1+XrCCk6LOpMDDQ4iDMMR+XlSFZI+7zdZ6bmQ9PPJ39o/?=
 =?us-ascii?Q?/Uiy000D9hAH0Byo6bUuzTyvyRjy3G2CNwuqeAFpW8mF5CLv0N6ZV/Y4BSKp?=
 =?us-ascii?Q?CEdD+VMI8AWvDV3G8jzoL3y+pRQhD4p8mUuBNoE+iHu7EPNsiLQcc+Fiqgel?=
 =?us-ascii?Q?u5DM1iJFpSXHL0RKS/U3FZXBeaNXzlfATLIg/kQaW8y3Im7KerX/XA6hgxua?=
 =?us-ascii?Q?ppHAW6vZISquTSYyUws8+BaVvsojHLlgeEsQNVwAc5tV1yW3+08LTHi92EMe?=
 =?us-ascii?Q?nBzcnhAo2tXh9d/8wExPeDzZEY3334DfyglM2suRX1n9B4pFAJc8tHNbZJtX?=
 =?us-ascii?Q?WmKn9sOoq+N87IT3rjbtD8osDXeWnTio8/fvzoM7?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d1caf17f-c558-4630-9939-08dc52c01748
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2024 02:53:35.7245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6eIo5j8ql6K14yjG6ewp1f952lCQ/NkD8R3MWdO97GyeRXw7VaAP2d4TqMqTUrXfJrLtSI+cPZmU7lQfActFeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6515
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 2, 2024 1:02 AM
>=20
> Email to Diana is bouncing.  I've reached out through other channels
> but not been successful for a couple months.  Lore shows no email from
> Diana for approximately 18 months.  Mark this driver as orphaned.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

