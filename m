Return-Path: <kvm+bounces-18354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCD78D4236
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 02:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EC3E1C21118
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19CBA31;
	Thu, 30 May 2024 00:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VvzEqOXY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596567F
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 00:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717027795; cv=fail; b=tHwTaKeqdBPqvr7IZxm7WVKO2iQQML8JBLWf2FKSXKPMeGHxcPwc7tsirBkMLqkUp8Mh/qQN+0x0LnzraF0GeYZyUIMlLi1fWbhIjULE2O/jdOtH7lwavhNevN5fFdYk4vNTBlpc7IzPzaWAhpEA6F+47dFa1RIU/mBwxKAcTl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717027795; c=relaxed/simple;
	bh=wmC0A/TFIhIGrEiUVCeePnVfqcngEURfu1tzceASz7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ToRHPcjaP9Yb0XE5F5GPA3dCpfp1hp+ZtRUg6ZszdS+tup3zgokylix43ydq1oJXdQpYNEvtvNeuZMIbYyGEONEaeQ+TBcVRy9wfGTBlHlda4rOAZu4GuRIryGCMTGxYiVwrS/9sV0Lb8Sf14DdcHUYsMgiOY9Ir2Sw8c9NMZPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VvzEqOXY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717027793; x=1748563793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wmC0A/TFIhIGrEiUVCeePnVfqcngEURfu1tzceASz7o=;
  b=VvzEqOXYRbHmLsB+QihNXkzywzkAekMdILdqBWfuSHftPA0ZQBzscVA4
   vjQFbU3weSk4g9D7N6CaPYJHifPLvNh3fDjQ/LXoQVkF/UfqgC2aefFZD
   U5YYWIo8sj4UKegzfo7qEo4kco7b1lqdkt728TkDFaLQ9xzQo+YzZ9GYO
   GMAHfEiqATccXpMiG8CNKfZoYwvDa4rqx0dKWhzZn2s3FCa1t671UPEJr
   TDOq0/0z/Nkz3rR3fafGucGPaUNRTACdEVdyyjFsZDCXOW2V6KNp6uumP
   v2J7t6KbxhpfUHur9aOISP0E8lJ8cf0E7VpA0paXDFYyH6kJbtichWy9l
   w==;
X-CSE-ConnectionGUID: iBe+OsNTTTq5Y8yAK5ahMA==
X-CSE-MsgGUID: jAki7fx9TkWMnCJUzVb9gQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="24600656"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="24600656"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 17:09:53 -0700
X-CSE-ConnectionGUID: EOOiwOjLTyOfY+bStSRCfw==
X-CSE-MsgGUID: lG5EQHfsRKCLt242SLJFZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="36163232"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 17:09:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 17:09:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 17:09:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 17:09:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2WL4JrgYKbnzf8shnf42CQvEICqXyNZJI8qeR49o+ok8rtz6nEXqdq0lDIPB58ztMWk2AdKFPYSsfLsZcni8rJJiEy3NTpWb4yVTrl5zbkakPKtTkNAfeecu5iKLwJKwWyWZk1GT0DXGTZInvPYlxX/10sSpG67by4UZYhWr3idMb7Mwo0f4VE4Y6WzLZWrxK/fR1yOtUMerIrldy+gDN3aDDk97c0984FGMGhmHbHD6p2zWieGAXGGboF2gDUN9mwav7jqObeu3+FeRGWYeTjAD2t/ayEOLhU8fT7Vf80YPttQKQD5i73ADuAP4qzjSjbt17rBblv/bI2cC7SWmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8l4klTPKHM1d95rm84kZvkLkOpf0yNb3FxPTtphYq2M=;
 b=mvoiueriIclzQRfoZdGPp9RIQ7R8aGztEKpync7ADtH4GD+4z9oxP3xlhIlTNdnvXHukOIi+okQOIHmt+H6ZQAE/p1vQjdALnkoaqzBV4VZyqwWLrXoUwd4Zg0TRYe1Bz5Q8iGGwWl42RFUYZei69nalJm/p8rfQDcmeXtWRsfneNElf2O2OVPtfei7aiR17II1cXyuRAOyWuIQyr54fzRyAFC18TDUrsoZVGqTlcCA/V306uGQMSXr/LCVyuGDWBhtrGWgjsFvdHVaiL+nWDKBIvTkVW/HAbC90l5TfgAD5DLKwyeSAZLlMTMGVS0TjFfL+SX3HpLX1aCWs3In1AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 00:09:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7633.018; Thu, 30 May 2024
 00:09:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "ajones@ventanamicro.com" <ajones@ventanamicro.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>
