Return-Path: <kvm+bounces-15740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 720898AFD47
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB701C2215E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CBA1FC4;
	Wed, 24 Apr 2024 00:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OdUn0EbB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C287EF
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 00:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713918266; cv=fail; b=HaYK12dIhRRaouiIslqpy0n3lixRQZzc53lSnvSGZjbPJPSsOZTb2VZ8OxnB8HGW36jMzPmAmLvFFolIh3TWup/at3+Q89gGsIMRUC/Gs58Y48Np/M9WaGxXArqTQIDXZHFyaTIcyzqd5oYjhhEaAKVLAqqCFAYxHfhQfnntnxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713918266; c=relaxed/simple;
	bh=RWfoRciqiYeWlY97If4z+iyjdPdGmoUBACyOXMAaWRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G3QGcepO1G1DDPxiN4In6vkgL6uoEdsYMVZVD+oTloXHBY0Be5kVSRYKdqOh61efG06e44LeH2ZAq56z87sroxq8wwmXswnyI5TpxcNo9vJBim7Nfi67Y/HuC9EcXNb1hDYhoJAgSJVln6rNhpfXca6g0q19fuT3HAVzBkzFDLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OdUn0EbB; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713918264; x=1745454264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RWfoRciqiYeWlY97If4z+iyjdPdGmoUBACyOXMAaWRM=;
  b=OdUn0EbBmDqL5nFuy28Hp6Qr5MhzMMkiakmZkxdRTIqM8oFAt//1TxB4
   mXZyfR7qBYJGu7i2MMlh+6sRsSxD+517n6vpsjCdsgrNYmrUe1ppMfDjm
   NWIv+uSgBSGggPmaMIWmqg3RTtAe6nl4td0pxFVnI4iyMWp2Pa+/c6/uQ
   KAhapjsRv6gKZ0ob3NSURHmjaMGiisNHgr2asZGXOK53+gOrxq1YbaDyl
   1LNdPbaVDcJSM/Tt+6MQhQvXz7PUqk+ayXYIcw97fjcMCpm/T5e+jgBt7
   GCa7tBMYDX7spn9nc18I8eol5w+3OL2zMJkB4BEzf0TKa/8euNyYlXtOg
   g==;
