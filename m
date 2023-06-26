Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8773E0BE
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 15:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjFZNfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 09:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjFZNf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 09:35:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02441B7;
        Mon, 26 Jun 2023 06:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687786523; x=1719322523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4DH85UHNS/l/RAF9dlScf8SC7+IDSTRC/TPMt6oTZtY=;
  b=bWOyElsbCCIdXvqk1IayTC7eISKWQW6B3PVB2n2aVE0wB5ENzewKAt/7
   fnMbhozbJHn9nNJ/FLt4eLT3D5X2/tE4S1Yn4k1eCABc+mNBjohtkxlZY
   rXO3NDNnCdO9g70RsTmYkQ/hWl8H5lXudpibxHbqR50Wdlw9HPBBVt7x7
   qmhv/ufrGzp5NU90usADXW9wYApBQsoOLysns6N20Iwxgl/2UWfX21h6i
   d7J76QBnEzDy2AQAuPcNIGuHfuTG2ZXyWneIUm1DDj2xZ61WYb3xL0zpi
   8pvnNPwzBWBiUI5jRFZD2Eqx3aZSaAmmI2/kKBzkW7DiMFGY2VSl81qYx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="391577895"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="391577895"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 06:35:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="806048842"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="806048842"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jun 2023 06:35:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 06:35:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 06:35:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 06:35:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 06:35:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ihvj4y6gy9cO2/zoWpGvWg5TvSECTRlNiP8BrJjxTH78mF/hSMVeplblrpt2kby3RNJbp2FqNemEO1jG9p9WodeFP+JVg/Gn40pobrJCu3bNGKFgVmYcPwy4nUf8zyi9WR1W26FeVUmpA6sbyO3VWh1mn2YpgfmQeSf63RlRfm3U5Gx7Ftq3nAdwFlp5Bju3gh2Gq4Z1lWySrYuJOeJTFy99jLw9UcSlAraf/E7mpxMHdG17DN5r7O+V9fIo7FRwfzniZLTDJYUXDDjjj4/0HnVnxf2QoKl9CYsbrI9w9W/OKaE8CuGe5vyCIzunKmONKF0hKLz/l94VvZ0LHs22PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhdiud/tZp8owJJQ5G8JSNnC4OoBUBDbrilrT0oQUFY=;
 b=mEVTmNcvzImy8xlP2Jc+7cVCKJ21DWUiKKN6Qece7GBXA2kg47VTw4u2P5vcrSvVfW4Pq/v/5kHPqrW7ukqXSrx6XIze9DQerlT5I/0JcG8xXrLV5fCTBBGFZ4VvdanYNYPYxeKaGAzu8i73LaThNvcW0u2MjhJ/nEOpiGYPI4IHMf1AMjp9UqFNCj3gbeHSnsnIo0bUrzxqub/gx04BWuP4eAeyppsE+hfII/3GSHe7hqbQTvDslVEQBxcK58A5UuHk+2uG90YmjkqQDg1YSBXvQY5Ck1GoSIlmnIxixD05VdAIWZyOq4ejrjRGeErDcmG7SZcTy1EhM77P8GMNow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 13:35:16 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d%3]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 13:35:16 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZlUw0PINbjPidUkeXtdGCTAzTl6+YsS6AgAQ157CAAEl6gIAACkuw
Date:   Mon, 26 Jun 2023 13:35:16 +0000
Message-ID: <DS0PR11MB75291F4581566C7B78DC110CC326A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-19-yi.l.liu@intel.com> <ZJXFEbmY7BOW6QIe@nvidia.com>
 <DS0PR11MB752904E31251E05619A442B9C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZJmK6ensADJS/kms@nvidia.com>
