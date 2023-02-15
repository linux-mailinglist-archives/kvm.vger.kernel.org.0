Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD719697773
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 08:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjBOHhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 02:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBOHhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 02:37:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16112C644;
        Tue, 14 Feb 2023 23:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676446626; x=1707982626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jNBVCU+rQvXCfljicYsl80j97kCntDMjk5v2OqVnyc4=;
  b=YrPnGR2AyLnw/3TE4FQQPAs7S+GyH4Qs0E1XW6lKZETzRQawhbsZAc19
   wKcMndH1CDsIb/BuJ662HLYRFqqxlPGn9SOKO0QZsYP5J+wY8n+jlJpyR
   CKZ+vSjTT0NulGvEQiqmbMKlOC4Fr94YkiKOL5WeC1uu5bNE0cuEbDPio
   pQ3DyEtiq47I1HornxVSCuidWzVIPvwWGKDvI4dz7/ZQ9VLTdtg4uHhxS
   RP/gpELgvPBUzqWrA75tmIq89YUfAob3YsO7tTB9mtKQtYqJC36gjB71q
   RCmLzOjgJWaX4mzYIgpkIYHWFBTR2NNQfoWtrUwZvMjEUyi6UpbtQsWeK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329996629"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="329996629"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 23:37:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619331134"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="619331134"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 23:37:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 23:37:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 23:37:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 23:37:04 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 23:37:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CilZpzXDqzraN0PiNjZ1NHSvqwv78ujWrekDdo5W4Tc2Htr1NEnCp1ulTQjGkxd+nc/kfFPRnvrC2aZa0aAMYJk/Xe/RcxhajOTPre4I99XmhKNFjN4kOp/qitIsTaYX0WOPNsKb7F786UlABxWOJRh9EJK+qYI0T9n+RrtQURIFzbPLyDM50niedrsiaVg+GalxHZf3bzcUg2Lh2fQ83/9BzYMNYOlbNwKhnB/2nDml+Ln3BzbNoOrkzysafKY3kkXqG9IBHaNQO6hthUz2uuB6fRM65DKFUoaMyJfvxaKOVSKh3D+ZZdPgUqpRzz5PxEyrping6eiIn5132w0tJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WozAEBvzE6Up1mvOntKXdkob8aAP7YfGEoPD5Mb46eQ=;
 b=QYF39oqcuzyX/25HMBl7/5LvV64YnRXeoByqCId51IxRZjyx0gW5sio2vrcMpKru1jYQ3WFgkPX/UgcnceKM4Vk80RCw5fKjfKzywst0Q5SIbe4kfch8n8y7gf4z0oS82f68Oq9OrhwiZyE/BqVAmO1tUfPe20swfKLncFCutBDiOFhRIid8dVM7enHgVnrWEZaZFGajnfibeTNK2TWCShnVj+/qdgtfZ5sodoPf+5VAvRsvZsFWx7p3KVF63JvHjYGZE485vKlszD3p/6VWVOAT1uerF+bVo5w8eoW9lkNkVQAYWibfG3BY5XTDf4sPDM0OoSI/TwwrW+Drj0U+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB7538.namprd11.prod.outlook.com (2603:10b6:806:32b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 07:37:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 07:37:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZP73PxotwwywX40uQF9TRO5UlQq7PB0WAgAAQc4CAAIag8A==
Date:   Wed, 15 Feb 2023 07:37:03 +0000
Message-ID: <DS0PR11MB75290E004D522E4D5A8DFA12C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-6-yi.l.liu@intel.com>
 <20230214152627.3a399523.alex.williamson@redhat.com>
 <Y+wYX34sPvPQmGSr@nvidia.com>
In-Reply-To: <Y+wYX34sPvPQmGSr@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB7538:EE_
x-ms-office365-filtering-correlation-id: c036e37c-e3be-44fd-5c3e-08db0f276e77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UNrU2VPQn6K4RyN03oKM9BloBtjnC4fgZwhLT3kJt2UomPI6v6wTxXueZp6IJjOoEwh/M/rkervrK1wWYja+xPt1C14ZzewfJq5K9qHTohKoEx4nRMSYzF2FlYPZma5I1TQC67XGfjT9sK2OnrDBeSfMocmykureAzGLSRKMEKaVgAIQP7z2YcB/WMNinF9CMgu+ojoP22mZgN60LQTh0fZU9Q4rQRIfqi43h3yL3/8xWntyt4TVg4ZTW+Eu09LrzZbj0Tw9/DZRJKGzD5lFDjRQuhnF3YeN+4ZCY93rDIGjz5sp+78ELKxTW72GYDjv8VXDC8CZ1tAkfqLEeDr+RX2ugg3LczpLOs6nbam7gagp2GZvB7ruu7TgDKftDYKGGaHIPAr2CyVSkcFoIeqfb8SynusR1ULoY28akV2/tGiH++4JyD6z5bbcjdI58uGI1brthZg7RKrGZbOkJwAIlxngHnsnZrkxqYCpQKtuLGXEMTU966ITTwmxZoseLPz0zoT1OWDA4jeNfNx0SYTx7Rnh/227E7K3OLPCC0NEvToFvmZ2R9sJMCANWUpR0qat9sJZu9u9T8YyPczlOdZ7fVTqZJQbXEzjkez1s6znqjbSGZScjDVIB1Gg5wMN/1eaDv+YOmTX85dbQa7BXdbWvJmIM8etXCImn+7sN3gYvPdX6qsqCtKxdx6MHlXlSujS/RudF+Lq6OhNKBUdfDku0BGDh4pchi0fOxDyW5S1MCM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199018)(7696005)(71200400001)(2906002)(33656002)(83380400001)(55016003)(82960400001)(86362001)(38070700005)(122000001)(478600001)(26005)(38100700002)(186003)(9686003)(41300700001)(52536014)(8936002)(76116006)(110136005)(54906003)(66446008)(66946007)(316002)(66556008)(66476007)(4326008)(64756008)(8676002)(6506007)(7416002)(5660300002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+rR6ot0IcNiTMYljfc/9PfUIUkxpzfJszghyURbtUn58RNxbwaj0n43SCP52?=
 =?us-ascii?Q?/zPzxnYjtAT45pnuwJI7VSva8kK0S0g6y9rU4Ft5CxfS58AxL6EN19CquR/s?=
 =?us-ascii?Q?G2w6oAEz7B1ERdeSk5b5PekDiFjOARnKdUAJrmjDejCN+peocOkaK9YmVgav?=
 =?us-ascii?Q?QFekuU2uxEpmyf45IwpcSfdwhnROhyOiUb3nevcnjiqdlZyfQmCbTYZqyJiP?=
 =?us-ascii?Q?t7xUbhjdwY7WaAtUvcvJm7pXTVgRXGvUEQ14hYNYLU+ZhK3ThZ2U7Cd6yT/J?=
 =?us-ascii?Q?kDO08onofCUap2eq0zzIfUMWKIn3UZBXsVX5WvSEfm8k7noRNGGSF/4C206T?=
 =?us-ascii?Q?F4Z2JT/EarEqxaJmyD+PZpXM2jc1VZaigXy92BFfPOYs1nEYs+ciZcxhgc30?=
 =?us-ascii?Q?IGj6TvYpUuC7DZmB3tlWaV6In8HnQovhDmTlwHqFNridGW1MUiqWHz7D3GIj?=
 =?us-ascii?Q?pREhU5PIitNdFWpgq8iJMTrcOwJaCPB5hCvnRRkO797YVg+P1NNpSXEkDnSA?=
 =?us-ascii?Q?tg3hhzs/xObUyIgXaIWf4AXw+lKN9vER+CYnVYWRhyB1FPmzfNsow7Y8/xsq?=
 =?us-ascii?Q?OiWlKXhhcXkl6RSr/5jH8nBIRIxGZz1jT8iOplIhNlnPD34d8WWSB5FlU4jo?=
 =?us-ascii?Q?2RSZV22neeCIMxZ1f7jn2Ey8k2yMN2/6TGUluAnagQ7VqOMiV0/goGJh15qM?=
 =?us-ascii?Q?hrgMfxE3ZG5a8nAWp4K6Yfz3O9gFIXKZk4owL/ra+J1qzGm5DfydMjIQDi07?=
 =?us-ascii?Q?5lWe2WKjzVeywcfbPgB4EQ3vs4bpqpTVf7WljV560K6pd+jMDSf4JQcoWd5q?=
 =?us-ascii?Q?gQ9ujxhvtA82d9SOSI+yi2mz/vVTlWi5dIZ8iKmUMSpiCplHh+kUVie5AQux?=
 =?us-ascii?Q?d7Z8c6nC28PGEtLsKHXUQjigBqrwPDp5sZE5VAOiX1n9KunEG+78J9ag5ZVr?=
 =?us-ascii?Q?xSQJM1rFhGv60O8wjoAmlM+JIqQ7d9AntzRbGeXRcZE+8AyPzh5mEsJfeZCE?=
 =?us-ascii?Q?bVYA6xLsxpV1K4w1Qj8qz8y7UaD1vpARq6RYYLiwq6+JGsX9P7ZJlQxCMSiO?=
 =?us-ascii?Q?VO3SexBhBHMNUg4NW0D3/C9PiYlz+Esvkcg3hgRbGKWNZsT9mC1EyBjVlfCD?=
 =?us-ascii?Q?xe42jvZVqUv4aEOjV6l7sYsbgxz0wcm9MT19M1+gmdrh7KNENJwqV4RBK47g?=
 =?us-ascii?Q?in7GJRiDYrneWrNcH7I5XJzah90fenmeTEle9EuP9tmjwzKU1Fywbmclp5//?=
 =?us-ascii?Q?sKcLOWm4mM2734rKUXzqZ6B/u3SGAW/bDmwrpTw/BvcBrIX1O0NRmkWZ6x30?=
 =?us-ascii?Q?r323fXi3gepw8HgSM+DwBQhxv/R3VVEKq0d7kYVeQrmK4tCY5vYcC0nL8E3G?=
 =?us-ascii?Q?w28jm/UWjCNNEuRPvSqe91CW1HYJvClMH8Xuz9puu0HbI1ZDsskJ7ldu88la?=
 =?us-ascii?Q?GDjRrwROK83GOgLreVjtfZHPZMxp9UrB6QsAlgrumGr8JNoXZxKe4tkRXEkc?=
 =?us-ascii?Q?XFJn9RfzoLytZx9iOMkapVhuCEhWFLE4FA/INCHEEZ2XXar8B3aSHXqho5yB?=
 =?us-ascii?Q?AUjnsA8GYw4ytMAhts1Vj+GPUg6EmdNuxxlkeQ7b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c036e37c-e3be-44fd-5c3e-08db0f276e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 07:37:03.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8FKMBguKTsYV610qgBpzSxvHrEdT4y69cM1++dA3GdE8BTrRqWjVFLZagou7We8jduK89kMbM6oewLd9og6gMw==
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 15, 2023 7:25 AM
>=20
> On Tue, Feb 14, 2023 at 03:26:27PM -0700, Alex Williamson wrote:
> > > index 857d6ba349e1..d869913baafd 100644
> > > --- a/virt/kvm/vfio.c
> > > +++ b/virt/kvm/vfio.c
> > > @@ -286,18 +286,18 @@ static int kvm_vfio_set_file(struct kvm_device
> *dev, long attr,
> > >  	int32_t fd;
> > >
> > >  	switch (attr) {
> > > -	case KVM_DEV_VFIO_GROUP_ADD:
> > > +	case KVM_DEV_VFIO_FILE_ADD:
> > >  		if (get_user(fd, argp))
> > >  			return -EFAULT;
> > >  		return kvm_vfio_file_add(dev, fd);
> > >
> > > -	case KVM_DEV_VFIO_GROUP_DEL:
> > > +	case KVM_DEV_VFIO_FILE_DEL:
> > >  		if (get_user(fd, argp))
> > >  			return -EFAULT;
> > >  		return kvm_vfio_file_del(dev, fd);
> > >
> > >  #ifdef CONFIG_SPAPR_TCE_IOMMU
> > > -	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> > > +	case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
> > >  		return kvm_vfio_file_set_spapr_tce(dev, arg);
> >
> > I don't see that the SPAPR code is so easily fungible to a device
> > file descriptor.  The kvm_vfio_spapr_tce data structure includes a
> > groupfd, which is required to match a groupfd on the file_list.  So
> > a SPAPR user cannot pass a cdev via FILE_ADD if they intend to use
> > this TCE code.
>=20
> SPAPR cannot use cdev at all, cdev mode only works with iommufd.
>=20
> So with my other remark about blocking unbound cdevs, in SPAPR mode
> you can never open a cdev and make it bound thus
> kvm_vfio_file_iommu_group() and others will return NULL always for
> cdev.
>=20
> Thus AFAICT this is all fine.
>=20
> Yi, you should also add some kconfig stuff to ensure that SPAPR always
> has the group interface compiled in.

Ok. I can make VFIO to select VFIO_GROUP for SPAPR.

Regards,
Yi Liu
