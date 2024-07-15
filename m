Return-Path: <kvm+bounces-21627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F033930F38
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 09:59:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA208281158
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 07:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07A9184103;
	Mon, 15 Jul 2024 07:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BOn3CKQf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9734D174EC6
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 07:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721030343; cv=fail; b=cUlH0ZJBLjVHACDJTI49Jlo96LQ9NxMhpWTbwWQcPXXg6qLgMKgYisRrij7Lp/7FpX4pRddfmt5Umq7BRmKVCl5kg8f3v8SA1BJ18TVBdwKAPYDgk0FUu0Pf9UYab4ibrGOaP2L214QuKMotcCchb8hiADVs0ICpziTnEO5NpUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721030343; c=relaxed/simple;
	bh=La02BjPKoinWNSZ7f+VojwBlfTvxVUU60cZLUSQTJhk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EyNWgfphdlcae1aalHqwTzgJ8pWYhqoms2QhxtAM135GGD0vVcQ8O5KEDOj9/6XrDJMJnCNarP+azvqj/K34GM3JeGCxBlflGzZVSOIRm3RyfJ/U1a40aBFSwRj09kgpq+b3sPMHE8aEiFBJAmq1OMOCHw5SobPf8xYqh6IF+SA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BOn3CKQf; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721030341; x=1752566341;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=La02BjPKoinWNSZ7f+VojwBlfTvxVUU60cZLUSQTJhk=;
  b=BOn3CKQfCBfVxiERBcqWQgkqqwEaKxWjkUF/UDZ5oAC5ZJrTMntlyJGF
   L7u/S8AA3y3UqgRjV/+kMR1FuY5nBjs4h+rTHywHxWE+0gxdXVX0GUYD3
   W3J3Zd8BgDnNNGk85NcYOqUNNUBxFRvKs7okFh5m3RkNZvFaLHNux7L+V
   GkKUHJ4oVCC0OYYe29gzbiIK44lRpiCSCf3zmn5BipfDoEd1VJ9p7bu4c
   8Tgs+cPJ5Q4ySNZeS2Zwbh1X5BaVKIlf022Z+7t+0EPqzXUS0fikGIWXv
   /dfV6NQ018mpxPaNO5UUy2EtiB2p2XqlCtX0pGfZWKSLvhAbjaxjswGze
   g==;
X-CSE-ConnectionGUID: RO24wHTyQsCS0VvNGmL/bw==
X-CSE-MsgGUID: 2XiEMSc+TGqQYeSG6Xs50A==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="18509345"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="18509345"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 00:59:00 -0700
X-CSE-ConnectionGUID: tVG+4f4vSJeA5yl4Q4PgZg==
X-CSE-MsgGUID: XmsAahbUQhW0b9TGA3/JdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="50175254"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 00:59:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 00:58:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 00:58:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 00:58:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 00:58:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/R7rShWlrPZCDvaoZ2xImPcQP/W6PbvJLfZr4WTSMI4HuytotWO6TDrO+qkFTpvxfLt+KsOd7zJ8Zbx3SVqgpwwVRtOMxYY7xoEFaCgW0mBo93YxNCwxxmPFWSGCw8Q8jN5ssQbqcGnNtbD9f2dI9hWt9NauNgWeLl6g4DqS/lR8MRTE1iCaeb4db38hKXCw9MpsGZJr73QvwychlbkyMBxC9NolriHfwiTFbyh7Rd3q5jwETNLSdAPGf4YDsmQ5jDhQDvmzqytZAvVNAQmMZzYjTmG6CjQtMmLKmc+B0C2Eds8MV9ioYKKUD9506mkKo7CzHbEr3RqrX++4ppULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkcPoBBkiN8Dzh3KinuU/K4M9BqpOIpEIqsiXFmVL9U=;
 b=cOWCIXBavBRVqwJV1zhjDtIJVv/x9epM8ps9OQLV/LX9jobZph5zIk/YGL49qAAjUCdvyCAupVQ4Gk/PV3AiehTD5J2p6KXkn9JtrQGZe36vVoM3yotSc1jamGEzPItPidncWYqNjmWy4Ib+ag/aQYsqAWgpKAt5DpwNQ2Coh+d3RRoMvnerLoDouAuIQ4OpePvFfFCAFRKJoL30sdW2APDyadofHBgNtcZfT62/7my1kblzalTKKO77cwI2x0ljcwLg2PfikFo8e2v2TAPkDESEzekhKT0dyFRWFQBapymHdH6mQQtQ7Z+jPYnY/m/4jVU5h9vRHZ+9oMsYDG2MsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 07:58:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 07:58:56 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: [PATCH 4/6] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Thread-Topic: [PATCH 4/6] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Thread-Index: AQHayTkDMuhZz3UgBkCqkpbPanPEW7H3haTA
