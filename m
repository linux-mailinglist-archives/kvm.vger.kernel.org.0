Return-Path: <kvm+bounces-8626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E5B8533C9
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 15:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27C4C1F2CD67
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 14:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D9454FB9;
	Tue, 13 Feb 2024 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I5JXQW8H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1715DF2D;
	Tue, 13 Feb 2024 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707836159; cv=fail; b=d3ihWhzgzzVMGg+pzYqCihNp4wADdFumCfkxsXWiu9i0YXZmMW7sHqTk5pPgEXQ8S8F+Jq+Ldbnm0RKb2tXhn0bNyNGr+XOZoq8+DSPOymZSp5RQwODyimsSR3gg7TpTgJLowxZ3V6JVJ3BcmZvg0XC8mkFoR0LHA3H907Rj1xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707836159; c=relaxed/simple;
	bh=pUEqenml3rjRlPoFBKe8dm1+j2mja1gC4RF1MyfJjgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D170P8qo3zamYjBkIUtRkhup9sz8FVqDBuryAaMy5Pc+jHoF4U/iVvKrlSa3T5ryc2hT2JDhxTqK8jiH5JVVG85ulShoAVm6m4bFLlEcyiJJbKdJBCjFcePRblkdz9cgk/osOLjfPMG6PYk/SI6VMKojTJJmAbcCcWxuRZ1W1ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I5JXQW8H; arc=fail smtp.client-ip=40.107.93.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nf4gfCoFjMeLNbN3BH9B2imYxwNHx4MRNrpMTLWyeL/o24MMOIumD4Z/PqiYxagd4IUPfTmXPhjaHI/WQbhUX72p2kjuWnfNRo0B7U2fmS+BNr3EAuT4jxEelYneXr666FE1nU8GoQWUa1q7Hwj4RrumNVGRg5/MK3Zp91R8FIOgEAv/rzpD09qcfJqG18Fih78asYLzoPbEL704GvbYWHYkWxKwhL4Wquv0DrywNZsJl6d8VCR+YIbha6JFozaaN3ooSKoPRYxPCKqiUo9o0ERdBo/WFS4u8QWm270q2d6mUFbbt/61kn1fZ/+b7Q6rBwfKqRko9KEsmldRh106Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGpy4a8EEXSYPgxekgKBQrIOCIvllbf2QEFKrbkzElk=;
 b=ljS2hrX9m9Iy+QcX1e6cYm2xmm0Drx/s+SXN4TPFfiDDmfs4OXbgeISDmmMKXKXlMBj+7QYMjUqntEuL/mSuIvtWmSV23OtGvd8hg3Fgz9EEyuMkHb1sJSU/gYcKZkZH4ETTaHExJINlKYF7w5+kcL0GWrr9w8I62lv9MM2m3VGY2kUQOgJL2z2Tg0nZenMcQSh7IGWYlZ0nVL3rD0fVIYNzq4tUwTer84GzvxkfkQMBvgjHEGtw/xN/UydrgAYV+hl+zfWaS2FCCG2ma/QfElUfqUtwjP0rgV4hW+TepjDHaG7GeikL6tAsjX1s4CuvPU1DVoN3aK5smY7BCOGKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGpy4a8EEXSYPgxekgKBQrIOCIvllbf2QEFKrbkzElk=;
 b=I5JXQW8HoJIAEoBK+yWkNbPXo0GjuN4nHouLll1ge10nOs3rgdpnrT1Qq6aPlDBrF9doleq7d6Vtq+FoaEjTmyFbyR1Lre6PXqQTsU8E+B4Vy2143JBXWy+kkWSNDsD7ELG/45YbE9CdKPwrw5u5t5+LcsCBdeEQtTsg/1UoArGycM2BrzX5T8uK724FJn49WFpjVcnyDLzMI+ahliIL9fZg0aGEFVAZWhNDylGqyBXAhpKcKHCCMFEHumN4B71lvi28UC4WIGAc7hFbjK6T4PxBlL45mmiLyjRefyyqyqdxxS942n+imdcVVtvoF7L0Cm5FUbAT3+ZQxP5T6VMlcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.23; Tue, 13 Feb
 2024 14:55:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 14:55:53 +0000
