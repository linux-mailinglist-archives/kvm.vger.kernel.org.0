Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2375C697770
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 08:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbjBOHhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 02:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjBOHhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 02:37:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A18328D31;
        Tue, 14 Feb 2023 23:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676446625; x=1707982625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=694MJFITP77qYeBWSMQkeBxvD7KlKc26JyBXaDSJHoY=;
  b=Y+x1okUrwDghLI4IgTN/Wwb0qkJ1ZEzhvK+OChozJRA2JYDpQVDjJHzQ
   PinqnVqYXqjJfd8EZscIeLai8drkHS2BKSoI72ecwnq4rCAhC+Lje4azq
   lg5h7yowL+FJ5vZJlF685Vd4onDIZZdy9w9sLLHk2gGgnmaBcjTTbsebr
   uA/AaQW7PHLtxKK3OHQGU8BN2s3E/mwLnwPKivbxwGxKEvy5U1mJ7h/Rg
   k24Ec/+qeXWOf10fgxw0/lr9hKopFngE2yNkujysJscauce6n/mtUlkOb
   CDWcFxH+iHN00ijCH0BO3nVm7AacgDWr+um/lTgH9QPMO9S3W6A/kp/5i
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329996616"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="329996616"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 23:37:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619331123"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="619331123"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 23:37:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 23:37:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 23:37:02 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 23:37:02 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 23:37:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id4t89QaoSIMNJnnk6zAJZDdh6zX54SLSgLll2PucAqydGURBDQJ4mPTuWuvdc+6RqwJS29eKJ+w/qwOKw5cbFS5NWO+xhdbd6e18Lmjac5537Q3aavqMHn/vqUllZbFwktUWqO92rKIxN+tOcgtG6Lm+FEVx0CtwpayshpNbzS2+BPz8ZbiM8Lv19agJR+xZ4OCI8sD1UHEcIO1UMTUVmOczdjNTSp1R7SIVtY0lbgru5oEzOkMeFVf8eBK17rSX83TIQuPmmIc2/RjMJ6NzncR4agWjCgWGN9C8ErxKlkoMiU/am81Un4nqOamyKiKIlR28shm5Q5TxHffc2/wsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+T8omRWcWqeYpL9w99UqjWV9Wx4TydSAkbUxLJweGNo=;
 b=LjfeFd38fVkJ4CdPV/yWQM+F0U8cCr/8jQhHICcucvkJgHTgBdpOlOHgjDyKKec+p5hS1vlbUlTK1/gIqBj2q3yxV+FBaVt/M0Dcj/dupeSHjgSZxVA+3QgkPBu2go9YptTOAMd3vCkNhd1OiD3eCcTRYWN+xKMb8OuEMz/IKmCxcx+Khn0idgUKNYUQn1T02zWlGIB/U5u6tXnKvNP5ShlwKfosrBJG/udHcLyjiquPtuTydvjy0rknFayB21t2eE4Rpg36iUOLc6jK65zkDa8uEvix1aSj2/UDHYbxQUKb+i8EqNtS0rWUqumjWWJvxCdJCNm5unSh0ftIVgKmjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB7538.namprd11.prod.outlook.com (2603:10b6:806:32b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 07:37:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 07:37:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: RE: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Topic: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Index: AQHZP73TMP7ZzqInoUK0sXtp8iwKVK7PG6oAgAAoogCAAEV70A==
Date:   Wed, 15 Feb 2023 07:37:00 +0000
Message-ID: <DS0PR11MB7529442C50C91FA407A5D50EC3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
 <Y+wbrgqt7+045A6o@yzhao56-desk.sh.intel.com>
 <BN9PR11MB527610103F75E77E8D5DF9998CA39@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527610103F75E77E8D5DF9998CA39@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB7538:EE_
x-ms-office365-filtering-correlation-id: 79247fb8-ede0-4351-b9dd-08db0f276c8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rccHbXmv7KMbEqPKY6r1zUflTKfrhx6CdjaCn5atOzZBSXmpB3GzhxRB4vFp7aHoApVIcF9f/AKws8yCa6NqZ5/58MsB5+Kten+Jg8wYVNjL5ErcQ+W60ulebXPNvTFFGZMMs/tRmnrqRYYAK21OlODizJf6JH+yZPGHG4JHJyNVXXa313I3JWPliad5wlLhWK/3SqNGKIpUEUy3nT/FqjsMIG+W7FIkk9t5ZRhuuFe0RMCB4bRHXauQGD8BT/Dip+yo0lCFlHlDLXNmHWdrLc6C4W9Y9xX52GG1ejhJhM3DIswe4KCk+Zwi5LCG4GiRcHUmjlNRTA2KqQ/K/u+Wr3ahWPeaS/eq0cz7dMySiHQWcROBN2rVsTtEjj8B0A1N+rkcbSu+BiesLqyXj9OtCyO6oUmeG5vEi+IXkh+E50+KoNmj7YwOAhDVvqq8v5y3cfSqqLM9i230MzL7ecCw2hyJmu2OUFW2szWfU2J9zCFGZ86PuN3io9EUJ/GTYU4Pczn3yGU5oH2MOYeZ2YgSz6Lf8ZZUVIsC5aX+/N/rkHhPdrlIgZqgKrorTR5Hius9dVa71AB9nFMi34q6sa6rb0/6Tu3995jNpZPa1u0z1e0htRYaloxNGx8kgYPfY1MYEjDvE+ZT7lNO7xv5VDQ1KtVxPkJQZQwdZ6+v1/dIwOUkz30hTr5GTlI6mdXYUhXEIiyImMIiAqFh5Oawty0tRS3fRkH3XpaZvlmjGIJBNYA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199018)(7696005)(71200400001)(2906002)(33656002)(83380400001)(55016003)(82960400001)(86362001)(38070700005)(122000001)(478600001)(26005)(38100700002)(186003)(9686003)(41300700001)(52536014)(8936002)(76116006)(110136005)(54906003)(6636002)(66446008)(66946007)(316002)(66556008)(66476007)(4326008)(64756008)(8676002)(6506007)(7416002)(5660300002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?svC3UF6rJIic+PGogZRl2Ha5o1WtmvHboF0icTJqNZJDZWdqWGJotK3x4iys?=
 =?us-ascii?Q?ObkUsz+y/x1A/crgq10HkTLjquNLM4YLDENyxK7eE76v8B2rP2/Ctdhp3stR?=
 =?us-ascii?Q?rWAPvrHI2wL91ROz9zAqedVg1FOUjmhFXx5vw/dW7aXVXT91RACBmXCku+YW?=
 =?us-ascii?Q?GgBkuqAYIO5uWBZH5rZ8zRllmbr0o4TmOSHuNjbr0nibvkN4USCdlI0a+XJn?=
 =?us-ascii?Q?hgUTwRGHtt7DewRym35w8BgmgTP2nmxQMOexR6sXtDWtx9dqhl23amoVqOwl?=
 =?us-ascii?Q?hEFCVFGoRD58/fHd4dx5GxmsxqRiSQbupjgplCbIaHlXo/oRekAYom8B3w9v?=
 =?us-ascii?Q?4wZcx7wQ03dtqSpVMOwuoEiaz3fzcFAI/wdMkRPEneX0p2eqdm7jGKSxFz47?=
 =?us-ascii?Q?MZLHxn1RR4tL4qvJJerldN9J1G+xdBtJZfxnWSFK1f+aQ/RZpKtakHDNUqIK?=
 =?us-ascii?Q?7P3wEcp/zz+8LxqvoD1fecLcDz+PpJ+ol2S5sVFV27Au/uobF5Zobg29MkhY?=
 =?us-ascii?Q?CYsqAO6koi8Xk1mW2DBib7MkpK/kKeQbeoaiW3nw40u7ZN6cyTZ52bY9WC4T?=
 =?us-ascii?Q?PMqlB8s5Z6yK64jpzZjtvYwmelVCYqDkWaiIfyitnxE6msU+da4rDqhU3hsV?=
 =?us-ascii?Q?sBpgDXeyDhPCucGlpMXtGtV+rJ9phNbamDRfKerTLzyR57bjUDKfymDlsBRo?=
 =?us-ascii?Q?KvYPlIk8Fi2MnFNJNNFAuu9aCoY46NHiFltPAT0uGjn+mu6T/+F6zFaDRKH1?=
 =?us-ascii?Q?YoyHNL/DGgAPcE7FuO/qxkk/3u28yDjdERbwJXDE+AKca1jDna6xTEeZtHaS?=
 =?us-ascii?Q?QuN4V2SSAMnDyxm2TB7fXhU8w4MzCeA9Ne6IJpHBkrNzPTOEgyhknu+vKx/H?=
 =?us-ascii?Q?GT68AAKCP9phxctpnErEc9LpKjWhTYa+YMrhxskT+o5I1+x5xuVRn5TzxOSR?=
 =?us-ascii?Q?qH6C5nxkQfB55QnVQysSvdoOCH3pHnJS5bdyu7G+i0zTSwr85baU4ljcHKed?=
 =?us-ascii?Q?fmpqpJv0RL6P3cfXKrT6bHgo866Cwg9Q1IrHOCKE6L9D75vZfxygi71BJ3P5?=
 =?us-ascii?Q?aXct7oMyoRzB0HU9eZ7kAPFI6nx+mM+6KgU/Wz1Wc8ZsmBjPS+qY64FQq7br?=
 =?us-ascii?Q?6gSLBhwZdeHDfILoMIM4t7hvs8w5+c5tFrjBtb5aT0GhpG4WKX3TRCh/DWn1?=
 =?us-ascii?Q?FdnasVj5a3CSEty722ReZit+wAJGmL3PXEBFHiBo4cCNGab79rVAk4dNaI6o?=
 =?us-ascii?Q?XAus7jzPbvabF62mIQkdp07mEJz+ie5GWJibTSBnMjiu0UkunYJnChCtapok?=
 =?us-ascii?Q?DU/xWQig5GHjLIviPYDI25hEOIPwDxDIIz3KpMzm5YtFwH4cT8/zrSL34B8V?=
 =?us-ascii?Q?uV/un5jzgagry4DCRNDE0JpQEFaiEUcVu8xLk3KNDdWSVZ5H3Gw57YWIwyNE?=
 =?us-ascii?Q?4chcnFpKs1ZFVl3Nb+QdZLLjlDip5HcfybNZQm9ZVLrd14GoeFTNlvNJIanL?=
 =?us-ascii?Q?Nghp/SBuW2FE0HfzJRBZUiAaW3HUBD6RAmSsJmE57s1yDC/UfYFFTOyqgWnn?=
 =?us-ascii?Q?8ESJQG4dM/LF0SfKRAAzGPya0ak+P+izz1idNRMw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79247fb8-ede0-4351-b9dd-08db0f276c8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 07:37:00.1800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y9F+4+/rmMnyAR+fkYfVPOiH90ozLNDduR2ulB3vxkYjTzyKZlkTYYQ1itY/mCUxfK3gYNVDJLZNC0NzFDB7kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7538
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, February 15, 2023 10:05 AM
>=20
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Wednesday, February 15, 2023 7:39 AM
> >
> > On Mon, Feb 13, 2023 at 07:13:47AM -0800, Yi Liu wrote:
> > ...
> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    unsigned long arg)
> > > +{
> > > +	struct vfio_device *device =3D df->device;
> > > +	struct vfio_device_bind_iommufd bind;
> > > +	struct iommufd_ctx *iommufd =3D NULL;
> > > +	struct fd f;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > > +
> > > +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (bind.argsz < minsz || bind.flags)
> > > +		return -EINVAL;
> > > +
> > > +	if (!device->ops->bind_iommufd)
> > > +		return -ENODEV;
> > > +
> > > +	ret =3D vfio_device_claim_group(device);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&device->dev_set->lock);
> > > +	/*
> > > +	 * If already been bound to an iommufd, or already set noiommu
> > > +	 * then fail it.
> > > +	 */
> > > +	if (df->iommufd || df->noiommu) {
> > > +		ret =3D -EINVAL;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	/* iommufd < 0 means noiommu mode */
> > > +	if (bind.iommufd < 0) {
> > > +		if (!capable(CAP_SYS_RAWIO)) {
> > > +			ret =3D -EPERM;
> > > +			goto out_unlock;
> > > +		}
> > > +		df->noiommu =3D true;
> > > +	} else {
> > > +		f =3D fdget(bind.iommufd);
> > > +		if (!f.file) {
> > > +			ret =3D -EBADF;
> > > +			goto out_unlock;
> > > +		}
> > > +		iommufd =3D iommufd_ctx_from_file(f.file);
> > > +		if (IS_ERR(iommufd)) {
> > > +			ret =3D PTR_ERR(iommufd);
> > > +			goto out_put_file;
> > > +		}
> > > +	}
> > > +
> > > +	/*
> > > +	 * Before the device open, get the KVM pointer currently
> > > +	 * associated with the device file (if there is) and obtain a
> > > +	 * reference. This reference is held until device closed. Save
> > > +	 * the pointer in the device for use by drivers.
> > > +	 */
> > > +	vfio_device_get_kvm_safe(df);
> > > +
> > > +	df->iommufd =3D iommufd;
> > > +	ret =3D vfio_device_open(df, &bind.out_devid, NULL);
> > > +	if (ret)
> > > +		goto out_put_kvm;
> > > +
> > > +	ret =3D copy_to_user((void __user *)arg +
> > > +			   offsetofend(struct vfio_device_bind_iommufd,
> > iommufd),
> > > +			   &bind.out_devid,
> > > +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> > > +	if (ret)
> > > +		goto out_close_device;
> > > +
> > > +	if (iommufd)
> > > +		fdput(f);
> > > +	else if (df->noiommu)
> > > +		dev_warn(device->dev, "vfio-noiommu device used by user
> "
> > > +			 "(%s:%d)\n", current->comm,
> task_pid_nr(current));
> >
> > IMHO, the "smp_store_release(&df->access_granted, true);" in patch 7
> > should be moved to here when bind is indeed successful.
> >
>=20
> yes. in that case patch7 should put release in vfio_device_group_open()
> and then add a new release here.

Right. This needs to be set in the caller instead of the vfio_device_open()=
.
Done in the latest branch on github.

Regards,
Yi Liu