Subject: RE: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Thread-Topic: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Thread-Index: AQHarUtexRr63CDGcEKkpW21XYaJoLGu7g9A
Date: Thu, 30 May 2024 00:09:49 +0000
Message-ID: <BN9PR11MB52769DB022895F3D310F52458CF32@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
In-Reply-To: <20240523195629.218043-3-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6822:EE_
x-ms-office365-filtering-correlation-id: 34a2b70e-2d53-4cfc-bc6a-08dc803cd29b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?Nz0kwmMWF7iIyTOQygCcL0gHieU7T9QyKCwzHxnRkqsd/2PAIAJURXLpgFmh?=
 =?us-ascii?Q?CvhRqD5AmhPo/LNvukYbBtO/rCh6H3YAaD1giZtCxF8VsQ9SNtWIcFjX0mhg?=
 =?us-ascii?Q?7tmmIcUGr+KKkloH1JXalPhHAywGG6Bmp5TuyCsdX/+2uXeyoEo95pf0kyWN?=
 =?us-ascii?Q?i8B3VNpKQ1R6+PzCYBhH6EmbMWN15411TOlnjBatN+PuZW/EKxNhtdTCE9gZ?=
 =?us-ascii?Q?hu30JEMAqEAsvJ7SuhBIGmp4TN6BaXnGFRkt5Y49smDbQ3rF+oVROyCoUMfO?=
 =?us-ascii?Q?HS3BVyHuiIfiSWZNy3aquXGKBpxN08tbSAvUfVzG73gFCeuSza+JDYvIVeSJ?=
 =?us-ascii?Q?cS9gPRf9RxhSm8YFu7NtIMEPCuCqRw8FGylp8AoAGG736eRnYoRmk46DxgRt?=
 =?us-ascii?Q?j0fT+ClO9V6qXZb17bvWefNIED6YMyOh7vvWGmZ7ze8p6eepGfWarnExiJN7?=
 =?us-ascii?Q?U4PbYwU4lZ0bP7r07TSsjLlIMM+sCHjWVjly/u6tk0HoNDoJRRTMf/NSpY1G?=
 =?us-ascii?Q?fL94JPH4AWlC6hXsbCFz6xdD46bt2ZDBcLdwkZ9u4k77I2N2q0pI2oK4t6MA?=
 =?us-ascii?Q?FfmPqFWNSOdQuFrcB7bqYC7wLObqN4AsaTpZEElxYWqHC21KbpYyj4+9Hrig?=
 =?us-ascii?Q?DbmVeUUyjT5Juv3bwtuBqwtcDPiVaalVEcXsrsCCs+za5yXJoNbITGBquufQ?=
 =?us-ascii?Q?e2nkSyuoY6IH8jKAtKRkIZ0Sy4igkCXMum4l1LaTcEy8Wf+0d8s2wcUsW968?=
 =?us-ascii?Q?+NCBPjBD2V7/ZhnY0QbRFQarMaDV8MdGSn8debyn/BxKDa48bmYwAEdRvqIe?=
 =?us-ascii?Q?mOJF2YtOvLLVna7ubQ+8gIR4HrrFlJwi/QYlz5GweiDI/cbq7cASdNiN1/hq?=
 =?us-ascii?Q?l9nXjZn0bPZb5waojnIRdYONXvYI8aJgM19+K2P2JYEqM4HW5q5Cijay7xfD?=
 =?us-ascii?Q?g5U0F4hv+YvMKmyC5Byxt1WFVCmHQW17NvR3ZPBG61aykmfxvjVVztWoTk1V?=
 =?us-ascii?Q?2+LGfsHTKZsPq10xNIGHKHjTpNfPGWZwsZ0cIQxLgQjwFGH+XJpErdbebsmu?=
 =?us-ascii?Q?+osHzAsI93A69/IoK7Y+aESrO1HKudHRkaL606+uc5rzO6d0cOsNy5BJS7Pw?=
 =?us-ascii?Q?of26pn1M/qpT7uro0iaJRUiswOS1aVxZgTGuBRGV4S+IxOGvv7oVm5rUqDsV?=
 =?us-ascii?Q?bTPNtaoRYHTzrEtb7+c7xmqFu29OiBzoJ2JcCZQMzZ+447qyaJqeH2MupmPj?=
 =?us-ascii?Q?C9rGXyBUHMqbHtIPz6kWEanNgDUhhvUr9z/weay73AosHBfE017lyS3owR2F?=
 =?us-ascii?Q?aTLUML2HYvRwoJVRPp/8moTdn9+L+ZZDvn8qOiYGeGgb6A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YHHQ5cyD/2RlbLM0Tvvon4nt3KIEeYpy1ywOoABvW5dU1DvRfRrnnLISlzGx?=
 =?us-ascii?Q?t5kacECXtVflxpd168TFuNEts6xGkpVODqYnciQxH4LliKfBqZweK+LX2ZTm?=
 =?us-ascii?Q?7BYJTZNLT8r1uYlMGhZ7z09w8ctKdgLtGyspbOm3JtX6VfB/FbrZBVcJBeaB?=
 =?us-ascii?Q?YYX5/fxbsH7YbEyE0QJ4V68FNV6MiNLXUOoKkqfG2reSifzUegDbrjgGW9N8?=
 =?us-ascii?Q?ETRkZas/2CrBKxKNbftmKqdPF2VaiUG5vQGwqPEFxsYxX49hs5gpleIvy+xl?=
 =?us-ascii?Q?VEeyLoiwXgpdVqaDgo3ur89EM6T1fLNH42ahvlaHWQO72zip0FUQK36lDUfA?=
 =?us-ascii?Q?1h4hiIH0olSGdaFxPzk+0Gewdx7PvWC8eot1Ej98o94X0chlzmDpL1m8RpbF?=
 =?us-ascii?Q?A0s+5hElNBa/exrOjsjISxWAosZ6p1BK46xt1lQhZmEl+fgO0O5HSWbv6D0Y?=
 =?us-ascii?Q?1qdEQXqmB8/jP1SXi7DEJ5CoGeKk7+5mN431Euq8zd57/fHsrtydcrgNh/Sz?=
 =?us-ascii?Q?BfQTsh0COIvhaOKdVu8SlLbd2H7H4HZBAn1He04ruzQf2E7Ad66DtjTsRNIo?=
 =?us-ascii?Q?IP9+5aELXIpOuXJcLTboWtPtbERJ2U309Kz3KTmqZLLbgK8Z5UxeQ3dR+vDD?=
 =?us-ascii?Q?h1VFcFuDghCthEODVJTuf13SI6BUJRzAqiC3DIcysYSEzr1T0uUdMcr1HtV/?=
 =?us-ascii?Q?Cnr0uvQMl9CscxC5txcJ8zwZ9obNztM2uFR0tVTqnWBggvarHQDCtR0bN+KF?=
 =?us-ascii?Q?pmab7gIow25EvGsPbl6RTBdEbpI27v1Ejzv7cvW93Msf3NJ7O2jhWFnw4r7i?=
 =?us-ascii?Q?PtrNFR+Cz+BiyIfqHE6QKBq0xlYnvtTR2foMOToLSFzAGb0TQbuf63hzU+tt?=
 =?us-ascii?Q?2dd9NZ77ZCN5bNjVcc+OzxiJag2RY1kmt08Qf1RwPzQqb8Pc8m5yWPwKXdIf?=
 =?us-ascii?Q?bfRJJmRtw3BZgYziQD1N6kwrGqAJHPhtH4wIbxJr9XW9mfFX4fqQGC7UUWxS?=
 =?us-ascii?Q?836a6CM9PSCM+ivobEU48IcQ/eXpaXddXK7ThPNa7tA/jXbF0eEgGFWxw+su?=
 =?us-ascii?Q?jIMG1nRrUtf+lr9M9fhgBeUJqptDCpKgj7LaRVxMJmwYzgLzOW3qcG+W0Puo?=
 =?us-ascii?Q?OnveVVAdy5eq+LXpk1ilvbSrIiNLH/urDwucTnnkZLPWx9JqP50bJRTos4f2?=
 =?us-ascii?Q?FcUeBcr9PTOTnF/v2rjvy37idRXICpXxuVI+EtR6RF0hFMV4ik3S3KR+63G/?=
 =?us-ascii?Q?TXL5TXcRBrLxQoWscQxmFytmHccVV8JfF4MbWV0FhAk2Qj3N1ZJqbrLNgWsM?=
 =?us-ascii?Q?IOJz87NVGCVJ/mXYf6w3xzH5FiTHzNDEzlXJJdn8EBo5h0BpFxDkTD97YtAS?=
 =?us-ascii?Q?dkpJcGuX389EsVx08OCphs5IBmkH1yy0WdxOEqwSjf+ikgwZVeZl+X/+rqSm?=
 =?us-ascii?Q?b4rFVx5EklDoJG0oJeH8iIKclBU0eAugjR3wBKXNp1vtZZKOSBYTwWZZaC/P?=
 =?us-ascii?Q?xlDwA2NokcxPoXtYtTbWDEMzXCBZpdngFyVRqzLaoQW6eXk/ho7UpPZ2S6By?=
 =?us-ascii?Q?NUyTY7HkzKHl10/ENpd1WdIJIUKq6FYijqvvI/+x?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a2b70e-2d53-4cfc-bc6a-08dc803cd29b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2024 00:09:49.9353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r+ae4OcjthEseD6jG/8P6D5pOW17SX75dNPeRhu+rFI0BGaZoO29k9tpH1jR8WiihT7D67UqUrBK3elSRMJK6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, May 24, 2024 3:56 AM
