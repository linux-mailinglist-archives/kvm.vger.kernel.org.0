Return-Path: <kvm+bounces-11488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E988779B1
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 023711F2168C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CCC10FF;
	Mon, 11 Mar 2024 01:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MY96SlgW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA425231;
	Mon, 11 Mar 2024 01:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710122174; cv=fail; b=hi0TBCaayPpZoet3LKGLzR0CYJwLYE/7b8azLkyIfI6YO0uoAXrdO3F5asmExdO8Tt5tpDcTL6euj0OVOz371yr2mvB8qPC7zxqITarByMrqFqiMxpR6G0WXQ1/+m3TiVSnMqIWwm13aI1xkbvpUfCPEVuq/vb2tk72d9f+REBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710122174; c=relaxed/simple;
	bh=FHGr6MBs2vanqL7pLB403oFXllxvqJ+JfpxBExzsa8Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cg7n3tvjy8MFsTMhmNF9HTiXrJ5vVUx5d0gC7e5Q/X1a63mxoAdLrkJrzW/iH3+MtPJ9BcJY5XcQi5TU10J0vLtPcgjeHdEzvN8AQYyD/5LsQ5JCf9cnVScP8naubsCHmU16EXub8JflHUnl/gSzi/EUw+/KkFd5WlIH5uGdars=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MY96SlgW; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710122172; x=1741658172;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FHGr6MBs2vanqL7pLB403oFXllxvqJ+JfpxBExzsa8Y=;
  b=MY96SlgWvIMRSR74O17WmN8RBSMSAJy4f9JANLi0kNt9dQEsxfyQLyY3
   RcQRxPjkPxr7ygTI3OWLUl45zchDLvm1N+b41CVxg7BCwVnvvdPfKQkWr
   ztNVA9eKL1ZGzeRaegPUSM4TJVvH3MRYSJhLazCoV0AkW8gVTfTd5IZzP
   S5pXPZKFUkNh36SjIgBlQpSz9h8UUVZtwaghbZDYMHgFr4f7WOJQVZLf6
   yQx8P2dxHW5ugB1S3wazt/0DXb23rVOszI9TP9HBvDghuKE7YHrLiswPl
   Yk2u3T28+e60IgNX6OnduFNMKdnEp57d6D1Zz80FAgZYsegr+qvCo6Z0D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="22290368"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="22290368"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:56:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="11025250"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 18:56:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:56:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 18:56:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 18:56:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVSZyHnT1MPLGOMjlcNDvolmp7YeaGkvaxcITYBpRxoc1PSfciVxsxqVuHU0B5ZbR/INZRkfM9xP13wsD5TsW4qD4Xx4NOa2ngVSqaSsU+/wQfEHlo3OACWqmKLNmeM37rFkqPt+mYjeqHhb4IGq6cH1phNGlRLytoSdKpB49FihhtWhvwIWPBs079REImteMaHCWcUNwDCmk6gDweXoTChnpB5ANPTc5njxkky2WvlEDUTIEp58BSrLqHCfz7uZkbDlBLXLw95GQtOgl7yBnfB5sDThR4lwHTIDfDhKAiw++KZ1rxCb8OxwF+ve7LctEVGIPZG20HULn88SqzXKTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/4slqHzBhgIqIrjpS4E2mgnQoUbeEX2QBng35kog7w=;
 b=d8KCeAGyZiwUzXvHDvzkIGsSzsRkjX4gDwVcU2mCs4jIMxWQwoFoCCJN6lLQd/87cGdAuqf6UKbfqV+d3aAoSyLk00ZW62OrZUnZj9+ks4vxLOeQyVBaLQ/+QPyu4xMbcS9MKo6j8Gl5zyGqXG0SzIO2VnV+EDMvfyVFhym4U7kew6LCcyfvUCNDmEUnQLA7VxR7GBXBx+eNbBQMr2WhhL5KdF2Yi/WkAjVhgcJF6slqI38tWBRJawMJYvLMgDdADrm2NECKCE6Fcq5eiXwcYeBO9FRaPQsjznLyzQ9aHwnR/93B5pF6ykMZ3vnrJHC71PX8J1WSsHj9e8TqjCci/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4719.namprd11.prod.outlook.com (2603:10b6:806:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Mon, 11 Mar
 2024 01:56:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.016; Mon, 11 Mar 2024
 01:56:07 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "diana.craciun@oss.nxp.com"
	<diana.craciun@oss.nxp.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH v2 7/7] vfio/fsl-mc: Block calling interrupt handler
 without trigger