In-Reply-To: <ZJmK6ensADJS/kms@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB4811:EE_
x-ms-office365-filtering-correlation-id: f8d20670-7112-41ae-d185-08db764a2d99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4cTlNoMXOdcuB4omhQ4SYWWjFbi8DBERw+UI5173o+fJ6gOX4UAFEvzIJJnUCmEftJOnjGLbZksI1oO8n+p+kIl6OcqJi9pt5pt9KIkYU5y/47AQnmbz6KEd35V42AW6o/C3dM6477C6WRB5KXVCwxig+UuGB8x1z84/30pJeDV4TovSk3MRysbzVC2jSXeEwaCopf4MqOa6/c+Gi1LI4RE8sGihq/Zlc3QIxuiMLTZVoQidJ/qP28oUp4AGt0VntFwMyiqi7OP549BpBE/HD1M6L6Kr4mrtRm79qOmoNkO8OLx7VJ44FfXNTcUZ1RpdLvdXLlF93CJVrFSJ/wbFOs2IJD4Ob8m8X1yeyv3LridICJLdB1tH9MKr0xSNaZTT4z0Coij1NUFJ+60tJv3T/hWO5zJ4bi2ucCTMuYzf2KQdMkcVN729N7Z+IYlitFSXyOVWcKSI2Y0IP+UH8f4SQ1Kmh5Of1ZORFCZw/rZTGF0GJ61HmEzjoR7TW/2j6OqkK8+41fGAexvJSvjniIeQoCb6hCxmcehw2mxQ8NRDUGR4P+NS/IpbONl5brkbj6q3PI9R0d4sQdvW7hEZUsBI+wfqz3uWVOlHL2LJZzlyR5Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(478600001)(54906003)(7696005)(71200400001)(83380400001)(26005)(186003)(9686003)(6506007)(66446008)(2906002)(5660300002)(7416002)(52536014)(33656002)(38100700002)(122000001)(4326008)(66946007)(55016003)(82960400001)(76116006)(316002)(86362001)(8936002)(8676002)(41300700001)(6916009)(38070700005)(66556008)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XF7jJ5/FqS4q2OkcQBohv4pxcXonat6tEo88d/sXFKJa4f4HeY3oQvJdREb6?=
 =?us-ascii?Q?Fa+gFrrnKN+NgzlPa9rixuUkaYvuVWWoi5qoBJd1v8qZFAn4CApp7V2S6Pcp?=
 =?us-ascii?Q?+sgeHVloehMp3dS2lrx/5+6hDYWWOThkvejcHt4ONTXetfBMGXlag0Rfc0vP?=
 =?us-ascii?Q?zdn+AlY8/+CR87cOt9DyB55tZAt0JR8U43i4wKgGpjfLDOHoi7BmfdcbFnEW?=
 =?us-ascii?Q?n8ezeIZ6OGhl4/CcKquBn787nQ9s6etnQQOb0Ozv0GgS5EM7MgLm92x00GsX?=
 =?us-ascii?Q?aFiGzH7DNzmBMaQaXq5s5s8WoxAxJaWN/lYEnBRmZoUti/uvPpUsriUjQhJF?=
 =?us-ascii?Q?Zkg4AbwROOcjIL0mFOQeUXqh4yUscknF856p/adC7E+2dvs0aHmJzMaDXDhZ?=
 =?us-ascii?Q?9s3IWiK2aG1S2xFCjTcz9NJfjH/kNG/LXtIJPESqFclxAox7i8efiDIJ0Xbj?=
 =?us-ascii?Q?hlH0JGZbnAXzycv+zwQzuNv7phmUEaz1i+yWxsxWcfThlLjKh3JBGVB8Wyjo?=
 =?us-ascii?Q?bBYbs6gFwYkaDuWbLnHNAOl0DyMcWL3IHpudWdoAavEnanIY34W22lxa6GSS?=
 =?us-ascii?Q?qwpDdjTcG5p9JnZzIfKMVlovthhPjXe8HAI4oeS0DJG7g9n4ms0Gb7oNkmNu?=
 =?us-ascii?Q?EZ20q8nwSU/Go90aaWF5GULERt80nHC3YZBWMmZcLhjRROzxVay4Mz4eQulS?=
 =?us-ascii?Q?RnAVCO4MgGcgJVD/pm+jwfLIT24F86jJRPPYuqmPBQAfe0b8I3G0xLA3vEjO?=
 =?us-ascii?Q?LYbK/UoYu/nQ+WIUMjFLETpHn7bXPOL6VQIPzu8THJUfhH97Qo29B5dJo07c?=
 =?us-ascii?Q?PYRY/3nzmZCH5bvt4t98ZmQ6aw2wTGILI4mIpPGbmz2JzZcG59+ykvTAZtKq?=
 =?us-ascii?Q?e0hdLz5OBX9w5aOyeuI5JGDDbWc9JiRkYhaW+oPNkJtG6SR7uSsI+AO+Wj5G?=
 =?us-ascii?Q?0pfeXzJUMFrUtHBJoYV5J8WsX7+mG3a4Pz8ZmAxq+Uk5a/OPjstIeWX/9+In?=
 =?us-ascii?Q?3dif0WROLEruwvq7HLgl46iFiQg9YoRNs3xG4UpsnAEqNqiGxZM2Oc4veudv?=
 =?us-ascii?Q?e7IXpNfM6BNk2rfNK7746W6w8sGoOe7Gn0KxBXnEYEtmPpudXv2y+z2warNs?=
 =?us-ascii?Q?jggqaKJCL2tMPFR/8jt5PMrMhMY32EuUMAEKNGQQrzh5QeVDe+aKowU6GZ1x?=
 =?us-ascii?Q?7TUIgyehbilSA3bwNSkWd3N7iGVU2PeLp11doJek4P6c4NA3CGamCx/bPqEr?=
 =?us-ascii?Q?oYdE2Biv36VvtRE++hLxz8pcYq5QC2y544o+Lpz9dCdRjq8BwQf+XMQXR5Dt?=
 =?us-ascii?Q?rwumEvh3dWFciFD5uiTptPCnN/PZMAuZ4bO1lE41BjhA//PgHu+JyAricc4k?=
 =?us-ascii?Q?qZUWSZFke7mJ6a28p1OTXzAXU3sN4Qt4SD8RSrrUeX5AFOVHsnnWyrbTWRls?=
 =?us-ascii?Q?bPVl4fQKKL+UB9f70dZnu21Y4KrLDOZ0BOqYlwgHhwiwkQdXLD8qKFcK1HD9?=
 =?us-ascii?Q?iLWZZHipd9IqclAAwF9h6B+sl8ZRI/5OQ0N5w1KN9VZtaGsOyj0V5oTK2zW6?=
 =?us-ascii?Q?K44l8svJszKO9ZTcyAz8IxA4CTaGjocDq1qxfkTG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d20670-7112-41ae-d185-08db764a2d99
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 13:35:16.7504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V1l2p7bcP7qpM3kgqUuWTDbvZPTPjN/SSoo6Qc0H5ZN4+7von36gpcYgmVst37hvwFoonOjzyWu7O5LQZ1Ha3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, June 26, 2023 8:56 PM
>=20
> On Mon, Jun 26, 2023 at 08:34:26AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, June 24, 2023 12:15 AM
> >
> > > >  }
> > > >
> > > > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > > > +{
> > > > +	spin_lock(&df->kvm_ref_lock);
> > > > +	if (df->kvm)
> > > > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > > > +	spin_unlock(&df->kvm_ref_lock);
> > > > +}
> > >
> > > I'm surprised symbol_get() can be called from a spinlock, but it sure
> > > looks like it can..
> > >
> > > Also moving the if kvm is null test into _vfio_device_get_kvm_safe()
> > > will save a few lines.
> > >
> > > Also shouldn't be called _vfio_device...
> >
> > Ah, any suggestion on the naming? How about vfio_device_get_kvm_safe_lo=
cked()?
>=20
> I thought you were using _df_ now for these functions?
>=20

I see. Your point is passing df to _vfio_device_get_kvm_safe(() and
test the df->kvm within it.  Hence rename it to be _df_. I think group
path should be ok with this change as well. Let me make it.

Regards,
Yi Liu