>=20
> -/* Caller holds vma_lock */
> -static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
> -			      struct vm_area_struct *vma)
> +static int vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn)
>  {
> -	struct vfio_pci_mmap_vma *mmap_vma;
> -
> -	mmap_vma =3D kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
> -	if (!mmap_vma)
> -		return -ENOMEM;
> -
> -	mmap_vma->vma =3D vma;
> -	list_add(&mmap_vma->vma_next, &vdev->vma_list);
> +	struct vfio_pci_core_device *vdev =3D vma->vm_private_data;
> +	int index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> PAGE_SHIFT);
> +	u64 pgoff;
>=20
> -	return 0;
> -}
> +	if (index >=3D VFIO_PCI_ROM_REGION_INDEX ||
> +	    !vdev->bar_mmap_supported[index] || !vdev->barmap[index])
> +		return -EINVAL;

Is a WARN_ON() required here? If those checks fail vfio_pci_core_mmap()
will return error w/o installing vm_ops.

> @@ -2506,17 +2373,11 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
>  				      struct vfio_pci_group_info *groups,
>  				      struct iommufd_ctx *iommufd_ctx)

the comment before this function should be updated too:

/*
 * We need to get memory_lock for each device, but devices can share mmap_l=
ock,
 * therefore we need to zap and hold the vma_lock for each device, and only=
 then
 * get each memory_lock.
 */

otherwise looks good:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

