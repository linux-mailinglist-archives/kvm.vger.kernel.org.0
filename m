Return-Path: <kvm+bounces-52401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 307D8B04C9C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C87DC4A6069
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFB7EACD;
	Tue, 15 Jul 2025 00:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WITzlqnU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33624F50F
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 00:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752537654; cv=fail; b=OlntxhslgTF9CNdUZLmcDuvv/BjOadRM+5z7zahcBoREkbKmUCCzrICmsF0cg88GfPTMkbwj+HbGKVn5S8eWk+dKYnrDJ14GyBQSGRitFQBbtaVDqqIYVyggPe/+qVHSU0N5AuJVXDQQKnx0fRuahEk9bKVq0pudSyrd2sCCJrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752537654; c=relaxed/simple;
	bh=cifxFk1+yRetEyJJDrSFZtwgh9bjs/R08DnGAFA1N/I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qVD7x+q2cqfBrC6ogvpF3lWmPlLB4uuJRvlRhhflyUzzg9YyPdfOg+uQ4jW5AP1BHdZa9Mnhgck/zTzv2ScxcIlgqV62qSqBqntpJ/c2B9anh8j2QKgA4iw7QLGzZxOoMkcwrF8exiRuA2hVwhHmgZ32aG6zuePBtX+y29pDPms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WITzlqnU; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752537652; x=1784073652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cifxFk1+yRetEyJJDrSFZtwgh9bjs/R08DnGAFA1N/I=;
  b=WITzlqnUXmWrO/kLkvHlxhs6IObzIT2peFnDNvu5OlMpGdm/JJZu5VZf
   dyZjenj5yctVyVlZRr6KBKBdpjG3Ak72+tDhqWGTMBORUL4XdyjYzKFBt
   k4HADD8TJ0JJZAvdAk8Lybe2JCKZDpTXpf2mqv8r7JK2Gg53qYsafDz5J
   y2muIWw0Ru4M9mz/dUI9vE/+bD/QbnZzhgvbQu2Z0Q6jwMfabdKEqD3yX
   M/vg4mY3QhZRG2AoRzaHU+jj6oIes/gIZh14cEaQfTGKN8oAdWsfLBQFN
   cggFS+pqGPtyfW5+RROYnifadKBU/Wk55TTgnY67koGzbbLm/GUUdzeEB
   A==;
