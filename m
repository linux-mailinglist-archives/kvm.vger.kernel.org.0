Return-Path: <kvm+bounces-63199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE9EC5C76D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 11:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 919304F7A9A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9AF3090C9;
	Fri, 14 Nov 2025 09:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BkXLJ2kS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CC43074B3;
	Fri, 14 Nov 2025 09:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763113055; cv=fail; b=h1EIAjamtyhL2ixyuuFBDJcS+2w8Y6Ywal3PbPAHfiCB1Wa9VHUntqNFhI2Lv1PT3TK4DWYC6jYhK7AYHxluvNKNQOnlv9OkT+UF4DH/GvevJa3HOXL9jRbKMGjb5L99+lCwXGr9mxJmOMfmkPlKBUj2X/VPDc6cjLvTtYSuAYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763113055; c=relaxed/simple;
	bh=or9OURCyKBIfsrymq7LrjHS9fQDVAcipBzCFHSDbTi0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=guMbnaCoQm6neKKGvMxzGkpeWPQq9Y9K+GbyX/ZA3QuL5pLpJCzUEWfmFZHapx2F1jUPMtnroabjoUqquFCsVaFBKFiNOo0oNLat/wq9uQiz73homo8ZF0hVm/2gekhYXOln+zimcC42s5JUpGJWJvzFvHAEJqg0kZ+QMH01R+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BkXLJ2kS; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763113052; x=1794649052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=or9OURCyKBIfsrymq7LrjHS9fQDVAcipBzCFHSDbTi0=;
  b=BkXLJ2kSjlR7o804cu5kFFew3TJz3PeG/x7NNQ8In0DdemYJqZ9/QUiC
   +hhfaIb0ScALiZZ3VJrqBSoIO27GVsmpiYbdAvtx+10DPWqVN0LbUyVef
   Qakkh/qfJ8z5z6Cag51fbYcLWnFBVHUgwOsNRQyDCQcxIVgqWBGrHlW1W
   jSwUIMLNh4pbuh1I+gcSoD9S00QW9w2g3ocEbMlkl/omKPda6LlDIp+Cg
   NSlFN09TkrejMTyc9PiW+oZ1/0XgaC51uH+9vLFqINkRJ469s851EXsrD
   AIThRivu5M7+igB9/KCJJQE8eOKPOAn4dBq/wrBvv8qaDBovsApIplLQI
   A==;
