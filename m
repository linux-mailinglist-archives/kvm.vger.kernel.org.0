Return-Path: <kvm+bounces-11584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E206E8786D1
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:57:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E754281662
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFB6535C6;
	Mon, 11 Mar 2024 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHZErjIC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC24D9E6;
	Mon, 11 Mar 2024 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710179843; cv=fail; b=fmJrfqiWDVofN8yRnVHKiNtfFZG2xYddfa37Sgcq8TEljQawCAlE9+fQUuGpSJThMTKTckT7aNcA0IdsipzvDtHakhTCnSpKz+szuN5CrtW/ro++HvmuJNPUu8oVARlv7oa8ITm5duscIzw/KdKoWN7tKCNFU9/0M+9Ev4UcIYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710179843; c=relaxed/simple;
	bh=5c0xVlerk1QhXiO3mKiowjaVhtwK+YfJyEkOBQ/ErKs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fh3iOBMaV9gLduzbdeYLCAFvdZgPpNT3Jl+uxw/2W/ttpyPzvwHPJkFLPs5iwRl6DCW+ZQv4P0n8tYAAc18XkR4tOR8ms9Gd34Y6YFBbYqbWZGyriMDUXfr1Fmpqgq9KaJDmgDwTGD6iLmiQmVcLcVVB27KHXSwZwj8XCTg1h4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHZErjIC; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710179842; x=1741715842;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5c0xVlerk1QhXiO3mKiowjaVhtwK+YfJyEkOBQ/ErKs=;
  b=CHZErjICOKcHFT8ULglqrgCRecb7H9qrjdpj/5G2L3zntIrKAyBBAqpK
   7Inc7rMWcOY1N+67qUuOUGnpMwJ99djkiAB16BcYiyU8w83HMeEFEiS0e
   04Nwfk+dkyneGsThEzKuHPzvZOYKPwA8bO1krwbbNUjOWBloC0M1RPAmh
   tCwVQs9iaxRRFyzkLq6YiOF0O1JGkp13YDr5P8hWXc4L7Keetc9DT7F3V
   O3kx9qOsEoPWtB2HEH/SF8JTBm66i9/1wPgROq2unzNfgFvZP3AGJuDla
   QsVFmqDBIy83adnrdAKcyQ4SlI1ZegfspJ3xsHm6JAEiWuEmze+kHq2hE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="22314342"
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="22314342"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 10:57:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="42226899"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 10:57:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 10:57:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 10:57:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 10:57:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 10:57:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/M8hXfSTfRIIx4B4zZRrToLONa1zZJj/7IgwG8jXC6x9/dPkWdpqoeooMfCoRcaCGZN9ASkhfta8g7WG71XNIRMoldogqnxgLLiPwLgGGcLpsofN1s1bDhOfMAeSrMApaPX/rlh0Lr3QYGEgYO2pgep5Kyb9HAevZjrhLZYetYPWtXyAlZ6vqN5H7d30MXzQW+qbM/aoMgiiapA+Zvd75mHUAwzLxYn6QEsBwH5+6cx/GxkibwODTln8Z8IYfPUV8pQpw0sxgNRO/WK4nqpPPw8NKLXZlnw9czmCdLzDK1Yg0h/geFKpUQYXf3CUsIsGj6ymVi/c1ZVkOwNI4U9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBg7TgttndQb84/dMt5J0hXqrUPuUhtqZK2f1FZUoMs=;
 b=JFx+c/ETINkVYUeSlcvqWRxGwiLZdy7dk5CjNL7dDsrVD6mMJ9uoVJ+fb74gtsF/M+suNvnBVpXyDzX+4pyEC6AAY9Lw3larNzljEjqcvJiOsQmx0pd4O5gBSqciunxSPXsW6mn+rpfaNsP0qm3+rI1c5nKIsWHTKb48Llq/Gza0yb2XWUkRPeXoKpDdzp4ABxri3/GUutnqdv7iwnv8noiY5Mq73WcVXN6+PhHZBoOeNxLK9arQc4Q1+hitticGgBAezgxoh0/e7/r9FzQ+B9ItNXdYgb2XtBav5olSUO9vt14WkIKzMStuVh0XgH7VYiwHo722OqCi7/mKT13CgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH3PR11MB8494.namprd11.prod.outlook.com (2603:10b6:610:1ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Mon, 11 Mar
 2024 17:57:15 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::90e5:7578:2fbf:b7c4]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::90e5:7578:2fbf:b7c4%4]) with mapi id 15.20.7362.019; Mon, 11 Mar 2024
 17:57:15 +0000
