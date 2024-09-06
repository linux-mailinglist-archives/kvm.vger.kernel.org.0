Return-Path: <kvm+bounces-25974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 354E896E7D1
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B1CF286C65
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 02:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671D9381B1;
	Fri,  6 Sep 2024 02:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzHUepSF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647D27450;
	Fri,  6 Sep 2024 02:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725590504; cv=fail; b=ThAzZHUZrwvKYa7VWKUlFD0DCtbwmsVTPyAfpGLrZPZvSDg2JnCKUyn5bcBpCUL+nJVIqRd/S0h6vjv8OTjsq9R0C21zf1bfguPjjXoZBTBqLw/cNJpOxfSJr7j7teZ6RT89G34JVq4SEkkg2AMNJBEs5JufzyxkOEM5YKGBdmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725590504; c=relaxed/simple;
	bh=HtkGb0zP38C0tx/5w8ovR4Kufi21fmwl4hr+U/oNix0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bfh9tvvbNiNYnSk/NXxf5gOClGohs6k72AoE7zbvzdpm2HP6L2bOWUCoAJ1MWYlTV/ix9kckGadUlvsmiZHlsBVca5+INwhI7SGgBAzQVylqZDFDAEREzrZVkwOCtGBS2cOZqSgQT2UDK6/tErbfR2lYgkaPq20KAxXGOXYKERs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RzHUepSF; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725590503; x=1757126503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HtkGb0zP38C0tx/5w8ovR4Kufi21fmwl4hr+U/oNix0=;
  b=RzHUepSF2y2hU5uy/lEjBZ8z60h7QvFravqLn/q2S3VQkcqRcU/+hbZP
   fQpLM/EzoDWVO40i26NR1LFFwD7C85CjfuMht3D4ZA7apyADP+eHoqL1n
   0WfEMgp+RdGDzOxK8GVYKAEQmgQK34HMq8ehLfx5VbxsgjLOAD5nLMw6b
   NZgNA5kiPd5KPN7Ev3yYCkRj8JAsP/OvplilzrZPYMpSkdpNmTjcqth7L
   z/ya7K+fviVci9uP69MPdynOmz7b1/Wn/+LSHBtr03GLyI3SKVpD4VvSy
   EV4kqq3xNrsNNq5tR0UefZ5gz3+IQ188ozDCP5+Xh1rSePLPPyJCyrIDb
   w==;