X-CSE-ConnectionGUID: fQG2gss2T8iJbO4o9zqAEA==
X-CSE-MsgGUID: YrLZinZPTImtPIjf1sShkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="68830035"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="68830035"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:37:31 -0800
X-CSE-ConnectionGUID: jkIj32u4SUCqe4ZBk+1Pbg==
X-CSE-MsgGUID: PE6UW2LyQ0uEPKljE6Bu+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="194885134"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:37:32 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:37:31 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 01:37:31 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.55) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:37:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbsXQ6GBF+gdkamu6uJrZ6JD+bsNGvPkTxPNtDIFaVcdUj7hTNToYhSuQiUAsA3G09FamCBBJ2Guyrhs8q4yooZORFNPCKrgMEC/4YJCFyrlcoKBYyHy/zwKFc6QO6SQ7+JZRAga3P6jTzlI6RPz30w2ESDAve6ahxxoYKH2hthipSyPjza74W2QB3dnUBnqbCemPmduDd0IvJdHMH61++KvoxyvMa9sOTAWEhpWkKI2smiVGLU7a2sfVOdv9yAEmwsOgqqMTA+0sxELeHF6zUUuCuGNezPEp9IkiVEPEoavBmdObsiLt2O7o6N5Cz9AxPa0lgcBs9L4iZqPqNsfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsOxgr77rFQBUvvEG3xJx5uvsS7toJIM3cLS645qJ0w=;
 b=olIDRKZcSNHHVR7Q4ZeDRlWKEokNRH6JKBvHoSlWTWl17490m1h18PvBPNFxYx+82HZTzw1UdIUNibSYamUpeGFjr511GAbz0pkzXMIGrxfvZ5GoAPT6L06CifQ9TIHsdf0GGWR0sVVl7yvoMJmJ3kM5iMHevOAQ6j+YtQiQvSpgIba4cqAmBlmNRffjVpodRNL5aGgqf/pLAhAZZcmOkTKxaAmf25T7ss3XK8UJ6OT09VhdBPdxbFjD/ERfWkk+G0fjvS3vX9baN18h5ySz9RztydJKLUizlECYZQxHnkbY1m2qq65jbtTk2/l0zICn6aM/UOiKSjHJtQuJ6EN1HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4731.namprd11.prod.outlook.com (2603:10b6:303:2f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 09:37:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 09:37:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"afael@kernel.org" <afael@kernel.org>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
Thread-Topic: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
Thread-Index: AQHcUsn0U4OK+eFVREizq+Vz85UbGLTx6dhA
Date: Fri, 14 Nov 2025 09:37:27 +0000
Message-ID: <BN9PR11MB527683978D304128441125C68CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
In-Reply-To: <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4731:EE_
x-ms-office365-filtering-correlation-id: 578341e4-d1be-4df6-53e9-08de23616ce5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?3EnnFjypX7AXcO5B0gxquMpxRKIUfgQ2vF7Zzwm7qPEip4I+dJMmL7sdQhrV?=
 =?us-ascii?Q?CG6rUPg7/j/JG/ZPa2AylcXhq/Qy5udIWxv8vT8ee2Yh8NlygBdQyyxHtegt?=
 =?us-ascii?Q?iL6pTpUIpD4ntEg48EkGazZ9aBl4ZK8XB/OwbmldsxEjSgq4QTcGun+aNKDH?=
 =?us-ascii?Q?yyYBXT4Lwl3ljj7YjiReU9WcHmi/Ku7xz77Vl4Yf//z5d+AqOTOvLeNW/TFx?=
 =?us-ascii?Q?WLQeTnXIpgR2/u18uu+bK9xt92XfvqPLL1TL5YVVAM4tzKWHvng0kxhmU2lG?=
 =?us-ascii?Q?YM4lSRb8owNFEasfZrVs1EY1Pg5DzREDnXP3A7PiZInpgcE4wV4500zlSMhM?=
 =?us-ascii?Q?tSQcK63/5mpSGL3jKzpXTlPpeahFOebTUgoaOfCvJ6p6BVvEA50cg9seZZUe?=
 =?us-ascii?Q?IqmRb7KxeJ5lonfoIGvilPQaHh3urvWUREQ8PW9VHQmkMJUvuDj9LpAGffhJ?=
 =?us-ascii?Q?cKbUbnBLFuWmplW+a/5bGF3kRgnzNEFvUWcFyryHnv64c7ty0Y2vmBEOpWnJ?=
 =?us-ascii?Q?Fdh5/qSm6KeYmya0STIlK2CVsocP2hmNWj9ub+SVsT3OETGc5gJlb9luDFod?=
 =?us-ascii?Q?KxUWPJMFWVJDvewdCQRddygMIi7ddm1kNaw1AVQBwo1EbRWNPIYKCOI+q3q7?=
 =?us-ascii?Q?PQmFXB0bcMzjeO4rb9CCJJvDZdhKoFRKQh327lQgSJ8jqGHoZErVbtkUe+65?=
 =?us-ascii?Q?0IicxlDHXATf7rNy8iqpeRyq+TjGyI0bh0tORlCvnXUYaeK9is0Pg2Oo0u8t?=
 =?us-ascii?Q?aP2XZ662VXIyJFqcrGUJvMoXYv0GTpYK9FRc3EZu8w+dFLN59189ZxtmZge2?=
 =?us-ascii?Q?sBToNYbm5L1giD2eKsiHWBGPx/u48LH50ZSh3Ljnb/7wDn6Z5JWiZNr67M0X?=
 =?us-ascii?Q?y9rft6doA0Yb2rMI7Py6mHeCgTPLKnrLEeENg6kdUkPQzMzDqDXbkBKXe16Y?=
 =?us-ascii?Q?8HZxpxoNIEqQXjVrvhEUPYFLmUszZkvDO36TlE0Hps0Cd3Hh85nnc48B0HyD?=
 =?us-ascii?Q?/oEKSdyyL0gfQ2xXkO9X0I4gZTfyQC+7xXNCMjR1pMfze7Jh+t2O0stRYZew?=
 =?us-ascii?Q?vOf/K3L1IzdLmYJzakB7NimXTognVGMx0dczFX0sNKydU4/Yej4xXkw0OnHn?=
 =?us-ascii?Q?XgTU8ZpfBq2x9uR8rsyGeRJeBryig09rbPHrFDpSKLRKihPKVQD1lrXGFQgS?=
 =?us-ascii?Q?PBTWXD8z7WS9K5rAu9LtG5QRZaPUiNgD3PQP2r76dAqeC2+BC2uFQbstXPl3?=
 =?us-ascii?Q?shBTEuyCtJCACcqYnO++l+oECLFsB59BSZPAuAr7gA9vgiUCh3X5EQrcqdJn?=
 =?us-ascii?Q?UrMhPOKaAtkLB9Nt1Vn9ZrqrSdK9YiE/3z8Be+ebWFONFOlr2AZlkLKC7TV4?=
 =?us-ascii?Q?M0MD3TFZcXP60LuTmF+930LI9DoZIJNqj2TRwikdk+Xrxe2//OYxK5RUnBDY?=
 =?us-ascii?Q?okI5zDhlzrFM1SB61o+pnuZTERHV6R/xXB9pZma62P3K9LsaQx99p3wBmq4p?=
 =?us-ascii?Q?9TDyGiBQdHfAHokx3zY2a8gs5QjgrkIV5uoy?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QRNE3hzO7Xw8LxEIGNZcGVpoZNXsUNmuN416nMaMWq0qBR/5lPxXdYVHln3O?=
 =?us-ascii?Q?yMva1Ljr4LrUmARhc15m0UIWPfUCSRS3IEVfUL8TiUTR1C9moRROGi7MU2Dl?=
 =?us-ascii?Q?cmRd7tR1OSTQpqIF9hB8fLJ6sJT/RzlA1BfmoiqzxzuBx2GiHfKK2vP8vgN+?=
 =?us-ascii?Q?bkNbwEleWJDbZz0zBvZxWw6XJdzD17O59dcZ0C9zXMO7y72Sk80bVO1Tpr77?=
 =?us-ascii?Q?3HJZCTk92IkXaiibAb7c5rQQejQdlCNlSHgXqA53L0R57yYMkiSqYLvVjCGc?=
 =?us-ascii?Q?ZHc1cAcXlwoP26GTN783yWYqKoLkUR7nP8rb0HjyC2eZWuT4YNKQslDj0wwM?=
 =?us-ascii?Q?zaPUAlIc6GW0tkTI7qd5VrfZikLk+uCL2q6BGelwTUpQfzS2qflQk7HbzZdf?=
 =?us-ascii?Q?YizM5BMUG4WZ/wuX9p5RIWPo9BA6ZAw9/HmdHcv+DxdsWATvptqlW8/kRC5q?=
 =?us-ascii?Q?CLfsCaICaaD1BhXYN+ebWMl1ghwOaRnxKp6qyueZ9pPvlp2aKU+4RpnSvjhj?=
 =?us-ascii?Q?vxnWFtlkxXD0IcOBqfawSOKXgXfuIjBgmB4a9GI+otFyt4gI4L//19NZdClO?=
 =?us-ascii?Q?UB3Ha9VnrK0JUP2bDQSSsjvabllWcPwNg94yE6RiNhYc9aeIWWURSm5Yevlo?=
 =?us-ascii?Q?bNFLadEpy4UKn0bOd7ilWJ6WD/G9JGn35ec3Q9OWqADPIfRkCINBT2yyqDgI?=
 =?us-ascii?Q?kRBYP5IdtrWA46K9LhAItIAriVv/21rS4nt4ltZ9ckNCyyw9PSstBtPtVWbl?=
 =?us-ascii?Q?kL2bhcldTTVh1AZoZjzIoylqM2VHdkd5hagV3Be1p8BNPGVyA4vS90UhqszP?=
 =?us-ascii?Q?yUbJdll91WO8dPEC75FyBLixCKVWACB2wJ3Oaq6xFllPNdKayOy7ZaC2ic+d?=
 =?us-ascii?Q?Z9OpWxdpteBEUZSI+JxLCBWefGyVA8OM7wwMlWR8xWaot4cZl3SXzKc22jwG?=
 =?us-ascii?Q?/2JgL2Mxctpn0NAXK4Ma1+j55uvnEGs2TufkqZzVoI1ppfJTOP2SOfhwgWaI?=
 =?us-ascii?Q?s16h67cuHot/gf3srd3wJYab2/qYPjivtkljrwxGVhbP+AQ24L8/KGN0szaW?=
 =?us-ascii?Q?D7AYNGSQB7I5OSsbKF3hnx74RGwtrqjQbntQDTBfMIkqksCII6l2s/CS6yI7?=
 =?us-ascii?Q?SABEsx3EATvrgOeAUaiM9yA7kL/u9XPn/JogDxIOKneXJl1U8ob7bNGavGSW?=
 =?us-ascii?Q?IAWlUiiXPcvoH+3Z0zSzuPulE+S9ZVhQfD05HLLsaye4tcLkv/yHrNPcwqtG?=
 =?us-ascii?Q?u3gvPEIyfMZjbnQc+mS5+YRe7xalbkmCNz4Hamzq88Qe9Yo/TDZCypWJsjfv?=
 =?us-ascii?Q?ZSmHxr4G4ul8W4TtSba6VU5+1dfDEHkIf9sFUdlEGptSoi+MoKIaXpPe3+iJ?=
 =?us-ascii?Q?GJ0YK07maLSrhZlIS18MzxSkDGh3GTqybcHEGaGtJsOS77oS3+IVvf011TQc?=
 =?us-ascii?Q?mewcN7jKwSNfsGLGGGUVLDSQ4Z7Y1dtWlFGZxNNSHINNnnUsPIhqmXB5Iued?=
 =?us-ascii?Q?sofsQnUD9nRyYHdJS6FZOeXZYCo/vys/4s/p5nKiJhAMgF0JQn6x/QjlEG5x?=
 =?us-ascii?Q?hUbh0wHHq1EX5fzN3twLRvJsmrukTgYnl8e5lBSc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 578341e4-d1be-4df6-53e9-08de23616ce5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 09:37:27.8093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wpo3c21aFNPmji0XU9IvD1LYiz1GXm2xPzsb7KMf8nDL8yMSJyY56hAD5flOctP+JLTyM3gkTXjVSC6bH2a+0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4731
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, November 11, 2025 1:13 PM
>=20
> Note that there are two corner cases:
>  1. Devices in the same iommu_group
>     Since an attachment is always per iommu_group, disallowing one device
>     to switch domains (or HWPTs in iommufd) would have to disallow others
>     in the same iommu_group to switch domains as well. So, play safe by
>     preventing a shared iommu_group from going through the iommu reset.

It'd be good to make clear that 'preventing' means that the racing problem
is not addressed.

> +	/*
> +	 * During a group device reset, @resetting_domain points to the
> physical
> +	 * domain, while @domain points to the attached domain before the
> reset.
> +	 */
> +	struct iommu_domain *resetting_domain;

'a group device' is a bit confusing. Just remove 'group'?

> @@ -2195,6 +2200,12 @@ int iommu_deferred_attach(struct device *dev,
> struct iommu_domain *domain)
>=20
>  	guard(mutex)(&dev->iommu_group->mutex);
>=20
> +	/*
> +	 * This is a concurrent attach while a group device is resetting. Rejec=
t
> +	 * it until iommu_dev_reset_done() attaches the device to group-
> >domain.
> +	 */
> +	if (dev->iommu_group->resetting_domain)
> +		return -EBUSY;

It might be worth noting that failing a deferred attach leads to failing
the dma map operation. It's different from other explicit attaching paths,
but there is nothing more we can do here.


> @@ -2253,6 +2264,16 @@ struct iommu_domain
> *iommu_driver_get_domain_for_dev(struct device *dev)
>=20
>  	lockdep_assert_held(&group->mutex);
>=20
> +	/*
> +	 * Driver handles the low-level __iommu_attach_device(), including
> the
> +	 * one invoked by iommu_dev_reset_done(), in which case the driver
> must
> +	 * get the resetting_domain over group->domain caching the one
> prior to
> +	 * iommu_dev_reset_prepare(), so that it wouldn't end up with
> attaching
> +	 * the device from group->domain (old) to group->domain (new).
> +	 */
> +	if (group->resetting_domain)
> +		return group->resetting_domain;

It's a pretty long sentence. Let's break it.

> +int iommu_dev_reset_prepare(struct device *dev)

If this is intended to be used by pci for now, it's clearer to have a 'pci'
word in the name. Later when there is a demand calling it from other
buses, discussion will catch eyes to ensure no racy of UAF etc.

> +	/*
> +	 * Once the resetting_domain is set, any concurrent attachment to
> this
> +	 * iommu_group will be rejected, which would break the attach
> routines
> +	 * of the sibling devices in the same iommu_group. So, skip this case.
> +	 */
> +	if (dev_is_pci(dev)) {
> +		struct group_device *gdev;
> +
> +		for_each_group_device(group, gdev) {
> +			if (gdev->dev !=3D dev)
> +				return 0;
> +		}
> +	}

btw what'd be a real impact to reject concurrent attachment for sibling
devices? This series already documents the impact in uAPI for the device
under attachment, and the userspace already knows the restriction=20
of devices in the group which must be attached to a same hwpt.

Combining those knowledge I don't think there is a problem for=20
userspace to be aware of that resetting a device in a multi-dev
group affects concurrent attachment of sibling devices...

> +	/* Re-attach RID domain back to group->domain */
> +	if (group->domain !=3D group->blocking_domain) {
> +		WARN_ON(__iommu_attach_device(group->domain, dev,
> +					      group->blocking_domain));
> +	}

Even if we disallow resetting on a multi-dev group, there is still a
corner case not taken care here.

It's possible that there is only one device in the group at prepare,
coming with a device hotplug added to the group in the middle,
then doing reset_done.

In this case the newly-added device will inherit the blocking domain.

Then reset_done should loop all devices in the group and re-attach
all of them to the cached domain.