X-CSE-ConnectionGUID: 94nSrTQAS4SR0H3BBMju2w==
X-CSE-MsgGUID: SPYuFLCMRvSMGLiVXmKwkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9397461"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9397461"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 17:24:23 -0700
X-CSE-ConnectionGUID: AnjkjotXTyujzkGEmrSyhA==
X-CSE-MsgGUID: rkpCAr1dQwWxAVwRL9BI6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24977461"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 17:24:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 17:24:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 17:24:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 17:24:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bno3keXMYMcnBp6DkJsyxLLDXySxCjL3z+euQdw/WoFhfYAIX8xn/x+41vN+sMo2cH8XMc2gkeGRErQFp3BJa5ynOqhXBjQXE/sDHqB/Gm2/U/k7ZePdSeDtMim/AVT2U7lLR0tF+sNHgxFlxKOvWInv8RRChouex3IOgrWNF7AN3xhnWcsllU/qtHkpBNfZIhbcdc0OjdOKLSN8F2MIsv6PrSA4nk5+s9TPB7JT+pozehmO3h5eAL0D0pZQG3zk1rEDQlirAcKvaOlKAfiWbhJK9S8k822Vc/zcmP5gWGo39FTMbDIm5jr+eLzpwQJKc9jry5e0h11kkoTsf7ViQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWfoRciqiYeWlY97If4z+iyjdPdGmoUBACyOXMAaWRM=;
 b=bP02FEkPFe5Wt14ZzuXh3GbJXBB/TPESz+mMeawywbO0XzNVRftmAmdYbtCUsDjZKJrGPvpZvbrhUat+ShcRes74fCUus351a/zFtjMY+lP8sbkN47kKFoU6bpLVUTDlghojQvXrbKbgINqn3Iiu8PvW8cORBq5R1zw9ns03iCIfXh7FAQPNdvuitnqI0n1fWzPCzIZzqx5bLUneqKBqytBRPXtt4YHF0HIU3tNeB+CwFOaUa3ZldDOo9bjtJsc172etP57g07+wYGxaGcu3hiilP8KbZ2oujGfwXXy5Rx7/W1EVWtwl020ru7+Bh8a/Ra2hTEuAmAIJRPWFDRXNVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6566.namprd11.prod.outlook.com (2603:10b6:806:251::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.19; Wed, 24 Apr
 2024 00:24:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 00:24:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Topic: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Index: AQHajLJzYiLjOoAxokK40c4Rfn6iJLF13UiAgAC7HDA=
Date: Wed, 24 Apr 2024 00:24:19 +0000
Message-ID: <BN9PR11MB527649B15B3671D02BBF9F6D8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-5-yi.l.liu@intel.com>
 <20240423123953.GA772409@nvidia.com>
In-Reply-To: <20240423123953.GA772409@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6566:EE_
x-ms-office365-filtering-correlation-id: e84c9c8e-cc65-4145-9606-08dc63f4e257
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?jAfZ3Oc9Un5ZkgW8qjRM2cAXHXB36YqNTIF5VzS15ZCTVil9BveT60Dumnzh?=
 =?us-ascii?Q?aw1bURL4IftLmuJDFbfdK9acafdsjC+2p5obf7UvLm7GWjA913JFCC4q/aIs?=
 =?us-ascii?Q?QRDWQNJTl3kTOMv91T28FxgULR0tZtHgEv9S6fCcBgrbc8rQA0X5mP2n+icY?=
 =?us-ascii?Q?5xskXX3qzrfv7spe5dbqxy1VzNTZhAFCx2SagCyQGYqyy2Jkg+3+YV94YtI7?=
 =?us-ascii?Q?mhl5+My2ERZaeqhPD7GI+lmcR1JFcObx7bCgFfas5AinzY8ZLAFS7J8/pqvc?=
 =?us-ascii?Q?4sIJfXjZa1IXrBTym6R/Cz27bK0N28ZXBa4cLqLkVBBSLvfVc9Epn5W+w3nM?=
 =?us-ascii?Q?aP+tw4n+KNqC4n1aeVPlxRn924k8DnVb4QYGlEz986d6bAHyIMW4DAXmuWx0?=
 =?us-ascii?Q?iKAXunrtS6EGuBB0Ef3ctrv2VSC0EqNgVF6Ya2b46U7GoJwIdsrBoeztETRX?=
 =?us-ascii?Q?C0IF5njXyfSo21+inQ9FS3Jh7jkwRNyKdVTxDttqDBOQkI9hBBH8+Rfd1p/D?=
 =?us-ascii?Q?MRu9uEnMFejL54ve6+cho3cLWe9G9pWSS7cKiAS5oBRXg4ZEBw+AAnwlYolT?=
 =?us-ascii?Q?F/5OUdsjZko+PKYbVI6CEbLm6Lzg3fs5tM0uPUpZMImuCe0RM874Va0XFVcn?=
 =?us-ascii?Q?r8DnHlEgFie6sZ9jnEYDleQpndXfAehcQ/AbKo+X0i9kdHgh+nV06ddZoAXR?=
 =?us-ascii?Q?Vl/4tqZlMAq3/gxFrudDE1vaYNo0ZPPcKD4gznj3uSCzElDOj3xPrpGZ/8Fo?=
 =?us-ascii?Q?L75mdY+XXZe8cO+QPc69cKdecEwnCQXNKFInUUAEolxGS/P/ZcZpM9RdH/pU?=
 =?us-ascii?Q?/sriZc+DgSXB5oWv8jVkqTdEWuYTgMm+9Sol4tsPGovZbZZG6qxd12nWZWRq?=
 =?us-ascii?Q?3kQY49tHnVGlZ1OWYDyWeVmxPfLP3vQkxz6OamLe09uR/wMkkRyHi9qNofoS?=
 =?us-ascii?Q?529BWyZXqvC27UbHIg6ezPSjxMs3yHvvsliyG/Bd4YDE45/fgQB+VjFQjMSs?=
 =?us-ascii?Q?/0helEiXPeaTHIg6Bgw706v0I4Kkm1P/gehWhjTt4uOMABg+Udfk4VuOL+S8?=
 =?us-ascii?Q?oYbc46V1QA3JSCOqzmq9HioFtIzPnZ/fJsGkpfUev6cgo57Ghw+haYPhnUwJ?=
 =?us-ascii?Q?Jp4F8Bjf7KeSrZd+raQ85qZoJ5q2rn02P38Un5wAF5RDGwviRhDPqQsMwUP2?=
 =?us-ascii?Q?QPubOQ2agiZkbaS/ky62LRXQ65hvxZ8GPsH9ieUQB0BwQmajPC5WyMsTbwD0?=
 =?us-ascii?Q?YFc/Ssnp7hnBAWzuUUp8To6AU9bY04K9bTkEGIrtwQ7+tU7/GYhxts/HwEP8?=
 =?us-ascii?Q?E6F1NMxs/umT+c+zPtu0y3ydf0sLmZBKyvsZ4OLkNy+4wA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h4wKxq4eODiLDPuFDllLS/m29/nMALyq2qDIFdb9O506kMNAlChWLr8UGNA8?=
 =?us-ascii?Q?3/uKlobxSv7VjAUSkr6eE3ljVv8mmH/rj2pWvsb7g+5lgCbbkfeo+rtG3CDB?=
 =?us-ascii?Q?M2afxus+CM/5g70JgBZUn+gtPorsGREqJ3v4DQQQNICqOyUzRT/lnZbCyCq2?=
 =?us-ascii?Q?XUR54JhxAwLXjYQH+d2L4DkqknJ1r0I1dONKC7Kez6ce24JEIOT+mav947Mt?=
 =?us-ascii?Q?KhKe+RHJSnx/JrjV2IhUnJaUWLZ1aiddvsvQYwF+kj8mTNaZCWoxiTkAb8+O?=
 =?us-ascii?Q?CdpSxCj5UkemCJWCXXh3T7WWUx/4jHsWr5Ezjg1SQgvUfY2ytjp0ywc4/1ZR?=
 =?us-ascii?Q?vrfillPI63gndgAuy31D3sOBDuCSAJqMlIZeW4zntcnoacKi4HkMeLjmCtV1?=
 =?us-ascii?Q?xJyNbOzCNIXmv8Oi04w1Kon0yDtmbd7YAWqSwJIdr8MWyguZpxT+tQ6K0j1L?=
 =?us-ascii?Q?jIcOQJU/+5dmn/Yy5i+5yxd2himvLyp0M7dxW+xIrWiUU6HF8j55agm41j8v?=
 =?us-ascii?Q?YPYBHToiUiPnWLqHKYfXOlE2Uifdo2w3qmwGZTmWyK5dX+6VywWEneF1+JM1?=
 =?us-ascii?Q?oQKf2tvN3Xp3GQFvn2d8vcu0ZcTk6EVSbcWEA/5Q9kgYYOShreMjP50mL2An?=
 =?us-ascii?Q?8tJThic1Pswd/qHsXxURXvA1/POj5eGAxZ8OzkICFU8f+isp0vde0r7t2B4R?=
 =?us-ascii?Q?ThRJmNf6TLTz2yB0LyeJsCyQvwvsDDpKmi7JZVhFAjQ6f98Aqer6/v+dMJYR?=
 =?us-ascii?Q?YsH9J52XxPIyXXDBPeKXVtkcVO2WViiujptM2Q0EREZdmAwtpsUcpsmojG78?=
 =?us-ascii?Q?GHAIoeoSutgZ2BAQe9WuCN30AfN4NS43PhX4U1kjVK7A/TOb/E3xdzJmcJU3?=
 =?us-ascii?Q?Ce7M5UCb21t3vTynQUMpECWXY6kbPQuHKRFqFyRMCADATHcN32huNd9SeWR4?=
 =?us-ascii?Q?GXbBhsir23E/js3laOfUiddLACPg0qM5idLerqEOoDar9eF7+6LY7rqBRu7h?=
 =?us-ascii?Q?VU+jYLg38XxLce0kNWTctQC9CDsd9AVgOhNgT3b4o/GgJP38CuFwgoKjVBhJ?=
 =?us-ascii?Q?RLsQU1UdHLy4OB09ap5l2+zTGYZOQpMI6uRckqQ0ZY+1wCPY1slqlXI5au99?=
 =?us-ascii?Q?Y1n5OnSZ+qGgvNQu7H6/Yo7HvxxEth1+nH089hNBndwiaJfDRbeiyQK6FXe3?=
 =?us-ascii?Q?iU0mlmA+YbaDocDQqn3DRKabeVqAPfQNk1lr4e3WY/SsFabBaJwWt7bltV02?=
 =?us-ascii?Q?z3OPquMdaL5RYyxqvYHR7crmthbLk+TD7WEWC0/46wkhGeu3uty+uQ39j8E8?=
 =?us-ascii?Q?FwRVY8bMVzgWODLTPGlc/ty6+FTVcz8pEZeQlx0+mDQMGWnT5vVhTDzi0rPX?=
 =?us-ascii?Q?iTyR+mIlyQQQYw/zmMcZQaDn/AlxXU3TBq3tiUMcJRpfUujDWxRfvNOn9u9T?=
 =?us-ascii?Q?srkyShqAl/77dJTtt111ysxRXbx0zkSlRhzTqAi5jP3vGeCovBl351d0n70y?=
 =?us-ascii?Q?oMV6/8B7rntWnhTXXGNr6NxawAoj4/ay78vCUWt8LBPB4HMQ8rgAB78oruRn?=
 =?us-ascii?Q?qFvjBLv6JliAgL1NndoiSLp6rayJAbtUZAvD6Yf4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e84c9c8e-cc65-4145-9606-08dc63f4e257
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 00:24:19.9870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qeMhI6cu7xVyMDxy2gto6ntT6de0dy8rwOfTnFg+EfKXePz5B+fmoC6LjHYH0YH4PrN5LXoodS/X7E/axcBC1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6566
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 23, 2024 8:40 PM
>=20
> On Fri, Apr 12, 2024 at 01:21:21AM -0700, Yi Liu wrote:
> > Today, vfio-pci hides the PASID capability of devices from userspace. U=
nlike
> > other PCI capabilities, PASID capability is going to be reported to use=
r by
> > VFIO_DEVICE_FEATURE. Hence userspace could probe PASID capability by
> it.
> > This is a bit different from the other capabilities which are reported =
to
> > userspace when the user reads the device's PCI configuration space. The=
re
> > are two reasons for this.
>=20
> I'm thinking this probably does not belong in VFIO, iommufd should
> report what the device, driver and OS is able to do with this
> device. PASID support is at least 50% an iommu property too.

We have PASID capability in both device side and iommu side.

VFIO is for the former and iommufd is for the latter.

both should report the capability only if that cap exists and is
enabled by OS.

>=20
> This is a seperate issue to forming the config space.
>=20
> I didn't notice anything about SIOV in this, are we tackling it later?

yes.

>=20
> IIRC we need the vIOMMU to specify a vPASID during attach and somehow
> that gets mapped into a pPASID and synchronized with the KVM ENQCMD
> translation?
>=20

yes, that is the original plan. More accurately the vfio attach uAPI
is always about a pPASID. The mapping will be added separately to
iommufd and synced with KVM.

But internally we are evaluating whether there is enough value
to justify adding this complexity to the kernel. It's the main burden
in SIOVr1. Given the limited usages very likely we'll only do the
basic SIOV support w/o the vPASID cap...