Thread-Topic: [PATCH v2 7/7] vfio/fsl-mc: Block calling interrupt handler
 without trigger
Thread-Index: AQHaca1RWvaU13rq+UiFS5yrw6Cg7bExyyBg
Date: Mon, 11 Mar 2024 01:56:07 +0000
Message-ID: <BN9PR11MB52768B392819FB724E70EC908C242@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-8-alex.williamson@redhat.com>
In-Reply-To: <20240308230557.805580-8-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4719:EE_
x-ms-office365-filtering-correlation-id: 78594ecc-ec03-41d8-e8d8-08dc416e6b27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QPgDWvs0cWSEgyxDBWk1V4GUg8hRfYV13TxldbYcSxC8cHlwUY7njqwU/Ic96nE3TZQrjy0OF+ZMtP2jk9jKYn1976RguF6bnBjUUGPJO1UM3r6ixEtPgD9SUe+3c3SNyAm3JNfSpyVRzo8/yT5mM4Yqc3eVZf283qbOSUArGo/cFQfidLpMhpXAGnuBxNKbZ9ksKEG4zBv5r1seex2WYCRW4rW/UAVN8ScPmgJLZADfqdkDJeuzmmXqGZ2hf8IZCXmnHU6Bs0xeIauv6hJ3kuNseCvu+ZC5WfB4rCEsZR8pnArr51VouhD8TEMprE8Smi+p3XY/pf9luyZ2IR3BBh3RHbN/mJ3VRDF97EGKejGeCH7TG1vkpy65Kcti9VK6rsMrk1YZwGbSRZ2QHHspC0i3F+6KJSego5N/gEhwfsrEVSsCfYztQxYoeGnuS9abvGyCjACA5VK88W5iauO7mzVB9hAz9gzUtiKSGdM0qtJM8lPNjC707qrx6UMeO8wwlm19RHZOEVMtGofSkSyArW7srmZjoSpXe3+E8NPEUOpTLwx+AUxjXyQnDKP5I4zlWVo96XVrokWmlmGbURWtK2cWK2JyShIEL51Ex/1YWJDWodxnnyh75FcSMU14rqlg+kOfd1+1MIgJ9JMJhdYo7bGRDXM6AMd15GvsrZdPxz+j1PyV8EHr75mMWEQSh9yVcdRettpKWBCEBwBbf5Vku7+t4qJYigp9A7CEVtCVRFA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8ciPD3QdzTQ0gNeafe2VHPWN4zCWPou+CrzbCTb720ob5LbMVJelz55k9yRA?=
 =?us-ascii?Q?rsdCcEuMMj9oNiWwqjSUQ1LTfrOfCXZD16nPz7u1nrHTT3k92d2491ouM9xW?=
 =?us-ascii?Q?o0BwkIdSPaiAvtnXHljsWkXhLEbaf3UWlIIN6fgv3ZLtHUutQjuJkHPt/P2m?=
 =?us-ascii?Q?OosgbgsBvp7p1C4A1uXMR01XgN5xlTNlllXh8YkoVEzohQo2C+zGNWYu1XXb?=
 =?us-ascii?Q?e2oP9F1ku+pURCEnP/w0IyDI1gyl3XcJMOkTWWuAlZMuZUTIV5divPizMQG0?=
 =?us-ascii?Q?+KtxUOR/rN8FnUn8fXANLtWG04jc22hxFtKrIqddIrR1B+ZGxTwuzflqZUVL?=
 =?us-ascii?Q?eTB7aPXisBsFI2yWI1fQ7Iut+DDfusxZGpoeDcvCau+ZFcrbny3HI/3P6UEJ?=
 =?us-ascii?Q?D0iN910o+64Nai77Ej88kyAznkBiQyjgFGNffA1PHitX3Q3fcOYuQ5/LBU36?=
 =?us-ascii?Q?V2mWXyjT6W1kUT3ibDzfqF0ZFhoa3RuYG5DS7qf/Ui2aeHFV6hr5GODTshFd?=
 =?us-ascii?Q?K/NS3uTjugjLDkfFBpZ0gHY80txywZ04MGLFckLVLrycVGEx/quoBvDPLvoe?=
 =?us-ascii?Q?jtZMaaeElZ8/wiOpwp2X0Wd3LfbL9P3/VX52UskcMpcbl1tQldEoJdr/JfKi?=
 =?us-ascii?Q?a14+S9JABS27dSqP9CcXx0Q1wOF3PAw06ly2bwMxeIaCPY41wpTou1wAPw42?=
 =?us-ascii?Q?W6D9/C4CPIK81hhxw6vgvviVhVsqc89LxFxtNJAIRLwzqD9pL8aAJ6fivKYc?=
 =?us-ascii?Q?Duogo2Y7oD8CesQHw9KFJHoTj5vc76mXy/N8bS3FZPmQGIO2cIZBCjEh5Ok0?=
 =?us-ascii?Q?OGP1n7ob6/U+bYNtVpqzScR+pmox/qXCJSxFGwwFJuoMwtYhF3aDjotqy2JY?=
 =?us-ascii?Q?7JYlMecpJ/V1B8Rkx6vF+M3Zl+iBna5Q/tUfRqffiQwbtxqeTSg6oNVUe1nd?=
 =?us-ascii?Q?ZdHxwhBhh79xeNZKBCTKRUBMCV5PiT49vgFDBo/6tWJfEKTgFupzMj4rIQ/7?=
 =?us-ascii?Q?nmJsLA4o1jdtWgG9XTna3hIFvgYFZJAnRckb5RtoMNOpXJ1QcIZYzS2Pdsfw?=
 =?us-ascii?Q?IOEq5AEDkdTUiIrGWHPQ4tLTflZIBg1/iqiMSifDTDL3/FUxa/IcpMkiYsFT?=
 =?us-ascii?Q?IdlCWWb57jH+5pqJcRy+cXG/LYdR3KqvSPfhZDEcVZsCu/jVCvKjIliuySSV?=
 =?us-ascii?Q?nwIJW8vCz/8arSItG56wRO8v8rRk5cQWgwozblBIEGmNdLjL7GKGimgE29QV?=
 =?us-ascii?Q?3DMR6cvjkzVgFRwXABjS1hKaNSx2mOExdsDwUM1WL/8OFxBjIpj7lmZzUMqW?=
 =?us-ascii?Q?38LFSWGrj5zLRy59oqDQVz5Z+mZU03h0liuphQ36ERkADYba1mNQpqEFmB1p?=
 =?us-ascii?Q?gvsy03MHZgjFahXRkY4cBjBhvrVPldTSHECHmpBBXP5WpikY7iRjY9jBazVT?=
 =?us-ascii?Q?D+ZCJERUlVkkQZecSdZKkLjJsNISVBmaRddW9WPKdgLD/k4UdILYdA+UFrdv?=
 =?us-ascii?Q?G32TyKUIiDN4hWd1Nic/K1DzMUh3b9IUvn1deMJSFbA+6lF3csAZC/lWuVGa?=
 =?us-ascii?Q?BOq9KvzemPNWfL8+vV0yeuvEEB3Dqlj3pNBGSswS?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 78594ecc-ec03-41d8-e8d8-08dc416e6b27
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2024 01:56:07.9491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IaecbVPdeQ/theuYGyAFYYDra6+V1055xyNEoPLXPZUReVK0c3dakANkv3ZNLGZGcUmohONjExZMqR9O5eSN4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4719
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, March 9, 2024 7:05 AM
>=20
> The eventfd_ctx trigger pointer of the vfio_fsl_mc_irq object is
> initially NULL and may become NULL if the user sets the trigger
> eventfd to -1.  The interrupt handler itself is guaranteed that
> trigger is always valid between request_irq() and free_irq(), but
> the loopback testing mechanisms to invoke the handler function
> need to test the trigger.  The triggering and setting ioctl paths
> both make use of igate and are therefore mutually exclusive.
>=20
> The vfio-fsl-mc driver does not make use of irqfds, nor does it
> support any sort of masking operations, therefore unlike vfio-pci
> and vfio-platform, the flow can remain essentially unchanged.
>=20
> Cc: Diana Craciun <diana.craciun@oss.nxp.com>
> Cc: stable@vger.kernel.org
> Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