Date: Mon, 15 Jul 2024 07:58:56 +0000
Message-ID: <BN9PR11MB5276D8B3E774F967F8C5D8E58CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-5-yi.l.liu@intel.com>
In-Reply-To: <20240628085538.47049-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5209:EE_
x-ms-office365-filtering-correlation-id: d50adbc4-01ac-4dad-3db4-08dca4a3fa87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?DUA9dzEi/U9GOfUMWsQfzVaDtOZ/x3FrqswrFl4eKGEjCUVWzYoGPWO1nXvV?=
 =?us-ascii?Q?K6Ucgz/BA0DsXCyC3tAbeV/k5L0PC3sUEL31SgGgzXlFLcse1RDQ4xvao3uV?=
 =?us-ascii?Q?UialrG7a8Fsr3I3LUt+DfEE+53JOAY7bCrx8eiP+Ez6rKnBQdOoEa7N2JgdW?=
 =?us-ascii?Q?00IbdNgrkffMTFb1PDunXGzofE6bXSHrd5v5Yh8K6yOLHZ0evIxdMNF8ybRe?=
 =?us-ascii?Q?+8GpQJbr7UzvvEnIbzY6Q/2oNa3mte8IE6t4W2ouQX/d+NCj1nyAwNH9ITFL?=
 =?us-ascii?Q?9i2WWKal/EeYoP3waKViMb3RTuEc1vj+FkCuW7rwbaptKtOV7s3PS6HDcv7T?=
 =?us-ascii?Q?Nr792IbI7aVoQ5uji6rshf+meaP7GKIP8vfdrubMxeK35kT/6p+2WCoI8cSl?=
 =?us-ascii?Q?KSNcMoqYXlW2z6VmoeLhJUBF5GdFxEFYvSlzWpUMpcdNX5zIDh7lVoQAXnnV?=
 =?us-ascii?Q?Th5dR0MxJZs3+AxKcneJJeDjNudLqKiZI8XYCVLEpw5zYCQHXMVoWH0FBba8?=
 =?us-ascii?Q?OLsN8zfr9iiUXwHuiFih37xUNl8dW8bP/DjblMAb5W65SjKXHlnf5LkTuSJp?=
 =?us-ascii?Q?JBfpWWJ8M0wdEDtbERb9iXobrNj32il3UAWy3CflG8Rh7ph79uL0eJEPvsvi?=
 =?us-ascii?Q?9hjGrATtaEdNSqns+tQyzUEfM4XLbnTJASKVooDicLQMqpNIRjBgVH9gOdd4?=
 =?us-ascii?Q?b9P/jfHxl7e7mmQoOsj5eIVq6mNjG9QLCqaIssmMoNiTFmv9KJLFIpAeXyo0?=
 =?us-ascii?Q?xLCZPJu1HGmLhrC9ZnFJqZejw/qECifTGuwiMwlwp6XT13BqBCukYPSqORGb?=
 =?us-ascii?Q?r2LOeAAgM85276ulmfJismkExwB+E3bpWRr/RBh+0Bo/3Y0fkxYnTSLIlXFq?=
 =?us-ascii?Q?kfm7ydrXI+HiiL08Xoq7PxOqudjf2JDpR9Ngs9kz6GSwkEWYA02JR11ExOES?=
 =?us-ascii?Q?yA/lE5Ud1c4HXjk5oB4ReQTpRtrnAuz8rF2u8CJD0L9axKD17hNd7ysKYdsx?=
 =?us-ascii?Q?y+p4fOLXrei4swEaPrLdJJDi3QCcFYom+85OSS60x7m58+n/GqYgo6yg3K7Y?=
 =?us-ascii?Q?JLiFCmhg3R2Nd6nY7Drzq3yMNq/Igb1h72slsdnbbVIoSpkafoWItzAOkJoB?=
 =?us-ascii?Q?MxzD5xvx62Bs2UeIXlf2skhnoVqXnhmis5xZG3SNfYoRPBQNpQOQ4IN19CWw?=
 =?us-ascii?Q?zoy5PobeOp2ImwmT0NFnEU3bPvXJK4c8nT0t5tJ2FZjwBgXXl7KVSQh+kbcw?=
 =?us-ascii?Q?37Hm3Wxo6DyuwhY+ByAU2TJBnpC+qTpEkRKfGD+VwfSgcMwALbtO6SCwg36I?=
 =?us-ascii?Q?9NemIPV0ll0ys4q3eWrMPz8St0tDb2Uzl8EWMsuD/u7g3etxiXAV9sgql/7G?=
 =?us-ascii?Q?2XsqeY3ipOHOhnzA9xKM5DLK3+9O5EdS8gMmAohjm3TosnVVjA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/3g7ZcIF0nofnzWt+ML/jksbXN6Wi+cCccEyQPfgapTAMzoP45/tq5a7NZ8e?=
 =?us-ascii?Q?E7AwYjj6c6DIOoQL+7Bwm1XXcPfHC3cSI3el5Cu0kEV/SfQoX57FOW1UjTdj?=
 =?us-ascii?Q?pBeo9IgNgnFXdO0X+HPk8W/hx8xLID1+T+AGYiSZmpoTKV5OMjYt6m7InQjI?=
 =?us-ascii?Q?ojt61blamRWpaZKaIaNInTCjKVaFCNOv3NUdlORnwsCmlw2yHevX6zrQ7oeY?=
 =?us-ascii?Q?OWkiDCj9cTsq/zCOF8DD8uDVJeYEGfSszsENTuS2REcisCQdosSFSy3zFMJ+?=
 =?us-ascii?Q?4uNmyvBvKWGwYTCjB305kvB81VcHxi1NKd8lSOJY+m9TZkfFeVRyhcTCOlU1?=
 =?us-ascii?Q?l/s8zkAZmM7JiMHU/ODGn36XX84QPTcdxRIuJJWd2V28fR1pQaZssAV2BXfw?=
 =?us-ascii?Q?jqbhVIUTol1OM8YuKRPd3urkyEgOn/QSobadpUzX40xr3Rj1ytdzqNriR/Oi?=
 =?us-ascii?Q?FjRrsoGW49csQOv6ohHvfyRuJT/H6DecnIYQkbU53fLDh/6zuAkRQZiYT12G?=
 =?us-ascii?Q?Pg1zSey1r2Rk1lTRoOloYDb67nxxD1BOt/q2sdLwNRFGI0/HrUWTC3ZmFslY?=
 =?us-ascii?Q?D1ALy36Px1noucuCvvPB1tLZzb/cublPx8Yo4xBexj401AGEpleMIBNc7dEB?=
 =?us-ascii?Q?HFMKPSK+TQxhPFqvViEX1oKJf3ZVG2Lk7r4+VcRUNn/jBB/Iho8XGb8yy9Hl?=
 =?us-ascii?Q?lFutWfBteovwimj5uBGLHqbCvmVuugCqiOOAryq4bqJl/uH5STSmGUg3Mh+G?=
 =?us-ascii?Q?cU525BW/lB00xKLt3kYbF6SZC5MmVEjaaHy/X/L1j9mnMc1RNagD8b11+Nn2?=
 =?us-ascii?Q?9ykCEaLla0VvRAr9Qh3Ea2tC6ySqSRDjuWNa1b8PDoZQDrpu35dh84HT/r+F?=
 =?us-ascii?Q?YMxpUfC3QFl7CtY8iP14lbzCg2iC2NyW8RNFmMdYbPGAziGr30PamkDErPav?=
 =?us-ascii?Q?WbGGum1+SD2RzoUpHW+9rMsEJdliRXd1QMSkjaGu+csxBCSJgQG8ayHkEUMx?=
 =?us-ascii?Q?l1exSNg+iPTx84N6JkPJPJX5IqfzHCV5obr2EOqxexCT0x2bW7ptMakcsElf?=
 =?us-ascii?Q?JG1YfE0BOyTPSq0bZSJFidX0CjPNVfYFeIgzUg98dNbeQHJe/XDILf0T/keo?=
 =?us-ascii?Q?A07PLtlruQbcfE6vaQ7wSHxizJF5nRT0iXNQ9v+yKIuZBjB8ZGx4kOQK/JXZ?=
 =?us-ascii?Q?2B35Bpy4s1LSs6AUy82sj75VvlbUfYQc+eNNpFD8Sh8S9Jjnp7h/bquE8WBd?=
 =?us-ascii?Q?teuFXOcjiejk6zOBHWXElnBAWdFWZjtDEZ4V2bNn0qSMjJCwrs/f7D2zNyK3?=
 =?us-ascii?Q?3l+iP9XsF0m0vWT7OWfWEFq3WX6WwHv3/zQst7F4NaVTsFoNhydrbz+iXMPE?=
 =?us-ascii?Q?VK0rR0ik9zZVtFBCsLEpizQKOI7Zh9gwdYx7gIyXzC3XjoAvaNdLM2fSp8uu?=
 =?us-ascii?Q?AqO0P2IpGJZgg3mXBDwt2wec4I2eOqxAMCWlU+26HzcSFoksu7nRXHh5y1bJ?=
 =?us-ascii?Q?2MnA+HFz/cC21rQpnFqDHkCsQojIatKgrxCj94Gxo94muQildX0XILfgWpzV?=
 =?us-ascii?Q?rc2+IDLCYJYKdqpYU+0AudgCEhB5N/xesKHqmjPx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d50adbc4-01ac-4dad-3db4-08dca4a3fa87
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 07:58:56.9197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LrdsQ+mEoi0TVPqLafYlcokZu4urDRtI1771IGkAFkBpMNkX0cAuy7Alqf0Oq9HXDfprM5gzjo1LbR4LOgmqRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, June 28, 2024 4:56 PM
>=20
> @@ -806,5 +806,7 @@ void intel_iommu_debugfs_create_dev_pasid(struct
> dev_pasid_info *dev_pasid)
>  /* Remove the device pasid debugfs directory. */
>  void intel_iommu_debugfs_remove_dev_pasid(struct dev_pasid_info
> *dev_pasid)
>  {
> +	if (!dev_pasid->debugfs_dentry)
> +		return;
>  	debugfs_remove_recursive(dev_pasid->debugfs_dentry);

debugfs_remove_recursive() already includes a check on null entry.

> -static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t
> pasid,
> -					 struct iommu_domain *domain)
> +static void domain_undo_dev_pasid(struct iommu_domain *domain,
> +				  struct device *dev, ioasid_t pasid)

'domain_remove_dev_pasid'

> +static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t
> pasid,
> +					 struct iommu_domain *domain)
> +{
> +	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
> +	struct intel_iommu *iommu =3D info->iommu;
> +
>  	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
> +	if (domain->type =3D=3D IOMMU_DOMAIN_IDENTITY)
> +		return;
> +	domain_undo_dev_pasid(domain, dev, pasid);

this reverts the order by tearing down the pasid entry in the beginning.
but I cannot think of a problem here.

>=20
> -	dev_pasid->dev =3D dev;
> -	dev_pasid->pasid =3D pasid;
> -	spin_lock_irqsave(&dmar_domain->lock, flags);
> -	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
> -	spin_unlock_irqrestore(&dmar_domain->lock, flags);
> +	/* Undo the association between the old domain and pasid of a
> device */
> +	if (old)
> +		domain_undo_dev_pasid(old, dev, pasid);

the comment is useless