X-CSE-ConnectionGUID: 5MfQ+rDYThG54JkPiV34pA==
X-CSE-MsgGUID: 9R7/uXiNSnqCyG8f3rc/yQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="53964875"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="53964875"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 17:00:51 -0700
X-CSE-ConnectionGUID: d+SoEgucQ/uoIrzN5N0KPA==
X-CSE-MsgGUID: mGXh5ODKRseVxXcJN7DFDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="156883143"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 17:00:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 17:00:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 14 Jul 2025 17:00:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 17:00:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q914SsQTSHMCC/bGQ0l87F9G6AGFX1hiy27i0KfX/a3MWTp2qm/46otv9eiYnS0ibDqBiSavmal3wGDkxMsxpfQBwhnZ55mlZkqXMrq/V4w8ztYCor2onK4fQLQ3euqQc9TYs2R/KGoc7EM4dzR5VRWPo9PBVOvGPQTpgptUEcE97w/pflCYzqJpN5GQGHdvci9LhNr1Ybea8Lk4r/8fDPl2P43S3XYSYYzcA2KsY0MLqKd+rva/S9VkXSha9Ojt1kb6ydW3qRaD550wmRSYzvAewdIDmyto1bX+h+qS0malLmhjd5UPvT1Z9BHBHcEd3EJA2LVINI0OHZ0D1KBrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jULNASNYI8n8pcFfF/YYQFzS3GtMqq4zKT+ykq+Efn0=;
 b=ZwpfCmbceipNRjZXLE/jkWjRIeijG0zc/UoWgLLp3z+hCXiy20ff5p1U09PsvCkyuS3eEsr+jcdYYkR+Q84WATaD8DX/TeyWpd0nfy5WJcxzgDsOiKDTOKP2piaUPiDqxi9KDWNST/LFL4onkeVuRGsxxe5kVN6qYyhBzOzN7wFAOvJciKeV4h/1/qguIGRWICjQy4jpuZ3zzi2SuxDNiHpcTNxEWyVCfZ+tdwpYj9Pfcow1vIwksjYuerCVUUKxm2IaP4dAX/6YIXrNo9gKi5x1d1UwI4R4Ct41sUmddsQowLR2DabYDHEc2jmMBih0VZnRfTfrDzY486a7kgUxkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8203.namprd11.prod.outlook.com (2603:10b6:8:187::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Tue, 15 Jul
 2025 00:00:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8901.024; Tue, 15 Jul 2025
 00:00:32 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Longfang Liu <liulongfang@huawei.com>, qat-linux <qat-linux@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, "Zeng,
 Xin" <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHb9NmS01ok38SXGki5giGPTn/wobQyTRiw
Date: Tue, 15 Jul 2025 00:00:32 +0000
Message-ID: <BN9PR11MB5276AF779F95C58EE9D417688C57A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
In-Reply-To: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8203:EE_
x-ms-office365-filtering-correlation-id: d758cb05-6e93-47a8-e957-08ddc3329de1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?T/lONgEqxXrq+8xd9e5e6Hr1yIeBXBBsP2TlgbfJaPgiRVsooDAH+FX/sQJq?=
 =?us-ascii?Q?H8Pc8ULlbIZJi25yc9cVog8OKH9bZIR62NuPfHjNiuYA//L6L9THrTKtIynF?=
 =?us-ascii?Q?GqK2QchuTcica+GEYDwdX87zfro2oaSy3V+dWgJBtk5fb8iWRIJ1E/DYGcwM?=
 =?us-ascii?Q?cXGLPqMjxcSUFjqA/xAxc3/SALk48yNcT72ekt3P1wWZmL+VSHPq5Ta00Di+?=
 =?us-ascii?Q?Bd+1XT7k/K+5bE9W6XP/u/PZw2wKK4DVvBP/a8dKgcrhhcp4Exi1XUulkQUx?=
 =?us-ascii?Q?/T0Sp403Py4GBJR5KJ597IwW2NLokI8OLM6Tpl1rsNZP9CugQI5eAZL9G640?=
 =?us-ascii?Q?TtzWw1AX11B1pCgeqzSkJAtvj3Bp1VC6+iZy0G+j50QzZAWQuDudXgzGZ9ET?=
 =?us-ascii?Q?WblwXhJwSFJwip9ZYJ608vyo1JYYoUvKvDbqJVckaSIKs7hchjDlrGdm0sNK?=
 =?us-ascii?Q?ykDWBYybA5FM0o/WoR7y/KxPDv+fAowXMrXcn0v9MgA/h9vU1/szc0vVwL/7?=
 =?us-ascii?Q?zQA8p+DvPUrnfj+7wYH7oueRq4DjiALRTI2BLc61NvooaJEH9vmFrB9R+gwX?=
 =?us-ascii?Q?4QATdibSyHEJbaOHpIPfkhPO5P8UpUMOVU0ij0iQete87Z4jon0uTyBCHTlA?=
 =?us-ascii?Q?mWyrhprwEijftdzqbaRLj7wvG/ksHCijQC/b/ky9nDxQtMcq90Q2g5/f9fhx?=
 =?us-ascii?Q?G800qggc4LX8m4kUtLVB/KTlGpbydVFRbA5Q+mB/rK/UmW67JrAxvXAIbv9H?=
 =?us-ascii?Q?MpSXunR7kA69hd9auWfSQ/DDdVw1lcaHChB/KJJxChysjm1myXFYta40XuUQ?=
 =?us-ascii?Q?5l/chEDeQNvSHzoxLEtYIjFVftYmZSFqRZkeiuySrNd4xPm98ImQZnKJlSBa?=
 =?us-ascii?Q?i0h/ZXQ8Opj5T4rBJhloRD399RwCh33jOlwreZDsM53SaLlUeytB8Thlhml9?=
 =?us-ascii?Q?mLupT5SFM3IMiYrfclnyL32gmSYkBAPkBChlgTzD+QG89lE6fm2oqrqmjPyK?=
 =?us-ascii?Q?F8gl/2hAH6LlQLCIKTsXd0WQbzaa/0rc04ewv65UwlXcG3lxrawxYKWmmjW+?=
 =?us-ascii?Q?E0FYIExKKfJhpr/Gp6ZP/P71/R6+D9LZUSZFgVo70artUe8hKtunTfGckjkd?=
 =?us-ascii?Q?rPxm9ztxuc84CTFrIP+OQLCHAqGebUGBjo+NSdEFAFRCpB/ZxTo7U+rcX/4n?=
 =?us-ascii?Q?TYA1Tp3pN29ZFIKQlhfv6buLuaQAT190wer7QpyAuol5kCvUbUItDdZMu+0f?=
 =?us-ascii?Q?gKK53EgZZl2Gj9vFwc8y8INZ5FXjp4dcw5jRhk6Bdb7bLYyfTKtmVHSd+dxr?=
 =?us-ascii?Q?6fYdV6mUihLc2t/R8xrmyMjQ6gkT4n9X+kwJn8aOMgi4nWCNy6MVqzbYT3ke?=
 =?us-ascii?Q?5tQImPrBurQ3B9hEmNamR59cSs/BazEhCyqqcAUCe43N+/m27uIWzCtMstnZ?=
 =?us-ascii?Q?asT8F9SsVEya58FIV0H6nXomVr9gzjFZm1+sjwIaBu2+efrFxemEnX8Ne93k?=
 =?us-ascii?Q?aNSHdFSRlziQnvc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2C2quuz3lzvrcqujDZPFjeoS/+z7PLy07hQ70isr904B62lH0oSMTONAwZwq?=
 =?us-ascii?Q?foWMmiTwhyVvUvHm+sZXpoprGK1ncSvlZY9QSFo1AfmtRTuWxO/Ukcwhwr44?=
 =?us-ascii?Q?jElm7CTVCLjyypajxxZsDP8SHy0AajASPoKx8rLXLAmZn+mcwgjN/eFLTUQa?=
 =?us-ascii?Q?Fru4GKv6AdC6/Asc/+UT6aMPly7BRN81StuigsxxGYVbvNkyZgDo5JBaKgm4?=
 =?us-ascii?Q?UMhtryBw9pWqnCllXgSIX1X5x/6oINulgrueeCvM/YtxtIsdRo6hBSHxZYL6?=
 =?us-ascii?Q?3GItCgLispJzm3uBgZnM58Zx59OO9AjzMMOZnetL8hcT6lSHNuOgh0XyPAP7?=
 =?us-ascii?Q?VVX1/SJtyPi6udnimQzZgbdhBNzYq+Sch8zEogUcHato1qsnwSdYT1uJ3Sx7?=
 =?us-ascii?Q?2T5ocl/EstqEF9sygy7+7lHkwOl9l7Lip/XLQcrPEP63EEl+kdMUNwprFtqn?=
 =?us-ascii?Q?Khi4Mt7Oh2VwPV5489OiOtXHGrnpze5wbh47riVlGq+o4r0p1uAYPT1SN+qv?=
 =?us-ascii?Q?lg/kC4GQDKDulZTw4C4DVzCpKT5u41kWPlrBr1YLKTzgUNq6QNimih/3jY+7?=
 =?us-ascii?Q?qQQ9YnuRxmi6CcNSXZamiT+cC/Zs4yJbIX2XxdhjEIkli7fVwSkQGOAWrJy6?=
 =?us-ascii?Q?2ZXjB49J2kT/WPsj6YdMVir7Cg/ML8IdscsH76WG8XI/F3L1GoXVvCLKCKV3?=
 =?us-ascii?Q?Ldas51rLRe5XtwRqYfBtFnAg1ZNrHNNYZ9A+jTz6vqiTAizfYjPAYax7+on5?=
 =?us-ascii?Q?Zj78ZOD2aW2b3cs0aVqvzXKKAmYhyrSbL/FfrpWlMSpUz2j1SSj7PTc2puCD?=
 =?us-ascii?Q?V0EjvKsyjrLiVDuA9FPnCwOEjrmkuAJwvkEBcsG8jJJcUN5RnD8nZX5xgu+J?=
 =?us-ascii?Q?5qeHOIgllpbYfKqS9MngAbNQb6/mPSSmvQjtNzPGrNWhiWt8S1xiIpZTHAaD?=
 =?us-ascii?Q?6seZA6z6XkTJGiTz5bluZ6AaoCl4OVqCOK9vvaKUejrTvh+J1zvvhxcllGw4?=
 =?us-ascii?Q?CGh0fPZvDjytFmf86TowVfr67vrnEwTCw43Ob7BcteTakOpqKPEg3LDCqeJ+?=
 =?us-ascii?Q?BSAonAXPdTDJ32ymwkJyeyUwqEBGETFvxoVR9joqS7loTuvmPZu/EpmOKjK8?=
 =?us-ascii?Q?+r1u1+k41ZS+3035OSjWO+JRBX/YO0uNNtuO1KLMy+aWrcAC+J2lmTj14PeF?=
 =?us-ascii?Q?35RjAkP+epQ62Bf/rM5Iw5Zm+jzdSZOPiCpY0rQWNkKYu8IFcon55DbPdPHE?=
 =?us-ascii?Q?uf1D70ZvJ3zXGLVs1/2r+NoyMxreSw7NGBDewu1ZfX2uHhHLT/MdaEYFoIXQ?=
 =?us-ascii?Q?oTnC4JwNzJ5sRgd3tE8w8HPE0PeFuup/dj9Ph+7lAEPM4LJVhUt7VS0hqquG?=
 =?us-ascii?Q?oNnncbscRepEpuWvE8fHX0IcstTsDuJUZSP30lRMtxTqTJ9Yg/hp51uvvSRG?=
 =?us-ascii?Q?L2JtYK/iiFVDmQxpN+iSjeIBLHKydI8Hk/IzU2gZDunzVuOeD+mhZSiQEGzy?=
 =?us-ascii?Q?yBZRfbK76TSJ+MCO0YJjRa1JoIHtCSU9JN6YXX2urJRgBSMVzOPGaoGVkzDN?=
 =?us-ascii?Q?HEWEvD86P0ka3/0BAyXg6rjMmz/4Env/WfKQlD3F?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d758cb05-6e93-47a8-e957-08ddc3329de1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 00:00:32.0921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TJA9yheerJdS1M238LTTp0w85cidSqH2YeyiM5K7x5AU1oyYFd5S/h4nEfx5i0ESLgNQWiAP9smgMxphIFZ0RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8203
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, July 15, 2025 12:08 AM
>=20
> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the
> group
> FD, something like:
>=20
>   "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
>=20
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
>=20
> Since we no longer have a device name in the cdev path, pass the token
> directly through VFIO_DEVICE_BIND_IOMMUFD using an optional field
> indicated by VFIO_DEVICE_BIND_FLAG_TOKEN.
>=20
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

my r-b to v2 was missed. anyway:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