Date: Mon, 11 Mar 2024 17:57:08 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Xin Zeng <xin.zeng@intel.com>, <herbert@gondor.apana.org.au>,
	<alex.williamson@redhat.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH v5 08/10] crypto: qat - add interface for live migration
Message-ID: <Ze9F9NSFSnasaN3Y@gcabiddu-mobl.ger.corp.intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
 <20240306135855.4123535-9-xin.zeng@intel.com>
 <20240308165232.GU9179@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240308165232.GU9179@nvidia.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH3PR11MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: c0d58a6b-b00c-4d8a-a9e2-08dc41f4af75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJ29vgjh+vFEQbgCogUzcYUtPZbfzIzzNDfOQRspRSt1wh/Mn0N0OvXeSKJ/+5zGah7kjk4sOeSJx9qXF3e1hP+OCP5DgPIR5Jk5sD+Cq6PEx2QphwGDJv6RVzQiR2w6gQevj8vNP5LwrONmL4d3iq+G+iNkThCqRNiLwMARLm4HdUNp/JmMPEeCyfuc0fOOX18Rt2oNSnc+nmMG8cj0QDS1nIRe9JpT9MkJWufiASB8c3qxvaTXQF4dmKmPGVkU0S8O8nybDVaHp0Tp6hgQH4WISWe/30Jvz9pR8PWY4T6ZGLBiim7AWF4yaY6f/eQq24Gp0Uqgkd/tJsxLswhqYVd3aWZNGHBZAF7Ru8UrzXCUrs1rH5pCc1zP8a0yioWcYBy/b1bUR6UXNXZCzvcFK7+yXj2y25NMbuCoDqelXT5HUB1nyWB4kwHvO7uluyZM2liCCZxmbew0t1hiszk4t1tGLMSzalsTM7DH4Uz0SOxZio6PchIoKOLn24RgLzwektIn3zJOt52sklzexehhicEjYfOESnk8NM47A9ov64XbyK0ejV3O+gd8B2RC81pL4ov6oqoXRN+xuuN2ucH9Rl7LChYNOCgFaKpDVAgZeMXV2gEF+RnKTZsZlftlpjfmcCN3sPc06KNYr+6ZPEKZISchVN7JLQn0GdaMYITCc8o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tqi61FwTYHRL8fPgUVgxos0ADIpciOjXWwCuiHUMFnmvdP2wNG+hExbe4xfS?=
 =?us-ascii?Q?W1budiP/JFbYD+QjAHduC9ViXTwNHGM3MniijFx+cDDevPh+Nhy42HDEqck/?=
 =?us-ascii?Q?7XHc2JBtzWRtaCFFMupqK6fwe7vciO896MGKcB6NO2LFWXRiL/pC6JGf1zH1?=
 =?us-ascii?Q?H4hYseU+bXhlDpbxYaNlROKxFL0zKS1Nb7mT6oHttnU/ubFpu2OsWab6Wxhd?=
 =?us-ascii?Q?2UdkFdFxMCBZNUq8at8xf3y928M5zQMtbQz/5/YxhxAb/BnWLes2DDZn8TPT?=
 =?us-ascii?Q?+JXtKDDXppXd1oGyFMYLZd+IHjZ6k/XEZ3OVZoRKEtRrfan9LsvKexfMFdur?=
 =?us-ascii?Q?LY0C9pW2Qvru7pfpTnrQTjRUx0YNLCQMGaDQ0i6rBIFt1Tl6bG/6qL1UH+HN?=
 =?us-ascii?Q?DQPvonF3hOM1x0QtLoPSrR48o4wkTbEV+eb+BY8BQs6XXrjh48yQLN9cIlLX?=
 =?us-ascii?Q?7zCUBXpRYb6q7mJx/cWTqBF/aWRTZtgsvdPH/mZGUJbZRkiNL7cLUbEpqCdT?=
 =?us-ascii?Q?DTwHLz0OauZCts2Ckrx1uL3DhHQCyDEJOazItXn1hXfqlK/fbyVowtqVQ33U?=
 =?us-ascii?Q?8ej9XIw7XO+J7GrB4h2Z7ns6EcY6BsVZWorIJWHOc2zVHllvTxe3/J8Dum4t?=
 =?us-ascii?Q?hJyRq3T9lGRasSIMK/e79z62pjesKYgcIdeftMYVQL7s6k4TEfK/XxUKZu+m?=
 =?us-ascii?Q?LtOSZWLzzeXS5yQEobc0i4RU9QIhof5zvlStYHeM4K42BPfT7GIvn2/Lh0hb?=
 =?us-ascii?Q?4fcJfVeWG2Tzlnil9SEcxEqFBWIaSkMyrfHEwqE9mROXD4sZyfhWcZ8rwoUJ?=
 =?us-ascii?Q?X0Aq6ahkdFgoqCeOWl+/o3dJPbBwnzNIJ1Xu3Eq2gG9TSiPYMIZbBgM6rcam?=
 =?us-ascii?Q?RoGVXaaYhJa0NSJkIAYW9Y2cWxzFuBk7gxvEbISq1wWbRKb/cEMx2e/yp4WG?=
 =?us-ascii?Q?IIWtZjz1U0hdGMqAGT72ts+5AtkW6AiVjtOIyyu5HSDK8iZjm8CxPa8HO8DE?=
 =?us-ascii?Q?GkwF/roNRa35p3DMoPIT4gz2seYR2kjbd9Wh3BeRtii/rBE3domtKc49yIUF?=
 =?us-ascii?Q?hD4vXVMp7x2Uj0oLk/wFIBtD1O6hqNs35aFpGA6gOXL4cbwih31CEm81ce2w?=
 =?us-ascii?Q?qsedq4Zmv/WgaMwxaXso+caueOAVGy81GSdbRTz09iK5/Z0lr8e7bs50J0Fa?=
 =?us-ascii?Q?c95Bb1jcjVIdGt/4morVsdQamBxMmxqHsPpIoB59OdB7R7m0f76f7wTiaN5+?=
 =?us-ascii?Q?P2wbFVyEKpnCcEKNl6Ly6MrJXWlIQtxgHgpoJkl7TBsr1G5tu5AaGjAc3oN4?=
 =?us-ascii?Q?03SwItdfU3OVj2PdXo+qwU3XQdrFG+sQcsS73LZofy5hxEjqJT764K1gXGmH?=
 =?us-ascii?Q?9DRO9hPUdWuwqSYIpaG4L89Scc/4abaIEUt9sUtZmCu9xV66P3lpK+cb4ktO?=
 =?us-ascii?Q?fs3LFdqstX9kMmS6fBWVWxZv+4zNMDUs/T/3xtQin6mQwF6WNRsASK574wJC?=
 =?us-ascii?Q?AJwaA7UuQ0Yl+QNT5GXG8ryy8aT+DdTtof08GY5PSbpQWzOVLUhleSvgp+vj?=
 =?us-ascii?Q?4dl7CFfscT2JQcaKSWEnMAaUV+7TMWITFbIksJFBL5WQiPLt8phs6O9z+SCi?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d58a6b-b00c-4d8a-a9e2-08dc41f4af75
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 17:57:15.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPDe2wgs5Mj5bgn0Srqsy83kZf2id8xg6f1DDg2SKWrVl+F855zEGJqCXaIHjE0VKjnz+7UCdAB+OMuXS3CN5MWKoo01bnbwZqYBBVpwu+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8494
X-OriginatorOrg: intel.com