X-CSE-ConnectionGUID: krseU/d4TtCmvfRYkm7ymA==
X-CSE-MsgGUID: 3HhooI0/T9aO19mE8k6pOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="28129489"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="28129489"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 19:41:43 -0700
X-CSE-ConnectionGUID: fi6YvZ3qSOOszbDDGBrDtQ==
X-CSE-MsgGUID: OcdOXlJRQSemtj3T4iVBQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="65810915"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 19:41:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 19:41:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 19:41:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 19:41:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WuArN6KYF3yGbKFJCZAd3inL3clhGloIbb0dqDYri+6QQG6xIHrYMK68Bg8Cz8f6IXKJ+5ljZOS8TjcA8bnug2X07WWE2C0ElLgizl3h81g0ePjAFOZbOHraFLJKI3uCpgfSZLvpiknG/ZUzZ3lcK6FwG8aXDyAnfmrdPLpLN25Lhlpb3jAnTT559sqWKnWBt55FxX/ETknzJhmOQfERIzoHEyHCSODIhVdgUiWeQ0JBpvy3Crblp81b66PQJyTYwHIF0dMMTfXbIbjiiEEqpbU9Q4cdVU0BRykkb3/jcCe3v86QUXUjWMys47hn0PS1j9Oldn0LqvtN1K5+deYM1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtkGb0zP38C0tx/5w8ovR4Kufi21fmwl4hr+U/oNix0=;
 b=T1707yTgqBkcNgeqjzClna3EjocEPfH/VsElP79jNtpkigrX31dE73o9VLO5TWMfSeOhOft+c1biceUWtiT3YC4Cpm0jHY6ty/3LzZ90FYqvT+7eC2vHvQMon/iq8NwIOOqflzoy7bbjRXI99SGJ35KfBp0RFW7JUyRjigzlhNfq6tMRzQIUCeCalMcvHcGi5i+cKDtsEFfE+K9DJwIl3qVl21N12PfPlS25jYwPsubpkW+EfMjZ9RaW7p1fB/JglNz1YQlYUEKX3WI7OOrMMVRCG/ZrMH/PU+T0QnnVyBluHg0EQckyjcrLhN7NMsD2ESu27qb+WJ52tyhp4QcMUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6474.namprd11.prod.outlook.com (2603:10b6:510:1f2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 6 Sep
 2024 02:41:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 02:41:38 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Mostafa Saleh <smostafa@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgwgABEaACABIX0AIAALPiAgAEeNQCAAHoIAIAGzr6AgAA6GYCAAA/8AIACSweAgAADRwCAAAMgAIAAjnSAgABfTRA=
Date: Fri, 6 Sep 2024 02:41:37 +0000
Message-ID: <BN9PR11MB52760ABCAD1AB37420A49ADD8C9E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
 <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240905122336.GG1358970@nvidia.com>
 <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6474:EE_
x-ms-office365-filtering-correlation-id: 02ad91a7-fe3d-45d1-d516-08dcce1d6e58
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?5YNpD1fcITF04GImOAdr11WY6vkSI5gfemTSUVrMszOAjno3MIm8WFRnP/Xj?=
 =?us-ascii?Q?xNinDtEXIvBSe1BerbcOk/qDmlOLPz2Qs5JXWGiBebZnm3L6N4Hj0LZ3Xpu4?=
 =?us-ascii?Q?93feWYcd8ijH4BHKyvsVN5twVUHEkHS3WoX5ctp0w79UfgR7orwVH2S5Hdjx?=
 =?us-ascii?Q?AebiG6Rf18PLylshpcHcvqysSLvCC9Ll90QSH5R2iK6MVsuhDSBo5gouKA0j?=
 =?us-ascii?Q?zxacQJJI83tV8Ik6kmXCEGE5aFFBOkCIKKMrn2NORWYAqLPhE0ctooOykx3f?=
 =?us-ascii?Q?SjGFYKALFXMZSotgb9wIIBMhmngBffYHRz6IZhPzCzkKK28zHufCfhS5GXNL?=
 =?us-ascii?Q?S1SyGpT6vyuY+XbjnKR69aU9X0fMhvf2EhId5z4RDGLm3tqMeQhSHGz8Ahbf?=
 =?us-ascii?Q?vxZLh4bDaaccFbyJxZQ5wFqfS9Bs7qWECoTSysQyRgIe3/q5C/1H/YBOaGtd?=
 =?us-ascii?Q?6h+b2GrZ20Mzm6Mldd4DygdPdZBbFnjtdAFSp94mxsq0dRLJdWe5OVJNcW9C?=
 =?us-ascii?Q?PrV65fu3QhCBKJPKBgQ9bZ9q7RBxc9WtqIGge5+OmDWHXTpiunQhmrPPVJGu?=
 =?us-ascii?Q?Di1uzKM1qycvrz1fmGSMVMvj5+2i6uV/ZZizGe3PTcKJPtYnAADTTbxEpq+m?=
 =?us-ascii?Q?fblIR7cJL3g6caWGEEpf6Yw+CJe2/OdBWj/xQQiwoRgfvFvCbGk28vkEux2K?=
 =?us-ascii?Q?3hin5L7LE6H6zfwTP7hu7a5GSiamCv+AOyTNtzDadv8ws7e4YTZf2CxjzU4E?=
 =?us-ascii?Q?wrPwyQ8VC9DN67iU07DuepEoHTmZZ6RxelkDvZkxjUxQYhs4PecEfFxQpvF7?=
 =?us-ascii?Q?lUoZkfJM8lu/5PlnkPQi2YG4xNfe5Cz0LYu/axV/U7ui3WQ1kcYh/dAJWFAT?=
 =?us-ascii?Q?dGWOjrZKo0PlNl58HnHAOJpVkpxLusdyXEwjNd/J86J+5LXDjN5s9f+C3eh9?=
 =?us-ascii?Q?qCXSlQJDIEiyxEFnHUBKYbJS6fDGE0F7Sv0nnrU51up4loqWXc6dNqMXU+S+?=
 =?us-ascii?Q?c6LRNxUk9/IP/hNQhun4Ln+6un8ITf7FYBSQFUpqvLOP2N4vJTYbxfvo5BmT?=
 =?us-ascii?Q?69M1hegQzd+Yrq8ABO0OQzZCTD4decG82L3dYvTkJGke40kVzhxRK7S88k64?=
 =?us-ascii?Q?7KsGBug3agm8lQ4UgntqkD3VfJKbuN5xn8YzUXBqceKSGrjmTXUsTX8XxYzw?=
 =?us-ascii?Q?Gv0Kwi46yUXc6jUd1EGs+v+T/ZhhVS8D7Jj2OoIWWeYH04LkOCCfkH2TZexk?=
 =?us-ascii?Q?/dCpiZ06gfCmtmKFW0lgPqHO60+CNqpEZq4nN3sUV5tg81iJkBldw19E3gVN?=
 =?us-ascii?Q?u21IM82l5acf6f4hHHCMIC+la7aH41Q6DE5k62rXluU+Cmt+kGzNEIgmqdI3?=
 =?us-ascii?Q?tgUPaYnnIUjECwgqQTlkibr8Pka7hPyL5MOeawikQD6j0hz6Qg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0/2eCoO4LanJM2ewaL01DJcuL2ajzr0STVUyuZSWgJbGqA29Z2La5C7VCKGR?=
 =?us-ascii?Q?gpANjILwkatB1f8w2pbQGFalxSS9KBgvxewhJHmPXpcmE2MfztrwFVylUG9Y?=
 =?us-ascii?Q?NidK94Vy89BWtz8SgJEfhdAV8JNxqRNckuZNsqbRsstF5BlmKManN2WeuOwv?=
 =?us-ascii?Q?cK4idWFppOaIrfMUAPJeo7CwzknARlUHjKERhWVIX0zrHflQOK6lUn8AZeTR?=
 =?us-ascii?Q?6gwR2UDvgsoA3mLqWff9ir90xCKYtMJgE6ymVz9vH3PkDZgb72ud44mVLe6d?=
 =?us-ascii?Q?8YbdOvaVGrnfjaTr1s7K3AA6M3bHEoi8IMmq70CyId0vMpePtmLpt3AWS8in?=
 =?us-ascii?Q?L3OlB7gcrLKkocJrifOwxR2DmOQRZk8UpcMpQDv5Op0J4grzz4N5Z9j5IPdn?=
 =?us-ascii?Q?8IXqJnP2NXf1LlspV2ECw45Y0WCJ1u3URj+3oWcVBOWyPvG7aQlNnCL0BovU?=
 =?us-ascii?Q?k+CTdy7b8KuulrvB9ewhb6EUkI7sgylF0GQS+48/JVb39e+k08PEPCDl++tI?=
 =?us-ascii?Q?iBQ29p7lQR7HzHLV8HimY3gwBvHSJUVJjrkSrUnhiUDGMkWC3RzFNT8XbDpZ?=
 =?us-ascii?Q?fFW4/yENmnaXSY4XXoCcA1OIYoZYMpoY+9KzB9DKV0FoHfSMCsv8uoZ5YNup?=
 =?us-ascii?Q?oIJ80RtPNh5Gz8vLBYk3wCYbsNu+CEbq/RgY3LNfY/knQCiBLg0Mb9zlYJ4v?=
 =?us-ascii?Q?rs8ZS9yg9hsjbOpf4qkxU6wdxsUzpF9hUGDjcgApNF2+B1+P0q8x7gavjcAD?=
 =?us-ascii?Q?TjEADyaw+FNrlgoyKk/WKHgfECRKHIz1ZkXdL+d5OXWZHL6yAfQrIfxOKXPE?=
 =?us-ascii?Q?tj3TZYUFPzMo9Lr2VkzE+ELjL8U67L3QFGyMLbe0q7jpaZ30IsCc9EqIkJq2?=
 =?us-ascii?Q?ZHJ0isYOJRPcT01zkz4DSpul655YVDL3rTfivIXndsoXn1JEX5c3UbJUIf7G?=
 =?us-ascii?Q?m0XzdU+3MN8lcNwexjisJNxT7fDRSNYmmFKvIe18SvGFKOeGwGPtfmojgxTH?=
 =?us-ascii?Q?m4MJ9qJQBZObxzZRx79Q4Y0ebV1EWlKz4p6JfrBeD54I/FIx/J3v9e4gTb/X?=
 =?us-ascii?Q?oDbE8sG+uuAiX2w+X0xbiuu63OqUPv9Xuv2HrAlCU7USlg6fJvJZQEDFXXxU?=
 =?us-ascii?Q?Y40FrU5wmthOX5H8BvtJDdMzB9KUESjDw+L7CxRFsPmkQWGen0CNStS3KonJ?=
 =?us-ascii?Q?BHkMc4LLX1dysWUgUxcigPNExNAPxq7LF+YaXo3Hn9as4Aof0Ug1N0ZbnUMT?=
 =?us-ascii?Q?QKksBJ8AM47w7KsG9QlHMnKVBhMZomOfvwgDGgQ3sH6gY2OvAw3Xcna1qqcP?=
 =?us-ascii?Q?DodSD4ht/F+8Z2qmquiTawmp3ML/c5PkYzkRNCyVuh58iijxXyulo6+SajvS?=
 =?us-ascii?Q?hEW/7hW2ZWnA9QmQNujTW3Q/XMgyLZD4OW9lqvoPBPWCnuJyo7TEDC2XN1XB?=
 =?us-ascii?Q?Jsl7gOwuNJcvaqVGWhD6Q28nVxATXIu8qkWX9wMHlDatkOGpl1+i6Jl+y7kL?=
 =?us-ascii?Q?V511TBZUhzJNFXnzckvqnzBJPWU2T03vGc3YvY1MY5MvANntxs+bGjAAqCg2?=
 =?us-ascii?Q?6t6ZqQNeOmGzp0s0c6bItcYDvvkKW3JKDH77uJKO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ad91a7-fe3d-45d1-d516-08dcce1d6e58
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 02:41:38.0083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gMZyttIBlSNynPOXeZzvPKHoITiokkxJH4PKwhgGsCh+CPX6jUyIe8a446j8wqdVCzShTD8oeBL3ao/ZG/bidA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6474
X-OriginatorOrg: intel.com

> From: Williams, Dan J <dan.j.williams@intel.com>
> Sent: Friday, September 6, 2024 4:53 AM
>=20
> Jason Gunthorpe wrote:
> > On Thu, Sep 05, 2024 at 12:17:14PM +0000, Tian, Kevin wrote:
> > > Then you expect to build CC/vPCI stuff around the vIOMMU
> > > object given it already connects to KVM?
> >
> > Yes, it is my thought
> >
> > We alreay have a binding of devices to the viommu, increasing that to
> > also include creating vPCI objects in the trusted world is a small
> > step.
>=20
> Sounds reasonable to me.
>=20
> To answer Kevin's question about what "bind capable" means I need to
> clarify this oversubscribed "bind" term means. "Bind" in the TDISP sense
> is transitioning the device to the LOCKED state so that its
> configuration is static and ready for the VM to run attestation without
> worrying about TOCTOU races.
>=20
> The VMM is not in a good position to know when the assigned device can
> be locked. There are updates, configuration changes, and reset/recovery
> scenarios the VM may want to perform before transitioning the device to
> the LOCKED state. So, the "bind capable" concept is: pre-condition VFIO
> with the context that "this vPCI device is known to VFIO as a device
> that can attach to the secure world, all the linkage between VFIO and
> the secure world is prepared for a VM to trigger entry into the LOCKED
> state, and later the RUN state".

Okay this makes sense. So the point is that the TDI state machine is
fully managed by the TSM driver so here 'bind capable' is a necessary
preparation step for that state machine to enter the LOCKED state.

>=20
> As mentioned in another thread this entry into the LOCKED state is
> likely nearly as violent as hotplug event since the DMA layer currently
> has no concept of a device having a foot in the secure world and the
> shared world at the same time.

Is the DMA layer relevant in this context? Here we are talking about
VFIO/IOMMUFD which can be hinted by VMM for whatever side
effect caused by the entry into the LOCKED state...