Date: Tue, 13 Feb 2024 10:55:51 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Zeng, Xin" <xin.zeng@intel.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240213145551.GC989297@nvidia.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <972cc8a41a8549d19ed897ee7335f9e0@huawei.com>
 <DM4PR11MB55025C3ECE1896D9C5CA4E86884F2@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB55025C3ECE1896D9C5CA4E86884F2@DM4PR11MB5502.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA0PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:806:d3::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d35d6ba-5f16-4dd3-0118-08dc2ca3e00a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qKmH6ONihq0RwdPErY630QjsyjCjA7FAnd/FzNiIe/iPFstYrYjw8EVy9vy3fsdidSXYz6JSwKXXbLpL3hdvBLvq0TtcclRoOwmOmMUKK6IS8aKfWc8SpOFx6LESOH+MeSKJYc2iMDVDjkdg7kfFuBgIIeu4sP6N39lhla7zzCk6uQmRYC0eFP0ag2vfiiIq0jKYb+lBA9JLhKEt70ioeruoFZ3C6gMapc3Hgn7vWx1SLx1YqGJUAF29eMRnNCfnZjO9u6qdKeuXDyxd72I/rar59TvM1r7EUD6ynYRX+2zgGCNQJuTP6XoQPL+BsBkHqh41wEvI7/h+TQSsCQJuXqC89TyGJabRQdGWZvmdECJn3QcWzV4SCxHm5lpT1RnEDBUdYerr7/RMbCXsr39oXkNorM8jO/7l31kBTI/s3kKDMXd7Bpzpav/gEcDU1oWH+eErLuemvGvIv1EwPtkpAXruTsLJ45Dy/f92Bptfbb0MOTPw+BlcD+GnNH6BH5oSYeVlLRumLCf+IkU402RedWw6ZcfJ4Rze6YZupjFg4ujwRg/mYksJj2ORrAJs9/vd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(376002)(346002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(8676002)(5660300002)(4326008)(2906002)(26005)(83380400001)(2616005)(1076003)(38100700002)(33656002)(36756003)(86362001)(6506007)(6916009)(66556008)(54906003)(66476007)(316002)(66946007)(6512007)(478600001)(6486002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TFqgGXNjvkOJSI8eP95OKZu6l2EQQIaW58bolfJyauVcTmhglKXzXtWy9e2r?=
 =?us-ascii?Q?y7QMpLVwVqWnZe4jk3wLBYflXKW1NkelPg0WFSxr+CdkVVr8tEa/rYh3Q9ES?=
 =?us-ascii?Q?/9qn1fo4tQ+NeEnONbyrEj825KQOsXTdkAuLZtYIzhcSJHsMKrNpniLY17dW?=
 =?us-ascii?Q?iB08e53LLIAH05mIqb/vtwmRM91UfBvkcedfvt1jrgB0tUOSrxAyS4iw1COK?=
 =?us-ascii?Q?JcJbo6eV3K4Lh9eeTL+Flju8UigBygdVJTdWvpsCkSJuw/FBt0Wc6N44nz8u?=
 =?us-ascii?Q?4eP9vvTFZTYjxy6YNX0nag3AnA05lNjc6UsYtap02lzgvXtKOGij89UK+5Xn?=
 =?us-ascii?Q?6p9mKb/8N2kDfr/Sb9V7Smv43M0/zGjnheKjVK6ddxcflNB442pOXzxHjMsm?=
 =?us-ascii?Q?NDbRcTu+tX6heczQpRijHkCm2MJz4AkBhGepsoAsH4MzGnSc5OSVQZZ9taab?=
 =?us-ascii?Q?iTtzeMswq/pimJ3BXFd2b6Ea1DUrDum/hA3n3XZk6rz4oIE1EQCKmlU764Pz?=
 =?us-ascii?Q?YxFWEjiLCjpmApd5b4ccN28Wb5Ryrlr/e86P0eBS9NXNelMqMBPunxkzFMBc?=
 =?us-ascii?Q?957B6Sa9n+qVnYFYSkEPL3ZHZJ0CmUd5dux+ZfeXFslTtOrtg68FJU8oVRQj?=
 =?us-ascii?Q?xTJXLkwpeESG4PU2MfKbAWIycRtnKZXUNX7E7pHlacSt07tzCGdpqgufzgOB?=
 =?us-ascii?Q?53mpTEkxH7VFeMsU0Nk8ZeuJ2l9tBnXynT/Ltv/u5AptRfKLq3eB7+MHUxu0?=
 =?us-ascii?Q?Utf+kncFukKH+vMrTMgv40x5p+LbF2A8koPeHBR89aZw8XUQBV2NmvSuE+Xf?=
 =?us-ascii?Q?2z1aDoVHyndI2P8IUN2/EUvYUrb7oa6Y41f4bCDPuHoe54UBEypk6lq+LLUU?=
 =?us-ascii?Q?hhKiLf8B3z4V4oQKnxiZ/TGF9SdXdPlj2MjiBKn2tNnNrz7iNwkAGVQNSH/P?=
 =?us-ascii?Q?FCXdEqu1vYhE2BzQNZ4I8oG4Kkt2RyrLQXh2NoOkjSA4F09KFsOKJHPVJ5zc?=
 =?us-ascii?Q?50vUGBszN+G5bDHIh9ggoT+QGJiWDeB+YiTPIiR9keozxkZa8fSndHoG+jTb?=
 =?us-ascii?Q?RdZvwXBN+tLuBliqqilUiFAYnFqQQn7z7rz0KtKV+27JkhTzZyuexLZT+Txl?=
 =?us-ascii?Q?0NaaiPLMzdNGHGhYZ7bwOaxqhQNff5ev7UO9WnRhCQ4+xUvOt+w34gBDUiKk?=
 =?us-ascii?Q?4rQT7xwDvcdArJvRIIwhZcsC9t4f/LatoDqVityny70b1v2aV787ISBPnEKe?=
 =?us-ascii?Q?phQfI95sOUfh0aOoYTNk2mMNimM7xDec80kadi7YSMOneYHoiqe2pszsdrWK?=
 =?us-ascii?Q?Jzry7c61HiH1Iq7ePM03YUycmVLwEIYT3TSA71ppIWqRsKwnHlZM07aSn993?=
 =?us-ascii?Q?qBGzr7sphAgv1Z/x5+Co6ZrRn+fQstrtzvRs6yUxbyslyXr1bGjKx1QHhFrI?=
 =?us-ascii?Q?rEB6eq+sRjpa6fMA1llMSuUr8/J64VaLK82OokkEpx2hIoP/SzgrfZj9vq16?=
 =?us-ascii?Q?Qb3u1TIvaepVS1bqzH5RTSd4wQ9h0J2aitWOXijN96F1xaQb7CNEHveeYEdm?=
 =?us-ascii?Q?0eeEfiVLR+F7PRNZWb4gL3O/qWTYrKDewB5dPcRZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d35d6ba-5f16-4dd3-0118-08dc2ca3e00a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 14:55:53.0738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilD59X0o5dhzJHoP6jUp9uLsCkhSou5ThU0OWwTy4h4zvvobv5ZDFv+uQFn0QnE6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233

On Tue, Feb 13, 2024 at 01:08:47PM +0000, Zeng, Xin wrote:
> > > +		ret = -ENODEV;
> > > +		goto err_rel;
> > > +	}
> > > +
> > > +	mdev = qat_vfmig_create(parent, vf_id);
> > > +	if (IS_ERR(mdev)) {
> > > +		ret = PTR_ERR(mdev);
> > > +		goto err_rel;
> > > +	}
> > > +
> > > +	ops = mdev->ops;
> > > +	if (!ops || !ops->init || !ops->cleanup ||
> > > +	    !ops->open || !ops->close ||
> > > +	    !ops->save_state || !ops->load_state ||
> > > +	    !ops->suspend || !ops->resume) {
> > > +		ret = -EIO;
> > > +		dev_err(&parent->dev, "Incomplete device migration ops
> > > structure!");
> > > +		goto err_destroy;
> > > +	}
> > 
> > If all these ops are a must why cant we move the check inside the
> > qat_vfmig_create()?
> > Or rather call them explicitly as suggested by Jason.
> 
> We can do it, but it might make sense to leave the check to the APIs' user
> as some of these ops interfaces might be optional for other QAT variant driver
> in future.

If you have patches already that need ops then you can leave them, but
otherwise they should be removed and added back if you come with
future patches that require another implementation.

Jason