Hi Jason,

On Fri, Mar 08, 2024 at 12:52:32PM -0400, Jason Gunthorpe wrote:
> On Wed, Mar 06, 2024 at 09:58:53PM +0800, Xin Zeng wrote:
> > @@ -258,6 +259,20 @@ struct adf_dc_ops {
> >  	void (*build_deflate_ctx)(void *ctx);
> >  };
> >  
> > +struct qat_migdev_ops {
> > +	int (*init)(struct qat_mig_dev *mdev);
> > +	void (*cleanup)(struct qat_mig_dev *mdev);
> > +	void (*reset)(struct qat_mig_dev *mdev);
> > +	int (*open)(struct qat_mig_dev *mdev);
> > +	void (*close)(struct qat_mig_dev *mdev);
> > +	int (*suspend)(struct qat_mig_dev *mdev);
> > +	int (*resume)(struct qat_mig_dev *mdev);
> > +	int (*save_state)(struct qat_mig_dev *mdev);
> > +	int (*save_setup)(struct qat_mig_dev *mdev);
> > +	int (*load_state)(struct qat_mig_dev *mdev);
> > +	int (*load_setup)(struct qat_mig_dev *mdev, int size);
> > +};
> 
> Why do we still have these ops? There is only one implementation
This is related to the architecture of the QAT driver. The core QAT
module (intel_qat.ko), which exposes the functions required for live
migration, supports multiple devices. Each QAT specific driver registers
the functions that it supports.

Even if live migration is currently supported only by QAT GEN4 devices,
my preference is to keep the qat_vfio_pci module to invoke GEN agnostic
functions. Also, I would prefer to avoid having such functions calling
directly the GEN4 specific implementation.

Regards,

-- 
Giovanni

